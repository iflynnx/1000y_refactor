unit uConnect;

interface

uses
  Classes, SysUtils, uGConnect, uBuffer, uAnsTick,
  uKeyClass, DefType, BSCommon, uPackets, IniFiles;
const
  savetime = 5; //每10秒存盘一次
type
  TBattleConnectState = (bcs_none, bcs_gotobattle, bcs_inbattle);

  TConnector = class
  private
    GateNo: Integer;
    ConnectID: Integer;


    SaveTick: Integer;

        //  BattleConnectState:TBattleConnectState;
  public
    CharName: string;
    StartTime: string;
    CharData: TDBRecord; //人物 属性；存盘 只会保存这份
    NTData: TNoticeData;

    LoginID: string;
    IpAddr: string;
    VerNo: Byte;
    PaidType: TPaidType;
    PaidCode: Byte;

    ReceiveBuffer: TPacketBuffer;
    OutIpAddr: string; //2015.11.25 在水一方
    hcode: string;
    Connected: Boolean; //<<<<<<
  public
    constructor Create(aGateNo, aConnectID: Integer);
    destructor Destroy; override;

    function StartLayer(aData: PChar; astrIp: string): Boolean;
    procedure EndLayer;
    procedure ReStartLayer;

    procedure Update(CurTick: Integer);

    procedure MessageProcess(aComData: PTWordComData);

    procedure AddReceiveData(aData: PChar; aSize: Integer);
    procedure AddSendData(aData: PChar; aSize: Integer);

        //    property BattleState:TBattleConnectState read BattleConnectState write BattleConnectState;
  end;

  TConnectorList = class
  private
    UniqueKey: TIntegerKeyClass;
    //NameKey: TStringKeyClass;

    DataList: TList;

    SaveBuffer: TPacketBuffer; //发送 DB  只发送 DB_UPDATE 并且不要求返回值

    CreateTick: Integer;
    DeleteTick: Integer;
    SaveTick: Integer;

    ConnectorProcessCount: Integer;
    CurProcessPos: Integer;
    OutIpList: TStringHash;
    LogidList: TStringHash;
    HcodeList: TStringHash;
    RepeatLoginList: TStringHash;
    BanList: THashedStringList;

    function GetCount: Integer;
    function GetNameKeyCount: Integer;
    function GetUniqueKeyCount: Integer;



  public
    NameKey: TStringKeyClass;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure Update(CurTick: Integer);

    procedure CreateConnect(aGateNo: Integer; aPacket: PTPacketData);
    procedure DeleteConnect(aGateNo: Integer; aConnectID: Integer);

    procedure ReStartChar(aConnectID: Integer);

    procedure CloseConnect(acount: integer);
    procedure CloseAllConnect;
    procedure CloseConnectByCharName(aName: string);
    function GetConnectByCharName(aName: string): Boolean;
    procedure CloseConnectByGateNo(aGateNo: Integer);

    procedure AddReceiveData(aGateNo: Integer; aPacket: PTPacketData);
//      procedure AddSendData(aPacket: PTPacketData);

    procedure AddSaveData(aData: PChar; aSize: Integer);

    function GetSaveListCount: Integer;

    procedure ProcessNoticeServerMessage(aPacketData: PTPacketData);
    procedure SendConnectInfo(aInfoStr: string);
    function CheckLimit(aName, aIP, aHcode: string): Boolean; //2015.11.25 在水一方
    function CheckLimit_Remove(aName, aIP, aHcode: string): Boolean; //2015.11.25 在水一方
    function RepeatLoginAdd(aName: string): Boolean;
    function RepeatLoginRemove(aName: string): Boolean;
    function RepeatLoginCheck(aName: string): Boolean;
    function BanlistAdd(aName: string; aTag: Integer): Boolean; //2015.11.26 在水一方
    function BanlistDel(aName: string): Boolean;
    function BanlistSave: Boolean;
    function BanlistToGate: Boolean; //<<<<<<

    property Count: Integer read GetCount;
    property NameKeyCount: Integer read GetNameKeyCount;
    property UniqueKeyCount: Integer read GetUniqueKeyCount;
    property Items: TList read DataList; //2015.11.25 在水一方
    property Bans: THashedStringList read BanList; //2015.11.26 在水一方
  end;

var
  ConnectorList: TConnectorList;

implementation

uses
  svMain, FGate, uUser, svClass, FSockets, AUtil32;

constructor TConnector.Create(aGateNo, aConnectID: Integer);
begin
  GateNo := aGateNo;
  ConnectID := aConnectID;

  VerNo := 0;
  PaidType := pt_none;
  PaidCode := 0;
  CharName := '';
  LoginID := '';
  IpAddr := '';

    //  BattleConnectState := bcs_none;

  FillChar(CharData, SizeOf(TDBRecord), 0);

  StartTime := DateToStr(Date) + ' ' + TimeToStr(Time);
  SaveTick := mmAnsTick;

  ReceiveBuffer := TPacketBuffer.Create(BufferSize_USER_RECE);
end;

destructor TConnector.Destroy;
var
  Str: string;
begin
  NTData.rMsg := GNM_OUTUSER;
  FrmSockets.AddDataToNotice(@NTData, SizeOf(TNoticeData));

  frmGate.AddLog('close ' + CharName);

    {    if BattleConnectState <> bcs_none then
        begin
            frmGate.AddSendBattleData(ConnectID, GB_USERDISCONNECT, 0, nil, 0);
        end;
     }
  if CharName <> '' then
  begin
    if Connected then //2015.11.25 在水一方
      ConnectorList.CheckLimit_Remove(LoginID, OutIpAddr, hcode); //<<<<<<
        //if BattleConnectState = bcs_none then
    EndLayer;
    ConnectorList.AddSaveData(@CharData, SizeOf(TDBRecord));
  end;

    //记录用户连线断线
  Str := (CharData.MasterName) + ',' + CharName + ',' + IpAddr + ',' + hcode + ',' + OutIpAddr + ',' + StartTime + ',' + DATETIMETOSTR(NOW) + ',';
  ConnectorList.SendConnectInfo(Str);

  ReceiveBuffer.Free;

  inherited Destroy;
end;

function TConnector.StartLayer(aData: PChar; astrIp: string): Boolean;
var
  Str, rdStr: string;
begin
  Result := true;

  Move(aData^, CharData, SizeOf(TDBRecord));
  CharName := (CharData.PrimaryKey); //人物名字
  LoginID := (CharData.MasterName); //帐号
  Str := astrIp; //(CharData.Dummy);

  Str := GetValidStr3(Str, rdStr, ',');
  IpAddr := rdStr;
  Str := GetValidStr3(Str, rdStr, ',');
  VerNo := _StrToInt(rdStr);
  Str := GetValidStr3(Str, rdStr, ',');
  PaidType := TPaidType(_StrToInt(rdStr));
  Str := GetValidStr3(Str, rdStr, ',');
  PaidCode := _StrToInt(rdStr);
  Str := GetValidStr3(Str, rdStr, ','); //2015.11.25 在水一方
  OutIpAddr := rdStr;
  Str := GetValidStr3(Str, rdStr, ',');
  hcode := rdStr; //<<<<<<


//    FillChar(CharData.Dummy, SizeOf(CharData.Dummy), 0);

  if UserList.InitialLayer(CharName, Self) = false then
  begin
    frmMain.WriteLogInfo('UserList.InitialLayer(CharName, Self)  failed');
    Result := false;
    exit;
  end;
  UserList.StartChar(CharName);

  FillChar(NTData, SizeOf(TNoticeData), 0);
  NTData.rMsg := GNM_INUSER;
  NTData.rLoginId := LoginID;
  NTData.rCharName := CharName;
  NTData.rIpAddr := IpAddr;
  NTData.rPaidType := TPaidType(PaidType);
  NTData.rCode := PaidCode;
  NTData.routip := OutIpAddr; //2015.11.25 在水一方
  NTData.rhcode := hcode; //<<<<<<

  FrmSockets.AddDataToNotice(@NTData, SizeOf(TNoticeData));
end;

procedure TConnector.EndLayer;
begin
  UserList.FinalLayer(Self);
end;

procedure TConnector.ReStartLayer;
begin
  if UserList.InitialLayer(CharName, Self) = false then
  begin
    exit;
  end;
  UserList.StartChar(CharName);
    //  BattleConnectState := bcs_none;
end;
//注意：TConnector.Update 并不处理包
//TUSER 里 处理

procedure TConnector.Update(CurTick: Integer);
//var
//    ComData: TWordComData;
//    iCnt: Word;
begin
  if frmMain.chkSaveUserData.Checked = true then
  begin //定 时间 存盘  //发送 DB
    if SaveTick + FrmMain.inteval < CurTick then
      //  if SaveTick + savetime * 10 * 100 < CurTick then
    begin
      ConnectorList.AddSaveData(@CharData, SizeOf(TDBRecord));
      SaveTick := CurTick;
    end;
  end;

    {if BattleConnectState = bcs_gotobattle then
    begin
        UserList.FinalLayer(Self);

        frmGate.AddSendBattleData(ConnectID, GB_USERCONNECT, 0, @CharData, SizeOf(TDBRecord));

        BattleConnectState := bcs_inbattle;
    end else if BattleConnectState = bcs_inbattle then
    begin
        if ReceiveBuffer.Count > 0 then
        begin
            while true do
            begin
                if ReceiveBuffer.Get(@ComData) = false then break;
                frmGate.AddSendBattleData(ConnectID, GB_GAMEDATA, 0, @ComData, ComData.Size + SizeOf(Word));
            end;
        end;
    end;
    }
end;

procedure TConnector.MessageProcess(aComData: PTWordComData);
begin
end;

procedure TConnector.AddReceiveData(aData: PChar; aSize: Integer);
begin
  if ReceiveBuffer.Put(aData, aSize) = false then
  begin
    frmMain.WriteLogInfo('TConnector.AddReceiveData() failed');
  end;
end;

procedure TConnector.AddSendData(aData: PChar; aSize: Integer);
begin
  GateConnectorList.AddSendData(GateNo, ConnectID, aData, aSize);
end;

// TConnectorList

constructor TConnectorList.Create;
begin
  CurProcessPos := 0;
  ConnectorProcessCount := 0;

  CreateTick := 0;
  DeleteTick := 0;
  SaveTick := 0;

  UniqueKey := TIntegerKeyClass.Create;
  NameKey := TStringKeyClass.Create;

  DataList := TList.Create;

  SaveBuffer := TPacketBuffer.Create(1024 * 1024 * 32);
  OutIpList := TStringHash.Create;
  LogidList := TStringHash.Create;
  HcodeList := TStringHash.Create;
  RepeatLoginList := TStringHash.Create;
  BanList := THashedStringList.Create;
  if FileExists(BanlistFile) then
    BanList.LoadFromFile(BanlistFile);
end;

destructor TConnectorList.Destroy;
begin
  Clear;
  UniqueKey.Free;
  NameKey.Free;
  DataList.Free;

  SaveBuffer.Free;
  OutIpList.Free;
  LogidList.Free;
  HcodeList.Free;
  RepeatLoginList.Free;
  BanList.Free;

  inherited Destroy;
end;

procedure TConnectorList.Clear;
var
  i: Integer;
  Connector: TConnector;
begin
  UniqueKey.Clear;
  NameKey.Clear;

  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    Connector.Free;
  end;
  DataList.Clear;

  SaveBuffer.Clear;
end;

procedure TConnectorList.Update(CurTick: Integer);
var
  i, StartPos: Integer;
  Connector: TConnector;
  CharData: TDBRecord;
begin
    //发送 DB
  if SaveBuffer.Count > 0 then
  begin
    if CurTick >= SaveTick + 10 then //10毫秒1次
    begin
      if SaveBuffer.View(@CharData) = true then
      begin
        if frmGate.AddSendDBServerData(DB_UPDATE, @CharData, SizeOf(TDBRecord)) = true then
        begin
          SaveBuffer.Flush;
        end;
      end;
      SaveTick := CurTick;
    end;
  end;

  //2015.12.17 屏蔽多余的2行
  //ConnectorProcessCount := (DataList.Count * 4 div 100);
  //if ConnectorProcessCount = 0 then ConnectorProcessCount := DataList.Count;
    //每次 只
  ConnectorProcessCount := ProcessListCount;

  if DataList.Count > 0 then
  begin
    StartPos := CurProcessPos;
    for i := 0 to ConnectorProcessCount - 1 do
    begin
      if CurProcessPos >= DataList.Count then CurProcessPos := 0;
      Connector := DataList.Items[CurProcessPos];
      Connector.Update(CurTick);
      Inc(CurProcessPos);
      if CurProcessPos = StartPos then break;
    end;
  end;
end;

function TConnectorList.GetCount: Integer;
begin
  Result := DataList.Count;
end;

function TConnectorList.GetNameKeyCount: Integer;
begin
  Result := NameKey.Count;
end;

function TConnectorList.GetUniqueKeyCount: Integer;
begin
  Result := UniqueKey.Count;
end;

function TConnectorList.CheckLimit(aName, aIP, aHcode: string): Boolean; //2015.11.25 在水一方
var
  nn, ni, nh: Integer;
begin
  Result := False;
  nn := 0; ni := 0; nh := 0;
  //ID处理
//  if aName <> '' then
//  begin
//    nn := LogidList.ValueOf(aName);
//    if nn + 1 > LoginID_Limit then
//    begin
//      frmMain.WriteLogInfo(Format('Login LoginID_Limit %s %d', [aName, nn]));
//      Exit;
//    end;
//    if nn = -1 then
//      LogidList.Add(aName, 1)
//    else begin
//      inc(nn);
//      LogidList.Modify(aName, nn);
//    end;
//  end;
  //IP处理
  if aIP <> '' then
  begin
    ni := OutIpList.ValueOf(aIP);
    if ni + 1 > OutIP_Limit then
    begin
      frmMain.WriteLogInfo(Format('Login OutIP_Limit  %s  %s  %d', [aName, aIP, ni]));
      Exit;
    end;
    if ni = -1 then
      OutIpList.Add(aIP, 1)
    else begin
      inc(ni);
      OutIpList.Modify(aIP, ni);
    end;
  end;

  //机器码处理
  if aHcode <> '' then
  begin
    nh := HcodeList.ValueOf(aHcode);
    if nh + 1 > HCode_Limit then
    begin
      frmMain.WriteLogInfo(Format('Login HCode_Limit  %s  %s  %d', [aName, aHcode, nh]));
      Exit;
    end;
    if nh = -1 then
      HcodeList.Add(aHcode, 1)
    else begin
      inc(nh);
      HcodeList.Modify(aHcode, nh);
    end;
  end;
  Result := True;

//  if (aName = '') or (aIP = '') or (aHcode = '') then Exit;
//
//  nn := LogidList.ValueOf(aName);
//  ni := OutIpList.ValueOf(aIP);
//  nh := HcodeList.ValueOf(aHcode);
//  if nn + 1 > LoginID_Limit then Exit;
//  if ni + 1 > OutIP_Limit then Exit;
//  if nh + 1 > HCode_Limit then Exit;
//
//  if nn = -1 then
//    LogidList.Add(aName, 1)
//  else begin
//    inc(nn);
//    LogidList.Modify(aName, nn);
//  end;
//
//  if ni = -1 then
//    OutIpList.Add(aIP, 1)
//  else begin
//    inc(ni);
//    OutIpList.Modify(aIP, ni);
//  end;
//
//  if nh = -1 then
//    HcodeList.Add(aHcode, 1)
//  else begin
//    inc(nh);
//    HcodeList.Modify(aHcode, nh);
//  end;

//  Result := True;
end;

function TConnectorList.CheckLimit_Remove(aName, aIP, aHcode: string): Boolean; //2015.11.25 在水一方
var
  nn, ni, nh: Integer;
begin
  Result := False;
  nn := 0; ni := 0; nh := 0;

  //ID处理
//  if aName <> '' then
//  begin
//    nn := LogidList.ValueOf(aName);
//    if nn > 0 then
//    begin
//      dec(nn);
//      LogidList.Modify(aName, nn);
//    end;
//  end;

  //IP处理
  if aIP <> '' then
  begin
    ni := OutIpList.ValueOf(aIP);
    if ni > 0 then
    begin
      dec(ni);
      OutIpList.Modify(aIP, ni);
    end;
  end;

  //aHcode处理
  if aHcode <> '' then
  begin
    nh := HcodeList.ValueOf(aHcode);
    if nh > 0 then
    begin
      dec(nh);
      HcodeList.Modify(aHcode, nh);
    end;
  end;

  Result := True;
end;

function TConnectorList.RepeatLoginAdd(aName: string): Boolean; //2015.12.22 在水一方
var
  nn: Integer;
begin
  Result := False;
  if (aName = '') then Exit;
  nn := RepeatLoginList.ValueOf(aName);
  if nn = -1 then
    RepeatLoginList.Add(aName, mmAnsTick)
  else
    RepeatLoginList.Modify(aName, mmAnsTick);
  Result := True;
end;

function TConnectorList.RepeatLoginRemove(aName: string): Boolean; //2015.12.22 在水一方
var
  nn, ni, nh: Integer;
begin
  Result := False;
  if (aName = '') then Exit;
  nn := RepeatLoginList.ValueOf(aName);
  if nn = -1 then exit;
  if nn < mmAnsTick - LoginOver_Limit * 100 then //默认限制30秒
  begin
    RepeatLoginList.Remove(aName);
    Result := True;
  end;
end;

function TConnectorList.RepeatLoginCheck(aName: string): Boolean; //2015.12.22 在水一方 返回true表示不通过
var
  nn: Integer;
begin
  Result := False;
  if (aName = '') then Exit;
  nn := RepeatLoginList.ValueOf(aName);
  if nn = -1 then exit;
  if nn < mmAnsTick - LoginOver_Limit * 100 then exit; //默认限制30秒
  Result := True;
end;

function TConnectorList.BanlistAdd(aName: string; aTag: Integer): Boolean; //2015.11.25 在水一方
var
  str: string;
begin
  str := aName + '=' + inttostr(aTag);
  if BanList.IndexOf(str) >= 0 then Exit;
  BanList.Add(str);
end;

function TConnectorList.BanlistDel(aName: string): Boolean; //2015.11.25 在水一方
begin
  BanList.Delete(BanList.IndexOfName(aName));
end;

function TConnectorList.BanlistSave: Boolean; //2015.11.25 在水一方
begin
  BanList.SaveToFile(BanlistFile);
end;

function TConnectorList.BanlistToGate: Boolean;
var //2015.11.25 在水一方
  ComData: TWordComData;
begin
  ComData.Size := 0;
  WordComData_ADDStringPro(ComData, BanList.Text);
  GateConnectorList.AddSendDataToBalance(@ComData, ComData.Size + SizeOf(Word), GM_BANLIST);
end;

//创建 一 个新的连接（用户）
{        temp.Size := 0;
                        WordComData_ADDBuf(temp, @aPacket^.Data, SizeOf(TDBRecord));
                        WordComData_ADDString(temp, str, length(str));}

procedure TConnectorList.CreateConnect(aGateNo: Integer; aPacket: PTPacketData);
var
//    nPos: Integer;
  Connector: TConnector;
  pcd: TDBRecord;
  GateNo, ConnectID: Integer;
  i: Integer;
  str, retstr: string;
  TempUser: TUser;
begin
  GateNo := aGateNo;
  ConnectID := aPacket^.RequestID;
  i := 0;
  WordComData_GETbuf(aPacket^.Data, i, @pcd, sizeof(TDBRecord));
  //获取连接信息
  str := WordComData_GETString(aPacket^.Data, i);

   // pcd := @aPacket^.Data;
  if (pcd.PrimaryKey) = '' then
  begin
    frmMain.WriteLogInfo('NOName Char found');
    GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DISCONNECT, nil, 0);
    exit;
  end;

  if RepeatLoginCheck(pcd.PrimaryKey) then begin //2015.12.22 在水一方 处理频繁顶号作弊问题
    GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_THESAVED, nil, 0);
    //retstr := '角色登录间隔过短,请稍后再试...';
    //GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DUPLICATE, PChar(retstr), Length(retstr));
    exit;
  end;

  //检测玩家在线关闭玩家客户端
  if checkjh then begin
    TempUser := UserList.GetUserPointer((pcd.PrimaryKey));
    if TempUser <> nil then
    begin
      //RepeatLoginAdd(pcd.PrimaryKey);
      GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DUPLICATE, nil, 0);
      TempUser.boDeleteState := true;
      TempUser.SendClass.SendChatMessage('您的角色在其他地方进行登录!!!', SAY_COLOR_SYSTEM);
      TempUser.SendClass.SendCloseClient(); ;
      Exit;
    end;
  end;
  //判断玩家是否在线
  Connector := NameKey.Select((pcd.PrimaryKey));
  if Connector <> nil then
  begin
    GateConnectorList.AddSendServerData(Connector.GateNo, Connector.ConnectID, GM_DISCONNECT, nil, 0);
    GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DUPLICATE, nil, 0);
    try
      RepeatLoginAdd(Connector.CharName);
      UniqueKey.Delete(Connector.ConnectID);
      NameKey.Delete(Connector.CharName);
      DataList.Remove(Connector);
      Connector.Free;
    except
      frmMain.WriteLogInfo('TConnectorList.CreateConnect () failed');
    end;
    exit;
  end;

  //检测是否在保存队列
  if SaveBuffer.Count > 0 then
  begin
    if SaveBuffer.View(@pcd) = true then
    begin
      GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_THESAVED, nil, 0);
      Exit;
    end;
  end;

  Connector := TConnector.Create(GateNo, ConnectID);
  if Connector.StartLayer(@pcd, str) = false then
  begin
    frmMain.WriteLogInfo('TConnectorList.CreateConnect (Connector.StartLayer) failed');
    GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DUPLICATE, nil, 0);
    Connector.Free;
    CloseConnectByCharName((pcd.PrimaryKey));
    exit;
  end;

  //检测是否允许登录
  if CheckLimit(Connector.LoginID, Connector.OutIpAddr, Connector.hcode) = false then
  begin
    //frmMain.WriteLogInfo(Format('Login Limit... %s %s %s', [Connector.LoginID, Connector.OutIpAddr, Connector.hcode]));
    GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DISCONNECT, nil, 0);
    Connector.Free;
    CloseConnectByCharName((pcd.PrimaryKey));
    exit;
  end;

  GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_CONNECT, nil, 0);
  RepeatLoginRemove(Connector.CharName);

  UniqueKey.Insert(ConnectID, Connector);
  NameKey.Insert(Connector.CharName, Connector);
  DataList.Add(Connector);
  Connector.Connected := True;
end;
{
procedure TConnectorList.CreateConnect(aGateNo:Integer; aPacket:PTPacketData);
var
    nPos            :Integer;
    Connector       :TConnector;
    pcd             :PTDBRecord;
    GateNo, ConnectID:Integer;

begin
    GateNo := aGateNo;
    ConnectID := aPacket^.RequestID;
    pcd := @aPacket^.Data;

    if (pcd^.PrimaryKey) = '' then
    begin
        frmMain.WriteLogInfo('NOName Char found');
        GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DISCONNECT, nil, 0);
        exit;
    end;

    Connector := NameKey.Select((pcd^.PrimaryKey));
    if Connector <> nil then
    begin
        GateConnectorList.AddSendServerData(Connector.GateNo, Connector.ConnectID, GM_DISCONNECT, nil, 0);
        GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DUPLICATE, nil, 0);

        try
            UniqueKey.Delete(Connector.ConnectID);
            NameKey.Delete(Connector.CharName);
            DataList.Remove(Connector);
            Connector.Free;
        except
            frmMain.WriteLogInfo('TConnectorList.CreateConnect () failed');
        end;
        exit;
    end;

    Connector := TConnector.Create(GateNo, ConnectID);
    if Connector.StartLayer(@aPacket^.Data) = false then
    begin
        frmMain.WriteLogInfo('TConnectorList.CreateConnect (Connector.StartLayer) failed');
        GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_DUPLICATE, nil, 0);
        Connector.Free;
        CloseConnectByCharName((pcd^.PrimaryKey));
        exit;
    end;

    GateConnectorList.AddSendServerData(GateNo, ConnectID, GM_CONNECT, nil, 0);

    UniqueKey.Insert(ConnectID, Connector);
    NameKey.Insert(Connector.CharName, Connector);
    DataList.Add(Connector);
end;
}

procedure TConnectorList.DeleteConnect(aGateNo: Integer; aConnectID: Integer);
var
    //  nPos            :Integer;
  Connector: TConnector;
begin
  Connector := UniqueKey.Select(aConnectID);
  if Connector = nil then exit;

  try
            //    nPos := DataList.IndexOf(Connector);
    RepeatLoginAdd(Connector.CharName);

    UniqueKey.Delete(Connector.ConnectID);
    NameKey.Delete(Connector.CharName);
    DataList.Remove(Connector);
    Connector.Free;
            //  DataList.Delete(nPos);
  except
    frmMain.WriteLogInfo('TConnectorList.DeleteConnect () failed');
  end;

end;

procedure TConnectorList.ReStartChar(aConnectID: Integer);
var
  Connector: TConnector;
begin
  Connector := UniqueKey.Select(aConnectID);
  if Connector <> nil then
  begin
    Connector.ReStartLayer;
  end;
end;

procedure TConnectorList.CloseConnect(acount: integer);
var
  i, j: Integer;
  Connector: TConnector;
begin
  j := 0;
  for i := DataList.Count - 1 downto 0 do
  begin
    if j > acount then exit;
    Connector := DataList.Items[i];
    GateConnectorList.AddSendServerData(Connector.GateNo, Connector.ConnectID, GM_DISCONNECT, nil, 0);
    inc(j);
  end;
end;

procedure TConnectorList.CloseAllConnect;
var
  i: Integer;
  Connector: TConnector;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    Connector := DataList.Items[i];
    GateConnectorList.AddSendServerData(Connector.GateNo, Connector.ConnectID, GM_DISCONNECT, nil, 0);
  end;
end;

procedure TConnectorList.CloseConnectByCharName(aName: string);
var
  i: Integer;
  Connector: TConnector;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    Connector := DataList.Items[i];
    if Connector.CharName = aName then
    begin
      GateConnectorList.AddSendServerData(Connector.GateNo, Connector.ConnectID, GM_DISCONNECT, nil, 0);
      exit;
    end;
  end;
end;

function TConnectorList.GetConnectByCharName(aName: string): Boolean;
var
  i: Integer;
  Connector: TConnector;
begin
  Result := False;
  for i := DataList.Count - 1 downto 0 do
  begin
    Connector := DataList.Items[i];
    if Connector.CharName = aName then
    begin
      Result := true;
      exit;
    end;
  end;
end;

procedure TConnectorList.CloseConnectByGateNo(aGateNo: Integer);
var
  i: Integer;
  Connector: TConnector;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    Connector := DataList.Items[i];
    if Connector.GateNo = aGateNo then
    begin
      DeleteConnect(aGateNo, Connector.ConnectID);
    end;
  end;
end;

procedure TConnectorList.AddReceiveData(aGateNo: Integer; aPacket: PTPacketData);
var
  //  ComData: TWordComData;
  nsize: integer;
  Connector: TConnector;
begin
  Connector := UniqueKey.Select(aPacket^.RequestID);
  if Connector <> nil then
  begin
        //        if Connector.BattleConnectState = bcs_none then
               // begin
    nsize := aPacket^.PacketSize - (SizeOf(Word) + SizeOf(Integer) + SizeOf(Byte) * 2);
      //  Move(aPacket^.Data, ComData.Data, ComData.Size);
    if nsize <= 0 then exit;
    if nsize <> (aPacket.Data.Size + SizeOf(Word)) then
    begin
      frmMain.WriteLogInfo('TConnectorList.AddReceiveData () failed ');
      exit;
    end;

    Connector.AddReceiveData(@aPacket.Data, aPacket.Data.Size + SizeOf(Word));
        { end else
         begin
             ComData.Size := aPacket^.PacketSize - (SizeOf(Word) + SizeOf(Integer) + SizeOf(Byte) * 2);
             Move(aPacket^.Data, ComData.Data, ComData.Size);
             frmGate.AddSendBattleData(aPacket^.RequestID, GB_GAMEDATA, 0, @ComData.Data, ComData.Size);
         end; }
    exit;
  end;
end;

{
procedure TConnectorList.AddSendData(aPacket: PTPacketData);
var
    ComData: TWordComData;
    Connector: TConnector;
begin
    Connector := UniqueKey.Select(aPacket^.RequestID);
    if Connector <> nil then
    begin
        ComData.Size := aPacket^.PacketSize - (SizeOf(Word) + SizeOf(Integer) + SizeOf(Byte) * 2);
        Move(aPacket^.Data, ComData.Data, ComData.Size);
        Connector.AddSendData(@ComData.Data, ComData.Size);
        exit;
    end;
end;
}
//发向 DB

procedure TConnectorList.AddSaveData(aData: PChar; aSize: Integer);
begin
  SaveBuffer.Put(aData, aSize);
end;

function TConnectorList.GetSaveListCount: Integer;
begin
  Result := SaveBuffer.Count;
end;

procedure TConnectorList.ProcessNoticeServerMessage(aPacketData: PTPacketData);
var
  i: integer;
  User: TUser;
  Connector: TConnector;
  pnd: PTNoticeData;
  nd: TNoticeData;
  Str: string;
begin
  if aPacketData^.RequestMsg <> PACKET_NOTICE then exit;

  pnd := @aPacketData^.Data;
  case pnd^.rMsg of
    NGM_REQUESTCLOSE: //踢人下线
      begin
        Str := pnd^.rCharName;
        Connector := NameKey.Select(Str);
        if Connector <> nil then
        begin
          User := UserList.GetUserPointer(Str);
          if User <> nil then
          begin
            User.SendClass.SendChatMessage('因重复连接或超过使用时间断开连接', SAY_COLOR_SYSTEM);
            User.boDeleteState := true;
            User.SendClass.SendCloseClient();
          end;
          //CloseConnectByCharName(Str);
        end;
      end;
    NGM_REQUESTALLUSER: //获取 所有人 列表
      begin
        FillChar(nd, SizeOf(TNoticeData), 0);
        nd.rMsg := GNM_ALLCLEAR;
        FrmSockets.AddDataToNotice(@nd, SizeOf(TNoticeData));
        for i := 0 to DataList.Count - 1 do
        begin
          Connector := DataList.Items[i];
          if Connector.CharName <> '' then
          begin
            Connector.NTData.rMsg := GNM_INUSER;
            FrmSockets.AddDataToNotice(@Connector.NTData, SizeOf(TNoticeData));
          end;
        end;
      end;
  end;
end;

procedure TConnectorList.SendConnectInfo(aInfoStr: string);
//var
 //   cnt             :integer;
 //   usd             :TStringData;
begin
    //   usd.rmsg := 1;
    //   SetWordString(usd.rWordString, aInfoStr + ',');
     //  cnt := sizeof(usd) - sizeof(TWordString) + sizeofwordstring(usd.rwordstring);

  FrmSockets.UdpConnectAddData(aInfoStr);
end;

end.

