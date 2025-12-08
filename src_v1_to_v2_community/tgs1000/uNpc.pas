unit uNpc;
{
继承关系
1,TBasicObject
2,------------TLifeObject
3,------------------------TNpc

}
interface

uses
  Windows, Messages, Classes, SysUtils, svClass, subutil, uAnsTick, //AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, uMonster, uUser, UserSDB,
  uManager, uSkills;

type
  TTradeUserListclass = class
  private
    FDCurTick: integer;
    Fdata: Tlist; //对话 交易 列表
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function get(aid: integer): Tuser;
    procedure del();
    procedure Update(CurTick: integer);
  end;

  TNpc = class(TLifeObject)
  private

        // boFighterNpc: Boolean;
    DblClick_UserId: integer;
    FTradeUserList: TTradeUserListclass;
    BuySellSkill: TBuySellSkill;
    SpeechSkill: TSpeechSkill;
    DeallerSkill: TDeallerSkill;
    AttackSkill: TAttackSkill;



    function Regen: Boolean;

    //function Start: Boolean;
  protected
    procedure SetNpcAttrib;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
    procedure Initial(aNpcName: string; ax, ay, aw: integer; aBookName: string; anation, amappathid: integer);
    procedure StartProcess; override;
    procedure EndProcess; override;

  public
    pSelfData: PTNpcData;
    NpcName: string;
    CreateIndex: integer;
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer); override;

    procedure CallMe(x, y: Integer);
    function GetAttackSkill: TAttackSkill;
    procedure SetAttackSkill(aAttackSkill: TAttackSkill);
    procedure RegenNpcSettingByName;

    function GetCsvStr: string;

  end;

  TNpcList = class
  private
    Manager: TManager;
    CurProcessPos: integer;

        // AnsList : TAnsList;
    DataList: TList;

        {
        function  AllocFunction: pointer;
        procedure FreeFunction (item: pointer);
        }
    function GetCount: integer;

    procedure Clear;





  public
    constructor Create(aManager: TManager);
    destructor Destroy; override;

    procedure ReLoad;
    procedure Regen;
    function CallNpc(aNpcName: string; ax, ay, aw: integer; aName: string; anation, amappathid: integer): TNpc;
    procedure AddNpc(aNpcName: string; ax, ay, aw: integer; aBookName: string; anation, amappathid: integer; aboDieDelete: boolean = false);
    procedure AddNpc2(aNpcName: string; ax, ay, aw: integer; aBookName: string; anation, amappathid: integer; adelay: Integer; aboDieDelete: boolean = false); //新增延迟添加
    function DelNpc(aName: string): boolean;
    function FindNpc(aName: string): integer;
    procedure RegenNpc(aName: string);
    procedure NotMoveNpc(aName: string; aitem: integer);
    procedure SayDelayAddNpc(aName, aSay: string; atiem: integer);
    procedure boNotHitNpc(aName: string; astate: boolean);

    procedure Update(CurTick: integer);
    property Count: integer read GetCount;
    function GetNpcIndex(id: integer): TNpc;

    function GetNpcByName(aName: string): TBasicObject;

    function getDieCount(aname: string): integer;
    function getliveCount(aname: string): integer;
    procedure SaveFileCsv;
    procedure RegenNpcSettingByName(aName: string);
  end;

    // var
       // FighterNpc : TNpc = nil;

implementation

uses
  svMain, uMarriage, uQuest;

/////////////////////////////////////
//       Npc
////////////////////////////////////

constructor TNpc.Create;
begin
  inherited Create;


  pSelfData := nil;
  DblClick_UserId := 0;
    // boFighterNpc := FALSE;

  BuySellSkill := nil;
  SpeechSkill := nil;
  DeallerSkill := nil;
  AttackSkill := nil;
end;

destructor TNpc.Destroy;
begin
  pSelfData := nil;
  if BuySellSkill <> nil then BuySellSkill.Free;
  if SpeechSkill <> nil then SpeechSkill.Free;
  if DeallerSkill <> nil then DeallerSkill.Free;
  if (AttackSkill <> nil) and (FboCopy = false) then AttackSkill.Free;

  inherited destroy;
end;

function TNpc.Regen: Boolean;
var
  i, xx, yy: word;
begin
  Result := true;

  if FboRegisted = FALSE then
  begin
    //第一次，没注册
    xx := CreatedX;
    yy := CreatedY;
  end else
  begin
    xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
    yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
  end;


  for i := 0 to 10 - 1 do
  begin                         
    //新增 修改刷新范围
    if (ActionWidth = 1) and (Maper.isMoveable(CreatedX, CreatedY)) then
    begin
      xx := CreatedX;
      yy := CreatedY;
    end
    else
    begin
      xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
      yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
    end;

    //xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
    //yy := CreatedY - ActionWidth + Random(ActionWidth * 2);

    if Maper.isMoveable(xx, yy) then
    begin
      EndProcess;
      BasicData.x := xx;
      BasicData.y := yy;
      BasicData.nx := xx;
      BasicData.ny := yy;
      BasicData.dir := DR_4;
      BasicData.Feature.rhitmotion := AM_HIT1;
      CurLife := MaxLife;
      StartProcess;
      exit;
    end;
  end;

  //没站位
  //frmMain.WriteLogInfo(format('NPC %s 没站位 %d, %d', [BasicData.Name, xx, yy]));

//  xx := CreatedX;
//  yy := CreatedY;    
  EndProcess;
//    BasicData.x := xx;
//    BasicData.y := yy;
//    BasicData.nx := xx;
//    BasicData.ny := yy;
//    BasicData.dir := DR_4;
//    BasicData.Feature.rhitmotion := AM_HIT1;
//    CurLife := MaxLife;
//    StartProcess;

  Result := false;
end;

//function TNpc.Start: Boolean;
//var
//  i, xx, yy: word;
//begin
//  Result := true;
//
//  xx := BasicData.X;
//  yy := BasicData.Y;
//  for i := 0 to 10 - 1 do
//  begin
//    if Maper.isMoveable(xx, yy) then
//    begin
//      BasicData.x := xx;
//      BasicData.y := yy;
//      BasicData.nx := xx;
//      BasicData.ny := yy;
//      BasicData.Feature.rHitMotion := AM_HIT1;
//
//      CurLife := MaxLife;
//
//      StartProcess;
//      exit;
//    end;
//    xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
//    yy := CreatedY - ActionWidth + Random(ActionWidth * 2);
//  end;
//  Result := false;
//end;


procedure TNpc.SetNpcAttrib;
begin
  if pSelfData = nil then exit;

  LifeData.damagebody := LifeData.damagebody + pSelfData^.rDamage;
  LifeData.damagehead := LifeData.damagehead + 0;
  LifeData.damagearm := LifeData.damagearm + 0;
  LifeData.damageleg := LifeData.damageleg + 0;
  LifeData.AttackSpeed := LifeData.AttackSpeed + pSelfData^.rAttackSpeed;
  LifeData.avoid := LifeData.avoid + pSelfData^.ravoid;
  LifeData.recovery := LifeData.recovery + pSelfData^.rrecovery;
  LifeData.armorbody := LifeData.armorbody + pSelfData^.rarmor;
  LifeData.armorhead := LifeData.armorhead + pSelfData^.rarmor;
  LifeData.armorarm := LifeData.armorarm + pSelfData^.rarmor;
  LifeData.armorleg := LifeData.armorleg + pSelfData^.rarmor;
  LifeData.HitArmor := LifeData.HitArmor + pselfdata^.rHitArmor;
  SoundNormal := pSelfData^.rSoundNormal;
  SoundAttack := pSelfData^.rSoundAttack;
  SoundDie := pSelfData^.rSoundDie;
  SoundStructed := pSelfData^.rSoundStructed;
end;

procedure TNpc.Initial(aNpcName: string; ax, ay, aw: integer; aBookName: string; anation, amappathid: integer);
begin
  NpcClass.GetNpcData(aNpcName, pSelfData);
  if pSelfData = nil then
  begin
    frmMain.WriteLogInfo(format('TNpc.Initial() pSelfData=NIL Error %s (%d %d)', [aNpcName, ax, ay]));
    exit;
  end;

  inherited Initial(aNpcName, (pSelfData^.rViewName));

    {
    if aNpcName = '比武场' then boFighterNpc := TRUE
    else boFighterNpc := FALSE;
    }

  DblClick_UserId := 0;

  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);
    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);
  end;

  SetNpcAttrib;

  NpcName := aNpcName;

  if pSelfData^.rboSeller = true then
  begin
    if BuySellSkill = nil then
      BuySellSkill := TBuySellSkill.Create(Self);

    BuySellSkill.LoadFromFile('.\NpcSetting\' + (pSelfData^.rNpcText));

  end;

  BasicData.id := GetNewMonsterId;
  BasicData.X := ax;
  BasicData.Y := ay;
  BasicData.ClassKind := CLASS_NPC;
  BasicData.Feature.rrace := RACE_NPC;
    // BasicData.Feature.rName Color := WinRGB(31, 31, 31);

  BasicData.Feature.raninumber := pSelfData^.rAnimate;
  BasicData.Feature.rImageNumber := pSelfData^.rShape;

  BasicData.Feature.rnation := anation;
  BasicData.MapPathID := amappathid;
  CreatedX := ax;
  CreatedY := ay;
  ActionWidth := aw;

  MaxLife := pSelfData^.rLife;
  BasicData.BasicObjectType := botNpc;
  if aBookName <> '' then
  begin
    if SpeechSkill = nil then
    begin
      SpeechSkill := TSpeechSkill.Create(Self);
    end;
    SpeechSkill.LoadFromFile('.\NpcSetting\' + aBookName);
    if DeallerSkill = nil then
    begin
      DeallerSkill := TDeallerSkill.Create(Self);
    end;
    DeallerSkill.LoadFromFile('.\NpcSetting\' + aBookName);
  end;
  BasicData.boNotHit := pSelfData.rboHit = false;
  BasicData.boNotBowHit := pSelfData.rboNotBowHit;
    //载入脚本
  //SetScript(pSelfData.rScripter, format('.\%s\%s\%s.pas', ['Script', 'npc', pSelfData.rScripter]));
  SetLuaScript(pSelfData.rScripter, format('.\%s\%s\%s\%s.lua', ['Script', 'lua', 'npc', pSelfData.rScripter]));
end;

procedure TNpc.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;
  CurLife := MaxLife;
  if pSelfData <> nil then RegenInterval := pSelfData.rrecovery;
  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);

    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);
  end;

    {
    if boFighterNpc then begin
       FighterNpc := Self;
       DontAttacked := TRUE;
    end;
    }

  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

  //CallScriptFunction('OnRegen', [integer(self)]);
  CallLuaScriptFunction('OnRegen', [integer(self)]);
end;

procedure TNpc.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;

  SetAttackSkill(nil);
  FboCopy := false;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);
    {
    if boFighterNpc then begin
       FighterNpc := nil;
       DontAttacked := FALSE;
    end;
    }

  inherited EndProcess;
end;

procedure TNpc.CallMe(x, y: Integer);
begin
  EndProcess;
  BasicData.x := x;
  BasicData.y := y;
  StartProcess;
end;

function TNpc.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i: integer;
  tx, ty: Word;
  RetStr, Str, CheatName, itemlist: string;
  bo: TBasicObject;
  User: TUser;
  Mon: TMonster;
  SubData: TSubData;
  ItemData: TItemData;
  tmpAttackSkill: TAttackSkill;

  NPCSAY: PTSNPCSAY;
  PCnpc: PTCnpc;
  attacker, _attacker: TEnmitydata;
  uUser: tuser;
begin
  Result := PROC_FALSE;

  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;
  if FboAllowDelete = true then exit;

    {
    if boFighterNpc then begin
       UserList.FieldProc2 (hfu, Msg, SenderInfo, aSubData);
       exit;
    end;
    }

 //   if LifeObjectState = los_die then exit;
  case Msg of
        { FM_KillDead:
             begin
                 Result := PROC_TRUE;
                 SetWordString(aSubData.SayString, format('你被【%s】杀死。', [BasicData.ViewName]));
                 exit;
             end;}
       { FM_CLICK:
        //菜单，1
            begin
                if SenderInfo.id = BasicData.id then exit;
                if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
                User := Tuser(SenderInfo.p);
                if User <> nil then
                begin
                    if (USER.SpecialWindow <> 0) then
                    begin
                        USER.SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
                        exit;
                    end;
                    USER.MenuSayText := '';
                    USER.MenuSTATE := nsSelect;
                    User.MenuSayObjId := BasicData.id;
                    CallLuaScriptFunction('OnMenu', [integer(SenderInfo.p), integer(self)]);
                    CallScriptFunction('OnMenu', [integer(SenderInfo.p), integer(self)]);
                end;
            end;
        FM_MenuSAY:                                                             //NPC通用 菜单 交互
            begin
                if SenderInfo.id = BasicData.id then exit;
                if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
                if SenderInfo.Feature.rfeaturestate = wfs_die then exit;
                User := Tuser(SenderInfo.p);
                USER.MenuSayText := '';
                STR := aSubData.SubName;

                USER.MenuSTATE := nsSelect;
                User.MenuSayObjId := BasicData.id;

                if STR = '' then exit;
                if STR[1] <> '@' then exit;
                STR := copy(STR, 2, length(STR));
                CallScriptFunction(str, [integer(SenderInfo.p), integer(self)]);
            end;
          }
    FM_NPC:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
        if SenderInfo.Feature.rfeaturestate = wfs_die then exit;
        User := Tuser(SenderInfo.p);
        PCnpc := @aSubData;

        if PCnpc^.rKEY = MenuFT_windowsclse then
        begin
          User.closeNPCSAYWindow;
          exit;
        end;

        if BuySellSkill = nil then
        begin
          User.closeNPCSAYWindow;
          exit;
        end;
        if BuySellSkill.ProcessMessageNEW(@aSubData, SenderInfo) = false then
        begin
          User.closeNPCSAYWindow;
          User.CloseAllWindow;
        end;
      end;

    FM_DBLCLICK:
      begin
                { User := UserList.GetUserPointer((SenderInfo.Name));
                 if User <> nil then
                 begin

                     Scripter.OnDblClick((SenderInfo.Name), NPCNAME);
                     User.Npc := SELF;
                 end;}
      end;

    FM_SHOW:
      begin
        if SenderInfo.id = BasicData.id then exit;

        if SenderInfo.Feature.rnation = BasicData.Feature.rnation then exit;
        if SenderInfo.boNotHit then exit;


        if SenderInfo.Feature.rHideState = hs_0 then exit;
        if SenderInfo.Feature.rFeatureState = wfs_die then
        begin
          if AttackSkill.GetTargetID = SenderInfo.id then
          begin
            AttackSkill.SetTargetID(0, true);
            exit;
          end;
        end;
        if AttackSkill.GetTargetID <> 0 then exit;

        if pSelfData <> nil then if pSelfData^.rboProtecter = true then
          begin
            if SenderInfo.Feature.rrace = RACE_MONSTER then
            begin
              Mon := TMonster(GetViewObjectById(SenderInfo.id));
              if Mon <> nil then
              begin
                tmpAttackSkill := Mon.GetAttackSkill;
                if tmpAttackSkill <> nil then
                begin
                  if tmpAttackSkill.boAutoAttack = true then
                    AttackSkill.SetTargetId(SenderInfo.id, true);
                end;
              end;
            end;
            exit;
          end;
        if pSelfData <> nil then if pSelfData^.rboAutoAttack = true then
          begin
            if SenderInfo.Feature.rrace = RACE_HUMAN then
            begin
              AttackSkill.SetTargetId(SenderInfo.id, true);
            end;
          end;
      end;
    FM_CHANGEFEATURE:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rHideState = hs_0 then exit;
        if (SenderInfo.id = AttackSkill.GetTargetId)
          and (SenderInfo.Feature.rFeatureState = wfs_die) then
        begin
          AttackSkill.SetTargetId(0, true);
          exit;
        end;

        if AttackSkill.GetTargetID <> 0 then exit;

        if SenderInfo.Feature.rnation = BasicData.Feature.rnation then exit;
        if SenderInfo.boNotHit then exit;

        if pSelfData^.rboAutoAttack = true then
        begin
          if SenderInfo.Feature.rrace = RACE_HUMAN then
          begin
            AttackSkill.SetTargetId(SenderInfo.id, true);
          end;
        end;
      end;

    FM_BOW,
      FM_HIT:
      begin
        if SenderInfo.ID = BasicData.ID then exit;
        if pSelfData^.rboObserver then
        begin
          //发现玩家攻击玩家 攻击对象
          if (SenderInfo.Feature.rrace = RACE_HUMAN) and (AttackSkill.GetTargetID = 0) and (isUserId(aSubData.TargetId))then
            AttackSkill.SetTargetId(SenderInfo.id, true);
        end;
      end;
    FM_STRUCTED:
      begin
        if SenderInfo.id = BasicData.id then
        begin
          if pSelfData^.rboProtecter then
          begin
            AttackSkill.SetTargetId(aSubData.attacker, true);
          end;
          if CurLife <= 0 then
          begin
            BasicData.nx := BasicData.x;
            BasicData.ny := BasicData.y;

            AttackSkill.SetTargetId(0, true);
            if isUserId(aSubData.attacker) then //20090924只有人攻击才会掉
            begin
              itemlist := '';
              _attacker := EnmityList.getMaxEnmityAttacker();
              //掉落物品
              for i := 0 to high(pSelfData^.rHaveItem) do
              begin
                if pSelfData^.rHaveItem[i].rName <> '' then
                begin
                   //判断 玩家 作弊值
                  CheatName := '';
                  uUser := UserList.GetUserPointer(_attacker.rname);
                  if (uUser <> nil) and (uUser.getCheatings > 0) then
                    CheatName := _attacker.rname;
                  if ItemClass.GetCheckItemData(NpcName, pSelfData^.rHaveItem[i], ItemData, CheatName) = false then continue;
                  NewItemSet(_nist_all, ItemData); //打编号
                  //判断是否按照浩然拾取
                  if pSelfData^.rboEnmity then
                  begin
                    ItemData.rTempOwner := _attacker;
                  end;
                                    //ItemData.rOwnerName := '';
                  SubData.ItemData := ItemData;
                  SubData.ServerId := Manager.ServerId;
                  Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                  //爆出公告
                  if (uUser <> nil) then
                    uUser.ScriptOnDropItem((BasicData.Name), ItemData.rName, ItemData.rViewName, ItemData.rCount);

                  if pSelfData^.rboLog then itemlist := itemlist + '(' + ItemData.rName + ':' + inttostr(ItemData.rCount) + ')';
                end;
              end;
              //死亡记录
              if pSelfData^.rboLog then
                logMonsterdie(_attacker.rname, BasicData.Name, itemlist, Manager.ServerId, BasicData.x, BasicData.y);

//              //GameSys.lua 杀怪触发
//              //获取最大仇恨
//              attacker := EnmityList.getMaxEnmityAttacker();
//              uUser := UserList.GetUserPointer(attacker.rname);
//              if uUser <> nil then
//                uUser.ScriptMonsterDie(integer(self), BasicData.name);

            end;
          end;
        end;
      end;
    FM_DEADHIT: //GM指令 @爆
      begin
        if SenderInfo.id = BasicData.id then exit;
        if BasicData.Feature.rfeaturestate = wfs_die then
        begin
          Result := PROC_TRUE;
          exit;
        end;
        CurLife := 0;

        AttackSkill.SetTargetId(0, true);

        BasicData.nx := BasicData.x;
        BasicData.ny := BasicData.y;
        for i := 0 to 5 - 1 do
        begin
          if pSelfData^.rHaveItem[i].rName <> '' then
          begin
            if ItemClass.GetCheckItemData(NpcName, pSelfData^.rHaveItem[i], ItemData) = false then continue;
            NewItemSet(_nist_all, ItemData); //打编号
//                        ItemData.rOwnerName := '';
            SubData.ItemData := ItemData;
            SubData.ServerId := Manager.ServerId;
            Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
          end;
        end;

        CommandChangeCharState(wfs_die);
        //CallScriptFunction('OnDie', [integer(SenderInfo.p), integer(self), SenderInfo.Feature.rrace]);
        CallLuaScriptFunction('OnDie', [integer(SenderInfo.p), integer(self), SenderInfo.Feature.rrace]);
        //if isUserId(aSubData.attacker) then tuser(SenderInfo.p).ScriptMonsterDie(integer(self), BasicData.name); //怪物触发
      end;
    FM_SAY:
      begin
                // if boFighterNpc then exit;
        if SenderInfo.Feature.rfeaturestate = wfs_die then exit;
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rrace = RACE_NPC then exit;
        str := GetWordString(aSubData.SayString);

        if BuySellSkill <> nil then
        begin
          if BuySellSkill.ProcessMessage(str, SenderInfo) = true then exit;
        end;
        if DeallerSkill <> nil then
        begin
          if DeallerSkill.ProcessMessage(str, SenderInfo) = true then exit;
        end;
      end;
  end;
end;

procedure TNpc.Update(CurTick: integer);

begin
  inherited UpDate(CurTick);
       // if boFighterNpc then exit;

    //新增定时刷新改变状态
  if AddDelayState then
  begin
    if CurTick >= AddDelayTick then
    begin
      AddDelayTick := 0;
      AddDelayState := false;
      LifeObjectState := los_die;
    end;
    exit;
  end;

  case LifeObjectState of
    los_init:
      begin
        if Regen = false then
        begin
          //EndProcess;
          frmMain.WriteLogInfo(format('TNpc.Start (%s,%d,%d,%d) failed los_init', [BasicData.Name, ServerID, BasicData.X, BasicData.Y]));
          exit;
        end;
       // Regen; //Start;
      end;
    los_die:
      begin
        if CurTick > DiedTick + 1600 then
        begin
          if Manager.RegenInterval = 0 then
          begin
            if AttackSkill <> nil then
            begin
              if AttackSkill.GetObjectBoss <> nil then
              begin
                FboAllowDelete := true;
              end;
            end;
            if FboAllowDelete = false then
            begin
                            //时间 判断 是否可复活
              if (CurTick > DiedTick + RegenInterval) or (RegenInterval <= 0) then
              begin
                if Regen = false then
                begin
                  frmMain.WriteLogInfo(format('TNpc.Regen (%s,%d,%d,%d) failed RegenInterval', [BasicData.Name, ServerID, BasicData.X, BasicData.Y]));
                  //EndProcess;
                  exit;
                end;
              end;
             // Regen;
            end;
            exit;
          end;
        end;
        if CurTick > DiedTick + 800 then
        begin
          if Manager.RegenInterval > 0 then
          begin
            FboAllowDelete := true;
            exit;
          end;
          if boDieDelete then
          begin
            FboAllowDelete := true;
            exit;
          end;
        end;
      end;
    los_none:
      begin
        if SpeechSkill <> nil then SpeechSkill.ProcessMessage(CurTick);
        if AttackSkill <> nil then AttackSkill.ProcessNone(CurTick);
      end;
    los_attack: //攻击 状态
      begin
        if AttackSkill <> nil then AttackSkill.ProcessAttack(CurTick, Self);
      end;
    los_moveattack:
      begin
        if AttackSkill <> nil then AttackSkill.ProcessMoveAttack(CurTick);
      end;
    los_deadattack:
      begin
        if AttackSkill <> nil then AttackSkill.ProcessDeadAttack(CurTick);
      end;
  end;
end;

function TNpc.GetAttackSkill: TAttackSkill;
begin
  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);
    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);
  end;
  Result := AttackSkill;
end;

function TNpc.GetCsvStr: string;
begin
  result := BasicData.ViewName + ','
    + inttostr(CreatedX) + ';' + inttostr(CreatedY) + ',';

end;

procedure TNpc.SetAttackSkill(aAttackSkill: TAttackSkill);
begin
  if (AttackSkill <> nil) and (FboCopy = false) then
  begin
    AttackSkill.Free;
  end;

  AttackSkill := aAttackSkill;
end;

procedure TNpc.RegenNpcSettingByName;
begin

  NpcClass.GetNpcData(BasicData.Name, pSelfData);
  if pSelfData = nil then
  begin
    exit;
  end;
  if pSelfData^.rboSeller = true then
  begin
    if BuySellSkill = nil then
      BuySellSkill := TBuySellSkill.Create(Self);
    BuySellSkill.LoadFromFile('.\NpcSetting\' + (pSelfData^.rNpcText));
  end;
end;

//////////////////////////////////////////////////////

procedure TTradeUserListclass.Clear;
var
  i: integer;
  pp: Tuser;
begin
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
  end;
  Fdata.Clear;
end;

procedure TTradeUserListclass.Update(CurTick: integer);
var
  i: integer;
  pp: Tuser;

begin
  if GetItemLineTimeSec(CurTick - FDCurTick) < 5 then exit;
  FDCurTick := CurTick;
  for i := Fdata.Count - 1 downto 0 do
  begin
    pp := fdata.Items[i];
    if not Assigned(pp) then
    begin
      fdata.Delete(i);
    end else
    begin

    end;

  end;

end;

procedure TTradeUserListclass.del();
begin

end;

function TTradeUserListclass.get(aid: integer): Tuser;
var
  i: integer;
  pp: Tuser;
begin
  result := nil;
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    if Assigned(pp) then
    begin
      if pp.BasicData.id = aid then
      begin
        result := pp;
        exit;
      end;
    end;
  end;
end;

constructor TTradeUserListclass.Create;
begin
  inherited Create;
  Fdata := Tlist.Create;
end;

destructor TTradeUserListclass.Destroy;
begin
  Fdata.Clear;
  Fdata.Free;
  inherited destroy;
end;

////////////////////////////////////////////////////
//
//             ===  NpcList  ===
//
////////////////////////////////////////////////////

constructor TNpcList.Create(aManager: TManager);
begin
  Manager := aManager;
  CurProcessPos := 0;
    // AnsList := TAnsList.Create (cnt, AllocFunction, FreeFunction);
  DataList := TList.Create;

  //  LoadFromFile;
end;

destructor TNpcList.Destroy;
begin
  Clear;
  DataList.Free;
    // AnsList.Free;
  inherited destroy;
end;

procedure TNpcList.Regen;
var
  i: Integer;
  Npc: TNpc;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Npc := DataList.Items[i];
    Npc.Regen;
  end;
end;

procedure TNpcList.Clear;
var
  i: Integer;
  Npc: TNpc;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Npc := DataList.Items[i];
    Npc.EndProcess;
    Npc.Free;
  end;
  DataList.Clear;
end;

procedure TNpcList.ReLoad;
var
  i, j, n: integer;
  pd: PTCreateNpcData;
begin
  Clear;
  if Manager.NpcCreateClass_p = nil then exit;
  n := Manager.NpcCreateClass_p.getCount;
  for i := 0 to n - 1 do
  begin
    pd := Manager.NpcCreateClass_p.get(i);
    if pd <> nil then
    begin
      for j := 0 to pd^.Count - 1 do
      begin
        AddNpc(pd^.mName, pd^.x, pd^.y, pd^.Width, pd^.BookName, pd^.rnation, pd^.rmappathid);
      end;
    end;
  end;
end;
{
var
    i, j: integer;
    FileName: string;
    pd: PTCreateNpcData;
    CreateNpcList: TList;
begin
    Clear;

    FileName := format('.\Setting\CreateNpc%d.SDB', [Manager.ServerID]);
    if not FileExists(FileName) then exit;

    CreateNpcList := TList.Create;
    LoadCreateNpc(FileName, CreateNpcList);
    for i := 0 to CreateNpcList.Count - 1 do
    begin
        pd := CreateNpcList.Items[i];
        if pd <> nil then
        begin
            for j := 0 to pd^.Count - 1 do
            begin
                AddNpc(pd^.mName, pd^.x, pd^.y, pd^.Width, pd^.BookName, pd^.rnation, pd^.rmappathid);
            end;
        end;
    end;
    for i := 0 to CreateNpcList.Count - 1 do
    begin
        Dispose(CreateNpcList[i]);
    end;
    CreateNpcList.Clear;
    CreateNpcList.Free;
end;
}

function TNpcList.GetCount: integer;
begin
  Result := DataList.Count;
end;

procedure TNpcList.AddNpc(aNpcName: string; ax, ay, aw: integer; aBookName: string; anation, amappathid: integer; aboDieDelete: boolean = false);
var
  Npc: TNpc;
begin
  Npc := TNpc.Create;
  if Npc <> nil then
  begin
    Npc.SetManagerClass(Manager);
    Npc.Initial(aNpcName, ax, ay, aw, aBookName, anation, amappathid);
    DataList.Add(Npc);
    Npc.boDieDelete := aboDieDelete;
  end;
end;

procedure TNpcList.AddNpc2(aNpcName: string; ax, ay, aw: integer; aBookName: string; anation, amappathid: integer; adelay: Integer; aboDieDelete: boolean = false);
var
  Npc: TNpc;
begin
  Npc := TNpc.Create;
  if Npc <> nil then
  begin
    Npc.SetManagerClass(Manager);
    Npc.Initial(aNpcName, ax, ay, aw, aBookName, anation, amappathid);
    DataList.Add(Npc);
    Npc.boDieDelete := aboDieDelete;
    //新增延迟增加
    if adelay > 0 then
    begin
      Npc.AddDelay(adelay);
     // Monster.LifeObjectState := los_exit;
      Npc.LifeObjectState := los_die;
      Npc.CommandChangeCharState(wfs_die);
    end;
  end;
end;
{function TNpcList.CallNpc(aNpcName: string; ax, ay, aw: integer; aName: string; anation, amappathid: integer): TNpc;
var
    Npc: TNpc;
    AttackSkill: TAttackSkill;
begin
    Result := nil;

    Npc := TNpc.Create;
    if Npc <> nil then
    begin
        Npc.SetManagerClass(Manager);
        Npc.Initial(aNpcName, ax, ay, aw, '', anation, amappathid);
        Npc.Start;
        AttackSkill := Npc.GetAttackSkill;
        if AttackSkill <> nil then
        begin
            AttackSkill.SetDeadAttackName(aName);
        end;
        DataList.Add(Npc);

        Result := Npc;
    end;
end;}

function TNpcList.CallNpc(aNpcName: string; ax, ay, aw: integer; aName: string; anation, amappathid: integer): TNpc;
var
  Npc: TNpc;
  AttackSkill: TAttackSkill;
begin
  Result := nil;

  Npc := TNpc.Create;
  if Npc <> nil then
  begin
    Npc.SetManagerClass(Manager);
    Npc.Initial(aNpcName, ax, ay, aw, '', anation, amappathid);
    //if Npc.Start = false then
    if Npc.Regen = false then
    begin
      frmMain.WriteLogInfo(format('TNpc.Regen (%s,%d,%d,%d) failed CallNpc', [aNpcName, Manager.ServerID, ax, ay]));
     // Npc.EndProcess;
      Npc.Free;
      exit;
    end;
       { AttackSkill := Npc.GetAttackSkill;
        if AttackSkill <> nil then
        begin
            AttackSkill.SetDeadAttackName(aName);
        end;
        }
    DataList.Add(Npc);

    Result := Npc;
  end;
end;

procedure TNpcList.Update(CurTick: integer);
var
  i, iCount: integer;
  Npc: TNpc;
begin
 {   iCount := ProcessListCount;
    if DataList.Count < iCount then
    begin
        iCount := DataList.Count;
        CurProcessPos := 0;
    end;

    for i := 0 to iCount - 1 do
    begin
        if DataList.Count = 0 then break;
        if CurProcessPos >= DataList.Count then CurProcessPos := 0;

        Npc := DataList.Items[CurProcessPos];
        if Npc.FboAllowDelete = true then
        begin
            Npc.EndProcess;
            Npc.SetAttackSkill(nil);
            Npc.Free;
            DataList.Delete(CurProcessPos);
        end else
        begin
            try
                Npc.Update(CurTick);
            except
                Npc.FboAllowDelete := true;
                frmMain.WriteLogInfo(format('TNpcList.Update (%s) failed', [Npc.NpcName]));
            end;
        end;
        Inc(CurProcessPos);
    end;
    }
  iCount := ProcessListCount;
  if DataList.Count < iCount then
  begin
    iCount := DataList.Count;
    CurProcessPos := 0;
  end;

  for i := 0 to iCount - 1 do
  begin
    if DataList.Count = 0 then break;
    if CurProcessPos >= DataList.Count then CurProcessPos := 0;

    Npc := DataList.Items[CurProcessPos];
    if Npc.FboAllowDelete = true then
    begin
      Npc.EndProcess;
      Npc.SetAttackSkill(nil);
      Npc.Free;
      DataList.Delete(CurProcessPos);
    end else
    begin
      try
        Npc.Update(CurTick);
        Inc(CurProcessPos);
      except
        Npc.FboAllowDelete := true;
        frmMain.WriteLogInfo(format('TNpcList.Update (%s) failed', [Npc.NpcName]));
      end;
    end;

  end;
end;

function TNpcList.GetNpcIndex(id: integer): TNpc;
begin
  result := nil;

  if (id < 0) or (id >= datalist.Count) then exit;

  result := datalist.Items[id];
end;

function TNpcList.FindNpc(aName: string): integer;
var
  i: Integer;
  BO: TNPC;
begin
  Result := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO <> nil then
    begin
      if (BO.BasicData.Name) = aName then
                //if BO.LifeObjectState <> los_die then
      begin
        inc(Result);
      end;
    end;
  end;
end;

function TNpcList.DelNpc(aName: string): boolean;
var
  i: Integer;
  BO: TBasicObject;
begin
  Result := false;
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO <> nil then
    begin
      if (BO.BasicData.Name) = aName then
      begin
        bo.boAllowDelete := true;
      end;
    end;
  end;
  Result := true;
end;

function TNpcList.GetNpcByName(aName: string): TBasicObject;
var
  i: Integer;
  BO: TBasicObject;
begin
  Result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO <> nil then
    begin
      if (BO.BasicData.Name) = aName then
      begin
        if BO.BasicData.Feature.rfeaturestate <> wfs_die then
        begin
          Result := BO;
          exit;
        end;
      end;
    end;
  end;
end;

function TNpcList.getDieCount(aname: string): integer;
var
  i: Integer;
  BO: TNPC;
begin
  Result := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO = nil then Continue;
    if aname <> '' then if bo.BasicData.Name <> aname then Continue;
    if BO.LifeObjectState <> los_die then Continue;
    inc(Result);
  end;
end;

procedure TNpcList.SaveFileCsv;
var
  i: Integer;
  BO: TNPC;
  templs: tstringlist;
  str: string;
begin
  templs := tstringlist.Create;
  try
    templs.Add('名字,坐标,掉落物品,');
    for i := 0 to DataList.Count - 1 do
    begin
      BO := DataList.Items[i];

      templs.Add(BO.GetCsvStr);
    end;
    templs.SaveToFile('.\help\NPC' + Manager.Title + '.csv');
  finally
    templs.Free;
  end;
end;


procedure TNpcList.RegenNpcSettingByName(aName: string);
var
  i: Integer;
  BO: TNPC;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO <> nil then
    begin
      if (BO.BasicData.Name) = aName then
        BO.RegenNpcSettingByName;
    end;
  end;
end;

function TNpcList.getliveCount(aname: string): integer;
var
  i: Integer;
  BO: TNPC;
begin
  Result := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO = nil then Continue;
    if aname <> '' then if bo.BasicData.Name <> aname then Continue;
    if BO.LifeObjectState = los_die then Continue;
    inc(Result);
  end;
end;

procedure TNpcList.boNotHitNpc(aName: string; astate: boolean);
var
  i: Integer;
  BO: TNPC;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO = nil then Continue;
    if (aname = '') or (BO.NpcName = aname) then
    begin
      BO.BasicData.boNotHit := astate;
    end;
  end;
end;

procedure TNpcList.SayDelayAddNpc(aName, aSay: string; atiem: integer);
var
  i: Integer;
  BO: TNPC;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO = nil then Continue;
    if (aname = '') or (BO.NpcName = aname) then
    begin
      BO.SayDelayAdd(aSay, atiem);
    end;
  end;
end;

procedure TNpcList.NotMoveNpc(aName: string; aitem: integer);
var
  i: Integer;
  BO: TNPC;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO = nil then Continue;
    if (aname = '') or (BO.NpcName = aname) then
    begin
      BO.LockNotMove(aitem);
    end;
  end;
end;


procedure TNpcList.RegenNpc(aName: string);
var
  i: Integer;
  BO: TNPC;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO = nil then Continue;
    if (aname = '') or (BO.NpcName = aname) then
    begin
      BO.Regen;
    end;
  end;
end;




end.

