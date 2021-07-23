unit CCE.OTA.Utils;

interface

uses
  Dccstrs,
  ToolsAPI,
  System.IOUtils,
  System.SysUtils,
  System.Classes;

type TCCEOTAProject = class

  private
    FProject: IOTAProject;
    FActiveConfig: IOTABuildConfiguration;

  public
    function OutputPath: string;
    function ExeName: String;
    function MapFileName: string;

    constructor create(Project: IOTAProject);
end;

implementation

{ TCCEOTAProject }

constructor TCCEOTAProject.create(Project: IOTAProject);
begin
  FProject := Project;
  FActiveConfig := (Project.ProjectOptions as IOTAProjectOptionsConfigurations)
                      .ActiveConfiguration;
end;

function TCCEOTAProject.ExeName: String;
begin
  Result := OutputPath +
                ChangeFileExt(ExtractFileName(Project.FileName), '.exe');
end;

function TCCEOTAProject.MapFileName: string;
begin
  result := ChangeFileExt(ExeName, '.map');
end;

function TCCEOTAProject.OutputPath: string;
begin
  result := FActiveConfig.GetValue(sExeOutput);
  result := TPath.GetFullPath(result)
                 .Replace('$(Platform)', config.Platform)
                 .Replace('$(Config)', config.Name) + '\';

  result := Result.Replace('\\', '\');
end;

end.
