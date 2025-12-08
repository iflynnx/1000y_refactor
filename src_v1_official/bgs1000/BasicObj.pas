unit BasicObj;

interface

uses
  Windows, Classes, SysUtils, svClass, SubUtil, uAnsTick, AnsUnit,
  FieldMsg, MapUnit, DefType, Autil32, uGroup, AnsStringCls, uSendCls, uConnect;

type
   TBasicObject = class
   private
      FCreateTick : integer;
      FCreateX, FCreateY : integer;
      function  GetPosx: integer;
      function  GetPosy: integer;
      function  GetFeatureState: TFeatureState;
   protected
      FboRegisted : Boolean;
      FboAllowDelete : Boolean;
      
      function  isRange (xx, yy: word) : Boolean;
      function  isRangeMessage (hfu: Longint; Msg: word; var SenderInfo: TBasicData): Boolean;
      function  FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; dynamic;
      function  GetViewObjectById (aid: integer): TBasicObject;
      function  SendLocalMessage (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;

      function  isHitedArea (adir, ax, ay: integer; afunc: byte; var apercent: integer) : Boolean;
      function  GetViewObjectByName (aName: string; aRace: integer): TBasicObject;
      procedure Initial (aName, aViewName: String);
      procedure StartProcessByDir (aDir : Integer); dynamic;
      procedure StartProcess; dynamic;
      procedure EndProcess; dynamic;

      procedure BocSay (astr: string);
      procedure BocChangeFeature;

      procedure BoSysopMessage (astr: string; aSysopScope: integer);
   public
      procedure SetManagerClass (aManager : TBattleRoom);
   public
      Manager : TBattleRoom;
      Maper : TMaper;
      Phone : TFieldPhone;
      ServerID : Integer;

      BasicData : TBasicData;                         // 공용변수
      ViewObjectList : TList;

      constructor Create;
      destructor  Destroy; override;
      procedure   Update (CurTick: integer); dynamic;
      procedure   BocChangeProperty;

      function    FindViewObject (aBasicObject : TBasicObject) : Boolean;

      property    PosX : integer read GetPosX;
      property    PosY : integer read GetPosY;
      property    CreateX : integer read FCreateX;
      property    CreateY : integer read FCreateY;
      property    CreateTick : integer read FCreateTick;
      property    boAllowDelete: Boolean read FboAllowDelete write FboAllowDelete;
      property    boRegisted : Boolean read FboRegisted;
      property    State : TFeatureState read GetFeatureState;
   end;

   TItemObject = class (TBasicObject)
    private
     SelfItemData : TItemData;
     OwnerId : Integer;
     boAllowPickup : Boolean;
    protected
     procedure   Initial (aItemData: TItemData; aOwnerId, ax, ay: integer);
     procedure   StartProcess; override;
     procedure   EndProcess; override;
     function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
    public
     constructor Create;
     destructor  Destroy; override;
     procedure   Update (CurTick: integer); override;

     property    AllowPickUp : Boolean read boAllowPickup;
   end;

   TItemList = class
   private
      Manager : TBattleRoom;

      DataList : TList;
      // function  AllocFunction: pointer;
      // procedure FreeFunction (item: pointer);
      function  GetCount: integer;
   public
      constructor Create (cnt: integer; aManager : TBattleRoom);
      destructor  Destroy; override;

      procedure   AllClear;
      procedure   AddItemObject (aItemData: TItemData; aOwnerId, ax, ay: integer);
      procedure   Update (CurTick: integer);
      property    Count : integer read GetCount;
   end;

   TMirrorObject = class (TBasicObject)
   private
      SelfData : TCreateMirrorData;

      ViewerList : TList;

      boActive : Boolean;
      SendClass : TSendClass;
      function GetViewerCount : Integer;
   protected
      procedure   Initial;
      procedure   StartProcess; override;
      procedure   EndProcess; override;
      function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
      function    FieldProc2 (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   AddViewer (aConnector : Pointer);
      function    DelViewer (aConnector : Pointer) : Boolean;

      procedure   Update (CurTick : Integer); override;

      function    GetSelfData : PTCreateMirrorData;
      property    ViewerCount : Integer read GetViewerCount;
   end;

   TMirrorList = class
   private
      DataList : TList;

      function  GetCount: integer;
   public
      constructor Create;
      destructor  Destroy; override;

      function    AddViewer (aStr : String; aConnector : Pointer) : Boolean;
      function    DelViewer (aConnector : Pointer) : Boolean;

      procedure   Clear;
      procedure   LoadFromFile (aFileName : String);

      procedure   Update (CurTick: integer);

      procedure   ShowViewerList (aConnector : TConnector);

      property    Count : integer read GetCount;
   end;

   TSpecialAreaObject = class (TBasicObject)
   private
      SelfData : TCreateSpecialAreaData;

      boRefill : Boolean;
      boPK : Boolean;
   protected
      procedure Initial;
      procedure StartProcess; override;
      procedure EndProcess; override;
      function  FieldProc (hfu : Longint; Msg: Word; var SenderInfo : TBasicData; var aSubData : TSubData) : Integer; override;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Update (CurTick : Integer); override;

      function GetSelfData : PTCreateSpecialAreaData;
   end;

   TSpecialAreaList = class
   private
      DataList : TList;

      function GetCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure LoadFromFile (aFileName : String);

      procedure Update (CurTick : Integer);

      property Count : Integer read GetCount;
   end;


   {
   TGateObject = class (TBasicObject)
   private
      SelfData : TCreateGateData;

      boActive : Boolean;
      RegenedTick : Integer;
      RemainHour, RemainMin, RemainSec : Word;
   protected
      procedure   Initial;
      procedure   StartProcess; override;
      procedure   EndProcess; override;
      function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   Update (CurTick : Integer); override;

      function    GetSelfData : PTCreateGateData;
   end;

   TGateList = class
   private
      DataList : TList;

      function  GetCount: integer;
   public
      constructor Create;
      destructor  Destroy; override;

      procedure   Clear;
      procedure   LoadFromFile (aFileName : String);

      procedure   Update (CurTick: integer);

      property    Count : integer read GetCount;
   end;
   }
{
   TStaticItem = class (TBasicObject)
    private
      CurDurability : integer;
      SelfItemData : TItemData;
      OwnerId : Integer;
    protected
      procedure   Initial (aItemData: TItemData; aOwnerId, ax, ay: integer);
      procedure   StartProcess; override;
      procedure   EndProcess; override;
      function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
    public
      constructor Create;
      destructor  Destroy; override;
      procedure   Update (CurTick: integer); override;
   end;

   {
   TStaticItemList = class
   private
      Manager : TRoom;
      DataList : TList;
      // function  AllocFunction: pointer;
      // procedure FreeFunction (item: pointer);
      function  GetCount: integer;
   public
      constructor Create (cnt: integer; aManager: TRoom);
      destructor  Destroy; override;

      procedure   Clear;

      function    AddStaticItemObject (aItemData: TItemData; aOwnerId, ax, ay: integer): integer;
      procedure   Update (CurTick: integer);
      property    Count : integer read GetCount;
   end;
   }
{
   TDynamicObject = class (TBasicObject)
    private
     SelfData : TCreateDynamicObjectData;
     OpenedTick : Integer;
     ObjectStatus : byte;
     CurHitCount : Integer;

     MemberList : TList;
    protected
     procedure   Initial (pObjectData: PTCreateDynamicObjectData);
     procedure   StartProcess; override;
     procedure   EndProcess; override;
     function    FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
    public
     constructor Create;
     destructor  Destroy; override;
     procedure   Update (CurTick: integer); override;
     procedure   MemberDie (aBasicObject : TBasicObject);
   end;

   TDynamicObjectList = class
   private
      Manager : TManager;

      DataList : TList;
      // function  AllocFunction: pointer;
      // procedure FreeFunction (item: pointer);
      function  GetCount: integer;
   public
      constructor Create (cnt: integer; aManager: TManager);
      destructor  Destroy; override;

      procedure Clear;
      procedure   ReLoadFromFile;
      function    AddDynamicObject (pObjectData: PTCreateDynamicObjectData): integer;
      procedure   Update (CurTick: integer);
      property    Count : integer read GetCount;
   end;
}
   procedure SignToItem (var aItemData : TItemData;aServerID : Integer; var aBasicData : TBasicData; aIP : String);

var
   boShowHitedValue : Boolean = FALSE;

   // GateList : TGateList = nil;
   MirrorList : TMirrorList = nil;
   SpecialAreaList : TSpecialAreaList = nil;

implementation

uses
   SvMain, uUser, uLevelExp, UserSDB;

///////////////////////////////
//        TBasicObject
///////////////////////////////

constructor TBasicObject.Create;
begin
   FillChar (BasicData, sizeof(BasicData), 0);
   BasicData.P := Self;
   ViewObjectList := TList.Create;
   // ViewObjectNameList := TStringList.Create;
end;

destructor TBasicObject.Destroy;
begin
   ViewObjectList.Free;
   // ViewObjectNameList.Free;
   inherited Destroy;
end;

function TBasicObject.FindViewObject (aBasicObject : TBasicObject) : Boolean;
var
   i : Integer;
   BasicObject : TBasicObject;
begin
   Result := false;
   for i := 0 to ViewObjectList.Count - 1 do begin
      BasicObject := ViewObjectList.Items [i];
      if BasicObject = aBasicObject then begin
         Result := true;
         exit;
      end;
   end;
end;

function Check5Hit (adir, ax, ay, myx, myy: integer): integer;
var
   tempdir : byte;
   xx, yy: word;
begin
   Result := 0;

   tempdir := adir;
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 100; exit; end;   //99

   tempdir := adir;
   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;    //90

   tempdir := adir;
   tempdir := GetLeftDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;    //90


   tempdir := adir;
   tempdir := GetRightDirection (tempdir);
   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;     //80

   tempdir := adir;
   tempdir := GetLeftDirection (tempdir);
   tempdir := GetLeftDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;     //80
end;

function Check8Hit (adir, ax, ay, myx, myy: integer): integer;
var
   tempdir : byte;
   xx, yy: word;
begin
   Result := 0;

   tempdir := adir;
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 100; exit; end;      //100

   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;       //70

   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;       //70

   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;       //85

   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;       //85

   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;       //85

   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;       //85

   tempdir := GetRightDirection (tempdir);
   xx := ax; yy := ay;
   GetNextPosition (tempdir, xx, yy);
   if (myx = xx) and (myy = yy) then begin Result := 99; exit; end;       //85
end;

function  TBasicObject.isHitedArea (adir, ax, ay: integer; afunc: byte; var apercent: integer) : Boolean;
var
   xx, yy: word;
begin
   apercent := 0;
   Result := FALSE;
   case afunc of
      MAGICFUNC_NONE   :
         begin
            xx := ax; yy := ay;
            GetNextPosition (adir, xx, yy);
            if (BasicData.x = xx) and (BasicData.y = yy) then begin
               apercent := 100;
               Result := TRUE;
            end;
         end;
      MAGICFUNC_8HIT   :
         begin
            if GetLargeLength (ax, ay, BasicData.x, BasicData.y) > 1 then exit;
            apercent := Check8Hit (adir, ax, ay, BasicData.x, BasicData.y);
            if apercent = 0 then exit;
            Result := TRUE;
         end;
      MAGICFUNC_5HIT   :
         begin
            if GetLargeLength (ax, ay, BasicData.x, BasicData.y) > 1 then exit;
            apercent := Check5Hit (adir, ax, ay, BasicData.x, BasicData.y);
            if apercent = 0 then exit;
            Result := TRUE;
         end;
   end;
end;

procedure TBasicObject.SetManagerClass (aManager : TBattleRoom);
begin
   Manager := aManager;
   ServerID := Manager.ServerID;
   Maper := TMaper(Manager.Maper);
   Phone := TFieldPhone (Manager.Phone);
end;

function  TBasicObject.GetPosx: integer;
begin
   Result := BasicData.x;
end;

function  TBasicObject.GetPosy: integer;
begin
   Result := BasicData.y;
end;

function  TBasicObject.GetFeatureState: TFeatureState;
begin
   Result := BasicData.Feature.rfeaturestate;
end;

procedure TBasicObject.Initial (aName, aViewName: String);
begin
   FillChar (BasicData, sizeof(BasicData), 0);
   BasicData.P := Self;
   StrPCopy (@BasicData.Name, aName);
   StrPCopy (@BasicData.ViewName, aViewName);

   FboAllowDelete := FALSE;
   FboRegisted := FALSE;

   FCreateX := 0; FCreateY := 0;
end;

procedure TBasicObject.StartProcessByDir (aDir : Integer);
begin
   FboRegisted := TRUE;
   FboAllowDelete := FALSE;

   BasicData.dir := aDir;
   BasicData.Feature.rfeaturestate := wfs_normal;

   FCreateX := BasicData.x;
   FCreateY := BasicData.y;
   FCreateTick := mmAnsTick;

   ViewObjectList.Clear;
end;

procedure TBasicObject.StartProcess;
begin
   FboRegisted := TRUE;
   FboAllowDelete := FALSE;

   BasicData.dir := DR_4;
   BasicData.Feature.rfeaturestate := wfs_normal;

   FCreateX := BasicData.x;
   FCreateY := BasicData.y;
   FCreateTick := mmAnsTick;

   ViewObjectList.Clear;
end;

procedure TBasicObject.EndProcess;
begin
   ViewObjectList.Clear;

   FboRegisted := FALSE;
end;

function TBasicObject.GetViewObjectById (aid: integer): TBasicObject;
var i : integer;
begin
   Result := nil;
   for i := 0 to ViewObjectList.Count -1 do begin
      if TBasicObject (ViewobjectList[i]).BasicData.id = aid then begin
         Result := ViewObjectList[i];
         exit;
      end;
   end;
end;

// function    TBasicObject.GetViewObjectByName (aName: string; aRace: integer): TBasicObject;
// 2000.09.18 같은 이름의 객체가 있을때 발생되는 버그수정을 위해 인자추가
// 찾으려는 객체의 이름과 종류로 검색한다 by Lee.S.G
function    TBasicObject.GetViewObjectByName (aName: string; aRace: integer): TBasicObject;
var
   i : integer;
   BObject: TBasicObject;
begin
   Result := nil;
   for i := 0 to ViewObjectList.Count -1 do begin
      BObject := ViewObjectList[i];
      if (BObject.BasicData.Feature.rRace = aRace) and (StrPas (@BObject.BasicData.Name) = aName) then begin
//      if StrPas (@BObject.BasicData.Name) = aName then begin
         Result := BObject;
         exit;
      end;
   end;
end;

procedure   TBasicObject.BocSay (astr: string);
var SubData : TSubData;
begin
   SetWordString (SubData.SayString, StrPas (@BasicData.Name) + ': '+ astr);
   SendLocalMessage (NOTARGETPHONE, FM_SAY, BasicData, SubData);
end;

procedure   TBasicObject.BocChangeFeature;
var SubData : TSubData;
begin
   SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
end;

procedure   TBasicObject.BocChangeProperty;
var SubData : TSubData;
begin
   SendLocalMessage (NOTARGETPHONE, FM_CHANGEPROPERTY, BasicData, SubData);
end;

procedure   TBasicObject.BoSysopMessage (astr: string; aSysopScope: integer);
var SubData : TSubData;
begin
   if not boShowHitedValue then exit;

   SetWordString (SubData.SayString, StrPas (@BasicData.Name) + ': '+ astr);
   SubData.SysopScope := aSysopScope;
   SendLocalMessage (NOTARGETPHONE, FM_SYSOPMESSAGE, BasicData, SubData);
end;

function    TBasicObject.SendLocalMessage (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i : integer;
   Bo : TBasicObject;
begin
   Result := PROC_FALSE;

   if hfu = 0 then begin
      Result := FieldProc (hfu, Msg, SenderInfo, aSubData);
      {
      for i := 0 to ViewObjectList.Count -1 do begin
         Bo := ViewObjectList[i];
         if Bo <> Self then begin
            Bo.FieldProc (hfu, Msg, SenderInfo, aSubData)
         end;
      end;
      }
      i := 0;
      while i < ViewObjectList.Count do begin
         Bo := ViewObjectList[i];
         try
            if Bo <> Self then begin
               Bo.FieldProc (hfu, Msg, SenderInfo, aSubData)
            end;
            Inc (i);
         except
            {
            frmMain.WriteLogInfo (format ('TBasicObject.SendLocalMessage (%s) failed', [ViewObjectNameList[i]]));
            ViewObjectNameList.Delete (i);
            }
            ViewObjectList.Delete (i);
            frmMain.WriteLogInfo (format ('TBasicObject.SendLocalMessage (%s) failed', [StrPas (@BasicData.Name)]));
         end;
      end;

   end else begin
      for i := 0 to ViewObjectList.Count -1 do begin
         Bo := ViewObjectList[i];
         try
            if Bo.BasicData.id = hfu then begin
               result := Bo.FieldProc (hfu, Msg, SenderInfo, aSubData);
               exit;
            end;
         except
            {
            frmMain.WriteLogInfo (format ('TBasicObject.SendLocalMessage (%s) failed', [ViewObjectNameList[i]]));
            ViewObjectNameList.Delete (i);
            }
            ViewObjectList.Delete (i);
            frmMain.WriteLogInfo (format ('TBasicObject.SendLocalMessage (%s) failed', [StrPas (@BasicData.Name)]));
            exit;
         end;
      end;
   end;
end;

function  TBasicObject.isRange ( xx, yy: word) : Boolean;
var x1,x2,y1,y2:integer;
begin
   Result := TRUE;
   x1 := BasicData.x; y1 := BasicData.y;
   x2 := xx; y2 := yy;
   if (x2 < x1-VIEWRANGEWIDTH) then begin Result := FALSE; exit; end;
   if (x2 > x1+VIEWRANGEWIDTH) then begin Result := FALSE; exit; end;
   if (y2 < y1-VIEWRANGEHEIGHT) then begin Result := FALSE; exit; end;
   if (y2 > y1+VIEWRANGEHEIGHT) then begin Result := FALSE; exit; end;
end;

function  TBasicObject.isRangeMessage (hfu: Longint; Msg: word; var SenderInfo: TBasicData): Boolean;
begin
   Result := FALSE;
   if (hfu = BasicData.id) then begin Result := TRUE; exit; end;
   if hfu = NOTARGETPHONE then begin
      if isRange ( SenderInfo.x, SenderInfo.y) then begin Result := TRUE; exit; end;
      if (msg = FM_MOVE) and isRange (SenderInfo.nx, SenderInfo.ny) then begin Result := TRUE; exit; end;
   end;
   if Msg = FM_SHOUT then Result := TRUE;
end;

function  TBasicObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i : integer;
   SubData : TSubData;
   bo1, bo2 : boolean;
begin
   Result := PROC_FALSE;

   case Msg of
      FM_GIVEMEADDR : if hfu = BasicData.id then Result := Integer (Self);

      FM_CLICK : if hfu = BasicData.id then SetWordString (aSubData.SayString, StrPas (@BasicData.Name));
      FM_SHOW :
         begin
            if SenderInfo.id = Basicdata.id then begin
               ViewObjectList.Clear;
               // ViewObjectNameList.Clear;
            end;

            if FindViewObject (SenderInfo.P) = true then begin
               frmMain.WriteLogInfo ('ViewObjectList Duplicate');
               exit;
            end;

            if SenderInfo.Feature.rrace = RACE_HUMAN then begin
               ViewObjectList.Insert (0, SenderInfo.p);
               // ViewObjectNameList.Insert (0, StrPas (@SenderInfo.Name));
            end else begin
               ViewObjectList.Add (SenderInfo.p);
               // ViewObjectNameList.Add (StrPas (@SenderInfo.Name));
            end;
         end;
      FM_HIDE :
         begin
            for i := 0 to ViewObjectList.Count - 1 do begin
               if ViewObjectList[i] = SenderInfo.P then begin
                  ViewObjectList.Delete (i);
                  // ViewObjectNameList.Delete (i);
                  break;
               end;
            end;
         end;
      FM_CREATE :
         begin
            Phone.SendMessage ( BasicData.Id, FM_SHOW, SenderInfo, aSubData);
            if SenderInfo.Id = BasicData.id then begin
               BasicData := SenderInfo;
               if (BasicData.Feature.rRace = RACE_HUMAN) and (BasicData.Feature.rfeaturestate = wfs_die) then exit;
               Maper.MapProc (BasicData.Id, MM_SHOW, BasicData.x, BasicData.y, BasicData.x, BasicData.y);
            end else begin
               Result := PROC_TRUE;
               Phone.SendMessage ( SenderInfo.Id, FM_SHOW, BasicData, SubData);
            end;
         end;
      FM_DESTROY :
         begin
            if SenderInfo.Id = BasicData.id then
               Maper.MapProc (BasicData.Id, MM_HIDE, BasicData.x, BasicData.y, BasicData.x, BasicData.y);
            Phone.SendMessage ( BasicData.Id, FM_HIDE, SenderInfo, aSubData);
         end;
      FM_MOVE:
         begin
            bo1 := isRange (SenderInfo.x, SenderInfo.y);
            bo2 := isRange (SenderInfo.nx, SenderInfo.ny);
            if (bo1 = TRUE) and (bo2 = FALSE) then begin
               Phone.SendMessage (SenderInfo.Id, FM_HIDE, BasicData, SubData);
               Phone.SendMessage (BasicData.id, FM_HIDE, SenderInfo, aSubData);
               exit;
            end;
            if (bo1 = FALSE) and (bo2 = TRUE) then begin
               Phone.SendMessage (SenderInfo.Id, FM_SHOW, BasicData, SubData);
               Phone.SendMessage (BasicData.ID, FM_SHOW, SenderInfo, aSubData);
               exit;
            end;
         end;
   end;
end;

procedure TBasicObject.Update(CurTick: integer);
begin
end;


////////////////////////////////////////////////////
//
//             ===  ItemObject  ===
//
////////////////////////////////////////////////////

constructor TItemObject.Create;
begin
   inherited Create;
   boAllowPickup := true;
end;

destructor  TItemObject.Destroy;
begin
   inherited destroy;
end;

function  TItemObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   SubData : TSubData;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   case Msg of
      FM_ADDITEM:
         begin
            if aSubData.ItemData.rCount <> 1 then exit;
            if SelfItemData.rKind = ITEM_KIND_COLORDRUG then exit;
            
            if aSubData.ItemData.rKind = ITEM_KIND_COLORDRUG then begin
               if SelfItemData.rboColoring = FALSE then begin Result := PROC_FALSE; exit; end;
               if INI_WHITEDRUG <> StrPas (@aSubData.ItemData.rName) then begin
                  SelfItemData.rColor := aSubData.ItemData.rColor;
                  BasicData.Feature.rImageColorIndex := aSubData.ItemData.rColor;
                  Phone.SendMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
               end else begin
                  SelfItemdata.rColor := SelfItemdata.rColor + aSubData.ItemData.rColor;
                  BasicData.Feature.rImageColorIndex := SelfItemdata.rColor;
                  Phone.SendMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
               end;
               Result := PROC_TRUE;
            end;
         end;
      FM_PICKUP :
         begin
            if FboAllowDelete then exit;
            {
            if boAllowPickup = false then begin
               if (SenderInfo.x <> BasicData.x) or (SenderInfo.y <> BasicData.y) then begin
                  exit;
               end;
            end;
            }

            SubData.ItemData := SelfItemData;
            SubData.ServerId := ServerId;
            if Phone.SendMessage (SenderInfo.id, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then FboAllowDelete := TRUE;
         end;
      FM_SAY :
         begin
         end;
   end;
end;

procedure TItemObject.Initial (aItemData: TItemData; aOwnerId, ax, ay: integer);
var
   iName, iViewName : string;
begin
   iName := StrPas (@aItemData.rName);
   if aItemData.rCount > 1 then iName := iName + ':' + IntToStr (aItemData.rCount);
   iViewName := StrPas (@aItemData.rViewName);
   if aItemData.rCount > 1 then iViewName := iViewName + ':' + IntToStr (aItemData.rCount);

   inherited Initial (iName, iViewName);
   
   OwnerId := aOwnerId;
   SelfItemdata := aItemData;
   BasicData.id := GetNewItemId;
   BasicData.x := ax;
   BasicData.y := ay;
   BasicData.ClassKind := CLASS_ITEM;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := aItemData.rShape;
   BasicData.Feature.rImageColorIndex := aItemData.rcolor;

   {
   boAllowPickup := true;
   if not Maper.isMoveable (ax, ay) then begin
      boAllowPickup := false;
   end;
   }
end;

procedure TItemObject.StartProcess;
var SubData : TSubData;
begin
   inherited StartProcess;
   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);

   if SelfItemData.rSoundDrop.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (SelfItemData.rSoundDrop.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;
end;

procedure TItemObject.EndProcess;
var SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;

   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
   inherited EndProcess;
end;

procedure   TItemObject.Update (CurTick: integer);
begin
   if CreateTick + 3*60*100 < CurTick then FboAllowDelete := TRUE;
   {
   if boAllowPickup = false then begin
      if CreateTick + 5*100 < CurTick then begin
         boAllowPickup := true;
      end;
   end;
   }
end;


////////////////////////////////////////////////////
//
//             ===  ItemList  ===
//
////////////////////////////////////////////////////

constructor TItemList.Create (cnt: integer; aManager: TBattleRoom);
begin
   Manager := aManager;
   DataList := TList.Create;
end;

destructor TItemList.Destroy;
begin
   AllClear;
   DataList.Free;
   inherited destroy;
end;

procedure TItemList.AllClear;
var
   i : Integer;
   ItemObject : TItemObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      ItemObject := DataList.Items [i];
      ItemObject.EndProcess;
      ItemObject.Free;
   end;
   DataList.Clear;
end;

function  TItemList.GetCount: integer;
begin
   Result := DataList.Count;
end;

{
function TItemList.AllocFunction: pointer;
begin
   Result := TItemObject.Create;
end;

procedure TItemList.FreeFunction (item: pointer);
begin
   TItemObject (item).Free;
end;
}

procedure TItemList.AddItemObject (aItemData: TItemData; aOwnerId, ax, ay: integer);
var
   ItemObject : TItemObject;
begin
   if DataList.Count > 3000 then exit;

   ItemObject := TItemObject.Create;
   
   ItemObject.SetManagerClass (Manager);
   ItemObject.Initial (aItemData, aOwnerId, ax, ay);
   ItemObject.StartProcess;

   DataList.Add (ItemObject);
end;

procedure TItemList.Update (CurTick: integer);
var
   i : integer;
   ItemObject : TItemObject;
begin
   for i := DataList.Count - 1 downto 0 do begin
      ItemObject := DataList.Items [i];
      if ItemObject.boAllowDelete then begin
         ItemObject.EndProcess;
         ItemObject.Free;
         DataList.delete (i);
      end;
   end;
   
   for i := 0 to DataList.Count - 1 do begin
      ItemObject := DataList.Items [i];
      ItemObject.Update (CurTick);
   end;
end;

////////////////////////////////////////////////////
//
//             ===  MirrorObject  ===
//
////////////////////////////////////////////////////

constructor TMirrorObject.Create;
begin
   inherited Create;

   ViewerList := TList.Create;
   SendClass := TSendClass.Create;

   FillChar (SelfData, SizeOf (TCreateMirrorData), 0);
   boActive := false;
end;

destructor TMirrorObject.Destroy;
begin
   SendClass.Free;
   ViewerList.Free;

   inherited Destroy;
end;

procedure TMirrorObject.Initial;
begin
   inherited Initial (SelfData.Name, SelfData.Name);

   BasicData.id := GetNewItemId;
   BasicData.x := SelfData.X;
   BasicData.y := SelfData.Y;
   BasicData.ClassKind := CLASS_SERVEROBJ;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := 0;
   BasicData.Feature.rImageColorIndex := 0;

   boActive := SelfData.boActive;
end;

procedure TMirrorObject.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TMirrorObject.EndProcess;
var
   SubData : TSubData;
begin
   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TMirrorObject.AddViewer (aConnector : Pointer);
var
   i : Integer;
begin
   if ViewerList.IndexOf (aConnector) >= 0 then exit;
   ViewerList.Add (aConnector);

   TConnector (aConnector).SendMap (BasicData, Manager.MapName, Manager.ObjName, Manager.RofName, Manager.TilName, Manager.SoundBase);
   for i := 0 to ViewObjectList.Count - 1 do begin
      TConnector (aConnector).SendShow (TBasicObject (ViewObjectList[i]).BasicData);
   end;
end;

function TMirrorObject.DelViewer (aConnector : Pointer) : Boolean;
var
   iNo : Integer;
begin
   Result := false;

   iNo := ViewerList.IndexOf (aConnector);
   if iNo < 0 then exit;

   TConnector (aConnector).WhereStatus := ws_group;
   TConnector (aConnector).SendBattleGroupList (0);

   ViewerList.Delete (iNo);
   Result := true;
end;

function TMirrorObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i : Integer;
   tmpConnector : TConnector;
begin
   Result := PROC_FALSE;

   if isRangeMessage (hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);

   for i := 0 to ViewerList.Count - 1 do begin
      tmpConnector := ViewerList.Items [i];
      SendClass.SetConnector (tmpConnector);
      FieldProc2 (hfu, Msg, SenderInfo, aSubData);
      SendClass.SetConnector (nil);
   end;
end;

function TMirrorObject.FieldProc2 (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   SaveActionState : TActionState;
begin
   Result := PROC_FALSE;

   SaveActionState := SenderInfo.Feature.rActionState;

   case Msg of
      FM_SOUND :
         begin
            SendClass.SendSoundEffect (GetWordString (aSubData.SayString), SenderInfo.x, SenderInfo.y );
         end;
      FM_SAYUSEMAGIC : SendClass.SendSayUseMagic (SenderInfo, GetWordString (aSubData.SayString) );
      FM_SAY   : SendClass.SendSay (SenderInfo, GetWordString (aSubData.SayString) );
      FM_SHOUT : SendClass.SendChatMessage (GetWordString(aSubData.SayString), SAY_COLOR_SHOUT);
      FM_SHOW  :
         begin
            if BasicData.ID = SenderInfo.ID then
               SenderInfo.Feature.rActionState := as_ice;
            SendClass.SendShow (SenderInfo);
            if BasicData.ID = SenderInfo.ID then
               SenderInfo.Feature.rActionState := SaveActionState;
         end;
      FM_HIDE  : SendClass.SendHide (SenderInfo);
      FM_STRUCTED      :
         begin
            SendClass.SendMotion (SenderInfo.id, AM_STRUCTED);
            if Manager.OwnerUser = nil then begin
               SendClass.SendStructed (SenderInfo.id, aSubData.percent, RACE_HUMAN);
            end else begin
               SendClass.SendStructed (SenderInfo.id, aSubData.percent, RACE_ITEM);
               Manager.SetBattleBar (SenderInfo, aSubData.percent);

               if (Manager.Stage mod 2) = 1 then begin
                  SendClass.SendBattleBar (Manager.Owner, Manager.Fighter,
                     Manager.OwnerWin, Manager.FighterWin, Manager.OwnerPercent,
                     Manager.FighterPercent, Manager.BattleType);
               end else begin
                  SendClass.SendBattleBar (Manager.Fighter, Manager.Owner,
                     Manager.FighterWin, Manager.OwnerWin, Manager.FighterPercent,
                     Manager.OwnerPercent, Manager.BattleType);
               end;
            end;
         end;
      FM_CHANGEFEATURE :
         begin
            if BasicData.ID = SenderInfo.ID then
               SenderInfo.Feature.rActionState := as_ice;
            SendClass.SendChangeFeature (SenderInfo);
            if BasicData.ID = SenderInfo.ID then
               SenderInfo.Feature.rActionState := SaveActionState;
         end;
      FM_CHANGEPROPERTY : SendClass.SendChangeProperty (SenderInfo);
      FM_MOTION :
         begin
            SendClass.SendMotion (SenderInfo.id, aSubData.motion);
            if Manager.OwnerUser <> nil then begin
               Manager.SetUserMotion (SenderInfo, aSubData.motion);
            end;
         end;
      FM_TURN   :
         begin
            SendClass.SendTurn (SenderInfo);
         end;
      FM_MOVE   :
         begin
            SendClass.SendMove (SenderInfo);
         end;
      FM_BOW :
         begin
            SendClass.SendShootMagic (SenderInfo, aSubData.TargetId, aSubData.tx, aSubData.ty, aSubData.BowImage, aSubData.BowSpeed);
         end;
   end;
end;

procedure TMirrorObject.Update (CurTick : Integer);
begin

end;

function TMirrorObject.GetSelfData : PTCreateMirrorData;
begin
   Result := @SelfData;
end;

function TMirrorObject.GetViewerCount : Integer;
begin
   Result := ViewerList.Count;
end;


////////////////////////////////////////////////////
//
//             ===  MirrorList  ===
//
////////////////////////////////////////////////////

constructor TMirrorList.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\Setting\CreateMirror.SDB');
end;

destructor TMirrorList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TMirrorList.Clear;
var
   i : Integer;
   MirrorObj : TMirrorObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      MirrorObj := DataList.Items [i];
      MirrorObj.EndProcess;
      MirrorObj.Free;
   end;
   DataList.Clear;
end;

function TMirrorList.AddViewer (aStr : String; aConnector : Pointer) : Boolean;
var
   i : Integer;
   MirrorObj : TMirrorObject;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      MirrorObj := DataList.Items [i];
      if UpperCase (StrPas (@MirrorObj.BasicData.Name)) = UpperCase (aStr) then begin
         MirrorObj.AddViewer (aConnector);
         Result := true;
         exit;
      end;
   end;
end;

function TMirrorList.DelViewer (aConnector : Pointer) : Boolean;
var
   i : Integer;
   MirrorObj : TMirrorObject;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      MirrorObj := DataList.Items [i];
      if MirrorObj.DelViewer (aConnector) = true then begin
         Result := true;
         exit;
      end;      
   end;   
end;

procedure TMirrorList.LoadFromFile (aFileName : String);
var
   DB : TUserStringDB;
   i : Integer;
   iName : String;
   MirrorObj : TMirrorObject;
   pd : PTCreateMirrorData;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      MirrorObj := TMirrorObject.Create;
      pd := MirrorObj.GetSelfData;

      pd^.Name :=DB.GetFieldValueString (iName, 'Name');
      pd^.X := DB.GetFieldValueInteger (iName, 'X');
      pd^.Y := DB.GetFieldValueInteger (iName, 'Y');
      pd^.MapID := DB.GetFieldValueInteger (iName, 'MapID');
      pd^.boActive := DB.GetFieldValueBoolean (iName, 'boActive');

      if ShareRoom <> nil then begin
         MirrorObj.SetManagerClass (ShareRoom);
         MirrorObj.Initial;
         MirrorObj.StartProcess;
         DataList.Add (MirrorObj);
      end else begin
         MirrorObj.Free;
      end;
   end;

   DB.Free;
end;

procedure TMirrorList.Update (CurTick: integer);
var
   i : Integer;
   MirrorObj : TMirrorObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      MirrorObj := DataList.Items [i];
      MirrorObj.Update (CurTick);
   end;
end;

procedure TMirrorList.ShowViewerList (aConnector : TConnector);
var
   i : Integer;
   MirrorObj : TMirrorObject;
   Str : String;
begin
   for i := 0 to DataList.Count - 1 do begin
      MirrorObj := DataList.Items [i];
      Str := Str + ' ' + '공유방구경 ' + MirrorObj.SelfData.Name + ' : ' + InttoStr (MirrorObj.ViewerCount);
   end;

   aConnector.SendChatMessage (Str, SAY_COLOR_SYSTEM);
end;

function TMirrorList.GetCount: integer;
begin
   Result := DataList.Count;
end;

////////////////////////////////////////////////////
//
//             ===  SpecialAreaObject  ===
//
////////////////////////////////////////////////////

constructor TSpecialAreaObject.Create;
begin
   inherited Create;

   FillChar (SelfData, SizeOf (TCreateSpecialAreaData), 0);

   boRefill := false;
   boPK := false;
end;

destructor TSpecialAreaObject.Destroy;
begin

   inherited Destroy;
end;

procedure TSpecialAreaObject.Initial;
begin
   inherited Initial (SelfData.Name, SelfData.ViewName);

   BasicData.id := GetNewItemId;
   BasicData.x := SelfData.X;
   BasicData.y := SelfData.Y;
   BasicData.ClassKind := CLASS_SERVEROBJ;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := 0;
   BasicData.Feature.rImageColorIndex := 0;

   boRefill := SelfData.boRefill;
   boPK := SelfData.boPK;
end;

procedure TSpecialAreaObject.StartProcess;
var
   SubData : TSubData; 
begin
   inherited StartProcess;

   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TSpecialAreaObject.EndProcess;
var
   SubData : TSubData;
begin
   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

function TSpecialAreaObject.FieldProc (hfu : Longint; Msg: Word; var SenderInfo : TBasicData; var aSubData : TSubData) : Integer;
var
   BO : TBasicObject;
   tmpUser : TUser;
begin
   Result := PROC_FALSE;
   if isRangeMessage (hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   case Msg of
      FM_MOVE :
         begin
            BO := TBasicObject (SenderInfo.P);
            if BO = nil then exit;
            if not (BO is TUser) then exit;
            tmpUser := TUser (BO);

            if StrPas (@SenderInfo.ServerName) = SelfData.Name then begin
               if CheckInArea (SenderInfo.nx, SenderInfo.ny, BasicData.x, Basicdata.y, SelfData.Width) then begin
                  if boRefill = true then begin
                     tmpUser.SendRefillMessage (tmpUser.BasicData.id, tmpUser.BasicData);
                  end;
                  if boPK = true then begin
                     tmpUser.CanAttack := false;
                     tmpUser.CanHit := false;
                  end;
               end else begin
                  tmpUser.CanAttack := true;
                  tmpUser.CanHit := true;
               end;
            end;
         end;
   end;
end;

procedure TSpecialAreaObject.Update (CurTick : Integer);
begin

end;

function TSpecialAreaObject.GetSelfData : PTCreateSpecialAreaData;
begin
   Result := @SelfData;
end;

////////////////////////////////////////////////////
//
//             ===  SpecialAreaList  ===
//
////////////////////////////////////////////////////

constructor TSpecialAreaList.Create;
begin
   DataList := TList.Create;
   LoadFromFile ('.\Setting\CreateSpecialArea.SDB');   
end;

destructor TSpecialAreaList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TSpecialAreaList.Clear;
var
   i : Integer;
   SO : TSpecialAreaObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      SO := DataList.Items [i];
      SO.EndProcess;
      SO.Free;
   end;
   DataList.Clear;
end;

procedure TSpecialAreaList.LoadFromFile (aFileName : String);
var
   DB : TUserStringDB;
   i : Integer;
   iName : String;
   SO : TSpecialAreaObject;
   pSD : PTCreateSpecialAreaData;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then exit;

      SO := TSpecialAreaObject.Create;
      pSD := SO.GetSelfData;

      pSD^.Name := DB.GetFieldValueString (iName, 'AreaName');
      pSD^.ViewName := DB.GetFieldValueString (iName, 'ViewName');
      pSD^.X := DB.GetFieldValueInteger (iName, 'X');
      pSD^.Y := DB.GetFieldValueInteger (iName, 'Y');
      pSD^.Width := DB.GetFieldValueInteger (iName, 'Width');
      pSD^.MapID := DB.GetFieldValueInteger (iName, 'MapID');
      pSD^.boRefill := DB.GetFieldValueBoolean (iName, 'boRefill');
      pSD^.boPK := DB.GetFieldValueBoolean (iName, 'boPK');

      if ShareRoom <> nil then begin
         SO.SetManagerClass (ShareRoom);
         SO.Initial;
         SO.StartProcess;
         DataList.Add (SO);      
      end else begin
         SO.Free;
      end;
   end;

   DB.Free;
end;

procedure TSpecialAreaList.Update (CurTick : Integer);
var
   i : Integer;
   SpecialObject : TSpecialAreaObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      SpecialObject := DataList.Items [i];
      SpecialObject.Update (CurTick);
   end;
end;

function TSpecialAreaList.GetCount : Integer;
begin
   Result := DataList.Count;
end;


////////////////////////////////////////////////////
//
//             ===  GateObject  ===
//
////////////////////////////////////////////////////

{
constructor TGateObject.Create;
begin
   inherited Create;

   boActive := false;
   RegenedTick := mmAnsTick;

   FillChar (SelfData, SizeOf (TCreateGateData), 0);
end;

destructor TGateObject.Destroy;
begin
   inherited destroy;
end;

function TGateObject.GetSelfData : PTCreateGateData;
begin
   Result := @SelfData;
end;

function TGateObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i : Integer;
   SubData : TSubData;
   ItemData : TItemData;
   pUser : TUser;
   boFlag : Boolean;
   BO : TBasicObject;
   RetStr : String;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   case Msg of
      FM_MOVE :
         begin
            if (BasicData.nx = 0) and (BasicData.ny = 0) then exit;

            if CheckInArea (SenderInfo.nx, SenderInfo.ny, BasicData.x, BasicData.y, SelfData.Width) then begin
               BO := TBasicObject (SenderInfo.P);
               if BO = nil then exit;
               if not (BO is TUser) then exit;
               pUser := TUser (BO);

               if pUser.MovingStatus = true then begin
                  exit;
               end;

               if boActive = false then begin
                  pUser.SetPosition (SelfData.EjectX, SelfData.EjectY);
                  pUser.SendClass.SendChatMessage (format ('지금은 들어갈 수 없습니다. %d분%d초후에 열립니다', [RemainHour * 60 + RemainMin, RemainSec]), SAY_COLOR_SYSTEM);
                  exit;
               end;

               boFlag := true;
               if SelfData.NeedAge > 0 then begin
                  if SelfData.NeedAge <= pUser.GetAge then begin
                  end else begin
                     if SelfData.AgeNeedItem > 0 then begin
                        if SelfData.AgeNeedItem <= pUser.GetAge then begin
                           for i := 0 to 5 - 1 do begin
                              if SelfData.NeedItem[i].rName = '' then break;
                              ItemClass.GetItemData (SelfData.NeedItem[i].rName, ItemData);
                              if ItemData.rName[0] <> 0 then begin
                                 ItemData.rCount := SelfData.NeedItem[i].rCount;
                                 boFlag := TUser (BO).FindItem (@ItemData);
                                 if boFlag = false then break;
                              end;
                           end;
                           if boFlag = true then begin
                              for i := 0 to 5 - 1 do begin
                                 if SelfData.NeedItem[i].rName = '' then break;
                                 ItemClass.GetItemData (SelfData.NeedItem[i].rName, ItemData);
                                 if ItemData.rName[0] <> 0 then begin
                                    ItemData.rCount := SelfData.NeedItem[i].rCount;
                                    TUser (BO).DeleteItem (@ItemData);
                                 end;
                              end;
                           end;
                        end else begin
                           boFlag := false;
                        end;
                     end else begin
                        boFlag := false;
                     end;
                  end;
               end;
               
               if boFlag = true then begin
                  if SelfData.Quest <> 0 then begin
                     if QuestClass.CheckQuestComplete (SelfData.Quest, ServerID, RetStr) = false then begin
                        pUser.SetPosition (SelfData.EjectX, SelfData.EjectY);
                        pUser.SendClass.SendChatMessage (SelfData.QuestNotice, SAY_COLOR_SYSTEM);
                        pUser.SendClass.SendChatMessage (RetStr, SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;
               
               if boFlag = true then begin
                  SubData.ServerId := SelfData.TargetServerId;
                  Phone.SendMessage (SenderInfo.id, FM_GATE, BasicData, SubData);
               end else begin
                  if (SelfData.EjectX > 0) and (SelfData.EjectY > 0) then begin
                     pUser.SetPosition (SelfData.EjectX, SelfData.EjectY);
                  end;
                  if SelfData.EjectNotice = '' then begin
                     pUser.SendClass.SendChatMessage ('들어갈 수 없습니다. 출입이 제한된 곳입니다', SAY_COLOR_SYSTEM);
                  end else begin
                     pUser.SendClass.SendChatMessage (SelfData.EjectNotice, SAY_COLOR_SYSTEM);
                  end;
               end;
            end;
         end;
   end;
end;

procedure TGateObject.Initial;
begin
   inherited Initial (SelfData.Name);

   BasicData.id := GetNewItemId;
   BasicData.x := SelfData.x;
   BasicData.y := SelfData.y;
   BasicData.nx := SelfData.targetx;
   BasicData.ny := SelfData.targety;
   BasicData.ClassKind := CLASS_GATE;
   BasicData.Feature.rrace := RACE_ITEM;
   BasicData.Feature.rImageNumber := SelfData.Shape;
   BasicData.Feature.rImageColorIndex := 0;

   boActive := true;
   RegenedTick := mmAnsTick;
end;

procedure TGateObject.StartProcess;
var
   SubData : TSubData;
begin
   inherited StartProcess;

   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);
end;

procedure TGateObject.EndProcess;
var
   SubData : TSubData;
begin
   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);

   inherited EndProcess;
end;

procedure TGateObject.Update (CurTick : Integer);
begin
   if (SelfData.RegenInterval > 0) and (RegenedTick + 100 <= CurTick) then begin
      Manager.CalcTime (RegenedTick + SelfData.RegenInterval - CurTick, RemainHour, RemainMin, RemainSec);
   end;
   if (SelfData.RegenInterval > 0) and (RegenedTick + SelfData.RegenInterval <= CurTick) then begin
      RegenedTick := CurTick;
      boActive := true;
   end else begin
      if boActive = true then begin
         if (SelfData.RegenInterval > 0) and (RegenedTick + SelfData.ActiveInterval <= CurTick) then begin
            boActive := false;
         end;
      end;
   end;
end;

////////////////////////////////////////////////////
//
//             ===  GateList  ===
//
////////////////////////////////////////////////////

constructor TGateList.Create;
begin
   DataList := TList.Create;

   LoadFromFile ('.\Setting\CreateGate.SDB');
end;

destructor TGateList.Destroy;
begin
   Clear;
   DataList.Free;
   
   inherited Destroy;
end;

procedure TGateList.Clear;
var
   i : Integer;
   GateObject : TGateObject;
begin
   for i := 0 to DataList.Count - 1 do begin
      GateObject := DataList.Items [i];
      if GateObject.boRegisted then begin
         GateObject.EndProcess;
      end;
      GateObject.Free;
   end;
   DataList.Clear;
end;

function TGateList.GetCount: integer;
begin
   Result := DataList.Count;
end;

procedure TGateList.LoadFromFile (aFileName : String);
var
   i, j : integer;
   iName, srcstr, tokenstr : String;
   ItemData : TItemData;
   GateObject : TGateObject;
   pd : PTCreateGateData;
   DB : TUserStringDB;
   Manager : TManager;
begin
   if not FileExists (aFileName) then exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);

      GateObject := TGateObject.Create;
      pd := GateObject.GetSelfData;

      pd^.Name := DB.GetFieldValueString (iName, 'GateName');
      pd^.MapID := DB.GetFieldValueInteger (iname, 'MapID');
      pd^.x := DB.GetFieldValueInteger (iName, 'X');
      pd^.y := DB.GetFieldValueInteger (iName, 'Y');
      pd^.targetx := DB.GetFieldValueInteger (iName, 'TX');
      pd^.targety := DB.GetFieldValueInteger (iName, 'TY');
      pd^.ejectx := DB.GetFieldValueInteger (iName, 'EX');
      pd^.ejecty := DB.GetFieldValueInteger (iName, 'EY');
      pd^.targetserverid := DB.GetFieldValueInteger (iName, 'ServerId');
      pd^.shape := DB.GetFieldValueInteger (iName, 'Shape');
      pd^.Width := DB.GetFieldValueInteger (iName, 'Width');

      pd^.NeedAge := DB.GetFieldValueInteger (iName, 'NeedAge');
      pd^.AgeNeedItem := DB.GetFieldValueInteger (iName, 'AgeNeedItem');

      srcstr := DB.GetFieldValueString (iName, 'NeedItem');
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
      pd^.Quest := DB.GetFieldValueInteger (iname, 'Quest');
      pd^.QuestNotice := DB.GetFieldValueString (iname, 'QuestNotice');
      pd^.RegenInterval := DB.GetFieldValueInteger (iName, 'RegenInterval');
      pd^.ActiveInterval := DB.GetFieldValueInteger (iName, 'ActiveInterval');
      pd^.EjectNotice := DB.GetFieldValueString (iname, 'EjectNotice');

      Manager := ManagerList.GetManagerByServerID (pd^.MapID);
      if Manager <> nil then begin
         GateObject.SetManagerClass (Manager);
         GateObject.Initial;
         GateObject.StartProcess;
         DataList.Add (GateObject);
      end else begin
         GateObject.Free;
      end;
   end;
   DB.Free;
end;

procedure TGateList.Update (CurTick: integer);
var
   i: integer;
   GateObject : TGateObject;
begin
   for i := DataList.Count - 1 downto 0 do begin
      GateObject := DataList.Items [i];
      if GateObject.boAllowDelete then begin
         GateObject.EndProcess;
         GateObject.Free;
         DataList.Delete (i);
      end;
   end;
   
   for i := 0 to DataList.Count - 1 do begin
      GateObject := DataList.Items [i];
      GateObject.Update (CurTick);
   end;
end;
}

{
////////////////////////////////////////////////////
//
//             ===  StaticItemObject  ===
//
////////////////////////////////////////////////////

constructor TStaticItem.Create;
begin
   inherited Create;
end;

destructor  TStaticItem.Destroy;
begin
   inherited destroy;
end;

function  TStaticItem.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   percent : integer;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   case Msg of
      FM_HIT :
         begin
            if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
               Dec (CurDurability, 5*100);
            end;
         end;
   end;
end;

procedure TStaticItem.Initial (aItemData: TItemData; aOwnerId, ax, ay: integer);
var
   str : string;
begin
   str := StrPas (@aItemData.rName);
   if aItemData.rCount > 1 then str := str + ':' + IntToStr (aItemData.rCount);
   inherited Initial (str, str);
   CurDurability := 10 * 60 * 100;   // 10분동안 없어지지 안음.

   OwnerId := aOwnerId;
   SelfItemdata := aItemData;
   BasicData.id := GetNewStaticItemId;
   BasicData.x := ax;
   BasicData.y := ay;
   BasicData.ClassKind := CLASS_STATICITEM;
   BasicData.Feature.rrace := RACE_STATICITEM;
   BasicData.Feature.rImageNumber := aItemData.rShape;
   BasicData.Feature.rImageColorIndex := aItemData.rcolor;
end;

procedure TStaticItem.StartProcess;
var SubData : TSubData;
begin
   inherited StartProcess;
   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);

   if SelfItemData.rSoundDrop.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (SelfItemData.rSoundDrop.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;
end;

procedure TStaticItem.EndProcess;
var SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;

   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
   inherited EndProcess;
end;

procedure   TStaticItem.Update (CurTick: integer);
begin
   if CreateTick + CurDurability < CurTick then FboAllowDelete := TRUE;
end;


////////////////////////////////////////////////////
//
//             ===  StaticItemList  ===
//
////////////////////////////////////////////////////

{
constructor TStaticItemList.Create (cnt: integer; aManager: TManager);
begin
   Manager := aManager;
   DataList := TList.Create;
end;

destructor TStaticItemList.Destroy;
begin
   Clear;
   DataList.Free;
   inherited destroy;
end;

procedure TStaticItemList.Clear;
var
   i : Integer;
   ItemObject : TStaticItem;
begin
   for i := 0 to DataList.Count - 1 do begin
      ItemObject := DataList.Items [i];
      ItemObject.EndProcess;
      ItemObject.Free;
   end;
   DataList.Clear;
end;

function  TStaticItemList.GetCount: integer;
begin
   Result := DataList.Count;
end;

function  TStaticItemList.AddStaticItemObject (aItemData: TItemData; aOwnerId, ax, ay: integer): integer;
var
   ItemObject : TStaticItem;
begin
   Result := PROC_FALSE;
   if DataList.count > 3000 then exit;

   if aItemData.rCount <> 1 then exit;
   if not TMaper(Manager.Maper).isMoveable (ax, ay) then exit;

   ItemObject := TStaticItem.Create;
   ItemObject.SetManagerClass (Manager);
   ItemObject.Initial (aItemData, aOwnerId, ax, ay);
   ItemObject.StartProcess;
   
   DataList.Add (ItemObject);
   Result := PROC_TRUE;
end;

procedure TStaticItemList.Update (CurTick: integer);
var
   i : integer;
   StaticItem : TStaticItem;
begin
   for i := DataList.Count - 1 downto 0 do begin
      StaticItem := DataList.Items [i];
      if StaticItem.boAllowDelete then begin
         StaticItem.EndProcess;
         StaticItem.Free;
         DataList.Delete (i);
      end;
   end;

   for i := 0 to DataList.Count - 1 do begin
      StaticItem := DataList.Items [i];
      StaticItem.UpDate (CurTick);
   end;
end;
}

(*

////////////////////////////////////////////////////
//
//             ===  DynamicItemObject  ===
//
////////////////////////////////////////////////////

constructor TDynamicObject.Create;
begin
   inherited Create;
   ObjectStatus := 0;
   MemberList := nil;
end;

destructor  TDynamicObject.Destroy;
var
   i : Integer;
   AttackSkill : TAttackSkill;
   BO : TBasicObject;
begin
   if MemberList <> nil then begin
      for i := MemberList.Count - 1 downto 0 do begin
         BO := MemberList[i];
         if BO <> nil then begin
            AttackSkill := nil;
            if BO.BasicData.Feature.rRace = RACE_MONSTER then begin
               AttackSkill := TMonster (BO).GetAttackSkill;
            end else if BO.BasicData.Feature.rRace = RACE_NPC then begin
               AttackSkill := TNpc (BO).GetAttackSkill;
            end;
            if AttackSkill <> nil then begin
               AttackSkill.SetObjectBoss (nil);
            end;
         end;
      end;
      MemberList.Clear;
      MemberList.Free;
   end;
   inherited destroy;
end;

procedure TDynamicObject.MemberDie (aBasicObject : TBasicObject);
var
   i, j : Integer;
begin
   if MemberList = nil then exit;
   for i := 0 to MemberList.Count - 1 do begin
      if aBasicObject = MemberList[i] then begin
         if aBasicObject.BasicData.Feature.rfeaturestate <> wfs_die then begin
            CurHitCount := SelfData.rLife;
         end else begin
            for j := 0 to 5 - 1 do begin
               if StrPas (@aBasicObject.BasicData.Name) = SelfData.rDropMop [j].rName then begin
                  SelfData.rDropMop[j].rName := '';
                  break;
               end;
               if StrPas (@aBasicObject.BasicData.Name) = SelfData.rCallNpc [j].rName then begin
                  SelfData.rCallNpc[j].rName := '';
                  break;
               end;
            end;
         end;
         MemberList.Delete (i);
         break;
      end;
   end;
end;

function  TDynamicObject.FieldProc (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i, j, xx, yy : Integer;
   percent : Integer;
   SubData : TSubData;
   ItemData : TItemData;
   CurTick, SkillLevel : Integer;
   BO, BO2 : TBasicObject;
   Monster : TMonster;
   Npc : TNpc;
   boFlag : boolean;
   AttackSkill : TAttackSkill;
begin
   Result := PROC_FALSE;
   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
   Result := inherited FieldProc (hfu, Msg, Senderinfo, aSubData);
   if Result = PROC_TRUE then exit;

   CurTick := mmAnsTick;
   case Msg of
      FM_SAY :
         begin
         end;
      FM_HIT :
         begin
            if BasicData.Feature.rhitmotion <> byte (dos_Closed) then exit;

            BO := GetViewObjectByID (SenderInfo.id);
            if BO = nil then exit;
            if not (BO is TUser) then exit;

            if isHitedArea (SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then begin
               if SelfData.rLife = CurHitCount then begin
                  for i := 0 to 5 - 1 do begin
                     if SelfData.rDropMop[i].rName = '' then continue;
                     for j := 0 to SelfData.rDropMop[i].rCount - 1 do begin
                        xx := BasicData.x;
                        yy := BasicData.y;
                        Maper.GetNearXy (xx, yy);
                        if Maper.isMoveable (xx, yy) then begin
                           Monster := TMonsterList (Manager.MonsterList).CallMonster (SelfData.rDropMop[i].rName, xx, yy, 4, StrPas (@SenderInfo.Name));
                           if Monster <> nil then begin
                              AttackSkill := Monster.GetAttackSkill;
                              if AttackSkill <> nil then begin
                                 AttackSkill.SetObjectBoss (Self);
                              end;
                              if MemberList = nil then begin
                                 MemberList := TList.Create;
                              end;
                              MemberList.Add (Monster);
                           end;
                        end;
                     end;
                  end;
                  for i := 0 to 5 - 1 do begin
                     if SelfData.rCallNpc[i].rName = '' then continue;
                     for j := 0 to SelfData.rCallNpc[i].rCount - 1 do begin
                        xx := BasicData.x;
                        yy := BasicData.y;
                        Maper.GetNearXy (xx, yy);
                        if Maper.isMoveable (xx, yy) then begin
                           Npc := TNpcList (Manager.NpcList).CallNpc (SelfData.rCallNpc[i].rName, xx, yy, 4, StrPas(@SenderInfo.Name));
                           if Npc <> nil then begin
                              AttackSkill := Npc.GetAttackSkill;
                              if AttackSkill <> nil then begin
                                 AttackSkill.SetObjectBoss (Self);
                              end;
                              if MemberList = nil then begin
                                 MemberList := TList.Create;
                              end;
                              MemberList.Add (Npc);
                           end;
                        end;
                     end;
                  end;
               end else begin
                  if MemberList <> nil then begin
                     for i := 0 to MemberList.Count - 1 do begin
                        BO2 := MemberList[i];
                        if BO2 <> nil then begin
                           if BO2.BasicData.Feature.rRace = RACE_NPC then begin
                              AttackSkill := TNpc (BO2).GetAttackSkill;
                           end else begin
                              AttackSkill := TMonster (BO2).GetAttackSkill;
                           end;
                           AttackSkill.SetDeadAttackName (StrPas (@SenderInfo.Name));
                        end;
                     end;
                  end;
               end;

               if SelfData.rBasicData.rSoundEvent.rWavNumber > 0 then begin
                  SetWordString (SubData.SayString, IntToStr (SelfData.rBasicData.rSoundEvent.rWavNumber) + '.wav');
                  SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
               end;

               CurHitCount := CurHitCount - 1;
               if CurHitCount > 0 then exit;

               if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then begin
                  SetWordString (SubData.SayString, IntToStr (SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
                  SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
               end;

               if SelfData.rNeedAge <> 0 then begin
                  if TUser (BO).GetAge < SelfData.rNeedAge then begin
                     TUser (BO).SendClass.SendChatMessage (format ('%d세 이상만 열 수 있습니다', [SelfData.rNeedAge]), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;
               for i := 0 to 5 - 1 do begin
                  if SelfData.rNeedSkill[i].rName = '' then break;
                  SkillLevel := TUser (BO).FindHaveMagicByName (SelfData.rNeedSkill[i].rName);
                  if SelfData.rNeedSkill[i].rLevel > SkillLevel then begin
                     TUser (BO).SendClass.SendChatMessage (format ('%s의 수련치가 %s 이상인 사람만 열 수 있습니다', [SelfData.rNeedSkill[i].rName, Get10000To100(SelfData.rNeedSkill[i].rLevel)]), SAY_COLOR_SYSTEM);
                     exit;
                  end;
               end;

               for i := 0 to 5 - 1 do begin
                  if SelfData.rNeedItem[i].rName = '' then break;
                  ItemClass.GetItemData (SelfData.rNeedItem[i].rName, ItemData);
                  if ItemData.rName[0] <> 0 then begin
                     ItemData.rCount := SelfData.rNeedItem[i].rCount;
                     boFlag := TUser (BO).FindItem (@ItemData);
                     if boFlag = false then begin
                        TUser (BO).SendClass.SendChatMessage (format ('%s 아이템 %d개가 필요합니다', [StrPas (@ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
                        exit;
                     end;
                  end;
               end;

               for i := 0 to 5 - 1 do begin
                  if SelfData.rNeedItem[i].rName = '' then break;
                  ItemClass.GetItemData (SelfData.rNeedItem[i].rName, ItemData);
                  if ItemData.rName[0] <> 0 then begin
                     ItemData.rCount := SelfData.rNeedItem[i].rCount;
                     TUser (BO).DeleteItem (@ItemData);
                  end;
               end;

               BasicData.Feature.rhitmotion := byte (dos_Openning);
               SendLocalMessage (NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
               BasicData.Feature.rhitmotion := byte (dos_Openned);

               OpenedTick := CurTick;

               BasicData.nx := SenderInfo.x;
               BasicData.ny := SenderInfo.y;
               for i := 0 to 5 - 1 do begin
                  if SelfData.rGiveItem[i].rName = '' then break;
                  ItemClass.GetChanceItemData (StrPas (@BasicData.Name), SelfData.rGiveItem[i].rName, ItemData);
                  ItemData.rCount := SelfData.rGiveItem[i].rCount;
                  ItemData.rOwnerName[0] := 0;

                  SubData.ItemData := ItemData;
                  SubData.ServerId := ServerId;
                  if TFieldPhone (Manager.Phone).SendMessage (SenderInfo.id, FM_ENOUGHSPACE, BasicData, SubData) = PROC_FALSE then begin
                     Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                  end else begin
                     TFieldPhone(Manager.Phone).SendMessage (SenderInfo.id, FM_ADDITEM, BasicData, SubData);
                  end;
               end;
            end;
         end;
   end;
end;

procedure TDynamicObject.Initial (pObjectData: PTCreateDynamicObjectData);
begin
   inherited Initial (pObjectData^.rBasicData.rName);

   Move (pObjectData^, SelfData, sizeof (TCreateDynamicObjectData));
   BasicData.id := GetNewDynamicObjectId;
   BasicData.x := pObjectData^.rx[0];
   BasicData.y := pObjectData^.ry[0];
   BasicData.ClassKind := CLASS_DYNOBJECT;
   BasicData.Feature.rrace := RACE_DYNAMICOBJECT;
   BasicData.Feature.rImageNumber := pObjectData^.rBasicData.rShape;
   Case pObjectData^.rBasicData.rKind of
      0 :
         begin
            BasicData.Feature.rHitMotion := byte(dos_Closed);
         end;
      1 :
         begin
            BasicData.Feature.rHitMotion := byte(dos_Scroll);
         end;
   end;

   CurHitCount := pObjectData^.rLife;
end;

procedure TDynamicObject.StartProcess;
var
   SubData : TSubData;
   i, x, y, c, cmax : Integer;
begin
   cmax := 0;
   for i := 0 to 5 - 1 do begin
      if (SelfData.rX[i] = 0) and (SelfData.rY[i] = 0) then begin
         break;
      end;
      inc (cmax);
   end;

   c := Random(cmax);
   x := SelfData.rX[c];
   y := SelfData.rY[c];
   if not TMaper(Manager.Maper).isMoveable (x, y) then exit;

   BasicData.X := x;
   BasicData.Y := y;

   inherited StartProcess;
   Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
   Phone.SendMessage (0, FM_CREATE, BasicData, SubData);

   ObjectStatus := 1;
   
   if SelfData.rBasicData.rSoundSpecial.rWavNumber <> 0 then begin
      SetWordString (SubData.SayString, IntToStr (SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
      SendLocalMessage (NOTARGETPHONE, FM_SOUND, BasicData, SubData);
   end;
end;

procedure TDynamicObject.EndProcess;
var
   SubData : TSubData;
begin
   if FboRegisted = FALSE then exit;

   ObjectStatus := 2;
   
   Phone.SendMessage (0, FM_DESTROY, BasicData, SubData);
   Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
   
   inherited EndProcess;
end;

procedure TDynamicObject.Update (CurTick: integer);
var
   i : Integer;
   ItemData : TItemData;
   SubData : TSubData;
begin
   if ObjectStatus = 1 then begin
      if BasicData.Feature.rHitMotion = byte (dos_Openned) then begin
         if OpenedTick + 200 <= CurTick then begin
            for i := 0 to 5 - 1 do begin
               if SelfData.rDropItem[i].rName = '' then break;
               if ItemClass.GetCheckItemData (StrPas (@BasicData.Name), SelfData.rDropItem[i], ItemData) = true then begin
                  ItemData.rOwnerName[0] := 0;
                  SubData.ItemData := ItemData;
                  SubData.ServerId := ServerId;
                  Phone.SendMessage (MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
               end;
            end;
            EndProcess;
         end;
      end;
   end else if ObjectStatus = 2 then begin
      if Manager.RegenInterval = 0 then begin
         if OpenedTick + 300 + SelfData.rRegenInterval <= CurTick then begin
            StartProcess;
         end;
      end;
   end;
end;


////////////////////////////////////////////////////
//
//             ===  DynamicObjectList  ===
//
////////////////////////////////////////////////////

constructor TDynamicObjectList.Create (cnt: integer; aManager: TManager);
begin
   Manager := aManager;
   DataList := TList.Create;

   ReLoadFromFile;
end;

destructor TDynamicObjectList.Destroy;
begin
   Clear;
   DataList.Free;
   inherited destroy;
end;

procedure TDynamicObjectList.Clear;
var
   i : Integer;
   DynamicObject : TDynamicObject;
begin
   for i := DataList.Count - 1 downto 0 do begin
      DynamicObject := DataList.Items [i];
      DynamicObject.EndProcess;
      DynamicObject.Free;
      DataList.Delete (i);
   end;
   DataList.Clear;
end;

procedure TDynamicObjectList.ReLoadFromFile;
var
   i, j : integer;
   iRandomCount : Integer;
   FileName, iName, ObjectName : String;
   mStr, sStr : String;
   DB : TUserStringDb;
   DynamicObject : TDynamicObject;
   CreateDynamicObjectData : TCreateDynamicObjectData;
   DynamicObjectData : TDynamicObjectData;
   MonsterData : TMonsterData;
   NpcData : TNpcData;
   MagicData : TMagicData;
   ItemData : TItemData;
begin
   Clear;

   FileName := '.\Setting\CreateDynamicObject' + IntToStr (Manager.ServerID) + '.SDB';

   if not FileExists (FileName) then exit;

   DB := TUserStringDb.Create;
   DB.LoadFromFile (FileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;
      
      ObjectName := DB.GetFieldValueString (iName, 'Name');
      FillChar (DynamicObjectData, SizeOf (DynamicObjectData), 0);
      DynamicObjectClass.GetDynamicObjectData (ObjectName, DynamicObjectData);
      if DynamicObjectData.rName = '' then continue;
      
      Move (DynamicObjectData, CreateDynamicObjectData.rBasicData, SizeOf (TDynamicObjectData));
      CreateDynamicObjectData.rState := DB.GetFieldValueInteger (iname, 'State');
      CreateDynamicObjectData.rRegenInterval := DB.GetFieldValueInteger (iname, 'RegenInterval');
      CreateDynamicObjectData.rLife := DB.GetFieldValueInteger (iname, 'Life');
      CreateDynamicObjectData.rNeedAge := DB.GetFieldValueInteger (iname, 'NeedAge');

      mStr := DB.GetFieldValueString (iName, 'NeedSkill');
      for j := 0 to 5 - 1 do begin
         if mStr = '' then break;
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr <> '' then begin
            MagicClass.GetMagicData (sStr, MagicData, 0);
            if MagicData.rName[0] <> 0 then begin
               CreateDynamicObjectData.rNeedSkill[j].rName := StrPas (@MagicData.rName);
               mStr := GetValidStr3 (mStr, sStr, ':');
               CreateDynamicObjectData.rNeedSkill[j].rLevel := _StrToInt (sStr);
            end;
         end;
      end;
      mStr := DB.GetFieldValueString (iname, 'NeedItem');
      for j := 0 to 5 - 1 do begin
         if mStr = '' then break;
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr <> '' then begin
            ItemClass.GetItemData (sStr, ItemData);
            if ItemData.rname[0] <> 0 then begin
               CreateDynamicObjectData.rNeedItem[j].rName := StrPas (@ItemData.rName);
               mStr := GetValidStr3 (mStr, sStr, ':');
               CreateDynamicObjectData.rNeedItem[j].rCount := _StrToInt (sStr);
            end;
         end;
      end;
      mStr := DB.GetFieldValueString (iname, 'GiveItem');
      for j := 0 to 5 - 1 do begin
         if mStr = '' then break;
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr <> '' then begin
            ItemClass.GetItemData (sStr, ItemData);
            if ItemData.rName[0] <> 0 then begin
               CreateDynamicObjectData.rGiveItem[j].rName := StrPas (@ItemData.rName);
               mStr := GetValidStr3 (mStr, sStr, ':');
               CreateDynamicObjectData.rGiveItem[j].rCount := _StrToInt (sStr);
               mStr := GetValidStr3 (mStr, sStr, ':');
               iRandomCount := _StrToInt (sStr);
               if iRandomCount <= 0 then iRandomCount := 1;

               RandomClass.AddData (CreateDynamicObjectData.rGiveItem[j].rName, ObjectName, iRandomCount);
            end;
         end;
      end;
      mStr := DB.GetFieldValueString (iname, 'DropItem');
      for j := 0 to 5 - 1 do begin
         if mStr = '' then break;
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr <> '' then begin
            ItemClass.GetItemData (sStr, ItemData);
            if ItemData.rname[0] <> 0 then begin
               CreateDynamicObjectData.rDropItem[j].rName := StrPas (@ItemData.rName);
               mStr := GetValidStr3 (mStr, sStr, ':');
               CreateDynamicObjectData.rDropItem[j].rCount := _StrToInt (sStr);
               mStr := GetValidStr3 (mStr, sStr, ':');
               iRandomCount := _StrToInt (sStr);
               if iRandomCount <= 0 then iRandomCount := 1;

               RandomClass.AddData (CreateDynamicObjectData.rDropItem[j].rName, ObjectName, iRandomCount);
            end;
         end;
      end;

      mStr := DB.GetFieldValueString (iname, 'DropMop');
      for j := 0 to 5 - 1 do begin
         if mStr = '' then break;
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr <> '' then begin
            MonsterClass.GetMonsterData (sStr, @MonsterData);
            if MonsterData.rName[0] <> 0 then begin
               CreateDynamicObjectData.rDropMop[j].rName := StrPas (@MonsterData.rName);
               mStr := GetValidStr3 (mStr, sStr, ':');
               CreateDynamicObjectData.rDropMop[j].rCount := _StrToInt (sStr);
            end;
         end;
      end;

      mStr := DB.GetFieldValueString (iname, 'CallNpc');
      for j := 0 to 5 - 1 do begin
         if mStr = '' then break;
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr <> '' then begin
            NpcClass.GetNpcData (sStr, @NpcData);
            if NpcData.rName[0] <> 0 then begin
               CreateDynamicObjectData.rCallNpc[j].rName := StrPas (@NpcData.rName);
               mStr := GetValidStr3 (mStr, sStr, ':');
               CreateDynamicObjectData.rCallNpc[j].rCount := _StrToInt (sStr);
            end;
         end;
      end;

      mStr := DB.GetFieldValueString (iname, 'X');
      for j := 0 to 5 - 1 do begin
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr = '' then break;
         CreateDynamicObjectData.rX[j] := _StrToInt (sStr);
      end;
      mStr := DB.GetFieldValueString (iname, 'Y');
      for j := 0 to 5 - 1 do begin
         mStr := GetValidStr3 (mStr, sStr, ':');
         if sStr = '' then break;
         CreateDynamicObjectData.rY[j] := _StrToInt (sStr);
      end;

      DynamicObject := TDynamicObject.Create;
      DynamicObject.SetManagerClass (Manager);
      DynamicObject.Initial (@CreateDynamicObjectData);
      DynamicObject.StartProcess;
      
      DataList.Add (DynamicObject);
   end;
   
   DB.Free;
end;

function  TDynamicObjectList.GetCount: integer;
begin
   Result := DataList.Count;
end;

{
function TDynamicObjectList.AllocFunction: pointer;
begin
   Result := TDynamicObject.Create;
end;

procedure TDynamicObjectList.FreeFunction (item: pointer);
begin
   TDynamicObject (item).Free;
end;
}

function  TDynamicObjectList.AddDynamicObject (pObjectData: PTCreateDynamicObjectData): integer;
var
   DynamicObject : TDynamicObject;
begin
   Result := PROC_FALSE;

   DynamicObject := TDynamicObject.Create;
   DynamicObject.SetManagerClass (Manager);
   DynamicObject.Initial (pObjectData);
   DynamicObject.StartProcess;
   DataList.Add (DynamicObject);

   Result := PROC_TRUE;
end;

procedure TDynamicObjectList.Update (CurTick: integer);
var
   i : integer;
   DynamicObject : TDynamicObject;
begin
   for i := DataList.Count - 1 downto 0 do begin
      DynamicObject := DataList.Items [i];
      if DynamicObject.boAllowDelete then begin
         DynamicObject.EndProcess;
         DataList.Delete (i);
      end;
   end;

   for i := 0 to DataList.Count - 1 do begin
      DynamicObject := DataList.Items [i];
      DynamicObject.UpDate (CurTick);
   end;
end;
*)

procedure SignToItem (var aItemData : TItemData; aServerID : Integer; var aBasicData : TBasicData; aIP : String);
begin
   if aItemData.rName[0] > 0 then begin
      aItemData.rOwnerRace := aBasicData.Feature.rrace;
      aItemData.rOwnerServerID := aServerID;
      if aBasicData.Feature.rRace <> RACE_HUMAN then begin
         StrPCopy(@aItemData.rOwnerName, '@');
         StrCopy (@aItemData.rOwnerName[1], @aBasicData.Name);
         StrPCopy (@aItemData.rOwnerIP, '');
      end else begin
         StrCopy (@aItemData.rOwnerName, @aBasicData.Name);
         StrPCopy (@aItemData.rOwnerIP, aIP);
      end;
      aItemData.rOwnerX := aBasicData.x;
      aItemData.rOwnerY := aBasicData.y;
      StrPCopy (@aItemData.rOwnerIP, aIP);
   end;
end;

end.

