unit CCE.Core.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes;

type
  ICCEProject = interface
    ['{676756F9-BEBC-4FCB-90AE-0B9843F7D126}']
    function ProjectPath: string;
    function OutputPath: string;
    function ExeName: String;
    function MapFileName: string;

    function ListAllPaths: TArray<String>;
    function ListAllUnits(Path: String): TArray<String>;

    function AddPath(Value: string): ICCEProject;
    function AddUnit(Value: string): ICCEProject;
    function AddAllUnits(Value: string): ICCEProject;

    function RemovePath(Value: String): ICCEProject;
    function RemoveUnit(Value: String): ICCEProject;
    function RemoveAllUnits(Path: String): ICCEProject;

    function OnRemoveUnit(Value: TProc<String>): ICCEProject;
    function OnRemovePath(Value: TProc<String>): ICCEProject;

    function OnAddUnit(Value: TProc<String>): ICCEProject;
    function OnAddPath(Value: TProc<String>): ICCEProject;

  end;

implementation

end.
