@echo off
set MainOS=O:
set HACK_EFIESP=K:
set BSP=G:
set VIRT_EFIESP=J:
set EFIESP=L:

set Folder=W:\10.0.20279.1002.fe_release_10x.201214-1532_arm64fre_26ce5ebdeaad

mkdir %EFIESP%\efi\Boot
copy %HACK_EFIESP%\efi\Boot\bootaa64.efi %EFIESP%\efi\Boot

bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {default} nointegritychecks on
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {default} testsigning on

bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enablebootdebugpolicy   No
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enablebootorderclean    No
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enabledeviceid          No
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enablemassstorage       No
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enablerpmbprovisioning  No
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enablesecurebootpolicy  No
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enablestartcharge       No
bcdedit /store %HACK_EFIESP%\efi\Microsoft\Boot\BCD /set {01de5a27-8705-40db-bad6-96fa5187d4a6} enableresettpm          No

ren %HACK_EFIESP%\efi\Microsoft\Boot\SecureBootPolicy.p7b SecureBootPolicy.p7b.bak

xcopy /cheriky %HACK_EFIESP%\* %VIRT_EFIESP%\

reg load HKLM\RTS %MainOS%\Windows\System32\config\SOFTWARE
for /f %%f in ('dir /b /s %Folder%\REG.TALKMAN\SOFTWARE\*.reg') do reg import %%f
reg unload HKLM\RTS

reg load HKLM\RTS %MainOS%\Windows\System32\config\SYSTEM
for /f %%f in ('dir /b /s %Folder%\REG.TALKMAN\SYSTEM\*.reg') do reg import %%f
reg add HKLM\RTS\ControlSet001\Services\bindflt /v Start /t REG_DWORD /d 0 /f
reg add HKLM\RTS\ControlSet001\Control\Bitlocker /v PreventDeviceEncryption /t REG_DWORD /d 1 /f
reg unload HKLM\RTS

%Folder%\Tools\WPinternals.exe -Test