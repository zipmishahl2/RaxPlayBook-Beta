@Echo off
setlocal EnableDelayedExpansion
powershell set-executionpolicy unrestricted -force 
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do reg.exe add "%%a\Device Parameters\Disk" /v "CacheIsPowerProtected" /t REG_DWORD /d "1" /f > NUL 2>&1
	)
	for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI"^| findstr "HKEY"') do (
		for /f "tokens=*" %%a in ('reg query "%%i"^| findstr "HKEY"') do reg.exe add "%%a\Device Parameters\Disk" /v "UserWriteCacheSetting" /t REG_DWORD /d "1" /f > NUL 2>&1
	)
)
bcdedit /set {current} nx AlwaysOff
bcdedit /set disabledynamictick yes
bcdedit /deletevalue useplatformclock
bcdedit /set bootmenupolicy legacy
bcdedit /set hypervisorlaunchtype off
bcdedit /set isolatedcontext No
bcdedit /set vsmlaunchtype Off 
bcdedit /set vm No
bcdedit /set disableelamdrivers Yes
bcdedit /set {globalsettings} custom:16000067 true
bcdedit /set {globalsettings} custom:16000068 true
bcdedit /set {globalsettings} custom:16000069 true
bcdedit /timeout 10
bcdedit /set {current} description "RaxOS"
label C: RaxOS
Reg add "HKEY_CURRENT_USER\Software\Classes\ID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
@=""
powershell -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_rspndr, ms_lltdio, ms_implat, ms_lldp" 
for /f "delims=" %%u in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces" /s /f "NetbiosOptions" ^| findstr "HKEY"') do (
    reg add "%%u" /v "NetbiosOptions" /t REG_DWORD /d "2" /f
)
powershell.exe Remove-AutologgerConfig -Name "autologger-diagtrack-listener", "cellcore", "cloudexperiencehostoobe", "lwtnetlog", "mellanox-Kernel", "microsoft-windows-assignedaccess-trace", "microsoft-windows-rdp-graphics-rdpidd-trace"

for %%a in (DmaRemappingCompatible) do for /f "delims=" %%b in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%a" ^| findstr "HKEY"') do Reg.exe add "%%b" /v "%%a" /t REG_DWORD /d "0" /f 
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d "0" /f 
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture') do Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d "0" /f 
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" /t REG_DWORD /d "0" /f 
for /f "delims=" %%a in ('reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render') do Reg.exe add "%%a\Properties" /v "{b3f8fa53-0004-438e-9003-51a46e139bfc},4" /t REG_DWORD /d "0" /f 
sc config wlansvc start=auto
set BACKUP="C:\Windows\srvbackup\Windows-Default-services.reg"
echo Windows Registry Editor Version 5.00 >>%BACKUP%

for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (
    for /f "tokens=3" %%b in ('reg query "%%~a" /v "Start" 2^>nul') do (
        for /l %%c in (0,1,4) do (
            if "%%b"=="0x%%c" (
                echo. >>%BACKUP%
                echo [%%~a] >>%BACKUP%
                echo "Start"=dword:0000000%%c >>%BACKUP%
            ) 
        ) 
    ) 
) 

fsutil behavior set disable8dot3 1 > NUL 2>&1
fsutil behavior set disablelastaccess 1 > NUL 2>&1

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi | ForEach-Object { $_.enable = $false; $_.psbase.put(); }"

for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
:: Probably will be reset by installing GPU driver
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul

reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /t REG_SZ /d "" /f > nul

w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"
SC queryex "w32time"|Find "STATE"|Find /v "RUNNING">Nul||(
    net stop w32time
)
net start w32time
w32tm /config /update
w32tm /resync

Reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "HubMode" /t REG_DWORD /d "1" /f 
Reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Classes\ID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f 
Reg.exe add "HKCR\ID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f 

Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{6bdd1fc6-810f-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{ca3e7ab9-b4c3-4ae6-8251-579ef933890f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f
Reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" /v "InactivityShutdownDelay" /t REG_DWORD /d "4294967295" /f
for %%z in (
      AJRouter
      ALG
      AssignedAccessManagerSvc
	AppVClient
	AppIDSvc
      autotimesvc
      AxInstSV
      AarSvc
      acpiex
      acpipagr
      acpipmi
      acpitime
      arcsas
      BDESVC
	Beep
      BcastDVRUserService
	bthleenum
	BTHMODEM
	BthA2dp
	BthEnum
	BthHFEnum
	BTAGService
	bthserv
	BluetoothUserService
	BthAvctpSvc
      bttflt
      HidBth
      BthMini
      BTHPORT
      BTHUSB
      CertPropSvc
      CloudBackupRestoreSvc
      COMSysApp
      ConsentUXUserSvc
      CscService
	cdrom
	cnghwassist
      cloudidsvc
	CldFlt
      cdfs
      circlass
      CompositeBus
      DusmSvc
      defragsvc
      DsSvc
      DialogBlockingService
      dispbrokerdesktopsvc
      DiagTrack
      diagsvc
      DPS
      diagnosticshub.standardcollector.service
      dmwappushservice
      dcsvc
      DevQueryBroker
      DmEnrollmentSvc
      dam
	ehstorclass
      ehstortcgdrv
      embeddedmode
      EapHost
      EFS
      EntAppSvc
	FontCache
	FontCache3.0.0.0
      fdPHost
      fhsvc
      FDResPub
      GraphicsPerfSvc
	gencounter
      GameInputSvc
	hyperkbd
	hypervideo
	hvservice
	hvcrash
	HvHost
      IpxlatCfgSvc
      lfsvc
      lltdio
      lltdsvc
      luafv
      InventorySvc
      lltsdvc
      IKEEXT
	lmhosts
      KtmRM
      MSiSCSI
      MessagingService
      McpManagementService
      mslldp
      MixedRealityOpenXRSvc
	microsoft_bluetooth_avrcptransport
      MapsBroker
      Ndu
	NetBIOS
	NetBT
      NetTcpPortSharing
      NaturalAuthentication
      NPSMSvc
	OneSyncSvc
      UsoSvc
	PcaSvc
      PimIndexMaintenanceSvc
	printworkflowusersvc
      PolicyAgent
      PrintNotify
      PenService
      P9RdrService
      PNRPAutoReg
      PNRPsvc
      p2psvc
      p2pimsvc
      PhoneSvc
      perceptionsimulation
      PeerDistSvc
      QWAVE
      QWAVEdrv
      rspndr
	rdyboost
      rdpbus
      RetailDemo
      RasAuto
      RasAcd
      RDPDR
      RdpVideominiport
	RmSvc
	RFCOMM
      SharedAccess
	SysMain
	ShellHWDetection
      SCardSvr
      ScDeviceEnum
      SCPolicySvc
      scfilter
      SDRSVC
      SessionEnv
      smphost
      SNMPTrap
      svsc
      swprv
      spectrum
      SharedRealitySvc
	spooler
      SEMgrSvc
      SSDPSRV
      storflt
      SmsRouter
	spaceport
	Themes
	TrkWks
	tzautoupdate
      troubleshootingsvc
      TapiSrv
      terminpt
      TsUsbGD
      TermService
      tcpipreg
      TsUsbFlt
      tsusbhub
      TieringEngineService
      upnphost
      UserDataSvc
      UnistoreSvc
	udfs
      UmRdpService
      VacSvc
      Vid
	vmickvpexchange
	vmicguestinterface
	vmicshutdown
	vmicheartbeat
	vmicvmsession
      vpci
	vmicrdv
	vmictimesync
	vmicvss
	vmgid
      VSS
      W32Time
      WaaSMedicSvc
      WalletService
      wbengine
      WpnService
      WbioSrvc
      WEPHOSTSVC
      WerSvc
      wercplsupport
      WSearch
      WPDBusEnum
	wdiservicehost
      WarpJITSvc
      wisvc
      wlpasvc
      wmpApSrv
	wdisystemhost
      WMPNetworkSvc
      WpcMonSvc
      wmiApSrv
      WebClient
) do (
Reg.exe add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%z" /v "Start" /t REG_DWORD /d "4" /f
)

 
set BACKUP="C:\Windows\srvbackup\RaxOS-Default-services.reg"
echo Windows Registry Editor Version 5.00 >>%BACKUP%

for /f "delims=" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services"') do (
    for /f "tokens=3" %%b in ('reg query "%%~a" /v "Start" 2^>nul') do (
        for /l %%c in (0,1,4) do (
            if "%%b"=="0x%%c" (
                echo. >>%BACKUP%
                echo [%%~a] >>%BACKUP%
                echo "Start"=dword:0000000%%c >>%BACKUP%
            ) 
        ) 
    ) 
) 

