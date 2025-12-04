unit uMopSub;
{$DEFINE  Free}
interface

uses
  Classes, SysUtils, BasicObj, svClass, uAnsTick, AUtil32, DefType, UUser, Dialogs;

const
    //MOP_DROPITEM_MAX = 10;
    //MOP_HAVEITEM_MAX = 10;
   // MOP_WANTITEM_MAX = 5;

  MOP_HAVEMAGIC_MAX = 11;

type
  TMopHaveItemClass = class
  private
    BasicObject: TBasicObject;

//        DropItemArr:array[0..10 - 1] of TCheckItem;
    DropItemclass: TCheckItemclass;
    HaveItemArr: array[0..10 - 1] of TAtomItem;
    WantItemArr: array[0..5 - 1] of string;
  public
    boLog: BOOLEAN;
    constructor Create(aBasicObject: TBasicObject);
    destructor Destroy; override;

    procedure Clear;

    procedure HaveItemClear;
    procedure WantItemClear;


    function HaveItemCount: Integer;
    function WantItemCount: Integer;


    function HaveItemFreeCount: Integer;
    function WantItemFreeCount: Integer;

    procedure DropSetCheckItemclass(CheckItemclass: TCheckItemclass);
    procedure DropItemClear;

    function FindHaveItem(aName: string): Integer;
    function AddHaveItem(aName: string; aCount, aColor: Integer): Boolean;
    function DelHaveItem(aName: string; aColor, aCount: Integer): Boolean;

    function FindWantItem(aName: string): Integer;
    function AddWantItem(aName: string): Boolean;
    function DelWantItem(aName: string): Boolean;

    procedure DropItemGround(attackerId, attackerMasterId, aKind: integer); //爆东西出

    function GetCsvStr: string;
  end;

  TMopHaveMagicClass = class
  private
    BasicObject: TBasicObject;

    UsedTickArr: array[0..MAGICSPECIAL_LAST - 1] of Integer;
    HaveMagicPos: array[0..MAGICSPECIAL_LAST - 1] of Byte;
    HaveMagicArr: array[0..MOP_HAVEMAGIC_MAX - 1] of TMagicParamData;
    HaveMagicData: array[0..MOP_HAVEMAGIC_MAX - 1] of TMagicData;
  public
    constructor Create(aBasicObject: TBasicObject);
    destructor Destroy; override;

    procedure Clear;
    procedure Init(aMagicStr: string);
    procedure InitExt(aMagicStr: string; aPara: TMagicParamData; aid: integer);

    function isHaveHideMagic: Boolean;
    function isHaveSameMagic: Boolean;
    function isHaveHealMagic: Boolean;
    function isHaveSwapMagic: Boolean;
    function isHaveEatMagic: Boolean;
    function isHaveKillMagic: Boolean;
    function isHavePickMagic: Boolean;

    function isHaveAbsorbMagic(): Boolean;
    function isHaveCALLMagic(): Boolean;
    function isHaveMAGICFUNCMagic(): Boolean;
    function isHaveSHOWSKILLMagic(): Boolean;


    function RunHaveSameMagic(aPercent: Integer; var aSubData: TSubData): Boolean;
    function RunHaveHealMagic(aName: string; aPercent: Integer; var aSubData: TSubData): Boolean;
    function RunHaveSwapMagic(aPercent: Integer; var aname: string; var boRegen: boolean): Boolean;
    function RunHaveEatMagic(aPercent: Integer; aHaveItemClass: TMopHaveItemClass; var aSubData: TSubData): Boolean;
    function RunHavePickMagic(aPercent: Integer; aName: string): Boolean;
    function RunHaveHideMagic(aPercent: Integer): Boolean;


    function RunHaveAbsorbMagic(aPercent: Integer): Boolean;
    function RunHaveCALLMagic(aPercent: Integer): Boolean;
    function RunHaveMAGICFUNCMagic(out aHitFunction, aHitFunctionSkill: integer): boolean;
    function RunHaveSHOWSKILLMagic(aPercent: Integer): Boolean;
    function getHaveSwapMagicMopName: string;
    {
    MAGICSPECIAL_7absorb = 7;                                                   //吸血
    MAGICSPECIAL_8CALL = 8;                                                     //召唤
    MAGICSPECIAL_9MAGICFUNC = 9;                                                //必杀
    MAGICSPECIAL_10SHOWSKILL = 10;                                              //透视
    }
  end;

implementation

uses
  uMonster, SVMain, SubUtil;

// TMopHaveItemClass

constructor TMopHaveItemClass.Create(aBasicObject: TBasicObject);
begin
  DropItemclass := nil;
  BasicObject := aBasicObject;
  boLog := FALSE;
  Clear;
end;

destructor TMopHaveItemClass.Destroy;
begin
  Clear;

  inherited Destroy;
end;

procedure TMopHaveItemClass.Clear;
begin
  DropItemClear;
  HaveItemClear;
  WantItemClear;
end;

procedure TMopHaveItemClass.DropSetCheckItemclass(CheckItemclass: TCheckItemclass);
begin
  DropItemclass := CheckItemclass;
end;

procedure TMopHaveItemClass.DropItemClear;
begin
  DropItemclass := nil;
end;

procedure TMopHaveItemClass.HaveItemClear;
var
  i: Integer;
begin
  for i := 0 to high(HaveItemArr) do
  begin
    FillChar(HaveItemArr[i], SizeOf(TAtomItem), 0);
  end;
end;

procedure TMopHaveItemClass.WantItemClear;
var
  i: Integer;
begin
  for i := 0 to high(WantItemArr) do
  begin
    WantItemArr[i] := '';
  end;
end;


function TMopHaveItemClass.HaveItemCount: Integer;
var
  i, iCount: Integer;
begin
  iCount := 0;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rItemName <> '' then
    begin
      Inc(iCount);
    end;
  end;

  Result := iCount;
end;

function TMopHaveItemClass.WantItemCount: Integer;
var
  i, iCount: Integer;
begin
  iCount := 0;
  for i := 0 to high(WantItemArr) do
  begin
    if WantItemArr[i] <> '' then
    begin
      Inc(iCount);
    end;
  end;

  Result := iCount;
end;



function TMopHaveItemClass.HaveItemFreeCount: Integer;
begin
  Result := (high(HaveItemArr) + 1) - HaveItemCount;
end;

function TMopHaveItemClass.WantItemFreeCount: Integer;
begin
  Result := (high(WantItemArr) + 1) - WantItemCount;
end;








function TMopHaveItemClass.FindHaveItem(aName: string): Integer;
var
  i, iCount: Integer;
begin
  iCount := 0;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rItemName = aName then
    begin
      Inc(iCount);
    end;
  end;

  Result := iCount;
end;

function TMopHaveItemClass.AddHaveItem(aName: string; aCount, aColor: Integer): Boolean;
var
  i: Integer;
begin
  Result := false;

  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rItemName = '' then
    begin
      HaveItemArr[i].rItemName := aName;
      HaveItemArr[i].rItemCount := aCount;
      HaveItemArr[i].rColor := aColor;
      Result := true;
      exit;
    end;
  end;
end;

function TMopHaveItemClass.DelHaveItem(aName: string; aColor, aCount: Integer): Boolean;
var
  i, iCount: Integer;
begin
  Result := false;

  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rItemName = aName then
    begin
      if HaveItemArr[i].rItemCount > 0 then
      begin
        if (aColor < 0) or (HaveItemArr[i].rColor = aColor) then
        begin
          HaveItemArr[i].rItemCount := HaveItemArr[i].rItemCount - aCount;
          if HaveItemArr[i].rItemCount <= 0 then
          begin
            HaveItemArr[i].rItemName := '';
            HaveItemArr[i].rItemCount := 0;
            HaveItemArr[i].rColor := 0;
          end;
          Result := true;
          exit;
        end;
      end;
    end;
  end;
end;

function TMopHaveItemClass.FindWantItem(aName: string): Integer;
var
  i, iCount: Integer;
begin
  iCount := 0;
  for i := 0 to high(WantItemArr) do
  begin
    if WantItemArr[i] = aName then
    begin
      Inc(iCount);
    end;
  end;

  Result := iCount;
end;

function TMopHaveItemClass.AddWantItem(aName: string): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to high(WantItemArr) do
  begin
    if WantItemArr[i] = '' then
    begin
      WantItemArr[i] := aName;
      Result := true;
      exit;
    end;
  end;
end;

function TMopHaveItemClass.DelWantItem(aName: string): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to high(WantItemArr) do
  begin
    if WantItemArr[i] = aName then
    begin
      WantItemArr[i] := '';
      Result := true;
      exit;
    end;
  end;
end;

function TMopHaveItemClass.GetCsvStr: string;
var
  i, j: Integer;
  p: pTCheckItem;
  ItemData: TItemData;
begin
  Result := '';
  j := 0;
  if DropItemclass = nil then exit;
  for i := 0 to DropItemclass.Count - 1 do
  begin
    p := DropItemclass.getIndex(i);
    if p = nil then Continue;
    if p.rName = '' then Continue;

    if ItemClass.GetItemData(p.rName, ItemData) then
    begin
      if ItemData.rKind <> ITEM_KIND_QUEST then
      begin
        inc(j);
        Result := Result + ItemData.rViewName + '、';
        if (j mod 3) = 0 then Result := Result + '<br>';
      end;
    end;
  end;
end;

//怪物死后 掉东西

procedure TMopHaveItemClass.DropItemGround(attackerId, attackerMasterId, aKind: integer);
var
  i, j, xx, yy, wif: Integer;
  MopName, MopViewName, itemlist, CheatName: string;
  attacker: TEnmitydata;
  ItemData, TempItem: TItemData;
  SubData: TSubData;
  CheckItem: TCheckItem;
  p: pTCheckItem;
  uUser: tuser;
begin
  if attackerMasterId <> 0 then attackerId := attackerMasterId;
  MopName := (BasicObject.BasicData.Name);
  BasicObject.BasicData.nx := BasicObject.BasicData.x;
  BasicObject.BasicData.ny := BasicObject.BasicData.y;
  attacker := BasicObject.EnmityList.getMaxEnmityAttacker();
    //BasicObject.BocSay(BasicObject.EnmityList.getListString);
  itemlist := '';
  wif := 0;
  if DropItemclass <> nil then
    for i := 0 to DropItemclass.Count - 1 do
    begin
     // if MopName = '石棺青龙刺客' then ShowMessage(inttostr(DropItemclass.Count));
      p := DropItemclass.getIndex(i);
      if p = nil then Continue;
      if p.rName <> '' then
      begin
        //玩家击杀
        CheatName := '';
        //检测爆出作弊设置
        if isUserId(attackerId) then
        begin
          uUser := UserList.GetUserPointer(attacker.rname);
          if (uUser <> nil) and (uUser.getCheatings > 0) then
            CheatName := attacker.rname;
        end;
        if ItemClass.GetCheckItemData(MopName, p^, ItemData, CheatName) = false then continue;

//                ItemData.rOwnerName := '';
        NewItemSet(_nist_all, ItemData); //打编号

        if aKind <> MONTER_KIND_9 then
          ItemData.rTempOwner := attacker;

       // OnDropItem

        if isUserId(attackerId) then
        begin
          MopViewName := (BasicObject.BasicData.ViewName);
          uUser := UserList.GetUserPointer(attacker.rname);
          if uUser <> nil then
            uUser.ScriptOnDropItem(MopViewName, ItemData.rName, ItemData.rViewName, ItemData.rCount);
        end;
//        if isUserId(attackerId) then
//        begin
//          TempItem := tuser(BasicObject.GetViewObjectById(attackerId)).ScriptOnDropItem(MopName, ItemData);
//          if TempItem.rName = ItemData.rName then
//          begin
//            ItemData := TempItem;
//             //ShowMessage(TempItem.rname);
//          end
//        end;

        SubData.ItemData := ItemData;
        SubData.ServerId := BasicObject.Manager.ServerId;


        if (ItemData.rKind = ITEM_KIND_QUEST) or (ItemData.rAttribute = ITEM_Attribute_6HaveItem) then
        begin
          if isUserId(attackerId) = false then Continue;

          BasicObject.Phone.SendMessage(attackerId, FM_ADDITEM, BasicObject.BasicData, SubData);
        end else
        begin
          if ItemData.rboExplosion then
          begin
            SubData.ItemData.rCount := 1;
            for j := 0 to ItemData.rCount - 1 do
            begin
              if BasicObject.Maper.GetItemXy(BasicObject.BasicData.x, BasicObject.BasicData.y, xx, yy, wif, 900) then
              begin
                BasicObject.BasicData.nx := xx;
                BasicObject.BasicData.ny := yy;
              end;
              BasicObject.Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
            end;
          end else
          begin
            if BasicObject.Maper.GetItemXy(BasicObject.BasicData.x, BasicObject.BasicData.y, xx, yy, wif, 900) then
            begin
              BasicObject.BasicData.nx := xx;
              BasicObject.BasicData.ny := yy;
            end;
            BasicObject.Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
          end;

        end;

        if boLog then itemlist := itemlist + '(' + ItemData.rName + ':' + inttostr(ItemData.rCount) + ')';
              //  SetWordString(SubData.SayString,ItemData.rName);
              //  BasicObject.SendLocalMessage(MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
//{$IFDEF Free}
//        if ItemData.rGrade > 1 then
//{$ELSE}
//        if (ItemData.rKind = 6) or (ItemData.rKind = 121) then
//{$ENDIF}
//          if attacker.rname <> '' then TopMSG('玩家【' + attacker.rname + '】杀死 ' + BasicObject.BasicData.ViewName + ' 爆出物品 ' + ItemData.rName, $FFFFFFFF);
      end;
    end;
    //SDB文件里设置的道具爆出
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rItemName <> '' then
    begin
      if Random(2) = 1 then
      begin
        CheckItem.rName := HaveItemArr[i].rItemName;
        if ItemClass.GetCheckItemData(MopName, CheckItem, ItemData) = false then continue;
        NewItemSet(_nist_all, ItemData); //打编号
        ItemData.rTempOwner := attacker;
        ItemData.rCount := HaveItemArr[i].rItemCount;
        ItemData.rColor := HaveItemArr[i].rColor;
//                ItemData.rOwnerName := '';
        SubData.ItemData := ItemData;
        SubData.ServerId := BasicObject.Manager.ServerId;

        if (ItemData.rKind = ITEM_KIND_QUEST) or (ItemData.rAttribute = ITEM_Attribute_6HaveItem) then
        begin
          if isUserId(attackerId) = false then Continue;
          BasicObject.Phone.SendMessage(attackerId, FM_ADDITEM, BasicObject.BasicData, SubData);
        end else
        begin
          if ItemData.rboExplosion then
          begin
            SubData.ItemData.rCount := 1;
            for j := 0 to ItemData.rCount - 1 do
            begin
              if BasicObject.Maper.GetItemXy(BasicObject.BasicData.x, BasicObject.BasicData.y, xx, yy, wif, 900) then
              begin
                BasicObject.BasicData.nx := xx;
                BasicObject.BasicData.ny := yy;
              end;
              BasicObject.Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
            end;
          end else
          begin
            if BasicObject.Maper.GetItemXy(BasicObject.BasicData.x, BasicObject.BasicData.y, xx, yy, wif, 900) then
            begin
              BasicObject.BasicData.nx := xx;
              BasicObject.BasicData.ny := yy;
            end;
            BasicObject.Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
          end;
        end;
        if boLog then
          itemlist := itemlist + '(' + ItemData.rName + ':' + inttostr(ItemData.rCount) + ')';
//{$IFDEF Free}
//        if ItemData.rGrade > 1 then
//{$ELSE}
//        if (ItemData.rKind = 6) or (ItemData.rKind = 121) then
//{$ENDIF}
//          if attacker.rname <> '' then topmsg('玩家【' + attacker.rname + '】杀死 ' + BasicObject.BasicData.ViewName + ' 爆出物品 ' + ItemData.rName, $FFFFFFFF);
      end;
    end;
  end;
  if boLog then
  begin
    //怪物死亡记录
    logMonsterdie(attacker.rname, BasicObject.BasicData.Name, itemlist, BasicObject.Manager.ServerID, BasicObject.BasicData.x, BasicObject.BasicData.y);
      //  FrmMain.Logdrop('玩家【'+attacker.rname+'】杀死 '+BasicObject.BasicData.ViewName+' 爆出物品 '+itemlist);
  end;
  HaveItemClear;
end;

// TMopHaveMagicClass

constructor TMopHaveMagicClass.Create(aBasicObject: TBasicObject);
begin
  BasicObject := aBasicObject;

  FillChar(UsedTickArr, SizeOf(UsedTickArr), 0);
  FillChar(HaveMagicPos, SizeOf(HaveMagicPos), 0);
  FillChar(HaveMagicArr, SizeOf(HaveMagicArr), 0);
  FillChar(HaveMagicData, SizeOf(HaveMagicData), 0);
end;

destructor TMopHaveMagicClass.Destroy;
begin
  inherited Destroy;
end;

procedure TMopHaveMagicClass.Clear;
begin
  fillchar(UsedTickArr, sizeof(UsedTickArr), 0);
end;

procedure TMopHaveMagicClass.Init(aMagicStr: string);
var
  i: Integer;
  iName: string;
  Str, rdStr: string;
begin
  iName := (BasicObject.BasicData.Name);

  FillChar(UsedTickArr, SizeOf(UsedTickArr), 0);
  FillChar(HaveMagicPos, SizeOf(HaveMagicPos), 0);
  FillChar(HaveMagicArr, SizeOf(HaveMagicArr), 0);
  FillChar(HaveMagicData, SizeOf(HaveMagicData), 0);

  Str := aMagicStr;
  for i := 0 to high(HaveMagicData) do
  begin
    Str := GetValidStr3(Str, rdStr, ':');
    if rdStr = '' then break;
    if MagicParamClass.GetMagicParamData(iName, rdStr, HaveMagicArr[i]) = true then
    begin

      MagicClass.GetMagicData(HaveMagicArr[i].MagicName, HaveMagicData[i], 9999);
      if HaveMagicData[i].rMagicType = MAGICTYPE_SPECIAL then
      begin

        if HaveMagicData[i].rFunction > high(HaveMagicPos) then
        begin
          frmMain.WriteLogInfo(format('TMopHaveMagicClass.Init HaveMagicData[i].rFunction>MAX %s %s(%d)', [iName, rdStr, HaveMagicData[i].rFunction]));
          Continue;
        end;
        HaveMagicPos[HaveMagicData[i].rFunction] := i + 1;
      end;
    end;
  end;
end;

procedure TMopHaveMagicClass.InitExt(aMagicStr: string; aPara: TMagicParamData; aid: integer);
var
  i: Integer;
  iName: string;
  Str, rdStr, rmStr: string;
begin
  iName := (BasicObject.BasicData.Name);

  FillChar(UsedTickArr, SizeOf(UsedTickArr), 0);
  FillChar(HaveMagicPos, SizeOf(HaveMagicPos), 0);
  FillChar(HaveMagicArr, SizeOf(HaveMagicArr), 0);
  FillChar(HaveMagicData, SizeOf(HaveMagicData), 0);

  Str := aMagicStr;
  for i := 0 to high(HaveMagicData) do
  begin
    Str := GetValidStr3(Str, rdStr, ':');
    if rdStr = '' then break;
    rmStr := rdStr;
    rdStr := rdStr + '_' + IntToStr(aid);
    if MagicParamClass.GetMagicParamData(iName, rdStr, HaveMagicArr[i]) = false then
    begin
      MagicParamClass.Add(iName, rmStr, aPara, aid);
    end;
    if MagicParamClass.GetMagicParamData(iName, rdStr, HaveMagicArr[i]) = true then
    begin

      MagicClass.GetMagicData(HaveMagicArr[i].MagicName, HaveMagicData[i], 9999);
      if HaveMagicData[i].rMagicType = MAGICTYPE_SPECIAL then
      begin

        if HaveMagicData[i].rFunction > high(HaveMagicPos) then
        begin
          frmMain.WriteLogInfo(format('TMopHaveMagicClass.Init HaveMagicData[i].rFunction>MAX %s %s(%d)', [iName, rdStr, HaveMagicData[i].rFunction]));
          Continue;
        end;
        HaveMagicPos[HaveMagicData[i].rFunction] := i + 1;
      end;
    end;
  end;
end;

function TMopHaveMagicClass.isHaveHideMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_HIDE] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveSameMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_SAME] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveHealMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_HEAL] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveSwapMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_SWAP] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveEatMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_EAT] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveKillMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_KILL] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHavePickMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_PICK] > 0 then Result := true;
end;

function TMopHaveMagicClass.RunHaveSameMagic(aPercent: Integer; var aSubData: TSubData): Boolean;
var
  ArrPos: Integer;
begin
  Result := false;

  ArrPos := HaveMagicPos[MAGICSPECIAL_SAME] - 1;
  if ArrPos < 0 then exit;
  if UsedTickArr[MAGICSPECIAL_SAME] <> 0 then exit;

  if aPercent <= HaveMagicArr[ArrPos].NumberParam[0] then
  begin
    UsedTickArr[MAGICSPECIAL_SAME] := mmAnsTick;
    aSubData.HitData.ToHit := HaveMagicArr[ArrPos].NumberParam[1];
    Result := true;
  end;
end;

function TMopHaveMagicClass.RunHaveHealMagic(aName: string; aPercent: Integer; var aSubData: TSubData): Boolean;
var
  i, ArrPos: Integer;
  boFlag: Boolean;
begin
  Result := false;
    //再生术
  ArrPos := HaveMagicPos[MAGICSPECIAL_HEAL] - 1;
  if ArrPos < 0 then exit;
  if mmAnsTick < UsedTickArr[MAGICSPECIAL_HEAL] + HaveMagicArr[ArrPos].NumberParam[2] then exit;

  boFlag := false;
  for i := 0 to 5 - 1 do
  begin
    if aName = HaveMagicArr[ArrPos].NameParam[i] then
    begin
      boFlag := true;
      break;
    end;
  end;
  if boFlag = false then exit;

  if aPercent <= HaveMagicArr[ArrPos].NumberParam[0] then
  begin
    UsedTickArr[MAGICSPECIAL_HEAL] := mmAnsTick;
    aSubData.HitData.ToHit := HaveMagicArr[ArrPos].NumberParam[1];
    Result := true;
  end;
end;

function TMopHaveMagicClass.getHaveSwapMagicMopName: string;
var
  ArrPos: Integer;
begin
  Result := '';
  ArrPos := HaveMagicPos[MAGICSPECIAL_SWAP] - 1;
  if ArrPos < 0 then exit;
  Result := HaveMagicArr[ArrPos].NameParam[0];

end;

function TMopHaveMagicClass.RunHaveSwapMagic(aPercent: Integer; var aname: string; var boRegen: boolean): Boolean;
var
  ArrPos: Integer;
begin
  Result := false;


  ArrPos := HaveMagicPos[MAGICSPECIAL_SWAP] - 1;
  if ArrPos < 0 then exit;

  if aPercent <= HaveMagicArr[ArrPos].NumberParam[0] then
  begin
    UsedTickArr[MAGICSPECIAL_SWAP] := mmAnsTick;
    aname := HaveMagicArr[ArrPos].NameParam[0];
    boRegen := HaveMagicArr[ArrPos].NumberParam[1] = 0;


    Result := true;
  end;
end;

function TMopHaveMagicClass.RunHaveEatMagic(aPercent: Integer; aHaveItemClass: TMopHaveItemClass; var aSubData: TSubData): Boolean;
var
  i: Integer;
  ArrPos: Integer;
begin
  Result := false;

  ArrPos := HaveMagicPos[MAGICSPECIAL_EAT] - 1;
  if ArrPos < 0 then exit;

  if mmAnsTick < UsedTickArr[MAGICSPECIAL_EAT] + HaveMagicArr[ArrPos].NumberParam[2] then exit;

  if aPercent > HaveMagicArr[ArrPos].NumberParam[0] then exit;
  if aHaveItemClass.FindHaveItem(HaveMagicArr[ArrPos].NameParam[0]) > 0 then
  begin
    aHaveItemClass.DelHaveItem(HaveMagicArr[ArrPos].NameParam[0], -1, 1);
    aSubData.ItemData.rName := HaveMagicArr[ArrPos].NameParam[0];
    aSubData.HitData.ToHit := HaveMagicArr[ArrPos].NumberParam[1];
    UsedTickArr[MAGICSPECIAL_EAT] := mmAnsTick;
    Result := true;
    exit;
  end;
end;

function TMopHaveMagicClass.RunHavePickMagic(aPercent: Integer; aName: string): Boolean;
var
  i: Integer;
  ArrPos: Integer;
  boFlag: Boolean;
begin
  Result := false;

  ArrPos := HaveMagicPos[MAGICSPECIAL_PICK] - 1;
  if ArrPos < 0 then exit;

  if aPercent > HaveMagicArr[ArrPos].NumberParam[0] then exit;

  boFlag := false;
  if HaveMagicArr[ArrPos].NameParam[0] <> '' then
  begin
    for i := 0 to 5 - 1 do
    begin
      if aName = HaveMagicArr[ArrPos].NameParam[i] then
      begin
        boFlag := true;
        break;
      end;
    end;
  end else
  begin
    boFlag := true;
  end;

  if boflag = true then
  begin
    UsedTickArr[MAGICSPECIAL_PICK] := mmAnsTick;
    Result := true;
  end;
end;

function TMopHaveMagicClass.RunHaveHideMagic(aPercent: Integer): Boolean;
var
  i: Integer;
  ArrPos: Integer;
  boFlag: Boolean;
begin
  Result := false;

  ArrPos := HaveMagicPos[MAGICSPECIAL_HIDE] - 1;
  if ArrPos < 0 then exit;

  if HaveMagicArr[ArrPos].NumberParam[2] > 0 then
  begin
    if mmAnsTick < UsedTickArr[MAGICSPECIAL_HIDE] + HaveMagicArr[ArrPos].NumberParam[1] then exit;
  end;

  if aPercent < HaveMagicArr[ArrPos].NumberParam[0] then exit;
  if aPercent > HaveMagicArr[ArrPos].NumberParam[1] then exit;

  UsedTickArr[MAGICSPECIAL_HIDE] := mmAnsTick;

  Result := true;
end;

function TMopHaveMagicClass.isHaveAbsorbMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_7absorb] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveCALLMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_8CALL] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveMAGICFUNCMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_9MAGICFUNC] > 0 then Result := true;
end;

function TMopHaveMagicClass.isHaveSHOWSKILLMagic: Boolean;
begin
  Result := false;
  if HaveMagicPos[MAGICSPECIAL_10SHOWSKILL] > 0 then Result := true;
end;

function TMopHaveMagicClass.RunHaveAbsorbMagic(aPercent: Integer): Boolean;
begin

end;

function TMopHaveMagicClass.RunHaveCALLMagic(aPercent: Integer): Boolean;
var
  i, j: integer;
  str, rstr, aname: string;
  acount, aw: integer;
  ArrPos: Integer;
begin
  Result := false;

  ArrPos := HaveMagicPos[MAGICSPECIAL_8CALL] - 1;
  if (ArrPos < 0) or (ArrPos > HIGH(HaveMagicArr)) then exit;
  if UsedTickArr[MAGICSPECIAL_8CALL] <> 0 then exit;
  UsedTickArr[MAGICSPECIAL_8CALL] := mmAnsTick;

  aw := HaveMagicArr[ArrPos].NumberParam[0];
  for i := 0 to high(HaveMagicArr[ArrPos].NameParam) do
  begin
    str := HaveMagicArr[ArrPos].NameParam[i];
    Str := GetValidStr3(Str, rstr, ':');
    if rstr = '' then exit;
    aname := rstr;
    Str := GetValidStr3(Str, rstr, ':');
    if rstr = '' then exit;
    acount := _StrToInt(rstr);
    for j := 0 to acount - 1 do
    begin
      TMonsterList(BasicObject.Manager.MonsterList).AddMonster(
        aname, BasicObject.BasicData.x, BasicObject.BasicData.y,
        aw, '',
        BasicObject.BasicData.Feature.rnation, 0, true);
    end;
  end;
  Result := true
end;

function TMopHaveMagicClass.RunHaveMAGICFUNCMagic(out aHitFunction, aHitFunctionSkill: integer): boolean;
var
  ArrPos: Integer;
begin
  Result := false;

  ArrPos := HaveMagicPos[MAGICSPECIAL_9MAGICFUNC] - 1;
  if (ArrPos < 0) or (ArrPos > HIGH(HaveMagicArr)) then exit;

  aHitFunction := HaveMagicArr[ArrPos].NumberParam[0];
  aHitFunctionSkill := HaveMagicArr[ArrPos].NumberParam[1];
  Result := true;

end;

function TMopHaveMagicClass.RunHaveSHOWSKILLMagic(aPercent: Integer): Boolean;
begin

end;

end.

