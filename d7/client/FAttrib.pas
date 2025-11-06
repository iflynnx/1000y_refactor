unit FAttrib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, A2Img, aDeftype, Deftype, ExtCtrls, StdCtrls, CharCls, cltype, AtzCls,
  BackScrn, Gauges, Menus, uAnsTick; //Fdyeing,

const
  AttribItemMaxCount = HAVEITEMSIZE;    //30
  KeyMaxSize = 8;

type

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
    PanelItem: TA2Panel;
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
    Image1: TImage;
    PgHead: TGauge;
    PGArm: TGauge;
    PGLeg: TGauge;
    LbMoney: TLabel;
    LbWindowName: TLabel;
    LbAge: TLabel;
    LbVirtue: TLabel;
    LbEvent: TLabel;
    PanelBest: TA2Panel;
    SILabel0: TA2ILabel;
    SILabel1: TA2ILabel;
    SILabel3: TA2ILabel;
    SILabel4: TA2ILabel;
    SILabel5: TA2ILabel;
    SILabel6: TA2ILabel;
    SILabel7: TA2ILabel;
    SILAbel8: TA2ILabel;
    SILabel9: TA2ILabel;
    SILabel10: TA2ILabel;
    SILabel11: TA2ILabel;
    SILabel12: TA2ILabel;
    SILabel13: TA2ILabel;
    SILabel14: TA2ILabel;
    SILabel2: TA2ILabel;
    SILabel15: TA2ILabel;
    SILabel16: TA2ILabel;
    SILabel17: TA2ILabel;
    SILabel18: TA2ILabel;
    SILabel19: TA2ILabel;
    SILabel20: TA2ILabel;
    SILabel21: TA2ILabel;
    SILabel22: TA2ILabel;
    SILabel23: TA2ILabel;
    SILabel24: TA2ILabel;
    MagicPoint: TLabel;
    Image2: TImage;
    btnMagicTab: TA2Button;
    btnBasicMagicTab: TA2Button;
    btnRiseMagicTab: TA2Button;
    imgMagic: TImage;
    imgBasicMagic: TImage;
    imgRiseMagic: TImage;
    PanelMagics: TA2Panel;
    lblMagic0: TA2ILabel;
    lblMagic1: TA2ILabel;
    lblMagic2: TA2ILabel;
    lblMagic3: TA2ILabel;
    lblMagic4: TA2ILabel;
    lblMagic5: TA2ILabel;
    lblMagic6: TA2ILabel;
    lblMagic7: TA2ILabel;
    lblMagic8: TA2ILabel;
    lblMagic9: TA2ILabel;
    lblMagic10: TA2ILabel;
    lblMagic11: TA2ILabel;
    lblMagic12: TA2ILabel;
    lblMagic13: TA2ILabel;
    lblMagic14: TA2ILabel;
    lblMagic15: TA2ILabel;
    lblMagic16: TA2ILabel;
    lblMagic17: TA2ILabel;
    lblMagic18: TA2ILabel;
    lblMagic19: TA2ILabel;
    lblMagic20: TA2ILabel;
    lblMagic21: TA2ILabel;
    lblMagic22: TA2ILabel;
    lblMagic23: TA2ILabel;
    lblMagic24: TA2ILabel;
    lblMagic25: TA2ILabel;
    lblMagic26: TA2ILabel;
    lblMagic27: TA2ILabel;
    lblMagic28: TA2ILabel;
    lblMagic29: TA2ILabel;
    Image3: TImage;
    lblGuildEnergy: TA2ILabel;
    A2ILabel30: TA2ILabel;
    A2ILabel31: TA2ILabel;
    A2ILabel32: TA2ILabel;
    A2ILabel33: TA2ILabel;
    A2ILabel34: TA2ILabel;
    A2ILabel35: TA2ILabel;
    A2ILabel36: TA2ILabel;
    A2ILabel37: TA2ILabel;
    A2ILabel38: TA2ILabel;
    A2ILabel39: TA2ILabel;
    A2ILabel40: TA2ILabel;
    A2ILabel41: TA2ILabel;
    A2ILabel42: TA2ILabel;
    A2ILabel43: TA2ILabel;
    A2ILabel44: TA2ILabel;
    A2ILabel45: TA2ILabel;
    A2ILabel46: TA2ILabel;
    A2ILabel47: TA2ILabel;
    A2ILabel48: TA2ILabel;
    A2ILabel49: TA2ILabel;
    lblMagic30: TA2ILabel;
    lblMagic31: TA2ILabel;
    lblMagic32: TA2ILabel;
    lblMagic33: TA2ILabel;
    lblMagic34: TA2ILabel;
    lblMagic35: TA2ILabel;
    lblMagic36: TA2ILabel;
    lblMagic37: TA2ILabel;
    lblMagic38: TA2ILabel;
    lblMagic39: TA2ILabel;
    lblMagic40: TA2ILabel;
    lblMagic41: TA2ILabel;
    lblMagic42: TA2ILabel;
    lblMagic43: TA2ILabel;
    lblMagic44: TA2ILabel;
    lblMagic45: TA2ILabel;
    lblMagic48: TA2ILabel;
    lblMagic47: TA2ILabel;
    lblMagic46: TA2ILabel;
    lblMagic49: TA2ILabel;
    SILabel25: TA2ILabel;
    SILabel26: TA2ILabel;
    SILabel27: TA2ILabel;
    SILabel28: TA2ILabel;
    SILabel29: TA2ILabel;
    SILabel30: TA2ILabel;
    SILabel31: TA2ILabel;
    SILabel32: TA2ILabel;
    SILabel33: TA2ILabel;
    SILabel34: TA2ILabel;
    SILabel35: TA2ILabel;
    SILabel36: TA2ILabel;
    SILabel37: TA2ILabel;
    SILabel38: TA2ILabel;
    SILabel39: TA2ILabel;
    SILabel40: TA2ILabel;
    SILabel41: TA2ILabel;
    SILabel42: TA2ILabel;
    SILabel43: TA2ILabel;
    SILabel44: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LbCharMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure LbCharStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure LbCharMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure LbCharDragOver(Sender, Source: TObject; X, Y: Integer; State:
      TDragState; var Accept: Boolean);
    procedure LbCharDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ItemLabelDblClick(Sender: TObject);
    procedure ItemLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ItemLabelDragOver(Sender, Source: TObject; X, Y: Integer; State:
      TDragState; var Accept: Boolean);
    procedure ItemLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure ItemLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure ItemLabelClick(Sender: TObject);
    procedure ItemLabelPaint(Sender: TObject);
    procedure ItemLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnMagicTabClick(Sender: TObject);
    procedure btnBasicMagicTabClick(Sender: TObject);
    procedure btnRiseMagicTabClick(Sender: TObject);
    procedure lblMagicClick(Sender: TObject);
    procedure lblMagicDblClick(Sender: TObject);
    procedure lblMagicDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lblMagicDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lblMagicMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblMagicMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblMagicPaint(Sender: TObject);
    procedure lblMagicStartDrag(Sender: TObject;
      var DragObject: TDragObject);
  private
    { Private declarations }
//     DragDropSelectNum : integer;
//     SelectItem : integer;

//    FIndexDragOnWear: integer;
    nLastMagicWindow: integer;
    procedure SetFormText;
  public
    CurrentWindow: integer;
    lblMagic: array[0..HAVEMAGICSIZE - 1] of TA2ILabel;
    MagicData: array[0..HAVEMAGICSIZE*5 - 1] of TAttribMagicData;

    procedure SetMagicData(aIndex, aShape: integer; aName: string; aLevel:
      integer);
    procedure DrawMagicIcon(Sender: TObject; MagicSub: integer);
    procedure PanelSelect(iPanel: integer; LabelText: string);
    function FindMagicIndex(const aMagicName: string): integer;
    function GetMagicSkillLevel(const aMagicName: string): string;
    function HaveSomeItem(const strItemName: string; iNeedCount: integer):
      integer;
  public
    { Public declarations }
    ILabels: array[0..HAVEITEMSIZE - 1] of TA2ILabel;
    SLabels: array[0..50 - 1] of TA2ILabel;

    CharCenterImage: TA2Image;
    WearStrings: array[0..10] of string;

    procedure MessageProcess(var code: TWordComData);
    procedure DrawWearItem;
    procedure DrawGuildEnergy(AValue: Integer);
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape:
      word);

    function AppKeyDownHook(var Msg: TMessage): Boolean;
    procedure SetKeybuffer(key: Word);

    procedure keyRepaint(value: word);
    procedure keyProcess(value: Word);
    procedure SendGlobalClick(AMsg, AWin, AIndex: integer);
    procedure changeBack();
  end;

var
  FrmAttrib: TFrmAttrib;

var
  KeyFlag: Boolean = FALSE;
  KeyValue: Word = 0;
  KeyIndex: integer = -1;
  Keybuffer: array[0..KeyMaxSize - 1] of Word;
var
  savekeyImagelib: TA2ImageLib;
  savekeyImage: TA2Image;
  GuildImageLib: TA2ImageLib;

  //Add by Steven 2004-09-07 15:09
  HaveItemList: array[0..HAVEITEMSIZE - 1] of TSHaveItemNew;
  SelectHaveItem: Integer;

function Get10000To100(avalue: integer): string;

implementation

uses
  FMain, FBottom, FLogOn, FDepository, FQuantity, FMiniMap, FSkill,
  FNPCTrade, AUtil32, FCharAttrib;

{$R *.DFM}

var
  Last_X: integer;
  P: TPoint;

  ////////////////////////////////////////////////
  // Shortcut Key

procedure TFrmAttrib.keyRepaint(value: word);
begin
  case value of
    {1..30: ILabels[value - 1].Repaint;
    31..150: lblMagic[(value - 1) mod 30].Repaint;
    151..175: SLabels[value - 151].Repaint; }

    1..50: ILabels[value - 1].Repaint;
    51..250: lblMagic[(value - 1) mod 50].Repaint;
    251..295: SLabels[value - 251].Repaint;
  end;
end;

procedure TFrmAttrib.keyProcess(value: Word);        //显示快捷键生效的
begin
  case value of              //基础 BASICFIGHT> 武功 > 背包 > 上乘 > 掌法
   { 1..30: SendGlobalClick(CM_DBLCLICK, WINDOW_ITEMS, value - 1);
    31..60: SendGlobalClick(CM_DBLCLICK, WINDOW_MAGICS, value - 31);
    61..90: SendGlobalClick(CM_DBLCLICK, WINDOW_BASICFIGHT, value - 61);
    91..120: SendGlobalClick(CM_DBLCLICK, WINDOW_RISEMAGICS, value - 91);
    121..150: SendGlobalClick(CM_DBLCLICK, WINDOW_MYSTERYMAGICS, value - 121);
    151..175: SendGlobalClick(CM_DBLCLICK, WINDOW_BESTMAGIC, value - 151); }

    1..50: SendGlobalClick(CM_DBLCLICK, WINDOW_ITEMS, value - 1);
    51..100: SendGlobalClick(CM_DBLCLICK, WINDOW_MAGICS, value - 51);
    101..150: SendGlobalClick(CM_DBLCLICK, WINDOW_BASICFIGHT, value - 101);
    151..200: SendGlobalClick(CM_DBLCLICK, WINDOW_RISEMAGICS, value - 151);
    201..250: SendGlobalClick(CM_DBLCLICK, WINDOW_MYSTERYMAGICS, value - 201);
    251..295: SendGlobalClick(CM_DBLCLICK, WINDOW_BESTMAGIC, value - 251);

  end;
end;

procedure TFrmAttrib.SetKeybuffer(key: Word);
  procedure Setkey(a: Word);
  var
    i: integer;
    n: Word;
    cCSetShortCut: TCSetShortCut;
  begin
    for i := 0 to KeyMaxSize - 1 do
      if Keybuffer[i] = keyindex then
        Keybuffer[i] := 0;
    n := Keybuffer[a];
    KeyBuffer[a] := 0;
    KeyRepaint(n);
    Keybuffer[a] := KeyIndex; //steven

    cCSetShortCut.rMsg := CM_SETSHORTCUT;
    cCSetShortCut.rButton := a;
    cCSetShortCut.rPosition := Keyindex;

    FrmLogon.SocketAddData(sizeof(cCSetShortCut), @cCSetShortCut);

    //      Connector.SendData(@cCSetShortCut, sizeof(cCSetShortCut));
  end;
begin
  case key of
    VK_F5: Setkey(0);
    VK_F6: Setkey(1);
    VK_F7: Setkey(2);
    VK_F8: Setkey(3);
    VK_F9: Setkey(4);
    VK_F10: Setkey(5);
    VK_F11: Setkey(6);
    VK_F12: Setkey(7);
  end;
end;

function TFrmAttrib.AppKeyDownHook(var Msg: TMessage): Boolean;
begin
  Result := FALSE;
  GetCursorPos(P);

  if (P.x < 800 - 180 + FrmM.Left) or (P.x > 800 + FrmM.Left) then
  begin
    KeyFlag := FALSE;
    exit;
  end;
  if (P.y > 600 - 117 + FrmM.Top) or (P.y < 144 + FrmM.Top) then
  begin
    KeyFlag := FALSE;
    exit;
  end;

  case Msg.Msg of
    Cm_AppkeyDown:
      begin
        if KeyFlag then
        begin
          if not FrmAttrib.Visible then
            exit;
          if (PanelItem.Visible) or (PanelMagics.Visible) or (PanelBest.Visible)
            then
          begin
            KeyValue := TWMKey(Msg).CharCode;
            SetKeybuffer(KeyValue);
            keyRepaint(KeyIndex);
          end;
        end;
        Result := TRUE;
      end;
  else
    Result := FALSE;
  end;
end;

/////////////////////////////

procedure TFrmAttrib.SetFormText;
begin
  PgHead.Hint := Conv('头');
  PGArm.Hint := Conv('手臂');
  PGLeg.Hint := Conv('腿');
end;

var
  SelWearItemIndex: integer = 0;
  OverWearItemIndex: integer = 0;

const
  SelectedMagicLabel: TA2ILabel = nil;
  SelectedItemLabel: TA2ILabel = nil;
  SelectedWearLabel: TA2ILabel = nil;

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
  i,j,h: integer;
begin
  application.HookMainWindow(AppKeyDownHook);
  savekeyImage := TA2Image.Create(140, 140, 0, 0);
  savekeyImagelib := TA2ImageLib.Create;
  savekeyImagelib.LoadFromFile('.\ect\funcimg.atz');

  //GuildImageLib := TA2ImageLib.Create;
  //GuildImageLib.LoadFromFile('.\ect\guildimg.atz');
 
  Color := clBlack;
  Parent := FrmM;
  //Left := 1024 - Width;

  if  G_Default800 then
  begin
     Left := fwide800 - Width;
     end else
  begin
     Left := fwide - Width;
  end;

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

  //lblGuildEnergy.A2Image := TA2Image.Create(60, 74, 0, 0);
  DrawGuildEnergy(0);
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
  ILabels[30] := A2ILabel30;
  ILabels[31] := A2ILabel31;
  ILabels[32] := A2ILabel32;
  ILabels[33] := A2ILabel33;
  ILabels[34] := A2ILabel34;
  ILabels[35] := A2ILabel35;
  ILabels[36] := A2ILabel36;
  ILabels[37] := A2ILabel37;
  ILabels[38] := A2ILabel38;
  ILabels[39] := A2ILabel39;
  ILabels[40] := A2ILabel40;
  ILabels[41] := A2ILabel41;
  ILabels[42] := A2ILabel42;
  ILabels[43] := A2ILabel43;
  ILabels[44] := A2ILabel44;
  ILabels[45] := A2ILabel45;
  ILabels[46] := A2ILabel46;
  ILabels[47] := A2ILabel47;
  ILabels[48] := A2ILabel48;
  ILabels[49] := A2ILabel49;

  lblMagic[0] := lblMagic0;
  lblMagic[1] := lblMagic1;
  lblMagic[2] := lblMagic2;
  lblMagic[3] := lblMagic3;
  lblMagic[4] := lblMagic4;
  lblMagic[5] := lblMagic5;
  lblMagic[6] := lblMagic6;
  lblMagic[7] := lblMagic7;
  lblMagic[8] := lblMagic8;
  lblMagic[9] := lblMagic9;
  lblMagic[10] := lblMagic10;
  lblMagic[11] := lblMagic11;
  lblMagic[12] := lblMagic12;
  lblMagic[13] := lblMagic13;
  lblMagic[14] := lblMagic14;
  lblMagic[15] := lblMagic15;
  lblMagic[16] := lblMagic16;
  lblMagic[17] := lblMagic17;
  lblMagic[18] := lblMagic18;
  lblMagic[19] := lblMagic19;
  lblMagic[20] := lblMagic20;
  lblMagic[21] := lblMagic21;
  lblMagic[22] := lblMagic22;
  lblMagic[23] := lblMagic23;
  lblMagic[24] := lblMagic24;
  lblMagic[25] := lblMagic25;
  lblMagic[26] := lblMagic26;
  lblMagic[27] := lblMagic27;
  lblMagic[28] := lblMagic28;
  lblMagic[29] := lblMagic29;
  lblMagic[30] := lblMagic30;
  lblMagic[31] := lblMagic31;
  lblMagic[32] := lblMagic32;
  lblMagic[33] := lblMagic33;
  lblMagic[34] := lblMagic34;
  lblMagic[35] := lblMagic35;
  lblMagic[36] := lblMagic36;
  lblMagic[37] := lblMagic37;
  lblMagic[38] := lblMagic38;
  lblMagic[39] := lblMagic39;
  lblMagic[40] := lblMagic40;
  lblMagic[41] := lblMagic41;
  lblMagic[42] := lblMagic42;
  lblMagic[43] := lblMagic43;
  lblMagic[44] := lblMagic44;
  lblMagic[45] := lblMagic45;
  lblMagic[46] := lblMagic46;
  lblMagic[47] := lblMagic47;
  lblMagic[48] := lblMagic48;
  lblMagic[49] := lblMagic49;

  SLabels[0] := SILabel0;
  SLabels[1] := SILabel1;
  SLabels[2] := SILabel2;
  SLabels[3] := SILabel3;
  SLabels[4] := SILabel4;
  SLabels[5] := SILabel5;
  SLabels[6] := SILabel6;
  SLabels[7] := SILabel7;
  SLabels[8] := SILabel8;
  SLabels[9] := SILabel9;
  SLabels[10] := SILabel10;
  SLabels[11] := SILabel11;
  SLabels[12] := SILabel12;
  SLabels[13] := SILabel13;
  SLabels[14] := SILabel14;
  SLabels[15] := SILabel15;
  SLabels[16] := SILabel16;
  SLabels[17] := SILabel17;
  SLabels[18] := SILabel18;
  SLabels[19] := SILabel19;
  SLabels[20] := SILabel20;
  SLabels[21] := SILabel21;
  SLabels[22] := SILabel22;
  SLabels[23] := SILabel23;
  SLabels[24] := SILabel24;
  SLabels[25] := SILabel25;
  SLabels[26] := SILabel26;
  SLabels[27] := SILabel27;
  SLabels[28] := SILabel28;
  SLabels[29] := SILabel29;
  SLabels[30] := SILabel30;
  SLabels[31] := SILabel31;
  SLabels[32] := SILabel32;
  SLabels[33] := SILabel33;
  SLabels[34] := SILabel34;
  SLabels[35] := SILabel35;
  SLabels[36] := SILabel36;
  SLabels[37] := SILabel37;
  SLabels[38] := SILabel38;
  SLabels[39] := SILabel39;
  SLabels[40] := SILabel40;
  SLabels[41] := SILabel41;
  SLabels[42] := SILabel42;
  SLabels[43] := SILabel43;
  SLabels[44] := SILabel44;


  for i := 0 to HAVEITEMSIZE - 1 do       //for i := 0 to 30 - 1 do
    //ILabels[i] := TA2ILabel(FindComponent(Format('A2ILabel%d', [i])));
    ILabels[i].Tag := i;
  for j := 0 to HAVEMAGICSIZE - 1 do
    //lblMagic[i] := TA2ILabel(FindComponent(Format('lblMagic%d', [i])));
    lblMagic[j].Tag := j;

  for h := 0 to 45 - 1 do
    //SLabels[i] := TA2ILabel(FindComponent(Format('SILabel%d', [i])));
    SLabels[h].Tag := h;
  CurrentWindow := WINDOW_ITEMS;
  nLastMagicWindow := 2;
end;

procedure TFrmAttrib.FormDestroy(Sender: TObject);
begin
  application.UnhookMainWindow(AppKeyDownHook);

  savekeyImagelib.Free;
  GuildImageLib.Free;
  savekeyImage.Free;

  CharCenterImage.Free;
end;

procedure TFrmAttrib.FormShow(Sender: TObject);
begin

  if G_Default800 then
  begin
    Left := fwide800 - Width;
  end else
  begin
    Left := fwide - Width;
  end;

  //BackScreen.SHeight := 480;
  //   FrmM.DXTimerTimer(Self, 0);
end;

procedure TFrmAttrib.changeBack;
 begin
  if G_Default800 then
  begin
    Left := fwide800 - Width;
  end else
  begin
    Left := fwide - Width;
  end;
  //BackScreen.SWidth := 1024;
  //BackScreen.SHeight := 480;
  //   FrmM.DXTimerTimer(Self, 0);
end;

procedure TFrmAttrib.FormHide(Sender: TObject);
begin
  if G_Default800 then
  begin
    Left := fwide800 - Width;
  end else
  begin
    Left := fwide - Width;
  end;
  //BackScreen.SWidth := 1024;
  //BackScreen.SHeight := 480;
  //   FrmM.DXTimerTimer(Self, 0);
end;

procedure TFrmAttrib.SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte;
  shape: word);
var
  gc, ga: integer;
begin
  Lb.Caption := '';
  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;

  if shape = 0 then
  begin
    Lb.A2Image := nil;
    Lb.BColor := 0;
    exit;
  end
  else
    Lb.A2Image := AtzClass.GetItemImage(shape);
end;

procedure TFrmAttrib.MessageProcess(var code: TWordComData);
var
  psAttribValues: PTSAttribValues;
  psExtraAttribValue: PTSExtraAttribValues;
  psWearItem: PTSWearItem;
  psHaveMagic: PTSHaveMagic;
  psHaveItem: PTSHaveItemNew;
  psNetState: PTSNetState;
  i: integer;
begin
  case Code.Data[0] of
    SM_HAVEITEM:
      begin
        psHaveItem := @Code.Data;
        with pshaveitem^ do
        begin
          SetItemLabel(ILabels[rkey], StrPas(@rName), pshaveitem^.rColor,
            rshape);
          if rcount <= 1 then
            ILabels[rkey].Hint := StrPas(@rName)
          else
            ILabels[rkey].Hint := StrPas(@rName) + ':' + IntToStr(rCount);
          ILabels[rkey].Font.Color := rViewColor;
          //Add by Steven 2004-09-07 14:58

          HaveItemList[rKey] := pshaveitem^;
          //if HaveItemList[rKey].rLockState <> 0 then
          //Modity by Steven 2004-09-21 13:23
          TA2ILabel(FindComponent(Format('A2ILabel%d', [rKey]))).Repaint;
        end;
      end;
    SM_WEARITEM:
      begin
        psWearItem := @Code.Data;
        WearStrings[pswearitem^.rkey] := StrPas(@pswearitem^.rName);
      end;
    SM_BASICMAGIC:
      begin
        psHaveMagic := @Code.Data;
        with pshaveMagic^ do
          //SetMagicData(rKey + 30, rShape, StrPas(@rName), rSkillLevel);
          SetMagicData(rKey + HAVEMAGICSIZE, rShape, StrPas(@rName), rSkillLevel);    //无名的位置
      end;
    SM_HAVEMAGIC:
      begin
        psHaveMagic := @Code.Data;
        with pshaveMagic^ do
          SetMagicData(rKey, rShape, StrPas(@rName), rSkillLevel);
      end;
    SM_HAVERISEMAGIC:
      begin
        psHaveMagic := @Code.Data;
        with pshaveMagic^ do
          // SetMagicData(rKey + 60, rShape, StrPas(@rName), rSkillLevel);
          SetMagicData(rKey + HAVEMAGICSIZE*2, rShape, StrPas(@rName), rSkillLevel);
      end;
    SM_HAVEMYSTERY:
      begin
        psHaveMagic := @Code.Data;
        with pshaveMagic^ do
         // SetMagicData(rKey + 90, rShape, StrPas(@rName), rSkillLevel);
          SetMagicData(rKey + HAVEMAGICSIZE*3, rShape, StrPas(@rName), rSkillLevel);
      end;
    SM_HAVEBESTMAGIC:
      begin
        psHaveMagic := @Code.Data;
        with pshaveMagic^ do
          //SetMagicData(rKey + 120, rShape, StrPas(@rName), rSkillLevel);
          SetMagicData(rKey + HAVEMAGICSIZE*4, rShape, StrPas(@rName), rSkillLevel);
      end;
    SM_EXTRAATTRIB_VALUES:
      begin
        psExtraAttribValue := @Code.Data;
        MagicPoint.Caption := IntToStr(psExtraAttribValue.AddableStatePoint);
      end;
    SM_ATTRIB_VALUES:
      begin
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
        end;
        PgHead.Progress := psAttribValues^.rHeadSeak;
        PgArm.Progress := psAttribValues^.rArmSeak;
        PgLeg.Progress := psAttribValues^.rLegSeak;

        case psAttribValues^.rHeadSeak of
          0..1000: PgHead.ForeColor := $00000044;
          1001..2000: PgHead.ForeColor := $00000077;
        else
          PgHead.ForeColor := $00404077;
        end;
        case psAttribValues^.rArmSeak of
          0..5000: PgArm.ForeColor := $00000044;
          5001..6000: PgArm.ForeColor := $00000077;
        else
          PgArm.ForeColor := $00404077;
        end;
        case psAttribValues^.rLegSeak of
          0..5000: PgLeg.ForeColor := $00000044;
          5001..6000: PgLeg.ForeColor := $00000077;
        else
          PgLeg.ForeColor := $00404077;
        end;
        pgHead.Hint := Conv('头') + ':' + Get10000To100(PgHead.Progress) +
          '%';
        pgArm.Hint := Conv('手臂') + ':' + Get10000To100(PgArm.Progress) + '%';
        pgLeg.Hint := Conv('腿') + ':' + Get10000To100(PgLeg.Progress) + '%';
      end;
    SM_NETSTATE:
      begin
        psNetState := @Code.Data;
        for i := 0 to 15 do
        begin
          EncBasePos2[i] := psNetState.rQuestion[i];
        end;
        bUpdateBasePos := True;
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

procedure TFrmAttrib.LbCharMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
  Integer);
var
  i, n: integer;
  CL: TCharClass;
  ImageLib: TA2ImageLib;
begin
  Cl := CharList.GetChar(CharCenterId);
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
    MouseInfoStr := WearStrings[n];
  OverWearItemIndex := n;

  if SelWearItemIndex <> 0 then
    TA2ILabel(Sender).BeginDrag(TRUE);
end;

procedure TFrmAttrib.LbCharStartDrag(Sender: TObject; var DragObject:
  TDragObject);
begin
  DragItem.Selected := SelWearItemIndex;
  DragItem.Dragedid := 0;
  DragItem.SourceId := WINDOW_WEARS;
  DragObject := DragItem;
  SelWearItemIndex := 0;
end;

procedure TFrmAttrib.LbCharMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i, n: integer;
  CL: TCharClass;
  ImageLib: TA2ImageLib;
begin
  Cl := CharList.GetChar(CharCenterId);
  if Cl = nil then
    exit;

  if Button = mbRight then
  begin
    frmM.ShowA2Form(frmCharAttrib);
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
  SelWearItemIndex := n;
end;

procedure TFrmAttrib.LbCharDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  i, n: integer;
  ImageLib: TA2ImageLib;
  Cl: TCharClass;
begin
  Accept := FALSE;
  OverWearItemIndex := 0;
  if Source <> nil then
  begin
    if TDragItem(Source).SourceID = WINDOW_ITEMS then
    begin
      Accept := TRUE;

      Cl := CharList.GetChar(CharCenterId);
      n := 0;
      for i := 1 to 9 do
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
        MouseInfoStr := WearStrings[n];
        OverWearItemIndex := n;
      end;
    end;
  end;
end;

procedure TFrmAttrib.LbCharDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
  DragItem: TDragItem;
begin
  if Source = nil then
    exit;

  DragItem := TDragItem(Source);
  with cDragDrop do
  begin
    if DragItem.SourceID <> WINDOW_ITEMS then
      exit;

    rmsg := CM_DRAGDROP;
    rsourId := DragItem.DragedId;
    rdestId := 0;
    rsourwindow := DragItem.SourceId;
    rdestwindow := WINDOW_WEARS;
    rsourkey := DragItem.Selected;
    rdestkey := OverWearItemIndex;

    //Connector.SendData(@cDragDrop, sizeof(TCDragDrop))
    frmLogon.SocketAddData(sizeof(TCDragDrop), @cDragDrop)
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
  Cl := CharList.GetChar(CharCenterId);
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
          CharCenterImage.DrawImage(ImageLib.Images[57], ImageLib.Images[57].px
            + 28, ImageLib.Images[57].py + 36, TRUE)
        else
          CharCenterImage.DrawImageGreenConvert(ImageLib.Images[57],
            ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, gc, ga);
      end;
    end;
    OldFeature := Cl.Feature;
    LbChar.A2Image := CharCenterImage;
  end;
end;

procedure TFrmAttrib.ItemLabelDblClick(Sender: TObject);
begin
  if frmNPCTrade.Visible then
  begin
    case frmNPCTrade.DocType of
      DT_Sell, DT_Sell2:
        begin
          DragItem.Selected := TA2ILabel(Sender).Tag;
          DragItem.SourceId := WINDOW_ITEMS;
          DragItem.Dragedid := 0;
          DragItem.sx := 0;
          DragItem.sy := 0;

          frmNPCTrade.listContent.OnDragDrop(frmNPCTrade.listContent, DragItem,
            0, 0);
        end;
    end;
  end
  else
  begin
    SendGlobalClick(CM_DBLCLICK, WINDOW_ITEMS, TA2ILabel(Sender).tag);
  end;
end;

procedure TFrmAttrib.ItemLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
  DragItem: TDragItem;
begin
  if Source = nil then
    exit;
  DragItem := TDragItem(Source);

  case DragItem.SourceID of
    WINDOW_SSAMZIEITEM, WINDOW_GUILDITEMLOG, WINDOW_ITEMS, WINDOW_WEARS,
      WINDOW_SCREEN, WINDOW_TRADE, WINDOW_SALE, WINDOW_SKILL,
      WINDOW_INDIVIDUALMARKET, WINDOW_MARKET: ; // add by minds 020129
  else
    exit;
  end;

  with cDragDrop do
  begin
    rmsg := CM_DRAGDROP;
    rsourId := DragItem.Dragedid;
    rdestId := 0;
    rsx := DragItem.sx;
    rsy := DragItem.sy;
    rdx := 0;
    rdy := 0;
    rsourwindow := DragItem.SourceId;
    rdestwindow := WINDOW_ITEMS;
    rsourkey := DragItem.Selected;
    rdestkey := TA2ILabel(Sender).tag;
  end;
  FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop); // server r
  //   Connector.SendData(@cDragDrop, sizeof(TCDragDrop))
end;

procedure TFrmAttrib.ItemLabelDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source <> nil then
  begin
    // change by minds 020129
    if not (Source is TDragItem) then
      exit;

    case TDragItem(Source).SourceID of
      WINDOW_ITEMS, WINDOW_WEARS, WINDOW_SCREEN,
        WINDOW_SSAMZIEITEM, WINDOW_GUILDITEMLOG, WINDOW_TRADE, WINDOW_SKILL,
        WINDOW_SALE, WINDOW_INDIVIDUALMARKET, WINDOW_MARKET:
        Accept := True;
    end;
  end;
end;

procedure TFrmAttrib.ItemLabelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Temp: TA2ILabel;
begin
  SelectedItemLabel := Ta2ILabel(Sender);
  Temp := Ta2ILabel(Sender);
  if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
  begin
    if temp.A2Image <> nil then
      Temp.BeginDrag(TRUE);
  end;

  MouseInfoStr := Format('<%d>%s', [TA2ILabel(Sender).Font.Color,
    TA2ILabel(Sender).Hint]);

  if Temp.Hint <> '' then
  begin
    KeyIndex := TA2ILabel(Sender).Tag + 1;
    KeyFlag := TRUE;
  end;
end;

procedure TFrmAttrib.ItemLabelStartDrag(Sender: TObject; var DragObject:
  TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_ITEMS;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmAttrib.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y:
  Integer);
begin
  MouseInfoStr := '';
end;

procedure TFrmAttrib.ItemLabelClick(Sender: TObject);
begin
  SendGlobalClick(CM_CLICK, WINDOW_ITEMS, TA2ILabel(Sender).Tag);
end;

procedure TFrmAttrib.ItemLabelPaint(Sender: TObject);
var
  i, int, X, Y: Integer;
  A2ILabel: TA2ILabel;
begin
  A2ILabel := TA2ILabel(Sender);
  if (A2ILabel = nil) or (A2ILabel.A2Image = nil) then
    Exit;

  //-------Add by steven 2004-09-08 11:06---------------------------------------
  SaveKeyImage.Clear(0);
  X := (A2ILabel.Width - A2ILabel.A2Image.Width) div 2;
  Y := (A2ILabel.Height - A2ILabel.A2Image.Height) div 2;
  SavekeyImage.DrawImageGreenConvert(A2ILabel.A2Image, x, y, A2ILabel.GreenCol,
    A2ILabel.GreenAdd);
  case HaveItemList[A2ILabel.Tag].rLockState of
    1:
    begin
      SaveKeyImage.DrawImage(SaveKeyImageLib[24], A2ILabel.Width - 14,
        A2ILabel.Height - 12, True);
    end;
    2:
    begin
      SaveKeyImage.DrawImage(SaveKeyImageLib[25], A2ILabel.Width - 14,
        A2ILabel.Height - 12, True);
    end;
  end;
  //这句代码最后删除
  //SaveKeyImage.DrawImage(SaveKeyImageLib[24], A2ILabel.Width - 14,
  //  A2ILabel.Height - 14, True);
  //

  A2DrawImage(A2ILabel.Canvas, 0, 0, SaveKeyImage);
  //----------------------------------------------------------------------------

  for i := 0 to KeyMaxSize - 1 do
  begin
    int := KeyBuffer[i];
    if A2ILabel.Tag + 1 <> int then
      Continue;
    {
    Delete by steven 2004-09-08 11:10
    SaveKeyImage.Clear(0);
    X := (A2ILabel.Width - A2ILabel.A2Image.Width) div 2;
    Y := (A2ILabel.Height - A2ILabel.A2Image.Height) div 2;
    SaveKeyImage.DrawImageGreenConvert(A2ILabel.A2Image, x, y,
      A2ILabel.GreenCol, A2ILabel.GreenAdd);

    SaveKeyImage.DrawImage(SaveKeyImageLib[24], A2ILabel.Width - 12,
      A2ILabel.Height - 12, True);
    A2DrawImage(A2ILabel.Canvas, 0, 0, SaveKeyImage);
    }
    SaveKeyImage.DrawImage(SaveKeyImageLib[i + 10], 1, 1, TRUE);
      //Add by steven 2004-09-07
    A2DrawImage(A2ILabel.Canvas, 0, 0, SaveKeyImage);
      //是这个两个函数来控制绘图SaveKeyImage
    Exit;
  end;
  //Add by steven 2004-09-07 16:35
end;

procedure TFrmAttrib.ItemLabelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) and (TControl(Sender).Hint <> '') then
  begin
    SelectHaveItem := TA2ILabel(Sender).Tag;
    SendGlobalClick(CM_SELECTITEMWINDOW, WINDOW_ITEMS, TA2ILabel(Sender).Tag);
  end;
end;

///////////////////

procedure TFrmAttrib.btnMagicTabClick(Sender: TObject);
begin
  PanelSelect(2, Conv('武功'));
end;

procedure TFrmAttrib.btnBasicMagicTabClick(Sender: TObject);
begin
  PanelSelect(3, Conv('基本武功'));
end;

procedure TFrmAttrib.btnRiseMagicTabClick(Sender: TObject);
begin
  PanelSelect(4, Conv('上层武功'));
end;

procedure TFrmAttrib.SendGlobalClick(AMsg, AWin, AIndex: integer);
begin
  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);

  with GrobalClick do
  begin
    rmsg := AMsg;
    rwindow := AWin;
    rclickedId := 0;
    rShift := KeyShift;
    rkey := AIndex;
  end;
end;

procedure TFrmAttrib.lblMagicClick(Sender: TObject);
begin
  SendGlobalClick(CM_CLICK, CurrentWindow, TA2ILabel(Sender).Tag);
end;

procedure TFrmAttrib.lblMagicDblClick(Sender: TObject);
begin
  SendGlobalClick(CM_DBLCLICK, CurrentWindow, TA2ILabel(Sender).Tag);
end;

procedure TFrmAttrib.lblMagicStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := CurrentWindow;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmAttrib.lblMagicDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source = nil then
    exit;

  if TDragItem(Source).SourceID = CurrentWindow then
  begin
    Accept := TRUE;
  end;
end;

procedure TFrmAttrib.lblMagicDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  cDragDrop: TCDragDrop;
  DragItem: TDragItem;
begin
  if Source = nil then
    exit;
  DragItem := TDragItem(Source);

  with cDragDrop do
  begin
    if DragItem.SourceID <> CurrentWindow then
      exit;
    rmsg := CM_DRAGDROP;
    rsourId := DragItem.Dragedid;
    rdestId := 0;
    rsx := DragItem.sx;
    rsy := DragItem.sy;
    rdx := 0;
    rdy := 0;
    rsourwindow := DragItem.SourceId;
    rdestwindow := CurrentWindow;
    rsourkey := DragItem.Selected;
    rdestkey := TA2ILabel(Sender).Tag;
  end;
  FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  //   Connector.SendData(@cDragDrop, sizeof(TCDragDrop))
end;

procedure TFrmAttrib.lblMagicMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbRight) and (TControl(Sender).Hint <> '') then
  begin
    SendGlobalClick(CM_SELECTITEMWINDOW, CurrentWindow, TA2ILabel(Sender).Tag);
  end;
end;

procedure TFrmAttrib.lblMagicMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  A2ILabel: TA2ILabel;
begin
  Last_X := X;
  SelectedMagicLabel := TA2ILabel(Sender);
  A2ILabel := TA2ILabel(Sender);
  if (x < 0) or (y < 0) or (x > A2ILabel.Width) or (y > A2ILabel.Height) then
  begin
    if A2ILabel.Hint <> '' then
      A2ILabel.BeginDrag(TRUE);
  end;
  MouseInfoStr := A2ILabel.Hint;
  if A2ILabel.Hint <> '' then
  begin
    case CurrentWindow of
      WINDOW_MAGICS: KeyIndex := A2ILabel.Tag + HAVEMAGICSIZE+1;         //F5快捷键生效
      WINDOW_BASICFIGHT: KeyIndex := A2ILabel.Tag + HAVEMAGICSIZE*2+1;
      WINDOW_RISEMAGICS: KeyIndex := A2ILabel.Tag + HAVEMAGICSIZE*3+1;
      WINDOW_MYSTERYMAGICS: KeyIndex := A2ILabel.Tag + HAVEMAGICSIZE*4+1;
      WINDOW_BESTMAGIC: KeyIndex := A2ILabel.Tag + HAVEMAGICSIZE*5+1;
    else
      exit;
    end;
    KeyFlag := TRUE;
  end;
end;

procedure TFrmAttrib.lblMagicPaint(Sender: TObject);
begin
  case CurrentWindow of
    WINDOW_MAGICS: DrawMagicIcon(Sender, HAVEMAGICSIZE);       //一层    武功显示的地方会变
    WINDOW_BASICFIGHT: DrawMagicIcon(Sender, HAVEMAGICSIZE*2);   //  基本
    WINDOW_RISEMAGICS: DrawMagicIcon(Sender, HAVEMAGICSIZE*3);    //  二层
    WINDOW_MYSTERYMAGICS: DrawMagicIcon(Sender, HAVEMAGICSIZE*4); //  掌法
    WINDOW_BESTMAGIC: DrawMagicIcon(Sender, HAVEMAGICSIZE*5);      //  三层
  end;
end;

procedure TFrmAttrib.SetMagicData(aIndex, aShape: integer; aName: string;
  aLevel: integer);
begin
  if (aIndex < 0) or (aIndex >= HAVEMAGICSIZE*5) then
    exit;

  MagicData[aIndex].rShape := aShape;
  MagicData[aIndex].rMagicName := aName;

  if aLevel = 0 then
    //   if (aIndex >= 120) and (aIndex < 135) then // 檬侥狼 版快 殿鞭钎矫 绝澜
    MagicData[aIndex].rMagicHint := aName
  else
    MagicData[aIndex].rMagicHint := aName + ':' + Get10000To100(aLevel);

    KeyRepaint(aIndex + HAVEMAGICSIZE+1);     //移动武功时，图标跟着移动，按武功的格子算

  // 诀单捞飘等 公傍捞 泅犁 荤侩吝牢 公傍老锭
  if MagicData[aIndex].rMagicName = frmBottom.UseMagicList[0].Caption then
  begin
    frmBottom.SetSkillLevelGauge(Get10000To100(aLevel));
  end;
end;

procedure TFrmAttrib.DrawMagicIcon(Sender: TObject; MagicSub: integer);
var
  i, index: integer;
  ILabel: TA2ILabel;
begin
  ILabel := TA2ILabel(Sender);
  savekeyImage.Clear(0);

  // Draw Back Panel
  savekeyImage.DrawImage(AtzClass.GetMagicImage(0), 0, 0, FALSE);

  index := MagicSub - HAVEMAGICSIZE + ILabel.Tag;      //按武功格子数算，数字小，会往前跑
  if (index < 0) or (index >= HAVEMAGICSIZE*5) then
    exit;

  if MagicData[index].rShape <> 0 then
  begin
    savekeyImage.DrawImage(AtzClass.GetMagicImage(MagicData[index].rShape), 4,
      3, FALSE);
  end;

  // Check and Draw Shortcut
  for i := 0 to KeyMaxSize - 1 do
  begin
    if (KeyBuffer[i] - MagicSub) = ILabel.Tag + 1 then
    begin
      savekeyImage.DrawImage(savekeyImagelib[i + 10], 1, 1, TRUE);
      break;
    end;
  end;

  // Draw Image
  A2DrawImage(TA2ILabel(Sender).Canvas, 0, 0, savekeyImage);
  ILabel.Hint := MagicData[index].rMagicHint;
end;

procedure TFrmAttrib.PanelSelect(iPanel: integer; LabelText: string);
begin
  if FrmMiniMap.Visible then
    FrmMiniMap.Visible := False;

  if iPanel = -1 then
    iPanel := nLastMagicWindow;

  Visible := True;

  LbWindowName.Caption := LabelText;
  LbMoney.Caption := LabelText;

  PanelItem.Visible := (iPanel = 1);
  PanelMagics.Visible := (iPanel in [2..5]);
  PanelBest.Visible := (iPanel = 6);

  case iPanel of
    1:
      begin
        CurrentWindow := WINDOW_ITEMS;
      end;
    2:
      begin
        btnMagicTab.UpImage := btnMagicTab.DownImage;
        btnBasicMagicTab.UpImage := imgBasicMagic.Picture;
        btnRiseMagicTab.UpImage := imgRiseMagic.Picture;
        CurrentWindow := WINDOW_MAGICS;
        nLastMagicWindow := 2;
        PanelMagics.Repaint;
      end;
    3:
      begin
        btnMagicTab.UpImage := imgMagic.Picture;
        btnBasicMagicTab.UpImage := btnBasicMagicTab.DownImage;
        btnRiseMagicTab.UpImage := imgRiseMagic.Picture;
        CurrentWindow := WINDOW_BASICFIGHT;
        nLastMagicWindow := 3;
        PanelMagics.Repaint;
      end;
    4:
      begin
        btnMagicTab.UpImage := imgMagic.Picture;
        btnBasicMagicTab.UpImage := imgBasicMagic.Picture;
        btnRiseMagicTab.UpImage := btnRiseMagicTab.DownImage;
        CurrentWindow := WINDOW_RISEMAGICS;
        nLastMagicWindow := 4;
        PanelMagics.Repaint;
      end;
    5:
      begin
        CurrentWindow := WINDOW_MYSTERYMAGICS;
        PanelMagics.Repaint;
      end;
    6:
      begin
        CurrentWindow := WINDOW_BESTMAGIC;
      end;
  end;

  if iPanel in [2..4] then
  begin
    btnMagicTab.Visible := True;
    btnMagicTab.Repaint;
    btnBasicMagicTab.Visible := True;
    btnBasicMagicTab.Repaint;
    btnRiseMagicTab.Visible := True;
    btnRiseMagicTab.Repaint;
  end
  else
  begin
    btnMagicTab.Visible := False;
    btnBasicMagicTab.Visible := False;
    btnRiseMagicTab.Visible := False;
  end;
end;

function TFrmAttrib.FindMagicIndex(const aMagicName: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to HAVEMAGICSIZE*5 - 1 do
  begin
    if MagicData[i].rMagicName = aMagicName then
    begin
      Result := i;
      break;
    end;
  end;
end;

function TFrmAttrib.GetMagicSkillLevel(const aMagicName: string): string;
var
  i: integer;
  str: string;
begin
  Result := '';
  for i := 0 to HAVEMAGICSIZE*5 - 1 do
  begin
    if MagicData[i].rMagicName = aMagicName then
    begin
      str := MagicData[i].rMagicHint;
      GetValidStr4(str, ':');
      Result := str;
    end;
  end;
end;

function TFrmAttrib.HaveSomeItem(const strItemName: string; iNeedCount:
  integer): integer;
var
  i, iCount: integer;
  str, strItem: string;
begin
  Result := -1;

  for i := 0 to HAVEITEMSIZE - 1 do  //for i := 0 to 30 - 1 do
  begin
    str := GetValidStr3(ILabels[i].Hint, strItem, ':');
    if strItem = strItemName then
    begin
      iCount := _StrToInt(str);
      if iCount = 0 then
        iCount := 1;
      if iCount >= iNeedCount then
      begin
        Result := i;
        exit;
      end;
    end;
  end;
end;

procedure TFrmAttrib.DrawGuildEnergy(AValue: Integer);
begin
  if (AValue >= 0) and (AValue <= 9) then
    //lblGuildEnergy.A2Image.DrawImage(GuildImageLib[AValue], 0, 0, True);
end;

end.

