unit LuaRegisterClass;

interface

uses
  Lua, LuaLib, Dialogs, SysUtils, deftype, classes, class_DataSetWrapper;

type
  TProc = function(L: TLuaState): Integer of object; // Lua Function

  TCallback = class
    Routine: TMethod; // Code and Data for the method
    Exec: TProc; // Resulting execution function
  end;

  TTgsLuaLib = class(TLua)
  public
    procedure RegisterLuaLib;
    procedure RegisterFunction2(const FuncName: AnsiString; MethodName: AnsiString = '');
  published
    procedure test();
    procedure MenuSay(uObject: integer; SAYTEXT: string);
  end;

procedure Lua_GroupScripteRegister(L: lua_state);

implementation

uses
  SVMain, UUser, uSkills, uNpc, uMonster, uGuild, svClass, aUtil32, basicobj, fieldmsg,
  mapunit, subutil, uanstick, uSendcls, uUserSub, aiunit, uLetter, uManager,
  uConnect, uBuffer, uItemLog, uKeyClass, uGramerID, mmSystem, uLevelExp,
  uResponsion, DateUtils, UTelemanagement, UserSdb;

function LuaCallBack(L: Lua_State): Integer; cdecl;
var
  CallBack: TCallBack; // The Object stored in the Object Table
begin
  // Retrieve first Closure Value (=Object Pointer)
  CallBack := lua_topointer(L, lua_upvalueindex(1));

  // Execute only if Object is valid
  if (assigned(CallBack) and assigned(CallBack.Exec)) then
    Result := CallBack.Exec(L)
  else
    Result := 0;
end;

procedure TTgsLuaLib.MenuSay(uObject: integer; SAYTEXT: string);
var
  USER: TUser;
  sname: string;
begin
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  USER.ShowNPCSAYWindow(SAYTEXT);
end;

procedure TTgsLuaLib.RegisterFunction2(const FuncName: AnsiString; MethodName: AnsiString = '');
var
  CallBack: TCallBack; // Callback Object
  PMethod: TMethod;
begin
  // if method name not specified use Lua function name
  if (MethodName = '') then
    MethodName := FuncName;



  // Add Callback Object to the Object Index
  CallBack := TCallBack.Create;
  CallBack.Routine.Data := Self;
  CallBack.Routine.Code := Self.MethodAddress((FuncName));
  CallBack.Exec := TProc(CallBack.Routine);
  CallbackList.Add(CallBack);

  // prepare Closure value (Method Name)
  lua_pushstring(LuaInstance, PAnsiChar(FuncName));

  // prepare Closure value (CallBack Object Pointer)
  lua_pushlightuserdata(LuaInstance, CallBack);

  // set new Lua function with Closure value
  lua_pushcclosure(LuaInstance, LuaCallBack, 1);
  lua_settable(LuaInstance, LUA_GLOBALSINDEX);

end;

procedure TTgsLuaLib.RegisterLuaLib;
const
  MenuSayS = 'MenuSay';
begin

  self.RegisterFunction2(MenuSayS, MenuSayS);
  self.RegisterFunction2('test', 'test');
end;

procedure TTgsLuaLib.test;
begin
  showmessage('s');
end;
//这里是新增一个LUA的 MenuSay方法
//建立tgs\Script\lua路径 建立\Script\lua\npc保存NPC脚本
//在\Script\lua\npc路径下增加\tgs\Script\npc 对应名字的lua脚本 测试后把原先的PAS脚本删掉
// RegisterRoutine('procedure MenuSay(uObject:integer; SAYTEXT:string);', @MenuSay); //NPC菜单
//procedure MenuSay(uObject: integer; SAYTEXT: string);
//var
//  USER: TUser;
//  sname: string;
//begin
//  if not (TObject(uObject) is TUser) then exit;
//  user := TUser(uObject);
//  USER.ShowNPCSAYWindow(SAYTEXT);
//end;

//指定对象脚本语言
//NPC窗口信息

function MenuSay(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  sname: string;
  uObject: integer;
  SAYTEXT: string;
begin
  uObject := lua_tointeger(L, 1);
  SAYTEXT := lua_tostring(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  USER.ShowNPCSAYWindow(SAYTEXT);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//NPC窗口信息

function MenuSayItem(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, ItemKey: integer;
  ITEMNAME, SAYTEXT: string;
  ttTManager: TManager;
  Bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  SAYTEXT := lua_tostring(L, 2);
  ITEMNAME := lua_tostring(L, 3);
  ItemKey := lua_tointeger(L, 4);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;

  user := TUser(uObject);
  user.MenuSayObjId := -999;
  user.ShowNPCSAYWindow2(SAYTEXT, ITEMNAME, ItemKey);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;


//指定对象发顶部消息框

function topyoumsg(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  atext: string;
  acolor: integer;
begin
  uObject := lua_tointeger(L, 1);
  atext := lua_tostring(L, 2);
  acolor := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.SendClass.SendTopMSG(ColorSysToDxColor(acolor), atext);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;
//指定对象发系统类型消息

function saysystem(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  SAYTEXT: string;
  acolor: integer;
begin
  uObject := lua_tointeger(L, 1);
  SAYTEXT := lua_tostring(L, 2);
  acolor := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  USER.SendClass.SendChatMessage(SAYTEXT, acolor);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//指定对象发自定义颜色

function sayByCol(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  SAYTEXT: string;
  afcolor: integer;
  abcolor: integer;
begin
  uObject := lua_tointeger(L, 1);
  SAYTEXT := lua_tostring(L, 2);
  afcolor := lua_tointeger(L, 3);
  abcolor := lua_tointeger(L, 4);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  USER.SendClass.SendChatMessageByCol(SAYTEXT, ColorSysToDxColor(afcolor), ColorSysToDxColor(abcolor));
  //返回
  Result := 0;
end;

//指定对象发自定义颜色

function SendARoundChatMsg(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  SAYTEXT: string;
  afcolor: integer;
  abcolor: integer;
begin
  uObject := lua_tointeger(L, 1);
  SAYTEXT := lua_tostring(L, 2);
  afcolor := lua_tointeger(L, 3);
  abcolor := lua_tointeger(L, 4);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  USER.SendClass.SendChatMessageByCol(SAYTEXT, ColorSysToDxColor(afcolor), ColorSysToDxColor(abcolor));

  //返回
  Result := 0;
end;
//指定对象说话

function SAY(L: TLuaState): Integer; cdecl;
var
  ttBasicObject: TBasicObject;
  USER: TUser;
  uObject: integer;
  SAYTEXT: string;
begin
  uObject := lua_tointeger(L, 1);
  SAYTEXT := lua_tostring(L, 2);
  //以上获取LUA参数
  //NPC  人都可以
  if not (TObject(uObject) is TBasicObject) then
    exit;
  ttBasicObject := TBasicObject(uObject);
  ttBasicObject.BocSay(SAYTEXT);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;
//指定对象延迟说话

function SayDelayAdd(L: TLuaState): Integer; cdecl;
var
  ttBasicObject: TBasicObject;
  USER: TUser;
  uObject, atime: integer;
  SAYTEXT: string;
begin
  uObject := lua_tointeger(L, 1);
  SAYTEXT := lua_tostring(L, 2);
  atime := lua_tointeger(L, 3);
  //以上获取LUA参数
  //NPC  人都可以
  if not (TObject(uObject) is TBasicObject) then
    exit;
  ttBasicObject := TBasicObject(uObject);
  ttBasicObject.SayDelayAdd(SAYTEXT, atime);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;
//指定对象延迟说话

function MapDelaySayNPC(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid, atime: integer;
  aname, asay: string;

begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  asay := lua_tostring(L, 3);
  atime := lua_tointeger(L, 4);
  //以上获取LUA参数
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  if ttTManager.NpcList = nil then
    exit;
  TNpcList(ttTManager.NpcList).SayDelayAddNpc(aname, asay, atime);
  Result := 0;
end;

function MapGetboIsDupTime(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid: integer;
begin
  amapid := lua_tointeger(L, 1);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  Lua_Pushstring(L, PAnsiChar(_DateTimeToStr(ttTManager.boIsDupTime)));
  Result := 1;
end;


function getAQData(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  c1: char;
  uObject: integer;
  atype: string;
  aStr: integer;
begin
  uObject := lua_tointeger(L, 1);
  atype := lua_tostring(L, 2);
  //以上获取LUA参数
  aStr := 0;
  if atype = '' then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  c1 := atype[1];
  case c1 of
    'l':
      begin
        //附加属性类
        //攻击
        if atype = 'ldamagebody' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.damageBody //身体
        else if atype = 'ldamagehead' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.damageHead //头
        else if atype = 'ldamagearm' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.damageArm //手
        else if atype = 'ldamageleg' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.damageLeg //脚
                //防御
        else if atype = 'larmorbody' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.armorBody //身
        else if atype = 'larmorhead' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.armorHead //头
        else if atype = 'larmorarm' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.armorArm //手
        else if atype = 'larmorleg' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.armorLeg //脚
                //其他
        else if atype = 'lattackspeed' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.AttackSpeed //攻击速度
        else if atype = 'lavoid' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.avoid //躲闪
        else if atype = 'lrecovery' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.recovery //恢复
        else if atype = 'laccuracy' then
          aStr := user.AttribClass.AttribQuestData.AttribLifeData.accuracy //命中
      end;
    'a':
      begin
        if atype = 'aage' then
          aStr := user.AttribClass.AttribQuestData.Age //年龄
        else if atype = 'alight' then
          aStr := user.AttribClass.AttribQuestData.Light //阳
        else if atype = 'adark' then
          aStr := user.AttribClass.AttribQuestData.Dark //阴
        else if atype = 'avirtue' then
          aStr := user.AttribClass.AttribQuestData.virtue //浩然
        else if atype = 'aadaptive' then
          aStr := user.AttribClass.AttribQuestData.adaptive //赖性
        else if atype = 'arevival' then
          aStr := user.AttribClass.AttribQuestData.Revival //再生
      end;
    'e':
      begin
        if atype = 'eenergy' then
          aStr := user.AttribClass.AttribQuestData.Energy //元气
        else if atype = 'einpower' then
          aStr := user.AttribClass.AttribQuestData.InPower //内功
        else if atype = 'eoutpower' then
          aStr := user.AttribClass.AttribQuestData.OutPower //外功
        else if atype = 'emagic' then
          aStr := user.AttribClass.AttribQuestData.Magic //武功
        else if atype = 'elife' then
          aStr := user.AttribClass.AttribQuestData.Life //活力
      end;

    'h':
      begin
        if atype = 'hheadseak' then
          aStr := user.AttribClass.AttribQuestData.HeadSeak //头
        else if atype = 'harmseak' then
          aStr := user.AttribClass.AttribQuestData.ArmSeak //手
        else if atype = 'hlegseak' then
          aStr := user.AttribClass.AttribQuestData.LegSeak //脚
        else if atype = 'hhealth' then
          aStr := user.AttribClass.AttribQuestData.Health //健康
        else if atype = 'hsatiety' then
          aStr := user.AttribClass.AttribQuestData.Satiety //饱和
        else if atype = 'hpoisoning' then
          aStr := user.AttribClass.AttribQuestData.Poisoning //中毒
        else if atype = 'htalent' then
          aStr := user.AttribClass.AttribQuestData.Talent //魂点
        else if atype = 'hgoodchar' then
          aStr := user.AttribClass.AttribQuestData.GoodChar //神性
        else if atype = 'hbadchar' then
          aStr := user.AttribClass.AttribQuestData.BadChar //魔性
        else if atype = 'hlucky' then
          aStr := user.AttribClass.AttribQuestData.lucky //幸运
        else if atype = 'himmunity' then
          aStr := user.AttribClass.AttribQuestData.immunity //免疫

             //   else if atype = 'hprestige' then aStr := user.AttribClass.AttribQuestData.prestige //荣誉
        else if atype = 'hr3f_sky' then
          aStr := user.AttribClass.AttribQuestData.r3f_sky //天
        else if atype = 'hr3f_terra' then
          aStr := user.AttribClass.AttribQuestData.r3f_terra //地
        else if atype = 'hr3f_fetch' then
          aStr := user.AttribClass.AttribQuestData.r3f_fetch //魂 应该是（命）
      end;
  end;
  Lua_PushInteger(L, aStr);

  //下边这行必加 中间保持原对应方法内容
  Result := 1;
end;

//返回玩家攻击防御等属性

function getLifeData(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  aLifeData: TLifeData;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  aLifeData := user.getLifeData; //获取属性
  lua_newtable(L); //创建一个表格，放在栈顶
  //攻击 //身体
  lua_pushstring(L, pansichar('damageBody')); //压入key
  Lua_PushInteger(L, aLifeData.damageBody);
  lua_settable(L, -3);
  //攻击 //头
  lua_pushstring(L, pansichar('damageHead')); //压入key
  Lua_PushInteger(L, aLifeData.damageHead);
  lua_settable(L, -3);
  //攻击 //手
  lua_pushstring(L, pansichar('damageArm')); //压入key
  Lua_PushInteger(L, aLifeData.damageArm);
  lua_settable(L, -3);
  //攻击 //脚
  lua_pushstring(L, pansichar('damageLeg')); //压入key
  Lua_PushInteger(L, aLifeData.damageLeg);
  lua_settable(L, -3);

  //防御 //身
  lua_pushstring(L, pansichar('armorBody')); //压入key
  Lua_PushInteger(L, aLifeData.armorBody);
  lua_settable(L, -3);
  //防御 //头
  lua_pushstring(L, pansichar('armorHead')); //压入key
  Lua_PushInteger(L, aLifeData.armorHead);
  lua_settable(L, -3);
  //防御 //手
  lua_pushstring(L, pansichar('armorArm')); //压入key
  Lua_PushInteger(L, aLifeData.armorArm);
  lua_settable(L, -3);
  //防御 //脚
  lua_pushstring(L, pansichar('armorLeg')); //压入key
  Lua_PushInteger(L, aLifeData.armorLeg);
  lua_settable(L, -3);
  //攻击速度
  lua_pushstring(L, pansichar('AttackSpeed')); //压入key
  Lua_PushInteger(L, aLifeData.AttackSpeed);
  lua_settable(L, -3);
  //躲闪
  lua_pushstring(L, pansichar('avoid')); //压入key
  Lua_PushInteger(L, aLifeData.avoid);
  lua_settable(L, -3);
  //恢复
  lua_pushstring(L, pansichar('recovery')); //压入key
  Lua_PushInteger(L, aLifeData.recovery);
  lua_settable(L, -3);
  //命中
  lua_pushstring(L, pansichar('accuracy')); //压入key
  Lua_PushInteger(L, aLifeData.accuracy);
  lua_settable(L, -3);
  //维持
  lua_pushstring(L, pansichar('HitArmor')); //压入key
  Lua_PushInteger(L, aLifeData.HitArmor);
  lua_settable(L, -3);

  //返回
  Result := 1;
end;

function getitemcount(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  aTItemData: TItemData;
  uObject: integer;
  Push: integer;
  aitemname: string;
begin
  uObject := lua_tointeger(L, 1);
  aitemname := lua_tostring(L, 2);
  //以上获取LUA参数
  //NPC  人都可以
  Push := -1;
  aitemname := trim(aitemname);
  if aitemname = '' then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if user.ViewItemName(aitemname, @aTItemData) then
    Push := aTItemData.rCount;
  Lua_PushInteger(L, Push);
  Result := 1;
end;

function deleteitem(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  aTItemData: TItemData;
  uObject: integer;
  Push: LongBool;
  aitemname, aname: string;
  acount: integer;
begin
  uObject := lua_tointeger(L, 1);
  aitemname := lua_tostring(L, 2);
  acount := lua_tointeger(L, 3);
  aname := lua_tostring(L, 4);
  //以上获取LUA参数
  Push := LongBool(false);
  aitemname := trim(aitemname);
  if aitemname = '' then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if user.ViewItemName(aitemname, @aTItemData) = FALSE then
    exit;
  if acount > 0 then
    aTItemData.rCount := acount;
  Push := LongBool(user.ItemScripterDeleteItem(@aTItemData, aname));
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;

//获取物品栏指定位置table

function GetHaveItemInfoTabs(L: TLuaState): Integer; cdecl;
var
  I: Integer;
  USER: TUser;
  uObject, akey: integer;
  p: ptitemdata;
begin
  uObject := lua_tointeger(L, 1);
  akey := lua_tointeger(L, 2);
  //以上获取LUA参数
  lua_newtable(L); //创建一个表格，放在栈顶
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  //if p = nil then exit;
  //返回
  if p = nil then
  begin
    lua_pushstring(L, pansichar('Name')); //压入key
    lua_pushstring(L, pansichar(''));
    lua_settable(L, -3);
  end
  else
  begin
  //rName
    lua_pushstring(L, pansichar('Name')); //压入key
    lua_pushstring(L, pansichar(AnsiString(p.rName)));
    lua_settable(L, -3);
  //rViewName
    lua_pushstring(L, pansichar('ViewName')); //压入key
    lua_pushstring(L, pansichar(AnsiString(p.rViewName)));
    lua_settable(L, -3);
  //rNameColor
    lua_pushstring(L, pansichar('rNameColor')); //压入key
    Lua_PushInteger(L, p.rNameColor);
    lua_settable(L, -3);
  //rNeedGrade
    lua_pushstring(L, pansichar('rNeedGrade')); //压入key
    Lua_PushInteger(L, p.rNeedGrade);
    lua_settable(L, -3);
  //rKind
    lua_pushstring(L, pansichar('Kind')); //压入key
    Lua_PushInteger(L, p.rKind);
    lua_settable(L, -3);
  //rHitType
    lua_pushstring(L, pansichar('rHitType')); //压入key
    Lua_PushInteger(L, p.rHitType);
    lua_settable(L, -3);
  //rId
    lua_pushstring(L, pansichar('rId')); //压入key
    Lua_PushInteger(L, p.rId);
    lua_settable(L, -3);
  //rDecSize
    lua_pushstring(L, pansichar('rDecSize')); //压入key
    Lua_PushInteger(L, p.rDecSize);
    lua_settable(L, -3);
  //rSex
    lua_pushstring(L, pansichar('Sex')); //压入key
    Lua_PushInteger(L, p.rSex);
    lua_settable(L, -3);
  //rcolor
    lua_pushstring(L, pansichar('Color')); //压入key
    Lua_PushInteger(L, p.rcolor);
    lua_settable(L, -3);
  //rCount
    lua_pushstring(L, pansichar('Count')); //压入key
    Lua_PushInteger(L, p.rCount);
    lua_settable(L, -3);
  //rlockState
    lua_pushstring(L, pansichar('lockState')); //压入key
    Lua_PushInteger(L, p.rlockState);
    lua_settable(L, -3);
  //rlocktime
    lua_pushstring(L, pansichar('locktime')); //压入key
    Lua_PushInteger(L, p.rlocktime);
    lua_settable(L, -3);
  //rDateTimeSec
    lua_pushstring(L, pansichar('rDateTimeSec')); //压入key
    Lua_PushInteger(L, p.rDateTimeSec);
    lua_settable(L, -3);
  //rGrade
    lua_pushstring(L, pansichar('Grade')); //压入key
    Lua_PushInteger(L, p.rGrade);
    lua_settable(L, -3);
  //MaxUpgrade
    lua_pushstring(L, pansichar('MaxUpgrade')); //压入key
    Lua_PushInteger(L, p.MaxUpgrade);
    lua_settable(L, -3);
  //rDurability
    lua_pushstring(L, pansichar('rDurability')); //压入key
    Lua_PushInteger(L, p.rDurability);
    lua_settable(L, -3);
  //rCurDurability
    lua_pushstring(L, pansichar('rCurDurability')); //压入key
    Lua_PushInteger(L, p.rCurDurability);
    lua_settable(L, -3);
  //rSmithingLevel
    lua_pushstring(L, pansichar('SmithingLevel')); //压入key
    Lua_PushInteger(L, p.rSmithingLevel);
    lua_settable(L, -3);
  end;
  Result := 1;
end;
//删除物品栏指定位置物品

function DelHaveItemInfo(L: TLuaState): Integer; cdecl;
var
  I: Integer;
  USER: TUser;
  uObject, akey, acount: integer;
begin
  uObject := lua_tointeger(L, 1);
  akey := lua_tointeger(L, 2);
  acount := lua_tointeger(L, 3);
  //以上获取LUA参数
  if akey < 0 then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  //返回
  lua_pushboolean(L, LongBool(user.ItemScripterDeleteItemKey(akey, acount)));
  Result := 1;
end;

//写入物品栏指定位置table

function AddItemTabsToHave(L: TLuaState): Integer; cdecl;
var
  I: Integer;
  USER: TUser;
  uObject, aStarLevel, aSmithingLevel, aSettingCount, aAttach, aDurability: integer;
  p: TItemData;
  anames, aitemname, acreatename: string;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not lua_istable(L, 2) then
    exit;
  //rViewName
  lua_getfield(L, 2, 'Name');
  aitemname := lua_tostring(L, -1);
  if not ItemClass.GetItemData(aitemname, p) then
    exit;
    //ShowMessage(inttostr(p.rWearArr));
  p.rName := aitemname;
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rCount
  lua_getfield(L, 2, 'Count');
  p.rCount := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rcolor
  lua_getfield(L, 2, 'Color');
  p.rcolor := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rGrade
  lua_getfield(L, 2, 'Grade');
  p.rGrade := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rId
  lua_getfield(L, 2, 'Id');
  p.rId := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aStarLevel
  lua_getfield(L, 2, 'StarLevel');
  aStarLevel := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aSmithingLevel
  lua_getfield(L, 2, 'SmithingLevel');
  aSmithingLevel := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aSettingCount
  lua_getfield(L, 2, 'SettingCount');
  aSettingCount := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aAttach
  lua_getfield(L, 2, 'Attach');
  aAttach := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aAttach
  lua_getfield(L, 2, 'createname');
  acreatename := lua_tostring(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aDurability
  lua_getfield(L, 2, 'Durability');
  aDurability := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  NewItemSet(_nist_all, p);

  if p.rWearArr = ARR_WEAPON then
  begin
    if aSettingCount > 2 then
      aSettingCount := 2;
  end
  else
  begin
    if aSettingCount > 4 then
      aSettingCount := 4;
  end;
  if aSettingCount > 0 then
  begin
    p.rSetting.rsettingcount := aSettingCount;
    p.rboident := false;
  end;

  if (aStarLevel > 0) and (aStarLevel <= p.rStarLevelMax) then
    p.rStarLevel := aStarLevel;
  if (aSmithingLevel > 0) and (aSmithingLevel <= p.MaxUpgrade) then
    p.rSmithingLevel := aSmithingLevel;

  if aDurability > p.rDurability then
    aDurability := p.rDurability;
  if aDurability >= 0 then
    p.rCurDurability := aDurability;

  if acreatename <> '' then
    p.rcreatename := copy(acreatename, 1, 20);
  if (aAttach > 0) then
  begin
    if ItemLifeDataClass.get('X附加' + inttostr(aAttach)) <> nil then
      p.rAttach := aAttach;
    p.rboident := false;
  end;
  anames := lua_tostring(L, 3);
  //返回
  lua_pushboolean(L, Boolean(user.ItemScripterADDITEM(@p, anames)));
  Result := 1;
end;


//获取装备栏指定位置table

function GetWearItemInfoTabs(L: TLuaState): Integer; cdecl;
var
  I: Integer;
  USER: TUser;
  uObject, akey: integer;
  p: ptitemdata;
begin
  uObject := lua_tointeger(L, 1);
  akey := lua_tointeger(L, 2);
  //以上获取LUA参数
  lua_newtable(L); //创建一个表格，放在栈顶
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  p := user.WearItemClass.getViewItem(akey);
  //if p = nil then exit;
  //返回
  if p = nil then
  begin
    lua_pushstring(L, pansichar('Name')); //压入key
    lua_pushstring(L, pansichar(''));
    lua_settable(L, -3);
  end
  else
  begin
  //rName
    lua_pushstring(L, pansichar('Name')); //压入key
    lua_pushstring(L, pansichar(AnsiString(p.rName)));
    lua_settable(L, -3);
  //rViewName
    lua_pushstring(L, pansichar('ViewName')); //压入key
    lua_pushstring(L, pansichar(AnsiString(p.rViewName)));
    lua_settable(L, -3);
  //rNameColor
    lua_pushstring(L, pansichar('rNameColor')); //压入key
    Lua_PushInteger(L, p.rNameColor);
    lua_settable(L, -3);
  //rNeedGrade
    lua_pushstring(L, pansichar('rNeedGrade')); //压入key
    Lua_PushInteger(L, p.rNeedGrade);
    lua_settable(L, -3);
  //rKind
    lua_pushstring(L, pansichar('Kind')); //压入key
    Lua_PushInteger(L, p.rKind);
    lua_settable(L, -3);
  //rHitType
    lua_pushstring(L, pansichar('rHitType')); //压入key
    Lua_PushInteger(L, p.rHitType);
    lua_settable(L, -3);
  //rId
    lua_pushstring(L, pansichar('rId')); //压入key
    Lua_PushInteger(L, p.rId);
    lua_settable(L, -3);
  //rDecSize
    lua_pushstring(L, pansichar('rDecSize')); //压入key
    Lua_PushInteger(L, p.rDecSize);
    lua_settable(L, -3);
  //rSex
    lua_pushstring(L, pansichar('Sex')); //压入key
    Lua_PushInteger(L, p.rSex);
    lua_settable(L, -3);
  //rcolor
    lua_pushstring(L, pansichar('Color')); //压入key
    Lua_PushInteger(L, p.rcolor);
    lua_settable(L, -3);
  //rCount
    lua_pushstring(L, pansichar('Count')); //压入key
    Lua_PushInteger(L, p.rCount);
    lua_settable(L, -3);
  //rlockState
    lua_pushstring(L, pansichar('lockState')); //压入key
    Lua_PushInteger(L, p.rlockState);
    lua_settable(L, -3);
  //rlocktime
    lua_pushstring(L, pansichar('locktime')); //压入key
    Lua_PushInteger(L, p.rlocktime);
    lua_settable(L, -3);
  //rDateTimeSec
    lua_pushstring(L, pansichar('rDateTimeSec')); //压入key
    Lua_PushInteger(L, p.rDateTimeSec);
    lua_settable(L, -3);
  //rGrade
    lua_pushstring(L, pansichar('Grade')); //压入key
    Lua_PushInteger(L, p.rGrade);
    lua_settable(L, -3);
  //MaxUpgrade
    lua_pushstring(L, pansichar('MaxUpgrade')); //压入key
    Lua_PushInteger(L, p.MaxUpgrade);
    lua_settable(L, -3);
  //rDurability
    lua_pushstring(L, pansichar('rDurability')); //压入key
    Lua_PushInteger(L, p.rDurability);
    lua_settable(L, -3);
  //rCurDurability
    lua_pushstring(L, pansichar('rCurDurability')); //压入key
    Lua_PushInteger(L, p.rCurDurability);
    lua_settable(L, -3);
  //rSmithingLevel
    lua_pushstring(L, pansichar('SmithingLevel')); //压入key
    Lua_PushInteger(L, p.rSmithingLevel);
    lua_settable(L, -3);
  end;
  Result := 1;
end;

//写入装备栏指定位置table

function AddItemTabsToWear(L: TLuaState): Integer; cdecl;
var
  I: Integer;
  USER: TUser;
  uObject, aStarLevel, aSmithingLevel, aSettingCount, aAttach, aDurability: integer;
  p: TItemData;
  aitemname, acreatename: string;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not lua_istable(L, -1) then
    exit;
  //rViewName
  lua_getfield(L, -1, 'Name');
  aitemname := lua_tostring(L, -1);
  if not ItemClass.GetItemData(aitemname, p) then
    exit;
    //ShowMessage(inttostr(p.rWearArr));
  p.rName := aitemname;
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rCount
  lua_getfield(L, -1, 'Count');
  p.rCount := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rcolor
  lua_getfield(L, -1, 'Color');
  p.rcolor := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rGrade
  lua_getfield(L, -1, 'Grade');
  p.rGrade := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //rId
  lua_getfield(L, -1, 'Id');
  p.rId := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aStarLevel
  lua_getfield(L, -1, 'StarLevel');
  aStarLevel := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aSmithingLevel
  lua_getfield(L, -1, 'SmithingLevel');
  aSmithingLevel := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aSettingCount
  lua_getfield(L, -1, 'SettingCount');
  aSettingCount := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aAttach
  lua_getfield(L, -1, 'Attach');
  aAttach := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aAttach
  lua_getfield(L, -1, 'createname');
  acreatename := lua_tostring(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //aDurability
  lua_getfield(L, -1, 'Durability');
  aDurability := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  NewItemSet(_nist_all, p);

  if p.rWearArr = ARR_WEAPON then
  begin
    if aSettingCount > 2 then
      aSettingCount := 2;
  end
  else
  begin
    if aSettingCount > 4 then
      aSettingCount := 4;
  end;
  if aSettingCount > 0 then
  begin
    p.rSetting.rsettingcount := aSettingCount;
    p.rboident := false;
  end;

  if (aStarLevel > 0) and (aStarLevel <= p.rStarLevelMax) then
    p.rStarLevel := aStarLevel;
  if (aSmithingLevel > 0) and (aSmithingLevel <= p.MaxUpgrade) then
    p.rSmithingLevel := aSmithingLevel;

  if aDurability > p.rDurability then
    aDurability := p.rDurability;
  if aDurability >= 0 then
    p.rCurDurability := aDurability;

  if acreatename <> '' then
    p.rcreatename := copy(acreatename, 1, 20);
  if (aAttach > 0) then
  begin
    if ItemLifeDataClass.get('X附加' + inttostr(aAttach)) <> nil then
      p.rAttach := aAttach;
    p.rboident := false;
  end;
  //返回
  lua_pushboolean(L, Boolean(user.ItemScripterADDWearITEM(@p)));
  Result := 1;
end;

//删除物品栏指定位置物品

function DelWearItemInfo(L: TLuaState): Integer; cdecl;
var
  I: Integer;
  USER: TUser;
  uObject, akey: integer;
  p: ptitemdata;
begin
  uObject := lua_tointeger(L, 1);
  akey := lua_tointeger(L, 2);
  //以上获取LUA参数
  if akey <= 0 then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  //返回
  lua_pushboolean(L, LongBool(user.ItemScripterDelWearITEM(akey)));
  Result := 1;
end;

//获取玩家是否在线

function GetUserIsPointer(L: TLuaState): Integer; cdecl;
var
  auser: TUser;
  aname: string;
  uObject: integer;
  Push: LongBool;
begin
  aname := lua_tostring(L, 1);
  //以上获取LUA参数
  uObject := -1;
  Push := LongBool(False);
  auser := UserList.GetUserPointer(aname);
  if auser <> nil then
  begin
    uObject := Integer(auser);
    Push := LongBool(True)
  end;
  Lua_PushInteger(L, uObject);
  lua_pushboolean(L, Push);
  Result := 2;
end;
//获取玩家名称

function getname(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushstring(L, pansichar(user.name));
  Result := 1;
end;
//获取玩家帐号

function GetMasterName(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  MasterName: string;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  MasterName := user.Connector.CharData.MasterName;
  lua_pushstring(L, pansichar(MasterName));
  Result := 1;
end;

//获取玩家机器码

function GetHcode(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushstring(L, pansichar(user.Connector.hcode));
  Result := 1;
end;

//获取玩家外网IP

function GetOutIpAddr(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushstring(L, pansichar(user.Connector.OutIpAddr));
  Result := 1;
end;

//获取玩家性别

function getsex(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, sex: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  sex := 0;
  if user.BasicData.Feature.rboman then
    sex := 1
  else
    sex := 2;
  Lua_PushInteger(L, sex);
  Result := 1;
end;

//获取玩家状态

function Getfeaturestate(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, state: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  state := 0;
  case user.BasicData.Feature.rfeaturestate of
    wfs_normal: state := 0;
    wfs_care: state := 1;
    wfs_sitdown: state := 2;
    wfs_die: state := 3;
    wfs_running: state := 4;
    wfs_running2: state := 5;
  end;
  Lua_PushInteger(L, state);
  Result := 1;
end;

//获取玩家境界等级

function GetEnergyLevel(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  //返回
  Lua_PushInteger(L, user.AttribClass.PowerLevelMax);
  Result := 1;
end;
//获取玩家账号

function GetAccount(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushstring(L, pansichar(user.Connector.LoginID));
  Result := 1;
end;

//获取玩家权限

function GetSysopScope(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Lua_PushInteger(L, user.SysopScope);
  Result := 1;
end;



//获取玩家包裹空格

function getitemspace(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  //返回
  Lua_PushInteger(L, user.HaveItemClass.SpaceCount);
  Result := 1;
end;
//获取玩家物品栏密码

function GetItemPassWord(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  //返回
  lua_pushstring(L, pansichar(user.HaveItemClass.getpassword));
  Result := 1;
end;
//获取玩家物品栏密码锁状态

function GetItemPassBo(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Push := LongBool(False);
  //返回
  lua_pushboolean(L, LongBool(user.HaveItemClass.LockedPass));
  Result := 1;
end;
//获取玩家当前使用的武功

function GetCurUseMagic(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, atype: integer;
  Push: string;
begin
  uObject := lua_tointeger(L, 1);
  atype := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Push := '';
  if atype = 0 then //攻击
  begin
    if USER.HaveMagicClass.pCurAttackMagic <> nil then
      Push := USER.HaveMagicClass.pCurAttackMagic.rname;
  end
  else if atype = 1 then //护体
  begin
    if USER.HaveMagicClass.pCurProtectingMagic <> nil then
      Push := USER.HaveMagicClass.pCurProtectingMagic.rname;
  end
  else if atype = 2 then //步法
  begin
    if USER.HaveMagicClass.pCurRunningMagic <> nil then
      Push := USER.HaveMagicClass.pCurRunningMagic.rname;
  end
  else if atype = 3 then //心法
  begin
    if USER.HaveMagicClass.pCurBreathngMagic <> nil then
      Push := USER.HaveMagicClass.pCurBreathngMagic.rname;
  end
  else if atype = 4 then //辅助
  begin
    if USER.HaveMagicClass.pCurEctMagic <> nil then
      Push := USER.HaveMagicClass.pCurEctMagic.rname;
  end;
  //返回
  lua_pushstring(L, pansichar(Push));
  Result := 1;
end;
//获取玩家基本属性

function GetAttrib(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_newtable(L); //创建一个表格，放在栈顶
  //年龄
  lua_pushstring(L, pansichar('Age')); //压入key
  Lua_PushInteger(L, user.AttribClass.AQgetAge);
  lua_settable(L, -3);
  //内功
  lua_pushstring(L, pansichar('InPower')); //压入key
  Lua_PushInteger(L, user.AttribClass.AQgetInPower);
  lua_settable(L, -3);
  //外功
  lua_pushstring(L, pansichar('OutPower')); //压入key
  Lua_PushInteger(L, user.AttribClass.AQgetOutPower);
  lua_settable(L, -3);
  //武功
  lua_pushstring(L, pansichar('Magic')); //压入key
  Lua_PushInteger(L, user.AttribClass.AQgetMagic);
  lua_settable(L, -3);
  //活力
  lua_pushstring(L, pansichar('Life')); //压入key
  Lua_PushInteger(L, user.AttribClass.AQgetLife);
  lua_settable(L, -3);
  //元气
  lua_pushstring(L, pansichar('Energy')); //压入key
  Lua_PushInteger(L, user.AttribClass.AQgetEnergy);
  lua_settable(L, -3);
  //浩然
  lua_pushstring(L, pansichar('Virtue')); //压入key
  Lua_PushInteger(L, user.AttribClass.GetVirtueLevel);
  lua_settable(L, -3);
  //返回
  Result := 1;
end;

//设定玩家附加属性

function SetAddLifeData(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aid, atime: integer;
  rLifeData, rLifeDataBasic: TLifeData;
  aname: string;
  push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  aid := lua_tointeger(L, 2);
  aname := lua_tostring(L, 3);
  atime := lua_tointeger(L, 4);
  //ShowMessage(aname);
  if not lua_istable(L, 5) then
    exit;
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  //damageBody
  lua_getfield(L, -1, 'damageBody');
  rLifeDataBasic.DamageBody := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //ShowMessage(inttostr(rLifeDataBasic.DamageBody));
  //damageHead
  lua_getfield(L, -1, 'damageHead');
  rLifeDataBasic.damageHead := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //damageArm
  lua_getfield(L, -1, 'damageArm');
  rLifeDataBasic.damageArm := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //damageLeg
  lua_getfield(L, -1, 'damageLeg');
  rLifeDataBasic.damageLeg := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorBody
  lua_getfield(L, -1, 'armorBody');
  rLifeDataBasic.armorBody := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorHead
  lua_getfield(L, -1, 'armorHead');
  rLifeDataBasic.armorHead := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorArm
  lua_getfield(L, -1, 'armorArm');
  rLifeDataBasic.armorArm := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorLeg
  lua_getfield(L, -1, 'armorLeg');
  rLifeDataBasic.armorLeg := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //AttackSpeed
  lua_getfield(L, -1, 'AttackSpeed');
  rLifeDataBasic.AttackSpeed := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //avoid
  lua_getfield(L, -1, 'avoid');
  rLifeDataBasic.avoid := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //recovery
  lua_getfield(L, -1, 'recovery');
  rLifeDataBasic.recovery := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //accuracy
  lua_getfield(L, -1, 'accuracy');
  rLifeDataBasic.accuracy := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //HitArmor
  lua_getfield(L, -1, 'HitArmor');
  rLifeDataBasic.HitArmor := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  user := TUser(uObject);
  push := user.LifeDataList.AddScript(aid, aname, rLifeDataBasic, atime);

  //返回
  lua_pushboolean(L, Boolean(push));
  Result := 1;
end;

//获取玩家怪物Buff
function GetAddBuff(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  MONSTER: TMonster;
  uObject, aid, atime: integer;
begin
  uObject := lua_tointeger(L, 1);
  aid := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) and not (TObject(uObject) is TMonster) then
    exit;

  atime := -1;
  if (TObject(uObject) is TUser) then
  begin
    user := TUser(uObject);
    atime := user.GetBuffer(1000 + aid);
  end
  else if (TObject(uObject) is TMonster) then
  begin
    monster := TMonster(uObject);
    atime := monster.GetBuffer(1000 + aid);
  end;
  //返回
  lua_pushinteger(L, atime);
  Result := 1;
end;
//设定玩家怪物Buff
function SetAddBuff(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  MONSTER: TMonster;
  uObject, aid, atime, asharp, aeffect: integer;
  rLifeData, rLifeDataBasic: TLifeData;
  aname, adesc: string;
  push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  aid := lua_tointeger(L, 2);
  aname := lua_tostring(L, 3);
  atime := lua_tointeger(L, 4);
  asharp := lua_tointeger(L, 5);
  aeffect := lua_tointeger(L, 6);
  adesc := lua_tostring(L, 7);
  //ShowMessage(aname);
  if not lua_istable(L, 8) then
    exit;
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) and not (TObject(uObject) is TMonster) then
    exit;
  //damageBody
  lua_getfield(L, -1, 'damageBody');
  rLifeDataBasic.DamageBody := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //ShowMessage(inttostr(rLifeDataBasic.DamageBody));
  //damageHead
  lua_getfield(L, -1, 'damageHead');
  rLifeDataBasic.damageHead := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //damageArm
  lua_getfield(L, -1, 'damageArm');
  rLifeDataBasic.damageArm := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //damageLeg
  lua_getfield(L, -1, 'damageLeg');
  rLifeDataBasic.damageLeg := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorBody
  lua_getfield(L, -1, 'armorBody');
  rLifeDataBasic.armorBody := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorHead
  lua_getfield(L, -1, 'armorHead');
  rLifeDataBasic.armorHead := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorArm
  lua_getfield(L, -1, 'armorArm');
  rLifeDataBasic.armorArm := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorLeg
  lua_getfield(L, -1, 'armorLeg');
  rLifeDataBasic.armorLeg := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //AttackSpeed
  lua_getfield(L, -1, 'AttackSpeed');
  rLifeDataBasic.AttackSpeed := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //avoid
  lua_getfield(L, -1, 'avoid');
  rLifeDataBasic.avoid := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //recovery
  lua_getfield(L, -1, 'recovery');
  rLifeDataBasic.recovery := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //accuracy
  lua_getfield(L, -1, 'accuracy');
  rLifeDataBasic.accuracy := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //HitArmor
  lua_getfield(L, -1, 'HitArmor');
  rLifeDataBasic.HitArmor := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  if (TObject(uObject) is TUser) then
  begin
    user := TUser(uObject);
    push := user.AddBuffer(aid, aname, rLifeDataBasic, atime, asharp, aeffect, adesc);
  end
  else if (TObject(uObject) is TMonster) then
  begin
    monster := TMonster(uObject);
    push := monster.AddBuffer(aid, aname, rLifeDataBasic, atime, asharp, aeffect, adesc);
  end;

  //返回
  lua_pushboolean(L, Boolean(push));
  Result := 1;
end;

  //获取玩家怪物MultiplyBuff
function GetAddMulBuff(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  MONSTER: TMonster;
  uObject, aid, atime: integer;
begin
  uObject := lua_tointeger(L, 1);
  aid := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) and not (TObject(uObject) is TMonster) then
    exit;

  if (TObject(uObject) is TUser) then
  begin
    user := TUser(uObject);
    atime := user.GetMultiplyBuffer(1000 + aid);
  end
  else if (TObject(uObject) is TMonster) then
  begin
    monster := TMonster(uObject);
    atime := monster.GetMultiplyBuffer(1000 + aid);
  end;

  //返回
  lua_pushinteger(L, atime);
  Result := 1;
end;
//设定玩家怪物MultiplyBuff
function SetAddMulBuff(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  MONSTER: TMonster;
  uObject, aid, atime, asharp, aeffect: integer;
  rLifeData, rLifeDataBasic: TLifeData;
  aname, adesc: string;
  push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  aid := lua_tointeger(L, 2);
  aname := lua_tostring(L, 3);
  atime := lua_tointeger(L, 4);
  asharp := lua_tointeger(L, 5);
  aeffect := lua_tointeger(L, 6);
  adesc := lua_tostring(L, 7);
  //ShowMessage(aname);
  if not lua_istable(L, 8) then
    exit;
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) and not (TObject(uObject) is TMonster) then
    exit;
  //damageBody
  lua_getfield(L, -1, 'damageBody');
  rLifeDataBasic.DamageBody := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //ShowMessage(inttostr(rLifeDataBasic.DamageBody));
  //damageHead
  lua_getfield(L, -1, 'damageHead');
  rLifeDataBasic.damageHead := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //damageArm
  lua_getfield(L, -1, 'damageArm');
  rLifeDataBasic.damageArm := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //damageLeg
  lua_getfield(L, -1, 'damageLeg');
  rLifeDataBasic.damageLeg := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorBody
  lua_getfield(L, -1, 'armorBody');
  rLifeDataBasic.armorBody := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorHead
  lua_getfield(L, -1, 'armorHead');
  rLifeDataBasic.armorHead := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorArm
  lua_getfield(L, -1, 'armorArm');
  rLifeDataBasic.armorArm := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //armorLeg
  lua_getfield(L, -1, 'armorLeg');
  rLifeDataBasic.armorLeg := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //AttackSpeed
  lua_getfield(L, -1, 'AttackSpeed');
  rLifeDataBasic.AttackSpeed := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //avoid
  lua_getfield(L, -1, 'avoid');
  rLifeDataBasic.avoid := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //recovery
  lua_getfield(L, -1, 'recovery');
  rLifeDataBasic.recovery := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //accuracy
  lua_getfield(L, -1, 'accuracy');
  rLifeDataBasic.accuracy := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //HitArmor
  lua_getfield(L, -1, 'HitArmor');
  rLifeDataBasic.HitArmor := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  if (TObject(uObject) is TUser) then
  begin
    user := TUser(uObject);
    push := user.AddMultiplyBuffer(aid, aname, rLifeDataBasic, atime, asharp, aeffect, adesc);
  end
  else if (TObject(uObject) is TMonster) then
  begin
    monster := TMonster(uObject);
    push := monster.AddMultiplyBuffer(aid, aname, rLifeDataBasic, atime, asharp, aeffect, adesc);
  end;

  //返回
  lua_pushboolean(L, Boolean(push));
  Result := 1;
end;

//设置怪物武功

function SetMonsterMagic(L: TLuaState): Integer; cdecl;
var
  Monster: TMonster;
  uObject: integer;
  amagicname: string;
  aid, aai, aexp: integer;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  amagicname := lua_tostring(L, 2);
  aid := lua_tointeger(L, 3);
  aai := lua_tointeger(L, 4); //0 正常 1 单体攻击 2 全屏攻击
  aexp := lua_tointeger(L, 5);
  //执行
  if not (TObject(uObject) is TMonster) then
    exit;
  Monster := TMonster(uObject);
  Monster.SetAttackMagic(amagicname, aid, aai, aexp);
  //返回
  lua_pushboolean(L, Boolean(True));
  Result := 1;
end;

//设置怪物魔法

function SetMonsterHaveMagic(L: TLuaState): Integer; cdecl;
var
  Monster: TMonster;
  uObject: integer;
  amagicname: string;
  aid: integer;
  aPara: TMagicParamData;
  push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  aid := lua_tointeger(L, 2);
  amagicname := lua_tostring(L, 3);
  //ShowMessage(aname);
  if not lua_istable(L, 4) then
    exit;
  //以上获取LUA参数
  if not (TObject(uObject) is TMonster) then
    exit;
  //PName1
  lua_getfield(L, -1, 'PName1');
  aPara.NameParam[0] := lua_tostring(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PName2
  lua_getfield(L, -1, 'PName2');
  aPara.NameParam[1] := lua_tostring(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PName3
  lua_getfield(L, -1, 'PName3');
  aPara.NameParam[2] := lua_tostring(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PName4
  lua_getfield(L, -1, 'PName4');
  aPara.NameParam[3] := lua_tostring(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PName5
  lua_getfield(L, -1, 'PName5');
  aPara.NameParam[4] := lua_tostring(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PNum1
  lua_getfield(L, -1, 'PNum1');
  aPara.NumberParam[0] := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PNum2
  lua_getfield(L, -1, 'PNum2');
  aPara.NumberParam[1] := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PNum3
  lua_getfield(L, -1, 'PNum3');
  aPara.NumberParam[2] := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PNum4
  lua_getfield(L, -1, 'PNum4');
  aPara.NumberParam[3] := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //PNum5
  lua_getfield(L, -1, 'PNum5');
  aPara.NumberParam[4] := lua_tointeger(L, -1);
  lua_pop(L, 1); //获取下一个值之前要POP下
  //执行
  Monster := TMonster(uObject);
  push := Monster.SetHaveMagicExt(amagicname, aPara, aid);

  //返回
  lua_pushboolean(L, Boolean(push));
  Result := 1;
end;

function additem(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  aTItemData: TItemData;
  uObject: integer;
  aitemname, aname: string;
  acount: integer;
begin
  uObject := lua_tointeger(L, 1);
  aitemname := lua_tostring(L, 2);
  acount := lua_tointeger(L, 3);
  aname := lua_tostring(L, 4);
  //以上获取LUA参数
  lua_pushboolean(L, Boolean(False));
  aitemname := trim(aitemname);
  if aitemname = '' then
    exit;
  if acount <= 0 then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if not ItemClass.GetItemData(aitemname, aTItemData) then
    exit;
  aTItemData.rCount := acount;
  NewItemSet(_nist_all, aTItemData);
  //返回
  lua_pushboolean(L, Boolean(user.ItemScripterADDITEM(@aTItemData, aname)));
  Result := 1;
end;

function MapMove(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  amapid, ax, ay, aDelayTick: integer;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  amapid := lua_tointeger(L, 2);
  ax := lua_tointeger(L, 3);
  ay := lua_tointeger(L, 4);
  aDelayTick := lua_tointeger(L, 5);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.MoveToMap(amapid, ax, ay, aDelayTick);
  //返回
  lua_pushboolean(L, Boolean(True));
  Result := 1;
end;

function NotMoveUser(L: TLuaState): Integer; cdecl;
var
  auser: Tuser;
  aname: string;
  atime: integer;
begin
  //获取参数
  aname := lua_tostring(L, 1);
  atime := lua_tointeger(L, 2);
  //执行
  auser := UserList.GetUserPointer(aname);
  if auser = nil then
    exit;
  auser.LockNotMove(atime);
  auser.SendClass.lockmoveTime(atime);
  Result := 0;
end;

//改变指定玩家武功等级

function SetMagicLevel(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  MagicName: string;
  MagicLevel: integer;
  push: LongBool;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  MagicName := lua_tostring(L, 2);
  MagicLevel := lua_tointeger(L, 3);
  //执行
  //判断武功名称
  MagicName := trim(MagicName);
  if MagicName = '' then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if MagicLevel >= 0 then
    push := LongBool(user.SetMagicLevel(MagicName, MagicLevel));
  //返回
  lua_pushboolean(L, push);
  Result := 1;
end;

//获取指定玩家武功等级

function GetMagicLevel(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  MagicName: string;
  push: integer;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  MagicName := lua_tostring(L, 2);
  //执行
  push := 0;
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  push := user.getMagicLevel(MagicName);
  //返回
  Lua_PushInteger(L, push);
  Result := 1;
end;

//添加武功

function AddMagicAndLevel(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  MagicData: tMagicData;
  uObject: integer;
  MagicName: string;
  MagicLevel: integer;
  push: LongBool;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  MagicName := lua_tostring(L, 2);
  MagicLevel := lua_tointeger(L, 3);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  //判断等级范围
  if (MagicLevel > 9999) or (MagicLevel < 100) then
    MagicLevel := 100;

  if MagicClass.GetMagicData(MagicName, MagicData, GetLevelExp(MagicLevel)) = false then
    exit;
  push := LongBool(user.AddMagicAndLevel(@MagicData));
  //返回
  lua_pushboolean(L, push);
  Result := 1;
end;

//发玩家屏幕左侧消息

function LeftText(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  astr: string;
  acolor: integer;
  loc: integer;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  astr := lua_tostring(L, 2);
  acolor := lua_tointeger(L, 3);
  loc := lua_tointeger(L, 4);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  acolor := ColorSysToDxColor(acolor);
  if loc = 1 then
    user.SendClass.SendLeftText(astr, acolor, mtLeftText)
  else if loc = 2 then
    user.SendClass.SendLeftText(astr, acolor, mtLeftText2)
  else if loc = 3 then
    user.SendClass.SendLeftText(astr, acolor, mtLeftText3)
  else if loc = 4 then
    user.SendClass.SendLeftText(astr, acolor, mtLeftText4);
  //返回
  Result := 0;
end;

//获取玩家点击NPC菜单

function GetMenuCommand(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  //返回
  lua_pushstring(L, pansichar(user.MenuCommand));
  Result := 1;
end;
//获取玩家门派名称

function GuildGetName(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  GuildName: string;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if user.uGuildObject <> nil then
    GuildName := Tguildobject(user.uGuildObject).GuildName;
  //返回
  lua_pushstring(L, pansichar(GuildName));
  Result := 1;
end;
//获取玩家门派贡献

function GetGuildPoint(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, GuildPoint: integer;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  GuildPoint := 0;
  user := TUser(uObject);
  if user.uGuildObject <> nil then
    GuildPoint := user.AttribClass.GuildPoint;
  //返回
  Lua_PushInteger(L, GuildPoint);
  Result := 1;
end;

//写入玩家门派贡献

function SetGuildPoint(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, GuildPoint: integer;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  GuildPoint := lua_tointeger(L, 2);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if user.uGuildObject <> nil then
    user.AttribClass.GuildPoint := GuildPoint;
  //返回
  Result := 0;
end;

function BoFreedom(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  Push: LongBool;
begin
  //获取参数
  uObject := lua_tointeger(L, 1);
  //执行
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Push := LongBool(False);
  if user.SpecialWindow = WINDOW_NONE then
    Push := LongBool(true);
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;
//M(无对象语句)

function centermsg(L: TLuaState): Integer; cdecl;
var
  atext: string;
  acolor: integer;
begin
  atext := lua_tostring(L, 1);
  acolor := lua_tointeger(L, 2);
  //以上获取LUA参数
  UserList.SendCenterMSG(ColorSysToDxColor(acolor), atext, SHOWCENTERMSG_BatMsg);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//播放变色消息

function CenterMagicMSG(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  aMsg, aCols: string;
  bo: TBasicObject;
  Push: LongBool;
begin
  aMsg := lua_tostring(L, 1);
  aCols := lua_tostring(L, 2);
  //以上获取LUA参数
  UserList.SendCenterMagicMSG(aMsg, aCols);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//发送聊天框自定义颜色消息

function worldnoticemsg(L: TLuaState): Integer; cdecl;
var
  atext: string;
  afcolor, abcolor: integer;
begin
  atext := lua_tostring(L, 1);
  afcolor := lua_tointeger(L, 2);
  abcolor := lua_tointeger(L, 3);
  //以上获取LUA参数
  UserList.SendNoticeMessage2(atext, ColorSysToDxColor(afcolor), ColorSysToDxColor(abcolor));
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//发送聊天框自定义颜色消息 + 物品

function worldnoticemsgitem(L: TLuaState): Integer; cdecl;
var
  atext: string;
  afcolor, abcolor, aitem: integer;
  c: TUserTmpData;
begin
  atext := lua_tostring(L, 1);
  afcolor := lua_tointeger(L, 2);
  abcolor := lua_tointeger(L, 3);
  aitem := lua_tointeger(L, 4);
  //以上获取LUA参数
  c := TUserTmpData(aitem);
  UserList.SendNoticeMessage2Ex(atext, ColorSysToDxColor(afcolor), ColorSysToDxColor(abcolor), c.FSayItem);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;
//发送聊天框系统颜色消息

function worldnoticesysmsg(L: TLuaState): Integer; cdecl;
var
  atext: string;
  acolor: integer;
begin
  atext := lua_tostring(L, 1);
  acolor := lua_tointeger(L, 2);
  //以上获取LUA参数
  UserList.SendNoticeMessage(atext, acolor);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//发送全服特效
function SendEffectEx(L: TLuaState): Integer; cdecl;
var
  aEffectNum, atype, acount: integer;
begin
  aEffectNum := lua_tointeger(L, 1);
  atype := lua_tointeger(L, 2);
  acount := lua_tointeger(L, 3);
  //以上获取LUA参数
  if aEffectNum <= 0 then
    exit;
  case atype of
    0: UserList.SendEffectEx(aEffectNum, lek_none, acount);   
    1: UserList.SendEffectEx(aEffectNum, lek_follow, acount);
    2: UserList.SendEffectEx(aEffectNum, lek_cumulate, acount);
    3: UserList.SendEffectEx(aEffectNum, lek_cumulate_follow, acount);
  end;
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;



//发送TOP 消息框

function topmsg(L: TLuaState): Integer; cdecl;
var
  atext: string;
  acolor: integer;
begin
  atext := lua_tostring(L, 1);
  acolor := lua_tointeger(L, 2);
  //以上获取LUA参数
  UserList.SendTopMSG(ColorSysToDxColor(acolor), atext);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;
//发送LEFT 消息框

function leftmsg(L: TLuaState): Integer; cdecl;
var
  atext: string;
  acolor, atype, ashape: integer;
begin
  atext := lua_tostring(L, 1);
  acolor := lua_tointeger(L, 2);
  atype := lua_tointeger(L, 3);
  if atype > 10 then
    ashape := lua_tointeger(L, 4)
  else
    ashape := 0;
  //以上获取LUA参数
  if atype = 1 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText)
  else if atype = 2 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText2)
  else if atype = 3 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText3)
  else if atype = 4 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText4)
  else if atype = 11 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText, ashape)
  else if atype = 12 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText2, ashape)
  else if atype = 13 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText3, ashape)
  else if atype = 14 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText4, ashape)
  else if atype = 21 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText)
  else if atype = 22 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText2)
  else if atype = 23 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText3)
  else if atype = 24 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText4);

  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;
//发送LEFT 消息框

function leftmsgitem(L: TLuaState): Integer; cdecl;
var
  atext: string;
  acolor, atype, ashape, aitem: integer;
  c: TUserTmpData;
begin
  atext := lua_tostring(L, 1);
  acolor := lua_tointeger(L, 2);
  atype := lua_tointeger(L, 3);
  ashape := lua_tointeger(L, 4);
  aitem := lua_tointeger(L, 5);
  //以上获取LUA参数
  c := TUserTmpData(aitem);
  atext := Copy(atext, 1, c.FSayItem.rpos) + '[' + c.FSayItem.rChatItemData.rName + ']' + Copy(atext, c.FSayItem.rpos + 1, Length(atext));
  if atype = 1 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText)
  else if atype = 2 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText2)
  else if atype = 3 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText3)
  else if atype = 4 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftText4)
  else if atype = 11 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText, ashape)
  else if atype = 12 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText2, ashape)
  else if atype = 13 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText3, ashape)
  else if atype = 14 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftLightText4, ashape)  
  else if atype = 21 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText)
  else if atype = 22 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText2)
  else if atype = 23 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText3)
  else if atype = 24 then
    UserList.SendLeftMSG(ColorSysToDxColor(acolor), atext, mtLeftBigText4);

  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//发送门派消息

function GuildSay(L: TLuaState): Integer; cdecl;
var
  aGuildName, atext: string;
  acolor: integer;
  GuildObject: TGuildObject;
begin
  aGuildName := lua_tostring(L, 1);
  atext := lua_tostring(L, 2);
  acolor := lua_tointeger(L, 3);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(aGuildName);
  if GuildObject = nil then
    Exit;

  UserList.GuildSay(aGuildName, atext, acolor);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//发送自定义颜色门派消息

function GuildSayByCol(L: TLuaState): Integer; cdecl;
var
  aGuildName, atext: string;
  aFColor, aBColor: integer;
  GuildObject: TGuildObject;
begin
  aGuildName := lua_tostring(L, 1);
  atext := lua_tostring(L, 2);
  aFColor := lua_tointeger(L, 3);
  aBColor := lua_tointeger(L, 4);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(aGuildName);
  if GuildObject = nil then
    Exit;

  UserList.GuildSayByCol(aGuildName, atext, aFColor, aBColor);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;


//获取某玩家门派职位

function IsGuildSysOp(L: TLuaState): Integer; cdecl;
var
  GuildName, PlayName: string;
  Push: integer;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  PlayName := lua_tostring(L, 2);

  Push := 0;
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject <> nil then
  begin
    if GuildObject.IsGuildSysop(PlayName) = true then
      Push := 1
    else if GuildObject.IsGuildSubSysop(PlayName) = true then
      Push := 2
    else if GuildObject.IsGuildUser(PlayName) = true then
      Push := 3;
  end;
  //以上获取LUA参数
  Lua_PushInteger(L, Push);
  //下边这行必加 中间保持原对应方法内容
  Result := 1;
end;



//B(基本OBJ对象语句)
//查询周边目标

function FindObjectByName(L: TLuaState): Integer; cdecl;
var
  uObject, aRace: integer;
  aName: string;
  Push: LongBool;
  aBasicObject, pBasicObject: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  aName := lua_tostring(L, 2);
  aRace := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  aBasicObject := TBasicObject(uObject);
  //查找数据
  Push := LongBool(False);
  pBasicObject := aBasicObject.GetViewObjectByName(aName, aRace);
  if pBasicObject <> nil then
  begin
    uObject := Integer(pBasicObject);
    Push := LongBool(True)
  end;
  //返回
  Lua_PushInteger(L, uObject);
  lua_pushboolean(L, Push);
  Result := 2;
end;
//冻结目标

function CommandIce(L: TLuaState): Integer; cdecl;
var
  uObject, atime: integer;
  aBasicObject: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  atime := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  aBasicObject := TBasicObject(uObject);
  //冻结目标
  aBasicObject.LockNotMove(atime);
  //返回
  Result := 0;
end;
//删除目标

function DelObjByID(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  atype: string;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  atype := lua_tostring(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  //判断删除类型
  if atype = 'NPC' then
  begin
    if (TObject(uObject) is TBasicObject) then
    begin
      TBasicObject(uObject).boAllowDelete := true;
      Push := LongBool(true);
    end;
  end
  else if atype = 'MONSTER' then
  begin
    if (TObject(uObject) is TMonster) then
    begin
      TMonster(uObject).boAllowDelete := true;
      Push := LongBool(true);
    end;
  end
  else if atype = 'DYNAMICOBJECT' then
  begin
    if (TObject(uObject) is TDynamicObject) then
    begin
      TDynamicObject(uObject).boAllowDelete := true;
      Push := LongBool(true);
    end;
  end;
  lua_pushboolean(L, Push);
  //返回
  Result := 1;
end;
//获取对象真实名字

function GetRealName(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  //返回
  lua_pushstring(L, pansichar(AnsiString(bo.BasicData.Name)));
  Result := 1;
end;

//获取对象显示名字

function GetViewName(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  //返回
  lua_pushstring(L, pansichar(AnsiString(bo.BasicData.ViewName)));
  Result := 1;
end;

//全屏幕攻击

function HIT_Screen(L: TLuaState): Integer; cdecl;
var
  uObject, aHit: integer;
  bo: TBasicObject;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  aHit := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  if aHit <= 0 then
    exit;
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  bo.HIT_Screen(aHit);
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  //返回
  Result := 1;
end;

//播放声音

function ShowSound(L: TLuaState): Integer; cdecl;
var
  uObject, asound: integer;
  bo: TBasicObject;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  asound := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  if asound <= 0 then
    exit;
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  bo.ShowSound(asound);
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  //返回
  Result := 1;
end;
//播放特效

function ShowEffect(L: TLuaState): Integer; cdecl;
var
  uObject, aEffectNum, atype: integer;
  bo: TBasicObject;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  aEffectNum := lua_tointeger(L, 2);
  atype := lua_tointeger(L, 3);
  //以上获取LUA参数
  Push := LongBool(false);
  if aEffectNum <= 0 then
    exit;
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  if atype = 0 then
    bo.ShowEffect(aEffectNum, lek_none)
  else if atype = 1 then
    bo.ShowEffect(aEffectNum, lek_follow)
  else if atype = 2 then
    bo.ShowEffect(aEffectNum, lek_cumulate)
  else if atype = 3 then
    bo.ShowEffect(aEffectNum, lek_cumulate_follow)
  else
    exit;
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  //返回
  Result := 1;
end;
//播放特效(带播放次数)

function ShowEffectEx(L: TLuaState): Integer; cdecl;
var
  uObject, aEffectNum, atype, acount: integer;
  bo: TBasicObject;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  aEffectNum := lua_tointeger(L, 2);
  atype := lua_tointeger(L, 3);
  acount := lua_tointeger(L, 4);
  //以上获取LUA参数
  Push := LongBool(false);
  if aEffectNum <= 0 then
    exit;
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  if atype = 0 then
    bo.ShowEffect(aEffectNum, lek_none, acount)
  else if atype = 1 then
    bo.ShowEffect(aEffectNum, lek_follow, acount)
  else if atype = 2 then
    bo.ShowEffect(aEffectNum, lek_cumulate, acount)
  else if atype = 3 then
    bo.ShowEffect(aEffectNum, lek_cumulate_follow, acount)
  else
    exit;
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  //返回
  Result := 1;
end;

//获取目标种族

function GetRace(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  //返回
  Lua_PushInteger(L, bo.BasicData.Feature.rrace);
  Result := 1;
end;

//获取目标种族

function ObjectBoNotHit(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  bo: TBasicObject;
  astate: Boolean;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  astate := lua_toboolean(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  //返回
  bo := TBasicObject(uObject);
  bo.BasicData.boNotHit := astate;
  Push := LongBool(true);
  Lua_Pushboolean(L, Push);
  Result := 1;
end;

//改变动态物品状态

function DynamicobjectChange(L: TLuaState): Integer; cdecl;
var
  uObject, astate: integer;
  DynamicObject: TDynamicObject;
  aObjectStatus: TDynamicObjectState;
  Push: LongBool;
begin
  uObject := lua_tointeger(L, 1);
  astate := lua_tointeger(L, 2);

  //以上获取LUA参数
  Push := LongBool(False);
  if not (TObject(uObject) is TDynamicobject) then
    exit;
  DynamicObject := TDynamicobject(uObject);
  if astate = 1 then
    aObjectStatus := dos_Closed
  else if astate = 2 then
    aObjectStatus := dos_Openning
  else if astate = 3 then
    aObjectStatus := dos_Openned
  else if astate = 0 then
    aObjectStatus := dos_Scroll
  else
    exit;
  if (DynamicObject.ObjectStatus = aObjectStatus) and (aObjectStatus <> dos_Openning) then
    exit;
  DynamicObject.SetObjectStatus(aObjectStatus);

  Push := LongBool(true);
  //返回
  Lua_Pushboolean(L, Push);
  Result := 1;
end;
//获取动态物品状态

function DynamicobjectGet(L: TLuaState): Integer; cdecl;
var
  uObject, astate: integer;
  DynamicObject: TDynamicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TDynamicobject) then
    exit;
  astate := 0;
  DynamicObject := TDynamicobject(uObject);
  //返回
  if DynamicObject.ObjectStatus = dos_Closed then
    astate := 1
  else if DynamicObject.ObjectStatus = dos_Openning then
    astate := 2
  else if DynamicObject.ObjectStatus = dos_Openned then
    astate := 3
  else if DynamicObject.ObjectStatus = dos_Scroll then
    astate := 0
  else
    exit;
  Lua_PushInteger(L, astate);
  Result := 1;
end;

//获取动态物品打开时间

function GetDynamicOpenedTick(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  DynamicObject: TDynamicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TDynamicobject) then
    exit;
  DynamicObject := TDynamicobject(uObject);
  //返回
  Lua_PushInteger(L, DynamicObject.OpenedTick);
  Result := 1;
end;

//获取动态物品打开时间

function GotoXyStand(L: TLuaState): Integer; cdecl;
var
  uObject, ax, ay: integer;
  Bo: TBasicObject;
  AttackSkill: TAttackSkill;
begin
  uObject := lua_tointeger(L, 1);
  ax := lua_tointeger(L, 2);
  ay := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  Bo := TBasicObject(uObject);
  if Bo.BasicData.Feature.rrace = RACE_MONSTER then
  begin
    AttackSkill := TMonster(Bo).GetAttackSkill;
  end
  else if Bo.BasicData.Feature.rrace = RACE_NPC then
  begin
    AttackSkill := TNpc(Bo).GetAttackSkill;

  end;
  if AttackSkill <> nil then
  begin
    AttackSkill.TargetX := ax;
    AttackSkill.TargetY := ay;
  end;

  Result := 0;
end;

//获取目标周边坐标

function GetNearXy(L: TLuaState): Integer; cdecl;
var
  uObject, nX, nY: integer;
  bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);

  nX := bo.BasicData.x;
  nY := bo.BasicData.y;
  if bo.Maper.GetNearXy(nX, nY) = false then
    exit;
  //返回
  Lua_PushInteger(L, nX);
  Lua_PushInteger(L, nY);
  Result := 2;
end;
//获取对象团队

function GetGroupKey(L: TLuaState): Integer; cdecl;
var
  uObject, fellowship: integer;
  bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  fellowship := bo.BasicData.Feature.rfellowship;
  //返回
  Lua_PushInteger(L, fellowship);
  Result := 1;
end;

//设定对象团队

function SetGroupKey(L: TLuaState): Integer; cdecl;
var
  uObject, fellowship, i, PROC: integer;
  Acolor: word;
  bo: TBasicObject;
  Push: LongBool;
  SubData: TSubData;
begin
  uObject := lua_tointeger(L, 1);
  fellowship := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  if (fellowship < 100) or (fellowship > 65535) then
  begin
    exit;
  end
  else
  begin
    bo.BasicData.Feature.rfellowship := fellowship;
    i := (fellowship - 100) mod 18;
    case i of
      0:
        Acolor := ColorSysToDxColor($0000FF); // = TColor($000000);
      1:
        Acolor := ColorSysToDxColor($BDFF19); // = TColor($000080);
      2:
        Acolor := ColorSysToDxColor($63FFE6); //= TColor($008000);
      3:
        Acolor := ColorSysToDxColor($EF42AD); //= TColor($008080);
      4:
        Acolor := ColorSysToDxColor($FFFFFF); //= TColor($800000);
      5:
        Acolor := ColorSysToDxColor($73FFFF); // = TColor($800080);
      6:
        Acolor := ColorSysToDxColor($FF0000); //= TColor($808000);
      7:
        Acolor := ColorSysToDxColor($10FF7B); //= TColor($808080);
      8:
        Acolor := ColorSysToDxColor($FF9CCE); // = TColor($C0C0C0);
      9:
        Acolor := ColorSysToDxColor($FFFF10); //= TColor($0000FF);
      10:
        Acolor := ColorSysToDxColor($F7A5FF); //= TColor($00FF00);
      11:
        Acolor := ColorSysToDxColor($08CEF7); //= TColor($00FFFF);
      12:
        Acolor := ColorSysToDxColor($E608EF); //= TColor($FF0000);
      13:
        Acolor := ColorSysToDxColor($FFB521); // = TColor($FF00FF);
      14:
        Acolor := ColorSysToDxColor($4284FF); //= TColor($FFFF00);
      15:
        Acolor := ColorSysToDxColor($C5E694); // = TColor($C0C0C0);
      16:
        Acolor := ColorSysToDxColor($ADCEFF); //= TColor($808080);
      17:
        Acolor := ColorSysToDxColor($00F7AD); //= TColor($FFFFFF);
    end;
    bo.BasicData.Feature.rNameColor := Acolor;
    if bo.SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE_NameColor, bo.BasicData, SubData) = PROC_TRUE then
    begin
      Push := LongBool(true);
    end
  end;
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;
//获取对象地图和坐标

function GetPosition(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  //返回
  Lua_PushInteger(L, bo.ServerID);
  Lua_PushInteger(L, bo.BasicData.x);
  Lua_PushInteger(L, bo.BasicData.y);
  Result := 3;
end;

function GetDynamicServerID(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  DynamicObject: TDynamicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TDynamicobject) then
    exit;
  DynamicObject := TDynamicobject(uObject);
  //返回
  ShowMessage(IntToStr(DynamicObject.ServerID));
  Lua_PushInteger(L, DynamicObject.ServerID);
  Result := 1;
end;


//获取对象地图ID

function GetServerID(L: TLuaState): Integer; cdecl;
var
  uObject: integer;
  bo: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  bo := TBasicObject(uObject);
  //返回
  Lua_PushInteger(L, bo.ServerID);
  Result := 1;
end;

//获取对象当前血量

function GetCurLife(L: TLuaState): Integer; cdecl;
var
  uObject, Push: integer;
  aBasicObject: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  Push := 0;
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  aBasicObject := TBasicObject(uObject);
  if aBasicObject.BasicData.Feature.rrace = RACE_HUMAN then
  begin
    Push := TUser(uObject).AttribClass.CurLife;
  end;
  if (aBasicObject.BasicData.Feature.rrace = RACE_MONSTER) or (aBasicObject.BasicData.Feature.rrace = RACE_NPC) then
  begin
    Push := TLifeObject(uObject).getCurLife;
  end;
  //返回
  Lua_PushInteger(L, Push);
  Result := 1;
end;
//获取对象最大血量

function GetMaxLife(L: TLuaState): Integer; cdecl;
var
  uObject, Push: integer;
  aBasicObject: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  Push := 0;
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  aBasicObject := TBasicObject(uObject);
  if aBasicObject.BasicData.Feature.rrace = RACE_HUMAN then
  begin
    Push := TUser(uObject).AttribClass.MaxLife;
  end;
  if (aBasicObject.BasicData.Feature.rrace = RACE_MONSTER) or (aBasicObject.BasicData.Feature.rrace = RACE_NPC) then
  begin
    Push := TLifeObject(uObject).getMaxLife;
  end;
  //返回
  Lua_PushInteger(L, Push);
  Result := 1;
end;
//改变目标血量

function ChangeLife(L: TLuaState): Integer; cdecl;
var
  uObject, Life: integer;
  aBasicObject: TBasicObject;
begin
  uObject := lua_tointeger(L, 1);
  Life := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  aBasicObject := TBasicObject(uObject);
  if aBasicObject.BasicData.Feature.rrace = RACE_HUMAN then
  begin
    TUser(uObject).AttribClass.CurLife := TUser(uObject).AttribClass.CurLife + Life;
  end;
  if (aBasicObject.BasicData.Feature.rrace = RACE_MONSTER) or (aBasicObject.BasicData.Feature.rrace = RACE_NPC) then
  begin
    TLifeObject(uObject).ScripAddLife(Life);
  end;
  //返回
  Result := 0;
end;


//返回服务器在线玩家列表

function GetAllOnlineUser(L: TLuaState): Integer; cdecl;
var
  i, s, e: integer;
  User: TUser;
  uname: string;
begin
  s := lua_tointeger(L, 1);
  e := lua_tointeger(L, 2);
  //以上获取LUA参数
  if s > UserList.DataList.Count then
    s := UserList.DataList.Count;
  if e > UserList.DataList.Count then
    e := UserList.DataList.Count;

  lua_newtable(L); //创建一个表格，放在栈顶
 // for i := 0 to UserList.DataList.Count - 1 do
  for i := s - 1 to e - 1 do
  begin
    User := UserList.DataList.Items[i];
    if User <> nil then
    begin
      uname := User.BasicData.Name;
      lua_pushstring(L, pansichar(uname)); //压入key
      Lua_PushInteger(L, Integer(User));
      lua_settable(L, -3);
    end;
  end;
  //返回
  Result := 1;
end;

//获取指定地图玩家列表

function GetMapOnlineUser(L: TLuaState): Integer; cdecl;
var
  aServerID, i, s, e, n: integer;
  User: TUser;
  uname: string;
begin
  aServerID := lua_tointeger(L, 1);
  s := lua_tointeger(L, 2);
  e := lua_tointeger(L, 3);
  //以上获取LUA参数
  if s > UserList.DataList.Count then
    s := UserList.DataList.Count;
  if e > UserList.DataList.Count then
    e := UserList.DataList.Count;

  n := 0;
  lua_newtable(L); //创建一个表格，放在栈顶
  for i := 0 to UserList.DataList.Count - 1 do
  begin
    User := UserList.DataList.Items[i];
    if User.ServerID = aServerID then
    begin
      inc(n);
      if (n >= s) and (n <= e) then
      begin
        uname := User.BasicData.Name;
        lua_pushstring(L, pansichar(uname)); //压入key
        Lua_PushInteger(L, Integer(User));
        lua_settable(L, -3);
      end;
    end;
  end;
  //返回
  Result := 1;
end;

//获取周边玩家

function FindViewUserObjectList(L: TLuaState): Integer; cdecl;
var
  uObject, atime: integer;
  aBasicObject: TBasicObject;
  i: Integer;
  viewObjList: Tlist;
  Bo: TBasicObject;
  otherUser: TUser;
  uname: string;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TBasicObject) then
    exit;
  aBasicObject := TBasicObject(uObject);
  viewObjList := aBasicObject.getViewObjectList;
  lua_newtable(L); //创建一个表格，放在栈顶
  i := 0;
  while i < viewObjList.Count do
  begin
    Bo := viewObjList[i];
    if Bo <> aBasicObject then
    begin
      if Bo is TUser then
      begin
        otherUser := TUser(Bo);
        uname := otherUser.BasicData.Name;
        //这里获取其他玩家的用户名
        lua_pushstring(L, pansichar(uname)); //压入key
        Lua_PushInteger(L, Integer(otherUser));
        lua_settable(L, -3);
      end;
    end;
    Inc(i);
  end;
  Result := 1;
end;
//获取玩家绑定钱币

function GetBindMoney(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Lua_PushInteger(L, Integer(user.HaveItemClass.Get_Bind_Money));
  Result := 1;
end;
//增加玩家绑定钱币

function AddBindMoney(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, acount: integer;
begin
  uObject := lua_tointeger(L, 1);
  acount := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.Add_Bind_Money(acount)));
  Result := 1;
end;
//减少玩家绑定钱币

function DelBindMoney(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, acount: integer;
begin
  uObject := lua_tointeger(L, 1);
  acount := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.DEL_Bind_Money(acount)));
  Result := 1;
end;

//设定任务信息

function SendQuestInfo(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, AQuestId, AGroup: integer;
  ATitle, ADes: string;
  ABComplete, ABFollow: Boolean;
begin
  uObject := lua_tointeger(L, 1);
  AQuestId := lua_tointeger(L, 2);
  AGroup := lua_tointeger(L, 3);
  ATitle := lua_tostring(L, 4);
  ADes := lua_tostring(L, 5);
  ABComplete := lua_toboolean(L, 6);
  ABFollow := lua_toboolean(L, 7);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.SendQuestInfo(AQuestId, AGroup, ATitle, ADes, ABComplete, ABFollow);
  Result := 1;
end;

//删除任务信息

function DelQuestInfo(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, AQuestId, AGroup: integer;
begin
  uObject := lua_tointeger(L, 1);
  AQuestId := lua_tointeger(L, 2);
  AGroup := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  USER.DelQuestInfo(AQuestId, AGroup);
  Result := 1;
end;

//更新任务信息

function UpdateQuestInfo(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, AQuestId, AGroup: integer;
  ATitle, ADes: string;
  ABComplete, ABFollow: Boolean;
begin
  uObject := lua_tointeger(L, 1);
  AQuestId := lua_tointeger(L, 2);
  AGroup := lua_tointeger(L, 3);
  ATitle := lua_tostring(L, 4);
  ADes := lua_tostring(L, 5);
  ABComplete := lua_toboolean(L, 6);
  ABFollow := lua_toboolean(L, 7);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.UpdateQuestInfo(AQuestId, AGroup, ATitle, ADes, ABComplete, ABFollow);
  Result := 1;
end;

function GetQuestTempArr(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aIndex: integer;
begin
  uObject := lua_tointeger(L, 1);
  aIndex := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if (aIndex < 0) or (aIndex > high(user.Connector.CharData.QuesttempArr)) then
    exit;
  Lua_PushInteger(L, user.Connector.CharData.QuesttempArr[aindex]);
  Result := 1;
end;

function SetQuestTempArr(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aIndex, aValue: integer;
begin
  uObject := lua_tointeger(L, 1);
  aIndex := lua_tointeger(L, 2);
  aValue := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if (aIndex < 0) or (aIndex > high(user.Connector.CharData.QuesttempArr)) then
    exit;
  user.Connector.CharData.QuesttempArr[aindex] := aValue;
  user.SendClass.SendQuestTempArr(aIndex);
  Result := 0;
end;
 //获取 临时变量值

function GetTempArr(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aIndex: integer;
begin
  uObject := lua_tointeger(L, 1);
  aIndex := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if (aIndex < 0) or (aIndex > 99) then
    exit;
  Lua_PushInteger(L, user.GetTempArr(aIndex));
  Result := 1;
end;
 //设置临时变量值

function SetTempArr(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aIndex, aValue: integer;
begin
  uObject := lua_tointeger(L, 1);
  aIndex := lua_tointeger(L, 2);
  aValue := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  if (aIndex < 0) or (aIndex > 99) then
    exit;
  user.SetTempArr(aindex, aValue);
  Result := 0;
end;
//获取天赋经验

function getnewTalentExp(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  Lua_PushInteger(L, user.getnewTalentExp);
  Result := 1;
end;

//写入天赋经验

function setnewTalentExp(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, Exp: integer;
begin
  uObject := lua_tointeger(L, 1);
  Exp := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  user.setnewTalentExp(Exp);
  Result := 0;
end;

//获取天赋等级

function getnewTalentLv(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  Lua_PushInteger(L, user.getnewTalentLv);
  Result := 1;
end;

//写入天赋等级

function setnewTalentLv(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, Lv: integer;
begin
  uObject := lua_tointeger(L, 1);
  Lv := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  user.setnewTalentLv(Lv);
  Result := 0;
end;

//获取天赋点

function getnewTalent(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  Lua_PushInteger(L, user.getnewTalent);
  Result := 1;
end;

//写入天赋点

function setnewTalent(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, newTalent: integer;
begin
  uObject := lua_tointeger(L, 1);
  newTalent := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  user.setnewTalent(newTalent);
  Result := 0;
end;
//获取天赋属性

function GetTalentAttrib(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Lua_PushInteger(L, user.getnewBone);
  Lua_PushInteger(L, user.getnewLeg);
  Lua_PushInteger(L, user.getnewSavvy);
  Lua_PushInteger(L, user.getnewAttackPower);
  Result := 4;
end;

//写入天赋属性

function SetTalentAttrib(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
  AnewBone, AnewLeg, AnewSavvy, AnewAttackPower: integer;
begin
  uObject := lua_tointeger(L, 1);
  AnewBone := lua_tointeger(L, 2); //根骨
  AnewLeg := lua_tointeger(L, 3); //身法
  AnewSavvy := lua_tointeger(L, 4); //悟性
  AnewAttackPower := lua_tointeger(L, 5); //武学

  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.setnewBone(AnewBone);
  user.setnewLeg(AnewLeg);
  user.setnewSavvy(AnewSavvy);
  user.setnewAttackPower(AnewAttackPower);
  Result := 0;
end;

//获取VIP信息

function GetVipInfo(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;

  user := TUser(uObject);
  Lua_PushInteger(L, user.AttribClass.VipUseLevel);
  Lua_Pushstring(L, PAnsiChar(_DateTimeToStr(user.AttribClass.VipUseTime)));
  Result := 2;
end;

//写入VIP信息

function SetVipInfo(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, VipLevel: integer;
  VipTime: string;
begin
  uObject := lua_tointeger(L, 1);
  VipLevel := lua_tointeger(L, 2); //VIP等级
  VipTime := lua_tostring(L, 3); //VIP时间

  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;

  user := TUser(uObject);
  user.AttribClass.VipUseLevel := VipLevel;
  user.AttribClass.VipUseTime := _StrToDateTime(VipTime);
  Result := 0;
end;

//增加武功翻倍经验

function AddMagicExpMul(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aMulCount, aSec: integer;
begin
  uObject := lua_tointeger(L, 1);
  aMulCount := lua_tointeger(L, 2); //倍数
  aSec := lua_tointeger(L, 3); //时间

  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.MagicExpMulScriptAdd(aMulCount, aSec)));
  Result := 1;
end;

//获取武功翻倍经验

function GetMagicExpMul(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Lua_PushInteger(L, user.MagicExpMulCountGet);
  Lua_PushInteger(L, user.MagicExpMulGetCurMulMinutes);
  Result := 2;
end;

//写入爆率作弊值
function SetCheatings(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aCheatings: integer;

begin
  uObject := lua_tointeger(L, 1);
  aCheatings := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.setCheatings(aCheatings);
  Result := 0;
end;

//获取爆率作弊值

function GetCheatings(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Lua_PushInteger(L, user.getCheatings);
  Result := 1;
end;

//写入强化祝福值
function SetableStatePoint(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, ableStatePoint: integer;

begin
  uObject := lua_tointeger(L, 1);
  ableStatePoint := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.SetableStatePoint(ableStatePoint);
  Result := 0;
end;

//获取强化祝福值

function GetableStatePoint(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Lua_PushInteger(L, user.GetableStatePoint);
  Result := 1;
end;

//获取元宝

function GetMysqlDianJuan(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  Lua_PushInteger(L, user.GET_GOLD_Money);
  Result := 1;
end;

//写入元宝

function SetMysqlDianJuan(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aNum: integer;
begin
  uObject := lua_tointeger(L, 1);
  aNum := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.SET_GOLD_Money(aNum)));
  Result := 1;
end;


//增加元宝

function AddMysqlDianJuan(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aNum: integer;
begin
  uObject := lua_tointeger(L, 1);
  aNum := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.Add_GOLD_Money(aNum)));
  Result := 1;
end;


//删除元宝

function DelMysqlDianJuan(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aNum: integer;
begin
  uObject := lua_tointeger(L, 1);
  aNum := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.Del_GOLD_Money(aNum)));
  Result := 1;
end;


//写入定时触发

function SetEventTick(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, akey, atime: integer;
begin
  uObject := lua_tointeger(L, 1);
  akey := lua_tointeger(L, 2);
  atime := lua_tointeger(L, 3);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.SetEventTick(akey, atime)));
  Result := 1;
end;

//获取定时触发

function GetEventTick(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, akey: integer;
begin
  uObject := lua_tointeger(L, 1);
  akey := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushinteger(L, user.GetEventTick(akey));
  Result := 1;
end;

//踢玩家下线

function BanPlay(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.boDeleteState := true;
  user.SendClass.SendCloseClient();
  Result := 0;
end;

//囚禁玩家

function PrisonPlay(L: TLuaState): Integer; cdecl;
var
  aName, aType, aReason: string;
begin
  aName := lua_tostring(L, 1);
  aType := lua_tostring(L, 2);
  aReason := lua_tostring(L, 2);
  //以上获取LUA参数
  lua_pushstring(L, PAnsiChar(PrisonClass.AddUser(aName, aType, aReason)));
  Result := 1;
end;

//囚禁玩家

function SendProcBlackList(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject: integer;
begin
  uObject := lua_tointeger(L, 1);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.SendProcBlackList;
  Result := 0;
end;


//对玩家电脑截屏 获取进程列表 或获取进程文件,并上传

function SendUpload(L: TLuaState): Integer; cdecl; //2015.12.24 在水一方
var
  USER: TUser;
  sname: string;
  uObject, aType, akey: integer;
begin
  uObject := lua_tointeger(L, 1);
  aType := lua_tointeger(L, 2);
  akey := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  USER := TUser(uObject);
  USER.SendClass.SendUpload(aType, akey);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//增加玩家年龄经验

function UpAgeExp(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aexp: integer;
begin
  uObject := lua_tointeger(L, 1);
  aexp := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  USER := TUser(uObject);
  USER.UpAgeExp(aexp);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//增加玩家浩然经验

function UpVirtueExp(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aexp: integer;
begin
  uObject := lua_tointeger(L, 1);
  aexp := lua_tointeger(L, 2);
  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  USER := TUser(uObject);
  USER.AttribClass.SETvirtue(aexp);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//修改角色名字

function ChangeCharName(L: TLuaState): Integer; cdecl; //2016.03.19 在水一方 脚本中应该做名字合法检测
var
  USER: TUser;
  uObject: integer;
  NewName: string;
begin
  uObject := lua_tointeger(L, 1);
  NewName := lua_tostring(L, 2);

  //以上获取LUA参数
  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  lua_pushboolean(L, LongBool(user.ChangeCharNameStart(NewName)));
  Result := 1;
end;

//检测角色名字

function CheckCharName(L: TLuaState): Integer; cdecl; //2016.03.19 在水一方 脚本中应该做名字合法检测
var
  ucharname, str: string;
  i: Integer;
begin
  ucharname := trim(lua_tostring(L, 1));
  //以上获取LUA参数
  str := '';
  if (ucharname = '') or (Pos(',', ucharname) > 0) then
  begin
    str := '无法使用角色名称';
  end;

  if str = '' then
    for i := 0 to RejectNameList.Count - 1 do
    begin
      if Pos(RejectNameList.Strings[i], ucharname) > 0 then
      begin
        str := '无法使用角色名称';
      end;
    end;


  if str = '' then
    if Length(ucharname) > 12 then
    begin
      str := '角色名称最多六个字';
    end;

  if str = '' then
    if (ucharname[1] >= '0') and (ucharname[1] <= '9') then
    begin
      str := '角色名称的第一个字无法使用数字';
    end;

  if str = '' then
    if (ucharname[Length(ucharname)] >= '0') and (ucharname[Length(ucharname)] <= '9') then
    begin
      str := '角色名称的最后一个字无法使用数字';
    end;

  if str = '' then
    if (not IsHZ(ucharname)) then //if (not isFullHangul(ucharname)) then // or (not isGrammarID(ucharname)) then
    begin
      str := 'ID无法使用特殊文字';
    end;

  lua_pushstring(L, PAnsiChar(str));
  Result := 1;
end;

//打开物品输入窗口

function ItemInputWindowsOpen(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aSubKey: integer;
  aCaption, aText: string;
  Push: Boolean;
begin
  uObject := lua_tointeger(L, 1);
  aSubKey := lua_tointeger(L, 2);
  aCaption := lua_tostring(L, 3);
  aText := lua_tostring(L, 4);
  //以上获取LUA参数
  Push := LongBool(False);

  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.HaveItemClass.ItemInputWindowsOpen(aSubKey, aCaption, aText);

  Push := LongBool(TRUE);
  lua_pushboolean(L, Push);
  Result := 1;
end;

//设定物品输入窗口

function setItemInputWindowsKey(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aSubKey, akey: integer;
  Push: Boolean;
begin
  uObject := lua_tointeger(L, 1);
  aSubKey := lua_tointeger(L, 2);
  akey := lua_tointeger(L, 3);
  //以上获取LUA参数
  Push := LongBool(False);

  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  Push := LongBool(user.HaveItemClass.setItemInputWindowsKey(aSubKey, akey));
  lua_pushboolean(L, Push);
  Result := 1;
end;

//获取物品输入窗口

function getItemInputWindowsKey(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, aSubKey: integer;
  Push: Boolean;
begin
  uObject := lua_tointeger(L, 1);
  aSubKey := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(False);

  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);

  Push := LongBool(user.HaveItemClass.GetItemInputWindowsKey(aSubKey));
  lua_pushboolean(L, Push);
  Result := 1;
end;

//打开消息输入窗口

function MsgConfirmDialog(L: TLuaState): Integer; cdecl;
var
  USER: TUser;
  uObject, oObject, did: integer;
  aCaption: string;
begin
  uObject := lua_tointeger(L, 1);
  oObject := lua_tointeger(L, 2);
  did := lua_tointeger(L, 3);
  aCaption := lua_tostring(L, 4);
  //以上获取LUA参数

  if not (TObject(uObject) is TUser) then
    exit;
  user := TUser(uObject);
  user.ShowConfirmDialog(oObject, did, aCaption);

  Result := 0;
end;


function MapAddMonster(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  ax, ay, acount, awidth: integer;
  amember: string;
  anation, amappathid: integer;
  aboDieDelete: boolean;
  adelay: Integer;
  ttTManager: TManager;
  i: integer;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  ax := lua_tointeger(L, 3);
  ay := lua_tointeger(L, 4);
  acount := lua_tointeger(L, 5);
  awidth := lua_tointeger(L, 6);
  amember := lua_tostring(L, 7);
  anation := lua_tointeger(L, 8);
  amappathid := lua_tointeger(L, 9);
  aboDieDelete := lua_toboolean(L, 10);
  adelay := lua_tointeger(L, 11);

  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  for i := 0 to acount - 1 do
  begin
    TMonsterList(ttTManager.MonsterList).AddMonster2(aname, ax, ay, awidth, amember, anation, amappathid, aboDieDelete, adelay);
  end;
  Result := 0;
end;
//指定地图ID删除怪物

function MapDelMonster(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  Push: LongBool;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  Push := LongBool(TMonsterList(ttTManager.MonsterList).DeleteMonster(aname));
  lua_pushboolean(L, Push);
  Result := 1;
end;

//指定地图ID查找怪物

function MapFindMonster(L: TLuaState): Integer; cdecl;
var
  amapid, atype: Integer;
  aname: string;
  Push: Integer;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  atype := lua_tointeger(L, 3);
  //以上获取LUA参数
  Push := 0;
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  if atype = 1 then
  begin
    Push := TMonsterList(ttTManager.MonsterList).getDieCount(aname);
  end
  else if atype = 2 then
  begin
    Push := TMonsterList(ttTManager.MonsterList).getliveCount(aname);
  end
  else if atype = 0 then
  begin
    if aname = '' then
      Push := TMonsterList(ttTManager.MonsterList).Count
    else
      Push := TMonsterList(ttTManager.MonsterList).FindMonster(aname);
  end;

  Lua_PushInteger(L, Push);
  Result := 1;
end;

//指定地图ID添加NPC

function MapAddNPC(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  ax, ay, acount, awidth: integer;
  aBookName: string;
  anation, amappathid: integer;
  adelay: Integer;
  ttTManager: TManager;
  i: integer;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  ax := lua_tointeger(L, 3);
  ay := lua_tointeger(L, 4);
  acount := lua_tointeger(L, 5);
  awidth := lua_tointeger(L, 6);
  aBookName := lua_tostring(L, 7);
  anation := lua_tointeger(L, 8);
  amappathid := lua_tointeger(L, 9);
  adelay := lua_tointeger(L, 10);

  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  for i := 0 to acount - 1 do
  begin
    TNpcList(ttTManager.NpcList).AddNpc2(aname, ax, ay, awidth, aBookName, anation, amappathid, adelay);
  end;
  Result := 0;
end;
//指定地图ID删除NPC

function MapDelNPC(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  Push: LongBool;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;

  Push := LongBool(TNpcList(ttTManager.NpcList).DelNpc(aname));
  lua_pushboolean(L, Push);
  Result := 1;
end;
//指定地图ID查找NPC

function MapFindNPC(L: TLuaState): Integer; cdecl;
var
  amapid, atype: Integer;
  aname: string;
  Push: Integer;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  atype := lua_tointeger(L, 3);
  //以上获取LUA参数
  Push := 0;
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  if atype = 1 then
  begin
    Push := TNpcList(ttTManager.NpcList).getDieCount(aname);
  end
  else if atype = 2 then
  begin
    Push := TNpcList(ttTManager.NpcList).getliveCount(aname);
  end
  else if atype = 0 then
  begin
    if aname = '' then
      Push := TNpcList(ttTManager.NpcList).Count
    else
      Push := TNpcList(ttTManager.NpcList).FindNpc(aname);
  end;

  Lua_PushInteger(L, Push);
  Result := 1;
end;

//指定地图ID添加Dynamicobject

function MapAddDynamicobject(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aObjectName, aNeedSkill, aNeedItem, aGiveItem, aDropItem, aDropMop, aCallNpc, axs, ays: string;
  aNeedAge, aDropX, aDropy, adelay: Integer;
  ttTManager: TManager;
  Push: LongBool;
  pd: TCreateDynamicObjectData;
begin
  amapid := lua_tointeger(L, 1);
  aObjectName := lua_tostring(L, 2);
  aNeedSkill := lua_tostring(L, 3);
  aNeedItem := lua_tostring(L, 4);
  aGiveItem := lua_tostring(L, 5);
  aDropItem := lua_tostring(L, 6);
  aDropMop := lua_tostring(L, 7);
  aCallNpc := lua_tostring(L, 8);
  axs := lua_tostring(L, 9);
  ays := lua_tostring(L, 10);
  aNeedAge := lua_tointeger(L, 11);
  aDropX := lua_tointeger(L, 12);
  aDropy := lua_tointeger(L, 13);
  adelay := lua_tointeger(L, 14);

  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;

  Push := LongBool(False);

  fillchar(pd, sizeof(pd), 0);
  if DynamicObjectClass.GetDynamicObjectData(aObjectName, pd.rBasicData) = false then
    exit;
  try
    LoadDynamicObject(aObjectName, aNeedSkill, aNeedItem, aGiveItem, aDropItem, aDropMop, aCallNpc, axs, ays, @pd);
  except
    exit;
  end;
  pd.rNeedAge := aNeedAge;
  pd.rDropX := aDropX;
  pd.rDropX := aDropy;
  Push := LongBool(TDynamicObjectList(ttTManager.DynamicObjectList).AddDynamicObject2(@pd, adelay));
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;
//指定地图ID删除Dynamicobject

function MapDelDynamicobject(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  Push: LongBool;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;

  Push := LongBool(TDynamicObjectList(ttTManager.DynamicObjectList).DeleteDynamicObject_b(aname));
  lua_pushboolean(L, Push);
  Result := 1;
end;
//指定地图ID查找Dynamicobject

function MapFindDynamicobject(L: TLuaState): Integer; cdecl;
var
  amapid, astate: Integer;
  aname: string;
  Push: Integer;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  astate := lua_tointeger(L, 3);
  //以上获取LUA参数
  Push := 0;
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;

  if astate = 1 then
    Push := TDynamicObjectList(ttTManager.DynamicObjectList).getTypeCount(aname, dos_Closed)
  else if astate = 2 then
    Push := TDynamicObjectList(ttTManager.DynamicObjectList).getTypeCount(aname, dos_Openning)
  else if astate = 3 then
    Push := TDynamicObjectList(ttTManager.DynamicObjectList).getTypeCount(aname, dos_Openned)
  else if astate = 0 then
  begin
    if aname = '' then
      Push := TDynamicObjectList(ttTManager.DynamicObjectList).Count
    else
      Push := TDynamicObjectList(ttTManager.DynamicObjectList).FindDynamicObject(aname);
  end;

  Lua_PushInteger(L, Push);
  Result := 1;
end;
//指定地图ID改变Dynamicobject状态

function MapChangeDynamicobject(L: TLuaState): Integer; cdecl;
var
  amapid, astate: Integer;
  aname: string;
  Push: LongBool;
  ttTManager: TManager;
  aObjectStatus: TDynamicObjectState;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  astate := lua_tointeger(L, 3);
  //以上获取LUA参数
  Push := LongBool(false);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;

  if astate = 1 then
    aObjectStatus := dos_Closed
  else if astate = 2 then
    aObjectStatus := dos_Openning
  else if astate = 3 then
    aObjectStatus := dos_Openned
  else if astate = 0 then
    aObjectStatus := dos_Scroll
  else
    exit;

  TDynamicObjectList(ttTManager.DynamicObjectList).ChangeObjectStatus(aname, aObjectStatus);
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  Result := 1;
end;

//指定地图刷新动态物品

function MapRegenDynamicObject(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  Push: LongBool;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  TDynamicObjectList(ttTManager.DynamicObjectList).RegenDynamicObject(aname);
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  Result := 1;
end;

//获取指定地图玩家数量

function MapUserCount(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager <> nil then Lua_PushInteger(L, UserList.MapUserCount(ttTManager.ServerID))
  else Lua_PushInteger(L, -1);
  Result := 1;
end;


//指定地图刷新怪物

function MapRegenMonster(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  Push: LongBool;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  TMonsterList(ttTManager.MonsterList).RegenMonster(aname);
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  Result := 1;
end;   
//指定地图刷新NPC
function MapRegenNPC(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  aname: string;
  Push: LongBool;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  TNpcList(ttTManager.NpcList).RegenNPC(aname);
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  Result := 1;
end;
//获取指定地图ID名称

function GetMapName(L: TLuaState): Integer; cdecl;
var
  amapid: Integer;
  ttTManager: TManager;
begin
  amapid := lua_tointeger(L, 1);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;

  lua_pushstring(L, PAnsiChar(ttTManager.Title));
  Result := 1;
end;

function getMySqlDataSet(L: TLuaState): Integer; cdecl;
begin
  Result := G_TDataSetWrapper.getMySqlDataSetForLua(L);
end;

function DoMySql(L: TLuaState): Integer; cdecl;
var
  sql: string;
begin
  sql := lua_tostring(L, 1);
  //以上获取LUA参数
  Lua_PushInteger(L, G_TDataSetWrapper.doSQL(sql));
  Result := 1;
end;

//指定地图ID发送消息

function MapObjSay(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid: integer;
  atext: string;
  acolor: integer;
begin
  amapid := lua_tointeger(L, 1);
  atext := lua_tostring(L, 2);
  acolor := lua_tointeger(L, 3);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  UserList.SendChatMessage_ServerID(ttTManager.ServerID, atext, acolor);
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//根据地图ID添加个新地图

function GetNewMap(L: TLuaState): Integer; cdecl;
var
  amapid, anewid: integer;
  atitle: string;
begin
  amapid := lua_tointeger(L, 1);
  anewid := lua_tointeger(L, 2);
  atitle := lua_tostring(L, 3);
  //以上获取LUA参数
  //返回
  lua_pushboolean(L, LongBool(ManagerList.GetNewMap(amapid, anewid, atitle)));
  //下边这行必加 中间保持原对应方法内容
  Result := 1;
end;

//设定门派石是否允许攻击

function ScriptOpenGuildWar(L: TLuaState): Integer; cdecl;
var
  kill: Boolean;
begin
  kill := lua_toboolean(L, 1);
  //以上获取LUA参数
  GuildList.setKillstate(kill);
  Result := 0;
end;

//指定地图ID发送自定义颜色消息

function MapObjSayByCol(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid: integer;
  atext: string;
  afcolor, abcolor: integer;
begin
  amapid := lua_tointeger(L, 1);
  atext := lua_tostring(L, 2);
  afcolor := lua_tointeger(L, 3);
  abcolor := lua_tointeger(L, 4);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  UserList.SendChatMessageByCol_ServerID(ttTManager.ServerID, atext, ColorSysToDxColor(afcolor), ColorSysToDxColor(abcolor));
  //下边这行必加 中间保持原对应方法内容
  Result := 0;
end;

//刷新指定ID地图

function MapRegen(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid: integer;
  Push: LongBool;
begin
  amapid := lua_tointeger(L, 1);
  //以上获取LUA参数
  Push := LongBool(False);
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  ttTManager.Regen;
  Push := LongBool(true);
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;

//指定ID地图查找目标

function MapFindName(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid, aRace, FindID: integer;
  aname: string;
  Bo: TBasicObject;
  Monster: TMonster;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  aRace := lua_tointeger(L, 3);
  //以上获取LUA参数
  FindID := 0;
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;

  if aRace = 1 then
  begin
    Bo := UserList.GetUserPointer(aname);
    if (Bo <> nil) and (Bo.ServerID = amapid) then
    begin
      FindID := Integer(Bo);
    end;
  end
  else if aRace = 3 then
  begin
    Monster := TMonsterList(ttTManager.MonsterList).GetMonsterByName(aname);
    if Monster <> nil then
    begin
      FindID := Integer(Monster);
    end;
  end
  else if aRace = 4 then
  begin
    Bo := TNpcList(ttTManager.NpcList).GetNpcByName(aname);
    if Bo <> nil then
    begin
      FindID := Integer(Bo);
    end;
  end
  else if aRace = 6 then
  begin
    Bo := TDynamicObjectList(ttTManager.DynamicObjectList).GetDynamicByName(aname);
    if Bo <> nil then
    begin
      FindID := Integer(Bo);
    end;
  end

  else
    exit;
  //返回
  Lua_PushInteger(L, FindID);
  Result := 1;
end;

//指定ID地图玩家全部传送

function MapMoveByServerID(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid, tomapid, tomapx, tomapy, totime: integer;
begin
  amapid := lua_tointeger(L, 1);
  tomapid := lua_tointeger(L, 2);
  tomapx := lua_tointeger(L, 3);
  tomapy := lua_tointeger(L, 4);
  totime := lua_tointeger(L, 5);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  UserList.MoveByServerID(amapid, tomapid, tomapx, tomapy, totime);
  //返回
  Result := 0;
end;

//冻结地图全部怪物

function MapIceMonster(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid: integer;
  aname: string;
  astate: Boolean;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  astate := lua_toboolean(L, 3);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  TMonsterList(ttTManager.MonsterList).iceMonster(aname, astate);
  //返回
  Result := 0;
end;

//地图全部怪物允许攻击

function MapboNotHItMonster(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid: integer;
  aname: string;
  astate: Boolean;
begin
  amapid := lua_tointeger(L, 1);
  aname := lua_tostring(L, 2);
  astate := lua_toboolean(L, 3);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  TMonsterList(ttTManager.MonsterList).boNotHitMonster(aname, astate);
  //返回
  Result := 0;
end;

//获取地图剩余时间

function GetMapRemainTickById(L: TLuaState): Integer; cdecl;
var
  ttTManager: TManager;
  amapid, n: integer;
begin
  amapid := lua_tointeger(L, 1);
  //以上获取LUA参数
  ttTManager := ManagerList.GetManagerByServerID(amapid);
  if ttTManager = nil then
    exit;
  //返回
  Lua_PushInteger(L, ttTManager.RemainTickById);
  Result := 1;
end;

//判断2个坐标之间距离

function GetLargeLengthlua(L: TLuaState): Integer; cdecl;
var
  ax, ay, bx, by: integer;
begin
  ax := lua_tointeger(L, 1);
  ay := lua_tointeger(L, 2);
  bx := lua_tointeger(L, 3);
  by := lua_tointeger(L, 4);
  //以上获取LUA参数
  //返回
  Lua_PushInteger(L, GetLargeLength(ax, ay, bx, by));
  Result := 1;
end;

//设置门派石最大血量

function SetGuildDurabilityMax(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  Durability: integer;
  GuildObject: TGuildObject;
  Push: LongBool;
begin
  GuildName := lua_tostring(L, 1);
  Durability := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(False);
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject <> nil then
  begin
    Tguildobject(GuildObject).setlifeMax(Durability);
    Push := LongBool(true);
  end;
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;

//获取门派石最大血量

function GetGuildDurabilityMax(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  Lua_PushInteger(L, Tguildobject(GuildObject).getLifeMax);
  Result := 1;
end;

//设置门派石当前血量

function SetGuildDurability(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  Durability: integer;
  GuildObject: TGuildObject;
  Push: LongBool;
begin
  GuildName := lua_tostring(L, 1);
  Durability := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(False);
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject <> nil then
  begin
    Tguildobject(GuildObject).setLife(Durability);
    Push := LongBool(true);
  end;
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;

//获取门派石当前血量

function GetGuildDurability(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  Lua_PushInteger(L, Tguildobject(GuildObject).getLife);
  Result := 1;
end;

//获取门派石当前等级

function GetGuildLevel(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  Lua_PushInteger(L, Tguildobject(GuildObject).level);
  Result := 1;
end;

//设定门派石当前等级

function SetGuildLevel(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  Level: integer;
  GuildObject: TGuildObject;
  Push: LongBool;
begin
  GuildName := lua_tostring(L, 1);
  Level := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(False);
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject <> nil then
  begin
    Tguildobject(GuildObject).level := Level;
    Push := LongBool(true);
  end;
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;

//获取门派石元气

function GetGuildEnegy(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  Lua_PushInteger(L, Tguildobject(GuildObject).Enegy);
  Result := 1;
end;

//设定门派石元气

function SetGuildEnegy(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  Enegy: integer;
  GuildObject: TGuildObject;
  Push: LongBool;
begin
  GuildName := lua_tostring(L, 1);
  Enegy := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(False);
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject <> nil then
  begin
    Tguildobject(GuildObject).Enegy := Enegy;
    Push := LongBool(true);
  end;
  //返回
  lua_pushboolean(L, Push);
  Result := 1;
end;

//获取门派石等级升级经验

function GetGuildUpEnegy(L: TLuaState): Integer; cdecl;
var
  level, MaxEnegy: integer;
  GuildObject: TGuildObject;
begin
  level := lua_tointeger(L, 1);
  //以上获取LUA参数
  MaxEnegy := GuildList.getMaxEnegy(level);
  //返回
  Lua_PushInteger(L, MaxEnegy);
  Result := 1;
end;

//获取门派石门派团队

function GetGuildTeam(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  Lua_PushInteger(L, Tguildobject(GuildObject).GuildTeam);
  Result := 1;
end;

//获取门派石门派团队

function SetGuildTeam(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
  aTeam: Integer;
begin
  GuildName := lua_tostring(L, 1);
  aTeam := lua_tointeger(L, 2);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  Tguildobject(GuildObject).GuildTeam := aTeam;
  Result := 0;
end;


//添加门派成员     ,对象必须在线

function AddGuildUser(L: TLuaState): Integer; cdecl;
var
  GuildName, aNewName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  aNewName := lua_tostring(L, 2);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  GuildObject.AddUserScript(aNewName);
  Result := 0;
end;

//获取门派门武

function GetGuildMagic(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  lua_pushstring(L, PAnsiChar(GuildObject.GetGuildMagicString));
  Result := 1;
end;

//删除门派门武

function DelGuildMagic(L: TLuaState): Integer; cdecl;
var
  GuildName: string;
  GuildObject: TGuildObject;
begin
  GuildName := lua_tostring(L, 1);
  //以上获取LUA参数
  GuildObject := GuildList.GetGuildObject(GuildName);
  if GuildObject = nil then
    Exit;
  //返回
  GuildObject.DelGuildMagicString;
  Result := 0;
end;

//强制删除玩家

function FinalLayerCharName(L: TLuaState): Integer; cdecl;
var
  CharName: string;
begin
  CharName := lua_tostring(L, 1);
  //以上获取LUA参数
  UserList.FinalLayerCharName(CharName);
  //返回
  Result := 0;
end;

//返回对应字段的值   local aStr = M_GetSdbInfo('.\\Tgsplus\\test.sdb', '测试帐号', '称号');

function GetSdbInfo(L: TLuaState): Integer; cdecl;
var
  aFileName, aIndex, aName: string;
  aStr: string;
  TempDb: TUserStringDb;
  i: Integer;
begin
  aFileName := lua_tostring(L, 1);
  aName := lua_tostring(L, 2);
  aIndex := lua_tostring(L, 3);
  //以上获取LUA参数
  aStr := '';
  if FileExists(aFileName) then
  begin
    TempDb := TUserStringDb.Create;
    try
      TempDb.LoadFromFile(aFileName);
      aStr := TempDb.GetFieldValueString(aName, aIndex);
    finally
      TempDb.Free;
    end;
  end;
  //返回
  Lua_PushString(L, PAnsiChar(aStr));
  Result := 1;
end;

//设定对应字段的值   SetSdbInfo('NewScript\\1.sdb', '测试帐号', '称号', '我的称号');

function SetSdbInfo(L: TLuaState): Integer; cdecl;
var
  aFileName, aIndex, aName, aValue: string;
  TempDb: TUserStringDb;
  i: Integer;
begin
  aFileName := lua_tostring(L, 1);
  aName := lua_tostring(L, 2);
  aIndex := lua_tostring(L, 3);
  aValue := lua_tostring(L, 4);
  //以上获取LUA参数
  if FileExists(aFileName) then
  begin
    TempDb := TUserStringDb.Create;
    try
      TempDb.LoadFromFile(aFileName);
      //查询
      if TempDb.GetNameIndex(aName) = -1 then
        TempDb.AddName(aName);
      TempDb.SetFieldValueString(aName, aIndex, aValue);
      TempDb.SaveToFile(aFileName);
    finally
      TempDb.Free;
    end;
  end;
  //返回
  Result := 0;
end;

//删除对应SDB索引   DelSdbInfo('NewScript\\1.sdb', '测试帐号');

function DelSdbInfo(L: TLuaState): Integer; cdecl;
var
  aFileName, aName: string;
  TempDb: TUserStringDb;
  i: Integer;
begin
  aFileName := lua_tostring(L, 1);
  aName := lua_tostring(L, 2);
  //以上获取LUA参数
  if FileExists(aFileName) then
  begin
    TempDb := TUserStringDb.Create;
    try
      TempDb.LoadFromFile(aFileName);
      TempDb.DeleteName(aName);
      TempDb.SaveToFile(aFileName);
    finally
      TempDb.Free;
    end;
  end;
  //返回
  Result := 0;
end;

//检测门派团派是否在使用

function CheckGuildTeam(L: TLuaState): Integer; cdecl;
var
  aTeam: Integer;
begin
  aTeam := lua_tointeger(L, 1);
  //以上获取LUA参数
  lua_pushboolean(L, LongBool(GuildList.CheckGuildTeam(aTeam)));

  Result := 1;
end;

//获取境界等级对应境界名称

function GetPowerLevelName(L: TLuaState): Integer; cdecl;
var
  PowerLevel: integer;
  pp: string;
begin
  PowerLevel := lua_tointeger(L, 1);
  //以上获取LUA参数
  //返回
  Lua_PushString(L, PAnsiChar(PowerLevelClass.getname(PowerLevel)));
  Result := 1;
end;


//伤害指定玩家
function ReturnDamage(L: TLuaState): Integer; cdecl;
var        
  USER: TUser;
  uObject, uKillObject, aHit: integer;
  aBasicObject: TBasicObject;
  Push: LongBool;    
  aSubData: tSubData;
begin
  uObject := lua_tointeger(L, 1);
  aHit := lua_tointeger(L, 2);
  //以上获取LUA参数
  Push := LongBool(false);
  if aHit <= 0 then
    exit;
  if not (TObject(uObject) is TUser) then
    exit;                           
  user := TUser(uObject);

  fillchar(aSubData, sizeof(aSubData), 0);
  aSubData.HitData.damageBody := aHit;
  aSubData.HitData.ToHit := 65535;
  aSubData.HitData.HitLevel := 7500;
  aSubData.HitData.HitTargetsType := _htt_All;
  aSubData.HitData.boHited := FALSE;
  aSubData.HitData.HitFunction := 0;
  aSubData.HitData.HitFunctionSkill := 0;
  user.SendLocalMessage(user.BasicData.id, FM_DIREHIT, user.BasicData, aSubData);
  Push := LongBool(true);
  lua_pushboolean(L, Push);
  //返回
  Result := 1;
end;

procedure Lua_GroupScripteRegister(L: lua_state);
begin
  Lua_Register(L, 'P_MenuSay', MenuSay); //NPC说话
  Lua_Register(L, 'P_MenuSayItem', MenuSayItem); //ITEM弹出对话框
  Lua_Register(L, 'P_topyoumsg', topyoumsg); //指定对象发顶部消息框
  Lua_Register(L, 'P_saysystem', saysystem); //指定对象发系统类型消息
  Lua_Register(L, 'P_sayByCol', sayByCol); //指定对象发自定义颜色消息
  Lua_Register(L, 'P_getitemcount', getitemcount); //获取物品数量
  Lua_Register(L, 'P_deleteitem', deleteitem); //获取物品数量
  Lua_Register(L, 'P_additem', additem); //增加背包物品数量
  Lua_Register(L, 'P_getname', getname); //获取玩家名称
  Lua_Register(L, 'P_GetMasterName', GetMasterName); //获取玩家帐号
  Lua_Register(L, 'P_GetHcode', GetHcode); //获取玩家机器码
  Lua_Register(L, 'P_GetOutIpAddr', GetOutIpAddr); //获取玩家外网IP
  Lua_Register(L, 'P_getsex', getsex); //获取玩家性别
  Lua_Register(L, 'P_Getfeaturestate', Getfeaturestate); //获取玩家状态
  Lua_Register(L, 'P_GetEnergyLevel', GetEnergyLevel); //获取玩家境界等级
  Lua_Register(L, 'P_GetAccount', GetAccount); //获取玩家账号
  Lua_Register(L, 'P_getitemspace', getitemspace); //获取获取背包 空位数量。
  Lua_Register(L, 'P_GuildGetName', GuildGetName); //获取玩家门派
  Lua_Register(L, 'P_GetGuildPoint', GetGuildPoint); //获取玩家门派贡献
  Lua_Register(L, 'P_SetGuildPoint', SetGuildPoint); //写入玩家门派贡献

  Lua_Register(L, 'P_BoFreedom', BoFreedom); //获取玩家是否打开窗口
  Lua_Register(L, 'P_GetItemPassWord', GetItemPassWord); //获取玩家物品栏密码
  Lua_Register(L, 'P_GetItemPassBo', GetItemPassBo); //获取玩家物品栏密码锁状态
  Lua_Register(L, 'P_GetCurUseMagic', GetCurUseMagic); //获取玩家当前使用武功
  Lua_Register(L, 'P_GetSysopScope', GetSysopScope); //获取玩家权限值
  //Lua_Register(L, 'P_ShowEffect', ShowEffect); //显示特效
  Lua_Register(L, 'P_MapMove', MapMove); //移动指定目标到指定位置
  Lua_Register(L, 'P_NotMoveUser', NotMoveUser); //根据玩家名字 一定时间内限制玩家移动
  Lua_Register(L, 'P_SetMagicLevel', SetMagicLevel); //改变玩家武功等级
  Lua_Register(L, 'P_GetMagicLevel', GetMagicLevel); //获取玩家武功等级
  Lua_Register(L, 'P_AddMagicAndLevel', AddMagicAndLevel); //给玩家添加某等级的武功
  Lua_Register(L, 'P_LeftText', LeftText); //发玩家左侧消息
  Lua_Register(L, 'P_GetMenuCommand', GetMenuCommand); //发玩家左侧消息
  Lua_Register(L, 'P_GetHaveItemInfoTabs', GetHaveItemInfoTabs); //获取背包栏物品table
  Lua_Register(L, 'P_GetWearItemInfoTabs', GetWearItemInfoTabs); //获取装备栏物品table
  Lua_Register(L, 'P_AddItemTabsToHave', AddItemTabsToHave); //添加物品到物品栏
  Lua_Register(L, 'P_AddItemTabsToWear', AddItemTabsToWear); //添加物品到装备栏
  Lua_Register(L, 'P_DelHaveItemInfo', DelHaveItemInfo); //删除物品栏指定位置物品
  Lua_Register(L, 'P_DelWearItemInfo', DelWearItemInfo); //删除装备栏指定装备
 // Lua_Register(G_TgsLuaLib.LuaInstance, 'P_MsgBoxTempOpen', MsgBoxTempOpen); //打开临时消息窗口
  Lua_Register(L, 'P_getAQData', getAQData); //返回玩家 任务特殊属性
  Lua_Register(L, 'P_getLifeData', getLifeData); //返回玩家攻击防御等属性
  Lua_Register(L, 'P_GetAttrib', GetAttrib); //获取玩家基本属性
  Lua_Register(L, 'P_SetAddLifeData', SetAddLifeData); //设定玩家附加属性
  Lua_Register(L, 'P_SetAddBuff', SetAddBuff);         //设定玩家怪物Buff
  Lua_Register(L, 'P_SetAddMulBuff', SetAddMulBuff);   //设定玩家怪物倍增Buff
  Lua_Register(L, 'P_GetAddBuff', GetAddBuff);         //获取玩家怪物Buff
  Lua_Register(L, 'P_GetAddMulBuff', GetAddMulBuff);   //获取玩家怪物倍增Buff
  Lua_Register(L, 'P_SetMonsterMagic', SetMonsterMagic);               
  Lua_Register(L, 'P_SetMonsterHaveMagic', SetMonsterHaveMagic);

  Lua_Register(L, 'P_FindViewUserObjectList', FindViewUserObjectList); //获取对象周边玩家
  Lua_Register(L, 'P_GetBindMoney', GetBindMoney); //获取玩家绑定钱币
  Lua_Register(L, 'P_AddBindMoney', AddBindMoney); //增加玩家绑定钱币
  Lua_Register(L, 'P_DelBindMoney', DelBindMoney); //减少玩家绑定钱币
  Lua_Register(L, 'P_SendQuestInfo', SendQuestInfo); //设定任务信息
  Lua_Register(L, 'P_DelQuestInfo', DelQuestInfo); //删除任务信息
  Lua_Register(L, 'P_UpdateQuestInfo', UpdateQuestInfo); //更新任务信息
  Lua_Register(L, 'P_GetQuestTempArr', GetQuestTempArr); //返回任务临时变量值
  Lua_Register(L, 'P_SetQuestTempArr', SetQuestTempArr); //设置任务临时变量值
  Lua_Register(L, 'P_GetTempArr', GetTempArr); //返回临时变量值
  Lua_Register(L, 'P_SetTempArr', SetTempArr); //设置临时变量值

  Lua_Register(L, 'P_GetnewTalentExp', getnewTalentExp); //获得天赋经验
  Lua_Register(L, 'P_SetnewTalentExp', setnewTalentExp); //修改天赋经验
  Lua_Register(L, 'P_GetnewTalentLv', getnewTalentLv); //获得天赋等级
  Lua_Register(L, 'P_SetnewTalentLv', setnewTalentLv); //修改天赋等级
  Lua_Register(L, 'P_GetnewTalent', getnewTalent); //获得天赋点
  Lua_Register(L, 'P_SetnewTalent', setnewTalent); //修改天赋点
  Lua_Register(L, 'P_GetTalentAttrib', GetTalentAttrib); //获取天赋属性
  Lua_Register(L, 'P_SetTalentAttrib', SetTalentAttrib); //写入天赋属性
  Lua_Register(L, 'P_GetVipInfo', GetVipInfo); //获取VIP信息
  Lua_Register(L, 'P_SetVipInfo', SetVipInfo); //写入VIP信息
  Lua_Register(L, 'P_AddMagicExpMul', AddMagicExpMul); //增加武功翻倍经验
  Lua_Register(L, 'P_GetMagicExpMul', GetMagicExpMul); //获取武功翻倍经验剩余分钟
  Lua_Register(L, 'P_SetCheatings', SetCheatings); //写入爆率作弊值
  Lua_Register(L, 'P_GetCheatings', GetCheatings); //获取爆率作弊值
  Lua_Register(L, 'P_ItemInputWindowsOpen', ItemInputWindowsOpen); //打开物品输入窗口
  Lua_Register(L, 'P_setItemInputWindowsKey', setItemInputWindowsKey); //设置物品输入窗口
  Lua_Register(L, 'P_getItemInputWindowsKey', getItemInputWindowsKey); //获取物品输入窗口。
  Lua_Register(L, 'P_MsgConfirmDialog', MsgConfirmDialog); //打开消息输入窗口。

  Lua_Register(L, 'P_GetMysqlDianJuan', GetMysqlDianJuan); //获取玩家元宝
  Lua_Register(L, 'P_SetMysqlDianJuan', SetMysqlDianJuan); //写入玩家元宝
  Lua_Register(L, 'P_AddMysqlDianJuan', AddMysqlDianJuan); // 增加玩家元宝
  Lua_Register(L, 'P_DelMysqlDianJuan', DelMysqlDianJuan); // 删除玩家元宝
  Lua_Register(L, 'P_SendUpload', SendUpload); //对玩家电脑截屏 获取进程列表 或获取进程文件,并上传
  Lua_Register(L, 'P_UpAgeExp', UpAgeExp); //增加玩家年龄经验
  Lua_Register(L, 'P_UpVirtueExp', UpVirtueExp); //增加玩家浩然经验
  Lua_Register(L, 'P_ChangeCharName', ChangeCharName); //修改角色名字
  Lua_Register(L, 'P_CheckCharName', CheckCharName); //检测角色名字合法性
  Lua_Register(L, 'P_SetEventTick', SetEventTick); // 写入玩家定时触发
  Lua_Register(L, 'P_GetEventTick', GetEventTick); //获取玩家定时触发
  Lua_Register(L, 'P_BanPlay', BanPlay); //踢玩家下线
  Lua_Register(L, 'P_PrisonPlay', PrisonPlay); //囚禁玩家
  Lua_Register(L, 'P_SendProcBlackList', SendProcBlackList); //囚禁玩家 
  Lua_Register(L, 'P_SetableStatePoint', SetableStatePoint); //写入强化祝福点
  Lua_Register(L, 'P_GetableStatePoint', GetableStatePoint); //获取强化祝福点
  Lua_Register(L, 'P_ReturnDamage', ReturnDamage); //攻击指定目标

//M(无对象语句)
  Lua_Register(L, 'M_centermsg', centermsg); //中间消息框
  Lua_Register(L, 'M_CenterMagicMSG', CenterMagicMSG); //中间变色消息
  Lua_Register(L, 'M_worldnoticemsg', worldnoticemsg); //发送聊天框自定义颜色消息
  Lua_Register(L, 'M_worldnoticemsgitem', worldnoticemsgitem); //发送聊天框自定义颜色消息 + 物品
  Lua_Register(L, 'M_worldnoticesysmsg', worldnoticesysmsg); //发送聊天框系统颜色消息
  Lua_Register(L, 'M_topmsg', topmsg); //顶部消息框
  Lua_Register(L, 'M_leftmsg', leftmsg); //左侧消息框
  Lua_Register(L, 'M_leftmsgitem', leftmsgitem); //左侧消息框
  Lua_Register(L, 'M_GuildSay', GuildSay); //发送门派系统颜色消息
  Lua_Register(L, 'M_GuildSayByCol', GuildSayByCol); //发送门派自定义颜色消息
  Lua_Register(L, 'M_GetUserIsPointer', GetUserIsPointer); //获取玩家是否在线
  Lua_Register(L, 'M_GetAllOnlineUser', GetAllOnlineUser); //获取在线玩家
  Lua_Register(L, 'M_IsGuildSysOp', IsGuildSysOp); //获取某玩家门派职位
  Lua_Register(L, 'M_MapAddMonster', MapAddMonster); //指定地图添加怪物
  Lua_Register(L, 'M_MapDelMonster', MapDelMonster); //指定地图删除怪物
  Lua_Register(L, 'M_MapFindMonster', MapFindMonster); //指定地图查找怪物
  Lua_Register(L, 'M_MapAddNPC', MapAddNPC); //指定地图添加NPC
  Lua_Register(L, 'M_MapDelNPC', MapDelNPC); //指定地图删除NPC
  Lua_Register(L, 'M_MapFindNPC', MapFindNPC); //指定地图查找NPC
  Lua_Register(L, 'M_MapAddDynamicobject', MapAddDynamicobject); //指定地图添加Dynamicobject
  Lua_Register(L, 'M_MapDelDynamicobject', MapDelDynamicobject); //指定地图删除Dynamicobject
  Lua_Register(L, 'M_MapFindDynamicobject', MapFindDynamicobject); //指定地图查找Dynamicobject
  Lua_Register(L, 'M_MapChangeDynamicobject', MapChangeDynamicobject); //改变指定地图动态物品状态
  Lua_Register(L, 'M_MapRegenMonster', MapRegenMonster); //指定地图刷新怪物
  Lua_Register(L, 'M_MapRegenNPC', MapRegenNPC); //指定地图刷新NPC
  Lua_Register(L, 'M_MapRegenDynamicObject', MapRegenDynamicObject); //指定地图刷新动态物品
  Lua_Register(L, 'M_MapUserCount', MapUserCount); //获取指定地图玩家数量
  Lua_Register(L, 'M_GetMapOnlineUser', GetMapOnlineUser); //获取指定地图玩家列表
  Lua_Register(L, 'M_GetMapName', GetMapName); //指定地图ID获取地图名称
  Lua_Register(L, 'M_GetMySqlDataSet', getMySqlDataSet); //查询MYSQL数据
  Lua_Register(L, 'M_DoMySql', DoMySql); //执行MYSQL语句,一般用于更新，删除，添加
  Lua_Register(L, 'M_MapObjSay', MapObjSay); //指定地图ID发送消息
  Lua_Register(L, 'M_MapObjSayByCol', MapObjSayByCol); //指定地图ID发送自定义颜色消息
  Lua_Register(L, 'M_MapRegen', MapRegen); //刷新指定ID地图
  Lua_Register(L, 'M_MapFindName', MapFindName); //指定ID地图查找目标
  Lua_Register(L, 'M_MapMoveByServerID', MapMoveByServerID); //指定ID地图玩家全部传送
  Lua_Register(L, 'M_MapIceMonster', MapIceMonster); //冻结地图全部怪物
  Lua_Register(L, 'M_MapboNotHItMonster', MapboNotHItMonster); //地图全部怪物允许攻击
  Lua_Register(L, 'M_GetMapRemainTickById', GetMapRemainTickById); //获取地图剩余时间
  Lua_Register(L, 'M_GetLargeLength', GetLargeLengthlua); //判断2个坐标之间距离
  Lua_Register(L, 'M_SetGuildDurabilityMax', SetGuildDurabilityMax); //设置门派石最大血量
  Lua_Register(L, 'M_GetGuildDurabilityMax', GetGuildDurabilityMax); //获取门派石最大血量
  Lua_Register(L, 'M_SetGuildDurability', SetGuildDurability); //设置门派石当前血量
  Lua_Register(L, 'M_GetGuildDurability', GetGuildDurability); //获取门派石当前血量
  Lua_Register(L, 'M_GetGuildLevel', GetGuildLevel); //获取门派石当前等级
  Lua_Register(L, 'M_SetGuildLevel', SetGuildLevel); //设定门派石当前等级
  Lua_Register(L, 'M_GetGuildEnegy', GetGuildEnegy); //获取门派石元气
  Lua_Register(L, 'M_SetGuildEnegy', SetGuildEnegy); //设定门派石元气
  Lua_Register(L, 'M_GetGuildUpEnegy', GetGuildUpEnegy); //获取门派石等级升级经验
  Lua_Register(L, 'M_GetPowerLevelName', GetPowerLevelName); //获取境界等级对应境界名称
  Lua_Register(L, 'M_GetGuildTeam', GetGuildTeam); //获取门派石门派团队
  Lua_Register(L, 'M_SetGuildTeam', SetGuildTeam); //设定门派石门派团队
  Lua_Register(L, 'M_CheckGuildTeam', CheckGuildTeam); //检测门派团派是否在使用
  Lua_Register(L, 'M_GetNewMap', GetNewMap); //根据地图ID添加个新地图
  Lua_Register(L, 'M_ScriptOpenGuildWar', ScriptOpenGuildWar); //设定门派石是否允许攻击
  Lua_Register(L, 'M_MapDelaySayNPC', MapDelaySayNPC); //指定地图ID NPC延迟说话
  Lua_Register(L, 'M_MapGetboIsDupTime', MapGetboIsDupTime); //指定地图ID 获取上次玩家退出时间 单人副本才生效
  Lua_Register(L, 'M_AddGuildUser', AddGuildUser); //添加门派成员     ,对象必须在线
  Lua_Register(L, 'M_GetGuildMagic', GetGuildMagic); //获取门派门武
  Lua_Register(L, 'M_DelGuildMagic', DelGuildMagic); //删除门派门武
  Lua_Register(L, 'M_FinalLayerCharName', FinalLayerCharName); //强制删除玩家
  Lua_Register(L, 'M_GetSdbInfo', GetSdbInfo); //读取SDB文件对应索引的值
  Lua_Register(L, 'M_SetSdbInfo', SetSdbInfo); //设置SDB文件对应索引的值
  Lua_Register(L, 'M_DelSdbInfo', DelSdbInfo); //删除SDB文件对应索引


//B(基础对象语句)
  //lua_pushcfunction(L, BasicObj);
  Lua_Register(L, 'B_SAY', SAY); //指定对象说话
  Lua_Register(L, 'B_SayDelayAdd', SayDelayAdd); //指定目标延迟说话

  Lua_Register(L, 'B_FindObjectByName', FindObjectByName); //查找周围目标
  Lua_Register(L, 'B_CommandIce', CommandIce); //冻结目标
  Lua_Register(L, 'B_DelObjByID', DelObjByID); //删除目标
  Lua_Register(L, 'B_GetGroupKey', GetGroupKey); //获取对象团队
  Lua_Register(L, 'B_SetGroupKey', SetGroupKey); //写入对象团队
  Lua_Register(L, 'B_GetPosition', GetPosition); //获取对象地图ID和坐标
  Lua_Register(L, 'B_GetCurLife', GetCurLife); //获取对象当前血量
  Lua_Register(L, 'B_GetMaxLife', GetMaxLife); //获取对象最大血量
  Lua_Register(L, 'B_ChangeLife', ChangeLife); //改变对象血量
  Lua_Register(L, 'B_GetRealName', GetRealName); //获取对象真实名
  Lua_Register(L, 'B_GetViewName', GetViewName); //获取对象显示名
  Lua_Register(L, 'B_HIT_Screen', HIT_Screen); //全屏幕攻击
  Lua_Register(L, 'B_ShowSound', ShowSound); //播放声音
  Lua_Register(L, 'B_ShowEffect', ShowEffect); //播放特效
  Lua_Register(L, 'B_ShowEffectEx', ShowEffectEx); //播放特效
  Lua_Register(L, 'B_GetRace', GetRace); //获取目标种族
  Lua_Register(L, 'B_ObjectBoNotHit', ObjectBoNotHit); //指定目标是否允许攻击
  Lua_Register(L, 'B_DynamicobjectChange', DynamicobjectChange); //改变动态物体状态
  Lua_Register(L, 'B_DynamicobjectGet', DynamicobjectGet); //获取动态物体状态
  Lua_Register(L, 'B_GetDynamicOpenedTick', GetDynamicOpenedTick); //获取动态物体打开时间
  Lua_Register(L, 'B_GotoXyStand', GotoXyStand); //指定对象移动
  Lua_Register(L, 'B_GetNearXy', GetNearXy); //获取目标周边坐标
end;

initialization


//P(指定单对象语句)

//B(盒子怪物对象语句)



finalization


end.

