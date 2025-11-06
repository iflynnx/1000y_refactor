unit uSItemRemoteConnector;

interface

uses
  Classes, SysUtils, ScktComp, Deftype, uSBasicConnector, uRemoteDef;

type
  TSItemRemoteConnector = class(TSBasicConnector)
  private
  protected
    procedure DoRead; override;
    procedure MessageProcess(var aPacket: TRemotePacket);
  public
    constructor Create(aSocket: TCustomWinSocket; aboServer: Boolean);
    destructor Destroy; override;

    procedure AddRequestData(aMsgID, aResultCode: Integer; aData: string);
  end;

  TSItemRemoteConnectorList = class(TSBasicConnectorList)
  private
  protected
  public
    constructor Create(aboServer: Boolean);
    destructor Destroy; override;

    procedure StartListen(aPort: Integer); override;

    function AddConnector(aSocket: TCustomWinSocket): Boolean; override;
    function DelConnector(aSocket: TCustomWinSocket): Boolean; override;

    procedure AddRequestData(aRequestID, aMsgID, aResultCode: Integer; aData:
      string);
  end;

implementation

uses
  fMain, uRecordDef, uDBProvider, uUtil, uConnector, uIpChecker;

// TSItemRemoteConnector;

constructor TSItemRemoteConnector.Create(aSocket: TCustomWinSocket; aboServer:
  Boolean);
begin
  inherited Create(aSocket, aboServer);
end;

destructor TSItemRemoteConnector.Destroy;
begin
  inherited Destroy;
end;

procedure TSItemRemoteConnector.DoRead;
var
  Packet: TRemotePacket;
begin
  while FRecvBuffer.Count > SizeOf(Word) do
  begin
    if FRecvBuffer.View(@Packet, SizeOf(Word)) = false then
      break;
    if FRecvBuffer.Count < Packet.Len then
      break;
    if FRecvBuffer.Get(@Packet, Packet.Len) = false then
      break;
    MessageProcess(Packet);
  end;
end;

procedure TSItemRemoteConnector.AddRequestData(aMsgID, aResultCode: Integer;
  aData: string);
var
  RetStr: string;
  Packet: TRemotePacket;
begin
  if aResultCode = 0 then
  begin
    case aMsgID of
      DB_ITEMSELECT:
        begin
          RetStr := aData;
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_READ;
          Packet.Result := REMOTE_RESULT_OK;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
        end;
      DB_ITEMUPDATE:
        begin
          //               RetStr := format ('itemdata write ok (%s)', [DataUserName]);

          RetStr := Format('ItemData Writed, %s', [aData]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_WRITE;
          Packet.Result := REMOTE_RESULT_OK;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);



{
            RetStr := Format('%s UserData Writed, ×Ö¶Î:%s, Öµ:"%s" -> Öµ:"%s"',
              [keyStr, FieldList.Strings[i], rdOldStr, rdNewStr]);
            Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetSTr) + 1;
            Packet.Cmd := REMOTE_CMD_WRITE;
            Packet.Result := REMOTE_RESULT_OK;
            StrPCopy(@Packet.Data, RetStr);

}

        end;
    end;
  end
  else
  begin
    case aMsgID of
      DB_ITEMSELECT:
        begin
          RetStr := format('Itemdata read failed (%s)', [aData]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_READ;
          Packet.Result := REMOTE_RESULT_NOTFOUND;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
        end;
      DB_ITEMUPDATE:
        begin
          RetStr := format('Itemdata write failed (%s)', [aData]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_WRITE;
          Packet.Result := REMOTE_RESULT_NOTFOUND;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
        end;
    end;
  end;
end;

procedure TSItemRemoteConnector.MessageProcess(var aPacket: TRemotePacket);
var
  DataStr, str, keyStr, RetStr: string;
  DBRecord: TDBRecord;
  buffer: array[0..2048 - 1] of Char;
  Packet: TRemotePacket;
begin
  case aPacket.Cmd of
    REMOTE_CMD_NONE:
      begin
      end;
    REMOTE_CMD_FIELD:
      begin
        RetStr := frmMain.GetItemDataFields;
        Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
        Packet.Cmd := REMOTE_CMD_FIELD;
        Packet.Result := REMOTE_RESULT_OK;
        StrPCopy(@Packet.Data, RetStr);
        AddSendData(@Packet, Packet.Len);
      end;
    REMOTE_CMD_READ:
      begin
        keyStr := StrPas(@aPacket.Data);

        {
        if CurrentCharList.Select (KeyStr) <> nil then begin
           RetStr := format ('%s is now playing', [keyStr]);
           Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
           Packet.Cmd := REMOTE_CMD_READ;
           Packet.Result := REMOTE_RESULT_NOACCESS;
           StrPCopy (@Packet.Data, RetStr);
           AddSendData (@Packet, Packet.Len);
           exit;
        end;
        }
        if Trim(keyStr) = '' then
          exit;
        FillChar(DBRecord, SizeOf(TDBRecord), 0);
        StrPCopy(@DBRecord.PrimaryKey, KeyStr);
        ConnectorList.AddPacketToGameServer(FSocketHandle, DB_ITEMSELECT, 0,
          @DBRecord.PrimaryKey, SizeOf(DBRecord.PrimaryKey));
      end;
    REMOTE_CMD_WRITE:
      begin
        DataStr := StrPas(@aPacket.Data);
        Str := DataStr;
        Str := GetTokenStr(Str, keyStr, ',');

        {
        if CurrentCharList.Select (KeyStr) <> nil then begin
           RetStr := format ('%s is now playing', [keyStr]);
           Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
           Packet.Cmd := REMOTE_CMD_WRITE;
           Packet.Result := REMOTE_RESULT_NOACCESS;
           StrPCopy (@Packet.Data, RetStr);
           AddSendData (@Packet, Packet.Len);
           exit;
        end;
        }
        if Trim(keyStr) = '' then
          exit;
        StrPCopy(@buffer, DataStr);
        ConnectorList.AddPacketToGameServer(FSocketHandle, DB_ITEMUPDATE, 0,
          @buffer, StrLen(buffer) + 1);
      end;
    {
    REMOTE_CMD_LOGIN : begin           // ·Î±×ÀÎ³Ö±â...
       Str := StrPas (@aPacket.Data);
       Str := GetTokenStr (Str, keyStr, ',');

       if RemoteUserList.FindRemoteUser(keyStr, Str) = true then begin
          RetStr := frmMain.GetItemDataFields;
          Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_FIELD;
          Packet.Result := REMOTE_RESULT_OK;
          StrPCopy (@Packet.Data, RetStr);
          AddSendData (@Packet, Packet.Len);

          WriteRemoteLog (format ('%s ItemLogData Connect', [keyStr]));
       end else begin
          RetStr := format ('%s Connect Failed', [keystr]);;
          Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_LOGIN;
          Packet.Result := REMOTE_RESULT_NOTFOUND;
          StrPCopy (@Packet.Data, RetStr);
          AddSendData (@Packet, Packet.Len);
       end;
    end;
    }
  else
    begin

    end;
  end;
end;

// TSItemRemoteConnectorList;

constructor TSItemRemoteConnectorList.Create(aboServer: Boolean);
begin
  inherited Create(aboServer);
end;

destructor TSItemRemoteConnectorList.Destroy;
begin
  inherited Destroy;
end;

procedure TSItemRemoteConnectorList.StartListen(aPort: Integer);
begin
  inherited StartListen(aPort);
end;

function TSItemRemoteConnectorList.AddConnector(aSocket: TCustomWinSocket):
  Boolean;
var
  Connector: TSItemRemoteConnector;
begin
   Result := false;
    WriteLogInfo1 (aSocket.RemoteAddress + ':' + IntToStr(aSocket.RemotePort) ,'Refuse','Remote_ITEM');
    aSocket.Close;

{  if RemoteIPList.IndexOf(aSocket.RemoteAddress) < 0 then
  begin
    aSocket.Close;
    exit;
  end;

  Connector := TSItemRemoteConnector.Create(aSocket, FboServer);
  if FSocketKey.Insert(aSocket.SocketHandle, Connector) = true then
  begin
    FDataList.Add(Connector);
    Result := true;
    exit;
  end;

  Connector.Free;}
end;

function TSItemRemoteConnectorList.DelConnector(aSocket: TCustomWinSocket):
  Boolean;
var
  Connector: TSItemRemoteConnector;
begin
  Result := false;

  Connector := FSocketKey.Select(aSocket.SocketHandle);
  if Connector <> nil then
  begin
    Connector.FSocket := nil;
    Connector.FboDeleteAllow := true;
    Result := true;
    exit;
  end;
end;

procedure TSItemRemoteConnectorList.AddRequestData(aRequestID, aMsgID,
  aResultCode: Integer; aData: string);
var
  Connector: TSItemRemoteConnector;
begin
  Connector := FSocketKey.Select(aRequestID);
  if Connector <> nil then
  begin
    Connector.AddRequestData(aMsgID, aResultCode, aData);
    exit;
  end;
end;

end.

