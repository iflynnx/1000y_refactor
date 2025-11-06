unit uSRemoteConnector;

interface

uses
  Classes, SysUtils, ScktComp, Deftype, uSBasicConnector, uRemoteDef, Dialogs, uCookie;

type
  TSRemoteConnector = class(TSBasicConnector)
  private
  protected
    procedure DoRead; override;
    procedure MessageProcess(var aPacket: TRemotePacket);
  public
    constructor Create(aSocket: TCustomWinSocket; aboServer: Boolean);
    destructor Destroy; override;
  end;

  TSRemoteConnectorList = class(TSBasicConnectorList)
  private
  protected
  public
    constructor Create(aboServer: Boolean);
    destructor Destroy; override;

    procedure StartListen(aPort: Integer); override;

    function AddConnector(aSocket: TCustomWinSocket): Boolean; override;
    function DelConnector(aSocket: TCustomWinSocket): Boolean; override;
  end;

implementation

uses
  fMain, uRecordDef, uDBProvider, uUtil, uConnector, uIpChecker;

// TSRemoteConnector;

constructor TSRemoteConnector.Create(aSocket: TCustomWinSocket; aboServer:
  Boolean);
begin
  inherited Create(aSocket, aboServer);
end;

destructor TSRemoteConnector.Destroy;
begin
  inherited Destroy;
end;

procedure TSRemoteConnector.DoRead;
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

procedure TSRemoteConnector.MessageProcess(var aPacket: TRemotePacket);
var
  Str, rdStr, keyStr, RetStr: String;
  DBRecord: TDBRecord;

  Packet: TRemotePacket;
  //Author:Steven Date: 2004-11-02 13:34:05
  //Note:OldStr, NewStr rdOldStr, rdNewStr
  OldDBRecord, NewDBRecord, tmpDBRecord: TDBRecord;
  OldStr, NewStr, rdOldStr, rdNewStr: String;

  FieldList: TStringList;

  i, j: Integer;
begin
  case aPacket.Cmd of
    REMOTE_CMD_NONE:
      begin

      end;
    REMOTE_CMD_FIELD:
      begin
        RetStr := frmMain.GetUserDataFields;
        Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
        Packet.Cmd := REMOTE_CMD_FIELD;
        Packet.Result := REMOTE_RESULT_OK;
        StrPCopy(@Packet.Data, RetStr);
        AddSendData(@Packet, Packet.Len);
      end;
    REMOTE_CMD_READ:
      begin
        keyStr := StrPas(@aPacket.Data);
         RetStr := DBProvider.ChangeDataToStr (@DBRecord);
        if DBProvider.Select(keyStr, @DBRecord) <> DB_OK then
        begin
          RetStr := format('%s Data read failed', [keyStr]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetSTr) + 1;
          Packet.Cmd := REMOTE_CMD_READ;
          Packet.Result := REMOTE_RESULT_NOTFOUND;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
          exit;
        end;
        if CurrentCharList.Select(KeyStr) <> nil then
        begin
          RetStr := format('%s is now playing', [keyStr]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_READ;
          Packet.Result := REMOTE_RESULT_NOACCESS;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
          exit;
        end;

        //Author:Steven Date: 2004-11-02 13:22:47
        //Note:DBProvider.ChangeDataToStr (@DBRecord)对Record进行了String的转换
         // add by Orber at 2004-11-25 15:27:06
        RetStr := DBProvider.ChangeDataToStr(@DBRecord);
         // add by Orber at 2004-11-25 15:50:41
        if DBRecord.CRCKey <> oz_CRC32(@DBRecord,SizeOf(DBRecord) - 4) then
        begin
          RetStr := RetStr + ',ErrorCRCKey';
          Str := Format('%s ErrorCRCKey', [KeyStr]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(Str) + 1;
          Packet.Cmd := REMOTE_CMD_WRITE;
          Packet.Result := REMOTE_RESULT_OK;
          StrPCopy(@Packet.Data, Str);
          AddSendData(@Packet, Packet.Len);
        end
        else
        begin
          RetStr := RetStr + ',OK';
        end;




        Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
        Packet.Cmd := REMOTE_CMD_READ;
        Packet.Result := REMOTE_RESULT_OK;
        StrPCopy(@Packet.Data, RetStr);
        AddSendData(@Packet, Packet.Len);
      end;
    REMOTE_CMD_WRITE:
      begin
        Str := StrPas(@aPacket.Data);
        Str := GetTokenStr(Str, keyStr, ',');

        if DBProvider.Select(keyStr, @DBRecord) <> DB_OK then
        begin
          RetStr := format('%s Data Not Found', [keyStr]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_WRITE;
          Packet.Result := REMOTE_RESULT_NOTFOUND;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
          exit;
        end;
        if CurrentCharList.Select(KeyStr) <> nil then
        begin
          RetStr := format('%s is now playing', [keyStr]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_WRITE;
          Packet.Result := REMOTE_RESULT_NOACCESS;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
          exit;
        end;

        FillChar(DBRecord, SizeOf(TDBRecord), 0);
        DBRecord.boUsed := 1;

        DBProvider.ChangeStrToData(keyStr + ',' + Str, DBRecord);

        //Author:Steven Date: 2004-11-02 11:01:28//////////////////////////////
        //Note:
        {获取字段列表}
        FieldList := TStringList.Create;
        with FieldList do
        begin
          Clear;
          OldStr := frmMain.GetUserDataFields;
          while OldStr <> '' do
          begin
            OldStr := GetTokenStr (OldStr, rdOldStr, ',');
            Add (rdOldStr);
         end;
        end;
        { OldDBRecord}
        DBProvider.Select(keyStr, @OldDBRecord);
        {}
        OldStr := DBProvider.ChangeDataToStr(@OldDBRecord);
        { NewDBRecord }
        NewDBRecord := DBRecord;
        {}
        NewStr := DBProvider.ChangeDataToStr(@NewDBRecord);
        { Compare DBRecord }
        for i := 0 to FieldList.Count - 1 do
        begin
          OldStr := GetTokenStr(OldStr, rdOldStr, ',');
          NewStr := GetTokenStr(NewStr, rdNewStr, ',');
          if rdOldStr <> rdNewStr then
          begin
            RetStr := Format('%s UserData Writed, 字段:%s, 值:"%s" -> 值:"%s"',
              [keyStr, FieldList.Strings[i], rdOldStr, rdNewStr]);
            Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetSTr) + 1;
            Packet.Cmd := REMOTE_CMD_WRITE;
            Packet.Result := REMOTE_RESULT_OK;
            StrPCopy(@Packet.Data, RetStr);
            AddSendData(@Packet, Packet.Len);
          end;

        end;

        { Free FieldList }
        FieldList.Free;



        //////////////////////////////////////////////////////////////////////
        // add by Orber at 2004-11-25 15:11:58
        DBRecord.CRCKey := oz_CRC32(@DBRecord,SizeOf(DBRecord) - 4);
        if DBProvider.Update(keyStr, @DBRecord) = DB_OK then
        begin
          RetStr := format('%s UserData writed', [keyStr]);

          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetSTr) + 1;
          Packet.Cmd := REMOTE_CMD_WRITE;
          Packet.Result := REMOTE_RESULT_OK;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
        end
        else
        begin
          RetStr := format('%s Data write failed', [keyStr]);
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_WRITE;
          Packet.Result := REMOTE_RESULT_DUPLICATE;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
        end;
      end;
    REMOTE_CMD_INSERT:
      begin

      end;
    REMOTE_CMD_DELETE:
      begin

      end;
    REMOTE_CMD_RESULT:
      begin

      end;
    {
    REMOTE_CMD_LOGIN : begin           // 肺弊牢持扁...
       Str := StrPas (@aPacket.Data);
       Str := GetTokenStr (Str, keyStr, ',');

       if RemoteUserList.FindRemoteUser(keyStr, Str) = true then begin
          RetStr := frmMain.GetUserDataFields;
          Packet.Len := SizeOf (Word) + SizeOf (Byte) * 2 + Length (RetStr) + 1;
          Packet.Cmd := REMOTE_CMD_FIELD;
          Packet.Result := REMOTE_RESULT_OK;
          StrPCopy (@Packet.Data, RetStr);
          AddSendData (@Packet, Packet.Len);

          WriteRemoteLog (format ('%s UserData Connect', [keyStr]));
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
  REMOTE_ITEM_SEND:
    begin
      Str := StrPas(@aPacket.Data);
      { 处理消息包 }
      {
        更新物品栏位
      }

      with TStringList.Create do
      begin
        Clear;
        Text := Str;
        for i := Count - 1 downto 0 do
        begin
          Str := Strings[i];
          Str := GetTokenStr(Str, keyStr, ',');
          if DBProvider.Select(keyStr, @tmpDBRecord) = DB_OK then
          begin
            for j := 0 to HAVEITEMSIZE do
            begin
              RetStr := StrPas(@tmpDBRecord.HaveItemArr[j].Name) + ':' +
                IntToStr (tmpDBRecord.HaveItemArr[j].Color) + ':' +
                IntToStr (tmpDBRecord.HaveItemArr[j].Count) + ':' +
                IntToSTr (tmpDBRecord.HaveItemArr[j].CurDurability) + ':' +
                IntToSTr (tmpDBRecord.HaveItemArr[j].Durability) + ':' +
                IntToSTr (tmpDBRecord.HaveItemArr[j].Upgrade) + ':' +
                IntToSTr (tmpDBRecord.HaveItemArr[j].AddType)+ ':' +
                IntToSTr (tmpDBRecord.HaveItemArr[j].LockState)+ ':' +
                IntToSTr (tmpDBRecord.HaveItemArr[j].unLockTime);
              if (RetStr = ':0:0:0:0:0:0:0:0') then
              begin
                Str := GetTokenStr(Str, rdStr, ',');
                Str := rdStr;
                //存入数据
                with tmpDBRecord.HaveItemArr[j] do
                begin
                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    StrPCopy(@Name, rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    Color := StrToInt(rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    Count := StrToInt(rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    CurDurability := StrToInt(rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    Durability := StrToInt(rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    Upgrade := StrToInt(rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    AddType := StrToInt(rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    LockState := StrToInt(rdStr);

                  Str := GetTokenStr(Str, rdStr, ':');
                  if rdStr <> '' then
                    unLockTime := StrToInt(rdStr);
                end;

                if DBProvider.Update(keyStr, @tmpDBRecord) = DB_OK then
                begin
                  { 此记录已操作，删除此记录 }
                  Delete(i);
                  { 跳出循环 }
                  Break;
                end;
              end;
            end;
          end;
        end;
          { 更新失败的记录被返回 }
        if Text <> '' then
        begin
          RetStr := Text;
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_ITEM_SEND;
          Packet.Result := REMOTE_ITEM_FAIL;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
        end
        else
        begin
          RetStr := '';
          Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2 + Length(RetStr) + 1;
          Packet.Cmd := REMOTE_ITEM_SEND;
          Packet.Result := REMOTE_ITEM_SUCCESS;
          StrPCopy(@Packet.Data, RetStr);
          AddSendData(@Packet, Packet.Len);
        end;

      end;

      {

      }



    end;
  else
    begin

    end;
  end;
end;

// TSRemoteConnectorList;

constructor TSRemoteConnectorList.Create(aboServer: Boolean);
begin
  inherited Create(aboServer);
end;

destructor TSRemoteConnectorList.Destroy;
begin
  inherited Destroy;
end;

procedure TSRemoteConnectorList.StartListen(aPort: Integer);
begin
  inherited StartListen(aPort);
end;

function TSRemoteConnectorList.AddConnector(aSocket: TCustomWinSocket): Boolean;
var
  Connector: TSRemoteConnector;
begin
  // add by Orber at 2005-03-21 12:10:21

   Result := false;
    WriteLogInfo1 (aSocket.RemoteAddress + ':' + IntToStr(aSocket.RemotePort) ,'Refuse','Remote_ITEM');
    aSocket.Close;
{

  if RemoteIPList.IndexOf(aSocket.RemoteAddress) < 0 then
  begin
    aSocket.Close;
    exit;
  end;

  Connector := TSRemoteConnector.Create(aSocket, FboServer);
  if FSocketKey.Insert(aSocket.SocketHandle, Connector) = true then
  begin
    FDataList.Add(Connector);
    Result := true;
    exit;
  end;

  Connector.Free;}
end;

function TSRemoteConnectorList.DelConnector(aSocket: TCustomWinSocket): Boolean;
var
  Connector: TSRemoteConnector;
begin
  Result := false;

  Connector := FSocketKey.Select(aSocket.SocketHandle);
  if Connector <> nil then
  begin
  // add by Orber at 2005-03-21 12:11:01
    WriteLogInfo1 (aSocket.RemoteAddress + ':' + IntToStr(aSocket.RemotePort) ,'DisConnect','Remote');
    Connector.FSocket := nil;
    Connector.FboDeleteAllow := true;
    Result := true;
    exit;
  end;
end;

end.


