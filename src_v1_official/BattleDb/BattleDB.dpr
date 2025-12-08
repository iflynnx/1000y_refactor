program BattleDB;

uses
  Forms,
  uBattleDB in 'uBattleDB.pas',
  FMain in 'FMain.pas' {FrmMain},
  uConnect in 'uConnect.pas',
  uBuffer in '..\common\uBuffer.pas',
  uCrypt in '..\common\uCrypt.pas',
  uPackets in '..\common\uPackets.pas',
  Common in '..\common\Common.pas',
  BSCommon in '..\common\BSCommon.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  uBDKeyClass in 'uBDKeyClass.pas',
  uServerList in 'uServerList.pas',
  uMagicList in 'uMagicList.pas',
  uBattleTable in 'uBattleTable.pas',
  uUserData in 'uUserData.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
