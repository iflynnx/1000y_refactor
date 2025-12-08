program paid;

uses
  Forms,
  FMain in 'FMain.pas' {frmMain},
  uConnect in 'uConnect.pas',
  uPackets in '..\common\uPackets.pas',
  uBuffer in '..\common\uBuffer.pas',
  uCrypt in '..\common\uCrypt.pas',
  Common in '..\common\Common.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
