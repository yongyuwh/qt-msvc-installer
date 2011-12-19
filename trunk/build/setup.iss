#define MyAppName "Qt"
#define MyAppNameExtra ""
#define MyAppVer "4.5.2"
#define MyAppVerName "Qt Open Source 4.5.2 Win32 (VS2008)"
#define MyAppPublisher "Packaged by gabeiscoding"
#define MyAppURL "http://code.google.com/p/qt-msvc-installer/"
#define MyAppExeName "bin/qtdemo.exe"
#define MyLicFile "E:\Build\Qt\SourceWin32\qt-win-opensource-src-4.5.2\LICENSE.LGPL"
#define MyAppId "{{6BF23811-0ADC-4736-92A8-2B885629594D}"
#define MyPlatform "Win32"
#define MyPlatformCode = ""
#define MyOSCode = ""
#define MyOutputDir "E:/Build/Qt/SourceWin32/InstallerWin32"
#define MyStageDir "E:/Build/Qt/SourceWin32/qt-win-opensource-src-4.5.2"
#define MyScriptWriterPath "E:/Build/Qt/SourceWin32/build/write-launch-script.js"
#define MyRedistPath "E:/Build/Qt/SourceWin32/build/vcredist_x86.exe"
#define MyOrigPath "E:/Build/Qt/SourceWin32/qt-win-opensource-src-4.5.2"
#define MySetupIconPath "E:/Build/Qt/SourceWin32/qt-win-opensource-src-4.5.2/demos/qtdemo/qtdemo.ico"


[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={#MyAppId}
AppName={#MyAppName}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\{#MyAppName}\{#MyAppVer}{#MyPlatformCode}
DefaultGroupName={#MyAppVerName}\
LicenseFile={#MyLicFile}
OutputDir={#MyOutputDir}
OutputBaseFilename={#MyAppName}-{#MyPlatform}-{#MyAppVer}{#MyAppNameExtra}
SetupIconFile={#MySetupIconPath}
Compression=lzma/ultra
SolidCompression=true
UninstallDisplayIcon={app}\bin\qtdemo.exe
UninstallDisplayName={#MyAppVerName}
ArchitecturesInstallIn64BitMode={#MyOSCode}
ArchitecturesAllowed={#MyOSCode}

VersionInfoDescription={#MyAppName}-{#MyPlatform}-{#MyAppVer}
VersionInfoTextVersion={#MyAppName}-{#MyPlatform}-{#MyAppVer}
VersionInfoCompany={#MyAppPublisher}
RestartIfNeededByRun=false
DiskSpanning=true
DiskSliceSize=199229440

[Languages]
Name: english; MessagesFile: compiler:Default.isl

[Tasks]
Name: fileassoc; Description: Associate *.ui files with Qt Designer; GroupDescription: File Associations:

[Files]
Source: {#MyStageDir}\*; DestDir: {app}; Flags: ignoreversion recursesubdirs createallsubdirs
Source: {#MyScriptWriterPath}; DestDir: {tmp}; Flags: deleteafterinstall
Source: {#MyRedistPath}; DestDir: {tmp}; DestName: vcredist.exe; Flags: deleteafterinstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: {group}\{#MyAppName} Demo; Filename: {app}\{#MyAppExeName}; WorkingDir: {app}
Name: {group}\Assistant; Filename: {app}\bin\assistant.exe; WorkingDir: {app}
Name: {group}\Designer; Filename: {app}\bin\designer.exe; WorkingDir: {app}
Name: {group}\Linguist; Filename: {app}\bin\linguist.exe; WorkingDir: {app}
Name: {group}\PixelTool; Filename: {app}\bin\pixeltool.exe; WorkingDir: {app}
Name: {group}\{#MyAppName} {#MyAppVer} Command Prompt; Filename: {app}\{#MyAppName}CommandPrompt.bat; WorkingDir: {app}; IconFilename: %SystemRoot%\system32\cmd.exe
Name: {group}\Visual Studio 2008 with {#MyAppName} {#MyAppVer}; Filename: {app}\{#MyAppName}VisualStudioStart.bat; WorkingDir: {app}; IconFilename: {app}\{#MyAppExeName}
Name: {group}\{cm:ProgramOnTheWeb,{#MyAppName} MSVC Installer}; Filename: {#MyAppURL}
Name: {group}\{cm:UninstallProgram,{#MyAppName}}; Filename: {uninstallexe}

[Run]
Filename: {app}\{#MyAppExeName}; Description: {cm:LaunchProgram,{#MyAppName} Demo}; Flags: nowait postinstall skipifsilent
Filename: cscript; Parameters: "{tmp}\write-launch-script.js {#MyAppName}  ""{app}"" ""{#MyOrigPath}"" {#MyPlatform}"; WorkingDir: {app}; StatusMsg: Creating a launch script for a {#MyAppName} configured command prompt
Filename: {tmp}\vcredist.exe; StatusMsg: Installing Visual C++ 2008 Runtime...; Parameters: /q

[Registry]
Root: HKCR; Subkey: .ui; ValueType: string; ValueName: ; ValueData: QtDesignerUi; Flags: uninsdeletevalue
Root: HKCR; Subkey: QtDesignerUi; ValueType: string; ValueName: ; ValueData: Qt Designer UI Files; Flags: uninsdeletekey
Root: HKCR; Subkey: QtDesignerUi\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\designer.exe,0
Root: HKCR; Subkey: QtDesignerUi\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\bin\designer.exe"" ""%1"""

[UninstallDelete]
Name: {app}\*; Type: filesandordirs; Tasks: ; Languages: 
