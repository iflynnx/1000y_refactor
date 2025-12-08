unit FMain;

interface

uses
  Windows, mmSystem, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, DefType, uUtil, ExtCtrls, ScktComp, uAnsTick,
  ComCtrls, Spin;

function _DateTimeToStr(atime: Tdatetime): string; //统一时间格式转换
function _StrToDateTime(atime: string): Tdatetime; //统一时间格式转换

const
  MAX_AVAILABLE_GATE = 10;

type

  TfrmMain = class(TForm)
    sckUser: TServerSocket;
    timerDisplay: TTimer;
    timerProcess: TTimer;
    sckGate: TServerSocket;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit_logindectime: TSpinEdit;
    SpinEdit_logintime: TSpinEdit;
    SpinEdit_logincount: TSpinEdit;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpinEdit_conndectime: TSpinEdit;
    SpinEdit_conntime: TSpinEdit;
    SpinEdit_conncount: TSpinEdit;
    TabSheet4: TTabSheet;
    lstInfo: TListBox;
    Panel1: TPanel;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    Panel2: TPanel;
    cmdClose: TButton;
    Edit_ver: TEdit;
    Label7: TLabel;
    chkUserAccept: TCheckBox;
    CheckBox_ver: TCheckBox;
    grp1: TGroupBox;
    lbl1: TLabel;
    SpinEdit_ClientNum: TSpinEdit;
    chk_open: TCheckBox;
    dtp_date: TDateTimePicker;
    dtp_time: TDateTimePicker;
    procedure cmdCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sckUserClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sckUserClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);

    procedure timerDisplayTimer(Sender: TObject);
    procedure sckUserClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckUserClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckUserAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure timerProcessTimer(Sender: TObject);
    procedure sckGateClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sckGateAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckGateClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGateClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckGateClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button1Click(Sender: TObject);
    procedure SpinEdit_conndectimeChange(Sender: TObject);
    procedure SpinEdit_logindectimeChange(Sender: TObject);
    procedure SpinEdit_logintimeChange(Sender: TObject);
    procedure SpinEdit_logincountChange(Sender: TObject);
    procedure SpinEdit_conntimeChange(Sender: TObject);
    procedure SpinEdit_conncountChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit_verChange(Sender: TObject);
    procedure sckGateClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure SpinEdit_ClientNumChange(Sender: TObject);
    procedure dtp_dateChange(Sender: TObject);
  private
        { Private declarations }

  public
        { Public declarations }

    procedure AddInfo(aStr: string);
  end;

var
  frmMain: TfrmMain;
  TcpLocalPort
    , GATEPort
    , TGSPort
    , verini
    , Clientnum
    : Integer;
  OpenTime: TDateTime;
  TotalConnectionCount: Integer = 0;
  BanList: THashedStringList; //2015.11.26 在水一方
    //    GateInfo        :array[0..MAX_AVAILABLE_GATE - 1] of TGateInfo;

implementation

uses
  uPackets, uConnector, uGATEConnector, DateUtils;

{$R *.DFM}

procedure TfrmMain.AddInfo(aStr: string);
begin
  if lstInfo.Items.Count >= 10 then
  begin
    lstInfo.Items.Delete(0);
  end;

  lstInfo.Items.Add(aStr);
  lstInfo.ItemIndex := lstInfo.Items.Count - 1;
end;

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.timerDisplayTimer(Sender: TObject);
var
  i, CurTick: Integer;
  Socket: TCustomWinSocket;
begin
  CurTick := timeGetTime;
  if BanList.Count = 0 then begin //2015.11.26 在水一方
    GConnectorList.getBanlist;
  end;
  Memo1.Lines.Text := GConnectorList.getmenu;

end;

procedure TfrmMain.timerProcessTimer(Sender: TObject);

var
  CurTick: Integer;
begin
  CurTick := mmAnsTick;

  ConnectorList.Update(CurTick);
  GConnectorList.Update(CurTick);

end;

procedure inisaveinteger(s1, s2: string; aid: integer);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create('.\BALANCE.INI');
  try

    iniFile.WriteInteger(s1, s2, aid);
  finally
    iniFile.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: Integer;
  iniFile: TIniFile;
  str: string;
begin
  BanList := THashedStringList.Create;
  
  if not FileExists('.\BALANCE.INI') then
  begin
    iniFile := TIniFile.Create('.\BALANCE.INI');
    try

      iniFile.WriteInteger('BALANCE', 'TCPLOCALPORT', 3053);
      iniFile.WriteInteger('BALANCE', 'GATEPORT', 3080);
      iniFile.WriteInteger('BALANCE', 'TGSPORT', 3090);

    finally
      iniFile.Free;
    end;
  end;
  iniFile := TIniFile.Create('.\BALANCE.INI');
  try
    TcpLocalPort := iniFile.ReadInteger('BALANCE', 'TCPLOCALPORT', 3053);
    GATEPort := iniFile.ReadInteger('BALANCE', 'GATEPORT', 3080);
    TGSPort := iniFile.ReadInteger('BALANCE', 'TGSPORT', 3090);

    SpinEdit_logintime.Value := iniFile.ReadInteger('SPINEDIT', SpinEdit_logintime.Name, 1);
    SpinEdit_logindectime.Value := iniFile.ReadInteger('SPINEDIT', SpinEdit_logindectime.Name, 1);
    SpinEdit_logincount.Value := iniFile.ReadInteger('SPINEDIT', SpinEdit_logincount.Name, 1);
    SpinEdit_conntime.Value := iniFile.ReadInteger('SPINEDIT', SpinEdit_conntime.Name, 1);
    SpinEdit_conndectime.Value := iniFile.ReadInteger('SPINEDIT', SpinEdit_conndectime.Name, 1);
    SpinEdit_conncount.Value := iniFile.ReadInteger('SPINEDIT', SpinEdit_conncount.Name, 1);
    verini := iniFile.ReadInteger('ver', 'ver', 1);
    Edit_ver.Text := inttostr(verini);
    //客户端进程数量
    Clientnum := iniFile.ReadInteger('SPINEDIT', 'SpinEdit_ClientNum', 3);
    SpinEdit_ClientNum.Text := inttostr(Clientnum);
    //限时登陆
    Str := iniFile.ReadString('SPINEDIT', 'SpinEdit_OpenDate', '');
    if Str <> '' then
    begin
      OpenTime := _StrToDateTime(Str);
      dtp_date.DateTime := OpenTime;
      dtp_time.DateTime := OpenTime;
    end;
  finally
    iniFile.Free;
  end;

  try
    ConnectorList := TConnectorList.Create;
    GConnectorList := TGConnectorList.Create;

    sckUser.Port := TcpLocalPort;
    sckUser.Active := true;

    sckgate.Port := gatePort;
    sckgate.Active := true;

    timerDisplay.Interval := 1000;
    timerDisplay.Enabled := true;
  except
    Close;
  end;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  BanList.free;
  ConnectorList.Free;
  GConnectorList.Free;

end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.sckUserClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  AddInfo(Socket.RemoteAddress + ' Error');
  ErrorCode := 0;
end;

procedure TfrmMain.sckUserClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ConnectorList.SetWriteAllow(Socket);
end;

procedure TfrmMain.sckUserClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);

begin
  ConnectorList.DeleteConnect(Socket);

  AddInfo(Socket.RemoteAddress + ' DisConnected ');
end;

procedure TfrmMain.sckUserClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..deftype_MAX_PACK_SIZE] of byte;
begin
  nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
  if nRead > 0 then
  begin
    ConnectorList.AddReceiveData(Socket, @buffer, nRead);
    exit;
  end;
end;

procedure TfrmMain.sckUserAccept(Sender: TObject;
  Socket: TCustomWinSocket);
var
  pplog: pTconnUserLogdata;
  templog: TconnUserLogdata;
begin
  if chkUserAccept.Checked = true then
  begin

    pplog := connIPLog.get(Socket.RemoteAddress);
    if pplog <> nil then
    begin
      pplog.rcount := pplog.rcount + 1;
      pplog.rcurcount := pplog.rcurcount + 1;
      if SecondsBetween(now(), pplog.rconnTime) < frmMain.SpinEdit_conntime.Value then
      begin
        AddInfo(Socket.RemoteAddress + ' 连接过于频繁，拒绝。');
        Socket.Close;
        exit;
      end;
      pplog.rconnTime := now();
      if pplog.rcurcount > frmMain.SpinEdit_conncount.Value then
      begin
        AddInfo(Socket.RemoteAddress + ' 连接数量超标，拒绝。');
        Socket.Close;
        exit;
      end;

    end;
    if pplog = nil then
    begin
      templog.rloginid := Socket.RemoteAddress;
      templog.rpassword := '';
      templog.ripadd := Socket.RemoteAddress;
      templog.rconnTime := now();
      templog.rcount := 1;

      connIPLog.add(@templog);
    end;
    AddInfo(Socket.RemoteAddress + ' Connected');
    if ConnectorList.CreateConnect(Socket) = true then exit;

  end;
  Socket.Close;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.sckGateClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
end;

procedure TfrmMain.sckGateAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin

  AddInfo(Socket.RemoteAddress + ' Connected');
  if gConnectorList.CreateConnect(Socket) = true then exit;

  Socket.Close;
end;

procedure TfrmMain.sckGateClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  gConnectorList.DeleteConnect(Socket);

  AddInfo(Socket.RemoteAddress + ' DisConnected ');
end;

procedure TfrmMain.sckGateClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nRead: Integer;
  buffer: array[0..deftype_MAX_PACK_SIZE] of byte;
begin
  nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
  if nRead > 0 then
  begin
    gConnectorList.AddReceiveData(Socket, @buffer, nRead);
    exit;
  end;
end;

procedure TfrmMain.sckGateClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  gConnectorList.SetWriteAllow(Socket);
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  Memo2.Lines.Text := connUserLog.getmenu;
end;

procedure TfrmMain.SpinEdit_conndectimeChange(Sender: TObject);
begin
  if connIPLog <> nil then connIPLog.fdectime := SpinEdit_conndectime.Value;
  inisaveinteger('SPINEDIT', TSpinEdit(Sender).Name, TSpinEdit(Sender).Value);

end;

procedure TfrmMain.SpinEdit_logindectimeChange(Sender: TObject);
begin
  if connuserLog <> nil then
    connuserLog.fdectime := SpinEdit_logindectime.Value;
  inisaveinteger('SPINEDIT', TSpinEdit(Sender).Name, TSpinEdit(Sender).Value);
end;

procedure TfrmMain.SpinEdit_logintimeChange(Sender: TObject);
begin
  inisaveinteger('SPINEDIT', TSpinEdit(Sender).Name, TSpinEdit(Sender).Value);
end;

procedure TfrmMain.SpinEdit_logincountChange(Sender: TObject);
begin
  inisaveinteger('SPINEDIT', TSpinEdit(Sender).Name, TSpinEdit(Sender).Value);
end;

procedure TfrmMain.SpinEdit_conntimeChange(Sender: TObject);
begin
  inisaveinteger('SPINEDIT', TSpinEdit(Sender).Name, TSpinEdit(Sender).Value);
end;

procedure TfrmMain.SpinEdit_conncountChange(Sender: TObject);
begin
  inisaveinteger('SPINEDIT', TSpinEdit(Sender).Name, TSpinEdit(Sender).Value);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  Memo2.Lines.Text := connIPLog.getmenu;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  connUserLog.Clear;
  connIPLog.Clear;
end;

procedure TfrmMain.Edit_verChange(Sender: TObject);
begin
  try
    verini := strtoint(Edit_ver.Text);
    inisaveinteger('ver', 'ver', verini);
  except
    Edit_ver.Text := inttostr(verini);
    exit;
  end;

end;

procedure TfrmMain.sckGateClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if socket.RemoteAddress <> '127.0.0.1' then
  begin
    Socket.Close; //
// MessageBox(0,PChar(ParamStr(0)),'',0);
  end;
end;

procedure TfrmMain.SpinEdit_ClientNumChange(Sender: TObject);
begin
  try
    Clientnum := strtoint(SpinEdit_ClientNum.Text);
    inisaveinteger('SPINEDIT', 'SpinEdit_ClientNum', Clientnum);
  except
    SpinEdit_ClientNum.Text := inttostr(Clientnum);
    exit;
  end;
end;

procedure TfrmMain.dtp_dateChange(Sender: TObject);
var
  iniFile: TIniFile;
begin
  iniFile := TIniFile.Create('.\BALANCE.INI');
  try
    dtp_date.Time := dtp_time.Time;
    OpenTime := dtp_date.DateTime;
    iniFile.WriteString('SPINEDIT', 'SpinEdit_OpenDate', _DateTimeToStr(OpenTime));
  finally
    iniFile.Free;
  end;
end;


function _DateTimeToStr(atime: Tdatetime): string;
var
  FSetting: TFormatSettings;
begin
  FSetting.ShortDateFormat := 'yyyy-MM-dd';
  FSetting.DateSeparator := '-';
  FSetting.TimeSeparator := ':';
  FSetting.LongTimeFormat := 'hh:mm:ss';

  Result := DateTimeToStr(atime, FSetting);
end;

function _StrToDateTime(atime: string): Tdatetime;
var
  FSetting: TFormatSettings;
begin
  FSetting.ShortDateFormat := 'yyyy-MM-dd';
  FSetting.DateSeparator := '-';
  FSetting.TimeSeparator := ':';
  FSetting.LongTimeFormat := 'hh:mm:ss';

  Result := StrToDateTime(atime, FSetting);
end;
end.

