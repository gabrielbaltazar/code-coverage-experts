unit CCE.Core.CodeCoverage;

interface

uses
  CCE.Core.Interfaces,
  CCE.Core.Utils,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Winapi.Windows,
  Vcl.Dialogs;

type TCCECoreCodeCoverage = class(TInterfacedObject, ICCECodeCoverage)

  private
    FCodeCoverageFileName: String;
    FExeFileName: String;
    FMapFileName: String;
    FOutputReport: String;
    FUnitsFiles: TList<string>;
    FPaths: TList<string>;
    FGenerateHtml: Boolean;
    FGenerateXml: Boolean;
    FGenerateEmma: Boolean;
    FGenerateLog: Boolean;
    FUseRelativePath: Boolean;

    function FilePathsName: String;
    function FileUnitsName: String;
    function FileCodeCoverageBat: string;
    function CodeCoverageCommand: String;

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

    function ContainsIn(Value: String; AList: TList<String>): Boolean;
  protected
    function BasePath: string;
    function Clear: ICCECodeCoverage;

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

    function AddUnit(Value: String): ICCECodeCoverage;
    function AddPath(Value: String): ICCECodeCoverage;

    function Save: ICCECodeCoverage;
    function Execute: ICCECodeCoverage;

    function ShowHTMLReport: ICCECodeCoverage;
    function ShowXMLReport: ICCECodeCoverage;
    function ShowLogCoverage: ICCECodeCoverage;

  public
    constructor create;
    class function New: ICCECodeCoverage;
    destructor Destroy; override;
end;

implementation

{ TCCECoreCodeCoverage }

function TCCECoreCodeCoverage.AddPath(Value: String): ICCECodeCoverage;
begin
  result := Self;
  if not ContainsIn(Value, FPaths) then
    FPaths.Add(Value);
end;

function TCCECoreCodeCoverage.AddUnit(Value: String): ICCECodeCoverage;
begin
  result := Self;
  if not ContainsIn(Value, FUnitsFiles) then
    FUnitsFiles.Add(Value);
end;

function TCCECoreCodeCoverage.BasePath: string;
begin
  result := ExtractFilePath(FExeFileName);
end;

function TCCECoreCodeCoverage.Clear: ICCECodeCoverage;
begin
  result := Self;
  FUnitsFiles.Clear;
  FPaths.Clear;
end;

function TCCECoreCodeCoverage.CodeCoverageCommand: String;
begin
  result := '"%s" -e "%s" -m "%s" -uf "%s" -spf "%s" -od "%s" ';
  if FGenerateLog then
    result := result + '-lt ';

  if FGenerateEmma then
    result := result + '-emma -meta ';

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

function TCCECoreCodeCoverage.ContainsIn(Value: String; AList: TList<String>): Boolean;
var
  listValue: string;
begin
  result := False;
  for listValue in AList do
  begin
    if listValue.ToLower.Equals(Value.ToLower) then
      Exit(True);
  end;
end;

constructor TCCECoreCodeCoverage.create;
begin
  FCodeCoverageFileName := 'CodeCoverage.exe';
  FGenerateXml := True;
  FGenerateLog := True;
  FGenerateHtml := True;
  FGenerateEmma := True;
  FUseRelativePath := True;

  FUnitsFiles := TList<String>.create;
  FPaths := TList<String>.create;
end;

destructor TCCECoreCodeCoverage.Destroy;
begin
  FUnitsFiles.Free;
  FPaths.Free;
  inherited;
end;

function TCCECoreCodeCoverage.Execute: ICCECodeCoverage;
begin
  result := Self;

  ExecuteAndWait(BasePath, FileCodeCoverageBat);
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
  path: string;
  i : Integer;
begin
  with TStringList.Create do
  try
    for i := 0 to Pred(FPaths.Count) do
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
  unitFile: String;
  i : Integer;
begin
  with TStringList.Create do
  try
    for i := 0 to Pred(FUnitsFiles.Count) do
    begin
      unitFile := ExtractFileName(FUnitsFiles[i]);
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
var
  i: Integer;
begin
  result := Self;
  for i := 0 to Pred(Length(Values)) do
    AddPath(Values[i]);
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
var
  i: Integer;
begin
  result := Self;
  for i := 0 to Pred(Length(Values)) do
    AddUnit(Values[i]);
end;

function TCCECoreCodeCoverage.UseRelativePath(Value: Boolean): ICCECodeCoverage;
begin
  result := Self;
  FUseRelativePath := Value;
end;

end.
