unit FAttrib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, A2Img, Deftype, ExtCtrls, StdCtrls, CharCls, cltype, AtzCls, uAnsTick,
  BackScrn, Gauges, Menus, jpeg, uMagicClass, Usersdb, uKeyClass, AUtil32; //Fdyeing,


//const
    //AttribItemMaxCount = 30;

type
  TcBufferItemDataClass = class
  private
    DataList: TList;
    NameIndex: TStringKeyClass;
  public
    constructor Create;
    destructor Destroy; override;
    function get(aname: string): PTItemdata;
    procedure add(var aitem: titemdata);
    procedure clear;
  end;

  TcItemTextClass = class
  private
    DataList: TList;
    NameIndex: TStringKeyClass;
    procedure add(var aitem: TitemTextdata);
    procedure clear;
  public
    constructor Create;
    destructor Destroy; override;
    function get(aname: string): pTitemTextdata;
    function getText(aname: string): string;
    procedure addText(aname, aitemtext: string);
  end;

  TonItemclass_update = procedure(akey: integer; aitem: titemdata) of object;

  TcItemListClass = class
  private
    FonUPdate: TonItemclass_update;
    ItemArr: array of TItemData;
    procedure upitemBoIdent(akey: integer; astate: boolean);
    procedure upitemboBlueprint(akey: integer; astate: boolean);
  public
    constructor Create(amaxcount: integer);
    destructor Destroy; override;
    procedure clear;
    procedure upitemCountUP(akey, acount: integer);
    procedure upitem(akey: integer; aitem: TItemData);
    procedure upitemcolor(akey: integer; acolor: integer);
    procedure upitemChangeItem(akey: integer; akey2: integer);
    procedure upitemCountadd(akey: integer; acount: integer);
    procedure upitemLockState(akey: integer; astate: integer);
    procedure upitemCountDec(akey: integer; acount: integer);
    function get(akey: integer): TItemData;
    procedure del(akey: integer);
    function getname(str: string): PTItemdata;
    function getid(id: integer): PTItemdata;
    function getSuitIDCount(aid: integer): integer;
    property onUPdate: TonItemclass_update read FonUPdate write FonUPdate;
    function IS_Samzie(akey: integer): boolean; //测试 是否 可存仓库
    function IS_Drop(akey: integer): boolean; //测试 是否 可丢弃
    function IS_Trade(akey: integer): boolean; //测试 是否 可出售
    function IS_Exchange(akey: integer): boolean; //测试 是否 可交易
    function getitemNameList: string;
    function getnameid(str: string): integer;
    function getViewNameid(str: string): integer;
    function count: integer;
    procedure sendItemText(aname: string);
  end;

  TcWearitemClass = class
  private
  public
    Wear: TcItemListClass;
    WearFD: TcItemListClass;
    constructor Create;
    destructor Destroy; override;
  end;

  TonMagicclass_update = procedure(akey: integer; aitem: TMagicData) of object;

  TcMagicListClass = class
  private
    FonUPdate: TonMagicclass_update;
    ItemArr: array of TMagicData;
  public
    constructor Create(amaxcount: integer);
    destructor Destroy; override;
    procedure upitem(akey: integer; aitem: TMagicData);
    function get(akey: integer): TMagicData;
    procedure del(akey: integer);
    function getname(str: string): PTMagicData;
    function getMagicType(aMagicType: integer): PTMagicData;
    function getMagicTypeIndex(aMagicType: integer): integer;
    function getMoveMagicNameList: string;
    function getProtectMagicNameList: string;
    function getBREATHNGMagicNameList: string;
    function getAttackMagicNameList(aTag: integer): string;
    function getindex(id: integer): PTMagicData;
    function getID(aMagicid: integer): PTMagicData;
    procedure addexp(aitem: TMagicData);
    property onUPdate: TonMagicclass_update read FonUPdate write FonUPdate;
    function getQieHuanMagicName: string;
  end;

  TcHaveMagicClass = class
  private
  public
    HaveMagic: TcMagicListClass;
    HaveRiseMagic: TcMagicListClass;
    HaveMysteryMagic: TcMagicListClass;
    DefaultMagic: TcMagicListClass;
    constructor Create;
    destructor Destroy; override;
    procedure addexp(aitem: TMagicData);
  end;

  TcMagicClass = class(TMagicBasicClass)
  public
    constructor Create;
    destructor Destroy; override;
    procedure loadfromDamage(astr: string);
    procedure loadfromArmor(astr: string);
  end;

  TONcAttribPro = procedure(Value_max, Value: integer) of object;

  TONcAttribUPdate = procedure(Value: integer) of object;

  TcAttribClass = class
  private
  public
    CurAttribData: TCurAttribData;
    AttribData: TAttribData;
    LifeData: TLifeData;
    onHead: TONcAttribPro;
    onArm: TONcAttribPro;
    onLeg: TONcAttribPro;
    onprestige: TONcAttribUPdate;
    onprestigeadd: TONcAttribUPdate;
    constructor Create;
    destructor Destroy; override;
    procedure MessageProcess(var code: TWordComData); virtual;
    function getArm(): integer;
    function gethead(): integer;
    function getleg(): integer;
    procedure setArm(Value: integer);
    procedure setLeg(Value: integer);
    procedure setHead(Value: integer);
    property Arm: integer read getArm write setArm;
    property Head: integer read gethead write sethead;
    property Leg: integer read getleg write setleg;
  end;

  OnOtherUserUpdate = procedure of object;

  TcOtherUserAttribClass = class(TcAttribClass)
  private
    FOnOtherUserUpdate: OnOtherUserUpdate;
  public
    constructor Create;
    procedure MessageProcess(var code: TWordComData); override;
    property OtherUserUpdate: OnOtherUserUpdate read FOnOtherUserUpdate write FOnOtherUserUpdate;
  end;

  TKeyClassDataType = (kcdt_none, kcdt_key, kcdt_F5_f12);

  TKeyClassDataKey = (kcdk_none, kcdk_HaveItem, kcdk_HaveMagic, kcdk_BasicMagic, kcdk_HaveRiseMagic, kcdk_HaveMysteryMagic);

  TKeyClassData = record
    rboUser: boolean;
    rtype: TKeyClassDataType;
    rkeyType: TKeyClassDataKey;
    rkey: integer;
  end;

  pTKeyClassData = ^TKeyClassData;

  TKeyClassData_update = procedure(akey: integer; aitem: TKeyClassData) of object;

  TKeyClass = class
  private
    FdataArr: array[0..7] of TKeyClassData;
    FOnUpdate: TKeyClassData_update;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear();
    procedure del(aindex: integer);
    procedure UPdate(aindex: integer; rtype: TKeyClassDataType; rkeyType: TKeyClassDataKey; rkey: integer);
    function getKey(aindex: integer): integer;
    function get(aindex: integer): pTKeyClassData;
    procedure delType(rkeyType: TKeyClassDataKey; rkey: integer);
    procedure UpdateType(rkeyType: TKeyClassDataKey; rkey: integer);
  end;

  TFrmAttrib = class(TForm)
    A2Form: TA2Form;
    PanelAttrib: TA2Panel;
    LbLight: TA2Label;
    LbDark: TA2Label;
    LbGoodChar: TA2Label;
    LbBadChar: TA2Label;
    LbAdaptive: TA2Label;
    LbRevival: TA2Label;
    LbImmunity: TA2Label;
    Lbtalent: TA2Label;
    LbGil: TA2Label;
    Lbhung: TA2Label;
    LbBok: TA2Label;
    Lbhoa: TA2Label;
    LbChar: TA2ILabel;
    PanelBasic: TA2Panel;
    PanelMagic: TA2Panel;
    PanelItem: TA2Panel;
    PanelSkill: TA2Panel;
    A2ILabel0: TA2ILabel;
    A2ILabel1: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2ILabel4: TA2ILabel;
    A2ILabel5: TA2ILabel;
    A2ILabel6: TA2ILabel;
    A2ILabel7: TA2ILabel;
    A2ILabel8: TA2ILabel;
    A2ILabel9: TA2ILabel;
    A2ILabel10: TA2ILabel;
    A2ILabel11: TA2ILabel;
    A2ILabel12: TA2ILabel;
    A2ILabel13: TA2ILabel;
    A2ILabel14: TA2ILabel;
    A2ILabel15: TA2ILabel;
    A2ILabel16: TA2ILabel;
    A2ILabel17: TA2ILabel;
    A2ILabel18: TA2ILabel;
    A2ILabel19: TA2ILabel;
    A2ILabel20: TA2ILabel;
    A2ILabel21: TA2ILabel;
    A2ILabel22: TA2ILabel;
    A2ILabel23: TA2ILabel;
    A2ILabel24: TA2ILabel;
    A2ILabel25: TA2ILabel;
    A2ILabel26: TA2ILabel;
    A2ILabel27: TA2ILabel;
    A2ILabel28: TA2ILabel;
    A2ILabel29: TA2ILabel;
    BLabel0: TA2ILabel;
    BLabel1: TA2ILabel;
    BLabel2: TA2ILabel;
    BLabel3: TA2ILabel;
    BLabel4: TA2ILabel;
    BLabel5: TA2ILabel;
    BLabel6: TA2ILabel;
    BLabel7: TA2ILabel;
    BLabel8: TA2ILabel;
    BLabel9: TA2ILabel;
    BLabel10: TA2ILabel;
    BLabel11: TA2ILabel;
    MLabel0: TA2ILabel;
    MLabel1: TA2ILabel;
    MLabel2: TA2ILabel;
    MLabel3: TA2ILabel;
    MLabel4: TA2ILabel;
    MLabel5: TA2ILabel;
    MLabel6: TA2ILabel;
    MLabel7: TA2ILabel;
    MLabel8: TA2ILabel;
    MLabel9: TA2ILabel;
    MLabel10: TA2ILabel;
    MLabel11: TA2ILabel;
    PgHead: TGauge;
    PGArm: TGauge;
    PGLeg: TGauge;
    BLabel12: TA2ILabel;
    BLabel13: TA2ILabel;
    BLabel14: TA2ILabel;
    BLabel15: TA2ILabel;
    BLabel16: TA2ILabel;
    BLabel17: TA2ILabel;
    BLabel18: TA2ILabel;
    BLabel19: TA2ILabel;
    MLabel12: TA2ILabel;
    MLabel13: TA2ILabel;
    MLabel14: TA2ILabel;
    MLabel15: TA2ILabel;
    MLabel16: TA2ILabel;
    MLabel17: TA2ILabel;
    MLabel18: TA2ILabel;
    MLabel19: TA2ILabel;
    LbSkill0: TLabel;
    LbSkill1: TLabel;
    LbSkill2: TLabel;
    LbSkill3: TLabel;
    LbSkill4: TLabel;
    LbSkill5: TLabel;
    LbSkill6: TLabel;
    LbSkill7: TLabel;
    BLabel20: TA2ILabel;
    BLabel21: TA2ILabel;
    BLabel22: TA2ILabel;
    BLabel23: TA2ILabel;
    BLabel24: TA2ILabel;
    BLabel25: TA2ILabel;
    BLabel26: TA2ILabel;
    BLabel27: TA2ILabel;
    BLabel28: TA2ILabel;
    BLabel29: TA2ILabel;
    MLabel20: TA2ILabel;
    MLabel21: TA2ILabel;
    MLabel22: TA2ILabel;
    MLabel23: TA2ILabel;
    MLabel24: TA2ILabel;
    MLabel25: TA2ILabel;
    MLabel26: TA2ILabel;
    MLabel27: TA2ILabel;
    MLabel28: TA2ILabel;
    MLabel29: TA2ILabel;
    LbWindowName: TA2ILabel;
    LbMoney: TA2ILabel;
    LbAge: TA2ILabel;
    LbVirtue: TA2ILabel;
    LbEvent: TLabel;
    PanelHailFellow: TPanel;
    listContent: TA2ListBox;
    HailFellowUserName: TEdit;
    HailFellowbtdel: TA2Button;
    HailFellowbtadd: TA2Button;
    Image2: TImage;
    btnMagicTab: TA2Button;
    btnBasicMagicTab: TA2Button;
    btnRiseMagicTab: TA2Button;
    Label1: TLabel;
    A2Label1: TA2Label;
    A2ILabel30: TA2ILabel;
    MLabel31: TA2ILabel;
    MLabel32: TA2ILabel;
    MLabel33: TA2ILabel;
    MLabel34: TA2ILabel;
    MLabel35: TA2ILabel;
    MLabel36: TA2ILabel;
    MLabel37: TA2ILabel;
    MLabel38: TA2ILabel;
    MLabel39: TA2ILabel;
    MLabel40: TA2ILabel;
    MLabel41: TA2ILabel;
    MLabel42: TA2ILabel;
    MLabel43: TA2ILabel;
    MLabel44: TA2ILabel;
    MLabel45: TA2ILabel;
    MLabel46: TA2ILabel;
    MLabel47: TA2ILabel;
    MLabel48: TA2ILabel;
    MLabel49: TA2ILabel;
    MLabel50: TA2ILabel;
    MLabel51: TA2ILabel;
    MLabel52: TA2ILabel;
    MLabel53: TA2ILabel;
    MLabel54: TA2ILabel;
    MLabel55: TA2ILabel;
    MLabel56: TA2ILabel;
    MLabel57: TA2ILabel;
    MLabel58: TA2ILabel;
    MLabel59: TA2ILabel;
    MLabel30: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LbCharMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure LbCharStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure LbCharMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LbCharDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure LbCharDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ItemLabelDblClick(Sender: TObject);
    procedure ItemLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure A2ILabel0DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ItemLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ItemLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure MLabelDblClick(Sender: TObject);
    procedure MLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure MLabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure MLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure BLabel0DblClick(Sender: TObject);
    procedure BLabel0MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BLabel0StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure LbSkill0Click(Sender: TObject);
    procedure LbSkill0DblClick(Sender: TObject);
    procedure LbSkill0MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure LbSkill4Click(Sender: TObject);
    procedure BLabel0Click(Sender: TObject);
    procedure MLabel0Click(Sender: TObject);
    procedure A2ILabel26Click(Sender: TObject);
    procedure A2ILabel0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BLabel0MouseLeave(Sender: TObject);
    procedure BLabel0MouseEnter(Sender: TObject);
    procedure A2ILabel0MouseEnter(Sender: TObject);
    procedure A2ILabel0MouseLeave(Sender: TObject);
    procedure MLabel0MouseEnter(Sender: TObject);
    procedure MLabel0MouseLeave(Sender: TObject);
    function getkeyadd(id: integer): TA2ILabel;
    procedure BLabel0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure HailFellowbtaddClick(Sender: TObject);
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure FormPaint(Sender: TObject);
    procedure listContentKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure A2ILabel0MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnBasicMagicTabClick(Sender: TObject);
    procedure btnMagicTabClick(Sender: TObject);
  private
        { Private declarations }
    //     DragDropSelectNum : integer;
    //     SelectItem : integer;
    procedure SetFormText;
  public
    Fmoney: integer;
    FITEMA2Hint: TA2Hint;
    temprSkillLevel: integer;
        { Public declarations }
    viewImage: TA2ImageLib; //  view.atz
    energyImageLib: TA2ImageLib; //energy.atz
    WWWImageLib: TA2ImageLib;
    ILabels: array[0..30 - 1] of TA2ILabel;
    MLabels: array[0..60 - 1] of TA2ILabel;
    BLabels: array[0..30 - 1] of TA2ILabel;
    SLabels: array[0..8 - 1] of TLabel;
    CharCenterImage: TA2Image;
    procedure MessageProcess(var code: TWordComData);
    procedure DrawWearItem;
    procedure SetItemLabelBackGround(Lb: TA2ILabel; acolor: byte; BackGroundFileName: string);
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
    procedure SetMagicLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shape2: word);
    procedure KeySaveAction(id: integer);
//        procedure keysetsave(Keyindex, ItemIndex: integer);
//        procedure keyDel(Keyindex, ItemIndex: integer);
//        procedure KeyGetAll();

//        procedure keysetImg(savekey, KeyIndex: integer);
    procedure PaneClose(aname: string);
    procedure sendHailFellowAdd(aname: string);
    procedure A2hint(aitem: TItemData);
    procedure A2hintTMagicData(aitem: TMagicData);
    procedure magicState(abool: boolean);
    procedure onHaveitemUPdate(akey: integer; aitem: titemdata);
    procedure onWearitemUPdate(akey: integer; aitem: titemdata);
    procedure onWearFDitemUPdate(akey: integer; aitem: titemdata);
    procedure onUserWearitemUPdate(akey: integer; aitem: titemdata);
    procedure onUserWearFDitemUPdate(akey: integer; aitem: titemdata);
    procedure onHaveMagicUp(akey: integer; aitem: TMagicData);
    procedure onHaveMysteryMagicUp(akey: integer; aitem: TMagicData);
    procedure onHaveRiseMagicUp(akey: integer; aitem: TMagicData);
    procedure onDefaultMagicUp(akey: integer; aitem: TMagicData);
    procedure onMoney(acount: integer);
    procedure onBindMoney(acount: integer);
    procedure ONLeg(value_max, value: integer);
    procedure ONArm(value_max, value: integer);
    procedure ONHead(value_max, value: integer);
    procedure onprestige(value: integer);
    procedure sendDblClickItemString(akey: integer; astr: string);
    procedure sendDblClickItemStringEx(akey: integer; astr: string; aSayItem: TCSayItem);
    procedure onKeyItemUPdate(akey: integer; adata: TKeyClassData);
    procedure onKeyF5_F12UPdate(akey: integer; adata: TKeyClassData);
    procedure onHaveitemQuestUPdate(akey: integer; aitem: titemdata);
  end;

var
  FrmAttrib: TFrmAttrib;
  HaveItemQuestClass: TcItemListClass;
  HaveItemclass: TcItemListClass;
  WearitemClass: TcWearitemClass;
  WearUseritemClass: TcWearitemClass;
  HaveMagicClass: TcHaveMagicClass;
  cF5_F12Class: TKeyClass;
  cKeyClass: TKeyClass;
  cMagicClass: TcMagicClass;
  cAttribClass: TcAttribClass;
  cOtherUserAttribClass: TcOtherUserAttribClass;
  cItemTextClass: TcItemTextClass;
  G_BufferItemDataClass: TcBufferItemDataClass;
//    BasicBufferkey: array[0..7] of byte;                                        //f5-F12

var
  FrmAttribFormPaint: boolean;
  savekeyBool: Boolean;
  savekeytextout: Boolean;
    //    savekey         :word;
  savekeyImagelib: TA2ImageLib;
  savekeyImage: TA2Image;
  keyselmagicindex: integer = -1;
  keyselmagicindexadd: integer = -1;

function TItemDataToStr(aitem: TItemData): string;

function getviewImage(idx: integer): TA2Image;

function GETenergyImage(idx: integer): TA2Image;

function getWWWImageLib(idx: integer): TA2Image;

function formatStr(str: string; awidth: integer): string;

implementation

uses
  FMain, FBottom, Fbl, FDepository, FQuantity, FNPCTrade, FCharAttrib, FItemHelp,
  FConfirmDialog, FShowPopMsg, FWearItem, FWearItemUser, filepgkclass, FnewMagic,
  uPersonBat;

{$R *.DFM}

var
  Last_X: integer;
  P: TPoint;

var
  SelWearItemIndex: integer = 0;
  SelectedMagicLabel: TA2ILabel = nil;
    //SelectedItemLabel:TA2ILabel = nil;

function getWWWImageLib(idx: integer): TA2Image;
begin
  Result := nil;
  if (idx < 0) or (idx >= FrmAttrib.WWWImageLib.Count) then
    exit;
  Result := FrmAttrib.WWWImageLib[idx];
end;

function getviewImage(idx: integer): TA2Image;
begin
  Result := nil;
  if (idx < 0) or (idx >= FrmAttrib.viewImage.Count) then
    exit;
  Result := FrmAttrib.viewImage[idx];
end;

function GETenergyImage(idx: integer): TA2Image;
begin
  Result := nil;
  if (idx < 0) or (idx >= FrmAttrib.energyImageLib.Count) then
    exit;
  Result := FrmAttrib.energyImageLib[idx];
end;
///////////////////////////////////////////////////
//                  物品 背包 管理类
///////////////////////////////////////////////////

function TcItemListClass.getid(id: integer): PTItemdata;
begin
  result := nil;
  if (id >= 0) and (id <= high(ItemArr)) then
    result := @ItemArr[id];

end;

function TcItemListClass.IS_Trade(akey: integer): boolean;
begin
  result := false;
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    if ItemArr[akey].rboNotTrade = false then
      result := true;
  end;
end;

function TcItemListClass.getitemNameList: string;
var
  i: integer;
begin
  result := '';
  for i := 0 to high(ItemArr) do
  begin
    if ItemArr[i].rKind = 13 then
    begin
      result := result + ItemArr[i].rViewName + #13#10;

    end;
  end;

end;

function TcItemListClass.IS_Exchange(akey: integer): boolean;
begin
  result := false;
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    if ItemArr[akey].rboNotExchange = false then
      result := true;
  end;
end;

function TcItemListClass.IS_Drop(akey: integer): boolean;
begin
  result := false;
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    if ItemArr[akey].rboNotDrop = false then
      result := true;
  end;
end;

function TcItemListClass.IS_Samzie(akey: integer): boolean;
begin
  result := false;
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    if ItemArr[akey].rboNotSSamzie = false then
      result := true;
  end;
end;

procedure TcItemListClass.sendItemText(aname: string);
var
  temp: TWordComData;
begin
  if aname = '' then
    exit;
  if length(aname) > 32 then
    exit;
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ItemText);
  WordComData_ADDString(temp, aname);
  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

function TcItemListClass.getViewNameid(str: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rViewName) = str then
    begin
      result := i;
      exit;
    end;
  end;

end;

function TcItemListClass.getnameid(str: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rName) = str then
    begin
      result := i;
      exit;
    end;
  end;

end;

function TcItemListClass.getSuitIDCount(aid: integer): integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rSuitId) = aid then
    begin
      if (ItemArr[i].rWearArr) <> 9 then
        inc(result);
    end;
  end;

end;

function TcItemListClass.getname(str: string): PTItemdata;
var
  i: integer;
begin
  result := nil;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rName) = str then
    begin
      result := @ItemArr[i];
      exit;
    end;
  end;

end;

function formatStr(str: string; awidth: integer): string;
var
  temp: TStringlist;
  i: integer;
begin
  result := '';
  temp := TStringlist.Create;
  try
    ExtractStrings(['^'], [#13, #10], pchar(str), temp);
    for i := 0 to temp.Count - 1 do
    begin
      str := temp.Strings[i];
      while str <> '' do
      begin
        result := result + CutLengthString(str, awidth) + #13#10;
      end;
    end;
  finally
    temp.Free;
  end;
end;

function TcItemListClass.get(akey: integer): TItemData;
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    result := ItemArr[akey];
  end
  else
  begin
    fillchar(result, sizeof(TItemData), 0);
  end;
end;

procedure TcItemListClass.del(akey: integer);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    fillchar(ItemArr[akey], sizeof(TItemData), 0);
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitem(akey: integer; aitem: TItemData);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey] := aitem;
    if aitem.rName <> '' then
    begin
      if cItemTextClass.get(aitem.rName) = nil then
        sendItemText(aitem.rName);
    end;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitemChangeItem(akey: integer; akey2: integer);
var
  m: TItemData;
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
    if (akey2 >= low(ItemArr)) and (akey2 <= high(ItemArr)) then
    begin
      m := ItemArr[akey];
      ItemArr[akey] := ItemArr[akey2];
      ItemArr[akey2] := m;
      if assigned(FonUPdate) then
        FonUPdate(akey, ItemArr[akey]);
      if assigned(FonUPdate) then
        FonUPdate(akey2, ItemArr[akey2]);
    end;
end;

procedure TcItemListClass.clear;
begin
  fillchar(ItemArr[0], sizeof(TItemData) * high(ItemArr) + 1, 0);
end;

procedure TcItemListClass.upitemCountUP(akey: integer; acount: integer);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey].rCount := acount;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitemCountAdd(akey: integer; acount: integer);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey].rCount := ItemArr[akey].rCount + acount;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitemLockState(akey: integer; astate: integer);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey].rlockState := astate;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitemboBlueprint(akey: integer; astate: boolean);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey].rboBlueprint := astate;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitemBoIdent(akey: integer; astate: boolean);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey].rboident := astate;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitemCountDec(akey: integer; acount: integer);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey].rCount := ItemArr[akey].rCount - acount;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

procedure TcItemListClass.upitemcolor(akey: integer; acolor: integer);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey].rcolor := acolor;
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

constructor TcItemListClass.Create(amaxcount: integer);
begin
  setlength(ItemArr, amaxcount);
  fillchar(ItemArr[0], sizeof(TItemData) * high(ItemArr) + 1, 0);
  onUPdate := nil;
end;

destructor TcItemListClass.Destroy;
begin

  inherited Destroy;
end;
////////////////////////////////////////////////////
//                   TcWearitemClass
////////////////////////////////////////////////////

constructor TcWearitemClass.Create();
begin
  Wear := TcItemListClass.Create(14);
  WearFD := TcItemListClass.Create(14);

end;

destructor TcWearitemClass.Destroy;
begin
  Wear.Free;
  WearFD.Free;
  inherited Destroy;
end;

////////////////////////////////////////////////////
//                   TcMagicClass
////////////////////////////////////////////////////

procedure TcMagicClass.loadfromDamage(astr: string);
var
  TempDb: TUserStringDb;
  templist: tstringlist;
begin
  templist := tstringlist.Create;
  try
    templist.text := astr;

    TempDb := TUserStringDb.Create;
    try
      TempDb.LoadFromStringList(templist);
      loadDamage(TempDb);
    finally
      TempDb.Free;
    end;
  finally
    templist.Free;
  end;

end;

procedure TcMagicClass.loadfromArmor(astr: string);
var
  TempDb: TUserStringDb;
  templist: tstringlist;
begin
  templist := tstringlist.Create;
  try
    templist.text := astr;

    TempDb := TUserStringDb.Create;
    try
      TempDb.LoadFromStringList(templist);

      loadArmor(TempDb);
    finally
      TempDb.Free;
    end;
  finally
    templist.Free;
  end;

end;

constructor TcMagicClass.Create();
begin
  inherited Create;

end;

destructor TcMagicClass.Destroy;
begin

  inherited Destroy;
end;
////////////////////////////////////////////////////
//                   TcAttribClass
////////////////////////////////////////////////////

constructor TcAttribClass.Create();
begin
  inherited Create;

end;

destructor TcAttribClass.Destroy;
begin

  inherited Destroy;
end;

procedure TcAttribClass.setHead(Value: integer);
begin
  AttribData.CHeadSeak := Value;
  if Assigned(onhead) then
    onhead(CurAttribData.CurheadSeak, AttribData.cheadSeak);
end;

procedure TcAttribClass.setLeg(Value: integer);
begin
  AttribData.cLegSeak := Value;
  if Assigned(onleg) then
    onleg(CurAttribData.CurLegSeak, AttribData.cLegSeak);
end;

function TcAttribClass.getArm(): integer;
begin
  result := AttribData.carmSeak;
end;

function TcAttribClass.gethead(): integer;
begin
  result := AttribData.cheadSeak;
end;

function TcAttribClass.getleg(): integer;
begin
  result := AttribData.cLegSeak;
end;

procedure TcAttribClass.setArm(Value: integer);
begin
  AttribData.cArmSeak := Value;
  if Assigned(onArm) then
    onArm(CurAttribData.CurarmSeak, AttribData.cArmSeak);
end;

procedure TcAttribClass.MessageProcess(var code: TWordComData);
var
  pSLifeData: pTSLifeData;
  psAttribBase: PTSAttribBase;
  psAttribValues: PTSAttribValues;
  pSAttribUPDATE: pTSAttribUPDATE;
begin
  case Code.Data[0] of
    SM_ATTRIB_UPDATE:
      begin
        pSAttribUPDATE := @Code.Data;
        case pSAttribUPDATE.rType of
          aut_rprestige:
            begin
              AttribData.prestige := pSAttribUPDATE.rvaluer;
              if Assigned(onprestige) then
                onprestige(AttribData.prestige);
            end;
          aut_rprestige_Add:
            begin
              AttribData.prestige := AttribData.prestige + pSAttribUPDATE.rvaluer;
              if Assigned(onprestige) then
                onprestige(AttribData.prestige);
              if Assigned(onprestigeadd) then
                onprestigeadd(pSAttribUPDATE.rvaluer);

            end;
        end;

      end;
    SM_LifeData:
      begin
        pSLifeData := @Code.Data;
        LifeData.damageBody := pSLifeData.damageBody;
        LifeData.damageHead := pSLifeData.damageHead;
        LifeData.damageLeg := pSLifeData.damageLeg;
        LifeData.damageArm := pSLifeData.damageArm;

        LifeData.armorBody := pSLifeData.armorBody;
        LifeData.armorHead := pSLifeData.armorHead;
        LifeData.armorArm := pSLifeData.armorArm;
        LifeData.armorLeg := pSLifeData.armorLeg;

        LifeData.AttackSpeed := pSLifeData.AttackSpeed;
        LifeData.avoid := pSLifeData.avoid;
        LifeData.recovery := pSLifeData.recovery;
        LifeData.HitArmor := pSLifeData.HitArmor;
        LifeData.accuracy := pSLifeData.accuracy;
                //  FrmBottom.AddChat('测试消息：收到攻击 防御 速度 躲避 命中属性' + datetimetostr(now()), WinRGB(Random(22), 22, 0), 0);
      end;
    SM_ATTRIB_VALUES:
      begin
                // FrmBottom.AddChat('测试消息：收到ATTRIB_VALUES' + datetimetostr(now()), WinRGB(Random(22), 22, 0), 0);
        psAttribValues := @Code.Data;
        with psAttribValues^ do
        begin

          AttribData.cLight := rLight;
          AttribData.cDark := rDark;
          AttribData.cMagic := rMagic;

          AttribData.cTalent := rTalent;
          AttribData.cGoodChar := rGoodChar;
          AttribData.cBadChar := rBadChar;
          AttribData.cLucky := rLucky;
          AttribData.lucky := rlucky;
          AttribData.cAdaptive := rAdaptive;
          AttribData.cRevival := rRevival;
          AttribData.cimmunity := rimmunity;
          AttribData.cVirtue := rVirtue;

          CurAttribData.Curhealth := rCurhealth;
          CurAttribData.Cursatiety := rCursatiety;
          CurAttribData.Curpoisoning := rCurpoisoning;

          AttribData.cHealth := rhealth;
          AttribData.Csatiety := rsatiety;
          AttribData.Cpoisoning := rpoisoning;

          //天赋属性


          AttribData.newTalent := rCTalent;
          AttribData.newTalentLv := rCTalentLv;
          AttribData.newTalentExp := rCTalentExp;
          AttribData.newTalentNextLvExp := rCTalentNextLvExp;
          AttribData.newBone := rCnewBone;
          AttribData.newLeg := rCnewLeg;
          AttribData.newSavvy := rCnewSavvy;
          AttribData.newAttackPower := rCnewAttackPower;

          //ShowMessage(IntToStr(rCnewAttackPower));

          CurAttribData.CurHeadSeak := rCurHeadSeak;
          CurAttribData.CurArmSeak := rCurArmSeak;
          CurAttribData.CurLegSeak := rCurLegSeak;

                    //  AttribData.CHeadSeak := rHeadSeak;
                     // AttribData.CArmSeak := rArmSeak;
                      //AttribData.CLegSeak := rLegSeak;
          Head := rHeadSeak;
          Arm := rArmSeak;
          Leg := rLegSeak;
        end;
      end;
    SM_ATTRIBBASE:
      begin
                //  FrmBottom.AddChat('测试消息：收到ATTRIBBASE' + datetimetostr(now()), WinRGB(Random(22), 22, 0), 0);
        psAttribBase := @Code.Data;
        with psAttribBase^ do
        begin
          AttribData.cAge := rAge; //年龄
          AttribData.cEnergy := rEnergy; //元气
          CurAttribData.CurEnergy := rCurEnergy;

          AttribData.cInPower := rInPower; //内功
          CurAttribData.CurInPower := rCurInPower;

          AttribData.cOutPower := rOutPower; //外功
          CurAttribData.CurOutPower := rCurOutPower;

          AttribData.cMagic := rMagic; //武功
          CurAttribData.CurMagic := rCurMagic;

          AttribData.cLife := rLife; //活力 生命
          CurAttribData.CurLife := rCurLife;
          AttribData.lucky := rlucky;
          AttribData.newTalent := rCTalent;
          AttribData.newTalentExp := rCTalentExp;
          AttribData.newTalentNextLvExp := rCTalentNextLvExp;
          AttribData.newTalentLv := rCTalentLv;
          AttribData.newBone := rCnewBone;
          AttribData.newLeg := rCnewLeg;
          AttribData.newSavvy := rCnewSavvy;
          AttribData.newAttackPower := rCnewAttackPower;
        end;

      end;

  end;
end;
////////////////////////////////////////////////////
//                   TcHaveMagicClass
////////////////////////////////////////////////////

constructor TcHaveMagicClass.Create();
begin
  HaveMagic := TcMagicListClass.Create(60);
  DefaultMagic := TcMagicListClass.Create(20);
  HaveRiseMagic := TcMagicListClass.Create(60);
  HaveMysteryMagic := TcMagicListClass.Create(60);
end;

destructor TcHaveMagicClass.Destroy;
begin
  HaveMagic.Free;
  DefaultMagic.Free;
  HaveRiseMagic.Free;
  HaveMysteryMagic.Free;
  inherited Destroy;
end;

procedure TcHaveMagicClass.addexp(aitem: TMagicData);
begin
  HaveMagic.addexp(aitem);
  DefaultMagic.addexp(aitem);
  HaveRiseMagic.addexp(aitem);
  HaveMysteryMagic.addexp(aitem);
end;
////////////////////////////////////////////////////
//                   TcMagicListClass
////////////////////////////////////////////////////

constructor TcMagicListClass.Create(amaxcount: integer);
begin
  setlength(ItemArr, amaxcount);
  fillchar(ItemArr[0], sizeof(TMagicData) * high(ItemArr) + 1, 0);
  onUPdate := nil;
end;

destructor TcMagicListClass.Destroy;
begin
  inherited Destroy;
end;

procedure TcMagicListClass.addexp(aitem: TMagicData);
var
  i: integer;
  atemp: TMagicData;
begin
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rID) = aitem.rID then
    begin
      atemp := ItemArr[i];
      atemp.rcSkillLevel := aitem.rcSkillLevel;
      FrmM.EventstringSet(atemp.rname, EventString_Magic);
      FrmM.EventstringSet(atemp.rname, EventString_Attrib);
      upitem(i, atemp);
      exit;
    end;
  end;

end;

procedure TcMagicListClass.upitem(akey: integer; aitem: TMagicData);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    ItemArr[akey] := aitem;
    cMagicClass.Calculate_cLifeData(@ItemArr[akey]);
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

function TcMagicListClass.get(akey: integer): TMagicData;
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    result := ItemArr[akey];
  end
  else
  begin
    fillchar(result, sizeof(TMagicData), 0);
  end;
end;

procedure TcMagicListClass.del(akey: integer);
begin
  if (akey >= low(ItemArr)) and (akey <= high(ItemArr)) then
  begin
    fillchar(ItemArr[akey], sizeof(TMagicData), 0);
    if assigned(FonUPdate) then
      FonUPdate(akey, ItemArr[akey]);
  end;
end;

function TcMagicListClass.getMagicType(aMagicType: integer): PTMagicData;
var
  i: integer;
begin
  result := nil;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rMagicType) = aMagicType then
    begin
      result := @ItemArr[i];
      exit;
    end;
  end;

end;

function TcMagicListClass.getMoveMagicNameList: string;
var
  i: integer;
  temp: TMagicData;
begin
  Result := '';
  for i := 0 to high(ItemArr) do
  begin
    temp := ItemArr[i];
    if temp.rname = '草上飞' then
      Result := Result + temp.rname + #13#10
    else if temp.rname = '归归步法' then
      Result := Result + temp.rname + #13#10
    else if temp.rname = '徒步飞' then
      Result := Result + temp.rname + #13#10
    else if temp.rname = '弓身' then
      Result := Result + temp.rname + #13#10
    else if temp.rname = '灵空虚徒' then
      Result := Result + temp.rname + #13#10
    else if temp.rname = '陆地飞行术' then
      Result := Result + temp.rname + #13#10
    else if temp.rname = '幻魔身法' then
      Result := Result + temp.rname + #13#10;
  end;

end;

function TcMagicListClass.getMagicTypeIndex(aMagicType: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rMagicType) = aMagicType then
    begin
      result := i;
      exit;
    end;
  end;

end;

function TcMagicListClass.getname(str: string): PTMagicData;
var
  i: integer;
begin
  result := nil;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rname) = str then
    begin
      result := @ItemArr[i];
      exit;
    end;
  end;

end;

function TcMagicListClass.getindex(id: integer): PTMagicData;
begin
  result := nil;
  if (id >= 0) and (id <= high(ItemArr)) then
    result := @ItemArr[id];

end;

function TcMagicListClass.getID(aMagicid: integer): PTMagicData;
var
  i: integer;
begin
  result := nil;
  for i := 0 to high(ItemArr) do
  begin
    if (ItemArr[i].rID) = aMagicid then
    begin
      result := @ItemArr[i];
      exit;
    end;
  end;

end;
////////////////////////////////////////////////////
//                   TFrmAttrib
////////////////////////////////////////////////////

procedure TFrmAttrib.onHaveMagicUp(akey: integer; aitem: TMagicData);
begin
  if aitem.rname <> '' then
  begin
    if Frmbottom.UseMagic1.Caption = (aitem.rName) then
      Frmbottom.PGSkillLevelSET(aitem.rcSkillLevel);
    SetMagicLabel(MLabels[akey], (aitem.rName) + ':' + Get10000To100(aitem.rcSkillLevel), 0, aitem.rShape, 0);
  end
  else
  begin
    SetMagicLabel(MLabels[akey], (aitem.rName), 0, 0, 0);

  end;
//    FrmBottom.ShortcutKeyUP(akey + 30);
  FrmNewMagic.onHaveMagicUp(akey, aitem);
end;

procedure TFrmAttrib.ONLeg(value_max, value: integer);
begin
  Frmbottom.ONLeg(value_max, value);
end;

procedure TFrmAttrib.ONArm(value_max, value: integer);
begin
  Frmbottom.ONArm(value_max, value);
end;

procedure TFrmAttrib.ONHead(value_max, value: integer);
begin
  Frmbottom.ONHead(value_max, value);
end;

procedure TFrmAttrib.onprestige(value: integer);
begin
  FrmWearItem.onprestige(value);
end;

procedure TFrmAttrib.onMoney(acount: integer);
begin
  Fmoney := acount;
  FrmWearItem.onMoney(acount);
end;

procedure TFrmAttrib.onDefaultMagicUp(akey: integer; aitem: TMagicData);
begin
  if aitem.rname <> '' then
  begin
    if Frmbottom.UseMagic1.Caption = (aitem.rName) then
      Frmbottom.PGSkillLevelSET(aitem.rcSkillLevel);
    SetMagicLabel(BLabels[akey], (aitem.rName) + ':' + Get10000To100(aitem.rcSkillLevel), 0, aitem.rShape, 0);
  end
  else
  begin
    SetMagicLabel(BLabels[akey], (aitem.rName), 0, 0, 0);

  end;
//    FrmBottom.ShortcutKeyUP(akey);
  FrmNewMagic.onDefaultMagicUp(akey, aitem);
end;

procedure TFrmAttrib.onUserWearitemUPdate(akey: integer; aitem: titemdata);
begin

  frmWearItemUser.ItemPaint(akey, aitem);
end;

procedure TFrmAttrib.onUserWearFDitemUPdate(akey: integer; aitem: titemdata);
begin
  frmWearItemUser.ItemFDPaint(akey, aitem);
end;

procedure TFrmAttrib.onWearitemUPdate(akey: integer; aitem: titemdata);
begin
  FrmWearItem.updateWearItem(akey, aitem);
end;

procedure TFrmAttrib.onWearFDitemUPdate(akey: integer; aitem: titemdata);
begin
  FrmWearItem.ItemPaintFD(akey, aitem);
end;
//背包 物品 改变

procedure TFrmAttrib.onHaveitemUPdate(akey: integer; aitem: titemdata);
var
  idx: integer;
begin
  if aitem.rViewName = '' then
  begin
    SetItemLabel(ILabels[akey], '', 0, 0, 0, 0);
//        FrmBottom.ShortcutKeyUP(akey + 60);
    ILabels[akey].Hint := '';
  end
  else
  begin
    if aitem.rlockState = 1 then
      idx := 24
    else if aitem.rlockState = 2 then
      idx := 25
    else
      idx := 0;
    SetItemLabel(ILabels[akey], (aitem.rViewName), aitem.rColor, aitem.rshape, idx, 0);
//        FrmBottom.ShortcutKeyUP(akey + 60);
    if aitem.rcount <= 1 then
      ILabels[akey].Hint := (aitem.rViewName)
    else
      ILabels[akey].Hint := (aitem.rViewName) + ':' + IntToStr(aitem.rCount);
  end;
  FrmWearItem.onHaveitemUPdate(akey, aitem);
end;

procedure TFrmAttrib.SetFormText;
begin
  PgHead.Hint := ('头');
  PGArm.Hint := ('手臂');
  PGLeg.Hint := ('腿');

  LbSkill0.Hint := ('铸造师');
  LbSkill1.Hint := ('炼丹师');
  LbSkill2.Hint := ('工匠');
  LbSkill3.Hint := ('火药师');
  LbSkill4.Hint := ('美容师');
  LbSkill5.Hint := ('料理师');
  LbSkill6.Hint := ('裁缝师');
  LbSkill7.Hint := ('占卜师');
end;

function Get10000To100(avalue: integer): string;
var
  n: integer;
  str: string;
begin
  str := InttoStr(avalue div 100) + '.';
  n := avalue mod 100;
  if n >= 10 then
    str := str + IntToStr(n)
  else
    str := str + '0' + InttoStr(n);

  Result := str;
end;

procedure TFrmAttrib.FormCreate(Sender: TObject);
var
  i: integer;
begin
  cItemTextClass := TcItemTextClass.Create;
  cF5_F12Class := TKeyClass.Create;
  cF5_F12Class.FOnUpdate := onKeyF5_F12UPdate;
  cKeyClass := TKeyClass.Create;
  cKeyClass.FOnUpdate := onKeyItemUPdate;

  cMagicClass := TcMagicClass.Create;
  HaveItemQuestClass := TcItemListClass.Create(30);
  HaveItemQuestClass.onUPdate := onHaveitemQuestUPdate;

  HaveItemclass := TcItemListClass.Create(30);
  HaveItemclass.onUPdate := onHaveitemUPdate;

  WearItemclass := TcWearitemClass.Create;
  WearItemclass.Wear.onUPdate := onWearitemUPdate;
  WearItemclass.WearFD.onUPdate := onWearFDitemUPdate;

  WearUseritemClass := TcWearitemClass.Create;
  WearUseritemClass.Wear.onUPdate := onUserWearitemUPdate;
  WearUseritemClass.WearFD.onUPdate := onUserWearFDitemUPdate;

  HaveMagicClass := TcHaveMagicClass.Create;
  HaveMagicClass.HaveMagic.onUPdate := onHaveMagicUp;
  HaveMagicClass.DefaultMagic.onUPdate := onDefaultMagicUp;
  HaveMagicClass.HaveRiseMagic.onUPdate := onHaveRiseMagicUp;
  HaveMagicClass.HaveMysteryMagic.onUPdate := onHaveMysteryMagicUp;

  cAttribClass := TcAttribClass.Create;
  cAttribClass.onHead := ONHead;
  cAttribClass.onArm := ONArm;
  cAttribClass.onLeg := ONLeg;
  cAttribClass.onprestige := onPrestige;
  cAttribClass.onprestigeadd := FrmWearItem.onPrestigeadd;
  cOtherUserAttribClass := TcOtherUserAttribClass.Create;
  DoubleBuffered := true;

  Fmoney := 0;
  FITEMA2Hint := TA2Hint.Create;
    // Image1.Picture.LoadFromFile('attrib.bmp');
  //  pgkBmp.getBitmap('attrib.bmp', Image1.Picture.Bitmap);
  viewImage := TA2ImageLib.Create; //  view.atz
    //  viewImage.LoadFromFile('.\ect\view.atz');
  pgkect.getImageLib('view.atz', viewImage);

  WWWImageLib := TA2ImageLib.Create; //energy.atz
    //  WWWImageLib.LoadFromFile('.\ect\www.atz');
  pgkect.getImageLib('www.atz', WWWImageLib);

  energyImageLib := TA2ImageLib.Create; //energy.atz
  //  energyImageLib.LoadFromFile(ExtractFilePath(ParamStr(0))+'ect\energy.atz');
  pgkect.getImageLib('energy.atz', energyImageLib);

  savekeyImagelib := TA2ImageLib.Create;
  pgkect.getImageLib('funcimg.atz', savekeyImagelib);
    // savekeyImagelib.LoadFromFile('.\ect\funcimg.atz');
  savekeyImage := TA2Image.Create(140, 140, 0, 0);

  Color := clBlack;
  Parent := FrmM;
    // FrmM.AddA2Form(Self, A2form);
  Left := fwide - Width;
  Top := 0;
  SetFormText; // hint text
    // FrmAttrib Set Font
  FrmAttrib.Font.Name := mainFont;
  LbMoney.Font.Name := mainFont;
  LbEvent.Font.Name := mainFont;
  LbWindowName.Font.Name := mainFont;
  LbAge.Font.Name := mainFont;
  LbVirtue.Font.Name := mainFont;

  CharCenterImage := TA2Image.Create(56, 72, 0, 0);
  LbChar.A2Image := CharCenterImage;

  MLabels[0] := MLabel0;
  MLabels[1] := MLabel1;
  MLabels[2] := MLabel2;
  MLabels[3] := MLabel3;
  MLabels[4] := MLabel4;
  MLabels[5] := MLabel5;
  MLabels[6] := MLabel6;
  MLabels[7] := MLabel7;
  MLabels[8] := MLabel8;
  MLabels[9] := MLabel9;
  MLabels[10] := MLabel10;
  MLabels[11] := MLabel11;
  MLabels[12] := MLabel12;
  MLabels[13] := MLabel13;
  MLabels[14] := MLabel14;
  MLabels[15] := MLabel15;
  MLabels[16] := MLabel16;
  MLabels[17] := MLabel17;
  MLabels[18] := MLabel18;
  MLabels[19] := MLabel19;
  MLabels[20] := MLabel20;
  MLabels[21] := MLabel21;
  MLabels[22] := MLabel22;
  MLabels[23] := MLabel23;
  MLabels[24] := MLabel24;
  MLabels[25] := MLabel25;
  MLabels[26] := MLabel26;
  MLabels[27] := MLabel27;
  MLabels[28] := MLabel28;
  MLabels[29] := MLabel29;
  MLabels[30] := MLabel30;
  MLabels[31] := MLabel31;
  MLabels[32] := MLabel32;
  MLabels[33] := MLabel33;
  MLabels[34] := MLabel34;
  MLabels[35] := MLabel35;
  MLabels[36] := MLabel36;
  MLabels[37] := MLabel37;
  MLabels[38] := MLabel38;
  MLabels[39] := MLabel39;
  MLabels[40] := MLabel40;
  MLabels[41] := MLabel41;
  MLabels[42] := MLabel42;
  MLabels[43] := MLabel43;
  MLabels[44] := MLabel44;
  MLabels[45] := MLabel45;
  MLabels[46] := MLabel46;
  MLabels[47] := MLabel47;
  MLabels[48] := MLabel48;
  MLabels[49] := MLabel49;
  MLabels[50] := MLabel50;
  MLabels[51] := MLabel51;
  MLabels[52] := MLabel52;
  MLabels[53] := MLabel53;
  MLabels[54] := MLabel54;
  MLabels[55] := MLabel55;
  MLabels[56] := MLabel56;
  MLabels[57] := MLabel57;
  MLabels[58] := MLabel58;
  MLabels[59] := MLabel59;

  BLabels[0] := BLabel0;
  BLabels[1] := BLabel1;
  BLabels[2] := BLabel2;
  BLabels[3] := BLabel3;
  BLabels[4] := BLabel4;
  BLabels[5] := BLabel5;
  BLabels[6] := BLabel6;
  BLabels[7] := BLabel7;
  BLabels[8] := BLabel8;
  BLabels[9] := BLabel9;
  BLabels[10] := BLabel10;
  BLabels[11] := BLabel11;
  BLabels[12] := BLabel12;
  BLabels[13] := BLabel13;
  BLabels[14] := BLabel14;
  BLabels[15] := BLabel15;
  BLabels[16] := BLabel16;
  BLabels[17] := BLabel17;
  BLabels[18] := BLabel18;
  BLabels[19] := BLabel19;
  BLabels[20] := BLabel20;
  BLabels[21] := BLabel21;
  BLabels[22] := BLabel22;
  BLabels[23] := BLabel23;
  BLabels[24] := BLabel24;
  BLabels[25] := BLabel25;
  BLabels[26] := BLabel26;
  BLabels[27] := BLabel27;
  BLabels[28] := BLabel28;
  BLabels[29] := BLabel29;

  ILabels[0] := A2ILabel0;
  ILabels[1] := A2ILabel1;
  ILabels[2] := A2ILabel2;
  ILabels[3] := A2ILabel3;
  ILabels[4] := A2ILabel4;
  ILabels[5] := A2ILabel5;
  ILabels[6] := A2ILabel6;
  ILabels[7] := A2ILabel7;
  ILabels[8] := A2ILabel8;
  ILabels[9] := A2ILabel9;
  ILabels[10] := A2ILabel10;
  ILabels[11] := A2ILabel11;
  ILabels[12] := A2ILabel12;
  ILabels[13] := A2ILabel13;
  ILabels[14] := A2ILabel14;
  ILabels[15] := A2ILabel15;
  ILabels[16] := A2ILabel16;
  ILabels[17] := A2ILabel17;
  ILabels[18] := A2ILabel18;
  ILabels[19] := A2ILabel19;
  ILabels[20] := A2ILabel20;
  ILabels[21] := A2ILabel21;
  ILabels[22] := A2ILabel22;
  ILabels[23] := A2ILabel23;
  ILabels[24] := A2ILabel24;
  ILabels[25] := A2ILabel25;
  ILabels[26] := A2ILabel26;
  ILabels[27] := A2ILabel27;
  ILabels[28] := A2ILabel28;
  ILabels[29] := A2ILabel29;

  SLabels[0] := LbSkill0;
  SLabels[1] := LbSkill1;
  SLabels[2] := LbSkill2;
  SLabels[3] := LbSkill3;
  SLabels[4] := LbSkill4;
  SLabels[5] := LbSkill5;
  SLabels[6] := LbSkill6;
  SLabels[7] := LbSkill7;

  for i := 0 to 60 - 1 do
    SetMagicLabel(MLabels[i], '', 0, 0, 0);
  for i := 0 to 30 - 1 do
    SetMagicLabel(BLabels[i], '', 0, 0, 0);
//    for i := 0 to high(BasicBufferkey) do BasicBufferkey[i] := 255;
  for i := 0 to 60 - 1 do
    MLabels[i].A2ShowHint := FALSE;
  for i := 0 to 30 - 1 do
    BLabels[i].A2ShowHint := FALSE;
  for i := 0 to 30 - 1 do
  begin
    ILabels[i].A2ShowHint := FALSE;
    ILabels[i].BColor := ColorSysToDxColor(ILabels[i].Color);
  end;
    //
  listContent.SetScrollTopImage(getviewImage(7), getviewImage(6));
  listContent.SetScrollTrackImage(getviewImage(4), getviewImage(5));
  listContent.SetScrollBottomImage(getviewImage(9), getviewImage(8));
  listContent.FFontSelBACKColor := ColorSysToDxColor($9B7781);
  listContent.FLayout := tlCenter;
  G_BufferItemDataClass := TcBufferItemDataClass.Create;
end;

procedure TFrmAttrib.FormDestroy(Sender: TObject);
begin
  cF5_F12Class.Free;
  cKeyClass.Free;
  HaveItemQuestClass.Free;
  cItemTextClass.Free;
  cMagicClass.Free;
  cAttribClass.Free;
  cOtherUserAttribClass.Free;
  HaveItemclass.free;
  WearitemClass.free;
  WearUseritemClass.free;
  HaveMagicClass.free;

  FITEMA2Hint.Free;
    //    application.UnhookMainWindow(AppKeyDownHook);
  energyImageLib.Free;
  savekeyImagelib.Free;
  savekeyImage.Free;
  WWWImageLib.Free;
  CharCenterImage.Free;
  viewImage.Free;
  G_BufferItemDataClass.Free;
end;
//2015.06.26在水一方 >>>>>>

procedure TFrmAttrib.SetItemLabelBackGround(Lb: TA2ILabel; acolor: byte; BackGroundFileName: string);
var
  back: TA2Image;
  gc, ga: Integer;
begin
  if BackGroundFileName <> '' then
  try
    back := TA2Image.Create(Lb.Width, Lb.Height, 0, 0);
    back.LoadFromFile(BackGroundFileName);
    back.addColor(1, 1, 1);
    GetGreenColorAndAdd(acolor, gc, ga);
    with Lb do begin
      if A2Image = nil then
        A2Image := TA2Image.Create(Lb.Width, Lb.Height, 0, 0)
      else A2Image.clear(1);
      if gc = 0 then
      begin
        A2Image.DrawImage(back, (Width - back.Width) div 2, (Height - back.Height) div 2, true);
      end
      else
      begin
        try
          A2Image.DrawImageGreenConvert(back, (Width - back.Width) div 2, (Height - back.Height) div 2, gc, ga);
        except
        end;
      end;
    end;
  finally
    back.Free;
  end;
end;
//2015.06.26在水一方 <<<<<<

procedure TFrmAttrib.SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
var
  gc, ga: integer;
begin
    //savekeyImagelib[idx]
  Lb.Caption := aname;
  Lb.Font.Color := clRed; //添加上颜色 20130720
    //lb.Font.Size:=1;
  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;
    // Lb.BColor := Color;
  if shape = 0 then
  begin
    Lb.A2Image := nil;
    Lb.A2ImageRDown := nil;
        // Lb.A2ImageLUP := nil;
    exit;
  end
  else
  begin
    lb.Visible := true;
    Lb.A2Image := AtzClass.GetItemImage(shape);
    if shapeRdown = 0 then
      Lb.A2ImageRDown := nil
    else
      Lb.A2ImageRDown := savekeyImagelib[shapeRdown];
        { if shapeLUP = 0 then Lb.A2ImageLUP := nil
         else
             Lb.A2ImageLUP := savekeyImagelib[shapeLUP];
             }
  end;

end;

procedure TFrmAttrib.SetMagicLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shape2: word);
var
  gc, ga: integer;
begin
  Lb.Caption := '';
  Lb.Hint := aname;

  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;

    { if shape = 0 then
     begin
         Lb.A2Image := nil;
         Lb.BColor := 0;
         exit;
     end else}
   // Lb.A2Imageback := AtzClass.GetMagicImage(0);
  Lb.A2Image := AtzClass.GetMagicImage(shape);

  KeySelmagicIndex := -1; // 公傍父 困摹函版啊瓷
  if Lb.Hint <> '' then
  begin
    KeySelmagicIndex := Lb.Tag + 30; //不知道调用lb.tag是做什么的
    savekeyBool := TRUE;
  end;

end;

procedure TFrmAttrib.MessageProcess(var code: TWordComData);
var
  psAttribValues: PTSAttribValues;
  psAttribBase: PTSAttribBase;
  psWearItem: pTsWearItem;
  psHaveMagic: PTSHaveMagic;
  psHaveItem: PTSHaveItem;
  idx, i, n, nkey, n1: integer;
  pskey: pTSkey;
  pSHailFellowbasic: pTSHailFellowbasic;
  pSHailFellowChangeProperty: pTSHailFellowChangeProperty;
  sname, astr: string;
  atype: ItemTextType;
  pitem: pTItemData;
  aitem: TItemData;
  amagic: TMagicData;
begin
  case Code.Data[0] of
    SM_Designation:
      begin
        i := 1;
        n := WordComData_GETbyte(code, i);
        case n of
          Designation_user:
            begin
              astr := WordComData_GETString(code, i);
              frmCharAttrib.A2LabelDesignation.Caption := astr;
            end;
          Designation_menu:
            begin
              astr := WordComData_GETStringPro(code, i);
              frmCharAttrib.listDesignation.StringList.Text := astr;
              frmCharAttrib.listDesignation.DrawItem;
            end;
        else
          ;
        end;

      end;
    SM_money:
      begin
        i := 1;
        n := WordComData_GETdword(code, i);
        onMoney(n);
      end;
    SM_Bindmoney:
      begin
        i := 1;
        n := WordComData_GETdword(code, i);
        onBindMoney(n);
      end;
    SM_ITEM_UPDATE:
      begin
        i := 1;
        nkey := WordComData_GETbyte(code, i);
        idx := WordComData_GETbyte(code, i);
        case TSENDUPDATEITEMTYPE(nkey) of
          suitHave, suitHaveNoInfo:
            pitem := HaveItemclass.getid(idx);
          suitWear:
            pitem := WearItemclass.wear.getid(idx);
          suitWearFd:
            pitem := WearItemclass.wearFD.getid(idx);
        else
          exit;
        end;
        n := WordComData_GETbyte(code, i);
        case n of
          ITEM_UPDATE_add:
            begin
              TWordComDataToTItemData(i, code, aitem);

              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave:
                  begin
                    HaveItemclass.upitem(idx, aitem);
                    PersonBat.LeftMsgListadd3(format('%s 获得 %d 个', [aitem.rViewName, aitem.rCount]), WinRGB(22, 22, 0));
                  end;
                suitHaveNoInfo:
                  HaveItemclass.upitem(idx, aitem);
                suitWear:
                  WearItemclass.Wear.upitem(idx, aitem);
                suitWearFd:
                  WearItemclass.wearFD.upitem(idx, aitem);
              else
                exit;
              end;
            end;
          ITEM_UPDATE_del:
            begin
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  HaveItemclass.del(idx);
                suitWear:
                  WearItemclass.Wear.del(idx);
                suitWearFd:
                  WearItemclass.wearFD.del(idx);
              else
                exit;
              end;
            end;
          ITEM_UPDATE_rcolor:
            begin
              n1 := WordComData_GETdword(code, i);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  begin
                    HaveItemclass.upitemcolor(idx, n1);

                  end;
                suitWear:
                  WearItemclass.Wear.upitemcolor(idx, n1);
                suitWearFd:
                  WearItemclass.wearFD.upitemcolor(idx, n1);
              else
                exit;
              end;
            end;
          ITEM_UPDATE_ChangeItem:
            begin
              n1 := WordComData_GETbyte(code, i);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  HaveItemclass.upitemChangeItem(idx, n1);
              else
                exit;
              end;
            end;
          ITEM_UPDATE_rcount_add:
            begin
              n1 := WordComData_GETdword(code, i);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave:
                  begin
                    HaveItemclass.upitemCountadd(idx, n1);
                    pitem := HaveItemclass.getid(idx);
                    if pitem <> nil then
                      PersonBat.LeftMsgListadd3(format('%s 获得 %d 个', [pitem.rViewName, n1]), WinRGB(22, 22, 0));
                  end;
                suitHaveNoInfo:
                  HaveItemclass.upitemCountadd(idx, n1);
                suitWear:
                  WearItemclass.Wear.upitemCountadd(idx, n1);
                suitWearFd:
                  WearItemclass.wearFD.upitemCountadd(idx, n1);
              else
                exit;
              end;
            end;

          ITEM_UPDATE_rcount_UP:
            begin
              n1 := WordComData_GETdword(code, i);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave:
                  begin
                    HaveItemclass.upitemCountUP(idx, n1);
                  end;
                suitHaveNoInfo:
                  HaveItemclass.upitemCountUP(idx, n1);
                suitWear:
                  WearItemclass.Wear.upitemCountUP(idx, n1);
                suitWearFd:
                  WearItemclass.wearFD.upitemCountUP(idx, n1);
              else
                exit;
              end;
            end;
          ITEM_UPDATE_rcount_dec:
            begin
              n1 := WordComData_GETdword(code, i);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  HaveItemclass.upitemCountdec(idx, n1);
                suitWear:
                  WearItemclass.Wear.upitemCountdec(idx, n1);
                suitWearFd:
                  WearItemclass.wearFD.upitemCountdec(idx, n1);
              else
                exit;
              end;
            end;
          ITEM_UPDATE_rtimemode_del:
            begin
              FrmBottom.AddChat(format('%s物品使用时间到期', [pitem.rViewName]), WinRGB(22, 22, 0), 0);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  HaveItemclass.del(idx);
                suitWear:
                  WearItemclass.wear.del(idx);
                suitWearFd:
                  WearItemclass.wearFD.del(idx);
              else
                exit;
              end;
            end;

          ITEM_UPDATE_rlocktime:
            begin
              idx := WordComData_GETdword(code, i);
              pitem.rlocktime := idx;
            end;
          ITEM_UPDATE_rlockState:
            begin
              n1 := WordComData_GETbyte(code, i);
                            // pitem.rlockState := idx;
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  HaveItemclass.upitemLockState(idx, n1);
                suitWear:
                  WearItemclass.Wear.upitemLockState(idx, n1);
                suitWearFd:
                  WearItemclass.wearFD.upitemLockState(idx, n1);
              else
                exit;
              end;
            end;
          ITEM_UPDATE_rDurability:
            begin
              idx := WordComData_GETdword(code, i);
              pitem.rCurDurability := idx;
            end;
          ITEM_UPDATE_rboident:
            begin
              n1 := WordComData_GETbyte(code, i);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  HaveItemclass.upitemBoIdent(idx, boolean(n1));
                suitWear:
                  WearItemclass.Wear.upitemBoIdent(idx, boolean(n1));
                suitWearFd:
                  WearItemclass.wearFD.upitemBoIdent(idx, boolean(n1));
              else
                exit;
              end;
            end;
          ITEM_UPDATE_rSpecialLevel:
            begin
              idx := WordComData_GETdword(code, i);
              pitem.rSpecialLevel := idx;
            end;
          ITEM_UPDATE_rboBlueprint:
            begin
              n1 := WordComData_GETbyte(code, i);
              case TSENDUPDATEITEMTYPE(nkey) of
                suitHave, suitHaveNoInfo:
                  HaveItemclass.upitemboBlueprint(idx, boolean(n1));
                suitWear:
                  WearItemclass.Wear.upitemboBlueprint(idx, boolean(n1));
                suitWearFd:
                  WearItemclass.wearFD.upitemboBlueprint(idx, boolean(n1));
              else
                exit;
              end;
            end;
        end;

      end;
        { SM_HailFellow:
             begin
                 pSHailFellowbasic := @Code.Data;

                 sname := (pSHailFellowbasic.rName);
                 case pSHailFellowbasic.rkey of
                     HailFellow_Message_ADD: //有人 要加我
                         begin
                             // frmConfirmDialog.MessageProcess(code);
                             frmPopMsg.MessageProcess(code);
                         end;
                     HailFellowChangeProperty: //好又列表
                         begin
                             pSHailFellowChangeProperty := @Code.Data;
                             sname := (pSHailFellowChangeProperty.rName);
                             if HailFellowisuname(sname) and chat_outcry then
                                 if (pSHailFellowChangeProperty.rstate = HailFellow_state_onlise) then
                                     FrmBottom.AddChat(format('你的好友【%s】上线了', [sname]), WinRGB(22, 22, 0), 0)
                                 else
                                     FrmBottom.AddChat(format('你的好友【%s】离线了', [sname]), WinRGB(22, 22, 0), 0);
                             HailFellowadd(sname);
                             HailFellowSETstate(sname, pSHailFellowChangeProperty.rstate);
                         end;
                     HailFellow_GameExit: //好朋友  下线
                         begin
                             HailFellowSETstate(sname, HailFellow_state_downlide);
                             if chat_outcry then
                                 FrmBottom.AddChat(format('你的好友【%s】离线了', [sname]), WinRGB(22, 22, 0), 0);
                         end;
                     HailFellow_del:
                         begin
                             HailFellowdel(sname);
                         end;
                 end;

             end;
             }
    SM_keyf5f12:
      begin
            {
00，DefaultMagic
30，HaveMagic
60，HaveItemclass
90,WINDOW_MAGICS_Rise
120,WINDOW_MAGICS_Mystery
}
        pskey := @Code.Data;

        cF5_F12Class.Clear;
        cKeyClass.Clear;
        keyselmagicindexadd := -1;
        for idx := 0 to high(pskey.rKEY) do
        begin
                   // keysetImg(idx, -1);
                  //  keysetImg(idx, pskey.rKEY[idx]);
          case pskey.rKEY[idx] of
            0..29:
              cKeyClass.UPdate(idx, kcdt_F5_f12, kcdk_BasicMagic, pskey.rKEY[idx]);
            30..89:
              cKeyClass.UPdate(idx, kcdt_F5_f12, kcdk_HaveMagic, pskey.rKEY[idx] - 30);
            90..119:
              cKeyClass.UPdate(idx, kcdt_F5_f12, kcdk_HaveItem, pskey.rKEY[idx] - 90);
            120..179:
              cKeyClass.UPdate(idx, kcdt_F5_f12, kcdk_HaveRiseMagic, pskey.rKEY[idx] - 120);
            180..239:
              cKeyClass.UPdate(idx, kcdt_F5_f12, kcdk_HaveMysteryMagic, pskey.rKEY[idx] - 180);
          end;
        end;
              //  FrmBottom.ShortcutKeyClear;
        for idx := 0 to high(pskey.rKEY2) do
        begin
                   // FrmBottom.ShortcutKeySETimg(idx, pskey.rKEY2[idx]);
          case pskey.rKEY2[idx] of
            0..29:
              cF5_F12Class.UPdate(idx, kcdt_key, kcdk_BasicMagic, pskey.rKEY2[idx]);
            30..89:
              cF5_F12Class.UPdate(idx, kcdt_key, kcdk_HaveMagic, pskey.rKEY2[idx] - 30);
            90..119:
              cF5_F12Class.UPdate(idx, kcdt_key, kcdk_HaveItem, pskey.rKEY2[idx] - 90);
            120..179:
              cF5_F12Class.UPdate(idx, kcdt_key, kcdk_HaveRiseMagic, pskey.rKEY2[idx] - 120);
            180..239:
              cF5_F12Class.UPdate(idx, kcdt_key, kcdk_HaveMysteryMagic, pskey.rKEY2[idx] - 180);
          end;
        end;

      end;
    SM_HAVEITEM_LIST_QUEST:
      begin
        fillchar(aitem, sizeof(aitem), 0);
        i := 1;
        nkey := WordComData_GETbyte(code, i);
        sname := WordComData_GETString(code, i);
        if sname <> '' then
        begin
          astr := WordComData_GETString(code, i);
          aitem.rCount := WordComData_GETdword(code, i);
          aitem.rMaxCount := WordComData_GETdword(code, i);
          aitem.rShape := WordComData_GETword(code, i);
          aitem.rName := copy(sname, 1, 20);
          aitem.rViewName := copy(astr, 1, 20);
          aitem.rKind := ITEM_KIND_QUEST;
          HaveItemQuestClass.upitem(nkey, aitem);
        end
        else
        begin
          HaveItemQuestClass.del(nkey);
        end;

      end;
    SM_HAVEITEM_list:
      begin
        psHaveItem := @Code.Data;
        with pshaveitem^ do
        begin
          if rdel then
          begin
            HaveItemclass.del(rkey);
          end
          else
          begin
            i := sizeof(tsHaveItem);
            TWordComDataToTItemData(i, code, aitem);
            HaveItemclass.upitem(rkey, aitem);

          end;
        end;
      end;

    SM_ItemTextAdd:
      begin
        i := 1;
        sname := WordComData_getString(code, i);
        astr := WordComData_getString(code, i);
        cItemTextClass.addText(sname, astr);
      end;
    SM_WEARITEM:
      begin

        psWearItem := @Code.Data;

        case psWearItem.rtype of
          witWear:
            begin
              i := sizeof(TsWearItem);
              TWordComDataToTItemData(i, code, aitem);
              WearItemclass.wear.upitem(pswearitem^.rkey, aitem);

            end;
          witWeardel:
            begin
              WearItemclass.wear.del(pswearitem^.rkey);
            end;
          witWearFD:
            begin
              i := sizeof(TsWearItem);
              TWordComDataToTItemData(i, code, aitem);
              WearItemclass.wearFD.upitem(pswearitem^.rkey, aitem);
            end;
          witWearFDdel:
            begin
              WearItemclass.wearFD.del(pswearitem^.rkey);
            end;

          witWearUser:
            begin
              i := sizeof(TsWearItem);
              TWordComDataToTItemData(i, code, aitem);
              WearUserItemclass.wear.upitem(pswearitem^.rkey, aitem);
            end;
          witWeardelUser:
            begin
              WearUserItemclass.wear.del(pswearitem^.rkey);
            end;
          witWearFDUser:
            begin
              i := sizeof(TsWearItem);
              TWordComDataToTItemData(i, code, aitem);
              WearUserItemclass.wearFD.upitem(pswearitem^.rkey, aitem);
            end;
          witWearFDdelUser:
            begin
              WearUserItemclass.wearfd.del(pswearitem^.rkey);
            end;
        end;

      end;
    SM_MAGIC:
      begin
        psHaveMagic := @Code.Data;
        case pshaveMagic.rType of
          smt_ini:
            begin
              i := 2;
              astr := WordComData_GETStringPro(code, i);
              cMagicClass.loadfromDamage(astr);
              astr := WordComData_GETStringPro(code, i);
              cMagicClass.loadfromArmor(astr);

              INI_SKILL_DIV_DAMAGE := WordComData_GETdword(code, i);
              INI_SKILL_DIV_ARMOR := WordComData_GETdword(code, i);
              INI_SKILL_DIV_ATTACKSPEED := WordComData_GETdword(code, i);
              INI_SKILL_DIV_EVENT := WordComData_GETdword(code, i);

              INI_2SKILL_DIV_DAMAGE := WordComData_GETdword(code, i);
              INI_2SKILL_DIV_ARMOR := WordComData_GETdword(code, i);
              INI_2SKILL_DIV_ATTACKSPEED := WordComData_GETdword(code, i);
              INI_2SKILL_DIV_EVENT := WordComData_GETdword(code, i);
            end;
        end;

      end;
    SM_HAVEMAGIC:
      begin
        psHaveMagic := @Code.Data;
        case pshaveMagic.rType of
          smt_HaveRiseMagic:
            begin
              if pshaveMagic.rdel then
              begin
                HaveMagicClass.HaveRiseMagic.del(pshaveMagic.rkey);
              end
              else
              begin
                i := sizeof(TSHaveMagic);
                TWordComDataToTMagicData(i, code, amagic);
                HaveMagicClass.HaveRiseMagic.upitem(pshaveMagic.rkey, amagic);
              end;
            end;
          smt_HaveMysteryMagic:
            begin
              if pshaveMagic.rdel then
              begin
                HaveMagicClass.HaveMysteryMagic.del(pshaveMagic.rkey);
              end
              else
              begin
                i := sizeof(TSHaveMagic);
                TWordComDataToTMagicData(i, code, amagic);
                HaveMagicClass.HaveMysteryMagic.upitem(pshaveMagic.rkey, amagic);
              end;
            end;
          smt_DefaultMagic:
            begin
              if pshaveMagic.rdel then
              begin
                HaveMagicClass.DefaultMagic.del(pshaveMagic.rkey);
              end
              else
              begin
                i := sizeof(TSHaveMagic);
                TWordComDataToTMagicData(i, code, amagic);
                HaveMagicClass.DefaultMagic.upitem(pshaveMagic.rkey, amagic);
              end;
            end;
          smt_HaveMagic:
            begin
              if pshaveMagic.rdel then
              begin
                HaveMagicClass.HaveMagic.del(pshaveMagic.rkey);
              end
              else
              begin
                i := sizeof(TSHaveMagic);
                TWordComDataToTMagicData(i, code, amagic);
                HaveMagicClass.HaveMagic.upitem(pshaveMagic.rkey, amagic);
              end;
            end;
          smt_MagicAddExp:
            begin
              i := sizeof(TSHaveMagic);
              amagic.rID := WordComData_GETdword(code, i);
              amagic.rcSkillLevel := WordComData_GETdword(code, i);
              HaveMagicClass.addexp(amagic);
            end;
        end;

      end;
    SM_LifeData, SM_ATTRIB_UPDATE:
      begin
        cAttribClass.MessageProcess(code);
      end;
    SM_ATTRIBBASE:
      begin
        psAttribBase := @Code.Data;
        LbAge.Caption := Get10000To100(psAttribBase^.rAge);
        cAttribClass.MessageProcess(code);
      end;
    SM_OtherUserLifeData:
      begin
        cOtherUserAttribClass.MessageProcess(code);
      end;
    SM_OtherUserATTRIBBASE:
      begin
        cOtherUserAttribClass.MessageProcess(code);
      end;
    SM_ATTRIB_VALUES:
      begin
        cAttribClass.MessageProcess(code);
        psAttribValues := @Code.Data;
        with psAttribValues^ do
        begin
          LbLight.Caption := Get10000To100(rLight);
          LbDark.Caption := Get10000To100(rDark);
                    //               LbMagic.Caption := Get10000To100 (rMagic);
          LbTalent.Caption := Get10000To100(rTalent);
          LbGoodChar.Caption := Get10000To100(rGoodChar);
          LbBadChar.Caption := Get10000To100(rBadChar);
                    //               ListboxAttrib.Items.Add ('玫款 : ' + Get10000To100 (rLucky));
          LbAdaptive.Caption := Get10000To100(rAdaptive);
          LbRevival.Caption := Get10000To100(rRevival);
          LbImmunity.Caption := Get10000To100(rImmunity);
          LbVirtue.Caption := Get10000To100(rVirtue);

                    //               LbHealth.Caption := IntToStr (rhealth div 100);
                    //               LbPoisoning.Caption := IntToStr (rpoisoning div 100);
                    //               LbSatiety.Caption := IntToStr (rsatiety div 100);
          PgHead.Progress := rCurheadseak * 10000 div rHeadSeak;
          PgArm.Progress := rCurArmSeak * 10000 div rArmSeak;
          PgLeg.Progress := rCurLegSeak * 10000 div rLegSeak;
        end;
                //头手脚
      end;
    SM_ITEMDATA:
      begin
        psHaveItem := @Code.Data;
        with pshaveitem^ do
        begin
          if rdel then
          begin
            HaveItemclass.del(rkey);
          end
          else
          begin
            i := sizeof(tsHaveItem);
            TWordComDataToTItemData(i, code, aitem);

            G_BufferItemDataClass.add(aitem);

          end;
        end;
      end;
  end;
end;

function IsInArea(CharImage: TA2Image; ax, ay: integer): Boolean;
var
  xp, yp: integer;
  xx, yy: integer;
  pb: pword;
begin
  Result := TRUE;
  xx := CharImage.px + 28;
  yy := CharImage.py + 36;

  if (ax <= xx) then
    Result := FALSE;
  if (ay <= yy) then
    Result := FALSE;
  if ax >= xx + CharImage.Width then
    Result := FALSE;
  if ay >= yy + CharImage.Height then
    Result := FALSE;
  if Result = FALSE then
    exit;

  xp := ax - xx;
  yp := ay - yy;

  pb := PWORD(CharImage.bits);
  inc(pb, xp + yp * CharImage.Width);
  if pb^ = 0 then
    Result := FALSE;
end;

procedure TFrmAttrib.LbCharMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i, n: integer;
  CL: TCharClass;
  ImageLib: TA2ImageLib;
  aitem: titemdata;
begin
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then
    exit;

  n := 0;
  for i := 1 to 10 - 1 do
  begin
    ImageLib := Cl.GetArrImageLib(i, mmAnsTick);
    if ImageLib <> nil then
    begin
      if IsInArea(ImageLib.Images[57], x, y) then
        n := i;
    end;
  end;
  if n <> 0 then
  begin
    if cl.Feature.rboFashionable then
    begin
      aitem := WearItemclass.wearFD.get(n);
      MouseInfoStr := (aitem.rViewName);
    end
    else
    begin
      aitem := WearItemclass.wear.get(n);
      MouseInfoStr := (aitem.rViewName); //(WearStrings[n].;
    end;
  end;

  if SelWearItemIndex <> 0 then
    TA2ILabel(Sender).BeginDrag(TRUE);
end;

procedure TFrmAttrib.LbCharStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  DragItem.Selected := SelWearItemIndex;
  DragItem.Dragedid := 0;
  DragItem.SourceId := WINDOW_WEARS;
  DragObject := DragItem;
  SelWearItemIndex := 0;
end;

procedure TFrmAttrib.LbCharMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, n: integer;
  CL: TCharClass;
  ImageLib: TA2ImageLib;
begin

  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then
    exit;

  if Button = mbRight then
  begin

    frmCharAttrib.Visible := true;
    exit;
  end;
  n := 0;
  for i := 1 to 10 - 1 do
  begin
    ImageLib := Cl.GetArrImageLib(i, mmAnsTick);
    if ImageLib <> nil then
    begin
      if IsInArea(ImageLib.Images[57], x, y) then
        n := i;
    end;
  end;

  if cl.Feature.rboFashionable then
    SelWearItemIndex := n + 100
  else
    SelWearItemIndex := n;
end;

procedure TFrmAttrib.LbCharDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_ITEMS then
        Accept := TRUE;
    end;
  end;
end;

procedure TFrmAttrib.LbCharDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
begin

  if Source = nil then
    exit;

  with Source as TDragItem do
  begin
    if SourceID <> WINDOW_ITEMS then
      exit;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := DragedId;
    cDragDrop.rdestId := 0;
    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_WEARS;
    cDragDrop.rsourkey := Selected;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop);

        // if frmCharAttrib.Visible then frmCharAttrib.update;
  end;
end;

var
  OldFeature: TFeature;

procedure TFrmAttrib.DrawWearItem;
var
  i, gc, ga: integer;
  Cl: TCharClass;
  ImageLib: TA2ImageLib;
begin
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then
    exit;

  if not CompareMem(@OldFeature, @Cl.Feature, sizeof(TFeature)) then
  begin

    CharCenterImage.Clear(0);

    for i := 0 to 10 - 1 do
    begin
      ImageLib := Cl.GetArrImageLib(i, mmAnsTick);
      if ImageLib <> nil then
      begin
        GetGreenColorAndAdd(Cl.Feature.rArr[i * 2 + 1], gc, ga);
        if Cl.Feature.rArr[i * 2 + 1] = 0 then
          CharCenterImage.DrawImage(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, TRUE)
        else
                    //               CharCenterImage.DrawImageGreenConvert (ImageLib.Images[105], ImageLib.Images[105].px+28, ImageLib.Images[105].py+36, ColorIndex[Cl.Feature.rArr[i*2+1]], 0);
          CharCenterImage.DrawImageGreenConvert(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, gc, ga);
      end;
    end;
    OldFeature := Cl.Feature;
    LbChar.A2Image := CharCenterImage;
  end;
end;
{
function TFrmAttrib.isILabels_item(id:integer):boolean;
var
    tt              :pTSHaveItem;
begin
    result := false;
    //限制 虚拟 物品
    tt := getid(id);
    if tt = nil then exit;
    if tt.rCount <= 0 then exit;

    result := true;
end;
}

procedure TFrmAttrib.sendDblClickItemString(akey: integer; astr: string);
var
  cClick: TCClick;
  tempitem: TItemData;
  tempsend: TWordComData;
begin
  tempitem := HaveItemclass.get(akey);
  if tempitem.rName = '' then
    exit;
  if tempitem.rKind <> ITEM_KIND_ScripterSay then
    exit;

  cClick.rmsg := CM_DBLCLICK;
  cClick.rwindow := WINDOW_ITEMS;
  cClick.rclickedId := 0;
  cClick.rShift := KeyShift;
  cClick.rkey := akey;
  tempsend.Size := sizeof(TCClick);
  copymemory(@tempsend.data, @cClick, sizeof(TCClick));
  WordComData_ADDString(tempsend, astr);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TFrmAttrib.sendDblClickItemStringEx(akey: integer; astr: string;
  aSayItem: TCSayItem);
var
  cClick: TCClickChatItem;
  tempitem: TItemData;
  tempsend: TWordComData;
begin
  tempitem := HaveItemclass.get(akey);
  if tempitem.rName = '' then exit;
  if tempitem.rKind <> ITEM_KIND_ScripterSay then exit;

  cClick.rmsg := CM_DBLCLICKSAYITEM;
  cClick.rwindow := WINDOW_ITEMS;
  cClick.rclickedId := 0;
  cClick.rShift := KeyShift;
  cClick.rkey := akey;
  copymemory(@cClick.rSayItem, @aSayItem, sizeof(TCSayItem));
  tempsend.Size := sizeof(TCClickChatItem) - -sizeof(TWordString) + SizeOfWordString(aSayItem.rWordString); ;
  copymemory(@tempsend.data, @cClick, sizeof(TCClickChatItem));
  WordComData_ADDString(tempsend, astr);
  Frmfbl.SocketAddDataEx(tempsend.Size, @tempsend.data);
end;

procedure TFrmAttrib.ItemLabelDblClick(Sender: TObject);
var
  cClick: TCClick;
  tempitem: TItemData;
  frmConfirmDialog: TfrmConfirmDialog;
begin
  if frmNPCTrade.Visible and (frmNPCTrade.Visiblestate = 3) then
  begin
    if Sender is TA2ILabel then
    begin
      DragItem.Selected := TA2ILabel(Sender).Tag;
      DragItem.SourceId := WINDOW_ITEMS;
      DragItem.Dragedid := 0;
      DragItem.sx := 0;
      DragItem.sy := 0;
            // DragObject := DragItem;
      frmNPCTrade.listContentDragDrop(Sender, DragItem, 0, 0);
    end;
  end
  else
  begin
        //  if not isILabels_item(TA2ILabel(Sender).tag) then exit;
    tempitem := HaveItemclass.get(TA2ILabel(Sender).tag);
    if tempitem.rName = '' then
      exit;
    //道具 输入 窗口
    if tempitem.rKind = ITEM_KIND_ScripterSay then
    begin
      //检测是喇叭就退出
      if (tempitem.rName = '低级喇叭') or (tempitem.rName = '中级喇叭') or (tempitem.rName = '高级喇叭') then exit;
            //创建 输入 窗口
      frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
      frmConfirmDialog.Fkey := TA2ILabel(Sender).tag;
      frmConfirmDialog.ShowFrom(cdtItemStirng, '请输入文字', '');
      exit;
    end;
        //未做限制 发送间隔 时间
    cClick.rmsg := CM_DBLCLICK;
    cClick.rwindow := WINDOW_ITEMS;
    cClick.rclickedId := 0;
    cClick.rShift := KeyShift;
    cClick.rkey := TA2ILabel(Sender).tag;
    Frmfbl.SocketAddData(sizeof(cClick), @cClick);

  end;
end;

procedure TFrmAttrib.ItemLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
begin
  if Source = nil then
    exit;
  with Source as TDragItem do
  begin
    case SourceID of
      WINDOW_ITEMLOG:
        begin

          FrmDepository.showinputCountOUt(DragItem.Selected, TA2ILabel(Sender).tag, 1, FrmDepository.get(DragItem.Selected).rCount, FrmDepository.get(DragItem.Selected).rViewName);
          exit;
        end;
      WINDOW_ITEMS, WINDOW_WEARS, WINDOW_SCREEN:
        ;
    else
      exit;
    end;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := Dragedid;
    cDragDrop.rdestId := 0;
    cDragDrop.rsx := sx;
    cDragDrop.rsy := sy;
    cDragDrop.rdx := 0;
    cDragDrop.rdy := 0;
    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_ITEMS;
    case SourceId of
      WINDOW_ITEMS:
        cDragDrop.rsourkey := Selected;
      WINDOW_WEARS:
        cDragDrop.rsourkey := Selected;
    end;
    cDragDrop.rsourkey := Selected;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop); // server r
  end;
end;

{
procedure TFrmAttrib.CheckattribDragDropItem(aname: string; aCount: integer);
var
   i, iCount : integer;
begin
   if (aname = '') or (aCount = 0) then exit;
   iCount := AttribitemData[FrmDepository.DepitemData[DragDropSelectNum].mempos].itemCount;
   if FrmDepository.DepitemData[DragDropSelectNum].mempos <> SelectItem then
      SelectItem := FrmDepository.DepitemData[DragDropSelectNum].mempos;

   if FrmDepository.DepitemData[DragDropSelectNum].memPos = -1 then begin
      if AttribItemData[SelectItem].ItemName <> '' then begin
         for i := 0 to AttribItemMaxCount - 1 do begin
            if AttribitemData[i].ItemName = '' then SelectItem := i;
         end;
      end;
   end;

   if FrmDepository.DepitemData[DragDropSelectNum].ItemCount >= aCount then
      AttribitemData[SelectItem].ItemCount := iCount + aCount
   else begin
      DragDropSelectNum := -1;
      SelectItem := -1;
      exit;
   end;

   if FrmDepository.DepitemData[DragDropSelectNum].ItemName = aname then
      AttribitemData[SelectItem].ItemName := aname
   else begin
      DragDropSelectNum := -1;
      SelectItem := -1;
      exit;
   end;
   AttribitemData[SelectItem].ItemShape := FrmDepository.DepitemData[DragDropSelectNum].ItemShape;
   AttribitemData[SelectItem].ItemColor := FrmDepository.DepitemData[DragDropSelectNum].ItemColor;
   AttribitemData[SelectItem].memPos := DragDropSelectNum;

   SetItemLabel (ILabels[SelectItem], FrmDepository.DepitemData[DragDropSelectNum].ItemName, FrmDepository.DepitemData[DragDropSelectNum].ItemColor, FrmDepository.DepitemData[DragDropSelectNum].ItemShape);
   FrmDepository.ItemClear(aName, aCount,DragDropSelectNum);
   DragDropSelectNum := -1;
   SelectItem := -1;
end;
}

procedure TFrmAttrib.A2ILabel0DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_ITEMS then
        Accept := TRUE;
      if SourceID = WINDOW_WEARS then
        Accept := TRUE;
      if SourceID = WINDOW_SCREEN then
        Accept := TRUE;
      if SourceID = WINDOW_ITEMLOG then
        Accept := TRUE;
    end;
  end;
end;

procedure TFrmAttrib.A2hintTMagicData(aitem: TMagicData);
begin

  FITEMA2Hint.FVisible := false;
  if aitem.rname <> '' then
  begin
    FITEMA2Hint.Ftype := hstTransparent;
    FITEMA2Hint.FVisible := TRUE;
    FITEMA2Hint.setText(TMagicDataToStr(aitem));
    FITEMA2Hint.Fleft := fwide - 180 - FITEMA2Hint.Fback.Width - 8;
    FITEMA2Hint.Ftop := 140;
  end;
end;

procedure TFrmAttrib.A2hint(aitem: TItemData);
begin

  FITEMA2Hint.FVisible := false;
  if aitem.rViewName <> '' then
  begin
    FITEMA2Hint.Ftype := hstTransparent;
    FITEMA2Hint.FVisible := TRUE;
    FITEMA2Hint.setText(TItemDataToStr(aitem));
    FITEMA2Hint.Fleft := fwide - 180 - FITEMA2Hint.Fback.Width - 8;
    FITEMA2Hint.Ftop := 140;
  end;
end;

procedure TFrmAttrib.ItemLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Temp: TA2ILabel;
begin
    //    SelectedItemLabel := Ta2ILabel(Sender);
  Temp := Ta2ILabel(Sender);
  if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
  begin
    if temp.A2Image <> nil then
      Temp.BeginDrag(TRUE);
    FITEMA2Hint.FVisible := false;
    exit;
  end;
  MouseInfoStr := TA2ILabel(Sender).Hint;
  A2hint(HaveItemclass.get(TA2ILabel(Sender).Tag));
end;

procedure TFrmAttrib.ItemLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
        //        if not isILabels_item(TA2ILabel(Sender).tag) then exit;
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_ITEMS;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmAttrib.MLabelDblClick(Sender: TObject);
begin
  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);

  GrobalClick.rmsg := CM_DBLCLICK;
  GrobalClick.rwindow := WINDOW_MAGICS;
  GrobalClick.rclickedId := 0;
  GrobalClick.rShift := KeyShift;
  GrobalClick.rkey := TA2ILabel(Sender).tag;
end;

procedure TFrmAttrib.MLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
begin
  if Source = nil then
    exit;

  with Source as TDragItem do
  begin
    case SourceID of
      WINDOW_MAGICS:
        ;
    else
      exit;
    end;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := Dragedid;
    cDragDrop.rdestId := 0;
    cDragDrop.rsx := sx;
    cDragDrop.rsy := sy;
    cDragDrop.rdx := 0;
    cDragDrop.rdy := 0;
    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_MAGICS;
    case SourceId of
      WINDOW_MAGICS:
        cDragDrop.rsourkey := Selected;
    end;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  end;
end;

procedure TFrmAttrib.MLabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_MAGICS then
        Accept := TRUE;
    end;
  end;
end;

procedure TFrmAttrib.MLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  per: integer;
  tt: TGET_cmd;
  cnt: integer;
begin
  if Button = mbRight then
  begin
        { tt.rmsg := CM_itempro;
         tt.rKEY := itemproGET_Magic;
         tt.rKEY2 := TA2ILabel(Sender).Tag;
         frmItemHelpitemPro_KEY := TA2ILabel(Sender).Tag;
         cnt := sizeof(TT);
         Frmfbl.SocketAddData(cnt, @TT);
         exit;
         }
  end;

  if x < 31 then
    exit;
  if y > 35 then
    y := 35;
  per := (35 - y) div 3;

  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);

  GrobalClick.rmsg := CM_CLICKPERCENT;
  GrobalClick.rwindow := WINDOW_MAGICS;
  GrobalClick.rclickedId := per;
  GrobalClick.rShift := KeyShift;
  GrobalClick.rkey := TA2ILabel(Sender).Tag;
end;

procedure TFrmAttrib.MLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Temp: TA2ILabel;
begin
  Last_X := X;
  SelectedMagicLabel := TA2ILabel(Sender);
  Temp := TA2ILabel(Sender);
  if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
  begin
    if temp.A2Image <> nil then
      Temp.BeginDrag(TRUE);
  end;
  MouseInfoStr := TA2ILabel(Sender).Hint;

  KeySelmagicIndex := -1;
  if temp.Hint <> '' then
  begin
    KeySelmagicIndex := TA2ILabel(Sender).Tag + 30; //移动到谁上面，就用谁的tag+30
    savekeyBool := TRUE;
  end;
  A2hintTMagicData(HaveMagicClass.HaveMagic.get(TA2ILabel(Sender).Tag));
end;

procedure TFrmAttrib.MLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_MAGICS;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmAttrib.BLabel0DblClick(Sender: TObject);
begin
  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);

  GrobalClick.rmsg := CM_DBLCLICK;
  GrobalClick.rwindow := WINDOW_BASICFIGHT;
  GrobalClick.rclickedId := 0;
  GrobalClick.rShift := KeyShift;
  GrobalClick.rkey := TA2ILabel(Sender).Tag;
end;

procedure TFrmAttrib.BLabel0MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Temp: TA2ILabel;
begin
  Last_X := X;
  SelectedMagicLabel := TA2ILabel(Sender);
  Temp := TA2ILabel(Sender);
  if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
  begin
    if temp.A2Image <> nil then
      Temp.BeginDrag(TRUE);
  end;
  MouseInfoStr := TA2ILabel(Sender).Hint;

  KeySelmagicIndex := -1;
  if temp.Hint <> '' then
  begin
    KeySelmagicIndex := TA2ILabel(Sender).Tag; //blabel直接等于tag
    savekeyBool := TRUE;
  end;
  A2hintTMagicData(HaveMagicClass.DefaultMagic.get(TA2ILabel(Sender).Tag));

end;

procedure TFrmAttrib.FormShow(Sender: TObject);
begin
  BackScreen.SWidth := fwide - 192;
    // BackScreen.SHeight := fheight - 117;
     //   FrmM.DXTimerTimer(Self, 0);
end;

procedure TFrmAttrib.FormHide(Sender: TObject);
begin
  BackScreen.SWidth := fwide;
    //BackScreen.SHeight := fheight - 117;
    //   FrmM.DXTimerTimer(Self, 0);
end;

procedure TFrmAttrib.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  MouseInfoStr := '';
  FITEMA2Hint.FVisible := false;
end;

procedure TFrmAttrib.BLabel0StartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_BASICFIGHT;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmAttrib.LbSkill0Click(Sender: TObject);
begin
    //
end;

procedure TFrmAttrib.LbSkill0DblClick(Sender: TObject);
begin
    //
end;

procedure TFrmAttrib.LbSkill0MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  LbWindowName.Caption := TLabel(Sender).Hint;
end;

procedure TFrmAttrib.LbSkill4Click(Sender: TObject);
begin
    //   Frmdyeing.Visible := not Frmdyeing.Visible;
end;

procedure TFrmAttrib.PaneClose(aname: string);
begin
  aname := UpperCase(aname);
  PanelItem.Visible := aname = UpperCase('PanelItem');
  PanelMagic.Visible := aname = UpperCase('PanelMagic');
  PanelAttrib.Visible := aname = UpperCase('PanelAttrib');
  PanelBasic.Visible := aname = UpperCase('PanelBasic');
  PanelSkill.Visible := aname = UpperCase('PanelSkill');
  PanelHailFellow.Visible := aname = UpperCase('PanelHailFellow');
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmAttrib.BLabel0Click(Sender: TObject);
begin
    //   GrobalClick : TCClick;
    //   ClickTick : integer = 0;
    //   savekeyBool := TRUE;
  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);

  GrobalClick.rmsg := CM_CLICK;
  GrobalClick.rwindow := WINDOW_BASICFIGHT;
  GrobalClick.rclickedId := 0;
  GrobalClick.rShift := KeyShift;
  GrobalClick.rkey := TA2ILabel(Sender).Tag;

    //
 //   if FrmBottom.Visible then FrmBottom.FocusControl (FrmBottom.EdChat);
end;

procedure TFrmAttrib.MLabel0Click(Sender: TObject);
begin
    //   savekeyBool := TRUE;
    {ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_CLICK;
    GrobalClick.rwindow := WINDOW_MAGICS;
    GrobalClick.rclickedId := 0;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).Tag;
    }
    //   if FrmBottom.Visible then FrmBottom.FocusControl (FrmBottom.EdChat);
end;

procedure TFrmAttrib.A2ILabel26Click(Sender: TObject);
begin
    //    if not isILabels_item(TA2ILabel(Sender).tag) then exit;

  {  ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_CLICK;
    GrobalClick.rwindow := WINDOW_ITEMS;
    GrobalClick.rclickedId := 0;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).Tag;
   }
end;

procedure TFrmAttrib.A2ILabel0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tt: TGET_cmd;
  cnt: integer;
begin
  FITEMA2Hint.FVisible := false;
  if Button = mbRight then
  begin
    frmItemHelp.ShowProItem(TA2ILabel(Sender).Tag);
  end;
end;

//设置

{procedure TFrmAttrib.keysetImg(savekey, KeyIndex: integer);
var
    i: integer;
    idx, ID: integer;
begin
    //    if KeyIndex = 255 then KeyIndex := -1;
    case savekey of
        0..7:
            begin
                id := savekey;
                idx := savekey + 10;
            end;
    else exit;
    end;
    //删除 原来
    if BasicBufferkey[id] <> 255 then
    begin
        case BasicBufferkey[id] of
            0..29:
                begin
                    BLabels[BasicBufferkey[id]].A2ImageLUP := nil;
                    FrmNewMagic.onKEYF5_f8Default(BasicBufferkey[id], nil);
                end;
            30..59:
                begin
                    MLabels[BasicBufferkey[id] - 30].A2ImageLUP := nil;
                    FrmNewMagic.onKEYF5_f8HaveMagic(BasicBufferkey[id] - 30, nil);
                end;
            60..89:
                begin
                    ILabels[BasicBufferkey[id] - 60].A2ImageLUP := nil;
                    FrmWearItem.onKEYF5_f8Item(BasicBufferkey[id] - 60, nil);
                end;

        else exit;
        end;
    end;

    if (BasicBufferkey[id] = KeyIndex) then
    begin                                                                       //取消
        // BasicBufferkey[id] := -1;
    end else
    begin                                                                       //增加
        BasicBufferkey[id] := KeyIndex;
        if BasicBufferkey[id] <> 255 then
            case BasicBufferkey[id] of
                0..29:
                    begin
                        BLabels[BasicBufferkey[id]].A2ImageLUP := savekeyImagelib[idx];
                        FrmNewMagic.onKEYF5_f8Default(BasicBufferkey[id], savekeyImagelib[idx]);
                    end;
                30..59:
                    begin
                        MLabels[BasicBufferkey[id] - 30].A2ImageLUP := savekeyImagelib[idx];
                        FrmNewMagic.onKEYF5_f8HaveMagic(BasicBufferkey[id] - 30, savekeyImagelib[idx]);
                    end;
                60..89:
                    begin
                        ILabels[BasicBufferkey[id] - 60].A2ImageLUP := savekeyImagelib[idx];
                        FrmWearItem.onKEYF5_f8Item(BasicBufferkey[id] - 60, savekeyImagelib[idx]);
                    end;
            end;
    end;

end;
}
{
procedure TFrmAttrib.KeyGetAll();
var
    tt: TGET_cmd;
    cnt: integer;
begin

    tt.rmsg := CM_GET;
    tt.rKEY := Get_KEYf5f12;
    cnt := sizeof(TT);
    Frmfbl.SocketAddData(cnt, @TT);
end;
}
//删除
{
procedure TFrmAttrib.keyDel(Keyindex, ItemIndex: integer);
var
    id: integer;

begin
    //DEL 物品 原 KEY
    for id := 0 to high(BasicBufferkey) do
    begin
        if BasicBufferkey[id] = ItemIndex then
        begin

            //物品 图象
            case BasicBufferkey[id] of
                0..29:
                    begin
                        BLabels[BasicBufferkey[id]].A2ImageLUP := nil;
                        FrmNewMagic.onKEYF5_f8Default(BasicBufferkey[id], nil);
                    end;
                30..59:
                    begin
                        MLabels[BasicBufferkey[id] - 30].A2ImageLUP := nil;
                        FrmNewMagic.onKEYF5_f8HaveMagic(BasicBufferkey[id] - 30, nil);
                    end;
                60..89:
                    begin
                        ILabels[BasicBufferkey[id] - 60].A2ImageLUP := nil;
                        FrmWearItem.onKEYF5_f8Item(BasicBufferkey[id] - 60, nil);
                    end;

            end;
            //删除对应 关系
            BasicBufferkey[id] := 255;

        end;

    end;
    //热键 DEL
    if BasicBufferkey[Keyindex] <> 255 then
    begin
        //物品 图象
        case BasicBufferkey[Keyindex] of
            0..29:
                begin
                    BLabels[BasicBufferkey[Keyindex]].A2ImageLUP := nil;
                    FrmNewMagic.onKEYF5_f8Default(BasicBufferkey[Keyindex], nil);
                end;
            30..59:
                begin
                    MLabels[BasicBufferkey[Keyindex] - 30].A2ImageLUP := nil;
                    FrmNewMagic.onKEYF5_f8HaveMagic(BasicBufferkey[Keyindex] - 30, nil);
                end;
            60..89:
                begin
                    ILabels[BasicBufferkey[Keyindex] - 60].A2ImageLUP := nil;
                    FrmWearItem.onKEYF5_f8Item(BasicBufferkey[Keyindex] - 60, nil);
                end;

        end;

        //对应 关系
        BasicBufferkey[Keyindex] := 255;
    end;

end;
 }
{procedure TFrmAttrib.keysetsave(Keyindex, ItemIndex: integer);
var
    tt: tskey;
    cnt: integer;
    skey, i: integer;
begin
    // if KeyIndex = 255 then KeyIndex := -1;
    case Keyindex of
        0..7:
            begin

            end;
    else exit;
    end;
    case ItemIndex of
        0..29: ;
        30..59: ;
        60..89: ;
    else exit;
    end;
    keyDel(KeyIndex, ItemIndex);

    keysetImg(KeyIndex, ItemIndex);
    // BasicBufferkey[KeyIndex] := ItemIndex;
    // if BasicBufferkey[KeyIndex] <> -1 then

end;
 }

procedure TFrmAttrib.keysaveaction(id: integer);
var
  p: pTKeyClassData;
begin
  if keyselmagicindexadd <> -1 then
  begin
    if (((PanelItem.Visible or PanelMagic.Visible or PanelBasic.Visible) and FrmAttrib.Visible) = false) and (FrmNewMagic.Visible = false) and (FrmWearItem.Visible = false) then
      exit;
    if keyselmagicindexadd = -1 then
      exit;
    case keyselmagicindexadd of
      0..29:
        cF5_F12Class.UPdate(id, kcdt_F5_f12, kcdk_BasicMagic, keyselmagicindexadd); //basic的
      30..89:
        cF5_F12Class.UPdate(id, kcdt_F5_f12, kcdk_HaveMagic, keyselmagicindexadd - 30); //添加的mlabel的
      90..119:
        cF5_F12Class.UPdate(id, kcdt_F5_f12, kcdk_HaveItem, keyselmagicindexadd - 90); //物品的
      120..179:
        cF5_F12Class.UPdate(id, kcdt_F5_f12, kcdk_HaveRiseMagic, keyselmagicindexadd - 120);
      180..239:
        cF5_F12Class.UPdate(id, kcdt_F5_f12, kcdk_HaveMysteryMagic, keyselmagicindexadd - 180);

         //   150..179: cF5_F12Class.UPdate(id, kcdt_F5_f12, kcdk_HaveItem, keyselmagicindexadd - 150);   //物品的
    end;
//        keysetsave(id, keyselmagicindexadd);
  end
  else
  begin
    p := cF5_F12Class.get(id);
    if p = nil then
      exit;
    if p.rboUser = false then
      exit;
    if (p.rkey < 0) or (p.rkey > 60) then
      exit;
    xtag := p.rkey;
    case p.rkeyType of
      kcdk_BasicMagic:
        FrmNewMagic.BLabels[p.rkey].OnDblClick(BLabels[p.rkey]);
      kcdk_HaveMagic:
        FrmNewMagic.MLabels[p.rkey].OnDblClick(MLabels[p.rkey]);
      kcdk_HaveItem:
        FrmWearItem.ILabels[p.rkey].OnDblClick(ILabels[p.rkey]);
      kcdk_HaveRiseMagic:
        FrmNewMagic.RiseLabels[p.rkey].OnDblClick(MLabels[p.rkey]);
      kcdk_HaveMysteryMagic:
        FrmNewMagic.MysteryLabels[p.rkey].OnDblClick(MLabels[p.rkey]);
    end;
    xtag := -1;
  end;
  FrmBottom.saveAllKey;  //2015.12.15 在水一方 玩家设置完快捷键后及时的自动保存
end;

procedure TFrmAttrib.BLabel0MouseLeave(Sender: TObject);
begin
  keyselmagicindexadd := -1;
end;

procedure TFrmAttrib.BLabel0MouseEnter(Sender: TObject);
begin
  keyselmagicindexadd := TA2ILabel(Sender).Tag; //blabel果然不加
end;

procedure TFrmAttrib.A2ILabel0MouseEnter(Sender: TObject);
begin
  keyselmagicindexadd := TA2ILabel(Sender).Tag + 90; //A2lebel+60的   改成90的
  FITEMA2Hint.FVisible := false;
end;

procedure TFrmAttrib.A2ILabel0MouseLeave(Sender: TObject);
begin
  keyselmagicindexadd := -1;
  FITEMA2Hint.FVisible := false;
end;

procedure TFrmAttrib.MLabel0MouseEnter(Sender: TObject);
begin
  keyselmagicindexadd := TA2ILabel(Sender).Tag + 30; //Mlabel indexadd 这里是+30
end;

procedure TFrmAttrib.MLabel0MouseLeave(Sender: TObject);
begin
  keyselmagicindexadd := -1;
end;

function TFrmAttrib.getkeyadd(id: integer): TA2ILabel;
begin
  result := nil;
  case id of
    0..29:
      result := FrmNewMagic.BLabels[id]; //blabel不加
    30..89:
      result := FrmNewMagic.MLabels[id - 30]; //mlabel+30
    90..119:
      result := FrmWearItem.ILabels[id - 90]; //alabel+90
    120..179:
      result := FrmNewMagic.RiseLabels[id - 120];
    180..239:
      result := FrmNewMagic.MysteryLabels[id - 180];
      //  150..179: result := FrmWearItem.ILabels[id - 150];      //alabel+60
  end;
end;

procedure TFrmAttrib.BLabel0MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tt: TGET_cmd;
  cnt: integer;
begin
  if Button = mbRight then
  begin
        { tt.rmsg := CM_itempro;
         tt.rKEY := itemproGET_MagicBasic;
         tt.rKEY2 := TA2ILabel(Sender).Tag;
         frmItemHelpitemPro_KEY := TA2ILabel(Sender).Tag;
         cnt := sizeof(TT);
         Frmfbl.SocketAddData(cnt, @TT);
         }
  end;
end;

procedure TFrmAttrib.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  MouseInfoStr := '';
end;

procedure TFrmAttrib.HailFellowbtaddClick(Sender: TObject);
begin
  HailFellowUserName.Text := trim(HailFellowUserName.Text);
  if HailFellowUserName.Text = '' then
    exit;
  sendHailFellowAdd(HailFellowUserName.Text);

  HailFellowUserName.Text := '';
end;

procedure TFrmAttrib.sendHailFellowAdd(aname: string);
var
  tt: TSHailFellowbasic;
  cnt: integer;
begin
  if aname = '' then
    exit;
  tt.rmsg := CM_HailFellow;
  tt.rKEY := HailFellow_ADD;
  TT.rName := aname;
  cnt := sizeof(TT);
  Frmfbl.SocketAddData(cnt, @TT);
  FrmBottom.AddChat(format('邀请[%s]加好友,等待对方应答!！', [aname]), WinRGB(22, 22, 0), 0);
  SAY_EdChatFrmBottomSetFocus;
end;

procedure dxGaugePaint(aAnsImage: TA2Image; aPleft, aPtop: integer; tempGauge: tGauge);
var
  R, r2: TRect;
  xx, yy: integer;
  Can: TCanvas;
  fWidth, x, y: integer;
  BaseImage, tempA2image: TA2Image;
begin

  BaseImage := TA2Image.Create(tempGauge.Width, tempGauge.Height, 0, 0);
  try
    BaseImage.Resize(tempGauge.Width, tempGauge.Height);
    BaseImage.Clear(ColorSysToDxColor(tempGauge.BackColor));

    fWidth := trunc(tempGauge.Width * (tempGauge.Progress / (tempGauge.MaxValue - tempGauge.MinValue)));
    tempA2image := TA2Image.Create(fWidth, tempGauge.Height, 0, 0);

    try
      tempA2image.Resize(fWidth, tempGauge.Height);
      tempA2image.Clear(ColorSysToDxColor(tempGauge.ForeColor));
      x := tempGauge.Width - fWidth;
      x := tempGauge.Left + x;
      y := tempGauge.Top;
      BaseImage.DrawImage(tempA2image, 0, 0, false);
      aAnsImage.DrawImage(BaseImage, aPleft + tempGauge.Left, aPtop + tempGauge.Top, false);

    finally
      tempA2image.Free;
    end;
  finally
    BaseImage.Free;
  end;
end;

procedure TFrmAttrib.A2FormAdxPaint(aAnsImage: TA2Image);
begin
    //
   { dxGaugePaint(aAnsImage, 0, 0, PgHead);
    dxGaugePaint(aAnsImage, 0, 0, PGArm);
    dxGaugePaint(aAnsImage, 0, 0, PGLeg);
 }
end;

procedure TFrmAttrib.FormPaint(Sender: TObject);
begin
    //
  FrmAttribFormPaint := true;
end;

procedure TFrmAttrib.listContentKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SAY_EdChatFrmBottomSetFocus
end;

procedure TFrmAttrib.A2ILabel0MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FITEMA2Hint.FVisible := false;
end;

procedure TFrmAttrib.btnBasicMagicTabClick(Sender: TObject);
begin
  savekeyBool := FALSE; // FAttrib狼 savekey 阜澜
  FrmAttrib.LbWindowName.Caption := ('基本武功');
  FrmAttrib.LbMoney.Caption := ('基本武功');
  magicState(true);
  btnBasicMagicTab.Lockdown(true);
  if FrmAttrib.PanelBasic.Visible then
    exit;
  FrmAttrib.PaneClose('PanelBasic');
    // FrmAttrib.PanelBasic.Visible := TRUE;
end;

procedure TFrmAttrib.btnMagicTabClick(Sender: TObject);
begin
  savekeyBool := FALSE; // FAttrib狼 savekey 阜澜
  FrmAttrib.LbWindowName.Caption := ('武功');
  FrmAttrib.LbMoney.Caption := ('武功');
  if FrmAttrib.PanelMagic.Visible then
    exit;
  magicState(true);
  btnMagicTab.Lockdown(true);
  FrmAttrib.PaneClose('PanelMagic');
    //    FrmAttrib.PanelMagic.Visible := TRUE;
end;

procedure TFrmAttrib.magicState(abool: boolean);
begin
  btnMagicTab.Visible := abool;
  btnRiseMagicTab.Visible := abool;
  btnBasicMagicTab.Visible := abool;
  btnRiseMagicTab.Lockdown(false);
  btnMagicTab.Lockdown(false);
  btnBasicMagicTab.Lockdown(false);
end;

{ TItemTextClass }

procedure TcItemTextClass.add(var aitem: TitemTextdata);
var
  p: pTitemTextdata;
begin
  if get(aitem.rname) <> nil then
    exit;
  new(p);

  p^ := aitem;
  DataList.Add(p);
  NameIndex.Insert(P.rname, p);
end;

procedure TcItemTextClass.addText(aname, aitemtext: string);
var
  aitem: TitemTextdata;
begin
  aitem.rname := copy(aname, 1, 64);
  aitem.rdesc := copy(aitemtext, 1, 255);
  add(aitem);
end;

procedure TcItemTextClass.clear;
var
  i: integer;
  p: pTitemTextdata;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
  NameIndex.Clear;
end;

constructor TcItemTextClass.Create;
begin
  DataList := TList.Create;
  NameIndex := TStringKeyClass.Create;
end;

destructor TcItemTextClass.Destroy;
begin
  clear;
  DataList.free;
  NameIndex.free;

  inherited;
end;

function TcItemTextClass.get(aname: string): pTitemTextdata;
begin
  result := NameIndex.Select(aname);
end;

function TcItemTextClass.getText(aname: string): string;
var
  p: pTitemTextdata;
  str: string;
  i: integer;
begin
  result := '';
  p := get(aname);
  if p = nil then
    exit;
  str := p.rdesc;
  for i := 1 to length(str) do
  begin
    if str[i] = '^' then
    begin
      Result := Result + #13#10 + '{2} ' + #13#10;
    end
    else
      Result := Result + str[i];
  end;

end;

function TItemDataToStr(aitem: TItemData): string;
var
  astr: string;
  i: integer;

  function _get(acolor: string; var rLifeData: TLifeData): string;
  begin
    result := '';
    if rLifeData.AttackSpeed <> 0 then
      result := result + acolor + format('    速度: %d', [-rLifeData.AttackSpeed]) + #13#10 + '{2} ' + #13#10;
    if rLifeData.recovery <> 0 then
      result := result + acolor + format('    恢复: %d', [-rLifeData.recovery]) + #13#10 + '{2} ' + #13#10;
   // if (rLifeData.AttackSpeed <> 0) or (rLifeData.recovery <> 0) then
   //   result := result + #13#10 + '{2} ' + #13#10;
    if rLifeData.accuracy <> 0 then
      result := result + acolor + format('    命中: %d', [rLifeData.accuracy]) + #13#10 + '{2} ' + #13#10;
    if rLifeData.avoid <> 0 then
      result := result + acolor + format('    躲闪: %d', [rLifeData.avoid]) + #13#10 + '{2} ' + #13#10;
   // if (rLifeData.accuracy <> 0) or (rLifeData.avoid <> 0) then
   //   result := result + #13#10 + '{2} ' + #13#10;

    if rLifeData.HitArmor <> 0 then
      result := result + acolor + format('    维持: %d', [rLifeData.HitArmor]) + #13#10 + '{2} ' + #13#10;

    if (rLifeData.damageBody <> 0) or (rLifeData.damageHead <> 0) or (rLifeData.damageArm <> 0) or (rLifeData.damageLeg <> 0) then
      result := result + acolor + format('    攻击: %d/%d/%d/%d', [rLifeData.damageBody, rLifeData.damageHead, rLifeData.damageArm, rLifeData.damageLeg]) + #13#10 + '{2} ' + #13#10;

    if (rLifeData.armorBody <> 0) or (rLifeData.armorHead <> 0) or (rLifeData.armorArm <> 0) or (rLifeData.armorLeg <> 0) then
      result := result + acolor + format('    防御: %d/%d/%d/%d', [rLifeData.armorBody, rLifeData.armorHead, rLifeData.armorArm, rLifeData.armorLeg]) + #13#10 + '{2} ' + #13#10;
    //    if (rLifeData.HitArmor <> 0) then
//    begin
//      result := result + acolor + '【维持】' + ' ';
//      if rLifeData.HitArmor <> 0 then result := result + format('+维持:%d', [rLifeData.HitArmor]) + ' ';
//      result := result + #13#10;
//    end;
//    if (rLifeData.avoid <> 0) or (rLifeData.recovery <> 0) or (rLifeData.accuracy <> 0) or (rLifeData.AttackSpeed <> 0) then
//    begin
//      result := result + acolor + '【特殊】' + ' ';
//      if (rLifeData.avoid <> 0) then result := result + format('+躲避:%d', [rLifeData.avoid]) + ' ';
//      if rLifeData.recovery <> 0 then result := result + format('+恢复:%d', [-rLifeData.recovery]) + ' ';
//      if rLifeData.accuracy <> 0 then result := result + format('+命中:%d', [rLifeData.accuracy]) + ' ';
//      if rLifeData.AttackSpeed <> 0 then result := result + format('+速度:%d', [-rLifeData.AttackSpeed]) + ' ';
//      result := result + #13#10;
//    end;

//      result := result + acolor + '【攻击】' + ' ';
//      if rLifeData.damageBody <> 0 then result := result + format('+身:%d', [rLifeData.damageBody]) + ' ';
//      if rLifeData.damageHead <> 0 then result := result + format('+头:%d', [rLifeData.damageHead]) + ' ';
//      if rLifeData.damageArm <> 0 then result := result + format('+手:%d', [rLifeData.damageArm]) + ' ';
//      if rLifeData.damageLeg <> 0 then result := result + format('+脚:%d', [rLifeData.damageLeg]) + ' ';
//      result := result + #13#10;
//
//      result := result + acolor + '【防御】' + ' ';
//      if rLifeData.armorBody <> 0 then result := result + format('+身:%d', [rLifeData.armorBody]) + ' ';
//      if rLifeData.armorHead <> 0 then result := result + format('+头:%d', [rLifeData.armorHead]) + ' ';
//      if rLifeData.armorArm <> 0 then result := result + format('+手:%d', [rLifeData.armorArm]) + ' ';
//      if rLifeData.armorLeg <> 0 then result := result + format('+脚:%d', [rLifeData.armorLeg]) + ' ';
//
//      result := result + #13#10;
  //  end;
  end;

begin //$001DF833  绿    $0005A0EB 金黄     $00B1753F 蓝    $001A4DFB 红
  result := '';
  with aitem do
  begin
    case rStarLevel of //20130717修改显示
         //   0: rNameColor:= clwhite;
      1:
        rNameColor := clGreen;
      2:
        rNameColor := clYellow;
      3:
        rNameColor := clRed;
    end;

    if rNameColor > 0 then
      result := result + '<' + inttostr(rNameColor) + '>';

    case rStarLevel of //20130717修改显示
       // 0:Result:=result+'粗糙的';
      1:
        result := result + '粗糙的';
      2:
        result := result + '精致的';
      3:
        result := result + '完美的';
    end;

        //for i := 1 to rStarLevel do result := result + '☆';
    case rSex of
      1:
        result := result + format('%s(%s)', [rViewName, '男']);
      2:
        result := result + format('%s(%s)', [rViewName, '女']);
    else
      result := result + format('%s', [rViewName]);
    end;
    if rSetting.rsettingcount > 0 then
      result := result + format('<$0023A4FA>(%d孔)', [rSetting.rsettingcount]);
//    if rSmithingLevel > 0 then
//      result := result + format('<$0023A4FA> +%d', [rSmithingLevel]); //format('<$0023A4FA>+%d', [rSmithingLevel]);
    result := result + #13#10 + '{2} ' + #13#10;

    if rcreatename <> '' then
      result := result + '<$FF8000>〖' + rcreatename + '〗制造' + #13#10 + '{2} ' + #13#10;

    astr := _get('', rLifeDataBasic);
    if astr <> '' then
      result := result + '<$0000F1FF>基础属性:' + #13#10 + '{2} ' + #13#10 + astr;


    astr := _get('', rLifeDataLevel);
    if astr <> '' then
      result := result + '<$0000F1FF>强化属性:' + format(' <$00EEEEEE>%d级', [rSmithingLevel]) + #13#10 + '{2} ' + #13#10 + astr;
    astr := _get('<$001A4DFB>', rLifeDataAttach);
    if astr <> '' then
      result := result + '<$001DF833>附加属性:' + #13#10 + '{2} ' + #13#10 + astr;
    astr := _get('<$00F7A61E>', rLifeDataSetting);
    if astr <> '' then
      result := result + '<$00F7A61E>镶嵌属性:' + #13#10 + '{2} ' + #13#10 + astr;

    if cItemTextClass.getText(rName) <> '' then
      result := result + '<$0000F1FF>物品说明: <$00EEEEEE>' + cItemTextClass.getText(rName) + #13#10 + '{2} ' + #13#10;

    if rKind = ITEM_KIND_QUEST then
      result := result + '<$001A4DFB>任务物品' + #13#10 + '{2} ' + #13#10;
    //交易状态
    if rboNotExchange then
      result := result + '<$001A4DFB>不可交易' + #13#10 + '{2} ' + #13#10; //新开关 NPC交易
    //出售状态
    if rboNotTrade then
      result := result + '<$001A4DFB>不可出售' + #13#10 + '{2} ' + #13#10; //新开关 NPC交易
    if rboNotDrop then
      result := result + '<$001A4DFB>不可丢弃' + #13#10 + '{2} ' + #13#10;
    if rboNotSSamzie then
      result := result + '<$001A4DFB>不可寄存' + #13#10 + '{2} ' + #13#10;
    if rboDurability then
      if rboNOTRepair then
        result := result + '<$001A4DFB>不可维修' + #13#10 + '{2} ' + #13#10;
    if rboColoring then
      result := result + '<$001A4DFB>允许染色' + #13#10 + '{2} ' + #13#10;
    if rboTimeMode then
      result := result + '<$001A4DFB>有效时间:' + datetimetostr(rDateTime) + #13#10 + '{2} ' + #13#10;

//    if rGrade > 0 then result := result + format('品阶:%d', [rGrade]) + #13#10; //新-品介
    if rPrice > 0 then
    begin
      result := result + format('<$0000F1FF>出售价格: <$00EEEEEE>%d', [rPrice]);
//
//      if rPrice > 100000000 then
//        result := result + format(' <$000080FF>(%.2f亿)', [rPrice / 100000000])
//      else if rPrice > 10000 then
//        result := result + format(' <$000080FF>(%.2f万)', [rPrice / 10000]);
      result := result + #13#10 + '{2} ' + #13#10; //价格
      //result := result + '<$0000F1FF>交易货币: <$00EEEEEE>' + rTradeMoneyName + #13#10;
    end;
    if rCount > 1 then
    begin
      result := result + format('<$0000F1FF>数量: <$00EEEEEE>%d', [rCount]); //数量
//      if rCount > 100000000 then
//        result := result + format(' <$000080FF>(%.2f亿)', [rCount / 100000000])
//      else if rCount > 10000 then
//        result := result + format(' <$000080FF>(%.2f万)', [rCount / 10000]);
      result := result + #13#10 + '{2} ' + #13#10;
    end;
    if rSpecialLevel > 0 then
    begin
      result := result + '<$0000F1FF>等级: <$00EEEEEE>' + Get10000To100(rSpecialLevel) + #13#10 + '{2} ' + #13#10;
    end;
    if rKind = ITEM_KIND_35 then
    begin
         //   if rDurability > 0 then
      result := result + format('<$0000F1FF>水量: <$00EEEEEE>%d/%d', [rCurDurability, rDurability]) + #13#10 + '{2} ' + #13#10;
    end
    else
    begin
      if rDurability > 0 then
        result := result + format('<$0000F1FF>持久: <$00EEEEEE>%d/%d', [rCurDurability, rDurability]) + #13#10 + '{2} ' + #13#10;
    end;

//    if boUpgrade then
//      if MaxUpgrade > 0 then
//        result := result + '最高升段等级:' + inttostr(MaxUpgrade) + #13#10 + '{2} ' + #13#10; //新 (最大升级别)
    if rboident then
      result := result + '<$001DF833>可鉴定(通过鉴定可以得到更多属性)' + #13#10 + '{2} ' + #13#10;

    if rSuitId > 0 then
    begin
      if WearitemClass.Wear.getSuitIDCount(rSuitId) >= 4 then
      begin
        astr := _get('<$001DF833>', rLifeDataSuit);
        if astr <> '' then
          result := result + '<$001DF833>〓套装〓' + #13#10 + '{2} ' + #13#10 + astr;
      end
      else
      begin
        astr := _get('<$007B7B7B>', rLifeDataSuit);
        if astr <> '' then
          result := result + '<$007B7B7B>〓套装〓(穿戴全套激活属性)' + #13#10 + '{2} ' + #13#10 + astr;
      end;
    end;
    if rSetting.rsettingcount > 0 then
    begin
      if rSetting.rsettingcount >= 1 then
        if rSetting.rsetting1 <> '' then
          result := result + '<$00F7A61E>镶嵌(1):' + rSetting.rsetting1 + #13#10 + '{2} ' + #13#10;
      if rSetting.rsettingcount >= 2 then
        if rSetting.rsetting2 <> '' then
          result := result + '<$00F7A61E>镶嵌(2):' + rSetting.rsetting2 + #13#10 + '{2} ' + #13#10;
      if rSetting.rsettingcount >= 3 then
        if rSetting.rsetting3 <> '' then
          result := result + '<$00F7A61E>镶嵌(3):' + rSetting.rsetting3 + #13#10 + '{2} ' + #13#10;
      if rSetting.rsettingcount >= 4 then
        if rSetting.rsetting4 <> '' then
          result := result + '<$00F7A61E>镶嵌(4):' + rSetting.rsetting4 + #13#10 + '{2} ' + #13#10;

    end;
    case rlockState of
      1:
        result := result + '<$001A4DFB>锁定状态' + #13#10 + '{2} ' + #13#10;
      2:
        result := result + format('<$001A4DFB>解锁时间已过:%.2f小时', [(rlocktime / 60)]) + #13#10 + '{2} ' + #13#10;
            //  2:result := result + '解锁时间' + #13#10;
    end;

    if rboBlueprint then
    begin
      result := result + '<$0023A4FA>设计图纸/铸造模型' + #13#10 + '{2} ' + #13#10;
      result := result + '<$0023A4FA>合成材料：';
      if rMaterial.NameArr[0] <> '' then
        result := result + format(' %s %d个', [rMaterial.NameArr[0], rMaterial.CountArr[0]]);
      if rMaterial.NameArr[1] <> '' then
        result := result + format(' %s %d个', [rMaterial.NameArr[1], rMaterial.CountArr[1]]);
      if rMaterial.NameArr[2] <> '' then
        result := result + format(' %s %d个', [rMaterial.NameArr[2], rMaterial.CountArr[2]]);
      if rMaterial.NameArr[3] <> '' then
        result := result + format(' %s %d个', [rMaterial.NameArr[3], rMaterial.CountArr[3]]);
      result := result + #13#10 + '{2} ' + #13#10;
    end;
//
//    if rKind = ITEM_KIND_QUEST then
//      result := result + '<$001A4DFB>任务物品' + #13#10;
//    if rboNotTrade then
//      result := result + '<$001A4DFB>不可出售' + #13#10; //新开关 NPC交易
//    if rboNotExchange then
//      result := result + '<$001A4DFB>不可交易' + #13#10;
//    if rboNotDrop then
//      result := result + '<$001A4DFB>不可丢弃' + #13#10;
//    if rboNotSSamzie then
//      result := result + '<$001A4DFB>不可寄存' + #13#10;
//    if rboDurability then
//      if rboNOTRepair then
//        result := result + '<$001A4DFB>不可维修' + #13#10;
//    if rKind = ITEM_KIND_WEARITEM then
//    begin
//      case rSpecialKind of
//        1:
//          result := result + '<$001A4DFB>普通装备' + #13#10 + '{2} ' + #13#10;
//        2:
//          result := result + '<$001A4DFB>生产装备' + #13#10 + '{2} ' + #13#10;
//        3:
//          result := result + '<$001A4DFB>荣誉装备' + #13#10 + '{2} ' + #13#10;
//        4:
//          result := result + '<$001A4DFB>合成装备' + #13#10 + '{2} ' + #13#10;
//        5:
//          result := result + '<$001A4DFB>修炼装备' + #13#10 + '{2} ' + #13#10;
//        6:
//          result := result + '<$001A4DFB>特殊道具(离开任务地图消失)' + #13#10 + '{2} ' + #13#10;
//      end;
//    end;
//        if rboQuest then result := result + '<$001A4DFB>任务道具(离开任务地图消失)' + #13#10;
       // if rboPrestige then result := result + '<$0023A4FA>荣誉装备' + #13#10;

  end;
end;

function TcItemListClass.count: integer;
begin

  result := high(ItemArr) + 1;
end;

{ TKeyClass }

procedure TKeyClass.Clear;
var
  i: integer;
begin
  fillchar(FdataArr, sizeof(FdataArr), 0);
  for i := 0 to high(FdataArr) do
  begin
    if assigned(FonUPdate) then
      FonUPdate(i, FdataArr[i]);
  end;

end;

constructor TKeyClass.Create;
begin
  Clear;
  FOnUpdate := nil;
end;

procedure TKeyClass.del(aindex: integer);
begin
  if (aindex < 0) or (aindex > high(FdataArr)) then
    exit;
  FdataArr[aindex].rboUser := false;
  if assigned(FonUPdate) then
    FonUPdate(aindex, FdataArr[aindex]);
end;

procedure TKeyClass.UpdateType(rkeyType: TKeyClassDataKey; rkey: integer);
var
  i: integer;
begin
  for i := 0 to high(FdataArr) do
  begin
    if FdataArr[i].rboUser then
      if FdataArr[i].rkeyType = rkeyType then
        if FdataArr[i].rkey = rkey then
          UPdate(i, FdataArr[i].rtype, FdataArr[i].rkeyType, FdataArr[i].rkey);
  end;
end;

procedure TKeyClass.delType(rkeyType: TKeyClassDataKey; rkey: integer);
var
  i: integer;
begin
  for i := 0 to high(FdataArr) do
  begin
    if FdataArr[i].rboUser then
      if FdataArr[i].rkeyType = rkeyType then
        if FdataArr[i].rkey = rkey then
          del(i);
  end;
end;

destructor TKeyClass.Destroy;
begin

  inherited;
end;

function TKeyClass.get(aindex: integer): pTKeyClassData;
begin
  result := nil;
  if (aindex < 0) or (aindex > high(FdataArr)) then
    exit;
  result := @FdataArr[aindex];
end;

function TKeyClass.getKey(aindex: integer): integer;
begin
  result := -1;
  if (aindex < 0) or (aindex > high(FdataArr)) then
    exit;
  result := FdataArr[aindex].rkey;
end;

procedure TKeyClass.UPdate(aindex: integer; rtype: TKeyClassDataType; rkeyType: TKeyClassDataKey; rkey: integer);
begin
  if (aindex < 0) or (aindex > high(FdataArr)) then
    exit;                
  //FrmBottom.AddChat('设置快捷键', WinRGB(22, 22, 0), 0);
  FdataArr[aindex].rboUser := false;
  if assigned(FonUPdate) then
    FonUPdate(aindex, FdataArr[aindex]);
  FdataArr[aindex].rboUser := true;
  FdataArr[aindex].rtype := rtype;
  FdataArr[aindex].rkeyType := rkeyType;
  FdataArr[aindex].rkey := rkey;
  if assigned(FonUPdate) then
    FonUPdate(aindex, FdataArr[aindex]);
  //FrmBottom.SaveAllKey;
end;

procedure TFrmAttrib.onKeyF5_F12UPdate(akey: integer; adata: TKeyClassData);
var
  aitem: titemdata;
  aMagic: TMagicData;
  idx: integer;
begin
    //使用 savekeyImagelib
  if adata.rboUser = false then
  begin

    case adata.rkeyType of
      kcdk_none:
        ;
      kcdk_HaveItem:
        begin
          if (adata.rkey < 0) or (adata.rkey > 30) then
            exit;
          FrmWearItem.ILabels[adata.rkey].A2ImageLUP := nil;
        end;
      kcdk_HaveMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 60) then
            exit; //60武功格，这里也改动
          FrmNewMagic.MLabels[adata.rkey].A2ImageLUP := nil;
        end;
      kcdk_HaveRiseMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 60) then
            exit;
          FrmNewMagic.RiseLabels[adata.rkey].A2ImageLUP := nil;
        end;
      kcdk_HaveMysteryMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 60) then
            exit;
          FrmNewMagic.MysteryLabels[adata.rkey].A2ImageLUP := nil;
        end;
      kcdk_BasicMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 30) then
            exit;
          FrmNewMagic.bLabels[adata.rkey].A2ImageLUP := nil;
        end;
    end;

  end
  else
  begin
    case adata.rkeyType of
      kcdk_none:
        ;
      kcdk_HaveItem:
        begin
          if (adata.rkey < 0) or (adata.rkey > 30) then
            exit;
          FrmWearItem.ILabels[adata.rkey].A2ImageLUP := savekeyImagelib[akey + 10];
        end;
      kcdk_HaveMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 60) then
            exit; //这里也得改动
          FrmNewMagic.MLabels[adata.rkey].A2ImageLUP := savekeyImagelib[akey + 10];
        end;
      kcdk_BasicMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 30) then
            exit;
          FrmNewMagic.bLabels[adata.rkey].A2ImageLUP := savekeyImagelib[akey + 10];
        end;
      kcdk_HaveRiseMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 60) then
            exit;
          FrmNewMagic.RiseLabels[adata.rkey].A2ImageLUP := savekeyImagelib[akey + 10];
        end;
      kcdk_HaveMysteryMagic:
        begin
          if (adata.rkey < 0) or (adata.rkey > 60) then
            exit;
          FrmNewMagic.MysteryLabels[adata.rkey].A2ImageLUP := savekeyImagelib[akey + 10];
        end;
    end;
  end;

end;

procedure TFrmAttrib.onKeyItemUPdate(akey: integer; adata: TKeyClassData);
var
  aitem: titemdata;
  aMagic: TMagicData;
  idx: integer;
begin
    //使用
  if adata.rboUser = false then
  begin
    SetItemLabel(FrmBottom.shortcutLabels[akey], '', 0, 0, 0, 0);
  end
  else
  begin
    case adata.rkeyType of
      kcdk_HaveItem:
        begin
          aitem := HaveItemclass.get(adata.rkey);
          if aitem.rViewName = '' then
          begin
            SetItemLabel(FrmBottom.shortcutLabels[akey], '', 0, 0, 0, 0);
          end
          else
          begin
            if aitem.rlockState = 1 then
              idx := 24
            else if aitem.rlockState = 2 then
              idx := 25
            else
              idx := 0;
            SetItemLabel(FrmBottom.shortcutLabels[akey], '', aitem.rColor, aitem.rshape, idx, 0);
          end;
        end;
      kcdk_HaveMagic:
        begin
          aMagic := (HaveMagicClass.HaveMagic.get(adata.rkey));
          if aMagic.rname = '' then
          begin
            SetItemLabel(FrmBottom.shortcutLabels[akey], '', 0, 0, 0, 0);
          end
          else
          begin
            SetMagicLabel(FrmBottom.shortcutLabels[akey], '', 0, aMagic.rShape, 0);
          end;
        end;
      kcdk_BasicMagic:
        begin
          aMagic := (HaveMagicClass.DefaultMagic.get(adata.rkey));
          if aMagic.rname = '' then
          begin
            SetItemLabel(FrmBottom.shortcutLabels[akey], '', 0, 0, 0, 0);
          end
          else
          begin
            SetMagicLabel(FrmBottom.shortcutLabels[akey], '', 0, aMagic.rShape, 0);
          end;
        end;
      kcdk_HaveRiseMagic:
        begin
          aMagic := (HaveMagicClass.HaveRiseMagic.get(adata.rkey));
          if aMagic.rname = '' then
          begin
            SetItemLabel(FrmBottom.shortcutLabels[akey], '', 0, 0, 0, 0);
          end
          else
          begin
            SetMagicLabel(FrmBottom.shortcutLabels[akey], '', 0, aMagic.rShape, 0);
          end;
        end;
      kcdk_HaveMysteryMagic:
        begin
          aMagic := (HaveMagicClass.HaveMysteryMagic.get(adata.rkey));
          if aMagic.rname = '' then
          begin
            SetItemLabel(FrmBottom.shortcutLabels[akey], '', 0, 0, 0, 0);
          end
          else
          begin
            SetMagicLabel(FrmBottom.shortcutLabels[akey], '', 0, aMagic.rShape, 0);
          end;
        end;
    end;
  end;
end;

procedure TFrmAttrib.onHaveitemQuestUPdate(akey: integer; aitem: titemdata);
begin
  FrmWearItem.onHaveitemQuestUPdate(akey, aitem);
end;

procedure TFrmAttrib.onHaveMysteryMagicUp(akey: integer; aitem: TMagicData);
begin
  FrmNewMagic.onHaveMysteryMagicUp(akey, aitem);
end;

procedure TFrmAttrib.onHaveRiseMagicUp(akey: integer; aitem: TMagicData);
begin
  FrmNewMagic.onHaveRiseMagicUp(akey, aitem);
end;

procedure TFrmAttrib.onBindMoney(acount: integer);
begin
  FrmWearItem.onBindMoney(acount);
end;
{ TcBufferItemDataClass }

procedure TcBufferItemDataClass.add(var aitem: titemdata);
var
  p: ptitemdata;
begin
  if get(aitem.rname) <> nil then
    exit;
  new(p);

  p^ := aitem;
  DataList.Add(p);
  NameIndex.Insert(P.rname, p);
end;

procedure TcBufferItemDataClass.clear;
var
  i: integer;
  p: ptitemdata;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    p := DataList.Items[i];
    dispose(p);
  end;
  DataList.Clear;
  NameIndex.Clear;
end;

constructor TcBufferItemDataClass.Create;
begin
  DataList := TList.Create;
  NameIndex := TStringKeyClass.Create;
end;

destructor TcBufferItemDataClass.Destroy;
begin
  clear;
  DataList.free;
  NameIndex.free;

  inherited;
end;

function TcBufferItemDataClass.get(aname: string): PTItemdata;
begin
  result := NameIndex.Select(aname);
end;

function TcMagicListClass.getProtectMagicNameList: string;
var
  i: integer;
  temp: TMagicData;
begin
  Result := '';
  for i := 0 to high(ItemArr) do
  begin
    temp := ItemArr[i];
    if (temp.rMagicType = 9) or (temp.rMagicType = 109) then
      Result := Result + temp.rname + #13#10;

  end;
end;

function TcMagicListClass.getBREATHNGMagicNameList: string;
var
  i: integer;
  temp: TMagicData;
begin
  Result := '';
  for i := 0 to high(ItemArr) do
  begin
    temp := ItemArr[i];
    if (temp.rMagicType = 8) or (temp.rMagicType = 108) then
      Result := Result + temp.rname + #13#10;
  end;
end;

function TcMagicListClass.getAttackMagicNameList(aTag: integer): string;
var
  i: integer;
  temp: TMagicData;
  tag: boolean;
begin
  Result := '';
  for i := 0 to high(ItemArr) do
  begin
    tag := false;
    temp := ItemArr[i];
    case aTag of
    0: tag := true;
    1: tag := temp.rcSkillLevel = 9999;
    2: tag := temp.rcSkillLevel <> 9999;
    end;
    if tag and (temp.rname<>'') and ((temp.rMagicType in [0..6,100..106])) then
      Result := Result + temp.rname + #13#10;
  end;
end;

function TcMagicListClass.getQieHuanMagicName: string;
var
  i: integer;
  temp: TMagicData;
begin
  Result := '';
  for i := 0 to high(ItemArr) do
  begin
    temp := ItemArr[i];
    case temp.rMagicType of
      //进攻武功类型
      MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING, MAGICTYPE_SPEARING, MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING, MAGICTYPE_2SPEARING:
        begin
          if temp.rcSkillLevel < 9999 then
          begin
            Result := temp.rname;
            exit;
          end;
        end;
    end;
  end;
end;


{ TcOtherUserAttribClass }

constructor TcOtherUserAttribClass.Create;
begin
  inherited Create;
  FOnOtherUserUpdate := nil;
end;

procedure TcOtherUserAttribClass.MessageProcess(var code: TWordComData);
var
  pSLifeData: pTSLifeData;
  psAttribBase: PTSAttribBase;
  psAttribValues: PTSAttribValues;
  pSAttribUPDATE: pTSAttribUPDATE;
begin
  case Code.Data[0] of
    SM_OtherUserLifeData:
      begin
        pSLifeData := @Code.Data;
        LifeData.damageBody := pSLifeData.damageBody;
        LifeData.damageHead := pSLifeData.damageHead;
        LifeData.damageLeg := pSLifeData.damageLeg;
        LifeData.damageArm := pSLifeData.damageArm;

        LifeData.armorBody := pSLifeData.armorBody;
        LifeData.armorHead := pSLifeData.armorHead;
        LifeData.armorArm := pSLifeData.armorArm;
        LifeData.armorLeg := pSLifeData.armorLeg;

        LifeData.AttackSpeed := pSLifeData.AttackSpeed;
        LifeData.avoid := pSLifeData.avoid;
        LifeData.recovery := pSLifeData.recovery;
        LifeData.HitArmor := pSLifeData.HitArmor;
        LifeData.accuracy := pSLifeData.accuracy;
        if Assigned(FOnOtherUserUpdate) then
          FOnOtherUserUpdate();
                  //FrmBottom.AddChat('测试消息：收到攻击 防御 速度 躲避 命中属性' + datetimetostr(now()), WinRGB(Random(22), 22, 0), 0);
      end;

    SM_OtherUserATTRIBBASE:
      begin
                //  FrmBottom.AddChat('测试消息：收到ATTRIBBASE' + datetimetostr(now()), WinRGB(Random(22), 22, 0), 0);
        psAttribBase := @Code.Data;
        with psAttribBase^ do
        begin
          AttribData.cAge := rAge; //年龄
          AttribData.cEnergy := rEnergy; //元气
          CurAttribData.CurEnergy := rCurEnergy;

          AttribData.cInPower := rInPower; //内功
          CurAttribData.CurInPower := rCurInPower;

          AttribData.cOutPower := rOutPower; //外功
          CurAttribData.CurOutPower := rCurOutPower;

          AttribData.cMagic := rMagic; //武功
          CurAttribData.CurMagic := rCurMagic;

          AttribData.cLife := rLife; //活力 生命
          CurAttribData.CurLife := rCurLife;
          AttribData.lucky := rlucky; // 幸运

          AttribData.cadaptive := radaptive; //耐性
          AttribData.cRevival := rRevival; //再生

          AttribData.newTalent := rCTalent;
          AttribData.newTalentExp := rCTalentExp;
          AttribData.newTalentNextLvExp := rCTalentNextLvExp;
          AttribData.newTalentLv := rCTalentLv;
          AttribData.newBone := rCnewBone;
          AttribData.newLeg := rCnewLeg;
          AttribData.newSavvy := rCnewSavvy;
          AttribData.newAttackPower := rCnewAttackPower;
        end;
        if Assigned(FOnOtherUserUpdate) then
          FOnOtherUserUpdate();
      end;

  end;
end;

end.

