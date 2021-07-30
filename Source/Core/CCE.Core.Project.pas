unit CCE.Core.Project;

interface

uses
  Dccstrs,
  ToolsAPI,
  CCE.Core.Interfaces,
  CCE.Core.Utils,
  System.Generics.Collections,
  System.IOUtils,
  System.SysUtils,
  System.Types,
  System.Classes;

const
  TEST_INSIGHT = 'TESTINSIGHT';

type TCCECoreProject = class(TInterfacedObject, ICCEProject)

  private
    FProject: IOTAProject;
    FActiveConfig: IOTABuildConfiguration;
    FPaths: TList<String>;
    FUnits: TList<String>;

    function ProjectPath: string;
    function GetSearchPaths: TList<String>;

    procedure SetAllPaths;
    procedure SetAllUnits(Path: String);

    procedure AddPath(Value: String);
    procedure AddUnit(Value: String);
  public
    function OutputPath: string;
    function ExeName: String;
    function DprFileName: string;
    function MapFileName: string;

    function SetDetailedMapFile: ICCEProject;

    function ListAllPaths: TArray<String>;
    function ListAllUnits(Path: String): TArray<String>; overload;
    function ListAllUnits: TArray<String>; overload;

    function Build: ICCEProject;

    constructor create(Project: IOTAProject);
    class function New(Project: IOTAProject): ICCEProject;
    destructor Destroy; override;
end;

implementation

{ TCCECoreProject }

procedure TCCECoreProject.AddPath(Value: String);
begin
  if not FPaths.Contains(Value) then
    FPaths.Add(Value);
end;

procedure TCCECoreProject.AddUnit(Value: String);
begin
  if not FUnits.Contains(Value) then
    FUnits.Add(Value);
end;

function TCCECoreProject.Build: ICCEProject;
begin
  result := Self;
  FProject.ProjectBuilder
    .BuildProject(TOTACompileMode.cmOTABuild, True, True);
end;

constructor TCCECoreProject.create(Project: IOTAProject);
begin
  FProject := Project;
  FActiveConfig := (Project.ProjectOptions as IOTAProjectOptionsConfigurations)
                      .ActiveConfiguration;

  FPaths := TList<String>.create;
  FUnits := TList<String>.create;

  SetAllPaths;
end;

destructor TCCECoreProject.Destroy;
begin
  FPaths.Free;
  FUnits.Free;
  inherited;
end;

function TCCECoreProject.DprFileName: string;
begin
  result := FProject.FileName;
end;

function TCCECoreProject.ExeName: String;
begin
  Result := OutputPath +
                ChangeFileExt(ExtractFileName(FProject.FileName), '.exe');
end;

function TCCECoreProject.GetSearchPaths: TList<String>;
var
  searchPath: TStrings;
  path: string;
  i: Integer;
begin
  searchPath := TStringList.Create;
  try
    result := TList<String>.create;
    try
      FActiveConfig.GetValues(sUnitSearchPath, searchPath, True);
      for i := 0 to Pred(searchPath.Count) do
      begin
        path := RelativeToAbsolutePath(searchPath[i], ProjectPath);
        result.Add(path);
      end;

    except
      result.Free;
    end;
  finally
    searchPath.Free;
  end;
end;

function TCCECoreProject.ListAllPaths: TArray<String>;
begin
  result := FPaths.ToArray;
end;

function TCCECoreProject.ListAllUnits: TArray<String>;
begin
  result := FUnits.ToArray;
end;

function TCCECoreProject.ListAllUnits(Path: String): TArray<String>;
var
  i: Integer;
  unitPath: string;
begin
  if not Path.EndsWith('\') then
    Path := Path + '\';

  for i := 0 to Pred(FUnits.Count) do
  begin
    unitPath := ExtractFilePath(FUnits[i]).ToLower;
    if Path.ToLower = unitPath then
    begin
      SetLength(result, Length(result) + 1);
      result[Length(result) - 1] := FUnits[i];
    end;
  end;
end;

function TCCECoreProject.MapFileName: string;
begin
  result := ChangeFileExt(ExeName, '.map');
end;

class function TCCECoreProject.New(Project: IOTAProject): ICCEProject;
begin
  result := Self.create(Project);
end;

function TCCECoreProject.OutputPath: string;
begin
  result := FActiveConfig.GetValue(sExeOutput);
  result := RelativeToAbsolutePath(Result, ProjectPath)
                 .Replace('$(Platform)', FActiveConfig.Platform)
                 .Replace('$(Config)', FActiveConfig.Name) + '\';

  result := Result.Replace('\\', '\');
end;

function TCCECoreProject.ProjectPath: string;
begin
  result := ExtractFilePath(FProject.FileName);
end;

procedure TCCECoreProject.SetAllPaths;
var
  i: Integer;
  searchPath: TList<String>;
  path: string;
begin
  for i := 0 to Pred(FProject.GetModuleCount) do
  begin
    if ExtractFileExt(FProject.GetModule(i).FileName) = '.pas' then
    begin
      path := ExtractFilePath(FProject.GetModule(i).FileName);
      AddPath(path);

      SetAllUnits(path);
    end;
  end;

  searchPath := Self.GetSearchPaths;
  try
    for i := 0 to Pred(searchPath.Count) do
    begin
      path := searchPath.Items[i];
      AddPath(path);

      SetAllUnits(path);
    end;
  finally
    searchPath.Free;
  end;
end;

procedure TCCECoreProject.SetAllUnits(Path: String);
var
  i: Integer;
  files: TStringDynArray;
begin
  files := TDirectory.GetFiles(Path);

  for i := 0 to Pred(Length(files)) do
  begin
    if ExtractFileExt(files[i]) = '.pas' then
      AddUnit(files[i]);
  end;
end;

function TCCECoreProject.SetDetailedMapFile: ICCEProject;
begin
  result := Self;
  FActiveConfig.SetValue('DCC_MapFile', '3');
  FProject.Save(False, True);
  FProject.Refresh(True);
end;

end.
