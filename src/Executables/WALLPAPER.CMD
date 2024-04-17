@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
rmdir /s /q "%windir%\Web"
robocopy "Web" "%windir%\Web" /E /IM /IT /NP > nul
mkdir C:\PostInstall
robocopy "PostInstall" "C:\PostInstall" /E /IM /IT /NP
copy "PostInstall.Ink" "%USERPROFILE%\Desktop"
for /d %%x in ("!ProgramData!\Microsoft\Windows\SystemData\*") do (
	for /d %%y in ("%%x\ReadOnly\LockScreen_*") do (
		rd /s /q "%%y" 
	)
)
for /f "tokens=2 delims==," %%a in ('whoami /user /fo csv ^| findstr /r "[0-9]*-[0-9]*-[0-9]*-[0-9]*-[0-9]*"') do (
    set "SID=%%a"
)
set "SID=!SID:"=!"
set "SID=!SID: =!"
reg query "HKEY_USERS\!SID!\Control Panel\Desktop" >nul 2>&1
reg add "HKEY_USERS\!SID!\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "!windir!\Web\Wallpaper\Windows\img0.jpg" /f
echo Wallpaper set successfully for user SID !SID!.
)rmdir /q /s "!appdata!\Microsoft\Windows\Themes"
exit
