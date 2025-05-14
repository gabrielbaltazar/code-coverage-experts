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

type
  TCCECoreCodeCoverage = class(TInterfacedObject, ICCECodeCoverage)
  private
    FCodeCoverageFileName: string;
    FExeFileName: string;
    FMapFileName: string;
    FOutputReport: string;
    FUnitsFiles: TList<string>;
    FUnitsIgnore: TList<string>;
    FPaths: TList<string>;
    FGenerateHtml: Boolean;
    FGenerateXml: Boolean;
    FGenerateEmma: Boolean;
    FGenerateLog: Boolean;
    FUseRelativePath: Boolean;

    function FileToList(AFileName: string): TList<string>;

    function FilePathsName: string;
    function FileUnitsName: string;
    function FileCodeCoverageBat: string;
    function CodeCoverageCommand: string;

    procedure GenerateFilePaths;
    procedure GenerateFileUnits;

    function GetExeName: string;
    function GetMapName: string;
    function GetOutputReport: string;
    function GetFileUnits: string;
    function GetFilePaths: string;
    function GetReportHTMLName: string;
    function GetReportXMLName: string;
    function GetCoverageLogFileName: string;

    function ContainsIn(Value: string; AList: TList<string>): Boolean;
  protected
    function BasePath: string;
    function Clear: ICCECodeCoverage;

    function CodeCoverageFileName(Value: string): ICCECodeCoverage;
    function ExeFileName(Value: string): ICCECodeCoverage;
    function MapFileName(Value: string): ICCECodeCoverage;
    function OutputReport(Value: string): ICCECodeCoverage;
    function Paths(Values: TArray<string>): ICCECodeCoverage;
    function Units(Values: TArray<string>): ICCECodeCoverage;
    function GenerateHtml(Value: Boolean): ICCECodeCoverage;
    function GenerateXml(Value: Boolean): ICCECodeCoverage;
    function GenerateEmma(Value: Boolean): ICCECodeCoverage;
    function GenerateLog(Value: Boolean): ICCECodeCoverage;
    function UseRelativePath(Value: Boolean): ICCECodeCoverage;

    function IsInCovUnits(AUnitName: string): Boolean;
    function IgnoredUnits: TArray<string>;

    function AddUnit(Value: string): ICCECodeCoverage;
    function AddUnitIgnore(Value: string): ICCECodeCoverage;
    function AddPath(Value: string): ICCECodeCoverage;

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

function TCCECoreCodeCoverage.AddPath(Value: string): ICCECodeCoverage;
begin
  Result := Self;
  if not ContainsIn(Value, FPaths) then
    FPaths.Add(Value);
end;

function TCCECoreCodeCoverage.AddUnit(Value: string): ICCECodeCoverage;
begin
  Result := Self;
  if not ContainsIn(Value, FUnitsFiles) then
    FUnitsFiles.Add(Value);
end;

function TCCECoreCodeCoverage.AddUnitIgnore(Value: string): ICCECodeCoverage;
var
  LValue: string;
begin
  Result := Self;
  LValue := Value;
  if LValue.StartsWith('!') then
    LValue := Copy(LValue, 2, LValue.Length);

  if not FUnitsIgnore.Contains(LValue) then
    FUnitsIgnore.Add(LValue);
end;

function TCCECoreCodeCoverage.BasePath: string;
begin
  Result := ExtractFilePath(FExeFileName);
end;

function TCCECoreCodeCoverage.Clear: ICCECodeCoverage;
begin
  Result := Self;
  FUnitsFiles.Clear;
  FUnitsIgnore.Clear;
  FPaths.Clear;
end;

function TCCECoreCodeCoverage.CodeCoverageCommand: string;
begin
  Result := '"%s" -e "%s" -m "%s" -uf "%s" -spf "%s" -od "%s" ';
  if FGenerateLog then
    Result := Result + '-lt ';

  if FGenerateEmma then
    Result := Result + '-emma -meta ';

  if FGenerateHtml then
    Result := Result + '-html ';

  if FGenerateXml then
    Result := Result + '-xml -xmllines';

  Result := Format(Result, [FCodeCoverageFileName,
                            GetExeName,
                            GetMapName,
                            GetFileUnits,
                            GetFilePaths,
                            GetOutputReport]);
end;

function TCCECoreCodeCoverage.CodeCoverageFileName(Value: string): ICCECodeCoverage;
begin
  Result := Self;
  FCodeCoverageFileName := Value;
end;

function TCCECoreCodeCoverage.ContainsIn(Value: string; AList: TList<string>): Boolean;
var
  listValue: string;
begin
  Result := False;
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

  FUnitsFiles := TList<string>.create;
  FUnitsIgnore := TList<string>.create;
  FPaths := TList<string>.create;
end;

destructor TCCECoreCodeCoverage.Destroy;
begin
  FUnitsFiles.Free;
  FPaths.Free;
  FUnitsIgnore.Free;
  inherited;
end;

function TCCECoreCodeCoverage.Execute: ICCECodeCoverage;
begin
  Result := Self;

  ExecuteAndWait(BasePath, FileCodeCoverageBat);
end;

function TCCECoreCodeCoverage.ExeFileName(Value: string): ICCECodeCoverage;
begin
  Result := Self;
  FExeFileName := Value;
end;

function TCCECoreCodeCoverage.FileCodeCoverageBat: string;
begin
  Result := ExtractFilePath(FExeFileName) + 'dcov_execute.bat';
end;

function TCCECoreCodeCoverage.FilePathsName: string;
begin
  Result := ExtractFilePath(FExeFileName) + 'dcov_paths.lst';
end;

function TCCECoreCodeCoverage.FileToList(AFileName: string): TList<string>;
var
  LFile: TStrings;
  i: Integer;
begin
  Result := TList<string>.create;
  try
    LFile := TStringList.Create;
    try
      if FileExists(AFileName) then
      begin
        LFile.LoadFromFile(AFileName);
        for i := 0 to Pred(LFile.Count) do
          Result.Add(LFile[i]);
      end;
    finally
      LFile.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TCCECoreCodeCoverage.FileUnitsName: string;
begin
  Result := ExtractFilePath(FExeFileName) + 'dcov_units.lst';
end;

function TCCECoreCodeCoverage.GenerateEmma(Value: Boolean): ICCECodeCoverage;
begin
  Result := Self;
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
  unitFile: string;
  i : Integer;
begin
  with TStringList.Create do
  try
    for i := 0 to Pred(FUnitsIgnore.Count) do
      Add('!' + FUnitsIgnore[i]);

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
  Result := Self;
  FGenerateHtml := Value;
end;

function TCCECoreCodeCoverage.GenerateLog(Value: Boolean): ICCECodeCoverage;
begin
  Result := Self;
  FGenerateLog := Value;
end;

function TCCECoreCodeCoverage.GenerateXml(Value: Boolean): ICCECodeCoverage;
begin
  Result := Self;
  FGenerateXml := Value;
end;

function TCCECoreCodeCoverage.GetCoverageLogFileName: string;
begin
  Result := BasePath + '\Delphi-Code-Coverage-Debug.log';
end;

function TCCECoreCodeCoverage.GetExeName: string;
begin
  Result := FExeFileName;
  if FUseRelativePath then
    Result := AbsolutePathToRelative(FExeFileName, BasePath);
end;

function TCCECoreCodeCoverage.GetFilePaths: string;
begin
  Result := FilePathsName;
  if FUseRelativePath then
    Result := AbsolutePathToRelative(FilePathsName, BasePath);
end;

function TCCECoreCodeCoverage.GetFileUnits: string;
begin
  Result := FileUnitsName;
  if FUseRelativePath then
    Result := AbsolutePathToRelative(FileUnitsName, BasePath);
end;

function TCCECoreCodeCoverage.GetMapName: string;
begin
  Result := FMapFileName;
  if FUseRelativePath then
    Result := AbsolutePathToRelative(FMapFileName, BasePath);
end;

function TCCECoreCodeCoverage.GetOutputReport: string;
begin
  Result := FOutputReport;
  if FUseRelativePath then
    Result := AbsolutePathToRelative(FOutputReport, BasePath);
end;

function TCCECoreCodeCoverage.GetReportHTMLName: string;
begin
  Result := FOutputReport + '\CodeCoverage_summary.html';
end;

function TCCECoreCodeCoverage.GetReportXMLName: string;
begin
  Result := FOutputReport + '\CodeCoverage_Summary.xml';
end;

function TCCECoreCodeCoverage.IgnoredUnits: TArray<string>;
var
  LUnits: TList<string>;
  i: Integer;
begin
  LUnits := FileToList(FileUnitsName);
  try
    for i := 0 to Pred(LUnits.Count) do
    begin
      if LUnits[i].StartsWith('!') then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1] := Copy(LUnits[i], 2, LUnits[i].Length).Trim;
      end;
    end;
  finally
    LUnits.Free;
  end;
end;

function TCCECoreCodeCoverage.IsInCovUnits(AUnitName: string): Boolean;
var
  LPaths: TList<string>;
  LUnits: TList<string>;
  LUnitName: string;
  LPath: string;
begin
  LPaths := FileToList(FilePathsName);
  LUnits := FileToList(FileUnitsName);
  try
    LPath := ExtractFilePath(AUnitName);
    if FUseRelativePath then
      LPath := AbsolutePathToRelative(LPath, BasePath);

    LUnitName := ExtractFileName(AUnitName);

    Result := (LPaths.Contains(LPath)) and (LUnits.Contains(LUnitName));
  finally
    LPaths.Free;
    LUnits.Free;
  end;
end;

function TCCECoreCodeCoverage.MapFileName(Value: string): ICCECodeCoverage;
begin
  Result := Self;
  FMapFileName := Value;
end;

class function TCCECoreCodeCoverage.New: ICCECodeCoverage;
begin
  Result := Self.Create;
end;

function TCCECoreCodeCoverage.OutputReport(Value: string): ICCECodeCoverage;
begin
  Result := Self;
  FOutputReport := Value;
end;

function TCCECoreCodeCoverage.Paths(Values: TArray<string>): ICCECodeCoverage;
var
  i: Integer;
begin
  Result := Self;
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
  Result := Self;
  CCE.Core.Utils.OpenFile(GetReportHTMLName);
end;

function TCCECoreCodeCoverage.ShowLogCoverage: ICCECodeCoverage;
begin
  Result := Self;
  CCE.Core.Utils.OpenFile(GetCoverageLogFileName);
end;

function TCCECoreCodeCoverage.ShowXMLReport: ICCECodeCoverage;
begin
  Result := Self;
  CCE.Core.Utils.OpenFile(GetReportXMLName);
end;

function TCCECoreCodeCoverage.Units(Values: TArray<string>): ICCECodeCoverage;
var
  i: Integer;
begin
  Result := Self;
  for i := 0 to Pred(Length(Values)) do
    AddUnit(Values[i]);
end;

function TCCECoreCodeCoverage.UseRelativePath(Value: Boolean): ICCECodeCoverage;
begin
  Result := Self;
  FUseRelativePath := Value;
end;

end.
