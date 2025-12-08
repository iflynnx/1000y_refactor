unit svClass;

interface

uses
  Windows, SysUtils, Classes, Usersdb, adeftype, Deftype, AnsUnit,
  AnsImg2, AUtil32, uSendcls, uAnstick, uLevelexp, IniFiles, SubUtil,
  AnsStringCls, uKeyClass;

const
   AREA_NONE         = 0;
   AREA_CANMAKEGUILD = 1;

type
   TSkillAddDamageData = record
      rdamagebody: integer;
      rdamagehead: integer;
      rdamagearm: integer;
      rdamageleg: integer;
   end;

   TRandomData = record
      rItemName : String;
      rObjName : String;
      rIndex : Integer;
      rCurIndex : Integer;
      rCount : Integer;
   end;
   PTRandomData = ^TRandomData;

   TRandomClass = class
   private
      DataList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure AddData (aItemName, aObjName : String; aCount : Integer);
      function  GetChance (aItemName, aObjName : String) : Boolean;
   end;

   // 2000.10.05 추가방어력 구조체 by Lee.S.G
   TSkillAddArmorData = record
      rarmorbody: integer;
      rarmorhead: integer;
      rarmorarm: integer;
      rarmorleg: integer;
   end;

   TMagicClass = class
   private
     MagicDb : TUserStringDb;
     MagicForGuildDb : TUserStringDb;
     DataList : TList;
     AnsIndexClass : TAnsIndexClass;
     SkillAddDamageArr : array [0..10000] of TSkillAddDamageData;
     SkillAddArmorArr : array [0..10000] of TSkillAddArmorData; // 추가방어력
     procedure Clear;
     function  LoadMagicData (aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;
   public
     constructor Create;
     destructor Destroy; override;

     procedure ReLoadFromFile;
//     procedure CompactGuildMagic;

     function  GetSkillDamageBody (askill: integer): integer;
     function  GetSkillDamageHead (askill: integer): integer;
     function  GetSkillDamageArm  (askill: integer): integer;
     function  GetSkillDamageLeg  (askill: integer): integer;

     function  GetSkillArmorBody (askill: integer): integer;
     function  GetSkillArmorHead (askill: integer): integer;
     function  GetSkillArmorArm  (askill: integer): integer;
     function  GetSkillArmorLeg  (askill: integer): integer;

     procedure Calculate_cLifeData (pMagicData: PTMagicData);

     function GetMagicData (aMagicName: string; var MagicData: TMagicData; aexp: integer): Boolean;
     function GetHaveMagicData (astr: string; var MagicData: TMagicData): Boolean;
     function GetHaveMagicString (var MagicData: TMagicData): string;
   end;

   TItemClass = class
   private
     ItemDb : TUserStringDb;
     DataList : TList;
     AnsIndexClass : TAnsIndexClass;

     procedure Clear;
     function  LoadItemData (aItemName: string; var ItemData: TItemData): Boolean;
   public
     constructor Create;
     destructor Destroy; override;

     procedure ReLoadFromFile;
     function GetItemData (aItemName: string; var ItemData: TItemData): Boolean;
     function GetCheckItemData (aObjName : String; aCheckItem : TCheckItem; var ItemData: TItemData): Boolean;
     function GetWearItemData (astr: string; var ItemData: TItemData): Boolean;
     function GetChanceItemData (aStr, aObjName : string; var ItemData: TItemData): Boolean;
     function GetWearItemString (var ItemData: TItemData): string;
   end;

{
   // 상태 변화를 갖는 아이템들에 대한 클래스 왕릉의 문, 상자 etc
   TDynamicObjectClass = class
   private
      // DynamicItemDb : TUserStringDb;
      DataList : TList;
      AnsIndexClass : TAnsIndexClass;

      procedure   Clear;
   public
      constructor Create;
      destructor  Destroy; override;
      procedure   LoadFromFile (aName : String);

      function    GetDynamicObjectData (aObjectName: String; var aObjectData: TDynamicObjectData): Boolean;
   end;
}
   TItemDrugClass = class
   private
     ItemDrugDb : TUserStringDb;
     DataList : TList;
     AnsIndexClass : TAnsIndexClass;
     procedure Clear;
     function  LoadItemDrugData (aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
   public
     constructor Create;
     destructor Destroy; override;
     procedure ReLoadFromFile;
     function  GetItemDrugData (aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
   end;

   TMonsterClass = class
   private
     MonsterDb : TUserStringDb;
     DataList : TList;
     AnsIndexClass : TAnsIndexClass;
     procedure Clear;
     function  LoadMonsterData (aMonsterName: string; var MonsterData: TMonsterData): Boolean;
   public
     constructor Create;
     destructor Destroy; override;
     procedure ReLoadFromFile;
     function GetMonsterData (aMonsterName: String; pMonsterData: PTMonsterData): Boolean;
     function GetMonsterDataPointer (aMonsterName: String) : PTMonsterData;
   end;

   TNpcClass = class
   private
      DataList : TList;
      KeyClass : TStringKeyClass;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure LoadFromFile (aFileName : String);
      function  GetNpcData (aNpcName: String; aNpcData: PTNpcData): Boolean;
      function  GetNpcDataPointer (aNpcName: String) : PTNpcData;
   end;

   TSysopClass = class
   private
     SysopDb : TUserStringDb;
   public
     constructor Create;
     destructor Destroy; override;
     procedure  ReLoadFromFile;
     function   GetSysopScope (aName: string): integer;
   end;

   TPosByDieClass = class
   private
      DataList : TList;
      procedure Clear;
   public
      constructor Create;
      destructor Destroy; override;

      procedure ReLoadFromFile;
      procedure GetPosByDieData (aServerID : Integer; var aDestServerID : Integer; var aDestX, aDestY : Word);
   end;

   {
   TQuestClass = class
   private
      function CheckQuest1 (aServerID : Integer; var aRetStr : String) : Boolean;
   public
      constructor Create;
      destructor Destroy; override;

      function GetQuestString (aQuest : Integer) : String;
      function CheckQuestComplete (aQuest, aServerID : Integer; var aRetStr : String) : Boolean;
   end;
   }

   TAreaClass = class
   private
      DataList : TList;
      function  GetCount: integer;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   Clear;
      procedure   LoadFromFile (aFileName : String);

      function    CanMakeGuild (aIndex : Byte) : Boolean;
      function    GetAreaName (aIndex : Byte) : String;
      function    GetAreaDesc (aIndex : Byte) : String;

      property    Count : integer read GetCount;
   end;
{
   TPrisonData = record
      rUserName : String;
      rPrisonTime : Integer;
      rElaspedTime : Integer;
      rPrisonType : String;
      rReason : String;
   end;
   PTPrisonData = ^TPrisonData;

   TPrisonClass = class
   private
      DataList : TList;
      SaveTick : Integer;

      function GetPrisonTime (aType : String) : Integer;
      function GetPrisonData (aName : String) : PTPrisonData;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function LoadFromFile (aFileName : String) : Boolean;
      function SaveToFile (aFileName : String) : Boolean;

      function AddUser (aName, aType, aReason : String) : String;
      function DelUser (aName : String) : String;
      function UpdateUser (aName, aType, aReason : String) : String;
      function PlusUser (aName, aType, aReason : String) : String;
      function EditUser (aName, aTime, aReason : String) : String;

      function GetUserStatus (aName : String) : String;
      function IncreaseElaspedTime (aName : String; aTime : Integer) : Integer;

      procedure Update (CurTick : Integer);
   end;
}
   TNpcFunction = class
   private
      DataList : TList;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure LoadFromFile (aFileName : String);

      function GetFunction (aIndex : Integer) : PTNpcFunctionData;
   end;

   procedure LoadGameIni (aName: string);

   function  GetServerIdPointer (aServerId, atype: integer): Pointer;

   procedure LoadCreateItem (aFileName: string; List : TList);
   // procedure LoadCreateDynamicObject (aFileName : String; List : TList);

var
   NameStringListForDeleteMagic : TStringList;
   RandomClass : TRandomClass;
   MagicClass : TMagicClass;
   ItemClass : TItemClass;
//   DynamicObjectClass : TDynamicObjectClass;
   ItemDrugClass : TItemDrugClass;
   MonsterClass : TMonsterClass;
   NpcClass : TNpcClass;
   UserData : TUserStringDb;
   SysopClass : TSysopclass;
   PosByDieClass : TPosByDieClass;
   // QuestClass : TQuestClass;
   AreaClass : TAreaClass;
//   PrisonClass : TPrisonClass;
   NpcFunction : TNpcFunction;
   
   GrobalLightDark : TLightDark = gld_light;

   NameOfLend : string = '';

   GameStartDateStr : String;
   GameStartYear : Word = 2000;
   GameStartMonth : Word = 1;
   GameStartDay : Word = 1;
   
   GameCurrentDate : integer = 0;

   Udp_MouseEvent_IpAddress : string = '';
   Udp_MouseEvent_Port : integer = 6000;

   Udp_Item_IpAddress : string = '';
   Udp_Item_Port : integer = 6000;

   Udp_Moniter_IpAddress : string = '';
   Udp_Moniter_Port : integer = 6000;

   Udp_Connect_IpAddress : string = '';
   Udp_Connect_Port : integer = 6022;

   Udp_UserData_Ipaddress : string = '';
   Udp_UserData_Port : integer = 0;
   Udp_UserData_LocalPort : integer = 0;

   Udp_Notice_Ipaddress : string = '';
   Udp_Notice_Port : integer = 0;
   Udp_Notice_LocalPort : integer = 0;

   ProcessListCount : integer = 40;

   ////////////////////////
   //     INI Variable
   ////////////////////////

   INI_WHO : string = '/WHO';
   INI_SERCHSKILL : string = '@SERCHSKILL';
   INI_WHITEDRUG : string = 'WHITEDRUG';
   INI_ROPE : string = 'ROPE';
   INI_SEX_FIELD_MAN : string = 'MAN';
   INI_SEX_FIELD_WOMAN : string = 'WOMAN';
   INI_GUILD_STONE : string = 'GUILDSTONE';
   INI_GUILD_NPC_NAME : string = 'NPC';
   INI_GOLD : string = 'GOLD';

   INI_Guild_MAN_SEX : string = 'MAN';
   INI_Guild_MAN_CAP : string = '';
   INI_Guild_MAN_HAIR : string = '';
   INI_GUILD_MAN_UPUNDERWEAR : string = '';
   INI_Guild_MAN_UPOVERWEAR : string = '';
   INI_Guild_MAN_DOWNUNDERWEAR : string = '';
   INI_Guild_MAN_GLOVES : string = '';
   INI_Guild_MAN_SHOES : string = '';
   INI_Guild_MAN_WEAPON : string = '';
   INI_GUILD_MAN_SHAPE : integer = 27;
   INI_GUILD_MAN_ANIMATE : integer = 11;

   INI_Guild_WOMAN_SEX : string = 'WOMAN';
   INI_Guild_WOMAN_CAP : string = '';
   INI_Guild_WOMAN_HAIR : string = '';
   INI_GUILD_WOMAN_UPUNDERWEAR : string = '';
   INI_Guild_WOMAN_UPOVERWEAR : string = '';
   INI_Guild_WOMAN_DOWNUNDERWEAR : string = '';
   INI_Guild_WOMAN_GLOVES : string = '';
   INI_Guild_WOMAN_SHOES : string = '';
   INI_Guild_WOMAN_WEAPON : string = '';
   INI_GUILD_WOMAN_SHAPE : integer = 30;
   INI_GUILD_WOMAN_ANIMATE : integer = 12;



   INI_DEF_WRESTLING   : string;
   INI_DEF_FENCING     : string;
   INI_DEF_SWORDSHIP   : string;
   INI_DEF_HAMMERING   : string;
   INI_DEF_SPEARING    : string;
   INI_DEF_BOWING      : string;
   INI_DEF_THROWING    : string;
   INI_DEF_RUNNING     : string;
   INI_DEF_BREATHNG    : string;
   INI_DEF_PROTECTING  : string;

   INI_NORTH     : string;
   INI_NORTHEAST : string;
   INI_EAST      : string;
   INI_EASTSOUTH : string;
   INI_SOUTH     : string;
   INI_SOUTHWEST : string;
   INI_WEST      : string;
   INI_WESTNORTH : string;

   INI_HIDEPAPER_DELAY : Integer = 15;

   INI_MAGIC_DIV_VALUE  : integer = 10;
   INI_ADD_DAMAGE       : integer = 40;
   INI_MUL_ATTACKSPEED  : integer = 10;
   INI_MUL_AVOID           : integer = 6;
   INI_MUL_RECOVERY        : integer = 10;
   INI_MUL_DAMAGEBODY      : integer = 23;
   INI_MUL_DAMAGEHEAD      : integer = 17;
   INI_MUL_DAMAGEARM       : integer = 17;
   INI_MUL_DAMAGELEG       : integer = 17;
   INI_MUL_ARMORBODY       : integer = 7;
   INI_MUL_ARMORHEAD       : integer = 7;
   INI_MUL_ARMORARM        : integer = 7;
   INI_MUL_ARMORLEG        : integer = 7;

   INI_MUL_EVENTENERGY     : integer = 20;
   INI_MUL_EVENTINPOWER    : integer = 22;
   INI_MUL_EVENTOUTPOWER   : integer = 22;
   INI_MUL_EVENTMAGIC      : integer = 10;
   INI_MUL_EVENTLIFE       : integer = 8;

   INI_MUL_5SECENERGY      : integer = 20;
   INI_MUL_5SECINPOWER     : integer = 14;
   INI_MUL_5SECOUTPOWER    : integer = 14;
   INI_MUL_5SECMAGIC       : integer = 9;
   INI_MUL_5SECLIFE        : integer = 8;


   INI_SKILL_DIV_DAMAGE    : integer = 5000;
   INI_SKILL_DIV_ARMOR     : integer = 5000;
   INI_SKILL_DIV_ATTACKSPEED : integer = 25000;
   INI_SKILL_DIV_EVENT     : integer = 5000;

function  GetItemDataInfo (var aItemData: TItemData): string;
function  GetMagicDataInfo (var aMagicData: TMagicData): string;
procedure GatherLifeData (var BaseLifeData, aLifeData: TLifeData);
procedure CheckLifeData (var BaseLifeData: TLifeData);

implementation

uses
   uuser, uconnect, uGroup;

function  GetMagicDataInfo (var aMagicData: TMagicData): string;
begin
   Result := '';
   if aMagicData.rName[0] = 0 then exit;
   with aMagicData.rcLifeData do begin
      Result := format ('%s  수련레벨: %s', [StrPas (@aMagicData.rName), Get10000To100 (aMagicData.rcSkillLevel)]) + #13;

      if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) then
         Result := Result + format ('공격속도: %d   자세보정: %d   회피: %d', [AttackSpeed, Recovery, Avoid]) + #13;
      if DamageBody <> 0 then
         Result := Result + format ('파괴력: %d/%d/%d/%d',[DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
      if ArmorBody <> 0 then
         Result := Result + format ('방어력: %d/%d/%d/%d',[ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
   end;
{
   Result := '';
   if aMagicData.rName[0] = 0 then exit;
   with aMagicData do begin
      Result := format ('%s  수련레벨: %s', [StrPas (@rName), Get10000To100 (rcSkillLevel)]) + #13;

      if (rLifeData.AttackSpeed <> 0) or (rLifeData.Recovery <> 0) or (rLifeData.Avoid <> 0) then
         Result := Result + format ('공격속도: %d   자세보정: %d   회피: %d', [rLifeData.AttackSpeed, rLifeData.Recovery, rLifeData.Avoid]) + #13;
      if rLifeData.DamageBody <> 0 then
         Result := Result + format ('파괴력: %d/%d/%d/%d',[rLifeData.DamageBody+rLifeData.damagebody*rcSkillLevel div INI_SKILL_DIV_DAMAGE, rLifeData.DamageHead, rLifeData.DamageArm, rLifeData.DamageLeg]) + #13;
      if rLifeData.ArmorBody <> 0 then
         Result := Result + format ('방어력: %d/%d/%d/%d',[rLifeData.ArmorBody, rLifeData.ArmorHead, rLifeData.ArmorArm, rLifeData.ArmorLeg]) + #13;
   end;
}
end;

function  GetItemDataInfo (var aItemData: TItemData): string;
begin
   Result := '';
   if aItemData.rName[0] = 0 then exit;
   with aItemData do begin
      Result := format ('%s  가격: %d', [StrPas (@rName), rPrice]) + #13;
      if rDurability <> 0 then
         Result := Result + format ('내구성: %d/%d',[rCurDurability, rDurability]) + #13;
   end;
   with aItemData.rLifeData do begin
      if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) then
         Result := Result + format ('공격속도: %d   자세보정: %d   회피: %d', [-AttackSpeed, -Recovery, Avoid]) + #13;
      if (DamageBody <> 0) or (DamageHead <> 0) or (DamageArm <> 0) or (DamageLeg <> 0) then
         Result := Result + format ('파괴력: %d/%d/%d/%d',[DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
      if (ArmorBody <> 0) or (ArmorHead <> 0) or (ArmorArm <> 0) or (ArmorLeg <> 0) then
         Result := Result + format ('방어력: %d/%d/%d/%d',[ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
   end;
end;

procedure GatherLifeData (var BaseLifeData, aLifeData: TLifeData);
begin
   BaseLifeData.DamageBody     := BaseLifeData.DamageBody     + aLifeData.damageBody;
   BaseLifeData.DamageHead     := BaseLifeData.DamageHead     + aLifeData.damageHead;
   BaseLifeData.DamageArm      := BaseLifeData.DamageArm      + aLifeData.damageArm;
   BaseLifeData.DamageLeg      := BaseLifeData.DamageLeg      + aLifeData.damageLeg;
   BaseLifeData.AttackSpeed    := BaseLifeData.AttackSpeed    + aLifeData.AttackSpeed;
   BaseLifeData.avoid          := BaseLifeData.avoid          + aLifeData.avoid;
   BaseLifeData.recovery       := BaseLifeData.recovery       + aLifeData.recovery;
   BaseLifeData.armorBody      := BaseLifeData.armorBody      + aLifeData.armorBody;
   BaseLifeData.armorhead      := BaseLifeData.armorHead      + aLifeData.armorHead;
   BaseLifeData.armorArm       := BaseLifeData.armorArm       + aLifeData.armorArm;
   BaseLifeData.armorLeg       := BaseLifeData.armorLeg       + aLifeData.armorLeg;
end;

procedure CheckLifeData (var BaseLifeData: TLifeData);
begin
   if BaseLifeData.damageBody < 0 then BaseLifeData.DamageBody := 0;
   if BaseLifeData.DamageHead < 0 then BaseLifeData.DamageHead := 0;
   if BaseLifeData.DamageArm  < 0 then BaseLifeData.DamageArm := 0;
   if BaseLifeData.DamageLeg  < 0 then BaseLifeData.DamageLeg := 0;

   if BaseLifeData.AttackSpeed < 0 then BaseLifeData.AttackSpeed := 0;
   if BaseLifeData.avoid       < 0 then BaseLifeData.avoid       := 0;
   if BaseLifeData.recovery    < 0 then BaseLifeData.recovery    := 0;

   if BaseLifeData.ArmorBody < 0 then BaseLifeData.ArmorBody := 0;
   if BaseLifeData.ArmorHead < 0 then BaseLifeData.ArmorHead := 0;
   if BaseLifeData.ArmorArm  < 0 then BaseLifeData.ArmorArm := 0;
   if BaseLifeData.ArmorLeg  < 0 then BaseLifeData.ArmorLeg := 0;
end;

{
procedure LoadCreateMonster (aFileName: string; List : TList);
var
   i : integer;
   iname : string;
   pd : PTCreateMonsterData;
   CreateMonster : TUserStringDb;
begin
   for i := 0 to List.Count -1 do dispose (List[i]);   // 종료를 잘못함...
   List.Clear;

   CreateMonster := TUserStringDb.Create;
   CreateMonster.LoadFromFile (aFileName);

   for i := 0 to CreateMonster.Count -1 do begin
      iname := CreateMonster.GetIndexName (i);
      new (pd);
      FillChar (pd^, sizeof(TCreateMonsterData), 0);

      pd^.index := i;
      pd^.mName := CreateMonster.GetFieldValueString (iname, 'MonsterName');
      pd^.CurCount := 0;
      pd^.Count := CreateMonster.GetFieldValueInteger (iname, 'Count');
      pd^.x := CreateMonster.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateMonster.GetFieldValueInteger (iname, 'Y');
      pd^.width := CreateMonster.GetFieldValueInteger (iname, 'Width');
      pd^.Member := CreateMonster.GetFieldValueString (iName, 'Member');
      List.Add (pd);
   end;
   CreateMonster.Free;
end;

procedure LoadCreateNpc (aFileName: string; List : TList);
var
   i : integer;
   iname : string;
   pd : PTCreateNpcData;
   CreateNpc : TUserStringDb;
begin
   for i := 0 to List.Count -1 do dispose (List[i]); // 종료를 잘못함...
   List.Clear;

   CreateNpc := TUserStringDb.Create;
   CreateNpc.LoadFromFile (aFileName);

   for i := 0 to CreateNpc.Count -1 do begin
      iname := CreateNpc.GetIndexName (i);
      new (pd);
      FillChar (pd^, sizeof(TCreateNpcData), 0);

      pd^.index := i;
      pd^.mName := CreateNpc.GetFieldValueString (iname, 'NpcName');
      pd^.CurCount := 0;
      pd^.Count := CreateNpc.GetFieldValueInteger (iname, 'Count');
      pd^.x := CreateNpc.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateNpc.GetFieldValueInteger (iname, 'Y');
      pd^.width := CreateNpc.GetFieldValueInteger (iname, 'Width');
      pd^.BookName := CreateNpc.GetFieldValueString (iname, 'BookName');      
      List.Add (pd);
   end;
   CreateNpc.Free;
end;

procedure LoadCreateGate (aFileName: string; List : TList);
var
   i, j : integer;
   iname : string;
   pd : PTCreateGateData;
   CreateGate : TUserStringDb;
   ItemData : TItemData;
   srcstr, tokenstr : String;
begin
   if not FileExists (aFileName) then exit;

   for i := 0 to List.Count -1 do dispose (List[i]); // 종료를 잘못함...
   List.Clear;

   CreateGate := TUserStringDb.Create;
   CreateGate.LoadFromFile (aFileName);

   for i := 0 to CreateGate.Count -1 do begin
      iname := CreateGate.GetIndexName (i);
      new (pd);
      FillChar (pd^, sizeof(TCreateGateData), 0);
      pd^.index := i;
      pd^.mName := CreateGate.GetFieldValueString (iname, 'GateName');
      pd^.x := CreateGate.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateGate.GetFieldValueInteger (iname, 'Y');
      pd^.targetx := CreateGate.GetFieldValueInteger (iname, 'TX');
      pd^.targety := CreateGate.GetFieldValueInteger (iname, 'TY');
      pd^.ejectx := CreateGate.GetFieldValueInteger (iname, 'EX');
      pd^.ejecty := CreateGate.GetFieldValueInteger (iname, 'EY');
      pd^.targetserverid := CreateGate.GetFieldValueInteger (iname, 'ServerId');
      pd^.shape := CreateGate.GetFieldValueInteger (iname, 'Shape');
      pd^.Width := CreateGate.GetFieldValueInteger (iname, 'Width');

      pd^.NeedAge := CreateGate.GetFieldValueInteger (iname, 'NeedAge');
      pd^.AgeNeedItem := CreateGate.GetFieldValueInteger (iname, 'AgeNeedItem');

      srcstr := CreateGate.GetFieldValueString (iname, 'NeedItem');
      if srcstr <> '' then begin
         for j := 0 to 5 - 1 do begin
            srcstr := GetValidStr3 (srcstr, tokenstr, ':');
            if tokenstr = '' then break;
            ItemClass.GetItemData (tokenstr, ItemData);
            if ItemData.rName[0] <> 0 then begin
               srcstr := GetValidStr3 (srcstr, tokenstr, ':');
               ItemData.rCount := _StrToInt (tokenstr);
               pd^.NeedItem[j].rName := StrPas (@ItemData.rName);
               pd^.NeedItem[j].rCount := ItemData.rCount;
            end;
         end;
      end;

      pd^.Quest := CreateGate.GetFieldValueInteger (iname, 'Quest');
      pd^.QuestNotice := CreateGate.GetFieldValueString (iname, 'QuestNotice');

      pd^.RegenInterval := CreateGate.GetFieldValueInteger (iName, 'RegenInterval');
      pd^.ActiveInterval := CreateGate.GetFieldValueInteger (iName, 'ActiveInterval');

      pd^.EjectNotice := CreateGate.GetFieldValueString (iname, 'EjectNotice');

      List.Add (pd);
   end;
   CreateGate.Free;
end;
}

procedure LoadCreateItem (aFileName: string; List : TList);
begin
end;

{
procedure LoadCreateDynamicObject (aFileName : String; List : TList);
var
   i, j, iRandomCount : integer;
   iName, ObjectName, ItemName, mStr, sStr : string;
   DynamicObjectData : TDynamicObjectData;
   pd : PTCreateDynamicObjectData;
   CreateDynamicObject : TUserStringDb;
   MagicData : TMagicData;
   ItemData : TItemData;
   MonsterData : TMonsterData;
   NpcData : TNpcData;
begin
   if not FileExists (aFileName) then exit;

   for i := 0 to List.Count - 1 do begin
      Dispose (List[i]);
   end;
   List.Clear;

   CreateDynamicObject := TUserStringDb.Create;
   CreateDynamicObject.LoadFromFile (aFileName);

   for i := 0 to CreateDynamicObject.Count -1 do begin
      iName := CreateDynamicObject.GetIndexName (i);
      ObjectName := CreateDynamicObject.GetFieldValueString (iName, 'Name');
      FillChar (DynamicObjectData, SizeOf (DynamicObjectData), 0);
      DynamicObjectClass.GetDynamicObjectData (ObjectName, DynamicObjectData);
      if DynamicObjectData.rName <> '' then begin
         New (pd);
         FillChar (pd^, sizeof(TCreateDynamicObjectData), 0);
         pd^.rBasicData := DynamicObjectData;
         pd^.rState := CreateDynamicObject.GetFieldValueInteger (iname, 'State');
         pd^.rRegenInterval := CreateDynamicObject.GetFieldValueInteger (iname, 'RegenInterval');
         pd^.rLife := CreateDynamicObject.GetFieldValueInteger (iname, 'Life');
         pd^.rNeedAge := CreateDynamicObject.GetFieldValueInteger (iname, 'NeedAge');

         // pd^.rNeedSkill
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'NeedSkill');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               MagicClass.GetMagicData (sStr, MagicData, 0);
               if MagicData.rname[0] <> 0 then begin
                  pd^.rNeedSkill[j].rName := StrPas (@MagicData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rNeedSkill[j].rLevel := _StrToInt (sStr);
               end;
            end;
         end;
         // pd^.rNeedItem
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'NeedItem');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               ItemClass.GetItemData (sStr, ItemData);
               if ItemData.rname[0] <> 0 then begin
                  pd^.rNeedItem[j].rName := StrPas (@ItemData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rNeedItem[j].rCount := _StrToInt (sStr);
               end;
            end;
         end;
         // pd^.rGiveItem
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'GiveItem');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               ItemClass.GetItemData (sStr, ItemData);
               if ItemData.rName[0] <> 0 then begin
                  pd^.rGiveItem[j].rName := StrPas (@ItemData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rGiveItem[j].rCount := _StrToInt (sStr);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  iRandomCount := _StrToInt (sStr);
                  if iRandomCount <= 0 then iRandomCount := 1;

                  RandomClass.AddData (pd^.rGiveItem[j].rName, ObjectName, iRandomCount);                  
               end;
            end;
         end;
         // pd^.rDropItem
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'DropItem');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               ItemClass.GetItemData (sStr, ItemData);
               if ItemData.rname[0] <> 0 then begin
                  pd^.rDropItem[j].rName := StrPas (@ItemData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rDropItem[j].rCount := _StrToInt (sStr);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  iRandomCount := _StrToInt (sStr);
                  if iRandomCount <= 0 then iRandomCount := 1;

                  RandomClass.AddData (pd^.rDropItem[j].rName, ObjectName, iRandomCount);
               end;
            end;
         end;

         // pd^.rDropMop
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'DropMop');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               MonsterClass.LoadMonsterData (sStr, MonsterData);
               if MonsterData.rName[0] <> 0 then begin
                  pd^.rDropMop[j].rName := StrPas (@MonsterData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rDropMop[j].rCount := _StrToInt (sStr);
               end;
            end;
         end;

         // pd^.rCallNpc
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'CallNpc');
         for j := 0 to 5 - 1 do begin
            if mStr = '' then break;
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr <> '' then begin
               NpcClass.GetNpcData (sStr, @NpcData);
               if NpcData.rName[0] <> 0 then begin
                  pd^.rCallNpc[j].rName := StrPas (@NpcData.rName);
                  mStr := GetValidStr3 (mStr, sStr, ':');
                  pd^.rCallNpc[j].rCount := _StrToInt (sStr);
               end;
            end;
         end;

         mStr := CreateDynamicObject.GetFieldValueString (iname, 'X');
         for j := 0 to 5 - 1 do begin
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr = '' then break;
            pd^.rX[j] := _StrToInt (sStr);
         end;
         mStr := CreateDynamicObject.GetFieldValueString (iname, 'Y');
         for j := 0 to 5 - 1 do begin
            mStr := GetValidStr3 (mStr, sStr, ':');
            if sStr = '' then break;
            pd^.rY[j] := _StrToInt (sStr);
         end;
         List.Add (pd);
      end;
   end;
   CreateDynamicObject.Free;
end;

procedure LoadCreateGuild (aFileName: string; List : TList);
var
   i, j: integer;
   str, rdstr : string;
   iname : string;
   pd : PTCreateGuildData;
   CreateGuildDb : TUserStringDb;
begin
   if not FileExists (aFileName) then exit;
   
   for i := 0 to List.Count -1 do dispose (List[i]);  // 종료를 잘못함...
   List.Clear;

   CreateGuildDb := TUserStringDb.Create;
   CreateGuildDb.LoadFromFile (aFileName);

   for j := 0 to CreateGuildDb.Count -1 do begin
      iname := CreateGuildDb.GetIndexName (j);
      new (pd); FillChar (pd^, sizeof(TCreateGuildData), 0);
      pd^.index := j;
      pd^.mName := iname;
      pd^.x := CreateGuildDb.GetFieldValueInteger (iname, 'X');
      pd^.y := CreateGuildDb.GetFieldValueInteger (iname, 'Y');
      pd^.Sysop := CreateGuildDb.GetFieldValueString (iname, 'Sysop');
      pd^.SubSysop0 := CreateGuildDb.GetFieldValueString (iname, 'SubSysop0');
      pd^.SubSysop1 := CreateGuildDb.GetFieldValueString (iname, 'SubSysop1');
      pd^.SubSysop2 := CreateGuildDb.GetFieldValueString (iname, 'SubSysop2');
      pd^.Durability := CreateGuildDb.GetFieldValueInteger (iname, 'Durability');
      pd^.GuildMagic := CreateGuildDb.GetFieldValueString (iname, 'GuildMagic');
      pd^.MakeDate := CreateGuildDb.GetFieldValueString (iname, 'MakeDate');
      pd^.MagicExp := CreateGuildDb.GetFieldValueInteger (iname, 'MagicExp');

      for i := 0 to 5-1 do begin
         str := CreateGuildDb.GetFieldValueString (iname, 'Npc'+IntToStr(i));
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpcDataArr[i].rName := rdstr;
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpcDataArr[i].rx := _StrtoInt (rdstr);
         str := GetValidStr3 (str, rdstr, ':');
         pd^.GuildNpcDataArr[i].ry := _StrtoInt (rdstr);
         pd^.GuildNpcDataArr[i].rIndex := i;
      end;

      List.Add (pd);
   end;
   CreateGuildDb.Free;
end;

procedure SaveCreateGuild (aFileName: string; List : TList);
var
   i, j : integer;
   str: string;
   pd : PTCreateGuildData;
   CreateGuildDb : TUserStringDb;
begin
   CreateGuildDb := TUserStringDb.Create;
   CreateGuildDb.LoadFromFile (aFileName);
   for i := 0 to CreateGuildDb.count -1 do
      CreateGuildDb.DeleteName ( CreateGuildDb.GetIndexName(0));

//   CreateGuildDb.SetDbFields ('Name,X,Y,Sysop,SubSysop0,SubSysop1,SubSysop2,Durability,GuildMagic,MakeDate,MagicExp');
//   주석이 아니면 에러남... (SetDbFields 이후에... free 에서 에러남.

   for j := 0 to List.Count -1 do begin
      pd := List[j];
      CreateGuildDb.AddName (pd^.mName);
      CreateGuildDb.SetFieldValueInteger (pd^.mName, 'X', pd^.x);
      CreateGuildDb.SetFieldValueInteger (pd^.mName, 'Y', pd^.y);
      CreateGuildDb.SetFieldValueString (pd^.mName, 'Sysop', pd^.Sysop);
      CreateGuildDb.SetFieldValueString (pd^.mName, 'SubSysop0', pd^.SubSysop0);
      CreateGuildDb.SetFieldValueString (pd^.mName, 'SubSysop1', pd^.SubSysop1);
      CreateGuildDb.SetFieldValueString (pd^.mName, 'SubSysop2', pd^.SubSysop2);
      CreateGuildDb.SetFieldValueInteger (pd^.mName, 'Durability', pd^.Durability);
      CreateGuildDb.SetFieldValueString (pd^.mName, 'GuildMagic', pd^.GuildMagic);
      CreateGuildDb.SetFieldValueString (pd^.mName, 'MakeDate', pd^.MakeDate);
      CreateGuildDb.SetFieldValueInteger (pd^.mName, 'MagicExp', pd^.MagicExp);

      for i := 0 to 5-1 do begin
         str := pd^.GuildNpcDataArr[i].rName + ':';
         str := str + IntToStr (pd^.GuildNpcDataArr[i].rx) + ':';
         str := str + IntToStr (pd^.GuildNpcDataArr[i].ry) + ':';
         if pd^.GuildNpcDataArr[i].rName = '' then str := '';
         CreateGuildDb.SetFieldValueString (pd^.mName, 'Npc'+IntToStr(i), str);
      end;
   end;
   CreateGuildDb.SaveToFile (aFileName);
   CreateGuildDb.Free;
end;
}

function  GetServerIdPointer (aServerId, atype: integer): Pointer;
begin
   Result := nil;
end;

procedure StrToEffectData (var effectdata: TEffectData; astr: string);
var
   str, rdstr : string;
begin
   str := astr;
   str := GetValidStr3 (str, rdstr, ':');
   effectdata.rWavNumber := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   effectdata.rPercent := _StrToInt (rdstr);
end;

///////////////////////////////////
//         TRandomClass
///////////////////////////////////

constructor TRandomClass.Create;
begin
   DataList := nil;
   DataList := TList.Create;
end;

destructor TRandomClass.Destroy;
begin
   Clear;
   if DataList <> nil then DataList.Free;
end;

procedure TRandomClass.Clear;
var
   i : Integer;
   pd : PTRandomData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items[i];
      if pd <> nil then Dispose (pd);
   end;
   DataList.Clear;
end;

procedure TRandomClass.AddData (aItemName, aObjName : String; aCount : Integer);
var
   pd : PTRandomData;
begin
   if (aItemName = '') or (aObjName = '') then exit;

   New (pd);
   pd^.rItemName := aItemName;
   pd^.rObjName := aObjName;
   if aCount < 1 then pd^.rCount := 1
   else pd^.rCount := aCount;
   pd^.rIndex := Random (pd^.rCount);
   pd^.rCurIndex := 0;

   DataList.Add (pd);
end;

function  TRandomClass.GetChance (aItemName, aObjName : String) : Boolean;
var
   i : Integer;
   pd : PTRandomData;
begin
   Result := true;
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then begin
         if pd^.rItemName = aItemName then begin
            if pd^.rObjName = aObjName then begin
               Result := false;
               if pd^.rCurIndex = pd^.rIndex then Result := true;
               
               Inc (pd^.rCurIndex);
               if pd^.rCurIndex >= pd^.rCount then begin
                  pd^.rCurIndex := 0;
                  pd^.rIndex := Random (pd^.rCount);
               end;
               exit;
            end;
         end;
      end;
   end;
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

procedure  TSysopClass.ReLoadFromFile;
begin
   if FileExists ('sysop.sdb') then
      SysopDb.LoadFromFile ('sysop.sdb');
end;

function   TSysopClass.GetSysopScope (aName: string): integer;
begin
   if SysopDb.Count > 0 then Result := SysopDb.GetFieldValueInteger (aName, 'SysopScope')
   else Result := 0;
end;

///////////////////////////////////
//         TMagicClass
///////////////////////////////////


constructor TMagicClass.Create;
begin
   DataList := TList.Create;
   AnsIndexClass := TAnsIndexClass.Create ('MagicClass', 20, TRUE);
   MagicDb := TUserStringDb.Create;
   MagicForGuildDb := TUserStringDb.Create;
   ReLoadFromFile;
end;

destructor TMagicClass.Destroy;
begin
   Clear;
   MagicForGuildDb.Free;
   MagicDb.Free;
   DataList.Free;
   AnsIndexClass.Free;
   inherited destroy;
end;

procedure TMagicClass.Clear;
var i : integer;
begin
   FillChar (SkillAddDamageArr, sizeof(SkillAddDamageArr) , 0);
   FillChar (SkillAddArmorArr, sizeof(SkillAddArmorArr), 0);
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   AnsIndexClass.Clear;
end;

procedure TMagicClass.Calculate_cLifeData (pMagicData: PTMagicData);
begin
   if pMagicData = nil then exit;
   if pMagicData^.rName[0] = 0 then exit;

   with pMagicData^ do begin
      rcLifeData.DamageBody   := rLifeData.damageBody  + rLifeData.damageBody * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      rcLifeData.DamageHead   := rLifeData.DamageHead  + rLifeData.damageHead * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      rcLifeData.DamageArm    := rLifeData.DamageArm   + rLifeData.damageArm  * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      rcLifeData.DamageLeg    := rLifeData.DamageLeg   + rLifeData.damageLeg  * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      rcLifeData.AttackSpeed  := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div INI_SKILL_DIV_ATTACKSPEED;
      rcLifeData.avoid        := rLifeData.avoid   ;//    + rLifeData.avoid;
      rcLifeData.recovery     := rLifeData.recovery;//    + rLifeData.recovery;
      rcLifeData.armorBody    := rLifeData.armorBody   + rLifeData.armorBody * rcSkillLevel div INI_SKILL_DIV_ARMOR;
      rcLifeData.armorHead    := rLifeData.armorHead   + rLifeData.armorHead * rcSkillLevel div INI_SKILL_DIV_ARMOR;
      rcLifeData.armorArm     := rLifeData.armorArm    + rLifeData.armorArm  * rcSkillLevel div INI_SKILL_DIV_ARMOR;
      rcLifeData.armorLeg     := rLifeData.armorLeg    + rLifeData.armorLeg  * rcSkillLevel div INI_SKILL_DIV_ARMOR;
   end;

   with pMagicData^ do begin
      rcLifeData.Damagebody := rcLifeData.Damagebody + rcLifeData.DamageBody * MagicClass.GetSkillDamageBody (rcSkillLevel) div 100;
      if rMagicType = MAGICTYPE_PROTECTING then
         rcLifeData.Armorbody := rcLifeData.Armorbody + rcLifeData.ArmorBody * MagicClass.GetSkillArmorBody (rcSkillLevel) div 100;
   end;
end;

procedure TMagicClass.ReLoadFromFile;
var
   i, idx, sn, en : integer;
   iname, mname : string;
   pmd : PTMagicData;
   TempDb : TUserStringDb;
begin
   Clear;
   TempDb := TUserStringDb.Create;
   TempDb.LoadFromFile ('adddamage.sdb');
   for idx := 0 to TempDb.Count -1 do begin
      iname := TempDb.GetIndexName (idx);
      sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
      en := TempDb.GetFieldValueInteger (iname,'EndSkill');
      if sn <= 0 then sn := 0;
      if en >= 10000 then en := 10000;
      for i := sn to en do begin
         SkillAddDamageArr[i].rdamagebody := TempDb.GetFieldValueInteger (iname,'DamageBody');
         SkillAddDamageArr[i].rdamagehead := TempDb.GetFieldValueInteger (iname,'DamageHead');
         SkillAddDamageArr[i].rdamagearm := TempDb.GetFieldValueInteger (iname,'DamageArm');
         SkillAddDamageArr[i].rdamageleg := TempDb.GetFieldValueInteger (iname,'DamageLeg');
      end;
   end;
   TempDb.Free;

   // 2000.10.05 추가방어력 AddArmor.sdb 파일의 로드 
   TempDb := TUserStringDb.Create;
   TempDb.LoadFromFile ('addarmor.sdb');
   for idx := 0 to TempDb.Count -1 do begin
      iname := TempDb.GetIndexName (idx);
      sn := TempDb.GetFieldValueInteger (iname,'StartSkill');
      en := TempDb.GetFieldValueInteger (iname,'EndSkill');
      if sn <= 0 then sn := 0;
      if en >= 10000 then en := 10000;
      for i := sn to en do begin
         SkillAddArmorArr[i].rarmorbody := TempDb.GetFieldValueInteger (iname,'ArmorBody');
         SkillAddArmorArr[i].rarmorhead := TempDb.GetFieldValueInteger (iname,'ArmorHead');
         SkillAddArmorArr[i].rarmorarm := TempDb.GetFieldValueInteger (iname,'ArmorArm');
         SkillAddArmorArr[i].rarmorleg := TempDb.GetFieldValueInteger (iname,'ArmorLeg');
      end;
   end;
   TempDb.Free;

   MagicDb.LoadFromFile ('magic.sdb');
   MagicForGuildDb.LoadFromFile ('magicforguild.sdb');
   for i := 0 to MagicDb.Count -1 do begin
      mname := MagicDb.GetIndexName (i);
      new (pmd);
      LoadMagicData (mname, pmd^, MagicDb);
      DataList.Add (pmd);
      AnsIndexClass.Insert (Integer(pmd), mname);
   end;

   for i := 0 to MagicForGuildDb.Count -1 do begin
      mname := MagicForGuildDb.GetIndexName (i);
      new (pmd);
      LoadMagicData (mname, pmd^, MagicForGuildDb);
      pmd^.rGuildMagictype := 1;
      DataList.Add (pmd);
      AnsIndexClass.Insert (Integer(pmd), mname);
   end;
end;

function  TMagicClass.GetSkillDamageBody (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamagebody;
end;

function  TMagicClass.GetSkillDamageHead (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamagehead;
end;

function  TMagicClass.GetSkillDamageArm  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamagearm;
end;

function  TMagicClass.GetSkillDamageLeg  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddDamageArr[askill].rdamageleg;
end;

// 2000.10.05 몸 추가방어력 구하는 Method
function  TMagicClass.GetSkillArmorBody (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorbody;
end;

// 2000.10.05 머리 추가방어력 구하는 Method
function  TMagicClass.GetSkillArmorHead (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorhead;
end;

// 2000.10.05 팔 추가방어력 구하는 Method
function  TMagicClass.GetSkillArmorArm  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorarm;
end;

// 2000.10.05 다리 추가방어력 구하는 Method
function  TMagicClass.GetSkillArmorLeg  (askill: integer): integer;
begin
   Result := 0;
   if (askill <= 0) or (askill >= 10000) then exit;
   Result := SkillAddArmorArr[askill].rarmorleg;
end;

function TMagicClass.GetMagicData (aMagicName: string; var MagicData: TMagicData; aexp: integer): Boolean;
var
   n : integer;
begin
   Result := FALSE;

   n := AnsIndexClass.Select (aMagicName);
   if (n = 0) or (n = -1) then begin
      FillChar (MagicData, sizeof(MagicData), 0);
      exit;
   end;
   MagicData := PTMagicData (n)^;

   MagicData.rSkillExp := aexp;
   MagicData.rcSkillLevel := GetLevel (aexp);
   Result := TRUE;
end;

{
procedure TMagicClass.CompactGuildMagic;
var
   i : Integer;
   MagicName, GuildName : String;
begin
   if MagicForGuildDB.Count = 0 then exit;

   for i := MagicForGuildDB.Count - 1 downto 0 do begin
      MagicName := MagicForGuildDb.GetIndexName (i);
      if MagicName = '' then continue;

      GuildName := MagicForGuildDB.GetFieldValueString (MagicName, 'GuildName');
      if GuildList.GetGuildServerID (GuildName) = -1 then begin
         MagicForGuildDB.DeleteName (MagicName);
      end;
   end;

   MagicForGuildDB.SaveToFile ('MagicForGuild.SDB');

   ReloadFromFile;
end;
}

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
function TMagicClass.LoadMagicData (aMagicName: string; var MagicData: TMagicData; aDb: TUserStringDb): Boolean;
begin
   Result := FALSE;
   FillChar (MagicData, sizeof(MagicData), 0);
   if aDb.GetDbString (aMagicName) = '' then exit;
   with MagicData do begin
      StrPCopy (@rname, aMagicName);
      // rPercent := 10;

      StrToEffectData (rSoundEvent, aDb.GetFieldValueString (aMagicName, 'SoundEvent'));
      StrToEffectData (rSoundStrike, aDb.GetFieldValueString (aMagicName, 'SoundStrike'));
      StrToEffectData (rSoundSwing, aDb.GetFieldValueString (aMagicName, 'SoundSwing'));
      StrToEffectData (rSoundStart, aDb.GetFieldValueString (aMagicName, 'SoundStart'));
      StrToEffectData (rSoundEnd, aDb.GetFieldValueString (aMagicName, 'SoundEnd'));

      rBowImage := aDb.GetFieldValueinteger (aMagicName, 'BowImage');
      rBowSpeed := aDb.GetFieldValueinteger (aMagicName, 'BowSpeed');
      rShape := aDb.GetFieldValueinteger (aMagicName, 'Shape');
      rMagicType := aDb.GetFieldValueinteger (aMagicName, 'MagicType');
      rFunction := aDb.GetFieldValueinteger (aMagicName, 'Function');

//      rGoodChar := aDb.GetFieldValueinteger (aMagicName, 'GoodChar');
//      rBadChar := aDb.GetFieldValueinteger (aMagicName, 'BadChar');

      if aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') <> 0 then
         rLifeData.AttackSpeed := (120 - aDb.GetFieldValueinteger (aMagicName, 'AttackSpeed') ) * INI_MUL_ATTACKSPEED div INI_MAGIC_DIV_VALUE;
      if aDb.GetFieldValueinteger (aMagicName, 'Recovery') <> 0 then
         rLifeData.recovery := (120 - aDb.GetFieldValueinteger (aMagicName, 'Recovery') ) * INI_MUL_RECOVERY div INI_MAGIC_DIV_VALUE;
      if aDb.GetFieldValueinteger (aMagicName, 'Avoid') <> 0 then
         rLifeData.avoid := aDb.GetFieldValueinteger (aMagicName, 'Avoid') * INI_MUL_AVOID div INI_MAGIC_DIV_VALUE;

      if aDb.GetFieldValueinteger (aMagicName, 'DamageBody') <> 0 then
         rLifeData.damageBody := (aDb.GetFieldValueinteger (aMagicName, 'DamageBody')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEBODY div INI_MAGIC_DIV_VALUE;

      if aDb.GetFieldValueinteger (aMagicName, 'DamageHead') <> 0 then
         rLifeData.damageHead := (aDb.GetFieldValueinteger (aMagicName, 'DamageHead')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEHEAD div INI_MAGIC_DIV_VALUE;

      if aDb.GetFieldValueinteger (aMagicName, 'DamageArm') <> 0 then
         rLifeData.damageArm := (aDb.GetFieldValueinteger (aMagicName, 'DamageArm')+INI_ADD_DAMAGE) * INI_MUL_DAMAGEARM div INI_MAGIC_DIV_VALUE;

      if aDb.GetFieldValueinteger (aMagicName, 'DamageLeg') <> 0 then
         rLifeData.damageLeg := (aDb.GetFieldValueinteger (aMagicName, 'DamageLeg')+INI_ADD_DAMAGE) * INI_MUL_DAMAGELEG div INI_MAGIC_DIV_VALUE;

      rLifeData.armorBody := aDb.GetFieldValueinteger (aMagicName, 'ArmorBody') * INI_MUL_ARMORBODY div INI_MAGIC_DIV_VALUE;
      rLifeData.armorHead := aDb.GetFieldValueinteger (aMagicName, 'ArmorHead') * INI_MUL_ARMORHEAD div INI_MAGIC_DIV_VALUE;
      rLifeData.armorArm := aDb.GetFieldValueinteger (aMagicName, 'ArmorArm') * INI_MUL_ARMORARM div INI_MAGIC_DIV_VALUE;
      rLifeData.armorLeg := aDb.GetFieldValueinteger (aMagicName, 'ArmorLeg') * INI_MUL_ARMORLEG div INI_MAGIC_DIV_VALUE;

      rEventDecEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy') * INI_MUL_EVENTENERGY div INI_MAGIC_DIV_VALUE;
      rEventDecInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower') * INI_MUL_EVENTINPOWER div INI_MAGIC_DIV_VALUE;
      rEventDecOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower') * INI_MUL_EVENTOUTPOWER div INI_MAGIC_DIV_VALUE;
      rEventDecMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic') * INI_MUL_EVENTMAGIC div INI_MAGIC_DIV_VALUE;
      rEventDecLife := aDb.GetFieldValueinteger (aMagicName, 'eLife') * INI_MUL_EVENTLIFE div INI_MAGIC_DIV_VALUE;

      rEventBreathngEnergy := aDb.GetFieldValueinteger (aMagicName, 'eEnergy');
      rEventBreathngInPower:= aDb.GetFieldValueinteger (aMagicName, 'eInPower');
      rEventBreathngOutPower:= aDb.GetFieldValueinteger (aMagicName, 'eOutPower');
      rEventBreathngMagic := aDb.GetFieldValueinteger (aMagicName, 'eMagic');
      rEventBreathngLife := aDb.GetFieldValueinteger (aMagicName, 'eLife');

      r5SecDecEnergy := aDb.GetFieldValueinteger (aMagicName, '5Energy') * INI_MUL_5SECENERGY div INI_MAGIC_DIV_VALUE;
      r5SecDecInPower:= aDb.GetFieldValueinteger (aMagicName, '5InPower') * INI_MUL_5SECINPOWER div INI_MAGIC_DIV_VALUE;
      r5SecDecOutPower:= aDb.GetFieldValueinteger (aMagicName, '5OutPower') * INI_MUL_5SECOUTPOWER div INI_MAGIC_DIV_VALUE;
      r5SecDecMagic := aDb.GetFieldValueinteger (aMagicName, '5Magic') * INI_MUL_5SECMAGIC div INI_MAGIC_DIV_VALUE;
      r5SecDecLife := aDb.GetFieldValueinteger (aMagicName, '5Life') * INI_MUL_5SECLIFE div INI_MAGIC_DIV_VALUE;

      rKeepEnergy := aDb.GetFieldValueinteger (aMagicName, 'kEnergy') * 10;
      rKeepInPower:= aDb.GetFieldValueinteger (aMagicName, 'kInPower') * 10;
      rKeepOutPower:= aDb.GetFieldValueinteger (aMagicName, 'kOutPower') * 10;
      rKeepMagic := aDb.GetFieldValueinteger (aMagicName, 'kMagic') * 10;
      rKeepLife := aDb.GetFieldValueinteger (aMagicName, 'kLife') * 10;
   end;
   Result := TRUE;
end;

function TMagicClass.GetHaveMagicData (astr: string; var MagicData: TMagicData): Boolean;
var
   str, rdstr, amagicname: string;
   sexp :integer;
begin
   Result := FALSE;
   str := astr;
   str := GetValidStr3 (str, amagicname, ':');
   str := GetValidStr3 (str, rdstr, ':');
   sexp := _StrToInt (rdstr);
   if GetMagicData (amagicname, MagicData, sexp) = FALSE then exit;
   Result := TRUE;
end;

function TMagicClass.GetHaveMagicString (var MagicData: TMagicData): string;
begin
   Result := StrPas (@MagicData.rName) + ':' + IntToStr(MagicData.rSkillExp)+':';
end;



///////////////////////////////////
//         TItemClass
///////////////////////////////////
constructor TItemClass.Create;
begin
   {
   n := 1;
   for i := 0 to 30 do begin
      MonsterRandomCount[i] := n;
      n := n * 2;
   end;
   }

   ItemDb := TUserStringDb.Create;
   DataList := TList.Create;
   AnsIndexClass := TAnsIndexClass.Create ('ItemClass', 20, TRUE);
   ReLoadFromFile;
end;

destructor  TItemClass.Destroy;
begin
   Clear;
   AnsIndexClass.Free;
   DataList.Free;
   ItemDb.Free;
   inherited Destroy;
end;

procedure TItemClass.Clear;
var i : integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   AnsIndexClass.Clear;
end;

procedure TItemClass.ReLoadFromFile;
var
   i : integer;
   iName : string;
   pid : PTItemData;
begin
   Clear;
   ItemDb.LoadFromFile ('item.sdb');
   for i := 0 to ItemDb.Count -1 do begin
      iName := ItemDb.GetIndexName (i);
      New (pid);
      LoadItemData (iName, pid^);
      {
      rCount := ItemDB.GetFieldValueInteger (iName, 'RandomCount');
      if rCount > 1 then begin
         RandomClass.AddData (iName, rCount);
      end;
      }
      DataList.Add (pid);
      AnsIndexClass.Insert (Integer(pid), iname);
   end;
end;

function  TItemClass.LoadItemData (aItemName: string; var ItemData: TItemData): Boolean;
begin
   Result := FALSE;
   FillChar (ItemData, sizeof(ItemData), 0);
   if ItemDb.GetDbString (aItemName) = '' then exit;


   StrPCopy (@ItemData.rname, aItemName);

   StrToEffectData (ItemData.rSoundEvent, ItemDb.GetFieldValueString (aItemName, 'SoundEvent'));
   StrToEffectData (ItemData.rSoundDrop, ItemDb.GetFieldValueString (aItemName, 'SoundDrop'));

   Itemdata.rLifeData.DamageBody := ItemDb.GetFieldValueinteger (aItemName, 'DamageBody');
   Itemdata.rLifeData.DamageHead := ItemDb.GetFieldValueinteger (aItemName, 'DamageHead');
   Itemdata.rLifeData.DamageArm := ItemDb.GetFieldValueinteger (aItemName, 'DamageArm');
   Itemdata.rLifeData.DamageLeg := ItemDb.GetFieldValueinteger (aItemName, 'DamageLeg');

   Itemdata.rLifeData.ArmorBody := ItemDb.GetFieldValueinteger (aItemName, 'ArmorBody');
   Itemdata.rLifeData.ArmorHead := ItemDb.GetFieldValueinteger (aItemName, 'ArmorHead');
   Itemdata.rLifeData.ArmorArm := ItemDb.GetFieldValueinteger (aItemName, 'ArmorArm');
   Itemdata.rLifeData.ArmorLeg := ItemDb.GetFieldValueinteger (aItemName, 'ArmorLeg');

   Itemdata.rLifeData.AttackSpeed := 0 - ItemDb.GetFieldValueinteger (aItemName, 'AttackSpeed');
   Itemdata.rLifeData.Recovery := 0 - ItemDb.GetFieldValueinteger (aItemName, 'Recovery');
   Itemdata.rLifeData.Avoid := ItemDb.GetFieldValueinteger (aItemName, 'Avoid');
   
   Itemdata.rDurability := ItemDb.GetFieldValueinteger (aItemName, 'Durability');
   Itemdata.rCurDurability := Itemdata.rDurability;
   
   ItemData.rWearArr := ItemDb.GetFieldValueinteger (aItemName, 'WearPos');
   ItemData.rWearShape := ItemDb.GetFieldValueinteger (aItemName, 'WearShape');
   ItemData.rShape := ItemDb.GetFieldValueinteger (aItemName, 'Shape');
   ItemData.rActionImage := ItemDb.GetFieldValueInteger (aItemName, 'ActionImage');
   ItemData.rHitMotion := ItemDb.GetFieldValueinteger (aItemName, 'HitMotion');
   ItemData.rHitType := ItemDb.GetFieldValueinteger (aItemName, 'HitType');
   ItemData.rKind := ItemDb.GetFieldValueinteger (aItemName, 'Kind');
   ItemData.rColor := ItemDb.GetFieldValueinteger (aItemName, 'Color');
   ItemData.rBoDouble := ItemDb.GetFieldValueBoolean (aItemName, 'boDouble');
   ItemData.rBoColoring := ItemDb.GetFieldValueBoolean (aItemName, 'boColoring');
   ItemData.rPrice := ItemDb.GetFieldValueInteger (aItemName, 'Price');
   ItemData.rNeedGrade := ItemDb.GetFieldValueInteger (aItemName, 'NeedGrade');

   ItemData.rSex := ItemDb.GetFieldValueInteger (aItemName, 'Sex');

   ItemData.rServerId := ItemDb.GetFieldValueInteger (aItemName, 'ServerId');
   ItemData.rx := ItemDb.GetFieldValueInteger (aItemName, 'X');
   ItemData.ry := ItemDb.GetFieldValueInteger (aItemName, 'Y');

   ItemData.rCount := 1;

   Result := TRUE;
end;

function    TItemClass.GetItemData (aItemName: string; var ItemData: TItemData): Boolean;
var
   n : integer;
begin
   Result := FALSE;

   n := AnsIndexClass.Select (aItemName);
   if (n = 0) or (n = -1) then begin
      FillChar (ItemData, sizeof(ItemData), 0);
      exit;
   end;
   ItemData := PTItemData (n)^;
   Result := TRUE;
end;

function TItemClass.GetCheckItemData (aObjName : String; aCheckItem : TCheckItem; var ItemData: TItemData): Boolean;
var
   n : integer;
begin
   Result := FALSE;

   n := AnsIndexClass.Select (aCheckItem.rName);
   if (n = 0) or (n = -1) then begin
      FillChar (ItemData, sizeof(ItemData), 0);
      exit;
   end;
   if RandomClass.GetChance (aCheckItem.rName, aObjName) = false then begin
      FillChar (ItemData, sizeof(ItemData), 0);
      exit;
   end;
   
   ItemData := PTItemData (n)^;
   ItemData.rCount := aCheckItem.rCount;

   Result := TRUE;
end;

function TItemClass.GetChanceItemData (aStr, aObjName: string; var ItemData: TItemData): Boolean;
var
   str, rdstr, iname : string;
   icolor, icnt : integer;
   boChance : Boolean;
begin
   Result := FALSE;

   str := astr;

   str := GetValidStr3 (str, iname, ':');
   str := GetValidStr3 (str, rdstr, ':');
   icolor := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   icnt := _StrToInt (rdstr);
   {
   str := GetValidStr3 (str, rdstr, ':');
   iper := _StrToInt (rdstr);
   }

   if GetItemData (iName, ItemData) = FALSE then exit;

   // 기존의 iper 는 천분율이었는데 이것을 MonsterRandomCount 테이블을 이용해서
   // 확률을 정함. rper는 0에서 30 까지의 숫자이어야 됨.
   // 0 = 1/1 = 100%,          30= 1/1000000000 = ??
   {
   if (iper > 30) or (iper < 0)  then begin
      FillChar(ItemData, sizeof(TItemData),0);
      exit;
   end;
   rcount := MonsterRandomCount[iper];
   if Random (rcount) <> 0 then begin
      FillChar(ItemData, sizeof(TItemData),0);
      exit;
   end;
   }

//   if (iper <> 0) and (Random (1000) > iper) then begin FillChar(ItemData, sizeof(TItemData),0); exit; end;
   boChance := RandomClass.GetChance (iName, aObjName);
   if boChance = false then begin
      FillChar(ItemData, sizeof(TItemData),0);
      exit;
   end else begin
      ItemData.rColor := iColor;
      ItemData.rCount := iCnt;
   end;

   Result := TRUE;
end;

function    TItemClass.GetWearItemData (astr: string; var ItemData: TItemData): Boolean;
var
   str, rdstr, iname : string;
   icolor, icnt :integer;
begin
   Result := FALSE;

   str := astr;

   str := GetValidStr3 (str, iname, ':');
   str := GetValidStr3 (str, rdstr, ':');
   icolor := _StrToInt (rdstr);
   str := GetValidStr3 (str, rdstr, ':');
   icnt := _StrToInt (rdstr);

   if GetItemData (iname, ItemData) = FALSE then exit;
   ItemData.rColor := icolor;
   ItemData.rCount := icnt;
   Result := TRUE;
end;

function TItemClass.GetWearItemString (var ItemData: TItemData): string;
begin
   Result := StrPas (@ItemData.rName) + ':' + IntToStr(ItemData.rcolor)+':'+IntToStr(ItemData.rCount) + ':';
end;

{
///////////////////////////////
// TDynamicObjectClass
///////////////////////////////
constructor TDynamicObjectClass.Create;
begin
   DataList := TList.Create;
   AnsIndexClass := TAnsIndexClass.Create ('DynamicItemClass', 20, TRUE);
   LoadFromFile ('DynamicObject.Sdb');
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
   i : integer;
begin
   for i := 0 to DataList.Count - 1 do begin
      Dispose (DataList[i]);
   end;
   DataList.Clear;
   AnsIndexClass.Clear;
end;

function TDynamicObjectClass.GetDynamicObjectData (aObjectName: String; var aObjectData: TDynamicObjectData): Boolean;
var
   n : integer;
begin
   Result := FALSE;

   n := AnsIndexClass.Select (aObjectName);
   if (n = 0) or (n = -1) then begin
      FillChar (aObjectData, sizeof(TDynamicObjectData), 0);
      exit;
   end;
   aObjectData := PTDynamicObjectData (n)^;
   Result := TRUE;
end;

procedure TDynamicObjectClass.LoadFromFile (aName : String);
var
   i : integer;
   iName : String;
   StrDB : TUserStringDb;
   pd : PTDynamicObjectData;
begin
   Clear;

   StrDB := nil;
   pd := nil;
   try
      StrDB := TUserStringDb.Create;
      StrDB.LoadFromFile (aName);
      for i := 0 to StrDb.Count - 1 do begin
         iName := StrDb.GetIndexName (i);
         New (pd);

         pd^.rName := StrDB.GetFieldValueString (iName, 'NAME');
         pd^.rKind := StrDB.GetFieldValueInteger (iName, 'KIND');
         pd^.rShape := StrDB.GetFieldValueInteger (iName, 'SHAPE');
         StrToEffectData (pd^.rSoundEvent, StrDB.GetFieldValueString (iName, 'SOUNDEVENT'));
         StrToEffectData (pd^.rSoundSpecial, StrDB.GetFieldValueString (iName, 'SOUNDSPECIAL'));
         pd^.rComment := StrDB.GetFieldValueString (iName, 'COMMENT');

         DataList.Add (pd);
         AnsIndexClass.Insert (Integer(pd), iName);
      end;
      StrDb.Free;
   except
      if StrDb <> nil then StrDb.Free;
      if pd <> nil then Dispose (pd);
   end;
end;
}
const
   ITEMDRUG_DIV_VALUE            = 10;

   ITEMDRUG_MUL_EVENTENERGY      = 10;
   ITEMDRUG_MUL_EVENTINPOWER     = 10;
   ITEMDRUG_MUL_EVENTOUTPOWER    = 10;
   ITEMDRUG_MUL_EVENTMAGIC       = 10;
   ITEMDRUG_MUL_EVENTLIFE        = 15;
   ITEMDRUG_MUL_EVENTHEADLIFE    = 15;
   ITEMDRUG_MUL_EVENTARMLIFE     = 15;
   ITEMDRUG_MUL_EVENTLEGLIFE     = 15;
   
///////////////////////////////////
//         TItemDrugClass
///////////////////////////////////
constructor TItemDrugClass.Create;
begin
   ItemDrugDb := TUserStringDb.Create;
   DataList := TList.Create;
   AnsIndexClass := TAnsIndexClass.Create ('ItemDrugClass', 20, TRUE);
   ReLoadFromFile;
end;

destructor  TItemDrugClass.Destroy;
begin
   Clear;
   AnsIndexClass.Free;
   DataList.Free;
   ItemDrugDb.Free;
   inherited Destroy;
end;

procedure TItemDrugClass.Clear;
var i : integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   AnsIndexClass.Clear;
end;

procedure TItemDrugClass.ReLoadFromFile;
var
   i : integer;
   iname : string;
   pid : PTItemDrugData;
begin
   Clear;
   ItemDrugDb.LoadFromFile ('itemDrug.sdb');
   for i := 0 to ItemDrugDb.Count -1 do begin
      iname := ItemDrugDb.GetIndexName (i);
      new (pid);
      LoadItemDrugData (iname, pid^);
      DataList.Add (pid);
      AnsIndexClass.Insert (Integer(pid), iname);
   end;
end;

function  TItemDrugClass.LoadItemDrugData (aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
begin
   Result := FALSE;
   FillChar (ItemDrugData, sizeof(ItemDrugData), 0);
   if ItemDrugDb.GetDbString (aItemDrugName) = '' then exit;

   StrPCopy (@ItemDrugData.rname, aItemDrugName);
   ItemDrugData.rEventEnergy   := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eEnergy')   * ITEMDRUG_MUL_EVENTENERGY   div ITEMDRUG_DIV_VALUE;
   ItemDrugData.rEventInPower  := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eInPower')  * ITEMDRUG_MUL_EVENTINPOWER  div ITEMDRUG_DIV_VALUE;
   ItemDrugData.rEventOutPower := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eOutPower') * ITEMDRUG_MUL_EVENTOUTPOWER div ITEMDRUG_DIV_VALUE;
   ItemDrugData.rEventMagic    := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eMagic')    * ITEMDRUG_MUL_EVENTMAGIC    div ITEMDRUG_DIV_VALUE;
   ItemDrugData.rEventLife     := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eLife')     * ITEMDRUG_MUL_EVENTLIFE     div ITEMDRUG_DIV_VALUE;
   ItemDrugData.rEventHeadLife := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eHeadLife') * ITEMDRUG_MUL_EVENTHEADLIFE div ITEMDRUG_DIV_VALUE;
   ItemDrugData.rEventArmLife  := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eArmLife')  * ITEMDRUG_MUL_EVENTARMLIFE  div ITEMDRUG_DIV_VALUE;
   ItemDrugData.rEventLegLife  := ItemDrugDb.GetFieldValueinteger (aItemDrugName, 'eLegLife')  * ITEMDRUG_MUL_EVENTLEGLIFE  div ITEMDRUG_DIV_VALUE;
   Result := TRUE;
end;

function    TItemDrugClass.GetItemDrugData (aItemDrugName: string; var ItemDrugData: TItemDrugData): Boolean;
var
   n : integer;
begin
   Result := FALSE;

   n := AnsIndexClass.Select (aItemDrugName);
   if (n = 0) or (n = -1) then begin
      FillChar (ItemDrugData, sizeof(ItemDrugData), 0);
      exit;
   end;
   ItemDrugData := PTItemDrugData (n)^;
   ItemDrugData.rUsedCount := 0;
   Result := TRUE;
end;


///////////////////////////////////
//         TMonsterClass
///////////////////////////////////
constructor TMonsterClass.Create;
begin
   MonsterDb := TUserStringDb.Create;
   DataList := TList.Create;
   AnsIndexClass := TAnsIndexClass.Create ('Monster', 20, TRUE);
   ReLoadFromFile;
end;

destructor TMonsterClass.Destroy;
begin
   Clear;
   AnsIndexClass.Free;
   DataList.Free;
   MonsterDb.Free;
   inherited Destroy;
end;

procedure TMonsterClass.Clear;
var i : integer;
begin
   for i := 0 to DataList.Count -1 do dispose (DataList[i]);
   DataList.Clear;
   AnsIndexClass.Clear;
end;

function  TMonsterClass.LoadMonsterData (aMonsterName: string; var MonsterData: TMonsterData): Boolean;
var
   i, iCount, iRandomCount : Integer;
   str, mName, mCount, mSkill: String;
begin
   Result := FALSE;
   FillChar (MonsterData, sizeof(MonsterData), 0);
   if MonsterDb.GetDbString (aMonsterName) = '' then exit;

   StrPCopy (@MonsterData.rname, aMonsterName);
   StrToEffectData (MonsterData.rSoundNormal, MonsterDb.GetFieldValueString (aMonsterName, 'SoundNormal'));
   StrToEffectData (MonsterData.rSoundAttack, MonsterDb.GetFieldValueString (aMonsterName, 'SoundAttack'));
   StrToEffectData (MonsterData.rSoundDie, MonsterDb.GetFieldValueString (aMonsterName, 'SoundDie'));
   StrToEffectData (MonsterData.rSoundStructed, MonsterDb.GetFieldValueString (aMonsterName, 'SoundStructed'));

   MonsterData.rAnimate := MonsterDb.GetFieldValueinteger (aMonsterName, 'Animate');
   MonsterData.rWalkSpeed := MonsterDb.GetFieldValueinteger (aMonsterName, 'WalkSpeed');
   MonsterData.rShape := MonsterDb.GetFieldValueinteger (aMonsterName, 'Shape');
   MonsterData.rdamage := MonsterDb.GetFieldValueinteger (aMonsterName, 'Damage');
   MonsterData.rAttackSpeed := MonsterDb.GetFieldValueinteger (aMonsterName, 'AttackSpeed');
   MonsterData.ravoid := MonsterDb.GetFieldValueinteger (aMonsterName, 'Avoid');
   MonsterData.rrecovery := MonsterDb.GetFieldValueinteger (aMonsterName, 'Recovery');
   MonsterData.rspendlife := MonsterDb.GetFieldValueinteger (aMonsterName, 'SpendLife');
   MonsterData.rarmor := MonsterDb.GetFieldValueinteger (aMonsterName, 'Armor');
   MonsterData.rlife := MonsterDb.GetFieldValueinteger (aMonsterName, 'Life');

   str := MonsterDb.GetFieldValueString (aMonsterName, 'HaveItem');
   for i := 0 to 5 - 1 do begin
      if str = '' then break;
      str := GetValidStr3 (str, mName, ':');
      if mName = '' then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iCount := _StrToInt (mCount);
      if iCount <= 0 then break;
      str := GetValidStr3 (str, mCount, ':');
      if mCount = '' then break;
      iRandomCount := _StrToInt (mCount);
      if iRandomCount <= 0 then iRandomCount := 1;
      MonsterData.rHaveItem[i].rName := mName;
      MonsterData.rHaveItem[i].rCount := iCount;

      RandomClass.AddData (mName, aMonsterName,iRandomCount); 
   end;

   MonsterData.rboViewHuman := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boViewHuman');
   MonsterData.rboAutoAttack := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boAutoAttack');
   MonsterData.rEscapeLife := MonsterDb.GetFieldValueinteger (aMonsterName, 'EscapeLife');
   MonsterData.rViewWidth := MonsterDb.GetFieldValueinteger (aMonsterName, 'ViewWidth');
   MonsterData.rboBoss := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boBoss');
   MonsterData.rboChangeTarget := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boChangeTarget');
   MonsterData.rboVassal := MonsterDb.GetFieldValueBoolean (aMonsterName, 'boVassal');
   MonsterData.rVassalCount := MonsterDb.GetFieldValueinteger (aMonsterName, 'VassalCount');

   str := MonsterDb.GetFieldValueString (aMonsterName, 'AttackMagic');
   str := GetValidStr3 (str, mname, ':');
   str := GetValidStr3 (str, mskill, ':');

   MagicClass.GetMagicData (mname, MonsterData.rAttackMagic, _StrToInt(mskill));
   
   Result := TRUE;
end;

procedure TMonsterClass.ReLoadFromFile;
var
   i : integer;
   iname : string;
   pmd : PTMonsterData;
begin
   Clear;
   MonsterDb.LoadFromFile ('monster.sdb');
   for i := 0 to MonsterDb.Count -1 do begin
      iname := MonsterDb.GetIndexName (i);
      new (pmd);
      LoadMonsterData (iname, pmd^);
      DataList.Add (pmd);
      AnsIndexClass.Insert (Integer(pmd), iname);
   end;
end;

function TMonsterClass.GetMonsterData (aMonsterName: string; pMonsterData: PTMonsterData): Boolean;
var
   n : integer;
begin
   Result := FALSE;

   n := AnsIndexClass.Select (aMonsterName);
   if (n = 0) or (n = -1) then begin
      FillChar (pMonsterData^, SizeOf (TMonsterData), 0);
      exit;
   end;

   Move (PTMonsterData(n)^, pMonsterData^, SizeOf (TMonsterData));

   Result := TRUE;
end;

function TMonsterClass.GetMonsterDataPointer (aMonsterName : String) : PTMonsterData;
var
   n : integer;
begin
   Result := nil;

   n := AnsIndexClass.Select (aMonsterName);
   if (n = 0) or (n = -1) then exit;

   Result := PTMonsterData (n);
end;

///////////////////////////////////
//         TNpcClass
///////////////////////////////////
constructor TNpcClass.Create;
begin
   DataList := TList.Create;
   KeyClass := TStringKeyClass.Create;
   
   LoadFromFile ('.\Npc.SDB');
end;

destructor TNpcClass.Destroy;
begin
   Clear;
   
   KeyClass.Free;
   DataList.Free;

   inherited destroy;
end;

procedure TNpcClass.Clear;
var
   i : integer;
   pd : PTNpcData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      Dispose (pd);
   end;
   DataList.Clear;
   KeyClass.Clear;
end;

procedure TNpcClass.LoadFromFile (aFileName : String);
var
   i, j : Integer;
   iCount, iRandomCount : integer;
   iName, Str, mName, mCount : String;
   pd : PTNpcData;
   DB : TUserStringDB;
begin
   Clear;

   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      FillChar (pd^, SizeOf (TNpcData), 0);

      StrPCopy (@pd^.rName, iName);

      pd^.rShape := DB.GetFieldValueInteger (iName, 'Shape');
      pd^.rAnimate := DB.GetFieldValueInteger (iName, 'Animate');
      pd^.rdamage := DB.GetFieldValueInteger (iName, 'Damage');
      pd^.rAttackSpeed := DB.GetFieldValueInteger (iName, 'AttackSpeed');
      pd^.rAvoid := DB.GetFieldValueInteger (iName, 'Avoid');
      pd^.rRecovery := DB.GetFieldValueInteger (iName, 'Recovery');
      pd^.rSpendlife := DB.GetFieldValueInteger (iName, 'SpendLife');
      pd^.rArmor := DB.GetFieldValueInteger (iName, 'Armor');
      pd^.rLife := DB.GetFieldValueInteger (iName, 'Life');
      pd^.rboProtecter := DB.GetFieldValueBoolean (iName, 'boProtecter');
      pd^.rboAutoAttack := DB.GetFieldValueBoolean (iName, 'boAutoAttack');
      pd^.rboSeller := DB.GetFieldValueBoolean (iName, 'boSeller');
      pd^.rActionWidth := DB.GetFieldValueInteger (iName, 'ActionWidth');

      str := DB.GetFieldValueString (iName, 'HaveItem');
      for j := 0 to 5 - 1 do begin
         if str = '' then break;
         str := GetValidStr3 (str, mName, ':');
         if mName = '' then break;
         str := GetValidStr3 (str, mCount, ':');
         if mCount = '' then break;
         iCount := _StrToInt (mCount);
         if iCount <= 0 then break;
         str := GetValidStr3 (str, mCount, ':');
         if mCount = '' then break;
         iRandomCount := _StrToInt (mCount);
         if iRandomCount <= 0 then iRandomCount := 1;

         pd^.rHaveItem[j].rName := mName;
         pd^.rHaveItem[j].rCount := iCount;

         RandomClass.AddData (mName, iName, iRandomCount);
      end;

      str := DB.GetFieldValueString (iName, 'NpcText');
      StrPCopy (@pd^.rNpcText, str);

      pd^.rAnimate := DB.GetFieldValueInteger (iName, 'Animate');
      pd^.rShape := DB.GetFieldValueInteger (iName, 'Shape');

      StrToEffectData (pd^.rSoundNormal, DB.GetFieldValueString (iName, 'SoundNormal'));
      StrToEffectData (pd^.rSoundAttack, DB.GetFieldValueString (iName, 'SoundAttack'));
      StrToEffectData (pd^.rSoundDie, DB.GetFieldValueString (iName, 'SoundDie'));
      StrToEffectData (pd^.rSoundStructed, DB.GetFieldValueString (iName, 'SoundStructed'));

      DataList.Add (pd);
      KeyClass.Insert (iName, pd);
   end;

   DB.Free;
end;

function TNpcClass.GetNpcDataPointer (aNpcName: String) : PTNpcData;
var
   pd : PTNpcData;
begin
   Result := nil;

   pd := KeyClass.Select (aNpcName);
   if pd = nil then exit;

   Result := pd;
end;

function TNpcClass.GetNpcData (aNpcName: String; aNpcData: PTNpcData): Boolean;
var
   pd : PTNpcData;
begin
   Result := FALSE;

   pd := KeyClass.Select (aNpcName);
   if pd = nil then begin
      FillChar (aNpcData^, SizeOf (TNpcData), 0);
      exit;
   end;
   
   Move (pd^, aNpcData^, SizeOf (TNpcData));

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
   i : Integer;
begin
   for i := 0 to DataList.Count - 1 do begin
      Dispose (DataList[i]);
   end;
   DataList.Clear;
end;

procedure TPosByDieClass.ReLoadFromFile;
var
   i : Integer;
   iName : String;
   StrDB : TUserStringDB;
   pd : PTPosByDieData;
begin
   StrDB := TUserStringDB.Create;
   StrDB.LoadFromFile ('PosByDie.SDB');

   for i := 0 to StrDB.Count - 1 do begin
      iName := StrDB.GetIndexName (i);
      if iName <> '' then begin
         New (pd);
         FillChar (pd^, sizeof (PTPosByDieData), 0);
         pd^.rServerID := StrDB.GetFieldValueInteger (iName, 'Server');
         pd^.rDestServerID := StrDB.GetFieldValueInteger (iName, 'DestServer');
         pd^.rDestX := StrDB.GetFieldValueInteger (iName, 'DestX');
         pd^.rDestY := StrDB.GetFieldValueInteger (iName, 'DestY');

         DataList.Add (pd);
      end;
   end;

   StrDB.Free;
end;

procedure TPosByDieClass.GetPosByDieData (aServerID : Integer; var aDestServerID : Integer; var aDestX, aDestY : Word);
var
   i : Integer;
   pd : PTPosByDieData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then begin
         if pd^.rServerID = aServerID then begin
            aDestServerID := pd^.rDestServerID;
            aDestX := pd^.rDestX;
            aDestY := pd^.rDestY;
            exit;
         end;
      end;
   end;
end;

{
constructor TQuestClass.Create;
begin
end;

destructor TQuestClass.Destroy;
begin
   inherited Destroy;
end;

function TQuestClass.CheckQuest1 (aServerID : Integer; var aRetStr : String) : Boolean;
var
   tmpManager : TManager;
   iMonster, iNpc : Integer;
begin
   Result := false;
   tmpManager := ManagerList.GetManagerByServerID (aServerID);
   if tmpManager <> nil then begin
      iMonster := TMonsterList (tmpManager.MonsterList).Count;
      iNpc := TNpcList (tmpManager.NpcList).Count;
      if (iMonster <= 0) and (iNpc <= 0) then begin
         Result := true;
         exit;
      end;
      aRetStr := '';
      if iMonster > 0 then begin
         aRetStr := aRetStr + format ('MONSTER(%d)', [iMonster]);
      end;
      if (iMonster > 0) and (iNpc > 0) then begin
         aRetStr := aRetStr + ', ';
      end;
      if iNpc > 0 then begin
         aRetStr := aRetStr + format ('NPC(%d)', [iNpc]);
      end;
      aRetStr := aRetStr + ' 생존';
   end;
end;

function TQuestClass.GetQuestString (aQuest : Integer) : String;
begin
   Result := '';
end;

function TQuestClass.CheckQuestComplete (aQuest, aServerID : Integer; var aRetStr : String) : Boolean;
begin
   Result := false;
   Case aQuest of
      1 : Result := CheckQuest1 (aServerID, aRetStr);
   end;
end;
}

////////////////////////////////////////////////////
//
//             ===  AreaClass  ===
//
////////////////////////////////////////////////////

constructor TAreaClass.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\AreaData.SDB');
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
   i : Integer;
begin
   for i := 0 to DataList.Count - 1 do Dispose (DataList[i]);
   DataList.Clear;
end;

procedure TAreaClass.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   pd : PTAreaClassData;
   AreaDB : TUserStringDb;
begin
   Clear;

   if not FileExists (aFileName) then exit;

   AreaDB := TUserStringDb.Create;
   AreaDB.LoadFromFile (aFileName);

   for i := 0 to AreaDB.Count - 1 do begin
      iName := AreaDB.GetIndexName (i);
      if iName = '' then continue;
      
      New (pd);
      FillChar (pd^, sizeof(TAreaClassData), 0);

      pd^.Name := AreaDB.GetFieldValueString (iName, 'Name');
      pd^.Index := AreaDB.GetFieldValueInteger (iName, 'Index');
      pd^.Func := AreaDB.GetFieldValueString (iName, 'Func');
      pd^.Desc := AreaDB.GetFieldValueString (iName, 'Desc');
      
      DataList.Add (pd);
   end;
   AreaDB.Free;
end;

function TAreaClass.CanMakeGuild (aIndex : Byte) : Boolean;
var
   i : Integer;
   str, rdstr : String;
   pd : PTAreaClassData;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd^.Index = aIndex then begin
         str := pd^.func;
         while str <> '' do begin
            str := GetValidStr3 (str, rdstr, ':');
            if _StrToInt (rdstr) = AREA_CANMAKEGUILD then begin
               Result := true;
               exit;
            end;
         end;
         exit;
      end;
   end;
end;

function TAreaClass.GetAreaName (aIndex : Byte) : String;
var
   i : Integer;
   pd : PTAreaClassData;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd^.Index = aIndex then begin
         Result := pd^.Name;
         exit;
      end;
   end;
end;

function TAreaClass.GetAreaDesc (aIndex : Byte) : String;
var
   i : Integer;
   pd : PTAreaClassData;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd^.Index = aIndex then begin
         Result := pd^.Desc;
         exit;
      end;
   end;
end;

{
constructor TPrisonClass.Create;
begin
   SaveTick := mmAnsTick;
   DataList := TList.Create;
   LoadFromFile ('Prison.SDB');
end;

destructor TPrisonClass.Destroy;
begin
   if DataList <> nil then begin
      SaveToFile ('Prison.SDB');
      Clear;
      DataList.Free;
   end;
   inherited Destroy;
end;

function TPrisonClass.GetPrisonTime (aType : String) : Integer;
var
   i : Integer;
   sKind, sCount : String;
   Count, SumTime : Integer;
begin
   SumTime := 0;

   sKind := Copy (aType, 1, 1);
   sCount := Copy (aType, 2, Length (aType) - 1);
   Count := _StrToInt (sCount);

   if UpperCase (sKind) = 'A' then begin
      SumTime := 3;
      for i := 1 to Count - 1 do begin
         SumTime := SumTime * 2;
      end;
   end else if UpperCase (sKind) = 'B' then begin
      SumTime := Count;
   end;

   SumTime := SumTime * 24 * 60;
   
   Result := SumTime;
end;

function TPrisonClass.GetPrisonData (aName : String) : PTPrisonData;
var
   i : Integer;
   pd : PTPrisonData;
begin
   Result := nil;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd = nil then continue;
      if pd^.rUserName = aName then begin
         Result := pd;
         exit;
      end;
   end;
end;

procedure TPrisonClass.Update (CurTick : Integer);
begin
   if SaveTick + 5 * 60 * 100 <= CurTick then begin
      SaveTick := CurTick;
      SaveToFile ('Prison.SDB');
   end;
end;

procedure TPrisonClass.Clear;
var
   i : Integer;
   pd : PTPrisonData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then Dispose (pd);
   end;
   DataList.Clear;
end;

function TPrisonClass.LoadFromFile (aFileName : String) : Boolean;
var
   i : Integer;
   PrisonDB : TUserStringDB;
   iName : String;
   pd : PTPrisonData;
begin
   Result := false;

   if not FileExists (aFileName) then exit;

   PrisonDB := TUserStringDB.Create;
   PrisonDB.LoadFromFile (aFileName);

   for i := 0 to PrisonDB.Count - 1 do begin
      iName := PrisonDB.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      FillChar (pd^, sizeof (TPrisonData), 0);

      pd^.rUserName := PrisonDB.GetFieldValueString (iName, 'UserName');
      pd^.rPrisonType := PrisonDB.GetFieldValueString (iName, 'PrisonType');
      pd^.rElaspedTime := PrisonDB.GetFieldValueInteger (iName, 'ElaspedTime');
      pd^.rPrisonTime := GetPrisonTime (pd^.rPrisonType);
      pd^.rReason := PrisonDB.GetFieldValueString (iName, 'Reason');

      DataList.Add (pd);
   end;

   PrisonDB.Free;

   Result := true;
end;

function TPrisonClass.SaveToFile (aFileName : String) : Boolean;
var
   i : Integer;
   iName : String;
   PrisonDB : TUserStringDB;
   pd : PTPrisonData;
begin
   Result := false;

   PrisonDB := TUserStringDB.Create;
   PrisonDB.LoadFromFile (aFileName);
   for i := 0 to PrisonDB.Count - 1 do begin
      iName := PrisonDB.GetIndexName (i);
      PrisonDB.DeleteName (iName);
   end;

   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if pd <> nil then begin
         PrisonDB.AddName (pd^.rUserName);
         PrisonDB.SetFieldValueString (pd^.rUserName, 'UserName', pd^.rUserName);
         PrisonDB.SetFieldValueInteger (pd^.rUserName, 'PrisonTime', pd^.rPrisonTime);
         PrisonDB.SetFieldValueInteger (pd^.rUserName, 'ElaspedTime', pd^.rElaspedTime);
         PrisonDB.SetFieldValueString (pd^.rUserName, 'PrisonType', pd^.rPrisonType);
         PrisonDB.SetFieldValueString (pd^.rUserName, 'Reason', pd^.rReason);
      end;
   end;

   PrisonDB.SaveToFile (aFileName);
   PrisonDB.Free;

   Result := true;
end;

function TPrisonClass.AddUser (aName, aType, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
   pUser : TUser;
begin
   Result := '';

   if aName = '' then begin
      Result := '사용자 이름을 지정해 주세요';
      exit;
   end;
   if GetPrisonData (aName) <> nil then begin
      Result := '이미 수감된 사용자입니다';
      exit;
   end;
   rTime := GetPrisonTime (aType);
   if rTime = 0 then begin
      Result := '시간설정이 잘못되었습니다';
      exit;
   end;

   New (pd);
   FillChar (pd^, sizeof (TPrisonData), 0);

   pd^.rUserName := aName;
   pd^.rElaspedTime := 0;
   pd^.rPrisonTime := rTime;
   pd^.rPrisonType := aType;
   pd^.rReason := aReason;

   DataList.Add (pd);

   pUser := UserList.GetUserPointer (aName);
   if pUser <> nil then begin
      pUser.SendClass.SendChatMessage ('지금부터 유배지에 수감됩니다. 다시 접속 해 주세요', SAY_COLOR_SYSTEM);
      ConnectorList.CloseConnectByCharName(aName);      
   end;
end;

function TPrisonClass.DelUser (aName : String) : String;
var
   pd : PTPrisonData;
   rIndex : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := '사용자 이름을 지정해 주세요';
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := '수감되어 있는 사용자가 아닙니다';
      exit;
   end;
   rIndex := DataList.IndexOf (pd);
   if rIndex >= 0 then DataList.Delete (rIndex);
end;

function TPrisonClass.UpdateUser (aName, aType, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := '사용자 이름을 지정해 주세요';
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := '수감되어 있는 사용자가 아닙니다';
      exit;
   end;

   rTime := GetPrisonTime (aType);
   if rTime = 0 then begin
      Result := '시간설정이 잘못되었습니다';
      exit;
   end;
   pd^.rPrisonTime := rTime;
   pd^.rElaspedTime := 0;
   pd^.rPrisonType := aType;
   if aReason <> '' then begin
      pd^.rReason := aReason;
   end;
end;

function TPrisonClass.PlusUser (aName, aType, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := '사용자 이름을 지정해 주세요';
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := '수감되어 있는 사용자가 아닙니다';
      exit;
   end;

   rTime := GetPrisonTime (aType);
   if rTime = 0 then begin
      Result := '시간설정이 잘못되었습니다';
      exit;
   end;
   pd^.rPrisonTime := pd^.rPrisonTime + rTime;
   pd^.rPrisonType := aType;
   if aReason <> '' then begin
      pd^.rReason := aReason;
   end;
end;

function TPrisonClass.EditUser (aName, aTime, aReason : String) : String;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := '';

   if aName = '' then begin
      Result := '사용자 이름을 지정해 주세요';
      exit;
   end;

   pd := GetPrisonData (aName);
   if pd = nil then begin
      Result := '수감되어 있는 사용자가 아닙니다';
      exit;
   end;

   rTime := _StrToInt (aTime);
   pd^.rPrisonTime := rTime;
   pd^.rPrisonType := 'C';
   if aReason <> '' then begin
      pd^.rReason := aReason;
   end;
end;


function TPrisonClass.GetUserStatus (aName : String) : String;
var
   pd : PTPrisonData;
   TotalMin : Integer;
   nDay, nHour, nMin : Word;
   rStr : String;
begin
   Result := '';
   pd := GetPrisonData (aName);
   if pd = nil then exit;

   nDay := 0; nHour := 0; nMin := 0;
   TotalMin := pd^.rPrisonTime;
   nDay := (TotalMin div (60 * 24));
   TotalMin := TotalMin - (nDay * 60 * 24);
   nHour := (TotalMin div 60);
   TotalMin := TotalMin - (nHour * 60);
   nMin := TotalMin;

   rStr := format ('수감시간(%d일%d시간%d분)', [nDay, nHour, nMin]);

   nDay := 0; nHour := 0; nMin := 0;
   TotalMin := pd^.rPrisonTime - pd^.rElaspedTime;
   nDay := (TotalMin div (60 * 24));
   TotalMin := TotalMin - (nDay * 60 * 24);
   nHour := (TotalMin div 60);
   TotalMin := TotalMin - (nHour * 60);
   nMin := TotalMin;

   rStr := rStr + format (' 남은시간(%d일%d시간%d분)', [nDay, nHour, nMin]);

   Result := rStr;
end;

function TPrisonClass.IncreaseElaspedTime (aName : String; aTime : Integer) : Integer;
var
   pd : PTPrisonData;
   rTime : Integer;
begin
   Result := 0;
   pd := GetPrisonData (aName);
   if pd = nil then exit;

   pd^.rElaspedTime := pd^.rElaspedTime + aTime;

   rTime := pd^.rPrisonTime - pd^.rElaspedTime;

   if rTime = 0 then DelUser (aName);

   Result := rTime;
end;
}  

constructor TNpcFunction.Create;
begin
   DataList := TList.Create;

   LoadFromFile ('.\NpcFunction\NpcFunction.SDB');
end;

destructor TNpcFunction.Destroy;
begin
   Clear;
   DataList.Free;
end;

procedure TNpcFunction.Clear;
var
   i : Integer;
   pd : PTNpcFunctionData;
begin
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      Dispose (pd);
   end;
   DataList.Clear;
end;

procedure TNpcFunction.LoadFromFile (aFileName : String);
var
   i : Integer;
   iName : String;
   DB : TUserStringDB;
   pd : PTNpcFunctionData;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      New (pd);
      FillChar (pd^, SizeOf (TNpcFunctionData), 0);
      pd^.Index := _StrToInt (iName);
      pd^.FuncType := DB.GetFieldValueInteger (iName, 'FuncType');
      pd^.Text := DB.GetFieldValueString (iName, 'Text');
      pd^.FileName := DB.GetFieldValueString (iName, 'FileName');
      pd^.StartQuest := DB.GetFieldValueInteger (iName, 'StartQuest');
      pd^.NextQuest := DB.GetFieldValueInteger (iName, 'NextQuest');

      DataList.Add (pd);
   end;

   DB.Free;
end;

function TNpcFunction.GetFunction (aIndex : Integer) : PTNpcFunctionData;
var
   i : Integer;
   pd : PTNpcFunctionData;
begin
   Result := nil;
   
   for i := 0 to DataList.Count - 1 do begin
      pd := DataList.Items [i];
      if aIndex = pd^.Index then begin
         Result := pd;
         exit;
      end;
   end;
end;

procedure LoadGameIni (aName: string);
var ini: TIniFile;
begin
   ini := TIniFile.Create (aName);

   INI_WHO             := ini.ReadString ('STRINGS','WHO','/WHO');
   INI_SERCHSKILL      := ini.ReadString ('STRINGS','SERCHSKILL','@SERCHSKILL');
   INI_WHITEDRUG       := ini.ReadString ('STRINGS','WHITEDRUG','WHITEDRUG');
   INI_ROPE            := ini.ReadString ('STRINGS','ROPE','ROPE');
   INI_SEX_FIELD_MAN   := ini.ReadString ('STRINGS','SEX_FIELD_MAN','MAN');
   INI_SEX_FIELD_WOMAN := ini.ReadString ('STRINGS','SEX_FIELD_WOMAN','WOMAN');
   INI_GUILD_STONE     := ini.ReadString ('STRINGS','GUILD_STONE','GUILDSTONE');
   INI_GUILD_NPC_NAME  := ini.ReadString ('STRINGS','GUILD_NPC_NAME','NPC');
   INI_GOLD            := ini.ReadString ('STRINGS','GOLD','GOLD');


   INI_Guild_MAN_SEX           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_SEX','MAN');
   INI_Guild_MAN_CAP           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_CAP','');
   INI_Guild_MAN_HAIR          := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_HAIR','');
   INI_GUILD_MAN_UPUNDERWEAR   := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_UPUNDERWEAR','');
   INI_Guild_MAN_UPOVERWEAR    := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_UPOVERWEAR','');
   INI_Guild_MAN_DOWNUNDERWEAR := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_DOWNUNDERWEAR','');
   INI_Guild_MAN_GLOVES        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_GLOVES','');
   INI_Guild_MAN_SHOES         := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_SHOES','');
   INI_Guild_MAN_WEAPON        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_MAN_WEAPON','');

   INI_Guild_WOMAN_SEX           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_SEX','WOMAN');
   INI_Guild_WOMAN_CAP           := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_CAP','');
   INI_Guild_WOMAN_HAIR          := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_HAIR','');
   INI_GUILD_WOMAN_UPUNDERWEAR   := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_UPUNDERWEAR','');
   INI_Guild_WOMAN_UPOVERWEAR    := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_UPOVERWEAR','');
   INI_Guild_WOMAN_DOWNUNDERWEAR := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_DOWNUNDERWEAR','');
   INI_Guild_WOMAN_GLOVES        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_GLOVES','');
   INI_Guild_WOMAN_SHOES         := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_SHOES','');
   INI_Guild_WOMAN_WEAPON        := ini.ReadString ('GUILD_NPC_WEAR','GUILD_WOMAN_WEAPON','');


   INI_DEF_WRESTLING   := ini.ReadString ('DEFAULT_MAGIC','DEF_WRESTLING','WRESTLING');
   INI_DEF_FENCING     := ini.ReadString ('DEFAULT_MAGIC','DEF_FENCING','FENCING');
   INI_DEF_SWORDSHIP   := ini.ReadString ('DEFAULT_MAGIC','DEF_SWORDSHIP','SWORDSHIP');
   INI_DEF_HAMMERING   := ini.ReadString ('DEFAULT_MAGIC','DEF_HAMMERING','HAMMERING');
   INI_DEF_SPEARING    := ini.ReadString ('DEFAULT_MAGIC','DEF_SPEARING','SPEARING');
   INI_DEF_BOWING      := ini.ReadString ('DEFAULT_MAGIC','DEF_BOWING','BOWING');
   INI_DEF_THROWING    := ini.ReadString ('DEFAULT_MAGIC','DEF_THROWING','THROWING');
   INI_DEF_RUNNING     := ini.ReadString ('DEFAULT_MAGIC','DEF_RUNNING','RUNNING');
   INI_DEF_BREATHNG    := ini.ReadString ('DEFAULT_MAGIC','DEF_BREATHNG','BREATHNG');
   INI_DEF_PROTECTING  := ini.ReadString ('DEFAULT_MAGIC','DEF_PROTECTING','PROTECTING');


   INI_NORTH     := ini.ReadString ('DIRECTION_NAMES','NORTH','NORTH');
   INI_NORTHEAST := ini.ReadString ('DIRECTION_NAMES','NORTHEAST','NORTHEAST');
   INI_EAST      := ini.ReadString ('DIRECTION_NAMES','EAST','EAST');
   INI_EASTSOUTH := ini.ReadString ('DIRECTION_NAMES','EASTSOUTH','EASTSOUTH');
   INI_SOUTH     := ini.ReadString ('DIRECTION_NAMES','SOUTH','SOUTH');
   INI_SOUTHWEST := ini.ReadString ('DIRECTION_NAMES','SOUTHWEST','SOUTHWEST');
   INI_WEST      := ini.ReadString ('DIRECTION_NAMES','WEST','WEST');
   INI_WESTNORTH := ini.ReadString ('DIRECTION_NAMES','WESTNORTH','WESTNORTH');

   INI_HIDEPAPER_DELAY := ini.Readinteger ('ITEM_VALUES','HIDEPAPER_DELAY', 15);

   INI_MAGIC_DIV_VALUE     := ini.Readinteger ('MAGIC_VALUES','MAGIC_DIV_VALUE', 10);
   INI_ADD_DAMAGE          := ini.Readinteger ('MAGIC_VALUES','ADD_DAMAGE', 40);
   INI_MUL_ATTACKSPEED     := ini.Readinteger ('MAGIC_VALUES','MUL_ATTACKSPEED', 10);
   INI_MUL_AVOID           := ini.Readinteger ('MAGIC_VALUES','MUL_AVOID',6);
   INI_MUL_RECOVERY        := ini.Readinteger ('MAGIC_VALUES','MUL_RECOVERY',10);
   INI_MUL_DAMAGEBODY      := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGEBODY',23);
   INI_MUL_DAMAGEHEAD      := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGEHEAD',17);
   INI_MUL_DAMAGEARM       := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGEARM',17);
   INI_MUL_DAMAGELEG       := ini.Readinteger ('MAGIC_VALUES','MUL_DAMAGELEG',17);
   INI_MUL_ARMORBODY       := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORBODY',7);
   INI_MUL_ARMORHEAD       := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORHEAD',7);
   INI_MUL_ARMORARM        := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORARM',7);
   INI_MUL_ARMORLEG        := ini.Readinteger ('MAGIC_VALUES','MUL_ARMORLEG',7);

   INI_MUL_EVENTENERGY     := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTENERGY',20);
   INI_MUL_EVENTINPOWER    := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTINPOWER',22);
   INI_MUL_EVENTOUTPOWER   := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTOUTPOWER',22);
   INI_MUL_EVENTMAGIC      := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTMAGIC',10);
   INI_MUL_EVENTLIFE       := ini.Readinteger ('MAGIC_VALUES','MUL_EVENTLIFE',8);

   INI_MUL_5SECENERGY      := ini.Readinteger ('MAGIC_VALUES','MUL_5SECENERGY',20);
   INI_MUL_5SECINPOWER     := ini.Readinteger ('MAGIC_VALUES','MUL_5SECINPOWER',14);
   INI_MUL_5SECOUTPOWER    := ini.Readinteger ('MAGIC_VALUES','MUL_5SECOUTPOWER',14);
   INI_MUL_5SECMAGIC       := ini.Readinteger ('MAGIC_VALUES','MUL_5SECMAGIC',9);
   INI_MUL_5SECLIFE        := ini.Readinteger ('MAGIC_VALUES','MUL_5SECLIFE',8);


   INI_SKILL_DIV_DAMAGE      := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_DAMAGE',5000);
   INI_SKILL_DIV_ARMOR       := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_ARMOR', 5000);
   INI_SKILL_DIV_ATTACKSPEED := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_ATTACKSPEED', 25000);
   INI_SKILL_DIV_EVENT       := ini.Readinteger ('MAGIC_VALUES','SKILL_DIV_EVENT', 5000);

   ini.free;
end;

Initialization
begin
   NameStringListForDeleteMagic := TStringList.Create;

   NpcFunction := TNpcFunction.Create;
//   PrisonClass := TPrisonClass.Create;
   RandomClass := TRandomClass.Create;
   // QuestClass := TQuestClass.Create;
   AreaClass := TAreaClass.Create;
   PosByDieClass := TPosByDieClass.Create;
   SysopClass := TSysopclass.Create;
   LoadGameIni ('.\game.ini');
   NpcClass := TNpcClass.Create;
   ItemClass := TItemClass.Create;
//   DynamicObjectClass := TDynamicObjectClass.Create;
   ItemDrugClass := TItemDrugClass.Create;
   MagicClass := TMagicClass.Create;

   MonsterClass := TMonsterClass.Create;

   UserData := TUserStringDb.Create;
   UserData.LoadFromFile ('fielduser.sdb');
end;

Finalization
begin
   UserData.Free;

   MonsterClass.Free;
   MagicClass.Free;
   ItemClass.Free;
//   DynamicObjectClass.Free;
   ItemDrugClass.Free;
   NpcClass.Free;
   SysopClass.free;
   PosByDieClass.Free;
   AreaClass.Free;
   // QuestClass.Free;
   RandomClass.Free;
//   PrisonClass.Free;
   NpcFunction.Free;

   NameStringListForDeleteMagic.Free;
end;

end.
