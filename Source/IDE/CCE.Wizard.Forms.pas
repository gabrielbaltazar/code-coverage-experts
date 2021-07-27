unit CCE.Wizard.Forms;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  ToolsAPI, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs,
  System.IOUtils,
  Vcl.FileCtrl,
  CCE.Core.Interfaces,
  CCE.Core.Project,
  CCE.Core.CodeCoverage,
  CCE.Helpers.CheckListBox,
  CCE.Helpers.TreeView,
  System.Generics.Collections, Vcl.CheckLst, Vcl.Menus, Vcl.Buttons;

type
  TCCEWizardForms = class(TForm)
    pgcWizard: TPageControl;
    tsFiles: TTabSheet;
    pnlBottom: TPanel;
    btnNext: TButton;
    btnPrevious: TButton;
    pnlTop: TPanel;
    lblTitle: TLabel;
    edtExeName: TLabeledEdit;
    btnSelectExeName: TButton;
    edtMapFileName: TLabeledEdit;
    btnSelectMapFile: TButton;
    edtCoverageExeName: TLabeledEdit;
    btnSelectCodeCoverage: TButton;
    tsPaths: TTabSheet;
    chklstPaths: TCheckListBox;
    Label1: TLabel;
    chkLstUnits: TCheckListBox;
    Label2: TLabel;
    pmPaths: TPopupMenu;
    SelectAll1: TMenuItem;
    UnselectAll1: TMenuItem;
    pmUnits: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    RemovePath1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    ChgeckUnits1: TMenuItem;
    edtOutputReport: TLabeledEdit;
    btnOutputReport: TButton;
    openTextDialog: TOpenTextFileDialog;
    grpOutputFormat: TGroupBox;
    chkXmlReport: TCheckBox;
    chkHtmlReport: TCheckBox;
    chkEmmaReport: TCheckBox;
    btnFinish: TButton;
    chkLog: TCheckBox;
    chkUseRelativePath: TCheckBox;
    tsTreeView: TTabSheet;
    tvPaths: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnSelectExeNameClick(Sender: TObject);
    procedure btnSelectCodeCoverageClick(Sender: TObject);
    procedure btnSelectMapFileClick(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure UnselectAll1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure RemovePath1Click(Sender: TObject);
    procedure btnOutputReportClick(Sender: TObject);
    procedure btnFinishClick(Sender: TObject);
    procedure tvPathsClick(Sender: TObject);
  private
    FProject: ICCEProject;
    FTreeNodes: TDictionary<String, TTreeNode>;

    function GetNode(APath: String): TTreeNode;
    procedure AddPathInTreeView(APath: String);

    procedure OnRemoveUnit(AUnit: String);
    procedure OnRemovePath(APath: String);
    procedure OnAddUnit(AUnit: String);
    procedure OnAddPath(APath: String);

    procedure searchFile(FilterText, FilterExt: string; AComponent: TCustomEdit);
    procedure selectFolder(AComponent: TCustomEdit);

    procedure ListPaths;
    procedure ListUnits(Path: String);

    procedure SelectAllPaths;
    procedure SelectAllUnits;

    procedure InitialValues;
    procedure ApplyTheme;
    procedure HideTabs;
    procedure SelectPageNext;
    procedure SelectPagePrevious;
  public
    constructor create(AOwner: TComponent; Project: IOTAProject); reintroduce;
    destructor Destroy; override;
    { Public declarations }
  end;

var
  CCEWizardForms: TCCEWizardForms;

implementation

{$R *.dfm}

{ TCCEWizardForms }

procedure TCCEWizardForms.AddPathInTreeView(APath: String);
var
  i: Integer;
  list: TStringList;
  nodeParent: TTreeNode;
  node: TTreeNode;
  text: String;
  pathParent: String;
  path: String;
begin
  list := TStringList.Create;
  try
    list.Delimiter := '\';
    list.StrictDelimiter := True;
    list.DelimitedText := APath;

    nodeParent := nil;
    pathParent := '';
    for i := 0 to Pred(list.Count) do
    begin
      text := list[i];
      if text = '' then
        Continue;
      path := path + text + '\';
      node := GetNode(path);
      if Assigned(node) then
        Continue;

      if i = 0 then
      begin
        nodeParent := tvPaths.Items.AddChild(nil, text);
//        nodeParent.
        FTreeNodes.Add(path, nodeParent);
        nodeParent := nil;
        Continue;
      end;

      pathParent := Copy(path, 1, path.length - text.Length - 1);
      nodeParent := GetNode(pathParent);
      if Assigned(nodeParent) then
      begin
        nodeParent := tvPaths.Items.AddChild(nodeParent, text);
        FTreeNodes.Add(path, nodeParent);
        nodeParent := nil;
        Continue;
      end;
    end;

  finally
    list.Free;
  end;
end;

procedure TCCEWizardForms.ApplyTheme;
{$IF CompilerVersion > 31.0}
var
  theme: IOTAIDEThemingServices250;
  i: Integer;
{$ENDIF}
begin
  {$IF CompilerVersion > 31.0}
  theme := (BorlandIDEServices as IOTAIDEThemingServices250);
  theme.RegisterFormClass(TCCEWizardForms);

  for i := 0 to Pred(Self.ComponentCount) do
  begin
    if Components[i] is TLabel then
      theme.ApplyTheme(TLabel(Components[i]));
//
//    if Components[i] is TComboBox then
//      theme.ApplyTheme(TComboBox(Components[i]));
//    if Components[i] is TPageControl then
//      theme.ApplyTheme(TPageControl(Components[i]));
//
//    if Components[i] is TTabSheet then
//      theme.ApplyTheme(TTabSheet(Components[i]));

    if Components[i] is TPanel then
      theme.ApplyTheme(TPanel(Components[i]));

    if Components[i] is TLabeledEdit then
      theme.ApplyTheme(TLabeledEdit(Components[i]));

  end;
//    theme.StyleServices.
  {$ENDIF}
end;

procedure TCCEWizardForms.btnPreviousClick(Sender: TObject);
begin
  SelectPagePrevious;
end;

procedure TCCEWizardForms.btnSelectCodeCoverageClick(Sender: TObject);
begin
  searchFile('Code Coverage File', 'exe', edtCoverageExeName);
end;

procedure TCCEWizardForms.btnSelectExeNameClick(Sender: TObject);
begin
  searchFile('Test Project', 'exe', edtExeName);
end;

procedure TCCEWizardForms.btnSelectMapFileClick(Sender: TObject);
begin
  searchFile('Map File', 'map', edtMapFileName);
end;

procedure TCCEWizardForms.btnFinishClick(Sender: TObject);
begin
  TCCECoreCodeCoverage.New
    .CodeCoverageFileName(edtCoverageExeName.Text)
    .ExeFileName(edtExeName.Text)
    .MapFileName(edtMapFileName.Text)
    .OutputReport(edtOutputReport.Text)
    .Paths(FProject.ListAllPaths)
    .Units(FProject.ListAllUnits)
    .GenerateHtml(chkHtmlReport.Checked)
    .GenerateXml(chkXmlReport.Checked)
    .GenerateEmma(chkEmmaReport.Checked)
    .GenerateLog(chkLog.Checked)
    .UseRelativePath(chkUseRelativePath.Checked)
    .Save;
end;

procedure TCCEWizardForms.btnNextClick(Sender: TObject);
begin
  SelectPageNext;
end;

procedure TCCEWizardForms.btnOutputReportClick(Sender: TObject);
begin
  selectFolder(edtOutputReport);
end;

constructor TCCEWizardForms.create(AOwner: TComponent; Project: IOTAProject);
begin
  inherited create(AOwner);
  FTreeNodes := TDictionary<String, TTreeNode>.create;
  FProject := TCCECoreProject.New(Project);
  FProject
    .OnAddUnit(Self.OnAddUnit)
    .OnAddPath(Self.OnAddPath)
    .OnRemoveUnit(Self.OnRemoveUnit)
    .OnRemovePath(Self.OnRemovePath);
end;

destructor TCCEWizardForms.Destroy;
begin
  FTreeNodes.Free;
  inherited;
end;

procedure TCCEWizardForms.FormCreate(Sender: TObject);
begin
  HideTabs;
  InitialValues;
end;

procedure TCCEWizardForms.FormShow(Sender: TObject);
begin
//  ApplyTheme;
end;

function TCCEWizardForms.GetNode(APath: String): TTreeNode;
begin
  result := nil;
  if FTreeNodes.ContainsKey(APath) then
    result := FTreeNodes.Items[APath];
end;

procedure TCCEWizardForms.HideTabs;
var
  i: Integer;
begin
  pgcWizard.ActivePageIndex := 0;

  for i := 0 to Pred(pgcWizard.PageCount) do
    pgcWizard.Pages[i].TabVisible := False;

  SelectPageNext;
end;

procedure TCCEWizardForms.InitialValues;
begin
//  edtExeName.Text := FProject.ExeName;
//  edtMapFileName.Text := FProject.MapFileName;

  ListPaths;
  SelectAllPaths;
  SelectAllUnits;
end;

procedure TCCEWizardForms.ListPaths;
var
  paths: TArray<String>;
  i: Integer;
begin
  paths := FProject.ListAllPaths;

  {$REGION 'CheckList'}
  for i := 0 to Pred(Length(paths)) do
    if TDirectory.Exists(paths[i]) then
    begin
      chklstPaths.AddOrSet(paths[i]);

      ListUnits(Paths[i]);
    end;
  {$ENDREGION}

  for i := 0 to Pred(Length(paths)) do
    if TDirectory.Exists(paths[i]) then
      AddPathInTreeView(Paths[i]);

end;

procedure TCCEWizardForms.ListUnits(Path: String);
var
  units: TArray<String>;
  i: Integer;
begin
  units := FProject.ListAllUnits(Path);
  for i := 0 to Pred(Length( units )) do
    chkLstUnits.AddOrSet(units[i]);
end;

procedure TCCEWizardForms.MenuItem1Click(Sender: TObject);
begin
  chkLstUnits.SelectAll;
end;

procedure TCCEWizardForms.MenuItem2Click(Sender: TObject);
begin
  chkLstUnits.UnSelectAll;
end;

procedure TCCEWizardForms.OnAddPath(APath: String);
begin
  chklstPaths.Check(APath);
end;

procedure TCCEWizardForms.OnAddUnit(AUnit: String);
begin
  chkLstUnits.Check(AUnit);
end;

procedure TCCEWizardForms.OnRemovePath(APath: String);
begin
  chklstPaths.UnCheck(APath);
end;

procedure TCCEWizardForms.OnRemoveUnit(AUnit: String);
begin
  chkLstUnits.UnCheck(AUnit);
end;

procedure TCCEWizardForms.RemovePath1Click(Sender: TObject);
var
  path: String;
begin
  path := chklstPaths.Value;
  FProject.RemoveAllUnits(path);
  FProject.RemovePath(path);

end;

procedure TCCEWizardForms.searchFile(FilterText, FilterExt: string; AComponent: TCustomEdit);
begin
  openTextDialog.Filter := Format('%s | *.%s', [FilterText, FilterExt]);
  if openTextDialog.Execute then
    AComponent.Text := openTextDialog.FileName;
end;

procedure TCCEWizardForms.SelectAll1Click(Sender: TObject);
begin
  SelectAllPaths;
end;

procedure TCCEWizardForms.SelectAllPaths;
var
  i: Integer;
begin
  chklstPaths.SelectAll;
  for i := 0 to chklstPaths.Items.Count - 1 do
    FProject.AddPath(chklstPaths.Value(i));
end;

procedure TCCEWizardForms.SelectAllUnits;
var
  i: Integer;
begin
  chkLstUnits.SelectAll;
  for i := 0 to chkLstUnits.Items.Count - 1 do
    FProject.AddUnit(chkLstUnits.Value(i));
end;

procedure TCCEWizardForms.selectFolder(AComponent: TCustomEdit);
var
  path: string;
begin
  path := FProject.ProjectPath;
  if SelectDirectory('Select Directory', '', path) then
    AComponent.Text := path;
end;

procedure TCCEWizardForms.SelectPageNext;
begin
  pgcWizard.SelectNextPage(True, False);
  btnNext.Enabled := pgcWizard.ActivePageIndex < (pgcWizard.PageCount - 1);
  btnPrevious.Enabled := True;
end;

procedure TCCEWizardForms.SelectPagePrevious;
begin
  pgcWizard.SelectNextPage(False, False);
  btnPrevious.Enabled := pgcWizard.ActivePageIndex > 0;
  btnNext.Enabled := True;
end;

procedure TCCEWizardForms.tvPathsClick(Sender: TObject);
begin
  showmessage(tvPaths.SelectedPath);
end;

procedure TCCEWizardForms.UnselectAll1Click(Sender: TObject);
begin
  chklstPaths.UnSelectAll;
end;

end.
