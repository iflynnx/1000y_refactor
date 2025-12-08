unit uUserSub;
{$DEFINE  Free}

interface

uses
  Windows, dialogs, SysUtils, Classes, Usersdb, Deftype, //AnsUnit,
  AUtil32, uSendcls, uAnstick, uLevelexp, svClass, BasicObj, uResponsion,
  uMagicClass, uKeyClass, PaxScripter, ScriptForMysql, class_DataSetWrapper;

const
  DRUGARR_SIZE = 3;

type
  TLifeDataListdata = record
    rid: integer;
    LifeData: TLifeData;
    name: string[32];
    rendtime: integer;
    rstarttime: integer;
    rsharp: integer;
    reffect: integer;
    rdesc: string[255];
  end;

  pTLifeDataListdata = ^TLifeDataListdata;

  /////////////////////////////////////////////////
  //               状态：基本数据存储
  /////////////////////////////////////////////////
  TOnLifedata = procedure(var temp: TLifeDataListdata) of object;

  TOnLifedataClear = procedure() of object;

  TOnLifedataSetUPdate = procedure() of object;

  TLifeDataBASIC = class //属性列表
  private
    ftext: string;
    Fonadd: TOnLifedata;
    Fondel: TOnLifedata;
    FonUPdate: TOnLifedata;
    FonClear: TOnLifedataClear;
    FonLifedataUPdate: TOnLifedataSetUPdate;
    procedure updatetext;
    function getcount: integer;
  public
    DataList: TList;
    LifeData: TLifeData; //属性合计
    rboupdate: boolean; //是否有变动
    constructor Create;
    destructor Destroy; override;
    function get(aid: integer): pTLifeDataListdata;
    function del(aid: integer): boolean; //唯一  删除
    function add(var aitem: TLifeDataListdata): boolean; //唯一 增加
    procedure upitem(pp: pTLifeDataListdata; var aitem: TLifeDataListdata);
    //唯一 更新覆盖
    procedure Clear();
    procedure setLifeData();
    property ONadd: TOnLifedata read Fonadd write Fonadd;
    property ONdel: TOnLifedata read Fondel write Fondel;
    property ONUPdate: TOnLifedata read FonUPdate write FonUPdate;
    property ONClear: TOnLifedataClear read FonClear write FonClear;
    property onLifedataUPdate: TOnLifedataSetUPdate read FonLifedataUPdate write FonLifedataUPdate;
    property text: string read ftext;
    property Count: Integer read getcount;
  end;
  /////////////////////////////////////////////////
  //             状态：通用管理类
  /////////////////////////////////////////////////
  TLifeDataList = class(TLifeDataBASIC)
  private
    FBasicObject: TBasicObject;
  public
    constructor Create(aBasicObject: TBasicObject = nil);
    destructor Destroy; override;
    function additem(var aitem: titemdata): boolean;
    function AddScript(aid: Integer; aname: string; aLifeData: TLifeData; atime: Integer;
      asharp: Integer = 0; aeffect: Integer = 0; adesc: string = ''): boolean; //2015.11.04新增脚本添加附加属性
    procedure Update(CurTick: integer);
  end;

  TDesignationClass = class
  private
    FSendClass: TSendClass;
    FBasicObject: TBasicObject;
    boSend: boolean;
    procedure sendMenu;
    procedure onUpdate(aindex: integer);
  public
    LifeData: TLifeData;
    DesignationData: TDesignationData;
    constructor Create(aBasicObject: TBasicObject; aSendClass: TSendClass);
    destructor Destroy; override;
    procedure LoadFromSdb(aCharData: PTDBRecord);
    procedure SaveToSdb(aCharData: PTDBRecord);
    function getId(aname: string): integer;
    function User(aname: string): boolean; //使用
    function UserID(aid: integer): boolean; //使用
    function delName(aname: string): boolean; //删除
    function add(aid: integer): boolean; //增加
    function del(aid: integer): boolean; //删除
    function IsCheck(aid: integer): boolean;
    function getName(aid: integer): string; //获取ID对应名字
    function getMenu(): string;
    procedure Update(CurTick: integer);
    function SpaceCount: integer;
  end;

  TAttribClass = class
  private
    FBasicObject: TBasicObject;
    boAddExp: Boolean;
    boMan: Boolean;
    boSendValues: Boolean;
    boSendBase: Boolean;
    boRevivalFlag: Boolean;
    boEnergyFlag: Boolean;
    boInPowerFlag: Boolean;
    boOutPowerFlag: Boolean;
    boMagicFlag: Boolean;
    FFeatureState: TFeatureState;
    StartTick: integer;
    CheckIncreaseTick: integer; // 9 檬俊 茄锅
    CheckDrugTick: integer; // 1 檬俊 茄锅
    CheckLuckyTick: Integer;
    FPowerLevelPdata: pTPowerLeveldata;
    FSendClass: TSendClass;
    //防御
    function GetCurInPower: integer;
    procedure SetCurInPower(value: integer);
    function GetCurOutPower: integer;
    procedure SetCurOutPower(value: integer);
    function GetCurMagic: integer;
    procedure SetCurMagic(value: integer);
    function GetCurLife: integer;
    procedure SetCurLife(value: integer);
    function GetMaxLife: integer;
    function GetCurHeadLife: integer;
    procedure SetCurHeadLife(value: integer);
    function GetCurArmLife: integer;
    procedure SetCurArmLife(value: integer);
    function GetCurLegLife: integer;
    procedure SetCurLegLife(value: integer);
    function getprestige(): integer;
    procedure setprestige(value: integer);
    function CheckRevival: Boolean;
    function CheckEnegy: Boolean;
    function CheckInPower: Boolean;
    function CheckOutPower: Boolean;
    function CheckMagic: Boolean;
    procedure SetLifeData;
    procedure SetPowerLevelPdata(value: pTPowerLeveldata);
    procedure addLife(aLife: integer);
    function getGuildPoint: Integer;
    procedure setGuildPoint(const Value: Integer);
    function getGuildName: TNameString;
    procedure setGuildName(const Value: TNameString);
    //VIP操作 //VIP等级
    function getVipUseLevel: byte;
    procedure setVipUseLevel(const Value: byte);
    //VIP操作 //VIP时间
    function getVipUseTime: Tdatetime;
    procedure setVipUseTime(const Value: Tdatetime);
    //强化祝福值 操作
    function getAddableStatePoint: byte;
    procedure setAddableStatePoint(const Value: byte);
    //双倍 倍数
    function getMagicExpMulCount: byte;
    procedure setMagicExpMulCount(const Value: byte);
    //双倍 时间
    function getMagicExpMulEndTime: Integer;
    procedure setMagicExpMulEndTime(const Value: Integer);
  public
    ItemDrugArr: array[0..DRUGARR_SIZE - 1] of TItemDrugData; //药品 物品
    CurAttribData: TCurAttribData;
    AttribData: TAttribData;
    AttribLifeData: TLifeData;
    ReQuestPlaySoundNumber: integer;

    //境界 等级
    PowerLevel: integer;
    PowerLevelMax: integer;
    HaveItemCLife: integer;
    WearItemCLife: Integer; //2015.10.24 新增身上装备活力
    PowerShieldBoState: boolean;
    PowerShieldLife, PowerShieldLifeMax: integer; //境界盾 活力
    PowerShieldArmor: integer;
    PowerShieldTick, shieldtick: integer;
    FGuildPoint: Integer;
    procedure setHaveItemCLife(aLife: integer);
    procedure setWearItemCLife(aLife: integer); //2015.10.24 添加增加身上装备活力
    constructor Create(aBasicObject: TBasicObject; aSendClass: TSendClass);
    destructor Destroy; override;
    procedure Update(CurTick: integer);
    function AddItemDrug(aDrugName: string): Boolean;
    procedure LoadFromSdb(aCharData: PTDBRecord);
    procedure SaveToSdb(aCharData: PTDBRecord);
    procedure Calculate;
    procedure AddAdaptive(aexp: integer);
    procedure upEnergy(aexp: integer);
    procedure addEnergy(aexp: integer);
    procedure delenergy(aexp: integer);
    procedure addvirtue(aexp, aMaxLevel: integer); //浩然
    procedure SetVirtue(aexp: integer);
    function GetVirtueLevel(): integer;
    property CurMagic: Integer read GetCurMagic write SetCurMagic;
    property CurOutPower: Integer read GetCurOutPower write SetCurOutPower;
    property CurInPower: Integer read GetCurInPower write SetCurInPower;
    property CurLife: Integer read GetCurLife write SetCurLife;
    property MaxLife: Integer read GetMaxLife;
    property CurHeadLife: Integer read GetCurHeadLife write SetCurHeadLife;
    property CurArmLife: Integer read GetCurArmLife write SetCurArmLife;
    property CurLegLife: Integer read GetCurLegLife write SetCurLegLife;
    property PowerLevelPdata: pTPowerLeveldata read FPowerLevelPdata write SetPowerLevelPdata;
    property prestige: Integer read getprestige write setprestige; //荣誉
    property FeatureState: TFeatureState read FFeatureState write FFeatureState;
    property GuildPoint: Integer read getGuildPoint write setGuildPoint;
    property GuildName: TNameString read getGuildName write setGuildName;
    property SetAddExpFlag: Boolean write boAddExp;
    function GetAge: Integer;

    property VipUseLevel: byte read getVipUseLevel write setVipUseLevel; //VIP等级
    property VipUseTime: Tdatetime read getVipUseTime write setVipUseTime; //VIP时间

    property AddableStatePoint: byte read getAddableStatePoint write setAddableStatePoint; //强化祝福值

    property MagicExpMulCount: byte read getMagicExpMulCount write setMagicExpMulCount; //双倍 倍数
    property MagicExpMulEndTime: Integer read getMagicExpMulEndTime write setMagicExpMulEndTime; //双倍 时间
  public
    AttribQuestData: TAttribQuestData; //特殊 任务 属性 附加
    procedure AQCalculate;
    procedure AQClear;
    procedure AQDataUPdate();
    function AQgetEnergy: integer;
    function AQgetAge: integer;
    function AQget3f_fetch: integer;
    function AQget3f_sky: integer;
    function AQget3f_terra: integer;
    function AQgetAdaptive: integer;
    function AQgetInPower: integer;
    function AQgetLife: integer;
    function AQgetMagic: integer;
    function AQgetOutPower: integer;
    function get3f_fetch: integer;
    function get3f_sky: integer;
    function get3f_terra: integer;
    procedure REFILL;
    function getEnergy: integer;
    function getcEnergy: integer;
    procedure SetEnergy(aexp: integer);
    procedure set3f_fetch(avalue: integer);
    procedure set3f_sky(avalue: integer);
    procedure set3f_terra(avalue: integer);
    function getluck: integer; //获取年龄奖励
    function getbad: integer; //获取武术职业
    function gettalent: integer;
    procedure Settalent(aexp: integer);
    procedure Setluck(aexp: integer); //设置年龄奖励
    procedure Setbad(aexp: integer); //设置武者职业
    function Getpetmax(): integer;
    function Getpetname(): string;
    procedure Setpetname(aexp: string);
    function Getpetmagic(): string;
    procedure Setpetmagic(aexp: string);
    function Getpetgrade(): integer;
    procedure Setpetgrade(aexp: integer);
    function Getpetexp(): integer;
    procedure Setpetexp(aexp: integer);
    procedure addpetexp(aexp: integer);
    procedure Setpetmax(aexp: integer);
    procedure subLucky();
    procedure caclTalentlv(); //计算天赋是否升级
    procedure setnewTalentExp(ATalentExp: Integer);
    function getnewTalentExp: Integer; //获取天赋经验

    function getnewTalentLv: integer; //获取天赋等级
    procedure setnewTalentLv(ATalentLv: Integer); //修改天赋等级

    function getnewTalent: integer; //获取天赋点
    procedure setnewTalent(AnewTalent: Integer); //修改天赋点

    function getnewBone: Integer; //获取根骨
    function getnewLeg: Integer; //获取身法
    function getnewSavvy: Integer; //获取悟性
    function getnewAttackPower: Integer; //获取武学

    procedure setnewBone(AnewBone: word); //写入根骨
    procedure setnewLeg(AnewLeg: word); //写入身法
    procedure setnewSavvy(AnewSavvy: word); //写入悟性
    procedure setnewAttackPower(AnewAttackPower: word); //写入武学

  end;

  TUserSubBase = class
  private
    FBasicObject: TBasicObject;
    FSendClass: TSendClass;
    FAttribClass: TAttribClass;
  public
    LifeData: TLifeData;
    procedure LoadFromSdb(aCharData: PTDBRecord); virtual; abstract;
    procedure SaveToSdb(aCharData: PTDBRecord); virtual; abstract;
    procedure SetLifeData; virtual; abstract;
    constructor Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass); virtual;
    destructor Destroy; override;
  end;

  TTalentClass = class(TUserSubBase)
  private
    FnewBone: word; //根骨
    FnewLeg: word; //身法
    FnewSavvy: word; //悟性
    FnewAttackPower: word; //武学
  public

    procedure LoadFromSdb(aCharData: PTDBRecord); override;
    procedure SaveToSdb(aCharData: PTDBRecord); override;
    constructor Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass); override;
    destructor Destroy; override;
    procedure SetLifeData; override;
    procedure SetnewAttackPower(anewAttackPower: Word);
    procedure SetnewLeg(AnewLeg: word);
    procedure SetnewSavvy(AnewSavvy: word);
    procedure SetnewBone(AnewBone: word);

    procedure ScriptSetnewAttackPower(anewAttackPower: Word);
    procedure ScriptSetnewLeg(AnewLeg: word);
    procedure ScriptSetnewSavvy(AnewSavvy: word);
    procedure ScriptSetnewBone(AnewBone: word);
  end;

  THaveMagicClass = class
  private
    FBasicObject: TBasicObject;
    boAddExp: Boolean;
    HaveItemType: integer; //武器 攻击类型
  //  HaveMagicArr: array[0..HAVEMAGICSIZE60 - 1] of TMagicData; //学书 武功
  //  HaveRiseMagicArr: array[0..xHAVEMAGICSIZE - 1] of TMagicData; //2层武功
  //  HaveMysteryMagicArr: array[0..xHAVEMAGICSIZE - 1] of TMagicData; //掌法
    WalkingCount: integer; //Walking 走路
    FpCurAttackMagic: PTMagicData;
    FpCurBreathngMagic: PTMagicData;
    FpCurRunningMagic: PTMagicData;
    FpCurProtectingMagic: PTMagicData;
    FpCurEctMagic: PTMagicData;
    FSendClass: TSendClass;
    FAttribClass: TAttribClass;
    AddExpCount: integer; //获得 经验 次数量
    AddHitCount: integer; //攻击 次数量
    JobKind: integer;
    jobLevelx: integer;
    JobSkillExp: integer; //20130713修改 这个传递调整为grade
    JobSendTick: integer;
    JobpTJobGradeData: pTJobGradeData;
    Procession_Exp_Sum: integer;
    FMagicExpMulCount: integer; //经验翻倍倍数
    function boKeepingMagic(pMagicData: PTMagicData): Boolean;
    procedure DecBreathngAttrib(pMagicData: PTMagicData);
    procedure Dec5SecAttrib(pMagicData: PTMagicData);
    procedure DecEventAttrib(pMagicData: PTMagicData);
    procedure SetLifeData;
    procedure FindAndSendMagic(pMagicData: PTMagicData);
    procedure SendMagicAddExp(pMagicData: PTMagicData);
    procedure DefaultMagic2;
  public
    DefaultMagic: array[0..20 - 1] of TMagicData; //基本 武功 列表
    // DefaultRiseMagic: array[0..10 - 1] of TMagicData;                       //基本 武功 列表
    HaveMagicArr: array[0..HAVEMAGICSIZE60 - 1] of TMagicData; //学书 武功
    HaveRiseMagicArr: array[0..xHAVEMAGICSIZE - 1] of TMagicData; //2层武功
    HaveMysteryMagicArr: array[0..xHAVEMAGICSIZE - 1] of TMagicData; //掌法
    HaveMagicLifeData: TLifeData;
    ReQuestPlaySoundNumber: integer;
    constructor Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
    destructor Destroy; override;
    function Update(CurTick: integer): integer;
    procedure sendMagicBasicIni();
    procedure LoadFromSdb(aCharData: PTDBRecord);
    procedure SaveToSdb(aCharData: PTDBRecord);
    function AddpetExp(atype: TExpType; aexp: integer): integer;
    procedure JObgetMenu;
    procedure jobSetKind(akind: integer);
    function JobAddExp(aexp, amaxexp: integer): boolean;
    function jobGetKind: integer;
    function JobgetJobGrade: pTJobGradeData;
    function jobGetlevel: integer;
    function JobSetLevel(alevel: integer): boolean;
    //
//      function GETSendBasicMagic(akey: integer): Boolean;
//        function GETSendMagic(akey: integer): Boolean;
//公共部分
    function All_FindName(aMagicName: string): PTMagicData;
    function All_MagicEnerySum(): integer; //元气总和
    function changem(x: integer): integer; //点脉
    function changes(x: string): integer; //单武功点脉
    function AddMagic(aMagicData: PTMagicData): Boolean;
    function AddMagicAndLevel(aMagicData: PTMagicData): Boolean;
    function DeleteMagicName(aname: string): Boolean;
    //增加经验
    function AddAttackExp(atype: TExpType; aexp: integer): integer;
    //攻击 增加谨严
    function AddProtectExp(atype: TExpType; aexp: integer): integer;
    //护体 被攻击 增加 经验
    function AddEctExp(atype: TExpType; aexp: integer): integer;
    //强身 攻击 增加经验
    function AddWalking: Boolean; //步法  增加经验
    function AddMagicExp(aname: string; aexp: integer): integer; //脚本使用 增加
    function SetMagicLevel(MagicName: string; MagicLevel: integer): Boolean; //脚本使用 修改武功等级
    function clearMagicExp(aname: string): integer; //清理武功
    procedure SetBreathngMagic(aMagic: PTMagicData);
    procedure SetRunningMagic(aMagic: PTMagicData);
    procedure SetProtectingMagic(aMagic: PTMagicData);
    procedure SetEctMagic(aMagic: PTMagicData);
    procedure setAttackMagic(value: PTMagicData); //2009 4 11增加
    // function  SetHaveMagicPercent (akey: integer; aper: integer): Boolean;
    // function  SetDefaultMagicPercent (akey: integer; aper: integer): Boolean;
    // function  FindBasicMagic (akey : Integer) : Integer;
//其他
   //减少元气
    procedure delenergypoint(aenergypoint: integer);
    //增加元气
    procedure addEnergyPoint(aEnergyPoint: integer);
    function SetHaveItemMagicType(atype: integer): integer;
    function GetUsedMagicList: string; //使用武功 文字列表
    function DecEventMagic(apmagic: PTMagicData): Boolean;

    //未使用部分
    function getuserMagic: string;
    //属性
    property pCurAttackMagic: PTMagicData read FpCurAttackMagic; //攻击
    property pCurBreathngMagic: PTMagicData read FpCurBreathngMagic; //Breath 心法
    //Breath 心法
    property pCurRunningMagic: PTMagicData read FpCurRunningMagic; //奔跑
    property pCurProtectingMagic: PTMagicData read FpCurProtectingMagic; //防护
    property pCurEctMagic: PTMagicData read FpCurEctMagic; //辅助
    property SetAddExpFlag: Boolean write boAddExp;
    //武功倍数
    property MagicExpMulCount: integer read FMagicExpMulCount write FMagicExpMulCount;
  public
    //武功
    function ViewMagic(akey: integer; aMagicData: PTMagicData): Boolean;
    function PreSelectHaveMagic(akey, aper: integer; var RetStr: string): Boolean; //选择前 简单 判断
    function SelectHaveMagic(akey, aper: integer; var RetStr: string): integer;
    //选择武功
    function ChangeMagic(asour, adest: integer): Boolean; //改变武功
    function DeleteMagic(akey: integer): Boolean;
    function GetMagicSkillLevel(aMagicName: string): Integer;
    //查找 武功 经验等级
    function GetMagicIndex(aMagicName: string): integer;
    function MagicSpaceCount: integer;

    //2武功
    function Rise_ViewMagic(akey: integer; aMagicData: PTMagicData): Boolean;
    function Rise_PreSelectHaveMagic(akey, aper: integer; var RetStr: string): Boolean;
    function Rise_SelectHaveMagic(akey, aper: integer; var RetStr: string): integer;
    function Rise_ChangeMagic(asour, adest: integer): Boolean;
    function Rise_DeleteMagic(akey: integer): Boolean;
    function Rise_GetMagicSkillLevel(aMagicName: string): Integer;
    //查找 武功 位置
    function Rise_GetMagicIndex(aMagicName: string): integer;
    function Rise_MagicSpaceCount: integer;
    //掌法武功
    function Mystery_ViewMagic(akey: integer; aMagicData: PTMagicData): Boolean;
    function Mystery_PreSelectHaveMagic(akey, aper: integer; var RetStr: string): Boolean;
    function Mystery_SelectHaveMagic(akey, aper: integer; var RetStr: string): integer;
    function Mystery_ChangeMagic(asour, adest: integer): Boolean;
    function Mystery_DeleteMagic(akey: integer): Boolean;
    function Mystery_GetMagicSkillLevel(aMagicName: string): Integer;
    //查找 武功 位置
    function Mystery_GetMagicIndex(aMagicName: string): integer;
    function Mystery_MagicSpaceCount: integer;
    //基本
    function ViewBasicMagic(akey: integer; aMagicData: PTMagicData): Boolean;
    function PreSelectBasicMagic(akey, aper: integer; var RetStr: string): Boolean;
    function SelectBasicMagic(akey, aper: integer; var RetStr: string): integer;
    function ChangeBasicMagic(asour, adest: integer): Boolean;
  end;

  //身上装备
  TWearItemClass = class
  private
    FdecItemDurabilityTick: INTEGER;
    boLocked: Boolean;
    LockTick: integer;
    FBasicObject: TBasicObject;
    FHaveMagicClass: THaveMagicClass;
    boFashionable: boolean; //使用时装
    WearFeature: pTFeature; //TFeature;
    WearItemArr: array[ARR_BODY..ARR_MAX] of TItemData;
    WearFashionableItemArr: array[ARR_BODY..ARR_MAX] of TItemData;
    FSendClass: TSendClass;
    FAttribClass: TAttribClass;
    procedure SetLifeData;
    procedure ItemTimeMode(CurTick: integer);
  public
    WearItemLifeData: TLifeData;
    ReQuestPlaySoundNumber: integer;
    constructor Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
    destructor Destroy; override;
    procedure Update(CurTick: integer);
    procedure PowerLevelUPDATE;
    function GETfellowship(): integer;
    function SETfellowship(id: integer): boolean;
    procedure UPFeature;
    procedure AddAttackExp(aexp: integer);
    function DecDurabilityWeapon(): boolean;
    procedure DecDurability();
    procedure LoadFromSdb(aCharData: PTDBRecord);
    procedure SaveToSdb(aCharData: PTDBRecord);
    function GetWearItemName(akey: integer): string;
    function getViewItem(akey: integer): PTItemData;
    function getViewItemFD(akey: integer): PTItemData;
    //Repair
    function RepairGoldSum(): integer;
    function RepairAll(): boolean;
    function ViewItem(akey: integer; aItemData: PTItemData): Boolean;
    function ViewItemFD(akey: integer; aItemData: PTItemData): Boolean;
    function AddItem(aItemData: PTItemData): Boolean; //唯一 增加
    function AddItemFD(aItemData: PTItemData): Boolean;
    function DeleteKeyItem(akey: integer): boolean;
    procedure DeleteKeyItemFD(akey: integer);
    procedure onChangeItem(akey: integer);
    function ChangeItem(var aItemData: TItemData; var aOldItemData: TItemData): Boolean;
    function ChangeItemFD(var aItemData: TItemData; var aOldItemData: TItemData): Boolean;
    function GetWeaponType: Integer;
    function GetWeaponName: string;
    function GetWeaponAttribute: Integer;
    function GetWeaponGuild: boolean;
    procedure SetFeatureState(aFeatureState: TFeatureState);
    procedure SetHiddenState(aHiddenState: THiddenState);
    procedure SetActionState(aActionState: TActionState);
    function GetHiddenState: THiddenState;
    function GetActionState: TActionState;
    property Locked: Boolean read boLocked write boLocked;
    property Fashionable: Boolean read boFashionable write boFashionable;
    procedure QClear; //清除 任务装备

    function colorItem(aItemData: PTItemData; adest: integer): Boolean; //2015.10.22 新增身上装备染色
    procedure StartItem;
  end;

  THaveItemQuestClass = class
  private
    FSendClass: TSendClass;
    FAttribClass: TAttribClass;
    FItemArr: array[0..30 - 1] of TItemData;
    procedure clear;
  public
    constructor Create(aSendClass: TSendClass; aAttribClass: TAttribClass);
    destructor Destroy; override;
    procedure LoadFromSdb(aCharData: PTDBRecord);
    procedure SaveToSdb(aCharData: PTDBRecord);
    function Add(aItemData: PTItemData): Boolean; //物品 唯一
    procedure del(aname: string; acount: integer);
    function get(aname: string): PTItemData;
    procedure delQuestId(aQusetID: integer);
    function SpaceCount: integer;
  end;

  THaveItemLifeData = record
    rLife: integer;
    rLifedata: TLifeData;
  end;

  //背包 物品 列表
  THaveItemClass = class
  private
    //  boLocked:Boolean;
    FHaveItemQuestClass: THaveItemQuestClass;
    boLockedPass: boolean; //密码 琐
    UpdateTick: integer; //上次UPDATE 物品时间
    LockTick: integer;
    AddLifeTick: integer;
    WaterTick: integer;
    FUserName: string;
    FSendClass: TSendClass;
    FAttribClass: TAttribClass;
    FGOLD_Money: integer; //【元宝】
    //备份 用于 回滚
    BAKGOLD_Money: integer; //【元宝】
    FBindMoney: Int64;
    FBackBindMoney: Int64;
    BAKHaveItemArr: array[0..HAVEITEMSIZE - 1] of TItemData;
    FItemInputWindowsKeyArr: array[0..4] of integer;
    //-1 表示 空  0-29 背包某个位置
    Faffair: THaveItemClassAffair;
    FBasicObject: TBasicObject;
    //_开始的内部使用
    function _GetSpace(): integer;
    function _GetItemName(aname: string): integer;
  public
    HaveItemArr: array[0..HAVEITEMSIZE - 1] of TItemData;
    ReQuestPlaySoundNumber: integer;
    HaveItemLifeData: THaveItemLifeData;
    LockPassword: string[20]; //array[0..20 - 1] of byte;
    constructor Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass; aHaveItemQuestClass: THaveItemQuestClass);
    destructor Destroy; override;
    procedure LoadFromSdb(aCharData: PTDBRecord);
    procedure SaveToSdb(aCharData: PTDBRecord);
    procedure Update(CurTick: integer);
    procedure setLifeData();
    function ItemInputWindowsOpen(aSubKey: integer; aCaption: string; aText: string): boolean;
    function ItemInputWindowsClose: boolean;
    function ItemInputWindowsClear: boolean;
    function GetItemInputWindowsKey(aSubKey: integer): integer;
    function setItemInputWindowsKey(aSubKey, akey: integer): boolean;
    procedure affair(atype: THaveItemClassAffair); //事务回滚
    function SpaceCount: integer; //空闲位置数量
    function IsSpace: boolean; //TRUE 有空位置
    function SetPassword(aPassword: string): string; //设置密码
    function FreePassword(aPassword: string): string; //临时解锁密码
    function ClearPassword(aPassword: string): string; //清空密码
    function getViewItem(akey: integer): PTItemData;
    function ViewItem(akey: integer; aItemData: PTItemData): Boolean;
    function ViewItemName(aname: string; outitemData: PTItemData): Boolean;

    //增加 一共2个指令
    function Add_GOLD_Money(acount: integer): Boolean; //【元宝】 唯一
    function AddItem(aItemData: PTItemData; isinfo: Boolean = True): Boolean; //物品 唯一
    //        function AddKeyItem(akey:Integer; var aItemData:TItemData):Boolean; //物品
    function FindItem(aItemData: PTItemData): Boolean; //查找 物品 测试 数量
    //查找目标 背包位置
    function FindKindItem(akind: integer): integer;
    function FindNameItem(aname: string): integer;
    function FindItemByMagicKind(aKind: integer): integer;
    //删除
    function DEL_GOLD_Money(acount: integer): Boolean; //扣 元宝  唯一    
    function SET_GOLD_Money(acount: integer): Boolean; //写入 元宝  唯一
    function DeletekeyItem(akey, aCount: integer): Boolean; //删除指定 位置 数量
    function DropkeyItem(akey, aCount, x, y: integer): Boolean; //掉落 物品
    function DeleteItem(aItemData: PTItemData): Boolean;
    //扣物品 调用 DeletekeyItem 完成功能

  //        function DelCleftItem(akey, acount:integer; aOutItemData:PTItemData):Boolean; //分离模式
    function GET_GOLD_Money(): INTEGER;
    function lockkeyItem(akey: integer): Boolean;
    procedure ItemWorldSay(aItemData: PTItemData); //物品 世界通告 名字,自己位置
    function UNlockkeyItem(akey: integer): Boolean;
    function SendItemPro(akey: integer): Boolean; //物品详细 筐
    function ChangeItem(asour, adest: integer): Boolean;
    procedure Sort(var AItemDatas: array of TItemData);
    procedure SortItem();
    function colorItem(asour, adest: integer): Boolean;
    function getpassword(): string;
    procedure DeleteAllItem;
    procedure OnChangeMap();
    procedure OnGameExit();
    procedure Ondie();
    procedure neaten();
    procedure sendItemAll; //重新发送 物品 列表
    function IsDurability_Water(): boolean;
    function addDurability_Water: boolean;
    function setDurability(akey, aCount: integer): boolean;
    //   property Locked:Boolean read boLocked write boLocked;
    property LockedPass: Boolean read boLockedPass write boLockedPass;
    property Password: string read getpassword;
    property GOLD_Money: integer read FGOLD_Money;
    //======================修改部分============================
    function UpStarLevel(akey, alevel: integer): Boolean;
    function UpBoIdent(akey: integer; astate: boolean): Boolean;
    function blitem(akey: integer; astate: boolean): Boolean; //百炼装备
    function UpboBlueprint(akey: integer; astate: boolean): Boolean;
    function UPdateAttach(akey, aAttach: integer): Boolean;
    function Updatesettingcount(akey, acount: integer): Boolean;
    function UPdateItem_UPLevel(akey, alevel: integer; aLifeData: TLifeData): boolean;
    function UPdateItem_UPLevel_New(akey, alevel: integer): boolean;
    function UPdateItem_Setting_del(akey: integer): boolean;
    function UPdateItem_Setting(akey, aadditemKey: integer): boolean;
    //    function UpdateItemSetting_Stiletto(akey: integer): Integer; //打孔
    procedure QClear; //清除 任务装备
   //15.8.23 nirendao
    function Get_Bind_Money(): integer;
    function Add_Bind_Money(acount: integer): Boolean;
    function DEL_Bind_Money(acount: integer): Boolean;
  end;
  //交易 类

  TExChange = class
  private
  public
    MsgList: TResponsion; //应答列表
    fdata: TExChangeData; //交易 临时
    constructor Create;
    destructor Destroy; override;
    procedure Clear();
    function isstate: boolean; //交易状态
    procedure setExChange(aid: integer; aname: string);
    function add(akey: integer; aitem: tItemData): boolean;
    function del(akey: integer): boolean;
    function get(aindex: integer): pTExChangeItem;
    function getname(aname: string): pTExChangeItem;
    function IsSpace: boolean; //TRUE 有空位置
    function IsCheck: boolean; //确定 状态
    function count(): integer; //件
    procedure SendEnd;
  end;

  TItemLogAffair = (ilaRoll_back, ilaStart, ilaConfirm);

  TItemLog = class
  private
    Faffairtype: TItemLogAffair;
    FSendClass: TSendClass;
    bakFLogData: TItemLogRecord;
  public
    FLogData: PTItemLogRecord;
    constructor Create(aSendClass: TSendClass);
    destructor Destroy; override;
    function CreateRoom: Boolean;
    function GetCount: Integer;
    function isLocked: Boolean;
    function SetPassword(aPassword: string): string;
    function FreePassword(aPassword: string): string;
    function add(akey: integer; aitem: tItemData): boolean;
    function del(akey, acount: integer): boolean;
    procedure affair(atype: TItemLogAffair); //事务
    function ViewItem(akey: integer; aItemData: PTItemData): Boolean; //拷贝一份
    procedure neaten();
    procedure SetItemLog(tt: pointer);
    //下发 到客户端
    procedure senditemlogall();
    procedure senditemlog(akey: integer);
  end;
  //20090904增加 删除武功记录

  TDeleteMagicClass = class
  private
    Ffilename: string;
    FfileStream: TFileStream;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Write(astr: string);
    function GetCurDate: string;
  end;
  //20090904增加 摆摊功能  数据层

  TBoothDataClass = class
  private
    Faffair: THaveItemClassAffair;
    FBoothBuyArr: array[0..11] of TBoothShopData;
    FBoothSellArr: array[0..11] of TBoothShopData;
    FBoothBuyArr_bak: array[0..11] of TBoothShopData;
    FBoothSellArr_bak: array[0..11] of TBoothShopData;
    FSendClass: TSendClass;
    FHaveItemClass: THaveItemClass;
  public
    state: boolean;
    boothname: string;
    boothshape: integer;
    procedure clear;
    constructor Create(aSendClass: TSendClass; aHaveItemClass: THaveItemClass);
    destructor Destroy; override;
    function BuyAdd(akey: integer; var aitem: TBoothShopData): boolean;
    function BuyDel(akey, acount: integer; aUserSendclass: TSendClass): boolean;
    function BuyGet(akey: integer): PTBoothShopData;
    function SellAdd(akey: integer; var aitem: TBoothShopData): boolean;
    function SellDel(akey, acount: integer; aUserSendclass: TSendClass): boolean;
    function SellGet(akey: integer): PTBoothShopData;
    function checkHaveItemKey(): boolean;
    function check(out astr: string): boolean;
    procedure sendall;
    procedure send_userall(asendclass: TSendClass);
    procedure affair(atype: THaveItemClassAffair);
  end;

  ///////////////////////////////////////////////////////////////////////////
var
  DelMagic: TDeleteMagicClass;
  vBfth: integer = 0; //步法弹回变量
  vAddVirtueExp: integer = 1;
  vAddMagicExp_MaxExp: integer = 1;
  vAddMagicExp_AttackMagic: integer = 1;
  vAddMagicExp_BreathngMagic: integer = 1;
  vAddMagicExp_RunningMagic: integer = 1;
  vAddMagicExp_ProtectingMagic: integer = 1;
  vAddMagicExp_EctMagic: integer = 1;
  vAge_Exp: integer = 1;

procedure CopyItemToDBItem(var Source: TItemData; var DEST: TDBItemData);

procedure CopyDBItemToItem(var Source: TDBItemData; var DEST: TItemData);

function DBItemDataADD(Source: tItemData; var dest: TDBItemData): boolean;

function ItemDataADD(Source: tItemData; var dest: tItemData): boolean;

procedure ItemLifeDataUPdate(var item: TItemData);

implementation

uses
  FSockets, svMain, uUser, uMonster, StrUtils, UTelemanagement;
//统一 物品 拷贝
//DB简易 到 完整 物品
{
TWearItemClass  类 身上
THaveItemClass  类 背包

}

function DBItemDataADD(Source: tItemData; var dest: TDBItemData): boolean;
var
  temp: tItemData;
begin
  result := false;
  CopyDBItemToItem(dest, temp);
  if ItemDataADD(Source, temp) then
  begin
    CopyItemToDBItem(temp, dest);
    result := true;
  end
  else
  begin

  end;

end;

function ItemDataADD(Source: tItemData; var dest: tItemData): boolean;
begin
  result := false;
  if Source.rName = '' then
    exit;
  if Source.rCount <= 0 then
    exit;
  if (dest.rName = '') or (dest.rCount <= 0) then
  begin
    dest := Source;
    result := true;
  end
  else
  begin
    if Source.rboDouble = false then
      exit;
    if Source.rName <> dest.rName then
      exit;
    if Source.rColor <> dest.rColor then
      exit;
    dest.rCount := Source.rCount + dest.rCount;

    if dest.rCurDurability < Source.rCurDurability then
      dest.rCurDurability := Source.rCurDurability;
    if dest.rDurability < Source.rDurability then
      dest.rDurability := Source.rDurability;

    // if dest.rlevel < Source.rlevel then
    dest.rSmithingLevel := Source.rSmithingLevel;

    dest.rAttach := Source.rAttach;
    if (dest.rlockState = 1) or (Source.rlockState = 1) then
    begin
      dest.rlockState := 1;
    end
    else if (dest.rlockState = 2) or (Source.rlockState = 2) then
    begin
      dest.rlockState := 2;
    end
    else
    begin
      dest.rlockState := 0;
    end;
    if dest.rlocktime < Source.rlocktime then
      dest.rlocktime := Source.rlocktime;

    result := true;
  end;

end;
//计算属性

procedure ItemLifeDataUPdate(var item: TItemData);
var
  i: integer;
  tempitem: TItemData;
  aLifeData: TLifeData;
  str: string;
  mul, mulx: Integer;
  pJobUpgrade: PTJobUpgradelData;
begin

  //=========================================================================
  //星级处理
  ItemClass.GetItemData(item.rName, tempitem);
  item.rLifeDataBasic := tempitem.rLifeDataBasic;
         //20130720修改星级加成物品属性
  FillChar(item.rLifeDataLevel, sizeof(TLifeData), 0);

  if ItemLifeDataClass.getItemStarLevel(item.rStarLevel, aLifeData) then
  begin

  //  fillchar(alifedata,SizeOf(tLifeData),0);
    case item.rStarLevel of
      1:
        begin
          mul := -10;
          mulx := 0;
        end;
      2:
        begin
          mul := 1;
          mulx := -1;
        end;
      3:
        begin
          mul := 6;
          mulx := 0;
        end; {
    4:
    begin
    mul:=1;
    mulx:=2;
    end; }
    end;
    if item.rStarLevel > 0 then
    begin
      if item.rLifeDataBasic.damageBody <> 0 then
        item.rLifeDataBasic.damageBody := item.rLifeDataBasic.damageBody + item.rLifeDataBasic.damageBody div mul + item.rLifeDataBasic.damageBody * mulx;

      if item.rLifeDataBasic.damageHead <> 0 then
        item.rLifeDataBasic.damageHead := item.rLifeDataBasic.damageHead + item.rLifeDataBasic.damageHead div mul + item.rLifeDataBasic.damageHead * mulx;
      if item.rLifeDataBasic.damageArm <> 0 then
        item.rLifeDataBasic.damageArm := item.rLifeDataBasic.damageArm + item.rLifeDataBasic.damageArm div mul + item.rLifeDataBasic.damageArm * mulx;
      if item.rLifeDataBasic.damageLeg <> 0 then
        item.rLifeDataBasic.damageLeg := item.rLifeDataBasic.damageLeg + item.rLifeDataBasic.damageLeg div mul + item.rLifeDataBasic.damageLeg * mulx;

      if item.rLifeDataBasic.armorBody <> 0 then
        item.rLifeDataBasic.armorBody := item.rLifeDataBasic.armorBody + item.rLifeDataBasic.armorBody div mul + item.rLifeDataBasic.armorBody * mulx;
      if item.rLifeDataBasic.armorHead <> 0 then
        item.rLifeDataBasic.armorHead := item.rLifeDataBasic.armorHead + item.rLifeDataBasic.armorHead div mul + item.rLifeDataBasic.armorHead * mulx;
      if item.rLifeDataBasic.armorArm <> 0 then
        item.rLifeDataBasic.armorArm := item.rLifeDataBasic.armorArm + item.rLifeDataBasic.armorArm div mul + item.rLifeDataBasic.armorArm * mulx;
      if item.rLifeDataBasic.armorLeg <> 0 then
        item.rLifeDataBasic.armorLeg := item.rLifeDataBasic.armorLeg + item.rLifeDataBasic.armorLeg div mul + item.rLifeDataBasic.armorLeg * mulx;

   { if item.rLifeDataBasic.AttackSpeed <> 0 then
      item.rLifeDataBasic.AttackSpeed := item.rLifeDataBasic.AttackSpeed +
        aLifeData.AttackSpeed;    }
      if item.rLifeDataBasic.avoid <> 0 then
        item.rLifeDataBasic.avoid := item.rLifeDataBasic.avoid + item.rLifeDataBasic.avoid div mul + item.rLifeDataBasic.avoid * mulx;
   { if item.rLifeDataBasic.recovery <> 0 then
      item.rLifeDataBasic.recovery := item.rLifeDataBasic.recovery +
        aLifeData.recovery;       }
      if item.rLifeDataBasic.HitArmor <> 0 then
        item.rLifeDataBasic.HitArmor := item.rLifeDataBasic.HitArmor + item.rLifeDataBasic.HitArmor div mul + item.rLifeDataBasic.HitArmor * mulx;
      if item.rLifeDataBasic.accuracy <> 0 then
        item.rLifeDataBasic.accuracy := item.rLifeDataBasic.accuracy + item.rLifeDataBasic.accuracy div mul + item.rLifeDataBasic.accuracy * mulx;

    end;

  end;
   {
  begin

    if item.rLifeDataBasic.damageBody <> 0 then
      item.rLifeDataBasic.damageBody := item.rLifeDataBasic.damageBody +
        aLifeData.damageBody;

    if item.rLifeDataBasic.damageHead <> 0 then
      item.rLifeDataBasic.damageHead := item.rLifeDataBasic.damageHead +
        aLifeData.damageHead;
    if item.rLifeDataBasic.damageArm <> 0 then
      item.rLifeDataBasic.damageArm := item.rLifeDataBasic.damageArm +
        aLifeData.damageArm;
    if item.rLifeDataBasic.damageLeg <> 0 then
      item.rLifeDataBasic.damageLeg := item.rLifeDataBasic.damageLeg +
        aLifeData.damageLeg;

    if item.rLifeDataBasic.armorBody <> 0 then
      item.rLifeDataBasic.armorBody := item.rLifeDataBasic.armorBody +
        aLifeData.armorBody;
    if item.rLifeDataBasic.armorHead <> 0 then
      item.rLifeDataBasic.armorHead := item.rLifeDataBasic.armorHead +
        aLifeData.armorHead;
    if item.rLifeDataBasic.armorArm <> 0 then
      item.rLifeDataBasic.armorArm := item.rLifeDataBasic.armorArm +
        aLifeData.armorArm;
    if item.rLifeDataBasic.armorLeg <> 0 then
      item.rLifeDataBasic.armorLeg := item.rLifeDataBasic.armorLeg +
        aLifeData.armorLeg;

    if item.rLifeDataBasic.AttackSpeed <> 0 then
      item.rLifeDataBasic.AttackSpeed := item.rLifeDataBasic.AttackSpeed +
        aLifeData.AttackSpeed;
    if item.rLifeDataBasic.avoid <> 0 then
      item.rLifeDataBasic.avoid := item.rLifeDataBasic.avoid + aLifeData.avoid;
    if item.rLifeDataBasic.recovery <> 0 then
      item.rLifeDataBasic.recovery := item.rLifeDataBasic.recovery +
        aLifeData.recovery;
    if item.rLifeDataBasic.accuracy <> 0 then
      item.rLifeDataBasic.accuracy := item.rLifeDataBasic.accuracy +
        aLifeData.accuracy;

  end;   }
  //=========================================================================
  if item.rWearArr = ARR_10_Special then
  begin
   // item.rSpecialLevel := GetLevel(item.rSpecialExp);
  end;
  FillChar(item.rLifeDataSetting, sizeof(TLifeData), 0);

  i := 0;
  //1号孔
  inc(i);
  if item.rSetting.rsettingcount >= 1 then
    if item.rSetting.rsetting1 <> '' then
      if ItemClass.GetItemData(item.rSetting.rsetting1, tempitem) then
        GatherLifeData(item.rLifeDataSetting, tempitem.rLifeData);
  //2号孔
  inc(i);
  if item.rSetting.rsettingcount >= 2 then
    if item.rSetting.rsetting2 <> '' then
      if ItemClass.GetItemData(item.rSetting.rsetting2, tempitem) then
        GatherLifeData(item.rLifeDataSetting, tempitem.rLifeData);
  //3号孔
  inc(i);
  if item.rSetting.rsettingcount >= 3 then
    if item.rSetting.rsetting3 <> '' then
      if ItemClass.GetItemData(item.rSetting.rsetting3, tempitem) then
        GatherLifeData(item.rLifeDataSetting, tempitem.rLifeData);
  //4号孔
  inc(i);
  if item.rSetting.rsettingcount >= 4 then
    if item.rSetting.rsetting4 <> '' then
      if ItemClass.GetItemData(item.rSetting.rsetting4, tempitem) then
        GatherLifeData(item.rLifeDataSetting, tempitem.rLifeData);
  //=========================================================================
  //精炼 属性
 { str := '精炼等级' + inttostr(item.rSmithingLevel);
  if ItemClass.GetItemData(str, tempitem) then
  begin
      case item.rWearArr of
          ARR_WEAPON:GatherLifeDataWEAPON(item.rLifeDataPro, tempitem.rLifeData);
      else GatherLifeDataNOTWEAPON(item.rLifeDataPro, tempitem.rLifeData);
      end;

  end;
  }
  //if ItemClass.boItemUPdateLevel then
  begin
         //20130704修改升级物品属性
    FillChar(item.rLifeDataLevel, sizeof(TLifeData), 0);

    if ItemLifeDataClass.getItemUPdateLevel(item.rGrade, item.rWearArr, item.rSmithingLevel, aLifeData) then
    begin
     // if item.rSmithingLevel>4 then  if item.rSmithingLevel=4  ;//限制最高4段
      fillchar(alifedata, SizeOf(tLifeData), 0);
      pJobUpgrade := JobUpgradeClass.getdate(item.rSmithingLevel);
      if pJobUpgrade <> nil then
      begin
        //闪躲
        if item.rLifeDataBasic.avoid <> 0 then
          aLifeData.avoid := item.rLifeDataBasic.avoid * pJobUpgrade.Avoid div 100;
        //维持
        if item.rLifeDataBasic.HitArmor <> 0 then
          aLifeData.HitArmor := item.rLifeDataBasic.HitArmor * pJobUpgrade.KeepRecovery div 100;
        //命中
        if item.rLifeDataBasic.accuracy <> 0 then
          aLifeData.accuracy := item.rLifeDataBasic.accuracy * pJobUpgrade.accuracy div 100;
        //攻击
        if item.rLifeDataBasic.damageBody <> 0 then
          aLifeData.damageBody := item.rLifeDataBasic.damageBody * pJobUpgrade.damageBody div 100;
        if item.rLifeDataBasic.damageHead <> 0 then
          aLifeData.damageHead := item.rLifeDataBasic.damageHead * pJobUpgrade.damageHead div 100;
        if item.rLifeDataBasic.damageArm <> 0 then
          aLifeData.damageArm := item.rLifeDataBasic.damageArm * pJobUpgrade.damageArm div 100;
        if item.rLifeDataBasic.damageLeg <> 0 then
          aLifeData.damageLeg := item.rLifeDataBasic.damageLeg * pJobUpgrade.damageLeg div 100;
        //防御
        if item.rLifeDataBasic.armorBody <> 0 then
          aLifeData.armorBody := item.rLifeDataBasic.armorBody * pJobUpgrade.armorBody div 100;
        if item.rLifeDataBasic.armorHead <> 0 then
          aLifeData.armorHead := item.rLifeDataBasic.armorHead * pJobUpgrade.armorHead div 100;
        if item.rLifeDataBasic.armorArm <> 0 then
          aLifeData.armorArm := item.rLifeDataBasic.armorArm * pJobUpgrade.armorArm div 100;
        if item.rLifeDataBasic.armorLeg <> 0 then
          aLifeData.armorLeg := item.rLifeDataBasic.armorLeg * pJobUpgrade.armorLeg div 100;

        GatherLifeData(item.rLifeDataLevel, aLifeData);
      end;
//      //强化属性配置
//      case item.rSmithingLevel of
//        1:
//          begin
//            mul := 4;
//            mulx := 0;
//          end;
//        2:
//          begin
//            mul := 2;
//            mulx := 0;
//          end;
//        3:
//          begin
//            mul := 1;
//            mulx := 0;
//          end;
//        4:
//          begin
//            mul := 2;
//            mulx := 1;
//          end;
//        5: //2
//          begin
//            mul := 1;
//            mulx := 1;
//          end;
//        6: //2.25
//          begin
//            mul := 4;
//            mulx := 2;
//          end;
//        7: //2.5
//          begin
//            mul := 2;
//            mulx := 2;
//          end;
//        8: //3
//          begin
//            mul := 1;
//            mulx := 2;
//          end;
//        9: //3.25
//          begin
//            mul := 4;
//            mulx := 3;
//          end;
//        10: //4
//          begin
//            mul := 1;
//            mulx := 3;
//          end;
//      end;
//      if item.rSmithingLevel <> 0 then
//      begin
//        if item.rLifeDataBasic.damageBody <> 0 then
//          aLifeData.damageBody := item.rLifeDataBasic.damageBody div mul + item.rLifeDataBasic.damageBody * mulx;
//
//        if item.rLifeDataBasic.damageHead <> 0 then
//          aLifeData.damageHead := item.rLifeDataBasic.damageHead div mul + item.rLifeDataBasic.damageHead * mulx;
//        if item.rLifeDataBasic.damageArm <> 0 then
//          aLifeData.damageArm := item.rLifeDataBasic.damageArm div mul + item.rLifeDataBasic.damageArm * mulx;
//        if item.rLifeDataBasic.damageLeg <> 0 then
//          aLifeData.damageLeg := item.rLifeDataBasic.damageLeg div mul + item.rLifeDataBasic.damageLeg * mulx;
//
//        if item.rLifeDataBasic.armorBody <> 0 then
//          aLifeData.armorBody := item.rLifeDataBasic.armorBody div mul + item.rLifeDataBasic.armorBody * mulx;
//        if item.rLifeDataBasic.armorHead <> 0 then
//          aLifeData.armorHead := item.rLifeDataBasic.armorHead div mul + item.rLifeDataBasic.armorHead * mulx;
//        if item.rLifeDataBasic.armorArm <> 0 then
//          aLifeData.armorArm := item.rLifeDataBasic.armorArm div mul + item.rLifeDataBasic.armorArm * mulx;
//        if item.rLifeDataBasic.armorLeg <> 0 then
//          aLifeData.armorLeg := item.rLifeDataBasic.armorLeg div mul + item.rLifeDataBasic.armorLeg * mulx;
//        if item.rLifeDataBasic.avoid <> 0 then
//          aLifeData.avoid := item.rLifeDataBasic.avoid div mul + item.rLifeDataBasic.avoid * mulx;
//        if item.rLifeDataBasic.accuracy <> 0 then
//          aLifeData.accuracy := item.rLifeDataBasic.accuracy div mul + item.rLifeDataBasic.accuracy * mulx;
//        if item.rLifeDataBasic.HitArmor <> 0 then
//          aLifeData.HitArmor := item.rLifeDataBasic.HitArmor div mul + item.rLifeDataBasic.HitArmor * mulx;
//
//        GatherLifeData(item.rLifeDataLevel, aLifeData);
//      end;

    end;
  end;
  //附加 属性
  if item.rAttach > 0 then
    item.rLifeDataAttach := AttachClass.get(item.rAttach);
  //=========================================================================
  //物品 属性
  FillChar(item.rLifeData, sizeof(TLifeData), 0);
  GatherLifeData(item.rLifeData, item.rLifeDataBasic);
  GatherLifeData(item.rLifeData, item.rLifeDataLevel);
  GatherLifeData(item.rLifeData, item.rLifeDataSetting);
  GatherLifeData(item.rLifeData, item.rLifeDataAttach);
end;
//从DB中读出来物品

procedure CopyDBItemToItem(var Source: TDBItemData; var DEST: TItemData);
var
  STR: string;
begin

  STR := (source.rName);
  if (source.rCount <= 0) or (source.rName = '') then
  begin
    FillChar(DEST, sizeof(TItemData), 0);
    exit;
  end;
  if ItemClass.GetItemData(str, DEST) = false then
  begin

    exit;
  end;

  dest.rID := Source.rId;
  dest.rCount := Source.rCount;

  if DEST.rKind = 1 then //1是颜色物品  颜色使用数据库的
  begin

  end
  else
    dest.rcolor := Source.rColor;
  dest.rCurDurability := Source.rDurability;
  dest.rDurability := Source.rDurabilityMAX;
  dest.rSmithingLevel := Source.rSmithingLevel;
  dest.rAttach := Source.rAttach; //附加属性
  dest.rlockState := Source.rlockState;
  dest.rlocktime := Source.rlocktime;
  dest.rSetting := Source.rSetting;
  dest.rDateTime := source.rDateTime;
  //    dest.rLifeDataLevel := Source.rLifeDataLevel;
  DEST.rboident := Source.rBoident;
  DEST.rStarLevel := Source.rStarLevel;
  DEST.rboBlueprint := Source.rboBlueprint;
  DEST.rSpecialExp := Source.rSpecialExp;
  DEST.rcreatename := Source.rCreateName;
  //镶嵌 宝石 计算属性
  ItemLifeDataUPdate(DEST); //计算附加属性
end;

//完整物品 到 DB简易
 //物品存入DB

procedure CopyItemToDBItem(var Source: TItemData; var DEST: TDBItemData);
var
  STR: string;
begin

  STR := (source.rName);
  DEST.rName := str;
  dest.rID := Source.rId;
  dest.rCount := Source.rCount;
  dest.rcolor := Source.rColor;
  dest.rDurability := Source.rCurDurability;
  dest.rDurabilityMAX := Source.rDurability;
  dest.rSmithingLevel := Source.rSmithingLevel;
  dest.rAttach := Source.rAttach;
  dest.rlockState := Source.rlockState;
  dest.rlocktime := Source.rlocktime;
  dest.rSetting := Source.rSetting;
  dest.rDateTime := source.rDateTime;
  DEST.rBoident := Source.rboident;
  DEST.rStarLevel := Source.rStarLevel;
  DEST.rboBlueprint := Source.rboBlueprint;
  DEST.rcreatename := Source.rCreateName;
  //    dest.rLifeDataLevel := Source.rLifeDataLevel;
  DEST.rSpecialExp := Source.rSpecialExp;
end;

function GetPermitExp(aLevel, addvalue: integer): integer;
var
  p: PTLevelData;
  n: integer;
begin
  Result := 0;
  if alevel < 100 then
    alevel := 100;
  if alevel >= 9999 then
    exit;

  n := (alevel div 100);
  p := PTLevelData(@LevelsArr);
  inc(p, n - 1);
  n := p.rGetMaxExp;
  if n > addvalue then
    n := addvalue;
  Result := n;
end;
{
var
    n: integer;
begin
    n := GetLevelMaxExp(aLevel);
    if n > addvalue then n := addvalue;
    Result := n;
end; }

function clearlevel(var aLevel, aExp: integer): integer; //等级清零
begin
  dec(aExp, aExp);
  aLevel := GetLevel(aExp);
  result := aLevel;
end;

function _AddExpNotLevelMax(var aLevel, aExp: integer; addvalue: integer): integer;
begin
  Result := addvalue;
  inc(aExp, addvalue);
  if (aexp >= 1085138172) or (aexp < 0) then
  begin
    aexp := 1085138172;
    aLevel := 9999;
    exit;
  end;
  aLevel := GetLevel(aExp);
end;
{
function AddPermitExp(var aLevel, aExp: integer; addvalue: integer): integer;
var
    n: integer;
begin
    n := GetLevelMaxExp(aLevel) * vAddMagicExp_MaxExp;                          //原始 是*3
    if n > addvalue then n := addvalue;
    inc(aExp, n);
    aLevel := GetLevel(aExp);
    Result := n;

    {  // 沥惑
       n := GetLevelMaxExp (aLevel);
       if n > addvalue then n := addvalue;
       inc (aExp, n);
       aLevel := GetLevel (aExp);
       Result := n;
    }
    {  // 傈何倾侩
       n := GetLevelMaxExp (aLevel);
       if n <> 0 then n := addvalue;
       inc (aExp, n);
       aLevel := GetLevel (aExp);
       Result := n;
                }{
end;
}

//类型 ，等级，经验，增加值，翻倍数量

function _AddExp(aAddExpType: TAddExpType; var aLevel, aExp: integer; addvalue, aMulExp: integer; aMagicExp: integer = 0): integer;
var
  n, BMaxExp, aMaxExp, Baddvalue, rm: integer;
  p: PTLevelData;
begin
  Result := 0;
  if alevel < 100 then
    alevel := 100;
  if alevel >= 9999 then
    exit;

  n := (alevel div 100);
  p := PTLevelData(@LevelsArr);
  inc(p, n - 1);
  //最多可增加经验
  BMaxExp := p.rGetMaxExp;
  Baddvalue := addvalue;
  //翻倍后经验
  aMaxExp := p.rGetMaxExp * vAddMagicExp_MaxExp;

  case aAddExpType of
    _aet_Attack: //攻击性武功
      begin
        if aMagicExp > 0 then
        begin
          addvalue := addvalue * aMagicExp;
          aMaxExp := aMaxExp * aMagicExp;
        end
        else
        begin
          addvalue := addvalue * vAddMagicExp_AttackMagic;
          aMaxExp := aMaxExp * vAddMagicExp_AttackMagic;
        end;
      end;
    _aet_ect: //辅助武功
      begin
        if aMagicExp > 0 then
        begin
          addvalue := addvalue * aMagicExp;
          aMaxExp := aMaxExp * aMagicExp;
        end
        else
        begin
          addvalue := addvalue * vAddMagicExp_EctMagic;
          aMaxExp := aMaxExp * vAddMagicExp_EctMagic;
        end;
      end;
    _aet_Running: //步法
      begin
        if aMagicExp > 0 then
        begin
          addvalue := addvalue * aMagicExp;
          aMaxExp := aMaxExp * aMagicExp;
        end
        else
        begin
          addvalue := addvalue * vAddMagicExp_RunningMagic;
          aMaxExp := aMaxExp * vAddMagicExp_RunningMagic;
        end;
      end;
    _aet_Protecting: //护体
      begin
        if aMagicExp > 0 then
        begin
          addvalue := addvalue * aMagicExp;
          aMaxExp := aMaxExp * aMagicExp;
        end
        else
        begin
          addvalue := addvalue * vAddMagicExp_ProtectingMagic;
          aMaxExp := aMaxExp * vAddMagicExp_ProtectingMagic;
        end;
      end;
    _aet_Breathng: //心法
      begin
        if aMagicExp > 0 then
        begin
          addvalue := addvalue * aMagicExp;
          aMaxExp := aMaxExp * aMagicExp;
        end
        else
        begin
          addvalue := addvalue * vAddMagicExp_BreathngMagic;
          aMaxExp := aMaxExp * vAddMagicExp_BreathngMagic;
        end;
      end;
    _aet_virtue: //浩然翻倍
      begin
        addvalue := addvalue * vAddVirtueExp;
        aMaxExp := aMaxExp * vAddVirtueExp;
      end;
  end;
 // aMulExp:=5;// 2013 修改5倍
  //再翻倍（玩家倍数）
  if aMulExp > 0 then
  begin
    addvalue := addvalue * aMulExp;
    aMaxExp := aMaxExp * aMulExp;
  end;

  if aMaxExp > addvalue then
    aMaxExp := addvalue;
 // FrmMain.WriteLogInfo('aMaxExp = ' + inttostr(aMaxExp) + 'addvalue' + inttostr(addvalue));
  inc(aExp, aMaxExp);

  if BMaxExp > Baddvalue then
    BMaxExp := Baddvalue;
  Result := BMaxExp;
  if (aexp >= 1085138172) or (aexp < 0) then
  begin
    aexp := 1085138172;
    aLevel := 9999;
    exit;
  end;

  if aExp > (p.rexp + p.rgap) then
  begin
    aLevel := GetLevel(aExp);
    exit;
  end;

  //本级 计算后两位
  rm := aexp - p.rexp;
  if p.rexp > 10000000 then
  begin
    rm := rm div 100;
    aLevel := p.rlevel * 100 + rm * 100 div (p.rgap div 100);
  end
  else
  begin
    aLevel := p.rlevel * 100 + rm * 100 div p.rgap;
  end;

end;
{
function _AddAttackExp(var aLevel, aExp: integer; addvalue: integer): integer;
var
    n: integer;
begin
    n := GetLevelMaxExp(aLevel) * vAddMagicExp_MaxExp;
    addvalue := addvalue * vAddMagicExp_AttackMagic;
    if n > addvalue then n := addvalue;
    inc(aExp, n);
    aLevel := GetLevel(aExp);
    Result := n;
end;

function _AddBreathngExp(var aLevel, aExp: integer; addvalue: integer): integer;
var
    n: integer;
begin
    n := GetLevelMaxExp(aLevel) * vAddMagicExp_MaxExp;
    addvalue := addvalue * vAddMagicExp_BreathngMagic;
    if n > addvalue then n := addvalue;
    inc(aExp, n);
    aLevel := GetLevel(aExp);
    Result := n;
end;

function _AddRunningExp(var aLevel, aExp: integer; addvalue: integer): integer;
var
    n: integer;
begin
    n := GetLevelMaxExp(aLevel) * vAddMagicExp_MaxExp;
    addvalue := addvalue * vAddMagicExp_RunningMagic;
    if n > addvalue then n := addvalue;
    inc(aExp, n);
    aLevel := GetLevel(aExp);
    Result := n;
end;

function _AddProtectingExp(var aLevel, aExp: integer; addvalue: integer): integer;
var
    n: integer;
begin
    n := GetLevelMaxExp(aLevel) * vAddMagicExp_MaxExp;
    addvalue := addvalue * vAddMagicExp_ProtectingMagic;
    if n > addvalue then n := addvalue;
    inc(aExp, n);
    aLevel := GetLevel(aExp);
    Result := n;
end;

function _AddEctExp(var aLevel, aExp: integer; addvalue: integer): integer;
var
    n: integer;
begin
    n := GetLevelMaxExp(aLevel) * vAddMagicExp_MaxExp;
    addvalue := addvalue * vAddMagicExp_EctMagic;
    if n > addvalue then n := addvalue;
    inc(aExp, n);
    aLevel := GetLevel(aExp);
    Result := n;
end;

function Get10000To100(avalue: integer): string;
var
    n: integer;
    str: string;
begin
    str := InttoStr(avalue div 100) + '.';
    n := avalue mod 100;
    if n >= 10 then str := str + IntToStr(n)
    else str := str + '0' + InttoStr(n);

    Result := str;
end;

function Get10000To120(avalue: integer): string;
var
    n: integer;
    str: string;
begin
    avalue := avalue * 12 div 10;
    str := InttoStr(avalue div 100) + '.';
    n := avalue mod 100;
    if n >= 10 then str := str + IntToStr(n)
    else str := str + '0' + InttoStr(n);

    Result := str;
end;
}
///////////////////////////////////
//         TExChange
///////////////////////////////////

function TExChange.IsCheck: boolean; //确定 状态
begin
  result := fdata.rboCheck;
end;

procedure TExChange.SendEnd;
var
  i: integer;
begin
  for i := 0 to high(fdata.rItems) do
  begin //查是否
    if fdata.rItems[i].ritem.rName <> '' then
    begin
      fdata.rItems[i].rsend := false;
    end;
  end;
end;

function TExChange.count(): integer; //件
var
  i: integer;
begin
  result := 0;

  for i := 0 to high(fdata.rItems) do
  begin //查是否
    if fdata.rItems[i].ritem.rName <> '' then
    begin
      inc(result);
    end;
  end;
end;

function TExChange.IsSpace: boolean; //TRUE 有空位置
var
  i: integer;
begin
  result := false;

  for i := 0 to high(fdata.rItems) do
  begin //查是否
    if fdata.rItems[i].ritem.rName = '' then
    begin
      result := true;
      exit;
    end;
  end;
end;

function TExChange.getname(aname: string): pTExChangeItem;
var
  i: integer;
begin
  result := nil;
  for i := 0 to high(fdata.rItems) do
  begin //查是否
    if (aname) = fdata.rItems[i].ritem.rName then
    begin
      result := @fdata.rItems[i].ritem;
      exit;

    end;
  end;
end;

function TExChange.del(akey: integer): boolean;
begin
  result := false;
  if (akey < 0) or (akey > high(fdata.rItems)) then
    exit;
  fillchar(fdata.rItems[akey], sizeof(TExChangeItem), 0);
  fdata.rItems[akey].rsend := true;

  result := true;
end;

function TExChange.add(akey: integer; aitem: tItemData): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to high(fdata.rItems) do
  begin //查是否
    if fdata.rItems[i].ritem.rName = '' then
    begin
      result := true;
      fdata.rItems[i].ritem := aitem;
      fdata.rItems[i].rkey := akey;
      fdata.rItems[I].rsend := true;
      exit;
    end;
  end;
end;

function TExChange.get(aindex: integer): pTExChangeItem;
begin
  result := nil;
  if (aindex < 0) or (aindex > high(fdata.rItems)) then
    exit;
  result := @fdata.rItems[aindex];
end;

procedure TExChange.setExChange(aid: integer; aname: string);
begin
  fdata.rExChangeId := aid;
  fdata.rExChangeName := aname;
end;

function TExChange.isstate: boolean;
begin
  result := fdata.rExChangeId <> 0;
end;

procedure TExChange.Clear();
var
  i: integer;
begin
  FillChar(fdata, sizeof(TExChangeData), 0);
end;

constructor TExChange.Create;
begin
  inherited Create;
  Clear;
  MsgList := TResponsion.Create; //应答列表
end;

destructor TExChange.Destroy;
begin
  MsgList.Free;
  inherited destroy;
end;
///////////////////////////////////
//         TAttribClass
///////////////////////////////////

constructor TAttribClass.Create(aBasicObject: TBasicObject; aSendClass: TSendClass);
begin
  fillchar(AttribQuestData, sizeof(AttribQuestData), 0);
  PowerLevelMax := 0;
  HaveItemCLife := 0;
  WearItemCLife := 0;
  PowerShieldBoState := false;
  PowerShieldTick := 0;
  PowerShieldLife := 0;
  PowerShieldLifeMax := 0; //活力
  PowerShieldArmor := 0;

  PowerLevel := 0;
  PowerLevelPdata := nil;
  FBasicObject := aBasicObject;
  boAddExp := true;
  ReQuestPlaySoundNumber := 0;
  FSendClass := aSendClass;
end;

destructor TAttribClass.Destroy;
begin
  inherited Destroy;
end;

procedure TAttribClass.SetLifeData;
begin //暂时 废弃没使用
  {FillChar(AttribLifeData, sizeof(TLifeData), 0);

  AttribLifeData.damageBody := 41;
  AttribLifeData.damageHead := 41;
  AttribLifeData.damageArm := 41;
  AttribLifeData.damageLeg := 41;
  AttribLifeData.AttackSpeed := 70;
  AttribLifeData.avoid := 25;
  AttribLifeData.recovery := 50;
  AttribLifeData.armorBody := 0;
  AttribLifeData.armorHead := 0;
  AttribLifeData.armorArm := 0;
  AttribLifeData.armorLeg := 0;
  }
  TUserObject(FBasicObject).SetLifeData;
end;

function TAttribClass.GetAge: Integer;
begin
  //    Result := AttribData.cAge;
  Result := AttribData.cAge + AttribQuestData.Age;
end;

function TAttribClass.GetCurHeadLife: integer;
begin
  Result := CurAttribData.CurHeadSeak;
end;

function TAttribClass.GetCurArmLife: integer;
begin
  Result := CurAttribData.CurArmSeak;
end;

function TAttribClass.GetCurLegLife: integer;
begin
  Result := CurAttribData.CurLegSeak;
end;

function TAttribClass.GetCurLife: integer;
begin
  Result := CurAttribData.CurLife;
end;

function TAttribClass.GetCurMagic: integer;
begin
  Result := CurAttribData.CurMagic;
end;

function TAttribClass.GetCurOutPower: integer;
begin
  Result := CurAttribData.CurOutPower;
end;

function TAttribClass.GetCurInPower: integer;
begin
  Result := CurAttribData.CurInPower;
end;

function TAttribClass.GetMaxLife: integer;
begin
  //    Result := AttribData.cLife;
  Result := AttribData.cLife + AttribQuestData.Life;
end;

procedure TAttribClass.SetCurHeadLife(value: integer);
begin
  if Value < 0 then
    Value := 0;
  if CurAttribData.CurHeadSeak = Value then
    exit;
  CurAttribData.CurHeadSeak := Value;
  //   if CurAttribData.CurHeadSeak > AttribData.cHeadSeak then CurAttribData.CurHeadSeak := AttribData.cHeadSeak;
  if CurAttribData.CurHeadSeak > (AttribData.cHeadSeak + AttribQuestData.HeadSeak) then
    CurAttribData.CurHeadSeak := (AttribData.cHeadSeak + AttribQuestData.HeadSeak);
  boSendValues := TRUE;

end;

procedure TAttribClass.SetCurArmLife(value: integer);
begin
  if Value < 0 then
    Value := 0;
  if CurAttribData.CurArmSeak = Value then
    exit;
  CurAttribData.CurArmSeak := Value;
  //  if CurAttribData.CurArmSeak > AttribData.cArmSeak then CurAttribData.CurArmSeak := AttribData.cArmSeak;
  if CurAttribData.CurArmSeak > (AttribData.cArmSeak + AttribQuestData.ArmSeak) then
    CurAttribData.CurArmSeak := (AttribData.cArmSeak + AttribQuestData.ArmSeak);
  boSendValues := TRUE;

end;

procedure TAttribClass.SetCurLegLife(value: integer);
begin
  if Value < 0 then
    Value := 0;
  if CurAttribData.CurLegSeak = Value then
    exit;
  CurAttribData.CurLegSeak := Value;
  //  if CurAttribData.CurLegSeak > AttribData.cLegSeak then CurAttribData.CurLegSeak := AttribData.cLegSeak;
  if CurAttribData.CurLegSeak > (AttribData.cLegSeak + AttribQuestData.LegSeak) then
    CurAttribData.CurLegSeak := (AttribData.cLegSeak + AttribQuestData.LegSeak);
  boSendValues := TRUE;

end;

procedure TAttribClass.SetCurLife(Value: integer);
begin
  if Value < 0 then
    Value := 0;
  if CurAttribData.CurLife = Value then
    exit;
  CurAttribData.CurLife := Value;
  // if CurAttribData.CurLife > AttribData.cLife then CurAttribData.CurLife := AttribData.cLife;
  if CurAttribData.CurLife > (AttribData.cLife + AttribQuestData.Life) then
    CurAttribData.CurLife := (AttribData.cLife + AttribQuestData.Life);
  boSendBase := TRUE;

end;

procedure TAttribClass.SetCurMagic(Value: integer);
begin
  if Value < 0 then
    Value := 0;
  if CurAttribData.CurMagic = Value then
    exit;
  CurAttribData.CurMagic := Value;
  //  if CurAttribData.CurMagic > AttribData.cMagic then CurAttribData.CurMagic := AttribData.cMagic;
  if CurAttribData.CurMagic > (AttribData.cMagic + AttribQuestData.Magic) then
    CurAttribData.CurMagic := AttribData.cMagic + AttribQuestData.Magic;
  boSendBase := TRUE;

end;

procedure TAttribClass.SetCurInPower(Value: integer);
begin
  if Value < 0 then
    Value := 0;
  if CurAttribData.CurInPower = Value then
    exit;
  CurAttribData.CurInPower := Value;
  //    if CurAttribData.CurInPower > AttribData.cInPower then CurAttribData.CurInPower := AttribData.cInPower;
  if CurAttribData.CurInPower > (AttribData.cInPower + AttribQuestData.InPower) then
    CurAttribData.CurInPower := (AttribData.cInPower + AttribQuestData.InPower);
  boSendBase := TRUE;

end;

procedure TAttribClass.SetCurOutPower(Value: integer);
begin
  if Value < 0 then
    Value := 0;
  if CurAttribData.CurOutPower = Value then
    exit;
  CurAttribData.CurOutPower := Value;
  //    if CurAttribData.CurOutPower > AttribData.cOutPower then CurAttribData.CurOutPower := AttribData.cOutPower;
  if CurAttribData.CurOutPower > (AttribData.cOutPower + AttribQuestData.OutPower) then
    CurAttribData.CurOutPower := (AttribData.cOutPower + AttribQuestData.OutPower);
  boSendBase := TRUE;

end;

function TAttribClass.GetVirtueLevel(): integer;
begin
  result := AttribData.cvirtue;
end;

procedure TAttribClass.SETvirtue(aexp: integer);
begin
  AttribData.virtue := AttribData.virtue + aexp;
  FSendClass.SendEventString('浩然');
  Calculate;
  boSendValues := TRUE;
end;

procedure TAttribClass.addvirtue(aexp, aMaxLevel: integer);
var
  curslevel, oldslevel: integer;
begin

  curslevel := GetLevel(AttribData.virtue);
  //2015年12月22日 09:51:20 修改取消限制浩然等级限制
  //if (aMaxLevel > 0) and (curslevel > aMaxLevel) then
  //  exit;
  oldslevel := curslevel;
 // ShowMessage(IntToStr(AttribData.MagicExpMulCount));
  if _AddExp(_aet_virtue, curslevel, AttribData.virtue, aexp, AttribData.MagicExpMulCount) <> 0 then
  begin
    FSendClass.SendEventString('浩然');
    Calculate;
  end;
  if oldslevel <> curslevel then
    boSendValues := TRUE;
end;

procedure TAttribClass.Setbad(aexp: integer);
begin
  AttribData.badChar := aexp;
  FSendClass.SendEventString('武者职业');
  Calculate;
  boSendBase := TRUE;
end;

procedure TAttribClass.Setluck(aexp: integer);
begin
  AttribData.GoodChar := aexp;
  FSendClass.SendEventString('年龄奖励');
  Calculate;
  boSendBase := TRUE;
end;

procedure TAttribClass.SetTalent(aexp: integer);
begin
  AttribData.Talent := aexp;
  FSendClass.SendEventString('魂点');
  Calculate;
  boSendBase := TRUE;
end;

procedure TAttribClass.SetEnergy(aexp: integer);
begin
  AttribData.Energy := aexp;
 // FSendClass.SendEventString('元气');
  Calculate;
  boSendBase := TRUE;
end;

////////////////

function TAttribClass.Getpetmax(): integer;
begin
  result := AttribData.cpetmax;
end;

function TAttribClass.Getpetname(): string;
begin
  result := AttribData.cpetname;
end;

procedure TAttribClass.Setpetname(aexp: string);
begin
  AttribData.cpetname := aexp;
end;

function TAttribClass.Getpetmagic(): string;
begin
  result := AttribData.cpetmagic;
end;

procedure TAttribClass.Setpetmagic(aexp: string);
begin
  AttribData.cpetmagic := aexp;
end;

procedure TAttribClass.Setpetmax(aexp: integer);
begin
  AttribData.cpetmax := aexp;
end;

function TAttribClass.Getpetgrade(): integer;
begin
  result := AttribData.cpetgrade;
end;

procedure TAttribClass.Setpetgrade(aexp: integer);
begin
  AttribData.cpetgrade := aexp;
end;

function TAttribClass.Getpetexp(): integer;
begin
  result := AttribData.cpetexp;
end;

procedure TAttribClass.Setpetexp(aexp: integer);
begin
  AttribData.cpetexp := aexp;
end;

procedure TAttribClass.addpetexp(aexp: integer);
var
  curslevel, oldslevel: integer;
begin
  // curslevel := GetLevel(AttribData.Energy);
  // oldslevel := curslevel;
  // if AddPermitExp(curslevel, AttribData.Energy, aexp) <> 0 then
  begin
    if aexp <= 0 then
      exit;

    if GetxLevel(AttribData.cpetexp) <= AttribData.cpetmax + 20 then
    begin
      AttribData.cpetexp := AttribData.cpetexp + aexp;

    // AttribData.cl:= GetLevel(AttribData.cpetexp);
      FSendClass.SendEventString('宠物经验提升');
    end
    else
      FSendClass.SendEventString('宠物经验上限');
   // Calculate;
    boSendBase := TRUE;
  end;
  //    if oldslevel <> curslevel then boSendBase := TRUE;
end;
///////////////

procedure TAttribClass.delEnergy(aexp: integer);
var
  curslevel, oldslevel: integer;
begin
  // curslevel := GetLevel(AttribData.Energy);
  // oldslevel := curslevel;
  // if AddPermitExp(curslevel, AttribData.Energy, aexp) <> 0 then
  begin
    if aexp <= 0 then
      exit;
    AttribData.Energy := AttribData.Energy - aexp;
    FSendClass.SendEventString('元气');
    Calculate;
    boSendBase := TRUE;
  end;
  //    if oldslevel <> curslevel then boSendBase := TRUE;
end;
//procedure TAttribClass.addMagicEnery(aexp: integer);
//begin
//    if aexp <= 0 then exit;
//    AttribData.Energy := AttribData.Energy + aexp;
//    Calculate;
//end;

procedure TAttribClass.upEnergy(aexp: integer);
begin
  if aexp < 0 then
    exit;
  AttribData.Energy := aexp;
  Calculate;
  boSendBase := TRUE;
end;

procedure TAttribClass.addEnergy(aexp: integer);
var
  curslevel, oldslevel: integer;
begin
  // curslevel := GetLevel(AttribData.Energy);
  // oldslevel := curslevel;
  // if AddPermitExp(curslevel, AttribData.Energy, aexp) <> 0 then
  begin
    if aexp <= 0 then
      exit;
    AttribData.Energy := AttribData.Energy + aexp;
    FSendClass.SendEventString('元气');
    Calculate;
    boSendBase := TRUE;
  end;
  //    if oldslevel <> curslevel then boSendBase := TRUE;
end;

procedure TAttribClass.AddAdaptive(aexp: integer);
var
  oldslevel: integer;
begin
  if boAddExp = false then
    exit;
  oldslevel := AttribData.cAdaptive;
  if _AddExp(_aet_none, AttribData.cAdaptive, AttribData.Adaptive, DEFAULTEXP, 0) <> 0 then
    FSendClass.SendEventString('耐性');
  if oldslevel <> AttribData.cAdaptive then
    boSendValues := TRUE;
end;

function TAttribClass.CheckRevival: Boolean;
var
  oldslevel: integer;
begin
  Result := FALSE;

  if boAddExp = false then
    exit;

  if boRevivalFlag then
  begin
    if CurAttribData.CurLife <= 0 then
    begin
      oldslevel := AttribData.cRevival;
      if _AddExp(_aet_none, AttribData.cRevival, AttribData.Revival, DEFAULTEXP, 0) <> 0 then
        FSendClass.SendEventString('再生');
      subLucky; //减少幸运
      if oldslevel <> AttribData.cRevival then
        boSendValues := TRUE;

      boRevivalFlag := FALSE;
      boEnergyFlag := FALSE;
      boInPowerFlag := FALSE;
      boOutPowerFlag := FALSE;
      boMagicFlag := FALSE;

      Result := TRUE;
    end;
    exit;
  end;
  if (AttribData.cLife - AttribData.cLife div 10) < CurAttribData.CurLife then
    boRevivalFlag := TRUE;
end;

function TAttribClass.CheckEnegy: Boolean;
var
  curslevel, oldslevel: integer;
begin
  Result := FALSE;

  { if boAddExp = false then exit;

   if boEnergyFlag then
   begin
       if (AttribData.cEnergy - AttribData.cEnergy div 10) < CurAttribData.CurEnergy then
       begin
           curslevel := GetLevel(AttribData.Energy);
           oldslevel := curslevel;
           if AddPermitExp(curslevel, AttribData.Energy, DEFAULTEXP) <> 0 then
               FSendClass.SendEventString('元气');
           if oldslevel <> curslevel then boSendBase := TRUE;
           boEnergyFlag := FALSE;
           Result := TRUE;
       end;
       exit;
   end;
   if (AttribData.cEnergy div 10) > CurAttribData.CurEnergy then boEnergyFlag := TRUE;
   }
end;

function TAttribClass.CheckInPower: Boolean;
var
  curslevel, oldslevel: integer;
begin
  Result := FALSE;

  if boAddExp = false then
    exit;

  if boInPowerFlag then
  begin
    if (AttribData.cInPower - AttribData.cInPower div 10) < CurAttribData.CurInPower then
    begin
      curslevel := GetLevel(AttribData.InPower);
      oldslevel := curslevel;
      if _AddExp(_aet_none, curslevel, AttribData.InPower, DEFAULTEXP, 0) <> 0 then
        FSendClass.SendEventString('内功');
      if oldslevel <> curslevel then
        boSendBase := TRUE;
      boInPowerFlag := FALSE;
      Result := TRUE;
    end;
    exit;
  end;
  if (AttribData.cInPower div 10) > CurAttribData.CurInPower then
    boInPowerFlag := TRUE;
end;

function TAttribClass.CheckOutPower: Boolean;
var
  curslevel, oldslevel: integer;
begin
  Result := FALSE;

  if boAddExp = false then
    exit;

  if boOutPowerFlag then
  begin
    if (AttribData.cOutPower - AttribData.cOutPower div 10) < CurAttribData.CurOutPower then
    begin
      curslevel := GetLevel(AttribData.OutPower);
      oldslevel := curslevel;
      if _AddExp(_aet_none, curslevel, AttribData.OutPower, DEFAULTEXP, 0) <> 0 then
        FSendClass.SendEventString('外功');
      if oldslevel <> curslevel then
        boSendBase := TRUE;
      boOutPowerFlag := FALSE;
      Result := TRUE;
    end;
    exit;
  end;
  if (AttribData.cOutPower div 10) > CurAttribData.CurOutPower then
    boOutPowerFlag := TRUE;
end;

function TAttribClass.CheckMagic: Boolean;
var
  curslevel, oldslevel: integer;
begin
  Result := FALSE;

  if boAddExp = false then
    exit;

  if boMagicFlag then
  begin
    if (AttribData.cMagic - AttribData.cMagic div 10) < CurAttribData.CurMagic then
    begin
      curslevel := GetLevel(AttribData.Magic);
      oldslevel := curslevel;
      if _AddExp(_aet_none, curslevel, AttribData.Magic, DEFAULTEXP, 0) <> 0 then
        FSendClass.SendEventString('武功');
      if oldslevel <> curslevel then
        boSendBase := TRUE;
      boMagicFlag := FALSE;
      Result := TRUE;
    end;
    exit;
  end;
  if (AttribData.cMagic div 10) > CurAttribData.CurMagic then
    boMagicFlag := TRUE;
end;

procedure TAttribClass.setprestige(value: integer);
begin
  AttribData.prestige := value;
  FSendClass.SendAttribUPDATE(aut_rprestige, value);
end;

function TAttribClass.getprestige(): integer;
begin
  result := AttribData.prestige;
end;

procedure TAttribClass.LoadFromSdb(aCharData: PTDBRecord); //加载人物结构数据
begin

  //////////////////////////////////////////////////////////////////
  ReQuestPlaySoundNumber := 0;
  StartTick := mmAnsTick;
  FFeatureState := wfs_normal;

  boRevivalFlag := FALSE;
  boEnergyFlag := FALSE;
  boInPowerFlag := FALSE;
  boOutPowerFlag := FALSE;
  boMagicFlag := FALSE;

  FillChar(AttribData, sizeof(AttribData), 0);
  FillChar(CurAttribData, sizeof(CurAttribData), 0);
  FillChar(ItemDrugArr, sizeof(ItemDrugArr), 0);

  CheckIncreaseTick := StartTick;
  CheckDrugTick := StartTick;
  CheckLuckyTick := StartTick;
  boMan := FALSE;

  boMan := false;
  if (aCharData^.Sex) = true then
    boMan := true;
  //
  AttribData.Light := aCharData^.Light;
  AttribData.Dark := aCharData^.Dark;
  AttribData.Age := AttribData.Light + AttribData.Dark;
  AttribData.Energy := aCharData^.Energy;
  AttribData.InPower := aCharData^.InPower;
  AttribData.OutPower := aCharData^.OutPower;
  AttribData.Magic := aCharData^.Magic;
  AttribData.Life := aCharData^.Life;

  AttribData.r3f_sky := aCharData^.r3f_sky;
  AttribData.r3f_terra := aCharData^.r3f_terra;
  AttribData.r3f_fetch := aCharData^.r3f_fetch;
////////////////////////////////////////// 宠物数据
  AttribData.cpetname := aCharData^.petname;
  AttribData.cpetgrade := achardata^.petgrade;
  AttribData.cpetmax := achardata^.petmax;
  AttribData.cpetexp := achardata^.petexp;
  AttribData.cpetmagic := achardata^.petmagic;
/////////////////////////////////////
  with AttribData do
  begin
    Talent := aCharData^.Talent;
    GoodChar := aCharData^.GoodChar;
    BadChar := aCharData^.BadChar;
    {
          str := UserData.GetFieldValueString (aName, '制造日期');
          if str <> '' then begin
             try
                lucky := Round (Date - StrToDate (str)) mod 50 + 50;
             except
                lucky := 50;
             end;
          end else begin
             lucky := 50;
          end;
    }
    lucky := aCharData^.lucky;
    adaptive := aCharData^.Adaptive;
    revival := aCharData^.Revival;
    immunity := aCharData^.Immunity;
    virtue := aCharData^.Virtue;
  end;

  CurAttribData.CurEnergy := aCharData^.CurEnergy;
  CurAttribData.CurInPower := aCharData^.CurInPower;
  CurAttribData.CurOutPower := aCharData^.CurOutPower;
  CurAttribData.CurMagic := aCharData^.CurMagic;
  CurAttribData.CurLife := aCharData^.CurLife;
  CurAttribData.Curhealth := aCharData^.CurHealth;
  CurAttribData.Cursatiety := aCharData^.CurSatiety;
  CurAttribData.Curpoisoning := aCharData^.CurPoisoning;
  CurAttribData.CurHeadSeak := aCharData^.CurHeadSeek;
  CurAttribData.CurArmSeak := aCharData^.CurArmSeek;
  CurAttribData.CurLegSeak := aCharData^.CurLegSeek;

  prestige := aCharData.prestige;

  GuildPoint := aCharData^.guildPoint;
  AttribData.newTalent := aCharData^.newTalent;
  //nirendao 测试用 需要删除
  //if AttribData.newTalent < 100 then
  //  AttribData.newTalent := 10000;
  AttribData.newTalentExp := aCharData^.newTalentExp;
  AttribData.newTalentLv := aCharData^.newTalentLv;
  caclTalentlv;
  Calculate;

  VipUseLevel := aCharData^.VipUseLevel; //VIP等级
  VipUseTime := aCharData^.VipUseTime; //VIP时间

  AddableStatePoint := aCharData^.AddableStatePoint; //强化祝福值

  MagicExpMulCount := aCharData^.MagicExpMulCount; //双倍 倍数
  MagicExpMulEndTime := aCharData^.MagicExpMulEndTime; //新增倍数剩余时间 秒

  FSendClass.SendAttribBase(AttribData, CurAttribData, AttribQuestData);
  FSendClass.SendAttribValues(AttribData, CurAttribData, AttribQuestData);
  boSendBase := FALSE;
  boSendValues := FALSE;
end;

procedure TAttribClass.SaveToSdb(aCharData: PTDBRecord); //保存人物结构数据
var
  n: integer;
begin
  if GrobalLightDark = gld_light then
  begin
    //保存阳气地方
    n := aCharData^.Light;
    n := n + ((mmAnsTick - StartTick) div 100 * vAge_Exp);
    aCharData^.Light := n;
  end
  else
  begin
    n := aCharData^.Dark;
    n := n + (mmAnsTick - StartTick) div 100 * vAge_Exp;
    aCharData^.Dark := n;
  end;
  aCharData^.guildPoint := AttribData.guildPoint;
  aCharData^.prestige := AttribData.prestige;
  aCharData^.CurEnergy := CurAttribData.CurEnergy;
  aCharData^.CurInPower := CurAttribData.CurInPower;
  aCharData^.CurOutPower := CurAttribData.CurOutPower;
  aCharData^.CurMagic := CurAttribData.CurMagic;
  aCharData^.CurLife := CurAttribData.CurLife;
  aCharData^.CurHealth := CurAttribData.Curhealth;
  aCharData^.CurSatiety := CurAttribData.Cursatiety;
  aCharData^.CurPoisoning := CurAttribData.Curpoisoning;
  aCharData^.CurHeadSeek := CurAttribData.CurHeadSeak;
  aCharData^.CurArmSeek := CurAttribData.CurArmSeak;
  aCharData^.CurLegSeek := CurAttribData.CurLegSeak;

  aCharData^.Energy := AttribData.Energy;
  aCharData^.InPower := AttribData.InPower;
  aCharData^.OutPower := AttribData.OutPower;
  aCharData^.Magic := AttribData.Magic;
  aCharData^.Life := AttribData.Life;

  aCharData^.r3f_sky := AttribData.r3f_sky;
  aCharData^.r3f_terra := AttribData.r3f_terra;
  aCharData^.r3f_fetch := AttribData.r3f_fetch;
////////////////////////////////////////// 宠物数据
  aCharData^.petname := AttribData.cpetname;
  achardata^.petgrade := AttribData.cpetgrade;
  achardata^.petmax := AttribData.cpetmax;
  achardata^.petexp := AttribData.cpetexp;
  achardata^.petmagic := AttribData.cpetmagic;
  achardata^.lucky := AttribData.lucky;
  //天赋数据
  achardata^.newTalent := AttribData.newTalent;
  achardata^.newTalentExp := AttribData.newTalentExp;
  achardata^.newTalentLv := AttribData.newTalentLv;
  //VIP
  achardata^.VipUseLevel := AttribData.VipUseLevel;
  achardata^.VipUseTime := AttribData.VipUseTime;
  //强化祝福值
  achardata^.AddableStatePoint := AttribData.AddableStatePoint;
  //双倍经验
  achardata^.MagicExpMulCount := AttribData.MagicExpMulCount;
  achardata^.MagicExpMulEndTime := AttribData.MagicExpMulEndTime;

/////////////////////////////////////
  with AttribData do
  begin
    aCharData^.Talent := Talent;
    aCharData^.GoodChar := GoodChar;
    aCharData^.BadChar := BadChar;
    aCharData^.Adaptive := adaptive;
    aCharData^.Revival := revival;
    aCharData^.Immunity := immunity;
    aCharData^.Virtue := virtue;
  end;

  StartTick := mmAnsTick;

  AttribData.Light := aCharData^.Light;
  AttribData.Dark := aCharData^.Dark;
  AttribData.Age := AttribData.Light + AttribData.Dark;

  Calculate;
end;

procedure TAttribClass.SetPowerLevelPdata(value: pTPowerLeveldata);
begin
  FPowerLevelPdata := value;
  if value <> nil then
  begin
    PowerShieldLifeMax := value.ShieldLife;
    PowerShieldArmor := value.ShieldArmor;
  end
  else
  begin
    PowerShieldLifeMax := 0;
    PowerShieldArmor := 0;
  end;
  Calculate;
  boSendValues := TRUE;
  boSendBase := TRUE;
end;

procedure TAttribClass.setHaveItemCLife(aLife: integer);
begin
  if HaveItemCLife <> aLife then
  begin
    HaveItemCLife := aLife;
    Calculate;
    boSendValues := TRUE;
    boSendBase := TRUE;
  end;
end;

procedure TAttribClass.setWearItemCLife(aLife: integer);
begin
  if WearItemCLife <> aLife then
  begin
    WearItemCLife := aLife;
    Calculate;
    boSendValues := TRUE;
    boSendBase := TRUE;
  end;
end;

procedure TAttribClass.Calculate;
begin
  FillChar(AttribLifeData, sizeof(TLifeData), 0);

  AttribLifeData.damageBody := 41;
  AttribLifeData.damageHead := 41;
  AttribLifeData.damageArm := 41;
  AttribLifeData.damageLeg := 41;

  AttribLifeData.armorBody := 0;
  AttribLifeData.armorHead := 0;
  AttribLifeData.armorArm := 0;
  AttribLifeData.armorLeg := 0;

  AttribLifeData.accuracy := 0;
  AttribLifeData.AttackSpeed := 70;
  AttribLifeData.avoid := 25;
  AttribLifeData.recovery := 50;

  //新增加  基本
  //GetLevel(AttribData.Energy) + 500; // 扁夯盔扁 = 5.00
  AttribData.cInPower := GetLevel(AttribData.InPower) + 1000; // 扁夯郴傍 = 10.00
  AttribData.cOutPower := GetLevel(AttribData.OutPower) + 1000;
  // 扁夯寇傍 = 10.00
  AttribData.cMagic := GetLevel(AttribData.Magic) + 500; // 扁夯公傍 = 5.00
  AttribData.cLife := GetLevel(AttribData.Life) + 2000; // 扁夯劝仿 = 20.00
  AttribData.cAge := GetLevel(AttribData.Age); //年龄
  AttribData.cLight := GetLevel(AttribData.Light + 664); // 剧沥扁
  AttribData.cDark := GetLevel(AttribData.Dark + 664); // 澜沥扁
  //新增加  基本

  // 郴傍 = 扁夯郴傍 (10) + 唱捞(50) + ...
  AttribData.cInPower := AttribData.cInPower + (AttribData.cAge div 2);
  // 寇傍 = 扁夯寇傍 (10) + 唱捞(50) + ...
  AttribData.cOutPower := AttribData.cOutPower + (AttribData.cAge div 2);
  // 公傍 = 扁夯公傍 (10) + 唱捞(50) + ...
  AttribData.cMagic := AttribData.cMagic + (AttribData.cAge div 2);
  // 劝仿 = 扁夯劝仿(20) + 唱捞(100) + 流诀劝仿 + ...
  AttribData.cLife := AttribData.cLife + AttribData.cAge;
  //境界增加 活力
  if PowerLevelPdata <> nil then
    AttribData.cLife := AttribData.cLife + PowerLevelPdata.Life;
  //戒指增加 活力 、装备增加活力
  AttribData.cLife := AttribData.cLife + HaveItemCLife + WearItemCLife;

  with AttribData do
  begin
    cTalent := GetLevel(Talent) + (AttribData.cAge div 2);
    cGoodChar := GetLevel(GoodChar);
    cBadChar := GetLevel(BadChar);
    //      clucky := GetLevel (lucky);
    clucky := lucky;
    cadaptive := GetLevel(adaptive);
    crevival := GetLevel(revival);
    cimmunity := GetLevel(immunity);
    cvirtue := GetLevel(virtue);

    cHeadSeak := cLife;
    cArmSeak := cLife;
    cLegSeak := cLife;

    cHealth := cLife;
    cSatiety := cLife;
    cPoisoning := cLife;

  end;
    // 盔扁 = 扁夯盔扁(5) + 唱捞(50) + 距(20) + 畴仿(25);
  //15.8.15 nirendao
  //  SetLifeData;
//   AQCalculate;
  //元气计算
  AttribData.cEnergy := (AttribData.Energy); // + 500;
  //获取境界等级
  PowerLevelMax := PowerLevelClass.getMax(AttribData.cEnergy);
end;

procedure TAttribClass.AQCalculate;
begin
  GatherLifeData(AttribLifeData, AttribQuestData.AttribLifeData);
  AttribData.cAge := AttribData.cAge + AttribQuestData.Age; //年龄
  AttribData.cLight := AttribData.cLight + AttribQuestData.Light; //阳气
  AttribData.cDark := AttribData.cDark + AttribQuestData.Dark; //阴气
  AttribData.cvirtue := AttribData.cvirtue + AttribQuestData.virtue; //浩然
  AttribData.cadaptive := AttribData.cadaptive + AttribQuestData.adaptive; //耐性
  AttribData.cRevival := AttribData.cRevival + AttribQuestData.Revival; //再生
  AttribData.cEnergy := AttribData.cEnergy + AttribQuestData.Energy; //元气
  AttribData.cInPower := AttribData.cInPower + AttribQuestData.InPower; //内功
  AttribData.cOutPower := AttribData.cOutPower + AttribQuestData.OutPower; //外功
  AttribData.cMagic := AttribData.cMagic + AttribQuestData.Magic; //武功
  AttribData.cLife := AttribData.cLife + AttribQuestData.Life; //活力 生命
  AttribData.cHeadSeak := AttribData.cHeadSeak + AttribQuestData.HeadSeak; //头
  AttribData.cArmSeak := AttribData.cArmSeak + AttribQuestData.ArmSeak; //手
  AttribData.cLegSeak := AttribData.cLegSeak + AttribQuestData.LegSeak; //脚
  AttribData.cHealth := AttribData.cHealth + AttribQuestData.Health;
  //健康  （翻译）自己定义（健康）
  AttribData.cSatiety := AttribData.cSatiety + AttribQuestData.Satiety;
  //厌腻  （翻译）自己定义（饱和）
  AttribData.cPoisoning := AttribData.cPoisoning + AttribQuestData.Poisoning;
  //施毒法（翻译）自己定义（中毒）
  AttribData.cTalent := AttribData.cTalent + AttribQuestData.Talent; //才能
  AttribData.cGoodChar := AttribData.cGoodChar + AttribQuestData.GoodChar; //神性
  AttribData.cBadChar := AttribData.cBadChar + AttribQuestData.BadChar; //魔性
  AttribData.clucky := AttribData.clucky + AttribQuestData.lucky;
  //幸运  运气 （翻译）
  AttribData.cimmunity := AttribData.cimmunity + AttribQuestData.immunity; //免疫

  //  AttribData.prestige := AttribData.prestige + AttribQuestData.prestige;      //荣誉
        //三魂六魄
  AttribData.r3f_sky := AttribData.r3f_sky + AttribQuestData.r3f_sky; //天
  AttribData.r3f_terra := AttribData.r3f_terra + AttribQuestData.r3f_terra; //地
  AttribData.r3f_fetch := AttribData.r3f_fetch + AttribQuestData.r3f_fetch; //魂
end;

procedure TAttribClass.set3f_fetch(avalue: integer);
begin
  AttribData.r3f_fetch := avalue;
end;

procedure TAttribClass.set3f_sky(avalue: integer);
begin
  AttribData.r3f_sky := avalue;
end;

procedure TAttribClass.set3f_terra(avalue: integer);
begin
  AttribData.r3f_terra := avalue;
end;

function TAttribClass.get3f_fetch: integer;
begin
  result := AttribData.r3f_fetch;
end;

function TAttribClass.get3f_sky: integer;
begin
  result := AttribData.r3f_sky;
end;

function TAttribClass.get3f_terra: integer;
begin
  result := AttribData.r3f_terra;
end;

procedure TAttribClass.REFILL;
begin
  CurAttribData.CurEnergy := AttribData.cEnergy + AttribQuestData.Energy;
  CurAttribData.CurInPower := AttribData.cInPower + AttribQuestData.InPower;
  CurAttribData.CurOutPower := AttribData.cOutPower + AttribQuestData.OutPower;
  CurAttribData.CurMagic := AttribData.cMagic + AttribQuestData.Magic;
  CurAttribData.CurLife := AttribData.cLife + AttribQuestData.Life;
  CurAttribData.CurHeadSeak := AttribData.cHeadSeak + AttribQuestData.HeadSeak;
  CurAttribData.CurArmSeak := AttribData.cArmSeak + AttribQuestData.ArmSeak;
  CurAttribData.CurLegSeak := AttribData.cLegSeak + AttribQuestData.LegSeak;
  boSendValues := TRUE;
  boSendBase := TRUE;
end;

function TAttribClass.AQgetInPower: integer;
begin
  result := AttribData.cInPower + AttribQuestData.InPower;
end;

function TAttribClass.AQgetOutPower: integer;
begin
  result := AttribData.cOutPower + AttribQuestData.OutPower;
end;

function TAttribClass.AQgetMagic: integer;
begin
  result := AttribData.cMagic + AttribQuestData.Magic;
end;

function TAttribClass.AQgetLife: integer;
begin
  result := AttribData.cLife + AttribQuestData.Life;
end;

function TAttribClass.AQgetAdaptive: integer;
begin
  result := AttribData.cadaptive + AttribQuestData.adaptive;
end;

function TAttribClass.AQget3f_sky: integer;
begin
  result := AttribData.r3f_sky + AttribQuestData.r3f_sky;
end;

function TAttribClass.AQget3f_terra: integer;
begin
  result := AttribData.r3f_terra + AttribQuestData.r3f_terra;
end;

function TAttribClass.AQget3f_fetch: integer;
begin
  result := AttribData.r3f_fetch + AttribQuestData.r3f_fetch;
end;

function TAttribClass.getcEnergy: integer;
begin
  result := AttribData.cEnergy;
end;

function TAttribClass.getluck: integer;
begin
  result := AttribData.GoodChar;
end;

function TAttribClass.getbad: integer; //武术职业
begin
  result := AttribData.badChar;
end;

function TAttribClass.gettalent: integer;
begin
  result := AttribData.talent;
end;

function TAttribClass.getEnergy: integer;
begin
  result := AttribData.Energy;
end;

function TAttribClass.AQgetEnergy: integer;
begin
  result := AttribData.cEnergy + AttribQuestData.Energy;
end;

function TAttribClass.AQgetAge: integer;
begin
  result := AttribData.cAge + AttribQuestData.Age;
end;

procedure TAttribClass.AQDataUPdate();
begin
  boSendBase := TRUE;
  boSendValues := TRUE;
end;

procedure TAttribClass.AQClear;
begin
  fillchar(AttribQuestData, sizeof(AttribQuestData), 0);
  AQDataUPdate;
end;

function TAttribClass.AddItemDrug(aDrugName: string): Boolean;
var
  i: integer;
  ItemDrugData: TItemDrugData;
begin
  Result := FALSE;

  ItemDrugClass.GetItemDrugData(aDrugName, ItemDrugData);
  if ItemDrugData.rName = '' then
    exit;

  for i := 0 to DRUGARR_SIZE - 1 do
  begin
    if ItemDrugArr[i].rName = '' then
    begin
      ItemDrugArr[i] := ItemDrugData;
      ItemDrugArr[i].rUsedCount := 0;
      Result := TRUE;
      CurAttribData.CurPoisoning := CurAttribData.CurPoisoning - CurAttribData.CurPoisoning div 10;
      exit;
    end;
  end;
end;

procedure TAttribClass.addLife(aLife: integer);
begin
  inc(CurAttribData.CurLife, aLife);
  if CurAttribData.CurLife > (AttribData.cLife + AttribQuestData.Life) then
    CurAttribData.CurLife := (AttribData.cLife + AttribQuestData.Life);
  boSendBase := TRUE;
end;

procedure TAttribClass.Update(CurTick: integer);

  function AddLimitValue(var curvalue: integer; maxvalue, addvalue: integer): Boolean;
  begin
    Result := FALSE;
    if curvalue = maxvalue then
      exit;
    curvalue := curvalue + addvalue;
    if curvalue > maxvalue then
      curvalue := maxvalue;
    if curvalue < 0 then
      curvalue := 0;
    Result := TRUE;
  end;

var
  n, i: integer;
  SubData: TSubData;
begin
  if boAddExp then
  begin
    if CheckRevival then
      Calculate;
    if CheckEnegy then
      Calculate;
    if CheckInpower then
      Calculate;
    if CheckOutpower then
      Calculate;
    if CheckMagic then
      Calculate;
  end;
  if (CurTick > shieldtick + 50) and (shieldtick <> 0) then
  begin
    SetWordString(SubData.SayString, '');
    Self.FBasicObject.SendLocalMessage(NOTARGETPHONE, FM_SAYUSEMAGIC, Self.FBasicObject.BasicData, SubData);
    shieldtick := 0;
  end;

  //境界盾 30秒复活 2015.11.22修改
  if CurTick > PowerShieldTick + 3000 then
  begin
    PowerShieldTick := CurTick;
    PowerShieldLife := PowerShieldLife + PowerShieldLifeMax div 10;
    if PowerShieldLife > PowerShieldLifeMax then
      PowerShieldLife := PowerShieldLifeMax;
    PowerShieldBoState := false;
  end;

  if CurTick > CheckDrugTick + 100 then
  begin
    CheckDrugTick := CurTick;
    for i := 0 to high(ItemDrugArr) do
    begin
      if ItemDrugArr[i].rName = '' then
        continue;

      CurAttribData.CurHeadSeak := CurAttribData.CurHeadSeak + ItemDrugArr[i].rEventHeadLife;
      CurAttribData.CurArmSeak := CurAttribData.CurArmSeak + ItemDrugArr[i].rEventArmLife;
      CurAttribData.CurLegSeak := CurAttribData.CurLegSeak + ItemDrugArr[i].rEventLegLife;
      //            if CurAttribData.CurHeadSeak > AttribData.cHeadSeak then CurAttribData.CurHeadSeak := AttribData.cHeadSeak;
       //           if CurAttribData.CurArmSeak > AttribData.cArmSeak then CurAttribData.CurArmSeak := AttribData.cArmSeak;
        //          if CurAttribData.CurLegSeak > AttribData.cLegSeak then CurAttribData.CurLegSeak := AttribData.cLegSeak;
      if CurAttribData.CurHeadSeak > (AttribData.cHeadSeak + AttribQuestData.HeadSeak) then
        CurAttribData.CurHeadSeak := (AttribData.cHeadSeak + AttribQuestData.HeadSeak);
      if CurAttribData.CurArmSeak > (AttribData.cArmSeak + AttribQuestData.ArmSeak) then
        CurAttribData.CurArmSeak := (AttribData.cArmSeak + AttribQuestData.ArmSeak);
      if CurAttribData.CurLegSeak > (AttribData.cLegSeak + AttribQuestData.LegSeak) then
        CurAttribData.CurLegSeak := (AttribData.cLegSeak + AttribQuestData.LegSeak);
      ///////////////////////////////////////////
      inc(CurAttribData.CurEnergy, ItemDrugArr[i].rEventEnergy);
      inc(CurAttribData.CurInPower, ItemDrugArr[i].rEventInPower);
      inc(CurAttribData.CurOutPower, ItemDrugArr[i].rEventOutPower);
      inc(CurAttribData.CurMagic, ItemDrugArr[i].rEventMagic);
      inc(CurAttribData.CurLife, ItemDrugArr[i].rEventLife);

      with CurAttribData do
      begin
        // if CurEnergy > AttribData.cEnergy then CurEnergy := AttribData.cEnergy;
        // if CurInPower > AttribData.cInPower then CurInPower := AttribData.cInPower;
         //if CurOutPower > AttribData.cOutPower then CurOutPower := AttribData.cOutPower;
        // if CurMagic > AttribData.cMagic then CurMagic := AttribData.cMagic;
        // if CurLife > AttribData.cLife then CurLife := AttribData.cLife;
        if CurEnergy > (AttribData.cEnergy + AttribQuestData.Energy) then
          CurEnergy := (AttribData.cEnergy + AttribQuestData.Energy);
        if CurInPower > (AttribData.cInPower + AttribQuestData.InPower) then
          CurInPower := (AttribData.cInPower + AttribQuestData.InPower);
        if CurOutPower > (AttribData.cOutPower + AttribQuestData.OutPower) then
          CurOutPower := (AttribData.cOutPower + AttribQuestData.OutPower);
        if CurMagic > (AttribData.cMagic + AttribQuestData.Magic) then
          CurMagic := (AttribData.cMagic + AttribQuestData.Magic);
        if CurLife > (AttribData.cLife + AttribQuestData.Life) then
          CurLife := (AttribData.cLife + AttribQuestData.Life);
      end;

      {  if tuser(FBasicObject).pMonster <> nil then
        begin
            TMonster(tuser(FBasicObject).pMonster).AddLife(ItemDrugArr[i].rEventLife * 2);
        end;}
      boSendBase := TRUE;
      boSendValues := TRUE;
      if (ItemDrugArr[i].rtype = 0) and (ItemDrugArr[i].rUsedCount = 0) then
      begin
        PowerShieldLife := PowerShieldLife + PowerShieldLifeMax div 20;
        if PowerShieldLife > PowerShieldLifeMax then
          PowerShieldLife := PowerShieldLifeMax;
      end;

      if ItemDrugArr[i].rUsedCount >= 10 then
      begin
        FillChar(ItemDrugArr[i], sizeof(TItemDrugData), 0);
      end
      else
        inc(ItemDrugArr[i].rUsedCount);
    end;

    if tuser(FBasicObject).FMonsterList.Count > 0 then
    begin

     //   {$IFDEF Free}
      //活力在80%+ 自己活力10%转换给元神
    {  n := (AttribData.cLife + AttribQuestData.Life);
      n := (CurAttribData.CurLife * 100 div n);
      if n >= 80 then
      begin
        n := AttribData.cLife div 4;
        if tuser(FBasicObject).MonsterAddLife(n) then
          //  if TMonster(tuser(FBasicObject).pMonster).AddLife(n) then
        begin
          CurAttribData.CurLife := CurAttribData.CurLife - n;
          FSendClass.SendLeftText(xViewName+'吸活力' + inttostr(n div 100), WinRGB(22,
            22, 0), mtLeftText3);
        end;
      end;
      // {$ELSE}
      tuser(FBasicObject).petlevel := GetxLevel(tuser(FBasicObject).getpetexp);
      tuser(FBasicObject).MonsterAddLife(tuser(FBasicObject).petlevel div 10); //10万的元神血量 20131013
    // {$ENDIF}
  //   tuser(FBasicObject).name:=tuser(FBasicObject).petname+'['+inttostr(GetLevel(tuser(FBasicObject).getpetexp) div 100 )+'级]';
//      tuser(FBasicObject).petgrade:=tuser(FBasicObject).BasicData.grade;//这里扣耐久
      TMonster(tuser(FBasicObject).FMonsterList.Items[0]).setpetdata(tuser(FBasicObject));

      if tuser(FBasicObject).xpetgrade <= 0 then
      begin
//      tuser(FBasicObject).MonsterDel(TMonster( tuser(FBasicObject).FMonsterList.Items[0]));
        tuser(FBasicObject).monsterclear;
        FSendClass.SendChatMessage('宠物耐久度为0，请补充宠物点。', SAY_COLOR_SYSTEM);
      end;
      Setpetgrade(tuser(FBasicObject).xpetgrade);
      Setpetmax(tuser(FBasicObject).petmax);
    end;
  end;
//  if CurTick > CheckLuckyTick + 180000 then //半小时（180000）一点幸运  ,测试10秒1点
//  begin
//    CheckLuckyTick := CurTick;
//    AttribData.lucky := AttribData.lucky + 1;
//    FSendClass.SendEventString('气运');
//  end;
  if CurTick > CheckIncreaseTick + 900 then
  begin
    CheckIncreaseTick := CurTick;
    //boSendBase := FALSE;
    n := GetLevel((AttribData.Age + (CurTick - StartTick) div 100 * vAge_Exp));
    if AttribData.cAge <> n then
    begin
      if (AttribData.cAge div 100) <> (n div 100) then
      begin
        Calculate;
        FSendClass.SendChatMessage(format('年龄已达 %d岁。', [n div 100]), SAY_COLOR_SYSTEM);
      end;
      AttribData.cAge := n;
      boSendBase := TRUE;
    end;

    if GrobalLightDark = gld_light then
    begin
      n := GetLevel(AttribData.Light + 664 + (CurTick - StartTick) div 100 * vAge_Exp);
      if AttribData.cLight <> n then
      begin
        AttribData.cLight := n;
        FSendClass.SendEventString('阳气');
        boSendBase := TRUE;
      end;
    end
    else
    begin
      n := GetLevel(AttribData.Dark + 664 + (CurTick - StartTick) div 100 * vAge_Exp);
      if AttribData.cDark <> n then
      begin
        AttribData.cDark := n;
        FSendClass.SendEventString('阴气');
        boSendBase := TRUE;
      end;
    end;

    case FFeatureState of
      wfs_normal:
        n := 80;
      wfs_care:
        n := 10;
      wfs_sitdown:
        n := 150;
      wfs_die:
        n := 300;
    else
      n := 50;
    end;
    n := n + n * AttribData.crevival div 10000;

    CurAttribData.Curhealth := CurAttribData.Curhealth + n;
    CurAttribData.Cursatiety := CurAttribData.Cursatiety + n;
    CurAttribData.Curpoisoning := CurAttribData.Curpoisoning + n;
    CurAttribData.CurHeadSeak := CurAttribData.CurHeadSeak + n;
    CurAttribData.CurArmSeak := CurAttribData.CurArmSeak + n;
    CurAttribData.CurLegSeak := CurAttribData.CurLegSeak + n;

    //if CurAttribData.Curhealth > AttribData.cHealth then CurAttribData.Curhealth := AttribData.cHealth;
    //if CurAttribData.Cursatiety > AttribData.cSatiety then CurAttribData.Cursatiety := AttribData.cSatiety;
    //if CurAttribData.Curpoisoning > AttribData.cPoisoning then CurAttribData.Curpoisoning := AttribData.cPoisoning;
    //if CurAttribData.CurHeadSeak > AttribData.cHeadSeak then CurAttribData.CurHeadSeak := AttribData.cHeadSeak;
    //if CurAttribData.CurArmSeak > AttribData.cArmSeak then CurAttribData.CurArmSeak := AttribData.cArmSeak;
    //if CurAttribData.CurLegSeak > AttribData.cLegSeak then CurAttribData.CurLegSeak := AttribData.cLegSeak;
    if CurAttribData.Curhealth > (AttribData.cHealth + AttribQuestData.Health) then
      CurAttribData.Curhealth := (AttribData.cHealth + AttribQuestData.Health);
    if CurAttribData.Cursatiety > (AttribData.cSatiety + AttribQuestData.Satiety) then
      CurAttribData.Cursatiety := (AttribData.cSatiety + AttribQuestData.Satiety);
    if CurAttribData.Curpoisoning > (AttribData.cPoisoning + AttribQuestData.Poisoning) then
      CurAttribData.Curpoisoning := (AttribData.cPoisoning + AttribQuestData.Poisoning);
    if CurAttribData.CurHeadSeak > (AttribData.cHeadSeak + AttribQuestData.HeadSeak) then
      CurAttribData.CurHeadSeak := (AttribData.cHeadSeak + AttribQuestData.HeadSeak);
    if CurAttribData.CurArmSeak > (AttribData.cArmSeak + AttribQuestData.ArmSeak) then
      CurAttribData.CurArmSeak := (AttribData.cArmSeak + AttribQuestData.ArmSeak);
    if CurAttribData.CurLegSeak > (AttribData.cLegSeak + AttribQuestData.LegSeak) then
      CurAttribData.CurLegSeak := (AttribData.cLegSeak + AttribQuestData.LegSeak);
    boSendValues := TRUE;

    case FFeatureState of
      wfs_normal:
        n := 50;
      wfs_care:
        n := 20;
      wfs_sitdown:
        n := 70;
      wfs_die:
        n := 100;
    else
      n := 50;
    end;
    n := n + n * AttribData.crevival div 10000;

    if AddLimitValue(CurAttribData.CurEnergy, Attribdata.cEnergy, n div 4) then
      boSendBase := TRUE;
    if AddLimitValue(CurAttribData.CurInPower, Attribdata.cInPower, n) then
      boSendBase := TRUE;
    if AddLimitValue(CurAttribData.CurOutPower, Attribdata.cOutPower, n) then
      boSendBase := TRUE;
    if AddLimitValue(CurAttribData.CurMagic, Attribdata.cMagic, n div 2) then
      boSendBase := TRUE;
    if AddLimitValue(CurAttribData.CurLife, Attribdata.cLife, n) then
      boSendBase := TRUE;

    boSendBase := TRUE;
  end;

  if boSendBase then
    FSendClass.SendAttribBase(AttribData, CurAttribData, AttribQuestData);
  if boSendValues then
    FSendClass.SendAttribValues(AttribData, CurAttribData, AttribQuestData);
  boSendBase := FALSE;
  boSendValues := FALSE;
end;
///////////////////////////////////
//         THaveItemClass
///////////////////////////////////

constructor THaveItemClass.Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass; aHaveItemQuestClass: THaveItemQuestClass);
begin
  //    boLocked := false;
  FBasicObject := ABasicObject;
  fillchar(HaveItemLifeData, sizeof(HaveItemLifeData), 0);
  FHaveItemQuestClass := aHaveItemQuestClass;
  ItemInputWindowsClear;
  boLockedpass := true;
  ReQuestPlaySoundNumber := 0;
  FSendClass := aSendClass;
  FAttribClass := aAttribClass;
  FUserName := '';
  UpdateTick := mmAnsTick;
  LockTick := mmAnsTick;
  AddLifeTick := mmAnsTick;

  FGOLD_Money := 0;
  WaterTick := 0;
end;

destructor THaveItemClass.Destroy;
begin
  inherited destroy;
end;

procedure THaveItemClass.Update(CurTick: integer);
var
  i: integer;
  f: integer;
begin
  //刷 开锁 时间            HaveItemArr:array[0..HAVEITEMSIZE - 1] of TItemData;

  //if f > 0 then                                                               //分钟
  if CurTick > UpdateTick + 200 then
  begin
    UpdateTick := CurTick;
    for i := 0 to high(HaveItemArr) do
    begin
      if HaveItemArr[i].rName = '' then
        Continue;
      //增加活力
      if CurTick > AddLifeTick + 500 then
      begin
        case HaveItemArr[i].rKind of
          ITEM_KIND_41:
            begin
              FAttribClass.addLife(500);
              FSendClass.SendChatMessage(format('喝口 %s 增加活力。', [HaveItemArr[i].rViewName]), SAY_COLOR_SYSTEM);
            end;
        end;
      end;
      //扣持久
      case HaveItemArr[i].rKind of
        ITEM_KIND_WEARITEM_GUILD,
          ITEM_KIND_WEARITEM, //20130729修改，把挖矿工具转移到下面磨损消失里了
          ITEM_KIND_WEARITEM_FD:
          ; //装备不需要扣
      else
        begin
          if (HaveItemArr[i].rboDurability = true) and (HaveItemArr[i].rDecSize > 0) and (HaveItemArr[i].rCurDurability > 0) then
          begin
            if CurTick > HaveItemArr[i].TimeTick + HaveItemArr[i].rDecDelay then
            begin
              HaveItemArr[i].TimeTick := CurTick;
              HaveItemArr[i].rCurDurability := HaveItemArr[i].rCurDurability - HaveItemArr[i].rDecSize;
              if HaveItemArr[i].rCurDurability < 0 then
                HaveItemArr[i].rCurDurability := 0;
              if HaveItemArr[i].rCurDurability <= 0 then
              begin
                //物品消失
                case HaveItemArr[i].rKind of
                  ITEM_KIND_41, ITEM_KIND_36, ITEM_KIND_44, ITEM_KIND_WEARITEM_27, ITEM_KIND_45, ITEM_KIND_51, ITEM_KIND_59: //20130729修改，把挖矿工具转移到下面磨损消失里了
                    begin
                      FSendClass.SendChatMessage(format('%s 已经磨损的再不能用了。', [HaveItemArr[i].rViewName]), SAY_COLOR_SYSTEM);
                      DeletekeyItem(i, HaveItemArr[i].rCount);
                      Continue;
                    end;
                  ITEM_KIND_35:
                    begin
                      FSendClass.SendChatMessage('没水喝了', SAY_COLOR_SYSTEM);
                    end;
                  ITEM_KIND_Scripter:
                    begin
                      //持久消耗完，自动运行一次脚本，如果失败，可重新双点物品
                      //ItemClass.CallScriptFunction(HaveItemArr[i].rScripter, 'OnItemDblClick', [integer(FBasicObject), i, '']);
                      ItemClass.CallLuaScriptFunction(HaveItemArr[i].rScripter, 'OnItemDblClick', [integer(FBasicObject), i, '']);
                    end;

                end;
              end
              else
              begin
                //扣了喊话
                if HaveItemArr[i].rSpecialKind = 100 then
                  ItemWorldSay(@HaveItemArr[i]);
              end;
              FSendClass.SendUPDATEItem_rDurability(suitHave, i, HaveItemArr[i]);
            end;

          end;
        end;
      end;
    end;
  end;

  if CurTick > AddLifeTick + 500 then
    AddLifeTick := CurTick;

  f := GetItemLineTime(CurTick - LockTick);
  if f <= 0 then
    exit;
  LockTick := CurTick;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
      Continue;

    if HaveItemArr[i].rboTimeMode = true then
    begin
      if now() > HaveItemArr[i].rDateTime then
      begin

        logItemMoveInfo('时间模式删除', @FAttribClass.FBasicObject.BasicData, nil, HaveItemArr[i], FAttribClass.FBasicObject.Manager.ServerID);

        FillChar(HaveItemArr[i], sizeof(TItemData), 0);

        FSendClass.SendUPDATEItem_rtimemode_del(suitHave, i, HaveItemArr[i]);
        Continue;
      end;
    end;

    //锁定问题
    if HaveItemArr[i].rlockState = 2 then //0,无锁状态，1,是加锁状态,2,是解锁状态
    begin
      if (HaveItemArr[i].rlocktime + f) > (60 * 24) then
      begin //24小时 解除 锁定
        HaveItemArr[i].rlockState := 0;
        FSendClass.SendUPDATEItem_rlockState(suitHave, i, HaveItemArr[i]);
      end
      else
      begin
        HaveItemArr[i].rlocktime := HaveItemArr[i].rlocktime + f;
        FSendClass.SendUPDATEItem_rlocktime(suitHave, i, HaveItemArr[i]);
      end;
    end;
  end;

end;

procedure THaveItemClass.affair(atype: THaveItemClassAffair);
var
  i: integer;
begin
  case atype of
    hicaStart:
      begin
        Move(HaveItemArr, bakHaveItemArr, SizeOf(HaveItemArr));
        BAKGOLD_Money := FGOLD_Money;
        FBackBindMoney := FBindMoney;
        Faffair := atype;
      end;
    hicaConfirm:
      begin
        Faffair := atype;
      end;
    hicaRoll_back:
      begin
        if Faffair <> hicaStart then
          exit;

        Move(bakHaveItemArr, HaveItemArr, SizeOf(HaveItemArr));
        FGOLD_Money := BAKGOLD_Money;
        FBindMoney := FBackBindMoney;
        sendItemAll;
        Faffair := atype;

      end;
  end;

end;

procedure THaveItemClass.OnGameExit();
var
  i, j, wif, XX, YY: integer;
begin
  wif := 0;
  for i := 0 to high(HaveItemArr) do
  begin
    if (HaveItemArr[i].rName <> '') and (HaveItemArr[i].rCount > 0) then
    begin
      case HaveItemArr[i].rdiePunish of
        3: //1,死亡掉,3,下线,死亡,离开地图
          begin
            j := random(100);
            if j < (100 - HaveItemArr[i].rRandomCount) then
            begin
              if FBasicObject.Maper.GetItemXy(FBasicObject.BasicData.x, FBasicObject.BasicData.y, xx, yy, wif, 64) = false then
              begin
                xx := FBasicObject.BasicData.x;
                yy := FBasicObject.BasicData.y;
              end;
              DropkeyItem(i, HaveItemArr[i].rCount, xx, yy);
            end;
          end;
      end;
    end;
  end;
end;

procedure THaveItemClass.OnChangeMap();
var
  i, j, wif, XX, YY: integer;
begin
  wif := 0;
  for i := 0 to high(HaveItemArr) do
  begin
    if (HaveItemArr[i].rName <> '') and (HaveItemArr[i].rCount > 0) then
    begin
      case HaveItemArr[i].rdiePunish of
        3: //3,夺宝物品
          begin
            j := random(100);
            if j < (100 - HaveItemArr[i].rRandomCount) then
            begin
              if FBasicObject.Maper.GetItemXy(FBasicObject.BasicData.x, FBasicObject.BasicData.y, xx, yy, wif, 64) = false then
              begin
                xx := FBasicObject.BasicData.x;
                yy := FBasicObject.BasicData.y;
              end;
              DropkeyItem(i, HaveItemArr[i].rCount, xx, yy);
            end;
          end;
      end;
    end;
  end;
end;

function THaveItemClass.DropkeyItem(akey, aCount, x, y: integer): Boolean;
//掉落 物品
var
  SubData: TSubData;
  XX, YY: integer;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit; //非法
  if aCount < 0 then
    EXIT; //非法
  if HaveItemArr[akey].rCount < aCount then
    EXIT; //数量不够
  XX := FBasicObject.BasicData.Nx;
  YY := FBasicObject.BasicData.NY;
  SubData.ServerId := FBasicObject.Manager.ServerId;
  SubData.ItemData := HaveItemArr[akey];
  FBasicObject.BasicData.Nx := x;
  FBasicObject.BasicData.NY := y;

  if FBasicObject.Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, FBasicObject.BasicData, SubData) <> PROC_TRUE then
  begin
    exit;
  end;
  //掉落成功删除物品
  DeletekeyItem(akey, HaveItemArr[akey].rCount);

  FBasicObject.BasicData.Nx := XX;
  FBasicObject.BasicData.NY := YY;
  Result := TRUE;
end;

procedure THaveItemClass.Ondie();
var
  i, j, wif, XX, YY: integer;
begin
  wif := 0;
  for i := 0 to high(HaveItemArr) do
  begin
    if (HaveItemArr[i].rName <> '') and (HaveItemArr[i].rCount > 0) then
    begin
      case HaveItemArr[i].rdiePunish of
        1, 3: //1,死亡掉,3,下线,死亡,离开地图
          begin
            j := random(100);
            if j < (100 - HaveItemArr[i].rRandomCount) then
            begin
              if FBasicObject.Maper.GetItemXy(FBasicObject.BasicData.x, FBasicObject.BasicData.y, xx, yy, wif, 64) = false then
              begin
                xx := FBasicObject.BasicData.x;
                yy := FBasicObject.BasicData.y;
              end;
              DropkeyItem(i, HaveItemArr[i].rCount, xx, yy);
            end;
          end;
      end;
    end;
  end;
end;

procedure THaveItemClass.neaten();
var
  i, j: integer;
begin
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName <> '' then
    begin

      if HaveItemArr[i].rboDouble = true then
      begin //可重叠 的整理在一起
        for j := i + 1 to high(HaveItemArr) do
        begin
          if (HaveItemArr[i].rName) = (HaveItemArr[j].rName) then
          begin
            if HaveItemArr[i].rColor = HaveItemArr[j].rColor then
            begin
              HaveItemArr[i].rCount := HaveItemArr[i].rCount + HaveItemArr[j].rCount;
              FillChar(HaveItemArr[j], SizeOf(TItemData), 0);
            end;
          end;
        end;
      end
      else
      begin
        {
        if HaveItemArr[i].rCount >= 10 then begin
           frmMain.WriteLogInfo (format ('HaveItemInfo %s, %s, %d', [aName, (HaveItemArr[i].rName), HaveItemArr[i].rCount]));
        end;
        }
        //不重复的   >1 的分开
        for j := 0 to high(HaveItemArr) do
        begin
          if HaveItemArr[i].rCount <= 1 then
            break;
          if HaveItemArr[j].rName = '' then
          begin
            HaveItemArr[i].rCount := HaveItemArr[i].rCount - 1;
            Move(HaveItemArr[i], HaveItemArr[j], SizeOf(TItemData));
            HaveItemArr[j].rCount := 1;
          end;
        end;
      end;
    end;
  end;
end;

procedure THaveItemClass.LoadFromSdb(aCharData: PTDBRecord);
var
  i: integer;
begin
    //    boLocked := false;
  FGOLD_Money := aCharData.GOLD_Money;
  FBindMoney := aCharData.newBindMoney;
  //nirendao 测试用 需要删除
//  if FBindMoney > 100000 then
//    FBindMoney := 0;
  ReQuestPlaySoundNumber := 0;
  move(aCharData.Password, LockPassword, sizeof(LockPassword));
  if LockPassword <> '' then
    boLockedPass := true
  else
    boLockedPass := false;
  FUserName := (aCharData^.PrimaryKey);
  for i := 0 to high(HaveItemArr) do
  begin
    CopyDBItemToItem(aCharData^.HaveItemArr[i], HaveItemArr[i]);
    HaveItemArr[i].TimeTick := 0;
    //任务物品 增加 到任务背包
    if HaveItemArr[i].rName <> '' then
      if HaveItemArr[i].rKind = ITEM_KIND_QUEST then
      begin
        fHaveItemQuestClass.Add(@HaveItemArr[i]);
        FillChar(HaveItemArr[i], SizeOf(TItemData), 0);
      end;
  end;

  //删除 任务装备
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
      Continue;
    if HaveItemArr[i].rSpecialKind = 6 then //这导致任务属性是6的物品被删除，比如某些药品山参之类的 2014修改
      FillChar(HaveItemArr[i], SizeOf(TItemData), 0);
  end;

  neaten;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName <> '' then
      FSendClass.SendHaveItem(i, HaveItemArr[i]);
  end;
  //  sendItemAll;
  FSendClass.SendMoney(FGOLD_Money);
  FSendClass.SendBindMoney(FBindMoney);
  tmmoneylist.gameLoad(FUserName, FGOLD_Money);
  setLifeData();
  FAttribClass.setHaveItemCLife(HaveItemLifeData.rLife);
end;

procedure THaveItemClass.SaveToSdb(aCharData: PTDBRecord);
var
  i: integer;
begin

  aCharData.GOLD_Money := FGOLD_Money;
  aCharData.newBindMoney := FBindMoney;
  move(LockPassword, aCharData.Password, sizeof(LockPassword));
  for i := 0 to high(HaveItemArr) do
  begin
    CopyItemToDBItem(HaveItemArr[i], aCharData^.HaveItemArr[i]);
  end;
  tmmoneylist.gamesave(FUserName, FGOLD_Money);
end;

function THaveItemClass._GetItemName(aname: string): integer;
var
  i: integer;
begin

  Result := -1;
  if aname = '' then
    EXIT;
  for i := 0 to high(HaveItemArr) do
  begin
    if (HaveItemArr[i].rName = aname) and (HaveItemArr[i].rCount > 0) then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function THaveItemClass._GetSpace(): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function THaveItemClass.IsSpace: boolean; //TRUE 有空位置
var
  i: integer;
begin
  Result := false;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
    begin
      Result := true;
      exit;
    end;
  end;
end;

function THaveItemClass.SpaceCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
      Result := Result + 1;
  end;
end;

function THaveItemClass.getViewItem(akey: integer): PTItemData;
begin
  Result := nil;

  //    if boLocked = true then exit;

  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  Result := @HaveItemArr[akey];
end;

function THaveItemClass.ViewItem(akey: integer; aItemData: PTItemData): Boolean;
begin
  FillChar(aItemData^, sizeof(TItemData), 0);
  Result := FALSE;

  //    if boLocked = true then exit;

  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  Move(HaveItemArr[akey], aItemData^, SizeOf(TItemData));
  Result := TRUE;
end;

function THaveItemClass.ViewItemName(aname: string; outitemData: PTItemData): Boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to high(HaveItemArr) do
  begin
    if (HaveItemArr[i].rName) = aname then
    begin
      Move(HaveItemArr[i], outitemData^, SizeOf(TItemData));
      Result := true;
      exit;
    end;
  end;
end;

function THaveItemClass.FindItem(aItemData: PTItemData): Boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to high(HaveItemArr) do
  begin
    if (HaveItemArr[i].rName) = (aItemData^.rName) then
    begin
      if HaveItemArr[i].rCount >= aItemData^.rCount then
      begin
        Result := true;
        exit;
      end;
    end;
  end;
end;

function THaveItemClass.FindNameItem(aname: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = aname then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function THaveItemClass.FindKindItem(akind: integer): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rkind = akind then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function THaveItemClass.FindItemByMagicKind(aKind: integer): integer;
var
  i, tmpresult: integer;
begin
  Result := -1;
  tmpresult := -1;
  for i := 0 to high(HaveItemArr) do
  begin
    if aKind = MAGICTYPE_WRESTLING then
    begin
      if HaveItemArr[i].rName = '' then
      begin
        tmpresult := i;
      end;
    end;
    if (HaveItemArr[i].rName <> '') and (HaveItemArr[i].rWearArr = ARR_WEAPON) and (HaveItemArr[i].rHitType = aKind) and (HaveItemArr[i].rKind = ITEM_KIND_WEARITEM) then
    begin
      Result := i;
      exit;
    end;
  end;
  if aKind = MAGICTYPE_WRESTLING then
    Result := tmpresult;
end;
//增加 到指定 位置
{
function THaveItemClass.AddKeyItem(aKey:Integer; var aItemData:TItemData):Boolean;
var
    i               :Integer;
    nPos            :Integer;
begin
    Result := FALSE;

    if boLocked = true then exit;
    if (aKey < 0) or (aKey > high(HaveItemArr)) then exit;
    if aItemData.rName = '' then exit;

    nPos := aKey;
    //找物品是否位置
    for i := 0 to high(HaveItemArr) do
    begin
        //  if HaveItemArr[i].rlockState <> 2 then
        if (HaveItemArr[i].rName) = (aItemData.rName) then
        begin
            if HaveItemArr[i].rColor = aItemData.rColor then
            begin
                if HaveItemArr[i].rboDouble = true then
                    // if HaveItemArr[i].rlockState = aItemData.rlockState then
                begin
                    nPos := i;
                    break;
                end;
            end;
        end;
    end;
    //位置上有物品
    if HaveItemArr[nPos].rName <> '' then
    begin
        if (HaveItemArr[nPos].rName) <> (aItemData.rName) then exit;
        if aItemData.rboDouble = false then exit;
        HaveItemArr[nPos].rCount := HaveItemArr[nPos].rCount + aItemData.rCount;
         if (HaveItemArr[nPos].rCount > 0)
             and (aItemData.rCount > 0) then
         begin
             //锁     级别 最高
             //解     级别 第二  时间取大的
             if (aItemData.rlockState = 1) or (HaveItemArr[nPos].rlockState = 1) then
             begin
                 HaveItemArr[nPos].rlockState := 1;
                 HaveItemArr[nPos].rlocktime := aItemData.rlocktime;

             end
             else if (aItemData.rlockState = 2) or (HaveItemArr[nPos].rlockState = 2) then
             begin
                 HaveItemArr[nPos].rlockState := 2;
                 if HaveItemArr[nPos].rlocktime < aItemData.rlocktime then
                     HaveItemArr[nPos].rlocktime := aItemData.rlocktime;
             end
             else
             begin
                 HaveItemArr[nPos].rlockState := 0;
                 HaveItemArr[nPos].rlocktime := aItemData.rlocktime;
             end;

         end
         else
         begin
             HaveItemArr[nPos].rlockState := aItemData.rlockState;
             HaveItemArr[nPos].rlocktime := aItemData.rlocktime;
         end;
    end else
    begin
        HaveItemArr[nPos] := aItemData;
    end;

    FSendClass.SendHaveItem(nPos, HaveItemArr[nPos]);
    ReQuestPlaySoundNumber := HaveItemArr[nPos].rSoundEvent.rWavNumber;

    Result := true;
end;
}

function THaveItemClass.DEL_GOLD_Money(acount: integer): Boolean;
begin
  Result := FALSE;
  if acount <= 0 then
    EXIT;
  //    if boLocked = true then exit;
  if (FGOLD_Money - acount) < 0 then
    EXIT;
  FGOLD_Money := FGOLD_Money - acount;
  if FGOLD_Money < 0 then
    FGOLD_Money := 0;
  Result := TRUE;
  FSendClass.SendMoney(FGOLD_Money);
end;

function THaveItemClass.SET_GOLD_Money(acount: integer): Boolean;
begin
  Result := FALSE;
  if acount <= 0 then
    acount := 0;
  FGOLD_Money := acount;
  Result := TRUE;
  FSendClass.SendMoney(FGOLD_Money);
end;

function THaveItemClass.GET_GOLD_Money(): INTEGER;
begin
  result := FGOLD_Money;
end;

function THaveItemClass.Add_GOLD_Money(acount: integer): Boolean;
begin
  Result := FALSE;
  if acount <= 0 then
    EXIT;
  //    if boLocked = true then exit;
  if FGOLD_Money < 0 then
    FGOLD_Money := 0;
  FGOLD_Money := FGOLD_Money + acount;
  Result := TRUE;
  FSendClass.SendMoney(FGOLD_Money);
end;

function THaveItemClass.addDurability_Water(): boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
      Continue;
    if HaveItemArr[i].rKind <> ITEM_KIND_35 then
      Continue;
    if HaveItemArr[i].rCurDurability = HaveItemArr[i].rDurability then
      exit;
    HaveItemArr[i].rCurDurability := HaveItemArr[i].rDurability;
    FSendClass.SendUPDATEItem_rDurability(suitHave, i, HaveItemArr[i]);
    FSendClass.SendChatMessage('竹筒已经装满水了', SAY_COLOR_NORMAL);
    Result := TRUE;
    exit;
  end;
end;

function THaveItemClass.setDurability(akey, aCount: integer): boolean;
begin
  Result := FALSE;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit; //非法
  if aCount < 0 then
    EXIT;
  if HaveItemArr[akey].rName = '' then
    exit;
  HaveItemArr[akey].rCurDurability := aCount;
  if HaveItemArr[akey].rCurDurability > HaveItemArr[akey].rDurability then
    HaveItemArr[akey].rCurDurability := HaveItemArr[akey].rDurability;
  if HaveItemArr[akey].rCurDurability < 0 then
    HaveItemArr[akey].rCurDurability := 0;
  FSendClass.SendUPDATEItem_rDurability(suitHave, akey, HaveItemArr[akey]);
  Result := TRUE;
end;

function THaveItemClass.IsDurability_Water(): boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
      Continue;
    if HaveItemArr[i].rKind <> ITEM_KIND_35 then
      Continue;
    if HaveItemArr[i].rCurDurability <= 0 then
      Continue;
    { 统一在UPDATE里扣持久
    if mmAnsTick > WaterTick + HaveItemArr[i].rDecDelay then
     begin
         WaterTick := mmAnsTick;
         HaveItemArr[i].rCurDurability := HaveItemArr[i].rCurDurability - HaveItemArr[i].rDecSize;
         if HaveItemArr[i].rCurDurability < 0 then HaveItemArr[i].rCurDurability := 0;
         FSendClass.SendUPDATEItem_rDurability(suitHave, i, HaveItemArr[i]);
         Result := TRUE;
         exit;
     end;

     if HaveItemArr[i].rCurDurability <= 0 then Continue;
     }
    Result := TRUE;
    exit;
  end;
end;

function THaveItemClass.AddItem(aItemData: PTItemData; isinfo: Boolean = True): Boolean;
//统一 唯一 增加物品
var
  i, j: integer;
  asum: int64;
  boUP: boolean;
begin
  Result := FALSE;

//  if aItemData.rboLOG then
//    FrmMain.Logdrop(' ' + Self.FUserName + ' 增加' + aitemdata.rViewName + ' ' + inttostr(aitemdata.rCount) + '个');
  if aItemData.rKind = ITEM_KIND_QUEST then
  begin
    fHaveItemQuestClass.Add(aItemData);
    Result := true;
    exit;
  end;
  boUP := false;
  //    if boLocked = true then exit;
  if aItemData.rCount <= 0 then
    exit;
  //增加的是绑定钱币
  if aItemData.rName = '钱币1' then
  begin
    Add_Bind_Money(aItemData.rCount);
    FSendClass.SendLeftText(format('绑定钱币 获得 %d 个', [aItemData.rCount]), WinRGB(22, 22, 0), mtLeftText3);
    result := true;
    exit;
  end;

  //20091019 增加，控制 前提物品
//前提物品
  if aItemData.rNeedItem <> '' then
  begin
    j := _GetItemName(aItemData.rNeedItem);
   //  FSendClass.SendLeftText(aItemData.rNeedItem + ' 有'+IntToStr(j)+' 个  22222', WinRGB(22, 22, 0), mtLeftText3) ;
    if j = -1 then
      exit; //结束
    if HaveItemArr[j].rCount < aItemData.rNeedItemCount then
    begin
      result := true;
      exit; //结束
    end;
  end;
  {
//不能拥有物品
for i := 0 to high(aItemData.rNotHaveItemArr) do
begin
    if aItemData.rNotHaveItemArr[i] = '' then Break;                        //结束
    j := _GetItemName(aItemData.rNotHaveItemArr[i]);
    if j = -1 then Continue;
    if HaveItemArr[j].rCount >= aItemData.rNotHaveItemCountArr[i] then exit; //静止拥有
end;}
//删除 指定物品
  if aItemData.rDelItem <> '' then
  begin
    j := _GetItemName(aItemData.rDelItem);
    if j <> -1 then
      DeletekeyItem(j, aItemData.rDelItemCount);
  end;

  //增加 替代品进入背包
  if aItemData.rAddItem <> '' then
  begin
    j := aItemData.rAddItemCount;
    if ItemClass.GetItemData(aItemData.rAddItem, aItemData^) = false then
    begin
      result := true;
      FSendClass.SendLeftText(aItemData.rViewName + '物品无效', WinRGB(22, 22, 0), mtLeftText3);
      exit;
    end;
    aItemData.rAddItemCount := j;
  end;

  if aItemData^.rboDouble then
  begin //可重叠
    j := _GetItemName(aItemData.rName);
    if j <> -1 then
    begin
      asum := HaveItemArr[j].rCount;
      asum := asum + aItemData.rCount;

      if HaveItemArr[j].rMaxCount > 0 then
      begin
        if asum > HaveItemArr[j].rMaxCount then
        begin
          asum := HaveItemArr[j].rMaxCount;
          //   FSendClass.SendChatMessage('测试提示：' + HaveItemArr[j].rName + ' 数量超过MaxCount', SAY_COLOR_NORMAL);
          FSendClass.SendLeftText(HaveItemArr[j].rViewName + '数量达到最大', WinRGB(22, 22, 0), mtLeftText3);
          boUP := true;
        end;
      end;
      if asum > 2000000000 then
      begin
        asum := 2000000000;
        boUP := true;
      end;

      HaveItemArr[j].rCount := asum;
      if boUP then
      begin
     //      FSendClass.SendUPDATEItem_rcount_UP(suitHave, j, HaveItemArr[j].rCount)
        if isinfo then
          FSendClass.SendUPDATEItem_rcount_UP(suitHave, j, HaveItemArr[j].rCount)
        else
          FSendClass.SendUPDATEItem_rcount_UP(suitHaveNoInfo, j, HaveItemArr[j].rCount);
      end
      else
      begin
    //       FSendClass.SendUPDATEItem_rcount_add(suitHave, j, aItemData.rCount)
        if isinfo then
          FSendClass.SendUPDATEItem_rcount_add(suitHave, j, aItemData.rCount)
        else
          FSendClass.SendUPDATEItem_rcount_add(suitHaveNoInfo, j, aItemData.rCount);
      end;

      ReQuestPlaySoundNumber := HaveItemArr[j].rSoundEvent.rWavNumber;
      Result := TRUE;
      setLifeData();
      if HaveItemArr[j].rSpecialKind = 100 then
        ItemWorldSay(@HaveItemArr[j]);
      exit;
    end;
    i := _GetSpace;
    if i <> -1 then
    begin
      HaveItemArr[i] := aItemData^;
      if HaveItemArr[i].rMaxCount > 0 then
      begin
        if HaveItemArr[i].rCount > HaveItemArr[i].rMaxCount then
        begin
          HaveItemArr[i].rCount := HaveItemArr[i].rMaxCount;
          //  FSendClass.SendChatMessage('测试提示：' + HaveItemArr[j].rName + ' 数量超过MaxCount', SAY_COLOR_NORMAL);
          FSendClass.SendLeftText(HaveItemArr[i].rViewName + '数量达到最大', WinRGB(22, 22, 0), mtLeftText3);
        end;
      end;
      if HaveItemArr[i].rCount > 2000000000 then
        HaveItemArr[i].rCount := 2000000000;
    //  FSendClass.SendUPDATEItem_add(suitHave, i, HaveItemArr[i]);
      if isinfo then
        FSendClass.SendUPDATEItem_add(suitHave, i, HaveItemArr[i])
      else
        FSendClass.SendUPDATEItem_add(suitHaveNoInfo, i, HaveItemArr[i]);

      ReQuestPlaySoundNumber := HaveItemArr[i].rSoundEvent.rWavNumber;

      Result := TRUE;
      setLifeData();
      if HaveItemArr[i].rSpecialKind = 100 then
        ItemWorldSay(@HaveItemArr[i]);
    end;
    exit;
  end;
  if aItemData.rCount <> 1 then
    exit;
  i := _GetSpace;
  if i <> -1 then
  begin
    HaveItemArr[i] := aItemData^;
    ItemLifeDataUPdate(HaveItemArr[i]);
   //   FSendClass.SendUPDATEItem_add(suitHave, i, HaveItemArr[i]);
    if isinfo then
      FSendClass.SendUPDATEItem_add(suitHave, i, HaveItemArr[i])
    else
      FSendClass.SendUPDATEItem_add(suitHaveNoInfo, i, HaveItemArr[i]);

    ReQuestPlaySoundNumber := HaveItemArr[i].rSoundEvent.rWavNumber;

    Result := TRUE;
    setLifeData();
    if HaveItemArr[i].rSpecialKind = 100 then
      ItemWorldSay(@HaveItemArr[i]);
  end;

  exit;

end;

function THaveItemClass.Updatesettingcount(akey: integer; acount: integer): Boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;

  if (HaveItemArr[akey].rKind <> ITEM_KIND_WEARITEM)
    //        and (HaveItemArr[akey].rKind <> ITEM_KIND_WEARITEM2)
  //      and (HaveItemArr[akey].rKind <> ITEM_KIND_WEARITEM_29)
  and (HaveItemArr[akey].rKind <> ITEM_KIND_WEARITEM_GUILD) then
    exit;

  if HaveItemArr[akey].rWearArr = ARR_WEAPON then
  begin
    if (acount < 0) or (acount > 2) then
      exit;
  end
  else
  begin
    if (acount < 0) or (acount > 4) then
      exit;
  end;

  HaveItemArr[akey].rSetting.rsettingcount := acount;
  HaveItemArr[akey].rSetting.rsetting1 := '';
  HaveItemArr[akey].rSetting.rsetting2 := '';
  HaveItemArr[akey].rSetting.rsetting3 := '';
  HaveItemArr[akey].rSetting.rsetting4 := '';
  ItemLifeDataUPdate(HaveItemArr[akey]);
  FSendClass.SendHaveItem(aKey, HaveItemArr[akey]); //重新发送 物品
  Result := TRUE;
end;

function THaveItemClass.UpStarLevel(akey: integer; alevel: integer): Boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;

  HaveItemArr[akey].rStarLevel := alevel;
  if HaveItemArr[akey].rStarLevel > HaveItemArr[akey].rStarLevelMax then
    HaveItemArr[akey].rStarLevel := HaveItemArr[akey].rStarLevelMax;
  if HaveItemArr[akey].rStarLevel < 0 then
    HaveItemArr[akey].rStarLevel := 0;
  ItemLifeDataUPdate(HaveItemArr[akey]);
  FSendClass.SendHaveItem(aKey, HaveItemArr[akey]); //重新发送 物品
  Result := TRUE;
end;

function THaveItemClass.UpboBlueprint(akey: integer; astate: boolean): Boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;

  HaveItemArr[akey].rboBlueprint := astate;
  FSendClass.SendUPDATEItem_rboBlueprint(suitHave, akey, HaveItemArr[akey]);

  Result := TRUE;
end;

function THaveItemClass.blitem(akey: integer; astate: boolean): Boolean; //百炼装备
var
  i: integer;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  for i := 0 to blstr.Count - 1 do
  begin
    if blstr.Strings[i] = '百炼' + HaveItemArr[akey].rName then
    begin
      if astate then
        HaveItemArr[akey].rName := '百炼' + HaveItemArr[akey].rName;
      Result := TRUE;
      Break;
    end;
  end;
//  FSendClass.SendUPDATEItem_rboident(suitHave, akey, HaveItemArr[akey]);
end;

function THaveItemClass.UpBoIdent(akey: integer; astate: boolean): Boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;

  HaveItemArr[akey].rboident := astate;
  FSendClass.SendUPDATEItem_rboident(suitHave, akey, HaveItemArr[akey]);

  Result := TRUE;
end;

function THaveItemClass.lockkeyItem(akey: integer): Boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  if HaveItemArr[akey].rlockState <> 1 then
  begin
    HaveItemArr[akey].rlockState := 1;
    HaveItemArr[akey].rlocktime := 0;

    FSendClass.SendUPDATEItem_rlockState(suitHave, akey, HaveItemArr[akey]);
    FSendClass.SendChatMessage('物品加锁成功', SAY_COLOR_SYSTEM);
  end;

  Result := TRUE;
end;

function THaveItemClass.UNlockkeyItem(akey: integer): Boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;

  if HaveItemArr[akey].rlockState = 1 then
  begin
    HaveItemArr[akey].rlockState := 2;
    HaveItemArr[akey].rlocktime := 0;
    FSendClass.SendUPDATEItem_rlockState(suitHave, akey, HaveItemArr[akey]);
    FSendClass.SendChatMessage('物品开始解锁', SAY_COLOR_SYSTEM);
  end;

  Result := TRUE;
end;

function THaveItemClass.ItemInputWindowsOpen(aSubKey: integer; aCaption: string; aText: string): boolean;
begin
  result := false;
  if (aSubKey < 0) or (aSubKey > 4) then
    exit;
  setItemInputWindowsKey(aSubKey, -1);
  FSendClass.SendItemInputWindowsOpen(aSubkey, aCaption, aText);
  result := true;
end;

function THaveItemClass.ItemInputWindowsClear: boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to High(FItemInputWindowsKeyArr) do
  begin
    FItemInputWindowsKeyArr[i] := -1;
  end;
  result := true;
end;

function THaveItemClass.ItemInputWindowsClose: boolean;
begin
  result := false;
  ItemInputWindowsClear;
  FSendClass.SendItemInputWindowsClose;
  result := true;
end;

function THaveItemClass.GetItemInputWindowsKey(aSubKey: integer): integer;
begin
  result := -1;
  if (aSubKey < 0) or (aSubKey > 4) then
    exit;
  result := FItemInputWindowsKeyArr[aSubKey];
end;

procedure THaveItemClass.setLifeData();
var
  i: integer;
begin
  fillchar(HaveItemLifeData, sizeof(HaveItemLifeData), 0);
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
      Continue;
    case HaveItemArr[i].rKind of
      ITEM_KIND_59:
        begin
          GatherLifeData(HaveItemLifeData.rLifedata, HaveItemArr[i].rLifeDataBasic);
        end;
      ITEM_KIND_36:
        begin
          HaveItemLifeData.rLife := HaveItemLifeData.rLife + HaveItemArr[i].rcLife;
        end;

    end;

  end;
  FAttribClass.setHaveItemCLife(HaveItemLifeData.rLife);
  TUserObject(FBasicObject).SetLifeData;
end;

function THaveItemClass.setItemInputWindowsKey(aSubKey, akey: integer): boolean;
begin
  result := false;
  if (aSubKey < 0) or (aSubKey > 4) then
    exit;
  FItemInputWindowsKeyArr[aSubKey] := akey;
  FSendClass.SendItemInputWindowskey(aSubKey, akey);
  result := true;
end;

function THaveItemClass.SendItemPro(akey: integer): Boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;

  if HaveItemArr[akey].rName = '' then
    exit;
  FSendClass.Senditempro(HaveItemArr[akey]);

  Result := TRUE;
end;
//分离 模式 删除
//1，交易 使用
//2，邮寄
//3，寄售
{
function THaveItemClass.DelCleftItem(akey, acount:integer; aOutItemData:PTItemData):Boolean;
begin
    Result := FALSE;
    if boLocked = true then exit;
    if acount <= 0 then exit;
    if (akey < 0) or (akey > HAVEITEMSIZE - 1) then exit;
    if HaveItemArr[akey].rCount < acount then exit;

    aOutItemData^ := HaveItemArr[akey];
    aOutItemData.rCount := acount;
    HaveItemArr[akey].rCount := HaveItemArr[akey].rCount - aCount;
    if HaveItemArr[aKey].rCount <= 0 then
    begin
        FillChar(HaveItemArr[aKey], SizeOf(TItemData), 0);
    end else
    begin
        // NEWItemIDClass.ItemNewId(ItemData);
    end;

    FSendClass.SendHaveItem(aKey, HaveItemArr[akey]);

    Result := TRUE;
end;
}

//物品打孔

{function THaveItemClass.UpdateItemSetting_Stiletto(akey: integer): Integer;
var
  tempSettingCount: integer;
begin
  Result := -1;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then exit;
  if HaveItemArr[akey].rName = '' then exit;
  if HaveItemArr[akey].rboSetting = false then exit;
        ///////////////////////////////////////////////////////////
        //                    修改属性
  tempSettingCount := NewItemSetCount(HaveItemArr[akey]);
  FSendClass.SendHaveItem(aKey, HaveItemArr[akey]); //重新发送 物品
  ReQuestPlaySoundNumber := HaveItemArr[akey].rSoundEvent.rWavNumber;
  Result := tempSettingCount;           //返回随机生成孔的数量
end;  }

procedure THaveItemClass.QClear;
var
  i: integer;
begin
  for i := 0 to high(HaveItemArr) do
  begin
    if HaveItemArr[i].rName = '' then
      Continue;
    if HaveItemArr[i].rSpecialKind = 6 then
      DeletekeyItem(i, HaveItemArr[i].rCount);
  end;
end;


function THaveItemClass.UPdateItem_Setting(akey, aadditemKey: integer): boolean;
var
  boTRUE: BOOLEAN;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  if (aadditemKey < 0) or (aadditemKey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[aadditemKey].rName = '' then
    exit;
  if HaveItemArr[aadditemKey].rKind <> 121 then
    exit;

  if HaveItemArr[aadditemKey].rWearArr <> 100 then
    if HaveItemArr[aadditemKey].rWearArr <> HaveItemArr[akey].rWearArr then
      exit;
  boTRUE := false;
  if (boTRUE = false) and (HaveItemArr[akey].rSetting.rsettingcount >= 1) and (HaveItemArr[akey].rSetting.rsetting1 = '') then
  begin
    HaveItemArr[akey].rSetting.rsetting1 := HaveItemArr[aadditemKey].rName;
    DeletekeyItem(aadditemKey, 1);
    boTRUE := true;
  end;
  if (boTRUE = false) and (HaveItemArr[akey].rSetting.rsettingcount >= 2) and (HaveItemArr[akey].rSetting.rsetting2 = '') then
  begin
    HaveItemArr[akey].rSetting.rsetting2 := HaveItemArr[aadditemKey].rName;
    DeletekeyItem(aadditemKey, 1);
    boTRUE := true;
  end;
  if (boTRUE = false) and (HaveItemArr[akey].rSetting.rsettingcount >= 3) and (HaveItemArr[akey].rSetting.rsetting3 = '') then
  begin
    HaveItemArr[akey].rSetting.rsetting3 := HaveItemArr[aadditemKey].rName;
    DeletekeyItem(aadditemKey, 1);
    boTRUE := true;
  end;
  if (boTRUE = false) and (HaveItemArr[akey].rSetting.rsettingcount >= 4) and (HaveItemArr[akey].rSetting.rsetting4 = '') then
  begin
    HaveItemArr[akey].rSetting.rsetting4 := HaveItemArr[aadditemKey].rName;
    DeletekeyItem(aadditemKey, 1);
    boTRUE := true;
  end;
  if not boTRUE then
    exit;

  ItemLifeDataUPdate(HaveItemArr[akey]);
  FSendClass.SendHaveItem(aKey, HaveItemArr[akey]); //重新发送 物品
  ReQuestPlaySoundNumber := HaveItemArr[akey].rSoundEvent.rWavNumber;

  Result := TRUE;
end;

function THaveItemClass.UPdateItem_Setting_del(akey: integer): boolean;
var
  boTRUE: BOOLEAN;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  HaveItemArr[akey].rSetting.rsetting1 := '';
  HaveItemArr[akey].rSetting.rsetting2 := '';
  HaveItemArr[akey].rSetting.rsetting3 := '';
  HaveItemArr[akey].rSetting.rsetting4 := '';
  ItemLifeDataUPdate(HaveItemArr[akey]);
  FSendClass.SendHaveItem(aKey, HaveItemArr[akey]); //重新发送 物品
  ReQuestPlaySoundNumber := HaveItemArr[akey].rSoundEvent.rWavNumber;

  Result := TRUE;
end;

function THaveItemClass.UPdateItem_UPLevel_New(akey, alevel: integer): boolean;
var
  oldlevel: Integer;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  if HaveItemArr[akey].boUpgrade = false then
    exit;
  if HaveItemArr[akey].rboBlueprint then
    exit;

  ///////////////////////////////////////////////////////////
  //                    修改属性
  oldlevel := HaveItemArr[akey].rSmithingLevel;
  HaveItemArr[akey].rSmithingLevel := alevel; //修改等级
  ItemLifeDataUPdate(HaveItemArr[akey]); //重新 计算 物品 属性
  FSendClass.SendHaveItem(aKey, HaveItemArr[akey]); //重新发送 物品
  ReQuestPlaySoundNumber := HaveItemArr[akey].rSoundEvent.rWavNumber;
  //                    记录LOG
  logItemUpgrade(FBasicObject.BasicData.Name, HaveItemArr[akey].rName, oldlevel, alevel);
  Result := TRUE;
end;

function THaveItemClass.UPdateItem_UPLevel(akey, alevel: integer; aLifeData: TLifeData): boolean;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[akey].rName = '' then
    exit;
  if HaveItemArr[akey].boUpgrade = false then
    exit;
  if HaveItemArr[akey].rboBlueprint then
    exit;
  //   if HaveItemArr[akey].rSmithingLevel >= HaveItemArr[akey].MaxUpgrade then exit;
    // if astate then
    // begin
         ///////////////////////////////////////////////////////////
         //                    修改属性
  HaveItemArr[akey].rSmithingLevel := alevel; //修改等级
  HaveItemArr[akey].rLifeDataLevel := aLifeData;
  //    GatherLifeData(HaveItemArr[akey].rLifeDataLevel, aaddLifeData);
  ItemLifeDataUPdate(HaveItemArr[akey]); //重新 计算 物品 属性
  FSendClass.SendHaveItem(aKey, HaveItemArr[akey]); //重新发送 物品
  ReQuestPlaySoundNumber := HaveItemArr[akey].rSoundEvent.rWavNumber;
  {end else
  begin
    //  if HaveItemArr[akey].rSmithingLevel >= 3 then
      begin
          HaveItemArr[akey].rSmithingLevel := 0;
          fillchar(HaveItemArr[akey].rLifeDataLevel, sizeof(TLifeData), 0);
          ItemLifeDataUPdate(HaveItemArr[akey]);
          FSendClass.SendHaveItem(aKey, HaveItemArr[akey]);                   //重新发送 物品

      end;
      ReQuestPlaySoundNumber := HaveItemArr[akey].rSoundEvent.rWavNumber;
  end;
 }
  Result := TRUE;
end;

procedure THaveItemClass.DeleteAllItem; //@整理道具  专用
var
  i: Integer;
begin
  for i := 0 to HAVEITEMSIZE - 1 do
  begin
    FillChar(HaveItemArr[i], SizeOf(TItemData), 0);
    FSendClass.SendHaveItem(i, HaveItemArr[i]); //重新发送
  end;
end;

function THaveItemClass.SetPassword(aPassword: string): string;
var
  Password: string;
  nCount: integer;
begin
  Result := '';
  {    if boLocked = true then
      begin
          Result := '目前禁止使用本功能';
          exit;
      end;
      }
  Password := Trim(aPassword);
  if (Length(Password) < 4) or (Length(Password) > 8) then
  begin
    Result := '密码请设定4-8位数';
    exit;
  end;

  if boLockedPass = true then
  begin
    Result := '密码已设定';
    exit;
  end;

  boLockedPass := true;
  LockPassword := Password;

  //基本信息写入MYSQL
  if tuser(FBasicObject).SysopScope < 99 then
    tuser(FBasicObject).SetMysqlInfo;

  Result := '密码已设定,请牢记密码';

end;

function THaveItemClass.FreePassword(aPassword: string): string;
var
  Password: string;
  nStartPos, nEndPos, nCount, nPos: Integer;
begin
  Result := '';

  {    if boLocked = true then
      begin
          Result := '目前禁止使用本功能';
          exit;
      end;
   }
  Password := Trim(aPassword);
  if Password = '' then
  begin
    Result := '请输入密码';
    exit;
  end;

  if boLockedPass = false then
  begin
    Result := '还没设定密码';
    exit;
  end;

  if (LockPassword) <> aPassword then
  begin
    Result := '密码不正确';
    exit;
  end;

  boLockedPass := false;

  Result := '解除了密码';

end;

function THaveItemClass.UPdateAttach(akey, aAttach: integer): Boolean;
//唯一 扣 物品 指令
begin
  Result := FALSE;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit; //非法
  HaveItemArr[akey].rAttach := aAttach;
  ItemLifeDataUPdate(HaveItemArr[akey]);
  FSendClass.SendHaveItem(akey, HaveItemArr[akey]);
  Result := TRUE;
end;

procedure THaveItemClass.ItemWorldSay(aItemData: PTItemData);
begin
  if aItemData = nil then
    exit;

  UserList.SendCenterMSG(ColorSysToDxColor($00FFFFFF), format('小道消息: %s 携带〖%s〗在 %s(%d,%d)附近出现过。', [FBasicObject.BasicData.Name, aItemData.rViewName, FBasicObject.Manager.Title, FBasicObject.BasicData.x, FBasicObject.BasicData.y]), SHOWCENTERMSG_BatMsg);

end;

function THaveItemClass.DeleteKeyItem(akey, aCount: integer): Boolean;
//唯一 扣 物品 指令
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (akey < 0) or (akey > HAVEITEMSIZE - 1) then
    exit; //非法
  if aCount < 0 then
    EXIT; //非法
  if HaveItemArr[akey].rCount < aCount then
    EXIT; //数量不够
  HaveItemArr[akey].rCount := HaveItemArr[akey].rCount - aCount;
  if HaveItemArr[aKey].rCount <= 0 then
  begin //被扣完
    FillChar(HaveItemArr[aKey], SizeOf(TItemData), 0);
    FSendClass.SendUPDATEItem_del(suitHave, akey);
  end
  else
  begin //数量 减少
    FSendClass.SendUPDATEItem_rcount_dec(suitHave, akey, aCount);
  end;
  setLifeData;
  Result := TRUE;
//  if HaveItemArr[akey].rboLOG then
//    FrmMain.Logdrop(' ' + self.FUserName + ' 减少 ' + HaveItemArr[akey].rViewName + inttostr(aCount) + '个,背包剩余' + inttostr(HaveItemArr[akey].rcount) + '个');
end;
//扣数量 并非直接删除

function THaveItemClass.DeleteItem(aItemData: PTItemData): Boolean;
var
  i: integer;
begin
  Result := FALSE;

  //    if boLocked = true then exit;
  i := _GetItemName(aItemData.rName); //查找到位置
  if i = -1 then
    exit;
  Result := DeletekeyItem(i, aItemData.rCount); //删除掉
  {
for i := 0 to HAVEITEMSIZE - 1 do
begin
  if (HaveItemArr[i].rName) = (aItemData^.rName) then
  begin
      if HaveItemArr[i].rCount < aItemData^.rCount then exit;

      {    if (aItemData^.rPrice * aItemData^.rCount >= 100) or (aItemData^.rcolor <> 1) then
          begin
              if aItemData^.rOwnerName <> '' then
              begin
                  FSendClass.SendItemMoveInfo(FUserName + ',' + (aItemData.rOwnerName) + ',' + (aItemData^.rName) + ',' + IntToStr(aItemData^.rCount)
                      + ',' + IntToStr(aItemData^.rOwnerServerID) + ',' + IntToStr(aItemData.rOwnerX) + ',' + IntToStr(aItemData^.rOwnerY) + ',' + (aItemData^.rOwnerIP) + ',');
              end;
          end;
       }
    {  HaveItemArr[i].rCount := HaveItemArr[i].rCount - aItemData.rCount;
      if HaveItemArr[i].rCount = 0 then FillChar(HaveItemArr[i], sizeof(TItemData), 0);
      FSendClass.SendHaveItem(i, HaveItemArr[i]);
      Result := TRUE;
      exit;
  end;
end;
}
end;

function THaveItemClass.getpassword(): string;
begin
  result := (LockPassword);
end;

function THaveItemClass.colorItem(asour, adest: integer): Boolean;
var
  ItemData: TItemData;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (asour < 0) or (asour > HAVEITEMSIZE - 1) then
    exit;
  if (adest < 0) or (adest > HAVEITEMSIZE - 1) then
    exit;
  if HaveItemArr[adest].rName = '' then
    exit;
  if HaveItemArr[asour].rName = '' then
    exit;
  if (HaveItemArr[adest].rboColoring) = false then
    exit;
  if (HaveItemArr[adest].rKind = ITEM_KIND_COLORDRUG) then
    exit;
  if (HaveItemArr[adest].rKind = ITEM_KIND_CHANGER) then
    exit;

  if (HaveItemArr[asour].rKind <> ITEM_KIND_COLORDRUG) then
    exit;
  if (HaveItemArr[asour].rCount < 1) then
    exit;

  if INI_WHITEDRUG <> (HaveItemArr[asour].rName) then
  begin //脱色
    HaveItemArr[adest].rColor := HaveItemArr[asour].rColor;
  end
  else
  begin //染色
    HaveItemArr[adest].rColor := HaveItemArr[adest].rColor + HaveItemArr[asour].rColor;
  end;
  DeleteKeyItem(asour, 1); //扣物品
  FSendClass.SendUPDATEItem_rcolor(suitHave, adest, HaveItemArr[adest]);
  Result := TRUE;
end;

function THaveItemClass.ChangeItem(asour, adest: integer): Boolean;
var
  ItemData: TItemData;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  if (asour < 0) or (asour > HAVEITEMSIZE - 1) then
    exit;
  if (adest < 0) or (adest > HAVEITEMSIZE - 1) then
    exit;

  ItemData := HaveItemArr[asour];
  HaveItemArr[asour] := HaveItemArr[adest];
  HaveItemArr[adest] := ItemData;

  FSendClass.SendUPDATEItem_ChangeItem(suitHave, adest, asour);
  Result := TRUE;
end;
//重新 发送 1次

procedure THaveItemClass.sendItemAll;
var
  i: Integer;
begin
  for i := 0 to high(HaveItemArr) do
  begin
    FSendClass.SendHaveItem(i, HaveItemArr[i]);
  end;
end;

///////////////////////////////////
//         TWearItemClass
///////////////////////////////////

constructor TWearItemClass.Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
begin
  FdecItemDurabilityTick := 0;
  LockTick := mmAnsTick;
  boLocked := false;

  FBasicObject := aBasicObject;

  WearFeature := @FBasicObject.BasicData.Feature;
  ReQuestPlaySoundNumber := 0;
  FSendClass := aSendClass;
  FAttribClass := aAttribClass;
end;

destructor TWearItemClass.Destroy;
begin
  inherited destroy;
end;

procedure TWearItemClass.SetLifeData; //装备 计算出属性  境界加成 20130517
var
  i, suitid, suitcount, clife: integer;
begin
  FillChar(WearItemLifeData, sizeof(TLifeData), 0);
  //境界增加 攻击
  if FAttribClass.PowerLevelPdata <> nil then
  begin
    //百分比 增加武功身体攻击
    i := FAttribClass.PowerLevelPdata.damageBodyPercent;
    if (i > 0) and (WearItemArr[ARR_WEAPON].rName <> '') then
    begin
      WearItemLifeData.damageBody := trunc(WearItemArr[ARR_WEAPON].rLifeData.damageBody * (i / 100));
    end;
    //百分比增加衣服身体防御
    i := FAttribClass.PowerLevelPdata.armorBodyPercent;
    if (i > 0) and (WearItemArr[ARR_UPOVERWEAR].rName <> '') then
    begin
      WearItemLifeData.armorBody := trunc(WearItemArr[ARR_UPOVERWEAR].rLifeData.armorBody * (i / 100));
    end;
  end;
  suitcount := 0;
  suitid := 0;
  clife := 0;
  for i := ARR_GLOVES to ARR_MAX do
  begin
    if (WearItemArr[i].rName <> '') and (WearItemArr[i].rSuitId > 0) then
    begin
      if suitid = 0 then
        suitid := WearItemArr[i].rSuitId;
      if WearItemArr[i].rSuitId <> suitid then
        Break;
      if WearItemArr[i].rWearArr <> 9 then
        inc(suitcount);
    end;
  end;
  //装备加属性
  for i := ARR_GLOVES to ARR_MAX do
  begin //累加
    if (WearItemArr[i].rName <> '') and (WearItemArr[i].rlock = false) then
    begin
      //如果是令牌类装备
      if i = ARR_11_Special then
      begin
        //如果rAttribute>0 检测武器是否相同rAttribute
        if WearItemArr[i].rAttribute > 0 then
        begin
          //ShowMessage(IntToStr(WearItemArr[ARR_WEAPON].rAttribute));
          if WearItemArr[i].rAttribute = WearItemArr[ARR_WEAPON].rAttribute then
          begin
            clife := clife + WearItemArr[i].rcLife;
            GatherLifeData(WearItemLifeData, WearItemArr[i].rLifeData)
          end
        end
        //rAttribute 不>0直接增加属性
        else
        begin
          clife := clife + WearItemArr[i].rcLife;
          GatherLifeData(WearItemLifeData, WearItemArr[i].rLifeData)
        end;
      end
      else
      //不是令牌类装备
      begin
        clife := clife + WearItemArr[i].rcLife;
        GatherLifeData(WearItemLifeData, WearItemArr[i].rLifeData);
      //累加上套装属性
        if (suitcount >= 4) and (suitid = WearItemArr[i].rSuitId) then
          GatherLifeData(WearItemLifeData, WearItemArr[i].rLifeDataSuit);
      end
    end;
  end;
  //时装加属性
  for i := ARR_GLOVES to ARR_WEAPON do
  begin //累加
    if (WearFashionableItemArr[i].rName <> '') and (WearFashionableItemArr[i].rlock = false) then
    begin
      clife := clife + WearFashionableItemArr[i].rcLife;
      GatherLifeData(WearItemLifeData, WearFashionableItemArr[i].rLifeData);
    end;
  end;
  FAttribClass.setWearItemCLife(clife);
  TUserObject(FBasicObject).SetLifeData;

  //基本属性，装备属性，武功属性（ 三属性 叠加）
end;

procedure TWearItemClass.AddAttackExp(aexp: integer);
var
  oldslevel: integer;
begin
  if aexp < 0 then
    exit;
  if WearItemArr[ARR_10_Special].rName = '' then
    exit;
  if WearItemArr[ARR_10_Special].rSpecialKind = WEAR_SPECIAL_KIND_LEVEL then
  begin
  //经验珠子
    oldslevel := WearItemArr[ARR_10_Special].rSpecialLevel;
    _AddExp(_aet_Attack, WearItemArr[ARR_10_Special].rSpecialLevel, WearItemArr[ARR_10_Special].rSpecialexp, aexp, 0);
    if oldslevel <> WearItemArr[ARR_10_Special].rSpecialLevel then
    begin
    //下发
      FSendClass.SendUPDATEItem_rSpecialLevel(suitWear, ARR_10_Special, WearItemArr[ARR_10_Special]);
    end;
  end;
end;

function TWearItemClass.DecDurabilityWeapon(): boolean;
var
  bb: boolean;
  ItemData: titemdata;
  str: string;
  SubData: TSubData;
begin
  result := false;
  with WearItemArr[ARR_WEAPON] do
  begin
    if rName = '' then
      exit;
    if rboDurability = false then
    begin
      result := True;
      exit;
    end;
    //扣持久
    if (rCurDurability > 0) then
    begin

      rCurDurability := rCurDurability - 1;
      if rCurDurability < 0 then
        rCurDurability := 0;
      if (rCurDurability = 0) then
      begin
        rlock := true;
        bb := true;
      end;
      FSendClass.SendUPDATEItem_rDurability(suitWear, ARR_WEAPON, WearItemArr[ARR_WEAPON]);
      result := True;
    end;
    //是否消失
    if (rCurDurability <= 0) and rboNOTRepair then //无持久 不能修理
    begin
      rlock := true;
      bb := true;
      logItemMoveInfo('打击消耗删除', @FBasicObject.BasicData, nil, WearItemArr[ARR_WEAPON], FBasicObject.Manager.ServerID);
      FillChar(WearItemArr[ARR_WEAPON], sizeof(TItemData), 0);
      FSendClass.SendWearItem(ARR_WEAPON, witWear, WearItemArr[ARR_WEAPON]);

          //武功 换成默认武功。
      ViewItem(ARR_WEAPON, @ItemData);
      if ItemData.rName = '' then
      begin
        tuser(FBasicObject).HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
        tuser(FBasicObject).HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
      end;
      UPFeature;
      tuser(FBasicObject).SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, tuser(FBasicObject).BasicData, SubData);
    end;
  end;
  if bb then
    SetLifeData;
end;

procedure TWearItemClass.DecDurability();
var
  I: INTEGER;
  bb: boolean;
begin
  bb := false;
  for I := low(WearItemArr) to HIGH(WearItemArr) do
  begin
    if i = ARR_WEAPON then
      Continue;
    with WearItemArr[I] do
    begin
      if rName = '' then
        Continue;
      if rboDurability = false then
        Continue;
      //扣持久
      if (rCurDurability > 0) then
      begin
        rCurDurability := rCurDurability - 1;
        if rCurDurability < 0 then
          rCurDurability := 0;
        if (rCurDurability = 0) then
        begin
          rlock := true;
          bb := true;
        end;
        FSendClass.SendUPDATEItem_rDurability(suitWear, i, WearItemArr[i]);
      end;
      //是否消失
      if (rCurDurability <= 0) and rboNOTRepair then //无持久 不能修理
      begin
        rlock := true;
        bb := true;
        logItemMoveInfo('打击消耗删除', @FBasicObject.BasicData, nil, WearItemArr[I], FBasicObject.Manager.ServerID);
        FillChar(WearItemArr[i], sizeof(TItemData), 0);
        FSendClass.SendWearItem(i, witWear, WearItemArr[i]);
      end;
    end;
  end;
  if bb then
    SetLifeData;
end;


procedure TWearItemClass.ItemTimeMode(CurTick: integer);
var
  I, F: INTEGER;
  bb: boolean;
  ItemData: titemdata;
  str: string;
  SubData: TSubData;
begin
  if CurTick > FdecItemDurabilityTick then
  begin
    f := GetItemLineTime(CurTick - LockTick);
    if f <= 0 then
      exit;
    LockTick := CurTick;

    FdecItemDurabilityTick := CurTick + 6000; //1分钟检测次
    bb := false;
    for I := low(WearItemArr) to HIGH(WearItemArr) do
    begin
      with WearItemArr[I] do
      begin
        if rName = '' then
          Continue;
        //有时间模式删除执行
        if rboTimeMode = true then
        begin
          if now() > rDateTime then
          begin
            bb := true;
            logItemMoveInfo('时间模式删除', @FBasicObject.BasicData, nil, WearItemArr[I], FBasicObject.Manager.ServerID);
            tuser(FBasicObject).SendClass.SendChatMessage(format('%s物品使用时间到期', [WearItemArr[I].rViewName]), SAY_COLOR_SYSTEM);
            DeleteKeyItem(i);
          //武功 换成默认武功。
            ViewItem(ARR_WEAPON, @ItemData);
            if ItemData.rName = '' then
            begin
              tuser(FBasicObject).HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
              tuser(FBasicObject).HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
            end;
            UPFeature;
            tuser(FBasicObject).SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, tuser(FBasicObject).BasicData, SubData);
          end;
        end;

        //锁定问题
        if rlockState = 2 then //0,无锁状态，1,是加锁状态,2,是解锁状态
        begin
          if (rlocktime + f) > (60 * 24) then
          begin //24小时 解除 锁定
            rlockState := 0;
            FSendClass.SendUPDATEItem_rlockState(suitHave, i, WearItemArr[i]);
          end
          else
          begin
            rlocktime := rlocktime + f;
            FSendClass.SendUPDATEItem_rlocktime(suitHave, i, WearItemArr[i]);
          end;
        end;
      end;
    end;
    for I := low(WearFashionableItemArr) to HIGH(WearFashionableItemArr) do
    begin
      with WearFashionableItemArr[I] do
      begin
        if rName = '' then
          Continue;
        //有时间模式删除执行
        if rboTimeMode = true then
        begin
          if now() > rDateTime then
          begin
            bb := true;
            logItemMoveInfo('时间模式删除', @FBasicObject.BasicData, nil, WearFashionableItemArr[I], FBasicObject.Manager.ServerID);
            tuser(FBasicObject).SendClass.SendChatMessage(format('%s物品使用时间到期', [WearFashionableItemArr[I].rViewName]), SAY_COLOR_SYSTEM);
            DeleteKeyItemFD(i);
            UPFeature;
            tuser(FBasicObject).SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, tuser(FBasicObject).BasicData, SubData);
          end;
        end;
        //锁定问题
        if rlockState = 2 then //0,无锁状态，1,是加锁状态,2,是解锁状态
        begin
          if (rlocktime + f) > (60 * 24) then
          begin //24小时 解除 锁定
            rlockState := 0;
            FSendClass.SendUPDATEItem_rlockState(suitHave, i, WearFashionableItemArr[i]);
          end
          else
          begin
            rlocktime := rlocktime + f;
            FSendClass.SendUPDATEItem_rlocktime(suitHave, i, WearFashionableItemArr[i]);
          end;
        end;
      end;
    end;
    if bb then
      SetLifeData;
  end;
end;
//
//procedure TWearItemClass.ItemTimeMode(CurTick: integer);
//var
//  I: INTEGER;
//  bb: boolean;
//  ItemData: titemdata;
//  str: string;
//  SubData: TSubData;
//begin
//  if CurTick > FdecItemDurabilityTick then
//  begin
//    FdecItemDurabilityTick := CurTick + 6000;
//    bb := false;
//    for I := low(WearItemArr) to HIGH(WearItemArr) do
//    begin
//      with WearItemArr[I] do
//      begin
//        if rName = '' then
//          Continue;
//        if rboTimeMode = false then
//          Continue;
//        if now() > rDateTime then
//        begin
//          bb := true;
//          logItemMoveInfo('时间模式删除', @FBasicObject.BasicData, nil, WearItemArr[I], FBasicObject.Manager.ServerID);
//          tuser(FBasicObject).SendClass.SendChatMessage(format('%s物品使用时间到期', [WearItemArr[I].rViewName]), SAY_COLOR_SYSTEM);
//          DeleteKeyItem(i);
//          //武功 换成默认武功。
//          ViewItem(ARR_WEAPON, @ItemData);
//          if ItemData.rName = '' then
//          begin
//            tuser(FBasicObject).HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
//            tuser(FBasicObject).HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
//          end;
//          UPFeature;
//          tuser(FBasicObject).SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, tuser(FBasicObject).BasicData, SubData);
//        end;
//      end;
//    end;
//    for I := low(WearFashionableItemArr) to HIGH(WearFashionableItemArr) do
//    begin
//      with WearFashionableItemArr[I] do
//      begin
//        if rName = '' then
//          Continue;
//        if rboTimeMode = false then
//          Continue;
//        if now() > rDateTime then
//        begin
//          bb := true;
//
//          logItemMoveInfo('时间模式删除', @FBasicObject.BasicData, nil, WearFashionableItemArr[I], FBasicObject.Manager.ServerID);
//          tuser(FBasicObject).SendClass.SendChatMessage(format('%s物品使用时间到期', [WearItemArr[I].rViewName]), SAY_COLOR_SYSTEM);
//          DeleteKeyItemFD(i);
//          //武功 换成默认武功。
//          ViewItem(ARR_WEAPON, @ItemData);
//          if ItemData.rName = '' then
//          begin
//            tuser(FBasicObject).HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
//            tuser(FBasicObject).HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
//          end;
//          UPFeature;
//          tuser(FBasicObject).SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, tuser(FBasicObject).BasicData, SubData);
//        end;
//      end;
//    end;
//    if bb then
//      SetLifeData;
//  end;
//end;

procedure TWearItemClass.PowerLevelUPDATE();
begin
  SetLifeData;
end;

procedure TWearItemClass.Update(CurTick: integer);
begin
  ItemTimeMode(CurTick);
end;

function SETfellowshipToFeature(id: integer): TFeature;
var
  Acolor: word;
  i: integer;
begin

  if (id < 100) or (id > 9999) then
  begin

    exit;
  end
  else
  begin

    Result.rfellowship := id;

    i := (id - 100) mod 18;
    //
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

    Result.rNameColor := Acolor;

  end;
end;

function ChangeCharDataToFeature(aCharData: PTDBRecord): TFeature;
var
  i: Integer;
  WearItemArr: array[ARR_BODY..ARR_MAX] of TItemData;
begin
  FillChar(WearItemArr, sizeof(WearItemArr), 0);
  if (aCharData^.Sex) = true then
    Result.rboMan := TRUE
  else
    Result.rboMan := FALSE;

  Result.rArr[ARR_BODY * 2] := 0;
  copydbItemtoitem(aCharData^.WearItemArr[4], WearItemArr[ARR_DOWNUNDERWEAR]);
  copydbItemtoitem(aCharData^.WearItemArr[2], WearItemArr[ARR_UPUNDERWEAR]);
  copydbItemtoitem(aCharData^.WearItemArr[6], WearItemArr[ARR_SHOES]); //鞋子
  copydbItemtoitem(aCharData^.WearItemArr[3], WearItemArr[ARR_UPOVERWEAR]);
  copydbItemtoitem(aCharData^.WearItemArr[5], WearItemArr[ARR_GLOVES]);
  copydbItemtoitem(aCharData^.WearItemArr[0], WearItemArr[ARR_HAIR]);
  copydbItemtoitem(aCharData^.WearItemArr[1], WearItemArr[ARR_CAP]);
  copydbItemtoitem(aCharData^.WearItemArr[7], WearItemArr[ARR_WEAPON]);

  copydbItemtoitem(aCharData^.WearItemArr[8], WearItemArr[ARR_10_Special]);
  copydbItemtoitem(aCharData^.WearItemArr[9], WearItemArr[ARR_11_Special]);
  copydbItemtoitem(aCharData^.WearItemArr[10], WearItemArr[ARR_12_Special]);
  copydbItemtoitem(aCharData^.WearItemArr[11], WearItemArr[ARR_13_Special]);
     //删除 任务 装备
  for i := 0 to high(WearItemArr) do
  begin
    if WearItemArr[i].rName = '' then
      Continue;
    if WearItemArr[i].rSpecialKind = 6 then
      FillChar(WearItemArr[i], sizeof(TItemData), 0);
  end;

  Result.rrace := RACE_HUMAN;
  Result.rFeaturestate := wfs_normal;
  Result.rNameColor := WinRGB(31, 31, 31); //WinRGB(25, 25, 25);
  Result.rTeamColor := 0;
  Result := SETfellowshipToFeature(aCharData.GroupKey);

  for i := ARR_GLOVES to high(WearItemArr) do
  begin
    if i <= ARR_WEAPON then
    begin
      if aCharData^.WearItemArr[i].rName <> '' then
      begin

        Result.rArr[i * 2] := WearItemArr[i].rWearShape;
        Result.rArr[i * 2 + 1] := WearItemArr[i].rColor;

      end;
    end;
  end;
end;

procedure TWearItemClass.LoadFromSdb(aCharData: PTDBRecord);
var
  i: integer;
  str: string;
begin
  boLocked := false;
  ReQuestPlaySoundNumber := 0;

  FillChar(WearItemArr, sizeof(WearItemArr), 0);
  // Fillchar(WearFeature^, sizeof(TFeature), 0);

   //if (aCharData^.Sex) = INI_SEX_FIELD_MAN then WearFeature.rboMan := TRUE
  if (aCharData^.Sex) = true then
    WearFeature.rboMan := TRUE
  else
    WearFeature.rboMan := FALSE;

  WearFeature.rArr[ARR_BODY * 2] := 0;

  copydbItemtoitem(aCharData^.WearItemArr[4], WearItemArr[ARR_DOWNUNDERWEAR]);
  copydbItemtoitem(aCharData^.WearItemArr[2], WearItemArr[ARR_UPUNDERWEAR]);
  copydbItemtoitem(aCharData^.WearItemArr[6], WearItemArr[ARR_SHOES]); //鞋子
  copydbItemtoitem(aCharData^.WearItemArr[3], WearItemArr[ARR_UPOVERWEAR]);
  copydbItemtoitem(aCharData^.WearItemArr[5], WearItemArr[ARR_GLOVES]);
  copydbItemtoitem(aCharData^.WearItemArr[0], WearItemArr[ARR_HAIR]);
  copydbItemtoitem(aCharData^.WearItemArr[1], WearItemArr[ARR_CAP]);
  copydbItemtoitem(aCharData^.WearItemArr[7], WearItemArr[ARR_WEAPON]);

  copydbItemtoitem(aCharData^.WearItemArr[8], WearItemArr[ARR_10_Special]);
  copydbItemtoitem(aCharData^.WearItemArr[9], WearItemArr[ARR_11_Special]);
  copydbItemtoitem(aCharData^.WearItemArr[10], WearItemArr[ARR_12_Special]);
  copydbItemtoitem(aCharData^.WearItemArr[11], WearItemArr[ARR_13_Special]);
  //时装 读入
  FillChar(WearFashionableItemArr, sizeof(WearFashionableItemArr), 0);
  boFashionable := aCharData^.FashionableDress;
  copydbItemtoitem(aCharData^.FashionableDressArr[4], WearFashionableItemArr[ARR_DOWNUNDERWEAR]);
  copydbItemtoitem(aCharData^.FashionableDressArr[2], WearFashionableItemArr[ARR_UPUNDERWEAR]);
  copydbItemtoitem(aCharData^.FashionableDressArr[6], WearFashionableItemArr[ARR_SHOES]); //鞋子
  copydbItemtoitem(aCharData^.FashionableDressArr[3], WearFashionableItemArr[ARR_UPOVERWEAR]);
  copydbItemtoitem(aCharData^.FashionableDressArr[5], WearFashionableItemArr[ARR_GLOVES]);
  copydbItemtoitem(aCharData^.FashionableDressArr[0], WearFashionableItemArr[ARR_HAIR]);
  copydbItemtoitem(aCharData^.FashionableDressArr[1], WearFashionableItemArr[ARR_CAP]);
  copydbItemtoitem(aCharData^.FashionableDressArr[7], WearFashionableItemArr[ARR_WEAPON]);
  //删除 任务 装备
  for i := 0 to high(WearItemArr) do
  begin
    if WearItemArr[i].rName = '' then
      Continue;
    if WearItemArr[i].rSpecialKind = 6 then
      FillChar(WearItemArr[i], sizeof(TItemData), 0);
  end;

  for i := 0 to high(WearFashionableItemArr) do
  begin
    if WearFashionableItemArr[i].rName = '' then
      Continue;
    if WearFashionableItemArr[i].rSpecialKind = 6 then
      FillChar(WearFashionableItemArr[i], sizeof(TItemData), 0);
  end;

  WearFeature.rrace := RACE_HUMAN;
  WearFeature.rFeaturestate := wfs_normal;
  WearFeature.rNameColor := WinRGB(31, 31, 31); //WinRGB(25, 25, 25);
  WearFeature.rTeamColor := 0;

  SETfellowship(aCharData.GroupKey);
  for i := ARR_GLOVES to high(WearItemArr) do
  begin
    if i <= ARR_WEAPON then
    begin
      if WearItemArr[i].rName <> '' then
      begin
        if not boFashionable then
        begin
          WearFeature.rArr[i * 2] := WearItemArr[i].rWearShape;
          WearFeature.rArr[i * 2 + 1] := WearItemArr[i].rColor;
        end;
        { if WearItemArr[6].rKind = ITEM_KIND_WEARITEM2 then
         begin
             if (i = 2) or (i = 4) then continue;
         end;}
      end;
    end;
    if WearItemArr[i].rName <> '' then
      FSendClass.SendWearItem(i, witWear, WearItemArr[i]);
  end;

  for i := ARR_GLOVES to ARR_WEAPON do
  begin
    if WearFashionableItemArr[i].rName <> '' then
    begin
      if boFashionable then
      begin
        if i = ARR_WEAPON then //武器
        begin
          WearFeature.rArr[i * 2] := WearItemArr[i].rWearShape;
          WearFeature.rArr[i * 2 + 1] := WearItemArr[i].rColor;
        end
        else
        begin
          WearFeature.rArr[i * 2] := WearFashionableItemArr[i].rWearShape;
          WearFeature.rArr[i * 2 + 1] := WearFashionableItemArr[i].rColor;
        end;
      end;
    end;
    if WearFashionableItemArr[i].rName <> '' then
      FSendClass.SendWearItem(i, witWearFD, WearFashionableItemArr[i]);
  end;

  SetLifeData;
end;

procedure TWearItemClass.SaveToSdb(aCharData: PTDBRecord);
var
  str, rdstr: string;
begin

  CopyItemToDBItem(WearItemArr[ARR_DOWNUNDERWEAR], aCharData^.WearItemArr[4]);
  CopyItemToDBItem(WearItemArr[ARR_UPUNDERWEAR], aCharData^.WearItemArr[2]);
  CopyItemToDBItem(WearItemArr[ARR_SHOES], aCharData^.WearItemArr[6]);
  CopyItemToDBItem(WearItemArr[ARR_UPOVERWEAR], aCharData^.WearItemArr[3]);
  CopyItemToDBItem(WearItemArr[ARR_GLOVES], aCharData^.WearItemArr[5]);
  CopyItemToDBItem(WearItemArr[ARR_HAIR], aCharData^.WearItemArr[0]);
  CopyItemToDBItem(WearItemArr[ARR_CAP], aCharData^.WearItemArr[1]);
  CopyItemToDBItem(WearItemArr[ARR_WEAPON], aCharData^.WearItemArr[7]);

  CopyItemToDBItem(WearItemArr[ARR_10_Special], aCharData^.WearItemArr[8]);
  CopyItemToDBItem(WearItemArr[ARR_11_Special], aCharData^.WearItemArr[9]);
  CopyItemToDBItem(WearItemArr[ARR_12_Special], aCharData^.WearItemArr[10]);
  CopyItemToDBItem(WearItemArr[ARR_13_Special], aCharData^.WearItemArr[11]);

  aCharData.GroupKey := WearFeature.rfellowship;
  CopyItemToDBItem(WearFashionableItemArr[ARR_DOWNUNDERWEAR], aCharData^.FashionableDressArr[4]);
  CopyItemToDBItem(WearFashionableItemArr[ARR_UPUNDERWEAR], aCharData^.FashionableDressArr[2]);
  CopyItemToDBItem(WearFashionableItemArr[ARR_SHOES], aCharData^.FashionableDressArr[6]);
  CopyItemToDBItem(WearFashionableItemArr[ARR_UPOVERWEAR], aCharData^.FashionableDressArr[3]);
  CopyItemToDBItem(WearFashionableItemArr[ARR_GLOVES], aCharData^.FashionableDressArr[5]);
  CopyItemToDBItem(WearFashionableItemArr[ARR_HAIR], aCharData^.FashionableDressArr[0]);
  CopyItemToDBItem(WearFashionableItemArr[ARR_CAP], aCharData^.FashionableDressArr[1]);
  CopyItemToDBItem(WearFashionableItemArr[ARR_WEAPON], aCharData^.FashionableDressArr[7]);
  aCharData^.FashionableDress := boFashionable;

end;

function TWearItemClass.GETfellowship(): integer;
begin
  result := WearFeature.rfellowship;
end;

function TWearItemClass.SETfellowship(id: integer): boolean;
var
  Acolor: word;
  i: integer;
begin
  result := false;
  if (id < 100) or (id > 9999) then
  begin

    exit;
  end
  else
  begin

    WearFeature.rfellowship := id;

    i := (id - 100) mod 18;
    //
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

    WearFeature.rNameColor := Acolor;
    result := true;
  end;
end;

procedure TWearItemClass.UPFeature;
var
  i, aHitMotion: integer;
begin
  FBasicObject.BasicData.Feature.rTeamColor := 0; //换装备取消人浮空

  WearFeature.rrace := RACE_HUMAN; //物体类型  人物什么的
  //VIP
  if now() < FAttribClass.AttribData.VipUseTime then
    WearFeature.rboVip := true
  else
    WearFeature.rboVip := False;

  WearFeature.rboFashionable := boFashionable;
  //WearFeature.rEffect_WEAPON_color := 0;
  if WearItemArr[ARR_WEAPON].rWeaponLevelColor_PP <> nil then
    if WearItemArr[ARR_WEAPON].rName <> '' then
    begin
      i := WearItemArr[ARR_WEAPON].rSmithingLevel;
      if (i >= 0) and (i < high(WearItemArr[ARR_WEAPON].rWeaponLevelColor_PP.LevelArr)) then
      begin
        WearFeature.rEffect_WEAPON_color := WearItemArr[ARR_WEAPON].rWeaponLevelColor_PP.LevelArr[i];
       // ShowMessage(IntToStr(WearFeature.rEffect_WEAPON_color));
      end;
    end;
  //显示角色外观
  for i := ARR_GLOVES to ARR_WEAPON do
  begin
    //FSendClass.SendChatMessage(format('WearItemArr[%d].rColor=%d', [i, WearItemArr[i].rColor]), SAY_COLOR_SYSTEM);
    if (boFashionable) and (WearFashionableItemArr[i].rName <> '') then
    begin
      WearFeature.rArr[i * 2] := WearFashionableItemArr[i].rWearShape;
      WearFeature.rArr[i * 2 + 1] := WearFashionableItemArr[i].rColor;
//      if WearFashionableItemArr[i].rName <> '' then
//      begin
//        WearFeature.rArr[i * 2] := WearFashionableItemArr[i].rWearShape;
//        WearFeature.rArr[i * 2 + 1] := WearFashionableItemArr[i].rColor;
//      end
//      else
//      begin
//        WearFeature.rArr[i * 2] := WearItemArr[i].rWearShape;
//        WearFeature.rArr[i * 2 + 1] := WearItemArr[i].rColor;
//      end;
    end
    else
    begin
      WearFeature.rArr[i * 2] := WearItemArr[i].rWearShape;
      WearFeature.rArr[i * 2 + 1] := WearItemArr[i].rColor;
    end;
  end;

  if WearFeature.rArr[ARR_GLOVES * 2] <> 0 then
  begin
    if (boFashionable) and (WearFashionableItemArr[ARR_GLOVES].rName <> '') then
    begin
      WearFeature.rArr[5 * 2] := WearFashionableItemArr[ARR_GLOVES].rWearShape;
      WearFeature.rArr[5 * 2 + 1] := WearFashionableItemArr[ARR_GLOVES].rColor;
    end
    else
    begin
      WearFeature.rArr[5 * 2] := WearItemArr[ARR_GLOVES].rWearShape;
      WearFeature.rArr[5 * 2 + 1] := WearItemArr[ARR_GLOVES].rColor;
    end;
  end;
  //武器 攻击动作 类型
  {if boFashionable then
  begin
      aHitMotion := WearFashionableItemArr[ARR_WEAPON].rHitMotion;
  end else }
  begin
    aHitMotion := WearItemArr[ARR_WEAPON].rHitMotion;
  end;

  case aHitMotion of
    0:
      WearFeature.rhitmotion := AM_HIT; //拳头
    1:
      WearFeature.rhitmotion := AM_HIT1; //
    2:
      WearFeature.rhitmotion := AM_HIT2; //剑 刀
    3:
      WearFeature.rhitmotion := AM_HIT3; //抢 斧
    4:
      WearFeature.rhitmotion := AM_HIT4; //弓箭
    5:
      WearFeature.rhitmotion := AM_HIT5; //
    6:
      WearFeature.rhitmotion := AM_HIT6; //
    7:
      WearFeature.rhitmotion := AM_HIT7; //
    9:
      WearFeature.rhitmotion := AM_HIT9; //
    12:
      WearFeature.rhitmotion := AM_HIT8;
  end;

  //  Result := WearFeature;
end;

function TWearItemClass.GetWeaponAttribute: Integer;
begin
  if WearItemArr[ARR_WEAPON].rName = '' then
  begin
    Result := 0;
    exit;
  end;

  Result := WearItemArr[ARR_WEAPON].rAttribute;
end;

function TWearItemClass.GetWeaponName: string;
begin
  Result := '';
  if WearItemArr[ARR_WEAPON].rName = '' then
    exit;

  Result := WearItemArr[ARR_WEAPON].rName;
end;

function TWearItemClass.GetWeaponType: Integer;
begin
  if WearItemArr[ARR_WEAPON].rName = '' then
  begin
    Result := MAGICTYPE_WRESTLING;
    exit;
  end;

  Result := WearItemArr[ARR_WEAPON].rHitType;
end;

function TWearItemClass.GetWeaponGuild: boolean;
begin
  if WearItemArr[ARR_WEAPON].rName = '' then
  begin
    Result := false;
    exit;
  end;

  Result := WearItemArr[ARR_WEAPON].rKind = ITEM_KIND_WEARITEM_GUILD;
  //攻击门派石 特殊武器
end;

function TWearItemClass.RepairGoldSum(): integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to high(WearItemArr) do
  begin
    if WearItemArr[i].rName = '' then
      Continue;
    if WearItemArr[i].rboDurability = false then
      Continue;
    if WearItemArr[i].rboNOTRepair then
      Continue;
    if WearItemArr[i].rCurDurability = WearItemArr[i].rDurability then
      Continue;
    result := result + WearItemArr[i].rRepairPrice * (WearItemArr[i].rDurability - WearItemArr[i].rCurDurability);
  end;
end;

function TWearItemClass.RepairAll(): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to high(WearItemArr) do
  begin
    if WearItemArr[i].rName = '' then
      Continue;
    if WearItemArr[i].rboDurability = false then
      Continue;
    if WearItemArr[i].rboNOTRepair then
      Continue;
    if WearItemArr[i].rCurDurability = WearItemArr[i].rDurability then
      Continue;
    WearItemArr[i].rCurDurability := WearItemArr[i].rDurability;
    FSendClass.SendUPDATEItem_rDurability(suitWear, i, WearItemArr[i]);
  end;
  result := true;
end;

function TWearItemClass.getViewItemFD(akey: integer): PTItemData;
begin
  Result := nil;

  if boLocked = true then
    exit;

  if (akey < 0) or (akey > high(WearFashionableItemArr)) then
    exit;
  if WearFashionableItemArr[akey].rName = '' then
    exit;
  Result := @WearFashionableItemArr[akey];
end;

function TWearItemClass.getViewItem(akey: integer): PTItemData;
begin
  Result := nil;

  if boLocked = true then
    exit;

  if (akey < 0) or (akey > high(WearItemArr)) then
    exit;
  if WearItemArr[akey].rName = '' then
    exit;
  Result := @WearItemArr[akey];
end;

function TWearItemClass.ViewItem(akey: integer; aItemData: PTItemData): Boolean;
begin
  Result := FALSE;
  if boLocked = true then
    exit;
  if (akey < 0) or (akey > high(WearItemArr)) then
  begin
    FillChar(aItemData^, sizeof(TItemData), 0);
    exit;
  end;
  if WearItemArr[akey].rName = '' then
  begin
    FillChar(aItemData^, sizeof(TItemData), 0);
    exit;
  end;
  Move(WearItemArr[akey], aItemData^, SizeOf(TItemData));
  Result := TRUE;
end;

function TWearItemClass.GetWearItemName(akey: integer): string;
begin
  Result := '';
  if boLocked = true then
    exit;
  if (akey < 0) or (akey > high(WearItemArr)) then
    exit;

  if WearItemArr[akey].rName = '' then
    exit;

  Result := (WearItemArr[akey].rName);
end;

function TWearItemClass.ViewItemFD(akey: integer; aItemData: PTItemData): Boolean;
begin
  Result := FALSE;
  if boLocked = true then
    exit;
  if (akey < 0) or (akey > high(WearFashionableItemArr)) then
  begin
    FillChar(aItemData^, sizeof(TItemData), 0);
    exit;
  end;
  if WearFashionableItemArr[akey].rName = '' then
  begin
    FillChar(aItemData^, sizeof(TItemData), 0);
    exit;
  end;
  Move(WearFashionableItemArr[akey], aItemData^, SizeOf(TItemData));
  Result := TRUE;
end;

//激活穿戴装备脚本

procedure TWearItemClass.StartItem;
var
  i: Integer;
begin
  for i := ARR_GLOVES to ARR_MAX do
  begin
    if (WearItemArr[i].rName <> '') and (WearItemArr[i].rSpecialKind = WEAR_SPECIAL_KIND_Scripter) then
      ItemClass.CallLuaScriptFunction(WearItemArr[i].rScripter, 'OnWearItemOn', [integer(FBasicObject), i]);
  end;
end;

//增加

function TWearItemClass.AddItem(aItemData: PTItemData): Boolean;
var
  ItemData: TItemData;
begin
  Result := FALSE;
  if boLocked = true then
    exit;
  //范围 检查
  if (aItemData^.rWearArr < low(WearItemArr)) or (aItemData^.rWearArr > (high(WearItemArr))) then
    exit;
  //身上 位置 检查  已经有是无法装置
  if WearItemArr[aItemData^.rWearArr].rName <> '' then
    exit;
  //物品 检查
  if aItemData^.rName = '' then
    exit;
  if (aItemData.rKind <> ITEM_KIND_WEARITEM) //6
  //        and (aItemData.rKind <> ITEM_KIND_WEARITEM2)                            //24
   //       and (aItemData.rKind <> ITEM_KIND_WEARITEM_29)                          //29
  and (aItemData.rKind <> ITEM_KIND_WEARITEM_GUILD) then
    exit;

  //是否图纸
  if aItemData.rboBlueprint then
    exit;
  case aItemData^.rSex of
    1:
      if not WearFeature.rboMan then
        exit;
    2:
      if WearFeature.rboMan then
        exit;
  end;

  Move(aItemData^, WearItemArr[aItemData^.rWearArr], SizeOf(TItemData));
  WearItemArr[aItemData^.rWearArr].rCount := 1;
  {
   if (aItemData^.rWearArr = 6) and (aItemData^.rKind = ITEM_KIND_WEARITEM2) then
   begin
       FillChar(ItemData, SizeOf(TItemData), 0);
       FSendClass.SendWearItem(2, ItemData);
       FSendClass.SendWearItem(4, ItemData);
       FSendClass.SendWearItem(aItemData^.rWearArr, aItemData^);
   end else if (aItemData^.rWearArr = 2) or (aItemData^.rWearArr = 4) then
   begin
       if WearItemArr[6].rKind <> ITEM_KIND_WEARITEM2 then
       begin
           FSendClass.SendWearItem(aItemData^.rWearArr, aItemData^);
       end;
   end else
   }
  begin
    FSendClass.SendWearItem(aItemData^.rWearArr, witWear, aItemData^);
  end;
  ReQuestPlaySoundNumber := aItemData^.rSoundEvent.rWavNumber;

  if WearItemArr[aItemData^.rWearArr].rSpecialKind = WEAR_SPECIAL_KIND_Scripter then
  begin
    //ItemClass.CallScriptFunction(aItemData.rScripter, 'OnWearItemOn', [integer(FBasicObject), aItemData^.rWearArr]);
    ItemClass.CallLuaScriptFunction(aItemData.rScripter, 'OnWearItemOn', [integer(FBasicObject), aItemData^.rWearArr]);
  end;

  SetLifeData;
  FBasicObject.CallLuaScriptFunction('OnChangeWearItem', [integer(TUserObject(FBasicObject))]); //装备切换触发
  Result := TRUE;
end;

function TWearItemClass.AddItemFD(aItemData: PTItemData): Boolean;
var
  ItemData: TItemData;
begin
  Result := FALSE;
  if boLocked = true then
    exit;
  //范围 检查
  if (aItemData^.rWearArr < low(WearItemArr)) or (aItemData^.rWearArr > (high(WearItemArr))) then
    exit;
  //身上 位置 检查  已经有是无法装置
  if WearFashionableItemArr[aItemData^.rWearArr].rName <> '' then
    exit;
  if aItemData.rboBlueprint then
    exit;
  //物品 检查
  if aItemData^.rName = '' then
    exit;
  if (aItemData^.rKind <> ITEM_KIND_WEARITEM_FD) then
    exit;

  case aItemData^.rSex of
    1:
      if not WearFeature.rboMan then
        exit;
    2:
      if WearFeature.rboMan then
        exit;
  end;
  Move(aItemData^, WearFashionableItemArr[aItemData^.rWearArr], SizeOf(TItemData));
  WearFashionableItemArr[aItemData^.rWearArr].rCount := 1;

  begin
    FSendClass.SendWearItem(aItemData^.rWearArr, witWearFD, aItemData^);
  end;
  ReQuestPlaySoundNumber := aItemData^.rSoundEvent.rWavNumber;

  SetLifeData;
  Result := TRUE;
end;
//改变

function TWearItemClass.ChangeItem(var aItemData: TItemData; var aOldItemData: TItemData): Boolean;
var
  ItemData: TItemData;
  Tm_Special: Integer;
begin

  Result := FALSE;

  if boLocked = true then
    exit; //锁
  if aItemData.rName = '' then
    exit; //物品是否有效
  if (aItemData.rKind <> ITEM_KIND_WEARITEM)
    //        and (aItemData.rKind <> ITEM_KIND_WEARITEM2)
 //       and (aItemData.rKind <> ITEM_KIND_WEARITEM_29)
  and (aItemData.rKind <> ITEM_KIND_WEARITEM_27) and (aItemData.rKind <> ITEM_KIND_WEARITEM_GUILD) then
    exit;

  //范围 检查
  if (aItemData.rWearArr < low(WearItemArr)) or (aItemData.rWearArr > (high(WearItemArr))) then
    exit;

  if aItemData.rboBlueprint then
    exit;
  //判断性别
  case aItemData.rSex of
    1:
      if not WearFeature.rboMan then
        exit;
    2:
      if WearFeature.rboMan then
        exit;
  end;
  //命格装备穿戴
  if aItemData.rWearArr = ARR_12_Special then
  begin
    Tm_Special := ARR_12_Special;
    //判断2个物品都为空
    if (WearItemArr[ARR_12_Special].rName = '') and (WearItemArr[ARR_13_Special].rName = '') then
    begin
      FillChar(aOldItemData, SizeOf(TItemData), 0);
    end
    //判断第一个天命不为空，且 rAttribute 一样，取下第一个天命
    else if (WearItemArr[ARR_12_Special].rName <> '') and (WearItemArr[ARR_12_Special].rAttribute = aItemData.rAttribute) then
    begin
      Tm_Special := ARR_12_Special;
    end
    //判断第二个天命不为空，且 rAttribute 一样，取下第二个天命
    else if (WearItemArr[ARR_13_Special].rName <> '') and (WearItemArr[ARR_13_Special].rAttribute = aItemData.rAttribute) then
    begin
      Tm_Special := ARR_13_Special;
    end
    //没有发现一致的rAttribute  检测第一个天命 是否是空的
    else if WearItemArr[ARR_12_Special].rName = '' then
    begin
      Tm_Special := ARR_12_Special;
      FillChar(aOldItemData, SizeOf(TItemData), 0);
    end
    //没有发现一致的rAttribute  检测第二个天命 是否是空的
    else if WearItemArr[ARR_13_Special].rName = '' then
    begin
      Tm_Special := ARR_13_Special;
      FillChar(aOldItemData, SizeOf(TItemData), 0);
    end;
    //返回被替换天命
    Move(WearItemArr[Tm_Special], aOldItemData, SizeOf(TItemData));
    FillChar(WearItemArr[Tm_Special], SizeOf(TItemData), 0);
    aOldItemData.rCount := 1;
    //穿戴天命
    Move(aItemData, WearItemArr[Tm_Special], SizeOf(TItemData));
    WearItemArr[Tm_Special].rCount := 1;
    //发送天命消息
    FSendClass.SendWearItem(Tm_Special, witWear, aItemData);
  end
  //其他装备穿戴
  else
  begin
    //取下旧装备逻辑
    //判断物品是否为空
    if WearItemArr[aItemData.rWearArr].rName = '' then
    begin
      FillChar(aOldItemData, SizeOf(TItemData), 0);
    end
    else
    begin
      //取下触发脚本
      if WearItemArr[aItemData.rWearArr].rSpecialKind = WEAR_SPECIAL_KIND_Scripter then
      begin
      //ItemClass.CallScriptFunction(WearItemArr[aItemData.rWearArr].rScripter, 'OnWearItemOff', [integer(FBasicObject), aItemData.rWearArr]);
        ItemClass.CallLuaScriptFunction(WearItemArr[aItemData.rWearArr].rScripter, 'OnWearItemOff', [integer(FBasicObject), aItemData.rWearArr]);
      end;
      //返回被替换装备
      Move(WearItemArr[aItemData.rWearArr], aOldItemData, SizeOf(TItemData));
      FillChar(WearItemArr[aItemDAta.rWearArr], SizeOf(TItemData), 0);
      aOldItemData.rCount := 1;
    end;
    //穿戴装备
    Move(aItemData, WearItemArr[aItemData.rWearArr], SizeOf(TItemData));
    WearItemArr[aItemData.rWearArr].rCount := 1;
    //穿戴脚本触发
    if WearItemArr[aItemData.rWearArr].rSpecialKind = WEAR_SPECIAL_KIND_Scripter then
    begin
    //ItemClass.CallScriptFunction(aItemData.rScripter, 'OnWearItemOn', [integer(FBasicObject), aItemData.rWearArr]);
      ItemClass.CallLuaScriptFunction(aItemData.rScripter, 'OnWearItemOn', [integer(FBasicObject), aItemData.rWearArr]);
    end;
    //发送装备消息
    begin
      FSendClass.SendWearItem(aItemData.rWearArr, witWear, aItemData);
    end;
  end;

  ReQuestPlaySoundNumber := aItemData.rSoundEvent.rWavNumber;

  SetLifeData;

  FBasicObject.CallLuaScriptFunction('OnChangeWearItem', [integer(TUserObject(FBasicObject))]); //装备切换触发
  Result := TRUE;

end;

function TWearItemClass.ChangeItemFD(var aItemData: TItemData; var aOldItemData: TItemData): Boolean;
var
  ItemData: TItemData;
begin
  Result := FALSE;

  if boLocked = true then
    exit; //锁
  if aItemData.rName = '' then
    exit; //物品是否有效
  if (aItemData.rKind <> ITEM_KIND_WEARITEM_FD) then
    exit;
  if aItemData.rWearArr = ARR_WEAPON then
    EXIT; //是武器 结束
  if aItemData.rboBlueprint then
    exit;

  case aItemData.rSex of
    1:
      if not WearFeature.rboMan then
        exit;
    2:
      if WearFeature.rboMan then
        exit;
  end;
  if WearFashionableItemArr[aItemData.rWearArr].rName = '' then
  begin
    FillChar(aOldItemData, SizeOf(TItemData), 0);
  end
  else
  begin
    Move(WearFashionableItemArr[aItemData.rWearArr], aOldItemData, SizeOf(TItemData));
    FillChar(WearFashionableItemArr[aItemDAta.rWearArr], SizeOf(TItemData), 0);
    aOldItemData.rCount := 1;
  end;

  Move(aItemData, WearFashionableItemArr[aItemData.rWearArr], SizeOf(TItemData));
  WearFashionableItemArr[aItemData.rWearArr].rCount := 1;

  { if (aItemData.rWearArr = 6) and (aItemData.rKind = ITEM_KIND_WEARITEM2) then
   begin
       FillChar(ItemData, SizeOf(TItemData), 0);
       FSendClass.SendWearItem(2, ItemData);
       FSendClass.SendWearItem(4, ItemData);
       FSendClass.SendWearItem(aItemData.rWearArr, aItemData);
   end
   else if (aItemData.rWearArr = 2) or (aItemData.rWearArr = 4) then
   begin
       if WearItemArr[6].rKind <> ITEM_KIND_WEARITEM2 then
       begin
           FSendClass.SendWearItem(aItemData.rWearArr, aItemData);
       end;
   end else
   }
  begin
    FSendClass.SendWearItem(aItemData.rWearArr, witWearFD, aItemData);
  end;

  ReQuestPlaySoundNumber := aItemData.rSoundEvent.rWavNumber;

  SetLifeData;

  Result := TRUE;
end;
//没使用

procedure TWearItemClass.onChangeItem(akey: integer);
var
  ItemData: TItemData;
begin

end;

function TWearItemClass.DeleteKeyItem(akey: integer): boolean;
begin
  result := false;
  if boLocked = true then
    exit;
  if (akey < 0) or (akey > high(WearItemArr)) then
    exit;
  {
      if (aKey = 6) and (WearItemArr[aKey].rKind = ITEM_KIND_WEARITEM2) then
  begin
      FSendClass.SendWearItem(2, WearItemArr[2]);
      FSendClass.SendWearItem(4, WearItemArr[4]);
  end;
  }
  if WearItemArr[akey].rSpecialKind = WEAR_SPECIAL_KIND_Scripter then
  begin
    //ItemClass.CallScriptFunction(WearItemArr[akey].rScripter, 'OnWearItemOff', [integer(FBasicObject), akey]);
    ItemClass.CallLuaScriptFunction(WearItemArr[akey].rScripter, 'OnWearItemOff', [integer(FBasicObject), akey]);

  end;

  FillChar(WearItemArr[akey], sizeof(TItemData), 0);
  FSendClass.SendWearItem(akey, witWear, WearItemArr[akey]);

  SetLifeData;

  FBasicObject.CallLuaScriptFunction('OnChangeWearItem', [integer(TUserObject(FBasicObject))]); //装备切换触发
  result := true;
end;

procedure TWearItemClass.DeleteKeyItemFD(akey: integer);
begin
  if boLocked = true then
    exit;
  if (akey < 0) or (akey > high(WearFashionableItemArr)) then
    exit;
  {
      if (aKey = 6) and (WearItemArr[aKey].rKind = ITEM_KIND_WEARITEM2) then
  begin
      FSendClass.SendWearItem(2, WearItemArr[2]);
      FSendClass.SendWearItem(4, WearItemArr[4]);
  end;
  }
  FillChar(WearFashionableItemArr[akey], sizeof(TItemData), 0);
  FSendClass.SendWearItem(akey, witWearFD, WearFashionableItemArr[akey]);
  SetLifeData;
end;

procedure TWearItemClass.SetFeatureState(aFeatureState: TFeatureState);
begin
  WearFeature.rfeaturestate := aFeatureState;
end;

procedure TWearItemClass.SetHiddenState(aHiddenState: THiddenState);
begin
  FBasicObject.BasicData.Feature.rHideState := aHiddenState;
  WearFeature.rHideState := aHiddenState;
end;

procedure TWearItemClass.SetActionState(aActionState: TActionState);
begin
  FBasicObject.BasicData.Feature.rActionState := aActionState;
  WearFeature.rActionState := aActionState;
end;

function TWearItemClass.GetHiddenState: THiddenState;
begin
  Result := WearFeature.rHideState;
end;

function TWearItemClass.GetActionState: TActionState;
begin
  Result := WearFeature.rActionState;
end;

procedure TWearItemClass.QClear; //清除 任务装备
var
  i: integer;
begin
  for i := 0 to high(WearItemArr) do
  begin
    if WearItemArr[i].rName = '' then
      Continue;
    if WearItemArr[i].rSpecialKind = 6 then
      FillChar(WearItemArr[i], sizeof(TItemData), 0);
    FSendClass.SendWearItem(i, witWear, WearItemArr[i]);
  end;

  for i := 0 to high(WearFashionableItemArr) do
  begin
    if WearFashionableItemArr[i].rName = '' then
      Continue;
    if WearFashionableItemArr[i].rSpecialKind = 6 then
      FillChar(WearFashionableItemArr[i], sizeof(TItemData), 0);
    FSendClass.SendWearItem(i, witWearFD, WearFashionableItemArr[i]);
  end;
  SetLifeData;
end;

//身上物品染色
//asour = 背包物品位置
//adest = 身上物品位置

function TWearItemClass.colorItem(aItemData: PTItemData; adest: integer): Boolean;
var
  ItemData: TItemdata;
  HaveItemClass: THaveItemClass;
begin
  Result := FALSE;
  //    if boLocked = true then exit;
  //判断身上物品位置范围
  if (adest < ARR_BODY) or (adest > ARR_MAX - 1) then
    exit;
  //检测背包物品名称
  //ShowMessage(aItemData.rName);
  if aItemData.rName = '' then
    exit;
  //检测身上物品名称
  if WearItemArr[adest].rName = '' then
    exit;
  //检测身上物品是否可以染色
  if (WearItemArr[adest].rboColoring) = false then
    exit;
  if (WearItemArr[adest].rKind = ITEM_KIND_COLORDRUG) then
    exit;
  if (WearItemArr[adest].rKind = ITEM_KIND_CHANGER) then
    exit;
  //检测背包物品是否可以染色
  if (aItemData.rKind <> ITEM_KIND_COLORDRUG) then
    exit;
  if (aItemData.rCount < 1) then
    exit;
  if INI_WHITEDRUG <> (aItemData.rName) then
  begin //身上物品脱色
    WearItemArr[adest].rColor := aItemData.rColor;
  end
  else
  begin //身上物品染色
    WearItemArr[adest].rColor := WearItemArr[adest].rColor + aItemData.rColor;
  end;
  FSendClass.SendUPDATEItem_rcolor(suitWear, adest, WearItemArr[adest]);
  Result := TRUE;
end;
///////////////////////////////////
//         THaveMagicClass
///////////////////////////////////

constructor THaveMagicClass.Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
begin
  FMagicExpMulCount := 0;
  Procession_Exp_Sum := 0;
  JobKind := 0;
  jobLevelx := 0;
  JobSkillExp := 0;
  JobSendTick := 0;
  JobpTJobGradeData := nil;

  FBasicObject := aBasicObject;
  boAddExp := true;
  ReQuestPlaySoundNumber := 0;
  FSendClass := aSendClass;
  FAttribClass := aAttribclass;
end;

destructor THaveMagicClass.Destroy;
begin
  inherited destroy;
end;

procedure THaveMagicClass.setAttackMagic(value: PTMagicData);
//2009 4 11 增加      攻击武功发生改变
var
  aSubData: tSubData;
begin
  {0=拳 1=剑 2=刀 3=槌 4=枪 5=弓 6=投 7=步法 8=心法 9=护体 10=辅助武功 11=百鬼夜行术 12=非玩家魔法 13=玩家魔法
      213=掌法 314=招式(0=1层拳 100=2层拳 300=3层拳)
      拳 是0  111---117
      剑 是1  121---127
      刀 是2  131---137
      斧 是3  141---147
      枪 是4  151---147}
  if FpCurAttackMagic = value then
    exit;

  FpCurAttackMagic := value;

end;

procedure THaveMagicClass.SetLifeData;

  procedure AddLifeData(p: PTMagicData);
  begin
    if p = nil then
      exit;
    {        HaveMagicLifeData.DamageBody := HaveMagicLifeData.DamageBody + p^.rLifeData.damageBody + p^.rLifeData.damageBody * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
            HaveMagicLifeData.DamageHead := HaveMagicLifeData.DamageHead + p^.rLifeData.damageHead + p^.rLifeData.damageHead * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
            HaveMagicLifeData.DamageArm := HaveMagicLifeData.DamageArm + p^.rLifeData.damageArm + p^.rLifeData.damageArm * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
            HaveMagicLifeData.DamageLeg := HaveMagicLifeData.DamageLeg + p^.rLifeData.damageLeg + p^.rLifeData.damageLeg * p^.rcSkillLevel div INI_SKILL_DIV_DAMAGE;
            HaveMagicLifeData.AttackSpeed := HaveMagicLifeData.AttackSpeed + p^.rLifeData.AttackSpeed - p^.rLifeData.AttackSpeed * p^.rcSkillLevel div INI_SKILL_DIV_ATTACKSPEED;
            HaveMagicLifeData.avoid := HaveMagicLifeData.avoid + p^.rLifeData.avoid;
            HaveMagicLifeData.recovery := HaveMagicLifeData.recovery + p^.rLifeData.recovery;
            HaveMagicLifeData.armorBody := HaveMagicLifeData.armorBody + p^.rLifeData.armorBody + p^.rLifeData.armorBody * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
            HaveMagicLifeData.armorHead := HaveMagicLifeData.armorHead + p^.rLifeData.armorHead + p^.rLifeData.armorHead * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
            HaveMagicLifeData.armorArm := HaveMagicLifeData.armorArm + p^.rLifeData.armorArm + p^.rLifeData.armorArm * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
            HaveMagicLifeData.armorLeg := HaveMagicLifeData.armorLeg + p^.rLifeData.armorLeg + p^.rLifeData.armorLeg * p^.rcSkillLevel div INI_SKILL_DIV_ARMOR;
            }
  end;

  procedure AddLevelCountLifeData();
  var
    i, rcountAttack, rcountProtect, rcountEct, rcountBREATHNG, rcountWalking: integer;
    tempLifeData: tLifeData;
  begin
    ///////////////////////////////////////////////
    //              满级 武功 累加 属性
    rcountAttack := 0;
    rcountProtect := 0;
    rcountEct := 0;
    rcountBREATHNG := 0;
    rcountWalking := 0;
    for i := 0 to high(HaveMagicArr) do
    begin
      if HaveMagicArr[i].rcSkillLevel >= 9999 then
      begin
        case HaveMagicArr[i].rMagicType of
          MAGICTYPE_WRESTLING, // 拳
            MAGICTYPE_FENCING, //剑
            MAGICTYPE_SWORDSHIP, //刀
            MAGICTYPE_HAMMERING, //槌
            MAGICTYPE_SPEARING, //枪
            MAGICTYPE_BOWING, //弓
            MAGICTYPE_THROWING //投
            :
            inc(rcountAttack); //攻击
          MAGICTYPE_RUNNING:
            inc(rcountWalking); //步法
          MAGICTYPE_BREATHNG:
            inc(rcountBREATHNG); //心法
          MAGICTYPE_PROTECTING:
            inc(rcountProtect); //护体
          MAGICTYPE_ECT:
            inc(rcountEct); // 辅助武功
        end;
      end;
    end;
    for i := 0 to high(DefaultMagic) do
    begin
      if DefaultMagic[i].rcSkillLevel >= 9999 then
        case DefaultMagic[i].rMagicType of
          MAGICTYPE_WRESTLING, // 拳
            MAGICTYPE_FENCING, //剑
            MAGICTYPE_SWORDSHIP, //刀
            MAGICTYPE_HAMMERING, //槌
            MAGICTYPE_SPEARING, //枪
            MAGICTYPE_BOWING, //弓
            MAGICTYPE_THROWING //投
            :
            inc(rcountAttack); //攻击
          MAGICTYPE_RUNNING:
            inc(rcountWalking); //步法
          MAGICTYPE_BREATHNG:
            inc(rcountBREATHNG); //心法
          MAGICTYPE_PROTECTING:
            inc(rcountProtect); //护体
          MAGICTYPE_ECT:
            inc(rcountEct); // 辅助武功
        end;
    end;
    if rcountAttack > 0 then //满武功加的属性
    begin
      tempLifeData := ItemLifeDataClass.LifeDataMagicAttack;
      GatMultiplyLifeData(tempLifeData, rcountAttack);
      GatherLifeData(HaveMagicLifeData, tempLifeData);
    end;
    if rcountProtect > 0 then
    begin
      tempLifeData := ItemLifeDataClass.LifeDataMagicProtect;
      GatMultiplyLifeData(tempLifeData, rcountProtect);
      GatherLifeData(HaveMagicLifeData, tempLifeData);
    end;
    if rcountEct > 0 then
    begin
      tempLifeData := ItemLifeDataClass.LifeDataMagicEct;
      GatMultiplyLifeData(tempLifeData, rcountEct);
      GatherLifeData(HaveMagicLifeData, tempLifeData);
    end;
    if rcountBREATHNG > 0 then
    begin
      tempLifeData := ItemLifeDataClass.LifeDataMagicBREATHNG;
      GatMultiplyLifeData(tempLifeData, rcountBREATHNG);
      GatherLifeData(HaveMagicLifeData, tempLifeData);
    end;
    if rcountWalking > 0 then
    begin
      tempLifeData := ItemLifeDataClass.LifeDataMagicWalking;
      GatMultiplyLifeData(tempLifeData, rcountWalking);
      GatherLifeData(HaveMagicLifeData, tempLifeData);
    end;

    ////////////////////////////////////////////////////////////////////////////
  end;

var
  str: string;
  aSkillLevel: word;
begin
  AddExpCount := 0;
  FillChar(HaveMagicLifeData, sizeof(TLifeData), 0);

  //frmMain.WriteLogInfo(str);

  // AddLifeData(pCurAttackMagic);

   {if pCurAttackMagic <> nil then
   begin
       HaveMagicLifeData.damageBody := HaveMagicLifeData.damageBody + HaveMagicLifeData.DamageBody * MagicClass.GetSkillDamageBody(pCurAttackMagic^.rcSkillLevel) div 100;
       HaveMagicLifeData.damageHead := HaveMagicLifeData.damageHead;
       HaveMagicLifeData.damageArm := HaveMagicLifeData.damageArm;
       HaveMagicLifeData.damageLeg := HaveMagicLifeData.damageLeg;
   end;
   }

   // AddLifeData(pCurBreathngMagic);
  // AddLifeData(pCurRunningMagic);
 //  AddLifeData(pCurProtectingMagic);
  { if pCurProtectingMagic <> nil then
   begin
       HaveMagicLifeData.ArmorBody := HaveMagicLifeData.ArmorBody + HaveMagicLifeData.ArmorBody * MagicClass.GetSkillArmorBody(pCurProtectingMagic^.rcSkillLevel) div 100;
   end;
   }
  // AddLifeData(pCurEctMagic);

  if pCurAttackMagic <> nil then
    GatherLifeData(HaveMagicLifeData, pCurAttackMagic.rcLifedata);
  if pCurBreathngMagic <> nil then
    GatherLifeData(HaveMagicLifeData, pCurBreathngMagic.rcLifedata);
  if pCurRunningMagic <> nil then
    GatherLifeData(HaveMagicLifeData, pCurRunningMagic.rcLifedata);
  if pCurProtectingMagic <> nil then
    GatherLifeData(HaveMagicLifeData, pCurProtectingMagic.rcLifedata);
  if pCurEctMagic <> nil then
    GatherLifeData(HaveMagicLifeData, pCurEctMagic.rcLifedata);
  //   if pCurAttackMagic <> nil then                               // 寇傍捞 鼻过颇鲍俊 康氢
  //   if pCurattackMagic.rMagicType = MAGICTYPE_WRESTLING then
  //      HaveMagicLifeData.damage := HaveMagicLifeData.Damage + FAttribClass.CurOutPower div 100;
  str := '';
  aSkillLevel := 100;
  if pCurAttackMagic <> nil then
  begin
    if str = '' then
      aSkillLevel := pCurAttackMagic.rcSkillLevel;
    str := str + (pCurAttackMagic^.rName) + ',';
  end;
  if pCurBreathngMagic <> nil then
  begin
    if str = '' then
      aSkillLevel := pCurBreathngMagic.rcSkillLevel;
    str := str + (pCurBreathngMagic^.rName) + ',';
  end;
  if pCurRunningMagic <> nil then
  begin
    if str = '' then
      aSkillLevel := pCurRunningMagic.rcSkillLevel;
    str := str + (pCurRunningMagic^.rName) + ',';
  end;
  if pCurProtectingMagic <> nil then
  begin
    if str = '' then
      aSkillLevel := pCurProtectingMagic.rcSkillLevel;
    str := str + (pCurProtectingMagic^.rName) + ',';
  end;
  if pCurEctMagic <> nil then
  begin
    if str = '' then
      aSkillLevel := pCurEctMagic.rcSkillLevel;
    str := str + (pCurEctMagic^.rName) + ',';
  end;

  FSendClass.SendUsedMagicString(str, aSkillLevel);
  //AddLevelCountLifeData; //附加 满级武功 属性
  TUserObject(FBasicObject).SetLifeData;
end;

procedure THaveMagicClass.sendMagicBasicIni();
var
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_MAGIC);
  WordComData_ADDbyte(ComData, byte(smt_ini));
  WordComData_ADDStringPro(ComData, MagicClass.Damagestr);
  WordComData_ADDStringPro(ComData, MagicClass.Armorstr);
  WordComData_ADDdword(ComData, INI_SKILL_DIV_DAMAGE);
  WordComData_ADDdword(ComData, INI_SKILL_DIV_ARMOR);
  WordComData_ADDdword(ComData, INI_SKILL_DIV_ATTACKSPEED);
  WordComData_ADDdword(ComData, INI_SKILL_DIV_EVENT);

  WordComData_ADDdword(ComData, INI_2SKILL_DIV_DAMAGE);
  WordComData_ADDdword(ComData, INI_2SKILL_DIV_ARMOR);
  WordComData_ADDdword(ComData, INI_2SKILL_DIV_ATTACKSPEED);
  WordComData_ADDdword(ComData, INI_2SKILL_DIV_EVENT);
  FSendClass.SendData(ComData);
end;

procedure THaveMagicClass.DefaultMagic2();
var
  n: integer;

  procedure _add(i, j: integer; aname: string);
  begin

    if DefaultMagic[j].rcSkillLevel >= 9999 then
      if DefaultMagic[i].rname = '' then
      begin
        aname := aname + ':0';
        MagicClass.GetHaveMagicData(aname, DefaultMagic[i]);
        DefaultMagic[i].rID := 70000 + i;
        MagicClass.Calculate_cLifeData(@DefaultMagic[i]);
        if DefaultMagic[i].rname <> '' then
          FSendClass.SendHaveMagic(smt_DefaultMagic, i, DefaultMagic[i]);
      end;

  end;

begin
  //2，元气，无为
    //  n := PowerLevelClass.getMax(FAttribClass.AttribData.Energy);
  if fAttribClass.PowerLevelMax < 2 then
    exit;
  //3，浩燃60。
  if FAttribClass.AttribData.cvirtue < 6000 then
    exit;
  _add(DEFAULT2_WRESTLING, DEFAULT_WRESTLING, INI_DEF_WRESTLING2);
  _add(DEFAULT2_FENCING, DEFAULT_FENCING, INI_DEF_FENCING2);
  _add(DEFAULT2_SWORDSHIP, DEFAULT_SWORDSHIP, INI_DEF_SWORDSHIP2);
  _add(DEFAULT2_HAMMERING, DEFAULT_HAMMERING, INI_DEF_HAMMERING2);
  _add(DEFAULT2_SPEARING, DEFAULT_SPEARING, INI_DEF_SPEARING2);
  _add(DEFAULT2_BOWING, DEFAULT_BOWING, INI_DEF_BOWING2);
  _add(DEFAULT2_THROWING, DEFAULT_THROWING, INI_DEF_THROWING2);
  _add(DEFAULT2_RUNNING, DEFAULT_RUNNING, INI_DEF_RUNNING2);
  _add(DEFAULT2_BREATHNG, DEFAULT_BREATHNG, INI_DEF_BREATHNG2);
  _add(DEFAULT2_PROTECTING, DEFAULT_PROTECTING, INI_DEF_PROTECTING2);

end;

procedure THaveMagicClass.LoadFromSdb(aCharData: PTDBRecord);
var
  i, j: integer;
  str: string;
begin
  //读取双倍经验倍数
  MagicExpMulCount := aCharData^.MagicExpMulCount;
  //下发  武功 基本 配置
  sendMagicBasicIni;
  JobKind := aCharData^.JobKind;
  JobSkillExp := 0;
  jobLevelx := 0;
  JobpTJobGradeData := nil;
  if achardata^.CurrentGrade > 0 then //以前的一个临时保存职业技能经验的参数转换
  begin
    JobAddExp(aCharData^.CurrentGrade, 1085138172);
    achardata^.TotalStatePoint := jobGetlevel;
    achardata^.CurrentGrade := 0;
  end;
  if achardata^.TotalStatePoint > 0 then
    JobSetLevel(achardata^.TotalStatePoint); //20130906修改
  ReQuestPlaySoundNumber := 0;
  //                              一层基本
  MagicClass.GetMagicData(INI_DEF_WRESTLING, DefaultMagic[default_wrestling], aCharData^.BasicMagicArr[0].rSkill);
  MagicClass.GetMagicData(INI_DEF_FENCING, DefaultMagic[default_fencing], aCharData^.BasicMagicArr[1].rSkill);
  MagicClass.GetMagicData(INI_DEF_SWORDSHIP, DefaultMagic[default_swordship], aCharData^.BasicMagicArr[2].rSkill);
  MagicClass.GetMagicData(INI_DEF_HAMMERING, DefaultMagic[default_hammering], aCharData^.BasicMagicArr[3].rSkill);
  MagicClass.GetMagicData(INI_DEF_SPEARING, DefaultMagic[default_spearing], aCharData^.BasicMagicArr[4].rSkill);
  MagicClass.GetMagicData(INI_DEF_BOWING, DefaultMagic[default_bowing], aCharData^.BasicMagicArr[5].rSkill);
  MagicClass.GetMagicData(INI_DEF_THROWING, DefaultMagic[default_throwing], aCharData^.BasicMagicArr[6].rSkill);
  MagicClass.GetMagicData(INI_DEF_RUNNING, DefaultMagic[default_running], aCharData^.BasicMagicArr[7].rSkill);
  MagicClass.GetMagicData(INI_DEF_BREATHNG, DefaultMagic[default_breathng], aCharData^.BasicMagicArr[8].rSkill);
  MagicClass.GetMagicData(INI_DEF_PROTECTING, DefaultMagic[default_Protecting], aCharData^.BasicMagicArr[9].rSkill);
  //2层

  //2，元气，无为
     // j := PowerLevelClass.getMax(FAttribClass.AttribData.Energy);
  if (fAttribClass.PowerLevelMax >= 2) and (FAttribClass.AttribData.cvirtue >= 6000) then
  begin
    //3，浩燃60。
    if DefaultMagic[default_wrestling].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_WRESTLING2, DefaultMagic[default2_wrestling], aCharData^.BasicRiseMagicArr[0].rSkill);
    if DefaultMagic[default_fencing].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_FENCING2, DefaultMagic[default2_fencing], aCharData^.BasicRiseMagicArr[1].rSkill);
    if DefaultMagic[default_swordship].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_SWORDSHIP2, DefaultMagic[default2_swordship], aCharData^.BasicRiseMagicArr[2].rSkill);
    if DefaultMagic[default_hammering].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_HAMMERING2, DefaultMagic[default2_hammering], aCharData^.BasicRiseMagicArr[3].rSkill);
    if DefaultMagic[default_spearing].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_SPEARING2, DefaultMagic[default2_spearing], aCharData^.BasicRiseMagicArr[4].rSkill);
    if DefaultMagic[default_bowing].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_BOWING2, DefaultMagic[default2_bowing], aCharData^.BasicRiseMagicArr[5].rSkill);
    if DefaultMagic[default_throwing].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_THROWING2, DefaultMagic[default2_throwing], aCharData^.BasicRiseMagicArr[6].rSkill);
    if DefaultMagic[default_running].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_RUNNING2, DefaultMagic[default2_running], aCharData^.BasicRiseMagicArr[7].rSkill);
    if DefaultMagic[default_breathng].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_BREATHNG2, DefaultMagic[default2_breathng], aCharData^.BasicRiseMagicArr[8].rSkill);
    if DefaultMagic[default_Protecting].rcSkillLevel >= 9999 then
      MagicClass.GetMagicData(INI_DEF_PROTECTING2, DefaultMagic[default2_Protecting], aCharData^.BasicRiseMagicArr[9].rSkill);
  end;

  for i := 0 to 20 - 1 do
  begin
    DefaultMagic[i].rID := 70000 + i;
    MagicClass.Calculate_cLifeData(@DefaultMagic[i]);
    if DefaultMagic[i].rname <> '' then
      FSendClass.SendHaveMagic(smt_DefaultMagic, i, DefaultMagic[i]);
  end;

  {  for i := 0 to 10 - 1 do
    begin
        j := i + 10;
        str := (aCharData^.BasicRiseMagicArr[i].rName) + ':' + IntToStr(aCharData^.BasicRiseMagicArr[i].rSkill);
        MagicClass.GetHaveMagicData(str, DefaultMagic[j]);
        DefaultMagic[j].rID := 70000 + j;
        MagicClass.Calculate_cLifeData(@DefaultMagic[j]);
        if DefaultMagic[j].rname <> '' then
            FSendClass.SendHaveMagic(smt_DefaultMagic, j, DefaultMagic[j]);
    end;
    }
    //浪人
   // DefaultMagic2;

    //                               一层武功
  for i := 0 to HAVEMAGICSIZE60 - 1 do
  begin

    str := (aCharData^.HaveMagicArr[i].rName) + ':' + IntToStr(aCharData^.HaveMagicArr[i].rSkill);
    MagicClass.GetHaveMagicData(str, HaveMagicArr[i]);
    HaveMagicArr[i].rID := 80000 + i;
    MagicClass.Calculate_cLifeData(@HaveMagicArr[i]);
    if HaveMagicArr[i].rname <> '' then
      FSendClass.SendHaveMagic(smt_HaveMagic, i, HaveMagicArr[i]);
  end;
  //                            二层武功
  for i := 0 to xHAVEMAGICSIZE - 1 do
  begin

    str := (aCharData^.HaveRiseMagicArr[i].rName) + ':' + IntToStr(aCharData^.HaveRiseMagicArr[i].rSkill);
    MagicClass.GetHaveMagicData(str, HaveRiseMagicArr[i]);
    HaveRiseMagicArr[i].rID := 81000 + i;
    MagicClass.Calculate_cLifeData(@HaveRiseMagicArr[i]);
    if HaveRiseMagicArr[i].rname <> '' then
      FSendClass.SendHaveMagic(smt_HaveRiseMagic, i, HaveRiseMagicArr[i]);
  end;
   //掌法  //20130620修改 暂时不开放 如果要开放可能需要重新设定USER.DB   ，否则人物初始化时候可能报错导致TGS退出
{$IFDEF Free}
  for i := 0 to xHAVEMAGICSIZE - 1 do
  begin

    str := (aCharData^.HaveMysteryMagicArr[i].rName) + ':' + IntToStr(aCharData^.HaveMysteryMagicArr[i].rSkill);
    MagicClass.GetHaveMagicData(str, HaveMysteryMagicArr[i]);
    HaveMysteryMagicArr[i].rID := 82000 + i;
    MagicClass.Calculate_cLifeData(@HaveMysteryMagicArr[i]);
    if HaveMysteryMagicArr[i].rname <> '' then
      FSendClass.SendHaveMagic(smt_HaveMysteryMagic, i, HaveMysteryMagicArr[i]);
  end;
{$ENDIF}
  WalkingCount := 0;
  FpCurAttackMagic := nil;
  FpCurBreathngMagic := nil;
  FpCurRunningMagic := nil;
  FpCurProtectingMagic := nil;
  FpCurEctMagic := nil;

  SetLifeData;

end;

procedure THaveMagicClass.SaveToSdb(aCharData: PTDBRecord);
var
  i: integer;
  str, rdstr: string;
begin
  {
  UserData.SetFieldValueInteger (aName, 'Wrestling', DefaultMagic[FindBasicMagic(default_wrestling)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Fencing', DefaultMagic[FindBasicMagic(default_fencing)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Swordship', DefaultMagic[FindBasicMagic(default_swordship)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Hammering', DefaultMagic[FindBasicMagic(default_hammering)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Spearing', DefaultMagic[FindBasicMagic(default_spearing)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Bowing', DefaultMagic[FindBasicMagic(default_bowing)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Throwing', DefaultMagic[FindBasicMagic(default_throwing)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Breathng', DefaultMagic[FindBasicMagic(default_breathng)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Running', DefaultMagic[FindBasicMagic(default_running)].rSkillExp);
  UserData.SetFieldValueInteger (aName, 'Protecting', DefaultMagic[FindBasicMagic(default_Protecting)].rSkillExp);
  }
  aCharData^.JobKind := jobkind;
  // aCharData^.JobKindLevelExp := JobSkillExp;
  aCharData^.TotalStatePoint := jobLevelx; //JobSkillExp;   //20130908修改
  aCharData^.BasicMagicArr[0].rSkill := DefaultMagic[default_wrestling].rSkillExp;
  aCharData^.BasicMagicArr[1].rSkill := DefaultMagic[default_fencing].rSkillExp;
  aCharData^.BasicMagicArr[2].rSkill := DefaultMagic[default_swordship].rSkillExp;
  aCharData^.BasicMagicArr[3].rSkill := DefaultMagic[default_hammering].rSkillExp;
  aCharData^.BasicMagicArr[4].rSkill := DefaultMagic[default_spearing].rSkillExp;
  aCharData^.BasicMagicArr[5].rSkill := DefaultMagic[default_bowing].rSkillExp;
  aCharData^.BasicMagicArr[6].rSkill := DefaultMagic[default_throwing].rSkillExp;
  aCharData^.BasicMagicArr[7].rSkill := DefaultMagic[default_running].rSkillExp;
  aCharData^.BasicMagicArr[8].rSkill := DefaultMagic[default_breathng].rSkillExp;
  aCharData^.BasicMagicArr[9].rSkill := DefaultMagic[default_Protecting].rSkillExp;

  aCharData^.BasicRiseMagicArr[0].rSkill := DefaultMagic[default2_wrestling].rSkillExp;
  aCharData^.BasicRiseMagicArr[1].rSkill := DefaultMagic[default2_fencing].rSkillExp;
  aCharData^.BasicRiseMagicArr[2].rSkill := DefaultMagic[default2_swordship].rSkillExp;
  aCharData^.BasicRiseMagicArr[3].rSkill := DefaultMagic[default2_hammering].rSkillExp;
  aCharData^.BasicRiseMagicArr[4].rSkill := DefaultMagic[default2_spearing].rSkillExp;
  aCharData^.BasicRiseMagicArr[5].rSkill := DefaultMagic[default2_bowing].rSkillExp;
  aCharData^.BasicRiseMagicArr[6].rSkill := DefaultMagic[default2_throwing].rSkillExp;
  aCharData^.BasicRiseMagicArr[7].rSkill := DefaultMagic[default2_running].rSkillExp;
  aCharData^.BasicRiseMagicArr[8].rSkill := DefaultMagic[default2_breathng].rSkillExp;
  aCharData^.BasicRiseMagicArr[9].rSkill := DefaultMagic[default2_Protecting].rSkillExp;

  for i := 0 to HAVEMAGICSIZE60 - 1 do //这里决定了快捷栏那拖放的武功
  begin
    aCharData^.HaveMagicArr[i].rName := HaveMagicArr[i].rname;
    aCharData^.HaveMagicArr[i].rSkill := HaveMagicArr[i].rSkillExp;
  end;

  for i := 0 to xHAVEMAGICSIZE - 1 do
  begin
    aCharData^.HaveRiseMagicArr[i].rName := HaveRiseMagicArr[i].rname;
    aCharData^.HaveRiseMagicArr[i].rSkill := HaveRiseMagicArr[i].rSkillExp;
  end;

  for i := 0 to xHAVEMAGICSIZE - 1 do
  begin
    aCharData^.HaveMysteryMagicArr[i].rName := HaveMysteryMagicArr[i].rname;
    aCharData^.HaveMysteryMagicArr[i].rSkill := HaveMysteryMagicArr[i].rSkillExp;
  end;
end;

procedure THaveMagicClass.SendMagicAddExp(pMagicData: PTMagicData);
begin
  if pMagicData = nil then
    exit;
  FSendClass.SendMagicAddExp(pMagicData^);
end;

procedure THaveMagicClass.FindAndSendMagic(pMagicData: PTMagicData);
var
  i: integer;
begin
  for i := 0 to 10 - 1 do
  begin
    if pMagicData = @DefaultMagic[i] then
    begin
      FSendClass.SendHaveMagic(smt_DefaultMagic, i, DefaultMagic[i], EventString_Magic_Attrib);
      exit;
    end;
  end;

  for i := 0 to HAVEMAGICSIZE60 - 1 do
  begin
    if pMagicData = @HaveMagicArr[i] then
    begin
      FSendClass.SendHaveMagic(smt_HaveMagic, i, HaveMagicArr[i], EventString_Magic_Attrib);
      exit;
    end;
  end;
end;

function THaveMagicClass.ViewMagic(akey: integer; aMagicData: PTMagicData): Boolean;
begin
  Result := FALSE;
  if (akey < 0) or (akey > HAVEMAGICSIZE60 - 1) then
    exit;
  if HaveMagicArr[akey].rName = '' then
    exit;
  Move(HaveMagicArr[akey], aMagicData^, SizeOf(TMagicData));
  Result := TRUE;
end;

function THaveMagicClass.ViewBasicMagic(akey: integer; aMagicData: PTMagicData): Boolean;
begin
  Result := FALSE;
  if (akey < 0) or (akey > 20 - 1) then
    exit;
  if DefaultMagic[akey].rName = '' then
    exit;
  Move(DefaultMagic[akey], aMagicData^, SizeOf(TMagicData));
  Result := TRUE;
end;

function THaveMagicClass.Rise_ChangeMagic(asour, adest: integer): Boolean;
var
  MagicData: TMagicData;
begin
  Result := FALSE;
  if (asour < 0) or (asour > xHAVEMAGICSIZE - 1) then
    exit;
  if (adest < 0) or (adest > xHAVEMAGICSIZE - 1) then
    exit;

  if FpCurAttackMagic = @HaveRiseMagicArr[asour] then
    exit;
  if FpCurBreathngMagic = @HaveRiseMagicArr[asour] then
    exit;
  if FpCurRunningMagic = @HaveRiseMagicArr[asour] then
    exit;
  if FpCurProtectingMagic = @HaveRiseMagicArr[asour] then
    exit;
  if FpCurEctMagic = @HaveRiseMagicArr[asour] then
    exit;

  if FpCurAttackMagic = @HaveRiseMagicArr[adest] then
    exit;
  if FpCurBreathngMagic = @HaveRiseMagicArr[adest] then
    exit;
  if FpCurRunningMagic = @HaveRiseMagicArr[adest] then
    exit;
  if FpCurProtectingMagic = @HaveRiseMagicArr[adest] then
    exit;
  if FpCurEctMagic = @HaveRiseMagicArr[adest] then
    exit;

  MagicData := HaveRiseMagicArr[asour];
  HaveRiseMagicArr[asour] := HaveRiseMagicArr[adest];
  HaveRiseMagicArr[adest] := MagicData;

  FSendClass.SendHaveMagic(smt_HaveRiseMagic, asour, HaveRiseMagicArr[asour]);
  FSendClass.SendHaveMagic(smt_HaveRiseMagic, adest, HaveRiseMagicArr[adest]);
  Result := TRUE;
end;

function THaveMagicClass.Rise_GetMagicIndex(aMagicName: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to high(HaveRiseMagicArr) do
  begin
    if (HaveRiseMagicArr[i].rName) = aMagicName then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function THaveMagicClass.Rise_GetMagicSkillLevel(aMagicName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to high(HaveRiseMagicArr) do
  begin
    if (HaveRiseMagicArr[i].rName) = aMagicName then
    begin
      Result := HaveRiseMagicArr[i].rcSkillLevel;
      exit;
    end;
  end;
end;

function THaveMagicClass.Rise_MagicSpaceCount: integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to high(HaveRiseMagicArr) do
  begin
    if (HaveRiseMagicArr[i].rName) = '' then
    begin
      Result := Result + 1;
    end;
  end;

end;

function THaveMagicClass.Rise_PreSelectHaveMagic(akey, aper: integer; var RetStr: string): Boolean;
begin
  Result := false;
  RetStr := '';
  if (akey < 0) or (akey > high(HaveRiseMagicArr)) then
    exit;
  if HaveRiseMagicArr[akey].rName = '' then
  begin
    RetStr := '选择的武功不存在.';
    exit;
  end;

  case HaveRiseMagicArr[akey].rMagicType of
    MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING, MAGICTYPE_2SPEARING, MAGICTYPE_2BOWING, MAGICTYPE_2THROWING:
      begin
        if aper <= 10 then
        begin
          RetStr := '因头的活力不足，所以选择武功失败.';
          exit;
        end;
      end;

  end;
  Result := true;
end;

function THaveMagicClass.Rise_SelectHaveMagic(akey, aper: integer; var RetStr: string): integer;
var
  aSubData: tSubData;
begin
  RetStr := '';
  Result := SELECTMAGIC_RESULT_FALSE;
  if akey < 0 then
    exit;
  if akey > high(HaveRiseMagicArr) then
    exit;
  if HaveRiseMagicArr[akey].rName = '' then
    exit;

  case HaveRiseMagicArr[akey].rMagicType of
    MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING, MAGICTYPE_2SPEARING, MAGICTYPE_2BOWING, MAGICTYPE_2THROWING:
      begin
        if HaveItemType <> (HaveRiseMagicArr[akey].rMagicType mod 100) then
          exit;
        RetStr := '因头的活力不足，所以选择武功失败.';
        case aper of
          0..10:
            exit;
        else
          RetStr := '';
        end;
      end;

  end;

  Result := SELECTMAGIC_RESULT_NONE;
  case HaveRiseMagicArr[akey].rMagicType of
    //攻击类型
    MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING, MAGICTYPE_2SPEARING, MAGICTYPE_2BOWING, MAGICTYPE_2THROWING:
    //MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING, MAGICTYPE_2SPEARING:
      begin
        setAttackMagic(@HaveRiseMagicArr[akey]);
        //要求等级9999，才能挂辅助武功
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    //步法
    MAGICTYPE_2RUNNING:
      begin
        SetRunningMagic(@HaveRiseMagicArr[akey]);
        if FpCurRunningMagic <> nil then
          Result := SELECTMAGIC_RESULT_RUNNING
        else
          Result := SELECTMAGIC_RESULT_NORMAL;
      end;
    //心法
    MAGICTYPE_2BREATHNG:
      begin
        SetBreathngMagic(@HaveRiseMagicArr[akey]);
        if FpCurBreathngMagic <> nil then
          Result := SELECTMAGIC_RESULT_SITDOWN
        else
          Result := SELECTMAGIC_RESULT_NORMAL;
        //关护体
        if FpCurBreathngMagic <> nil then
          SetProtectingMagic(nil);
      end;
    //护体
    MAGICTYPE_2PROTECTING:
      begin
        SetProtectingMagic(@HaveRiseMagicArr[akey]);
        //关心法
        if FpCurProtectingMagic <> nil then
          SetBreathngMagic(nil);
      end;
    //辅助
          {  MAGICTYPE_ECT:
                begin
                    SetEctMagic(@HaveRiseMagicArr[akey]);
                end;}
  end;
  SetLifeData;
end;

function THaveMagicClass.Rise_ViewMagic(akey: integer; aMagicData: PTMagicData): Boolean;
begin
  Result := FALSE;
  if (akey < 0) or (akey > high(HaveRiseMagicArr)) then
    exit;
  if HaveRiseMagicArr[akey].rName = '' then
    exit;
  Move(HaveRiseMagicArr[akey], aMagicData^, SizeOf(TMagicData));
  Result := TRUE;
end;

{function THaveMagicClass.GETSendMagic(akey: integer): Boolean;

begin
    Result := FALSE;
    if (akey < 0) or (akey > 10 - 1) then exit;
    if HaveMagicArr[akey].rName = '' then exit;
    //

    FSendClass.Senditempro_MagicBasic(HaveMagicArr[akey]);
    Result := TRUE;
end;
 }
 {
function THaveMagicClass.GETSendBasicMagic(akey: integer): Boolean;

begin
    Result := FALSE;
    if (akey < 0) or (akey > 10 - 1) then exit;
    if DefaultMagic[akey].rName = '' then exit;
    //

    FSendClass.Senditempro_MagicBasic(DefaultMagic[akey]);
    Result := TRUE;
end;
  }
//脚本添加武功

function THaveMagicClass.AddMagicAndLevel(aMagicData: PTMagicData): Boolean;
var
  i, j: integer;
  boFlag: boolean;
  //min, mini : integer;
begin
  Result := FALSE;
  if aMagicData = nil then
    exit;
  if aMagicData.rname = '' then
    exit;
  case aMagicData.rMagicType of
    0..99:
      begin
      //1层
        //是否已经学过
        for i := 0 to HAVEMAGICSIZE60 - 1 do
          if (HaveMagicArr[i].rName = aMagicData^.rName) then
            exit;
        //增加到空位置上
        for i := 0 to HAVEMAGICSIZE60 - 1 do
        begin
          if HaveMagicArr[i].rName = '' then
          begin
            aMagicData^.rID := HaveMagicArr[i].rID;
            HaveMagicArr[i] := aMagicData^;
            MagicClass.Calculate_cLifeData(@HaveMagicArr[i]); //学习后直接计算属性
            FSendClass.SendHaveMagic(smt_HaveMagic, i, HaveMagicArr[i]);
            Result := TRUE;
            exit;
          end;
        end;
      end;
    100..199:
      begin
        //是否已经学过
        for i := 0 to xHAVEMAGICSIZE - 1 do
          if (HaveRiseMagicArr[i].rName = aMagicData^.rName) then
            exit;
        //增加到空位置上
        for i := 0 to xHAVEMAGICSIZE - 1 do
        begin
          if HaveRiseMagicArr[i].rName = '' then
          begin
            aMagicData^.rID := HaveRiseMagicArr[i].rID;
            HaveRiseMagicArr[i] := aMagicData^;
            MagicClass.Calculate_cLifeData(@HaveRiseMagicArr[i]); //学习后直接计算属性
            FSendClass.SendHaveMagic(smt_HaveRiseMagic, i, HaveRiseMagicArr[i]);
            Result := TRUE;
            exit;
          end;
        end;
      end;
    200..299:
      begin
         //是否已经学过
        for i := 0 to xHAVEMAGICSIZE - 1 do
          if (HaveMysteryMagicArr[i].rName = aMagicData^.rName) then
            exit;
           //增加到空位置上
        for i := 0 to xHAVEMAGICSIZE - 1 do
        begin
          if HaveMysteryMagicArr[i].rName = '' then
          begin
            aMagicData^.rID := HaveMysteryMagicArr[i].rID;
            HaveMysteryMagicArr[i] := aMagicData^;
            MagicClass.Calculate_cLifeData(@HaveMysteryMagicArr[i]); //学习后直接计算属性
            FSendClass.SendHaveMagic(smt_HaveMysteryMagic, i, HaveMysteryMagicArr[i]);
            Result := TRUE;
            exit;
          end;
        end;
      end;
    300..399:
      begin

      end;
  end;
end;

function THaveMagicClass.AddMagic(aMagicData: PTMagicData): Boolean;
//学书 获得技能
var
  i, j: integer;
  boFlag: boolean;
  //min, mini : integer;
begin
  Result := FALSE;
  if aMagicData = nil then
    exit;
  if aMagicData.rname = '' then
    exit;
  case aMagicData.rMagicType of
    0..99:
      //1层
      begin
        if (aMagicData^.rName) = '风灵旋' then
        begin
          boFlag := false;
          //基本，刀，枪，剑，斧，拳，至少满1个武功。
          for i := 0 to 10 - 1 do
          begin
            case DefaultMagic[i].rMagictype of
              MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING, MAGICTYPE_SPEARING:
                begin
                  if DefaultMagic[i].rcSkillLevel >= 9999 then
                  begin
                    boFlag := true;
                    break;
                  end;
                end;
            end;
          end;
          if boFlag = false then
          begin
            //1层。刀，枪，剑，斧，拳，至少满1个武功。
            for i := 0 to HAVEMAGICSIZE60 - 1 do
            begin
              case HaveMagicArr[i].rMagictype of
                MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING, MAGICTYPE_SPEARING:
                  begin
                    if HaveMagicArr[i].rcSkillLevel >= 9999 then
                    begin
                      boFlag := true;
                      break;
                    end;
                  end;
              end;
            end;
          end;
          if boFlag = false then
          begin
            FSendClass.SendChatMessage('至少要武功满一个武功才可以学习风灵旋.', SAY_COLOR_SYSTEM);
            exit;
          end;
        end;

        if (aMagicData^.rName) = '灵动八方' then
        begin
          //要求风灵旋必须满级
          boFlag := false;
          for i := 0 to HAVEMAGICSIZE60 - 1 do
          begin
            if (HaveMagicArr[i].rName) = '风灵旋' then
            begin
              if HaveMagicArr[i].rcSkillLevel >= 9999 then
              begin
                boFlag := true;
                break;
              end;
            end;
          end;
          if boFlag = false then
          begin
            FSendClass.SendChatMessage('必须修炼满风灵旋后才可以学习灵动八方.',
              SAY_COLOR_SYSTEM);
            exit;
          end;
        end;
        //确保 门派武功只有1个。
        if aMagicData^.rGuildMagictype <> 0 then
        begin
          for i := 0 to HAVEMAGICSIZE60 - 1 do
            if HaveMagicArr[i].rGuildMagictype <> 0 then
            begin
              exit;
            end;
        end;

        //是否已经学过
        for i := 0 to HAVEMAGICSIZE60 - 1 do
          if (HaveMagicArr[i].rName = aMagicData^.rName) then
          begin
            FSendClass.SendChatMessage('武功不能重复修炼.', SAY_COLOR_SYSTEM);
            exit;
          end;
        //增加到空位置上
        for i := 0 to HAVEMAGICSIZE60 - 1 do
        begin
          if HaveMagicArr[i].rName = '' then
          begin
            aMagicData^.rID := HaveMagicArr[i].rID;
            HaveMagicArr[i] := aMagicData^;
            MagicClass.Calculate_cLifeData(@HaveMagicArr[i]); //学习后直接计算属性
            FSendClass.SendHaveMagic(smt_HaveMagic, i, HaveMagicArr[i]);
            Result := TRUE;
            exit;
          end;
        end;

      end;
    100..199:
      begin
        //1,同类武功 必须满6个，和1个无名。 //20091110修改 ，元气 2境界，1层满1个对应2层就能学
        boFlag := false;
        for i := 0 to high(HaveMagicArr) do
        begin
          if (HaveMagicArr[i].rName) <> '' then
          begin
            if (HaveMagicArr[i].rMagicType = aMagicData.rMagicType mod 100) and (HaveMagicArr[i].rcSkillLevel >= 9999) and (HaveMagicArr[i].rMagicRelation = aMagicData.rMagicRelation) then
            begin
              boFlag := true;
              Break;
            end;
          end;
        end;
        if boFlag = false then
        begin
          FSendClass.SendChatMessage('学习上层武功,必须对应一层武功满级.', SAY_COLOR_SYSTEM);
          exit;
        end;

        //2，元气，无为  //20091110 修改 造化境
            //if PowerLevelClass.getMax(FAttribClass.AttribData.Energy) < 2 then
        if fAttribClass.PowerLevelMax < 2 then
        begin
          FSendClass.SendChatMessage('学习上层武功,必须境界到造化境.', SAY_COLOR_SYSTEM);
          exit;
        end;
        //3，浩燃60。
        if FAttribClass.AttribData.cvirtue < 6000 then
        begin
          FSendClass.SendChatMessage('学习上层武功,必须浩然到60.', SAY_COLOR_SYSTEM);
          exit;
        end;
        //是否已经学过
        for i := 0 to xHAVEMAGICSIZE - 1 do
          if (HaveRiseMagicArr[i].rName = aMagicData^.rName) then
          begin
            FSendClass.SendChatMessage('武功不能重复修炼.', SAY_COLOR_SYSTEM);
            exit;
          end;
        //增加到空位置上
        for i := 0 to xHAVEMAGICSIZE - 1 do
        begin
          if HaveRiseMagicArr[i].rName = '' then
          begin
            //                      Move(aMagicData^, HaveRiseMagicArr[i], SizeOf(TMagicData));
          //                        HaveMagicArr[i].rID := 81000 + i;
            aMagicData^.rID := HaveRiseMagicArr[i].rID;
            HaveRiseMagicArr[i] := aMagicData^;

            MagicClass.Calculate_cLifeData(@HaveRiseMagicArr[i]); //学习后直接计算属性

            FSendClass.SendHaveMagic(smt_HaveRiseMagic, i, HaveRiseMagicArr[i]);

            Result := TRUE;
            exit;
          end;
        end;
      end;
    200..299:
      begin


         //是否已经学过
        for i := 0 to xHAVEMAGICSIZE - 1 do
          if (HaveMysteryMagicArr[i].rName = aMagicData^.rName) then
            exit;
           //增加到空位置上
        for i := 0 to xHAVEMAGICSIZE - 1 do
        begin
          if HaveMysteryMagicArr[i].rName = '' then
          begin
//                      Move(aMagicData^, HaveMysteryMagicArr[i], SizeOf(TMagicData));
//                        HaveMagicArr[i].rID := 82000 + i;
            aMagicData^.rID := HaveMysteryMagicArr[i].rID;
            HaveMysteryMagicArr[i] := aMagicData^;

            FSendClass.SendHaveMagic(smt_HaveMysteryMagic, i, HaveMysteryMagicArr[i]);
            Result := TRUE;
            exit;
          end;
        end;
      end;
    300..399:
      begin

      end;
  end;

  {
     min := 2000000000;
     mini := -1;

     for i := 0 to HAVEMAGICSIZE-1 do begin
        if HaveMagicArr[i].rSkillExp <= min then begin
           min := HaveMagicArr[i].rSkillExp;
           mini := i;
        end;
     end;

     if (mini >= 0) and (mini <= HAVEMAGICSIZE-1) then begin
        if FpCurAttackMagic     = @HaveMagicArr[mini] then exit;
        if FpCurBreathngMagic   = @HaveMagicArr[mini] then exit;
        if FpCurRunningMagic    = @HaveMagicArr[mini] then exit;
        if FpCurProtectingMagic = @HaveMagicArr[mini] then exit;
        if FpCurEctMagic        = @HaveMagicArr[mini] then exit;

        HaveMagicArr[mini] := MagicData;
        FSendClass.SendHaveMagic (mini, HaveMagicArr[mini]);
        Result := TRUE;
        exit;
     end;
  }
end;

function THaveMagicClass.DeleteMagicName(aname: string): Boolean;
var
  n: integer;
begin
  result := false;
  n := GetMagicIndex(aname);
  if n <> -1 then
  begin
    result := DeleteMagic(n);
    exit;
  end;
  n := Rise_GetMagicIndex(aname);
  if n <> -1 then
  begin
    result := Rise_DeleteMagic(n);
    exit;
  end;
  n := Mystery_GetMagicIndex(aname);
  if n <> -1 then
  begin
    result := Mystery_DeleteMagic(n);
    exit;
  end;
end;

function THaveMagicClass.DeleteMagic(akey: integer): Boolean;
var
  aid: integer;
begin
  Result := FALSE;
  if (akey < 0) or (akey > HAVEMAGICSIZE60 - 1) then
    exit;
  if FpCurAttackMagic = @HaveMagicArr[akey] then
    exit;
  if FpCurBreathngMagic = @HaveMagicArr[akey] then
    exit;
  if FpCurRunningMagic = @HaveMagicArr[akey] then
    exit;
  if FpCurProtectingMagic = @HaveMagicArr[akey] then
    exit;
  if FpCurEctMagic = @HaveMagicArr[akey] then
    exit;

  DelMagic.Write(format('%s,%s,%d,%d,', [FBasicObject.BasicData.Name, HaveMagicArr[akey].rname, HaveMagicArr[akey].rSkillExp, HaveMagicArr[akey].rcSkillLevel]));

  aid := HaveMagicArr[akey].rID;
  FillChar(HaveMagicArr[akey], sizeof(TMagicData), 0);
  HaveMagicArr[akey].rID := aid;

  FSendClass.SendHaveMagic(smt_HaveMagic, akey, HaveMagicArr[akey]);
  SetLifeData;
  Result := TRUE;
end;

function THaveMagicClass.GetMagicIndex(aMagicName: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to HAVEMAGICSIZE60 - 1 do
  begin
    if (HaveMagicArr[i].rName) = aMagicName then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function THaveMagicClass.GetUsedMagicList: string;
begin
  Result := '';

  if FpCurAttackMagic <> nil then
    Result := Result + ' ' + (FpCurAttackMagic^.rName);
  if FpCurBreathngMagic <> nil then
    Result := Result + ' ' + (FpCurBreathngMagic^.rName);
  if FpCurRunningMagic <> nil then
    Result := Result + ' ' + (FpCurRunningMagic^.rName);
  if FpCurProtectingMagic <> nil then
    Result := Result + ' ' + (FpCurProtectingMagic^.rName);
  if FpCurEctMagic <> nil then
    Result := Result + ' ' + (FpCurEctMagic^.rName);
end;

function THaveMagicClass.DecEventMagic(apmagic: PTMagicData): Boolean;
begin
  Result := FALSE;
  if FAttribClass.CurLife < apmagic^.rEventDecLife then
    exit;
  if FAttribClass.CurMagic < apmagic^.rEventDecMagic then
    exit;
  if FAttribClass.CurInPower < apmagic^.rEventDecInPower then
    exit;
  if FAttribClass.CurOutPower < apmagic^.rEventDecOutPower then
    exit;

  FAttribClass.CurLife := FAttribClass.CurLife - apmagic^.rEventDecLife;
  FAttribClass.CurMagic := FAttribClass.CurMagic - apmagic^.rEventDecMagic;
  FAttribClass.CurInPower := FAttribClass.CurInPower - apmagic^.rEventDecInPower;
  FAttribClass.CurOutPower := FAttribClass.CurOutPower - apmagic^.rEventDecOutPower;
  Result := TRUE;
end;

function THaveMagicClass.ChangeMagic(asour, adest: integer): Boolean;
var
  MagicData: TMagicData;
begin
  Result := FALSE;
  if (asour < 0) or (asour > HAVEMAGICSIZE60 - 1) then
    exit;
  if (adest < 0) or (adest > HAVEMAGICSIZE60 - 1) then
    exit;

  if FpCurAttackMagic = @HaveMagicArr[asour] then
    exit;
  if FpCurBreathngMagic = @HaveMagicArr[asour] then
    exit;
  if FpCurRunningMagic = @HaveMagicArr[asour] then
    exit;
  if FpCurProtectingMagic = @HaveMagicArr[asour] then
    exit;
  if FpCurEctMagic = @HaveMagicArr[asour] then
    exit;

  if FpCurAttackMagic = @HaveMagicArr[adest] then
    exit;
  if FpCurBreathngMagic = @HaveMagicArr[adest] then
    exit;
  if FpCurRunningMagic = @HaveMagicArr[adest] then
    exit;
  if FpCurProtectingMagic = @HaveMagicArr[adest] then
    exit;
  if FpCurEctMagic = @HaveMagicArr[adest] then
    exit;

  MagicData := HaveMagicArr[asour];
  HaveMagicArr[asour] := HaveMagicArr[adest];
  HaveMagicArr[adest] := MagicData;

  FSendClass.SendHaveMagic(smt_HaveMagic, asour, HaveMagicArr[asour]);
  FSendClass.SendHaveMagic(smt_HaveMagic, adest, HaveMagicArr[adest]);
  Result := TRUE;
end;

function THaveMagicClass.ChangeBasicMagic(asour, adest: integer): Boolean;
var
  MagicData: TMagicData;
begin
  Result := FALSE;
  if (asour < 0) or (asour > 10 - 1) then
    exit;
  if (adest < 0) or (adest > 10 - 1) then
    exit;

  if FpCurAttackMagic = @DefaultMagic[asour] then
    exit;
  if FpCurBreathngMagic = @DefaultMagic[asour] then
    exit;
  if FpCurRunningMagic = @DefaultMagic[asour] then
    exit;
  if FpCurProtectingMagic = @DefaultMagic[asour] then
    exit;

  if FpCurAttackMagic = @DefaultMagic[adest] then
    exit;
  if FpCurBreathngMagic = @DefaultMagic[adest] then
    exit;
  if FpCurRunningMagic = @DefaultMagic[adest] then
    exit;
  if FpCurProtectingMagic = @DefaultMagic[adest] then
    exit;

  MagicData := DefaultMagic[asour];
  DefaultMagic[asour] := DefaultMagic[adest];
  DefaultMagic[adest] := MagicData;

  FSendClass.SendHaveMagic(smt_DefaultMagic, asour, DefaultMagic[asour]);
  FSendClass.SendHaveMagic(smt_DefaultMagic, adest, DefaultMagic[adest]);
  Result := TRUE;
end;

procedure THaveMagicClass.SetBreathngMagic(aMagic: PTMagicData);
begin
  if FpCurBreathngMagic <> nil then
  begin
    FSendClass.SendChatMessage((FpCurBreathngMagic^.rName) + ' ' + '终止', SAY_COLOR_SYSTEM);
    FpCurBreathngMagic := nil;
  end
  else
  begin
    FpCurBreathngMagic := aMagic;
    if aMagic <> nil then
    begin
      FSendClass.SendChatMessage((FpCurBreathngMagic^.rName) + ' ' + '开始', SAY_COLOR_SYSTEM);
      FpCurBreathngMagic.rMagicProcessTick := mmAnsTick;
    end;
  end;
  SetLifeData;
end;

procedure THaveMagicClass.SetRunningMagic(aMagic: PTMagicData);
begin
  if FpCurRunningMagic <> nil then
  begin
    FSendClass.SendChatMessage((FpCurRunningMagic^.rName) + ' ' + '终止', SAY_COLOR_SYSTEM);
    FpCurRunningMagic := nil;
  end
  else
  begin
    FpCurRunningMagic := aMagic;
    if aMagic <> nil then
    begin
      FSendClass.SendChatMessage((FpCurRunningMagic^.rName) + ' ' + '开始', SAY_COLOR_SYSTEM);
    end;
  end;
  SetLifeData;
end;
//护体

procedure THaveMagicClass.SetProtectingMagic(aMagic: PTMagicData);
var
  aSubData: tSubData;
begin
  if FpCurProtectingMagic <> nil then
  begin
    FSendClass.SendChatMessage((FpCurProtectingMagic^.rName) + ' ' + '终止', SAY_COLOR_SYSTEM);
    ReQuestPlaySoundNumber := FpCurProtectingMagic.rSoundEnd.rWavNumber;

    if aMagic = FpCurProtectingMagic then
    begin
      FpCurProtectingMagic := nil;
      SetLifeData;
      exit;
    end;
    FpCurProtectingMagic := nil;
  end;

  FpCurProtectingMagic := aMagic;
  if aMagic <> nil then
  begin
    FSendClass.SendChatMessage(FpCurProtectingMagic^.rName + ' ' + '开始', SAY_COLOR_SYSTEM);
    ReQuestPlaySoundNumber := FpCurProtectingMagic.rSoundStart.rWavNumber;
    if FpCurProtectingMagic.rcSkillLevel = 9999 then
    begin
      if FpCurProtectingMagic.rSEffectNumber > 0 then
        FBasicObject.ShowMagicEffect(FpCurProtectingMagic.rSEffectNumber + 1, lek_follow);
    end;
  end;

  SetLifeData;
end;

procedure THaveMagicClass.SetEctMagic(aMagic: PTMagicData);
begin
  if FpCurEctMagic <> nil then
  begin
    FSendClass.SendChatMessage((FpCurEctMagic^.rName) + ' ' + '终止', SAY_COLOR_SYSTEM);
    FpCurEctMagic := nil;
  end
  else
  begin
    FpCurEctMagic := aMagic;
    if aMagic <> nil then
    begin
      FSendClass.SendChatMessage((FpCurEctMagic^.rName) + ' ' + '开始', SAY_COLOR_SYSTEM);
    end;
  end;
  SetLifeData;
end;

{
function  THaveMagicClass.SetHaveMagicPercent (akey: integer; aper: integer): Boolean;
begin
   Result := FALSE;
   if (akey < 0) or (akey > HAVEMAGICSIZE-1) then exit;
   if (aper < 1) or (akey > 10) then exit;

   // HaveMagicArr[akey].rPercent := aper;
   FSendClass.SendHaveMagic (akey, HaveMagicArr[akey]);
   Result := TRUE;
end;
}

{
function  THaveMagicClass.SetDefaultMagicPercent (akey: integer; aper: integer): Boolean;
begin
   Result := FALSE;
   if (akey < 0) or (akey > 10-1) then exit;
   if (aper < 1) or (akey > 10) then exit;

   DefaultMagic[akey].rPercent := aper;

   FSendClass.SendBasicMagic (akey, DefaultMagic[akey]);
   Result := TRUE;
end;
}

function THaveMagicClass.SetHaveItemMagicType(atype: integer): integer;
begin
  HaveItemType := atype;
  Result := 0;
end;

{
function THaveMagicClass.FindBasicMagic (akey : Integer) : Integer;
var
   i : Integer;
begin
   Result := -1;

   if akey < 0 then exit;
   if akey > 10-1 then exit;

   for i := 0 to 10 - 1 do begin
      if aKey = DefaultMagic[i].rMagicType then begin
         Result := i;
         exit;
      end;
   end;
end;
}

function THaveMagicClass.PreSelectBasicMagic(akey, aper: integer; var RetStr: string): Boolean;
begin
  Result := false;

  if akey < 0 then
    exit;
  if akey > 20 - 1 then
    exit;
  if DefaultMagic[akey].rName = '' then
    exit;

  case DefaultMagic[akey].rMagicType of
    MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP,
      MAGICTYPE_HAMMERING, MAGICTYPE_SPEARING, MAGICTYPE_BOWING,
      MAGICTYPE_THROWING
      , MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP,
      MAGICTYPE_2HAMMERING, MAGICTYPE_2SPEARING, MAGICTYPE_2BOWING,
      MAGICTYPE_2THROWING:
      begin
        // if HaveItemType <> DefaultMagic[akey].rMagicType then begin exit; end;
        RetStr := '因头的活力不足，所以选择武功失败.';
        case aper of
          0..10:
            exit;
        else
          RetStr := '';
        end;
      end;
    MAGICTYPE_ECT:
      begin
        if FpCurAttackMagic <> nil then
        begin
          if FpCurAttackMagic^.rcSkillLevel < 9999 then
          begin
            RetStr := '辅助武功要在使用攻击性武功的状态下才能使用.';
            exit;
          end;
        end;
      end;
  end;

  Result := true;
end;

function THaveMagicClass.SelectBasicMagic(akey, aper: integer; var RetStr: string): integer;
var
  aSubData: TSubData;
begin
  Result := SELECTMAGIC_RESULT_NONE;

  case DefaultMagic[akey].rMagicType of
    MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING, MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING, MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING, MAGICTYPE_2SPEARING, MAGICTYPE_2BOWING, MAGICTYPE_2THROWING:
      begin
        //FpCurAttackMagic := @DefaultMagic[akey];
        setAttackMagic(@DefaultMagic[akey]);
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    MAGICTYPE_RUNNING, MAGICTYPE_2RUNNING:
      begin
        SetRunningMagic(@DefaultMagic[akey]);
        if FpCurRunningMagic <> nil then
          Result := SELECTMAGIC_RESULT_RUNNING
        else
          Result := SELECTMAGIC_RESULT_NORMAL;
      end;
    MAGICTYPE_BREATHNG, MAGICTYPE_2BREATHNG:
      begin
        SetBreathngMagic(@DefaultMagic[akey]);
        if FpCurBreathngMagic <> nil then
          Result := SELECTMAGIC_RESULT_SITDOWN
        else
          Result := SELECTMAGIC_RESULT_NORMAL;

        if FpCurBreathngMagic <> nil then
          SetProtectingMagic(nil);
      end;
    MAGICTYPE_PROTECTING, MAGICTYPE_2PROTECTING:
      begin
        SetProtectingMagic(@DefaultMagic[akey]);

        if FpCurProtectingMagic <> nil then
          SetBreathngMagic(nil);
      end;
  end;
  SetLifeData;
  // FBasicObject.SendLocalMessage(0, FM_CHANGEMagic, FBasicObject.BasicData, aSubData);
end;

//aper 头血 百分比

function THaveMagicClass.PreSelectHaveMagic(akey, aper: integer; var RetStr: string): Boolean;
begin
  Result := false;
  RetStr := '';
  if akey < 0 then
    exit;
  if akey > HAVEMAGICSIZE60 - 1 then
    exit;
  if HaveMagicArr[akey].rName = '' then
  begin
    RetStr := '无法识别的武功.';
    exit;
  end;

  case HaveMagicArr[akey].rMagicType of
    MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP,
      MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING:
      begin
        // if HaveItemType <> HaveMagicArr[akey].rMagicType then begin exit; end;
        RetStr := '因头的活力不足，所以选择武功失败.';
        case aper of
          0..10:
            exit;
        else
          RetStr := '';
        end;
      end;
    MAGICTYPE_ECT:
      begin
        if FpCurAttackMagic <> nil then
        begin
          if FpCurAttackMagic^.rcSkillLevel < 9999 then
          begin
            RetStr := '辅助武功要在使用攻击性武功的状态下才能使用.';
            exit;
          end;
        end;
        //地图是否允许使用
        if not FAttribClass.FBasicObject.Manager.boUseEtcMagic then
        begin
          RetStr := '当前地图不允许使用辅助武功.';
          exit;
        end;
      end;
  end;
  Result := true;
end;

function THaveMagicClass.SelectHaveMagic(akey, aper: integer; var RetStr: string): integer;
var
  aSubData: tSubData;
begin
  RetStr := '';
  Result := SELECTMAGIC_RESULT_FALSE;
  if akey < 0 then
    exit;
  if akey > HAVEMAGICSIZE60 - 1 then
    exit;
  if HaveMagicArr[akey].rName = '' then
    exit;

  case HaveMagicArr[akey].rMagicType of
    MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP,
      MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING:
      begin
        if HaveItemType <> HaveMagicArr[akey].rMagicType then
        begin
          exit;
        end;
        RetStr := '';
        // 玫窍辑滚 力寇
        RetStr := '因头的活力不足，所以选择武功失败.';
        case aper of
          0..10:
            exit;
        else
          RetStr := '';
        end;
      end;
    MAGICTYPE_ECT:
      begin
        if FpCurAttackMagic <> nil then
        begin
          if FpCurAttackMagic^.rcSkillLevel < 9999 then
          begin
            RetStr := '辅助武功要在使用攻击性武功的状态下才能使用.';
            exit;
          end;
        end;
      end;
  end;

  Result := SELECTMAGIC_RESULT_NONE;
  case HaveMagicArr[akey].rMagicType of
    MAGICTYPE_WRESTLING:
      begin
        setAttackMagic(@HaveMagicArr[akey]);
        //   FpCurAttackMagic := @HaveMagicArr[akey];
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    MAGICTYPE_FENCING:
      begin
        setAttackMagic(@HaveMagicArr[akey]);
        // FpCurAttackMagic := @HaveMagicArr[akey];
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    MAGICTYPE_SWORDSHIP:
      begin
        setAttackMagic(@HaveMagicArr[akey]);
        //   FpCurAttackMagic := @HaveMagicArr[akey];
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    MAGICTYPE_HAMMERING:
      begin
        setAttackMagic(@HaveMagicArr[akey]);
        // FpCurAttackMagic := @HaveMagicArr[akey];
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    MAGICTYPE_SPEARING:
      begin
        setAttackMagic(@HaveMagicArr[akey]);
        //   FpCurAttackMagic := @HaveMagicArr[akey];
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    MAGICTYPE_BOWING:
      begin
        setAttackMagic(@HaveMagicArr[akey]);
        //  FpCurAttackMagic := @HaveMagicArr[akey];
      //if FpCurEctMagic <> nil then SetEctMagic(nil);
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
    MAGICTYPE_THROWING:
      begin
        setAttackMagic(@HaveMagicArr[akey]);
        //  FpCurAttackMagic := @HaveMagicArr[akey];
      // if FpCurEctMagic <> nil then SetEctMagic(nil);
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;

    MAGICTYPE_RUNNING:
      begin
        SetRunningMagic(@HaveMagicArr[akey]);
        if FpCurRunningMagic <> nil then
          Result := SELECTMAGIC_RESULT_RUNNING
        else
          Result := SELECTMAGIC_RESULT_NORMAL;
      end;
    MAGICTYPE_BREATHNG:
      begin
        SetBreathngMagic(@HaveMagicArr[akey]);
        if FpCurBreathngMagic <> nil then
          Result := SELECTMAGIC_RESULT_SITDOWN
        else
          Result := SELECTMAGIC_RESULT_NORMAL;
        if FpCurBreathngMagic <> nil then
          SetProtectingMagic(nil);
      end;
    MAGICTYPE_PROTECTING:
      begin
        SetProtectingMagic(@HaveMagicArr[akey]);
        if FpCurProtectingMagic <> nil then
          SetBreathngMagic(nil);
      end;
    MAGICTYPE_ECT:
      begin
        SetEctMagic(@HaveMagicArr[akey]);
      end;
  end;
  SetLifeData;
  // FBasicObject.SendLocalMessage(0, FM_CHANGEMagic, FBasicObject.BasicData, aSubData);
end;

function THaveMagicClass.AddWalking: Boolean; //Walking 走路
var
  oldslevel: integer;
  exp: integer;
begin
  Result := FALSE;

  if boAddExp = false then
    exit;

  if FpCurRunningMagic <> nil then //使用 步法
  begin
    inc(WalkingCount);
    //  FBasicObject.BasicData.REWelkingEffect := 0;
    if (WalkingCount mod 2 = 0) and (pCurRunningMagic^.rcSkillLevel = 9999) then
      //满级2步  带动作
    begin
      //  FBasicObject.BasicData.REWelkingEffect := 5001;
      FBasicObject.ShowMagicEffect(5001, lek_follow);
    end;
    if WalkingCount >= 10 then
    begin
      WalkingCount := 0;
      exp := DEFAULTEXP;

      case pCurRunningMagic^.rcSkillLevel of
        0..4999:
          ReQuestPlaySoundNumber := FpCurRunningMagic.rSoundEvent.rWavNumber;
        5000..8999:
          ReQuestPlaySoundNumber := FpCurRunningMagic.rSoundEvent.rWavNumber + 1;
      else
        ReQuestPlaySoundNumber := FpCurRunningMagic.rSoundEvent.rWavNumber + 2;
      end;

      oldslevel := pCurRunningMagic^.rcSkillLevel;
      //步法增加经验
      _AddExp(_aet_Running, pCurRunningMagic^.rcSkillLevel, pCurRunningMagic^.rSkillExp, exp, FMagicExpMulCount, pCurRunningMagic^.rMagicExp); //满了是增加0
      if oldslevel <> pCurRunningMagic^.rcSkillLevel then
      begin //等级 变化后 发送
        SendMagicAddExp(pCurRunningMagic);
        // FSendClass.SendEventString((pCurRunningMagic^.rname));
        inc(AddExpCount);
        if (pCurRunningMagic^.rcSkillLevel = 9999) then
        begin
          UserList.SendTOPMSG(WinRGB(31, 31, 31), format('%s 恭喜你,%s 修炼值已达到顶点', [FBasicObject.BasicData.Name, pCurRunningMagic^.rname]));
          //addEnergyPoint(pCurRunningMagic.rEnergyPoint); //增加 元气点
          SetLifeData;
        end;
        if AddExpCount > 100 then
          SetLifeData;
      end;
      DecEventAttrib(FpCurRunningMagic); //扣 消耗值
      Result := TRUE;
    end;
  end;
end;

function upLevel10(v1, v2: integer): boolean;
var
  lv11: integer;
  lv21: integer;
begin
  result := false;
  lv11 := v1 div 1000;
  lv21 := v2 div 1000;
  if lv21 > lv11 then
    result := true;
end;

procedure THaveMagicClass.delEnergyPoint(aEnergyPoint: integer);
begin
  FAttribClass.delEnergy(aEnergyPoint);
end;

procedure THaveMagicClass.addEnergyPoint(aEnergyPoint: integer);
begin
  FAttribClass.addEnergy(aEnergyPoint);
end;

function THaveMagicClass.jobGetlevel: integer;
begin
  result := jobLevelx;

end;

function THaveMagicClass.jobGetKind: integer;
begin
  result := JobKind;
end;

procedure THaveMagicClass.JObgetMenu;
begin
  case JobKind of
    1, 2, 3, 4:
      ;
  else
    exit;
  end;

  if (JobSendTick = 0) or (mmAnsTick > JobSendTick + 30000) then
  begin
    JobSendTick := mmAnsTick;
    FSendClass.SendJog_menu(JobKind);
  end;
end;

function THaveMagicClass.JobgetJobGrade(): pTJobGradeData;
begin
  result := JobpTJobGradeData;
end;

procedure THaveMagicClass.jobSetKind(akind: integer);
begin
  JobKind := akind;
  JobSkillExp := 0;
  jobLevelx := 0;
  JobAddExp(0, 0);
  JobSendTick := 0;
  JObgetMenu;
end;

function THaveMagicClass.JobSetLevel(alevel: integer): boolean;
begin
  jobLevelx := alevel;

  JobpTJobGradeData := JobGradeClass.getLevle(jobLevelx);
  FSendClass.SendJog_Skill(JobKind, jobLevelx, JobpTJobGradeData);

  result := true;
end;
{
function THaveMagicClass.JobSetLevel(alevel: integer): boolean;
var
  n: integer;
begin
  result := false;
  JobSikllExp := GetLevelExp(alevel);

  n := GetLevel(JobSikllExp);
  if n <> jobLevel then
  begin
    jobLevel := n;

    JobpTJobGradeData := JobGradeClass.getLevle(jobLevel);
    FSendClass.SendJog_Skill(JobKind, jobLevel, JobpTJobGradeData);
  end;
  result := true;
end;     }

function THaveMagicClass.JobAddExp(aexp, amaxexp: integer): boolean;
var
  n: integer;
begin
  result := false;
  JobSkillExp := JobSkillExp + aexp;
  if amaxexp > 0 then
    if JobSkillExp > amaxexp then
    begin
      JobSkillExp := amaxexp;
    end;
  n := GetLevel(JobSkillExp);
  if n <> jobLevelx then
  begin
    jobLevelx := n;

    JobpTJobGradeData := JobGradeClass.getLevle(jobLevelx);
    FSendClass.SendJog_Skill(JobKind, jobLevelx, JobpTJobGradeData);
  end;
  result := true;
end;

function THaveMagicClass.AddpetExp(atype: TExpType; aexp: integer): integer;
var
  oldslevel: integer;
  aSubData: TSubData;
begin
  Result := 0;

  if boAddExp = false then
    exit;
  if pCurAttackMagic = nil then
    exit;

  case atype of
    _et_PET_MONSTER_die:
      begin
       //  FSendClass.SendLeftText('死亡经验' + inttostr(aexp div 10000), WinRGB(22, 22, 0), mtLeftText3);
      end;
  end;

  FAttribClass.addpetexp(aexp div 10000); //增加 宠物经验
end;

function THaveMagicClass.AddAttackExp(atype: TExpType; aexp: integer): integer;
var
  oldslevel: integer;
  aSubData: TSubData;
  str: string;
begin
  Result := 0;

  if boAddExp = false then
    exit;
  if pCurAttackMagic = nil then
    exit;

  case atype of
    _et_Procession:
      begin
        //队伍8个人 会得到4 倍速度
        aexp := aexp div 4;
        Procession_Exp_Sum := Procession_Exp_Sum + aexp;
        if Procession_Exp_Sum > 100000 then
        begin
          //累计10点，提示一次
          FSendClass.SendProcessionExp(Procession_Exp_Sum div 10000);
          Procession_Exp_Sum := 0;
        end;
      end;
    _et_MONSTER_die:
      begin
       // FSendClass.SendLeftText('死亡经验' + inttostr(aexp div 10000), WinRGB(22, 22, 0), mtLeftText3);
      end;
  end;

  ///////////////////////////////////////////////////////////////////////////
  //            2009 6 9 增加 攻击100次增加1点荣誉值
  {inc(AddHitCount);
  if AddHitCount >= 10 then
  begin
      FAttribClass.prestigeAdd(1);
      AddHitCount := 0;
  end;
  }

  // if pCurAttackMagic.rPercent <> 10 then exit;
  //攻击类武功增加经验
  oldslevel := pCurAttackMagic.rcSkillLevel;
  Result := _AddExp(_aet_Attack, pCurAttackMagic.rcSkillLevel, pCurAttackMagic.rSkillExp, aexp, FMagicExpMulCount, pCurAttackMagic.rMagicExp);
  if oldslevel <> pCurAttackMagic.rcSkillLevel then
  begin
    if upLevel10(oldslevel, pCurAttackMagic.rcSkillLevel) then
    begin
      FBasicObject.ShowMagicEffect(4001, lek_follow);
      ReQuestPlaySoundNumber := 4000;
    end;
    SendMagicAddExp(pCurAttackMagic);
    //  FSendClass.SendEventString((pCurAttackMagic^.rname));
    MagicClass.Calculate_cLifeData(pCurAttackMagic);

    inc(AddExpCount);
    if (pCurAttackMagic^.rcSkillLevel = 9999) then
    begin
      UserList.SendTOPMSG(WinRGB(31, 31, 31), format('%s 恭喜你,%s 修炼值已达到顶点', [FBasicObject.BasicData.Name, pCurAttackMagic^.rname]));
      //addEnergyPoint(pCurAttackMagic.rEnergyPoint); //增加 元气点
      //SetLifeData;

    end;
    //SetLifeData; //每次等级改变都计算属性
    if AddExpCount > 100 then
    begin
      SetLifeData;
    end;

  end;

  //FSendClass.SendChatMessage(format('%d杀怪物经验%d，实际得到经验%d,等级变化%d', [AddExpCount, aexp, Result, pCurAttackMagic.rcSkillLevel - oldslevel]), SAY_COLOR_SYSTEM);
  if pCurEctMagic <> nil then
  begin
    // oldslevel := pCurEctMagic.rcSkillLevel;
    Result := GetPermitExp(pCurEctMagic.rcSkillLevel, aexp);

  end;
end;

function THaveMagicClass.AddProtectExp(atype: TExpType; aexp: integer): integer;
//护体 被攻击 增加 经验
var
  oldslevel: integer;
begin
  Result := 0;
  if boAddExp = false then
    exit;

  if pCurProtectingMagic = nil then
    exit;
  // if pCurProtectingMagic.rPercent <> 10 then exit;
  oldslevel := pCurProtectingMagic.rcSkillLevel;
  //护体增加经验
  Result := _AddExp(_aet_Protecting, pCurProtectingMagic.rcSkillLevel, pCurProtectingMagic.rSkillExp, aexp, FMagicExpMulCount, pCurProtectingMagic.rMagicExp);
  if oldslevel <> pCurProtectingMagic.rcSkillLevel then
  begin

    SendMagicAddExp(pCurProtectingMagic);
    //        FSendClass.SendEventString((pCurProtectingMagic^.rname));
    MagicClass.Calculate_cLifeData(pCurProtectingMagic);

    inc(AddExpCount);
    if (pCurProtectingMagic^.rcSkillLevel = 9999) then
    begin
      UserList.SendTOPMSG(WinRGB(31, 31, 31), format('%s 恭喜你,%s 修炼值已达到顶点', [FBasicObject.BasicData.Name, pCurProtectingMagic^.rname]));
     // addEnergyPoint(pCurProtectingMagic.rEnergyPoint); //增加 元气点
      SetLifeData;
    end;
    if AddExpCount > 100 then
      SetLifeData;
  end;
end;

function THaveMagicClass.clearMagicExp(aname: string): Integer;
var
  p: pTMagicData;
begin
  p := All_FindName(aname);
  if p = nil then
    exit;
  if p.rcSkillLevel = 9999 then
    result := clearlevel(p.rcSkillLevel, p.rSkillExp)
  else
    result := 9;
end;

function THaveMagicClass.AddMagicExp(aname: string; aexp: integer): integer;
var
  p: pTMagicData;
  oldslevel: integer;
begin
  result := 0;
  p := All_FindName(aname); //p.rEnergyPoint
  if p = nil then
    exit;
  oldslevel := p.rcSkillLevel;
  Result := _AddExpNotLevelMax(p.rcSkillLevel, p.rSkillExp, aexp);
  if oldslevel <> p.rcSkillLevel then
  begin
    SendMagicAddExp(p);
    MagicClass.Calculate_cLifeData(p);
    if (p^.rcSkillLevel = 9999) then
    begin
      UserList.SendTOPMSG(WinRGB(31, 31, 31), format('%s 恭喜你,%s 修炼值已达到顶点', [FBasicObject.BasicData.Name, p.rname]));
     // addEnergyPoint(p.rEnergyPoint); //增加 元气点
    end;
    SetLifeData;
  end;
end;

//修改武功等级

function THaveMagicClass.SetMagicLevel(MagicName: string; MagicLevel: integer): Boolean;
var
  p: pTMagicData;
begin
  result := False;
  //根据名字获取武功数据
  p := All_FindName(MagicName); //p.rEnergyPoint
  if p = nil then
    exit;
  //判断等级范围
  if (MagicLevel > 9999) or (MagicLevel < 100) then
    MagicLevel := 100;
  //判断等级有没有变化
  if MagicLevel <> p.rcSkillLevel then
  begin
    //改变值
    p.rcSkillLevel := MagicLevel;
    p.rSkillExp := GetLevelExp(MagicLevel);
    //改变数据
    SendMagicAddExp(p);
    MagicClass.Calculate_cLifeData(p);
    //写入属性
    SetLifeData;
  end;
  result := True;
end;

function THaveMagicClass.AddEctExp(atype: TExpType; aexp: integer): integer;
//强身 攻击 增加经验
var
  oldslevel: integer;
begin
  Result := 0;
  if boAddExp = false then
    exit;

  if pCurEctMagic = nil then
    exit;
  // if pCurEctMagic.rPercent <> 10 then exit;
  oldslevel := pCurEctMagic.rcSkillLevel;
  //辅助武功增加经验
  Result := _AddExp(_aet_ect, pCurEctMagic.rcSkillLevel, pCurEctMagic.rSkillExp, aexp, FMagicExpMulCount, pCurEctMagic.rMagicExp);
  if oldslevel <> pCurEctMagic.rcSkillLevel then
  begin

    SendMagicAddExp(pCurEctMagic);
    //  FSendClass.SendEventString((pCurEctMagic^.rname));
    MagicClass.Calculate_cLifeData(pCurEctMagic);

    inc(AddExpCount);
    if (pCurEctMagic^.rcSkillLevel = 9999) then
    begin
      UserList.SendTOPMSG(WinRGB(31, 31, 31), format('%s 恭喜你,%s 修炼值已达到顶点', [FBasicObject.BasicData.Name, pCurEctMagic^.rname]));
      //addEnergyPoint(pCurEctMagic.rEnergyPoint); //增加 元气点
      SetLifeData;
    end;
    if AddExpCount > 100 then
      SetLifeData;
  end;
end;

function THaveMagicClass.boKeepingMagic(pMagicData: PTMagicData): Boolean;
begin
  Result := TRUE;
  if FAttribClass.CurAttribData.CurEnergy < pMagicData^.rKeepEnergy then
    Result := FALSE;

  if FAttribClass.CurAttribData.CurInPower < pMagicData^.rKeepInPower then
    Result := FALSE;

  if FAttribClass.CurAttribData.CurOutPower < pMagicData^.rKeepOutPower then
    Result := FALSE;

  if FAttribClass.CurAttribData.CurMagic < pMagicData^.rKeepMagic then
    Result := FALSE;

  if FAttribClass.CurAttribData.CurLife < pMagicData^.rKeepLife then
    Result := FALSE;                               
end;

procedure THaveMagicClass.Dec5SecAttrib(pMagicData: PTMagicData);
begin

  with FAttribClass do
  begin
    CurAttribData.CurEnergy := CurAttribData.CurEnergy - pMagicData^.r5SecDecEnergy;
    CurAttribData.CurInPower := CurAttribData.CurInPower - pMagicData^.r5SecDecInPower;
    CurAttribData.CurOutPower := CurAttribData.CurOutPower - pMagicData^.r5SecDecOutPower;
    CurAttribData.CurMagic := CurAttribData.CurMagic - pMagicData^.r5SecDecMagic;
    CurAttribData.CurLife := CurAttribData.CurLife - pMagicData^.r5SecDecLife;

    if CurAttribData.CurEnergy < 0 then
      CurAttribData.CurEnergy := 0;
    if CurAttribData.CurInPower < 0 then
      CurAttribData.CurInPower := 0;
    if CurAttribData.CurOutPower < 0 then
      CurAttribData.CurOutPower := 0;
    if CurAttribData.CurMagic < 0 then
      CurAttribData.CurMagic := 0;
    if CurAttribData.CurLife < 0 then
      CurAttribData.CurLife := 0;

    // if CurAttribData.CurEnergy > AttribData.cEnergy then CurAttribData.CurEnergy := AttribData.cEnergy;
    // if CurAttribData.CurInPower > AttribData.cInPower then CurAttribData.CurInPower := AttribData.cInPower;
    // if CurAttribData.CurOutPower > AttribData.cOutPower then CurAttribData.CurOutPower := AttribData.cOutPower;
    // if CurAttribData.CurMagic > AttribData.cMagic then CurAttribData.CurMagic := AttribData.cMagic;
    // if CurAttribData.CurLife > AttribData.cLife then CurAttribData.CurLife := AttribData.cLife;

    if CurAttribData.CurEnergy > (AttribData.cEnergy + AttribQuestData.Energy) then
      CurAttribData.CurEnergy := (AttribData.cEnergy + AttribQuestData.Energy);
    if CurAttribData.CurInPower > (AttribData.cInPower + AttribQuestData.InPower) then
      CurAttribData.CurInPower := (AttribData.cInPower + AttribQuestData.InPower);
    if CurAttribData.CurOutPower > (AttribData.cOutPower + AttribQuestData.OutPower) then
      CurAttribData.CurOutPower := (AttribData.cOutPower + AttribQuestData.OutPower);
    if CurAttribData.CurMagic > (AttribData.cMagic + AttribQuestData.Magic) then
      CurAttribData.CurMagic := (AttribData.cMagic + AttribQuestData.Magic);
    if CurAttribData.CurLife > (AttribData.cLife + AttribQuestData.Life) then
      CurAttribData.CurLife := (AttribData.cLife + AttribQuestData.Life);
  end;
end;

procedure THaveMagicClass.DecEventAttrib(pMagicData: PTMagicData);
var
  n: integer;
begin
  with FAttribClass do
  begin
    n := pMagicData^.rEventDecEnergy + pMagicData^.rEventDecEnergy * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
    dec(CurAttribData.CurEnergy, n);

    n := pMagicData^.rEventDecInPower + pMagicData^.rEventDecInPower * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
    dec(CurAttribData.CurInPower, n);

    n := pMagicData^.rEventDecOutPower + pMagicData^.rEventDecOutPower * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
    dec(CurAttribData.CurOutPower, n);

    n := pMagicData^.rEventDecMagic + pMagicData^.rEventDecMagic * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
    dec(CurAttribData.CurMagic, n);

    n := pMagicData^.rEventDecLife + pMagicData^.rEventDecLife * pMagicData^.rcSkillLevel div INI_SKILL_DIV_EVENT;
    dec(CurAttribData.CurLife, n);

    if CurAttribData.CurEnergy < 0 then
      CurAttribData.CurEnergy := 0;
    if CurAttribData.CurInPower < 0 then
      CurAttribData.CurInPower := 0;
    if CurAttribData.CurOutPower < 0 then
      CurAttribData.CurOutPower := 0;
    if CurAttribData.CurMagic < 0 then
      CurAttribData.CurMagic := 0;
    if CurAttribData.CurLife < 0 then
      CurAttribData.CurLife := 0;

    // if CurAttribData.CurEnergy > AttribData.cEnergy then CurAttribData.CurEnergy := AttribData.cEnergy;
    // if CurAttribData.CurInPower > AttribData.cInPower then CurAttribData.CurInPower := AttribData.cInPower;
    // if CurAttribData.CurOutPower > AttribData.cOutPower then CurAttribData.CurOutPower := AttribData.cOutPower;
    // if CurAttribData.CurMagic > AttribData.cMagic then CurAttribData.CurMagic := AttribData.cMagic;
    // if CurAttribData.CurLife > AttribData.cLife then CurAttribData.CurLife := AttribData.cLife;

    if CurAttribData.CurEnergy > (AttribData.cEnergy + AttribQuestData.Energy) then
      CurAttribData.CurEnergy := (AttribData.cEnergy + AttribQuestData.Energy);
    if CurAttribData.CurInPower > (AttribData.cInPower + AttribQuestData.InPower) then
      CurAttribData.CurInPower := (AttribData.cInPower + AttribQuestData.InPower);
    if CurAttribData.CurOutPower > (AttribData.cOutPower + AttribQuestData.OutPower) then
      CurAttribData.CurOutPower := (AttribData.cOutPower + AttribQuestData.OutPower);
    if CurAttribData.CurMagic > (AttribData.cMagic + AttribQuestData.Magic) then
      CurAttribData.CurMagic := (AttribData.cMagic + AttribQuestData.Magic);
    if CurAttribData.CurLife > (AttribData.cLife + AttribQuestData.Life) then
      CurAttribData.CurLife := (AttribData.cLife + AttribQuestData.Life);
  end;
end;

procedure THaveMagicClass.DecBreathngAttrib(pMagicData: PTMagicData);
var
  max: integer;
begin
  with FAttribClass do
  begin
    max := AttribData.cEnergy div (6 + (12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
    max := max * pMagicData^.rEventBreathngEnergy div 100;
    dec(CurAttribData.CurEnergy, max);

    max := AttribData.cInPower div (6 + (12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
    max := max * pMagicData^.rEventBreathngInPower div 100;
    dec(CurAttribData.CurInPower, max);

    max := AttribData.cOutPower div (6 + (12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
    max := max * pMagicData^.rEventBreathngOutPower div 100;
    dec(CurAttribData.CurOutPower, max);

    max := AttribData.cMagic div (6 + (12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
    max := max * pMagicData^.rEventBreathngMagic div 100;
    dec(CurAttribData.CurMagic, max);

    max := AttribData.cLife div (6 + (12000 - pMagicData^.rcSkillLevel) * 14 div 12000);
    max := max * pMagicData^.rEventBreathngLife div 100;
    dec(CurAttribData.CurLife, max);

    if CurAttribData.CurEnergy < 0 then
      CurAttribData.CurEnergy := 0;
    if CurAttribData.CurInPower < 0 then
      CurAttribData.CurInPower := 0;
    if CurAttribData.CurOutPower < 0 then
      CurAttribData.CurOutPower := 0;
    if CurAttribData.CurMagic < 0 then
      CurAttribData.CurMagic := 0;
    if CurAttribData.CurLife < 0 then
      CurAttribData.CurLife := 0;

    // if CurAttribData.CurEnergy > AttribData.cEnergy then CurAttribData.CurEnergy := AttribData.cEnergy;
    // if CurAttribData.CurInPower > AttribData.cInPower then CurAttribData.CurInPower := AttribData.cInPower;
    // if CurAttribData.CurOutPower > AttribData.cOutPower then CurAttribData.CurOutPower := AttribData.cOutPower;
     //if CurAttribData.CurMagic > AttribData.cMagic then CurAttribData.CurMagic := AttribData.cMagic;
    // if CurAttribData.CurLife > AttribData.cLife then CurAttribData.CurLife := AttribData.cLife;
    if CurAttribData.CurEnergy > (AttribData.cEnergy + AttribQuestData.Energy) then
      CurAttribData.CurEnergy := (AttribData.cEnergy + AttribQuestData.Energy);
    if CurAttribData.CurInPower > (AttribData.cInPower + AttribQuestData.InPower) then
      CurAttribData.CurInPower := (AttribData.cInPower + AttribQuestData.InPower);
    if CurAttribData.CurOutPower > (AttribData.cOutPower + AttribQuestData.OutPower) then
      CurAttribData.CurOutPower := (AttribData.cOutPower + AttribQuestData.OutPower);
    if CurAttribData.CurMagic > (AttribData.cMagic + AttribQuestData.Magic) then
      CurAttribData.CurMagic := (AttribData.cMagic + AttribQuestData.Magic);
    if CurAttribData.CurLife > (AttribData.cLife + AttribQuestData.Life) then
      CurAttribData.CurLife := (AttribData.cLife + AttribQuestData.Life);
  end;
end;

function THaveMagicClass.getuserMagic: string;
var
  p: PTMagicData;
begin
  RESULT := '';
  if pCurAttackMagic <> nil then
  begin
    RESULT := pCurAttackMagic.rname;
    EXIT;
  end;
  if pCurBreathngMagic <> nil then
  begin
    RESULT := pCurBreathngMagic.rname;
    EXIT;
  end;
  if pCurRunningMagic <> nil then
  begin
    RESULT := pCurRunningMagic.rname;
    EXIT;
  end;
  if pCurProtectingMagic <> nil then
  begin
    RESULT := pCurProtectingMagic.rname;
    EXIT;
  end;

end;

function THaveMagicClass.MagicSpaceCount: integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to high(HaveMagicArr) do
  begin
    if (HaveMagicArr[i].rName) = '' then
    begin
      Result := Result + 1;
    end;
  end;

end;

function THaveMagicClass.All_FindName(aMagicName: string): PTMagicData;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to high(HaveMagicArr) do
  begin
    if (HaveMagicArr[i].rName) = aMagicName then
    begin
      Result := @HaveMagicArr[i];
      exit;
    end;
  end;
  for i := 0 to high(DefaultMagic) do
  begin
    if (DefaultMagic[i].rName) = aMagicName then
    begin
      Result := @DefaultMagic[i];
      exit;
    end;
  end;
  for i := 0 to high(HaveRiseMagicArr) do
  begin
    if (HaveRiseMagicArr[i].rName) = aMagicName then
    begin
      Result := @HaveRiseMagicArr[i];
      exit;
    end;
  end;
  for i := 0 to high(HaveMysteryMagicArr) do
  begin
    if (HaveMysteryMagicArr[i].rName) = aMagicName then
    begin
      Result := @HaveMysteryMagicArr[i];
      exit;
    end;
  end;
end;

function THaveMagicClass.changes(x: string): integer; //真元点三魂单个武功
var
  i, t, sum: integer;
begin
  Result := 0;
  if pos('无名', pCurAttackMagic.rname) <= 0 then
  begin
    result := 7;
    Exit;
  end;
  sum := 0;
  t := 0;
  //获取HaveMagicArr武功的元气总和
  for i := 0 to high(HaveMagicArr) do
  begin
    if HaveMagicArr[i].rcSkillLevel >= 9999 then
    begin
      if HaveMagicArr[i].rname = x then
        t := 1;
    end;
  end;
  if t = 1 then
  begin
    t := 0;
    for i := 0 to high(HaveMagicArr) do
    begin
      if HaveMagicArr[i].rcSkillLevel >= 9999 then
      begin
        if HaveMagicArr[i].rname = x then
        begin
          sum := HaveMagicArr[i].rEnergyPoint;
          if DeleteMagicName(HaveMagicArr[i].rName) then
            t := 2; //20130605修改
        end;
      end;
    end;
    if t = 2 then
      Self.FAttribClass.Settalent(Self.FAttribClass.gettalent + sum);
    result := Self.FAttribClass.gettalent;
  end;
end;

function THaveMagicClass.changem(x: integer): integer; //真元点三魂
var
  i, t, sum, add: integer;
begin
  Result := 0;

  { MAGICTYPE_WRESTLING = 0; // 拳
  MAGICTYPE_FENCING = 1; //剑
  MAGICTYPE_SWORDSHIP = 2; //刀
  MAGICTYPE_HAMMERING = 3; //槌
  MAGICTYPE_SPEARING = 4; //枪

  MAGICTYPE_BOWING = 5; //弓
  MAGICTYPE_THROWING = 6; //投

  MAGICTYPE_RUNNING = 7; //步法
  MAGICTYPE_BREATHNG = 8; //心法
  MAGICTYPE_PROTECTING = 9; //护体

  MAGICTYPE_ECT = 10; // 辅助武功
  procedure cal(uSource, uDest:integer);
    var
    i:integer;
     // temp: integer;
    begin
       i:=changem(usource,0);//0是兑换拳法一套
       case i of
       7:say(uDest,'你需要把当前使用的武功切换成无名武功！');
       6:set3f_sky(usource,get3f_sky(usource)+1);
       0..5:say(uDest,'这套武功没满！');
       end;
    end;
}
  if pos('无名', pCurAttackMagic.rname) <= 0 then
  begin
    result := 7;
    Exit;
  end;
  if x > 6 then
    Exit;
  t := 0;
  sum := 0;
  add := 0;
  //获取HaveMagicArr武功的元气总和
  for i := 0 to high(HaveMagicArr) do
  begin
    if HaveMagicArr[i].rcSkillLevel >= 9999 then
    begin
      if (HaveMagicArr[i].rGuildMagictype = 0) and (HaveMagicArr[i].rName <> '三功剑式') then //不是门武的话
        if HaveMagicArr[i].rMagicType = x then
          Inc(t);
    end;
  end;

  if t = 6 then
  begin
    t := 0;
    for i := 0 to high(HaveMagicArr) do
    begin
      if (HaveMagicArr[i].rGuildMagictype = 0) and (HaveMagicArr[i].rName <> '三功剑式') then //不是门武的话
        if HaveMagicArr[i].rcSkillLevel >= 9999 then
        begin
          add := HaveMagicArr[i].rEnergyPoint;
          if HaveMagicArr[i].rMagicType = x then
            if DeleteMagicName(HaveMagicArr[i].rName) then
            begin
              sum := sum + add;
              Inc(t); //20130605修改
            end;
        end;
    end;

    if t = 6 then
      if sum < 7000 then
        Self.FAttribClass.Settalent(Self.FAttribClass.gettalent + sum + 500);
    result := Self.FAttribClass.gettalent;
  end;

end;


//获得所有武功的总元气     20130716修改，满一套武功加元气

function THaveMagicClass.All_MagicEnerySum(): integer;
var
  aRow: array[0..199] of Byte; //纵向加成
  yCow: array[0..9] of Byte; //一层横向加成
  eCow: array[0..9] of Byte; //二层横向加成
  AllEnery, i, n, m, Max: integer;
begin
  Result := 0;
  AllEnery := 0;
  Max := 0;
  fillchar(aRow, sizeof(aRow), 0);
  fillchar(yCow, sizeof(yCow), 0);
  fillchar(eCow, sizeof(eCow), 0);
  //获取基本武功的元气总和
  for i := 0 to high(DefaultMagic) do
  begin
    if DefaultMagic[i].rcSkillLevel >= 9999 then
    begin
      //frmMain.WriteLogInfo(Format('满级武功【%s】增加元气 %d', [DefaultMagic[i].rname, DefaultMagic[i].rEnergyPoint]));
      Inc(Max); //满级武功数量加1
      AllEnery := AllEnery + DefaultMagic[i].rEnergyPoint;
      case DefaultMagic[i].rMagicType of
        MAGICTYPE_WRESTLING:
          begin
            Inc(aRow[MAGICTYPE_WRESTLING]); // 1级拳  纵向增加
            Inc(yCow[DefaultMagic[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_FENCING:
          begin
            Inc(aRow[MAGICTYPE_FENCING]); // 1级剑  纵向增加
            Inc(yCow[DefaultMagic[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_SWORDSHIP:
          begin
            Inc(aRow[MAGICTYPE_SWORDSHIP]); // 1级刀  纵向增加
            Inc(yCow[DefaultMagic[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_HAMMERING:
          begin
            Inc(aRow[MAGICTYPE_HAMMERING]); // 1级槌  纵向增加
            Inc(yCow[DefaultMagic[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_SPEARING:
          begin
            Inc(aRow[MAGICTYPE_SPEARING]); // 1级枪  纵向增加
            Inc(yCow[DefaultMagic[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_BOWING:
          begin
            Inc(aRow[MAGICTYPE_BOWING]); // 1级弓  纵向增加
          end;
        MAGICTYPE_THROWING:
          begin
            Inc(aRow[MAGICTYPE_THROWING]); // 1级投  纵向增加
          end;
        MAGICTYPE_RUNNING:
          begin
            Inc(aRow[MAGICTYPE_RUNNING]); // 1级步法  纵向增加
          end;
        MAGICTYPE_BREATHNG:
          begin
            Inc(aRow[MAGICTYPE_BREATHNG]); // 1级心法  纵向增加
          end;
        MAGICTYPE_PROTECTING:
          begin
            Inc(aRow[MAGICTYPE_PROTECTING]); // 1级护体  纵向增加
          end;
        MAGICTYPE_2WRESTLING:
          begin
            Inc(aRow[MAGICTYPE_2WRESTLING]); // 2级拳  纵向增加
            Inc(eCow[DefaultMagic[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2FENCING:
          begin
            Inc(aRow[MAGICTYPE_2FENCING]); // 2级剑  纵向增加
            Inc(eCow[DefaultMagic[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2SWORDSHIP:
          begin
            Inc(aRow[MAGICTYPE_2SWORDSHIP]); // 2级刀  纵向增加
            Inc(eCow[DefaultMagic[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2HAMMERING:
          begin
            Inc(aRow[MAGICTYPE_2HAMMERING]); // 2级槌  纵向增加
            Inc(eCow[DefaultMagic[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2SPEARING:
          begin
            Inc(aRow[MAGICTYPE_2SPEARING]); // 2级枪  纵向增加
            Inc(eCow[DefaultMagic[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2BOWING:
          begin
            Inc(aRow[MAGICTYPE_2BOWING]); // 2级弓  纵向增加
          end;
        MAGICTYPE_2THROWING:
          begin
            Inc(aRow[MAGICTYPE_2THROWING]); // 2级投  纵向增加
          end;
        MAGICTYPE_2RUNNING:
          begin
            Inc(aRow[MAGICTYPE_2RUNNING]); // 2级步法  纵向增加
          end;
        MAGICTYPE_2PROTECTING:
          begin
            Inc(aRow[MAGICTYPE_2PROTECTING]); // 2级心法  纵向增加
          end;
      end;
    end
    else if DefaultMagic[i].rcSkillLevel >= 9000 then
    begin
      AllEnery := AllEnery + Trunc(DefaultMagic[i].rEnergyPoint * 0.5);
    end
    else if DefaultMagic[i].rcSkillLevel >= 8000 then
    begin
      AllEnery := AllEnery + Trunc(DefaultMagic[i].rEnergyPoint * 0.4);
    end
    else if DefaultMagic[i].rcSkillLevel >= 7000 then
    begin
      AllEnery := AllEnery + Trunc(DefaultMagic[i].rEnergyPoint * 0.3);
    end
    else if DefaultMagic[i].rcSkillLevel >= 6000 then
    begin
      AllEnery := AllEnery + Trunc(DefaultMagic[i].rEnergyPoint * 0.2);
    end
    else if DefaultMagic[i].rcSkillLevel >= 5000 then
    begin
      AllEnery := AllEnery + Trunc(DefaultMagic[i].rEnergyPoint * 0.1);
    end;
  end;
  //获取一层武功的元气总和
  for i := 0 to high(HaveMagicArr) do
  begin
    if HaveMagicArr[i].rcSkillLevel >= 9999 then
    begin
      Inc(Max); //满级武功数量加1
      AllEnery := AllEnery + HaveMagicArr[i].rEnergyPoint;
      //frmMain.WriteLogInfo(Format('满级武功【%s】增加元气 %d', [HaveMagicArr[i].rname, HaveMagicArr[i].rEnergyPoint]));
      case HaveMagicArr[i].rMagicType of
        MAGICTYPE_WRESTLING:
          begin
            Inc(aRow[MAGICTYPE_WRESTLING]); // 1级拳  纵向增加
            Inc(yCow[HaveMagicArr[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_FENCING:
          begin
            Inc(aRow[MAGICTYPE_FENCING]); // 1级剑  纵向增加
            Inc(yCow[HaveMagicArr[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_SWORDSHIP:
          begin
            Inc(aRow[MAGICTYPE_SWORDSHIP]); // 1级刀  纵向增加
            Inc(yCow[HaveMagicArr[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_HAMMERING:
          begin
            Inc(aRow[MAGICTYPE_HAMMERING]); // 1级槌  纵向增加
            Inc(yCow[HaveMagicArr[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_SPEARING:
          begin
            Inc(aRow[MAGICTYPE_SPEARING]); // 1级枪  纵向增加
            Inc(yCow[HaveMagicArr[i].rMagicRelation]); // 一层横向增加
          end;
        MAGICTYPE_BOWING:
          begin
            Inc(aRow[MAGICTYPE_BOWING]); // 1级弓  纵向增加
          end;
        MAGICTYPE_THROWING:
          begin
            Inc(aRow[MAGICTYPE_THROWING]); // 1级投  纵向增加
          end;
        MAGICTYPE_RUNNING:
          begin
            Inc(aRow[MAGICTYPE_RUNNING]); // 1级步法  纵向增加
          end;
        MAGICTYPE_BREATHNG:
          begin
            Inc(aRow[MAGICTYPE_BREATHNG]); // 1级心法  纵向增加
          end;
        MAGICTYPE_PROTECTING:
          begin
            Inc(aRow[MAGICTYPE_PROTECTING]); // 1级护体  纵向增加
          end;
      end;
    end
    else if HaveMagicArr[i].rcSkillLevel >= 9000 then
    begin
      AllEnery := AllEnery + Trunc(HaveMagicArr[i].rEnergyPoint * 0.5);
    end
    else if HaveMagicArr[i].rcSkillLevel >= 8000 then
    begin
      AllEnery := AllEnery + Trunc(HaveMagicArr[i].rEnergyPoint * 0.4);
    end
    else if HaveMagicArr[i].rcSkillLevel >= 7000 then
    begin
      AllEnery := AllEnery + Trunc(HaveMagicArr[i].rEnergyPoint * 0.3);
    end
    else if HaveMagicArr[i].rcSkillLevel >= 6000 then
    begin
      AllEnery := AllEnery + Trunc(HaveMagicArr[i].rEnergyPoint * 0.2);
    end
    else if HaveMagicArr[i].rcSkillLevel >= 5000 then
    begin
      AllEnery := AllEnery + Trunc(HaveMagicArr[i].rEnergyPoint * 0.1);
    end;
  end;
  //获取二层武功的元气总和
  for i := 0 to high(HaveRiseMagicArr) do
  begin
    if HaveRiseMagicArr[i].rcSkillLevel >= 9999 then
    begin
      Inc(Max); //满级武功数量加1
      AllEnery := AllEnery + HaveRiseMagicArr[i].rEnergyPoint;
      //frmMain.WriteLogInfo(Format('满级武功【%s】增加元气 %d', [HaveRiseMagicArr[i].rname, HaveRiseMagicArr[i].rEnergyPoint]));
      case HaveRiseMagicArr[i].rMagicType of
        MAGICTYPE_2WRESTLING:
          begin
            Inc(aRow[MAGICTYPE_2WRESTLING]); // 2级拳  纵向增加
            Inc(eCow[HaveRiseMagicArr[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2FENCING:
          begin
            Inc(aRow[MAGICTYPE_2FENCING]); // 2级剑  纵向增加
            Inc(eCow[HaveRiseMagicArr[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2SWORDSHIP:
          begin
            Inc(aRow[MAGICTYPE_2SWORDSHIP]); // 2级刀  纵向增加
            Inc(eCow[HaveRiseMagicArr[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2HAMMERING:
          begin
            Inc(aRow[MAGICTYPE_2HAMMERING]); // 2级槌  纵向增加
            Inc(eCow[HaveRiseMagicArr[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2SPEARING:
          begin
            Inc(aRow[MAGICTYPE_2SPEARING]); // 2级枪  纵向增加
            Inc(eCow[HaveRiseMagicArr[i].rMagicRelation]); // 2级 横向增加
          end;
        MAGICTYPE_2BOWING:
          begin
            Inc(aRow[MAGICTYPE_2BOWING]); // 2级弓  纵向增加
          end;
        MAGICTYPE_2THROWING:
          begin
            Inc(aRow[MAGICTYPE_2THROWING]); // 2级投  纵向增加
          end;
        MAGICTYPE_2RUNNING:
          begin
            Inc(aRow[MAGICTYPE_2RUNNING]); // 2级步法  纵向增加
          end;
        MAGICTYPE_2PROTECTING:
          begin
            Inc(aRow[MAGICTYPE_2PROTECTING]); // 2级心法  纵向增加
          end;
      end;
    end
    else if HaveRiseMagicArr[i].rcSkillLevel >= 9000 then
    begin
      AllEnery := AllEnery + Trunc(HaveRiseMagicArr[i].rEnergyPoint * 0.5);
    end
    else if HaveRiseMagicArr[i].rcSkillLevel >= 8000 then
    begin
      AllEnery := AllEnery + Trunc(HaveRiseMagicArr[i].rEnergyPoint * 0.4);
    end
    else if HaveRiseMagicArr[i].rcSkillLevel >= 7000 then
    begin
      AllEnery := AllEnery + Trunc(HaveRiseMagicArr[i].rEnergyPoint * 0.3);
    end
    else if HaveRiseMagicArr[i].rcSkillLevel >= 6000 then
    begin
      AllEnery := AllEnery + Trunc(HaveRiseMagicArr[i].rEnergyPoint * 0.2);
    end
    else if HaveRiseMagicArr[i].rcSkillLevel >= 5000 then
    begin
      AllEnery := AllEnery + Trunc(HaveRiseMagicArr[i].rEnergyPoint * 0.1);
    end;
  end;
  //满级超过5个才继续处理附加元气
  if Max >= 5 then
  begin
  //处理纵向增加元气
    for i := 0 to high(aRow) do
    begin
      if aRow[i] >= 7 then
      begin
       // frmMain.WriteLogInfo(Format('纵向key【%d】增加元气', [i]));
        if i <= 99 then
          AllEnery := AllEnery + 700
        else
          AllEnery := AllEnery + 1050;
      end;
    end;
  //处理一层横向增加元气
    for i := 0 to high(yCow) do
    begin
      if yCow[i] >= 5 then
      begin
        //frmMain.WriteLogInfo(Format('横向一层key【%d】增加元气', [i]));
        AllEnery := AllEnery + 500;
      end;
    end;
  //处理二层横向增加元气
    for i := 0 to high(eCow) do
    begin
      if eCow[i] >= 5 then
      begin
        //frmMain.WriteLogInfo(Format('横向二层key【%d】增加元气', [i]));
        AllEnery := AllEnery + 750;
      end;
    end;
  end;

  //返回元气的总和
  Result := AllEnery;
end;

function THaveMagicClass.GetMagicSkillLevel(aMagicName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to HAVEMAGICSIZE60 - 1 do
  begin
    if (HaveMagicArr[i].rName) = aMagicName then
    begin
      Result := HaveMagicArr[i].rcSkillLevel;
      exit;
    end;
  end;
end;

function THaveMagicClass.Update(CurTick: integer): integer;
var
  oldslevel: integer;
  closeflag, upflag: Boolean;
  aSubData: TSubData;
begin
  Result := 0;
  if FpCurAttackMagic <> nil then
  begin
    if CurTick > FpCurAttackMagic.rMagicProcessTick + 500 then
    begin
      FpCurAttackMagic.rMagicProcessTick := CurTick;
      Dec5SecAttrib(FpCurAttackMagic);
      if not boKeepingMagic(FpCurAttackMagic) then
      begin
        Result := RET_CLOSE_ATTACK;
        exit;
      end;
    end;
  end;

  if FpCurRunningMagic <> nil then
  begin
    if CurTick > FpCurRunningMagic.rMagicProcessTick + 500 then
    begin
      FpCurRunningMagic.rMagicProcessTick := CurTick;
      Dec5SecAttrib(FpCurRunningMagic);
      if not boKeepingMagic(FpCurRunningMagic) then
      begin
        Result := RET_CLOSE_RUNNING;
        exit;
      end;
    end;
  end;

  if FpCurProtectingMagic <> nil then
  begin
    if CurTick > FpCurProtectingMagic.rMagicProcessTick + 500 then
    begin
      FpCurProtectingMagic.rMagicProcessTick := CurTick;
      Dec5SecAttrib(FpCurProtectingMagic);
      if not boKeepingMagic(FpCurProtectingMagic) then
      begin
        Result := RET_CLOSE_PROTECTING;
        exit;
      end;
    end;
  end;

  if FpCurBreathngMagic <> nil then //Breath 心法
  begin
    if CurTick > FpCurBreathngMagic.rMagicProcessTick + 500 then
    begin
      case FpCurBreathngMagic.rcSkillLevel of
        0..4999:
          ReQuestPlaySoundNumber := FpCurBreathngMagic.rSoundEvent.rWavNumber;
        5000..8999:
          ReQuestPlaySoundNumber := FpCurBreathngMagic.rSoundEvent.rWavNumber + 2;
      else
        ReQuestPlaySoundNumber := FpCurBreathngMagic.rSoundEvent.rWavNumber + 4;
      end;
      if not FAttribClass.boMan then
        ReQuestPlaySoundNumber := ReQuestPlaySoundNumber + 1;

      FpCurBreathngMagic.rMagicProcessTick := CurTick;

      //         Dec5SecAttrib (FpCurBreathngMagic);
      if not boKeepingMagic(FpCurBreathngMagic) then
      begin
        Result := RET_CLOSE_BREATHNG;
        exit;
      end;
         //2015.10.25 修改屏蔽心法起身判断
//      closeflag := TRUE;
//      if (FpCurBreathngMagic^.rEventDecEnergy < 0) and (FAttribClass.CurAttribData.CurEnergy < (FAttribClass.AttribData.cEnergy + FAttribClass.AttribQuestData.Energy)) then
//        closeflag := FALSE;
//      if (FpCurBreathngMagic^.rEventDecInPower < 0) and (FAttribClass.CurAttribData.CurInPower < (FAttribClass.AttribData.cInPower + FAttribClass.AttribQuestData.InPower)) then
//        closeflag := FALSE;
//      if (FpCurBreathngMagic^.rEventDecOutPower < 0) and (FAttribClass.CurAttribData.CurOutPower < (FAttribClass.AttribData.cOutPower + FAttribClass.AttribQuestData.OutPower)) then
//        closeflag := FALSE;
//      if (FpCurBreathngMagic^.rEventDecMagic < 0) and (FAttribClass.CurAttribData.CurMagic < (FAttribClass.AttribData.cMagic + FAttribClass.AttribQuestData.Magic)) then
//        closeflag := FALSE;
//      if (FpCurBreathngMagic^.rEventDecLife < 0) and (FAttribClass.CurAttribData.CurLife < (FAttribClass.AttribData.cLife + FAttribClass.AttribQuestData.Life)) then
//        closeflag := FALSE;
//      if closeflag then
//      begin
//        Result := RET_CLOSE_BREATHNG;
//        exit;
//      end;

      upflag := true;
      //2009 06 01 修改 心法 只要有1个未满 增加 经验
      //            if (FpCurBreathngMagic^.rEventDecEnergy < 0) and (FAttribClass.CurAttribData.CurEnergy >= FAttribClass.AttribData.cEnergy) then upflag := FALSE;
      //           if (FpCurBreathngMagic^.rEventDecInPower < 0) and (FAttribClass.CurAttribData.CurInPower >= FAttribClass.AttribData.cInPower) then upflag := FALSE;
      //          if (FpCurBreathngMagic^.rEventDecOutPower < 0) and (FAttribClass.CurAttribData.CurOutPower >= FAttribClass.AttribData.cOutPower) then upflag := FALSE;
      //         if (FpCurBreathngMagic^.rEventDecMagic < 0) and (FAttribClass.CurAttribData.CurMagic >= FAttribClass.AttribData.cMagic) then upflag := FALSE;
      //        if (FpCurBreathngMagic^.rEventDecLife < 0) and (FAttribClass.CurAttribData.CurLife >= FAttribClass.AttribData.cLife) then upflag := FALSE;
      DecBreathngAttrib(FpCurBreathngMagic);
      //         DecEventAttrib (FpCurBreathngMagic);
      FSendClass.SendAttribBase(FAttribClass.AttribData, FAttribClass.CurAttribData, FAttribClass.AttribQuestData);
      //
      if FpCurBreathngMagic.rcSkillLevel >= 8500 then
      begin
        if FpCurBreathngMagic.rSEffectNumber > 0 then
          FBasicObject.ShowMagicEffect(FpCurBreathngMagic.rSEffectNumber + 1, lek_none);
      end;
      //2009 06 01 修改 心法 只要有1个未满 增加 经验
      if (upflag = true) and (boAddExp = true) then
      begin
        //心法    增加经验
        oldslevel := FpCurBreathngMagic.rcSkillLevel;
        _AddExp(_aet_Breathng, FpCurBreathngMagic^.rcSkillLevel, FpCurBreathngMagic^.rSkillExp, DEFAULTEXP, FMagicExpMulCount, FpCurBreathngMagic.rMagicExp);
        if oldslevel <> FpCurBreathngMagic^.rcSkillLevel then
        begin
          SendMagicAddExp(FpCurBreathngMagic);
          if (FpCurBreathngMagic^.rcSkillLevel = 9999) then
          begin
            UserList.SendTOPMSG(WinRGB(31, 31, 31), format('%s 恭喜你,%s 修炼值已达到顶点', [FBasicObject.BasicData.Name, FpCurBreathngMagic^.rname]));
           // addEnergyPoint(pCurAttackMagic.rEnergyPoint); //增加 元气点
            SetLifeData;
          end;
          // FSendClass.SendEventString((FpCurBreathngMagic^.rName));
        end;
        //增加 神性
        oldslevel := FAttribClass.AttribData.cGoodChar;
        _AddExp(_aet_none, FAttribClass.AttribData.cGoodChar, FAttribClass.AttribData.GoodChar, FpCurBreathngMagic^.rGoodChar, 0);
        if oldslevel <> FAttribClass.AttribData.cGoodChar then
        begin
          FSendClass.SendAttribValues(FAttribClass.AttribData, FAttribClass.CurAttribData, fAttribClass.AttribQuestData);
        end;
        //魔性
        oldslevel := FAttribClass.AttribData.cBadChar;
        _AddExp(_aet_none, FAttribClass.AttribData.cBadChar, FAttribClass.AttribData.BadChar, FpCurBreathngMagic^.rBadChar, 0);
        if oldslevel <> FAttribClass.AttribData.cBadChar then
        begin
          FSendClass.SendAttribValues(FAttribClass.AttribData, FAttribClass.CurAttribData, FAttribClass.AttribQuestData);
        end;
      end;
    end;
  end;
end;

procedure TItemLog.neaten();
var
  i: integer;
begin
  if FLogData.rsize > (high(FLogData.data) + 1) then
    FLogData.rsize := high(FLogData.data) + 1;
  if FLogData = nil then
    exit;
  for i := 0 to High(FLogData.data) do
  begin
    if (FLogData.data[i].rCount <= 0) or (FLogData.data[i].rName = '') or (i > (FLogData.rsize - 1)) then
      fillchar(FLogData.data[i], sizeof(TItemLogData), 0);
  end;

end;

procedure TItemLog.SetItemLog(tt: pointer);
begin
  FLogData := tt;
  if FLogData.Header.LockPassword <> '' then
    FLogData.Header.boLocked := true
  else
    FLogData.Header.boLocked := false;
  neaten;
end;

constructor TItemLog.Create(aSendClass: TSendClass);
begin
  fSendClass := aSendClass;
  FLogData := nil;
  //    FEnabled := true;
end;

destructor TItemLog.Destroy;
begin

end;

//福袋 当前 几个

function TItemLog.GetCount: Integer;
begin
  if FLogData.rsize > (high(FLogData.data) + 1) then
    FLogData.rsize := high(FLogData.data) + 1;
  result := FLogData.rsize;
end;
//创建 福袋

function TItemLog.CreateRoom: Boolean;
var
  i: integer;
begin
  result := false;
  if FLogData.rsize < (high(FLogData.data) + 1) then
  begin
    for i := FLogData.rsize to high(FLogData.data) do
    begin
      fillchar(FLogData.data[i], sizeof(TItemLogData), 0);
    end;

    FLogData.rsize := FLogData.rsize + 10;
    if FLogData.rsize > (high(FLogData.data) + 1) then
      FLogData.rsize := high(FLogData.data) + 1;
    result := true;
  end;
end;

function TItemLog.isLocked: Boolean;
begin
  Result := FLogData.Header.boLocked;
end;

function TItemLog.SetPassword(aPassword: string): string;
var
  Password: string;
  nCount: integer;
begin
  Result := '';

  Password := Trim(aPassword);
  if (Length(Password) < 4) or (Length(Password) > 8) then
  begin
    Result := '密码请设定4-8位数';
    exit;
  end;
  nCount := GetCount;
  if nCount <= 0 then
  begin
    Result := '此人没有福袋';
    exit;
  end;

  if FLogData.Header.boLocked = true then
  begin
    Result := '福袋密码已设定';
    exit;
  end;

  FLogData.Header.boLocked := true;
  FLogData.Header.LockPassword := Password;

  Result := '福袋密码已设定,请牢记密码';

end;

function TItemLog.ViewItem(akey: integer; aItemData: PTItemData): Boolean;
begin
  FillChar(aItemData^, sizeof(TItemData), 0);
  Result := FALSE;

  if (akey < 0) or (akey > high(FLogData.data)) then
    exit;
  if FLogData.data[akey].rName = '' then
    exit;
  CopyDBItemToItem(FLogData.data[akey], aItemData^);
  Result := TRUE;
end;

procedure TItemLog.affair(atype: TItemLogAffair);
begin
  case atype of
    ilaStart:
      begin
        Move(FLogData^, bakFLogData, SizeOf(TItemLogRecord));
        Faffairtype := ilaStart;
      end;
    ilaConfirm:
      begin
        if Faffairtype <> ilaStart then
          EXIT;
        Faffairtype := ilaConfirm;
      end;
    ilaRoll_back:
      begin
        if Faffairtype <> ilaStart then
          EXIT;
        Move(bakFLogData, FLogData^, SizeOf(TItemLogRecord));
        Faffairtype := ilaRoll_back;
        senditemlogall;
      end;
  end;

end;

procedure TItemLog.senditemlog(akey: integer);
var
  ItemData: tItemData;
begin
  if (akey < 0) or (akey > high(FLogData.data)) then
    exit;
  CopyDBItemToItem(FLogData.data[akey], ItemData);
  FSendClass.SendLogItem(akey, ItemData);
end;

procedure TItemLog.senditemlogall();
var
  i: integer;
begin
  if GetCount > 0 then
    for i := 0 to GetCount - 1 do
    begin
      senditemlog(i);
    end;
end;

function TItemLog.del(akey, acount: integer): boolean;
begin
  result := false;
  if FLogData.rsize <= 0 then
    exit;
  if akey > (FLogData.rsize - 1) then
    exit; //超越拥有空间
  if (akey < 0) or (akey > high(FLogData.data)) then
    exit;
  if FLogData.data[akey].rCount < acount then
    exit;
  FLogData.data[akey].rCount := FLogData.data[akey].rCount - acount;
  if FLogData.data[akey].rCount = 0 then
    fillchar(FLogData.data[akey], sizeof(TItemLogData), 0);

  senditemlog(akey);
end;

function TItemLog.add(akey: integer; aitem: tItemData): boolean;
begin
  result := false;
  if FLogData.rsize <= 0 then
    exit;
  if aitem.rboNotSSamzie = true then
    exit;
  if akey > (FLogData.rsize - 1) then
    exit; //超越拥有空间
  if (akey < 0) or (akey > high(FLogData.data)) then
    exit;
  result := DBItemDataADD(aitem, FLogData.data[akey]);
  senditemlog(akey);
end;

function TItemLog.FreePassword(aPassword: string): string;
var
  Password: string;
  nStartPos, nEndPos, nCount, nPos: Integer;
begin
  Result := '';

  Password := Trim(aPassword);
  if Password = '' then
  begin
    Result := '请输入密码';
    exit;
  end;

  nCount := GetCount;
  if nCount <= 0 then
  begin
    Result := '此人没有保管空间';
    exit;
  end;

  if FLogData.Header.boLocked = false then
  begin
    Result := '还没设定密码';
    exit;
  end;

  if (FLogData.Header.LockPassword) <> aPassword then
  begin
    Result := '密码不正确';
    exit;
  end;

  FLogData.Header.boLocked := false;

  Result := '解除了福袋的密码';

end;
/////////////////////////////////////////////////
//                TLifeDatalist
////////////////////////////////////////////////

constructor TLifeDatalist.Create(aBasicObject: TBasicObject);
begin
  inherited Create;
  FBasicObject := aBasicObject;
end;

destructor TLifeDatalist.Destroy;
begin

  inherited destroy;
end;

function TLifeDatalist.additem(var aitem: titemdata): boolean;
var
  pp: pTLifeDataListdata;
  atemp: TLifeDataListdata;
begin
  result := false;
  if aitem.rKind <> 131 then
    exit;
  atemp.rid := aitem.rSpecialKind;
  atemp.name := aitem.rViewName;
  atemp.LifeData := aitem.rLifeData;
  atemp.rstarttime := mmAnsTick;
  atemp.rendtime := mmAnsTick + aitem.rDateTimeSec * 100;
  pp := get(atemp.rid);
  if pp <> nil then
  begin
    exit;
    //upitem(pp, atemp);
  end
  else
  begin
    add(atemp);

  end;
  result := true;

end;

//2015.11.04新增脚本添加附加属性

function TLifeDatalist.AddScript(aid: Integer; aname: string; aLifeData: TLifeData; atime, asharp, aeffect: Integer; adesc: string): boolean;
var
  pp: pTLifeDataListdata;
  atemp: TLifeDataListdata;
begin
  result := false;
  if (aid < 0) or (aid > 199) then
    exit;
  atemp.rid := 1000 + aid;
  atemp.name := aname;
  atemp.LifeData := aLifeData;
  atemp.rstarttime := mmAnsTick;
  atemp.rendtime := mmAnsTick + atime * 100;
  atemp.rsharp := asharp;
  atemp.reffect := aeffect;
  atemp.rdesc := adesc;
  pp := get(atemp.rid);
  if pp <> nil then
  begin
    upitem(pp, atemp);
  end
  else
  begin
    add(atemp);
  end;
  if FBasicObject <> nil then
    FBasicObject.CallLuaScriptFunction('OnBuffStart', [integer(FBasicObject), aid, aname]);
  result := true;
end;

procedure TLifeDatalist.Update(CurTick: integer);
var
  i: integer;
  pp: pTLifeDataListdata;
  str: string;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    pp := DataList.Items[i];
    if CurTick > pp.rendtime then //状态 结束
    begin
      if FBasicObject <> nil then
      begin
        //FBasicObject.CallLuaScriptFunction('OnBuffEnd', [integer(TUserObject(FBasicObject)), pp.rid, pp.name]);
        str := pp.name;
        FBasicObject.CallLuaScriptFunction('OnBuffEnd', [integer(FBasicObject), pp.rid - 1000, str]);
      end;
      del(pp.rid);
      //FSendClass.SendLeftText(format('%s 状态已过期', [pp.name]), WinRGB(22, 22, 0), mtLeftText3);
    end;
  end;

end;

/////////////////////////////////////////////////
//                TLifeDataBasic
////////////////////////////////////////////////

constructor TLifeDataBASIC.Create;
begin
  DataList := TList.Create;
end;

procedure TLifeDataBASIC.setLifeData;
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  FillChar(LifeData, SizeOf(TLifeData), 0);
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    GatherLifeData(LifeData, pp.LifeData);
  end;
  rboupdate := true;

  if assigned(FonLifedataUPdate) then
    FonLifedataUPdate;
end;

function TLifeDataBASIC.del(aid: integer): boolean;
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  result := false;
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    if pp.rid = aid then
    begin
      if assigned(Fondel) then
        Fondel(pp^);
      dispose(pp);
      DataList.Delete(i);
      setLifeData;
      result := true;
      exit;
    end;
  end;
  updatetext;
end;

function TLifeDataBASIC.get(aid: integer): pTLifeDataListdata;
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    if pp.rid = aid then
    begin
      result := pp;
      exit;
    end;
  end;

end;

procedure TLifeDataBASIC.upitem(pp: pTLifeDataListdata; var aitem: TLifeDataListdata);
begin
  pp^ := aitem;
  setLifeData;
  if assigned(FonUPdate) then
    FonUPdate(pp^);
end;

procedure TLifeDataBASIC.updatetext();
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  ftext := '';
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    ftext := ftext + ' ' + pp.name;
  end;

end;

function TLifeDataBASIC.getcount: integer;
begin
  Result := DataList.Count;
end;

function TLifeDataBASIC.add(var aitem: TLifeDataListdata): boolean;
var
  pp: pTLifeDataListdata;
begin
  result := false;
  if get(aitem.rid) <> nil then
    exit;
  new(pp);
  pp^ := aitem;
  DataList.Add(pp);
  setLifeData;
  if assigned(Fonadd) then
    Fonadd(pp^);
  result := true;
  updatetext;
end;

procedure TLifeDataBASIC.Clear();
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    dispose(pp);
  end;
  DataList.Clear;
  if assigned(FonClear) then
    FonClear();
  updatetext;
  setLifeData;
end;

destructor TLifeDataBASIC.Destroy;
begin
  Clear;
  DataList.Free;
  inherited destroy;
end;

{ TDeleteMagicClass }

constructor TDeleteMagicClass.Create();
var
  astr: string;
begin
  FfileName := '.\MagicData\' + GetCurDate + '.SDB';
  FfileStream := nil;
  if not DirectoryExists('.\MagicData\') then
  begin
    CreateDir('.\MagicData\');
  end;
  if FileExists(Ffilename) = false then
  begin
    FfileStream := TFileStream.Create(Ffilename, fmCreate);
    astr := 'TimeDate,CharName,MagicName,MagicExp,MagicLevel,' + #13#10;

    FfileStream.Write(astr[1], length(astr));
    FfileStream.Free;
    FfileStream := nil;
  end;

  FfileStream := TFileStream.Create(Ffilename, fmOpenReadWrite or fmShareDenyNone);
  FfileStream.Seek(0, soFromEnd);
end;

destructor TDeleteMagicClass.Destroy;
begin
  if FfileStream <> nil then
    FfileStream.Free;
  inherited Destroy;
end;

function TDeleteMagicClass.GetCurDate: string;
var
  nYear, nMonth, nDay: Word;
  sDate: string;
begin
  Result := '';
  try
    DecodeDate(Date, nYear, nMonth, nDay);
    sDate := IntToStr(nYear);
    if nMonth < 10 then
      sDate := sDate + '0';
    sDate := sDate + IntToStr(nMonth);
    if nDay < 10 then
      sDate := sDate + '0';
    sDate := sDate + IntToStr(nDay);
  except
  end;
  Result := sDate;
end;

procedure TDeleteMagicClass.Write(astr: string);
begin
  if FfileStream = nil then
    exit;
  //  astr := DateToStr(Date) + TimeToStr(Time) + ',' + astr + #13#10;
  astr := DateTimeToStr(now) + ',' + astr + #13#10;
  FfileStream.Write(astr[1], length(astr));
end;

{ TBoothData }

procedure TBoothDataClass.clear;
begin
  state := false;
  fillchar(FBoothBuyArr[0], (high(FBoothBuyArr) + 1) * sizeof(TBoothShopData), 0);
  fillchar(FBoothSellArr[0], (high(FBoothSellArr) + 1) * sizeof(TBoothShopData), 0);
  fillchar(FBoothBuyArr_bak[0], (high(FBoothBuyArr_bak) + 1) * sizeof(TBoothShopData), 0);
  fillchar(FBoothSellArr_bak[0], (high(FBoothSellArr_bak) + 1) * sizeof(TBoothShopData), 0);

end;

constructor TBoothDataClass.Create(aSendClass: TSendClass; aHaveItemClass: THaveItemClass);
begin
  FSendClass := aSendClass;
  FHaveItemClass := aHaveItemClass;
  clear;
  boothshape := 0;
end;

destructor TBoothDataClass.Destroy;
begin

  inherited;
end;

function TBoothDataClass.BuyAdd(akey: integer; var aitem: TBoothShopData): boolean;
begin
  result := false;
  if (akey < 0) or (akey > HIGH(FBoothBuyArr)) then
    exit;

  FBoothBuyArr[akey] := aitem;
  result := true;
end;

function TBoothDataClass.BuyDel(akey, acount: integer; aUserSendclass: TSendClass): boolean;
begin
  result := false;
  if acount <= 0 then
    exit;
  if (akey < 0) or (akey > HIGH(FBoothBuyArr)) then
    exit;
  if FBoothBuyArr[akey].rstate = false then
    exit;
  FBoothBuyArr[akey].rCount := FBoothBuyArr[akey].rCount - acount;
  if FBoothBuyArr[akey].rCount <= 0 then
  begin
    FBoothBuyArr[akey].rCount := 0;
    FBoothBuyArr[akey].rstate := false;
    FSendClass.SendBooth_edit_item_del(bt_buy, akey);
    if aUserSendclass <> nil then
      aUserSendclass.SendBooth_user_item_del(bt_buy, akey);
  end
  else
  begin
    FSendClass.SendBooth_edit_item_upCount(bt_buy, akey, FBoothBuyArr[akey].rCount);
    if aUserSendclass <> nil then
      aUserSendclass.SendBooth_user_item_upCount(bt_buy, akey, FBoothBuyArr[akey].rCount);
  end;

  result := true;

end;

function TBoothDataClass.BuyGet(akey: integer): PTBoothShopData;
begin
  result := nil;
  if (akey < 0) or (akey > HIGH(FBoothBuyArr)) then
    exit;
  if FBoothBuyArr[akey].rstate = false then
    exit;
  result := @FBoothBuyArr[akey];
end;

function TBoothDataClass.SellAdd(akey: integer; var aitem: TBoothShopData): boolean;
begin
  result := false;
  if (akey < 0) or (akey > HIGH(FBoothSellArr)) then
    exit;

  FBoothSellArr[akey] := aitem;
  result := true;
end;

function TBoothDataClass.SellDel(akey, acount: integer; aUserSendclass: TSendClass): boolean;
begin
  result := false;
  if acount <= 0 then
    exit;
  if (akey < 0) or (akey > HIGH(FBoothSellArr)) then
    exit;
  if FBoothSellArr[akey].rstate = false then
    exit;
  FBoothSellArr[akey].rCount := FBoothSellArr[akey].rCount - acount;
  if FBoothSellArr[akey].rCount <= 0 then
  begin
    FBoothSellArr[akey].rCount := 0;
    FBoothSellArr[akey].rstate := false;
    FSendClass.SendBooth_edit_item_del(bt_sell, akey);
    if aUserSendclass <> nil then
      aUserSendclass.SendBooth_user_item_del(bt_sell, akey);
  end
  else
  begin
    FSendClass.SendBooth_edit_item_upCount(bt_sell, akey, FBoothSellArr[akey].rCount);
    if aUserSendclass <> nil then
      aUserSendclass.SendBooth_user_item_upCount(bt_sell, akey, FBoothSellArr[akey].rCount);
  end;

  result := true;

end;

function TBoothDataClass.SellGet(akey: integer): PTBoothShopData;
begin
  result := nil;
  if (akey < 0) or (akey > HIGH(FBoothSellArr)) then
    exit;
  if FBoothSellArr[akey].rstate = false then
    exit;
  result := @FBoothSellArr[akey];
end;

//检查买列表 卖列表 买卖列表中是否出现重复使用情况

function TBoothDataClass.checkHaveItemKey(): boolean;
var
  i, j: integer;
begin
  Result := false;
  //检查卖列表
  for i := 0 to high(FBoothSellArr) do
  begin
    if FBoothSellArr[i].rstate = false then
      Continue;
    for j := i + 1 to high(FBoothSellArr) do
    begin
      if FBoothSellArr[j].rstate = false then
        Continue;
      if FBoothSellArr[j].rHaveItemKey = FBoothSellArr[i].rHaveItemKey then
        exit;
    end;
  end;
  //检查买列表
  for i := 0 to high(FBoothBuyArr) do
  begin
    if FBoothBuyArr[i].rstate = false then
      Continue;
    for j := i + 1 to high(FBoothBuyArr) do
    begin
      if FBoothBuyArr[j].rstate = false then
        Continue;
      if FBoothBuyArr[j].rHaveItemKey = FBoothBuyArr[i].rHaveItemKey then
        exit;
    end;
  end;
  //////////////////////////////////////////////////////
  for i := 0 to high(FBoothSellArr) do
  begin
    if FBoothSellArr[i].rstate = false then
      Continue;
    for j := 0 to high(FBoothBuyArr) do
    begin
      if FBoothBuyArr[j].rstate = false then
        Continue;
      if FBoothBuyArr[j].rHaveItemKey = FBoothSellArr[i].rHaveItemKey then
        exit;
    end;
  end;

  Result := true;
end;

function TBoothDataClass.check(out astr: string): boolean;
var
  i, j: integer;
  ItemData_gold, ItemData: TItemData;
  fAllMoney: integer;
  aUseCount: integer;
begin
  astr := '';
  aUseCount := 0;
  fAllMoney := 0;
  result := false;
  //购买的物品检查
  for i := 0 to High(FBoothBuyArr) do
  begin
    if FBoothBuyArr[i].rstate = false then
      Continue;
    //(1)检查key 数量  价钱
    if (FBoothBuyArr[i].rHaveItemKey < 0) or (FBoothBuyArr[i].rHaveItemKey > 29) then
    begin
      astr := '背包中没有' + IntToStr(FBoothBuyArr[i].rHaveItemKey) + '号位置';
      exit;
    end;

    if FBoothBuyArr[i].rPrice < 1 then
    begin
      astr := '物品单价不能小于1';
      exit;
    end;
    if FBoothBuyArr[i].rCount < 1 then
    begin
      astr := '数量不能小于1';
      exit;
    end;
    //(2)检查物品是否存在
    if FHaveItemClass.ViewItem(FBoothBuyArr[i].rHaveItemKey, @ItemData) = false then
    begin
      astr := '没有' + ItemData.rViewName;
      exit;
    end;
    //(3)检查物品是否重复使用
    if checkHaveItemKey = false then
    begin
      astr := ItemData.rViewName + '已在列表中使用,不能重复使用!';
      exit;
    end;
    //（4）检查物品 是否有限制
    if FHaveItemClass.LockedPass then
    begin
      astr := '有密码设定,无法收购';
      exit;
    end;
    if ItemData.rlockState <> 0 then
    begin
      astr := ItemData.rViewName + '锁定中,无法收购!';
      exit;
    end;
    if (ItemData.rKind = ITEM_KIND_CANTMOVE) or (ItemData.rboNotExchange) or (ItemData.rboNotTrade) then
    begin
      astr := ItemData.rViewName + '无法收购!';
      exit;
    end;
    //(5)检查钱币
    if FHaveItemClass.ViewItemName('钱币', @ItemData_gold) = false then
    begin
      astr := '没有钱币,无法收购物品!';
      exit;
    end;
    fAllMoney := fAllMoney + FBoothBuyArr[i].rCount * FBoothBuyArr[i].rPrice;
    if fAllMoney > ItemData_gold.rCount then
    begin
      astr := '收购的总价钱大于你所拥有的钱币!';
      exit;
    end;
  end;
  //出售的物品检查
  for j := 0 to High(FBoothSellArr) do
  begin
    //(1)检查key 数量  价钱
    if FBoothSellArr[j].rstate = false then
      Continue;

    if (FBoothSellArr[j].rHaveItemKey < 0) or (FBoothSellArr[j].rHaveItemKey > 29) then
    begin
      astr := '背包中没有' + IntToStr(FBoothSellArr[j].rHaveItemKey) + '号位置';
      exit;
    end;
    if FBoothSellArr[j].rPrice < 0 then
    begin
      astr := '价钱不能小于0';
      exit;
    end;
    if FBoothSellArr[j].rCount < 0 then
    begin
      astr := '数量不能小于0';
      exit;
    end;
    //(2)检查物品是否存在  是否小于出售的数量
    if FHaveItemClass.ViewItem(FBoothSellArr[j].rHaveItemKey, @ItemData) = false then
    begin
      astr := '没有' + ItemData.rViewName;
      exit;
    end;
    if checkHaveItemKey() = false then
    begin
      astr := ItemData.rName + '已在列表中使用,不能重复使用!';
      exit;
    end;
    //(3)物品的数量不能小于1
    if ItemData.rCount < 1 then
    begin
      astr := '没有' + ItemData.rViewName;
      exit;
    end;
    //(4)检查物品的数量
    if ItemData.rCount < FBoothSellArr[j].rCount then
    begin
      astr := ItemData.rViewName + '数量不足';
      exit;
    end;

    //（5）检查物品 是否有限制
    if FHaveItemClass.LockedPass then
    begin
      astr := '有密码设定,无法出售';
      exit;
    end;
    if ItemData.rlockState <> 0 then
    begin
      astr := ItemData.rViewName + '锁定中,无法出售';
      exit;
    end;
    if (ItemData.rKind = ITEM_KIND_CANTMOVE) or (ItemData.rboNotExchange) or (ItemData.rboNotTrade) then
    begin
      astr := ItemData.rViewName + '无法出售';
      exit;
    end;
  end;
  result := true;
end;

procedure TBoothDataClass.affair(atype: THaveItemClassAffair);
var
  i: integer;
begin
  case atype of
    hicaStart:
      begin
        Move(FBoothBuyArr, FBoothBuyArr_bak, SizeOf(FBoothBuyArr));
        Move(FBoothSellArr, FBoothSellArr_bak, SizeOf(FBoothSellArr));
        Faffair := atype;
      end;
    hicaConfirm:
      begin
        Faffair := hicaConfirm;
      end;
    hicaRoll_back:
      begin
        if Faffair <> hicaStart then
          exit;
        Move(FBoothBuyArr_bak, FBoothBuyArr, SizeOf(FBoothBuyArr));
        Move(FBoothSellArr_bak, FBoothSellArr, SizeOf(FBoothSellArr));
        sendall;
        Faffair := atype;
      end;
  end;

end;
//发给自己

procedure TBoothDataClass.sendall;
var
  i: integer;
begin
  for i := 0 to High(FBoothBuyArr) do
  begin
    FSendClass.SendBooth_edit_item(bt_buy, i, FBoothBuyArr[i]);
  end;
  for i := 0 to High(FBoothSellArr) do
  begin
    FSendClass.SendBooth_edit_item(bt_sell, i, FBoothSellArr[i]);
  end;
end;
//发送给 顾客

procedure TBoothDataClass.send_userall(asendclass: TSendClass);
var
  i: integer;
  aitem: titemdata;
begin
  for i := 0 to High(FBoothBuyArr) do
  begin
    fillchar(aitem, sizeof(aitem), 0);
    if FBoothBuyArr[i].rstate then
      FHaveItemClass.ViewItem(FBoothBuyArr[i].rHaveItemKey, @aitem);
    asendclass.SendBooth_user_item(bt_buy, i, FBoothBuyArr[i], aitem);
  end;
  for i := 0 to High(FBoothSellArr) do
  begin
    fillchar(aitem, sizeof(aitem), 0);
    if FBoothSellArr[i].rstate then
      FHaveItemClass.ViewItem(FBoothSellArr[i].rHaveItemKey, @aitem);
    asendclass.SendBooth_user_item(bt_sell, i, FBoothSellArr[i], aitem);
  end;
end;

{ TDesignation }

constructor TDesignationClass.Create(aBasicObject: TBasicObject; aSendClass: TSendClass);
begin
  boSend := false;
  fillchar(LifeData, sizeof(LifeData), 0);
  fillchar(DesignationData, sizeof(DesignationData), 0);
  FSendClass := aSendClass;
  FBasicObject := aBasicObject;
end;

destructor TDesignationClass.Destroy;
begin

  inherited;
end;

procedure TDesignationClass.sendMenu();
begin
  FSendClass.SendDesignation_Menu(getMenu);
end;

procedure TDesignationClass.LoadFromSdb(aCharData: PTDBRecord);
var
  i: integer;
begin
  DesignationData.rcurid := aCharData.DesignationCurID;
  move(aCharData.DesignationArr, DesignationData.rIdArr, sizeof(aCharData.DesignationArr));
  for i := 0 to high(DesignationData.rIdArr) do
  begin
    onUpdate(i);
  end;
  UserID(DesignationData.rcurid);

end;

procedure TDesignationClass.SaveToSdb(aCharData: PTDBRecord);
begin
  aCharData.DesignationCurID := DesignationData.rcurid;
  move(DesignationData.rIdArr, aCharData.DesignationArr, sizeof(aCharData.DesignationArr));
end;

function TDesignationClass.add(aid: integer): boolean;
var
  i: integer;
begin
  result := false;
  if IsCheck(aid) then
    exit;

  for i := 0 to high(DesignationData.rIdArr) do
  begin
    if DesignationData.rIdArr[i] = 0 then
    begin
      DesignationData.rIdArr[i] := aid;
      result := true;
      onUpdate(i);
      exit;
    end;
  end;
end;

function TDesignationClass.del(aid: integer): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to high(DesignationData.rIdArr) do
  begin
    if DesignationData.rIdArr[i] = aid then
    begin
      if DesignationData.rNameArr[i] = DesignationData.rname then
        exit;
      DesignationData.rIdArr[i] := 0;
      result := true;
      onUpdate(i);
      exit;
    end;
  end;
end;

function TDesignationClass.delName(aname: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to high(DesignationData.rNameArr) do
  begin
    if DesignationData.rNameArr[i] = aname then
    begin
      if DesignationData.rNameArr[i] = DesignationData.rname then
        exit;
      DesignationData.rIdArr[i] := 0;
      result := true;
      onUpdate(i);
      exit;
    end;
  end;
end;

function TDesignationClass.getName(aid: integer): string;
var
  i: integer;
begin
  result := '';
  if aid <= 0 then
    exit;
  for i := 0 to high(DesignationData.rIdArr) do
  begin
    if DesignationData.rIdArr[i] = aid then
    begin
      result := DesignationData.rNameArr[i];
      exit;
    end;
  end;
end;

function TDesignationClass.User(aname: string): boolean;
begin
  result := UserID(getId(aname));
end;

procedure TDesignationClass.onUpdate(aindex: integer);
var
  str: string;
  aitem: TItemLifeData;
begin
  if (aindex < 0) or (aindex > high(DesignationData.rIdArr)) then
    exit;
  if (DesignationData.rIdArr[aindex] <= 0) then
  begin
    DesignationData.rIdArr[aindex] := 0;
    DesignationData.rNameArr[aindex] := '';
  end;

  if DesignationData.rIdArr[aindex] > 0 then
  begin
    str := format('X称号%d', [DesignationData.rIdArr[aindex]]);
    if ItemLifeDataClass.GetItemData(str, aitem) = false then
    begin
      DesignationData.rIdArr[aindex] := 0;
      DesignationData.rNameArr[aindex] := '';

      exit;
    end;
    DesignationData.rNameArr[aindex] := aitem.ViewName;
  end;
  boSend := true;
end;

function TDesignationClass.UserID(aid: integer): boolean;
var
  str: string;
  aitem: TItemLifeData;
begin
  result := false;

  str := format('X称号%d', [aid]);
  if ItemLifeDataClass.GetItemData(str, aitem) then
  begin
    DesignationData.rname := aitem.ViewName;
    DesignationData.rcurid := aid;
    LifeData := aitem.LifeData;
  end
  else
  begin
    DesignationData.rname := '';
    DesignationData.rcurid := 0;
    fillchar(LifeData, sizeof(LifeData), 0);
  end;
  FSendClass.SendDesignation_User(DesignationData.rname);
  TUserObject(FBasicObject).SetLifeData;
  result := true;
end;

function TDesignationClass.getId(aname: string): integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to high(DesignationData.rNameArr) do
  begin
    if DesignationData.rNameArr[i] = aname then
    begin
      result := DesignationData.rIdArr[i];
      exit;
    end;
  end;
end;

procedure TDesignationClass.Update(CurTick: integer);
begin
  if boSend then
    sendMenu;
  boSend := false;
end;

function TDesignationClass.getMenu: string;
var
  i: integer;
begin
  result := '';
  for i := 0 to high(DesignationData.rNameArr) do
  begin
    if DesignationData.rNameArr[i] <> '' then
    begin
      result := result + DesignationData.rNameArr[i] + #13#10;
    end;
  end;
end;

function TDesignationClass.IsCheck(aid: integer): boolean;
var
  i: integer;
begin
  result := false;
  if aid <= 0 then
    exit;
  for i := 0 to high(DesignationData.rIdArr) do
  begin
    if DesignationData.rIdArr[i] = aid then
    begin
      result := true;
      exit;
    end;
  end;
end;

function TDesignationClass.SpaceCount: integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to high(DesignationData.rIdArr) do
  begin
    if DesignationData.rIdArr[i] = 0 then
    begin
      inc(result);
    end;
  end;
end;
{ THaveItemQuestClass }

function THaveItemQuestClass.Add(aItemData: PTItemData): Boolean;
var
  I: INTEGER;
  P: PTItemData;
begin
  result := false;

  if aItemData.rKind <> ITEM_KIND_QUEST then
    exit;
  if aItemData.rCount <= 0 then
    exit;

  //前提物品
  if aItemData.rNeedItem <> '' then
  begin
    p := get(aItemData.rNeedItem);
    if p = nil then
      exit; //结束
    if p.rCount < aItemData.rNeedItemCount then
    begin
      result := true;
      exit; //结束
    end;
  end;
  {//不能拥有物品
      for i := 0 to high(aItemData.rNotHaveItemArr) do
      begin
          if aItemData.rNotHaveItemArr[i] = '' then Break;                        //结束
          p := get(aItemData.rNotHaveItemArr[i]);
          if p = nil then Continue;
          if p.rCount >= aItemData.rNotHaveItemCountArr[i] then exit;             //静止拥有
      end;}

  //删除 指定物品
  if aItemData.rDelItem <> '' then
  begin
    del(aItemData.rDelItem, aItemData.rDelItemCount);
  end;

  //增加 替代品进入背包
  if aItemData.rAddItem <> '' then
  begin
    i := aItemData.rAddItemCount;
    if ItemClass.GetItemData(aItemData.rAddItem, aItemData^) = false then
    begin
      result := true;
      FSendClass.SendLeftText(aItemData.rViewName + '物品无效', WinRGB(22, 22, 0), mtLeftText3);
      exit;
    end;
    aItemData.rAddItemCount := i;
  end;

  //正式增加
      //追加
  for I := 0 to HIGH(FItemArr) do
  begin
    if FItemArr[I].rName = aItemData.rName then
    begin
      FItemArr[I].rCount := FItemArr[I].rCount + aItemData.rCount;
      FSendClass.SendLeftText(aItemData.rViewName + ' ' + inttostr(FItemArr[I].rCount) + ' 需要' + inttostr(FItemArr[I].rMaxCount), WinRGB(22, 22, 0), mtLeftText3); //20130619修改，任务品提示
      if FItemArr[I].rMaxCount > 0 then
        if FItemArr[I].rCount > FItemArr[I].rMaxCount then
        begin
          FItemArr[I].rCount := FItemArr[I].rMaxCount;
          FSendClass.SendLeftText(FItemArr[i].rViewName + '数量达到最大', WinRGB(22, 22, 0), mtLeftText3);
        end;
      if FItemArr[I].rCount < 0 then
        FItemArr[I].rCount := 1;
      FSendClass.SendHaveItemQuest(i, FItemArr[I]);
      exit;
    end;
  end;
  //新增加
  for I := 0 to HIGH(FItemArr) do
  begin
    if FItemArr[I].rName = '' then
    begin
      FItemArr[I] := aItemData^;
      if FItemArr[I].rMaxCount > 0 then
        if FItemArr[I].rCount > FItemArr[I].rMaxCount then
        begin
          FItemArr[I].rCount := FItemArr[I].rMaxCount;
          FSendClass.SendLeftText(FItemArr[i].rViewName + '数量达到最大', WinRGB(22, 22, 0), mtLeftText3);
        end;
      if FItemArr[I].rCount < 0 then
        FItemArr[I].rCount := 1;
      FSendClass.SendHaveItemQuest(i, FItemArr[I]);
      exit;
    end;
  end;
  result := true;
end;

procedure THaveItemQuestClass.clear;
begin
  fillchar(FItemArr, sizeof(FItemArr), 0);
end;

constructor THaveItemQuestClass.Create(aSendClass: TSendClass; aAttribClass: TAttribClass);
begin
  FSendClass := aSendClass;
  FAttribClass := aAttribClass;
  clear;
end;

function THaveItemQuestClass.SpaceCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to high(FItemArr) do
  begin
    if FItemArr[i].rName = '' then
      Result := Result + 1;
  end;
end;

procedure THaveItemQuestClass.delQuestId(aQusetID: integer);
var
  I: INTEGER;
begin
  for I := 0 to HIGH(FItemArr) do
  begin
    if FItemArr[I].rName <> '' then
    begin
      if FItemArr[I].rQuestNum = aQusetID then
      begin
        FItemArr[I].rCount := 0;
        FItemArr[I].rName := '';
        FItemArr[I].rViewName := '';
        FSendClass.SendHaveItemQuest(i, FItemArr[I]);
      end;
    end;
  end;
end;

procedure THaveItemQuestClass.del(aname: string; acount: integer);
var
  I: INTEGER;
begin
  for I := 0 to HIGH(FItemArr) do
  begin
    if FItemArr[I].rName = aname then
    begin
      FItemArr[I].rCount := FItemArr[I].rCount - acount;
      if FItemArr[I].rCount <= 0 then
      begin
        FItemArr[I].rCount := 0;
        FItemArr[I].rName := '';
      end;
      FSendClass.SendHaveItemQuest(i, FItemArr[I]);
    end;
  end;
end;

destructor THaveItemQuestClass.Destroy;
begin

  inherited;
end;

function THaveItemQuestClass.get(aname: string): PTItemData;
var
  I: INTEGER;
begin
  result := nil;
  for I := 0 to HIGH(FItemArr) do
  begin
    if FItemArr[I].rName = aname then
    begin
      result := @FItemArr[I];
    end;
  end;
end;

procedure THaveItemQuestClass.LoadFromSdb(aCharData: PTDBRecord);
var
  I: INTEGER;
  tempitem: titemdata;
begin
  for I := 0 to HIGH(FItemArr) do
  begin
    if ItemClass.GetItemData(aCharData.HaveItemQuestArr[i].rName, tempitem) = false then
      Continue;
    if tempitem.rKind <> ITEM_KIND_QUEST then
      Continue;
    FItemArr[i] := tempitem;
    FItemArr[I].rCount := aCharData.HaveItemQuestArr[i].rCount;
    FSendClass.SendHaveItemQuest(i, FItemArr[I]);
  end;
end;

procedure THaveItemQuestClass.SaveToSdb(aCharData: PTDBRecord);
var
  I: INTEGER;
begin
  for I := 0 to HIGH(FItemArr) do
  begin
    aCharData.HaveItemQuestArr[i].rName := FItemArr[I].rName;
    aCharData.HaveItemQuestArr[i].rCount := FItemArr[I].rCount;
  end;
end;

function THaveMagicClass.Mystery_ChangeMagic(asour, adest: integer): Boolean;
var
  MagicData: TMagicData;
begin
  Result := FALSE;
  if (asour < 0) or (asour > xHAVEMAGICSIZE - 1) then
    exit;
  if (adest < 0) or (adest > xHAVEMAGICSIZE - 1) then
    exit;

  if FpCurAttackMagic = @HaveMysteryMagicArr[asour] then
    exit;
  if FpCurBreathngMagic = @HaveMysteryMagicArr[asour] then
    exit;
  if FpCurRunningMagic = @HaveMysteryMagicArr[asour] then
    exit;
  if FpCurProtectingMagic = @HaveMysteryMagicArr[asour] then
    exit;
  if FpCurEctMagic = @HaveMysteryMagicArr[asour] then
    exit;

  if FpCurAttackMagic = @HaveMysteryMagicArr[adest] then
    exit;
  if FpCurBreathngMagic = @HaveMysteryMagicArr[adest] then
    exit;
  if FpCurRunningMagic = @HaveMysteryMagicArr[adest] then
    exit;
  if FpCurProtectingMagic = @HaveMysteryMagicArr[adest] then
    exit;
  if FpCurEctMagic = @HaveMysteryMagicArr[adest] then
    exit;

  MagicData := HaveMysteryMagicArr[asour];
  HaveMysteryMagicArr[asour] := HaveMysteryMagicArr[adest];
  HaveMysteryMagicArr[adest] := MagicData;

  FSendClass.SendHaveMagic(smt_HaveMysteryMagic, asour, HaveMysteryMagicArr[asour]);
  FSendClass.SendHaveMagic(smt_HaveMysteryMagic, adest, HaveMysteryMagicArr[adest]);
  Result := TRUE;
end;

function THaveMagicClass.Mystery_GetMagicIndex(aMagicName: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to high(HaveMysteryMagicArr) do
  begin
    if (HaveMysteryMagicArr[i].rName) = aMagicName then
    begin
      Result := i;
      exit;
    end;
  end;
end;

function THaveMagicClass.Mystery_GetMagicSkillLevel(aMagicName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to high(HaveMysteryMagicArr) do
  begin
    if (HaveMysteryMagicArr[i].rName) = aMagicName then
    begin
      Result := HaveMysteryMagicArr[i].rcSkillLevel;
      exit;
    end;
  end;
end;

function THaveMagicClass.Mystery_MagicSpaceCount: integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to high(HaveMysteryMagicArr) do
  begin
    if (HaveMysteryMagicArr[i].rName) = '' then
    begin
      Result := Result + 1;
    end;
  end;

end;

function THaveMagicClass.Mystery_PreSelectHaveMagic(akey, aper: integer; var RetStr: string): Boolean;
begin
  Result := false;
  RetStr := '';
  if (akey < 0) or (akey > high(HaveMysteryMagicArr)) then
    exit;
  if HaveMysteryMagicArr[akey].rName = '' then
    exit;

  case HaveMysteryMagicArr[akey].rMagicType of
    MAGIC_Mystery_TYPE:
      begin
        if aper <= 10 then
        begin
          RetStr := '因头的活力不足，所以选择武功失败.';
          exit;
        end;
      end;
  else
    begin
      RetStr := '无法识别的武功.';
      exit;
    end;
  end;
  Result := true;
end;

function THaveMagicClass.Mystery_SelectHaveMagic(akey, aper: integer; var RetStr: string): integer;
begin
  RetStr := '';
  Result := SELECTMAGIC_RESULT_FALSE;
  if akey < 0 then
    exit;
  if akey > high(HaveMysteryMagicArr) then
    exit;
  if HaveMysteryMagicArr[akey].rName = '' then
    exit;

  case HaveMysteryMagicArr[akey].rMagicType of
    MAGIC_Mystery_TYPE:
      begin
        if HaveItemType <> 0 then
          exit;
        RetStr := '因头的活力不足，所以选择武功失败.';
        case aper of
          0..10:
            exit;
        else
          RetStr := '';
        end;
      end;
  else
    begin
      RetStr := '无法识别的武功.';
      exit;
    end;

  end;

  Result := SELECTMAGIC_RESULT_NONE;
  case HaveMysteryMagicArr[akey].rMagicType of
    //攻击类型
    MAGIC_Mystery_TYPE:
      begin
        setAttackMagic(@HaveMysteryMagicArr[akey]);
        //要求等级9999，才能挂辅助武功
        if (FpCurEctMagic <> nil) and (FpCurAttackMagic^.rcSkillLevel < 9999) then
          SetEctMagic(nil);
      end;
  end;
  SetLifeData;
end;

function THaveMagicClass.Mystery_ViewMagic(akey: integer; aMagicData: PTMagicData): Boolean;
begin
  Result := FALSE;
  if (akey < 0) or (akey > high(HaveMysteryMagicArr)) then
    exit;
  if HaveMysteryMagicArr[akey].rName = '' then
    exit;
  Move(HaveMysteryMagicArr[akey], aMagicData^, SizeOf(TMagicData));
  Result := TRUE;
end;

function THaveMagicClass.Rise_DeleteMagic(akey: integer): Boolean;
var
  aid: integer;
begin
  Result := FALSE;
  if (akey < 0) or (akey > high(HaveRiseMagicArr)) then
    exit;
  if FpCurAttackMagic = @HaveRiseMagicArr[akey] then
    exit;
  if FpCurBreathngMagic = @HaveRiseMagicArr[akey] then
    exit;
  if FpCurRunningMagic = @HaveRiseMagicArr[akey] then
    exit;
  if FpCurProtectingMagic = @HaveRiseMagicArr[akey] then
    exit;
  if FpCurEctMagic = @HaveRiseMagicArr[akey] then
    exit;

  DelMagic.Write(format('%s,%s,%d,%d,', [FBasicObject.BasicData.Name, HaveRiseMagicArr[akey].rname, HaveRiseMagicArr[akey].rSkillExp, HaveRiseMagicArr[akey].rcSkillLevel]));

  aid := HaveMagicArr[akey].rID;
  FillChar(HaveRiseMagicArr[akey], sizeof(TMagicData), 0);
  HaveMagicArr[akey].rID := aid;

  FSendClass.SendHaveMagic(smt_HaveRiseMagic, akey, HaveRiseMagicArr[akey]);
  SetLifeData;
  Result := TRUE;
end;

function THaveMagicClass.Mystery_DeleteMagic(akey: integer): Boolean;
var
  aid: integer;
begin
  Result := FALSE;
  if (akey < 0) or (akey > high(HaveMysteryMagicArr)) then
    exit;
  if FpCurAttackMagic = @HaveMysteryMagicArr[akey] then
    exit;
  if FpCurBreathngMagic = @HaveMysteryMagicArr[akey] then
    exit;
  if FpCurRunningMagic = @HaveMysteryMagicArr[akey] then
    exit;
  if FpCurProtectingMagic = @HaveMysteryMagicArr[akey] then
    exit;
  if FpCurEctMagic = @HaveMysteryMagicArr[akey] then
    exit;

  DelMagic.Write(format('%s,%s,%d,%d,', [FBasicObject.BasicData.Name, HaveMysteryMagicArr[akey].rname, HaveMysteryMagicArr[akey].rSkillExp, HaveMysteryMagicArr[akey].rcSkillLevel]));

  aid := HaveMagicArr[akey].rID;
  FillChar(HaveMysteryMagicArr[akey], sizeof(TMagicData), 0);
  HaveMagicArr[akey].rID := aid;

  FSendClass.SendHaveMagic(smt_HaveMysteryMagic, akey, HaveMysteryMagicArr[akey]);
  SetLifeData;
  Result := TRUE;
end;

function TAttribClass.getGuildPoint: Integer;
begin
  Result := AttribData.guildPoint;
end;

procedure TAttribClass.setGuildPoint(const Value: Integer);
begin
  AttribData.guildPoint := Value;
end;

function TAttribClass.getGuildName: TNameString;
begin
  Result := AttribData.guildName;
end;

procedure TAttribClass.setGuildName(const Value: TNameString);
begin
  AttribData.guildName := Value;
end;

//VIP等级

function TAttribClass.getVipUseLevel: byte;
begin
  Result := AttribData.VipUseLevel;
end;

procedure TAttribClass.setVipUseLevel(const Value: byte);
begin
  AttribData.VipUseLevel := Value;
end;

//强化祝福值

function TAttribClass.getAddableStatePoint: byte;
begin
  Result := AttribData.AddableStatePoint;
end;

procedure TAttribClass.setAddableStatePoint(const Value: byte);
begin
  AttribData.AddableStatePoint := Value;
end;

//VIP时间

function TAttribClass.getVipUseTime: Tdatetime;
begin
  Result := AttribData.VipUseTime;
end;

procedure TAttribClass.setVipUseTime(const Value: Tdatetime);
begin
  AttribData.VipUseTime := Value;
end;

//双倍 倍数

function TAttribClass.getMagicExpMulCount: byte;
begin
  Result := AttribData.MagicExpMulCount;
end;

procedure TAttribClass.setMagicExpMulCount(const Value: byte);
begin
  AttribData.MagicExpMulCount := Value;
end;
//双倍 时间

function TAttribClass.getMagicExpMulEndTime: Integer;
begin
  Result := AttribData.MagicExpMulEndTime;
end;

procedure TAttribClass.setMagicExpMulEndTime(const Value: Integer);
begin
  AttribData.MagicExpMulEndTime := Value;
end;

procedure THaveItemClass.Sort(var AItemDatas: array of TItemData);
var
  I, J: Integer;
  t: TItemData;
begin
  for I := High(AItemDatas) downto Low(AItemDatas) do
    for J := Low(AItemDatas) to High(AItemDatas) - 1 do
      if AItemDatas[J].rKind < AItemDatas[J + 1].rKind then
      begin
        ChangeItem(j, j + 1);
      end
      else if AItemDatas[J].rKind = AItemDatas[J + 1].rKind then
      begin
        if AItemDatas[J].rGrade < AItemDatas[J + 1].rGrade then
        begin
          ChangeItem(j, j + 1);
        end;
      end;
end;

procedure THaveItemClass.SortItem;
begin
  Sort(HaveItemArr);
end;

function THaveItemClass.ClearPassword(aPassword: string): string;
var
  Password: string;
  nStartPos, nEndPos, nCount, nPos: Integer;
begin
  Result := '';

  Password := Trim(aPassword);
  if Password = '' then
  begin
    Result := '请输入密码';
    exit;
  end;

//  if boLockedPass = false then
//  begin
//    Result := '还没设定密码';
//    exit;
//  end;

  if (LockPassword) <> aPassword then
  begin
    Result := '密码不正确';
    exit;
  end;

  if boLockedPass then
  begin
    Result := '还没解除密码';
    exit;
  end;

  boLockedPass := false;
  LockPassword := '';

  //基本信息写入MYSQL
  if tuser(FBasicObject).SysopScope < 99 then
    tuser(FBasicObject).SetMysqlInfo;
    
  Result := '清除了密码';

end;

procedure TAttribClass.subLucky;
begin
  self.AttribData.lucky := self.AttribData.lucky - 1;
  if self.AttribData.lucky < 0 then
    self.AttribData.lucky := 0;
end;

procedure TAttribClass.setnewTalentExp(ATalentExp: Integer);
begin
  AttribData.newTalentExp := ATalentExp;
  caclTalentlv;
  boSendValues := TRUE;
end;

procedure TAttribClass.caclTalentlv();
var
  p: PTTalentLevelData;
  isup: Boolean;
begin
  isup := False;
  p := TalentLevelClass.getLevle(AttribData.newTalentLv + 1);
  if p = nil then
  begin

    Exit;
  end;
 // AttribData.newTalentExp := AttribData.newTalentExp + ATalentExp;
  //AttribData.newTalentExp := ATalentExp;
  if AttribData.newTalentExp >= p^.Exp then
  begin
    AttribData.newTalentLv := AttribData.newTalentLv + 1;
    AttribData.newTalentExp := AttribData.newTalentExp - p^.Exp;
    AttribData.newTalent := AttribData.newTalent + p^.Point;
    //发送提示信息
    FSendClass.SendChatMessage('天赋等级已提升！', SAY_COLOR_SYSTEM);
    isup := True; //已升级
  end;
  AttribData.newTalentNextLvExp := p^.Exp;
  //有升级继续执行，以便计算经验是否足够多次升级
  if isup then caclTalentlv;
end;

function TAttribClass.getnewTalentExp: Integer;
begin
  Result := AttribData.newTalentExp;
end;

function TAttribClass.getnewTalentLv: Integer;
begin
  Result := AttribData.newTalentLv;
end;

function TAttribClass.getnewTalent: Integer; //获取天赋点
begin
  Result := AttribData.newTalent;
end;

procedure TAttribClass.setnewTalent(AnewTalent: Integer); //写入天赋点
begin
  AttribData.newTalent := AnewTalent;
  boSendValues := TRUE;
end;

function TAttribClass.getnewBone: Integer; //获取根骨
begin
  Result := AttribData.newBone;
end;

function TAttribClass.getnewLeg: Integer; //获取身法
begin
  Result := AttribData.newLeg;
end;

function TAttribClass.getnewSavvy: Integer; //获取悟性
begin
  Result := AttribData.newSavvy;
end;

function TAttribClass.getnewAttackPower: Integer; //获取武学
begin
  Result := AttribData.newAttackPower;
end;

procedure TAttribClass.setnewBone(AnewBone: word); //写入根骨
begin
  AttribData.newBone := AnewBone;
  boSendValues := TRUE;
end;

procedure TAttribClass.setnewLeg(AnewLeg: word); //写入身法
begin
  AttribData.newLeg := AnewLeg;
  boSendValues := TRUE;
end;

procedure TAttribClass.setnewSavvy(AnewSavvy: word); //写入悟性
begin
  AttribData.newSavvy := AnewSavvy;
  boSendValues := TRUE;
end;

procedure TAttribClass.setnewAttackPower(AnewAttackPower: word); //写入武学
begin
  AttribData.newAttackPower := AnewAttackPower;
  boSendValues := TRUE;
end;
//修改天赋等级

procedure TAttribClass.setnewTalentLv(ATalentLv: Integer);
var
  p: PTTalentLevelData;
begin
  p := TalentLevelClass.getLevle(ATalentLv);
  if p = nil then
  begin

    Exit;
  end;
  AttribData.newTalentLv := ATalentLv;
  AttribData.newTalentNextLvExp := p^.Exp;
  boSendValues := True;
end;

{ TUserSubBase }

constructor TUserSubBase.Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
begin
  FBasicObject := aBasicObject;
  FSendClass := aSendClass;
  FAttribClass := aAttribClass;
end;

destructor TUserSubBase.Destroy;
begin

  inherited;
end;

{ TTalentClass }

constructor TTalentClass.Create(aBasicObject: TBasicObject; aSendClass: TSendClass; aAttribClass: TAttribClass);
var
  aScript, afilename: string;
begin
  inherited;

end;

destructor TTalentClass.Destroy;
begin

  inherited;
end;

procedure TTalentClass.LoadFromSdb(aCharData: PTDBRecord);
begin
  inherited;
  FnewAttackPower := aCharData^.newAttackPower;

  FnewBone := aCharData^.newBone;
  FnewLeg := aCharData^.newLeg;
  FnewSavvy := aCharData^.newSavvy;
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
  SetLifeData;
end;

procedure TTalentClass.SaveToSdb(aCharData: PTDBRecord);
begin
  inherited;
  aCharData^.newAttackPower := FnewAttackPower;
  aCharData^.newBone := FnewBone;
  aCharData^.newLeg := FnewLeg;
  aCharData^.newSavvy := FnewSavvy;
end;

procedure TTalentClass.SetLifeData;
var
  SubData: TSubData;
begin
  FillChar(LifeData, sizeof(TLifeData), 0);
  LifeData.damageBody := FnewAttackPower * 6;
  LifeData.avoid := FnewLeg div 2;
  LifeData.accuracy := FnewSavvy div 2;
  LifeData.armorBody := FnewBone * 6;

  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
  self.FAttribClass.boSendValues := TRUE;
  TUserObject(FBasicObject).SetLifeData;

 // FBasicObject.SendSelfMessage(NOTARGETPHONE, FM_SETLIFEDATA, FBasicObject.BasicData, SubData);
end;

procedure TTalentClass.SetnewAttackPower(anewAttackPower: Word);
var
  tmp: word;
begin
  //获取增加了几点
  tmp := anewAttackPower - self.FnewAttackPower;
  if (tmp <= 0) or (tmp > FAttribClass.AttribData.newTalent) then
    Exit;
  //减少剩余天赋点
  FAttribClass.AttribData.newTalent := FAttribClass.AttribData.newTalent - tmp;
  self.FnewAttackPower := anewAttackPower;
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

procedure TTalentClass.ScriptSetnewAttackPower(anewAttackPower: Word);
var
  tmp: word;
begin
  //直接修改
  self.FnewAttackPower := anewAttackPower;
  //改变属性里数值
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

procedure TTalentClass.SetnewBone(AnewBone: word);
var
  tmp: word;
begin
  tmp := AnewBone - self.FnewBone;
  if (tmp < 0) or (tmp > FAttribClass.AttribData.newTalent) then
    Exit;
  FAttribClass.AttribData.newTalent := FAttribClass.AttribData.newTalent - tmp;
  self.FnewBone := AnewBone;
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

procedure TTalentClass.ScriptSetnewBone(AnewBone: Word);
var
  tmp: word;
begin
  //直接修改
  self.FnewBone := AnewBone;
  //改变属性里数值
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

procedure TTalentClass.SetnewLeg(AnewLeg: word);
var
  tmp: word;
begin
  tmp := AnewLeg - self.FnewLeg;
  if (tmp < 0) or (tmp > FAttribClass.AttribData.newTalent) then
    Exit;
  FAttribClass.AttribData.newTalent := FAttribClass.AttribData.newTalent - tmp;
  self.FnewLeg := AnewLeg;
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

procedure TTalentClass.ScriptSetnewLeg(AnewLeg: Word);
var
  tmp: word;
begin
  //直接修改
  self.FnewLeg := AnewLeg;
  //改变属性里数值
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

procedure TTalentClass.SetnewSavvy(AnewSavvy: word);
var
  tmp: word;
begin
  tmp := AnewSavvy - self.FnewSavvy;
  if (tmp < 0) or (tmp > FAttribClass.AttribData.newTalent) then
    Exit;
  FAttribClass.AttribData.newTalent := FAttribClass.AttribData.newTalent - tmp;
  self.FnewSavvy := AnewSavvy;
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

procedure TTalentClass.ScriptSetnewSavvy(AnewSavvy: Word);
var
  tmp: word;
begin
  //直接修改
  self.FnewSavvy := AnewSavvy;
  //改变属性里数值
  self.FAttribClass.AttribData.newAttackPower := FnewAttackPower;
  self.FAttribClass.AttribData.newBone := FnewBone;
  self.FAttribClass.AttribData.newLeg := FnewLeg;
  self.FAttribClass.AttribData.newSavvy := FnewSavvy;
end;

function THaveItemClass.Get_Bind_Money(): integer;
begin
  Result := 0;
  if FBindMoney < 0 then
    FBindMoney := 0;
  Result := FBindMoney;
end;

function THaveItemClass.Add_Bind_Money(acount: integer): Boolean;
begin
  Result := FALSE;
  if acount <= 0 then
    EXIT;

  if FBindMoney < 0 then
    FBindMoney := 0;
  FBindMoney := FBindMoney + acount;
  Result := TRUE;
  FSendClass.SendBindMoney(FBindMoney);
end;

function THaveItemClass.DEL_Bind_Money(acount: integer): Boolean;
begin
  Result := FALSE;
  if acount <= 0 then
    EXIT;
   //   if boLocked = true then exit;
  if (FBindMoney - acount) < 0 then
    EXIT;
  FBindMoney := FBindMoney - acount;
  if FBindMoney < 0 then
    FBindMoney := 0;
  Result := TRUE;
  FSendClass.SendBindMoney(FBindMoney);
end;

initialization
  begin
    DelMagic := TDeleteMagicClass.Create();
  end;

finalization
  begin
    DelMagic.Free;
  end;

end.

