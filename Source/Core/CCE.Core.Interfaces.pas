unit CCE.Core.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes;

type
  ICCEProject = interface
    ['{676756F9-BEBC-4FCB-90AE-0B9843F7D126}']
    function Clear: ICCEProject;
    function ProjectPath: string;
    function OutputPath: string;
    function ExeName: String; overload;
    function MapFileName: string; overload;

    function SetDetailedMapFile: ICCEProject;

    function ListAllPaths: TArray<String>;
    function ListAllUnits(Path: String): TArray<String>; overload;
    function ListAllUnits: TArray<String>; overload;

    function AddPath(Value: string): ICCEProject;
    function AddUnit(Value: string): ICCEProject;

    function RemovePath(Value: String): ICCEProject;
    function RemoveUnit(Value: String): ICCEProject;

    function Build: ICCEProject;
  end;

  ICCECodeCoverage = interface
    ['{DCE40126-F975-4BAA-8CAE-3BD2ED2AF6EF}']
    function BasePath: string;
    function CodeCoverageFileName(Value: String): ICCECodeCoverage;
    function ExeFileName(Value: String): ICCECodeCoverage; overload;
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
  end;

implementation

end.
