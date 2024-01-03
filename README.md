# MikrotikBackupScript

## Add Devices
To add the devices to the list, you need to start a connection with WinSCP. In the connection you can export the Fingerprints. WinSCP needs the SHA256 Key and Plink the MD5. Add the "=" to the SHA Fingerprint. You can copy both by the link label in the promt:

![grafik](https://github.com/Stiles96/MikrotikBackupScript/assets/51234422/6d5ae90e-8457-4dca-b90e-9bcaf09438c3)

Copy the Devices.csv.examlpe to Devices.csv and add your devices.


```
IP;DeviceName;Hostkey;plinkHostkey;Username;Password
44.149.19.113;DeviceIdentiy;ssh-rsa 2048 HPKJ2oICnzyjTo3UCAgpYPcL5w/9C4P6tyPuMb29L2E=;ssh-rsa 2048 7b:2b:2e:66:57:38:91:b8:90:d8:f2:d6:23:3e:40:a5;admin;password
```


I use the system identity from the device itself for the device name. The device name is used in the backup file name.

![grafik](https://github.com/Stiles96/MikrotikBackupScript/assets/51234422/fc2efd0e-99ef-455b-8bcc-1aaef22de567)

## Delete old files
The script automatically delete old backup files. Default is 14 days old files. You can chnage it in the script:
```powershell
$Ordner = Get-ChildItem -Path $ExportPath;
foreach ($Datei in $Ordner)
{
    # Change it here
    if ($Datei.CreationTime -lt $(Get-Date).AddDays(-14))
    {
		Write-Host "Remove $($Datei.FullName)";
        Remove-Item $Datei.FullName -Recurse -Force;
    }
}
```

## Run the scipt
You need to download plink.exe (https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) and store it in the same directory.

Change the path to your environment.
```batch
powershell.exe -file ".\Backup.sh"
```
