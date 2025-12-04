unit fbl;

interface

uses
  Windows, SysUtils, Classes, ExtCtrls, Controls, Graphics, Forms, VCLZip, VCLUnZip,
  Buttons, StdCtrls, deftype, uBuffer,
  uAnsTick, aUtil32, inifiles, WinSock,
  Dialogs, Cltype, A2Img, A2Form, Log, mmSystem, unewPackets, Messages,
  ComCtrls, WinInet, ImgList, Gauges, jpeg, SkinCtrls, SkinData,
  DynamicSkinForm, Mask, SkinBoxCtrls, ScktComp, BaseUIForm, uHardCode, ZLibExGZ, TlHelp32, PerlRegEx; //ansunit;

type //ping要用到的声明
  PIPOptionInfo = ^TIPOptionInfo;

  TIPOptionInfo = packed record
    TTL: Byte;
    TOS: Byte;
    Flags: Byte;
    OptionsSize: Byte;
    OptionsData: PChar;
  end;

  PIcmpEchoReply = ^TIcmpEchoReply;

  TIcmpEchoReply = packed record
    Address: DWORD;
    Status: DWORD;
    RTT: DWORD;
    DataSize: Word;
    Reserved: Word;
    Data: Pointer;
    Options: TIPOptionInfo;
  end;

  TIcmpCreateFile = function: THandle; stdcall;

  TIcmpCloseHandle = function(IcmpHandle: THandle): Boolean; stdcall;

  TIcmpSendEcho = function(IcmpHandle: THandle; DestinationAddress: DWORD; RequestData: Pointer; RequestSize: Word; RequestOptions: PIPOptionInfo; ReplyBuffer: Pointer; ReplySize: DWord; Timeout: DWord): DWord; stdcall;

type
  Tbuf_char = array[0..4095] of char;
  Tbuf_byte = array[0..4095] of byte;

const
    //  MAXSOCKETDATASIZE = 10000;
     // MAXSOCKETSENDDATASIZE = 4096;

     // PROCESSDATASIZE = 4096;

    //  PacketBufferSize = 8192;
     // SocketBufferSize = 64192;
  verini = 20170310; //版本号
  urllist = '293535317B6E6E2E2D6F23242033302F6F222E2C6E34316E2D2832356F353935';

type
  Txchar = class
    rver: string[128];
    rName: string[128];
  end;
type
  TConnectState = (cs_none, cs_balance, cs_gate, cs_gameserver);
  THostAddressdata = record
    rHost: string[128];
    rPort: integer;
    rName: string[64];
  end;
  pTHostAddressdata = ^THostAddressdata;

  THostAddressSub = class
  private
    fdata: tlist;
    fname: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure clear;
    procedure add(adata: THostAddressdata);
    function get(aindex: integer): pTHostAddressdata;
    function getIndex(aname: string): integer;
    function getMenu(): string;
  end;

  THostAddressClass = class
  private
    fdata: tlist;
  public
    constructor Create(aFileName: string);
    destructor Destroy; override;

    procedure clear;
    procedure add(aname: string);
    function get(aname: string): THostAddressSub;
    function getMenu(): string;
    function getSubMenu(aname: string): string;
    function getSub(aname: string; aindex: integer): pTHostAddressdata;
    function getIndex(aname: string): integer;
    function getSubIndex(aname, asubname: string): integer;
  end;

  TGameStatus = (gs_none, gs_BA, gs_login, gs_play);
type
  Tfrmfbl = class(TfrmBaseUI)
    TimePing: TTimer;
    sckConnect: TClientSocket;
    timerProcess: TTimer;
    Timer_login: TTimer;
    TimerSpeedCheck: TTimer;
    TimerSendTime: TTimer;
    ImageList2: TImageList;
    ClientSocket1: TClientSocket;
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinData1: TspSkinData;
    spCompressedStoredSkin1: TspCompressedStoredSkin;
    Panel1: TA2Panel;
    btnExit: TA2Button;
    btnLogin: TA2Button;
    EdID: TA2Edit;
    EdPass: TA2Edit;
    PnInfo: TA2Label;
    A2Form: TA2Form;
    A2CheckBox_SaveUser: TA2CheckBox;
    A2CheckBox_SavePass: TA2CheckBox;
    btnRegister: TA2Button;
    btnHomePage: TA2Button;
  //  A2Form: TA2Form;
    procedure btnRegisterClick(Sender: TObject);
    procedure btnHomePageClick(Sender: TObject);
    procedure btnloginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure timerProcessTimer(Sender: TObject);
    procedure Timer_loginTimer(Sender: TObject);
    procedure TimePingTimer(Sender: TObject);
    procedure sckConnectConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckConnectDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckConnectError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sckConnectRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckConnectWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure btnnewuserClick(Sender: TObject);
    procedure btnexitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TreeView1Click(Sender: TObject);
    procedure TimerSpeedCheckTimer(Sender: TObject);
    procedure EdIDChange(Sender: TObject);
    procedure EdPassChange(Sender: TObject);
    procedure EdIDKeyPress(Sender: TObject; var Key: Char);
    procedure EdIDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdPassKeyPress(Sender: TObject; var Key: Char);
    procedure EdPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure updatebtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2CheckBox_SaveUserClick(Sender: TObject);
    procedure A2CheckBox_SavePassClick(Sender: TObject);


  private
    { Private declarations }
    Floginstate: integer;

    HostAddressClass: THostAddressClass;

    FStartTime: TDateTime;
    FCurTick, FOldTick: integer;
//        ReadBuffer: TBuffer;
    procedure InitMainSocketAndBuffer;
    procedure sendPack(aid: Integer; aPackType: TPackType);
//        procedure packUpate;
    procedure WriteLog(aStr: string);
    procedure sendPing;
    procedure downfile(x, y: string);
    function GetOuterIP(url, aPos, bPos: string; aPort: Integer = 80): string;
    function GetClientNum: Integer;
  public
    cConnTime: integer;
    PacketSender: TNEWPacketSender;
    PacketReceiver: TNEWPacketReceiver;
//    PacketReceiver_r: TRPacketReceiver;
 //   PacketSender_r: TRPacketSender;
    FGameStatus: TGameStatus;
    ConnectID: integer;
    DBRecordList: TDBRecordList;
    filename1: string; //本地文件名
    serfilename: string; //服务器端文件名
    serhost1: string; //服务器地址
    can_rec1: boolean; //是否可以接收
    stop1: boolean; //是否停止
    procedure bk(var msg: TWMERASEBKGND); message WM_ERASEBKGND;

    function MessageProcess(var Code: TWordComData): Boolean; //处理 消息
    procedure ClearEdit(abo: Boolean);
    function SocketAddData(cnt: integer; buf: pointer): Boolean;
    function SocketAddDataEx(cnt: integer; buf: pointer): Boolean;
        //        function SocketAddOneData(adata:byte):Boolean;

    function ISMsgCmd(acmd: integer): boolean;

    function SocketDisConnect(ErrText, ErrCaption: string; aActive: Boolean; aopenwww: boolean = false): Boolean;
    procedure SetFormText;
    procedure tchange;
    procedure sendIDPASS();
    procedure sendBalance();
    procedure SendGameCheckResult(aKey1, aKey2: Byte); //2016.03.24 在水一方
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure RefreshCheckBox;
  end;

var
  frmfbl: Tfrmfbl;
  mainFont: string = '宋体';
  CurServerName: string = '';
  MessageDelayTime: array[0..255] of integer;
  MsgCmdarr: array[0..255] of integer;

  CaptionServerName: string = '';

  ReConnectId: string = '';
  ReConnectPass: string = '';
  ReConnectChar: string = '';
  ReConnectServer: string = '';
  ReConnectIpAddr: string = '';
  ReConnectPort: integer = 0;
  ReConnectIpAddr_gate: string = '';
  ReConnectPort_gate: integer = 0;
  ReConnectyid: integer;

  boTimePaid: Boolean = TRUE; // 牢器讥眉农侩
  ReConnetFlag: Boolean = TRUE;
  ReConnectTick: Integer = 0;
  ReConnectLoginTick: Integer = 0;
  ReConnectMagic: string = ''; //重连攻击性武功
  ReConnectFengMagic: string = ''; //重连风武功
  //ReConnectMagicBo: Boolean = False;
  ReConnectHit: Integer = 0;
  ReConnectEnergy: Integer = -1;
  ReConnectyctime: Integer = 1;
  ReConnectAttack: Boolean = False;
  ReConnectAttackUser: Boolean = False;


  indexTick: integer;

  ConnectState: TConnectState;
  boDirectClose: Boolean = FALSE;
  bofirst: boolean = TRUE;

  netPingId: integer;
  netPing: integer;
  netPingSendTick: integer;
  localnum: Integer = 0;


  pos1: longint; //上次下载到的位置
  currentver, oldver: string;


  cxver, cxzip: string;
  xchar: Txchar;
  hcode, oldhcode: string;
  OuterIpAddr: string = ''; //2015.11.25 在水一方


//ping要用到的变量声明
  hICMPDll, hICMP: THandle;
  wsaData: TWSADATA;
  ICMPCreateFile: TICMPCreateFile;
  IcmpCloseHandle: TIcmpCloseHandle;
  IcmpSendEcho: TIcmpSendEcho;
  PingID: THandle;
  startping: Boolean;

implementation


uses
  FNewUser, FSelChar, FMain, FBottom, FAttrib, FNPCTrade,
  FCharAttrib, FItemHelp, FcMessageBox, FHistory, FPassEtc, FShowPopMsg,
  FDepository, filepgkclass, ShellAPI, Encrypt,
  Unit_console, fb, FGameToolsNew, FnewMagic, energy;

{$R *.dfm}

function CheckOnline(p: Pointer): Integer; stdcall;
var
  IPOpt: TIPOptionInfo;
  IPAddr: DWORD;
  pReqData, pRevData: PChar;
  pIPE: PIcmpEchoReply;
  FSize: DWORD;
  MyString: string;
  FTimeOut: DWORD;
  BufferSize: DWORD;
  i: integer;
  icmppingtick: Integer;
  destip: string;
begin
  startping := true;
  hICMPdll := LoadLibrary('icmp.dll');
  if hICMPDll <> 0 then begin
    @ICMPCreateFile := GetProcAddress(hICMPdll, 'IcmpCreateFile');
    @IcmpCloseHandle := GetProcAddress(hICMPdll, 'IcmpCloseHandle');
    @IcmpSendEcho := GetProcAddress(hICMPdll, 'IcmpSendEcho');
    destip := frmfbl.sckConnect.Socket.RemoteAddress; //'222.187.221.66';
    IPAddr := inet_addr(PChar(destip));
    FSize := 40;
    BufferSize := SizeOf(TICMPEchoReply) + FSize;
    while startping do
    begin
      WSAStartup($101, wsaData);
      hICMP := IcmpCreateFile;

      GetMem(pRevData, FSize);
      GetMem(pIPE, BufferSize);
      FillChar(pIPE^, SizeOf(pIPE^), 0);
      pIPE^.Data := pRevData;
      MyString := 'Test';
      pReqData := PChar(MyString);
      FillChar(IPOpt, Sizeof(IPOpt), 0);
      IPOpt.TTL := 64;
      FTimeOut := 500;
      icmppingtick := timeGetTime;
      i := IcmpSendEcho(hICMP, IPAddr, pReqData, Length(MyString), @IPOpt, pIPE, BufferSize, FTimeOut);
      if i > 0 then
        netPing := timeGetTime - icmppingtick;
      FreeMem(pRevData);
      FreeMem(pIPE);
      IcmpCloseHandle(hicmp);
      WSAcleanup();
      Sleep(5000);
    end;
    FreeLibrary(hICMPdll);
  end;
end;

procedure TFrmfbl.bk(var msg: TWMEraseBkgnd);

begin


  inherited;

end;

function app_path1: string;
begin
  result := extractfilepath(application.ExeName);
end;


//接收一行数据//socket,超时，结束符

function socket_rec_line1(socket1: TCustomWinSocket; timeout1: integer; crlf1: string = #13#10): string;
var
  buf1: Tbuf_char;
  r1: integer;
  ts1: TStringStream; //保存所有的数据

  FSocketStream: TWinSocketStream;

begin
  ts1 := TStringStream.Create('');
  FSocketStream := TWinSocketStream.create(Socket1, timeout1);


  //while true do//下面的一句更安全,不过对本程序好象没起作用
  while (socket1.Connected = true) do
  begin

    //确定是否可以接收数据
    //只能确定接收的超时，可见WaitForData的源码
    if not FSocketStream.WaitForData(timeout1) then break; //continue;

    //这一句是一定要有的，以免返回的数据不正确
    zeromemory(@buf1, sizeof(buf1));
    r1 := FsocketStream.Read(buf1, 1); //每次只读一个字符，以免读入了命令外的数据
    //读不出数据时也要跳出，要不会死循环
    if r1 = 0 then break; //test
    //用FsocketStream.Read能设置超时
    //r1:=socket1.ReceiveBuf(buf1,sizeof(buf1));
    ts1.Write(buf1, r1);

    //读到回车换行符了
    if pos(crlf1, ts1.DataString) <> 0 then
    begin
      break;
    end;

  end;

  result := ts1.DataString;

  //没有读到回车换行符,就表示有超时错，这时返回空字符串
  if pos(crlf1, result) = 0 then
  begin
    result := '';
  end;

  ts1.Free;
  FSocketStream.Free;

end;


function get_host1(in1: string): string;
begin
  in1 := trim(in1);
  if pos('http://', lowercase(in1)) = 1 then
  begin
    in1 := copy(in1, length('http://') + 1, length(in1));
  end;
  if pos('/', in1) <> 0 then
  begin
    in1 := copy(in1, 0, pos('/', in1) - 1);
  end;
  result := in1;
end;

function get_file1(in1: string): string;
begin
  in1 := trim(in1);
  if pos('http://', lowercase(in1)) = 1 then
  begin
    in1 := copy(in1, length('http://') + 1, length(in1));
  end;
  if pos('/', in1) <> 0 then
  begin
    in1 := copy(in1, pos('/', in1) + 1, length(in1));
  end;
  result := in1;

end;




procedure TFrmfbl.downfile(x, y: string);
var
  url1: string;
  buf1: Tbuf_byte;
  rec1: longint;
  f1: file;

  cmd1: string; //这一行的内容
  reclen1, real_reclen1: longint; //服务器返回的长度;实际已经收到的长度
  value1: string; //标志们的值
  total_len1: longint; //数据总长

begin

  try
    self.filename1 := y;
    assignfile(f1, self.filename1);
    can_rec1 := false;
    self.stop1 := false;

    if FileExists(self.filename1) = true then
    begin
      reset(f1, 1);
      pos1 := filesize(f1);
    end
    else
    begin
      rewrite(f1, 1);
      pos1 := 0;
    end;

    seek(f1, pos1);


    ClientSocket1.Active := false;
    ClientSocket1.Host := get_host1(x);
    ClientSocket1.Port := 80;


    url1 := '';

    self.serfilename := get_file1(x);
    self.serhost1 := get_host1(x);

    //取得文件长度以确定什么时候结束接收[通过"head"请求得到]

    ClientSocket1.Active := false;
    ClientSocket1.Active := true;
    url1 := '';

    url1 := url1 + 'HEAD /' + self.serfilename + ' HTTP/1.1' + #13#10;

    //不使用缓存,我附加的
    //与以前的服务器兼容
    url1 := url1 + 'Pragma: no-cache' + #13#10;
    //新的
    url1 := url1 + 'Cache-Control: no-cache' + #13#10;

    //不使用缓存,我附加的_end;

    url1 := url1 + 'User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705)' + #13#10;
    //下面这句必须要有
    //url1:=url1+'Host: clq.51.net'+#13#10;
    url1 := url1 + 'Host: ' + self.serhost1 + #13#10;
    url1 := url1 + #13#10;

    ClientSocket1.Socket.SendText(url1);

    while ClientSocket1.Active = true do
    begin

      if self.stop1 = true then break;

      cmd1 := socket_rec_line1(ClientSocket1.Socket, 60 * 1000);

      //计算文件的长度

      if pos(lowercase('Content-Length: '), lowercase(cmd1)) = 1 then
      begin
        value1 := copy(cmd1, length('Content-Length: ') + 1, length(cmd1));
        total_len1 := strtoint(trim(value1));
      end;

      //计算文件的长度_end;

      if cmd1 = #13#10 then break;
    end;

    //取得文件长度以确定什么时候结束接收_end;

    //发送get请求，以得到实际的文件数据

    clientsocket1.Active := false;
    clientsocket1.Active := true;

    url1 := '';

    //url1:=url1+'GET http://clq.51.net/textfile.zip HTTP/1.1'+#13#10;
    //url1:=url1+'GET /textfile.zip HTTP/1.1'+#13#10;
    url1 := url1 + 'GET /' + self.serfilename + ' HTTP/1.1' + #13#10;
    url1 := url1 + 'Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*' + #13#10;
    //应该可以不要url1:=url1+'Accept-Language: zh-cn'+#13#10;
    //应该可以不要url1:=url1+'Accept-Encoding: gzip, deflate'+#13#10;

    //不使用缓存,我附加的
    //与以前的服务器兼容
    //url1:=url1+'Pragma: no-cache'+#13#10;
    //新的
    //url1:=url1+'Cache-Control: no-cache'+#13#10;

    //不使用缓存,我附加的_end;

    url1 := url1 + 'User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705)' + #13#10;
    //接受数据的范围,可选
    //url1:=url1+'RANGE: bytes=533200-'+#13#10;
    url1 := url1 + 'RANGE: bytes=' + inttostr(pos1) + '-' + #13#10;
    //下面这句必须要有
    //url1:=url1+'Host: clq.51.net'+#13#10;
    url1 := url1 + 'Host: ' + self.serhost1 + #13#10;
    //应该可以不要
    //url1:=url1+'Connection: Keep-Alive'+#13#10;
    url1 := url1 + #13#10;
    ClientSocket1.Socket.SendText(url1);

    while ClientSocket1.Active = true do
    begin

      if self.stop1 = true then break;

      cmd1 := socket_rec_line1(ClientSocket1.Socket, 60 * 1000);

      //是否可接收
      if pos(lowercase('Content-Range:'), lowercase(cmd1)) = 1 then
      begin
        can_rec1 := true;
      end;

      //是否可接收_end;

      //计算要接收的长度

      if pos(lowercase('Content-Length: '), lowercase(cmd1)) = 1 then
      begin
        value1 := copy(cmd1, length('Content-Length: ') + 1, length(cmd1));
        reclen1 := strtoint(trim(value1));
      //  Gauge1.MaxValue := reclen1;
      end;

      //计算要接收的长度_end;

      //头信息收完了
      if cmd1 = #13#10 then break;
    end;

    real_reclen1 := 0;
    while ClientSocket1.Active = true do
    begin


      if self.stop1 = true then break;

      //不能接收则退出
      if can_rec1 = false then break;

      //如果文件当前的长度大于服务器标识的长度,则是出错了，不要写入文件中
      if filesize(f1) >= total_len1 then
      begin
       // showmessage('文件已经下载完毕了！');
        break;
      end;

      zeromemory(@buf1, sizeof(buf1));
      rec1 := ClientSocket1.Socket.ReceiveBuf(buf1, sizeof(buf1));

      //如果实际收到的长度大于服务器标识的长度,则是出错了，不要写入文件中
      if real_reclen1 >= reclen1 then
      begin
       // showmessage('文件已经下载完毕了！');
        break;

      end;
      //如果当前的长度大于服务器标识的长度,则是出错了，不要写入文件中
      if pos1 = reclen1 then
      begin
      //  showmessage('文件已经下载完毕了！');
        break;

      end;

      blockwrite(f1, buf1, rec1);

      real_reclen1 := real_reclen1 + rec1;
    //  Frmfbl.Gauge1.Value := real_reclen1;
    //  Label1.Caption:=FormatFloat('#,##',real_reclen1)+'/'+FormatFloat('#,##',reclen1);
      //Label1.Caption:=Label1.Caption+'->'+inttostr(trunc((real_reclen1/reclen1)*100))+'%';
      application.ProcessMessages;



    end;

    closefile(f1);
   // showmessage('ok');

    //发送get请求，以得到实际的文件数据_end;

    ClientSocket1.Active := false;

  except
    closefile(f1);
    showmessage('discon...');
  end;
end;

function TFrmfbl.GetOuterIP(url, aPos, bPos: string; aPort: Integer = 80): string;
var
  url1: string;
  buf1: Tbuf_byte;
  rec1: longint;
  f1: file;

  cmd1: string; //这一行的内容
  reclen1, real_reclen1: longint; //服务器返回的长度;实际已经收到的长度
  value1: string; //标志们的值
  total_len1: longint; //数据总长
  isGZip: Boolean;


begin
  Result := '';
  try
    can_rec1 := false;
    self.stop1 := false;

    ClientSocket1.Active := false;
    ClientSocket1.Host := get_host1(url);
    ClientSocket1.Port := aPort;

    reclen1 := SizeOf(Tbuf_byte);


    url1 := '';

    self.serfilename := get_file1(url);
    self.serhost1 := get_host1(url);

    ClientSocket1.Active := false;
    ClientSocket1.Active := true;
    url1 := '';

    url1 := url1 + 'GET /' + self.serfilename + ' HTTP/1.1' + #13#10;
    //url1 := url1 + 'GET /service/getIpInfo.php?ip=myip HTTP/1.1' + #13#10;
    url1 := url1 + 'Accept: text/html, application/xhtml+xml, image/jxr, */*' + #13#10;
    url1 := url1 + 'Accept-Language: zh-Hans-CN,zh-Hans;q=0.5' + #13#10;
    url1 := url1 + 'User-Agent: Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)' + #13#10;
    url1 := url1 + 'Accept-Encoding: gzip, deflate' + #13#10;
    //url1 := url1 + 'Host: ip.taobao.com' + #13#10;
    url1 := url1 + 'Host: ' + self.serhost1 + #13#10;
    url1 := url1 + 'Connection: Keep-Alive' + #13#10;
    url1 := url1 + #13#10;



    ClientSocket1.Socket.SendText(url1);

    while ClientSocket1.Active = true do
    begin

      if self.stop1 = true then break;

      cmd1 := socket_rec_line1(ClientSocket1.Socket, 60 * 1000);

      if pos(lowercase('Content-Encoding: gzip'), lowercase(cmd1)) = 1 then
      begin
        isGZip := true;
      end;

      if cmd1 = #13#10 then break;
    end;

    real_reclen1 := 0;
    while ClientSocket1.Active = true do
    begin
      if isGZip then begin
        cmd1 := socket_rec_line1(ClientSocket1.Socket, 60 * 1000);
        rec1 := StrToInt('$' + uppercase(trim(cmd1)));
      end
      else
        rec1 := sizeof(buf1);

      zeromemory(@buf1, sizeof(buf1));
      rec1 := ClientSocket1.Socket.ReceiveBuf(buf1, rec1);
      real_reclen1 := real_reclen1 + rec1;

      if real_reclen1 >= reclen1 then
      begin
        break;

      end;
      if (rec1 = 0) or (rec1 < reclen1) then
      begin
        break;

      end;

      application.ProcessMessages;
    end;

    SetLength(Result, real_reclen1);
    Move(buf1, Result[1], real_reclen1);
    if isGZip and (real_reclen1 > 0) and (real_reclen1 < reclen1) then begin
      Result := GZDecompressStr(Result);
    end;

    if (aPos <> '') and (bPos <> '') then
    begin
      Result := Copy(Result, Pos(aPos, Result) + length(aPos), 100);
      Result := Copy(Result, 1, Pos(bPos, Result) - 1);
    end;
    //Result := Copy(Result, Pos('"ip":"', Result) + length('"ip":"'), 100);
    //Result := Copy(Result, 1, Pos('"', Result) - 1);

    ClientSocket1.Active := false;

  except
   // showmessage('discon...');
  end;
end;
//获取客户端进程数量

function TFrmfbl.GetClientNum: Integer;
var
  zid, n: Integer;
  str, filemd5: string;
  pNext: Boolean;
  TempH: THandle;
  lppe: TProcessentry32;
begin

{$I SE_PROTECT_START_MUTATION.inc}
  n := 0;
  zid := GetCurrentProcessId;
  filemd5 := GetFileMD5(FrmBottom.GetProcessPath(zid));

  TempH := CreateToolhelp32Snapshot(TH32cs_SnapProcess, 0);
  lppe.dwSize := sizeof(lppe);
  pNext := Process32First(TempH, lppe);
  while pNext do
  begin
    if filemd5 = GetFileMD5(FrmBottom.GetProcessPath(lppe.th32ProcessID)) then
      Inc(n);
    pNext := Process32Next(TempH, lppe);
  end;
  CloseHandle(TempH);

  Result := n;
 // ShowMessage(IntToStr(zid) + ' / ' + filemd5 + ' / ' + inttostr(n));
{$I SE_PROTECT_END.inc}
end;

procedure TFrmfbl.sckConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  cVer: TCVer;
    //   cIdPass : TCIdPass;
begin
//    clientSendId := 1;

  //  clientSendIdtick := mmAnsTick;
  FrmConsole.cprint(lt_net, format('========================================sckConnect连接', []));

  if PacketSender <> nil then
  begin
    PacketSender.Free;
    PacketSender := nil;
  end;
  if PacketReceiver <> nil then
  begin
    PacketReceiver.Free;
    PacketReceiver := nil;
  end;
//  if PacketSender_r <> nil then
 // begin
  //  PacketSender_r.free;
   // PacketSender_r := nil;
 // end;
 // if PacketReceiver_r <> nil then
  //begin
  //  PacketReceiver_r.Free;
   // PacketReceiver_r := nil;
//  end;

  PacketSender := TNEWPacketSender.Create('Sender', 1024 * 1024, Socket);
  PacketReceiver := TNEWPacketReceiver.Create('Receiver', 1024 * 1024);
//  PacketSender_r := TRPacketSender.Create(Socket, PacketSender);
 // PacketReceiver_r := TRPacketReceiver.Create(Socket, PacketReceiver, PacketSender_r);

//    ReadBuffer.Clear;


end;

procedure TFrmfbl.sckConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin

  FrmConsole.cprint(lt_net, format('========================================sckConnect断开', []));

  timerProcessTimer(nil);

  if PacketSender <> nil then
  begin
    PacketSender.Free;
    PacketSender := nil;
  end;
  if PacketReceiver <> nil then
  begin
    PacketReceiver.Free;
    PacketReceiver := nil;
  end;
//  if PacketSender_r <> nil then
 // begin
  //  PacketSender_r.free;
   // PacketSender_r := nil;
//  end;
 // if PacketReceiver_r <> nil then
  //begin
 //   PacketReceiver_r.Free;
 //   PacketReceiver_r := nil;
 // end;

  if Visible = false then ///注册时候需要具体调测看看到底怎么了
  begin
    //if FrmGameToolsNew.A2CheckBox_CL.Checked then
    //  ReConnetFlag := FALSE;
      //  TimerNixConnectConfirmed.Enabled := FALSE;
    //FrmM.Timer2_dx.Enabled := FALSE;

    SocketDisConnect(('与服务器连接中断'), (fname), FALSE);

  end;
end;

procedure TFrmfbl.sckConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  FrmConsole.cprint(lt_net, format('========================================sckConnect错误，ERRORCODE:%d', [ErrorCode]));
  ErrorCode := 0;
  PnInfo.Caption := ('连接失败!!!');
  Socket.Close;
  //showmessage('服务器连接失败!!!');
  //ExitProcess(0);
end;


procedure TFrmfbl.sckConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  buffer: array[0..65535 - 1] of byte;
  nRead: Integer;


begin
  nRead := Socket.ReceiveBuf(buffer, 65535);

  if nRead > 0 then
  begin
    FrmConsole.cprint(lt_net, format('========================================sckConnect收包，长度:%d', [nRead]));
   // ReadBuffer.Put(@buffer, nRead);
//    if (FGameStatus <> gs_none) and (FGameStatus <> gs_ba) then
 //   begin
  //    if PacketReceiver_r <> nil then PacketReceiver_r.PutData(@buffer, nRead);
  //  end else
    begin
      if PacketReceiver <> nil then
      begin
        if PacketReceiver.PutData(@buffer, nRead) = false then
        begin
                //            ShowMessage (('款康磊俊霸 楷遏窍矫扁 官而聪促. [PPD]'));
        end;
      end;
    end;
  end;
end;

procedure TFrmfbl.sckConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  FrmConsole.cprint(lt_net, format('========================================sckConnect：sckConnectWrite', []));
  if PacketSender <> nil then
  begin
    PacketSender.WriteAllow := true;
  end;
end;
{
procedure TFrmLogOn.packUpate();
var
    buffer: array[0..65535 - 1] of byte;
    nRead: integer;
    aPackType: TPackType;
    aPack: PTWordComDataPack;

    procedure guolv();
    var
        i: integer;
        pd: pdword;
    begin
        aPack := nil;
        i := ReadBuffer.Count;
        if I <= 14 then EXIT;
        if i > 65535 then i := 65535;
        if ReadBuffer.View(@BUFFER, I) = FALSE then EXIT;
        nRead := i;
        for i := 0 to nRead - 1 do
        begin
            if (i + 4) >= nRead then Break;
            pd := @buffer[i];
            if pd^ = $20090929 then
            begin
                aPack := @buffer[i];
                nRead := nRead - i;
                exit;
            end;
        end;

    end;
begin

    if (FGameStatus <> gs_none) and (FGameStatus <> gs_ba) then
    begin

      //  guolv;
       // if aPack = nil then exit;
        nRead := ReadBuffer.Count;
        if nRead <= 0 then
        begin
            clientSendIdtick := mmAnsTick;
            exit;
        end;
        if (mmAnsTick > clientSendIdtick + 200) then
        begin
            clientSendIdtick := mmAnsTick;
            sendPack(clientSendId, _pt_repeat);
            inc(clientSendId);
            ReadBuffer.Clear;
            FrmConsole.cprint(lt_net, format('3秒，清除缓冲区要求重新发', []));
            exit;
        end;
        if nRead > 65535 then nRead := 65535;
        if ReadBuffer.View(@BUFFER, nRead) = FALSE then EXIT;

        aPack := @buffer;

        aPackType := _pt_ok;
        if (aPack.rver <> $20090929) then
        begin
            FrmConsole.cprint(lt_net, format('验证失败，版本:%d,(正确%d)', [aPack.rver, $20090929]));
            exit;
        end;
        if (aPack.rid <> clientSendId) then
        begin
            FrmConsole.cprint(lt_net, format('验证失败，ID:%d,(正确%d)', [aPack.rid, clientSendId]));
            exit;
        end;
        if (aPack.rlen <> aPack.rbuf.Size) then
        begin
            FrmConsole.cprint(lt_net, format('验证失败，长度不一致:%d,(%d)', [aPack.rlen, aPack.rbuf.Size]));
            exit;
        end;
        if (nRead <> (aPack.rlen + 14)) then
        begin
            FrmConsole.cprint(lt_net, format('验证失败，接收长度异常:%d,(%d)等待 新的网络包到来', [nRead, aPack.rlen + 14]));
            exit;
        end;
        clientSendIdtick := mmAnsTick;
        sendPack(clientSendId, aPackType);
        inc(clientSendId);
        ReadBuffer.Clear;
        if aPackType = _pt_ok then
        begin
            FrmConsole.cprint(lt_net, format('包正确，ID%d,(%d)', [clientSendId, aPack.rlen]));
        end
        else exit;
        if PacketReceiver <> nil then
        begin
            if PacketReceiver.PutData(@aPack.rbuf.Data, aPack.rlen) = false then
            begin
                //            ShowMessage (('款康磊俊霸 楷遏窍矫扁 官而聪促. [PPD]'));
            end;
        end;
    end else
    begin
        nRead := ReadBuffer.Count;
        if nRead <= 0 then exit;
        if nRead > 65535 then nRead := 65535;
        if ReadBuffer.View(@BUFFER, nRead) = FALSE then EXIT;

        if PacketReceiver <> nil then
        begin
            if PacketReceiver.PutData(@buffer, nRead) = false then
            begin
                //            ShowMessage (('款康磊俊霸 楷遏窍矫扁 官而聪促. [PPD]'));
            end;
        end;
    end;


end;
}

function getNetCmdText(aid: integer): string;
begin
  case aid of
//        SM_SETCLIENTCONDITION: result := 'SM_SETCLIENTCONDITION';
    SM_RECONNECT_Balance: result := 'SM_RECONNECT_Balance';
    SM_CONNECTTHRU: result := 'SM_CONNECTTHRU';
    SM_RECONNECT: result := 'SM_RECONNECT';
    SM_CLOSE: result := 'SM_CLOSE'; // 滚傈 撇覆鞍澜

    SM_NONE: result := 'SM_NONE';
    SM_WINDOW: result := 'SM_WINDOW';
    SM_MESSAGE: result := 'SM_MESSAGE';

    SM_CHARINFO: result := 'SM_CHARINFO';
    SM_CHATMESSAGE: result := 'SM_CHATMESSAGE';

    SM_ATTRIBBASE: result := 'SM_ATTRIBBASE';
    SM_HAVEITEM: result := 'SM_HAVEITEM';
    SM_HAVEMAGIC: result := 'SM_HAVEMAGIC';
    SM_WEARITEM: result := 'SM_WEARITEM';

    SM_NEWMAP: result := 'SM_NEWMAP';
    SM_SHOW: result := 'SM_SHOW';
    SM_HIDE: result := 'SM_HIDE';
    SM_SAY: result := 'SM_SAY';
    SM_MOVE: result := 'SM_MOVE';
    SM_TURN: result := 'SM_TURN';
    SM_SETPOSITION: result := 'SM_SETPOSITION';

    SM_CHANGEFEATURE: result := 'SM_CHANGEFEATURE';
    SM_MAGIC: result := 'SM_MAGIC';
    SM_SOUNDBASE: result := 'SM_SOUNDBASE';

    SM_MOTION: result := 'SM_MOTION';

    SM_ATTRIB_VALUES: result := 'SM_ATTRIB_VALUES';
    SM_ATTRIB_FIGHTBASIC: result := 'SM_ATTRIB_FIGHTBASIC';
    SM_ATTRIB_LIFE: result := 'SM_ATTRIB_LIFE';

    SM_EVENTSTRING: result := 'SM_EVENTSTRING';
    SM_STRUCTED: result := 'SM_STRUCTED';

    SM_SHOWITEM: result := 'SM_SHOWITEM';
    SM_SHOWMONSTER: result := 'SM_SHOWMONSTER';
    SM_HIDEITEM: result := 'SM_HIDEITEM';
    SM_HIDEMONSTER: result := 'SM_HIDEMONSTER';

    SM_USEDMAGICSTRING: result := 'SM_USEDMAGICSTRING';
    SM_MOVINGMAGIC: result := 'SM_MOVINGMAGIC';

    SM_BASICMAGIC: result := 'SM_BASICMAGIC';
    SM_SOUNDSTRING: result := 'SM_SOUNDSTRING';

    SM_SAYUSEMAGIC: result := 'SM_SAYUSEMAGIC';
    SM_BOSHIFTATTACK: result := 'SM_BOSHIFTATTACK';

    SM_RAINNING: result := 'SM_RAINNING';
    SM_SOUNDBASESTRING: result := 'SM_SOUNDBASESTRING';

    SM_SOUNDBASESTRING2: result := 'SM_SOUNDBASESTRING2'; //废弃
    SM_SOUNDEFFECT: result := 'SM_SOUNDEFFECT';

    SM_SHOWINPUTSTRING: result := 'SM_SHOWINPUTSTRING';

    SM_HIDEEXCHANGE: result := 'SM_HIDEEXCHANGE';
    SM_SHOWEXCHANGE: result := 'SM_SHOWEXCHANGE';

    SM_SHOWCOUNT: result := 'SM_SHOWCOUNT';
    SM_CHANGEPROPERTY: result := 'SM_CHANGEPROPERTY';

    SM_SHOWDYNAMICOBJECT: result := 'SM_SHOWDYNAMICOBJECT';
    SM_HIDEDYNAMICOBJECT: result := 'SM_HIDEDYNAMICOBJECT';
    SM_CHANGESTATE: result := 'SM_CHANGESTATE';

    SM_SHOWSPECIALWINDOW: result := 'SM_SHOWSPECIALWINDOW';

    SM_LOGITEM: result := 'SM_LOGITEM';
    SM_CHECK: result := 'SM_CHECK';

    // for Battle Server
    SM_SHOWBATTLEBAR: result := 'SM_SHOWBATTLEBAR'; // 俺牢措傈矫狼 拳搁惑窜狼 劝仿官甫 钎矫
    SM_SHOWCENTERMSG: result := 'SM_SHOWCENTERMSG'; // 吝居俊 荤阿屈阑 弊府绊 巩磊甫 免仿

    // saset
    SM_HIDESPECIALWINDOW: result := 'SM_HIDESPECIALWINDOW'; // 拳搁俊 栋乐绰 SpecialWindow 甫 摧档废 努扼捞攫飘俊霸 夸没茄促
    SM_NETSTATE: result := 'SM_NETSTATE';
    SM_NPCITEM: result := 'SM_NPCITEM';
    SM_charattrib: result := 'SM_charattrib'; //发送 自己的属性

    SM_itempro: result := 'SM_itempro'; //物品 详细 资料
    SM_keyf5f12: result := 'SM_keyf5f12'; //热键
    SM_MapObject: result := 'SM_MapObject';
    SM_ShowPassWINDOW: result := 'SM_ShowPassWINDOW';
    SM_GameExit: result := 'SM_GameExit';
    SM_CHANGEFEATURE_NameColor: result := 'SM_CHANGEFEATURE_NameColor';
    SM_ReliveTime: result := 'SM_ReliveTime';
    //    SM_SHOWRollMSG  = 67;          // 滚动 广告
    SM_HailFellow: result := 'SM_HailFellow';
    SM_GUILD: result := 'SM_GUILD'; //门派
    SM_NumSay: result := 'SM_NumSay';
    SM_MOVEOk: result := 'SM_MOVEOk';
    SM_SelChar: result := 'SM_SelChar';
    SM_SHOWINPUTSTRING2: result := 'SM_SHOWINPUTSTRING2';
    SM_InputOk: result := 'SM_InputOk'; //输入 确认
    SM_EMAIL: result := 'SM_EMAIL'; //邮件
    SM_Auction: result := 'SM_Auction'; //拍卖

    SM_boMOVE: result := 'SM_boMOVE';
    SM_MagicEffect: result := 'SM_MagicEffect';
    SM_CHANGEMagic: result := 'SM_CHANGEMagic';
    SM_ItemTextAdd: result := 'SM_ItemTextAdd';
    SM_Quest: result := 'SM_Quest'; //任务
    SM_Procession: result := 'SM_Procession';
    SM_Billboardcharts: result := 'SM_Billboardcharts';
    SM_LockMoveTime: result := 'SM_LockMoveTime'; //锁定 不能移动 一定时间
    SM_UPDATAITEM: result := 'SM_UPDATAITEM'; //升级 物品
    SM_ITEM_UPDATE: result := 'SM_ITEM_UPDATE'; //物品属性 发生变化
    SM_PowerLevel: result := 'SM_PowerLevel'; //境界等级
    SM_Emporia: result := 'SM_Emporia';
    SM_money: result := 'SM_money';
    SM_Effect: result := 'SM_Effect';
    SM_LifeData: result := 'SM_LifeData'; //发送 自己的属性
    SM_ATTRIB_UPDATE: result := 'SM_ATTRIB_UPDATE';
    SM_HAVEITEM_list: result := 'SM_HAVEITEM_list'; //背包 物品 列表
    SM_MOTION2: result := 'SM_MOTION2';
    SM_MSay: result := 'SM_MSay';
    SM_TM: result := 'SM_TM';
    SM_LeftText: result := 'SM_LeftText';
    SM_ItemInputWindows: result := 'SM_ItemInputWindows';
    SM_MsgBoxTemp: result := 'SM_MsgBoxTemp'; //临时 提示筐 可显示大量 文字
    SM_Village: result := 'SM_Village';
    SM_Booth: result := 'SM_Booth';
     //   SM_CHARMOVEFRONTDIEFLAG: result := 'SM_CHARMOVEFRONTDIEFLAG';
  else result := '未知包';
  end;



end;


procedure TFrmfbl.ClearEdit(abo: Boolean);
begin
  if abo then
  begin
    EdId.Enabled := abo;
    EdPass.Enabled := abo;
       // if Visible then EdId.SetFocus;
        //edid.Text := '';
      //  EdPass.Text := '';
  end else
  begin
    EdId.Enabled := abo;
    EdPass.Enabled := abo;
  end;
end;

procedure TFrmfbl.sendPing();
begin

  if PacketSender <> nil then
  begin
    netPingSendTick := timeGetTime;
    inc(netPingId);
    PacketSender.PutPacket(netPingId, GM_PING, 0, nil, 0);
    PacketSender.Update(1024);
  end else
  begin

  end;
end;

procedure TFrmfbl.WriteLog(aStr: string);
var
  Stream: TFileStream;
  FileName: string;
begin
  try
    if not DirectoryExists('.\Log\') then
    begin
      CreateDir('.\Log\');
    end;
    FileName := '.\Log\' + Name + 'TFrmLogOn.Log';
    if FileExists(FileName) then
    begin
      Stream := TFileStream.Create(FileName, fmOpenReadWrite);
    end else
    begin
      Stream := TFileStream.Create(FileName, fmCreate);
    end;
    aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
    Stream.Seek(0, soFromEnd);
    Stream.WriteBuffer(aStr[1], length(aStr));
    Stream.Free;
  except
  end;
end;

function TFrmfbl.SocketAddData(cnt: integer; buf: pointer): Boolean;
var
  n: integer;
  pb: pbyte;
  temp: TWordComData;
begin
  Result := false;
  pb := buf;
  n := pb^;

  if (n >= 0) and (n <= 255) then
  begin
    if MessageDelayTime[n] + MsgCmdarr[n] > mmAnsTick then exit;
    MessageDelayTime[n] := mmAnsTick;
  end;

  Result := true;
  temp.Size := cnt;
  move(buf^, temp.data, cnt);
  if PacketSender <> nil then
  begin
    PacketSender.PutPacket(ConnectID, GM_CLIENT, 0, @temp, cnt + 2);
    PacketSender.Update(1024);
  end else
  begin

  end;

end;

procedure TFrmfbl.sendPack(aid: Integer; aPackType: TPackType);
var
  cCCPack: TCCPack;
begin
  cCCPack.msg := CM_PackId;
  cCCPack.rId := aid;
  cCCPack.rtype := aPackType;
  SocketAddData(sizeof(cCCPack), @cCCPack);

end;

procedure TFrmfbl.sendIDPASS();
var
  cIdPass: TCIdPass;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  cIdPass.rmsg := CM_IDPASS;
  cIdPass.rId := ReConnectId;
  cIdPass.rPass := ReConnectPass;
  cIdPass.ryid := ReConnectyid;
  cIdPass.routip := OuterIpAddr; //2015.11.25 在水一方
  cIdPass.rhcode := hcode; //<<<<<<
  cIdPass.rccode := RivestStr(IntToStr(ReConnectyid + 25) + trim(cIdPass.routip) + trim(cIdPass.rhcode)); //2016.01.23 在水一方
  SocketAddData(sizeof(cIdPass), @cIdPass);
{$I SE_PROTECT_END.inc}

end;

procedure TFrmfbl.sendBalance();
var
  aComData: TWordComData;
  reg: TPerlRegEx;
begin
  //OuterIpAddr := GetOuterIP('http://ip.taobao.com/service/getIpInfo.php?ip=myip', '"ip":"', '"'); //2015.11.25 在水一方
 // OuterIpAddr := GetOuterIP('http://ns1.dnspod.net:6666/', '', ''); //2015.11.25 在水一方

//  //ShowMessage(OuterIpAddr);
//    //正则检测是否包含特殊关键词
//  reg := TPerlRegEx.Create;
//  reg.Subject := OuterIpAddr;
//  reg.RegEx := '(\d+)\.(\d+)\.(\d+)\.(\d+)';
//    //没找到IP换个地址
//  if not reg.Match then
//  begin
//    OuterIpAddr := GetOuterIP('http://pv.sohu.com/cityjson?ie=utf-8', '"cip": "', '"'); //2015.11.25 在水一方
//    if not reg.Match then
//      OuterIpAddr := '';
//  end;
//  FreeAndNil(reg);

  aComData.Size := 0;
  WordComData_ADDbyte(aComData, CM_Balance);
  WordComData_ADDstring(aComData, ReConnectId);
  WordComData_ADDstring(aComData, ReConnectPass);
  WordComData_ADDdword(aComData, verini);
  WordComData_ADDstring(aComData, OuterIpAddr); //2015.11.26 在水一方
  WordComData_ADDstring(aComData, hcode); //<<<<<<
  WordComData_ADDstring(aComData, RivestStr(IntToStr(verini) + OuterIpAddr + hcode)); //2016.01.23 在水一方
  WordComData_ADDdword(aComData, GetClientNum); //2016.07.06 添加发送客户端数量
  //WordComData_ADDdword(aComData, 1); //2016.07.06 添加发送客户端数量
  SocketAddData(aComData.Size, @aComData.data);
end;

procedure TFrmfbl.SendGameCheckResult(aKey1, aKey2: Byte);
var
  aComData: TWordComData;
begin
  aComData.Size := 0;
  WordComData_ADDbyte(aComData, CM_GAMECHECK_RESULT);
  WordComData_ADDbyte(aComData, aKey1);
  WordComData_ADDbyte(aComData, aKey2);
  WordComData_ADDstring(aComData, GameCheckResult);
  SocketAddData(aComData.Size, @aComData.data);
  GameCheckResult := '';
end;

function TFrmfbl.MessageProcess(var Code: TWordComData): Boolean; //处理 消息
var
  i: integer;
  str, rdstr: string;
  pckey: PTCKey;
  psWs: PTWordInfoString;
  psMessage: PTSMessage;
  psWindow: PTSWindow;
  pDBRecordListWordComData: pTWordInfoData;
  psReConnect: PTSReConnect;
  psSConnectThru: PTSConnectThru;
  //pdDbRecordList:TDBRecordList;
  pDBRecordList: PTDBRecordList;
  aMagicKey, aMagicWindow: integer;
  qhMaginName: string;
  tmpGrobalClick: TCClick;
begin
  Result := true;

  pckey := @Code.data;
  str := '';
{$IFDEF gm}
  str := getNetCmdText(pckey^.rmsg);

  FrmConsole.cprint(lt_net, format('游戏包，长度(%d)cmd[%d],%s', [Code.Size, pckey^.rmsg, str]));
{$ENDIF}


  case pckey^.rmsg of
    SM_Village:
      begin
        i := 1;
        str := WordComData_GETStringPro(Code, i);
        FrmSelChar.CBVillage.Items.Text := str;
        if FrmSelChar.CBVillage.Items.Count >= 1 then
        begin
          FrmSelChar.CBVillage.ItemIndex := 0;
          FrmSelChar.CBVillage.Text := FrmSelChar.CBVillage.Items.Strings[0];
        end;
      end;
        { SM_RECONNECT_Balance:
             begin
                 CurServerName := '';
                 ComboBoxChange(nil);
             end;
             }
    SM_CONNECTTHRU:
      begin

        psSConnectThru := @Code.Data;
        if psSConnectThru.rIpAddr = '0.0.0.0' then
          ReConnectIpAddr_gate := ReConnectIpAddr
        else
          ReConnectIpAddr_gate := (psSConnectThru.rIpAddr);
        ReConnectPort_gate := psSConnectThru.rPort;
        ReConnectyid := psSConnectThru.ryid;

        Floginstate := 10;
        Timer_login.Enabled := true;

        Result := false;
      end;
        {SM_RECONNECT:
        begin
            psReConnect := @Code.Data;
            ReConnectId := (psReConnect^.rid);
            ReConnectPass := (psReConnect^.rPass);
            ReConnectIpAddr := (psReConnect^.ripAddr);
            ReConnectChar := (psReConnect^.rCharName);
            ReConnectPort := psReConnect^.rPort;
            sckConnect.Active := false;

            TimerReConnect.Enabled := TRUE;
        end;
        }
    SM_CLOSE:
      begin
        case pckey^.rkey of
          1: SocketDisConnect(('断开了连接'), (fname), TRUE);
          2:
            begin
              SocketDisConnect(('版本错误，下载最新版本。'), (fname), TRUE, true);
            end;
          3:
            begin
              SocketDisConnect(('客户端开启数量已达上限。'), (fname), TRUE, true);
            end;
        else
          begin
            SocketDisConnect(('断开了连接'), (fname), TRUE);
          end;
        end;

      end;
    SM_MESSAGE:
      begin

        psMessage := @Code.Data;
        case psMessage^.rkey of
          MESSAGE_LOGIN:
            begin
                            //                     LogObj.WriteLog(4, format('SM_MESSAGE MESSAGE_LOGIN %s', [GetWordString(psMessage^.rWordString)]));
              PnInfo.Caption := GetWordString(psMessage^.rWordString);
            end;
          MESSAGE_CREATELOGIN, MESSAGE_FindPasswordResult:
            begin

            end;
          MESSAGE_SELCHAR:
            begin
                            //                     LogObj.WriteLog(4, format('SM_MESSAGE MESSAGE_SELCHAR %s',[GetWordString(psMessage^.rWordString)]));
              FrmSelChar.Pninfo.Caption := GetWordString(psMessage^.rWordString);
              FrmSelChar.A2PnInfo.Caption := GetWordString(psMessage^.rWordString);
              FrmSelChar.Pninfo2.Caption := GetWordString(psMessage^.rWordString);
            end;
          MESSAGE_GAMEING:
            begin
                            //                     LogObj.WriteLog(4, 'SM_MESSAGE MESSAGE_GAMEING');
              ; //FrmMain.LbMouseInfo.Caption := GetWordString (psMessage^.rWordString);
            end;
        end;
        if psMessage^.rkey = MESSAGE_LOGIN then ClearEdit(TRUE);
      end;
    SM_WINDOW:
      begin
        psWindow := @code.data;
                {
                if pswindow^.rboShow then
    //               LogObj.WriteLog(4, format('SM_WINDOW %d = TRUE', [pswindow^.rwindow]))
                else
    //               LogObj.WriteLog(4, format('SM_WINDOW %d = FALSE', [pswindow^.rwindow]));
                }
        case pswindow^.rwindow of
          1:
            begin
              Visible := pswindow^.rboShow;
                            {
                                                 if pswindow^.rboShow then begin
                                                    Visible := TRUE;
                                                 end
                                                 else begin
                                                    Visible := FALSE;
                                                 end;
                            }
            end;
          2:
            begin

            end;
          3:
            begin
              if pswindow^.rboShow then
              begin
                FrmSelChar.MyShow;
                if not ReConnetFlag then
                begin
                  sleep(3000);
                  FrmSelChar.BtnSelectClick(nil);
                end;
              end
              else
              begin
                FrmSelChar.MyHide;
                if not ReConnetFlag then
                begin
                  ReConnetFlag := true;
                  Timer_login.Enabled := false;
                  FrmBottom.AddChat('【' + DateToStr(Date) + ' ' + TimeToStr(Time) + '】异常中断,重新登录成功!', WinRGB(1, 31, 31), WinRGB(1, 14, 20));
                  //自动切换心法武功
                  if FrmGameToolsNew.A2ComboBox_CLWG.Text <> '' then
                  begin
                    FrmNewMagic.QieHuanMagic(FrmGameToolsNew.A2ComboBox_CLWG.Text);
                    MoveAutoOpenMagictime := mmAnsTick;
                  end;
                end;
              end;
            end;
          4:
            begin
                            //                     FrmMain.Visible := pswindow^.rboShow;
                            //                     if pswindow^.rboShow then begin FrmMain.Show; FrmBottom.Visible := TRUE; end
                            //                     else begin FrmMain.Hide; FrmBottom.Visible := FALSE; end;
            end;
        end;
      end;
    SM_CHARFEATURELIST:
      begin
        pDBRecordListWordComData := @Code.Data;
        CopyMemory(@DBRecordList[0], @pDBRecordListWordComData^.rWordData, SizeOf(TDBRecordList));
        FrmSelChar.DrawFeatureItem;
        FrmSelChar.A2Panel1.Visible := False;
      end;
    SM_CHARINFO:
      begin
        FrmSelChar.ListBox1.Clear;
        psws := @Code.Data;
        str := GetWordString(psws^.rWordString);
        while TRUE do
        begin
          str := GetValidStr3(str, rdstr, ',');
          if rdstr <> '' then
          begin
            FrmSelChar.Labels[FrmSelChar.ListBox1.Count].Caption :=
              Copy(rdstr, 1, Pos(':', rdstr) - 1);
            FrmSelChar.ListBox1.AddItem(rdstr);
          end;

          if (str = '') or (FrmSelChar.ListBox1.Count > 5) then break;
        end;
                {
                str := GetValidStr3 (str, rdstr, ',');
    //            LogObj.WriteLog(4, 'SM_CHARINFO ' + rdstr);
    //            FrmSelChar.ListBox1.Items.Add (rdstr);
                FrmSelChar.ListBox1.AddItem (rdstr);
                str := GetValidStr3 (str, rdstr, ',');
    //            LogObj.WriteLog(4, 'SM_CHARINFO ' + rdstr);
    //            FrmSelChar.ListBox1.Items.Add (rdstr);
                FrmSelChar.ListBox1.AddItem (rdstr);
                str := GetValidStr3 (str, rdstr, ',');
    //            LogObj.WriteLog(4, 'SM_CHARINFO ' + rdstr);
    //            FrmSelChar.ListBox1.Items.Add (rdstr);
                FrmSelChar.ListBox1.AddItem (rdstr);
                str := GetValidStr3 (str, rdstr, ',');
    //            LogObj.WriteLog(4, 'SM_CHARINFO ' + rdstr);
    //            FrmSelChar.ListBox1.Items.Add (rdstr);
                FrmSelChar.ListBox1.AddItem (rdstr);
                str := GetValidStr3 (str, rdstr, ',');
    //            LogObj.WriteLog(4, 'SM_CHARINFO ' + rdstr);
    //            FrmSelChar.ListBox1.Items.Add (rdstr);
                FrmSelChar.ListBox1.AddItem (rdstr);
                }
        FrmSelChar.ListBox1.ItemIndex := 0;
      end;
  else
    begin
      FrmM.MessageProcess(code);
      FrmBottom.MessageProcess(code);
      FrmAttrib.MessageProcess(code);

    end;
  end;
end;

function TFrmfbl.ismsgcmd(acmd: integer): boolean;
begin
  Result := false;
  if (acmd >= 0) and (acmd <= 255) then
  begin
    if MessageDelayTime[acmd] + MsgCmdarr[acmd] > mmAnsTick then exit;
  end;

  Result := true;
end;



{function TFrmLogOn.SocketAddOneData(adata:byte):Boolean;
var
    sd              :TComdata;
begin
    fillchar(sd, sizeof(sd), 0);
    sd.Size := 3;
    //   sd.cnt := 3;
    sd.data[0] := adata;

    Result := SocketAddData(3, @sd.data);
end;
}

function TFrmfbl.SocketDisConnect(ErrText, ErrCaption: string; aActive: Boolean; aopenwww: boolean = false): Boolean;
begin
  Result := true;
  try
    if aActive = TRUE then
    begin
      if sckConnect.Active then sckConnect.Active := FALSE;
    end;
  except
    Result := FALSE;
  end;
  if (ErrText <> '') or (ErrCaption <> '') then
  begin
     //   if aopenwww then ShellExecute(Handle, 'open', 'IExplore.EXE', 'http://www.1000y.com.cn', nil, SW_SHOWNORMAL);
    if not FrmGameToolsNew.A2CheckBox_CL.Checked then begin //2016.03.18 在水一方
      Application.MessageBox(Pchar(ErrText), Pchar(ErrCaption), 0);
      ExitProcess(0); //20130607修改
      exit;
    end;
      //  FrmM.close;
    //  TimerNixConnectConfirmed.Enabled := FALSE;
 //2016.03.18 在水一方 断线自动重连
    ReConnectTick := mmAnsTick;
    ReConnectLoginTick := mmAnsTick + ReConnectyctime * 500;
    if ReConnectMagic = '' then
      ReConnectMagic := Trim(Frmbottom.UseMagic1.Caption); //记录主动武功

    //判断记录风武功
    if ReConnectFengMagic = '' then
      if (Frmbottom.UseMagic2.Caption = '风灵旋') or (Frmbottom.UseMagic2.Caption = '灵动八方') then
        ReConnectFengMagic := Frmbottom.UseMagic2.Caption
      else if (Frmbottom.UseMagic3.Caption = '风灵旋') or (Frmbottom.UseMagic3.Caption = '灵动八方') then
        ReConnectFengMagic := Frmbottom.UseMagic3.Caption
      else if (Frmbottom.UseMagic4.Caption = '风灵旋') or (Frmbottom.UseMagic4.Caption = '灵动八方') then
        ReConnectFengMagic := Frmbottom.UseMagic4.Caption;
    //攻击状态
    if ReConnectHit = 0 then
      ReConnectHit := FrmM.SendHit_ID;
    //反击状态
    //if FrmGameToolsNew.A2CheckBox_CounterAttack.Checked then
    ReConnectAttack := FrmGameToolsNew.A2CheckBox_CounterAttack.Checked;
    //if FrmGameToolsNew.A2CheckBox_CounterAttackUser.Checked then
    ReConnectAttackUser := FrmGameToolsNew.A2CheckBox_CounterAttackUser.Checked;
    //境界等级
    ReConnectEnergy := energyGraphicsclass.GETlevel;

    FrmBottom.AddChat('【' + DateToStr(Date) + ' ' + TimeToStr(Time) + '】与服务器异常中断,尝试重新登录中!', WinRGB(1, 31, 31), WinRGB(1, 14, 20));


    frmSelChar.left := 1000;
    frmfbl.Align := alNone;
    frmfbl.left := 1000;
    Floginstate := 1;
    Timer_login.Enabled := true;
    frmfbl.Visible := true;
    ReConnetFlag := FALSE;
  end;

end;

{
procedure TFrmLogOn.TimerSendTimer(Sender: TObject);
var
   sd: TWordComdata;
   buffer : array [0..MAXSOCKETDATASIZE-1] of byte;
   cnt : Integer;
begin
   if GetAnsSocketAllowSend (AnsSocketHandle) = FALSE then exit;

   cnt := 0;
   while MainPacketBuffer.Count > 0 do begin
      if MainPacketBuffer.Get (@sd) = false then break;
      if cnt + sd.cnt + sizeof (word) > MAXSOCKETSENDDATASIZE then break;

      Reverse4Bit (sd);
      Move (sd, buffer[cnt], sd.cnt + sizeof (word));

      cnt := cnt + sd.cnt + sizeof (word);
   end;
   if cnt > 0 then AnsSocketSend (AnsSocketHandle, @Buffer, cnt);
end;
}

{
procedure TFrmLogOn.TimerRBufferPTimer(Sender: TObject);
var
 i, len : integer;
   wcnt : word;
   sd: TWordComData;
   gSocketBuffer : array [0..MAXSOCKETDATASIZE-1] of byte;
begin
   AnsSocketUpDate (AnsSocketHandle);

   len := AnsSocketRead (AnsSocketHandle, @gSocketBuffer, PROCESSDATASIZE);
   if len > 0 then begin
      if MainBuffer.Put (@gSocketBuffer, len) = false then begin
         ShowMessage ('MainBuffer.Put () failed');
      end;
   end;

   for i := 0 to 50 - 1 do begin
      if MainBuffer.View (@wcnt, sizeof (word)) = false then break;
      if MainBuffer.Count < wcnt + sizeof (word) then break;
      if MainBuffer.Get (@sd, wcnt + sizeof (word)) = false then break;
      Reverse4Bit (sd);
      MessageProcess (sd);
   end;
end;
}

procedure TFrmfbl.SetFormText;
begin
    // FrmLogOn font set
   // Frmfbl.Font.Name := mainFont;

  PnInfo.Font.Name := mainFont;
  //  ComboBoxServer.Font.Name := mainFont;
  EdID.Font.Name := mainFont;
  EdPass.Font.Name := mainFont;

  Caption := (fname);
 // Pninfo.Caption := ('连线中...');
 // Floginstate := 1;
 // Timer_login.Enabled := true;
 // cConnTime := mmAnsTick;
  cConnTime := mmAnsTick;
  Pninfo.Caption := ('连接中...');
  Floginstate := 200;
  Timer_login.Enabled := TRUE;

  EdId.Enabled := False;
  EdPass.Enabled := False;
  BtnLogin.Enabled := False;
end;

procedure TFrmfbl.InitMainSocketAndBuffer;
begin
  if PacketSender <> nil then
  begin
    PacketSender.Clear;
  end;
  if PacketReceiver <> nil then
  begin
    PacketReceiver.Clear;
  end;
end;
{ THostAddressSub }

procedure THostAddressSub.add(adata: THostAddressdata);
var
  p: pTHostAddressdata;
begin
  new(p);
  p^ := adata;
  fdata.Add(p);
end;

procedure THostAddressSub.clear;
var
  i: integer;
  p: pTHostAddressdata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    dispose(p);
  end;

  fdata.Clear;
end;

constructor THostAddressSub.Create;
begin
  fdata := tlist.Create;
end;

destructor THostAddressSub.Destroy;
begin
  clear;
  fdata.Free;
  inherited;
end;

function THostAddressSub.get(aindex: integer): pTHostAddressdata;
begin
  result := nil;
  if (aindex < 0) or (aindex > (fdata.Count - 1)) then exit;
  result := fdata.Items[aindex];
end;

function THostAddressSub.getIndex(aname: string): integer;
var
  i: integer;
  p: pTHostAddressdata;
begin
  result := -1;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.rName = aname then
    begin
      result := i;
      exit;
    end;
  end;
end;

function THostAddressSub.getMenu: string;
var
  i: integer;
  p: pTHostAddressdata;
begin
  result := '';
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    result := result + p.rName + #13#10;
  end;
end;

{ THostAddressClass }

procedure THostAddressClass.add(aname: string);
var
  p: THostAddressSub;
begin
  if get(aname) <> nil then exit;
  p := THostAddressSub.Create;
  p.fname := aname;
  fdata.Add(p);
end;

procedure THostAddressClass.clear;
var
  i: integer;
  p: THostAddressSub;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    p.Free;
  end;
  fdata.Clear;
end;

constructor THostAddressClass.Create(aFileName: string);
var
  i: integer;
  str, rdstr: string;
  StringList: TStringList;
  temp: THostAddressdata;
  HostAddressSub: THostAddressSub;
  xlist: TStringList;
begin
  fdata := TList.Create;
  xlist := tstringlist.Create;
  if FileExists(aFileName) = false then exit;
  StringList := TStringList.Create;
  try
    StringList.LoadFromFile(afilename);
    localnum := stringlist.count;
    xlist.Text := GetInterNetURLText(PChar(decode(urllist)));
    for i := 0 to xlist.Count - 1 do
    begin
      StringList.Add(Trim(xlist.Strings[i]));
    end;
      //  StringList.SaveToFile('d:\xx.txt');
    for i := 0 to StringList.Count - 1 do
    begin
      str := stringlist[i];
      fillchar(temp, sizeof(temp), 0);
                 //区
      str := GetValidStr3(str, rdstr, '|');
      if rdstr = '' then Continue;
      add(rdstr);
      HostAddressSub := get(rdstr);
      if HostAddressSub = nil then Continue;
                //ip
      str := GetValidStr3(str, rdstr, '|');
      if rdstr = '' then Continue;
      temp.rHost := rdstr;
                //port
      str := GetValidStr3(str, rdstr, '|');
      if rdstr = '' then Continue;
      temp.rPort := _strtoint(rdstr);
                //server name
      str := GetValidStr3(str, rdstr, '|');
      if rdstr = '' then Continue;
      temp.rName := rdstr;



      HostAddressSub.add(temp);
    end;
  finally
    StringList.Free;
    xlist.Free;
  end;
end;


destructor THostAddressClass.Destroy;
begin
  clear;
  fdata.Free;
  inherited;
end;

function THostAddressClass.get(aname: string): THostAddressSub;
var
  i: integer;
  p: THostAddressSub;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.fname = aname then
    begin
      result := p;
      exit;
    end;
  end;

end;

function THostAddressClass.getIndex(aname: string): integer;
var
  i: integer;
  p: THostAddressSub;
begin
  result := -1;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.fname = aname then
    begin
      result := i;
      exit;
    end;
  end;
end;

function THostAddressClass.getMenu: string;
var
  i: integer;
  p: THostAddressSub;
begin
  result := '';
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    result := result + p.fname + #13#10;
  end;
end;


function THostAddressClass.getSub(aname: string; aindex: integer): pTHostAddressdata;
var
  p: THostAddressSub;
begin
  result := nil;
  p := get(aname);
  if p = nil then exit;
  result := p.get(aindex);
end;

function THostAddressClass.getSubIndex(aname, asubname: string): integer;
var
  p: THostAddressSub;
begin
  result := -1;
  p := get(aname);
  if p = nil then exit;
  result := p.getIndex(asubname);
end;


function THostAddressClass.getSubMenu(aname: string): string;
var
  p: THostAddressSub;
begin
  result := '';
  p := get(aname);
  if p = nil then exit;
  result := p.getMenu;
end;

procedure Tfrmfbl.btnloginClick(Sender: TObject);
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  ReConnectId := trim(EdId.Text);
  ReConnectPass := EdPass.Text;
  Floginstate := 1;
  Timer_login.Enabled := true;
  ClearEdit(FALSE);

    // frmfbl.Visible:=False;
     // frmfbl.Free;
end;


function CenterStr(Src: string; Before, After: string): string;
var
  Pos1, Pos2: WORD;
  Temp: string;
begin
  Temp := Src;
  Pos1 := Pos(Before, Temp);
  Delete(Temp, 1, Pos1 + Length(Before));
  Pos2 := Pos(After, Temp);
  if (Pos1 = 0) or (Pos2 = 0) then
  begin
    Result := '';
    Exit;
  end;
  Pos1 := Pos1 + Length(Before);
  Result := Copy(Src, Pos1, Pos2);
end;

procedure Tfrmfbl.FormCreate(Sender: TObject);
var
  x, y: TStringList;
  i, n: integer;
  cserver, cserverhead: string;
  str: string;
//  TimepayType: TTimepayType;
  xtree: TTreeNode;

begin
  inherited;
  hcode := GetHardCode;
  //hcode := '';
  //OuterIpAddr := ''; //2015.11.25 在水一方
  FTestPos := True;
  FrmM.AddA2Form(Self, A2Form);
  xchar := txchar.create;
  // SetLength(xchar,0);
  ClientIni := TIniFile.Create('.\ClientIni.ini');
   //  updateurl:=Trim(ClientIni.ReadString('FBL', 'update','')) ; //升级地址
  //   cxver:=Trim(ClientIni.ReadString('FBL', 'ver','')) ; //升级版本地址
 //    cxzip:=Trim(ClientIni.ReadString('FBL', 'zip','')) ; //升级zip地址

  A2CheckBox_SaveUser.Checked := ClientIni.readString('ID', 'saveuser', 'Y') = 'Y';
  A2CheckBox_SavePass.Checked := ClientIni.readString('ID', 'savepass', 'N') = 'Y';
  oldhcode := ClientIni.readString('ID', 'code', ''); //2015.11.16 在水一方
  if oldhcode = hcode then //<<<<<<
    if A2CheckBox_SaveUser.Checked then begin
      try
        edid.Text := decode(ClientIni.readString('ID', 'user', ''), '0123456789');
      except
      end;
      try
        if A2CheckBox_SavePass.Checked then
          edpass.Text := decode(ClientIni.readString('ID', 'pass', ''), '0123456789');
      except
      end;
    end;
  RefreshCheckBox;
//    ReadBuffer := TBuffer.Create(65535);

  for i := 0 to high(MsgCmdarr) do
  begin
    MsgCmdarr[i] := 55;
  end;
  MsgCmdarr[CM_ItemText] := 0;
  MsgCmdarr[CM_TURN] := 5;
  MsgCmdarr[CM_NETSTATE] := 0;
  MsgCmdarr[CM_MOUSEEVENT] := 0;
  MsgCmdarr[CM_MOVE] := 25;
  MsgCmdarr[CM_DRAGDROP] := 20;
  MsgCmdarr[CM_CLICK] := 20;
  MsgCmdarr[CM_HIT] := 20;
  MsgCmdarr[CM_PackId] := 0;
  MsgCmdarr[CM_DBLCLICK] := 5;
  ConnectState := cs_none;

  FStartTime := Time;
  FOldTick := mmAnsTick;
  indexTick := 0;




  Left := 0;
  Top := 0;

  PacketSender := nil;
  PacketReceiver := nil;
//  PacketSender_r := nil;
 // PacketReceiver_r := nil;


  InitMainSocketAndBuffer;

  timerProcess.Interval := 5;
  timerProcess.Enabled := true;
  SetNewVersionTest;
  SetFormText;

  cserverhead := ClientIni.ReadString('CLIENT', 'serverhead', '');
  cserver := ClientIni.ReadString('CLIENT', 'servername', '');
  HostAddressClass := THostAddressClass.Create('addr.txt');

  //  x:=TStringList.Create;
  //  y:=TStringList.Create;
//  x.Text:=HostAddressClass.getMenu;
   // y.Text:=HostAddressClass.getSubMenu(ComboBoxHead.Text);

 {  ComboBoxHead.Items.Text := HostAddressClass.getMenu;

   ComboBoxHead.ItemIndex := HostAddressClass.getIndex(cserverhead);
    if ComboBoxHead.ItemIndex = -1 then
        if ComboBoxHead.Items.Count > 0 then ComboBoxHead.ItemIndex := 0;
    ComboBoxServer.Items.Text := HostAddressClass.getSubMenu(ComboBoxHead.Text);

    ComboBoxServer.ItemIndex := HostAddressClass.getSubIndex(cserverhead, cserver);
    if ComboBoxServer.ItemIndex = -1 then
        if ComboBoxServer.Items.Count > 0 then ComboBoxServer.ItemIndex := 0;

        }
  FillChar(MessageDelayTime, sizeof(MessageDelayTime), 0);

//    str := '';
//    for i := 1 to ParamCount + 2 do
//    begin
//        str := str + ParamStr(i) + ' ';
//    end;
//
//    if NATION_VERSION <> NATION_KOREA then exit;
//
//  //  if x.Count>0 then SetLength(xchar,x.count);
//    for i:=0 to x.Count-1 do
//    begin
//    str:=Copy(x.Strings[i],1,Pos('<',x.Strings[i])-1);
//    if str='' then str:=x.Strings[i];
//    xtree:=TreeView1.Items.Add(nil,str);
//
//     if i<localnum-1 then xtree.ImageIndex := 1 else xtree.ImageIndex := 2;   //设置本地服和网络服图标的差别
//
//    str:=x.Strings[i];
//    xchar.rver:=CenterStr(str,'<','>');
//    xchar.rName:=CenterStr(str,'[',']');
//
//   // Move(str[1],Pointer(xtree.Data)^,100);
//  //  xtree.Data:=@xchar;
//
////  if xchar<>nil then
//   xtree.Data:=xchar;//Pchar(@xchar[i][1]);
//
//  // xchar:=nil;
//
//    y.text:=HostAddressClass.getSubMenu(x.Strings[i]);
//    for n:=0 to y.Count-1 do
//    begin
//      TreeView1.Items.Addchild(xtree,y.Strings[n]);
//      if y.Strings[n]=cserver then
//      begin
//      xtree.Item[n].Selected:=True;
//       Tchange;
//      end;
//    end;
//   //  xtree.Expanded:=True;
//    end;
//    TreeView1.Height:=x.Count*65;
//
//    FreeAndNil(x);
//    FreeAndNil(y);


end;

function ResolveIP(Name: string): string;
type
  tAddr = array[0..100] of PInAddr;
  pAddr = ^tAddr;
var
  I: Integer;
  WSA: TWSAData;
  PHE: PHostEnt;
  P: pAddr;
  hostName: array[0..255] of char;
begin
  Result := '';
  WSAStartUp($101, WSA);
  try
    gethostname(hostName, sizeof(hostName));
    StrPCopy(hostName, Name);
    PHE := GetHostByName(HostName);
    if (PHE <> nil) then
    begin
      P := pAddr(PHE^.h_addr_list);
      I := 0;
      while (P^[I] <> nil) do
      begin
        Result := (inet_nToa(P^[I]^));
        Inc(I);
      end;
    end;
  except
  end;
  WSACleanUp;
end;

procedure Tfrmfbl.timerProcessTimer(Sender: TObject);
var
  nSize, i: Integer;
  //ComData: TWordComData;
  PacketData: TPacketData;
begin

//  if (FGameStatus <> gs_none) and (FGameStatus <> gs_ba) then
 // begin
  //  if PacketSender_r <> nil then PacketSender_r.Update(mmAnsTick);
   // if PacketReceiver_r <> nil then PacketReceiver_r.Update(mmAnsTick);
 // end else
  begin
    if PacketSender <> nil then PacketSender.Update(1024);
  end;
  if PacketReceiver <> nil then
  begin
    //packUpate;

    PacketReceiver.Update; //解密

    for i := 0 to PacketReceiver.Count - 1 do
    begin
      if PacketReceiver = nil then exit;
      if PacketReceiver.Count = 0 then exit;
      if PacketReceiver.GetPacket(@PacketData) = false then break;
      nSize := PacketData.PacketSize - sizeof(word) - sizeof(Integer) - sizeof(byte) - sizeof(byte);

      case PacketData.RequestMsg of
        GM_GATE, GM_BA:
          begin
            if nSize <> (PacketData.Data.Size + 2) then
            begin
               //错误
              WriteLog(format('PacketReceiver 长度错误:PacketSize=%d nSize=%d', [PacketData.PacketSize, PacketData.Data.Size]));
            end
            else
            begin
              ConnectID := PacketData.RequestID;

              if MessageProcess(PacketData.Data) = false then break;
            end;
          end;
        GM_PING:
          begin

            if netPingId = PacketData.RequestID then
            begin
              //netPing := timeGetTime - netPingSendTick;
            end
            else
            begin
              //netPing := -1;
            end;

          end;
      end;
    end;
  end;
end;

procedure Tfrmfbl.Timer_loginTimer(Sender: TObject);
var
  s_io: TSockAddrIn;
  tempSize: integer;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  if not ReConnetFlag and (mmAnsTick - ReConnectTick > 60000) then begin
    ReConnetFlag := True;
    Timer_login.Enabled := False;
    showmessage('服务器连接失败!!!');
    ExitProcess(0);
  end;
  //1分钟没连上重连
  if not ReConnetFlag and (mmAnsTick - ReConnectLoginTick > 6000) then begin
    Floginstate := 1;
    ReConnectLoginTick := mmAnsTick;
  end;
  case Floginstate of
    1: //连接
      begin
        //重连状态3秒重连
        if (not ReConnetFlag) and (mmAnsTick - ReConnectLoginTick < 0) then
          exit;
        ReConnectLoginTick := mmAnsTick + ReConnectyctime * 500;
        FGameStatus := gs_none;
        if sckConnect.Socket.Connected
          and (sckConnect.Host = ReConnectIpAddr)
          and (sckConnect.Port = ReConnectPort) then
        begin
          Floginstate := 3;
          exit;
        end;
        sckConnect.Active := false;
        cConnTime := mmAnsTick;
        Floginstate := 2;
      end;
    2:
      begin
        if sckConnect.Socket.Connected = false then
        begin
          FGameStatus := gs_BA;
          sckConnect.Host := ResolveIP(ReConnectIpAddr);
          sckConnect.Port := ReConnectPort;
          sckConnect.Open;
          Floginstate := 3;
          PnInfo.Caption := ('连接服务器...');
          cConnTime := mmAnsTick;
        end else
        begin
          if GetItemLineTimeSec(mmAnsTick - cConnTime) > 3 then
          begin
            Floginstate := 1;
            cConnTime := mmAnsTick;
          end;
        end;
      end;

    3:
      begin
        if sckConnect.Socket.Connected then
        begin
          tempSize := SizeOf(TSockAddrIn);
          FillChar(s_io, tempSize, 0);
          getsockname(sckConnect.Socket.SocketHandle, s_io, tempSize);
          MyClientIP := inet_ntoa(s_io.sin_addr);
          //hcode := GetHardCode;
          //hcode := '';
          sendBalance;
          PnInfo.Caption := ('获取登录验证...');
          Floginstate := 5;
        end else
        begin
          if GetItemLineTimeSec(mmAnsTick - cConnTime) > 3 then
          begin
            cConnTime := mmAnsTick;
            Floginstate := 1;
          end;
        end;
      end;
    5:
      begin

      end;
    10:
      begin
        sckConnect.Active := false;
        Floginstate := 11;
        cConnTime := mmAnsTick;
      end;
    11:
      begin
        if sckConnect.Socket.Connected = false then
        begin
          FGameStatus := gs_login;
          sckConnect.Host := ResolveIP(ReConnectIpAddr_gate);
          sckConnect.Port := ReConnectPort_gate;
          sckConnect.Open;
          Floginstate := 12;
          PnInfo.Caption := ('连接服务器...');
        end else
        begin
          if GetItemLineTimeSec(mmAnsTick - cConnTime) > 5 then
          begin
            cConnTime := mmAnsTick;
            Floginstate := 10;
          end;
        end;
      end;

    12:
      begin

        if sckConnect.Socket.Connected then
        begin
          sendIDPASS;

          PnInfo.Caption := ('登陆...');
          Floginstate := 100;
        end else
        begin
          if GetItemLineTimeSec(mmAnsTick - cConnTime) > 5 then
          begin
            cConnTime := mmAnsTick;
            Floginstate := 10;
          end;
        end;

      end;
    100:
      begin
        if not ReConnetFlag then
        begin
          FrmBottom.AddChat('【' + DateToStr(Date) + ' ' + TimeToStr(Time) + '】连接失败,尝试重新连接中!', WinRGB(1, 31, 31), WinRGB(1, 14, 20));
          Floginstate := 1;
          ReConnectLoginTick := mmAnsTick + ReConnectyctime * 500;
          Exit;
        end;
        Timer_login.Enabled := false;
        if not startping then
          CreateThread(nil, 0, @CheckOnline, nil, 0, PingID);
      end;
    200:
      begin
        if GetItemLineTimeSec(mmAnsTick - cConnTime) > 1 then
        begin
          PnInfo.Caption := ('开始连接...');
          Floginstate := 201;
          OuterIpAddr := GetOuterIP('http://ip.taobao.com/service/getIpInfo.php?ip=myip', '"ip":"', '"'); //2015.11.25 在水一方
        end;
      end;
    201: //连接
      begin
        FGameStatus := gs_none;
        if sckConnect.Socket.Connected
          and (sckConnect.Host = ReConnectIpAddr)
          and (sckConnect.Port = ReConnectPort) then
        begin
          Floginstate := 203;
          exit;
        end;
        sckConnect.Active := false;
        Floginstate := 202;
      end;
    202:
      begin
        if sckConnect.Socket.Connected = false then
        begin
          FGameStatus := gs_none;
          sckConnect.Host := ResolveIP(ReConnectIpAddr);
          sckConnect.Port := ReConnectPort;
          sckConnect.Open;
          Floginstate := 203;
          PnInfo.Caption := ('连接中...');
          cConnTime := mmAnsTick;
        end else
        begin
          if GetItemLineTimeSec(mmAnsTick - cConnTime) > 5 then
          begin
            cConnTime := mmAnsTick;
            Floginstate := 201;
          end;
        end;
      end;

    203:
      begin
        if sckConnect.Socket.Connected then
        begin
          PnInfo.Caption := ('连接成功!');
          Floginstate := 300;
        end else
        begin
          if GetItemLineTimeSec(mmAnsTick - cConnTime) > 10 then
          begin
            //showmessage('服务器连接失败!!!');
            //ExitProcess(0);
            PnInfo.Caption := ('连接失败!!!');
            BtnLogin.Enabled := TRUE;
           // cConnTime := mmAnsTick;
           // Floginstate := 201;
          end;
        end;
      end;
    300:
      begin
        EdId.Enabled := TRUE;
        EdPass.Enabled := TRUE;
        BtnLogin.Enabled := TRUE;
               // BtnNewUser.Enabled := TRUE;
             //   EdId.Color := clBlack;
             //   EdPass.Color := clBlack;
        if Visible then EdId.SetFocus;

        Timer_login.Enabled := false;
      end;

  end;
{$I SE_PROTECT_END.inc}
end;

procedure Tfrmfbl.TimePingTimer(Sender: TObject);
begin
  sendPing;
end;

procedure Tfrmfbl.btnnewuserClick(Sender: TObject);
begin
  if sckConnect.Socket.Connected then
  begin

  end else PnInfo.Caption := '未选择进入的游戏区';
end;

procedure Tfrmfbl.btnexitClick(Sender: TObject);
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
    //  SocketAddOneData(CM_CLOSE);
  bodirectclose := TRUE;
  ExitProcess(0);
end;

procedure Tfrmfbl.btnRegisterClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://account.m1000y.com/user/reg/',
    nil, nil, SW_SHOW);
end;

procedure Tfrmfbl.btnHomePageClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.m1000y.com/',
    nil, nil, SW_SHOW);
end;

procedure Tfrmfbl.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

   //     ClientIni.Free;

  bodirectclose := TRUE;
   // ExitProcess(0);
  xchar.Free;
  // SetLength(xchar,0);
end;
//function  aat:Cardinal ;stdcall;
//var
//  x:TStringList;
//  begin
//       //////////////////检测升级
//
//  if FileExists(PChar(ExtractFilepath(ParamStr(0))+'ver.txt')) then
//  begin
//  x:=tstringlist.Create;
//  x.LoadFromFile(ExtractFilepath(ParamStr(0))+'ver.txt');
//  oldver:=trim(x.Strings[0]);
//  FreeAndNil(x);
//  end;
//
//
//
//
//  currentver:=GetInterNetURLText(PChar(cxver));
//
// frmfbl.label3.caption:='检测到当前版本：'+oldver+'                   最新版本：'+currentver+'       请升级登录器，否则可能无法正常使用';
//  if currentver<>oldver then
//  begin
//  frmfbl.label3.fontColor:=clRed;
//  frmfbl.label3.Visible:=True;
//  frmfbl.updatebtn.Enabled:=True;
////  MessageBox(0,'请点击升级登录器升级','升级提示',0);
//  end else
//  begin
//  frmfbl.label3.fontColor:=clblack;
//  frmfbl.label3.Visible:=false;
//  frmfbl.updatebtn.Enabled:=false;
//  end;
//
//  ExitThread(0);
//end;

//procedure checkver ;
//var
//  c1,c2:Cardinal;
//begin
//
//  c1:=CreateThread (nil,0,@aat,nil,0,c2);
// // CloseHandle(c1);
//end;

procedure tfrmfbl.tchange;
var
  n: integer;
  p: pTHostAddressdata;
  x: string;
begin
//    x:='';
//    if TreeView1.Selected.Parent<>nil then
//    if  TreeView1.Selected.Parent.Parent=nil  then
//    begin
//    if CurServerName = TreeView1.Selected.Text then exit;
//    CurServerName := TreeView1.Selected.Text;
//   // TreeView1.Selected.ImageIndex:=TreeView1.Selected.ImageIndex;
//
//
//   if (TreeView1.Selected.Parent.Data<>nil) and
//      (PChar(TreeView1.Selected.Parent.Data)<>'') then
//  begin
//   cxver:=Txchar(TreeView1.Selected.Parent.Data).rver;
//   cxzip:=Txchar(TreeView1.Selected.Parent.Data).rname;
//  // updateurl:=PChar(TreeView1.Selected.Parent.Data) ;
//   x:='<'+cxver+'>'+'['+cxzip+']';
//   end;
//   checkver;
//
//    ClientIni.WriteString('CLIENT', 'serverhead',TreeView1.Selected.Parent.Text );
//    ClientIni.WriteString('CLIENT', 'servername', TreeView1.Selected.text);
//
//    ConnectState := cs_none;
//  //  sckConnect.Active := false;
//
//    p := HostAddressClass.getSub(TreeView1.Selected.Parent.Text+x, TreeView1.Selected.Index);
//    if p = nil then exit;
  //ReConnectIpAddr :='115.238.238.250';
  //ReConnectPort := 4153;

  try
      //  if sckConnect.Active = true then sckConnect.Close;

        //   sckConnect.Address := sip;
       // sckConnect.Host := p.rHost;
      //  sckConnect.Port := p.rPort;
        //sckConnect.Open;
    Floginstate := 200;
    Timer_login.Enabled := TRUE;

  except
       // Pninfo.Caption := ('连接失败');
    exit;
  end;

  Pninfo.Caption := ('…');

  EdId.Enabled := FALSE;
  EdPass.Enabled := FALSE;
  BtnLogin.Enabled := FALSE;
  //  BtnNewUser.Enabled := FALSE;

 //   EdId.Color := clBtnFace;
//   EdPass.Color := clBtnFace;

  CurServerName := '测试'; // TreeView1.Selected.Text;
 // end;
end;

procedure Tfrmfbl.TreeView1Click(Sender: TObject);
begin
  TChange;
end;

procedure Tfrmfbl.TimerSpeedCheckTimer(Sender: TObject);
var
  Tick: integer;
  nHour, nMin, nSec, nMSec: word;
  ElaspedTime: TDateTime;
  aTime: integer;
    //   h : pchar;
begin
    ///// 皋农肺
    {
       h := pchar(FindWindow(nil, '皓?彳酗'));
       if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

       h := pchar(FindWindow(nil, 'GearNT'));
       if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

       h := pchar(FindWindow(nil, '1000y - XZ'));
       if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);

       h := pchar(FindWindow(nil, 'Brothers Speeder'));
       if h <> nil then PostMessage(THandle(h), WM_QUIT, 0, 0);
    }
    /////

  FCurTick := mmAnsTick;
  Tick := (FCurTick - FOldTick) div 100;
  ElaspedTime := Time - FStartTime;
  DecodeTime(ElaspedTime, nHour, nMin, nSec, nMSec);
  aTime := nHour * 3600 + nMin * 60 + nSec + 15;
  inc(indexTick);
  if indexTick > 10000 then
  begin
    FOldTick := mmAnsTick;
    FStartTime := Time;
    indexTick := 0;
  end;
  if Tick > aTime then
  begin
    TimerSpeedCheck.Enabled := FALSE;
    SocketDisConnect(('请不要使用加速.'), (fname), TRUE);

  end;
    {
    FrmM.ListBox1.Items.Add(format ('%d : %d = %d',[Tick,aTime,aTime-Tick]));
    FrmM.ListBox1.ItemIndex := FrmM.ListBox1.Items.Count-1;
    if FrmM.ListBox1.Items.Count > 30000 then FrmM.ListBox1.Items.Delete(0);
    }
end;



procedure Tfrmfbl.EdIDChange(Sender: TObject);
var
  ClientIni: TIniFile;
begin
  if not A2CheckBox_SaveUser.Checked then exit;
  ClientIni := TIniFile.Create('.\ClientIni.ini');
  try
    ClientIni.WriteString('ID', 'user', encode(EdID.Text, '0123456789'));
  finally
    ClientIni.Free;
  end;
end;

procedure Tfrmfbl.EdPassChange(Sender: TObject);
var
  ClientIni: TIniFile;
begin
  ClientIni := TIniFile.Create('.\ClientIni.ini');
  try
    ClientIni.WriteString('ID', 'pass', encode(Edpass.Text, '0123456789'));
  finally
    ClientIni.Free;
  end;

end;

procedure Tfrmfbl.EdIDKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = char(VK_ESCAPE)) or (key = char(VK_RETURN)) then key := char(0);

end;

procedure Tfrmfbl.EdIDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN: EdPass.SetFocus;
    VK_ESCAPE: ClearEdit(TRUE);
  end;
end;

procedure Tfrmfbl.EdPassKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = char(VK_ESCAPE)) or (key = char(VK_RETURN)) then key := char(0);
end;

procedure Tfrmfbl.EdPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then ClearEdit(TRUE);
  if key <> VK_RETURN then exit;

  if Length(Edid.Text) < 2 then
  begin
    Edid.SetFocus;
    exit;
  end;
  if Length(EdPass.Text) < 2 then
  begin
    EdPass.SetFocus;
    exit;
  end;

  if Pos(',', EdID.Text) > 0 then
  begin
    Edid.SetFocus;
    exit;
  end;
  if Pos(',', EdPass.Text) > 0 then
  begin
    EdPass.SetFocus;
    exit;
  end;

  if BtnLogIn.Enabled then
    BtnLogInClick(nil);
end;

procedure upzip(MyZipName, MyDestDir: string);
var
  zipControl: TVCLZip;
begin
  zipControl := TVCLZip.Create(nil);
  try
    with zipControl do
    begin
      ZipName := MyZipName;
      ReadZip;
      DestDir := MyDestDir;
      OverwriteMode := Always;
      RelativePaths := True;
      RecreateDirs := True;
      DoAll := True;

      FilesList.Add('*.*');
      UnZip;
    end;
  except
  end;
  FreeAndNil(zipControl);
end;


procedure Tfrmfbl.updatebtnClick(Sender: TObject);
var
  xx: string;
begin
  if currentver <> oldver then
  begin

    xx := ExtractFilePath(ParamStr(0));
    downfile(cxzip, xx + '\temp.zip');
    upzip(xx + '\temp.zip', xx);
    DeleteFile(xx + '\temp.zip');
    MessageBox(0, '文件已经下载完毕了', '提示', 0);
  end else MessageBox(0, '已经是最新版本,无需升级', '提示', 0);
end;

procedure Tfrmfbl.FormShow(Sender: TObject);
begin
  if paramcount <= 0 then
  begin
    showmessage('请用登录器启动客户端！');
    ExitProcess(0);
  end;
  ReConnectIpAddr := paramstr(1);
  ReConnectPort := StrToInt(paramstr(2));
  fserveraddr := paramstr(3);
// tchange ;
end;

procedure Tfrmfbl.SetConfigFileName;
begin
  FConfigFileName := 'Login.xml';
end;

procedure Tfrmfbl.SetNewVersionTest;
begin
  inherited;
  SetControlPos(self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := True;
  SetControlPos(Panel1);

  SetControlPos(EdID);
  SetControlPos(EdPass);
  SetControlPos(btnLogin);
  SetControlPos(btnExit);
  SetControlPos(btnRegister);
  SetControlPos(btnHomePage);
  SetControlPos(PnInfo);
  SetControlPos(A2CheckBox_SaveUser);
  SetControlPos(A2CheckBox_SavePass);
end;

procedure Tfrmfbl.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure Tfrmfbl.RefreshCheckBox;
var
  ClientIni: TIniFile;
  su, sp, ustr, pstr: string;
begin
  su := 'N';
  sp := 'N';
  ustr := '0123456789';
  pstr := '0123456789';
  if not A2CheckBox_SaveUser.Checked then begin
    A2CheckBox_SavePass.Checked := False;
    A2CheckBox_SavePass.Enabled := False;
  end
  else begin
    A2CheckBox_SavePass.Enabled := True;
    su := 'Y';
    ustr := EdID.Text;
    if A2CheckBox_SavePass.Checked then begin
      sp := 'Y';
      pstr := EdPass.Text;
    end;
  end;
  ClientIni := TIniFile.Create('.\ClientIni.ini');
  try
    ClientIni.WriteString('ID', 'saveuser', su);
    ClientIni.WriteString('ID', 'savepass', sp);
    ClientIni.WriteString('ID', 'user', encode(ustr, '0123456789'));
    ClientIni.WriteString('ID', 'pass', encode(pstr, '0123456789'));
    ClientIni.WriteString('ID', 'code', hcode);
  finally
    ClientIni.Free;
  end;
end;

procedure Tfrmfbl.A2CheckBox_SaveUserClick(Sender: TObject);
begin
  inherited;
  RefreshCheckBox;
end;

procedure Tfrmfbl.A2CheckBox_SavePassClick(Sender: TObject);
begin
  inherited;
  RefreshCheckBox;
end;

function Tfrmfbl.SocketAddDataEx(cnt: integer; buf: pointer): Boolean;
var
  n: integer;
  pb: pbyte;
  temp: TWordComData;
begin
  Result := false;
  pb := buf;
  n := pb^;

  if (n >= 0) and (n <= 255) then
  begin
    if MessageDelayTime[n] + MsgCmdarr[n] > mmAnsTick then exit;
    MessageDelayTime[n] := mmAnsTick;
  end;

  Result := true;
  temp.Size := cnt;
  move(buf^, temp.data, cnt);
  if PacketSender <> nil then
  begin
    PacketSender.PutPacket(ConnectID, GM_CLIENT, 0, @temp, cnt + 2);
    PacketSender.Update(2048);
  end else
  begin

  end;
end;

end.

