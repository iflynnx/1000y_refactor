program tgs1000;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  SVMain in 'SVMain.pas' {FrmMain},
  UUser in 'UUser.pas',
  svClass in 'svClass.pas',
  fieldmsg in 'fieldmsg.pas',
  BasicObj in 'BasicObj.pas',
  MapUnit in 'MapUnit.pas',
  SubUtil in 'SubUtil.pas',
  uSendCls in 'uSendCls.pas',
  uMonster in 'uMonster.pas',
  uNpc in 'uNpc.pas',
  uUserSub in 'uUserSub.pas',
  uGuild in 'uGuild.pas',
  FSockets in 'FSockets.pas' {FrmSockets},
  deftype in '..\1000ydef\deftype.pas',
  uGuildSub in 'uGuildSub.pas',
  uLetter in 'uLetter.pas',
  uAIPath in 'uAIPath.pas',
  uManager in 'uManager.pas',
  uSkills in 'uSkills.pas',
  FGate in 'FGate.pas' {frmGate},
  uGConnect in 'uGConnect.pas',
  uBuffer in '..\common\uBuffer.pas',
  uConnect in 'uConnect.pas',
  uPackets in '..\common\uPackets.pas',
  uCrypt in '..\common\uCrypt.pas',
  uEasyList in '..\common\uEasyList.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  uItemLog in 'uItemLog.pas',
  uDoorGen in 'uDoorGen.pas',
  uMopSub in 'uMopSub.pas',
  uObjectEvent in 'uObjectEvent.pas',
  BSCommon in '..\common\BSCommon.pas',
  uGramerId in '..\1000ydef\uGramerId.pas',
  uhailfellow in 'uhailfellow.pas',
  uResponsion in 'uResponsion.pas',
  uMarriage in 'uMarriage.pas',
  uQuest in 'uQuest.pas',
  uEmail in 'uEmail.pas',
  uAuction in 'uAuction.pas',
  uEmaildata in 'uEmaildata.pas',
  uProcession in 'uProcession.pas',
  uBillboardcharts in 'uBillboardcharts.pas',
  uEmporia in 'uEmporia.pas',
  uMagicClass in 'uMagicClass.pas',
  UTelemanagement in 'UTelemanagement.pas',
  ViewLog in 'ViewLog.pas' {frmLog},
  uDBFile in '..\db-酷引擎\uDBFile.pas',
  frmAuction in 'frmAuction.pas' {FormAuction},
  frmEmail in 'frmEmail.pas' {FormEmail},
  UnitItemEditWin in '..\db-酷引擎\UnitItemEditWin.pas' {frmItemEdit},
  fbl in 'fbl.pas' {frmfbl},
  Unit_console in '..\Client\v5ncl1000\Unit_console.pas' {FrmConsole},
  class_DataSetWrapper in 'class_DataSetWrapper.pas',
  uDM in 'uDM.pas' {dm: TDataModule},
  ScriptForMysql in 'ScriptForMysql.pas',
  LuaRegisterClass in 'LuaRegisterClass.pas',
  uUserManager in 'uUserManager.pas' {FrmUserManager},
  uRandomManager in 'uRandomManager.pas' {FrmRandomManager},
  uComplex in 'uComplex.pas';

{$R *.RES}

begin
  // checkrpc;
 //   frmfbl:=Tfrmfbl.Create(Application);
 // frmfbl.Show;
 //while not Fblxz do Application.ProcessMessages;

  //去掉启动注册界面后，修改直接验证
//  check1:=true;
//  check2:=True;
//  FBLXZ:=True;

  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmSockets, FrmSockets);
  Application.CreateForm(TfrmGate, frmGate);
  Application.CreateForm(TfrmLog, frmLog);
  Application.CreateForm(TFrmConsole, FrmConsole);
  Application.CreateForm(TFrmUserManager, FrmUserManager);       
  Application.CreateForm(TFrmRandomManager, FrmRandomManager);
  //Application.CreateForm(Tdm, dm);     //2015.11.10 在水一方 内存泄露004
  Application.Run;
end.
