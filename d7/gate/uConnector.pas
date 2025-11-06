unit uConnector;

interface

uses
   Windows, Classes, SysUtils, ScktComp, mmSystem, uBuffer, uLGRecordDef,
   uDBRecordDef, uKeyClass, uPackets, AnsStringCls, DefType, AUtil32, uCharCheck;

// add by minds 050915
const
   PacketCountBufferSize = 8;
type
   TCountBuffer = packed record
      Count: integer;
      Tick: LongWord;
   end;

type
   TClientWindow = ( cw_none, cw_login, cw_createlogin, cw_selectchar, cw_main, cw_agree );
   TGameStatus = ( gs_none, gs_login, gs_agree, gs_selectchar, gs_gotogame, gs_playing, gs_createchar, gs_deletechar, gs_createlogin, gs_changepass );

   TConnectData = record
      SocketInt : Integer;
   end;
   PTConnectData = ^TConnectData;

   TConnector = class
   private
      ConnectID : Integer;

      SocketInt : Integer;
      Socket : TCustomWinSocket;

      PacketSender : TPacketSender;
      PacketReceiver : TPacketReceiver;

      FGameStatus : TGameStatus;
      FClientWindow : TClientWindow;

      FLastMessage : Byte;
      RequestTime : LongWord;

      CreateTime : LongWord;

      LoginData : TLGRecord;
      CharNameList : array [0..5-1] of String;
      
      VerNo : Byte;
      LoginID, LoginPW, LoginCompany : String;
      PlayChar, UseChar, UseLand : String;
      IpAddr : String;
      FPaidData : TPaidData2;

//      FAutoCount : Integer;
      // add by minds 050915
      PacketCount: array[0..PacketCountBufferSize-1] of TCountBuffer;
      PCIndex: integer;
      function GetPacketCountOnCycle: integer;
      ///

      procedure ShowWindow (aKey : TClientWindow; boShow : Boolean);
      procedure SendStatusMessage (aKey: Byte; aStr : String);
      function GetCharInfo : String;
      function FindCharatLoginList (aName : String):Boolean;
   protected
   public
      constructor Create (aSocket : TCustomWinSocket; aConnectID : Integer);
      destructor Destroy; override;

      function Update (CurTick : LongWord) : Boolean;
      function MessageProcess (aComData : PTWordComData) : Boolean;

      procedure AddReceiveData (aData : PChar; aCount : Integer);
      procedure AddSendData (aData : PChar; aCount : Integer);
      procedure AddSendDataDirect (aData : PChar; aCount : Integer);
      procedure AddSendDataNoTouch (aData : PChar; aCount : Integer);

      procedure GameMessageProcess (aPacket : PTPacketData);
      procedure DBMessageProcess (aPacket : PTPacketData);
      procedure LoginMessageProcess (aPacket : PTPacketData);
      procedure PaidMessageProcess (aPacket : PTPacketData);

      procedure SetWriteAllow;

      property GameStatus : TGameStatus read FGameStatus;
      property PlayCharName : String read PlayChar;
   end;

   TConnectorList = class
   private
      UniqueID : Integer;
      UniqueValue : Integer;

      FPlayingUserCount : Integer;
      FLogingUserCount : Integer;

      SocketKey, ConnectIDKey : TIntegerKeyClass;
      
      DataList : TList;
      DeleteList : TList;

      CurProcessPos, ProcessCount : Word;

      function GetCount : Integer;
   protected
   public
      constructor Create;
      destructor Destroy; override;

      procedure Clear;

      function Update (CurTick : LongWord) : Boolean;

      function CreateConnect (aSocket : TCustomWinSocket) : Boolean;
      function DeleteConnect (aSocket : TCustomWinSocket) : String;

      procedure AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aCount : Integer);

      procedure GameMessageProcess (aPacket : PTPacketData);
      procedure DBMessageProcess (aPacket : PTPacketData);
      procedure LoginMessageProcess (aPacket : PTPacketData);
      procedure PaidMessageProcess (aPacket : PTPacketData);

      procedure SetWriteAllow (aSocket : TCustomWinSocket);
      procedure ReCalc;

      property Count : Integer read GetCount;

      property PlayingUserCount : Integer read FPlayingUserCount write FPlayingUserCount;
      property LogingUserCount : Integer read FLogingUserCount write FLogingUserCount;
      property AutoConnectID : Integer read UniqueID;
      property GateUniqueValue : Integer read UniqueValue write UniqueValue;
   end;

var
   ConnectorList : TConnectorList;

implementation

uses
   FMain, uUtil;

// TConnector
constructor TConnector.Create (aSocket : TCustomWinSocket; aConnectID : Integer);
begin
   ConnectID := aConnectID;

   SocketInt := Integer (aSocket);
   
   Socket := aSocket;

   PacketSender := TPacketSender.Create ('Sender', 65535, aSocket, true, true);
   PacketReceiver := TPacketReceiver.Create ('Receiver', 65535, true);

   FGameStatus := gs_none;
   FClientWindow := cw_none;

   FLastMessage := 0;
   RequestTime := 0;
   CreateTime := timeGetTime;

   FillChar (LoginData, SizeOf (TLGRecord), 0);

   LoginID := '';
   LoginPW := '';
   LoginCompany := '';
   PlayChar := '';
   UseChar := '';
   UseLand := '';
   IpAddr := aSocket.RemoteAddress;
   VerNo := 0;

//   FAutoCount := 0;

   FillChar (FPaidData, SizeOf (TPaidData2), 0);
   FPaidData.rPaidType := pt_none;

   FillChar(PacketCount, sizeof(PacketCount), 0);
   PCIndex := 0;
end;

destructor TConnector.Destroy;
var
   buffer : array[0..20 - 1] of byte;
begin
   if GameStatus = gs_playing then begin
      FillChar (buffer, SizeOf (buffer), 0);
      StrPCopy (@buffer, PlayChar);
      if GameSender <> nil then begin
         GameSender.PutPacket (ConnectID, GM_DISCONNECT, 0, @buffer, SizeOf (buffer));
      end;
      {
      if DBSender <> nil then begin
         DBSender.PutPacket (ConnectID, DB_UNLOCK, 0, @buffer, SizeOf (buffer));
      end;
      }
   end;

   PacketReceiver.Free;
   PacketSender.Free;

   inherited Destroy;
end;

procedure TConnector.SetWriteAllow;
begin
   PacketSender.WriteAllow := true;
end;

procedure TConnector.AddReceiveData (aData : PChar; aCount : Integer);
begin
   PacketReceiver.PutData (aData, aCount);
end;

procedure TConnector.AddSendData (aData : PChar; aCount : Integer);
var
   ComData : TWordComData;
begin
   ComData.Size := aCount;
   Move (aData^, ComData.Data, aCount);
   PacketSender.PutPacket (0, 0, 0, @ComData, ComData.Size + SizeOf (Word));
end;

procedure TConnector.AddSendDataDirect (aData : PChar; aCount : Integer);
begin
   PacketSender.PutPacket (0, 0, 0, aData, aCount);
end;

procedure TConnector.AddSendDataNoTouch (aData : PChar; aCount : Integer);
begin
   PacketSender.PutPacket (0, 0, 0, aData, aCount);
end;

procedure TConnector.SendStatusMessage (aKey: Byte; aStr : String);
var
   cnt : Integer;
   sMessage : TSMessage;
begin
   sMessage.rmsg := SM_MESSAGE;
   sMessage.rkey := aKey;
   SetWordString (sMessage.rWordString, aStr);
   cnt := Sizeof(sMessage) - Sizeof(TWordString) + sizeofwordstring(sMessage.rWordString);
   
   AddSendData (@sMessage, cnt);
end;

procedure TConnector.ShowWindow (aKey : TClientWindow; boShow : Boolean);
var
   sWindow : TSWindow;
begin
   if boShow = true then begin
      FClientWindow := aKey;
   end;
   sWindow.rmsg := SM_WINDOW;
   sWindow.rwindow := Byte (aKey);
   sWindow.rboShow := boShow;
   AddSendData (@sWindow, sizeof(sWindow));
end;

function TConnector.GetPacketCountOnCycle: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to PacketCountBufferSize-1 do
  Result := Result + PacketCount[i].Count;
end;

function TConnector.Update (CurTick : LongWord) : Boolean;
var
   PacketData : TPacketData;
   ComData : TWordComData;
   nSize : Integer;
   i, nPacketCount: integer;
   CheckTime: LongWord;
begin
   if CreateTime = 0 then exit;

   try
      PacketSender.Update;
      PacketReceiver.Update;

      // add by minds 0509015
      CheckTime := CurTick - PacketCount[PCIndex].Tick;
      PacketCount[PCIndex].Count := PacketReceiver.Count;
      PacketCount[PCIndex].Tick := CurTick;
      PCIndex := (PCIndex + 1) mod PacketCountBufferSize;

      if CheckTime >= 1000 then begin
        nPacketCount := (GetPacketCountOnCycle * 1000) div CheckTime;
        if nPacketCount > LimitPacketCount then begin
          CreateTime := 0;
          frmMain.WriteLogInfo(format('!!!Exceed Packet Limit: ID:%s, Char:%s, IP:%s, Packets/Sec:%d', [LoginID, PlayCharName, IpAddr, nPacketCount]));
          Socket.Close;
          exit;
        end;
      end;
      //...

      while PacketReceiver.Count > 0 do begin
         if PacketReceiver.GetPacket (@PacketData) = false then break;

         {
         if PacketData.RequestID <> FAutoCount then begin
            Socket.Close;
            exit;
         end;
         Inc (FAutoCount);
         if FAutoCount >= 200000000 then FAutoCount := 0;
         }
         nSize := PacketData.PacketSize - SizeOf (Word) - SizeOf (Integer) - SizeOf (Byte) - SizeOf (Byte);
         Move (PacketData.Data, ComData, nSize);
         if FGameStatus = gs_playing then begin
            if GameSender <> nil then begin
               GameSender.PutPacket (ConnectID, GM_SENDGAMEDATA, 0, @ComData.Data, ComData.Size);
            end;
         end else begin
            MessageProcess (@ComData);
         end;
      end;
   except
      CreateTime := 0;
      frmMain.AddLog ('exception : ' + IpAddr);
      Socket.Close;
      exit;
   end;

   if (FGameStatus <> gs_none) and (FGameStatus <> gs_playing) then begin
      if RequestTime + 60000 <= CurTick then begin
         RequestTime := 0;
         FGameStatus := gs_none;
         Case FClientWindow of
            cw_login :
               begin
                  SendStatusMessage (MESSAGE_LOGIN, Conv('[TIMEOUT] 다시 시도해 주세요'));
               end;
            cw_selectchar :
               begin
                  SendStatusMessage (MESSAGE_SELCHAR, Conv('[TIMEOUT] 다시 시도해 주세요'));
               end;
            cw_createlogin :
               begin
                  ShowWindow (cw_createlogin, false);
                  ShowWindow (cw_login, true);
                  SendStatusMessage (MESSAGE_LOGIN, Conv('[TIMEOUT] 다시 시도해 주세요'));
               end;
         end;
      end;
   end;

   if FGameStatus <> gs_playing then begin
      if (CreateTime > 0) and (CurTick >= CreateTime + 1000 * 60 * 5) then begin
         PacketSender.Update;
         // ConnectorList.DeleteConnect (Socket);
         CreateTime := 0;
         frmMain.AddLog ('login timeout : ' + IpAddr);
         Socket.Close;
      end;
   end;

   Result := true;
end;

function TConnector.GetCharInfo : String;
var
   i : Integer;
   str : String;
begin
   str := '';
   for i := 0 to 5 - 1 do begin
{
      if LoginData.CharInfo[i].CharName[0] <> 0 then begin
         str := str + StrPas (@LoginData.CharInfo[i].CharName);
         str := str + ':';
         str := str + StrPas (@LoginData.CharInfo[i].ServerName);
      end;
}
      CharNameList[i] := '';
      if LoginData.CharInfo[i].CharName <> '' then begin
         Str := Str + LoginData.CharInfo [i].CharName;
         str := str + ':';
         Str := Str + LoginData.CharInfo [i].ServerName;
         CharNameList[i] := LoginData.CharInfo [i].CharName + ':' + LoginData.CharInfo [i].ServerName;
      end;

      if i < 5 - 1 then str := str + ',';
      // str := str + ',';
   end;

   Result := str;
end;

function TConnector.FindCharatLoginList (aName : String):Boolean;
var
   i : integer;
begin
   Result := false;

   for i := 0 to 5 - 1 do begin
      if CharNameList[i] = aName then begin
         Result := true;
         exit;
      end;
   end;
end;

procedure TConnector.PaidMessageProcess (aPacket : PTPacketData);
var
   pPaidData : PTPaidData2;
begin
   Case aPacket^.RequestMsg of
      PM_CHECKPAID :
         begin
            if aPacket^.ResultCode = 0 then begin
               FGameStatus := gs_none;
               exit;
            end;

            pPaidData := @aPacket^.Data;
            if pPaidData^.rLoginId <> LoginID then begin
               SendStatusMessage (MESSAGE_LOGIN, Conv('유료정보 오류입니다'));
               FGameStatus := gs_none;
               exit;
            end;

            FPaidData.rLoginID := pPaidData^.rLoginID;
            FPaidData.rIPAddr := pPaidData^.rIPAddr;
            FPaidData.rEndDate := pPaidData^.rEndDate;
            FPaidData.rPayMode := pPaidData^.rPayMode;
            FPaidData.rPayNo := pPaidData^.rPayNo;
            if FPaidDAta.rPaidType = pt_none then begin
               if pPaidData^.rPayMode = '000' then begin // 무료
                  FPaidData.rPaidType := pt_invalidate;
                  SendStatusMessage (MESSAGE_SELCHAR, Conv('무료 사용으로 접속되었습니다'));
               end else if pPaidData^.rPayMode = '001' then begin // 3일 무료계정
                  FPaidData.rPaidType := pt_test;
                  SendStatusMessage (MESSAGE_SELCHAR, Conv('체험기간 사용자로 접속했습니다'));
               end else if pPaidData^.rPayMode = '100' then begin // ID 정액
                  FPaidData.rPaidType := pt_namemoney;
                  SendStatusMessage (MESSAGE_SELCHAR, format (Conv('%s %s 까지 사용하실 수 있습니다'), [DateToStr (pPaidData^.rEndDate), TimeToStr (pPaidData^.rEndDate)]));
               end else if pPaidData^.rPayMode = '200' then begin // IP 정액
                  FPaidData.rPaidType := pt_ipmoney;
                  SendStatusMessage (MESSAGE_SELCHAR, format (Conv('%s %s 까지 사용하실 수 있습니다'), [DateToStr (pPaidData^.rEndDate), TimeToStr (pPaidData^.rEndDate)]));
               end else if pPaidData^.rPayMode = '400' then begin // ID 정량
                  FPaidData.rPaidType := pt_nametime;
                  SendStatusMessage (MESSAGE_SELCHAR, format (Conv('%s %s 까지 사용하실 수 있습니다'), [DateToStr (pPaidData^.rEndDate), TimeToStr (pPaidData^.rEndDate)]));
               end;
            end else begin
               if FPaidData.rPaidType = pt_validate then begin
                  SendStatusMessage (MESSAGE_SELCHAR, Conv('접속되었습니다'));
               end else if FPaidData.rPaidType = pt_timepay then begin
                  SendStatusMessage (MESSAGE_SELCHAR, Conv('종량제 사용자로 접속했습니다'));
               end;
            end;

            FGameStatus := gs_none;
         end;
   end;
end;

procedure TConnector.GameMessageProcess (aPacket : PTPacketData);
var
   iCnt : Integer;
   pDBRecord : PTDBRecord;
   buffer : array [0..20 - 1] of byte;
begin
   Case aPacket^.RequestMsg of
      GM_CONNECT :
         begin
            FGameStatus := gs_playing;
            ShowWindow (cw_selectchar, FALSE);
            ShowWindow (cw_main, TRUE);

            StrPCopy (@buffer, PlayChar);
            if DBSender <> nil then begin
               DBSender.PutPacket (ConnectID, DB_LOCK, 0, @buffer, SizeOf (buffer));
            end;
         end;
      GM_DISCONNECT :
         begin
            frmMain.AddLog (Conv('접속해제 : ') + PlayChar);
            Socket.Close;
         end;
      GM_SENDUSERDATA :
         begin
            pDBRecord := @aPacket^.Data;
            if DBSender <> nil then begin
               DBSender.PutPacket (ConnectID, DB_UPDATE, 0, @aPacket.Data, SizeOf (TDBRecord));
            end;
         end;
      GM_SENDGAMEDATA :
         begin
            iCnt := aPacket^.PacketSize - (SizeOf (Word) + SizeOf (Integer) + SizeOf (Byte) * 2);
            AddSendDataDirect (@aPacket^.Data, iCnt);
         end;
      GM_DUPLICATE :
      	begin
            SendStatusMessage (MESSAGE_SELCHAR, Conv('접속해제 되었습니다'));
            PlayChar := ''; UseChar := ''; UseLand := '';
            FGameStatus := gs_none;
            CreateTime := timeGetTime - (1000 * 60 * 5);
         end;
      GM_SENDALL :
      	begin
         	if FGameStatus = gs_playing then begin
               iCnt := aPacket^.PacketSize - (SizeOf (Word) + SizeOf (Integer) + SizeOf (Byte) * 2);
               AddSendDataNoTouch (@aPacket^.Data, iCnt);
            end;
         end;
   end;
end;

procedure TConnector.DBMessageProcess (aPacket : PTPacketData);
var
   i, cnt : Integer;
   str : String;
   ws : TWordInfoString;
   pDBRecord : PTDBRecord;
   LGRecord : TLGRecord;
   CurDate, LastDate : TDateTime;
begin
   Case aPacket^.RequestMsg of
      DB_INSERT :
         begin
            if aPacket^.ResultCode = DB_OK then begin
               if FGameStatus = gs_createchar then begin
                  pDBRecord := @aPacket^.Data;

                  Move (LoginData, LGRecord, SizeOf (TLGRecord));
                  for i := 0 to 5 - 1 do begin
//                     if LGRecord.CharInfo[i].CharName[0] = 0 then begin
//                        StrCopy (@LGRecord.CharInfo[i].CharName, @pDBRecord^.PrimaryKey);
//                        StrPCopy (@LGRecord.CharInfo[i].ServerName, ServerName);
                     if LGRecord.CharInfo [i].CharName = '' then begin
                        LGRecord.CharInfo[i].CharName := StrPas (@pDBRecord^.PrimaryKey);
                        LGRecord.CharInfo[i].ServerName := ServerName;
                        break;
                     end;
                  end;
                  ws.rmsg := SM_CHARINFO;
                  str := GetCharInfo;
                  SetWordString (ws.rwordstring, str);
                  cnt := sizeof(ws) - sizeof(TWordString) + SizeofWordString (ws.rWordstring);
                  AddSendData (@ws, cnt);

                  if LoginSender <> nil then begin
                     LoginSender.PutPacket (ConnectID, LG_UPDATE, 0, @LGRecord, SizeOf (TLGRecord));
                  end;
               end;
            end else begin
               Case aPacket^.ResultCode of
                  DB_ERR_DUPLICATE :
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('이미 같은 이름의 캐릭터가 있습니다'));
                     end;
                  DB_ERR_NOTENOUGHSPACE :
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('공간이 부족해 캐릭터를 만들 수 없습니다'));
                     end;
                  DB_ERR_INVALIDDATA :
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('올바른 캐릭터 명이 아닙니다'));
                     end;
                  DB_ERR_IO :
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('I/O 오류가 발생했습니다'));
                     end;
                  Else
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('DB Server 내부 오류입니다'));
                     end;
               end;
               FGameStatus := gs_none;
            end;
         end;
      DB_SELECT :
         begin
            if aPacket^.ResultCode = DB_OK then begin
               if FGameStatus = gs_selectchar then begin
                  pDBRecord := @aPacket^.Data;

                  if TestStr (@pDBRecord^.PrimaryKey, 20) = false then begin
                     pDBRecord^.PrimaryKey[0] := 0;
                  end;
                  if TestStr (@pDBRecord^.PrimaryKey, 20) = false then begin
                     pDBRecord^.MasterName[0] := 0;
                  end;

                  if StrPas (@pDBRecord^.PrimaryKey) <> UseChar then begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('DB 서버의 내부오류입니다'));
                     UseChar := ''; UseLand := '';
                     FGameStatus := gs_none;
                     exit;
                  end;

                  if StrPas (@pDBRecord^.MasterName) <> LoginID then begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('본인의 캐릭터가 아닙니다'));
                     UseChar := ''; UseLand := '';
                     FGameStatus := gs_none;
                     exit;
                  end;

                  if frmMain.sckGameConnect.Active = false then begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('죄송합니다. 잠시후 다시 연결해 주세요'));
                     UseChar := ''; UseLand := '';
                     FGameStatus := gs_none;
                     exit;
                  end;

                  PlayChar := UseChar;

                  frmMain.AddLog (format (Conv('캐릭명 : %s'), [StrPas (@pDBRecord^.PrimaryKey)]));

                  Move (FPaidData, pDBRecord^.Dummy, SizeOf (TPaidData2));
                  if GameSender <> nil then begin
                     GameSender.PutPacket (ConnectID, GM_CONNECT, 0, @aPacket^.Data, SizeOf (TDBRecord));
                  end;

                  FGameStatus := gs_gotogame;
               end else if FGameStatus = gs_deletechar then begin
                  pDBRecord := @aPacket^.Data;

                  if StrPas (@pDBRecord^.PrimaryKey) <> UseChar then begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('DB 서버의 내부오류입니다'));
                     UseChar := ''; UseLand := '';
                     FGameStatus := gs_none;
                     exit;
                  end;
                  if StrPas (@pDBRecord^.MasterName) <> LoginID then begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('본인의 캐릭터가 아닙니다'));
                     UseChar := ''; UseLand := '';
                     FGameStatus := gs_none;
                     exit;
                  end;

                  try
                     CurDate := Date - 7;
                     LastDate := StrToDate (StrPas (@pDBRecord^.LastDate));
                     if LastDate > CurDate then begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('최근 7일 이전 접속 캐릭터는 지울 수 없습니다'));
                        FGameStatus := gs_none;
                        exit;
                     end;
                  except
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('최근 7일 이전 접속 캐릭터는 지울 수 없습니다'));
                     FGameStatus := gs_none;
                     exit;
                  end;

                  Move (LoginData, LGRecord, SizeOf (TLGRecord));
                  for i := 0 to 5 - 1 do begin
//                     if StrPas (@LGRecord.CharInfo[i].CharName) = UseChar then begin
//                        if StrPas (@LGRecord.CharInfo[i].ServerName) = UseLand then begin
                     if LGRecord.CharInfo [i].CharName = UseChar then begin
                        if LGRecord.CharInfo [i].ServerName = UseLand then begin
                           FillChar (LGRecord.CharInfo[i], SizeOf (TCharInfo), 0);
                           break;
                        end;
                     end;
                  end;

                  if LoginSender <> nil then begin
                     LoginSender.PutPacket (ConnectID, LG_UPDATE, 0, @LGRecord, SizeOf (TLGRecord));
                  end;
               end;
            end else begin
               Case aPacket^.ResultCode of
                  DB_ERR_NOTFOUND :
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('선택한 캐릭터를 찾을 수 없습니다'));
                     end;
                  DB_ERR_INVALIDDATA :
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('올바른 캐릭터 명이 아닙니다'));
                     end;
                  DB_ERR_IO :
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('I/O 오류가 발생했습니다'));
                     end;
                  Else
                     begin
                        SendStatusMessage (MESSAGE_SELCHAR, Conv('DB Server 내부 오류입니다'));
                     end;
               end;
               FGameStatus := gs_none;
            end;
         end;
      DB_UPDATE :
         begin
         end;
      Else
         begin
            // frmMain.AddLog (format ('%d Packet was received', [aPacket^.RequestMsg]));
         end;
   end;
end;

procedure TConnector.LoginMessageProcess (aPacket : PTPacketData);
var
   cnt : Integer;
   ws : TWordInfoString;
   str : String;
   PaidPacket : TPacketData;
   pPaidData : PTPaidData2;
begin
   Case aPacket^.RequestMsg of
      LG_INSERT :
         begin
            if aPacket^.ResultCode = DB_OK then begin
               ShowWindow (cw_createlogin, FALSE);
               ShowWindow (cw_login, TRUE);
               SendStatusMessage (MESSAGE_LOGIN, Conv('지금 만든 접속이름으로 접속할 수 있습니다'));
            end else begin
               Case aPacket^.ResultCode of
                  DB_ERR_DUPLICATE :
                     begin
                        SendStatusMessage (MESSAGE_CREATELOGIN, Conv('이미 존재하는 접속이름입니다'));
                     end;
                  Else
                     begin
                        SendStatusMessage (MESSAGE_CREATELOGIN, Conv('로그인 서버의 내부오류입니다'));
                     end;
               end;
            end;
            FGameStatus := gs_none;
         end;
      LG_SELECT :
         begin
            if aPacket^.ResultCode = DB_OK then begin
               if FGameStatus = gs_login then begin
                  Move (aPacket^.Data, LoginData, SizeOf (TLGRecord));

                  if LoginData.PrimaryKey <> LoginID then begin
                     SendStatusMessage (MESSAGE_LOGIN, format (Conv('로그인서버의 내부오류입니다'), [ServerName]));
                     LoginID := ''; LoginPW := '';
                     FGameStatus := gs_none;
                     exit;
                  end;
                  if LoginData.PassWord <> LoginPW then begin
                     SendStatusMessage (MESSAGE_LOGIN, format (Conv('비밀번호가 올바르지 않습니다'), [ServerName]));
                     LoginID := ''; LoginPW := '';
                     FGameStatus := gs_none;
                     exit;
                  end;

                  ShowWindow (cw_login, FALSE);
                  ShowWindow (cw_selectchar, TRUE);

                  LoginData.LastDate := DateToStr (Date);
                  LoginData.IpAddr := IpAddr;

                  if LoginSender <> nil then begin
                     LoginSender.PutPacket (ConnectID, LG_UPDATE, 0, @LoginData, SizeOf (TLGRecord));
                  end;

                  ws.rmsg := SM_CHARINFO;
                  str := GetCharInfo;
                  SetWordString (ws.rwordstring, str);
                  cnt := sizeof(ws) - sizeof(TWordString) + SizeofWordString (ws.rWordstring);
                  AddSendData (@ws, cnt);

                  FGameStatus := gs_none;

                  if (PaidSender = nil) or (boCheckPaidInfo = false) then begin
                     FPaidData.rPaidType := pt_validate;
                  end;

                  FPaidData.rLoginID := LoginID;
                  FPaidData.rIpAddr := IpAddr;
                  if FPaidData.rPaidType <> pt_none then begin
                     pPaidData := @PaidPacket;
                     pPaidData^.rLoginId := LoginID;
                     pPaidData^.rIpAddr := IpAddr;
                     pPaidData^.rEndDate := Now;
                     pPaidData^.rPayMode := '000';
                     pPaidData^.rPayNo := 0;
                     pPaidData^.rPaidType := pt_validate;
                     PaidMessageProcess (@PaidPacket);
                  end else begin
                     PaidSender.PutPacket (ConnectID, PM_CHECKPAID, 0, @FPaidData, SizeOf (TPaidData2));
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('유료정보를 확인중입니다'));
                  end;
               end;
            end else begin
               Case aPacket^.ResultCode of
                  DB_ERR_NOTFOUND :
                     begin
                        SendStatusMessage (MESSAGE_LOGIN, Conv('계정정보를 찾을 수 없습니다'));
                     end;
                  DB_ERR_INVALIDDATA :
                     begin
                        SendStatusMessage (MESSAGE_LOGIN, Conv('계정명이 올바르지 않습니다'));
                     end;
                  Else
                     begin
                        SendStatusMessage (MESSAGE_LOGIN, Conv('다시 입력해 주세요'));
                     end;
               end;
            end;
            FGameStatus := gs_none;
         end;
      LG_UPDATE :
         begin
            if aPacket^.ResultCode = DB_OK then begin
               Move (aPacket^.Data, LoginData, SizeOf (TLGRecord));
               Case FGameStatus of
                  gs_createchar : begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('캐릭터를 만들었습니다.'));

                     ws.rmsg := SM_CHARINFO;
                     str := GetCharInfo;
                     SetWordString (ws.rwordstring, str);
                     cnt := sizeof(ws) - sizeof(TWordString) + SizeofWordString (ws.rWordstring);
                     AddSendData (@ws, cnt);

                     FGameStatus := gs_none;
                  end;
                  gs_changepass : begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('비밀번호를 변경했습니다'));
                     FGameStatus := gs_none;
                  end;
                  gs_deletechar : begin
                     SendStatusMessage (MESSAGE_SELCHAR, Conv('캐릭터를 삭제했습니다'));

                     ws.rmsg := SM_CHARINFO;
                     str := GetCharInfo;
                     SetWordString (ws.rwordstring, str);
                     cnt := sizeof(ws) - sizeof(TWordString) + SizeofWordString (ws.rWordstring);
                     AddSendData (@ws, cnt);

                     FGameStatus := gs_none;
                  end;
               end;
            end else begin
               Case aPacket^.ResultCode of
                  DB_ERR_NOTFOUND :
                     begin
                        SendStatusMessage (MESSAGE_LOGIN, Conv('계정정보를 찾을 수 없습니다'));
                     end;
               end;
               FGameStatus := gs_none;
            end;
         end;
      Else
         begin
            // frmMain.AddLog (format ('%d Packet was received', [aPacket^.RequestMsg]));
         end;
   end;
end;

function TConnector.MessageProcess (aComData : PTWordComData) : Boolean;
var
   i : Integer;
   msg : PByte;
   sKey : TCKey;
//   pcKey : PTCKey;
   pcVer : PTCVer;
//   pcCreateIdPass : PTCCreateIdPass;
   pcCreateIdPass2 : PTCCreateIdPass2;
   pcCreateIdPass3 : PTCCreateIdPass3;
   pcIdPass : PTCIdPass;
   pcCreateChar : PTCCreateChar;
   pcDeleteChar : PTCDeleteChar;
   pcSelectChar : PTCSelectChar;
   pcChangePassword : PTCChangePassword;

   LGRecord : TLGRecord;
   DBRecord : TDBRecord;

   uStr : String;
   boFlag : Boolean;

   nYear, nMonth, nDay : Word;
   uid, upass, uname, unativenumber, umasterkey : String;
   uEmail, uPhone, uParentName, uParentNativeNumber : String;
   ucharname, uvillage, uservername : String;
   CharSet : String;

   pd : PTVillageData;
begin
   Result := true;

   msg := @aComData^.Data;

   if VerNo < PROGRAM_VERSION then begin
      if Msg^ = CM_VERSION then begin
         if FGameStatus <> gs_none then exit;

         pcVer := @aComData^.Data;
         if (pcVer^.rNation <> NATION_VERSION) or (pcVer^.rVer <> PROGRAM_VERSION) then begin
            sKey.rmsg := SM_CLOSE;
            sKey.rkey := 1;
            AddSendData (@sKey, SizeOf(skey));
         end else begin
            VerNo := pcVer^.rVer;
            FClientWindow := cw_login;
            SendStatusMessage (MESSAGE_LOGIN, '젯쌈냥묘');
         end;
      end else begin
         sKey.rmsg := SM_CLOSE;
         sKey.rkey := 1;
         AddSendData (@sKey, SizeOf(skey));
      end;
      exit;
   end;

   case msg^ of
      CM_VERSION :
         begin
            if FGameStatus <> gs_none then exit;

            pcVer := @aComData^.Data;
            if (pcVer^.rNation <> NATION_VERSION) or (pcVer^.rVer < PROGRAM_VERSION) then begin
               sKey.rmsg := SM_CLOSE;
               sKey.rkey := 1;
               AddSendData (@sKey, SizeOf(skey));
            end else begin
               VerNo := pcVer^.rVer;
               FClientWindow := cw_login;
               SendStatusMessage (MESSAGE_LOGIN, Conv('연결되었습니다'));
            end;
         end;
      CM_CREATEIDPASS :
         begin
            exit;
         end;
      CM_CREATEIDPASS2 :
         begin
            exit;
         end;
      CM_CREATEIDPASS3 :
         begin
            exit;
         end;
      CM_IDPASS :
         begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_login) then exit;

            if frmMain.sckLoginConnect.Socket.Connected = false then begin
               SendStatusMessage (MESSAGE_LOGIN, Conv('죄송합니다. 잠시후 다시 연결해 주세요'));
               exit;
            end;

            FGameStatus := gs_login;

            pcIdPass := @aComData^.data;
            pcIdPass^.rID [NAME_SIZE - 1] := 0;
            pcIdPass^.rPass [NAME_SIZE - 1] := 0;

            LoginID := Trim (StrPas (@pcIdPass^.rID));
            LoginPW := Trim (StrPas (@pcIdPass^.rPass));

            if (LoginID = '') or (LoginPW = '') then begin
               LoginID := '';
               LoginPW := '';
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_LOGIN, Conv('정확히 입력해 주세요'));
               exit;
            end;

            if (LimitUserCount > 0) and (LimitUserCount <= ConnectorList.Count) then begin
               if RemoteIPList.IndexOf (IpAddr) < 0 then begin
                  FGameStatus := gs_none;
                  LoginID := '';
                  LoginPW := '';
                  SendStatusMessage (MESSAGE_SELCHAR, Conv('접속인원이 초과되었습니다'));
                  exit;
               end;
            end;

            FillChar (LGRecord, SizeOf (TLGRecord), 0);
            LGRecord.PrimaryKey := LoginID;

            if LoginSender <> nil then begin
               LoginSender.PutPacket (ConnectID, LG_SELECT, 0, @LGRecord.PrimaryKey, SizeOf (LGRecord.PrimaryKey));
            end;
         end;
      CM_IDPASSAZACOM :
         begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_login) then exit;

            if frmMain.sckLoginConnect.Socket.Connected = false then begin
               SendStatusMessage (MESSAGE_LOGIN, Conv('죄송합니다. 잠시후 다시 연결해 주세요'));
               exit;
            end;

            FGameStatus := gs_login;

            FPaidData.rPaidType := pt_timepay;

            pcIdPass := @aComData^.data;
            pcIdPass^.rID [NAME_SIZE - 1] := 0;
            pcIdPass^.rPass [NAME_SIZE - 1] := 0;
            pcIdPass^.rCompany [NAME_SIZE - 1] := 0;

            LoginID := Trim (StrPas (@pcIdPass^.rID));
            LoginPW := Trim (StrPas (@pcIdPass^.rPass));
            LoginCompany := Trim (StrPas (@pcIdPass^.rCompany));

            FillChar (LGRecord, SizeOf (TLGRecord), 0);
            LGRecord.PrimaryKey := LoginID;

            if LoginSender <> nil then begin
               LoginSender.PutPacket (ConnectID, LG_SELECT, 0, @LGRecord.PrimaryKey, SizeOf (LGRecord.PrimaryKey));
            end;
         end;
      CM_CREATECHAR :
         begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_createchar) then exit;

            if FPaidData.rPaidType = pt_none then begin
               SendStatusMessage (MESSAGE_SELCHAR, Conv('유저정보를 얻고 있습니다. 잠시 기다려 주세요'));
               exit;
            end else if FPaidData.rPaidType = pt_invalidate then begin
               SendStatusMessage (MESSAGE_SELCHAR, Conv('무료 사용자는 만들 수 없습니다.'));
               exit;
            end;

            FGameStatus := gs_createchar;

            boFlag := false;
            for i := 0 to 5 - 1 do begin
               if LoginData.CharInfo[i].CharName = '' then begin
                  boFlag := true;
                  break;
               end;
            end;
            if boflag = false then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('더이상 캐릭터를 만들 수 없습니다'));
               exit;
            end;

            pcCreateChar := @aComData^.data;
            pcCreateChar^.rChar [NAME_SIZE - 1] := 0;
            pcCreateChar^.rVillage [NAME_SIZE - 1] := 0;
            pcCreateChar^.rServer [NAME_SIZE - 1] := 0;

            ucharname := Trim (StrPas (@pcCreateChar^.rChar));
            uvillage := Trim (StrPas (@pcCreateChar^.rVillage));
            uservername := Trim (StrPas (@pcCreateChar^.rServer));

            for i := 0 to RejectCharName.Count - 1 do begin
               if Pos (RejectCharName.Strings[i], ucharname) > 0 then begin
                  FGameStatus := gs_none;
                  SendStatusMessage (MESSAGE_SELCHAR, Conv('캐릭터명으로 사용할 수 없습니다'));
                  exit;
               end;
            end;

            if (Length (ucharname) > 12) or (Length (ucharname) = 0)then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('캐릭터명의 최대길이는 한글 6글자입니다'));
               exit;
            end;

            if (ucharname [1] >= '0') and (ucharname [1] <= '9') then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('캐릭터명의 처음에 숫자를 사용할 수 없습니다'));
               exit;
            end;
            if (ucharname [Length (ucharname)] >= '0') and (ucharname [Length (ucharname)] <= '9') then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('캐릭터명의 끝에 숫자를 사용할 수 없습니다'));
               exit;
            end;
            if (ucharname = '') or (Pos (',', ucharname) > 0) or (Pos (' ', ucharname) > 0) then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('캐릭터명으로 사용할 수 없습니다'));
               exit;
            end;
            if (CheckPascalString (ucharname) = 0) then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('특수문자 아이디는 만들 수 없습니다'));
               exit;
            end;

            FillChar (DBRecord, SizeOf (TDBRecord), 0);
            DecodeDate (Date, nYear, nMonth, nDay);
            with DBRecord do begin
               StrPCopy (@PrimaryKey, ucharname);
               StrPCopy (@MasterName, LoginData.PrimaryKey);
               StrPCopy (@LastDate, format ('%d-%d-%d', [nYear, nMonth, nDay]));
               StrPCopy (@CreateDate, format ('%d-%d-%d', [nYear, nMonth, nDay]));

               if pcCreateChar^.rSex = 0 then begin
                  StrPCopy (@Sex, Conv ('켕'));
                  StrPCopy (@WearItemArr [3].Name, INI_CLOTHES_COAT_MAN);
                  WearItemArr [3].Count := 1;
                  WearItemArr [3].Color := 1;
                  StrPCopy (@WearItemArr [4].Name, INI_CLOTHES_PANTS_MAN);
                  WearItemArr [4].Count := 1;
                  WearItemArr [4].Color := 1;
               end else begin
                  StrPCopy (@Sex, Conv ('큽'));
                  StrPCopy (@WearItemArr [3].Name, INI_CLOTHES_COAT_WOMAN);
                  WearItemArr [3].Count := 1;
                  WearItemArr [3].Color := 1;
                  StrPCopy (@WearItemArr [4].Name, INI_CLOTHES_PANTS_WOMAN);
                  WearItemArr [4].Count := 1;
                  WearItemArr [4].Color := 1;
               end;
               StrPCopy (@HaveItemArr [0].Name, INI_WEAPON_SWORD);
               HaveItemArr [0].Count := 1;
               HaveItemArr [0].Color := 1;
               StrPCopy (@HaveItemArr [1].Name, INI_WEAPON_KNIFE);
               HaveItemArr [1].Count := 1;
               HaveItemArr [1].Color := 1;
               StrPCopy (@HaveItemArr [2].Name, INI_WEAPON_SPEAR);
               HaveItemArr [2].Count := 1;
               HaveItemArr [2].Color := 1;
               StrPCopy (@HaveItemArr [3].Name, INI_WEAPON_AX);
               HaveItemArr [3].Count := 1;
               HaveItemArr [3].Color := 1;
               StrPCopy (@HaveItemArr [4].Name, INI_ETC_01);
               HaveItemArr [4].Count := 1;
               HaveItemArr [4].Color := 1;
               HaveItemArr [4].Durability := 1000;
               HaveItemArr [4].CurDurability := 1000;

               ServerID := 0;
               X := 534;
               Y := 574;

               for i := 0 to VillageList.Count - 1 do begin
                  pd := VillageList.Items [i];
//                  if pd^.Name = uvillage then begin
                     ServerID := pd^.ServerID;
                     X := pd^.X;
                     Y := pd^.Y;
                     break;
//                  end;
               end;
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
            if DBSender <> nil then begin
               DBSender.PutPacket (ConnectID, DB_CREATENEW, 0, @DBRecord, SizeOf (DBRecord));
            end;
         end;
      CM_DELETECHAR:
         begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_deletechar) then exit;

            if FPaidData.rPaidType = pt_none then begin
               SendStatusMessage (MESSAGE_SELCHAR, Conv('유저정보를 얻고 있습니다. 잠시 기다려 주세요'));
               exit;
            end else if FPaidData.rPaidType = pt_invalidate then begin
               SendStatusMessage (MESSAGE_SELCHAR, Conv('무료 사용자는 지울 수 없습니다.'));
               exit;
            end;

            FGameStatus := gs_deletechar;

            pcDeleteChar := @aComData^.Data;
            pcDeleteChar^.rChar [NAME_SIZE - 1] := 0;

            uStr := StrPas (@pcDeleteChar^.rChar);
            uStr := GetTokenStr (uStr, UseChar, ':');
            uStr := GetTokenStr (uStr, UseLand, ':');
            UseChar := Trim (UseChar);
            UseLand := Trim (UseLand);
            if UseChar = '' then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('삭제할 캐릭터를 선택해 주세요'));
               exit;
            end;
            if UseLand <> ServerName then begin
               FGameStatus := gs_none;
               SendStatusMessage (MESSAGE_SELCHAR, Conv('선택된 서버의 캐릭터가 아닙니다'));
               exit;
            end;

            FillChar (DBRecord, SizeOf (TDBRecord), 0);
            StrPCopy (@DBRecord.PrimaryKey, UseChar);

            if DBSender <> nil then begin
               DBSender.PutPacket (ConnectID, DB_SELECT, 0, @DBRecord, SizeOf (DBRecord.PrimaryKey));
            end;
         end;
      CM_SELECTCHAR:
         begin
            if (FGameStatus <> gs_none) or (FGameStatus = gs_selectchar) then exit;
            if frmMain.sckDBConnect.Socket.Connected = false then begin
               SendStatusMessage (MESSAGE_SELCHAR, Conv('죄송합니다. 잠시후 다시 연결해 주세요'));
               exit;
            end;

            if FPaidData.rPaidType = pt_none then begin
               SendStatusMessage (MESSAGE_SELCHAR, Conv('유저정보를 얻고 있습니다. 잠시 기다려 주세요'));
               exit;
            end else if FPaidData.rPaidType = pt_invalidate then begin
               SendStatusMessage (MESSAGE_SELCHAR, Conv('무료 사용자는 접속할 수 없습니다.'));
               exit;
            end;

            FGameStatus := gs_selectchar;

            pcSelectChar := @aComData.Data;
            pcSelectChar^.rChar [NAME_SIZE - 1] := 0;

            uStr := StrPas (@pcSelectChar^.rChar);
            uStr := GetTokenStr (uStr, UseChar, ':');
            uStr := GetTokenStr (uStr, UseLand, ':');

            UseChar := Trim (UseChar);
            UseLand := Trim (UseLand);
            CharSet := UseChar + ':' + UseLand;
            
            if (UseChar = '') or (UseLand = '') then begin
               FGameStatus := gs_none;
               UseChar := '';
               UseLand := '';
               exit;
            end;
            if UseLand <> ServerName then begin
               FGameStatus := gs_none;
               UseChar := '';
               UseLand := '';
               SendStatusMessage (MESSAGE_SELCHAR, Conv('현재 선택된 서버의 캐릭터가 아닙니다'));
               exit;
            end;

            if FindCharatLoginList(CharSet) = false then begin
               FGameStatus := gs_none;
               UseChar := '';
               UseLand := '';
               frmMain.WriteLogInfo (format ('!!!WARNING ID:%s,CharName:%s,IP Address : %s, this guest try to Hack ', [LoginID,ucharname,IpAddr]));
               exit;
            end;

            FillChar (DBRecord, SizeOf (TDBRecord), 0);
            StrPCopy (@DBRecord.PrimaryKey, UseChar);

            SendStatusMessage (MESSAGE_SELCHAR, format (Conv('캐릭터[%s]를 선택했습니다.'), [UseChar]));
            if DBSender <> nil then begin
               DBSender.PutPacket (ConnectID, DB_SELECT, 0, @DBRecord, SizeOf (DBRecord.PrimaryKey));
            end;
         end;
   end;

   FLastMessage := msg^;
   RequestTime := timeGetTime;
end;

// TConnectorList
constructor TConnectorList.Create;
begin
   UniqueID := 0;
   UniqueValue := -1;

   FPlayingUserCount := 0;
   FLogingUserCount := 0;

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

   inherited Destroy;
end;

procedure TConnectorList.Clear;
var
   i : Integer;
   Connector : TConnector;
   pd : PTConnectData;
begin
   FPlayingUserCount := 0;
   FLogingUserCount := 0;

   SocketKey.Clear;
   ConnectIDKey.Clear;
   
   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      Connector.Free;
   end;
   DataList.Clear;

   for i := 0 to DeleteList.Count - 1 do begin
      pd := DeleteList.Items [i];
      Dispose (pd);
   end;
   DeleteList.Clear;
end;

function TConnectorList.GetCount : Integer;
begin
   Result := DataList.Count;
end;


function TConnectorList.CreateConnect (aSocket : TCustomWinSocket) : Boolean;
var
   Connector : TConnector;
begin
   Result := false;

   if UniqueValue = -1 then exit;
   
   Connector := TConnector.Create (aSocket, UniqueID + UniqueValue);

   SocketKey.Insert (Connector.SocketInt, Connector);
   ConnectIDKey.Insert (Connector.ConnectID, Connector);
   DataList.Add (Connector);

   Inc (UniqueID, 10);
   Inc (FLogingUserCount);

   Result := true;
end;

function TConnectorList.DeleteConnect (aSocket :  TCustomWinSocket) : String;
var
   pd : PTConnectData;
   Connector : TConnector;
begin
   Result := '';

   Connector := SocketKey.Select (Integer(aSocket));
   if Connector <> nil then begin
      Result := Connector.PlayCharName;
   end;

   New (pd);
   pd^.SocketInt := Integer (aSocket);

   DeleteList.Add (pd);
end;

procedure TConnectorList.AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aCount : Integer);
var
   Connector : TConnector;
begin
   Connector := SocketKey.Select (Integer(aSocket));
   if Connector <> nil then begin
      Connector.AddReceiveData (aData, aCount);
      exit;
   end;
end;

procedure TConnectorList.GameMessageProcess (aPacket : PTPacketData);
var
	i : Integer;
   Connector : TConnector;
   pDBRecord : PTDBRecord;
begin
   if aPacket^.RequestMsg = GM_SENDALL then begin
   	// Reverse4Bit (PTComData (@aPacket^.Data));
      for i := 0 to DataList.Count - 1 do begin
      	Connector := DataList.Items [i];
         Connector.GameMessageProcess (aPacket);
      end;
      exit;
   end;
   if aPacket^.RequestMsg = GM_UNIQUEVALUE then begin
      UniqueValue := aPacket^.RequestID;
      frmMain.Caption := format ('Gate Server [%d]', [UniqueValue]);
      exit;
   end;
   if aPacket^.RequestMsg = GM_CONNECT then begin
      Inc (FPlayingUserCount);
      Dec (FLogingUserCount);
   end;

   Connector := ConnectIDKey.Select (aPacket^.RequestID);
   if Connector <> nil then begin
      Connector.GameMessageProcess (aPacket);
      exit;
   end;

   if aPacket^.RequestMsg = GM_SENDUSERDATA then begin
      pDBRecord := @aPacket^.Data;
      if DBSender <> nil then begin
         DBSender.PutPacket (0, DB_UPDATE, 0, @aPacket^.Data, SizeOf (TDBRecord));
      end;
      frmMain.AddLog (format ('closing user data (%s)', [StrPas (@pDBRecord^.PrimaryKey)]));
   end else begin
      if GameSender <> nil then begin
         GameSender.PutPacket (aPacket^.RequestID, GM_DISCONNECT, 0, nil, 0);
      end;
      // frmMain.AddLog ('TConnectorList.GameMessageProcess failed');
   end;
end;

procedure TConnectorList.DBMessageProcess (aPacket : PTPacketData);
var
   Connector : TConnector;
   RecordData : TDBRecord;
begin
   if aPacket^.RequestMsg <> DB_UPDATE then begin
      Connector := ConnectIDKey.Select (aPacket^.RequestID);
      if Connector <> nil then begin
         Connector.DBMessageProcess (aPacket);
      end;
      // frmMain.AddLog ('TConnectorList.DBMessageProcess failed');
   end else begin
      Case aPacket^.RequestMsg of
         DB_UPDATE :
            begin
               if aPacket^.ResultCode = DB_OK then begin
                  Move (aPacket^.Data, RecordData.PrimaryKey, SizeOf (RecordData.PrimaryKey));
                  frmMain.AddLog (format ('user data saved [%s]', [StrPas (@RecordData.PrimaryKey)]));
               end else begin
                  Move (aPacket^.Data, RecordData.PrimaryKey, SizeOf (RecordData.PrimaryKey));
                  frmMain.AddLog (format ('user data save failed [%s]', [StrPas (@RecordData.PrimaryKey)]));
               end;
            end;
      end;
   end;
end;

procedure TConnectorList.LoginMessageProcess (aPacket : PTPacketData);
var
   Connector : TConnector;
begin
   Connector := ConnectIDKey.Select (aPacket^.RequestID);
   if Connector <> nil then begin
      Connector.LoginMessageProcess (aPacket);
   end;
   // frmMain.AddLog ('TConnectorList.LoginMessageProcess failed');
end;

procedure TConnectorList.PaidMessageProcess (aPacket : PTPacketData);
var
   Connector : TConnector;
begin
   Connector := ConnectIDKey.Select (aPacket^.RequestID);
   if Connector <> nil then begin
      Connector.PaidMessageProcess (aPacket);
   end;
   // frmMain.AddLog ('TConnectorList.PaidMessageProcess failed');
end;

function TConnectorList.Update (CurTick : LongWord) : Boolean;
var
   i, nIndex : Integer;
   Connector : TConnector;
   pd : PTConnectData;
   StartPos : Word;
begin
   if DeleteList.Count > 0 then begin
      for i := 0 to DeleteList.Count - 1 do begin
         pd := DeleteList.Items [i];
         Connector := SocketKey.Select (pd^.SocketInt);
         if Connector <> nil then begin
            if Connector.GameStatus = gs_playing then begin
               Dec (FPlayingUserCount);
            end else begin
               Dec (FLogingUserCount);
            end;
            SocketKey.Delete (Connector.SocketInt);
            ConnectIDKey.Delete (Connector.ConnectID);

            Connector.Free;
            nIndex := DataList.IndexOf (Connector);
            if nIndex <> -1 then DataList.Delete (nIndex);
         end;
         Dispose (pd);
      end;
      DeleteList.Clear;
   end;

   if DataList.Count > 0 then begin
   	ProcessCount := DataList.Count * 4 div 100;
      if ProcessCount < 40 then ProcessCount := 40;
      StartPos := CurProcessPos;
      for i := 0 to ProcessCount - 1 do begin
         if CurProcessPos >= DataList.Count then CurProcessPos := 0;
         Connector := DataList.Items [CurProcessPos];
         Connector.Update (CurTick);
         Inc (CurProcessPos);
         if CurProcessPos >= DataList.Count then CurProcessPos := 0;
         if CurProcessPos = StartPos then break;
      end;
   end;

   Result := true;
end;

procedure TConnectorList.SetWriteAllow (aSocket : TCustomWinSocket);
var
   Connector : TConnector;
begin
   Connector := SocketKey.Select (Integer (aSocket));
   if Connector <> nil then begin
      Connector.SetWriteAllow;
      exit;
   end;
   // frmMain.AddLog ('TConnectorList.SetWriteAllow failed');
end;

procedure TConnectorList.ReCalc;
var
   Connector : TConnector;
   i : Integer;
begin
   FLogingUserCount := 0;
   FPlayingUserCount := 0;

   for i := 0 to DataList.Count - 1 do begin
      Connector := DataList.Items [i];
      if Connector.FGameStatus = gs_playing then begin
         Inc (FPlayingUserCount);
      end else begin
         Inc (FLogingUserCount);
      end;
   end;   
end;


end.
