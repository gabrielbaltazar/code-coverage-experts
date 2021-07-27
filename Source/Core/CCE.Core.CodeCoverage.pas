unit CCE.Core.CodeCoverage;

interface

uses
  CCE.Core.Interfaces,
  System.SysUtils,
  System.Classes;

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

    procedure GenerateFilePaths;
    procedure GenerateFileUnits;
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

  public
    constructor create;
    class function New: ICCECodeCoverage;
end;

implementation

{ TCCECoreCodeCoverage }

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
                            FExeFileName,
                            FMapFileName,
                            FileUnitsName,
                            FilePathsName,
                            FOutputReport]);
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
  GenerateFilePaths;
  GenerateFileUnits;
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