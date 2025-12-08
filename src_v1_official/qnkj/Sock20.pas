unit Sock20;
{ Install this component using Component, Install, Add within
  Delphi 2.0. This component high-levels the winsock functionallity
  and provides a simple interface to TCP/IP socket functions.

  The code herein is released to the public domain without conditions.

  Written By:      Gary T. Desrosiers
  Date:            March 27th, 1995.
  Modified:        March 18th, 1996 for Delphi 2.0
  Copyright:       (R) Copyright by Gary T. Desrosiers, 1995. All Rights Reserved
  UserID(s):       71062,2754
                   desrosi@pcnet.com

  Description:     This control performs WinSock TCP/IP functions.

  Prerequisites:   You must have the TCP/IP protocol installed and the
                   WSOCK32.DLL available. This code has been tested under
                   Windows 95 and Windows NT 4.0.


  Modifications:   Version 3 - March 18th, 1996
                   - Added properties;
                     - HostName, Returns the name of the local host.
                     - MaximumReceiveLength, Sets the maximum receive buffer size.
                   - Added Methods;
                     - GetLocalIPAddr, returns the IP address of the local host
                   - Added Events;
                     - OnDataNeeded, called when the socket needs data and it's
                        okay to write.

                   Version 2 - July 5th, 1995
                   - Added properties;
                     - MasterSocket, Gets the listener's socket
                     - Peek, Preview data in the input buffer.
                     - NonBlocking, Blocking vs Non-Blocking sockets
                     - Timeout, For blocking mode timeouts
                     - OOB, Sends and receives data out of band (urgent data)
                   - Modified properties;
                     - SocketNumber to read/write
                     - Text (no longer published)
                   - Added Methods;
                     - SCancelListen, new method cancels the listener socket
                     - GetPeerIPAddr, returns partners IP address
                     - GetPeerPort, returns partners port
                   - Modified Methods;
                     - GetIPAddr, Documented and bug fix
                     - GetPort, Documented
                     - SClose, Added shutdown, etc.
                     - SReceive, Modified to use PChar instead of Pascal strings
                     - SSend, Modified to use PChar instead of Pascal strings
                     - SetText, Now loops until entire buffer sent
                   - Added Events
                     - OnErrorOccurred, Called on WinSock errors.

  Properties:       Authorized, true for authorized port assignment
                    default is false which allocates ports > 1024

                    IPAddr, Design time and runtime read/write.
                     Sets the IP Address of the partner that you will
                     eventually SConnect to. You may specify this as
                     dotted decimal or a literal name to be converted
                     via DNS.
                     examples;
                       Sockets1.IPAddr := 'desrosi';
                       Sockets1.IPAddr := '127.0.0.1';
                       addr := Sockets1.IPAddr;

                   Port, Design time and runtime read/write.
                     Sets the Port number of the remote port to connect
                     to or the local port to listen on depending on
                     whether you subsequently issue a SConnect or SListen.
                     This can be specified as a number or a literal name
                     to be converted via DNS.
                     examples;
                       Sockets1.Port := 'echo';
                       Sockets1.Port := '7';
                       port := Sockets1.Port;

                   SocketNumber, Runtime Read/write.
                     Returns (or sets) the socket number of the currently
                     allocated connection.
                     example;
                       sock := Sockets1.SocketNumber;

                   MasterSocket, Runtime Read/Write.
                     Returns (or sets) the master socket number (listener)
                     example;
                       msock := Sockets1.MasterSocket;

                   Text, Design time and runtime read/write.
                     if set, sends the text to the partner.
                     if read, receives some text from the partner.
                     examples;
                       buffer := Sockets1.Text; (* Receive data *)
                       Sockets1.Text := 'This is a test'; (* Send Data *)

                   Peek, runtime read only.
                     Returns up to 255 characters of data waiting to
                     be received but does not actually receive the
                     data.

                   OOB, runtime read/write.
                     if set, sends the text to the partner as urgent (out of
                       band) data.
                     if read, receives urgent (out of band) data.
                     examples;
                       buffer := Sockets1.OOB;
                       Sockets1.OOB := 'This is a test';

                   NonBlocking, Design time and runtime read/write
                     Set to False for blocking mode and True for non-blocking
                     mode (the default). When the socket is in blocking
                     mode, none of the event callback functions (with the
                     exception of OnErrorOccurred) will function.

                   Timeout, Design time and runtime read/write
                     When NonBlocking = 0 (blocking mode) this value
                     specifies the maximum amount of time that
                     a socket operation can take. After this time
                     limit expires, the operation is canceled and
                     an error occurs. The default is 30 (seconds).
                     The Valid range is 0-60 seconds. Setting Timeout
                     to zero causes the operation to wait indefinitely.

                   MaximumReceiveLength, Runtime read/write
                     Set to limit the size of buffers retrieved using
                     .Text, .PeekData, and .OOB Default is 8192.

                   HostName, Runtime read only.
                     Returns the name of the local host.

Methods:           SConnect - Connects to the remote (or local) system
                     specified in the IPAddr and Port properties.
                     example;
                       Sockets1.SConnect; (* Connect to partner *)

                   SListen - Listens on the port specified in the Port
                     property.
                     example;
                       Sockets1.SListen; (* Establish server environment *)

                   SCancelListen - Cancels listens on the socket.
                     example;
                       Sockets1.SCancelListen; (* Dont accept further clients *)

                   SAccept - Accepts a client request. Usually issued in
                     OnSessionAvailable event.
                     example;
                       Sock := Sockets1.SAccept; (* Get client connection *)

                   SClose - Closes the socket.
                     example;
                       Sockets1.SClose; (* Close connection *)

                   SReceive - Receives data from partner, similar to
                     reading the property Text although this function
                     uses PChar instead of Pascal strings.
                     example;
                       len := Sockets1.SReceive(Sockets1.SocketNumber,szBuffer,4096);

                   SSend - Sends data to the partner, similar to
                     setting the property Text although this function
                     uses PChar instead of Pascal strings.
                     example;
                       len := Sockets1.SSend(Sockets1.SocketNumber,szBuff,32000);

                   GetPort - Returns the actual port number of the socket
                     specified as the argument. Generally used when you've
                     specified a port of zero and need to retrieve the
                     assigned port number.

                   GetIPAddr - Returns the IP Address of the socket specified
                     as the argument.

                   GetPeerPort - Returns the partners port number of the socket
                     specified as the argument.

                   GetPeerIPAddr - Returns partners IP Address of the socket
                     specified as the argument.

                   GetLocalIPAddr - Returns the local host's IP Address.

Events:            OnDataAvailable - Called when data is available to
                     be received from the partner. You should issue;
                     buffer := Sockets1.Text; or a SReceive method to
                     receive the data from the partner.

                   OnDataNeeded - Called when it is okay to write
                     data to the socket.

                   OnSessionAvailable - Called when a client has requested
                     to connect to a 'listening' server. You can call
                     the method SAccept here.

                   OnSessionClosed - Called when the partner has closed
                     a socket on you. Normally, you would close your side
                     of the socket when this event happens.

                   OnSessionConnected - Called when the SConnect has
                     completed and the session is connected. This is a
                     good place to send the initial data of a conversation.
                     Also, you may want to enable certain controls that
                     allow the user to send data on the conversation here.

                   OnErrorOccurred - Called when an error occurs on the socket.
                     If defined, the OnErrorOccurred procedure is called when
                     the error occurs. If the procedure isn't defined then
                     a dialog box is displayed with the error text and the
                     program is halted.
}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, WinSock;
const
  { User Windows Messages }
  WM_ASYNCSELECT = WM_USER + 0;
type
  TDataAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
  TDataNeeded = procedure (Sender: TObject; Socket: TSocket) of object;
  TSessionClosed = procedure (Sender: TObject; Socket: TSocket) of object;
  TSessionAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
  TSessionConnected = procedure (Sender: TObject; Socket: TSocket) of object;
  TErrorOccurred = procedure (Sender: TObject; Socket: Integer; Error: integer; Msg: string) of object;

  TSockets = class(TWinControl)
  private
    Pse: PServEnt;
    Phe: PHostEnt;
    Ppe: PProtoEnt;
    sin: TSockAddrIn;
    initdata: TWSAData;
    FAuthorized: Boolean;
    FPort: String;
    FIPAddr: String;
    FSocket: TSocket;
    FMSocket: TSocket;
    FMode: longint;
    FTimeout: integer;
    FMaximumReceiveLength: integer;
    FDataAvailable: TDataAvailable;
    FDataNeeded : TDataNeeded;
    FSessionClosed: TSessionClosed;
    FSessionAvailable: TSessionAvailable;
    FSessionConnected: TSessionConnected;
    FErrorOccurred: TErrorOccurred;
    procedure SetText(Text: string);
    function GetText : string;
    procedure SetTextOOB(Text: string);
    function GetTextOOB : string;
    function PeekData : string;
    function SocketErrorDesc(error: integer) : string;
    procedure SocketError(Socket: TSocket; sockfunc: string; error: integer);
    procedure TWMPaint(var msg:TWMPaint); message WM_PAINT;
    procedure SetTimeout;
    procedure ResetTimeout;
    function GetLocalHostName: string;
  protected
    procedure WMASyncSelect(var msg: TMessage); message WM_ASYNCSELECT;
    procedure WMTimer(var msg: TMessage); message WM_TIMER;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { I'd like to call these methods Connect, Close, Listen, etc but
      they would conflict with the WSock32.DLL function names ! }
    procedure SConnect;
    procedure SClose;
    procedure SListen;
    procedure SCancelListen;
    function SAccept: TSocket;
    function SReceive(Socket: TSocket; szBuff: PChar; var rlen: integer): integer;
    function SSend(Socket: TSocket; szBuff: PChar; var slen: integer): integer;
    function GetIPAddr(aSocket: TSocket): string;
    function GetLocalIPAddr: string;
    function GetPort(aSocket: TSocket): string;
    function GetPeerIPAddr(aSocket: TSocket): string;
    function GetPeerPort(aSocket: TSocket): string;
    function GetBlocking: Boolean;
    procedure SetBlocking(flag: Boolean);
    property Text: string read GetText write SetText;
    property Authorized: Boolean read FAuthorized write FAuthorized;
    property Peek: string read PeekData;
    property OOB: string read GetTextOOB write SetTextOOB;
    property SocketNumber: TSocket read FSocket write FSocket;
    property MasterSocket: TSocket read FMSocket write FMSocket;
    property HostName: string read GetLocalHostName;
  published
    property MaximumReceiveLength: integer read FMaximumReceiveLength write FMaximumReceiveLength;
    property IPAddr: string read FIPAddr write FIPAddr;
    property Port: string read FPort write FPort;
    property NonBlocking: Boolean read GetBlocking write SetBlocking default True;
    property Timeout: integer read FTimeout write FTimeout default 30;
    property OnDataAvailable: TDataAvailable read FDataAvailable
      write FDataAvailable;
    property OnDataNeeded: TDataNeeded read FDataNeeded
      write FDataNeeded;
    property OnSessionClosed: TSessionClosed read FSessionClosed
      write FSessionClosed;
    property OnSessionAvailable: TSessionAvailable read FSessionAvailable
      write FSessionAvailable;
    property OnSessionConnected: TSessionConnected read FSessionConnected
      write FSessionConnected;
    property OnErrorOccurred: TErrorOccurred read FErrorOccurred
      write FErrorOccurred;
    property Parent;  
  end;

procedure Register;

implementation


procedure _strPCopy (buf: PChar; str: string);
var i, len: integer;
begin
	len := Length (str);
	for i:=0 to len-1 do buf[i] := str[i+1];
   buf[len] := #0;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TSockets]);
end;


constructor TSockets.Create(AOwner: TComponent);
var
  iStatus: integer;
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  FAuthorized := False;
  FMode := 1;
  FTimeout := 30;
  FMaximumReceiveLength := 8192;
  FSocket := INVALID_SOCKET;
  FMSocket := INVALID_SOCKET;
  iStatus := WSAStartup($101,initdata);
  if iStatus <> 0 then
    SocketError(0,'Constructor (WSAStartup)',WSAGetLastError);
  invalidate;
end;

destructor TSockets.Destroy;
var
  iStatus: integer;
begin
  iStatus := WSACleanup;
  if iStatus < 0 then
    SocketError(INVALID_SOCKET,'Destructor (WSACleanup)',WSAGetLastError);
  inherited Destroy;
end;

procedure TSockets.TWMPaint(var msg: TWMPaint);
var
  icon: HIcon;
  dc: HDC;
begin
  if csDesigning in ComponentState then
  begin
    icon := LoadIcon(HInstance,MAKEINTRESOURCE('TSOCKETS'));
    dc := GetDC(Handle);
    Width := 32;
    Height := 32;
    DrawIcon(dc,0,0,icon);
    ReleaseDC(Handle,dc);
    FreeResource(icon);
  end;
  ValidateRect(Handle,nil);
end;

function TSockets.GetBlocking: Boolean;
begin
  if FMode = 1 then
    Result := True
  else
    Result := False;
end;

procedure TSockets.SetBlocking(flag: Boolean);
begin
  if flag then
    FMode := 1
  else
    FMode := 0;
end;

procedure TSockets.SetText(Text: string);
var
  len: integer;
  pBuff: PChar;
begin
  len   := Length (Text);
  pBuff := StrAlloc (Len+1);
  _strPCopy (pBuff,Text);
  SSend (FSocket, pBuff, len);
  StrDispose(pBuff);
end;

(*  pBuff := StrAlloc(Length(Text)+1);
  _strPCopy(pBuff,Text);
  if FMode = 0 then
    SetTimeout;
  BytesSent := send(FSocket,pBuff^,Length(Text),0);
  if FMode = 0 then
    ResetTimeout;
  if BytesSent < 0 then
    SocketError(FSocket,'SetText (Send)',WSAGetLastError);
  StrDispose(pBuff);*)

function TSockets.GetText: string;
var
  len: integer;
  pBuff: PChar;
begin
  if FSocket <> INVALID_SOCKET then
  begin
    pBuff := StrAlloc(FMaximumReceiveLength);
    if FMode = 0 then
      SetTimeout;
    len := recv(FSocket,pBuff^,FMaximumReceiveLength,0);
    if FMode = 0 then
      ResetTimeout;
    if len < 0 then
      SocketError(FSocket,'GetText (Recv)',WSAGetLastError);
    pBuff[len] := chr(0);
    Result := StrPas(pBuff);
    StrDispose(pBuff);
  end
  else Result := '';
end;

procedure TSockets.SetTextOOB(Text: string);
var
  BytesSent: integer;
  pBuff: PChar;
begin
  pBuff := StrAlloc(Length(Text)+1);
  _strPCopy(pBuff,Text);
  if FMode = 0 then
    SetTimeout;
  BytesSent := send(FSocket,pBuff^,Length(Text),MSG_OOB);
  if FMode = 0 then
    ResetTimeout;
  if BytesSent < 0 then
    SocketError(FSocket,'SetText (Send)',WSAGetLastError);
  StrDispose(pBuff);
end;

function TSockets.GetTextOOB: string;
var
  len: integer;
  pBuff: PChar;
begin
  if FSocket <> INVALID_SOCKET then
  begin
    pBuff := StrAlloc(FMaximumReceiveLength);
    if FMode = 0 then
      SetTimeout;
    len := recv(FSocket,pBuff^,FMaximumReceiveLength,MSG_OOB);
    if FMode = 0 then
      ResetTimeout;
    if len < 0 then
      SocketError(FSocket,'GetText (Recv)',WSAGetLastError);
    Result := pBuff;
    StrDispose(pBuff);
  end
  else Result := '';
end;


function TSockets.PeekData: string;
var
  len: integer;
  pBuff: PChar;
begin
  if FSocket <> INVALID_SOCKET then
  begin
    pBuff := StrAlloc(FMaximumReceiveLength);
    if FMode = 0 then
      SetTimeout;
    len := recv(FSocket,pBuff^,FMaximumReceiveLength,MSG_PEEK);
    if FMode = 0 then
      ResetTimeout;
    if len < 0 then
      SocketError(FSocket,'PeekData (Peek)',WSAGetLastError);
    Result := pBuff;
    StrDispose(pBuff);
  end
  else Result := '';
end;

function TSockets.GetPort(aSocket: TSocket): string;
var
  addr: TSockAddrIn;
  addrlen: integer;
begin
  addrlen := sizeof(addr);
  getsockname(aSocket,addr,addrlen);
  Result := IntToStr(ntohs(addr.sin_port));
end;

function TSockets.GetIPAddr(aSocket: TSocket): string;
var
  addr: TSockAddrIn;
  addrlen: integer;
  szIPAddr: PChar;
begin
  addrlen := sizeof(addr);
  getsockname(aSocket,addr,addrlen);
  szIPAddr := inet_ntoa(addr.sin_addr);
  Result := StrPas(szIPAddr);
end;

function TSockets.GetLocalIPAddr: string;
var
  addr: TSockAddrIn;
  Phe: PHostEnt;
  szHostName: array[0..128] of char;
begin
  GetHostName(szHostName,128);
  Phe := GetHostByName(szHostName);
  if Phe = nil then
    Result := '0.0.0.0'
  else
  begin
    addr.sin_addr.S_addr := longint(plongint(Phe^.h_addr_list^)^);
    Result := inet_ntoa(addr.sin_addr);
  end;
end;

function TSockets.GetLocalHostName: string;
var
  szHostName: array[0..128] of char;
begin
  GetHostName(szHostName,128);
  Result := szHostName;
end;


function TSockets.GetPeerPort(aSocket: TSocket): string;
var
  addr: TSockAddrIn;
  addrlen: integer;
begin
  addrlen := sizeof(addr);
  getpeername(aSocket,addr,addrlen);
  Result := IntToStr(ntohs(addr.sin_port));
end;

function TSockets.GetPeerIPAddr(aSocket: TSocket): string;
var
  addr: TSockAddrIn;
  addrlen: integer;
  szIPAddr: PChar;
begin
  addrlen := sizeof(addr);
  getpeername(aSocket,addr,addrlen);
  szIPAddr := inet_ntoa(addr.sin_addr);
  Result := StrPas(szIPAddr);
end;


function TSockets.SReceive(Socket: TSocket; szBuff: PChar; var rlen: integer) : integer;
begin
  if Socket <> INVALID_SOCKET then
  begin
    if FMode = 0 then
      SetTimeout;
    rlen := recv(Socket,szBuff^,rlen,0);
    if FMode = 0 then
      ResetTimeout;
    if rlen < 0 then begin        //error original is "if rlen < 0 then"
      SocketError(FSocket,'SReceive',WSAGetLastError);
    end;
    Result := rlen;
  end
  else Result := -1;
end;

function TSockets.SSend(Socket: TSocket; szBuff: PChar; var slen: integer): integer;
var i, snd, len: integer;
	ptr: PChar;
begin
   Result := 0;
  if Socket <> INVALID_SOCKET then
  begin
  	 snd := 0;
    for i:=0 to 100 do begin
       if FMode = 0 then
         SetTimeout;
       ptr := @szBuff[snd];
       if (slen-snd) > 250 then len := send(Socket,ptr^,250,0)
       else len := send(Socket,ptr^,(slen-snd),0);
       if FMode = 0 then
         ResetTimeout;
       if len < 0 then begin
         SocketError(FSocket,'SSend',WSAGetLastError);
         Result := len;
         exit;
       end else begin
         snd := snd + len;
         if snd >= slen then break;
       end;
    end;
    Result := snd;
  end;
end;

procedure TSockets.WMASyncSelect(var msg: TMessage);
var
  err: integer;
  errfn: string;
begin
  err := WSAGetSelectError(msg.LParam);
  if err > WSABASEERR then
  begin
    case WSAGetSelectEvent(msg.lParam) of
      FD_READ: errfn := 'FD_READ';
      FD_WRITE: errfn := 'FD_WRITE';
      FD_CLOSE: errfn := 'FD_CLOSE';
      FD_ACCEPT: errfn := 'FD_ACCEPT';
      FD_CONNECT: errfn := 'FD_CONNECT';
    end;
    SocketError(msg.wParam,errfn,err);
  end
  else
  case WSAGetSelectEvent(msg.lParam) of
    FD_READ:
    begin
      if Assigned(FDataAvailable) then
        FDataAvailable(Self,msg.wParam);
    end;
    FD_WRITE:
    begin
      if Assigned(FDataNeeded) then
        FDataNeeded(Self,msg.wParam);
    end;
    FD_CLOSE:
    begin
      if Assigned(FSessionClosed) then
        FSessionClosed(Self,msg.wParam);
    end;
    FD_ACCEPT:
    begin
      if Assigned(FSessionAvailable) then
        FSessionAvailable(Self,msg.wParam);
    end;
    FD_CONNECT:
    begin
      if Assigned(FSessionConnected) then
        FSessionConnected(Self,msg.wParam);
    end;
  end;
end;

procedure TSockets.WMTimer(var msg: TMessage);
var
  szErrMsg: array[0..255] of char;
begin
  KillTimer(Handle,10);
  if WSAIsBlocking then
  begin
    WSACancelBlockingCall;
    if Assigned(FErrorOccurred) then
      FErrorOccurred(Self,FSocket,WSAETIMEDOUT,'Blocking call timed out')
    else
      begin
        _strPCopy(szErrMsg,'Error ' + IntToStr(WSAETIMEDOUT) + #13#10 +
          'Blocking call timed out');
        Application.MessageBox(szErrMsg, 'WINSOCK CALL CANCELED', mb_OKCancel +
          mb_DefButton1);
      end;
  end;
end;


procedure TSockets.SConnect;
var
  iStatus: integer;
  szTcp: PChar;
  szPort: array[0..31] of char;
  szData: array[0..256] of char;
  bind_sin: TSockAddrIn;
  alport: TSocket;
begin
  if FPort = '' then
  begin
    Application.MessageBox('No Port Specified', 'WINSOCK ERROR', mb_OKCancel +
      mb_DefButton1);
    exit;
  end;
  if FIPAddr = '' then
  begin
    Application.MessageBox('No IP Address Specified', 'WINSOCK ERROR', mb_OKCancel +
      mb_DefButton1);
    exit;
  end;
  sin.sin_family := AF_INET;
  _strPCopy(szPort,FPort);
  szTcp := 'tcp';
  Pse := getservbyname(szPort,szTcp);
  if Pse = nil then
     sin.sin_port := htons(StrToInt(StrPas(szPort)))
  else sin.sin_port := Pse^.s_port;
  _strPCopy(szData,FIPAddr);
  sin.sin_addr.s_addr := inet_addr(szData);
  if sin.sin_addr.s_addr = INADDR_NONE then
    begin
      Phe := gethostbyname(szData);
      if Phe = nil then
        begin
          _strPCopy(szData,'Cannot convert host address');
          Application.MessageBox(szData, 'WINSOCK ERROR', mb_OKCancel +
             mb_DefButton1);
          exit;
        end;
      sin.sin_addr.S_addr := longint(plongint(Phe^.h_addr_list^)^);
    end;
  Ppe := getprotobyname(szTcp);
  FSocket := socket(PF_INET,SOCK_STREAM,Ppe^.p_proto);
  if FSocket < 0 then
    SocketError(INVALID_SOCKET,'SConnect (socket)',WSAGetLastError);
  if FAuthorized = True then
  begin
    alport := IPPORT_RESERVED;
    bind_sin.sin_family := AF_INET;
    bind_sin.sin_addr.s_addr := 0;
    repeat
      bind_sin.sin_port := htons(alport);
      if bind(FSocket,bind_sin,sizeof(bind_sin)) = 0 then
        break;
      if WSAGetLastError <> WSAEADDRINUSE then
        SocketError(FSocket,'SConnect bind()',WSAGetLastError);
      dec(alport);
    until(alport <= (IPPORT_RESERVED div 2));
  end;
  if FMode = 1 then begin
    iStatus := WSAASyncSelect(FSocket,Handle,WM_ASYNCSELECT,
      FD_READ or FD_CLOSE or FD_CONNECT or FD_WRITE);
    if iStatus <> 0 then
      SocketError(FSocket,'WSAAsyncSelect',WSAGetLastError);
  end else
    ioctlsocket(FSocket,FIONBIO,FMode);

  if FMode = 0 then SetTimeout;

  iStatus := connect(FSocket,sin,sizeof(sin));

  if FMode = 0 then ResetTimeout;

  if iStatus <> 0 then
    begin
    iStatus := WSAGetLastError;
    if iStatus <> WSAEWOULDBLOCK then
       SocketError(FSocket,'SConnect',WSAGetLastError);
    end;
end;

procedure TSockets.SListen;
var
  iStatus: integer;
  szTcp: PChar;
  szPort: array[0..31] of char;
//  szData: array[0..256] of char;
begin
  if FPort = '' then
  begin
    Application.MessageBox('No Port Specified', 'WINSOCK ERROR', mb_OKCancel +
      mb_DefButton1);
    exit;
  end;
  sin.sin_family := AF_INET;
  sin.sin_addr.s_addr := INADDR_ANY;
  szTcp := 'tcp';
  _strPCopy(szPort,FPort);
  Pse := getservbyname(szPort,szTcp);
  if Pse = nil then
     sin.sin_port := htons(StrToInt(StrPas(szPort)))
  else sin.sin_port := Pse^.s_port;
  Ppe := getprotobyname(szTcp);
  FMSocket := socket(PF_INET,SOCK_STREAM,Ppe^.p_proto);
  if FMSocket < 0 then
    SocketError(INVALID_SOCKET,'socket',WSAGetLastError);
  iStatus := bind(FMSocket, sin, sizeof(sin));
  if iStatus <> 0 then
    SocketError(FMSocket,'Bind',WSAGetLastError);
  iStatus := listen(FMSocket,5);
  if iStatus <> 0 then
    SocketError(FMSocket,'Listen',WSAGetLastError);
  if FMode = 1 then
  begin
    iStatus := WSAASyncSelect(FMSocket,Handle,WM_ASYNCSELECT,
      FD_READ or FD_WRITE or FD_ACCEPT or FD_CLOSE);
    if iStatus <> 0 then
      SocketError(FMSocket,'WSAASyncSelect',WSAGetLastError);
  end
  else ioctlsocket(FMSocket,FIONBIO,FMode);
end;

procedure TSockets.SCancelListen;
var
  iStatus: integer;
begin
  if FMode = 1 then
    WSAASyncSelect(FMSocket,Handle,WM_ASYNCSELECT,0);
  shutdown(FMSocket,2);
  iStatus := closesocket(FMSocket);
  if iStatus <> 0 then
    SocketError(FMSocket,'CancelListen (closesocket)',WSAGetLastError);
  FMSocket := 0;
end;


function TSockets.SAccept: TSocket;
var
//  iStatus: integer;
  len: integer;
begin
  len := sizeof(sin);
  if FMode = 0 then
    SetTimeout;
  FSocket := accept(FMSocket,sin,len);
  if FMode = 0 then
  begin
    ResetTimeout;
    ioctlsocket(FSocket,FIONBIO,FMode);
  end;
  if FMSocket < 0 then
    SocketError(FSocket,'Accept',WSAGetLastError);
  Result := FSocket;
end;

procedure TSockets.SClose;
var
  iStatus: integer;
  lin: TLinger;
  linx: array[0..3] of char absolute lin;
begin
  if FMode = 1 then
    WSAASyncSelect(FSocket,Handle,WM_ASYNCSELECT,0);
  if WSAIsBlocking then
    WSACancelBlockingCall;
  shutdown(FSocket,2);
  lin.l_onoff := 1;
  lin.l_linger := 0;
  setsockopt(FSocket,SOL_SOCKET,SO_LINGER,linx,sizeof(lin));
  iStatus := closesocket(FSocket);
  if iStatus <> 0 then
    SocketError(FSocket,'Disconnect (closesocket)',WSAGetLastError);
  FSocket := INVALID_SOCKET;
end;


procedure TSockets.SocketError(Socket: TSocket; sockfunc: string; error: Integer);
var
  szLine: array[0..255]  of char;
  line, ErrMsg: string;
begin
  ErrMsg := SocketErrorDesc(error);
  line := 'Error '+ IntToStr(error) + ' in function ' + sockfunc +
  #13#10 + ErrMsg;
  if Assigned(FErrorOccurred) then
    FErrorOccurred(Self,Socket,error,ErrMsg)
  else
    begin
      _strPCopy(szLine,line);
      Application.MessageBox(szLine, 'WINSOCK ERROR', mb_OKCancel +
        mb_DefButton1);
      halt;
    end;
end;

function TSockets.SocketErrorDesc(error: integer) : string;
begin
  case error of
    WSAEINTR:
      SocketErrorDesc := 'Interrupted system call';
    WSAEBADF:
      SocketErrorDesc := 'Bad file number';
    WSAEACCES:
      SocketErrorDesc := 'Permission denied';
    WSAEFAULT:
      SocketErrorDesc := 'Bad address';
    WSAEINVAL:
      SocketErrorDesc := 'Invalid argument';
    WSAEMFILE:
      SocketErrorDesc := 'Too many open files';
    WSAEWOULDBLOCK:
      SocketErrorDesc := 'Operation would block';
    WSAEINPROGRESS:
      SocketErrorDesc := 'Operation now in progress';
    WSAEALREADY:
      SocketErrorDesc := 'Operation already in progress';
    WSAENOTSOCK:
      SocketErrorDesc := 'Socket operation on non-socket';
    WSAEDESTADDRREQ:
      SocketErrorDesc := 'Destination address required';
    WSAEMSGSIZE:
      SocketErrorDesc := 'Message too long';
    WSAEPROTOTYPE:
      SocketErrorDesc := 'Protocol wrong type for socket';
    WSAENOPROTOOPT:
      SocketErrorDesc := 'Protocol not available';
    WSAEPROTONOSUPPORT:
      SocketErrorDesc := 'Protocol not supported';
    WSAESOCKTNOSUPPORT:
      SocketErrorDesc := 'Socket type not supported';
    WSAEOPNOTSUPP:
      SocketErrorDesc := 'Operation not supported on socket';
    WSAEPFNOSUPPORT:
      SocketErrorDesc := 'Protocol family not supported';
    WSAEAFNOSUPPORT:
      SocketErrorDesc := 'Address family not supported by protocol family';
    WSAEADDRINUSE:
      SocketErrorDesc := 'Address already in use';
    WSAEADDRNOTAVAIL:
      SocketErrorDesc := 'Can''t assign requested address';
    WSAENETDOWN:
      SocketErrorDesc := 'Network is down';
    WSAENETUNREACH:
      SocketErrorDesc := 'Network is unreachable';
    WSAENETRESET:
      SocketErrorDesc := 'Network dropped connection on reset';
    WSAECONNABORTED:
      SocketErrorDesc := 'Software caused connection abort';
    WSAECONNRESET:
      SocketErrorDesc := 'Connection reset by peer';
    WSAENOBUFS:
      SocketErrorDesc := 'No buffer space available';
    WSAEISCONN:
      SocketErrorDesc := 'Socket is already connected';
    WSAENOTCONN:
      SocketErrorDesc := 'Socket is not connected';
    WSAESHUTDOWN:
      SocketErrorDesc := 'Can''t send after socket shutdown';
    WSAETOOMANYREFS:
      SocketErrorDesc := 'Too many references: can''t splice';
    WSAETIMEDOUT:
      SocketErrorDesc := 'Connection timed out';
    WSAECONNREFUSED:
      SocketErrorDesc := 'Connection refused';
    WSAELOOP:
      SocketErrorDesc := 'Too many levels of symbolic links';
    WSAENAMETOOLONG:
      SocketErrorDesc := 'File name too long';
    WSAEHOSTDOWN:
      SocketErrorDesc := 'Host is down';
    WSAEHOSTUNREACH:
      SocketErrorDesc := 'No route to host';
    WSAENOTEMPTY:
      SocketErrorDesc := 'Directory not empty';
    WSAEPROCLIM:
      SocketErrorDesc := 'Too many processes';
    WSAEUSERS:
      SocketErrorDesc := 'Too many users';
    WSAEDQUOT:
      SocketErrorDesc := 'Disc quota exceeded';
    WSAESTALE:
      SocketErrorDesc := 'Stale NFS file handle';
    WSAEREMOTE:
      SocketErrorDesc := 'Too many levels of remote in path';
    WSASYSNOTREADY:
      SocketErrorDesc := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED:
      SocketErrorDesc := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED:
      SocketErrorDesc := 'WinSock not initialized';
    WSAHOST_NOT_FOUND:
      SocketErrorDesc := 'Host not found';
    WSATRY_AGAIN:
      SocketErrorDesc := 'Non-authoritative host not found';
    WSANO_RECOVERY:
      SocketErrorDesc := 'Non-recoverable error';
    WSANO_DATA:
      SocketErrorDesc := 'No Data';
    else SocketErrorDesc := 'Not a WinSock error';
  end;
end;

procedure TSockets.SetTimeout;
begin
  if FTimeout > 0 then
    SetTimer(Handle,10,FTimeout*1000,nil);
end;

procedure TSockets.ResetTimeout;
begin
  if FTimeout > 0 then
    KillTimer(Handle,10);
end;

end.
