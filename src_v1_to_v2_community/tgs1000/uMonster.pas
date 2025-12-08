unit uMonster;
{
继承关系
1,TBasicObject
2,------------TLifeObject(处理 被攻击 死亡)
3,------------------------TMonster

}
interface

uses
  Windows, Dialogs, Classes, Controls, SysUtils, svClass, subutil, uAnsTick, //AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, aiunit,
  uAIPath, uManager, uSkills, uMopSub, PaxScripter, DateUtils, UUser, uUserSub,
  uKeyClass, uLevelExp;

type

  TMonster = class(TLifeObject)
  private
    pSelfData: PTMonsterData;

    AttackSkill: TAttackSkill;

    HaveItemClass: TMopHaveItemClass; //死后 爆出物品
    HaveMagicClass: TMopHaveMagicClass;


                //自己分身 列表
    CopiedList: TList; //本类不创建 不销毁
        //自己是分身状态下的BOSS
    CopyBoss: TMonster; //本类不创建 不销毁
    FMagicName: string;

    procedure SetAttackSkillData;
    procedure SetpetAttackSkill;


  protected

    procedure SetMonsterData;
    procedure SetMonsterDataForBuff;
    procedure SetLifeData;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;

    function Regen: Boolean;
//    function Start: Boolean;
    procedure Hit_DESTROY();
  public
    UpdateTcik: integer;
    MonsterName: string;
    pUSER: pointer;
    LifeBuffer: integer;
    MultiplyBuffer: integer;
                                                     //有主人
    constructor Create;
    destructor Destroy; override;
    procedure petInitial(owner: TUserObject; aMonsterName: string; ax, ay, aw: integer; anation, amappathid: integer; aHitTargetsType: tHitTargetsType); //宠物
    procedure InitialEx(aMonsterName: string);
    procedure Initial(aMonsterName: string; ax, ay, aw: integer; anation, amappathid: integer; aHitTargetsType: tHitTargetsType);
    procedure StartProcess; override;
    procedure EndProcess; override;

    procedure Update(CurTick: integer); override;

    procedure CallMe(x, y: Integer);
    procedure CallMeServerId(aServerId, x, y: Integer);

    function GetAttackSkill: TAttackSkill;
    procedure SetAttackSkill(aAttackSkill: TAttackSkill);
        //设置攻击目标
    procedure SetAttackObj(aid: integer);
    function AddBuffer(aid: Integer; aname: string; aLifeData: TLifeData; atime, asharp, aeffect: Integer; adesc: string): boolean;
    function GetBuffer(aid: Integer): Integer;
    function AddMultiplyBuffer(aid: Integer; aname: string; aLifeData: TLifeData; atime, asharp, aeffect: Integer; adesc: string): boolean;
    function GetMultiplyBuffer(aid: Integer): Integer;
    procedure OnAddBuffer(var temp: TLifeDataListdata);
    procedure OnDelBuffer(var temp: TLifeDataListdata);
    procedure OnUPdateBuffer(var temp: TLifeDataListdata);
    procedure OnClearBuffer();
    procedure GetAllBuffer(var tempall: TAllBuffDataMessage);
    function SetAttackMagic(AMagicName: string; Aid, AiMode, Amskill: integer): Boolean;
    function SetHaveMagic(AMagicName: string): Boolean;
    function SetHaveMagicExt(AMagicName: string; aPara: TMagicParamData; aid: integer): Boolean;

    function GetCreatedX: integer;
    function GetCreatedY: integer;

    procedure setpetdata(owner: TUserObject);
        //获取一层近身武功经验
    function GetShortExp: integer;
        //获取二层近身武功经验
    function GetRiseShortExp: integer;
        //获取一层远程武功经验
    function GetLongExp: integer;
        //获取二层远程武功经验
    function GetRiseLongExp: integer;


  public
    //20091023增加 分身 管理
    procedure CopyMonster_add(aCount: integer); //唯一 分身 创建
    procedure CopyMonster_Del(adelMonster: TMonster); //唯一 分身 删除
    procedure CopyMonster_AllDie(); //唯一 分身 全部死亡
    procedure CopyMonster_Clear; //唯一 分身 销毁
    //
    function GetCsvStr: string;
    function GetCsvCreatexy: string;
    function GetCsvDorpItem: string;
  end;

  TMonsterList = class
  private
    Manager: TManager;

    CurProcessPos: integer;
    DataList: TList;

    function GetCount: integer;
    procedure Clear;

  public
    constructor Create(aManager: TManager);
    destructor Destroy; override;


    procedure RegenMonster(aMonsterName: string);

    procedure AddMonster(aMonsterName: string; ax, ay, aw: integer; aMemberStr: string; anation, amappathid: integer; aboDieDelete: boolean);
    procedure AddMonster2(aMonsterName: string; ax, ay, aw: integer; aMemberStr: string; anation, amappathid: integer; aboDieDelete: boolean; adelay: Integer);
    function CallMonster(aMonsterName: string; ax, ay, aw: integer; aName: string): TMonster;
    function CopyMonster(aMonster: TMonster): TMonster;
    procedure ComeOn(aName: string; X, Y: Word);

    procedure iceMonster(aMonsterName: string; astate: boolean);
    function getDieCount(aname: string): integer;
    function getliveCount(aname: string): integer;

    function FindMonster(aMonsterName: string): Integer;
    function DeleteMonster(aMonsterName: string): Boolean;
    procedure NotMoveMonster(aMonsterName: string; atime: integer);
    procedure boNotHitMonster(aMonsterName: string; astate: boolean);
    procedure SayDelayAddMonster(aMonsterName, asay: string; atime: integer);
    procedure Regen;
    procedure ReLoad;

    function getHelpHtm: string;

    procedure Update(CurTick: integer);

    function GetMonsterByName(aName: string): TMonster;

    property Count: integer read GetCount;
  end;

  TMonsterHtmClass = class
  private
    fname, fVname: string;
    dataList: tlist;
                                                               //坐标列表
    fdorpItem: string;
    flevel: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(ax, ay: integer);
    function getMin(ax, ay: integer): integer;
    function getList(): string;

  end;

  TMonsterHtmListClass = class
  private
    dataList: tlist;
    fnameindex: TStringKeyClass;
  public
    procedure Clear;
    constructor Create;
    destructor Destroy; override;
    procedure add(aname: string);
    function get(aname: string): TMonsterHtmClass;
    procedure addMonster(aMonster: TMonster);
    procedure Sort;
  end;


implementation

uses
  SvMain;

/////////////////////////////////////
//       Monster
////////////////////////////////////

constructor TMonster.Create;
var
  i: Integer;
begin
  inherited Create;

  FMagicName := '';
  CopiedList := nil;
  CopyBoss := nil;
  pSelfData := nil;
  AttackSkill := nil;
  pUSER := nil;
  LifeBuffer := 0;
  MultiplyBuffer := 0;
  UpdateTcik := 0;


  HaveItemClass := TMopHaveItemClass.Create(Self);
  HaveMagicClass := TMopHaveMagicClass.Create(SElf);

end;

destructor TMonster.Destroy;
begin
  CopyMonster_Clear;
  CopyBoss := nil;
  HaveMagicClass.Free;
  HaveItemClass.Free;

  if pUSER <> nil then
  begin
       // tuser(pUSER).pMonster := nil; 应该掉过程
    tuser(pUSER).MonsterDel(Self);
  end;


  pSelfData := nil;
  if (AttackSkill <> nil) and (FboCopy = false) then
  begin
    AttackSkill.Free;
  end;
  if LifeBuffer <> 0 then
  begin
    with TLifeDataList(LifeBuffer) do
    begin
      ONadd := nil;
      ONdel := nil;
      ONUPdate := nil;
      ONClear := nil;
    end;
    TLifeDataList(LifeBuffer).Free;
    LifeBuffer := 0;
  end;
  if MultiplyBuffer <> 0 then
  begin
    with TLifeDataList(MultiplyBuffer) do
    begin
      ONadd := nil;
      ONdel := nil;
      ONUPdate := nil;
      ONClear := nil;
    end;
    TLifeDataList(MultiplyBuffer).Free;
    MultiplyBuffer := 0;
  end;
  inherited Destroy;
end;

procedure TMonster.Hit_DESTROY();
begin
  EndProcess;
end;

function TMonster.Regen: Boolean;
var
  i, xx, yy: integer;
begin

  Result := true;

    //滚动石头机关
  if BasicData.boMoveKill then
  begin
    xx := CreatedX;
    yy := CreatedY;
    EndProcess;
    BasicData.x := xx;
    BasicData.y := yy;
    BasicData.nx := xx;
    BasicData.ny := yy;
    CurLife := MaxLife;
    StartProcess;
    exit;
  end;
    //元神
  if pUSER <> nil then
  begin
    xx := tuser(pUSER).BasicData.x + Random(3); //20131117这里修改了下宠物的刷新坐标                          // - 8 + Random(16);
    yy := tuser(pUSER).BasicData.Y + Random(3); // - 8 + Random(16);
    if Maper.GetMoveableXy(xx, yy, 10) = false then
    begin
      if Maper.getMoveable_width(xx, yy, 10) = false then
      begin
        xx := tuser(pUSER).BasicData.x + Random(3); // - 8 + Random(16);
        yy := tuser(pUSER).BasicData.y + Random(3);
      end;
    end;
    EndProcess;
    BasicData.x := xx;
    BasicData.y := yy;
    BasicData.nx := xx;
    BasicData.ny := yy;

    CurLife := tuser(pUSER).MonsterUserMaxLife;
    StartProcess;
    exit;
  end;

    //正常
   { if FboRegisted = FALSE then      //20130605修改
    begin
    //没注册，第一复活，开始
        xx := CreatedX;
        yy := CreatedY;
    end else
    begin }
  //xx := CreatedX - ActionWidth + Random(ActionWidth * 2);
  //yy := CreatedY - ActionWidth + Random(ActionWidth * 2);

  //新增 修改刷新范围
  //xx := CreatedX - RegenWidth + Random(RegenWidth * 2);
  //yy := CreatedY - RegenWidth + Random(RegenWidth * 2);

    //end;
  for i := 0 to 10 - 1 do
  begin
    //新增 修改刷新范围
    if (RegenWidth = 1) and (Maper.isMoveable(CreatedX, CreatedY)) then
    begin
      xx := CreatedX;
      yy := CreatedY;
    end
    else
    begin
      xx := CreatedX - RegenWidth + Random(RegenWidth * 2);
      yy := CreatedY - RegenWidth + Random(RegenWidth * 2);
    end;

    if Maper.isMoveable(xx, yy) then
    begin
      EndProcess;
      BasicData.x := xx;
      BasicData.y := yy;
      BasicData.nx := xx;
      BasicData.ny := yy;
      CurLife := MaxLife;
      StartProcess;
      exit;
    end;
  end;

    //没站点
 // xx := CreatedX;
 // yy := CreatedY;
  EndProcess;
//  BasicData.x := xx;
//  BasicData.y := yy;
//  BasicData.nx := xx;
//  BasicData.ny := yy;
//  CurLife := MaxLife;
//  StartProcess;
//  exit;

  Result := false;
end;

//找到1个能站的位置

//function TMonster.Start: Boolean;
//var
//  i, xx, yy: word;
//begin
//
//  Result := true;
////  if BasicData.boMoveKill then
////  begin
////    xx := CreatedX;
////    yy := CreatedY;
////    EndProcess;
////    BasicData.x := xx;
////    BasicData.y := yy;
////    BasicData.nx := xx;
////    BasicData.ny := yy;
////    if pUSER <> nil then
////      CurLife := tuser(pUSER).getMaxLife
////    else
////      CurLife := MaxLife;
////    StartProcess;
////    exit;
////  end;
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
//      if pUSER <> nil then
//        CurLife := tuser(pUSER).getMaxLife
//      else
//        CurLife := MaxLife;
//
//      StartProcess;
//      exit;
//    end;
//    xx := CreatedX - RegenWidth + Random(RegenWidth * 2);
//    yy := CreatedY - RegenWidth + Random(RegenWidth * 2);
//  end;
//  Result := false;
//end;

procedure TMonster.SetpetAttackSkill; //宠物技能设置   这里没调好
begin
  if pSelfData = nil then exit;
  if AttackSkill = nil then exit;

  AttackSkill.boViewHuman := pSelfData^.rboViewHuman;
  AttackSkill.boAutoAttack := True; //主动攻击
    //pSelfData^.rboAutoAttack;
  AttackSkill.boAttack := pSelfData^.rboAttack;
  AttackSkill.EscapeLife := pSelfData^.rEscapeLife;
  AttackSkill.ViewWidth := pSelfData^.rViewWidth;
  AttackSkill.boChangeTarget := pSelfData^.rboChangeTarget;
  AttackSkill.boBoss := pSelfData^.rboBoss;
  AttackSkill.boVassal := pSelfData^.rboVassal;
  AttackSkill.VassalCount := pSelfData^.rVassalCount;
  AttackSkill.SetAttackMagic(pSelfData^.rAttackMagic);
end;

procedure TMonster.SetAttackSkillData;
begin
  if pSelfData = nil then exit;
  if AttackSkill = nil then exit;

  AttackSkill.boViewHuman := pSelfData^.rboViewHuman;
  AttackSkill.boAutoAttack := pSelfData^.rboAutoAttack;
  AttackSkill.boAttack := pSelfData^.rboAttack;
  AttackSkill.EscapeLife := pSelfData^.rEscapeLife;
  AttackSkill.ViewWidth := pSelfData^.rViewWidth;
  AttackSkill.boChangeTarget := pSelfData^.rboChangeTarget;
  AttackSkill.boBoss := pSelfData^.rboBoss;
  AttackSkill.boVassal := pSelfData^.rboVassal;
  AttackSkill.VassalCount := pSelfData^.rVassalCount;
  AttackSkill.SetAttackMagic(pSelfData^.rAttackMagic);
  FMagicName := pSelfData^.rAttackMagic.rname;
end;


procedure TMonster.SetpetData(owner: TUserObject); //宠物的属性设置
var
  i: Integer;
  CheckItemclass: TCheckItemclass;
  x: TMagicData;
begin
  if pSelfData = nil then exit;


  LifeData.damageBody := 100 + owner.petlevel * 20; //+ LifeData.damageBody + pSelfData^.rDamage ;
  LifeData.damageHead := LifeData.damageHead + 0;
  LifeData.damageArm := LifeData.damageArm + 0;
  LifeData.damageLeg := LifeData.damageLeg + 0;
  LifeData.AttackSpeed := 150 + pSelfData^.rAttackSpeed - owner.petlevel div 10;
  LifeData.avoid := owner.petlevel; //+ LifeData.avoid + pSelfData^.ravoid;
  LifeData.recovery := 120 + pSelfData^.rrecovery - owner.petlevel div 10;
  LifeData.armorBody := 100 + owner.petlevel * 15; // + LifeData.armorBody + pSelfData^.rarmor ;
  LifeData.armorHead := pSelfData^.rarmor;
  LifeData.armorArm := pSelfData^.rarmor;
  LifeData.armorLeg := pSelfData^.rarmor;
  LifeData.HitArmor := pSelfData^.rHitArmor;

    {if pUSER <> nil then
    begin
        BasicData.Feature.rMonType := 1;
        BasicData.MasterId := tuser(pUSER).BasicData.id;
        copymemory(@BasicData.Feature.rArr[0], @tuser(pUSER).BasicData.Feature.rArr, sizeof(BasicData.Feature.rArr));
        BasicData.Feature.rboman := tuser(pUSER).BasicData.Feature.rboman;
        BasicData.Feature.rhitmotion := tuser(pUSER).BasicData.Feature.rhitmotion;
        //MaxLife := tuser(pUSER).getMaxLife;
    end else
    }
  begin
    BasicData.Feature.rMonType := pSelfData.rMonType;
    if BasicData.Feature.rMonType = 1 then
    begin
    //人 型怪物
      copymemory(@BasicData.Feature.rArr[0], @pSelfData.rArr, sizeof(BasicData.Feature.rArr));
      BasicData.Feature.rboman := pSelfData.rboman;
      BasicData.Feature.rhitmotion := pSelfData.rhitmotion;

    end
    else
    begin
      BasicData.Feature.rhitmotion := AM_HIT1;
      BasicData.Feature.raninumber := pSelfData^.rAnimate;
      BasicData.Feature.rImageNumber := pSelfData^.rShape;
      BasicData.boMoveKill := pSelfData^.rboControl;
      if BasicData.boMoveKill then
        BasicData.boMoveKillView := 1;
    end;

  end;
  BasicData.boNotAddExp := pSelfData^.rboNOTAddExp;
   { for i := 0 to high(pSelfData^.rHaveItem) do
    begin
        HaveItemClass.AddDropItem(pSelfData^.rHaveItem[i].rName, pSelfData^.rHaveItem[i].rCount);
    end;
    }


  //   HaveItemClass.DropSetCheckItemclass(pSelfData^.rHaveItemListP);   //宠物不掉装备
  MaxLife := owner.petlevel * 100 + 100;
  //  MaxLife := pSelfData^.rLife;
    {if pUSER <> nil then
        CurLife := tuser(pUSER).getMaxLife
    else}
  CurLife := MaxLife;

  SetpetAttackSkill;
  WalkSpeed := pSelfData^.rWalkSpeed - owner.petlevel;

  if WalkSpeed < 30 then WalkSpeed := 30;

  BasicData.Feature.WalkSpeed := WalkSpeed;
  BasicData.Feature.AttackSpeed := LifeData.AttackSpeed;

  SoundNormal := pSelfData^.rSoundNormal;
  SoundAttack := pSelfData^.rSoundAttack;
  SoundDie := pSelfData^.rSoundDie;
  SoundStructed := pSelfData^.rSoundStructed;

end;

procedure TMonster.petInitial(owner: TUserObject; aMonsterName: string; ax, ay, aw: Integer; anation, amappathid: integer; aHitTargetsType: tHitTargetsType);
var
  i: Integer;
  MonsterData: TMonsterData;
begin
  MonsterClass.GetMonsterData(aMonsterName, pSelfData);
  if pSelfData = nil then
  begin
    frmMain.WriteLogInfo(format('TMonster.Initial() pSelfData=NIL Error %s (%d %d)', [aMonsterName, ax, ay]));
    exit;
  end;
  inherited Initial(aMonsterName, (pSelfData^.rViewName));

  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);
    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);
  end;

  HaveItemClass.Clear;

  SetpetData(owner);


  owner.SendClass.SendChatMessage('耐久度：' + inttostr(owner.xpetgrade) + ' 攻击力' + inttostr(LifeData.damageBody) + ' 攻击速度' + inttostr(LifeData.AttackSpeed) +
    ' 躲闪' + inttostr(LifeData.avoid) + ' 恢复' + inttostr(LifeData.recovery) + ' 防御' + inttostr(LifeData.armorBody), SAY_COLOR_SYSTEM);

  MonsterName := aMonsterName;

  BasicData.master := Pointer(owner); //传递宠物的主人的指针参数
  Basicdata.id := GetNewMonsterId;
  BasicData.X := ax;
  BasicData.Y := ay;
  BasicData.ClassKind := CLASS_MONSTER;
  BasicData.Feature.rrace := RACE_MONSTER;


  CreatedX := ax;
  CreatedY := ay;

  ActionWidth := aw;
  HaveMagicClass.Init(owner.petmagic);
  //  HaveMagicClass.Init(pSelfData^.rHaveMagic);
  BasicData.BasicObjectType := botMonster;
  HaveItemClass.boLog := pSelfData^.rboLOG;


  BasicData.Feature.rnation := anation;

  BasicData.HitTargetsType := _htt_nation;
  BasicData.MapPathID := amappathid;
  MapPath := nil;
  if BasicData.MapPathID > 0 then MapPath := MapPathList.get(BasicData.MapPathID);
  //SetScript(pSelfData.rScripter, format('.\%s\%s\%s.pas', ['Script', 'Monster', pSelfData.rScripter]));
  SetLuaScript(pSelfData.rScripter, format('.\%s\%s\%s\%s.lua', ['Script', 'lua', 'Monster', pSelfData.rScripter]));
  Fboice := pSelfData.rboice;
end;

//初始化才会执行

procedure TMonster.SetMonsterData;
var
  i: Integer;
  CheckItemclass: TCheckItemclass;
begin
  if pSelfData = nil then exit;

  LifeData.damageBody := LifeData.damageBody + pSelfData^.rDamage;
  LifeData.damageHead := LifeData.damageHead + 0;
  LifeData.damageArm := LifeData.damageArm + 0;
  LifeData.damageLeg := LifeData.damageLeg + 0;
  LifeData.AttackSpeed := LifeData.AttackSpeed + pSelfData^.rAttackSpeed;
  LifeData.avoid := LifeData.avoid + pSelfData^.ravoid;
  LifeData.recovery := LifeData.recovery + pSelfData^.rrecovery;
  LifeData.armorBody := LifeData.armorBody + pSelfData^.rarmor;
  LifeData.armorHead := LifeData.armorHead + pSelfData^.rarmor;
  LifeData.armorArm := LifeData.armorArm + pSelfData^.rarmor;
  LifeData.armorLeg := LifeData.armorLeg + pSelfData^.rarmor;
  LifeData.HitArmor := pSelfData^.rHitArmor;
  LifeData.accuracy := LifeData.avoid + pSelfData^.rAccuracy;


    {if pUSER <> nil then
    begin
        BasicData.Feature.rMonType := 1;
        BasicData.MasterId := tuser(pUSER).BasicData.id;
        copymemory(@BasicData.Feature.rArr[0], @tuser(pUSER).BasicData.Feature.rArr, sizeof(BasicData.Feature.rArr));
        BasicData.Feature.rboman := tuser(pUSER).BasicData.Feature.rboman;
        BasicData.Feature.rhitmotion := tuser(pUSER).BasicData.Feature.rhitmotion;
        //MaxLife := tuser(pUSER).getMaxLife;
    end else
    }
  begin
    BasicData.Feature.rMonType := pSelfData.rMonType;
    if BasicData.Feature.rMonType = 1 then
    begin
    //人 型怪物
      copymemory(@BasicData.Feature.rArr[0], @pSelfData.rArr, sizeof(BasicData.Feature.rArr));
      BasicData.Feature.rboman := pSelfData.rboman;
      BasicData.Feature.rhitmotion := pSelfData.rhitmotion;

    end
    else
    begin
      BasicData.Feature.rhitmotion := AM_HIT1;
      BasicData.Feature.raninumber := pSelfData^.rAnimate;
      BasicData.Feature.rImageNumber := pSelfData^.rShape;
      BasicData.boMoveKill := pSelfData^.rboControl;
      if BasicData.boMoveKill then
        BasicData.boMoveKillView := 1;
    end;

  end;
  BasicData.boNotAddExp := pSelfData^.rboNOTAddExp;
  //2015年10月17日 16:23:11新增
  BasicData.boNotHit := pSelfData.rboHit = false;
  BasicData.boNotBowHit := pSelfData.rboNotBowHit;
  BasicData.rboScripterHit := pSelfData.rboScripterHit;

   { for i := 0 to high(pSelfData^.rHaveItem) do
    begin
        HaveItemClass.AddDropItem(pSelfData^.rHaveItem[i].rName, pSelfData^.rHaveItem[i].rCount);
    end;
    }


  HaveItemClass.DropSetCheckItemclass(pSelfData^.rHaveItemListP);

  MaxLife := pSelfData^.rLife;
    {if pUSER <> nil then
        CurLife := tuser(pUSER).getMaxLife
    else}
  CurLife := MaxLife;

  SetAttackSkillData;
  WalkSpeed := pSelfData^.rWalkSpeed;

  if WalkSpeed < 30 then WalkSpeed := 30;

  BasicData.Feature.WalkSpeed := WalkSpeed;
  BasicData.Feature.AttackSpeed := LifeData.AttackSpeed;

  SoundNormal := pSelfData^.rSoundNormal;
  SoundAttack := pSelfData^.rSoundAttack;
  SoundDie := pSelfData^.rSoundDie;
  SoundStructed := pSelfData^.rSoundStructed;

end;

procedure TMonster.SetMonsterDataForBuff;
var
  i: Integer;
  CheckItemclass: TCheckItemclass;
begin
  if pSelfData = nil then exit;

  LifeData.damageBody := LifeData.damageBody + pSelfData^.rDamage;
  LifeData.damageHead := LifeData.damageHead + 0;
  LifeData.damageArm := LifeData.damageArm + 0;
  LifeData.damageLeg := LifeData.damageLeg + 0;
  LifeData.AttackSpeed := LifeData.AttackSpeed + pSelfData^.rAttackSpeed;
  LifeData.avoid := LifeData.avoid + pSelfData^.ravoid;
  LifeData.recovery := LifeData.recovery + pSelfData^.rrecovery;
  LifeData.armorBody := LifeData.armorBody + pSelfData^.rarmor;
  LifeData.armorHead := LifeData.armorHead + pSelfData^.rarmor;
  LifeData.armorArm := LifeData.armorArm + pSelfData^.rarmor;
  LifeData.armorLeg := LifeData.armorLeg + pSelfData^.rarmor;
  LifeData.HitArmor := pSelfData^.rHitArmor;
  LifeData.accuracy := LifeData.accuracy + pSelfData^.rAccuracy; // 15.8.1  by nirendao

  WalkSpeed := pSelfData^.rWalkSpeed;

  if WalkSpeed < 20 then WalkSpeed := 20;

  BasicData.Feature.WalkSpeed := WalkSpeed;
  BasicData.Feature.AttackSpeed := LifeData.AttackSpeed;




end;

procedure TMonster.SetLifeData;
var
  tempLifeData: tLifeData;
begin

  if pSelfData = nil then exit;

  fillchar(LifeData, sizeof(LifeData), 0);
  LifeData.damageBody := 55;
  LifeData.damageHead := 0;
  LifeData.damageArm := 0;
  LifeData.damageLeg := 0;
  LifeData.armorBody := 0;
  LifeData.armorHead := 0;
  LifeData.armorArm := 0;
  LifeData.armorLeg := 0;
  LifeData.AttackSpeed := 150;
  LifeData.avoid := 25;
  LifeData.recovery := 70;
  LifeData.accuracy := 0;

  SetMonsterDataForBuff;
    //Multiply Buffer
  if MultiplyBuffer <> 0 then
  begin
    tempLifeData := LifeData;
    GatMultiplyLifeData(tempLifeData, TLifeDataList(MultiplyBuffer).LifeData);
    GatherLifeData(LifeData, tempLifeData);
  end;
    //Buffer
  if LifeBuffer <> 0 then
  begin
    GatherLifeData(LifeData, TLifeDataList(LifeBuffer).LifeData);
  end;

end;

procedure TMonster.Initial(aMonsterName: string; ax, ay, aw: Integer; anation, amappathid: integer; aHitTargetsType: tHitTargetsType);
var
  i: Integer;
  MonsterData: TMonsterData;
begin
  MonsterClass.GetMonsterData(aMonsterName, pSelfData);
  if pSelfData = nil then
  begin
    frmMain.WriteLogInfo(format('TMonster.Initial() pSelfData=NIL Error %s (%d %d)', [aMonsterName, ax, ay]));
    exit;
  end;
  inherited Initial(aMonsterName, (pSelfData^.rViewName));

  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);
    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);
  end;

  HaveItemClass.Clear;

  SetMonsterData;


  MonsterName := aMonsterName;


  Basicdata.id := GetNewMonsterId;
  BasicData.X := ax;
  BasicData.Y := ay;
  BasicData.ClassKind := CLASS_MONSTER;
  BasicData.Feature.rrace := RACE_MONSTER;


  CreatedX := ax;
  CreatedY := ay;

  ActionWidth := pSelfData^.rActionWidth;
  RegenWidth := aw; //新增刷新范围

  HaveMagicClass.Init(pSelfData^.rHaveMagic);
  BasicData.BasicObjectType := botMonster;
  HaveItemClass.boLog := pSelfData^.rboLOG;


  BasicData.Feature.rnation := anation;

  BasicData.HitTargetsType := _htt_nation;
  BasicData.MapPathID := amappathid;
  MapPath := nil;
  if BasicData.MapPathID > 0 then MapPath := MapPathList.get(BasicData.MapPathID);
  //SetScript(pSelfData.rScripter, format('.\%s\%s\%s.pas', ['Script', 'Monster', pSelfData.rScripter]));
  SetLuaScript(pSelfData.rScripter, format('.\%s\%s\%s\%s.lua', ['Script', 'lua', 'Monster', pSelfData.rScripter]));
  Fboice := pSelfData.rboice;
end;

procedure TMonster.InitialEx(aMonsterName: string);
var
  i: Integer;
  MonsterData: TMonsterData;
begin
  MonsterClass.GetMonsterData(aMonsterName, pSelfData);

  BasicData.Name := (pSelfData^.rName);
  BasicData.ViewName := (pSelfData^.rViewName);

  inherited InitialEx;

  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);
    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);
  end;

  HaveItemClass.DropItemClear;

  SetMonsterData;

  MonsterName := aMonsterName;

  HaveMagicClass.Init(pSelfData^.rHaveMagic);
  RegenInterval := pSelfData.rRegenInterval;
end;

procedure TMonster.StartProcess;
var
  SubData: TSubData;
  MonsterData: TMonsterData;
begin

  inherited StartProcess;
  BasicData.boHaveSwap := false;
  if pSelfData <> nil then
    RegenInterval := pSelfData.rRegenInterval;

  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);

    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);

    SetAttackSkillData;
  end;
  if pUSER <> nil then
  begin
    BasicData.Feature.rMonType := mtype; //20130622修改，这里的montye就是指定了类型，元神就是1，宠物就是0 /2
    BasicData.MasterId := tuser(pUSER).BasicData.id;
    copymemory(@BasicData.Feature.rArr[0], @tuser(pUSER).BasicData.Feature.rArr, sizeof(BasicData.Feature.rArr));
    BasicData.Feature.rboman := tuser(pUSER).BasicData.Feature.rboman;
    if mtype = 1 then
    begin
      BasicData.Feature.rhitmotion := tuser(pUSER).BasicData.Feature.rhitmotion;
      if AttackSkill <> nil then AttackSkill.SetAttackMagic(tuser(pUSER).getAttackMagic);
    end;
    case monrole of

      0: BasicData.ViewName := tuser(pUSER).petname + '[' + inttostr(getxlevel(tuser(pUSER).getpetexp)) + '级]';
      1: BasicData.ViewName := tuser(pUSER).name + '的元神';
      2: BasicData.ViewName := tuser(pUSER).petname + '[' + inttostr(getxlevel(tuser(pUSER).getpetexp)) + '级]';
    end;
       ////////////////////////////////////////////////////////////
  end;
  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

  if FboCopy = true then
  begin
    ShowEffect(1, lek_none);
  end;
  HaveMagicClass.Clear;
    // 篮脚贱
  if HaveMagicClass.isHaveHideMagic then
  begin
    if HaveMagicClass.RunHaveHideMagic(BasicData.LifePercent) then
    begin
      SetHideState(hs_0);
    end;
  end;
    //必杀技
  HitFunctionSkill := 0;
  HitFunction := 0;
  if HaveMagicClass.isHaveMAGICFUNCMagic then
  begin
    if HaveMagicClass.RunHaveMAGICFUNCMagic(HitFunction, HitFunctionSkill) = false then
    begin
      HitFunctionSkill := 0;
      HitFunction := 0;
    end;
  end;
  //CallScriptFunction('OnRegen', [integer(self)]);
  CallLuaScriptFunction('OnRegen', [integer(self)]);
end;

procedure TMonster.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;


    //自己是分身，通知主人自己销毁
  try
    if CopyBoss <> nil then CopyBoss.CopyMonster_Del(self);
  except
  end;
  CopyBoss := nil;
    //自己是主人，销毁全部分身
  CopyMonster_Clear;

  SetAttackSkill(nil);
  FboCopy := false;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;

procedure TMonster.CallMeServerId(aServerId, x, y: Integer);
var
  SubData: TSubData;
  tmpManager: TManager;
  PosMoveX, PosMoveY: integer;
begin
  if FboRegisted = FALSE then exit;
  Phone.SendMessage(NOTARGETPHONE, FM_DESTROY, BasicData, SubData); //消失
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y); //卸载
  PosMoveX := x;
  PosMoveY := y;
  if aServerId <> Manager.ServerID then
  begin
    tmpManager := ManagerList.GetManagerByServerID(aServerId);
    if tmpManager <> nil then
    begin
      SetManagerClass(tmpManager);
    end else
    begin
      frmMain.WriteLogInfo(format('TMonster.CallMeServerId;Manager = nil (%s, %d, %d, %d)', [MonsterName, aServerId, PosMoveX, PosMoveY]));
    end;
  end;

  if Maper.GetMoveableXy(PosMoveX, PosMoveY, 10) = false then
  begin
    frmMain.WriteLogInfo(format('TMonster.CallMeServerId; (%s, %d, %d, %d)', [MonsterName, aServerId, PosMoveX, PosMoveY]));
  end;

  BasicData.x := PosMoveX;
  BasicData.y := PosMoveY;
  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(NOTARGETPHONE, FM_CREATE, BasicData, SubData);
end;

procedure TMonster.CallMe(x, y: Integer);
begin
  EndProcess;
  BasicData.x := x;
  BasicData.y := y;
  StartProcess;
end;



procedure TMonster.CopyMonster_add(aCount: integer); //唯一 分身 创建
var
  aMonster: TMonster;
  j: integer;
begin
  if aCount <= 0 then exit;
  if CopiedList = nil then //=NIL 创建
  begin
    CopiedList := TList.Create; //创建
  end;
  for j := 0 to aCount - 1 do
  begin
    aMonster := TMonsterList(Manager.MonsterList).CopyMonster(Self);
    if aMonster <> nil then
    begin
      aMonster.CopyBoss := Self;
      aMonster.LifeObjectState := LifeObjectState;
      CopiedList.Add(aMonster); //创建 分身完成 增加到列表
    end;
  end;
end;

procedure TMonster.CopyMonster_Del(adelMonster: TMonster);
var
  i: integer;
  aMonster: TMonster;
begin
  if CopiedList = nil then exit;
  for i := 0 to CopiedList.Count - 1 do
  begin
    if CopiedList.Items[i] = adelMonster then
    begin
      CopiedList.Delete(i);
      exit;
    end;
  end;

end;

procedure TMonster.CopyMonster_AllDie(); //唯一 分身 全部死亡
var
  i: integer;
  aMonster: TMonster;
begin
  if CopiedList = nil then exit;
  for i := 0 to CopiedList.Count - 1 do
  begin
    aMonster := CopiedList.Items[i];
    aMonster.CurLife := 0;
    aMonster.BasicData.LifePercent := 0;
    aMonster.CommandChangeCharState(wfs_die);
  end;
end;

function TMonster.GetCreatedX: integer;
begin
  result := CreatedX;
end;

function TMonster.GetCreatedY: integer;
begin
  result := Createdy;
end;

function TMonster.GetShortExp: integer;
begin
  result := pSelfData.rShortExp;
end;

function TMonster.GetRiseShortExp: integer;
begin
  result := pSelfData.rRiseShortExp;
end;

function TMonster.GetLongExp: integer;
begin
  result := pSelfData.rLongExp;
end;

function TMonster.GetRiseLongExp: integer;
begin
  result := pSelfData.rRiseLongExp;
end;

function TMonster.GetCsvCreatexy: string;
begin
  result := inttostr(CreatedX) + ';' + inttostr(CreatedY);
end;

function TMonster.GetCsvDorpItem: string;
begin
  result := '';
  if HaveItemClass <> nil then
    result := HaveItemClass.GetCsvStr;

end;

function TMonster.GetCsvStr: string;
begin
  result := BasicData.ViewName + ','
    + inttostr(CreatedX) + ';' + inttostr(CreatedY) + ',';
  if HaveItemClass <> nil then
    result := result + HaveItemClass.GetCsvStr + ',';
end;

procedure TMonster.CopyMonster_Clear();
var
  i: integer;
  aMonster: TMonster;
begin
  if CopiedList = nil then exit;
  for i := 0 to CopiedList.Count - 1 do
  begin
    aMonster := CopiedList.Items[i];
    aMonster.boAllowDelete := true;
  end;
  CopiedList.Free;
  CopiedList := nil;
end;

function TMonster.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i, j, lifepercent, n: Integer;
  tx, ty, len, len2, key: word;
  Str: string;
  bo: TBasicObject;
  SubData: TSubData;
  ItemData: TItemData;
  MagicData: TMagicData;
  Monster: TMonster;
  tempuser: tuser;
  attacker: TEnmitydata;
  monsterx: TStringList;
  uUser: tuser;
  tempbuffall: TAllBuffDataMessage;
label
  abcde;

begin
  Result := PROC_FALSE;

  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);

  if Fboice then exit;
  if Result = PROC_TRUE then exit;
  if FboAllowDelete = true then exit;

  if LifeObjectState = los_die then exit;

  case Msg of
    FM_IAMHERE, FM_HIT, FM_BOW, FM_STRUCTED, FM_CHANGEFEATURE, FM_MOVE, FM_SHOW:
      begin
        if SenderInfo.id = BasicData.id then goto abcde; //是自己
        if SenderInfo.Feature.rnation = BasicData.Feature.rnation then goto abcde; //本国人
                //if (SenderInfo.Feature.rrace <> RACE_HUMAN) then goto abcde;    // 林籍捞搁 阁胶磐档 傍拜
        if SenderInfo.Feature.rHideState = hs_0 then goto abcde;
        if SenderInfo.boNotHit then goto abcde; //不接受攻击的 不主动

        case SenderInfo.Feature.rrace of
                   // RACE_NONE: goto abcde;
          RACE_HUMAN: ; //人(类)
                  //  RACE_ITEM: goto abcde;                                      //物品
          RACE_MONSTER: ; //怪物
          RACE_NPC: ; //NPC
                   // RACE_DYNAMICOBJECT: goto abcde;                             //动态 对象
                   // RACE_STATICITEM: goto abcde;
        else goto abcde;
        end;

                //发送者死亡
        if (SenderInfo.Feature.rFeatureState = wfs_die) then
        begin
          if SenderInfo.id = AttackSkill.CurNearViewObjId then AttackSkill.CurNearViewObjId := 0;
          if SenderInfo.id = AttackSkill.HateObjectID then AttackSkill.HateObjectID := 0;
          goto abcde;
        end;
                //自己和发送者距离
        len := GetLargeLength(BasicData.x, BasicData.y, SenderInfo.x, SenderInfo.y);
                //不在可视范围 消息终止
        if AttackSkill.ViewWidth < len then exit;
               // if AttackSkill.boViewHuman = FALSE then exit;
        bo := nil;
        if AttackSkill.CurNearViewObjId <> 0 then
                //获取 最近对象
          bo := TBasicObject(GetViewObjectById(AttackSkill.CurNearViewObjId));
        if bo <> nil then
        begin
                    //自己和最近对象 距离
          len2 := GetLargeLength(BasicData.x, BasicData.y, bo.Posx, bo.Posy);
                        //对比最近的和本次发送者距离
          if len2 > len then
          begin
            AttackSkill.CurNearViewObjId := SenderInfo.id;
                        //if BasicData.MasterId <> 0 then BocSay(format('测试消息：替换最近，旧目标 n:%s id:%d,[%d,%d]', [bo.BasicData.Name, bo.BasicData.id, bo.BasicData.x, bo.BasicData.y]));
                        //if BasicData.MasterId <> 0 then BocSay(format('测试消息：最近目标 n:%s id:%d,[%d,%d]', [SenderInfo.Name, SenderInfo.id, SenderInfo.x, SenderInfo.y]));
          end;
        end else
        begin
                    //没有目标使用当前目标
          AttackSkill.CurNearViewObjId := SenderInfo.id;
                    //if BasicData.MasterId <> 0 then BocSay(format('测试消息：最近目标 n:%s id:%d,[%d,%d]', [SenderInfo.Name, SenderInfo.id, SenderInfo.x, SenderInfo.y]));
        end;
      end;
    FM_HIDE:
      begin
        if SenderInfo.id = BasicData.id then goto abcde;
        if SenderInfo.id = AttackSkill.CurNearViewObjId then AttackSkill.CurNearViewObjId := 0;
        if SenderInfo.id = AttackSkill.HateObjectID then AttackSkill.HateObjectID := 0;
      end;
  end;
  abcde:

  case Msg of
    FM_IAMHERE:
      begin
        if SenderInfo.ID = BasicData.ID then exit;
        if SenderInfo.Feature.rRace = RACE_ITEM then
        begin
          if (LifeObjectState <> los_none) and (LifeObjectState <> los_attack) then exit;

                    // 荐笼贱
          if not HaveMagicClass.isHavePickMagic then exit;
          if not HaveMagicClass.RunHavePickMagic(BasicData.LifePercent, (SenderInfo.Name)) then exit;
          if HaveItemClass.HaveItemFreeCount > 0 then
          begin
            AttackSkill.SetSaveIDandPos(SenderInfo.ID, SenderInfo.X, SenderInfo.Y, los_eat);
            LifeObjectState := los_movework;
            exit;
          end;
        end;
      end;
    FM_SHOW:
      begin
      end;
    FM_ADDITEM:
      begin
        if LifeObjectState = los_die then exit;
        if SenderInfo.Feature.rrace = RACE_ITEM then
        begin
          Str := (aSubData.ItemData.rName);
          if HaveItemClass.AddHaveItem(Str, aSubData.ItemData.rCount, aSubData.ItemData.rColor) = true then
          begin
                        // SetWordString(SubData.SayString, IntToStr(aSubData.ItemData.rSoundDrop.rWavNumber));
            SubData.sound := aSubData.ItemData.rSoundDrop.rWavNumber;
            SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
            Result := PROC_TRUE;
          end;
        end;
      end;
    FM_CHANGEFEATURE:
      begin
        if SenderInfo.ID = BasicData.ID then exit;
        if SenderInfo.ID = BasicData.MasterId then
        begin
          if SenderInfo.Feature.rfeaturestate = wfs_die then
          begin
            if AttackSkill <> nil then AttackSkill.SetTargetId(0, true);
            CommandChangeCharState(wfs_die);
            exit;
          end;
        end;

        if SenderInfo.Feature.rnation = BasicData.Feature.rnation then exit;
                // if LifeObjectState = los_attack then exit;
        if SenderInfo.Feature.rRace <> RACE_HUMAN then exit;
        if SenderInfo.Feature.rfeaturestate <> wfs_die then exit;
        if HaveMagicClass.isHaveKillMagic then
        begin
          AttackSkill.SetSaveIDandPos(SenderInfo.ID, SenderInfo.X, SenderInfo.Y, los_kill);
          LifeObjectState := los_movework;
          exit;
        end;
      end;
    FM_GATHERVASSAL:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rnation = BasicData.Feature.rnation then exit;
        if AttackSkill.boVassal and (LifeObjectState = los_none) and (aSubData.VassalCount > 0) then
        begin
          aSubData.VassalCount := aSubData.VassalCount - 1;
          AttackSkill.SetTargetId(aSubData.TargetId, false);
        end;
      end;
    FM_BOW,
      FM_HIT,
      FM_MOVE:
      begin
        if SenderInfo.ID = BasicData.ID then exit;
                // 治疗技能   不能给自己治疗
        if HaveMagicClass.isHaveHealMagic then
        begin
          if HaveMagicClass.RunHaveHealMagic((SenderInfo.Name), SenderInfo.LifePercent, SubData) then
          begin
            key := GetNextDirection(BasicData.X, BasicData.Y, SenderInfo.X, SenderInfo.Y);
            if (key <> DR_DONTMOVE) and (key <> BasicData.dir) then
            begin
              CommandTurn(key);
            end;
            SubData.Motion := BasicData.Feature.rHitMotion;
            SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData);
            ShowEffect(6, lek_follow);
            SendLocalMessage(SenderInfo.ID, FM_HEAL, BasicData, SubData);
          end;
        end;

      end;

    FM_HEAL:
      begin
        ShowEffect(6, lek_follow);
        CurLife := CurLife + aSubData.HitData.ToHit;
        if CurLife > MaxLife then CurLife := MaxLife;

        if MaxLife <= 0 then BasicData.LifePercent := 0
        else BasicData.LifePercent := CurLife * 100 div MaxLife;
        SubData.Percent := BasicData.LifePercent;
        SendLocalMessage(NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
      end;

    FM_STRUCTED:
      begin
        if SenderInfo.id = BasicData.id then
        begin
          if CurLife <= 0 then CurLife := 0;
                    // 篮脚贱
          if HaveMagicClass.isHaveHideMagic then
          begin
            if BasicData.Feature.rHideState = hs_100 then
            begin
              if HaveMagicClass.RunHaveHideMagic(BasicData.LifePercent) then
              begin
                SetHideState(hs_0);
              end;
            end;
          end;
                    //召唤术

          if HaveMagicClass.isHaveCALLMagic then
          begin
            HaveMagicClass.RunHaveCALLMagic(100);
          end;
                    // 盒脚贱  分身术
          if HaveMagicClass.isHaveSameMagic then
          begin
            if (FboCopy = false) and (LifeObjectState = los_attack) then
            begin
              if HaveMagicClass.RunHaveSameMagic(BasicData.LifePercent, SubData) = true then
              begin
                               { if CopiedList = nil then                        //=NIL 创建
                                begin
                                    CopiedList := TList.Create;                 //创建
                                end;
                               // CopiedList.Clear; 20091023日取消，如果这里清除，分身就丢失了。

                                if BasicData.Feature.rrace = RACE_MONSTER then
                                begin
                                    for j := 0 to SubData.HitData.ToHit - 1 do
                                    begin
                                        Monster := TMonsterList(Manager.MonsterList).CopyMonster(Self);
                                        if Monster <> nil then
                                        begin
                                            Monster.CopyBoss := Self;
                                            Monster.LifeObjectState := LifeObjectState;
                                            CopiedList.Add(Monster);            //创建 分身完成 增加到列表
                                        end;
                                    end;
                                end;
                                }

                CopyMonster_add(SubData.HitData.ToHit);
              end;
            end;
          end;

                    // 矫距贱
          if HaveMagicClass.isHaveEatMagic then
          begin
            if HaveMagicClass.RunHaveEatMagic(BasicData.LifePercent, HaveItemClass, SubData) then
            begin
              CurLife := CurLife + SubData.HitData.ToHit;
              if CurLife > MaxLife then CurLife := MaxLife;

              if MaxLife <= 0 then BasicData.LifePercent := 0
              else BasicData.LifePercent := CurLife * 100 div MaxLife;
              SubData.Percent := BasicData.LifePercent;
              SendLocalMessage(NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
            end;
          end;

          if CurLife <= 0 then
          begin //怪物 死亡
                        // attacker := Bo.EnmityList.getMaxEnmityAttacker();
//            monsterx := tstringlist.Create; //20130621修改，提示指定怪物死亡
//            if FileExists(ExtractFilePath(ParamStr(0)) + '\Setting\monster.sdb')
//              then Monsterx.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\Setting\monster.sdb');
//            for i := 0 to Monsterx.Count - 1 do
//            begin
//              if BasicData.Name = Monsterx.Strings[i] then worldnoticemsg(BasicData.Name + ' 已死亡', $000080FF, 0);
//              Break;
//            end;
//            FreeAndNil(Monsterx);
            CopyMonster_AllDie;
            AttackSkill.SetTargetId(0, true);
            if (isUserId(aSubData.attacker)) //20090924只有人攻击才会掉
              or (aSubData.attackerMasterId <> 0)
                            //and (HaveMagicClass.isHaveSwapMagic = false)
            then
            begin
              HaveItemClass.DropItemGround(aSubData.attacker, aSubData.attackerMasterId, pSelfData.rKind); //死后掉东西

            end;

            if (BasicData.boNotAddExp = false) then
            begin
              if (pSelfData.rVirtue > 0) then //20090924 不获取经验 怪物
                if isUserId(aSubData.attacker) then
                begin
                  //通知 增加浩然值
                  //获取最大仇恨
                  attacker := EnmityList.getMaxEnmityAttacker();
                  uUser := UserList.GetUserPointer(attacker.rname);
                  if uUser <> nil then
                  begin
                    SubData.ExpData.Exp := pSelfData.rVirtue;
                    SubData.ExpData.ExpType := _et_MONSTER;
                    SubData.ExpData.LevelMax := pSelfData.rVirtueLevel;
                    SubData.ProcessionClass := nil;
                    uUser.SendLocalMessage(attacker.rAttacker, FM_ADDvirtueEXP, BasicData, SubData);
                    //GameSys.lua 杀怪触发
                    //uUser.ScriptMonsterDie(integer(self), BasicData.name); //怪物触发
                  end;

//                    SubData.ExpData.Exp := pSelfData.rVirtue;
//                    SubData.ExpData.ExpType := _et_MONSTER;
//                    SubData.ExpData.LevelMax := pSelfData.rVirtueLevel;
//                    SubData.ProcessionClass := nil;
//                    SendLocalMessage(aSubData.attacker, FM_ADDvirtueEXP, BasicData, SubData);

                end;
              if pSelfData.rExtraExp > 0 then //20090924 不获取经验 怪物
                if (aSubData.attackerMasterId <> 0) or isUserId(aSubData.attacker) then
                begin

                            //通知 增加杀死怪物 额外经验
                  SubData.ExpData.Exp := pSelfData.rExtraExp;

                  SubData.ExpData.LevelMax := 9999;
                  SubData.ProcessionClass := nil;
                  if aSubData.attackerMasterId <> 0 then
                  begin
                    SubData.ExpData.ExpType := _et_PET_MONSTER_die;
                    SendLocalMessage(aSubData.attackerMasterId, FM_ADDATTACKEXP, BasicData, SubData)
                  end
                  else
                  begin
                    SubData.ExpData.ExpType := _et_MONSTER_die;
                    SendLocalMessage(aSubData.attacker, FM_ADDATTACKEXP, BasicData, SubData);
                  end;
                end;

            end;

            exit;

          end;
          if AttackSkill.boAttack = false then exit;

          if AttackSkill.boChangeTarget then
          begin
            Bo := GetViewObjectByID(AttackSkill.GetTargetID);
            if Bo <> nil then
            begin
              len := GetLargeLength(BasicData.x, BasicData.y, Bo.Posx, Bo.Posy);
              if len > 1 then
              begin
                AttackSkill.SetTargetId(aSubData.attacker, true);
              end;
            end;
          end;
          if (aSubData.attacker <> BasicData.MasterId)
            and (isUserId(aSubData.attacker) or (isUserId(aSubData.attackerMasterId))) then
            AttackSkill.HateObjectID := aSubData.attacker;
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
        BasicData.LifePercent := 0;

        AttackSkill.SetTargetId(0, true);
             //   if HaveMagicClass.isHaveSwapMagic = false then
        begin //被GM杀死
          HaveItemClass.DropItemGround(SenderInfo.id, 0, pSelfData.rKind); //死后掉东西
        end;

        CommandChangeCharState(wfs_die);
        //CallScriptFunction('OnDie', [integer(SenderInfo.p), integer(self), SenderInfo.Feature.rrace]);
        CallLuaScriptFunction('OnDie', [integer(SenderInfo.p), integer(self), SenderInfo.Feature.rrace]);
        //2015年10月17日 10:20:03修改添加是否玩家判断
        //if isUserId(aSubData.attacker) then tuser(SenderInfo.p).ScriptMonsterDie(integer(self), BasicData.name); //怪物触发
      end;
    FM_Drag:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if BasicData.Feature.rfeaturestate = wfs_die then exit;
        if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
        //CallScriptFunction('OnDragItem', [integer(SenderInfo.p), integer(self), aSubData.TargetId]);
        CallLuaScriptFunction('OnDragItem', [integer(SenderInfo.p), integer(self), aSubData.TargetId]);
      end;
    FM_SAY:
      begin
      end;
    FM_GETALLBUFF:
      begin
        FillChar(tempbuffall, SizeOf(TAllBuffDataMessage), 0);
        GetAllBuffer(tempbuffall);
        if tempbuffall.rbuffcount > 0 then
          Tuser(SenderInfo.P).SendClass.SendAllBuffData(tempbuffall);
      end;
  end;
end;

procedure TMonster.Update(CurTick: integer);
var
  i: Integer;
  key: Word;
  boFlag: Boolean;
  SubData: TSubData;
  BO: TLifeObject;
  pBasicObject: TBasicObject;
  aname: string;
begin

  inherited UpDate(CurTick);
  if (BasicData.Feature.rfeaturestate = wfs_die) and (LifeObjectState <> los_die) then
  begin
    LifeObjectState := los_die;
  end;

  if LifeBuffer <> 0 then
  with TLifeDataList(LifeBuffer) do
  begin
    Update(curtick);
    if rboupdate then
    begin
      rboupdate := false;
      Self.SetLifeData;
      SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
    end;
  end;
  if MultiplyBuffer <> 0 then
  with TLifeDataList(MultiplyBuffer) do
  begin
    Update(curtick);
    if rboupdate then
    begin
      rboupdate := false;
      Self.SetLifeData;
      SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
    end;
  end;

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

  if BasicData.boMoveKill then
  begin
   // if AddDelayState then exit;

    case LifeObjectState of
      los_init:
        begin
         // if Start = false then
          if Regen = false then
          begin
           // EndProcess;
            frmMain.WriteLogInfo(format('TMonster.Regen (%s,%d,%d,%d) failed los_init', [BasicData.Name, ServerID, BasicData.X, BasicData.Y]));
          end;
          //Regen; //Start;
          exit;
        end;
      los_die:
        begin
          if Fboice then exit;
          if FboRegisted then EndProcess;
          if CurTick > DiedTick + RegenInterval then
          begin
            if FboAllowDelete = false then
            begin
              if Regen = false then
              begin
               // EndProcess;
                    //刷新失败提高刷新时间
               // DiedTick := mmAnsTick;
               // if RegenInterval <= 0 then RegenInterval := 500;
                frmMain.WriteLogInfo(format('TMonster.Regen (%s,%d,%d,%d) failed RegenInterval', [BasicData.Name, ServerID, BasicData.X, BasicData.Y]));
              end;
            end;
           // Regen; //复活
          end;

        end;
    else
      begin
        if Fboice then exit;
        if WalkTick + WalkSpeed < CurTick then //设置移动 速度的2倍时间，移动1次
        begin
          WalkTick := CurTick;
          if GotoXyStand_SET(BasicData.x + pSelfData^.rxControl, BasicData.y + pSelfData^.rycontrol) < 0 then
          begin
            CommandChangeCharState(wfs_die);
          end;
        end;
      end;
    end;
    exit;
  end;

  case LifeObjectState of
    los_init:
      begin
         // if Start = false then
        if Regen = false then
        begin
          //EndProcess;
          frmMain.WriteLogInfo(format('TMonster.Regen (%s,%d,%d,%d) failed los_init', [BasicData.Name, ServerID, BasicData.X, BasicData.Y]));
        end;
          //Regen; //Start;
        exit;
      end;
    los_die:
      begin
        if Fboice then
        begin

          exit;
        end;
                //死亡
                //变身 技能===================================================
        if not BasicData.boHaveSwap then
          if CurTick > DiedTick + 200 then
          begin
            if HaveMagicClass.isHaveSwapMagic then
            begin
              if HaveMagicClass.RunHaveSwapMagic(BasicData.LifePercent, aname, boFlag) = true then
              begin
                if boFlag then
                begin
                  InitialEx(aname);
                  SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                end else
                begin
                  InitialEx(aname);
                                    //LifeObjectState := los_die;
                  CommandChangeCharState(wfs_die);
                  BasicData.boHaveSwap := true;
                end;
              end;
              exit;
            end;
          end;

                //复活 ===================================================
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
              if RegenInterval >= 0 then
                if (CurTick > DiedTick + RegenInterval) then
                begin
                  if Regen = false then
                  begin
                    //刷新失败提高刷新时间
                    //DiedTick := mmAnsTick;
                    //if RegenInterval <= 0 then RegenInterval := 500;
                    //EndProcess;
                    frmMain.WriteLogInfo(format('TMonster.Regen (%s,%d,%d,%d) failed RegenInterval', [BasicData.Name, ServerID, BasicData.X, BasicData.Y]));
                  end;
               // Regen; //复活

                end;
            end;
            exit;
          end;
        end;
        //收尸体===================================================
        if CurTick > DiedTick + 800 then
        begin
          if boDieDelete then
          begin
            FboAllowDelete := true;
            exit;
          end;
          if Manager.RegenInterval > 0 then
          begin
            FboAllowDelete := true;
            exit;
          end;
          if FboRegisted then EndProcess;
        end;
      end;
    los_none: //空闲
      begin //说明：设置攻击目标、逃跑攻击目标、移动位置、自己移动。
        if Fboice then exit;
        if AttackSkill <> nil then
        begin
          if pUSER <> nil then
          begin
            AttackSkill.TargetX := tuser(pUSER).BasicData.Nx;
            AttackSkill.TargetY := tuser(pUSER).BasicData.Ny;
          end;
          AttackSkill.ProcessNone(CurTick);
        end;
      end;
    los_escape: //逃走
      begin
        if Fboice then exit; //说明：逃跑20秒；恢复到空闲状态。
        if AttackSkill <> nil then AttackSkill.ProcessEscape(CurTick);
      end;
    los_attack: //攻击
      begin
        if Fboice then exit; //说明：近身、远程攻击目标到死亡或者消失
        if AttackSkill <> nil then
        begin
          boFlag := AttackSkill.ProcessAttack(CurTick, Self);

                    {if (boFlag = false) and (FboCopy = false) then
                    begin
                        if CopiedList <> nil then                               //主人 死亡 分身全部死亡
                        begin                                                   //分身 复制对象，在主死亡后销毁
                            for i := 0 to CopiedList.Count - 1 do
                            begin
                                BO := TLifeObject(CopiedList[i]);
                                BO.boAllowDelete := true;
                            end;
                        end;
                    end;
                    }
        end;
      end;
    los_moveattack: //移动 攻击
      begin
        if Fboice then exit; //说明：发现目标在可视范围， 进入攻击状态；
        if AttackSkill <> nil then AttackSkill.ProcessMoveAttack(CurTick);
      end;
    los_deadattack: //死攻击
      begin
        if Fboice then exit; //说明：全服琐定追杀目标，目标不在同1地图或者死亡。自己销毁。
        if AttackSkill <> nil then AttackSkill.ProcessDeadAttack(CurTick);
      end;
    los_movework: //移动 工作
      begin
        if Fboice then exit; //说明：移动到目标位置，转入预工作
        if AttackSkill <> nil then AttackSkill.ProcessMoveWork(CurTick);
      end;
    los_eat: //吃  物品
      begin
        if Fboice then exit; //说明：相当与拾取物品到背包
        if AttackSkill = nil then
        begin
          LifeObjectState := los_none;
          exit;
        end;
        if CurTick < AttackSkill.ArrivalTick + 100 then exit;

        pBasicObject := TBasicObject(GetViewObjectByID(AttackSkill.GetSaveID));
        if pBasicObject <> nil then
        begin
          if pBasicObject.BasicData.Feature.rRace = RACE_ITEM then
          begin
            Phone.SendMessage(pBasicObject.BasicData.ID, FM_PICKUP, BasicData, SubData);
          end;
        end;
        LifeObjectState := los_none;
        if AttackSkill.GetTargetID <> 0 then LifeObjectState := los_attack;
      end;
    los_kill: //怪物 爆掉人物品
      begin
        if Fboice then exit; //说明：怪物的5武功在杀死人后，可以取掉1件物品。
        if AttackSkill = nil then
        begin
          LifeObjectState := los_none;
          exit;
        end;
        if CurTick < AttackSkill.ArrivalTick + 100 then exit;

        pBasicObject := TBasicObject(GetViewObjectByID(AttackSkill.GetSaveID));
        if pBasicObject <> nil then
        begin
          if pBasicObject.BasicData.Feature.rRace = RACE_HUMAN then
          begin
            if pBasicObject.BasicData.Feature.rFeatureState = wfs_die then
            begin
              key := GetNextDirection(BasicData.X, BasicData.Y, AttackSkill.TargetX, AttackSkill.TargetY);
              if (key <> DR_DONTMOVE) and (key <> BasicData.dir) then
              begin
                CommandTurn(key);
              end;
              Phone.SendMessage(pBasicObject.BasicData.ID, FM_KILL, BasicData, SubData);
            end;
          end;
        end;
        LifeObjectState := los_none;
        if AttackSkill.GetTargetID <> 0 then LifeObjectState := los_attack;
      end;
    los_move: //移动
      begin
        if Fboice then exit; //说明：到达目标设置到达时间（TargetArrivalTick）
        if AttackSkill <> nil then
        begin
          if AttackSkill.ProcessMove(CurTick) = false then exit;
        end;

        LifeObjectState := los_none;
      end;
  end;

  if BasicData.Feature.rfeaturestate <> wfs_die then
    if pSelfData.rboUPdateTime and (CurTick >= UpdateTcik + 100) then
    begin
      UpdateTcik := CurTick;
      CallLuaScriptFunction('OnUpdate', [integer(self), CurTick]);
    end;
end;

function TMonster.GetAttackSkill: TAttackSkill;
begin
  if AttackSkill = nil then
  begin
    AttackSkill := TAttackSkill.Create(Self);
    AttackSkill.TargetX := CreateX - 3 + Random(6);
    AttackSkill.TargetY := CreateY - 3 + Random(6);
  end;
  Result := AttackSkill;
end;

procedure TMonster.SetAttackObj(aid: integer);
begin
  if BasicData.Feature.rfeaturestate = wfs_die then exit;
  if AttackSkill = nil then exit;
  if AttackSkill.GetTargetID = aid then exit;
  AttackSkill.SetTargetID(aid, true);
    //BocSay('测试消息：主人设置攻击目标：' + inttostr(aid));
end;

procedure TMonster.SetAttackSkill(aAttackSkill: TAttackSkill);
begin
  if AttackSkill <> nil then
  begin
        //不是复制 品 释放
    if FboCopy = false then
    begin
      AttackSkill.Free;
    end;
  end;

  AttackSkill := aAttackSkill;
end;

function TMonster.AddBuffer(aid: Integer; aname: string; aLifeData: TLifeData; atime, asharp, aeffect: Integer; adesc: string): boolean;
begin
  if MultiplyBuffer <> 0 then
  if TLifeDataList(MultiplyBuffer).get(aid) <> nil then
  begin
    Result := False;
    exit;
  end;
  if LifeBuffer = 0 then
  begin
    LifeBuffer := Integer(TLifeDataList.Create(Self));
    with TLifeDataList(LifeBuffer) do
    begin
      ONadd := OnAddBuffer;
      ONdel := OnDelBuffer;
      ONUPdate := OnUPdateBuffer;
      ONClear := OnClearBuffer;
    end;
  end;
  Result := TLifeDataList(LifeBuffer).AddScript(aid, aname, aLifeData, atime, asharp, aeffect, adesc);
end;

function TMonster.GetBuffer(aid: Integer): Integer;
var
  pp: pTLifeDataListdata;
begin
  Result := -1;
  if LifeBuffer <> 0 then
  begin
    pp := TLifeDataList(LifeBuffer).get(aid);
    if pp <> nil then
    begin
      Result := pp.rendtime;
      exit;
    end;
  end;
end;

function TMonster.AddMultiplyBuffer(aid: Integer; aname: string; aLifeData: TLifeData; atime, asharp, aeffect: Integer; adesc: string): boolean;
begin
  if LifeBuffer <> 0 then
  if TLifeDataList(LifeBuffer).get(aid) <> nil then
  begin
    Result := False;
    exit;
  end;
  if MultiplyBuffer = 0 then
  begin
    MultiplyBuffer := Integer(TLifeDataList.Create(Self));
    with TLifeDataList(MultiplyBuffer) do
    begin
      ONadd := OnAddBuffer;
      ONdel := OnDelBuffer;
      ONUPdate := OnUPdateBuffer;
      ONClear := OnClearBuffer;
    end;
  end;
  Result := TLifeDataList(MultiplyBuffer).AddScript(aid, aname, aLifeData, atime, asharp, aeffect, adesc);
end;

function TMonster.GetMultiplyBuffer(aid: Integer): Integer;
var
  pp: pTLifeDataListdata;
begin
  Result := -1;
  if MultiplyBuffer <> 0 then
  begin
    pp := TLifeDataList(MultiplyBuffer).get(aid);
    if pp <> nil then
    begin
      Result := pp.rendtime;
      exit;
    end;
  end;
end;

procedure TMonster.OnAddBuffer(var temp: TLifeDataListdata);
var
  aSubData: TSubData;
begin
  //SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, aSubData);
end;

procedure TMonster.OnDelBuffer(var temp: TLifeDataListdata);
var
  aSubData: TSubData;
begin
  //SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, aSubData);
end;

procedure TMonster.OnUPdateBuffer(var temp: TLifeDataListdata);
var
  aSubData: TSubData;
begin
  //SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, aSubData);
end;

procedure TMonster.OnClearBuffer();
var
  aSubData: TSubData;
begin
  //SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, aSubData);
end;

procedure TMonster.GetAllBuffer(var tempall: TAllBuffDataMessage);
var
  i, n: integer;
  pp: pTLifeDataListdata;
begin
  with tempall do
  begin
    rmsg := SM_ALLBUFF;
    rid := BasicData.id;
    if MaxLife <= 0 then BasicData.LifePercent := 0
    else BasicData.LifePercent := CurLife * 100 div MaxLife;
    rstruct := BasicData.LifePercent;
    n := Length(rBuffData);
    rbuffcount := 0;
    if LifeBuffer <> 0 then
      rbuffcount := TLifeDataList(LifeBuffer).Count;
    if MultiplyBuffer <> 0 then
      rbuffcount := rbuffcount + TLifeDataList(MultiplyBuffer).Count;
    if rbuffcount > n then
      rbuffcount := n;
    n := 0;
    if LifeBuffer <> 0 then
      for i := 0 to TLifeDataList(LifeBuffer).Count - 1 do
      begin
        Inc(n);
        if n > rbuffcount then break;
        pp := TLifeDataList(LifeBuffer).DataList.Items[i];
        with rBuffData[n - 1] do
        begin
          rid := pp^.rid;
          rshape := pp^.rsharp;
          rdesc := pp^.rdesc;
        end;
      end;
    if MultiplyBuffer <> 0 then
      for i := 0 to TLifeDataList(MultiplyBuffer).Count - 1 do
      begin
        Inc(n);
        if n > rbuffcount then break;
        pp := TLifeDataList(MultiplyBuffer).DataList.Items[i];
        with rBuffData[n - 1] do
        begin
          rid := pp^.rid;
          rshape := pp^.rsharp;
          rdesc := pp^.rdesc;
        end;
      end;
  end;
end;

function TMonster.SetAttackMagic(AMagicName: string; Aid, AiMode, Amskill: integer): Boolean;
var
  MagicData: TMagicData;
begin
  if (AiMode < 0) or (AiMode > 2) then Exit;

  if AMagicName = '' then
  begin
    AiMode := 0;
    AMagicName := FMagicName;
    MagicData := pSelfData^.rAttackMagic;
  end
  else
    MagicClass.GetMagicData(AMagicName, MagicData, Amskill);
  begin
    if AttackSkill = nil then Exit;
    if Aid <> 0 then
      AttackSkill.SetTargetID(Aid, true);
    AttackSkill.SetAttackMagic(MagicData);
    AttackSkill.FAiMode := AiMode;
    BasicData.HitTargetsType := _htt_All;
  end;
end;

function TMonster.SetHaveMagic(AMagicName: string): Boolean;
begin
  HaveMagicClass.clear;
  HaveMagicClass.Init(AMagicName);
end;

function TMonster.SetHaveMagicExt(AMagicName: string; aPara: TMagicParamData; aid: integer): Boolean;
begin
  HaveMagicClass.clear;
  HaveMagicClass.InitExt(AMagicName, aPara, aid);
end;

////////////////////////////////////////////////////
//
//             ===  MonsterList  ===
//
////////////////////////////////////////////////////

constructor TMonsterList.Create(aManager: TManager);
begin
  Manager := aManager;

  CurProcessPos := 0;
    // AnsList := TAnsList.Create (cnt, AllocFunction, FreeFunction);
    // AnsList.MaxUnUsedCount := 10000;
  DataList := TList.Create;

//    LoadFromFile;
end;

destructor TMonsterList.Destroy;
begin
  Clear;
  DAtaList.Free;

  inherited destroy;
end;

procedure TMonsterList.Regen;
var
  i: Integer;
  Monster: TMonster;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    Monster.Regen;
  end;
end;


procedure TMonsterList.Clear;
var
  i: Integer;
  Monster: TMonster;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    Monster.EndProcess;
    Monster.Free;
  end;
  DataList.Clear;
end;

 //导出，怪物资料，方便制作资料。



function TMonsterList.getHelpHtm: string;
var
  i, j: Integer;
  Monster: TMonster;
  templs: tstringlist;
  str, aname, axy, aitemstr: string;
  MonsterHtmListClass: TMonsterHtmListClass;
  p: TMonsterHtmClass;

begin
{

<tr>
    <td rowspan="2" align="center" bgcolor="#F0F0F0" scope="row">长城以南</td>
    <td align="center" bgcolor="#F0F0F0">怪物1</td>
    <td bgcolor="#F0F0F0"><p>(200;200)(200;200)<br>
      (200;200)(200;200)<br>
      (200;200)(200;200)</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p>
      <p>&nbsp;</p></td>
    <td height="22" bgcolor="#F0F0F0"><p>asdfasdf</p>
    <p>asdf</p>
    <p>asdf</p>
    <p>asdf</p>
    <p>asdf</p>
    <p>asdf</p>
    <p>&nbsp;</p></td>
  </tr>
  <tr>
    <td align="center" bgcolor="#F0F0F0">怪2</td>
    <td bgcolor="#F0F0F0">(200;200)(200;200)<br>
      (200;200)(200;200)<br>
      (200;200)(200;200)</td>
    <td height="22" bgcolor="#F0F0F0">&nbsp;</td>
  </tr>
}
  result := '';
  templs := tstringlist.Create;
  MonsterHtmListClass := TMonsterHtmListClass.Create;

  try


    templs.Clear;
    for i := 0 to DataList.Count - 1 do
    begin
      Monster := DataList.Items[i];
      MonsterHtmListClass.addMonster(Monster);
    end;
    MonsterHtmListClass.Sort;
    for i := 0 to MonsterHtmListClass.dataList.Count - 1 do
    begin
      p := MonsterHtmListClass.dataList.Items[i];
      templs.Add('<tr>');
      if i = 0 then templs.Add('<td rowspan="' + inttostr(MonsterHtmListClass.dataList.Count) + '" align="center" bgcolor="#F0F0F0" scope="row">' + Manager.Title + '</td>');

      templs.Add('<td align="center" bgcolor="#F0F0F0">' + p.fVname + '</td>');
      templs.Add('<td bgcolor="#F0F0F0"><p>' + p.getList + ' </p></td>');
      templs.Add('<td height="22" bgcolor="#F0F0F0"><p>' + p.fdorpItem + '</p></td>');
      templs.Add('</tr>');
    end;

    result := templs.Text;
  finally
    templs.free;
    MonsterHtmListClass.free;

  end;
end;

procedure TMonsterList.ReLoad;
var
  i, j, n: integer;
  pd: PTCreateMonsterData;
begin
  Clear;
  if Manager.MonsterCreateClass_p = nil then exit;
  n := Manager.MonsterCreateClass_p.getCount;
  for i := 0 to n - 1 do
  begin
    pd := Manager.MonsterCreateClass_p.get(i);
    if pd <> nil then
    begin
      for j := 0 to pd^.Count - 1 do
      begin
        AddMonster(pd^.mName, pd^.x, pd^.y, pd^.Width, pd^.Member, pd^.rnation, pd^.rmappathid, false);
      end;
    end;
  end;
end;
{var
    i, j: integer;
    pd: PTCreateMonsterData;
    FileName: string;
    CreateMonsterList: TList;
begin
    Clear;

    FileName := format('.\Setting\CreateMonster%d.SDB', [Manager.ServerID]);
    if not FileExists(FileName) then exit;

    CreateMonsterList := TList.Create;
    LoadCreateMonster(FileName, CreateMonsterList);
    for i := 0 to CreateMonsterList.Count - 1 do
    begin
        pd := CreateMonsterList.Items[i];
        if pd <> nil then
        begin
            for j := 0 to pd^.Count - 1 do
            begin
                AddMonster(pd^.mName, pd^.x, pd^.y, pd^.Width, pd^.Member, pd^.rnation, pd^.rmappathid);
            end;
        end;
    end;
    for i := 0 to CreateMonsterList.Count - 1 do
    begin
        Dispose(CreateMonsterList[i]);
    end;

    CreateMonsterList.Clear;
    CreateMonsterList.Free;
end;
}

function TMonsterList.GetCount: integer;
begin
  Result := DataList.Count;
end;


//唯一 正常创建怪物

procedure TMonsterList.AddMonster(aMonsterName: string; ax, ay, aw: integer; aMemberStr: string; anation, amappathid: integer; aboDieDelete: boolean);
var
  Monster, Member: TMonster;
  str, MemberName, MemberCount: string;
  i, Count: Integer;
  AttackSkill,
    tmpAttackSkill: TAttackSkill;
begin
  Monster := TMonster.Create;
  if Monster <> nil then
  begin
    Monster.SetManagerClass(Manager);
    Monster.Initial(aMonsterName, ax, ay, aw, anation, amappathid, _htt_nation);
    DataList.Add(Monster);
    Monster.boDieDelete := aboDieDelete;
        //附带怪物
    if aMemberStr <> '' then
    begin
            //创建 组
      AttackSkill := Monster.GetAttackSkill;
      AttackSkill.GroupCreate;

      str := aMemberStr;
      while str <> '' do
      begin
        str := GetValidStr3(str, MemberName, ':');
        if MemberName = '' then break;
        str := GetValidStr3(str, MemberCount, ':');
        if MemberCount = '' then break;
        Count := _StrToInt(MemberCount);

        for i := 0 to Count - 1 do
        begin
          Member := nil;
          Member := TMonster.Create;
          if Member <> nil then
          begin
            Member.SetManagerClass(Manager);
            Member.Initial(MemberName, ax, ay, aw, anation, 0, _htt_nation);
            DataList.Add(Member);
                        //加入 到主，组
            AttackSkill.GroupAdd(Member);
            tmpAttackSkill := Member.GetAttackSkill;
            if tmpAttackSkill <> nil then tmpAttackSkill.GroupSetBoss(Monster); //创建 怪物
          end;
        end;
      end;
    end;
  end;
end;


function TMonsterList.CopyMonster(aMonster: TMonster): TMonster;
var
  Monster: TMonster;

begin
  Result := nil;

  Monster := TMonster.Create;
  if Monster <> nil then
  begin
    Monster.SetManagerClass(Manager);
    Monster.SetAttackSkill(aMonster.AttackSkill);

    Monster.FboCopy := true;
    Monster.Initial(
      aMonster.MonsterName,
      aMonster.BasicData.x,
      aMonster.BasicData.y,
      4,
      aMonster.BasicData.Feature.rnation, aMonster.BasicData.MapPathID, _htt_nation
      );
      //  if Monster.Start = false then
    if Monster.Regen = false then
    begin
      frmMain.WriteLogInfo(format('TMonster.Regen (%s,%d,%d,%d) failed CallMonster', [aMonster.MonsterName, Manager.ServerID, aMonster.BasicData.x, aMonster.BasicData.y]));
     // Monster.EndProcess;
      Monster.Free;
      exit;
    end;

    DataList.Add(Monster);

    Result := Monster;
  end;
end;

procedure TMonsterList.iceMonster(aMonsterName: string; astate: boolean);
var
  i: Integer;
  Monster: TMonster;
begin

  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if (aMonsterName = '') or (Monster.MonsterName = aMonsterName) then
    begin
      Monster.Fboice := astate;
    end;
  end;
end;

procedure TMonsterList.RegenMonster(aMonsterName: string);
var
  i: Integer;
  Monster: TMonster;
begin

  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if (aMonsterName = '') or (Monster.MonsterName = aMonsterName) then
    begin
      if Monster.Regen = false then
      begin
           // EndProcess;
        frmMain.WriteLogInfo(format('TMonster.Regen (%s,%d,%d,%d) failed los_init', [Monster.BasicData.Name, Monster.ServerID, Monster.BasicData.X, Monster.BasicData.Y]));
      end;
    end;
  end;    
end;


procedure TMonsterList.SayDelayAddMonster(aMonsterName, asay: string; atime: integer);
var
  i: Integer;
  Monster: TMonster;
begin

  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if (aMonsterName = '') or (Monster.MonsterName = aMonsterName) then
    begin
      Monster.SayDelayAdd(asay, atime);
    end;
  end;
end;

procedure TMonsterList.boNotHitMonster(aMonsterName: string; astate: boolean);
var
  i: Integer;
  Monster: TMonster;
begin

  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if (aMonsterName = '') or (Monster.MonsterName = aMonsterName) then
    begin
      Monster.BasicData.boNotHit := astate;
    end;
  end;
end;

procedure TMonsterList.NotMoveMonster(aMonsterName: string; atime: integer);
var
  i: Integer;
  Monster: TMonster;
begin

  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if (aMonsterName = '') or (Monster.MonsterName = aMonsterName) then
    begin
      Monster.LockNotMove(atime);
    end;
  end;
end;

function TMonsterList.FindMonster(aMonsterName: string): Integer;
var
  i, iCount: Integer;
  Monster: TMonster;
begin
  Result := 0;

  iCount := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if Monster.MonsterName = aMonsterName then
          //  if Monster.LifeObjectState <> los_die then
    begin
      Inc(iCount);
    end;
  end;

  Result := iCount;
end;

function TMonsterList.DeleteMonster(aMonsterName: string): Boolean;
var
  i, iCount: Integer;
  Monster: TMonster;
begin
  Result := false;

  iCount := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if Monster.MonsterName = aMonsterName then
    begin
      Monster.FboAllowDelete := true;
      Inc(iCount);
    end;
  end;
  if iCount > 0 then Result := true;
end;
//召唤 怪物，（创建怪物）
//动态物品可召唤怪物
{
function TMonsterList.CallMonster(aMonsterName: string; ax, ay, aw: integer; aName: string): TMonster;
var
    Monster: TMonster;
    AttackSkill: TAttackSkill;
begin
    Result := nil;

    Monster := TMonster.Create;
    if Monster <> nil then
    begin
        Monster.SetManagerClass(Manager);
        Monster.Initial(aMonsterName, ax, ay, aw, 0, 0, _htt_nation);
        Monster.InitialEx(aMonsterName);
        if Monster.Start = false then
        begin
            Monster.Free;
            exit;
        end;
        AttackSkill := Monster.GetAttackSkill;
        if AttackSkill <> nil then
        begin
            AttackSkill.SetDeadAttackName(aName);
        end;
        DataList.Add(Monster);

        Result := Monster;
    end;
end;
}

function TMonsterList.CallMonster(aMonsterName: string; ax, ay, aw: integer; aName: string): TMonster;
var
  Monster: TMonster;
  AttackSkill: TAttackSkill;
begin
  Result := nil;

  Monster := TMonster.Create;
  if Monster <> nil then
  begin
    Monster.SetManagerClass(Manager);
    Monster.Initial(aMonsterName, ax, ay, aw, 0, 0, _htt_nation);
    Monster.InitialEx(aMonsterName);
    //if Monster.Start = false then
    if Monster.Regen = false then
    begin
      frmMain.WriteLogInfo(format('TMonster.Regen (%s,%d,%d,%d) failed CallMonster', [aMonsterName, Manager.ServerID, ax, ay]));
      //Monster.EndProcess;
      Monster.Free;
      exit;
    end;
       { AttackSkill := Monster.GetAttackSkill;
        if AttackSkill <> nil then
        begin
            AttackSkill.SetDeadAttackName(aName);
        end;}
    DataList.Add(Monster);

    Result := Monster;
  end;
end;

function TMonsterList.GetMonsterByName(aName: string): TMonster;
var
  i: Integer;
  Monster: TMonster;
begin
  Result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if Monster.MonsterName = aName then
    begin
      if Monster.BasicData.Feature.rfeaturestate = wfs_normal then
      begin
        Result := Monster;
        exit;
      end;
    end;
  end;
end;


procedure TMonsterList.Update(CurTick: integer);
var
  i, iCount: integer;
  Monster: TMonster;
begin
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
    Monster := DataList[CurProcessPos];
    if Monster.FboAllowDelete = true then
    begin
      Monster.EndProcess;
      Monster.Free;
      DataList.Delete(CurProcessPos);
    end else
    begin
      try
        Monster.Update(CurTick);
        Inc(CurProcessPos);
      except
        Monster.FBoAllowDelete := true;
        frmMain.WriteLogInfo(format('TMonsterList.Update (%s) failed', [Monster.MonsterName]));
      end;
    end;
  end;

end;

procedure TMonsterList.ComeOn(aName: string; X, Y: Word);
var
  i: Integer;
  Monster: TMonster;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if (Monster.BasicData.Name) = aName then
    begin
      if Monster.FboAllowDelete = true then continue;
      if Monster.AttackSkill = nil then continue;
      Monster.AttackSkill.SetSaveIDandPos(0, X, Y, los_none);
      Monster.LifeObjectState := los_move;
    end;
  end;
end;

function TMonsterList.getDieCount(aname: string): integer;
var
  i: Integer;
  Monster: TMonster;
begin
  result := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if Monster = nil then Continue;
    if aname <> '' then if Monster.BasicData.Name <> aname then Continue;
    if Monster.LifeObjectState <> los_die then Continue;
    inc(result);
  end;
end;

function TMonsterList.getliveCount(aname: string): integer;
var
  i: Integer;
  Monster: TMonster;
begin
  result := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    Monster := DataList.Items[i];
    if Monster = nil then Continue;
    if aname <> '' then if Monster.BasicData.Name <> aname then Continue;
    if Monster.LifeObjectState = los_die then Continue;
    if Monster.BasicData.MasterId <> 0 then Continue;
    inc(result);
  end;
end;





{ TMonsterHtmListClass }

procedure TMonsterHtmListClass.add(aname: string);
var
  p: TMonsterHtmClass;
begin
  if get(aname) <> nil then exit;
  p := TMonsterHtmClass.Create;
  p.fname := aname;
  dataList.Add(p);
  fnameindex.Insert(aname, p);
end;

procedure TMonsterHtmListClass.addMonster(aMonster: TMonster);
var
  p: TMonsterHtmClass;
  str: string;
  ax, ay: integer;
begin
  str := aMonster.BasicData.Name;
  p := get(str);
  if p = nil then
  begin
    add(str);
    p := get(str);
    if p <> nil then
    begin
      p.fVname := aMonster.BasicData.ViewName;
      p.fdorpItem := aMonster.GetCsvDorpItem;
      ax := aMonster.GetCreatedX;
      ay := aMonster.GetCreatedY;

      p.add(ax, ay);
      p.flevel := aMonster.LifeData.damageBody;
    end;
    exit;
  end;

  ax := aMonster.GetCreatedX;
  ay := aMonster.GetCreatedY;
    //20范围内有了 不重复增加
  if p.getMin(ax, ay) < 20 then exit;
  p.add(ax, ay);
end;

procedure TMonsterHtmListClass.Clear;
var
  p: TMonsterHtmClass;
  i: integer;
begin
  for i := 0 to dataList.Count - 1 do
  begin
    p := dataList.Items[i];
    p.Free;
  end;
  dataList.Clear;
  fnameindex.Clear;
end;

constructor TMonsterHtmListClass.Create;
begin
  dataList := TList.Create;
  fnameindex := TStringKeyClass.Create;
end;

destructor TMonsterHtmListClass.Destroy;
begin
  Clear;
  dataList.Free;
  fnameindex.Free;
  inherited;
end;

function TMonsterHtmListClass.get(aname: string): TMonsterHtmClass;
begin
  result := fnameindex.Select(aname);

end;

function MonsterHtmClassSort(Item1, Item2: Pointer): Integer;
begin
  result := 0;
  if TMonsterHtmClass(Item1).flevel > TMonsterHtmClass(Item2).flevel then
    result := 1
  else if TMonsterHtmClass(Item1).flevel < TMonsterHtmClass(Item2).flevel then
    result := -1;
end;

procedure TMonsterHtmListClass.Sort;
begin
  dataList.Sort(MonsterHtmClassSort);
end;

{ TMonsterHtmClass }

procedure TMonsterHtmClass.add(ax, ay: integer);
var
  p: ^TPoint;
begin
  new(p);
  p.X := ax;
  p.y := ay;
  dataList.Add(p);
end;

procedure TMonsterHtmClass.Clear;
var
  p: ^TPoint;
  i: integer;
begin
  for i := 0 to dataList.Count - 1 do
  begin
    p := dataList.Items[i];
    dispose(p);
  end;
  dataList.Clear;
end;

constructor TMonsterHtmClass.Create;
begin
  dataList := TList.Create;
end;

destructor TMonsterHtmClass.Destroy;
begin
  Clear;
  dataList.Free;
  inherited;
end;

function TMonsterHtmClass.getList: string;
var
  p, p2: ^TPoint;
  i, j, ax, ay, n, min_, min_j, aw: integer;
begin
  result := '';
  aw := 1;
  j := 0;
  while dataList.Count > 8 do
  begin
    if j > dataList.Count - 1 then j := 0;
    p := dataList.Items[j];
    i := j + 1;
    while (i < dataList.Count) and (dataList.Count > 8) do
    begin
      p2 := dataList.Items[i];
      n := GetLargeLength(p.X, p.Y, p2.X, p2.Y);
      if n <= aw then
      begin
              //删除
        dispose(p2);
        dataList.Delete(i);
      end else inc(i);
    end;
    inc(j);
    inc(aw);
  end;


  for i := 0 to dataList.Count - 1 do
  begin
    p := dataList.Items[i];
    result := result + format('(%d;%d)', [p.X, p.Y]);
    if ((i + 1) mod 2) = 0 then result := result + '<br>';
  end;

end;

function TMonsterHtmClass.getMin(ax, ay: integer): integer;
var
  p: ^TPoint;
  i, j, min: integer;
begin
  result := -1;
  for i := 0 to dataList.Count - 1 do
  begin
    p := dataList.Items[i];
    j := GetLargeLength(ax, ay, p.X, p.y);
    if (j < Result) or (Result = -1) then result := j;
  end;

end;

procedure TMonsterList.AddMonster2(aMonsterName: string; ax, ay,
  aw: integer; aMemberStr: string; anation, amappathid: integer;
  aboDieDelete: boolean; adelay: Integer);
var
  Monster, Member: TMonster;
  str, MemberName, MemberCount: string;
  i, Count: Integer;
  AttackSkill,
    tmpAttackSkill: TAttackSkill;
begin
  Monster := TMonster.Create;
  if Monster <> nil then
  begin
    Monster.SetManagerClass(Manager);
    Monster.Initial(aMonsterName, ax, ay, aw, anation, amappathid, _htt_nation);
    DataList.Add(Monster);
    Monster.boDieDelete := aboDieDelete;
        //新增延迟刷怪
    if adelay > 0 then
    begin
      Monster.AddDelay(adelay);
     // Monster.LifeObjectState := los_exit;
      Monster.LifeObjectState := los_die;
      Monster.CommandChangeCharState(wfs_die);
    end;

        //附带怪物
    if aMemberStr <> '' then
    begin
            //创建 组
      AttackSkill := Monster.GetAttackSkill;
      AttackSkill.GroupCreate;

      str := aMemberStr;
      while str <> '' do
      begin
        str := GetValidStr3(str, MemberName, ':');
        if MemberName = '' then break;
        str := GetValidStr3(str, MemberCount, ':');
        if MemberCount = '' then break;
        Count := _StrToInt(MemberCount);

        for i := 0 to Count - 1 do
        begin
          Member := nil;
          Member := TMonster.Create;
          if Member <> nil then
          begin
            Member.SetManagerClass(Manager);
            Member.Initial(MemberName, ax, ay, aw, anation, 0, _htt_nation);
            DataList.Add(Member);
            Member.boDieDelete := aboDieDelete;
                       //新增延迟刷怪
            if adelay > 0 then
            begin
              Member.AddDelay(adelay);
              Member.LifeObjectState := los_die;
              Member.CommandChangeCharState(wfs_die);
            end;
                        //加入 到主，组
            AttackSkill.GroupAdd(Member);
            tmpAttackSkill := Member.GetAttackSkill;
            if tmpAttackSkill <> nil then tmpAttackSkill.GroupSetBoss(Monster); //创建 怪物
          end;
        end;
      end;
    end;
  end;
end;

end.

