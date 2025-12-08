unit uConnector;

interface

uses
   Classes, SysUtils, ScktComp, uPackets, DefType;

const
   CHECKINTERVALSECOND = 5;

   PM_STRING = 1;

type
   TConnector = class
   private
      ConnectID : Integer;
      Socket : TCustomWinSocket;

      Name : String;
      IpAddr : String;

      PacketSender : TPacketSender;
      PacketReceiver : TPacketReceiver;

      boAllowDelete : Boolean;
   public
      constructor Create (aSocket : TCustomWinSocket; aID : Integer);
      destructor Destroy; override;

      procedure Close;

      procedure RequestAllUser;

      procedure AddReceiveData (aData : PChar; aSize : Integer);
      procedure AddSendData (aData : PChar; aSize : Integer);

      procedure Update (CurTick : Integer);

      procedure MessageProcess (aPacketData : PTPacketData);
   end;

   TConnectorList = class
   private
      IncreaseID : Integer;

      DataList : TList;

      function GetCount : Integer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      procedure RequestAllUser (aServerName : String);

      function CreateConnector (aSocket : TCustomWinSocket) : Boolean;
      function DeleteConnector (aSocket : TCustomWinSocket) : Boolean;

      procedure AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aSize : Integer);
      procedure AddSendData (aServerName : String; aData : PChar; aSize : Integer);

      procedure Update (CurTick : Integer);

      procedure SetWriteAllow (aSocket : TCustomWinSocket);

      property Count : Integer read GetCount;
   end;

var
   ConnectorList : TConnectorList = nil;

implementation

uses
   FMain, uUsers, uServers;

constructor TConnector.Create (aSocket : TCustomWinSocket; aID : Integer);
var
   nd : TNoticeData;
begin
   IpAddr := aSocket.RemoteAddress;
   Name := ServerList.GetServerName (IpAddr);

   ConnectID := aID;
   Socket := aSocket;

   PacketSender := TPacketSender.Create ('Sender', 1048576, aSocket);
   PacketReceiver := TPacketReceiver.Create ('Receiver', 1048576);

   RequestAllUser;

   boAllowDelete := false;
end;

destructor TConnector.Destroy;
begin
   PacketSender.Free;
   PacketReceiver.Free;

   inherited Destroy;
end;

procedure TConnector.RequestAllUser;
var
   nd : TNoticeData;
begin
   UserList.ClearByServer (Name);
   
   FillChar (nd, SizeOf (TNoticeData), 0);
   nd.rMsg := NGM_REQUESTALLUSER;
   PacketSender.PutPacket (0, PACKET_NOTICE, 0, @nd, SizeOf (TNoticeData));
end;

procedure TConnector.Close;
begin
   Socket.Close;
end;

procedure TConnector.AddReceiveData (aData : PChar; aSize : Integer);
begin
   PacketReceiver.PutData (aData, aSize);
end;

procedure TConnector.AddSendData (aData : PChar; aSize : Integer);
begin
   PacketSender.PutPacket (0, PACKET_NOTICE, 0, aData, aSize);
end;

procedure TConnector.Update (CurTick : Integer);
var
   PacketData : TPacketData;
begin
   PacketSender.Update;
   PacketReceiver.Update;
   while PacketReceiver.Count > 0 do begin
      if PacketReceiver.GetPacket (@PacketData) = false then break;
      MessageProcess (@PacketData);
   end;
end;

procedure TConnector.MessageProcess (aPacketData : PTPacketData);
var
   pnd : PTNoticeData;
begin
   if aPacketData^.RequestMsg <> PACKET_GAME then exit;

   pnd := @aPacketData.Data;
   Case pnd^.rMsg of
      GNM_INUSER :
         begin
            AddInfo (format ('IN (%s,%s,%s)', [Name, pnd^.rLoginID, pnd^.rCharName]));
            UserList.AddUser (Name, pnd^.rLoginID, pnd^.rCharName, pnd^.rIpAddr, pnd^.rPaidType, pnd^.rCode);
         end;
      GNM_OUTUSER :
         begin
            AddInfo (format ('OUT (%s,%s,%s)', [Name, pnd^.rLoginID, pnd^.rCharName]));
            UserList.DelUser (pnd^.rLoginID, pnd^.rCharName);
         end;
      GNM_ALLCLEAR :
         begin
            AddInfo ('ALLCLEAR');
            UserList.ClearByServer (Name);
         end;
   end;
end;

constructor TConnectorList.Create;
begin
   IncreaseID := 0;
   DataList := TList.Create;
end;

destructor TConnectorList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

procedure TConnectorList.Clear;
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.Free;
   end;
   DataList.Clear;
end;

procedure TConnectorList.RequestAllUser (aServerName : String);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Name = aServerName then begin
         Connector.RequestAllUser;
         exit;
      end;
   end;
end;

function TConnectorList.CreateConnector (aSocket : TCustomWinSocket) : Boolean;
var
   i : Integer;
   Connector, tmpConnector : TConnector;
begin
   Result := false;

   Connector := TConnector.Create (aSocket, IncreaseID);
   if Connector.Name = '' then begin
      Connector.Free;
      exit;
   end;
   for i := 0 to DataList.Count - 1 do begin
      tmpConnector := DataList.Items [i];
      if tmpConnector.Name = Connector.Name then begin
         Connector.Free;
         exit;
      end;
   end;

   DataList.Add (Connector);

   Inc (IncreaseID);

   Result := true;
end;

function TConnectorList.DeleteConnector (aSocket : TCustomWinSocket) : Boolean;
var
   i : Integer;
   Connector : TConnector;
begin
   Result := false;
   
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.boAllowDelete := true;
         Result := true;
         exit;
      end;
   end;
end;

procedure TConnectorList.AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aSize : Integer);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.AddReceiveData (aData, aSize);
         exit;
      end;
   end;
end;

procedure TConnectorList.AddSendData (aServerName : String; aData : PChar; aSize : Integer);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Name = aServerName then begin
         Connector.AddSendData (aData, aSize);
         exit;
      end;
   end;
end;

procedure TConnectorList.Update (CurTick : Integer);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := DataList.Count - 1 downto 0 do begin
      Connector := DataList.Items [i];
      if Connector.boAllowDelete = true then begin
         Connector.Free;
         DataList.Delete (i);
      end;
   end;

   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.Update (CurTick);
   end;
end;

procedure TConnectorList.SetWriteAllow (aSocket : TCustomWinSocket);
var
   i : Integer;
   Connector : TConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.Socket = aSocket then begin
         Connector.PacketSender.WriteAllow := true;
         exit;
      end;
   end;
end;

function TConnectorList.GetCount : Integer;
begin
   Result := DataList.Count;
end;

end.
