unit CCE.ContextMenu;

interface

uses
  ToolsAPI,
  CCE.Constants,
  CCE.Wizard.Forms,
  System.Classes,
  System.SysUtils;

type
  TCCEOnContextMenuClick = procedure (const MenuContextList: IInterfaceList) of object;

  TCCEContextMenuWizard = class(TNotifierObject, IOTAProjectMenuItemCreatorNotifier)
  private
    FProject: IOTAProject;

    procedure Initialize(Project: IOTAProject);

    procedure OnExecuteCodeCoverageWizard(const MenuContextList: IInterfaceList);

    function AddMenu(Caption: String;
                     Position: Integer;
                     Parent: string = '';
                     OnExecute: TCCEOnContextMenuClick = nil;
                     Checked: Boolean = False): IOTAProjectManagerMenu; overload;
  protected
    procedure AddMenu(const Project: IOTAProject;
                      const IdentList: TStrings;
                      const MenuList: IInterfaceList;
                            IsMultiSelect: Boolean); overload;

  public
    class function New: IOTAProjectMenuItemCreatorNotifier;
  end;

  TCCEContextMenu = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
  private
    FCaption: String;
    FIsMultiSelectable: Boolean;
    FChecked: Boolean;
    FEnabled: Boolean;
    FHelpContext: Integer;
    FName: string;
    FParent: string;
    FPosition: Integer;
    FVerb: string;

  protected
    FProject: IOTAProject;
    FOnExecute: TCCEOnContextMenuClick;

    function GetCaption: string;
    function GetChecked: Boolean;
    function GetEnabled: Boolean;
    function GetHelpContext: Integer;
    function GetName: string;
    function GetParent: string;
    function GetPosition: Integer;
    function GetVerb: string;
    procedure SetCaption(const Value: string);
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetHelpContext(Value: Integer);
    procedure SetName(const Value: string);
    procedure SetParent(const Value: string);
    procedure SetPosition(Value: Integer);
    procedure SetVerb(const Value: string);
    function GetIsMultiSelectable: Boolean;
    procedure SetIsMultiSelectable(Value: Boolean);
    procedure Execute(const MenuContextList: IInterfaceList); virtual;
    function PreExecute(const MenuContextList: IInterfaceList): Boolean;
    function PostExecute(const MenuContextList: IInterfaceList): Boolean;

    constructor create(OnExecute: TCCEOnContextMenuClick); overload;
    class function New(OnExecute: TCCEOnContextMenuClick): IOTAProjectManagerMenu; overload;
  end;

var
  IndexContextMenuCoverage: Integer = -1;

procedure RegisterContextMenu;

implementation

procedure RegisterContextMenu;
begin
  IndexContextMenuCoverage := (BorlandIDEServices as IOTAProjectManager)
    .AddMenuItemCreatorNotifier(TCCEContextMenuWizard.New);
end;

{ TCCEContextMenu }

constructor TCCEContextMenu.create(OnExecute: TCCEOnContextMenuClick);
begin
  FOnExecute := OnExecute;
  FEnabled := True;
  FChecked := False;
  FIsMultiSelectable := False;
end;

procedure TCCEContextMenu.Execute(const MenuContextList: IInterfaceList);
begin
  if Assigned(FOnExecute) then
    FOnExecute(MenuContextList);
end;

function TCCEContextMenu.GetCaption: string;
begin
  result := FCaption;
end;

function TCCEContextMenu.GetChecked: Boolean;
begin
  result := FChecked;
end;

function TCCEContextMenu.GetEnabled: Boolean;
begin
  result := FEnabled;
end;

function TCCEContextMenu.GetHelpContext: Integer;
begin
  result := FHelpContext;
end;

function TCCEContextMenu.GetIsMultiSelectable: Boolean;
begin
  Result := FIsMultiSelectable;
end;

function TCCEContextMenu.GetName: string;
begin
  result := FName;
end;

function TCCEContextMenu.GetParent: string;
begin
  result := FParent;
end;

function TCCEContextMenu.GetPosition: Integer;
begin
  result := FPosition;
end;

function TCCEContextMenu.GetVerb: string;
begin
  result := FVerb;
end;

class function TCCEContextMenu.New(OnExecute: TCCEOnContextMenuClick): IOTAProjectManagerMenu;
begin
  result := Self.create(OnExecute);
end;

function TCCEContextMenu.PostExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  result := True;
end;

function TCCEContextMenu.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  result := True;
end;

procedure TCCEContextMenu.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TCCEContextMenu.SetChecked(Value: Boolean);
begin
  FChecked := Value;
end;

procedure TCCEContextMenu.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TCCEContextMenu.SetHelpContext(Value: Integer);
begin
  FHelpContext := Value;
end;

procedure TCCEContextMenu.SetIsMultiSelectable(Value: Boolean);
begin
  FIsMultiSelectable := Value;
end;

procedure TCCEContextMenu.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TCCEContextMenu.SetParent(const Value: string);
begin
  FParent := Value;
end;

procedure TCCEContextMenu.SetPosition(Value: Integer);
begin
  FPosition := Value;
end;

procedure TCCEContextMenu.SetVerb(const Value: string);
begin
  FVerb := Value;
end;

{ TCCEContextMenuWizard }

procedure TCCEContextMenuWizard.AddMenu(const Project: IOTAProject;
  const IdentList: TStrings; const MenuList: IInterfaceList;
  IsMultiSelect: Boolean);
begin
  if (IdentList.IndexOf(sProjectContainer) < 0) or
     (not Assigned(MenuList))
  then
    Exit;

  Initialize(Project);

  MenuList.Add(AddMenu(CCE_COVERAGE_CAPTION, CCE_COVERAGE_POSITION, '', OnExecuteCodeCoverageWizard));
end;

function TCCEContextMenuWizard.AddMenu(Caption: String; Position: Integer;
  Parent: string; OnExecute: TCCEOnContextMenuClick;
  Checked: Boolean): IOTAProjectManagerMenu;
begin
  result := TCCEContextMenu.New(OnExecute);
  Result.Caption := Caption;
  result.Verb := Caption;
  Result.Parent := Parent;
  result.Position := Position;
  result.Checked := Checked;
  result.IsMultiSelectable := False;
end;

procedure TCCEContextMenuWizard.Initialize(Project: IOTAProject);
begin
  FProject := Project;
end;

class function TCCEContextMenuWizard.New: IOTAProjectMenuItemCreatorNotifier;
begin
  result := Self.Create;
end;

procedure TCCEContextMenuWizard.OnExecuteCodeCoverageWizard(const MenuContextList: IInterfaceList);
begin
  if not Assigned(CCEWizardForms) then
    CCEWizardForms := TCCEWizardForms.Create(nil, FProject);

  CCEWizardForms.Show;
end;

initialization

finalization
  if IndexContextMenuCoverage >= 0 then
    (BorlandIDEServices as IOTAProjectManager)
      .RemoveMenuItemCreatorNotifier(IndexContextMenuCoverage);

end.
