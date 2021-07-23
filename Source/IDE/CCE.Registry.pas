unit CCE.Registry;

interface

uses
  ToolsAPI,
  CCE.ContextMenu;

procedure Register;

implementation

procedure Register;
begin
  RegisterContextMenu;
end;

end.
