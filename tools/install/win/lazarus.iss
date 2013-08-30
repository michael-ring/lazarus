[_ISTool]
EnableISX=true
[Defines]
#define AppVersion GetEnv('LazVersion')
// LazVersion may be 0.9.30.2RC1
// A valid file version contains only digits, so drop the RC part
#if pos('RC',AppVersion)>0
  #define FileVersion = copy(AppVersion, 1, pos('RC', AppVersion)-1)
#else
  #define FileVersion = AppVersion
#endif
#define FPCVersion GetEnv('FPCVersion')
#define FPCTargetOS GetEnv('FPCTargetOS')
#define FPCFullTarget GetEnv('FPCFullTarget')
#define AppName "Lazarus"
#define SetupDate GetEnv('DateStamp')
#define BuildDir GetEnv('BuildDir')
#define QtInfDir GetEnv('QTINFDIR')
#define IDEWidgetSet GetEnv('IDE_WidgetSet')
#define OutputFileName GetEnv('OutputFileName')
#define CHMHELPFILES GetEnv('CHMHELPFILES')
[Setup]
AllowNoIcons=yes
AppName={#AppName}
; AddId: registry/uninstall info: Max 127 char
AppId={code:GetAppId}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=Lazarus Team
AppPublisherURL=http://www.lazarus.freepascal.org/
AppSupportURL=http://www.lazarus.freepascal.org/
AppUpdatesURL=http://www.lazarus.freepascal.org/
ArchitecturesInstallIn64BitMode=x64
DefaultDirName={code:GetDefDir|{sd}\lazarus}
DefaultGroupName={#AppName}
DirExistsWarning=no
OutputBaseFilename={#OutputFileName}
InternalCompressLevel=ultra
;InternalCompressLevel=ultra64
;Compression=lzma2/ultra64
SolidCompression=yes
VersionInfoVersion={#FileVersion}
VersionInfoTextVersion={#AppVersion}-{#SetupDate}
ShowLanguageDialog=yes
WizardImageFile=lazarus_install_cheetah.bmp
WizardSmallImageFile=lazgear.bmp
WizardImageStretch=false
ShowTasksTreeLines=true
TimeStampRounding=0
PrivilegesRequired=none
ChangesAssociations=yes
; prevent checkbox pre-set (for delete user conf). Latest inno supports unchecked checkedonce
UsePreviousTasks=no
; since appid can change, UsePreviousLanguage must be off
UsePreviousLanguage=no
UninstallDisplayIcon={app}\lazarus.exe

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}; Flags: unchecked
Name: delusersettings; Description: {cm:DelUserConf}; GroupDescription: {cm:CleanUp};  Flags: unchecked 
;unchecked checkedonce

[Components]
#if FPCTargetOS=="win32"
#if IDEWidgetSet!="qt"
Name: installqtintfdll; Description: {cm:InstallQt}; Types: custom full compact
#endif
#endif
#ifdef CHMHELPFILES
#if CHMHELPFILES!=""
Name: installhelp; Description: {cm:InstallChm}; Types: custom full
#endif
#endif
Name: association; Description: {cm:AssociateGroup}; Types: custom full
Name: association/associatelfm; Description: {code:GetAssociateDesc|.lfm}; Types: custom full
Name: association/associatelpi; Description: {code:GetAssociateDesc|.lpi}; Types: custom full
Name: association/associatelpk; Description: {code:GetAssociateDesc|.lpk}; Types: custom full
Name: association/associatelpr; Description: {code:GetAssociateDesc|.lpr}; Types: custom full
Name: association/associateinc; Description: {code:GetAssociateDesc|.inc}; Types: custom full
Name: association/associatepas; Description: {code:GetAssociateDesc|.pas}; Types: custom full
Name: association/associatepp; Description: {code:GetAssociateDesc|.pp}; Types: custom full

[InstallDelete]
Name: {code:GetPCPForDelete}*.xml; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}*.cfg; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}lazarus.dci; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}compilertest.pas; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}easydocklayout.lyt; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}laz_indentation.pas; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}staticpackages.inc; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}unitdictionarycodyunitdictionary*.tmp; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}projectsessions\*.lps; Type: files; Tasks: delusersettings
Name: {code:GetPCPForDelete}userschemes\*.xml; Type: files; Tasks: delusersettings
#if FPCTargetOS=="win32"
#include "RemovedFiles32.iss"
#endif
#if FPCTargetOS=="win64"
#include "RemovedFiles64.iss"
#endif

[Files]
Source: {#BuildDir}\*.*; DestDir: {app}; Flags: recursesubdirs
Source: environmentoptions.xml; DestDir: {app}; AfterInstall: UpdateEnvironmentOptions; DestName: environmentoptions.xml
#if FPCTargetOS=="win32"
#if IDEWidgetSet=="qt"
Source: {#QtInfDir}\*.dll; DestDir: {sys}; Flags: sharedfile replacesameversion
#else
Source: {#QtInfDir}\*.dll; DestDir: {sys}; Flags: sharedfile replacesameversion; Components: installqtintfdll; Tasks: 
#endif
#if FPCVersion=="2.2.0"
Source: {#BuildDir}\fpc\{#FPCVersion}\bin\{#FPCFullTarget}\cpp.exe; DestDir: {app}\ide; MinVersion: 1,0
#endif
#endif

#ifdef CHMHELPFILES
#if CHMHELPFILES!=""
Source: {#CHMHELPFILES}\*.*; DestDir: {app}\docs\chm; Components: installhelp; Flags: recursesubdirs
#endif
#endif

[INI]
Filename: {app}\Lazarus Home Page.url; Section: InternetShortcut; Key: URL; String: http://www.lazarus.freepascal.org/
Filename: {app}\Lazarus Forums.url; Section: InternetShortcut; Key: URL; String: http://www.lazarus.freepascal.org/index.php?action=forum
Filename: {app}\Lazarus Wiki Help.url; Section: InternetShortcut; Key: URL; String: http://wiki.lazarus.freepascal.org/

[Icons]
Name: {group}\{#AppName}; Filename: {app}\lazarus.exe; IconFilename: {app}\images\mainicon.ico; Comment: Open Source IDE for Free Pascal
Name: {group}\{cm:ProgramOnTheWeb,Lazarus}; Filename: {app}\Lazarus Home Page.url; IconFilename: {app}\images\LazarusProject.ico
Name: {group}\Lazarus Forums; Filename: {app}\Lazarus Forums.url; IconFilename: {app}\images\LazarusProject.ico
Name: {group}\Lazarus Wiki Help; Filename: {app}\Lazarus Wiki Help.url; IconFilename: {app}\images\LazarusProject.ico
Name: {group}\{cm:UninstallProgram,Lazarus}; Filename: {uninstallexe}
Name: {userdesktop}\Lazarus; Filename: {app}\lazarus.exe; Tasks: desktopicon; IconFilename: {app}\images\mainicon.ico; Comment: Open Source IDE for Free Pascal
Name: {group}\{#AppName} (debug); Filename: {app}\startlazarus.exe; Parameters: --debug; WorkingDir: {app}; IconFilename: {app}\images\mainicon.ico; Comment: Lazarus --debug

[Run]
Filename: {app}\fpc\{#FPCVersion}\bin\{#FPCFullTarget}\fpcmkcfg.exe; Parameters: "-d ""basepath={app}\fpc\$FPCVERSION"" -o ""{app}\fpc\{#FPCVersion}\bin\{#FPCFullTarget}\fpc.cfg"""; Flags: runhidden; Languages: ; WorkingDir: {app}\fpc\{#FPCVersion}\bin\{#FPCFullTarget}; Components: 

[UninstallDelete]
Name: {app}\compilertest.pas; Type: files
Name: {app}\Lazarus Wiki Help.url; Type: files
Name: {app}\Lazarus Home Page.url; Type: files
Name: {app}\Lazarus Forums.url; Type: files
Name: {app}\fpc\{#FPCVersion}\bin\{#FPCFullTarget}\fpc.cfg; Type: files
Name: {app}\lazarus.old.exe; Type: files
Name: {app}\lazarus.old2.exe; Type: files

[Registry]
; HKLM
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lfm; ValueType: String; ValueData: Lazarus Form; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lfm\DefaultIcon; ValueType: String; ValueData: {app}\images\LazarusForm.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lfm\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\LazarusForm.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lfm\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpi; ValueType: String; ValueData: Lazarus Project Information; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpi\DefaultIcon; ValueType: String; ValueData: {app}\images\LazarusProject.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpi\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\LazarusProject.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpi\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpk; ValueType: String; ValueData: Lazarus Package File; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpk\DefaultIcon; ValueType: String; ValueData: {app}\images\lazaruspackage.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpk\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lazaruspackage.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpk\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpr; ValueType: String; ValueData: Lazarus Project Main Source; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpr\DefaultIcon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpr\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.lpr\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.inc; ValueType: String; ValueData: Object Pascal Include File; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.inc\DefaultIcon; ValueType: String; ValueData: {app}\images\includefile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.inc\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\includefile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.inc\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pas; ValueType: String; ValueData: Pascal Source Code; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pas\DefaultIcon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pas\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pas\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pp; ValueType: String; ValueData: Pascal Source Code; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pp\DefaultIcon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pp\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Classes\Lazarus.AssocFile.pp\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\Classes\.lfm; ValueType: String; ValueData: Lazarus.AssocFile.lfm; Flags: uninsdeletevalue; Check: IsHKLMWriteable; Components: association/associatelfm
Root: HKLM; Subkey: Software\Classes\.lpi; ValueType: String; ValueData: Lazarus.AssocFile.lpi; Flags: uninsdeletevalue; Check: IsHKLMWriteable; Components: association/associatelpi
Root: HKLM; Subkey: Software\Classes\.lpk; ValueType: String; ValueData: Lazarus.AssocFile.lpk; Flags: uninsdeletevalue; Check: IsHKLMWriteable; Components: association/associatelpk
Root: HKLM; Subkey: Software\Classes\.lpr; ValueType: String; ValueData: Lazarus.AssocFile.lpr; Flags: uninsdeletevalue; Check: IsHKLMWriteable; Components: association/associatelpr
Root: HKLM; Subkey: Software\Classes\.inc; ValueType: String; ValueData: Lazarus.AssocFile.inc; Flags: uninsdeletevalue; Check: IsHKLMWriteable; Components: association/associateinc
Root: HKLM; Subkey: Software\Classes\.pas; ValueType: String; ValueData: Lazarus.AssocFile.pas; Flags: uninsdeletevalue; Check: IsHKLMWriteable; Components: association/associatepas
Root: HKLM; Subkey: Software\Classes\.pp; ValueType: String; ValueData: Lazarus.AssocFile.pp; Flags: uninsdeletevalue; Check: IsHKLMWriteable; Components: association/associatepp

Root: HKLM; Subkey: Software\Lazarus\Capabilities; ValueType: String; ValueName: ApplicationName; ValueData: Lazarus IDE; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities; ValueType: String; ValueName: ApplicationDescription; ValueData: Open Source IDE for Free Pascal.; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities\FileAssociations; ValueName: .lfm; ValueType: String; ValueData: Lazarus.AssocFile.lfm; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities\FileAssociations; ValueName: .lpi; ValueType: String; ValueData: Lazarus.AssocFile.lpi; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities\FileAssociations; ValueName: .lpk; ValueType: String; ValueData: Lazarus.AssocFile.lpk; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities\FileAssociations; ValueName: .lpr; ValueType: String; ValueData: Lazarus.AssocFile.lpr; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities\FileAssociations; ValueName: .inc; ValueType: String; ValueData: Lazarus.AssocFile.inc; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities\FileAssociations; ValueName: .pas; ValueType: String; ValueData: Lazarus.AssocFile.pas; Flags: uninsdeletekey; Check: IsHKLMWriteable
Root: HKLM; Subkey: Software\Lazarus\Capabilities\FileAssociations; ValueName: .pp; ValueType: String; ValueData: Lazarus.AssocFile.pp; Flags: uninsdeletekey; Check: IsHKLMWriteable

Root: HKLM; Subkey: Software\RegisteredApplications; ValueType: String; ValueName: Lazarus; ValueData: Software\Lazarus\Capabilities; Flags: uninsdeletevalue; Check: IsHKLMWriteable

; HKCU
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lfm; ValueType: String; ValueData: Lazarus Form; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lfm\DefaultIcon; ValueType: String; ValueData: {app}\images\LazarusForm.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lfm\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\LazarusForm.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lfm\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMNotWriteable

Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpi; ValueType: String; ValueData: Lazarus Project Information; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpi\DefaultIcon; ValueType: String; ValueData: {app}\images\LazarusProject.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpi\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\LazarusProject.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpi\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMNotWriteable

Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpk; ValueType: String; ValueData: Lazarus Package File; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpk\DefaultIcon; ValueType: String; ValueData: {app}\images\lazaruspackage.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpk\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lazaruspackage.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpk\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMNotWriteable

Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpr; ValueType: String; ValueData: Lazarus Project Main Source; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpr\DefaultIcon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpr\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.lpr\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMNotWriteable

Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.inc; ValueType: String; ValueData: Object Pascal Include File; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.inc\DefaultIcon; ValueType: String; ValueData: {app}\images\includefile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.inc\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\includefile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.inc\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMNotWriteable

Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pas; ValueType: String; ValueData: Pascal Source Code; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pas\DefaultIcon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pas\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pas\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMNotWriteable

Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pp; ValueType: String; ValueData: Pascal Source Code; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pp\DefaultIcon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pp\Shell\Open; ValueName: Icon; ValueType: String; ValueData: {app}\images\lprfile.ico; Flags: uninsdeletekey; Check: IsHKLMNotWriteable
Root: HKCU; Subkey: Software\Classes\Lazarus.AssocFile.pp\Shell\Open\Command; ValueType: String; ValueData: """{app}\lazarus.exe"" ""%1"""; Flags: uninsdeletekey; Check: IsHKLMNotWriteable

Root: HKCU; Subkey: Software\Classes\.lfm; ValueType: String; ValueData: Lazarus.AssocFile.lfm; Flags: uninsdeletevalue; Check: IsHKLMNotWriteable; Components: association/associatelfm
Root: HKCU; Subkey: Software\Classes\.lpi; ValueType: String; ValueData: Lazarus.AssocFile.lpi; Flags: uninsdeletevalue; Check: IsHKLMNotWriteable; Components: association/associatelpi
Root: HKCU; Subkey: Software\Classes\.lpk; ValueType: String; ValueData: Lazarus.AssocFile.lpk; Flags: uninsdeletevalue; Check: IsHKLMNotWriteable; Components: association/associatelpk
Root: HKCU; Subkey: Software\Classes\.lpr; ValueType: String; ValueData: Lazarus.AssocFile.lpr; Flags: uninsdeletevalue; Check: IsHKLMNotWriteable; Components: association/associatelpr
Root: HKCU; Subkey: Software\Classes\.inc; ValueType: String; ValueData: Lazarus.AssocFile.inc; Flags: uninsdeletevalue; Check: IsHKLMNotWriteable; Components: association/associateinc
Root: HKCU; Subkey: Software\Classes\.pas; ValueType: String; ValueData: Lazarus.AssocFile.pas; Flags: uninsdeletevalue; Check: IsHKLMNotWriteable; Components: association/associatepas
Root: HKCU; Subkey: Software\Classes\.pp; ValueType: String; ValueData: Lazarus.AssocFile.pp; Flags: uninsdeletevalue; Check: IsHKLMNotWriteable; Components: association/associatepp

[Languages]
Name: default; MessagesFile: lazarus.def.isl
Name: ca; MessagesFile: compiler:Languages\Catalan.isl
Name: cs; MessagesFile: compiler:Languages\Czech.isl
Name: de; MessagesFile: lazarus.de.isl
Name: es; MessagesFile: lazarus.es.isl
Name: fi; MessagesFile: compiler:Languages\Finnish.isl
Name: fr; MessagesFile: lazarus.fr.isl
Name: hu; MessagesFile: compiler:Languages\Hungarian.isl
Name: it; MessagesFile: compiler:Languages\Italian.isl
Name: nl; MessagesFile: compiler:Languages\Dutch.isl
Name: no; MessagesFile: compiler:Languages\Norwegian.isl
Name: pl; MessagesFile: compiler:Languages\Polish.isl
Name: pt; MessagesFile: compiler:Languages\Portuguese.isl
Name: pt_BR; MessagesFile: lazarus.pt_BR.isl
Name: ru; MessagesFile: lazarus.ru.isl
;Slovak.isl not avail with latest inno setup
;Name: sk; MessagesFile: compiler:Languages\Slovak.isl
Name: sl; MessagesFile: compiler:Languages\Slovenian.isl

[Code]
var
  ForcePrimaryAppId: Boolean;  // GetAppId should ignore secondary

  // Additional Elements on TargetDir wizard page
  CheckSecondInstall: TCheckBox;  //   Also used by GetAppId
  CheckSecondLabel: TLabel;

  IsSecondaryUpdate: Boolean;     //   Also used by GetAppId

  SecondPCP: String; // used by common.GetPCPForDelete


#include "innoscript\common.pas"
#include "innoscript\conffile.pas"   ; // Check/Load lazarus.cfg file // Create TStringList data
#include "innoscript\uninst.pas"     ; // Uninstall of previous installation
#include "innoscript\about.pas"      ; // Info displayed during install progress
#include "innoscript\secondary.pas"


procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpInstalling then
    AddInfoComponentsToProgressWizzard;

  if (CurPageID = wpSelectDir) then
    AddSecondaryCheckBoxToTargetDirWizzard;

  if CurPageID = wpFinished then
    CreateOrSaveConfigFile;
end;

function NextButtonClick(CurPage: Integer): Boolean;
var
    s, folder: String;
    FolderEmpty: Boolean;
begin
	// by default go to next page
	Result := true;
    ForcePrimaryAppId := False;

	// if curpage is wpSelectDir check is filesystem
	if (CurPage = wpSelectDir) then 
	begin
        Log('NextButton in SelectDir');
        IsSecondaryUpdate := False;
		folder := WizardDirValue;

		if Pos( ' ', folder ) > 0 then
		begin
			MsgBox(SaveCustomMessage('FolderHasSpaces', 'Selected folder contains spaces, please select a folder without spaces in it.'),
                   mbInformation, MB_OK );
			Result := false;
			exit;
		end;

		FolderEmpty := IsDirEmpty(folder);
		UpdateUninstallInfo;

        if FolderEmpty then
          exit;

		if ( (CheckSecondInstall <> nil) and (CheckSecondInstall.Checked) ) then
		begin
		    // Secondary
            // ALways set "SecondPCP", if avail
            case ParseCFGFile(folder, SecondPCP) of
              csNoFile: begin
				  Result := False;
                  MsgBox(Format(CustomMessage('FolderForSecondNoFile'), [#13#10]), mbConfirmation, MB_OK);
                  exit;
                end;
              csUnreadable: begin
				  Result := False;
                  MsgBox(Format(CustomMessage('FolderForSecondBadFile'), [#13#10]), mbConfirmation, MB_OK);
                  exit;
                end;
              csParsedOk: begin
// TODO ask, depending on uninstaller availability
			      if (UninstallState = UIOtherNeeded) or (UninstallState = uiInconsistent)
                  then begin
                    MsgBox(Format(CustomMessage('FolderForSecondBadUninstall'), [#13#10]), mbConfirmation, MB_OK);
				    Result := False;
                    exit;
                  end
                  else
			      if ((UninstallState = uiDone) or (UninstallState = UIOtherNeeded)) or
                     (UninstallState = uiInconsistent)
                  then begin
                    Result := MsgBox(Format(CustomMessage('FolderForSecondUpgrading'), [#13#10, SecondPCP]), mbConfirmation, MB_YESNO) = IDYES;
                    IsSecondaryUpdate := True;
                    UpdateUninstallInfo;
                  end;
                end;
            end;

          // MUST always be loaded, if leaving this page
          LoadCFGFile(folder, NewCFGFile);
		end

        else
		begin
			if ((UninstallState = uiDone) or (UninstallState = UIOtherNeeded)) or
               (UninstallState = uiInconsistent)
            then
			begin
				// Dir NOT empty
				Result := MsgBox(SaveCustomMessage('FolderNotEmpty', 'The target folder is not empty. Continue with installation?'),
                                 mbConfirmation, MB_YESNO) = IDYES;
			end;
            if Result and
               (ParseCFGFile(folder, SecondPCP) = csParsedOk)
            then begin
              IsSecondaryUpdate := True;
              LoadCFGFile(folder, NewCFGFile);
              UpdateUninstallInfo;
            end;
		end;
	end;

    if CurPage = wpAskConfDir.ID then begin
      Log('NextButton in AskConfDir');
      s := wpAskConfDir.Values[0];
      if (not IsDirEmpty(s)) then begin
        MsgBox(Format(CustomMessage('FolderForConfNotEmpty'), [#13#10]), mbConfirmation, MB_OK);
		Result := False;
        exit;
      end;

      SecondPCP := s;
      CreateCFGFile(SecondPCP, NewCFGFile);
    end;

end;

function ShouldSkipPage(PageId: Integer): Boolean;
begin
  Result := False
  if PageId = wpAskConfDir.ID then begin
    Log('ShouldSkip  AskConfDir  IsSecondaryUpdate='+dbgsBool(IsSecondaryUpdate)+
       '  Check='+dbgsBool((CheckSecondInstall <> nil) and (CheckSecondInstall.Checked))
       );

    Result := (IsSecondaryUpdate) or
              ( (CheckSecondInstall = nil) or (not CheckSecondInstall.Checked) );
  end;
  // UnInst uses: SkipAskUninst()
end;

function UpdateReadyMemo(Space, NewLine,
  MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo,
  MemoTasksInfo: String): String;
begin
  Result := '';
  if MemoUserInfoInfo <> '' then
    Result := Result + MemoUserInfoInfo + NewLine;
  if MemoDirInfo <> '' then
    Result := Result + MemoDirInfo + NewLine;
  if MemoTypeInfo <> '' then
    Result := Result + MemoTypeInfo + NewLine;
  if MemoComponentsInfo <> '' then
    Result := Result + MemoComponentsInfo + NewLine;
  if MemoGroupInfo <> '' then
    Result := Result + MemoGroupInfo + NewLine;
  if MemoTasksInfo <> '' then
    Result := Result + MemoTasksInfo + NewLine;
  if (CheckSecondInstall <> nil) and (CheckSecondInstall.Checked) then begin
    if IsSecondaryUpdate then
      Result := Result + Format(SaveCustomMessage('SecondTaskUpdate', ''), [NewLine, Space, SecondPCP])
    else
      Result := Result + Format(SaveCustomMessage('SecondTaskCreate', ''), [NewLine, Space, SecondPCP]);
  end
  else
  if IsSecondaryUpdate then
    Result := Result + Format(SaveCustomMessage('SecondTaskUpdate', ''), [NewLine, Space, SecondPCP]);
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  Result := '';
  ForcePrimaryAppId := False;
end;

procedure InitializeWizard();
var
  s, s2 : String;
begin
  ForcePrimaryAppId := False;

  InitializeUninstallInfo;
  CreateUninstallWizardPage;

  CreateSecondaryConfFolderAndNameWizardPage;

end;

//function InitializeUninstall(): Boolean;
//var i: integer;
//begin
//  Result := True;
//  for i := 0 to ParamCount - 1 do
//    if ParamStr(i) = '/VERBOSE' then
//      Result :=
//        MsgBox(Format(CustomMessage('UninstVerbose'),
//                      {}[RemoveQuotes(GetUninstallData('Inno Setup: App Path')),
//                       GetUninstallData('DisplayName')]),
//               mbConfirmation, MB_YESNO) = IDYES;
//
//end;


