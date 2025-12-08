unit uAuction;

interface
uses
  Windows, Sysutils, Classes, Deftype, uAnsTick, BasicObj, SvClass,
  SubUtil, uSkills, uLevelExp, uUser, aUtil32, uGramerid, //AnsUnit,
  FieldMsg, MapUnit, uKeyClass, uResponsion, DateUtils
  , uDBFile;

type
  TDBAuctionFile = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create;
    destructor Destroy; override;

    function Update(aIndexName: string; aAuctionData: pTAuctionData): Byte;
    function Delete(aIndexName: string): Byte;
    function Select(aIndexName: string; aAuctionData: pTAuctionData): Byte;
    function SelectAllName(): string;
    function Insert(aIndexName: string; aAuctionData: pTAuctionData): Byte;
    function count: integer;
  end;
    //数据中心
  TAuctionDataClass = class
  private

    FdataIdList: TIntegerKeyListClass; //所有数据     ID 索引方式存储
    procedure Clear();
  protected

  public
    constructor Create;
    destructor Destroy; override;
    function auditing(tmpitem: pTAuctionData; var outstr: string): boolean; //审核
    function add(tmpitem: pTAuctionData; var OutAdds: pointer; boSave: boolean): boolean;
    function get(aid: integer): pointer;
    function del(aid: integer): boolean;

    procedure getNext(var Code: TWordComData; aindex: integer); //下一页
    procedure getBack(var Code: TWordComData; aindex: integer); //上一页
    function GetCount: integer; //数量


  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         TAuctionBatUpdate
    ////////////////////////////////////////////////////////////////////////////
    {TAuctionBatUpdatetype = (abuDel, abuUPdate);
    TAuctionBatUpdate = class
    private
        Ftype: TAuctionBatUpdatetype;
        FDCurTick: integer;
        Fdata: Tlist;
        procedure Clear();
        procedure DBDel();
        procedure DBUPdate();

        function get(aid: integer): pointer;
    public
        constructor Create(atype: TAuctionBatUpdatetype);
        destructor Destroy; override;
        procedure add(atemp: pTAuctionData);
        procedure del(aid: integer);
        procedure Update(CurTick: integer);
    end;}
    //同卖家名字  列表
    //同物品名字 列表
    //同KIND类型 列表
  TIndexDataList = class
  private
    Fdata: Tlist; //

  public
    constructor Create;
    destructor Destroy; override;
    procedure add(temp: pointer);
    procedure del(aid: integer);
    procedure getList(var Code: TWordComData); //
    procedure getNext(var Code: TWordComData; aindex: integer); //下一页
    procedure getBack(var Code: TWordComData; aindex: integer); //上一页
    function get(aid: integer): pointer;
    function GetCount: integer; //数量
  end;

  TIndexclass = class
  private
    Fdata: TStringKeyListClass; //TIndexDataList

  public
    constructor Create;
    destructor Destroy; override;
    function get(aname: string): pointer;
    function getNameCount(aname: string): integer;
    procedure Add(aname: string; temp: pointer);
    procedure Del(aname: string; aid: integer);
    procedure Clear();
  published

  end;

    //系统
    {说明：出售东西在这里注册}

  TAuctionSystemClass = class
  private
    FDCurTick: integer;

    AuctionData: TAuctionDataClass; //数据存储
    FUserIndex: TIndexclass; //同卖家名字  列表TIndexDataList
    FItemIndex: TIndexclass; //同物品名字 列表      TIndexDataList
    CM_MessageTick: array[0..255] of integer;
    Fpoundage: integer;



    function add(tmpitem: pTAuctionData; boSave: boolean): boolean;
    function del(aid: integer): boolean;
    procedure systemItemDel(atemp: pTAuctionData);
  public
    DBAuctionFile: TDBAuctionFile;
    constructor Create;
    destructor Destroy; override;

    procedure MessageProcess(var Code: TWordComData; uUser: tuser);
    procedure openAucitonWindows(uUser: tuser;modx:Integer=0);
    procedure closeAuctionWindows(uUser: tuser);
        //卖家
    procedure UserItemGet(uUser: tuser); // 寄售 列表
    function UserItemAdd(uUser: tuser; aItemKey, aItemCount, aPrice, aMaxtime: integer; apricetype: TAuctionPriceType): boolean; //发布 寄售 物品
    procedure UserItemDel(uUser: tuser; aAuctionId: integer); //撤消 寄售
    procedure SendUserItemAdd(uUser: tuser; aitem: pTAuctionData);
        //买家
    procedure ItemSearch(uUser: tuser; aname: string); //搜索
    procedure ItemSearchNext(uUser: tuser; aname: string; aindex: integer); //搜索
    procedure ItemSearchBack(uUser: tuser; aname: string; aindex: integer); //搜索
    procedure ItemNext(uUser: tuser; aindex: integer); //顺序
    procedure ItemBack(uUser: tuser; aindex: integer); //顺序

    procedure SendItemAdd(uUser: tuser; aitem: pTAuctionData);
    procedure SendItemDel(uUser: tuser; aAuctionId: integer);

    procedure ItemGetText(uUser: tuser; aAuctionId: integer); //获取 物品 描述
    procedure ItemBuy(uUser: tuser; aAuctionId: integer); //购买

    procedure Update(CurTick: integer);




    procedure DBAuctionSave(aAuctionData: TAuctionData);
    procedure DBAuctionLoadFile();
    procedure DBAuctionDel(aid: Integer);
  published

  end;
var
  AuctionSystemClass: TAuctionSystemClass;


procedure AuctionDataToWordComData(var Code: TWordComData; aitem: pTAuctionData);
implementation
uses FGate, uUserSub, uEmail, SVMain;

procedure SendDbAuction(aData: PChar; aCount: Integer);
begin
  if frmGate.AddSendDBServerData(DB_Auction, (aData), aCount) = false then
  begin

  end;
  frmGate.dbsend; //马上发送
end;

procedure AuctionDataToWordComData(var Code: TWordComData; aitem: pTAuctionData);
var
  i, temptime: integer;
  aitemtemp: titemdata;
begin
  temptime := (aitem.rMaxTime * 3600) - SecondsBetween(now(), aitem.rTime);
  if temptime <= 0 then temptime := 1;

  WordComData_ADDdword(Code, aitem.rid);
    //  WordComData_ADDstring(Code, aitem.rItem.rName);
     // WordComData_ADDdword(Code, aitem.ritemimg);
    //  WordComData_ADDdword(Code, aitem.rItem.rColor);
  WordComData_ADDdword(Code, aitem.rPrice);
  WordComData_ADDdword(Code, temptime);
    //    WordComData_ADDdword(Code, aitem.rItem.rCount);
  WordComData_ADDstring(Code, aitem.rBargainorName);
  CopyDBItemToItem(aitem.rItem, aitemtemp);
  TItemDataToTWordComData(aitemtemp, Code);
  if aitem.rPricetype = aptGold then i := 0;
  if aitem.rPricetype = aptGOLD_Money then i := 1;
  WordComData_ADDbyte(Code, i);
end;

///////////////////////////////////////////////
//              TAuctionDataClass
///////////////////////////////////////////////

procedure TAuctionDataClass.Clear();
begin

end;

constructor TAuctionDataClass.Create;
begin
  inherited Create;

  FdataIdList := TIntegerKeyListClass.Create;
end;

destructor TAuctionDataClass.Destroy;
begin

  Clear;
  FdataIdList.Free;
  inherited destroy;
end;



function TAuctionDataClass.GetCount: integer; //数量
begin
  result := FdataIdList.Count;
end;

procedure TAuctionDataClass.getBack(var Code: TWordComData; aindex: integer); //上一页
var
  i: integer;
  pp: pTAuctionData;
  temp: TWordComData;
  rcount: integer;
begin
  if aindex < 0 then aindex := 0;
  rcount := 0;
  temp.Size := 0;
  i := aindex;
  while (i >= 0) and (i < FdataIdList.Count) do
  begin
    pp := FdataIdList.GetIndex(i);
    if pp = nil then Break;
    AuctionDataToWordComData(temp, pp);
    inc(rcount);
    i := i + 1;
    if rcount >= 5 then Break;
  end;
  WordComData_ADDdword(Code, rcount);
  WordComData_ADDdword(Code, i);
  copymemory(@Code.Data[Code.size], @temp.data, temp.Size);
  code.Size := code.Size + temp.Size;
end;

procedure TAuctionDataClass.getNext(var Code: TWordComData; aindex: integer); //下一页
var
  i: integer;
  pp: pTAuctionData;
  temp: TWordComData;
  rcount: integer;
begin
  if aindex >= FdataIdList.Count then aindex := FdataIdList.Count - 1;

  rcount := 0;
  temp.Size := 0;
  i := aindex;
  while (i >= 0) and (i < FdataIdList.Count) do
  begin
    pp := FdataIdList.GetIndex(i);
    if pp = nil then Break;
    AuctionDataToWordComData(temp, pp);
    inc(rcount);
    i := i - 1;
    if rcount >= 5 then Break;
  end;
  WordComData_ADDdword(Code, rcount);
  WordComData_ADDdword(Code, i);
  copymemory(@Code.Data[Code.size], @temp.data, temp.Size);
  code.Size := code.Size + temp.Size;
end;

function TAuctionDataClass.auditing(tmpitem: pTAuctionData; var outstr: string): boolean;
begin
  result := false;
  outstr := '';
  if tmpitem.rMaxTime <= 0 then
  begin
    outstr := '时间太少。';
    exit;
  end;
  if tmpitem.rMaxTime > 24*7 then   //7天
  begin
    outstr := '时间超出范围。';
    exit;
  end;
  result := true;
end;

function TAuctionDataClass.add(tmpitem: pTAuctionData; var OutAdds: pointer; boSave: boolean): boolean;
var
  pp: pTAuctionData;
begin
  result := false;
  if get(tmpitem.rid) <> nil then exit;
  new(pp);
  pp^ := tmpitem^;
  if FdataIdList.Insert(pp.rid, pp) = false then
  begin
    Dispose(pp);
    exit;
  end;
  if boSave then AuctionSystemClass.DBAuctionSave(pp^);
  OutAdds := pp;
  result := true;
end;

function TAuctionDataClass.del(aid: integer): boolean;
var
  pp: pTAuctionData;
begin
  result := false;
  pp := get(aid);
  if pp = nil then exit;
  AuctionSystemClass.DBAuctionDel(aid);
  FdataIdList.Delete(aid);
  Dispose(pp);
  result := true;
end;

function TAuctionDataClass.get(aid: integer): pointer;
begin
  result := FdataIdList.Select(aid);
end;
///////////////////////////////////////////////
//              TAuctionSystemClass
///////////////////////////////////////////////

function TAuctionSystemClass.del(aid: integer): boolean;
var
  pp: pTAuctionData;
  aitem: TAuctionData;
begin
  result := false;
  pp := AuctionData.get(aid);
  if pp = nil then exit;
  aitem := pp^;
    //先删除 其他分类 索引
  fUserIndex.Del(aitem.rBargainorName, aid);
  FItemIndex.del(aitem.rItem.rName, aid);
    //数据 删除
  result := AuctionData.del(aid);

end;
//寄售 唯一增加

function TAuctionSystemClass.add(tmpitem: pTAuctionData; boSave: boolean): boolean;
var
  OutAdds: pointer;
begin
  result := AuctionData.add(tmpitem, OutAdds, boSave);
  if result = false then exit;
  if outadds = nil then exit;

    //可增加 更多 索引 方式
  fUserIndex.Add(tmpitem.rBargainorName, outadds);
  FItemIndex.Add(tmpitem.rItem.rName, outadds);
end;

procedure TAuctionSystemClass.SendItemDel(uUser: tuser; aAuctionId: integer);
var
  i: integer;
  Code: TWordComData;
begin
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Item_ListDel);
  WordComData_ADDdword(Code, aAuctionId);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.SendItemAdd(uUser: tuser; aitem: pTAuctionData);
var
  i: integer;
  Code: TWordComData;
begin
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Item_ListAdd);
  AuctionDataToWordComData(Code, aitem);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.SendUserItemAdd(uUser: tuser; aitem: pTAuctionData);
var
  i: integer;
  Code: TWordComData;
begin

  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Bargainor_ListAdd);
  AuctionDataToWordComData(Code, aitem);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.ItemBack(uUser: tuser; aindex: integer); //顺序
var
  Code: TWordComData;
  str: string;
begin
  str := '';
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Item_GetList);
  WordComData_ADDstring(Code, str);
  AuctionData.getBack(Code, aindex);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.ItemNext(uUser: tuser; aindex: integer); //返回 10个 从最后到前面
var
  Code: TWordComData;
  str: string;
begin
  str := '';
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Item_GetList);
  WordComData_ADDstring(Code, str);
  AuctionData.getNext(Code, aindex);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.ItemSearchNext(uUser: tuser; aname: string; aindex: integer); //搜索
var
  pp: TIndexDataList;
  i: integer;
  Code: TWordComData;
begin

  pp := FItemIndex.get(aname);
  if pp = nil then
  begin
    uUser.SendClass.SendChatMessage(format('没有物品%s', [aname]), SAY_COLOR_SYSTEM);
    exit;
  end;
  if pp.GetCount <= 0 then
  begin
    uUser.SendClass.SendChatMessage(format('没有物品%s', [aname]), SAY_COLOR_SYSTEM);
    exit;
  end;
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Item_GetList);
  WordComData_ADDstring(Code, aname);
  pp.getNext(Code, aindex);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.ItemSearchBack(uUser: tuser; aname: string; aindex: integer); //搜索
var
  pp: TIndexDataList;
  i: integer;
  Code: TWordComData;
begin

  pp := FItemIndex.get(aname);
  if pp = nil then
  begin
    uUser.SendClass.SendChatMessage(format('没有物品%s', [aname]), SAY_COLOR_SYSTEM);
    exit;
  end;
  if pp.GetCount <= 0 then
  begin
    uUser.SendClass.SendChatMessage(format('没有物品%s', [aname]), SAY_COLOR_SYSTEM);
    exit;
  end;
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Item_GetList);
  WordComData_ADDstring(Code, aname);
  pp.getBack(Code, aindex);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.ItemSearch(uUser: tuser; aname: string);
var
  pp: TIndexDataList;
  i: integer;
  Code: TWordComData;
begin

  pp := FItemIndex.get(aname);
  if pp = nil then
  begin
    uUser.SendClass.SendChatMessage(format('没有物品%s', [aname]), SAY_COLOR_SYSTEM);
    exit;
  end;
  if pp.GetCount <= 0 then
  begin
    uUser.SendClass.SendChatMessage(format('没有物品%s', [aname]), SAY_COLOR_SYSTEM);
    exit;
  end;
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Item_GetList);
  WordComData_ADDstring(Code, aname);
  pp.getList(Code);
  uUser.SendClass.SendData(code);
end;

procedure TAuctionSystemClass.openAucitonWindows(uUser: tuser;modx:Integer=0);
var
  i: integer;
  adata: TWordComData;
begin
 if modx=0 then if uUser.MenuSTATE <> nsauction then exit;
  adata.Size := 0;
  WordComData_ADDbyte(adata, SM_Auction);
  WordComData_ADDbyte(adata, Auction_WindowsOpen);
  WordComData_ADDdword(adata, Fpoundage);
  uUser.SendClass.SendData(adata);

  UserItemGet(uUser); // 寄售 列表
  i := AuctionData.GetCount - 1;
  ItemNext(uuser, i);
end;

procedure TAuctionSystemClass.closeAuctionWindows(uUser: tuser);
var
  adata: TWordComData;
begin
  if uUser.MenuSTATE <> nsauction then exit;
  adata.Size := 0;
  WordComData_ADDbyte(adata, SM_Auction);
  WordComData_ADDbyte(adata, Auction_Windowsclose);
  uUser.SendClass.SendData(adata);
  uUser.CloseAuctionWindow;

end;

procedure TAuctionSystemClass.UserItemGet(uUser: tuser);
var
  pp: TIndexDataList;
  i: integer;
  Code: TWordComData;
begin
  pp := FUserIndex.get(uuser.name);
  if pp = nil then
  begin

    exit;
  end;
  if pp.GetCount <= 0 then
  begin

    exit;
  end;

  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Bargainor_GetNameList);
  pp.getList(Code);
  uUser.SendClass.SendData(code);
end;
{
procedure TAuctionSystemClass.DBMessageProcess(var adata: TWordComData);
var
    akey, amsg, i: integer;
    pp: TAuctionData;
begin
    i := 0;
    akey := WordComData_GETbyte(adata, i);
    case akey of
        Auction_SELECTLoad:
            begin
                FLoadState := true;
            end;
        Auction_INSERT:
            begin

            end;
        Auction_SELECT:
            begin
                copymemory(@pp, @adata.Data[i], sizeof(TAuctionData));
                add(@pp);
            end;
        Auction_DELETE:
            begin
                akey := WordComData_GETdword(adata, i);
                AuctionSQlDEl.del(akey);
            end;
        Auction_UPDATE:
            begin
                akey := WordComData_GETdword(adata, i);
                AuctionSQLUpdate.del(akey);
            end;
    end;

end;
}

procedure TAuctionSystemClass.MessageProcess(var Code: TWordComData; uUser: tuser);
var
  pckey: PTCkey;
  i, akey, eid: integer;
  str: string;
  aItemKey, aItemCount, aPrice, aMaxtime: integer;
begin
  if uUser.MenuSTATE <> nsauction then exit;
  pckey := @Code.Data;
  if pckey^.rmsg <> CM_Auction then exit;
  i := 1;
  akey := WordComData_GETbyte(Code, i);
    { if akey <> Auction_getItemText then
     begin
         if CM_MessageTick[akey] + 100 > mmAnsTick then
         begin
             //uUser.SendClass.SendChatMessage('不要频繁操作！' + inttostr(random(10000)), SAY_COLOR_SYSTEM);
             exit;
         end;
         CM_MessageTick[akey] := mmAnsTick;
     end; }
  case akey of
    Auction_WindowsClose:
      begin
        uUser.CloseAuctionWindow;

       // uuser.MenuSTATE:=nsemail;
      //  uUser.ShowEmailWindow(1);
      end;
    Auction_Bargainor_GetNameList: //自己列表
      begin
        UserItemGet(uuser);
      end;

    Auction_Item_GetList: //查询列表
      begin
        str := WordComData_GETstring(Code, i);
        akey := WordComData_GETbyte(Code, i);
        eid := WordComData_GETdword(Code, i);
        case akey of
          Auction_getList:
            begin
              if str = '' then
              begin
                eid := AuctionData.GetCount - 1;
                ItemNext(uuser, eid);
              end else
              begin
                eid := FItemIndex.getNameCount(str) - 1;
                ItemSearchNext(uuser, str, eid);
              end;
            end;
          Auction_getBack:
            begin
              if str = '' then
              begin
                ItemBack(uuser, eid);
              end else
              begin
                ItemSearchBack(uuser, str, eid);
              end;
            end;
          Auction_getNext:
            begin
              if str = '' then
              begin
                ItemNext(uuser, eid);
              end else
              begin
                ItemSearchNext(uuser, str, eid);
              end;
            end;
        end;

      end;

    Auction_Consignment: //发布寄售
      begin
        aItemKey := WordComData_getbyte(Code, i);
        aItemCount := WordComData_getword(Code, i);
        aPrice := WordComData_getdword(Code, i);
        aMaxtime := WordComData_getbyte(Code, i);
        akey := WordComData_getbyte(Code, i);
        if akey = 1 then
          UserItemAdd(uUser, aItemKey, aItemCount, aPrice, aMaxtime, aptGOLD_Money)
        else
          UserItemAdd(uUser, aItemKey, aItemCount, aPrice, aMaxtime, aptGold);

      end;
    Auction_ConsignmentCancel: //寄售 取消
      begin
        eid := WordComData_getdword(Code, i);
        UserItemDel(uUser, eid);
      end;
    Auction_buy: //购买
      begin
        eid := WordComData_getdword(Code, i);
        ItemBuy(uUser, eid);
      end;
    Auction_getItemText:
      begin
        eid := WordComData_getdword(Code, i);
        ItemGetText(uUser, eid);
      end;

  end;

end;

procedure TAuctionSystemClass.ItemGetText(uUser: tuser; aAuctionId: integer); //获取 物品 描述
var
  i: integer;
  Code: TWordComData;
  pp: pTAuctionData;
  temp: TItemData;
  str: string;
begin
    { pp := AuctionData.get(aAuctionId);
     if pp = nil then
     begin
         exit;
     end;
     CopyDBItemToItem(pp.rItem, temp);
     //    str := TItemDataToStr(temp);
     Code.Size := 0;
     WordComData_ADDbyte(Code, SM_Auction);
     WordComData_ADDbyte(Code, Auction_getItemText);
     WordComData_ADDdword(Code, aAuctionId);
     // WordComData_ADDstring(Code, str);
     TItemDataToTWordComData(temp, Code);
     uUser.SendClass.SendData(code);
     }
end;

procedure TAuctionSystemClass.ItemBuy(uUser: tuser; aAuctionId: integer); //购买
var
  i: integer;
  Code: TWordComData;
  pp: pTAuctionData;
  tempAuction: TAuctionData;
    //  GoldITEMKEY     :INTEGER;
  tempGold: TItemData;
  tempGoldcut: TCutItemData;
  str: string;
  tempMoney, emaiid1, emaiid2: integer;

begin
  pp := AuctionData.get(aAuctionId);
  if pp = nil then
  begin
    uUser.SendClass.SendChatMessage('购买失败1物品不存在。', SAY_COLOR_SYSTEM);
    exit;
  end;
  tempAuction := pp^; //保存临时
  if tempAuction.rPrice <= 0 then
  begin
    uUser.SendClass.SendChatMessage('购买失败2价格问题商品。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if uuser.aEmail = nil then
  begin
    uUser.SendClass.SendChatMessage('你邮箱问题。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if TEmailclass(uuser.aEmail).getcount >= 20 then
  begin
    uUser.SendClass.SendChatMessage('你邮箱已满。', SAY_COLOR_SYSTEM);
    exit;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                               【元宝】交易
    ////////////////////////////////////////////////////////////////////////////
  if tempAuction.rPricetype = aptGOLD_Money then
  begin
    uUser.affair(hicaStart);
        //扣元宝
    if uuser.DEL_GOLD_Money(tempAuction.rPrice) = false then
    begin
      uUser.SendClass.SendChatMessage('【元宝】不够。', SAY_COLOR_SYSTEM);
      exit;
    end;
        //发送 物品
    if EmailList.SystemSendNewEmail(
      uUser.name
      , '购买成功' //标题
      , '购买成功' //内容
      , '系统' //发送者
      , tempAuction.rItem //物品
      , 0
      , emaiid1) = false then
    begin
      uUser.SendClass.SendChatMessage('购买失败3邮寄失败。', SAY_COLOR_SYSTEM);
      uUser.affair(hicaRoll_back);
      exit;
    end;
        //扣税
    tempMoney := trunc(tempAuction.rPrice * (95 / 100));

    if tempMoney < 0 then tempMoney := 0;
    str := format('你的物品成功出售，售得【元宝】%d扣税后你应得元宝%d。', [tempAuction.rPrice, tempMoney]);
    str := tempAuction.rBargainorName + ':<br>' + str;

    tempGoldcut.rName := '';
        //发送钱
    if EmailList.SystemSendNewEmail(
      tempAuction.rBargainorName
      , '寄卖成功' //标题
      , str //内容
      , '系统' //发送者
      , tempGoldcut //物品
      , tempMoney
      , emaiid2) = false then
    begin
      EmailList.del(uUser.name, emaiid1);
      uUser.affair(hicaRoll_back);
      exit;
    end;
        //扣物品
    if del(aAuctionId) = false then
    begin
      uUser.SendClass.SendChatMessage('购买失败2', SAY_COLOR_SYSTEM);
      EmailList.del(uUser.name, emaiid1);
      EmailList.del(tempAuction.rBargainorName, emaiid2);
      uUser.affair(hicaRoll_back);
      exit;
    end;
  end else
  begin
        ////////////////////////////////////////////////////////////////////////////
        //                               钱币交易
        ////////////////////////////////////////////////////////////////////////////

        //手续费用
    if uuser.ViewItemName(INI_GOLD, @tempGold) = false then
    begin
      uUser.SendClass.SendChatMessage('你没有金钱。', SAY_COLOR_SYSTEM);
      exit;
    end;
    if tempGold.rCount < tempAuction.rPrice then
    begin
      uUser.SendClass.SendChatMessage('金钱不够。', SAY_COLOR_SYSTEM);
      exit;
    end;
    tempGold.rCount := tempAuction.rPrice;
        ///////////////////////////////////////////////////////////////////////////
        //                          扣
        ///////////////////////////////////////////////////////////////////////////
    uUser.affair(hicaStart);
        //扣钱
    if uUser.ItemAuctionDeleteItem(@tempGold) = false then
    begin
      uUser.SendClass.SendChatMessage('金钱不够。', SAY_COLOR_SYSTEM);
      exit;
    end;

        //发送 物品
    if EmailList.SystemSendNewEmail(
      uUser.name
      , '购买成功' //标题
      , '购买成功' //内容
      , '系统' //发送者
      , tempAuction.rItem //物品
      , 0
      , emaiid1) = false then
    begin
      uUser.SendClass.SendChatMessage('购买失败3邮寄失败。', SAY_COLOR_SYSTEM);
      uUser.affair(hicaRoll_back);
            //退还失败 不再处理
      exit;
    end;
    CopyItemToDBItem(tempGold, tempGoldcut);
        //扣税
    tempGoldcut.rCount := trunc(tempGoldcut.rCount * (90 / 100));
    if tempGoldcut.rCount < 0 then tempGoldcut.rCount := 0;

    str := format('你的物品成功出售，售得%d扣税后你应得%d。', [tempGold.rCount, tempGoldcut.rCount]);
    str := tempAuction.rBargainorName + ':<br>' + str;
    if tempGoldcut.rCount <= 0 then tempGoldcut.rName := '';
        //发送钱
    if EmailList.SystemSendNewEmail(
      tempAuction.rBargainorName
      , '寄卖成功' //标题
      , str //内容
      , '系统' //发送者
      , tempGoldcut //物品
      , 0
      , emaiid2) = false then
    begin
            //需要做记录 邮寄失败
      EmailList.del(uUser.name, emaiid1);
      uUser.affair(hicaRoll_back);
      exit;
    end;
        //扣寄售物品
    if del(aAuctionId) = false then
    begin
      uUser.SendClass.SendChatMessage('购买失败2', SAY_COLOR_SYSTEM);
      EmailList.del(uUser.name, emaiid1);
      EmailList.del(tempAuction.rBargainorName, emaiid2);
      uUser.affair(hicaRoll_back);
      exit;
    end;
  end;
  uUser.SendClass.SendChatMessage('购买成功', SAY_COLOR_SYSTEM);
  SendItemDel(uuser, aAuctionId);
end;

procedure TAuctionSystemClass.systemItemDel(atemp: pTAuctionData);
var
  emaiid1: integer;
begin

  if EmailList.SystemSendNewEmail(
    atemp.rBargainorName
    , '寄售超时' //标题
    , '寄售超时退还你物品' //内容
    , '系统' //发送者
    , atemp.rItem //物品
    , 0
    , emaiid1) = false then
  begin
    exit;
  end;
  if del(atemp.rid) = false then
  begin
    EmailList.del(atemp.rBargainorName, emaiid1);
    exit;
  end;

end;

procedure TAuctionSystemClass.UserItemDel(uUser: tuser; aAuctionId: integer);
var
  i: integer;
  Code: TWordComData;
  pp: pTAuctionData;
  temp: TAuctionData;
  emaiid1: integer;
begin
  pp := AuctionData.get(aAuctionId);
  if pp = nil then
  begin
    uUser.SendClass.SendChatMessage('撤消失败1', SAY_COLOR_SYSTEM);
    exit;
  end;
  temp := pp^;
  if temp.rBargainorName <> uuser.name then
  begin
    uUser.SendClass.SendChatMessage('撤消失败2安全不符合。', SAY_COLOR_SYSTEM);
    exit;
  end;

  if EmailList.SystemSendNewEmail(
    uUser.name
    , '撤消成功' //标题
    , '撤消成功' //内容
    , '系统' //发送者
    , temp.rItem //物品
    , 0
    , emaiid1) = false then
  begin
    uUser.SendClass.SendChatMessage('撤消失败4邮寄失败。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if del(aAuctionId) = false then
  begin
    uUser.SendClass.SendChatMessage('撤消失败3', SAY_COLOR_SYSTEM);
    EmailList.del(uuser.name, emaiid1);
    exit;
  end;
  uUser.SendClass.SendChatMessage('撤消成功。', SAY_COLOR_SYSTEM);
  Code.Size := 0;
  WordComData_ADDbyte(Code, SM_Auction);
  WordComData_ADDbyte(Code, Auction_Bargainor_ListDel);
  WordComData_ADDdword(Code, aAuctionId);
  uUser.SendClass.SendData(code);
end;

function TAuctionSystemClass.UserItemAdd(uUser: tuser; aItemKey, aItemCount, aPrice, aMaxtime: integer; apricetype: TAuctionPriceType): boolean;
var
  tmpitem: TAuctionData;
  aItemData: TItemData;
  str: string;
  outadds: TAuctionData;
  tempGold: TItemData;
begin
  Result := false;
    ////////////////////////////////////////////////////////////////////////////
    //                         检查
    ////////////////////////////////////////////////////////////////////////////
  if uUser.LockedPass then
  begin
    uUser.SendClass.SendChatMessage('背包有密码设定', SAY_COLOR_SYSTEM);
    exit;
  end;
  if uuser.aEmail = nil then
  begin
    uUser.SendClass.SendChatMessage('你邮箱问题。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if TEmailclass(uuser.aEmail).getcount >= 20 then
  begin
    uUser.SendClass.SendChatMessage('你邮箱已满。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if aprice <= 2 then
  begin
    uUser.SendClass.SendChatMessage('价格太少。', SAY_COLOR_SYSTEM);
    exit;
  end;
  uUser.SendClass.SendChatMessage('出售时间'+inttostr(amaxtime)+'小时', SAY_COLOR_SYSTEM);
  case amaxtime of
    24: ;
    24*3: ;
    24*7: ;
  else
    begin
      uUser.SendClass.SendChatMessage('出售时间出现问题。', SAY_COLOR_SYSTEM);
      exit;
    end;
  end;

  tmpitem.rid := NEWAuctionIDClass.GetNewID;
  tmpitem.rBargainorName := uuser.name;
  tmpitem.rPrice := aprice;
  tmpitem.rTime := now();
  tmpitem.rMaxTime := amaxtime;
  tmpitem.rPricetype := apricetype;

  if aItemCount <= 0 then
  begin
    uUser.SendClass.SendChatMessage('物品数量超出范围。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if uuser.ViewItem(aitemkey, @aItemData) = false then
  begin
    uUser.SendClass.SendChatMessage('没有物品。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if aItemData.rlockState <> 0 then
  begin
    uUser.SendClass.SendChatMessage('锁状态物品无法寄售。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if aItemData.rboNotExchange then
  begin
    uUser.SendClass.SendChatMessage('限制交易物品，禁止寄售。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if aItemData.rboNotTrade then
  begin
    uUser.SendClass.SendChatMessage('限制出售物品，禁止寄售。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if aItemData.rCount < aItemCount then
  begin
    uUser.SendClass.SendChatMessage('物品数量问题。', SAY_COLOR_SYSTEM);
    exit;
  end;

    //手续费用
  if uuser.ViewItemName(INI_GOLD, @tempGold) = false then
  begin
    uUser.SendClass.SendChatMessage('你没有金钱。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if tempGold.rCount < Fpoundage then
  begin
    uUser.SendClass.SendChatMessage('金钱不够。', SAY_COLOR_SYSTEM);
    exit;
  end;
  aItemData.rCount := aItemCount;
  CopyItemToDBItem(aItemData, tmpitem.rItem);
  tmpitem.ritemimg := aItemData.rShape;
    //审核
  if AuctionData.auditing(@tmpitem, str) = false then
  begin
    uUser.SendClass.SendChatMessage('审核问题。' + str, SAY_COLOR_SYSTEM);
    exit;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         发布
    ////////////////////////////////////////////////////////////////////////////
  uUser.affair(hicaStart);
    //扣钱
  tempGold.rCount := Fpoundage;
  if uUser.ItemAuctionDeleteItem(@tempGold) = false then
  begin
    uUser.SendClass.SendChatMessage('金钱不够。', SAY_COLOR_SYSTEM);
    exit;
  end;
    //扣物品
  if uUser.ItemAuctionDelKeyItem(aitemkey, aItemCount, @aItemData) = false then
  begin
    uUser.SendClass.SendChatMessage('物品问题2。', SAY_COLOR_SYSTEM);
    uUser.affair(hicaRoll_back);
    exit;
  end;

  CopyItemToDBItem(aItemData, tmpitem.rItem);
  tmpitem.ritemimg := aItemData.rShape;
  if add(@tmpitem, true) = false then
  begin
    uUser.SendClass.SendChatMessage('发布失败。', SAY_COLOR_SYSTEM);
    uUser.affair(hicaRoll_back);
    exit;
  end;
  SendUserItemAdd(uuser, @tmpitem);
  uUser.SendClass.SendChatMessage(format('物品%s发布成功。', [tmpitem.rItem.rName]), SAY_COLOR_SYSTEM);
  uUser.ScriptAuction(aItemData);
  Result := true;
end;




procedure TAuctionSystemClass.Update(CurTick: integer);
var
  i, temptime, rcount: integer;
  pp: pTAuctionData;
begin

  if GetItemLineTimeSec(CurTick - FDCurTick) < 10 then exit; //1分钟 执行 一次
  FDCurTick := CurTick;

  i := 0;
  rcount := 0;

  while i <= (AuctionData.FdataIdList.Count - 1) do
  begin
    pp := AuctionData.FdataIdList.GetIndex(i);
 
    temptime := (pp.rMaxTime * 3600) - SecondsBetween(now(), pp.rTime);
    if temptime <= 0 then
    begin
      systemItemDel(pp);
      inc(rcount);
    end else inc(i);
    if rcount >= 20 then exit;
  end;

end;

constructor TAuctionSystemClass.Create;
begin
  DBAuctionFile := TDBAuctionFile.Create;
  FDCurTick := 0;

  Fpoundage := 10000;  //寄售需要1万
  AuctionData := TAuctionDataClass.Create;
  FUserIndex := TIndexclass.Create; //同卖家名字  列表TIndexDataList
  FItemIndex := TIndexclass.Create; //同物品名字 列表      TIndexDataList

  DBAuctionLoadFile;
end;

destructor TAuctionSystemClass.Destroy;
begin
  AuctionData.Free;
  FUserIndex.Free; //同卖家名字  列表TIndexDataList
  FItemIndex.Free; //同物品名字 列表      TIndexDataList
  DBAuctionFile.Free;
  inherited destroy;
end;
///////////////////////////////////////////////
//              TbargainorIndex
///////////////////////////////////////////////

procedure TIndexDataList.del(aid: integer);
var
  i: integer;
  pp: pTAuctionData;
begin
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[i];
    if pp.rid = aid then
    begin
      Fdata.Delete(i);
      exit;
    end;
  end;

end;

procedure TIndexDataList.getBack(var Code: TWordComData; aindex: integer); //上一页
var
  i: integer;
  pp: pTAuctionData;
  temp: TWordComData;
  rcount: integer;
begin

  if aindex < 0 then aindex := 0;
  rcount := 0;
  temp.Size := 0;
  i := aindex;
  while (i >= 0) and (i < Fdata.Count) do
  begin
    pp := Fdata.Items[i];
    if pp = nil then Break;
    AuctionDataToWordComData(temp, pp);
    inc(rcount);
    i := i + 1;
    if rcount >= 5 then Break;
  end;
  WordComData_ADDdword(Code, rcount);
  WordComData_ADDdword(Code, i);
  copymemory(@Code.Data[Code.size], @temp.data, temp.Size);
  code.Size := code.Size + temp.Size;
end;

procedure TIndexDataList.getNext(var Code: TWordComData; aindex: integer); //下一页
var
  i: integer;
  pp: pTAuctionData;
  temp: TWordComData;
  rcount: integer;
begin
  if aindex >= Fdata.Count then aindex := Fdata.Count - 1;

  rcount := 0;
  temp.Size := 0;
  i := aindex;
  while (i >= 0) and (i < Fdata.Count) do
  begin
    pp := Fdata.Items[i];
    if pp = nil then Break;
    AuctionDataToWordComData(temp, pp);
    inc(rcount);
    i := i - 1;
    if rcount >= 5 then Break;
  end;
  WordComData_ADDdword(Code, rcount);
  WordComData_ADDdword(Code, i);
  copymemory(@Code.Data[Code.size], @temp.data, temp.Size);
  code.Size := code.Size + temp.Size;
end;

procedure TIndexDataList.getList(var Code: TWordComData);
var
  i, temptime: integer;
  pp: pTAuctionData;
  str: string;
begin
  WordComData_ADDdword(Code, Fdata.Count);
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[i];
    temptime := (pp.rMaxTime * 3600) - SecondsBetween(now(), pp.rTime);
    if temptime <= 0 then temptime := 0;
    AuctionDataToWordComData(Code, pp);
  end;

end;

function TIndexDataList.GetCount: integer;
begin
  result := Fdata.Count;
end;

function TIndexDataList.get(aid: integer): pointer;
var
  i: integer;
  pp: pTAuctionData;
begin
  result := nil;
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[i];
    if pp.rid = aid then
    begin
      result := pp;
      exit;
    end;
  end;

end;

procedure TIndexDataList.add(temp: pointer);
begin
  Fdata.Add(temp);
end;

constructor TIndexDataList.Create;
begin
  Fdata := TLIST.Create;
end;

destructor TIndexDataList.Destroy;
begin
  Fdata.Free;
  inherited destroy;
end;
//////////////////////

procedure TIndexclass.Clear();
var
  i: integer;
  pp: TIndexDataList;
begin
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.GetIndex(i);
    pp.Free;
  end;
  Fdata.Clear;
end;

function TIndexclass.getNameCount(aname: string): integer;
var
  pp: TIndexDataList;
begin
  result := 0;
  pp := Fdata.Select(aname);
  if pp = nil then exit;
  result := pp.GetCount;
end;

function TIndexclass.get(aname: string): pointer;
begin
  result := Fdata.Select(aname);
end;

procedure TIndexclass.Add(aname: string; temp: pointer);
var
  pp: TIndexDataList;
begin
  pp := Fdata.Select(aname);
  if pp = nil then
  begin
    pp := TIndexDataList.Create;
    Fdata.Insert(aname, pp);
  end;
  pp.add(temp);
end;

procedure TIndexclass.Del(aname: string; aid: integer);
var
  pp: TIndexDataList;
begin
  pp := Fdata.Select(aname);
  if pp = nil then exit;
  pp.del(aid);
end;

constructor TIndexclass.Create;
begin
  Fdata := TStringKeyListClass.Create;
end;

destructor TIndexclass.Destroy;
begin
  Clear;
  Fdata.Free;
  inherited destroy;
end;
/////////////////////////////////////////////////////////////////////////////////////
{
procedure TAuctionBatUpdate.Clear();
var
    i: integer;
    pp: pTAuctionData;
begin
    for i := 0 to Fdata.Count - 1 do
    begin

        pp := Fdata.Items[I];
        dispose(pp);
    end;
    Fdata.Clear;
end;

function TAuctionBatUpdate.get(aid: integer): pointer;
var
    i: integer;
    pp: pTAuctionData;
begin
    result := nil;
    for i := 0 to Fdata.Count - 1 do
    begin
        pp := Fdata.Items[I];
        if pp.rid = aid then
        begin
            result := pp;
            exit;
        end;
    end;
end;

procedure TAuctionBatUpdate.del(aid: integer);
var
    i: integer;
    pp: pTAuctionData;
begin
    for i := 0 to Fdata.Count - 1 do
    begin
        pp := Fdata.Items[I];
        if pp.rid = aid then
        begin
            Fdata.Delete(i);
            dispose(pp);
            exit;
        end;
    end;
end;

procedure TAuctionBatUpdate.DBDel();
var
    i, rcount: integer;
    pp: pTAuctionData;
    Code: TWordComData;
begin
    rcount := 0;
    for i := 0 to Fdata.Count - 1 do
    begin
        pp := Fdata.Items[I];
        if pp <> nil then
        begin
            //
            Code.Size := 0;
            WordComData_ADDbyte(Code, Auction_DELETE);
            WordComData_ADDdword(Code, pp.rid);
            SendDbAuction(@Code, Code.Size + 2);
        end;
        inc(rcount);
        if rcount >= 10 then Break;
    end;
end;

procedure TAuctionBatUpdate.DBUPdate();
var
    i, rcount: integer;
    pp: pTAuctionData;
    Code: TWordComData;
begin
    rcount := 0;
    for i := 0 to Fdata.Count - 1 do
    begin
        pp := Fdata.Items[I];
        if pp <> nil then
        begin
            //
            Code.Size := 0;
            WordComData_ADDbyte(Code, Auction_UPDATE);
            copymemory(@Code.Data[Code.Size], pp, sizeof(TAuctionData));
            Code.Size := Code.Size + sizeof(TAuctionData);
            SendDbAuction(@Code, Code.Size + 2);
        end;
        inc(rcount);
        if rcount >= 10 then Break;
    end;
end;

procedure TAuctionBatUpdate.Update(CurTick: integer);
begin
    if GetItemLineTimeSec(CurTick - FDCurTick) < 5 then exit;                   //5秒
    FDCurTick := CurTick;
    case Ftype of
        abuDel: DBDel;
        abuUPdate: DBUPdate;
    end;
end;

procedure TAuctionBatUpdate.add(atemp: pTAuctionData);
var
    pp: pTAuctionData;
begin
    if get(atemp.rid) <> nil then
    begin
        del(atemp.rid);
    end;
    new(pp);
    pp^ := atemp^;
    Fdata.Add(pp);
end;

constructor TAuctionBatUpdate.Create(atype: TAuctionBatUpdatetype);
begin
    Ftype := atype;
    Fdata := Tlist.Create;
    FDCurTick := 0;
end;

destructor TAuctionBatUpdate.Destroy;
begin
    Clear;
    Fdata.Free;
    inherited destroy;
end;
}
////////////////////////////////


{ TAuctionDBAdapter }

function TDBAuctionFile.count: integer;
begin
  result := dbfile.count;
end;

constructor TDBAuctionFile.Create;
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_06_01_Auction';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TAuctionData);
  dbfile := TDbFileClass.Create(aHead, '.\savedb\Auction.DB');
end;

function TDBAuctionFile.Delete(aIndexName: string): Byte;
begin
  result := dbfile.DELETE(aIndexName);
end;

destructor TDBAuctionFile.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TDBAuctionFile.Insert(aIndexName: string; aAuctionData: pTAuctionData): Byte;
begin
  result := dbfile.Insert(aIndexName, aAuctionData, sizeof(TAuctionData));
end;

function TDBAuctionFile.Select(aIndexName: string; aAuctionData: pTAuctionData): Byte;
begin
  result := dbfile.Select(aIndexName, aAuctionData, sizeof(TAuctionData));
end;

function TDBAuctionFile.SelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;

function TDBAuctionFile.Update(aIndexName: string; aAuctionData: pTAuctionData): Byte;
begin
  result := dbfile.Update(aIndexName, aAuctionData, sizeof(TAuctionData));
end;


procedure TAuctionSystemClass.DBAuctionDel(aid: Integer);
var
  fresult: integer;
begin
  fresult := DBAuctionFile.Delete(inttostr(aid));
  if fresult <> db_ok then frmMain.WriteLogInfo(format('procedure TAuctionSystemClass.DBAuctionDel Error (%s)', [GetDBErrorText(fresult)]));
end;

procedure TAuctionSystemClass.DBAuctionLoadFile;
var
  aAuctionData: TAuctionData;
  fresult: integer;
  sid: string;
  i: integer;
  tempList: tstringlist;
begin
  tempList := tstringlist.Create;
  try
    tempList.Text := DBAuctionFile.SelectAllName;
    for i := 0 to tempList.Count - 1 do
    begin
      sid := tempList.Strings[i];
      fresult := DBAuctionFile.Select(sid, @aAuctionData);
      if fresult = db_ok then
      begin
        add(@aAuctionData, false);
      end else
      begin
        frmMain.WriteLogInfo(format('procedure TAuctionSystemClass.DBAuctionLoadFile; (%s)', [GetDBErrorText(fresult)]));
      end;
    end;
  finally
    tempList.Free;
  end;
end;

procedure TAuctionSystemClass.DBAuctionSave(aAuctionData: TAuctionData);
var
  fresult: integer;
begin
  fresult := DBAuctionFile.Insert(inttostr(aAuctionData.rid), @aAuctionData);
  if fresult <> db_ok then frmMain.WriteLogInfo(format('procedure TAuctionSystemClass.DBAuctionSave Error (%s)', [GetDBErrorText(fresult)]));
end;

initialization
  begin
    AuctionSystemClass := TAuctionSystemClass.Create;

  end;

finalization
  begin
    AuctionSystemClass.Free;
  end;
end.

