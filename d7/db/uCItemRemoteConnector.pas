unit uCItemRemoteConnector;

interface

uses
   Classes, SysUtils, ScktComp, uCBasicConnector, WinSock, uRemoteDef ,Deftype , Dialogs, uCookie;

type

   TCItemRemoteConnector = class (TCBasicConnector)
   private
   protected
      FSocketHandle : Integer;

      procedure OnConnect (Sender: TObject; Socket: TCustomWinSocket); override;
      procedure DoRead; override;
      procedure MessageProcess (var aPacket : TRemotePacket);
   public
      constructor Create (aName, aIP : String; aPort : Integer);
      destructor Destroy; override;
      procedure AddRequestData (aMsgID, aResultCode : Integer; aData : String);
      procedure Update (CurTick : LongWord); override;

   end;

implementation

uses
   FMain, uRecordDef, uDBProvider, uUtil, uConnector, uIpChecker;

// TCItemRemoteConnector;
constructor TCItemRemoteConnector.Create (aName, aIP : String; aPort : Integer);
begin
   inherited Create (aName, 8192, 65536, 1024 * 128);

   FAddress := aIP;
   FPort := aPort;
end;

destructor TCItemRemoteConnector.Destroy;
begin
   inherited Destroy;
end;

procedure TCItemRemoteConnector.Update (CurTick : LongWord);
begin
   inherited Update (CurTick);
end;


procedure TCItemRemoteConnector.DoRead;
var
   Packet : TRemotePacket;
begin
   while FRecvBuffer.Count > SizeOf (Word) do begin
      if FRecvBuffer.View (@Packet, SizeOf (Word)) = false then break;
      if FRecvBuffer.Count < Packet.Len then break;
      if FRecvBuffer.Get (@Packet, Packet.Len) = false then break;
      MessageProcess(Packet);
   end;
end;

procedure TCItemRemoteConnector.OnConnect (Sender: TObject; Socket: TCustomWinSocket);
var  RetStr :String;
    Packet : TRemotePacket;
begin
    RetStr := 'ITEM';
    Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
    Packet.Cmd := REMOTE_CMD_WHOAMI;
    Packet.Result := REMOTE_RESULT_OK;
    StrPCopy(@Packet.Data, RetStr);
    AddSendData(@Packet, Packet.Len);
end;

procedure TCItemRemoteConnector.AddRequestData (aMsgID, aResultCode : Integer; aData : String);
var
   RetStr : String;
   Packet : TRemotePacket;
begin
   if aResultCode = 0 then begin
      Case aMsgID of
         DB_ITEMSELECT :
            begin
               RetStr := aData;
               Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
               Packet.Cmd := REMOTE_CMD_READ;
               Packet.Result := REMOTE_RESULT_OK;
               StrPCopy (@Packet.Data, RetStr);
               AddSendData (@Packet, Packet.Len);
            end;
         DB_ITEMUPDATE :
            begin
//               RetStr := format ('itemdata write ok (%s)', [DataUserName]);
               RetStr := Format('ItemData Writed, %s', [aData]);
               Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
               Packet.Cmd := REMOTE_CMD_WRITE;
               Packet.Result := REMOTE_RESULT_OK;
               StrPCopy (@Packet.Data, RetStr);
               AddSendData (@Packet, Packet.Len);
            end;
      end;
   end else begin
      Case aMsgID of
         DB_ITEMSELECT : begin
            RetStr := format ('itemdata read failed (%s)', [aData]);
            Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
            Packet.Cmd := REMOTE_CMD_READ;
            Packet.Result := REMOTE_RESULT_NOTFOUND;
            StrPCopy (@Packet.Data, RetStr);
            AddSendData (@Packet, Packet.Len);
         end;
         DB_ITEMUPDATE : begin
            RetStr := format ('itemdata write failed (%s)', [aData]);
            Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
            Packet.Cmd := REMOTE_CMD_WRITE;
            Packet.Result := REMOTE_RESULT_NOTFOUND;
            StrPCopy (@Packet.Data, RetStr);
            AddSendData (@Packet, Packet.Len);
         end;
      end;
   end;
end;

procedure TCItemRemoteConnector.MessageProcess (var aPacket : TRemotePacket);
var
   DataStr, str, keyStr, RetStr : String;
   DBRecord : TDBRecord;
   buffer : array [0..2048 - 1] of Char;
   Packet : TRemotePacket;
begin
   Case aPacket.Cmd of
      REMOTE_CMD_NONE : begin
      end;
      REMOTE_CMD_FIELD : begin
         RetStr := frmMain.GetItemDataFields;
         Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
         Packet.Cmd := REMOTE_CMD_FIELD;
         Packet.Result := REMOTE_RESULT_OK;
         StrPCopy (@Packet.Data, RetStr);
         AddSendData (@Packet, Packet.Len);
      end;
      REMOTE_CMD_READ : begin
         keyStr := StrPas (@aPacket.Data);
         if Trim (keyStr) = '' then exit;
         FillChar (DBRecord, SizeOf (TDBRecord), 0);
         StrPCopy (@DBRecord.PrimaryKey, KeyStr);
         ConnectorList.AddPacketToGameServer (FSocketHandle, DB_ITEMSELECT, 0, @DBRecord.PrimaryKey, SizeOf (DBRecord.PrimaryKey));
      end;
      REMOTE_CMD_WRITE : begin
         DataStr := StrPas (@aPacket.Data);
         Str := DataStr;
         Str := GetTokenStr (Str, keyStr, ',');
         if Trim (keyStr) = '' then exit;
         StrPCopy (@buffer, DataStr);
         ConnectorList.AddPacketToGameServer (FSocketHandle, DB_ITEMUPDATE, 0, @buffer, StrLen (buffer) + 1);
      end;

      Else begin

      end;
   end;
end;

end.
