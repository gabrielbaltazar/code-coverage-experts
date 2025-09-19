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
    function ExeName: string; overload;
    function DprFileName: string;
    function MapFileName: string; overload;

    function SetDetailedMapFile: ICCEProject;

    function ListAllPaths: TArray<string>;
    function ListAllUnits(APath: string): TArray<string>; overload;
    function ListAllUnits: TArray<string>; overload;

    function Build: ICCEProject;
  end;

  ICCECodeCoverage = interface
    ['{DCE40126-F975-4BAA-8CAE-3BD2ED2AF6EF}']
    function Clear: ICCECodeCoverage;
    function BasePath: string;
    function CodeCoverageFileName(AValue: string): ICCECodeCoverage;
    function ExeFileName(AValue: string): ICCECodeCoverage; overload;
    function MapFileName(AValue: string): ICCECodeCoverage;
    function OutputReport(Value: string): ICCECodeCoverage;
    function Paths(AValues: TArray<string>): ICCECodeCoverage;
    function Units(AValues: TArray<string>): ICCECodeCoverage;
    function GenerateHtml(AValue: Boolean): ICCECodeCoverage;
    function GenerateXml(AValue: Boolean): ICCECodeCoverage;
    function GenerateEmma(AValue: Boolean): ICCECodeCoverage;
    function GenerateLog(AValue: Boolean): ICCECodeCoverage;
    function UseRelativePath(AValue: Boolean): ICCECodeCoverage;
    function Jacoco(AValue: Boolean): ICCECodeCoverage;

    function IsInCovUnits(AUnitName: string): Boolean;
    function IgnoredUnits: TArray<string>;

    function AddUnit(AValue: string): ICCECodeCoverage;
    function AddUnitIgnore(AValue: string): ICCECodeCoverage;
    function AddPath(AValue: string): ICCECodeCoverage;

    function Save: ICCECodeCoverage;
    function Execute: ICCECodeCoverage;

    function ShowHTMLReport: ICCECodeCoverage;
    function ShowXMLReport: ICCECodeCoverage;
    function ShowLogCoverage: ICCECodeCoverage;
  end;

implementation

end.
