unit CharCls;
{
28 卫兵2
29 卫兵3
31 货郎2

46 怪物，猿猴 男


118 宝箱
119 怪物，猿猴 女
120 怪物，祭祀
121 怪物，鳄鱼，恐龙，类型
122  怪物，球形，骷髅头组合
123  怪物，双头狼
124  石柱，只有碎动画

}
interface

uses
  Windows, SysUtils, Classes, graphics,
  subutil, uanstick, deftype, A2Img, AtzCls, clType, maptype, clmap, backscrn,
  objcls, CTable, AUtil32, uKeyClass, SESDK, SELicenseSDK;

const
  MAGICNEXTTIME = 7; // 付过橇饭烙捞 函窍绰 矫埃
  DYNAMICOBJECTTIME = 15; // DynamicObj啊 函拳窍绰 矫埃

  FRAME_BUFFER_SIZE = 30;

  MESSAGEARR_SIZE = 10;

  CharMaxSiez = 160;
  CHarMaxSiezHalf = 80;

  MovingMagicMaxSiez = 140;
  MovingMagicMaxSiezHalf = 70;

  DynamicObjectMaxSize = 300;
  DynamicObjectMaxSizeHalf = 200;

  BgEffectMaxSize = 140 * 3;
  BgEffectMaxSizeHalf = 70 * 3;

  CharImageBufferCount = 12;
const
  Color16Table: array[0..3 * 32 - 1] of word = (
    0, 0, 0,
    128, 128, 128, // 焊烹
    84, 191, 127, // 檬废
    153, 108, 71, // 哎祸
    145, 162, 194, // 颇鄂
    206, 68, 23, // 弧埃
    71, 150, 153, // 没废
    229, 200, 234, // 焊扼
    225, 230, 157, // 炔配祸
    109, 0, 32, // 磊林
    63, 187, 239, // 窍疵
    32, 32, 32, // 盔濒厘
    255, 0, 0, // 盔弧埃
    0, 255, 0, // 盔踌祸
    0, 0, 255, // 盔颇鄂
    255, 255, 255, // 盔闰祸

    0, 0, 0,
    128, 128, 128, // 焊烹
    84, 191, 127, // 檬废
    153, 108, 71, // 哎祸
    145, 162, 194, // 颇鄂
    206, 68, 23, // 弧埃
    71, 150, 153, // 没废
    229, 200, 234, // 焊扼
    225, 230, 157, // 炔配祸
    109, 0, 32, // 磊林
    63, 187, 239, // 窍疵
    32, 32, 32, // 盔濒厘
    255, 0, 0, // 盔弧埃
    0, 255, 0, // 盔踌祸
    0, 0, 255, // 盔颇鄂
    255, 255, 255); // 盔闰祸

type
  TRecordGhost = record
    aImg: TA2Image; 
    aLightImg: TA2Image;
    ax,ay: integer;
    bx,by: integer;
    gc,ga: Word;
    atick: integer;
  end;
  pTRecordGhost = ^TRecordGhost;

  TRecordMessage = record
    rid: integer;
    rMsg, rdir, rx, ry: Integer;
    rfeature: TFeature;
    rmotion: integer
  end;
  pTRecordMessage = ^TRecordMessage;
    //动画 消息 队列
  TMessageListclass = class
  private
    fid: integer;
    fdata: tlist;
    procedure Clear();
    function getnewId(): integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure del(aid: integer);
    function getfirst(): pTRecordMessage;
    procedure add(app: pTRecordMessage);
  end;

    ///////////// TBgEffect Class /////////// 010120 ankudo
  TBgEffect = class
  private
    DelayTick: integer;
    FUsed: Boolean;
    FAtzClass: TAtzClass;
    BgEffectShape: integer;
    LightEffectKind: TLightEffectKind;
    BgEffectIndex: integer;
    fx, fy: Integer;
    fCreateTick: integer;
    Realx, Realy: integer;
                                                       //中间 对其 坐标
    fboBgOverValue: boolean;
  public

    BgEffectNumEND: integer; //结束
    BgEffectTime: integer; // BgEffect啊 函拳窍绰 矫埃
    BgOverValue: integer;

    FFileName: string;
    ID: integer;
    EffectPositionData: TEffectPositionData;

    BgEffectImagePP: TA2Image;
    pImagePP: pTImageFiledata;
    RepeatCount: Integer;

    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Initialize(ax, ay: integer; aBgEffectShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; astart: integer = 0; rCount: Integer = 1);
    procedure Finalize;
    procedure Paint(aRealx, aRealy, adir: integer);
    procedure SetFrame(CurTick: integer);
    procedure Update(CurTick: integer);
    property Used: Boolean read FUsed;
  end;
  TBgEffectList = class
  private
    data: tlist;
    updatetick: integer;
    function get(aBgEffectShape, ax, ay: integer): TBgEffect;
    function getbyid(aId: integer): TBgEffect;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear();
    procedure CreateInitialize(FAtzClass: TAtzClass; ax, ay: integer; aBgEffectShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; astart: integer = 0; rCount: Integer = 1);

    procedure Update(CurTick: integer);
    procedure Paint(aRealx, aRealy, adir: integer);
  end;

    ///////////// TDynamicObject Class /////////// 010102 ankudo
  TDynamicGuard = record
    aCount: Byte;
    aGuardX: array[0..10 - 1] of Shortint; // 扁霖 128;
    aGuardY: array[0..10 - 1] of Shortint; // 扁霖 128;
  end;
    //活动 物体
  TDynamicObject = class
  private
    DelayTick: integer;
    FUsed: Boolean;
    FAtzClass: TAtzClass;
    DynamicObjIndex: integer;
    DynamicObjShape: integer;
    RealX, RealY: integer;
    FDynamicGuard: TDynamicGuard;

    StructedTick: integer;
    StructedPercent: integer;
    FImagePP: pTImageFiledata;
  public
    Id: integer;
    x, y: integer;
    FStartFrame, FEndFrame: Word;

    DynamicObjImage: TA2Image;
    DynamicObjName: string;
    DynamicObjectState: byte;

    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;

    procedure Initialize(aItemName: string; aId, ax, ay, aItemShape: integer; aStartFrame, aEndFrame: Word; aState: byte; aDynamicGuard: TDynamicGuard);
    procedure Finalize;

    procedure ChangeProperty(pCP: PTSChangeProperty);

    procedure ProcessMessage(aMsg, aMotion: integer);
    procedure SetFrame(aDynamicObjectState: byte; CurTick: integer);
    function IsArea(ax, ay: integer): Boolean;
    procedure Paint;
    function Update(CurTick: integer): Integer;
    property Used: Boolean read FUsed;
    property DynamicGuard: TDynamicGuard read FDynamicGuard;
  end;

  TItemClass = class //物品
  private
    FUsed: Boolean;
    FAtzClass: TAtzClass;
    ItemShape: integer;
    ItemColor: integer;
    RealX, RealY: integer;

  public
    Id: integer;
    x, y: integer;
    Race: byte;
    ItemImage: TA2Image;
    ItemName: string;

    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Initialize(aItemName: string; aRace: byte; aId, ax, ay, aItemshape, aItemcolor: integer);
        //        procedure Finalize;
    procedure SetItemAndColor(aItemshape, aItemColor: integer);

    procedure ChangeProperty(pCP: PTSChangeProperty);

    function IsArea(ax, ay: integer): Boolean;
    procedure Paint; //输出 到背景缓冲区
    function Update(CurTick: integer): Integer;
        //        property Used:Boolean read FUsed;
  end;

  TVirtualObjectClass = class
  private
    RealX, RealY: integer;
    ItemImage: TA2Image;


  public
    Id: integer;
    x, y: integer;
    Width, Height: integer;
    Race: byte;
    fName: string;
    constructor Create();
    destructor Destroy; override;
    procedure Initialize(aName: string; aRace: byte; aId, ax, ay, aw, ah: integer);
    function IsArea(ax, ay: integer): Boolean;
    procedure Paint;
  end;
  TVirtualObjectListClass = class
  private
    fdata: tlist;
    procedure clear;

  public
    function GetData: TList;
    constructor Create;
    destructor Destroy; override;
    procedure add(aName: string; aRace: byte; aId, ax, ay, aw, ah: integer);
    procedure del(aid: integer);
    function get(aid: integer): TVirtualObjectClass;
    procedure MouseMove(x, y: integer);
    procedure Paint();


  end;

    {TCharImageBuffer = record
        aCharImage:TA2Image;
        aImageNumber:integer;
    end;
   }
    //物体 人 怪物
  TCharClass = class
  private
    TurningTick: integer;
    StructedTick: integer; //顶 血条
    StructedPercent: integer; //顶 血条 百分比

    AniList: TList; //动画 配置表
    FrameStartTime: Longint; // 青悼 矫累茄 矫埃

    ImageNumber: Integer; //是图片的下标
    CurFrame: integer;
    CurActionInfo: PTAniInfo;
    CurActionInfoBak: TAniInfo;


    CurMOTION: integer; //当前动画
    CurMOTION_dir: integer; //当前动画方向

        //----------------------------------------------------------
        //FOverImage:TA2Image;
        //FImageBuffer:TA2Image;

    cOverImage: TA2Image;
    cImageBuffer: TA2Image;
//        cImageBuffer_wPP: TA2Image;
//        cImageBufferTemp2: TA2Image;

    cImageBufferTemp2CurTick: integer;
    cImageBufferTemp3CurTick: integer;
    cImageBufferTemp4CurTick: integer;
    cImageBufferTempIndex: integer;
    cImageBufferTempIndexState: boolean;

    cImageArrPP: array[0..10] of pTImageFiledata;
    cImageArrw_PP: pTImageFiledata;
    cImageArrw_GhostPP: pTImageFiledata;
    cImageBuffer_w: TA2Image;
    cOverImagePP: pTImageFiledata;
    cImageArrGhost: array[0..25] of TRecordGhost;
        //----------------------------------------------------------

    MOverImage: TA2Image;
    MImageBuffer: TA2Image;
    mOverImagePP: pTImageFiledata;
    mImageBufferPP: pTImageFiledata;

    BgEffect: TBgEffect; //普通效果
    ScreenEffect: TBgEffect; //屏幕 效果
    MagicEffect: TBgEffect; //武功效果     移动  满10级 效果
    BgEffectList: TBgEffectList; //可重叠效果

    _RealX, _RealY: integer; //坐标 屏幕输出
    FUsed: Boolean; //是否被使用
    FAtzClass: TAtzClass; //图片集

    CurAction: integer;

    OldMakeFrame: integer;
    Oldblock: integer;

    BubbleList: TStringList; //冒泡 消息 内容（多行）
    BubbleTick: integer; //冒泡 时间 
    SayTick: integer; //冒泡 时间SM_SAY

    MessageList: TMessageListclass;
        //ImageBufList:TImageBufclass;
        //tempboolean:boolean;
    rFName: string; //自己名字

    procedure SetCurrentFrame(aAniInfo: PTAniInfo; aFrame, CurTime: integer);
    function FindAnimation(aact, adir: Integer): PTAniInfo;
    procedure SetCurrentPos;
    function getname: string;
    procedure setname(name: string);
    function getx: integer;
    procedure setx(value: integer);
    function gety: integer;
    procedure sety(value: integer);
    function getRealX: integer;
    procedure setRealX(value: integer);
    function getRealY: integer;
    procedure setRealY(value: integer);
  public
    _rName: string; //自己名字                     //2016.03.13 在水一方 停用,防外挂
    ConsortName: string; //配偶 名字
    GuildName: string; //帮会名字
    FboMOVE: boolean;
    id, dir, _x, _y: integer;
    Feature: TFeature;
    rspecialShowState: boolean;

    oldspecialMagicType: word; //上一次的技能
    rspecialMagicType: word; //特殊 效果
    oldC1, oldC2: integer;
    oldspecialEffectColor: byte;
    rspecialEffectColor: byte; //动作
    Effectmove, //
      EffectMotion
      : boolean;

    rbooth: BOOLEAN;
    rBoothName: string;
    rboothshape: integer;
    RandomValue: Word;

    bidx, caddx, caddy: integer;
    property rName: string read getname write setname; //自己名字 //2016.03.13 在水一方 新增,防外挂
    property x: integer read getx write setx; //2016.03.14 在水一方 新增,防外挂
    property y: integer read gety write sety; //2016.03.14 在水一方 新增,防外挂
    property RealX: integer read getRealX write setRealX; //2016.03.14 在水一方 新增,防外挂
    property RealY: integer read getRealY write setRealY; //2016.03.14 在水一方 新增,防外挂
    procedure MakeFrame(aindex, CurTick: integer);

    procedure AddBgEffect(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; rCount: Integer = 1);
    procedure AddBgEffectList(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; rCount: Integer = 1);
    procedure AddScreenEffect(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean);
    procedure AddMagicEffect(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; astat, aend: integer; boBgOverValue: boolean);
    procedure AddBufferEffect(pp: PTSChangeFeature);
    procedure AddBufferEffect2(pp: PTSChangeFeature_Npc_MONSTER);

    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Initialize(aName: string; aId, adir, ax, ay: integer; afeature: TFeature); //安装 初始化
        //        procedure Finalize;        //卸载

    function IsArea(ax, ay: integer): Boolean;
    procedure MouseMove(x, y: integer);
    function GetArrImageLib(aindex, CurTick: integer): TA2ImageLib;
    procedure Paint(CurTick: integer);
    procedure paint_Point(image: TA2Image; aw, ah: integer);

    function AllowAddAction: Boolean;
    function ProcessMessage(aMsg, adir, _ax, _ay: Integer; afeature: TFeature; amotion: integer): Integer;
    function ProcessMessageRun(aMsg, adir, ax, ay: Integer; afeature: TFeature; amotion: integer): Integer;
    function Update(CurTick: integer): Integer;

    procedure Say(astr: string); //消息 消息 
    procedure SayItem(astr:string;AChatItemMessage:PTSChatItemMessage);
    procedure SayItemHead(astr:string;AChatItemMessage:PTSChatItemMessageHead);

    procedure ChangeProperty(str: string);
        //        property Used:Boolean read FUsed;
    property Structed: integer read StructedPercent;
    procedure DrawWearHeadPortrait(aHeadP: TA2Image); //得到 头像
        //    property    Image : TA2Image read CharImage;
  end;
    //--------------------------------------------------------------------------------------
  TCharDataListclass = class
  private
    fdata: tlist;
    FidIndex: TIntegerKeyClass;
    fnameIndex: TStringKeyClass;
  public

    constructor Create;
    destructor Destroy; override;
    procedure Clear();
    function getAllName(): string;
    function getAllMonsterName(): string;
    procedure add(aName: string; aId, adir, ax, ay: integer; afeature: TFeature);
    procedure del(aid: integer);
    function getname(aname: string): TCharClass;
    function getId(aid: integer): TCharClass;
    procedure Update(CurTick: integer);
    procedure UpdateEffect(CurTick: integer);
    function getbyindex(aindex: Integer): TCharClass;
    procedure MouseMove(x, y: integer);
    procedure Paint(CurTick: integer);
    procedure PaintText(aCanvas: TCanvas);
    function getData: TList;
    function CharGetByName(aName: string): TCharClass;
  end;

    //所有 实体
  TCharList = class
  private
    CharDataList: TCharDataListclass; //创建 列表 {人}
    ItemDataList: TList; //创建 列表 {物品}
    MagicDataList: TList; //创建 列表 {魔法}

    DynamicObjDataList: TList; //创建 列表 {动态 对象}

    FAtzClass: TAtzClass; //本类 不创建 资料
    boothImageBuffer: TA2Image;

    MAP_EffectList: TBgEffectList; //全局 效果。用在，远程武功打完后效果处理
        //    function isStaticItemID(aid : LongInt) : Boolean; //010127 ankudo isStaticitem阑 荤侩救窍备 race蔼栏肺 魄窜窃
    function isDynamicObjectStaticItemID(aid: LongInt): Boolean;
  public
    VirtualObjectList: TVirtualObjectListClass;
    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Clear;
        //                 名字             ID  方向  坐标            Feature 外关描述
    procedure CharAdd(aName: Widestring; aId, adir, ax, ay: integer; afeature: TFeature);
    function CharGet(aId: integer): TCharClass;
    function CharGetByIndex(Aid: Integer): TCharClass;
    function CharGetTlist(): tlist;
    function CharGetAllName(): string;
    function CharGetAllMonsterName(): string;
    procedure CharDelete(aId: integer);
        // item
    procedure AddItem(aItemName: string; aRace: byte; aId, ax, ay, aItemShape, aItemColor: integer);
    function GetItem(aId: integer): TItemClass;
    procedure DelItem(aId: integer);
        // DynamicObject Item 010105 ankudo
    procedure AddDynamicObjItem(aItemName: string; aId, ax, ay, aItemShape: integer; aStartFrame, aEndFrame: Word; aState: byte; aDynamicGuard: TDynamicGuard);
    procedure SetDynamicObjItem(aId: integer; aState: byte; aStartFrame, aEndFrame: Word);
    function GeTDynamicObjItem(aId: integer): TDynamicObject;
    procedure DeleteDynamicObjItem(aId: integer);

    procedure AddMagic(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, aef, CurTick: integer; aType: byte);
    procedure GetVarRealPos(var aid, ax, ay: integer);
    function isMovable(xx, yy: integer): Boolean;

    procedure PaintText(aCanvas: TCanvas);
    procedure Paint(CurTick: integer);
    procedure Paint_Point(image: TA2Image; aw, ah: integer);
    function UpDate(CurTick: integer): Integer;
    procedure UpDataBgEffect(CurTick: integer);
    procedure MouseMove(x, y: integer);
    function CharGetByName(aName: string): TCharClass;
  end;

  TMagicActionType = (MAT_SHOW, MAT_MOVE, MAT_HIDE, MAT_DESTROY);

  ToldMovingMagic = record
    asid, aeid: LongInt;
    aDeg: integer;
    atx, aty: word;
    aMagicShape: integer;
    amf: byte;
    aEf: byte;
    aspeed: byte;
    aType: byte;
    ax, ay: integer;
  end;

  TMovingMagicClass = class
  private
    StartId, EndId: longInt;
    speed: word;
    tx, ty, drawX, drawY: integer;
    Ef: integer;
    ActionStartTime: DWORD;
    LifeCycle: integer;
    curframe: Integer;
    ArriveFlag: Boolean;
    Deg, Direction: word;

    MagicCount: integer;
    MagicType: byte;
    OldMovingMagicR: ToldMovingMagic;

    FUsed: Boolean;
    FAtzClass: TAtzClass;
    MagicShape: integer;
    RealX, RealY: integer;
    MsImageLib, MmImageLib, MeImageLib: TA2ImageLib;
    procedure SetAction(aAction: TMagicActionType; CurTime: integer);
  public
    MagicCurAction: TMagicActionType;
    x, y: integer;
        //    MagicImage : TA2Image;
    MagicName: string;
    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Initialize(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, aEf, CurTick: integer; aType: byte);
        //        procedure Finalize;

    procedure Paint;
    function Update(CurTick: integer): Integer;
        // property Used:Boolean read FUsed;
  end;

procedure GetGreenColorAndAdd(acolor: integer; var GreenColor, GreenAdd: integer);

var
  CharList: TCharList;



  CharCenterId: integer = 0; //自己ID
  CharCenterName: string = ''; //自己 名字
  CharPosX: integer = 0; //自己 坐标
  CharPosY: integer = 0;
  CharCenterLockMoveTick: integer = 0;
  G_AutoHitCharPosX: Integer = 0;
  G_AutoHitCharPosY: Integer = 0;
  SelectedChar: integer = 0;
  AutoSelectedChar: Integer = 0;
  ClickSelectedChar: integer = 0;
  Selecteditem: integer = 0;
  SelectedVirtualObject: integer = 0;
  SelectedDynamicItem: integer = 0;

  CharMoveFrontdieFlag: Boolean = FALSE;
  MyModstart, MyModEnd: Cardinal;
  MzH: PImageDosHeader;
  peH: PImageNtHeaders;
                                                    //锁定 移动 一定时间

    //   ColorIndex : array [0..32-1] of word;

implementation
uses

  FMain, FBottom, Unit_console, FGameToolsNew, FSound, filepgkclass;
{$O+}

//////////////////////////////////
//         Moving Magic Class
//////////////////////////////////
// 滚弊肺 牢秦辑 积变 酒捞袍祸阑 抛捞喉肺 贸府窃.

procedure GetGreenColorAndAdd(acolor: integer; var GreenColor, GreenAdd: integer);
begin
  if (acolor >= 256) or (acolor < 0) then acolor := 0;
  GreenColor := ColorDataTable[acolor * 2];
  GreenAdd := ColorDataTable[acolor * 2 + 1];

    //   GreenColor := ColorIndex[acolor mod 32];
    //   GreenAdd := acolor div 16;

    //   GreenColor := WINRGB (ColorTable[acolor * 3 + 0],ColorTable[acolor * 3 + 1],ColorTable[acolor * 3 + 2] );
    //   GreenAdd := acolor div 64;
end;
{
procedure GetGreenColorAndAdd (acolor: integer; var GreenColor, GreenAdd: integer);
begin
   if (acolor >= 256) or (acolor < 0) then acolor := 0;
   GreenColor := ColorDataTable[acolor*2];
   GreenAdd := ColorDataTable[acolor*2+1];
end;
}

{
procedure GetGreenColorAndAdd (acolor: integer; var GreenColor, GreenAdd: integer);
begin
   if acolor < 16 then begin
      GreenColor := ColorIndex[acolor];
      GreenAdd := 0;
   end else begin
      GreenColor := ColorIndex[acolor];
      GreenAdd := 3;
   end;
end;
}

////////////////////////////////////////////////////////////////////////////////
//                           TMovingMagicClass
////////////////////////////////////////////////////////////////////////////////

constructor TMovingMagicClass.Create(aAtzClass: TAtzClass);
begin
  FAtzClass := aAtzClass;
  Fillchar(OldMovingMagicR, Sizeof(OldMovingMagicR), 0);
  MagicCount := 0;
  MagicType := 0;
end;

destructor TMovingMagicClass.Destroy;
begin
  inherited destroy;
end;

procedure TMovingMagicClass.Initialize(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, aEf, CurTick: integer; aType: byte);
begin
  if aType > 0 then
  begin
    MagicCount := 8 - 1;
    OldMovingMagicR.asid := sid;
    OldMovingMagicR.aeid := eid;
    OldMovingMagicR.aDeg := adeg;
    OldMovingMagicR.atx := atx;
    OldMovingMagicR.aty := aty;
    OldMovingMagicR.aMagicShape := aMagicShape;
    OldMovingMagicR.amf := aMagicShape;
    OldMovingMagicR.aEf := aEf;
    OldMovingMagicR.aspeed := aspeed;
    OldMovingMagicR.aType := atype;
    OldMovingMagicR.ax := ax;
    OldMovingMagicR.ay := ay;
  end;
  StartId := sid;
  EndId := eid;
  deg := adeg;
  speed := aspeed;
  x := ax;
  y := ay;
  Tx := atx;
  ty := aty;
  Ef := aEf;
  MagicShape := aMagicShape;
  MagicType := aType;
  LifeCycle := 30;
  Direction := GetDegDirection(deg);
  SetAction(MAT_SHOW, mmAnsTick);

  MsImageLib := nil;
  MmImageLib := FAtzClass.GetImageLib('y' + IntToStr(MagicShape) + '.atz', CurTick);
  MeImageLib := nil;

  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
  FUsed := TRUE;
end;

procedure TMovingMagicClass.SetAction(aAction: TMagicActionType; CurTime: integer);
var
  cl: TCharClass;
begin
  MagicCurAction := aAction;
  ActionStartTime := CurTime;
  curframe := 0;
  if MagicCurAction = MAT_SHOW then
  begin
    DrawX := x * UNITX + UNITXS;
    DrawY := y * UNITY - UNITYS;
    CharList.GetVarRealPos(StartId, DrawX, DrawY);
  end;
  RealX := DrawX;
  RealY := DrawY;
  if MagicCurAction = MAT_HIDE then
  begin
        //CharList.MAP_EffectList.CreateInitialize(FAtzClass, tx, ty, Ef-1, lek_cumulate);
    if Ef > 0 then
    begin
      Cl := CharList.CharGet(EndId);
      if Cl <> nil then
      begin
        cl.AddBgEffect(Cl.x, Cl.y, Ef - 1, lek_cumulate, TRUE);
                    //FrmBottom.AddChat('普通效果', WinRGB(22, 22, 0), 0);
      end;
    end;
  end;
end;
{
procedure TMovingMagicClass.Finalize;
begin
    FUsed := FALSE;
end;
}

procedure TMovingMagicClass.Paint;
var
  tempframe: integer;
  overValue: integer;
begin
  tempframe := 0;
  overValue := 10;
  case MagicCurAction of
    MAT_SHOW:
      begin
        if MsImageLib = nil then exit;
        case MagicType of
          0:
            begin
              if MmImageLib.Count = 80 then tempframe := curframe + Direction * 10
              else tempframe := curframe;
            end;
          1:
            begin
              tempframe := Random(MmImageLib.Count - 1);
              overValue := random(3) + 7;
            end;
        end;
        BackScreen.DrawImageOveray(MsImageLib.Images[tempframe], DrawX, DrawY, overValue);
      end;
    MAT_MOVE:
      begin
        if MmImageLib = nil then exit;
        case MagicType of
          0:
            begin
              if MmImageLib.Count = 80 then tempframe := curframe + Direction * 10
              else tempframe := curframe;
            end;
          1:
            begin
              tempframe := Random(MmImageLib.Count - 1);
              overValue := random(3) + 7;
            end;
        end;
        BackScreen.DrawImageOveray(MmImageLib.Images[tempframe], DrawX, DrawY, overValue);
      end;
    MAT_HIDE:
      begin
        if MeImageLib = nil then exit;
        case MagicType of
          0:
            begin
              if MmImageLib.Count = 80 then tempframe := curframe + Direction * 10
              else tempframe := curframe;
            end;
          1:
            begin
              tempframe := Random(MmImageLib.Count - 1);
              overValue := random(3) + 7;
            end;
        end;
        BackScreen.DrawImageOveray(MeImageLib.Images[tempframe], DrawX, DrawY, overValue);
      end;
  end;
end;

function TMovingMagicClass.Update(CurTick: integer): Integer;
var
  tdrawx, tdrawy, len: integer;
  PassTime: LongInt;
  tdeg: word;
begin
  Result := 0;
  if MagicCurAction = MAT_MOVE then Result := 1;

  PassTime := CurTick - integer(ActionStartTime); // 青悼捞 场车栏搁

  case MagicCurAction of
    MAT_SHOW:
      begin
        curframe := PassTime div MAGICNEXTTIME;
        if curframe >= 10 then SetAction(MAT_MOVE, CurTick);
        DrawX := x * UNITX + UNITXS;
        DrawY := y * UNITY - UNITYS;
        CharList.GetVarRealPos(StartId, DrawX, DrawY);
        case MagicType of
          0: ;
          1:
            begin
              if MagicCount > 0 then
              begin
                with OldMovingMagicR do
                begin
                  CharList.AddMagic(asid, aeid, Random(360), Random(15) + 10, ax + Random(5), ay + Random(5), atx + Random(5), aty + Random(5), aMagicShape, aEf, CurTick, 0);
                end;
                Dec(MagicCount);
              end;
            end;
        end;
      end;
    MAT_MOVE:
      begin
        tdrawx := Tx * UNITX + UNITXS;
        tdrawy := ty * UNITY - UNITYS;

        CharList.GetVarRealPos(EndId, tDrawX, tDrawY);

        curframe := curframe + 1;
        if curframe >= 10 then curframe := 0;
        Dec(LifeCycle);

        if LifeCycle = 0 then SetAction(MAT_HIDE, CurTick);
        GetDegNextPosition(deg, speed, DrawX, DrawY);
        tdeg := GetDeg(DrawX, DrawY, tdrawx, tdrawy);

        len := (DrawX - tDrawx) * (DrawX - tDrawx) + (DrawY - tDrawy) * (DrawY - tDrawy);
        if len < 400 then
        begin
          Drawx := tDrawx;
          Drawy := tDrawy;
          SetAction(MAT_HIDE, CurTick);
          exit;
        end;

        deg := GetNewDeg(deg, tdeg, 20);
        if ArriveFlag then if abs(deg - tdeg) > 100 then SetAction(MAT_HIDE, CurTick);

        if deg = tdeg then ArriveFlag := TRUE;
        case MagicType of
          0: ;
          1:
            begin
              if MagicCount > 0 then
              begin
                with OldMovingMagicR do
                begin
                  CharList.AddMagic(asid, aeid, Random(360), Random(15) + 10, ax + Random(5), ay + Random(5), atx + Random(5), aty + Random(5), aMagicShape, aEf, CurTick, 0);
                end;
                Dec(MagicCount);
              end;
            end;
        end;
      end;
    MAT_HIDE:
      begin
        curframe := PassTime div MAGICNEXTTIME;
        if curframe >= 10 then SetAction(MAT_DESTROY, CurTick);

        DrawX := tx * UNITX + UNITXS;
        DrawY := ty * UNITY - UNITYS;
        CharList.GetVarRealPos(EndId, DrawX, DrawY);
      end;
    MAT_DESTROY: exit;
  end;
  RealX := DrawX;
  RealY := DrawY;
end;

//////////////////////////////////
//         TMessageListclass
//////////////////////////////////

constructor TMessageListclass.Create();
begin
  inherited Create;
  fdata := tlist.Create;
  fid := 0;
end;

function TMessageListclass.getfirst(): pTRecordMessage;
begin
  result := nil;
  if fdata.Count <= 0 then exit;
  result := fdata.Items[0];

end;

procedure TMessageListclass.add(app: pTRecordMessage);
var
  pp: pTRecordMessage;
begin
  new(pp);

  pp^ := app^;
  pp.rid := getnewId;
  fdata.Add(pp);
end;

function TMessageListclass.getnewId(): integer;
begin
  inc(fid);
  result := fid;
end;

procedure TMessageListclass.del(aid: integer);
var
  i: integer;
  pp: pTRecordMessage;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    if pp.rid = aid then
    begin
      dispose(pp);
      fdata.Delete(i);
      exit;
    end;
  end;

end;

procedure TMessageListclass.Clear();
var
  i: integer;
  pp: pTRecordMessage;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    dispose(pp);
  end;
  fdata.Clear;
end;

destructor TMessageListclass.Destroy;

begin
  Clear;
  fdata.Free;
  inherited destroy;
end;

//////////////////////////////////
//         BgEffectList Class
//////////////////////////////////

procedure TBgEffectList.CreateInitialize(FAtzClass: TAtzClass; ax, ay: integer; aBgEffectShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; astart: integer; rCount: Integer);
var
  temp: TBgEffect;
begin
  if aBgEffectShape <= 0 then exit;
  temp := TBgEffect.Create(FAtzClass);
  temp.Initialize(ax, ay, aBgEffectShape, aLightEffectKind, boBgOverValue, astart, rCount);
  data.Add(temp);
end;

procedure TBgEffectList.Update(CurTick: integer);
var
  temp: TBgEffect;
  i: integer;
begin
  while data.Count > 10 do
  begin
    temp := data.Items[0];
    temp.Free;
    data.Delete(0);
  end;
  for i := data.Count - 1 downto 0 do
  begin
    temp := data.Items[i];
    if temp.FUsed = false then
    begin
      temp.Free;
      data.Delete(i);
    end else
      temp.Update(CurTick);

  end;

end;

procedure TBgEffectList.Paint(aRealx, aRealy, adir: integer);
var
  temp: TBgEffect;
  i: integer;
begin
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    temp.Paint(aRealx, aRealy, adir);
//    if fwide = 800 then temp.Paint(aRealx, aRealy, adir) else temp.Paint(aRealx + 12, aRealy + 4, adir);
   // temp.Paint(aRealx+100, aRealy, adir);
  end;

end;


function TBgEffectList.get(aBgEffectShape: integer; ax, ay: integer): TBgEffect;
var
  temp: TBgEffect;
  i: integer;
begin
  result := nil;
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    if (temp.BgEffectShape = aBgEffectShape)
      and (temp.fx = ax)
      and (temp.fy = ay)
      then
    begin
      result := temp;
      exit;
    end;
  end;

end;

function TBgEffectList.getbyid(aId: integer): TBgEffect;
begin
  result := nil;
  if (aId < 0) or (aId >= data.Count) then exit;
  result := data.Items[aId];
end;

procedure TBgEffectList.Clear();
var
  temp: TBgEffect;
  i: integer;
begin
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    temp.Free;
  end;
  data.Clear;
end;

constructor TBgEffectList.Create();
begin
  data := tlist.Create;
  updatetick := 0;
end;

destructor TBgEffectList.Destroy;
begin

  Clear;
  data.Free;
  inherited destroy;
end;
//////////////////////////////////
//         BgEffect Class
//////////////////////////////////

constructor TBgEffect.Create(aAtzClass: TAtzClass);
begin
  pImagePP := nil;
  BgEffectImagePP := nil;
  fboBgOverValue := false;
  FAtzClass := aAtzClass;
  RepeatCount := 1;
end;

destructor TBgEffect.Destroy;
begin
  inherited destroy;
end;

procedure TBgEffect.Initialize(ax, ay: integer; aBgEffectShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; astart: integer = 0; rCount: Integer = 1);

begin
  fboBgOverValue := boBgOverValue;
  BgEffectShape := aBgEffectShape;
    //    FFileName := format('_%d.atz', [BgEffectShape]);
  FFileName := format('_%d.eft', [BgEffectShape]);

  EffectPositionData := EffectPositionClass.GetPosition(FFilename);
  BgOverValue := EffectPositionData.rArr[0];
  if BgOverValue < 0 then BgOverValue := 0;
  BgEffectTime := EffectPositionData.rArr[1];
  if BgEffectTime < 1 then BgEffectTime := 10;

  LightEffectKind := aLightEffectKind;
  fx := ax;
  fy := ay;
  fCreateTick := mmAnsTick;

  RealX := ax * UNITX + UNITX div 2;
  RealY := ay * UNITY + UNITY div 2;

  BgEffectIndex := astart;
  BgEffectNumEND := -1;
  DelayTick := 0;
  FUsed := TRUE;

  BgEffectImagePP := nil;
  pImagePP := FAtzClass.EffectList.GetImageLibPP(FFileName, mmAnsTick);
  RepeatCount := rCount;
end;

procedure TBgEffect.Finalize;
begin
  FFileName := '';
  FUsed := FALSE;
  RepeatCount := 1;
end;

procedure TBgEffect.Paint(aRealx, aRealy, adir: integer);
var
  i, j, ax, ay: integer;
begin
  adir := adir + 1;
  ax := EffectPositionData.rArr[adir * 2];
  ay := EffectPositionData.rArr[adir * 2 + 1];
  if Used = FALSE then exit;
  if BgEffectImagePP = nil then EXIT;


  {  fboBgOverValue := true;
    for i := -10 to 10 do
    begin
        for j := -10 to 10 do
        begin
            ax := i * 32;
            ay := j * 24;


   }
  ax := 0; ay := 0; //2015.11.26 在水一方
  case LightEffectKind of
    lek_none:
      begin
        //开关境界光球特效偏移
        case BgEffectShape of
          2000..2001: ay := 24;
          2002..2007: ay := -24;
        end;
        //FrmBottom.AddChat(format('[目标%D]', [BgEffectShape]), ColorSysToDxColor(clred), 0);
        if fboBgOverValue then
          BackScreen.DrawImageOveray(BgEffectImagePP, RealX + ax, RealY + ay, BgOverValue) //2015.11.15 在水一方
          //BackScreen.DrawImageOveray(BgEffectImagePP, RealX {+ ax}, RealY {+ ay}, BgOverValue) //2015.11.15 在水一方
        else
          BackScreen.DrawImageAdd(BgEffectImagePP, RealX + ax, RealY + ay); //<<<<<<
         // BackScreen.DrawImageAdd(BgEffectImagePP, RealX {+ ax}, RealY {+ ay}); //<<<<<<
      end;
    lek_follow: //跟随
      begin
        //开关境界光球特效偏移
        case BgEffectShape of
          2000..2001: ay := 48;
          2002..2007: ay := 0;
        else
          ay := 24;
        end;
       // FrmBottom.AddChat(format('[aRealX%D][aRealY%D][ax%D][ay%D] ', [aRealX, aRealY, ax, ay]), ColorSysToDxColor(clred), 0);
        if fboBgOverValue then
          BackScreen.DrawImageOveray(BgEffectImagePP, aRealX + ax, aRealY + ay, BgOverValue)
         // BackScreen.DrawImageOveray(BgEffectImagePP, aRealX + ax, aRealY + ay, BgOverValue)
        else
          BackScreen.DrawImageAdd(BgEffectImagePP, aRealX + ax, aRealY + ay); //, 0);//BgOverValue);
         // BackScreen.DrawImageAdd(BgEffectImagePP, aRealX + ax, aRealY + ay); //, 0);//BgOverValue);

      end;
    lek_future: ;
    lek_cumulate_follow: //累积 跟随
      begin
        //开关境界光球特效偏移
        case BgEffectShape of
          2000..2001: ay := 48;
          2002..2007: ay := 0;
        else
          ay := 24;
        end;

       // FrmBottom.AddChat(format('[aRealX%D][aRealY%D][ax%D][ay%D] ', [aRealX, aRealY, ax, ay]), ColorSysToDxColor(clred), 0);
        if fboBgOverValue then
          BackScreen.DrawImageOveray(BgEffectImagePP, aRealX + ax, aRealY + ay, BgOverValue)
         // BackScreen.DrawImageOveray(BgEffectImagePP, aRealX + ax, aRealY + ay, BgOverValue)
        else
          BackScreen.DrawImageAdd(BgEffectImagePP, aRealX + ax, aRealY + ay); //, 0);//BgOverValue);
         // BackScreen.DrawImageAdd(BgEffectImagePP, aRealX + ax, aRealY + ay); //, 0);//BgOverValue);


       //if fboBgOverValue then
       //  BackScreen.DrawImageOveray(BgEffectImagePP, aRealX + ax, aRealY + ay, BgOverValue)
       // else BackScreen.DrawImageAdd(BgEffectImagePP, aRealX + ax, aRealY + ay);
      end;
    lek_cumulate: //累积
      begin

        //开关境界光球特效偏移
        case BgEffectShape of
          2000..2001: ay := 24;
          2002..2007: ay := -24;
        end;
        if fboBgOverValue then
          BackScreen.DrawImageOveray(BgEffectImagePP, RealX + ax, RealY + ay, BgOverValue) //2015.11.15 在水一方
          //BackScreen.DrawImageOveray(BgEffectImagePP, RealX {+ ax}, RealY {+ ay}, BgOverValue) //2015.11.15 在水一方
        else
          BackScreen.DrawImageAdd(BgEffectImagePP, RealX + ax, RealY + ay); //<<<<<<
         // BackScreen.DrawImageAdd(BgEffectImagePP, RealX {+ ax}, RealY {+ ay}); //<<<<<<

        //if fboBgOverValue then BackScreen.DrawImageOveray(BgEffectImagePP, RealX + ax, RealY + ay, BgOverValue)
       // else BackScreen.DrawImageAdd(BgEffectImagePP, RealX + ax, RealY + ay);
      end;
  end;
    {    end;

    end;}
end;

procedure TBgEffect.SetFrame(CurTick: integer);

begin
  if Used = FALSE then exit;
  if pImagePP = nil then
  begin
    Finalize;
    EXIT;
  end;
  if pImagePP.rImageLib = nil then
  begin
    Finalize;
    EXIT;
  end;
  BgEffectImagePP := nil;
    //////////////////////////////////////////
    //             完成所有动画释放自己
    //////////////////////////////////////////
  if (pImagePP.rImageLib <> nil) then
  begin
    if BgEffectIndex > pImagePP.rImageLib.Count - 1 then
    begin
      if RepeatCount <> MaxRepeatCount then
        Dec(RepeatCount);
      if RepeatCount <= 0 then begin
        Finalize;
        exit;
      end
      else begin
        BgEffectIndex := 0;
      end;
    end;
    if BgEffectNumEND > 0 then
    begin
      if BgEffectIndex >= BgEffectNumEND then
      begin
        if RepeatCount <> MaxRepeatCount then
          Dec(RepeatCount);
        if RepeatCount <= 0 then begin
          Finalize;
          exit;
        end
        else begin
          BgEffectIndex := 0;
        end;
      end;
    end;
  end else
  begin
    Finalize;
    exit;
  end;
  if (pImagePP.rImageLib.Images[BgEffectIndex] = nil) then
  begin
    Finalize;
    exit;
  end;
    //////////////////////////////////////////
    //             组合图片
    //////////////////////////////////////////
  BgEffectImagePP := pImagePP.rImageLib.Images[BgEffectIndex];
  inc(BgEffectIndex);
end;

procedure TBgEffect.Update(CurTick: integer);
begin
  if pImagePP <> nil then pImagePP.rrunTick := CurTick;
  if CurTick > DelayTick + BgEffectTime then
  begin
    DelayTick := CurTick;
    SetFrame(CurTick);
  end;
end;

//////////////////////////////////
//         DynamicObject Class
//////////////////////////////////

constructor TDynamicObject.Create(aAtzClass: TAtzClass);
begin
  FAtzClass := aAtzClass;
  DynamicObjImage := TA2Image.Create(DynamicObjectMaxSize, DynamicObjectMaxSize, 0, 0);
  StructedTick := 0;
  StructedPercent := 0;

  FStartFrame := 0;
  FEndFrame := 0;
end;

destructor TDynamicObject.Destroy;
begin
  DynamicObjImage.Free;
  inherited destroy;
end;

procedure TDynamicObject.Initialize(aItemName: string; aId, ax, ay, aItemShape: integer; aStartFrame, aEndFrame: Word; aState: byte; aDynamicGuard: TDynamicGuard);
begin
  DynamicObjName := aItemName;
  id := aid;
  x := ax;
  y := ay;
  DynamicObjShape := aItemShape;
  DynamicObjectState := aState;
  if DynamicObjectState = 1 then DynamicObjIndex := Random(5 + aStartFrame)
  else DynamicObjIndex := aStartFrame;
  FDynamicGuard := aDynamicGuard;
  FStartFrame := aStartFrame;
  FEndFrame := aEndFrame;
  DelayTick := 0;

  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
  FUsed := TRUE;
  FImagePP := nil;

end;

procedure TDynamicObject.Finalize;
begin
  FUsed := FALSE;
  DynamicObjName := '';
  id := 0;
end;

procedure TDynamicObject.ChangeProperty(pCP: PTSChangeProperty);
begin

  DynamicObjName := GetWordString(pCP.rWordString);
end;

procedure TDynamicObject.ProcessMessage(aMsg, aMotion: integer);
begin
  case amsg of
    SM_STRUCTED:
      begin
        StructedTick := mmAnsTick;
        StructedPercent := aMotion;
      end;
  end;
end;

function TDynamicObject.IsArea(ax, ay: integer): Boolean;
var
  xp, yp: integer;
  xx, yy: integer;
  pb: pword;
begin
  Result := TRUE;
  xx := RealX + DynamicObjImage.px - DynamicObjectMaxSizeHalf;
  yy := RealY + DynamicObjImage.py - DynamicObjectMaxSizeHalf;

  if (ax <= xx) then Result := FALSE;
  if (ay <= yy) then Result := FALSE;
  if ax >= xx + DynamicObjImage.Width then Result := FALSE;
  if ay >= yy + DynamicObjImage.Height then Result := FALSE;
  if Result = FALSE then exit;

  xp := ax - xx;
  yp := ay - yy;

  pb := PWORD(DynamicObjImage.bits);
  inc(pb, xp + yp * DynamicObjImage.Width);
  if pb^ = 0 then Result := FALSE;
end;

procedure TDynamicObject.SetFrame(aDynamicObjectState: byte; CurTick: integer);
var
  ImageLib: TA2ImageLib;
begin
  if FImagePP = nil then FImagePP := FAtzClass.AtzList.GetImageLibPP(format('x%d.atz', [DynamicObjShape]), CurTick);
  if FImagePP <> nil then ImageLib := FImagePP.rImageLib;
  DynamicObjImage.Free;
  DynamicObjImage := TA2Image.Create(DynamicObjectMaxSize, DynamicObjectMaxSize, 0, 0);
  case aDynamicObjectState of
    0: // ex 惑磊 : 凯府绰 葛嚼
      begin

        if ImageLib <> nil then
        begin
          if DynamicObjIndex > FEndFrame then DynamicObjIndex := FEndFrame;
          if (ImageLib <> nil) and (ImageLib.Images[DynamicObjIndex] <> nil) then
          begin
            DynamicObjImage.DrawImage(ImageLib.Images[DynamicObjIndex], ImageLib.Images[DynamicObjIndex].px + DynamicObjectMaxSizeHalf, ImageLib.Images[DynamicObjIndex].py + DynamicObjectMaxSizeHalf, TRUE);
            DynamicObjImage.Optimize;
          end;
          Inc(DynamicObjIndex)
        end;
      end;
    1: // ex 巩颇檬籍 拳肺 : 拌加利栏肺 Scroll凳
      begin
                // ImageLib := FAtzClass.GetImageLib(format('x%d.atz', [DynamicObjShape]), CurTick);
        if ImageLib <> nil then
        begin
          if DynamicObjIndex > FEndFrame then DynamicObjIndex := FStartFrame;
          if (ImageLib <> nil) and (ImageLib.Images[DynamicObjIndex] <> nil) then
          begin
            DynamicObjImage.DrawImage(ImageLib.Images[DynamicObjIndex], ImageLib.Images[DynamicObjIndex].px + DynamicObjectMaxSizeHalf, ImageLib.Images[DynamicObjIndex].py + DynamicObjectMaxSizeHalf, TRUE);
            DynamicObjImage.Optimize;
          end;
          Inc(DynamicObjIndex)
        end;
      end;
  end;
end;

procedure TDynamicObject.Paint;
begin
  if DynamicObjImage <> nil then
    BackScreen.DrawImageKeyColor(DynamicObjImage, RealX - DynamicObjectMaxSizeHalf, RealY - DynamicObjectMaxSizeHalf);
  if StructedTick <> 0 then BackScreen.DrawStructed(RealX, RealY, 55, StructedPercent);
end;

function TDynamicObject.Update(CurTick: integer): Integer;
begin
  if FImagePP <> nil then FImagePP.rrunTick := CurTick;
  Result := 0;
  if StructedTick + 200 < CurTick then StructedTick := 0;
  if CurTick > DelayTick + DYNAMICOBJECTTIME then
  begin
    DelayTick := CurTick;
    SetFrame(DynamicObjectState, CurTick);
  end;
end;

//////////////////////////////////
//         Item Class
//////////////////////////////////

constructor TItemClass.Create(aAtzClass: TAtzClass);
begin
  FAtzClass := aAtzClass;
  ItemImage := TA2Image.Create(140, 140, 0, 0);
end;

destructor TItemClass.Destroy;
begin
  ItemImage.Free;
  inherited destroy;
end;

procedure TItemClass.SetItemAndColor(aItemshape, aItemColor: integer);
var
  gc, ga: integer;
  tempImage: TA2Image;
begin
  ItemShape := aItemShape;
  ItemColor := aItemColor;
  tempImage := FAtzClass.GetItemImage(ItemShape);
  if tempImage <> nil then
  begin
        // ItemImage.Free;
        // ItemImage := TA2Image.Create(140, 140, 0, 0);

    GetGreenColorAndAdd(ItemColor, gc, ga);
    ItemImage.DrawImageGreenConvert(TempImage, 70 - TempImage.Width div 2, 70 - TempImage.Height div 2, gc, ga);
        // ItemImage.Optimize;
  end else ItemImage.Clear(0);
  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
end;

procedure TItemClass.Initialize(aItemName: string; aRace: byte; aId, ax, ay, aItemshape, aItemcolor: integer);
var
  gc, ga: integer;
  tempImage: TA2Image;
begin
  ItemName := aItemName;
  id := aid;
  x := ax;
  y := ay;
  ItemShape := aItemShape;
  ItemColor := aItemColor;
  tempImage := FAtzClass.GetItemImage(ItemShape);
  ItemImage.Free;
  ItemImage := TA2Image.Create(140, 140, 0, 0);

  GetGreenColorAndAdd(ItemColor, gc, ga);

  ItemImage.DrawImageGreenConvert(TempImage, 70 - TempImage.Width div 2, 70 - TempImage.Height div 2, gc, ga);
  ItemImage.Optimize;

  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
  Race := aRace;
  FUsed := TRUE;
end;
{
procedure TItemClass.Finalize;
begin
    FUsed := FALSE;
    ItemName := '';
    id := 0;
    Race := RACE_ITEM;
end;
 }

procedure TItemClass.ChangeProperty(pCP: PTSChangeProperty);
begin
  ItemName := GetWordString(pCP.rWordString);
end;

function TItemClass.IsArea(ax, ay: integer): Boolean;
var
  xp, yp: integer;
  xx, yy: integer;
  pb: pword;
begin
  Result := TRUE;
  xx := RealX + ItemImage.px - 70;
  yy := RealY + ItemImage.py - 70;

  if (ax <= xx) then Result := FALSE;
  if (ay <= yy) then Result := FALSE;
  if ax >= xx + ItemImage.Width then Result := FALSE;
  if ay >= yy + ItemImage.Height then Result := FALSE;
  if Result = FALSE then exit;

  xp := ax - xx;
  yp := ay - yy;

  pb := PWORD(ItemImage.bits);
  inc(pb, xp + yp * ItemImage.Width);
  if pb^ = 0 then Result := FALSE;
end;

procedure TItemClass.Paint;
var
  TEMP: TA2Image;
begin
  BackScreen.DrawImage(ItemImage, RealX - 70, RealY - 70, TRUE);

    {if (Selecteditem = Id) or (ssAlt in KeyShift) then
    begin
    //描边
        temp := TA2Image.Create(32, 32, 0, 0);
        try
            ItemImage.CopyImage(temp);
            temp.delColor(31);
            temp.strokeCler(31);
            temp.stroke(WinRGB(0, 31, 0));
            temp.delColor(31);

                           // temp.addColor(3, 3, 3);
            BackScreen.DrawImage(temp, RealX - 70, RealY - 70, TRUE);
        finally
            temp.Free;
        end;
    end;
    }

end;

function TItemClass.Update(CurTick: integer): Integer;
begin
  Result := 0;
end;

//////////////////////////////////
//         Char Class     人物初始化绘画
//////////////////////////////////

constructor TCharClass.Create(aAtzClass: TAtzClass);
var
  i: integer;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  Randomize;
  RandomValue := Random(255) + 1;
  cImageBufferTempIndex := 0;
  cImageBufferTemp2CurTick := 0;
  cImageBufferTemp3CurTick := 0;
  cImageBufferTemp4CurTick := 0;
  FillChar(cImageArrGhost,SizeOf(cImageArrGhost),0);
  rbooth := false;
  rBoothName := '';
  rboothshape := 0;
    //tempboolean := false;
    //ImageBufList := TImageBufclass.Create(50);

  MessageList := TMessageListclass.Create;
  FboMOVE := true;
  FAtzClass := aAtzClass;
  ConsortName := '';

  BubbleList := TStringList.Create;
  BgEffect := TBgEffect.Create(FAtzClass);
  ScreenEffect := TBgEffect.Create(FAtzClass);
  MagicEffect := TBgEffect.Create(FAtzClass);

  BgEffectList := TBgEffectList.Create;

  MOverImage := nil;
  MImageBuffer := nil;
  mOverImagePP := nil;
  mImageBufferPP := nil;

  cImageBuffer := TA2Image.Create(32, 32, 0, 0);
//    cImageBufferTemp := TA2Image.Create(32, 32, 0, 0);
 //   cImageBufferTemp2 := TA2Image.Create(32, 32, 0, 0);
  cOverImage := nil;
  fillchar(cImageArrPP, sizeof(cImageArrPP), 0);
  cImageBuffer_w := nil;
  cImageArrw_PP := nil;
  cImageArrw_GhostPP := nil;

  cOverImagePP := nil;
//  cImageArrw_PP := nil;

  oldblock := -1;
{$I SE_PROTECT_END.inc}


end;

destructor TCharClass.Destroy;
begin
//    cImageBufferTemp.Free;
 //   cImageBufferTemp2.Free;
  cImageBuffer.Free;
  MessageList.Free;
  BubbleList.Free;

  BgEffect.Free;
  ScreenEffect.Free;
  MagicEffect.Free;

  if cOverImage <> nil then cOverImage := nil;
  BgEffectList.Free;
  inherited destroy;
end;

procedure TCharClass.AddScreenEffect(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean);
begin
  ScreenEffect.Initialize(aRealx, aRealy, aShape, aLightEffectKind, boBgOverValue);
end;

procedure TCharClass.AddMagicEffect(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; astat, aend: integer; boBgOverValue: boolean);
begin
  if astat >= 0 then
    MagicEffect.Initialize(aRealx, aRealy, aShape, aLightEffectKind, boBgOverValue, astat)
  else MagicEffect.Initialize(aRealx, aRealy, aShape, aLightEffectKind, boBgOverValue);
  if aend > 0 then MagicEffect.BgEffectNumEND := aend;
end;

procedure TCharClass.AddBgEffectList(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; rCount: Integer);
var
  temp: TBgEffect;
begin
  temp := BgEffectList.get(aShape, aRealx, aRealy);
  if temp <> nil then
  begin
    temp.RepeatCount := rCount;
    if (mmAnsTick - temp.fCreateTick) < 100 then
    begin
      exit;
    end;
  end;

  BgEffectList.CreateInitialize(FAtzClass, aRealx, aRealy, aShape, aLightEffectKind, boBgOverValue, 0, rCount);

end;

procedure TCharClass.AddBgEffect(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; boBgOverValue: boolean; rCount: Integer);
begin
  case aLightEffectKind of
    lek_none, lek_follow, lek_future:
      begin
        if rCount > 0 then
          BgEffect.Initialize(aRealx, aRealy, aShape, aLightEffectKind, boBgOverValue, 0, rCount)
        else
          BgEffect.RepeatCount := 0;
      end;
    lek_cumulate, lek_cumulate_follow:
      begin

        AddBgEffectList(aRealx, aRealy, aShape, aLightEffectKind, boBgOverValue, rCount);
      end;
  end;
  Feature.rEffectNumber := 0;
end;

procedure TCharClass.AddBufferEffect(pp: PTSChangeFeature);
var
  i, j, maxx: integer;
  boBgOverValue, boNoFound: boolean;
  temp: TBgEffect;
begin
  for j := 0 to BgEffectList.data.Count - 1 do
  begin
    temp := BgEffectList.getbyid(j);
    if temp.RepeatCount <> MaxRepeatCount then Continue;
    boNoFound := True;
    with pp^ do
    for i := 0 to rBuffEffectCount - 1 do
    begin
      if rBuffEffect[i] - 1 = temp.BgEffectShape then
        boNoFound := False;
    end;
    if boNoFound then
      temp.RepeatCount := 0;
  end;
  maxx := Length(pp^.rBuffEffect);
  with pp^ do
  for i := 0 to rBuffEffectCount - 1 do
  begin
    if i > maxx then Break;
    if rBuffEffect[i] > 255 then
      boBgOverValue := False
    else
      boBgOverValue := True;
    boNoFound := True;
    for j := 0 to BgEffectList.data.Count - 1 do
    begin
      temp := BgEffectList.getbyid(j);
      if rBuffEffect[i] - 1 = temp.BgEffectShape then
      begin
        boNoFound := False;
        Break;
      end;
    end;
    if boNoFound then
    AddBgEffectList(x, y, rBuffEffect[i] - 1, lek_cumulate_follow, boBgOverValue, MaxRepeatCount);
  end;
end;

procedure TCharClass.AddBufferEffect2(pp: PTSChangeFeature_Npc_MONSTER);
var
  i, j, maxx: integer;
  boBgOverValue, boNoFound: boolean;
  temp: TBgEffect;
begin
  for j := 0 to BgEffectList.data.Count - 1 do
  begin
    temp := BgEffectList.getbyid(j);
    if temp.RepeatCount <> MaxRepeatCount then Continue;
    boNoFound := True;
    with pp^ do
    for i := 0 to rBuffEffectCount - 1 do
    begin
      if rBuffEffect[i] - 1 = temp.BgEffectShape then
        boNoFound := False;
    end;
    if boNoFound then
      temp.RepeatCount := 0;
  end;
  maxx := Length(pp^.rBuffEffect);
  with pp^ do
  for i := 0 to rBuffEffectCount - 1 do
  begin
    if i > maxx then Break;
    if rBuffEffect[i] > 255 then
      boBgOverValue := False
    else
      boBgOverValue := True;
    boNoFound := True;
    for j := 0 to BgEffectList.data.Count - 1 do
    begin
      temp := BgEffectList.getbyid(j);
      if rBuffEffect[i] - 1 = temp.BgEffectShape then
      begin
        boNoFound := False;
        Break;
      end;
    end;
    if boNoFound then
      AddBgEffectList(x, y, rBuffEffect[i] - 1, lek_cumulate_follow, boBgOverValue, MaxRepeatCount);
  end;
end;

function TCharClass.GetArrImageLib(aindex, CurTick: integer): TA2ImageLib;
begin
  if not Feature.rboMan then
    Result := FAtzClass.GetImageLib(char(word('a') + aindex) + format('%d0.atz', [Feature.rArr[aindex * 2]]), CurTick)
  else
    Result := FAtzClass.GetImageLib(char(word('n') + aindex) + format('%d0.atz', [Feature.rArr[aindex * 2]]), CurTick);
end;

procedure TCharClass.MouseMove(x, y: integer);
begin
  if IsArea(x, y) then SelectedChar := id;
end;

function TCharClass.IsArea(ax, ay: integer): Boolean;
var
  xp, yp: integer;
  xx, yy: integer;
  pb: pword;
begin
  if rbooth then
  begin
    Result := false;
    xx := Realx + CharList.boothImageBuffer.px - CHarMaxSiezHalf;
    yy := Realy + CharList.boothImageBuffer.py - CHarMaxSiezHalf;

    if (ax <= xx) then exit;
    if (ay <= yy) then exit;
    if ax >= xx + CharList.boothImageBuffer.Width then exit;
    if ay >= yy + CharList.boothImageBuffer.Height then exit;
    xp := ax - xx;
    yp := ay - yy;

    pb := PWORD(CharList.boothImageBuffer.bits);
    inc(pb, xp + yp * CharList.boothImageBuffer.Width);
    if pb^ = 0 then exit;
    Result := true;
    exit;
  end;
  if (Feature.rMonType = 0) and ((Feature.rrace = RACE_MONSTER) or (Feature.rrace = RACE_NPC)) then
  begin
    Result := false;
    if MImageBuffer = nil then exit;
    xx := Realx + MImageBuffer.px;
    yy := Realy + MImageBuffer.py;

    if (ax <= xx) then exit;
    if (ay <= yy) then exit;
    if ax >= xx + MImageBuffer.Width then exit;
    if ay >= yy + MImageBuffer.Height then exit;
    xp := ax - xx;
    yp := ay - yy;

    pb := PWORD(MImageBuffer.bits);
    inc(pb, xp + yp * MImageBuffer.Width);
    if pb^ = 0 then exit;
    Result := true;
  end else
  begin
    Result := false;
    xx := Realx + cImageBuffer.px - CHarMaxSiezHalf;
    yy := Realy + cImageBuffer.py - CHarMaxSiezHalf;

    if (ax <= xx) then exit;
    if (ay <= yy) then exit;
    if ax >= xx + cImageBuffer.Width then exit;
    if ay >= yy + cImageBuffer.Height then exit;
    xp := ax - xx;
    yp := ay - yy;

    pb := PWORD(cImageBuffer.bits);
    inc(pb, xp + yp * cImageBuffer.Width);
    if pb^ = 0 then exit;
    Result := true;
  end;
end;
//安装  初始化

procedure TCharClass.Initialize(aName: string; aId, adir, ax, ay: integer; afeature: TFeature);
var
  akey: word;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  if afeature.rEncKey = 0 then begin
    x := ax;
    y := ay;
  end
  else begin
    akey := afeature.rEncKey;
    asm
      rol akey,7
    end;
    x := ax xor akey;
    y := ay xor akey;
    akey := 0;
  end;

  ChangeProperty(aName);
  id := aid;
  dir := adir;
  //x := ax;
  //y := ay;
  Feature := aFeature;
  Feature.rEncKey := 0;
  CurFrame := 1;
  CurActionInfo := nil;
  CurAction := -1;
  AniList := Animater.GetAnimationList(aFeature.raninumber);

  FUsed := TRUE;
  OldMakeFrame := -1;

  TurningTick := 0;
  StructedTick := 0;
  StructedPercent := 0;
  cImageBuffer.Setsize(CharMaxSiez, CharMaxSiez);
  MOverImage := nil;
  MImageBuffer := nil;
  mOverImagePP := nil;

  fillchar(cImageArrPP, sizeof(cImageArrPP), 0);
  cImageBuffer_w := nil;
  cImageArrw_PP := nil;
  cImageArrw_GhostPP := nil;

  cOverImagePP := nil;
  oldblock := -1;
{$I SE_PROTECT_END.inc}
end;
//卸载
{
procedure TCharClass.Finalize;
var
    i               :integer;
begin
    BgEffect.Finalize;
    MagicEffect.Finalize;
    ScreenEffect.Finalize;

    rName := '';
    id := 0;
    dir := 0;
    x := 0;
    y := 0;
    FillChar(Feature, sizeof(Feature), 0);
    FUsed := FALSE;
end;
}
//消息 消息

procedure TCharClass.Say(astr: string);
begin
  BubbleTick := mmAnsTick;
  BubbleList.Clear;
  BackScreen.GetBubble(BubbleList, astr);
end;

procedure TCharClass.SayItem(astr: string;
  AChatItemMessage: PTSChatItemMessage);
begin
  BubbleTick := mmAnsTick;
  if SayTick + 300 < mmAnsTick then      //2015.12.10 在水一方
    BubbleList.Clear;
  SayTick := mmAnsTick;
  BackScreen.GetBubbleEx(BubbleList, astr ,AChatItemMessage);
end;

procedure TCharClass.SayItemHead(astr: string;
  AChatItemMessage: PTSChatItemMessageHead);
begin
  BubbleTick := mmAnsTick;
  if SayTick + 300 < mmAnsTick then      //2015.12.10 在水一方
    BubbleList.Clear;
  SayTick := mmAnsTick;
  BackScreen.GetBubbleExHead(BubbleList, astr ,AChatItemMessage);
end;

//改变 名字

procedure TCharClass.ChangeProperty(str: string);
var
  strs: string;
begin
    // str := GetWordString(pd.rWordString);
  str := GetValidStr3(str, strs, ',');
  rName := strs;
  str := GetValidStr3(str, strs, ',');
  GuildName := strs;
  str := GetValidStr3(str, strs, ',');
  ConsortName := strs;

end;

function TCharClass.getname: string;
var
  i: integer;
  pb: pbyte;
  bb, rr: byte;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  Result := rFName;
  rr := RandomValue * 2 + 1;
  pb := @Result[1];
  for i := 1 to Length(Result) do
  begin
    bb := pb^;
    pb^ := bb xor rr;
    inc(pb);
  end;
{$I SE_PROTECT_END.inc}
end;

procedure TCharClass.setname(name: string);
var
  i: integer;
  pb: pbyte;
  bb, rr: byte;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  pb := @name[1];
  rr := RandomValue * 2 + 1;
  for i := 1 to Length(name) do
  begin
    bb := pb^;
    pb^ := bb xor rr;
    inc(pb);
  end;
  rFName := name;
{$I SE_PROTECT_END.inc}
end;

function TCharClass.getx: integer;
var
  rr: word;
  curEBP, val1, ms, me, rst, rdm, rm: Cardinal;
  p: ^Cardinal;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  {asm
    mov curEBP,ebp  ;
  end;
  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  p := Pointer(curEBP + 4);
  val1 := p^;
  if (val1 < ms) or (val1 > me) then begin
    Result := Random(255);
    exit;
  end;
  rr := (RandomValue * 3 + 17) div 3;
  Result := _x xor rr;}

  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  rst := Random(255);
  rdm := RandomValue;
  rm := _x;
  asm
    call @label_1;
    db  0cdh,0b0h;
    jmp  @label_4;
  @label_1:
    pop  eax;
    jmp  @label_2;
    db  0cdh,0b0h;
  @label_2:
    add  eax,2;
    jmp  @label_3;
    db  0f9h;
  @label_3:
    push eax;
    ret;
    db  0e9h;
  @label_4:
    mov curEBP,ebp  ;
    jmp  @label_7;
    db  0d9h;
  @label_5:
    jmp  @label_1;
    db  0c9h;
  @label_6:
    mov eax, curEBP;
    jmp  @label_10;
    db  0b9h;
  @label_7:
    add curEBP, 4;
    jmp  @label_6;
    db  0a9h;
  @label_8:
    cmp ms, eax;
    mov eax, rst;
    mov @result, eax;
    jmp  @label_end;
    ret;
    db  0c6h;
  @label_9:
    cmp me, eax;
    mov eax, rst;
    mov @result, eax;
    jmp  @label_end;
    ret;
    db  0c7h;
  @label_10:
    mov eax, [eax];
    cmp ms, eax;
    jnbe @label_9;
    cmp me, eax;
    jnae @label_8;
    jmp  @label_11;
    db  0c8h;
  @label_11:
    mov eax, rdm;
    movzx eax, ax;
    lea eax, [eax+eax*2];
    add eax, 24;
    mov ecx, 3;
    xor edx, edx;
    div ecx;
    xor eax, rm;
    mov @result,eax;
    jmp  @label_end;
    db  0cdh;
  @label_end:
  end;
{$I SE_PROTECT_END.inc}
end;

procedure TCharClass.setx(value: integer);
var
  rr: word;
  curEBP, val1, ms, me, rdm, rm: Cardinal;
  p: ^Cardinal;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  {rr := (RandomValue * 3 + 17) div 3;
  _x := value xor rr;}

  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  rdm := RandomValue;
  rm := value;
  asm
    call @label_1;
    db  0cdh,0b0h;
    jmp  @label_4;
  @label_1:
    pop  eax;
    jmp  @label_2;
    db  0cdh,0b0h;
  @label_2:
    add  eax,2;
    jmp  @label_3;
    db  0f9h;
  @label_3:
    push eax;
    ret;
    db  0e9h;
  @label_4:
    mov curEBP,ebp  ;
    jmp  @label_7;
    db  0d9h;
  @label_5:
    jmp  @label_1;
    db  0c9h;
  @label_6:
    mov eax, curEBP;
    jmp  @label_10;
    db  0b9h;
  @label_7:
    add curEBP, 4;
    jmp  @label_6;
    db  0a9h;
  @label_8:
    cmp ms, eax;
    jmp  @label_end;
    ret;
    db  0c6h;
  @label_9:
    cmp me, eax;
    jmp  @label_end;
    ret;
    db  0c7h;
  @label_10:
    mov eax, [eax];
    cmp ms, eax;
    jnbe @label_9;
    cmp me, eax;
    jnae @label_8;
    jmp  @label_11;
    db  0c8h;
  @label_11:
    mov eax, rdm;
    movzx eax, ax;
    lea eax, [eax+eax*2];
    add eax, 24;
    mov ecx, 3;
    xor edx, edx;
    div ecx;
    xor eax, rm;
    mov rm,eax;
    jmp  @label_end;
    db  0cdh;
  @label_end:
  end;
  _x := rm;
{$I SE_PROTECT_END.inc}
end;

function TCharClass.gety: integer;
var
  rr: word;
  curEBP, val1, ms, me, rst, rdm, rm: Cardinal;
  p: ^Cardinal;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  {asm
    mov curEBP,ebp  ;
  end;
  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  p := Pointer(curEBP + 4);
  val1 := p^;
  if (val1 < ms) or (val1 > me) then begin
    Result := Random(255);
    exit;
  end;
  rr := (RandomValue * 3 + 17) div 3;
  Result := _y xor rr;}
  
  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  rst := Random(255);
  rdm := RandomValue;
  rm := _y;
  asm
    call @label_1;
    db  0cdh,0b0h;
    jmp  @label_4;
  @label_1:
    pop  eax;
    jmp  @label_2;
    db  0cdh,0b0h;
  @label_2:
    add  eax,2;
    jmp  @label_3;
    db  0f9h;
  @label_3:
    push eax;
    ret;
    db  0e9h;
  @label_4:
    mov curEBP,ebp  ;
    jmp  @label_7;
    db  0d9h;
  @label_5:
    jmp  @label_1;
    db  0c9h;
  @label_6:
    mov eax, curEBP;
    jmp  @label_10;
    db  0b9h;
  @label_7:
    add curEBP, 4;
    jmp  @label_6;
    db  0a9h;
  @label_8:
    cmp ms, eax;
    mov eax, rst;
    mov @result, eax;
    jmp  @label_end;
    ret;
    db  0c6h;
  @label_9:
    cmp me, eax;
    mov eax, rst;
    mov @result, eax;
    jmp  @label_end;
    ret;
    db  0c7h;
  @label_10:
    mov eax, [eax];
    cmp ms, eax;
    jnbe @label_9;
    cmp me, eax;
    jnae @label_8;
    jmp  @label_11;
    db  0c8h;
  @label_11:
    mov eax, rdm;
    movzx eax, ax;
    lea eax, [eax+eax*2];
    add eax, 28;
    mov ecx, 3;
    xor edx, edx;
    div ecx;
    xor eax, rm;
    mov @result,eax;
    jmp  @label_end;
    db  0cdh;
  @label_end:
  end;
{$I SE_PROTECT_END.inc}
end;

procedure TCharClass.sety(value: integer);
var
  rr: word;
  curEBP, val1, ms, me, rdm, rm: Cardinal;
  p: ^Cardinal;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  {rr := (RandomValue * 3 + 17) div 3;
  _y := value xor rr;}

  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  rdm := RandomValue;
  rm := value;
  asm
    call @label_1;
    db  0cdh,0b0h;
    jmp  @label_4;
  @label_1:
    pop  eax;
    jmp  @label_2;
    db  0cdh,0b0h;
  @label_2:
    add  eax,2;
    jmp  @label_3;
    db  0f9h;
  @label_3:
    push eax;
    ret;
    db  0e9h;
  @label_4:
    mov curEBP,ebp  ;
    jmp  @label_7;
    db  0d9h;
  @label_5:
    jmp  @label_1;
    db  0c9h;
  @label_6:
    mov eax, curEBP;
    jmp  @label_10;
    db  0b9h;
  @label_7:
    add curEBP, 4;
    jmp  @label_6;
    db  0a9h;
  @label_8:
    cmp ms, eax;
    jmp  @label_end;
    ret;
    db  0c6h;
  @label_9:
    cmp me, eax;
    jmp  @label_end;
    ret;
    db  0c7h;
  @label_10:
    mov eax, [eax];
    cmp ms, eax;
    jnbe @label_9;
    cmp me, eax;
    jnae @label_8;
    jmp  @label_11;
    db  0c8h;
  @label_11:
    mov eax, rdm;
    movzx eax, ax;
    lea eax, [eax+eax*2];
    add eax, 28;
    mov ecx, 3;
    xor edx, edx;
    div ecx;
    xor eax, rm;
    mov rm,eax;
    jmp  @label_end;
    db  0cdh;
  @label_end:
  end;
  _y := rm;
{$I SE_PROTECT_END.inc}
end;

function TCharClass.getrealx: integer;
var
  rr: word;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  rr := (RandomValue * 3 + 17) div 3;
  Result := _realx xor rr;
{$I SE_PROTECT_END.inc}
end;

procedure TCharClass.setrealx(value: integer);
var
  rr: word;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  rr := (RandomValue * 3 + 17) div 3;
  _realx := value xor rr;
{$I SE_PROTECT_END.inc}
end;

function TCharClass.getrealy: integer;
var
  rr: word;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  rr := (RandomValue * 3 + 17) div 3;
  Result := _realy xor rr;
{$I SE_PROTECT_END.inc}
end;

procedure TCharClass.setrealy(value: integer);
var
  rr: word;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  rr := (RandomValue * 3 + 17) div 3;
  _realy := value xor rr;
{$I SE_PROTECT_END.inc}
end;

function TCharClass.ProcessMessagerun(aMsg, adir, ax, ay: Integer; afeature: TFeature; amotion: integer): Integer;
var
  RMsg: TRecordMessage;
begin
  RMsg.rMsg := aMsg;
  RMsg.rdir := adir;
  Rmsg.rx := ax;
  RMsg.ry := ay;
  RMsg.rfeature := aFeature;
  Rmsg.rmotion := amotion;
  MessageList.add(@RMsg);
end;

function TCharClass.ProcessMessage(aMsg, adir, _ax, _ay: Integer; afeature: TFeature; amotion: integer): Integer;
var
  CurTick: integer;
  xx, yy: word;
  ax, ay: Integer;
  akey: Word;
  i: integer;
    //   RMsg : TRecordMessage;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  if afeature.rEncKey = 0 then begin
    ax := _ax;
    ay := _ay;
  end
  else begin
    akey := afeature.rEncKey;
    asm
      rol akey,4
    end;
    ax := _ax xor akey;
    ay := _ay xor akey;
  end;
  rspecialShowState := false;
    // CurAction := 0;
  Result := 0;
  CurTick := mmAnsTick;
  OldMakeFrame := -1;
    {
       if (CurActionInfo <> nil) and (id <> CharCenterId) then begin
          RMsg.rMsg := aMsg;
          RMsg.rdir := adir;
          Rmsg.rx := ax;
          RMsg.ry := ay;
          RMsg.rfeature := aFeature;
          Rmsg.rmotion := amotion;
          AddMessage (RMsg);
          exit;
       end;
    }
  case amsg of
    SM_STRUCTED: //头顶 血条
      begin
        StructedTick := CurTick;
        StructedPercent := amotion;
      end;
    SM_SAY: ;

    SM_CHANGEFEATURE:
      begin



        if Feature.raninumber <> afeature.raninumber then
          AniList := Animater.GetAnimationList(afeature.raninumber);
        dir := adir;
        x := ax;
        y := ay;

        if (Feature.rfeaturestate <> wfs_sitdown)
          and (aFeature.rFeatureState = wfs_sitdown) then
        begin
          CurActionInfo := FindAnimation(AM_SEATDOWN, dir);
          SetCurrentFrame(CurActionInfo, 0, CurTick);
          CurAction := SM_MOTION;
        end;

        if (Feature.rfeaturestate = wfs_sitdown)
          and (aFeature.rFeatureState <> wfs_sitdown) then
        begin
          CurActionInfo := FindAnimation(AM_STANDUP, dir);
          SetCurrentFrame(CurActionInfo, 0, CurTick);
          CurAction := SM_MOTION;
        end;

        if (Feature.rfeaturestate <> wfs_die)
          and (aFeature.rFeatureState = wfs_die) then
        begin
          CurActionInfo := FindAnimation(AM_DIE, dir);
          SetCurrentFrame(CurActionInfo, 0, CurTick);
          CurAction := SM_MOTION;
        end;

        Feature := aFeature;
        if CurActionInfo <> nil then
        begin
          CurActionInfo := FindAnimation(CurMOTION, CurMOTION_dir);
          SetCurrentFrame(CurActionInfo, Curframe, CurTick);
        end;

        if Feature.rEffectNumber > 0 then
        begin
          AddBgEffect(ax, ay, Feature.rEffectNumber - 1, Feature.rEffectKind, TRUE);
        end;

        fillchar(cImageArrPP, sizeof(cImageArrPP), 0);
        cImageBuffer_w := nil;
        cImageArrw_PP := nil;
        cImageArrw_GhostPP := nil;

        cOverImagePP := nil;

        mOverImagePP := nil;
        mImageBufferPP := nil;

        oldblock := -1;

      end;
    SM_SETPOSITION:
      begin
        dir := adir;
        x := ax;
        y := ay;
        Feature := aFeature;
        CurActionInfo := FindAnimation(AM_TURN, dir);
        SetCurrentFrame(CurActionInfo, 0, CurTick);
        CurAction := SM_TURN;
      end;
    SM_TURN:
            //转方向
      begin
        dir := adir;
        //x := ax;
        //y := ay;
        Feature := aFeature;
        CurActionInfo := FindAnimation(AM_TURN, dir);
        SetCurrentFrame(CurActionInfo, 0, CurTick);
        CurAction := SM_TURN;
      end;
    SM_MOTION:
      begin

        dir := adir;
        x := ax;
        y := ay;
                //Feature.rhitmotion := amotion;
        CurActionInfo := FindAnimation(amotion, dir);
        SetCurrentFrame(CurActionInfo, 0, CurTick);
        CurAction := SM_MOTION;

                //cOverImagePP := nil;
      end;
    SM_MOVE:
            //移动
      begin
       // FrmBottom.AddChat('接收移动，' + inttostr(adir) + '坐标 X:' + inttostr(ax) + ' Y:' + inttostr(ay), WinRGB(22, 22, 0), 0);

        xx := ax;
        yy := ay;
                //计算 下个坐标
        GetNextPosition(adir, xx, yy);
        x := xx;
        y := yy;
        dir := adir;
       // FrmBottom.AddChat('执行移动，' + inttostr(dir) + '坐标 X:' + inttostr(x) + ' Y:' + inttostr(y), WinRGB(22, 22, 0), 0);

        CurActionInfo := FindAnimation(AM_MOVE, dir);
        //if CurActionInfo.FrameTime = 6 then
        //  CurActionInfo.FrameTime := 8;     //2015.11.15 在水一方  手动设定
        SetCurrentFrame(CurActionInfo, 0, CurTick);
        CurAction := SM_MOVE;
      end;
  end;
  ax := 0;
  ay := 0;
  akey := 0;
{$I SE_PROTECT_END.inc}
end;

function TCharClass.FindAnimation(aact, adir: Integer): PTAniInfo;
var
  i, t1: Integer;
  ainfo: PTAniInfo;
begin
  Result := nil;
  CurMOTION := aact;
  CurMOTION_dir := adir;
  case Feature.rFeaturestate of
    wfs_normal: if aact = AM_TURN then aact := AM_TURN;
    wfs_care: if aact = AM_TURN then aact := AM_TURN1;
    wfs_sitdown: if aact = AM_TURN then aact := AM_TURN2;
    wfs_die: if aact = AM_TURN then aact := AM_TURN3;
    wfs_running: if aact = AM_TURN then aact := AM_TURN4;
    wfs_running2: if aact = AM_TURN then aact := AM_TURN5;
  end;

  case Feature.rFeaturestate of
    wfs_normal: if aact = AM_TURNNING then aact := AM_TURNNING;
    wfs_care: if aact = AM_TURNNING then aact := AM_TURNNING1;
    wfs_sitdown: if aact = AM_TURNNING then aact := AM_TURNNING2;
    wfs_die: if aact = AM_TURNNING then aact := AM_TURNNING3;
    wfs_running: if aact = AM_TURNNING then aact := AM_TURNNING4;
    wfs_running2: if aact = AM_TURNNING then aact := AM_TURNNING5;
  end;

  case Feature.rFeaturestate of
    wfs_normal: if aact = AM_MOVE then aact := AM_MOVE;
    wfs_care: if aact = AM_MOVE then aact := AM_MOVE1;
    wfs_sitdown: if aact = AM_MOVE then aact := AM_MOVE2;
    wfs_die: if aact = AM_MOVE then aact := AM_MOVE3;
    wfs_running: if aact = AM_MOVE then aact := AM_MOVE4;
    wfs_running2: if aact = AM_MOVE then aact := AM_MOVE5;
  end;

  for i := 0 to AniList.Count - 1 do
  begin
    ainfo := AniList[i];
    if (ainfo.Action = aact) and (ainfo.direction = adir) then
    begin
      Result := ainfo;
      break;
    end;
  end;

  if Result <> nil then
  begin
    CurActionInfoBak := Result^;
        //计算 动画 速度
    i := CurActionInfoBak.FrameTime * CurActionInfoBak.Frame;
    case CurMOTION of
      AM_MOVE..AM_MOVE9:
        begin
          if Feature.WalkSpeed = 0 then exit;
          if i > Feature.WalkSpeed then
          begin
            CurActionInfoBak.FrameTime := Feature.WalkSpeed div CurActionInfoBak.Frame;
          end;
        end;
      AM_HIT..AM_HIT9:
        begin
          if Feature.AttackSpeed = 0 then exit;
          if i > Feature.AttackSpeed then
          begin
            CurActionInfoBak.FrameTime := Feature.AttackSpeed div CurActionInfoBak.Frame;
          end;
        end; //攻击
    end;
  end;
end;
//设置  动画 一帧

procedure TCharClass.SetCurrentFrame(aAniInfo: PTAniInfo; aFrame, CurTime: integer);
begin
  if aAniInfo = nil then
  begin
    Error := 10;
    exit;
  end;

  FrameStartTime := CurTime;
  Curframe := aFrame;
  ImageNumber := aAniInfo^.Frames[CurFrame];
  RealX := x * UNITX + aAniInfo^.Pxs[CurFrame] + UNITXS;
  RealY := y * UNITY + aAniInfo^.Pys[CurFrame] - UNITYS;
end;

procedure TCharClass.DrawWearHeadPortrait(aHeadP: TA2Image);
var
  i, gc, ga: integer;

  ImageLib: TA2ImageLib;
  ttImage: TA2Image;
begin

  ttImage := TA2Image.Create(56, 72, 0, 0);
  try

    ttImage.Clear(0);

    for i := 0 to 10 - 1 do
    begin
      ImageLib := GetArrImageLib(i, mmAnsTick);
      if ImageLib <> nil then
      begin
        GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
        if Feature.rArr[i * 2 + 1] = 0 then
          ttImage.DrawImage(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, TRUE)
        else
          ttImage.DrawImageGreenConvert(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, gc, ga);
      end;
    end;
        //拷贝出来 头像
    i := ((ttImage.Width - aHeadP.Width) div 2);
    i := i - 5;
    ttImage.GetImage(aHeadP, i, 0);
  finally
    ttImage.Free;
  end;

end;

function TCharClass.AllowAddAction: Boolean;
begin
  Result := FALSE;
  if id = CharCenterId then
  begin
    if CharCenterLockMoveTick > mmAnsTick then exit;
  end;
    //if MessageList.fdata.Count > 0 then exit;

  if FboMOVE = false then exit;

  if Feature.rfeaturestate = wfs_die then //死亡
  begin
    Result := FALSE;
    exit;
  end;
  //2015年11月18日 13:23:01 修改屏蔽 打坐状态 移动以及切换状态
  //if Feature.rfeaturestate = wfs_sitdown then //打坐
  //begin
  //  Result := FALSE;
  //  exit;
  //end;
    //----------------------------------------------------------------------------

  if CurActionInfo = nil then //无动画
  begin
    Result := TRUE;
    exit;
  end;
  if (CurAction = SM_TURN) then Result := TRUE;
  if (CurActionInfo^.Frame - 2 = curframe) then Result := TRUE;
  if Feature.rfeaturestate = wfs_die then Result := FALSE;
  if Feature.rfeaturestate = wfs_sitdown then Result := FALSE;

    {Result := FALSE;
    if CurActionInfo = nil then begin Result := TRUE; exit; end;
    if (CurAction = SM_TURN) then Result := TRUE;
    if (CurActionInfo^.Frame-2 = curframe) then Result := TRUE;
    if Feature.rfeaturestate = wfs_die then Result := FALSE;
    if Feature.rfeaturestate = wfs_sitdown then Result := FALSE;}
end;

procedure TCharClass.MakeFrame(aindex, CurTick: integer); //aindex 图象序号
var
  c1, c2, block: integer;
  tt2: TA2Image;
  addx, addy, gc, ga: integer;
  procedure _MagicDraw();
  begin
    with Feature do //Feature外观描述
    begin
            //武功 效果 刀光效果
      if rspecialShowState and (CurAction = SM_MOTION) then
      begin
        c1 := 0;
        if (rspecialMagicType >= 0) then // and (rhitmotion >= 30) and (rhitmotion <= 39) then
        begin
          case rspecialMagicType of
            0..99:
              begin
                c1 := 1;
                c2 := rspecialMagicType;
              end;
            100..199:
              begin
                c1 := 2;
                c2 := rspecialMagicType - 100;
              end;
            300..399:
              begin
                c1 := 3;
                c2 := rspecialMagicType - 300;
              end;
          end;

                    //-----------------------------------------------
          if (c1 <> oldC1)
            or (c2 <> oldC2)
            or (rspecialEffectColor <> oldspecialEffectColor) then
          begin
            cOverImagePP := nil;
          end;
                    //-----------------------------------------------

          if c1 > 0 then
          begin
            if cOverImagePP = nil then
            begin
              cOverImagePP := FAtzClass.AtzList.GetImageLibPP(
                format('_%d%d%d.atz', [c1, c2, rspecialEffectColor]),
                CurTick);
              oldC1 := c1;
              oldC2 := c2;
              oldspecialEffectColor := rspecialEffectColor;
            end;
            if (cOverImagePP <> nil) and (cOverImagePP.rImageLib <> nil) then
            begin
              cOverImage := cOverImagepp.rImageLib.Images[bidx];
            end;
          end;
        end;
      end;
    end;
  end;

  procedure _ShadowDraw(); //阴影
  begin
    with Feature do //Feature外观描述
    begin
            //>>>>>>阴影
      if cImageArrPP[10] = nil then
      begin
        if not rboMan then
          cImageArrPP[10] := FAtzClass.AtzList.GetImageLibPP(
            format('0%d%d.atz', [rArr[0], block]),
            CurTick) //女
        else
          cImageArrPP[10] := FAtzClass.AtzList.GetImageLibPP(
            format('1%d%d.atz', [rArr[0], block]),
            CurTick); //男
      end;
      if (cImageArrPP[10] <> nil) and (cImageArrPP[10].rImageLib <> nil) then
        cImageBuffer.DrawImage(
          cImageArrPP[10].rImageLib.Images[bidx],
          cImageArrPP[10].rImageLib.Images[bidx].px + CHarMaxSiezHalf,
          cImageArrPP[10].rImageLib.Images[bidx].py + CHarMaxSiezHalf,
          FALSE);
    end;
  end;

  procedure _BasicDraw(); //光人
  var
    i: integer;
  begin
    with Feature do //Feature外观描述
    begin
            //>>>>>>全部光人外观（不包含装备） 0整体外观 1 2 3 4 5
      for i := 0 to 5 do //a b c d e f 0-5
      begin
        if (i <> 0) and (Feature.rArr[i * 2] = 0) then continue;
        if cImageArrPP[i] = nil then
        begin
          if not rboMan then
            cImageArrPP[i] := FAtzClass.AtzList.GetImageLibPP(
              char(word('a') + i) + format('%d%d.atz',
              [Feature.rArr[i * 2], block]), CurTick)
          else
            cImageArrPP[i] := FAtzClass.AtzList.GetImageLibPP(
              char(word('n') + i) + format('%d%d.atz',
              [Feature.rArr[i * 2], block]), CurTick);
        end;

        if (cImageArrPP[i] = nil) then continue;
        if (cImageArrPP[i].rImageLib = nil) then continue;
        if (cImageArrPP[i].rImageLib.Count <= bidx) then continue;
        if (cImageArrPP[i].rImageLib.Images[bidx] = nil) then continue;

        if Feature.rArr[i * 2 + 1] = 0 then //rArr 一共32个
        begin
                    //直接绘画
          cImageBuffer.DrawImage(
            cImageArrPP[i].rImageLib.Images[bidx],
            cImageArrPP[i].rImageLib.Images[bidx].px + addx,
            cImageArrPP[i].rImageLib.Images[bidx].py + addy,
            TRUE)
        end else
        begin
                    //换色 方式   绘画
          GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
          cImageBuffer.DrawImageGreenConvert(
            cImageArrPP[i].rImageLib.Images[bidx],
            cImageArrPP[i].rImageLib.Images[bidx].px + addx,
            cImageArrPP[i].rImageLib.Images[bidx].py + addy,
            gc,
            ga);
        end;
      end;
    end;
  end;

  procedure _ApparelDraw(); //穿戴
  var
    i: integer;
  begin
        //g 6号衣装（包括手）
        //h 7 头发
        //i 8 头装备
    for i := 6 to 8 do //g h i j 6-9
    begin
      if (i <> 0) and (Feature.rArr[i * 2] = 0) then continue;
      if cImageArrPP[i] = nil then
      begin
        if not Feature.rboMan then
          cImageArrPP[i] := FAtzClass.AtzList.GetImageLibPP(
            char(word('a') + i)
            + format('%d%d.atz', [Feature.rArr[i * 2], block]),
            CurTick)
        else
          cImageArrPP[i] := FAtzClass.AtzList.GetImageLibPP(
            char(word('n') + i)
            + format('%d%d.atz', [Feature.rArr[i * 2], block]),
            CurTick);
      end;

      if cImageArrPP[i] = nil then continue;
      if cImageArrPP[i].rImageLib = nil then continue;
      if cImageArrPP[i].rImageLib.Count <= bidx then continue;
      if cImageArrPP[i].rImageLib.Images[bidx] = nil then Continue;

      if Feature.rArr[i * 2 + 1] = 0 then
      begin
        cImageBuffer.DrawImage(
          cImageArrPP[i].rImageLib.Images[bidx],
          cImageArrPP[i].rImageLib.Images[bidx].px + addx,
          cImageArrPP[i].rImageLib.Images[bidx].py + addy,
          TRUE)
      end else
      begin
        GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
        cImageBuffer.DrawImageGreenConvert(
          cImageArrPP[i].rImageLib.Images[bidx],
          cImageArrPP[i].rImageLib.Images[bidx].px + addx,
          cImageArrPP[i].rImageLib.Images[bidx].py + addy,
          gc,
          ga);
      end;
    end;
  end;

  procedure _UpdateGhost(AnsImage, LightImage: TA2Image; x, y: Integer; acol, defaultadd: word);
  begin
    if (Curframe < 0) or (Curframe > High(cImageArrGhost)) then exit;
    cImageBufferTemp3CurTick := CurTick;
    with cImageArrGhost[Curframe] do
    begin
      aImg := AnsImage;
      aLightImg := LightImage;
      ax := x;
      ay := y;
      bx := x;
      by := y;
      gc := acol;
      ga := defaultadd;
      atick := CurTick;
    end;
  end;

  procedure _WEAPONDraw();
  var
    i: integer;
    lightname: string;
  begin
        //先画9号 9号武器
    for i := 9 to 9 do
    begin
      if (i <> 0) and (Feature.rArr[i * 2] = 0) then continue;
      if _test_test_mode then begin
        if _test_delete_mode or (_test_remove_filename <> '') then begin
          pgkeft_W.fboUPdate := True;
          pgkeft_W.fboWrite := True;
          if _test_remove_filename = '' then begin
            if not Feature.rboMan then
              lightname := 'w_' + inttostr(_test_renderer_color) + char(word('a') + 9) + format('%d%d.atz', [Feature.rArr[i * 2], block])
            else
              lightname := 'w_' + inttostr(_test_renderer_color) + char(word('n') + 9) + format('%d%d.atz', [Feature.rArr[i * 2], block]);
          end
          else
            lightname := _test_remove_filename;
          if _test_renderer_color <> 0 then
            Feature.rEffect_WEAPON_color := 0;
          if _test_ghost_color <> 0 then
            Feature.rEffect_WEAPON_gcolor := 0;
          pgkeft_W.del(UpperCase(lightname));
          FAtzClass.AtzList.del(LowerCase(lightname));
          DeleteFile(FpkTempPath + Enc(AnsiUpperCase(lightname)) + '.dat');
          _test_delete_mode := False;
          _test_remove_filename := '';
        end;
        if Feature.rEffect_WEAPON_color <> _test_renderer_color then
          cImageArrPP[i] := nil;
        Feature.rEffect_WEAPON_color := _test_renderer_color;
        Feature.rEffect_WEAPON_gcolor := _test_ghost_color;
        Feature.rEffect_WEAPON_light := _test_renderer_light;
        Feature.rEffect_WEAPON_glight := _test_ghost_light;
        Feature.rEffect_WEAPON_flickspeed := _test_flick_speed;
        Feature.rEffect_WEAPON_showghost := _test_ghost_visible;
      end;
      if cImageArrPP[i] = nil then
      begin
        cImageArrw_PP := nil;
        cImageArrw_GhostPP := nil;
        if not Feature.rboMan then
        begin
          cImageArrPP[i] := FAtzClass.AtzList.GetImageLibPP(
            char(word('a') + 9)
            + format('%d%d.atz', [Feature.rArr[i * 2], block]),
            CurTick);
          if (Feature.rEffect_WEAPON_color > 0) and (Feature.rEffect_WEAPON_light > 0) then
          begin
            cImageArrw_PP := FAtzClass.AtzList.GetImageLib_WEAPONPP(
              char(word('a') + 9) + format('%d%d.atz', [Feature.rArr[i * 2], block]),
              Feature.rEffect_WEAPON_color,
              CurTick);
          end;
          if Feature.rEffect_WEAPON_showghost then
          begin
            cImageArrw_GhostPP := FAtzClass.AtzList.GetImageLib_WEAPONGHOSTPP(
              char(word('a') + 9) + format('%d%d.atz', [Feature.rArr[i * 2], block]),
              Feature.rEffect_WEAPON_gcolor,
              CurTick);
          end;
        end
        else
        begin
          cImageArrPP[i] := FAtzClass.AtzList.GetImageLibPP(
            char(word('n') + 9) + format('%d%d.atz', [Feature.rArr[i * 2], block]),
            CurTick);
          if Feature.rEffect_WEAPON_color > 0 then
          begin
            cImageArrw_PP := FAtzClass.AtzList.GetImageLib_WEAPONPP(
              char(word('n') + 9) + format('%d%d.atz', [Feature.rArr[i * 2], block]),
              Feature.rEffect_WEAPON_color,
              CurTick);
          end;
          if Feature.rEffect_WEAPON_showghost then
          begin
            cImageArrw_GhostPP := FAtzClass.AtzList.GetImageLib_WEAPONGHOSTPP(
              char(word('n') + 9) + format('%d%d.atz', [Feature.rArr[i * 2], block]),
              Feature.rEffect_WEAPON_gcolor,
              CurTick);
          end;
        end;
      end;
      if (cImageArrPP[i] = nil) then continue;
      if (cImageArrPP[i].rImageLib = nil) then continue;
      if (cImageArrPP[i].rImageLib.Count <= bidx) then continue;
      if (cImageArrPP[i].rImageLib.Images[bidx] = nil) then continue;

      if Feature.rArr[i * 2 + 1] = 0 then
      begin
        cImageBuffer.DrawImage(
          cImageArrPP[i].rImageLib.Images[bidx],
          cImageArrPP[i].rImageLib.Images[bidx].px + addx,
          cImageArrPP[i].rImageLib.Images[bidx].py + addy,
          TRUE);
        
        _UpdateGhost(
          cImageArrPP[i].rImageLib.Images[bidx],
          nil,
          RealX + cImageArrPP[i].rImageLib.Images[bidx].px + addx,
          RealY + cImageArrPP[i].rImageLib.Images[bidx].py + addy,
          0,
          0);
      end else
      begin
        GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
        cImageBuffer.DrawImageGreenConvert(
          cImageArrPP[i].rImageLib.Images[bidx],
          cImageArrPP[i].rImageLib.Images[bidx].px + addx,
          cImageArrPP[i].rImageLib.Images[bidx].py + addy,
          gc,
          ga);
        
        _UpdateGhost(
          cImageArrPP[i].rImageLib.Images[bidx],
          nil,
          RealX + cImageArrPP[i].rImageLib.Images[bidx].px + addx,
          RealY + cImageArrPP[i].rImageLib.Images[bidx].py + addy,
          gc,
          ga);
      end;
    end;
  end;
begin


  if aindex = OldMakeFrame then exit;

  OldMakeFrame := aindex;


  if (Feature.rTeamColor > 0) and (Feature.rTeamColor < 32) then
  begin
    caddx := 0;
    caddy := Feature.rTeamColor - Random(2);
    addx := CHarMaxSiezHalf;
    addy := CHarMaxSiezHalf - caddy;

  end else
  begin
    caddx := 0;
    caddy := 0;
    addx := CHarMaxSiezHalf;
    addy := CHarMaxSiezHalf;
  end;
  block := aindex div 500;
  bidx := aindex mod 500;

  MOverImage := nil;
  MImageBuffer := nil;

    //怪物---------------------------------------------------------------------------------------------------

  if (Feature.rMonType = 0) and ((Feature.rrace = RACE_MONSTER) or (Feature.rrace = RACE_NPC)) then
  begin
    with Feature do
    begin
      if mImageBufferPP = nil then mImageBufferPP := FAtzClass.AtzList.GetImageLibPP(format('z%d.atz', [rImageNumber]), CurTick);
      if (mImageBufferPP <> nil) and (mImageBufferPP.rImageLib <> nil) then
      begin
        mImageBufferPP.rrunTick := CurTick;
        MImageBuffer := mImageBufferPP.rImageLib[bidx];
      end;
      if mOverImagePP = nil then mOverImagePP := FAtzClass.AtzList.GetImageLibPP(format('z%dm.atz', [rImageNumber]), CurTick);

      if (mOverImagePP <> nil) and (mOverImagePP.rImageLib <> nil) then
      begin
        mOverImagePP.rrunTick := CurTick;
        MOverImage := mOverImagePP.rImageLib[bidx];
      end;
    end;
    exit;
  end;
    //人---------------------------------------------------------------------------------------------------

    //-----------------------------------------------
  if oldblock <> block then
  begin
    fillchar(cImageArrPP, sizeof(cImageArrPP), 0);
    oldblock := block;
  end;
  cOverImage := nil;
    //-----------------------------------------------

  _MagicDraw; //武功
  cImageBuffer.Setsize(CharMaxSiez, CharMaxSiez);
  if Feature.rhitmotion = AM_HIT4 then
  begin
    case dir of
      5, 6, 7, 0, 4: //上
        begin
          _ShadowDraw; //阴影
          _BasicDraw; //光人
          _ApparelDraw; //穿戴
          _WEAPONDraw; //武器
        end;
      1, 2, 3: //右 上
        begin
          _ShadowDraw; //阴影
          _WEAPONDraw; //武器
          _BasicDraw; //光人
          _ApparelDraw; //穿戴
        end;
    end;
  end else
  begin
    case dir of
      0, 1, 2, 3, 4: //上
        begin
          _ShadowDraw; //阴影
          _BasicDraw; //光人
          _ApparelDraw; //穿戴
          _WEAPONDraw; //武器
        end;
      5, 6, 7: //右 上
        begin
          _ShadowDraw; //阴影
          _WEAPONDraw; //武器
          _BasicDraw; //光人
          _ApparelDraw; //穿戴
        end;
    end;
  end;
  tt2 := TA2Image.Create(cImageBuffer.Width, cImageBuffer.Height, 0, 0);
  tt2.DrawImage(cImageBuffer, 0, 0, false);

  if fwide = 1024 then
    tt2.Resize(cImageBuffer.Width * 110 div 100, cImageBuffer.Height * 110 div 100); //调整人物大小 20131009
  cImageBuffer.DrawImage(tt2, 0, 0, false);
  tt2.Free;
  cImageBuffer.Optimize;
  cImageBufferTemp2CurTick := 0;

  //  cImageBuffer.DrawImage_(_dt_SoftLight, 0, 0, 0, 31, nil, cImageBuffer, 0, 0);
end;

procedure TCharClass.Paint(CurTick: integer);
var
  i, j: word;
  temp: TA2Image;

begin
  if rbooth then
  begin
    BackScreen.DrawImageKeyColor(CharList.boothImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
    exit;
  end;

  MakeFrame(ImageNumber, CurTick); //组织 图象
  if Feature.rMonType = 1 then
  begin
         //人形怪物
    BackScreen.DrawImageKeyColor(cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
    if cOverImage <> nil then BackScreen.DrawImageOveray(cOverImage, RealX, RealY, 20);
    if StructedTick <> 0 then BackScreen.DrawStructed(RealX, RealY, 36, StructedPercent); // Char 赣府困狼 俊呈瘤官
    exit;
  end;
  if (Feature.rrace = RACE_MONSTER) or (Feature.rrace = RACE_NPC) then
  begin
    case Feature.rHideState of
      hs_100: // 老馆利牢 葛嚼
        begin
                    // 透明 色替换成阴影
          if MImageBuffer <> nil then
          begin
            BackScreen.DrawImageKeyColor(MImageBuffer, RealX, RealY);
            if (SelectedChar = id) or (ssCtrl in KeyShift) then
            begin
                          //  BackScreen.DrawImageKeyColor(MImageBuffer, RealX, RealY);
                        //描边
                           { temp := TA2Image.Create(32, 32, 0, 0);
                            try
                                MImageBuffer.CopyImage(temp);
                                temp.delColor(31);
                                temp.strokeCler(31);
                                temp.stroke(30);
                                temp.delColor(31);
                              //  temp.addColor(6, 6, 6);

                                BackScreen.DrawImageAdd(temp, RealX, RealY);
                            finally
                                temp.Free;
                            end;
                           }
            end else
            begin

            end;
          end;
                    // 涂 方式 画
          if MOverImage <> nil then
            BackScreen.DrawImageOveray(MOverImage, RealX, RealY, 20);
        end;
      hs_1: // 篮脚吝烙 CharCenterID 老版快 荤侩磊祈狼肺 距埃颇鄂祸捞 啊固等 版快 Refracrange : 4 overValue : 3
        if MImageBuffer <> nil then
          BackScreen.DrawRefractive(MImageBuffer, RealX, RealY, 4, 3);
      hs_99: // 篮脚吝 荤侩磊啊 篮脚焊绰 付过殿阑 荤侩矫 距埃 焊捞绰版快 Refracrange : 4 overValue : 0
        if MImageBuffer <> nil then
          BackScreen.DrawRefractive(MImageBuffer, RealX, RealY, 4, 0);
    end;
  end else
  begin
        //   if CharImageBuffer[CharImageBufferIndex].aCharImage = nil then exit;
    case Feature.rHideState of
      hs_100: // 老馆利牢 葛嚼
        begin
                    // 透明 色替换成阴影
          BackScreen.DrawImageKeyColor(cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
          if SelectedChar = id then
          begin
                        //描边
                       { temp := TA2Image.Create(32, 32, 0, 0);
                        try
                            BackScreen.DrawImageKeyColor(cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
                            cImageBuffer.CopyImage(temp);
                            temp.delColor(31);
                            temp.strokeCler(31);
                            temp.stroke(30);
                            temp.delColor(31);

                           // temp.addColor(3, 3, 3);
                            BackScreen.DrawImageAdd(temp, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
                        finally
                            temp.Free;
                        end;}
          end else
          begin

          end;
          if CurTick > cImageBufferTemp2CurTick + 20 then
          begin
            cImageBufferTemp2CurTick := CurTick;
            if cImageArrw_PP = nil then
            begin
              cImageBuffer_w := nil;
            end else
            begin
              if cImageBufferTempIndexState then
              begin
                if CurTick > cImageBufferTemp4CurTick + 20 * Feature.rEffect_WEAPON_flickspeed div 100 then begin
                  cImageBufferTemp4CurTick := CurTick;
                  inc(cImageBufferTempIndex);
                end;
                if cImageBufferTempIndex >= 6 then
                begin
                  cImageBufferTempIndex := 6;
                  cImageBufferTempIndexState := false;
                end;
              end
              else
              begin
                if CurTick > cImageBufferTemp4CurTick + 20 * Feature.rEffect_WEAPON_flickspeed div 100 then begin
                  cImageBufferTemp4CurTick := CurTick;
                  dec(cImageBufferTempIndex);
                end;
                if cImageBufferTempIndex <= 3 then
                begin
                  cImageBufferTempIndex := 3;
                  cImageBufferTempIndexState := true;
                end;
              end;

              i := bidx * 4 + cImageBufferTempIndex - 2 - 1;
              cImageBuffer_w := cImageArrw_PP.rImageLib.Images[i];
            end;

          end; 
          if _test_ghost_mode or (Feature.rEffect_WEAPON_showghost and (CurAction = SM_MOTION)) then begin
            if (Curframe <= High(cImageArrGhost)) and (Curframe >= 0) and (cImageArrw_GhostPP <> nil) then begin
              i := bidx * 4 + 3;
              cImageArrGhost[Curframe].aLightImg := cImageArrw_GhostPP.rImageLib.Images[i];
              cImageArrGhost[Curframe].bx := RealX - CHarMaxSiezHalf - caddx;
              cImageArrGhost[Curframe].by := RealY - CHarMaxSiezHalf - caddy;
            end;
            for j := High(cImageArrGhost) downto 0 do begin
              with cImageArrGhost[j] do begin
              if (j > 1) and (aImg = cImageArrGhost[j-1].aImg) then Continue;
              if j >= _test_ghost_count then Continue;
              if (aLightImg <> nil) and (CurTick - atick < _test_ghost_delay div 10) then
                BackScreen.DrawImageGreenConvert2(aLightImg, bx, by, Feature.rEffect_WEAPON_gcolor,0,
                  Feature.rEffect_WEAPON_glight * (_test_ghost_delay - (CurTick - atick) * 10) div _test_ghost_delay);
              end;
            end;
          end;
          if cImageBuffer_w <> nil then
            BackScreen.DrawImageGreenConvert2(cImageBuffer_w, RealX - CHarMaxSiezHalf - caddx, RealY - CHarMaxSiezHalf - caddy,Feature.rEffect_WEAPON_color,0,Feature.rEffect_WEAPON_light);



                  //  BackScreen.DrawImageAdd(cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
                   // BackScreen.DrawImage_(_dt_SoftLight, 0.5, 0, 0, 31, @Darkentbl, cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
                    //BackScreen.DrawImage(FImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf,true);
                    // 涂 方式 画
          if cOverImage <> nil then
            BackScreen.DrawImageOveray(cOverImage, RealX, RealY, 20);
                    // BackScreen.DrawImageAdd(OverImage, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
        end;
      hs_0: // 不隐身
        if id = CharCenterID then
          BackScreen.DrawRefractive(cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf, 4, 3);
      hs_1: // 篮脚吝烙 CharCenterID 老版快 荤侩磊祈狼肺 距埃颇鄂祸捞 啊固等 版快 Refracrange : 4 overValue : 3
        BackScreen.DrawRefractive(cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf, 4, 3);
      hs_99: // 篮脚吝 荤侩磊啊 篮脚焊绰 付过殿阑 荤侩矫 距埃 焊捞绰版快 Refracrange : 4 overValue : 0
        BackScreen.DrawRefractive(cImageBuffer, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf, 4, 0);
    end;
  end;

    //画头顶血条
  if StructedTick <> 0 then BackScreen.DrawStructed(RealX, RealY, 36, StructedPercent); // Char 赣府困狼 俊呈瘤官
end;

procedure TCharClass.paint_Point(image: TA2Image; aw, ah: integer);
var
  tempimg: TA2Image;
  ax, ay: integer;
  t: TRect;
begin
    // tempimg := TA2Image.Create(40, 40, 0, 0);
  try
        //左上 坐标
    ax := CharPosX - (aw div 2);
    ay := CharPosY - (ah div 2);
        //自己坐标
    ax := x - ax;
    ay := y - ay;
        //象素坐标
    ax := trunc((ax / aw) * image.Width);
    ay := trunc((ay / ah) * image.Height);
    t := Rect(ax - 2, ay - 2, ax + 2, ay + 2);
    case Feature.rrace of
      RACE_MONSTER:
        if Feature.rHideState = hs_100 then
          image.EraseRect(t, ColorSysToDxColor(clRed));
      RACE_HUMAN:
        begin
          if CharCenterId = id then
            image.EraseRect(t, ColorSysToDxColor(clBlue))
          else
          begin
            if Feature.rHideState = hs_100 then
              image.EraseRect(t, ColorSysToDxColor(clYellow));
          end;
        end;
      RACE_NPC:
        if Feature.rHideState = hs_100 then
          image.EraseRect(t, ColorSysToDxColor(clLime));
    end;
        //中心对其
        //ax := ax - tempimg.Width div 2;
        //ay := ay - tempimg.Height div 2;
        //image.DrawImage(tempimg, ax, ay, false);

  finally
        // tempimg.Free;
  end;
end;


function TCharClass.Update(CurTick: integer): Integer;
  procedure _CurActionInfo_TURN;
  begin
    CurActionInfo := nil;

    if feature.rfeaturestate = wfs_die then
    begin
      CurActionInfo := FindAnimation(AM_DIE, dir);
      if CurActionInfo <> nil then
        SetCurrentFrame(CurActionInfo, CurActionInfo^.Frame - 1, mmAnsTick);
      CurAction := SM_TURN;
      exit;
    end;

    if CurTick > TurningTick + 200 then
       // if CurTick > TurningTick + 1 then
    begin
      TurningTick := CurTick;
      CurActionInfo := FindAnimation(AM_TURNNING, dir);
      SetCurrentFrame(CurActionInfo, 0, CurTick);
      CurAction := SM_TURN;
    end else
    begin
      CurActionInfo := FindAnimation(AM_TURN, dir);
      SetCurrentFrame(CurActionInfo, 0, CurTick);
      CurAction := SM_TURN;
    end;
  end;
var
  PassTick: integer;
  i: integer;
begin


  Result := 0;

    //----------------------------------------
  for i := 0 to high(cImageArrPP) do
  begin
    if cImageArrPP[i] <> nil then
      cImageArrPP[i].rrunTick := CurTick;
  end;

  if cImageArrw_PP <> nil then cImageArrw_PP.rrunTick := CurTick;
  if cImageArrw_GhostPP <> nil then cImageArrw_GhostPP.rrunTick := CurTick;
  if cOverImagePP <> nil then cOverImagePP.rrunTick := CurTick;
  if mImageBufferPP <> nil then mImageBufferPP.rrunTick := CurTick;
  if mOverImagePP <> nil then mOverImagePP.rrunTick := CurTick;
    //-----------------------------------------

    //冒泡 消息 定时 清除
  if (BubbleList.Count <> 0) and (BubbleTick + 300 < CurTick) then BubbleList.Clear;

  if StructedTick + 200 < CurTick then StructedTick := 0;
    //动画
  if (CurActionInfo <> nil) then
  begin
    PassTick := CurTick - FrameStartTime;
    if PassTick >= (CurActionInfoBak.Frametime) then
     //   if PassTick >= (CurActionInfo^.Frametime) then
    begin //换图片
      Result := 1;
      curframe := curframe + 1;
      if curframe >= CurActionInfo^.Frame then
        _CurActionInfo_TURN //恢复 站姿势
      else
        SetCurrentFrame(CurActionInfo, curframe, CurTick);
    end;
  end else
  begin
    _CurActionInfo_TURN; //恢复 站姿势
  end;
  SetCurrentPos();

  if CharCenterId = id then
  begin
    CharPosX := x;
    CharPosY := y;
    BackScreen.SetCenter(RealX, RealY);
    Map.SetCenter(x, y);
  end;
end;

///////////////////////////////////
//        Char List
///////////////////////////////////

constructor TCharList.Create(aAtzClass: TAtzClass);
begin
  MAP_EffectList := TBgEffectList.Create;
  boothImageBuffer := TA2Image.Create(160, 160, 0, 0);

  if pgkBmp.isfile('摊位形象1.bmp') then
  begin
    pgkBmp.getBmp('摊位形象1.bmp', boothImageBuffer);
    boothImageBuffer.TransparentColor := 0;
    boothImageBuffer.Optimize;
  end;
    {
       for i := 0 to 32-1 do
          ColorIndex[i] := WinRGB (Color16Table[i*3] shr 3, Color16Table[i*3+1] shr 3, Color16Table[i*3+2] shr 3);
    }
  FAtzClass := aAtzClass;
  CharDataList := TCharDataListclass.Create;
  ItemDataList := TList.Create;
  DynamicObjDataList := TList.Create;

  MagicDataList := TList.Create;

  VirtualObjectList := TVirtualObjectListClass.Create;
end;

destructor TCharList.Destroy;
var
  i: integer;
begin
  MAP_EffectList.Free;
  VirtualObjectList.Free;
  boothImageBuffer.Free;
  for i := 0 to MagicDataList.Count - 1 do TMovingMagicClass(MagicDataList[i]).Free;
  MagicDataList.Free;

  for i := 0 to ItemDataList.Count - 1 do TItemClass(ItemDataList[i]).Free;
  ItemDataList.Free;

  for i := 0 to DynamicObjDataList.Count - 1 do TDynamicObject(DynamicObjDataList[i]).Free; // Dynamicitem
  DynamicObjDataList.Free;

  CharDataList.Free;

  inherited destroy;
end;

procedure TCharList.Clear;
var
  i: integer;
begin
  for i := 0 to ItemDataList.Count - 1 do TItemClass(ItemDataList[i]).free;
  ItemDataList.Clear;

  CharDataList.Clear;
  for i := 0 to MagicDataList.Count - 1 do TMovingMagicClass(MagicDataList[i]).Free;
  MagicDataList.Clear;
  for i := 0 to DynamicObjDataList.Count - 1 do TDynamicObject(DynamicObjDataList[i]).free;
  DynamicObjDataList.Clear;
end;

procedure TCharList.CharAdd(aName: Widestring; aId, adir, ax, ay: integer; afeature: TFeature);
begin
  CharDataList.Add(aName, aid, adir, ax, ay, afeature);
end;

function TCharList.CharGet(aId: integer): TCharClass;
begin
  result := CharDataList.getId(aid);
end;

function TCharList.CharGetAllName(): string;
begin
  result := CharDataList.getAllName;
end;

function TCharList.CharGetTlist(): tlist;
begin
  result := CharDataList.fdata;
end;

procedure TCharList.CharDelete(aId: integer);
begin
  CharDataList.del(aid);
end;

procedure TCharList.AddItem(aItemName: string; aRace: byte; aId, ax, ay, aItemShape, aItemColor: integer);
var
  i: integer;
  ItemClass: TItemClass;
begin

    //没有 新增加
  ItemClass := TItemClass.Create(FAtzClass);
  ItemClass.Initialize(aItemName, aRace, aId, ax, ay, aItemShape, aItemColor);
  ItemDataList.Add(ItemClass);

end;

function TCharList.GetItem(aId: integer): TItemClass;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ItemDataList.Count - 1 do
  begin
        // if TItemClass(ItemDataList[i]).Used = FALSE then continue;
    if TItemClass(ItemDataList[i]).Id = aId then
    begin
      Result := TItemClass(ItemDataList[i]);
      exit;
    end;
  end;
end;

procedure TCharList.DelItem(aId: integer);
var
  i: integer;
begin
  for i := 0 to ItemDataList.Count - 1 do
  begin
        // if TItemClass(ItemDataList[i]).Used = FALSE then continue;
    if TItemClass(ItemDataList[i]).Id = aId then
    begin
      TItemClass(ItemDataList[i]).free;
      ItemDataList.Delete(i);
      exit;
    end;
  end;
end;

procedure TCharList.AddDynamicObjItem(aItemName: string; aId, ax, ay, aItemShape: integer; aStartFrame, aEndFrame: Word; aState: byte; aDynamicGuard: TDynamicGuard);
var
  i: integer;
  DynamicObject: TDynamicObject;
begin
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    DynamicObject := DynamicObjDataList[i];
    if DynamicObject.Used = FALSE then
    begin
      DynamicObject.Initialize(aItemName, aId, ax, ay, aItemShape, aStartFrame, aEndFrame, aState, aDynamicGuard);
      exit;
    end;
  end;
  DynamicObject := TDynamicObject.Create(FAtzClass);
  DynamicObject.Initialize(aItemName, aId, ax, ay, aItemShape, aStartFrame, aEndFrame, aState, aDynamicGuard);
  DynamicObjDataList.Add(DynamicObject);
end;

procedure TCharList.SetDynamicObjItem(aId: integer; aState: byte; aStartFrame, aEndFrame: Word);
var
  i: integer;
  DynamicObject: TDynamicObject;
begin
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    DynamicObject := DynamicObjDataList[i];
    if DynamicObject.Id = aID then
    begin
      DynamicObject.DynamicObjectState := aState;
      DynamicObject.FStartFrame := aStartFrame;
      DynamicObject.FEndFrame := aEndFrame;
      exit;
    end;
  end;
end;

function TCharList.GeTDynamicObjItem(aId: integer): TDynamicObject;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    if TDynamicObject(DynamicObjDataList[i]).Used = FALSE then continue;
    if TDynamicObject(DynamicObjDataList[i]).Id = aId then
    begin
      Result := TDynamicObject(DynamicObjDataList[i]);
      exit;
    end;
  end;
end;

procedure TCharList.DeleteDynamicObjItem(aId: integer);
var
  i: integer;
begin
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    if TDynamicObject(DynamicObjDataList[i]).Used = FALSE then continue;
    if TDynamicObject(DynamicObjDataList[i]).Id = aId then
    begin
      TDynamicObject(DynamicObjDataList[i]).Finalize;
      exit;
    end;
  end;
end;

function TCharList.UpDate(CurTick: integer): integer;
var
  i: integer;
begin
  Result := 0;
    //回收 处理
  for i := MagicDataList.Count - 1 downto 0 do
  begin
        //        if TMovingMagicClass(MagicDataList[i]).Used = FALSE then continue;
    if TMovingMagicClass(MagicDataList[i]).MagicCurAction = MAT_DESTROY then
    begin
      TMovingMagicClass(MagicDataList[i]).free;
      MagicDataList.Delete(i);
    end;
  end;
    //转到 UPDATE
  for i := 0 to MagicDataList.Count - 1 do
  begin
        // if TMovingMagicClass(MagicDataList[i]).Used = FALSE then continue;
    if TMovingMagicClass(MagicDataList[i]).Update(CurTick) <> 0 then Result := 1;
  end;

  CharDataList.Update(CurTick);

  for i := 0 to ItemDataList.Count - 1 do
  begin
        // if TItemClass(ItemDataList[i]).Used = FALSE then continue;
    if TItemClass(ItemDataList[i]).Update(CurTick) <> 0 then Result := 1;
  end;

  for i := 0 to DynamicObjDataList.Count - 1 do
  begin // aniitem
    if TDynamicObject(DynamicObjDataList[i]).Used = FALSE then continue;
    if TDynamicObject(DynamicObjDataList[i]).Update(CurTick) <> 0 then Result := 1;
  end;

end;

procedure TCharList.UpDataBgEffect(CurTick: integer);
begin
  CharDataList.UpdateEffect(curtick);
  MAP_EffectList.Update(CurTick);
end;

procedure TCharList.GetVarRealPos(var aid, ax, ay: integer);
var
  temp: TCharClass;
begin
  if aid = 0 then exit;
  temp := CharDataList.getId(aid);
  if temp = nil then exit;

  ax := temp.RealX;
  ay := temp.RealY;

end;

function TCharList.isMovable(xx, yy: integer): Boolean;
var
  i, n: integer;
  temp: TCharClass;
begin
  Result := FALSE;
 // FrmBottom.AddChat(format('CharDataList.fdata.Count[%D]。', [CharDataList.fdata.Count]), ColorSysToDxColor(clLime), 0);

  for i := 0 to CharDataList.fdata.Count - 1 do
  begin

    temp := CharDataList.fdata.Items[i];
        // 2000.12.05 磷菌阑版快 纳腐磐啊 瘤唱哎荐 乐档废 汲沥 by ankudo
    if CharMoveFrontdieFlag then
    begin // 辑滚俊辑 CharMoveFrontdieFlag甫 TRUE肺 汲沥矫 磷绢乐阑版快 瘤唱皑
      if temp.Feature.rfeaturestate <> wfs_die then
        if (temp.X = xx) and (temp.Y = yy) then exit;
     // if ((temp._X xor (temp.RandomValue * 3 + 17) div 3) = xx) and ((temp._Y xor (temp.RandomValue * 3 + 17) div 3) = yy) then exit;

    end else
    begin
      if (temp.X = xx) and (temp.Y = yy) then exit;
      //if ((temp._X xor (temp.RandomValue * 3 + 17) div 3) = xx) and ((temp._Y xor (temp.RandomValue * 3 + 17) div 3) = yy) then exit;
    end;
//    if temp.ID = CharCenterId then
//    begin
//      FrmBottom.AddChat(format('CharDataList.fdata.Count[%D]。', [CharDataList.fdata.Count]), ColorSysToDxColor(clLime), 0);
//      BackScreen.CenterchangeIDPos(temp.X - xx, temp.Y - yy);
//    end;
  end;
    // 2000.10.01 巩颇檬籍阑 StaticItem栏肺结 埃林窍咯 某腐磐啊 棵扼啊瘤 给窍档废 荐沥 by Lee.S.G
  for i := 0 to ItemDataList.Count - 1 do
  begin
        // if TItemClass(ItemDataList[i]).Used = FALSE then continue;
    if TItemClass(ItemDataList[i]).Race = RACE_STATICITEM then
    begin // race肺 备盒 010127 ankudo
      if (TItemClass(ItemDataList[i]).X = xx) and (TItemClass(ItemDataList[i]).Y = yy) then exit;
    end;
  end;
    // DynamicObject item
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    with TDynamicObject(DynamicObjDataList[i]) do
    begin
      if Used = FALSE then continue;
      if isDynamicObjectStaticItemID(Id) then
      begin
        if (X = xx) and (Y = yy) then exit;
        for n := 0 to DynamicGuard.aCount - 1 do
        begin
          if (DynamicGuard.aGuardX[n] + X = xx) and (DynamicGuard.aGuardY[n] + Y = yy) then exit;
        end;
      end;
    end;
  end;
  Result := TRUE;
end;
//X,Y世界图像坐标

procedure TCharList.MouseMove(x, y: integer); //鼠标 移动 到 X，Y位置；地图（32*24）单位坐标
var
  i: integer;
begin
  VirtualObjectList.MouseMove(x, y);
  SelectedItem := 0;
  for i := 0 to ItemDataList.Count - 1 do
  begin
        //        if TItemClass(ItemDataList[i]).Used = FALSE then continue;
    if TItemClass(ItemDataList[i]).IsArea(x, y) then
      SelectedItem := TItemClass(ItemDataList[i]).id;
  end;

  SelectedDynamicItem := 0; // Dynamicitem
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    if TDynamicObject(DynamicObjDataList[i]).Used = FALSE then continue;
    if TDynamicObject(DynamicObjDataList[i]).IsArea(x, y) then
      SelectedDynamicItem := TDynamicObject(DynamicObjDataList[i]).id;
  end;

  CharDataList.MouseMove(x, y);
end;

procedure TCharList.Paint_Point(image: TA2Image; aw, ah: integer);
var
  i: integer;
  cl: TCharClass;
begin
  for i := 0 to CharDataList.fdata.Count - 1 do
  begin
    cl := CharDataList.fdata[i];
    cl.paint_Point(image, aw, ah);
  end;

end;

procedure TCharList.Paint(CurTick: integer);
  function GetGap(a1, a2: integer): integer;
  begin
    if a1 > a2 then Result := a1 - a2
    else Result := a2 - a1;
  end;
var
  i, j, oi, cy, n, m: integer;
  Cl: TCharClass;
  IC: TItemClass;
  AIC: TDynamicObject;
  po: PTObjectData;
  MapCell: TMapCell;
  subMapCell: TMapCell;
  chardieidx: integer;
begin
    //画物品
  for i := 0 to ItemDataList.Count - 1 do
  begin
    IC := TItemClass(ItemDataList[i]);
        //        if IC.Used = FALSE then continue;
    if IC.Race = RACE_STATICITEM then continue;
    TItemClass(ItemDataList[i]).Paint;
  end;
    //估计是死亡 排列在最前面
  chardieidx := 0; // 磷菌阑版快 刚历 弊覆
  for i := 0 to CharDataList.fdata.Count - 1 do
  begin
    Cl := CharDataList.fdata[i];
    if Cl.Feature.rfeaturestate = wfs_die then
    begin
      CharDataList.fdata.Exchange(chardieidx, i);
      inc(chardieidx);
    end;
  end;

  for i := 0 to MagicDataList.Count - 1 do
  begin
        // if TMovingMagicClass(MagicDataList[i]).Used = FALSE then continue;
    TMovingMagicClass(MagicDataList[i]).Paint;
  end;

    //画地图 物体 （分上下层）
  for j := Map.Cy - VIEWHEIGHT - 3 to Map.Cy + VIEWHEIGHT - 1 + 14 do
  begin
        //1,绘制地图物体 一行
    for i := Map.Cx - VIEWWIDTH - 8 to Map.Cx + VIEWWIDTH do
    begin
      MapCell := Map.GetCell(i, j); //获取地图块
      oi := MapCell.ObjectId; //物体ID
      if oi = 0 then Continue;
      po := ObjectDataList[oi]; //获取物体
      if po = nil then Continue;
      if po.Style = TOB_follow then //follow  随从
      begin
        if CurTick > Map.GetMapCellTick(i, j) + po.AniDelay then
        begin
          Map.SetMapCellTick(i, j, CurTick);
          if po.StartID = po.ObjectId then
          begin
            inc(MapCell.ObjectNumber);
            if MapCell.ObjectNumber > po.nBlock - 1 then MapCell.ObjectNumber := 0;
            Map.SetCell(i, j, MapCell);

                        //for m := j - po.MHeight to j + (po.MHeight div 2) + 2 do
            for m := j - po.MHeight to j + (po.MHeight div 2) + 2 do
            begin
              for n := 0 to po.EndID - po.StartID do
              begin
                SubMapCell := Map.GetCell(i + n + (po.IWidth div 32) - 1, m);
                if (SubMapCell.ObjectId > 0) and (SubMapCell.ObjectId > po.StartID) and (SubMapCell.ObjectId <= po.EndID) then
                begin
                  Map.SetMapCellTick(i + n + (po.IWidth div 32) - 1, m, CurTick);
                  inc(SubMapCell.ObjectNumber);
                  if subMapCell.ObjectNumber > po.nBlock - 1 then subMapCell.ObjectNumber := 0;
                  Map.SetCell(i + n + (po.IWidth div 32) - 1, m, subMapCell);
                end;
              end;
            end;

          end else
          begin

          end;
        end;
      end else MapCell.ObjectNumber := 0;
      BackScreen.DrawImageKeyColor(ObjectDataList.GetObjectImage(oi, MapCell.ObjectNumber, CurTick), i * UNITX, j * UNITY);
    end;
                //2，动态 物体
    for i := 0 to DynamicObjDataList.Count - 1 do
    begin // DynamicObjPaint
      AIC := TDynamicObject(DynamicObjDataList[i]);
      if AIC.Used = FALSE then continue;
      if isDynamicObjectStaticItemID(AIC.Id) = FALSE then continue;
      if AIC.y <> j then continue;
      TDynamicObject(DynamicObjDataList[i]).Paint;
    end;
        //3，移动 物体 人 怪物
    for i := 0 to CharDataList.fdata.Count - 1 do
    begin // 纳腐磐 paint

      Cl := CharDataList.fdata[i];
      cy := (CL.RealY + UNITYS) div UNITY;
      if ((CL.Realy + UNITYS) mod UNITY) > (UNITY div 2) then cy := cy + 1;
      if j = cy then
      begin
        if (Cl.BgEffect.BgEffectImagePP <> nil) and Cl.BgEffect.BgEffectImagePP.DrawOnBack then //2015.11.15 在水一方
          Cl.BgEffect.Paint(Cl.Realx, Cl.Realy, cl.dir); // overvalue, Speed 锭巩俊 +2
        if (Cl.id = SelectedChar) then
          CL.paint(CurTick)
        else Cl.paint(CurTick);
      end;

      if Cl.Feature.rEffectNumber > 0 then
        Cl.AddBgEffect(cl.x, cl.y, Cl.Feature.rEffectNumber - 1, Cl.Feature.rEffectKind, True);
      if j = cy then
      begin
        if (Cl.BgEffect.BgEffectImagePP <> nil) and not Cl.BgEffect.BgEffectImagePP.DrawOnBack then //2015.11.15 在水一方
          Cl.BgEffect.Paint(Cl.Realx, Cl.Realy, cl.dir); // overvalue, Speed 锭巩俊 +2

        cl.BgEffectList.Paint(Cl.Realx, Cl.Realy, cl.dir);
        Cl.ScreenEffect.Paint(Cl.Realx, Cl.Realy, cl.dir); // overvalue, Speed 锭巩俊 +2
        Cl.MagicEffect.Paint(Cl.Realx, Cl.Realy, cl.dir); // overvalue, Speed 锭巩俊 +2
      end;

    end;
        //4，
    for i := 0 to ItemDataList.Count - 1 do
    begin
      IC := TItemClass(ItemDataList[i]);
            // if IC.Used = FALSE then continue;
      if IC.Race <> RACE_STATICITEM then continue;
      if IC.y <> j then continue;
      TItemClass(ItemDataList[i]).Paint;
    end;


  end;
  MAP_EffectList.Paint(0, 0, 0);
end;

procedure TCharList.PaintText(aCanvas: TCanvas);
var
  i: integer;
  Cl: TCharClass;
  Col: integer;
  str: string;
begin
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    if TDynamicObject(DynamicObjDataList[i]).DynamicObjName = '' then continue;
    if TDynamicObject(DynamicObjDataList[i]).Used = FALSE then continue;

    if TDynamicObject(DynamicObjDataList[i]).id = SelectedDynamicItem then
    begin
      Col := WinRGB(31, 31, 31);
      BackScreen.DrawName(aCanvas, TDynamicObject(DynamicObjDataList[i]).RealX, TDynamicObject(DynamicObjDataList[i]).RealY, TDynamicObject(DynamicObjDataList[i]).DynamicObjName, Col);
    end;
    if FrmSound.A2CheckBox_ShowItem.Checked then
    begin
      if TDynamicObject(DynamicObjDataList[i]).id = SelectedDynamicItem then
        Col := NameChangeColor
      else
        Col := WinRGB(31, 31, 31);
      BackScreen.DrawName(aCanvas, TDynamicObject(DynamicObjDataList[i]).RealX, TDynamicObject(DynamicObjDataList[i]).RealY, TDynamicObject(DynamicObjDataList[i]).DynamicObjName, Col);
    end;
  end;

  for i := 0 to ItemDataList.Count - 1 do
  begin
        //if TItemClass(ItemDataList[i]).Used = FALSE then continue;
    if TItemClass(ItemDataList[i]).id = SelectedItem then
    begin
      Col := WinRGB(31, 31, 31);
      BackScreen.DrawName(aCanvas, TItemClass(ItemDataList[i]).RealX, TItemClass(ItemDataList[i]).RealY, TItemClass(ItemDataList[i]).ItemName, Col);
    end;

    if (FrmSound.A2CheckBox_ShowItem.Checked) then
    begin
      if TItemClass(ItemDataList[i]).id = SelectedItem then
        Col := NameChangeColor
      else
        Col := WinRGB(31, 31, 31);
      BackScreen.DrawName(aCanvas, TItemClass(ItemDataList[i]).RealX, TItemClass(ItemDataList[i]).RealY, TItemClass(ItemDataList[i]).ItemName, Col);
    end;
  end;
  CharDataList.PaintText(aCanvas);
end;

procedure TCharList.AddMagic(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, aef, CurTick: integer; aType: byte);
var
    //   i : integer;
  MagicClass: TMovingMagicClass;
begin

  MagicClass := TMovingMagicClass.Create(FAtzClass);
  MagicClass.Initialize(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, aef, CurTick, aType);
  MagicDataList.Add(MagicClass);

end;
{
function TCharList.isStaticItemID(aid : LongInt) : Boolean;
var id : Longint;
begin
   Result := FALSE;
   id := aid - 10000;
   if (id mod 10) = 4 then Result := TRUE;
end;
}

function TCharList.isDynamicObjectStaticItemID(aid: LongInt): Boolean;
var
  id: Longint;
begin
  Result := FALSE;
  id := aid - 10000;
  if (id mod 10) = 5 then Result := TRUE;
end;

////////////////////////////////////////////////////////////////////////////////
//                         TCharDataListclass
////////////////////////////////////////////////////////////////////////////////

procedure TCharDataListclass.Clear();
var
  i: integer;
  temp: TCharClass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    temp.Free;
  end;
  FDATA.Clear;
  FidIndex.Clear;
  fnameIndex.Clear;
end;

function TCharDataListclass.getAllName(): string;
var
  i: integer;
  temp: TCharClass;
begin
  result := '';
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    result := result + temp.rName + #13#10;
  end;

end;

procedure TCharDataListclass.del(aid: integer);
var
  i: integer;
  temp: TCharClass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    if temp.id = aid then
    begin
      FDATA.Delete(i);
      FidIndex.Delete(temp.id);
      fnameIndex.Delete(temp.rName);
      temp.Free;
      exit;
    end;
  end;

end;

procedure TCharDataListclass.add(aName: string; aId, adir, ax, ay: integer; afeature: TFeature);
var
  CharClass: TCharClass;
begin
  CharClass := TCharClass.Create(AtzClass);
  CharClass.Initialize(aName, aId, adir, ax, ay, afeature);
  fdata.Add(CharClass);
  FidIndex.Insert(CharClass.id, CharClass);
  fnameIndex.Insert(CharClass.rName, CharClass);
end;

procedure TCharDataListclass.Painttext(aCanvas: TCanvas);
var
  i: integer;
  Cl: TCharClass;
  Col: integer;
  str: string;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    Cl := fdata[i];
    if Cl.Feature.rHideState = hs_100 then
    begin
            //if (Cl.id = SelectedChar) then
            //begin

      if (cl.Feature.rrace = RACE_MONSTER) then
      begin
        if cl.id = SelectedChar then
        begin
          Col := WinRGB(31, 31, 31);
          str := cl.rName;
          if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
          BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col);
        end;

        if (FrmSound.A2CheckBox_ShowMonster.Checked) or (FrmSound.A2CheckBox_ShowNpc.Checked) then
        begin
          if cl.id = SelectedChar then
            Col := NameChangeColor
          else
            Col := WinRGB(31, 31, 31);
          str := cl.rName;
          if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
          BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col);
        end;
      end
      else if (cl.Feature.rrace = RACE_NPC) then
      begin
        if cl.id = SelectedChar then
        begin
          Col := ColorSysToDxColor($FFFF10);
          str := cl.rName;
          if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
          BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col);
        end;

        if FrmSound.A2CheckBox_ShowNpc.Checked then
        begin
          if cl.id = SelectedChar then
            Col := NameChangeColor
          else
            Col := ColorSysToDxColor($FFFF10);
          str := cl.rName;
          if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
          BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col);
        end;
      end
      else if (cl.Feature.rrace = race_human) then
      begin

        if cl.id = SelectedChar then
        begin
          Col := cl.Feature.rNameColor; //WinRGB(31, 31, 31);
          str := cl.rName;
          if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
          if fwide = 800 then BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col)
          else BackScreen.DrawName(aCanvas, Cl.RealX + 10, Cl.RealY, str, Col); //放大人物导致的人名显示错位
        end else
        begin
          if cl.rbooth then
          begin
            Col := ColorSysToDxColor($003E7CFF);
            str := cl.rBoothName;
            BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col);
          end else
          begin
            //显示人名选中
            if (FrmSound.A2CheckBox_ShowSelfName.Checked) or (GetKeyState(VK_MENU) < 0) then
            begin
              if cl.id = SelectedChar then
              begin
                col := NameChangeColor;
              end
              else Col := cl.Feature.rNameColor;
              str := cl.rName;
              if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
              if fwide = 800 then BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col)
              else BackScreen.DrawName(aCanvas, Cl.RealX + 10, Cl.RealY, str, Col); //放大人物导致的人名显示错位
            end
            else
            begin
            //自身高亮选中
              if FrmSound.A2CheckBox_ShowPlayer1.Checked then
              begin
                if cl.id = CharCenterId then
                begin
                  if cl.id = SelectedChar then
                  begin
                    col := NameChangeColor;
                  end
                  else Col := cl.Feature.rNameColor;
                  str := cl.rName;
                  if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
                  if fwide = 800 then BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col)
                  else BackScreen.DrawName(aCanvas, Cl.RealX + 10, Cl.RealY, str, Col); //放大人物导致的人名显示错位
                end;
              end;

            end;

//            //自身高亮选中
//            if FrmSound.A2CheckBox_ShowPlayer1.Checked then
//            begin
//              //显示人名选中
//              if FrmSound.A2CheckBox_ShowSelfName.Checked then
//              begin
//                if cl.id = CharCenterId then
//                begin
//                  if cl.id = SelectedChar then
//                  begin
//                    col := NameChangeColor;
//                  end
//                  else Col := cl.Feature.rNameColor;
//                  str := cl.rName;
//                  if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
//                  if fwide = 800 then BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col)
//                  else BackScreen.DrawName(aCanvas, Cl.RealX + 10, Cl.RealY, str, Col); //放大人物导致的人名显示错位
//                end;
//              end else
//              begin
//                if cl.id = SelectedChar then
//                begin
//                  col := NameChangeColor;
//                end
//                else Col := cl.Feature.rNameColor;
//                str := cl.rName;
//                if FrmSound.A2CheckBox_ShowGuildName.Checked then
//                begin
//                  if cl.GuildName <> '' then str := str + ',' + cl.GuildName;
//                end;
//
//                if fwide = 800 then BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, str, Col)
//                else BackScreen.DrawName(aCanvas, Cl.RealX + 10, Cl.RealY, str, Col); //放大人物导致的人名显示错位
//              end;
//
//            end;
          end;
        end;


      end;

            //end;
    end;

    if Cl.BubbleList.Count <> 0 then
    begin
      if WinVerType = wvtnew then
      begin
        {if cl.GuildName <> '' then
        begin
          if fwide = 800 then BackScreen.DrawBubble(aCanvas, Cl.RealX, Cl.RealY - 10, Cl.BubbleList)
          else BackScreen.DrawBubble(aCanvas, Cl.RealX + 10, Cl.RealY, Cl.BubbleList); //20130630修改，武功 切换显示
        end
        else
        begin
          if fwide = 800 then BackScreen.DrawBubble(aCanvas, Cl.RealX, Cl.RealY + 5, Cl.BubbleList)
          else BackScreen.DrawBubble(aCanvas, Cl.RealX, Cl.RealY - 5, Cl.BubbleList); //20130630修改 掉血切换红色显示
        end;}
        BackScreen.DrawBubble(aCanvas, Cl.RealX, Cl.RealY - 5, Cl.BubbleList); //2015.12.18 在水一方
      end
      else
      begin
        BackScreen.DrawBubble(aCanvas, Cl.RealX, Cl.RealY - 5, Cl.BubbleList);
      end;
    end;
  end;
end;

procedure TCharDataListclass.Paint(CurTick: integer);
var
  i: integer;
  temp: TCharClass;
begin

  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    temp.Paint(curtick);
  end;
end;

procedure TCharDataListclass.MouseMove(x, y: integer);
var
  i: integer;
  temp: TCharClass;
begin
  SelectedChar := 0;
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    temp.MouseMove(x, y);
  end;

end;

procedure TCharDataListclass.UpdateEffect(CurTick: integer);
var
  i: integer;
  temp: TCharClass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    temp.BgEffect.Update(CurTicK);
    temp.BgEffectList.Update(CurTicK);
    temp.ScreenEffect.Update(CurTicK);
    temp.MagicEffect.Update(CurTicK);
  end;

end;

procedure TCharDataListclass.Update(CurTick: integer);
var
  i: integer;
  temp: TCharClass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    temp.Update(CurTick);
  end;

end;

function TCharDataListclass.getId(aid: integer): TCharClass;
begin
  result := TCharClass(FidIndex.Select(aid));
end;

function TCharDataListclass.getname(aname: string): TCharClass;
begin
  result := TCharClass(fnameIndex.Select(aname));
end;

constructor TCharDataListclass.Create;
begin
  inherited Create;
  FDATA := tlist.Create;
  FidIndex := TIntegerKeyClass.Create;
  fnameIndex := TStringKeyClass.Create;
end;

destructor TCharDataListclass.Destroy;
begin
  Clear;
  FDATA.Free;
  FidIndex.Free;
  fnameIndex.Free;
  inherited Destroy;
end;
{ TVirtualObjectClass }

constructor TVirtualObjectClass.Create();
begin
  ItemImage := TA2Image.Create(32, 32, 0, 0);
  Id := 0;
  x := 0;
  y := 0;
  Width := 0;
  Height := 0;
  Race := 0;
  fName := '';
  RealX := 0;
  RealY := 0;
end;

destructor TVirtualObjectClass.Destroy;
begin
  ItemImage.Free;
  inherited;
end;

procedure TVirtualObjectClass.Initialize(aName: string; aRace: byte; aId,
  ax, ay, aw, ah: integer);
begin
  fName := aName;
  x := ax;
  y := ay;
  id := aId;
  Race := aRace;
  Width := aw * UNITX;
  Height := ah * UNITY;

  RealX := x * UNITX + UNITX div 2; //自己在屏幕坐标位置
  RealY := y * UNITY + UNITY div 2;
  ItemImage.Setsize(Width, Height);
  ItemImage.Clear(ColorSysToDxColor(clRed));
end;

procedure TVirtualObjectClass.Paint;
begin
  BackScreen.DrawImage(ItemImage, RealX - Width div 2, RealY - Height div 2, TRUE);
end;

function TVirtualObjectClass.IsArea(ax, ay: integer): Boolean;
var
  xp, yp: integer;
  xx, yy: integer;
begin
  Result := TRUE;
    //左边上
  xx := RealX - Width div 2;
  yy := RealY - Height div 2;

  if (ax <= xx) then Result := FALSE;
  if (ay <= yy) then Result := FALSE;
  if ax >= xx + Width then Result := FALSE;
  if ay >= yy + Height then Result := FALSE;

end;

{ TVirtualObjectListClass }

procedure TVirtualObjectListClass.add(aName: string; aRace: byte; aId, ax, ay, aw, ah: integer);
var
  bo: TVirtualObjectClass;
begin
  if get(aId) <> nil then exit;
  bo := TVirtualObjectClass.Create();
  bo.Initialize(aName, aRace, aId, ax, ay, aw, ah);
  fdata.Add(bo);
end;

procedure TVirtualObjectListClass.clear;
var
  i: integer;
  bo: TVirtualObjectClass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    bo := fdata.Items[i];
    bo.Free;
  end;
  fdata.Clear;
end;

constructor TVirtualObjectListClass.Create;
begin
  fdata := TList.Create;
end;

procedure TVirtualObjectListClass.del(aid: integer);
var
  i: integer;
  bo: TVirtualObjectClass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    bo := fdata.Items[i];
    if bo.id = aid then
    begin
      bo.Free;
      fdata.Delete(i);
      exit;
    end;
  end;

end;

destructor TVirtualObjectListClass.Destroy;
begin
  clear;
  fdata.Free;
  inherited;
end;

function TVirtualObjectListClass.get(aid: integer): TVirtualObjectClass;
var
  i: integer;
  bo: TVirtualObjectClass;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    bo := fdata.Items[i];
    if bo.id = aid then
    begin
      result := bo;
      exit;
    end;
  end;

end;

function TVirtualObjectListClass.GetData: TList;
begin
  Result := fdata;
end;

procedure TVirtualObjectListClass.MouseMove(x, y: integer);
var
  i: integer;
  bo: TVirtualObjectClass;
begin
  SelectedVirtualObject := 0;
  for i := 0 to fdata.Count - 1 do
  begin
    bo := fdata.Items[i];
    if bo.IsArea(x, y) then
    begin
      SelectedVirtualObject := bo.Id;

      exit;
    end;
  end;

end;

procedure TVirtualObjectListClass.Paint;
var
  i: integer;
  bo: TVirtualObjectClass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    bo := fdata.Items[i];
    bo.Paint;
  end;

end;

function TCharDataListclass.getbyindex(aindex: Integer): TCharClass;
var
  tmp: TCharClass;
begin
  try
    tmp := fnameIndex.SelectByIndex(aindex);
    Result := tmp;
  except
    Result := nil;
  end;

end;

function TCharList.CharGetByIndex(Aid: Integer): TCharClass;
begin
  result := CharDataList.getbyindex(Aid);
end;

function TCharList.CharGetAllMonsterName: string;
begin
  Result := CharDataList.getAllMonsterName;
end;

function TCharDataListclass.getAllMonsterName: string;
var
  i: integer;
  temp: TCharClass;
begin
  result := '';
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    if temp.Feature.rrace = RACE_MONSTER then
      result := result + temp.rName + #13#10;
  end;
end;

function TCharDataListclass.getData: TList;
begin
  Result := fdata;
end;

function TCharList.CharGetByName(aName: string): TCharClass;
var
  i: integer;
  temp: TCharClass;
begin
  Result := CharDataList.CharGetByName(aName);

end;

function TCharDataListclass.CharGetByName(aName: string): TCharClass;
var
  i: integer;
  temp: TCharClass;
begin
  Result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    temp := fdata.Items[i];
    if temp.Feature.rrace = RACE_MONSTER then
    begin
      if (temp.rName = aName) and (temp.Feature.rfeaturestate <> wfs_die) and (GetLargeLength(CharPosX, CharPosY, temp.getx, temp.gety) <= 12) then
      begin
        Result := temp;
        Break;
      end;
    end;
  end;
end;

procedure TCharClass.SetCurrentPos;
begin
  if CurActionInfo = nil then
  begin
    RealX := x * UNITX + UNITXS;
    RealY := y * UNITY - UNITYS;
  end
  else
  begin
  //  ImageNumber := CurActionInfo^.Frames[CurFrame];
    RealX := x * UNITX + CurActionInfo^.Pxs[CurFrame] + UNITXS;
    RealY := y * UNITY + CurActionInfo^.Pys[CurFrame] - UNITYS;
  end
end;

initialization
{$I SE_PROTECT_START_MUTATION.inc}
  MyModstart := GetModuleHandle(0);
  MzH := PImageDosHeader(MyModstart);
  peH := PImageNtHeaders(MyModstart + MzH._lfanew);
  MyModEnd := MyModstart + peH.OptionalHeader.SizeOfImage;
  MyModstart := MyModstart xor 1235689;
  MyModEnd := MyModEnd xor 2345689;
{$I SE_PROTECT_END.inc}

finalization

end.

