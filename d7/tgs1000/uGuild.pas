unit uGuild;
//门派 类
interface

uses
  Windows, Classes, Controls, SysUtils, Variants, svClass, subutil, uAnsTick, //AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, uMonster, uGramerid, UUser,
  IniFiles, uLevelexp, uGuildSub, uManager, UserSDB, uResponsion, uUserSub, DateUtils, PaxScripter;

const
    // DEC_GUILD_DURA_TICK = 200;
  DEC_GUILD_DURA_TICK = 500;

    // 2000.09.16 巩颇檬籍狼 郴备己 刘啊摹 5000栏肺 荐沥 by Lee.S.G
    // ADD_GUILD_DURA_BY_SYSOP = 4000;
  ADD_GUILD_DURA_BY_SYSOP = 5000;
  ADD_GUILD_DURA_BY_SUBSYSOP = 1000;
  DEC_GUILD_DURA_BY_HIT = 20; // 20;  //每次攻击门派掉血

  MAX_GUILD_DURA1 = 1100000; //1级 血  最大
  MAX_GUILD_DURA2 = 1100000; //2级 血  最大
  MAX_GUILD_DURA3 = 1100000; //3级 血  最大

  GUILDSTONE_IMAGE_NUMBER = 67;

  MAX_SUBSYSOP_COUNT = 3;
  MAX_GUILDNPC_COUNT = 5; //门派买 兵 最大5个
  MAX_ALLYGUILD_COUNT = 3; //同盟门派 最多3个
  MAX_GUILDWEAR_COUNT = 2;

type

  TGuildObject = class(TBasicObject)
  private
    LifeDataList: TLifeDataList; //门派 属性

    FGuildName: string;
    FWarAlarmStr: string;
    FGuildnotice: string; //新 公告

    FWarAlarmStartTick: Integer;
    FWarAlarmTick: Integer;

    SelfData: TCreateGuildData;

    GuildNpcList: TList;
    DieGuildNpcList: TList;
    GuildUserList: TGuildUserList;
    DuraTick: integer;

    ADDMsgList: TResponsion; //加人  等待 应答 列表
    ADDALLYMsgList: TResponsion; //请求同盟  等待 应答 列表

    boAddGuildMagic: Boolean;
    boAddAllyGuild: Boolean; //是否允许同盟
    boProtect: Boolean; //是否保护状态
    FHITNUM: integer;
    function AddGuildNpc(aName: string; aX, aY: Integer; aSex: Byte): Boolean;
  protected
    procedure Initial;
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;

    function GetGuildNpcbyName(aname: string): integer;

  public
    LifeData: TLifeData;
        ////////////////////////////////////////////////////////////////////////
        //                          门派 属性  事件
        ////////////////////////////////////////////////////////////////////////
    procedure onGuildLifdadd(var temp: TLifeDataListdata);
    procedure onGuildLifddel(var temp: TLifeDataListdata);
    procedure onGuildLifdUPdate(var temp: TLifeDataListdata);
    procedure onGuildLifdClear();
    procedure onGuildLifdSetUPdate();

        ////////////////////////////////////////////////////////////////////////
        //                          基本
        ////////////////////////////////////////////////////////////////////////
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer); override;
        ////////////////////////////////////////////////////////////////////////
    procedure Clear;
    procedure LoadFromFile(aGuildName: string);
    procedure SaveToFile;
    function GetUserGrade(uname: string): string;
    procedure GetGuildInfo(aUser: TUser);
    procedure GetGuildInfoFrom(aUser: TUser); //窗口界面
    function SETonLine(aUser: TUser): boolean; //上线
    function getGuildInfo2(aUser: TUser): boolean;
        //操作函数
    function AddUser(asysname, aUserName: string): string; //增加人
    function setSubSysop(sayer, objectname: string): string; //设置副门主
    function setSysop(sayer, objectname: string): string; //设置 门主，让位
    function delSubSysop(sayer, objectname: string): string;
    function delSubSysop_ic(sayer: string): string;

    function DelUser_Force(asysname, aUserName: string): string; //剔除人
    function DelUser(aUserName: string): string; //脱离门派

    procedure AddUserMsgOK(auser: tuser);
    procedure addALLYMsgOk(auser: tuser);
    procedure AddUserScript(aUserName: string);
        ////////////////////////////////////////////////////////////////////////
    procedure sendMsgHit();
    procedure SendMsgSubSysop(aUserName: string);
    procedure SendMsgOnlise(auserId: integer);
    procedure SendMsgGameExit(auserId: integer);
    procedure SendLevel();
        ////////////////////////////////////////////////////////////////////////
    procedure AddUserMsgNo(auser: tuser);
    procedure addALLYMsgNo(auser: tuser);

    procedure DelUser_ForceAll();
    function SetGradeName(asysname, aUserName, aGradeName: string): string;

    procedure SETGameExit(aUser: TUser);

    function MoveStone(aServerID, ax, ay: integer): Boolean;
    function CreateStone(aSysopName: string; aServerID, ax, ay: integer): Boolean;

    function IsGuildSysop(aName: string): Boolean;
    function IsGuildSubSysop(aName: string): Boolean;
    function IsGuildALLYList(aGuildName: string): Boolean;
    function GetGuildALLYNum: Integer;
    function AddGuildALLYList(aGuildName: string): Boolean;
    function DelGuildALLYList(aGuildName: string): Boolean;

    function IsGuildUser(aName: string): Boolean;
    function IsGuildNpc(aName: string): Boolean;

    function GetSelfData: PTCreateGuildData;
    function GetGuildMagicString: string;
    procedure DelGuildMagicString;
    function GetInformation: string;

    procedure AddGuildMagic(aMagicName: string);
    procedure ChangeGuildNpcName(aOldName, aNewName: string);
    function GetGuildServerID(): Integer;
    procedure SetWarAlarm(aName, aStr: string);
    function SetGuildnotice(aname, aStr: string): string;
    function readlevel(): integer;
    procedure setlevel(value: integer);

    procedure setLifeData();

    procedure setEnegy(value: integer);
    function getEnegy(): integer;
    procedure setLife(value: integer);
    function setlifex(value: integer): boolean;
    function getLife(): integer;
    function getLifeMax(): integer;
    procedure setLifeMax(value: integer);
    property GuildName: string read FGuildName;
    property level: integer read readlevel write setlevel; //等级
    property Enegy: integer read getEnegy write setEnegy; //元气
    property Life: integer read getLife write setLife; //血
    function LifeDataAdditem(aitemname: string): boolean; //物品附加属性
    function getGuildUserList: TGuildUserList;
    procedure setMaxDurability(aMaxDurability: Integer);
    procedure setMaxNum(aMaxNum: Integer);
    property MaxNum: Integer write setMaxNum;
    property MaxDurability: Integer write setMaxDurability;

    function getGuildTeam(): integer;
    procedure setGuildTeam(aGuildTeam: Integer);
    property GuildTeam: Integer read getGuildTeam write setGuildTeam;

    //function GetAddAllyGuild: Boolean;
    procedure SetAddAllyGuild(bo: boolean);
    function GetAddAllyGuild: Boolean;
    function GetGuildSysop: string;
    function AddALLYMsg(aUserName, aGuildName: string): string; //增加同盟请求
    function DelALLYMsg(aGuildName: string): string; //取消同盟消息
    procedure AllyGuildSay(aStr: string; COLOR: integer = SAY_COLOR_NORMAL); //同盟说话

  end;

  TGuildList = class
  private

    FKillstate: boolean; //攻击状态
        // starttime:ttime;
         //endtime:ttime;
    HitListArr: array[1..7, 0..23] of boolean;

    CurProcessPos: Integer;
    DataList: TList;
    FDCurTick: integer;
    FKillstateUPdateCurTick: integer;
    function GetCount: Integer;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer);

    procedure Clear;

    procedure LoadFromFile(aFileName: string);

    procedure LoadFromFileIni(aFileName: string);
    procedure SaveToFile(aFileName: string);

    procedure CompactGuild;

        // function    isGuildSysop (aGuildName, aName : String) : Boolean;
    procedure AllowGuildName(gid: integer; aboAllow: Boolean; aGuildName, aSysopName: string);
    function AllowGuildCondition(gname, uname: string): Boolean;
    function AddGuildObject(aGuildName, aOwnerName: string; aServerID, aX, aY: integer): TGuildObject;
    function AddGuildObjectCreateName(aGuildName, aOwnerName: string; aServerID, aX, aY, akey: integer): boolean;
    function GetUserGrade(aGuildName, uname: string): string;
    function GetGuildServerID(aGuildName: string): Integer;
    procedure GetGuildInfo(aGuildName: string; aUser: TUser);
    function GetGuildNname(aGuildName: string): TGuildObject;
    function GetGuildcount: integer; //获取门派数量
    function adduserMsgOk(aGuildName: string; aUser: TUser): string;
    function addALLYMsgOk(aGuildName: string; aUser: TUser): string;
    function adduserMsgNO(aGuildName: string; aUser: TUser): string;
    function addALLYMsgNo(aGuildName: string; aUser: TUser): string;

    function isGuildItem(aid: integer): boolean;

    procedure GetGuildInfoFrom(aGuildName: string; aUser: TUser);
    function CheckGuildUser(aGuildName, aName: string): Boolean;
    function MoveStone(aGuildName: string; aServerID, ax, ay: integer): Boolean;
    function CreateStone(aGuildName, aSysopName: string; aServerID, ax, ay: integer): Boolean;
    procedure DeleteStone(aGuildName: string);

    function GetGuildObject(aGuildName: string): TGuildObject;
    function GetGuildObjectByIndex(aindex: Integer): TGuildObject;
    function GetGuildObjectByMagicName(aMagicName: string): TGuildObject;
    function GetCharInformation(aName: string): string;
    function GetInformation(aName: string): string;

    procedure killstateUPdate(CurTick: integer); //攻击状态 更新
    property Count: integer read GetCount;

    function SETGuildOnLine(aGuildName: string; aUser: TUser): boolean;
    function SETGuildGameExit(aGuildName: string; aUser: TUser): boolean;
    procedure setKillstate(Value: boolean);
    function isGuildStoneArea(ax, ay: integer; amap: TMaper): boolean;


    property Killstate: boolean read FKillstate write setKillstate;

    function getMaxEnegy(level: integer): integer;

    function CheckGuildTeam(ateam: integer): boolean; //检测门派 团队 是否已存在
    procedure getBillboard;
  end;

var
  GuildList: TGuildList;
  Guildsys: TGuildsys; //等级配置表
implementation

uses
  SVMain, FSockets, Math, uBillboardcharts;

////////////////////////////////////////////////////
//
//             ===  GuildObject  ===
//
////////////////////////////////////////////////////

procedure TGuildObject.onGuildLifdadd(var temp: TLifeDataListdata);
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_Lifedata_add);

  WordComData_ADDdword(tempsend, temp.rid);
  WordComData_ADDdword(tempsend, temp.rendtime - temp.rstarttime);
  WordComData_ADDstring(tempsend, temp.name);
  copymemory(@tempsend.data[tempsend.Size], @temp.LifeData, sizeof(TLifeData));
  tempsend.Size := tempsend.Size + sizeof(TLifeData);
  UserList.GuildSendData(GuildName, tempsend);
end;

procedure TGuildObject.onGuildLifddel(var temp: TLifeDataListdata);
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_Lifedata_del);

  WordComData_ADDdword(tempsend, temp.rid);
  UserList.GuildSendData(GuildName, tempsend);
end;

procedure TGuildObject.onGuildLifdUPdate(var temp: TLifeDataListdata);
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_Lifedata_update);

  WordComData_ADDdword(tempsend, temp.rid);
  WordComData_ADDdword(tempsend, temp.rendtime - temp.rstarttime);
  WordComData_ADDstring(tempsend, temp.name);
  copymemory(@tempsend.data[tempsend.Size], @temp.LifeData, sizeof(TLifeData));
  tempsend.Size := tempsend.Size + sizeof(TLifeData);
  UserList.GuildSendData(GuildName, tempsend);
end;

procedure TGuildObject.onGuildLifdClear();
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_Lifedata_Clear);

  UserList.GuildSendData(GuildName, tempsend);
end;

procedure TGuildObject.onGuildLifdSetUPdate();
begin
    //使用 被动方式
end;

constructor TGuildObject.Create;
begin
  inherited Create;
  LifeDataList := TLifeDataList.Create;
  ADDMsgList := TResponsion.Create; //加人  等待 应答 列表
  ADDALLYMsgList := TResponsion.Create; //同盟  等待 应答 列表
  FGuildName := '';

  FWarAlarmStr := '';
  FWarAlarmTick := 0;
  FWarAlarmStartTick := 0;

  FillChar(SelfData, SizeOf(TCreateGuildData), 0);

  GuildNpcList := TList.Create;
  DieGuildNpcList := TList.Create;
  GuildUserList := TGuildUserList.Create;

  LifeDataList.ONadd := onGuildLifdadd;
  LifeDataList.ONdel := onGuildLifddel;
  LifeDataList.ONUPdate := onGuildLifdUPdate;
  LifeDataList.ONClear := onGuildLifdClear;
  LifeDataList.onLifedataUPdate := onGuildLifdSetUPdate;
end;

destructor TGuildObject.Destroy;
begin
  LifeDataList.Free;
  Clear;
  GuildUserList.Free;
  GuildNpcList.Free;
  DieGuildNpcList.Free;
  ADDMsgList.Free;
  ADDALLYMsgList.Free;
  inherited Destroy;
end;

procedure TGuildObject.Clear;
var
  i: Integer;
  GuildNpc: TGuildNpc;
begin
  for i := 0 to DieGuildNpcList.Count - 1 do
  begin
    GuildNpc := DieGuildNpcList.Items[i];
    GuildNpc.Free;
  end;
  DieGuildNpcList.Clear;

  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    GuildNpc.EndProcess;
    GuildNpc.Free;
  end;
  GuildNpcList.Clear;
  GuildUserList.Clear;
end;

function TGuildObject.GetSelfData: PTCreateGuildData;
begin
  Result := @SelfData;
end;

function TGuildObject.GetInformation: string;
var
  i: Integer;
  Str: string;
begin
  Result := '';

  Str := format('<%s门派信息> ', [GuildName]) + #13;
  Str := Str + format('门主: %s', [SelfData.Sysop]) + #13;
  for i := 0 to 3 - 1 do
  begin
    Str := Str + format('副门主%d: %s', [i + 1, SelfData.SubSysop[i]]) + #13;
  end;
  Str := Str + format('位置: %d,%d', [BasicData.X, BasicData.Y]) + #13;
  Str := Str + format('耐久度:%d', [SelfData.Durability]) + #13;
  Str := Str + format('门派武功: %s　修炼值：%d', [SelfData.GuildMagic, SelfData.MagicExp]) + #13;
  for i := 0 to 5 - 1 do
  begin
    Str := Str + format('%s : %d,%d', [SelfData.GuildNpc[i].rName, SelfData.GuildNpc[i].rX, SelfData.GuildNpc[i].rY]) + #13;
  end;

  Result := Str;
end;

function TGuildObject.GetGuildMagicString: string;
begin
  Result := SelfData.GuildMagic;
end;     

procedure TGuildObject.DelGuildMagicString;
begin
  SelfData.GuildMagic := '';
end;

procedure TGuildObject.AddGuildMagic(aMagicName: string);
var
  GuildNpc: TGuildNpc;
begin
  GuildNpc := nil;
  SelfData.GuildMagic := aMagicName;
  SelfData.MagicExp := 100;
  if GuildNpcList.Count > 0 then
  begin
    GuildNpc := GuildNpcList.Items[0];
  end else if DieGuildNpcList.Count > 0 then
  begin
    GuildNpc := DieGuildNpcList.Items[0];
  end;
  if GuildNpc <> nil then
  begin
    GuildNpc.boMagicNpc := true;
    GuildNpc.BasicData.Guild := SelfData.GuildMagic;
    MagicClass.GetMagicData(SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
    GuildNpc.BocChangeProperty;
  end;
end;

function TGuildObject.IsGuildUser(aName: string): boolean;
begin
  Result := GuildUserList.IsGuildUser(aName);
end;

function TGuildObject.IsGuildSysop(aName: string): Boolean;
begin
  Result := false;
  if SelfData.Sysop = aName then Result := true;
end;

function TGuildObject.GetGuildSysop: string;
begin
  Result := SelfData.Sysop;
end;

function TGuildObject.IsGuildSubSysop(aName: string): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to 3 - 1 do
  begin
    if SelfData.SubSysop[i] = aName then
    begin
      Result := true;
      exit;
    end;
  end;
end;

function TGuildObject.IsGuildALLYList(aGuildName: string): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := 0 to MAX_ALLYGUILD_COUNT - 1 do
  begin
    if SelfData.AllyGuild[i] = aGuildName then
    begin
      Result := true;
      exit;
    end;
  end;
end;

function TGuildObject.GetGuildALLYNum: Integer;
var
  i, j: Integer;
begin
  j := 0;
  for i := 0 to MAX_ALLYGUILD_COUNT - 1 do
  begin
    if SelfData.AllyGuild[i] <> '' then
      Inc(j);
  end;
  Result := j;
end;

function TGuildObject.AddGuildALLYList(aGuildName: string): Boolean;
var
  i, j: Integer;
begin
  Result := false;
  for i := 0 to MAX_ALLYGUILD_COUNT - 1 do
  begin
    if SelfData.AllyGuild[i] = '' then
    begin
      SelfData.AllyGuild[i] := aGuildName;
      Result := true;
      Exit;
    end;
  end;
end;

function TGuildObject.DelGuildALLYList(aGuildName: string): Boolean;
var
  i, j: Integer;
begin
  Result := false;
  for i := 0 to MAX_ALLYGUILD_COUNT - 1 do
  begin
    if SelfData.AllyGuild[i] = aGuildName then
    begin
      SelfData.AllyGuild[i] := '';
      Result := true;
      Exit;
    end;
  end;
end;


function TGuildObject.IsGuildNpc(aName: string): Boolean;
var
  i: Integer;
  GuildNpc: TGuildNpc;
begin
  Result := false;

  if aName = '' then exit;

  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    if GuildNpc.GuildNpcName = aName then
    begin
      Result := true;
      exit;
    end;
  end;
  for i := 0 to DieGuildNpcList.Count - 1 do
  begin
    GuildNpc := DieGuildNpcList.Items[i];
    if GuildNpc.GuildNpcName = aName then
    begin
      Result := true;
      exit;
    end;
  end;
end;

procedure TGuildObject.SaveToFile;
var
  i, j, nIndex: Integer;
  GuildNpc: TGuildNpc;
begin
  if SelfData.Name = '' then exit;

  FillChar(SelfData.GuildNpc, SizeOf(SelfData.GuildNpc), 0);
  nIndex := 0;
  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    if GuildNpc.boMagicNpc = true then
    begin
      SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
      SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
      SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
      SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
      SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
      Inc(nIndex);
    end;
  end;
  for i := 0 to DieGuildNpcList.Count - 1 do
  begin
    GuildNpc := DieGuildNpcList.Items[i];
    if GuildNpc.boMagicNpc = true then
    begin
      SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
      SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
      SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
      SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
      SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
      Inc(nIndex);
    end;
  end;

  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    if GuildNpc.boMagicNpc = false then
    begin
      SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
      SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
      SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
      SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
      Inc(nIndex);
    end;
  end;
  for i := 0 to DieGuildNpcList.Count - 1 do
  begin
    GuildNpc := DieGuildNpcList.Items[i];
    if GuildNpc.boMagicNpc = false then
    begin
      SelfData.MagicExp := GuildNpc.GuildMagicData.rSkillExp;
      SelfData.GuildNpc[nIndex].rName := GuildNpc.GuildNpcName;
      SelfData.GuildNpc[nIndex].rX := GuildNpc.StartX;
      SelfData.GuildNpc[nIndex].rY := GuildNpc.StartY;
      SelfData.GuildNpc[nIndex].rSex := GuildNpc.Sex;
      Inc(nIndex);
    end;
  end;

  GuildUserList.SaveToFile('.\Guild\' + SelfData.Name + 'GUser.sdb');
end;

procedure TGuildObject.LoadFromFile;
begin
  if not FileExists('.\Guild\' + SelfData.Name + 'GUser.SDB') then exit;

  GuildUserList.LoadFromFile('.\Guild\' + SelfData.Name + 'GUser.sdb');
end;

function TGuildObject.GetUserGrade(uName: string): string;
var
  i: Integer;
begin
    {if SelfData.Durability < SelfData.MaxDurability + 100000 then
    begin
        // if uName = SelfData.Sysop then Inc(SelfData.Durability, ADD_GUILD_DURA_BY_SYSOP);
        for i := 0 to MAX_SUBSYSOP_COUNT - 1 do
        begin
            if uName = SelfData.SubSysop[i] then Inc(SelfData.Durability, ADD_GUILD_DURA_BY_SUBSYSOP);
        end;
        SelfData.Durability := SelfData.MaxDurability;
    end;
    }
  Result := GuildUserList.GetGradeName(uName);
end;

procedure TGuildObject.GetGuildInfo(aUser: TUser);
var
  i: Integer;
  tmpStr, Sep: string;
begin
  tmpStr := SelfData.Name + ' 坐标: ' + IntToStr(BasicData.X) + ',' + IntToStr(BasicData.Y);
  aUser.SendClass.SendChatMessage('门派名称: ' + tmpStr + '  耐久度：' + inttostr(SelfData.Durability) + '/'
    + inttostr(SelfData.MaxDurability) + ' 门主: ' + SelfData.Sysop, SAY_COLOR_NORMAL);
  //  aUser.SendClass.SendChatMessage('门主:' + SelfData.Sysop, SAY_COLOR_NORMAL);

  tmpStr := '';
  Sep := '';
  for i := 0 to MAX_SUBSYSOP_COUNT - 1 do
  begin
    if SelfData.SubSysop[i] <> '' then
    begin
      tmpStr := tmpStr + Sep + SelfData.SubSysop[i];
      Sep := ', ';
    end;
  end;
  if tmpstr <> '' then
  begin
    tmpstr := '副门主: ' + tmpstr;
    aUser.SendClass.SendChatMessage(tmpStr, SAY_COLOR_NORMAL);
  end;
  tmpStr := '';
  Sep := '';
  for i := 0 to MAX_ALLYGUILD_COUNT - 1 do
  begin
    if SelfData.AllyGuild[i] <> '' then
    begin
      tmpStr := tmpStr + Sep + SelfData.AllyGuild[i];
      Sep := ', ';
    end;
  end;
  if tmpstr <> '' then
  begin
    tmpstr := '同盟: ' + tmpstr;
    aUser.SendClass.SendChatMessage(tmpStr, SAY_COLOR_NORMAL);
  end;
end;

procedure TGuildObject.SendMsgOnlise(auserId: integer);
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_online);
  WordComData_ADDdword(tempsend, auserId);

  UserList.GuildSendData(GuildName, tempsend);
end;

procedure TGuildObject.SendLevel();
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_Level);
  WordComData_ADDdword(tempsend, SelfData.FguildLeve);
  WordComData_ADDdword(tempsend, SelfData.FguildMaxNum);

  UserList.GuildSendData(GuildName, tempsend);
end;

procedure TGuildObject.SendMsgGameExit(auserId: integer);
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_GameExit);
  WordComData_ADDdword(tempsend, auserId);

  UserList.GuildSendData(GuildName, tempsend);
end;
//权利 变化

procedure TGuildObject.SendMsgSubSysop(aUserName: string);
var
  tempsend: TWordComData;
  p: PTGuildUserData;

begin
  p := GuildUserList.GetName(aUserName);
  if p = nil then exit;
  if IsGuildSubSysop(aUserName) then
  begin
    p.rjob := GUILD_job_SubSysop;
  end
  else if IsGuildSysop(aUserName) then
  begin
    p.rjob := GUILD_job_Sysop;
  end
  else
  begin
    p.rjob := GUILD_job_None;
  end;
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_SubSysop);
  WordComData_ADDdword(tempsend, p.rid);
  WordComData_ADDdword(tempsend, p.rjob);

  UserList.GuildSendData(GuildName, tempsend);
end;

function TGuildObject.SETonLine(aUser: TUser): boolean; //上线
var
  p: PTGuildUserData;
begin
  result := false;
  p := GuildUserList.GetName(auser.name);
  if p = nil then exit;
  result := true;
  p.ronline := true;

  p.rage := auser.GetAge;
  p.rEnergy := aUser.getcEnergy;
  p.rGuildPoint := aUser.getGuildPoint;
  if IsGuildSysop(p.rName) then p.rjob := 1
  else if IsGuildSubSysop(p.rName) then p.rjob := 2
  else p.rjob := 0;

  GetGuildInfoFrom(auser); //给自己发 门派 列表
  SendMsgOnlise(p.rid); //通知所有人
  auser.BocChangeProperty;
    //门派战争 状态
  //aUser.SendClass.SendGulidKillstate(GuildList.Killstate);
    {    if GuildList.Killstate then
            aUser.SendClass.SendChatMessage('【门派进入攻击状态】', SAY_COLOR_NORMAL)
        else
            aUser.SendClass.SendChatMessage('【门派禁止攻击状态】', SAY_COLOR_NORMAL);}
end;

procedure TGuildObject.SETGameExit(aUser: TUser);
var
  p: PTGuildUserData;
begin
  p := GuildUserList.GetName(auser.name);
  if p = nil then exit;
  p.ronline := false;
  SendMsgGameExit(p.rid); //通知所有人
end;

function TGuildObject.AddUser(asysname, aUserName: string): string;
var
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
  systuser, destuser: Tuser;

begin
  result := '';
  if (IsGuildSysop(asysname) = false)
    and (IsGuildSubSysop(asysname) = false) then
  begin
    result := (format('%s 不是门主或者副门主。', [asysname]));
    exit;
  end;
  if GuildUserList.count >= SelfData.FguildMaxNum then
  begin
    result := '门派满员';
    exit;
  end;

  systuser := UserList.GetUserPointer(asysname);
  if systuser = nil then exit;

  //destuser := UserList.GetUserPointer(aUserName); // GetViewObjectByName(aUserName, RACE_HUMAN);
  destuser := tuser(systuser.GetViewObjectByName(aUserName, RACE_HUMAN));
  if destuser = nil then
  begin
    result := (format('%s不在可视范围内。', [aUserName]));
    exit;
  end
  else
  begin
    if not destuser.GuildJoin then
    begin
      Result := (format('%s拒绝加入门派', [aUserName]));
      Exit;
    end;
  end;

  if IsGuildUser(aUserName) then
  begin
    result := (format('%s已被加入过', [aUserName]));
    exit;
  end;
  if destuser.GuildName <> '' then
  begin
    result := (format('%s是别的门派', [aUserName]));
    exit;
  end;

  result := (format('等待 %s 应答。', [aUserName]));

  ADDMsgList.addPointer(aUserName, asysname, destuser, userlist.GetUserPointer(asysname));

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_addMsg);
  WordComData_ADDstring(tempsend, GuildName);
  WordComData_ADDstring(tempsend, asysname);

  destuser.SendClass.SendData(tempsend);

end;

function TGuildObject.AddALLYMsg(aUserName, aGuildName: string): string;
var
  tempstr: string;
  TempUser: Tuser;
  tempsend: TWordComData;
begin
  result := '';
  //判断是否接受请求
  if GetAddAllyGuild = false then
  begin
    result := GuildName + '门派设定拒绝同盟请求.';
    exit;
  end;
   //判断门主是否在线
  tempstr := GetGuildSysop;
  TempUser := UserList.GetUserPointer(tempstr);
  if TempUser = nil then
  begin
    result := GuildName + '门主不在线上。';
    exit;
  end;

  result := (format('等待 %s 门主应答。', [GuildName]));
  //添加同盟列表 被请求角色 请求角色 被请求 TempUser
  ADDALLYMsgList.addPointer(tempstr, aUserName, TempUser, userlist.GetUserPointer(aUserName));

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_addALLYMsg);
  WordComData_ADDstring(tempsend, GuildName); //被请求门派
  WordComData_ADDstring(tempsend, aGuildName); //请求门派

  TempUser.SendClass.SendData(tempsend);
end;

function TGuildObject.DelALLYMsg(aGuildName: string): string;
var
  tempstr: string;
  TempUser: Tuser;
  tempGuildObject: TGuildObject;
begin
  result := '';
  //判断对方是否自己同盟
  if IsGuildALLYList(aGuildName) = False then
  begin
    result := GuildName + '不是同盟门派';
    exit;
  end;
  //取消同盟
  if DelGuildALLYList(aGuildName) = True then
    result := (format('与【%s】门派取消同盟关系成功。', [aGuildName]))
  else
    result := (format('与【%s】门派取消同盟关系失败。', [aGuildName]));
  //获取对方门派对象
  tempGuildObject := GuildList.GetGuildObject(aGuildName); //获取邀请门派对象
  if tempGuildObject <> nil then
  begin
     //对方取消自己门派同盟
    tempGuildObject.DelGuildALLYList(GuildName)
  end;
end;

//同盟说话

procedure TGuildObject.AllyGuildSay(aStr: string; COLOR: integer = SAY_COLOR_NORMAL);
var
  bo: boolean;
  i: Integer;
begin
  bo := False;
  //循环同盟门派说话
  for i := 0 to MAX_ALLYGUILD_COUNT - 1 do
  begin
    if SelfData.AllyGuild[i] <> '' then
    begin
      UserList.GuildSay(SelfData.AllyGuild[i], aStr, COLOR);
      bo := true;
    end;
  end;
  //自己门派内说话
  if bo then
    UserList.GuildSay(GuildName, aStr, COLOR);
end;



procedure TGuildObject.SendMsgHit();
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_hit);
  WordComData_ADDDWORD(tempsend, SelfData.Durability);
  UserList.GuildSendData(GuildName, tempsend);

end;

procedure TGuildObject.AddUserMsgOK(aUser: tuser);
var
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
  pp: pTResponsiondata;
  procedure _sendsay(astr: string);
  begin
    if pp <> nil then
      if pp.rSource <> nil then
        tuser(pp.rSource).SendClass.SendChatMessage(astr, SAY_COLOR_SYSTEM);
  end;
begin
  pp := ADDMsgList.Get(aUser.name);
  if pp = nil then
  begin
    aUser.SendClass.SendChatMessage('应答过期', SAY_COLOR_SYSTEM);
    exit;
  end;

  if aUser.GuildName = SelfData.Name then
  begin
    _sendsay(format('%s已被加入过', [aUser.name]));
    exit;
  end;
  if aUser.GuildName <> '' then
  begin
    _sendsay(format('%s是别的门派', [aUser.name]));
    exit;
  end;

  if GuildUserList.GetName(auser.name) = nil then
  begin
    GuildUserList.AddUser(auser.BasicData.id, auser.name);
  end;

  begin
    auser.GuildSet(self);
    auser.BocChangeProperty;
  end;

  tempPTGuildUserData := GuildUserList.GetName(auser.name);

  if tempPTGuildUserData = nil then
  begin
    _sendsay(format('%s 加入失败！', [aUser.name]));

    exit;
  end;
    // BocSay(format('加入了%s', [auser.name]));

  aUser.SendClass.SendChatMessage(format('你成功加入 %s', [GuildName]), SAY_COLOR_SYSTEM);
  //保存数据 2015.11.17修改
  SaveToFile;
  //触发脚本
  aUser.CallLuaScriptFunction('OnAddGuild', [integer(aUser), GuildName]);

  //if Self.uGuildObject <> nil then
  //CallScriptFunction('OnGuildUpdate', [integer(self), Integer(Self.uGuildObject), GUILD_list_addMsgOk, self.getGuildPoint, Self.name])
  //else
  //CallScriptFunction('OnGuildUpdate', [integer(self), -1, GUILD_list_addMsgOk, self.getGuildPoint, Self.name]);

  GetGuildInfoFrom(auser); //给自己发 门派 列表
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_add);
  if IsGuildSysop(tempPTGuildUserData.rName) then tempPTGuildUserData.rjob := 1
  else if IsGuildSubSysop(tempPTGuildUserData.rName) then tempPTGuildUserData.rjob := 2
  else tempPTGuildUserData.rjob := 0;

  WordComData_ADDdword(tempsend, tempPTGuildUserData.rid); //ID
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rLastDay); //持续天
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rage); //年龄
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rjob); //职位
  WordComData_ADDbyte(tempsend, byte(tempPTGuildUserData.ronline)); //在线

  WordComData_ADDString(tempsend, tempPTGuildUserData.rName); //名字
  WordComData_ADDString(tempsend, tempPTGuildUserData.rGradeName); //封号
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rEnergy); //元气
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rGuildPoint); //贡献
  UserList.GuildSendData(GuildName, tempsend);
  //  SaveToFile;
end;

procedure TGuildObject.AddUserScript(aUserName: string);
var
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
  aUser: tuser;
begin

  aUser := UserList.GetUserPointer(aUserName); //获取邀请对象
  if aUser = nil then
  begin
    exit;
  end;

  if GuildUserList.GetName(auser.name) = nil then
  begin
    GuildUserList.AddUser(auser.BasicData.id, auser.name);
  end;

  begin
    auser.GuildSet(self);
    auser.BocChangeProperty;
  end;

  tempPTGuildUserData := GuildUserList.GetName(auser.name);
  if tempPTGuildUserData = nil then
  begin
    aUser.SendClass.SendChatMessage(format('%s 加入失败！', [aUser.name]), SAY_COLOR_SYSTEM);
    exit;
  end;

  GetGuildInfoFrom(auser); //给自己发 门派 列表
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_add);
  if IsGuildSysop(tempPTGuildUserData.rName) then tempPTGuildUserData.rjob := 1
  else if IsGuildSubSysop(tempPTGuildUserData.rName) then tempPTGuildUserData.rjob := 2
  else tempPTGuildUserData.rjob := 0;

  WordComData_ADDdword(tempsend, tempPTGuildUserData.rid); //ID
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rLastDay); //持续天
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rage); //年龄
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rjob); //职位
  WordComData_ADDbyte(tempsend, byte(tempPTGuildUserData.ronline)); //在线

  WordComData_ADDString(tempsend, tempPTGuildUserData.rName); //名字
  WordComData_ADDString(tempsend, tempPTGuildUserData.rGradeName); //封号
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rEnergy); //元气
  WordComData_ADDdword(tempsend, tempPTGuildUserData.rGuildPoint); //贡献
  UserList.GuildSendData(GuildName, tempsend);
  //  SaveToFile;
end;
//处理同意同盟
//aUser 被邀请门派门主
//TGuildObject 被邀请门派

procedure TGuildObject.addALLYMsgOk(aUser: tuser);
var
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
  pp: pTResponsiondata;
  tempGuildObject: TGuildObject;
  tempuser: tuser;
  procedure _sendsay(astr: string);
  begin
    if pp <> nil then
      if pp.rSource <> nil then
        tuser(pp.rSource).SendClass.SendChatMessage(astr, SAY_COLOR_SYSTEM);
  end;
begin
  if aUser.GuildName = '' then
    exit;
  pp := ADDALLYMsgList.Get(aUser.name);
  if pp = nil then
  begin
    aUser.SendClass.SendChatMessage('应答过期', SAY_COLOR_SYSTEM);
    exit;
  end;
  tempuser := UserList.GetUserPointer(pp.rSourceName); //获取邀请对象
  if tempuser = nil then
  begin
    aUser.SendClass.SendChatMessage('对方门主不在线.', SAY_COLOR_SYSTEM);
    exit;
  end;
  //获取邀请对象门派
  tempGuildObject := GuildList.GetGuildObject(tempuser.GuildName); //获取邀请门派对象
  if tempGuildObject = nil then
  begin
    aUser.SendClass.SendChatMessage('对方门派不存在.', SAY_COLOR_SYSTEM);
    exit;
  end;
  //判断是否重复同盟
  if IsGuildALLYList(tempuser.GuildName) = True then
  begin
    _sendsay(format('【%s】门派已经是同盟.', [tempuser.GuildName]));
    exit;
  end;
  //检测自己同盟数量
  if GetGuildALLYNum >= MAX_ALLYGUILD_COUNT then
  begin
    _sendsay(format('【%s】门派同盟数量已满.', [GuildName]));
    exit;
  end;
  //检测邀请对象门派同盟数量
  if tempGuildObject.GetGuildALLYNum >= MAX_ALLYGUILD_COUNT then
  begin
    aUser.SendClass.SendChatMessage(format('【%s】门派同盟数量已满.', [tempGuildObject.GuildName]), SAY_COLOR_SYSTEM);
    exit;
  end;

  //自己门派 添加对方
  if AddGuildALLYList(tempGuildObject.GuildName) = False then
  begin
    aUser.SendClass.SendChatMessage(format('与【%s】门派同盟失败,对方可能同盟数量已满!', [tempGuildObject.GuildName]), SAY_COLOR_SYSTEM);
    exit;
  end;
  //对方门派 添加自己
  if tempGuildObject.AddGuildALLYList(GuildName) = False then
  begin
    _sendsay(format('与【%s】门派同盟失败,对方可能同盟数量已满!', [GuildName]));
    exit;
  end;
  //发对象消息
  _sendsay(format('与【%s】门派同盟成功!', [GuildName]));
  //发自己消息
  aUser.SendClass.SendChatMessage(format('与【%s】门派同盟成功!', [tempGuildObject.GuildName]), SAY_COLOR_SYSTEM);
end;

procedure TGuildObject.AddUserMsgNo(auser: tuser);
var

  pp: pTResponsiondata;
  procedure _sendsay(astr: string);
  begin
    if pp <> nil then
      if pp.rSource <> nil then
        tuser(pp.rSource).SendClass.SendChatMessage(astr, SAY_COLOR_SYSTEM);
  end;

begin
  pp := ADDMsgList.Get(aUser.name);
  if pp = nil then exit;

  _sendsay(format('%s 拒绝了加人。', [aUser.name]));
  ADDMsgList.del(aUser.name);
  exit;

end;

procedure TGuildObject.addALLYMsgNo(auser: tuser);
var

  pp: pTResponsiondata;
  procedure _sendsay(astr: string);
  begin
    if pp <> nil then
      if pp.rSource <> nil then
        tuser(pp.rSource).SendClass.SendChatMessage(astr, SAY_COLOR_SYSTEM);
  end;

begin
  pp := ADDALLYMsgList.Get(aUser.name);
  if pp = nil then exit;

  _sendsay(format('%s 拒绝了同盟请求。', [aUser.GuildName]));
  ADDALLYMsgList.del(aUser.name);
  exit;

end;


function TGuildObject.DelUser(aUserName: string): string; //自己离开门派
var
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
  auserId: integer;
  bo: TBasicObject;
  tmpUser: Tuser;
begin
  result := '';
  tempPTGuildUserData := GuildUserList.GetName(aUserName);
  if tempPTGuildUserData = nil then
  begin
    result := (format('%s 还没加入。', [aUserName]));
    exit;
  end;
  if IsGuildSysop(aUserName) then
  begin
    result := (format('%s 是门主不能脱离。', [aUserName]));
    exit;
  end;
  if IsGuildSubSysop(aUserName) then
  begin
    result := (format('%s 是副门主不能脱离。', [aUserName]));
    exit;
  end;
  auserId := tempPTGuildUserData.rid;
  if GuildUserList.DelUser(aUserName) then
  begin
    result := (format('%s 已脱离门派。', [aUserName]));
  end;

  tmpUser := UserList.GetUserPointer(aUserName);
  if tmpUser <> nil then
  begin
    if tmpUser.GuildName = GuildName then
    begin
      tmpUser.GuildDel;
      tmpUser.BocChangeProperty;
    end;
  end;

  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_del);
  WordComData_ADDdword(tempsend, auserId);

  UserList.GuildSendData(GuildName, tempsend); //发送 给所有人
  if tmpUser <> nil then tmpUser.SendClass.SendData(tempsend); //发送 给自己

  if tmpUser <> nil then
    tmpUser.CallLuaScriptFunction('OnExitGuild', [integer(tmpUser), GuildName]);

  //保存数据 2015.11.17修改
  SaveToFile;
end;

function TGuildObject.SetGradeName(asysname, aUserName, aGradeName: string): string;
var
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
  auserId: integer;
  tmpUser: Tuser;
begin

  if IsHZ(aGradeName) = false then // if isFullHangul(aGradeName) = false then
  begin
    result := '有特殊字符，不合法！';
    exit;
  end;
  result := '';
  if (IsGuildSysop(asysname) = false)
    and (IsGuildSubSysop(asysname) = false) then
  begin
    result := (format('%s 不是门主或者副门主。', [asysname]));
    exit;
  end;
  tempPTGuildUserData := GuildUserList.GetName(aUserName);
  if tempPTGuildUserData = nil then
  begin
    BocSay(format('%s 还没加入。', [aUserName]));
    exit;
  end;
  auserId := tempPTGuildUserData.rid;
  if length(aGradeName) > 12 then
    aGradeName := copy(aGradeName, 1, 12);
  GuildUserList.SetGradeName(aUserName, aGradeName);
  begin
    BocSay(format('%s 获得职称%s。', [aUserName, aGradeName]));

  end;
  tmpUser := UserList.GetUserPointer(aUserName);
  if tmpUser <> nil then
  begin
    if tmpUser.GuildName = GuildName then
    begin
      tmpUser.GuildGrade := aGradeName;
      tmpUser.BocChangeProperty;
    end;
  end;

  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_GradeNameUPDATE);
  WordComData_ADDdword(tempsend, auserId);
  WordComData_ADDString(tempsend, aGradeName);

  UserList.GuildSendData(GuildName, tempsend);
end;

procedure TGuildObject.DelUser_ForceAll();

begin

  UserList.GuildSendDelAll(GuildName);
end;

function TGuildObject.DelUser_Force(asysname, aUserName: string): string;
var
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
  auserId: integer;
  tmpUser, sysUser: Tuser;
begin
  result := '';

  if (IsGuildSysop(asysname) = false)
    and (IsGuildSubSysop(asysname) = false) then
  begin
    result := (format('%s 不是门主或者副门主。', [asysname]));
    exit;
  end;

  tempPTGuildUserData := GuildUserList.GetName(aUserName);
  if tempPTGuildUserData = nil then
  begin
    result := (format('%s 还没加入。', [aUserName]));
    exit;
  end;
  if IsGuildSysop(aUserName) then
  begin
    result := (format('%s 是门主不能踢出。', [aUserName]));
    exit;
  end;
  if IsGuildSubSysop(aUserName) then
  begin
    result := (format('%s 是副门主不能踢出。', [aUserName]));
    exit;
  end;
  auserId := tempPTGuildUserData.rid;
  if GuildUserList.DelUser(aUserName) then
  begin
    result := (format('%s 已踢出门派。', [aUserName]));
  end;

  tmpUser := UserList.GetUserPointer(aUserName);
  if tmpUser <> nil then
  begin
    if tmpUser.GuildName = GuildName then
    begin
      tmpUser.GuildDel;
      tmpUser.BocChangeProperty;
    end;
  end;

  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_ForceDel);
  WordComData_ADDdword(tempsend, auserId);
  if tmpUser <> nil then
    tmpUser.SendClass.SendData(tempsend);
  UserList.GuildSendData(GuildName, tempsend);



  sysUser := UserList.GetUserPointer(asysname);
  if sysUser <> nil then
    sysUser.CallLuaScriptFunction('OnDelGuild', [integer(sysUser), GuildName, aUserName, tempPTGuildUserData.rGuildPoint]);
  //保存数据 2015.11.17修改
  SaveToFile;
end;

procedure TGuildObject.GetGuildInfoFROM(aUser: TUser);
var
  i, i2, j, maxnum, zcount: Integer;
  tempsend: TWordComData;
  tempPTGuildUserData: PTGuildUserData;
begin
  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_head);

  WordComData_ADDString(tempsend, SelfData.Name); //加入 门派名字
  WordComData_ADDbyte(tempsend, level); //门派 等级
  WordComData_ADDbyte(tempsend, SelfData.FguildMaxNum); //门派 最大人数
  WordComData_ADDString(tempsend, FGuildnotice); //门派 公告
  WordComData_ADDDWORD(tempsend, SelfData.Durability); //当前血量
  WordComData_ADDDWORD(tempsend, SelfData.MaxDurability); //最大血量
    //14.11.23新增
  WordComData_ADDDWORD(tempsend, SelfData.x);
  WordComData_ADDDWORD(tempsend, SelfData.y); //门派坐标
  WordComData_ADDString(tempsend, SelfData.GuildMagic); //门派武功
  WordComData_ADDString(tempsend, SelfData.MakeDate); //创建日期
  WordComData_ADDDWORD(tempsend, SelfData.rEnegy); //积分？
  WordComData_ADDDWORD(tempsend, SelfData.rMaxEnegy); //升级积分
  WordComData_ADDString(tempsend, SelfData.Sysop); //门主

  aUser.SendClass.SendData(tempsend);
    //头部
  i := GuildUserList.count;
  if i = 0 then i := 0;
  zcount := i div 50;
  if (i mod 50) > 0 then zcount := zcount + 1;
  for j := 0 to zcount - 1 do
  begin

    maxnum := GuildUserList.Count - (j * 50);
    if maxnum > 50 then maxnum := 50;
    if maxnum <= 0 then exit;
    tempsend.Size := 0;
    WordComData_ADDbyte(tempsend, SM_GUILD);
    WordComData_ADDbyte(tempsend, GUILD_list);
    WordComData_ADDword(tempsend, maxnum); //数量
    for i2 := 0 to maxnum - 1 do
    begin
      i := i2 + j * 50;
      if i >= GuildUserList.Count then Break;
      tempPTGuildUserData := GuildUserList.Getindex(i);

      if tempPTGuildUserData = nil then Continue;

      if IsGuildSysop(tempPTGuildUserData.rName) then tempPTGuildUserData.rjob := 1
      else if IsGuildSubSysop(tempPTGuildUserData.rName) then tempPTGuildUserData.rjob := 2
      else tempPTGuildUserData.rjob := 0;

      WordComData_ADDdword(tempsend, tempPTGuildUserData.rid); //ID
      WordComData_ADDdword(tempsend, tempPTGuildUserData.rLastDay); //持续天
      WordComData_ADDdword(tempsend, tempPTGuildUserData.rage); //年龄
      WordComData_ADDdword(tempsend, tempPTGuildUserData.rjob); //职位
      WordComData_ADDbyte(tempsend, byte(tempPTGuildUserData.ronline)); //在线

      WordComData_ADDString(tempsend, tempPTGuildUserData.rName); //名字
      WordComData_ADDString(tempsend, tempPTGuildUserData.rGradeName); //封号
      WordComData_ADDdword(tempsend, tempPTGuildUserData.rEnergy); //元气
      WordComData_ADDdword(tempsend, tempPTGuildUserData.rGuildPoint); //贡献
    end;
    aUser.SendClass.SendData(tempsend);
  end;
end;

function TGuildObject.AddGuildNpc(aName: string; ax, ay: integer; aSex: Byte): Boolean;
var
  i: integer;
  GuildNpc: TGuildNpc;
begin
  Result := FALSE;

  if GetGuildNpcByName(aName) <> -1 then exit;
  if aSex <> 2 then aSex := 1;

  for i := 0 to MAX_GUILDNPC_COUNT - 1 do
  begin
    if SelfData.GuildNpc[i].rName = '' then
    begin
      SelfData.GuildNpc[i].rName := aName;
      SelfData.GuildNpc[i].rX := aX;
      SelfData.GuildNpc[i].rY := aY;
      SelfData.GuildNpc[i].rSex := aSex;

      GuildNpc := TGuildNpc.Create;
      GuildNpc.SetManagerClass(Manager);

      GuildNpc.Initial(Self, aName, aX, aY, aSex);

      if (SelfData.GuildMagic <> '') and (boAddGuildMagic = false) then
      begin
        GuildNpc.boMagicNpc := true;
        GuildNpc.BasicData.Guild := SelfData.GuildMagic;
        MagicClass.GetMagicData(SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
        boAddGuildMagic := true;
      end;
      DieGuildNpcList.Add(GuildNpc);

      Result := TRUE;
      exit;
    end;
  end;
end;

function TGuildObject.delSubSysop(sayer, objectname: string): string;
begin
  result := '';
  if (IsGuildSysop(sayer) = false) then
  begin
    result := ('你不是『门主』。');
    exit;
  end;
  if (IsGuildSysop(objectname)) then
  begin
    result := (format('%s是『门主』不能删除权利。', [objectname]));
    exit;
  end;
  if (IsGuildSubSysop(objectname) = false) then
  begin
    result := (format('%s不是『副门主』。', [objectname]));
    exit;
  end;

  if SelfData.SubSysop[0] = objectname then
  begin
    SelfData.SubSysop[0] := '';
    SendMsgSubSysop(objectname);
    exit;
  end;
  if SelfData.SubSysop[1] = objectname then
  begin
    SelfData.SubSysop[1] := '';
    SendMsgSubSysop(objectname);
    exit;
  end;
  if SelfData.SubSysop[2] = objectname then
  begin
    SelfData.SubSysop[2] := '';
    SendMsgSubSysop(objectname);
    exit;
  end;

end;


function TGuildObject.delSubSysop_ic(sayer: string): string;
begin
  result := '';
  if (IsGuildSysop(sayer) = TRUE) then
  begin
    result := ('『门主』不能删除自己权利');
    exit;
  end;

  if (IsGuildSubSysop(sayer) = false) then
  begin
    result := (format('%s不是『副门主』。', [sayer]));
    exit;
  end;

  if SelfData.SubSysop[0] = sayer then
  begin
    SelfData.SubSysop[0] := '';
    SendMsgSubSysop(sayer);
    exit;
  end;
  if SelfData.SubSysop[1] = sayer then
  begin
    SelfData.SubSysop[1] := '';
    SendMsgSubSysop(sayer);
    exit;
  end;
  if SelfData.SubSysop[2] = sayer then
  begin
    SelfData.SubSysop[2] := '';
    SendMsgSubSysop(sayer);
    exit;
  end;
end;

function TGuildObject.setSubSysop(sayer, objectname: string): string;
begin
  result := '';

  if (IsGuildSysop(sayer) = false) then
  begin
    result := (format('%s不是门主。', [sayer]));
    exit;
  end;
  if sayer = objectname then
  begin
    result := (format('%s已经是门主', [objectname]));
    exit;
  end;
  if IsGuildUser(objectname) = false then
  begin
    result := (format('%s不是门员', [objectname]));
    exit;
  end;

  if (IsGuildSubSysop(objectname) = true) then
  begin
    result := (format('%s已经是副门主', [objectname]));
    exit;
  end;

  if (SelfData.SubSysop[0] <> '') and (SelfData.SubSysop[1] <> '') and (SelfData.SubSysop[2] <> '') then
  begin
    result := ('无法再任命,副门主满员');
    exit;
  end;

  if SelfData.SubSysop[0] = '' then
  begin
    SelfData.SubSysop[0] := objectname;
    SendMsgSubSysop(objectname);

    exit;
  end;
  if SelfData.SubSysop[1] = '' then
  begin
    SelfData.SubSysop[1] := objectname;
    SendMsgSubSysop(objectname);

    exit;
  end;
  if SelfData.SubSysop[2] = '' then
  begin
    SelfData.SubSysop[2] := objectname;
    SendMsgSubSysop(objectname);

    exit;
  end;

end;

function TGuildObject.setSysop(sayer, objectname: string): string; //设置 门主，让位
begin
  result := '';

  if (IsGuildSysop(sayer) = false) then
  begin
    result := (format('%s不是门主。', [sayer]));
    exit;
  end;
  if sayer = objectname then
  begin
    result := (format('%s已经是门主', [objectname]));
    exit;
  end;
  if IsGuildUser(objectname) = false then
  begin
    result := (format('%s不是门员', [objectname]));
    exit;
  end;

  if (IsGuildSubSysop(objectname) = false) then
  begin
    result := (format('%s不是副门主', [objectname]));
    exit;
  end;
  delSubSysop(sayer, objectname);
  SelfData.Sysop := objectname;
  SendMsgSubSysop(objectname);
  SendMsgSubSysop(sayer);
end;

function TGuildObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i, n, percent, DEC_GUILD: integer;
    //   xx, yy: word;
  str1, str2, str3: string;
  str, gname, tempName: string;
  sayer, objectname, gradename: string;
  SubData: TSubData;
  BO: TBasicObject;
  GuildNpc: TGuildNpc;
  xx, yy: word;
  tempGuildObject: TGuildObject;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit; //测试 可视 范围
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  case Msg of
    FM_ADDITEM:
      begin
        if FboAllowDelete then exit;
        if SelfData.Name = '' then Exit;
        //门战期间可用加血石
        if aSubData.ItemData.rKind = ITEM_KIND_GuildAddLife then
        begin //门派加血
          i := MinutesBetween(now(), SelfData.AddLifeTick);
          if i < 30 then
          begin
            BocSay(format('生命补充失败!%d分钟后才可使用', [30 - i]));
            exit;
          end;
          if Life >= getLifeMax then
          begin
            BocSay('生命已满,无需补充!');
            exit;
          end;
          SelfData.AddLifeTick := now();
          Life := life + aSubData.ItemData.rDurability;
          BocSay('生命补充成功!当前: ' + inttostr(Life));
          Result := PROC_TRUE;
          exit;
        end;
        //门战期间不可用加血石
        if aSubData.ItemData.rKind = ITEM_KIND_GuildAddLife2 then
        begin
          //判断是否门战期间
          if GuildList.Killstate then
          begin
            BocSay('门战期间无法使用!');
            exit;
          end;
          if Life >= getLifeMax then
          begin
            BocSay('生命已满,无需补充!');
            exit;
          end;
          Life := life + aSubData.ItemData.rDurability;
          BocSay('生命补充成功!当前: ' + inttostr(Life));
          Result := PROC_TRUE;
          exit;
        end;

        if aSubData.ItemData.rKind = ITEM_KIND_DUMMY then
        begin
          if GuildNpcList.Count + DieGuildNpcList.Count >= MAX_GUILDNPC_COUNT then
          begin
            BocSay('无法再制造。');
            exit;
          end;
          i := 0;
          while true do
          begin
            if aSubData.ItemData.rSex = 2 then
            begin
              gName := INI_GUILD_NPCWOMAN_NAME + IntToStr(i);
              if GetGuildNpcByName(gName) = -1 then
              begin
                AddGuildNpc(gName, BasicData.X, BasicData.Y, 2);
                Result := PROC_TRUE;
                break;
              end;
            end else
            begin
              gName := INI_GUILD_NPCMAN_NAME + IntToStr(i);
              if GetGuildNpcByName(gName) = -1 then
              begin
                AddGuildNpc(gName, BasicData.X, BasicData.Y, 1);
                Result := PROC_TRUE;
                break;
              end;
            end;
            Inc(i);
          end;
        end;
      end;
    FM_HIT:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if FboAllowDelete then exit;
        //检测是否允许攻击
        if GuildList.Killstate = false then exit;
        //检测是否保护期内门派
        if boProtect then
        begin
          LeftTextSay(hfu, selfdata.name + ': 门派处于保护期内', WinRGB(22, 22, 0)); //门派石受攻击
          exit;
        end;
        if SelfData.Name <> '' then
        begin
          if isHitedArea(SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then
          begin
            // if (SenderInfo.P is TUser) then exit;
            if not isUserId(SenderInfo.id) then exit;
            //没门派不让攻击
            tempName:= Tuser(SenderInfo.P).GuildName;
            if tempName = '' then exit;
            //保护门派期内不让攻击
            tempGuildObject := GuildList.GetGuildObject(tempName);
            if (tempGuildObject <> nil) and (tempGuildObject.boProtect) then
            begin
              Tuser(SenderInfo.P).SendClass.SendChatMessage('您的门派在保护期内,您无法攻击其他门派石.', SAY_COLOR_SYSTEM);
              exit;
            end;
            //判断攻击角色面向坐标是否是门派石
            xx := SenderInfo.x;
            yy := SenderInfo.y;
            GetNextPosition(SenderInfo.dir, xx, yy);
            if (SelfData.x <> xx) or (SelfData.y <> yy) then exit;
            //检测武器
            if Tuser(SenderInfo.P).GetWeaponGuild then
              DEC_GUILD := INI_WEAPONGUILD
            else
              DEC_GUILD := INI_GUILDDURABYHIT;
            if DEC_GUILD <= 0 then exit;

//              if not Tuser(SenderInfo.P).GetWeaponGuild then
//              begin
//              //Tuser(SenderInfo.P).SetTargetId(0);
//                exit; //测试 攻击 门派武器
//              end;
            //过滤  武器 对应
            //2015.11.21 屏蔽门派被攻击刷屏
            //UserList.GuildSay(SelfData.Name, SelfData.Name + ': ' + format('%s 被攻击', [INI_GUILD_STONE]));
            //减少血
            Dec(SelfData.Durability, DEC_GUILD);
            //10次 才提示
            inc(FHITNUM);
            if FHITNUM >= 10 then
            begin
              FHITNUM := 0;
              SendMsgHit; //发送 被攻击
            end;

            if SelfData.Durability <= 0 then
            begin
              //门派等级超过1 降级门派
              if level > 1 then
              begin
                //降级
                setlevel(level - 1);
                //改血
                SelfData.Durability := SelfData.MaxDurability;
                //全服公告
                UserList.SendTOPMSG(WinRGB(31, 31, 31), format('门派 %s 门石被击破!等级降为了%d级!', [GuildName, level]));
              end
              else
              begin
                SelfData.Durability := 0;
                GuildList.DeleteStone(GuildName); //删除门派
              end
            end;

            n := SelfData.Durability;
                        // if n > SelfData.MaxDurability then n := SelfData.MaxDurability;
                       // BocSay(IntToStr(n));  //20130706修改，直接提示，不刷屏了
            LeftTextSay(hfu, selfdata.name + ': ' + IntToStr(n), WinRGB(22, 22, 0)); //门派石受攻击
                        {
                        SetWordString(SubData.SayString, '-' + IntToStr(n));
                        SendLocalMessage(NOTARGETPHONE, FM_SAYUSEMAGIC, BasicData, SubData); }
                       ///////////////////////////////////////////////

            SubData.TargetId := SenderInfo.id;
            for i := 0 to GuildNpcList.Count - 1 do
            begin
              GuildNpc := GuildNpcList.Items[i];
              if GuildNpc.FieldProc(NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData) = PROC_TRUE then
              begin
                break;
              end;
            end;

          end;
        end;
                {
                            xx := SenderInfo.x; yy := SenderInfo.y;
                            GetNextPosition (SenderInfo.dir, xx, yy);
                            if (BasicData.x = xx) and (BasicData.y = yy) then begin
                               UserList.GuildSay (GuildName, GuildName+ ': '+format ('%s 被攻击',[INI_GUILD_STONE]));
                               Dec (GuildDurability, DEC_GUILD_DURA_BY_HIT);
                               BocSay (IntToStr (GuildDurability));
                               SubData.TargetId := SenderInfo.id;
                               for i := 0 to AnsList.Count -1 do
                                  if TGuildNpc (AnsList[i]).FieldProc (NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData) = PROC_TRUE then break;
                            end;
                }
      end;
    FM_PICKUP:
      begin
        if FboAllowDelete then exit;
        if (SelfData.Name = '') and (SelfData.Sysop <> '') then
        begin
          if ((SenderInfo.Name) = SelfData.Sysop) then
          begin
            ItemClass.GetItemData(INI_Guild_STONE, SubData.ItemData);
//                        SignToItem(SubData.ItemData, Manager.ServerID, SenderInfo, '');
            SubData.ServerId := Manager.ServerId;
            if TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then
            begin
              FboAllowDelete := TRUE;
              exit;
            end;
          end;
        end;
      end;
    FM_SAY:
      begin
        if FboAllowDelete then exit;
        if SenderInfo.id = BasicData.id then exit;

        if (SenderInfo.Name) = SelfData.Sysop then
        begin
                    { str := GetWordString(aSubData.SayString);
                     if ReverseFormat(str, '%s: %s门派创建', str1, str2, str3, 2) then
                     begin
                         if (not isFullHangul(str2)) or (not isGrammarID(str2)) or (Length(str2) > 12) or (Length(str2) < 2) then
                         begin
                             BocSay('门派名字错误。');
                             // Tuser(SenderInfo.P).SendClass.SendShowCreateGuildName;
                             exit;
                         end;
                         if Tuser(SenderInfo.P).GuildName <> '' then
                         begin
                             BocSay(format('%s 已加入 %s,无法成立门派。', [str1, Tuser(SenderInfo.P).GuildName]));
                             exit;
                         end;
                         if GuildList.GetGuildNname(str2) <> nil then
                         begin
                             BocSay('已有门派名称,无法成立门派。');
                             // Tuser(SenderInfo.P).SendClass.SendShowCreateGuildName;
                             exit;
                         end;
                         SubData.ServerId := Manager.ServerId;
                         SubData.SubName := Str1;
                         SubData.GuildName := Str2;
                         if TFieldPhone(Manager.Phone).SendMessage(MANAGERPHONE, FM_ALLOWGUILDNAME, BasicData, SubData) = PROC_FALSE then
                         begin
                             BocSay('该人物已是门主或副门主,无法成立门派。');
                             exit;
                         end else
                         begin
                             BocChangeProperty;

                         end;
                         exit;
                     end;
                 end;
                 }
          if SelfData.Name = '' then exit;

                    {str := GetwordString(aSubData.SayString);
                     if Pos('请将我逃脱', str) > 0 then
                     begin
                         str := GetValidStr3(str, sayer, ':');
                         str := DelUser(sayer);
                         BocSay(str);
                         exit;
                     end;
                     }
                   {  str := GetWordString(aSubData.SayString);
                      if Pos('请将我的权力删除', str) > 0 then
                       begin
                           str := GetValidStr3(str, sayer, ':');
                           Bo := GetViewObjectByName(sayer, RACE_HUMAN);
                           if Bo = nil then exit;
                           if not (Bo is TUser) then exit;
                           if (sayer <> SelfData.SubSysop[0]) and (sayer <> SelfData.SubSysop[1]) and (sayer <> SelfData.SubSysop[2]) then
                           begin
                               BocSay('并非是副门主。');
                               exit;
                           end;
                           if sayer = SelfData.SubSysop[0] then
                           begin
                               SelfData.SubSysop[0] := '';
                               SendMsgSubSysop(sayer);
                           end
                           else if sayer = SelfData.SubSysop[1] then
                           begin
                               SelfData.SubSysop[1] := '';
                               SendMsgSubSysop(sayer);
                           end
                           else if sayer = SelfData.SubSysop[2] then
                           begin
                               SelfData.SubSysop[2] := '';
                               SendMsgSubSysop(sayer);
                           end;
                           BocSay('已将副门主权力删除。');
                           exit;
                       end;
                       }
                       //权利 检查
          str := GetwordString(aSubData.SayString);
          if ReverseFormat(str, '%s: ', sayer, str2, str3, 1) then
          begin
            if (sayer <> SelfData.Sysop) and (sayer <> SelfData.SubSysop[0])
              and (sayer <> SelfData.SubSysop[1]) and (sayer <> SelfData.SubSysop[2]) then exit;
          end;

          if ReverseFormat(str, '%s: 攻击%s', sayer, objectname, str3, 2) then
          begin
            Bo := GetViewObjectByName(objectname, RACE_HUMAN);
            if Bo = nil then
            begin
              BocSay(format('%s不在。', [objectname]));
              exit;
            end;
            if not (Bo is TUser) then
            begin
              BocSay(format('%s不是使用者。', [objectname]));
              exit;
            end;
            if BO.BasicData.Feature.rfeaturestate = wfs_die then exit;
            SubData.TargetId := BO.BasicData.id;
            for i := 0 to GuildNpcList.Count - 1 do
            begin
              GuildNpc := GuildNpcList.Items[i];
              Bo := GetViewObjectByID(GuildNpc.BasicData.ID);
              if Bo <> nil then
              begin
                GuildNpc.FieldProc(NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData);
              end;
            end;
            exit;
          end;
          if ReverseFormat(str, '%s: 停止攻击', sayer, objectname, str3, 1) then
          begin
            SubData.TargetId := 0;
            for i := 0 to GuildNpcList.Count - 1 do
            begin
              GuildNpc := GuildNpcList.Items[i];
              GuildNpc.FieldProc(NOTARGETPHONE, FM_GUILDATTACK, BasicData, SubData);
            end;
            exit;
          end;
          if ReverseFormat(str, '%s: 将%s加入了', sayer, objectname, str3, 2) then
          begin
            str := AddUser(sayer, objectname);
            if str <> '' then BocSay(str);
            exit;
          end;
                    {
                    if ReverseFormat(str, '%s: 将%s脱离', sayer, objectname, str3, 2) then
                    begin
                        str := DelUser_Force(sayer, objectname);
                        if str <> '' then BocSay(str);
                        exit;          //2008-11-34 操作 完成 结束掉
                    end;}
                    {
                    if ReverseFormat(str, '%s: %s的职称是%s', sayer, objectname, gradename, 3) then
                    begin
                        if (not isFullHangul(gradename)) or (not isGrammarID(gradename)) or (Length(gradename) > 12) or (Length(gradename) < 2) then
                        begin
                            BocSay('错误的职称');
                            exit;
                        end;
                        str := SetGradeName(sayer, objectname, gradename);
                        if str <> '' then BocSay(str);
                        exit;          //2008-11-34 操作 完成 结束掉
                    end;}
                    {
                     if ReverseFormat(str, '%s: 将%s任命为副门主', sayer, objectname, str3, 2) then
                     begin
                         if sayer <> SelfData.Sysop then exit;
                         // 2000.09.18 NPC狼 捞抚苞 User狼 捞抚捞 鞍阑锭 八祸坷幅滚弊 荐沥 by Lee.S.G
                         // 何巩林绰 RACE_HUMAN俊辑父 蜡瓤窍促
                         Bo := GetViewObjectByName(objectname, RACE_HUMAN);
                         if Bo = nil then
                         begin
                             BocSay(format('%s不在。', [objectname]));
                             exit;
                         end;
                         if not (Bo is TUser) then
                         begin
                             BocSay(format('%s不是使用者。', [objectname]));
                             exit;
                         end;
                         if TUser(Bo).GuildName <> SelfData.Name then
                         begin
                             BocSay(format('%s不是门员', [objectname]));
                             exit;
                         end;

                         if (objectname = SelfData.SubSysop[0]) or (objectname = SelfData.SubSysop[1]) or (objectname = SelfData.SubSysop[2]) then
                         begin
                             BocSay(format('%s已经是副门主', [objectname]));
                             exit;
                         end;

                         if (SelfData.SubSysop[0] <> '') and (SelfData.SubSysop[1] <> '') and (SelfData.SubSysop[2] <> '') then
                         begin
                             BocSay('无法再任命');
                             BocSay(format('副门主是%s, %s, %s', [SelfData.SubSysop[0], SelfData.SubSysop[1], SelfData.SubSysop[2]]));
                             exit;
                         end;

                         // 2000.09.20 促弗 巩颇狼 巩林唱 何巩林绰 何巩林肺 烙疙瞪荐 绝促 by Lee.S.G
                         SubData.ServerId := Manager.ServerId;
                         SubData.SubName := objectname;
                         SubData.GuildName := '';
                         if TFieldPhone(Manager.Phone).SendMessage(MANAGERPHONE, FM_ALLOWGUILDSYSOPNAME, BasicData, SubData) = PROC_FALSE then
                         begin
                             BocSay('已是其他门派的副门主或门主');
                             BocSay('已经是');
                             Exit;
                         end;

                         if SelfData.SubSysop[0] = '' then
                         begin
                             SelfData.SubSysop[0] := objectname;
                             SendMsgSubSysop(objectname);
                             BocSay(format('任命%s为副门主', [objectname]));
                             exit;
                         end;
                         if SelfData.SubSysop[1] = '' then
                         begin
                             SelfData.SubSysop[1] := objectname;
                             SendMsgSubSysop(objectname);
                             BocSay(format('任命%s为副门主', [objectname]));
                             exit;
                         end;
                         if SelfData.SubSysop[2] = '' then
                         begin
                             SelfData.SubSysop[2] := objectname;
                             SendMsgSubSysop(objectname);
                             BocSay(format('任命%s为副门主', [objectname]));
                             exit;
                         end;
                         exit;          //2008-11-34 操作 完成 结束掉
                     end; }
                 {   if ReverseFormat(str, '%s: 将副门主%s权力删除', sayer, objectname, str3, 2) then
                    begin
                        if sayer <> SelfData.Sysop then exit;
                        if SelfData.SubSysop[0] = objectname then
                        begin
                            SelfData.SubSysop[0] := '';
                            SendMsgSubSysop(objectname);
                            BocSay(format('删除%s副门主的权力', [objectname]));
                            exit;
                        end;
                        if SelfData.SubSysop[1] = objectname then
                        begin
                            SelfData.SubSysop[1] := '';
                            SendMsgSubSysop(objectname);
                            BocSay(format('删除%s副门主的权力', [objectname]));
                            exit;
                        end;
                        if SelfData.SubSysop[2] = objectname then
                        begin
                            SelfData.SubSysop[2] := '';
                            SendMsgSubSysop(objectname);
                            BocSay(format('删除%s副门主的权力', [objectname]));
                            exit;
                        end;
                        BocSay(format('%s不是副门主', [objectname]));
                        exit;          //2008-11-34 操作 完成 结束掉
                    end;
                    }
          if ReverseFormat(str, '%s: 门派情报', str1, str2, str3, 1) then
          begin
            BocSay('门派卒兵情报');
            for i := 0 to GuildNpcList.Count - 1 do
            begin
              GuildNpc := GuildNpcList.Items[i];
              str := (GuildNpc.BasicData.Name);
              str := str + '  x:' + IntToStr(GuildNpc.BasicData.X);
              str := str + '  y:' + IntToStr(GuildNpc.BasicData.Y);
              BocSay(str);
            end;
            n := SelfData.Durability;
            if n > SelfData.MaxDurability then n := SelfData.MaxDurability;
            BocSay(format('门派石: %d/%d', [n, SelfData.MaxDurability]));
            exit;
          end;
        end;
      end;
  end;
end;

procedure TGuildObject.Initial;
var
  i: Integer;
  GuildNpc: TGuildNpc;
  MagicData: TMagicData;
begin
  inherited Initial(SelfData.Name, SelfData.Name);

  LoadFromFile(SelfData.Name);

  FGuildName := SelfData.Name;
  DuraTick := mmAnsTick;

    // if (SelfData.MaxDurability = 0) or (SelfData.MaxDurability = 110000) then begin
    // SelfData.MaxDurability := MAX_GUILD_DURA;
    // end;

  BasicData.id := GetNewStaticItemId; //;
  BasicData.x := SelfData.X;
  BasicData.y := SelfData.Y;
  BasicData.ClassKind := CLASS_GUILDSTONE;
  BasicData.Feature.rrace := RACE_STATICITEM;
  BasicData.Feature.rImageNumber := 67;
  BasicData.Feature.rImageColorIndex := 0;
  BasicData.BasicObjectType := boGuildObject;
  MagicClass.GetMagicData(SelfData.GuildMagic, MagicData, SelfData.MagicExp);
  if MagicData.rName = '' then
  begin
    SelfData.GuildMagic := '';
    SelfData.MagicExp := 0;
  end;

  boAddGuildMagic := false;
  boAddAllyGuild := false; //默认拒绝门派同盟
  boProtect := false; //默认非保护状态

  DieGuildNpcList.Clear;
  for i := 0 to MAX_GUILDNPC_COUNT - 1 do
  begin
    if SelfData.GuildNpc[i].rName = '' then continue;

    GuildNpc := TGuildNpc.Create;
    if Manager <> nil then
    begin
      GuildNpc.SetManagerClass(Manager);
    end;
    GuildNpc.Initial(Self, SelfData.GuildNpc[i].rName, SelfData.GuildNpc[i].rX, SelfData.GuildNpc[i].rY, SelfData.GuildNpc[i].rSex);

    if (SelfData.GuildMagic <> '') and (boAddGuildMagic = false) then
    begin
      GuildNpc.boMagicNpc := true;
      GuildNpc.BasicData.Guild := SelfData.GuildMagic;
      MagicClass.GetMagicData(SelfData.GuildMagic, GuildNpc.GuildMagicData, SelfData.MagicExp);
      boAddGuildMagic := true;
    end;
    DieGuildNpcList.Add(GuildNpc);
  end;
end;

procedure TGuildObject.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;

  TFieldPhone(Manager.Phone).RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  TFieldPhone(Manager.Phone).SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TGuildObject.EndProcess;
var
  i: integer;
  SubData: TSubData;
  GuildNpc: TGuildNpc;
begin
  if FboRegisted = FALSE then exit;

  for i := DieGuildNpcList.Count - 1 downto 0 do
  begin
    GuildNpc := DieGuildNpcList.Items[i];
    GuildNpc.Free;
    DieGuildNpcList.Delete(i);
  end;

  for i := GuildNpcList.Count - 1 downto 0 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    GuildNpc.EndProcess;
    GuildNpc.Free;
    GuildNpcList.Delete(i);
  end;

  TFieldPhone(Manager.Phone).SendMessage(0, FM_DESTROY, BasicData, SubData);
  TFieldPhone(Manager.Phone).UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;

function TGuildObject.MoveStone(aServerID, ax, ay: integer): Boolean;
var
  i, nX, nY: integer;
  nIndex: Byte;
  SubData: TSubData;
  tmpManager: TManager;
  GuildNpc: TGuildNpc;
begin
  Result := false;

  if Manager = nil then exit;

  tmpManager := ManagerList.GetManagerByServerID(aServerID);
  if tmpManager = nil then exit;
  if tmpManager.boMakeGuild = false then exit;
  nIndex := TMaper(tmpManager.Maper).GetAreaIndex(aX, aY);
  if nIndex = 0 then exit;
  if AreaClass.CanMakeGuild(nIndex) = false then exit;

  nX := aX;
  nY := aY;
    // TMaper (tmpManager.Maper).GetMoveableXY (nX, nY, 10);
    // if not TMaper (tmpManager.Maper).isMoveable (nX, nY) then exit;

  TFieldPhone(Manager.Phone).SendMessage(NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
  TFieldPhone(Manager.Phone).UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  SelfData.MapID := aServerID;
  SelfData.X := nX;
  SelfData.Y := nY;
  BasicData.x := nx;
  BasicData.y := ny;

  SetManagerClass(tmpManager);

  TFieldPhone(Manager.Phone).RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  TFieldPhone(Manager.Phone).SendMessage(NOTARGETPHONE, FM_CREATE, BasicData, SubData);

  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    GuildNpc.MoveGuildNpc(aServerID, nX, nY);
  end;

  for i := 0 to DieGuildNpcList.Count - 1 do
  begin
    GuildNpc := DieGuildNpcList.Items[i];
    GuildNpc.MoveDieGuildNpc(aServerID, nX, nY);
  end;

  Result := true;
end;

function TGuildObject.CreateStone(aSysopName: string; aServerID, ax, ay: integer): Boolean;
var
  i, nX, nY: integer;
  nIndex: Byte;
  SubData: TSubData;
  tmpManager: TManager;
  GuildNpc: TGuildNpc;
begin
  Result := false;

  if (aSysopName <> '') and (SelfData.Sysop <> aSysopName) then exit;

  tmpManager := ManagerList.GetManagerByServerID(aServerID);
  if tmpManager = nil then exit;
  if tmpManager.boMakeGuild = false then exit;
   // nIndex := TMaper(tmpManager.Maper).GetAreaIndex(aX, aY);
  //  if nIndex = 0 then exit;
  //  if AreaClass.CanMakeGuild(nIndex) = false then exit;

  nX := aX;
  nY := aY;
    //if TMaper(tmpManager.Maper).isGuildStoneArea(nX, nY) = true then exit;
  if GuildList.isGuildStoneArea(nX, nY, tmpManager.Maper) = true then exit;
    // TMaper (tmpManager.Maper).GetMoveableXY (nX, nY, 10);
    // if not TMaper (tmpManager.Maper).isMoveable (nX, nY) then exit;

  SelfData.MapID := aServerID;
  SelfData.X := nX;
  SelfData.Y := nY;
  BasicData.x := nx;
  BasicData.y := ny;

  SetManagerClass(tmpManager);

  Initial;
  StartProcess;

  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    GuildNpc.MoveGuildNpc(aServerID, nX, nY);
  end;

  for i := 0 to DieGuildNpcList.Count - 1 do
  begin
    GuildNpc := DieGuildNpcList.Items[i];
    GuildNpc.MoveDieGuildNpc(aServerID, nX, nY);
  end;

  Result := true;
end;

function TGuildObject.GetGuildNpcByName(aname: string): integer;
var
  i: integer;
  GuildNpc: TGuildNpc;
begin
  Result := -1;
  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    if GuildNpc.GuildNpcName = aName then
    begin
      Result := i;
      exit;
    end;
  end;
end;

procedure TGuildObject.ChangeGuildNpcName(aOldName, aNewName: string);
var
  i: integer;
  GuildNpc: TGuildNpc;
begin
  for i := 0 to MAX_GUILDNPC_COUNT - 1 do
  begin
    if SelfData.GuildNpc[i].rName = aOldName then
    begin
      SelfData.GuildNpc[i].rName := aNewName;
      exit;
    end;
  end;
end;

function TGuildObject.GetGuildServerID(): Integer;
begin
  Result := -1;
  if boAllowDelete = false then
  begin
    Result := SelfData.MapID;
  end;
end;

function TGuildObject.readlevel(): integer;
begin

  result := SelfData.FguildLeve;
end;

function TGuildObject.LifeDataAdditem(aitemname: string): boolean; //物品附加属性
var
  aitem: titemdata;
begin
  result := false;
  if ItemClass.GetItemData(aitemname, aitem) = false then exit;
  if LifeDataList.additem(aitem) = false then exit;
  result := true;
end;

procedure TGuildObject.setLifeData(); //重新 计算 门派附加属性
begin
  FillChar(LifeData, SizeOf(TLifeData), 0);
  GatherLifeData(LifeData, LifeDataList.LifeData);
  UserList.GuildSetLifeData(GuildName); //设置 本门派在线人员 门派附加属性
end;

function TGuildObject.getEnegy(): integer;
begin
  result := SelfData.rEnegy;
end;

procedure TGuildObject.setEnegy(value: integer);
begin
  SelfData.rEnegy := value;
  if SelfData.rEnegy < 0 then SelfData.rEnegy := 0;

  if SelfData.rEnegy > SelfData.rMaxEnegy then SelfData.rEnegy := SelfData.rMaxEnegy;
end;


function TGuildObject.getLifeMax(): integer;
begin
  result := SelfData.MaxDurability;
end;

function TGuildObject.getLife(): integer;
begin
  result := SelfData.Durability;
end;

function TGuildObject.getGuildTeam(): integer;
begin
  result := SelfData.FGuildTeam;
end;

procedure TGuildObject.setLifeMax(value: integer);
begin
  if value < 0 then value := 0;
  SelfData.MaxDurability := value;
end;

function TGuildObject.setLifex(value: integer): Boolean;
begin
  result := False;

  if MinutesBetween(now(), SelfData.AddLifeTick) < 30 then //20130902修改
  begin
    BocSay('补血失败!剩余' + inttostr(30 - MinutesBetween(now(), SelfData.AddLifeTick)) + '分钟才可以再次补血');
    exit;
  end;
  SelfData.AddLifeTick := now();
  SelfData.Durability := value;
  if SelfData.Durability < 0 then SelfData.Durability := 0;
  if SelfData.Durability > SelfData.MaxDurability then SelfData.Durability := SelfData.MaxDurability;
  result := True;
end;

procedure TGuildObject.setLife(value: integer);
begin

  SelfData.Durability := value;
  if SelfData.Durability < 0 then SelfData.Durability := 0;
  if SelfData.Durability > SelfData.MaxDurability then SelfData.Durability := SelfData.MaxDurability;
end;

procedure TGuildObject.setlevel(value: integer);
var
  pp: pTGuildsysdata;
begin
  //todo:门派相关  去掉guildsys文件里的 配置   初始值从game.ini里读取
  pp := Guildsys.get(value);
  if pp <> nil then
  begin
    SelfData.rMaxEnegy := pp.rMaxEnegy;
    SelfData.MaxDurability := pp.rMaxLife;
    SelfData.FguildMaxNum := pp.rMaxNum;

    if SelfData.rEnegy > SelfData.rMaxEnegy then SelfData.rEnegy := SelfData.rMaxEnegy;
    if SelfData.Durability > SelfData.MaxDurability then SelfData.Durability := SelfData.MaxDurability;
  end;
  SelfData.FguildLeve := value;
  SendLevel;
end;



function TGuildObject.SetGuildnotice(aname, aStr: string): string;
var
  tempsend: TWordComData;
begin
  result := '';
  if (IsGuildSysop(aname) = false)
    and (IsGuildSubSysop(aname) = false) then
  begin
    result := (format('%s 不是门主或者副门主。', [aname]));
    exit;
  end;
  aStr := copy(trim(aStr), 1, 120);
  if IsHZ(aStr) = false then //if isFullHangul(aStr) = false then
  begin
    result := '有特殊字符，不合法！';
    exit;
  end;
  if aStr = '' then exit;
  if FGuildnotice <> aStr then
  begin
    FGuildnotice := aStr;
        //通知 所有人
    tempsend.Size := 0;

    WordComData_ADDbyte(tempsend, SM_GUILD);
    WordComData_ADDbyte(tempsend, GUILD_noticeUPdate);
    WordComData_ADDString(tempsend, FGuildnotice);

    UserList.GuildSendData(GuildName, tempsend);
  end;
  result := '修改门派宣言成功';
end;

procedure TGuildObject.SetWarAlarm(aName, aStr: string);
var
  i: Integer;
  boFlag: Boolean;
begin
  boFlag := false;

  if isGuildSysop(aName) then boFlag := true;
  if boFlag = false then
  begin
    if isGuildSubSysop(aName) then boFlag := true;
  end;

  if boFlag = false then exit;

  FWarAlarmStr := aStr;
  FWarAlarmTick := mmAnsTick;
  FWarAlarmStartTick := mmAnsTick;
end;

procedure TGuildObject.Update(CurTick: integer);
var
  i, j, nX, nY: integer;
  nname: string;
  GuildNpc: TGuildNpc;
  bo: TBasicObject;
begin
  LifeDataList.Update(CurTick);
  if LifeDataList.rboupdate then
  begin
    setLifeData;
    LifeDataList.rboupdate := false;
  end;
  ADDMsgList.UPDATE(CurTick);
  ADDALLYMsgList.UPDATE(CurTick);
  //判断门派是否保护期判断
  if GuildList.Killstate then
    if (INI_GUILDBAOHU > 0) and (GetTimeDiff(Now, VarToDateTime(SelfData.MakeDate)) div 60 div 60 div 24 <= INI_GUILDBAOHU) then
      boProtect := True
    else
      boProtect := False;

    // 2000.09.18 巩颇器凉捞 昏力登绰 泅惑阑 阜扁困秦 刚历 昏力窍绊
    // 第捞绢 官肺 积己茄促 by Lee.S.G
  for i := GuildNpcList.Count - 1 downto 0 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    if GuildNpc.boAllowDelete then
    begin
      GuildNpc.EndProcess;
      GuildNpcList.Delete(i);
      DieGuildNpcList.Add(GuildNpc);
    end;
  end;

  if (Manager <> nil) and (DieGuildNpcList.Count > 0) then
  begin
    for i := DieGuildNpcList.Count - 1 downto 0 do
    begin
      GuildNpc := DieGuildNpcList.Items[i];
      nX := GuildNpc.StartX - 3 + Random(6);
      nY := GuildNpc.StartY - 3 + Random(6);
      TMaper(Manager.Maper).GetMoveableXY(nX, nY, 10);
      if TMaper(Manager.Maper).isMoveable(nX, nY) then
      begin
        GuildNpc.BasicData.X := nX;
        GuildNpc.BasicData.Y := nY;
        GuildNpc.StartProcess;
        GuildNpcList.Add(GuildNpc);
        DieGuildNpcList.Delete(i);
      end;
    end;
  end;

  for i := 0 to GuildNpcList.Count - 1 do
  begin
    GuildNpc := GuildNpcList.Items[i];
    GuildNpc.Update(CurTick);
  end;

    {if CurTick > DuraTick + DEC_GUILD_DURA_TICK then
    begin
        DuraTick := CurTick;
        Dec(SelfData.Durability);
        if boShowGuildDuraValue then
        begin
            BocSay(IntToStr(SelfData.Durability) + '/' + IntToStr(SelfData.MaxDurability));
        end;
    end;
    }
  if (FWarAlarmStr <> '') and (CurTick > FWarAlarmTick + 1000) then
  begin
    UserList.GuildSay(SelfData.Name, SelfData.Name + ': ' + format('%s', [FWarAlarmStr]));
    FWarAlarmTick := CurTick;
    if CurTick > FWarAlarmStartTick + 18000 then
    begin
      FWarAlarmTick := 0;
      FWArAlarmSTartTick := 0;
      FWarAlarmStr := '';
    end;
  end;
end;

////////////////////////////////////////////////////
//
//             ===  GuildList  ===
//
////////////////////////////////////////////////////

function getfilec: string;


begin


end;

constructor TGuildList.Create;
var
  i: Integer;
  vv: ofstruct;
begin
  Killstate := false;
  CurProcessPos := 0;

  DataList := TList.Create;
  Guildsys := TGuildsys.Create; //等级配置表
  if FileExists('.\Guild\CreateGuild.SDB') then
  begin
    i := openfile(pchar(ParamStr(0)), vv, 0);
    if GetFileSize(i, nil) > 2048 then CopyFile('.\Guild\CreateGuild.SDB', '.\Guild\CreateGuild.SDB_', false);
    _lclose(i);
  end;
  LoadFromFile('.\Guild\CreateGuild.SDB');
end;

destructor TGuildList.Destroy;
begin
  Guildsys.Free;
  SaveToFile('.\Guild\CreateGuild.SDB');
  Clear;
  DataList.Free;

  inherited Destroy;
end;

procedure TGuildList.Clear;
var
  i: Integer;
  GuildObject: TGuildObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    GuildObject.EndProcess;
    GuildObject.Free;
  end;
  DataList.Clear;
end;

function TGuildList.GetCount: integer;
begin
  Result := DataList.Count;
end;


function TGuildList.GetUserGrade(aGuildName, uName: string): string;
var
  i: integer;
  GuildObject: TGuildObject;
begin
  Result := '';
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = aGuildName then
    begin
      Result := GuildObject.GetUserGrade(uname);
      exit;
    end;
  end;
end;


function TGuildList.GetGuildServerID(aGuildName: string): Integer;
var
  i: integer;
  GuildObject: TGuildObject;
begin
  Result := -1;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = aGuildName then
    begin
      if GuildObject.boAllowDelete = false then
      begin
        Result := GuildObject.SelfData.MapID;
        exit;
      end;
    end;
  end;
end;

function TGuildList.SETGuildOnLine(aGuildName: string; aUser: TUser): boolean;
var
  GuildObject: TGuildObject;
begin
  result := false;
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;

  result := GuildObject.SETonLine(aUser);

end;

procedure TGuildList.setKillstate(Value: boolean);
var
  ComData: TWordComData;
begin
  if Value <> FKillstate then
  begin
    ComData.Size := 0;
    WordComData_ADDbyte(ComData, SM_GUILD);
    WordComData_ADDbyte(ComData, GUILD_sys);
    WordComData_ADDbyte(ComData, byte(Value));
    UserList.SendALLdata(ComData);
  end;
  FKillstate := Value;
end;

function TGuildList.SETGuildGameExit(aGuildName: string; aUser: TUser): boolean;
var
  GuildObject: TGuildObject;
begin
  result := false;
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;
  result := GuildObject.IsGuildUser(auser.name);
  if result then
    GuildObject.SETGameExit(aUser);
end;
//请求加门同意

function TGuildList.adduserMsgOk(aGuildName: string; aUser: TUser): string;
var
  GuildObject: TGuildObject;
begin
  result := '';
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;

  GuildObject.adduserMsgOK(aUser);
end;
//请求同盟同意

function TGuildList.addALLYMsgOk(aGuildName: string; aUser: TUser): string;
var
  GuildObject: TGuildObject;
begin
  result := '';
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;

  GuildObject.addALLYMsgOk(aUser);
end;

function TGuildList.isGuildItem(aid: integer): boolean;
begin
  result := false;
  if not isStaticItemId(aid) then exit;
  result := true;
end;

function TGuildList.adduserMsgNo(aGuildName: string; aUser: TUser): string;
var
  GuildObject: TGuildObject;
begin
  result := '';
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;

  GuildObject.adduserMsgNo(aUser);
end;

function TGuildList.addALLYMsgNo(aGuildName: string; aUser: TUser): string;
var
  GuildObject: TGuildObject;
begin
  result := '';
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;

  GuildObject.addALLYMsgNo(aUser);
end;

function TGuildList.GetGuildcount: integer;
var
  i: integer;
begin
  result := DataList.Count;
end;

function TGuildList.GetGuildNname(aGuildName: string): TGuildObject;
var
  i: integer;
  GuildObject: TGuildObject;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = aGuildName then
    begin
      result := GuildObject;
      exit;
    end;
  end;
end;

procedure TGuildList.GetGuildInfo(aGuildName: string; aUser: TUser);
var
  GuildObject: TGuildObject;
begin
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;
  GuildObject.GetGuildInfo(aUser);
end;

procedure TGuildList.GetGuildInfoFrom(aGuildName: string; aUser: TUser);
var
  GuildObject: TGuildObject;
begin
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;
  GuildObject.GetGuildInfoFrom(aUser);
end;

function TGuildList.CheckGuildUser(aGuildName, aName: string): Boolean;
var
  GuildObject: TGuildObject;
begin
  Result := FALSE;
  GuildObject := GetGuildNname(aGuildName);
  if GuildObject = nil then EXIT;
  if GuildObject.IsGuildUser(aName) = true then
  begin
    Result := TRUE;
    exit;
  end;
end;

procedure TGuildList.AllowGuildName(gid: integer; aboAllow: Boolean; aGuildName, aSysopName: string);
var
  i: integer;
  pd: PTCreateGuildData;
  GuildObject: TGuildObject;
  tempuser: tuser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.BasicData.id = gid then
    begin
      if aboAllow = true then
      begin
        pd := GuildObject.GetSelfData;

        GuildObject.BocSay(format('门派名称是 %s', [aGuildName]));
        pd^.Sysop := aSysopName;
        GuildObject.BasicData.Name := aGuildName;
        GuildObject.BasicData.ViewName := aGuildName;
        pd^.Name := aGuildName;
        GuildObject.FGuildName := aGuildName;
        GuildObject.BocChangeFeature;
       // pd^.MakeDate := DateToStr(Date);
        pd^.MakeDate := FormatdateTime('yyyy-mm-dd', now);
                //发送

             //   GuildObject.AddUser(aSysopName, aSysopName);
        tempuser := UserList.GetUserPointer(aSysopName);
        if tempuser <> nil then
        begin
          GuildObject.GuildUserList.AddUser(tempuser.BasicData.id, tempuser.name);
          tempuser.GuildSet(GuildObject);
          GuildObject.SETonLine(tempuser);

        end;

      end else
      begin
        GuildObject.BocSay('无法成立门派。');
      end;
      exit;
    end;
  end;
end;

function TGuildList.AllowGuildCondition(gname, uname: string): Boolean;
var
  i, j: integer;
  pd: PTCreateGuildData;
  GuildObject: TGuildObject;
begin
  Result := TRUE;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    pd := GuildObject.GetSelfData;
    if pd^.Name = '' then continue;
    if pd^.Name = gname then
    begin
      Result := FALSE;
      exit;
    end;
    if pd^.Sysop = uname then
    begin
      Result := FALSE;
      exit;
    end;
    for j := 0 to MAX_SUBSYSOP_COUNT - 1 do
    begin
      if pd^.SubSysop[j] = uname then
      begin
        Result := FALSE;
        exit;
      end;
    end;
  end;
end;

function TGuildList.MoveStone(aGuildName: string; aServerID, ax, ay: integer): Boolean;
var
  i: integer;
  GuildObject: TGuildObject;
begin
  Result := false;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = aGuildName then
    begin
      Result := GuildObject.MoveStone(aServerID, ax, ay);
      exit;
    end;
  end;
end;

function TGuildList.CreateStone(aGuildName, aSysopName: string; aServerID, ax, ay: integer): Boolean;
var
  i: integer;
  GuildObject: TGuildObject;
begin
  Result := false;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.SelfData.Name = aGuildName then
    begin
      if GuildObject.boRegisted = false then
      begin
        Result := GuildObject.CreateStone(aSysopName, aServerID, ax, ay);
      end;
      exit;
    end;
  end;
end;

function TGuildList.AddGuildObject(aGuildName, aOwnerName: string; aServerID, aX, aY: integer): TGuildObject;
var
  Manager: TManager;
  GuildObject: TGuildObject;
  pd: PTCreateGuildData;
  tempuser: Tuser;
begin

  GuildObject := TGuildObject.Create;

  pd := GuildObject.GetSelfData;
  pd^.Name := aGuildName;
  pd^.MapID := aServerID;
  pd^.X := aX;
  pd^.Y := aY;
  pd^.Durability := MAX_GUILD_DURA1 + 100000; //默认 创建 是1级帮会
  pd^.MaxDurability := MAX_GUILD_DURA1;
  pd^.Sysop := aOwnerName;

  Manager := ManagerList.GetManagerByServerID(aServerID);
  GuildObject.SetManagerClass(Manager);
  GuildObject.Initial;
  GuildObject.StartProcess;
  DataList.Add(GuildObject);

  Result := GuildObject;
end;

function TGuildList.AddGuildObjectCreateName(aGuildName, aOwnerName: string; aServerID, aX, aY, akey: integer): boolean;
var
  Manager: TManager;
  GuildObject: TGuildObject;
  pd: PTCreateGuildData;
  tempuser: Tuser;
  SubData: TSubData;
begin
  result := FALSE;
  Manager := ManagerList.GetManagerByServerID(aServerID);
  tempuser := UserList.GetUserPointer(aOwnerName);
  if tempuser = nil then exit;
    {if aGuildName = '' then
    begin
        tempuser.SendClass.SendChatMessage('门派名字错误。', SAY_COLOR_SYSTEM);
        tempuser.SendClass.SendShowCreateGuildName(akey);
    end;
    if (not isFullHangul(aGuildName)) or (not isGrammarID(aGuildName)) or (Length(aGuildName) > 12) or (Length(aGuildName) < 2) then
    begin
        tempuser.SendClass.SendChatMessage('门派名字错误。', SAY_COLOR_SYSTEM);
        tempuser.SendClass.SendShowCreateGuildName(akey);
        exit;
    end;
    if tempuser.GuildName <> '' then
    begin
        tempuser.SendClass.SendNUMSAY(numsay_24, SAY_COLOR_SYSTEM, tempuser.GuildName); //   , '你已加入 %s,无法成立门派。' //24  numsay_24
        exit;
    end;
    if GuildList.GetGuildNname(aGuildName) <> nil then
    begin
        tempuser.SendClass.SendChatMessage('已有门派名称,无法成立门派。', SAY_COLOR_SYSTEM);
        tempuser.SendClass.SendShowCreateGuildName(akey);
        exit;
    end;

    if AllowGuildCondition(aGuildName, aOwnerName) = false then
    begin
        tempuser.SendClass.SendChatMessage('该人物已是门主或副门主,无法成立门派。', SAY_COLOR_SYSTEM); // BocSay('');
        exit;
    end;
    }
  GuildObject := TGuildObject.Create;

  pd := GuildObject.GetSelfData;
  pd^.Name := aGuildName;
  pd^.MapID := aServerID;
  pd^.X := aX;
  pd^.Y := aY;

  pd^.Durability := MAX_GUILD_DURA1 + 100000; //默认 创建 是1级帮会
  pd^.MaxDurability := MAX_GUILD_DURA1;
  pd^.Sysop := aOwnerName;

    //Manager := ManagerList.GetManagerByServerID(aServerID);
  GuildObject.SetManagerClass(Manager);
  GuildObject.Initial;
  GuildObject.StartProcess;
  DataList.Add(GuildObject);
    //
  GuildObject.BocSay(format('门派名称是 %s', [aGuildName]));
  //2016-9-16 21:56:30 增加全服公告
  UserList.SendTOPMSG(WinRGB(31, 25, 0), format('%s 恭喜你,门派 [%s] 创建了', [aOwnerName, aGuildName]));
  SaveToFile('.\Guild\CreateGuild.SDB');
  pd^.Sysop := aOwnerName;
  GuildObject.BasicData.Name := aGuildName;
  GuildObject.BasicData.ViewName := aGuildName;
  pd^.Name := aGuildName;
  GuildObject.FGuildName := aGuildName;
  GuildObject.BocChangeFeature;
 // pd^.MakeDate := DateToStr(Date);
  pd^.MakeDate := FormatdateTime('yyyy-mm-dd', now);
    //发送
  GuildObject.level := 1;
  //门派相关
  GuildObject.setMaxDurability(INI_CREATEGUILDMAXLIFE);
  GuildObject.setMaxNum(INI_CREATEGUILDMAXNUM);
  GuildObject.GuildUserList.AddUser(tempuser.BasicData.id, tempuser.name);
  tempuser.GuildSet(GuildObject);
  GuildObject.SETonLine(tempuser);
  //脚本触发
 // tempuser.CallScriptFunction('OnGuildUpdate', [integer(tempuser), Integer(GuildObject), GUILD_Create_name, tempuser.getGuildPoint, tempuser.name]);
  Result := true;
end;

procedure TGuildList.LoadFromFileIni(aFileName: string);
var
  i, j: Integer;
  str, rdstr: string;
  iName: string;
  DB: TUserStringDb;
begin
  FillChar(HitListArr, SizeOf(HitListArr), 0);
  if not FileExists(aFileName) then exit;

  DB := TUserStringDb.Create;
  try
    DB.LoadFromFile(aFileName);
    for i := 0 to 6 do
    begin
      iName := Db.GetIndexName(i);
      if iName = '' then continue;
      if iName <> inttostr(i + 1) then Continue;
      for j := 0 to 23 do
      begin
        HitListArr[i + 1, j] := Db.GetFieldValueBoolean(iName, 'clock' + inttostr(j));
      end;
    end;
  finally
    DB.Free;
  end;
  //todo: 16.6.6  重新计算门派排行
  getBillboard;
end;

procedure TGuildList.LoadFromFile(aFileName: string);
var
  i, j: Integer;
  str, rdstr, dstr: string;
  iName: string;
  pd, pdd: PTCreateGuildData;
  DB: TUserStringDb;
  Manager: TManager;
  GuildObject: TGuildObject;
  pp: pTGuildsysdata;
  maxNum: Integer;
begin
  //门派相关
  LoadFromFileIni('.\guild\guildHitTime.sdb');
  if not FileExists(aFileName) then exit;

  DB := TUserStringDb.Create;
  DB.LoadFromFile(aFileName);

  for i := 0 to Db.Count - 1 do
  begin
    iName := Db.GetIndexName(i);
    if iName = '' then continue;

    GuildObject := TGuildObject.Create;
    pd := GuildObject.GetSelfData;

    FillChar(pd^, SizeOf(TCreateGuildData), 0);

    pd^.Name := iName;
    pd^.Title := Db.GetFieldValueString(iName, 'Title');
    pd^.MapID := Db.GetFieldValueInteger(iName, 'MapID');
    pd^.x := Db.GetFieldValueInteger(iname, 'X');
    pd^.y := Db.GetFieldValueInteger(iname, 'Y');
    pd^.Durability := Db.GetFieldValueInteger(iName, 'Durability');
    pd^.MaxDurability := Db.GetFieldValueInteger(iName, 'MaxDurability');
    pd^.GuildMagic := Db.GetFieldValueString(iName, 'GuildMagic');
    pd^.MagicExp := Db.GetFieldValueInteger(iName, 'MagicExp');
    pd^.MakeDate := Db.GetFieldValueString(iName, 'MakeDate');
    pd^.Sysop := Db.GetFieldValueString(iname, 'Sysop');
    for j := 0 to MAX_SUBSYSOP_COUNT - 1 do
    begin
      pd^.SubSysop[j] := Db.GetFieldValueString(iName, 'SubSysop' + IntToStr(j));
    end;
    for j := 0 to MAX_GUILDNPC_COUNT - 1 do
    begin
      str := Db.GetFieldValueString(iName, 'Npc' + IntToStr(j));
      str := GetValidStr3(str, rdstr, ':');
      pd^.GuildNpc[j].rName := rdstr;
      str := GetValidStr3(str, rdstr, ':');
      pd^.GuildNpc[j].rx := _StrToInt(rdstr);
      str := GetValidStr3(str, rdstr, ':');
      pd^.GuildNpc[j].ry := _StrToInt(rdstr);
      str := GetValidStr3(str, rdstr, ':');
      pd^.GuildNpc[j].rSex := _StrToInt(rdstr);
    end;
    for j := 0 to MAX_GUILDWEAR_COUNT - 1 do
    begin
      str := Db.GetFieldValueString(iName, 'Wear0');
      str := GetValidStr3(str, rdstr, ':');
      pd^.GuildWear[j].rItemName := rdstr;
      str := GetValidStr3(str, rdstr, ':');
      pd^.GuildWear[j].rColor := _StrToInt(rdstr);
      str := GetValidStr3(str, rdstr, ':');
      pd^.GuildWear[j].rItemCount := _StrToInt(rdstr);
    end;

    pd^.BasicPoint := Db.GetFieldValueInteger(iName, 'BasicPoint');
    pd^.AwardPoint := Db.GetFieldValueInteger(iName, 'AwardPoint');
    pd^.BattleRejectCount := Db.GetFieldValueInteger(iName, 'BattleRejectCount');
    pd^.ChallengeGuild := Db.GetFieldValueString(iName, 'ChallengeGuild');
    pd^.ChallengeGuildUser := Db.GetFieldValueString(iName, 'ChallengeGuildUser');
    pd^.ChallengeDate := Db.GetFieldValueString(iName, 'ChallengeDate');
    dstr := Db.GetFieldValueString(iName, 'AddLifeTick');
    //2015.11.10 在水一方 内存泄露003
    //if Pos('-', dstr) > 0 then dstr := StringReplace(dstr, '-', '/', [rfReplaceAll]); //20131017修改，修正- /的一个门派错误
      //  if str<>'' then
    try
      pd^.AddLifeTick := strtodatetime(dstr);
    except
      pd^.AddLifeTick := Now;
    end;

    pd^.rEnegy := Db.GetFieldValueInteger(iName, 'Enegy');

    GuildObject.FGuildnotice := Db.GetFieldValueString(iName, 'Notice');

    GuildObject.level := Db.GetFieldValueInteger(iName, 'Level');
    GuildObject.MaxNum := Db.GetFieldValueInteger(iName, 'MaxNum');

    GuildObject.GuildTeam := Db.GetFieldValueInteger(iName, 'GuildTeam'); //2015.11.09 新增读取门派 团队
    //门派同盟
    str := Db.GetFieldValueString(iName, 'AllyGuild');
    for j := 0 to MAX_ALLYGUILD_COUNT - 1 do
    begin
      str := GetValidStr3(str, rdstr, ':');
      if rdstr <> '' then
        pd^.AllyGuild[j] := rdstr;
    end;

    pd^.rMaxEnegy := getMaxEnegy(GuildObject.level);

    Manager := ManagerList.GetManagerByServerID(pd^.MapID);
    if Manager <> nil then
    begin
      GuildObject.SetManagerClass(Manager);
      GuildObject.Initial;
      GuildObject.StartProcess;
    end else
    begin
      GuildObject.Initial;
    end;

    DataList.Add(GuildObject);
  end;

  DB.Free;

end;

procedure TGuildList.SaveToFile(aFileName: string);
var
  i, j: integer;
  str, rdstr: string;
  pd: PTCreateGuildData;
  GuildObject: TGuildObject;
  DB: TUserStringDb;
begin
  if not FileExists(aFileName) then exit;

  Db := TUserStringDb.Create;
  Db.LoadFromFile(aFileName);

  for i := 0 to Db.Count - 1 do
  begin
    Db.DeleteName(Db.GetIndexName(0));
  end;

  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    pd := GuildObject.GetSelfData;
    if pd^.Name = '' then continue;

    GuildObject.SaveToFile;

    Db.AddName(pd^.Name);

    Db.SetFieldValueString(pd^.Name, 'Title', pd^.Title);
    Db.SetFieldValueInteger(pd^.Name, 'MapID', pd^.MapID);
    Db.SetFieldValueInteger(pd^.Name, 'X', pd^.x);
    Db.SetFieldValueInteger(pd^.Name, 'Y', pd^.y);
    Db.SetFieldValueInteger(pd^.Name, 'Durability', pd^.Durability);
    Db.SetFieldValueInteger(pd^.Name, 'MaxDurability', pd^.MaxDurability);
    Db.SetFieldValueString(pd^.Name, 'GuildMagic', pd^.GuildMagic);
    Db.SetFieldValueInteger(pd^.Name, 'MagicExp', pd^.MagicExp);
    Db.SetFieldValueString(pd^.Name, 'MakeDate', pd^.MakeDate);
    Db.SetFieldValueString(pd^.Name, 'Sysop', pd^.Sysop);
    for j := 0 to MAX_SUBSYSOP_COUNT - 1 do
    begin
      Db.SetFieldValueString(pd^.Name, 'SubSysop' + IntToStr(j), pd^.SubSysop[j]);
    end;
    for j := 0 to MAX_GUILDNPC_COUNT - 1 do
    begin
      str := pd^.GuildNpc[j].rName + ':';
      str := str + IntToStr(pd^.GuildNpc[j].rx) + ':';
      str := str + IntToStr(pd^.GuildNpc[j].ry) + ':';
      str := str + IntToStr(pd^.GuildNpc[j].rSex) + ':';
      if pd^.GuildNpc[j].rName = '' then str := '';
      Db.SetFieldValueString(pd^.Name, 'Npc' + IntToStr(j), str);
    end;
    for j := 0 to MAX_GUILDWEAR_COUNT - 1 do
    begin
      str := '';
      if pd^.GuildWear[j].rItemName <> '' then
      begin
        str := pd^.GuildWear[j].rItemName + ':';
        str := str + IntToStr(pd^.GuildWear[j].rColor) + ':';
        str := str + IntToStr(pd^.GuildWear[j].rItemCount) + ':';
      end;
      Db.SetFieldValueString(pd^.Name, 'Wear' + IntToStr(j), str);
    end;
    Db.SetFieldValueInteger(pd^.Name, 'BasicPoint', pd^.BasicPoint);
    Db.SetFieldValueInteger(pd^.Name, 'AwardPoint', pd^.AwardPoint);
    Db.SetFieldValueInteger(pd^.Name, 'BattleRejectCount', pd^.BattleRejectCount);
    Db.SetFieldValueString(pd^.Name, 'ChallengeGuild', pd^.ChallengeGuild);
    Db.SetFieldValueString(pd^.Name, 'ChallengeGuildUser', pd^.ChallengeGuildUser);
    Db.SetFieldValueString(pd^.Name, 'ChallengeDate', pd^.ChallengeDate);
    Db.SetFieldValueString(pd^.Name, 'Notice', GuildObject.FGuildnotice);
    Db.SetFieldValueInteger(pd^.Name, 'Level', pd^.FguildLeve);
    Db.SetFieldValueInteger(pd^.Name, 'Enegy', pd^.rEnegy);
    Db.SetFieldValueInteger(pd^.Name, 'MaxNum', pd^.FguildMaxNum);
    if pd^.AddLifeTick <> 0 then
      Db.SetFieldValuestring(pd^.Name, 'AddLifeTick', datetimetostr(pd^.AddLifeTick)) //20131017修改，修正- /的一个门派错误
    else Db.SetFieldValuestring(pd^.Name, 'AddLifeTick', datetimetostr(now));

    Db.SetFieldValueInteger(pd^.Name, 'GuildTeam', pd^.FGuildTeam); //2015-11-09新增保存门派 团队

    //门派同盟
    str := '';
    for j := 0 to MAX_ALLYGUILD_COUNT - 1 do
    begin
      if (pd^.AllyGuild[j] <> '') and (GuildList.GetGuildObject(pd^.AllyGuild[j]) <> nil) then
      begin
        str := pd^.AllyGuild[j] + ':';
      end;
    end;
    Db.SetFieldValueString(pd^.Name, 'AllyGuild', str);
  end;

  Db.SaveToFile('.\Guild\CreateGuild.SDB');
  Db.Free;
end;

procedure TGuildList.killstateUPdate(CurTick: integer); //攻击状态 更新
var
  aweek: integer;
  Hour, Min, Sec, MSec: Word;
begin
  if GetItemLineTimeSec(CurTick - FKillstateUPdateCurTick) < 30 then exit; //30秒检查一次
  FKillstateUPdateCurTick := CurTick;

  aweek := DayOfTheWeek(NOW);
  DecodeTime(now(), Hour, Min, Sec, MSec);
  if HitListArr[aweek, hour] <> Killstate then
    Killstate := HitListArr[aweek, hour];
end;

procedure TGuildList.Update(CurTick: integer);
var
  i, j: Integer;
  DeleteGuildObject, GuildObject: TGuildObject;
  StartPos, GuildProcessCount: Integer;
begin
  killstateUPdate(CurTick);
  if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
  FDCurTick := CurTick;

  GuildProcessCount := (DataList.Count * 4 div 100);
  if GuildProcessCount = 0 then GuildProcessCount := DataList.Count;

  GuildProcessCount := ProcessListCount;

  if DataList.Count > 0 then
  begin
    StartPos := CurProcessPos;
    for i := 0 to GuildProcessCount - 1 do
    begin
      if CurProcessPos >= DataList.Count then CurProcessPos := 0;
      GuildObject := DataList.Items[CurProcessPos];
            // if (GuildObject.SelfData.Durability <= 0) or (GuildObject.FboAllowDelete = true) then begin
      if GuildObject.FboAllowDelete = true then
      begin
        GuildObject.DelUser_ForceAll; //通知  所有人
        GuildObject.EndProcess;
        GuildObject.Free;
        DataList.Delete(CurProcessPos);
      end else
      begin
        try
          GuildObject.Update(CurTick);
        except
          frmMain.WriteLogInfo(format('TGuild.Update (%s) exception', [GuildObject.GuildName]));
          exit;
        end;
      end;
      Inc(CurProcessPos);
      if CurProcessPos = StartPos then break;
    end;
  end;

    //Killstate
end;
//保存 当前 灭门派

procedure TGuildList.CompactGuild;
var
  i: Integer;
  GuildObject: TGuildObject;
  Str, iName: string;
  buffer: array[0..1024 * 8 - 1] of char;
  DB: TUserStringDB;
  Stream: TFileStream;
begin
  if not FileExists('.\Guild\DeletedGuild.SDB') then
  begin
    Str := 'Index,DeletedDate,Name,Durability,X,Y,Sysop,SubSysop0,SubSysop1,SubSysop2,GuildMagic,MakeDate,MagicExp' + #13#10;
    StrPCopy(@buffer, Str);
    Stream := TFileStream.Create('.\Guild\DeletedGuild.SDB', fmCreate);
    Stream.WriteBuffer(buffer, StrLen(@buffer));
    Stream.Free;
  end;

  DB := TUserStringDB.Create;
  DB.LoadFromFile('.\Guild\DeletedGuild.SDB');

  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = '' then continue;
    if GuildObject.SelfData.Durability <= 0 then
    begin
      iName := IntToStr(DB.Count);
      DB.AddName(iName);
      DB.SetFieldValueString(iName, 'DeletedDate', DateToStr(Date));
      DB.SetFieldValueString(iName, 'Name', GuildObject.GuildName);
      DB.SetFieldValueInteger(iName, 'Durability', GuildObject.SelfData.Durability);
      DB.SetFieldValueInteger(iName, 'X', GuildObject.SelfData.X);
      DB.SetFieldValueInteger(iName, 'Y', GuildObject.SelfData.Y);
      DB.SetFieldValueString(iName, 'Sysop', GuildObject.SelfData.Sysop);
      DB.SetFieldValueString(iName, 'SubSysop0', GuildObject.SelfData.SubSysop[0]);
      DB.SetFieldValueString(iName, 'SubSysop1', GuildObject.SelfData.SubSysop[1]);
      DB.SetFieldValueString(iName, 'SubSysop2', GuildObject.SelfData.SubSysop[2]);
      DB.SetFieldValueString(iName, 'GuildMagic', GuildObject.SelfData.GuildMagic);
      DB.SetFieldValueString(iName, 'MakeDate', GuildObject.SelfData.MakeDate);
      DB.SetFieldValueInteger(iName, 'MagicExp', GuildObject.SelfData.MagicExp);

      GuildObject.boAllowDelete := true;
      try
        DeleteFile('.\Guild\' + GuildObject.GuildName + 'GUser.SDB');
      except
      end;
    end;
  end;

  DB.SaveToFile('.\Guild\DeletedGuild.SDB');
  DB.Free;

  MagicClass.CompactGuildMagic;
end;
//正常 唯一 删除门派途径

procedure TGuildList.DeleteStone(aGuildName: string);
var
  i: Integer;
  GuildObject: TGuildObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = aGuildName then
    begin
      GuildObject.SelfData.Durability := 0;
      CompactGuild; //修正 门派 灭亡 门派武功不消失
      exit;
    end;
  end;
end;

function TGuildList.GetGuildObject(aGuildName: string): TGuildObject;
var
  i: Integer;
  GuildObject: TGuildObject;
begin
  Result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = aGuildName then
    begin
      Result := GuildObject;
      exit;
    end;
  end;
end;

  //检测门派 团队 是否已存在

function TGuildList.CheckGuildTeam(ateam: integer): boolean;
var
  i: Integer;
  GuildObject: TGuildObject;
begin
  Result := False;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildTeam = ateam then
    begin
      Result := True;
      exit;
    end;
  end;
end;

function TGuildList.GetGuildObjectByMagicName(aMagicName: string): TGuildObject;
var
  i: Integer;
  GuildObject: TGuildObject;
begin
  Result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.boAllowDelete = false then //同时要测试 门派是否被灭
      if GuildObject.SelfData.GuildMagic = aMagicName then
      begin
        Result := GuildObject;
        exit;
      end;
  end;
end;

function TGuildList.GetCharInformation(aName: string): string;
var
  i, j: Integer;
  GuildObject: TGuildObject;
begin
  Result := '';

  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = '' then continue;
    if GuildObject.SelfData.Sysop = aName then
    begin
      Result := format('%s门派的门主', [GuildObject.GuildName]);
      exit;
    end;
    for j := 0 to 3 - 1 do
    begin
      if GuildObject.SelfData.SubSysop[j] = aName then
      begin
        Result := format('%门派的副门主', [GuildObject.GuildName]);
        exit;
      end;
    end;
  end;
end;

function TGuildList.GetInformation(aName: string): string;
var
  i: Integer;
  GuildObject: TGuildObject;
begin
  Result := '';

  for i := 0 to DataList.Count - 1 do
  begin
    GuildObject := DataList.Items[i];
    if GuildObject.GuildName = '' then continue;
    Result := GuildObject.GetInformation;
  end;
end;
//TRUE 表示占用

function TGuildList.isGuildStoneArea(ax, ay: integer; amap: TMaper): boolean;
var
  nIndex, i, j: Integer;
begin
  Result := false;
  if amap = nil then exit;
  for i := -1 to 1 do
  begin
    for j := -1 to 1 do
    begin
            //地图范围
      if (i + ay < 0) or (j + ax < 0) or (i + ay > amap.Height) or (j + ax > amap.Width) then
      begin
        Result := true;
        exit;
      end;
            //是否可站立
      if amap.getMoveable(j + ax, i + ay) = false then
      begin
        Result := true;
        exit;
      end;
            //地图表面类型
      nIndex := amap.GetAreaIndex(j + ax, i + ay);
      if nIndex = 0 then
      begin
        Result := true;
        exit;
      end;
            //地图表面是否可创建门派
      if AreaClass.CanMakeGuild(nIndex) = false then
      begin
        Result := true;
        exit;
      end;
            //是否有门派
      nIndex := amap.getUser(j + ax, i + ay);
      if nIndex > 0 then
        if isStaticItemId(nIndex) then
        begin
          Result := true;
          exit;
        end;
    end;
  end;
end;

function TGuildList.getMaxEnegy(level: integer): integer;
var
  pp: pTGuildsysdata;
begin
  result := 0;
  pp := Guildsys.get(level);
  if pp <> nil then
  begin
    result := pp.rMaxEnegy;
  end;
end;

function TGuildObject.getGuildUserList: TGuildUserList;
begin
  Result := GuildUserList;
end;

procedure TGuildObject.setMaxDurability(aMaxDurability: Integer);
begin
  SelfData.MaxDurability := aMaxDurability;
  if SelfData.Durability > SelfData.MaxDurability then SelfData.Durability := SelfData.MaxDurability;
end;

procedure TGuildObject.setMaxNum(aMaxNum: Integer);
begin
  SelfData.FguildMaxNum := aMaxNum;
end;

procedure TGuildObject.setGuildTeam(aGuildTeam: Integer);
begin
  SelfData.FGuildTeam := aGuildTeam;
end;

procedure TGuildObject.SetAddAllyGuild(bo: boolean);
begin
  boAddAllyGuild := bo;
end;

function TGuildObject.GetAddAllyGuild: boolean;
begin
  Result := boAddAllyGuild;
end;


function getGuildObjectByName(aGuildName: string): Integer;
var
  guildobj: TGuildObject;
begin
  Result := -1;
  if GuildList <> nil then
  begin
    guildobj := GuildList.GetGuildObject(aGuildName);
    if guildobj <> nil then
      Result := Integer(guildobj);
  end;
end;

function transIntToGuildObject(uGuildObject: integer): TGuildObject;
var
  guildobj: Tguildobject;
begin
  result := nil;
  if uGuildObject = -1 then Exit;
  if not (TObject(uGuildObject) is Tguildobject) then exit;
  Result := Tguildobject(uGuildObject);
end;

function GuildSetDurabilityMaxNew(uGuildObject: integer; value: integer): boolean; //设置最大血量
var
  guildobj: Tguildobject;
begin
  result := false;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  guildobj.setlifeMax(value);
  Result := true;
end;

function GuildSetDurabilityNew(uGuildObject: integer; value: integer): boolean; //设置当前血量
var
  guildobj: Tguildobject;
begin
  result := false;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  guildobj.setlifex(value);
  Result := true;
end;

function GuildGetDurabilityMaxNew(uGuildObject: integer): integer; //获得最大血量
var
  guildobj: Tguildobject;
begin
  result := 0;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  result := guildobj.getLifeMax;
end;

function GuildGetDurabilityNew(uGuildObject: integer): integer; //获得当前血量
var
  guildobj: Tguildobject;
begin
  result := 0;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  result := guildobj.getLife;
end;

function GuildGetLevelNew(uGuildObject: integer): integer; //获得等级
var
  guildobj: Tguildobject;
begin
  result := 0;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  result := guildobj.level;

end;

function GuildLevelUpdateNew(uGuildObject: integer; anum: integer): boolean; //修改门派等级
var
  guildobj: Tguildobject;
begin
  result := False;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  guildobj.level := anum;
  result := true;
end;

function GuildGetEnegyNew(uGuildObject: integer): integer; //获得元气
var
  guildobj: Tguildobject;
begin
  result := 0;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  result := guildobj.Enegy;
end;

function GuildEnegyUpdateNew(uGuildObject: integer; anum: integer): boolean; //修改元气
var
  guildobj: Tguildobject;
begin
  result := False;
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  guildobj.Enegy := anum;
  result := true;
end;

function GuildIsGuildSysopNew(uObject: integer): boolean; //测试 是否 是门主
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  if Tguildobject(user.uGuildObject).IsGuildSysop(user.name) = false then exit;
  result := true;
end;

function GuildIsGuildSubSysopNew(uObject: integer): boolean; //测试 是否 是副门主
var
  USER: TUser;

begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  if Tguildobject(user.uGuildObject).IsGuildSubSysop(user.name) = false then exit;
  result := true;
end;

function GuildGetNameNew(uGuildObject: integer): string;
var
  guildobj: Tguildobject;
begin
  result := '';
  guildobj := transIntToGuildObject(uGuildObject);
  if guildobj = nil then Exit;
  result := guildobj.GuildName;

end;

function TGuildObject.GetGuildInfo2(aUser: TUser): boolean;

var
  p: PTGuildUserData;
begin
  result := false;
  p := GuildUserList.GetName(auser.name);
  if p = nil then exit;
  result := true;
  p.ronline := true;

  p.rage := auser.GetAge;
  p.rEnergy := aUser.getcEnergy;
  p.rGuildPoint := aUser.getGuildPoint;
  if IsGuildSysop(p.rName) then p.rjob := 1
  else if IsGuildSubSysop(p.rName) then p.rjob := 2
  else p.rjob := 0;

  GetGuildInfoFrom(auser); //给自己发 门派 列表
end;

function TGuildList.GetGuildObjectByIndex(aindex: Integer): TGuildObject;
begin
  result := nil;
  if (aindex < 0) or (aindex >= DataList.Count) then exit;
  result := DataList.Items[aindex];
end;

procedure TGuildList.getBillboard;
var
  i: Integer;
  guild: TGuildObject;
begin
  for i := 0 to Count - 1 do
  begin
    guild := GetGuildObjectByIndex(i);
    if guild <> nil then
    begin
      G_BillboardGuilds.add(guild.GetGuildSysop, guild.GuildUserList.getAllEnergy, guild.GuildUserList.count, guild.FGuildName);
    end;
  end;
end;

initialization
  begin
    RegisterRoutine('function GuildSetDurabilityNew(uGuildObject: integer; value: integer): boolean;', @GuildSetDurabilityNew); //设置当前血量
    RegisterRoutine('function GuildGetDurabilityNew(uGuildObject: integer): integer;', @GuildGetDurabilityNew); //获得当前血量
    RegisterRoutine('function GuildSetDurabilityMaxNew(uGuildObject: integer; value: integer): boolean;', @GuildSetDurabilityMaxNew); //设置最大血量
    RegisterRoutine('function GuildGetDurabilityMaxNew(uGuildObject: integer): integer;', @GuildGetDurabilityMaxNew); //获得最大血量
    RegisterRoutine('function getGuildObjectByName(aGuildName:string):Integer;', @getGuildObjectByName); //根据门派名获取门派对象
    RegisterRoutine('function GuildGetLevelNew(uGuildObject: integer): integer;', @GuildGetLevelNew); //获得门派等级
    RegisterRoutine('function GuildLevelUpdateNew(uGuildObject: integer; anum: integer): boolean;', @GuildLevelUpdateNew); //修改门派等级
    RegisterRoutine('function GuildGetEnegyNew(uGuildObject: integer): integer;', @GuildGetEnegyNew); //获得元气
    RegisterRoutine('function GuildEnegyUpdateNew(uGuildObject: integer; anum: integer): boolean;', @GuildEnegyUpdateNew); //修改元气
    RegisterRoutine('function GuildIsGuildSubSysopNew(uObject:integer):boolean;', @GuildIsGuildSubSysopNew); //测试 是否 是副门主
    RegisterRoutine('function GuildIsGuildSysopNew(uObject:integer):boolean;', @GuildIsGuildSysopNew); //测试 是否 是门主
    RegisterRoutine('function GuildGetNameNew(uGuildObject: integer): string;', @GuildGetNameNew); //从门派对象中获取门派名

  end;
end.

