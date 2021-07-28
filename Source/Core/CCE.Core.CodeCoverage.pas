unit CCE.Core.CodeCoverage;

interface

uses
  CCE.Core.Interfaces,
  CCE.Core.Utils,
  System.SysUtils,
  System.Classes,
  Winapi.ShellAPI,
  Winapi.Windows,
  Vcl.Dialogs;

type TCCECoreCodeCoverage = class(TInterfacedObject, ICCECodeCoverage)

  private
    FCodeCoverageFileName: String;
    FExeFileName: String;
    FMapFileName: String;
    FOutputReport: String;
    FPaths: TArray<String>;
    FUnits: TArray<String>;
    FGenerateHtml: Boolean;
    FGenerateXml: Boolean;
    FGenerateEmma: Boolean;
    FGenerateLog: Boolean;
    FUseRelativePath: Boolean;

    function FilePathsName: String;
    function FileUnitsName: String;
    function FileCodeCoverageBat: string;
    function CodeCoverageCommand: String;

    function BasePath: string;

    procedure GenerateFilePaths;
    procedure GenerateFileUnits;

    function GetExeName: String;
    function GetMapName: String;
    function GetOutputReport: string;
    function GetFileUnits: String;
    function GetFilePaths: string;
    function GetReportHTMLName: String;
    function GetReportXMLName: String;
    function GetCoverageLogFileName: string;
  protected
    function CodeCoverageFileName(Value: String): ICCECodeCoverage;
    function ExeFileName(Value: String): ICCECodeCoverage;
    function MapFileName(Value: String): ICCECodeCoverage;
    function OutputReport(Value: String): ICCECodeCoverage;
    function Paths(Values: TArray<String>): ICCECodeCoverage;
    function Units(Values: TArray<String>): ICCECodeCoverage;
    function GenerateHtml(Value: Boolean): ICCECodeCoverage;
    function GenerateXml(Value: Boolean): ICCECodeCoverage;
    function GenerateEmma(Value: Boolean): ICCECodeCoverage;
    function GenerateLog(Value: Boolean): ICCECodeCoverage;
    function UseRelativePath(Value: Boolean): ICCECodeCoverage;

    function Save: ICCECodeCoverage;
    function Execute: ICCECodeCoverage;

    function ShowHTMLReport: ICCECodeCoverage;
    function ShowXMLReport: ICCECodeCoverage;
    function ShowLogCoverage: ICCECodeCoverage;

  public
    constructor create;
    class function New: ICCECodeCoverage;
end;

implementation

{ TCCECoreCodeCoverage }

function TCCECoreCodeCoverage.BasePath: string;
begin
  result := ExtractFilePath(FExeFileName);
end;

function TCCECoreCodeCoverage.CodeCoverageCommand: String;
begin
  result := '"%s" -e "%s" -m "%s" -uf "%s" -spf "%s" -od "%s" ';
  if FGenerateLog then
    result := result + '-lt ';

  if FGenerateHtml then
    result := result + '-html ';

  if FGenerateXml then
    result := result + '-xml';

  result := Format(Result, [FCodeCoverageFileName,
                            GetExeName,
                            GetMapName,
                            GetFileUnits,
                            GetFilePaths,
                            GetOutputReport]);
end;

function TCCECoreCodeCoverage.CodeCoverageFileName(Value: String): ICCECodeCoverage;
begin
  result := Self;
  FCodeCoverageFileName := Value;
end;

constructor TCCECoreCodeCoverage.create;
begin
  FCodeCoverageFileName := 'CodeCoverage.exe';
  FGenerateXml := True;
  FGenerateLog := True;
  FGenerateHtml := True;
  FGenerateEmma := True;
  FUseRelativePath := True;
end;

function TCCECoreCodeCoverage.Execute: ICCECodeCoverage;
begin
  result := Self;
  Save;

  ExecuteAndWait(BasePath, FileCodeCoverageBat);
//  Winexec(PAnsiChar(FileCodeCoverageBat), SW_NORMAL);
//  WinExec(PAnsiChar('C:\WINDOWS\Command.COM /C ' + FileCodeCoverageBat),SW_SHOW);
//  ShellExecute(HInstance, 'open', PChar(GetReportHTMLName), '', '', 0);
//  ShowMessage('foi');


end;

function TCCECoreCodeCoverage.ExeFileName(Value: String): ICCECodeCoverage;
begin
  result := Self;
  FExeFileName := Value;
end;

function TCCECoreCodeCoverage.FileCodeCoverageBat: string;
begin
  result := ExtractFilePath(FExeFileName) + 'dcov_execute.bat';
end;

function TCCECoreCodeCoverage.FilePathsName: String;
begin
  result := ExtractFilePath(FExeFileName) + 'dcov_paths.lst';
end;

function TCCECoreCodeCoverage.FileUnitsName: String;
begin
  result := ExtractFilePath(FExeFileName) + 'dcov_units.lst';
end;

function TCCECoreCodeCoverage.GenerateEmma(Value: Boolean): ICCECodeCoverage;
begin
  result := Self;
  FGenerateEmma := Value;
end;

procedure TCCECoreCodeCoverage.GenerateFilePaths;
var
  i: Integer;
  path: string;
begin
  with TStringList.Create do
  try
    for i := 0 to Pred(Length(FPaths)) do
    begin
      path := FPaths[i];
      if FUseRelativePath then
        path := AbsolutePathToRelative(path, BasePath);

      if not path.EndsWith('\') then
        path := path + '\';
      Add(path);
    end;

    SaveToFile(FilePathsName);
  finally
    Free;
  end;
end;

procedure TCCECoreCodeCoverage.GenerateFileUnits;
var
  i: Integer;
  unitFile: String;
begin
  with TStringList.Create do
  try
    for i := 0 to Pred(Length(FUnits)) do
    begin
      unitFile := ExtractFileName(FUnits[i]);
      Add(unitFile);
    end;

    SaveToFile(FileUnitsName);
  finally
    Free;
  end;
end;

function TCCECoreCodeCoverage.GenerateHtml(Value: Boolean): ICCECodeCoverage;
begin
  result := Self;
  FGenerateHtml := Value;
end;

function TCCECoreCodeCoverage.GenerateLog(Value: Boolean): ICCECodeCoverage;
begin
  result := Self;
  FGenerateLog := Value;
end;

function TCCECoreCodeCoverage.GenerateXml(Value: Boolean): ICCECodeCoverage;
begin
  result := Self;
  FGenerateXml := Value;
end;

function TCCECoreCodeCoverage.GetCoverageLogFileName: string;
begin
  result := BasePath + '\Delphi-Code-Coverage-Debug.log';
end;

function TCCECoreCodeCoverage.GetExeName: String;
begin
  result := FExeFileName;
  if FUseRelativePath then
    result := AbsolutePathToRelative(FExeFileName, BasePath);
end;

function TCCECoreCodeCoverage.GetFilePaths: string;
begin
  result := FilePathsName;
  if FUseRelativePath then
    result := AbsolutePathToRelative(FilePathsName, BasePath);
end;

function TCCECoreCodeCoverage.GetFileUnits: String;
begin
  result := FileUnitsName;
  if FUseRelativePath then
    result := AbsolutePathToRelative(FileUnitsName, BasePath);
end;

function TCCECoreCodeCoverage.GetMapName: String;
begin
  result := FMapFileName;
  if FUseRelativePath then
    result := AbsolutePathToRelative(FMapFileName, BasePath);
end;

function TCCECoreCodeCoverage.GetOutputReport: string;
begin
  result := FOutputReport;
  if FUseRelativePath then
    result := AbsolutePathToRelative(FOutputReport, BasePath);
end;

function TCCECoreCodeCoverage.GetReportHTMLName: String;
begin
  result := FOutputReport + '\CodeCoverage_summary.html';
end;

function TCCECoreCodeCoverage.GetReportXMLName: String;
begin
  result := FOutputReport + '\CodeCoverage_Summary.xml';
end;

function TCCECoreCodeCoverage.MapFileName(Value: String): ICCECodeCoverage;
begin
  result := Self;
  FMapFileName := Value;
end;

class function TCCECoreCodeCoverage.New: ICCECodeCoverage;
begin
  result := Self.Create;
end;

function TCCECoreCodeCoverage.OutputReport(Value: String): ICCECodeCoverage;
begin
  result := Self;
  FOutputReport := Value;
end;

function TCCECoreCodeCoverage.Paths(Values: TArray<String>): ICCECodeCoverage;
begin
  result := Self;
  FPaths := Values;
end;

function TCCECoreCodeCoverage.Save: ICCECodeCoverage;
begin
  Result := Self;
  GenerateFilePaths;
  GenerateFileUnits;

  with TStringList.Create do
  try
    Text := CodeCoverageCommand;
    SaveToFile(FileCodeCoverageBat);
  finally
    Free;
  end;
end;

function TCCECoreCodeCoverage.ShowHTMLReport: ICCECodeCoverage;
begin
  result := Self;
  CCE.Core.Utils.OpenFile(GetReportHTMLName);
end;

function TCCECoreCodeCoverage.ShowLogCoverage: ICCECodeCoverage;
begin
  result := Self;
  CCE.Core.Utils.OpenFile(GetCoverageLogFileName);
end;

function TCCECoreCodeCoverage.ShowXMLReport: ICCECodeCoverage;
begin
  result := Self;
  CCE.Core.Utils.OpenFile(GetReportXMLName);
end;

function TCCECoreCodeCoverage.Units(Values: TArray<String>): ICCECodeCoverage;
begin
  result := Self;
  FUnits := Values;
end;

function TCCECoreCodeCoverage.UseRelativePath(Value: Boolean): ICCECodeCoverage;
begin
  result := Self;
  FUseRelativePath := Value;
end;

end.
