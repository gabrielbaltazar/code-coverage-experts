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
  CCE.Core.Utils,
  CCE.Helpers.TreeView,
  System.Generics.Collections, Vcl.CheckLst, Vcl.Menus, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage, Vcl.Mask;

const
  COLOR_PRIMARY = $00FB7E15;
  COLOR_DISABLED = $00aba6a0;

type
  TCCEWizardForms = class(TForm)
    pgcWizard: TPageControl;
    tsFiles: TTabSheet;
    pnlBottom: TPanel;
    openTextDialog: TOpenTextFileDialog;
    tsTreeView: TTabSheet;
    tvPaths: TTreeView;
    iltreeView: TImageList;
    Panel1: TPanel;
    imgSetDetailed: TImage;
    imgXml: TImage;
    imgTxt: TImage;
    imgHtml: TImage;
    imgBuild: TImage;
    imgRun: TImage;
    imgSave: TImage;
    imgFolder: TImage;
    pnlContentFiles: TPanel;
    pnlBody: TPanel;
    edtCoverageExeName: TLabeledEdit;
    edtExeName: TLabeledEdit;
    edtMapFileName: TLabeledEdit;
    edtOutputReport: TLabeledEdit;
    grpOutputFormat: TGroupBox;
    chkXmlReport: TCheckBox;
    chkHtmlReport: TCheckBox;
    chkEmmaReport: TCheckBox;
    chkLog: TCheckBox;
    chkUseRelativePath: TCheckBox;
    pnlTitle: TPanel;
    lblTitleSettings: TLabel;
    btnNext: TPanel;
    btnPrevious: TPanel;
    btnClose: TPanel;
    imgGithub: TImage;
    btnSelectCodeCoverage2: TImage;
    btnSelectExeName: TImage;
    btnSelectMapFile: TImage;
    btnOutputReport: TImage;
    tsIgnoredFiles: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    lstIgnoreUnits: TListBox;
    edtIgnoreUnit: TLabeledEdit;
    pnlAddIgnoreUnit: TPanel;
    imgAddIgnoreUnit: TImage;
    pmIgnoreUnits: TPopupMenu;
    Delete1: TMenuItem;
    ChkJacoco: TCheckBox;
    procedure tvPathsDblClick(Sender: TObject);
    procedure imgRunClick(Sender: TObject);
    procedure imgSaveClick(Sender: TObject);
    procedure imgSetDetailedClick(Sender: TObject);
    procedure imgBuildClick(Sender: TObject);
    procedure imgHtmlClick(Sender: TObject);
    procedure imgXmlClick(Sender: TObject);
    procedure imgTxtClick(Sender: TObject);
    procedure imgFolderClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSelectCodeCoverage2Click(Sender: TObject);
    procedure btnSelectExeNameClick(Sender: TObject);
    procedure btnSelectMapFileClick(Sender: TObject);
    procedure btnOutputReportClick(Sender: TObject);
    procedure imgGithubClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure imgAddIgnoreUnitClick(Sender: TObject);
  private
    FProject: ICCEProject;
    FCoverage: ICCECodeCoverage;
    FTreeNodes: TDictionary<String, TTreeNode>;

    function GetNode(APath: String): TTreeNode;
    procedure AddPathInTreeView(APath: String);
    function GetKeyNode(ANode: TTreeNode): String;

    procedure SetCoverage(ASetUnits: Boolean = True);
    procedure SetCoverageUnits;

    procedure SetStateTreeView;
    procedure SetStateChilds(ANode: TTreeNode; AStateIndex: Integer);
    procedure SetStateParents(ANode: TTreeNode);
    procedure SetSelectedUnits;
    procedure SetIgnoreUnits;

    procedure searchFile(FilterText, FilterExt: string; AComponent: TCustomEdit);
    procedure selectFolder(AComponent: TCustomEdit);

    procedure ListPaths;
    procedure ListUnits(Path: String);

    procedure InitialValues;
    procedure HideTabs;
    procedure SelectPageNext;
    procedure SelectPagePrevious;
    procedure SetColorButtons;
  public
    function Project(Value: IOTAProject): TCCEWizardForms;

    constructor Create(AOwner: TComponent); override;
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
  nodeParent: TTreeNode;
  node: TTreeNode;
  text: String;
  pathParent: String;
  path: String;
  splittedPath: TArray<string>;

  procedure SetImageIndex(ANode: TTreeNode; APath: String);
  var
    index: Integer;
  begin
    ANode.StateIndex := CHECKED_INDEX;
    index := FOLDER_INDEX;
    if APath.EndsWith('\') then
      APath := Copy(APath, 1, APath.Length - 1);
    if FileExists(APath) then
      index := UNIT_INDEX;

    ANode.ImageIndex := index;
    ANode.SelectedIndex := index;
  end;
begin
  splittedPath := APath.Split(['\']);

  pathParent := '';
  for i := 0 to Pred(Length(splittedPath)) do
  begin
    text := splittedPath[i];
    if text = '' then
      Continue;
    path := path + text + '\';
    node := GetNode(path);
    if Assigned(node) then
      Continue;

    if i = 0 then
    begin
      nodeParent := tvPaths.Items.AddChild(nil, text);
      SetImageIndex(nodeParent, path);
      FTreeNodes.Add(path, nodeParent);
      Continue;
    end;

    pathParent := Copy(path, 1, path.length - text.Length - 1);
    nodeParent := GetNode(pathParent);
    if Assigned(nodeParent) then
    begin
      nodeParent := tvPaths.Items.AddChild(nodeParent, text);
      SetImageIndex(nodeParent, path);
      FTreeNodes.Add(path, nodeParent);
      Continue;
    end;
  end;
end;

procedure TCCEWizardForms.btnSelectCodeCoverage2Click(Sender: TObject);
begin
  searchFile('Code Coverage File', 'exe', edtCoverageExeName);
end;

procedure TCCEWizardForms.btnSelectExeNameClick(Sender: TObject);
begin
  searchFile('Delphi Test Project', 'exe', edtExeName);
end;

procedure TCCEWizardForms.btnSelectMapFileClick(Sender: TObject);
begin
  searchFile('Map File', 'map', edtMapFileName);
end;

procedure TCCEWizardForms.SetSelectedUnits;
var
  i: Integer;
  LIndex: Integer;
  LText: String;

  function GetFullName(ANode: TTreeNode): String;
  var
    LParent: TTreeNode;
  begin
    Result := ANode.Text;
    LParent := ANode.Parent;
    while LParent <> nil do
    begin
      Result := LParent.Text + '\' + Result;
      LParent := LParent.Parent;
    end;
  end;
begin
  tvPaths.Items.BeginUpdate;
  try
    for i := 0 to Pred(tvPaths.Items.Count) do
    begin
      LText := GetFullName(tvPaths.Items[i]);
      if FileExists(LText) then
      begin
        LIndex := UNCHECKED_INDEX;
        if FCoverage.IsInCovUnits(LText) then
          LIndex := CHECKED_INDEX;

        tvPaths.Items[i].StateIndex := LIndex;
        SetStateParents(tvPaths.Items[i]);
      end;
    end;
  finally
    tvPaths.Items.EndUpdate;
  end;
end;

procedure TCCEWizardForms.SetStateChilds(ANode: TTreeNode; AStateIndex: Integer);
var
  childNode: TTreeNode;
begin
  childNode := ANode.getFirstChild;

  while childNode <> nil do
  begin
    childNode.StateIndex := AStateIndex;
    SetStateChilds(childNode, AStateIndex);

    childNode := ANode.GetNextChild(childNode);
  end;
end;

procedure TCCEWizardForms.SetStateParents(ANode: TTreeNode);
var
  nodeParent: TTreeNode;
  hasCheck: Boolean;
  hasUnCheck: Boolean;
  hasGrayed: Boolean;
  childNode: TTreeNode;
  index: Integer;
begin
  nodeParent := ANode.Parent;
  if not Assigned(nodeParent) then
    Exit;

  hasCheck := False;
  hasUnCheck := False;
  hasGrayed := False;

  childNode := nodeParent.getFirstChild;
  while childNode <> nil do
  begin
    index := childNode.StateIndex;
    hasCheck := (hasCheck) or (index = CHECKED_INDEX);
    hasUnCheck := (hasUnCheck) or (index = UNCHECKED_INDEX);
    hasGrayed := (hasGrayed) or (index = GRAYED_INDEX);

    childNode := nodeParent.GetNextChild(childNode);
  end;

  index := UNCHECKED_INDEX;
  if (hasCheck and hasUnCheck) or (hasGrayed) then
    index := GRAYED_INDEX
  else
  if hasCheck then
    index := CHECKED_INDEX;

  nodeParent.StateIndex := index;
  SetStateParents(nodeParent);
end;

procedure TCCEWizardForms.SetStateTreeView;
var
  stateIndex: Integer;
  nodeSelected: TTreeNode;
begin
  nodeSelected := tvPaths.Selected;
  nodeSelected.Expanded := not nodeSelected.Expanded;

  stateIndex := UNCHECKED_INDEX;
  if nodeSelected.StateIndex = UNCHECKED_INDEX then
    stateIndex := CHECKED_INDEX;

  nodeSelected.StateIndex := stateIndex;

  SetStateChilds(nodeSelected, stateIndex);
  SetStateParents(nodeSelected);
end;

constructor TCCEWizardForms.create(AOwner: TComponent);
begin
  inherited;
  FTreeNodes := TDictionary<String, TTreeNode>.create;
end;

procedure TCCEWizardForms.Delete1Click(Sender: TObject);
begin
  lstIgnoreUnits.DeleteSelected;
end;

destructor TCCEWizardForms.Destroy;
begin
  FTreeNodes.Free;
  inherited;
end;

function TCCEWizardForms.GetKeyNode(ANode: TTreeNode): String;
var
  nodeParent: TTreeNode;
begin
  Result := ANode.Text;
  nodeParent := ANode.Parent;
  while nodeParent <> nil do
  begin
    Result := nodeParent.Text + '\' + Result;
    nodeParent := nodeParent.Parent;
  end;

  if Result.EndsWith('\') then
    Result := Copy(Result, 1, Result.Length - 1);
end;

function TCCEWizardForms.GetNode(APath: String): TTreeNode;
begin
  Result := nil;
  if FTreeNodes.ContainsKey(APath) then
    Result := FTreeNodes.Items[APath];
end;

procedure TCCEWizardForms.HideTabs;
var
  i: Integer;
begin
  pgcWizard.ActivePage := tsFiles;

  for i := 0 to Pred(pgcWizard.PageCount) do
    pgcWizard.Pages[i].TabVisible := False;

  SelectPageNext;
end;

procedure TCCEWizardForms.imgAddIgnoreUnitClick(Sender: TObject);
var
  LText: string;
begin
  LText := edtIgnoreUnit.Text;
  if lstIgnoreUnits.Items.IndexOf(LText) < 0 then
    lstIgnoreUnits.Items.Add(LText);
end;

procedure TCCEWizardForms.imgBuildClick(Sender: TObject);
begin
  FProject.Build;
end;

procedure TCCEWizardForms.imgFolderClick(Sender: TObject);
begin
  SetCoverage;
  OpenFolder(FCoverage.BasePath);
end;

procedure TCCEWizardForms.imgGithubClick(Sender: TObject);
begin
  OpenUrl('https://github.com/gabrielbaltazar/code-coverage-experts');
end;

procedure TCCEWizardForms.imgHtmlClick(Sender: TObject);
begin
  SetCoverage;
  FCoverage.ShowHTMLReport;
end;

procedure TCCEWizardForms.imgRunClick(Sender: TObject);
begin
  SetCoverage;
  FCoverage
    .Save
    .Execute;
end;

procedure TCCEWizardForms.imgSaveClick(Sender: TObject);
begin
  SetCoverage;
  FCoverage.Save;
  ShowMessage('OK');
end;

procedure TCCEWizardForms.imgSetDetailedClick(Sender: TObject);
begin
  FProject.SetDetailedMapFile;
  ShowMessage('OK');
end;

procedure TCCEWizardForms.imgTxtClick(Sender: TObject);
begin
  SetCoverage;
  FCoverage.ShowLogCoverage;
end;

procedure TCCEWizardForms.imgXmlClick(Sender: TObject);
begin
  SetCoverage;
  FCoverage.ShowXMLReport;
end;

procedure TCCEWizardForms.InitialValues;
begin
  edtExeName.Text := FProject.ExeName;
  edtMapFileName.Text := FProject.MapFileName;
  edtOutputReport.Text := ExtractFilePath(FProject.ExeName) + 'report';
end;

procedure TCCEWizardForms.ListPaths;
var
  paths: TArray<String>;
  i: Integer;
begin
  paths := FProject.ListAllPaths;

  for i := 0 to Pred(Length(paths)) do
    if TDirectory.Exists(paths[i]) then
    begin
      ListUnits(Paths[i]);
    end;
end;

procedure TCCEWizardForms.ListUnits(Path: String);
var
  units: TArray<String>;
  i: Integer;
begin
  units := FProject.ListAllUnits(Path);
  for i := 0 to Pred(Length( units )) do
    AddPathInTreeView(units[i]);
end;

function TCCEWizardForms.Project(Value: IOTAProject): TCCEWizardForms;
begin
  Result := Self;

//  if (not Assigned(FProject)) or (FProject.DprFileName <> Value.FileName) then
  begin
    FTreeNodes.Clear;
    tvPaths.Items.Clear;

    FProject := TCCECoreProject.New(Value);
    FCoverage := TCCECoreCodeCoverage.New;

    ListPaths;
    tvPaths.FullCollapse;

    HideTabs;
    InitialValues;
    SetCoverage(False);
    SetSelectedUnits;
    SetIgnoreUnits;
  end;
end;

procedure TCCEWizardForms.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TCCEWizardForms.btnNextClick(Sender: TObject);
begin
  SelectPageNext;
end;

procedure TCCEWizardForms.btnOutputReportClick(Sender: TObject);
begin
  selectFolder(edtOutputReport);
end;

procedure TCCEWizardForms.btnPreviousClick(Sender: TObject);
begin
  SelectPagePrevious;
end;

procedure TCCEWizardForms.SetCoverageUnits;
var
  nodeSelect: TArray<TTreeNode>;
  i: Integer;
  unitFile: string;
begin
  FCoverage.Clear;
  nodeSelect := tvPaths.CheckedNodes;

  for i := 0 to Pred(lstIgnoreUnits.Count) do
    FCoverage.AddUnitIgnore(lstIgnoreUnits.Items[i]);

  for i := 0 to Pred(Length(nodeSelect)) do
  begin
    unitFile := GetKeyNode(nodeSelect[i]);
    if FileExists(unitFile) then
    begin
      FCoverage
        .AddUnit(unitFile)
        .AddPath(ExtractFilePath(unitFile));
    end;
  end;

end;

procedure TCCEWizardForms.SetIgnoreUnits;
var
  LIgnore: TArray<String>;
begin
  LIgnore := FCoverage.IgnoredUnits;
  lstIgnoreUnits.Clear;
  lstIgnoreUnits.Items.AddStrings(LIgnore);
end;

procedure TCCEWizardForms.searchFile(FilterText, FilterExt: string; AComponent: TCustomEdit);
begin
  openTextDialog.Filter := Format('%s | *.%s', [FilterText, FilterExt]);
  if openTextDialog.Execute then
    AComponent.Text := openTextDialog.FileName;
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
  btnPrevious.Enabled := pgcWizard.ActivePageIndex > 0; // (pgcWizard.PageCount - 1);

  setColorButtons;
end;

procedure TCCEWizardForms.SelectPagePrevious;
begin
  pgcWizard.SelectNextPage(False, False);
  btnPrevious.Enabled := pgcWizard.ActivePageIndex > 0;
  btnNext.Enabled := True;

  setColorButtons;
end;

procedure TCCEWizardForms.SetColorButtons;
begin
  btnNext.Color := COLOR_PRIMARY;
  btnPrevious.Color := COLOR_PRIMARY;

  if not btnNext.Enabled then
    btnNext.Color := COLOR_DISABLED;

  if not btnPrevious.Enabled then
    btnPrevious.Color := COLOR_DISABLED;
end;

procedure TCCEWizardForms.SetCoverage(ASetUnits: Boolean = True);
begin
  if ASetUnits then
    SetCoverageUnits;

  FCoverage
    .CodeCoverageFileName(edtCoverageExeName.Text)
    .ExeFileName(edtExeName.Text)
    .MapFileName(edtMapFileName.Text)
    .OutputReport(edtOutputReport.Text)
    .GenerateHtml(chkHtmlReport.Checked)
    .GenerateXml(chkXmlReport.Checked)
    .GenerateEmma(chkEmmaReport.Checked)
    .GenerateLog(chkLog.Checked)
    .UseRelativePath(chkUseRelativePath.Checked)
    .Jacoco(ChkJacoco.Checked);
end;

procedure TCCEWizardForms.tvPathsDblClick(Sender: TObject);
begin
  tvPaths.Items.BeginUpdate;
  try
    SetStateTreeView;
  finally
    tvPaths.Items.EndUpdate;
  end;
end;

initialization

finalization
  CCEWizardForms.Free;

end.
