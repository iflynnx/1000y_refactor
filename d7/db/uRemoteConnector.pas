unit uRemoteConnector;

interface

uses
   Windows, Classes, SysUtils, ScktComp, uRecordDef, DefType, uPackets, AUtil32;

type
   TRemoteType = ( rt_userdata, rt_itemdata );
   
   TRemoteConnector = class
   private
      Socket : TCustomWinSocket;

      RemoteType : TRemoteType;

      PacketSender : TPacketSender;
      PacketReceiver : TPacketReceiver;
   protected
   public
      constructor Create (aSocket : TCustomWinSocket; aType : TRemoteType);
      destructor Destroy; override;

      procedure Clear;

      procedure Update (CurTick : Integer);
      procedure MessageProcess (var aPacket : TPacketData);
      
      procedure AddReceiveData (aData : PChar; aSize : Integer);
      procedure AddSendData (aID : Integer; aMsg : Word; aRetCode : Byte; aStr : String);

      procedure AddRequestData (aConnectID : Integer; aMsgID, aResultCode : Byte; aData : String);

      function isConnected : Boolean;

      procedure SetWriteAllow;
      procedure SetSocket (aSocket : TCustomWinSocket);
   end;
   
var
   RemoteConnector : TRemoteConnector = nil;

implementation

uses
   FMain, uDBProvider, uUtil, uConnector;

// TRemoteConnector
constructor TRemoteConnector.Create (aSocket : TCustomWinSocket; aType : TRemoteType);
begin
   Socket := aSocket;

   RemoteType := aType;
   
   PacketSender := TPacketSender.Create ('', 32768, aSocket, false, false);
   PacketReceiver := TPacketReceiver.Create ('', 32768, false);
end;

destructor TRemoteConnector.Destroy;
begin
   PacketSender.Free;
   PacketReceiver.Free;
   
   inherited Destroy;
end;

procedure TRemoteConnector.Clear;
begin
   PacketSender.Clear;
   PacketReceiver.Clear;
end;

procedure TRemoteConnector.AddReceiveData (aData : PChar; aSize : Integer);
begin
   PacketReceiver.PutData (aData, aSize);
end;

procedure TRemoteConnector.AddSendData (aID : Integer; aMsg : Word; aRetCode : Byte; aStr : String);
var
   pd : PTWordInfoString;
   ComData : TWordComData;
begin
   pd := PTWordInfoString (@ComData.Data);
   SetWordString (pd^.rWordString, aStr);

   ComData.Size := Sizeof (TWordInfoString) - sizeof(TWordString) + SizeofWordString(pd^.rWordString);
   PacketSender.PutPacket (aID, aMsg, aRetCode, @ComData, ComData.Size + SizeOf (Word));
end;

procedure TRemoteConnector.AddRequestData (aConnectID : Integer; aMsgID, aResultCode : Byte; aData : String);
var
   RetStr : String;
begin
   if aResultCode = 0 then begin
      Case aMsgID of
         DB_ITEMSELECT :
            begin
               RetStr := aData;
               AddSendData (aConnectID, PACKET_DB, 0, RetStr);
            end;
         DB_ITEMUPDATE :
            begin
               RetStr := aData;
               AddSendData (aConnectID, PACKET_DB, 0, RetStr);
            end;
      end;
   end else begin
      RetStr := 'Message,data read failed';
      AddSendData (aConnectID, PACKET_DB, 0, RetStr);
   end;
end;

procedure TRemoteConnector.Update (CurTick : Integer);
var
   Packet : TPacketData;
begin
   PacketSender.Update;
   PacketReceiver.Update;
   while PacketReceiver.Count > 0 do begin
      if PacketReceiver.GetPacket (@Packet) = false then break;
      MessageProcess (Packet);
   end;
end;

procedure TRemoteConnector.MessageProcess (var aPacket : TPacketData);
var
   rStr, str, cmdStr, keyStr, RetStr : String;
   DBRecord : TDBRecord;
   buffer : array [0..2048 - 1] of Char;

   pComData : PTWordComData;
   pd : PTWordInfoString;
begin
   pComData := PTWordComData (@aPacket.Data);
   pd := PTWordInfoString (@pComData^.Data);

   rStr := GetWordString (pd^.rWordString);
   while true do begin
      rStr := GetTokenStr (rStr, Str, #13);
      if Str = '' then break;

      str := GetTokenStr (str, cmdStr, ',');
      str := GetTokenStr (str, keyStr, ',');

      cmdStr := Trim (cmdStr);
      keyStr := Trim (keyStr);
      if cmdStr = '' then exit;

      if cmdStr = 'REMOTETYPE' then begin
         if KeyStr = '0' then begin
            RemoteType := rt_userdata;
            RetStr := 'Message,remote type is userdata';
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end else begin
            RemoteType := rt_itemdata;
            RetStr := 'Message,remote type is itemdata';
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end;
         exit;
      end;

      if RemoteType = rt_userdata then begin
         if UpperCase (cmdStr) = 'FIELDS' then begin
            RetStr := 'Fields,' + frmMain.GetUserDataFields;
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end else if UpperCase (cmdStr) = 'CREATE' then begin
         end else if UpperCase (cmdStr) = 'DELETE' then begin
         end else if UpperCase (cmdStr) = 'READ' then begin
            if Trim (keyStr) = '' then begin
               RetStr := 'Message,wrong primary key';
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;
            if DBProvider.Select (keyStr, @DBRecord) <> DB_OK then begin
               RetStr := format ('Message,read fail (%s)', [keyStr]);
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;
            if CurrentCharList.Select (KeyStr) <> nil then begin
               RetStr := 'Message,' + KeyStr + ' is playing now';
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;
            RetStr := 'UserData,' + DBProvider.ChangeDataToStr (@DBRecord);
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);

            RetStr := format ('Message,read ok (%s)', [keyStr]);
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end else if UpperCase (cmdStr) = 'WRITE' then begin
            if keyStr = '' then begin
               RetStr := 'Message,wrong primary key';
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;
            if CurrentCharList.Select (KeyStr) <> nil then begin
               RetStr := 'Message,' + KeyStr + ' is playing now';
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;

            FillChar (DBRecord, SizeOf (TDBRecord), 0);
            DBRecord.boUsed := 1;

            DBProvider.ChangeStrToData (keyStr + ',' + str, DBRecord);
            if DBProvider.Update (keyStr, @DBRecord) <> DB_OK then begin
               RetStr := format ('Message,write fail (%s)', [keyStr]);
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;
            RetStr := format ('Message,write ok (%s)', [keyStr]);
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end else begin
            frmMain.AddLog ('Unknown Command Received - ' + rStr);
         end;
      end else begin
         if UpperCase (cmdStr) = 'FIELDS' then begin
            RetStr := 'Fields,' + frmMain.GetItemDataFields;
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end else if UpperCase (cmdStr) = 'CREATE' then begin
         end else if UpperCase (cmdStr) = 'DELETE' then begin
         end else if UpperCase (cmdStr) = 'READ' then begin
            if Trim (keyStr) = '' then begin
               RetStr := 'Message,wrong primary key';
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;
            FillChar (DBRecord, SizeOf (TDBRecord), 0);
            StrPCopy (@DBRecord.PrimaryKey, KeyStr);
            ConnectorList.AddPacketToGameServer (aPacket.RequestID, DB_ITEMSELECT, 0, @DBRecord.PrimaryKey, SizeOf (DBRecord.PrimaryKey));

            RetStr := format ('Message,read request was send (%s)', [keyStr]);
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end else if UpperCase (cmdStr) = 'WRITE' then begin
            if Trim (keyStr) = '' then begin
               RetStr := 'Message, wrong primary key';
               AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
               exit;
            end;
            StrPCopy (@buffer, KeyStr + ',' + Str);
            ConnectorList.AddPacketToGameServer (aPacket.RequestID, DB_ITEMUPDATE, 0, @buffer, StrLen (buffer) + 1);

            RetStr := format ('Message,write request was send (%s)', [keyStr]);
            AddSendData (aPacket.RequestID, PACKET_DB, 0, RetStr);
         end else begin
            frmMain.AddLog ('Unknown Command Received - ' + rStr);
         end;
      end;
   end;
end;

function TRemoteConnector.isConnected : Boolean;
begin
   Result := false;
   if PacketSender.SocketObject <> nil then begin
      Result := true;
   end;
end;

procedure TRemoteConnector.SetWriteAllow;
begin
   PacketSender.WriteAllow := true;
end;

procedure TRemoteConnector.SetSocket (aSocket : TCustomWinSocket);
begin
   PacketSender.SocketObject := aSocket;
end;

initialization
begin
   RemoteConnector := TRemoteConnector.Create (nil, rt_userdata);
end;

finalization
begin
   RemoteConnector.Free;
end;

end.
