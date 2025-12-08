
program Client;
{
canvas.rectangle():画矩形pen.color:定义画笔颜色
roundrect():画圆角矩形pen.width:定义画笔宽度
arc():画弧线(不填充) brush.color:定义填充颜色
chord():画弧线(填充) textout():在固定位置输出字符串
pie:画扇形 textwidth:取字符串高度
polygon():画多边形填充textheight:取字符串宽度
polyline():多点连线(不填充)font.color:指定字体颜色
Pixels():指定固定象素点颜色值font.size:指定字体大小
moveto():指明画线起点 Ellipse():画圆或椭圆
lineto():指明画线终点

}
uses
  FastMM4,
  SysUtils,
  Classes,
  Dialogs,
  FastMM4Messages,
  Windows,
  Forms,
  FSelChar in 'FSelChar.pas' {FrmSelChar},
  CLMap in 'CLMap.pas',
  CTable in 'CTable.pas',
  USound in 'Usound.pas',
  deftype in '..\..\1000ydef\deftype.pas',
  TileCls in 'TileCls.pas',
  ObjCls in 'objcls.pas',
  FMain in 'FMain.pas' {FrmM},
  FBottom in 'FBottom.pas' {FrmBottom},
  FAttrib in 'FAttrib.pas' {FrmAttrib},
  SubUtil in '..\..\1000ydef\SubUtil.pas',
  FExchange in 'FExchange.pas' {FrmExchange},
  FSearch in 'FSearch.pas' {FrmSearch},
  FQuantity in 'FQuantity.pas' {FrmQuantity},
  FSound in 'FSound.pas' {FrmSound},
  Log in '..\..\1000ydef\Log.pas',
  FDepository in 'FDepository.pas' {FrmDepository},
  FMiniMap in 'FMiniMap.pas' {FrmMiniMap},
  FcMessageBox in 'FcMessageBox.pas' {FrmcMessageBox},
  uPersonBat in 'uPersonBat.pas',
  FbatList in 'FbatList.pas' {FrmbatList},
  FMuMagicOffer in 'FMuMagicOffer.pas' {FrmMuMagicOffer},
  uBuffer in '..\..\common\uBuffer.pas',
  uCrypt in '..\..\common\uCrypt.pas',
  uPackets in '..\..\common\uPackets.pas',
  BSCommon in '..\..\common\BSCommon.pas',
  FNPCTrade in 'FNPCTrade.pas' {frmNPCTrade},
  FCharAttrib in 'FCharAttrib.pas' {frmCharAttrib},
  FItemHelp in 'FItemHelp.pas' {frmItemHelp},
  FHistory in 'FHistory.pas' {frmHistory},
  ProClass in 'ProClass.pas',
  FPassEtc in 'FPassEtc.pas' {FrmPassEtc},
  FConfirmDialog in 'FConfirmDialog.pas' {frmConfirmDialog},
  cAIPath in 'cAIPath.pas',
  FShowPopMsg in 'FShowPopMsg.pas' {frmPopMsg},
  FPopMsgList in 'FPopMsgList.pas' {frmPopMsgList},
  FGuild in 'FGuild.pas' {frmGuild},
  FWearItem in 'FWearItem.pas' {FrmWearItem},
  //FNewEMAIL in 'FNewEMAIL.PAS' {FrmNEWEmail},
  //FEMAIL in 'FEMAIL.pas' {FrmEmail},
  //FAuction in 'FAuction.pas' {frmAuction},
  //AuctionBuy in 'AuctionBuy.pas' {frmAuctionBuy},
  FItemTreeView in 'FItemTreeView.pas' {frmItemTreeView},
  FWearItemUser in 'FWearItemUser.pas' {frmWearItemUser},
  FQuest in 'FQuest.pas' {frmQuest},
  //FProcession in 'FProcession.pas' {frmProcession},
  FBillboardcharts in 'FBillboardcharts.pas' {frmBillboardcharts},
  //FProcessionList in 'FProcessionList.pas' {frmProcessionList},
  //FProcessionButton in 'FProcessionButton.pas' {frmProcessionButton},
  FfilePgk in 'PGK\FfilePgk.pas',
  uKeyClass in '..\..\common\uKeyClass.pas',
  filepgkclass in 'filepgkclass.pas',
  energy in 'energy.pas',
  FUPdateItemLevel in 'FUPdateItemLevel.pas' {FrmUPdateItemLevel},
  FEmporia in 'FEmporia.pas' {frmEmporia},
  uMagicClass in '..\..\tgs1000\uMagicClass.pas',
  cMAPGDI in 'cMAPGDI.pas',
  FnewMagic in 'FnewMagic.pas' {FrmNewMagic},
  FGameToolsNew in 'FGameToolsNew.pas' {frmGameToolsNew},
  FNEWHailFellow in 'FNEWHailFellow.pas' {FrmHailFellow},
  uGramerId in '..\..\1000ydef\uGramerId.pas',
  //Femailread in 'Femailread.pas' {frmEmailRead},
  //Fhelp_htm in 'Fhelp_htm.pas' {frmHelp},
  uSetWinIni in 'uSetWinIni.pas',
  uinifile in '..\..\common\uinifile.pas',
 // Fchat in 'Fchat.pas' {frmchat},
  //fmsgboxtemp in 'fmsgboxtemp.pas' {frmMsgBoxTemp},
  FLittleMap in 'FLittleMap.pas' {frmLittleMap},
  //FBooth in 'FBooth.pas' {FrmBooth},
  Unit_console in 'Unit_console.pas' {FrmConsole},
  uNewPackets in '..\..\common\uNewPackets.pas',
  fbl in 'fbl.pas' {frmfbl},
  fb in 'fb.pas' {frmfb},
 // FSkill in 'FSkill.pas' {frmSkill},
  NativeXml in 'xml\NativeXml.pas',
  BaseUIForm in 'BaseUIForm.pas' {frmBaseUI},
  ShowHintForm in 'ShowHintForm.pas' {frmShowHint},
  FCreateChar in 'FCreateChar.pas' {frmCreateChar},
  FPassEtcEdit in 'FPassEtcEdit.pas' {frmPassEtcEdit},
  FNewQuest in 'FNewQuest.pas' {frmNewQuest},
  FHorn in 'FHorn.pas' {FrmHorn},
  FComplexProperties in 'FComplexProperties.pas' {frmComplexProperties},
  FItemUpgrade in 'FItemUpgrade.pas' {frmItemUpgrade},
  uHardCode in 'uHardCode.pas',
  ZLibExGZ in 'ZLibEx\ZLibExGZ.pas',
  ZLibEx in 'ZLibEx\ZLibEx.pas',
  FLoad in 'FLoad.pas' {Load},
  FGameToolsAssist in 'FGameToolsAssist.pas' {FrmGameToolsAssist},
  FBuffPanel in 'FBuffPanel.pas' {frmBuffPanel},
  FMonsterBuffPanel in 'FMonsterBuffPanel.pas' {frmMonsterBuffPanel};

{$R *.RES}
{$R uac.res}
const
  newFile = 'Updata_x.exe'; //2015.11.21 在水一方
  oldFile = 'Updata.exe'; //<<<<<<

//var
//   buffer : array [0..128] of byte;
//   SelfHandle : integer;

var
  name: string;

begin

//  if FileExists(ExtractFilePath(ParamStr(0)) + '\' + newFile) then            //2015.11.21 在水一方 >>>>>>
//  begin
//    copyFile(PChar(ExtractFilePath(ParamStr(0)) + '\' + newFile), PChar(ExtractFilePath(ParamStr(0)) + '\' + oldFile), false);
//    deleteFile(PChar(ExtractFilePath(ParamStr(0)) + '\' + newFile));
//  end;

  if FileExists(pchar(ExtractFilePath(ParamStr(0)) + newFile)) then //2015.11.21 在水一方 >>>>>>
  begin
    if copyFile(pchar(ExtractFilePath(ParamStr(0)) + newFile), pchar(ExtractFilePath(ParamStr(0)) + oldFile), false) then
    begin
      deleteFile(pchar(ExtractFilePath(ParamStr(0)) + newFile));
    end;
  end;

  Application.Initialize;
//  frmfb:=Tfrmfb.Create(Application);
//  frmfb.Show;
 //  while not Fblxz do Application.ProcessMessages;


  Application.Title := '梦千年online';
  Load := TLoad.Create(Application);
  Load.Show;
  Load.Update;

  Application.CreateForm(TFrmM, FrmM);
  Application.CreateForm(TFrmSelChar, FrmSelChar);
  Application.CreateForm(TFrmAttrib, FrmAttrib);
  Application.CreateForm(TfrmShowHint, frmShowHint);
  Application.CreateForm(TFrmBottom, FrmBottom);
  Application.CreateForm(TfrmCreateChar, frmCreateChar);
  Application.CreateForm(TfrmNewQuest, frmNewQuest);
  Application.CreateForm(TFrmGameToolsAssist, FrmGameToolsAssist);
  Application.CreateForm(TfrmBuffPanel, frmBuffPanel);
  Application.CreateForm(TfrmMonsterBuffPanel, frmMonsterBuffPanel); 
  //  Application.CreateForm(TFrmperson, Frmperson);
  Application.CreateForm(TFrmExchange, FrmExchange);
  Application.CreateForm(TFrmSearch, FrmSearch);
  Application.CreateForm(TFrmQuantity, FrmQuantity);
  Application.CreateForm(TFrmSound, FrmSound);
  Application.CreateForm(TFrmDepository, FrmDepository);
  Application.CreateForm(TFrmMiniMap, FrmMiniMap);
  Application.CreateForm(TFrmcMessageBox, FrmcMessageBox);
  Application.CreateForm(TFrmbatList, FrmbatList);
  Application.CreateForm(TFrmMuMagicOffer, FrmMuMagicOffer);
  Application.CreateForm(TfrmWearItemUser, frmWearItemUser);
  Application.CreateForm(TfrmQuest, frmQuest);
 // Application.CreateForm(TfrmProcession, frmProcession);
  Application.CreateForm(TfrmBillboardcharts, frmBillboardcharts);
  Application.CreateForm(TFrmUPdateItemLevel, FrmUPdateItemLevel);
  Application.CreateForm(TfrmEmporia, frmEmporia);
  Application.CreateForm(TFrmNewMagic, FrmNewMagic);
  //Application.CreateForm(TfrmLittleMap, frmLittleMap);  2015年10月22日屏蔽小地图
  Application.CreateForm(TfrmGameToolsNew, frmGameToolsNew);
  Application.CreateForm(TFrmHailFellow, FrmHailFellow);
 // Application.CreateForm(TfrmEmailRead, frmEmailRead);
  Application.CreateForm(TfrmNPCTrade, frmNPCTrade);
  Application.CreateForm(TfrmCharAttrib, frmCharAttrib);
  Application.CreateForm(TfrmItemHelp, frmItemHelp);
  Application.CreateForm(TfrmHistory, frmHistory);
  Application.CreateForm(TFrmPassEtc, FrmPassEtc);
  Application.CreateForm(TfrmPassEtcEdit, frmPassEtcEdit);
  Application.CreateForm(TfrmGuild, frmGuild);
  Application.CreateForm(TFrmWearItem, FrmWearItem);
 // Application.CreateForm(TFrmNEWEmail, FrmNEWEmail);
 // Application.CreateForm(TFrmEmail, FrmEmail);
 // Application.CreateForm(TfrmAuction, frmAuction);
  //Application.CreateForm(TfrmAuctionBuy, frmAuctionBuy);
  Application.CreateForm(TfrmItemTreeView, frmItemTreeView);
  Application.CreateForm(TfrmPopMsg, frmPopMsg);
  //Application.CreateForm(TfrmHelp, frmHelp);
 // Application.CreateForm(Tfrmchat, frmchat);
 // Application.CreateForm(TfrmMsgBoxTemp, frmMsgBoxTemp);
  //Application.CreateForm(TFrmBooth, FrmBooth);
  Application.CreateForm(TFrmConsole, FrmConsole);
 // Application.CreateForm(TfrmSkill, frmSkill);
  Application.CreateForm(TFrmHorn, FrmHorn);
  Application.CreateForm(TfrmComplexProperties, frmComplexProperties);
  Application.CreateForm(TfrmItemUpgrade, frmItemUpgrade); //强化窗口
  Application.CreateForm(TFrmfbl, Frmfbl);
 // Application.CreateForm(TFrmLogOn, FrmLogOn);

  //Application.CreateForm(TfrmEnergy, frmEnergy);
  Load.Hide;
  Load.Free;
  startOptFont;
  Application.Run;

end.

