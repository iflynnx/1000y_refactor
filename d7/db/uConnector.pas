unit uConnector;

interface

uses
  Windows, Classes, SysUtils, ScktComp, uBuffer, uRecordDef, uPackets, DefType,
    uCookie, Dialogs;

type
  TConnectType = (ct_gate, ct_gameserver);

  TConnector = class
  private
    Socket: TCustomWinSocket;
    boWriteAllow: Boolean;

    ConnectType: TConnectType;

    GateSender: TPacketSender;
    GateReceiver: TPacketReceiver;
  protected
  public
    constructor Create(aSocket: TCustomWinSocket);
    destructor Destroy; override;

    procedure Update(CurTick: Integer);
    procedure MessageProcess(aPacket: PTPacketData);

    procedure AddReceiveData(aData: PChar; aCount: Integer);
    procedure AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData: PChar;
      aSize: Integer);

    procedure SetWriteAllow(boFlag: Boolean);
  end;

  TConnectorList = class
  private
    DataList: TList;

    function GetCount: Integer;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    function CreateConnect(aSocket: TCustomWinSocket): Boolean;
    function DeleteConnect(aSocket: TCustomWinSocket): Boolean;

    procedure Update(CurTick: Integer);

    procedure AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount:
      Integer);

    procedure SetWriteAllow(aSocket: TCustomWinSocket);

    function AddPacketToGameServer(aID: Integer; aMsg, aRetCode: Byte; aData:
      PChar; aSize: Integer): Boolean;

    property Count: Integer read GetCount;
  end;

var
  ConnectorList: TConnectorList;

implementation

uses
  FMain, uDBProvider;

// TConnector

constructor TConnector.Create(aSocket: TCustomWinSocket);
begin
  Socket := aSocket;
  boWriteAllow := false;

  ConnectType := ct_gate;

  GateSender := TPacketSender.Create('Gate', BufferSizeS2S, aSocket, false,
    false);
  GateReceiver := TPacketReceiver.Create('Gate', BufferSizeS2S, false);
end;

destructor TConnector.Destroy;
begin
  GateSender.Free;
  GateReceiver.Free;

  inherited Destroy;
end;

procedure TConnector.SetWriteAllow(boFlag: Boolean);
begin
  GateSender.WriteAllow := boFlag;
end;

procedure TConnector.AddReceiveData(aData: PChar; aCount: Integer);
begin
  if aCount > 0 then
  begin
    GateReceiver.PutData(aData, aCount);
    frmMain.AddEvent(format('DataReceived (%d bytes %s)', [aCount,
      Socket.RemoteAddress]));
  end;
end;

procedure TConnector.AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData:
  PChar; aSize: Integer);
begin
  if aSize < SizeOf(TPacketData) then
  begin
    GateSender.PutPacket(aID, aMsg, aRetCode, aData, aSize);
    frmMain.AddEvent(format('DataSend (%d bytes %s)', [aSize,
      Socket.RemoteAddress]));
  end;
end;

procedure TConnector.Update(CurTick: Integer);
var
  Packet: TPacketData;
begin
  GateReceiver.Update;
  while GateReceiver.Count > 0 do
  begin
    if GateReceiver.GetPacket(@Packet) = false then
      break;
    MessageProcess(@Packet);
  end;

  GateSender.Update;
end;

procedure TConnector.MessageProcess(aPacket: PTPacketData);
var
  RecordData: TDBRecord;
  KeyValue, mStr: string;
  nCode: Byte;
  // add by minds at 2005-01-27
  nYear, nMonth, nDay: Word;
begin
  case aPacket^.RequestMsg of
    DB_INSERT:
      // add by minds at 2005-01-27
      begin
        WriteLogInfo1 (Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort),
                       'TryInsert', StrPas(@RecordData.PrimaryKey));
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));
        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, DB_ERR_DUPLICATE,
          @RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));
      end;
         {
      begin
        RecordData.boUsed := 1;
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TDBRecord) -
          SizeOf(Byte));
        KeyValue := StrPas(@RecordData.PrimaryKey);
        // add by Orber at 2004-11-24 15:11:58
        RecordData.CRCKey := oz_CRC32(@RecordData, SizeOf(RecordData) - 4);

        nCode := DBProvider.Insert(KeyValue, @RecordData);
        if nCode = DB_OK then
        begin
          frmMain.AddLog(format('DB_INSERT %s', [KeyValue]));
        end
        else
        begin
          frmMain.AddLog(format('DB_INSERT failed %s', [KeyValue]));
        end;
        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
          @RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));
      end;
         }
    // add by minds at 2005-01-27
    DB_CREATENEW:
      begin
        RecordData.boUsed := 1;
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TDBRecord) -
          SizeOf(Byte));
        KeyValue := StrPas(@RecordData.PrimaryKey);
        // add by minds at 2005-01-27
        DecodeDate (Date, nYear, nMonth, nDay);
        with RecordData do begin
           StrPCopy (@LastDate, format ('%d-%d-%d', [nYear, nMonth, nDay]));
           StrPCopy (@CreateDate, format ('%d-%d-%d', [nYear, nMonth, nDay]));

           FillChar(WearItemArr[0], sizeof(TDBItemData) * 8, 0);
           FillChar(HaveItemArr[0], sizeof(TDBItemData) * 30, 0);

{$IFDEF _CHINA}
           if StrPas(@Sex) = '男' then begin
             StrPCopy(@WearItemArr[3].Name, '男子道服');
             WearItemArr[3].Count := 1;
             WearItemArr[3].Color := 1;
             StrPCopy(@WearItemArr[4].Name, '男子短裤');
             WearItemArr[4].Count := 1;
             WearItemArr[4].Color := 1;
           end else begin
             StrPCopy(@WearItemArr[3].Name, '女子道服');
             WearItemArr[3].Count := 1;
             WearItemArr[3].Color := 1;
             StrPCopy(@WearItemArr[4].Name, '女子短裤');
             WearItemArr[4].Count := 1;
             WearItemArr[4].Color := 1;
           end;
           StrPCopy (@HaveItemArr [0].Name, '长剑');
           HaveItemArr [0].Count := 1;
           HaveItemArr [0].Color := 1;
           StrPCopy (@HaveItemArr [1].Name, '长刀');
           HaveItemArr [1].Count := 1;
           HaveItemArr [1].Color := 1;
           StrPCopy (@HaveItemArr [2].Name, '长枪');
           HaveItemArr [2].Count := 1;
           HaveItemArr [2].Color := 1;
           StrPCopy (@HaveItemArr [3].Name, '斧头');
           HaveItemArr [3].Count := 1;
           HaveItemArr [3].Color := 1;
           StrPCopy (@HaveItemArr [4].Name, '五色药水');
{$ENDIF}
{$IFDEF _TAIWAN}
           if StrPas(@Sex) = '╧' then begin
             StrPCopy(@WearItemArr[3].Name, '╧笵狝');
             WearItemArr[3].Count := 1;
             WearItemArr[3].Color := 1;
             StrPCopy(@WearItemArr[4].Name, '╧祏壳');
             WearItemArr[4].Count := 1;
             WearItemArr[4].Color := 1;
           end else begin
             StrPCopy(@WearItemArr[3].Name, '笵狝');
             WearItemArr[3].Count := 1;
             WearItemArr[3].Color := 1;
             StrPCopy(@WearItemArr[4].Name, '祏壳');
             WearItemArr[4].Count := 1;
             WearItemArr[4].Color := 1;
           end;
           StrPCopy (@HaveItemArr [0].Name, '糃');
           HaveItemArr [0].Count := 1;
           HaveItemArr [0].Color := 1;
           StrPCopy (@HaveItemArr [1].Name, '');
           HaveItemArr [1].Count := 1;
           HaveItemArr [1].Color := 1;
           StrPCopy (@HaveItemArr [2].Name, '簀');
           HaveItemArr [2].Count := 1;
           HaveItemArr [2].Color := 1;
           StrPCopy (@HaveItemArr [3].Name, '繷');
           HaveItemArr [3].Count := 1;
           HaveItemArr [3].Color := 1;
           StrPCopy (@HaveItemArr [4].Name, 'き︹媚');
{$ENDIF}

           HaveItemArr [4].Count := 1;
           HaveItemArr [4].Color := 1;
           HaveItemArr [4].Durability := 1000;
           HaveItemArr [4].CurDurability := 1000;
           ServerID := 49; // Village.ini SERVERID0
           X := 106;       // Village.ini X0
           Y := 55;        // Village.ini Y0
           CurHeadSeak := 2200;
           CurArmSeak := 2200;
           CurLegSeak := 2200;
           CurHealth := 2200;
           CurSatiety := 2200;
           CurPoisoning := 2200;
           CurEnergy := 600;
           CurInPower := 1100;
           CurOutPower := 1100;
           CurMagic := 600;
           CurLife := 2200;
        end;

        // add by Orber at 2004-11-24 15:11:58
        RecordData.CRCKey := oz_CRC32(@RecordData, SizeOf(RecordData) - 4);

        nCode := DBProvider.Insert(KeyValue, @RecordData);
        if nCode = DB_OK then
        begin
          frmMain.AddLog(format('DB_INSERT %s', [KeyValue]));
        end
        else
        begin
          frmMain.AddLog(format('DB_INSERT failed %s', [KeyValue]));
        end;
        // add by minds at 2005-01-27
//        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
        AddSendData(aPacket^.RequestID, DB_INSERT, nCode,
          @RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));

      end;
    DB_SELECT:
      begin
        Move(aPacket^.Data, RecordData.PrimaryKey,
          SizeOf(RecordData.PrimaryKey));
        KeyValue := StrPas(@RecordData.PrimaryKey);
        nCode := DBProvider.Select(KeyValue, @RecordData);
        // add by Orber at 2004-11-24 15:28:24
        if nCode = DB_OK then
        begin
          if oz_CRC32(@RecordData, SizeOf(RecordData) - 4) <> RecordData.CRCKey
            then
          begin
            nCode := DB_ERR_NOTFOUND;
          end;
        end;
        if nCode = DB_OK then
        begin
          frmMain.AddLog(format('DB_SELECT %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
            @RecordData.PrimaryKey, SizeOf(TDBRecord) - SizeOf(Byte));
        end
        else
        begin
          frmMain.AddLog(format('DB_SELECT failed %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
            @RecordData.PrimaryKey, 0);
        end;
      end;
    DB_UPDATE:
      begin
        RecordData.boUsed := 1;
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TDBRecord) -
          SizeOf(Byte));
        KeyValue := StrPas(@RecordData.PrimaryKey);

        nCode := DBProvider.Update(KeyValue, @RecordData);
        if nCode = DB_OK then
        begin
          mStr := DBProvider.ChangeDataToStr(@RecordData);
          frmMain.AddTodayData(KeyValue, mStr);

          mStr := DBProvider.ChangeDataToWebStr(@RecordData);
          frmMain.AddWebData(KeyValue, mStr);

          frmMain.AddLog(format('DB_UPDATE %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
            @RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));
        end
        else
        begin
          frmMain.AddLog(format('DB_UPDATE failed %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
            @RecordData.PrimaryKey, 0);
        end;
      end;
    DB_LOCK:
      begin
        KeyValue := StrPas(@aPacket^.Data);
        CurrentCharList.Insert(KeyValue, @RecordData);
      end;
    DB_UNLOCK:
      begin
        KeyValue := StrPas(@aPacket^.Data);
        CurrentCharList.Delete(KeyValue);
      end;
    DB_CONNECTTYPE:
      begin
        KeyValue := StrPas(@aPacket^.Data);
        if UpperCase(KeyValue) = 'GATE' then
        begin
          ConnectType := ct_gate;
        end
        else if UpperCase(KeyValue) = 'GAMESERVER' then
        begin
          ConnectType := ct_gameserver;
        end;
      end;
    DB_ITEMSELECT:
      begin
        KeyValue := StrPas(@aPacket^.Data);
//        ItemRemoteConnectorList.AddRequestData(aPacket^.RequestID,
//          aPacket^.RequestMsg, aPacket^.ResultCode, KeyValue);
  // add by Orber at 2005-03-31 16:25:45
        ItemRemoteConnector.AddRequestData(aPacket^.RequestMsg, aPacket^.ResultCode, KeyValue);

      end;
    DB_ITEMUPDATE:
      begin
        //Author:Steven Date: 2004-12-09 17:32:11
        //Note:
        KeyValue := StrPas(@aPacket^.Data);
//        ItemRemoteConnectorList.AddRequestData(aPacket^.RequestID,
//          aPacket^.RequestMsg, aPacket^.ResultCode, KeyValue);

  // add by Orber at 2005-03-31 16:25:38
        ItemRemoteConnector.AddRequestData(aPacket^.RequestMsg, aPacket^.ResultCode, KeyValue);

      end;
    // add by Orber at 2004-11-04 20:17:46
    DB_UPDATE_END:
      begin
        RecordData.boUsed := 1;
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TDBRecord) -
          SizeOf(Byte));
        KeyValue := StrPas(@RecordData.PrimaryKey);
        // add by Orber at 2004-11-24 15:11:58
        RecordData.CRCKey := oz_CRC32(@RecordData, SizeOf(RecordData) - 4);
        nCode := DBProvider.Update(KeyValue, @RecordData);
        if nCode = DB_OK then
        begin
          mStr := DBProvider.ChangeDataToStr(@RecordData);
          frmMain.AddTodayData(KeyValue, mStr);

          mStr := DBProvider.ChangeDataToWebStr(@RecordData);
          frmMain.AddWebData(KeyValue, mStr);

          frmMain.AddLog(format('DB_UPDATE %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
            @RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));
        end
        else
        begin
          frmMain.AddLog(format('DB_UPDATE failed %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode,
            @RecordData.PrimaryKey, 0);
        end;
      end;

  else
    begin
      frmMain.AddLog(format('%d Packet was received', [aPacket^.RequestMsg]));
    end;
  end;
end;

// TConnectorList

constructor TConnectorList.Create;
begin
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
  i: Integer;
  Connector: TConnector;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    Connector.Free;
  end;
  DataList.Clear;
end;

function TConnectorList.GetCount: Integer;
begin
  Result := DataList.Count;
end;

function TConnectorList.CreateConnect(aSocket: TCustomWinSocket): Boolean;
var
  Connector: TConnector;
begin
  Result := true;

  try
    Connector := TConnector.Create(aSocket);
    DataList.Add(Connector);
  except
    frmMain.AddEvent('TConnectorList.CreateConnect failed (' +
      aSocket.RemoteAddress + ')');
    Result := false;
  end;
end;

function TConnectorList.DeleteConnect(aSocket: TCustomWinSocket): Boolean;
var
  i: Integer;
  Connector: TConnector;
begin
  Result := true;

  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    if Connector.Socket = aSocket then
    begin
      DataList.Delete(i);
      exit;
    end;
  end;

  frmMain.AddEvent('TConnectorList.DeleteConnect failed (' +
    aSocket.RemoteAddress + ')');
  Result := false;
end;

procedure TConnectorList.AddReceiveData(aSocket: TCustomWinSocket; aData: PChar;
  aCount: Integer);
var
  i: Integer;
  Connector: TConnector;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    if Connector.Socket = aSocket then
    begin
      Connector.AddReceiveData(aData, aCount);
      exit;
    end;
  end;

  frmMain.AddEvent('TConnectorList.AddReceiveData failed (' +
    aSocket.RemoteAddress + ')');
end;

procedure TConnectorList.Update(CurTick: Integer);
var
  i: Integer;
  Connector: TConnector;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    Connector.Update(CurTick);
  end;
end;

procedure TConnectorList.SetWriteAllow(aSocket: TCustomWinSocket);
var
  i: Integer;
  Connector: TConnector;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    if Connector.Socket = aSocket then
    begin
      Connector.SetWriteAllow(true);
      exit;
    end;
  end;
end;

function TConnectorList.AddPacketToGameServer(aID: Integer; aMsg, aRetCode:
  Byte; aData: PChar; aSize: Integer): Boolean;
var
  i: Integer;
  Connector: TConnector;
begin
  Result := false;
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    if Connector.ConnectType = ct_gameserver then
    begin
      Connector.AddSendData(aID, aMsg, aRetCode, aData, aSize);
      Result := true;
      exit;
    end;
  end;
end;

end.

