program Balance;

uses
  Forms,
  FMain in 'FMain.pas' {frmMain},
  uUtil in '..\common\uUtil.pas',
  uBuffer in '..\common\uBuffer.pas',
  uCrypt in '..\common\uCrypt.pas',
  uPackets in '..\common\uPackets.pas',
  deftype in '..\1000ydef\deftype.pas',
  uConnector in 'uConnector.pas',
  uExequatur in '..\gate\uExequatur.pas',
  uGATEConnector in 'uGATEConnector.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  uNewPackets in '..\common\uNewPackets.pas',
  Unit_console in '..\Client\v5ncl1000\Unit_console.pas' {FrmConsole},
  uHardCode in '..\Client\v5ncl1000\uHardCode.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TFrmConsole, FrmConsole);
  Application.Run;
end.
