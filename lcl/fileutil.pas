{  $Id$  }
{
 /***************************************************************************
                               fileutil.pas
                               -----------

 ***************************************************************************/

 *****************************************************************************
 *                                                                           *
 *  This file is part of the Lazarus Component Library (LCL)                 *
 *                                                                           *
 *  See the file COPYING.modifiedLGPL.txt, included in this distribution,        *
 *  for details about the copyright.                                         *
 *                                                                           *
 *  This program is distributed in the hope that it will be useful,          *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
 *                                                                           *
 *****************************************************************************
}
unit FileUtil;

{$mode objfpc}{$H+}

interface

uses
  // For Smart Linking: Do not use the LCL!
  Classes, SysUtils, LCLStrConsts, Masks;
  
{$ifdef Windows}
{$define CaseInsensitiveFilenames}
{$endif}

const
  UTF8FileHeader = #$ef#$bb#$bf;

// file attributes and states
function CompareFilenames(const Filename1, Filename2: string): integer;
function CompareFilenames(const Filename1, Filename2: string;
                          ResolveLinks: boolean): integer;
function CompareFilenames(Filename1: PChar; Len1: integer;
  Filename2: PChar; Len2: integer; ResolveLinks: boolean): integer;
function FilenameIsAbsolute(const TheFilename: string):boolean;
function FilenameIsWinAbsolute(const TheFilename: string):boolean;
function FilenameIsUnixAbsolute(const TheFilename: string):boolean;
procedure CheckIfFileIsExecutable(const AFilename: string);
procedure CheckIfFileIsSymlink(const AFilename: string);
function FileIsReadable(const AFilename: string): boolean;
function FileIsWritable(const AFilename: string): boolean;
function FileIsText(const AFilename: string): boolean;
function FileIsText(const AFilename: string; out FileReadable: boolean): boolean;
function FileIsExecutable(const AFilename: string): boolean;
function FileIsSymlink(const AFilename: string): boolean;
function FileSize(const Filename: string): int64;
function GetFileDescription(const AFilename: string): string;
function ReadAllLinks(const Filename: string;
                      ExceptionOnError: boolean): string;

// directories
function DirPathExists(const FileName: String): Boolean;
function ForceDirectory(DirectoryName: string): boolean;
function DeleteDirectory(const DirectoryName: string;
  OnlyChilds: boolean): boolean;
function ProgramDirectory: string;
function DirectoryIsWritable(const DirectoryName: string): boolean;

// filename parts
const
  PascalFileExt: array[1..3] of string = ('.pas','.pp','.p');

function ExtractFileNameOnly(const AFilename: string): string;
function ExtractFileNameWithoutExt(const AFilename: string): string;
function CompareFileExt(const Filename, Ext: string;
                        CaseSensitive: boolean): integer;
function CompareFileExt(const Filename, Ext: string): integer;
function FilenameIsPascalUnit(const Filename: string): boolean;
function AppendPathDelim(const Path: string): string;
function ChompPathDelim(const Path: string): string;
function TrimFilename(const AFilename: string): string;
function CleanAndExpandFilename(const Filename: string): string;
function CleanAndExpandDirectory(const Filename: string): string;
function CreateAbsoluteSearchPath(const SearchPath, BaseDirectory: string): string;
function CreateRelativePath(const Filename, BaseDirectory: string): string;
function FileIsInPath(const Filename, Path: string): boolean;
function FileIsInDirectory(const Filename, Directory: string): boolean;

// file search
type
  TSearchFileInPathFlag = (
    sffDontSearchInBasePath,
    sffSearchLoUpCase
    );
  TSearchFileInPathFlags = set of TSearchFileInPathFlag;

const
  AllDirectoryEntriesMask = '*';
  
function GetAllFilesMask: string;
function GetExeExt: string;
function SearchFileInPath(const Filename, BasePath, SearchPath,
  Delimiter: string; Flags: TSearchFileInPathFlags): string;
function SearchAllFilesInPath(const Filename, BasePath, SearchPath,
  Delimiter: string; Flags: TSearchFileInPathFlags): TStrings;
function FindDiskFilename(const Filename: string): string;
function FindDiskFileCaseInsensitive(const Filename: string): string;
function FindDefaultExecutablePath(const Executable: string): string;

type

  { TFileIterator }

  TFileIterator = class
  private
    FPath: String;
    FLevel: Integer;
    FFileInfo: TSearchRec;
    FSearching: Boolean;
    function GetFileName: String;
  public
    procedure Stop;

    function IsDirectory: Boolean;
  public
    property FileName: String read GetFileName;
    property FileInfo: TSearchRec read FFileInfo;
    property Level: Integer read FLevel;
    property Path: String read FPath;

    property Searching: Boolean read FSearching;
  end;

  TFileFoundEvent = procedure (FileIterator: TFileIterator) of object;
  TDirectoryFoundEvent = procedure (FileIterator: TFileIterator) of object;

  { TFileSearcher }

  TFileSearcher = class(TFileIterator)
  private
    FOnFileFound: TFileFoundEvent;
    FOnDirectoryFound: TDirectoryFoundEvent;

    procedure RaiseSearchingError;
  protected
    procedure DoDirectoryEnter; virtual;
    procedure DoDirectoryFound; virtual;
    procedure DoFileFound; virtual;
  public
    constructor Create;

    procedure Search(const ASearchPath: String; ASearchMask: String = '';
      ASearchSubDirs: Boolean = True; AMaskSeparator: char = ';');
  public
    property OnDirectoryFound: TDirectoryFoundEvent read FOnDirectoryFound write FOnDirectoryFound;
    property OnFileFound: TFileFoundEvent read FOnFileFound write FOnFileFound;
  end;

function FindAllFiles(const SearchPath: String; SearchMask: String = '';
  SearchSubDirs: Boolean = True): TStringList;

// file actions
function ReadFileToString(const Filename: string): string;
function CopyFile(const SrcFilename, DestFilename: string): boolean;
function CopyFile(const SrcFilename, DestFilename: string; PreserveTime: boolean): boolean;
function GetTempFilename(const Directory, Prefix: string): string;

// basic functions similar to the RTL but working with UTF-8 instead of the
// system encoding

// AnsiToUTF8 and UTF8ToAnsi need a widestring manager under Linux, BSD, MacOSX
// but normally these OS use UTF-8 as system encoding so the widestringmanager
// is not needed.
function NeedRTLAnsi: boolean;// true if system encoding is not UTF-8
procedure SetNeedRTLAnsi(NewValue: boolean);
function UTF8ToSys(const s: string): string;// as UTF8ToAnsi but more independent of widestringmanager
function SysToUTF8(const s: string): string;// as AnsiToUTF8 but more independent of widestringmanager


implementation

uses
{$IFDEF windows}
  Windows;
{$ELSE}
  Unix, BaseUnix;
{$ENDIF}

var
  UpChars: array[char] of char;

var
  FNeedRTLAnsi: boolean = false;
  FNeedRTLAnsiValid: boolean = false;

function NeedRTLAnsi: boolean;
{$IFDEF WinCE}
// CP_UTF8 is missing in the windows unit of the Windows CE RTL
const
  CP_UTF8 = 65001;
{$ENDIF}
var
  Lang: String;
  i: LongInt;
  Encoding: String;
begin
  if FNeedRTLAnsiValid then
    exit(FNeedRTLAnsi);
  {$IFDEF Windows}
  FNeedRTLAnsi:=GetACP<>CP_UTF8;
  {$ELSE}
  FNeedRTLAnsi:=false;
  {$ENDIF}
  Lang := SysUtils.GetEnvironmentVariable('LC_ALL');
  if Length(lang) = 0 then
  begin
    Lang := SysUtils.GetEnvironmentVariable('LC_MESSAGES');
    if Length(Lang) = 0 then
    begin
      Lang := SysUtils.GetEnvironmentVariable('LANG');
    end;
  end;
  i:=System.Pos('.',Lang);
  if (i>0) then begin
    Encoding:=copy(Lang,i+1,length(Lang)-i);
    FNeedRTLAnsi:=(SysUtils.CompareText(Encoding,'UTF-8')=0)
              or (SysUtils.CompareText(Encoding,'UTF8')=0);
  end;
  FNeedRTLAnsiValid:=true;
  Result:=FNeedRTLAnsi;
end;

procedure SetNeedRTLAnsi(NewValue: boolean);
begin
  FNeedRTLAnsi:=NewValue;
  FNeedRTLAnsiValid:=true;
end;

function UTF8ToSys(const s: string): string;
begin
  if NeedRTLAnsi then
    Result:=s
  else
    Result:=UTF8ToAnsi(s);
end;

function SysToUTF8(const s: string): string;
begin
  if NeedRTLAnsi then
    Result:=s
  else
    Result:=AnsiToUTF8(s);
end;

{$I fileutil.inc}

procedure InternalInit;
var
  c: char;
begin
  for c:=Low(char) to High(char) do begin
    UpChars[c]:=upcase(c);
  end;
end;

initialization
  InternalInit;

end.

