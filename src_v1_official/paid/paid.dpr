program paid;

uses
  Forms,
  FMain in 'FMain.pas' {frmMain},
  deftype in '..\1000ydef\deftype.pas',
  uConnect in 'uConnect.pas',
  uPackets in '..\common\uPackets.pas',
  uCrypt in '..\common\uCrypt.pas',
  uBuffer in '..\common\uBuffer.pas',
  Common in '..\common\Common.pas',
  uUtil in '..\common\uUtil.pas',
  uPaidDB in 'uPaidDB.pas',
  uKeyClass in '..\common\uKeyClass.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
