unit FGate;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, ComCtrls, uPackets, AUtil32, BSCommon,
    BasicObj, DefType,  ScktComp   ;

type
    TfrmGate = class(TForm)
        sckGateAccept: TServerSocket;
        PageControl1: TPageControl;
        tsGate1: TTabSheet;
        GroupBox1: TGroupBox;
        Label4: TLabel;
        lblSendByte1: TLabel;
        Label6: TLabel;
        lblRecvByte1: TLabel;
        Label8: TLabel;
        lblWBCount1: TLabel;
        shpWBSign1: TShape;
        Label10: TLabel;
        GroupBox2: TGroupBox;
        Label1: TLabel;
        lblSendByte3: TLabel;
        Label3: TLabel;
        lblRecvByte3: TLabel;
        Label12: TLabel;
        lblWBCount3: TLabel;
        shpWBSign3: TShape;
        Label14: TLabel;
        GroupBox3: TGroupBox;
        Label15: TLabel;
        lblSendByte2: TLabel;
        Label17: TLabel;
        lblRecvByte2: TLabel;
        Label19: TLabel;
        lblWBCount2: TLabel;
        shpWBSign2: TShape;
        Label21: TLabel;
        GroupBox4: TGroupBox;
        Label22: TLabel;
        lblSendByte4: TLabel;
        Label24: TLabel;
        lblRecvByte4: TLabel;
        Label26: TLabel;
        lblWBCount4: TLabel;
        shpWBSign4: TShape;
        Label28: TLabel;
        timerDisplay: TTimer;
        sckDBConnect: TClientSocket;
        timerProcess: TTimer;
        Label2: TLabel;
        Label5: TLabel;
        Shape1: TShape;
        Label7: TLabel;
        Label9: TLabel;
        GroupBox5: TGroupBox;
        Label11: TLabel;
        lblDBSendBytes: TLabel;
        Label16: TLabel;
        lblDBReceiveBytes: TLabel;
        Label20: TLabel;
        lblDBWBCount: TLabel;
        shpDBWBSign: TShape;
        Label25: TLabel;
        TabSheet1: TTabSheet;
        Label13: TLabel;
        lblNameKeyCount: TLabel;
        Label18: TLabel;
        lblUniqueKeyCount: TLabel;
        Label27: TLabel;
        lblSaveListCount: TLabel;
        Label23: TLabel;
        lblConnectListCount: TLabel;
        sckBattleConnect: TClientSocket;
        GroupBox6: TGroupBox;
        Label29: TLabel;
        lblBattleSendBytes: TLabel;
        Label31: TLabel;
        lblBattleReceiveBytes: TLabel;
        Label33: TLabel;
        lblBattleWBCount: TLabel;
        shpBattleWBSign: TShape;
        Label35: TLabel;
        txtLog: TMemo;
        procedure sckGateAcceptAccept(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckGateAcceptClientConnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckGateAcceptClientDisconnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckGateAcceptClientError(Sender: TObject;
            Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
            var ErrorCode: Integer);
        procedure sckGateAcceptClientRead(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckGateAcceptClientWrite(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure timerDisplayTimer(Sender: TObject);
        procedure sckDBConnectConnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckDBConnectDisconnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckDBConnectError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; var ErrorCode: Integer);
        procedure sckDBConnectRead(Sender: TObject; Socket: TCustomWinSocket);
        procedure sckDBConnectWrite(Sender: TObject; Socket: TCustomWinSocket);
        procedure timerProcessTimer(Sender: TObject);
        procedure sckBattleConnectConnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckBattleConnectDisconnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckBattleConnectError(Sender: TObject;
            Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
            var ErrorCode: Integer);
        procedure sckBattleConnectRead(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckBattleConnectWrite(Sender: TObject;
            Socket: TCustomWinSocket);
    private
        { Private declarations }
        procedure DBMessageProcess(aPacket: PTPacketData);
        procedure BattleMessageProcess(aPacket: PTPacketData);
    public
        { Public declarations }
       procedure WriteLogInfo(aStr: string);
        procedure AddLog(aStr: string);
        function AddSendDBServerData(aMsg: Byte; aData: PChar; aCount: Integer): Boolean;
        procedure dbsend();
        function AddSendBattleData(aID: Integer; aMsg: Byte; aRetCode: Byte; aData: PChar; aCount: Integer): Boolean;
    end;

var
    frmGate: TfrmGate;

    DBServerIPAddress: string;
    DBServerPort: Integer;
    BattleServerIPAddress: string;
    BattleServerPort: Integer;

    DBSender: TPacketSender = nil;
    BattleSender: TPacketSender = nil;
    DBReceiver: TPacketReceiver = nil;
    BattleReceiver: TPacketReceiver = nil;

    ServerGateProt: integer = 3052;
implementation

uses
    SVMain, uGConnect, uConnect, uItemLog, uEmail, uAuction, UTelemanagement, UUser;

{$R *.DFM}
procedure TFrmgate.WriteLogInfo(aStr: string);
var
    Stream: TFileStream;
    tmpFileName: string;
    szBuf: array[0..1024] of Byte;
begin
    try
        StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
        tmpFileName := 'attackip.LOG';
        if FileExists(tmpFileName) then
            Stream := TFileStream.Create(tmpFileName, fmOpenReadWrite)
        else
            Stream := TFileStream.Create(tmpFileName, fmCreate);

        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(szBuf, StrLen(@szBuf));
        Stream.Destroy;
    except
    end;
end;
procedure TfrmGate.AddLog(aStr: string);
begin
   try
    if txtLog.Lines.Count >= 30 then
    begin
        txtLog.Lines.Delete(0);
    end;
    txtLog.Lines.Add(aStr);
   except
     end;
end;

procedure TfrmGate.sckGateAcceptAccept(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    GateConnectorList.CreateConnect(Socket);
    AddLog(format('Gate Server Accepted %s', [Socket.RemoteAddress]));
end;

procedure TfrmGate.sckGateAcceptClientConnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
     if Socket.RemoteAddress<>'127.0.0.1' then     writeLoginfo(format('攻击IP %s', [Socket.RemoteAddress]));
   if Socket.RemoteAddress<>'127.0.0.1' then Socket.Close;    //20130731修改，最大的刷装备漏洞
   //该漏洞利用如下：本机开除了tgs之外的其他工具，用db后台修改用户数据，过一会就保存上了

end;

procedure TfrmGate.sckGateAcceptClientDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if Socket.Connected = true then
    begin
        GateConnectorList.DeleteConnect(Socket);
        AddLog(format('Gate Server Disconnected %s', [Socket.RemoteAddress]));
    end;
end;

procedure TfrmGate.sckGateAcceptClientError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
begin
    AddLog(format('Gate Accept Socket Error (%d, %s)', [ErrorCode, Socket.RemoteAddress]));
    ErrorCode := 0;
end;

procedure TfrmGate.sckGateAcceptClientRead(Sender: TObject;
    Socket: TCustomWinSocket);
var
    nRead, nTotalBytes: Integer;
    buffer: array[0..65535 - 1] of byte;
begin
    nTotalBytes := Socket.ReceiveLength;

    // while nTotalBytes > 0 do begin
    nRead := nTotalBytes;
    if nRead > 65535 then nRead := 65535;
    nRead := Socket.ReceiveBuf(buffer, nRead);
    if nRead > 0 then
    begin
        nTotalBytes := nTotalBytes - nRead;
        GateConnectorList.AddReceiveData(Socket, @buffer, nRead);
        // end else begin
        //    break;
    end;
    // end;
end;

procedure TfrmGate.sckGateAcceptClientWrite(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    GateConnectorList.SetWriteAllow(Socket);
end;

procedure TfrmGate.FormCreate(Sender: TObject);
begin
    DBSender := nil;
    DBReceiver := nil;

    BattleSender := nil;
    BattleReceiver := nil;

    GateList.SetBSGateActive(false);

    sckDBConnect.Address := DBServerIPAddress;
    sckDBConnect.Port := DBServerPort;
    sckDBConnect.Active := true;

    sckBattleConnect.Address := BattleServerIPAddress;
    sckBattleConnect.Port := BattleServerPort;
    sckBattleConnect.Active := true;

    sckGateAccept.Port := ServerGateProt;
    sckGateAccept.Active := true;

    timerDisplay.Interval := 1000;
    timerDisplay.Enabled := true;

    timerProcess.Interval := 10;
    timerProcess.Enabled := true;
end;

procedure TfrmGate.FormDestroy(Sender: TObject);
begin
    timerDisplay.Enabled := false;
    timerProcess.Enabled := false;

    if DBSender <> nil then
    begin
        DBSender.Free;
        DBSender := nil;
    end;
    if DBReceiver <> nil then
    begin
        DBReceiver.Free;
        DBReceiver := nil;
    end;

    if BattleSender <> nil then
    begin
        BattleSender.Free;
        BattleSender := nil;
    end;
    if BattleReceiver <> nil then
    begin
        BattleReceiver.Free;
        BattleReceiver := nil;
    end;

    if sckGateAccept.Active = true then
    begin
        sckGateAccept.Socket.Close;
    end;
    if sckGateAccept.Active = true then
    begin
        sckDBConnect.Socket.Close;
    end;
end;

procedure TfrmGate.timerDisplayTimer(Sender: TObject);
var
    i: Integer;
    GateConnector: TGateConnector;
begin
    if sckDBConnect.Active = false then
    begin
        FrmMain.shpDbConnected.Brush.Color := clRed;
        sckDBConnect.Socket.Close;
        sckDBConnect.Active := true;
    end else
    begin             
        FrmMain.shpDbConnected.Brush.Color := clLime;
    end;

    { if sckBattleConnect.Active = false then
     begin
         sckBattleConnect.Socket.Close;
         sckBattleConnect.Active := true;
     end else
     begin
     end;
     }
     // Gate 1-1
    if GateConnectorList.Count > 0 then
    begin
        GateConnector := GateConnectorList.Items[0];
        with GateConnector do
        begin
            lblSendByte1.Caption := IntToStr(SendBytesPerSec) + 'K';
            lblRecvByte1.Caption := IntToStr(ReceiveBytesPerSec) + 'K';
            lblWBCount1.Caption := IntToStr(WBCount);

            if WriteAllow = true then
            begin
                shpWBSign1.Brush.Color := clLime;
            end else
            begin
                shpWBSign1.Brush.Color := clRed;
            end;
        end;
    end;
    // Gate 1-2
    if GateConnectorList.Count > 1 then
    begin
        GateConnector := GateConnectorList.Items[1];
        with GateConnector do
        begin
            lblSendByte2.Caption := IntToStr(SendBytesPerSec) + 'K';
            lblRecvByte2.Caption := IntToStr(ReceiveBytesPerSec) + 'K';
            lblWBCount2.Caption := IntToStr(WBCount);

            if WriteAllow = true then
            begin
                shpWBSign2.Brush.Color := clLime;
            end else
            begin
                shpWBSign2.Brush.Color := clRed;
            end;
        end;
    end;
    // Gate 1-3
    if GateConnectorList.Count > 2 then
    begin
        GateConnector := GateConnectorList.Items[2];
        with GateConnector do
        begin
            lblSendByte3.Caption := IntToStr(SendBytesPerSec) + 'K';
            lblRecvByte3.Caption := IntToStr(ReceiveBytesPerSec) + 'K';
            lblWBCount3.Caption := IntToStr(WBCount);

            if WriteAllow = true then
            begin
                shpWBSign3.Brush.Color := clLime;
            end else
            begin
                shpWBSign3.Brush.Color := clRed;
            end;
        end;
    end;
    // Gate 1-4
    if GateConnectorList.Count > 3 then
    begin
        GateConnector := GateConnectorList.Items[3];
        with GateConnector do
        begin
            lblSendByte4.Caption := IntToStr(SendBytesPerSec) + 'K';
            lblRecvByte4.Caption := IntToStr(ReceiveBytesPerSec) + 'K';
            lblWBCount4.Caption := IntToStr(WBCount);

            if WriteAllow = true then
            begin
                shpWBSign4.Brush.Color := clLime;
            end else
            begin
                shpWBSign4.Brush.Color := clRed;
            end;
        end;
    end;
    // DB Connection
    if (DBSender <> nil) and (DBReceiver <> nil) then
    begin
        lblDBSendBytes.Caption := IntToStr(DBSender.SendBytesPerSec) + 'K';
        lblDBReceiveBytes.Caption := IntToStr(DBReceiver.ReceiveBytesPerSec) + 'K';
        lblDBWBCount.Caption := IntToStr(DBSender.WouldBlockCount);

        if DBSender.WriteAllow = true then
        begin
            shpDBWBSign.Brush.Color := clLime;
        end else
        begin
            shpDBWBSign.Brush.Color := clRed;
        end;
    end;

    lblSaveListCount.Caption := IntToStr(ConnectorList.GetSaveListCount);

    lblConnectListCount.Caption := IntToStr(ConnectorList.Count);
    lblNameKeyCount.Caption := IntToStr(ConnectorList.NameKeyCount);
    lblUniqueKeyCount.Caption := IntToStr(ConnectorList.UniqueKeyCount);
end;

procedure TfrmGate.sckDBConnectConnect(Sender: TObject;
    Socket: TCustomWinSocket);
var
    buffer: array[0..20 - 1] of char;
begin
    if DBSender <> nil then
    begin
        DBSender.Free;
        DBSender := nil;
    end;
    if DBReceiver <> nil then
    begin
        DBReceiver.Free;
        DBReceiver := nil;
    end;
    DBSender := TPacketSender.Create('DB_SENDER', BufferSize_DB_SEND, Socket);
    DBReceiver := TPacketReceiver.Create('DB_RECEIVER', BufferSize_DB_RECE);

    FillChar(buffer, SizeOf(buffer), 0);
    StrPCopy(@buffer, 'GAMESERVER');
    DBSender.PutPacket(0, DB_CONNECTTYPE, 0, @buffer, SizeOf(buffer));
end;

procedure TfrmGate.sckDBConnectDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if DBSender <> nil then
    begin
        DBSender.Free;
        DBSender := nil;
    end;
    if DBReceiver <> nil then
    begin
        DBReceiver.Free;
        DBReceiver := nil;
    end;
end;

procedure TfrmGate.sckDBConnectError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
begin
    if (ErrorCode <> 10061) and (ErrorCode <> 10038) then
    begin
        AddLog(format('DBConnect Socket Error (%d)', [ErrorCode]));
    end;
    ErrorCode := 0;
end;

procedure TfrmGate.sckDBConnectRead(Sender: TObject;
    Socket: TCustomWinSocket);
var
    nTotalSize, nReadSize, nRead: Integer;
    buffer: array[0..65535 - 1] of Byte;
begin
    nTotalSize := Socket.ReceiveLength;
    while nTotalSize > 0 do
    begin
        nReadSize := nTotalSize;
        if nReadSize > 65535 then nReadSize := 65535;
        nRead := Socket.ReceiveBuf(buffer, nReadSize);
        if nRead < 0 then break;
        if DBReceiver <> nil then DBReceiver.PutData(@buffer, nRead);
        nTotalSize := nTotalSize - nRead;
    end;
end;

procedure TfrmGate.sckDBConnectWrite(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if DBSender <> nil then DBSender.WriteAllow := true;
end;
//发送 DB。EXE

function TfrmGate.AddSendDBServerData(aMsg: Byte; aData: PChar; aCount: Integer): Boolean;
begin
    Result := false;
    if (aCount >= 0) and (aCount < SizeOf(TPacketData)) then
    begin
        if DBSender <> nil then
        begin
            Result := DBSender.PutPacket(0, aMsg, 0, aData, aCount);
        end;
    end;
end;

procedure TfrmGate.dbsend();
begin
    if DBSender <> nil then DBSender.Update;
end;

procedure TfrmGate.DBMessageProcess(aPacket: PTPacketData);
var
    i, akey: Integer;
    Str, Str2: string;
    user: TUser;
begin
    case aPacket^.RequestMsg of
        DB_UPDATE:
            begin
                i := 0;
                Str := WordComData_GETString(aPacket.data, i);
                if aPacket^.ResultCode = DB_OK then
                begin
                    AddLog(format('用户 %s 保存资料成功。', [Str]));
                end else
                begin
                    AddLog(format('用户 %s 保存资料失败。', [Str]));
                end;
            end;
        DB_INSERT:       //2016.03.19 在水一方 >>>>>>
            begin
                i := 0;
                Str := WordComData_GETString(aPacket.data, i);
                Str2 := UserList.GetChangeName(Str);
                user := UserList.GetUserPointer(Str2);
                if user <> nil then
                  user.ChangeCharNameEnd(aPacket^.ResultCode, Str);
                if aPacket^.ResultCode = DB_OK then
                begin
                    AddLog(format('用户 %s 改名 %s 成功。', [Str, Str2]));
                end else
                begin
                    AddLog(format('用户 %s 改名 %s 失败。', [Str, Str2]));
                end;
            end;       //2016.03.19 在水一方 <<<<<<
        DB_Email:
            begin
//                EmailList.DBMessageProcess(aPacket.data);
            end;
        DB_Auction:
            begin
              //  AuctionSystemClass.DBMessageProcess(aPacket.data);
            end;

    end;
end;

function TfrmGate.AddSendBattleData(aID: Integer; aMsg: Byte; aRetCode: Byte; aData: PChar; aCount: Integer): Boolean;
begin
    if BattleSender <> nil then
    begin
        Result := BattleSender.PutPacket(aID, aMsg, aRetCode, aData, aCount);
    end;
end;

procedure TfrmGate.BattleMessageProcess(aPacket: PTPacketData);
begin
    case aPacket^.RequestMsg of
        BG_USERCLOSE:
            begin
                ConnectorList.ReStartChar(aPacket^.RequestID);
            end;
        BG_GAMEDATA:
            begin
//                ConnectorList.AddSendData(aPacket);
            end;
    end;
end;

procedure TfrmGate.timerProcessTimer(Sender: TObject);
var
    Packet: TPacketData;
begin
    //DB
    if DBSender <> nil then DBSender.Update;
    if DBReceiver <> nil then
    begin
        DBReceiver.Update;                                                      //分包 解包
        while DBReceiver.Count > 0 do
        begin
            //提出 一个包
            if DBReceiver.GetPacket(@Packet) = false then break;
            DBMessageProcess(@Packet);
        end;
    end;

    if BattleSender <> nil then BattleSender.Update;
    if BattleReceiver <> nil then
    begin
        BattleReceiver.Update;
        while BattleReceiver.Count > 0 do
        begin
            if BattleReceiver.GetPacket(@Packet) = false then break;
            BattleMessageProcess(@Packet);
        end;
    end;
end;

procedure TfrmGate.sckBattleConnectConnect(Sender: TObject;
    Socket: TCustomWinSocket);
var
    buffer: array[0..20 - 1] of char;
begin
    if BattleSender <> nil then
    begin
        BattleSender.Free;
        BattleSender := nil;
    end;
    if BattleReceiver <> nil then
    begin
        BattleReceiver.Free;
        BattleReceiver := nil;
    end;
    BattleSender := TPacketSender.Create('Battle_SENDER', 65535, Socket);
    BattleReceiver := TPacketReceiver.Create('Battle_RECEIVER', 65535);

    GateList.SetBSGateActive(true);
end;

procedure TfrmGate.sckBattleConnectDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if BattleSender <> nil then
    begin
        BattleSender.Free;
        BattleSender := nil;
    end;
    if BattleReceiver <> nil then
    begin
        BattleReceiver.Free;
        BattleReceiver := nil;
    end;

    GateList.SetBSGateActive(false);
end;

procedure TfrmGate.sckBattleConnectError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
begin
    if (ErrorCode <> 10061) and (ErrorCode <> 10038) then
    begin
        AddLog(format('BattleConnect Socket Error (%d)', [ErrorCode]));
    end;
    ErrorCode := 0;
end;

procedure TfrmGate.sckBattleConnectRead(Sender: TObject;
    Socket: TCustomWinSocket);
var
    nRead: Integer;
    buffer: array[0..deftype_MAX_PACK_SIZE - 1] of Byte;
begin
    nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
    if nRead > 0 then
    begin
        if BattleReceiver <> nil then BattleReceiver.PutData(@buffer, nRead);
    end;
end;

procedure TfrmGate.sckBattleConnectWrite(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if BattleSender <> nil then BattleSender.WriteAllow := true;
end;

end.

