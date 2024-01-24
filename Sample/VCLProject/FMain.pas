unit FMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Model.Calculator,
  Model.Formatter;

type
  TFrmMain = class(TForm)
    Label1: TLabel;
    EdtNumber1: TEdit;
    EdtNumber2: TEdit;
    Label2: TLabel;
    EdtResult: TEdit;
    Label3: TLabel;
    BtnSum: TButton;
    BtnSubtract: TButton;
    Label4: TLabel;
    EdtText: TEdit;
    BtnOnlyNumber: TButton;
    Label5: TLabel;
    EdtResultOnlyNumber: TEdit;
    procedure BtnSumClick(Sender: TObject);
    procedure BtnSubtractClick(Sender: TObject);
    procedure BtnOnlyNumberClick(Sender: TObject);
  private
    FCalculator: TCalculator;
    FFormatter: TFormatter;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.BtnOnlyNumberClick(Sender: TObject);
var
  LResult: string;
begin
  LResult := FFormatter.OnlyNumbers(EdtText.Text);
  EdtResultOnlyNumber.Text := LResult;
end;

procedure TFrmMain.BtnSubtractClick(Sender: TObject);
var
  LNum1: Double;
  LNum2: Double;
  LResult: Double;
begin
  LNum1 := StrToFloatDef(EdtNumber1.Text, 0);
  LNum2 := StrToFloatDef(EdtNumber2.Text, 0);
  LResult := FCalculator.Subtract(LNum1, LNum2);
  EdtResult.Text := LResult.ToString;
end;

procedure TFrmMain.BtnSumClick(Sender: TObject);
var
  LNum1: Double;
  LNum2: Double;
  LResult: Double;
begin
  LNum1 := StrToFloatDef(EdtNumber1.Text, 0);
  LNum2 := StrToFloatDef(EdtNumber2.Text, 0);
  LResult := FCalculator.Sum(LNum1, LNum2);
  EdtResult.Text := LResult.ToString;
end;

constructor TFrmMain.Create(AOwner: TComponent);
begin
  inherited;
  FCalculator := TCalculator.Create;
  FFormatter := TFormatter.Create;
end;

destructor TFrmMain.Destroy;
begin
  FCalculator.Free;
  FFormatter.Free;
  inherited;
end;

end.
