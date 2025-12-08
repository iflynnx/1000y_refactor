unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ScktComp, Grids, ComCtrls, TeeProcs, TeEngine, Chart,
  iniFiles, mmSystem, NMUDP, uUtil, DefType, AUtil32;

type
  TfrmMain = class(TForm)
    tabView: TPageControl;
    cmdClose: TButton;
    tsServer: TTabSheet;
    tsInfo: TTabSheet;
    tsResult: TTabSheet;
    tsGate: TTabSheet;
    grdServer: TStringGrid;
    sckServer: TServerSocket;
    timerProcess: TTimer;
    timerDisplay: TTimer;
    cmbServers: TComboBox;
    cmdRefresh: TButton;
    lstInfo: TListBox;
    lstResult: TListBox;
    grdGate: TStringGrid;
    lblTotal: TLabel;
    tsUsedIP: TTabSheet;
    lstUsedIP: TListBox;
    lstEndIP: TListBox;
    lblUsedIP: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sckARS: TServerSocket;
    lstGateUser: TListBox;
    lblBanIP: TLabel;
    chkIPLImit: TCheckBox;
    udpSend: TNMUDP;
    procedure cmdCloseClick(Sender: TObject);
    procedure sckServerAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckServerClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckServerClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckServerClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timerProcessTimer(Sender: TObject);
    procedure timerDisplayTimer(Sender: TObject);
    procedure cmdRefreshClick(Sender: TObject);
    procedure sckARSClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sckARSClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckARSAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckARSClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure grdGateDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure AddInfo (aStr : String);
  procedure AddResult (aStr : String);
  procedure AddUsedIP (aStr : String);
  procedure AddEndIP (aStr : String);

  procedure SendUdp (aStr : String);

var
  frmMain: TfrmMain;

  LocalPort : Integer = 3020;
  BufferSizeS2S : Integer = 1048576;
  BufferSizeS2C : Integer = 65535;

  UdpSendAddress : String = '';
  UdpSendPort : Integer = 3001;

implementation

uses
   uConnector, uServers, uUsers, uUseIP;

{$R *.DFM}

procedure SendUdp (aStr : String);
var
   cnt : Integer;
   psd : PTStringData;
   pComData : PTComData;
   buffer : array [0..8192 - 1] of Char;
begin
   if UdpSendAddress = '' then exit;

   pComData := @buffer;
   psd := @pComData^.Data;
   psd^.rMsg := 1;
   SetWordString (psd^.rWordString, aStr + ',');
   cnt := sizeof(TStringData) - sizeof(TWordString) + sizeofwordstring (psd^.rwordstring);
   pComData^.Size := cnt;

   frmMain.udpSend.RemoteHost := UdpSendAddress;
   frmMain.udpSend.RemotePort := UdpSendPort;

   frmMain.udpSend.SendBuffer (buffer, cnt + SizeOf (Integer));
end;

procedure AddInfo (aStr : String);
begin
   if frmMain.lstInfo.Items.Count > 100 then begin
      frmMain.lstInfo.Items.Delete (0);
   end;

   frmMain.lstInfo.Items.Add (aStr);
   frmMain.LstInfo.ItemIndex := frmMain.lstInfo.Items.Count - 1;
end;

procedure AddResult (aStr : String);
begin
   if frmMain.lstResult.Items.Count > 100 then begin
      frmMain.lstResult.Items.Delete (0);
   end;

   frmMain.lstResult.Items.Add (aStr);
   frmMain.lstResult.ItemIndex := frmMain.lstResult.Items.Count - 1;
end;

procedure AddUsedIP (aStr : String);
begin
   if frmMain.lstUsedIP.Items.Count > 100 then begin
      frmMain.lstUsedIP.Items.Delete (0);
   end;

   frmMain.lstUsedIP.Items.Add (aStr);
   frmMain.lstUsedIP.ItemIndex := frmMain.lstUsedIP.Items.Count - 1;
end;

procedure AddEndIP (aStr : String);
begin
   if frmMain.lstEndIP.Items.Count > 100 then begin
      frmMain.lstEndIP.Items.Delete (0);
   end;

   frmMain.lstEndIP.Items.Add (aStr);
   frmMain.lstEndIP.ItemIndex := frmMain.lstEndIP.Items.Count - 1;
end;

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmMain.sckServerAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if ConnectorList.CreateConnector (Socket) = true then begin
      AddInfo (format ('Connected %s', [Socket.RemoteAddress]));
      exit;
   end;
   AddInfo (format ('Rejected %s', [Socket.RemoteAddress]));
   Socket.Close;
end;

procedure TfrmMain.sckServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if ConnectorList.DeleteConnector (Socket) = true then begin
      AddInfo (format ('DisConnected %s', [Socket.RemoteAddress]));
   end;
end;

procedure TfrmMain.sckServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   ErrorCode := 0;
end;

procedure TfrmMain.sckServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   nRead : Integer;
   buffer : array [0..4096 - 1] of Char;
begin
   nRead := Socket.ReceiveBuf (buffer, 4096);
   if nRead > 0 then begin
      ConnectorList.AddReceiveData (Socket, @buffer, nRead);
   end;
end;

procedure TfrmMain.sckServerClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.SetWriteAllow (Socket);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   i, nCount : Integer;
   Name, Addr : String;
   iniFile : TIniFile;
begin
   ConnectorList := TConnectorList.Create;
   ServerList := TServerList.Create;
   UserList := TUserList.Create;
   IPList := TIPList.Create;
   
   iniFile := TIniFile.Create ('.\notice.ini');
   LocalPort := iniFile.ReadInteger ('SERVER', 'PORT', 3020);
   BufferSizeS2S := iniFile.ReadInteger ('SERVER', 'BUFFERSIZES2S', 65535);
   BufferSizeS2C := iniFile.ReadInteger ('SERVER', 'BUFFERSIZES2C', 65535);

   UdpSendAddress := iniFile.ReadString ('SERVER', 'UDPIPADDRESS', '');
   UdpSendPort := iniFile.ReadInteger ('SERVER', 'UDPPORT', 3001);

   nCount := iniFile.ReadInteger ('GAMESERVER', 'COUNT', 0);
   for i := 0 to nCount - 1 do begin
      Name := iniFile.ReadString ('GAMESERVER', 'NAME' + IntToStr (i + 1), '');
      Addr := iniFile.ReadString ('GAMESERVER', 'IP' + IntToStr (i + 1), '');
      if (Name <> '') and (Addr <> '') then begin
         cmbServers.Items.Add (Name);
         ServerList.AddServer (Name, Addr);
      end;
   end;
   iniFile.Free;
   if cmbServers.Items.Count > 0 then begin
      cmbServers.ItemIndex := 0;
   end;

   sckServer.Port := LocalPort;
   sckServer.Active := true;

   sckARS.Port := 5997;
   sckARS.Active := true;

   timerDisplay.Interval := 1000;
   timerDisplay.Enabled := true;

   timerProcess.Interval := 10;
   timerProcess.Enabled := true;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
   timerDisplay.Enabled := false;
   timerProcess.Enabled := false;

   UserList.Free;
   IPList.Free;
   ServerList.Free;
   ConnectorList.Free;
end;

procedure TfrmMain.timerProcessTimer(Sender: TObject);
var
   CurTick : Integer;
begin
   CurTick := timeGetTime;

   ConnectorList.Update (CurTick);
   UserList.Update (CurTick);
end;

procedure TfrmMain.timerDisplayTimer(Sender: TObject);
var
   i, nIndex : Integer;
   Server : TServer;
   GateIP : TGateIP;
   CurTick : Integer;
begin
   CurTick := timeGetTime;

   grdServer.ColCount := 3;
   grdServer.RowCount := ServerList.Count + 1;
   grdServer.Cells [0, 0] := 'ServerName';
   grdServer.Cells [1, 0] := 'Ip Address';
   grdServer.Cells [2, 0] := 'User Count';
   grdServer.ColWidths [0] := 80;
   grdServer.ColWidths [1] := 100;
   grdServer.ColWidths [2] := 60;

   for i := 0 to ServerList.Count - 1 do begin
      Server := ServerList.Items [i];
      grdServer.Cells [0, i + 1] := Server.Name;
      grdServer.Cells [1, i + 1] := Server.IpAddr;
      grdServer.Cells [2, i + 1] := IntToStr (Server.UserCount);
   end;

   grdGate.ColCount := 3;
   grdGate.RowCount := IPList.GateIPCount + 1;
   grdGate.Cells [0, 0] := 'Gate Name';
   grdGate.Cells [1, 0] := 'Ip Address';
   grdGate.Cells [2, 0] := 'Use Count';
   grdGate.ColWidths [0] := 80;
   grdGate.ColWidths [1] := 100;
   grdGate.ColWidths [2] := 60;

   nIndex := 0;
   for i := 0 to IPList.GateIPCount - 1 do begin
      GateIP := IPList.GetGateIP (i);
      if GateIP <> nil then begin
         if GateIP.UseCount > 0 then begin
            grdGate.Cells [0, nIndex + 1] := GateIP.Name;
            grdGate.Cells [1, nIndex + 1] := GateIP.IpAddr;
            grdGate.Cells [2, nIndex + 1] := IntToStr (GateIP.UseCount);
            Inc (nIndex);
         end;
      end;
   end;
   for i := 0 to IPList.GateIPCount - 1 do begin
      GateIP := IPList.GetGateIP (i);
      if GateIP <> nil then begin
         if GateIP.UseCount <= 0 then begin
            grdGate.Cells [0, nIndex + 1] := GateIP.Name;
            grdGate.Cells [1, nIndex + 1] := GateIP.IpAddr;
            grdGate.Cells [2, nIndex + 1] := IntToStr (GateIP.UseCount);
            Inc (nIndex);
         end;
      end;
   end;

   lblTotal.Caption := format ('User Count : %d', [UserList.Count]);
   lblUsedIP.Caption := format ('Used IP Count : %d', [IPList.UseIPCount]);
   lblBanIP.Caption := format ('BAN IP Count : %s', [IPList.BanIPCount]);
end;

procedure TfrmMain.cmdRefreshClick(Sender: TObject);
var
   Name : String;
   Server : TServer;
begin
   Name := cmbServers.Items [cmbServers.ItemIndex];
   if Name = '' then exit;

   ConnectorList.RequestAllUser (Name);
end;

procedure TfrmMain.sckARSClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   ErrorCode := 0;
end;

procedure TfrmMain.sckARSClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   Str, datastr: string;
   cmd, uid: string;
begin
   Str := Socket.ReceiveText;
   while TRUE do begin
      if Str = '' then break;
      Str := GetTokenStr (str, DataStr, #13);

      Datastr := GetTokenStr (Datastr, cmd, ',');
      Datastr := GetTokenStr (Datastr, uid, ',');

      if CompareText (cmd,'@CLOSE') = 0 then begin
         UserList.ARSClose (uid);
      end;
   end;
end;

procedure TfrmMain.sckARSAccept(Sender: TObject; Socket: TCustomWinSocket);
begin
   AddResult ('ARS Client Connected ' + Socket.RemoteAddress);
end;

procedure TfrmMain.sckARSClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   AddResult ('ARS Client DisConnected ' + Socket.RemoteAddress);
end;

procedure TfrmMain.grdGateDblClick(Sender: TObject);
var
   i : Integer;
   GateIP : TGateIP;
   User : TUser;
   Str : String;
begin
   Str := grdGate.Cells [1, grdGate.Row];
   GateIP := IPList.FindGateIP (Str);
   if GateIP = nil then exit;

   lstGateUser.Clear;
   for i := 0 to GateIP.UseCount - 1 do begin
      User := GateIP.SelUser (i);
      if User <> nil then begin
         Str := format ('%s %s %s', [User.ServerName, User.LoginID, User.CharName]);
         lstGateUser.Items.Add (Str);
      end;
   end;
end;

end.
