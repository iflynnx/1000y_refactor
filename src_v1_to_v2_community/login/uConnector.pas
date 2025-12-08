{
1插入记录
2查找记录
3更新保存
无其他功能
}
unit uConnector;

interface

uses
  Windows, Classes, SysUtils, uBuffer, uPackets, DefType, ScktComp, MyAccess, Dialogs;

type
  TConnectType = (ct_gate, ct_gameserver);

  TConnector = class
  private
    Socket: TCustomWinSocket;
    boWriteAllow: Boolean;

    ConnectType: TConnectType;

    GateSender: TPacketSender;
    GateReceiver: TPacketReceiver;

    procedure WriteLog(aStr: string);
  protected

  public
    constructor Create(aSocket: TCustomWinSocket);
    destructor Destroy; override;

    procedure Update();
    procedure MessageProcess(aPacket: PTPacketData); //所有事情 在这里处理

    procedure AddReceiveData(aData: PChar; aCount: Integer);
    procedure AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer);

    procedure SetWriteAllow(boFlag: Boolean);
    procedure send();
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

    procedure Update();

    procedure AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer);

    procedure SetWriteAllow(aSocket: TCustomWinSocket);

    function AddPacketToGameServer(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer): Boolean;

    property Count: Integer read GetCount;
  end;

var
  ConnectorList: TConnectorList;

implementation

uses
  FMain, uSQLDBAdapter, uEmaildata;

// TConnector

constructor TConnector.Create(aSocket: TCustomWinSocket);
begin
  Socket := aSocket;
  boWriteAllow := false;

  ConnectType := ct_gate;

  GateSender := TPacketSender.Create('Gate', BufferSizeS2S, aSocket);
  GateReceiver := TPacketReceiver.Create('Gate', BufferSizeS2S);
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
    frmMain.AddEvent(format('DataReceived (%d bytes %s)', [aCount, Socket.RemoteAddress]));
  end;
end;

procedure TConnector.AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer);
begin
  if aSize < SizeOf(TPacketData) then
  begin
    GateSender.PutPacket(aID, aMsg, aRetCode, aData, aSize);
    frmMain.AddEvent(format('DataSend (%d bytes %s)', [aSize, Socket.RemoteAddress]));
  end;
end;

procedure TConnector.Update();
var
  Packet: TPacketData;
begin
  GateReceiver.Update;
  while GateReceiver.Count > 0 do
  begin
    if GateReceiver.GetPacket(@Packet) = false then break;
    MessageProcess(@Packet);
  end;

  GateSender.Update;
end;

procedure TConnector.send();
begin
  GateSender.Update;

end;



procedure TConnector.WriteLog(aStr: string);
var
  Stream: TFileStream;
  FileName: string;
begin
  try
    FileName := '.\Log\' + 'TConnector.Log';
    if FileExists(FileName) then
    begin
      Stream := TFileStream.Create(FileName, fmOpenReadWrite);
    end else
    begin
      Stream := TFileStream.Create(FileName, fmCreate);
    end;
    aStr := '[' + datetimetostr(now()) + ']' + aStr + #13 + #10;
    Stream.Seek(0, soFromEnd);
    Stream.WriteBuffer(aStr[1], length(aStr));
    Stream.Free;
  except
  end;
end;

procedure TConnector.MessageProcess(aPacket: PTPacketData);
var
    //  Packet          :TPacketData;
  RecordData: TLGRecord;
  KeyValue: string;
  nCode: Byte;
begin
  case aPacket^.RequestMsg of
    DB_LG_INSERT:
      begin
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TLGRecord));
        KeyValue := RecordData.PrimaryKey;

        if (Pos(';', KeyValue) > 0) or (Pos('''', KeyValue) > 0) then
        begin
          nCode := DB_ERR_INVALIDDATA;
          frmMain.AddLog(format('LG_INSERT 失败 有特殊字符 %s', [KeyValue]));
        end else
        begin
          nCode := SQLDBAdapter.New_LG_Insert(KeyValue, @RecordData);
          //nCode := LoginDBAdapter.Insert(KeyValue, @RecordData);
          if nCode = DB_OK then
          begin
            frmMain.AddLog(format('LG_INSERT 成功 %s', [KeyValue]));
          end else
          begin
            frmMain.AddLog(format('LG_INSERT 失败 %s', [KeyValue]));
          end;
        end;
                //只发送 状态
        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
      end;
    DB_LG_SELECT:
      begin
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));
        KeyValue := RecordData.PrimaryKey;

        if (Pos(';', KeyValue) > 0) or (Pos('''', KeyValue) > 0) then
        begin
          nCode := DB_ERR_INVALIDDATA;
          frmMain.AddLog(format('LG_SELECT 失败 有特殊字符 %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
        end else
        begin
          nCode := SQLDBAdapter.New_LG_Select(KeyValue, @RecordData);
                    // nCode := LoginDBAdapter.Select(KeyValue, @RecordData);
          if nCode = DB_OK then
          begin
            frmMain.AddLog(format('LG_SELECT 成功 %s', [KeyValue]));
                        //成功 发送完整数据
            AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, SizeOf(TLGRecord));
          end else
          begin
            frmMain.AddLog(format('LG_SELECT 失败 %s', [KeyValue]));
            AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
          end;
        end;
      end;
    DB_LG_SELECTCHAR:
      begin
        Move(aPacket^.Data, RecordData, SizeOf(TLGRecord));
        KeyValue := RecordData.PrimaryKey;
        nCode := SQLDBAdapter.New_LG_UpdateChar(KeyValue, @RecordData);
      end;
    DB_LG_DELETE:
      begin

      end;
    DB_LG_UPDATE:
      begin
        Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TLGRecord));
        KeyValue := RecordData.PrimaryKey;

        if (Pos(';', KeyValue) > 0) or (Pos('''', KeyValue) > 0) then
        begin
          nCode := DB_ERR_INVALIDDATA;
          frmMain.AddLog(format('LG_UPDATE 失败 有特殊字符 %s', [KeyValue]));
          AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
        end else
        begin
          nCode := SQLDBAdapter.New_LG_Update(KeyValue, @RecordData);
          if nCode = DB_OK then
          begin
            frmMain.AddLog(format('LG_UPDATE 成功 %s', [KeyValue]));
                        //更新 成功 也发完整数据
            AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, SizeOf(TLGRecord));
          end else
          begin
            frmMain.AddLog(format('LG_UPDATE 失败 %s', [KeyValue]));
            AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
          end;
        end;
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
    frmMain.AddEvent('TConnectorList.CreateConnect failed (' + aSocket.RemoteAddress + ')');
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
      Connector.Free;
      exit;
    end;
  end;

  frmMain.AddEvent('TConnectorList.DeleteConnect failed (' + aSocket.RemoteAddress + ')');
  Result := false;
end;

procedure TConnectorList.AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer);
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

  frmMain.AddEvent('TConnectorList.AddReceiveData failed (' + aSocket.RemoteAddress + ')');
end;

procedure TConnectorList.Update();
var
  i: Integer;
  Connector: TConnector;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    Connector.Update();
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

function TConnectorList.AddPacketToGameServer(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer): Boolean;
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

