program db;

uses
  Forms,
  FMain in 'FMain.pas' {frmMain},
  uConnector in 'uConnector.pas',
  uBuffer in '..\common\uBuffer.pas',
  uDBProvider in '..\common\uDBProvider.pas',
  uUtil in '..\common\uUtil.pas',
  uPackets in '..\common\uPackets.pas',
  uCrypt in '..\common\uCrypt.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  uRecordDef in 'uRecordDef.pas',
  deftype in '..\1000ydef\deftype.pas',
  uCBasicConnector in '..\common\uCBasicConnector.pas',
  uSBasicConnector in '..\common\uSBasicConnector.pas',
  uSRemoteConnector in 'uSRemoteConnector.pas',
  uCRemoteConnector in 'uCRemoteConnector.pas',
  uSItemRemoteConnector in 'uSItemRemoteConnector.pas',
  uCItemRemoteConnector in 'uCItemRemoteConnector.pas',
  uRemoteDef in '..\common\uRemoteDef.pas',
  uIpChecker in 'uIpChecker.pas',
  uCookie in '..\common\uCookie.pas',
  uLevelExp in '..\1000ydef\uLevelExp.pas',
  AUtil32 in '..\1000ydef\AUtil32.pas',
  AnsUnit in '..\common\AnsUnit.pas',
  uDBFile in 'uDBFile.pas',
  uDBAdapter in 'uDBAdapter.pas',
  UserSdb in '..\common\Usersdb.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
