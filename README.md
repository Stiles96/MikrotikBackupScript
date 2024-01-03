# MikrotikBackupScript

## Add Devices
To add the devices to the list, you need to start a connection with WinSCP. In the connection you can export the Fingerprints. WinSCP needs the SHA256 Key and Plink the MD5. Add the "=" to the SHA Fingerprint. You can copy both by the link label in the promt:

![WinSCP Fingerprints](https://github.com/Stiles96/MikrotikBackupScript/assets/51234422/af9a0499-fae1-4593-a499-825da5c47c48)

```PowerShell
$Devices += [MikrotikDevice]::new("<IP-Address>", "<DeviceName>", "<Fingerprint SHA256 for WinSCP>=", "<Fingerprint MD5 for PLink>");
```

I use the system identity from the device itself for the device name. The device name is used in the backup file name.

![System Identity](https://github.com/Stiles96/MikrotikBackupScript/assets/51234422/ac8f0407-1eca-4b84-911c-94b318b817d2)
