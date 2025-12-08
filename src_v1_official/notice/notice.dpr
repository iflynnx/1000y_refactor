program notice;

uses
  Forms,
  FMain in 'FMain.pas' {frmMain},
  uConnector in 'uConnector.pas',
  uBuffer in '..\common\uBuffer.pas',
  uCrypt in '..\common\uCrypt.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  uPackets in '..\common\uPackets.pas',
  uServers in 'uServers.pas',
  uUsers in 'uUsers.pas',
  uUseIP in 'uUseIP.pas',
  deftype in '..\1000ydef\deftype.pas',
  uUtil in '..\common\uUtil.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
