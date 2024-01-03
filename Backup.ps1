cd $PSScriptRoot;

$ExportPath = "F:\HamNet\";
$FullBackup = $false;

if ($(Get-Date).Day -eq 1)
{
    $FullBackup = $true;
}

function Create-FullBackup($Device)
{
    Write-Host "Backup: $($Device.DeviceName)";
    $filename = "$($Device.DeviceName)_$((Get-Date).ToString("yyyy-MM-dd"))";
    
    echo "open sftp://$($Device.Username):$($Device.Password)@$($Device.IP) -hostkey=`"$($Device.Hostkey)`"" > Get-Files.txt
    echo "get /backup.backup $($ExportPath)$($filename).backup -neweronly" >> Get-Files.txt
    echo "get /backup.rsc $($ExportPath)$($filename).rsc -neweronly" >> Get-Files.txt
    echo "get /*.key $($ExportPath)$($filename).key -neweronly" >> Get-Files.txt
    echo "close" >> Get-Files.txt
    echo "exit" >> Get-Files.txt

    .\plink.exe -ssh "$($Device.Username)@$($Device.IP)" -pw $($Device.Password) -batch -noagent -hostkey $($Device.plinkHostkey) "export file=backup";
    .\plink.exe -ssh "$($Device.Username)@$($Device.IP)" -pw $($Device.Password) -batch -noagent -hostkey $($Device.plinkHostkey) "/system backup save name=backup";
    .\plink.exe -ssh "$($Device.Username)@$($Device.IP)" -pw $($Device.Password) -batch -noagent -hostkey $($Device.plinkHostkey) "/system license output";
    Start-Sleep -Seconds 5;

    & 'C:\Program Files (x86)\WinSCP\WinSCP.com' /ini=nul /script=Get-Files.txt

    .\plink.exe -ssh "$($Device.Username)@$($Device.IP)" -pw $($Device.Password) -batch -noagent -hostkey $($Device.plinkHostkey) "/file remove backup.rsc";
    .\plink.exe -ssh "$($Device.Username)@$($Device.IP)" -pw $($Device.Password) -batch -noagent -hostkey $($Device.plinkHostkey) "/file remove backup.backup";
}

function Create-Backup($Device)
{
    Write-Host "Backup: $($Device.DeviceName)";
    $filename = "$($Device.DeviceName)_$((Get-Date).ToString("yyyy-MM-dd"))";

    .\plink.exe -ssh "$($Device.Username)@$($Device.IP)" -pw $($Device.Password) -batch -noagent -hostkey $($Device.plinkHostkey) "export" > "$($ExportPath)$($filename).rsc";
}

$Devices = Import-Csv ".\Devices.csv" -Delimiter ";";

foreach ($Device in $Devices)
{
    if ($FullBackup)
    {
        Create-FullBackup -Device $Device;
    }
    else
    {
        Create-Backup -Device $Device;
    }
}

$Ordner = Get-ChildItem -Path $ExportPath;
foreach ($Datei in $Ordner)
{
    if ($Datei.CreationTime -lt $(Get-Date).AddDays(-14))
    {
		Write-Host "Remove $($Datei.FullName)";
        Remove-Item $Datei.FullName -Recurse -Force;
    }
}