@echo off
curl -L -o C:\Windows\SetTimerResolution.exe https://github.com/amitxv/TimerResolution/releases/download/SetTimerResolution-v0.1.4/SetTimerResolution.exe
Reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "TimerResolution" /t REG_SZ /d "C:\Windows\SetTimerResolution.exe --resolution 5067 --no-console" 
ver | findstr /i "10\.0\.[0-1][0-9][0-9][0-9][0-9]*" > nul
if %errorlevel% equ 0 (
    Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t Reg_DWORD /d "1" /f 
    Reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t Reg_DWORD /d "2" /f 
    Reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t Reg_DWORD /d "0" /f 
    Reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "TimerResolution" /f
    del /q "C:\Windows\SetTimerResolution.exe" 
exit