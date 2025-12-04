unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, iniFiles, mmSystem, ExtCtrls,
  uKeyClass, deftype, Menus, DB, ADODB, ScktComp, DBAccess, MyAccess;

type
  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    tsEvent: TTabSheet;
    tsMonitor: TTabSheet;
    txtLog: TMemo;
    sckAccept: TServerSocket;
    tsStatus: TTabSheet;
    timerDisplay: TTimer;
    timerProcess: TTimer;
    StaticText7: TStaticText;
    lblGateConnectCount: TStaticText;
    StaticText11: TStaticText;
    lblElaspedTime: TStaticText;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    NMenuLogin: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    lstEvent: TMemo;
    lLoginDbCount: TStaticText;
    lblLoginDbCount: TStaticText;
    MyConn: TMyConnection;
    AccConn: TMyConnection;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure sckAcceptAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckAcceptClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckAcceptClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure timerDisplayTimer(Sender: TObject);
    procedure timerProcessTimer(Sender: TObject);
    procedure sckItemRemoteClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure NMenuLoginClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure MyConnError(Sender: TObject; E: EDAError; var Fail: Boolean);
  private
        { Private declarations }
    FConfig: TIniFile;
  public
        { Public declarations }
    procedure AddEvent(aStr: string);
    procedure AddLog(aStr: string);
    function Connect: Boolean;
  end;

var
  frmMain: TfrmMain;

  ElaspedSec, StartTick, CheckMysql: Integer;
   // FDBFileName: string;
  BufferSizeS2S: Integer;
  PaidAcceptPort
    , GateAcceptPort
       // , RemoteAcceptPort
       // , ItemRemoteAcceptPort
  : Integer;

  sqldbname, sqlip, sqlusername, sqlpassword: string;

implementation

uses
  uConnector, uSQLDBAdapter, frmLogin;

{$R *.DFM}

procedure TfrmMain.AddEvent(aStr: string);
begin
  if lstEvent.Lines.Count > 100 then lstEvent.Lines.Clear;
  lstEvent.Lines.Add(aStr);
end;

procedure TfrmMain.AddLog(aStr: string);
begin
  if txtLog.Lines.Count > 1000 then txtLog.Lines.Clear;
  txtLog.Lines.Add(aStr);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  str: string;
  iniFile: TIniFile;
begin
  AddLog(format('Login Server Started %s %s', [DateToStr(Date), TimeToStr(Time)]));
  ElaspedSec := 0;
  StartTick := timeGetTime;
  CheckMysql := timeGetTime;
  if not FileExists('.\login.ini') then
  begin
    FConfig := TIniFile.Create('.\login.ini');
    try
      FConfig.WriteInteger('DB_SERVER', 'BufferSizeS2S', 1024 * 1024);
      FConfig.WriteInteger('DB_SERVER', 'GateAcceptPort', 4150);
    finally

    end;
  end;
  FConfig := TIniFile.Create('.\login.ini');
  try
    BufferSizeS2S := FConfig.ReadInteger('DB_SERVER', 'BufferSizeS2S', 1024 * 1024);
    GateAcceptPort := FConfig.ReadInteger('DB_SERVER', 'GateAcceptPort', 4150);
  finally

  end;

  ConnectorList := TConnectorList.Create;

  sckAccept.Port := GateAcceptPort;
  sckAccept.Active := true;

  timerDisplay.Interval := 1000;
  timerDisplay.Enabled := true;

  timerProcess.Interval := 10;
  timerProcess.Enabled := true;

  NMenuLogin.Visible := false;
  Caption := '';
  //  LoginDBAdapter := nil;
  lLoginDbCount.Visible := false;
  lblLoginDbCount.Visible := false;

  NMenuLogin.Visible := true;
  lLoginDbCount.Visible := true;
  lblLoginDbCount.Visible := true;
  Caption := 'Login Server';
  SQLDBAdapter := TSQlDBAdapter.Create(MyConn);     
  Connect;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

  if sckAccept.Active = true then
  begin
    sckAccept.Socket.Close;
  end;

  timerDisplay.Enabled := false;
  timerProcess.Enabled := false;

  ConnectorList.Free;
   // if LoginDBAdapter <> nil then LoginDBAdapter.Free;
  if SQLDBAdapter <> nil then SQLDBAdapter.Free;
  FConfig.Free;
end;

procedure TfrmMain.timerDisplayTimer(Sender: TObject);
var
  CurTick: Integer;
  FileName: string;
  nYear, nMonth, nDay: Word;
  mYear, mMonth, mDay: Word;
begin
  CurTick := timeGetTime;

  if CurTick >= StartTick + 1000 then
  begin
    ElaspedSec := ElaspedSec + 1;
    StartTick := CurTick;
  end;

  if CurTick >= CheckMysql + 60000 then
  begin
    if (not MyConn.Connected) or (not AccConn.Connected) then
    begin
      AddLog('Mysql Not Connected');
      Connect;
    end;
    CheckMysql := CurTick;
  end;


  lblElaspedTime.Caption := IntToStr(ElaspedSec);
  lblGateConnectCount.Caption := IntToStr(ConnectorList.Count);
   // if SQLDBAdapter <> nil then    lblLoginDbCount.Caption := inttostr(SQLDBAdapter.count);
end;

procedure TfrmMain.timerProcessTimer(Sender: TObject);
begin
  if ConnectorList <> nil then ConnectorList.Update();
end;

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.sckAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ConnectorList.CreateConnect(Socket);
  AddLog(format('Login Server Accepted %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if socket.RemoteAddress <> '127.0.0.1' then
  begin
    Socket.Close; //
 //MessageBox(0,PChar(ParamStr(0)),'',0);
  end;
end;

procedure TfrmMain.sckAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ConnectorList.DeleteConnect(Socket);
  AddLog(format('Login Server Disconnected %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  AddLog(format('Login Server Accept Socket Error (%d, %s)', [ErrorCode, Socket.RemoteAddress]));
  ErrorCode := 0;
  Socket.Close;
end;

procedure TfrmMain.sckAcceptClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..65535] of byte;
begin
    //3051
  nRead := Socket.ReceiveBuf(buffer, 65535);
  if nRead > 0 then
  begin
    ConnectorList.AddReceiveData(Socket, @buffer, nRead);
    exit;
  end;
end;

procedure TfrmMain.sckAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ConnectorList.SetWriteAllow(Socket);
end;

procedure TfrmMain.sckItemRemoteClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

function isbuf(abuf, abuf2: pointer; asize: integer; out strout: string): boolean;
var
  i: integer;
  pb, pb2: pbyte;
begin
  result := false;
  pb := abuf;
  pb2 := abuf2;
  for i := 0 to asize - 1 do
  begin
    if pb^ <> pb2^ then
    begin
      strout := '[位置]' + inttostr(i) + '/' + inttostr(asize);
      exit;
    end;
    inc(pb);
    inc(pb2);
  end;
  result := true;
end;

procedure TfrmMain.NMenuLoginClick(Sender: TObject);
begin
  FormLogin := TFormLogin.Create(self);
  try
    FormLogin.Left := 192;
    FormLogin.Top := 112;
    FormLogin.ShowModal;
  finally
    FormLogin.Free;
  end;
end;

procedure TfrmMain.N8Click(Sender: TObject);
begin
  if Application.MessageBox('你真的要退出吗?', 'Login SERVER', MB_OKCANCEL) <> ID_OK then exit;
  Close;
end;

function TfrmMain.Connect: Boolean;
var
  mysql: TMyQuery;
begin
  Result := True;
  MyConn.Close;
  MyConn.LoginPrompt := False;
  try
    MyConn.Server := FConfig.ReadString('DB_SERVER', 'Server', '');
    MyConn.Database := FConfig.ReadString('DB_SERVER', 'Database', '');
    MyConn.Port := FConfig.ReadInteger('DB_SERVER', 'Port', 0);
    MyConn.Username := FConfig.ReadString('DB_SERVER', 'Username', '');
    MyConn.Password := FConfig.ReadString('DB_SERVER', 'Password', '');
    //MyConn.LoginPrompt := False;
    //MyConn.TCustomMyConnectionOptions.Charset := 'gbk';
    MyConn.Connect;

    mysql := TMyQuery.Create(nil);
    if MyConn.Connected then
    begin
      mysql.Connection := MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
      frmMain.AddLog('连接角色数据库!');
    end;
    mysql.Free;
  except
    on e: Exception do
    begin
      frmMain.AddLog('login mysql 角色数据库连接失败!error:' + e.Message);
      Result := False;
    end;
  end;

  AccConn.Close;
  AccConn.LoginPrompt := False;
  try
    AccConn.Server := FConfig.ReadString('ACC_SERVER', 'Server', '');
    AccConn.Database := FConfig.ReadString('ACC_SERVER', 'Database', '');
    AccConn.Port := FConfig.ReadInteger('ACC_SERVER', 'Port', 0);
    AccConn.Username := FConfig.ReadString('ACC_SERVER', 'Username', '');
    AccConn.Password := FConfig.ReadString('ACC_SERVER', 'Password', '');
    //MyConn.LoginPrompt := False;
    //MyConn.TCustomMyConnectionOptions.Charset := 'gbk';
    AccConn.Connect;

    mysql := TMyQuery.Create(nil);
    if AccConn.Connected then
    begin
      mysql.Connection := AccConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
      frmMain.AddLog('连接帐号数据库!');
    end;
    mysql.Free;
  except
    on e: Exception do
    begin                                  
      frmMain.AddLog('login mysql 帐号数据库连接失败!error:' + e.Message);
      Result := False;
    end;
  end;
end;

procedure TfrmMain.MyConnError(Sender: TObject; E: EDAError;
  var Fail: Boolean);
begin
  frmMain.AddLog('错误信息: ' + E.Message);
  Fail := False;
  //错误10053
  if E.ErrorCode = 10053 then
   Connect;
end;

end.

