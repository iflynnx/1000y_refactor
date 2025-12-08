unit uGConnect;

interface

uses
   Classes, SysUtils, ScktComp, Graphics, uPackets, Common, AUtil32;

type
   TConnectData = record
      Socket : TCustomWinSocket;
   end;
   PTConnectData = ^TConnectData;

   TGameServerConnector = class
   private
      Name, IpAddr : String;

      GateNo : Integer;

      Socket : TCustomWinSocket;

      GameServerSender : TPacketSender;
      GameServerReceiver : TPacketReceiver;
   public
      constructor Create (aGateNo : Integer; aName, aIpAddr : String);
      destructor Destroy; override;

      procedure Init (aSocket : TCustomWinSocket);
      procedure Clear;

      procedure Update (CurTick : Integer);

      procedure MessageProcess (aPacket : PTPacketData);

      procedure AddReceiveData (aData : PChar; aCount : Integer);
      procedure AddSendData (aConnectID : Integer; aData : PChar; aCount : Integer);

      procedure AddSendServerData (aConnectID : Integer; aMsg : Byte; aData : PChar; aCount : Integer);

      function SendBytesPerSec : Integer;
      function ReceiveBytesPerSec : Integer;
      function WBCount : Integer;
      function WriteAllow : Boolean;

      procedure SetWriteAllow (boFlag : Boolean);
   end;

   TGameServerConnectorList = class
   private
      UniqueID : Integer;
      DataList : TList;

      function GetCount : Integer;
      function Get (aIndex : Integer) : Pointer;
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function GetGameServerName (aGateNo : Integer) : String;

      function CreateConnect (aSocket : TCustomWinSocket) : Boolean;
      function DeleteConnect (aSocket : TCustomWinSocket) : Boolean;

      function LoadFromFile (aFileName : String) : Boolean;

      procedure Update (CurTick : Integer);
      procedure AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aCount : Integer);
      procedure AddSendData (aGateNo, aConnectID : Integer; aData : PChar; aCount : Integer);
      procedure AddSendDataForAll (aData : PChar; aCount : Integer);
      procedure AddSendServerData (aGateNo, aConnectID : Integer; aMsg : Byte; aData : PChar; aCount : Integer);

      procedure SetWriteAllow (aSocket : TCustomWinSocket);

      property Count : Integer read GetCount;
      property Items [aIndex : Integer] : Pointer read Get;
   end;

var
   GameServerConnectorList : TGameServerConnectorList;

implementation

uses
   uConnect, SVMain, UserSDB, BsCommon, uGroup;

// TGameServerConnector
constructor TGameServerConnector.Create (aGateNo : Integer; aName, aIpAddr : String);
begin
   Socket := nil;

   GateNo := aGateNo;
   Name := aName;
   IpAddr := aIpAddr;

   GameServerSender := nil;
   GameServerReceiver := nil;
end;

destructor TGameServerConnector.Destroy;
begin
   if GameServerSender <> nil then GameServerSender.Free;
   if GameServerReceiver <> nil then GameServerReceiver.Free;

   inherited Destroy;
end;

procedure TGameServerConnector.Init (aSocket : TCustomWinSocket);
begin
   Socket := aSocket;

   if GameServerSender <> nil then GameServerSender.Free;
   if GameServerReceiver <> nil then GameServerReceiver.Free;

   GameServerSender := TPacketSender.Create (Name, BufferSizeS2S, Socket);
   GameServerReceiver := TPacketReceiver.Create (Name, BufferSizeS2S);
end;

procedure TGameServerConnector.Clear;
begin
   Socket := nil;
   if GameServerSender <> nil then GameServerSender.Free;
   if GameServerReceiver <> nil then GameServerReceiver.Free;

   GameServerSender := nil;
   GameServerReceiver := nil;
end;

function TGameServerConnector.SendBytesPerSec : Integer;
begin
   if GameServerSender <> nil then begin
      Result := GameServerSender.SendBytesPerSec;
   end else begin
      Result := 0;
   end;
end;

function TGameServerConnector.ReceiveBytesPerSec : Integer;
begin
   if GameServerReceiver <> nil then begin
      Result := GameServerReceiver.ReceiveBytesPerSec;
   end else begin
      Result := 0;
   end;
end;

function TGameServerConnector.WBCount : Integer;
begin
   if GameServerSender <> nil then begin
      Result := GameServerSender.WouldBlockCount;
   end else begin
      Result := 0;
   end;
end;

function TGameServerConnector.WriteAllow : Boolean;
begin
   if GameServerSender <> nil then begin
      Result := GameServerSender.WriteAllow;
   end else begin
      Result := false;
   end;
end;

procedure TGameServerConnector.AddReceiveData (aData : PChar; aCount : Integer);
begin
   if aCount > 0 then begin
      GameServerReceiver.PutData (aData, aCount);
   end;
end;

procedure TGameServerConnector.AddSendData (aConnectID : Integer; aData : PChar; aCount : Integer);
begin
   if (aCount >= 0) and (aCount < SizeOf (TPacketData)) then begin
      GameServerSender.PutPacket (aConnectID, BG_GAMEDATA, 0, aData, aCount);
   end;
end;

procedure TGameServerConnector.AddSendServerData (aConnectID : Integer; aMsg : Byte; aData : PChar; aCount : Integer);
begin
   if (aCount >= 0) and (aCount < SizeOf (TPacketData)) then begin
      GameServerSender.PutPacket (aConnectID, aMsg, 0, aData, aCount);
   end;
end;

procedure TGameServerConnector.Update (CurTick : Integer);
var
   Packet : TPacketData;
begin
   if Socket = nil then exit;

   GameServerReceiver.Update;
   while GameServerReceiver.Count > 0 do begin
      if GameServerReceiver.GetPacket (@Packet) = false then break;
      MessageProcess (@Packet);
   end;
   GameServerSender.Update;
end;

procedure TGameServerConnector.MessageProcess (aPacket : PTPacketData);
var
   Connector : TConnector;
begin
   Case aPacket^.RequestMsg of
      GB_USERCONNECT :
         begin
            Connector := ConnectorList.CreateConnect (GateNo, aPacket);

            if Connector <> nil then begin
               Connector.WhereStatus := ws_group;
               Connector.SendBattleGroupList (0);            
            end else begin
               AddSendServerData (aPacket^.RequestID, BG_USERCLOSE, nil, 0);
            end;
         end;
      GB_USERDISCONNECT :
         begin
            ConnectorList.DeleteConnect (GateNo, aPacket^.RequestID);
         end;
      GB_GAMEDATA :
         begin
            ConnectorList.AddReceiveData (GateNo, aPacket);
         end;
   end;
end;

procedure TGameServerConnector.SetWriteAllow (boFlag : Boolean);
begin
   GameServerSender.WriteAllow := boFlag;
end;

// TGameServerConnectorList
constructor TGameServerConnectorList.Create;
begin
   UniqueID := 0;
   DataList := TList.Create;

   LoadFromFile ('.\Setting\CreateServer.SDB');
end;

destructor TGameServerConnectorList.Destroy;
begin
   Clear;
   DataList.Free;

   inherited Destroy;
end;

function TGameServerConnectorList.Get (aIndex : Integer) : Pointer;
begin
   Result := nil;
   if aIndex < DataList.Count then begin
      Result := DataList.Items [aIndex];
   end;
end;

function TGameServerConnectorList.GetCount : Integer;
begin
   Result := DataList.Count;
end;

procedure TGameServerConnectorList.Clear;
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      GameServerConnector.Free;
   end;
   DataList.Clear;
end;

function TGameServerConnectorList.GetGameServerName (aGateNo : Integer) : String;
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   Result := '';
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      if GameServerConnector.GateNo = aGateNo then begin
         Result := GameServerConnector.Name;
         exit;
      end;
   end;
end;

function TGameServerConnectorList.CreateConnect (aSocket : TCustomWinSocket) : Boolean;
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   Result := false;

   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      if GameServerConnector.IpAddr = aSocket.RemoteAddress then begin
         GameServerConnector.Init (aSocket);
         Result := true;
         exit;
      end;
   end;
end;

function TGameServerConnectorList.DeleteConnect (aSocket : TCustomWinSocket) : Boolean;
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   Result := false;
   
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      if GameServerConnector.Socket = aSocket then begin
         GameServerConnector.Clear;
         Result := true;
         exit;
      end;
   end;
end;

function TGameServerConnectorList.LoadFromFile (aFileName : String) : Boolean;
var
   i : Integer;
   DB : TUserStringDB;
   iName, Name, IpAddr : String;
   GameServerConnector : TGameServerConnector;
begin
   Result := false;

   if not FileExists (aFileName) then exit;

   DB := TUserStringDB.Create;
   DB.LoadFromFile (aFileName);

   for i := 0 to DB.Count - 1 do begin
      iName := DB.GetIndexName (i);
      if iName = '' then continue;

      Name := DB.GetFieldValueString (iName, 'Name');
      IpAddr := DB.GetFieldValueString (iName, 'IpAddr');

      GameServerConnector := TGameServerConnector.Create (UniqueID, Name, IpAddr);

      DataList.Add (GameServerConnector);
      Inc (UniqueID);
   end;

   Result := true;
end;

procedure TGameServerConnectorList.AddReceiveData (aSocket :  TCustomWinSocket; aData : PChar; aCount : Integer);
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      if GameServerConnector.Socket = aSocket then begin
         GameServerConnector.AddReceiveData (aData, aCount);
         exit;
      end;
   end;
end;

procedure TGameServerConnectorList.AddSendData (aGateNo, aConnectID : Integer; aData : PChar; aCount : Integer);
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      if GameServerConnector.GateNo = aGateNo then begin
         GameServerConnector.AddSendData (aConnectID, aData, aCount);
         exit;
      end;
   end;
end;

procedure TGameServerConnectorList.AddSendServerData (aGateNo, aConnectID : Integer; aMsg : Byte; aData : PChar; aCount : Integer);
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      if (GameServerConnector.GateNo = aGateNo) then begin
         GameServerConnector.AddSendServerData (aConnectID, aMsg, aData, aCount);
         exit;
      end;
   end;
end;

procedure TGameServerConnectorList.AddSendDataForAll (aData : PChar; aCount : Integer);
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      GameServerConnector.AddSendServerData (0, GM_SENDALL, aData, aCount);
   end;
end;

procedure TGameServerConnectorList.Update (CurTick : Integer);
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      GameServerConnector.Update (CurTick);
   end;
end;

procedure TGameServerConnectorList.SetWriteAllow (aSocket : TCustomWinSocket);
var
   i : Integer;
   GameServerConnector : TGameServerConnector;
begin
   for i := 0 to DataList.Count - 1 do begin
      GameServerConnector := DataList.Items [i];
      if GameServerConnector.Socket = aSocket then begin
         GameServerConnector.SetWriteAllow (true);
         exit;
      end;
   end;
end;

end.
