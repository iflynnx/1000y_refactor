unit SVMain;

    //deftype umopsub uusersub deftype 有定义
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, inifiles, ExtCtrls,
  uAnsTick, uUser, uconnect, mapunit, fieldmsg, ulevelexp, deftype,
  svClass, basicobj, uMonster, uNpc, aUtil32, Spin, uGuild, Menus, ComCtrls,
  uLetter, uManager, uDoorGen, uhailfellow, AppEvnts, SubUtil, check, Encrypt,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdTCPServer, IdContext;

type

  TFrmMain = class(TForm)
    TimerProcess: TTimer;
    TimerDisplay: TTimer;
    TimerSave: TTimer;
    TimerClose: TTimer;
    SEProcessListCount: TSpinEdit;
    MainMenu1: TMainMenu;
    Files1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Env1: TMenuItem;
    LoadBadIpAndNotice1: TMenuItem;
    TimerRain: TTimer;
    MRain: TMenuItem;
    TimerRainning: TTimer;
    MConnection: TMenuItem;
    MDrop100: TMenuItem;
    MView: TMenuItem;
    MGate: TMenuItem;
    chkSaveUserData: TCheckBox;
    chkWeather: TCheckBox;
    MDelGuild: TMenuItem;
    Label1: TLabel;
    GroupBox_MAP: TGroupBox;
    SESelServer: TSpinEdit;
    Label2: TLabel;
    LbMonster: TLabel;
    GroupBox2: TGroupBox;
    LbConnection: TLabel;
    LbUser: TLabel;
    LbNpc: TLabel;
    LbItem: TLabel;
    LbProcess: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpinEditMoveTime: TSpinEdit;
    Label7: TLabel;
    ListBoxEvent: TListBox;
    SpinEditMaxExp: TSpinEdit;
    SpinEditAttackMagic: TSpinEdit;
    SpinEditBreathngMagic: TSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SpinEditRunningMagic: TSpinEdit;
    SpinEditProtectingMagic: TSpinEdit;
    SpinEditEctMagic: TSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    SEProcessListUserCount: TSpinEdit;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    log2: TMenuItem;
    CheckBox_speed: TCheckBox;
    N4: TMenuItem;
    N5: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    maptimer: TTimer;
    Edit1: TEdit;
    Label14: TLabel;
    Timer1: TTimer;
    Label15: TLabel;
    SpinEdit1: TSpinEdit;
    N6: TMenuItem;
    monstersdb1: TMenuItem;
    N7: TMenuItem;
    NPC1: TMenuItem;
    GM1: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    jnmax: TSpinEdit;
    Label16: TLabel;
    N11: TMenuItem;
    SpinEditVirtue: TSpinEdit;
    lbl1: TLabel;
    N12: TMenuItem;
    GroupBox_Users: TGroupBox;
    Label18: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    SEBan_Logid: TSpinEdit;
    SEBan_OutIP: TSpinEdit;
    SEBan_HCode: TSpinEdit;
    lblLaMaxstr: TLabel;
    LbMaxNum: TLabel;
    N13: TMenuItem;
    N14: TMenuItem;
    GroupBox1: TGroupBox;
    Label19: TLabel;
    SpinEditBfth: TSpinEdit;
    lbl2: TLabel;
    lblScript: TLabel;
    chktestcp: TCheckBox;
    SEMoveNormal: TSpinEdit;
    SEMoveRunning: TSpinEdit;
    SEMoveRunning2: TSpinEdit;
    chkwg: TCheckBox;
    CheckBox_Prison: TCheckBox;
    chkjihao: TCheckBox;
    SE_JF: TSpinEdit;
    lbl3: TLabel;
    lbl4: TLabel;
    SE_JMZ: TSpinEdit;
    CheckBox_cheat: TCheckBox;
    shpDbConnected: TShape;
    lbl5: TLabel;
    Label20: TLabel;
    shpNoticeConnected: TShape;
    SpinEditAge: TSpinEdit;
    Label17: TLabel;
    lbl6: TLabel;
    SEBan_LoginOver: TSpinEdit;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerProcessTimer(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure TimerSaveTimer(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure LoadBadIpAndNotice1Click(Sender: TObject);
    procedure SEProcessListCountChange(Sender: TObject);
    procedure TimerRainTimer(Sender: TObject);
    procedure MRainClick(Sender: TObject);
    procedure TimerRainningTimer(Sender: TObject);
    procedure MDrop100Click(Sender: TObject);
    procedure MGateClick(Sender: TObject);
    procedure MDelGuildClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure saveinix;
    procedure SpinEditMoveTimeChange(Sender: TObject);
    procedure SpinEditMaxExpChange(Sender: TObject);
    procedure SpinEditAttackMagicChange(Sender: TObject);
    procedure SpinEditBreathngMagicChange(Sender: TObject);
    procedure SpinEditRunningMagicChange(Sender: TObject);
    procedure SpinEditProtectingMagicChange(Sender: TObject);
    procedure SpinEditEctMagicChange(Sender: TObject);
    procedure SEProcessListUserCountChange(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure log2Click(Sender: TObject);
    procedure CheckBox_speedClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure maptimerTimer(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure monstersdb1Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure NPC1Click(Sender: TObject);
    procedure GM1Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure skillmaxChange(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure SpinEditVirtueChange(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure SEBan_LogidChange(Sender: TObject);
    procedure SEBan_OutIPChange(Sender: TObject);
    procedure SEBan_HCodeChange(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure SpinEditBfthChange(Sender: TObject);
    procedure chktestcpClick(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure SEMoveNormalChange(Sender: TObject);
    procedure chkwgClick(Sender: TObject);
    procedure CheckBox_PrisonClick(Sender: TObject);
    procedure chkjihaoClick(Sender: TObject);
    procedure SE_JFChange(Sender: TObject);
    procedure SE_JMZChange(Sender: TObject);
    procedure CheckBox_cheatClick(Sender: TObject);
    {procedure IdHTTPServer1CommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);}
    procedure SpinEditAgeChange(Sender: TObject);
    procedure SEBan_LoginOverChange(Sender: TObject);

  private
    BadIpStringList: TStringList;
    NoticeStringList: TStringList;
    RollMSGStringList: TStringList;
    CurNoticePosition: integer;
    RollMSGNOticePosition: integer;
    Rain: TSRainning;
  public
    ServerIni: TIniFile;
    boConnectRemote: Boolean;

    boCloseFlag: Boolean;
    boCloseCount: integer;
    boCloseState: integer;
    boCloseETime: integer;


    ProcessCount: integer;
    inteval: Integer;
    IniDate: string;
    IniHour: integer;
    EventStringList: TStringList;

    procedure AddEvent(aevent: string);
    procedure Logdrop(aStr: string);
    procedure WriteLogInfo(aStr: string);
    procedure WriteGameCheckLog(aStr: string);
        procedure WriteDumpInfo(aData: PChar; aSize: Integer);
  end;

var
  FrmMain: TFrmMain;

  BufferSize_GATE_RECE: Integer = 1048576;
  BufferSize_GATE_SEND: Integer = 1048576;

  BufferSize_USER_RECE: Integer = 65535;

  BufferSize_NOTICE_RECE: Integer = 65535;
  BufferSize_NOTICE_SEND: Integer = 65535;

  BufferSize_DB_RECE: Integer = 65535;
  BufferSize_DB_SEND: Integer = 65535;

  LoginID_Limit: Integer = 5;    //2015.11.25 在水一方
  OutIP_Limit: Integer = 5;
  HCode_Limit: Integer = 5;
  LoginOver_Limit: Integer = 30; //<<<<<<
  MoveNormal: Integer = 8;
  MoveRunning: Integer = 14;
  MoveRunning2: Integer = 20;

  CurrentDate: TDateTime;
  OldDate: string = '';
  RainTick: integer = 0;
  ad: string;
  head: string;
  FBLXZ: Boolean = False;
  check1: Boolean = False;
  check2: Boolean = False;
  checkwg: Boolean = True;
  checkjh: Boolean = True;
  JianFang: Integer = 0;
  JiaDuoShan: Integer = 0;
    //monstr:TStringList;
  blstr: TStringList;
  mnum: Integer = 0;


function logItemMoveInfo(atype: string; aSource, adest: pTBasicData; var aitem: titemdata; amapID: integer): Boolean;
function logMonsterdie(ahitname, aname, aitemlist: string; amapid, ax, ay: integer): Boolean;
function logEmporiaInfo(aCharName, aItemName: string; aCount, aPrice: integer): Boolean;
function logItemUpgrade(aCharName, aItemName: string; aOldLevel, aNewLevel: integer): Boolean;

procedure mapfun;
implementation

uses
  UTelemanagement, uUserSub, FSockets, FGate, uGConnect, uItemLog, uMarriage, uQuest, uEmail, uAuction, uProcession, uBillboardcharts, uEmporia,
  uComplex, ViewLog, frmEmail, frmAuction, Unit_console, uUserManager, uRandomManager;

{$R *.DFM}

function logEmporiaInfo(aCharName, aItemName: string; aCount, aPrice: integer): Boolean;
begin
  FrmSockets.UdpEmporiaInfoAddData(aCharName, aItemName, aCount, aPrice);
end;

function logItemUpgrade(aCharName, aItemName: string; aOldLevel, aNewLevel: integer): Boolean;
begin
  FrmSockets.UdpItemUpgradeAddData(aCharName, aItemName, aOldLevel, aNewLevel);
end;

function logMonsterdie(ahitname, aname, aitemlist: string; amapid, ax, ay: integer): Boolean;
begin
  FrmSockets.UdpMonsterdieAddData(ahitname, aname, aitemlist, amapid, ax, ay);
end;

function logItemMoveInfo(atype: string; aSource, adest: pTBasicData; var aitem: titemdata; amapID: integer): Boolean;
var
  aSourceIP, adestIP, aSourcestr, adeststr, aitemname: string;
  ax, ay: integer;
begin
  if aitem.rboLOG = false then exit;
  aSourceIP := '';
  adestIP := '';
  ax := 0;
  ay := 0;
  if aSource = nil then
  begin
    aSourcestr := '';
  end else
  begin
    ax := aSource.x;
    ay := aSource.y;
    case aSource.BasicObjectType of
      botNone: aSourcestr := '@NONE:' + aSource.Name;
      botNpc: aSourcestr := '@NPC:' + aSource.Name;
      botMonster: aSourcestr := '@怪物:' + aSource.Name;
      botUser:
        begin
          aSourcestr := '' + aSource.Name;
          aSourceIP := tuser(aSource.p).IP;
        end;
      botItemObject: aSourcestr := '@地上物品:' + aSource.Name;
      boDynamicObject: aSourcestr := '@动态物品:' + aSource.Name;
      boStaticItem: aSourcestr := '@禁态物品:' + aSource.Name;
      boMirrorObject: aSourcestr := '@boMirrorObject:' + aSource.Name;
      boGateObject: aSourcestr := '@boGateObject:' + aSource.Name;

      boDoorObject: aSourcestr := '@boDoorObject:' + aSource.Name;
      boSoundObj: aSourcestr := '@boSoundObj:' + aSource.Name;
      boItemGen: aSourcestr := '@boItemGen:' + aSource.Name;
      boObjectChecker: aSourcestr := '@boObjectChecker:' + aSource.Name;
      boGuildObject: aSourcestr := '@boGuildObject:' + aSource.Name;
      boLifeObject: aSourcestr := '@boLifeObject:' + aSource.Name;
      boGuildNpc: aSourcestr := '@boGuildNpc:' + aSource.Name;
    else aSourcestr := '@错误类:' + aSource.Name;
    end;
  end;
  if adest = nil then
  begin
    adeststr := '';
  end else
  begin
    if aSource = nil then
    begin
      ax := adest.x;
      ay := adest.y;
    end;
    case adest.BasicObjectType of
      botNone: adeststr := '@NONE:' + adest.Name;
      botNpc: adeststr := '@NPC:' + adest.Name;
      botMonster: adeststr := '@怪物:' + adest.Name;
      botUser:
        begin
          adeststr := '' + adest.Name;
          adestIP := tuser(adest.p).IP;
        end;
      botItemObject: adeststr := '@地上物品:' + adest.Name;
      boDynamicObject: adeststr := '@动态物品:' + adest.Name;
      boStaticItem: adeststr := '@禁态物品:' + adest.Name;
      boMirrorObject: adeststr := '@boMirrorObject:' + adest.Name;
      boGateObject: adeststr := '@boGateObject:' + adest.Name;
      boDoorObject: aSourcestr := '@boDoorObject:' + adest.Name;
      boSoundObj: aSourcestr := '@boSoundObj:' + adest.Name;
      boItemGen: aSourcestr := '@boItemGen:' + adest.Name;
      boObjectChecker: aSourcestr := '@boObjectChecker:' + adest.Name;
      boGuildObject: aSourcestr := '@boGuildObject:' + adest.Name;
      boLifeObject: aSourcestr := '@boLifeObject:' + adest.Name;
      boGuildNpc: aSourcestr := '@boGuildNpc:' + adest.Name;
    else aSourcestr := '@错误类:' + adest.Name;
    end;
  end;

  aitemname := aitem.rName;
  if aitem.rKind = ITEM_KIND_WEARITEM then
    aitemname := aitemname + ':' + IntToStr(aitem.rId);

  FrmSockets.UdpItemMoveInfoAddData(atype, aSourcestr, adeststr, aSourceIP, adestIP, amapID, ax, ay, aitemname, aitem.rCount);

end;

procedure TFrmMain.WriteLogInfo(aStr: string);
var
  Stream: TFileStream;
  tmpFileName: string;
  szBuf: array[0..1024] of Byte;
begin
  try
    StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
    tmpFileName := 'tgs1000.LOG';
    if FileExists(tmpFileName) then
      Stream := TFileStream.Create(tmpFileName, fmOpenReadWrite)
    else
      Stream := TFileStream.Create(tmpFileName, fmCreate);

    Stream.Seek(0, soFromEnd);
    Stream.WriteBuffer(szBuf, StrLen(@szBuf));
    Stream.Destroy;
  except
  end;
end;

procedure TFrmMain.WriteGameCheckLog(aStr: string);
var
  Stream: TFileStream;
  tmpFileName: string;
  szBuf: array[0..1024] of Byte;
begin
  try
    StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
    tmpFileName := 'GameCheck.LOG';
    if FileExists(tmpFileName) then
      Stream := TFileStream.Create(tmpFileName, fmOpenReadWrite)
    else
      Stream := TFileStream.Create(tmpFileName, fmCreate);

    Stream.Seek(0, soFromEnd);
    Stream.WriteBuffer(szBuf, StrLen(@szBuf));
    Stream.Destroy;
  except
  end;
end;

procedure TFrmMain.Logdrop(aStr: string);
var
  Stream: TFileStream;
  tmpFileName: string;
  szBuf: array[0..1024] of Byte;
begin
  try
    StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
    tmpFileName := 'Dropfile.LOG';
    if FileExists(tmpFileName) then
      Stream := TFileStream.Create(tmpFileName, fmOpenReadWrite)
    else
      Stream := TFileStream.Create(tmpFileName, fmCreate);

    Stream.Seek(0, soFromEnd);
    Stream.WriteBuffer(szBuf, StrLen(@szBuf));
    Stream.Destroy;
  except
  end;
end;

procedure TFrmMain.WriteDumpInfo(aData: PChar; aSize: Integer);
var
    Stream: TFileStream;
    tmpFileName: string;
    iCount: Integer;
begin
    try
        iCount := 0;
        while true do
        begin
            tmpFileName := 'DUMP' + IntToStr(iCount) + '.BIN';
            if not FileExists(tmpFileName) then break;
            iCount := iCount + 1;
        end;

        Stream := TFileStream.Create(tmpFileName, fmCreate);
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aData^, aSize);
        Stream.Destroy;
    except
    end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  cnt: integer;
  Manager: TManager;
begin
  inteval := 60 * 15 * 100; //存盘间隔  15分钟
  //monstr:=tstringlist.create;
  //monstr.LoadFromFile(ExtractFilePath(ParamStr(0))+'\monsterstr.txt');
  blstr := tstringlist.create;
  blstr.LoadFromFile(ExtractFilePath(ParamStr(0)) + '\blstr.txt');
  ad := '';

  tmlog := TsTMLogClass.Create('tmlog.dat');
  tmmoneylist := TsTMMoneyLogListClass.Create('tmlist.dat');

  CurrentDate := Date;

  SEProcessListCount.Value := ProcessListCount;
  EventStringList := TStringList.Create;

  boConnectRemote := FALSE;
  boCloseFlag := FALSE;

  Randomize;

  BadIpStringList := TStringList.Create;
  NoticeStringList := TStringList.Create;
  RollMSGStringList := tstringlist.Create;

  if not FileExists('.\sv1000.INI') then
  begin
    ServerINI := TIniFile.Create('.\sv1000.INI');

    try

      ServerINI.WriteInteger('SERVER', 'BufferSize_RECE', 4194304);
      ServerINI.WriteInteger('SERVER', 'BufferSize_SEND', 4194304);
      ServerINI.WriteInteger('SERVER', 'BufferSize_USER_RECE', 65535);
      ServerINI.WriteInteger('SERVER', 'ServerGateProt', 3052);

      ServerIni.WriteString('DB_SERVER', 'IPADDRESS', '127.0.0.1');
      ServerIni.WriteInteger('DB_SERVER', 'PORT', 3051);
      ServerINI.WriteInteger('DB_SERVER', 'BufferSize_RECE', 4194304);
      ServerINI.WriteInteger('DB_SERVER', 'BufferSize_SEND', 4194304);

      ServerIni.WriteString('NOTICE_SERVER', 'IPADDRESS', '127.1.0.1');
      ServerIni.WriteInteger('NOTICE_SERVER', 'PORT', 3090);
      ServerINI.WriteInteger('NOTICE_SERVER', 'BufferSize_RECE', 65535);
      ServerINI.WriteInteger('NOTICE_SERVER', 'BufferSize_SEND', 65535);

      ServerIni.WriteString('UDP_Receiver', 'IPADDRESS', '127.0.0.1');
      ServerIni.WriteInteger('UDP_Receiver', 'PORT', 6001);

      ServerIni.WriteString('BATTLE_SERVER', 'IPADDRESS', '127.0.0.1');
      ServerIni.WriteInteger('BATTLE_SERVER', 'PORT', 3040);
      ServerINI.WriteInteger('BATTLE_SERVER', 'BufferSize_RECE', 65535);
      ServerINI.WriteInteger('BATTLE_SERVER', 'BufferSize_SEND', 65535);

      ServerIni.WriteInteger('USER_MANAAGER', 'LoginID_Limit', 5);
      ServerINI.WriteInteger('USER_MANAAGER', 'OutIP_Limit', 5);
      ServerINI.WriteInteger('USER_MANAAGER', 'HCode_Limit', 5);
      ServerINI.WriteInteger('USER_MANAAGER', 'LoginOver_Limit', 30);
      ServerINI.WriteInteger('USER_MANAAGER', 'MoveNormal', 8);
      ServerINI.WriteInteger('USER_MANAAGER', 'MoveRunning', 14);
      ServerINI.WriteInteger('USER_MANAAGER', 'MoveRunning2', 20);
    finally

      ServerINI.Free;
    end;



  end;

  ServerINI := TIniFile.Create('.\sv1000.Ini');


  GameStartDateStr := DateToStr(EncodeDate(GameStartYear, GameStartMonth, GameStartDay));

  GameStartDateStr := ServerIni.ReadString('SERVER', 'GAMESTARTDATE', GameStartDateStr);
  GameCurrentDate := Round(Date - StrToDate(GameStartDateStr));

  Edit1.text := IntToStr(ServerINI.ReadInteger('SERVER', 'bulletin', 300000));
  spinEdit1.value := ServerINI.readInteger('SERVER', 'skill', 1);
  //  spinEdit2.value:=ServerINI.readInteger('SERVER', 'bb',  10000 );
  jnmax.value := ServerINI.readInteger('SERVER', 'skillmax', 20);
  BufferSize_GATE_RECE := ServerINI.ReadInteger('SERVER', 'BufferSize_RECE', 1048576);
  BufferSize_GATE_SEND := ServerINI.ReadInteger('SERVER', 'BufferSize_SEND', 1048576);

  BufferSize_USER_RECE := ServerINI.ReadInteger('SERVER', 'BufferSize_USER_RECE', 65535);


  ServerGateProt := ServerINI.ReadInteger('SERVER', 'ServerGateProt', 3052);

  cnt := ServerINI.ReadInteger('DATABASE', 'COUNT', 0);
  Inc(cnt);
  ServerINI.WriteInteger('DATABASE', 'COUNT', cnt);

  IniDate := ServerINI.ReadString('DATABASE', 'DATE', '');
  IniHour := ServerINI.ReadInteger('DATABASE', 'HOUR', 0);

  Udp_Receiver_IpAddress := ServerIni.ReadString('UDP_Receiver', 'IPADDRESS', '127.0.0.1');
  Udp_Receiver_Port := ServerIni.ReadInteger('UDP_Receiver', 'PORT', 6001);

    {Udp_Item_IpAddress := ServerIni.ReadString('UDP_ITEM', 'IPADDRESS', '127.0.0.1');
    Udp_Item_Port := ServerIni.ReadInteger('UDP_ITEM', 'PORT', 6001);

    Udp_MouseEvent_IpAddress := ServerIni.ReadString('UDP_MOUSEEVENT', 'IPADDRESS', '127.0.0.1');
    Udp_MouseEvent_Port := ServerIni.ReadInteger('UDP_MOUSEEVENT', 'PORT', 6 001);

    Udp_Moniter_IpAddress := ServerIni.ReadString('UDP_MONITER', 'IPADDRESS', '127.0.0.1');
    Udp_Moniter_Port := ServerIni.ReadInteger('UDP_MONITER', 'PORT', 6000);

    Udp_Connect_IpAddress := ServerIni.ReadString('UDP_CONNECT', 'IPADDRESS', '127.0.0.1');
    Udp_Connect_Port := ServerIni.ReadInteger('UDP_CONNECT', 'PORT', 6022);
    }
  DBServerIPAddress := ServerIni.ReadString('DB_SERVER', 'IPADDRESS', '127.0.0.1');
  DBServerPort := ServerIni.ReadInteger('DB_SERVER', 'PORT', 3051);
  BufferSize_DB_RECE := ServerINI.ReadInteger('DB_SERVER', 'BufferSize_RECE', 65535);
  BufferSize_DB_SEND := ServerINI.ReadInteger('DB_SERVER', 'BufferSize_SEND', 65535);



  NoticeServerIpAddress := ServerIni.ReadString('NOTICE_SERVER', 'IPADDRESS', '127.1.0.1');
  NoticeServerPort := ServerIni.ReadInteger('NOTICE_SERVER', 'PORT', 3090);
  BufferSize_NOTICE_RECE := ServerINI.ReadInteger('NOTICE_SERVER', 'BufferSize_RECE', 65535);
  BufferSize_NOTICE_SEND := ServerINI.ReadInteger('NOTICE_SERVER', 'BufferSize_SEND', 65535);

  BattleServerIPAddress := ServerIni.ReadString('BATTLE_SERVER', 'IPADDRESS', '127.0.0.1');
  BattleServerPort := ServerIni.ReadInteger('BATTLE_SERVER', 'PORT', 3040);

  LoginID_Limit := ServerIni.ReadInteger('USER_MANAAGER', 'LoginID_Limit', 5); //2015.11.25 在水一方
  OutIP_Limit := ServerIni.ReadInteger('USER_MANAAGER', 'OutIP_Limit', 5);
  HCode_Limit := ServerIni.ReadInteger('USER_MANAAGER', 'HCode_Limit', 5);
  SEBan_LoginOver.Value := ServerIni.ReadInteger('USER_MANAAGER', 'LoginOver_Limit', 30);  //<<<<<<
  SEMoveNormal.Value := ServerIni.ReadInteger('USER_MANAAGER', 'MoveNormal', 8);
  SEMoveRunning.Value := ServerIni.ReadInteger('USER_MANAAGER', 'MoveRunning', 14);
  SEMoveRunning2.Value := ServerIni.ReadInteger('USER_MANAAGER', 'MoveRunning2', 20);
  MoveNormal := ServerIni.ReadInteger('USER_MANAAGER', 'MoveNormal', 8);
  MoveRunning := ServerIni.ReadInteger('USER_MANAAGER', 'MoveRunning', 14);
  MoveRunning2 := ServerIni.ReadInteger('USER_MANAAGER', 'MoveRunning2', 20);

  ManagerList := TManagerList.Create;
  ManagerList.LoadFromFile('.\Init\MAP.SDB');

  SESelServer.MaxValue := ManagerList.Count - 1;

  GateConnectorList := TGateConnectorList.Create;

  ConnectorList := TConnectorList.Create;
  UserList := TUserList.Create(100);

  GuildList := TGuildList.Create;
  HailFellowList := tHailFellowList.Create;
  ProcessionclassList := TProcessionclassList.Create;
  GateList := TGateList.Create;
  GroupMoveLIST := TGroupMoveList.Create;
  MirrorList := TMirrorList.Create;
  EmporiaClass := TEmporiaClass.Create;
  ComplexClass := TComplexClass.Create;
    //排行
  BillboardchartsEnergy := TBillboardcharts.Create('.\Billboardcharts\Energy.sdb', bctEnergy);
  BillboardchartsPrestige := TBillboardcharts.Create('.\Billboardcharts\Prestige.sdb', bctPrestige);
  BillboardchartsnewTalent := TBillboardcharts.Create('.\Billboardcharts\newTalent.sdb', bctnewTalent);
  G_BillboardGuilds := TBillboardGuilds.Create('.\Billboardcharts\BillboardGuilds.sdb');
  GuildList.getBillboard;
  G_BillboardGuilds.SaveToFile('.\Billboardcharts\BillboardGuilds.sdb');
  //  Billboardcharts3h := TBillboardcharts.Create('.\Billboardcharts\3h.sdb', bctPrestige);
  SoundObjList := TSoundObjList.Create;

  Manager := ManagerList.GetManagerByTitle('狐狸洞');

  ItemGen := TItemGen.Create;
  ItemGen.SetManagerClass(Manager);
  ItemGen.Initial('ItemGen', '生肉', 100, 84);
  ItemGen.StartProcess;

  {  Manager := ManagerList.GetManagerByTitle('修炼洞');

{    ObjectChecker := TObjectChecker.Create;
    ObjectChecker.SetManagerClass(Manager);
    ObjectChecker.Initial('ObjectChecker', 26, 28);
    ObjectChecker.StartProcess;
 }
    // LetterManager := TLetterManager.Create(7, 1000, 'UserLetter.TXT');

  TimerProcess.Interval := 10;
  TimerProcess.Enabled := TRUE;

  SpinEditVirtue.Value := ServerIni.ReadInteger('FORM', 'SpinEditVirtue', 1); //浩然
  SpinEditBfth.Value := ServerIni.ReadInteger('FORM', 'SpinEditBfth', 200); //步法弹回
  SE_JF.Value := ServerIni.ReadInteger('FORM', 'JianFang', 0); //减防
  SE_JMZ.Value := ServerIni.ReadInteger('FORM', 'JiaDuoShan', 0); //加命中


  SpinEditMaxExp.Value := ServerIni.ReadInteger('FORM', 'SpinEditMaxExp', 1);
  SpinEditAttackMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditAttackMagic', 1);
  SpinEditBreathngMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditBreathngMagic', 1);
  SpinEditRunningMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditRunningMagic', 1);
  SpinEditProtectingMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditProtectingMagic', 1);
  SpinEditEctMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditEctMagic', 1);
  SpinEditAge.value := ServerINI.readInteger('FORM', 'SpinEditAge', 1); //年龄经验

  SEProcessListCount.Value := ServerIni.ReadInteger('FORM', 'SEProcessListCount', 40); //2015.11.25 在水一方 >>>>>>
  SEProcessListUserCount.Value := ServerIni.ReadInteger('FORM', 'SEProcessListUserCount', 40);
  SpinEditMoveTime.Value := ServerIni.ReadInteger('FORM', 'SpinEditMoveTime', 15);

  SEBan_Logid.Value := LoginID_Limit;
  SEBan_OutIP.Value := OutIP_Limit;
  SEBan_HCode.Value := HCode_Limit; 
  LoginOver_Limit := ServerIni.ReadInteger('USER_MANAAGER', 'LoginOver_Limit', 30); //2015.11.25 在水一方 <<<<<<
  try
    Timer1.Interval := StrToInt(Edit1.text);
  except
    Timer1.Interval := 30000;
  end;
  Timer1.Enabled := True;
  //

//  if INI_WEBPORT > 0 then
//  begin
//    //加载IdHTTPServer1
//    try
//      IdHTTPServer1.Bindings.Clear;
//      //要绑定的端口，一定设置此项，这是真正要绑定的端口;
//      IdHTTPServer1.DefaultPort := INI_WEBPORT;
//      IdHTTPServer1.Bindings.Add.IP := INI_WEBIP;
//      //启动服务器
//      IdHTTPServer1.Active := True;
//    except
//      WriteLogInfo('HTTP启动失败！');
//    end;
//  end;
//  SetWebLuaScript; //读取WebScript
     //新增重读脚本
    //uaScripterList.ReLoadFromFile;
  WriteLogInfo('GameServer Started');
end;

procedure tfrmmain.saveinix;
begin
  ServerIni.WriteInteger('FORM', 'SpinEditVirtue', SpinEditVirtue.Value); //浩然
  ServerIni.WriteInteger('FORM', 'SpinEditBfth', SpinEditBfth.Value); //步法弹回
  ServerIni.WriteInteger('FORM', 'JianFang', SE_JF.Value); //减防
  ServerIni.WriteInteger('FORM', 'JiaDuoShan', SE_JMZ.Value); //加命中

  ServerIni.WriteInteger('FORM', 'SpinEditMaxExp', SpinEditMaxExp.Value);
  ServerIni.WriteInteger('FORM', 'SpinEditAttackMagic', SpinEditAttackMagic.Value);
  ServerIni.WriteInteger('FORM', 'SpinEditBreathngMagic', SpinEditBreathngMagic.Value);
  ServerIni.WriteInteger('FORM', 'SpinEditRunningMagic', SpinEditRunningMagic.Value);
  ServerIni.WriteInteger('FORM', 'SpinEditProtectingMagic', SpinEditProtectingMagic.Value);
  ServerIni.WriteInteger('FORM', 'SpinEditEctMagic', SpinEditEctMagic.Value);
  ServerIni.WriteInteger('FORM', 'SpinEditAge', SpinEditAge.Value);

  ServerIni.WriteInteger('FORM', 'SEProcessListCount', SEProcessListCount.Value);
  ServerIni.WriteInteger('FORM', 'SEProcessListUserCount', SEProcessListUserCount.Value);
  ServerIni.WriteInteger('FORM', 'SpinEditMoveTime', SpinEditMoveTime.Value);
  ServerIni.WriteInteger('USER_MANAAGER', 'MoveNormal', SEMoveNormal.Value);
  ServerIni.WriteInteger('USER_MANAAGER', 'MoveRunning', SEMoveRunning.Value);
  ServerIni.WriteInteger('USER_MANAAGER', 'MoveRunning2', SEMoveRunning2.Value);
  ServerIni.WriteInteger('USER_MANAAGER', 'LoginOver_Limit', SEBan_LoginOver.Value);

end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin

  WriteLogInfo('GameServer Exit');

  saveinix;

  TimerProcess.Enabled := false;
  TimerSave.Enabled := false;
  TimerDisplay.Enabled := false;

  tmmoneylist.Free;
  tmlog.Free;
     //monstr.Free;
  blstr.free;
  SoundObjList.Free;

//    ObjectChecker.EndProcess;
  //  ObjectChecker.Free;

  ItemGen.EndProcess;
  ItemGen.Free;

    //LetterManager.Free;

  MirrorList.Free;
  GateList.Free;
  GroupMoveLIST.Free;
  GuildList.Free;
  HailFellowList.Free;

  UserList.free;
  ConnectorList.free;
  GateConnectorList.Free;
  ManagerList.Free;
  ProcessionclassList.Free;

  ServerINI.Free;
  NoticeStringList.Free;
  RollMSGStringList.Free;
  BadIpStringList.Free;
  EventStringList.Free;
  BillboardchartsEnergy.Free;
  BillboardchartsPrestige.Free;
  BillboardchartsnewTalent.Free;
  G_BillboardGuilds.Free;
    //   Billboardcharts3h.Free;
  EmporiaClass.Free;
  ComplexClass.Free;
end;

procedure TFrmMain.AddEvent(aevent: string);
begin
  EventStringList.Add(aevent);
end;

procedure TFrmMain.TimerSaveTimer(Sender: TObject);

var
  i, n: integer;
  Str: string;
  usd: TStringData;
  Manager: TManager;
  nYear, nMonth, nDay: Word;
begin
  if TimerClose.Enabled = true then exit;

  str := TimeToStr(Time);
  if OldDate <> DateToStr(Date) then
  begin
    OldDate := DateToStr(Date);
    GameCurrentDate := Round(Date - StrToDate(GameStartDateStr));
//        NameStringListForDeleteMagic.Clear;

  end;

    { if Date <> CurrentDate then
     begin
         DecodeDate(CurrentDate, nYear, nMonth, nDay);
         Str := '.\ItemLog\Backup\ItemLog';
         Str := Str + IntToStr(nYear) + '-';
         if nMonth < 10 then Str := Str + '0';
         Str := Str + IntToStr(nMonth) + '-';
         if nDay < 10 then Str := Str + '0';
         Str := Str + IntToStr(nDay) + '.SDB';
         ItemLog.SaveToSDB(Str);

         CurrentDate := Date;
     end;
     }
  if Pos('AM', str) > 0 then GrobalLightDark := gld_dark
  else GrobalLightDark := gld_light;




//  if NoticeStringList.Count > 0 then
//  begin
//    if CurNoticePosition >= NoticeStringList.Count then CurNoticePosition := 0;
//    UserList.SendNoticeMessage(NoticeStringList[CurNoticePosition], SAY_COLOR_NOTICE);
//    inc(CurNoticePosition);
//  end;
//  if RollMSGStringList.Count > 0 then
//  begin
//    if RollMSGNOticePosition >= RollMSGStringList.Count then RollMSGNOticePosition := 0;
//    UserList.SendRollMSG(ColorSysToDxColor($0000FF00), RollMSGStringList[RollMSGNOticePosition]);
//    inc(RollMSGNOticePosition);
//  end;

  n := GetCPUStartHour;
  if n <> IniHour then
  begin
    IniHour := n;
    ServerIni.WriteInteger('DATABASE', 'HOUR', n);
        // GuildList.CompactGuild;
    GuildList.SaveToFile('.\Guild\CreateGuild.SDB');

    //todo: 16.6.6  重新计算门派排行
    GuildList.getBillboard;
    HailFellowList.SaveToFile('.\HailFellow\HailFellow.SDB');
  end;

    //  usd.rmsg := 1;
     // SetWordString(usd.rWordString, IntToStr(UserList.Count));
     // n := sizeof(TStringData) - sizeof(TWordString) + sizeofwordstring(usd.rwordstring);
     //记录 在线人数
  FrmSockets.UdpMoniterAddData(IntToStr(UserList.Count) + ',');
end;

procedure TFrmMain.TimerCloseTimer(Sender: TObject);
var
  i: integer;
begin
  case boCloseState of
    0:
      begin
        boCloseCount := 0;
        boCloseState := 10;
                //1分钟后关闭

        boCloseETime := GetTickCount + 60000;
      end;
    10:
      begin
          //通告
        i := boCloseETime - GetTickCount;
        if i <= 0 then
        begin
          boCloseFlag := true;
          UserList.SendNoticeMessage(format('<服务器停机公告>正常停机。', []), SAY_COLOR_NOTICE);
          boCloseState := 20;
          exit;
        end;
        i := i div 1000;
        UserList.SendNoticeMessage(format('<服务器停机公告>%d秒后停机，避免数据丢失，请玩家下线。', [i]), SAY_COLOR_NOTICE);
      end;
    20:
      begin
        UserList.SendNoticeMessage(format('<服务器停机公告>停机中...', []), SAY_COLOR_NOTICE);
        ConnectorList.CloseConnect(10);
        if UserList.Count = 0 then
        begin
          boCloseState := 30;
        end;
      end;
    30:
      begin
        if (UserList.Count = 0) and (ConnectorList.Count = 0) and (ConnectorList.GetSaveListCount = 0) then
        begin
          TimerClose.Interval := 5000;
          boCloseState := 40;
        end;
      end;
    40:
      begin
        boCloseState := 50;
        Close;
      end;
  else
    begin

    end;
  end;
     {
    if (UserList.Count = 0) and (ConnectorList.Count = 0) and (ConnectorList.GetSaveListCount = 0) then
    begin
        if TimerClose.Interval = 1000 then
        begin
            TimerClose.Interval := 5000;
            exit;
        end;

    end else
    begin
        ConnectorList.CloseAllConnect;
    end;
    }
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin

  boCloseState := 0;

  TimerClose.Interval := 1000;
  TimerClose.Enabled := TRUE;
   //2015.11.10 在水一方 内存泄露002 此处代码重复
   {saveinix;

    TimerProcess.Enabled := false;
    TimerSave.Enabled := false;
    TimerDisplay.Enabled := false;

    tmmoneylist.Free;
    tmlog.Free;

    SoundObjList.Free;

//    ObjectChecker.EndProcess;
  //  ObjectChecker.Free;

    ItemGen.EndProcess;
    ItemGen.Free;

    //LetterManager.Free;

    MirrorList.Free;
    GateList.Free;
    GroupMoveLIST.Free;
    GuildList.Free;
    HailFellowList.Free;

    UserList.free;
    ConnectorList.free;
    GateConnectorList.Free;
    ManagerList.Free;
    ProcessionclassList.Free;

    ServerINI.Free;
    NoticeStringList.Free;
    RollMSGStringList.Free;
    BadIpStringList.Free;
    EventStringList.Free;
    BillboardchartsEnergy.Free;
    BillboardchartsPrestige.Free;
    BillboardchartsnewTalent.Free;
    //   Billboardcharts3h.Free;
    EmporiaClass.Free;
    WriteLogInfo('GameServer Exit'); }

  //  ExitProcess(0);

end;

procedure TFrmMain.LoadBadIpAndNotice1Click(Sender: TObject);
begin
  if FileExists('BadIpAddr.txt') then BadIpStringList.LoadFromFile('BadIpAddr.txt');
  if FileExists('Notice.txt') then NoticeStringList.LoadFromFile('Notice.txt');
  if FileExists('RollMSG.txt') then RollMSGStringList.LoadFromFile('RollMSG.txt');

  Udp_Item_IpAddress := ServerIni.ReadString('UDP_ITEM', 'IPADDRESS', '127.0.0.1');
  Udp_Item_Port := ServerIni.ReadInteger('UDP_ITEM', 'PORT', 6001);

  Udp_MouseEvent_IpAddress := ServerIni.ReadString('UDP_MOUSEEVENT', 'IPADDRESS', '127.0.0.1');
  Udp_MouseEvent_Port := ServerIni.ReadInteger('UDP_MOUSEEVENT', 'PORT', 6001);

  Udp_Moniter_IpAddress := ServerIni.ReadString('UDP_MONITER', 'IPADDRESS', '127.0.0.1');
  Udp_Moniter_Port := ServerIni.ReadInteger('UDP_MONITER', 'PORT', 6000);

  Udp_Connect_IpAddress := ServerIni.ReadString('UDP_CONNECT', 'IPADDRESS', '127.0.0.1');
  Udp_Connect_Port := ServerIni.ReadInteger('UDP_CONNECT', 'PORT', 6022);

  NoticeServerIpAddress := ServerIni.ReadString('NOTICE_SERVER', 'IPADDRESS', '127.0.0.1');
  NoticeServerPort := ServerIni.ReadInteger('NOTICE_SERVER', 'PORT', 5999);

  frmSockets.ReConnectNoticeServer(NoticeServerIPAddress, NoticeServerPort);

  CurNoticePosition := 0;

  LoadGameIni('.\game.ini');
end;

procedure TFrmMain.SEProcessListCountChange(Sender: TObject);
begin
  ProcessListCount := SEProcessListCount.Value;
end;

procedure TFrmMain.TimerDisplayTimer(Sender: TObject);
var
  str: string;
  Manager: TManager;
begin
  while TRUE do
  begin
    if EventStringList.Count = 0 then break;
    str := EventStringList[0];
    EventStringList.Delete(0);
    if ListBoxEvent.Items.Count > 5 then ListboxEvent.Items.Delete(0);
    ListBoxEvent.Items.add(str);
  end;

  LbProcess.Caption := 'P:' + IntToStr(processcount);
  ProcessCount := 0;

  if ConnectorList <> nil then
    LbConnection.Caption := '连接:' + IntToStr(ConnectorList.Count);
  if UserList <> nil then
  begin
    LbUser.Caption := '用户:' + IntToStr(UserList.Count);
    if UserList.Count > StrToIntDef(LbMaxNum.Caption, 0) then
      LbMaxNum.Caption := IntToStr(UserList.Count);
  end;

  if ManagerList <> nil then
  begin
    Manager := ManagerList.GetManagerByIndex(SeSelServer.Value);
    if Manager <> nil then
    begin
      GroupBox_MAP.Caption := Manager.Title;
      LbItem.Caption := IntToStr(TItemList(Manager.ItemList).Count);

      if Manager.MonsterList <> nil then LbMonster.Caption := IntToStr(TMonsterList(Manager.MonsterList).Count);
      LbNpc.Caption := IntToStr(TNpcList(Manager.NpcList).Count);
    end;
  end;

  lblScript.Caption := IntToStr(LuaScripterList.GetScripnum);
end;

procedure TFrmMain.TimerProcessTimer(Sender: TObject);
var
  CurTick: integer;
begin
  CurTick := mmAnsTick;

  GateConnectorList.Update(CurTick);

  PrisonClass.Update(CurTick);

  ConnectorList.Update(CurTick);
  UserList.Update(CurTick);

  if boCloseFlag = false then
  begin
    ManagerList.Update(CurTick);
  end;
    //配套系统-----------------------------------
  GuildList.Update(CurTick); //门派       1秒
  //HailFellowList.Update(CurTick); //好友      1秒
   // marriedlist.Update(curtick);                                                //婚姻系统   1 秒
   // Marriage.Update(curtick);                                                   //结婚仪式   1 秒
  //  Questreglist.Update(CurTick);                                               //任务注册系统  60秒
   // EmailList.Update(curtick);                                                  //邮件    60秒
  NEWEmailIDClass.Update(curtick);
  NEWAuctionidClass.Update(curtick);
//    NEWItemIDClass.Update(curtick);
  AuctionSystemClass.Update(curtick);
  ProcessionclassList.Update(curtick);
    //-------------------------------------------
  GateList.Update(CurTick);
  GroupMoveLIST.Update(CurTick);
  MirrorList.Update(CurTick);

  ItemGen.Update(CurTick);
//    ObjectChecker.Update(CurTick);

  SoundObjList.Update(CurTick);

  inc(ProcessCount);
end;

procedure TFrmMain.TimerRainTimer(Sender: TObject);
var
  nYear, nMonth, nDay: Word;
  nHour, nMin, nSec, nMSec: Word;
  boSnow: boolean;
begin
  if chkWeather.Checked = false then exit;

  try
    DecodeDate(Date, nYear, nMonth, nDay);
    DecodeTime(Time, nHour, nMin, nSec, nMSec);
  except
    exit;
  end;

  boSnow := true;
  if (nMonth > 3) and (nMonth < 11) then
  begin
    boSnow := false;
  end else if (nMonth = 3) or (nMonth = 11) then
  begin
    if Random(10) > 2 then
    begin
      boSnow := false;
    end;
  end;

  if boSnow = false then
  begin
    Rain.rmsg := SM_RAINNING;
    Rain.rspeed := 10;
    Rain.rCount := 200;
    Rain.rOverray := 50;
    Rain.rTick := 600;
    Rain.rRainType := RAINTYPE_RAIN;
  end else
  begin
    Rain.rmsg := SM_RAINNING;
    Rain.rspeed := 1;
    Rain.rCount := 200;
    Rain.rOverray := 20;
    Rain.rTick := 600;
    Rain.rRainType := RAINTYPE_SNOW;
  end;

  TimerRainning.Enabled := TRUE;
end;

procedure TFrmMain.MRainClick(Sender: TObject);
begin
  TimerRainTimer(Self);
end;

procedure TFrmMain.TimerRainningTimer(Sender: TObject);

var
  SendCount: Integer;
begin
  if chkWeather.Checked = false then exit;

    // Speed, Count, Overray, Tick
  UserList.SendRaining(Rain);

  SendCount := 20;
  if Rain.rRainType = RAINTYPE_SNOW then SendCount := 60;
  RainTick := RainTick + 1;
  if RainTick > SendCount then
  begin
    RainTick := 0;
    TimerRainning.Enabled := FALSE;
  end;
end;

procedure TFrmMain.MDrop100Click(Sender: TObject);
begin
    //
end;

procedure TFrmMain.MGateClick(Sender: TObject);
begin
  frmGate.Show;
end;

procedure TFrmMain.MDelGuildClick(Sender: TObject);
begin
    //
  GuildList.CompactGuild;
end;

procedure TFrmMain.FormActivate(Sender: TObject);
begin
  LoadBadIpAndNotice1Click(Self);
end;

procedure TFrmMain.Save1Click(Sender: TObject);
begin
  Inteval := 1000;

   //  EmailList.DBsave;                                                           //保存 所有 邮件
  //   AuctionSystemClass.DBsave;
end;


{                    背包锁     物品琐    禁止交易（和人交易）    禁止丢弃（丢地上）   禁止出售（NPC交易）  禁止寄存（仓库）
0，NPC购买           |NO        |NO       |YES                    |YES                  |YES                |YES
1，NPC出售           |NO        |NO       |NO                     |YES                  |NO                 |YES
2，邮寄              |NO        |NO       |NO                     |YES                  |YES                |YES
3，丢弃              |NO        |NO       |YES                    |NO                   |YES                |YES
4，寄售              |NO        |NO       |NO                     |YES                  |YES                |YES
5，精炼              |NO        |NO       |YES                    |YES                  |YES                |YES
6，镶嵌              |NO        |NO       |YES                    |YES                  |YES                |YES
7，取消镶嵌宝石      |NO        |NO       |YES                    |YES                  |YES                |YES
8，仓库              |NO        |NO       |YES                    |YES                  |YES                |NO
9，玩家交易          |NO        |NO       |NO                     |YES                  |YES                |YES
}

procedure TFrmMain.SpinEditMoveTimeChange(Sender: TObject);
begin
  VarMoveSpeedTime := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditMaxExpChange(Sender: TObject);
begin
  vAddMagicExp_MaxExp := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditAttackMagicChange(Sender: TObject);
begin
  vAddMagicExp_AttackMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditBreathngMagicChange(Sender: TObject);
begin
  vAddMagicExp_BreathngMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditRunningMagicChange(Sender: TObject);
begin
  vAddMagicExp_RunningMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditProtectingMagicChange(Sender: TObject);
begin
  vAddMagicExp_ProtectingMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditEctMagicChange(Sender: TObject);
begin
  vAddMagicExp_EctMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SEProcessListUserCountChange(Sender: TObject);
begin
  ProcessListUserCount := SEProcessListUserCount.Value;
end;

procedure TFrmMain.N1Click(Sender: TObject);
var
  FormEmail: TFormEmail;
begin
  FormEmail := TFormEmail.Create(Self);
  try
    FormEmail.ShowModal;
  finally
    FormEmail.Free;
  end;

end;

procedure TFrmMain.N2Click(Sender: TObject);
var
  FormAuction: TFormAuction;
begin
  FormAuction := TFormAuction.Create(Self);
  try
    FormAuction.ShowModal;
  finally
    FormAuction.Free;
  end;

end;

procedure TFrmMain.log2Click(Sender: TObject);
begin
  FrmConsole.Show;
end;

procedure TFrmMain.CheckBox_speedClick(Sender: TObject);
begin
  boCheckSpeed := CheckBox_speed.Checked;
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
//
  ManagerList.SaveFileCsv;

end;

procedure TFrmMain.N5Click(Sender: TObject);
begin
  UserList.ClearMagicDelCount;
end;

procedure TFrmMain.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  WriteLogInfo('错误信息: ' + e.Message);
end;

procedure mapfun;
var
  xx: TStringList;
  i, remain, regen: Integer;
  map: string;
  ttTManager: TManager;
begin
  if not FileExists(extractfilepath(ParamStr(0)) + '\Setting\map.sdb') then Exit;
  try
    xx := TStringList.Create;
    xx.LoadFromFile(extractfilepath(ParamStr(0)) + '\Setting\map.sdb');
    for i := 0 to xx.Count - 1 do
    begin
      map := xx.Strings[i];
      ttTManager := ManagerList.GetManagerByTitle(map);
      if ttTManager <> nil then
      begin
        remain := ttTManager.RemainMin;
        regen := ttTManager.RegenInterval div 6000;
        if regen - remain = 1 then worldnoticemsg(map + ' ' + inttostr(regen) + '分开启一次，现已开启，剩余' + inttostr(5 + remain - regen) + '分可进入 ', $000080FF, 0);
 // if regen-remain<5 then worldnoticemsg(map+' '+'已开启，剩余'+inttostr(5+remain-regen)+'分可进入', $000080FF, 0);
        if remain = 5 then worldnoticemsg(map + ' ' + inttostr(remain) + '分钟后开启 ', $000080FF, 0);
      end;
    end;
  finally
    FreeAndNil(xx);
  end;
end;

procedure TFrmMain.maptimerTimer(Sender: TObject);
begin
 // mapfun;
end;

procedure TFrmMain.Edit1Change(Sender: TObject);
begin
  ServerINI.WriteInteger('SERVER', 'bulletin', StrToInt(Edit1.Text));
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  //if not check1 then ExitProcess(0);//暗桩1
  if NoticeStringList.Count > 0 then
  begin
    if CurNoticePosition >= NoticeStringList.Count then CurNoticePosition := 0;
    UserList.SendNoticeMessage(NoticeStringList[CurNoticePosition], SAY_COLOR_NOTICE);
    inc(CurNoticePosition);
  end;
  if RollMSGStringList.Count > 0 then
  begin
    if RollMSGNOticePosition >= RollMSGStringList.Count then RollMSGNOticePosition := 0;
    UserList.SendRollMSG(ColorSysToDxColor($0000FF00), RollMSGStringList[RollMSGNOticePosition]);
    inc(RollMSGNOticePosition);
  end;
end;

procedure TFrmMain.SpinEdit1Change(Sender: TObject);
begin
  try
    ServerINI.WriteInteger('SERVER', 'skill', spinEdit1.value);
  except
    ServerINI.WriteInteger('SERVER', 'skill', 1);
  end;
end;



procedure TFrmMain.monstersdb1Click(Sender: TObject);
begin
  ItemClass.ReLoadFromFile; //item重载
end;

procedure TFrmMain.N7Click(Sender: TObject);
begin
//ScripterList.ReLoadFromFile;  //脚本代码重载
  LuaScripterList.ReLoadFromFile;
end;

procedure TFrmMain.NPC1Click(Sender: TObject);
begin
  NpcClass.ReLoadFromFile; //NPC重载
end;

procedure TFrmMain.GM1Click(Sender: TObject);
begin
  SysopClass.ReLoadFromFile; //GM重载
end;

procedure TFrmMain.N8Click(Sender: TObject);
begin
  MagicClass.ReLoadFromFile; //武功重载
  PosByDieClass.ReLoadFromFile; //死亡出现地图重载
  DynamicObjectClass.ReLoadFromFile; //动态刷新重载
  ItemDrugClass.ReLoadFromFile; //药物重载
  MonsterClass.ReLoadFromFile; //怪物重载
  MapPathList.ReLoadFromFile; //地图重载
end;

procedure TFrmMain.N10Click(Sender: TObject);
begin
  frmLog.Show;
end;

procedure TFrmMain.skillmaxChange(Sender: TObject);
begin
  try
    ServerINI.WriteInteger('SERVER', 'skillmax', jnmax.value);
  except
    ServerINI.WriteInteger('SERVER', 'skillmax', 20);
  end;
end;

procedure TFrmMain.N11Click(Sender: TObject);
begin
//monstr.Clear;
//monstr.LoadFromFile(ExtractFilePath(ParamStr(0))+'\monsterstr.txt');
end;

procedure TFrmMain.SpinEditVirtueChange(Sender: TObject);
begin
  vAddVirtueExp := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.N12Click(Sender: TObject); //2015.11.25 在水一方
begin
  FrmUserManager.show;
end;

procedure TFrmMain.SEBan_LogidChange(Sender: TObject); //2015.11.25 在水一方
begin
  LoginID_Limit := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SEBan_OutIPChange(Sender: TObject); //2015.11.25 在水一方
begin
  OutIP_Limit := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SEBan_HCodeChange(Sender: TObject); //2015.11.25 在水一方
begin
  HCode_Limit := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.N13Click(Sender: TObject);
begin
  FrmRandomManager.show;
end;

procedure TFrmMain.N14Click(Sender: TObject);
begin
  ComplexClass.loadFile;
end;

procedure TFrmMain.SpinEditBfthChange(Sender: TObject);
begin
  vBfth := SpinEditBfth.Value;
end;

procedure TFrmMain.chktestcpClick(Sender: TObject);
begin
  boCheckTestYd := chktestcp.Checked;
end;

procedure TFrmMain.N15Click(Sender: TObject);
begin
  EmporiaClass.loadFile;
  JobUpgradeClass.loadfile;
end;

procedure TFrmMain.SEMoveNormalChange(Sender: TObject);
begin
  case TSpinEdit(Sender).Tag of
    0:
      MoveNormal := TSpinEdit(Sender).Value;
    1:
      MoveRunning := TSpinEdit(Sender).Value;
    2:
      MoveRunning2 := TSpinEdit(Sender).Value;
  end;
end;


procedure TFrmMain.chkwgClick(Sender: TObject);
begin
  checkwg := chkwg.Checked;
end;

procedure TFrmMain.CheckBox_PrisonClick(Sender: TObject);
begin
  boCheckSpeedPrison := CheckBox_Prison.Checked;

end;

procedure TFrmMain.chkjihaoClick(Sender: TObject);
begin
  checkjh := chkjihao.Checked;
end;

procedure TFrmMain.SE_JFChange(Sender: TObject);
begin
  JianFang := SE_JF.Value;
end;

procedure TFrmMain.SE_JMZChange(Sender: TObject);
begin
  JiaDuoShan := SE_JMZ.Value;
end;

procedure TFrmMain.CheckBox_cheatClick(Sender: TObject);
begin
  boCheckCheat := CheckBox_cheat.Checked;
end;

{procedure TFrmMain.IdHTTPServer1CommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  i, n: Integer; 
  Name, Value, Query, Document, Content: string;
begin
  //未开启连接退出
  if not IdHTTPServer1.Active then exit;
  //参数为0退出
  //if ARequestInfo.Params.Count = 0 then exit;
  Query := '';
  n := ARequestInfo.Params.Count - 1;
  for i := 0 to n do
  begin
    Name := UTF8Decode(ARequestInfo.Params.Names[i]);
    Value := UTF8Decode(ARequestInfo.Params.Values[Name]);
    Query := Query + Name + '=' + Value;
    if i < n then Query := Query + '&';
  end;
  Document := UTF8Decode(ARequestInfo.Document);
  Content := CallWebLuaScriptFunction('CommandGet', [Document, Query, ARequestInfo.RemoteIP]);
  AResponseInfo.ContentText := utf8encode(Content);
end; }

//procedure TFrmMain.IdHTTPServer1CommandGet(AContext: TIdContext;
//  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
//var
//  i, n: Integer; 
//  Name, Value, Query, Document, Content: string;
//begin
//  //未开启连接退出
//  if not IdHTTPServer1.Active then exit;
//  //参数为0退出
//  //if ARequestInfo.Params.Count = 0 then exit;
//  Query := '';
//  n := ARequestInfo.Params.Count - 1;
//  for i := 0 to n do
//  begin
//    Name := UTF8Decode(ARequestInfo.Params.Names[i]);
//    Value := UTF8Decode(ARequestInfo.Params.Values[Name]);
//    Query := Query + Name + '=' + Value;
//    if i < n then Query := Query + '&';
//  end;
//  Document := UTF8Decode(ARequestInfo.Document);
//  Content := CallWebLuaScriptFunction('CommandGet', [Document, Query, ARequestInfo.RemoteIP]);
//  AResponseInfo.ContentText := utf8encode(Content);
//end;


procedure TFrmMain.SpinEditAgeChange(Sender: TObject);
begin
  vAge_Exp := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SEBan_LoginOverChange(Sender: TObject);
begin
  LoginOver_Limit := TSpinEdit(Sender).Value;
end;

end.

