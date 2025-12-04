unit svClass;

interface

uses
  Windows, SysUtils, Classes, Usersdb, Deftype, //AnsUnit,
  AUtil32, uSendcls, uAnstick, uLevelexp, IniFiles, SubUtil,
  uKeyClass, uGramerID, PaxScripter, PaxPascal, DateUtils, uMagicClass, Lua, LuaLib, Dialogs, LuaRegisterClass;

const
  AREA_NONE = 0;
  AREA_CANMAKEGUILD = 1;


  maxjj = 13; //最高境界限定

type
  Tnewitemtype = (_nist_all, _nist_Not_property);
  TRandomData = record
    rItemName: string;
    rObjName: string;
    rIndex: Integer;
    rCurIndex: Integer;
    rCount: Integer;
  end;
  PTRandomData = ^TRandomData;

  TRandomDataClass = class
        //成员是 TRandomData
  private
    DataList: TList;
    FObjName: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure add(aitem: TRandomData);
    procedure clear;
    function get(aname: string): PTRandomData;
    function GetCount: integer;
    function GetByIndex(aIndex: Integer): PTRandomData;
  end;

  TRandomClass = class
        //成员是 TRandomDataClass
  private
    DataList: TList;
    AnsIndexClass: TStringKeyClass;
    function get(aObjname: string): TRandomDataClass;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure del(aObjname: string);
    procedure AddData(aItemName, aObjName: string; aCount: Integer);
    function GetChance(aItemName, aObjName: string; aName: string = ''): Boolean;
    function SetChance(aItemName, aObjName: string; CurIndex, Index, Count: Integer): Boolean;
    function GetDataByObjName(aObjName: string): TRandomDataClass;
    function GetCount: integer;
    function GetDataByIndex(aIndex: Integer): TRandomDataClass;
  end;

    // 2000.10.05 眠啊规绢仿 备炼眉 by Lee.S.G

  TMagicClass = class(TMagicBasicClass)
  private
    MagicForGuildDb: TUserStringDb;
    AnsIndexClass: TStringKeyClass;
    MagicDb: TUserStringDb;
    DataList: TList;

  protected
    procedure Clear;
    function LoadMagicData(aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;
  public
    Damagestr: string;
    Armorstr: string;
    constructor Create;
    destructor Destroy; override;
    procedure CompactGuildMagic;
    procedure DelGuildMagic(astr: string);
    function GetMagicData(aMagicName: string; var MagicData: TMagicData; aexp: integer): Boolean;
    function GetHaveMagicData(astr: string; var MagicData: TMagicData): Boolean;
    function GetHaveMagicString(var MagicData: TMagicData): string;

    function CheckMagicData(var MagicData: TMagicData; var aRetStr: string; aCheckName: Boolean = True): Boolean;

    function GetMagicDataString(MagicData: TMagicData): string;
    function AddGuildMagic(var aMagicData: TMagicData; aGuildName: string): Boolean;

    procedure ReLoadFromFile;
  published

  end;

  TMagicParamClass = class
  private
    DataList: TList;
    KeyClass: TStringKeyClass;

    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    function LoadFromFile(aFileName: string): Boolean;
    function GetMagicParamData(aObjectName, aMagicName: string; var aMagicParamData: TMagicParamData): Boolean;
    function Add(oName, mName: string; apara: TMagicParamData; aid: integer): Boolean;
  end;

  TItemUPLevelClass = class
  private
    DataList: TList;
    AnsIndexClass: TIntegerKeyClass;
    procedure add(var aitem: TItemDataUPdataLevel);
    procedure clear;

  public
    constructor Create;
    destructor Destroy; override;
    procedure ReLoadFromFile;
    function get(alevel: integer): pItemDataUPdataLevel;
  end;





  TMineClass = class
  private
    DataList: TList;
    NameIndexClass: TStringKeyClass;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TMineData);
    function get(aName: string): pTMineData;
    procedure loadfile;
  end;

      //MineObjectShape.sdb

  TMineShapeClass = class
  private
    DataList: TList;
    ShapeIndexClass: TIntegerKeyClass;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TMineShapeData);
    function get(ashape: integer): pTMineShapeData;
    procedure loadfile;
  end;



    //Name,GroupName,MapID,PositionCount,SettingCount,Mine1,Mine2,Mine3,Mine4,Mine5,Desc
  TMineAvailClass = class
  private
    DataList: TList;
    GroupNameIndexClass: TStringKeyClass;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TMineAvailData);
    function get(aGroupName: string): pTMineAvailData;
    procedure loadfile;
  end;

  TWeaponLevelColorClass = class
  private
    DataList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TWeaponLevelColorData);
    function get(aname: string): pTWeaponLevelColorData;

    procedure loadfile;
  end;

  TDynamicCreateClass = class
  private
    DataList: TList;

  public
    constructor Create(afilename: string);
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TCreateDynamicObjectData);
    function get(aindex: integer): PTCreateDynamicObjectData;
    function getCount: integer;
    procedure loadfile(afilename: string);
  end;

  TMonsterCreateClass = class
  private
    DataList: TList;

  public
    constructor Create(afilename: string);
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TCreateMonsterData);
    function get(aindex: integer): PTCreateMonsterData;
    function getCount: integer;
    procedure loadfile(afilename: string);
  end;
  TNpcCreateClass = class
  private
    DataList: TList;

  public
    constructor Create(afilename: string);
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TCreateNpcData);
    function get(aindex: integer): PTCreateNpcData;
    function getCount: integer;
    procedure loadfile(afilename: string);
  end;
    //地图相关 资源 通用列表 管理类
  TMapOtherListClass = class
  private
    DataList: TList;
    FMapIdIndex: TIntegerKeyClass;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    function get(aMapId: integer): pointer;
  end;

  TNpcCreateListClass = class(TMapOtherListClass)
  public
    procedure add(aMapId: integer);
    procedure add2(aNewId, aMapId: integer);
  end;
  TMonsterCreateListClass = class(TMapOtherListClass)
  public
    procedure add(aMapId: integer);
    procedure add2(aNewId, aMapId: integer);
  end;
  TDynamicCreateListClass = class(TMapOtherListClass)
  public
    procedure add(aMapId: integer);
    procedure add2(aNewId, aMapId: integer);
  end;

  TMaterialClass = class
  private
    DataList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TMaterialData);
    function get(aname: string): pTMaterialData;
    procedure loadfile;
  end;

  //天赋等级升级经验配置
  TTalentLevelClass = class
  private
    DataList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TTalentLevelData);

    function getLevle(aLevel: integer): PTTalentLevelData;

    procedure loadfile;
  end;

  TJobGradeClass = class
  private
    DataList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TJobGradeData);
    function get(aname: string): pTJobGradeData;
    function getLevle(aLevel: integer): pTJobGradeData;

    procedure loadfile;
  end;

  //强化属性配置文件
  TJobUpgradeClass = class
  private
    DataList: TList;
    AnsIndexClass: TIntegerKeyClass;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TJobUpgradelData);

    function getdate(Upgrade: integer): PTJobUpgradelData;

    procedure loadfile;
  end;

    //Name,Mine,Tool,SFreq1,EFreq1,
  TToolRateClass = class
  private
    DataList: TList;
    fname: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TToolRateData);
    function get(atool: string): pTToolRateData;

  end;

  TToolRateListClass = class
  private
    DataList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(aMine: string);
    function get(aMine: string): TToolRateClass;
    procedure loadfile;
  end;

  TItemLifeDataClass = class
  private
    DataList: TList;
    NameIndexClass: TStringKeyClass;


        //(等级，部位，品级)
    FItemUPdateLevelArr: array[0..20, 0..20, 0..20] of TLifeData;
        //星级差值
    ItemStarLevelArr: array[0..10] of TLifeData;


  public
     //三魂 基本数据
    LifeData3f_sky, //天
      LifeData3f_terra, //地
      LifeData3f_fetch, //魂
      lifedatajob0,
      lifedatajob1,
      lifedatajob2,
      lifedatajob3,
      lifedatajob4,
      lifedatajob5,
      lifedatajob6: TLifeData; //武者职业


        //满级 武功 累加
    LifeDataMagicAttack,
      LifeDataMagicProtect,
      LifeDataMagicEct,
      LifeDataMagicWalking,
      LifeDataMagicBREATHNG
      : TLifeData;


    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(var adata: TItemLifeData);
    function get(aName: string): pTItemLifeData;

    function getItemUPdateLevel(aGrade, apos, alevel: integer; out aLifeData: TLifeData): boolean;
    function getItemStarLevel(alevel: integer; out aLifeData: TLifeData): boolean;

    function GetItemData(aName: string; out aItemLifeData: TItemLifeData): boolean;
    procedure loadfile;


  end;

  TItemClass = class
  private
    ItemDb: TUserStringDb;
    DataList: TList;
    AnsIndexClass: TStringKeyClass;
    ItemTextClass: TStringKeyListClass; //pTitemTextdata  物品描述





    procedure Clear;
    function LoadItemData(aItemName: string; var ItemData: TItemData): Boolean;
    procedure LoadScript(aScript, afilename: string);
    procedure LoadLuaScript(aScript, afilename: string);
    procedure JOb_add(var aitem: titemdata);

  public

        //4个职业 生产材料详细表
    Job_Material1: tstringList;
    Job_Material2: tstringList;
    Job_Material3: tstringList;
    Job_Material4: tstringList;
    constructor Create;
    destructor Destroy; override;
    function CallScriptFunction(const aScript, Name: string; const Params: array of const): integer;
    function CallLuaScriptFunction(const aScript, Name: string; const Params: array of const): string;

    procedure ReLoadFromFile;
    function GetItemData(aItemName: string; var ItemData: TItemData): Boolean;
    function GetCheckItemData(aObjName: string; aCheckItem: TCheckItem; var ItemData: TItemData; aName: string = ''): Boolean;
    function GetWearItemData(astr: string; var ItemData: TItemData): Boolean;
    function GetChanceItemData(aStr, aObjName: string; var ItemData: TItemData): Boolean;
    function GetWearItemString(var ItemData: TItemData): string;
    function getdesc(aname: string): string;

  end;


  TAttachClass = class
  private
    FDataArr: array of pTLifeData;
  public
    constructor Create(amaxindex: integer);
    destructor Destroy; override;

    procedure clear;
    function get(aindex: integer): TLifeData;

    procedure ReLoadFromFile(aItemClass: TItemLifeDataClass);
  end;
    // 惑怕 函拳甫 爱绰 酒捞袍甸俊 措茄 努贰胶 空釜狼 巩, 惑磊 etc
  TDynamicObjectClass = class
  private
        // DynamicItemDb : TUserStringDb;
    DataList: TList;
    AnsIndexClass: TStringKeyClass;

    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(aName: string);
    procedure RELoadFromFile;
    function GetDynamicObjectData(aObjectName: string; var aObjectData: TDynamicObjectData): Boolean;
  end;

  TItemDrugClass = class
  private
    ItemDrugDb: TUserStringDb;
    DataList: TList;
    AnsIndexClass: TStringKeyClass;
    procedure Clear;
    function LoadItemDrugData(aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReLoadFromFile;
    function GetItemDrugData(aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
  end;

  TMapPathData = record
    x, y: integer; //坐标
    time: integer; //逗留时间
  end;
  pTMapPathData = ^TMapPathData;
  TMapPath = class
  private
    fID: integer;
    fdata: tlist;
  protected

  public
    constructor Create;
    destructor Destroy; override;
    procedure clear();
    procedure add(ax, ay, atime: integer);
    procedure del(aindex: integer);
    function get(aindex: integer; var ax, ay, atime: integer): boolean;
    function count: integer;
  end;
  TMapPathList = class
  private
    fdata: tlist;

  public
    constructor Create;
    destructor Destroy; override;

    procedure clear();
    procedure add(aid: integer);
    procedure del(aid: integer);
    function get(aid: integer): TMapPath;

    procedure ReLoadFromFile;
  end;


  TScripterDATA = record
    rname: string[64];
    rnamefile: string[255];
    PaxScripter: tPaxScripter;
  end;
  PTScripterDATA = ^TScripterDATA;

  TScripter = class
    PaxPascal: tPaxPascal;
    DataList: TList;
    AnsIndexClass: TStringKeyClass;
  private
    procedure add(aitem: TScripterDATA);

    function get(aname: string): pTScripterDATA;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFile(Jname, JFileName: string); //载入脚本
    function IsScripter(JName: string): boolean; //判断脚本
    function GetScripter(JName: string; var PaxScripter: tPaxScripter): Boolean; //获取脚本
        {        procedure OnMain(JName:string; uSource, uDest:integer); //
                procedure OnDestroy(JName:string; uSource, uDest:integer); //
                procedure CALLFUN(JName:string; uSource, uDest:integer; callname:string); //uname npcNAME  通用 无参数 过程
                }
    procedure ReLoadFromFile();
  end;
  TLuaScripterDATA = record
    rname: string[64];
    rnamefile: string[255];
    LuaScripter: TLua;
  end;
  PTLuaScripterDATA = ^TLuaScripterDATA;
  TLuaScripter = class
  private
    DataList: TList;
    AnsIndexClass: TStringKeyClass;
    procedure add(aitem: TLuaScripterDATA);

    function get(aname: string): PTLuaScripterDATA;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFile(Jname, JFileName: string; ALua: TLua);
    function IsScripter(JName: string): boolean; //判断脚本
    function GetScripter(JName: string; var LuaScripter: TLua): Boolean; //获取脚本
    function GetScripnum: Integer;
    procedure ReLoadFromFile();
  end;
  TCheckItemclass = class
  private
    fdata: tlist;
    fname: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure add(aitem: TCheckItem);
    procedure del(aname: string);
    procedure clear;
    function get(aname: string): pTCheckItem;
    function getIndex(aindex: integer): pTCheckItem;
    function Count: integer;

  end;

  TCheckItemClassList = class
  private
    fdata: tlist;
  public
    constructor Create;
    destructor Destroy; override;
    procedure add(aname: string);
    procedure del(aname: string);
    procedure clear;
    function get(aname: string): TCheckItemclass;
    procedure addItem(aMonsterName, aitemname: string; acount, aRandomCount: integer);
  //  procedure loadfile(aname, afile: string);
    procedure loadfilex(amonstername: string);
    procedure loadfileMap(afilename: string);
    procedure savefile;

  end;

  TMonsterClass = class
  private
    MonsterDb: TUserStringDb;
    DataList: TList;
    AnsIndexClass: TStringKeyClass;

    procedure Clear;
    function LoadMonsterData(aMonsterName: string; var MonsterData: TMonsterData): Boolean;
    function GetCount: integer;
  public
    CheckItemClassList: TCheckItemClassList;
    constructor Create;
    destructor Destroy; override;
    procedure ReLoadFromFile;
    procedure ReLoadHaveItem;
    function GetMonsterData(aMonsterName: string; var pMonsterData: PTMonsterData): Boolean;
    procedure SaveDropItem();

    property Count: integer read GetCount;
    function GetMonsterByIndex(aindex: integer): PTMonsterData;
  end;

  TNpcClass = class
  private
    NpcDb: TUserStringDb;
    DataList: TList;
    AnsIndexClass: TStringKeyClass;

    procedure Clear;
    function LoadNpcData(aNpcName: string; var NpcData: TNpcData): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReLoadFromFile;

    function GetNpcData(aNpcName: string; var pNpcData: PTNpcData): Boolean;
  end;

  TSysopClass = class
  private
    SysopDb: TUserStringDb;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ReLoadFromFile;
    function GetSysopScope(aName: string): integer;
  end;

  TPosByDieClass = class
  private
    DataList: TList;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ReLoadFromFile;
    procedure GetPosByDieData(aServerID: Integer; var aDestServerID: Integer; var aDestX, aDestY: Word);
    procedure GetNewMapAdd(aServerID: Integer; aDestServerID: Integer; aDestX, aDestY: Word);
  end;

  TQuestClass = class
  private
    function CheckQuest1(aServerID: Integer; var aRetStr: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function GetQuestString(aQuest: Integer): string;
    function CheckQuestComplete(aQuest, aServerID: Integer; var aRetStr: string): Boolean;
  end;

  TAreaClass = class
  private
    DataList: TList;
    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFromFile(aFileName: string);

    function CanMakeGuild(aIndex: Byte): Boolean;
    function GetAreaName(aIndex: Byte): string;
    function GetAreaDesc(aIndex: Byte): string;

    property Count: integer read GetCount;
  end;

  TPrisonData = record
    rUserName: string;
    rPrisonTime: Integer;
    rElaspedTime: Integer;
    rPrisonType: string;
    rReason: string;
  end;
  PTPrisonData = ^TPrisonData;

  TPrisonClass = class
  private
    DataList: TList;
    SaveTick: Integer;

    function GetPrisonTime(aType: string): Integer;
    function GetPrisonData(aName: string): PTPrisonData;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    function LoadFromFile(aFileName: string): Boolean;
    function SaveToFile(aFileName: string): Boolean;

    function AddUser(aName, aType, aReason: string): string;
    function DelUser(aName: string): string;
    function UpdateUser(aName, aType, aReason: string): string;
    function PlusUser(aName, aType, aReason: string): string;
    function EditUser(aName, aTime, aReason: string): string;

    function GetUserStatus(aName: string): string;
    function IncreaseElaspedTime(aName: string; aTime: Integer): Integer;

    procedure Update(CurTick: Integer);
  end;

  TNpcFunction = class
  private
    DataList: TList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure LoadFromFile(aFileName: string);

    function GetFunction(aIndex: Integer): PTNpcFunctionData;
  end;
  TsaveID = class
  private
    FDCurTick: integer;
    Ffilename: string;
    DBStream: TFileStream;
    Fid: integer;
    procedure savefile;
    procedure loadfile;
  public
    constructor Create(afilename: string);
    destructor Destroy; override;
    function GetNewID: integer;
    procedure Update(CurTick: integer);
    procedure ItemNewId(var aitem: TItemData);
  published

  end;
  TPowerLeveldata = record
    ViewName: string[64];
    PowerValue, LimitEnergy: integer;
    damageBodyPercent: integer; //身体攻击百分比例
    armorBodyPercent: integer; //身体防御百分比
    Life: integer; //增加 活力
    LifeData: TLifeData;
    ShieldLife: integer; //盾活力
    ShieldArmor: integer; //盾防御
    saycolor: integer; //呐喊颜色
  end;
  pTPowerLeveldata = ^TPowerLeveldata;

  TPowerLevelSub = class
    LifeDataarr: array[1..maxjj] of TPowerLeveldata; //境界的参数
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear();
    procedure LoadFromSdb();
    function get(anum: integer): pTPowerLeveldata;
    function getname(anum: integer): string;
    function getMax(aPower: integer): integer;
  end;

procedure LoadGameIni(aName: string);

function GetServerIdPointer(aServerId, atype: integer): Pointer;

procedure LoadCreateMonster(aFileName: string; List: TList);
procedure LoadCreateNpc(aFileName: string; List: TList);
procedure LoadCreateDynamicObject(aFileName: string; List: TList);
procedure LoadDynamicObject(aObjectName, aNeedSkill, aNeedItem, aGiveItem, aDropItem, aDropMop, aCallNpc, axs, ays: string; pd: PTCreateDynamicObjectData);
//procedure SetWebLuaScript;
function CallWebLuaScriptFunction(const Name: string; const Params: array of const): string;

var


  FWebBaseLua: TLua; //lua脚本

  vServerTempVarArr: array[0..1000] of integer;

  ToolRateClass: TToolRateListClass;
  MineAvailClass: TMineAvailClass;
  MineShapeClass: TMineShapeClass;
  MineClass: TMineClass;
  JobGradeClass: TJobGradeClass;
  JobUpgradeClass: TJobUpgradeClass;
  TalentLevelClass: TTalentLevelClass;
//    NameStringListForDeleteMagic: TStringList;
  RejectNameList: TStringList;
  RandomClass: TRandomClass;
  MagicClass: TMagicClass;
  MagicParamClass: TMagicParamClass;
  NEWItemIDClass: Tsaveid;
  NEWEmailIDClass: Tsaveid;
  NEWAuctionIDClass: Tsaveid;

  AttachClass: TAttachClass;
  ItemLifeDataClass: TItemLifeDataClass;
  WeaponLevelColorClass: TWeaponLevelColorClass;
  MaterialClass: TMaterialClass;
  ItemClass: TItemClass;
  //  ItemUPLevelClass: TItemUPLevelClass;
  MapPathList: TMapPathList;
  DynamicObjectClass: TDynamicObjectClass;
  ItemDrugClass: TItemDrugClass;
  MonsterClass: TMonsterClass;
  NpcClass: TNpcClass;
    //--------------------------------------------------------
//    ScripterNPC     :TScripter;    //NPC
//    ScripterMonster :TScripter;    //怪物
  ScripterList: TScripter;
  LuaScripterList: TLuaScripter;
    //--------------------------------------------------------
  SysopClass: TSysopclass;
  PosByDieClass: TPosByDieClass;
  QuestClass: TQuestClass;
  AreaClass: TAreaClass;
  PrisonClass: TPrisonClass;
    //    NpcFunction     :TNpcFunction;
  PowerLevelClass: TPowerLevelSub;


  GrobalLightDark: TLightDark = gld_light;

  NameOfLend: string = '';

  GameStartDateStr: string;
  GameStartYear: Word = 2000;
  GameStartMonth: Word = 1;
  GameStartDay: Word = 1;

  GameCurrentDate: integer = 0;

  Udp_MouseEvent_IpAddress: string = '';
  Udp_MouseEvent_Port: integer = 6000;

  Udp_Item_IpAddress: string = '';
  Udp_Item_Port: integer = 6000;

  Udp_Moniter_IpAddress: string = '';
  Udp_Moniter_Port: integer = 6000;

  Udp_Connect_IpAddress: string = '';
  Udp_Connect_Port: integer = 6022;
  Udp_Receiver_IpAddress: string = '';
  Udp_Receiver_Port: integer = 6000;
    {
       Udp_UserData_Ipaddress : string = '';
       Udp_UserData_Port : integer = 0;
       Udp_UserData_LocalPort : integer = 0;
    }

  NoticeServerIpAddress: string = '';
  NoticeServerPort: Integer = 0;


  ProcessListCount: integer = 200;
  ProcessListUserCount: integer = 40;

    ////////////////////////
    //     INI Variable
    ////////////////////////

  INI_WHO: string = '/WHO';
  INI_SERCHSKILL: string = '@SERCHSKILL';
  INI_SERCHITEM: string = '钱币';
  INI_SERCHCOUNT: integer = 500;
  INI_WHITEDRUG: string = 'WHITEDRUG';
  INI_ROPE: string = 'ROPE';
  INI_SEX_FIELD_MAN: string = 'MAN';
  INI_SEX_FIELD_WOMAN: string = 'WOMAN';
  INI_GUILD_STONE: string = 'GUILDSTONE';
  INI_GUILD_NPCMAN_NAME: string = 'NPCMAN';
  INI_GUILD_NPCWOMAN_NAME: string = 'NPCWOMAN';
  INI_GOLD: string = '钱币';
  INI_DEFAULTGOLD: string = '绑定钱币';
  INI_GOLD_Money: string = 'MONEY'; //【元宝】
  INI_GAINAME: string = '改名卡';
  INI_HECHENG: integer = 0;
  INI_QIANGHUA: integer = 0;
  //INI_PAYTABLE: string = 'mqn_yb';
  INI_WEAPONGUILD: integer = 0;
  INI_GUILDDURABYHIT: integer = 20;
  INI_GUILDBAOHU: integer = 0;
  INI_NAIXING: integer = 0;
  INI_MONNAIXING: integer = 0;
  INI_BOWTOHIT: integer = 0;
  INI_WEBIP: string = '127.0.0.1';
  INI_WEBPORT: integer = 0;
  INI_ENERGYADD: integer = 0;

  INI_Guild_MAN_SEX: string = 'MAN';
  INI_Guild_MAN_CAP: string = '';
  INI_Guild_MAN_HAIR: string = '';
  INI_GUILD_MAN_UPUNDERWEAR: string = '';
  INI_Guild_MAN_UPOVERWEAR: string = '';
  INI_Guild_MAN_DOWNUNDERWEAR: string = '';
  INI_Guild_MAN_GLOVES: string = '';
  INI_Guild_MAN_SHOES: string = '';
  INI_Guild_MAN_WEAPON: string = '';
  INI_GUILD_MAN_SHAPE: integer = 27;
  INI_GUILD_MAN_ANIMATE: integer = 11;

  INI_Guild_WOMAN_SEX: string = 'WOMAN';
  INI_Guild_WOMAN_CAP: string = '';
  INI_Guild_WOMAN_HAIR: string = '';
  INI_GUILD_WOMAN_UPUNDERWEAR: string = '';
  INI_Guild_WOMAN_UPOVERWEAR: string = '';
  INI_Guild_WOMAN_DOWNUNDERWEAR: string = '';
  INI_Guild_WOMAN_GLOVES: string = '';
  INI_Guild_WOMAN_SHOES: string = '';
  INI_Guild_WOMAN_WEAPON: string = '';
  INI_GUILD_WOMAN_SHAPE: integer = 30;
  INI_GUILD_WOMAN_ANIMATE: integer = 12;

  INI_DEF_WRESTLING: string;
  INI_DEF_FENCING: string;
  INI_DEF_SWORDSHIP: string;
  INI_DEF_HAMMERING: string;
  INI_DEF_SPEARING: string;
  INI_DEF_BOWING: string;
  INI_DEF_THROWING: string;
  INI_DEF_RUNNING: string;
  INI_DEF_BREATHNG: string;
  INI_DEF_PROTECTING: string;

  INI_DEF_WRESTLING2: string = '不羁浪人拳法';
  INI_DEF_FENCING2: string = '不羁浪人剑法';
  INI_DEF_SWORDSHIP2: string = '不羁浪人刀法';
  INI_DEF_HAMMERING2: string = '不羁浪人槌法';
  INI_DEF_SPEARING2: string = '不羁浪人枪法';
  INI_DEF_BOWING2: string = '不羁浪人弓术';
  INI_DEF_THROWING2: string = '不羁浪人投法';
  INI_DEF_RUNNING2: string = '不羁浪人步法';
  INI_DEF_BREATHNG2: string = '不羁浪人心法';
  INI_DEF_PROTECTING2: string = '不羁浪人强身';



  INI_NORTH: string;
  INI_NORTHEAST: string;
  INI_EAST: string;
  INI_EASTSOUTH: string;
  INI_SOUTH: string;
  INI_SOUTHWEST: string;
  INI_WEST: string;
  INI_WESTNORTH: string;

  INI_HIDEPAPER_DELAY: Integer = 15;
  INI_SHOWPAPER_DELAY: Integer = 60;

  INI_ADD_DAMAGE: integer = 40;

  INI_MAGIC_DIV_VALUE: integer = 10;

  INI_MUL_ATTACKSPEED: integer = 10;
  INI_MUL_AVOID: integer = 6;
  INI_MUL_ACCURACY: integer = 6;

  INI_MUL_RECOVERY: integer = 10;
  INI_MUL_DAMAGEBODY: integer = 23;
  INI_MUL_DAMAGEHEAD: integer = 17;
  INI_MUL_DAMAGEARM: integer = 17;
  INI_MUL_DAMAGELEG: integer = 17;
  INI_MUL_ARMORBODY: integer = 7;
  INI_MUL_ARMORHEAD: integer = 7;
  INI_MUL_ARMORARM: integer = 7;
  INI_MUL_ARMORLEG: integer = 7;

  INI_MUL_EVENTENERGY: integer = 20;
  INI_MUL_EVENTINPOWER: integer = 22;
  INI_MUL_EVENTOUTPOWER: integer = 22;
  INI_MUL_EVENTMAGIC: integer = 10;
  INI_MUL_EVENTLIFE: integer = 8;

  INI_MUL_5SECENERGY: integer = 20;
  INI_MUL_5SECINPOWER: integer = 14;
  INI_MUL_5SECOUTPOWER: integer = 14;
  INI_MUL_5SECMAGIC: integer = 9;
  INI_MUL_5SECLIFE: integer = 8;
    //2层


  INI_2MAGIC_DIV_VALUE: integer = 10;
  INI_2ADD_DAMAGE: integer = 40;
  INI_2MUL_ATTACKSPEED: integer = 10;
  INI_2MUL_AVOID: integer = 6;
  INI_2MUL_RECOVERY: integer = 10;
  INI_2MUL_ACCURACY: integer = 6;
  INI_2MUL_KEEPRECOVERY: integer = 5;
  INI_2MUL_DAMAGEBODY: integer = 23;
  INI_2MUL_DAMAGEHEAD: integer = 17;
  INI_2MUL_DAMAGEARM: integer = 17;
  INI_2MUL_DAMAGELEG: integer = 17;
  INI_2MUL_ARMORBODY: integer = 7;
  INI_2MUL_ARMORHEAD: integer = 8;
  INI_2MUL_ARMORARM: integer = 8;
  INI_2MUL_ARMORLEG: integer = 8;

  INI_2MUL_EVENTENERGY: integer = 20;
  INI_2MUL_EVENTINPOWER: integer = 22;
  INI_2MUL_EVENTOUTPOWER: integer = 22;
  INI_2MUL_EVENTMAGIC: integer = 10;
  INI_2MUL_EVENTLIFE: integer = 8;

  INI_2MUL_5SECENERGY: integer = 20;
  INI_2MUL_5SECINPOWER: integer = 14;
  INI_2MUL_5SECOUTPOWER: integer = 14;
  INI_2MUL_5SECMAGIC: integer = 9;
  INI_2MUL_5SECLIFE: integer = 8;
  //
  INI_CREATEGUILDMAXNUM: Integer = 20;
  INI_CREATEGUILDMAXLIFE: Integer = 1000000;

  //INI_PAYTABLE: string = 'mqn_yb';
  INI_CONTACTTABLE: string = 'mqn_contact';
  INI_USERTABLE: string = 'mqn_contact';
  INI_USERINFOTABLE: string = 'mqn_user_info';

function GetItemDataInfo(var aItemData: TItemData): string;
function GetMagicDataInfo(var aMagicData: TMagicData): string;
procedure GatherLifeData(var BaseLifeData, aLifeData: TLifeData);
procedure GatMultiplyLifeData(var BaseLifeData: TLifeData; amultiply: integer); overload;
procedure GatMultiplyLifeData(var BaseLifeData: TLifeData; amultiply: TLifeData); overload;
procedure GatMix_MaxLifeData(var BaseLifeData: TLifeData; MinLifeData, MaxLifeData: TLifeData);
procedure GatherLifeDataWEAPON(var BaseLifeData, aLifeData: TLifeData);
procedure GatherLifeDataNOTWEAPON(var BaseLifeData, aLifeData: TLifeData);
procedure CheckLifeData(var BaseLifeData: TLifeData);
procedure NewItemSet(atype: Tnewitemtype; var aitem: titemdata);
function NewItemSetCount(var aitem: titemdata): integer;

implementation

uses
  uuser, uconnect, uManager, uMonster, uNpc, uGuild, uItemLog, SVMain;

procedure StrToEffectData(var effectdata: TEffectData; astr: string);
var
  str, rdstr: string;
begin
  str := astr;
  str := GetValidStr3(str, rdstr, ':');
  effectdata.rWavNumber := _StrToInt(rdstr);
  str := GetValidStr3(str, rdstr, ':');
  effectdata.rPercent := _StrToInt(rdstr);
end;

function GetMagicDataInfo(var aMagicData: TMagicData): string;
begin
  Result := '';
  if aMagicData.rName = '' then exit;
  with aMagicData.rcLifeData do
  begin
    Result := format('%s  修练等级: %s', [(aMagicData.rName), Get10000To100(aMagicData.rcSkillLevel)]) + #13;

    if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) then
      Result := Result + format('攻击速度: %d   恢复: %d   躲闪: %d', [AttackSpeed, Recovery, Avoid]) + #13;
    if DamageBody <> 0 then
      Result := Result + format('破坏力: %d / %d / %d / %d', [DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
    if ArmorBody <> 0 then
      Result := Result + format('防御力:  %d / %d / %d / %d', [ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
  end;

end;
//返回 物品 文字 描述

function GetItemDataInfo(var aItemData: TItemData): string;
var
  str: string;
begin
  Result := '';
  if aItemData.rName = '' then exit;
    //名字
  Result := Result + (aItemData.rViewName) + #13;
    //描述
  str := ItemClass.getdesc(aItemData.rName);
  if str <> '' then Result := Result + str + #13;
    //持久
  if aItemData.rDurability <> 0 then
    Result := Result + format('耐力: %d/%d', [aItemData.rCurDurability, aItemData.rDurability]) + #13;
    //属性

  with aItemData.rLifeData do
  begin
    if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) then
      Result := Result + format('攻击速度: %d   恢复: %d   躲闪: %d', [-AttackSpeed, -Recovery, Avoid]) + #13;
    if (DamageBody <> 0) or (DamageHead <> 0) or (DamageArm <> 0) or (DamageLeg <> 0) then
      Result := Result + format('破坏力: %d / %d / %d / %d', [DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
    if (ArmorBody <> 0) or (ArmorHead <> 0) or (ArmorArm <> 0) or (ArmorLeg <> 0) then
      Result := Result + format('防御力:  %d / %d / %d / %d', [ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
    if HitArmor <> 0 then Result := Result + format('维持:  %d', [HitArmor]) + #13;
  end;
  if aItemData.rSmithingLevel > 0 then
    Result := Result + format('精炼等级+%d', [aItemData.rSmithingLevel]) + #13;
    //镶嵌宝石
  with aItemData.rSetting do
  begin
    if rsettingcount > 0 then
    begin
      Result := Result + format('(%d孔可镶嵌宝石)', [rsettingcount]) + #13;
      if rsettingcount >= 1 then
        if rsetting1 <> '' then Result := Result + ' +' + rsetting1 + #13;
      if rsettingcount >= 2 then
        if rsetting2 <> '' then Result := Result + ' +' + rsetting2 + #13;
      if rsettingcount >= 3 then
        if rsetting3 <> '' then Result := Result + ' +' + rsetting3 + #13;
      if rsettingcount >= 4 then
        if rsetting4 <> '' then Result := Result + ' +' + rsetting4 + #13;
    end;
  end;
    //价格
  Result := Result + format('价格: %d', [aItemData.rPrice]) + #13;
end;
//最小 到最大，随机

procedure GatMix_MaxLifeData(var BaseLifeData: TLifeData; MinLifeData, MaxLifeData: TLifeData);
begin

  BaseLifeData.DamageBody := BaseLifeData.DamageBody + MinLifeData.damageBody + Random(MaxLifeData.damageBody - MinLifeData.damageBody);
  BaseLifeData.DamageHead := BaseLifeData.DamageHead + MinLifeData.DamageHead + Random(MaxLifeData.DamageHead - MinLifeData.DamageHead);
  BaseLifeData.DamageArm := BaseLifeData.DamageArm + MinLifeData.DamageArm + Random(MaxLifeData.DamageArm - MinLifeData.DamageArm);
  BaseLifeData.DamageLeg := BaseLifeData.DamageLeg + MinLifeData.DamageLeg + Random(MaxLifeData.DamageLeg - MinLifeData.DamageLeg);

  BaseLifeData.AttackSpeed := BaseLifeData.AttackSpeed + MinLifeData.AttackSpeed + Random(MaxLifeData.AttackSpeed - MinLifeData.AttackSpeed);
  BaseLifeData.avoid := BaseLifeData.avoid + MinLifeData.avoid + Random(MaxLifeData.avoid - MinLifeData.avoid);
  BaseLifeData.recovery := BaseLifeData.recovery + MinLifeData.recovery + Random(MaxLifeData.recovery - MinLifeData.recovery);
  BaseLifeData.accuracy := BaseLifeData.accuracy + MinLifeData.accuracy + Random(MaxLifeData.accuracy - MinLifeData.accuracy);
  BaseLifeData.HitArmor := BaseLifeData.HitArmor + MinLifeData.HitArmor + Random(MaxLifeData.HitArmor - MinLifeData.HitArmor);

  BaseLifeData.armorBody := BaseLifeData.armorBody + MinLifeData.armorBody + Random(MaxLifeData.armorBody - MinLifeData.armorBody);
  BaseLifeData.armorhead := BaseLifeData.armorHead + MinLifeData.armorHead + Random(MaxLifeData.armorHead - MinLifeData.armorHead);
  BaseLifeData.armorArm := BaseLifeData.armorArm + MinLifeData.armorArm + Random(MaxLifeData.armorArm - MinLifeData.armorArm);
  BaseLifeData.armorLeg := BaseLifeData.armorLeg + MinLifeData.armorLeg + Random(MaxLifeData.armorLeg - MinLifeData.armorLeg);
end;

procedure GatMultiplyLifeData(var BaseLifeData: TLifeData; amultiply: integer);
begin
  if amultiply < 0 then amultiply := 0;
  BaseLifeData.DamageBody := BaseLifeData.DamageBody * amultiply;
  BaseLifeData.DamageHead := BaseLifeData.DamageHead * amultiply;
  BaseLifeData.DamageArm := BaseLifeData.DamageArm * amultiply;
  BaseLifeData.DamageLeg := BaseLifeData.DamageLeg * amultiply;

  BaseLifeData.AttackSpeed := BaseLifeData.AttackSpeed * amultiply;
  BaseLifeData.avoid := BaseLifeData.avoid * amultiply;
  BaseLifeData.recovery := BaseLifeData.recovery * amultiply;
  BaseLifeData.accuracy := BaseLifeData.accuracy * amultiply;
  BaseLifeData.HitArmor := BaseLifeData.HitArmor * amultiply;
  BaseLifeData.armorBody := BaseLifeData.armorBody * amultiply;
  BaseLifeData.armorhead := BaseLifeData.armorHead * amultiply;
  BaseLifeData.armorArm := BaseLifeData.armorArm * amultiply;
  BaseLifeData.armorLeg := BaseLifeData.armorLeg * amultiply;
end;

procedure GatMultiplyLifeData(var BaseLifeData: TLifeData; amultiply: TLifeData);
begin
  BaseLifeData.DamageBody := BaseLifeData.DamageBody * amultiply.DamageBody div 100;
  BaseLifeData.DamageHead := BaseLifeData.DamageHead * amultiply.DamageHead div 100;
  BaseLifeData.DamageArm := BaseLifeData.DamageArm * amultiply.DamageArm div 100;
  BaseLifeData.DamageLeg := BaseLifeData.DamageLeg * amultiply.DamageLeg div 100;

  BaseLifeData.AttackSpeed := BaseLifeData.AttackSpeed * amultiply.AttackSpeed div 100;
  BaseLifeData.avoid := BaseLifeData.avoid * amultiply.avoid div 100;
  BaseLifeData.recovery := BaseLifeData.recovery * amultiply.recovery div 100;
  BaseLifeData.accuracy := BaseLifeData.accuracy * amultiply.accuracy div 100;
  BaseLifeData.HitArmor := BaseLifeData.HitArmor * amultiply.HitArmor div 100;
  BaseLifeData.armorBody := BaseLifeData.armorBody * amultiply.armorBody div 100;
  BaseLifeData.armorhead := BaseLifeData.armorHead * amultiply.armorHead div 100;
  BaseLifeData.armorArm := BaseLifeData.armorArm * amultiply.armorArm div 100;
  BaseLifeData.armorLeg := BaseLifeData.armorLeg * amultiply.armorLeg div 100;
end;

procedure GatherLifeData(var BaseLifeData, aLifeData: TLifeData);
begin
  BaseLifeData.DamageBody := BaseLifeData.DamageBody + aLifeData.damageBody;
  BaseLifeData.DamageHead := BaseLifeData.DamageHead + aLifeData.damageHead;
  BaseLifeData.DamageArm := BaseLifeData.DamageArm + aLifeData.damageArm;
  BaseLifeData.DamageLeg := BaseLifeData.DamageLeg + aLifeData.damageLeg;

  BaseLifeData.AttackSpeed := BaseLifeData.AttackSpeed + aLifeData.AttackSpeed;
  BaseLifeData.avoid := BaseLifeData.avoid + aLifeData.avoid;
  BaseLifeData.recovery := BaseLifeData.recovery + aLifeData.recovery;
  BaseLifeData.accuracy := BaseLifeData.accuracy + aLifeData.accuracy;

  BaseLifeData.HitArmor := BaseLifeData.HitArmor + aLifeData.HitArmor; //20130910加维持

  BaseLifeData.armorBody := BaseLifeData.armorBody + aLifeData.armorBody;
  BaseLifeData.armorhead := BaseLifeData.armorHead + aLifeData.armorHead;
  BaseLifeData.armorArm := BaseLifeData.armorArm + aLifeData.armorArm;
  BaseLifeData.armorLeg := BaseLifeData.armorLeg + aLifeData.armorLeg;
end;

procedure GatherLifeDataWEAPON(var BaseLifeData, aLifeData: TLifeData);
begin
  BaseLifeData.DamageBody := BaseLifeData.DamageBody + aLifeData.damageBody;
  BaseLifeData.DamageHead := BaseLifeData.DamageHead + aLifeData.damageHead;
  BaseLifeData.DamageArm := BaseLifeData.DamageArm + aLifeData.damageArm;
  BaseLifeData.DamageLeg := BaseLifeData.DamageLeg + aLifeData.damageLeg;
  BaseLifeData.AttackSpeed := BaseLifeData.AttackSpeed + aLifeData.AttackSpeed;
    //  BaseLifeData.avoid := BaseLifeData.avoid + aLifeData.avoid;
     // BaseLifeData.recovery := BaseLifeData.recovery + aLifeData.recovery;

  //  BaseLifeData.armorBody := BaseLifeData.armorBody + aLifeData.armorBody;
   // BaseLifeData.armorhead := BaseLifeData.armorHead + aLifeData.armorHead;
   // BaseLifeData.armorArm := BaseLifeData.armorArm + aLifeData.armorArm;
   // BaseLifeData.armorLeg := BaseLifeData.armorLeg + aLifeData.armorLeg;
end;

procedure GatherLifeDataNOTWEAPON(var BaseLifeData, aLifeData: TLifeData);
begin
    //    BaseLifeData.DamageBody := BaseLifeData.DamageBody + aLifeData.damageBody;
     //   BaseLifeData.DamageHead := BaseLifeData.DamageHead + aLifeData.damageHead;
     //   BaseLifeData.DamageArm := BaseLifeData.DamageArm + aLifeData.damageArm;
      //  BaseLifeData.DamageLeg := BaseLifeData.DamageLeg + aLifeData.damageLeg;

    //BaseLifeData.AttackSpeed := BaseLifeData.AttackSpeed + aLifeData.AttackSpeed;
  BaseLifeData.avoid := BaseLifeData.avoid + aLifeData.avoid;
  BaseLifeData.recovery := BaseLifeData.recovery + aLifeData.recovery;
  BaseLifeData.HitArmor := BaseLifeData.HitArmor + aLifeData.HitArmor;
  BaseLifeData.armorBody := BaseLifeData.armorBody + aLifeData.armorBody;
  BaseLifeData.armorhead := BaseLifeData.armorHead + aLifeData.armorHead;
  BaseLifeData.armorArm := BaseLifeData.armorArm + aLifeData.armorArm;
  BaseLifeData.armorLeg := BaseLifeData.armorLeg + aLifeData.armorLeg;
end;

//已经废弃 由脚本生成

function NewItemSetCount(var aitem: titemdata): integer;
begin
  Result := -1;
  if aitem.rboSetting = false then exit;
  if (aitem.rKind = ITEM_KIND_WEARITEM)
//        or (aitem.rKind = ITEM_KIND_WEARITEM2)
 //       or (aitem.rKind = ITEM_KIND_WEARITEM_29)
  or (aitem.rKind = ITEM_KIND_WEARITEM_GUILD) then
  begin
    //武器 最多2孔
    if aitem.rWearArr = ARR_WEAPON then
    begin
      if random(500) = 250 then
      begin
        aitem.rSetting.rsettingcount := 2;
        Result := aitem.rSetting.rsettingcount;
        exit;
      end;
      if random(1) = 0 then
      begin
        aitem.rSetting.rsettingcount := 1;
        Result := aitem.rSetting.rsettingcount;
        exit;
      end;
    end else //非武器4孔
    begin
      if random(1000) = 500 then
      begin
        aitem.rSetting.rsettingcount := 4;
        Result := aitem.rSetting.rsettingcount;
        exit;
      end;
      if random(500) = 250 then
      begin
        aitem.rSetting.rsettingcount := 3;
        Result := aitem.rSetting.rsettingcount;
        exit;
      end;
      if random(200) = 100 then
      begin
        aitem.rSetting.rsettingcount := 2;
        Result := aitem.rSetting.rsettingcount;
        exit;
      end;
      if random(1) = 0 then
      begin
        aitem.rSetting.rsettingcount := 1;
        Result := aitem.rSetting.rsettingcount;
        exit;
      end;
    end;
  end;
end;

procedure NewItemSet(atype: Tnewitemtype; var aitem: titemdata);
var
  i: integer;
begin

  if (aitem.rId = 0) then NEWItemIDClass.ItemNewId(aitem);
  if aitem.rboTimeMode then
  begin
    aitem.rDateTime := IncSecond(now(), aitem.rDateTimeSec);
  end;
  case atype of
    _nist_all:
      begin
      //  NewItemSetCount(aitem);         //附加 孔数量

        if aitem.rboBlueprint then exit;
        if aitem.rStarLevelMax > 0 then
        begin
          i := random(10000);
          case i of
            5000..7999: aitem.rStarLevel := 2;
            8000..9999: aitem.rStarLevel := 3;
          else aitem.rStarLevel := 1;
          end;
        end;
        if aitem.rStarLevel > aitem.rStarLevelMax then aitem.rStarLevel := aitem.rStarLevelMax;
        if aitem.rStarLevel < 0 then aitem.rStarLevel := 0;

                //随即属性
      end;
    _nist_Not_property:
      begin

      end;
  end;

end;

procedure CheckLifeData(var BaseLifeData: TLifeData);
begin
  if BaseLifeData.damageBody < 0 then BaseLifeData.DamageBody := 0;
  if BaseLifeData.DamageHead < 0 then BaseLifeData.DamageHead := 0;
  if BaseLifeData.DamageArm < 0 then BaseLifeData.DamageArm := 0;
  if BaseLifeData.DamageLeg < 0 then BaseLifeData.DamageLeg := 0;

  if BaseLifeData.AttackSpeed < 0 then BaseLifeData.AttackSpeed := 0;
  if BaseLifeData.avoid < 0 then BaseLifeData.avoid := 0;
  if BaseLifeData.recovery < 0 then BaseLifeData.recovery := 0;
  if BaseLifeData.accuracy < 0 then BaseLifeData.accuracy := 0;
  if BaseLifeData.HitArmor < 0 then BaseLifeData.HitArmor := 0;
  if BaseLifeData.ArmorBody < 0 then BaseLifeData.ArmorBody := 0;
  if BaseLifeData.ArmorHead < 0 then BaseLifeData.ArmorHead := 0;
  if BaseLifeData.ArmorArm < 0 then BaseLifeData.ArmorArm := 0;
  if BaseLifeData.ArmorLeg < 0 then BaseLifeData.ArmorLeg := 0;
end;

procedure LoadCreateMonster(aFileName: string; List: TList);
var
  i: integer;
  iname: string;
  pd: PTCreateMonsterData;
  CreateMonster: TUserStringDb;
begin
  if not FileExists(aFileName) then exit;

  for i := 0 to List.Count - 1 do dispose(List[i]); // 辆丰甫 肋给窃...
  List.Clear;

  CreateMonster := TUserStringDb.Create;
  CreateMonster.LoadFromFile(aFileName);

  for i := 0 to CreateMonster.Count - 1 do
  begin
    iname := CreateMonster.GetIndexName(i);
    new(pd);
    FillChar(pd^, sizeof(TCreateMonsterData), 0);

    pd^.index := i;
    pd^.mName := CreateMonster.GetFieldValueString(iname, 'MonsterName');
    pd^.CurCount := 0;
    pd^.Count := CreateMonster.GetFieldValueInteger(iname, 'Count');
    pd^.x := CreateMonster.GetFieldValueInteger(iname, 'X');
    pd^.y := CreateMonster.GetFieldValueInteger(iname, 'Y');
    pd^.width := CreateMonster.GetFieldValueInteger(iname, 'Width');
    pd^.Member := CreateMonster.GetFieldValueString(iName, 'Member');
    pd^.rnation := CreateMonster.GetFieldValueInteger(iName, 'nation');
    pd^.rmappathid := CreateMonster.GetFieldValueInteger(iName, 'mappathid');

    List.Add(pd);
  end;
  CreateMonster.Free;
end;

procedure LoadCreateNpc(aFileName: string; List: TList);
var
  i: integer;
  iname: string;
  pd: PTCreateNpcData;
  CreateNpc: TUserStringDb;
begin
  if not FileExists(aFileName) then exit;

  for i := 0 to List.Count - 1 do dispose(List[i]); // 辆丰甫 肋给窃...
  List.Clear;

  CreateNpc := TUserStringDb.Create;
  CreateNpc.LoadFromFile(aFileName);

  for i := 0 to CreateNpc.Count - 1 do
  begin
    iname := CreateNpc.GetIndexName(i);
    new(pd);
    FillChar(pd^, sizeof(TCreateNpcData), 0);

    pd^.index := i;
    pd^.mName := CreateNpc.GetFieldValueString(iname, 'NpcName');
    pd^.CurCount := 0;
    pd^.Count := CreateNpc.GetFieldValueInteger(iname, 'Count');
    pd^.x := CreateNpc.GetFieldValueInteger(iname, 'X');
    pd^.y := CreateNpc.GetFieldValueInteger(iname, 'Y');
    pd^.width := CreateNpc.GetFieldValueInteger(iname, 'Width');
    pd^.BookName := CreateNpc.GetFieldValueString(iname, 'BookName');
    pd^.rnation := CreateNpc.GetFieldValueInteger(iName, 'nation');
    pd^.rmappathid := CreateNpc.GetFieldValueInteger(iName, 'mappathid');
    List.Add(pd);
  end;
  CreateNpc.Free;
end;

procedure LoadDynamicObject(aObjectName, aNeedSkill, aNeedItem, aGiveItem, aDropItem, aDropMop, aCallNpc, axs, ays: string; pd: PTCreateDynamicObjectData);
var
  j, iRandomCount: integer;
  mStr, sStr: string;
  DynamicObjectData: TDynamicObjectData;
  MagicData: TMagicData;
  ItemData: TItemData;
  MonsterData: TMonsterData;
  NpcData: TNpcData;
begin
  if pd = nil then exit;
  DynamicObjectClass.GetDynamicObjectData(aObjectName, DynamicObjectData);
  if DynamicObjectData.rName <> '' then
  begin
    pd^.rBasicData := DynamicObjectData;
        // pd^.rNeedSkill
    mStr := aNeedSkill;
    for j := 0 to 5 - 1 do
    begin
      if mStr = '' then break;
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr <> '' then
      begin
        MagicClass.GetMagicData(sStr, MagicData, 0);
        if MagicData.rname <> '' then
        begin
          pd^.rNeedSkill[j].rName := (MagicData.rName);
          mStr := GetValidStr3(mStr, sStr, ':');
          pd^.rNeedSkill[j].rLevel := _StrToInt(sStr);
        end;
      end;
    end;
            // pd^.rNeedItem
    mStr := aNeedItem;
    for j := 0 to 5 - 1 do
    begin
      if mStr = '' then break;
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr <> '' then
      begin
        ItemClass.GetItemData(sStr, ItemData);
        if ItemData.rname <> '' then
        begin
          pd^.rNeedItem[j].rName := (ItemData.rName);
          mStr := GetValidStr3(mStr, sStr, ':');
          pd^.rNeedItem[j].rCount := _StrToInt(sStr);
        end;
      end;
    end;
            // pd^.rGiveItem
    mStr := aGiveItem;
    for j := 0 to 5 - 1 do
    begin
      if mStr = '' then break;
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr <> '' then
      begin
        ItemClass.GetItemData(sStr, ItemData);
        if ItemData.rName <> '' then
        begin
          pd^.rGiveItem[j].rName := (ItemData.rName);
          mStr := GetValidStr3(mStr, sStr, ':');
          pd^.rGiveItem[j].rCount := _StrToInt(sStr);
          mStr := GetValidStr3(mStr, sStr, ':');
          iRandomCount := _StrToInt(sStr);
          if iRandomCount <= 0 then iRandomCount := 1;

          RandomClass.AddData(pd^.rGiveItem[j].rName, aObjectName, iRandomCount);
        end;
      end;
    end;
            // pd^.rDropItem
    mStr := aDropItem;
    for j := 0 to 5 - 1 do
    begin
      if mStr = '' then break;
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr <> '' then
      begin
        ItemClass.GetItemData(sStr, ItemData);
        if ItemData.rname <> '' then
        begin
          pd^.rDropItem[j].rName := (ItemData.rName);
          mStr := GetValidStr3(mStr, sStr, ':');
          pd^.rDropItem[j].rCount := _StrToInt(sStr);
          mStr := GetValidStr3(mStr, sStr, ':');
          iRandomCount := _StrToInt(sStr);
          if iRandomCount <= 0 then iRandomCount := 1;

          RandomClass.AddData(pd^.rDropItem[j].rName, aObjectName, iRandomCount);
        end;
      end;
    end;

            // pd^.rDropMop
    mStr := aDropMop;
    for j := 0 to 5 - 1 do
    begin
      if mStr = '' then break;
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr <> '' then
      begin
        MonsterClass.LoadMonsterData(sStr, MonsterData);
        if MonsterData.rName <> '' then
        begin
          pd^.rDropMop[j].rName := (MonsterData.rName);
          mStr := GetValidStr3(mStr, sStr, ':');
          pd^.rDropMop[j].rCount := _StrToInt(sStr);
        end;
      end;
    end;

            // pd^.rCallNpc
    mStr := aCallNpc;
    for j := 0 to 5 - 1 do
    begin
      if mStr = '' then break;
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr <> '' then
      begin
        NpcClass.LoadNpcData(sStr, NpcData);
        if NpcData.rName <> '' then
        begin
          pd^.rCallNpc[j].rName := (NpcData.rName);
          mStr := GetValidStr3(mStr, sStr, ':');
          pd^.rCallNpc[j].rCount := _StrToInt(sStr);
        end;
      end;
    end;

    mStr := axs;
    for j := 0 to 5 - 1 do
    begin
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr = '' then break;
      pd^.rX[j] := _StrToInt(sStr);
    end;
    mStr := ays;
    for j := 0 to 5 - 1 do
    begin
      mStr := GetValidStr3(mStr, sStr, ':');
      if sStr = '' then break;
      pd^.rY[j] := _StrToInt(sStr);
    end;
  end;
end;

procedure LoadCreateDynamicObject(aFileName: string; List: TList);
var
  i: integer;
  iName, ObjectName: string;
  DynamicObjectData: TDynamicObjectData;
  pd: PTCreateDynamicObjectData;
  CreateDynamicObject: TUserStringDb;
    //MagicData: TMagicData;
   // ItemData: TItemData;
//    MonsterData: TMonsterData;
//    NpcData: TNpcData;
begin
  if not FileExists(aFileName) then exit;

  for i := 0 to List.Count - 1 do
  begin
    Dispose(List[i]);
  end;
  List.Clear;

  CreateDynamicObject := TUserStringDb.Create;
  CreateDynamicObject.LoadFromFile(aFileName);

  for i := 0 to CreateDynamicObject.Count - 1 do
  begin
    iName := CreateDynamicObject.GetIndexName(i);
    ObjectName := CreateDynamicObject.GetFieldValueString(iName, 'Name');
    FillChar(DynamicObjectData, SizeOf(DynamicObjectData), 0);
    DynamicObjectClass.GetDynamicObjectData(ObjectName, DynamicObjectData);
    if DynamicObjectData.rName <> '' then
    begin
      New(pd);
      FillChar(pd^, sizeof(TCreateDynamicObjectData), 0);
      pd^.rBasicData := DynamicObjectData;
            {
            pd^.rState := CreateDynamicObject.GetFieldValueInteger (iname, 'State');
            pd^.rRegenInterval := CreateDynamicObject.GetFieldValueInteger (iname, 'RegenInterval');
            pd^.rLife := CreateDynamicObject.GetFieldValueInteger (iname, 'Life');
            }
      pd^.rNeedAge := CreateDynamicObject.GetFieldValueInteger(iname, 'NeedAge');

      LoadDynamicObject(ObjectName
        , CreateDynamicObject.GetFieldValueString(iname, 'NeedSkill')
        , CreateDynamicObject.GetFieldValueString(iname, 'NeedItem')
        , CreateDynamicObject.GetFieldValueString(iname, 'GiveItem')
        , CreateDynamicObject.GetFieldValueString(iname, 'DropItem')
        , CreateDynamicObject.GetFieldValueString(iname, 'DropMop')
        , CreateDynamicObject.GetFieldValueString(iname, 'CallNpc')
        , CreateDynamicObject.GetFieldValueString(iname, 'X')
        , CreateDynamicObject.GetFieldValueString(iname, 'Y')
        , pd
        );
      pd^.rDropX := CreateDynamicObject.GetFieldValueInteger(iName, 'DropX');
      pd^.rDropY := CreateDynamicObject.GetFieldValueInteger(iName, 'DropY');
      pd^.rWidth := CreateDynamicObject.GetFieldValueInteger(iName, 'Width');
      pd^.rboDelay := CreateDynamicObject.GetFieldValueBoolean(iName, 'boDelay');

      List.Add(pd);
    end;
  end;
  CreateDynamicObject.Free;
end;

function GetServerIdPointer(aServerId, atype: integer): Pointer;
begin
  Result := nil;
end;

///////////////////////////////////
//         TRandomClass
///////////////////////////////////

constructor TRandomClass.Create;
begin
  DataList := nil;
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create;
end;

destructor TRandomClass.Destroy;
begin
  Clear;
  if DataList <> nil then DataList.Free;
  AnsIndexClass.Free;
end;

procedure TRandomClass.del(aObjname: string);
var
  i: Integer;
  p: TRandomDataClass;
begin
  if get(aObjname) = nil then exit;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p.FObjName = aObjname then
    begin
      DataList.Delete(i);
      AnsIndexClass.Delete(p.FObjName);
      p.Free;
      exit;
    end;
  end;

end;

procedure TRandomClass.Clear;
var
  i: Integer;
  p: TRandomDataClass;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    p.Free;
  end;
  DataList.Clear;
  AnsIndexClass.Clear;
end;

function TRandomClass.get(aObjname: string): TRandomDataClass;
begin
  result := AnsIndexClass.Select(aObjname);
end;

procedure TRandomClass.AddData(aItemName, aObjName: string; aCount: Integer);
var
  p: TRandomDataClass;
  temp: TRandomData;
begin
  if (aItemName = '') or (aObjName = '') then exit;
  p := get(aObjName);
  if p = nil then
  begin
    p := TRandomDataClass.Create;
    P.FObjName := aObjName;
    DataList.Add(p);
    AnsIndexClass.Insert(aObjName, p);
  end;

  temp.rItemName := aItemName;
  temp.rObjName := aObjName;
  if aCount < 1 then temp.rCount := 1
  else temp.rCount := aCount;
  //temp.rIndex := Random(temp.rCount);
  if temp.rCount >= 10000 then
    temp.rIndex := (temp.rCount div 2) + Random(temp.rCount div 2)
  else
    temp.rIndex := Random(temp.rCount);
  temp.rCurIndex := 0;
  p.add(temp);
end;

function TRandomClass.GetChance(aItemName, aObjName: string; aName: string = ''): Boolean;
var
//    i: Integer;
  pd: PTRandomData;
  p: TRandomDataClass;
  uUser: tuser;
begin
  Result := false;
  p := get(aObjName);
  if p = nil then exit;

  pd := p.get(aItemName);
  if pd = nil then exit;
  if pd^.rItemName = aItemName then
  begin
    if pd^.rObjName = aObjName then
    begin
      Result := false;
      //检测是否有传入玩家姓名
      if aName <> '' then
      begin
        //获取玩家爆出作弊设置
        uUser := UserList.GetUserPointer(aName);
        if (uUser <> nil) and (uUser.getCheatings = pd^.rCount) then
        begin
          pd^.rCurIndex := pd^.rIndex;
          uUser.SetCheatings(0);
        end;
      end;

      if pd^.rCurIndex = pd^.rIndex then Result := true;
      Inc(pd^.rCurIndex);
      if pd^.rCurIndex >= pd^.rCount then
      begin
        pd^.rCurIndex := 0;
        pd^.rIndex := Random(pd^.rCount);
        //pd^.rIndex := (pd^.rCount div 2) + Random(pd^.rCount div 2);
      end;
      exit;
    end;
  end;
end;

function TRandomClass.SetChance(aItemName, aObjName: string; CurIndex, Index, Count: Integer): Boolean;
var
//    i: Integer;
  pd: PTRandomData;
  p: TRandomDataClass;
begin
  Result := false;
  p := get(aObjName);
  if p = nil then exit;

  pd := p.get(aItemName);
  if pd = nil then exit;
  if pd^.rItemName = aItemName then
  begin
    if pd^.rObjName = aObjName then
    begin
      pd^.rCurIndex := CurIndex;
      pd^.rIndex := Index;
      pd^.rCount := Count;
      Result := true;
      exit;
    end;
  end;
end;


function TRandomClass.GetCount: integer;
begin
  result := DataList.Count;
end;

function TRandomClass.GetDataByIndex(aIndex: Integer): TRandomDataClass;
var
//    i: Integer;
  p: TRandomDataClass;
begin
  Result := nil;
  if (aIndex < 0) and (aIndex > DataList.Count) then Exit;
  p := DataList.Items[aIndex];
  if p <> nil then Result := p;
  exit;
end;

function TRandomClass.GetDataByObjName(aObjName: string): TRandomDataClass;
var
//    i: Integer;
  p: TRandomDataClass;
begin
  Result := nil;
  p := get(aObjName);
  if p = nil then exit;
  Result := p;
  exit;
end;

///////////////////////////////////
//         TSysopClass
///////////////////////////////////

constructor TSysopClass.Create;
begin
  SysopDb := TUserStringDb.Create;
  ReLoadFromFile;
end;

destructor TSysopClass.Destroy;
begin
  SysopDb.Free;
  inherited destroy;
end;

procedure TSysopClass.ReLoadFromFile;
begin
  SysopDb.Clear;
  if not FileExists('.\Sysop.SDB') then exit;
  SysopDb.LoadFromFile('.\Sysop.SDB');
end;

function TSysopClass.GetSysopScope(aName: string): integer;
begin
  if SysopDb.Count > 0 then Result := SysopDb.GetFieldValueInteger(aName, 'SysopScope')
  else Result := 0;
end;
//////////////////////////////////////////////////////
//                    TMagicClass

function TMagicClass.LoadMagicData(aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;
begin
  Result := FALSE;
  FillChar(MagicData, sizeof(MagicData), 0);
  if aDb.GetDbString(aMagicName) = '' then exit;
  with MagicData do
  begin
    rname := aMagicName;
        // rPercent := 10;

    StrToEffectData(rSoundEvent, aDb.GetFieldValueString(aMagicName, 'SoundEvent'));
    StrToEffectData(rSoundStrike, aDb.GetFieldValueString(aMagicName, 'SoundStrike'));
    StrToEffectData(rSoundSwing, aDb.GetFieldValueString(aMagicName, 'SoundSwing'));
    StrToEffectData(rSoundStart, aDb.GetFieldValueString(aMagicName, 'SoundStart'));
    StrToEffectData(rSoundEnd, aDb.GetFieldValueString(aMagicName, 'SoundEnd'));

    rBowImage := aDb.GetFieldValueinteger(aMagicName, 'BowImage');
    rBowSpeed := aDb.GetFieldValueinteger(aMagicName, 'BowSpeed');
    rBowType := aDb.GetFieldValueinteger(aMagicName, 'BowType');
    rShape := aDb.GetFieldValueinteger(aMagicName, 'Shape');
    rMagicType := aDb.GetFieldValueinteger(aMagicName, 'MagicType');
    rFunction := aDb.GetFieldValueinteger(aMagicName, 'Function');
    rEnergyPoint := aDb.GetFieldValueinteger(aMagicName, 'EnergyPoint');
    rMagicRelation := aDb.GetFieldValueinteger(aMagicName, 'MagicRelation');
        //      rGoodChar := aDb.GetFieldValueinteger (aMagicName, 'GoodChar');
        //      rBadChar := aDb.GetFieldValueinteger (aMagicName, 'BadChar');
    rMagicExp := aDb.GetFieldValueinteger(aMagicName, 'MagicExp');
    case rMagicType of
      0..99:
        begin
          if aDb.GetFieldValueinteger(aMagicName, 'AttackSpeed') <> 0 then
            rLifeData.AttackSpeed := (120 - aDb.GetFieldValueinteger(aMagicName, 'AttackSpeed')) * INI_MUL_ATTACKSPEED div INI_MAGIC_DIV_VALUE;
          if aDb.GetFieldValueinteger(aMagicName, 'Recovery') <> 0 then
            rLifeData.recovery := (120 - aDb.GetFieldValueinteger(aMagicName, 'Recovery')) * INI_MUL_RECOVERY div INI_MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'Avoid') <> 0 then
            rLifeData.avoid := aDb.GetFieldValueinteger(aMagicName, 'Avoid') * INI_MUL_AVOID div INI_MAGIC_DIV_VALUE;
          if aDb.GetFieldValueinteger(aMagicName, 'accuracy') <> 0 then
            rLifeData.accuracy := aDb.GetFieldValueinteger(aMagicName, 'accuracy') * INI_MUL_ACCURACY div INI_MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'DamageBody') <> 0 then
            rLifeData.damageBody := (aDb.GetFieldValueinteger(aMagicName, 'DamageBody') + INI_ADD_DAMAGE) * INI_MUL_DAMAGEBODY div INI_MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'DamageHead') <> 0 then
            rLifeData.damageHead := (aDb.GetFieldValueinteger(aMagicName, 'DamageHead') + INI_ADD_DAMAGE) * INI_MUL_DAMAGEHEAD div INI_MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'DamageArm') <> 0 then
            rLifeData.damageArm := (aDb.GetFieldValueinteger(aMagicName, 'DamageArm') + INI_ADD_DAMAGE) * INI_MUL_DAMAGEARM div INI_MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'DamageLeg') <> 0 then
            rLifeData.damageLeg := (aDb.GetFieldValueinteger(aMagicName, 'DamageLeg') + INI_ADD_DAMAGE) * INI_MUL_DAMAGELEG div INI_MAGIC_DIV_VALUE;

          rLifeData.armorBody := aDb.GetFieldValueinteger(aMagicName, 'ArmorBody') * INI_MUL_ARMORBODY div INI_MAGIC_DIV_VALUE;
          rLifeData.armorHead := aDb.GetFieldValueinteger(aMagicName, 'ArmorHead') * INI_MUL_ARMORHEAD div INI_MAGIC_DIV_VALUE;
          rLifeData.armorArm := aDb.GetFieldValueinteger(aMagicName, 'ArmorArm') * INI_MUL_ARMORARM div INI_MAGIC_DIV_VALUE;
          rLifeData.armorLeg := aDb.GetFieldValueinteger(aMagicName, 'ArmorLeg') * INI_MUL_ARMORLEG div INI_MAGIC_DIV_VALUE;

          rEventDecEnergy := aDb.GetFieldValueinteger(aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY div INI_MAGIC_DIV_VALUE;
          rEventDecInPower := aDb.GetFieldValueinteger(aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER div INI_MAGIC_DIV_VALUE;
          rEventDecOutPower := aDb.GetFieldValueinteger(aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER div INI_MAGIC_DIV_VALUE;
          rEventDecMagic := aDb.GetFieldValueinteger(aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC div INI_MAGIC_DIV_VALUE;
          rEventDecLife := aDb.GetFieldValueinteger(aMagicName, 'eLife') * INI_MUL_EVENTLIFE div INI_MAGIC_DIV_VALUE;



          r5SecDecEnergy := aDb.GetFieldValueinteger(aMagicName, '5Energy') * INI_MUL_5SECENERGY div INI_MAGIC_DIV_VALUE;
          r5SecDecInPower := aDb.GetFieldValueinteger(aMagicName, '5InPower') * INI_MUL_5SECINPOWER div INI_MAGIC_DIV_VALUE;
          r5SecDecOutPower := aDb.GetFieldValueinteger(aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER div INI_MAGIC_DIV_VALUE;
          r5SecDecMagic := aDb.GetFieldValueinteger(aMagicName, '5Magic') * INI_MUL_5SECMAGIC div INI_MAGIC_DIV_VALUE;
          r5SecDecLife := aDb.GetFieldValueinteger(aMagicName, '5Life') * INI_MUL_5SECLIFE div INI_MAGIC_DIV_VALUE;
        end;
      100..199:
        begin
          if aDb.GetFieldValueinteger(aMagicName, 'AttackSpeed') <> 0 then
            rLifeData.AttackSpeed := (130 - aDb.GetFieldValueinteger(aMagicName, 'AttackSpeed')) * INI_2MUL_ATTACKSPEED div INI_2MAGIC_DIV_VALUE;
          if aDb.GetFieldValueinteger(aMagicName, 'Recovery') <> 0 then
            rLifeData.recovery := (130 - aDb.GetFieldValueinteger(aMagicName, 'Recovery')) * INI_2MUL_RECOVERY div INI_2MAGIC_DIV_VALUE;


          if aDb.GetFieldValueinteger(aMagicName, 'Avoid') <> 0 then
            rLifeData.avoid := aDb.GetFieldValueinteger(aMagicName, 'Avoid') * INI_2MUL_AVOID div INI_2MAGIC_DIV_VALUE;
            //命中
          if aDb.GetFieldValueinteger(aMagicName, 'accuracy') <> 0 then
            rLifeData.accuracy := aDb.GetFieldValueinteger(aMagicName, 'accuracy') * INI_2MUL_ACCURACY div INI_2MAGIC_DIV_VALUE;

            //维持
          if aDb.GetFieldValueinteger(aMagicName, 'KeepRecovery') <> 0 then
            rLifeData.HitArmor := aDb.GetFieldValueinteger(aMagicName, 'KeepRecovery') * aDb.GetFieldValueinteger(aMagicName, 'KeepRecovery') div 22 + 70;


          if aDb.GetFieldValueinteger(aMagicName, 'DamageBody') <> 0 then
            rLifeData.damageBody := (aDb.GetFieldValueinteger(aMagicName, 'DamageBody') + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGEBODY div INI_2MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'DamageHead') <> 0 then
            rLifeData.damageHead := (aDb.GetFieldValueinteger(aMagicName, 'DamageHead') + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGEHEAD div INI_2MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'DamageArm') <> 0 then
            rLifeData.damageArm := (aDb.GetFieldValueinteger(aMagicName, 'DamageArm') + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGEARM div INI_2MAGIC_DIV_VALUE;

          if aDb.GetFieldValueinteger(aMagicName, 'DamageLeg') <> 0 then
            rLifeData.damageLeg := (aDb.GetFieldValueinteger(aMagicName, 'DamageLeg') + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGELEG div INI_2MAGIC_DIV_VALUE;

          rLifeData.armorBody := aDb.GetFieldValueinteger(aMagicName, 'ArmorBody') * INI_2MUL_ARMORBODY div INI_2MAGIC_DIV_VALUE;
          rLifeData.armorHead := aDb.GetFieldValueinteger(aMagicName, 'ArmorHead') * INI_2MUL_ARMORHEAD div INI_2MAGIC_DIV_VALUE;
          rLifeData.armorArm := aDb.GetFieldValueinteger(aMagicName, 'ArmorArm') * INI_2MUL_ARMORARM div INI_2MAGIC_DIV_VALUE;
          rLifeData.armorLeg := aDb.GetFieldValueinteger(aMagicName, 'ArmorLeg') * INI_2MUL_ARMORLEG div INI_2MAGIC_DIV_VALUE;

          rEventDecEnergy := aDb.GetFieldValueinteger(aMagicName, 'eEnergy') * INI_2MUL_EVENTENERGY div INI_2MAGIC_DIV_VALUE;
          rEventDecInPower := aDb.GetFieldValueinteger(aMagicName, 'eInPower') * INI_2MUL_EVENTINPOWER div INI_2MAGIC_DIV_VALUE;
          rEventDecOutPower := aDb.GetFieldValueinteger(aMagicName, 'eOutPower') * INI_2MUL_EVENTOUTPOWER div INI_2MAGIC_DIV_VALUE;
          rEventDecMagic := aDb.GetFieldValueinteger(aMagicName, 'eMagic') * INI_2MUL_EVENTMAGIC div INI_2MAGIC_DIV_VALUE;
          rEventDecLife := aDb.GetFieldValueinteger(aMagicName, 'eLife') * INI_2MUL_EVENTLIFE div INI_2MAGIC_DIV_VALUE;



          r5SecDecEnergy := aDb.GetFieldValueinteger(aMagicName, '5Energy') * INI_2MUL_5SECENERGY div INI_2MAGIC_DIV_VALUE;
          r5SecDecInPower := aDb.GetFieldValueinteger(aMagicName, '5InPower') * INI_2MUL_5SECINPOWER div INI_2MAGIC_DIV_VALUE;
          r5SecDecOutPower := aDb.GetFieldValueinteger(aMagicName, '5OutPower') * INI_2MUL_5SECOUTPOWER div INI_2MAGIC_DIV_VALUE;
          r5SecDecMagic := aDb.GetFieldValueinteger(aMagicName, '5Magic') * INI_2MUL_5SECMAGIC div INI_2MAGIC_DIV_VALUE;
          r5SecDecLife := aDb.GetFieldValueinteger(aMagicName, '5Life') * INI_2MUL_5SECLIFE div INI_2MAGIC_DIV_VALUE;
        end;
    end;


    rEventBreathngEnergy := aDb.GetFieldValueinteger(aMagicName, 'eEnergy');
    rEventBreathngInPower := aDb.GetFieldValueinteger(aMagicName, 'eInPower');
    rEventBreathngOutPower := aDb.GetFieldValueinteger(aMagicName, 'eOutPower');
    rEventBreathngMagic := aDb.GetFieldValueinteger(aMagicName, 'eMagic');
    rEventBreathngLife := aDb.GetFieldValueinteger(aMagicName, 'eLife');

    rKeepEnergy := aDb.GetFieldValueinteger(aMagicName, 'kEnergy') * 10;
    rKeepInPower := aDb.GetFieldValueinteger(aMagicName, 'kInPower') * 10;
    rKeepOutPower := aDb.GetFieldValueinteger(aMagicName, 'kOutPower') * 10;
    rKeepMagic := aDb.GetFieldValueinteger(aMagicName, 'kMagic') * 10;
    rKeepLife := aDb.GetFieldValueinteger(aMagicName, 'kLife') * 10;

        //新段
    rMotionType := aDb.GetFieldValueinteger(aMagicName, 'MotionType'); //动作类型 1-9
    rEffectColor := aDb.GetFieldValueinteger(aMagicName, 'EffectColor'); //动作效果 颜色
    rSEffectNumber := aDb.GetFieldValueinteger(aMagicName, 'SEffectNumber'); //使用当时 效果
    rSEffectNumber2 := aDb.GetFieldValueinteger(aMagicName, 'SEffectNumber2'); //使用之后 效果
    rCEffectNumber := aDb.GetFieldValueinteger(aMagicName, 'CEffectNumber'); //使用之中 效果
    rEEffectNumber := aDb.GetFieldValueinteger(aMagicName, 'EEffectNumber'); //攻击命中 效果
  end;
  Result := TRUE;
end;

function TMagicClass.GetMagicData(aMagicName: string; var MagicData: TMagicData; aexp: integer): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aMagicName);
    // if (n = 0) or (n = -1) then
  if n = nil then
  begin
    FillChar(MagicData, sizeof(MagicData), 0);
    exit;
  end;
  MagicData := PTMagicData(n)^;

  MagicData.rSkillExp := aexp;
  MagicData.rcSkillLevel := GetLevel(aexp);
  Result := TRUE;
end;

function TMagicClass.CheckMagicData(var MagicData: TMagicData; var aRetStr: string; aCheckName: Boolean = true): Boolean;
var
  i: Integer; //门派武功的值限制
  iName: string;
  tmpMagicData: TMagicData;
  ItemData: TItemData;
begin
  Result := false;

  aRetStr := '';

  iName := (MagicData.rName);
  if iName = '' then
  begin
    aRetStr := '没有输入门派武功名称';
    exit;
  end;
  if (Length(iName) < 4) or (Length(iName) > 10) then
  begin
    aRetStr := '门派武功名称是两个汉字以上五个汉字以下';
    exit;
  end;
  if not IsHZ(iName) then //if not isFullHangul(iName) //or not isGrammarID(iName)
  begin
    aRetStr := '无法使用的门派武功名';
    exit;
  end;

  for i := 0 to RejectNameList.Count - 1 do
  begin
    if Pos(RejectNameList.Strings[i], iName) > 0 then
    begin
      aRetStr := '无法使用的门派武功名';
      exit;
    end;
  end;

  if aCheckName then
  begin
    GetMagicData(iName, tmpMagicData, 1000);
    if tmpMagicData.rName <> '' then
    begin
      aRetStr := '已经存在的武功名称';
      exit;
    end;
  end;

  ItemClass.GetItemData(iName, ItemData);
  if ItemData.rName <> '' then
  begin
    aRetStr := '不能使用道具名称';
    exit;
  end;

  case MagicData.rMagicType of
    MAGICTYPE_WRESTLING,
      MAGICTYPE_FENCING,
      MAGICTYPE_SWORDSHIP,
      MAGICTYPE_HAMMERING,
      MAGICTYPE_SPEARING:
      begin
      end;
  else
    begin
      aRetStr := '武功的种类错误';
      exit;
    end;
  end;
  if (MagicData.rLifeData.AttackSpeed < 1) or (MagicData.rLifeData.AttackSpeed > 99) then
  begin
    aRetStr := '攻击速度只允许1-99的值';
    exit;
  end;
  if (MagicData.rLifeData.DamageBody < 1) or (MagicData.rLifeData.DamageBody > 99) then
  begin
    aRetStr := '上身破坏力只允许1-99的值';
    exit;
  end;
  if (MagicData.rLifeData.Recovery < 1) or (MagicData.rLifeData.Recovery > 99) then
  begin
    aRetStr := '恢复只允许1-99的值';
    exit;
  end;
  if (MagicData.rLifeData.Avoid < 1) or (MagicData.rLifeData.Avoid > 99) then
  begin
    aRetStr := '躲闪只允许1-99的值';
    exit;
  end;
  if (MagicData.rLifeData.DamageHead < 10) or (MagicData.rLifeData.DamageHead > 70) then
  begin
    aRetStr := '头部攻击只允许10-70的值';
    exit;
  end;
  if (MagicData.rLifeData.DamageArm < 10) or (MagicData.rLifeData.DamageArm > 70) then
  begin
    aRetStr := '手臂攻击只允许10-70的值';
    exit;
  end;
  if (MagicData.rLifeData.DamageLeg < 10) or (MagicData.rLifeData.DamageLeg > 70) then
  begin
    aRetStr := '腿部攻击只允许10-70的值';
    exit;
  end;
  if (MagicData.rLifeData.ArmorBody < 10) or (MagicData.rLifeData.ArmorBody > 70) then
  begin
    aRetStr := '上身防御只允许10-70的值';
    exit;
  end;
  if (MagicData.rLifeData.ArmorHead < 10) or (MagicData.rLifeData.ArmorHead > 70) then
  begin
    aRetStr := '头部防御只允许10-70的值';
    exit;
  end;
  if (MagicData.rLifeData.ArmorArm < 10) or (MagicData.rLifeData.ArmorArm > 70) then
  begin
    aRetStr := '手臂防御只允许10-70的值';
    exit;
  end;
  if (MagicData.rLifeData.ArmorLeg < 10) or (MagicData.rLifeData.ArmorLeg > 70) then
  begin
    aRetStr := '腿部防御只允许10-70的值';
    exit;
  end;
  if (MagicData.rEventDecOutPower < 5) or (MagicData.rEventDecOutPower > 35) then
  begin
    aRetStr := '外功消耗只允许5-35的值';
    exit;
  end;
  if (MagicData.rEventDecInPower < 5) or (MagicData.rEventDecInPower > 35) then
  begin
    aRetStr := '内功消耗只允许5-35的值';
    exit;
  end;
  if (MagicData.rEventDecMagic < 5) or (MagicData.rEventDecMagic > 50) then
  begin
    aRetStr := '武功消耗只允许5-50的值';
    exit;
  end;
  if (MagicData.rEventDecLife < 5) or (MagicData.rEventDecLife > 35) then
  begin
    aRetStr := '活力消耗只允许5-35的值';
    exit;
  end;

  if MagicData.rLifeData.AttackSpeed + MagicData.rLifeData.DamageBody <> 100 then
  begin
    aRetStr := '攻击速度和上身攻击之和是100';
    exit;
  end;
  if MagicData.rLifeData.Recovery + MagicData.rLifeData.Avoid <> 100 then
  begin
    aRetStr := '恢复和躲闪之和是100';
    exit;
  end;
  if MagicData.rLifeData.DamageHead + MagicData.rLifeData.DamageArm +
    MagicData.rLifeData.DamageLeg + MagicData.rLifeData.ArmorBody +
    MagicData.rLifeData.ArmorHead + MagicData.rLifeData.ArmorArm +
    MagicData.rLifeData.ArmorLeg <> 228 then
  begin
    aRetStr := '（头部，臂，腿）攻击+（上身，头部，臂，腿）防御力之和是228';
    exit;
  end;
  if MagicData.rEventDecInPower + MagicData.rEventDecOutPower +
    MagicData.rEventDecMagic + MagicData.rEventDecLife <> 80 then
  begin
    aRetStr := '内功+外功+武功+活力（消耗量）之和为80';
    exit;
  end;

  Result := true;
end;

function TMagicClass.GetMagicDataString(MagicData: TMagicData): string;
var
  str: string;
begin
  with MagicData do
  begin
    case rMagicType of
      0..99:
        begin
          if rLifeData.AttackSpeed <> 0 then
            rLifeData.AttackSpeed := (120 - rLifeData.AttackSpeed) * INI_MUL_ATTACKSPEED div INI_MAGIC_DIV_VALUE;
          if rLifeData.recovery <> 0 then
            rLifeData.recovery := (120 - rLifeData.recovery) * INI_MUL_RECOVERY div INI_MAGIC_DIV_VALUE;

          if rLifeData.avoid <> 0 then
            rLifeData.avoid := rLifeData.avoid * INI_MUL_AVOID div INI_MAGIC_DIV_VALUE;
          if rLifeData.accuracy <> 0 then
            rLifeData.accuracy := rLifeData.accuracy * INI_MUL_ACCURACY div INI_MAGIC_DIV_VALUE;

          if rLifeData.damageBody <> 0 then
            rLifeData.damageBody := (rLifeData.damageBody + INI_ADD_DAMAGE) * INI_MUL_DAMAGEBODY div INI_MAGIC_DIV_VALUE;

          if rLifeData.damageHead <> 0 then
            rLifeData.damageHead := (rLifeData.damageHead + INI_ADD_DAMAGE) * INI_MUL_DAMAGEHEAD div INI_MAGIC_DIV_VALUE;

          if rLifeData.damageArm <> 0 then
            rLifeData.damageArm := (rLifeData.damageArm + INI_ADD_DAMAGE) * INI_MUL_DAMAGEARM div INI_MAGIC_DIV_VALUE;

          if rLifeData.damageLeg <> 0 then
            rLifeData.damageLeg := (rLifeData.damageLeg + INI_ADD_DAMAGE) * INI_MUL_DAMAGELEG div INI_MAGIC_DIV_VALUE;

          rLifeData.armorBody := rLifeData.armorBody * INI_MUL_ARMORBODY div INI_MAGIC_DIV_VALUE;
          rLifeData.armorHead := rLifeData.armorHead * INI_MUL_ARMORHEAD div INI_MAGIC_DIV_VALUE;
          rLifeData.armorArm := rLifeData.armorArm * INI_MUL_ARMORARM div INI_MAGIC_DIV_VALUE;
          rLifeData.armorLeg := rLifeData.armorLeg * INI_MUL_ARMORLEG div INI_MAGIC_DIV_VALUE;
        end;
      100..199:
        begin
          if rLifeData.AttackSpeed <> 0 then
            rLifeData.AttackSpeed := (130 - rLifeData.AttackSpeed) * INI_2MUL_ATTACKSPEED div INI_2MAGIC_DIV_VALUE;
          if rLifeData.recovery <> 0 then
            rLifeData.recovery := (130 - rLifeData.recovery) * INI_2MUL_RECOVERY div INI_2MAGIC_DIV_VALUE;


          if rLifeData.avoid <> 0 then
            rLifeData.avoid := rLifeData.avoid * INI_2MUL_AVOID div INI_2MAGIC_DIV_VALUE;
            //命中
          if rLifeData.accuracy <> 0 then
            rLifeData.accuracy := rLifeData.accuracy * INI_2MUL_ACCURACY div INI_2MAGIC_DIV_VALUE;

            //维持
          if rLifeData.HitArmor <> 0 then
            rLifeData.HitArmor := rLifeData.HitArmor * rLifeData.HitArmor div 22 + 70;


          if rLifeData.damageBody <> 0 then
            rLifeData.damageBody := (rLifeData.damageBody + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGEBODY div INI_2MAGIC_DIV_VALUE;

          if rLifeData.damageHead <> 0 then
            rLifeData.damageHead := (rLifeData.damageHead + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGEHEAD div INI_2MAGIC_DIV_VALUE;

          if rLifeData.damageArm <> 0 then
            rLifeData.damageArm := (rLifeData.damageArm + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGEARM div INI_2MAGIC_DIV_VALUE;

          if rLifeData.damageLeg <> 0 then
            rLifeData.damageLeg := (rLifeData.damageLeg + INI_2ADD_DAMAGE) * INI_2MUL_DAMAGELEG div INI_2MAGIC_DIV_VALUE;

          rLifeData.armorBody := rLifeData.armorBody * INI_2MUL_ARMORBODY div INI_2MAGIC_DIV_VALUE;
          rLifeData.armorHead := rLifeData.armorHead * INI_2MUL_ARMORHEAD div INI_2MAGIC_DIV_VALUE;
          rLifeData.armorArm := rLifeData.armorArm * INI_2MUL_ARMORARM div INI_2MAGIC_DIV_VALUE;
          rLifeData.armorLeg := rLifeData.armorLeg * INI_2MUL_ARMORLEG div INI_2MAGIC_DIV_VALUE;
        end;
    end;
  end;

  MagicClass.Calculate_cLifeData(@MagicData); //计算属性
          //输出属性
  str := '';
  with MagicData do
  begin
    str := str + format('名称: %s  ', [rname]);
    str := str + format('等级: %s', [Get10000To100(rcSkillLevel)]) + #13#10;
    if rcLifeData.AttackSpeed > 0 then
      str := str + format('速度: %d  ', [rcLifeData.AttackSpeed]);
    if rcLifeData.recovery > 0 then
      str := str + format('恢复: %d  ', [rcLifeData.recovery]);
    if rcLifeData.avoid > 0 then
      str := str + format('躲闪: %d  ', [rcLifeData.avoid]);
    if rcLifeData.accuracy > 0 then
      str := str + format('命中: %d  ', [rcLifeData.accuracy]);
    if rcLifeData.HitArmor > 0 then
      str := str + format('维持: %d  ', [rcLifeData.HitArmor]);
    if (rcLifeData.damageBody <> 0) or (rcLifeData.damageHead <> 0) or (rcLifeData.damageArm <> 0) or (rcLifeData.damageLeg <> 0) then
      str := str + #13#10 + format('攻击: %d/%d/%d/%d', [rcLifeData.damageBody, rcLifeData.damageHead, rcLifeData.damageArm, rcLifeData.damageLeg]) + #13#10;
    if (rcLifeData.armorBody <> 0) or (rcLifeData.armorHead <> 0) or (rcLifeData.armorArm <> 0) or (rcLifeData.armorLeg <> 0) then
      str := str + format('防御: %d/%d/%d/%d', [rcLifeData.armorBody, rcLifeData.armorHead, rcLifeData.armorArm, rcLifeData.armorLeg]);
  end;

  Result := str;
end;

procedure TMagicClass.ReLoadFromFile;
var
  i: integer;
  mname: string;
  pmd: PTMagicData;
  TempDb: TUserStringDb;
  atemp: TStringList;
begin
  Clear;
  if FileExists('.\Init\AddDamage.SDB') then
  begin
    TempDb := TUserStringDb.Create;
    try
      TempDb.LoadFromFile('.\Init\AddDamage.SDB');
      loadDamage(TempDb);

    finally
      TempDb.Free;
    end;
    atemp := TStringList.Create;
    try
      atemp.LoadFromFile('.\Init\AddDamage.SDB');
      Damagestr := atemp.Text;
    finally
      atemp.Free;
    end;
  end;

  if FileExists('.\Init\AddArmor.SDB') then
  begin
        // 2000.10.05 眠啊规绢仿 AddArmor.sdb 颇老狼 肺靛
    TempDb := TUserStringDb.Create;
    try
      TempDb.LoadFromFile('.\Init\AddArmor.SDB');
      loadArmor(TempDb);
    finally
      TempDb.Free;
    end;
    atemp := TStringList.Create;
    try
      atemp.LoadFromFile('.\Init\AddArmor.SDB');
      Armorstr := atemp.Text;
    finally
      atemp.Free;
    end;
  end;

  if FileExists('.\Init\Magic.SDB') then
  begin
    MagicDb.LoadFromFile('.\Init\Magic.SDB');
    for i := 0 to MagicDb.Count - 1 do
    begin
      mname := MagicDb.GetIndexName(i);
      new(pmd);
      LoadMagicData(mname, pmd^, MagicDb);
      DataList.Add(pmd);
      AnsIndexClass.Insert(mname, (pmd));
    end;
  end;

  if FileExists('.\MagicForGuild.SDB') then
  begin
    MagicForGuildDb.LoadFromFile('.\MagicForGuild.SDB');
    for i := 0 to MagicForGuildDb.Count - 1 do
    begin

      mname := MagicForGuildDb.GetIndexName(i);
      new(pmd);
      LoadMagicData(mname, pmd^, MagicForGuildDb);
      pmd^.rGuildMagictype := 1;
      DataList.Add(pmd);
      AnsIndexClass.Insert(mname, (pmd));
    end;
  end;
end;

function TMagicClass.AddGuildMagic(var aMagicData: TMagicData; aGuildName: string): Boolean;
var
  iName: string;
  iType, iSoundStrike, iSoundSwing: Integer;
  MagicData: TMagicData;
begin
  Result := false;

  iName := (aMagicData.rName);
  MagicForGuildDB.AddName(iName);

  FillChar(MagicData, SizeOf(TMagicData), 0);
  iType := aMagicData.rMagicType;
  case iType of
    MAGICTYPE_WRESTLING:
      begin
        aMagicData.rShape := 1;
        GetMagicData('无名拳法', MagicData, 100);

      end;
    MAGICTYPE_FENCING:
      begin
        aMagicData.rShape := 16;
        GetMagicData('无名剑法', MagicData, 100);
      end;
    MAGICTYPE_SWORDSHIP:
      begin
        aMagicData.rShape := 32;
        GetMagicData('无名刀法', MagicData, 100);
      end;
    MAGICTYPE_HAMMERING:
      begin
        aMagicData.rShape := 64;
        GetMagicData('无名槌法', MagicData, 100);
      end;
    MAGICTYPE_SPEARING:
      begin
        aMagicData.rShape := 48;
        GetMagicData('无名枪术', MagicData, 100);
      end;
  end;
  if MagicData.rname = '' then exit;
  aMagicData.rEffectColor := MagicData.rEffectColor;

  iSoundSwing := MagicData.rSoundSwing.rWavNumber;
  iSoundStrike := MagicData.rSoundStrike.rWavNumber;

  MagicForGuildDB.SetFieldValueString(iName, 'SoundEvent', '');
  MagicForGuildDB.SetFieldValueString(iName, 'SoundStrike', IntToStr(iSoundStrike));
  MagicForGuildDB.SetFieldValueString(iName, 'SoundSwing', IntToStr(iSoundSwing));
  MagicForGuildDB.SetFieldValueString(iName, 'SoundStart', '');
  MagicForGuildDB.SetFieldValueString(iName, 'SoundEnd', '');
  MagicForGuildDB.SetFieldValueInteger(iName, 'Shape', aMagicData.rShape);
  MagicForGuildDB.SetFieldValueInteger(iName, 'MagicType', aMagicData.rMagicType);
  MagicForGuildDB.SetFieldValueInteger(iName, 'EffectColor', aMagicData.rEffectColor);

  MagicForGuildDB.SetFieldValueInteger(iName, 'Function', 0);
  MagicForGuildDB.SetFieldValueInteger(iName, 'AttackSpeed', aMagicData.rLifeData.AttackSpeed);
  MagicForGuildDB.SetFieldValueInteger(iName, 'Recovery', aMagicData.rLifeData.Recovery);
  MagicForGuildDB.SetFieldValueInteger(iName, 'Avoid', aMagicData.rLifeData.Avoid);
  MagicForGuildDB.SetFieldValueInteger(iName, 'DamageBody', aMagicData.rLifeData.DamageBody);
  MagicForGuildDB.SetFieldValueInteger(iName, 'DamageHead', aMagicData.rLifeData.DamageHead);
  MagicForGuildDB.SetFieldValueInteger(iName, 'DamageArm', aMagicData.rLifeData.DamageArm);
  MagicForGuildDB.SetFieldValueInteger(iName, 'DamageLeg', aMagicData.rLifeData.DamageLeg);
  MagicForGuildDB.SetFieldValueInteger(iName, 'ArmorBody', aMagicData.rLifeData.ArmorBody);
  MagicForGuildDB.SetFieldValueInteger(iName, 'ArmorHead', aMagicData.rLifeData.ArmorHead);
  MagicForGuildDB.SetFieldValueInteger(iName, 'ArmorArm', aMagicData.rLifeData.ArmorArm);
  MagicForGuildDB.SetFieldValueInteger(iName, 'ArmorLeg', aMagicData.rLifeData.ArmorLeg);

  MagicForGuildDB.SetFieldValueInteger(iName, 'eEnergy', aMagicData.rEventDecEnergy);
  MagicForGuildDB.SetFieldValueInteger(iName, 'eInPower', aMagicData.rEventDecInPower);
  MagicForGuildDB.SetFieldValueInteger(iName, 'eOutPower', aMagicData.rEventDecOutPower);
  MagicForGuildDB.SetFieldValueInteger(iName, 'eMagic', aMagicData.rEventDecMagic);
  MagicForGuildDB.SetFieldValueInteger(iName, 'eLife', aMagicData.rEventDecLife);

  MagicForGuildDB.SetFieldValueString(iName, 'GuildName', aGuildName);

  MagicForGuildDB.SetFieldValueInteger(iName, 'kEnergy', 10);
  MagicForGuildDB.SetFieldValueInteger(iName, 'kInPower', 10);
  MagicForGuildDB.SetFieldValueInteger(iName, 'kOutPower', 10);
  MagicForGuildDB.SetFieldValueInteger(iName, 'kMagic', 10);
  MagicForGuildDB.SetFieldValueInteger(iName, 'kLife', 10);

  MagicForGuildDB.SaveToFile('.\MagicForGuild.SDB');

  ReloadFromFile;

  Result := true;
end;

function TMagicClass.GetHaveMagicString(var MagicData: TMagicData): string;
begin
  Result := (MagicData.rName) + ':' + IntToStr(MagicData.rSkillExp) + ':';
end;

function TMagicClass.GetHaveMagicData(astr: string; var MagicData: TMagicData): Boolean;
var
  str, rdstr, amagicname: string;
  sexp: integer;
begin
  Result := FALSE;
  str := astr;
  str := GetValidStr3(str, amagicname, ':');
  str := GetValidStr3(str, rdstr, ':');
  sexp := _StrToInt(rdstr);
  if GetMagicData(amagicname, MagicData, sexp) = FALSE then exit;
  Result := TRUE;
end;

procedure TMagicClass.CompactGuildMagic;
var
  i: Integer;
  MagicName, GuildName: string;
  GuildObject: TGuildObject;
begin
  if MagicForGuildDB.Count = 0 then exit;

  for i := MagicForGuildDB.Count - 1 downto 0 do
  begin
    MagicName := MagicForGuildDb.GetIndexName(i);
    if MagicName = '' then continue;

    GuildName := MagicForGuildDB.GetFieldValueString(MagicName, 'GuildName');
    GuildObject := GuildList.GetGuildObjectByMagicName(MagicName);
    if GuildObject = nil then
    begin
      MagicForGuildDB.DeleteName(MagicName);
    end
    else
    begin
      MagicForGuildDB.SetFieldValueString(MagicName, 'GuildName', GuildObject.GuildName);
    end;
  end;

  MagicForGuildDB.SaveToFile('.\MagicForGuild.SDB');

  ReloadFromFile;
end;

procedure TMagicClass.DelGuildMagic(astr: string);
var
  i: Integer;
  MagicName, GuildName: string;
  GuildObject: TGuildObject;
begin
  if MagicForGuildDB.Count = 0 then exit;
  for i := MagicForGuildDB.Count - 1 downto 0 do
  begin
    MagicName := MagicForGuildDb.GetIndexName(i);
    if MagicName = astr then
    begin
      MagicForGuildDB.DeleteName(MagicName);
      Break;
    end;
  end;
  MagicForGuildDB.SaveToFile('.\MagicForGuild.SDB');
  ReloadFromFile;
end;

constructor TMagicClass.Create;
begin
  inherited Create;
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('MagicClass', 20, TRUE);
  MagicDb := TUserStringDb.Create;
  MagicForGuildDb := TUserStringDb.Create;
  ReLoadFromFile;
end;

procedure TMagicClass.Clear;
var
  i: integer;
begin
  inherited Clear;
  for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
  DataList.Clear;
  AnsIndexClass.Clear;
  Armorstr := '';
  Damagestr := '';
end;

destructor TMagicClass.Destroy;
begin
  Clear;
  MagicForGuildDb.Free;
  MagicDb.Free;
  DataList.Free;
  AnsIndexClass.Free;
  inherited Destroy;
end;

// TMagicParamClass

constructor TMagicParamClass.Create;
begin
  DataList := TList.Create;
  KeyClass := TStringKeyClass.Create;

  LoadFromFile('.\Init\MagicParam.SDB');
end;

destructor TMagicParamClass.Destroy;
begin
  Clear;
  KeyClass.Free;
  DataList.Free;

  inherited Destroy;
end;

procedure TMagicParamClass.Clear;
var
  i: Integer;
  pd: PTMagicParamData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    Dispose(pd);
  end;
  DataList.Clear;
  KeyClass.Clear;
end;

function TMagicParamClass.LoadFromFile(aFileName: string): Boolean;
var
  i, j: Integer;
  iName: string;
  pd: PTMagicParamData;
  DB: TUserStringDB;
begin
  Result := false;

  if not FileExists(aFileName) then exit;

  DB := TUserStringDB.Create;
  DB.LoadFromFile(aFileName);

  for i := 0 to DB.Count - 1 do
  begin
    iName := DB.GetIndexName(i);
    if iName = '' then continue;

    New(pd);
    FillChar(pd^, SizeOf(TMagicParamData), 0);

    pd^.ObjectName := DB.GetFieldValueString(iName, 'ObjectName');
    pd^.MagicName := DB.GetFieldValueString(iName, 'MagicName');
    for j := 0 to 5 - 1 do
    begin
      pd^.NameParam[j] := DB.GetFieldValueString(iName, 'NameParam' + IntToStr(j + 1));
    end;
    for j := 0 to 5 - 1 do
    begin
      pd^.NumberParam[j] := DB.GetFieldValueInteger(iName, 'NumberParam' + IntToStr(j + 1));
    end;

    KeyClass.Insert(pd^.ObjectName + pd^.MagicName, pd);
    DataList.Add(pd);
  end;

  DB.Free;

  Result := true;
end;

function TMagicParamClass.GetMagicParamData(aObjectName, aMagicName: string; var aMagicParamData: TMagicParamData): Boolean;
var
  pd: PTMagicParamData;
begin
  Result := false;

  pd := KeyClass.Select(aObjectName + aMagicName);
  if pd = nil then
  begin
    FillChar(aMagicParamData, SizeOf(TMagicParamData), 0);
    exit;
  end;

  Move(pd^, aMagicParamData, SizeOf(TMagicParamData));

  Result := true;
end;

function TMagicParamClass.Add(oName, mName: string; apara: TMagicParamData; aid: integer): Boolean;
var
  i, j: Integer;
  pd: PTMagicParamData;
begin
  Result := false;
  begin
    New(pd);
    FillChar(pd^, SizeOf(TMagicParamData), 0);

    pd^.ObjectName := oName;
    pd^.MagicName := mName;
    for j := 0 to 5 - 1 do
    begin
      pd^.NameParam[j] := apara.NameParam[j];
    end;
    for j := 0 to 5 - 1 do
    begin
      pd^.NumberParam[j] := apara.NumberParam[j];
    end;

    KeyClass.Insert(pd^.ObjectName + pd^.MagicName + '_' + IntToStr(aid), pd);
    DataList.Add(pd);
  end;
  Result := true;
end;

{
const
   MAGIC_DIV_VALUE      = 10;

   ADD_DAMAGE           = 40;

   MUL_ATTACKSPEED      = 10;
   MUL_AVOID            = 6;
   MUL_RECOVERY         = 10;
   MUL_DAMAGEBODY       = 23;
   MUL_DAMAGEHEAD       = 17;
   MUL_DAMAGEARM        = 17;
   MUL_DAMAGELEG        = 17;
   MUL_ARMORBODY        = 7;
   MUL_ARMORHEAD        = 7;
   MUL_ARMORARM         = 7;
   MUL_ARMORLEG         = 7;

   MUL_EVENTENERGY      = 20;
   MUL_EVENTINPOWER     = 22;
   MUL_EVENTOUTPOWER    = 22;
   MUL_EVENTMAGIC       = 10;
   MUL_EVENTLIFE        = 8;

   MUL_5SECENERGY       = 20;
   MUL_5SECINPOWER      = 14;
   MUL_5SECOUTPOWER     = 14;
   MUL_5SECMAGIC        = 9;
   MUL_5SECLIFE         = 8;
}

{ TAttachClass }



procedure TAttachClass.clear;
var
  j: integer;
  p: pTLifeData;
begin
  for j := 0 to high(FDataArr) do
  begin
    p := FDataArr[j];
    if p <> nil then dispose(p);
    FDataArr[j] := nil;
  end;
end;


constructor TAttachClass.Create(amaxindex: integer);
begin
  setlength(FDataArr, amaxindex);
  fillchar(FDataArr[0], (high(FDataArr) + 1) * 4, 0);
end;

destructor TAttachClass.Destroy;
begin
  clear;
  setlength(FDataArr, 0);
  inherited;
end;

function TAttachClass.get(aindex: integer): TLifeData;
begin
  if (aindex < 0) or (aindex > high(FDataArr)) then
  begin
    fillchar(result, sizeof(Result), 0);
    exit;
  end;
  if FDataArr[aindex] = nil then
  begin
    fillchar(result, sizeof(Result), 0);
    exit;
  end;
  Result := FDataArr[aindex]^;
end;

procedure TAttachClass.ReLoadFromFile(aItemClass: TItemLifeDataClass);
var
  j: integer;
  str: string;
  aitem: TItemLifeData;
  p: pTLifeData;
begin
  clear;
  //j:= high(FDataArr);
 // MessageBox(0,PChar(IntToStr(j)),'',0);
  for j := 0 to high(FDataArr) do
  begin
    new(p);
    FDataArr[j] := p;
    str := format('X附加%d', [j]);
    aItemClass.GetItemData(str, aitem);
    p^ := aitem.LifeData;

  end;
end;
///////////////////////////////////
//         TItemClass
///////////////////////////////////
{ TItemClass }



constructor TItemClass.Create;
begin

  Job_Material1 := tstringList.Create;
  Job_Material2 := tstringList.Create;
  Job_Material3 := tstringList.Create;
  Job_Material4 := tstringList.Create;
  ItemDb := TUserStringDb.Create;
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('ItemClass', 20, TRUE);
  ItemTextClass := TStringKeyListClass.Create;
  ReLoadFromFile;
end;



destructor TItemClass.Destroy;
begin

  Clear;

  Job_Material1.Free;
  Job_Material2.Free;
  Job_Material3.Free;
  Job_Material4.Free;
  AnsIndexClass.Free;
  ItemTextClass.Free;
  DataList.Free;
  ItemDb.Free;
  inherited Destroy;
end;

procedure TItemClass.Clear;
var
  i: integer;
  p: pTitemTextdata;
begin
  for i := 0 to ItemTextClass.Count - 1 do
  begin
    p := ItemTextClass.GetIndex(i);
    dispose(p);
  end;
  ItemTextClass.Clear;
  for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
  DataList.Clear;
  AnsIndexClass.Clear;

  Job_Material1.Clear;
  Job_Material2.Clear;
  Job_Material3.Clear;
  Job_Material4.Clear;
  Job_Material1.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
  Job_Material2.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
  Job_Material3.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
  Job_Material4.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
end;

procedure TItemClass.JOb_add(var aitem: titemdata);
var
  str: string;
  i: integer;
begin
  if aitem.rboJobDown = false then exit;
  case aitem.rjobKind of
    1, 2, 3, 4: ;
  else exit;
  end;
  str := '';
    //物品名字
  str := str + aitem.rName + ',';
    //图像
  str := str + inttostr(aitem.rShape) + ',';
    //品
  str := str + inttostr(aitem.rGrade) + ',';
  for i := 0 to 4 - 1 do
  begin
    //材料名字
    str := str + aitem.rMaterial.nameArr[i] + ',';
    //材料数量
    str := str + inttostr(aitem.rMaterial.countArr[i]) + ',';
  end;

  case aitem.rjobKind of
    1: Job_Material1.Add(str);
    2: Job_Material2.Add(str);
    3: Job_Material3.Add(str);
    4: Job_Material4.Add(str);
  else exit;
  end;


end;

procedure TItemClass.ReLoadFromFile;
var
  i: integer;
  iName: string;
  pid: PTItemData;
//    tempitem: titemdata;
begin

  Clear;
  if not FileExists('.\Init\Item.SDB') then exit;

  ItemDb.LoadFromFile('.\Init\Item.SDB');
  for i := 0 to ItemDb.Count - 1 do
  begin
    iName := ItemDb.GetIndexName(i);
    New(pid);
    LoadItemData(iName, pid^);
    DataList.Add(pid);
    AnsIndexClass.Insert(iname, (pid));



  end;

end;

function TItemClass.getdesc(aname: string): string;
var
  pp: pTitemTextdata;
begin
  result := '';
  pp := ItemTextClass.Select(aname);
  if pp = nil then exit;
  result := pp.rdesc;
end;

function TItemClass.CallScriptFunction(const aScript, Name: string; const Params: array of const): integer;
var
  FScriptClass: TPaxScripter;
begin
  result := 0;
  if aScript = '' then exit;
  if ScripterList.GetScripter(aScript, FScriptClass) = false then FScriptClass := nil;
  if FScriptClass <> nil then
  begin
    if FScriptClass.GetMemberID(Name) <> 0 then
      result := FScriptClass.CallFunction(Name, Params);
  end;
end;

function TItemClass.CallLuaScriptFunction(const aScript, Name: string; const Params: array of const): string;
var
  FBaseLua: TLua; //lua脚本
  I: Integer;
  vi: Integer;
  vas: string;
  vd: Double;
begin
  if aScript = '' then exit;
  if LuaScripterList.GetScripter(aScript, FBaseLua) = false then FBaseLua := nil;
  if FBaseLua <> nil then
  begin
    lua_pcall(FBaseLua.LuaInstance, 0, 0, 0);
    lua_getglobal(FBaseLua.LuaInstance, PChar(Name));

    for i := 0 to Length(Params) - 1 do
    begin
   // showmessage(Params[i].VType);
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
  end;
end;


procedure TItemClass.LoadScript(aScript, afilename: string);
begin
  if aScript = '' then exit;

  if ScripterList.IsScripter(aScript) = false then
    ScripterList.LoadFile(aScript, afilename);


end;

procedure TItemClass.LoadLuaScript(aScript, afilename: string);
var
  FBaseLua: TLua; //lua脚本
begin
  if aScript = '' then exit;

  if not FileExists(afilename) then
    Exit;

  if LuaScripterList.IsScripter(aScript) = false then
  begin
    FBaseLua := TLua.Create(false);
    try
      luaL_openlibs(FBaseLua.LuaInstance);
      Lua_GroupScripteRegister(FBaseLua.LuaInstance); //NPC说话
      if FBaseLua.DoFile(afilename) <> 0 then
        frmMain.WriteLogInfo(format('Lua脚本错误 方法: %s f: %s', [afilename, lua_tostring(FBaseLua.LuaInstance, -1)]));
      LuaScripterList.LoadFile(aScript, afilename, FBaseLua);
    finally
       // FBaseLua.Free;          //2015.11.10 在水一方 内存泄露006
    end;
  end;

end;


function TItemClass.LoadItemData(aItemName: string; var ItemData: TItemData): Boolean;
var
  mName, mcount, Str: string;
  pp: pTitemTextdata;
  i: integer;
  boMaterial: boolean;
  tempMaterial_p: ptMaterialdata;
begin
  Result := FALSE;
  boMaterial := false;
  FillChar(ItemData, sizeof(ItemData), 0);
  if ItemDb.GetDbString(aItemName) = '' then exit;

  ItemData.rname := aItemName;
  Str := ItemDB.GetFieldValueString(aItemName, 'desc');
    //物品描述 列表
  if ItemTextClass.Select(aItemName) = nil then
  begin
    new(pp);
    pp.rname := aItemName;
    pp.rdesc := copy(str, 1, 255);
    ItemTextClass.Insert(pp.rname, pp);
  end;

  Str := ItemDB.GetFieldValueString(aItemName, 'ViewName');
  ItemData.rViewName := Str;
  Itemdata.rNameColor := ItemDb.GetFieldValueinteger(aItemName, 'NameColor');
  Itemdata.rjobKind := ItemDb.GetFieldValueinteger(aItemName, 'jobKind');
  Itemdata.rSpecialKind := ItemDb.GetFieldValueinteger(aItemName, 'SpecialKind');
  Itemdata.rcLife := ItemDb.GetFieldValueinteger(aItemName, 'cLife');
  Itemdata.rboJobDown := ItemDb.GetFieldValueBoolean(aItemName, 'boJobDown');
  Itemdata.rQuestNum := ItemDb.GetFieldValueinteger(aItemName, 'QuestNum');
  Itemdata.rboQuestProcession := ItemDb.GetFieldValueBoolean(aItemName, 'boQuestProcession');
  Itemdata.rMix := ItemDb.GetFieldValueString(aItemName, 'Mix');
  Itemdata.rNeedEnergyLevel := ItemDb.GetFieldValueInteger(aItemName, 'NeedEnergyLevel');


  Itemdata.rRepairPrice := ItemDb.GetFieldValueinteger(aItemName, 'RepairPrice');

  StrToEffectData(ItemData.rSoundEvent, ItemDb.GetFieldValueString(aItemName, 'SoundEvent'));
  StrToEffectData(ItemData.rSoundDrop, ItemDb.GetFieldValueString(aItemName, 'SoundDrop'));

  Itemdata.rMaxCount := ItemDb.GetFieldValueinteger(aItemName, 'MaxCount'); //新(最大持有数量)

  Itemdata.rLifeDataBasic.DamageBody := ItemDb.GetFieldValueinteger(aItemName, 'DamageBody');
  Itemdata.rLifeDataBasic.DamageHead := ItemDb.GetFieldValueinteger(aItemName, 'DamageHead');
  Itemdata.rLifeDataBasic.DamageArm := ItemDb.GetFieldValueinteger(aItemName, 'DamageArm');
  Itemdata.rLifeDataBasic.DamageLeg := ItemDb.GetFieldValueinteger(aItemName, 'DamageLeg');

  Itemdata.rLifeDataBasic.ArmorBody := ItemDb.GetFieldValueinteger(aItemName, 'ArmorBody');
  Itemdata.rLifeDataBasic.ArmorHead := ItemDb.GetFieldValueinteger(aItemName, 'ArmorHead');
  Itemdata.rLifeDataBasic.ArmorArm := ItemDb.GetFieldValueinteger(aItemName, 'ArmorArm');
  Itemdata.rLifeDataBasic.ArmorLeg := ItemDb.GetFieldValueinteger(aItemName, 'ArmorLeg');


  Itemdata.rLifeDataBasic.AttackSpeed := 0 - ItemDb.GetFieldValueinteger(aItemName, 'AttackSpeed');
  Itemdata.rLifeDataBasic.Recovery := 0 - ItemDb.GetFieldValueinteger(aItemName, 'Recovery');
  Itemdata.rLifeDataBasic.Avoid := ItemDb.GetFieldValueinteger(aItemName, 'Avoid');
  Itemdata.rLifeDataBasic.accuracy := ItemDb.GetFieldValueinteger(aItemName, 'accuracy');
  Itemdata.rLifeDataBasic.HitArmor := ItemDb.GetFieldValueinteger(aItemName, 'KeepRecovery');
  Itemdata.rLifeData := Itemdata.rLifeDataBasic;
    //rLifeDataSuit
  Itemdata.rLifeDataSuit.DamageBody := ItemDb.GetFieldValueinteger(aItemName, 'sDamageBody');
  Itemdata.rLifeDataSuit.DamageHead := ItemDb.GetFieldValueinteger(aItemName, 'sDamageHead');
  Itemdata.rLifeDataSuit.DamageArm := ItemDb.GetFieldValueinteger(aItemName, 'sDamageArm');
  Itemdata.rLifeDataSuit.DamageLeg := ItemDb.GetFieldValueinteger(aItemName, 'sDamageLeg');

  Itemdata.rLifeDataSuit.ArmorBody := ItemDb.GetFieldValueinteger(aItemName, 'sArmorBody');
  Itemdata.rLifeDataSuit.ArmorHead := ItemDb.GetFieldValueinteger(aItemName, 'sArmorHead');
  Itemdata.rLifeDataSuit.ArmorArm := ItemDb.GetFieldValueinteger(aItemName, 'sArmorArm');
  Itemdata.rLifeDataSuit.ArmorLeg := ItemDb.GetFieldValueinteger(aItemName, 'sArmorLeg');

  Itemdata.rLifeDataSuit.AttackSpeed := 0 - ItemDb.GetFieldValueinteger(aItemName, 'sAttackSpeed');
  Itemdata.rLifeDataSuit.Recovery := 0 - ItemDb.GetFieldValueinteger(aItemName, 'sRecovery');
  Itemdata.rLifeDataSuit.Avoid := ItemDb.GetFieldValueinteger(aItemName, 'sAvoid');
  Itemdata.rLifeDataSuit.accuracy := ItemDb.GetFieldValueinteger(aItemName, 'saccuracy');


  Itemdata.rSuitId := ItemDb.GetFieldValueinteger(aItemName, 'SuitId');

    //关开
  ItemData.MaxUpgrade := ItemDb.GetFieldValueinteger(aItemName, 'MaxUpgrade'); //新 (最大升级别)
  ItemData.SuccessRate := ItemDb.GetFieldValueinteger(aItemName, 'SuccessRate'); //成功率

  Itemdata.boUpgrade := ItemDb.GetFieldValueBoolean(aItemName, 'boUpgrade'); //新 (允许升级)
  Itemdata.rboNotTrade := ItemDb.GetFieldValueBoolean(aItemName, 'boNotTrade'); //新(允许交易)
  Itemdata.rboNotExchange := ItemDb.GetFieldValueBoolean(aItemName, 'boNotExchange'); //新(允许交换)
  Itemdata.rboNotDrop := ItemDb.GetFieldValueBoolean(aItemName, 'boNotDrop'); //新(允许丢在地上)
  Itemdata.rboNotSSamzie := ItemDb.GetFieldValueBoolean(aItemName, 'boNotSSamzie'); //新(允许放在福袋)
  ItemData.rboLOG := ItemDb.GetFieldValueBoolean(aItemName, 'boLOG'); //新
  Itemdata.rboTimeMode := ItemDb.GetFieldValueBoolean(aItemName, 'boTimeMode'); //新 时间模式 每秒消耗
  Itemdata.rboDurability := ItemDb.GetFieldValueBoolean(aItemName, 'boDurability'); //新(打击消耗持久)
  ItemData.rboNOTRepair := ItemDb.GetFieldValueBoolean(aItemName, 'boNOTRepair'); //新 可维修
  ItemData.rboSetting := ItemDb.GetFieldValueBoolean(aItemName, 'boSetting'); //
  ItemData.rboident := (ItemDb.GetFieldValueBoolean(aItemName, 'boident')); //是否可鉴定
  ItemData.rboExplosion := (ItemDb.GetFieldValueBoolean(aItemName, 'boExplosion'));

//    ItemData.rboQuest := (ItemDb.GetFieldValueBoolean(aItemName, 'boQuest'));   // 任务装备 物品 过地图 就自动删除
  ItemData.rboBlueprint := (ItemDb.GetFieldValueBoolean(aItemName, 'boBlueprint')); //
//    ItemData.rboPrestige := (ItemDb.GetFieldValueBoolean(aItemName, 'boPrestige')); //


  Itemdata.rDurability := ItemDb.GetFieldValueinteger(aItemName, 'Durability');
  Itemdata.rDecSize := ItemDb.GetFieldValueinteger(aItemName, 'DecSize'); //新 DecSize(损坏大小) 每次磨损几点耐久

  Itemdata.rCurDurability := Itemdata.rDurability;

  ItemData.rWearArr := ItemDb.GetFieldValueinteger(aItemName, 'WearPos');
  ItemData.rWearShape := ItemDb.GetFieldValueinteger(aItemName, 'WearShape');
  ItemData.rShape := ItemDb.GetFieldValueinteger(aItemName, 'Shape');
  ItemData.rActionImage := ItemDb.GetFieldValueInteger(aItemName, 'ActionImage');
  ItemData.rHitMotion := ItemDb.GetFieldValueinteger(aItemName, 'HitMotion');
  ItemData.rHitType := ItemDb.GetFieldValueinteger(aItemName, 'HitType');
  ItemData.rKind := ItemDb.GetFieldValueinteger(aItemName, 'Kind');
  ItemData.rSpecialKind := ItemDb.GetFieldValueinteger(aItemName, 'SpecialKind');
  ItemData.rColor := ItemDb.GetFieldValueinteger(aItemName, 'Color');
  ItemData.rBoDouble := ItemDb.GetFieldValueBoolean(aItemName, 'boDouble');
  ItemData.rBoColoring := ItemDb.GetFieldValueBoolean(aItemName, 'boColoring');
  ItemData.rPrice := ItemDb.GetFieldValueInteger(aItemName, 'Price');
  ItemData.rNeedGrade := ItemDb.GetFieldValueInteger(aItemName, 'NeedGrade');
  ItemData.rSex := (ItemDb.GetFieldValueInteger(aItemName, 'Sex'));
  ItemData.rDecDelay := (ItemDb.GetFieldValueInteger(aItemName, 'DecDelay'));




  ItemData.rAttribute := (ItemDb.GetFieldValueInteger(aItemName, 'Attribute'));

  str := ItemDb.GetFieldValueString(aItemName, 'WeaponLevelColor');
  ItemData.rWeaponLevelColor_PP := WeaponLevelColorClass.get(STR);

  str := ItemDb.GetFieldValueString(aItemName, 'NeedItem');
  if str <> '' then
  begin
    str := GetValidStr3(str, mName, ':');
    str := GetValidStr3(str, mCount, ':');
    if (mName <> '') and (mCount <> '') then
    begin
      ItemData.rNeedItem := copy(mName, 1, 20);
      ItemData.rNeedItemCount := _StrToInt(mcount);

    end;
  end;

  str := (ItemDb.GetFieldValueString(aItemName, 'DelItem'));
  if str <> '' then
  begin
    str := GetValidStr3(str, mName, ':');
    str := GetValidStr3(str, mCount, ':');
    if (mName <> '') and (mCount <> '') then
    begin
      ItemData.rDelItem := copy(mName, 1, 20);
      ItemData.rDelItemCount := _StrToInt(mcount);
    end;
  end;
  str := (ItemDb.GetFieldValueString(aItemName, 'AddItem'));
  if str <> '' then
  begin
    str := GetValidStr3(str, mName, ':');
    str := GetValidStr3(str, mCount, ':');
    if (mName <> '') and (mCount <> '') then
    begin
      ItemData.rAddItem := copy(mName, 1, 20);
      ItemData.rAddItemCount := _StrToInt(mcount);
    end;
  end;

  //拥有该物品将无法拾取物品
  str := (ItemDb.GetFieldValueString(aItemName, 'NotHaveItem'));
  for i := 0 to high(ItemData.rNotHaveItem) do
  begin
    if str = '' then break;
    str := GetValidStr3(str, mName, ':');
    if mName = '' then break;
    str := GetValidStr3(str, mCount, ':');
    ItemData.rNotHaveItem[i].rName := copy(mName, 1, 20);
    ItemData.rNotHaveItem[i].rCount := _StrToInt(mcount);
  end;

  ItemData.rGrade := (ItemDb.GetFieldValueInteger(aItemName, 'Grade'));
  ItemData.rStarLevel := 0; // (ItemDb.GetFieldValueInteger(aItemName, 'StarLevel'));
  ItemData.rStarLevelMax := ItemDb.GetFieldValueInteger(aItemName, 'StarLevelMax');
  str := ItemDb.GetFieldValueString(aItemName, 'Material');
  if str <> '' then
  begin
   { if aItemName='溶华素' then
    aItemName:=aItemName;
        if aItemName='白龙剑' then
    aItemName:=aItemName;    }
    tempMaterial_p := MaterialClass.get(str);
    if tempMaterial_p <> nil then
    begin
      ItemData.rMaterial := tempMaterial_p^;
      boMaterial := true;
    end;
  end;
    //
    {for i := 0 to high(ItemData.rMaterial.namearr) do
    begin
        if str = '' then break;
        str := GetValidStr3(str, mName, ':');
        if mName = '' then break;
        str := GetValidStr3(str, mCount, ':');
        ItemData.MaterialArr[i].rname := copy(mName, 1, 20);
        ItemData.MaterialArr[i].rcount := _StrToInt(mcount);
        boMaterial := true;
    end;
    }
  ItemData.rNameParam[0] := ItemDb.GetFieldValueString(aItemName, 'NameParam1');
  ItemData.rNameParam[1] := ItemDb.GetFieldValueString(aItemName, 'NameParam2');
  ItemData.rDateTimeSec := ItemDb.GetFieldValueinteger(aItemName, 'DateTimeSec');
  ItemData.rServerId := ItemDb.GetFieldValueInteger(aItemName, 'ServerId');
  ItemData.rx := ItemDb.GetFieldValueInteger(aItemName, 'X');
  ItemData.ry := ItemDb.GetFieldValueInteger(aItemName, 'Y');

  ItemData.rScripter := ItemDb.GetFieldValueString(aItemName, 'Scripter');

  ItemData.rdiePunish := ItemDb.GetFieldValueInteger(aItemName, 'diePunish');
  ItemData.rRandomCount := ItemDb.GetFieldValueInteger(aItemName, 'RandomCount');

  ItemData.rCount := 1;

  ItemData.rSmithingLevel := 0; //新 装备等级
  ItemData.rAttach := 0; //新 附加属性
  ItemData.rlockState := 0; //新 物品锁状态
  ItemData.rlocktime := 0; //新 解锁状态 时间
  ItemData.rTradeMoneyName := ItemDb.GetFieldValueString(aItemName, 'TradeMoneyName');
  if boMaterial then JOb_add(ItemData);
  Result := TRUE;
  //LoadScript(ItemData.rScripter, format('.\%s\%s\%s.pas', ['Script', 'Item', ItemData.rScripter]));
  LoadLuaScript(ItemData.rScripter, format('.\%s\%s\%s\%s.lua', ['Script', 'Lua', 'Item', ItemData.rScripter]));
end;

function TItemClass.GetItemData(aItemName: string; var ItemData: TItemData): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aItemName);
    // if (n = 0) or (n = -1) then
  if n = nil then
  begin
    FillChar(ItemData, sizeof(ItemData), 0);
    exit;
  end;
  ItemData := PTItemData(n)^;

  Result := TRUE;
end;

function TItemClass.GetCheckItemData(aObjName: string; aCheckItem: TCheckItem; var ItemData: TItemData; aName: string = ''): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aCheckItem.rName);
    //if (n = 0) or (n = -1) then
  if n = nil then
  begin
    FillChar(ItemData, sizeof(ItemData), 0);
    exit;
  end;
  if RandomClass.GetChance(aCheckItem.rName, aObjName, aName) = false then
  begin
    FillChar(ItemData, sizeof(ItemData), 0);
    exit;
  end;

  ItemData := PTItemData(n)^;
  ItemData.rCount := aCheckItem.rCount;

  Result := TRUE;
end;

function TItemClass.GetChanceItemData(aStr, aObjName: string; var ItemData: TItemData): Boolean;
var
  str, rdstr, iname: string;
  icolor, icnt: integer;
  boChance: Boolean;
begin
  Result := FALSE;

  str := astr;

  str := GetValidStr3(str, iname, ':');
  str := GetValidStr3(str, rdstr, ':');
  icolor := _StrToInt(rdstr);
  str := GetValidStr3(str, rdstr, ':');
  icnt := _StrToInt(rdstr);

  if GetItemData(iName, ItemData) = FALSE then exit;

  boChance := RandomClass.GetChance(iName, aObjName);
  if boChance = false then
  begin
    FillChar(ItemData, sizeof(TItemData), 0);
    exit;
  end else
  begin
    ItemData.rColor := iColor;
    ItemData.rCount := iCnt;
  end;

  Result := TRUE;
end;

function TItemClass.GetWearItemData(astr: string; var ItemData: TItemData): Boolean;
var
  str, rdstr, iname: string;
  icolor, icnt: integer;
begin
  Result := FALSE;

  str := astr;

  str := GetValidStr3(str, iname, ':');
  str := GetValidStr3(str, rdstr, ':');
  icolor := _StrToInt(rdstr);
  str := GetValidStr3(str, rdstr, ':');
  icnt := _StrToInt(rdstr);

  if GetItemData(iname, ItemData) = FALSE then exit;
  ItemData.rColor := icolor;
  ItemData.rCount := icnt;
  Result := TRUE;
end;

function TItemClass.GetWearItemString(var ItemData: TItemData): string;
begin
  Result := (ItemData.rName) + ':' + IntToStr(ItemData.rcolor) + ':' + IntToStr(ItemData.rCount) + ':';
end;

///////////////////////////////
// TDynamicObjectClass
///////////////////////////////

constructor TDynamicObjectClass.Create;
begin
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('DynamicItemClass', 20, TRUE);
  LoadFromFile('.\Init\DynamicObject.Sdb');
end;

destructor TDynamicObjectClass.Destroy;
begin
  Clear;
  AnsIndexClass.Free;
  DataList.Free;

  inherited Destroy;
end;

procedure TDynamicObjectClass.Clear;
var
  i: integer;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Dispose(DataList[i]);
  end;
  DataList.Clear;
  AnsIndexClass.Clear;
end;

function TDynamicObjectClass.GetDynamicObjectData(aObjectName: string; var aObjectData: TDynamicObjectData): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aObjectName);
    //  if (n = 0) or (n = -1) then
  if n = nil then
  begin
    FillChar(aObjectData, sizeof(TDynamicObjectData), 0);
    exit;
  end;
  aObjectData := PTDynamicObjectData(n)^;
  Result := TRUE;
end;

procedure TDynamicObjectClass.RELoadFromFile;
begin
  LoadFromFile('.\Init\DynamicObject.Sdb');
end;

procedure TDynamicObjectClass.LoadFromFile(aName: string);
var
  i, j, j1: integer;
  iName, Str, rdStr: string;
  xx, yy: Word;
  StrDB: TUserStringDb;
  pd: PTDynamicObjectData;
begin
  Clear;

  if not FileExists(aName) then exit;

  StrDB := TUserStringDb.Create;
  StrDB.LoadFromFile(aName);
  for i := 0 to StrDb.Count - 1 do
  begin
    iName := StrDb.GetIndexName(i);
    if iName = '' then continue;

    New(pd);
    FillChar(pd^, SizeOf(TDynamicObjectData), 0);

    pd^.rName := StrDB.GetFieldValueString(iName, 'Name');
    pd^.rViewName := StrDB.GetFieldValueString(iName, 'ViewName');
    pd^.rKind := StrDB.GetFieldValueInteger(iName, 'Kind');
    pd^.rShape := StrDB.GetFieldValueInteger(iName, 'Shape');
    pd^.rLife := StrDB.GetFieldValueInteger(iName, 'Life');
    pd^.rScripter := StrDB.GetFieldValueString(iName, 'Scripter');
    pd^.rStepCount := StrDB.GetFieldValueInteger(iName, 'StepCount');

    pd^.rDamage := StrDB.GetFieldValueInteger(iName, 'Damage');
    pd^.rArmor := StrDB.GetFieldValueInteger(iName, 'Armor');
    for j := 0 to 3 - 1 do
    begin
      str := StrDB.GetFieldValueString(iName, 'SStep' + IntToStr(j));
      for j1 := 0 to 5 - 1 do
      begin
        if str = '' then break;
        Str := GetValidStr3(Str, rdStr, ':');
        if rdStr = '' then break;
        pd^.rSStep[j, j1] := _StrToInt(rdStr);
      end;
      str := StrDB.GetFieldValueString(iName, 'EStep' + IntToStr(j));
      for j1 := 0 to 5 - 1 do
      begin
        if str = '' then break;
        Str := GetValidStr3(Str, rdStr, ':');
        if rdStr = '' then break;
        pd^.rEStep[j, j1] := _StrToInt(rdStr);
      end;


    end;
    StrToEffectData(pd^.rSoundEvent, StrDB.GetFieldValueString(iName, 'SOUNDEVENT'));
    StrToEffectData(pd^.rSoundSpecial, StrDB.GetFieldValueString(iName, 'SOUNDSPECIAL'));

    Str := StrDB.GetFieldValueString(iName, 'GuardPos');
    for j := 0 to 10 - 1 do
    begin
      Str := GetValidStr3(Str, rdStr, ':');
      xx := _StrToInt(rdStr);
      Str := GetValidStr3(Str, rdStr, ':');
      yy := _StrToInt(rdStr);
      if (xx = 0) and (yy = 0) then break;

      pd^.rGuardX[j] := xx;
      pd^.rGuardY[j] := yy;
    end;
    pd^.rEventSay := StrDB.GetFieldValueString(iName, 'EventSay');
    pd^.rEventAnswer := StrDB.GetFieldValueString(iName, 'EventAnswer');
    Str := StrDB.GetFieldValueString(iName, 'EventItem');
    if Str <> '' then
    begin
      Str := GetValidStr3(Str, rdStr, ':');
      pd^.rEventItem.rName := rdStr;
      Str := GetValidStr3(Str, rdStr, ':');
      pd^.rEventItem.rCount := _StrToInt(rdStr);
    end;
    Str := StrDB.GetFieldValueString(iName, 'EventDropItem');
    if Str <> '' then
    begin
      Str := GetValidStr3(Str, rdStr, ':');
      pd^.rEventDropItem.rName := rdStr;
      Str := GetValidStr3(Str, rdStr, ':');
      pd^.rEventDropItem.rCount := _StrToInt(rdStr);
    end;

    pd^.rboRemove := StrDB.GetFieldValueBoolean(iName, 'boRemove');
    pd^.rOpennedInterval := StrDB.GetFieldValueInteger(iName, 'OpennedInterval');
    pd^.rRegenInterval := StrDB.GetFieldValueInteger(iName, 'RegenInterval');
    pd^.rShowInterval := StrDB.GetFieldValueInteger(iName, 'ShowInterval');
    pd^.rHideInterval := StrDB.GetFieldValueInteger(iName, 'HideInterval');

    DataList.Add(pd);
    AnsIndexClass.Insert(iName, (pd));
  end;

  StrDb.Free;
end;

const
  ITEMDRUG_DIV_VALUE = 10;

  ITEMDRUG_MUL_EVENTENERGY = 10;
  ITEMDRUG_MUL_EVENTINPOWER = 10;
  ITEMDRUG_MUL_EVENTOUTPOWER = 10;
  ITEMDRUG_MUL_EVENTMAGIC = 10;
  ITEMDRUG_MUL_EVENTLIFE = 15;
  ITEMDRUG_MUL_EVENTHEADLIFE = 15;
  ITEMDRUG_MUL_EVENTARMLIFE = 15;
  ITEMDRUG_MUL_EVENTLEGLIFE = 15;

    ///////////////////////////////////
    //         TItemDrugClass
    ///////////////////////////////////

constructor TItemDrugClass.Create;
begin
  ItemDrugDb := TUserStringDb.Create;
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('ItemDrugClass', 20, TRUE);
  ReLoadFromFile;
end;

destructor TItemDrugClass.Destroy;
begin
  Clear;
  AnsIndexClass.Free;
  DataList.Free;
  ItemDrugDb.Free;
  inherited Destroy;
end;

procedure TItemDrugClass.Clear;
var
  i: integer;
begin
  for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
  DataList.Clear;
  AnsIndexClass.Clear;
end;

procedure TItemDrugClass.ReLoadFromFile;
var
  i: integer;
  iname: string;
  pid: PTItemDrugData;
begin
  Clear;

  if not FileExists('.\Init\ItemDrug.SDB') then exit;

  ItemDrugDb.LoadFromFile('.\Init\ItemDrug.SDB');
  for i := 0 to ItemDrugDb.Count - 1 do
  begin
    iname := ItemDrugDb.GetIndexName(i);
    new(pid);
    LoadItemDrugData(iname, pid^);
    DataList.Add(pid);
    AnsIndexClass.Insert(iname, (pid));
  end;
end;

function TItemDrugClass.LoadItemDrugData(aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
begin
  Result := FALSE;
  FillChar(ItemDrugData, sizeof(ItemDrugData), 0);
  if ItemDrugDb.GetDbString(aItemDrugName) = '' then exit;

  ItemDrugData.rname := aItemDrugName;
  ItemDrugData.rEventEnergy := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eEnergy') * ITEMDRUG_MUL_EVENTENERGY div ITEMDRUG_DIV_VALUE;
  ItemDrugData.rEventInPower := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eInPower') * ITEMDRUG_MUL_EVENTINPOWER div ITEMDRUG_DIV_VALUE;
  ItemDrugData.rEventOutPower := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eOutPower') * ITEMDRUG_MUL_EVENTOUTPOWER div ITEMDRUG_DIV_VALUE;
  ItemDrugData.rEventMagic := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eMagic') * ITEMDRUG_MUL_EVENTMAGIC div ITEMDRUG_DIV_VALUE;
  ItemDrugData.rEventLife := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eLife') * ITEMDRUG_MUL_EVENTLIFE div ITEMDRUG_DIV_VALUE;
  ItemDrugData.rEventHeadLife := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eHeadLife') * ITEMDRUG_MUL_EVENTHEADLIFE div ITEMDRUG_DIV_VALUE;
  ItemDrugData.rEventArmLife := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eArmLife') * ITEMDRUG_MUL_EVENTARMLIFE div ITEMDRUG_DIV_VALUE;
  ItemDrugData.rEventLegLife := ItemDrugDb.GetFieldValueinteger(aItemDrugName, 'eLegLife') * ITEMDRUG_MUL_EVENTLEGLIFE div ITEMDRUG_DIV_VALUE;
  Result := TRUE;
end;

function TItemDrugClass.GetItemDrugData(aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aItemDrugName);
    // if (n = 0) or (n = -1) then
  if n = nil then
  begin
    FillChar(ItemDrugData, sizeof(ItemDrugData), 0);
    exit;
  end;
  ItemDrugData := PTItemDrugData(n)^;
  ItemDrugData.rUsedCount := 0;
  Result := TRUE;
end;

///////////////////////////////////
//         TMonsterClass
///////////////////////////////////

constructor TMonsterClass.Create;
begin
  CheckItemClassList := TCheckItemClassList.Create;
  MonsterDb := TUserStringDb.Create;
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('Monster', 20, TRUE);
  ReLoadFromFile;
end;

destructor TMonsterClass.Destroy;
begin
  Clear;
  AnsIndexClass.Free;
  DataList.Free;
  MonsterDb.Free;
  CheckItemClassList.Free;
  inherited Destroy;
end;

procedure TMonsterClass.Clear;
var
  i: integer;
  pmd: PTMonsterData;
begin
  CheckItemClassList.clear;
  for i := 0 to DataList.Count - 1 do
  begin
    pmd := DataList[i];
      //  RandomClass.del(pmd.rName);
    dispose(pmd);
  end;
  DataList.Clear;
  AnsIndexClass.Clear;
end;


function TMonsterClass.GetCount: integer;
begin
  Result := DataList.Count;
end;

function TMonsterClass.LoadMonsterData(aMonsterName: string; var MonsterData: TMonsterData): Boolean;
var
  i, iCount, iRandomCount: Integer;
  str, mName, mCount, mSkill: string;
  aitem: titemdata;
  ritemstr, ritemcolor: string;
begin
  Result := FALSE;
  FillChar(MonsterData, sizeof(MonsterData), 0);
  if MonsterDb.GetDbString(aMonsterName) = '' then exit;

  MonsterData.rname := aMonsterName;

  mName := MonsterDB.GetFieldValueString(aMonsterName, 'ViewName');
  MonsterData.rViewName := mName;

  StrToEffectData(MonsterData.rSoundNormal, MonsterDb.GetFieldValueString(aMonsterName, 'SoundNormal'));
  StrToEffectData(MonsterData.rSoundAttack, MonsterDb.GetFieldValueString(aMonsterName, 'SoundAttack'));
  StrToEffectData(MonsterData.rSoundDie, MonsterDb.GetFieldValueString(aMonsterName, 'SoundDie'));
  StrToEffectData(MonsterData.rSoundStructed, MonsterDb.GetFieldValueString(aMonsterName, 'SoundStructed'));

  MonsterData.rvirtue := MonsterDb.GetFieldValueinteger(aMonsterName, 'virtue');
  MonsterData.rVirtueLevel := MonsterDb.GetFieldValueinteger(aMonsterName, 'VirtueLevel');
  MonsterData.rExtraExp := MonsterDb.GetFieldValueinteger(aMonsterName, 'ExtraExp');
  //if MonsterData.rExtraExp > 0 then MonsterData.rExtraExp := MonsterData.rExtraExp * 10000;

  MonsterData.r3HitExp := MonsterDb.GetFieldValueinteger(aMonsterName, '3HitExp'); //真气经验
  MonsterData.rShortExp := MonsterDb.GetFieldValueinteger(aMonsterName, 'ShortExp'); //一层近经验
  MonsterData.rLongExp := MonsterDb.GetFieldValueinteger(aMonsterName, 'LongExp'); //一层远程经验
  MonsterData.rRiseShortExp := MonsterDb.GetFieldValueinteger(aMonsterName, 'RiseShortExp'); //二层近经验
  MonsterData.rRiseLongExp := MonsterDb.GetFieldValueinteger(aMonsterName, 'RiseLongExp'); //二层远程经验

//  MonsterData.rHandExp := MonsterDb.GetFieldValueinteger(aMonsterName, 'HandExp');
//  MonsterData.rBestShortExp := MonsterDb.GetFieldValueinteger(aMonsterName, 'BestShortExp');
//  MonsterData.rBestShortExp2 := MonsterDb.GetFieldValueinteger(aMonsterName, 'BestShortExp2');
 // MonsterData.rBestShortExp3 := MonsterDb.GetFieldValueinteger(aMonsterName, 'BestShortExp3');
  MonsterData.rLimitSkill := MonsterDb.GetFieldValueinteger(aMonsterName, 'LimitSkill');

  MonsterData.rShape := MonsterDb.GetFieldValueinteger(aMonsterName, 'Shape');
  MonsterData.rWalkSpeed := MonsterDb.GetFieldValueinteger(aMonsterName, 'WalkSpeed');


  MonsterData.rdamage := MonsterDb.GetFieldValueinteger(aMonsterName, 'Damage');
  MonsterData.rDamageHead := MonsterDb.GetFieldValueinteger(aMonsterName, 'DamageHead');
  MonsterData.rDamageArm := MonsterDb.GetFieldValueinteger(aMonsterName, 'DamageArm');
  MonsterData.rDamageLeg := MonsterDb.GetFieldValueinteger(aMonsterName, 'DamageLeg');

   { MonType(怪物类型) 1=人形怪,留空则普通怪物
sex(性别) 不填或"NULL"=女 TRUE=男
arr_body(身体)
arr_gloves(手套)
arr_upunderwear(上衣)
arr_shoes(鞋子)
arr_downunderwear(裤子)
arr_upoverwear(外套)
arr_hair(头发)
arr_cap(帽子)
arr_weapon(武器)
    }
  MonsterData.rMonType := MonsterDb.GetFieldValueInteger(aMonsterName, 'MonType');
  MonsterData.rboman := MonsterDb.GetFieldValueBoolean(aMonsterName, 'sex');

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_body');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[ARR_BODY * 2] := aitem.rWearShape;
    //MonsterData.rArr[ARR_BODY * 2 + 1] := aitem.rcolor;
    MonsterData.rArr[ARR_BODY * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_gloves');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[ARR_GLOVES * 2] := aitem.rWearShape;
    MonsterData.rArr[ARR_GLOVES * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_upunderwear');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[arr_upunderwear * 2] := aitem.rWearShape;
    MonsterData.rArr[arr_upunderwear * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_shoes');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[arr_shoes * 2] := aitem.rWearShape;
    MonsterData.rArr[arr_shoes * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_downunderwear');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[arr_downunderwear * 2] := aitem.rWearShape;
    MonsterData.rArr[arr_downunderwear * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_upoverwear');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[arr_upoverwear * 2] := aitem.rWearShape;
    MonsterData.rArr[arr_upoverwear * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_hair');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[arr_hair * 2] := aitem.rWearShape;
    MonsterData.rArr[arr_hair * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_cap');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[arr_cap * 2] := aitem.rWearShape;
    MonsterData.rArr[arr_cap * 2 + 1] := _StrToInt(ritemcolor);
  end;

  str := MonsterDb.GetFieldValueString(aMonsterName, 'arr_weapon');
  ritemcolor := GetValidStr3(str, ritemstr, ':');
  if (ritemstr <> '') and ItemClass.GetItemData(ritemstr, aitem) then
  begin
    MonsterData.rArr[arr_weapon * 2] := aitem.rWearShape;
    MonsterData.rArr[arr_weapon * 2 + 1] := _StrToInt(ritemcolor);

    case aitem.rHitMotion of
      0: MonsterData.rhitmotion := AM_HIT; //拳头
      1: MonsterData.rhitmotion := AM_HIT1; //
      2: MonsterData.rhitmotion := AM_HIT2; //剑 刀
      3: MonsterData.rhitmotion := AM_HIT3; //抢 斧
      4: MonsterData.rhitmotion := AM_HIT4; //弓箭
      5: MonsterData.rhitmotion := AM_HIT5; //
      6: MonsterData.rhitmotion := AM_HIT6; //
      7: MonsterData.rhitmotion := AM_HIT7; //
      9: MonsterData.rhitmotion := AM_HIT9; //
      12: MonsterData.rhitmotion := AM_HIT8;
    end;
  end;
  MonsterData.rarmor := MonsterDb.GetFieldValueinteger(aMonsterName, 'Armor');

  MonsterData.rAttackSpeed := MonsterDb.GetFieldValueinteger(aMonsterName, 'AttackSpeed');
  MonsterData.ravoid := MonsterDb.GetFieldValueinteger(aMonsterName, 'Avoid');
  MonsterData.rrecovery := MonsterDb.GetFieldValueinteger(aMonsterName, 'Recovery');
  MonsterData.rHitArmor := MonsterDB.GetFieldValueInteger(aMonsterName, 'HitArmor');
  MonsterData.rAccuracy := MonsterDB.GetFieldValueInteger(aMonsterName, 'Accuracy');

  MonsterData.rspendlife := MonsterDb.GetFieldValueinteger(aMonsterName, 'SpendLife');
  MonsterData.rAnimate := MonsterDb.GetFieldValueinteger(aMonsterName, 'Animate');

  MonsterData.rlife := MonsterDb.GetFieldValueinteger(aMonsterName, 'Life');
  MonsterData.rScripter := MonsterDb.GetFieldValueString(aMonsterName, 'Scripter');
  MonsterData.rboScripterHit := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boScripterHit'); //攻击触发脚本
  MonsterData.rboUpdateTime := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boUpdateTime'); //update脚本触发


  MonsterData.rboControl := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boControl');
  if MonsterData.rboControl then
  begin
    MonsterData.rxControl := MonsterDb.GetFieldValueInteger(aMonsterName, 'XControl');
    MonsterData.ryControl := MonsterDb.GetFieldValueInteger(aMonsterName, 'YControl');
  end;

{    str := MonsterDb.GetFieldValueString(aMonsterName, 'starttime');
    if str = '' then
        MonsterData.rstarttime := 0
    else MonsterData.rstarttime := StrToTime(str);
    str := MonsterDb.GetFieldValueString(aMonsterName, 'endtime');
    if str = '' then
        MonsterData.rendtime := 0
    else MonsterData.rendtime := StrToTime(str);
 }
    //20090928增加 单文件支持携带 多物品
  MonsterData.rHaveItemListP := nil;
    //20091126,新使用,大表格方式,处理爆率问题
  {str := MonsterDb.GetFieldValueString(aMonsterName, 'HaveItemFile');
  if str <> '' then
  begin
    CheckItemClassList.loadfile(aMonsterName, '.\Init\DropItem\' + str);

//        MonsterData.rHaveItemListP := CheckItemClassList.get(aMonsterName);
  end;                 }
  CheckItemClassList.loadfilex(amonstername); //这个是单独设置的

    //20090929恢复 向下兼容
  str := MonsterDb.GetFieldValueString(aMonsterName, 'HaveItem'); //这个是在monster.sdb里设定的
  for i := 0 to 9 do
  begin
    if str = '' then break;
    str := GetValidStr3(str, mName, ':');
    //if mName = '' then break;
    if mName = '' then
    begin
      frmMain.WriteLogInfo(format('怪物[%s]爆出空道具', [aMonsterName]));
      break;
    end;
    str := GetValidStr3(str, mCount, ':');
    if mCount = '' then break;
    iCount := _StrToInt(mCount);
   // if iCount <= 0 then break;
    if iCount <= 0 then
    begin
      frmMain.WriteLogInfo(format('怪物[%s]爆出[%s]设置错误', [aMonsterName, mName]));
      break;
    end;
    str := GetValidStr3(str, mCount, ':');
    if mCount = '' then break;
    iRandomCount := _StrToInt(mCount);
    //if iRandomCount <= 0 then iRandomCount := 1;
    //if iRandomCount <= 0 then break;
    if iRandomCount <= 0 then
    begin
      frmMain.WriteLogInfo(format('怪物[%s]爆出[%s]设置错误', [aMonsterName, mName]));
      break;
    end;

    CheckItemClassList.addItem(aMonsterName, mName, iCount, iRandomCount);
//        MonsterData.rHaveItem[i].rName := mName;
 //       MonsterData.rHaveItem[i].rCount := iCount;

    RandomClass.AddData(mName, aMonsterName, iRandomCount);
  end;
  MonsterData.rHaveItemListP := CheckItemClassList.get(aMonsterName);         
  //范围掉落
//  str := MonsterDb.GetFieldValueString(aMonsterName, 'FallItem');
//  for i := 0 to high(MonsterData.rFallItem) do
//  begin
//    if str = '' then break;
//    str := GetValidStr3(str, mName, ':');
//    if mName = '' then break;
//    str := GetValidStr3(str, mCount, ':');
//    MonsterData.rFallItem[i].rName := copy(mName, 1, 20);
//    MonsterData.rFallItem[i].rCount := _StrToInt(mcount);
//  end;      
//  MonsterData.rFallItemRandomCount := MonsterDb.GetFieldValueInteger(aMonsterName, 'FallItemRandomCount');

  MonsterData.rboLOG := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boLOG');
  MonsterData.rRegenInterval := MonsterDb.GetFieldValueInteger(aMonsterName, 'RegenInterval'); //2009 3 24 增加


  MonsterData.rboNOTAddExp := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boNOTAddExp');
  MonsterData.rboViewHuman := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boViewHuman');
  MonsterData.rboAutoAttack := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boAutoAttack');
  MonsterData.rboHit := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boHit'); //2015年10月17日 16:13:18增加是否允许攻击
  MonsterData.rboNotBowHit := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boNotBowHit'); //2016年3月4日 08:53:29 增加是否允许远程攻击

  MonsterData.rboAttack := MonsterDB.GetFieldValueBoolean(aMonsterName, 'boAttack');
  MonsterData.rEscapeLife := MonsterDb.GetFieldValueinteger(aMonsterName, 'EscapeLife');
  MonsterData.rViewWidth := MonsterDb.GetFieldValueinteger(aMonsterName, 'ViewWidth');
  MonsterData.rboBoss := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boBoss');
  MonsterData.rboChangeTarget := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boChangeTarget');
  MonsterData.rboVassal := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boVassal');
  MonsterData.rVassalCount := MonsterDb.GetFieldValueinteger(aMonsterName, 'VassalCount');
  MonsterData.rboice := MonsterDb.GetFieldValueBoolean(aMonsterName, 'boice');

  MonsterData.rActionWidth := MonsterDb.GetFieldValueInteger(aMonsterName, 'ActionWidth'); //新增读取怪物活动范围

  str := MonsterDb.GetFieldValueString(aMonsterName, 'AttackMagic');
  str := GetValidStr3(str, mname, ':');
  str := GetValidStr3(str, mskill, ':');
  MagicClass.GetMagicData(mname, MonsterData.rAttackMagic, _StrToInt(mskill));

  MonsterData.rHaveMagic := MonsterDb.GetFieldValueString(aMonsterName, 'HaveMagic');   
  MonsterData.rKind := MonsterDb.GetFieldValueinteger(aMonsterName, 'Kind');

  Result := TRUE;
end;

procedure TMonsterClass.SaveDropItem();
begin
  CheckItemClassList.savefile();
end;

procedure TMonsterClass.ReLoadFromFile;
var
  i: integer;
  iname: string;
  pmd: PTMonsterData;
begin
  Clear;

  if not FileExists('.\Init\Monster.SDB') then exit;

  MonsterDb.LoadFromFile('.\Init\Monster.SDB');

  for i := 0 to MonsterDb.Count - 1 do
  begin
    iname := MonsterDb.GetIndexName(i);
    new(pmd);
    LoadMonsterData(iname, pmd^);
    DataList.Add(pmd);
    AnsIndexClass.Insert(iname, (pmd));

  end;

//   SaveDropItem;
end;

procedure TMonsterClass.ReLoadHaveItem;
var
  i, m, iCount, iRandomCount: Integer;
  str, aMonsterName, mName, mCount: string;
  StrDB: TUserStringDB;
begin
  if not FileExists('.\Init\Monster.SDB') then exit;
  CheckItemClassList.clear;
  StrDB := TUserStringDB.Create;
  StrDB.LoadFromFile('.\Init\Monster.SDB');

  for i := 0 to StrDB.Count - 1 do
  begin
    aMonsterName := StrDB.GetIndexName(i);
    if aMonsterName <> '' then
    begin
      str := MonsterDb.GetFieldValueString(aMonsterName, 'HaveItem'); //这个是在monster.sdb里设定的
      for m := 0 to 9 do
      begin
        if str = '' then break;
        str := GetValidStr3(str, mName, ':');
        if mName = '' then
        begin
          frmMain.WriteLogInfo(format('怪物[%s]爆出空道具', [aMonsterName]));
          break;
        end;
        str := GetValidStr3(str, mCount, ':');
        if mCount = '' then break;
        iCount := _StrToInt(mCount);
        if iCount <= 0 then
        begin
          frmMain.WriteLogInfo(format('怪物[%s]爆出[%s]设置错误', [aMonsterName, mName]));
          break;
        end;
        str := GetValidStr3(str, mCount, ':');
        if mCount = '' then break;
        iRandomCount := _StrToInt(mCount);
        if iRandomCount <= 0 then
        begin
          frmMain.WriteLogInfo(format('怪物[%s]爆出[%s]设置错误', [aMonsterName, mName]));
          break;
        end;
        CheckItemClassList.addItem(aMonsterName, mName, iCount, iRandomCount);
        RandomClass.AddData(mName, aMonsterName, iRandomCount);
      end;
    end;
  end;
  StrDB.Free;
end;

function TMonsterClass.GetMonsterByIndex(aIndex: integer): PTMonsterData;
var
  i: Integer;
  Monster: PTMonsterData;
begin
  Result := nil;
  if (aIndex < 0) and (aIndex > DataList.Count) then Exit;
  Monster := DataList.Items[aIndex];
  if Monster <> nil then Result := Monster;
  exit;
end;

function TMonsterClass.GetMonsterData(aMonsterName: string; var pMonsterData: PTMonsterData): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aMonsterName);
    //   if (n = 0) or (n = -1) then
  if n = nil then
  begin
    pMonsterData := nil;
    exit;
  end;

  pMonsterData := PTMonsterData(n);

  Result := TRUE;
end;

///////////////////////////////////
//         TNpcClass
///////////////////////////////////

constructor TNpcClass.Create;
begin

  NpcDb := TUserStringDb.Create;
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('Npc', 20, TRUE);
  ReLoadFromFile;
end;

destructor TNpcClass.Destroy;
begin
  Clear;
  AnsIndexClass.Free;
  DataList.Free;
  NpcDb.Free;
  inherited destroy;
end;

procedure TNpcClass.Clear;
var
  i: integer;
begin
  for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
  DataList.Clear;
  AnsIndexClass.Clear;
end;

function TNpcClass.LoadNpcData(aNpcName: string; var NpcData: TNpcData): Boolean;
var
  i, iCount, iRandomCount: Integer;
  str, mName, mCount: string;
begin
    {Virtue,VirtueLevel,NpcText,,boSale,boSeller,boProtecter,boObserver,boAutoAttack,boHit,animate,shape,Image,Damage,Armor,ArmorHead,ArmorArm,ArmorLeg,Life,AttackSpeed,Avoid,Recovery,SpendLife,HitArmor,ActionWidth,SoundStart,SoundAttack,SoundDie,SoundNormal,SoundStructed,EffectStart,EffectStructed,EffectEnd,HaveItem,AttackMagic,AttackSkill,HaveMagic,RegenInterval,boBattle,boRightRemove,}
  Result := FALSE;
  FillChar(NpcData, sizeof(NpcData), 0);
  if NpcDb.GetNameIndex(aNpcName) = -1 then exit;

  NpcData.rName := aNpcName;
  mName := NpcDB.GetFieldValueString(aNpcName, 'ViewName');
  NpcData.rViewName := mName;

  NpcData.rboHit := NpcDb.GetFieldValueBoolean(aNpcName, 'boHit');
  NpcData.rMinimapShow := NpcDb.GetFieldValueBoolean(aNpcName, 'boMinimapShow');
  NpcData.rRegenInterval := NpcDb.GetFieldValueinteger(aNpcName, 'RegenInterval');

  NpcData.rShape := NpcDb.GetFieldValueinteger(aNpcName, 'Shape');
  NpcData.rAnimate := NpcDb.GetFieldValueinteger(aNpcName, 'Animate');
  NpcData.rImage := NpcDb.GetFieldValueinteger(aNpcName, 'Image');
  NpcData.rdamage := NpcDb.GetFieldValueinteger(aNpcName, 'Damage');
  NpcData.rAttackSpeed := NpcDb.GetFieldValueinteger(aNpcName, 'AttackSpeed');
  NpcData.ravoid := NpcDb.GetFieldValueinteger(aNpcName, 'Avoid');
  NpcData.rrecovery := NpcDb.GetFieldValueinteger(aNpcName, 'Recovery');
  NpcData.rspendlife := NpcDb.GetFieldValueinteger(aNpcName, 'SpendLife');
  NpcData.rarmor := NpcDb.GetFieldValueinteger(aNpcName, 'Armor');
  NpcData.rHitArmor := NpcDB.GetFieldValueInteger(aNpcName, 'HitArmor');
  NpcData.rlife := NpcDb.GetFieldValueinteger(aNpcName, 'Life');
  NpcData.rboProtecter := NpcDb.GetFieldValueBoolean(aNpcName, 'boProtecter');
  NpcData.rboObserver := NpcDb.GetFieldValueBoolean(aNpcName, 'boObserver');
  NpcData.rboAutoAttack := NpcDb.GetFieldValueBoolean(aNpcName, 'boAutoAttack');
  NpcData.rboSeller := NpcDb.GetFieldValueBoolean(aNpcName, 'boSeller');
  NpcData.rActionWidth := NpcDb.GetFieldValueInteger(aNpcName, 'ActionWidth');

  NpcData.rScripter := NpcDb.GetFieldValueString(aNpcName, 'Scripter');
  NpcData.rboEnmity := NpcDb.GetFieldValueBoolean(aNpcName, 'boEnmity');

  str := NpcDb.GetFieldValueString(aNpcName, 'HaveItem');
  for i := 0 to high(NpcData.rHaveItem) do
  begin
    if str = '' then break;
    str := GetValidStr3(str, mName, ':');
   // if mName = '' then break;
    if mName = '' then
    begin
      frmMain.WriteLogInfo(format('NPC[%s]爆出空道具', [aNpcName]));
      break;
    end;
    str := GetValidStr3(str, mCount, ':');
    if mCount = '' then break;
    iCount := _StrToInt(mCount);
    //if iCount <= 0 then break;
    if iCount <= 0 then
    begin
      frmMain.WriteLogInfo(format('NPC[%s]爆出[%s]设置错误', [aNpcName, mName]));
      break;
    end;

    str := GetValidStr3(str, mCount, ':');
    if mCount = '' then break;
    iRandomCount := _StrToInt(mCount);
    //if iRandomCount <= 0 then iRandomCount := 1;
    //if iRandomCount <= 0 then break;
    if iRandomCount <= 0 then
    begin
      frmMain.WriteLogInfo(format('NPC[%s]爆出[%s]设置错误', [aNpcName, mName]));
      break;
    end;

    NpcData.rHaveItem[i].rName := mName;
    NpcData.rHaveItem[i].rCount := iCount;

    RandomClass.AddData(mName, aNpcName, iRandomCount);
  end;

  str := NpcDb.GetFieldValueString(aNpcName, 'NpcText');
  NpcData.rNpcText := str;

  NpcData.rAnimate := NpcDb.GetFieldValueInteger(aNpcName, 'Animate');
  NpcData.rShape := NpcDb.GetFieldValueInteger(aNpcName, 'Shape');

  StrToEffectData(NpcData.rSoundNormal, NpcDb.GetFieldValueString(aNpcName, 'SoundNormal'));
  StrToEffectData(NpcData.rSoundAttack, NpcDb.GetFieldValueString(aNpcName, 'SoundAttack'));
  StrToEffectData(NpcData.rSoundDie, NpcDb.GetFieldValueString(aNpcName, 'SoundDie'));
  StrToEffectData(NpcData.rSoundStructed, NpcDb.GetFieldValueString(aNpcName, 'SoundStructed'));
  //2016.06.16 添加LOG 与 远程攻击设置
  NpcData.rboLOG := NpcDb.GetFieldValueBoolean(aNpcName, 'boLOG');
  NpcData.rboNotBowHit := NpcDb.GetFieldValueBoolean(aNpcName, 'boNotBowHit');
  NpcData.rboUPdateTime := NpcDb.GetFieldValueBoolean(aNpcName, 'boUPdateTime');
  Result := TRUE;
end;

procedure TNpcClass.ReLoadFromFile;
var
  i: integer;
  iname: string;
  pnd: PTNpcData;
begin
  Clear;

  if not FileExists('.\Init\Npc.SDB') then exit;

  NpcDb.LoadFromFile('.\Init\Npc.SDB');
  for i := 0 to NpcDb.Count - 1 do
  begin
    iname := NpcDb.GetIndexName(i);
    new(pnd);
    LoadNpcData(iname, pnd^);
    DataList.Add(pnd);
    AnsIndexClass.Insert(iname, (pnd));

  end;
end;

function TNpcClass.GetNpcData(aNpcName: string; var pNpcData: PTNpcData): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aNpcName);
    // if (n = 0) or (n = -1) then
  if n = nil then
  begin
    pNpcData := nil;
    exit;
  end;
  pNpcData := PTNpcData(n);

  Result := TRUE;
end;

constructor TPosByDieClass.Create;
begin
  DataList := TList.Create;
  ReLoadFromFile;
end;

destructor TPosByDieClass.Destroy;
begin
  Clear;
  DataList.Free;

  inherited Destroy;
end;

procedure TPosByDieClass.Clear;
var
  i: Integer;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Dispose(DataList[i]);
  end;
  DataList.Clear;
end;

procedure TPosByDieClass.ReLoadFromFile;
var
  i: Integer;
  iName: string;
  StrDB: TUserStringDB;
  pd: PTPosByDieData;
begin
  if not FileExists('.\Init\PosByDie.SDB') then exit;

  StrDB := TUserStringDB.Create;
  StrDB.LoadFromFile('.\Init\PosByDie.SDB');

  for i := 0 to StrDB.Count - 1 do
  begin
    iName := StrDB.GetIndexName(i);
    if iName <> '' then
    begin
      New(pd);
      FillChar(pd^, sizeof(PTPosByDieData), 0);
      pd^.rServerID := StrDB.GetFieldValueInteger(iName, 'Server');
      pd^.rDestServerID := StrDB.GetFieldValueInteger(iName, 'DestServer');
      pd^.rDestX := StrDB.GetFieldValueInteger(iName, 'DestX');
      pd^.rDestY := StrDB.GetFieldValueInteger(iName, 'DestY');

      DataList.Add(pd);
    end;
  end;

  StrDB.Free;
end;

procedure TPosByDieClass.GetPosByDieData(aServerID: Integer; var aDestServerID: Integer; var aDestX, aDestY: Word);
var
  i: Integer;
  pd: PTPosByDieData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if pd <> nil then
    begin
      if pd^.rServerID = aServerID then
      begin
        aDestServerID := pd^.rDestServerID;
        aDestX := pd^.rDestX;
        aDestY := pd^.rDestY;
        exit;
      end;
    end;
  end;
end;

procedure TPosByDieClass.GetNewMapAdd(aServerID: Integer; aDestServerID: Integer; aDestX, aDestY: Word);
var
  pd: PTPosByDieData;
begin
  New(pd);
  FillChar(pd^, sizeof(PTPosByDieData), 0);
  pd^.rServerID := aServerID;
  pd^.rDestServerID := aDestServerID;
  pd^.rDestX := aDestX;
  pd^.rDestY := aDestY;
  DataList.Add(pd);
end;

constructor TQuestClass.Create;
begin
end;

destructor TQuestClass.Destroy;
begin
  inherited Destroy;
end;

function TQuestClass.CheckQuest1(aServerID: Integer; var aRetStr: string): Boolean;
var
  tmpManager: TManager;
  iMonster, iNpc: Integer;
begin
  Result := false;
  tmpManager := ManagerList.GetManagerByServerID(aServerID);
  if tmpManager <> nil then
  begin
    iMonster := TMonsterList(tmpManager.MonsterList).getliveCount('');
    iNpc := TNpcList(tmpManager.NpcList).getliveCount('');
    if (iMonster <= 0) and (iNpc <= 0) then
    begin
      Result := true;
      exit;
    end;
    aRetStr := '';
    if iMonster > 0 then
    begin
      aRetStr := aRetStr + format('MONSTER(%d)', [iMonster]);
    end;
    if (iMonster > 0) and (iNpc > 0) then
    begin
      aRetStr := aRetStr + ', ';
    end;
    if iNpc > 0 then
    begin
      aRetStr := aRetStr + format('NPC(%d)', [iNpc]);
    end;
    aRetStr := aRetStr + ' 生存';
  end;
end;

function TQuestClass.GetQuestString(aQuest: Integer): string;
begin
  Result := '';
end;

function TQuestClass.CheckQuestComplete(aQuest, aServerID: Integer; var aRetStr: string): Boolean;
begin
  Result := false;
  case aQuest of
    1: Result := CheckQuest1(aServerID, aRetStr);
  end;
end;

////////////////////////////////////////////////////
//
//             ===  AreaClass  ===
//
////////////////////////////////////////////////////

constructor TAreaClass.Create;
begin
  DataList := TList.Create;
  LoadFromFile('.\Init\AreaData.SDB');
end;

destructor TAreaClass.Destroy;
begin
  Clear;
  DataList.Free;
  inherited destroy;
end;

function TAreaClass.GetCount: integer;
begin
  Result := DataList.Count;
end;

procedure TAreaClass.Clear;
var
  i: Integer;
begin
  for i := 0 to DataList.Count - 1 do Dispose(DataList[i]);
  DataList.Clear;
end;

procedure TAreaClass.LoadFromFile(aFileName: string);
var
  i: Integer;
  iName: string;
  pd: PTAreaClassData;
  AreaDB: TUserStringDb;
begin
  Clear;

  if not FileExists(aFileName) then exit;

  AreaDB := TUserStringDb.Create;
  AreaDB.LoadFromFile(aFileName);

  for i := 0 to AreaDB.Count - 1 do
  begin
    iName := AreaDB.GetIndexName(i);
    if iName = '' then continue;

    New(pd);
    FillChar(pd^, sizeof(TAreaClassData), 0);

    pd^.Name := AreaDB.GetFieldValueString(iName, 'Name');
    pd^.Index := AreaDB.GetFieldValueInteger(iName, 'Index');
    pd^.Func := AreaDB.GetFieldValueString(iName, 'Func');
    pd^.Desc := AreaDB.GetFieldValueString(iName, 'Desc');

    DataList.Add(pd);
  end;
  AreaDB.Free;
end;

function TAreaClass.CanMakeGuild(aIndex: Byte): Boolean;
var
  i: Integer;
  str, rdstr: string;
  pd: PTAreaClassData;
begin
  Result := false;

  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if pd^.Index = aIndex then
    begin
      str := pd^.func;
      while str <> '' do
      begin
        str := GetValidStr3(str, rdstr, ':');
        if _StrToInt(rdstr) = AREA_CANMAKEGUILD then
        begin
          Result := true;
          exit;
        end;
      end;
      exit;
    end;
  end;
end;

function TAreaClass.GetAreaName(aIndex: Byte): string;
var
  i: Integer;
  pd: PTAreaClassData;
begin
  Result := '';
  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if pd^.Index = aIndex then
    begin
      Result := pd^.Name;
      exit;
    end;
  end;
end;

function TAreaClass.GetAreaDesc(aIndex: Byte): string;
var
  i: Integer;
  pd: PTAreaClassData;
begin
  Result := '';
  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if pd^.Index = aIndex then
    begin
      Result := pd^.Desc;
      exit;
    end;
  end;
end;

constructor TPrisonClass.Create;
begin
  SaveTick := mmAnsTick;
  DataList := TList.Create;
  LoadFromFile('Prison.SDB');
end;

destructor TPrisonClass.Destroy;
begin
  if DataList <> nil then
  begin
    SaveToFile('Prison.SDB');
    Clear;
    DataList.Free;
  end;
  inherited Destroy;
end;

function TPrisonClass.GetPrisonTime(aType: string): Integer;
var
  i: Integer;
  sKind, sCount: string;
  Count, SumTime: Integer;
begin
  SumTime := 0;

  sKind := Copy(aType, 1, 1);
  sCount := Copy(aType, 2, Length(aType) - 1);
  Count := _StrToInt(sCount);

  if UpperCase(sKind) = 'A' then
  begin
    SumTime := 3;
    for i := 1 to Count - 1 do
    begin
      SumTime := SumTime * 2;
    end;
    SumTime := SumTime * 24 * 60;
  end else if UpperCase(sKind) = 'B' then
  begin
    SumTime := Count;
    SumTime := SumTime * 24 * 60;
  end else if UpperCase(sKind) = 'C' then
  begin
    SumTime := Count;
    SumTime := SumTime * 60;
  end else if UpperCase(sKind) = 'D' then
  begin
    SumTime := Count;
    SumTime := SumTime;
  end;

  //SumTime := SumTime * 24 * 60;

  Result := SumTime;
end;

function TPrisonClass.GetPrisonData(aName: string): PTPrisonData;
var
  i: Integer;
  pd: PTPrisonData;
begin
  Result := nil;

  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if pd = nil then continue;
    if pd^.rUserName = aName then
    begin
      Result := pd;
      exit;
    end;
  end;
end;

procedure TPrisonClass.Update(CurTick: Integer);
begin
  if SaveTick + FrmMain.inteval div 2 <= CurTick then
  begin
    SaveTick := CurTick;
    SaveToFile('Prison.SDB');
  end;
end;

procedure TPrisonClass.Clear;
var
  i: Integer;
  pd: PTPrisonData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if pd <> nil then Dispose(pd);
  end;
  DataList.Clear;
end;

function TPrisonClass.LoadFromFile(aFileName: string): Boolean;
var
  i: Integer;
  PrisonDB: TUserStringDB;
  iName: string;
  pd: PTPrisonData;
begin
  Result := false;

  if not FileExists(aFileName) then exit;

  PrisonDB := TUserStringDB.Create;
  PrisonDB.LoadFromFile(aFileName);

  for i := 0 to PrisonDB.Count - 1 do
  begin
    iName := PrisonDB.GetIndexName(i);
    if iName = '' then continue;

    New(pd);
    FillChar(pd^, sizeof(TPrisonData), 0);

    pd^.rUserName := PrisonDB.GetFieldValueString(iName, 'UserName');
    pd^.rPrisonType := PrisonDB.GetFieldValueString(iName, 'PrisonType');
    pd^.rElaspedTime := PrisonDB.GetFieldValueInteger(iName, 'ElaspedTime');
    pd^.rPrisonTime := GetPrisonTime(pd^.rPrisonType);
    pd^.rReason := PrisonDB.GetFieldValueString(iName, 'Reason');

    DataList.Add(pd);
  end;

  PrisonDB.Free;

  Result := true;
end;

function TPrisonClass.SaveToFile(aFileName: string): Boolean;
var
  i: Integer;
  iName: string;
  PrisonDB: TUserStringDB;
  pd: PTPrisonData;
begin
//    Result := false;

  PrisonDB := TUserStringDB.Create;
  PrisonDB.LoadFromFile(aFileName);
  for i := 0 to PrisonDB.Count - 1 do
  begin
    iName := PrisonDB.GetIndexName(i);
    PrisonDB.DeleteName(iName);
  end;

  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if pd <> nil then
    begin
      PrisonDB.AddName(pd^.rUserName);
      PrisonDB.SetFieldValueString(pd^.rUserName, 'UserName', pd^.rUserName);
      PrisonDB.SetFieldValueInteger(pd^.rUserName, 'PrisonTime', pd^.rPrisonTime);
      PrisonDB.SetFieldValueInteger(pd^.rUserName, 'ElaspedTime', pd^.rElaspedTime);
      PrisonDB.SetFieldValueString(pd^.rUserName, 'PrisonType', pd^.rPrisonType);
      PrisonDB.SetFieldValueString(pd^.rUserName, 'Reason', pd^.rReason);
    end;
  end;

  PrisonDB.SaveToFile(aFileName);
  PrisonDB.Free;

  Result := true;
end;

function TPrisonClass.AddUser(aName, aType, aReason: string): string;
var
  pd: PTPrisonData;
//    rStr: string;
  rTime: Integer;
  pUser: TUser;
begin
  Result := '';

  if aName = '' then
  begin
    Result := '请指定使用者名称';
    exit;
  end;
  if GetPrisonData(aName) <> nil then
  begin
    Result := '已被囚禁的使用者';
    exit;
  end;
  rTime := GetPrisonTime(aType);
  if rTime = 0 then
  begin
    Result := '时间设定错误';
    exit;
  end;

  New(pd);
  FillChar(pd^, sizeof(TPrisonData), 0);

  pd^.rUserName := aName;
  pd^.rElaspedTime := 0;
  pd^.rPrisonTime := rTime;
  pd^.rPrisonType := aType;
  pd^.rReason := aReason;

  DataList.Add(pd);

  pUser := UserList.GetUserPointer(aName);
  if pUser <> nil then
  begin
    pUser.boDeleteState := true;
    pUser.SendClass.SendCloseClient();
    pUser.SendClass.SendChatMessage('现在开始被囚禁于流配地，请重新连线', SAY_COLOR_SYSTEM);
    //ConnectorList.CloseConnectByCharName(aName);
  end;
end;

function TPrisonClass.DelUser(aName: string): string;
var
  pd: PTPrisonData;
//    rStr: string;
  rIndex: Integer;
begin
  Result := '';

  if aName = '' then
  begin
    Result := '请指定使用者名称';
    exit;
  end;

  pd := GetPrisonData(aName);
  if pd = nil then
  begin
    Result := '不是被囚禁的使用者';
    exit;
  end;
  rIndex := DataList.IndexOf(pd);
  if rIndex >= 0 then DataList.Delete(rIndex);
end;

function TPrisonClass.UpdateUser(aName, aType, aReason: string): string;
var
  pd: PTPrisonData;
//    rStr: string;
  rTime: Integer;
begin
  Result := '';

  if aName = '' then
  begin
    Result := '请指定使用者名称';
    exit;
  end;

  pd := GetPrisonData(aName);
  if pd = nil then
  begin
    Result := '不是被囚禁的使用者';
    exit;
  end;

  rTime := GetPrisonTime(aType);
  if rTime = 0 then
  begin
    Result := '时间设定错误';
    exit;
  end;
  pd^.rPrisonTime := rTime;
  pd^.rElaspedTime := 0;
  pd^.rPrisonType := aType;
  if aReason <> '' then
  begin
    pd^.rReason := aReason;
  end;
end;

function TPrisonClass.PlusUser(aName, aType, aReason: string): string;
var
  pd: PTPrisonData;
//    rStr: string;
  rTime: Integer;
begin
  Result := '';

  if aName = '' then
  begin
    Result := '请指定使用者名称';
    exit;
  end;

  pd := GetPrisonData(aName);
  if pd = nil then
  begin
    Result := '不是被囚禁的使用者';
    exit;
  end;

  rTime := GetPrisonTime(aType);
  if rTime = 0 then
  begin
    Result := '时间设定错误';
    exit;
  end;
  pd^.rPrisonTime := pd^.rPrisonTime + rTime;
  pd^.rPrisonType := aType;
  if aReason <> '' then
  begin
    pd^.rReason := aReason;
  end;
end;

function TPrisonClass.EditUser(aName, aTime, aReason: string): string;
var
  pd: PTPrisonData;
//    rStr: string;
  rTime: Integer;
begin
  Result := '';

  if aName = '' then
  begin
    Result := '请指定使用者名称';
    exit;
  end;

  pd := GetPrisonData(aName);
  if pd = nil then
  begin
    Result := '不是被囚禁的使用者';
    exit;
  end;

  rTime := _StrToInt(aTime);
  pd^.rPrisonTime := rTime;
  pd^.rPrisonType := 'C';
  if aReason <> '' then
  begin
    pd^.rReason := aReason;
  end;
end;

function TPrisonClass.GetUserStatus(aName: string): string;
var
  pd: PTPrisonData;
  TotalMin: Integer;
  nDay, nHour, nMin: Word;
  rStr: string;
begin
  Result := '';
  pd := GetPrisonData(aName);
  if pd = nil then exit;


  TotalMin := pd^.rPrisonTime;
  nDay := (TotalMin div (60 * 24));
  TotalMin := TotalMin - (nDay * 60 * 24);
  nHour := (TotalMin div 60);
  TotalMin := TotalMin - (nHour * 60);
  nMin := TotalMin;

  rStr := format('囚禁时间(%d天%d时%d分)', [nDay, nHour, nMin]);


  TotalMin := pd^.rPrisonTime - pd^.rElaspedTime;
  nDay := (TotalMin div (60 * 24));
  TotalMin := TotalMin - (nDay * 60 * 24);
  nHour := (TotalMin div 60);
  TotalMin := TotalMin - (nHour * 60);
  nMin := TotalMin;

  rStr := rStr + format('剩余时间(%d天%d时%d分)', [nDay, nHour, nMin]);

  Result := rStr;
end;

function TPrisonClass.IncreaseElaspedTime(aName: string; aTime: Integer): Integer;
var
  pd: PTPrisonData;
  rTime: Integer;
begin
  Result := 0;
  pd := GetPrisonData(aName);
  if pd = nil then exit;

  pd^.rElaspedTime := pd^.rElaspedTime + aTime;

  rTime := pd^.rPrisonTime - pd^.rElaspedTime;

  if rTime = 0 then DelUser(aName);

  Result := rTime;
end;

constructor TNpcFunction.Create;
begin
  DataList := TList.Create;

  LoadFromFile('.\NpcFunc\NpcFunc.SDB');
end;

destructor TNpcFunction.Destroy;
begin
  Clear;
  DataList.Free;
end;

procedure TNpcFunction.Clear;
var
  i: Integer;
  pd: PTNpcFunctionData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    Dispose(pd);
  end;
  DataList.Clear;
end;

procedure TNpcFunction.LoadFromFile(aFileName: string);
var
  i: Integer;
  iName: string;
  DB: TUserStringDB;
  pd: PTNpcFunctionData;
begin
  if not FileExists(aFileName) then exit;

  DB := TUserStringDB.Create;
  DB.LoadFromFile(aFileName);

  for i := 0 to DB.Count - 1 do
  begin
    iName := DB.GetIndexName(i);
    if iName = '' then continue;

    New(pd);
    FillChar(pd^, SizeOf(TNpcFunctionData), 0);
    pd^.Index := _StrToInt(iName);
    pd^.FuncType := DB.GetFieldValueInteger(iName, 'FuncType');
    pd^.Text := DB.GetFieldValueString(iName, 'Text');
    pd^.FileName := DB.GetFieldValueString(iName, 'FileName');
    pd^.StartQuest := DB.GetFieldValueInteger(iName, 'StartQuest');
    pd^.NextQuest := DB.GetFieldValueInteger(iName, 'NextQuest');

    DataList.Add(pd);
  end;

  DB.Free;
end;

function TNpcFunction.GetFunction(aIndex: Integer): PTNpcFunctionData;
var
  i: Integer;
  pd: PTNpcFunctionData;
begin
  Result := nil;

  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList.Items[i];
    if aIndex = pd^.Index then
    begin
      Result := pd;
      exit;
    end;
  end;
end;

constructor TScripter.Create;
begin
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('Scripter', 20, TRUE);
  PaxPascal := tPaxPascal.Create(nil);

end;

destructor TScripter.Destroy;
begin
  Clear;
  AnsIndexClass.Free;
  DataList.Free;
  PaxPascal.Free;
  inherited destroy;
end;

procedure TScripter.Clear;
var
  i: integer;
  p: pTScripterDATA;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList[i];
    p.PaxScripter.Free;
    dispose(p);
  end;
  DataList.Clear;
  AnsIndexClass.Clear;
end;

procedure TScripter.ReLoadFromFile();
var
  i: integer;
  p: pTScripterDATA;
  StringList: TStringList;
begin
  StringList := TStringList.Create;
  try
    for i := 0 to DataList.Count - 1 do
    begin
      p := DataList[i];
      if not FileExists(p.rnamefile) then Continue;
      StringList.Clear;
      StringList.LoadFromFile(p.rnamefile);
      try
        p.PaxScripter.RegisterLanguage(PaxPascal); //设置语言
        p.PaxScripter.ResetScripter;
        p.PaxScripter.AddModule('1', PaxPascal.LanguageName); //增加模块
        p.PaxScripter.AddCode('1', StringList.Text); //增加代码

        p.PaxScripter.Compile(); //编译
      except
        p.PaxScripter.ResetScripter;
      end;
    end;
  finally
    StringList.Free;
  end;
end;

function TScripter.get(aname: string): pTScripterDATA;
begin
  result := AnsIndexClass.Select(aname);
end;


procedure TScripter.add(aitem: TScripterDATA);
var
  p: pTScripterDATA;
begin
  if get(aitem.rname) <> nil then exit;
  new(p);
  p^ := aitem;
  DataList.Add(p);
  AnsIndexClass.Insert(p.rname, p);
end;

procedure TScripter.LoadFile(Jname, JFileName: string);
var
  StringList: TStringList;
  PaxScripter: tPaxScripter;
  aitem: TScripterDATA;
begin
  if not FileExists(JFileName) then EXIT;
  if IsScripter(Jname) then
  begin
    exit;
  end;
  StringList := TStringList.Create;

  try
    StringList.LoadFromFile(JFileName);
    PaxScripter := tPaxScripter.Create(nil);
    PaxScripter.RegisterLanguage(PaxPascal); //设置语言
    PaxScripter.ResetScripter;
    PaxScripter.AddModule('1', PaxPascal.LanguageName); //增加模块
    PaxScripter.AddCode('1', StringList.Text); //增加代码
        //PaxScripter.RegisterVariable('str', 'string', @self.str1); //注册变量
    try
      PaxScripter.Compile(); //编译
      aitem.rname := Jname;
      aitem.rnamefile := JFileName;
      aitem.PaxScripter := PaxScripter;
      add(aitem);
    except
            // frmMain.WriteLogInfo(format('TNPC.ScripterLOADFILE 脚本便宜错误 (%s) failed', [NpcName]));
      PaxScripter.Free;
    end;

  finally
    StringList.Free;
  end;
end;

function TScripter.IsScripter(JName: string): boolean;
begin
  Result := FALSE;
  if get(JName) <> nil then
    Result := true;
end;

function TScripter.GetScripter(JName: string; var PaxScripter: tPaxScripter): Boolean;
var
  p: pTScripterDATA;
begin
  Result := FALSE;
  PaxScripter := nil;
  p := get(JName);

  if p = nil then exit;

  PaxScripter := p.PaxScripter;

  Result := TRUE;
end;

{
procedure TScripter.CALLFUN(JName:string; uSource, uDest:integer; callname:string); //uname npcNAME  通用 无参数 过程
var
    PaxScripter     :tPaxScripter;
    aSource, aDest  :integer;
begin
    aSource := integer(uSource);
    aDest := integer(uDest);
    if pos('@', callname) <> 1 then exit;
    callname := copy(callname, 2, length(callname));
    if not GetScripter(Jname, PaxScripter) then EXIT;
    if PaxScripter = nil then EXIT;
    if PaxScripter.GetMemberID(callname) <> 0 then
        PaxScripter.CallFunction(callname, [aSource, aDest]);

end;

procedure TScripter.OnDestroy(JName:string; uSource, uDest:integer); //
var
    PaxScripter     :tPaxScripter;
    aSource, aDest  :integer;
begin
    aSource := integer(uSource);
    aDest := integer(uDest);
    if not GetScripter(JName, PaxScripter) then EXIT;
    if PaxScripter = nil then EXIT;
    if PaxScripter.GetMemberID('OnDestroy') <> 0 then
        PaxScripter.CallFunction('OnDestroy', [aSource, aDest]);

end;

procedure TScripter.OnMain(JName:string; uSource, uDest:integer); //uname npcNAME
var
    PaxScripter     :tPaxScripter;
    aSource, aDest  :integer;
begin
    aSource := integer(uSource);
    aDest := integer(uDest);
    if not GetScripter(JName, PaxScripter) then EXIT;
    if PaxScripter = nil then EXIT;
    if PaxScripter.GetMemberID('OnMain') <> 0 then
        PaxScripter.CallFunction('OnMain', [aSource, aDest]);

end;
}
////////////////////////////////////////////////////////////////////

procedure TsaveId.savefile();
begin
  if DBStream <> nil then
  begin
    DBStream.Position := 0;
    DBStream.WriteBuffer(Fid, 4);
  end;
end;

procedure TsaveId.loadfile;
begin

  if FileExists(Ffilename) = false then
  begin
    DBStream := TFileStream.Create(Ffilename, fmCreate);
    DBStream.WriteBuffer(Fid, 4);
  end else
  begin
    DBStream := TFileStream.Create(Ffilename, fmOpenReadWrite);
    DBStream.ReadBuffer(Fid, 4);
  end;
end;

constructor TsaveId.Create(afilename: string);
begin
  Ffilename := afilename;
  DBStream := nil;
  Fid := 0;
  loadfile;
end;

procedure TsaveId.Update(CurTick: integer);
begin
  if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit; //1分钟 执行 一次
  FDCurTick := CurTick;
  savefile;
end;

procedure TsaveId.ItemNewId(var aitem: TItemData);
begin
  if aitem.rboDouble = false then
    aitem.rId := GetNewID;

end;

function TsaveId.GetNewID: integer;
begin
  inc(fid);
  result := fid;
end;

destructor TsaveId.Destroy;
begin
  savefile;
  DBStream.Free;
  inherited Destroy;
end;

/////////////////////////////////////////////
//             TPowerLevel
/////////////////////////////////////////////

function TPowerLevelSub.getMax(aPower: integer): integer;
var
  i: integer;
begin
  result := 0;
  if aPower > LifeDataarr[High(LifeDataarr)].PowerValue then
  begin
    result := High(LifeDataarr);
    exit;
  end;
  for i := 1 to High(LifeDataarr) do
  begin
    if (aPower >= LifeDataarr[i].PowerValue) and (aPower <= LifeDataarr[i].LimitEnergy) then
    begin
     // ShowMessage(IntToStr(i));
      result := i;
      exit;
    end;
  end;

end;

function TPowerLevelSub.get(anum: integer): pTPowerLeveldata;
begin
  result := nil;
  if (anum < low(LifeDataarr)) or (anum > high(LifeDataarr)) then exit;
  result := @LifeDataarr[anum];
end;

function TPowerLevelSub.getname(anum: integer): string;
begin
  result := '';
  if (anum < low(LifeDataarr)) or (anum > high(LifeDataarr)) then exit;
  result := LifeDataarr[anum].ViewName;
end;

procedure TPowerLevelSub.LoadFromSdb();
var
  i, j: integer;
  iName: string;
  atp: TLifeData;
  adb: TUserStringDb;
begin
  Clear;

  if not FileExists('.\init\PowerLevel.SDB') then exit;
  adb := TUserStringDb.Create;
  try
    adb.LoadFromFile('.\init\PowerLevel.SDB');
    for i := 0 to adb.Count - 1 do
    begin
        //NAME,ViewName,PowerValue,LimitEnergy,damageBody,armorBody,damageHead,damageArm,damageLeg,armorHead,armorArm,armorLeg,AttackSpeed,avoid,recovery,HitArmor,accuracy,damageBodyPercent,armorBodyPercent,Life,
      iName := adb.GetIndexName(i);
      j := _StrToInt(iName);
      if (j >= low(LifeDataarr)) and (j <= high(LifeDataarr)) then
      begin
        LifeDataarr[j].ViewName := adb.GetFieldValueString(iName, 'ViewName');
        LifeDataarr[j].PowerValue := adb.GetFieldValueInteger(iName, 'PowerValue');
        LifeDataarr[j].LimitEnergy := adb.GetFieldValueInteger(iName, 'LimitEnergy');

        LifeDataarr[j].damageBodyPercent := adb.GetFieldValueInteger(iName, 'damageBodyPercent');
        LifeDataarr[j].armorBodyPercent := adb.GetFieldValueInteger(iName, 'armorBodyPercent');
        LifeDataarr[j].Life := adb.GetFieldValueInteger(iName, 'Life');

        LifeDataarr[j].ShieldLife := adb.GetFieldValueInteger(iName, 'ShieldLife');
        LifeDataarr[j].ShieldArmor := adb.GetFieldValueInteger(iName, 'ShieldArmor');
        LifeDataarr[j].SayColor := adb.GetFieldValueInteger(iName, 'SayColor');

        atp.damageBody := adb.GetFieldValueInteger(iName, 'damageBody');
        atp.damageHead := adb.GetFieldValueInteger(iName, 'damageHead');
        atp.damageArm := adb.GetFieldValueInteger(iName, 'damageArm');
        atp.damageLeg := adb.GetFieldValueInteger(iName, 'damageLeg');

        atp.armorBody := adb.GetFieldValueInteger(iName, 'armorBody');
        atp.armorHead := adb.GetFieldValueInteger(iName, 'armorHead');
        atp.armorArm := adb.GetFieldValueInteger(iName, 'armorArm');
        atp.armorLeg := adb.GetFieldValueInteger(iName, 'armorLeg');

        atp.AttackSpeed := adb.GetFieldValueInteger(iName, 'AttackSpeed');
        atp.avoid := adb.GetFieldValueInteger(iName, 'avoid');
        atp.recovery := adb.GetFieldValueInteger(iName, 'recovery');
        atp.HitArmor := adb.GetFieldValueInteger(iName, 'HitArmor');

        atp.accuracy := adb.GetFieldValueInteger(iName, 'accuracy');
        LifeDataarr[j].LifeData := atp;

      end;
    end;
  finally
    adb.Free;
  end;

end;

procedure TPowerLevelSub.Clear();
begin
  fillchar(LifeDataarr, sizeof(TPowerLeveldata) * (Length(LifeDataarr)), 0); //2015.11.10 在水一方 内存泄露001
end;

constructor TPowerLevelSub.Create;
begin
  inherited Create;
  Clear;
  LoadFromSdb;
end;

destructor TPowerLevelSub.Destroy;
begin

  inherited destroy;
end;

procedure LoadGameIni(aName: string);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(aName);

  INI_WHO := ini.ReadString('STRINGS', 'WHO', '/WHO');
  INI_SERCHSKILL := ini.ReadString('STRINGS', 'SERCHSKILL', '@SERCHSKILL');
  INI_SERCHITEM := ini.ReadString('STRINGS', 'SERCHITEM', '钱币');
  INI_SERCHCOUNT := ini.Readinteger('STRINGS', 'SERCHCOUNT', 500);
  INI_WHITEDRUG := ini.ReadString('STRINGS', 'WHITEDRUG', 'WHITEDRUG');
  INI_ROPE := ini.ReadString('STRINGS', 'ROPE', 'ROPE');
  INI_SEX_FIELD_MAN := ini.ReadString('STRINGS', 'SEX_FIELD_MAN', 'MAN');
  INI_SEX_FIELD_WOMAN := ini.ReadString('STRINGS', 'SEX_FIELD_WOMAN', 'WOMAN');
  INI_GUILD_STONE := ini.ReadString('STRINGS', 'GUILD_STONE', 'GUILDSTONE');
  INI_GUILD_NPCMAN_NAME := ini.ReadString('STRINGS', 'GUILD_NPCMAN_NAME', 'NPCMAN');
  INI_GUILD_NPCWOMAN_NAME := ini.ReadString('STRINGS', 'GUILD_NPCWOMAN_NAME', 'NPCWOMAN');
  INI_GOLD := ini.ReadString('STRINGS', 'GOLD', '钱币');
  INI_DEFAULTGOLD := ini.ReadString('STRINGS', 'DEFAULTGOLD', '绑定钱币');
  INI_GAINAME := ini.ReadString('STRINGS', 'GAINAME', '改名卡');
  INI_HECHENG := ini.Readinteger('STRINGS', 'HECHENG', 0);
  INI_QIANGHUA := ini.Readinteger('STRINGS', 'QIANGHUA', 0);
  //INI_PAYTABLE := ini.ReadString('STRINGS', 'PAYTABLE', 'mqn_yb');
  INI_WEAPONGUILD := ini.Readinteger('STRINGS', 'WEAPONGUILD', 0);
  INI_GUILDDURABYHIT := ini.Readinteger('STRINGS', 'GUILDDURABYHIT', 20);
  INI_GUILDBAOHU := ini.Readinteger('STRINGS', 'GUILDBAOHU', 0);
  INI_NAIXING := ini.Readinteger('STRINGS', 'NAIXING', 0);
  INI_MONNAIXING := ini.Readinteger('STRINGS', 'MONNAIXING', 0);
  INI_BOWTOHIT := ini.Readinteger('STRINGS', 'BOWTOHIT', 0);
  INI_WEBIP := ini.ReadString('STRINGS', 'WEBIP', '0.0.0.0');
  INI_WEBPORT := ini.Readinteger('STRINGS', 'WEBPORT', 0);
  INI_ENERGYADD := ini.Readinteger('STRINGS', 'ENERGYADD', 0);

  INI_Guild_MAN_SEX := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_SEX', 'MAN');
  INI_Guild_MAN_CAP := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_CAP', '');
  INI_Guild_MAN_HAIR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_HAIR', '');
  INI_GUILD_MAN_UPUNDERWEAR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_UPUNDERWEAR', '');
  INI_Guild_MAN_UPOVERWEAR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_UPOVERWEAR', '');
  INI_Guild_MAN_DOWNUNDERWEAR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_DOWNUNDERWEAR', '');
  INI_Guild_MAN_GLOVES := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_GLOVES', '');
  INI_Guild_MAN_SHOES := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_SHOES', '');
  INI_Guild_MAN_WEAPON := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_MAN_WEAPON', '');

  INI_Guild_WOMAN_SEX := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_SEX', 'WOMAN');
  INI_Guild_WOMAN_CAP := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_CAP', '');
  INI_Guild_WOMAN_HAIR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_HAIR', '');
  INI_GUILD_WOMAN_UPUNDERWEAR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_UPUNDERWEAR', '');
  INI_Guild_WOMAN_UPOVERWEAR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_UPOVERWEAR', '');
  INI_Guild_WOMAN_DOWNUNDERWEAR := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_DOWNUNDERWEAR', '');
  INI_Guild_WOMAN_GLOVES := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_GLOVES', '');
  INI_Guild_WOMAN_SHOES := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_SHOES', '');
  INI_Guild_WOMAN_WEAPON := ini.ReadString('GUILD_NPC_WEAR', 'GUILD_WOMAN_WEAPON', '');

  INI_DEF_WRESTLING := ini.ReadString('DEFAULT_MAGIC', 'DEF_WRESTLING', 'WRESTLING');
  INI_DEF_FENCING := ini.ReadString('DEFAULT_MAGIC', 'DEF_FENCING', 'FENCING');
  INI_DEF_SWORDSHIP := ini.ReadString('DEFAULT_MAGIC', 'DEF_SWORDSHIP', 'SWORDSHIP');
  INI_DEF_HAMMERING := ini.ReadString('DEFAULT_MAGIC', 'DEF_HAMMERING', 'HAMMERING');
  INI_DEF_SPEARING := ini.ReadString('DEFAULT_MAGIC', 'DEF_SPEARING', 'SPEARING');
  INI_DEF_BOWING := ini.ReadString('DEFAULT_MAGIC', 'DEF_BOWING', 'BOWING');
  INI_DEF_THROWING := ini.ReadString('DEFAULT_MAGIC', 'DEF_THROWING', 'THROWING');
  INI_DEF_RUNNING := ini.ReadString('DEFAULT_MAGIC', 'DEF_RUNNING', 'RUNNING');
  INI_DEF_BREATHNG := ini.ReadString('DEFAULT_MAGIC', 'DEF_BREATHNG', 'BREATHNG');
  INI_DEF_PROTECTING := ini.ReadString('DEFAULT_MAGIC', 'DEF_PROTECTING', 'PROTECTING');
  //二层默认武功
  INI_DEF_WRESTLING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_WRESTLING2', 'WRESTLING2');
  INI_DEF_FENCING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_FENCING2', 'FENCING2');
  INI_DEF_SWORDSHIP2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_SWORDSHIP2', 'SWORDSHIP2');
  INI_DEF_HAMMERING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_HAMMERING2', 'HAMMERING2');
  INI_DEF_SPEARING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_SPEARING2', 'SPEARING2');
  INI_DEF_BOWING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_BOWING2', 'BOWING2');
  INI_DEF_THROWING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_THROWING2', 'THROWING2');
  INI_DEF_RUNNING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_RUNNING2', 'RUNNING2');
  INI_DEF_BREATHNG2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_BREATHNG2', 'BREATHNG2');
  INI_DEF_PROTECTING2 := ini.ReadString('DEFAULT_MAGIC', 'DEF_PROTECTING2', 'PROTECTING2');

  INI_NORTH := ini.ReadString('DIRECTION_NAMES', 'NORTH', 'NORTH');
  INI_NORTHEAST := ini.ReadString('DIRECTION_NAMES', 'NORTHEAST', 'NORTHEAST');
  INI_EAST := ini.ReadString('DIRECTION_NAMES', 'EAST', 'EAST');
  INI_EASTSOUTH := ini.ReadString('DIRECTION_NAMES', 'EASTSOUTH', 'EASTSOUTH');
  INI_SOUTH := ini.ReadString('DIRECTION_NAMES', 'SOUTH', 'SOUTH');
  INI_SOUTHWEST := ini.ReadString('DIRECTION_NAMES', 'SOUTHWEST', 'SOUTHWEST');
  INI_WEST := ini.ReadString('DIRECTION_NAMES', 'WEST', 'WEST');
  INI_WESTNORTH := ini.ReadString('DIRECTION_NAMES', 'WESTNORTH', 'WESTNORTH');

  INI_HIDEPAPER_DELAY := ini.Readinteger('ITEM_VALUES', 'HIDEPAPER_DELAY', 15);
  INI_SHOWPAPER_DELAY := ini.Readinteger('ITEM_VALUES', 'SHOWPAPER_DELAY', 60);

  INI_MAGIC_DIV_VALUE := ini.Readinteger('MAGIC_VALUES', 'MAGIC_DIV_VALUE', 10);
  INI_ADD_DAMAGE := ini.Readinteger('MAGIC_VALUES', 'ADD_DAMAGE', 40);
  INI_MUL_ATTACKSPEED := ini.Readinteger('MAGIC_VALUES', 'MUL_ATTACKSPEED', 10);
  INI_MUL_AVOID := ini.Readinteger('MAGIC_VALUES', 'MUL_AVOID', 6);
  INI_MUL_ACCURACY := ini.Readinteger('MAGIC_VALUES', 'MUL_ACCURACY', 6);

  INI_MUL_RECOVERY := ini.Readinteger('MAGIC_VALUES', 'MUL_RECOVERY', 10);
  INI_MUL_DAMAGEBODY := ini.Readinteger('MAGIC_VALUES', 'MUL_DAMAGEBODY', 23);
  INI_MUL_DAMAGEHEAD := ini.Readinteger('MAGIC_VALUES', 'MUL_DAMAGEHEAD', 17);
  INI_MUL_DAMAGEARM := ini.Readinteger('MAGIC_VALUES', 'MUL_DAMAGEARM', 17);
  INI_MUL_DAMAGELEG := ini.Readinteger('MAGIC_VALUES', 'MUL_DAMAGELEG', 17);
  INI_MUL_ARMORBODY := ini.Readinteger('MAGIC_VALUES', 'MUL_ARMORBODY', 7);
  INI_MUL_ARMORHEAD := ini.Readinteger('MAGIC_VALUES', 'MUL_ARMORHEAD', 7);
  INI_MUL_ARMORARM := ini.Readinteger('MAGIC_VALUES', 'MUL_ARMORARM', 7);
  INI_MUL_ARMORLEG := ini.Readinteger('MAGIC_VALUES', 'MUL_ARMORLEG', 7);

  INI_MUL_EVENTENERGY := ini.Readinteger('MAGIC_VALUES', 'MUL_EVENTENERGY', 20);
  INI_MUL_EVENTINPOWER := ini.Readinteger('MAGIC_VALUES', 'MUL_EVENTINPOWER', 22);
  INI_MUL_EVENTOUTPOWER := ini.Readinteger('MAGIC_VALUES', 'MUL_EVENTOUTPOWER', 22);
  INI_MUL_EVENTMAGIC := ini.Readinteger('MAGIC_VALUES', 'MUL_EVENTMAGIC', 10);
  INI_MUL_EVENTLIFE := ini.Readinteger('MAGIC_VALUES', 'MUL_EVENTLIFE', 8);

  INI_MUL_5SECENERGY := ini.Readinteger('MAGIC_VALUES', 'MUL_5SECENERGY', 20);
  INI_MUL_5SECINPOWER := ini.Readinteger('MAGIC_VALUES', 'MUL_5SECINPOWER', 14);
  INI_MUL_5SECOUTPOWER := ini.Readinteger('MAGIC_VALUES', 'MUL_5SECOUTPOWER', 14);
  INI_MUL_5SECMAGIC := ini.Readinteger('MAGIC_VALUES', 'MUL_5SECMAGIC', 9);
  INI_MUL_5SECLIFE := ini.Readinteger('MAGIC_VALUES', 'MUL_5SECLIFE', 8);

  INI_SKILL_DIV_DAMAGE := ini.Readinteger('MAGIC_VALUES', 'SKILL_DIV_DAMAGE', 5000);
  INI_SKILL_DIV_ARMOR := ini.Readinteger('MAGIC_VALUES', 'SKILL_DIV_ARMOR', 5000);
  INI_SKILL_DIV_ATTACKSPEED := ini.Readinteger('MAGIC_VALUES', 'SKILL_DIV_ATTACKSPEED', 25000);
  INI_SKILL_DIV_EVENT := ini.Readinteger('MAGIC_VALUES', 'SKILL_DIV_EVENT', 5000);



  INI_2SKILL_ADD_BASESKILL := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_ADD_BASESKILL', 0);
  INI_2SKILL_DIV_DAMAGE := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_DAMAGE', 5000);
  INI_2SKILL_DIV_ARMOR := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_ARMOR', 5000);
  INI_2SKILL_DIV_ATTACKSPEED := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_ATTACKSPEED', 25000);
  INI_2SKILL_DIV_RECOVERY := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_RECOVERY', 25000);
  INI_2SKILL_DIV_AVOID := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_AVOID', 25000);
  INI_2SKILL_DIV_ACCURACY := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_ACCURACY', 25000);
  INI_2SKILL_DIV_KEEPRECOVERY := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_KEEPRECOVERY', 25000);
  INI_2SKILL_DIV_EVENT := ini.Readinteger('RISEMAGIC_VALUES', 'SKILL_DIV_EVENT', 5000);

  INI_2MAGIC_DIV_VALUE := ini.Readinteger('RISEMAGIC_VALUES', 'MAGIC_DIV_VALUE', 10);
  INI_2ADD_DAMAGE := ini.Readinteger('RISEMAGIC_VALUES', 'ADD_DAMAGE', 40);
  INI_2MUL_ATTACKSPEED := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_ATTACKSPEED', 10);
  INI_2MUL_AVOID := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_AVOID', 6);
  INI_2MUL_RECOVERY := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_RECOVERY', 10);
  INI_2MUL_ACCURACY := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_ACCURACY', 6);


  INI_2MUL_KEEPRECOVERY := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_KEEPRECOVERY', 5);
  INI_2MUL_DAMAGEBODY := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_DAMAGEBODY', 23);
  INI_2MUL_DAMAGEHEAD := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_DAMAGEHEAD', 17);
  INI_2MUL_DAMAGEARM := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_DAMAGEARM', 17);
  INI_2MUL_DAMAGELEG := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_DAMAGELEG', 17);
  INI_2MUL_ARMORBODY := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_ARMORBODY', 7);
  INI_2MUL_ARMORHEAD := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_ARMORHEAD', 8);
  INI_2MUL_ARMORARM := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_ARMORARM', 8);
  INI_2MUL_ARMORLEG := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_ARMORLEG', 8);



  INI_2MUL_EVENTENERGY := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_EVENTENERGY', 20);
  INI_2MUL_EVENTINPOWER := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_EVENTINPOWER', 22);
  INI_2MUL_EVENTOUTPOWER := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_EVENTOUTPOWER', 22);
  INI_2MUL_EVENTMAGIC := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_EVENTMAGIC', 10);
  INI_2MUL_EVENTLIFE := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_EVENTLIFE', 8);


  INI_2MUL_5SECENERGY := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_5SECENERGY', 20);
  INI_2MUL_5SECINPOWER := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_5SECINPOWER', 14);
  INI_2MUL_5SECOUTPOWER := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_5SECOUTPOWER', 14);
  INI_2MUL_5SECMAGIC := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_5SECMAGIC', 9);
  INI_2MUL_5SECLIFE := ini.Readinteger('RISEMAGIC_VALUES', 'MUL_5SECLIFE', 8);

  INI_CREATEGUILDMAXNUM := ini.Readinteger('GUILD_CREATE', 'GUILD_MAXNUM', 20);
  INI_CREATEGUILDMAXLIFE := ini.Readinteger('GUILD_CREATE', 'GUILD_MAXLIFE', 1000000);

  //mysql 表格名称
  //INI_PAYTABLE := ini.ReadString('STRINGS', 'PAYTABLE', 'mqn_yb');
  INI_USERTABLE := ini.ReadString('MYSQL_TABLE', 'USERTABLE', 'mqn_values');
  INI_USERINFOTABLE := ini.ReadString('MYSQL_TABLE', 'USERINFOTABLE', 'mqn_user_info');
  INI_CONTACTTABLE := ini.ReadString('MYSQL_TABLE', 'CONTACTTABLE', 'mqn_contact');

  ini.free;
end;

//procedure SetWebLuaScript;
//var
//  aScript, afilename: string;
//begin
//  if not frmmain.IdHTTPServer1.Active then exit;
//
//  aScript := 'WebScript';
//  afilename := format('.\%s\%s\%s.lua', ['Script', 'lua', 'WebScript']);
//  if aScript = '' then
//  begin
//    FWebBaseLua := nil;
//    exit;
//  end;
//
//  if not FileExists(afilename) then
//    Exit;
//  if FWebBaseLua = nil then
//  begin
//
//    //判断是否有相同宿主名称脚本
//    if LuaScripterList.IsScripter(aScript) = false then
//    begin
//      FWebBaseLua := TLua.Create(false);
//      luaL_openlibs(FWebBaseLua.LuaInstance);
//      Lua_GroupScripteRegister(FWebBaseLua.LuaInstance); //NPC说话
//      if FWebBaseLua.DoFile(afilename) <> 0 then
//        frmMain.WriteLogInfo(format('Lua脚本错误 方法: %s f: %s', [afilename, lua_tostring(FWebBaseLua.LuaInstance, -1)]));
//      LuaScripterList.LoadFile(aScript, afilename, FWebBaseLua);
//    end;
//
//    //获取LUA脚本ID
//    if LuaScripterList.GetScripter(aScript, FWebBaseLua) = false then
//    begin
//      FWebBaseLua := nil;
//    end;
//  end;
//end;

function CallWebLuaScriptFunction(const Name: string; const Params: array of const): string;
var
  I: Integer;
  vi: Integer;
  vas: string;
  vd: Double;
  ItemData: TItemData;
begin

  if FWebBaseLua = nil then
    Exit;

  lua_pcall(FWebBaseLua.LuaInstance, 0, 0, 0);
  lua_getglobal(FWebBaseLua.LuaInstance, PChar(Name));
  for i := 0 to Length(Params) - 1 do
  begin
    case Params[i].VType of
      vtInteger:
        begin
          vi := Params[i].VInteger;
          lua_pushinteger(FWebBaseLua.LuaInstance, vi);
        end;
      vtAnsiString:
        begin
          vas := Params[i].VPChar;
          lua_pushstring(FWebBaseLua.LuaInstance, PAnsiChar(vas));
        end;
      vtBoolean:
        begin
          lua_pushboolean(FWebBaseLua.LuaInstance, Params[i].VBoolean);
        end;
      vtCurrency:
        begin
          vd := Params[i].VExtended^;
          lua_pushnumber(FWebBaseLua.LuaInstance, vd);
        end;

    end;

  end;

  if (lua_pcall(FWebBaseLua.LuaInstance, Length(Params), 1, 0) = 0) then
  begin
    Result := lua_tostring(FWebBaseLua.LuaInstance, -1);
  end;
end;

{ TItemUPLevelClass }

procedure TItemUPLevelClass.add(var aitem: TItemDataUPdataLevel);
var
  p: pItemDataUPdataLevel;
begin
  if get(aitem.rlevel) <> nil then exit;
  new(p);
  p^ := aitem;
  DataList.Add(p);
  AnsIndexClass.Insert(P.rlevel, p);
end;

procedure TItemUPLevelClass.clear;
var
  i: integer;
  p: pItemDataUPdataLevel;
begin

  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);

  end;

  DataList.Clear;
  AnsIndexClass.Clear;
end;

constructor TItemUPLevelClass.Create;
begin
  DataList := TList.Create;
  AnsIndexClass := TIntegerKeyClass.Create;
end;

destructor TItemUPLevelClass.Destroy;
begin
  clear;
  DataList.Free;
  AnsIndexClass.Free;
  inherited;
end;

function TItemUPLevelClass.get(alevel: integer): pItemDataUPdataLevel;
begin
  result := AnsIndexClass.Select(alevel);

end;

procedure TItemUPLevelClass.ReLoadFromFile;
var
  ItemDb: TUserStringDb;
  aitem: tItemDataUPdataLevel;
  i: integer;
  iName: string;
begin
  clear;
  ItemDb := TUserStringDb.Create;
  try
    if not FileExists('.\Init\ItemUPLevel.SDB') then exit;

    ItemDb.LoadFromFile('.\Init\ItemUPLevel.SDB');
    for i := 0 to ItemDb.Count - 1 do
    begin
      iName := ItemDb.GetIndexName(i);
      if ItemDb.GetDbString(iName) = '' then exit;
      aitem.rlevel := ItemDb.GetFieldValueInteger(iName, '等级');
      aitem.rmoney := ItemDb.GetFieldValueInteger(iName, '钱');
      aitem.rhuanxian := ItemDb.GetFieldValueInteger(iName, '幻仙');
      aitem.rPrestige := ItemDb.GetFieldValueInteger(iName, '荣誉');
      aitem.rBijou := ItemDb.GetFieldValueInteger(iName, '宝石');
      add(aitem);

    end;
  finally
    ItemDb.Free;
  end;

end;

{ TRandomDataClass }

procedure TRandomDataClass.add(aitem: TRandomData);
var
  p: PTRandomData;
begin
  p := get(aitem.rItemName);
  if p <> nil then exit;
  new(p);
  p^ := aitem;
  DataList.Add(p);
end;

procedure TRandomDataClass.clear;
var
  i: Integer;
  p: PTRandomData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
end;

constructor TRandomDataClass.Create;
begin
  DataList := TList.Create;
end;

destructor TRandomDataClass.Destroy;
begin
  clear;
  DataList.Free;
  inherited;
end;

function TRandomDataClass.get(aname: string): PTRandomData;
var
  i: Integer;
  p: PTRandomData;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p.rItemName = aname then
    begin
      result := p;
      exit;
    end;
  end;

end;

function TRandomDataClass.GetCount: integer;
begin
  result := DataList.Count;
end;

function TRandomDataClass.GetByIndex(aIndex: Integer): PTRandomData;
var
  pd: PTRandomData;
begin
  result := nil;
  if (aIndex < 0) and (aIndex > DataList.Count) then Exit;
  pd := DataList.Items[aIndex];
  if pd <> nil then Result := pd;
  exit;
end;

{ TMapPath }

procedure TMapPath.add(ax, ay, atime: integer);
var
  p: pTMapPathData;
begin
  new(p);
  p.x := ax;
  p.y := ay;
  p.time := atime;
  fdata.Add(p);
end;

procedure TMapPath.clear;
var
  i: integer;
  p: pTMapPathData;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    dispose(p);
  end;
  fdata.Clear;
end;

function TMapPath.count: integer;
begin
  result := fdata.Count;
end;

constructor TMapPath.Create;
begin
  fdata := TList.Create;
end;

procedure TMapPath.del(aindex: integer);
var
  p: pTMapPathData;
begin
  if (aindex < 0) or (aindex >= fdata.Count) then exit;
  p := fdata.Items[aindex];
  fdata.Delete(aindex);
  dispose(p);
end;

destructor TMapPath.Destroy;
begin
  clear;
  fdata.Free;
  inherited;
end;

function TMapPath.get(aindex: integer; var ax, ay, atime: integer): boolean;
var
  p: pTMapPathData;
begin
  result := false;
  if (aindex < 0) or (aindex >= fdata.Count) then exit;
  p := fdata.Items[aindex];
  ax := p.x;
  ay := p.y;
  atime := p.time;
  result := true;
end;
{ TMapPathList }

procedure TMapPathList.add(aid: integer);
var
  t: TMapPath;
begin
  if get(aid) <> nil then exit;
  t := TMapPath.Create;
  t.fID := aid;
  fdata.Add(t);
end;

procedure TMapPathList.clear;
var
  t: TMapPath;
  i: integer;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    t := fdata.Items[i];
    t.free;
  end;
  fdata.Clear;
end;

constructor TMapPathList.Create;
begin
  fdata := TList.Create;
  ReLoadFromFile;
end;

procedure TMapPathList.del(aid: integer);
var
  t: TMapPath;
  i: integer;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    t := fdata.Items[i];
    if t.fID = aid then
    begin
      fdata.Delete(i);
      t.Free;
      exit;
    end;
  end;

end;

destructor TMapPathList.Destroy;
begin
  clear;
  fdata.Free;
  inherited;
end;

function TMapPathList.get(aid: integer): TMapPath;
var
  t: TMapPath;
  i: integer;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    t := fdata.Items[i];
    if t.fID = aid then
    begin
      result := T;
      exit;
    end;
  end;

end;

procedure TMapPathList.ReLoadFromFile;
var
  i, j: integer;
  iName, aName: string;
  aid, ax, ay, atime: integer;
  StrDB: TUserStringDb;

  temp: TMapPath;
begin
  Clear;
  aName := '.\Init\MapPath.SDB';
  if not FileExists(aName) then exit;
  StrDB := TUserStringDb.Create;
  try
    StrDB.LoadFromFile(aName);
    for i := 0 to StrDb.Count - 1 do
    begin
      iName := StrDb.GetIndexName(i);
      if iName = '' then continue;
      aid := StrDB.GetFieldValueInteger(iName, 'ID');
      add(aid);
      temp := get(aid);
      if temp = nil then continue;
      for j := 0 to 20 - 1 do
      begin
        ax := StrDB.GetFieldValueInteger(iName, 'x' + inttostr(j));
        ay := StrDB.GetFieldValueInteger(iName, 'y' + inttostr(j));
        atime := StrDB.GetFieldValueInteger(iName, 'time' + inttostr(j));
        if (ax > 0) and (ay > 0) then temp.add(ax, ay, atime);
      end;
    end;
  finally
    StrDb.Free;
  end;
end;

{ TCheckItemClassList }

procedure TCheckItemClassList.add(aname: string);
var
  p: TCheckItemclass;
begin
  if get(aname) <> nil then exit;
  p := TCheckItemclass.Create;
  p.fname := aname;
  fdata.Add(p);
end;

procedure TCheckItemClassList.addItem(aMonsterName, aitemname: string; acount, aRandomCount: integer);
var
  p: TCheckItemclass;
  aitem: TCheckItem;
begin
  p := get(aMonsterName);
  if p = nil then
  begin
    add(aMonsterName);
    p := get(aMonsterName);
  end;
  if p = nil then exit;
  aitem.rName := aitemname;
  aitem.rCount := acount;
  aitem.rRandomCount := aRandomCount;
  p.add(aitem);
end;

procedure TCheckItemClassList.clear;
var
  i: integer;
  p: TCheckItemclass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    p.Free;
  end;
  fdata.Clear;

end;

constructor TCheckItemClassList.Create;
begin
  fdata := TList.Create;
end;

procedure TCheckItemClassList.del(aname: string);
var
  i: integer;
  p: TCheckItemclass;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.fname = aname then
    begin
      fdata.Delete(i);
      p.Free;
      exit;
    end;
  end;

end;

destructor TCheckItemClassList.Destroy;
begin
  clear;
  fdata.Free;

  inherited;
end;

function TCheckItemClassList.get(aname: string): TCheckItemclass;
var
  i: integer;
  p: TCheckItemclass;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.fname = aname then
    begin
      result := p;
      exit;
    end;
  end;

end;

procedure TCheckItemClassList.loadfilex(amonstername: string);
var
//  CheckItempp: TCheckItemclass;
  icount, i, iRandomCount: Integer;
 // tt: TCheckItem;
  sDbfile: TUserStringDb;
  mname, mcount, iname: string;
  str, afile: string;
begin
  afile := extractfilepath(ParamStr(0)) + '\init\dropfile.sdb';
  if FileExists(afile) = false then exit;
  add(amonstername);
   //Name,Count,RandomCount
  sDbfile := TUserStringDb.Create;
  try
    sDbfile.LoadFromFile(afile);
 // if aMonsterName='牛' then
  //aMonsterName:=aMonsterName;
    str := sDbfile.GetFieldValueString(aMonsterName, 'HaveItem');
    for i := 0 to 9 do
    begin
      if str = '' then break;
      str := GetValidStr3(str, mName, ':');
      if mName = '' then break;
      str := GetValidStr3(str, mCount, ':');
      if mCount = '' then break;
      iCount := _StrToInt(mCount);
      if iCount <= 0 then break;
      str := GetValidStr3(str, mCount, ':');
      if mCount = '' then break;
      iRandomCount := _StrToInt(mCount);
      if iRandomCount <= 0 then iRandomCount := 1;

      addItem(aMonsterName, mName, iCount, iRandomCount);
//        MonsterData.rHaveItem[i].rName := mName;
 //       MonsterData.rHaveItem[i].rCount := iCount;

      RandomClass.AddData(mName, aMonsterName, iRandomCount);
    end;
           {
    for i := 0 to sDbfile.Count - 1 do
    begin
      iname := sDbfile.GetIndexName(i);
    //  tt.mName := sDbfile.GetFieldValueString(iname, 'mName');
      tt.rName := sDbfile.GetFieldValueString(iname, 'Name');
      tt.rCount := sDbfile.GetFieldValueInteger(iname, 'Count');
      iRandomCount := sDbfile.GetFieldValueInteger(iname, 'RandomCount');
      tt.rRandomCount := iRandomCount;
      if tt.rCount <= 0 then Continue;
      if iRandomCount <= 0 then iRandomCount := 1;

   //   CheckItempp.add(tt);
    if amonstername=iname then
    begin
     addItem(aMonsterName, tt.rName, tt.rCount, tt.rRandomCount);
     RandomClass.AddData(tt.rName, amonsterName, iRandomCount);
    end;
    end;
    {if amonstername=tt.mName then
     add(tt.mName);
     CheckItempp := get(tt.mName);
     if CheckItempp = nil then exit;  }
  finally
    sDbfile.Free;
  end;
end;
{procedure TCheckItemClassList.loadfile(aname, afile: string);
var
  CheckItempp: TCheckItemclass;
  i, iRandomCount: Integer;
  tt: TCheckItem;
  sDbfile: TUserStringDb;
  iname: string;
begin
  afile := afile + '.sdb';
  if FileExists(afile) = false then exit;
  add(aname);
  CheckItempp := get(aname);
  if CheckItempp = nil then exit;

   //Name,Count,RandomCount
  sDbfile := TUserStringDb.Create;
  try
    sDbfile.LoadFromFile(afile);
    for i := 0 to sDbfile.Count - 1 do
    begin
      iname := sDbfile.GetIndexName(i);
      tt.rName := sDbfile.GetFieldValueString(iname, 'Name');
      tt.rCount := sDbfile.GetFieldValueInteger(iname, 'Count');
      iRandomCount := sDbfile.GetFieldValueInteger(iname, 'RandomCount');
      tt.rRandomCount := iRandomCount;
      if tt.rCount <= 0 then Continue;
      if iRandomCount <= 0 then iRandomCount := 1;

      CheckItempp.add(tt);
      RandomClass.AddData(tt.rName, aname, iRandomCount);
    end;
  finally
    sDbfile.Free;
  end;
end;  }

procedure TCheckItemClassList.loadfileMap(afilename: string);
var
  tempList, tempItem, temp2: tstringlist;
  i, j, iRandomCount: Integer;
  scount, sRandomCount: string;
  str, aMopName, aitemname: string;
  tt: TCheckItem;
  CheckItempp: TCheckItemclass;
begin
  if FileExists(afilename) = false then exit;
  tempList := tstringlist.Create;
  tempItem := tstringlist.Create;
  temp2 := tstringlist.Create;
  try
    tempList.LoadFromFile(afilename);
    if tempList.Count >= 2 then
    begin
      str := tempList.Strings[0];
      tempItem.Text := StringReplace(str, ',', #13#10, [rfReplaceAll]);
      for i := 1 to tempList.Count - 1 do
      begin
        str := tempList.Strings[i];
        temp2.Text := StringReplace(str, ',', #13#10, [rfReplaceAll]);
                //
        aMopName := temp2.Strings[0];
        add(aMopName);
        CheckItempp := get(aMopName);
        if CheckItempp <> nil then
        begin
          for j := 1 to temp2.Count - 1 do
          begin
            if j > tempItem.Count - 1 then Break;
            aitemname := tempItem.Strings[j];
            str := temp2.Strings[j];
            if str <> '' then
            begin
              str := GetValidStr3(str, scount, ';');
              str := GetValidStr3(str, sRandomCount, ';');
              if (scount <> '') and (sRandomCount <> '') then
              begin
                tt.rCount := _StrToInt(scount);
                iRandomCount := _StrToInt(sRandomCount);
                tt.rRandomCount := iRandomCount;
                if tt.rCount <= 0 then Continue;
                if iRandomCount <= 0 then iRandomCount := 1;
                tt.rName := copy(aitemname, 1, 20);
                CheckItempp.add(tt);
                RandomClass.AddData(aitemname, aMopName, iRandomCount);
              end;
            end;

          end;
        end;
      end;
    end;
  finally
    temp2.free;
    tempItem.free;
    tempList.Free;
  end;

end;

procedure TCheckItemClassList.savefile;
var
  i, j: integer;
  CheckItemclass: TCheckItemclass;
  afileName, str: string;
  tempString: tstringlist;
  p: pTCheckItem;
begin
  tempString := tstringlist.Create;
  try
    for i := 0 to fdata.Count - 1 do
    begin
      CheckItemclass := fdata.Items[i];
      if CheckItemclass = nil then Continue;
      tempString.Clear;
      afileName := '.\Init\DropItem\' + CheckItemclass.fname + '.sdb';
      str := 'Name,Count,RandomCount,';
      tempString.Add(str);
      for j := 0 to CheckItemclass.Count - 1 do
      begin
        p := CheckItemclass.getIndex(j);
        if p = nil then Continue;
        str := p.rName + ',' + inttostr(p.rCount) + ',' + inttostr(p.rRandomCount) + ',';
        tempString.Add(str);
      end;
      tempString.SaveToFile(afileName);
    end;

  finally
    tempString.Free;
  end;
end;

{ TCheckItemclass }

procedure TCheckItemclass.add(aitem: TCheckItem);
var
  p: pTCheckItem;
begin
  if get(aitem.rName) <> nil then exit;
  new(p);
  p^ := aitem;
  fdata.Add(p);
end;

procedure TCheckItemclass.clear;
var
  i: integer;
  p: pTCheckItem;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    dispose(p);
  end;
  fdata.Clear;

end;

function TCheckItemclass.Count: integer;
begin
  result := fdata.Count;
end;

constructor TCheckItemclass.Create;
begin
  fdata := tlist.Create;
end;

procedure TCheckItemclass.del(aname: string);
var
  i: integer;
  p: pTCheckItem;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.rName = aname then
    begin
      fdata.Delete(i);
      dispose(p);
      exit;
    end;
  end;
end;

destructor TCheckItemclass.Destroy;
begin
  clear;
  fdata.Free;
  inherited;
end;

function TCheckItemclass.get(aname: string): pTCheckItem;
var
  i: integer;
  p: pTCheckItem;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.rName = aname then
    begin
      result := p;
      exit;
    end;
  end;
end;


function TCheckItemclass.getIndex(aindex: integer): pTCheckItem;
begin
  result := nil;
  if (aindex < 0) or (aindex >= fdata.Count) then exit;
  result := fdata.Items[aindex];

end;





{ TMineClass }

procedure TMineClass.add(var adata: TMineData);
var
  p: pTMineData;
begin

  if get(adata.Name) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);
  NameIndexClass.Insert(adata.Name, p);

end;

procedure TMineClass.Clear;
var
  i: Integer;
  p: pTMineData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
  NameIndexClass.Clear;
end;

constructor TMineClass.Create;
begin
  DataList := TList.Create;
  NameIndexClass := TStringKeyClass.Create;
  loadfile;
end;

destructor TMineClass.Destroy;
begin
  Clear;
  DataList.Free;
  NameIndexClass.Free;
  inherited;
end;

function TMineClass.get(aName: string): pTMineData;
begin
  result := NameIndexClass.Select(aName);
end;

procedure TMineClass.loadfile;
var
  i, j: integer;
  temp: TMineData;
  filesdb: TUserStringDb;
  mcount, mName, str, iName, FileName: string;
begin
  FileName := '.\Init\MineObject.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.ViewName := filesdb.GetFieldValueString(iName, 'ViewName');
      temp.PickConst := filesdb.GetFieldValueInteger(iName, 'PickConst');
      temp.Sound := filesdb.GetFieldValueInteger(iName, 'Sound');

      str := filesdb.GetFieldValueString(iName, 'Deposits');
      for j := 0 to high(temp.DepositsArr) do
      begin
        if str = '' then Break;
        str := GetValidStr3(str, mCount, ':');
        if (mCount <> '') then
        begin
          temp.DepositsArr[j] := _StrToInt(mcount);
        end;
      end;
      for j := 0 to high(temp.ItemArr) do
      begin
        temp.ItemArr[j] := filesdb.GetFieldValueString(iName, 'Item' + inttostr(j + 1));
      end;

      str := filesdb.GetFieldValueString(iName, 'RegenIntervals');
      for j := 0 to high(temp.RegenIntervalsArr) do
      begin
        if str = '' then Break;
        str := GetValidStr3(str, mCount, ':');
        if (mCount <> '') then
        begin
          temp.RegenIntervalsArr[j] := _StrToInt(mcount);
        end;
      end;

      str := filesdb.GetFieldValueString(iName, 'DropMop');
      if str <> '' then
      begin
        str := GetValidStr3(str, mName, ':');
        str := GetValidStr3(str, mCount, ':');
        if (mName <> '') and (mCount <> '') then
        begin
          temp.DropMopName := copy(mName, 1, 20);
          temp.DropMopCount := _StrToInt(mcount);
        end;
      end;
      add(temp);
    end;

  finally
    filesdb.Free;
  end;


end;

{ TMineShapeClass }

procedure TMineShapeClass.add(var adata: TMineShapeData);
var
  p: pTMineShapeData;
begin
  if get(adata.Shape) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);

  ShapeIndexClass.Insert(adata.Shape, p);

end;

procedure TMineShapeClass.Clear;
var
  i: Integer;
  p: pTMineShapeData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
  ShapeIndexClass.Clear;
end;

constructor TMineShapeClass.Create;
begin
  DataList := TList.Create;
  ShapeIndexClass := TIntegerKeyClass.Create;
  loadfile;
end;

destructor TMineShapeClass.Destroy;
begin
  Clear;
  DataList.Free;
  ShapeIndexClass.Free;
  inherited;
end;

function TMineShapeClass.get(ashape: integer): pTMineShapeData;
begin
  result := ShapeIndexClass.Select(ashape);
end;

procedure TMineShapeClass.loadfile;
var
  i, j, xx, yy: integer;
  temp: TMineShapeData;
  filesdb: TUserStringDb;
  str, iName, rdStr, FileName: string;
begin
  FileName := '.\Init\MineObjectShape.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
        //Name,Shape,SStep,EStep,GuardPos
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.Shape := filesdb.GetFieldValueInteger(iName, 'Shape');
      temp.SStep := filesdb.GetFieldValueInteger(iName, 'SStep');
      temp.EStep := filesdb.GetFieldValueInteger(iName, 'EStep');

      Str := filesdb.GetFieldValueString(iName, 'GuardPos');
      for j := 0 to 10 - 1 do
      begin
        Str := GetValidStr3(Str, rdStr, ':');
        xx := _StrToInt(rdStr);
        Str := GetValidStr3(Str, rdStr, ':');
        yy := _StrToInt(rdStr);
        if (xx = 0) and (yy = 0) then break;

        temp.GuardXArr[j] := xx;
        temp.GuardYArr[j] := yy;
      end;
      add(temp);
    end;

  finally
    filesdb.Free;
  end;


end;

{ TMineAvailClass }

procedure TMineAvailClass.add(var adata: TMineAvailData);
var
  p: pTMineAvailData;
begin
  if get(adata.GroupName) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);
  GroupNameIndexClass.Insert(adata.GroupName, p);

end;

procedure TMineAvailClass.Clear;
var
  i: Integer;
  p: pTMineAvailData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
  GroupNameIndexClass.Clear;
end;

constructor TMineAvailClass.Create;
begin
  DataList := TList.Create;
  GroupNameIndexClass := TStringKeyClass.Create;
  loadfile;
end;

destructor TMineAvailClass.Destroy;
begin
  Clear;
  DataList.Free;
  GroupNameIndexClass.Free;
  inherited;
end;

function TMineAvailClass.get(aGroupName: string): pTMineAvailData;
begin
  result := GroupNameIndexClass.Select(aGroupName);
end;

procedure TMineAvailClass.loadfile;
var
  i, j: integer;
  temp: TMineAvailData;
  filesdb: TUserStringDb;
  Scount, Ecount, mName, str, iName, FileName: string;
begin
  FileName := '.\Init\MineObjectAvail.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.GroupName := filesdb.GetFieldValueString(iName, 'GroupName');
      temp.MapID := filesdb.GetFieldValueInteger(iName, 'MapID');
      temp.PositionCount := filesdb.GetFieldValueInteger(iName, 'PositionCount');
      temp.SettingCount := filesdb.GetFieldValueInteger(iName, 'SettingCount');
      temp.Desc := filesdb.GetFieldValueString(iName, 'Desc');


      for j := 0 to high(temp.MineArr) do
      begin
        str := filesdb.GetFieldValueString(iName, 'Mine' + inttostr(j + 1));
        if str = '' then Continue;
        str := GetValidStr3(str, mName, ':');
        str := GetValidStr3(str, Scount, ':');
        str := GetValidStr3(str, Ecount, ':');
        if (mName <> '') and (Scount <> '') and (Ecount <> '') then
        begin
          temp.MineArr[j] := mName;
          temp.MineSArr[j] := _StrToInt(Scount);
          temp.MineEArr[j] := _StrToInt(Ecount);
        end;
      end;

      add(temp);
    end;

  finally
    filesdb.Free;
  end;


end;

{ TToolRateClass }

procedure TToolRateClass.add(var adata: TToolRateData);
var
  p: pTToolRateData;
begin
  if get(adata.Tool) <> nil then exit;
  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TToolRateClass.Clear;
var
  i: Integer;
  p: pTToolRateData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;

end;

constructor TToolRateClass.Create;
begin
  DataList := TList.Create;

end;

destructor TToolRateClass.Destroy;
begin
  Clear;
  DataList.Free;

  inherited;
end;

function TToolRateClass.get(atool: string): pTToolRateData;
var
  i: Integer;
  p: pTToolRateData;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if (p.Tool = atool) then
    begin
      result := p;
      exit;
    end;
  end;

end;


{ TToolRateListClass }

procedure TToolRateListClass.add(aMine: string);
var
  cp: TToolRateClass;
begin
  if get(aMine) <> nil then exit;
  cp := TToolRateClass.Create;
  cp.fname := aMine;
  DataList.Add(cp);
end;

procedure TToolRateListClass.Clear;
var
  i: integer;
  cp: TToolRateClass;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    cp := DataList.Items[i];
    cp.Free;
  end;

  DataList.Clear;
end;

constructor TToolRateListClass.Create;
begin
  DataList := TList.Create;
  loadfile;
end;

destructor TToolRateListClass.Destroy;
begin
  Clear;
  DataList.Free;
  inherited;
end;

function TToolRateListClass.get(aMine: string): TToolRateClass;
var
  i: integer;
  cp: TToolRateClass;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    cp := DataList.Items[i];
    if cp.fname = aMine then
    begin
      result := cp;
      exit;
    end;
  end;
end;

procedure TToolRateListClass.loadfile;
var
  i, j: integer;
  temp: TToolRateData;
  filesdb: TUserStringDb;
  iName, FileName: string;
  cp: TToolRateClass;
begin
  FileName := '.\Init\ToolRate.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.Mine := filesdb.GetFieldValueString(iName, 'Mine');
      temp.Tool := filesdb.GetFieldValueString(iName, 'Tool');

      for j := 0 to high(temp.SFreqArr) do
      begin
        temp.SFreqArr[j] := filesdb.GetFieldValueInteger(iName, 'SFreq' + inttostr(j + 1));
      end;
      for j := 0 to high(temp.EFreqArr) do
      begin
        temp.EFreqArr[j] := filesdb.GetFieldValueInteger(iName, 'EFreq' + inttostr(j + 1));
      end;

      cp := get(temp.Mine);
      if cp = nil then
      begin
        add(temp.Mine);
        cp := get(temp.Mine);
        if cp = nil then exit;
      end;
      cp.add(temp);
    end;

  finally
    filesdb.Free;
  end;


end;

{ TJobGradeClass }

procedure TJobGradeClass.add(var adata: TJobGradeData);
var
  p: pTJobGradeData;
begin
  if get(adata.ViewName) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TJobGradeClass.Clear;
var
  i: Integer;
  p: pTJobGradeData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;

end;

constructor TJobGradeClass.Create;
begin
  DataList := TList.Create;
  loadfile;
end;

destructor TJobGradeClass.Destroy;
begin
  Clear;
  DataList.free;
  inherited;
end;

function TJobGradeClass.get(aname: string): pTJobGradeData;
var
  i: Integer;
  p: pTJobGradeData;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p.ViewName = aname then
    begin
      result := p;
      exit;
    end;
  end;

end;

function TJobGradeClass.getLevle(aLevel: integer): pTJobGradeData;
var
  i: Integer;
  p: pTJobGradeData;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if (aLevel >= p.StartLevel) and (aLevel <= p.EndLevel) then
    begin
      result := p;
      exit;
    end;
  end;

end;

procedure TJobGradeClass.loadfile;
var
  i, j: integer;
  temp: TJobGradeData;
  filesdb: TUserStringDb;
  str, iName, FileName: string;
  tepitemdata: titemdata;
begin
//Name,ViewName,Grade,StartLevel,EndLevel,MaxItemGrade,1Grade,,Alchemist,Chemist,Designer,Craftsman
  FileName := '.\Init\JobGrade.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.ViewName := filesdb.GetFieldValueString(iName, 'ViewName');
      temp.Grade := filesdb.GetFieldValueInteger(iName, 'Grade');
      temp.StartLevel := filesdb.GetFieldValueInteger(iName, 'StartLevel');
      temp.EndLevel := filesdb.GetFieldValueInteger(iName, 'EndLevel');
      temp.MaxItemGrade := filesdb.GetFieldValueInteger(iName, 'MaxItemGrade');

      str := filesdb.GetFieldValueString(iName, 'Alchemist');
      if ItemClass.GetItemData(str, tepitemdata) then
      begin
        temp.Alchemist := tepitemdata.rViewName;
        temp.AlchemistShape := tepitemdata.rShape;
      end;
      str := filesdb.GetFieldValueString(iName, 'Chemist');
      if ItemClass.GetItemData(str, tepitemdata) then
      begin
        temp.Chemist := tepitemdata.rViewName;
        temp.ChemistShape := tepitemdata.rShape;
      end;
      str := filesdb.GetFieldValueString(iName, 'Designer');
      if ItemClass.GetItemData(str, tepitemdata) then
      begin
        temp.Designer := tepitemdata.rViewName;
        temp.DesignerShape := tepitemdata.rShape;
      end;
      str := filesdb.GetFieldValueString(iName, 'Craftsman');
      if ItemClass.GetItemData(str, tepitemdata) then
      begin
        temp.Craftsman := tepitemdata.rViewName;
        temp.CraftsmanShape := tepitemdata.rShape;
      end;

      for j := 0 to high(temp.GradeArr) do
      begin
        temp.GradeArr[j] := filesdb.GetFieldValueInteger(iName, inttostr(j + 1) + 'Grade');
      end;

      add(temp);
    end;

  finally
    filesdb.Free;
  end;


end;

{ TLifeDataClass }

procedure TItemLifeDataClass.add(var adata: TItemLifeData);
var
  p: pTItemLifeData;
begin
  if get(adata.Name) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);
  NameIndexClass.Insert(adata.Name, p);

end;

procedure TItemLifeDataClass.Clear;
var
  i: Integer;
  p: pTItemLifeData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
  NameIndexClass.Clear;
end;

constructor TItemLifeDataClass.Create;
begin
  DataList := TList.Create;
  NameIndexClass := TStringKeyClass.Create;
  loadfile;
end;

destructor TItemLifeDataClass.Destroy;
begin
  Clear;
  DataList.Free;
  NameIndexClass.Free;
  inherited;
end;

function TItemLifeDataClass.get(aName: string): pTItemLifeData;
begin
  result := NameIndexClass.Select(aName);
end;

function TItemLifeDataClass.getItemStarLevel(alevel: integer; out aLifeData: TLifeData): boolean;
begin
  result := false;
  if (alevel < 0) or (alevel > high(ItemStarLevelArr)) then
  begin
    fillchar(aLifeData, sizeof(TLifeData), 0);
    exit;
  end;
  aLifeData := ItemStarLevelArr[alevel];
  result := true;

end;




function TItemLifeDataClass.getItemUPdateLevel(aGrade, apos, alevel: integer; out aLifeData: TLifeData): boolean;
begin
  result := false;
  if (aGrade < 0) or (aGrade > 20) or (apos < 0) or (apos > 20) or (alevel < 0) or (alevel > 20) then
  begin
    fillchar(aLifeData, sizeof(TLifeData), 0);
    exit;
  end;
    //本级 百分比
  aLifeData := FItemUPdateLevelArr[alevel, apos, aGrade];
  result := true;
end;

function TItemLifeDataClass.GetItemData(aName: string; out aItemLifeData: TItemLifeData): boolean;
var
  p: pTItemLifeData;
begin
  Result := false;
  p := get(aName);
  if p = nil then
  begin
    fillchar(aItemLifeData, sizeof(TItemLifeData), 0);
    exit;
  end;
  aItemLifeData := p^;
  Result := true;
end;

procedure TItemLifeDataClass.loadfile;
var
  i, j, n: integer;
  temp: TItemLifeData;
  tempLevel: TItemLifeData;
  tempPosMax: TItemLifeData;
  tempMBfb: TItemLifeData;
  filesdb: TUserStringDb;
  iName, FileName: string;
  temp2: TItemLifeData;

            //本级，本部位，最大值百分比（0-20部位，0-20级别）
  ItemUPdateLevelArr: array[0..20, 0..20] of TLifeData;
        //部位位置MAX（0-20部位，0-20品级）
//    ItemUPdateLevelPosMaxArr: array[0..20, 0..20] of TLifeData;
  procedure _TItemLifeDataMul(var aItemLifeData1, aItemLifeData2, aItemLifeDataOut: TItemLifeData);
  begin
    fillchar(aItemLifeDataOut, sizeof(aItemLifeDataOut), 0);
    if (aItemLifeData1.LifeData.damageBody > 0) and (aItemLifeData2.LifeData.damageBody > 0) then
      aItemLifeDataOut.LifeData.damageBody := aItemLifeData1.LifeData.damageBody * aItemLifeData2.LifeData.damageBody div 100;
    if (aItemLifeData1.LifeData.damageHead > 0) and (aItemLifeData2.LifeData.damageHead > 0) then
      aItemLifeDataOut.LifeData.damageHead := aItemLifeData1.LifeData.damageHead * aItemLifeData2.LifeData.damageHead div 100;
    if (aItemLifeData1.LifeData.damageArm > 0) and (aItemLifeData2.LifeData.damageArm > 0) then
      aItemLifeDataOut.LifeData.damageArm := aItemLifeData1.LifeData.damageArm * aItemLifeData2.LifeData.damageArm div 100;
    if (aItemLifeData1.LifeData.damageLeg > 0) and (aItemLifeData2.LifeData.damageLeg > 0) then
      aItemLifeDataOut.LifeData.damageLeg := aItemLifeData1.LifeData.damageLeg * aItemLifeData2.LifeData.damageLeg div 100;

    if (aItemLifeData1.LifeData.armorBody > 0) and (aItemLifeData2.LifeData.armorBody > 0) then
      aItemLifeDataOut.LifeData.armorBody := aItemLifeData1.LifeData.armorBody * aItemLifeData2.LifeData.armorBody div 100;
    if (aItemLifeData1.LifeData.armorHead > 0) and (aItemLifeData2.LifeData.armorHead > 0) then
      aItemLifeDataOut.LifeData.armorHead := aItemLifeData1.LifeData.armorHead * aItemLifeData2.LifeData.armorHead div 100;
    if (aItemLifeData1.LifeData.armorArm > 0) and (aItemLifeData2.LifeData.armorArm > 0) then
      aItemLifeDataOut.LifeData.armorArm := aItemLifeData1.LifeData.armorArm * aItemLifeData2.LifeData.armorArm div 100;
    if (aItemLifeData1.LifeData.armorLeg > 0) and (aItemLifeData2.LifeData.armorLeg > 0) then
      aItemLifeDataOut.LifeData.armorLeg := aItemLifeData1.LifeData.armorLeg * aItemLifeData2.LifeData.armorLeg div 100;
  end;

begin
  FileName := '.\Init\ItemLifeData.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.ViewName := filesdb.GetFieldValueString(iName, 'ViewName');

      temp.LifeData.DamageBody := filesdb.GetFieldValueinteger(iName, 'DamageBody');
      temp.LifeData.DamageHead := filesdb.GetFieldValueinteger(iName, 'DamageHead');
      temp.LifeData.DamageArm := filesdb.GetFieldValueinteger(iName, 'DamageArm');
      temp.LifeData.DamageLeg := filesdb.GetFieldValueinteger(iName, 'DamageLeg');

      temp.LifeData.ArmorBody := filesdb.GetFieldValueinteger(iName, 'ArmorBody');
      temp.LifeData.ArmorHead := filesdb.GetFieldValueinteger(iName, 'ArmorHead');
      temp.LifeData.ArmorArm := filesdb.GetFieldValueinteger(iName, 'ArmorArm');
      temp.LifeData.ArmorLeg := filesdb.GetFieldValueinteger(iName, 'ArmorLeg');

      temp.LifeData.AttackSpeed := 0 - filesdb.GetFieldValueinteger(iName, 'AttackSpeed');
      temp.LifeData.Recovery := 0 - filesdb.GetFieldValueinteger(iName, 'Recovery');
      temp.LifeData.Avoid := filesdb.GetFieldValueinteger(iName, 'Avoid');
      temp.LifeData.accuracy := filesdb.GetFieldValueinteger(iName, 'accuracy');

      add(temp);
    end;

  finally
    filesdb.Free;
  end;



  GetItemData('X天', temp);
  LifeData3f_sky := temp.LifeData;
  GetItemData('X地', temp);
  LifeData3f_terra := temp.LifeData;
  GetItemData('X人', temp);
  LifeData3f_fetch := temp.LifeData;

  GetItemData('X武者职业0', temp); //20131015添加
  lifedatajob0 := temp.LifeData;
  GetItemData('X武者职业1', temp); //20131015添加
  lifedatajob1 := temp.LifeData;
  GetItemData('X武者职业2', temp); //20131015添加
  lifedatajob2 := temp.LifeData;
  GetItemData('X武者职业3', temp); //20131015添加
  lifedatajob3 := temp.LifeData;
  GetItemData('X武者职业4', temp); //20131015添加
  lifedatajob4 := temp.LifeData;
  GetItemData('X武者职业5', temp); //20131015添加
  lifedatajob5 := temp.LifeData;
  GetItemData('X武者职业6', temp); //20131015添加
  lifedatajob6 := temp.LifeData;

    //部位
 { for i := 0 to 20 do
  begin
    //等级
    for j := 0 to 20 do
    begin
      GetItemData(format('X精炼%dX%d', [i, j]), temp);
      ItemUPdateLevelArr[i, j] := temp.LifeData;

    end;
  end;
  FillChar(FItemUPdateLevelArr, sizeof(FItemUPdateLevelArr), 0);
    //部位
  for i := 0 to 20 do
  begin
    if not GetItemData(format('X精炼%dBMAX', [i]), tempPosMax) then Continue;
        //品级
    for j := 0 to 20 do
    begin
      if not GetItemData(format('X精炼%dMLBFB', [j]), tempMBfb) then Continue;
      _TItemLifeDataMul(tempPosMax, tempMBfb, temp);
            //等级
      for n := 0 to 20 do
      begin
             //(等级，部位，品级)
        tempLevel.LifeData := ItemUPdateLevelArr[i, n];
        _TItemLifeDataMul(tempLevel, temp, temp2);
        FItemUPdateLevelArr[n, i, j] := temp2.LifeData;
      end;
    end;
  end;

   }


  for j := 0 to 10 do
  begin
    GetItemData(format('X星级%d', [j]), temp);
    ItemStarLevelArr[j] := temp.LifeData;
  end;
  GetItemData('X满级武功攻击', temp);
  LifeDataMagicAttack := temp.LifeData;
  GetItemData('X满级武功护体', temp);
  LifeDataMagicProtect := temp.LifeData;
  GetItemData('X满级武功心法', temp);
  LifeDataMagicBREATHNG := temp.LifeData;
  GetItemData('X满级武功步法', temp);
  LifeDataMagicWalking := temp.LifeData;
  GetItemData('X满级武功辅助', temp);
  LifeDataMagicEct := temp.LifeData;

  AttachClass.ReLoadFromFile(self);


end;

{ TWeaponLevelColorClass }

procedure TWeaponLevelColorClass.add(var adata: TWeaponLevelColorData);
var
  p: pTWeaponLevelColorData;
begin
  if get(adata.ViewName) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TWeaponLevelColorClass.Clear;
var
  i: Integer;
  p: pTWeaponLevelColorData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;

end;


constructor TWeaponLevelColorClass.Create;
begin
  DataList := TList.Create;
  loadfile;
end;

destructor TWeaponLevelColorClass.Destroy;
begin
  Clear;
  DataList.free;
  inherited;
end;

function TWeaponLevelColorClass.get(aname: string): pTWeaponLevelColorData;
var
  i: Integer;
  p: pTWeaponLevelColorData;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p.Name = aname then
    begin
      result := p;
      exit;
    end;
  end;

end;


procedure TWeaponLevelColorClass.loadfile;
var
  i, j: integer;
  temp: TWeaponLevelColorData;
  filesdb: TUserStringDb;
  iName, FileName: string;
begin
//Name,ViewName,L0,L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L20,
  FileName := '.\Init\WeaponLevelColor.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.ViewName := filesdb.GetFieldValueString(iName, 'ViewName');

      for j := 0 to high(temp.LevelArr) do
      begin
        temp.LevelArr[j] := ColorSysToDxColor(filesdb.GetFieldValueInteger(iName, 'L' + inttostr(j)));
      end;
      add(temp);
    end;

  finally
    filesdb.Free;
  end;


end;

{ TMaterialClass }

procedure TMaterialClass.add(var adata: TMaterialData);
var
  p: pTMaterialData;
begin
  if get(adata.Name) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TMaterialClass.Clear;
var
  i: Integer;
  p: pTMaterialData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;

end;

constructor TMaterialClass.Create;
begin
  DataList := TList.Create;
  loadfile;
end;

destructor TMaterialClass.Destroy;
begin
  Clear;
  DataList.free;
  inherited;
end;

function TMaterialClass.get(aname: string): pTMaterialData;
var
  i: Integer;
  p: pTMaterialData;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    if p.Name = aname then
    begin
      result := p;
      exit;
    end;
  end;

end;


procedure TMaterialClass.loadfile;
var
  i, j: integer;
  temp: TMaterialData;
  filesdb: TUserStringDb;
  str, iName, FileName: string;
  tepitemdata: titemdata;
begin
//Name,name0,count0,name1,count1,name2,count2,name3,count3
  FileName := '.\Init\ItemMaterial.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      for j := 0 to high(temp.NameArr) do
      begin
        temp.NameArr[j] := filesdb.GetFieldValueString(iName, 'Name' + inttostr(j));
        temp.CountArr[j] := filesdb.GetFieldValueInteger(iName, 'count' + inttostr(j));
      end;
      add(temp);
    end;

  finally
    filesdb.Free;
  end;


end;

{ TMonsterCreateClass }

procedure TMonsterCreateClass.add(var adata: TCreateMonsterData);
var
  p: PTCreateMonsterData;
begin
//    if get(adata.Index) <> nil then exit;

  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TMonsterCreateClass.Clear;
var
  i: Integer;
  p: PTCreateMonsterData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;

end;

constructor TMonsterCreateClass.Create(afilename: string);
begin
  DataList := TList.Create;
  loadfile(afilename);
end;

destructor TMonsterCreateClass.Destroy;
begin
  Clear;
  DataList.Free;
  inherited;
end;

function TMonsterCreateClass.get(aindex: integer): PTCreateMonsterData;
begin
  result := nil;
  if (aindex < 0) or (aindex > DataList.Count - 1) then exit;
  result := DataList.Items[aindex];
end;


function TMonsterCreateClass.getCount: integer;
begin
  result := DataList.Count;
end;

procedure TMonsterCreateClass.loadfile(afilename: string);
var
  i: integer;
  iname: string;
  temp: TCreateMonsterData;
  CreateMonster: TUserStringDb;
begin
  if not FileExists(aFileName) then exit;
  Clear;
  CreateMonster := TUserStringDb.Create;
  try
    CreateMonster.LoadFromFile(aFileName);
    for i := 0 to CreateMonster.Count - 1 do
    begin
      iname := CreateMonster.GetIndexName(i);

      FillChar(temp, sizeof(TCreateMonsterData), 0);

      temp.index := i;
      temp.mName := CreateMonster.GetFieldValueString(iname, 'MonsterName');
      temp.CurCount := 0;
      temp.Count := CreateMonster.GetFieldValueInteger(iname, 'Count');
      temp.x := CreateMonster.GetFieldValueInteger(iname, 'X');
      temp.y := CreateMonster.GetFieldValueInteger(iname, 'Y');
      temp.width := CreateMonster.GetFieldValueInteger(iname, 'Width');
      temp.Member := CreateMonster.GetFieldValueString(iName, 'Member');
      temp.rnation := CreateMonster.GetFieldValueInteger(iName, 'nation');
      temp.rmappathid := CreateMonster.GetFieldValueInteger(iName, 'mappathid');

      Add(temp);
    end;

  finally
    CreateMonster.Free;
  end;

end;

{ TNpcCreateClass }

procedure TNpcCreateClass.add(var adata: TCreateNpcData);
var
  p: PTCreateNpcData;
begin
  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TNpcCreateClass.Clear;
var
  i: Integer;
  p: PTCreateNpcData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;

end;

constructor TNpcCreateClass.Create(afilename: string);
begin
  DataList := TList.Create;
  loadfile(afilename);
end;

destructor TNpcCreateClass.Destroy;
begin
  Clear;
  DataList.Free;
  inherited;
end;

function TNpcCreateClass.get(aindex: integer): PTCreateNpcData;
begin
  result := nil;
  if (aindex < 0) or (aindex > DataList.Count - 1) then exit;
  result := DataList.Items[aindex];
end;


function TNpcCreateClass.getCount: integer;
begin
  result := DataList.Count;
end;

procedure TNpcCreateClass.loadfile(afilename: string);
var
  i: integer;
  iname: string;
  temp: TCreateNpcData;
  afilesdb: TUserStringDb;
begin
  if not FileExists(aFileName) then exit;
  Clear;
  afilesdb := TUserStringDb.Create;
  try
    afilesdb.LoadFromFile(aFileName);
    for i := 0 to afilesdb.Count - 1 do
    begin
      iname := afilesdb.GetIndexName(i);

      FillChar(temp, sizeof(temp), 0);
      temp.index := i;
      temp.mName := afilesdb.GetFieldValueString(iname, 'NpcName');
      temp.CurCount := 0;
      temp.Count := afilesdb.GetFieldValueInteger(iname, 'Count');
      temp.x := afilesdb.GetFieldValueInteger(iname, 'X');
      temp.y := afilesdb.GetFieldValueInteger(iname, 'Y');
      temp.width := afilesdb.GetFieldValueInteger(iname, 'Width');
      temp.BookName := afilesdb.GetFieldValueString(iname, 'BookName');
      temp.rnation := afilesdb.GetFieldValueInteger(iName, 'nation');
      temp.rmappathid := afilesdb.GetFieldValueInteger(iName, 'mappathid');


      Add(temp);
    end;

  finally
    afilesdb.Free;
  end;

end;

{ TMapOtherListClass }



procedure TMapOtherListClass.Clear;
var
  i: integer;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    TObject(DataList.Items[i]).Free;
  end;
  DataList.Clear;
  FMapIdIndex.Clear;
end;

constructor TMapOtherListClass.Create;
begin
  DataList := TList.Create;
  FMapIdIndex := TIntegerKeyClass.Create;
end;

destructor TMapOtherListClass.Destroy;
begin
  Clear;
  DataList.Free;
  FMapIdIndex.Free;
  inherited;
end;

function TMapOtherListClass.get(aMapId: integer): pointer;
begin
  Result := FMapIdIndex.Select(aMapId);
end;

{ TNpcCreateListClass }

procedure TNpcCreateListClass.add(aMapId: integer);
var
  temp: TNpcCreateClass;
begin
  if get(aMapId) <> nil then exit;
  temp := TNpcCreateClass.Create(format('.\Setting\CreateNpc%d.SDB', [aMapId]));
  DataList.Add(temp);
  FMapIdIndex.Insert(aMapId, temp);
end;

procedure TNpcCreateListClass.add2(aNewId, aMapId: integer);
var
  temp: TNpcCreateClass;
begin
  if get(aNewId) <> nil then exit;
  temp := TNpcCreateClass.Create(format('.\Setting\CreateNpc%d.SDB', [aMapId]));
  DataList.Add(temp);
  FMapIdIndex.Insert(aNewId, temp);
end;

{ TMonsterCreateListClass }

procedure TMonsterCreateListClass.add(aMapId: integer);
var
  temp: TMonsterCreateClass;
begin
  if get(aMapId) <> nil then exit;
  temp := TMonsterCreateClass.Create(format('.\Setting\CreateMonster%d.SDB', [aMapId]));
  DataList.Add(temp);
  FMapIdIndex.Insert(aMapId, temp);
end;

procedure TMonsterCreateListClass.add2(aNewId, aMapId: integer);
var
  temp: TMonsterCreateClass;
begin
  if get(aNewId) <> nil then exit;
  temp := TMonsterCreateClass.Create(format('.\Setting\CreateMonster%d.SDB', [aMapId]));
  DataList.Add(temp);
  FMapIdIndex.Insert(aNewId, temp);
end;

{ TDynamicCreateClass }

procedure TDynamicCreateClass.add(var adata: TCreateDynamicObjectData);
var
  p: pTCreateDynamicObjectData;
begin
  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TDynamicCreateClass.Clear;
var
  i: Integer;
  p: pTCreateDynamicObjectData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;

end;

constructor TDynamicCreateClass.Create(afilename: string);
begin
  DataList := TList.Create;
  loadfile(afilename);
end;

destructor TDynamicCreateClass.Destroy;
begin
  Clear;
  DataList.Free;
  inherited;
end;

function TDynamicCreateClass.get(aindex: integer): pTCreateDynamicObjectData;
begin
  result := nil;
  if (aindex < 0) or (aindex > DataList.Count - 1) then exit;
  result := DataList.Items[aindex];
end;


function TDynamicCreateClass.getCount: integer;
begin
  result := DataList.Count;
end;

procedure TDynamicCreateClass.loadfile(afilename: string);
var
  i: integer;
  iname, ObjectName: string;
  temp: TCreateDynamicObjectData;
  afilesdb: TUserStringDb;
  DynamicObjectData: tDynamicObjectData;
begin
  if not FileExists(aFileName) then exit;
  Clear;
  afilesdb := TUserStringDb.Create;
  try
    afilesdb.LoadFromFile(aFileName);
    for i := 0 to afilesdb.Count - 1 do
    begin
      iname := afilesdb.GetIndexName(i);


      FillChar(DynamicObjectData, SizeOf(DynamicObjectData), 0);
      ObjectName := afilesdb.GetFieldValueString(iname, 'name');
      DynamicObjectClass.GetDynamicObjectData(ObjectName, DynamicObjectData);
      if DynamicObjectData.rName <> '' then
      begin

        FillChar(temp, sizeof(temp), 0);
        temp.rBasicData := DynamicObjectData;

        temp.rNeedAge := afilesdb.GetFieldValueInteger(iname, 'NeedAge');

        LoadDynamicObject(ObjectName
          , afilesdb.GetFieldValueString(iname, 'NeedSkill')
          , afilesdb.GetFieldValueString(iname, 'NeedItem')
          , afilesdb.GetFieldValueString(iname, 'GiveItem')
          , afilesdb.GetFieldValueString(iname, 'DropItem')
          , afilesdb.GetFieldValueString(iname, 'DropMop')
          , afilesdb.GetFieldValueString(iname, 'CallNpc')
          , afilesdb.GetFieldValueString(iname, 'X')
          , afilesdb.GetFieldValueString(iname, 'Y')
          , @temp
          );
        temp.rDropX := afilesdb.GetFieldValueInteger(iName, 'DropX');
        temp.rDropY := afilesdb.GetFieldValueInteger(iName, 'DropY');
        temp.rWidth := afilesdb.GetFieldValueInteger(iName, 'Width');
        temp.rboDelay := afilesdb.GetFieldValueBoolean(iName, 'boDelay');

        Add(temp);
      end;
    end;

  finally
    afilesdb.Free;
  end;

end;


{ TDynamicCreateListClass }

procedure TDynamicCreateListClass.add(aMapId: integer);
var
  temp: TDynamicCreateClass;
begin
  if get(aMapId) <> nil then exit;
  temp := TDynamicCreateClass.Create(format('.\Setting\CreateDynamicObject%d.SDB', [aMapId]));
  DataList.Add(temp);
  FMapIdIndex.Insert(aMapId, temp);
end;

procedure TDynamicCreateListClass.add2(aNewId, aMapId: integer);
var
  temp: TDynamicCreateClass;
begin
  if get(aNewId) <> nil then exit;
  temp := TDynamicCreateClass.Create(format('.\Setting\CreateDynamicObject%d.SDB', [aMapId]));
  DataList.Add(temp);
  FMapIdIndex.Insert(aNewId, temp);
end;

{ TLuaScripter }

procedure TLuaScripter.add(aitem: TLuaScripterDATA);
var
  p: PTLuaScripterDATA;
begin
  if get(aitem.rname) <> nil then exit;
  new(p);
  p^ := aitem;
  DataList.Add(p);
  AnsIndexClass.Insert(p.rname, p);
end;

procedure TLuaScripter.Clear;
var
  i: integer;
  p: PTLuaScripterDATA;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList[i];
    if p^.LuaScripter.LuaInstance <> Pointer($80808080) then //2015.11.10 在水一方 内存泄露007
      p^.LuaScripter.Free;
    dispose(p);
  end;
  DataList.Clear;
  AnsIndexClass.Clear;
end;

constructor TLuaScripter.Create;
begin
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create;
end;

destructor TLuaScripter.Destroy;
begin
  Clear;
  AnsIndexClass.Free;
  DataList.Free;
  inherited;
end;

function TLuaScripter.get(aname: string): PTLuaScripterDATA;
begin
  result := AnsIndexClass.Select(aname);
end;

procedure TLuaScripter.LoadFile(Jname, JFileName: string; ALua: TLua);
var
  StringList: TStringList;
  PaxScripter: tPaxScripter;
  aitem: TLuaScripterDATA;
begin
  if not FileExists(JFileName) then EXIT;

  //StringList := TStringList.Create;

  //try

  try

    aitem.rname := Jname; //脚本宿主名称
    aitem.rnamefile := JFileName; //脚本路径
    aitem.LuaScripter := ALua; //脚本ID
    add(aitem);
  except

  end;

  //finally
  //  StringList.Free;
  //end;
end;



procedure TLuaScripter.ReLoadFromFile;
var
  i: integer;
  p: PTLuaScripterDATA;
  StringList: TStringList;
begin
 // StringList := TStringList.Create;
 // try
  for i := 0 to DataList.Count - 1 do
  begin

    p := DataList[i];
    if not FileExists(p^.rnamefile) then Continue;
      //frmMain.WriteLogInfo(p^.rname);
      //luaL_openlibs(p^.LuaScripter.LuaInstance);
      //Lua_GroupScripteRegister(p^.LuaScripter.LuaInstance);
    if p^.LuaScripter.DoFile(p^.rnamefile) <> 0 then
      frmMain.WriteLogInfo(format('Lua脚本错误 方法: %s f: %s', [p^.rnamefile, lua_tostring(p^.LuaScripter.LuaInstance, -1)]));
  end;
 // finally
 //   StringList.Free;
 // end;
end;

function TLuaScripter.IsScripter(JName: string): boolean;
begin
  Result := FALSE;
  if get(JName) <> nil then
    Result := true;
end;

function TLuaScripter.GetScripter(JName: string; var LuaScripter: TLua): Boolean;
var
  p: PTLuaScripterDATA;
begin
  Result := FALSE;
  LuaScripter := nil;
  p := get(JName);

  if p = nil then exit;

  LuaScripter := p.LuaScripter;

  Result := TRUE;
end;

function TLuaScripter.GetScripnum: Integer;
begin
  Result := DataList.Count;
end;

{ TTalentLevelClass }

procedure TTalentLevelClass.add(var adata: TTalentLevelData);
var
  p: pTTalentLevelData;
begin
  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TTalentLevelClass.Clear;
var
  i: Integer;
  p: PTTalentLevelData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
end;

constructor TTalentLevelClass.Create;
begin
  DataList := TList.Create;
  loadfile;
end;

destructor TTalentLevelClass.Destroy;
begin
  Clear;
  DataList.free;
  inherited;
end;

function TTalentLevelClass.getLevle(aLevel: integer): PTTalentLevelData;
var
  i: Integer;
  p: PTTalentLevelData;
begin
  result := nil;
  try

    p := DataList.Items[aLevel];

    result := p;
  except
    Result := nil;
  end;

end;

procedure TTalentLevelClass.loadfile;
var
  i, j: integer;
  temp: TTalentLevelData;
  filesdb: TUserStringDb;
  str, iName, FileName: string;
  tepitemdata: titemdata;
begin

  FileName := '.\Init\TalentLevel.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      temp.Lv := filesdb.GetFieldValueInteger(iName, 'Lv');
      temp.Exp := filesdb.GetFieldValueInteger(iName, 'Exp');
      temp.Point := filesdb.GetFieldValueInteger(iName, 'Point');
      add(temp);
    end;

  finally
    filesdb.Free;
  end;

end;

{ TJobUpgradeClass }

procedure TJobUpgradeClass.add(var adata: TJobUpgradelData);
var
  p: PTJobUpgradelData;
begin

  new(p);
  p^ := adata;
  DataList.Add(p);
end;

procedure TJobUpgradeClass.Clear;
var
  i: Integer;
  p: PTJobUpgradelData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
end;

constructor TJobUpgradeClass.Create;
begin
  DataList := TList.Create;
  loadfile;
end;

destructor TJobUpgradeClass.Destroy;
begin
  Clear;
  if DataList <> nil then DataList.Free;
  inherited;
end;

function TJobUpgradeClass.getdate(Upgrade: integer): PTJobUpgradelData;
var
  i: Integer;
  pd: PTJobUpgradelData;
begin
  result := nil;
  try
    for i := 0 to DataList.Count - 1 do
    begin
      pd := DataList.Items[i];
      if pd <> nil then
      begin
        if pd^.Upgrade = Upgrade then
        begin
          Result := pd;
          exit;
        end;
      end;
    end;
//    if (Upgrade <= 0) or (Upgrade > DataList.count) then exit;
//    p := DataList.Items[Upgrade];
   // result := AnsIndexClass.Select(Upgrade);
  except
    Result := nil;
  end;

end;

procedure TJobUpgradeClass.loadfile;
var
  i, j: integer;
  temp: TJobUpgradelData;
  filesdb: TUserStringDb;
  str, iName, FileName: string;
begin
  Clear;
  FileName := '.\Init\JobUpgrade.sdb';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(temp, sizeof(temp), 0);
      //temp.Name := filesdb.GetFieldValueString(iName, 'Name');
      temp.Upgrade := filesdb.GetFieldValueInteger(iName, 'Upgrade');
      temp.SuccessRate := filesdb.GetFieldValueInteger(iName, 'SuccessRate');
      temp.DungeonRate := filesdb.GetFieldValueInteger(iName, 'DungeonRate');
      temp.Cost := filesdb.GetFieldValueInteger(iName, 'Cost');
      temp.Items := filesdb.GetFieldValueString(iName, 'Items');
      temp.DamageBody := filesdb.GetFieldValueInteger(iName, 'DamageBody');
      temp.DamageHead := filesdb.GetFieldValueInteger(iName, 'DamageHead');
      temp.DamageArm := filesdb.GetFieldValueInteger(iName, 'DamageArm');
      temp.DamageLeg := filesdb.GetFieldValueInteger(iName, 'DamageLeg');
      temp.ArmorBody := filesdb.GetFieldValueInteger(iName, 'ArmorBody');
      temp.ArmorHead := filesdb.GetFieldValueInteger(iName, 'ArmorHead');
      temp.ArmorArm := filesdb.GetFieldValueInteger(iName, 'ArmorArm');
      temp.ArmorLeg := filesdb.GetFieldValueInteger(iName, 'ArmorLeg');
      temp.AttackSpeed := filesdb.GetFieldValueInteger(iName, 'AttackSpeed');
      temp.Avoid := filesdb.GetFieldValueInteger(iName, 'Avoid');
      temp.Recovery := filesdb.GetFieldValueInteger(iName, 'Recovery');
      temp.Accuracy := filesdb.GetFieldValueInteger(iName, 'Accuracy');
      temp.KeepRecovery := filesdb.GetFieldValueInteger(iName, 'KeepRecovery');
      temp.bodec := filesdb.GetFieldValueBoolean(iName, 'bodec');
      temp.bodel := filesdb.GetFieldValueBoolean(iName, 'bodel');
      temp.decRate := filesdb.GetFieldValueInteger(iName, 'decRate');
      temp.delRate := filesdb.GetFieldValueInteger(iName, 'delRate');
      temp.powerlevel := filesdb.GetFieldValueInteger(iName, 'powerlevel');
      temp.bomsg := filesdb.GetFieldValueBoolean(iName, 'bomsg');
      temp.luck := filesdb.GetFieldValueInteger(iName, 'luck');
      add(temp);
    end;

  finally
    filesdb.Free;
  end;

end;


initialization
  begin

    fillchar(vServerTempVarArr, sizeof(vServerTempVarArr), 0);


    AttachClass := TAttachClass.Create(1000);
//        ItemUPLevelClass := TItemUPLevelClass.Create;
    PowerLevelClass := TPowerLevelSub.Create;
    NEWItemIDClass := TsaveId.Create('itemid.dat');
    NEWEmailIDClass := TsaveId.Create('emailid.dat');
    NEWAuctionIDClass := TsaveId.Create('auctionid.dat');
    ScripterList := TScripter.Create;
    LuaScripterList := TLuaScripter.Create;
      //  NameStringListForDeleteMagic := TStringList.Create;
    RejectNameList := TStringList.Create;
    RejectNameList.LoadFromFile('.\DontChar.TXT');

        //NpcFunction := TNpcFunction.Create; //闲置
    PrisonClass := TPrisonClass.Create;
    RandomClass := TRandomClass.Create;
    QuestClass := TQuestClass.Create;
    AreaClass := TAreaClass.Create;
    PosByDieClass := TPosByDieClass.Create;
    SysopClass := TSysopclass.Create;
    LoadGameIni('.\game.ini'); //读取配置文件
    NpcClass := TNpcClass.Create;
    WeaponLevelColorClass := TWeaponLevelColorClass.Create;
    MaterialClass := TMaterialClass.Create;
    ItemClass := TItemClass.Create;
    ItemLifeDataClass := TItemLifeDataClass.Create;

    DynamicObjectClass := TDynamicObjectClass.Create;
    ItemDrugClass := TItemDrugClass.Create;
    MagicClass := TMagicClass.Create;
    MagicParamClass := TMagicParamClass.Create;
    MonsterClass := TMonsterClass.Create;
        // ItemLog := TItemLog.Create;  //仓库  管理 类
    MapPathList := TMapPathList.Create;

    ToolRateClass := TToolRateListClass.Create;
    MineAvailClass := TMineAvailClass.Create;
    MineShapeClass := TMineShapeClass.Create;
    MineClass := TMineClass.Create;
    JobGradeClass := TJobGradeClass.Create;
    JobUpgradeClass := TJobUpgradeClass.Create;
    TalentLevelClass := TTalentLevelClass.Create;
  end;

finalization //2015.11.10 在水一方 内存泄露007  按此次序不得乱
  begin
    MaterialClass.Free;
    WeaponLevelColorClass.Free;
    ToolRateClass.Free;
    MineAvailClass.Free;
    MineShapeClass.Free;
    MineClass.Free;
    JobGradeClass.Free;
    JobUpgradeClass.Free;
    TalentLevelClass.Free;

    MapPathList.Free;
//        ItemUPLevelClass.Free;
        //ItemLog.Free;
    MonsterClass.Free;
    MagicClass.Free;
    MagicParamClass.Free;
    ItemClass.Free;
    DynamicObjectClass.Free;
    ItemDrugClass.Free;
    NpcClass.Free;
    SysopClass.free;
    PosByDieClass.Free;
    AreaClass.Free;
    QuestClass.Free;
    RandomClass.Free;
    PrisonClass.Free;
        //NpcFunction.Free;

    RejectNameList.Free;
//        NameStringListForDeleteMagic.Free;

    NEWItemIDClass.Free;
    NEWEmailIDClass.Free;
    NEWAuctionIDClass.Free;

    ScripterList.Free;
    AttachClass.Free;
    ItemLifeDataClass.Free;
    PowerLevelClass.Free;
    LuaScripterList.Free;
  end;

end.

