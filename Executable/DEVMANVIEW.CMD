@echo off
CD /d %~dp0
devmanview.exe /disable "High precision event timer" > NUL 2>&1
devmanview.exe /disable "System Speaker" > NUL 2>&1
devmanview.exe /disable "Microsoft Radio Device Enumeration Bus" > NUL 2>&1
devmanview.exe /disable "PCI Encryption/Decryption Controller" > NUL 2>&1
devmanview.exe /disable "AMD PSP" > NUL 2>&1
devmanview.exe /disable "Intel SMBus" > NUL 2>&1
devmanview.exe /disable "Intel Management Engine" > NUL 2>&1
devmanview.exe /disable "PCI Memory Controller" > NUL 2>&1
devmanview.exe /disable "PCI standard RAM Controller" > NUL 2>&1
devmanview.exe /disable "System Timer" > NUL 2>&1
devmanview.exe /disable "Programmable Interrupt Controller" > NUL 2>&1
devmanview.exe /disable "Numeric Data Processor" > NUL 2>&1
devmanview.exe /disable "Communications Port (COM1)" > NUL 2>&1
devmanview.exe /disable "Fax" > NUL 2>&1
devmanview.exe /disable "Microsoft Print to PDF" > NUL 2>&1
devmanview.exe /disable "Microsoft XPS Document Writer" > NUL 2>&1
devmanview.exe /disable "Root Print Queue" > NUL 2>&1
devmanview.exe /disable "Remote Desktop Device Redirector Bus" > NUL 2>&1