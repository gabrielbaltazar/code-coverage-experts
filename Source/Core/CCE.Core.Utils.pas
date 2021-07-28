unit CCE.Core.Utils;

interface

uses
  System.SysUtils,
  System.Types,
  Vcl.Forms,
  Winapi.ShellAPI,
  Winapi.Windows;

function RelativeToAbsolutePath(const RelativePath, BasePath: string): string;
function AbsolutePathToRelative(const AbsolutePath, BasePath: string): string;

procedure ExecuteAndWait(const ACommand: string);
procedure OpenFile(const AFileName: String);

function PathCanonicalize(lpszDst: PChar; lpszSrc: PChar): LongBool; stdcall;
  external 'shlwapi.dll' name 'PathCanonicalizeW';

function PathRelativePathTo(pszPath: PChar; pszFrom: PChar; dwAttrFrom: DWORD;
  pszTo: PChar; dwAtrTo: DWORD): LongBool; stdcall; external 'shlwapi.dll' name 'PathRelativePathToW';

implementation

function RelativeToAbsolutePath(const RelativePath, BasePath: string): string;
var
  Dst: array[0..259] of char;
begin
  PathCanonicalize(@Dst[0], PChar(IncludeTrailingBackslash(BasePath) + RelativePath));
  result := Dst;
end;

function AbsolutePathToRelative(const AbsolutePath, BasePath: string): string;
var
  Path: array[0..259] of char;
begin
  PathRelativePathTo(@Path[0], PChar(BasePath), FILE_ATTRIBUTE_DIRECTORY, PChar(AbsolutePath), 0);
  result := Path;
end;

procedure ExecuteAndWait(const ACommand: string);
var
  tmpStartupInfo: TStartupInfo;
  tmpProcessInformation: TProcessInformation;
  tmpProgram: String;
begin
  tmpProgram := trim(ACommand);
  FillChar(tmpStartupInfo, SizeOf(tmpStartupInfo), 0);
  with tmpStartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := SW_SHOWNORMAL;
  end;

  if CreateProcess(nil, pchar(tmpProgram), nil, nil, true, CREATE_NO_WINDOW,
    nil, nil, tmpStartupInfo, tmpProcessInformation) then
  begin
    // loop every 10 ms
    while WaitForSingleObject(tmpProcessInformation.hProcess, 10) > 0 do
    begin
      Application.ProcessMessages;
    end;
    CloseHandle(tmpProcessInformation.hProcess);
    CloseHandle(tmpProcessInformation.hThread);
  end
  else
  begin
    RaiseLastOSError;
  end;
end;

procedure OpenFile(const AFileName: String);
begin
  if FileExists(AFileName) then
    ShellExecute(HInstance, 'open', PWideChar(AFileName), '', '', SW_SHOWNORMAL);
end;

end.
