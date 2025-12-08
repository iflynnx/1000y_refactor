unit uManager;
//管理 类 在这里管理

interface

uses
  SysUtils, Classes, DefType, AUtil32, uAnsTick, windows, PaxScripter, svClass,
  Lua, LuaLib, Dialogs, LuaRegisterClass, IniFiles;

type
    {
    MapID,SmpName,MapName,TilName,ObjName,RofName,SoundBase,SoundEffect,MapTitle,boUseBowMagic,boUseChemistDrug,
    boUseDrug,boGetExp,boBigSay,boUsePowerItem,boUseGuildMagic,boUseMagic,boUseRiseMagic,boUseWindMagic,boUseBestMagic
    ,boUseBestSpecialMagic,boUsePowerLevel,boUseEtcMagic,boCanChangeMagic,boMakeGuild,boItemDrop,boPosDie,boHit,boWeather
    ,boPrison,boChangeLife,ChangePercentage,ChangeDelay,ChangeSize,Attribute,RegenInterval,EffectInterval,TargetServerID
    ,TargetX,TargetY,boDark,boRain,boPick,Script,LoginServerID,LoginX,LoginY,boSetGroupKey,GroupKey,boPK,boEvent,EventAge
    ,EventID,EventX,EventY,boNotAllowPK,boShop,SubMap,MotherMap,boNotUseHideItem,boShowMiniMap,boFirstPickUp,UseDay,
    StartHour,EndHour,SoundStart,SoundEnd,UseDrugName,boNotDeal,Scripter,boUpdateTime,
    }
  TManager = class
  private
    RegenedTick: Integer;

              //复活控制

  public
    ServerID: integer; //地图ID
    SmpName: string; //SMP地图 名字
    MapName: string; //地图名字
    ObjName: string; //地图 物体 名字
    RofName: string; //地图 顶
    TilName: string; //地图 地板
    Title: string; //地图标题
//        boMsg: boolean;                                                         //是否 公告
    Scripter: string; //脚本
    SoundBase: string; //地图 声音
    SoundEffect: integer; //地图声音
    
    boUseGuildMagic,boUseMagic,boUseRiseMagic,boUseBestMagic,
    boUseBestSpecialMagic,boUseWindMagic,
    boUseBowMagic,boUseEtcMagic,boCanChangeMagic: Boolean;

    boUseDrug: Boolean;
    boGetExp: Boolean;
    boBigSay: Boolean;
    boMakeGuild: Boolean;
    boPosDie: Boolean;
    boHit: Boolean;
    boWeather: Boolean;
    boPrison: Boolean;
    boSetGroupKey: Boolean; //2015.10.15增加团队是否统一
    GroupKey: Integer; //2015.10.15增加地图团队;
    boNotDeal: Boolean; //是否不允许交易
    boItemDrop: Boolean; //允许丢弃道具
    //2015.11.12新增地图下线后上线地图与坐标
    LoginServerID: Integer;
    LoginX: Integer;
    LoginY: Integer;

    EffectTick: Integer;
    EffectInterval: Integer;
    RegenInterval: Integer; //定时间 开放
    TargetServerID: Integer;
    TargetX, TargetY: Word;
    StartHour: integer; //(开始时间) 单位:小时(服务器时间为准)
    EndHour: integer; //(关闭时间) 单位:小时(服务器时间为准)
    TotalHour, TotalMin, TotalSec: Word;
    RemainHour, RemainMin, RemainSec: Word;
    Phone: Pointer; //本类 创建  {通知} 分组管理所有物体
    Maper: Pointer; //本类 创建  {地图}
    MonsterList: Pointer; //本类 创建  {怪物}
    ItemList: Pointer; //本类 创建  {物品}
    NpcList: Pointer; //本类 创建  {NPC}
    StaticItemList: Pointer; //本类 创建  {不动 物品}
    DynamicObjectList: Pointer; //本类 创建  {活动 物品}
    VirtualObjectList: pointer; //本类 创建 虚拟物品
    MineObjectList: Pointer;
    MsgTcik: integer; //公告时间
    UpdateTcik: integer;
    boUPdateTime: boolean;
    DupTickList: TStringHash;  //2016.04.05 在水一方 副本用
    boOfflineProtect: boolean;
    OfflineProtectInterval: Integer;
    boIsDuplicate: boolean; //<<<
    boIsDupTime: Tdatetime; //<<<

        //脚本
    FScriptClass: TPaxScripter;
    FBaseLua: TLua; //lua脚本
    FBaseLuaFileName: string; //lua脚本  路径
    boChangeLife: boolean; //活力 改变 开关
    ChangePercentage, //百分比
      ChangeDelay, //时间间隔
      ChangeSize, //数量
      Attribute: integer; //1，百分比 扣活力； 2，无水，扣数量活力；  3增加活力数量；
    boAQClear: boolean;
    MonsterCreateClass_p: TMonsterCreateClass; //本类不创建
    NpcCreateClass_p: TNpcCreateClass; //本类不创建
    DynamicCreateClass_p: TDynamicCreateClass; //本类不创建
  public
    constructor Create();
    destructor Destroy; override;
    procedure Update(CurTick: LongInt);
    procedure CalcTime(nTick: Integer; var nHour, nMin, nSec: Word);
    function CallScriptFunction(const Name: string; const Params: array of const): integer;
    procedure SetScript(aScript, afilename: string);
    procedure SetLuaScript(aScript, afilename: string);
    function CallLuaScriptFunction(const Name: string; const Params: array of const): string;
    procedure Initial;
    procedure Regen;
    function ChkDupTick(aCharName: string): Boolean;
    function RemainTickById: integer;
  end;
    //地图 为单位 管理列表

  TManagerList = class
  private
    DataList: TList;
    MonsterCreateListClass: TMonsterCreateListClass;
    NpcCreateListClass: TNpcCreateListClass;
    DynamicCreateListClass: TDynamicCreateListClass;
    function GetCount: Integer;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReLoadFromFile;
    function LoadFromFile(aFileName: string): Boolean;
    procedure Update(CurTick: LongInt);
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
    function GetManagerByIndex(aIndex: Integer): TManager;
    function GetManagerByServerID(aServerID: Integer): TManager;
    function GetManagerByTitle(aTitle: string): TManager;
        // function    GetManagerByGuild (aGuild, aName : String) : TManager;
    procedure SaveFileCsv;
    property Count: Integer read GetCount;

    function GetNewMap(amapid, anewid: Integer; atitle: string): Boolean; //2015.11.10新增复制地图

  end;

var
  ManagerList: TManagerList;

implementation

uses
  svMain, UserSDB, MapUnit, FieldMsg, uMonster, uNpc, BasicObj, uGuild, uUser,
  uDoorGen, FSockets;

constructor TManager.Create();
begin
  DynamicCreateClass_p := nil;
  NpcCreateClass_p := nil;
  MonsterCreateClass_p := nil;
  FScriptClass := nil;
  boAQClear := false;
  UpdateTcik := 0;
  MsgTcik := 0;
  EffectTick := 0;
  EffectInterval := 0;
  RegenedTick := mmAnsTick;

  MonsterList := nil;
  ItemList := nil;
  StaticItemList := nil;
  DynamicObjectList := nil;
  NpcList := nil;

  Phone := nil;
  Maper := nil;
  VirtualObjectList := nil;
  MineObjectList := nil;
  DupTickList := TStringHash.Create;
end;

destructor TManager.Destroy;
begin
  if MineObjectList <> nil then
    TMineObjectList(MineObjectList).Free;
  if VirtualObjectList <> nil then
    TVirtualObjectList(VirtualObjectList).Free;
  if MonsterList <> nil then
    TMonsterList(MonsterList).Free;
  if ItemList <> nil then
    TItemList(ItemList).Free;
  if StaticItemList <> nil then
    TStaticItemList(StaticItemList).Free;
  if DynamicObjectList <> nil then
    TDynamicObjectList(DynamicObjectList).Free;
  if NpcList <> nil then
    TNpcList(NpcList).Free;

  if Phone <> nil then
    TFieldPhone(Phone).Free;
  if Maper <> nil then
    TMaper(Maper).Free;
  DupTickList.Free;

  inherited Destroy;
end;

procedure TManager.CalcTime(nTick: Integer; var nHour, nMin, nSec: Word);
var
  SecValue: Integer;
begin
  SecValue := nTick div 100;
  nHour := SecValue div 3600;
  SecValue := SecValue - nHour * 3600;
  nMin := SecValue div 60;
  SecValue := SecValue - nMin * 60;
  nSec := SecValue;
end;

function TManager.CallScriptFunction(const Name: string; const Params: array of const): integer;
begin
  result := 0;
  if FScriptClass <> nil then
  begin
    if FScriptClass.GetMemberID(Name) <> 0 then
      result := FScriptClass.CallFunction(Name, Params);
  end;
end;

procedure TManager.SetScript(aScript, afilename: string);
begin
  if aScript = '' then
  begin
    FScriptClass := nil;
    exit;
  end;

  if ScripterList.IsScripter(aScript) = false then
    ScripterList.LoadFile(aScript, afilename);

  if ScripterList.GetScripter(aScript, FScriptClass) = false then
  begin
    FScriptClass := nil;
  end;
end;

procedure TManager.Regen();
begin
    //2015年10月14日 11:05:43新增设置(RegenInterval > 0) 才踢出所有人
  if RegenInterval > 0 then
  begin
    DupTickList.Clear;
    //1，纪录时间
    RegenedTick := mmAnsTick;
    //2，踢出所有人
    if (TargetX > 0) and (TargetY > 0) then
    begin
      UserList.MoveByServerID(ServerID, TargetServerID, TargetX, TargetY, 0);
    end
    else
    begin
    //没有配置 移动到 长城以南 500 500
      UserList.MoveByServerID(ServerID, 1, 500, 500, 0);
    end;
  end;

  if ItemList <> nil then
    TItemList(ItemList).AllClear;

  if MonsterList <> nil then
    TMonsterList(MonsterList).ReLoad;

  if NpcList <> nil then
    TNpcList(NpcList).ReLoad;

  if DynamicObjectList <> nil then
    TDynamicObjectList(DynamicObjectList).ReLoad;

  MsgTcik := 0;
  //CallScriptFunction('OnRegen', [integer(self), mmAnsTick]);
  CallLuaScriptFunction('OnRegen', [integer(self), mmAnsTick]);
end;


procedure TManager.Update(CurTick: LongInt);
begin
  if (RegenInterval > 0) and (RegenedTick + 100 <= CurTick) then
  begin
    CalcTime(RegenedTick + RegenInterval - CurTick, RemainHour, RemainMin, RemainSec);
    if CurTick >= (MsgTcik + 6000) then
    begin
      MsgTcik := CurTick;
      //CallScriptFunction('OnRegenFront', [integer(self), RemainHour, RemainMin, RemainSec]);
      CallLuaScriptFunction('OnRegenFront', [integer(self), RemainHour, RemainMin, RemainSec]);
    end;
  end;

  if ((RegenInterval > 0) and (RegenedTick + RegenInterval <= CurTick)) then
  begin
    Regen;
        //定时 重新 开放
       // RegenedTick := CurTick;

       // if (TargetX > 0) and (TargetY > 0) then
       // begin
       //     UserList.MoveByServerID(ServerID, TargetServerID, TargetX, TargetY);
        //end;

       // TMonsterList(MonsterList).ReLoadFromFile;
       // TNpcList(NpcList).ReLoadFromFile;
       // TDynamicObjectList(DynamicObjectList).ReLoadFromFile;
        //TItemList(ItemList).AllClear;

       { if ObjectChecker.Manager = Self then
        begin
            ObjectChecker.RegenData;
        end;}
       // MsgTcik := 0;
       // CallScriptFunction('OnRegen', [integer(self), CurTick]);
  end
  else
  begin
    TMonsterList(MonsterList).Update(CurTick);
    TItemList(ItemList).Update(CurTick);
    TStaticItemList(StaticItemList).Update(CurTick);
    TDynamicObjectList(DynamicObjectList).Update(CurTick);
    TNpcList(NpcList).Update(CurTick);
    TMineObjectList(MineObjectList).Update(CurTick);

    if SoundEffect <> 0 then
    begin
      if CurTick >= EffectTick + EffectInterval then
      begin
        UserList.SendSoundEffect(Self, SoundEffect);
        EffectTick := CurTick;
      end;
    end;
  end;
  if boUPdateTime and (CurTick >= UpdateTcik + 600) then
  begin
    UpdateTcik := CurTick;
    //CallScriptFunction('OnUpdate', [integer(self), CurTick]);
    CallLuaScriptFunction('OnUpdate', [integer(self), ServerID, CurTick]);
  end;
end;

function TManager.ChkDupTick(aCharName: string): boolean; //2016.04.05 在水一方
var
  ni: Integer;
begin
  Result := false;
  ni := DupTickList.ValueOf(aCharName);
  if ni <> -1 then begin
    if mmAnsTick - ni > OfflineProtectInterval * 100 then
      DupTickList.Remove(aCharName)
    else
      Result := true;
  end;
end;

function TManager.RemainTickById: Integer; //2016.04.05 在水一方
var
  n: Integer;
begin
  n := RegenedTick + RegenInterval - mmAnsTick;
  if n < 0 then n := 0;
  Result := n;
end;


constructor TManagerList.Create;
begin
  MonsterCreateListClass := TMonsterCreateListClass.Create;
  NpcCreateListClass := TNpcCreateListClass.Create;
  DynamicCreateListClass := TDynamicCreateListClass.Create;
  DataList := TList.Create;
//    LoadFromFile('.\Init\MAP.SDB');
end;

destructor TManagerList.Destroy;
begin

  Clear;
  MonsterCreateListClass.Free;
  NpcCreateListClass.Free;
  DynamicCreateListClass.Free;
  DataList.free;
end;

function TManagerList.GetCount: Integer;
begin
  Result := 0;
  if DataList <> nil then
  begin
    Result := DataList.Count;
  end;

  inherited Destroy;
end;

procedure TManager.Initial;
begin
  //SetScript(Scripter, format('.\%s\%s\%s.pas', ['Script', 'Manager', Scripter]));
  //CallScriptFunction('OnInitial', [integer(Self), mmAnsTick]);
  SetLuaScript(Scripter, format('.\%s\%s\%s\%s.lua', ['Script', 'lua', 'Manager', Scripter]));
  CallLuaScriptFunction('OnInitial', [integer(Self), mmAnsTick]);
end;

procedure TManagerList.Clear;
var
  i: Integer;
  Manager: TManager;
begin
  if DataList <> nil then
  begin
    for i := 0 to DataList.Count - 1 do
    begin
      Manager := DataList.Items[i];
      if Manager <> nil then
        Manager.Free;
    end;
    DataList.Clear;
  end;
  MonsterCreateListClass.Clear;
  NpcCreateListClass.Clear;
  DynamicCreateListClass.Clear;
end;
//只能 创建的时候使用本过程载入,实力分布在各个物体上.不能释放.

function TManagerList.LoadFromFile(aFileName: string): Boolean;
var
  i, j: Integer;
  Manager: TManager;
  MapDB: TUserStringDB;
  iName: string;
begin
//    Result := false;
  //  Clear;
  MapDB := TUserStringDB.Create;
  try
    MapDB.LoadFromFile(aFileName);
    for i := 0 to MapDB.Count - 1 do
    begin
      iName := MapDB.GetIndexName(i);
      if iName = '' then
        Continue;
      j := _StrToInt(iName);
            //地图相关资源读入
      MonsterCreateListClass.add(j);
      NpcCreateListClass.add(j);
      DynamicCreateListClass.add(j);
            //
      Manager := TManager.Create();

      Manager.MonsterCreateClass_p := MonsterCreateListClass.get(j);
      Manager.NpcCreateClass_p := NpcCreateListClass.get(j);
      Manager.DynamicCreateClass_p := DynamicCreateListClass.get(j);

      Manager.ServerID := j;
      Manager.SmpName := MapDB.GetFieldValueString(iName, 'SmpName');
      Manager.MapName := MapDB.GetFieldValueString(iName, 'MapName');
      Manager.ObjName := MapDB.GetFieldValueString(iName, 'ObjName');
      Manager.RofName := MapDB.GetFieldValueString(iName, 'RofName');
      Manager.TilName := MapDB.GetFieldValueString(iName, 'TilName');
      Manager.Title := MapDB.GetFieldValueString(iName, 'MapTitle');
//            Manager.boMsg := MapDB.GetFieldValueBoolean(iName, 'boMsg');
      Manager.Scripter := MapDB.GetFieldValueString(iName, 'Scripter');

      Manager.SoundBase := MapDB.GetFieldValueString(iName, 'SoundBase');
            // Manager.SoundEffect := MapDB.GetFieldValueString(iName, 'SoundEffect');
      Manager.SoundEffect := MapDB.GetFieldValueInteger(iName, 'SoundEffect');

      Manager.boUseGuildMagic := MapDB.GetFieldValueBoolean(iName, 'boUseGuildMagic'); //允许使用门派武功
      Manager.boUseMagic := MapDB.GetFieldValueBoolean(iName, 'boUseMagic'); // 允许使用普通武功 　
      Manager.boUseRiseMagic := MapDB.GetFieldValueBoolean(iName, 'boUseRiseMagic'); // 允许使用上层武功 　
      Manager.boUseBestMagic := MapDB.GetFieldValueBoolean(iName, 'boUseBestMagic'); // 允许使用绝世武功 　
      Manager.boUseBestSpecialMagic := MapDB.GetFieldValueBoolean(iName, 'boUseBestSpecialMagic'); // 允许使用招式 　
      Manager.boUseWindMagic := MapDB.GetFieldValueBoolean(iName, 'boUseWindMagic'); // 允许使用掌风 　
      Manager.boUseBowMagic := MapDB.GetFieldValueBoolean(iName, 'boUseBowMagic'); // 允许使用远程武功 弓术、投法
      Manager.boUseEtcMagic := MapDB.GetFieldValueBoolean(iName, 'boUseEtcMagic'); // 允许使用辅助武功 风灵旋、灵动八方
      Manager.boCanChangeMagic := MapDB.GetFieldValueBoolean(iName, 'boCanChangeMagic'); // 允许切换武功


      Manager.boUseDrug := MapDB.GetFieldValueBoolean(iName, 'boUseDrug');
      Manager.boGetExp := MapDB.GetFieldValueBoolean(iName, 'boGetExp');
      Manager.boBigSay := MapDB.GetFieldValueBoolean(iName, 'boBigSay');
      Manager.boMakeGuild := MapDB.GetFieldValueBoolean(iName, 'boMakeGuild');
      Manager.boPosDie := MapDB.GetFieldValueBoolean(iName, 'boPosDie');
      Manager.boHit := MapDB.GetFieldValueBoolean(iName, 'boHit');
      Manager.boWeather := MapDB.GetFieldValueBoolean(iName, 'boWeather');
      Manager.boPrison := MapDB.GetFieldValueBoolean(iName, 'boPrison');

      Manager.boSetGroupKey := MapDB.GetFieldValueBoolean(iName, 'boSetGroupKey'); //2015.10.15增加团队是否统一
      Manager.GroupKey := MapDB.GetFieldValueInteger(iName, 'GroupKey'); //2015.10.15增加地图团队;
      Manager.boNotDeal := MapDB.GetFieldValueBoolean(iName, 'boNotDeal'); // 是否不允许交易
      Manager.boItemDrop := MapDB.GetFieldValueBoolean(iName, 'boItemDrop'); // 允许丢弃道具


      //2015.11.12新增地图下线后上线地图与坐标
      Manager.LoginServerID := MapDB.GetFieldValueInteger(iName, 'LoginServerID');
      Manager.LoginX := MapDB.GetFieldValueInteger(iName, 'LoginX');
      Manager.LoginY := MapDB.GetFieldValueInteger(iName, 'LoginY');

      Manager.RegenInterval := MapDB.GetFieldValueInteger(iName, 'RegenInterval');
      Manager.EffectInterval := MapDB.GetFieldValueInteger(iName, 'EffectInterval');

      Manager.TargetServerID := MapDB.GetFieldValueInteger(iName, 'TargetServerID');
      Manager.TargetX := MapDB.GetFieldValueInteger(iName, 'TargetX');
      Manager.TargetY := MapDB.GetFieldValueInteger(iName, 'TargetY');
      Manager.StartHour := MapDB.GetFieldValueInteger(iName, 'StartHour');
      Manager.EndHour := MapDB.GetFieldValueInteger(iName, 'EndHour');

      Manager.boChangeLife := MapDB.GetFieldValueBoolean(iName, 'boChangeLife'); //: boolean;                                                  //活力 改变 开关
      Manager.ChangePercentage := MapDB.GetFieldValueInteger(iName, 'ChangePercentage'); //                                                       //百分比
      Manager.ChangeDelay := MapDB.GetFieldValueInteger(iName, 'ChangeDelay'); //,                                                        //时间间隔
      Manager.ChangeSize := MapDB.GetFieldValueInteger(iName, 'ChangeSize'); //,                                                         //数量
      Manager.Attribute := MapDB.GetFieldValueInteger(iName, 'Attribute'); //: integer;                                                 //1，百分比 扣 2，实际值扣  ，3恢复 实际增加

//StartHour(开始时间) 单位:小时(服务器时间为准)
//EndHour(关闭时间) 单位:小时(服务器时间为准)
      Manager.boUPdateTime := MapDB.GetFieldValueBoolean(iName, 'boUPdateTime');
      Manager.boAQClear := MapDB.GetFieldValueBoolean(iName, 'boAQClear');

      Manager.boOfflineProtect := MapDB.GetFieldValueBoolean(iName, 'boOfflineProtect');                                                //数量
      Manager.OfflineProtectInterval := MapDB.GetFieldValueInteger(iName, 'OfflineProtectInterval');                                      //数量
      Manager.boIsDuplicate := MapDB.GetFieldValueBoolean(iName, 'boIsDuplicate');

      Manager.CalcTime(Manager.RegenInterval, Manager.TotalHour, Manager.TotalMin, Manager.TotalSec);
      Manager.CalcTime(Manager.RegenInterval, Manager.RemainHour, Manager.RemainMin, Manager.RemainSec);

      Manager.Maper := TMaper.Create('.\Smp\' + Manager.SmpName); //地图
      Manager.Phone := TFieldPhone.Create(Manager);
            //地图创建 怪物列表

            //clear
      Manager.MonsterList := nil; //怪物列表
      Manager.NpcList := nil; //NPC 列表
      Manager.ItemList := nil; //物品 列表
      Manager.StaticItemList := nil; //静止 物品 列表
      Manager.DynamicObjectList := nil; //动 物体
      Manager.VirtualObjectList := nil;
      Manager.MineObjectList := nil;

            //create
      Manager.ItemList := TItemList.Create(Manager); //物品 列表
      Manager.StaticItemList := TStaticItemList.Create(Manager); //静止 物品 列表
      Manager.MonsterList := TMonsterList.Create(Manager); //怪物列表
      Manager.NpcList := TNpcList.Create(Manager); //NPC 列表
      Manager.DynamicObjectList := TDynamicObjectList.Create(Manager); //动 物体
      Manager.VirtualObjectList := TVirtualObjectList.Create(Manager);
      Manager.MineObjectList := TMineObjectList.Create(Manager);

            //load
      TMonsterList(Manager.MonsterList).ReLoad;
      tNpcList(Manager.NpcList).ReLoad;
      tDynamicObjectList(Manager.DynamicObjectList).ReLoad;
      TMineObjectList(Manager.MineObjectList).LoadFile;
      tVirtualObjectList(Manager.VirtualObjectList).LoadFile;

      Manager.Initial;

      DataList.Add(Manager);

    end;
  finally
    MapDB.Free;
  end;

  Result := true;
end;

procedure TManagerList.ReLoadFromFile;
var
  i, j: Integer;
  Manager: TManager;
begin
// TManager 实力 分布在各个实体上 不能释放
  for i := 0 to DataList.Count - 1 do
  begin
    Manager := DataList[i];
    if Manager <> nil then
    begin

      TMonsterList(Manager.MonsterList).Free; //怪物列表
      TNpcList(Manager.NpcList).Free; //NPC 列表
      TItemList(Manager.ItemList).Free; //物品 列表
      TStaticItemList(Manager.StaticItemList).Free; //静止 物品 列表
      TDynamicObjectList(Manager.DynamicObjectList).Free; //动 物体
      TVirtualObjectList(Manager.VirtualObjectList).Free;
      TMineObjectList(Manager.MineObjectList).Free;

      Manager.MonsterList := nil; //怪物列表
      Manager.NpcList := nil; //NPC 列表
      Manager.ItemList := nil; //物品 列表
      Manager.StaticItemList := nil; //静止 物品 列表
      Manager.DynamicObjectList := nil; //动 物体
      Manager.VirtualObjectList := nil;
      Manager.MineObjectList := nil;

      Manager.MonsterCreateClass_p := nil;
      Manager.NpcCreateClass_p := nil;
      Manager.DynamicCreateClass_p := nil;
    end;
  end;
  MonsterCreateListClass.Clear;
  NpcCreateListClass.Clear;
  DynamicCreateListClass.Clear;

  for i := 0 to DataList.Count - 1 do
  begin
    Manager := DataList[i];
    if Manager <> nil then
    begin
      j := Manager.ServerID;
      MonsterCreateListClass.add(j);
      NpcCreateListClass.add(j);
      DynamicCreateListClass.add(j);
            //
      Manager.MonsterCreateClass_p := MonsterCreateListClass.get(j);
      Manager.NpcCreateClass_p := NpcCreateListClass.get(j);
      Manager.DynamicCreateClass_p := DynamicCreateListClass.get(j);


             //create
      Manager.ItemList := TItemList.Create(Manager); //物品 列表
      Manager.StaticItemList := TStaticItemList.Create(Manager); //静止 物品 列表
      Manager.MonsterList := TMonsterList.Create(Manager); //怪物列表
      Manager.NpcList := TNpcList.Create(Manager); //NPC 列表
      Manager.DynamicObjectList := TDynamicObjectList.Create(Manager); //动 物体
      Manager.VirtualObjectList := TVirtualObjectList.Create(Manager);
      Manager.MineObjectList := TMineObjectList.Create(Manager);

            //load
      TMonsterList(Manager.MonsterList).ReLoad;
      tNpcList(Manager.NpcList).ReLoad;
      TMineObjectList(Manager.MineObjectList).LoadFile;
      tVirtualObjectList(Manager.VirtualObjectList).LoadFile;
      tDynamicObjectList(Manager.DynamicObjectList).ReLoad;

      Manager.Initial;
    end;
  end;
end;

function TManagerList.GetManagerByIndex(aIndex: Integer): TManager;
begin
  Result := nil;

  if DataList = nil then
    exit;
  if (aIndex < 0) or (aIndex >= DataList.Count) then
    exit;

  Result := DataList.Items[aIndex];
end;

function TManagerList.GetManagerByServerID(aServerID: Integer): TManager;
var
  i: Integer;
  Manager: TManager;
begin
  Result := nil;

  if DataList = nil then
    exit;

  for i := 0 to DataList.Count - 1 do
  begin
    Manager := DataList.Items[i];
    if Manager <> nil then
    begin
      if Manager.ServerID = aServerID then
      begin
        Result := Manager;
        exit;
      end;
    end;
  end;
end;


function TManagerList.GetNewMap(amapid, anewid: Integer; atitle: string): Boolean; //2015.11.10新增复制地图
var
  aManager, Manager: TManager;
  iName: string;
  i, j, DestServerID: Integer;
  MapDB: TUserStringDB;
  pd: PTPosByDieData;
  DestX, DestY: Word;
  ttgate, GateObject: TGateObject;
  tpd: PTCreateGateData;
begin
  Result := false;
  //获取要复制地图
  aManager := GetManagerByServerID(amapid);
  if aManager = nil then
    exit;

  //检测新地图ID存在就退出
  if GetManagerByServerID(anewid) <> nil then exit;

  MapDB := TUserStringDB.Create;
  try
    MapDB.LoadFromFile('.\Init\MAP.SDB');
    iName := IntToStr(amapid);
            //地图相关资源读入
    MonsterCreateListClass.add2(anewid, amapid);
    NpcCreateListClass.add2(anewid, amapid);
    DynamicCreateListClass.add2(anewid, amapid);
            //
    Manager := TManager.Create();
    Manager.boIsDuplicate := True; //2016.04.05 在水一方

    Manager.MonsterCreateClass_p := MonsterCreateListClass.get(anewid);
    Manager.NpcCreateClass_p := NpcCreateListClass.get(anewid);
    Manager.DynamicCreateClass_p := DynamicCreateListClass.get(anewid);

    Manager.ServerID := anewid;

    Manager.SmpName := MapDB.GetFieldValueString(iName, 'SmpName');
    Manager.MapName := MapDB.GetFieldValueString(iName, 'MapName');
    Manager.ObjName := MapDB.GetFieldValueString(iName, 'ObjName');
    Manager.RofName := MapDB.GetFieldValueString(iName, 'RofName');
    Manager.TilName := MapDB.GetFieldValueString(iName, 'TilName');
    Manager.Title := atitle;
//            Manager.boMsg := MapDB.GetFieldValueBoolean(iName, 'boMsg');
    Manager.Scripter := MapDB.GetFieldValueString(iName, 'Scripter');

    Manager.SoundBase := MapDB.GetFieldValueString(iName, 'SoundBase');
            // Manager.SoundEffect := MapDB.GetFieldValueString(iName, 'SoundEffect');
    Manager.SoundEffect := MapDB.GetFieldValueInteger(iName, 'SoundEffect');

    Manager.boUseDrug := MapDB.GetFieldValueBoolean(iName, 'boUseDrug');
    Manager.boGetExp := MapDB.GetFieldValueBoolean(iName, 'boGetExp');
    Manager.boBigSay := MapDB.GetFieldValueBoolean(iName, 'boBigSay');
    Manager.boMakeGuild := MapDB.GetFieldValueBoolean(iName, 'boMakeGuild');
    Manager.boPosDie := MapDB.GetFieldValueBoolean(iName, 'boPosDie');
    Manager.boHit := MapDB.GetFieldValueBoolean(iName, 'boHit');
    Manager.boWeather := MapDB.GetFieldValueBoolean(iName, 'boWeather');
    Manager.boPrison := MapDB.GetFieldValueBoolean(iName, 'boPrison');

    Manager.boSetGroupKey := MapDB.GetFieldValueBoolean(iName, 'boSetGroupKey'); //2015.10.15增加团队是否统一
    Manager.GroupKey := MapDB.GetFieldValueInteger(iName, 'GroupKey'); //2015.10.15增加地图团队;
    Manager.boNotDeal := MapDB.GetFieldValueBoolean(iName, 'boNotDeal'); //是否不允许交易
    Manager.boItemDrop := MapDB.GetFieldValueBoolean(iName, 'boItemDrop'); //是否不允许交易

      //2015.11.12新增地图下线后上线地图与坐标
    Manager.LoginServerID := MapDB.GetFieldValueInteger(iName, 'LoginServerID');
    Manager.LoginX := MapDB.GetFieldValueInteger(iName, 'LoginX');
    Manager.LoginY := MapDB.GetFieldValueInteger(iName, 'LoginY');

    Manager.RegenInterval := MapDB.GetFieldValueInteger(iName, 'RegenInterval');
    Manager.EffectInterval := MapDB.GetFieldValueInteger(iName, 'EffectInterval');

    Manager.TargetServerID := MapDB.GetFieldValueInteger(iName, 'TargetServerID');
    Manager.TargetX := MapDB.GetFieldValueInteger(iName, 'TargetX');
    Manager.TargetY := MapDB.GetFieldValueInteger(iName, 'TargetY');
    Manager.StartHour := MapDB.GetFieldValueInteger(iName, 'StartHour');
    Manager.EndHour := MapDB.GetFieldValueInteger(iName, 'EndHour');

    Manager.boChangeLife := MapDB.GetFieldValueBoolean(iName, 'boChangeLife'); //: boolean;                                                  //活力 改变 开关
    Manager.ChangePercentage := MapDB.GetFieldValueInteger(iName, 'ChangePercentage'); //                                                       //百分比
    Manager.ChangeDelay := MapDB.GetFieldValueInteger(iName, 'ChangeDelay'); //,                                                        //时间间隔
    Manager.ChangeSize := MapDB.GetFieldValueInteger(iName, 'ChangeSize'); //,                                                         //数量
    Manager.Attribute := MapDB.GetFieldValueInteger(iName, 'Attribute'); //: integer;                                                 //1，百分比 扣 2，实际值扣  ，3恢复 实际增加

//StartHour(开始时间) 单位:小时(服务器时间为准)
//EndHour(关闭时间) 单位:小时(服务器时间为准)
    Manager.boUPdateTime := MapDB.GetFieldValueBoolean(iName, 'boUPdateTime');
    Manager.boAQClear := MapDB.GetFieldValueBoolean(iName, 'boAQClear');
    Manager.boOfflineProtect := MapDB.GetFieldValueBoolean(iName, 'boOfflineProtect');                             //数量
    Manager.OfflineProtectInterval := MapDB.GetFieldValueInteger(iName, 'OfflineProtectInterval');
    Manager.boIsDuplicate := MapDB.GetFieldValueBoolean(iName, 'boIsDuplicate');

    Manager.CalcTime(Manager.RegenInterval, Manager.TotalHour, Manager.TotalMin, Manager.TotalSec);
    Manager.CalcTime(Manager.RegenInterval, Manager.RemainHour, Manager.RemainMin, Manager.RemainSec);

    Manager.Maper := TMaper.Create('.\Smp\' + Manager.SmpName); //地图
    Manager.Phone := TFieldPhone.Create(Manager);
            //地图创建 怪物列表

            //clear
    Manager.MonsterList := nil; //怪物列表
    Manager.NpcList := nil; //NPC 列表
    Manager.ItemList := nil; //物品 列表
    Manager.StaticItemList := nil; //静止 物品 列表
    Manager.DynamicObjectList := nil; //动 物体
    Manager.VirtualObjectList := nil;
    Manager.MineObjectList := nil;

            //create
    Manager.ItemList := TItemList.Create(Manager); //物品 列表
    Manager.StaticItemList := TStaticItemList.Create(Manager); //静止 物品 列表
    Manager.MonsterList := TMonsterList.Create(Manager); //怪物列表
    Manager.NpcList := TNpcList.Create(Manager); //NPC 列表
    Manager.DynamicObjectList := TDynamicObjectList.Create(Manager); //动 物体
    Manager.VirtualObjectList := TVirtualObjectList.Create(Manager);
    Manager.MineObjectList := TMineObjectList.Create(Manager);

            //load
    TMonsterList(Manager.MonsterList).ReLoad;
    tNpcList(Manager.NpcList).ReLoad;
    tDynamicObjectList(Manager.DynamicObjectList).ReLoad;
    TMineObjectList(Manager.MineObjectList).LoadFile;
    tVirtualObjectList(Manager.VirtualObjectList).LoadFile;

    Manager.Initial;

    DataList.Add(Manager);

    //地图复活点处理
    if Manager.boPosDie = true then
    begin
      PosByDieClass.GetPosByDieData(amapid, DestServerID, DestX, DestY);
      PosByDieClass.GetNewMapAdd(anewid, DestServerID, DestX, DestY);
    end;
    //地图跳点处理
    for I := 0 to GateList.Count - 1 do
    begin
      ttgate := GateList.GetItemIndex(i);
      if ttgate = nil then
        exit;
      tpd := ttgate.GetSelfData;
      if tpd.MapID = amapid then
      begin
        GateList.newInitial(tpd, anewid);
      end;
    end;

  finally
    MapDB.Free;
  end;
  //FrmMain.SESelServer.MaxValue := ManagerList.Count - 1;
  Result := true;
end;


function TManagerList.GetManagerByTitle(aTitle: string): TManager;
var
  i: Integer;
  Manager: TManager;
begin
  Result := nil;

  if DataList = nil then
    exit;

  for i := 0 to DataList.Count - 1 do
  begin
    Manager := DataList.Items[i];
    if Manager <> nil then
    begin
      if Manager.Title = aTitle then
      begin
        Result := Manager;
        exit;
      end;
    end;
  end;
end;

{
function TManagerList.GetManagerByGuild (aGuild, aName : String) : TManager;
var
   i : Integer;
   Manager : TManager;
begin
   Result := nil;

   if DataList = nil then exit;

   for i := 0 to DataList.Count - 1 do begin
      Manager := DataList.Items [i];
      if Manager <> nil then begin
         if TGuildList(Manager.GuildList).CheckGuildUser(aGuild, aName) = TRUE then begin
            Result := Manager;
            exit;
         end;
      end;
   end;
end;
}

procedure TManagerList.Update(CurTick: LongInt);
var
  i: Integer;
  Manager: TManager;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Manager := DataList.Items[i];
    if Manager <> nil then
    begin
      Manager.Update(CurTick);
    end;
  end;
end;

function TManagerList.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
//    i: integer;
//    nByte: Byte;
  SenderName, GuildName: string;
//    tmpUser: TUser;
  tmpManager: TManager;
begin
  Result := PROC_FALSE;

  case Msg of
    FM_CHECKGUILDUSER:
      begin
        SenderName := (aSubData.SubName);
        GuildName := (aSubData.GuildName);
        if GuildList.CheckGuildUser(GuildName, SenderName) = TRUE then
        begin
          Result := PROC_TRUE;
          exit;
        end;
        Result := PROC_FALSE;
      end;
    FM_REMOVEGUILDMEMBER:
      begin //已经 被废弃
                {SenderName := (aSubData.SubName);
                GuildName := (aSubData.GuildName);
                tmpUser := UserList.GetUserPointer(SenderName);
                if tmpUser <> nil then
                begin
                    if tmpUser.GuildName = GuildName then
                    begin
                        tmpUser.GuildName := '';
                        tmpUser.GuildGrade := '';
                        tmpUser.BasicData.Guild:= '';
                        tmpUser.BocChangeProperty;
                        tmpUser.SendClass.SendChatMessage(GuildName + '你已经脱离门派了。', SAY_COLOR_NORMAL);
                        Result := PROC_TRUE;
                    end;
                end;
               }
      end;
    FM_ALLOWGUILDSYSOPNAME:
      begin
        SenderName := (aSubData.SubName);
        GuildName := (aSubData.GuildName);
        if not GuildList.AllowGuildCondition(GuildName, SenderName) then
        begin
          Result := PROC_FALSE;
          exit;
        end;
        Result := PROC_TRUE;
      end;
    FM_ALLOWGUILDNAME: //许可的门派名字
      begin
        SenderName := (aSubData.SubName);
        GuildName := (aSubData.GuildName);
        if not GuildList.AllowGuildCondition(GuildName, SenderName) then
        begin
          Result := PROC_FALSE;
          exit;
        end;
                //成立 门派
        GuildList.AllowGuildName(SenderInfo.id, TRUE, GuildName, SenderName);
        Result := PROC_TRUE;
      end;
    FM_CURRENTUSER:
      begin
        SetWordString(aSubData.SayString, UserList.GetUserList);
      end;
    FM_ADDITEM:
      begin
        tmpManager := GetManagerByServerID(aSubData.ServerId);
        logItemMoveInfo('掉落物品', @SenderInfo, nil, aSubData.ItemData, aSubData.ServerId);
        case aSubData.ItemData.rKind of

          ITEM_KIND_GUILDSTONE: //门派石
            begin
              if tmpManager.boMakeGuild = true then
              begin

                                //nByte := TMaper(tmpManager.Maper).GetAreaIndex(SenderInfo.nX, SenderInfo.nY);
                               // if AreaClass.CanMakeGuild(nByte) = true then
                                //begin
                                  //  if TMaper(tmpManager.Maper).isGuildStoneArea(SenderInfo.nX, SenderInfo.nY) = false then
                if GuildList.isGuildStoneArea(SenderInfo.nX, SenderInfo.nY, tmpManager.Maper) = true then
                begin
                               //     Messagebox(0,PChar('isGuildStoneArea'),'提示',0) ;
                  TUSER(SenderInfo.P).SendClass.SendChatMessage('当前位置无法创建门派。', SAY_COLOR_NORMAL);
                end
                else
                begin
                  if Tuser(SenderInfo.P).GuildName = '' then
                  begin

                                            //  GuildList.AddGuildObject('', (SenderInfo.Name), tmpManager.ServerID, SenderInfo.nx, SenderInfo.ny);
                                              //弹出窗口 创建门派
                                            //  Tuser(SenderInfo.P).SendClass.SendShowCreateGuildName;
                                            //改为 直接创建
                    GuildName := (aSubData.GuildName);
                    GuildList.AddGuildObjectCreateName(GuildName, (SenderInfo.Name), tmpManager.ServerID, SenderInfo.nx, SenderInfo.ny, aSubData.TargetId);
                    Result := PROC_TRUE;
                  end
                  else
                  begin
                                            //        , '你已加入 %s,无法成立门派。' //24  numsay_24
                    Tuser(SenderInfo.P).SendClass.SendNUMSAY(numsay_24, SAY_COLOR_SYSTEM, Tuser(SenderInfo.P).GuildName);
                  end;

                end;
                                //end;
              end
              else
              begin
                            //  Messagebox(0,PChar('boMakeGuild'),'提示',0) ;
                TUSER(SenderInfo.P).SendClass.SendChatMessage('当前位置无法创建门派。', SAY_COLOR_NORMAL);
              end;
            end;
          ITEM_KIND_STATICITEM:
            begin
              Result := TStaticItemList(tmpManager.StaticItemList).AddStaticItemObject(aSubData.ItemData, SenderInfo.Id, SenderInfo.nx, SenderInfo.ny);

            end;
        else
          begin
                    //不是任务物品，任务物品不出现在地上
            if aSubData.ItemData.rKind <> ITEM_KIND_QUEST then
            begin
              TItemList(tmpManager.ItemList).AddItemObject(aSubData.ItemData, SenderInfo.Id, SenderInfo.nx, SenderInfo.ny);
              Result := PROC_TRUE;
            end;
          end;
        end;
      end;

  end;
end;

procedure TManagerList.SaveFileCsv;
var
  i, j: Integer;
  Manager: TManager;
  temps: TStringList;
  DOMonsterList: tlist;
begin
  temps := TStringList.Create;
  DOMonsterList := tlist.Create;
  try
    temps.Clear;

    temps.add('<HTML xmlns="http://www.w3.org/1999/xhtml">');
    temps.add('<HEAD>');
    temps.add('<TITLE></TITLE>');
    temps.add('<META http-equiv=Content-Type content="text/html; charset=gb2312">');
    temps.add('<META http-equiv=x-ua-compatible content=ie=7>');
    temps.add('<style type="text/css">');
    temps.add('<!--');
    temps.add('body {');
    temps.add('	background-color: #FFFFFF;');
    temps.add('	margin-left: 0px;');
    temps.add('	margin-top: 0px;');
    temps.add('	margin-right: 0px;');
    temps.add('	margin-bottom: 0px;');
    temps.add('	body {');
    temps.add('	margin-top: 0px;');
    temps.add('	margin-bottom: 0px;');
    temps.add('');
    temps.add('}');
    temps.add('}');
    temps.add('body,td,th {');
    temps.add('	color: #4B4B4B;');
    temps.add('	font-family: Arial, Helvetica, sans-serif;');
    temps.add('	font-size: 12px;');
    temps.add('}');
    temps.add('.STYLE1 {');
    temps.add('	font-size: 16px;');
    temps.add('	font-weight: bold;');
    temps.add('}');
    temps.add('-->');
    temps.add('</style>');
    temps.add('</HEAD>');
    temps.add('<BODY>');
    temps.add('<table width="600" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#5B5B5B">');
    temps.add('  <tr>');
    temps.add('    <td colspan="4" align="center" bgcolor="#FFFFFF" scope="col"><span class="STYLE1">怪物分布</span></td>');
    temps.add('  </tr>');
    temps.add('  <tr>');
    temps.add('    <td width="113" align="center" bgcolor="#B0B0B0" scope="col">地图</td>');
    temps.add('    <td width="87" align="center" bgcolor="#B0B0B0" scope="col">怪物</td>');
    temps.add('    <td width="116" align="center" bgcolor="#B0B0B0" scope="col">坐标</td>');
    temps.add('    <td width="255" align="center" bgcolor="#B0B0B0" scope="col">掉落物品</td>');
    temps.add('  </tr>');

    for i := 0 to DataList.Count - 1 do
    begin
      Manager := DataList.Items[i];
      if Manager <> nil then
      begin
        TDynamicObjectList(Manager.DynamicObjectList).DropMop(DOMonsterList);
        temps.Add(TMonsterList(Manager.MonsterList).getHelpHtm);
           // TNpcList(Manager.NpcList).SaveFileCsv;
           // TDynamicObjectList(Manager.DynamicObjectList).SaveFileCsv;
        for j := 0 to DOMonsterList.Count - 1 do
        begin
          TMonster(DOMonsterList.Items[j]).boAllowDelete := true;
        end;
        DOMonsterList.Clear;
      end;

    end;

    temps.Add('</table></BODY></HTML>');
    temps.SaveToFile('.\help\MOPHelp.htm');
  finally
    temps.Free;
    for j := 0 to DOMonsterList.Count - 1 do
    begin
      TMonster(DOMonsterList.Items[j]).boAllowDelete := true;
    end;
    DOMonsterList.Clear;
    DOMonsterList.Free;
  end;
end;

procedure TManager.SetLuaScript(aScript, afilename: string);
begin
  if aScript = '' then
  begin
    FBaseLua := nil;
    exit;
  end;

  if not FileExists(afilename) then
    Exit;
  if FBaseLua = nil then
  begin

    //判断是否有相同宿主名称脚本
    if LuaScripterList.IsScripter(aScript) = false then
    begin
      FBaseLua := TLua.Create(false);
      luaL_openlibs(FBaseLua.LuaInstance);
      Lua_GroupScripteRegister(FBaseLua.LuaInstance); //NPC说话
      if FBaseLua.DoFile(afilename) <> 0 then
        frmMain.WriteLogInfo(format('Lua脚本错误 方法: %s f: %s', [afilename, lua_tostring(FBaseLua.LuaInstance, -1)]));
      FBaseLuaFileName := afilename;
      LuaScripterList.LoadFile(aScript, afilename, FBaseLua);
    end;

    //获取LUA脚本ID
    if LuaScripterList.GetScripter(aScript, FBaseLua) = false then
    begin
      FBaseLua := nil;
    end;

//    FBaseLua := TLua.Create(false);
//    luaL_openlibs(FBaseLua.LuaInstance);
//    Lua_GroupScripteRegister(FBaseLua.LuaInstance); //NPC说话
//    if FBaseLua.DoFile(afilename) <> 0 then
//      frmMain.WriteLogInfo(format('Lua脚本错误 方法: %s f: %s', [afilename, lua_tostring(FBaseLua.LuaInstance, -1)]));
//    FBaseLuaFileName := afilename;
//
//    LuaScripterList.LoadFile(aScript, afilename, FBaseLua);
  end;
end;

function TManager.CallLuaScriptFunction(const Name: string; const Params: array of const): string;
var
  I: Integer;
  vi: Integer;
  vas: string;
  vd: Double;
  ItemData: TItemData;
begin

  if FBaseLua = nil then
    Exit;

 // luaopen_debug(G_LU); //如果要使用debug库
 // luaopen_io(FBaseLua.LuaInstance);
 // luaopen_math(FBaseLua.LuaInstance);// 如果要使用math库 不然就会attempt to index global 'math' (a nil value)
 // luaopen_os(FBaseLua.LuaInstance);
  //luaopen_package(FBaseLua.LuaInstance);
  //luaopen_string(FBaseLua.LuaInstance);
  //luaopen_table(FBaseLua.LuaInstance);

//  luaL_openlibs(FBaseLua.LuaInstance);

  lua_pcall(FBaseLua.LuaInstance, 0, 0, 0);
  lua_getglobal(FBaseLua.LuaInstance, PChar(Name));
  for i := 0 to Length(Params) - 1 do
  begin
    case Params[i].VType of
      vtInteger:
        begin
          vi := Params[i].VInteger;
          lua_pushinteger(FBaseLua.LuaInstance, vi);
        end;
      vtAnsiString:
        begin
          vas := Params[i].VPChar;
          lua_pushstring(FBaseLua.LuaInstance, PAnsiChar(vas));
        end;
      vtBoolean:
        begin
          lua_pushboolean(FBaseLua.LuaInstance, Params[i].VBoolean);
        end;
      vtCurrency:
        begin
          vd := Params[i].VExtended^;
          lua_pushnumber(FBaseLua.LuaInstance, vd);
        end;

    end;

  end;

  if (lua_pcall(FBaseLua.LuaInstance, Length(Params), 1, 0) = 0) then
  begin
    Result := lua_tostring(FBaseLua.LuaInstance, -1);
  end;
//  if (lua_pcall(FBaseLua.LuaInstance, Length(Params), 1, 0) <> 0) then
//  begin
//    frmMain.WriteLogInfo(format('Lua脚本错误 路径: %s 方法: %s f: %s', [FBaseLuaFileName, Name, lua_tostring(FBaseLua.LuaInstance, -1)]));
//  end else
//  begin
//    Result := lua_tostring(FBaseLua.LuaInstance, -1);
//  end;
end;

end.

