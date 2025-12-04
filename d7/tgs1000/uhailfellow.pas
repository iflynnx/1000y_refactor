unit uhailfellow;
interface

uses
  Windows, Sysutils, Classes, Deftype, BasicObj, SvClass,
  SubUtil, uSkills, uLevelExp, uuser, aUtil32, uGramerid, //AnsUnit,
  FieldMsg, MapUnit, uKeyClass, uResponsion, uAnsTick, MyAccess, Variants;
const
  MAX_hailfellow_count = 30;
type
    {玩家 上先 THailFellow附加给TUSER
    事件都有TUSER发起}
  ThailfellowData = record
    rName: string[20];

  end;
  pThailfellowData = ^ThailfellowData;

  THailFellow = class
  private
    FUserName: string;
    DataList: TList;
    NameKey: TStringKeyClass;

    ADDMsgList: TResponsion; //加人  等待 应答 列表
  public
    FuUser: Tuser;
    constructor Create;
    destructor Destroy; override;
    procedure LoadFrom(username, listname: string);
    function ADD(ausername: string): string;

    function ADDMsg(ausername: string): string;
    function ADDMsgOK(ausername: string): string;
    function ADDMsgNo(ausername: string): string;
    function ADDok(ausername: string): string;
    function ADDNO(ausername: string): string;
    function ADDdata(ausername: string): boolean;
    function del(ausername: string): string;
    procedure SaveTo(var username, listname: string);
    procedure Clear;
    property UserName: string read fUserName;
    function isHFname(aName: string): boolean;

    procedure SETUPLine(auser: Tuser);
    procedure SetDownLine();
    procedure Update(CurTick: integer);
  end;
  THailFellowList = class
  private
    DataList: TList;
    NameKey: TStringKeyClass;
    FDCurTick: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(aFileName: string);
    procedure SaveToFile(aFileName: string);
    function GetName(aUserName: string): pointer;
    procedure MYSQLGetList(auser: Tuser);
    function MYSQLISNAME(aName, rName: string): integer;
    function MYSQLCOUNT(aName: string; atype: Integer): Integer;
    function MYSQLADD(auser: Tuser; aName: string; aType: integer): string;
    function MYSQLDEL(auser: Tuser; aName: string): string;
    procedure Clear;
    procedure Update(CurTick: integer);
  end;
var
  HailFellowList: THailFellowList;

implementation

uses
  uDM, SvMain;

constructor THailFellow.Create;
begin
  ADDMsgList := TResponsion.Create;
  NameKey := TStringKeyClass.Create;
  DataList := TList.Create;
  FuUser := nil;
end;

destructor THailFellow.Destroy;

begin

  ADDMsgList.Free;
  Clear;
  DataList.Free;
  NameKey.Free;
  inherited destroy;
end;

procedure THailFellow.Clear;
var
  i: integer;
begin
  for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
  DataList.Clear;
  NameKey.Clear;
end;

procedure THailFellow.SETUPLine(auser: Tuser);
var
  i: integer;
  tempuser
    : tuser;
  tempTHailFellow: THailFellow;
  p: pThailfellowData;

begin
  FuUser := auser;

  if FuUser = nil then exit;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p = nil then Continue;
    tempuser := userlist.GetUserPointer(p.rName);
    if tempuser <> nil then
    begin //对方 在线
      tempTHailFellow := HailFellowList.GetName(tempuser.name);
      if tempTHailFellow <> nil then
      begin //对方 有好友
        if tempTHailFellow.isHFname(fUserName) then
        begin //对方 好友 里 有自己
                    //通知对方
          tempuser.SendClass.SendHailFellow(FuUser.name, '',
            FuUser.BasicData.x, FuUser.BasicData.y, HailFellow_state_onlise);
                    //通知自己
          FuUser.SendClass.SendHailFellow(tempuser.name, '',
            tempuser.BasicData.x, tempuser.BasicData.y, HailFellow_state_onlise);
          Continue;
        end;
      end;
    end;
        //通知自己 对方是里线
         //通知自己
    FuUser.SendClass.SendHailFellow(p.rname, '',
      0, 0, HailFellow_state_downlide);
        // iname.SendClass.SendHailFellowGameExit(p.rname);
  end;

end;


procedure THailFellow.Update(CurTick: integer);
var
  i: integer;
  p: pTResponsiondata;
begin
  if FuUser = nil then exit;

  for i := ADDMsgList.Count - 1 downto 0 do
  begin
    p := ADDMsgList.GetIndex(i);
    if p = nil then Continue;

    if CurTick > (p.rTime + ADDMsgList.FAvailabilityTime) then
    begin //过期

      FuUser.SendClass.SendChatMessage(format('加玩家 %s好友超时！', [p.rDestName]), SAY_COLOR_SYSTEM);
      ADDMsgList.delIndex(i);
    end;
  end;
end;

procedure THailFellow.setDownLine();
var
  i: integer;
  tempuser: tuser;
  p: pThailfellowData;
  tempTHailFellow: THailFellow;
begin
  FuUser := nil;

  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p = nil then Continue;
    tempuser := userlist.GetUserPointer(p.rName);
    if tempuser = nil then Continue;
        //对方在线
    tempTHailFellow := HailFellowList.GetName(tempuser.name);
    if tempTHailFellow = nil then Continue;
        //对方有好友
    if not tempTHailFellow.isHFname(FUserName) then Continue;
        //对方 好友里有自己

        //通知对方 自己 下线
    tempuser.SendClass.SendHailFellowGameExit(FUserName);
  end;

end;

function THailFellow.isHFname(aName: string): boolean;
begin
  Result := false;
  if NameKey.Select(aName) <> nil then
    Result := true;

end;

function THailFellow.ADDok(ausername: string): string;
var
  tempuser: tuser;
//    p               :pThailfellowData;
begin
  result := '';
  if not ADDMsgList.isName(ausername) then exit;
  ADDMsgList.del(ausername);

  if FuUser = nil then exit;
  tempuser := userlist.GetUserPointer(ausername);
  if tempuser = nil then exit;

  if isHFname(ausername) then exit;
  if DataList.Count >= MAX_hailfellow_count then exit;

  if ADDdata(ausername) then
  begin
    FuUser.SendClass.SendChatMessage(format('成功添加 %s 为好友！', [ausername]), SAY_COLOR_SYSTEM);
        //给自己 发个消息
    FuUser.SendClass.SendHailFellow(tempuser.name, '',
      tempuser.BasicData.x, tempuser.BasicData.y, HailFellow_state_onlise);
  end;
end;

function THailFellow.ADDNO(ausername: string): string;
//var
//    tempuser        :tuser;
//    p               :pThailfellowData;
begin
  result := '';
  ADDMsgList.del(ausername);

  if FuUser = nil then exit;
  FuUser.SendClass.SendChatMessage(format('玩家 %s 拒绝加好友！', [ausername]), SAY_COLOR_SYSTEM);

end;

function THailFellow.ADDdata(ausername: string): boolean;
var
  p: pThailfellowData;
begin
  result := false;
  if ausername = UserName then exit;
  if isHFname(ausername) then exit;
  if DataList.Count >= MAX_hailfellow_count then exit;
  new(p);
  p.rName := copy(ausername, 1, 20);
  NameKey.Insert(p.rName, (p));
  DataList.Add(p);
  result := true;
end;

function THailFellow.ADD(ausername: string): string;
var
  tempuser: tuser;
//    p               :pThailfellowData;
  tempTHailFellow: THailFellow;
begin
  if ausername = UserName then
  begin
    result := format('不能添加自己为好友！', [ausername]);
    exit;
  end;
  if DataList.Count >= MAX_hailfellow_count then
  begin
    result := format('添加失败,你的好友已满！', [ausername]);
    exit;
  end;

  if FuUser = nil then exit;
  if isHFname(ausername) then
  begin
    result := format('%s 已是你好友！', [ausername]);
    exit;
  end;
  tempuser := userlist.GetUserPointer(ausername);
  if tempuser = nil then
  begin
    result := format('%s 不在线！', [ausername]);
    exit;
  end;

  tempTHailFellow := HailFellowList.GetName(ausername);
  if tempTHailFellow = nil then
  begin
    result := format('%s 不在线！', [ausername]);
    exit;
  end;
  if not tempuser.HailFellowJoin then
  begin
    Result := format('%s拒绝加为好友', [aUserName]);
    Exit;
  end;
  if tempTHailFellow.DataList.Count >= MAX_hailfellow_count then
  begin
    result := format('%s 好友已满！', [ausername]);
    exit;
  end;
  result := format('已向 %s 发送添加好友请求！', [ausername]);
  ADDMsgList.Add(ausername, UserName);
    //发送 通知 对方 看对方是否同意
  tempTHailFellow.ADDMsg(FUserName);

end;
//被 通知自己 对方+我

function THailFellow.ADDMsg(ausername: string): string;
//var
  //  tempuser        :tuser;
begin

  if FuUser = nil then exit;
  FuUser.SendClass.SendHailFellow_Message_ADD(ausername);

end;

function THailFellow.ADDMsgNo(ausername: string): string;
var
  //  tempuser        :tuser;
  tempTHailFellow: THailFellow;
begin
    //自己 拒绝 别人加
  result := '';

  if FuUser = nil then exit;
  tempTHailFellow := HailFellowList.GetName(ausername);
  if tempTHailFellow = nil then exit;
  tempTHailFellow.ADDNO(FUserName);

end;

function THailFellow.ADDMsgOK(ausername: string): string;
var
//    tempuser        :tuser;
  tempTHailFellow: THailFellow;
begin
    //自己 同意 别人 加我
  result := '';

  if FuUser = nil then exit;
  tempTHailFellow := HailFellowList.GetName(ausername);
  if tempTHailFellow = nil then exit;
  tempTHailFellow.ADDok(FUserName);
    //自己 加 别人
  if isHFname(ausername) then exit; //对方
  ADD(ausername);
end;

function THailFellow.del(aUserName: string): string;
var
  tempuser: tuser;
  p: pThailfellowData;
  i: integer;
begin

  if FuUser = nil then exit;

  if not isHFname(ausername) then
  begin
    result := format('%s 不是你好友！', [ausername]);
    exit;
  end;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p = nil then Continue;
    if p.rName = aUserName then
    begin
      DataList.Delete(i);
      NameKey.Delete(p.rName);
      dispose(p);
      result := format('成功删除好友 %s', [ausername]);
            //通知 对方
      tempuser := userlist.GetUserPointer(ausername);
      if tempuser <> nil then
      begin
        tempuser.SendClass.SendHailFellowdel2(FUserName);
        Thailfellow(tempuser.ahailfellow).del(FUserName);
      end;
            //通知 自己
      FuUser.SendClass.SendHailFellowdel(ausername);

      Break;
    end;
  end;

end;

procedure THailFellow.LoadFrom(username, listname: string);
var
  i: integer;
  str, rdstr: string;
  p: pThailfellowData;
begin
  FUserName := username;
  str := listname;
  for i := 0 to MAX_hailfellow_count - 1 do
  begin
    if str = '' then Break;
    str := GetValidStr3(str, rdstr, ':');
    if rdstr = '' then Break;
    new(p);
    rdstr := copy(rdstr, 1, 20);
    p.rName := rdstr;

    NameKey.Insert(p.rName, (p));
    DataList.Add(p);
  end;

end;

procedure THailFellow.SaveTo(var username, listname: string);
var
  i: integer;
  str: string;
  p: pThailfellowData;
begin
  username := FUserName;
  listname := '';
  str := '';
  for i := 0 to DataList.Count - 1 do
  begin

    p := DataList.Items[i];
    if p = nil then Continue;
    str := str + p.rName + ':';
  end;
  listname := str;
end;
//-----------------------------

constructor THailFellowList.Create;
begin

  NameKey := TStringKeyClass.Create;
  DataList := TList.Create;

  LoadFromFile('.\HailFellow\HailFellow.SDB');
end;

destructor THailFellowList.Destroy;
begin
  SaveToFile('.\HailFellow\HailFellow.SDB');
  Clear;
  DataList.Free;
  NameKey.Free;
  inherited destroy;
end;

procedure THailFellowList.Clear;
var
  i: integer;

begin
  for i := 0 to DataList.Count - 1 do
    THailFellow(DataList[i]).Free;
  DataList.Clear;
  NameKey.Clear;
end;

procedure THailFellowList.LoadFromFile(aFileName: string);
var
  i: integer;
  str, rdstr: string;
  StringList: TStringList;
  pHailFellow: THailFellow;
  aname, anamelist: string;
begin
  Clear;
  if not FileExists(aFileName) then exit;

  StringList := TStringList.Create;
  StringList.LoadFromFile(aFileName);

  for i := 1 to StringList.Count - 1 do
  begin
    pHailFellow := THailFellow.Create;

    str := StringList[i];

    str := GetValidStr3(str, rdstr, ',');
    aname := rdstr;
    str := GetValidStr3(str, rdstr, ',');
    anamelist := rdstr;
    pHailFellow.LoadFrom(aname, anamelist);

    NameKey.Insert(pHailFellow.UserName, (pHailFellow));
    DataList.Add(pHailFellow);
  end;
  StringList.Free;
end;
//没有 就创建一份

procedure THailFellowList.Update(CurTick: integer);
var
  i: integer;
  pHailFellow: THailFellow;
begin
  if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
  FDCurTick := CurTick;
  for i := 0 to DataList.Count - 1 do
  begin
    pHailFellow := DataList[i];
    pHailFellow.Update(CurTick);
  end;

end;

function THailFellowList.GetName(aUserName: string): pointer;
var

  p: THailFellow;
begin

  Result := NameKey.Select(aUserName);
  if Result = nil then
  begin
    p := THailFellow.Create;
    p.LoadFrom(aUserName, '');
    NameKey.Insert(p.UserName, (p));
    DataList.Add(p);
    Result := p;
  end;
end;

procedure THailFellowList.MYSQLGetList(auser: Tuser);
var
  i: integer;
  mysql: TMyQuery;
  rname, sSql: string;
  rtype: integer;
  v: Variant;
begin
  if auser = nil then exit;
  try
    if not dm.MyConn.Connected then
    begin
      dm.Connect;
    end;

    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
    end;
    mysql.Free;

    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      sSql := format('SELECT rname,type FROM %s WHERE aname = "%s"', [INI_CONTACTTABLE, auser.name]);
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add(sSql);
      mysql.ExecSQL;
      if not mysql.IsEmpty then
      begin
        mysql.First;
        while not mysql.Eof do
        begin
        //发送数据
          v := mysql.FieldByName('rname').AsVariant;
          rname := VarToStrDef(v, 'errdata');
          v := mysql.FieldByName('type').AsVariant;
          rtype := _StrToInt(VarToStrDef(v, 'errdata'));
          auser.SendClass.SendHailFellowList(rname, rtype);
        //获取下一行数据
          mysql.Next;
        end;
      end;
    end;
  finally
    mysql.Close;
    mysql.Free;
  end;
end;

function THailFellowList.MYSQLISNAME(aName, rName: string): integer;
var
  i: integer;
  mysql: TMyQuery;
  sSql: string;
  rtype: integer;
  v: Variant;
begin
  result := -1;
  try
    if not dm.MyConn.Connected then
    begin
      dm.Connect;
    end;

    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
    end;
    mysql.Free;
    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      sSql := format('SELECT type FROM %s WHERE aname = "%s" and rname = "%s"', [INI_CONTACTTABLE, aName, rName]);
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add(sSql);
      mysql.ExecSQL;
      if not mysql.IsEmpty then
      begin

        v := mysql.FieldByName('type').AsVariant;
        rtype := _StrToInt(VarToStrDef(v, 'errdata'));
        result := rtype;
        exit;
      end;
    end;
  finally
    mysql.Close;
    mysql.Free;
  end;
end;

function THailFellowList.MYSQLCOUNT(aName: string; atype: Integer): Integer;
var
  mysql: TMyQuery;
  sSql: string;
  rcount: integer;
  v: Variant;
begin
  result := -1;
  try
    if not dm.MyConn.Connected then
    begin
      dm.Connect;
    end;

    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
    end;
    mysql.Free;
    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      sSql := format('SELECT count(rname) as count FROM %s WHERE aname = "%s" and type = %d', [INI_CONTACTTABLE, aName, atype]);
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add(sSql);
      mysql.ExecSQL;
      if not mysql.IsEmpty then
      begin
        v := mysql.FieldByName('count').AsVariant;
        rcount := _StrToInt(VarToStrDef(v, 'errdata'));
        result := rcount;
        exit;
      end;
    end;
  finally
    mysql.Close;
    mysql.Free;
  end;
end;

function THailFellowList.MYSQLADD(auser: Tuser; aName: string; aType: integer): string;
var
  i: integer;
  mysql: TMyQuery;
  rname, sSql: string;
  rtype: integer;
  v: Variant;
  tempuser: tuser;
begin
  if auser = nil then exit;

  result := '';             

  if auser.name = aName then
  begin
    result := '不能添加自己!';
    exit;
  end;

  tempuser := userlist.GetUserPointer(aName);
  if tempuser = nil then
  begin
    result := aName + '不在线!';
    exit;
  end;

  rtype := MYSQLISNAME(auser.name, aName);
  if rtype <> -1 then
  begin
    if rtype = 0 then
      result := aName + '在你的好友列表里!'
    else if rtype = 1 then
      result := aName + '在你的仇敌列表里!';
    exit;
  end;

  if MYSQLCOUNT(auser.name, aType) >= 50 then
  begin
    if aType = 0 then
      result := aName + '添加好友失败,好友已满!'
    else if aType = 1 then
      result := aName + '添加仇敌失败,仇敌已满!';
    exit;
  end;

  try
    if not dm.MyConn.Connected then
    begin
      dm.Connect;
    end;

    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
    end;
    mysql.Free;
    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      sSql := format('INSERT INTO %s (aname, rname, type) VALUES ("%s", "%s", %d)', [INI_CONTACTTABLE, auser.name, aName, aType]);
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add(sSql);
      mysql.ExecSQL;
      if mysql.RowsAffected > 0 then
      begin
        result := aName + '添加成功';
        //给自己 发个消息
        auser.SendClass.SendHailFellowList(aName, aType);
      end
      else
        result := aName + '添加失败!';
    end;
  finally
    mysql.Close;
    mysql.Free;
  end;
  exit;
end;

function THailFellowList.MYSQLDEL(auser: Tuser; aName: string): string;
var
  i: integer;
  mysql: TMyQuery;
  rname, sSql: string;
  rtype: integer;
  v: Variant;
  tempuser: tuser;
begin
  if auser = nil then exit;

  result := '';

  if auser.name = aName then
  begin
    result := '不能删除自己!';
    exit;
  end;

  rtype := MYSQLISNAME(auser.name, aName);
  if rtype = -1 then
  begin
    result := aName + '不在列表中!'
  end;

  try
    if not dm.MyConn.Connected then
    begin
      dm.Connect;
    end;

    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
    end;
    mysql.Free;

    mysql := TMyQuery.Create(nil);
    if dm.MyConn.Connected then
    begin
      sSql := format('DELETE FROM %s WHERE aname = "%s" and rname = "%s"', [INI_CONTACTTABLE, auser.name, aName]);
      mysql.Connection := dm.MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add(sSql);
      mysql.ExecSQL;
      if mysql.RowsAffected > 0 then
      begin
        result := aName + '删除成功';
        //给自己 发个消息
        auser.SendClass.SendHailFellowMysqlDel(aName, rtype);
      end
      else
        result := aName + '删除失败!';
    end;
  finally
    mysql.Close;
    mysql.Free;
  end;
  exit;
end;

procedure THailFellowList.SaveToFile(aFileName: string);
var
  i: integer;
  str: string;
  StringList: TStringList;
  pHailFellow: THailFellow;
  aname, anamelist: string;
begin

  StringList := TStringList.Create;
  str := 'Name,HailFellowList,';
  StringList.add(str);
  for i := 0 to DataList.Count - 1 do
  begin
    pHailFellow := DataList[i];

    pHailFellow.SaveTo(aname, anamelist);
    str := aname + ',' + anamelist + ',';
    StringList.Add(str);
  end;
  StringList.SaveToFile(aFileName);
  StringList.Free;

end;

end.

