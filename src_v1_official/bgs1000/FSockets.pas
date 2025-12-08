unit FSockets;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uanstick, ScktComp, StdCtrls, adeftype, ExtCtrls, autil32, deftype, WinSock,
  NMUDP, svClass, uBuffer;

type
  TFrmSockets = class(TForm)
    TimerProcess: TTimer;
    NMUDPForSend: TNMUDP;
    GMUDP: TNMUDP;
    NMUDPNotice: TNMUDP;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    // procedure GMUDPDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; Port : Integer);
    procedure TimerProcessTimer(Sender: TObject);
    procedure NMUDPNoticeDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; Port : Integer);
  private
    // UdpUserDataSocketBuffer : TBigBufferClass;
    // UdpNoticeSocketBuffer : TBigBufferClass;
    // UserDataComDataList : TBigComDataList;
    // NoticeComDataList : TBigComDataList;

    // UdpUserDataSocketBuffer : TBuffer;
    // UserDataComDataList : TPacketBuffer;
    
    UdpNoticeSocketBuffer : TBuffer;
    NoticeComDataList : TPacketBuffer;

  public
    boConnect : Boolean;
    function UdpSendMouseInfo (cnt: integer; pb: pbyte): Boolean;
    function UdpItemMoveInfoAddData(cnt: integer; pb: pbyte): Boolean;
    function UdpMoniterAddData (cnt: integer; pb: pbyte) :Boolean;
    // function UdpGMAddData(cnt: integer; pb: pbyte): Boolean;
    function UdpNTAddData(cnt: integer; pb: pbyte): Boolean;
    function UdpConnectAddData (cnt : Integer; pb : PByte) : Boolean;
  end;

var
  FrmSockets: TFrmSockets;

  Send_GM_CHECK_Tick : integer = 0;

implementation

uses SVMain, uconnect;

{$R *.DFM}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////

procedure TFrmSockets.FormCreate(Sender: TObject);
begin
   boConnect := FALSE;
   // UdpUserDataSocketBuffer := TBigBufferClass.Create ('');
   // UdpNoticeSocketBuffer := TBigBufferClass.Create ('');

   // UdpUserDataSocketBuffer := TBuffer.Create (1024 * 1024);
   // UserDataComDataList := TPacketBuffer.Create (1024 * 1024);

   UdpNoticeSocketBuffer := TBuffer.Create (1024 * 1024);
   NoticeComDataList := TPacketBuffer.Create (1024 * 1024);

   TimerProcess.Interval := 10;
   TimerProcess.Enabled := true;
end;

procedure TFrmSockets.FormDestroy(Sender: TObject);
begin
   UdpNoticeSocketBuffer.Free;
   NoticeComDataList.Free;
   // UserDataComDataList.Free;
   // UdpUserDataSocketBuffer.Free;
end;

procedure TFrmSockets.TimerProcessTimer(Sender: TObject);
   function LocalSendData(aUdp: TNMUdp; aip: string; aport, cnt: integer; pb: pbyte): Boolean;
   var
      psd : PTComData;
      Buffer : array [0..8192] of char;
   begin
      try
         psd := @Buffer;
         psd^.cnt := cnt;
         move (pb^, psd^.data, cnt);

         aUdp.RemoteHost  := aip;
         aUdp.RemotePort  := aport;

         aUdp.SendBuffer(Buffer, cnt + 4);
      except
         FrmMain.WriteLogInfo('FrmSockets.pas LocalSendData');
      end;
      Result := TRUE;
   end;
const
   OldGmSendTick : integer = 0;
var
   cnt : integer;
   gmd : TGMData;
   sd : TComData;
begin
   if NoticeComDataList.Get (@sd) then begin
      LocalSendData(NMUDPNotice, Udp_Notice_IpAddress, Udp_Notice_Port, sd.cnt, @sd.data);
   end;
   while TRUE do begin
      cnt := UdpNoticeSocketBuffer.Count;
      if cnt < 4 then break;
      UdpNoticeSocketBuffer.View (@sd.cnt, 4);
      if cnt < sd.cnt + 4 then break;
      UdpNoticeSocketBuffer.Get (@sd, sd.cnt + 4);
      ConnectorList.ProcessNoticeServerMessage (sd);
   end;

   // if UserDataComDataList.Get (@sd) then LocalSendData(GMUDP, Udp_UserData_IpAddress, Udp_UserData_Port, sd.cnt, @sd.data);

   {
   while TRUE do begin
      cnt := UdpUserDataSocketBuffer.Count;
      if cnt < 4 then break;
      UdpUserDataSocketBuffer.View (4, @sd.cnt);
      if cnt < sd.cnt + 4 then break;
      UdpUserDataSocketBuffer.Get (sd.cnt + 4, @sd);
      ConnectorList.ProcessGameServerMessage ( sd);
   end;

   if OldGmSendTick + 100 < mmAnsTick then begin
      OldGmSendTick := mmAnsTick;

      Send_GM_CHECK_Tick := mmAnsTick;
      FillChar (gmd, sizeof(gmd), 0);
      gmd.rmsg := GM_CHECK;
      cnt := sizeof(gmd) - sizeof(TWordString) + sizeofwordstring (gmd.rwordstring);
      UdpGmAddData (cnt, @gmd);
   end;
   }
end;

function TFrmSockets.UdpSendMouseInfo (cnt: integer; pb: pbyte): Boolean;
var
   psd : PTComData;
   Buffer : array [0..8192] of char;
begin
   try
      if (pb <> nil) and (cnt > 0) and (cnt + 4 < 8192) then begin
         psd := @Buffer;
         psd^.cnt := cnt;
         move (pb^, psd^.data, cnt);

         NMUdpForSend.RemoteHost  := Udp_MouseEvent_IpAddress;
         NMUdpForSend.RemotePort  := Udp_MouseEvent_Port;

         NMUdpForSend.SendBuffer(Buffer, cnt + 4);
      end else begin
         FrmMain.WriteLogInfo(format('FrmSockets.pas UDPSendMouseInfo Except (Cnt : %d)', [Cnt]));
      end;
   except
      FrmMain.WriteLogInfo('FrmSockets.pas UDPSendMouseInfo Except');
   end;
   Result := TRUE;
end;


function TFrmSockets.UdpItemMoveInfoAddData (cnt: integer; pb: pbyte) :Boolean;
var
   psd : PTComData;
   Buffer : array [0..8192] of char;
begin
   try
      psd := @Buffer;
      psd^.cnt := cnt;
      move (pb^, psd^.data, cnt);

      NMUdpForSend.RemoteHost  := Udp_Item_IpAddress;
      NMUdpForSend.RemotePort  := Udp_Item_Port;

      NMUdpForSend.SendBuffer(Buffer, cnt + 4);
   except
      FrmMain.WriteLogInfo('FrmSockets.pas UdpItemMoveInfoAddData Except');
   end;
   Result := TRUE;
end;

function TFrmSockets.UdpMoniterAddData (cnt: integer; pb: pbyte) :Boolean;
var
   psd : PTComData;
   Buffer : array [0..8192] of char;
begin
   try
      psd := @Buffer;
      psd^.cnt := cnt;
      move (pb^, psd^.data, cnt);

      NMUdpForSend.RemoteHost  := Udp_Moniter_IpAddress;
      NMUdpForSend.RemotePort  := Udp_Moniter_Port;

      NMUdpForSend.SendBuffer(Buffer, cnt + 4);
   except
      FrmMain.WriteLogInfo('FrmSockets.pas UdpMonitorAddData Except');
   end;
   Result := TRUE;
end;

{
function TFrmSockets.UdpGMAddData(cnt: integer; pb: pbyte): Boolean;
begin
   Result := UserDataComDataList.Put (PChar (pb), cnt);
end;
}

function TFrmSockets.UdpNTAddData(cnt: integer; pb: pbyte): Boolean;
var
   ComData : TComData;
begin
   ComData.Cnt := cnt;
   Move (pb^, ComData.Data, ComData.Cnt);

   Result := NoticeComDataList.Put (@ComData, ComData.Cnt + SizeOf (Integer));
end;

function TFrmSockets.UdpConnectAddData (cnt : Integer; pb : PByte) : Boolean;
var
   psd : PTComData;
   Buffer : array [0..8192] of char;
begin
   psd := @Buffer;
   psd^.cnt := cnt;
   move (pb^, psd^.data, cnt);

   NMUdpForSend.RemoteHost  := Udp_Connect_IpAddress;
   NMUdpForSend.RemotePort  := Udp_Connect_Port;

   NMUdpForSend.SendBuffer(Buffer, cnt + 4);

   Result := TRUE;
end;

{
procedure TFrmSockets.GMUDPDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; Port : Integer);
var
   cnt : integer;
   Buffer : array [0..8192] of char;
begin
   boConnect := TRUE;
   try
      cnt := NumberBytes;
      // 2000.09.29 UDP연결의 불안정으로 비정상적인 수치가 넘어오기 때문에
      // 0보다 큰 경우에만 처리한다 by Lee.S.G
      if cnt > 0 then begin
         if cnt > 8192 then cnt := 8192;
         if FromIp <> Udp_UserData_IpAddress then exit;
         GMUDP.ReadBuffer(Buffer, cnt);
         if Cnt > 0 then begin
            UdpUserDataSocketBuffer.Put (@Buffer, cnt);
         end;
      end;
   except
      FrmMain.WriteLogInfo('FrmSockets.pas GMUDPDataReceived Except');
   end;
end;
}

procedure TFrmSockets.NMUDPNoticeDataReceived(Sender: TComponent; NumberBytes: Integer; FromIP: String; Port : Integer);
var
   cnt : integer;
   Buffer : array [0..8192] of char;
begin
   boConnect := TRUE;
   cnt := NumberBytes;
   if cnt > 0 then begin
      if cnt > 8192 then cnt := 8192;
      if FromIp <> Udp_Notice_IpAddress then exit;
      NMUDPNotice.ReadBuffer(Buffer, cnt);
      if Cnt > 0 then begin
         UdpNoticeSocketBuffer.Put (@Buffer, cnt);
      end;
   end;
end;

end.
