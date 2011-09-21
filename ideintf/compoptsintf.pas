{
 *****************************************************************************
 *                                                                           *
 *  See the file COPYING.modifiedLGPL.txt, included in this distribution,    *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************

  Author: Mattias Gaertner

  Abstract:
    IDE interface to the IDE compiler options.
}
unit CompOptsIntf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LCLProc,
  IDEOptionsIntf;

type

  { TLazBuildMacro
    Every package/project can define build macros. A build macro has a name,
    a description, a list of possible values and a default value.
    The default value can be an expression using other build macros.
    The IDE defines basic macros like TargetOS and TargetCPU.
    The LCL package defines the macro LCLWidgetType. }

  TLazBuildMacro = class
  protected
    FDefaultValue: string;
    FIdentifier: string;
    FDescription: string;
    FValueDescriptions: TStrings;
    FValues: TStrings;
    procedure SetIdentifier(const AValue: string); virtual; abstract;
    procedure SetDescription(const AValue: string); virtual; abstract;
    procedure SetValueDescriptions(const AValue: TStrings); virtual; abstract;
    procedure SetValues(const AValue: TStrings); virtual; abstract;
  public
    procedure Assign(Source: TLazBuildMacro); virtual; abstract;
    property Identifier: string read FIdentifier write SetIdentifier;
    property Description: string read FDescription write SetDescription;
    property Values: TStrings read FValues write SetValues;
    property ValueDescriptions: TStrings read FValueDescriptions write SetValueDescriptions;
  end;

  { TLazBuildMacros
    The list of build macros of a package/project.
    They are stored in the compiler options. }

  TLazBuildMacros = class
  private
    FOwner: TObject;
  protected
    function GetItems(Index: integer): TLazBuildMacro; virtual; abstract;
  public
    constructor Create(TheOwner: TObject); virtual;
    function Add(Identifier: string): TLazBuildMacro; virtual; abstract;
    procedure Delete(Index: integer); virtual; abstract;
    procedure Move(OldIndex, NewIndex: integer); virtual; abstract;
    function IndexOfIdentifier(Identifier: string): integer; virtual; abstract;
    function VarWithIdentifier(Identifier: string): TLazBuildMacro; virtual; abstract;
    function Count: integer; virtual; abstract;
    procedure Clear; virtual; abstract;
    property Items[Index: integer]: TLazBuildMacro read GetItems; default;
    property Owner: TObject read FOwner;
  end;

  { TLazCompilerOptions }

  TCompilationExecutableType = (
    cetProgram,
    cetLibrary
    );

  TCompileReason = (
    crCompile,  // normal build current project/package
    crBuild,    // build all
    crRun       // quick build before run
    );
  TCompileReasons = set of TCompileReason;

  TCompilerDbgSymbolType = (dsAuto, dsStabs, dsDwarf2, dsDwarf2Set, dsDwarf3);

const
  crAll = [crCompile, crBuild, crRun];

type
  { TLazCompilerOptions }

  TLazCompilerOptions = class(TAbstractIDECompilerOptions)
  private
    FOnModified: TNotifyEvent;
    fOwner: TObject;
    SetEmulatedFloatOpcodes: boolean;
    function GetDebugInfoTypeStr: String;
    function GetGenerateDwarf: Boolean;
    procedure SetAllowLabel(const AValue: Boolean);
    procedure SetAssemblerStyle(const AValue: Integer);
    procedure SetCMacros(const AValue: Boolean);
    procedure SetConfigFilePath(const AValue: String);
    procedure SetCPPInline(const AValue: Boolean);
    procedure SetCStyleOp(const AValue: Boolean);
    procedure SetCustomConfigFile(const AValue: Boolean);
    procedure SetDebugInfoType(AValue: TCompilerDbgSymbolType);
    procedure SetDontUseConfigFile(const AValue: Boolean);
    procedure SetExecutableType(const AValue: TCompilationExecutableType);
    procedure SetGenDebugInfo(const AValue: Boolean);
    procedure SetGenerateDwarf(const AValue: Boolean);
    procedure SetGenGProfCode(const AValue: Boolean);
    procedure SetHeapSize(const AValue: Integer);
    procedure SetIncludeAssertionCode(const AValue: Boolean);
    procedure SetInitConst(const AValue: Boolean);
    procedure SetIOChecks(const AValue: Boolean);
    procedure SetLinkSmart(const AValue: Boolean);
    procedure SetOptLevel(const AValue: Integer);
    procedure SetOverflowChecks(const AValue: Boolean);
    procedure SetPassLinkerOpt(const AValue: Boolean);
    procedure SetRangeChecks(const AValue: Boolean);
    procedure SetShowAll(const AValue: Boolean);
    procedure SetShowAllProcsOnError(const AValue: Boolean);
    procedure SetShowCompProc(const AValue: Boolean);
    procedure SetShowCond(const AValue: Boolean);
    procedure SetShowDebugInfo(const AValue: Boolean);
    procedure SetShowDefMacros(const AValue: Boolean);
    procedure SetShowErrors(const AValue: Boolean);
    procedure SetShowExecInfo(const AValue: Boolean);
    procedure SetShowGenInfo(const AValue: Boolean);
    procedure SetShowHints(const AValue: Boolean);
    procedure SetShowHintsForSenderNotUsed(const AValue: Boolean);
    procedure SetShowHintsForUnusedUnitsInMainSrc(const AValue: Boolean);
    procedure SetShowLineNum(const AValue: Boolean);
    procedure SetShowNotes(const AValue: Boolean);
    procedure SetShowNothing(const AValue: Boolean);
    procedure SetShowSummary(const AValue: Boolean);
    procedure SetShowTriedFiles(const AValue: Boolean);
    procedure SetShowUsedFiles(const AValue: Boolean);
    procedure SetShowWarn(const AValue: Boolean);
    procedure SetSmallerCode(const AValue: boolean);
    procedure SetSmartLinkUnit(const AValue: Boolean);
    procedure SetStackChecks(const AValue: Boolean);
    procedure SetStaticKeyword(const AValue: Boolean);
    procedure SetStopAfterErrCount(const AValue: integer);
    procedure SetStripSymbols(const AValue: Boolean);
    procedure SetSyntaxMode(const AValue: string);
    procedure SetTargetFilenameAppplyConventions(const AValue: boolean);
    procedure SetUncertainOpt(const AValue: Boolean);
    procedure SetUseAnsiStr(const AValue: Boolean);
    procedure SetUseExternalDbgSyms(const AValue: Boolean);
    procedure SetUseHeaptrc(const AValue: Boolean);
    procedure SetUseLineInfoUnit(const AValue: Boolean);
    procedure SetUseValgrind(const AValue: Boolean);
    procedure SetVarsInReg(const AValue: Boolean);
    procedure SetVerifyObjMethodCall(const AValue: boolean);
    procedure SetWin32GraphicApp(const AValue: boolean);
    procedure SetWriteFPCLogo(const AValue: Boolean);
  protected
    FChangeStamp: int64;
    FSavedChangeStamp: int64;
    fOnChanged: TMethodList;

    // Paths:

    // conditionals / build modes
    FConditionals: string;
    fBuildMacros: TLazBuildMacros;
    fLCLWidgetType: string;

    // Parsing:
    // assembler style
    fAssemblerStyle: Integer;

    // syntax options
    FSyntaxMode: string;
    fCStyleOp: Boolean;
    fIncludeAssertionCode: Boolean;
    fAllowLabel: Boolean;
    fUseAnsiStr: Boolean;
    fCPPInline: Boolean;
    fCMacros: Boolean;
    fInitConst: Boolean;
    fStaticKeyword: Boolean;

    // Code generation:
    fSmartLinkUnit: Boolean;
    fIOChecks: Boolean;
    fRangeChecks: Boolean;
    fOverflowChecks: Boolean;
    fStackChecks: Boolean;
    FEmulatedFloatOpcodes: boolean;
    fHeapSize: LongInt;
    fVerifyObjMethodCall: boolean;
    FSmallerCode: boolean;
    fTargetProc: string;
    fTargetCPU: string;
    fVarsInReg: Boolean;
    fUncertainOpt: Boolean;
    fOptLevel: Integer;
    fTargetOS: String;

    // Linking:
    fGenDebugInfo: Boolean;
    FDebugInfoType: TCompilerDbgSymbolType;
    fUseLineInfoUnit: Boolean;
    fUseHeaptrc: Boolean;
    fUseValgrind: Boolean;
    fGenGProfCode: Boolean;
    fStripSymbols: Boolean;
    fLinkSmart: Boolean;
    fPassLinkerOpt: Boolean;
    fLinkerOptions: String;
    FWin32GraphicApp: boolean;
    FExecutableType: TCompilationExecutableType;
    FUseExternalDbgSyms : Boolean;
    fTargetFilename: string;
    FTargetFilenameAppplyConventions: boolean;

    // Messages:
    fShowErrors: Boolean;
    fShowWarn: Boolean;
    fShowNotes: Boolean;
    fShowHints: Boolean;
    fShowGenInfo: Boolean;
    fShowLineNum: Boolean;
    fShowAll: Boolean;
    fShowAllProcsOnError: Boolean;
    fShowDebugInfo: Boolean;
    fShowUsedFiles: Boolean;
    fShowTriedFiles: Boolean;
    fShowDefMacros: Boolean;
    fShowCompProc: Boolean;
    fShowCond: Boolean;
    fShowExecInfo: Boolean;
    fShowNothing: Boolean;
    fShowSummary: Boolean;
    fShowHintsForUnusedUnitsInMainSrc: Boolean;
    fShowHintsForSenderNotUsed: Boolean;
    fWriteFPCLogo: Boolean;
    fStopAfterErrCount: integer;

    // Other:
    fDontUseConfigFile: Boolean;
    fCustomConfigFile: Boolean;
    fConfigFilePath: String;
  protected
    function GetCustomOptions: string; virtual; abstract;
    function GetDebugPath: string; virtual; abstract;
    function GetIncludePaths: String; virtual; abstract;
    function GetLibraryPaths: String; virtual; abstract;
    function GetModified: boolean; virtual;
    function GetObjectPath: string; virtual; abstract;
    function GetSrcPath: string; virtual; abstract;
    function GetUnitOutputDir: string; virtual; abstract;
    function GetUnitPaths: String; virtual; abstract;
    procedure SetCompilerPath(const AValue: String); virtual; abstract;
    procedure SetConditionals(const AValue: string); virtual; abstract;
    procedure SetCustomOptions(const AValue: string); virtual; abstract;
    procedure SetDebugPath(const AValue: string); virtual; abstract;
    procedure SetIncludePaths(const AValue: String); virtual; abstract;
    procedure SetLibraryPaths(const AValue: String); virtual; abstract;
    procedure SetLinkerOptions(const AValue: String); virtual; abstract;
    procedure SetModified(const AValue: boolean); virtual; abstract;
    procedure SetObjectPath(const AValue: string); virtual; abstract;
    procedure SetSrcPath(const AValue: string); virtual; abstract;
    procedure SetTargetCPU(const AValue: string); virtual; abstract;
    procedure SetTargetFilename(const AValue: String); virtual; abstract;
    procedure SetTargetOS(const AValue: string); virtual; abstract;
    procedure SetTargetProc(const AValue: string); virtual; abstract;
    procedure SetUnitOutputDir(const AValue: string); virtual; abstract;
    procedure SetUnitPaths(const AValue: String); virtual; abstract;
    procedure SetLCLWidgetType(const AValue: string); virtual;
  public
    constructor Create(const TheOwner: TObject); virtual;
    destructor Destroy; override;
    function IsActive: boolean; virtual;
    function TrimCustomOptions(o: string): string; virtual; abstract;
    function CreatePPUFilename(const SourceFileName: string): string; virtual; abstract;
    function GetUnitOutputDirectory(RelativeToBaseDir: boolean): string; virtual; abstract;
  public
    property Owner: TObject read fOwner write fOwner;
    property Modified: boolean read GetModified write SetModified;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
    property ChangeStamp: int64 read FChangeStamp;
    procedure IncreaseChangeStamp;
    class function InvalidChangeStamp: int64;
    procedure AddOnChangedHandler(const Handler: TNotifyEvent);
    procedure RemoveOnChangedHandler(const Handler: TNotifyEvent);

    // search paths:
    property IncludePath: String read GetIncludePaths write SetIncludePaths; // alias IncPath
    property Libraries: String read GetLibraryPaths write SetLibraryPaths; // alias LibraryPath
    property OtherUnitFiles: String read GetUnitPaths write SetUnitPaths; // alias UnitPath
    property ObjectPath: string read GetObjectPath write SetObjectPath;
    property SrcPath: string read GetSrcPath write SetSrcPath;  // alias SrcPath
    property DebugPath: string read GetDebugPath write SetDebugPath;
    property UnitOutputDirectory: string read GetUnitOutputDir write SetUnitOutputDir;

    // conditional / build modes
    property Conditionals: string read FConditionals write SetConditionals;
    property BuildMacros: TLazBuildMacros read fBuildMacros;
    // Beware: eventually LCLWidgetType will be replaced by a more generic solution
    property LCLWidgetType: string read fLCLWidgetType write SetLCLWidgetType;

    // target:
    property TargetFilename: String read fTargetFilename write SetTargetFilename;
    property TargetFilenameApplyConventions: boolean read FTargetFilenameAppplyConventions write SetTargetFilenameAppplyConventions;

    // parsing:
    property SyntaxMode: string read FSyntaxMode write SetSyntaxMode;
    property AssemblerStyle: Integer read fAssemblerStyle write SetAssemblerStyle;
    property CStyleOperators: Boolean read fCStyleOp write SetCStyleOp;
    property IncludeAssertionCode: Boolean
                         read fIncludeAssertionCode write SetIncludeAssertionCode;
    property AllowLabel: Boolean read fAllowLabel write SetAllowLabel;
    property UseAnsiStrings: Boolean read fUseAnsiStr write SetUseAnsiStr;
    property CPPInline: Boolean read fCPPInline write SetCPPInline;
    property CStyleMacros: Boolean read fCMacros write SetCMacros;
    property InitConstructor: Boolean read fInitConst write SetInitConst;
    property StaticKeyword: Boolean read fStaticKeyword write SetStaticKeyword;

    // code generation:
    property IOChecks: Boolean read fIOChecks write SetIOChecks;
    property RangeChecks: Boolean read fRangeChecks write SetRangeChecks;
    property OverflowChecks: Boolean read fOverflowChecks write SetOverflowChecks;
    property StackChecks: Boolean read fStackChecks write SetStackChecks;
    property SmartLinkUnit: Boolean read fSmartLinkUnit write SetSmartLinkUnit;
    property EmulatedFloatOpcodes: boolean read SetEmulatedFloatOpcodes
                                           write SetEmulatedFloatOpcodes;
    property HeapSize: Integer read fHeapSize write SetHeapSize;
    property VerifyObjMethodCall: boolean read FVerifyObjMethodCall
                                          write SetVerifyObjMethodCall;
    property SmallerCode: boolean read FSmallerCode write SetSmallerCode;
    property TargetCPU: string read fTargetCPU write SetTargetCPU; // general type
    property TargetProcessor: String read fTargetProc write SetTargetProc; // specific
    property TargetOS: string read fTargetOS write SetTargetOS;
    property VariablesInRegisters: Boolean read fVarsInReg write SetVarsInReg;
    property UncertainOptimizations: Boolean read fUncertainOpt write SetUncertainOpt;
    property OptimizationLevel: Integer read fOptLevel write SetOptLevel;

    // linking:
    property GenerateDebugInfo: Boolean read fGenDebugInfo write SetGenDebugInfo;
    property DebugInfoType: TCompilerDbgSymbolType read FDebugInfoType write SetDebugInfoType;
    property DebugInfoTypeStr: String read GetDebugInfoTypeStr;
    property GenerateDwarf: Boolean read GetGenerateDwarf write SetGenerateDwarf; deprecated 'use DebugInfoType';
    property UseLineInfoUnit: Boolean read fUseLineInfoUnit write SetUseLineInfoUnit;
    property UseHeaptrc: Boolean read fUseHeaptrc write SetUseHeaptrc;
    property UseValgrind: Boolean read fUseValgrind write SetUseValgrind;
    property GenGProfCode: Boolean read fGenGProfCode write SetGenGProfCode;
    property StripSymbols: Boolean read fStripSymbols write SetStripSymbols;
    property LinkSmart: Boolean read fLinkSmart write SetLinkSmart;
    property PassLinkerOptions: Boolean read fPassLinkerOpt write SetPassLinkerOpt;
    property LinkerOptions: String read fLinkerOptions write SetLinkerOptions;
    property Win32GraphicApp: boolean read FWin32GraphicApp write SetWin32GraphicApp;
    property ExecutableType: TCompilationExecutableType
                                     read FExecutableType write SetExecutableType;
    property UseExternalDbgSyms: Boolean read FUseExternalDbgSyms write SetUseExternalDbgSyms;

    // messages:
    property ShowErrors: Boolean read fShowErrors write SetShowErrors;
    property ShowWarn: Boolean read fShowWarn write SetShowWarn;
    property ShowNotes: Boolean read fShowNotes write SetShowNotes;
    property ShowHints: Boolean read fShowHints write SetShowHints;
    property ShowGenInfo: Boolean read fShowGenInfo write SetShowGenInfo;
    property ShowLineNum: Boolean read fShowLineNum write SetShowLineNum;
    property ShowAll: Boolean read fShowAll write SetShowAll;
    property ShowAllProcsOnError: Boolean
      read fShowAllProcsOnError write SetShowAllProcsOnError;
    property ShowDebugInfo: Boolean read fShowDebugInfo write SetShowDebugInfo;
    property ShowUsedFiles: Boolean read fShowUsedFiles write SetShowUsedFiles;
    property ShowTriedFiles: Boolean read fShowTriedFiles write SetShowTriedFiles;
    property ShowDefMacros: Boolean read fShowDefMacros write SetShowDefMacros;
    property ShowCompProc: Boolean read fShowCompProc write SetShowCompProc;
    property ShowCond: Boolean read fShowCond write SetShowCond;
    property ShowExecInfo: Boolean read fShowExecInfo write SetShowExecInfo;
    property ShowNothing: Boolean read fShowNothing write SetShowNothing;
    property ShowSummary: Boolean read FShowSummary write SetShowSummary;
    property ShowHintsForUnusedUnitsInMainSrc: Boolean
      read fShowHintsForUnusedUnitsInMainSrc write SetShowHintsForUnusedUnitsInMainSrc;
    property ShowHintsForSenderNotUsed: Boolean
      read fShowHintsForSenderNotUsed write SetShowHintsForSenderNotUsed;
    property WriteFPCLogo: Boolean read fWriteFPCLogo write SetWriteFPCLogo;
    property StopAfterErrCount: integer
      read fStopAfterErrCount write SetStopAfterErrCount;

    // other
    property DontUseConfigFile: Boolean read fDontUseConfigFile
                                        write SetDontUseConfigFile;
    property CustomConfigFile: Boolean read fCustomConfigFile
                                       write SetCustomConfigFile;
    property ConfigFilePath: String read fConfigFilePath write SetConfigFilePath;
    property CustomOptions: string read GetCustomOptions write SetCustomOptions;
  end;

implementation

{ TLazBuildMacros }

constructor TLazBuildMacros.Create(TheOwner: TObject);
begin
  FOwner:=TheOwner
end;

{ TLazCompilerOptions }

procedure TLazCompilerOptions.SetLCLWidgetType(const AValue: string);
begin
  if AValue=LCLWidgetType then exit;
  fLCLWidgetType:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetLinkSmart(const AValue: Boolean);
begin
  if fLinkSmart=AValue then exit;
  fLinkSmart:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetOptLevel(const AValue: Integer);
begin
  if fOptLevel=AValue then exit;
  fOptLevel:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetOverflowChecks(const AValue: Boolean);
begin
  if fOverflowChecks=AValue then exit;
  fOverflowChecks:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetPassLinkerOpt(const AValue: Boolean);
begin
  if fPassLinkerOpt=AValue then exit;
  fPassLinkerOpt:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetRangeChecks(const AValue: Boolean);
begin
  if fRangeChecks=AValue then exit;
  fRangeChecks:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowAll(const AValue: Boolean);
begin
  if fShowAll=AValue then exit;
  fShowAll:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowAllProcsOnError(const AValue: Boolean);
begin
  if fShowAllProcsOnError=AValue then exit;
  fShowAllProcsOnError:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowCompProc(const AValue: Boolean);
begin
  if fShowCompProc=AValue then exit;
  fShowCompProc:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowCond(const AValue: Boolean);
begin
  if fShowCond=AValue then exit;
  fShowCond:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowDebugInfo(const AValue: Boolean);
begin
  if fShowDebugInfo=AValue then exit;
  fShowDebugInfo:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowDefMacros(const AValue: Boolean);
begin
  if fShowDefMacros=AValue then exit;
  fShowDefMacros:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowErrors(const AValue: Boolean);
begin
  if fShowErrors=AValue then exit;
  fShowErrors:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowExecInfo(const AValue: Boolean);
begin
  if fShowExecInfo=AValue then exit;
  fShowExecInfo:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowGenInfo(const AValue: Boolean);
begin
  if fShowGenInfo=AValue then exit;
  fShowGenInfo:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowHints(const AValue: Boolean);
begin
  if fShowHints=AValue then exit;
  fShowHints:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowHintsForSenderNotUsed(const AValue: Boolean);
begin
  if fShowHintsForSenderNotUsed=AValue then exit;
  fShowHintsForSenderNotUsed:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowHintsForUnusedUnitsInMainSrc(
  const AValue: Boolean);
begin
  if fShowHintsForUnusedUnitsInMainSrc=AValue then exit;
  fShowHintsForUnusedUnitsInMainSrc:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowLineNum(const AValue: Boolean);
begin
  if fShowLineNum=AValue then exit;
  fShowLineNum:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowNotes(const AValue: Boolean);
begin
  if fShowNotes=AValue then exit;
  fShowNotes:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowNothing(const AValue: Boolean);
begin
  if fShowNothing=AValue then exit;
  fShowNothing:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowSummary(const AValue: Boolean);
begin
  if FShowSummary=AValue then exit;
  FShowSummary:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowTriedFiles(const AValue: Boolean);
begin
  if fShowTriedFiles=AValue then exit;
  fShowTriedFiles:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowUsedFiles(const AValue: Boolean);
begin
  if fShowUsedFiles=AValue then exit;
  fShowUsedFiles:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetShowWarn(const AValue: Boolean);
begin
  if fShowWarn=AValue then exit;
  fShowWarn:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetSmallerCode(const AValue: boolean);
begin
  if FSmallerCode=AValue then exit;
  FSmallerCode:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetSmartLinkUnit(const AValue: Boolean);
begin
  if fSmartLinkUnit=AValue then exit;
  fSmartLinkUnit:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetStackChecks(const AValue: Boolean);
begin
  if fStackChecks=AValue then exit;
  fStackChecks:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetAllowLabel(const AValue: Boolean);
begin
  if fAllowLabel=AValue then exit;
  fAllowLabel:=AValue;
  IncreaseChangeStamp;
end;

function TLazCompilerOptions.GetGenerateDwarf: Boolean;
begin
  Result := FDebugInfoType in [dsDwarf2, dsDwarf2Set];
end;

function TLazCompilerOptions.GetDebugInfoTypeStr: String;
begin
  WriteStr(Result, FDebugInfoType);
end;

procedure TLazCompilerOptions.SetAssemblerStyle(const AValue: Integer);
begin
  if fAssemblerStyle=AValue then exit;
  fAssemblerStyle:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetCMacros(const AValue: Boolean);
begin
  if fCMacros=AValue then exit;
  fCMacros:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetConfigFilePath(const AValue: String);
begin
  if fConfigFilePath=AValue then exit;
  fConfigFilePath:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetCPPInline(const AValue: Boolean);
begin
  if fCPPInline=AValue then exit;
  fCPPInline:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetCStyleOp(const AValue: Boolean);
begin
  if fCStyleOp=AValue then exit;
  fCStyleOp:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetCustomConfigFile(const AValue: Boolean);
begin
  if fCustomConfigFile=AValue then exit;
  fCustomConfigFile:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetDebugInfoType(AValue: TCompilerDbgSymbolType);
begin
  if FDebugInfoType = AValue then Exit;
  FDebugInfoType := AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetDontUseConfigFile(const AValue: Boolean);
begin
  if fDontUseConfigFile=AValue then exit;
  fDontUseConfigFile:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetExecutableType(
  const AValue: TCompilationExecutableType);
begin
  if FExecutableType=AValue then exit;
  FExecutableType:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetGenDebugInfo(const AValue: Boolean);
begin
  if fGenDebugInfo=AValue then exit;
  fGenDebugInfo:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetGenerateDwarf(const AValue: Boolean);
begin
  if (FDebugInfoType = dsDwarf2) = AValue then exit;
  if AValue then
    FDebugInfoType := dsDwarf2;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetGenGProfCode(const AValue: Boolean);
begin
  if fGenGProfCode=AValue then exit;
  fGenGProfCode:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetHeapSize(const AValue: Integer);
begin
  if fHeapSize=AValue then exit;
  fHeapSize:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetIncludeAssertionCode(const AValue: Boolean);
begin
  if fIncludeAssertionCode=AValue then exit;
  fIncludeAssertionCode:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetInitConst(const AValue: Boolean);
begin
  if fInitConst=AValue then exit;
  fInitConst:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetIOChecks(const AValue: Boolean);
begin
  if fIOChecks=AValue then exit;
  fIOChecks:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetStaticKeyword(const AValue: Boolean);
begin
  if fStaticKeyword=AValue then exit;
  fStaticKeyword:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetStopAfterErrCount(const AValue: integer);
begin
  if fStopAfterErrCount=AValue then exit;
  fStopAfterErrCount:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetStripSymbols(const AValue: Boolean);
begin
  if fStripSymbols=AValue then exit;
  fStripSymbols:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetSyntaxMode(const AValue: string);
begin
  if FSyntaxMode=AValue then exit;
  FSyntaxMode:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetTargetFilenameAppplyConventions(
  const AValue: boolean);
begin
  if FTargetFilenameAppplyConventions=AValue then exit;
  FTargetFilenameAppplyConventions:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetUncertainOpt(const AValue: Boolean);
begin
  if fUncertainOpt=AValue then exit;
  fUncertainOpt:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetUseAnsiStr(const AValue: Boolean);
begin
  if fUseAnsiStr=AValue then exit;
  fUseAnsiStr:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetUseExternalDbgSyms(const AValue: Boolean);
begin
  if FUseExternalDbgSyms=AValue then exit;
  FUseExternalDbgSyms:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetUseHeaptrc(const AValue: Boolean);
begin
  if fUseHeaptrc=AValue then exit;
  fUseHeaptrc:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetUseLineInfoUnit(const AValue: Boolean);
begin
  if fUseLineInfoUnit=AValue then exit;
  fUseLineInfoUnit:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetUseValgrind(const AValue: Boolean);
begin
  if fUseValgrind=AValue then exit;
  fUseValgrind:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetVarsInReg(const AValue: Boolean);
begin
  if fVarsInReg=AValue then exit;
  fVarsInReg:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetVerifyObjMethodCall(const AValue: boolean);
begin
  if FVerifyObjMethodCall=AValue then exit;
  FVerifyObjMethodCall:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetWin32GraphicApp(const AValue: boolean);
begin
  if FWin32GraphicApp=AValue then exit;
  FWin32GraphicApp:=AValue;
  IncreaseChangeStamp;
end;

procedure TLazCompilerOptions.SetWriteFPCLogo(const AValue: Boolean);
begin
  if fWriteFPCLogo=AValue then exit;
  fWriteFPCLogo:=AValue;
  IncreaseChangeStamp;
end;

function TLazCompilerOptions.GetModified: boolean;
begin
  Result:=(FSavedChangeStamp=InvalidChangeStamp)
         or (FSavedChangeStamp<>FChangeStamp);
end;

constructor TLazCompilerOptions.Create(const TheOwner: TObject);
begin
  inherited Create;
  fOnChanged:=TMethodList.Create;
  FChangeStamp:=InvalidChangeStamp;
  FSavedChangeStamp:=FChangeStamp;
  FTargetFilenameAppplyConventions:=true;
  FOwner := TheOwner;
end;

destructor TLazCompilerOptions.Destroy;
begin
  FreeAndNil(fOnChanged);
  inherited Destroy;
end;

function TLazCompilerOptions.IsActive: boolean;
begin
  Result:=false;
end;

procedure TLazCompilerOptions.IncreaseChangeStamp;
begin
  if fChangeStamp<High(ChangeStamp) then
    inc(fChangeStamp)
  else
    fChangeStamp:=Low(int64)+1;
  if fOnChanged<>nil then fOnChanged.CallNotifyEvents(Self);
end;

class function TLazCompilerOptions.InvalidChangeStamp: int64;
begin
  Result:=Low(int64);
end;

procedure TLazCompilerOptions.AddOnChangedHandler(const Handler: TNotifyEvent);
begin
  fOnChanged.Add(TMethod(Handler));
end;

procedure TLazCompilerOptions.RemoveOnChangedHandler(const Handler: TNotifyEvent);
begin
  fOnChanged.Remove(TMethod(Handler));
end;

end.

