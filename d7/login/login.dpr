program login;

uses
  Forms,
  FMain in 'FMain.pas' {frmMain},
  uConnector in 'uConnector.pas',
  uBuffer in '..\common\uBuffer.pas',
  uUtil in '..\common\uUtil.pas',
  uPackets in '..\common\uPackets.pas',
  uCrypt in '..\common\uCrypt.pas',
  uEasyList in '..\common\uEasyList.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  deftype in '..\1000ydef\deftype.pas',
  //uEmaildata in '..\tgs1000\uEmaildata.pas',
  uDBFile in 'uDBFile.pas',
  uDBAdapter in 'uDBAdapter.pas',
  frmLogin in 'frmLogin.pas' {FormLogin},
  AUtil32 in '..\1000ydef\AUtil32.pas';

{$R *.RES}

begin
    Application.Initialize;
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

