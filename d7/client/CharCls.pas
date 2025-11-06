unit CharCls;

interface

uses
  Windows, SysUtils, Classes, graphics,
  subutil, uanstick, deftype, A2Img, AtzCls, clType, maptype, clmap, backscrn,
  objcls, CTable, dialogs, uEffectCls;

const
  MAGICNEXTTIME = 7; // 付过橇饭烙捞 函窍绰 矫埃
  DYNAMICOBJECTTIME = 15; // DynamicObj啊 函拳窍绰 矫埃

  FRAME_BUFFER_SIZE = 30;

  MESSAGEARR_SIZE = 10;

  CharMaxSiez = 160;
  CHarMaxSiezHalf = 80;

  MovingMagicMaxSiez = 140;
  MovingMagicMaxSiezHalf = 70;

  DynamicObjectMaxSize = 200;
  DynamicObjectMaxSizeHalf = 100;

  BgEffectMaxSize = 140;
  BgEffectMaxSizeHalf = 70;

  CharImageBufferCount = 12;
  EFFECTCOUNT = 12;

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
  TRecordMessage = packed record
    rMsg, rdir, rx, ry: Integer;
    rfeature: TFeature;
    rmotion: integer
  end;

  {  // TEffectClass肺 措眉凳 021023 minds
  ///////////// TBgEffect Class /////////// 010120 ankudo
    TBgEffect = class
    private
      DelayTick : integer;
      FUsed : Boolean;
      FAtzClass : TAtzClass;
      BgEffectShape : integer;
      LightEffectKind :TLightEffectKind;
      BgEffectIndex : integer;
      Realx, Realy : integer;
    public
      BgEffectTime : integer;           // BgEffect啊 函拳窍绰 矫埃
      BgOverValue : integer;

      FFileName : string;
      ID : integer;
      x, y: integer;
      EffectPositionData : TEffectPositionData;
      BgEffectImage : TA2Image;
      constructor Create (aAtzClass: TAtzClass);
      destructor  Destroy; override;
      // change by minds 1218 CurTick眠啊
      procedure   Initialize (ax, ay: integer; aBgEffectShape: integer; aLightEffectKind: TLightEffectKind; CurTick: integer);

      procedure   Finalize;
      procedure   Paint(aRealx, aRealy : integer);
      procedure   SetFrame(CurTick : integer);
      function    Update ( CurTick: integer) : Integer;
      property    Used : Boolean read FUsed;
    end;
  }
  ///////////// TEffectClass /////////////////// 021016 minds
  TEffectDraw = set of (ED_FRONT, ED_BACK, ED_SHADOW, ED_FRONTSUB);

  TEffectClass = class
  private
    FEffectShape: integer;
    FEffectKind: TLightEffectKind;
    FEffectName: string;
    FEffectData: TEffectDataClass;

    FDelayTick: integer;
    FStartTick: integer;
    FCurIndex: integer;

    RealX, RealY: integer;
    FUsed: Boolean;

    bSetDark: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize(adir, ax, ay: integer; aEffectShape: integer;
      aEffectKind: TLightEffectKind; CurTick: integer; StartTick: integer = 0);
    procedure Finalize;
    function Update(aDir, CurTick: integer): Integer;
    procedure SetFrame(aDir: integer);

    procedure Paint(aDir, aRealx, aRealy: integer; aDrawSet: TEffectDraw);

    property Used: Boolean read FUsed;
  end;

  TCharClass = class;

  TEffectList = class
  private
    FOwnChar: TCharClass;
    FDataList: TList;
  public
    constructor Create(Owner: TCharClass);
    destructor Destroy; override;
    procedure AddEffect(adir, ax, ay: integer; aEffectShape: integer;
      aEffectKind: TLightEffectKind; aDelayTick: integer = 0);
    procedure Update;
    procedure Paint(aDir, aRealx, aRealy: integer; aDrawSet: TEffectDraw);
  end;

  ///////////// TDynamicObject Class /////////// 010102 ankudo
  TDynamicGuard = packed record
    aCount: Byte;
    aGuardX: array[0..10 - 1] of Shortint; // 扁霖 128;
    aGuardY: array[0..10 - 1] of Shortint; // 扁霖 128;
  end;

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

    // add by minds 020319  Dynamic Object俊 Effect眠啊, 怕必八巩
//    BGEffect: TBGEffect;
    FEffect: TEffectClass;
  public
    Id: integer;
    x, y: integer;
    FStartFrame, FEndFrame: Word;

    DynamicObjImage: TA2Image;
    DynamicObjName: string;
    DynamicObjectState: byte;

    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;

    procedure Initialize(aItemName: string; aId, ax, ay, aItemShape: integer;
      aStartFrame, aEndFrame: Word; aState: byte; aDynamicGuard: TDynamicGuard);
    procedure Finalize;

    procedure ChangeProperty(pCP: PTSChangeProperty);
    procedure AddBgEffect(AEffectShape: integer; AEffectKind: TLightEffectKind);

    procedure ProcessMessage(aMsg, aMotion: integer);
    procedure SetFrame(aDynamicObjectState: byte; CurTick: integer);
    function IsArea(ax, ay: integer): Boolean;
    procedure Paint;
    function Update(CurTick: integer): Integer;
    property Used: Boolean read FUsed;
    property DynamicGuard: TDynamicGuard read FDynamicGuard;
  end;

  TItemClass = class
  private
    FUsed: Boolean;
    FAtzClass: TAtzClass;
    ItemShape: integer;
    ItemColor: integer;
    RealX, RealY: integer;
    Race: byte;
    {   // add by minds 1219 酒捞袍 积己矫狼 effect 眠啊
        BGEffect: TBGEffect;
        EffectShape: integer;
        EffectKind: TLightEffectKind;
        ItemHeight, FallX: integer;
    }
  public
    Id: integer;
    x, y: integer;
    ItemImage: TA2Image;
    ItemName: string;
    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Initialize(aItemName: string; aRace: byte; aId, ax, ay,
      aItemshape, aItemcolor: integer);
    procedure Finalize;
    procedure SetItemAndColor(aItemshape, aItemColor: integer);
    {   // add by minds 1219 酒捞袍 effect
        procedure   AddBGEffect(aEffectShape: integer; aEffectKind: TLightEffectKind);   // add by minds 1219
    }
    procedure ChangeProperty(pCP: PTSChangeProperty);

    function IsArea(ax, ay: integer): Boolean;
    procedure Paint;
    function Update(CurTick: integer): Integer;
    property Used: Boolean read FUsed;
  end;

  TCharImageBuffer = packed record
    aCharImage: TA2Image;
    aImageNumber: integer;
  end;

  // add by minds 021202
  TWaitMessage = packed record
    rMsg: integer;
    rMotion: integer;
    rFeature: TFeature;
  end;

  TCharClass = class
  private
    TurningTick: integer;
    StructedTick: integer;
    StructedPercent: integer;

    AniList: TList;
    FrameStartTime: Longint; // 青悼 矫累茄 矫埃
    ImageNumber: Integer;
    CurFrame: integer;
    CurActionInfo: PTAniInfo;

    OverImage: TA2Image;
    OverImageName: string;
    //    BgEffect : TBgEffect;

    FEffectList: TEffectList;

    RealX, RealY: integer;
    FUsed: Boolean;
    FAtzClass: TAtzClass;

    CurAction: integer;
    OldMakeFrame: integer;

    BubbleList: TStringList;
    BubbleTick: integer;
    // Add by minds 021126
    BubbleColor: Word; // 浅急档框富 臂磊祸
    BubbleType: byte; // 浅急档框富 鸥涝(0:焊烹, 1:绊沥鸥涝)
    StoreSign: string; // 惑痢浦富
    StoreFlag: Boolean; // 惑痢凯菌促 摧疽促...

    bCasting: Boolean;
    //    HitLock: Boolean;
    //    WaitMsgs: array[0..2] of TWaitMessage;

    BackX, BackY: integer;
    FBackMoveTick: integer;
    xxxx, NewX, yyyy, NewY: smallint;
    bUpdatePos: Boolean;
    MessageArr: array[0..MESSAGEARR_SIZE - 1] of TRecordMessage;

    MonImage: TA2Image;

    CharImageBuffer: array[0..CharImageBufferCount - 1] of TCharImageBuffer;
    CharImageBufferIndex: integer;

    procedure SetCurrentFrame(aAniInfo: PTAniInfo; aFrame, CurTime: integer);
    procedure SetCurrentPos;
    procedure UpdateCharPos;
    function FindAnimation(aact, adir: Integer): PTAniInfo;
    {
        // MovingMagic俊 狼秦 措扁登绰 悼累俊 包茄 窃荐甸
        procedure SetHitLock;
        procedure ReleaseHitLock;
        procedure WaitHitMessage(aMsg, aMotion: integer; aFeature: TFeature);
    }
  public
    Name: string;
    Feature: TFeature;
    id, dir: integer;

    procedure MakeFrame(aindex, CurTick: integer);
    procedure AddMessage(aRMsg: TRecordMessage);
    procedure GetMessage(var aRMsg: TRecordMessage);
    procedure ViewMessage(var aRMsg: TRecordMessage);

    function GetCharImage: TA2Image;

    // BgEffect Initialize何盒 内靛锭巩俊 眠啊茄巴
    // change by minds 1218, CurTick狼 眠啊
//    procedure   AddBgEffect (aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; CurTick: integer);
//    procedure   AddEffect(aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; CurTick: integer);
    procedure AddEffect(aShape: integer; aLightEffectKind: TLightEffectKind;
      CurTick: integer; DelayTick: integer = 0);

    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Initialize(aName: string; aId, adir, ax, ay: integer; afeature:
      TFeature);
    procedure Finalize;

    function IsArea(ax, ay: integer): Boolean;
    function GetArrImageLib(aindex, CurTick: integer): TA2ImageLib;
    procedure Paint(CurTick: integer);

    function AllowAddAction: Boolean;
    //    function    ProcessMessage (aMsg, adir, ax, ay: Integer; afeature: TFeature; amotion: integer): Integer;

    function Update(CurTick: integer): Integer;
    procedure Say(const astr: string);
    // add by minds 021126
    procedure SayStatic(const astr: string; wCol: Word = 32736);
    procedure SetStoreSign(const astr: string);
    procedure SetCasting(value: Boolean);
    function isCasting: Boolean;

    procedure ChangeFeature(var aFeature: TFeature);
    procedure Structed(aPercent: integer);
    procedure SetPosition(adir, ax, ay: integer);
    procedure SetTurn(adir: integer);
    procedure Move(adir, ax, ay: integer);
    procedure BackMove(adir, ax, ay: integer);
    procedure SetMotion(aMotion: integer);

    procedure ChangeProperty(pCP: PTSChangeProperty);
    procedure SetEffectName(aEffectName: string);

    property Used: Boolean read FUsed;
  public
    function GetX: SmallInt;
    function GetY: SmallInt;

// change by minds 050221
    property X: SmallInt read xxxx;
    property Y: SmallInt read yyyy;
//    property X: SmallInt read GetX;
//    property Y: SmallInt read GetY;
  end;

  TMagicActionType = (MAT_SHOW, MAT_MOVE, MAT_HIDE, MAT_DESTROY);

  ToldMovingMagic = packed record
    asid, aeid: LongInt;
    aDeg: integer;
    atx, aty: word;
    aMagicShape: integer;
    amf: byte;
    aspeed: byte;
    aType: byte;
    ax, ay: integer;
  end;

  TMovingMagicClass = class
  private
    StartId, EndId: longInt;
    speed: word;
    tx, ty, drawX, drawY: integer;
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

    // add by minds 1219 Target俊 嘎疽阑锭 effect眠啊
    eEffectNumber: integer;
    eEffectKind: TLightEffectKind;

    // Tick Delay贸府侩
    LastTick: integer;

    procedure SetAction(aAction: TMagicActionType; CurTime: integer);
  public
    MagicCurAction: TMagicActionType;
    x, y: integer;
    MagicName: string;
    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Initialize(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape,
      CurTick: integer; aType: byte);
    procedure Finalize;

    procedure Paint;
    function Update(CurTick: integer): Integer;
    property Used: Boolean read FUsed;

    // add by minds 1219 Target俊 嘎疽阑锭 effect眠啊
    procedure SetEndEffect(aEffectNumber: integer; aEffectKind:
      TLightEffectKind);
  end;

  {$IFDEF _DEBUG}
  TGuildNameTest = record
    X: Integer;
    Y: Integer;
    X1: Integer;
    Y1: Integer;
    Size: Integer;
    Style: Integer;
  end;
  {$ENDIF}

  TCharList = class
  private
    ItemDataList: TList;
    MagicDataList: TList;
    DynamicObjDataList: TList;
    CharDataList: TList;
    CharMsgList: TList;
    EffectDataList: TEffectDataList;

    FAtzClass: TAtzClass;

    function isDynamicObjectStaticItemID(aid: LongInt): Boolean;
  public
    constructor Create(aAtzClass: TAtzClass);
    destructor Destroy; override;
    procedure Clear;

    // change by minds 021126 积己等 Character甫 return 窍档废 函版
    function AddChar(aName: Widestring; aId, adir, ax, ay: integer; afeature:
      TFeature): TCharClass;
    function GetChar(aId: integer): TCharClass;
    procedure DeleteChar(aId: integer);
    // item
    procedure AddItem(aItemName: string; aRace: byte; aId, ax, ay, aItemShape,
      aItemColor: integer);
    function GetItem(aId: integer): TItemClass;
    procedure DeleteItem(aId: integer);
    // DynamicObject Item 010105 ankudo
    procedure AddDynamicObjItem(aItemName: string; aId, ax, ay, aItemShape:
      integer; aStartFrame, aEndFrame: Word; aState: byte; aDynamicGuard:
      TDynamicGuard);
    procedure SetDynamicObjItem(aId: integer; aState: byte; aStartFrame,
      aEndFrame: Word);
    function GetDynamicObjItem(aId: integer): TDynamicObject;
    procedure DeleteDynamicObjItem(aId: integer);

    // change by minds 1219 积己等 MovingMagicClass甫 return窍档废 函版
    function AddMagic(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape,
      CurTick: integer; aType: byte): TMovingMagicClass;
    //    procedure   AddMagic (sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, CurTick: integer; aType: byte);
    procedure GetVarRealPos(var aid, ax, ay: integer);
    function isMovable(xx, yy: integer): Boolean;

    procedure PaintText(aCanvas: TCanvas);
    procedure Paint(CurTick: integer);
    function UpDate(CurTick: integer): Integer;
    function UpDataBgEffect(CurTick: integer): integer;
    procedure MouseMove(x, y: integer);
    //
    procedure UpdateBasePos(NewBaseData: PByte);
    procedure DrawGuildName(X, Y: Integer);
    procedure DrawGuildNameFont(X, Y, X1, Y1: Integer; AGuildName: string;
      ASize: Integer; AStyle: Integer; ASpace: Integer; aParam: Integer);
  public
{$IFDEF _DEBUG}
    GuildNameTest: TGuildNameTest;
    procedure __DrawGuildNameFontTest(X, Y, X1, Y1, ASize, AStyle: Integer);
{$ENDIF}
  end;

procedure GetGreenColorAndAdd(acolor: integer; var GreenColor, GreenAdd:
  integer);

var
  EncBasePos2: array[0..15] of BYTE =
  (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  bUpdateBasePos: Boolean = False;
  CharList: TCharList;

  CharCenterId: integer = 0;
  CharCenterName: string = '';
  CharPosX: integer = 0;
  CharPosY: integer = 0;

  SelectedChar: integer = 0;
  Selecteditem: integer = 0;
  SelectedDynamicItem: integer = 0;

  CharMoveFrontdieFlag: Boolean = FALSE;
  bGridOn: Boolean = False;

  EncBasePos: array[0..15] of BYTE =
  (158, 251, 195, 188, 40, 177, 148, 202,
    73, 130, 97, 2, 250, 188, 52, 19);
  EncBasePosX2: array[0..15] of BYTE =
  (121, 31, 128, 16, 208, 91, 191, 77,
    146, 88, 181, 221, 113, 77, 177, 163);
  EncBasePosX3: array[0..15] of BYTE =
  (173, 52, 10, 56, 37, 3, 123, 111,
    90, 49, 204, 42, 128, 235, 107, 238);
{$IFDEF _DEBUG}
  bShowCharList: Boolean = False;
{$ENDIF}

implementation

uses
  FMain, Log, uXDibA, AUtil32, FHelp, uImage;
{$O+}

//////////////////////////////////
//         Effect Class
//////////////////////////////////

constructor TEffectClass.Create;
begin
  inherited;
  FUsed := False;
  FEffectData := nil;
end;

destructor TEffectClass.Destroy;
begin
  Finalize;

  inherited;
end;

procedure TEffectClass.Initialize(adir, ax, ay: integer; aEffectShape: integer;
  aEffectKind: TLightEffectKind; CurTick, StartTick: integer);
begin
  FEffectShape := aEffectShape;
  FEffectKind := aEffectKind;
  FEffectName := Format('_%d.eft', [aEffectShape]);
  FEffectData := CharList.EffectDataList.GetEffectData(FEffectName);
  FDelayTick := CurTick;
  FStartTick := StartTick;
  FCurIndex := -1;
  FUsed := True;

  RealX := ax;
  RealY := ay;

  if (3000 <= aEffectShape) and (aEffectShape <= 3011) then
    bSetDark := true
  else
    bSetDark := false;

  if FDelayTick > FStartTick then
    SetFrame(adir);
end;

procedure TEffectClass.Finalize;
begin
  if FEffectData <> nil then
  begin
    CharList.EffectDataList.FreeEffectData(FEffectData);
    FEffectData := nil;
  end;

  FEffectShape := 0;
  FEffectName := '';

  FUsed := False;
end;

function TEffectClass.Update(aDir, CurTick: integer): Integer;
begin
  Result := 0;
  if Used = False then
    exit;
  if CurTick < FStartTick then
    exit;

  if CurTick > FDelayTick + FEffectData.Delay[FCurIndex] then
  begin
    FDelayTick := CurTick;
    SetFrame(aDir);
  end;
end;

procedure TEffectClass.SetFrame(aDir: integer);
var
  MaxCount: integer;
begin
  if FEffectData = nil then
    exit;

  MaxCount := FEffectData.DataCount;
  if FEffectKind = lek_followdir then
  begin
    if MaxCount < 1 then
      exit;
    MaxCount := MaxCount div 8;
    FCurIndex := FCurIndex mod MaxCount;
  end;

  inc(FCurIndex);

  if FCurIndex >= MaxCount then
  begin
    // add by minds 021122
    // 厘过 扁葛栏绰 捞棋飘绰 葛记捞 官差扁傈俊绰 拌加利栏肺 老何 橇饭烙阑 馆汗窃
    case FEffectKind of
      lek_hit10:
        FCurIndex := FCurIndex - 4;
      lek_continue:
        FCurIndex := 0;
    else
      begin
        Finalize;
        exit;
      end;
    end;
  end;

  if FEffectKind = lek_followdir then
  begin
    FCurIndex := aDir * MaxCount + FCurIndex;
  end;
end;

procedure TEffectClass.Paint(aDir, aRealx, aRealy: integer; aDrawSet:
  TEffectDraw);
var
  p: PTEffectItem;
  dirX, dirY: integer;
  xx, yy: integer;
  Dib: TXDib;
begin
  if mmAnsTick < FStartTick then
    exit;

  p := FEffectData.GetEffect(FCurIndex);

  if p = nil then
    exit;

  // 规氢, 捞棋飘 己龙俊 蝶弗 谅钎拌魂..
  FEffectData.GetCoordinate(aDir, dirX, dirY);
  case FEffectKind of
    lek_none:
      begin
        xx := RealX + dirX;
        yy := RealY + dirY;
      end;
  else
    begin
      xx := aRealX + dirX;
      yy := aRealY + dirY;
    end;
  end;
  yy := yy + UNITY; // 困摹焊沥

  // Back Image;
  if ED_BACK in aDrawSet then
  begin
    if p^.rBack.rImage >= 0 then
    begin
      Dib := FEffectData.GetBackImage(p);

      case p^.rBack.rDrawType of
        Alpha_Transparent:
          BackScreen.DrawDib(Dib, xx + p^.rBack.rx, yy + p^.rBack.ry, False);
      else // Alpha_Screen
        BackScreen.DrawEffect(Dib, xx + p^.rBack.rx, yy + p^.rBack.ry,
          EffectScreen);
      end;
    end;
  end;

  // Front Image;
  if ED_FRONT in aDrawSet then
  begin
    if p^.rFront.rImage >= 0 then
    begin
      Dib := FEffectData.GetFrontImage(p);

      case p^.rFront.rDrawType of
        Alpha_Transparent:
          BackScreen.DrawDib(Dib, xx + p^.rFront.rx, yy + p^.rFront.ry, False);
        Alpha_Screen:
          if bSetDark then
            BackScreen.DrawEffect(Dib, xx + p^.rFront.rx, yy + p^.rFront.ry,
              EffectScreenDark)
          else
            BackScreen.DrawEffect(Dib, xx + p^.rFront.rx, yy + p^.rFront.ry,
              EffectScreen);
        Alpha_Screen_ColorDodge:
          BackScreen.DrawEffect(Dib, xx + p^.rFront.rx, yy + p^.rFront.ry,
            EffectColorDodge);
        Alpha_Screen_Lighten:
          BackScreen.DrawEffect(Dib, xx + p^.rFront.rx, yy + p^.rFront.ry,
            EffectLighten);
      end;
    end;
  end;

  // FrontSub Image;
  if ED_FRONTSUB in aDrawSet then
  begin
    if p^.rFrontSub.rImage >= 0 then
    begin
      Dib := FEffectData.GetFrontSubImage(p);
      case p^.rFrontSub.rDrawType of
        Alpha_Screen_Lighten:
          BackScreen.DrawEffect(Dib, xx + p^.rFrontSub.rx, yy + p^.rFrontSub.ry,
            EffectLighten);
      else
        BackScreen.DrawEffect(Dib, xx + p^.rFrontSub.rx, yy + p^.rFrontSub.ry,
          EffectScreen);
      end;
    end;
  end;

  // Shadow Image;
  if ED_SHADOW in aDrawSet then
  begin
    if p^.rShadow.rImage >= 0 then
    begin
      Dib := FEffectData.GetShadowImage(p);
      BackScreen.DrawDib(Dib, xx + p^.rShadow.rx, yy + p^.rShadow.ry, True);
    end;
  end;

end;

//////////////////////////////////
//         Moving Magic Class
//////////////////////////////////

procedure GetGreenColorAndAdd(acolor: integer; var GreenColor, GreenAdd:
  integer);
begin
  if (acolor >= 256) or (acolor < 0) then
    acolor := 0;
  GreenColor := ColorDataTable[acolor * 2];
  GreenAdd := ColorDataTable[acolor * 2 + 1];
end;

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

procedure TMovingMagicClass.Initialize(sid, eid, adeg, aspeed, ax, ay, atx, aty,
  aMagicShape, CurTick: integer; aType: byte);
//var
//   Cl: TCharClass;
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
  MagicShape := aMagicShape;
  MagicType := aType;
  LifeCycle := 30;
  Direction := GetDegDirection(deg);
  SetAction(MAT_SHOW, mmAnsTick);

  MsImageLib := nil;
  MmImageLib := FAtzClass.GetImageLib('y' + IntToStr(MagicShape) + '.atz',
    CurTick);
  MeImageLib := nil;

  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
  FUsed := TRUE;

  // add by minds 1219 MovingMagic俊 鸥百捞 嘎疽阑锭 effect眠啊侩 函荐狼 檬扁拳
  eEffectNumber := 0;
  eEffectKind := lek_none;
  {  // HitLock 焊幅
     Cl := CharList.GetChar(EndId);
     if Assigned(Cl) then Cl.SetHitLock;
  }
end;

// add by minds 1219 MovingMagic俊 鸥百捞 嘎疽阑锭 effect眠啊

procedure TMovingMagicClass.SetEndEffect(aEffectNumber: integer; aEffectKind:
  TLightEffectKind);
begin
  eEffectNumber := aEffectNumber;
  eEffectKind := aEffectKind;
end;

procedure TMovingMagicClass.SetAction(aAction: TMagicActionType; CurTime:
  integer);
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
end;

procedure TMovingMagicClass.Finalize;
begin
  FUsed := FALSE;
end;

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
        if MsImageLib = nil then
          exit;
        case MagicType of
          0:
            begin
              // change by minds 1221 规氢俊 蝶弗 frame瘤沥规侥 函版, 眠饶 抛捞喉肺 贸府夸噶
              case MmImageLib.Count of
                80: tempframe := curframe + Direction * 10;
                40: tempframe := curframe + Direction * 5;
                32: tempframe := curframe + Direction * 4;
              else
                tempframe := curframe;
              end;
              {if MmImageLib.Count = 80 then tempframe := curframe + Direction * 10
               else tempframe := curframe;                                         }
            end;
          1:
            begin
              tempframe := Random(MmImageLib.Count - 1);
              overValue := random(3) + 7;
            end;
        end;
        BackScreen.DrawImageOveray(MsImageLib.Images[tempframe], DrawX, DrawY,
          overValue);
      end;
    MAT_MOVE:
      begin
        if MmImageLib = nil then
          exit;
        case MagicType of
          0:
            begin
              // change by minds 1221 规氢俊 蝶弗 frame瘤沥规侥 函版
              case MmImageLib.Count of
                80: tempframe := curframe + Direction * 10;
                40: tempframe := curframe + Direction * 5;
                32: tempframe := curframe + Direction * 4;
              else
                tempframe := curframe;
              end;
              {if MmImageLib.Count = 80 then tempframe := curframe + Direction * 10
               else tempframe := curframe;                                         }
            end;
          1:
            begin
              tempframe := Random(MmImageLib.Count - 1);
              overValue := random(3) + 7;
            end;
        end;
        BackScreen.DrawImageOveray(MmImageLib.Images[tempframe], DrawX, DrawY,
          overValue);
      end;
    MAT_HIDE:
      begin
        if MeImageLib = nil then
          exit;
        case MagicType of
          0:
            begin
              // change by minds 1221 规氢俊 蝶弗 frame瘤沥规侥 函版
              case MmImageLib.Count of
                80: tempframe := curframe + Direction * 10;
                40: tempframe := curframe + Direction * 5;
                32: tempframe := curframe + Direction * 4;
              else
                tempframe := curframe;
              end;
              {if MmImageLib.Count = 80 then tempframe := curframe + Direction * 10
               else tempframe := curframe;                                         }
            end;
          1:
            begin
              tempframe := Random(MmImageLib.Count - 1);
              overValue := random(3) + 7;
            end;
        end;
        BackScreen.DrawImageOveray(MeImageLib.Images[tempframe], DrawX, DrawY,
          overValue);
      end;
  end;
end;

procedure GetDegNextPosition2(deg, speed: word; var DrawX, DrawY: integer;
  TickDiff: integer);
var
  dx, dy: integer;
  r: real;
begin
  r := PI * deg / 180 - PI / 2;

  if TickDiff > 5 then
    TickDiff := 5;

  dy := Round(sin(r) * speed * TickDiff / 3);
  dx := Round(cos(r) * speed * TickDiff / 3);

  Drawx := DrawX + dx;
  DrawY := DrawY + dy;
end;

function TMovingMagicClass.Update(CurTick: integer): Integer;
var
  tdrawx, tdrawy, len: integer;
  PassTime: LongInt;
  tdeg: word;
  cl: TCharClass;
begin
  Result := 0;
  if MagicCurAction = MAT_MOVE then
    Result := 1;

  PassTime := CurTick - integer(ActionStartTime); // 青悼捞 场车栏搁

  case MagicCurAction of
    MAT_SHOW:
      begin
        curframe := PassTime div MAGICNEXTTIME;
        if curframe >= 7 then
        begin
          SetAction(MAT_MOVE, CurTick);
          LastTick := CurTick;
        end;
        DrawX := x * UNITX + UNITXS;
        DrawY := y * UNITY - UNITYS;
        CharList.GetVarRealPos(StartId, DrawX, DrawY);
        case MagicType of
          0:
            ;
          1:
            begin
              if MagicCount > 0 then
              begin
                with OldMovingMagicR do
                begin
                  CharList.AddMagic(asid, aeid, Random(360), Random(15) + 10, ax
                    + Random(5), ay + Random(5), atx + Random(5), aty +
                    Random(5),
                    aMagicShape, CurTick, 0);
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
        if curframe >= 10 then
          curframe := 0;
        Dec(LifeCycle);

        if LifeCycle = 0 then
          SetAction(MAT_HIDE, CurTick);

        GetDegNextPosition2(deg, speed, DrawX, DrawY, CurTick - LastTick);
        LastTick := CurTick;
        tdeg := GetDeg(DrawX, DrawY, tdrawx, tdrawy);

        len := (DrawX - tDrawx) * (DrawX - tDrawx) + (DrawY - tDrawy) * (DrawY -
          tDrawy);
        if len < 400 then
        begin
          Drawx := tDrawx;
          Drawy := tDrawy;
          SetAction(MAT_HIDE, CurTick);

          // add by minds 1219 嘎阑锭 Effect狼 眠啊
          cl := CharList.GetChar(EndID);
          if cl <> nil then
          begin
            if eEffectNumber > 0 then
            begin
              cl.Feature.rEffectNumber := eEffectNumber;
              cl.Feature.rEffectKind := eEffectKind;
            end;
            //                  cl.ReleaseHitLock;
          end;

          exit;
        end;

        deg := GetNewDeg(deg, tdeg, 20);
        if ArriveFlag then
          if abs(deg - tdeg) > 100 then
            SetAction(MAT_HIDE, CurTick);

        if deg = tdeg then
          ArriveFlag := TRUE;
        case MagicType of
          0:
            ;
          1:
            begin
              if MagicCount > 0 then
              begin
                with OldMovingMagicR do
                begin
                  CharList.AddMagic(asid, aeid, Random(360), Random(15) + 10, ax
                    + Random(5), ay + Random(5), atx + Random(5), aty +
                    Random(5),
                    aMagicShape, CurTick, 0);
                end;
                Dec(MagicCount);
              end;
            end;
        end;
      end;
    MAT_HIDE:
      begin
        curframe := PassTime div MAGICNEXTTIME;
        if curframe >= 10 then
          SetAction(MAT_DESTROY, CurTick);

        DrawX := tx * UNITX + UNITXS;
        DrawY := ty * UNITY - UNITYS;
        CharList.GetVarRealPos(EndId, DrawX, DrawY);

      end;
    MAT_DESTROY: exit;
  end;
  RealX := DrawX;
  RealY := DrawY;
end;

{
//////////////////////////////////
//         BgEffect Class
//////////////////////////////////
constructor TBgEffect.Create (aAtzClass: TAtzClass);
begin
   FAtzClass := aAtzClass;
   BgEffectImage := nil; //TA2Image.Create (BgEffectMaxSize, BgEffectMaxSize, 0, 0);
end;

destructor  TBgEffect.Destroy;
begin
   inherited destroy;
end;

// change by minds 1218 CurTick眠啊
procedure   TBgEffect.Initialize (ax, ay: integer; aBgEffectShape: integer; aLightEffectKind: TLightEffectKind; CurTick: integer);
begin
   BgEffectShape := aBgEffectShape;
   FFileName := format ('_%d.atz', [BgEffectShape]);
   EffectPositionData := EffectPositionClass.GetPosition (FFilename);
   BgOverValue := EffectPositionData.rArr[0];
   if BgOverValue < 1 then BgOverValue := 20;
   BgEffectTime := EffectPositionData.rArr[1];
   if BgEffectTime < 1 then BgEffectTime := 8;

   LightEffectKind := aLightEffectKind;

   RealX := ax * UNITX + UNITX div 2;
   RealY := ay * UNITY + UNITY div 2;
   BgEffectIndex := 0;
   DelayTick := CurTick;
   FUsed := TRUE;
end;

procedure   TBgEffect.Finalize;
begin
   BGEffectImage := nil;
   FFileName := '';
   FUsed := FALSE;
end;

procedure   TBgEffect.Paint(aRealx, aRealy : integer);
begin
   if Used and Assigned(BgEffectImage) then begin
      case LightEffectKind of
         lek_none :
            BackScreen.DrawImageOveray (BgEffectImage, RealX, RealY, BgOverValue);
         lek_follow :
            BackScreen.DrawImageOveray (BgEffectImage, aRealX, aRealY, BgOverValue);
         lek_future :;
      end;
   end;
end;

procedure   TBgEffect.SetFrame(CurTick : integer);
var
   ImageLib : TA2ImageLib;
begin
   if Used = FALSE then exit;
   ImageLib := FAtzClass.GetImageLib (FFileName, CurTick);
   if ImageLib <> nil then begin
      if BgEffectIndex >= ImageLib.Count then begin
         Finalize;
         exit;
      end;

      if ImageLib.Images[BgEffectIndex] <> nil then begin
         BgEffectImage := ImageLib.Images[BgEffectIndex];
      end;
//      if BgEffectImage <> nil then BgEffectImage.Free;
//      if BgEffectImage <> nil then BgEffectImage := nil;
//      BgEffectImage := TA2Image.Create (BgEffectMaxSize, BgEffectMaxSize, 0, 0);
//      BgEffectImage.DrawImage (ImageLib.Images[BgEffectIndex], ImageLib.Images[BgEffectIndex].px+BgEffectMaxSizeHalf, ImageLib.Images[BgEffectIndex].py+BgEffectMaxSizeHalf, TRUE);
//      BgEffectImage.Optimize;
   end;

   inc (BgEffectIndex);
end;

function    TBgEffect.Update ( CurTick: integer) : Integer;
begin
   Result := 0;
   if CurTick > DelayTick + BgEffectTime then begin
      DelayTick := CurTick;
      SetFrame(CurTick);
   end;
end;
}
//////////////////////////////////
//         DynamicObject Class
//////////////////////////////////

constructor TDynamicObject.Create(aAtzClass: TAtzClass);
begin
  FAtzClass := aAtzClass;
  //   DynamicObjImage := TA2Image.Create (DynamicObjectMaxSize, DynamicObjectMaxSize, 0, 0);
  DynamicObjImage := nil;
  StructedTick := 0;
  StructedPercent := 0;

  FStartFrame := 0;
  FEndFrame := 0;
  // add by minds 020319 DynamicObject俊 捞棋飘眠啊
  FEffect := nil;
end;

destructor TDynamicObject.Destroy;
begin
  // add by minds 020323
  Finalize;
  inherited destroy;
end;

procedure TDynamicObject.Initialize(aItemName: string; aId, ax, ay, aItemShape:
  integer; aStartFrame, aEndFrame: Word; aState: byte; aDynamicGuard:
  TDynamicGuard);
begin
  DynamicObjName := aItemName;
  id := aid;
  x := ax;
  y := ay;
  DynamicObjShape := aItemShape;
  DynamicObjectState := aState;
  if DynamicObjectState = 1 then
    DynamicObjIndex := Random(5 + aStartFrame)
  else
    DynamicObjIndex := aStartFrame;
  FDynamicGuard := aDynamicGuard;
  FStartFrame := aStartFrame;
  FEndFrame := aEndFrame;
  DelayTick := 0;

  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
  FUsed := TRUE;

  // add by minds 020319 DynamicObject俊 捞棋飘眠啊
  if Assigned(FEffect) then
  begin
    FEffect.Free;
    FEffect := nil;
  end;
end;

procedure TDynamicObject.Finalize;
begin
  FUsed := FALSE;
  DynamicObjName := '';
  DynamicObjImage := nil;
  id := 0;
  // add by minds 020319 DynamicObject俊 捞棋飘眠啊
  if Assigned(FEffect) then
  begin
    FEffect.Free;
    FEffect := nil;
  end;
end;

// add by minds 020319 DynamicObject俊 捞棋飘眠啊

procedure TDynamicObject.AddBGEffect(aEffectShape: integer; aEffectKind:
  TLightEffectKind);
begin

  if FEffect = nil then
    FEffect := TEffectClass.Create; //TBGEffect.Create(FAtzClass);

  FEffect.Initialize(0, RealX, RealY, AEffectShape, aEffectKind, mmAnsTick);

end;

procedure TDynamicObject.ChangeProperty(pCP: PTSChangeProperty);
begin
  DynamicObjName := StrPas(@pCP^.rNameString);
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
  if DynamicObjImage = nil then
    exit;
  xx := RealX + DynamicObjImage.px;
  yy := RealY + DynamicObjImage.py;

  if (ax <= xx) then
    Result := FALSE;
  if (ay <= yy) then
    Result := FALSE;
  if ax >= xx + DynamicObjImage.Width then
    Result := FALSE;
  if ay >= yy + DynamicObjImage.Height then
    Result := FALSE;
  if Result = FALSE then
    exit;

  xp := ax - xx;
  yp := ay - yy;

  pb := PWORD(DynamicObjImage.bits);
  inc(pb, xp + yp * DynamicObjImage.Width);
  if pb^ = 0 then
    Result := FALSE;
  { 盔夯
  xx := RealX + DynamicObjImage.px - DynamicObjectMaxSizeHalf;
  yy := RealY + DynamicObjImage.py - DynamicObjectMaxSizeHalf;

  if (ax <= xx) then Result := FALSE;
  if (ay <= yy) then Result := FALSE;
  if ax >= xx + DynamicObjImage.Width then Result := FALSE;
  if ay >= yy + DynamicObjImage.Height then Result := FALSE;
  if Result = FALSE then exit;

  xp := ax-xx;
  yp := ay-yy;

  pb := PWORD (DynamicObjImage.bits);
  inc (pb, xp + yp*DynamicObjImage.Width);
  if pb^ = 0 then Result := FALSE;
  }
end;

procedure TDynamicObject.SetFrame(aDynamicObjectState: byte; CurTick: integer);
var
  ImageLib: TA2ImageLib;
begin
  //   DynamicObjImage.Free;
  DynamicObjImage := nil;
  //   DynamicObjImage := TA2Image.Create (DynamicObjectMaxSize, DynamicObjectMaxSize, 0, 0);
  case aDynamicObjectState of
    0: // ex 惑磊 : 凯府绰 葛嚼
      begin
        ImageLib := FAtzClass.GetImageLib(format('x%d.atz', [DynamicObjShape]),
          CurTick);
        if ImageLib <> nil then
        begin
          if DynamicObjIndex > FEndFrame then
            DynamicObjIndex := FEndFrame;
          if (ImageLib <> nil) and (ImageLib.Images[DynamicObjIndex] <> nil)
            then
          begin
            DynamicObjImage := ImageLib.Images[DynamicObjIndex];
            //                  DynamicObjImage.DrawImage (ImageLib.Images[DynamicObjIndex], ImageLib.Images[DynamicObjIndex].px+DynamicObjectMaxSizeHalf, ImageLib.Images[DynamicObjIndex].py+DynamicObjectMaxSizeHalf, TRUE);
            //                  DynamicObjImage.Optimize;
          end;
          Inc(DynamicObjIndex)
        end;
      end;
    1: // ex 巩颇檬籍 拳肺 : 拌加利栏肺 Scroll凳
      begin
        ImageLib := FAtzClass.GetImageLib(format('x%d.atz', [DynamicObjShape]),
          CurTick);
        if ImageLib <> nil then
        begin
          if DynamicObjIndex > FEndFrame then
            DynamicObjIndex := FStartFrame;
          if (ImageLib <> nil) and (ImageLib.Images[DynamicObjIndex] <> nil)
            then
          begin
            DynamicObjImage := ImageLib.Images[DynamicObjIndex];
            //                  DynamicObjImage.DrawImage (ImageLib.Images[DynamicObjIndex], ImageLib.Images[DynamicObjIndex].px+DynamicObjectMaxSizeHalf, ImageLib.Images[DynamicObjIndex].py+DynamicObjectMaxSizeHalf, TRUE);
            //                  DynamicObjImage.Optimize;
          end;
          Inc(DynamicObjIndex)
        end;
      end;
  end;
end;

procedure TDynamicObject.Paint;
begin
  if (FEffect <> nil) and (FEffect.FUsed = True) then
  begin
    FEffect.Paint(0, RealX, Realy + UNITY, [ED_BACK]);
  end;
  //   if DynamicObjImage <> nil then BackScreen.DrawImage (DynamicObjImage, RealX-DynamicObjectMaxSizeHalf, RealY-DynamicObjectMaxSizeHalf, TRUE);
  if DynamicObjImage <> nil then
  begin
    BackScreen.DrawImageKeyColor(DynamicObjImage, RealX, RealY);
    if bGridOn then
      BackScreen.DrawImageOveray(CellCheckImg, RealX, RealY, 30);
  end;
  if StructedTick <> 0 then
    BackScreen.DrawStructed(RealX, RealY, 55, StructedPercent);

  // add by minds 020319 DynamicObject俊 捞棋飘眠啊
  if (FEffect <> nil) and (FEffect.FUsed = True) then
  begin
    //      BGEffect.Paint(RealX + BGEffect.EffectPositionData.rArr[2], RealY + BGEffect.EffectPositionData.rArr[3]);
    FEffect.Paint(0, RealX, Realy + UNITY, [ED_FRONT, ED_FRONTSUB, ED_SHADOW]);
  end;
end;

function TDynamicObject.Update(CurTick: integer): Integer;
begin
  Result := 0;
  if StructedTick + 200 < CurTick then
    StructedTick := 0;
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
  {   // add by minds 1219
     BGEffect := nil;
     EffectShape := 0;
  }
end;

destructor TItemClass.Destroy;
begin
  ItemImage.Free;
  {  // add by minds 1219
     if BGEffect <> nil then BGEffect.Free;
  }
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
  ItemImage.Free;
  ItemImage := TA2Image.Create(140, 140, 0, 0);

  GetGreenColorAndAdd(ItemColor, gc, ga);
  ItemImage.DrawImageGreenConvert(TempImage, 70 - TempImage.Width div 2, 70 -
    TempImage.Height div 2, gc, ga);
  ItemImage.Optimize;
  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
end;

procedure TItemClass.Initialize(aItemName: string; aRace: byte; aId, ax, ay,
  aItemshape, aItemcolor: integer);
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
  if tempImage <> nil then
  begin
    ItemImage.DrawImageGreenConvert(TempImage, 70 - TempImage.Width div 2, 70 -
      TempImage.Height div 2, gc, ga);
    ItemImage.Optimize;
  end;
  RealX := x * UNITX + UNITX div 2;
  RealY := y * UNITY + UNITY div 2;
  Race := aRace;
  FUsed := TRUE;
  {   // add by minds 1219, Item捞 冻绢瘤绰 瓤苞.
     ItemHeight := 69;
     FallX := 0;
  }
end;

procedure TItemClass.Finalize;
begin
  FUsed := FALSE;
  ItemName := '';
  id := 0;
  Race := RACE_ITEM;
  {  // add by minds 1219
     ItemHeight := 0;
     if BGEffect <> nil then BGEffect.Free;
     BGEffect := nil;
  }
end;

{ // add by minds 1219
procedure TItemClass.AddBGEffect(aEffectShape: integer; aEffectKind:TLightEffectKind);
begin
   if BGEffect = nil then
      BGEffect := TBGEffect.Create(FAtzClass);

   EffectShape := aEffectShape;
   EffectKind := aEffectKind;
end;
}

procedure TItemClass.ChangeProperty(pCP: PTSChangeProperty);
begin
  ItemName := StrPas(@pCP^.rNameString);
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

  if (ax <= xx) then
    Result := FALSE;
  if (ay <= yy) then
    Result := FALSE;
  if ax >= xx + ItemImage.Width then
    Result := FALSE;
  if ay >= yy + ItemImage.Height then
    Result := FALSE;
  if Result = FALSE then
    exit;

  xp := ax - xx;
  yp := ay - yy;

  pb := PWORD(ItemImage.bits);
  inc(pb, xp + yp * ItemImage.Width);
  if pb^ = 0 then
    Result := FALSE;
end;

procedure TItemClass.Paint;
begin
  // add by minds 酒捞袍捞 冻绢瘤绰 瓤苞
  //   ItemImage.py := ItemImage.py - ItemHeight;
  BackScreen.DrawImage(ItemImage, RealX - 70, RealY - 70, TRUE);
  //   ItemImage.py := ItemImage.py + ItemHeight;
end;

function TItemClass.Update(CurTick: integer): Integer;
begin
  // add by minds 1219, Item俊 Effect 棺 冻绢瘤绰 瓤苞
{
  if (EffectShape > 0) and (BGEffect <> nil) then begin
     BGEffect.Initialize(x, y, EffectShape, EffectKind, CurTick);
     EffectShape := 0;
  end;

  if ItemHeight > 0 then begin
     ItemHeight := 70 - (70 - ItemHeight) * 2;
  end;
  if ItemHeight < 0 then ItemHeight := 0;
}
  Result := 0;
end;

//////////////////////////////////
//         Char Class
//////////////////////////////////

constructor TCharClass.Create(aAtzClass: TAtzClass);
var
  i: integer;
begin
  FAtzClass := aAtzClass;

  for i := 0 to CharImageBufferCount - 1 do
  begin
    CharImageBuffer[i].aCharImage := nil;
    CharImageBuffer[i].aImageNumber := -1;
  end;
  CharImageBuffer[0].aCharImage := TA2Image.Create(CharMaxSiez, CharMaxSiez, 0,
    0);
  CharImageBufferIndex := 0;

  BubbleList := TStringList.Create;
  //   BgEffect := nil;

  FEffectList := nil;
end;

destructor TCharClass.Destroy;
begin
  BubbleList.Free;
  Finalize;
  OverImage := nil;
  inherited destroy;
end;

procedure TCharClass.AddMessage(aRMsg: TRecordMessage);
var
  i: integer;
begin
  for i := 1 to 5 - 1 do
    MessageArr[i - 1] := MessageArr[i];
  FillChar(MessageArr[5 - 1], sizeof(TRecordMessage), 0);
  for i := 0 to 5 - 1 do
  begin
    if MessageArr[i].rmsg = 0 then
    begin
      MessageArr[i] := aRMsg;
      break;
    end;
  end;
end;

procedure TCharClass.GetMessage(var aRMsg: TRecordMessage);
var
  i: integer;
begin
  aRMsg := MessageArr[0];
  for i := 1 to 5 - 1 do
    MessageArr[i - 1] := MessageArr[i];
  FillChar(MessageArr[5 - 1], sizeof(TRecordMessage), 0);
end;

procedure TCharClass.ViewMessage(var aRMsg: TRecordMessage);
begin
  aRMsg := MessageArr[0];
end;
{
procedure   TCharClass.AddBgEffect (aRealx, aRealy: integer; aShape: integer; aLightEffectKind: TLightEffectKind; CurTick: integer);
begin
   if BgEffect = nil then
      BgEffect := TBgEffect.Create (FAtzClass);

   BgEffect.Initialize (aRealx, aRealy, aShape, aLightEffectKind, CurTick);
   Feature.rEffectNumber := 0;
end;
}

procedure TCharClass.AddEffect(aShape: integer; aLightEffectKind:
  TLightEffectKind; CurTick, DelayTick: integer);
begin
  FEffectList.AddEffect(Dir, RealX, RealY, aShape, aLightEffectKind, DelayTick);

  Feature.rEffectNumber := 0;
end;

function TCharClass.GetArrImageLib(aindex, CurTick: integer): TA2ImageLib;
begin
  if not Feature.rboMan then
    Result := FAtzClass.GetImageLib(char(word('a') + aindex) + format('%d0.atz',
      [Feature.rArr[aindex * 2]]), CurTick)
  else
    Result := FAtzClass.GetImageLib(char(word('n') + aindex) + format('%d0.atz',
      [Feature.rArr[aindex * 2]]), CurTick);
end;

function TCharClass.IsArea(ax, ay: integer): Boolean;
var
  xp, yp: integer;
  xx, yy: integer;
  pb: pword;
begin
  Result := TRUE;

  if Feature.rrace = RACE_MONSTER then
  begin
    if MonImage = nil then
    begin
      Result := FALSE;
      exit;
    end;
    xx := Realx + MonImage.px;
    yy := Realy + MonImage.py;

    if (ax <= xx) then
      Result := FALSE;
    if (ay <= yy) then
      Result := FALSE;
    if ax >= xx + MonImage.Width then
      Result := FALSE;
    if ay >= yy + MonImage.Height then
      Result := FALSE;
    if Result = FALSE then
      exit;
    xp := ax - xx;
    yp := ay - yy;

    pb := PWORD(MonImage.bits);
    inc(pb, xp + yp * MonImage.Width);
    if pb^ = 0 then
      Result := FALSE;
    exit;
  end;

  //////////// char ///////////
  if CharImageBuffer[CharImageBufferIndex].aCharImage = nil then
    exit;
  xx := Realx + CharImageBuffer[CharImageBufferIndex].aCharImage.px -
    CHarMaxSiezHalf;
  yy := Realy + CharImageBuffer[CharImageBufferIndex].aCharImage.py -
    CHarMaxSiezHalf;

  if (ax <= xx) then
    Result := FALSE;
  if (ay <= yy) then
    Result := FALSE;
  if ax >= xx + CharImageBuffer[CharImageBufferIndex].aCharImage.Width then
    Result := FALSE;
  if ay >= yy + CharImageBuffer[CharImageBufferIndex].aCharImage.Height then
    Result := FALSE;
  if Result = FALSE then
    exit;

  xp := ax - xx;
  yp := ay - yy;

  pb := PWORD(CharImageBuffer[CharImageBufferIndex].aCharImage.bits);
  inc(pb, xp + yp * CharImageBuffer[CharImageBufferIndex].aCharImage.Width);
  if pb^ = 0 then
    Result := FALSE;
end;

procedure TCharClass.Initialize(aName: string; aId, adir, ax, ay: integer;
  afeature: TFeature);
begin
  Name := aName;
  id := aid;
  dir := adir; //xxxx := ax; yyyy := ay;
  Feature := aFeature;
  CurFrame := 1;
  CurActionInfo := nil;
  CurAction := -1;
  AniList := Animater.GetAnimationList(aFeature.raninumber);

  FUsed := TRUE;
  OldMakeFrame := -1;

  TurningTick := 0;
  StructedTick := 0;
  StructedPercent := 0;
  // Effect 犬厘
  FEffectList := TEffectList.Create(Self);

  //   RealX := x * UNITX + UNITX div 2;
  //   RealY := y * UNITY + UNITY div 2;

  bUpdatePos := False;
  NewX := ax;
  NewY := ay;
  if bUpdateBasePos then
    bUpdatePos := True
  else
    UpdateCharPos;
  //   NewX := -30;
  //   NewY := -30;
  //   bUpdatePos := False;
  BackX := 0;
  BackY := 0;
  FBackMoveTick := 0;

  OverImage := nil;
  OverImageName := '';

  StoreSign := '';
{$IFNDEF _CHINA}
  //   if Feature.rfeaturestate = wfs_shop then begin
  //      StoreFlag := True;
  //      Feature.rfeaturestate := wfs_sitdown;
  //   end else
  //      StoreFlag := False;
{$ENDIF}

  BubbleList.Clear;
  //   HitLock := False;
end;

procedure TCharClass.Finalize;
var
  i: integer;
begin
  // Effect 犬厘
  FEffectList.Free;
  FEffectList := nil;
  //   FEffect.Free;
  //   FEffect := nil;

  MonImage := nil;
  for i := 0 to CharImageBufferCount - 1 do
  begin
    if CharImageBuffer[i].aCharImage <> nil then
      CharImageBuffer[i].aCharImage.Free;
    CharImageBuffer[i].aCharImage := nil;
    CharImageBuffer[i].aImageNumber := -1;
  end;
  Name := '';
  id := 0;
  dir := 0;
  xxxx := 0;
  yyyy := 0;
  FillChar(Feature, sizeof(Feature), 0);
  FUsed := FALSE;
end;

{
procedure TCharClass.SetHitLock;
begin
   HitLock := True;
   FillChar(WaitMsgs, SizeOf(TWaitMessage)*3, 0);
end;

procedure TCharClass.ReleaseHitLock;
var
   i: integer;
begin
   HitLock := False;
   for i := 0 to 2 do
      with WaitMsgs[i] do begin
         case rMsg of
         0: continue;
         else
            ProcessMessage(rMsg, Dir, X, Y, rFeature, rMotion);
         end;
      end;

end;

procedure TCharClass.WaitHitMessage(aMsg, aMotion: integer; aFeature: TFeature);
var
   i: integer;
begin
   for i := 0 to 2 do
      with WaitMsgs[i] do
         if (rMsg = 0) or (rMsg = aMsg) then begin
            rMsg := aMsg;
            rMotion := aMotion;
            rFeature := aFeature;
            exit;
         end;
end;
}

procedure TCharClass.Say(const astr: string);
begin
  BubbleTick := mmAnsTick;
  BubbleList.Clear;
  BackScreen.GetBubble(BubbleList, astr);
  BubbleColor := WinRGB(31, 31, 31);
  BubbleType := 0;
end;

procedure TCharClass.SayStatic(const astr: string; wCol: Word);
begin
  BubbleList.Clear;
  BackScreen.GetBubble(BubbleList, astr);
  BubbleColor := wCol;
  BubbleType := 1
end;

procedure TCharClass.SetStoreSign(const astr: string);
begin
  StoreSign := astr;
end;

procedure TCharClass.SetCasting(value: Boolean);
begin
  bCasting := value;
end;

function TCharClass.isCasting: Boolean;
begin
  Result := bCasting;
end;

procedure TCharClass.ChangeProperty(pCP: PTSChangeProperty);
begin
  Name := StrPas(@pCP^.rNameString);
end;

procedure TCharClass.SetEffectName(aEffectName: string);
begin
  OverImageName := aEffectName;
end;

function TCharClass.FindAnimation(aact, adir: Integer): PTAniInfo;
var
  i: Integer;
  ainfo: PTAniInfo;
begin
  Result := nil;

  if Feature.rrace = RACE_HUMAN then
  begin
    // 牢埃老锭
    if aact = AM_TURN then
    begin
      SetCasting(false); // 贱厘过某胶泼辆丰.
      case Feature.rFeaturestate of
        wfs_normal: aact := AM_TURN;
        wfs_care: aact := AM_TURN1;
        wfs_sitdown: aact := AM_TURN2;
        wfs_die: aact := AM_TURN3;
        wfs_running: aact := AM_TURN4;
        wfs_running2: aact := AM_TURN5;
      end;
    end;

    if aact = AM_TURNNING then
    begin
      case Feature.rFeaturestate of
        wfs_normal: aact := AM_TURNNING;
        wfs_care: aact := AM_TURNNING1;
        wfs_sitdown: aact := AM_TURNNING2;
        wfs_die: aact := AM_TURNNING3;
        wfs_running: aact := AM_TURNNING4;
        wfs_running2: aact := AM_TURNNING5;
      end;
    end;

    if aact = AM_MOVE then
    begin
      case Feature.rFeaturestate of
        wfs_normal: aact := AM_MOVE;
        wfs_care: aact := AM_MOVE1;
        wfs_sitdown: aact := AM_MOVE2;
        wfs_die: aact := AM_MOVE3;
        wfs_running: aact := AM_MOVE4;
        wfs_running2: aact := AM_MOVE5;
      end;
    end;
  end
  else
  begin
    // 阁胶磐老锭
    if aact = AM_TURN then
    begin
      SetCasting(false); // 贱厘过某胶泼辆丰.
      case Feature.rFeaturestate of
        wfs_normal: aact := AM_TURN;
        wfs_care: aact := AM_TURN;
        wfs_sitdown: aact := AM_TURN;
        wfs_die: aact := AM_TURN3;
        wfs_running: aact := AM_TURN;
        wfs_running2: aact := AM_TURN;
      end;
    end;

    if aact = AM_TURNNING then
    begin
      case Feature.rFeaturestate of
        wfs_normal: aact := AM_TURNNING;
        wfs_care: aact := AM_TURNNING;
        wfs_sitdown: aact := AM_TURNNING;
        wfs_die: aact := AM_TURNNING3;
        wfs_running: aact := AM_TURNNING;
        wfs_running2: aact := AM_TURNNING;
      end;
    end;

    if aact = AM_MOVE then
    begin
      case Feature.rFeaturestate of
        wfs_normal: aact := AM_MOVE;
        wfs_care: aact := AM_MOVE;
        wfs_sitdown: aact := AM_MOVE;
        wfs_die: aact := AM_MOVE3;
        wfs_running: aact := AM_MOVE;
        wfs_running2: aact := AM_MOVE;
      end;
    end;
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
end;

procedure TCharClass.ChangeFeature(var aFeature: TFeature);
var
  i: integer;
begin
  OldMakeFrame := -1;
  MonImage := nil;
  for i := 0 to CharImageBufferCount - 1 do
  begin
    if CharImageBuffer[i].aCharImage <> nil then
      CharImageBuffer[i].aCharImage.Free;
    CharImageBuffer[i].aCharImage := nil;
    CharImageBuffer[i].aImageNumber := -1;
  end;
  CharImageBuffer[0].aCharImage := TA2Image.Create(CharMaxSiez, CharMaxSiez, 0,
    0);
  CharImageBufferIndex := 0;

  if Feature.raninumber <> afeature.raninumber then
    AniList := Animater.GetAnimationList(afeature.raninumber);
  //dir := adir; x := ax; y := ay;

  // add by minds 021202
  if aFeature.rFeatureState = wfs_shop then
  begin
    aFeature.rFeatureState := wfs_sitdown;
    StoreFlag := True;
  end
  else
    StoreFlag := False;

  if (Feature.rfeaturestate <> wfs_sitdown) and (aFeature.rFeatureState =
    wfs_sitdown) then
  begin
    CurActionInfo := FindAnimation(AM_SEATDOWN, dir);
    SetCurrentFrame(CurActionInfo, 0, mmAnsTick);
    CurAction := SM_MOTION;
  end;

  if (Feature.rfeaturestate = wfs_sitdown) and (aFeature.rFeatureState <>
    wfs_sitdown) then
  begin
    CurActionInfo := FindAnimation(AM_STANDUP, dir);
    SetCurrentFrame(CurActionInfo, 0, mmAnsTick);
    CurAction := SM_MOTION;
  end;

  if (Feature.rfeaturestate <> wfs_die) and (aFeature.rFeatureState = wfs_die)
    then
  begin
    {  // HitLock 焊幅 021202
    if HitLock then begin
       WaitHitMessage(amsg, amotion, aFeature);
       exit;
    end
    }
    CurActionInfo := FindAnimation(AM_DIE, dir);
    SetCurrentFrame(CurActionInfo, 0, mmAnsTick);
    CurAction := SM_MOTION;
  end;

  Feature := aFeature;
  if Feature.rEffectNumber > 0 then
  begin
    //               AddBgEffect (ax, ay, Feature.rEffectNumber-1, Feature.rEffectKind, CurTick);
    AddEffect(Feature.rEffectNumber - 1, Feature.rEffectKind, mmAnsTick);
  end;
end;

procedure TCharClass.Structed(aPercent: integer);
begin
  OldMakeFrame := -1;
  StructedTick := mmAnsTick;
  StructedPercent := aPercent;
end;

procedure TCharClass.SetPosition(adir, ax, ay: integer);
begin
  OldMakeFrame := -1;
  dir := adir;
  NewX := ax;
  NewY := ay;
  if bUpdateBasePos then
    bUpdatePos := True
  else
    UpdateCharPos;

  CurActionInfo := FindAnimation(AM_TURN, dir);
  SetCurrentFrame(CurActionInfo, 0, mmAnsTick);
  CurAction := SM_TURN;
end;

procedure TCharClass.SetTurn(adir: integer);
begin
  OldMakeFrame := -1;
  dir := adir;
  CurActionInfo := FindAnimation(AM_TURN, dir);
  SetCurrentFrame(CurActionInfo, 0, mmAnsTick);
  CurAction := SM_TURN;
end;

procedure TCharClass.Move(adir, ax, ay: integer);
begin
  OldMakeFrame := -1;
  NewX := ax;
  NewY := ay;
  if bUpdateBasePos then
    bUpdatePos := True
  else
    UpdateCharPos;

  dir := adir;
  CurActionInfo := FindAnimation(AM_MOVE, dir);
  SetCurrentFrame(CurActionInfo, 0, mmAnsTick);
  CurAction := SM_MOVE;
end;

procedure TCharClass.BackMove(adir, ax, ay: integer);
begin
  SetPosition(adir, ax, ay);
  {
     OldMakeFrame := -1;
     BackX := (xxxx - ax) * UNITX;
     BackY := (yyyy - ay) * UNITY;
     FBackMoveTick := mmAnsTick;
     NewX := ax; NewY := ay;
     if bUpdateBasePos then bUpdatePos := True
                       else UpdateCharPos;

     dir := adir;
  }
end;

procedure TCharClass.SetMotion(aMotion: integer);
begin
  OldMakeFrame := -1;
  if amotion = AM_HIT10_READY then
    SetCasting(True);

  CurActionInfo := FindAnimation(amotion, dir);
  SetCurrentFrame(CurActionInfo, 0, mmAnsTick);
  CurAction := SM_MOTION;
end;

procedure TCharClass.SetCurrentFrame(aAniInfo: PTAniInfo; aFrame, CurTime:
  integer);
begin
  if aAniInfo = nil then
  begin
    Error := 10;
    exit;
  end;
  FrameStartTime := CurTime;
  Curframe := aFrame;
  ImageNumber := aAniInfo^.Frames[CurFrame];
end;

procedure TCharClass.SetCurrentPos;
var
  bBackMove: Boolean;
  pxs, pys: integer;
begin
  if CurActionInfo <> nil then
  begin
    pxs := CurActionInfo.Pxs[curframe] + UNITXS;
    pys := CurActionInfo.Pys[curframe] - UNITYS;
  end
  else
  begin
    pxs := UNITXS;
    pys := -UNITYS;
  end;

  RealX := x * UNITX + pxs;
  RealY := y * UNITY + pys;

  bBackMove := False;

  if BackX <> 0 then
  begin
    RealX := RealX + BackX;
    bBackMove := True;
  end;
  if BackY <> 0 then
  begin
    RealY := RealY + BackY;
    bBackMove := True;
  end;

  if bBackMove and (FBackMoveTick + 10 < mmAnsTick) then
  begin
    FBackMoveTick := mmAnsTick;
    BackX := BackX div 2;
    BackY := BackY div 2;
  end;
end;

function TCharClass.AllowAddAction: Boolean;
begin
  Result := FALSE;
  if CurActionInfo = nil then
  begin
    Result := TRUE;
    exit;
  end;
  if (CurAction = SM_TURN) then
    Result := TRUE;
  if (CurActionInfo^.Frame - 2 = curframe) then
    Result := TRUE;
  if Feature.rfeaturestate = wfs_die then
    Result := FALSE;
  if Feature.rfeaturestate = wfs_sitdown then
    Result := FALSE;
end;

procedure TCharClass.MakeFrame(aindex, CurTick: integer);
var
  i, block, bidx: integer;
  addx, addy: integer;
  gc, ga: integer;
  boflag: Boolean;
  ImageLib: TA2ImageLib;
  CharImage, LibImage: TA2Image;
  CharWord: word;

  function GetImageLibName(aFeature: TFeature; i, block: integer): string;
  begin
    if aFeature.rboMan then
      result := Chr(Ord('n') + i)
    else
      result := Chr(Ord('a') + i);

    result := result + format('%d%d.atz', [aFeature.rArr[i * 2], block]);
  end;
begin
  if (Feature.rFlyHeight > 0) and (Feature.rFlyHeight < 32) then
  begin
    addx := CHarMaxSiezHalf;
    addy := CHarMaxSiezHalf - Feature.rFlyHeight - Random(2);
  end
  else
  begin
    addx := CHarMaxSiezHalf;
    addy := CHarMaxSiezHalf;
  end;

  block := aindex div 500;
  bidx := aindex mod 500;

  if Feature.rrace <> RACE_MONSTER then
  begin
    if OverImageName <> '' then
    begin
      if CurActionInfo <> nil then
      begin
        if CurActionInfo.Action in [30..39] then
        begin
          ImageLib := FAtzClass.GetImageLib(OverImageName, CurTick);
          if (ImageLib <> nil) and (ImageLib.Images[bidx] <> nil) then
            OverImage := ImageLib.Images[bidx];
        end
        else
          OverImage := nil;
      end;
    end;
  end;

  if Feature.rrace = RACE_MONSTER then
  begin
    with Feature do
    begin
      ImageLib := FAtzClass.GetImageLib(format('z%d.atz', [rImageNumber]),
        CurTick);
      if (ImageLib <> nil) and (ImageLib.Images[bidx] <> nil) then
      begin
        MonImage := ImageLib.Images[bidx];
        case Feature.rHideState of
          hs_100: // 老馆利牢 葛嚼
            begin
              //                     ScaleImage := TA2Image.Create(MonImage.Width{*123+50) div 100}, (MonImage.Height*79+50) div 100, MonImage.px, MonImage.py);
              //                     ScaleImage.MakeImageScale(MonImage);
              BackScreen.DrawImageKeyColor(MonImage, RealX, RealY);
              //                     ScaleImage.Free;
            end;
          hs_0: ;
          hs_1: // 篮脚吝烙 CharCenterID 老版快 荤侩磊祈狼肺 距埃颇鄂祸捞 啊固等 版快 Refracrange : 4 overValue : 3
            BackScreen.DrawRefractive(MonImage, RealX, RealY, 4, 3);
          hs_99: // 篮脚吝 荤侩磊啊 篮脚焊绰 付过殿阑 荤侩矫 距埃 焊捞绰版快 Refracrange : 4 overValue : 0
            BackScreen.DrawRefractive(MonImage, RealX, RealY, 4, 0);
        end;
      end
      else
        MonImage := nil;
      ImageLib := FAtzClass.GetImageLib(format('z%dm.atz', [rImageNumber]),
        CurTick);
      if (ImageLib <> nil) and (ImageLib.Images[bidx] <> nil) then
      begin
        OverImage := ImageLib.Images[bidx];
        BackScreen.DrawImageOveray(OverImage, RealX, RealY, 20);
      end
      else
        OverImage := nil;
    end;
    exit;
  end;

  if aindex = OldMakeFrame then
    exit;
  OldMakeFrame := aindex;

  /////////////
  //   MonImage := nil;
  for i := 0 to CharImageBufferCount - 1 do
  begin
    if CharImageBuffer[i].aImageNumber = aindex then
    begin
      if CharImageBuffer[i].aCharImage <> nil then
      begin
        CharImageBufferIndex := i;
        exit;
      end;
    end;
  end;

  CharImageBufferIndex := -1;
  for i := 0 to CharImageBufferCount - 1 do
  begin
    if CharImageBuffer[i].aImageNumber = -1 then
    begin
      if CharImageBuffer[i].aCharImage <> nil then
      begin
        CharImageBufferIndex := i;
        break;
      end;
    end;
  end;

  if CharImageBufferIndex = -1 then
  begin
    CharImageBufferIndex := Random(CharImageBufferCount - 1);
    if CharImageBufferIndex > CharImageBufferCount then
      CharImageBufferIndex := 0;
  end;

  //   try
  CharImageBuffer[CharImageBufferIndex].aCharImage.Free;
  //   finally
  CharImageBuffer[CharImageBufferIndex].aCharImage :=
    TA2Image.Create(CharMaxSiez, CharMaxSiez, 0, 0);
  //   end;

  CharImageBuffer[CharImageBufferIndex].aImageNumber := aIndex;

  CharImage := CharImageBuffer[CharImageBufferIndex].aCharImage;
  ///////////
  if bShadowDraw then
  begin
    CharWord := Word('0');
    if Feature.rboMan then
      CharWord := Word('1');
    ImageLib := FAtzClass.GetImageLib(Char(CharWord) + format('%d%d.atz',
      [Feature.rArr[0], block]), CurTick);
    if (ImageLib <> nil) and (ImageLib.Images[bidx] <> nil) then
    begin
      LibImage := ImageLib.Images[bidx];
      CharImage.DrawImage(LibImage, LibImage.px + CHarMaxSiezHalf, LibImage.py +
        CHarMaxSiezHalf, FALSE);
    end;
  end;

  for i := 0 to 5 do
  begin
    ImageLib := FAtzClass.GetImageLib(GetImageLibName(Feature, i, block),
      CurTick);
    {
          if not Feature.rboMan then ImageLib := FAtzClass.GetImageLib (char(word('a')+i) + format ('%d%d.atz', [Feature.rArr[i*2],block]), CurTick)
          else               ImageLib := FAtzClass.GetImageLib (char(word('n')+i) + format ('%d%d.atz', [Feature.rArr[i*2],block]), CurTick);
    }
    if ImageLib = nil then
      continue;
    if ImageLib.Count <= bidx then
      continue;
    LibImage := ImageLib.Images[bidx];
    if LibImage <> nil then
    begin
      if Feature.rArr[i * 2 + 1] = 0 then
        CharImage.DrawImage(LibImage, LibImage.px + addx, LibImage.py + addy,
          true)
      else
      begin
        GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
        CharImage.DrawImageGreenConvert(LibImage, LibImage.px + addx, LibImage.py
          + addy, gc, ga);
      end;
    end;
    {
          if Feature.rArr[i*2+1] = 0 then begin
             if (ImageLib <> nil) and (ImageLib.Images[bidx] <> nil) then CharImageBuffer[CharImageBufferIndex].aCharImage.DrawImage (ImageLib.Images[bidx], ImageLib.Images[bidx].px+addx, ImageLib.Images[bidx].py+addy, TRUE)
          end else begin
             GetGreenColorAndAdd (Feature.rArr[i*2+1], gc, ga);
             if (ImageLib <> nil) and (ImageLib.Images[bidx] <> nil) then CharImageBuffer[CharImageBufferIndex].aCharImage.DrawImageGreenConvert (ImageLib.Images[bidx], ImageLib.Images[bidx].px+addx, ImageLib.Images[bidx].py+addy, gc, ga);
          end;
    }
  end;

  boflag := TRUE;
  case block of
    0: if CharTable0[bidx] = 1 then
        boflag := FALSE;
    1: if CharTable1[bidx] = 1 then
        boflag := FALSE;
    2: if CharTable2[bidx] = 1 then
        boflag := FALSE;
    3: if CharTable3[bidx] = 1 then
        boflag := FALSE;
    4: if CharTable4[bidx] = 1 then
        boflag := FALSE;
  end;

  if boflag then
  begin
    for i := 6 to 9 do
    begin
      ImageLib := FAtzClass.GetImageLib(GetImageLibName(Feature, i, block),
        CurTick);
      if ImageLib = nil then
        continue;
      if ImageLib.Count <= bidx then
        continue;
      LibImage := ImageLib.Images[bidx];
      if LibImage <> nil then
      begin
        if Feature.rArr[i * 2 + 1] = 0 then
          CharImage.DrawImage(LibImage, LibImage.px + addx, LibImage.py + addy,
            true)
        else
        begin
          GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
          CharImage.DrawImageGreenConvert(LibImage, LibImage.px + addx,
            LibImage.py + addy, gc, ga);
        end;
      end;
    end;
  end
  else
  begin
    ImageLib := FAtzClass.GetImageLib(GetImageLibName(Feature, 9, block),
      CurTick);
    if (ImageLib <> nil) and (ImageLib.Count > bidx) then
    begin
      LibImage := ImageLib.Images[bidx];
      if LibImage <> nil then
      begin
        if Feature.rArr[9 * 2 + 1] = 0 then
          CharImage.DrawImage(LibImage, LibImage.px + addx, LibImage.py + addy,
            true)
        else
        begin
          GetGreenColorAndAdd(Feature.rArr[9 * 2 + 1], gc, ga);
          CharImage.DrawImageGreenConvert(LibImage, LibImage.px + addx,
            LibImage.py + addy, gc, ga);
        end;
      end;
    end;

    for i := 6 to 8 do
    begin
      ImageLib := FAtzClass.GetImageLib(GetImageLibName(Feature, i, block),
        CurTick);
      if ImageLib = nil then
        continue;
      if ImageLib.Count <= bidx then
        continue;
      LibImage := ImageLib.Images[bidx];
      if LibImage <> nil then
      begin
        if Feature.rArr[i * 2 + 1] = 0 then
          CharImage.DrawImage(LibImage, LibImage.px + addx, LibImage.py + addy,
            true)
        else
        begin
          GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
          CharImage.DrawImageGreenConvert(LibImage, LibImage.px + addx,
            LibImage.py + addy, gc, ga);
        end;
      end;
    end;
  end;

  CharImage.Optimize;
end;

function TCharClass.GetCharImage: TA2Image;
begin
  Result := CharImageBuffer[CharImageBufferIndex].aCharImage;
end;

procedure TCharClass.Paint(CurTick: integer);
begin
  MakeFrame(ImageNumber, CurTick);

  if Feature.rrace <> RACE_MONSTER then
  begin
    case Feature.rHideState of
      hs_100: // 老馆利牢 葛嚼
        begin
          BackScreen.DrawImageKeyColor(CharImageBuffer[CharImageBufferIndex].aCharImage, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf);
          if OverImage <> nil then
            BackScreen.DrawImageOveray(OverImage, RealX, RealY, 20);
{$IFNDEF _CHINA}
          //               if StoreFlag then begin
          //                  BackScreen.DrawStoreSign(StoreSign, RealX, RealY);
          //               end;
{$ENDIF}
        end;
      hs_0: // 肯傈洒 焊捞瘤 救阑版快 弊府瘤 臼澜
        if id = CharCenterID then
          BackScreen.DrawRefractive(CharImageBuffer[CharImageBufferIndex].aCharImage, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf, 4, 3);
      hs_1: // 篮脚吝烙 CharCenterID 老版快 荤侩磊祈狼肺 距埃颇鄂祸捞 啊固等 版快 Refracrange : 4 overValue : 3
        BackScreen.DrawRefractive(CharImageBuffer[CharImageBufferIndex].aCharImage, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf, 4, 3);
      hs_99: // 篮脚吝 荤侩磊啊 篮脚焊绰 付过殿阑 荤侩矫 距埃 焊捞绰版快 Refracrange : 4 overValue : 0
        BackScreen.DrawRefractive(CharImageBuffer[CharImageBufferIndex].aCharImage, RealX - CHarMaxSiezHalf, RealY - CHarMaxSiezHalf, 4, 0);
    end;
  end;
  if StructedTick <> 0 then
    BackScreen.DrawStructed(RealX, RealY, 36, StructedPercent);
  // Char 赣府困狼 俊呈瘤官
end;

function TCharClass.Update(CurTick: integer): Integer;
  procedure NextMessage;
    //   var
    //      RMsg : TRecordMessage;
  begin
    CurActionInfo := nil;
    //      ViewMessage (RMsg);
    //      if RMsg.rMsg <> 0 then begin
    //         GetMessage (RMsg);
    //         with RMsg do
    //            ProcessMessage (rMsg, rdir, rx, ry, rfeature, rmotion);
    //      end else begin
    if CurTick > TurningTick + 200 then
    begin
      TurningTick := CurTick;
      CurActionInfo := FindAnimation(AM_TURNNING, dir);
      SetCurrentFrame(CurActionInfo, 0, CurTick);
      CurAction := SM_TURN;
    end
    else
    begin
      CurActionInfo := FindAnimation(AM_TURN, dir);
      SetCurrentFrame(CurActionInfo, 0, CurTick);
      CurAction := SM_TURN;
    end;
    //      end;
  end;
var
  PassTick: integer;
begin
  Result := 0;

  if (BubbleType = 0) and (BubbleList.Count <> 0) and
    (BubbleTick + 300 < CurTick) then
    BubbleList.Clear;

  if StructedTick + 200 < CurTick then
    StructedTick := 0;

  if bUpdatePos then
    UpdateCharPos;

  if CurActionInfo <> nil then
  begin
    PassTick := CurTick - FrameStartTime; // 青悼捞 场车栏搁
    if PassTick > (CurActionInfo^.Frametime) then
    begin
      Result := 1;
      curframe := curframe + 1;

      case CurActionInfo.Action of
        AM_SHIT_WRESTLE_READY, AM_SHIT_SWORD_READY,
          AM_SHIT_BLADE_READY, AM_SHIT_SPEAR_READY:
          if CurActionInfo^.Frame <= curframe then
            Dec(curframe);
      end;

      if CurActionInfo^.Frame <= curframe then
      begin
        OverImageName := '';
        OverImage := nil;
        NextMessage;
      end
      else
        SetCurrentFrame(CurActionInfo, curframe, CurTick);
    end;
  end
  else
  begin
    NextMessage;
  end;

  SetCurrentPos;

  if CharCenterId = id then
  begin
    CharPosX := x;
    CharPosY := y;
    BackScreen.SetCenter(RealX, RealY);
    Map.SetCenter(x, y);
  end;
end;

function TCharClass.GetX: SmallInt;
var
  tmpData: array[0..15] of BYTE;
  psMove: PTSMove;
  len: DWORD;
  Temp: Word;
begin
  Result := xxxx;

  if (CharCenterID = ID) or (not map.boCryptPos) then
  begin
    Result := xxxx;
  end
  else
  begin
    len := 16;
    MyDecrypt(2, 2, @EncBasePos, @tmpData, 16, len);
    psMove := @tmpData;
    Temp := xxxx - psMove^.rx;
    Result := (Word(Temp shr dir) or Word(Temp shl (16 - dir))) xor Word(id);
  end;

end;

function TCharClass.GetY: SmallInt;
var
  tmpData: array[0..15] of BYTE;
  psMove: PTSMove;
  len: DWORD;
  Temp: Word;
begin
  Result := yyyy;

  if (CharCenterID = ID) or (not map.boCryptPos) then
  begin
    Result := yyyy;
  end
  else
  begin
    len := 16;
    MyDecrypt(2, 2, @EncBasePos, @tmpData, 16, len);
    psMove := @tmpData;
    Temp := yyyy - psMove^.ry;
    Result := (Word(Temp shr dir) or Word(Temp shl (16 - dir))) xor Word(id);
  end;

end;

procedure TCharClass.UpdateCharPos;
begin
  xxxx := NewX;
  yyyy := NewY;
  NewX := -30;
  NewY := -30;
  bUpdatePos := False;
end;

///////////////////////////////////
//        Char List
///////////////////////////////////

constructor TCharList.Create(aAtzClass: TAtzClass);
begin
  FAtzClass := aAtzClass;
  CharDataList := TList.Create;
  ItemDataList := TList.Create;
  DynamicObjDataList := TList.Create;

  MagicDataList := TList.Create;
  EffectDataList := TEffectDataList.Create('.\effect\');
{$IFDEF _DEBUG}
  GuildNameTest.X := 0;
  GuildNameTest.Y := 0;
  GuildNameTest.X1 := 0;
  GuildNameTest.Y1 := 0;
  GuildNameTest.Size := 0;
{$ENDIF}

end;

destructor TCharList.Destroy;
var
  i: integer;
begin
  for i := 0 to MagicDataList.Count - 1 do
    TMovingMagicClass(MagicDataList[i]).Free;
  MagicDataList.Free;

  for i := 0 to ItemDataList.Count - 1 do
    TItemClass(ItemDataList[i]).Free;
  ItemDataList.Free;

  for i := 0 to DynamicObjDataList.Count - 1 do
    TDynamicObject(DynamicObjDataList[i]).Free; // Dynamicitem
  DynamicObjDataList.Free;

  for i := 0 to CharDataList.Count - 1 do
    TCharClass(CharDataList[i]).Free;
  CharDataList.Free;

  EffectDataList.Free;
  inherited destroy;
end;

procedure TCharList.Clear;
var
  i: integer;
begin
  for i := 0 to ItemDataList.Count - 1 do
    TItemClass(ItemDataList[i]).Finalize;
  for i := 0 to CharDataList.Count - 1 do
    TCharClass(CharDataList[i]).Finalize;
  for i := 0 to MagicDataList.Count - 1 do
    TMovingMagicClass(MagicDataList[i]).Free;
  MagicDataList.Clear;
  for i := 0 to DynamicObjDataList.Count - 1 do
    TDynamicObject(DynamicObjDataList[i]).Finalize;
end;

// change by minds 021126 积己等 CharClass甫 return 窍档废 荐沥

function TCharList.AddChar(aName: Widestring; aId, adir, ax, ay: integer;
  afeature: TFeature): TCharClass;
var
  i: integer;
begin
  for i := 0 to CharDataList.Count - 1 do
  begin
    Result := CharDataList[i];
    if Result.Used = FALSE then
    begin
      Result.Initialize(aName, aId, adir, ax, ay, afeature);
      exit;
    end;
  end;
  Result := TCharClass.Create(FAtzClass);
  Result.Initialize(aName, aId, adir, ax, ay, afeature);
  CharDataList.Add(Result);
end;

function TCharList.GetChar(aId: integer): TCharClass;
var
  i: integer;
  CharClass: TCharClass;
begin
  Result := nil;
  for i := 0 to CharDataList.Count - 1 do
  begin
    CharClass := TCharClass(CharDataList[i]);
    if CharClass.Used = FALSE then
      continue;
    if CharClass.id = aId then
    begin
      Result := TCharClass(CharDataList[i]);
      exit;
    end;
  end;
end;

procedure TCharList.DeleteChar(aId: integer);
var
  i: integer;
  CharClass: TCharClass;
begin
  for i := 0 to CharDataList.Count - 1 do
  begin
    CharClass := TCharClass(CharDataList[i]);
    if CharClass.Used = FALSE then
      continue;
    if CharClass.Id = aId then
    begin
      CharClass.Finalize;
      exit;
    end;
  end;
end;

procedure TCharList.AddItem(aItemName: string; aRace: byte; aId, ax, ay,
  aItemShape, aItemColor: integer);
var
  i: integer;
  ItemClass: TItemClass;
begin
  for i := 0 to ItemDataList.Count - 1 do
  begin
    ItemClass := ItemDataList[i];
    if ItemClass.Used = FALSE then
    begin
      ItemClass.Initialize(aItemName, aRace, aId, ax, ay, aitemShape,
        aItemColor);
      exit;
    end;
  end;
  ItemClass := TItemClass.Create(FAtzClass);
  ItemClass.Initialize(aItemName, aRace, aId, ax, ay, aItemShape, aItemColor);
  ItemDataList.Add(ItemClass);
end;

function TCharList.GetItem(aId: integer): TItemClass;
var
  i: integer;
  ItemClass: TItemClass;
begin
  Result := nil;
  for i := 0 to ItemDataList.Count - 1 do
  begin
    ItemClass := TItemClass(ItemDataList[i]);
    if ItemClass.Used = FALSE then
      continue;
    if ItemClass.Id = aId then
    begin
      Result := ItemClass;
      exit;
    end;
  end;
end;

procedure TCharList.DeleteItem(aId: integer);
var
  i: integer;
  ItemClass: TItemClass;
begin
  for i := 0 to ItemDataList.Count - 1 do
  begin
    ItemClass := TItemClass(ItemDataList[i]);
    if ItemClass.Used = FALSE then
      continue;
    if ItemClass.Id = aId then
    begin
      ItemClass.Finalize;
      exit;
    end;
  end;
end;

procedure TCharList.AddDynamicObjItem(aItemName: string; aId, ax, ay,
  aItemShape: integer; aStartFrame, aEndFrame: Word; aState: byte;
  aDynamicGuard:
  TDynamicGuard);
var
  i: integer;
  DynamicObject: TDynamicObject;
begin
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    DynamicObject := DynamicObjDataList[i];
    if DynamicObject.Used = FALSE then
    begin
      DynamicObject.Initialize(aItemName, aId, ax, ay, aItemShape, aStartFrame,
        aEndFrame, aState, aDynamicGuard);
      exit;
    end;
  end;
  DynamicObject := TDynamicObject.Create(FAtzClass);
  DynamicObject.Initialize(aItemName, aId, ax, ay, aItemShape, aStartFrame,
    aEndFrame, aState, aDynamicGuard);
  DynamicObjDataList.Add(DynamicObject);
end;

procedure TCharList.SetDynamicObjItem(aId: integer; aState: byte; aStartFrame,
  aEndFrame: Word);
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
  DynamicObject: TDynamicObject;
begin
  Result := nil;
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    DynamicObject := TDynamicObject(DynamicObjDataList[i]);
    if DynamicObject.Used = FALSE then
      continue;
    if DynamicObject.Id = aId then
    begin
      Result := DynamicObject;
      exit;
    end;
  end;
end;

procedure TCharList.DeleteDynamicObjItem(aId: integer);
var
  i: integer;
  DynamicObject: TDynamicObject;
begin
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    DynamicObject := TDynamicObject(DynamicObjDataList[i]);
    if DynamicObject.Used = FALSE then
      continue;
    if DynamicObject.Id = aId then
    begin
      DynamicObject.Finalize;
      exit;
    end;
  end;
end;

function TCharList.UpDate(CurTick: integer): integer;
var
  i, j: integer;
  MovingMagic: TMovingMagicClass;
  CharClass: TCharClass;
  ItemClass: TItemClass;
  DynamicObject: TDynamicObject;
begin
  Result := 0;

  for i := 0 to 15 do
  begin
    if EncBasePos2[i] <> 0 then
    begin
      UpdateBasePos(@EncBasePos2);
      for j := 0 to 15 do
      begin
        EncBasePos[j] := EncBasePos2[j];
        EncBasePos2[j] := 0;
      end;
    end;
  end;

  for i := MagicDataList.Count - 1 downto 0 do
  begin
    MovingMagic := TMovingMagicClass(MagicDataList[i]);
    if MovingMagic.Used = FALSE then
      continue;
    if MovingMagic.MagicCurAction = MAT_DESTROY then
    begin // Moving Magic篮 捞镑俊辑 磊眉利栏肺 辆丰甫 窍霸等促.
      MovingMagic.Finalize;
      continue;
    end;
    if MovingMagic.Update(CurTick) <> 0 then
      Result := 1;
  end;

  for i := 0 to CharDataList.Count - 1 do
  begin
    CharClass := TCharClass(CharDataList[i]);
    if CharClass.Used = FALSE then
      continue;
    if CharClass.Update(CurTick) <> 0 then
      Result := 1;
  end;

  for i := 0 to ItemDataList.Count - 1 do
  begin
    ItemClass := TItemClass(ItemDataList[i]);
    if ItemClass.Used = FALSE then
      continue;
    if ItemClass.Update(CurTick) <> 0 then
      Result := 1;
  end;

  for i := 0 to DynamicObjDataList.Count - 1 do
  begin // aniitem
    DynamicObject := TDynamicObject(DynamicObjDataList[i]);
    if DynamicObject.Used = FALSE then
      continue;
    if DynamicObject.Update(CurTick) <> 0 then
      Result := 1;
  end;
end;

function TCharList.UpDataBgEffect(CurTick: integer): integer;
var
  i: integer;
  //   BGEffect : TBGEffect;
  CharClass: TCharClass;
  Effect: TEffectClass;
begin
  Result := 0;
  for i := 0 to CharDataList.Count - 1 do
  begin
    CharClass := TCharClass(CharDataList[i]);
    if CharClass.Used and (CharClass.FEffectList <> nil) then
    begin
      CharClass.FEffectList.Update;
    end;
  end;
  {
     BGEffect := TCharClass(CharDataList[i]).BgEffect;
     if (BGEffect <> nil) and (BGEffect.Used = TRUE) then begin
        if BGEffect.Update(CurTick) <> 0 then Result := 1;
     end;
  }
  {
     CharClass := TCharClass(CharDataList[i]);
     Effect := CharClass.FEffect;
     if Effect = nil then continue;
     if Effect.Used = FALSE then continue;
     // add by minds 021122
     // 贱厘过 扁葛栏绰 捞棋飘老锭 action捞 官差搁 捞棋飘啊 辆丰凳
     if (Effect.FEffectKind = lek_hit10) and (CharClass.CurActionInfo <> nil) and
        (CharClass.CurActionInfo.Action <> AM_HIT10_READY) then
        Effect.Finalize
     else
        Effect.Update(CharClass.dir, CurTick);
  end;
  }
  // add by minds 1219  Item狼 BGEffect 焊幅
  {
  for i := 0 to ItemDataList.Count-1 do begin
     if TItemClass(ItemDataList[i]).BGEffect <> nil then
        if TItemClass(ItemDataList[i]).BGEffect.Update(CurTick) <> 0 then Result := 1; // Item BGEffect;
  end;
  }

  // add by minds 020319 DynamicObject俊 BFEffect
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    Effect := TDynamicObject(DynamicObjDataList[i]).FEffect;
    if Effect = nil then
      continue;
    if Effect.Used = FALSE then
      continue;
    Effect.Update(0, CurTick);
  end;
end;

procedure TCharList.GetVarRealPos(var aid, ax, ay: integer);
var
  i: integer;
  CharClass: TCharClass;
begin
  if aid = 0 then
    exit;
  for i := 0 to CharDataList.Count - 1 do
  begin
    CharClass := TCharClass(CharDataList[i]);
    if CharClass.Used = False then
      continue;
    if CharClass.id = aid then
    begin
      ax := CharClass.RealX;
      ay := CharClass.RealY;
      exit;
    end;
  end;
end;

function TCharList.isMovable(xx, yy: integer): Boolean;
var
  i, n: integer;
begin
  Result := FALSE;
  for i := 0 to CharDataList.Count - 1 do
  begin
    if TCharClass(CharDataList[i]).Used = FALSE then
      continue;
    // 2000.12.05 磷菌阑版快 纳腐磐啊 瘤唱哎荐 乐档废 汲沥 by ankudo
    if CharMoveFrontdieFlag then
    begin // 辑滚俊辑 CharMoveFrontdieFlag甫 TRUE肺 汲沥矫 磷绢乐阑版快 瘤唱皑
      if TCharClass(CharDataList[i]).Feature.rfeaturestate <> wfs_die then
        if (TCharClass(CharDataList[i]).X = xx) and
          (TCharClass(CharDataList[i]).Y = yy) then
          exit;
    end
    else
    begin
      if (TCharClass(CharDataList[i]).X = xx) and (TCharClass(CharDataList[i]).Y
        = yy) then
        exit;
    end;
    if TCharClass(CharDataList[i]).ID = CharCenterId then
      BackScreen.CenterchangeIDPos(TCharClass(CharDataList[i]).X - xx,
        TCharClass(CharDataList[i]).Y - yy);
  end;
  // 2000.10.01 巩颇檬籍阑 StaticItem栏肺结 埃林窍咯 某腐磐啊 棵扼啊瘤 给窍档废 荐沥 by Lee.S.G
  for i := 0 to ItemDataList.Count - 1 do
  begin
    if TItemClass(ItemDataList[i]).Used = FALSE then
      continue;
    if TItemClass(ItemDataList[i]).Race = RACE_STATICITEM then
    begin // race肺 备盒 010127 ankudo
      if (TItemClass(ItemDataList[i]).X = xx) and (TItemClass(ItemDataList[i]).Y
        = yy) then
        exit;
    end;
  end;
  // DynamicObject item
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    with TDynamicObject(DynamicObjDataList[i]) do
    begin
      if Used = FALSE then
        continue;
      if isDynamicObjectStaticItemID(Id) then
      begin
        if (X = xx) and (Y = yy) then
          exit;
        for n := 0 to DynamicGuard.aCount - 1 do
        begin
          if (DynamicGuard.aGuardX[n] + X = xx) and (DynamicGuard.aGuardY[n] + Y
            = yy) then
            exit;
        end;
      end;
    end;
  end;
  Result := TRUE;
end;

procedure TCharList.MouseMove(x, y: integer);
var
  i: integer;
  ItemClass: TItemClass;
  DynamicObject: TDynamicObject;
  CharClass: TCharClass;
begin
  SelectedItem := 0;
  for i := 0 to ItemDataList.Count - 1 do
  begin
    ItemClass := TItemClass(ItemDataList[i]);
    if ItemClass.Used = FALSE then
      continue;
    if ItemClass.IsArea(x, y) then
      SelectedItem := ItemClass.id;
  end;

  SelectedDynamicItem := 0; // Dynamicitem
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    DynamicObject := TDynamicObject(DynamicObjDataList[i]);
    if DynamicObject.Used = FALSE then
      continue;
    if DynamicObject.IsArea(x, y) then
      SelectedDynamicItem := DynamicObject.id;
  end;

  SelectedChar := 0;
  for i := 0 to CharDataList.Count - 1 do
  begin
    CharClass := TCharClass(CharDataList[i]);
    if CharClass.Used = FALSE then
      continue;
    if CharClass.IsArea(x, y) then
      SelectedChar := CharClass.id;
  end;
end;

procedure TCharList.Paint(CurTick: integer);
  function GetGap(a1, a2: integer): integer;
  begin
    if a1 > a2 then
      Result := a1 - a2
    else
      Result := a2 - a1;
  end;
var
  i, j, oi, cy {, n, m}: integer;
  ImageNum: integer;
  Cl: TCharClass;
  IC: TItemClass;
  AIC: TDynamicObject;
  po: PTObjectData;
  MapCell: TMapCell;
  //   subMapCell : TMapCell;
  chardieidx: integer;
  tmpA2Image: TA2Image;
  tmpImage: TA2Image;
  GuildName: string;
begin
  for i := 0 to ItemDataList.Count - 1 do
  begin
    IC := TItemClass(ItemDataList[i]);
    if IC.Used = FALSE then
      continue;
    if IC.Race = RACE_STATICITEM then
      continue;
    //      if isStaticItemID(IC.Id) then continue; race肺 魄窜窃
    TItemClass(ItemDataList[i]).Paint;
  end;

  chardieidx := 0; // 磷菌阑版快 刚历 弊覆
  for i := 0 to CharDataList.Count - 1 do
  begin
    if TCharClass(CharDataList[i]).Used = FALSE then
      continue;
    Cl := CharDataList[i];
    if Cl.Feature.rfeaturestate = wfs_die then
    begin
      CharDataList.Exchange(chardieidx, i);
      inc(chardieidx);
    end;
  end;

  for i := 0 to MagicDataList.Count - 1 do
  begin
    if TMovingMagicClass(MagicDataList[i]).Used = FALSE then
      continue;
    TMovingMagicClass(MagicDataList[i]).Paint;
  end;

  for j := Map.Cy - VIEWHEIGHT - 4 to Map.Cy + VIEWHEIGHT - 1 + 14 do
  begin

    for i := Map.Cx - VIEWWIDTH - 8 to Map.Cx + VIEWWIDTH do
    begin

      MapCell := Map.GetCell(i, j);
      oi := MapCell.ObjectId;
      if oi = 0 then
        continue; // change by minds 020103

      po := ObjectDataList[oi];

      if po = nil then
        continue; // change by minds 020103
      // changed by minds 020402
      ImageNum := 0;
      if po.Style = TOB_follow then
        ImageNum := (CurTick div po.AniDelay) mod po.nBlock;

      tmpA2Image := ObjectDataList.GetObjectImage(oi, ImageNum, CurTick);
      {
      //龙

      if oi = 3292 then
      begin
        GuildName := '天堂云';
        if Length(GuildName) = 2 then
        begin
          ATextOutEx(tmpA2Image, 9, 120, 32767, GuildName[1], '黑体', 12,
            [fsBold]);
        end;
        if Length(GuildName) = 4 then
        begin
          ATextOutEx(tmpA2Image, 9, 110, 32767, GuildName[1], '黑体', 12,
            [fsBold]);
          ATextOutEx(tmpA2Image, 9, 130, 32767, GuildName[2], '黑体', 12,
            [fsBold]);
        end;
        if Length(GuildName) = 6 then
        begin
          ATextOutEx(tmpA2Image, 9, 100, 32767, GuildName[1], '黑体', 12,
            [fsBold]);
          ATextOutEx(tmpA2Image, 9, 120, 32767, GuildName[2], '黑体', 12,
            [fsBold]);
          ATextOutEx(tmpA2Image, 9, 140, 32767, GuildName[3], '黑体', 12,
            [fsBold]);
        end;
      end;
      }
      {
            //大象
            if oi = 2603 then
            begin
              ATextOutEx(tmpA2Image, 7, 40, 32767, '我', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 7, 60, 32767, '是', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 7, 80, 32767, '大', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 7, 100, 32767, '象', '黑体', 12, [fsBold]);
            end;
            //河马
            if oi = 2617 then
            begin
              ATextOutEx(tmpA2Image, 5, 82, 32767, '我', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 22, 82, 32767, '河', '黑体', 12, [fsBold]);
            end;
            if oi = 2618 then
            begin
              //ATextOutEx(tmpA2Image, 12, 80, 32767, '河', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, -10, 88, 32767, '河', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 9, 88, 32767, '马', '黑体', 12, [fsBold]);
            end;
            if oi = 2619 then
            begin
              //ATextOutEx(tmpA2Image, -9, 80, 32767, '马', '黑体', 12, [fsBold]);

            end;
            //枪
            if oi = 3313 then
            begin
              ATextOutEx(tmpA2Image, 0, 0, 32767, '我', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 0, 20, 32767, '是', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 0, 40, 32767, '大', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 0, 80, 32767, '象', '黑体', 12, [fsBold]);
            end;

            //窟窿
            if oi = 3325 then
            begin
              ATextOutEx(tmpA2Image, 8, 83, 32767, '窟', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 103, 32767, '窿', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 123, 32767, '呀', '黑体', 12, [fsBold]);
              //ATextOutEx(tmpA2Image, 0, 80, 32767, '象', '黑体', 12, [fsBold]);
            end;

            if oi = 2595 then
            begin
              ATextOutEx(tmpA2Image, 8, 133, 32767, '这', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 153, 32767, '是', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 173, 32767, '狗', '黑体', 12, [fsBold]);
              //ATextOutEx(tmpA2Image, 0, 80, 32767, '象', '黑体', 12, [fsBold]);
            end;
            //狗
            if oi = 3278 then
            begin
              ATextOutEx(tmpA2Image, 8, 153, 32767, '这', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 173, 32767, '是', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 193, 32767, '狗', '黑体', 12, [fsBold]);
            end;
            //狮子
            if oi = 3252 then
            begin
              ATextOutEx(tmpA2Image, 8, 153, 32767, '狮', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 173, 32767, '子', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 193, 32767, '王', '黑体', 12, [fsBold]);
            end;
            //靠背背
            if oi = 2587 then
            begin
              ATextOutEx(tmpA2Image, 8, 123, 32767, '背', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 143, 32767, '靠', '黑体', 12, [fsBold]);
              ATextOutEx(tmpA2Image, 8, 163, 32767, '背', '黑体', 12, [fsBold]);
            end;
      }
      BackScreen.DrawImageKeyColor(tmpA2Image, i * UNITX, j * UNITY);
    end;

    for i := 0 to DynamicObjDataList.Count - 1 do
    begin // DynamicObjPaint
      AIC := TDynamicObject(DynamicObjDataList[i]);
      if AIC.Used = FALSE then
        Continue;
      if isDynamicObjectStaticItemID(AIC.Id) = FALSE then
        continue;
      if AIC.y <> j then
        Continue;
      AIC.Paint;
    end;

    for i := 0 to CharDataList.Count - 1 do
    begin // 纳腐磐 paint
      if TCharClass(CharDataList[i]).Used = FALSE then
        continue;
      Cl := CharDataList[i];
      cy := (CL.RealY + UNITY - 1) div UNITY;

      if j = cy then
      begin
        if Cl.Feature.rEffectNumber > 0 then
          Cl.AddEffect(Cl.Feature.rEffectNumber - 1, Cl.Feature.rEffectKind,
            CurTick);

        if (Cl.id = CharCenterID) or (Cl.Feature.rHideState <> hs_0) then
          Cl.FEffectList.Paint(Cl.Dir, Cl.RealX, Cl.Realy, [ED_BACK]);

        Cl.Paint(CurTick);

        if (Cl.id = CharCenterID) or (Cl.Feature.rHideState <> hs_0) then
          Cl.FEffectList.Paint(Cl.Dir, Cl.RealX, Cl.Realy, [ED_FRONT,
            ED_FRONTSUB, ED_SHADOW]);
      end;

    end;

    for i := 0 to ItemDataList.Count - 1 do
    begin
      IC := TItemClass(ItemDataList[i]);
      if IC.Used = FALSE then
        continue;
      if IC.Race <> RACE_STATICITEM then
        continue;
      if IC.y <> j then
        continue;
      IC.Paint;

      {         // add by minds 1219 Item俊 Effect持扁..
               if IC.BGEffect <> nil then begin
                  m := IC.BGEffect.EffectPositionData.rArr[2];
                  IC.BGEffect.Paint(IC.RealX+m, IC.RealY+m);
               end;
      }
    end;

  end;

  for j := Map.Cy - VIEWHEIGHT - 4 to Map.Cy + VIEWHEIGHT - 1 + 14 do
  begin
    for i := Map.Cx - VIEWWIDTH - 8 to Map.Cx + VIEWWIDTH do
    begin
      DrawGuildName(i, j);
    end;
  end;

end;

procedure TCharList.PaintText(aCanvas: TCanvas);
var
  i: integer;
  Cl: TCharClass;
  DObj: TDynamicObject;
  Item: TItemClass;
  Col: integer;
begin
  for i := 0 to DynamicObjDataList.Count - 1 do
  begin
    DObj := TDynamicObject(DynamicObjDataList[i]);
    if DObj = nil then
      continue;
    if DObj.DynamicObjName = '' then
      continue;
    if DObj.Used = FALSE then
      continue;
    if DObj.id = SelectedDynamicItem then
    begin
      Col := WinRGB(31, 31, 31);
      BackScreen.DrawName(aCanvas, DObj.RealX, DObj.RealY, DObj.DynamicObjName,
        Col);
    end;
  end;

  for i := 0 to ItemDataList.Count - 1 do
  begin
    Item := TItemClass(ItemDataList[i]);
    if Item.Used = FALSE then
      continue;
    if Item.id = SelectedItem then
    begin
      Col := WinRGB(31, 31, 31);
      BackScreen.DrawName(aCanvas, Item.RealX, Item.RealY, Item.ItemName, Col);
    end;
  end;

  for i := 0 to CharDataList.Count - 1 do
  begin
    Cl := CharDataList[i];
    if Cl.Used = FALSE then
      continue;
    if Cl.Feature.rHideState = hs_100 then
    begin
      if (Cl.id = SelectedChar) then
      begin
        if Cl.Feature.rTeamColor >= 100 then
          Col := TeamColorTable[Cl.Feature.rTeamColor - 103]
        else
          Col := WinRGB(31, 31, 31);

        BackScreen.DrawName(aCanvas, Cl.RealX, Cl.RealY, Cl.Name, Col);
      end;
    end;
    if Cl.BubbleList.Count <> 0 then
    begin
      BackScreen.DrawBubble(aCanvas, Cl.RealX, Cl.RealY, Cl.BubbleList,
        Cl.BubbleColor);
    end;

{$IFDEF _DEBUG}
    if bShowCharList then
    begin
      ATextOut(BackScreen.Back, 6, i * 16 + 46, 0,
        Format('name=%s,x=%d,y=%d', [Cl.Name, Cl.X, Cl.Y]));
      ATextOut(BackScreen.Back, 5, i * 16 + 45, 32767,
        Format('name=%s,x=%d,y=%d', [Cl.Name, Cl.X, Cl.Y]));
    end;
{$ENDIF}
  end;
end;

// change by minds 1219

function TCharList.AddMagic(sid, eid, adeg, aspeed, ax, ay, atx, aty,
  aMagicShape, CurTick: integer; aType: byte): TMovingMagicClass;
begin
  Result := TMovingMagicClass.Create(FAtzClass);
  Result.Initialize(sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape,
    CurTick, aType);
  MagicDataList.Add(Result);
end;
{
procedure TCharList.AddMagic (sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, CurTick: integer; aType: byte);
var MagicClass : TMovingMagicClass;
begin
   MagicClass := TMovingMagicClass.Create (FAtzClass);
   MagicClass.Initialize (sid, eid, adeg, aspeed, ax, ay, atx, aty, aMagicShape, CurTick, aType);
   MagicDataList.Add (MagicClass);
end;
}

function TCharList.isDynamicObjectStaticItemID(aid: LongInt): Boolean;
var
  id: Longint;
begin
  Result := FALSE;
  id := aid - 10000;
  if (id mod 10) = 5 then
    Result := TRUE;
end;

//

procedure TCharList.UpdateBasePos(NewBaseData: PBYTE);
var
  i: integer;
  tmpData: array[0..15] of BYTE;
  psMove: PTSMove;
  len: DWORD;
  cl: TCharClass;
  Temp: Word;
begin
// change by minds 050221
{
  if not map.boCryptPos then
    exit;

  len := 16;
  MyDecrypt(2, 2, NewBaseData, @tmpData, 16, len);
  psMove := @tmpData;

  for i := 0 to CharDataList.Count - 1 do
  begin
    cl := CharDataList[i];
    if cl.id = CharCenterID then
      continue; // 磊扁磊脚老版快 逞辫
    if cl.bUpdatePos then
      continue;

    Temp := Word(cl.X) xor Word(cl.id);
    cl.NewX := Word(Temp shl cl.dir) or Word(Temp shr (16 - cl.dir)) +
      psMove.rx;
    Temp := Word(cl.Y) xor Word(cl.id);
    cl.NewY := Word(Temp shl cl.dir) or Word(Temp shr (16 - cl.dir)) +
      psMove.ry;

    cl.bUpdatePos := True;
  end;
  bUpdateBasePos := False;
}
  bUpdateBasePos := False;
end;

constructor TEffectList.Create(Owner: TCharClass);
begin
  inherited Create;

  FOwnChar := Owner;
  FDataList := TList.Create;
end;

destructor TEffectList.Destroy;
var
  i: integer;
  Effect: TEffectClass;
begin
  for i := 0 to FDataList.Count - 1 do
  begin
    Effect := FDataList[i];
    Effect.Free;
  end;
  FDataList.Free;
  FOwnChar := nil;

  inherited;
end;

procedure TEffectList.AddEffect(adir, ax, ay: integer; aEffectShape: integer;
  aEffectKind: TLightEffectKind; aDelayTick: integer);
var
  i: integer;
  Effect: TEffectClass;
begin
  case aEffectKind of
    lek_off:
      begin
        for i := 0 to FDataList.Count - 1 do
        begin
          Effect := FDataList[i];
          if Effect.FEffectShape = aEffectShape then
          begin
            Effect.Free;
            FDataList.Delete(i);
            exit;
          end;
        end;
        exit;
      end;
    lek_continue:
      begin
        for i := 0 to FDataList.Count - 1 do
        begin
          Effect := FDataList[i];
          if Effect.FEffectShape = aEffectShape then
            exit;
        end;
      end;
  end;
  Effect := TEffectClass.Create;
  Effect.Initialize(aDir, ax, ay, aEffectShape, aEffectKind, mmAnsTick, mmAnsTick
    + aDelayTick);
  FDataList.Add(Effect);
end;

procedure TEffectList.Update;
var
  i: integer;
  Effect: TEffectClass;
begin
  i := 0;
  while i < FDataList.Count do
  begin
    Effect := FDataList[i];
    if (Effect.FEffectKind = lek_hit10) and (FOwnChar.CurActionInfo <> nil) then
    begin
      case FOwnChar.CurActionInfo.Action of
        AM_HIT10_READY, AM_SHIT_WRESTLE_READY, AM_SHIT_SWORD_READY,
          AM_SHIT_BLADE_READY, AM_SHIT_SPEAR_READY: ;
      else
        begin
          Effect.Free;
          FDataList.Delete(i);
          continue;
        end;
      end;
    end;
    Effect.Update(FOwnChar.dir, mmAnsTick);
    if Effect.Used then
    begin
      inc(i);
    end
    else
    begin
      Effect.Free;
      FDataList.Delete(i);
    end;
  end;
end;

procedure TEffectList.Paint(aDir, aRealx, aRealy: integer; aDrawSet:
  TEffectDraw);
var
  i: integer;
  Effect: TEffectClass;
begin
  for i := 0 to FDataList.Count - 1 do
  begin
    Effect := FDataList[i];
    Effect.Paint(aDir, aRealX, aRealY, aDrawSet);
  end;
end;

procedure TCharList.DrawGuildName(X, Y: Integer);
var
  GuildName: String;
  i: Integer;
begin


{
  GuildName := '天使岛';
  for i := 0 to 9 do
    StrPCopy(@GuildListInfo.rGuildName[i], GuildName);
}

  if LowerCase(Map.GetMapName) <> 'south.map' then
    Exit;

  if (X = 663) and (Y = 245) then //大象
    DrawGuildNameFont(X, Y, 8, 20, StrPas(@GuildListInfo.rGuildName[1]), 14, 1, 1, 3);
  if (X = 698) and (Y = 519) then //河马
    DrawGuildNameFont(X, Y, 1, 3, StrPas(@GuildListInfo.rGuildName[4]), 14, 0, 1, 3);
  if (X = 653) and (Y = 756) then //手枪
    DrawGuildNameFont(X, Y, 8, 12, StrPas(@GuildListInfo.rGuildName[2]), 14, 1, 1, 3);
  if (X = 529) and (Y = 678) then //龙
    DrawGuildNameFont(X, Y, 10, 0, StrPas(@GuildListInfo.rGuildName[0]), 16, 1, 3, 3);
  if (X = 821) and (Y = 623) then //窟窿
    DrawGuildNameFont(X, Y, 4, 14, StrPas(@GuildListInfo.rGuildName[3]), 18, 1, 1, 3);


  if (X = 255) and (Y = 221) then //狗
    DrawGuildNameFont(X, Y, 8, 17, StrPas(@GuildListInfo.rGuildName[5]), 10, 1, 1, 3);
  if (X = 654) and (Y = 702) then //猴子
    DrawGuildNameFont(X, Y, 10, 6, StrPas(@GuildListInfo.rGuildName[6]), 11, 1, 1, 3);
  if (X = 383) and (Y = 619) then //蟾蜍
    DrawGuildNameFont(X, Y, 6, 20, StrPas(@GuildListInfo.rGuildName[7]), 16, 1, 1, 3);

  if (X = 389) and (Y = 387) then //狮子
    DrawGuildNameFont(X, Y, 6, -2, StrPas(@GuildListInfo.rGuildName[8]), 16, 1, 1, 3);
  if (X = 570) and (Y = 311) then //背靠背
    DrawGuildNameFont(X, Y, 8, 6, StrPas(@GuildListInfo.rGuildName[9]), 14, 1, 1, 3);


{$IFDEF _DEBUG}
  if (X = GuildNameTest.X) and (Y = GuildNameTest.Y) then
  with GuildNameTest do
  begin
    DrawGuildNameFont(X, Y, X1, Y1, '第一剑', Size, Style, 1, 3);
  end;
{$ENDIF}
end;

procedure TCharList.DrawGuildNameFont(X, Y, X1, Y1: Integer; AGuildName: string;
  ASize: Integer; AStyle: Integer; ASpace: Integer; aParam: Integer);
var
  tmpA2Image: TA2Image;
  i: Integer;
begin
  if AGuildName = '' then
    Exit;
  i := GetStringLength(AGuildName);
  tmpA2Image := TA2Image.Create(300, 300, 0, 0);
  ATextOutEx(tmpA2Image, X1, Y1, WINRGB(0 shr 3, 255 shr 3, 255 shr 3), AGuildName, '楷体_GB2312', ASize, [fsBold],
    AStyle, ASpace, aParam);
  BackScreen.DrawImage(tmpA2Image, X * UNITX, Y * UNITY, True);
  tmpA2Image.Free;
end;

{$IFDEF _DEBUG}
procedure TCharList.__DrawGuildNameFontTest(X, Y, X1, Y1, ASize, AStyle: Integer);
begin
  GuildNameTest.X := X;
  GuildNameTest.Y := Y;
  GuildNameTest.X1 := X1;
  GuildNameTest.Y1 := Y1;
  GuildNameTest.Size := ASize;
  GuildNameTest.Style := AStyle;
end;
{$ENDIF}

end.




{
系统首页

公共资源(4个工作日)
  公共信息
    内部通知
    规章制度
    员工列表
  资源共享
    行业资源
    部门资源
    标准文档
    常用软件

传递文件(2个工作日)
  个人信箱
    收件箱
    发件箱
  管理选项
    查阅员工文件

工作日志(3个工作日)
  个人选项
    填写个人日志
    回顾个人日志
  部门选项
    填写部门日志
    回顾部门日志
  管理选项
    查阅个人日志
    查阅部门日志

项目进度(7个工作日)
  个人选项
    个人当日计划
    个人本周计划
    个人本月计划
  部门选项
    部门当日计划
    部门本周计划
    部门本月计划
  管理选项
    查阅个人计划
    查阅部门计划

企业资产(5个工作日)
  个人选项
    个人领用申请
  部门选项
    部门领用申请
  管理选项
    资产项目设置
    资产领用审批

人力资源(3个工作日)
  设置部门
  设置职务
  分配职务
  员工信息


薪资管理（4个工作日）
  薪资设置
  薪资统计


系统管理＋系统整合调试（7个工作日）
  界面设置
  功能设置
  设置超级用户

安装部署（2个工作日＋3个工作日）







}












