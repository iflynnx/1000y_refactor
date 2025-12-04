unit uPaidConnector;
//TGS
interface

uses
    Windows, Classes, SysUtils, ScktComp, uBuffer, uPackets, uAnsTick, DefType
    , uKeyClass;

type
    TuserList = class
    private
        FdecPaid_tcik, Fsave_tcik: integer;
        findexUsername: TStringKeyClass;
        Fpaid: TPaidData;
        fdata: tlist;                                                           //PTNoticeData
    public
        fname: string;
        constructor Create(aname: string; apaid: pTPaidData; akeyuser: TStringKeyClass);
        destructor Destroy; override;
        procedure Clear();
        procedure add(temp: PTNoticeData);
        procedure del(aCharName: string);
        function getname(aCharName: string): PTNoticeData;
        function getmenu: string;
        procedure savePaid;
        procedure paid_dec;                                                     //扣 点卡
        procedure Update(CurTick: Integer);
    end;

    TPaidUserList = class
    private

        FdecPaid_tcik: integer;
        fdata: tlist;                                                           //TuserList
        findexname: TStringKeyClass;
        findexUsername: TStringKeyClass;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Clear();
        function add_TNoticeData(temp: PTNoticeData): boolean;
        procedure del_TNoticeData(aLoginID, aCharName: string);

        function add(aname: string): boolean;
        procedure del(aLoginID: string);

        function get(aLoginID: string): TuserList;
        function getname(aLoginID, aCharName: string): PTNoticeData;
        function getUsername(aCharName: string): PTNoticeData;

        function getmenu: string;
        function getmenuLoginId(aname: string): string;
        procedure Update(CurTick: Integer);
    end;

    TPaidConnector = class
    private
        Fd_tcik: integer;
        Socket: TCustomWinSocket;

        GateSender: TPacketSender;
        GateReceiver: TPacketReceiver;
        fdata: TPaidUserList;
    public
        constructor Create(aSocket: TCustomWinSocket);
        destructor Destroy; override;

        procedure Update(CurTick: Integer);

        function MessageProcess(aPacket: pTPacketData): Boolean;

        procedure AddReceiveData(aData: PChar; aCount: Integer);
        procedure AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer);

        procedure SetWriteAllow(boFlag: Boolean);
        procedure sendUESTCLOSE(temp: PTNoticeData);                            //踢人下线
        procedure sendUESTALLUSER();                                            //获取 所有人列表
        procedure loginidCLOSE(aLoginID: string);
        procedure loginidCLOSEUser(ausername: string);
        procedure online_close();                                               //定时间 被动检查

    end;

    TPaidConnectorList = class
    private
        DataList: TList;

        function GetCount: Integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure Update(CurTick: Integer);

        function CreateConnect(aSocket: TCustomWinSocket): Boolean;
        function DeleteConnect(aSocket: TCustomWinSocket): Boolean;

        procedure AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer);

        procedure SetWriteAllow(aSocket: TCustomWinSocket);

        property Count: Integer read GetCount;
        function getmenu: string;

        procedure loginidCLOSE(aLoginID: string);
        procedure loginidCLOSEUser(ausername: string);
        function getPaidLoginid(aname: string): TuserList;
        function getPaidUsername(aname: string): PTNoticeData;

    end;

var
    PaidConnectorList: TPaidConnectorList;
function TNoticeDataTostr(atemp: PTNoticeData): string;
implementation

uses
    FMain,  DateUtils,  uDBAdapter;

function TNoticeDataTostr(atemp: PTNoticeData): string;
begin
    result := format(
        '帐号%s 角色%s IP %s',
        [atemp.rLoginID
        , atemp.rCharName
            , atemp.rIpAddr

        ]) + #13#10;
end;
// TgConnector

constructor TPaidConnector.Create(aSocket: TCustomWinSocket);
begin
    Fd_tcik := 0;
    Socket := aSocket;

    GateSender := TPacketSender.Create('Paid', BufferSizePaidSend, aSocket);
    GateReceiver := TPacketReceiver.Create('Paid', BufferSizePaidReceive);

    fdata := TPaidUserList.Create;
    sendUESTALLUSER;
end;

destructor TPaidConnector.Destroy;
begin

    fdata.Free;
    GateSender.Free;
    GateReceiver.Free;

    inherited Destroy;
end;

procedure TPaidConnector.sendUESTCLOSE(temp: PTNoticeData);                     //踢人下线
begin
    temp.rMsg := NGM_REQUESTCLOSE;
    AddSendData(0, PACKET_NOTICE, 0, pointer(temp), sizeof(TNoticeData));
end;

procedure TPaidConnector.online_close();
var
    pp: PTNoticeData;
    tempTuserList: TuserList;
    i, j: integer;
begin

    for j := 0 to fdata.fdata.Count - 1 do
    begin
        tempTuserList := fdata.fdata.Items[j];
        if (tempTuserList.fdata.Count <> 1)
            or (tempTuserList.Fpaid.rPaidType = pt_invalidate) then
            for i := 0 to tempTuserList.fdata.Count - 1 do
            begin
                pp := tempTuserList.fdata.Items[i];
                sendUESTCLOSE(pp);
                GateSender.Update;                                              //要求 马上发出去
            end;
    end;
end;

procedure TPaidConnector.loginidCLOSEUser(ausername: string);
var
    pp: PTNoticeData;
begin
    pp := fdata.getUsername(ausername);
    if pp = nil then exit;
    sendUESTCLOSE(pp);
end;

procedure TPaidConnector.loginidCLOSE(aLoginID: string);
var
    pp: PTNoticeData;
    tempTuserList: TuserList;
    i: integer;
begin
    tempTuserList := fdata.get(aLoginID);
    if tempTuserList = nil then exit;
    for i := 0 to tempTuserList.fdata.Count - 1 do
    begin
        pp := tempTuserList.fdata.Items[i];
        sendUESTCLOSE(pp);
    end;

end;

procedure TPaidConnector.sendUESTALLUSER();                                     //获取 所有人列表
var
    temp: TNoticeData;
begin
    temp.rMsg := NGM_REQUESTALLUSER;
    AddSendData(0, PACKET_NOTICE, 0, @temp, sizeof(TNoticeData));
end;

procedure TPaidConnector.SetWriteAllow(boFlag: Boolean);
begin
    GateSender.WriteAllow := boFlag;
end;

procedure TPaidConnector.AddReceiveData(aData: PChar; aCount: Integer);
begin
    if aCount > 0 then
    begin
        GateReceiver.PutData(aData, aCount);
        frmMain.AddLog(format('DataReceived (%d bytes %s)', [aCount, Socket.RemoteAddress]));
    end;
end;

procedure TPaidConnector.AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer);
begin
    if aSize < SizeOf(TPacketData) then
    begin
        GateSender.PutPacket(aID, aMsg, aRetCode, aData, aSize);
        frmMain.AddLog(format('DataSend (%d bytes %s)', [aSize, Socket.RemoteAddress]));
    end;
end;

procedure TPaidConnector.Update(CurTick: Integer);
var
    i: Integer;
    aPacket: TPacketData;
begin

    if abs(CurTick - Fd_tcik) > 10000 then
    begin
        Fd_tcik := CurTick;
        online_close();                                                         // >1和 过期 用户  踢下线
    end;

    fdata.Update(CurTick);
    GateReceiver.Update;
    while GateReceiver.Count > 0 do
    begin
        if GateReceiver.GetPacket(@aPacket) = false then break;
        MessageProcess(@aPacket);
    end;
    GateSender.Update;
end;

function TPaidConnector.MessageProcess(aPacket: pTPacketData): Boolean;
var
    I, N: INTEGER;
    str1, str2: string;
    pp: PTNoticeData;
    apaid: PTPaidData;
    apaidtemp: TPaidData;
    aResultCode, fresult: integer;
    userListtemp: TuserList;
begin
    //GNM_OUTUSER  用户 下线
    //GNM_INUSER   用户 上线
    //GNM_ALLCLEAR  清除所有 资料
    case aPacket.RequestMsg of
         PACKET_NOTICE:
            begin

                pp := @aPacket.data;
                case pp.rMsg of
                    GNM_OUTUSER:
                        begin
                            fdata.del_TNoticeData(pp.rLoginID, pp.rCharName);
                        end;
                    GNM_INUSER:
                        begin
                            userListtemp := fdata.get(pp.rLoginID);
                            if userListtemp <> nil then
                            begin
                                loginidCLOSE(pp.rLoginId);                      //把在线的踢下去
                            end;

                            if fdata.add_TNoticeData(pp) = true then
                            begin
                                {    userListtemp := fdata.get(pp.rLoginID);
                                    if userListtemp <> nil then
                                        if (userListtemp.fdata.Count <> 1) then
                                            loginidCLOSE(pp.rLoginID); //把在线的踢下去
                                            }
                            end else
                            begin
                                loginidCLOSE(pp.rLoginID);                      //把在线的踢下去
                                sendUESTCLOSE(pp);                              //把在线的踢下去
                            end;

                        end;
                    GNM_ALLCLEAR:
                        begin
                            fdata.Clear;
                        end;
                end;
            end;
         PACKET_PAID :
            begin

                apaid := @aPacket.data;
                apaidtemp := apaid^;
                aResultCode := -1;
                //获取 人物 点卡 状态
                aResultCode := 255;
                fresult := PaidDBAdapter.Select(apaidtemp.rLoginId, @apaidtemp);
                if fresult = DB_ERR_NOTFOUND then
                begin
                    fresult := PaidDBAdapter.Insert(apaidtemp.rLoginId, @apaidtemp);
                    if fresult = db_ok then
                        fresult := PaidDBAdapter.Select(apaidtemp.rLoginId, @apaidtemp);
                end;
                if fresult <> db_ok then exit;

                if (apaidtemp.rPaidType = pt_invalidate) or (apaidtemp.rPaidType = pt_none) then
                begin
                    apaidtemp.rPaidType := pt_test;                             //test 用户 不能移动
                    PaidDBAdapter.Update(apaidtemp.rLoginId, @apaidtemp);       //更新 修改用户类型
                end;
                aResultCode := 1;
                userListtemp := PaidConnectorList.getPaidLoginid(apaidtemp.rLoginID);
                if userListtemp <> nil then
                begin
                    PaidConnectorList.loginidCLOSE(apaidtemp.rLoginId);         //把在线的踢下去
                    aResultCode := 2;
                end;

                AddSendData(aPacket.RequestID, PACKET_PAID, aResultCode, @apaidtemp, sizeof(TPaidData));
            end;
    end;

end;

// TgConnectorList

constructor TPaidConnectorList.Create;
begin
    DataList := TList.Create;

end;

destructor TPaidConnectorList.Destroy;
begin

    Clear;
    DataList.Free;
    inherited Destroy;
end;

procedure TPaidConnectorList.Clear;
var
    i: Integer;
    Connector: TPaidConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        Connector.Free;
    end;
    DataList.Clear;
end;

function TPaidConnectorList.GetCount: Integer;
begin
    Result := DataList.Count;
end;

function TPaidConnectorList.CreateConnect(aSocket: TCustomWinSocket): Boolean;
var
    Connector: TPaidConnector;
begin
    Result := false;

    Connector := TPaidConnector.Create(aSocket);
    DataList.Add(Connector);

    Result := true;
end;

function TPaidConnectorList.DeleteConnect(aSocket: TCustomWinSocket): Boolean;
var
    i: Integer;
    Connector: TPaidConnector;
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

procedure TPaidConnectorList.AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer);
var
    i: Integer;
    Connector: TPaidConnector;
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

    frmMain.AddLog('TPaidConnectorList.AddReceiveData failed (' + aSocket.LocalAddress + ')');
end;

procedure TPaidConnectorList.Update(CurTick: Integer);
var
    i: Integer;
    Connector: TPaidConnector;
begin
    for i := DataList.Count - 1 downto 0 do
    begin
        Connector := DataList.Items[i];

        Connector.Update(CurTick);

    end;
end;

function TPaidConnectorList.getPaidUsername(aname: string): PTNoticeData;
var
    i: Integer;
    Connector: TPaidConnector;
begin
    result := nil;
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        result := Connector.fdata.getUsername(aname);
        if result <> nil then exit;
    end;
end;

function TPaidConnectorList.getPaidLoginid(aname: string): TuserList;
var
    i: Integer;
    Connector: TPaidConnector;
begin
    result := nil;
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        result := Connector.fdata.get(aname);
        if result <> nil then exit;
    end;
end;

procedure TPaidConnectorList.loginidCLOSEUser(ausername: string);
var
    i: Integer;
    Connector: TPaidConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        Connector.loginidCLOSEUser(ausername);
    end;
end;

procedure TPaidConnectorList.loginidCLOSE(aLoginID: string);
var
    i: Integer;
    Connector: TPaidConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        Connector.loginidCLOSE(aLoginID);
    end;
end;

function TPaidConnectorList.getmenu: string;
var
    i: Integer;
    Connector: TPaidConnector;
begin
    result := '';
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        result := result + '-----------------------------' + #13#10;
        result := result + Connector.fdata.getmenu;
    end;
end;

procedure TPaidConnectorList.SetWriteAllow(aSocket: TCustomWinSocket);
var
    i: Integer;
    Connector: TPaidConnector;
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

///

function TPaidUserList.add(aname: string): boolean;
var
    tempTuserList: TuserList;
    apaid: TPaidData;
begin
    result := false;
    if get(aname) <> nil then exit;
    apaid.rLoginId := aname;
    fillchar(apaid, sizeof(TPaidData), 0);
    apaid.rLoginId := aname;
    if PaidDBAdapter.Select(aname, @apaid) <> DB_OK then exit;

    tempTuserList := TuserList.Create(aname, @apaid, findexUsername);
    fdata.Add(tempTuserList);
    findexname.Insert(aname, tempTuserList);
end;

function TPaidUserList.add_TNoticeData(temp: PTNoticeData): boolean;
var
    tempTuserList: TuserList;

begin
    result := false;
    tempTuserList := get(temp.rLoginID);
    if tempTuserList = nil then
    begin
        add(temp.rLoginID);
        tempTuserList := get(temp.rLoginID);
        if tempTuserList = nil then exit;
    end;
    tempTuserList.add(temp);

    result := true;
end;

function TPaidUserList.getmenuLoginId(aname: string): string;
var
    i: integer;
    tempTuserList: TuserList;
begin
    result := '';
    for i := 0 to fdata.Count - 1 do
    begin
        tempTuserList := fdata.Items[i];
        if tempTuserList.fname = aname then
            result := result + tempTuserList.getmenu;
    end;

end;

function TPaidUserList.getmenu: string;
var
    i: integer;
    tempTuserList: TuserList;
begin
    result := '';
    for i := 0 to fdata.Count - 1 do
    begin
        tempTuserList := fdata.Items[i];
        result := result + tempTuserList.getmenu;
    end;

end;

procedure TPaidUserList.Update(CurTick: Integer);
var
    i: integer;
    tempTuserList: TuserList;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        tempTuserList := fdata.Items[i];
        tempTuserList.Update(CurTick);
    end;
end;

//测试 帐号 是否在线

function TPaidUserList.get(aLoginID: string): TuserList;
begin
    result := findexname.Select(aLoginID);
end;

function TPaidUserList.getUsername(aCharName: string): PTNoticeData;
begin
    result := findexUsername.Select(aCharName);
end;

function TPaidUserList.getname(aLoginID, aCharName: string): PTNoticeData;
var
    temp: TuserList;
begin
    result := nil;
    temp := findexname.Select(aLoginID);
    if temp = nil then exit;
    result := temp.getname(aCharName);
end;

procedure TPaidUserList.del(aLoginID: string);
var
    i: integer;
    temp: TuserList;
begin
    temp := get(aLoginID);
    if temp = nil then exit;

    for i := 0 to fdata.Count - 1 do
    begin
        temp := fdata.Items[i];
        if temp.fname = aLoginID then
        begin
            findexname.Delete(aLoginID);
            temp.Free;
            fdata.Delete(i);
            exit;
        end;
    end;

end;

procedure TPaidUserList.del_TNoticeData(aLoginID, aCharName: string);
var
    temp: TuserList;
begin
    temp := get(aLoginID);
    if temp = nil then exit;
    temp.del(aCharName);
    if temp.fdata.Count <= 0 then
        del(aLoginID);

end;

procedure TPaidUserList.Clear();
var
    i: integer;
    temp: TuserList;
begin
    for i := fdata.Count - 1 downto 0 do
    begin
        temp := fdata.Items[i];
        //  temp.Clear;
        temp.Free;
    end;
    fdata.Clear;
    findexname.Clear;
end;

constructor TPaidUserList.Create();
begin
    fdata := tlist.Create;
    findexname := TStringKeyClass.Create;
    findexUsername := TStringKeyClass.Create;
end;

destructor TPaidUserList.Destroy;
begin

    Clear;
    fdata.Free;
    findexname.Free;
    findexUsername.Free;
    inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////

procedure TuserList.add(temp: PTNoticeData);
var
    pp: PTNoticeData;
begin
    pp := getname(temp.rCharName);
    if pp <> nil then
    begin
        del(temp.rCharName);
        pp := nil;
    end;
    new(pp);
    pp^ := temp^;
    fdata.Add(pp);
    findexUsername.Insert(pp.rCharName, pp);
end;

procedure TuserList.Update(CurTick: Integer);
begin
    if abs(CurTick - FdecPaid_tcik) > 60000 then                                //1分钟 扣1点
    begin
        FdecPaid_tcik := CurTick;
        paid_dec;
    end;
    if abs(CurTick - Fsave_tcik) > 300000 then                                  //5分钟 保存1次
    begin
        Fsave_tcik := CurTick;
        if Fpaid.rPaidType = pt_timepay then
            savePaid;
    end;

end;

procedure TuserList.paid_dec;                                                   //扣 点卡     1分钟 扣一点
begin
    case Fpaid.rPaidType of
        pt_timepay:
            begin
                Fpaid.rRemainDay := Fpaid.rRemainDay - 1;
                if Fpaid.rRemainDay <= 0 then
                begin
                    Fpaid.rPaidType := pt_invalidate;
                    savePaid;
                end;
            end;
        pt_validate:
            begin
                if Fpaid.rmaturity < now() then
                begin
                    Fpaid.rPaidType := pt_invalidate;
                    savePaid;
                end;
            end;
    end;

end;

procedure TuserList.savePaid;
begin

    if PaidDBAdapter.Update(Fpaid.rLoginId, @Fpaid) <> db_ok then
        PaidDBAdapter.Insert(Fpaid.rLoginId, @Fpaid);
end;

function TuserList.getmenu: string;
var
    i: integer;
    pp: PTNoticeData;
begin
    result := '';
    result := result + Fpaid.rLoginId + ',' + Fpaid.rIpAddr + ',' + PaidtypeTostr(Fpaid.rPaidType) + #13#10;
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        result := result + '   ' + TNoticeDataTostr(pp);
    end;

end;

function TuserList.getname(aCharName: string): PTNoticeData;
var
    i: integer;
    pp: PTNoticeData;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if (pp.rCharName = aCharName) then
        begin
            result := pp;
            exit;
        end;
    end;

end;

procedure TuserList.del(aCharName: string);
var
    i: integer;
    pp: PTNoticeData;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if (pp.rCharName = aCharName) then
        begin
            findexUsername.Delete(pp.rCharName);
            dispose(pp);
            fdata.Delete(i);
            exit;
        end;
    end;

end;

procedure TuserList.Clear();
var
    i: integer;
    pp: PTNoticeData;
begin
    for i := fdata.Count - 1 downto 0 do
    begin
        pp := fdata.Items[i];
        dispose(pp);
    end;
    fdata.Clear;
    findexUsername.Clear;
end;

constructor TuserList.Create(aname: string; apaid: pTPaidData; akeyuser: TStringKeyClass);
begin

    fdata := tlist.Create;
    fname := aname;
    Fpaid := apaid^;
    FdecPaid_tcik := 0;
    Fsave_tcik := 0;
    findexUsername := akeyuser;
end;

destructor TuserList.Destroy;
begin
    //保存 点卡
    if Fpaid.rPaidType = pt_timepay then
        savePaid;
    Clear;
    fdata.Free;

    inherited Destroy;
end;
end.

