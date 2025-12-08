unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, ComCtrls, ExtCtrls, IniFiles, mmSystem, uBuffer, NMUDP,
  uPackets, DefType, Spin;

type
  TVillageData = record
    Name: string[64];
    X: Integer;
    Y: Integer;
    ServerID: Integer;
  end;
  PTVillageData = ^TVillageData;

  TfrmMain = class(TForm)
    pgMain: TPageControl;
    tsStatus: TTabSheet;
    tsEvent: TTabSheet;
    lstEvent: TListBox;
    tsLog: TTabSheet;
    txtLog: TMemo;
    sckUserAccept: TServerSocket;
    timerDisplay: TTimer;
    StaticText1: TStaticText;
    shpGameConnected: TShape;
    shpDBConnected: TShape;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    lblConnectCount: TStaticText;
    lblPlayCount: TStaticText;
    lblLogCount: TStaticText;
    lblConnectID: TStaticText;
    StaticText11: TStaticText;
    lblElaspedTime: TStaticText;

        // sckGameConnect: TClientSocket;
    sckDBConnect: TClientSocket;
    sckLoginConnect: TClientSocket;
    shpLoginConnected: TShape;
    StaticText7: TStaticText;
    timerProcess: TTimer;
    tsBufferStatus: TTabSheet;
    Label1: TLabel;
    lblGameSendBytes: TLabel;
    Label2: TLabel;
    lblGameRecvBytes: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblDBSendBytes: TLabel;
    Label8: TLabel;
    lblDBRecvBytes: TLabel;
    Label10: TLabel;
    lblLoginSendBytes: TLabel;
    Label12: TLabel;
    lblLoginRecvBytes: TLabel;
    Label3: TLabel;
    lblGameWBCount: TLabel;
    Label7: TLabel;
    lblDBWBCount: TLabel;
    Label11: TLabel;
    lblLoginWBCount: TLabel;
    shpGameWBSign: TShape;
    Label9: TLabel;
    shpDBWBSign: TShape;
    Label13: TLabel;
    shpLoginWBSign: TShape;
    Label14: TLabel;
    sckGameConnect: TClientSocket;
    timerClose: TTimer;
    sckPaidConnect: TClientSocket;
    shpPaidConnected: TShape;
    StaticText8: TStaticText;
    sckBalanceConnect: TClientSocket;
    StaticText9: TStaticText;
    shpBalanceConnected: TShape;
    TabSheet1: TTabSheet;
    MemoLog: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    chkUserAccept: TCheckBox;
    cmdClose: TButton;
    TabSheet2: TTabSheet;
    SpinEdit1: TSpinEdit;
    Label16: TLabel;
    Button2: TButton;
    Button3: TButton;
    chkyzz: TCheckBox;
    SpinUserCount: TSpinEdit;
    Label15: TLabel;
    StaticText10: TStaticText;
    lblCCAttack: TStaticText;
    btnClearNoPlayer: TButton;
    chkcc: TCheckBox;
    btnlogin: TButton;
    chkzf: TCheckBox;
    procedure cmdCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sckUserAcceptAccept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckUserAcceptClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckUserAcceptClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckUserAcceptClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckUserAcceptClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckUserAcceptClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure timerDisplayTimer(Sender: TObject);
    procedure sckDBConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckDBConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckDBConnectError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckDBConnectRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckDBConnectWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckLoginConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckLoginConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckLoginConnectError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckLoginConnectRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckLoginConnectWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure timerProcessTimer(Sender: TObject);
    procedure sckGameConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGameConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGameConnectError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckGameConnectRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGameConnectWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure timerCloseTimer(Sender: TObject);
    procedure sckPaidConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckPaidConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckPaidConnectError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckPaidConnectRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckPaidConnectWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBalanceConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBalanceConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBalanceConnectError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckBalanceConnectRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBalanceConnectWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpinUserCountChange(Sender: TObject);
    procedure btnClearNoPlayerClick(Sender: TObject);
    procedure btnloginClick(Sender: TObject);
    procedure chkzfClick(Sender: TObject);
  private

        { Private declarations }
    CCAttack: integer;
  public
        { Public declarations }
    procedure AddLog(aStr: string);
    procedure AddEvent(aStr: string);

    function UpdateServer(CurTick: Integer): Boolean;
    procedure WriteLog(aStr: string);
  end;

var
  frmMain: TfrmMain;

  StartTick, ElaspedSec: DWORD;
  BalanceSendTick: DWORD = 0;

  RejectCharName: TStringList;

  ServerName: string;
  LimitUserCount: Integer;


  BufferSize_TGS_Rece: integer;
  BufferSize_TGS_Send: integer;

  BufferSize_db_Rece: integer;
  BufferSize_db_Send: integer;

  BufferSize_LOGIN_Rece: integer;
  BufferSize_LOGIN_Send: integer;

  BufferSize_Paid_Rece: integer;
  BufferSize_Paid_Send: integer;

  BufferSize_BA_Rece: integer;
  BufferSize_BA_Send: integer;

  BufferSize_GATE_Rece: integer;
  BufferSize_GATE_Send: integer;


  UserAcceptInfo, GameConnectInfo, DBConnectInfo, LoginConnectInfo: TConnectInfo;
  BalanceConnectInfo, PaidConnectInfo: TConnectInfo;

  VillageList: TList;

  GameSender, DBSender, LoginSenderx, PaidSender: TPacketSender;
  GameReceiver, DBReceiver, LoginReceiverx, PaidReceiver: TPacketReceiver;
  BalanceSender: TPacketSender;
  BalanceReceiver: TPacketReceiver;
  CreateDBRecord0, CreateDBRecord1: TDBRecord;
implementation

uses
  uConnector, uExequatur, Unit_console;

{$R *.DFM}

procedure TfrmMain.WriteLog(aStr: string);
var
  Stream: TFileStream;
  FileName: string;
  buffer: array[0..65535 - 1] of byte;
begin
  try
    FileName := '.\GATE.Log';
    if FileExists(FileName) then
    begin
      Stream := TFileStream.Create(FileName, fmOpenReadWrite);
    end else
    begin
      Stream := TFileStream.Create(FileName, fmCreate);
    end;
    try
      aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer(aStr[1], LENGTH(aStr));
    finally
      Stream.Free;
    end;
  except
  end;
end;

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
  if Application.MessageBox('Do you want to exit program?', 'GATE SERVER', MB_OKCANCEL) <> ID_OK then exit;

  if ConnectorList <> nil then
  begin
    ConnectorList.Free;
    ConnectorList := nil;
  end;

  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i, nCount: Integer;
  iniFile: TIniFile;
  pd: PTVillageData;
  tempfile: TFileStream;
begin

  CCAttack := 0;
  AddLog('Gate Server Started ' + DateToStr(Date) + ' ' + TimeToStr(Time));
  WriteLog('Gate Server Started ' + DateToStr(Date) + ' ' + TimeToStr(Time));
  AddLog(inttostr(sizeof(TDBRecord)));
  FillChar(CreateDBRecord0, SizeOf(TDBRecord), 0);
  if FileExists('.\男号.dat') then
  begin
    tempfile := TFileStream.Create('.\男号.dat', fmOpenRead);
    try
      if tempfile.Size = SizeOf(TDBRecord) then
      begin
        tempfile.Position := 0;
        tempfile.ReadBuffer(CreateDBRecord0, SizeOf(TDBRecord));
      end;
    finally
      tempfile.Free;
    end;

  end;
  FillChar(CreateDBRecord1, SizeOf(TDBRecord), 0);
  if FileExists('.\女号.dat') then
  begin
    tempfile := TFileStream.Create('.\女号.dat', fmOpenRead);
    try
      if tempfile.Size = SizeOf(TDBRecord) then
      begin
        tempfile.Position := 0;
        tempfile.ReadBuffer(CreateDBRecord1, SizeOf(TDBRecord));
      end;
    finally
      tempfile.Free;
    end;

  end;
  ElaspedSec := 0;
  StartTick := timeGetTime;

  VillageList := TList.Create;

  RejectCharName := TStringList.Create;
  if FileExists('.\DONTCHAR.TXT') then
  begin
    RejectCharName.LoadFromFile('.\DONTCHAR.TXT');
  end;

  if not FileExists('.\GATE.INI') then
  begin
    iniFile := TIniFile.Create('.\GATE.INI');
    iniFile.WriteInteger('SERVER', 'LIMITUSERCOUNT', 200);
    iniFile.WriteString('SERVER', 'CHECKPAIDINFO', 'TRUE');
    iniFile.WriteString('SERVER', 'SERVERNAME', '千年');

    iniFile.WriteString('SERVER', 'LOCALIP', '127.0.0.1');
    iniFile.WriteInteger('SERVER', 'LOCALPORT', 3054);
    iniFile.WriteInteger('SERVER', 'BufferSize_Rece', 65535);
    iniFile.WriteInteger('SERVER', 'BufferSize_Send', 65535);


    iniFile.WriteString('TGS_SERVER', 'REMOTEIP', '127.0.0.1');
    iniFile.WriteInteger('TGS_SERVER', 'REMOTEPORT', 3052);
    iniFile.WriteInteger('TGS_SERVER', 'BufferSize_Rece', 4194304);
    iniFile.WriteInteger('TGS_SERVER', 'BufferSize_Send', 4194304);

    iniFile.WriteString('DB_SERVER', 'REMOTEIP', '127.0.0.1');
    iniFile.WriteInteger('DB_SERVER', 'REMOTEPORT', 3051);
    iniFile.WriteInteger('DB_SERVER', 'BufferSize_Rece', 4194304);
    iniFile.WriteInteger('DB_SERVER', 'BufferSize_Send', 4194304);


    iniFile.WriteString('LOGIN_SERVER', 'REMOTEIP', '127.0.0.1');
    iniFile.WriteInteger('LOGIN_SERVER', 'REMOTEPORT', 5000);
    iniFile.WriteInteger('LOGIN_SERVER', 'BufferSize_Rece', 1048576);
    iniFile.WriteInteger('LOGIN_SERVER', 'BufferSize_Send', 1048576);


    iniFile.WriteString('PAID_SERVER', 'REMOTEIP', '127.0.0.1');
    iniFile.WriteInteger('PAID_SERVER', 'REMOTEPORT', 5999);
    iniFile.WriteInteger('PAID_SERVER', 'BufferSize_Rece', 65535);
    iniFile.WriteInteger('PAID_SERVER', 'BufferSize_Send', 65535);


    iniFile.WriteString('BA_SERVER', 'BALANCEIP', '127.0.0.1');
    iniFile.WriteInteger('BA_SERVER', 'BALANCEPORT', 3080);
    iniFile.WriteInteger('BA_SERVER', 'BufferSize_Rece', 65535);
    iniFile.WriteInteger('BA_SERVER', 'BufferSize_Send', 65535);

    iniFile.Free;
  end;

  iniFile := TIniFile.Create('.\GATE.INI');

  try

    ServerName := iniFile.ReadString('SERVER', 'SERVERNAME', '土豆');
    LimitUserCount := iniFile.ReadInteger('SERVER', 'LIMITUSERCOUNT', 200);
    SpinUserCount.Value := LimitUserCount;
                                                     
    TCheckBox(chkzf).Checked := iniFile.ReadBool('INI_CONFIG', TCheckBox(chkzf).Name, false);
    UserAcceptInfo.RemoteIP := iniFile.ReadString('SERVER', 'LOCALIP', '127.0.0.1');
    UserAcceptInfo.LocalPort := iniFile.ReadInteger('SERVER', 'LOCALPORT', 3054);
    BufferSize_GATE_Rece := iniFile.ReadInteger('SERVER', 'BufferSize_Rece', 65535);
    BufferSize_GATE_Send := iniFile.ReadInteger('SERVER', 'BufferSize_SEND', 65535);

    GameConnectInfo.RemoteIP := iniFile.ReadString('TGS_SERVER', 'REMOTEIP', '127.0.0.1');
    GameConnectInfo.RemotePort := iniFile.ReadInteger('TGS_SERVER', 'REMOTEPORT', 3052);
    BufferSize_TGS_Rece := iniFile.ReadInteger('TGS_SERVER', 'BufferSize_Rece', 4194304);
    BufferSize_TGS_Send := iniFile.ReadInteger('TGS_SERVER', 'BufferSize_SEND', 4194304);


    DBConnectInfo.RemoteIP := iniFile.ReadString('DB_SERVER', 'REMOTEIP', '127.0.0.1');
    DBConnectInfo.RemotePort := iniFile.ReadInteger('DB_SERVER', 'REMOTEPORT', 3051);
    BufferSize_db_Rece := iniFile.ReadInteger('DB_SERVER', 'BufferSize_Rece', 4194304);
    BufferSize_db_Send := iniFile.ReadInteger('DB_SERVER', 'BufferSize_SEND', 4194304);

    LoginConnectInfo.RemoteIP := iniFile.ReadString('LOGIN_SERVER', 'REMOTEIP', '127.0.0.1');
    LoginConnectInfo.RemotePort := iniFile.ReadInteger('LOGIN_SERVER', 'REMOTEPORT', 5000);
    BufferSize_LOGIN_Rece := iniFile.ReadInteger('LOGIN_SERVER', 'BufferSize_Rece', 65535);
    BufferSize_LOGIN_Send := iniFile.ReadInteger('LOGIN_SERVER', 'BufferSize_SEND', 65535);

    PaidConnectInfo.RemoteIP := iniFile.ReadString('PAID_SERVER', 'REMOTEIP', '127.0.0.1');
    PaidConnectInfo.RemotePort := iniFile.ReadInteger('PAID_SERVER', 'REMOTEPORT', 3049);
    BufferSize_Paid_Rece := iniFile.ReadInteger('PAID_SERVER', 'BufferSize_Rece', 65535);
    BufferSize_Paid_Send := iniFile.ReadInteger('PAID_SERVER', 'BufferSize_SEND', 65535);

    BalanceConnectInfo.RemoteIP := iniFile.ReadString('BA_SERVER', 'BALANCEIP', '127.0.0.1');
    BalanceConnectInfo.RemotePort := iniFile.ReadInteger('BA_SERVER', 'BALANCEPORT', 3080);
    BufferSize_BA_Rece := iniFile.ReadInteger('BA_SERVER', 'BufferSize_Rece', 65535);
    BufferSize_BA_Send := iniFile.ReadInteger('BA_SERVER', 'BufferSize_SEND', 65535);
  finally
    iniFile.Free;
  end;


  if not FileExists('.\Village.INI') then
  begin
    iniFile := TIniFile.Create('.\Village.INI');
    try
      iniFile.WriteInteger('VILLAGE', 'COUNT', 5);
      for i := 0 to 5 - 1 do
      begin
        iniFile.WriteString('VILLAGE', 'NAME' + IntToStr(i), '书生村' + inttostr(i));
        iniFile.WriteInteger('VILLAGE', 'X' + IntToStr(i), 513);
        iniFile.WriteInteger('VILLAGE', 'Y' + IntToStr(i), 205);
        iniFile.WriteInteger('VILLAGE', 'ServerID' + IntToStr(i), 0);
      end;


    finally
      iniFile.Free;
    end;

  end;
  iniFile := TIniFile.Create('.\Village.INI');
  try
    nCount := iniFile.ReadInteger('VILLAGE', 'COUNT', 1);
    for i := 0 to nCount - 1 do
    begin
      New(pd);
      pd^.Name := iniFile.ReadString('VILLAGE', 'NAME' + IntToStr(i), '书生村');
      pd^.X := iniFile.ReadInteger('VILLAGE', 'X' + IntToStr(i), 513);
      pd^.Y := iniFile.ReadInteger('VILLAGE', 'Y' + IntToStr(i), 205);
      pd^.ServerID := iniFile.ReadInteger('VILLAGE', 'ServerID' + IntToStr(i), 0);
      VillageList.Add(pd);
    end;

  finally
    iniFile.Free;
  end;

  GameSender := nil;
  GameReceiver := nil;
  DBSender := nil;
  DBReceiver := nil;
  LoginSenderx := nil;
  LoginReceiverx := nil;
  PaidSender := nil;
  PaidReceiver := nil;
  BalanceSender := nil;
  BalanceReceiver := nil;

  ConnectorList := TConnectorList.Create;

  chkUserAccept.Checked := true;

  sckUserAccept.Port := UserAcceptInfo.LocalPort;
  sckUserAccept.Active := true;

  sckGameConnect.Address := GameConnectInfo.RemoteIP;
  sckGameConnect.Port := GameConnectInfo.RemotePort;
  sckGameConnect.Active := true;

  sckDBConnect.Address := DBConnectInfo.RemoteIP;
  sckDBConnect.Port := DBConnectInfo.RemotePort;
  sckDBConnect.Active := true;

 {   sckLoginConnect.Address := DBConnectInfo.RemoteIP;
    sckLoginConnect.Port := DBConnectInfo.RemotePort;
    sckLoginConnect.Active := true;
                                     }
  sckLoginConnect.Address := LoginConnectInfo.RemoteIP;
  sckLoginConnect.Port := LoginConnectInfo.RemotePort;
  sckLoginConnect.Active := true;

  sckPaidConnect.Address := PaidConnectInfo.RemoteIP;
  sckPaidConnect.Port := PaidConnectInfo.RemotePort;
  sckPaidConnect.Active := true;

  sckBalanceConnect.Address := BalanceConnectInfo.RemoteIP;
  sckBalanceConnect.Port := BalanceConnectInfo.RemotePort;
  sckBalanceConnect.Active := true;

  timerDisplay.Interval := 3000;
  timerDisplay.Enabled := true;

  timerProcess.Interval := 10;
  timerProcess.Enabled := true;

  timerClose.Enabled := false;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
  pd: PTVillageData;
begin
  WriteLog('Gate Server exit ' + DateToStr(Date) + ' ' + TimeToStr(Time));
  for i := 0 to VillageList.Count - 1 do
  begin
    pd := VillageList.Items[i];
    Dispose(pd);
  end;
  VillageList.Clear;
  VillageList.Free;

  if ConnectorList <> nil then
  begin
    ConnectorList.Free;
    ConnectorList := nil;
  end;

  if sckGameConnect.Socket.Connected = true then
  begin
    sckGameConnect.Socket.Close;
  end;
  if sckDBConnect.Socket.Connected = true then
  begin
    sckDBConnect.Socket.Close;
  end;
  if sckLoginConnect.Socket.Connected = true then
  begin
    sckLoginConnect.Socket.Close;
  end;
  if sckUserAccept.Active = true then
  begin
    sckUserAccept.Socket.Close;
  end;
  timerDisplay.Enabled := false;
  timerProcess.Enabled := false;

  if GameSender <> nil then
  begin
    GameSender.Free;
    GameSender := nil;
  end;
  if GameReceiver <> nil then
  begin
    GameReceiver.Free;
    GameReceiver := nil;
  end;

  if DBSender <> nil then
  begin
    DBSender.Free;
    DBSender := nil;
  end;
  if DBReceiver <> nil then
  begin
    DBReceiver.Free;
    DBReceiver := nil;
  end;
  if LoginSenderx <> nil then
  begin
    LoginSenderx.Free;
    LoginSenderx := nil;
  end;
  if LoginReceiverx <> nil then
  begin
    LoginReceiverx.Free;
    LoginReceiverx := nil;
  end;

  RejectCharName.Clear;
  RejectCharName.Free;

  AddLog('Gate Server Exit ' + DateToStr(Date) + ' ' + TimeToStr(Time));
end;

procedure TfrmMain.AddLog(aStr: string);
begin
  if txtLog.Lines.Count >= 30 then
  begin
    txtLog.Lines.Delete(0);
  end;
  txtLog.Lines.Add(aStr);
end;

procedure TfrmMain.AddEvent(aStr: string);
begin
  if lstEvent.Items.Count >= 30 then
  begin
    lstEvent.Items.Delete(0);
  end;
  lstEvent.Items.Add(aStr);
  lstEvent.ItemIndex := lstEvent.Items.Count - 1;
end;
{
--------------------------------------
----------TGS连接---------------------
--------------------------------------
<<<<<<<<<<<GATE------TGS1000>>>>>>>>>>
======收包========
GameReceiver.PutData              <存入缓冲区>
======处理包======
TfrmMain.UpdateServer             <定时处理>
GameReceiver.Update;              <1,分割包>
GameReceiver.GetPacket            <2,提出包>
ConnectorList.GameMessageProcess  <3,处理包>
======发送========
GameSender.PutPacket              <存入缓冲区>
======处理包======
TfrmMain.UpdateServer             <定时处理>
GameSender.Update;                <发送 出去>

--------------------------------------
----------DB连接---------------------
--------------------------------------
<<<<<<<<<<<GATE------DB>>>>>>>>>>
DBReceiver                        <接收 缓冲区>
DBSender                          <发送 缓冲区>
ConnectorList.DBMessageProcess    <处理收包>

--------------------------------------
----------login连接---------------------
--------------------------------------
<<<<<<<<<<<GATE------login>>>>>>>>>>
LoginReceiver                        <接收 缓冲区>
LoginSender                          <发送 缓冲区>
ConnectorList.LoginMessageProcess    <处理收包>

}

procedure TfrmMain.timerProcessTimer(Sender: TObject);
var
  CurTick: Cardinal;
  Packet: TPacketData;
begin
  CurTick := timeGetTime; // 1000


     //TGS1000发送 接收包
     //1，发送沉郁包
  if GameSender <> nil then GameSender.Update;
    //2，卸载TGS过来的包
  if GameReceiver <> nil then
  begin
   // if GameReceiver.ReceiveBufferCount > 0 then
    begin
      GameReceiver.Update;
      while GameReceiver.Count > 0 do
      begin
        if GameReceiver.GetPacket(@Packet) = false then break;
        ConnectorList.GameMessageProcess(@Packet);
      end;
    end;
  end;
    //2，发送和卸载用户包
  ConnectorList.Update(CurTick);
    //3，发送
  if GameSender <> nil then GameSender.Update;

    //DB.exe  发送
  if DBSender <> nil then DBSender.Update;
    //DB。EXE 收
  if DBReceiver <> nil then
  begin
    DBReceiver.Update;
    while DBReceiver.Count > 0 do
    begin
      if DBReceiver.GetPacket(@Packet) = false then break;
      ConnectorList.DBMessageProcess(@Packet);
    end;
  end;

  if LoginSenderx <> nil then LoginSenderx.Update;
  if LoginReceiverx <> nil then
  begin
    LoginReceiverx.Update;
    while LoginReceiverx.Count > 0 do
    begin
      if LoginReceiverx.GetPacket(@Packet) = false then break;
      ConnectorList.LoginMessageProcess(@Packet);
    end;
  end;

  if PaidSender <> nil then PaidSender.Update;
  if PaidReceiver <> nil then
  begin
    PaidReceiver.Update;
    while PaidReceiver.Count > 0 do
    begin
      if PaidReceiver.GetPacket(@Packet) = false then break;
      ConnectorList.PaidMessageProcess(@Packet);
    end;
  end;

  if BalanceSender <> nil then BalanceSender.Update;
  if BalanceReceiver <> nil then
  begin
    BalanceReceiver.Update;
    while BalanceReceiver.Count > 0 do
    begin
      if BalanceReceiver.GetPacket(@Packet) = false then break;
      ConnectorList.BalanceMessageProcess(@Packet);
    end;
  end;

end;

function TfrmMain.UpdateServer(CurTick: Integer): Boolean;

begin

  Result := true;
end;

procedure TfrmMain.sckUserAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
var
  pExequatur: pTExequaturdata;
begin
  if chkcc.Checked then
  begin
    pExequatur := ConnectorList.ExequaturList.GetIP(Socket.RemoteAddress);
    if pExequatur = nil then begin //2016.07.09 在水一方
      //WriteLog(format(Socket.RemoteAddress + ' 不接受连接(疑似攻击) [%d]',[Integer(Socket)]));
      Inc(CCAttack);
      Socket.Close;
      exit;
    end;
  end;

  if chkUserAccept.Checked = true then
  begin
    AddEvent(Socket.RemoteAddress + ' Connected');
    if ConnectorList.CreateConnect(Socket) = true then exit;
  end;
  Socket.Close;
end;

procedure TfrmMain.sckUserAcceptClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//if  socket.RemoteAddress<>'127.0.0.1' then Socket.Close;     //
//AddEvent(Socket.RemoteAddress + ' Connected ' + Name);
  //WriteLog(format(Socket.RemoteAddress + ' Connected [%d]', [Integer(Socket)]));
end;

procedure TfrmMain.sckUserAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Name: string;
begin
  Name := ConnectorList.DeleteConnect(Socket);

  AddEvent(Socket.RemoteAddress + ' DisConnected ' + Name);
end;

procedure TfrmMain.sckUserAcceptClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
  Name: string;
begin
  AddEvent(Socket.RemoteAddress + ' Error' + inttostr(ErrorCode));

  Name := ConnectorList.DeleteConnect(Socket); //test
  WriteLog(format('%s Error %d Socket %d [%s]', [Socket.RemoteAddress, ErrorCode, Integer(Socket), Name])); //test
  ErrorCode := 0;
  Socket.Close;
end;

procedure TfrmMain.sckUserAcceptClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..65535 - 1] of byte;
  Name: string;
begin
  nRead := Socket.ReceiveBuf(buffer, 65535);
  if nRead > 0 then
  begin
    if ConnectorList.AddReceiveData(Socket, @buffer, nRead) = false then
    begin
      Name := ConnectorList.DeleteConnect(Socket); //2016.04.08 在水一方
      WriteLog(format('TfrmMain.sckUserAcceptClientRead；ConnectorList.AddReceiveData失败[%s][%d]', [Name, Integer(Socket)]));
      Socket.Close;
    end;
    exit;
  end;
end;

procedure TfrmMain.sckUserAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ConnectorList.SetWriteAllow(Socket);
end;

procedure TfrmMain.timerDisplayTimer(Sender: TObject);
var
  CurTick: DWORD;
    //   wbColor : TColor;

  BalanceData: TGateInfo;
begin
  if sckGameConnect.Socket.Connected = false then
  begin
    shpGameConnected.Brush.Color := clRed;
    sckGameConnect.Socket.Close;
    sckGameConnect.Active := true;
  end else
  begin
    shpGameConnected.Brush.Color := clLime;
  end;

  if sckDBConnect.Active = false then
  begin
    shpDBConnected.Brush.Color := clRed;
    sckDBConnect.Socket.Close;
    sckDBConnect.Active := true;
  end else
  begin
    shpDBConnected.Brush.Color := clLime;
  end;

  if sckBalanceConnect.Active = false then
  begin
    shpBalanceConnected.Brush.Color := clRed;
    sckBalanceConnect.Socket.Close;
    sckBalanceConnect.Active := true;
  end else
  begin
    shpBalanceConnected.Brush.Color := clLime;
  end;

  if sckLoginConnect.Active = false then
  begin
    shpLoginConnected.Brush.Color := clRed;
    sckLoginConnect.Socket.Close;
    sckLoginConnect.Active := true;
  end else
  begin
    shpLoginConnected.Brush.Color := clLime;
  end;

  if sckPaidConnect.Active = false then
  begin
    shpPaidConnected.Brush.Color := clRed;
    sckPaidConnect.Socket.Close;
    sckPaidConnect.Active := true;
  end else
  begin
    shpPaidConnected.Brush.Color := clLime;
  end;
    //1秒刷新一次
  CurTick := timeGetTime;
  if CurTick >= StartTick + 1000 then
  begin
    ElaspedSec := ElaspedSec + 1;
    StartTick := CurTick;
  end;

  lblElaspedTime.Caption := IntToStr(ElaspedSec);
  lblConnectCount.Caption := IntToStr(ConnectorList.Count);
  lblPlayCount.Caption := IntToStr(ConnectorList.PlayingUserCount);
    //写出在线人数LOG
  //WriteLog(format('PlayCount %s', [lblPlayCount.Caption]));

  lblLogCount.Caption := IntToStr(ConnectorList.LogingUserCount);
  lblConnectID.Caption := IntToStr(ConnectorList.AutoConnectID);
  lblCCAttack.Caption := IntToStr(CCAttack);

  if ConnectorList.LogingUserCount > 0 then ConnectorList.ClearDieConnect; //2016.07.22 在水一方

  if GameSender <> nil then
  begin
    lblGameSendBytes.Caption := IntToStr(GameSender.SendBytesPerSec);
    lblGameWBCount.Caption := IntToStr(GameSender.WouldBlockCount);
    if GameSender.WriteAllow = true then
    begin
      shpGameWBSign.Brush.Color := clLime;
    end else
    begin
      shpGameWBSign.Brush.Color := clRed;
    end;
  end;
  if GameReceiver <> nil then
  begin
    lblGameRecvBytes.Caption := IntToStr(GameReceiver.ReceiveBytesPerSec);
  end;
  if DBSender <> nil then
  begin
    lblDBSendBytes.Caption := IntToStr(DBSender.SendBytesPerSec);
    lblDBWBCount.Caption := IntToStr(DBSender.WouldBlockCount);
    if DBSender.WriteAllow = true then
    begin
      shpDBWBSign.Brush.Color := clLime;
    end else
    begin
      shpDBWBSign.Brush.Color := clRed;
    end;
  end;
  if DBReceiver <> nil then
  begin
    lblDBRecvBytes.Caption := IntToStr(DBReceiver.ReceiveBytesPerSec);
  end;
  if LoginSenderx <> nil then
  begin
    lblLoginSendBytes.Caption := IntToStr(LoginSenderx.SendBytesPerSec);
    lblLoginWBCount.Caption := IntToStr(LoginSenderx.WouldBlockCount);
    if LoginSenderx.WriteAllow = true then
    begin
      shpLoginWBSign.Brush.Color := clLime;
    end else
    begin
      shpLoginWBSign.Brush.Color := clRed;
    end;
  end;
  if LoginReceiverx <> nil then
  begin
    lblLoginRecvBytes.Caption := IntToStr(LoginReceiverx.ReceiveBytesPerSec);
  end;

  if CurTick >= BalanceSendTick + 3000 then
  begin
    BalanceSendTick := CurTick;
    BalanceData.bofull := false;
    BalanceData.boChecked := chkUserAccept.Checked;

    BalanceData.RemoteIP := UserAcceptInfo.RemoteIP;
    BalanceData.RemotePort := UserAcceptInfo.LocalPort;
    BalanceData.UserCount := ConnectorList.Count;
    if BalanceSender <> nil then
      BalanceSender.PutPacket(0, BM_GATEINFO, 0, @BalanceData, sizeof(TGateInfo));
  end;

  if ConnectorList.GateUniqueValue = -1 then
  begin
    if GameSender <> nil then
    begin
      GameSender.PutPacket(0, GM_UNIQUEVALUE, 0, nil, 0);
    end;
  end;
end;

procedure TfrmMain.sckDBConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  DBSender := TPacketSender.Create('DB', BufferSize_db_Send, Socket);
  DBReceiver := TPacketReceiver.Create('DB', BufferSize_db_Rece);

  AddLog(format('Connected To DB Server %s', [Socket.RemoteAddress]));
  WriteLog(format('Connected To DB Server %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckDBConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if DBSender <> nil then
  begin
    DBSender.Free;
    DBSender := nil;
  end;
  if DBReceiver <> nil then
  begin
    DBReceiver.Free;
    DBReceiver := nil;
  end;

  if Socket.Connected = true then
  begin
    AddLog(format('Disconnected From DB Server %s', [Socket.RemoteAddress]));
  end;
end;

procedure TfrmMain.sckDBConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if (ErrorCode <> 10061) and (ErrorCode <> 10038) then
  begin
    AddLog(format('Socket Error At DBServer Connection (%d)', [ErrorCode]));
  end;
  ErrorCode := 0;
end;

procedure TfrmMain.sckDBConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..deftype_MAX_PACK_SIZE - 1] of byte;
begin
  nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
  if nRead > 0 then
  begin
    if DBReceiver = nil then
    begin
      WriteLog(format('TfrmMain.sckDBConnectRead；DBReceiver = nil', []));
      Socket.Close;
      exit;
    end;
    if DBReceiver.PutData(@buffer, nRead) = false then
    begin
      WriteLog(format('TfrmMain.sckDBConnectRead；DBReceiver.PutData', []));
      Socket.Close;
      exit;
    end;
    exit;
  end;
end;

procedure TfrmMain.sckDBConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if DBSender <> nil then DBSender.WriteAllow := true;
end;

procedure TfrmMain.sckLoginConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  LoginSenderx := TPacketSender.Create('Login', BufferSize_LOGIN_Send, Socket);
  LoginReceiverx := TPacketReceiver.Create('Login', BufferSize_LOGIN_Rece);

  AddLog(format('Connected To Login Server %s', [Socket.RemoteAddress]));
  writeLog(format('Connected To Login Server %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckLoginConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if LoginSenderx <> nil then
  begin
    LoginSenderx.Free;
    LoginSenderx := nil;
  end;
  if LoginReceiverx <> nil then
  begin
    LoginReceiverx.Free;
    LoginReceiverx := nil;
  end;
  if Socket.Connected = true then
  begin
    AddLog(format('Disconnected From Login Server %s', [Socket.RemoteAddress]));
  end;
end;

procedure TfrmMain.sckLoginConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if (ErrorCode <> 10061) and (ErrorCode <> 10038) then
  begin
    AddLog(format('Socket Error At LoginServer Connection (%d)', [ErrorCode]));
  end;
  ErrorCode := 0;
end;

procedure TfrmMain.sckLoginConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..deftype_MAX_PACK_SIZE - 1] of byte;
begin
  nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
  if nRead > 0 then
  begin
    if LoginReceiverx = nil then
    begin
      WriteLog(format('TfrmMain.sckLoginConnectRead；LoginReceiver = nil', []));
      Socket.Close;
      exit;
    end;
    if LoginReceiverx.PutData(@buffer, nRead) = false then
    begin
      WriteLog(format('TfrmMain.sckLoginConnectRead；LoginReceiver.PutData', []));
      Socket.Close;
      exit;
    end;
    exit;
  end;
end;

procedure TfrmMain.sckLoginConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if LoginSenderx <> nil then LoginSenderx.WriteAllow := true;
end;



procedure TfrmMain.sckGameConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  GameSender := TPacketSender.Create('Game', BufferSize_TGS_Send, Socket);
  GameReceiver := TPacketReceiver.Create('Game', BufferSize_TGS_Rece);

  AddLog(format('Connected To Game Server %s', [Socket.RemoteAddress]));
  WriteLog(format('Connected To Game Server %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckGameConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if GameSender <> nil then
  begin
    GameSender.Free;
    GameSender := nil;
  end;
  if GameReceiver <> nil then
  begin
    GameReceiver.Free;
    GameReceiver := nil;
  end;
  if Socket.Connected = true then
  begin
    AddLog(format('Disconnected From Game Server %s', [Socket.RemoteAddress]));
  end;
  if ConnectorList <> nil then
  begin
    ConnectorList.GateUniqueValue := -1;
  end;
end;

procedure TfrmMain.sckGameConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  if (ErrorCode <> 10061) and (ErrorCode <> 10038) then
  begin
    AddLog(format('Socket Error At GameServer Connection (%d)', [ErrorCode]));
  end;
  ErrorCode := 0;
end;

procedure TfrmMain.sckGameConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..65535 - 1] of byte;
begin
  nRead := Socket.ReceiveBuf(buffer, 65535);
  if nRead > 0 then
  begin
    if GameReceiver = nil then
    begin
      WriteLog(format('TfrmMain.sckGameConnectRead；GameReceiver=nil', []));
      Socket.Close;
      exit;
    end;
    if GameReceiver.PutData(@buffer, nRead) = false then
    begin
      WriteLog(format('TfrmMain.sckGameConnectRead；GameReceiver.PutData', []));
      Socket.Close;
      exit;
    end;
    exit;
  end;
end;

procedure TfrmMain.sckGameConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if GameSender <> nil then GameSender.WriteAllow := true;
end;

procedure TfrmMain.timerCloseTimer(Sender: TObject);
begin
  if ConnectorList = nil then
  begin
    timerClose.Enabled := false;
    Close;
    exit;
  end;
end;

procedure TfrmMain.sckPaidConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if PaidSender <> nil then PaidSender.Free;
  if PaidReceiver <> nil then PaidReceiver.Free;

  PaidSender := TPacketSender.Create('PaidSender', BufferSize_Paid_Send, Socket);
  PaidReceiver := TPacketReceiver.Create('PaidReceiver', BufferSize_Paid_Rece);

  AddLog(format('Connected To Paid Server %s', [Socket.RemoteAddress]));
  writeLog(format('Connected To Paid Server %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckPaidConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if PaidSender <> nil then PaidSender.Free;
  if PaidReceiver <> nil then PaidReceiver.Free;
  PaidSender := nil;
  PaidReceiver := nil;

  if Socket.Connected = true then
  begin
    AddLog(format('DisConnected From Paid Server %s', [Socket.RemoteAddress]));
  end;
end;

procedure TfrmMain.sckPaidConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TfrmMain.sckPaidConnectRead(Sender: TObject; Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..deftype_MAX_PACK_SIZE - 1] of char;
begin
  nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
  if nRead > 0 then
  begin
    if PaidReceiver = nil then
    begin
      WriteLog(format('TfrmMain.sckPaidConnectRead；PaidReceiver = nil', []));
      Socket.Close;
      exit;
    end;
    if PaidReceiver.PutData(@buffer, nRead) = false then
    begin
      WriteLog(format('TfrmMain.sckPaidConnectRead；PaidReceiver.PutData', []));
      Socket.Close;
      exit;
    end;
  end;
end;

procedure TfrmMain.sckPaidConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if PaidSender <> nil then PaidSender.WriteAllow := true;
end;

procedure TfrmMain.sckBalanceConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if BalanceSender <> nil then BalanceSender.Free;
  if BalanceReceiver <> nil then BalanceReceiver.Free;

  BalanceSender := TPacketSender.Create('BalanceSender', BufferSize_BA_Send, Socket);
  BalanceReceiver := TPacketReceiver.Create('BalanceReceiver', BufferSize_BA_Rece);

  AddLog(format('Connected To Balance Server %s', [Socket.RemoteAddress]));
  writeLog(format('Connected To Balance Server %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckBalanceConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if BalanceSender <> nil then BalanceSender.Free;
  if BalanceReceiver <> nil then BalanceReceiver.Free;
  BalanceSender := nil;
  BalanceReceiver := nil;

  if Socket.Connected = true then
  begin
    AddLog(format('DisConnected From Balance Server %s', [Socket.RemoteAddress]));
  end;
end;

procedure TfrmMain.sckBalanceConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TfrmMain.sckBalanceConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..deftype_MAX_PACK_SIZE - 1] of char;
begin
  nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
  if nRead > 0 then
  begin
    if BalanceReceiver = nil then
    begin
      WriteLog(format('TfrmMain.sckBalanceConnectRead；PaidReceiver = nil', []));
      Socket.Close;
      exit;
    end;
    if BalanceReceiver.PutData(@buffer, nRead) = false then
    begin
      WriteLog(format('TfrmMain.sckBalanceConnectRead；BalanceReceiver.PutData', []));
      Socket.Close;
      exit;
    end;
  end;
end;

procedure TfrmMain.sckBalanceConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if BalanceSender <> nil then BalanceSender.WriteAllow := true;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  memolog.Lines.Add(ConnectorList.GetStateList());
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  MemoLog.Lines.Clear;
  MemoLog.Lines.Add('TGSsend:' + inttostr(GameSender.BufferCount));
  MemoLog.Lines.Add('TGSrece:' + inttostr(GameReceiver.BufferCount));
  MemoLog.Lines.Add('TGSrecePack:' + inttostr(GameReceiver.Count));
  MemoLog.Lines.Add('======================');
  MemoLog.Lines.add(ConnectorList.GetBuffList);

end;

procedure TfrmMain.SpinEdit1Change(Sender: TObject);
begin
  userconnectorcount := TSpinEdit(Sender).Value;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  FrmConsole.Show;
end;

procedure TfrmMain.btnClearNoPlayerClick(Sender: TObject);
begin
  ShowMessage('清除了 ' + IntToStr(ConnectorList.ClearNoPlayer) + ' 个连接!');
end;

procedure TfrmMain.SpinUserCountChange(Sender: TObject);
var
  iniFile: TIniFile;
begin
  LimitUserCount := TSpinEdit(Sender).Value;

  iniFile := TIniFile.Create('.\GATE.INI');
  try
    iniFile.WriteInteger('SERVER', 'LIMITUSERCOUNT', LimitUserCount);
  finally
    iniFile.Free;
  end;
end;

procedure TfrmMain.btnloginClick(Sender: TObject);
begin
  sckLoginConnect.Socket.Close;

  sckLoginConnect.Active := false;

  sckLoginConnect.Address := LoginConnectInfo.RemoteIP;
  sckLoginConnect.Port := LoginConnectInfo.RemotePort;
  sckLoginConnect.Active := true;
end;

procedure TfrmMain.chkzfClick(Sender: TObject);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create('.\GATE.INI');
  try
    iniFile.WriteBool('INI_CONFIG', TCheckBox(Sender).Name, TCheckBox(Sender).Checked);
  finally
    iniFile.Free;
  end;
end;

end.

