program gate;

uses
  Forms,
  FMain in 'FMain.pas' {frmMain},
  uConnector in 'uConnector.pas',
  uBuffer in '..\common\uBuffer.pas',
  uUtil in '..\common\uUtil.pas',
  uLGRecordDef in '..\common\uLGRecordDef.pas',
  uDBRecordDef in '..\common\uDBRecordDef.pas',
  uPackets in '..\common\uPackets.pas',
  uEasyList in '..\common\uEasyList.pas',
  uCrypt in '..\common\uCrypt.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  deftype in '..\1000ydef\deftype.pas',
  Common in '..\common\Common.pas',
  uCharCheck in '..\common\uCharCheck.pas',
  AUtil32 in '..\1000ydef\AUtil32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
