@echo off

REM Configure Fullscreen Optimizations (FSO)
REM Windows default

reg delete "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_DSEBehavior /f
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 0 /f
reg delete "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_FSEBehavior /f
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 0 /f

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v __COMPAT_LAYER /f

REM Enable Game Bar
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /f

REM Enable Game Bar tips
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v GamePanelStartupTipIndex /f
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v ShowStartupPanel /f
reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /f

REM Enable Windows Game Recording and Broadcasting (DVR)
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" /v value /t REG_DWORD /d 1 /f