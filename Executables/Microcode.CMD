@echo off
cd C:\Windows\System32
takeown /f "mcupdate_AuthenticAMD.dll"
icacls "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /grant Administrators:F
ren mcupdate_AuthenticAMD.dll mcupdate_AuthenticAMD.old
takeown /f "mcupdate_GenuineIntel.dll"
icacls "C:\Windows\System32\mcupdate_GenuineIntel.dll" /grant Administrators:F
ren mcupdate_GenuineIntel.dll mcupdate_GenuineIntel.old
