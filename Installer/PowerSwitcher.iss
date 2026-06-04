; Inno Setup script for PowerPlanSwitcher
; Builds a double-click Windows installer for the compiled tray app.
; Compile with: ISCC.exe PowerSwitcher.iss

#define MyAppName "PowerPlanSwitcher"
#define MyAppVersion "0.4.4"
#define MyAppPublisher "Petrroll"
#define MyAppURL "https://github.com/petrroll/PowerSwitcher"
#define MyAppExeName "PowerSwitcher.TrayApp.exe"
; Release build output (relative to this .iss file)
#define BuildDir "..\Build\Release"

[Setup]
; Unique application id (do not reuse across unrelated apps)
AppId={{B5E9A3D1-7C4F-4E2A-9F6B-2D8E1A0C5F33}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\{#MyAppExeName}
OutputDir=..\Build\Installer
OutputBaseFilename=PowerPlanSwitcher-{#MyAppVersion}-setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
; App runs as the current user; admin only needed to write Program Files.
PrivilegesRequired=admin
; Matches the app.manifest supportedOS (Windows 10+). .NET Framework 4.8 is in-box on Win10/11.
MinVersion=10.0
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#BuildDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\{#MyAppExeName}.config"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist
Source: "{#BuildDir}\PowerSwitcher.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\Petrroll.Helpers.dll"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; Ensure the tray app is not running before files are removed.
Filename: "{sys}\taskkill.exe"; Parameters: "/IM ""{#MyAppExeName}"" /F"; Flags: runhidden; RunOnceId: "KillTrayApp"
