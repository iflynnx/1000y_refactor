program bgs1000;

uses
  Forms,
  UUser in 'UUser.pas',
  svClass in 'svClass.pas',
  fieldmsg in 'fieldmsg.pas',
  BasicObj in 'BasicObj.pas',
  MapUnit in 'MapUnit.pas',
  SubUtil in 'SubUtil.pas',
  uSendCls in 'uSendCls.pas',
  uUserSub in 'uUserSub.pas',
  uGramerId in 'uGramerId.pas',
  uAnsTick in 'C:\Project\ALib\uAnsTick.pas',
  deftype in '..\1000ydef\deftype.pas',
  AnsStringCls in 'C:\project\alib\AnsStringCls.pas',
  uLetter in 'uLetter.pas',
  uAIPath in 'uAIPath.pas',
  uGConnect in 'uGConnect.pas',
  uBuffer in '..\common\uBuffer.pas',
  uConnect in 'uConnect.pas',
  uDBRecordDef in '..\common\uDBRecordDef.pas',
  uPackets in '..\common\uPackets.pas',
  uCrypt in '..\common\uCrypt.pas',
  uEasyList in '..\common\uEasyList.pas',
  Common in '..\common\Common.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  SVMain in 'SVMain.pas' {FrmMain},
  uGroup in 'uGroup.pas',
  BSCommon in '..\common\BSCommon.pas',
  FGameServer in 'FGameServer.pas' {frmGSState};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmGSState, frmGSState);
  Application.Run;
end.
