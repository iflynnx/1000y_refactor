{$A1,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE ON}
{$WARN UNSAFE_CODE ON}
{$WARN UNSAFE_CAST ON}

{
--------------------------------------
----------用户连接--------------------
--------------------------------------
<<<<<<<<<<<GATE------用户>>>>>>>>>>
======收包========
TConnectorList.AddReceiveData <1,存>
TConnector.AddReceiveData     <2,存>
PacketReceiver.PutData        <3,存入缓冲区>
======处理包======
TConnector.Update             <定时处理>
PacketReceiver.Update;        <1,包分割>
PacketReceiver.GetPacket      <2,提出包>
TConnector.MessageProcess     <3,处理包>

======发送========
TConnector.AddSendData        <1,存>
PacketSender.PutPacket        <2,存入缓冲区>
======处理包======
TConnector.Update             <定时处理>
PacketSender.Update;          <发送 出去>


改名字流程
CM_CHANGECharName
    DB_SELECT      获取角色资料
    DB_INSERT      写入新角色
    DB_LG_UPDATE   修改账户信息

}
unit uConnector;

interface

uses
  Windows, Classes, SysUtils, ScktComp, mmSystem, uBuffer, uLGRecordDef,
  uKeyClass, DefType, AUtil32, uExequatur, uNewPackets;

type
  TClientWindow = (cw_none, cw_login, cw_createlogin, cw_selectchar, cw_main, cw_agree);
  TGameStatus = (gs_none, gs_login, gs_agree, gs_selectchar, gs_gotogame,
    gs_playing, gs_createchar, gs_deletechar, gs_createlogin,
    gs_changepass, gs_newchangepassSelect, gs_newchangepass, gs_FindPass
    , gs_changeCharName);

  TConnectData = record
    SocketInt: Integer;
  end;
  PTConnectData = ^TConnectData;

  TConnector = class
  private

    ConnectID: Integer;

    SocketInt: Integer;
    Socket: TCustomWinSocket;

    PacketSender: TNewPacketSender;
    PacketReceiver: TNewPacketReceiver; //

      //  PacketReceiver_r: TRPacketReceiver;
       // PacketSender_r: TRPacketSender;

    FGameStatePlay: boolean;

    FGameStatus: TGameStatus;
    FClientWindow: TClientWindow;

    FLastMessage: Byte;
    RequestTime: Cardinal;

    CreateTime: Cardinal;
    CreateDatetime: TDateTime;

    LoginData: TLGRecord;

    VerNo: Byte;
    PaidType: TPaidType;
    Code: Byte;
    LoginID, LoginPW, LoginEmail, LoginMasterKey, LoginNewPass: string;
    PlayChar, UseChar, UseLand: string;
    IpAddr: string;
    OutIpAddr: string; //2015.11.25 在水一方
    hcode: string; //<<<<<<
    FExequaturState: boolean;
    rOldName, rOldServerName, rNewName: string;
    boDelete: boolean;
    procedure ShowWindow(aKey: TClientWindow; boShow: Boolean);
    procedure SendStatusMessage(aKey: Byte; aStr: string);
    function GetCharInfo: string;
    procedure sendVillageInfo;
    procedure setNAME(aname: string);
    procedure WriteLog(aStr: string);
    function AddSendPING(aid: integer): Boolean;


  protected
  public
    constructor Create(aSocket: TCustomWinSocket; aConnectID: Integer);
    destructor Destroy; override;

    function Update(CurTick: Cardinal): Boolean;


    function MessageProcess(aComData: PTWordComData): Boolean; //处理 用户发来的包



    function AddReceiveData(aData: PChar; aCount: Integer): boolean;
    function AddSendData(aData: PChar; aCount: Integer): boolean;
    function AddSendDataDirect(aData: PChar; aCount: Integer): boolean;

       // procedure AddSendDataNoTouch(aData: PChar; aCount: Integer);

    procedure GameMessageProcess(aPacket: PTPacketData); //TGS
    procedure DBMessageProcess(aPacket: PTPacketData); //DB
    procedure LoginMessageProcess(aPacket: PTPacketData); //LOGIN
    procedure PaidMessageProcess(aPacket: PTPacketData); //PAID
    procedure sendCharInfo(); //发送 角色 列表

    procedure SetWriteAllow;

    property GameStatus: TGameStatus read FGameStatus;

    property PlayCharName: string read PlayChar;
  end;

  TConnectorList = class
  private
    UniqueID: Integer;
    UniqueValue: Integer;

        // FPlayingUserCount:Integer;
        //FLogingUserCount:Integer;

    SocketKey, ConnectIDKey: TIntegerKeyClass;
    FPlayingUser: TIntegerKeyClass;
    DataList: TList;
    DeleteList: TList;

    CurProcessPos, ProcessCount: Word;

    function GetCount: Integer;
    function GetPlayingUserCount: Integer;
    function GetloginUserCount: Integer;
  protected
  public
    ExequaturList: TExequatur; //许可证书
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    function Update(CurTick: Cardinal): Boolean;
    function ClearNoPlayer: integer;
    function ClearDieConnect: integer;

    function CreateConnect(aSocket: TCustomWinSocket): Boolean;
    function DeleteConnect(aSocket: TCustomWinSocket): string;

    function AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer): boolean;

    procedure GameMessageProcess(aPacket: PTPacketData);
    procedure DBMessageProcess(aPacket: PTPacketData);
    procedure LoginMessageProcess(aPacket: PTPacketData);
    procedure PaidMessageProcess(aPacket: PTPacketData);
    procedure BalanceMessageProcess(aPacket: PTPacketData);

    procedure SetWriteAllow(aSocket: TCustomWinSocket);
    function GetStateList(): string;
    function GetBuffList(): string;
    property Count: Integer read GetCount;

    property PlayingUserCount: Integer read GetPlayingUserCount; // write FPlayingUserCount;
    property LogingUserCount: Integer read GetloginUserCount; // write FLogingUserCount;
    property AutoConnectID: Integer read UniqueID;
    property GateUniqueValue: Integer read UniqueValue write UniqueValue;

  end;

var
    //用户  所有 连接
  ConnectorList: TConnectorList;
  userconnectorcount: integer = 40;
implementation

uses
  FMain, uUtil, uGramerID, StrUtils, uHardCode;

// TConnector

constructor TConnector.Create(aSocket: TCustomWinSocket; aConnectID: Integer);
begin
  boDelete := false;

  FGameStatePlay := false;
  FExequaturState := false;
  ConnectID := aConnectID;

  SocketInt := Integer(aSocket);

  Socket := aSocket;

  PacketSender := TNewPacketSender.Create('Sender', BufferSize_GATE_Send, aSocket);
  PacketReceiver := TNewPacketReceiver.Create('Receiver', BufferSize_GATE_Rece);

//    PacketSender_r := TRPacketSender.Create(aSocket, PacketSender);
 //   PacketReceiver_r := TRPacketReceiver.Create(aSocket, PacketReceiver, PacketSender_r);


  FGameStatus := gs_none;
  FClientWindow := cw_none;

  FLastMessage := 0;
  RequestTime := 0;
  CreateTime := timeGetTime;
  CreateDatetime := Now;

  FillChar(LoginData, SizeOf(TLGRecord), 0);

  LoginID := '';
  LoginPW := '';
  PlayChar := '';
  UseChar := '';
  UseLand := '';
  IpAddr := aSocket.RemoteAddress;
  OutIpAddr := '';
  hcode := '';
  VerNo := 0;
  PaidType := pt_none;
  Code := 0;
end;

destructor TConnector.Destroy;

begin
  if GameStatus = gs_playing then
  begin

    if GameSender <> nil then
    begin
           // if PlayChar <> '' then
             //   GameSender.PutPacket(ConnectID, GM_DISCONNECT, 0, @PlayChar[1], length(PlayChar));
      GameSender.PutPacket(ConnectID, GM_DISCONNECT, 0, nil, 0);
    end;
    if DBSender <> nil then
    begin
      if PlayChar <> '' then
        DBSender.PutPacket(ConnectID, DB_UNLOCK, 0, @PlayChar[1], length(PlayChar));
    end;
  end;
  ConnectorList.FPlayingUser.Delete(SocketInt);
  PacketReceiver.Free;
  PacketSender.Free;
//    PacketSender_r.Free;
 //   PacketReceiver_r.Free;
  inherited Destroy;
end;

procedure TConnector.SetWriteAllow;
begin
  PacketSender.WriteAllow := true;
end;



function TConnector.AddReceiveData(aData: PChar; aCount: Integer): boolean;
begin

  result := false;
  if boDelete then exit;
  if PacketReceiver.PutData(aData, aCount) then
    //if PacketReceiver_r.PutData(aData, aCount) then
  begin
    result := true;
    exit;
  end;
  PacketReceiver.Clear;
  PacketSender.Clear;
  ConnectorList.DeleteConnect(Socket);
  frmMain.WriteLog(format('TConnector.AddReceiveData,ERROR断开处理;ID%s,char:%s,server:%s', [LoginData.PrimaryKey, UseChar, UseLand]));
end;

//自己发送

function TConnector.AddSendPING(aid: integer): Boolean;
begin
  result := false;
  if boDelete then exit;
  if PacketSender.PutPacket(aID, GM_PING, 0, nil, 0) then
  begin
    result := true;
    exit;
  end;
  PacketReceiver.Clear;
  PacketSender.Clear;
  ConnectorList.DeleteConnect(Socket);
  frmMain.WriteLog(format('TConnector.AddSendPING,ERROR断开处理;ID%s,char:%s,server:%s', [LoginData.PrimaryKey, UseChar, UseLand]));
end;

function TConnector.AddSendData(aData: PChar; aCount: Integer): boolean;
var
  ComData: TWordComData;
begin
  result := false;
  if boDelete then exit;
  ComData.Size := aCount;
  Move(aData^, ComData.Data, aCount);
  if PacketSender.PutPacket(ConnectID, GM_GATE, 0, @ComData, aCount + 2) then
  begin
    result := true;
    exit;
  end;
  PacketReceiver.Clear;
  PacketSender.Clear;
  ConnectorList.DeleteConnect(Socket);
  frmMain.WriteLog(format('TConnector.AddSendData,ERROR断开处理;ID%s,char:%s,server:%s', [LoginData.PrimaryKey, UseChar, UseLand]));
end;
//转发

function TConnector.AddSendDataDirect(aData: PChar; aCount: Integer): boolean;
begin
  result := false;
  if boDelete then exit;
  if PacketSender.PutPacket(ConnectID, GM_GATE, 0, aData, aCount) then
  begin
    result := true;
    exit;
  end;
  PacketReceiver.Clear;
  PacketSender.Clear;
  ConnectorList.DeleteConnect(Socket);
  frmMain.WriteLog(format('TConnector.AddSendDataDirect,ERROR断开处理;ID%s,char:%s,server:%s', [LoginData.PrimaryKey, UseChar, UseLand]));
end;
{
function TConnector.AddSendDataNoTouch(aData: PChar; aCount: Integer);
begin
    // PacketSender.PutPacket(0, 0, 0, aData, aCount);
    if PacketSender.PutSendPacket(aData, aCount) = false then
    begin

        frmMain.AddLog(format('TConnector.AddSendDataNoTouch,ERROR断开处理;ID%s,char:%s,server:%s', [LoginData.PrimaryKey, UseChar, UseLand]));
        Socket.Close;
    end;
end;
 }

procedure TConnector.SendStatusMessage(aKey: Byte; aStr: string);
var
  cnt: Integer;
  sMessage: TSMessage;
begin
  sMessage.rmsg := SM_MESSAGE;
  sMessage.rkey := aKey;
  SetWordString(sMessage.rWordString, aStr);
  cnt := Sizeof(sMessage) - Sizeof(TWordString) + sizeofwordstring(sMessage.rWordString);

  AddSendData(@sMessage, cnt);
end;

procedure TConnector.ShowWindow(aKey: TClientWindow; boShow: Boolean);
var
  sWindow: TSWindow;
begin
  if boShow = true then
  begin
    FClientWindow := aKey;
  end;
  sWindow.rmsg := SM_WINDOW;
  sWindow.rwindow := Byte(aKey);
  sWindow.rboShow := boShow;
  AddSendData(@sWindow, sizeof(sWindow));
end;

procedure TConnector.WriteLog(aStr: string);
var
  Stream: TFileStream;
  FileName: string;
begin
  try
    if not DirectoryExists('.\Log\') then
    begin
      CreateDir('.\Log\');
    end;
    FileName := '.\Log\' + 'TConnector.Log';
    if FileExists(FileName) then
    begin
      Stream := TFileStream.Create(FileName, fmOpenReadWrite);
    end else
    begin
      Stream := TFileStream.Create(FileName, fmCreate);
    end;
    aStr := '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + ']' + aStr + #13 + #10;
    Stream.Seek(0, soFromEnd);
    Stream.WriteBuffer(aStr[1], length(aStr));
    Stream.Free;
  except
  end;
end;


function TConnector.Update(CurTick: Cardinal): Boolean;
var
  PacketData: TPacketData;
    //ComData: TWordComData;
  nSize: Integer;
  pCCPack: pTCCPack;
begin
  if boDelete then exit;
  PacketSender.Update;

//    PacketSender_r.Update(CurTick div 10);
 //   PacketReceiver_r.Update(CurTick div 10);

  PacketReceiver.Update;
  while PacketReceiver.Count > 0 do
  begin
    if PacketReceiver.GetPacket(@PacketData) = false then break;
        //if PacketData.RequestMsg = GM_CLIENT then
    begin
      nSize := PacketData.PacketSize - sizeof(word) - sizeof(Integer) - sizeof(byte) - sizeof(byte);
      case PacketData.RequestMsg of
        GM_CLIENT:
          begin
            if nSize <> (PacketData.Data.Size + 2) then
            begin
               //错误
              WriteLog(format('PacketReceiver 长度错误:PacketSize=%d nSize=%d(ID%s,char:%s,server:%s)', [PacketData.PacketSize, PacketData.Data.Size, LoginData.PrimaryKey, UseChar, UseLand]));
              ConnectorList.DeleteConnect(Socket);
              exit;
            end
            else
            begin
              if (FGameStatus = gs_playing) or FGameStatePlay then
              begin
                if GameSender <> nil then
                begin
                  GameSender.PutPacket(ConnectID, GM_SENDGAMEDATA, 0, @PacketData.Data, PacketData.Data.Size + 2);
                end;
              end else
              begin
                MessageProcess(@PacketData.Data);
              end;
            end;

          end;
        GM_PING:
          begin
            AddSendPING(PacketData.RequestID);
          end;
      end;

    end;
  end;
    /////////////////////////////////////////////////////////////////////////////
  if (FGameStatus <> gs_none) and (FGameStatus <> gs_playing) then
  begin
    if RequestTime + 60000 <= CurTick then
    begin
      RequestTime := 0;
      FGameStatus := gs_none;
      case FClientWindow of
        cw_login:
          begin
            SendStatusMessage(MESSAGE_LOGIN, '【TIMEOUT】请再试一次');
          end;
        cw_selectchar:
          begin
            SendStatusMessage(MESSAGE_SELCHAR, '【TIMEOUT】请再试一次');
          end;
        cw_createlogin:
          begin
            ShowWindow(cw_createlogin, false);
            ShowWindow(cw_login, true);
            SendStatusMessage(MESSAGE_LOGIN, '【TIMEOUT】请再试一次');
          end;
      end;
    end;
  end;
    /////////////////////////////////////////////////////////////////////////////
  if FGameStatus <> gs_playing then
  begin
    if CreateTime + 1000 * 60 * 1 <= CurTick then //
    begin
      ConnectorList.DeleteConnect(Socket);
    end;
  end;

  Result := true;
end;

function TConnector.GetCharInfo: string;
var
  i: Integer;
  str: string;
begin
  str := '';
  for i := 0 to 5 - 1 do
  begin
        {
              if LoginData.CharInfo[i].CharName[0] <> 0 then begin
                 str := str + StrPas (@LoginData.CharInfo[i].CharName);
                 str := str + ':';
                 str := str + StrPas (@LoginData.CharInfo[i].ServerName);
              end;
        }
    if LoginData.CharInfo[i].CharName <> '' then
    begin
      Str := Str + LoginData.CharInfo[i].CharName;
      str := str + ':';
      Str := Str + LoginData.CharInfo[i].ServerName;

         {   if LoginData.CharInfo[i].boCHANGECharNamex then
            begin
                str := str + ':';
                Str := Str + '改名字';
            end;
           }
    end;

    if i < 5 - 1 then str := str + ',';
        // str := str + ',';
  end;

  Result := str;
end;

procedure TConnector.PaidMessageProcess(aPacket: PTPacketData);
var
  pPaidData: PTPaidData;
  ws: TWordInfoString;
  str: string;
  cnt: integer;
begin
  case aPacket^.RequestMsg of
    PACKET_PAID:
      begin
        str := '';
        case aPacket^.ResultCode of
          1: ;

          2:
            begin
              str := '(帐号已使用)';
            end;
        else
          begin
            SendStatusMessage(MESSAGE_LOGIN, '储值资料错误');
            PaidType := pt_none;
            FGameStatus := gs_none;
            exit;
          end;
        end;

        pPaidData := PTPaidData(@aPacket^.Data);
        if pPaidData^.rLoginId <> LoginID then
        begin
          SendStatusMessage(MESSAGE_LOGIN, '储值资料错误');
          FGameStatus := gs_none;
          exit;
        end;

        PaidType := pPaidData^.rPaidType;
        Code := 0;

        case PaidType of
          pt_invalidate:
            str := str + '未储值使用者无法进行游戏。';
          pt_validate:
            str := str + '连接为收费帐户';
          pt_test:
            str := str + '连接为免费帐户';
          pt_timepay:
            str := str + '连接为收费秒卡帐户';
        else
          str := str + format(' %d', [pPaidData^.rRemainDay]);
        end;
        SendStatusMessage(MESSAGE_SELCHAR, str);
      end;
  end;
end;

procedure TConnector.GameMessageProcess(aPacket: PTPacketData);
var
  iCnt: Integer;
  pDBRecord: PTDBRecord;

begin
  case aPacket^.RequestMsg of
    GM_CONNECT:
      begin
        FGameStatePlay := true;
        FGameStatus := gs_playing;
        ShowWindow(cw_selectchar, FALSE);
        ShowWindow(cw_main, TRUE);
        ConnectorList.FPlayingUser.Insert(SocketInt, self); //增加 记录
        if DBSender <> nil then
        begin
          if PlayChar <> '' then
            DBSender.PutPacket(ConnectID, DB_LOCK, 0, @PlayChar[1], length(PlayChar)); //DB_LOCK 没有处理 已注释
        end;
      end;
    GM_DISCONNECT: //解除连线
      begin
        FGameStatePlay := false;
//                PacketSender.Update;
//                ClientSend;
        frmMain.AddLog('解除连线:' + PlayChar);

        if GameStatus = gs_playing then
          if GameSender <> nil then
            GameSender.PutPacket(ConnectID, GM_DISCONNECT, 0, nil, 0);

        Socket.Close;
      end;
    GM_SENDUSERDATA:
      begin
        pDBRecord := @aPacket^.Data;
        if DBSender <> nil then
        begin
          DBSender.PutPacket(ConnectID, DB_UPDATE, 0, @aPacket.Data, SizeOf(TDBRecord)); //发送给DB保存
        end;
      end;
    GM_SENDGAMEDATA: //发给 客户
      begin
        iCnt := aPacket^.PacketSize - (SizeOf(Word) + SizeOf(Integer) + SizeOf(Byte) * 2);
        AddSendDataDirect(@aPacket^.Data, iCnt);
      end;
    GM_DUPLICATE: //GM_DUPLICATE  复制 副本
      begin
        SendStatusMessage(MESSAGE_SELCHAR, '已解除连线');
        PlayChar := '';
        UseChar := '';
        UseLand := '';
        FGameStatus := gs_none;
      end;
    GM_THESAVED: //GM_DUPLICATE  复制 副本
      begin
        SendStatusMessage(MESSAGE_SELCHAR, '角色正在保存,请稍后...');
        PlayChar := '';
        UseChar := '';
        UseLand := '';
        FGameStatus := gs_none;
      end;
    GM_SENDALL:
      begin
        if FGameStatus = gs_playing then
        begin
          iCnt := aPacket^.PacketSize - (SizeOf(Word) + SizeOf(Integer) + SizeOf(Byte) * 2);
          AddSendDataDirect(@aPacket^.Data, iCnt);
        end;
      end;
  end;
end;
//DB  返回的报告

procedure TConnector.DBMessageProcess(aPacket: PTPacketData);
var
  i, cnt: Integer;
  str: string;
  ws: TWordInfoString;
  pDBRecord: PTDBRecord;
  pDBRecordList: PTDBRecordList;
  LGRecord: TLGRecord;
  CurDate, LastDate: TDateTime;
  temp: TWordComData;
  pDBRecordListWordComData: TWordInfoData;
begin
  case aPacket^.RequestMsg of
    DB_INSERT:
      begin
        if aPacket^.ResultCode = DB_OK then
        begin
          if FGameStatus = gs_changeCharName then
          begin
            Move(LoginData, LGRecord, SizeOf(TLGRecord));
            for i := 0 to high(LGRecord.CharInfo) do
            begin
              if LGRecord.CharInfo[i].CharName = rOldName then
              begin
                if LGRecord.CharInfo[i].ServerName = rOldServerName then
                begin
                  LGRecord.CharInfo[i].CharName := rNewName;
                              //      LGRecord.CharInfo[i].boCHANGECharNamex := false;
                  if LoginSenderx <> nil then
                  begin
                    LoginSenderx.PutPacket(ConnectID, DB_LG_UPDATE, 0, @LGRecord, SizeOf(TLGRecord));
                  end;
                  exit;
                end;
              end;
            end;
            SendStatusMessage(MESSAGE_SELCHAR, '错误：在账户角色名字。');
            rOldName := '';
            rOldServerName := '';
            rNewName := '';
            FGameStatus := gs_none;
            exit;
          end
          else if FGameStatus = gs_createchar then
          begin
            i := 0;
            str := WordComData_GETString(aPacket.data, i);
            Move(LoginData, LGRecord, SizeOf(TLGRecord));
            for i := 0 to 5 - 1 do
            begin

              if LGRecord.CharInfo[i].CharName = '' then
              begin

                LGRecord.CharInfo[i].CharName := str; //(pDBRecord^.PrimaryKey);
                LGRecord.CharInfo[i].ServerName := copy(ServerName, 1, 19);
                            //    LGRecord.CharInfo[i].boCHANGECharNamex:=False;
                break;
              end;
            end;
            if LoginSenderx <> nil then
            begin
              LoginSenderx.PutPacket(ConnectID, DB_LG_UPDATE, 0, @LGRecord, SizeOf(TLGRecord));
            end;
          end;
        end else
        begin
          case aPacket^.ResultCode of
            DB_ERR_DUPLICATE:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '此人物名称已被使用');
              end;
            DB_ERR_NOTENOUGHSPACE:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '人物资料已满，无法再建立');
              end;
            DB_ERR_INVALIDDATA:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '此为不适用的名称');
              end;
            DB_ERR_IO:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '发生I/O错误');
              end;
          else
            begin
              SendStatusMessage(MESSAGE_SELCHAR, 'DB服务器内部错误');
            end;
          end;
          FGameStatus := gs_none;
        end;
      end;
    DB_SELECT_FEATURE:
      begin
        if aPacket^.ResultCode = DB_OK then
        begin

          pDBRecordListWordComData.rmsg := SM_CHARFEATURELIST;

          copymemory(@pDBRecordListWordComData.rWordData[0], @aPacket^.Data, SizeOf(TDBRecordList));

          AddSendData(@pDBRecordListWordComData, SizeOf(TWordInfoData));



        end;
      end;

    DB_SELECT:
      begin
        if aPacket^.ResultCode = DB_OK then
        begin
          if FGameStatus = gs_changeCharName then
          begin
            pDBRecord := @aPacket^.Data;

            if (pDBRecord^.PrimaryKey) <> rOldName then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, '错误：在DB角色名字不匹配。');
              rOldName := '';
              rOldServerName := '';
              rNewName := '';
              FGameStatus := gs_none;
              exit;
            end;
            if (pDBRecord^.MasterName) <> LoginID then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, '错误：在DB角色账户不匹配。');
              rOldName := '';
              rOldServerName := '';
              rNewName := '';
              FGameStatus := gs_none;
              exit;
            end;
            if DBSender <> nil then
            begin
              pDBRecord.PrimaryKey := copy(rNewName, 1, 20);
              DBSender.PutPacket(ConnectID, DB_INSERT, 0, @pDBRecord^, SizeOf(TDBRecord));
            end;




          end
          else if FGameStatus = gs_selectchar then
          begin
            pDBRecord := @aPacket^.Data;

            if (pDBRecord^.PrimaryKey) <> UseChar then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, 'DB服务器内部错误');
              UseChar := '';
              UseLand := '';
              FGameStatus := gs_none;
              exit;
            end;

            if (pDBRecord^.MasterName) <> LoginID then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, '不是本人人物');
              UseChar := '';
              UseLand := '';
              FGameStatus := gs_none;
              exit;
            end;

            if frmMain.sckGameConnect.Active = false then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, '对不起，请稍后再试');
              UseChar := '';
              UseLand := '';
              FGameStatus := gs_none;
              exit;
            end;

            PlayChar := UseChar;

            frmMain.AddLog(format('人物名称： %s', [(pDBRecord^.PrimaryKey)]));

            if not frmMain.chkzf.Checked then
              OutIpAddr := IpAddr;

            Str := IpAddr + ',' + IntToStr(VerNo) + ',' + IntToStr(Byte(PaidType)) + ',' + IntToStr(Code) + ',' + OutIpAddr + ',' + hcode; //2015.11.25 在水一方
//                        pDBRecord^.Dummy := Str;
            temp.Size := 0;
            WordComData_ADDBuf(temp, @aPacket^.Data, SizeOf(TDBRecord));
            WordComData_ADDString(temp, str);
            if GameSender <> nil then
            begin
//                            GameSender.PutPacket(ConnectID, GM_CONNECT, 0, @aPacket^.Data, SizeOf(TDBRecord));
              GameSender.PutPacket(ConnectID, GM_CONNECT, 0, @temp, temp.Size + 2);
            end;

            FGameStatus := gs_gotogame;
          end else if FGameStatus = gs_deletechar then
          begin
            pDBRecord := @aPacket^.Data;

            if (pDBRecord^.PrimaryKey) <> UseChar then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, 'DB服务器内部错误');
              UseChar := '';
              UseLand := '';
              FGameStatus := gs_none;
              exit;
            end;
            if (pDBRecord^.MasterName) <> LoginID then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, '不是本人人物');
              UseChar := '';
              UseLand := '';
              FGameStatus := gs_none;
              exit;
            end;

            try
              CurDate := Date - 7;
              LastDate := ((pDBRecord^.LastDate));
              if LastDate > CurDate then
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '七天内使用过的人物无法删除');
                FGameStatus := gs_none;
                exit;
              end;
            except
              SendStatusMessage(MESSAGE_SELCHAR, '七天内使用过的人物无法删除');
              FGameStatus := gs_none;
              exit;
            end;
                        //在这里 把要删除的 清空 保存1次
            Move(LoginData, LGRecord, SizeOf(TLGRecord));
            for i := 0 to 5 - 1 do
            begin
                            //                     if StrPas (@LGRecord.CharInfo[i].CharName) = UseChar then begin
                            //                        if StrPas (@LGRecord.CharInfo[i].ServerName) = UseLand then begin
              if LGRecord.CharInfo[i].CharName = UseChar then
              begin
                if LGRecord.CharInfo[i].ServerName = UseLand then
                begin
                  FillChar(LGRecord.CharInfo[i], SizeOf(TCharInfo), 0);
                  break;
                end;
              end;
            end;

            if LoginSenderx <> nil then
            begin
              LoginSenderx.PutPacket(ConnectID, DB_LG_UPDATE, 0, @LGRecord, SizeOf(TLGRecord));
            end;
          end;
        end else
        begin
          case aPacket^.ResultCode of
            DB_ERR_NOTFOUND:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '找不到所选择的人物');
              end;
            DB_ERR_INVALIDDATA:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '此为不适用的名称');
              end;
            DB_ERR_IO:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '发生I/O错误');
              end;
          else
            begin
              SendStatusMessage(MESSAGE_SELCHAR, 'DB服务器内部错误');
            end;
          end;
          FGameStatus := gs_none;
        end;
      end;
    DB_UPDATE:
      begin
      end;
  else
    begin
            // frmMain.AddLog (format ('%d Packet was received', [aPacket^.RequestMsg]));
    end;
  end;
end;
//发送出生地点

procedure TConnector.sendVillageInfo();
var
  TEMP: TWordComData;
  pd: PTVillageData;
  I: INTEGER;
  str: string;
begin
  if VillageList.Count <= 0 then EXIT;
  str := '';
  for I := 0 to VillageList.Count - 1 do
  begin
    pd := VillageList.Items[I];
    str := str + pd.Name + #13#10;
  end;
  TEMP.Size := 0;
  WordComData_ADDbyte(TEMP, SM_Village);
  WordComData_ADDStringPro(TEMP, str);
  AddSendData(@TEMP.DATA, TEMP.Size);
end;
//发送到client

procedure TConnector.sendCharInfo();
var
  str: string;
  cnt: Integer;
  ws: TWordInfoString;
  ws2: TWordInfoString;
var
  ComData: TWordComData;
begin
    //发送 人物列表

  ws.rmsg := SM_CHARINFO;
  str := GetCharInfo;
  SetWordString(ws.rwordstring, str);
  cnt := sizeof(ws) - sizeof(TWordString) + SizeofWordString(ws.rWordstring);
  AddSendData(@ws, cnt);

  if DBSender <> nil then
  begin
    ws2.rmsg := DB_SELECT_FEATURE;



    SetWordString(ws2.rwordstring, str);
    cnt := sizeof(ws2) - sizeof(TWordString) + SizeofWordString(ws2.rWordstring);
//    ComData.Size := cnt;
//    Move(ws2, ComData.Data, cnt);
    DBSender.PutPacket(ConnectID, DB_SELECT_FEATURE, 0, @ws2, sizeof(ws2));

  end;

end;

//Client发送到-->GATE发送给DB 返回的消息 处理

procedure TConnector.LoginMessageProcess(aPacket: PTPacketData);
var
  cnt: Integer;
  ws: TWordInfoString;
  str: string;
  PaidPacket: TPacketData;
  pPaidData: PTPaidData;
  PaidData: TPaidData;
begin
  case aPacket^.RequestMsg of
    DB_LG_INSERT:
      begin
        if aPacket^.ResultCode = DB_OK then
        begin
          ShowWindow(cw_createlogin, FALSE);
          ShowWindow(cw_login, TRUE);
          SendStatusMessage(MESSAGE_LOGIN, '注册成功,用此账号名称进行连线');
        end else
        begin
          case aPacket^.ResultCode of
            DB_ERR_DUPLICATE:
              begin
                SendStatusMessage(MESSAGE_CREATELOGIN, '已存在的连线名称');
              end;
          else
            begin
              SendStatusMessage(MESSAGE_CREATELOGIN, 'LOGIN 服务器内部错误');
            end;
          end;
        end;
        FGameStatus := gs_none;
      end;
    DB_LG_SELECT:
      begin
        case FGameStatus of
          gs_login:
            begin
              if aPacket^.ResultCode <> DB_OK then
              begin
                case aPacket^.ResultCode of
                  DB_ERR_NOTFOUND:
                    begin
                      SendStatusMessage(MESSAGE_LOGIN, '找不到此连线名称资料');
                    end;
                  DB_ERR_INVALIDDATA:
                    begin
                      SendStatusMessage(MESSAGE_LOGIN, '连线名称不正确');
                    end;
                  DB_BLOCK:
                    begin
                      SendStatusMessage(MESSAGE_LOGIN, '帐号被封停');
                    end;
                else
                  begin
                    SendStatusMessage(MESSAGE_LOGIN, '请重新输入');
                  end;
                end;
                FExequaturState := false;

                exit;
              end;

              Move(aPacket^.Data, LoginData, SizeOf(TLGRecord));

              if LoginData.PrimaryKey <> LoginID then
              begin
                SendStatusMessage(MESSAGE_LOGIN, format('LOGIN 服务器内部错误', [ServerName]));
                LoginID := '';
                LoginPW := '';
                FGameStatus := gs_none;

                exit;
              end;
              if LoginData.PassWord <> LoginPW then
              begin
                SendStatusMessage(MESSAGE_LOGIN, format('此密码不适用', [ServerName]));
                LoginID := '';
                LoginPW := '';
                FGameStatus := gs_none;

                exit;
              end;

              ShowWindow(cw_login, FALSE);
              ShowWindow(cw_selectchar, TRUE);

              LoginData.LastDate := DateToStr(Date);
              LoginData.IpAddr := IpAddr;
                            //更新
              if LoginSenderx <> nil then
                LoginSenderx.PutPacket(ConnectID, DB_LG_UPDATE, 0, @LoginData, SizeOf(TLGRecord));
              sendVillageInfo; //发送创建 出生点
              sendCharInfo; //角色 列表

              FGameStatus := gs_none;
              FExequaturState := true;
                            //点卡 获取
              PaidType := pt_none;

              FillChar(PaidData, SizeOf(TPaidData), 0);

              PaidData.rLoginID := LoginID;
              PaidData.rIpAddr := IpAddr;
              PaidData.rMakeDate := LoginData.MakeDate;
              if PaidSender <> nil then
                PaidSender.PutPacket(ConnectID, PACKET_PAID, 0, @PaidData, SizeOf(TPaidData)); //唯一 发送 获取 点卡资料 地方
              SendStatusMessage(MESSAGE_SELCHAR, '确认储值资料中…');
            end;

          gs_newchangepassSelect:
            begin
              FGameStatus := gs_newchangepass;
              if aPacket^.ResultCode <> DB_OK then
              begin
                case aPacket^.ResultCode of
                  DB_ERR_NOTFOUND:
                    begin
                      SendStatusMessage(MESSAGE_CREATELOGIN, '找不到此连线名称资料');
                    end;
                  DB_ERR_INVALIDDATA:
                    begin
                      SendStatusMessage(MESSAGE_CREATELOGIN, '连线名称不正确');
                    end;
                else
                  begin
                    SendStatusMessage(MESSAGE_CREATELOGIN, '请重新输入');
                  end;
                end;
                FExequaturState := false;

                exit;
              end;

              Move(aPacket^.Data, LoginData, SizeOf(TLGRecord));

              if LoginData.PrimaryKey <> LoginID then
              begin
                SendStatusMessage(MESSAGE_CREATELOGIN, format('LOGIN 服务器内部错误', [ServerName]));
                exit;
              end;
              if LoginData.PassWord <> LoginPW then
              begin
                SendStatusMessage(MESSAGE_CREATELOGIN, format('此密码不适用', [ServerName]));
                exit;
              end;
              if LoginData.MasterKey <> LoginMasterKey then
              begin
                SendStatusMessage(MESSAGE_CREATELOGIN, format('安全问题输入错误', [ServerName]));
                exit;
              end;
              if LoginData.Email <> LoginEmail then
              begin
                SendStatusMessage(MESSAGE_CREATELOGIN, format('邮箱输入错误', [ServerName]));
                exit;
              end;

              LoginPW := LoginNewPass;
              LoginData.PassWord := LoginPW;

              SendStatusMessage(MESSAGE_CREATELOGIN, '资料正确密码修改成功');
              LoginData.LastDate := DateToStr(Date);
                            //更新
              if LoginSenderx <> nil then
              begin
                LoginSenderx.PutPacket(ConnectID, DB_LG_UPDATE, 0, @LoginData, SizeOf(TLGRecord));
              end;
            end;
          gs_FindPass:
            begin
              FGameStatus := gs_none;
              if aPacket^.ResultCode <> DB_OK then
              begin
                SendStatusMessage(MESSAGE_CREATELOGIN, '资料不正确');
                FExequaturState := false;
                exit;
              end;

              Move(aPacket^.Data, LoginData, SizeOf(TLGRecord));

              if (LoginData.PrimaryKey <> LoginID)
                or (LoginData.MasterKey <> LoginMasterKey)
                or (LoginData.Email <> LoginEmail) then
              begin
                SendStatusMessage(MESSAGE_CREATELOGIN, '资料不正确');
                exit;
              end;
              SendStatusMessage(MESSAGE_CREATELOGIN, '资料正确密码找回成功');
              SendStatusMessage(MESSAGE_FindPasswordResult, LoginData.PassWord);

            end;
        end;

      end;
    DB_LG_UPDATE:
      begin
        if aPacket^.ResultCode = DB_OK then
        begin
          Move(aPacket^.Data, LoginData, SizeOf(TLGRecord));
          case FGameStatus of
            gs_createchar:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '制造了一个角色');


                sendCharInfo;
                FGameStatus := gs_none;
              end;
            gs_changepass:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '密码变更完成');
                FGameStatus := gs_none;
              end;
            gs_newchangepass:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '密码修改成功');
                FGameStatus := gs_none;
              end;
            gs_changeCharName:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '角色名字修改成功');
                sendCharInfo;

                FGameStatus := gs_none;
              end;
            gs_deletechar:
              begin
                SendStatusMessage(MESSAGE_SELCHAR, '人物删除完成');

                sendCharInfo;

                FGameStatus := gs_none;
              end;
          end;
        end else
        begin
          case aPacket^.ResultCode of
            DB_ERR_NOTFOUND:
              begin
                SendStatusMessage(MESSAGE_LOGIN, '找不到此连线名称资料');
              end;
          end;
          FGameStatus := gs_none;
        end;
      end;
  else
    begin
            // frmMain.AddLog (format ('%d Packet was received', [aPacket^.RequestMsg]));
    end;
  end;
end;

procedure TConnector.setName(aname: string);
begin
  PacketSender.setName(aname);
  PacketReceiver.setName(aname);

//    PacketReceiver_r.setName(aname);
 //   PacketSender_r.setName(aname);
end;

//用户 收包 处理

function TConnector.MessageProcess(aComData: PTWordComData): Boolean;
var
  i: Integer;
  msg: PByte;
  sKey: TCKey;
    //   pcKey : PTCKey;
  pcVer: PTCVer;
    //   pcCreateIdPass : PTCCreateIdPass;
  pcCreateIdPass2: PTCCreateIdPass2;
  pcCreateIdPass3: PTCCreateIdPass3;
  pcIdPass: PTCIdPass;
  pcCreateChar: PTCCreateChar;
  pcDeleteChar: PTCDeleteChar;
  pcSelectChar: PTCSelectChar;
  pcChangePassword: PTCChangePassword;
  pcUpdatePassword: PTCUpdatePassword;
  PcFindPassword: PTFindPassword;
  LGRecord: TLGRecord;
  DBRecord: TDBRecord;

  uStr, checkcode: string;
  boFlag: Boolean;

  nYear, nMonth, nDay: Word;
  uid, upass, uname, unativenumber, umasterkey: string;
  uEmail, uPhone, uParentName, uParentNativeNumber: string;
  ucharname, uvillage, uservername: string;

  pd: PTVillageData;

  pExequatur: pTExequaturdata;
  pCChangeCharName: pTCChangeCharName;
begin
  Result := true;

  msg := @aComData^.Data;
    //////////////////////////////////////////////////////////////////////////////////////////////
    //                           注册账号，修改密码，找回密码
  case msg^ of
    CM_Balance: // Balance 消息 断开
      begin
        sKey.rmsg := SM_CLOSE;
        sKey.rkey := 1;
        AddSendData(@sKey, sizeof(sKey));
        exit;
      end;
    CM_IDPASS: //客户端 发来 帐号密码
      begin
        if (FGameStatus <> gs_none) or (FGameStatus = gs_login) then exit;

        if frmMain.sckLoginConnect.Socket.Connected = false then
        begin
          SendStatusMessage(MESSAGE_LOGIN, '对不起，请稍后再试');

          exit;
        end;

        FGameStatus := gs_login;

        pcIdPass := @aComData^.data;
                //验证 --------------------------------------------------------
        pExequatur := ConnectorList.ExequaturList.GetID(pcIdPass.ryid);
        if pExequatur = nil then
        begin
          FGameStatus := gs_none;
          SendStatusMessage(MESSAGE_LOGIN, '验证失败！');
          exit;
        end;
        if (pExequatur.rname <> pcIdPass.rId) or (pExequatur.rpassword <> pcIdPass.rPass) then
        begin
          FGameStatus := gs_none;
          SendStatusMessage(MESSAGE_LOGIN, '验证失败！');
          ConnectorList.ExequaturList.delname(pcIdPass.rId);

          exit;
        end;
        ConnectorList.ExequaturList.delname(pcIdPass.rId);
                //--------------------------------------------------------------
        LoginID := Trim((pcIdPass^.rID));
        LoginPW := Trim((pcIdPass^.rPass));
        OutIpAddr := Trim((pcIdPass^.routip)); //2015.11.25 在水一方
        hcode := Trim((pcIdPass^.rhcode)); //<<<<<<
        checkcode := Trim((pcIdPass^.rccode)); //2016.01.23 在水一方 >>>>>>

        if RivestStr(IntToStr(pcIdPass^.ryid + 25) + OutIpAddr + hcode) <> checkcode then //验证MD5
        begin
          FGameStatus := gs_none;
          SendStatusMessage(MESSAGE_LOGIN, '验证失败，请使用正确的版本！');
          WriteLog(format('MD5验证失败 [%s] [%s] [%s] [%s] [%s]', [LoginID, LoginPW, OutIpAddr, hcode, checkcode]));
          exit;
        end; //2016.01.23 在水一方 <<<<<<

        if (LoginID = '') or (LoginPW = '') then
        begin
          LoginID := '';
          LoginPW := '';
          FGameStatus := gs_none;
          SendStatusMessage(MESSAGE_LOGIN, '请输入正确的资料');
          exit;
        end;

        if (LimitUserCount > 0) and (ConnectorList.FPlayingUser.Count >= LimitUserCount) then
        begin
          FGameStatus := gs_none;
          LoginID := '';
          LoginPW := '';
          SendStatusMessage(MESSAGE_LOGIN, '上线人数已满，请选择其它服务器');
          exit;
        end;

        FillChar(LGRecord, SizeOf(TLGRecord), 0);

        LGRecord.PrimaryKey := LoginID;
        setNAME(LoginID);
        if LoginSenderx <> nil then
        begin
          LoginSenderx.PutPacket(ConnectID, DB_LG_SELECT, 0, @LGRecord.PrimaryKey, SizeOf(LGRecord.PrimaryKey));
        end;
      end;
    CM_CREATEIDPASS3: //创建 帐号
      begin
        if (FGameStatus <> gs_none) or (FGameStatus = gs_createlogin) then exit;

        pcCreateIdPass3 := @aComData^.Data;
        uId := Trim(pcCreateIdPass3^.rID);
        uPass := Trim(pcCreateIdPass3^.rPass);
        uName := Trim(pcCreateIdPass3^.rName);
        uNativeNumber := Trim(pcCreateIdPass3^.rNativeNumber);
        uMasterKey := Trim(pcCreateIdPass3^.rMasterKey);
        uEmail := Trim(pcCreateIdPass3^.rEmail);
        uPhone := Trim(pcCreateIdPass3^.rPhone);
        uParentName := Trim(pcCreateIdPass3^.rParentName);
        uParentNativeNumber := Trim(pcCreateIdPass3^.rParentNativeNumber);

        if (length(uId) < 6) or (not isGrammarID(uId)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【账户名称】只能使用英文字母与阿拉伯数字；并且至少6位。');
          exit;
        end;

        if (length(uPass) < 6) or (not isGrammarID(uPass)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【账户密码】只能使用英文字母与阿拉伯数字；并且至少6位。');
          exit;
        end;

        if (length(uName) < 4) or (not isFullHangul(uName)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【用户名字】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
          exit;
        end;

        if ((length(uNativeNumber) <> 15) and (length(uNativeNumber) <> 18)) or (not isGrammarID(uNativeNumber)) then //
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【身份证号】只能使用英文字母、阿拉伯数字；并且15位或者18位。');
          exit;
        end;

        if (length(uEmail) < 4) or (not isEmailID(uEmail)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【电子邮件】只能使用英文字母、阿拉伯数字；并且至少4位。');
          exit;
        end;

        if (length(uMasterKey) < 4) or (not isFullHangul(uMasterKey)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【安全问答】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
          exit;
        end;

        FGameStatus := gs_createlogin;

        FillChar(LGRecord, SizeOf(TLGRecord), 0);

        LGRecord.PrimaryKey := uId;
        LGRecord.PassWord := uPass;
        LGRecord.UserName := uName;
        LGRecord.NativeNumber := uNativeNumber;
        LGRecord.MasterKey := uMasterKey;
        LGRecord.Email := uEmail;
        LGRecord.Phone := uPhone;
        LGRecord.ParentName := uParentName;
        LGRecord.ParentNativeNumber := uParentNativeNumber;
        LGRecord.IpAddr := IpAddr;
        LGRecord.MakeDate := DateToStr(Date);

        if LoginSenderx <> nil then
        begin
          LoginSenderx.PutPacket(ConnectID, DB_LG_INSERT, 0, @LGRecord, SizeOf(TLGRecord));
        end;

      end;
    CM_FINDPASSWORD:
      begin
        if (FGameStatus <> gs_none) or (FGameStatus = gs_FindPass) then exit;
        PcFindPassword := @aComData^.Data;
        LoginID := PcFindPassword.rID;
        LoginEmail := PcFindPassword.rEmail;
        LoginMasterKey := PcFindPassword.rMasterKey;
        if (length(LoginID) < 6) or (not isGrammarID(LoginID)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【账户名称】只能使用英文字母与阿拉伯数字；并且至少6位。');
          exit;
        end;
        if (length(LoginEmail) < 4) or (not isEmailID(LoginEmail)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【电子邮件】只能使用英文字母、阿拉伯数字；并且至少4位。');
          exit;
        end;
        if (length(LoginMasterKey) < 4) or (not isFullHangul(LoginMasterKey)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【安全问答】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
          exit;
        end;

        FillChar(LGRecord, SizeOf(TLGRecord), 0);
        FGameStatus := gs_FindPass;
        LGRecord.PrimaryKey := LoginID;
        if LoginSenderx <> nil then
        begin
          LoginSenderx.PutPacket(ConnectID, DB_LG_SELECT, 0, @LGRecord.PrimaryKey, sizeof(LGRecord.PrimaryKey));
        end;

      end;
    CM_UPDATEPASSWORD: //修改页面处修改的密码
      begin
        if (FGameStatus <> gs_none) or (FGameStatus = gs_newchangepassSelect)
          or (FGameStatus = gs_newchangepass) then exit;

        pcUpdatePassword := @aComData^.Data;
        LoginID := Trim((pcUpdatePassword^.rID));
        LoginPW := Trim(pcUpdatePassword^.rPass);
        LoginNewPass := Trim(pcUpdatePassword^.rNewPass);
        LoginEmail := Trim(pcUpdatePassword^.rEmail);
        LoginMasterKey := Trim(pcUpdatePassword^.rMasterKey);

        if (length(LoginID) < 6) or (not isGrammarID(LoginID)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【账户名称】只能使用英文字母与阿拉伯数字；并且至少6位。');
          exit;
        end;

        if (length(LoginPW) < 6) or (not isGrammarID(LoginPW)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【原始密码】只能使用英文字母与阿拉伯数字；并且至少6位。');
          exit;
        end;

        if (length(LoginEmail) < 4) or (not isEmailID(LoginEmail)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【电子邮件】只能使用英文字母、阿拉伯数字；并且至少4位。');
          exit;
        end;

        if (length(LoginMasterKey) < 4) or (not isFullHangul(LoginMasterKey)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【安全问答】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
          exit;
        end;
        if (length(LoginNewPass) < 6) or (not isGrammarID(LoginNewPass)) then
        begin
          SendStatusMessage(MESSAGE_CREATELOGIN, '【新密码】只能使用英文字母与阿拉伯数字；并且至少6位。');
          exit;
        end;

                //Move(LoginData, LGRecord, SizeOf(TLGRecord));
                //TODO
        FillChar(LGRecord, SizeOf(TLGRecord), 0);
        FGameStatus := gs_newchangepassSelect;
        LGRecord.PrimaryKey := LoginID;
        if LoginSenderx <> nil then
        begin
          LoginSenderx.PutPacket(ConnectID, DB_LG_SELECT, 0, @LGRecord.PrimaryKey, sizeof(LGRecord.PrimaryKey));
        end;

      end;
  else
    begin
      if (FExequaturState = false) then
      begin
        SendStatusMessage(MESSAGE_LOGIN, '对不起,你没通过安全认证。' + inttostr(msg^));
        exit;
      end;

            //////////////////////////////////////////////////////////////////////////////////////////////
            //                          通过安全认证
      case msg^ of
        CM_CHANGEPASSWORD: //修改 密码
          begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_changepass) then exit;

            case PaidType of
              pt_none:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '接收玩家情报中，请稍後…');
                  exit;
                end;
              pt_invalidate:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '未储值使用者无法更改设定');
                  exit;
                end;
            end;
            FGameStatus := gs_changepass;

            pcChangePassword := @aComData^.Data;
            upass := Trim((pcChangePassword^.rNewPass));
            if (upass = '') or (Pos(',', upass) > 0) or (Length(upass) > 10) then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '新的密码输入错误');
              exit;
            end;
            Move(LoginData, LGRecord, SizeOf(TLGRecord));
            LGRecord.Password := uPass;
            if LoginSenderx <> nil then
            begin
              LoginSenderx.PutPacket(ConnectID, DB_LG_UPDATE, 0, @LGRecord, SizeOf(TLGRecord));
            end;
          end;

        CM_CREATECHAR: //创建 角色
          begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_createchar) then exit;

            case PaidType of
              pt_none:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '接收玩家情报中，请稍後…');
                           ///         exit;
                end;
              pt_invalidate:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '未储值使用者无法制造东西');
                  exit;
                end;
            end;

            FGameStatus := gs_createchar;

            boFlag := false;
            for i := 0 to 5 - 1 do
            begin
                            //               if LoginData.CharInfo[i].CharName[0] = 0 then begin
              if LoginData.CharInfo[i].CharName = '' then
              begin
                boFlag := true;
                break;
              end;
            end;
            if boflag = false then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '无法再建立角色');
              exit;
            end;

            pcCreateChar := @aComData^.data;
                        //                pcCreateChar^.rChar[NAME_SIZE - 1] := 0;
                          //              pcCreateChar^.rVillage[NAME_SIZE - 1] := 0;
                        //                pcCreateChar^.rServer[NAME_SIZE - 1] := 0;

            ucharname := LowerCase(Trim((pcCreateChar^.rChar)));
            uvillage := Trim((pcCreateChar^.rVillage));
            uservername := Trim((pcCreateChar^.rServer));
            if (ucharname = '') or (Pos(',', ucharname) > 0) then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '无法使用角色名称');
              exit;
            end;

            for i := 0 to RejectCharName.Count - 1 do
            begin
              if Pos(RejectCharName.Strings[i], ucharname) > 0 then
              begin
                FGameStatus := gs_none;
                SendStatusMessage(MESSAGE_SELCHAR, '无法使用角色名称');
                exit;
              end;
            end;

            if Length(ucharname) > 12 then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '角色名称最多六个字');
              exit;
            end;
            if (ucharname[1] >= '0') and (ucharname[1] <= '9') then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '角色名称的第一个字无法使用数字');
              exit;
            end;
            if (ucharname[Length(ucharname)] >= '0') and (ucharname[Length(ucharname)] <= '9') then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '角色名称的最后一个字无法使用数字');
              exit;
            end;

            if (not IsHZ(ucharname)) then //if (not isFullHangul(ucharname)) then // or (not isGrammarID(ucharname)) then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, 'ID无法使用特殊文字');
              exit;
            end;

            FillChar(DBRecord, SizeOf(TDBRecord), 0);

                        //拷贝 默认设置
            if pcCreateChar^.rSex = 0 then
              copymemory(@DBRecord, @CreateDBRecord0, SizeOf(TDBRecord))
            else
              copymemory(@DBRecord, @CreateDBRecord1, SizeOf(TDBRecord));

            for i := 0 to high(DBRecord.KeyArr) do DBRecord.KeyArr[i] := i;
            for i := 0 to high(DBRecord.ShortcutKeyArr) do DBRecord.ShortcutKeyArr[i] := i + 60;
            DecodeDate(Date, nYear, nMonth, nDay);
            with DBRecord do
            begin
              PrimaryKey := ucharname;
              MasterName := LoginData.PrimaryKey;
                            // Guild : array [0..20 - 1] of byte;
              LastDate := now; //format('%d-%d-%d', [nYear, nMonth, nDay]);
              CreateDate := now; //format('%d-%d-%d', [nYear, nMonth, nDay]);

              if pcCreateChar^.rSex = 0 then Sex := true
              else Sex := false;

              ServerID := 0;
              X := 165;
              Y := 227;
              //日期 修改随机出生点
              Randomize;
              i := Random(VillageList.Count - 1);
              pd := VillageList.Items[i];
              if pd <> nil then
              begin
                ServerID := pd^.ServerID;
                X := pd^.X;
                Y := pd^.Y;
              end;
//              for i := 0 to VillageList.Count - 1 do
//              begin
//                pd := VillageList.Items[i];
//                if pd^.Name = uvillage then
//                begin
//                  ServerID := pd^.ServerID;
//                  X := pd^.X;
//                  Y := pd^.Y;
//                  break;
//                end;
//              end;

              CurHeadSeek := 2200;
              CurArmSeek := 2200;
              CurLegSeek := 2200;
              CurHealth := 2200;
              CurSatiety := 2200;
              CurPoisoning := 2200;
              CurEnergy := 600;
              CurInPower := 1100;
              CurOutPower := 1100;
              CurMagic := 600;
              CurLife := 2200;

            end;
            if DBSender <> nil then
            begin
              DBSender.PutPacket(ConnectID, DB_INSERT, 0, @DBRecord, SizeOf(DBRecord));
            end;
          end;
        CM_CHANGECharName:
          begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_changeCharName) then exit;

            case PaidType of
              pt_none:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '接收玩家情报中，请稍後…');
                  exit;
                end;
              pt_invalidate:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '未储值使用者无法本功能');
                  exit;
                end;
            end;
            FGameStatus := gs_changeCharName;

            pCChangeCharName := @aComData^.Data;
                        //1，确认
                        //2，读角色
                        //3，改名字，增加到DB
                        //4，修改账户
            rOldName := pCChangeCharName.rOldName;
            rOldServerName := pCChangeCharName.rOldServerName;
            rNewName := pCChangeCharName.rNewName;

            if rOldName = '' then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：在旧角色名字是空。');
              exit;
            end;
            if rNewName = '' then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：在新角色名字是空。');
              exit;
            end;

            if rOldServerName <> ServerName then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：在服务器名字不匹配。');
              exit;
            end;

                       { for i := 0 to high(LoginData.CharInfo) do
                        begin
                            if LoginData.CharInfo[i].CharName = rOldName then
                            begin
                                if LoginData.CharInfo[i].ServerName = rOldServerName then
                                begin
                                    if LoginData.CharInfo[i].boCHANGECharNamex = false then
                                    begin
                                        FGameStatus := gs_none;
                                        SendStatusMessage(MESSAGE_SELCHAR, '错误：在角色不能修改名字。');
                                        exit;
                                    end;
                                    boFlag := true;
                                    Break;
                                end;
                            end;
                        end;    }
            if boFlag = false then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：在角色名字不匹配。');
              exit;
            end;
                        ////////                      名字安全检查

            for i := 0 to RejectCharName.Count - 1 do
            begin
              if Pos(RejectCharName.Strings[i], rNewName) > 0 then
              begin
                FGameStatus := gs_none;
                SendStatusMessage(MESSAGE_SELCHAR, '错误：无法使用角色名称');
                exit;
              end;
            end;
            if (rNewName = '') or (Pos(',', rNewName) > 0) then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：无法使用角色名称');
              exit;
            end;
            if Length(rNewName) > 12 then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：角色名称最多六个字');
              exit;
            end;
            if (rNewName[1] >= '0') and (rNewName[1] <= '9') then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：角色名称的第一个字无法使用数字');
              exit;
            end;
            if (rNewName[Length(rNewName)] >= '0') and (rNewName[Length(rNewName)] <= '9') then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：角色名称的最后一个字无法使用数字');
              exit;
            end;

            if (not IsHZ(rNewName)) then //if (not isFullHangul(rNewName)) then  // or (not isGrammarID(ucharname)) then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '错误：无法使用特殊文字');
              exit;
            end;
                        ///////
            if DBSender <> nil then
            begin
              aComData.Size := 0;
              WordComData_ADDstring(aComData^, rOldName);
              DBSender.PutPacket(ConnectID, DB_SELECT, 0, pchar(aComData), aComData.Size + 2);
            end;
          end;
        CM_DELETECHAR: //删除人物
          begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_deletechar) then exit;

            case PaidType of
              pt_none:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '接收玩家情报中，请稍後…');
                  exit;
                end;
              pt_invalidate:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '未储值使用者无法删除');
                  exit;
                end;
            end;

            FGameStatus := gs_deletechar;

            pcDeleteChar := @aComData^.Data;
                        //                pcDeleteChar^.rChar[NAME_SIZE - 1] := 0;

                        //uStr := ();
                      //  uStr := GetTokenStr(uStr, UseChar, ':');
            UseChar := pcDeleteChar^.rChar;
                        //uStr := GetTokenStr(uStr, UseLand, ':');
            UseLand := pcDeleteChar^.rServer;
            UseChar := Trim(UseChar);
            UseLand := Trim(UseLand);
            if UseChar = '' then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '请选择要删除的人物');
              exit;
            end;
            if UseLand <> ServerName then
            begin
              FGameStatus := gs_none;
              SendStatusMessage(MESSAGE_SELCHAR, '不是本服务器的人物');
              exit;
            end;

            if DBSender <> nil then
            begin
                            // 发送 的固定 长度 字符

              aComData.Size := 0;
              WordComData_ADDstring(aComData^, UseChar);
              DBSender.PutPacket(ConnectID, DB_SELECT, 0, pchar(aComData), aComData.Size + 2);
            end;
          end;
        CM_SELECTCHAR: //选择 人物
          begin
            //角色预创建
            if frmMain.chkyzz.Checked = true then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, '当前为角色预创建状态,无法进入游戏!');
              exit;
            end;
            if (FGameStatus <> gs_none) or (FGameStatus = gs_selectchar) then exit;
            if frmMain.sckDBConnect.Socket.Connected = false then
            begin
              SendStatusMessage(MESSAGE_SELCHAR, '对不起，请稍后再试');
              exit;
            end;

            case PaidType of
              pt_none:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '接收玩家情报中，请稍後…');
                  exit;
                end;
              pt_invalidate:
                begin
                  SendStatusMessage(MESSAGE_SELCHAR, '未储值使用者无法连线');
                  exit;
                end;
            end;

            FGameStatus := gs_selectchar;

            pcSelectChar := @aComData.Data;
                        //                pcSelectChar^.rChar[NAME_SIZE - 1] := 0;

                      //  uStr := (pcSelectChar^.rChar);
                       // uStr := GetTokenStr(uStr, UseChar, ':');
                        //uStr := GetTokenStr(uStr, UseLand, ':');
            UseChar := pcSelectChar^.rChar;
            UseLand := pcSelectChar^.rServer;
            UseChar := Trim(UseChar);
            UseLand := Trim(UseLand);

            if (UseChar = '') or (UseLand = '') then
            begin
              FGameStatus := gs_none;
              UseChar := '';
              UseLand := '';
              exit;
            end;
            if UseLand <> ServerName then
            begin
              FGameStatus := gs_none;
              UseChar := '';
              UseLand := '';
              SendStatusMessage(MESSAGE_SELCHAR, '不是本服务器的人物');
              exit;
            end;

            SendStatusMessage(MESSAGE_SELCHAR, format('选择了【%s】角色', [UseChar]));
            setNAME(LoginData.PrimaryKey + ',' + UseChar);
            if LoginSenderx <> nil then
            begin
              FillChar(LGRecord, SizeOf(TLGRecord), 0);
              LGRecord.PrimaryKey := LoginData.PrimaryKey;
              LGRecord.PassWord := '';
              LGRecord.Birth := '';
              LGRecord.Address := '';
              LGRecord.NativeNumber := '';
              LGRecord.MasterKey := '';
              LGRecord.Email := '';
              LGRecord.Phone := '';
              LGRecord.ParentName := '';
              LGRecord.ParentNativeNumber := '';
              LGRecord.IpAddr := '';
              LGRecord.MakeDate := '';
              LGRecord.UserName := UseChar;
              LGRecord.LastDate := DateToStr(Date);
              LoginSenderx.PutPacket(ConnectID, DB_LG_SELECTCHAR, 0, @LGRecord, SizeOf(TLGRecord));
            end;
            if DBSender <> nil then
            begin
              aComData.Size := 0;
              WordComData_ADDstring(aComData^, UseChar);
              DBSender.PutPacket(ConnectID, DB_SELECT, 0, pchar(aComData), aComData.Size + 2);

            end;
          end;
      end;
    end;
  end;
  FLastMessage := msg^;
  RequestTime := timeGetTime;
end;

// TConnectorList

constructor TConnectorList.Create;
begin
  FPlayingUser := TIntegerKeyClass.Create;
  ExequaturList := TExequatur.Create;
  UniqueID := 0;
  UniqueValue := -1;

    // FPlayingUserCount := 0;
//    FLogingUserCount := 0;

  SocketKey := TIntegerKeyClass.Create;
  ConnectIDKey := TIntegerKeyClass.Create;

  DataList := TList.Create;
  DeleteList := TList.Create;

  CurProcessPos := 0;
  ProcessCount := 40;
end;

destructor TConnectorList.Destroy;
begin

  Clear;
  SocketKey.Free;
  ConnectIDKey.Free;
  DataList.Free;
  DeleteList.Free;
  FPlayingUser.Free;
  ExequaturList.Free;
  inherited Destroy;
end;

procedure TConnectorList.Clear;
var
  i: Integer;
  Connector: TConnector;
  pd: PTConnectData;
  sKey: TCKey;
begin
    // FPlayingUserCount := 0;
//    FLogingUserCount := 0;

  sKey.rmsg := SM_CLOSE;
  sKey.rkey := 1;
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    Connector.AddSendData(@sKey, sizeof(sKey));
    Connector.Free;
  end;
  DataList.Clear;

  for i := 0 to DeleteList.Count - 1 do
  begin
    pd := DeleteList.Items[i];
    Dispose(pd);
  end;
  DeleteList.Clear;

  SocketKey.Clear;
  ConnectIDKey.Clear;
end;

function TConnectorList.GetPlayingUserCount: Integer;
begin
  Result := FPlayingUser.count;
end;

function TConnectorList.GetloginUserCount: Integer;
begin
  Result := DataList.Count - FPlayingUser.count;
end;

function TConnectorList.GetCount: Integer;
begin
  Result := DataList.Count;
end;

function TConnectorList.CreateConnect(aSocket: TCustomWinSocket): Boolean;
var
  Connector: TConnector;
begin
  Result := false;

  if UniqueValue = -1 then exit;

  Connector := TConnector.Create(aSocket, UniqueID + UniqueValue);

  SocketKey.Insert(Connector.SocketInt, Connector);
  ConnectIDKey.Insert(Connector.ConnectID, Connector);
  DataList.Add(Connector);

  Inc(UniqueID, 10);
    //    Inc(FLogingUserCount);

  Result := true;
end;

function TConnectorList.DeleteConnect(aSocket: TCustomWinSocket): string;
var
  pd: PTConnectData;
  Connector: TConnector;
begin
  Result := '';

  Connector := SocketKey.Select(Integer(aSocket));
  if Connector = nil then exit;
  Connector.boDelete := true;
  Result := Connector.PlayCharName;

  New(pd);
  pd^.SocketInt := Integer(aSocket);

  DeleteList.Add(pd);
end;


function TConnectorList.AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer): boolean;
var
  Connector: TConnector;
begin
  result := false;
  Connector := SocketKey.Select(Integer(aSocket));
  if Connector <> nil then
  begin
    result := Connector.AddReceiveData(aData, aCount);
    exit;
  end;
//  else
//    frmMain.WriteLog(format('ConnectorList.AddReceiveData 失败, Connector = nil aSocket = %d', [Integer(aSocket)])); //

end;
// TGS  连接  收包处理
//GameMessageProcess----> TConnector.GameMessageProcess

procedure TConnectorList.GameMessageProcess(aPacket: PTPacketData);
var
  i: Integer;
  Connector: TConnector;
  pDBRecord: PTDBRecord;
begin
  if aPacket^.RequestMsg = GM_BANLIST then
  begin
    if BalanceSender <> nil then
      BalanceSender.PutPacket(0, BM_BANLIST, 0, @aPacket^.Data, aPacket^.Data.Size + sizeof(Word));
    exit;
  end;
  if aPacket^.RequestMsg = GM_SENDALL then
  begin
        //给所有 连接
            // Reverse4Bit (PTComData (@aPacket^.Data));
    for i := 0 to DataList.Count - 1 do
    begin
      Connector := DataList.Items[i];
      Connector.GameMessageProcess(aPacket);
    end;
    exit;
  end;
  if aPacket^.RequestMsg = GM_UNIQUEVALUE then
  begin
    UniqueValue := aPacket^.RequestID;
    frmMain.Caption := format('Gate Server [%d]', [UniqueValue]);
    exit;
  end;

  Connector := ConnectIDKey.Select(aPacket^.RequestID);
  if Connector <> nil then
  begin
    Connector.GameMessageProcess(aPacket);
    exit;
  end;

  if aPacket^.RequestMsg = GM_SENDUSERDATA then
  begin
    pDBRecord := @aPacket^.Data;
    if DBSender <> nil then
    begin
      DBSender.PutPacket(0, DB_UPDATE, 0, @aPacket^.Data, SizeOf(TDBRecord));
    end;
    frmMain.AddLog(format('closing user data (%s)', [(pDBRecord^.PrimaryKey)]));
  end else
  begin
    if GameSender <> nil then
    begin
      GameSender.PutPacket(aPacket^.RequestID, GM_DISCONNECT, 0, nil, 0);
    end;
        // frmMain.AddLog ('TConnectorList.GameMessageProcess failed');
  end;
end;

procedure TConnectorList.DBMessageProcess(aPacket: PTPacketData);
var
  Connector: TConnector;

begin
  if aPacket^.RequestMsg <> DB_UPDATE then
  begin
    Connector := ConnectIDKey.Select(aPacket^.RequestID);
    if Connector <> nil then
    begin
      Connector.DBMessageProcess(aPacket);
    end;
        // frmMain.AddLog ('TConnectorList.DBMessageProcess failed');
  end else
  begin
    case aPacket^.RequestMsg of
      DB_UPDATE: // LOG
        begin
          if aPacket^.ResultCode = DB_OK then
          begin

            frmMain.AddLog(format('user data saved [%s]', [strpas(@aPacket^.Data)]));
          end else
          begin

            frmMain.AddLog(format('user data save failed [%s]', [strpas(@aPacket^.Data)]));
          end;
        end;
    end;
  end;
end;

procedure TConnectorList.LoginMessageProcess(aPacket: PTPacketData);
var
  Connector: TConnector;
begin
  Connector := ConnectIDKey.Select(aPacket^.RequestID);
  if Connector <> nil then
  begin
    Connector.LoginMessageProcess(aPacket); //Client--->GATE发送到DB返回的消息处理
  end;
    // frmMain.AddLog ('TConnectorList.LoginMessageProcess failed');
end;

function TConnectorList.GetStateList(): string;
var
  i: integer;
  Connector: TConnector;
  str: string;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];

    result := result + '账号：' + Connector.LoginData.PrimaryKey + #13#10;
    result := result + 'FGameStatePlay：' + IfThen(Connector.FGameStatePlay, '游戏阶段', '登陆阶段') + #13#10;
    case Connector.FGameStatus of
      gs_none: str := 'gs_none';
      gs_login: str := 'gs_login';
      gs_agree: str := 'gs_agree';
      gs_selectchar: str := 'gs_selectchar';
      gs_gotogame: str := 'gs_gotogame';
      gs_playing: str := 'gs_playing';
      gs_createchar: str := 'gs_createchar';
      gs_deletechar: str := 'gs_deletechar';
      gs_createlogin: str := 'gs_createlogin';
      gs_changepass: str := 'gs_changepass';
      gs_newchangepassSelect: str := 'gs_newchangepassSelect';
      gs_newchangepass: str := 'gs_newchangepass';
      gs_FindPass: str := 'gs_FindPass';
    else str := 'ERROR';
    end;
    result := result + 'FGameStatus：' + str + #13#10;

    case Connector.FClientWindow of
      cw_none: str := 'cw_none';
      cw_login: str := 'cw_login';
      cw_createlogin: str := 'cw_createlogin';
      cw_selectchar: str := 'cw_selectchar';
      cw_main: str := 'cw_main';
      cw_agree: str := 'cw_agree';
    else str := 'ERROR';
    end;
    result := result + 'FClientWindow：' + str + #13#10;

  end;

end;

function TConnectorList.GetBuffList: string;
var
  i: integer;
  Connector: TConnector;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    result := result + '账号：' + Connector.LoginData.PrimaryKey
      + '(SEND:' + inttostr(Connector.PacketSender.BufferCount) + ')'
      + '(RECE:' + inttostr(Connector.PacketReceiver.ReceiveBufferCount) + ')'
      + #13#10;
  end;
end;

procedure TConnectorList.BalanceMessageProcess(aPacket: PTPacketData);
var
  pp: pTExequaturdata;
begin
  case aPacket.RequestMsg of
    BM_Exequatur:
      begin
        pp := @aPacket.data;
        ExequaturList.add2(pp);
        frmMain.AddLog(format('验证信息 [%s %s %d]', [pp.rname, pp.rpassword, pp.rid]));
      end;
    BM_GETBANLIST: //2015.11.26 在水一方
      begin
        if GameSender <> nil then
        begin
          GameSender.PutPacket(0, GM_GETBANLIST, 0, nil, 0);
        end;
      end;

  end;
end;

procedure TConnectorList.PaidMessageProcess(aPacket: PTPacketData);
var
  Connector: TConnector;
begin
  Connector := ConnectIDKey.Select(aPacket^.RequestID);
  if Connector <> nil then
  begin
    Connector.PaidMessageProcess(aPacket);
  end;
    // frmMain.AddLog ('TConnectorList.PaidMessageProcess failed');
end;

function TConnectorList.Update(CurTick: Cardinal): Boolean;
var
  i, nIndex, icount: Integer;
  Connector: TConnector;
  pd: PTConnectData;
  StartPos: Word;
begin
  ExequaturList.UPDATE(CurTick);
  if DeleteList.Count > 0 then
  begin
    for i := 0 to DeleteList.Count - 1 do
    begin
      pd := DeleteList.Items[i];
      Connector := SocketKey.Select(pd^.SocketInt);
      if Connector <> nil then
      begin
        SocketKey.Delete(Connector.SocketInt);
        ConnectIDKey.Delete(Connector.ConnectID);


        nIndex := DataList.IndexOf(Connector);
        if nIndex <> -1 then DataList.Delete(nIndex);
        Connector.Free;
      end;
      Dispose(pd);
    end;
    DeleteList.Clear;
  end;



  iCount := userconnectorcount;
//  if DataList.Count < iCount then
//  begin
//    iCount := DataList.Count;
//    CurProcessPos := 0;
//  end;
//
//  for i := 0 to iCount - 1 do
//  begin
//    if DataList.Count = 0 then break;
//    if CurProcessPos >= DataList.Count then CurProcessPos := 0;
//    Connector := DataList.Items[CurProcessPos];
//    Connector.Update(CurTick);
//    Inc(CurProcessPos);
//  end;

  if DataList.Count > 0 then begin
    ProcessCount := DataList.Count * 4 div 100;
    if ProcessCount < iCount then ProcessCount := iCount;

    StartPos := CurProcessPos;

    for i := 0 to ProcessCount - 1 do begin
      if CurProcessPos >= DataList.Count then CurProcessPos := 0;
      Connector := DataList.Items[CurProcessPos];
      Connector.Update(CurTick);
      Inc(CurProcessPos);
      if CurProcessPos >= DataList.Count then CurProcessPos := 0;
      if CurProcessPos = StartPos then break;
    end;
  end;
  Result := true;
end;

function TConnectorList.ClearNoPlayer: integer;
var
  i, nIndex, n: integer;
  Connector: TConnector;
begin
  n := 0;
  for i := datalist.count - 1 downto 0 do
  begin
    Connector := DataList.Items[i];
    if Connector <> nil then
    begin
      if Connector.GameStatus = gs_playing then Continue;

      SocketKey.Delete(Connector.SocketInt);
      ConnectIDKey.Delete(Connector.ConnectID);

      nIndex := DataList.IndexOf(Connector);
      if nIndex <> -1 then DataList.Delete(nIndex);
      Connector.Free;
      Inc(n);
    end;
  end;
  Result := n;
end;

function TConnectorList.ClearDieConnect: integer; //2016.07.22 在水一方
var
  i, nIndex, n: integer;
  Connector: TConnector;
begin
  n := 0;
  for i := datalist.count - 1 downto 0 do
  begin
    Connector := DataList.Items[i];
    if Connector <> nil then
    begin
      if Connector.GameStatus = gs_playing then Continue;
      if Now - Connector.CreateDatetime < 2 * (1 / 24 / 60) then Continue; //2分钟

      SocketKey.Delete(Connector.SocketInt);
      ConnectIDKey.Delete(Connector.ConnectID);

      nIndex := DataList.IndexOf(Connector);
      if nIndex <> -1 then DataList.Delete(nIndex);
      Connector.Free;
      Inc(n);
    end;
  end;
  Result := n;
end;

procedure TConnectorList.SetWriteAllow(aSocket: TCustomWinSocket);
var
  Connector: TConnector;
begin
  Connector := SocketKey.Select(Integer(aSocket));
  if Connector <> nil then
  begin
    Connector.SetWriteAllow;
    exit;
  end;
    // frmMain.AddLog ('TConnectorList.SetWriteAllow failed');
end;


end.

