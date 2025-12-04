unit uSendCls;

interface

uses
  Windows, SysUtils, Classes, Usersdb, Deftype, //AnsUnit,
  AUtil32, subutil, uConnect;

type

  TSendClass = class
  private
    Name: string;
    Connector: TConnector;


  public
    constructor Create;
    destructor Destroy; override;

    procedure SetConnector(aConnector: TConnector);
    procedure SetName(aName: string);

    procedure SendProcessionExp(aExp: integer);

    procedure SendHaveItemQuest(akey: word; var ItemData: TItemData);

    procedure SendCancelExChange;
    procedure SendMoney(amoney: integer);
        //15.8.23 nirendao
    procedure SendBindMoney(amoney: integer);
    procedure SendJog_Skill(ajobKind, ajobLevel: integer; pJobGradeData: pTJobGradeData);
    procedure SendJog_menu(ajobKind: integer);

    procedure SendDesignation_Menu(atext: string);
    procedure SendDesignation_User(atext: string);

    procedure SendShowExChange(pexleft, pexright: PTExChangeData);
    procedure SendExChangeUPDATE(pexleft, pexright: PTExChangeData);
    procedure SendShowCount(aCountId, aSourKey, aDestKey, aCntMax: integer; acaption: string);

    procedure SendShowInputString(aInputStringId: integer; aCaptionString: string; aListString: string);
    procedure SendShowInputString2(atype: byte; aInputStringId: integer; aCaptionString: string);
    procedure SendShowInputOk(atype: byte; aInputStringId: integer; aCaptionString: string);

    procedure SendPowerLevel(aPowerLevel: integer; atext: string);

    procedure SendShiftAttack(abo: Boolean);
    procedure SendReliveTime(num: integer);
    procedure SendAttribFightBasic(astr: string);

    procedure SendAttribBase(var AttribData: TAttribData; var CurAttribData: TCurAttribData; var aAQuestData: TAttribQuestData);
    procedure SendOtherAttribBase(var AttribData: TAttribData; var CurAttribData: TCurAttribData; var aAQuestData: TAttribQuestData);
    procedure SendAttribValues(var AttribData: TAttribData; var CurAttribData: TCurAttribData; var aAQuestData: TAttribQuestData);
    procedure SendAttribUPDATE(atype: TAttribUPDATEType; avaluer: integer);

    procedure SendChangeFeature_NameColor(var aSenderinfo: TBasicData);

    procedure Sendcharattrib(var aAttribData: TAttribData; var aCurAttribData: TCurAttribData; var aLifeData: TLifeData);
    procedure SendLifeData(aLifeData: TLifeData);
    procedure SendOtherUserLifeData(aLifeData: TLifeData);
    procedure sendItemText(aname, atext: string);


    procedure SendChangeFeature(var aSenderinfo: TBasicData);
    procedure SendChangeProperty(var aSenderinfo: TBasicData);
    procedure SendKEYf5f12();
    procedure SendSay(var aSenderinfo: TBasicData; astr: string);
    procedure SendSayEx(var aSenderinfo: TBasicData; astr: string; aSay: PTCSayItem);
    procedure SendSayExHead(var aSenderinfo: TBasicData; astr: string; aSay: PTCSayItem; aId: integer);

    procedure SendSayUseMagic(var aSenderinfo: TBasicData; astr: string);
    procedure SendEventString(astr: string);
    procedure SendUsedMagicString(astr: string; aSkillLevel: word);
    procedure SendShootMagic(var aSenderinfo: TBasicData; atid: integer; ax, ay, abowimage, abowspeed: word; atype: Byte; EEffectNumber: integer);
    procedure SendTurn(var aSenderinfo: TBasicData);
    procedure SendSelChar(id: integer);
    procedure SendMove(var aSenderinfo: TBasicData);
    procedure SendMagicEffect(aid, aMagicEffect: integer; aEffecttype: TLightEffectKind);
    procedure SendEffect(aid, aMagicEffect: integer; aEffecttype: TLightEffectKind; aCount: Integer = 1);
    procedure SendMotion(aid, amotion: integer);
    procedure SendMotion2(aid, amotion: integer; aEffectimg: word; aEffectColor: byte);

    procedure SendStructed(var aSenderInfo: TBasicData; aPercent: integer);

    procedure SendChatMessage(astr: string; aColor: byte);
    procedure SendChatMessageByCol(astr: string; aFColor, aBColor: word);
    procedure SendChatMessageEx(astr: string; aColor: byte; aSay: PTCSayItem; aId: integer);
    procedure SendLeftText(astr: string; aColor: word; atype: TMsgType = mtNone; ashape: Integer = 0);
    procedure SendTESTMsg(astr: string);
    procedure lockmoveTime(atime: integer);
    procedure SendNUMSAY(astr: byte; aColor: byte; atext: string = '');
    procedure SendMSay(name, atext: string);
    procedure SendMSayEx(name, atext: string; amsayitem: PTCSayItemM);
    procedure SendBuffData(Akey, Aid: byte; ABuffData: TBuffData);
    procedure SendAllBuffData(var AllBuffData: TAllBuffDataMessage);
    procedure SendStatusMessage(astr: string);
    procedure Senditempro(var aItemData: TItemData);
    procedure Senditempro_MagicBasic(var aMagicData: TMagicData);
    procedure SendShow(var aSenderinfo: TBasicData);
    procedure SendHide(var aSenderinfo: TBasicData);
    procedure SendHaveItem(akey: word; var ItemData: TItemData);
    procedure SendHaveMagic(atype: TsendMagicType; akey: word; var MagicData: TMagicData; EventStringType: byte = 0);
    procedure SendMagicAddExp(var MagicData: TMagicData);
        //        procedure SendBasicMagic(akey:word; var MagicData:TMagicData; EventStringType:byte = 0);
    procedure SendWearItem(akey: word; atype: TWearItemtype; var ItemData: TItemData);
    procedure SendMap(var aSenderInfo: TBasicData; amap, aobj, arof, atil, aSoundBase, aMAPTitle: string);
    procedure SendHailFellow(aname, amapname: string; ax, ay, astate: integer);      
    procedure SendHailFellowList(aname: string; atype: Integer);
    procedure SendHailFellowMysqlDel(aname: string; atype: Integer);
    procedure SendHailFellow_Message_ADD(aname: string);

    procedure SendHailFellowGameExit(aname: string);
    procedure SendHailFellowDel(aname: string);
    procedure SendHailFellowDel2(aname: string);
    procedure SendMapObject(x, y: integer; aname: string; atype: integer);
    procedure SendSetPosition(var aSenderinfo: TBasicData);
    procedure SendSoundEffect(asoundname: integer; ax, ay: Word);

    procedure SendSoundBase(asoundname: string; aRoopCount: integer);

    procedure SendRainning(aRain: TSRainning);
    procedure SendShowCreateGuildName(aid: integer);

    procedure SendLogItem(akey: word; var ItemData: TItemData);
    procedure SendNPCItem(akey: word; var ItemData: TItemData; acount: integer);
    procedure SendShowSpecialWindow(aWindow: Byte; aCaption: string; aComment: string; akey1: INTEGER = 0; akey2: INTEGER = 0; akey3: INTEGER = 0; akey4: INTEGER = 0);
    procedure SendConfirmDialogWindow(aWindow: Byte; oObject, did: Integer; aCaption: string);
    procedure SendGameExit();
    procedure SendUpload(aType: Byte; aKey: WORD);
    procedure SendCloseClient();
    procedure WeaponLight(aInfo: TSMotion3);


    procedure SendShowGuildMagicWindow(aMagicWindowData: PTSShowGuildMagicWindow);
    procedure SendNetState(aID, aTick: Integer);
    procedure SendMoveOk();
    procedure SendData(var ComData: TWordComData); //发送 原始 数据
    procedure SendTOPMSG(acolor: word; astr: string);
    procedure SendQuestTempArr(aindex: integer);
    procedure SendQuestTempArrAll();
        //物品 发生 改变 系列
    procedure SendUPDATEItem_rlocktime(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_rtimemode_del(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_rlockState(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_rboident(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_rDurability(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_rcount_dec(aTYPE: TSENDUPDATEITEMTYPE; akey: word; acount: integer);
    procedure SendUPDATEItem_rcount_add(aTYPE: TSENDUPDATEITEMTYPE; akey: word; acount: integer);
    procedure SendUPDATEItem_rcount_UP(aTYPE: TSENDUPDATEITEMTYPE; akey: word; acount: integer);

    procedure SendUPDATEItem_add(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_del(aTYPE: TSENDUPDATEITEMTYPE; akey: word);
    procedure SendUPDATEItem_rcolor(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_rboBlueprint(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_rSpecialLevel(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
    procedure SendUPDATEItem_ChangeItem(aTYPE: TSENDUPDATEITEMTYPE; akey, akey2: word);

    procedure SendItemInputWindowsKey(aSubKey, akey: integer);
    procedure SendItemInputWindowsOpen(aSubkey: integer; aCaption: string; aText: string);
    procedure SendItemInputWindowsClose;

    procedure SendGulidKillstate(Value: boolean);
    procedure SendMsgBoxTemp(aCaption, astr: string);

    //2009.0909增加

    procedure SendBooth_edit_windows_open;
    procedure SendBooth_edit_windows_close;
    procedure SendBooth_edit_begin;
    procedure SendBooth_edit_end;
    procedure SendBooth_edit_item(atype: boothtype; akey: integer; var aboothitem: TBoothShopData);
    procedure SendBooth_edit_item_upCount(atype: boothtype; akey, acount: integer);
    procedure SendBooth_edit_item_del(atype: boothtype; akey: integer);


    procedure SendBooth_user_windows_open(aboothname: string);
    procedure SendBooth_user_windows_close;
    procedure SendBooth_user_item(atype: boothtype; akey: integer; aboothitem: TBoothShopData; aitem: titemdata);
    procedure SendBooth_user_item_upCount(atype: boothtype; akey, acount: integer);
    procedure SendBooth_user_item_del(atype: boothtype; akey: integer);

    procedure SendBooth_edit_Message(atext: string);

    procedure SendBooth(aid: integer; astate: boolean; aboothname: string; ashape: integer);
    procedure SendItemData(var ItemData: TItemData);
  end;

implementation

uses
  FSockets, svClass, SVMain, UUser, uUserSub, uMonster;

///////////////////////////////////
//         TSendClass
///////////////////////////////////

procedure TSendClass.SendShowCount(aCountID, aSourKey, aDestKey, aCntMax: Integer; aCaption: string);
var
  ComData: TWordComData;
  psCount: PTSCount;
begin
  psCount := @ComData.Data;
  with psCount^ do
  begin
    rMsg := SM_SHOWCOUNT;
    rCountID := aCountID;
    rSourKey := aSourKey;
    rDestKey := aDestKey;
    rCountCur := 0;
    rCountMax := aCntMax;
    SetWordString(rCountName, aCaption);
    ComData.Size := SizeOf(TSCount) - sizeof(TWordString) + sizeofWordstring(rCountName);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendCancelExChange;
var
  ComData: TWordComData;
  pcKey: PTCKey;
begin
  pcKey := @ComData.Data;
  with pcKey^ do
  begin
    rmsg := SM_HIDEEXCHANGE;
    ComData.Size := SizeOf(TCKey);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendExChangeUPDATE(pexleft, pexright: PTExChangeData);
var
  ComData: TWordComData;
  i: integer;
//    str: string;
begin //需要 改成 显示全部属性
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_SHOWEXCHANGE);
  WordComData_ADDbyte(ComData, SHOWEXCHANGE_Left);
    //pexleft
  WordComData_ADDbyte(ComData, byte(pexleft^.rboCheck));
  WordComData_ADDbyte(ComData, high(pexleft^.rItems) + 1); //数量
  for i := 0 to high(pexleft^.rItems) do
  begin
    if pexleft^.rItems[i].rItem.rName <> '' then
    begin
      if pexleft^.rItems[i].rsend then
      begin

        WordComData_ADDbyte(ComData, SHOWEXCHANGE_add); //数据
        TItemDataToTWordComData(pexleft^.rItems[i].ritem, ComData);
      end else
      begin
        WordComData_ADDbyte(ComData, 2); //没更新
      end;

    end else
    begin
      WordComData_ADDbyte(ComData, 3); //空
    end;

  end;
  SendData(comdata);
    ///////////////////////////////////////////////////////////////

  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_SHOWEXCHANGE);
  WordComData_ADDbyte(ComData, SHOWEXCHANGE_right);
    //pexleft
  WordComData_ADDbyte(ComData, byte(pexright^.rboCheck));
  WordComData_ADDbyte(ComData, high(pexright^.rItems) + 1); //数量
  for i := 0 to high(pexright^.rItems) do
  begin
    if pexright^.rItems[i].rItem.rName <> '' then
    begin
      if pexright^.rItems[i].rsend then
      begin

        WordComData_ADDbyte(ComData, SHOWEXCHANGE_add); //数据
        TItemDataToTWordComData(pexright^.rItems[i].ritem, ComData);
      end else
      begin
        WordComData_ADDbyte(ComData, 2); //没更新
      end;

    end else
    begin
      WordComData_ADDbyte(ComData, 3); //空
    end;

  end;
  SendData(comdata);
end;

procedure TSendClass.SendDesignation_Menu(atext: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Designation);
  WordComData_ADDbyte(ComData, Designation_menu);

  WordComData_ADDStringPro(ComData, atext);

  SendData(comdata);
end;

procedure TSendClass.SendDesignation_User(atext: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Designation);
  WordComData_ADDbyte(ComData, Designation_user);
  WordComData_ADDString(ComData, atext);

  SendData(comdata);
end;

procedure TSendClass.SendJog_menu(ajobKind: integer);
var
  ComData: TWordComData;
  str: string;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Job);
  WordComData_ADDbyte(ComData, Job_blueprint_Menu);
  str := '';
  case ajobKind of
    1: str := ItemClass.Job_Material1.Text;
    2: str := ItemClass.Job_Material2.Text;
    3: str := ItemClass.Job_Material3.Text;
    4: str := ItemClass.Job_Material4.Text;
  end;
  WordComData_ADDStringPro(ComData, str);

  SendData(comdata);
end;

procedure TSendClass.SendJog_Skill(ajobKind, ajobLevel: integer; pJobGradeData: pTJobGradeData);
var
  ComData: TWordComData;
  sname, stools: string;
  aMaxItemGrade: integer;
  aGrade: integer;
  ashape: word;
begin
  ashape := 0;
  aMaxItemGrade := 0;
  aGrade := 0;
  sname := '';
  stools := '';
  if pJobGradeData <> nil then
  begin
    sname := pJobGradeData.ViewName;
    case ajobKind of
      1:
        begin
          stools := pJobGradeData.Alchemist; // '铸造师';
          ashape := pJobGradeData.AlchemistShape;
        end;
      2: begin
          stools := pJobGradeData.Chemist; // '炼丹师';
          ashape := pJobGradeData.ChemistShape;
        end;
      3: begin
          stools := pJobGradeData.Designer; //'裁缝';
          ashape := pJobGradeData.DesignerShape;
        end;
      4: begin
          stools := pJobGradeData.Craftsman; // '工匠';
          ashape := pJobGradeData.CraftsmanShape;
        end;
    end;
    aMaxItemGrade := pJobGradeData.MaxItemGrade;
    aGrade := pJobGradeData.Grade;

  end;
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Job);
  WordComData_ADDbyte(ComData, Job_Skill);

  WordComData_ADDbyte(ComData, ajobKind);
  WordComData_ADDbyte(ComData, aMaxItemGrade);
  WordComData_ADDbyte(ComData, aGrade);

  WordComData_ADDdword(ComData, ajobLevel);
  WordComData_ADDword(ComData, ashape);
  WordComData_ADDString(ComData, sname);
  WordComData_ADDString(ComData, stools);
  SendData(comdata);
end;

procedure TSendClass.SendMoney(amoney: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_money);
  WordComData_ADDdword(ComData, amoney);

  SendData(comdata);
end;

procedure TSendClass.SendShowExChange(pexleft, pexright: PTExChangeData);
var
  ComData: TWordComData;
begin //需要 改成 显示全部属性
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_SHOWEXCHANGE);
  WordComData_ADDbyte(ComData, SHOWEXCHANGE_head);
  WordComData_ADDstring(ComData, pexleft^.rExChangeName);
  WordComData_ADDstring(ComData, pexright^.rExChangeName);
  SendData(comdata);
  SendExChangeUPDATE(pexleft, pexright);
end;

procedure TSendClass.SendShowInputString(aInputStringId: integer; aCaptionString: string; aListString: string);
var
  ComData: TWordComData;

  psShowInputString: PTSShowInputString;
begin
  psShowInputString := @ComData.Data;
  with psShowInputString^ do
  begin
    rmsg := SM_SHOWINPUTSTRING;
    rInputStringid := aInputStringId;
    SetWordString(rWordString, aCaptionString + ',' + aListString);
    ComData.Size := sizeof(TSShowInputString) - sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

//普通 输入筐，并且队列

procedure TSendClass.SendShowInputString2(atype: byte; aInputStringId: integer; aCaptionString: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_SHOWINPUTSTRING2);
  WordComData_ADDbyte(ComData, atype); //          类型
  WordComData_ADDdword(ComData, aInputStringId); //验证号
  WordComData_ADDString(ComData, aCaptionString); //文字提示
  SendData(ComData);
end;

procedure TSendClass.SendPowerLevel(aPowerLevel: integer; atext: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_PowerLevel);
  WordComData_ADDbyte(ComData, PowerLevel_level); //          类型
  WordComData_ADDbyte(ComData, aPowerLevel); //          类型

  WordComData_ADDstring(ComData, atext); //
  SendData(ComData);
end;

procedure TSendClass.SendShowInputOk(atype: byte; aInputStringId: integer; aCaptionString: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_InputOk);
  WordComData_ADDbyte(ComData, atype); //          类型
  WordComData_ADDdword(ComData, aInputStringId); //验证号
  WordComData_ADDString(ComData, aCaptionString); //文字提示
  SendData(ComData);
end;

procedure TSendClass.SendShowCreateGuildName(aid: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_GUILD);
  WordComData_ADDbyte(ComData, GUILD_Create_name);
  WordComData_ADDbyte(ComData, aid);
  SendData(ComData);
end;

procedure TSendClass.SendRainning(aRain: TSRainning);
var
  ComData: TWordComData;
  psRainning: PTSRainning;
begin
  psRainning := @ComData.Data;
  Move(aRain, psRainning^, SizeOf(TSRainning));
  ComData.Size := SizeOf(TSRainning);

  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

constructor TSendClass.Create;
begin
  Connector := nil;
end;

destructor TSendClass.Destroy;
begin
  inherited destroy;
end;

procedure TSendClass.SetConnector(aConnector: TConnector);
begin
  Connector := aConnector;
end;

procedure TSendClass.SetName(aName: string);
begin
  Name := aName;
end;

procedure TSendClass.SendShiftAttack(abo: Boolean);
var
  ComData: TWordComData;
  pcKey: PTCKey;
begin
  pcKey := @ComData.Data;
  with pcKey^ do
  begin
    rmsg := SM_BOSHIFTATTACK;
    if abo then rkey := 0
    else rkey := 1;
    ComData.Size := SizeOf(TCKey);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendReliveTime(num: integer);
var
  ComData: TWordComData;
  pcKey: PTCKey;
begin
  pcKey := @ComData.Data;
  with pcKey^ do
  begin
    rmsg := SM_ReliveTime;
    rkey := num;
    ComData.Size := SizeOf(TCKey);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendAttribFightBasic(astr: string);
var
  ComData: TWordComData;

  psAttribFightBasic: PTSAttribFightBasic;
begin
  psAttribFightBasic := @ComData.Data;
  with psAttribFightBasic^ do
  begin
    rmsg := SM_ATTRIB_FIGHTBASIC;
    SetWordString(rWordString, astr);
    ComData.Size := sizeof(TSAttribFightBasic) - sizeof(TWordString) + sizeofwordstring(rwordstring);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendAttribUPDATE(atype: TAttribUPDATEType; avaluer: integer);
var
  ComData: TWordComData;
  pSAttribUPDATE: pTSAttribUPDATE;

begin
  pSAttribUPDATE := @ComData.Data;
  with pSAttribUPDATE^ do
  begin
    rmsg := SM_ATTRIB_UPDATE;
    rType := atype;
    rvaluer := avaluer;
  end;
  ComData.Size := sizeof(TSAttribUPDATE);
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendAttribValues(var AttribData: TAttribData; var CurAttribData: TCurAttribData; var aAQuestData: TAttribQuestData);
var
  ComData: TWordComData;
  psAttribValues: PTSAttribValues;
begin
  psAttribValues := @ComData.Data;
  with psAttribValues^ do
  begin
    rmsg := SM_ATTRIB_VALUES;

    rLight := AttribData.cLight + aAQuestData.Light;
    rDark := AttribData.cDark + aAQuestData.Dark;
    rMagic := AttribData.cMagic + aAQuestData.Magic;

    rTalent := AttribData.cTalent + aAQuestData.Talent;
    rGoodChar := AttribData.cGoodChar + aAQuestData.GoodChar;
    rBadChar := AttribData.cBadChar + aAQuestData.BadChar;
    rLucky := AttribData.cLucky + aAQuestData.lucky;
    rAdaptive := AttribData.cAdaptive + aAQuestData.adaptive;
    rRevival := AttribData.cRevival + aAQuestData.Revival;
    rimmunity := AttribData.cimmunity + aAQuestData.immunity;
    rVirtue := AttribData.cVirtue + aAQuestData.virtue;

    rhealth := AttribData.cHealth + aAQuestData.Health;
    rsatiety := AttribData.cSatiety + aAQuestData.Satiety;
    rpoisoning := AttribData.cPoisoning + aAQuestData.Poisoning;

    rCurhealth := CurAttribData.Curhealth;
    rCursatiety := CurAttribData.Cursatiety;
    rCurpoisoning := CurAttribData.Curpoisoning;

    rHeadSeak := AttribData.cHeadSeak + aAQuestData.HeadSeak;
    rArmSeak := AttribData.cArmSeak + aAQuestData.ArmSeak;
    rLegSeak := AttribData.cLegSeak + aAQuestData.LegSeak;



    rCurHeadSeak := CurAttribData.CurHeadSeak;
    rCurArmSeak := CurAttribData.CurArmSeak;
    rCurLegSeak := CurAttribData.CurLegSeak;
    rlucky := AttribData.lucky;

    rCTalent := AttribData.newTalent;
    rCTalentLv := AttribData.newTalentLv;
    rCTalentExp := AttribData.newTalentExp;
    rCTalentNextLvExp := AttribData.newTalentNextLvExp;
    rCnewBone := AttribData.newBone;
    rCnewLeg := AttribData.newLeg;
    rCnewSavvy := AttribData.newSavvy;
    rCnewAttackPower := AttribData.newAttackPower;

    ComData.Size := SizeOf(TSAttribValues);
  end;

  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.sendItemText(aname, atext: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ItemTextAdd);
  WordComData_ADDstring(ComData, aname);
  WordComData_ADDstring(ComData, atext);
  SendData(ComData);
end;

procedure TSendClass.Sendcharattrib(var aAttribData: TAttribData; var aCurAttribData: TCurAttribData; var aLifeData: TLifeData);
var
  ComData: TWordComData;
  PScharattrib: PTcharattrib;
  n: integer;
begin
  PScharattrib := @ComData.Data;
  with PScharattrib^ do
  begin
    rmsg := SM_charattrib;

    rEnergy := aAttribData.cEnergy;
    rEnergyName := '保留';

    rAttackSpeed := aLifeData.AttackSpeed;
    rAvoid := aLifeData.avoid;
    rAccuracy := 39999;
    rRecovery := aLifeData.recovery;
    rKeepRecovery := aLifeData.HitArmor; //20130910

    rDamageBody := aLifeData.damageBody;
    rDamageHead := aLifeData.damageHead;
    rDamageArm := aLifeData.damageArm;
    rDamageLeg := aLifeData.damageLeg;
    rArmorBody := aLifeData.armorBody;
    rArmorHead := aLifeData.armorHead;
    rArmorArm := aLifeData.armorArm;
    rArmorLeg := aLifeData.armorLeg;
    rInPower := aAttribData.cInPower;
    rOutPower := aAttribData.cOutPower;
    rMagic := aAttribData.cMagic;
    rLife := aAttribData.cLife;
    rDefaultValue := aAttribData.cEnergy;
    with aAttribData do n := cEnergy + cMagic + cInPower + cOutPower + cLife;
    n := (n - 5000) div 4000;
    n := n - 5;
    if n <= 0 then n := 1;
    if n > 6 then n := 6;

    rShoutLevel := inttostr(n) + '境界';

    ComData.Size := SizeOf(Tcharattrib);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendLifeData(aLifeData: TLifeData);
var
  ComData: TWordComData;
  pSLifeData: pTSLifeData;
begin
  pSLifeData := @ComData.Data;
  with pSLifeData^ do
  begin
    rmsg := SM_LifeData;
        //damage 攻击
    damageBody := aLifeData.damageBody; //身体
    damageHead := aLifeData.damageHead; //头
    damageArm := aLifeData.damageArm; //武器
    damageLeg := aLifeData.damageLeg; //腿
        //armor 防御
    armorBody := aLifeData.armorBody;
    armorHead := aLifeData.armorHead;
    armorArm := aLifeData.armorArm;
    armorLeg := aLifeData.armorLeg;

    AttackSpeed := aLifeData.AttackSpeed; //攻击速度
    avoid := aLifeData.avoid; //躲避
    recovery := aLifeData.recovery; //恢复
    HitArmor := aLifeData.HitArmor;
    accuracy := aLifeData.accuracy;
    ComData.Size := SizeOf(TSLifeData);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendAttribBase(var AttribData: TAttribData; var CurAttribData: TCurAttribData; var aAQuestData: TAttribQuestData);
var /////发送人物数据
  ComData: TWordComData;
  psAttribBase: PTSAttribBase;
begin
  psAttribBase := @ComData.Data;
  with psAttribBase^ do
  begin
    rmsg := SM_ATTRIBBASE;
    rAge := AttribData.cAge + aAQuestData.Age; //年龄

    rEnergy := AttribData.cEnergy + aAQuestData.Energy; //元气
    rCurEnergy := CurAttribData.CurEnergy;

    rInPower := AttribData.cInPower + aAQuestData.InPower; //内功
    rCurInPower := CurAttribData.CurInPower;

    rOutPower := AttribData.cOutPower + aAQuestData.OutPower; //外功
    rCurOutPower := CurAttribData.CurOutPower;

    rMagic := AttribData.cMagic + aAQuestData.Magic; //武功
    rCurMagic := CurAttribData.CurMagic;

    rLife := AttribData.cLife + aAQuestData.Life; //活力 生命
    rCurLife := CurAttribData.CurLife;
    rlucky := AttribData.lucky;
    rCTalent := AttribData.newTalent;
    rCTalentLv := AttribData.newTalentLv;
    rCTalentExp := AttribData.newTalentExp;
    rCTalentNextLvExp := AttribData.newTalentNextLvExp;
    rCnewBone := AttribData.newBone;
    rCnewLeg := AttribData.newLeg;
    rCnewSavvy := AttribData.newSavvy;
    rCnewAttackPower := AttribData.newAttackPower;
    ComData.Size := SizeOf(TSAttribBase);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendChangeFeature_NameColor(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;

  pSNameColor: pTSNameColor;
begin
  if isDynamicObjectID(aSenderInfo.id) then
  begin

  end else
  begin
    pSNameColor := @ComData.Data;
    with pSNameColor^ do
    begin
      rmsg := SM_CHANGEFEATURE_NameColor;
      rId := aSenderInfo.id;
      rNameColor := aSenderInfo.Feature.rNameColor;
      ComData.Size := SizeOf(TSNameColor);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
  end;
end;

procedure TSendClass.SendBooth(aid: integer; astate: boolean; aboothname: string; ashape: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_CHANGEFEATURE);
  WordComData_ADDdword(ComData, aid);
  //状态
  WordComData_ADDbyte(ComData, Byte(astate));
  //名字
  WordComData_ADDstring(ComData, aboothname);
  //外观
  WordComData_ADDdword(ComData, ashape);

  SendData(ComData);
end;

procedure TSendClass.SendChangeFeature(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;
  psChangeFeature: PTSChangeFeature;
  PSChangeFeature_Npc_MONSTER: PTSChangeFeature_Npc_MONSTER;
  PSdie_Npc_MONSTER: PTSdie_Npc_MONSTER;
  psChangeState: PTSChangeState;
  i, n, maxx: integer;
  pp: pTLifeDataListdata;
  abuff: TLifeDataList;
begin
  if ((aSenderInfo.Feature.rRace = RACE_MONSTER) and (aSenderInfo.Feature.rMonType = 0))
    or (aSenderInfo.Feature.rRace = RACE_NPC) then
  begin
    if (aSenderInfo.boHaveSwap = false)
      and (aSenderInfo.Feature.rfeaturestate = wfs_die) then
    begin
        //非变身状态 发送死亡
      PSdie_Npc_MONSTER := @ComData.Data;
      PSdie_Npc_MONSTER.rmsg := SM_die_Npc_MONSTER;
      PSdie_Npc_MONSTER.rId := aSenderInfo.id;
      PSdie_Npc_MONSTER.rfeaturestate := aSenderInfo.Feature.rfeaturestate;

      ComData.Size := SizeOf(TSdie_Npc_MONSTER);

      Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
      EXIT;

    end;

    PSChangeFeature_Npc_MONSTER := @ComData.Data;
    with PSChangeFeature_Npc_MONSTER^ do
    begin
      rmsg := SM_CHANGE_Npc_MONSTER;
      rId := aSenderInfo.id;

      rFeature_npc_MONSTER.rrace := aSenderInfo.Feature.rrace;
      rFeature_npc_MONSTER.rMonType := aSenderInfo.Feature.rMonType;
      rFeature_npc_MONSTER.rTeamColor := aSenderInfo.Feature.rTeamColor;
      rFeature_npc_MONSTER.rImageNumber := aSenderInfo.Feature.rImageNumber;
      rFeature_npc_MONSTER.raninumber := aSenderInfo.Feature.raninumber;
      rFeature_npc_MONSTER.rHideState := aSenderInfo.Feature.rHideState;
      rFeature_npc_MONSTER.AttackSpeed := aSenderInfo.Feature.AttackSpeed;
      rFeature_npc_MONSTER.WalkSpeed := aSenderInfo.Feature.WalkSpeed;
      rFeature_npc_MONSTER.rfeaturestate := aSenderInfo.Feature.rfeaturestate;

      rBuffEffectCount := 0;
      maxx := Length(rBuffEffect);
      if TMonster(aSenderInfo.P).LifeBuffer <> 0 then
        n := TLifeDataList(TMonster(aSenderInfo.P).LifeBuffer).Count
      else
        n := 0;
      with TMonster(aSenderInfo.P) do
      for i:= 0 to n - 1 do
      begin
        if rBuffEffectCount > maxx then Break;
        pp := TLifeDataList(LifeBuffer).DataList[i];
        if pp^.reffect > 0 then
          rBuffEffect[rBuffEffectCount] := pp^.reffect;
        inc(rBuffEffectCount);
      end;
      if TMonster(aSenderInfo.P).MultiplyBuffer <> 0 then
        n := TLifeDataList(TMonster(aSenderInfo.P).MultiplyBuffer).Count
      else
        n := 0;
      with TMonster(aSenderInfo.P) do
      for i:= 0 to n - 1 do
      begin
        if rBuffEffectCount > maxx then Break;
        pp := TLifeDataList(MultiplyBuffer).DataList[i];
        if pp^.reffect > 0 then
          rBuffEffect[rBuffEffectCount] := pp^.reffect;
        inc(rBuffEffectCount);
      end;

      ComData.Size := SizeOf(TSChangeFeature_Npc_MONSTER) - Length(rBuffEffect) + SizeOf(Word)*rBuffEffectCount;
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
    EXIT;
  end;
  if isDynamicObjectID(aSenderInfo.id) then
  begin
    psChangeState := @ComData.Data;
    with psChangeState^ do
    begin
      rmsg := SM_CHANGESTATE;
      rId := aSenderInfo.id;
      rState := aSenderInfo.Feature.rHitMotion;
      rFrameStart := aSenderInfo.nx;
      rFrameEnd := aSenderInfo.ny;
      ComData.Size := SizeOf(TSChangeState);
      //ComData.Size := SizeOf(TSChangeFeature);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
  end else
  begin
    psChangeFeature := @ComData.Data;
    with psChangeFeature^ do
    begin
      rmsg := SM_CHANGEFEATURE;
      rId := aSenderInfo.id;
      rFeature := aSenderInfo.Feature;
      rBuffEffectCount := 0;
      maxx := Length(rBuffEffect);
      if (aSenderInfo.Feature.rRace = RACE_MONSTER) then
        abuff := TLifeDataList(TMonster(aSenderInfo.P).LifeBuffer)
      else
        abuff := TUser(aSenderInfo.P).LifeBuffer;
      if abuff <> nil then
      begin
        n := abuff.Count;
        for i:= 0 to n - 1 do
        begin
          if rBuffEffectCount > maxx then Break;
          pp := abuff.DataList[i];
          if pp^.reffect > 0 then
            rBuffEffect[rBuffEffectCount] := pp^.reffect;
          inc(rBuffEffectCount);
        end;
      end;
      if (aSenderInfo.Feature.rRace = RACE_MONSTER) then
        abuff := TLifeDataList(TMonster(aSenderInfo.P).MultiplyBuffer)
      else
        abuff := TUser(aSenderInfo.P).MultiplyBuffer;
      if abuff <> nil then
      begin
        n := abuff.Count;
        for i:= 0 to n - 1 do
        begin
          if rBuffEffectCount > maxx then Break;
          pp := abuff.DataList[i];
          if pp^.reffect > 0 then
            rBuffEffect[rBuffEffectCount] := pp^.reffect;
          inc(rBuffEffectCount);
        end;
      end;
      ComData.Size := SizeOf(TSChangeFeature) - Length(rBuffEffect) + SizeOf(Word)*rBuffEffectCount;
            //  if rFeature.rrace = RACE_NPC then rFeature.rrace := RACE_MONSTER;
      //ComData.Size := SizeOf(TSChangeFeature);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
  end;
end;

procedure TSendClass.SendChangeProperty(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;
  psChangeProperty: PTSChangeProperty;
  str: string;
begin
  psChangeProperty := @ComData.Data;

  with psChangeProperty^ do
  begin
    str := (aSenderInfo.ViewName);
        //if aSenderInfo.Guild[0] <> 0 then
    if aSenderinfo.BasicObjectType = botUser then
    begin
      str := str + ',' + (aSenderInfo.Guild);
      str := str + ',' + (aSenderInfo.ConsortName);
    end;
        // if Length(str) >= 18 then str := Copy(str, 1, 18);
    rmsg := SM_CHANGEPROPERTY;
    rId := aSenderInfo.id;

    SetWordString(rWordString, str);
    ComData.Size := SizeOf(TSChangeProperty) - sizeof(TWordString) + sizeofWordstring(rWordString);

  end;

  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendKEYf5f12();
var
  ComData: TWordComData;
  tt: pTSkey;
begin
  tt := @ComData.Data;
  with tt^ do
  begin
    rmsg := SM_keyf5f12;
    move(Connector.CharData.KeyArr[0], rkey[0], 8);
    move(Connector.CharData.ShortcutKeyArr[0], rkey2[0], 8);
    ComData.Size := SizeOf(TSkey);
  end;

  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendEventString(astr: string);
var
  ComData: TWordComData;

  psEventString: PTSEventString;
begin
  psEventString := @ComData.Data;
  with psEventString^ do
  begin
    rmsg := SM_EVENTSTRING;
    rKEY := EventString_Attrib;
    SetWordString(rWordString, astr);
    ComData.Size := sizeof(TSEventString) - sizeof(TWordString) + sizeofwordstring(rwordstring);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendUsedMagicString(astr: string; aSkillLevel: word);
var
  ComData: TWordComData;

  psEventString: PTSEventString;
begin
  psEventString := @ComData.Data;
  with psEventString^ do
  begin
    rmsg := SM_USEDMAGICSTRING;
    rKEY := aSkillLevel;
    SetWordString(rWordString, astr);
    ComData.Size := sizeof(TSEventString) - sizeof(TWordString) + sizeofwordstring(rwordstring);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendShootMagic(var aSenderinfo: TBasicData; atid: integer;
  ax, ay, abowimage, abowspeed: word; atype: byte; EEffectNumber: integer);
var
  ComData: TWordComData;
  psMovingMagic: PTSMovingMagic;
begin
  psMovingMagic := @ComData.Data;
  with psMovingMagic^ do
  begin
    rmsg := SM_MOVINGMAGIC;
    rsid := aSenderInfo.id;
    reid := atid;
    rtx := ax;
    rty := ay;
    rMoveingstyle := 0;
    rsf := 0;
    rmf := abowimage;
    ref := EEffectNumber;
    rspeed := abowspeed; //rspeed := 20;

    rafterimage := 0;
    rafterover := 0;
    rtype := atype;

    ComData.Size := SizeOf(TSMovingMagic);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendSayUseMagic(var aSenderinfo: TBasicData; astr: string);
var
  ComData: TWordComData;
  psSay: PTSSay;
begin
  psSay := @ComData.Data;
  with psSay^ do
  begin
    rmsg := SM_SAYUSEMAGIC;
    rId := aSenderInfo.id;
    rkind := 0;

    SetWordString(rWordString, astr);
    ComData.Size := sizeof(TSSay) - sizeof(TWordString) + sizeofwordstring(rwordstring);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendSay(var aSenderinfo: TBasicData; astr: string);
var
  ComData: TWordComData;

  psSay: PTSSay;
begin
  psSay := @ComData.Data;
  with psSay^ do
  begin
    rmsg := SM_SAY;
    rId := aSenderInfo.id;
    rkind := 0;
    SetWordString(rWordString, astr);
    ComData.Size := sizeof(TSSay) - sizeof(TWordString) + sizeofwordstring(rwordstring);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendSayEx(var aSenderinfo: TBasicData; astr: string;
  aSay: PTCSayItem);
var
  ComData: TWordComData;
  cnt: integer;
  psChatMessage: PTSChatItemMessage;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin
    rmsg := SM_CHATITEMMESSAGENORMAL;
    rId := aSenderinfo.id;
    rIsHead := False;
    rSn := aSay^.rChatItemData.rId;
    rtype := aSay^.rtype;
    rpos := aSay^.rpos;
    rFColor := WinRGB(0, 0, 0);
    rBColor := WinRGB(0, 0, 0);
    SetWordString(rWordstring, aStr);
    copymemory(@rChatItemData, @aSay^.rChatItemData, sizeof(TItemData));
    ComData.Size := Sizeof(TSChatItemMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end; 

procedure TSendClass.SendSayExHead(var aSenderinfo: TBasicData; astr: string;
  aSay: PTCSayItem; aId: integer);
var
  ComData: TWordComData;
  cnt: integer;
  psChatMessage: PTSChatItemMessageHead;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin
    rmsg := SM_CHATITEMMESSAGENORMAL;
    rId := aSenderinfo.id;
    rIsHead := True;
    rSn := aId;
    rItemName := aSay^.rChatItemData.rViewName;
    rtype := aSay^.rtype;
    rpos := aSay^.rpos;
    rFColor := WinRGB(0, 0, 0);
    rBColor := WinRGB(0, 0, 0);
    SetWordString(rWordstring, aStr);
    ComData.Size := Sizeof(TSChatItemMessageHead) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendSelChar(id: integer);
var
  ComData: TWordComData;

begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_SelChar);
  WordComData_ADDdword(ComData, id);
  SendData(ComData);
end;

procedure TSendClass.SendTurn(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;
  psTurn: PTSTurn;
  akey: Word; //2016.03.15 在水一方 反外挂
begin
  psTurn := @ComData.Data;
  with psTurn^ do
  begin
    rmsg := SM_TURN;
    rId := aSenderInfo.id;
    rdir := aSenderInfo.dir;
    if checkwg then begin
      akey := Random(65535) + 1;
      rx := aSenderInfo.x xor akey;
      ry := aSenderInfo.y xor akey;
      asm
        ror akey,4
      end;
      renckey := akey;
    end
    else begin
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      renckey := 0;
    end;
    ComData.Size := SizeOf(TSTurn);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendMagicEffect(aid, aMagicEffect: integer; aEffecttype: TLightEffectKind);
var
  ComData: TWordComData;
  pSMagicEffect: pTSMagicEffect;
begin
  pSMagicEffect := @ComData.Data;
  with pSMagicEffect^ do
  begin
    rmsg := SM_MagicEffect;
    rId := aid;
    reffectNum := aMagicEffect;
    reffecttype := aEffecttype;
    ComData.Size := SizeOf(TSMagicEffect);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendEffect(aid, aMagicEffect: integer; aEffecttype: TLightEffectKind; aCount: Integer);
var
  ComData: TWordComData;
  pSEffect: pTSEffect;
begin
  pSEffect := @ComData.Data;
  with pSEffect^ do
  begin
    rmsg := SM_Effect;
    rId := aid;
    reffectNum := aMagicEffect;
    reffecttype := aEffecttype;
    rrepeat := aCount;
    ComData.Size := SizeOf(TSMagicEffect);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendMove(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;
  psMove: PTSMove;
  akey: Word;
begin
  psMove := @ComData.Data;
  with psMove^ do
  begin
    rmsg := SM_MOVE;
    rId := aSenderInfo.id;
    rdir := aSenderInfo.dir;
    if checkwg then begin
      akey := Random(65535) + 1;
      rx := aSenderInfo.x xor akey;
      ry := aSenderInfo.y xor akey;
      asm
        ror akey,4
      end;
      renckey := akey;
    end
    else begin
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      renckey := 0;
    end;

    ComData.Size := SizeOf(TSMove);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendSetPosition(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;
  psSetPosition: PTSSetPosition;
  akey: Word; //2016.03.15 在水一方 反外挂
begin
  psSetPosition := @ComData.Data;
  with psSetPosition^ do
  begin
    rmsg := SM_SETPOSITION;
    rid := aSenderInfo.id;
    rdir := aSenderInfo.dir;
    if checkwg then begin
      akey := Random(65535) + 1;
      rx := aSenderInfo.x xor akey;
      ry := aSenderInfo.y xor akey;
      asm
        ror akey,4
      end;
      renckey := akey;
    end
    else begin
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      renckey := 0;
    end;
    ComData.Size := SizeOf(TSSetPosition);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendGulidKillstate(Value: boolean);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_GUILD);
  WordComData_ADDbyte(ComData, GUILD_sys);
  WordComData_ADDbyte(ComData, byte(Value));
  SendData(ComData);
end;

procedure TSendClass.SendMoveOk();
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_MOVEOk);
  SendData(ComData);
end;

procedure TSendClass.SendMapObject(x, y: integer; aname: string; atype: integer);
var
  ComData: TWordComData;
  pNpclist: pTSMapObject;

begin
  pNpclist := @ComData.Data;
  with pNpclist^ do
  begin
    rmsg := SM_MapObject;
    rx := X;
    ry := Y;
    rtype := atype;
    SetWordString(rWordString, aname);
    ComData.Size := sizeof(TSMapObject) - sizeof(TWordString) + sizeofwordstring(rwordstring);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendHailFellowDel(aname: string);
var
  ComData: TWordComData;
  pp: pTSHailFellowbasic;

begin
  pp := @ComData.Data;
  with pp^ do
  begin
    rmsg := SM_HailFellow;
    rkey := HailFellow_del;
    rName := aname;
    ComData.Size := sizeof(TSHailFellowbasic);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendHailFellowDel2(aname: string);
var
  ComData: TWordComData;
  pp: pTSHailFellowbasic;

begin
  pp := @ComData.Data;
  with pp^ do
  begin
    rmsg := SM_HailFellow;
    rkey := HailFellow_DEL2;
    rName := aname;
    ComData.Size := sizeof(TSHailFellowbasic);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;


procedure TSendClass.SendHailFellowGameExit(aname: string);
var
  ComData: TWordComData;
  pp: pTSHailFellowbasic;

begin
  pp := @ComData.Data;
  with pp^ do
  begin
    rmsg := SM_HailFellow;
    rkey := HailFellow_GameExit;
    rName := aname;
    ComData.Size := sizeof(TSHailFellowbasic);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;
//aname  增加 好友 是否同意

procedure TSendClass.SendHailFellow_Message_ADD(aname: string);
var
  ComData: TWordComData;
  pp: pTSHailFellowbasic;

begin
  pp := @ComData.Data;
  with pp^ do
  begin
    rmsg := SM_HailFellow;
    rkey := HailFellow_Message_ADD;
    rName := aname;
    ComData.Size := sizeof(TSHailFellowbasic);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendHailFellow(aname, amapname: string; ax, ay, astate: integer);
var
  ComData: TWordComData;
  pp: pTSHailFellowChangeProperty;

begin
  pp := @ComData.Data;
  with pp^ do
  begin
    rmsg := SM_HailFellow;
    rkey := HailFellowChangeProperty;
    rstate := astate;
    rx := ax;
    ry := ay;
    rMapName := amapname;
    rName := aname;
    ComData.Size := sizeof(TSHailFellowChangeProperty);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;



procedure TSendClass.SendHailFellowList(aname: string; atype: Integer);
var
  ComData: TWordComData;
  pp: pTSHailFellowMysqlList;
begin
  pp := @ComData.Data;
  with pp^ do
  begin
    rmsg := SM_HailFellow;
    rkey := HailFellow_Mysql_List;
    rName := aname;
    rType := atype;
    ComData.Size := sizeof(TSHailFellowMysqlList);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;    

procedure TSendClass.SendHailFellowMysqlDel(aname: string; atype: Integer);
var
  ComData: TWordComData;
  pp: pTSHailFellowMysqlList;
begin
  pp := @ComData.Data;
  with pp^ do
  begin
    rmsg := SM_HailFellow;
    rkey := HailFellow_MYSQLDEL;
    rName := aname;
    rType := atype;
    ComData.Size := sizeof(TSHailFellowMysqlList);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;
procedure TSendClass.SendMap(var aSenderInfo: TBasicData; amap, aobj, arof, atil, aSoundBase, aMAPTitle: string);
var
  ComData: TWordComData;
  psNewMap: PTSNewMap;

begin
  SendSoundBase('', 100);

  psNewMap := @ComData.Data;
  FillChar(psNewMap^, SizeOf(TSNewMap), 0);
  with psNewMap^ do
  begin
    rmsg := SM_NEWMAP;
    rMapName := aMap;
    rCharName := aSenderInfo.ViewName;
    rId := aSenderInfo.id;
    rx := aSenderInfo.x;
    ry := aSenderInfo.y;
    rObjName := aobj;
    rRofName := arof;
    rTilName := atil;
    rMapTitle := aMAPTitle;
    ComData.Size := SizeOf(TSNewMap);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));

  if aSoundBase <> '' then
  begin
    SendSoundBase(aSoundBase + '.mp3', 100);
  end;
end;

procedure TSendClass.SendShow(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;
  i: integer;
  psShow: PTSShow;
  pSShow_Npc_MONSTER: pTSShow_Npc_MONSTER;
  psShowItem: PTSShowItem;
  pssVirtualObject: pTssVirtualObject;

  psShowDynamicObject: PTSShowDynamicObject;
  str: shortstring;
  akey: Word; //2016.03.15 在水一方 反外挂
  SubData: TSubData;
  //  dod: TDynamicObjectData;
begin
  if aSenderInfo.ClassKind = CLASS_SERVEROBJ then exit;


  if ((aSenderInfo.Feature.rRace = RACE_MONSTER) and (aSenderInfo.Feature.rMonType = 0))
    or (aSenderInfo.Feature.rRace = RACE_NPC) then
  begin
    pSShow_Npc_MONSTER := @ComData.Data;
    with pSShow_Npc_MONSTER^ do
    begin
      str := (aSenderInfo.ViewName);
      str := str + ',' + (aSenderInfo.Guild);
      str := str + ',' + (aSenderInfo.ConsortName);
      rmsg := SM_SHOW_Npc_MONSTER;
      rId := aSenderInfo.id;
      rdir := aSenderInfo.dir;
      if checkwg then begin
        akey := Random(65535) + 1;
        rx := aSenderInfo.x xor akey;
        ry := aSenderInfo.y xor akey;
        asm
          ror akey,7
        end;
        rFeature_npc_MONSTER.rEncKey := akey;
      end
      else begin
        rx := aSenderInfo.x;
        ry := aSenderInfo.y;
        rFeature_npc_MONSTER.renckey := 0;
      end;

      rFeature_npc_MONSTER.rrace := aSenderInfo.Feature.rrace;
      rFeature_npc_MONSTER.rMonType := aSenderInfo.Feature.rMonType;
      rFeature_npc_MONSTER.rTeamColor := aSenderInfo.Feature.rTeamColor;
      rFeature_npc_MONSTER.rImageNumber := aSenderInfo.Feature.rImageNumber;
      rFeature_npc_MONSTER.raninumber := aSenderInfo.Feature.raninumber;
      rFeature_npc_MONSTER.rHideState := aSenderInfo.Feature.rHideState;
      rFeature_npc_MONSTER.AttackSpeed := aSenderInfo.Feature.AttackSpeed;
      rFeature_npc_MONSTER.WalkSpeed := aSenderInfo.Feature.WalkSpeed;
      rFeature_npc_MONSTER.rfeaturestate := aSenderInfo.Feature.rfeaturestate;


      SetWordString(rWordString, str);
      ComData.Size := sizeof(TSShow_Npc_MONSTER) - sizeof(twordstring) + sizeofwordstring(rwordstring);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
    if (aSenderInfo.Feature.rrace = RACE_MONSTER) then
    begin
      if (TMonster(aSenderInfo.p).LifeBuffer <> 0) or (TMonster(aSenderInfo.p).MultiplyBuffer <> 0) then
        TMonster(aSenderInfo.p).SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, aSenderInfo, SubData);
    end;
    exit;
  end;
  if (aSenderInfo.Feature.rrace = RACE_HUMAN)
    or (aSenderInfo.Feature.rRace = RACE_MONSTER) then
  begin
    psShow := @ComData.Data;
    with psShow^ do
    begin
      str := (aSenderInfo.ViewName);
            //if aSenderInfo.Guild[0] <> 0 then
      str := str + ',' + (aSenderInfo.Guild);
      str := str + ',' + (aSenderInfo.ConsortName);

      rmsg := SM_SHOW;
      rId := aSenderInfo.id;

      rdir := aSenderInfo.dir;
      if checkwg then begin
        akey := Random(65535) + 1;
        rx := aSenderInfo.x xor akey;
        ry := aSenderInfo.y xor akey;
        asm
          ror akey,7
        end;
        rFeature := aSenderInfo.Feature;
        rFeature.rEncKey := akey;
      end
      else begin
        rx := aSenderInfo.x;
        ry := aSenderInfo.y;
        rFeature := aSenderInfo.Feature;
        rFeature.rEncKey := 0;
      end;
            //            if rFeature.rrace = RACE_NPC then rFeature.rrace := RACE_MONSTER;
      SetWordString(rWordString, str);

      ComData.Size := sizeof(TSShow) - sizeof(twordstring) + sizeofwordstring(rwordstring);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
    if (aSenderInfo.Feature.rrace = RACE_HUMAN) then
    begin
      if (TUser(aSenderInfo.p).LifeBuffer.Count + TUser(aSenderInfo.p).MultiplyBuffer.Count > 0) then
        TUser(aSenderInfo.p).SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, aSenderInfo, SubData);
    end;
    exit;
  end;
  if (aSenderInfo.Feature.rRace = RACE_VirtualObject) then
  begin
    pssVirtualObject := @ComData.Data;
    with pssVirtualObject^ do
    begin
      rmsg := SM_ShowVirtualObject;
      rid := aSenderInfo.id;
      rNameString := aSenderInfo.ViewName;
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      Width := aSenderinfo.nx;
      Height := aSenderinfo.ny;
      rRace := aSenderInfo.Feature.rRace;
      ComData.Size := SizeOf(TssVirtualObject);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
    exit;
  end;

  if (aSenderInfo.Feature.rRace = RACE_ITEM)
    or (aSenderInfo.Feature.rRace = RACE_STATICITEM) then
  begin
    psShowItem := @ComData.Data;
    with psShowItem^ do
    begin
      rmsg := SM_SHOWITEM;
      rid := aSenderInfo.id;
      rNameString := aSenderInfo.ViewName;
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      rShape := aSenderInfo.Feature.rImageNumber;
      rColor := aSenderInfo.Feature.rImageColorIndex;
      rRace := aSenderInfo.Feature.rRace;
      ComData.Size := SizeOf(TSShowItem);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
    exit;
  end;

  if aSenderInfo.Feature.rrace = RACE_DYNAMICOBJECT then
  begin
    psShowDynamicObject := @ComData.Data;
    FillChar(psShowDynamicObject^, SizeOf(TSShowDynamicObject), 0);

       // DynamicObjectClass.GetDynamicObjectData((aSenderInfo.Name), dod);
    with psShowDynamicObject^ do
    begin
      rmsg := SM_SHOWDYNAMICOBJECT;
      rid := aSenderInfo.id;
      rNameString := aSenderInfo.ViewName;
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      rShape := aSenderInfo.Feature.rImageNumber;
      rState := aSenderInfo.Feature.rHitMotion;
      rFrameStart := aSenderInfo.nx;
      rFrameEnd := aSenderInfo.ny;
      ComData.Size := SizeOf(TSShowDynamicObject);
    end;
        {
        for i := 0 to 10 - 1 do
        begin
            if (dod.rGuardX[i] = 0) and (dod.rGuardY[i] = 0) then break;
            psShowDynamicObject^.rGuardX[i] := dod.rGuardX[i];
            psShowDynamicObject^.rGuardY[i] := dod.rGuardY[i];
        end;
         }
    for i := 0 to 10 - 1 do
    begin
      if (aSenderInfo.GuardX[i] = 0) and (aSenderInfo.Guardy[i] = 0) then break;
      psShowDynamicObject^.rGuardX[i] := aSenderInfo.GuardX[i];
      psShowDynamicObject^.rGuardY[i] := aSenderInfo.GuardY[i];
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
    exit;
  end;
  if (aSenderInfo.Feature.rrace = RACE_MineObject)
    or (aSenderInfo.Feature.rrace = RACE_GroupMoveObject) then
  begin
    psShowDynamicObject := @ComData.Data;
    FillChar(psShowDynamicObject^, SizeOf(TSShowDynamicObject), 0);

//        DynamicObjectClass.GetDynamicObjectData((aSenderInfo.Name), dod);
    with psShowDynamicObject^ do
    begin
      rmsg := SM_SHOWDYNAMICOBJECT;
      rid := aSenderInfo.id;
      rNameString := aSenderInfo.ViewName;
      rx := aSenderInfo.x;
      ry := aSenderInfo.y;
      rShape := aSenderInfo.Feature.rImageNumber;
      rState := aSenderInfo.Feature.rHitMotion;
      rFrameStart := aSenderInfo.nx;
      rFrameEnd := aSenderInfo.ny;
      ComData.Size := SizeOf(TSShowDynamicObject);
    end;
    for i := 0 to 10 - 1 do
    begin
      if (aSenderInfo.GuardX[i] = 0) and (aSenderInfo.Guardy[i] = 0) then break;
      psShowDynamicObject^.rGuardX[i] := aSenderInfo.GuardX[i];
      psShowDynamicObject^.rGuardY[i] := aSenderInfo.GuardY[i];
    end;

    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
    exit;
  end;
end;

procedure TSendClass.SendHide(var aSenderinfo: TBasicData);
var
  ComData: TWordComData;
  psHide: PTSHide;
begin
  if aSenderInfo.ClassKind = CLASS_SERVEROBJ then exit;

  psHide := @ComData.Data;
  with psHide^ do
  begin
    rmsg := SM_HIDE;
    if isObjectItemId(aSenderInfo.id) or isStaticItemId(aSenderInfo.id) then rmsg := SM_HIDEITEM;
    if isDynamicObjectID(aSenderInfo.id) then rmsg := SM_HIDEDYNAMICOBJECT;
    if isVirtualObjectID(aSenderInfo.id) then rmsg := SM_HIDEVirtualObject;
    rid := aSenderInfo.id;
    ComData.Size := SizeOf(TSHide);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendMotion2(aid, amotion: integer; aEffectimg: word; aEffectColor: byte);
var
  ComData: TWordComData;
  psMotion: PTSMotion2;
begin
  psMotion := @ComData.Data;
  with psMotion^ do
  begin
    rmsg := SM_MOTION2;
    rId := aid;
    rmotion := amotion;
    rEffectimg := aEffectimg;
    rEffectColor := aEffectColor;

    ComData.Size := SizeOf(TSMotion2);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendMotion(aid, amotion: integer);
var
  ComData: TWordComData;
  psMotion: PTSMotion;
begin
  psMotion := @ComData.Data;
  with psMotion^ do
  begin
    rmsg := SM_MOTION;
    rId := aid;
    rmotion := amotion;

    ComData.Size := SizeOf(TSMotion);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendStructed(var aSenderInfo: TBasicData; aPercent: integer);
var
  ComData: TWordComData;
  psStructed: PTSStructed;
begin
  psStructed := @ComData.Data;
  with psStructed^ do
  begin
    rmsg := SM_STRUCTED;
    rId := aSenderInfo.ID;
    if aSenderInfo.Feature.rRace <> RACE_DYNAMICOBJECT then
    begin
      rRace := RACE_HUMAN;
    end else
    begin
      rRace := aSenderInfo.Feature.rRace;
    end;
    rpercent := apercent;
    ComData.Size := SizeOf(TSStructed);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendQuestTempArrAll();
var
  ComData: TWordComData;
  i: integer;
begin
  ComData.Size := 0;
  i := high(Connector.CharData.QuesttempArr) + 1;
  WordComData_ADDbyte(ComData, SM_Quest);
  WordComData_ADDbyte(ComData, QuestTempArrList);
  WordComData_ADDbyte(ComData, i);
  for i := 0 to high(Connector.CharData.QuesttempArr) do
  begin
    WordComData_ADDdword(ComData, Connector.CharData.QuesttempArr[i]);
  end;

  SendData(ComData);
end;

procedure TSendClass.SendQuestTempArr(aindex: integer);
var
  ComData: TWordComData;
begin
  if (aindex < 0) or (aindex > high(Connector.CharData.QuesttempArr)) then exit;
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Quest);
  WordComData_ADDbyte(ComData, QuestTempArrUPdate);
  WordComData_ADDbyte(ComData, aindex);
  WordComData_ADDdword(ComData, Connector.CharData.QuesttempArr[aindex]);

  SendData(ComData);
end;

procedure TSendClass.SendTOPMSG(acolor: word; astr: string);
var
  ComData: TWordComData;

  PSShowCenterMsg: PTSShowCenterMsg;
begin
  PSShowCenterMsg := @ComData.Data;
  with PSShowCenterMsg^ do
  begin
    rmsg := SM_SHOWCENTERMSG;
    rColor := acolor;
    rtype := SHOWCENTERMSG_BatMsgTOP;
    SetWordString(rText, astr);
    ComData.Size := sizeof(TSShowCenterMsg) - sizeof(TWordString) + sizeofwordstring(rText);
  end;

  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendData(var ComData: TWordComData);
begin
  Connector.AddSendData((@ComData), ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendTESTMsg(astr: string);
begin
{$IFDEF test}
  SendChatMessage(astr, SAY_COLOR_SYSTEM);

{$ELSE}

{$ENDIF}

end;

procedure TSendClass.lockmoveTime(atime: integer); //锁定  一定时间 不能移动
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_LockMoveTime);
  WordComData_ADDdword(ComData, atime);
  SendData(ComData);
end;

procedure TSendClass.SendItemInputWindowsKey(aSubKey, akey: Integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ItemInputWindows);
  WordComData_ADDbyte(ComData, ItemInputWindows_key);
  WordComData_ADDbyte(ComData, aSubKey);
  WordComData_ADDdword(ComData, akey);
  SendData(ComData);
end;

procedure TSendClass.SendItemInputWindowsClose();
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ItemInputWindows);
  WordComData_ADDbyte(ComData, ItemInputWindows_Close);
  SendData(ComData);
end;

procedure TSendClass.SendItemInputWindowsOpen(aSubkey: integer; aCaption: string; aText: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ItemInputWindows);
  WordComData_ADDbyte(ComData, ItemInputWindows_Open);
  WordComData_ADDbyte(ComData, aSubkey);
  WordComData_ADDString(ComData, aCaption); //下发标签
  WordComData_ADDString(ComData, aText); //下发描述
  SendData(ComData);
end;

procedure TSendClass.SendLeftText(astr: string; aColor: word; atype: TMsgType = mtNone; ashape: Integer = 0);
var
  ComData: TWordComData;
  psLeftText: ptsLeftText;
begin
  psLeftText := @ComData.Data;
  with psLeftText^ do
  begin
    rmsg := SM_LeftText;
    rtype := atype;
    rFColor := aColor;
    rshape := ashape;
    SetWordString(rWordstring, aStr);
    ComData.Size := Sizeof(tsLeftText) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendChatMessage(astr: string; aColor: byte);
var
  ComData: TWordComData;
  psChatMessage: PTSChatMessage;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin

    rmsg := SM_CHATMESSAGE;
    case acolor of
      SAY_COLOR_NORMAL:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 0);
        end;
      SAY_COLOR_SHOUT:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 24);
        end;
      SAY_COLOR_SYSTEM:
        begin
          rFColor := WinRGB(22, 22, 0);
          rBColor := WinRGB(0, 0, 0);
        end;
      SAY_COLOR_NOTICE:
        begin
          rFColor := WinRGB(255 div 8, 255 div 8, 255 div 8);
          rBColor := WinRGB(133 div 8, 133 div 8, 133 div 8);
        end;
      //呐喊颜色
      SAY_COLOR_GRADE0:
        begin
          rFColor := WinRGB(18, 16, 14);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE1:
        begin
          rFColor := WinRGB(26, 23, 21);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE2:
        begin
          rFColor := WinRGB(31, 29, 27);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE3:
        begin
          rFColor := WinRGB(22, 18, 8);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE4:
        begin
          rFColor := WinRGB(23, 13, 4);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE5:
        begin
          rFColor := WinRGB(31, 29, 21);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE6:
        begin
          rFColor := WinRGB(30, 30, 1);
          rBColor := WinRGB(20, 10, 11);
        end;
      SAY_COLOR_GRADE7:
        begin
          rFColor := WinRGB(31, 30, 11);
          rBColor := WinRGB(25, 11, 11);
        end;
      SAY_COLOR_GRADE8:
        begin
          rFColor := WinRGB(31, 31, 1);
          rBColor := WinRGB(30, 5, 5);
        end;
      SAY_COLOR_GRADE9:
        begin
          rFColor := WinRGB(1, 31, 31);
          rBColor := WinRGB(1, 14, 20);
        end;
      SAY_COLOR_GRADE6lcred:
        begin
          rFColor := ColorSysToDxColor($FF); //WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 0);
        end;
        //副本说话颜色
      SAY_COLOR_MAP:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(1, 1, 1);
        end;
        //门派说话颜色
      SAY_COLOR_GUILD:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 1);
        end;
        //门派同盟说话颜色
      SAY_COLOR_GUILDALLY:
        begin
          rFColor := WinRGB(26, 23, 21);
          rBColor := WinRGB(2, 4, 6);
        end;
    else
      begin
        rFColor := WinRGB(22, 22, 22);
        rBColor := WinRGB(0, 0, 0);
      end;
    end;

    SetWordString(rWordstring, aStr);
    ComData.Size := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

//自定义色彩消息

procedure TSendClass.SendChatMessageByCol(astr: string; aFColor, aBColor: word);
var
  ComData: TWordComData;
  psChatMessage: PTSChatMessage;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin
    rmsg := SM_CHATMESSAGE;
    rFColor := (aFColor);
    rBColor := (aBColor);
    SetWordString(rWordstring, aStr);
    ComData.Size := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendChatMessageEx(astr: string; aColor: byte; aSay: PTCSayItem; aId: integer);
var
  ComData: TWordComData;
  cnt: integer;
  psChatMessage: PTSChatItemMessageHead;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin
    rmsg := SM_CHATITEMMESSAGE;
    case acolor of
      SAY_COLOR_NORMAL:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 0);
        end;
      SAY_COLOR_SHOUT:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 24);
        end;
      SAY_COLOR_SYSTEM:
        begin
          rFColor := WinRGB(22, 22, 0);
          rBColor := WinRGB(0, 0, 0);
        end;
      SAY_COLOR_NOTICE:
        begin
          rFColor := WinRGB(255 div 8, 255 div 8, 255 div 8);
          rBColor := WinRGB(133 div 8, 133 div 8, 133 div 8);
        end;

      SAY_COLOR_GRADE0:
        begin
          rFColor := WinRGB(18, 16, 14);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE1:
        begin
          rFColor := WinRGB(26, 23, 21);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE2:
        begin
          rFColor := WinRGB(31, 29, 27);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE3:
        begin
          rFColor := WinRGB(22, 18, 8);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE4:
        begin
          rFColor := WinRGB(23, 13, 4);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE5:
        begin
          rFColor := WinRGB(31, 29, 21);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE6lcred:
        begin
          rFColor := ColorSysToDxColor($FF); //WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 0);
        end;

    else
      begin
        rFColor := WinRGB(22, 22, 22);
        rBColor := WinRGB(0, 0, 0);
      end;
    end;
    rIsHead := True;
    rSn := aId;
    rItemName := aSay^.rChatItemData.rViewName;
    rtype := aSay^.rtype;
    rpos := aSay^.rpos;
    SetWordString(rWordstring, aStr);
    //copymemory(@rChatItemData, @aSay^.rChatItemData, sizeof(TItemData));
    ComData.Size := Sizeof(TSChatItemMessageHead) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendMSay(name, atext: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_MSay);
  WordComData_ADDstring(ComData, name);
  WordComData_ADDstring(ComData, atext);
  SendData(ComData);
end; 

procedure TSendClass.SendMSayEx(name, atext: string;
  amsayitem: PTCSayItemM);
var
  ComData: TWordComData;
  cnt: integer;
  psChatMessage: PTSChatItemMessageM;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin
    rmsg := SM_SAYITEMMESSAGEM;

    rtype := amsayitem^.rtype;
    rpos := amsayitem^.rpos;
    rName := name;
    SetWordString(rWordstring, atext);
    copymemory(@rChatItemData, @amsayitem^.rChatItemData, sizeof(TItemData));
    ComData.Size := Sizeof(TSChatItemMessageM) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendBuffData(Akey, Aid: byte; ABuffData: TBuffData);
var
  ComData: TWordComData;
  cnt: integer;
  pmBuffDataMessage: PTBuffDataMessage;
begin
  pmBuffDataMessage := @ComData.Data;
  with pmBuffDataMessage^ do
  begin
    rmsg := Akey;
    rid  := Aid;
    copymemory(@rBuffData, @ABuffData, sizeof(TBuffData));
    ComData.Size := Sizeof(TBuffDataMessage);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendAllBuffData(var AllBuffData: TAllBuffDataMessage);
var
  ComData: TWordComData;
  cnt: integer;
  pmBuffDataMessage: PTAllBuffDataMessage;
begin
  pmBuffDataMessage := @ComData.Data;
  pmBuffDataMessage^ := AllBuffData;
  with pmBuffDataMessage^ do
  begin
    rmsg := SM_ALLBUFF;
    ComData.Size := Sizeof(TAllBuffDataMessage) - (Length(AllBuffData.rBuffData)-AllBuffData.rbuffcount)*sizeof(TBuffData);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendNUMSAY(astr: byte; aColor: byte; atext: string = '');
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_NumSay);
  WordComData_ADDbyte(ComData, astr);
  WordComData_ADDbyte(ComData, aColor);
  WordComData_ADDstring(ComData, atext);

  SendData(ComData);
end;

procedure TSendClass.SendStatusMessage(astr: string);
var
  ComData: TWordComData;

  psMessage: PTSMessage;
begin
  psMessage := @ComData.Data;
  with psMessage^ do
  begin
    rmsg := SM_MESSAGE;
    rkey := MESSAGE_GAMEING;
    SetWordString(rWordstring, astr);
    ComData.Size := Sizeof(TSMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.Senditempro_MagicBasic(var aMagicData: TMagicData);
var
  ComData: TWordComData;

  psTSitemPro: pTSitemPro;
begin
  psTSitemPro := @ComData.Data;
  with psTSitemPro^ do
  begin
    rmsg := SM_ITEMPRO;
    rkey := itemproGET_MagicBasic; //区分 武功  物品
    rshape := 53; //aMagicData.rShape; //物品 图片

        // rcolor := aMagicData.rcolor;
 //        rGrade := aMagicData.rGrade; //品
 //        rlockState := aMagicData.rlockState; //锁 状态
 //        rlocktime := aMagicData.rlocktime; //在线  时间
 //        rlevel := aMagicData.rlevel; //等级
    rname := aMagicData.rName;
    SetWordString(rWordstring, GetMagicDataInfo(aMagicData));
    ComData.Size := Sizeof(TSitemPro) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));

end;

procedure TSendClass.Senditempro(var aItemData: TItemData);
var
  ComData: TWordComData;

  psTSitemPro: pTSitemPro;
begin
  psTSitemPro := @ComData.Data;
  with psTSitemPro^ do
  begin
    rmsg := SM_ITEMPRO;
    rkey := itemproGET; //区分 武功  物品
    rshape := aItemData.rShape; //物品 图片
    rcolor := aItemData.rcolor;
    rGrade := aItemData.rGrade; //品
    rlockState := aItemData.rlockState; //锁 状态
    rlocktime := aItemData.rlocktime; //在线  时间
    rSmithingLevel := aItemData.rSmithingLevel; //等级
    rname := AItemData.rViewName;
    SetWordString(rWordstring, GetItemDataInfo(aItemData));
    ComData.Size := Sizeof(TSitemPro) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));

end;
//发送 物品 到KF 端

procedure TSendClass.SendUPDATEItem_rtimemode_del(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rtimemode_del); //分类型
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rlocktime(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rlocktime); //分类型

  WordComData_ADDdword(ComData, ItemData.rlocktime); //解除时间
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rboBlueprint(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rboBlueprint); //分类型

  WordComData_ADDbyte(ComData, byte(ItemData.rboBlueprint));
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rboident(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rboident); //分类型

  WordComData_ADDbyte(ComData, byte(ItemData.rboident));
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rlockState(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rlockState); //分类型

  WordComData_ADDbyte(ComData, ItemData.rlockState);
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_add(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_add); //分类型
  TItemDataToTWordComData(ItemData, ComData);

  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_del(aTYPE: TSENDUPDATEITEMTYPE; akey: word);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_del); //分类型

  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_ChangeItem(aTYPE: TSENDUPDATEITEMTYPE; akey, akey2: word);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_ChangeItem); //分类型
  WordComData_ADDbyte(ComData, akey2); // 位置2

  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rcolor(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rcolor); //分类型

  WordComData_ADDdword(ComData, ItemData.rcolor);
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rcount_UP(aTYPE: TSENDUPDATEITEMTYPE; akey: word; acount: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rcount_UP); //分类型

  WordComData_ADDdword(ComData, acount);
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rcount_add(aTYPE: TSENDUPDATEITEMTYPE; akey: word; acount: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rcount_add); //分类型

  WordComData_ADDdword(ComData, acount);
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rcount_dec(aTYPE: TSENDUPDATEITEMTYPE; akey: word; acount: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rcount_dec); //分类型

  WordComData_ADDdword(ComData, acount);
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rDurability(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rDurability); //分类型

  WordComData_ADDdword(ComData, ItemData.rCurDurability);
  SendData(ComData);
end;

procedure TSendClass.SendUPDATEItem_rSpecialLevel(aTYPE: TSENDUPDATEITEMTYPE; akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_ITEM_UPDATE);
  WordComData_ADDbyte(ComData, byte(aTYPE)); //类型
  WordComData_ADDbyte(ComData, akey); //位置
  WordComData_ADDbyte(ComData, ITEM_UPDATE_rSpecialLevel); //分类型

  WordComData_ADDdword(ComData, ItemData.rSpecialLevel);
  SendData(ComData);
end;


procedure TSendClass.SendHaveItem(akey: word; var ItemData: TItemData); //重新发送 物品
var
  ComData: TWordComData;
  psHaveItem: PTSHaveItem;
begin
  psHaveItem := @ComData.Data;
  with psHaveItem^ do
  begin
    rmsg := SM_HAVEITEM_list;
    rkey := akey;
    if ItemData.rName <> '' then
    begin
      rdel := false;
      ComData.Size := SizeOf(TSHaveItem);
      TItemDataToTWordComData(ItemData, ComData);

    end else
    begin
      rdel := true;
      ComData.Size := 3;
    end;
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendProcessionExp(aExp: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Procession);
  WordComData_ADDbyte(ComData, Procession_AddExp);
  WordComData_ADDdword(ComData, aExp);
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendHaveItemQuest(akey: word; var ItemData: TItemData); //重新发送 物品
var
  ComData: TWordComData;
   // psHaveItem: PTSHaveItem;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_HAVEITEM_LIST_QUEST);
  WordComData_ADDbyte(ComData, akey);
  WordComData_ADDString(ComData, ItemData.rName);
  if ItemData.rName <> '' then
  begin
    WordComData_ADDString(ComData, ItemData.rViewName);
    WordComData_ADDdword(ComData, ItemData.rCount);
    WordComData_ADDdword(ComData, ItemData.rMaxCount);
    WordComData_ADDword(ComData, ItemData.rShape);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendWearItem(akey: word; atype: TWearItemtype; var ItemData: TItemData);
var
  ComData: TWordComData;
  psWearItem: pTsWearItem;
begin
  psWearItem := @ComData.Data;

  with psWearItem^ do
  begin
    rmsg := SM_WEARITEM;
    rkey := akey;
    if Itemdata.rName = '' then
    begin
      if atype = witWear then rtype := witWeardel;
      if atype = witWearFD then rtype := witWearFDdel;
      if atype = witWearUser then rtype := witWeardelUser;
      if atype = witWearFDUser then rtype := witWearFDdelUser;

      ComData.Size := 3;
    end else
    begin
      rtype := atype;

      ComData.Size := SizeOf(TSHaveItem);
      TItemDataToTWordComData(ItemData, ComData);
    end;
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));

    {  if aKey = 1 then
      begin
          with psWearItem^ do
          begin
              rmsg := SM_WEARITEM;
              rkey := 5;
              rName := Itemdata.rViewName;
              rColor := Itemdata.rcolor;
              rShape := Itemdata.rShape;
              rAdditional := Itemdata.rAdditional;
              rlockState := Itemdata.rlockState;
              ComData.Size := SizeOf(TSHaveItem);
          end;
          Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
      end;
    }
end;

procedure TSendClass.SendMagicAddExp(var MagicData: TMagicData);
var
  ComData: TWordComData;
  psHaveMagic: PTSHaveMagic;
begin
  psHaveMagic := @ComData.Data;
  with psHaveMagic^ do
  begin
    rmsg := SM_HAVEMAGIC;
    rType := smt_MagicAddExp;
    ComData.Size := SizeOf(TSHaveMagic);
    WordComData_ADDdword(ComData, MagicData.rID);
    WordComData_ADDdword(ComData, MagicData.rcSkillLevel);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendHaveMagic(atype: TsendMagicType; akey: word; var MagicData: TMagicData; EventStringType: byte = 0);
var
  ComData: TWordComData;
  psHaveMagic: PTSHaveMagic;
begin
  psHaveMagic := @ComData.Data;
  with psHaveMagic^ do
  begin
    rmsg := SM_HAVEMAGIC;
    rkey := akey;
    rType := atype;
    ComData.Size := SizeOf(TSHaveMagic);
    if MagicData.rname = '' then
    begin
      rdel := true;
    end else
    begin
      rdel := false;
      TMagicDataToTWordComData(MagicData, ComData);
    end;

  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

{procedure TSendClass.SendBasicMagic(akey:word; var MagicData:TMagicData; EventStringType:byte = 0);
var
    ComData         :TWordComData;
    psHaveMagic     :PTSHaveMagic;
begin
    psHaveMagic := @ComData.Data;
    with psHaveMagic^ do
    begin
        rmsg := SM_BASICMAGIC;
        rkey := akey;
        rShape := Magicdata.rShape;
        rName := MagicData.rname;

        rSkillLevel := Magicdata.rcSkillLevel;
        rEventStringType := EventStringType;
        rpercent := 0;
        ComData.Size := SizeOf(TSHaveMagic);
    end;
    Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;
}

procedure TSendClass.SendSoundEffect(asoundname: integer; ax, ay: Word);
var
  ComData: TWordComData;
  psSoundString: PTSSoundString;
begin
  psSoundString := @ComData.Data;
  with psSoundString^ do
  begin
    rmsg := SM_SOUNDEFFECT;

    rsound := asoundname;
    rX := ax;
    rY := ay;
    ComData.Size := SizeOf(TSSoundString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendSoundBase(asoundname: string; aRoopCount: integer);
var
  ComData: TWordComData;

  psSoundBaseString: PTSSoundBaseString;
begin
  psSoundBaseString := @ComData.Data;
  with psSoundBaseString^ do
  begin
    rmsg := SM_SOUNDBASESTRING;
    rRoopCount := aroopcount;
    SetWordString(rWordString, asoundname);
    ComData.Size := Sizeof(TSSoundBaseString) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendGameExit();
var
  ComData: TWordComData;
  tt: PTCKey;
begin
  tt := @ComData.Data;
  with tt^ do
  begin
    rmsg := SM_GameExit;
    ComData.Size := sizeof(TCKey);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendCloseClient();
var
  ComData: TWordComData;
  tt: PTCKey;
begin
  tt := @ComData.Data;
  with tt^ do
  begin
    rmsg := SM_CloseClient;
    ComData.Size := sizeof(TCKey);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendUpload(aType: Byte; aKey: WORD); //2015.12.23在水一方
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, SM_Upload);
  WordComData_ADDbyte(temp, aType);
  WordComData_ADDword(temp, aKey);

  SendData(temp);
end;

procedure TSendClass.WeaponLight(aInfo: TSMotion3);
var
  ComData: TWordComData;
  psLightInfo: pTSMotion3;
begin
  psLightInfo := @ComData.Data;
  psLightInfo^ := aInfo;
  with psLightInfo^ do
  begin
    rmsg := SM_MOTION3;
    ComData.Size := SizeOf(TSMotion3);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

//发送打开对话窗口信息

procedure TSendClass.SendShowSpecialWindow(aWindow: Byte; aCaption: string; aComment: string; akey1: INTEGER = 0; akey2: INTEGER = 0; akey3: INTEGER = 0; akey4: INTEGER = 0);
var
  ComData: TWordComData;
  pSShowSpecialWindow: PTSShowSpecialWindow;
begin
  psShowSpecialWindow := @ComData.Data;

  with psShowSpecialWindow^ do
  begin
    rmsg := SM_SHOWSPECIALWINDOW;
    rWindow := aWindow;
    rkey1 := akey1; //可传送头像
    rkey2 := akey2;
    rkey3 := akey3;
    rkey4 := akey4;
    rCaption := aCaption;
    SetWordString(rWordString, aComment);
    ComData.Size := sizeof(TSShowSpecialWindow) - sizeof(TWordString) + sizeofwordstring(rwordstring);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

//发送打开输入窗口信息

procedure TSendClass.SendConfirmDialogWindow(aWindow: Byte; oObject, did: Integer; aCaption: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, aWindow);
  WordComData_ADDdword(ComData, oObject);
  WordComData_ADDbyte(ComData, did);
  WordComData_ADDString(ComData, aCaption);
  SendData(ComData);
end;
//仓库  物品 发送

procedure TSendClass.SendLogItem(akey: word; var ItemData: TItemData);
var
  ComData: TWordComData;
  psLogItem: PTSLogItem;
begin
  psLogItem := @ComData.Data;
  with psLogItem^ do
  begin
    rmsg := SM_LOGITEM;
    rkey := aKey;

    if ItemData.rName <> '' then
    begin
      rbodel := false;

      ComData.Size := SizeOf(TSLogItem);
      TItemDataToTWordComData(ItemData, ComData);
    end else
    begin
      rbodel := true;
      ComData.Size := 3;
    end;

  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;
//新增加 NPC物品  发送  买卖都是这里发送

procedure TSendClass.SendNPCItem(akey: word; var ItemData: TItemData; acount: integer);
var
  ComData: TWordComData;
  psLogItem: PTSNPCItem;
begin
  psLogItem := @ComData.Data;
  with psLogItem^ do
  begin
    rmsg := SM_NPCITEM;
    rkey := aKey;
    rName := ItemData.rName;
    rViewName := ItemData.rViewName;
    rCount := acount;
    rColor := Itemdata.rcolor;
    rShape := Itemdata.rShape;
    rPrice := Itemdata.rPrice;
    if Itemdata.rTradeMoneyName = '' then
      rTradeMoneyName := INI_DEFAULTGOLD
    else
      rTradeMoneyName := Itemdata.rTradeMoneyName;
    ComData.Size := SizeOf(TSNPCItem);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendShowGuildMagicWindow(aMagicWindowData: PTSShowGuildMagicWindow);
var
  ComData: TWordComData;
begin
  ComData.Size := SizeOf(TSShowGuildMagicWindow);
  Move(aMagicWindowData^, ComData.Data, SizeOf(TSShowGuildMagicWindow));

  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendNetState(aID, aTick: Integer);
var
  ComData: TWordComData;
  pSNetState: PTSNetState;
begin
  ComData.Size := SizeOf(TSNetState);

  pSNetState := @ComData.Data;
  pSNetState^.rMsg := SM_NETSTATE;
  pSNetState^.rID := aID;
  pSNetState^.rMadeTick := aTick;

  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendMsgBoxTemp(aCaption, astr: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_MsgBoxTemp);
  WordComData_ADDStringPro(ComData, aCaption);
  WordComData_ADDStringPro(ComData, astr);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_windows_close;
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_edit_Windows_Close);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_windows_open;
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_edit_Windows_Open);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_user_windows_close;
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_user_Windows_Close);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_user_windows_open(aboothname: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_user_Windows_Open);
  WordComData_ADDString(ComData, aboothname);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_begin;
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_edit_Begin);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_end;
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_edit_End);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_item(atype: boothtype; akey: integer; var aboothitem: TBoothShopData);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_user_item);
  WordComData_ADDbyte(ComData, byte(atype));
  WordComData_ADDbyte(ComData, akey);

  WordComData_ADDdword(ComData, dword(aboothitem.rstate));
  WordComData_ADDdword(ComData, aboothitem.rHaveItemKey);
  WordComData_ADDdword(ComData, aboothitem.rPrice);
  WordComData_ADDdword(ComData, aboothitem.rCount);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_item_del(atype: boothtype; akey: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_edit_item_del);
  WordComData_ADDbyte(ComData, byte(atype));
  WordComData_ADDbyte(ComData, akey);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_item_upCount(atype: boothtype; akey, acount: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_edit_item_upcount);
  WordComData_ADDbyte(ComData, byte(atype));
  WordComData_ADDbyte(ComData, akey);
  WordComData_ADDdword(ComData, acount);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_user_item(atype: boothtype; akey: integer; aboothitem: TBoothShopData; aitem: titemdata);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_user_item);
  WordComData_ADDbyte(ComData, byte(atype));
  WordComData_ADDbyte(ComData, akey);
  if aboothitem.rstate = false then
  begin
    WordComData_ADDbyte(ComData, 1);
  end else
  begin
    WordComData_ADDbyte(ComData, 2);
    aitem.rPrice := aboothitem.rPrice;
    aitem.rCount := aboothitem.rCount;
    TItemDataToTWordComData(aitem, ComData);
  end;
  SendData(ComData);
end;

procedure TSendClass.SendBooth_user_item_del(atype: boothtype; akey: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_user_item_del);
  WordComData_ADDbyte(ComData, byte(atype));
  WordComData_ADDbyte(ComData, akey);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_user_item_upCount(atype: boothtype; akey, acount: integer);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_user_item_upcount);
  WordComData_ADDbyte(ComData, byte(atype));
  WordComData_ADDbyte(ComData, akey);
  WordComData_ADDdword(ComData, acount);
  SendData(ComData);
end;

procedure TSendClass.SendBooth_edit_Message(atext: string);
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Booth);
  WordComData_ADDbyte(ComData, Booth_edit_Message);
  WordComData_ADDString(ComData, atext);
  SendData(ComData);
end;


procedure TSendClass.SendBindMoney(amoney: integer);

var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Bindmoney);
  WordComData_ADDdword(ComData, amoney);

  SendData(comdata);
end;

procedure TSendClass.SendItemData(var ItemData: TItemData);
var
  ComData: TWordComData;
  psHaveItem: PTSHaveItem;
begin
  psHaveItem := @ComData.Data;
  with psHaveItem^ do
  begin
    rmsg := SM_ITEMDATA;

    if ItemData.rName <> '' then
    begin
      rdel := false;
      ComData.Size := SizeOf(TSHaveItem);
      TItemDataToTWordComData(ItemData, ComData);

    end else
    begin
      rdel := true;
      ComData.Size := 3;
    end;
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendOtherAttribBase(var AttribData: TAttribData;
  var CurAttribData: TCurAttribData; var aAQuestData: TAttribQuestData);
var /////发送人物数据
  ComData: TWordComData;
  psAttribBase: PTSAttribBase;
begin
  psAttribBase := @ComData.Data;
  with psAttribBase^ do
  begin
    rmsg := SM_OtherUserATTRIBBASE;
    rAge := AttribData.cAge + aAQuestData.Age; //年龄

    rEnergy := AttribData.cEnergy + aAQuestData.Energy; //元气
    rCurEnergy := CurAttribData.CurEnergy;

    rInPower := AttribData.cInPower + aAQuestData.InPower; //内功
    rCurInPower := CurAttribData.CurInPower;

    rOutPower := AttribData.cOutPower + aAQuestData.OutPower; //外功
    rCurOutPower := CurAttribData.CurOutPower;

    rMagic := AttribData.cMagic + aAQuestData.Magic; //武功
    rCurMagic := CurAttribData.CurMagic;

    rLife := AttribData.cLife + aAQuestData.Life; //活力 生命
    rCurLife := CurAttribData.CurLife;
    rlucky := AttribData.lucky; //幸运

    radaptive := AttribData.cadaptive + aAQuestData.adaptive; //耐性
    rRevival := AttribData.cRevival + aAQuestData.Revival; //再生

    rCTalent := AttribData.newTalent;
    rCTalentLv := AttribData.newTalentLv;
    rCTalentExp := AttribData.newTalentExp;
    rCTalentNextLvExp := AttribData.newTalentNextLvExp;
    rCnewBone := AttribData.newBone;
    rCnewLeg := AttribData.newLeg;
    rCnewSavvy := AttribData.newSavvy;
    rCnewAttackPower := AttribData.newAttackPower;
    ComData.Size := SizeOf(TSAttribBase);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TSendClass.SendOtherUserLifeData(aLifeData: TLifeData);
var
  ComData: TWordComData;
  pSLifeData: pTSLifeData;
begin
  pSLifeData := @ComData.Data;
  with pSLifeData^ do
  begin
    rmsg := SM_OtherUserLifeData;
        //damage 攻击
    damageBody := aLifeData.damageBody; //身体
    damageHead := aLifeData.damageHead; //头
    damageArm := aLifeData.damageArm; //武器
    damageLeg := aLifeData.damageLeg; //腿
        //armor 防御
    armorBody := aLifeData.armorBody;
    armorHead := aLifeData.armorHead;
    armorArm := aLifeData.armorArm;
    armorLeg := aLifeData.armorLeg;

    AttackSpeed := aLifeData.AttackSpeed; //攻击速度
    avoid := aLifeData.avoid; //躲避
    recovery := aLifeData.recovery; //恢复
    HitArmor := aLifeData.HitArmor;
    accuracy := aLifeData.accuracy;
    ComData.Size := SizeOf(TSLifeData);
  end;
  Connector.AddSendData(@ComData, ComData.Size + SizeOf(Word));
end;

end.

