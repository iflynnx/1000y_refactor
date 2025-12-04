unit uServerConnect;

interface

uses
    Windows, Classes, SysUtils, ScktComp, uBuffer, uPackets, DefType;

type
    TServerConnector = class
    private
        Socket:TCustomWinSocket;

        GateSender:TPacketSender;
        GateReceiver:TPacketReceiver;
    public
        constructor Create(aSocket:TCustomWinSocket);
        destructor Destroy; override;

        procedure Update(CurTick:Integer);

        procedure MessageProcess(aPacket:PTPacketData);

        procedure AddReceiveData(aData:PChar; aCount:Integer);
        procedure AddSendData(aID:Integer; aMsg, aRetCode:Byte; aData:PChar; aSize:Integer);

        procedure SetWriteAllow(boFlag:Boolean);
    end;

    TServerConnectorList = class
    private
        DataList:TList;

        function GetCount:Integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure Update(CurTick:Integer);

        function CreateConnect(aSocket:TCustomWinSocket):Boolean;
        function DeleteConnect(aSocket:TCustomWinSocket):Boolean;

        procedure AddReceiveData(aSocket:TCustomWinSocket; aData:PChar; aCount:Integer);

        procedure SetWriteAllow(aSocket:TCustomWinSocket);

        property Count:Integer read GetCount;
    end;

var
    ServerConnectorList:TServerConnectorList;

implementation

uses
    FSockets;

// TConnector

constructor TServerConnector.Create(aSocket:TCustomWinSocket);
begin
    Socket := aSocket;

    GateSender := TPacketSender.Create('Gate', 1048576, aSocket);
    GateReceiver := TPacketReceiver.Create('Gate', 1048576);
end;

destructor TServerConnector.Destroy;
begin
    GateSender.Free;
    GateReceiver.Free;

    inherited Destroy;
end;

procedure TServerConnector.SetWriteAllow(boFlag:Boolean);
begin
    GateSender.WriteAllow := boFlag;
end;

procedure TServerConnector.AddReceiveData(aData:PChar; aCount:Integer);
begin
    if aCount > 0 then
    begin
        GateReceiver.PutData(aData, aCount);
        //frmMain.AddStatus(format('DataReceived (%d bytes %s)', [aCount, Socket.RemoteAddress]));
    end;
end;

procedure TServerConnector.AddSendData(aID:Integer; aMsg, aRetCode:Byte; aData:PChar; aSize:Integer);
begin
    if aSize < SizeOf(TPacketData) then
    begin
        GateSender.PutPacket(aID, aMsg, aRetCode, aData, aSize);
        //frmMain.AddStatus(format('DataSend (%d bytes %s)', [aSize, Socket.RemoteAddress]));
    end;
end;

procedure TServerConnector.Update(CurTick:Integer);
var
    i               :Integer;
    Packet          :TPacketData;
    nSend, nSize    :Integer;
begin
    GateReceiver.Update;
    while GateReceiver.Count > 0 do
    begin
        if GateReceiver.GetPacket(@Packet) = false then break;
        MessageProcess(@Packet);
    end;
    GateSender.Update;
end;

procedure TServerConnector.MessageProcess(aPacket:PTPacketData);
var
    Packet          :TPacketData;
    KeyValue        :string;
    nCode           :Byte;
begin
    case aPacket^.RequestMsg of
        LG_INSERT:
            begin

                // AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
            end;

    else
        begin
            //frmMain.AddLog(format('%d Packet was received', [aPacket^.RequestMsg]));
        end;
    end;
end;

// TConnectorList

constructor TServerConnectorList.Create;
begin
    DataList := TList.Create;
end;

destructor TServerConnectorList.Destroy;
begin
    Clear;
    DataList.Free;
    inherited Destroy;
end;

procedure TServerConnectorList.Clear;
var
    i               :Integer;
    Connector       :TServerConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        Connector.Free;
    end;
    DataList.Clear;
end;

function TServerConnectorList.GetCount:Integer;
begin
    Result := DataList.Count;
end;

function TServerConnectorList.CreateConnect(aSocket:TCustomWinSocket):Boolean;
var
    Connector       :TServerConnector;
begin
    Result := false;

    Connector := TServerConnector.Create(aSocket);
    DataList.Add(Connector);

    Result := true;
end;

function TServerConnectorList.DeleteConnect(aSocket:TCustomWinSocket):Boolean;
var
    i               :Integer;
    Connector       :TServerConnector;
begin
    Result := false;
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        if Connector.Socket = aSocket then
        begin
            Connector.Free;
            DataList.Delete(i);
            Result := true;
            exit;
        end;
    end;
end;

procedure TServerConnectorList.AddReceiveData(aSocket:TCustomWinSocket; aData:PChar; aCount:Integer);
var
    i               :Integer;
    Connector       :TServerConnector;
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

    //frmMain.AddLog('TConnectorList.AddReceiveData failed (' + aSocket.LocalAddress + ')');
end;

procedure TServerConnectorList.Update(CurTick:Integer);
var
    i               :Integer;
    Connector       :TServerConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        Connector.Update(CurTick);
    end;
end;

procedure TServerConnectorList.SetWriteAllow(aSocket:TCustomWinSocket);
var
    i               :Integer;
    Connector       :TServerConnector;
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

end.

