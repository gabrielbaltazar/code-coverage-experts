unit CCE.DLL.Registry;

interface

uses
  ToolsAPI,
  CCE.ContextMenu;

function RegisterCodeCoverageExperts(ABorlandIDEServices: IBorlandIDEServices;
  ARegisterProc: TWizardRegisterProc;
  var ATerminate: TWizardTerminateProc): Boolean; stdcall;

implementation

function RegisterCodeCoverageExperts(ABorlandIDEServices: IBorlandIDEServices;
  ARegisterProc: TWizardRegisterProc;
  var ATerminate: TWizardTerminateProc): Boolean; stdcall;
begin
  Result := True;
  RegisterContextMenu;
end;

end.
