unit uEmail;

interface
uses
  Windows, Sysutils, Classes, Deftype, uAnsTick, BasicObj, SvClass,
  SubUtil, uSkills, uLevelExp, uUser, aUtil32, uGramerid, //AnsUnit,
  FieldMsg, MapUnit, uKeyClass, uResponsion, DateUtils, uEmaildata
  , uDBFile;
type
  TDBEmailFileClass = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create;
    destructor Destroy; override;

    function Update(aIndexName: string; aEmaildata: pTEmaildata): Byte;
    function Delete(aIndexName: string): Byte;
    function Select(aIndexName: string; aEmaildata: pTEmaildata): Byte;
    function SelectAllName(): string;
    function Insert(aIndexName: string; aEmaildata: pTEmaildata): Byte;
    function count: integer;
  end;
  TDBEmailNameListFileClass = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create;
    destructor Destroy; override;

    function Update(aIndexName: string; aEmailNamedata: pTEmailNamedata): Byte;
    function Delete(aIndexName: string): Byte;
    function Select(aIndexName: string; aEmailNamedata: pTEmailNamedata): Byte;
    function SelectAllName(): string;
    function Insert(aIndexName: string; aEmailNamedata: pTEmailNamedata): Byte;
    function count: integer;
  end;

  TEmailclass = class //每个人物1个
  private
    FUSER: tuser;
    Fname: string;
    Fdata: Tlist; //TEmaildata
    Fpoundage: integer;
    procedure Clear();
  public
    constructor Create;
    destructor Destroy; override;


    function add(aDestName: string; aID: integer; aTitle, aText, asourceName: string; aTime: tdatetime; abuf: TCutItemData; aGOLD_Money: integer; boSQLSave: boolean = true): boolean;
    function del(eid: integer): boolean;

    function getcount(): integer;
    procedure Emailread(aid: integer; uUser: tuser); //读邮件
    procedure Emailget(aid: integer; uUser: tuser); //
    procedure Emaildel(aid: integer; uUser: tuser); //
    procedure EmailNew(var Code: TWordComData; uUser: tuser); //
    procedure EmailgetList(uUser: tuser); //邮件列表
    procedure EmailWindowsOpen(uUser: tuser;modx:integer=0);
    procedure EmailWindowsClose(uUser: tuser);

    function get(aid: integer): pointer;

    procedure MessageProcess(var Code: TWordComData; uUser: tuser);

    procedure SETONLINE(atemp: tuser);
    procedure setGameExit();

  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         TEmaildataBatUpdate
    //说明：提供准确删除，准确更新数据。
    //      例如：邮件删除后拷贝一份进入本类，准确删除后，从本类删除
    ////////////////////////////////////////////////////////////////////////////
    {TEmaildataBatUpdatetype = (ebuDel, ebuUPdate, ebuREGName);
    TEmaildataBatUpdate = class
    private
        Ftype: TEmaildataBatUpdatetype;
        FDCurTick: integer;
        Fdata: Tlist;
        procedure Clear();
        procedure DBDel();
        procedure DBUPdate();
        procedure DBRegNameINSERT();

        function get(aid: integer): pointer;
    public
        constructor Create(atype: TEmaildataBatUpdatetype);
        destructor Destroy; override;
        procedure add(atemp: TEmaildataclass);
        procedure del(aid: integer);
        procedure Update(CurTick: integer);
    end;

     }
  TEmailList = class
  private
    DataNameKey: TStringKeyListClass; //TEmailclass


    procedure Clear();
    procedure add(aDestName: string; aID: integer; aTitle, aText, asourceName: string; aTime: tdatetime; abuf: TCutItemData; aGOLD_Money: INTEGER);

        //文件 名字列表
    procedure DBEmailNameListSave(aname: string);
    procedure DBEmailNameListLoadFile();

        //文件 邮件
    procedure DBEmailDEL(aid: integer);
    procedure DBEmailSave(cp: TEmaildataclass);
    procedure DBEmailLoadFile;
        //增加邮件


  public
    DBFileClass: TDBEmailFileClass;
    EmailNameListDBFileClass: TDBEmailNameListFileClass;
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer);

    function getname(aname: string): pointer;
    function createEmailclass(aname: string; boSQLSAVE: boolean = false): pointer;

    procedure GetEmailListName(uUser: tuser);
    procedure del(aDestName: string; aID: integer);
    function SystemSendNewEmail(aDestName: string; aTitle, aText, asourceName: string; abuf: TCutItemData; aGOLD_Money: INTEGER; var outemaiid: integer): boolean;

  end;
var
  EmailList: TEmailList;

implementation

uses FGate, uUserSub, SVMain;


function TEmailclass.get(aid: integer): pointer;
var
  i: integer;
  pp: TEmaildataclass;
begin
  result := nil;
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[I];
    if pp <> nil then
    begin
      if pp.FID = aid then
      begin
        result := pp;
        exit;
      end;
    end;
  end;

end;

procedure TEmailclass.SETONLINE(atemp: tuser);
begin
  FUSER := atemp;
  if getcount > 0 then
    FUSER.NewEmailState := true
  else
    FUSER.NewEmailState := false;
end;

procedure TEmailclass.setGameExit();
begin
  FUSER := nil;
end;

procedure TEmailclass.MessageProcess(var Code: TWordComData; uUser: tuser);
var
  pckey: PTCkey;
  i, akey, eid: integer;

begin
  if uUser.MenuSTATE <> nsemail then exit;
  pckey := @Code.Data;
  if pckey^.rmsg <> CM_EMAIL then exit;
  i := 1;
  akey := WordComData_GETbyte(Code, i);
  case akey of
    EMAIL_WindowsClose:
      begin
        uUser.CloseEmailWindow;
      end;
    EMAIL_NEW:  //新邮件到达
      begin
        EmailNew(code, uUser);
     //   uuser.MenuSTATE:=nsemail;
      //  uUser.ShowEmailWindow(1);
      end;
    EMAIL_read: //阅读
      begin
        eid := WordComData_GETdword(Code, i);
        Emailread(eid, uUser);
      end;
    EMAIL_list: //列表
      begin
        EmailgetList(uUser);
      end;
    EMAIL_del: //删除
      begin
        eid := WordComData_GETdword(Code, i);
        Emaildel(eid, uUser);
      end;
    EMAIL_get: //收取
      begin
        eid := WordComData_GETdword(Code, i);
        Emailget(eid, uUser);
      end;
  end;
end;

procedure TEmailclass.EmailWindowsOpen(uUser: tuser;modx:integer=0);
var
  i: integer;
  adata: TWordComData;
begin
   if modx=0 then   if uUser.MenuSTATE <> nsemail then exit;
  adata.Size := 0;
  WordComData_ADDbyte(adata, SM_EMAIL);
  WordComData_ADDbyte(adata, EMAIL_WindowsOpen);
  uUser.SendClass.SendData(adata);

  EmailgetList(uUser);
end;

procedure TEmailclass.EmailWindowsClose(uUser: tuser);
var
  i: integer;
  adata: TWordComData;
begin
  uUser.CloseEmailWindow;
  adata.Size := 0;
  WordComData_ADDbyte(adata, SM_EMAIL);
  WordComData_ADDbyte(adata, EMAIL_WindowsClose);
  uUser.SendClass.SendData(adata);
end;

procedure TEmailclass.EmailgetList(uUser: tuser);
var
  i: integer;
  adata: TWordComData;
  pp: TEmaildataclass;
begin
  adata.Size := 0;
  WordComData_ADDbyte(adata, SM_EMAIL);
  WordComData_ADDbyte(adata, EMAIL_list);
  WordComData_ADDbyte(adata, Fdata.Count);

  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[I];
    if pp <> nil then
    begin
      WordComData_ADDdword(adata, pp.FID);
      WordComData_ADDstring(adata, pp.FTitle);
      WordComData_ADDstring(adata, pp.FsourceName);
    end;
  end;
  uUser.SendClass.SendData(adata);
end;

function SbctoDbc(s: string): string;
var
  nlength, i: integer;
  str, ctmp, c1, c2: string;
    {
   在windows中，中文和全角字符都占两个字节，
   并且使用了ascii　chart  2  (codes  128 - 255 )。
  全角字符的第一个字节总是被置为163，
   而第二个字节则是相同半角字符码加上128（不包括空格）。
   如半角a为65，则全角a则是163（第一个字节）、 193 （第二个字节， 128 + 65 ）。
   而对于中文来讲，它的第一个字节被置为大于163，（
   如 ' 阿 ' 为: 176   162 ）,我们可以在检测到中文时不进行转换。
  }
begin
  nlength := length(s);
  if (nlength = 0) then
    exit;
  str := '';
  setlength(ctmp, nlength + 1);
  ctmp := s;
  i := 1;
  while (i <= nlength) do
  begin
    c1 := ctmp[i];
    c2 := ctmp[i + 1];
    if (c1 = #163) then // 如果是全角字符
    begin
      str := str + chr(ord(c2[1]) - 128);
      inc(i, 2);
      continue;
    end;
    if (c1 > #163) then // 如果是汉字
    begin
      str := str + c1;
      str := str + c2;
      inc(i, 2);
      continue;
    end;
    if (c1 = #161) and (c2 = #161) then // 如果是全角空格
    begin
      str := str + '   ';
      inc(i, 2);
      continue;
    end;
    str := str + c1;
    inc(i);
  end;
  result := str;
end;

procedure TEmailclass.EmailNew(var Code: TWordComData; uUser: tuser); //
var
  i, aItemKey, aItemCount: integer;

  tempTItemData: TItemData;

  aDestName: string;
  aID: integer;
  aTitle, aText, asourceName: string;
  aTime: tdatetime;
  abuf: TCutItemData;
  tempTEmailclass: TEmailclass;
  aGOLD_Money: integer;
  tempGold: TItemData;
begin
  i := 2;
  aTime := now();
  asourceName := uuser.name;
  aDestName := WordComData_getstring(Code, i);
  aTitle := WordComData_getstring(Code, i);
  aText := WordComData_getstring(Code, i);
  aItemKey := WordComData_getdword(Code, i);
  aItemCount := WordComData_getdword(Code, i);
  aGOLD_Money := WordComData_getdword(Code, i);

  if (aDestName = '') or (length(aDestName) > 20) then
  begin
    uUser.SendClass.SendChatMessage('邮件名字问题。', SAY_COLOR_SYSTEM);
    exit;
  end;

  if (aTitle = '') or (length(aTitle) > 20) then
  begin
    uUser.SendClass.SendChatMessage('邮件标题长度问题。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if IsGameStr(aTitle) = false then
  begin
    uUser.SendClass.SendChatMessage('邮件标题非法字符。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if (aText = '') or (length(aText) > 100) then
  begin
    uUser.SendClass.SendChatMessage('邮件内容长度问题。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if IsGameStr(aText) = false then
  begin
    uUser.SendClass.SendChatMessage('邮件内容非法字符。', SAY_COLOR_SYSTEM);
    exit;
  end;
  tempTEmailclass := EmailList.getname(aDestName);
  if tempTEmailclass = nil then
  begin
    uUser.SendClass.SendChatMessage(format('玩家%s不存在。', [aDestName]), SAY_COLOR_SYSTEM);
    exit;
  end;
  if tempTEmailclass.getcount >= 20 then
  begin
    uUser.SendClass.SendChatMessage(format('玩家%s邮箱已经满。', [aDestName]), SAY_COLOR_SYSTEM);
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

    ////////////////////////////////////////////////////////////////////////////
    //                         【元宝】处理 GM才能发
    ////////////////////////////////////////////////////////////////////////////

  if aGOLD_Money < 0 then aGOLD_Money := 0;
  if (aGOLD_Money > 0) then
  begin
    if uUser.isGm = false then
    begin
      uUser.SendClass.SendChatMessage('不能发送【元宝】！', SAY_COLOR_SYSTEM);
      exit;
    end;
        //测试 【元宝】 够不
    if uUser.GET_GOLD_Money < aGOLD_Money then
    begin
      uUser.SendClass.SendChatMessage('【元宝】不够！', SAY_COLOR_SYSTEM);
      exit;
    end;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         无附件邮件
    ////////////////////////////////////////////////////////////////////////////
  if (aItemKey < 0) or (aItemCount <= 0) then
  begin
    uuser.affair(hicaStart);
        //扣交易费用
    tempGold.rCount := Fpoundage;
    if uUser.ItemEmailDeleteItem(@tempGold) = false then
    begin
      uUser.SendClass.SendChatMessage('金钱不够。', SAY_COLOR_SYSTEM);
      exit;
    end;
    aID := NEWEmailIDClass.GetNewID;
    abuf.rID := 0;
    abuf.rName := '';
    if tempTEmailclass.add(aDestName, aID, aTitle, aText, asourceName, aTime, abuf, aGOLD_Money) = false then
    begin
      uUser.SendClass.SendChatMessage('邮件发送失败！', SAY_COLOR_SYSTEM);
      uuser.affair(hicaRoll_back);
      exit;
    end;
        //扣【元宝】
    if aGOLD_Money > 0 then
    begin
      if uUser.DEL_GOLD_Money(aGOLD_Money) = false then
      begin
        uUser.SendClass.SendChatMessage('邮件发送失败！', SAY_COLOR_SYSTEM);
        tempTEmailclass.del(aID);
        uuser.affair(hicaRoll_back);
        exit;
      end;
    end;
    uUser.SendClass.SendChatMessage('邮件发送成功。', SAY_COLOR_SYSTEM);
    exit;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         有附件邮件
    ////////////////////////////////////////////////////////////////////////////
  if uUser.LockedPass then
  begin
    uUser.SendClass.SendChatMessage('背包有密码设定', SAY_COLOR_SYSTEM);
    exit;
  end;
  if aItemCount <= 0 then
  begin
    uUser.SendClass.SendChatMessage('物品数量超出范围。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if uUser.ViewItem(aItemKey, @tempTItemData) = false then
  begin
    uUser.SendClass.SendChatMessage('无效的物品。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if tempTItemData.rlockState <> 0 then
  begin
    uUser.SendClass.SendChatMessage('锁状态物品无法邮寄。', SAY_COLOR_SYSTEM);
    exit;
  end;

  if tempTItemData.rboNotExchange then
  begin
    uUser.SendClass.SendChatMessage('限制交易物品，禁止邮寄。', SAY_COLOR_SYSTEM);
    exit;
  end;
                   //20130906修改，所有物品都能邮寄
 { if tempTItemData.rboNotTrade then
  begin
    uUser.SendClass.SendChatMessage('限制出售物品，禁止邮寄。', SAY_COLOR_SYSTEM);
    exit;
  end;    }
  if tempTItemData.rCount < aItemCount then
  begin
    uUser.SendClass.SendChatMessage('物品数量不够。', SAY_COLOR_SYSTEM);
    exit;
  end;
  tempTItemData.rCount := aItemCount;
  uuser.affair(hicaStart);
    //扣交易费用
  tempGold.rCount := Fpoundage;
  if uUser.ItemEmailDeleteItem(@tempGold) = false then
  begin
    uUser.SendClass.SendChatMessage('金钱不够。', SAY_COLOR_SYSTEM);
    exit;
  end;

    //1,背包中 扣除 并且纪录
  if uUser.ItemEmailDelKeyItem(aItemKey, aItemCount, @tempTItemData) = false then
  begin
    uUser.SendClass.SendChatMessage('附件物品错误2！', SAY_COLOR_SYSTEM);
    uuser.affair(hicaRoll_back);
    exit;
  end;
    //2,转换成 精简 物品
  CopyItemToDBItem(tempTItemData, abuf);
    //3,获得 新的邮件ID
  aID := NEWEmailIDClass.GetNewID;
    //4,发送邮件
  if tempTEmailclass.add(aDestName, aID, aTitle, aText, asourceName, aTime, abuf, aGOLD_Money) = false then
  begin
    uUser.SendClass.SendChatMessage('邮件发送失败！', SAY_COLOR_SYSTEM);
    uuser.affair(hicaRoll_back);
    exit;
  end;
    //扣【元宝】
  if aGOLD_Money > 0 then
  begin
    if uUser.DEL_GOLD_Money(aGOLD_Money) = false then
    begin
      uUser.SendClass.SendChatMessage('邮件发送失败！', SAY_COLOR_SYSTEM);
      tempTEmailclass.del(aid);
      uuser.affair(hicaRoll_back);
      exit;
    end;
  end;
  uUser.SendClass.SendChatMessage(format('给%s的邮件发送成功！', [aDestName]), SAY_COLOR_SYSTEM);
  exit;
end;

function TEmailclass.getcount(): integer;
begin
  result := Fdata.Count;
end;

function TEmailclass.del(eid: integer): boolean;
var
  i: integer;
  pp: TEmaildataclass;
begin
  result := false;
  for i := 0 to Fdata.Count - 1 do
  begin

    pp := Fdata.Items[I];
    if pp <> nil then
      if pp.FID = eid then
      begin
        Fdata.Delete(i);
        EmailList.DBEmailDEL(pp.FID);
        pp.Free;
        result := true;
        if FUSER <> nil then FUSER.NewEmailState := Fdata.Count > 0;

        exit;
      end

  end;

end;

procedure TEmailclass.Emailget(aid: integer; uUser: tuser); //
var
  adata: TWordComData;
  pp: TEmaildataclass;
  tempitem: TItemData;
  str: string;
begin
  pp := get(aid);
  if pp = nil then exit;
  adata.Size := 0;
  WordComData_ADDbyte(adata, SM_EMAIL);
  WordComData_ADDbyte(adata, EMAIL_get);
  WordComData_ADDdword(adata, pp.FID);
    //收【元宝】
  if pp.FGOLD_Money > 0 then
  begin
    if uuser.Add_GOLD_Money(pp.FGOLD_Money) = false then
    begin
      uUser.SendClass.SendChatMessage('收取附件失败3！', SAY_COLOR_SYSTEM);
      exit;
    end;
  end;
  if pp.Fbuf.rName <> '' then
  begin
    CopyDBItemToItem(pp.Fbuf, tempitem);
    if tempitem.rName = '' then
    begin
      uUser.SendClass.SendChatMessage('收取附件失败1！', SAY_COLOR_SYSTEM);
      exit;
    end;
    if uUser.ItemEmailADDITEM(@tempitem) = false then
    begin
      uUser.SendClass.SendChatMessage('收取附件失败2！', SAY_COLOR_SYSTEM);
      exit;
    end;
  end;
  del(aid);
  uUser.SendClass.SendData(adata);
  uUser.SendClass.SendChatMessage('收取邮件成功！', SAY_COLOR_SYSTEM);
  exit;
end;

procedure TEmailclass.Emaildel(aid: integer; uUser: tuser); //
begin

end;

procedure TEmailclass.Emailread(aid: integer; uUser: tuser);
var
  adata: TWordComData;
  pp: TEmaildataclass;
  tempitem: TItemData;
  str: string;
begin
  pp := get(aid);
  if pp = nil then exit;
  adata.Size := 0;
  WordComData_ADDbyte(adata, SM_EMAIL);
  WordComData_ADDbyte(adata, EMAIL_read);

  WordComData_ADDdword(adata, pp.FID);
  WordComData_ADDstring(adata, pp.FTitle);
  WordComData_ADDstring(adata, pp.FEmailText);
  WordComData_ADDstring(adata, pp.FsourceName);
  WordComData_ADDdatetime(adata, pp.FTime);
  tempitem.rName := '';
  if pp.Fbuf.rName <> '' then
  begin
    CopyDBItemToItem(pp.Fbuf, tempitem);
  end;

  if tempitem.rName <> '' then
  begin
    WordComData_ADDbyte(adata, 1);
    TItemDataToTWordComData(tempitem, adata);
  end else
    WordComData_ADDbyte(adata, 0);

  uUser.SendClass.SendData(adata);
end;

function TEmailclass.add(aDestName: string; aID: integer; aTitle, aText, asourceName: string; aTime: tdatetime; abuf: TCutItemData; aGOLD_Money: integer; boSQLSave: boolean = true): boolean;
var
  pp: TEmaildataclass;
begin
  result := false;
  pp := get(aid);
  if pp <> nil then
  begin
        //记录
    frmMain.WriteLogInfo(format('function TEmailclass.add( aID:%d,aDestName:%s, asourceName:%s, aTitle:%s,  Item: %s, aGOLD_Money: %d)', [aID, aDestName, asourceName, aTitle, abuf.rName, aGOLD_Money]));
    exit;
  end;
  pp := TEmaildataclass.Create;
  pp.FID := aid;
  pp.FDestName := aDestName;
  pp.FTitle := aTitle;
  pp.FEmailText := aText;
  pp.FsourceName := asourceName;
  pp.FTime := aTime;
  pp.Fbuf := abuf;
  pp.FGOLD_Money := aGOLD_Money;
  Fdata.Add(pp);
  result := true;

  if boSQLSave then EmailList.DBEmailSave(pp);

  if FUSER <> nil then FUSER.NewEmailState := true;
end;

procedure TEmailclass.Clear();
var
  i: integer;
  pp: TEmaildataclass;
begin
  for i := 0 to Fdata.Count - 1 do
  begin

    pp := Fdata.Items[I];
    if pp <> nil then
      pp.Free;
  end;
  Fdata.Clear;
end;

constructor TEmailclass.Create;
begin
  Fdata := TLIST.Create;
  Fpoundage := 1000;
  FUSER := nil;
end;

destructor TEmailclass.Destroy;
begin
  Clear;
  Fdata.Free;
  inherited destroy;
end;
//////////////////////
{
procedure TEmaildataBatUpdate.Clear();
var
    i: integer;
    pp: TEmaildataclass;
begin
    for i := 0 to Fdata.Count - 1 do
    begin

        pp := Fdata.Items[I];
        if pp <> nil then
            pp.Free;
    end;
    Fdata.Clear;
end;

function TEmaildataBatUpdate.get(aid: integer): pointer;
var
    i: integer;
    pp: TEmaildataclass;
begin
    result := nil;
    for i := 0 to Fdata.Count - 1 do
    begin
        pp := Fdata.Items[I];
        if pp <> nil then
            if pp.FID = aid then
            begin
                result := pp;
                exit;
            end;
    end;
end;

procedure TEmaildataBatUpdate.del(aid: integer);
var
    i: integer;
    pp: TEmaildataclass;
begin
    for i := 0 to Fdata.Count - 1 do
    begin
        pp := Fdata.Items[I];
        if pp <> nil then
            if pp.FID = aid then
            begin
                Fdata.Delete(i);
                pp.Free;
                exit;
            end;
    end;
end;

procedure TEmaildataBatUpdate.DBDel();
var
    i, rcount: integer;
    pp: TEmaildataclass;
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
            WordComData_ADDbyte(Code, Email_DELETE);
            WordComData_ADDdword(Code, pp.FID);
            SendDbEMAIL(@Code, Code.Size + 2);
        end;
        inc(rcount);
        if rcount >= 10 then Break;
    end;
end;

procedure TEmaildataBatUpdate.DBRegNameINSERT();
var
    i, rcount: integer;
    pp: TEmaildataclass;
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
            WordComData_ADDbyte(Code, Email_RegNameINSERT);
            WordComData_ADDdword(Code, pp.FID);
            WordComData_ADDstring(Code, pp.FDestName);
            SendDbEMAIL(@Code, Code.Size + 2);
        end;
        inc(rcount);
        if rcount >= 10 then Break;
    end;
end;

procedure TEmaildataBatUpdate.DBUPdate();
var
    i, rcount: integer;
    pp: TEmaildataclass;
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
            WordComData_ADDbyte(Code, Email_UPDATE);
            pp.SaveToWordComData(code);
            SendDbEMAIL(@Code, Code.Size + 2);
        end;
        inc(rcount);
        if rcount >= 10 then Break;
    end;
end;

procedure TEmaildataBatUpdate.Update(CurTick: integer);
begin
    if GetItemLineTimeSec(CurTick - FDCurTick) < 5 then exit;                   //5秒
    FDCurTick := CurTick;
    case Ftype of
        ebuDel: DBDel;
        ebuUPdate: DBUPdate;
        ebuREGName: DBRegNameINSERT;
    end;
end;

procedure TEmaildataBatUpdate.add(atemp: TEmaildataclass);
var
    pp: TEmaildataclass;
    Code: TWordComData;
    id: integer;
begin
    if get(atemp.FID) <> nil then
    begin
        del(atemp.FID);
    end;
    pp := TEmaildataclass.Create;
    Code.Size := 0;
    atemp.SaveToWordComData(code);
    id := 0;
    pp.LoadFormWordComData(code, id);
    Fdata.Add(pp);
end;

constructor TEmaildataBatUpdate.Create(atype: TEmaildataBatUpdatetype);
begin
    Ftype := atype;
    Fdata := Tlist.Create;
    FDCurTick := 0;
end;

destructor TEmaildataBatUpdate.Destroy;
begin
    Clear;
    Fdata.Free;
    inherited destroy;
end;
}
////////////////////////////////

procedure TEmailList.GetEmailListName(uUser: tuser);
var
  pp: TEmailclass;
  tempuser: tuser;
begin
  if uUser.aEmail = nil then
  begin

    exit;
  end;
  TEmailclass(uUser.aEmail).EmailgetList(uuser);
end;


procedure TEmailList.Update(CurTick: integer);
begin
end;


procedure TEmailList.Clear();
var
  i: integer;
  pp: TEmailclass;
begin
  for i := 0 to DataNameKey.Count - 1 do
  begin
    pp := DataNameKey.GetIndex(i);
    if pp <> nil then
      pp.Free;
  end;
  DataNameKey.Clear;
end;

function TEmailList.getname(aname: string): pointer;
begin
  result := DataNameKey.Select(aname);
end;


function TEmailList.SystemSendNewEmail(aDestName: string; aTitle, aText, asourceName: string; abuf: TCutItemData; aGOLD_Money: INTEGER; var outemaiid: integer): boolean;
var
  pp: TEmailclass;
  aID: integer;
  aTime: tdatetime;
begin
  if abuf.rName = '' then
    fillchar(abuf, sizeof(abuf), 0);
  aTime := now();
  result := false;
    //保证 有邮件队列
  pp := getname(aDestName);
  if pp = nil then
    pp := createEmailclass(aDestName);
    //保证 有ID
  while true do
  begin
    aid := NEWEmailIDClass.GetNewID;
    if pp.get(aid) = nil then Break;
  end;
  outemaiid := aid;
    //上面 只要ID唯一 肯定能发出
  if pp.add(aDestName, aID, aTitle, aText, asourceName, aTime, abuf, aGOLD_Money) = false then
  begin
    exit;
  end;
  result := true;
end;


procedure TEmailList.del(aDestName: string; aID: integer);
var
  pp: TEmailclass;
begin
  pp := getname(aDestName);
  if pp = nil then exit;
  pp.del(aID);
end;

procedure TEmailList.add(aDestName: string; aID: integer; aTitle, aText, asourceName: string; aTime: tdatetime; abuf: TCutItemData; aGOLD_Money: INTEGER);
var
  pp: TEmailclass;
begin
  pp := getname(aDestName);
  if pp = nil then createEmailclass(aDestName);

  pp := getname(aDestName);
  if pp = nil then
  begin

    exit;
  end;
  pp.add(aDestName, aID, aTitle, aText, asourceName, aTime, abuf, aGOLD_Money);
end;


//唯一 创建 邮件 管理
//一人一个管理类

function TEmailList.createEmailclass(aname: string; boSQLSAVE: boolean = false): pointer;
var
  pp: TEmailclass;
begin
  result := getname(aname);
  if result = nil then
  begin
    pp := TEmailclass.Create;
    DataNameKey.Insert(aname, pp);
    result := pp;
    if boSQLSAVE then DBEmailNameListSave(aname);
  end;
end;

constructor TEmailList.Create;
begin
  EmailNameListDBFileClass := TDBEmailNameListFileClass.Create;
  DBFileClass := TDBEmailFileClass.Create;
  DataNameKey := TStringKeyListClass.Create; //TEmail

  DBEmailNameListLoadfile;
  DBEmailLoadFile;
end;

destructor TEmailList.Destroy;
begin
  Clear;
  DataNameKey.Free;

  DBFileClass.Free;
  EmailNameListDBFileClass.Free;
  inherited destroy;
end;


{ TEmailDBAdapter }

function TDBEmailFileClass.count: integer;
begin
  result := dbfile.count;
end;

constructor TDBEmailFileClass.Create;
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_06_01_Email';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TEmaildata);
  dbfile := TDbFileClass.Create(aHead, '.\savedb\Email.DB');
end;

function TDBEmailFileClass.Delete(aIndexName: string): Byte;
begin
  result := dbfile.DELETE(aIndexName);
end;

destructor TDBEmailFileClass.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TDBEmailFileClass.Insert(aIndexName: string; aEmaildata: pTEmaildata): Byte;
begin
  result := dbfile.Insert(aIndexName, aEmaildata, sizeof(TEmaildata));
end;

function TDBEmailFileClass.Select(aIndexName: string; aEmaildata: pTEmaildata): Byte;
begin
  result := dbfile.Select(aIndexName, aEmaildata, sizeof(TEmaildata));
end;

function TDBEmailFileClass.SelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;

function TDBEmailFileClass.Update(aIndexName: string; aEmaildata: pTEmaildata): Byte;
begin
  result := dbfile.Update(aIndexName, aEmaildata, sizeof(TEmaildata));
end;
{ TEmailNameListDBFileClass }

function TDBEmailNameListFileClass.count: integer;
begin
  result := dbfile.count;
end;

constructor TDBEmailNameListFileClass.Create;
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_06_01_EmailNameList';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TEmailNamedata);
  dbfile := TDbFileClass.Create(aHead, '.\savedb\EmailNameList.DB');
end;

function TDBEmailNameListFileClass.Delete(aIndexName: string): Byte;
begin
  result := dbfile.DELETE(aIndexName);
end;

destructor TDBEmailNameListFileClass.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TDBEmailNameListFileClass.Insert(aIndexName: string; aEmailNamedata: pTEmailNamedata): Byte;
begin
  result := dbfile.Insert(aIndexName, aEmailNamedata, sizeof(TEmailNamedata));
end;

function TDBEmailNameListFileClass.Select(aIndexName: string; aEmailNamedata: pTEmailNamedata): Byte;
begin
  result := dbfile.Select(aIndexName, aEmailNamedata, sizeof(TEmailNamedata));
end;

function TDBEmailNameListFileClass.Update(aIndexName: string; aEmailNamedata: pTEmailNamedata): Byte;
begin
  result := dbfile.Update(aIndexName, aEmailNamedata, sizeof(TEmailNamedata));
end;

function TDBEmailNameListFileClass.SelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;



procedure TEmailList.DBEmailNameListLoadFile;
var
  i: integer;
  tempList: tstringlist;
begin
  tempList := tstringlist.Create;
  try
    tempList.Text := EmailNameListDBFileClass.SelectAllName;
    for i := 0 to tempList.Count - 1 do
    begin
      createEmailclass(tempList.Strings[i]);
    end;
  finally
    tempList.Free;
  end;
end;

procedure TEmailList.DBEmailNameListSave(aname: string);
var
  aEmailNamedata: TEmailNamedata;
  fresult: integer;
begin
  aEmailNamedata.rUserName := aname;
  aEmailNamedata.rRegDate := Now;
  fresult := EmailNameListDBFileClass.Insert(aEmailNamedata.rUserName, @aEmailNamedata);
  if fresult <> db_ok then frmMain.WriteLogInfo(format('procedure TEmailList.EmailNameListSave Error (%s)', [GetDBErrorText(fresult)]));
end;





procedure TEmailList.DBEmailLoadFile();
var
  aEmaildata: TEmaildata;
  fresult: integer;
  sid: string;
  i: integer;
  tempList: tstringlist;
  cp: TEmaildataclass;
  procedure DBaddclass(atemp: TEmaildataclass);
  var
    pp: TEmailclass;
  begin
    pp := getname(atemp.FDestName);
    if pp = nil then createEmailclass(atemp.FDestName);
    pp := getname(atemp.FDestName);
    if pp = nil then
    begin
      frmMain.WriteLogInfo(format('procedure DBaddclass(atemp: TEmaildataclass); (%s)', [atemp.FDestName]));
      exit;
    end;
    pp.add(atemp.FDestName, atemp.fID, atemp.fTitle, atemp.FEmailText, atemp.fsourceName, atemp.fTime, atemp.fbuf, atemp.fGOLD_Money, false);
  end;

begin
  tempList := tstringlist.Create;
  cp := TEmaildataclass.Create;
  try
    tempList.Text := DBFileClass.SelectAllName;
    for i := 0 to tempList.Count - 1 do
    begin
      sid := tempList.Strings[i];
      fresult := DBFileClass.Select(sid, @aEmaildata);
      if fresult = db_ok then
      begin
        if DaysBetween(now(), aEmaildata.FTime) > 15 then
        begin
                //过期 删除 邮件
          DBEmailDEL(aEmaildata.FID);
        end else
        begin
                //载入
          cp.LoadFormTEmaildata(aEmaildata);
          DBaddclass(cp);
        end;
      end else
      begin
        frmMain.WriteLogInfo(format('procedure TEmailList.DBEmailLoadFile(); (%s)', [GetDBErrorText(fresult)]));
      end;
    end;
  finally
    tempList.Free;
    cp.free;
  end;
end;

procedure TEmailList.DBEmailDEL(aid: integer);
var
  fresult: integer;
begin
  fresult := DBFileClass.Delete(inttostr(aid));
  if fresult <> db_ok then frmMain.WriteLogInfo(format('procedure TEmailList.DBEmailDEL (%s)', [GetDBErrorText(fresult)]));
end;

procedure TEmailList.DBEmailSave(cp: TEmaildataclass);
var
  aEmaildata: TEmaildata;
  fresult: integer;
begin
  cp.SaveToTEmaildata(aEmaildata);
  fresult := DBFileClass.Insert(inttostr(cp.FID), @aEmaildata);
  if fresult <> db_ok then frmMain.WriteLogInfo(format('procedure TEmailList.EmailSave Error (%s)', [GetDBErrorText(fresult)]));
end;
initialization
  begin
    EmailList := TEmailList.Create;

  end;

finalization
  begin
    EmailList.Free;
  end;
end.

