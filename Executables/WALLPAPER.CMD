@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
robocopy "Web" "%windir%\Web" /E /IM /IT /NP
robocopy "!PostInstall" "C:\" /E /IM /IT /NP
robocopy "PostInstall.ink" "%USERPROFILE%\Desktop" /E /IM /IT /NP
for /d %%x in ("!ProgramData!\Microsoft\Windows\SystemData\*") do (
	for /d %%y in ("%%x\ReadOnly\LockScreen_*") do (
		rd /s /q "%%y" 
	)
)
reg add "HKEY_USERS\%~1\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "!windir!\Web\Wallpaper\Windows\img0.jpg" /f
rmdir /q /s "!appdata!\Microsoft\Windows\Themes"
