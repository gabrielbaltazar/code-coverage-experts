program VCLProject;

uses
  Vcl.Forms,
  FMain in 'FMain.pas' {FrmMain},
  Model.Calculator in 'Source\Model\Model.Calculator.pas',
  Model.Formatter in 'Source\Model\Model.Formatter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
