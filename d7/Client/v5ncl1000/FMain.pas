unit FMain;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, DXSounds, uSound, Cltype, A2Form, A2Img, uAnsTick,
  ExtCtrls, StdCtrls, BackScrn, CharCls, ClMap, AtzCls, Deftype, subutil,
  PaintLabel, objcls, tilecls, AUtil32, IniFiles, CTable, mmsystem,
  uPersonBat, DXSprite, jpeg, ImgList, DIB, AppEvnts, FAttrib, shellapi,

  Menus, SESDK, SELicenseSDK, TLHelp32, PsAPI; //Log,
//uActiveMusic;

const
  WM_POP_MESSAGE = WM_USER + 1; //Mensaje usado para las notificaciones
  WM_ICONTRAY = WM_USER + 2; //Mensaje usado para el icono en el system tray
  WM_GAME_CHECK = WM_USER + 32;
  G_Menus: array[0..7] of string = ('@探查 [名字] -- 探查他人的大概方位', '@门派团队 -- 切换团队为门派团队', '@武功删除 XXXX-- 删除一个武功', '@设定团队 XXXX -- 切换团队(XXXX为数字)', '@纸条 [名字] [聊天内容] -- 发送私聊', '![聊天内容] -- 呐喊', '!![聊天内容] -- 门派聊天', '!!![聊天内容] -- 同盟聊天');
  Box_Monster: array[0..4] of string = ('黑忍者', '忍者', '黑牛', '犀牛', '稻草人');
  MenuArrS = -1;
  MenuArrE = 7;
var
  NameChangeColor: integer;

  boMove: boolean = false;

  OldCharPos: TPoint;
  boAttack: boolean = true;
  CurMagicType: integer = 0;

  fwide1024: Integer = 1024;
  fhei1024: Integer = 768;
  fwide: integer = 800;
  fhei: integer = 600;

  fname: string = '梦千年Online';
  fservername: string = '';
  fserveraddr: string = '';
type
    //TShowName = (tsnNone, tsnNpc, tsnPeople, tsnMonster, tsnItem);
  TWinVerType = (wvtNew, wvtOld);
  Tmove_win_form = (mwfLeft, mwfTop, mwfRight, mwfBottom, mwfCenter, mwfCenterLeft);
  TFormData = record
    rForm: TForm;
    rOldParent: integer;
    rA2Form: TA2Form;
  end;
  PTFormData = ^TFormData;

  TGameCheckThread = class(TThread)
  private
    FAllow: Boolean;
    FErrmsg: string;
  protected
    procedure Execute; override;
  public
    constructor Create(suspend: Boolean);
    property Errmsg: string read FErrmsg;
    property SendAllow: Boolean read FAllow write FAllow;
  end;

  TFrmM = class(TForm)
    PaintLabel: TPaintLabel;
    Timer1MouseEvent: TTimer;
    DXWaveList1: TDXWaveList;
    DXSound1: TDXSound;
    Timer2_dx: TTimer;
    ApplicationEvents1: TApplicationEvents;
    PopupMenuTray: TPopupMenu;

    max1: TMenuItem;
    Salir1: TMenuItem;
    MenuItem4: TMenuItem;
    DXDraw: TDXDraw;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure PaintLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PaintLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintLabelClick(Sender: TObject);
    procedure PaintLabelDblClick(Sender: TObject);
    procedure PaintLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure PaintLabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PaintLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure Time1TimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2_dx1Timer(Sender: TObject; LagCount: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer2_dxTimer(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure max1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
        { Private declarations }

    FormList: TList;
  //  procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;

    function GetMouseDirection: word;
    procedure DrawChatList;

    function send_Booth_Click: boolean;


  protected
    procedure WndProc(var Message: TMessage); override;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
  public
    dxTick: integer;
    dxTicknum, dxSPEEDtick: integer; //当前 刷了几张
    TrayIconData: TNotifyIconDataW;


    EventTick_Attrib: integer;
    EventTick_Tick: integer;
    EventTick_Magic: integer;
    Event_Magic_text: string;

    DragItem: TDragItem;

    BottomUpImage: TA2Image;
    //AttribLeftImage: TA2Image;
    SoundManager: TSoundManager;

        //    BaseAudio : TBaseAudio;
        //    BaseAudioVolume : integer;
    ChatList: TStringList;
    AutoHit_updatetick: integer;
    AutoHit_ID: integer;
    AutoHit_SendCMD: boolean;

    SendHit_ID: integer;

    questlist: tstringlist;
    list1, list2: string;
    FRightMove: Boolean;

    FShow: Boolean;
    FHotKeyId: Integer;
    FHaveHotKey: Boolean;
    procedure HotKeyDown(var Msg: Tmessage); message WM_HOTKEY;
    procedure DrawquestList; //显示任务列表
    procedure NewDrawquestList; //显示任务列表
    procedure Eventstringdisplay(aTick: integer);
    procedure EventstringSet(s: string; key: byte);
    procedure AddChat(astr: string; fcolor, bcolor: integer);
    procedure AddA2Form(aform: TForm; aA2Form: TA2Form);
    procedure DelA2Form(aform: TForm; aA2Form: TA2Form);
    procedure SaveAndDeleteAllA2Form;
    procedure RestoreAndAddAllA2Form;

    procedure SetA2Form(aForm: TForm; aA2Form: TA2Form);
    procedure MoveProcess;
    procedure ProtectProcess;
    procedure AutoHitProcess;
    procedure map_move(mx, my: integer);
    procedure CheckAndSendClick;
    procedure MessageProcess(var code: TWordComData);

    procedure OnAppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure CheckSome(var code: TWordComData);
    procedure move_win_form_Paint(aTick: integer);
    procedure move_win_form_set(sender: TForm; x, y: integer);
    procedure move_win_form_Align(sender: TForm; Align: Tmove_win_form);

    function send_hit_Selectid(): boolean;
    function send_get_WearItemUser(aid: integer): boolean;
    function send_get_NameUser(aid: integer): boolean;
    function send_get_CharBuff(aid: integer): boolean;
    function send_drink: boolean;
        //自动移动打怪 2009.7.15新增
    function AutoPathAI(cx, cy: word): integer;
    procedure AutoMove_begin(cx, cy: word);
    procedure AutoMove_stop;

    function AutoHit_begin(aid: integer): boolean;
    procedure AutoHit_stop;
    procedure AutoHit_update(curtick: integer);
//            procedure max1Click(Sender: TObject);
    procedure MinimizeToTrayClick(Sender: TObject);
    procedure RegHotKey;
    procedure UnRegHotKey;

    function findForm(AClassName: string): TForm;
    procedure ClearFormList;
    procedure changeScreen();
  end;

  TGameHint = class
  private
    A2Hint: TA2Hint;
    A2Hint_id: integer;
    A2Hint_text: string;
    A2Hint_state: integer;
    A2Hint_time: integer;
    A2Hint_X: integer;
    A2Hint_Y: integer;
    FUsePos: Boolean;
    FUserMaxArea: Boolean;
    FMaxHeigth: Integer;
    FMaxWidth: Integer;
    procedure SetMaxHeigth(const Value: Integer);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetUserMaxArea(const Value: Boolean);

  public
    constructor Create;
    destructor Destroy; override;

    procedure settext(aid: integer; astr: string);
    procedure update(curtick: integer);
        //        procedure pos(ax, ay:Integer);
    procedure Close();

    property MaxHeigth: Integer read FMaxHeigth write SetMaxHeigth;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    property UserMaxArea: Boolean read FUserMaxArea write SetUserMaxArea;
    property UsePos: Boolean read FUsePos write FUsePos;

  end;
  TGameHintByPos = class(TGameHint)
  public
    procedure setA2Hint_X(AX: Integer);
    procedure setA2Hint_Y(AY: Integer);
  end;
  TGameMenu = class
  private
    A2Hint: TA2Hint;
    A2HintArr: array[MenuArrS..MenuArrE] of TA2Hint;
    A2Hint_id: integer;
    A2Hint_text: string;
    A2Hint_state: integer;
    A2Hint_time: integer;
    A2Hint_X: integer;
    A2Hint_Y: integer;
    FCurrItem: integer;
    yyLine: integer;
    yyBlank: integer;
    YDrawMargin: integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure init(aid: integer = -2);
    procedure settext(aid, aindex: integer);
    procedure update(curtick: integer);
    procedure Close();
    function getvisable: Boolean;
    function getrect: TRect;
    function getHeight: Integer;
    function getWidth: Integer;
    function MouseEnter: Boolean;
    procedure MouseDown;
    function GetCurrItem: Integer;
    function ProcessDown(aid: integer): Boolean;
    function ProcessMove: Boolean;
    procedure setA2Hint_X(AX: Integer);
    procedure setA2Hint_Y(AY: Integer);
    property Visable: Boolean read getvisable;
    property ClientRect: TRect read getrect;
    property CurrItem: Integer read GetCurrItem write FCurrItem;
  end;
var
  FrmM: TFrmM;
  GameHint: TGameHint;
  GameHintByPos: TGameHintByPos;
  GameMenu: TGameMenu;
  Keyshift: TShiftState;
  G_enterhint: Boolean;
  GameCheck: TGameCheckThread;
var
  GrobalClick: TCClick;
  ClickTick: integer = 0;
  HitTick: integer = 0;
  QieHuanTick: integer = 0;
  boShiftAttack: Boolean = TRUE;

  mousecheck: boolean = FALSE;
  RightButtonDown: Boolean = FALSE;
  MapAutoPath: boolean = false;
  MapAutoPath2: boolean = false;

  MapAutoPathx, MapAutoPathy: integer;
  MapAutoPathx2, MapAutoPathy2: integer;
  mouseX, mousey: integer;
  ChkMouseX, ChkMousey: integer;
  MouseCellX, MouseCelly: integer;

  boShowChat: Boolean = false; //左侧显示记录
  boShowquest: Boolean = false; //左侧显示任务记录
  boStartInitGamemenu: Boolean = false;
  CurrInitItem: integer = -1;
  ClientIni: TIniFile;

  move_win_form: TForm;
  move_win_Or_baseX: integer;
  move_win_Or_baseY: integer;
  move_win_X: integer;

  move_win_Y: integer;
  move_winClickTick: integer;
  Hitrace: integer;

  FullScreen_time: integer = 0;


  MoveAutoOpenMagictime: integer = 0;

  ProtectAutoOpenMagictime: integer = 0;
  WinVerType: TWinVerType = wvtNew;
  boACTIVATEAPP: boolean = true;
  MagicWindow: integer;
  FBLXZ: Boolean = False;
  MouseMsgArr: array[0..9999] of TMouseInfo;
  MsgArrReadPos: integer = 0;
  MsgArrWritePos: integer = 0;
  MsgArrCount: integer = 0;
  LastMouseTestTick: DWORD = 0;
  GameCheckResult: string;
procedure startOptFont;
const
  maxjj = 13;

function FindMainWindow(h: HWND): HWND;

implementation

uses
  Fbl, FSelChar, FBottom, FQuantity, FSearch, FExchange, FSound, FDepository,
  FbatList, FMuMagicOffer, FcMessageBox, FNPCTrade,
  FCharAttrib, FItemHelp, FPassEtc, FPassEtcEdit, FHistory, FMiniMap, cAIPath,
  FShowPopMsg, FGuild, FWearItemUser, FQuest,
  FBillboardcharts, filepgkclass, energy, FUPdateItemLevel,
  FEmporia, FGameToolsNew, FWearItem, FNEWHailFellow, BaseUIForm //, uMinMap
{$IFDEF gm}
//    , cTm
{$ENDIF}
  , FLittleMap, FnewMagic, Unit_console,
  FNewQuest, FConfirmDialog, FComplexProperties, FItemUpgrade, FGameToolsAssist,
  FBuffPanel, FMonsterBuffPanel;

{$R *.DFM}
{$O+}
var

  first: Boolean = TRUE;
  oldMouseInfo: string = '';
  eventbuffer: array[0..10 - 1] of integer;
    //                        Twhoop
  xview: boolean;
//

function GetCellLengthEx(sx, sy, dx, dy: word): word;
var
  xx, yy, n: integer;
begin
  Result := 0;

  if sx > dx then xx := sx - dx
  else xx := dx - sx;
  if sy > dy then yy := sy - dy
  else yy := dy - sy;

  if xx > 2048 then exit;
  if yy > 2048 then exit;

  n := xx * xx + yy * yy;
  Result := Round(SQRT(n));
end;

procedure pushmousemsg(amsg: Byte; ax, ay: Word); //2016.03.23 在水一方
var
  oldx, oldy: Word;
  oldtick: DWORD;
begin
  with MouseMsgArr[MsgArrWritePos] do begin
    if (amsg = msg) and (ax = x) and (ay = y) then
      exit;
    oldx := x;
    oldy := y;
    oldtick := tick;
  end;
  if MsgArrWritePos >= High(MouseMsgArr) then
    MsgArrWritePos := 0
  else
    MsgArrWritePos := MsgArrWritePos + 1;
  with MouseMsgArr[MsgArrWritePos] do begin
    tick := mmAnsTick;
    msg := amsg;
    ivl := tick - oldtick;
    x := ax;
    y := ay;
    mx := (BackScreen.Cx + (ax - BackScreen.SWidth div 2)) div 32;
    my := (BackScreen.Cy + (ay - BackScreen.SHeight div 2)) div 24;
    Len := GetCellLengthEx(oldx, oldy, ax, ay);
    deg := GetDeg(oldx, oldy, ax, ay);
    if (tick - oldtick > 0) then
      spd := (len div (tick - oldtick))
    else
      spd := 0;
  end;
//  if MsgArrWritePos >= MsgArrReadPos then
//    MsgArrCount := MsgArrWritePos - MsgArrReadPos
//  else
//    MsgArrCount := MsgArrWritePos + (High(MouseMsgArr) - MsgArrWritePos) + 1;
end;

function popmousemsg: PMouseInfo; //2016.03.23 在水一方
var
  oldx, oldy: Word;
  oldtick: DWORD;
begin
  Result := nil;
  if MsgArrReadPos < MsgArrWritePos then
    MsgArrReadPos := MsgArrReadPos + 1
  else if MsgArrReadPos > MsgArrWritePos then begin
    if MsgArrReadPos >= High(MouseMsgArr) then
      MsgArrReadPos := 0
    else
      MsgArrReadPos := MsgArrReadPos + 1;
  end
  else begin
    exit;
  end;
  Result := @MouseMsgArr[MsgArrReadPos];
//  if MsgArrWritePos >= MsgArrReadPos then
//    MsgArrCount := MsgArrWritePos - MsgArrReadPos
//  else
//    MsgArrCount := MsgArrWritePos + (High(MouseMsgArr) - MsgArrWritePos) + 1;
end;

function GetProcessList(var List: TStringList; FileName: string = ''): TProcessEntry32;
var
  Ret: BOOL;
  s: string;
  FProcessEntry32: TProcessEntry32;
  FSnapshotHandle: THandle;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  Ret := Process32First(FSnapshotHandle, FProcessEntry32);
  while Ret do
  begin
    s := ExtractFileName(FProcessEntry32.szExeFile);
    if (FileName = '') then
      List.Add(PChar(s))
    else if (AnsicompareText(Trim(s), Trim(FileName)) = 0) and (FileName <> '') then
    begin
      List.Add(Pchar(s));
      result := FProcessEntry32;
      break;
    end;
    Ret := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function GetProcessPath(ProcessID: Cardinal): string;
var
  pProcess: THandle;
  buf: array[0..MAX_PATH] of char;
  hMod: HMODULE;
  cbNeeded: DWORD;
begin
  Result := '';
  pProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, ProcessID);
  if pProcess <> 0 then
  begin
    if EnumProcessModules(pProcess, @hMod, sizeof(hMod), cbNeeded) then
    begin
      ZeroMemory(@buf, MAX_PATH + 1);
      GetModuleFileNameEx(pProcess, hMod, buf, MAX_PATH + 1);
      Result := strpas(buf);
    end;
  end;
end;

function FoundModuel(moudelname: string; count: integer): string;
var
  Ret: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  PID: integer;
  MoudelList: TStringList;
  ModuleListHandle: Thandle;
  ModuleStruct: TMODULEENTRY32;
  ModuleArray: array of TModuleEntry32;
  i, j, k, founded: integer;
  Yn: boolean;
begin
  moudelname := UpperCase(moudelname);
  MoudelList := TStringList.Create;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  Ret := Process32First(FSnapshotHandle, FProcessEntry32);

  try
    MoudelList.Delimiter := '|';
    MoudelList.DelimitedText := moudelname;
    while Ret do
    begin
      Result := '';
      founded := 0;
      PID := FProcessEntry32.th32ProcessID;
      ModuleListHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, pID);
      ModuleStruct.dwSize := sizeof(ModuleStruct);
      yn := Module32First(ModuleListHandle, ModuleStruct);
      j := 0;
      while (yn) do
      begin
        SetLength(ModuleArray, j + 1);
        ModuleArray[j] := ModuleStruct;
        for k := 0 to MoudelList.Count - 1 do
          if Pos(MoudelList.Strings[k], UpperCase(ModuleStruct.szExePath)) > 0 then begin
            founded := founded + 1;
          end;
        yn := Module32Next(ModuleListHandle, ModuleStruct);
        j := j + 1;
      end;
      CloseHandle(ModuleListHandle);
      if founded >= count then begin
        Result := GetProcessPath(PID); //FProcessEntry32.szExeFile;
        Break;
      end;
      Ret := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
  finally
    CloseHandle(FSnapshotHandle);
    MoudelList.Free;
  end;
end;

type
  TFilterStructure = record
    classname: string;
    caption: string;
    chkoffset: Boolean; //检查位置
    left, top: integer; //相对坐标
    minleft, mintop: integer;
    maxleft, maxtop: integer;
    width, height: integer;
    minwidth, minheight: integer;
    maxwidth, maxheight: integer;
  end;
  PFilterStructure = ^TFilterStructure;

function GetChildWindows(h: HWND; isRecursion: Boolean; PR: TRect; F1, F2, F3: PFilterStructure): Boolean; //isRecursion 递归
var
  buf: array[0..255] of Char;
  arr: array[0..254] of Char;
  p: array[0..2] of PFilterStructure;
  f: array[0..2] of Boolean;
  i, num: integer;
  R: TRect;
begin
  Result := False;
  p[0] := F1;
  p[1] := F2;
  p[2] := F3;
  f[0] := F1 = nil;
  f[1] := F2 = nil;
  f[2] := F3 = nil;
  h := GetWindow(h, GW_CHILD);
  while h <> 0 do
  begin
    GetClassName(h, buf, 255);
    num := GetWindowText(h, arr, 254);
    i := 0;
    //for i := 0 to 2 do
    while i < 3 do
    begin
      Result := true;
      if p[i] <> nil then
      begin
        if (p[i].classname <> '') and (string(buf) <> p[i].classname) then
          Result := False;
        if (p[i].caption <> '') and (string(arr) <> p[i].caption) then
          Result := False;
        if p[i].chkoffset then begin
          GetWindowRect(h, R);
          if (p[i].left <> 0) and (p[i].left <> R.left - PR.Left) then
            Result := False;
          if (p[i].top <> 0) and (p[i].top <> R.top - PR.top) then
            Result := False;
          if (p[i].minleft <> 0) and (p[i].minleft > R.left - PR.Left) then
            Result := False;
          if (p[i].mintop <> 0) and (p[i].mintop > R.top - PR.top) then
            Result := False;
          if (p[i].maxleft <> 0) and (p[i].maxleft < R.left - PR.Left) then
            Result := False;
          if (p[i].maxtop <> 0) and (p[i].maxtop < R.top - PR.top) then
            Result := False;
          if (p[i].width <> 0) and (p[i].width <> R.Right - R.Left) then
            Result := False;
          if (p[i].height <> 0) and (p[i].height <> R.Bottom - R.top) then
            Result := False;
          if (p[i].minwidth <> 0) and (p[i].minwidth > R.Right - R.Left) then
            Result := False;
          if (p[i].minheight <> 0) and (p[i].minheight > R.Bottom - R.top) then
            Result := False;
          if (p[i].maxwidth <> 0) and (p[i].maxwidth < R.Right - R.Left) then
            Result := False;
          if (p[i].maxheight <> 0) and (p[i].maxheight < R.Bottom - R.top) then
            Result := False;
        end;
        if Result then
          f[i] := True;
  //        if num > 0 then ShowMessageFmt('%s %s:%d', [buf, arr, h])
      end;
      i := i + 1;
    end;
    Result := f[0] and f[1] and f[2];
    if Result then exit;

    h := GetWindow(h, GW_HWNDNEXT);
    if isRecursion then
      Result := Result or GetChildWindows(h, isRecursion, PR, F1, F2, F3);
  end;
end;

function FoundWizardWindow(aF1, aF2, aF3: PFilterStructure): string;
var
  szText: array[0..255] of char;
  wndClassName: array[0..254] of char;
  ahWnd: LongInt;
  R: TRect;
  F1, F2, F3: PFilterStructure;
  T1, T2, T3: TFilterStructure;
  dwProcessID: DWORD;
begin
  Result := '';
  //按键小精灵
  FillChar(T1, SizeOf(T1), 0);
  FillChar(T2, SizeOf(T2), 0);
  FillChar(T3, SizeOf(T3), 0);
  T1.caption := '设置';
  T1.classname := 'Button';
  T1.chkoffset := False;
  T1.width := 38;
  T1.height := 30;
  T2.caption := '声明';
  T2.classname := 'Button';
  T2.chkoffset := False;
  T2.width := 38;
  T2.height := 30;
  F1 := @T1;
  F2 := @T2;
  F3 := nil;
  ahWnd := GetWindow(FrmM.Handle, GW_hWndFIRST);
  while ahWnd <> 0 do
  begin
    GetClassName(ahWnd, wndClassName, 254);
    GetWindowText(ahWnd, szText, 255);
    GetWindowRect(ahWnd, R);
    if GetChildWindows(ahWnd, false, R, F1, F2, F3) then begin
      GetWindowThreadProcessId(ahWnd, dwProcessID);
      Result := GetProcessPath(dwProcessID);
      Break;
      //FrmBottom.AddChat(Format('发现按键小精灵 %s',[GetProcessPath(dwProcessID)]), WinRGB(22, 22, 0), 0);
    end;
    ahWnd := GetWindow(ahWnd, GW_hWndNEXT);
  end;
end;

procedure startOptFont;
begin
  OptFont := True;
end;

procedure TFrmM.MinimizeToTrayClick(Sender: TObject);
begin
  Hide;
  if IsWindowVisible(Application.Handle)
    then ShowWindow(Application.Handle, SW_HIDE);
end;

//procedure TFrmM.TrayMessage(var Msg: TMessage);
//var
//  p: TPoint;
//begin
//  case Msg.lParam of
//    WM_LBUTTONDOWN:
//      begin
//        if FrmM.Visible then
//        begin
//          Hide;
//          if IsWindowVisible(Application.Handle) then ShowWindow(Application.Handle, SW_HIDE);
//        end
//        else
//        begin
//          Application.Restore;
//          if WindowState = wsMinimized then WindowState := wsNormal;
//          Visible := True;
//          SetForegroundWindow(Application.Handle);
//          ShowWindow(Application.Handle, SW_show);
//          Show;
//        end;
//      end;
//    WM_RBUTTONDOWN:
//      begin
//        SetForegroundWindow(Handle);
//        GetCursorPos(p);
//        PopUpMenuTray.Popup(p.x, p.y);
//        PostMessage(Handle, WM_NULL, 0, 0);
//      end;
//  end;
//end;

procedure TFrmM.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    WM_ACTIVATE:
      begin
        if TWMActivate(Message).Active = WA_INACTIVE then
        begin
          boACTIVATEAPP := false;

                    // Caption := 'false';
        end else
        begin
          boACTIVATEAPP := true;
                    // Caption := 'true';
        end;
        SoundManager.activateapp(boACTIVATEAPP);
      end;

  end;
end;

procedure TFrmM.OnAppMessage(var Msg: TMsg; var Handled: Boolean);
var
  fframe, fcaption: integer;
begin
  if Msg.wParam = VK_F10 then begin
    if Msg.message = WM_SYSKEYUP then
      Msg.message := WM_KEYUP;
    if Msg.message = WM_SYSKEYDOWN then
      Msg.message := WM_KEYDOWN;
  end;
   // frmHelp.ApplicationEvents1Message(Msg, Handled);
  case Msg.message of
    WM_GAME_CHECK: //2016.03.23 在水一方 >>>>>>
      begin
        frmfbl.SendGameCheckResult(Msg.wParam, Msg.lParam);
      end;
    WM_RBUTTONDOWN:
      begin
        fframe := (Width - ClientWidth) div 2;
        fcaption := (Height - ClientHeight - fframe);
        pushmousemsg(MouseRDnMsg, msg.pt.X - self.Left - Fframe, msg.pt.Y - self.top - fcaption);
        LastMouseTestTick := mmAnsTick;
      end;
    WM_LBUTTONDOWN:
      begin
        fframe := (Width - ClientWidth) div 2;
        fcaption := (Height - ClientHeight - fframe);
        pushmousemsg(MouseLDnMsg, msg.pt.X - self.Left - Fframe, msg.pt.Y - self.top - fcaption);
        LastMouseTestTick := mmAnsTick;
      end;

    WM_LBUTTONUP: move_win_form := nil;
    WM_MOUSEMOVE:
      begin
        fframe := (Width - ClientWidth) div 2;
        fcaption := (Height - ClientHeight - fframe);
        pushmousemsg(MouseMoveMsg, msg.pt.X - self.Left - Fframe, msg.pt.Y - self.top - fcaption);
        LastMouseTestTick := mmAnsTick;


        move_win_X := msg.pt.X - self.Left;
        move_win_Y := msg.pt.Y - self.top;

        move_win_X := move_win_X - Fframe;
        move_win_Y := move_win_Y - fcaption;
      end;
  end;

  if GetAsyncKeyState(VK_SNAPSHOT) <> 0 then
    if boACTIVATEAPP then FrmBottom.ClientCapture;

  if (Msg.message >= WM_MOUSEMOVE) and (Msg.message <= WM_MBUTTONDBLCLK) then
  begin
        //鼠标  事件
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
                {    if not FileExists('.\South.map') then CCheck.rTick := 0;
                    if not FileExists('.\Southobj.obj') then CCheck.rTick := 0;
                    if not FileExists('.\Southrof.Obj') then CCheck.rTick := 0;
                    if not FileExists('.\Southtil.til') then CCheck.rTick := 0;}
        if not pgkmap.isfile('South.map') then CCheck.rTick := 0;
        if not pgkmap.isfile('Southobj.obj') then CCheck.rTick := 0;
        if not pgkmap.isfile('Southrof.Obj') then CCheck.rTick := 0;
        if not pgkmap.isfile('Southtil.til') then CCheck.rTick := 0;
      end;
    2:
      begin
        CCheck.rMsg := CM_CHECK;
        CCheck.rCheck := PsSCheck^.rCheck;
        CCheck.rTick := TimeGetTime;
      end;
  end;
  Frmfbl.SocketAddData(sizeof(CCheck), @CCheck);
end;

procedure TFrmM.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  if boStartInitGamemenu then begin
    GameMenu.Init(CurrInitItem);
    Inc(CurrInitItem);
    if CurrInitItem > MenuArrE then
      boStartInitGamemenu := false;
    Application.ProcessMessages;
  end;
end;

procedure TFrmM.FormCreate(Sender: TObject);
var
  tmpStream: TMemoryStream;
begin
  FShow := True;
  questlist := tstringlist.create;
  boShowquest := True;
  if not G_Default1024 then
  begin
    ClientHeight := fhei;
    ClientWidth := fwide;
    DXDraw.Display.Width := fwide;
    DXDraw.Display.Height := fhei;
    DXDraw.SurfaceHeight := fhei;
    DXDraw.SurfaceWidth := fwide;
  end
  else
  begin
    ClientHeight := fhei1024;
    ClientWidth := fwide1024;
    DXDraw.Display.Width := fwide1024;
    DXDraw.Display.Height := fhei1024;
    DXDraw.SurfaceHeight := fhei1024;
    DXDraw.SurfaceWidth := fwide1024;
  end;

//  Application.OnMinimize := MinimizeToTrayClick;
//  TrayIconData.cbSize := SizeOf(TrayIconData);
//  TrayIconData.Wnd := Handle;
//  TrayIconData.uID := 0;
//  TrayIconData.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
//  TrayIconData.uCallbackMessage := WM_ICONTRAY;
//  TrayIconData.hIcon := Application.Icon.Handle;
//  lstrcpy(@TrayIconData.szTip, pchar(fname));
//  Shell_NotifyIcon(NIM_ADD, @TrayIconData);

  netPingSendTick := 0;
  netPingId := 0;
  GameHint := TGameHint.Create;
  GameHintByPos := TGameHintByPos.Create;
  GameHintByPos.UserMaxArea := True;
  GameHintByPos.UsePos := True;
  GameMenu := TGameMenu.Create;
  //CreateThread(nil, 0, @_initGameMenu, nil, 0, ID);
{$IFDEF gm}
  //  frmTM := nil;
{$ENDIF}
  NameChangeColor := ColorSysToDxColor($00FF00);

  DoubleBuffered := true;

  dxTick := 0;
  move_winClickTick := 0;
  if doFullScreen in DxDraw.Options then BorderStyle := bsNone
  else begin //BorderStyle := bsDialog;           //2015.11.10 在水一方
    BorderStyle := bsSingle;
    BorderIcons := [biSystemMenu, biMinimize];
  end;
    //  LeftTextScroll := TTextScroll.Create;
  Chdir(ExtractFilePath(Application.ExeName));

  ClientIni := TIniFile.Create('.\ClientIni.ini');
  mainFont := ClientIni.ReadString('FONT', 'FontName', '宋体'); // font read
    // FrmM Font Set
  mainFont := '宋体';
  FrmM.Font.Name := mainFont;
  A2FontClass.SetFont(mainFont);
    // A2FontClass.SetFont(Font.Name);

  FormList := TList.Create;

  SoundManager := TSoundManager.Create(DxSound1, '.\wav\wav1000y.atw', '.\wav\effect.atw', DXWaveList1);
  SoundManager.Volume := ClientIni.ReadInteger('SOUND', 'BASEVOLUME', -1000);

    //BaseAudio := TBaseAudio.Create;
    //BaseAudio.SetVolume (SoundManager.Volume);

  {  if ClientIni.ReadString('CLIENT', 'SOUND', 'ON') <> 'ON' then
    boUseSound := FALSE
    else boUseSound := TRUE; }

  FrmM.SoundManager.VolumeEffect := ClientIni.ReadInteger('SOUND', 'EFFECTVOLUME', -2000);

    //   ActiveBaseAudioList := TActiveBaseAudioList.Create;

   // SoundManager.PlayBaseAudio('logon.wav', 5);
  SoundManager.PlayBaseAudioMp3('1003.mp3', 5);
    //  SoundManager.PlayBaseAudio('1003.wav', 5);

  BottomUpImage := TA2Image.Create(4, 4, 0, 0);
    //  BottomUpImage.LoadFromFile('upbottom.bmp'); //'bottomup.bmp');
//  if WinVerType = wvtOld then
//  begin
//    pgkBmp.getbmp('upbottom.bmp', BottomUpImage);
//  end
//  else if WinVerType = wvtNew then
//  begin
//    if not zipmode then //2015.11.13 在水一方 >>>>>>
//    begin
//      if G_Default1024 then
//        BottomUpImage.LoadFromFile('.\ui\img\操作界面_底框上_1024.bmp')
//      else
//        BottomUpImage.LoadFromFile('.\ui\img\操作界面_底框上半部分.bmp');
//    end
//    else begin
//      tmpStream := TMemoryStream.Create;
//      try
//        if G_Default1024 then
//          upzipstream(bmpzipstream, tmpStream, '操作界面_底框上_1024.bmp')
//        else
//          upzipstream(bmpzipstream, tmpStream, '操作界面_底框上半部分.bmp');
//        BottomUpImage.LoadFromStream(tmpStream);
//      finally
//        tmpStream.Free;
//      end;
//    end; //2015.11.13 在水一方 <<<<<<
//  end;
  BottomUpImage.TransparentColor := 0;
  //AttribLeftImage := TA2Image.Create(4, 4, 0, 0);
    //AttribLeftImage.LoadFromFile('attribleft.bmp');

  //pgkBmp.getbmp('attribleft.bmp', AttribLeftImage);
  //AttribLeftImage.TransparentColor := 0;
  BackScreen := TBackScreen.Create;
  DragItem := TDragItem.Create;
  TileDataList := TTileDataList.Create;
  ObjectDataList := TObjectDataList.Create;
  RoofDataList := TObjectDataList.Create;

  Map := TMap.Create;
  EffectPositionClass := TEffectPositionClass.Create;
  Animater := TAnimater.Create;
  AtzClass := TAtzClass.Create();
  EtcAtzClass := TEtcAtzClass.Create;

  CharList := TCharList.Create(AtzClass);
  ChatList := TStringList.Create;

  PersonBat := TPersonBat.Create;
  Application.OnMessage := OnAppMessage;
  GameCheck := TGameCheckThread.Create(False);

//  boStartInitGamemenu := true;           //@@
//  Application.OnIdle := ApplicationIdle; //@@
    //MinMap := TMinMap.Create;
end;

procedure TFrmM.FormDestroy(Sender: TObject);
begin
  if not GameCheck.Terminated then
    GameCheck.Terminate;
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
    //    LeftTextScroll.Free;
  ClientIni.WriteString('FONT', 'FontName', mainFont);
  GameHint.Free;
  GameHintByPos.Free;
  GameMenu.Free;
  ChatList.free;
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

  //AttribLeftImage.Free;
  BottomUpImage.Free;
  SoundManager.Free;

    //   ActiveBaseAudioList.Free;
  PersonBat.Free;

  DXSound1.Finalize;
  ClientIni.Free;
  EffectPositionClass.Free;
  questlist.free;
    //MinMap.Free;
  UnRegHotKey;
  ClearFormList; // 内存泄漏009 在水一方 2015.05.18
  FormList.Free;
end;

function TFrmM.findForm(AClassName: string): TForm;
var
  pf: PTFormData;
  i: Integer;
begin
  Result := nil;
  for i := 0 to FormList.Count - 1 do
  begin
    pf := FormList[i];
    if pf^.rForm.ClassName = AClassName then
    begin
      if pf^.rForm.Visible then
      begin
        Result := pf^.rForm;
        Break;
      end;
    end;
  end;
end;


procedure TFrmM.ClearFormList; // 内存泄漏009 在水一方 2015.05.18
var
  i: integer;
  pf: PTFormData;
begin
  for i := FormList.Count - 1 downto 0 do
  begin
    pf := FormList[i];
    dispose(pf);
    FormList.Delete(i);
  end;
end;

procedure TFrmM.DrawquestList; //任务内容直接输出

  function Request(str: string): string;
  var
    s1, s2: string;
    i: integer;
    temp, tempsub: TStringlist;
    p: ptitemdata;
  begin
    result := str;
    temp := TStringlist.Create;
    try
      if ExtractStrings(['(', ')'], [#13, #10], pchar(str), temp) = 0 then Exit;
      if temp.Count = 0 then exit;
      for i := 0 to temp.Count - 1 do
      begin
        str := temp.Strings[i];
        tempsub := TStringlist.Create;
        try
          ExtractStrings(['|'], [#13, #10], pchar(str), tempsub);
                    //1,任务背包无物品替换文字,2物品真实名字()
          if tempsub.Count >= 2 then
          begin
            s1 := tempsub.Strings[0];
            p := HaveItemQuestClass.getname(tempsub.Strings[1]);
            if p <> nil then
            begin
              s1 := format('%s:%d/%d', [p.rViewName, p.rCount, p.rMaxCount]);
            end;
            result := s1;
          end;
        finally
          tempsub.Free;
        end;
      end;
    finally
      temp.Free;
    end;

  end;
  function _settextcolor(aid: integer; back: boolean): integer;
  var
    col: integer;
    fcol, bcol: word;
    astr: string;
  begin

    fcol := ColorSysToDxColor(clWhite);
    bcol := ColorSysToDxColor(clBlack);
    astr := ' ';
       { if FrmM.questlist.Count > aid then
        begin
            col := Integer(FrmM.questlist.Objects[aid]);

            fcol := LOWORD(Col);
            bcol := HIWORD(col);
            astr := FrmM.questlist.Strings[aid];
        end;  }

    FrmM.questlist.Strings[aid] := Request(FrmM.questlist.Strings[aid]);
    if FrmM.questlist.Strings[aid] = '主线' then fcol := ColorSysToDxColor(clred);
    if FrmM.questlist.Strings[aid] = '随机任务' then fcol := ColorSysToDxColor(clgreen);
    if bcol = 0 then bcol := ColorSysToDxColor($001C1C1C);

    if astr = '' then astr := ' ';
    if back then result := bcol else result := fcol;
     //   atemp.BackColor := bcol;
      //  atemp.FontColor := fcol;
      //  atemp.Caption := astr;
  end;
var
  i: integer;

begin



    //   A2SetFontColor (RGB (12, 12, 12)); // back

  for i := 0 to FrmM.questlist.Count - 1 do
  begin

    if fwide = 800 then ATextOut(BackScreen.Back, 630 + 1, i * 16 + 170 + 1, _settextcolor(i, true), FrmM.questlist.Strings[i])
    else ATextOut(BackScreen.Back, 820 + 1, i * 16 + 420 + 1, _settextcolor(i, true), FrmM.questlist.Strings[i]);
    //  ATextOut(BackScreen.Back, 20 + 1, i * 16 + 1+435, WinRGB(1, 1, 1), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20+1, i*16+20+1, ChatList[i]);
  end;

    //   A2SetFontColor (clsilver);         // front
  for i := 0 to FrmM.questlist.Count - 1 do
  begin
      //  ATextOut(BackScreen.Back, 20, i * 16 + 435, _settextcolor(i,false), ChatList[i]);
    if fwide = 800 then ATextOut(BackScreen.Back, 630, i * 16 + 170, _settextcolor(i, false), FrmM.questlist.Strings[i])
    else ATextOut(BackScreen.Back, 820, i * 16 + 420, _settextcolor(i, false), FrmM.questlist.Strings[i]);
     //   ATextOut(BackScreen.Back, 20, i * 16+435  , WinRGB(24, 24, 24), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20, i*16+20, ChatList[i]);
  end;
end;

procedure TFrmM.AddChat(astr: string; fcolor, bcolor: integer);
var
  str, rdstr: string;
  col: Integer;
  addflag: Boolean;
begin
  addflag := FALSE;
  str := astr;
  while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    if rdstr = '' then break;

    if chat_outcry then
    begin // 寇摹扁
      if rdstr[1] = '[' then addflag := TRUE;
    end;

    if chat_Guild then
    begin // 辨靛
      if rdstr[1] = '<' then addflag := TRUE;
    end;

    if chat_notice then
    begin // 傍瘤荤亲
      if bcolor = 16912 then addflag := TRUE;
    end;

    if chat_normal then
    begin // 老馆蜡历
      if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
      begin
        addflag := TRUE;
      end;
    end;

    if Addflag then
    begin
      if ChatList.Count >= 10 then ChatList.delete(0); //聊天记录的行数
      col := MakeLong(fcolor, bcolor);
      ChatList.addObject(rdstr, TObject(col));
      if SaveChatList.Count > 500 then SaveChatList.Delete(0);
      SaveChatList.Add(rdstr);
    end;
  end;
end;

procedure TFrmM.SetA2Form(aForm: TForm; aA2Form: TA2Form);
var
  flag: Boolean;
  i: integer;
  pf: PTFormData;
begin
  if (Formlist.Count > 0) and (PTFormData(FormList[0])^.rForm = aForm) then exit;

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

procedure TFrmM.DXDrawInitialize(Sender: TObject);
begin
  if first then
  begin
    first := FALSE;
    Timer2_dx.Enabled := TRUE;
    Frmfbl.visible := TRUE;
    //    Frmfbl.FormActivate(Self);
  end;


end;

function TFrmM.GetMouseDirection: word;
var
  xx, yy: integer;
  MCellX, MCellY: integer;
  Cl, Sl: TCharClass;
begin
  Result := DR_DONTMOVE;
  Cl := CharList.CharGet(CharCenterId);
  if cl = nil then exit;
    //XX YY  图象坐标
  xx := BackScreen.Cx + (Mousex - BackScreen.SWidth div 2);
  yy := BackScreen.Cy + (Mousey - BackScreen.SHeight div 2);

    //换算 到 地图 坐标
  MCellX := xx div UNITX;
  MCellY := yy div UNITY;

  if SelectedChar <> 0 then
  begin
    SL := CharList.CharGet(SelectedChar);
    if SL <> nil then
    begin
      MCellX := Sl.X;
      MCellY := SL.Y;
    end;
  end;
    //计算 方向
  Result := GetViewDirection(cl.x, cl.y, mcellx, mcelly);
end;

var
  SelScreenId: integer = 0;
  SelScreenX: integer = 0;
  SelScreenY: integer = 0;

function TFrmM.send_hit_Selectid(): boolean;
var
  cHit: TCHit;
  CL: TCharClass;
  CLAtt: TCharClass;
  BOatt: TDynamicObject;
  it: TItemClass;
  procedure _sendHit(aid: integer);
  begin
    Hitrace := 0;
    HitTick := mmAnsTick;
    cHit.rmsg := CM_HIT;
    cHit.rkey := GetMouseDirection;
    cHit.rtid := aid;
    Frmfbl.SocketAddData(sizeof(cHit), @cHit);
        // FrmBottom.AddChat('测试消息：攻击指令', WinRGB(22, 22, 0), 0);
    SendHit_ID := aid;
    //FrmBottom.AddChat('攻击对象ID：' + IntToStr(SendHit_ID), WinRGB(1, 31, 31), WinRGB(1, 14, 20));
  end;

  function _hitChar(): boolean;
  begin
    result := false;
    if FrmGameToolsNew.A2CheckBox_MonsterHit.Checked and (FrmGameToolsNew.A2ComboBox_MonsterList.Text <> '') then
      SelectedChar := AutoSelectedChar;
        //人 怪物 等活动物体
    if SelectedChar <> 0 then
    begin
      if SelectedChar = CharCenterId then exit; //自己 ID 结束
      CLAtt := CharList.CharGet(SelectedChar); //查找目标
      if clatt = nil then exit; //目标无效

            //boAttack := true;

      if (ssCtrl in KeyShift) //按了 CTRL
        or (Hitrace = RACE_HUMAN) //历史 攻击 是人
        or frmGameToolsNew.A2CheckBox_Hit_not_Ctrl.Checked then
                //or frmGameTools.RzCheckBox_Hit_not_Ctrl.Checked//外挂 开免 按CTRL
      begin
        if (CLAtt.Feature.rrace = RACE_HUMAN) then
        begin
          _sendHit(SelectedChar);
          Hitrace := RACE_HUMAN;
          result := true;
          exit;
        end;
      end;
      if (Cl.Feature.rfeaturestate = wfs_care) then
      begin
        if (CLAtt.Feature.rrace = RACE_MONSTER) then
        begin
          _sendHit(SelectedChar);
          result := true;
          exit;
        end;
      end;
      if (ssShift in KeyShift)
        or (FrmGameToolsNew.A2CheckBox_Hit_not_Shift.Checked and (CLAtt.Feature.rrace = RACE_MONSTER)) then
      begin
        if (CLAtt.Feature.rrace = RACE_MONSTER)
          or (CLAtt.Feature.rrace = RACE_NPC)
          or (CLAtt.Feature.rrace = RACE_STATICITEM) then
        begin
          _sendHit(SelectedChar);
          result := true;
          exit;
        end;
      end;
    end;
  end;
  function _hititem(): boolean;
  begin
    result := false;
        //动态 物体
    if SelectedDynamicItem <> 0 then
    begin
      if SelectedDynamicItem = CharCenterId then exit; //自己 ID 结束
      BOatt := CharList.GeTDynamicObjItem(SelectedDynamicItem); //查找目标
      if BOatt = nil then exit; //目标无效

      if FrmGameToolsNew.A2CheckBox_Hit_not_Shift.Checked
        or (ssShift in KeyShift) or (Cl.Feature.rfeaturestate = wfs_care)
        then
      begin
        _sendHit(SelectedDynamicItem);
        result := true;
        exit;
      end;
    end;
    if Selecteditem <> 0 then
    begin
      if Selecteditem = CharCenterId then exit; //自己 ID 结束
      it := CharList.GetItem(Selecteditem); //查找目标
      if it = nil then exit; //目标无效
      if it.Race <> RACE_STATICITEM then exit;
      if (ssShift in KeyShift) then
      begin
        _sendHit(Selecteditem);
        result := true;
        exit;
      end;
    end;
  end;

begin
  result := false;
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;

  if Cl.Feature.rfeaturestate = wfs_die then exit; //自己状态 不能 攻击
  if Cl.Feature.rfeaturestate <> wfs_care then Hitrace := 0;

  if mmAnsTick < HitTick + 200 then exit; //攻击 间隔

  if _hitChar then
  begin
    result := true;
  end else
  begin
    if _hititem then
      result := true;
  end;
end;

function TFrmM.send_Booth_Click(): boolean;
var
  CL: TCharClass;
begin
  result := false;
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  if SelectedChar = 0 then exit;

  Cl := CharList.CharGet(SelectedChar);
  if Cl = nil then exit;
  if Cl.rbooth = false then exit;

  //FrmBooth.SendOpenWindowUser(cl.rName);
  result := true;
end;

function TFrmM.send_drink(): boolean;
var
  cl: TCharClass;
  bo: TVirtualObjectClass;
  Cdrink: TCdrink;
  ax, ay: integer;
begin

  result := false;
  if SelectedVirtualObject = 0 then exit;
  cl := CharList.CharGet(CharCenterId);
  if cl = nil then exit;

  bo := CharList.VirtualObjectList.get(SelectedVirtualObject);
  if bo = nil then exit;
  ax := BackScreen.Cx + (Mousex - BackScreen.SWidth div 2); //- 32 div 2;
  ay := BackScreen.Cy + (Mousey - BackScreen.SHeight div 2); // - 24 div 2;
  ax := ax div 32;
  ay := ay div 24;
  Cdrink.rmsg := CM_drink;
  Cdrink.rclickedId := SelectedVirtualObject;
  Cdrink.rX := ax;
  Cdrink.rY := ay;
  Frmfbl.SocketAddData(sizeof(Cdrink), @Cdrink);

  result := true;

end;

function TFrmM.send_get_WearItemUser(aid: integer): boolean;
var
  CLAtt: TCharClass;
  tt: TGET_cmd;
  temp: TWordComData;
begin
  result := false;
  if aid = 0 then exit;
  Clatt := CharList.CharGet(aid);
  if Clatt = nil then exit;
  if CLAtt.Feature.rrace <> RACE_HUMAN then exit;
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_UserObject);
  WordComData_ADDbyte(temp, UserObject_WearItem);
  WordComData_ADDdword(temp, aid);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
  frmWearItemUser.FUSERID := aid;
  result := true;
end;

function TFrmM.send_get_NameUser(aid: integer): boolean;
var
  CLAtt: TCharClass;
  tt: TGET_cmd;
  temp: TWordComData;
begin
  result := false;
  if aid = 0 then exit;
  Clatt := CharList.CharGet(aid);
  if Clatt = nil then exit;
  if CLAtt.Feature.rrace <> RACE_HUMAN then exit;
  FrmBottom.EdChat.Text := '@纸条 ' + Clatt.rName + ' ';
  FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
  result := true;
end;

   
function TFrmM.send_get_CharBuff(aid: integer): boolean;
var
  cl: TCharClass;
begin
  if aid <> 0 then
  begin
    cl := CharList.CharGet(aid);
    if  (cl.Feature.rrace = RACE_HUMAN) or (cl.Feature.rrace = RACE_MONSTER) then
    begin
      if frmMonsterBuffPanel.FSelectCharId <> aid then
        frmMonsterBuffPanel.CloseTimer;
      frmMonsterBuffPanel.FSelectCharId := aid;
      frmMonsterBuffPanel.FSelectCharName := cl.rName;
      if frmMonsterBuffPanel.Send_Get_BuffData then
      begin
        frmMonsterBuffPanel.DrawStructed(1, 100, 0);
        frmMonsterBuffPanel.Visible := True;
        frmMonsterBuffPanel.OpenTimer;
      end
      else
      begin
        frmMonsterBuffPanel.CloseTimer;
      end;
    end else
    begin
    end;

  end
  else
    frmMonsterBuffPanel.CloseTimer;
end;

procedure TFrmM.PaintLabelClick(Sender: TObject);
var
  key, iId: integer;
  cl: TCharClass;
begin
  if send_Booth_Click then exit;
  if AutoSelectedChar <> 0 then
    AutoSelectedChar := SelectedChar;

  if FrmGameToolsNew.A2CheckBox_autoHIt.Checked then
  begin
    if FrmGameToolsNew.A2CheckBox_Hit_not_Shift.Checked or FrmGameToolsNew.A2CheckBox_Hit_not_Ctrl.Checked then //2015.04.27 在水一方新增本行
      AutoHit_begin(SelectedChar);
  end else
  begin
    send_hit_Selectid;
  end;
//        if AutoHit_begin(SelectedChar) then exit;
 //   if send_hit_Selectid then exit;


  iID := 0;
  ClickTick := mmAnsTick;
  FillChar(GrobalClick, sizeof(GrobalClick), 0);
  key := GetMouseDirection;

  if SelectedChar <> 0 then iID := SelectedChar;
  if SelectedItem <> 0 then iID := SelectedItem;
  if SelectedDynamicItem <> 0 then iID := SelectedDynamicItem;

  if iID = 0 then exit;


  if SelectedChar <> 0 then
  begin
    cl := CharList.CharGet(SelectedChar);
    begin
      //如果按住shift或者ctrl 不发送点击信息
      if (ssShift in KeyShift) or (ssCtrl in KeyShift) then
      begin
        if (cl.Feature.rrace = RACE_NPC) or (cl.Feature.rrace = RACE_MONSTER) then
          Exit;
      end;
    end;
  end;


  GrobalClick.rmsg := CM_CLICK;
  GrobalClick.rwindow := WINDOW_SCREEN;
  GrobalClick.rclickedId := iID;
  GrobalClick.rShift := KeyShift;
  GrobalClick.rkey := key;
end;

procedure TFrmM.PaintLabelDblClick(Sender: TObject);
begin
  send_drink;
  if send_hit_Selectid then exit;
end;

procedure TFrmM.PaintLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
begin
  if Source = nil then exit;

  with Source as TDragItem do
  begin
    case SourceID of
      WINDOW_ITEMS: ;
      WINDOW_SCREEN: ;
      WINDOW_ShortcutItem: ;
    else exit;
    end;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := DragedId;

    cDragDrop.rdestId := 0;
    if SelectedDynamicItem <> 0 then cDragDrop.rdestId := SelectedDynamicItem;
    if Selecteditem <> 0 then cDragDrop.rdestId := SelectedItem;
    if SelectedChar <> 0 then cDragDrop.rdestId := SelectedChar;
    cdragdrop.rsx := sx;
    cdragdrop.rsy := sy;
    cdragdrop.rdx := mouseCellx;
    cdragdrop.rdy := mouseCelly;

    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_SCREEN;
    case SourceId of
      WINDOW_ITEMS:
        begin
          cDragDrop.rsourkey := Selected;
          if cDragDrop.rdestId = 0 then
            if HaveItemclass.IS_Drop(Selected) = false then
            begin
              FrmBottom.AddChat('无法丢弃的物品', WinRGB(22, 22, 0), 0);
              exit;
            end;
        end;
      WINDOW_WEARS: cDragDrop.rsourkey := Selected;
      WINDOW_ShortcutItem:
        begin
                    //清除
          cDragDrop.rsourkey := Selected;
          cKeyClass.del(Selected);
         // FrmBottom.ShortcutKeySET(Selected, -1);
          exit;
        end;
    end;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  end;
end;

procedure TFrmM.PaintLabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  Cl: TCharClass;
  IT: TItemClass;
  AIT: TDynamicObject;
  curEBP, val1, ms, me: Cardinal;
  p: ^Cardinal;
begin

  asm
    mov curEBP,ebp  ;
  end;
  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  p := Pointer(curEBP + 4);
  val1 := p^;
  if (val1 < ms) or (val1 > me) then begin
    exit;
  end
  else begin
    mousex := x;
    mousey := y;
    ChkMousex := x;
    ChkMousey := y;
  end;

  MouseCellX := (BackScreen.Cx - BackScreen.SWidth div 2 + Mousex) div UNITX;
  MouseCellY := (BackScreen.Cy - BackScreen.SHeight div 2 + Mousey) div UNITY;

  CharList.MouseMove(BackScreen.Cx + (Mousex - BackScreen.SWidth div 2), BackScreen.Cy + (Mousey - BackScreen.SHeight div 2));
  if (SelectedChar = 0) and (SelectedItem = 0) then MouseInfoStr := '';
  if SelectedChar <> 0 then
  begin
    Cl := CharList.CharGet(SelectedChar);
    if Cl <> nil then MouseInfoStr := Cl.rName;
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
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_ITEMS then Accept := TRUE;
      if SourceID = WINDOW_SCREEN then Accept := TRUE;
      if SourceID = WINDOW_ShortcutItem then Accept := TRUE;

    end;
  end;
end;

procedure TFrmM.PaintLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  curEBP, val1, ms, me: Cardinal;
  p: ^Cardinal;
  cl: TCharClass;
begin
  if not boStartInitGamemenu and (GameMenu <> nil) and GameMenu.Visable then begin
    if GameMenu.CurrItem < 0 then
      GameMenu.Close
    else
    begin
      GameMenu.MouseDown;
      Exit;
    end;

  end;
    //
  if PersonBat.MouseDown(Sender, Button, Shift, X, Y) then
  begin
    exit;
  end;

  asm
    mov curEBP,ebp  ;
  end;
  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  p := Pointer(curEBP + 4);
  val1 := p^;
  if (val1 < ms) or (val1 > me) then begin
    exit;
  end
  else begin
    mousex := x;
    mousey := y;
    ChkMousex := x;
    ChkMousey := y;
  end;
  //alt + 鼠标右键  查看玩家装备
  if mbRight = Button then
  begin
    FRightMove := True;
    AutoHit_stop;
    FrmMiniMap.StopAutoMOVE;
    if ssAlt in Shift then
    begin
      if send_get_WearItemUser(SelectedChar) then exit;
    end;
    mousecheck := TRUE;
    RightButtonDown := TRUE;

    exit;
  end;
  //alt + 鼠标左键 (玩家 快捷纸条)
  if mbLeft = Button then
  begin
    if ssAlt in Shift then
    begin
      if send_get_NameUser(SelectedChar) then exit;
    end;
  end;

  SelScreenId := 0;
  if SelectedChar <> 0 then SelScreenId := SelectedChar;

  if SelectedItem <> 0 then SelScreenId := SelectedItem;

  if SelScreenId <> 0 then
  begin
    SelScreenX := x;
    SelScreenY := y;
  end else
  begin
    SelScreenX := 0;
    SelScreenY := 0;
  end;

  send_get_CharBuff(SelectedChar);

end;

procedure TFrmM.PaintLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Cl: TCharClass;
  IT: TItemClass;
  AIT: TDynamicObject;
  curEBP, val1, ms, me: Cardinal;
  p: ^Cardinal;
begin

  GameHint.Close;
  FrmAttrib.FITEMA2Hint.FVisible := false;
  if PersonBat.MouseMove(Sender, Shift, X, Y) then exit;

  asm
    mov curEBP,ebp  ;
  end;
  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  p := Pointer(curEBP + 4);
  val1 := p^;
  if (val1 < ms) or (val1 > me) then begin
    exit;
  end
  else begin
    mousex := x;
    mousey := y;
    ChkMousex := x;
    ChkMousey := y;
  end;

  if not boStartInitGamemenu and (GameMenu <> nil) and GameMenu.ProcessMove then Exit;

  if RightButtonDown then mousecheck := TRUE;

  CharList.MouseMove
    (BackScreen.Cx + (Mousex - BackScreen.SWidth div 2)
    , BackScreen.Cy + (Mousey - BackScreen.SHeight div 2));
  if (SelectedChar = 0) and (SelectedItem = 0) and (SelectedDynamicItem = 0) then MouseInfoStr := '';

  if SelectedChar <> 0 then
  begin
    Cl := CharList.CharGet(SelectedChar);
    if Cl <> nil then
      if Cl.Feature.rHideState = hs_100 then
      begin
        MouseInfoStr := Cl.rName;
        if GetKeyState(VK_MENU) < 0 then FrmBottom.EdChat.Text := Cl.rName;
      end;
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
  if (SelScreenId <> 0) and (abs(SelScreenX - x) + abs(SelScreenY - y) > 10) then PaintLabel.BeginDrag(TRUE);
end;

procedure TFrmM.PaintLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  curEBP, val1, ms, me: Cardinal;
  p: ^Cardinal;
begin
    //    FrmMiniMap.StopAutoMOVE;
  if PersonBat.MouseUp(Sender, Button, Shift, X, Y) then
  begin
    RightButtonDown := FALSE;
    exit;
  end;

  asm
    mov curEBP,ebp  ;
  end;
  ms := MyModstart xor 1235689;
  me := MyModEnd xor 2345689;
  p := Pointer(curEBP + 4);
  val1 := p^;
  if (val1 < ms) or (val1 > me) then begin
    exit;
  end
  else begin
    mousex := x;
    mousey := y;
    ChkMousex := x;
    ChkMousey := y;
  end;

  RightButtonDown := FALSE;

  if abs(SelScreenX - x) + abs(SelScreenY - y) < 10 then
  begin
    SelScreenX := 0;
    SelScreenY := 0;
    SelScreenId := 0;
  end;
end;

procedure TFrmM.PaintLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  DragItem.Dragedid := SelScreenId;
  DragItem.SourceId := WINDOW_SCREEN;
  DragItem.sx := mouseCellX;
  DragItem.sy := mouseCellY;
  DragObject := DragItem;
  SelScreenId := 0;
end;

procedure TFrmM.map_move(mx, my: integer);
begin
  MapAutoPath := true;
  MapAutoPathx := mx;
  MapAutoPathy := my;
end;

function TFrmM.AutoPathAI(cx, cy: word): integer;
  function _GetDistance(a, b: word): integer;
  begin
    if a > b then Result := a - b
    else Result := b - a;
  end;
  function _isMovable(ax, ay: word): boolean;
  begin
    Result := false;
    if map.isMovable(ax, ay) and CharList.isMovable(ax, ay) then Result := true;
  end;
var
  i: integer;
  len: dword;
  adir: word; //距离 方向
  mx, my: word;
  lenArr: array[0..7] of dword;
  boArr: array[0..7] of boolean;
  ckey: TCKey;
  cMove: TCMove;
  cl: TCharClass;
begin
  Result := 2;
  cl := CharList.CharGet(CharCenterId);
  if cl = nil then exit;
  if Cl.AllowAddAction = FALSE then exit;

  len := _GetDistance(cl.x, cx) + _GetDistance(cl.y, cy);
  if len = 0 then
  begin
    Result := 0;
    exit;
  end;

    //计算方向
  adir := GetNextDirection(cl.x, cl.y, cx, cy);
    //计算下一个坐标
  mx := cl.x;
  my := cl.y;
  GetNextPosition(adir, mx, my);
  if (mx = cx) and (my = cy) and not Map.isMovable(mx, my) then
  begin
    if cl.dir <> adir then
    begin
            //转方向
      ckey.rmsg := CM_TURN;
      ckey.rkey := adir;
      if Frmfbl.ISMsgCmd(CM_TURN) = false then exit;
      Frmfbl.SocketAddData(sizeof(ckey), @ckey);
      CL.ProcessMessage(SM_TURN, adir, cl.x, cl.y, cl.feature, 0);
    end;

    Result := 1;
    exit;
  end;

  for i := 0 to 7 do lenArr[i] := $FFFFFFFF;

    //上
  boArr[0] := _isMovable(cl.x, cl.y - 1);
  if (OldCharPos.X = cl.x) and (OldCharPos.y = cl.y - 1) then boArr[0] := false;
  if boArr[0] then
    lenArr[0] := (cl.x - cx) * (cl.x - cx) + (cl.y - 1 - cy) * (cl.y - 1 - cy);

    //右上
  boArr[1] := _isMovable(cl.x + 1, cl.y - 1);
  if (OldCharPos.X = cl.x + 1) and (OldCharPos.Y = cl.y - 1) then boArr[1] := false;
  if boArr[1] then
    lenArr[1] := (cl.x + 1 - cx) * (cl.x + 1 - cx) + (cl.y - 1 - cy) * (cl.y - 1 - cy);

    //右
  boArr[2] := _isMovable(cl.x + 1, cl.y);
  if (OldCharPos.X = cl.x + 1) and (OldCharPos.Y = cl.y) then boArr[2] := false;
  if boArr[2] then
    lenArr[2] := (cl.x + 1 - cx) * (cl.x + 1 - cx) + (cl.y - cy) * (cl.y - cy);

    //右下
  boArr[3] := _isMovable(cl.x + 1, cl.y + 1);
  if (OldCharPos.X = cl.x + 1) and (OldCharPos.Y = cl.y + 1) then boArr[3] := false;
  if boArr[3] then
    lenArr[3] := (cl.x + 1 - cx) * (cl.x + 1 - cx) + (cl.y + 1 - cy) * (cl.y + 1 - cy);
    //下
  boArr[4] := _isMovable(cl.x, cl.y + 1);
  if (OldCharPos.X = cl.x) and (OldCharPos.Y = cl.y + 1) then boArr[4] := false;
  if boArr[4] then
    lenArr[4] := (cl.x - cx) * (cl.x - cx) + (cl.y + 1 - cy) * (cl.y + 1 - cy);

    //左下
  boArr[5] := _isMovable(cl.x - 1, cl.y + 1);
  if (OldCharPos.X = cl.x - 1) and (OldCharPos.Y = cl.y + 1) then boArr[5] := false;
  if boArr[5] then
    lenArr[5] := (cl.x - 1 - cx) * (cl.x - 1 - cx) + (cl.y + 1 - cy) * (cl.y + 1 - cy);

    //左
  boArr[6] := _isMovable(cl.x - 1, cl.y);
  if (OldCharPos.X = cl.x - 1) and (OldCharPos.Y = cl.y) then boArr[6] := false;
  if boArr[6] then
    lenArr[6] := (cl.x - 1 - cx) * (cl.x - 1 - cx) + (cl.y - cy) * (cl.y - cy);

    //左上
  boArr[7] := _isMovable(cl.x - 1, cl.y - 1);
  if (OldCharPos.X = cl.x - 1) and (OldCharPos.Y = cl.y - 1) then boArr[7] := false;
  if boArr[7] then
    lenArr[7] := (cl.x - 1 - cx) * (cl.x - 1 - cx) + (cl.y - 1 - cy) * (cl.y - 1 - cy);

  len := $FFFFFFFF;

  for i := 0 to 7 do
  begin
    if (len > lenArr[i]) then
    begin
      adir := i;
      len := lenArr[i];
    end;
  end;

  mx := cl.x;
  my := cl.y;

  if (cl.dir <> adir) then
  begin
        //转方向
    ckey.rmsg := CM_TURN;
    ckey.rkey := adir;
    if Frmfbl.ISMsgCmd(CM_TURN) = false then exit;
    Frmfbl.SocketAddData(sizeof(ckey), @ckey);
    CL.ProcessMessage(SM_TURN, adir, cl.x, cl.y, cl.feature, 0);
  end
  else
  begin
    GetNextPosition(adir, mx, my);
        //移动
    if _isMovable(mx, my) then
    begin
      OldCharPos.X := cl.x;
      OldCharPos.y := cl.y;

      cmove.rmsg := CM_MOVE;
      cmove.rdir := adir;
      cmove.rx := mx;
      cmove.ry := my;
      cmove.rmmAnsTick := mmAnsTick;
      if Frmfbl.ISMsgCmd(CM_MOVE) = false then exit;
      //Frmfbl.SocketAddData(sizeof(cmove), @cmove);
      if Frmfbl.SocketAddData(sizeof(cmove), @cmove) then
        CL.ProcessMessage(SM_MOVE, adir, cl.x, cl.y, cl.feature, 0);
    end
    else
    begin
      OldCharPos.X := 0;
      oldcharpos.Y := 0;
    end;
  end;
end;

procedure TFrmM.AutoMove_begin(cx, cy: word);
begin
  AutoHit_SendCMD := false;
  //MapAutoPath2 := true; //屏蔽 自动 移动攻击
  MapAutoPathy2 := cy;
  MapAutoPathx2 := cx;
  FrmConsole.cprint(lt_gametools, format('---移动开始，目标%d,%d', [MapAutoPathx2, MapAutoPathy2]));
end;

procedure TFrmM.AutoMove_stop;
begin
  FrmConsole.cprint(lt_gametools, format('---移动停止，目标%d,%d', [MapAutoPathx2, MapAutoPathy2]));
  MapAutoPath2 := false;
  AutoHit_SendCMD := false;
end;

function TFrmM.AutoHit_begin(aid: integer): boolean;
var
  target: TCharClass;
  cl: TCharClass;
begin
  result := false;
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  if cl.Feature.rfeaturestate = wfs_die then exit;
  target := CharList.CharGet(aid);
  if target = nil then exit;
  if target.Feature.rrace <> RACE_MONSTER then exit;
  if target.Feature.rfeaturestate = wfs_die then exit;
  AutoHit_ID := aid;
  result := true;
  AutoHit_SendCMD := false;
  FrmConsole.cprint(lt_gametools, format('---攻击开始，目标%s,ID%d', [target.rName, aid]));
end;

procedure TFrmM.AutoHit_stop();
begin
  FrmConsole.cprint(lt_gametools, format('---攻击停止，ID%d', [AutoHit_ID]));
  AutoHit_ID := 0;
  MapAutoPath2 := false;
  AutoHit_SendCMD := false;
end;

procedure TFrmM.AutoHit_update(curtick: integer);
var
  target: TCharClass;
  cl: TCharClass;
  aMagicType: integer;
  aitem: PTMagicData;
  procedure _SendHit(aid: integer);
  var
    cHit: TCHit;
    adir: integer;
  begin
    if curtick < HitTick + 100 then
    begin
            //FrmBottom.AddChat('---攻击，等待时间-------', WinRGB(255, 255, 0), 0);
      exit; //攻击 间隔
    end;
    HitTick := curtick;
    adir := GetViewDirection(cl.x, cl.y, target.x, target.y);
    cHit.rmsg := CM_HIT;
    cHit.rkey := adir;
    cHit.rtid := aid;
    if Frmfbl.ISMsgCmd(CM_HIT) = false then exit;
    Frmfbl.SocketAddData(sizeof(cHit), @cHit);
    AutoHit_SendCMD := true;
        //FrmBottom.AddChat('---攻击指令-------', WinRGB(255, 255, 0), 0);
  end;

begin
  if FRightMove then Exit;
  if AutoHit_ID = 0 then exit;
  if AutoHit_updatetick + 20 > mmAnsTick then exit;
  AutoHit_updatetick := mmAnsTick;

  target := CharList.CharGet(AutoHit_ID);
  if target = nil then
  begin
    AutoHit_stop;
    exit;
  end;
  if target.Feature.rfeaturestate = wfs_die then
  begin
    AutoHit_stop;
    exit;
  end;
  if target.Feature.rHideState <> hs_100 then
  begin
    AutoHit_stop;
    exit;
  end;

//  if MapAutoPath2 then
//  begin
//    MapAutoPathy2 := target.y;
//    MapAutoPathx2 := target.x;
//    exit;
//  end;

  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  if cl.Feature.rfeaturestate = wfs_die then exit;

  aitem := HaveMagicClass.DefaultMagic.getname(Frmbottom.UseMagic1.Caption);
  if aitem = nil then
    aitem := HaveMagicClass.HaveMagic.getname(Frmbottom.UseMagic1.Caption);
  if aitem = nil then
    aitem := HaveMagicClass.HaveRiseMagic.getname(Frmbottom.UseMagic1.Caption);
  if aitem = nil then
    aitem := HaveMagicClass.HaveMysteryMagic.getname(Frmbottom.UseMagic1.Caption);

  if aitem = nil then exit;
  //远程武功处理
  case aitem.rMagicType of
        // MAGICTYPE_WRESTLING = 0;       // 拳
        //  MAGICTYPE_FENCING = 1;         //剑
        // MAGICTYPE_SWORDSHIP = 2;       //刀
        // MAGICTYPE_HAMMERING = 3;       //槌
        // MAGICTYPE_SPEARING = 4;        //枪
    MAGICTYPE_BOWING, //弓
      MAGICTYPE_THROWING
      , MAGICTYPE_2BOWING, //弓
      MAGICTYPE_2THROWING
      , MAGICTYPE_3BOWING, //弓
      MAGICTYPE_3THROWING
      , MAGIC_Mystery_TYPE: ; //投
        //  MAGICTYPE_RUNNING = 7;         //步法
        //  MAGICTYPE_BREATHNG = 8;        //心法
        // MAGICTYPE_PROTECTING = 9;      //护体
  else
    begin
      if not FrmGameToolsNew.A2CheckBox_MonsterHit.Checked then
      begin
        if GetLargeLength(cl.x, cl.y, target.x, target.y) > 1 then
        begin
          AutoMove_begin(target.x, target.y);
          exit;
        end;
      end;

    end;
  end;
  //自动切换武功处理
  if AutoHit_SendCMD = false then _SendHit(AutoHit_ID);
end;
//procedure TFrmM.AutoHit_update(curtick: integer);
//var
//  target: TCharClass;
//  cl: TCharClass;
//  aMagicType: integer;
//  aitem: PTMagicData;
//  procedure _SendHit(aid: integer);
//  var
//    cHit: TCHit;
//    adir: integer;
//  begin
//    if curtick < HitTick + 100 then
//    begin
//            //FrmBottom.AddChat('---攻击，等待时间-------', WinRGB(255, 255, 0), 0);
//      exit; //攻击 间隔
//    end;
//    HitTick := curtick;
//    adir := GetViewDirection(cl.x, cl.y, target.x, target.y);
//    cHit.rmsg := CM_HIT;
//    cHit.rkey := adir;
//    cHit.rtid := aid;
//    if Frmfbl.ISMsgCmd(CM_HIT) = false then exit;
//    Frmfbl.SocketAddData(sizeof(cHit), @cHit);
//    AutoHit_SendCMD := true;
//       // FrmBottom.AddChat('---攻击指令-------', WinRGB(255, 255, 0), 0);
//  end;
//
//begin
//  if FRightMove then Exit;
//  if AutoHit_ID = 0 then exit;
//  if AutoHit_updatetick + 20 > mmAnsTick then exit;
//  AutoHit_updatetick := mmAnsTick;
//
//  target := CharList.CharGet(AutoHit_ID);
//  if target = nil then
//  begin
//    AutoHit_stop;
//    exit;
//  end;
//  if target.Feature.rfeaturestate = wfs_die then
//  begin
//    AutoHit_stop;
//    exit;
//  end;
//  if target.Feature.rHideState <> hs_100 then
//  begin
//    AutoHit_stop;
//    exit;
//  end;
//
////  if MapAutoPath2 then
////  begin
////    MapAutoPathy2 := target.y;
////    MapAutoPathx2 := target.x;
////    exit;
////  end;
//
//  Cl := CharList.CharGet(CharCenterId);
//  if Cl = nil then exit;
//  if cl.Feature.rfeaturestate = wfs_die then exit;
//
//  aitem := HaveMagicClass.DefaultMagic.getname(Frmbottom.UseMagic1.Caption);
//  if aitem = nil then
//    aitem := HaveMagicClass.HaveMagic.getname(Frmbottom.UseMagic1.Caption);
//  if aitem = nil then
//    aitem := HaveMagicClass.HaveRiseMagic.getname(Frmbottom.UseMagic1.Caption);
//  if aitem = nil then
//    aitem := HaveMagicClass.HaveMysteryMagic.getname(Frmbottom.UseMagic1.Caption);
//
//  if aitem = nil then exit;
//  case aitem.rMagicType of
//        // MAGICTYPE_WRESTLING = 0;       // 拳
//        //  MAGICTYPE_FENCING = 1;         //剑
//        // MAGICTYPE_SWORDSHIP = 2;       //刀
//        // MAGICTYPE_HAMMERING = 3;       //槌
//        // MAGICTYPE_SPEARING = 4;        //枪
//    MAGICTYPE_BOWING, //弓
//      MAGICTYPE_THROWING
//      , MAGICTYPE_2BOWING, //弓
//      MAGICTYPE_2THROWING
//      , MAGICTYPE_3BOWING, //弓
//      MAGICTYPE_3THROWING
//      , MAGIC_Mystery_TYPE: ; //投
//        //  MAGICTYPE_RUNNING = 7;         //步法
//        //  MAGICTYPE_BREATHNG = 8;        //心法
//        // MAGICTYPE_PROTECTING = 9;      //护体
//  else
// // AutoHit_stop;
////    begin
////      if GetLargeLength(cl.x, cl.y, target.x, target.y) > 1 then
////      begin
////        AutoMove_begin(target.x, target.y);
////        exit;
////      end;
////    end;
//  end;
//  if AutoHit_SendCMD = false then _SendHit(AutoHit_ID);
//end;

procedure TFrmM.MoveProcess;
var
  dir, xx, yy: word;
  ckey: TCKey;
  cmove: TCMove;
  Cl: TCharClass;
  procedure _automoveopenmagic();
  var
    magicKey, aMoveMagicKey, aMoveMagicWindow: integer;
    tmpGrobalClick: TCClick;
    str: string;
  begin
    if FrmGameToolsNew.A2CheckBox_MoveOpenMagic.Checked = false then exit;
    if Cl = nil then exit;
    if (cl.Feature.rfeaturestate <> wfs_running)
      and (cl.Feature.rfeaturestate <> wfs_running2) then
    begin
      if MoveAutoOpenMagictime + 20 > mmAnsTick then exit;
      str := FrmGameToolsNew.A2ComboBox_ChangeMoveMagic.Text;
      if (str = '无名步法') or (str = '') then
      begin
        aMoveMagicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_RUNNING);
        aMoveMagicWindow := WINDOW_BASICFIGHT;
      end
      else
      begin
        aMoveMagicKey := FrmNewMagic.GetMagicTag(str);
        if aMoveMagicKey = -1 then exit;
        aMoveMagicWindow := WINDOW_MAGICS;
      end;

      MoveAutoOpenMagictime := mmAnsTick;
      magicKey := aMoveMagicKey;
      MagicWindow := aMoveMagicWindow;
            //magicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_RUNNING);
      if magicKey = -1 then exit;

      tmpGrobalClick.rmsg := CM_DBLCLICK;
      tmpGrobalClick.rwindow := MagicWindow;
      tmpGrobalClick.rclickedId := 0;
      tmpGrobalClick.rShift := [];
      tmpGrobalClick.rkey := magicKey;
      Frmfbl.SocketAddData(sizeof(tmpGrobalClick), @tmpGrobalClick);
    end;
  end;
begin
  FRightMove := False;

  //自动 移动 攻击
//  if MapAutoPath2 then
//  begin
//    FrmMiniMap.StopAutoMOVE;
//    Cl := CharList.CharGet(CharCenterId);
//    if Cl = nil then exit;
//    if Cl.AllowAddAction = FALSE then exit;
//    if GetLargeLength(cl.x, cl.y, MapAutoPathx2, MapAutoPathy2) <= 1 then
//    begin
//      AutoMove_stop;
//      exit;
//    end;
//    _automoveopenmagic;
//    AutoPathAI(MapAutoPathx2, MapAutoPathy2);
//    exit;
//  end;

    //自动 移动
  if MapAutoPath then
  begin
    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;
    if Cl.AllowAddAction = FALSE then exit;
        //if AutoMove = false then
    _automoveopenmagic;
    if (cl.x = MapAutoPathx) and (cl.y = MapAutoPathy) then
    begin
      FrmBottom.AddChat(format('相同坐标[目标%D,%D]', [MapAutoPathx, MapAutoPathy]), ColorSysToDxColor(clred), 0);
            //直接 提下个坐标
      MapAutoPath := false;
      if FrmMiniMap.TimerAutoPathMove.Enabled then
        FrmMiniMap.TimerAutoPathMoveTimer(nil);
      if not MapAutoPath then exit;
    end;
    dir := GetViewDirection(cl.x, cl.y, MapAutoPathx, MapAutoPathy);
    if dir <> DR_DONTMOVE then
    begin
      if dir <> Cl.dir then
      begin
                //转向
        ckey.rmsg := CM_TURN;
        ckey.rkey := dir;
        if Frmfbl.ISMsgCmd(CM_TURN) = false then exit;
        Frmfbl.SocketAddData(sizeof(ckey), @ckey);
        begin
          CL.ProcessMessage(SM_TURN, dir, cl.x, cl.y, cl.feature, 0);
          MapAutoPath := false;
        end;
      end else

      begin
                //移动
        xx := Cl.x;
        yy := Cl.y;
        GetNextPosition(dir, xx, yy);
                //地图 障碍 测试
        if Map.isMovable(xx, yy) = FALSE then
        begin
          FrmBottom.AddChat(format('坐标问题Map[目标%D,%D][移动%D,%D]', [MapAutoPathx, MapAutoPathy, xx, yy]), ColorSysToDxColor(clred), 0);
          MapAutoPath := false;
          exit;
        end;
                //物体 障碍 测试
        if CharList.isMovable(xx, yy) = FALSE then
        begin
          //FrmBottom.AddChat(format('障碍[目标%D,%D][移动%D,%D]', [MapAutoPathx, MapAutoPathy, xx, yy]), ColorSysToDxColor(clred), 0);
                    //需要重新 计算 路线
          cMaper.QuickMode := false;
          FrmMiniMap.AIPathcalc_paoshishasbi(FrmMiniMap.AIPathgx, FrmMiniMap.AIPathgy);
          MapAutoPath := false;
          exit;
        end;

        cmove.rmsg := CM_MOVE;
        cmove.rdir := dir;
        cmove.rx := xx;
        cmove.ry := yy;
        cmove.rmmAnsTick := mmAnsTick;
        if Frmfbl.ISMsgCmd(CM_MOVE) = false then exit;
        if Frmfbl.SocketAddData(sizeof(cmove), @cmove) then
        begin
          CL.ProcessMessage(SM_MOVE, dir, cl.x, cl.y, cl.feature, 0);
          MapAutoPath := false;
        end;
      end;
    end;
    exit;
  end;
    //普通 移动
  if RightButtonDown = FALSE then exit;
  FRightMove := True;
  AutoHit_stop; //自动攻击停止
    //查找 自己
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  if Cl.AllowAddAction = FALSE then exit;
  _automoveopenmagic; //判断自动开启步法

  dir := GetMouseDirection; //获取鼠标移动方向
  if dir <> DR_DONTMOVE then
  begin
    //判断是否转向
    if dir <> Cl.dir then
    begin
            //转向
      ckey.rmsg := CM_TURN;
      ckey.rkey := dir;
      if Frmfbl.ISMsgCmd(CM_TURN) = false then exit;
      if Frmfbl.SocketAddData(sizeof(ckey), @ckey) then
      begin
        CL.ProcessMessage(SM_TURN, dir, cl.x, cl.y, cl.feature, 0);
                // FrmBottom.AddChat('主动改变方向' + inttostr(dir), WinRGB(22, 22, 0), 0);
      end;
    end else
    begin
      //移动
      xx := Cl.x;
      yy := Cl.y;
      GetNextPosition(dir, xx, yy); //计算移动后坐标
            //地图 障碍 测试
      if Map.isMovable(xx, yy) = FALSE then exit;
            //物体 障碍 测试
      if CharList.isMovable(xx, yy) = FALSE then
      begin
        exit;
      end;

      cmove.rmsg := CM_MOVE;
      cmove.rdir := dir;
      cmove.rx := xx;
      cmove.ry := yy;
      cmove.rmmAnsTick := mmAnsTick;
      if Frmfbl.ISMsgCmd(CM_MOVE) = false then exit;
     // FrmBottom.AddChat('发送移动，方向' + inttostr(dir) + '坐标 X:' + inttostr(cmove.rx) + ' Y:' + inttostr(cmove.ry), WinRGB(22, 22, 0), 0);
     // Frmfbl.SocketAddData(sizeof(cmove), @cmove);
      if Frmfbl.SocketAddData(sizeof(cmove), @cmove) then
      begin
        //发送移动动画
        CL.ProcessMessage(SM_MOVE, dir, cl.x, cl.y, cl.feature, 0);
      //  FrmBottom.AddChat('主动移动，方向' + inttostr(dir) + '坐标 X:' + inttostr(cl.x) + ' Y:' + inttostr(cl.y), WinRGB(22, 22, 0), 0);
      end;
            //    if Cl <> nil then Cl.ProcessMessage(SM_MOVE, rdir, rx, ry, Cl.feature, 0);
    end;
  end;
end;

procedure TFrmM.CheckAndSendClick;
begin
  if mmAnsTick < ClickTick + 10 then exit;
  if GrobalClick.rwindow = 0 then exit;
  Frmfbl.SocketAddData(sizeof(GrobalClick), @GrobalClick);
  FillChar(GrobalClick, sizeof(GrobalClick), 0);
end;

procedure TFrmM.MessageProcess(var code: TWordComData);
var
  TagetX, TagetY, len, akey: Word;
  i, n, deg, xx, yy, id, aid: integer;
  pan, volume, volume2: integer;
  str, rdstr: string;
  cstr: string[1];
  DynamicGuard: TDynamicGuard;

  ItemClass: TItemClass;
  Cl, TL: TCharClass;
  Dt: TDynamicObject;
  pckey: PTCKey;
  psSay: PTSSay;
  psNewMap: PTSNewMap;
  psShow: PTSShow;
  pSShow_Npc_MONSTER: pTSShow_Npc_MONSTER;
  AFeature: TFeature;
  psShowItem: PTSShowItem;
  psHide: PTSHide;
  pssVirtualObject: pTssVirtualObject;
  psTurn: PTSTurn;
  psMove: PTSMove;
  pSMagicEffect: pTSMagicEffect;
  pSEffect: pTSEffect;
  pSCHANGEMagic: pTSCHANGEMagic;
  pSdie_Npc_MONSTER: pTSdie_Npc_MONSTER;
  pSNameColor: pTSNameColor;
  psSetPosition: PTSSetPosition;
  psChatMessage: PTSChatMessage;
  psChangeFeature: PTSChangeFeature;
  PSChangeFeature_Npc_MONSTER: PTSChangeFeature_Npc_MONSTER;
  psChangeProperty: PTSChangeProperty;
  psMotion: PTSMotion;
  psMotion2: PTSMotion2;
  psMotion3: PTSMotion3;
  psStructed: PTSStructed;
  psHaveMagic: PTSHaveMagic;
  psHaveItem: PTSHaveItem;
    //   psWearItem : PTSWearItem;
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
  PSSShowSpecialWindow: PTSShowSpecialWindow;
  PSTSHideSpecialWindow: PTSHideSpecialWindow;
  PSTSNetState: PTSNetState;
  cCNetState: TCNetState;
  PTTSShowCenterMsg: PTSShowCenterMsg;
  frmConfirmDialog: TfrmConfirmDialog;
var
  key: Word;
  cSay: TCSay;
begin
  key := VK_RETURN;

  pckey := @Code.data;
  case pckey^.rmsg of
    //SM_Job: frmSkill.MessageProcess(code);
    //SM_Booth: FrmBooth.MessageProcess(code);
    SM_TM:
      begin
{$IFDEF gm}
//                if frmTM <> nil then frmTM.MessageProcess(code);
{$ENDIF}
      end;
    SM_ItemInputWindows:
      begin
        frmNPCTrade.MessageProcess(Code);
                // FrmItemInput.MessageProcess(code);
      end;
    SM_money: frmEmporia.MessageProcess(code);
    //消息框
  //  SM_MsgBoxTemp: frmMsgBoxTemp.MessageProcess(code);
    //
    SM_Emporia: frmEmporia.MessageProcess(code);
    //输入框
    SM_ConfirmDialog:
      begin
        id := 1;
        aid := WordComData_GETdword(code, id);
        akey := WordComData_GETbyte(code, id);
        str := WordComData_GETstring(code, id);
            //创建 输入 窗口
        frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
        frmConfirmDialog.aid := aid;
        frmConfirmDialog.Fkey := akey;
        frmConfirmDialog.ShowFrom(cdtNpcShow, str, '');
        exit;
   // frmConfirmDialog.MessageProcess(code);
      end;

    SM_Complex: frmComplexProperties.MessageProcess(code); //合成界面
    SM_ItemUpgrade: frmItemUpgrade.MessageProcess(code); //强化界面
        //2009.07.03修改
    SM_PowerLevel:
            //FrmEnergy.MessageProcess(code);
      energyGraphicsclass.MessageProcess(code);
    SM_UPDATAITEM:
      begin
        FrmUPdateItemLevel.MessageProcess(code);
      end;
    SM_Billboardcharts, SM_BillboardGuilds: frmBillboardcharts.MessageProcess(code);
   // SM_Procession: frmProcession.MessageProcess(code);
    SM_Quest: frmQuest.MessageProcess(code);
    SM_NewQuest: frmnewquest.MessageProcess(code);
    SM_ITEMDATA: frmnewquest.MessageProcess(code);
    //SM_Auction: frmAuction.MessageProcess(Code);
    //SM_EMAIL: FrmEmail.MessageProcess(Code);

    SM_GUILD:
      begin
        frmGuild.MessageProcess(Code);
      end;

    SM_GameExit:
      begin
        bodirectclose := true;
        Close;
      end;

    SM_CloseClient:
      begin
        if FrmGameToolsNew.A2CheckBox_CL.Checked then
          FrmGameToolsNew.A2CheckBox_CL.Checked := False;
        cSay.rmsg := CM_SAY;
        str := '@CloseClient';
        SetWordString(cSay.rWordString, str);
        id := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
        Frmfbl.SocketAddData(id, @csay);

//        Frmfbl.sckConnect.Active := false;
//        Application.MessageBox(Pchar('与服务器连接中断'), Pchar(fname), 0);
//        ExitProcess(0); //20130607修改
        exit;
      end;

    SM_AutoAttack:
      begin
        id := 1;
        aid := WordComData_GETbyte(code, id);
        if aid = 1 then
        begin
          ReConnectAttack := False;
          FrmBottom.AddChat('原地反击怪物已开启!', WinRGB(22, 22, 0), 0);
        end
        else
          FrmBottom.AddChat('原地反击怪物已关闭!', WinRGB(22, 22, 0), 0);
      end;

    SM_AutoAttackUser:
      begin
        id := 1;
        aid := WordComData_GETbyte(code, id);
        if aid = 1 then
        begin
          ReConnectAttackUser := False;
          FrmBottom.AddChat('原地反击玩家已开启!', WinRGB(22, 22, 0), 0);
        end
        else
          FrmBottom.AddChat('原地反击玩家已关闭!', WinRGB(22, 22, 0), 0);
      end;

    SM_ITEMPRO:
      begin
        frmItemHelp.MessageProcess(Code);
      end;

    SM_NETSTATE:
      begin
        PSTSNetState := @Code.data;
        with cCNetState do
        begin
          rMsg := CM_NETSTATE;
          rID := PSTSNetState^.rID + 1;
          rMadeTick := PSTSNetState^.rMadeTick;
          rCurTick := mmAnsTick;
        end;
        Frmfbl.SocketAddData(sizeof(cCNetState), @cCNetState);

      end;
    SM_HIDESPECIALWINDOW:
      begin
        PSTSHideSpecialWindow := @Code.data;
        case PSTSHideSpecialWindow^.rWindow of
          WINDOW_GROUPWINDOW: FrmbatList.Visible := FALSE;
          WINDOW_ROOMWINDOW: FrmbatList.Visible := FALSE;
          WINDOW_GRADEWINDOW: FrmbatList.Visible := FALSE;
          WINDOW_ITEMLOG: FrmDepository.Visible := FALSE;
          WINDOW_ALERT: FrmDepository.Visible := FALSE;
          WINDOW_AGREE: FrmcMessageBox.Visible := FALSE;
          WINDOW_GUILDMAGIC: FrmMuMagicOffer.Visible := FALSE;
        end;
      end;
    SM_SHOWBATTLEBAR:
      begin
        PersonBat.MessageProcess(Code);
      end;
    SM_SHOWCENTERMSG:
      begin
        PTTSShowCenterMsg := @Code.data;
        if (PTTSShowCenterMsg.rtype <> SHOWCENTERMSG_RollMSG) and (PTTSShowCenterMsg.rtype <> SHOWCENTERMSG_MagicMSG) then
        begin
          str := GetwordString(PTTSShowCenterMsg.rText);
          AddChat(str, PTTSShowCenterMsg.rColor, 0);
        end;
        PersonBat.MessageProcess(Code);
      end;
    SM_CHECK:
      begin
        CheckSome(Code);
      end;
    SM_LOGITEM:
      begin
        FrmDepository.MessageProcess(Code);
      end;
    SM_NPCITEM:
      begin
        frmNPCTrade.MessageProcess(Code);
      end;
    SM_SHOWSPECIALWINDOW:
      begin
        FrmPassEtc.MessageProcess(Code);
        frmPassEtcEdit.MessageProcess(Code);
        frmNPCTrade.MessageProcess(Code);
        FrmDepository.MessageProcess(Code);
        FrmbatList.MessageProcess(Code);
        FrmcMessageBox.MessageProcess(Code);
        FrmMuMagicOffer.MessageProcess(Code);
        FrmUPdateItemLevel.MessageProcess(code);
        frmEmporia.MessageProcess(code); //商城窗口操作
        frmComplexProperties.MessageProcess(code); //合成窗口操作
        frmItemUpgrade.MessageProcess(code); //强化窗口操作
                {
                FrmMunpaCreate.MessageProcess(Code);
                FrmMunpaimpo.MessageProcess(Code);
                FrmcMessageBox.MessageProcess(Code);
                FrmMunpaWarOffer.MessageProcess(Code);
                }
      end;
    SM_CHARMOVEFRONTDIEFLAG:
      begin // 烙矫荤侩 纳腐磐啊 磷篮荤恩困肺 瘤唱哎荐 乐绰 版快甫 TRUE肺 汲沥
        CharMoveFrontdieFlag := TRUE;
      end;
    SM_SHOWEXCHANGE: // 背券芒
      begin
        FrmExChange.MessageProcess(Code);
      end;
    SM_HIDEEXCHANGE:
      begin
        FrmExchange.Visible := FALSE;
        if FrmQuantity.Visible then FrmQuantity.Visible := FALSE;
      end;
    SM_SHOWCOUNT: // 荐樊芒
      begin
        FrmQuantity.MessageProcess(Code);
      end;

        // CM_SELECTCOUNT;
    SM_SHOWINPUTSTRING2: frmPopMsg.MessageProcess(code);

    SM_InputOk: frmPopMsg.MessageProcess(code);

    SM_SHOWINPUTSTRING: // 沤祸芒
      begin
        psShowInputString := @Code.Data;
        FrmSearch.QuantityID := psShowInputString.rInputStringid;
        FrmSearch.QuantityData := GetWordString(psShowInputString.rWordString);
        FrmSearch.SearchItem;
        FrmSearch.Visible := TRUE;
      end;
    SM_RAINNING: // 厚
      begin
        psRainning := @Code.Data;
        with psRainning^ do
        begin
          BackScreen.SetRainState(TRUE, rspeed, rCount, rOverray, rTick, rRainType);
        end;
      end;
    SM_ReliveTime, SM_SelChar:
      begin
        PersonBat.MessageProcess(code);
                //pckey := @Code.data;
                //  LeftTextScroll.DiedTick := mmAnsTick; //GetItemLineTimeSec

                //  LeftTextScroll.ReliveTime := pckey.rkey;
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
    SM_SOUNDEFFECT: //声音 应该 和动作捆绑
      begin
                // if not boUseSound then exit;
        psSoundString := @Code.Data;
        str := InttoStr(psSoundString.rsound) + '.wav'; //(psSoundString^.rSoundName);
        TagetX := psSoundString.rX;
        TagetY := psSoundString.rY;

                //            if volume < -2000 then Volume := -2000;
                //            volume2 := FrmM.SoundManager.RangeVolume(CharPosX, CharPosY,TagetX,TagetY,volume);
                //            LogObj.WriteLog (5, 'SM_SoundE.. :'+ str);
        pan := FrmM.SoundManager.RangeCompute(CharPosX, TagetX);
        FrmM.SoundManager.NewPlayEffect(str, pan);
                //    FrmBottom.AddChat(format('SM_SOUNDEFFECT声音(%s)坐标[%d,%d]', [str, TagetX, Tagety]), ColorSysToDxColor(clred), 0);
      end;

    SM_SOUNDBASESTRING: // 硅版澜厩.... 1盒沥档焊促 变巴甸
      begin
                //                if not boUseSound then exit;
        psSoundBaseString := @Code.Data;
        str := GetWordString(psSoundBaseString^.rWordString);

                //                FrmM.SoundManager.PlayBaseAudio(str, psSoundBaseString^.rRoopCount);
        FrmM.SoundManager.PlayBaseAudioMp3(str, psSoundBaseString^.rRoopCount);
      end;

    SM_MOVINGMAGIC:
      begin
        psMovingMagic := @Code.Data;
        with psMovingMagic^ do
        begin
          Cl := CharList.CharGet(rsid);
          TL := CharList.CharGet(reid);
          if Cl = nil then exit;
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
          CharList.AddMagic(Cl.Id, reid, deg, rspeed, Cl.x, Cl.y, xx, yy, rmf, ref, mmAnstick, rType)
        end;
      end;
    SM_EVENTSTRING:
      begin
        psEventString := @Code.data;
        EventstringSet(GetwordString(psEventString^.rWordstring), psEventString.rKEY);

      end;
    SM_boMOVE:
      begin
        i := 1;
        n := WordComData_GETbyte(code, i);
        Cl := CharList.CharGet(CharCenterId);
        if Cl <> nil then
        begin
          Cl.FboMOVE := boolean(n);
        end;
      end;
    SM_LockMoveTime:
      begin
        i := 1;
        n := WordComData_GETdword(code, i);
        CharCenterLockMoveTick := mmAnsTick + n;

                //Cl := CharList.CharGet(CharCenterId);
               // if Cl <> nil then
                //begin


                    // FrmBottom.AddChat(format('%s被锁定%d的时间不能移动', [cl.rName, n]), WinRGB(22, 22, 0), 0);
               // end;

      end;
    SM_MOTION:
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psMotion := @Code.Data;
        Cl := CharList.CharGet(psMotion^.rid);
        if Cl <> nil then
        begin
          Cl.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, Cl.feature, psMotion^.rmotion);

                    // if CharCenterId = cl.id then
                   //  FrmBottom.AddChat(format('%D动作样式', [psMotion^.rmotion]), WinRGB(22, 22, 0), 0);
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_MOTION2:
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psMotion2 := @Code.Data;
        Cl := CharList.CharGet(psMotion2^.rid);
        if Cl <> nil then
        begin
          Cl.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, Cl.feature, psMotion2^.rmotion);
          Cl.rspecialMagicType := psMotion2.rEffectimg;
          cl.rspecialEffectColor := psMotion2.rEffectColor;
          cl.rspecialShowState := true;

                    // if CharCenterId = cl.id then
                   //  FrmBottom.AddChat(format('%D动作样式', [psMotion^.rmotion]), WinRGB(22, 22, 0), 0);
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_MOTION3:
      begin
        psMotion3 := @Code.Data;
        Cl := CharList.CharGet(psMotion3^.rid);
        if Cl <> nil then
        begin
          Cl.Feature.rEffect_WEAPON_color := psMotion3.rRenderer_color;
          Cl.Feature.rEffect_WEAPON_gcolor := psMotion3.rRenderer_gcolor;
          Cl.Feature.rEffect_WEAPON_light := psMotion3.rRenderer_light;
          Cl.Feature.rEffect_WEAPON_glight := psMotion3.rRenderer_glight;
          Cl.Feature.rEffect_WEAPON_flickspeed := psMotion3.rFlick_speed;
          Cl.Feature.rEffect_WEAPON_showghost := psMotion3.rGhost_visible;
        end;
      end;
    SM_STRUCTED:
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psStructed := @Code.Data;
        case psStructed^.rRace of
          RACE_HUMAN:
            begin

//              Cl := CharList.CharGet(psStructed^.rid);
//              if Cl <> nil then
//              begin
//
//                            //      if CharCenterId = cl.id then
//                            //          FrmBottom.AddChat('血条', WinRGB(22, 22, 0), 0);
//                Cl.ProcessMessage(SM_STRUCTED, cl.dir, cl.x, cl.y, Cl.feature, psStructed^.rpercent);
//                            //                                PersonBat.SelChar.UPStructedPercent(CL.id, CL.Structed);
//              end;
              try
                Cl := CharList.CharGet(psStructed^.rid);
                if Cl = nil then Exit;
                Cl.ProcessMessage(SM_STRUCTED, cl.dir, cl.x, cl.y, Cl.feature, psStructed^.rpercent);
                if cl.id = frmMonsterBuffPanel.FSelectCharId then
                begin
                  if frmMonsterBuffPanel.Visible then
                  begin
                    if (frmMonsterBuffPanel.FSelectCharName = cl.rName) and (psStructed^.rpercent = 0) then
                    begin
                      frmMonsterBuffPanel.CloseTimer;
                      frmMonsterBuffPanel.Visible := False;
                    end
                    else if frmMonsterBuffPanel.FSelectCharName = cl.rName then
                      frmMonsterBuffPanel.DrawStructed(1, psStructed^.rpercent, 0);
                  end;
                end;
              except
              end;
            end;
          RACE_DYNAMICOBJECT:
            begin
              Dt := CharList.GetDynamicObjItem(psStructed^.rid);
              if Dt <> nil then Dt.ProcessMessage(SM_STRUCTED, psStructed^.rpercent);
            end;
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_CHATMESSAGE:
      begin
        psChatMessage := @Code.data;

        str := GetwordString(psChatMessage^.rWordstring);
        cstr := str;
        if (cstr = '[') or (cstr = '<') then
        begin
          if pos(':', str) > 1 then
          begin
            str := GetValidStr3(str, rdstr, ':');
            str := ChangeDontSay(str);
            rdstr := rdstr + ':' + str
          end else rdstr := str;
        end else
        begin
          str := ChangeDontSay(str);
          rdstr := str;
        end;
        AddChat(rdstr, psChatMessage^.rFColor, psChatMessage^.rBColor);
        str := '';
        rdstr := '';
      end;
    SM_SAY:
      begin
        if chat_normal then
        begin
          psSay := @Code.data;
          str := GetwordString(pssay^.rWordstring);
          str := GetValidStr3(str, rdstr, ':');
          str := ChangeDontSay(str);
          rdstr := rdstr + ' :' + str;
          AddChat(rdstr, WinRGB(28, 28, 28), 0);
          Cl := CharList.CharGet(psSay^.rid);
          if Cl <> nil then Cl.Say(rdstr);
          str := '';
          rdstr := '';
        end;
      end;
    SM_SAYUSEMAGIC:
      begin
        psSay := @Code.data;
        Cl := CharList.CharGet(psSay^.rid);
        if Cl <> nil then
        begin
          if Cl <> nil then Cl.Say(GetwordString(pssay^.rWordstring));
//          str := GetwordString(pssay^.rWordstring);
//           //检测是否屏蔽伤害显示
//          if not FrmSound.A2CheckBox_ShowDamage.Checked then
//          begin
//            if (str = 'Miss') or (str = '') or (str[1] = '-') then Exit;   //2015.11.12 在水一方
//          end;
//          Cl.Say(str);
        end;

      end;
    SM_MapObject: FrmMiniMap.MessageProcess(code);
    SM_HailFellow: HailFellowlist.MessageProcess(code);
    SM_NEWMAP:
      begin
        FrmMiniMap.StopAutoMOVE;
        CharList.Clear;
        psNewMap := @Code.data;
        CharCenterId := psNewMap^.rId;
        CharCenterName := (psNewMap^.rCharName);
        Application.Title := format('%s:%s', [CharCenterName, fservername]);
        FrmGameToolsNew.loadFromfile(CharCenterName); //加载辅助工具
        //辅助工具初始化
        FHaveHotKey := False;
        FrmSound.InitTgsConfig;

        if FrmGameToolsNew.A2CheckBox_BossKey.Checked then
        begin
          RegHotKey;
        end;
        if FrmGameToolsNew.A2CheckBox_CounterAttack.Checked then
          FrmBottom.sendsay('@反击开启', key);
        //else FrmBottom.sendsay('@反击关闭', key);


        if FrmGameToolsNew.A2CheckBox_CounterAttackUser.Checked then
          FrmBottom.sendsay('@反击玩家开启', key);
        //else FrmBottom.sendsay('@反击用户关闭', key);
               { FrmGameToolsNew.A2CheckBox_ShowAllName.Checked:=True;
                FrmGameToolsNew.A2CheckBox_ShowMonster.Checked:=True;
                FrmGameToolsNew.A2CheckBox_ShowNpc.Checked:=True;
                FrmGameToolsNew.A2CheckBox_ShowPlayer.Checked:=True;
                FrmGameToolsNew.A2CheckBox_ShowItem.Checked:=True; }
                //  ObjectDataList.LoadFromFile((psNewMap^.rObjName));
        ObjectDataList.LoadFrom((psNewMap^.rObjName));
        TileDataList.LoadFrom((psNewMap^.rTilName));
        RoofDataList.LoadFrom((psNewMap^.rRofName));
        Map.LoadFrom((psNewMap^.rmapname), psNewMap^.rx, psNewMap^.ry);
        cMaper.cLoadMapFrom((psNewMap^.rmapname));
        cSearchPathClass.SetMaper(cMaper);
        nSearchPathClass.SetMaper(cMaper);
                {
                            ObjectDataList.LoadFromFile ('foxobj.Obj');
                            TileDataList.LoadFromFile ('foxtil.til');
                            RoofDataList.LoadFromFile ('');
                            Map.LoadFromFile ('fox.map', psNewMap^.rx, psNewMap^.ry);
                }
                //            MapName := StrPas (@psNewMap^.rmapname);
        Map.SetCenter(psNewMap^.rx, psNewMap^.ry); //设置 自己 位置
        BackScreen.SetCenter(psNewMap^.rx * UNITX, psNewMap^.ry * UNITY);
        BackScreen.Back.Clear(0);

        FrmBottom.Visible := TRUE;
        FrmBottom.EdChat.SetFocus;

        Frmbottom.visible := true;
                // FrmBottom.BtnItemClick(nil);
        FrmAttrib.Visible := false;
        frmBuffPanel.Visible := True;
        FrmMiniMap.MessageProcess(code);
                //  FrmBottom.AddChat(format('新地图%s', [psNewMap.rMapName]), WinRGB(22, 22, 0), 0);
        //FrmProcession.FCharList.Clear;
      end;
    SM_SHOWDYNAMICOBJECT: // DynamicItem 010102 ankudo 空釜酒捞袍 Add
      begin
        PSShowDynamicObject := @Code.Data;
        with PSShowDynamicObject^ do
        begin
          Fillchar(DynamicGuard, sizeof(DynamicGuard), 0);
          DynamicGuard.aCount := 0;
          for i := 0 to 10 - 1 do
          begin
            if (rGuardX[i] = 0) and (rGuardY[i] = 0) then break;
            DynamicGuard.aGuardX[i] := rGuardX[i];
            DynamicGuard.aGuardY[i] := rGuardY[i];
            inc(DynamicGuard.aCount);
          end;
          CharList.AddDynamicObjItem((rNameString), rid, rx, ry, rshape, rFrameStart, rFrameEnd, rstate, DynamicGuard);
        end;
      end;
    SM_CHANGESTATE: // DynamicItem 010106 ankudo 空釜酒捞袍狼 惑怕函版
      begin
        PSChangeState := @Code.Data;

        with PSChangeState^ do
        begin
          CharList.SetDynamicObjItem(rid, rState, rFrameStart, rFrameEnd);
        end;
      end;
    SM_HIDEDYNAMICOBJECT: // DynamicItem 010106 ankudo 空釜酒捞袍 昏力
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
          CharList.AddItem((rNameString), rRace, rid, rx, ry, rshape, rcolor);
          if FrmGameToolsNew.A2ListBox_DropItemlist.Count > 500 then
          begin
            FrmGameToolsNew.A2ListBox_DropItemlist.Clear;
          end;
          FrmGameToolsNew.A2ListBox_DropItemlist.AddItem(rNameString);
          fwItemList.add2((rNameString), rRace, rid, rx, ry, rshape, rcolor);
        end;
      end;
    SM_HIDEITEM:
      begin
        psHide := @Code.Data;
        with pshide^ do
        begin
          CharList.DelItem(rid);
          fwItemList.del(rid);
        end;
      end;
    SM_ShowVirtualObject:
      begin
        pssVirtualObject := @Code.Data;
                //aName: string; aRace: byte; aId, ax, ay, aw, ah
        CharList.VirtualObjectList.add(pssVirtualObject^.rNameString,
          pssVirtualObject^.rRace, pssVirtualObject^.rId,
          pssVirtualObject^.rx, pssVirtualObject^.ry,
          pssVirtualObject^.Width, pssVirtualObject^.Height
          );
      end;
    SM_HIDEVirtualObject:
      begin
        psHide := @Code.Data;
        CharList.VirtualObjectList.del(psHide^.rId);
      end;
    SM_SHOW_Npc_MONSTER:
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        pSShow_Npc_MONSTER := @Code.Data;
        with pSShow_Npc_MONSTER^ do
        begin

          FILLCHAR(AFeature, SIZEOF(AFeature), 0);

          AFeature.rrace := rFeature_npc_MONSTER.rrace;
          AFeature.rMonType := rFeature_npc_MONSTER.rMonType;
          AFeature.rTeamColor := rFeature_npc_MONSTER.rTeamColor;
          AFeature.rImageNumber := rFeature_npc_MONSTER.rImageNumber;
          AFeature.raninumber := rFeature_npc_MONSTER.raninumber;
          AFeature.rHideState := rFeature_npc_MONSTER.rHideState;
          AFeature.AttackSpeed := rFeature_npc_MONSTER.AttackSpeed;
          AFeature.WalkSpeed := rFeature_npc_MONSTER.WalkSpeed;
          AFeature.rfeaturestate := rFeature_npc_MONSTER.rfeaturestate;
          AFeature.rEncKey := rFeature_npc_MONSTER.rEncKey;
          str := GetWordString(rWordString);
          CharList.CharAdd(str, rid, rdir, rx, ry, AFeature);

        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_SHOW: //显示
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psShow := @Code.Data;
        with psshow^ do
        begin
                    //                    cMaper.UserMove(rid, rx, ry);
          str := GetWordString(rWordString);
          CharList.CharAdd(str, rid, rdir, rx, ry, rFeature);
//          if rFeature.rrace = RACE_HUMAN then
//            FrmProcession.FCharList.ADD(rid, STR, '');
{$IFDEF showTestLog}
                    //      FrmBottom.AddChat(format('%D显示%s', [rid, str]), WinRGB(22, 22, 0), 0);
{$ENDIF}
                    // FrmBottom.AddChat(format('%D显示%s', [rid, str]), WinRGB(22, 22, 0), 0);
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_HIDE: //消失
      begin
        psHide := @Code.Data;
        with pshide^ do
        begin
{$IFDEF showTestLog}
                    // Cl := CharList.CharGet(rid);
                     //  if Cl <> nil then cMaper.UserMove(0, cl.x, cl.y);
                   //  if cl <> nil then
                     //    FrmBottom.AddChat(format('%s,%D隐藏', [cl.rName, rid]), WinRGB(22, 22, 0), 0)
                    // else FrmBottom.AddChat(format('%s,%D隐藏', ['错误', rid]), WinRGB(22, 22, 0), 0);
{$ENDIF}

                    { Cl := CharList.CharGet(rid);
                     if cl = nil then
                         FrmBottom.AddChat(format('%s,%D隐藏', ['NIL', rid]), WinRGB(22, 22, 0), 0)
                     else
                         FrmBottom.AddChat(format('%s,%D隐藏', [cl.rName, rid]), WinRGB(22, 22, 0), 0);
                         }
          CharList.CharDelete(rid);
         // FrmProcession.FCharList.DEL(rid);
        end;
      end;
    SM_SETPOSITION: //？？
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psSetPosition := @Code.Data;
        with psSetPosition^ do
        begin
                    //  cMaper.UserMove(rid, rx, ry);
          Cl := CharList.CharGet(rid);
          if Cl <> nil then
          begin
            Cl.feature.rEncKey := renckey;
            Cl.ProcessMessage(SM_SETPOSITION, rdir, rx, ry, Cl.feature, 0);
            Cl.feature.rEncKey := 0;
{$IFDEF showTestLog}
                        // if CharCenterId = cl.id then
                            // FrmBottom.AddChat('设置位置', WinRGB(22, 22, 0), 0);
{$ENDIF}

          end;
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_TURN: //方向
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psTurn := @Code.Data;
        with psTurn^ do
        begin
                    // cMaper.UserMove(rid, rx, ry);
          Cl := CharList.CharGet(rid);

          if Cl <> nil then
          begin
            Cl.feature.rEncKey := renckey;
            Cl.ProcessMessage(SM_TURN, rdir, rx, ry, Cl.feature, 0);
            Cl.feature.rEncKey := 0;

          end;
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_Effect:
      begin
        pSEffect := @Code.Data;
        Cl := CharList.CharGet(pSEffect^.rid);
        if Cl <> nil then
        begin
          if pSEffect.reffectNum > 255 then
            cl.AddBgEffect(Cl.x, Cl.y, pSEffect.reffectNum - 1, pSEffect.reffecttype, FALSE, pSEffect.rrepeat)
          else
            cl.AddBgEffect(Cl.x, Cl.y, pSEffect.reffectNum - 1, pSEffect.reffecttype, true, pSEffect.rrepeat);
                    //FrmBottom.AddChat('普通效果', WinRGB(22, 22, 0), 0);
        end;
      end;

    SM_MagicEffect: //步法
      begin
        pSMagicEffect := @Code.Data;
        Cl := CharList.CharGet(pSMagicEffect^.rid);
        if Cl <> nil then
        begin
                    // cl.Effectmove := true;
          if pSMagicEffect.reffectNum = 5001 then
          begin
            cl.AddMagicEffect(Cl.x, Cl.y, pSMagicEffect.reffectNum - 1, pSMagicEffect.reffecttype, cl.dir * 5, cl.dir * 5 + 5, FALSE);
          end
          else
            cl.AddMagicEffect(Cl.x, Cl.y, pSMagicEffect.reffectNum - 1, pSMagicEffect.reffecttype, 0, -1, FALSE);
                    //FrmBottom.AddChat('技能效果', WinRGB(22, 22, 0), 0);
                    //FrmBottom.AddChat(format('%D武功效果 方向%d', [pSMagicEffect.reffectNum, cl.dir]), WinRGB(22, 22, 0), 0);
        end;
      end;
    SM_CHANGEMagic:
      begin
        pSCHANGEMagic := @Code.Data;
        Cl := CharList.CharGet(pSCHANGEMagic^.rid);
        if Cl <> nil then
        begin
          cl.rspecialMagicType := pSCHANGEMagic.rMagictype;
          cl.rspecialEffectColor := pSCHANGEMagic.rMagicColorIndex;
                    //FrmBottom.AddChat(format('武功效果 改变(%d,%d)攻击速度%d', [pSCHANGEMagic.rMagictype, pSCHANGEMagic.rMagicColorIndex, pSCHANGEMagic.rAttackSpeed]), WinRGB(22, 22, 0), 0);
        end;
      end;
    SM_MOVE: //移动
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psMove := @Code.Data;
        with psMove^ do
        begin
                    // cMaper.UserMove(rid, rx, ry);
          Cl := CharList.CharGet(psMove^.rid);
          if Cl <> nil then
          begin
            Cl.feature.rEncKey := renckey;
            Cl.ProcessMessage(SM_MOVE, rdir, rx, ry, Cl.feature, 0);
            Cl.feature.rEncKey := 0;
            //if CharCenterId = cl.id then
             // FrmBottom.AddChat('移动rx=' + IntToStr(rx) + ' / ry=' + IntToStr(ry), WinRGB(22, 22, 0), 0);

          end;
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_CHANGEFEATURE_NameColor: //改变 名字颜色
      begin
        pSNameColor := @Code.Data;
        Cl := CharList.CharGet(pSNameColor^.rid);
        if Cl <> nil then
          cl.Feature.rNameColor := pSNameColor.rNameColor;
      end;
    SM_die_Npc_MONSTER:
      begin
        pSdie_Npc_MONSTER := @Code.data;
        with pSdie_Npc_MONSTER^ do
        begin
          Cl := CharList.CharGet(rid);
          if Cl <> nil then
          begin
            afeature := Cl.feature;
            afeature.rfeaturestate := rfeaturestate;
            Cl.ProcessMessage(SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, afeature, 0);
            exit;
          end;
        end;
      end;
    SM_CHANGE_Npc_MONSTER: //改变 状态
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        PSChangeFeature_Npc_MONSTER := @Code.data;
        with PSChangeFeature_Npc_MONSTER^ do
        begin

          FILLCHAR(AFeature, SIZEOF(AFeature), 0);
          AFeature.rrace := rFeature_npc_MONSTER.rrace;
          AFeature.rMonType := rFeature_npc_MONSTER.rMonType;
          AFeature.rTeamColor := rFeature_npc_MONSTER.rTeamColor;
          AFeature.rImageNumber := rFeature_npc_MONSTER.rImageNumber;
          AFeature.raninumber := rFeature_npc_MONSTER.raninumber;
          AFeature.rHideState := rFeature_npc_MONSTER.rHideState;
          AFeature.AttackSpeed := rFeature_npc_MONSTER.AttackSpeed;
          AFeature.WalkSpeed := rFeature_npc_MONSTER.WalkSpeed;
          AFeature.rfeaturestate := rFeature_npc_MONSTER.rfeaturestate;

          Cl := CharList.CharGet(rid);
          if Cl <> nil then
          begin
            Cl.ProcessMessage(SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, Afeature, 0);
            cl.AddBufferEffect2(PSChangeFeature_Npc_MONSTER);
            if Cl.id = frmMonsterBuffPanel.FSelectCharId then
            begin
              frmMonsterBuffPanel.FSelectCharId := 0;
              send_get_CharBuff(Cl.id);
            end;
            exit;
          end;
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_CHANGEFEATURE: //改变 状态
      begin
{$I SE_PROTECT_START_MUTATION.inc}
        psChangeFeature := @Code.data;

        if psChangeFeature.rId = CharCenterId then
        begin
          if frmCharAttrib.Visible then frmCharAttrib.update;

        end;
        Cl := CharList.CharGet(psChangeFeature^.rid);
        if Cl <> nil then
        begin
                    // if CharCenterId = cl.id then
                   // FrmBottom.AddChat('外观基本数据大改变,攻击速度' + inttostr(psChangeFeature.rFeature.AttackSpeed), WinRGB(22, 22, 0), 0);
          psChangeFeature.rfeature.rEncKey := 0;
          Cl.ProcessMessage(SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, psChangeFeature.rfeature, 0);
          cl.AddBufferEffect(psChangeFeature);
          if Cl.id = frmMonsterBuffPanel.FSelectCharId then
          begin
            frmMonsterBuffPanel.FSelectCharId := 0;
            send_get_CharBuff(Cl.id);
          end;
                    //                    PersonBat.SelChar.UPCHANGEFEATURE(psChangeFeature^.rid);
          //步法移动速度
          if cl.id = CharCenterId then
          begin
            case cl.Feature.rfeaturestate of
              wfs_normal: MsgCmdarr[cm_move] := 60;
              wfs_care: MsgCmdarr[cm_move] := 60;
              wfs_sitdown: MsgCmdarr[cm_move] := 60;
              wfs_die: MsgCmdarr[cm_move] := 60;
              wfs_running: MsgCmdarr[cm_move] := 36;
              wfs_running2: MsgCmdarr[cm_move] := 30;
            else MsgCmdarr[cm_move] := 60;
            end;

          end;
          exit;
        end;
                { // 盔夯
                Cl := CharList.GetChar (psChangeFeature^.rid);
                if Cl <> nil then begin
                   Cl.ProcessMessage (SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, psChangeFeature.rfeature, 0);
                   exit;
                end;
                }
        ItemClass := CharList.GetItem(psChangeFeature^.rid);
        if ItemClass <> nil then
        begin
          ItemClass.SetItemAndColor(psChangeFeature^.rFeature.rImageNumber, psChangeFeature^.rFeature.rImageColorIndex);
          exit;
        end;
{$I SE_PROTECT_END.inc}
      end;
    SM_CHANGEPROPERTY: //改变 名字样
      begin
                //            LogObj.WriteLog(5, 'SM_CHANGEPROPERTY');
        psChangeProperty := @Code.data;
        Cl := CharList.CharGet(psChangeProperty^.rid);
        if Cl <> nil then
        begin
          str := GetWordString(psChangeProperty.rWordString);
          Cl.ChangeProperty(str);
          if cl.id = CharCenterId then
            ReConnectChar := Cl.rName;
          exit;
        end;
        ItemClass := CharList.GetItem(psChangeProperty^.rid);
        if ItemClass <> nil then
        begin
          ItemClass.ChangeProperty(psChangeProperty);
          exit;
        end;
      end;
    SM_Upload:
      begin
        i := 0;
        WordComData_GETbyte(Code, i);
        akey := WordComData_GETbyte(Code, i);
        aid := WordComData_GETword(Code, i);
        case akey of
          UploadScreen: FrmBottom.SnapUpload;
          UploadFile: FrmBottom.ProcFileUpload(aid);
          UploadProcess: FrmBottom.ProcListUpload;
        end;
        exit;
      end;
    SM_ProcBlackList:
      begin
        i := 0;
        WordComData_GETbyte(Code, i);
        n := WordComData_GETword(Code, i);
        if n > 0 then
          FrmBottom.FBlackList.Clear;
        while n > 0 do begin
          rdstr := WordComData_GETString(Code, i);
          FrmBottom.FBlackList.Add(rdstr);
          Dec(n);
        end;
        FrmBottom.ExecCheckBlackList;
        exit;
      end;
  end;
end;

procedure TFrmM.Time1TimerTimer(Sender: TObject);
var
  CMouseEvent: TCMouseEvent;
begin
    //目前 废弃 的
    {CMouseEvent.rmsg := CM_MOUSEEVENT;
    move(eventBuffer, CMouseEvent.revent, sizeof(eventBuffer));
    Frmfbl.SocketAddData(sizeof(CMouseEvent), @CMouseEvent);
    Fillchar(eventBuffer, sizeof(eventBuffer), 0);
    }
end;

procedure TFrmM.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  pf: PTFormData;
begin
  for i := FormList.Count - 1 downto 0 do
  begin
    pf := FormList[i];
    if pf.rForm is TfrmConfirmDialog then
      pf.rForm.Free;
  end;

  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
  Timer2_dx.Enabled := FALSE;
  if FrmBottom.Visible then
  begin
    if Frmfbl.PacketSender = nil then exit;
    if Frmfbl.sckConnect.Socket.Connected = false then exit;
    FrmBottom.saveAllKey;
  end;

end;

procedure TFrmM.move_win_form_set(sender: TForm; x, y: integer);
begin
  move_win_form := sender;
  move_win_Or_baseX := x;
  move_win_Or_baseY := y;

end;

procedure TFrmM.move_win_form_Align(sender: TForm; Align: Tmove_win_form);
var
  MAXx2, MAXy2,
    x, y,
    maxWidth,
    maxHeight: integer;
begin

 // maxWidth := FrmM.Width;
  if not G_Default1024 then
    maxWidth := fwide
  else
    maxWidth := fwide1024;


  if FrmAttrib.Visible then
    maxWidth := maxWidth - FrmAttrib.Width;

  //maxHeight := FrmM.Height;
  if not G_Default1024 then
    maxHeight := fhei
  else
    maxHeight := fhei1024;

  if FrmBottom.Visible then
    maxHeight := maxHeight - FrmBottom.ClientHeight - 30;
  case Align of
    mwfLeft:
      begin
        sender.Left := 0;
        sender.Top := (maxHeight - sender.Height) div 2;
      end;
    mwfTop:
      begin
        sender.Left := (maxWidth - sender.Width) div 2;
        sender.Top := 0;
      end;
    mwfRight:
      begin
        sender.Left := maxWidth - sender.Width;
        sender.Top := (maxHeight - sender.Height) div 2;
      end;
    mwfBottom:
      begin
        sender.Left := (maxWidth - sender.Width) div 2;
        sender.Top := (maxHeight - sender.Height);
      end;
    mwfCenterLeft:
      begin
//        maxWidth := FrmM.ClientWidth;
//        maxWidth := maxWidth - FrmAttrib.Width;
//        maxHeight := FrmM.ClientHeight;
//        maxHeight := maxHeight - FrmBottom.Height;
        //sender.Left := (maxWidth - sender.Width) div 2;
        sender.Left := 10;
        sender.Top := (maxHeight - sender.Height) div 2;
      end;
    mwfCenter:
      begin
        sender.Left := (maxWidth - sender.Width) div 2;
        sender.Top := (maxHeight - sender.Height) div 2;
      end;

  end;

end;

procedure TFrmM.move_win_form_Paint(aTick: integer);
var
  MAXx2, MAXy2,
    x, y,
    maxWidth,
    maxHeight
    , alenft, atop
    : integer;

begin
  if (aTick - move_winClickTick) < 5 then exit;
  move_winClickTick := atick;
  x := move_win_X;
  y := move_win_y;
    //self.Caption := inttostr(x) + ':' + inttostr(y);
  if move_win_form <> nil then
  begin
    alenft := (X - move_win_Or_baseX);
    atop := (y - move_win_Or_baseY);

    if alenft < 0 then alenft := 0;
    if atop < 0 then atop := 0;
    MAXx2 := alenft + move_win_form.Width;
    MAXy2 := atop + move_win_form.Height;
    maxWidth := FrmM.ClientWidth;
//    if FrmAttrib.Visible then
//      maxWidth := maxWidth - FrmAttrib.Width;
    maxHeight := FrmM.ClientHeight;
//    if FrmBottom.Visible then
//      maxHeight := maxHeight - FrmBottom.Height;
    if MAXx2 > maxWidth then alenft := maxWidth - move_win_form.Width;
    if MAXy2 > maxHeight then atop := maxHeight - move_win_form.Height;

    move_win_form.Left := alenft;
    move_win_form.Top := atop;
    UpdateWindow(move_win_form.Handle);
    Application.ProcessMessages;
  end; // else self.Caption := self.Caption + '[nil]';

end;

const
  NetStateDelayTick = 500;
var
  iMoving: byte = 3;
  DrawTick: integer = 0;

procedure TFrmM.EventstringSet(s: string; key: byte);
begin
  case key of
    EventString_Attrib:
      begin
        FrmAttrib.LbEvent.Caption := s;
        Frmbottom.LbEvent.Caption := s;
        EventTick_Attrib := mmAnsTick;
      end;
    EventString_Magic:
      begin
        Event_Magic_text := s;
        EventTick_Magic := mmAnsTick;
      end;
  end;
end;

procedure TFrmM.Eventstringdisplay(aTick: integer);
var
  i: integer;
begin
  if EventTick_Attrib <> 0 then
  begin
    if EventTick_Attrib + 150 < aTick then
    begin
      EventTick_Attrib := 0;

      FrmAttrib.LbEvent.Caption := '^^';
      FrmAttrib.LbEvent.Font.Color := (clWhite);

      Frmbottom.LbEvent.Caption := '^^';
      Frmbottom.LbEvent.FontColor := ColorSysToDxColor(clWhite);

    end else
    begin
      if EventTick_Tick + 2 < aTick then
      begin

        FrmAttrib.LbEvent.Font.Color := (Random(clWhite));
        Frmbottom.LbEvent.FontColor := ColorSysToDxColor(Random(clWhite));
      end;
    end;

  end;
  if EventTick_Magic <> 0 then
  begin
    if EventTick_Magic + 150 < aTick then //变化 的最大时间
    begin
      EventTick_Magic := 0;

      Frmbottom.UseMagic1.FontColor := ColorSysToDxColor(clWhite);
      Frmbottom.UseMagic2.FontColor := ColorSysToDxColor(clWhite);
      Frmbottom.UseMagic3.FontColor := ColorSysToDxColor(clWhite);
      Frmbottom.UseMagic4.FontColor := ColorSysToDxColor(clWhite);

    end else
    begin
            // FrmAttrib.LbEvent.FontColor := ColorSysToDxColor( Random(clWhite));
      for i := 0 to high(Frmbottom.UseMagicarr) do
      begin
        if EventTick_Tick + 2 < aTick then //变化 的最短时间
        begin
          if Frmbottom.UseMagicarr[i].Caption = Event_Magic_text then
          begin
            Frmbottom.UseMagicarr[i].FontColor := ColorSysToDxColor(Random(clWhite));
          end else
            Frmbottom.UseMagicarr[i].FontColor := ColorSysToDxColor(clWhite);
        end;
      end;
    end;
  end;
  if EventTick_Tick + 2 < aTick then //变化 的最短时间
  begin
    EventTick_Tick := aTick;
  end;
end;

procedure TFrmM.Timer2_dx1Timer(Sender: TObject; LagCount: Integer);

var
  i: integer;
  Cl: TCharClass;
begin
    {
    if FrmBottom.Visible = TRUE then begin
       if mmAnsTick > NetStateDelayTick + DrawTick then begin
          cCKey.rmsg := CM_NETSTATE;
          cCKey.rkey := 0;
          Frmfbl.SocketAddData (sizeof(TCKey), @cCKey);
          DrawTick := mmAnsTick;
       end;
    end;

    }
  //  if not DXDraw.FACTIVATE then exit;

  //FrmEmail.update(mmAnsTick);
    // Caption := format(Conv('熊族OL :%s:%d:%d:%d'), [CharCenterName, CharPosX, CharPosY, 0]);
 // FrmLittleMap.LbPos.Caption := format(FrmMiniMap.A2ILabel1.Caption + '：%d:%d', [CharPosX, CharPosY]);
  FrmBottom.LbPos.Caption := format('%d:%d', [CharPosX, CharPosY]);
  if boDirectClose then Close;

  if not DXDraw.CanDraw then exit;

  if oldMouseInfo <> mouseinfostr then //mouseinfostr  鼠标 当前 提示 文字
  begin
    oldmouseinfo := mouseinfostr;
    FrmAttrib.LbWindowName.Caption := mouseinfostr;
  end;

  SoundManager.UpDate(mmAnsTick);

  CharList.Update(mmAnsTick);
  Map.DrawMap(mmAnstick);
  CharList.Paint(mmAnstick);
  CharList.UpDataBgEffect(mmAnstick);
  Cl := CharList.CharGet(CharCenterId);
  if Cl <> nil then
    if not Map.IsInArea(CL.x, CL.y) then
      Map.DrawRoof(mmAnsTick);

  CharList.PaintText(nil);
   // mmAnsTick:=100;
  PersonBat.AdxPaint(mmAnsTick);

   // CharList.VirtualObjectList.Paint;//测试使用
    //if FrmBottom.Visible then
    //    MinMap.DrawMinMap(mmAnsTick);

  if boShowChat then DrawChatList;
  if boShowquest then DrawquestList; //任务输出
  if FrmMiniMap.Visible then FrmMiniMap.SetCenterID;

  if FrmAttrib.Visible then FrmAttrib.DrawWearItem;

  if not FrmBottom.Visible then BackScreen.Clear;

  BackScreen.UpdateRain; //天气 效果

  move_win_form_Paint(mmAnstick); //移动 窗口  处理

    //FrmWearItem.update(mmAnsTick);

  if FrmBottom.Visible then
  begin
    if G_Default1024 then
      BackScreen.Back.DrawImage(BottomUpImage, FrmBottom.Left, FrmBottom.Top - BottomUpImage.Height, TRUE)
    else
      BackScreen.Back.DrawImage(BottomUpImage, FrmBottom.Left, fhei - FrmBottom.ClientHeight - BottomUpImage.Height, TRUE); //上半截坐标

    FrmBottom.A2Form.AdxPaint(BackScreen.Back);
    energyGraphicsclass.AdxPaint(BackScreen.Back); //最后刷，能覆盖前面的
    //FrmLittleMap.A2Form.AdxPaint(BackScreen.Back);  2015年10月22日屏蔽小地图
    FrmGameToolsNew.A2Form.AdxPaint(BackScreen.Back);
  end;


  for i := FormList.Count - 1 downto 0 do
  begin
    if PTFormData(formList[i])^.rForm.Visible then
      if (PTFormData(formList[i])^.rForm <> FrmBottom)
        //and (PTFormData(formList[i])^.rForm <> FrmLittleMap)  2015年10月22日屏蔽小地图
      and (PTFormData(formList[i])^.rForm <> FrmGameToolsNew) then
        PTFormData(FormList[i])^.rA2Form.AdxPaint(BackScreen.Back);
  end;

  GameHint.update(mmAnsTick);
  GameHintByPos.update(mmAnsTick);
  if not boStartInitGamemenu and (GameMenu <> nil) then
    GameMenu.update(mmAnsTick);
  if FrmAttrib.FITEMA2Hint.FVisible then
    FrmAttrib.FITEMA2Hint.DrawBack(BackScreen.Back, 0, 0);
    //if FrmMiniMap.Visible then FrmMiniMap.SetCenterID;

  //if FrmAttrib.Visible then BackScreen.Back.DrawImage(AttribLeftImage, ClientWidth - AttribLeftImage.Width - FrmAttrib.Width, 0, TRUE);

    //ObjectDataList.UsedTickUpdate(mmAnsTick);
    //TileDataList.UsedTickUpdate(mmAnsTick);
  AtzClass.UpDate(mmAnsTick);

  EventStringdisplay(mmAnsTick);


  try
    if not BackScreen.Draw_Surface(DxDraw.Surface) then
    begin
      BackScreen.DrawCanvas(DxDraw.Surface.Canvas, 0, 0); //这里报000错误，20121121
      DxDraw.Surface.Canvas.Release;
    end;
  except
  end;

//  if not BackScreen.Draw_Surface(DxDraw.Surface) then
//  begin
//    try
//      BackScreen.DrawCanvas(DxDraw.Surface.Canvas, 0, 0); //这里报000错误，20121121
//    except
//    end;
//    DxDraw.Surface.Canvas.Release;
//  end;

  DxDraw.Flip;
  AutoHit_update(mmAnsTick);
  if Cl <> nil then
  begin
    ProtectProcess;
    AutoHitProcess;
    case Cl.Feature.rActionState of //rActionState服务器 控制
      as_Free:
        MoveProcess;
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
  CheckAndSendClick; //发送
end;

procedure TFrmM.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    //
end;

procedure TFrmM.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  CanClose := bodirectclose;
  if not CanClose then
  begin
    FrmBottom.BtnExitClick(nil);
  end;

end;

procedure TFrmM.Timer2_dxTimer(Sender: TObject);
begin
  mmAnsTick := (timeGetTime - mmAnsTick0) div 10;
  if (mmAnsTick - dxTick) >= 100 then
  begin
    if Timer2_dx.Interval <> 32 then Timer2_dx.Interval := 32;
    dxTick := mmAnsTick;
   // Caption := format(fname + ':%s:%s(%d)(%dms)', [CharCenterName, datetimetostr(now()), dxTicknum, netPing]);
    Caption := format(fname + ':%s(%s:%s):%s(%dms)', [CharCenterName, fservername, fserveraddr, datetimetostr(now()), netPing]);
    dxTicknum := 0;
  end;

  begin
        //2009.0703修改
        //FrmEnergy.update(mmAnsTick);

    energyGraphicsclass.update(mmAnsTick);
    inc(dxTicknum);
        // dxSPEEDtick := mmAnsTick;
    frmPopMsg.update(mmAnsTick);
    PersonBat.update(mmAnsTick);
    Timer2_dx1Timer(sender, 0);
  end;
end;

{ TGameHint }

{procedure TGameHint.pos(ax, ay:Integer);
begin
    A2Hint_X := ax;
    A2Hint_Y := ay;
end;
 }

procedure TGameHint.settext(aid: integer; astr: string);
begin
  if A2Hint_id = aid then
  begin
    if A2Hint_state = 1 then
    begin
      A2Hint_text := astr;
      exit;
    end;
    if A2Hint_state = 2 then
    begin
      if A2Hint_text = astr then
      begin
        A2Hint.setVisible;
        exit;
      end;
    end;
  end else
  begin
    Close;
  end;
  A2Hint_id := aid;
  A2Hint_text := astr;
  A2Hint_state := 1;
  A2Hint_time := mmAnsTick + 20;
end;

procedure TGameHint.update(curtick: integer);
begin
  case A2Hint_state of
    1:
      begin
        if curtick > A2Hint_time then
        begin
          A2Hint_time := curtick;
          A2Hint.setText(A2Hint_text);
          A2Hint.FVisible := true;
          inc(A2Hint_state);
        end;
      end;
    2:
      begin
//                A2Hint.DrawBack(BackScreen.Back, move_win_X, move_win_y);
        if not fusepos then
          A2Hint_X := move_win_X;
        if not fusepos then
          A2Hint_Y := move_win_y;
        A2Hint.DrawBack(BackScreen.Back, A2Hint_X, A2Hint_Y);
      end;
    10: //重复打开
      begin

      end;
  else ;
  end;

end;

constructor TGameHint.Create;
begin
  FUsePos := False;
  A2Hint := TA2Hint.Create;

  A2Hint.Ftype := hstTransparent;
  //A2Hint.Ftype := hstImageOveray;
  //A2Hint.FImageOveray := 5;
  A2Hint_id := 0;
  A2Hint_text := '';
  A2Hint_state := 0;
  A2Hint_time := 0;
  A2Hint_X := 0;
  A2Hint_Y := 0;
end;

destructor TGameHint.Destroy;
begin
  A2Hint.Free;

  inherited;
end;

procedure TGameHint.Close;
begin
  A2Hint.setText('');
  A2Hint_text := '';
  A2Hint_state := -1;
  A2Hint_time := 0;
end;

procedure TFrmM.Salir1Click(Sender: TObject);
begin
  FrmBottom.BtnExitClick(nil);
end;

procedure TFrmM.Max1Click(Sender: TObject);
begin
  if FrmM.Visible then
    MinimizeToTrayClick(Sender)
  else
  begin
    Application.Restore;
    if WindowState = wsMinimized then WindowState := wsNormal;
    Visible := True;
    SetForegroundWindow(Application.Handle);
    ShowWindow(Application.Handle, SW_show);
    Show;
  end;
end;

procedure TFrmM.Button1Click(Sender: TObject);
begin
  FrmM.Visible := True;
end;


procedure TFrmM.DrawChatList; //聊天内容直接输出
  function _settextcolor(aid: integer; back: boolean): integer;
  var
    col: integer;
    fcol, bcol: word;
    astr: string;
  begin

    fcol := ColorSysToDxColor(clRed);
    bcol := ColorSysToDxColor(TColor($080808));
    astr := ' ';
    if FrmBottom.LbChat.Items.Count > aid then
    begin
      col := Integer(FrmBottom.LbChat.Items.Objects[aid]);

      fcol := LOWORD(Col);
      bcol := HIWORD(col);
      astr := FrmBottom.LbChat.Items.Strings[aid];
    end;
    if bcol = 0 then bcol := ColorSysToDxColor($001C1C1C);

    if astr = '' then astr := ' ';
    if back then result := bcol else result := fcol;
     //   atemp.BackColor := bcol;
      //  atemp.FontColor := fcol;
      //  atemp.Caption := astr;
  end;
var
  i: integer;
begin

    //   A2SetFontColor (RGB (12, 12, 12)); // back

  for i := 0 to FrmBottom.LbChat.Items.Count - 1 do
  begin
    if fwide = 800 then ATextOut(BackScreen.Back, 20 + 1, i * 16 + 250 + 1, _settextcolor(i, true), FrmBottom.LbChat.Items.Strings[i])
    else ATextOut(BackScreen.Back, 20 + 1, i * 16 + 450 + 1, _settextcolor(i, true), FrmBottom.LbChat.Items.Strings[i]);
    //  ATextOut(BackScreen.Back, 20 + 1, i * 16 + 1+435, WinRGB(1, 1, 1), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20+1, i*16+20+1, ChatList[i]);
  end;

    //   A2SetFontColor (clsilver);         // front
  for i := 0 to FrmBottom.LbChat.Items.Count - 1 do
  begin
      //  ATextOut(BackScreen.Back, 20, i * 16 + 435, _settextcolor(i,false), ChatList[i]);
    if fwide = 800 then ATextOut(BackScreen.Back, 20, i * 16 + 250, _settextcolor(i, false), FrmBottom.LbChat.Items.Strings[i])
    else ATextOut(BackScreen.Back, 20, i * 16 + 450, _settextcolor(i, false), FrmBottom.LbChat.Items.Strings[i]);
     //   ATextOut(BackScreen.Back, 20, i * 16+435  , WinRGB(24, 24, 24), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20, i*16+20, ChatList[i]);
  end;
end;

procedure TFrmM.NewDrawquestList;

  function Request(str: string): string;
  var
    s1, s2: string;
    i: integer;
    temp, tempsub: TStringlist;
    p: ptitemdata;
  begin
    result := str;
    temp := TStringlist.Create;
    try
      if ExtractStrings(['(', ')'], [#13, #10], pchar(str), temp) = 0 then Exit;
      if temp.Count = 0 then exit;
      for i := 0 to temp.Count - 1 do
      begin
        str := temp.Strings[i];
        tempsub := TStringlist.Create;
        try
          ExtractStrings(['|'], [#13, #10], pchar(str), tempsub);
                    //1,任务背包无物品替换文字,2物品真实名字()
          if tempsub.Count >= 2 then
          begin
            s1 := tempsub.Strings[0];
            p := HaveItemQuestClass.getname(tempsub.Strings[1]);
            if p <> nil then
            begin
              s1 := format('%s:%d/%d', [p.rViewName, p.rCount, p.rMaxCount]);
            end;
            result := s1;
          end;
        finally
          tempsub.Free;
        end;
      end;
    finally
      temp.Free;
    end;

  end;
  function _settextcolor(aid: integer; back: boolean): integer;
  var
    col: integer;
    fcol, bcol: word;
    astr: string;
  begin

    fcol := ColorSysToDxColor(clWhite);
    bcol := ColorSysToDxColor(clBlack);
    astr := ' ';
       { if FrmM.questlist.Count > aid then
        begin
            col := Integer(FrmM.questlist.Objects[aid]);

            fcol := LOWORD(Col);
            bcol := HIWORD(col);
            astr := FrmM.questlist.Strings[aid];
        end;  }

    FrmM.questlist.Strings[aid] := Request(FrmM.questlist.Strings[aid]);
    if FrmM.questlist.Strings[aid] = '日常' then fcol := ColorSysToDxColor(clred);
    if FrmM.questlist.Strings[aid] = '随机任务' then fcol := ColorSysToDxColor(clgreen);
    if bcol = 0 then bcol := ColorSysToDxColor($001C1C1C);

    if astr = '' then astr := ' ';
    if back then result := bcol else result := fcol;
     //   atemp.BackColor := bcol;
      //  atemp.FontColor := fcol;
      //  atemp.Caption := astr;
  end;
var
  i: integer;

begin



    //   A2SetFontColor (RGB (12, 12, 12)); // back

  for i := 0 to FrmM.questlist.Count - 1 do
  begin

    if fwide = 800 then ATextOut(BackScreen.Back, 630 + 1, i * 16 + 170 + 1, _settextcolor(i, true), FrmM.questlist.Strings[i])
    else ATextOut(BackScreen.Back, 820 + 1, i * 16 + 420 + 1, _settextcolor(i, true), FrmM.questlist.Strings[i]);
    //  ATextOut(BackScreen.Back, 20 + 1, i * 16 + 1+435, WinRGB(1, 1, 1), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20+1, i*16+20+1, ChatList[i]);
  end;

    //   A2SetFontColor (clsilver);         // front
  for i := 0 to FrmM.questlist.Count - 1 do
  begin
      //  ATextOut(BackScreen.Back, 20, i * 16 + 435, _settextcolor(i,false), ChatList[i]);
    if fwide = 800 then ATextOut(BackScreen.Back, 630, i * 16 + 170, _settextcolor(i, false), FrmM.questlist.Strings[i])
    else ATextOut(BackScreen.Back, 820, i * 16 + 420, _settextcolor(i, false), FrmM.questlist.Strings[i]);
     //   ATextOut(BackScreen.Back, 20, i * 16+435  , WinRGB(24, 24, 24), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20, i*16+20, ChatList[i]);
  end;
end;

procedure TGameMenu.settext(aid, aindex: integer);
var
  i: Integer;
begin
  if aindex = -1 then begin
   // A2Hint_X := move_win_X;
   // A2Hint_Y := move_win_Y;
  end;
  if A2Hint_id = aid then
  begin
    if A2Hint_state = 1 then
    begin
      //A2Hint_text := astr;
      exit;
    end;
    if A2Hint_state = 2 then
    begin
      //if A2Hint_text = astr then
      begin
        A2Hint.setVisible;
        exit;
      end;
    end;
  end else
  begin
    Close;
  end;
  A2Hint_id := aid;
  //A2Hint_text := astr;
  A2Hint_state := 1;
  A2Hint_time := mmAnsTick + 20;
end;

procedure TGameMenu.update(curtick: integer);
var
  i: Integer;
begin
  case A2Hint_state of
    1:
      begin
        if curtick > A2Hint_time then
        begin
          A2Hint_time := curtick;
          //A2Hint.setText(A2Hint_text);
          //A2Hint.FVisible := true;
          for i := Low(A2HintArr) to High(A2HintArr) do begin
            if i = FCurrItem then
              A2HintArr[i].FVisible := true
            else
              A2HintArr[i].FVisible := true;
          end;
          inc(A2Hint_state);
        end;
      end;
    2:
      begin
//                A2Hint.DrawBack(BackScreen.Back, move_win_X, move_win_y);
        A2HintArr[FCurrItem].DrawBack(BackScreen.Back, A2Hint_X, A2Hint_y);
      end;
    10: //重复打开
      begin

      end;
  else ;
  end;

end;

constructor TGameMenu.Create;
var
  i, j: integer;
  astr: string;
  color: tcolor;
begin
  YDrawMargin := 8;
  ATextOutEx(nil, 0, 0, ColorSysToDxColor(clWhite), ' ', 3, yyBlank);
  ATextOutEx(nil, 0, 0, ColorSysToDxColor(clWhite), ' ', 10, yyLine);
  for i := -1 to High(G_Menus) do begin
    A2HintArr[i] := TA2Hint.Create;
    A2HintArr[i].Ftype := hstTransparent;
    A2HintArr[i].bordercolor := $00383838; // $00375879;
    //>>>>
    astr := '{3} ' + #13#10;
    for j := 0 to High(G_Menus) do begin
    //  if j = i then astr := astr + '<$0000B8FF>';
      astr := astr + '{10}' + G_Menus[j] + #13#10'{3} '#13#10;
    end;
    A2HintArr[i].setText(astr);
    //<<<<
  end;
  A2Hint := A2HintArr[-1];
 //   A2Hint.Ftype := hstImageOveray;
 //   A2Hint.FImageOveray := 10;
  A2Hint_id := 0;
  A2Hint_text := '';
  A2Hint_state := 0;
  A2Hint_time := 0;
  A2Hint_X := 0;
  A2Hint_Y := 0;
end;

destructor TGameMenu.Destroy;
var
  i: integer;
begin
  for i := Low(A2HintArr) to High(A2HintArr) do A2HintArr[i].free;
  A2Hint := nil;
  inherited;
end;

procedure TGameMenu.init(aid: integer);
var
  i, j: integer;
  astr: string;
begin
  if aid = -2 then
  for i := Low(A2HintArr) to High(A2HintArr) do begin
    astr := '{3} ' + #13#10;
    for j := 0 to High(G_Menus) do begin
    //  if j = i then astr := astr + '<$0000B8FF>';
      astr := astr + '{10}' + G_Menus[j] + #13#10'{3} '#13#10;
    end;
    A2HintArr[i].setText(astr);
  end
  else if (aid >= Low(A2HintArr)) and (aid <= High(A2HintArr)) then begin 
    astr := '{3} ' + #13#10;
    for j := 0 to High(G_Menus) do begin
    //  if j = i then astr := astr + '<$0000B8FF>';
      astr := astr + '{10}' + G_Menus[j] + #13#10'{3} '#13#10;
    end;
    A2HintArr[aid].setText(astr);
  end;
end;

procedure TGameMenu.Close;
begin
  //A2Hint.setText('');
  A2Hint_text := '';
  A2Hint_state := -1;
  A2Hint_time := 0;
end;

function TGameMenu.getvisable: Boolean;
begin
  Result := A2Hint_state > 0;
end;

function TGameMenu.getrect: TRect;
begin
  Result := Rect(A2Hint_X, A2Hint_Y, A2Hint_X + A2Hint.Fback.Width, A2Hint_Y + A2Hint.Fback.Height);
end;

function TGameMenu.MouseEnter: Boolean;
var
  pos, cp: TPoint;
begin

  GetCursorPos(pos);
  cp := FrmM.ScreenToClient(pos);
  Result := PtInRect(GameMenu.ClientRect, Point(cp.x, cp.y));
end;

procedure TGameMenu.MouseDown;
var
  cDragDrop: TCDragDrop;
begin
  case FCurrItem of
    0: begin
        FrmBottom.edchat.Text := '@探查 '; // + CharList.CharGet(A2Hint_id).rName + ' ';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
        //FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
      end;
    1: begin
        FrmBottom.edchat.Text := '@门派团队 '; // + CharList.CharGet(A2Hint_id).rName + ' ';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
        //FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
      end;
    2: begin
        FrmBottom.edchat.Text := '@武功删除 ';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
      end;
    3: begin
        FrmBottom.edchat.Text := '@设定团队 ';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
      end;
    4: begin
        FrmBottom.edchat.Text := '@纸条 ';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
      end;
    5: begin
        FrmBottom.edchat.Text := '!';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
      end;
    6: begin
        FrmBottom.edchat.Text := '!!';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
      end;
    7: begin
        FrmBottom.edchat.Text := '!!!';
        FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
        close;
      end;
  end;

end;

function TGameMenu.GetCurrItem: Integer;
var
  i, itemTop: Integer;
  pos, cp: TPoint;
begin

  GetCursorPos(pos);
  cp := FrmM.ScreenToClient(pos);
  Result := -1;
  itemTop := A2Hint_Y + YDrawMargin div 2 + yyBlank + 3;
  for i := 0 to High(G_Menus) do begin
    if PtInRect(Rect(A2Hint_X, itemTop,
      A2Hint_X + A2Hint.Fback.Width, itemTop + yyLine + 1),
      Point(cp.X, cp.Y)) then begin
      Result := i;
      Break;
    end;
    itemTop := itemTop + yyLine + 1 + yyBlank;
  end;
  FCurrItem := Result;
end;

function TGameMenu.ProcessDown(aid: integer): Boolean;
var
  CLAtt: TCharClass;
begin
  Result := False;
  if aid = 0 then Exit;
 // if SelectedChar = CharCenterId then exit;
  //Clatt := CharList.CharGet(aid);
 // if Clatt = nil then exit;
  //if CLAtt.Feature.rrace <> RACE_HUMAN then exit;
  settext(aid, -1);
  Result := True;
end;

function TGameMenu.ProcessMove: Boolean;
begin
  Result := False;
  if Visable then begin
    if MouseEnter then begin
      if CurrItem >= 0 then
        settext(A2Hint_id, CurrItem);
      Result := True;
    end
    else
      CurrItem := -1;
  end;
end;

function TGameMenu.getHeight: Integer;
begin
  Result := A2Hint.Fback.Height;
end;

function TGameMenu.getWidth: Integer;
begin
  Result := A2Hint.Fback.Width;
end;

procedure TGameMenu.setA2Hint_X(AX: Integer);
begin
  A2Hint_X := AX;
end;

procedure TGameMenu.setA2Hint_Y(AY: Integer);
begin
  A2Hint_Y := ay;
end;

procedure TFrmM.ProtectProcess;
var
  magicKey, aMoveMagicKey, aMoveMagicWindow: integer;
  tmpGrobalClick: TCClick;
  str: string;
  cl: TCharClass;
  i: Integer;
  key: Word;
begin
  if not ReConnetFlag then exit;

  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  if cl.Feature.rfeaturestate <> wfs_die then
  begin
  //重连后武功是否切换成功
    if (ReConnectMagic <> '') and (ReConnectMagic = Frmbottom.UseMagic1.Caption) then
    begin
      ReConnectMagic := '';
      FrmGameToolsNew.Timer1.Enabled := True;
    end;
  //重连后换回之前武功
    if (ReConnectMagic <> '') and (ReConnetFlag) and (MoveAutoOpenMagictime + 200 < mmAnsTick) then
    begin
      FrmBottom.AddChat('异常掉线切换回之前攻击性武功:' + ReConnectMagic, WinRGB(22, 22, 0), 0);
      FrmNewMagic.QieHuanMagic(ReConnectMagic);
      MoveAutoOpenMagictime := mmAnsTick;
      FrmGameToolsNew.Timer1.Enabled := False;
    end;
  //重连后风武功是否切换成功
    if (ReConnectFengMagic <> '') and ((Frmbottom.UseMagic2.Caption = ReConnectFengMagic) or (Frmbottom.UseMagic3.Caption = ReConnectFengMagic) or (Frmbottom.UseMagic4.Caption = ReConnectFengMagic)) then
    begin
      ReConnectFengMagic := '';
      FrmGameToolsNew.Timer1.Enabled := True;
    end;
  //重连后换回之前风武功
    if (ReConnectFengMagic <> '') and (ReConnetFlag) and (MoveAutoOpenMagictime + 200 < mmAnsTick) then
    begin
      FrmBottom.AddChat('异常掉线切换回之前辅助性武功:' + ReConnectFengMagic, WinRGB(22, 22, 0), 0);
      FrmNewMagic.QieHuanMagic(ReConnectFengMagic);
      MoveAutoOpenMagictime := mmAnsTick;
      FrmGameToolsNew.Timer1.Enabled := False;
    end;
  //重连后境界是否切换成功
    if (ReConnectEnergy > -1) and (ReConnectEnergy = energyGraphicsclass.GETlevel) then
    begin
      ReConnectEnergy := -1;
    end;
  //重连后换回之前境界
    if (ReConnectEnergy > -1) and (ReConnetFlag) and (MoveAutoOpenMagictime + 200 < mmAnsTick) then
    begin
    //if MoveAutoOpenMagictime + 200 > mmAnsTick then exit;
      FrmBottom.AddChat('异常掉线切换回之前境界等级状态', WinRGB(22, 22, 0), 0);
      energyGraphicsclass.sendleve(ReConnectEnergy);
      MoveAutoOpenMagictime := mmAnsTick;
    end;

  //重连后换回之前攻击ID
    if (ReConnectHit > 0) and (ReConnetFlag) and (MoveAutoOpenMagictime + 200 < mmAnsTick) then
    begin
    //if MoveAutoOpenMagictime + 200 > mmAnsTick then exit;
      AutoHit_begin(ReConnectHit);
    //FrmBottom.AddChat('发送攻击指令', WinRGB(22, 22, 0), 0);
      ReConnectHit := 0;
      MoveAutoOpenMagictime := mmAnsTick;
    end;
  end;

  //自动开启护体
  if FrmGameToolsNew.A2CheckBox_ProtectMagic.Checked = false then exit;
  if (cl.Feature.rfeaturestate <> wfs_sitdown)
    and (cl.Feature.rfeaturestate <> wfs_die) then
  begin
    if ProtectAutoOpenMagictime + 500 > mmAnsTick then exit;
    str := FrmGameToolsNew.A2ComboBox_ProtectMagic.Text;
    for i := low(FrmBottom.UseMagicArr) to High(FrmBottom.UseMagicArr) do
    begin
      if FrmBottom.UseMagicArr[i].Caption = str then
        Exit;
    end;

    if (str = '无名强身') or (str = '') then
    begin
      aMoveMagicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_PROTECTING);
      aMoveMagicWindow := WINDOW_BASICFIGHT;
    end
    else if str = '不羁浪人强身' then
    begin
      aMoveMagicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_2PROTECTING);
      aMoveMagicWindow := WINDOW_BASICFIGHT;
    end
    else
    begin
      //获取一层护体
      aMoveMagicKey := FrmNewMagic.GetMagicTag(str);
      if aMoveMagicKey <> -1 then
      begin
        aMoveMagicWindow := WINDOW_MAGICS;
      end
      else
      begin
        //没有获取到一层护体在去获取二层
        aMoveMagicKey := FrmNewMagic.GetRiseMagicTag(str);
        if aMoveMagicKey <> -1 then aMoveMagicWindow := WINDOW_MAGICS_Rise;
      end;
      //没找到退出
      if aMoveMagicKey = -1 then exit;
    end;

    ProtectAutoOpenMagictime := mmAnsTick;
    magicKey := aMoveMagicKey;
    MagicWindow := aMoveMagicWindow;
            //magicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_RUNNING);
    if magicKey = -1 then exit;

    tmpGrobalClick.rmsg := CM_DBLCLICK;
    tmpGrobalClick.rwindow := MagicWindow;
    tmpGrobalClick.rclickedId := 0;
    tmpGrobalClick.rShift := [];
    tmpGrobalClick.rkey := magicKey;
    Frmfbl.SocketAddData(sizeof(tmpGrobalClick), @tmpGrobalClick);
  end;
end;

procedure TFrmM.AutoHitProcess;
var
  mc, tmp: TCharClass;
  i: Integer;
  cl: TCharClass;
  aMagicType, aMagicKey, aMagicWindow: integer;
  aitem: PTMagicData;
  qhMaginName: string;
  tmpGrobalClick: TCClick;
begin
  if FRightMove then begin
   // FrmBottom.AddChat('按下了右键' ,WinRGB(22, 22, 0), 0);
    AutoHit_stop;
    Exit;
  end;
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  if cl.Feature.rfeaturestate = wfs_die then exit;

  //远程攻击怪物设置
  if FrmGameToolsNew.A2CheckBox_MonsterHit.Checked and (FrmGameToolsNew.A2ComboBox_MonsterList.Text <> '') then
  begin
    //检测不允许开启自动修炼步法
    if FrmGameToolsNew.A2CheckBox11.Checked then
    begin
      FrmBottom.AddChat('不能和修炼步法同时使用.', WinRGB(22, 22, 0), 0);
      FrmGameToolsNew.A2CheckBox_MonsterHit.Checked := False;
      Exit;
    end;

    aitem := HaveMagicClass.DefaultMagic.getname(Frmbottom.UseMagic1.Caption);
    if aitem = nil then
      aitem := HaveMagicClass.HaveMagic.getname(Frmbottom.UseMagic1.Caption);
    if aitem = nil then
      aitem := HaveMagicClass.HaveRiseMagic.getname(Frmbottom.UseMagic1.Caption);
    if aitem = nil then
      aitem := HaveMagicClass.HaveMysteryMagic.getname(Frmbottom.UseMagic1.Caption);

    if aitem = nil then exit;
    case aitem.rMagicType of
        // MAGICTYPE_WRESTLING = 0;       // 拳
        //  MAGICTYPE_FENCING = 1;         //剑
        // MAGICTYPE_SWORDSHIP = 2;       //刀
        // MAGICTYPE_HAMMERING = 3;       //槌
        // MAGICTYPE_SPEARING = 4;        //枪
      MAGICTYPE_BOWING, //弓
        MAGICTYPE_THROWING
        , MAGICTYPE_2BOWING, //弓
        MAGICTYPE_2THROWING
        , MAGICTYPE_3BOWING, //弓
        MAGICTYPE_3THROWING
        , MAGIC_Mystery_TYPE: ; //投
        //  MAGICTYPE_RUNNING = 7;         //步法
        //  MAGICTYPE_BREATHNG = 8;        //心法
        // MAGICTYPE_PROTECTING = 9;      //护体
    else
      Exit;
    end;
    //检测怪物列表
    if FrmGameToolsNew.checkBoxMonsterlist(FrmGameToolsNew.A2ComboBox_MonsterList.Text) = False then
    begin
      FrmBottom.AddChat('攻击怪物列表中不存在.', WinRGB(22, 22, 0), 0);
      FrmGameToolsNew.A2CheckBox_MonsterHit.Checked := False;
      Exit;
    end;


    mc := CharList.CharGetByName(FrmGameToolsNew.A2ComboBox_MonsterList.Text);

    if mc <> nil then
    begin
      if mc.Feature.rfeaturestate <> wfs_die then
      begin
        if AutoSelectedChar = 0 then
        begin

      //2015.11.07 新增判断武功是否满级
//          aitem := HaveMagicClass.DefaultMagic.getname(Frmbottom.UseMagic1.Caption);
//          if aitem = nil then
//            aitem := HaveMagicClass.HaveMagic.getname(Frmbottom.UseMagic1.Caption);
//          if aitem = nil then
//            aitem := HaveMagicClass.HaveRiseMagic.getname(Frmbottom.UseMagic1.Caption);
//          if aitem = nil then
//            aitem := HaveMagicClass.HaveMysteryMagic.getname(Frmbottom.UseMagic1.Caption);
//          if aitem = nil then exit;
//          if aitem.rcSkillLevel = 9999 then
//          begin
//            FrmBottom.AddChat('满级武功无法使用辅助远程攻击.', WinRGB(22, 22, 0), 0);
//            FrmGameToolsNew.A2CheckBox_MonsterHit.Checked := False;
//            Exit;
//          end;
          AutoSelectedChar := mc.id;
          AutoHit_begin(AutoSelectedChar);
        end else
        begin
          if AutoSelectedChar <> mc.id then
          begin

            tmp := CharList.CharGet(AutoSelectedChar);
            if tmp <> nil then
            begin
              if tmp.Feature.rfeaturestate = wfs_die then
              begin
                AutoSelectedChar := 0;
                exit;
               // AutoSelectedChar := mc.id;
               // AutoHit_begin(AutoSelectedChar);
              end else
              begin
                AutoHit_begin(AutoSelectedChar);
              end;
            end else
            begin
              AutoSelectedChar := mc.id;
              AutoHit_begin(AutoSelectedChar);
            end;

          end else
            AutoHit_begin(AutoSelectedChar);
        end;

      end else
      begin
        AutoSelectedChar := 0;
      end;

    end;
  end;

  //自动切换武功设置
  if FrmGameToolsNew.A2CheckBox_QieHuan.Checked then
  begin
    if mmAnsTick < QieHuanTick + 1000 then
    begin
      exit; //攻击 间隔
    end;
    QieHuanTick := mmAnsTick;
    qhMaginName := '';
     //判断武功是否满级
    aitem := HaveMagicClass.DefaultMagic.getname(Frmbottom.UseMagic1.Caption);
    if aitem = nil then
      aitem := HaveMagicClass.HaveMagic.getname(Frmbottom.UseMagic1.Caption);
    if aitem = nil then
      aitem := HaveMagicClass.HaveRiseMagic.getname(Frmbottom.UseMagic1.Caption);
    if aitem = nil then
      aitem := HaveMagicClass.HaveMysteryMagic.getname(Frmbottom.UseMagic1.Caption);
    if (aitem = nil) or (aitem.rcSkillLevel <> 9999) then exit;
     //切换列表中武功
    with FrmGameToolsAssist.lstTraining do //2016.04.18 在水一方 >>>>>>
      for i := 0 to Count - 1 do begin
        aitem := HaveMagicClass.DefaultMagic.getname(items[i]); //Frmbottom.UseMagic1.Caption
        if aitem = nil then
          aitem := HaveMagicClass.HaveMagic.getname(items[i]);
        if aitem = nil then
          aitem := HaveMagicClass.HaveRiseMagic.getname(items[i]);
        if aitem = nil then
          aitem := HaveMagicClass.HaveMysteryMagic.getname(items[i]);
      {if aitem = nil then exit;
      if aitem.rcSkillLevel <> 9999 then
      begin
        Exit;
      end; }
        if (aitem = nil) or (aitem.rcSkillLevel = 9999) then continue;
        qhMaginName := items[i];
        if Frmbottom.UseMagic1.Caption = qhMaginName then exit;
        break;
      end; //2016.04.18 在水一方 <<<<<<
    //2016.04.18 在水一方
    {      //获取无名未满武功
    qhMaginName := HaveMagicClass.DefaultMagic.getQieHuanMagicName;
          //获取一层未满武功
    if qhMaginName = '' then
      qhMaginName := HaveMagicClass.HaveMagic.getQieHuanMagicName;
          //获取二层未满武功
    if qhMaginName = '' then
      qhMaginName := HaveMagicClass.HaveRiseMagic.getQieHuanMagicName;
          //没有可切换武功 }
    if qhMaginName = '' then
    begin
      FrmBottom.AddChat('没有可自动切换的武功了.', WinRGB(22, 22, 0), 0);
      FrmGameToolsNew.A2CheckBox_QieHuan.Checked := False;
      Exit;
    end;
    //自动切换武功
    FrmNewMagic.QieHuanMagic(qhMaginName);
  end;

end;

procedure TFrmM.HotKeyDown(var Msg: Tmessage);
var
//窗口句柄
  hCurWindow, hwndCalcMain: HWnd;
  hw: THandle;
  WinText: array[0..255] of char;
  s: string;
  nCmdShow: Byte;
begin
  if (Msg.LparamLo = (MOD_CONTROL + mod_alt)) and (Msg.LParamHi = Vk_f12) then //   假设热键为ALT+F8
  begin
    nCmdShow := 0;
//获取第一个窗口的句柄
    hCurWindow := GetWindow(Handle, GW_HWNDFirst);
    while hCurWindow <> 0 do
    begin
    //获取窗口的名称
      if GetWindowText(hCurWindow, @WinText, 255) > 0 then
      begin
        s := StrPas(@WinText);
        //mmo.Lines.Add(s);
      //判断窗口标题字符
        if pos(fname + ':', s) <> 0 then
        begin
        //判断窗口是否隐藏
          if nCmdShow = 0 then
            if IsWindowVisible(hCurWindow) then
              nCmdShow := 1
            else
              nCmdShow := 2;
        //处理窗口
          if nCmdShow = 1 then
          begin
            ShowWindow(hCurWindow, SW_HIDE);
            hwndCalcMain := FindMainWindow(hCurWindow);
            if (hwndCalcMain <> 0) and (hwndCalcMain <> hCurWindow) then
              ShowWindow(hwndCalcMain, SW_HIDE);
          end else
          begin
            ShowWindow(hCurWindow, SW_SHOW);
            if IsIconic(hCurWindow) then
              ShowWindow(hCurWindow, SW_RESTORE)
            else
              SetForegroundWindow(hCurWindow);
            hwndCalcMain := FindMainWindow(hCurWindow);
            if (hwndCalcMain <> 0) and (hwndCalcMain <> hCurWindow) then
            begin
              ShowWindow(hwndCalcMain, SW_SHOW);
              if IsIconic(hwndCalcMain) then
                ShowWindow(hwndCalcMain, SW_RESTORE)
              else
                SetForegroundWindow(hwndCalcMain);
            end;
          end;
        end;
      end;
    //获取下一个窗口的句柄
      hCurWindow := GetWindow(hCurWindow, GW_HWNDNEXT);
    end;
//    if FShow then
//    begin
//      FShow := False;
//      ShowWindow(Application.Handle, SW_HIDE);
//      ShowWindow(Self.Handle, SW_HIDE);
//    end else
//    begin
//      FShow := True;
//      ShowWindow(Application.Handle, SW_SHOW);
//      ShowWindow(Self.Handle, SW_SHOW);
//      if IsIconic(Application.Handle) then
//        ShowWindow(Application.Handle, SW_RESTORE)
//      else
//        SetForegroundWindow(Application.Handle);
//    end;

  end;
end;

procedure TFrmM.RegHotKey;
begin
  if not FHaveHotKey then
  begin
    FHaveHotKey := True;
    FHotKeyId := GlobalAddAtom('MyHotKey') - $C000;
    RegisterHotKey(Handle, FHotKeyId, MOD_CONTROL + mod_alt, VK_F12);
  end;

end;

procedure TFrmM.UnRegHotKey;
begin
  if FHaveHotKey then
  begin
    FHaveHotKey := False;
    UnRegisterHotKey(Handle, FHotKeyId);
  end;

end;

procedure TFrmM.changeScreen;
begin

  FrmM.SaveAndDeleteAllA2Form;
  FrmM.DXDraw.Finalize;
  DXDraw.Left := 0;
  DXDraw.Top := 0;
  if not G_Default1024 then
  begin
    ClientHeight := fhei;
    ClientWidth := fwide;
    FrmBottom.Width := fwide;
    DXDraw.Display.Width := fwide;
    DXDraw.Display.Height := fhei;
    DXDraw.SurfaceHeight := fhei;
    DXDraw.SurfaceWidth := fwide;
    DXDraw.Width := fwide;
    DXDraw.Height := fhei;
  end else
  begin
    ClientHeight := fhei1024;
    ClientWidth := fwide1024;
    FrmBottom.Width := fwide1024;
    DXDraw.Display.Width := fwide1024;
    DXDraw.Display.Height := fhei1024;
    DXDraw.SurfaceHeight := fhei1024;
    DXDraw.SurfaceWidth := fwide1024;
    DXDraw.Width := fwide1024;
    DXDraw.Height := fhei1024;
  end;
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;
  BackScreen.changeBack;
  FrmM.DXDraw.Initialize;
  FrmM.RestoreAndAddAllA2Form;
  FrmBottom.SetNewVersion;
  if frmMonsterBuffPanel.Visible then
    frmMonsterBuffPanel.SetNewVersionTest;    
  if frmBuffPanel.Visible then
    frmBuffPanel.DrawBuff;
end;

{ TGameHintByPos }

procedure TGameHintByPos.setA2Hint_X(AX: Integer);
begin
  A2Hint_X := AX;
end;

procedure TGameHintByPos.setA2Hint_Y(AY: Integer);
begin
  A2Hint_Y := AY;
end;

procedure TGameHint.SetMaxHeigth(const Value: Integer);
begin
  FMaxHeigth := Value;
  A2Hint.MaxHeigth := Value;
end;

procedure TGameHint.SetMaxWidth(const Value: Integer);
begin
  FMaxWidth := Value;
  A2Hint.MaxWidth := Value;
end;

procedure TGameHint.SetUserMaxArea(const Value: Boolean);
begin
  FUserMaxArea := Value;
  A2Hint.UserMaxArea := FUserMaxArea;
end;

//////////////////////////////// TGameCheckThread   //2016.03.23 在水一方

constructor TGameCheckThread.Create(suspend: Boolean);
begin
  FAllow := False;
  FErrmsg := '';
  inherited Create(suspend);
end;

procedure TGameCheckThread.Execute;
const
  c = 10;
var
  i, j, k, n, n0, n1, n2, n3, n4, n5, nn, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, s1, s2: integer;
  p: PMouseInfo;
  lastmsg: Byte;
  lastmsgtick: DWORD;
  lasttick: DWORD;
  lastchecktick: DWORD;
  lastchecktick2: DWORD;
  mi: array[0..c * 2 - 1] of TMouseInfo;
  parr: array of array of word;
  marr: array of array of word;
  prarr: array of array of word;
  mrarr: array of array of word;
  procedure SetCheckResult;
  begin
    GameCheckResult := Format('mi=%d; m1=%d; m2=%d; m3=%d; m4=%d; s1=%d; s2=%d', [(mmAnsTick - lasttick) div 100 div 60, m1, m2, m3, m4, s1, s2]);
  end;
  procedure SetCheckResult2;
  begin
    GameCheckResult := Format('%d;%d;%d;%d;%d;%d', [m5, m6, m7, m10, m8, m9]);
  end;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  FreeOnTerminate := true;
  //GameMenu := TGameMenu.Create;
  lastmsg := 255;
  lastmsgtick := mmAnsTick;
  lasttick := mmAnsTick;
  lastchecktick := mmAnsTick;
  lastchecktick2 := mmAnsTick;
  m1 := 0; m2 := 0; m3 := 0; m4 := 0; m5 := 0; m6 := 0; m7 := 0; m8 := 0; m9 := 0; m10 := 0; s1 := 0; s2 := 0;
  SetLength(parr, 1024 + 1, 768 + 1);
  SetLength(marr, 950 + 1, 950 + 1);
  SetLength(prarr, 1024 + 1, 768 + 1);
  SetLength(mrarr, 950 + 1, 950 + 1);

  while not Terminated do
  begin
    //if FAllow then
    if MsgArrWritePos <> MsgArrReadPos then
    begin
      if MsgArrWritePos >= MsgArrReadPos then
        n := MsgArrWritePos - MsgArrReadPos
      else
        n := MsgArrWritePos + (High(MouseMsgArr) - MsgArrWritePos) + 1;
      if n > c then begin
        for i := 0 to c - 1 do
          mi[i] := mi[i + c];
        for i := c to c * 2 - 1 do
        try
          p := popmousemsg;
          if p <> nil then begin
            mi[i] := p^;
            with p^ do
              if (msg = MouseLDnMsg) then begin
                if (x >= 0) and (x <= 1024) and (y >= 0) and (y <= 768) and (parr[x, y] < 65535) then
                  Inc(parr[x, y]);
                if (mx >= 0) and (mx <= 950) and (my >= 0) and (my <= 950) and (marr[mx, my] < 65535) then
                  Inc(marr[mx, my]);
              end
              else if (msg = MouseRDnMsg) then begin
                if (x >= 0) and (x <= 1024) and (y >= 0) and (y <= 768) and (prarr[x, y] < 65535) then
                  Inc(prarr[x, y]);
                if (mx >= 0) and (mx <= 950) and (my >= 0) and (my <= 950) and (mrarr[mx, my] < 65535) then
                  Inc(mrarr[mx, my]);
              end;
          end
          else Break;
          {with p^ do
          begin
            if (tick - lastmsgtick > 0) then //and (len/(tick - lastmsgtick))
            PostMessage(Application.Handle, WM_GAME_CHECK, len, (len div (tick - lastmsgtick)));
            //PostMessage(Application.Handle, WM_GAME_CHECK, MsgArrReadPos, MsgArrWritePos);
            lastmsg := msg;
            lastmsgtick := tick;
          end;}
        except
        end;
        if i >= c * 2 then begin
          n0 := 0; n1 := 0; n2 := 0; n3 := 0; n4 := 0; n5 := 0; nn := 0;
          for i := c to c * 2 - 1 do begin
            if mi[i].msg = MouseLDnMsg then m1 := m1 + 1;
            if mi[i].msg = MouseLDnMsg then m5 := m5 + 1;
            if mi[i].msg = MouseRDnMsg then m10 := m10 + 1;
            if mi[i].msg = MouseMoveMsg then m2 := m2 + 1;
            //if i > 0 then
            if (mi[i - 1].msg = MouseMoveMsg) and (mi[i].msg = MouseLDnMsg) and (mi[i].ivl > 500) then m3 := m3 + 1; //点击后不动5秒
            if mi[i].msg = MouseLDnMsg then n0 := n0 + 1;
            if mi[i].Len > 50 then n1 := n1 + 1;
            if mi[i].ivl <= 1 then n2 := n2 + 1;
            //if i > 0 then
            if (mi[i].spd = mi[i - 1].spd) and (mi[i].spd > 2) then n3 := n3 + 1;
            if {(i > 0) and}(mi[i].deg <> 0) then
              if mi[i].deg = mi[i - 1].deg then n4 := n4 + 1;
            if n4 >= c * 4 div 5 then m4 := m4 + 1; //轨迹检查
            if mi[i].spd > 100 then n5 := n5 + 1;
          end;
          if n3 >= c div 2 then s1 := s1 + 1; //匀速
          s2 := s2 + n5; //高速
          if n2 >= 3 then nn := nn + 1;
          if n3 >= 3 then nn := nn + 1;
          if n4 >= 3 then nn := nn + 1;
          nn := nn + n1 + n5;
          if (n0 = 0) or (n0 >= 3) then nn := 0;
          //if nn >= 2 then
          //  PostMessage(Application.Handle, WM_GAME_CHECK, MsgArrReadPos, MsgArrWritePos);
          if mmAnsTick - lastchecktick2 > 100 * 60 * 5 then begin //5分钟检查一次
            SetCheckResult;
            if (m1 > 50) and (m2 div m1 < 50) then begin //点击与移动比例 一般是1:100
              PostMessage(Application.Handle, WM_GAME_CHECK, 1, m2 div m1);
              sleep(1000);
            end;
            if (m3 > 50) then begin
              PostMessage(Application.Handle, WM_GAME_CHECK, 2, m3);
              sleep(1000);
            end;
            if (s1 > 1000) then begin
              PostMessage(Application.Handle, WM_GAME_CHECK, 3, s1);
              sleep(1000);
            end;
            if (s2 > 1000) then begin
              PostMessage(Application.Handle, WM_GAME_CHECK, 4, s2);
              sleep(1000);
            end;
            m6 := 0; m7 := 0; m8 := 0; m9 := 0;
            for j := 0 to 1024 do
              for k := 0 to 768 do
                if parr[j, k] > 0 then begin
                  inc(m6);
                  parr[j, k] := 0;
                end;
            for j := 0 to 950 do
              for k := 0 to 950 do
                if marr[j, k] > 0 then begin
                  inc(m7);
                  marr[j, k] := 0;
                end;
            for j := 0 to 1024 do
              for k := 0 to 768 do
                if prarr[j, k] > 0 then begin
                  inc(m8);
                  prarr[j, k] := 0;
                end;
            for j := 0 to 950 do
              for k := 0 to 950 do
                if mrarr[j, k] > 0 then begin
                  inc(m9);
                  mrarr[j, k] := 0;
                end;
            if (m5 > 100) or (m10 > 50) then begin
              SetCheckResult2;
              PostMessage(Application.Handle, WM_GAME_CHECK, 5, 0);
              sleep(1000);
              m5 := 0;
              m10 := 0;
            end;
            lastchecktick2 := mmAnsTick;
          end;
        end;
      end;
      //FAllow := false;
    end;
    if mmAnsTick - lasttick > 100 * 60 * 60 then begin //1小时清除一次
      m1 := 0; m2 := 0; m3 := 0; m4 := 0; s1 := 0; s2 := 0;
      lasttick := mmAnsTick;
    end;
    if mmAnsTick - lastchecktick > 100 * 60 * 15 then begin //15分钟检查一次
      SetCheckResult;
      PostMessage(Application.Handle, WM_GAME_CHECK, 0, 0); //回传检查结果
      sleep(1000);
      if FoundModuel('refs.dll|cfgdll.dll|Syntconv.dll', 3) <> '' then begin //按键精灵
        PostMessage(Application.Handle, WM_GAME_CHECK, 10, 0);
        sleep(1000);
      end;
      if FoundWizardWindow(nil, nil, nil) <> '' then begin //按键精灵,小精灵
        PostMessage(Application.Handle, WM_GAME_CHECK, 11, 0);
        sleep(1000);
      end;
      if FoundModuel('JdbbxTop.dll|Definition.dll|GuessYouLike.dll|Loading.dll', 4) <> '' then begin //简单游
        PostMessage(Application.Handle, WM_GAME_CHECK, 12, 0);
        sleep(1000);
      end;
      if FoundModuel('bbxcomm.dll|soundbox.dll', 2) <> '' then begin //简单游 工具
        PostMessage(Application.Handle, WM_GAME_CHECK, 12, 0);
        sleep(1000);
      end;
      if (ChkMouseX <> mouseX) or (ChkMouseY <> mouseY) then begin //发现内存修改鼠标信息
        PostMessage(Application.Handle, WM_GAME_CHECK, 13, 0);
        sleep(1000);
      end;
      lastchecktick := mmAnsTick;
    end;
    sleep(1);
  end;
{$I SE_PROTECT_END.inc}
end;



function FindMainWindow(h: HWND): HWND;
var
  hParent, hOwner: HWND;
begin
  hParent := h;
  repeat
    Result := hParent;
    hParent := Windows.GetParent(hParent);
  until hParent = 0;

  hOwner := Result;
  repeat
    Result := hOwner;
    hOwner := Windows.GetWindow(hOwner, GW_OWNER)
  until hOwner = 0
end;
end.

