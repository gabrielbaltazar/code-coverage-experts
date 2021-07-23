unit CCE.Wizard.Forms;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls,
  ToolsAPI, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs,
  CCE.OTA.Utils,
  System.Generics.Collections;

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
    openTextDialog: TOpenTextFileDialog;
    edtMapFileName: TLabeledEdit;
    btnSelectMapFile: TButton;
    edtCoverageExeName: TLabeledEdit;
    btnSelectCodeCoverage: TButton;
    tsPaths: TTabSheet;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnSelectExeNameClick(Sender: TObject);
    procedure btnSelectCodeCoverageClick(Sender: TObject);
    procedure btnSelectMapFileClick(Sender: TObject);
  private
    FProject: IOTAProject;
    FProjectUtils: TCCEOTAProject;
    { Private declarations }

    procedure searchFile(FilterText, FilterExt: string; AComponent: TLabeledEdit);

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

procedure TCCEWizardForms.btnNextClick(Sender: TObject);
begin
  SelectPageNext;
end;

constructor TCCEWizardForms.create(AOwner: TComponent; Project: IOTAProject);
begin
  inherited create(AOwner);
  FProject := Project;
  FProjectUtils := TCCEOTAProject.create(Project);
end;

destructor TCCEWizardForms.Destroy;
begin
  FProjectUtils.Free;
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
  edtExeName.Text := FProjectUtils.ExeName;
  edtMapFileName.Text := FProjectUtils.MapFileName;
end;

procedure TCCEWizardForms.searchFile(FilterText, FilterExt: string; AComponent: TLabeledEdit);
begin
  openTextDialog.Filter := Format('%s | *.%s', [FilterText, FilterExt]);
  if openTextDialog.Execute then
    AComponent.Text := openTextDialog.FileName;
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

end.
