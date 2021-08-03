unit CCE.Core.Utils;

interface

uses
  CCE.dprocess,
  System.IOUtils,
  System.SysUtils,
  System.Types,
  Vcl.Forms,
  Winapi.ShellAPI,
  Winapi.Windows;

function RelativeToAbsolutePath(const RelativePath, BasePath: string): string;
function AbsolutePathToRelative(const AbsolutePath, BasePath: string): string;

procedure ExecuteAndWait(const APath, ACommand: string);
procedure OpenFile(const AFileName: String);
procedure OpenUrl(const Url: String);

function PathCanonicalize(lpszDst: PChar; lpszSrc: PChar): LongBool; stdcall;
  external 'shlwapi.dll' name 'PathCanonicalizeW';

function PathRelativePathTo(pszPath: PChar; pszFrom: PChar; dwAttrFrom: DWORD;
  pszTo: PChar; dwAtrTo: DWORD): LongBool; stdcall; external 'shlwapi.dll' name 'PathRelativePathToW';

implementation

function RelativeToAbsolutePath(const RelativePath, BasePath: string): string;
var
  Dst: array[0..259] of char;
begin
  result := RelativePath;
  if TPath.IsRelativePath(RelativePath) then
  begin
    PathCanonicalize(@Dst[0], PChar(IncludeTrailingBackslash(BasePath) + RelativePath));
    if Dst <> '' then
      result := Dst;
  end;
end;

function AbsolutePathToRelative(const AbsolutePath, BasePath: string): string;
var
  Path: array[0..259] of char;
begin
  result := AbsolutePath;
  if not TPath.IsRelativePath(AbsolutePath) then
  begin
    PathRelativePathTo(@Path[0], PChar(BasePath), FILE_ATTRIBUTE_DIRECTORY, PChar(AbsolutePath), 0);
    if Path <> '' then
      result := Path;
  end;
end;

procedure ExecuteAndWait(const APath, ACommand: string);
var
  output: AnsiString;
begin
  RunCommandIndir(APath, 'cmd', ['/c', ACommand], output, [poNoConsole]);
end;

procedure OpenFile(const AFileName: String);
begin
  if FileExists(AFileName) then
    ShellExecute(HInstance, 'open', PWideChar(AFileName), '', '', SW_SHOWNORMAL);
end;

procedure OpenUrl(const Url: String);
begin
  ShellExecute(HInstance, 'open', PWideChar( Url ), '', '', SW_SHOWNORMAL);
end;

end.
