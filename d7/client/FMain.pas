{
  2004-09-17 ÀîÕýçäÏÈÉú½â¾öCPUÕ¼ÓÃ¹ý¸ßµÄÎÊÌâ
  2004-09-21 Steven½â¾öÎïÆ·À¸¼ÓËøÏÔÊ¾²»Õý³£µÄBug

  
}

unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, Cltype, A2Form, A2Img, uAnsTick,
  ExtCtrls, StdCtrls, BackScrn, CharCls, ClMap, AtzCls, Deftype, subutil,
  PaintLabel, objcls, tilecls, adeftype, AUtil32, IniFiles, CTable, mmsystem,
  uPersonBat, uSoundManager, clvar;

type
  TFormData = record
    rForm: TForm;
    rOldParent: integer;
    rA2Form: TA2Form;
  end;
  PTFormData = ^TFormData;

  TFrmM = class(TForm)
    PaintLabel: TPaintLabel;
    Timer1: TTimer;
    DXDraw: TDXDraw;
    DXTimer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure PaintLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure PaintLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure PaintLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure PaintLabelClick(Sender: TObject);
    procedure PaintLabelDblClick(Sender: TObject);
    procedure PaintLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PaintLabelDragOver(Sender, Source: TObject; X, Y: Integer; State:
      TDragState; var Accept: Boolean);
    procedure PaintLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure Time1TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DXTimer1Timer(Sender: TObject);
  private
    { Private declarations }
    function GetMouseDirection: word;
  public
    FormList: TList;

    procedure AddA2Form(aform: TForm; aA2Form: TA2Form);
    procedure DelA2Form(aform: TForm; aA2Form: TA2Form);
    procedure SaveAndDeleteAllA2Form;
    procedure RestoreAndAddAllA2Form;
    procedure SetA2Form(aForm: TForm; aA2Form: TA2Form);
    procedure ShowA2Form(aform: TForm);
  public
    EventTick: integer;
    DragItem: TDragItem;

    BottomUpImage: TA2Image;
    AttribLeftImage: TA2Image;

    //    ChatList : TStringList;
    //    procedure AddChat ( astr: string; fcolor, bcolor: integer);
    procedure MoveProcess;
    procedure CheckAndSendClick;
    procedure MessageProcess(var code: TWordComData);
procedure changeScreen();
    procedure OnAppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure CheckSome(var code: TWordComData);
    procedure OnAppActivate(Sender: TObject);
    procedure OnAppDeactivate(Sender: TObject);
    // add by minds 020624 Modal FormÀÌ ¿­·ÁÀÖ´ÂÁö check
    function OtherFormOpened: Boolean;
  end;

var
  FrmM: TFrmM;
  Keyshift: TShiftState;
  GrobalClick: TCClick;
  ClickTick: integer = 0;
  HitTick: integer = 0;
  boShiftAttack: Boolean = TRUE;
  mousecheck: boolean = FALSE;
  RightButtonDown: Boolean = FALSE;

  mouseX, mousey: integer;
  MouseCellX, MouseCelly: integer;

  boShowChat: Boolean = FALSE;

  ClientIni: TIniFile;
  // Sound
  BaseSound: TBaseSound = nil;
  ATWaveLib: TATWaveLib = nil;
  BASEVOLUME: integer = -2000;
  EffectVolume: integer = -2000;

  // System Info
  DriverName, GraphicCard: PChar;
  CPUSpeed, TotalMemory: integer;

  GuildListInfo: TSGuildListInfo;

  fwide800: Integer = 800;     //¸ß
  fheight600: Integer = 600;   //¸ß
  fwide: integer = 1024;       //¿í
  fhei: integer = 768;         //¿í
  G_Default800: Boolean = true ;//  Ä¬ÈÏ800  False      true


function IsDebuggerPresent: LongBool; external kernel32 name
  'IsDebuggerPresent';

implementation

uses
  FLogOn, FSelChar, FBottom, FAttrib, FQuantity, FSearch, FExchange, FSound,
    FDepository,
  FbatList, FMuMagicOffer, FcMessageBox, FMiniMap, FPassEtc, FEnergy,
  FHelp, FItemHelp, FNPCTrade, Log, FSkill, Registry, FHistory,
  FEventInput, uCookie, FBestMagic, FSpecialMagic, FCharAttrib, uImage,
  FTeamMember, FInputDialog, FConfirmDialog, FGuildInfo;

{$R *.DFM}
{$O+}
var
  eventbuffer: array[0..10 - 1] of integer;

  // add by minds 020624 Modal FormÀÌ ¿­·ÁÀÖ´ÂÁö check

function TFrmM.OtherFormOpened: Boolean;
begin
  Result := (frmNPCTrade.Visible or frmHelp.Visible
    or frmSkill.Visible or frmExchange.Visible
    or frmCMessageBox.Visible or frmDepository.Visible
    or frmQuantity.Visible);
  // or frmTrade.Visible; Áß±¹Àº TradeÃ¢ Áö¿ø¾ÈÇÔ 030723
end;

procedure TFrmM.OnAppActivate(Sender: TObject);
begin
  // change by minds 020222
  BaseSound.Continue;
end;

procedure TFrmM.OnAppDeactivate(Sender: TObject);
begin
  // change by minds 020222
  BaseSound.Pause;
end;

procedure TFrmM.SetA2Form(aForm: TForm; aA2Form: TA2Form);
var
  flag: Boolean;
  i: integer;
  pf: PTFormData;
begin
  if (Formlist.Count > 0) and (PTFormData(FormList[0])^.rForm = aForm) then
    exit;

  for i := 0 to FormList.Count - 1 do
  begin
    pf := FormList[i];
    if pf^.rForm = aForm then
    begin
      FormList.Delete(i);
      FormList.Insert(0, pf);
      break;
    end;
  end;

  for i := 0 to FormList.count - 1 do
  begin
    pf := FormList[i];
    flag := pf^.rForm.Visible;
    pf^.rForm.visible := FALSE;
    pf^.rForm.parentwindow := 0;
    pf^.rForm.parentwindow := handle;
    pf^.rForm.visible := flag;
  end;
end;

procedure TFrmM.SaveAndDeleteAllA2Form;
var
  i: integer;
  pf: PTFormData;
begin
  for i := 0 to FormList.Count - 1 do
  begin
    pf := FormList[i];
    pf^.rForm.ParentWindow := pf^.roldParent;
  end;
end;

procedure TFrmM.RestoreAndAddAllA2Form;
var
  i: integer;
  pf: PTFormData;
begin
  for i := 0 to FormList.Count - 1 do
  begin
    pf := FormList[i];
    pf^.rForm.ParentWindow := Handle;
  end;
end;

procedure TFrmM.DelA2Form(aform: TForm; aA2Form: TA2Form);
var
  i: integer;
  pf: PTFormData;
begin
  for i := 0 to FormList.Count - 1 do
  begin
    pf := FormList[i];
    if pf^.rForm = aform then
    begin
      aForm.ParentWindow := pf^.roldParent;
      dispose(pf);
      FormList.Delete(i);
      exit;
    end;
  end;
end;

procedure TFrmM.ShowA2Form(aForm: TForm);
var
  i: integer;
  pf: PTFormData;
begin
  for i := 0 to FormList.Count - 1 do
  begin
    pf := FormList[i];

    // »õ·Î¶ã A2FormÀ» ±×¸®±â¼ø¼­ Á¦ÀÏ ³ªÁß(»óÀ§È­¸é)¿¡ º¸ÀÌ°Ô²ûÇÔ
    if (pf^.rForm = aForm) then
    begin
      if i > 0 then
      begin
        FormList.Delete(i);
        FormList.Insert(0, pf);
      end;
      break;
    end;
  end;

  for i := 1 to FormList.Count - 1 do
  begin
    pf := FormList[i];

    // ±âÁ¸¿¡ ¶°ÀÖ´Â ÃÖ»óÀ§ A2FormÀ» »õ·Î¶ã A2Formº¸´Ù µÚ·Î °¡°Ô²ûÇÔ
    if pf^.rForm.Visible then
    begin
      SetWindowPos(pf^.rForm.handle, aForm.handle, 0, 0, 0, 0, SWP_NOSIZE or
        SWP_NOMOVE);
      break;
    end;
  end;
  aForm.Visible := True;
  aForm.ParentWindow := Handle;
end;

procedure TFrmM.AddA2Form(aform: TForm; aA2Form: TA2Form);
var
  pf: PTFormData;
begin
  new(pf);
  pf^.rOldParent := aForm.parentWindow;
  aForm.ParentWindow := Handle;
  pf^.rForm := aForm;
  pf^.rA2Form := aA2Form;
  FormList.Add(pf);
end;

procedure TFrmM.OnAppMessage(var Msg: TMsg; var Handled: Boolean);
var
  ckey: TCKey;
begin
  // change by minds.
  if (GetAsyncKeyState(VK_SNAPSHOT) <> 0) and FrmM.Active then
  begin
    ckey.rmsg := CM_GETTIME;
    ckey.rkey := 0;
    frmLogon.SocketAddData(SizeOf(TCKey), @ckey);
  end;

  if (Msg.message >= WM_MOUSEMOVE) and (Msg.message <= WM_MBUTTONDBLCLK) then
  begin
    inc(eventbuffer[Msg.message - WM_MOUSEMOVE]);
  end;
end;

procedure TFrmM.CheckSome(var code: TWordComData);
var
  PsSCheck: PTSCheck;
  CCheck: TCCheck;
begin
  PsSCheck := @Code.data;
  case PsSCheck^.rCheck of
    1:
      begin
        CCheck.rMsg := CM_CHECK;
        CCheck.rCheck := PsSCheck^.rCheck;
        CCheck.rTick := 1;
        if not FileExists('.\South.map') then
          CCheck.rTick := 0;
        if not FileExists('.\Southobj.obj') then
          CCheck.rTick := 0;
        if not FileExists('.\Southrof.Obj') then
          CCheck.rTick := 0;
        if not FileExists('.\Southtil.til') then
          CCheck.rTick := 0;
      end;
    2:
      begin
        CCheck.rMsg := CM_CHECK;
        CCheck.rCheck := PsSCheck^.rCheck;
        CCheck.rTick := TimeGetTime;
      end;
  end;
  FrmLogOn.SocketAddData(sizeof(CCheck), @CCheck);
end;

procedure TFrmM.FormCreate(Sender: TObject);
var
  tmpStr: string;
  //   RegKey: TRegistry;
begin

  if G_Default800 then
  begin
    ClientHeight := 600;
    ClientWidth := 800;
    DXDraw.Display.Width := fwide800;
    DXDraw.Display.Height := fheight600;
    DXDraw.SurfaceHeight := fheight600;
    DXDraw.SurfaceWidth := fwide800;
  end else
  begin
    ClientHeight := 768;
    ClientWidth := 1024;
    DXDraw.Display.Width := fwide;
    DXDraw.Display.Height := fhei;
    DXDraw.SurfaceHeight := fhei;
    DXDraw.SurfaceWidth := fwide;
  end;



{$IFDEF _DEBUG}
  DXDraw.Options := DXDraw.Options - [doFullScreen];
{$ENDIF}
  Caption := DateToStr(Date) + ' ' + TimeToStr(Time);
  if doFullScreen in DxDraw.Options then
    BorderStyle := bsNone
  else
    BorderStyle := bsDialog;

  tmpStr := ExtractFilePath(Application.ExeName);
  Chdir(tmpStr);

  ClientIni := TIniFile.Create('.\ClientIni.ini');
  mainFont := ClientIni.ReadString('FONT', 'FontName', 'Arial'); // font read
  // FrmM Font Set
  FrmM.Font.Name := mainFont;
  A2FontClass.SetFont(MainFont);

  FormList := TList.Create;

  BottomUpImage := TA2Image.Create(4, 4, 0, 0);
  //   BottomUpImage.LoadFromFile ('bottomup.bmp');
  BottomUpImage.LoadFromFile('bottomup.bmp');
  AttribLeftImage := TA2Image.Create(4, 4, 0, 0);
  AttribLeftImage.LoadFromFile('attribleft.bmp');

  BackScreen := TBackScreen.Create;
  DragItem := TDragItem.Create;
  TileDataList := TTileDataList.Create;
  ObjectDataList := TObjectDataList.Create;
  RoofDataList := TObjectDataList.Create;

  Map := TMap.Create;
  //   EffectPositionClass := TEffectPositionClass.Create;
  Animater := TAnimater.Create;
  AtzClass := TAtzClass.Create('.\sprite\');
  EtcAtzClass := TEtcAtzClass.Create(MUN_ETC_ATZ);
  EtcViewClass := TEtcAtzClass.Create(ETC_VIEW_ATZ); //

  CharList := TCharList.Create(AtzClass);
  //   ChatList := TStringList.Create;

  PersonBat := TPersonBat.Create;

  BaseSound := TBaseSound.Create;
  ATWaveLib := TATWaveLib.Create(Self.Handle);
  ATWaveLib.LoadFormFile('wav\effect.atw');
  BASEVOLUME := ClientIni.ReadInteger('SOUND', 'BASEVOLUME', -2000);
  EFFECTVOLUME := ClientIni.ReadInteger('SOUND', 'EFFECTVOLUME', -2000);
  BaseSound.SetVolume(BASEVOLUME);
  BaseSound.play('wav\logon.wav', True);

  Application.OnMessage := OnAppMessage;
  Application.OnActivate := OnAppActivate;
  Application.OnDeactivate := OnAppDeactivate;

end;

procedure TFrmM.FormDestroy(Sender: TObject);
begin
  // add by minds 020222
  Application.OnMessage := nil;
  Application.OnActivate := nil;
  Application.OnDeactivate := nil;

  BaseSound.Free;
  ATWaveLib.Free;
  BaseSound := nil;

  ClientIni.WriteString('FONT', 'FontName', mainFont);

  ClientIni.WriteInteger('SOUND', 'BASEVOLUME', BASEVOLUME);
  ClientIni.WriteInteger('SOUND', 'EFFECTVOLUME', EFFECTVOLUME);

  //   ChatList.free;
  CharList.Free;
  AtzClass.Free;
  Animater.Free;
  EtcAtzClass.Free;
  Map.Free;

  TileDataList.Free;
  ObjectDataList.Free;
  RoofDataList.Free;

  DragItem.Free;
  BackScreen.Free;

  AttribLeftImage.Free;
  BottomUpImage.Free;

  PersonBat.Free;

  FormList.Free;
  ClientIni.Free;

  //   CloseMFGS;
end;

procedure TFrmM.DXDrawInitialize(Sender: TObject);
const
  first: Boolean = TRUE;
begin
  if first then
  begin
    first := FALSE;
    DxTimer1.Enabled := TRUE;
    FrmLogon.visible := TRUE;
    FrmLogon.FormActivate(Self);
  end;
end;

function TFrmM.GetMouseDirection: word;
var
  xx, yy: integer;
  MCellX, MCellY: integer;
  Cl, Sl: TCharClass;
begin
  Result := DR_DONTMOVE;
  Cl := CharList.GetChar(CharCenterId);
  if cl = nil then
    exit;
  xx := BackScreen.Cx + (Mousex - BackScreen.SWidth div 2);
  yy := BackScreen.Cy + (Mousey - BackScreen.SHeight div 2);

  MCellX := xx div UNITX;
  MCellY := yy div UNITY;

  if SelectedChar <> 0 then
  begin
    SL := CharList.GetChar(SelectedChar);
    if SL <> nil then
    begin
      MCellX := Sl.X;
      MCellY := SL.Y;
    end;
  end;

  Result := GetViewDirection(cl.x, cl.y, mcellx, mcelly);
end;

var
  SelScreenId: integer = 0;
  SelScreenX: integer = 0;
  SelScreenY: integer = 0;

procedure TFrmM.PaintLabelClick(Sender: TObject);
var
  key: word;
  cHit: TCHit;
  CL: TCharClass;
  CLAtt: TCharClass;
  UserFlag: Boolean; // »ç¶÷ÀÎÁö ¾Æ´ÑÁö ±¸º°°ª
  AttactFlag: Boolean;

  iID: integer;
begin
  if OtherFormOpened then
    exit;

  UserFlag := FALSE;
  AttactFlag := FALSE;
  if (ssShift in KeyShift) then
  begin
    UserFlag := FALSE;
    AttactFlag := TRUE;
  end;
  if (ssCtrl in KeyShift) then
  begin
    UserFlag := TRUE;
    AttactFlag := TRUE;
  end;
  // ankudo 020213 shift ÀÏ°æ¿ì ¸ó½ºÅÍ¸¸ °¡´É CtrlÀÏ °æ¿ì »ç¶÷¸¸ °¡´É ³ª¸ÓÁø ´Ù Àû¿ë
  if AttactFlag then
  begin
    if mmAnsTick < HitTick + 200 then
      exit;
    if boShiftAttack = FALSE then
      exit;
    HitTick := mmAnsTick;
    Cl := CharList.GetChar(CharCenterId);
    if Cl = nil then
      exit;
    if Cl.Feature.rfeaturestate = wfs_die then
      exit;

    // add by minds 021210 CastingÁß Å¬¸¯±ÝÁö
    if Cl.isCasting then
      exit;
    if Cl.Feature.rActionState = as_ice then
      exit;

    if SelectedChar <> 0 then
    begin
      CLAtt := CharList.GetChar(SelectedChar);
      if CLAtt = nil then
        exit;
      if UserFlag and (CLAtt.Feature.rrace = RACE_MONSTER) then
        exit;
      if not UserFlag and (CLAtt.Feature.rrace = RACE_HUMAN) then
        exit;
      cHit.rtx := CLAtt.x;
      cHit.rty := CLAtt.y;
    end
    else
    begin
      MouseCellX := (BackScreen.Cx - BackScreen.SWidth div 2 + Mousex) div
        UNITX;
      MouseCellY := (BackScreen.Cy - BackScreen.SHeight div 2 + Mousey) div
        UNITY;
      cHit.rtx := MouseCellX;
      cHit.rty := MouseCellY;
    end;

    cHit.rmsg := CM_HIT;
    cHit.rkey := GetMouseDirection;

    // change by minds 020313
    //   cHit.rtid := SelectedChar
    if (SelectedChar = 0) and (SelectedDynamicItem <> 0) then
      cHit.rtid := SelectedDynamicItem
    else
      cHit.rtid := SelectedChar;

    cHit.rtx := MouseCellX;
    cHit.rty := MouseCellY;
    Frmlogon.SocketAddData(sizeof(cHit), @cHit);

    if cHit.rkey <> Cl.dir then
      //CL.ProcessMessage (SM_TURN, cHit.rkey, cl.x, cl.y, cl.feature, 0);
      Cl.SetTurn(cHit.rkey);

    // change by minds 021120 {Àå¹ý µ¿ÀÛ ±¸Çö}
    case Cl.Feature.rHitMotion of
      AM_HELLO, AM_MOTION: ;
      AM_HIT10, AM_HIT11: ;
      {
      AM_HIT10:
         if cHit.rtid <> 0 then begin
            CL.ProcessMessage (SM_MOTION, cHit.rkey, cl.x, cl.y, cl.feature, AM_HIT10_READY);
            Cl.SetCasting(true);
         end;
         }
    else
      //CL.ProcessMessage (SM_MOTION, cHit.rkey, cl.x, cl.y, cl.feature, Cl.Feature.rhitmotion);
      Cl.SetMotion(Cl.Feature.rhitmotion);
    end;
    exit;
    {
    if (Cl.Feature.rHitMotion <> 5) and (Cl.Feature.rHitMotion <> 6) then
       CL.ProcessMessage (SM_MOTION, cHit.rkey, cl.x, cl.y, cl.feature, Cl.Feature.rhitmotion);
    exit;
    }
  end;

  iID := 0;
  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);
  key := GetMouseDirection;

  // add by minds 020618
  if SelectedDynamicItem <> 0 then
    iID := SelectedDynamicItem;
  if SelectedChar <> 0 then
    iID := SelectedChar;
  if SelectedItem <> 0 then
    iID := SelectedItem;

  MouseCellX := (BackScreen.Cx - BackScreen.SWidth div 2 + Mousex) div UNITX;
  MouseCellY := (BackScreen.Cy - BackScreen.SHeight div 2 + Mousey) div UNITY;

  GrobalClick.rmsg := CM_CLICK;
  GrobalClick.rwindow := WINDOW_SCREEN;
  GrobalClick.rclickedId := iID;
  GrobalClick.rShift := KeyShift;
  GrobalClick.rkey := key;
  GrobalClick.rx := MouseCellX;
  GrobalClick.ry := MouseCellY;
end;

procedure TFrmM.PaintLabelDblClick(Sender: TObject);
var
  iID: integer;
  Cl: TCharClass;
begin
  if OtherFormOpened then
    exit;

  Cl := CharList.GetChar(CharCenterId);
  if Cl = nil then
    exit;
  if Cl.isCasting then
    exit;

  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);

  iID := 0;
  if SelectedDynamicItem <> 0 then
    iID := SelectedDynamicItem;
  if SelectedChar <> 0 then
    iID := SelectedChar;
  if SelectedItem <> 0 then
    iID := SelectedItem;

  GrobalClick.rmsg := CM_DBLCLICK;
  GrobalClick.rwindow := WINDOW_SCREEN;
  GrobalClick.rclickedId := iID;
  GrobalClick.rShift := KeyShift;
  GrobalClick.rkey := GetMouseDirection;

  MouseCellX := (BackScreen.Cx - BackScreen.SWidth div 2 + Mousex) div
    UNITX;
  MouseCellY := (BackScreen.Cy - BackScreen.SHeight div 2 + Mousey) div
    UNITY;
  GrobalClick.rX := MouseCellX;
  GrobalClick.rY := MouseCellY;



end;

procedure TFrmM.PaintLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop; //steven 20040907
begin
  if Source = nil then
    Exit;


  with Source as TDragItem do
  begin
    //Add by steven 2004-09-07 20:53
    //
    {
      TDragItem = class (TDragObject)
        Selected: integer;
        Dragedid: integer;
        StdMode: byte;
        SourceID: Integer;
        sx, sy : word;
      end;
    }

    if HaveItemList[Selected].rLockState <> 0 then
    begin
      ChatMan.AddChat(Conv('¹óÖØÎïÆ·ÒÑ¼ÓËø£¬Çë²»ÒªËæÊÖÂÒÈÓ£¡'), WinRGB(22, 22, 0), 0);
      Exit;
    end;



    case SourceID of
      WINDOW_ITEMS: ;
      WINDOW_SCREEN: ;
      WINDOW_SHORTCUT:
        begin
          frmBottom.ClearShortcut(Selected);
          exit;
        end;
    else
      exit;
    end;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := DragedId;

    cDragDrop.rdestId := 0;
    if SelectedDynamicItem <> 0 then
      cDragDrop.rdestId := SelectedDynamicItem;
    if Selecteditem <> 0 then
      cDragDrop.rdestId := SelectedItem;
    if SelectedChar <> 0 then
      cDragDrop.rdestId := SelectedChar;
    cdragdrop.rsx := sx;
    cdragdrop.rsy := sy;
    cdragdrop.rdx := mouseCellx;
    cdragdrop.rdy := mouseCelly;

    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_SCREEN;
    case SourceId of
      WINDOW_ITEMS: cDragDrop.rsourkey := Selected;
      WINDOW_WEARS: cDragDrop.rsourkey := Selected;
    end;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  end;
end;

procedure TFrmM.PaintLabelDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Cl: TCharClass;
  IT: TItemClass;
  AIT: TDynamicObject;
begin


  mouseX := x;
  mousey := y;

  MouseCellX := (BackScreen.Cx - BackScreen.SWidth div 2 + Mousex) div UNITX;
  MouseCellY := (BackScreen.Cy - BackScreen.SHeight div 2 + Mousey) div UNITY;

  CharList.MouseMove(BackScreen.Cx + (Mousex - BackScreen.SWidth div 2),
    BackScreen.Cy + (Mousey - BackScreen.SHeight div 2));
  if (SelectedChar = 0) and (SelectedItem = 0) then
    MouseInfoStr := '';
  if SelectedChar <> 0 then
  begin
    Cl := CharList.GetChar(SelectedChar);
    if Cl <> nil then
      MouseInfoStr := Cl.Name;
  end;
  if SelectedItem <> 0 then
  begin
    IT := CharList.GetItem(SelectedItem);
    MouseInfoStr := IT.ItemName;
  end;
  if SelectedDynamicItem <> 0 then
  begin // aniItem add by 001217
    AIT := CharList.GetDynamicObjItem(SelectedDynamicItem);
    MouseInfoStr := AIT.DynamicObjName;
  end;

  Accept := FALSE;
  if OtherFormOpened then
    exit;

  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_ITEMS then
        Accept := TRUE;
      if SourceID = WINDOW_SCREEN then
        Accept := TRUE;
      if SourceID = WINDOW_SHORTCUT then
        Accept := TRUE;
    end;
  end;
end;

procedure TFrmM.PaintLabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mousex := x;
  mousey := y;
  if mbRight = Button then
  begin
    mousecheck := TRUE;
    if not OtherFormOpened then
      RightButtonDown := TRUE;
    exit;
  end;
  SelScreenId := 0;
  if SelectedChar <> 0 then
    SelScreenId := SelectedChar;

  if SelectedItem <> 0 then
    SelScreenId := SelectedItem;

  if SelScreenId <> 0 then
  begin
    SelScreenX := x;
    SelScreenY := y;
  end
  else
  begin
    SelScreenX := 0;
    SelScreenY := 0;
  end;
end;

procedure TFrmM.PaintLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
  Integer);
var
  Cl: TCharClass;
  IT: TItemClass;
  AIT: TDynamicObject;
begin
  mouseX := x;
  mousey := y;

  if RightButtonDown then
    mousecheck := TRUE;
  CharList.MouseMove(BackScreen.Cx + (Mousex - BackScreen.SWidth div 2),
    BackScreen.Cy + (Mousey - BackScreen.SHeight div 2));
  if (SelectedChar = 0) and (SelectedItem = 0) and (SelectedDynamicItem = 0)
    then
    MouseInfoStr := '';
  if SelectedChar <> 0 then
  begin
    Cl := CharList.GetChar(SelectedChar);
    if Cl <> nil then
      if Cl.Feature.rHideState = hs_100 then
        MouseInfoStr := Cl.Name;
  end;
  if SelectedItem <> 0 then
  begin
    IT := CharList.GetItem(SelectedItem);
    MouseInfoStr := IT.ItemName;
  end;

  if SelectedDynamicItem <> 0 then
  begin // aniItem add by 001217
    AIT := CharList.GetDynamicObjItem(SelectedDynamicItem);
    MouseInfoStr := AIT.DynamicObjName;
  end;

  if OtherFormOpened then
    exit;
  //   if frmTrade.isShopReady then exit;

  if (SelScreenId <> 0) and (abs(SelScreenX - x) + abs(SelScreenY - y) > 10)
    then
    PaintLabel.BeginDrag(TRUE);
end;

procedure TFrmM.PaintLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  mouseX := x;
  mousey := y;
  RightButtonDown := FALSE;

  if abs(SelScreenX - x) + abs(SelScreenY - y) < 10 then
  begin
    SelScreenX := 0;
    SelScreenY := 0;
    SelScreenId := 0;
  end;
end;

procedure TFrmM.PaintLabelStartDrag(Sender: TObject; var DragObject:
  TDragObject);
begin
  DragItem.Dragedid := SelScreenId;
  DragItem.SourceId := WINDOW_SCREEN;
  DragItem.sx := mouseCellX;
  DragItem.sy := mouseCellY;
  DragObject := DragItem;
  SelScreenId := 0;
end;

procedure TFrmM.MoveProcess;
var
  dir, xx, yy: word;
  ckey: TCKey;
  cmove: TCMove;
  Cl: TCharClass;
begin
  if RightButtonDown = FALSE then
    exit;
  if OtherFormOpened then
    exit;

  Cl := CharList.GetChar(CharCenterId);
  if Cl = nil then
    exit;
  if Cl.AllowAddAction = FALSE then
    exit;

  dir := GetMouseDirection;
  if dir <> DR_DONTMOVE then
  begin
    if dir <> Cl.dir then
    begin
      ckey.rmsg := CM_TURN;
      ckey.rkey := dir;
      FrmLogon.SocketAddData(sizeof(ckey), @ckey);
      //CL.ProcessMessage (SM_TURN, dir, cl.x, cl.y, cl.feature, 0);
      Cl.SetTurn(dir);
    end
    else
    begin
      xx := Cl.x;
      yy := Cl.y;
      GetNextPosition(dir, xx, yy);
      if Map.isMovable(xx, yy) = FALSE then
        exit;
      if CharList.isMovable(xx, yy) = FALSE then
        exit;

      cmove.rmsg := CM_MOVE;
      cmove.rdir := dir;
      cmove.rx := Cl.x;
      cmove.ry := Cl.y;
      if (xx = 424) and (yy = 895) then
      begin
        //            FrmAttrib.keyProcess (Keybuffer[3]);
        //            CheckAndSendClick;
      end;
      if FrmLogon.SocketAddData(sizeof(cmove), @cmove) then
      begin
        //CL.ProcessMessage (SM_MOVE, dir, cl.x, cl.y, cl.feature, 0);
        Cl.Move(dir, xx, yy);
      end;
    end;
  end;
end;

procedure TFrmM.CheckAndSendClick;
var
  cl: TCharClass;
  dyn: TDynamicObject;
begin
  if mmAnsTick < ClickTick + 10 then
    exit;
  if GrobalClick.rwindow = 0 then
    exit;
  if (GrobalClick.rmsg = CM_DBLCLICK) and (GrobalClick.rwindow = WINDOW_SCREEN)
    then
  begin
    cl := CharList.GetChar(GrobalClick.rclickedId);
    if cl <> nil then
    begin
      GrobalClick.rX := cl.X;
      GrobalClick.rY := cl.Y;
    end;
    dyn := CharList.GetDynamicObjItem(GrobalClick.rclickedId);
    if dyn <> nil then
    begin
      GrobalClick.rX := dyn.x;
      GrobalClick.rY := dyn.y;
    end;
  end;

  Frmlogon.SocketAddData(sizeof(GrobalClick), @GrobalClick);
  FillChar(GrobalClick, sizeof(GrobalClick), 0);
end;

procedure TFrmM.MessageProcess(var code: TWordComData);
var
  TagetX, TagetY, len: Word;
  i, n, deg, xx, yy: integer;
  pan, volume, volume2: integer;
  str, rdstr: string;
  cstr: string[1];
  DynamicGuard: TDynamicGuard;

  // add by minds 1219 MovingMagic°ú Item¿¡ EffectÃß°¡
  MovingMagic: TMovingMagicClass;
  ItemClass: TItemClass;
  // add by minds 020319 DynamicObject¿¡ EffectÃß°¡
  DynamicObj: TDynamicObject;

  Cl, TL: TCharClass;
  Dt: TDynamicObject;
  pckey: PTCKey;
  psSay: PTSSay;
  psNewMap: PTSNewMap;
  psShow: PTSShow;
  psShowItem: PTSShowItem;
  psHide: PTSHide;
  psTurn: PTSTurn;
  psMove: PTSMove;
  psSetPosition: PTSSetPosition;
  psChatMessage: PTSChatMessage;
  psChangeFeature: PTSChangeFeature;
  psChangeProperty: PTSChangeProperty;
  psMotion: PTSMotion;
  psStructed: PTSStructed;
  psHaveMagic: PTSHaveMagic;
  psHaveItem: PTSHaveItem;
  psAttribBase: PTSAttribBase;
  psAttriblife: PTSAttribLife;
  psAttribValues: PTSAttribValues;
  psAttribFightBasic: PTSAttribFightBasic;
  psEventString: PTSEventString;
  psMovingMagic: PTSMovingMagic;
  psSoundString: PTSSoundString;
  psSoundBaseString: PTSSoundBaseString;
  psRainning: PTSRainning;
  psShowInputString: PTSShowInputString;

  PSShowDynamicObject: PTSShowDynamicObject; // DynamicItem Add 010102 ankudo
  PSChangeState: PTSChangeState; // Dynamic Item state Change 010105 ankudo
  PSTSHideSpecialWindow: PTSHideSpecialWindow;
  PSTSNetState: PTSNetState;
  cCNetState: TCNetState;
  PSTSSetShortCut: PTSSetShortCut;
  psSetPowerLevel: PTSSetPowerLevel; // ¿ø±â·¹º§ Á¶Àý // add by minds 1220
  psStartHelpWindow: PTSStartHelpWindow; // µµ¿ò¸»Ã¢ ¿­±â
  cSysInfo: TCSystemInfoData;
  pWordInfo: PTWordInfoString;
  psSetEffect: PTSSetEffect;
  psActionState: PTSSetActionState;
  psScreenEffect: PTSScreenEffect;
  psGuildListInfo: PTSGuildListInfo;
begin
  pckey := @Code.data;
  case pckey^.rmsg of
    SM_PASSWORD:
      begin
        FrmPassEtc.MessageProcess(Code);
      end;
    SM_SETSHORTCUT:
      begin
        PSTSSetShortCut := @Code.data;
        for i := 0 to KeyMaxSize - 1 do
        begin
          KeyBuffer[i] := PSTSSetShortCut^.rPosition[i];
          FrmAttrib.keyRepaint(KeyBuffer[i]);
        end;
      end;
    SM_MINIMAP:
      begin
        FrmMiniMap.MessageProcess(Code);
      end;
    SM_NETSTATE:
      begin
        PSTSNetState := @Code.data;
        with cCNetState do
        begin
          rMsg := CM_NETSTATE;
          rID := PSTSNetState^.rID;
          rMadeTick := PSTSNetState^.rMadeTick;
          rCurTick := mmAnsTick;
          rAnswer1 := oz_CRC32(@PSTSNetState^.rQuestion, 16);
          rAnswer2 := oz_CRC32(@cCNetState, sizeof(TCNetState) -
            sizeof(cardinal));
        end;
        FrmLogon.SocketAddData(sizeof(cCNetState), @cCNetState);
      end;
    SM_HIDESPECIALWINDOW:
      begin
        PSTSHideSpecialWindow := @Code.data;
        case PSTSHideSpecialWindow^.rWindow of
          WINDOW_GROUPWINDOW: FrmbatList.Visible := FALSE;
          WINDOW_ROOMWINDOW: FrmbatList.Visible := FALSE;
          WINDOW_GRADEWINDOW: FrmbatList.Visible := FALSE;
          WINDOW_SSAMZIEITEM: FrmDepository.Visible := FALSE;
          WINDOW_ALERT: FrmDepository.Visible := FALSE;
          WINDOW_AGREE: FrmcMessageBox.Visible := FALSE;
          WINDOW_GUILDMAGIC: FrmMuMagicOffer.Visible := FALSE;
        end;
      end;
    SM_SHOWBATTLEBAR, SM_SHOWCENTERMSG, SM_SHOWTOPMSG, SM_SHOWEVENTMSG:
      begin
        PersonBat.MessageProcess(Code);
      end;
    SM_CHECK:
      begin
        CheckSome(Code);
      end;
    SM_SSAMZIEITEM:
      begin
        FrmDepository.MessageProcess(Code);
      end;
    SM_GUILDITEM:
      begin
        FrmDepository.MessageProcess(Code);
      end;
    SM_SHOWSPECIALWINDOW:
      begin
        FrmDepository.MessageProcess(Code);
        FrmbatList.MessageProcess(Code);
        FrmcMessageBox.MessageProcess(Code);
        FrmMuMagicOffer.MessageProcess(Code);
      end;
    SM_CHARMOVEFRONTDIEFLAG:
      begin // ÀÓ½Ã»ç¿ë ÄÉ¸¯ÅÍ°¡ Á×Àº»ç¶÷À§·Î Áö³ª°¥¼ö ÀÖ´Â °æ¿ì¸¦ TRUE·Î ¼³Á¤
        CharMoveFrontdieFlag := TRUE;
      end;
    SM_SHOWEXCHANGE: // ±³È¯Ã¢
      begin
        FrmExChange.MessageProcess(Code);
      end;
    SM_HIDEEXCHANGE:
      begin
        FrmExchange.Visible := FALSE;
        if FrmQuantity.Visible then
          FrmQuantity.Visible := FALSE;
      end;
    SM_SHOWCOUNT: // ¼ö·®Ã¢
      begin
        FrmQuantity.MessageProcess(Code);
      end;

    // CM_SELECTCOUNT;
    SM_SHOWINPUTSTRING: // Å½»öÃ¢
      begin
        psShowInputString := @Code.Data;
        FrmSearch.QuantityID := psShowInputString.rInputStringid;
        FrmSearch.QuantityData := GetWordString(psShowInputString.rWordString);
        FrmSearch.SearchItem;
        FrmSearch.Visible := TRUE;
      end;
    SM_RAINNING: // ºñ
      begin
        psRainning := @Code.Data;
        with psRainning^ do
        begin
          BackScreen.SetRainState(TRUE, rspeed, rCount, rOverray, rTick,
            rRainType);
        end;
      end;
    SM_BOSHIFTATTACK:
      begin
        pckey := @Code.data;
        if pckey^.rkey = 0 then
        begin
          boShiftAttack := TRUE;
        end
        else
        begin
          boShiftAttack := FALSE;
        end;
      end;
    SM_SOUNDEFFECT: // »õ·Î¿î È¿°úÀ½.
      begin
        psSoundString := @Code.Data;
        if Application.Active then
        begin
          str := StrPas(@psSoundString^.rSoundName);
          TagetX := psSoundString.rX;
          TagetY := psSoundString.rY;
          //            volume := FrmSound.changeEffectVolume;
          pan := RangeCompute(CharPosX, TagetX);
          ATWaveLib.play(str, pan, EFFECTVOLUME);
        end;
        {
           if not boUseSound then exit;
           psSoundString := @Code.Data;
           str := StrPas (@psSoundString^.rSoundName);

           TagetX := psSoundString.rX;
           TagetY := psSoundString.rY;

           volume := FrmSound.changeEffectVolume;
           pan := FrmM.SoundManager.RangeCompute(CharPosX, TagetX);
           FrmM.SoundManager.NewPlayEffect (str,pan,volume);
           }
      end;
    SM_SOUNDBASESTRING: // ¹è°æÀ½¾Ç.... 1ºÐÁ¤µµº¸´Ù ±ä°Íµé
      begin
        psSoundBaseString := @Code.Data;
        str := GetWordString(psSoundBaseString^.rWordString);
        // change by minds 020222
        if str = '' then
          BaseSound.Clear
        else
        begin
          BaseSound.play('wav\' + str, TRUE);
          if not Application.Active then
            BaseSound.Pause;
        end;
        {
           if not boUseSound then exit;
           psSoundBaseString := @Code.Data;
           str := GetWordString (psSoundBaseString^.rWordString);
           FrmM.SoundManager.PlayBaseAudio (str, psSoundBaseString^.rRoopCount);
           }
      end;
    SM_SOUNDBASESTRING2: // È¿°úÀ½Çâ (¹Ù¶÷¼Ò¸®, ÃµµÕ¼Ò¸®, »õ¼Ò¸®,...)
      begin
        {
           if not boUseSound then exit;
           psSoundBaseString := @Code.Data;
           str := GetWordString (psSoundBaseString^.rWordString);
           FrmM.SoundManager.PlayBaseAudio2 (str, psSoundBaseString^.rRoopCount);
        }
      end;
    SM_MOVINGMAGIC:
      begin
        psMovingMagic := @Code.Data;
        with psMovingMagic^ do
        begin
          Cl := CharList.GetChar(rsid);
          TL := CharList.GetChar(reid);
          if Cl = nil then
            exit;
          if Tl <> nil then
          begin
            xx := Tl.x;
            yy := Tl.y;
          end
          else
          begin
            xx := rtx;
            yy := rty;
          end;
          deg := GetDeg(Cl.x, Cl.y, xx, yy);
          MovingMagic := CharList.AddMagic(Cl.Id, reid, deg, rspeed, Cl.x, Cl.y,
            xx, yy, rmf, mmAnstick, rType);

          // add by minds 1219  ´øÁú¶§ Effect¿Í ¸ÂÀ»¶§ EffectÀÇ Ãß°¡
          if rsEffectNumber > 0 then
          begin
            Cl.Feature.rEffectNumber := rsEffectNumber;
            Cl.Feature.rEffectKind := rsEffectKind;
          end;
          if reEffectNumber > 0 then
            MovingMagic.SetEndEffect(reEffectNumber, reEffectKind);

        end;
      end;
    SM_EVENTSTRING:
      begin
        psEventString := @Code.data;
        str := GetwordString(psEventString^.rWordstring);
        if str <> Conv('¼¼ÄÜ') then
        begin
          FrmAttrib.LbEvent.Caption := str;
          EventTick := mmAnsTick;
          FrmBottom.AddEventString(str, mmAnsTick);
        end;
      end;
    SM_MOTION:
      begin
        psMotion := @Code.Data;
        // change by minds 021121 bug¼öÁ¤
        str := '';
        if psMotion^.rEffectColor > 0 then
        begin
          with psMotion^ do
          begin
            if rMagicKind = 3 then
              rMagicKind := 2;
            if rMagicKind = 5 then
              rMagicKind := 4;
            str := format('_%d%d%d.atz', [rMagicState, rMagicKind,
              rEffectColor]);
          end;
        end;
        Cl := CharList.GetChar(psMotion^.rid);
        if Cl <> nil then
        begin
          Cl.SetEffectName(str);
          //Cl.ProcessMessage (SM_MOTION, cl.dir, cl.x, cl.y, Cl.feature, psMotion^.rmotion);
          Cl.SetMotion(psMotion^.rmotion);
        end;
        {
        if psMotion^.rEffectColor = 3 then psMotion^.rEffectColor := 2;  // 1, 2, 4 ¸¸ Á¸ÀçÇÔ @@
        if psMotion^.rEffectColor = 5 then psMotion^.rEffectColor := 4;
        str := format ('_%d%d%d.atz',[psMotion^.rMagicState, psMotion^.rMagicKind, psMotion^.rEffectColor]);
        Cl := CharList.GetChar (psMotion^.rid);
        Cl.SetEffectName (str);
        if Cl <> nil then Cl.ProcessMessage (SM_MOTION, cl.dir, cl.x, cl.y, Cl.feature, psMotion^.rmotion);
        }
      end;
    SM_STRUCTED:
      begin
        psStructed := @Code.Data;
        case psStructed^.rRace of
          RACE_HUMAN:
            begin
              Cl := CharList.GetChar(psStructed^.rid);
              if Cl <> nil then
                //Cl.ProcessMessage (SM_STRUCTED, cl.dir, cl.x, cl.y, Cl.feature, psStructed^.rpercent);
                Cl.Structed(psStructed^.rpercent);
            end;
          RACE_DYNAMICOBJECT:
            begin
              Dt := CharList.GetDynamicObjItem(psStructed^.rid);
              if Dt <> nil then
                Dt.ProcessMessage(SM_STRUCTED, psStructed^.rpercent);
            end;
        end;
      end;
    SM_CHATMESSAGE:
      begin
        psChatMessage := @Code.data;
        str := GetwordString(psChatMessage^.rWordstring);
        cstr := str;
        // change by minds 030304
        rdstr := GetValidStr4(str, ':');
        if str <> '' then
          rdstr := rdstr + ':' + ChangeDontSay(str);
        {
        if (cstr = '[') or (cstr = '<') then begin
           if pos (':', str) > 1 then begin
              str := GetValidStr3 (str, rdstr, ':');
              str := ChangeDontSay (str);
              rdstr := rdstr + ':' + str
           end else begin
              rdstr := str;
           end;
        end else begin
           str := ChangeDontSay (str);
           rdstr := str;
        end;
        }
        ChatMan.AddChat(rdstr, psChatMessage^.rFColor, psChatMessage^.rBColor);
        str := '';
        rdstr := '';
      end;
    SM_SAY:
      begin
        psSay := @Code.data;
        str := GetwordString(pssay^.rWordstring);
        str := GetValidStr3(str, rdstr, ':');
        str := ChangeDontSay(str);
        rdstr := rdstr + ' :' + str;
        ChatMan.AddChat(rdstr, WinRGB(28, 28, 28), 0);
        Cl := CharList.GetChar(psSay^.rid);
        if (Cl <> nil) and chat_normal then
          Cl.Say(rdstr);
        str := '';
        rdstr := '';
      end;
    SM_SAYUSEMAGIC:
      begin
        psSay := @Code.data;
        Cl := CharList.GetChar(psSay^.rid);
        if Cl <> nil then
          Cl.Say(GetwordString(pssay^.rWordstring));
      end;
    SM_NEWMAP:
      begin
        CharList.Clear;
        psNewMap := @Code.data;
        CharCenterId := psNewMap^.rId;
        CharCenterName := StrPas(@psNewMap^.rCharName);
        LogObj.WriteLog(1, Format('%d %s', [CharCenterId, CharCenterName]));

        ObjectDataList.LoadFromFile(StrPas(@psNewMap^.rObjName));
        TileDataList.LoadFromFile(StrPas(@psNewMap^.rTilName));
        RoofDataList.LoadFromFile(StrPas(@psNewMap^.rRofName));
        Map.LoadFromFile(StrPas(@psNewMap^.rmapname), psNewMap^.rx,
          psNewMap^.ry);

        BackScreen.SetCenter(psNewMap^.rx * UNITX, psNewMap^.ry * UNITY);
        Map.SetCenter(psNewMap^.rx, psNewMap^.ry);
        BackScreen.Back.Clear(0);

// change by minds 050221
        Map.boCryptPos := False;
{
        with psNewMap^ do
        begin
          Map.boCryptPos := True;
          if (rboRain - rboDark = 1) and (rboDark * rboRain = 2) then
          begin
            if not SetKey2 then
              Move(EncBasePosX2, EncBasePos, 16);
          end
          else if (rboRain - rboDark = 2) and (byte(rboDark + rboRain) = 2) then
          begin
            if not SetKey3 then
              Move(EncBasePosX3, EncBasePos, 16);
          end
          else if (rboRain - rboDark = 3) and ((rboDark + rboRain) mod 16 = 3)
            then
          begin
            Map.boCryptPos := False;
          end;
        end;
}
        // add by minds 020204
        {
        if Code.Size = SizeOf (TSNewMap) then begin
           BackScreen.boDark := psNewMap^.rboDark;
           if psNewMap^.rboRain then
              BackScreen.SetRainState (TRUE, 3, 100, 20, 1080000, RAINTYPE_RAIN);
        end;
        }
        RightButtonDown := False;

        FrmMiniMap.Visible := False;
        //            FrmAttrib.Visible := TRUE;
        FrmBottom.Visible := TRUE;
        FrmBottom.EdChat.SetFocus;
        PersonBat.ShowBar := False;
      end;
    SM_SHOWDYNAMICOBJECT: // DynamicItem 010102 ankudo ¿Õ¸ª¾ÆÀÌÅÛ Add
      begin
        PSShowDynamicObject := @Code.Data;
        with PSShowDynamicObject^ do
        begin
          Fillchar(DynamicGuard, sizeof(DynamicGuard), 0);
          DynamicGuard.aCount := 0;
          for i := 0 to 10 - 1 do
          begin
            if (rGuardX[i] = 0) and (rGuardY[i] = 0) then
              break;
            DynamicGuard.aGuardX[i] := rGuardX[i];
            DynamicGuard.aGuardY[i] := rGuardY[i];
            inc(DynamicGuard.aCount);
          end;
          CharList.AddDynamicObjItem(StrPas(@rNameString), rid, rx, ry, rshape,
            rFrameStart, rFrameEnd, rstate, DynamicGuard);
        end;
      end;
    SM_CHANGESTATE: // DynamicItem 010106 ankudo ¿Õ¸ª¾ÆÀÌÅÛÀÇ »óÅÂº¯°æ
      begin
        PSChangeState := @Code.Data;
        with PSChangeState^ do
        begin
          CharList.SetDynamicObjItem(rid, rState, rFrameStart, rFrameEnd);
        end;
      end;
    SM_HIDEDYNAMICOBJECT: // DynamicItem 010106 ankudo ¿Õ¸ª¾ÆÀÌÅÛ »èÁ¦
      begin
        PSHide := @Code.Data;
        with PSHide^ do
        begin
          CharList.DeleteDynamicObjItem(rid);
        end;
      end;
    SM_SHOWITEM:
      begin
        psShowItem := @Code.Data;
        with psshowItem^ do
        begin
          CharList.AddItem(StrPas(@rNameString), rRace, rid, rx, ry, rshape,
            rcolor);
          {               // add by minds 1219 ItemÀÌ »ý±æ¶§ EffectÃß°¡
                         if rEffectNumber > 0 then begin
                            ItemClass := CharList.GetItem(rid);
                            if ItemClass <> nil then ItemClass.AddBGEffect(rEffectNumber-1, rEffectKind);
                         end;
          }
        end;
      end;
    SM_HIDEITEM:
      begin
        psHide := @Code.Data;
        with pshide^ do
        begin
          CharList.DeleteItem(rid);
        end;
      end;
    SM_SHOW:
      begin
        psShow := @Code.Data;
        with psshow^ do
        begin
{$IFDEF _DEBUG}
          if bShowCharList then
            ChatMan.AddChat(Format('SHOW id=%d,X=%d,Y=%d', [rid, rx, ry]),
              32727, 0);
{$ENDIF}
          CharList.AddChar(GetWordString(rWordString), rid, rdir, rx, ry,
            rFeature);
        end;
      end;
    SM_HIDE:
      begin
        psHide := @Code.Data;
        with pshide^ do
        begin
          CharList.DeleteChar(rid);
          //               LogObj.WriteLog(1, Format('hide %d', [rid]));
        end;
      end;
    SM_SETPOSITION:
      begin
        psSetPosition := @Code.Data;
        with psSetPosition^ do
        begin
          Cl := CharList.GetChar(rid);
          if Cl <> nil then
            //Cl.ProcessMessage (SM_SETPOSITION, rdir, rx, ry, Cl.feature, 0);
            Cl.SetPosition(rdir, rx, ry);
        end;
      end;
    SM_TURN:
      begin
        psTurn := @Code.Data;
        with psTurn^ do
        begin
{$IFDEF _DEBUG}
          if bShowCharList then
            ChatMan.AddChat(Format('TURN id=%d,X=%d,Y=%d', [rid, rx, ry]),
              32727, 0);
{$ENDIF}
          Cl := CharList.GetChar(rid);
          if Cl <> nil then
            //Cl.ProcessMessage (SM_TURN, rdir, rx, ry, Cl.feature, 0);
            Cl.SetPosition(rdir, rx, ry);
        end;
      end;
    SM_MOVE:
      begin
        psMove := @Code.Data;
        with psMove^ do
        begin
{$IFDEF _DEBUG}
          if bShowCharList then
            ChatMan.AddChat(Format('MOVE id=%d,X=%d,Y=%d', [rid, rx, ry]),
              32727, 0);
{$ENDIF}
          Cl := CharList.GetChar(psMove^.rid);
          if Cl <> nil then
            //Cl.ProcessMessage (SM_MOVE, rdir, rx, ry, Cl.feature, 0);
            Cl.Move(rdir, rx, ry);
        end;
      end;
    SM_BACKMOVE:
      begin
        psMove := @Code.Data;
        with psMove^ do
        begin
{$IFDEF _DEBUG}
          if bShowCharList then
            ChatMan.AddChat(Format('BACKMOVE id=%d,X=%d,Y=%d', [rid, rx, ry]),
              32727, 0);
{$ENDIF}
          Cl := CharList.GetChar(psMove^.rid);
          if Cl <> nil then
            //Cl.ProcessMessage (SM_BACKMOVE, rdir, rx, ry, Cl.feature, 0);
            Cl.BackMove(rdir, rx, ry);
        end;
      end;
    SM_CHANGEFEATURE:
      begin
        psChangeFeature := @Code.data;
        Cl := CharList.GetChar(psChangeFeature^.rid);
        if Cl <> nil then
        begin
          //               Cl.ProcessMessage (SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, psChangeFeature.rfeature, 0);
          Cl.ChangeFeature(psChangeFeature.rFeature);
{$IFNDEF _CHINA}
          str := GetWordString(psChangeFeature.rWordString);
          str := ChangeDontSay(str);
          Cl.SetStoreSign(str);
{$ENDIF}
          exit;
        end;
        ItemClass := CharList.GetItem(psChangeFeature^.rid);
        if ItemClass <> nil then
        begin
          ItemClass.SetItemAndColor(psChangeFeature^.rFeature.rImageNumber,
            psChangeFeature^.rFeature.rImageColorIndex);
          exit;
        end;
        DynamicObj := CharList.GetDynamicObjItem(psChangeFeature^.rid);
        if DynamicObj <> nil then
        begin
          if psChangeFeature^.rFeature.rEffectNumber > 0 then
            DynamicObj.AddBgEffect(psChangeFeature^.rFeature.rEffectNumber,
              psChangeFeature^.rFeature.rEffectKind);
        end;
      end;
    SM_CHANGEPROPERTY:
      begin
        psChangeProperty := @Code.data;
        Cl := CharList.GetChar(psChangeProperty^.rid);
        if Assigned(Cl) then
        begin
        //Author:Steven Date: 2005-01-05 07:07:47
        //Note: ÐÞ¸ÄÓÐÉúÃüÈËÎïµÄÊôÐÔ°üÀ¨NameµÈ
          Cl.ChangeProperty(psChangeProperty);
          exit;
        end;
        ItemClass := CharList.GetItem(psChangeProperty^.rid);
        if Assigned(ItemClass) then
        begin
          ItemClass.ChangeProperty(psChangeProperty);
          exit;
        end;
        // Add by minds 020618
        DynamicObj := CharList.GetDynamicObjItem(psChangeProperty^.rid);
        if Assigned(DynamicObj) then
        begin
          DynamicObj.ChangeProperty(psChangeProperty);
          exit;
        end;
      end;
    // ¿ø±â·¹º§ Á¶Àý
    SM_SETPOWERLEVEL:
      begin
        psSetPowerLevel := @Code.data;
        with psSetPowerLevel^ do
          FrmEnergy.SetLevel(StrPas(@rName), rLevel, mmAnsTick);
        //if FrmBottom.Visible then FrmEnergy.Visible := True;
      end;
    // Help Windows Message
    SM_STARTHELPWINDOW:
      begin
        frmHelp.MessageProcess(Code);
      end;
    SM_ITEMHELPWINDOW2, SM_ITEMHELPWINDOW3:
      begin
        frmItemHelp.MessageProcess(Code);
      end;
    SM_TRADEWINDOW, SM_SHOWTRADEWINDOW, SM_SETTRADEITEM,
      SM_SHOWINDIVIDUALMARKETWINDOW:
      begin
        frmNPCTrade.MessageProcess(Code);
      end;
    // Skill Window Message
    SM_SKILLWINDOW, SM_JOBRESULT, SM_MATERIALITEM:
      begin
        frmSkill.MessageProcess(Code);
      end;
    SM_SYSTEMINFO:
      begin
        cSysInfo.rMsg := CM_SYSTEMINFO;
        cSysInfo.rCPUSpeed := CPUSpeed;
        cSysInfo.rRAMSize := TotalMemory;
        SetWordString(cSysInfo.rVGA, GraphicCard);
        n := sizeof(cSysInfo) - sizeof(TWordString) +
          SizeOfWordString(cSysInfo.rVGA);
        FrmLogon.SocketAddData(n, @cSysInfo);
      end;
    { // Áß±¹Àº °³ÀÎÆÇ¸Å Áö¿ø ¾ÈÇÔ...
 SM_MARKETWINDOW,SM_MARKETITEM,SM_SHOWMARKETCOUNT,SM_CONFIRMMARKET:
    begin
       FrmTrade.MessageProcess(Code);
    end;
    }
    SM_TIME:
      begin
        psEventString := @Code.Data;
        FrmBottom.ClientCapture(GetWordString(psEventString.rWordString));
      end;
    SM_SIDEMESSAGE:
      begin
        pWordInfo := @Code.Data;
        str := GetWordString(pWordInfo.rWordString);
        with ChatMan do
        begin
          //               if bSideMessage then
          AddSideMessage(str, mmAnsTick)
            //               else
          //                  AddChat(str, WinRGB(22,22,0), 0);
        end;
      end;
    SM_SHOWBESTATTACKMAGICWINDOW,
      SM_SHOWBESTPROTECTMAGICWINDOW:
      begin
        frmBestMagic.MessageProcess(Code);
      end;
    SM_SHOWBESTSPECIALMAGICWINDOW:
      begin
        frmSpecialMagic.MessageProcess(Code);
      end;
    SM_SETEFFECT:
      begin
        psSetEffect := @Code.Data;
        Cl := CharList.GetChar(psSetEffect.rid);
        if Cl = nil then
          exit;
        Cl.AddEffect(psSetEffect.rEffectNumber - 1, psSetEffect.rEffectKind,
          mmAnsTick, psSetEffect.rDelay);
      end;
    SM_SETACTIONSTATE:
      begin
        psActionState := @Code.Data;
        if CharCenterId = psActionState.rid then
        begin
          Cl := CharList.GetChar(psActionState.rid);
          Cl.Feature.rActionState := psActionState.rActionState;
        end
      end;
    SM_SCREENEFFECT:
      begin
        psScreenEffect := @Code.Data;
        case psScreenEffect.rScreenEffectNum of
          1:
            begin
              BackScreen.AddEarthquake(psScreenEffect.rDelay, 4);
            end;
        end;
      end;
    //      SM_SHOWEVENTINPUT: begin
    //         ShowA2Form(frmEventInput);
    //      end;
    SM_ABILITYATTRIB:
      begin
        frmCharAttrib.MessageProcess(Code);
      end;
    //Author:Steven Date: 2004-12-09 12:02:44
    //Note:
    SM_TEAMMEMBERLIST:
      begin
        frmTeamMember.MessageProcess(Code);
      end;
    ////////////////////////////////////////

  //Author:Steven Date: 2004-12-26 14:29:35
  //Note:
    SM_MARRYWINDOW, SM_INPUTGUILDNAMEWINDOW, SM_GUILDMONEYCHIPWINDOW:
      begin
        frmInputDialog.MessageProcess(Code);
      end;
    SM_MARRYANSWERWINDOW, SM_UNMARRY, SM_GUILDMONEYAPPLYWINDOW, SM_ISINVITETEAM,
    SM_GUILDSUBSYSOP, SM_ARENAWINDOW, SM_ARENAJOINWINDOW, SM_GUILDANSWERWINDOW:
      begin
        frmConfirmDialog.MessageProcess(Code);
      end;

    SM_GUILDINFO:
      begin
        psGuildListInfo := @Code.Data;
        Move(psGuildListInfo^, GuildListInfo, SizeOf(TSGuildListInfo));
      end;

    SM_GUILDINFOWINDOW:
      begin
        frmGuildInfo.MessageProcess(Code);
      end;
    SM_GUILDENERGY:
      begin
        pckey := @Code.data;
        FrmAttrib.DrawGuildEnergy(pckey^.rkey);
      end;

  //===========================================
  end;
end;



procedure TFrmM.changeScreen;       //f1 ¼ÓÔØ800*1024
begin

  FrmM.SaveAndDeleteAllA2Form;
  FrmM.DXDraw.Finalize;
  if G_Default800 then
  begin
    ClientHeight := fheight600;
    ClientWidth := fwide800;
    DXDraw.Display.Width := fwide800;
    DXDraw.Display.Height := fheight600;
    DXDraw.SurfaceHeight := fheight600;
    DXDraw.SurfaceWidth := fwide800;
  end else
  begin
    ClientHeight := fhei;
    ClientWidth := fwide;
    DXDraw.Display.Width := fwide;
    DXDraw.Display.Height := fhei;
    DXDraw.SurfaceHeight := fhei;
    DXDraw.SurfaceWidth := fwide;
  end;

  BackScreen.changeBack;
  FrmBottom.changeBack;        //f1 ¼ÓÔØ800*1024    µ×ÏÂ
  FrmAttrib.changeBack;        //f1 ¼ÓÔØ800*1024    ÓÒ±ß
  FrmEnergy.changeBack;        //f1 ¼ÓÔØ800*1024    ¾³½ç
  FrmM.DXDraw.Initialize;
  FrmM.RestoreAndAddAllA2Form;
  //FrmBottom.SetNewVersion;
end;



procedure TFrmM.Time1TimerTimer(Sender: TObject);
var
  CMouseEvent: TCMouseEvent;
begin
  CMouseEvent.rmsg := CM_MOUSEEVENT;
  move(eventBuffer, CMouseEvent.revent, sizeof(eventBuffer));
  FrmLogon.SocketAddData(sizeof(CMouseEvent), @CMouseEvent);
  Fillchar(eventBuffer, sizeof(eventBuffer), 0);
end;

procedure TFrmM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DXTimer1.Enabled := FALSE;
end;

const
  NetStateDelayTick = 500;
var
  iMoving: byte = 3;
  DrawTick: integer = 0;

procedure TFrmM.DXTimer1Timer(Sender: TObject);
const
  oldMouseInfo: string = '';
var
  i: integer;
  Cl: TCharClass;
  n: integer;
  TempStr: string;
begin
{$IFDEF _FRAME}
  Caption := format(Conv('Ãµ³â :%d'), [DxTimer1.FrameRate]);
{$ELSE}
  //   Caption := format (Conv('Ãµ³â :%s:%s'),[CharCenterName, TimeToStr(Time)]);
  Caption := Conv('Ç§Äê') + format(':%s:%s', [CharCenterName, TimeToStr(Time)]);
{$ENDIF}

  FrmBottom.LbPos.Caption := format('%d:%d', [CharPosX, CharPosY]);
  if boDirectClose then
  begin
    Close;
    exit;
  end;

  CharList.Update(mmAnsTick);

  if not DXDraw.CanDraw then
    exit;

  if oldMouseInfo <> mouseinfostr then
  begin
    oldmouseinfo := mouseinfostr;

    if (Length(MouseInfoStr) > 0) and (MouseInfoStr[1] = '<') then
    begin
      n := Pos('>', MouseInfoStr);
      TempStr := Copy(MouseInfoStr, 2, n - 2);
      FrmAttrib.LbWindowName.Caption := Copy(MouseInfoStr, n + 1, 20);
      FrmAttrib.LbWindowName.Font.Color := _StrToInt(TempStr);
    end
    else
    begin
      FrmAttrib.LbWindowName.Caption := MouseInfoStr;
      FrmAttrib.LbWindowName.Font.Color := clWhite;
    end;
  end;

  if EventTick <> 0 then
  begin
    if EventTick + 150 < mmAnsTick then
    begin
      EventTick := 0;
      FrmAttrib.LbEvent.Caption := '';
    end;
    FrmAttrib.LbEvent.Font.Color := Random(clWhite);
  end;
  FrmBottom.EventTickProcess(mmAnsTick);

  Map.DrawMap(mmAnsTick);

  CharList.Paint(mmAnstick);

  CharList.UpdataBgEffect(mmAnsTick);
  Cl := CharList.GetChar(CharCenterId);
  if Cl <> nil then
    if not Map.IsInArea(CL.x, CL.y) then
      Map.DrawRoof(mmAnsTick);

  CharList.PaintText(nil);

  with ChatMan do
  begin
    if boShowChat then
      DrawChatList;
    DrawSideMessage(mmAnsTick);
  end;

  if FrmMiniMap.Visible then
    FrmMiniMap.SetCenterID;

  if FrmAttrib.Visible then
    FrmAttrib.DrawWearItem;

  BackScreen.UpdateRain; //

  for i := FormList.Count - 1 downto 0 do
  begin
    if PTFormData(formList[i])^.rForm.Visible then
      PTFormData(FormList[i])^.rA2Form.AdxPaint(BackScreen.Back);
  end;

  if FrmBottom.Visible then
  begin
    FrmEnergy.EnergyDraw(mmAnsTick);
       if  G_Default800 then
  begin
    BackScreen.Back.DrawImage(BottomUpImage, 0, 600-117 - BottomUpImage.Height,
      TRUE);
     end else
  begin
    //BackScreen.Back.DrawImage(BottomUpImage, 0, 768-117 - BottomUpyImage.Height,TRUE);

  end;
  end;
  if FrmAttrib.Visible then
    BackScreen.Back.DrawImage(AttribLeftImage, 1024 - AttribLeftImage.Width -
      FrmAttrib.Width, 0, TRUE);

  ObjectDataList.UsedTickUpdate(mmAnsTick);
  TileDataList.UsedTickUpdate(mmAnsTick);
  AtzClass.UpDate(mmAnsTick);

  ///

  if PersonBat.ShowBar then
    PersonBat.Draw;

  if PersonBat.ShowBatMsg then
    PersonBat.BatMessageDraw(mmAnsTick);
  {
     ATextOut(BackScreen.Back, 10, 10, 32767, IntToStr(PacketCount));
     ATextOut(BackScreen.Back, 10, 30, 32767, IntToStr(PacketMaxCount));
     PacketCount := 0;
  }
  BackScreen.DrawCanvas(DxDraw.Surface.Canvas, 0, 0);
  DxDraw.Surface.Canvas.Release;
  DxDraw.Flip;

  if Cl <> nil then
  begin
    case Cl.Feature.rActionState of
      as_Free: MoveProcess;
      as_ice: ;
      as_slow:
        begin
          if iMoving > 1 then
          begin
            MoveProcess;
            iMoving := 3;
          end;
          Dec(iMoving);
        end;
    end;
  end;
  CheckAndSendClick;

end;

end.

