unit uConnect;

interface

uses
   SysUtils, Classes, ScktComp, common, uPackets, BSCommon;

type
   TConnect = class
   private
      ConnectID : Integer;
      Socket : TCustomWinSocket;

      Sender : TPacketSender;
      Receiver : TPacketReceiver;
   public
      Constructor Create (aSocket: TCustomWinSocket; aConnectID : Integer);
      Destructor Destroy; override;

      procedure AddReceiveData (aData : PChar; aSize : Integer);
      procedure AddSendPacket (aID : Integer; aMsg : Word; aRetCode : Byte; aData : PChar; aSize : integer);

      procedure Update;

      procedure MessageProcess (aPacket : PTPacketData);

      procedure SetWriteAllow;
   end;


   TConnectList = class
   private
      AutoConnectID : Integer;
      DataList : TList;
   public
      Constructor Create;
      Destructor Destroy; override;

      procedure CreateConnect (aSocket : TCustomWinSocket);
      procedure DeleteConnect (aSocket : TCustomWinSocket);
      procedure SetAllowWrite (aSocket : TCustomWinSocket);

      procedure AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aSize : Integer);

      procedure Update;
   end;


var
   ConnectList : TConnectList;

implementation

uses
   FMain, uBattleDB;

/////////////////////  TConnect //////////////////////////
Constructor TConnect.Create (aSocket: TCustomWinSocket; aConnectID : Integer);
begin
   ConnectID := aConnectID;
   Socket := aSocket;

   Sender := TPacketSender.Create ('Sender', BufferSizeS2S, aSocket);
   Receiver := TPacketReceiver.Create ('Receiver', BufferSizeS2S);
end;

Destructor TConnect.Destroy;
begin
   Sender.Free;
   Receiver.Free;

   inherited Destroy;
end;

procedure TConnect.AddReceiveData (aData : PChar; aSize : integer);
begin
   Receiver.PutData (aData, aSize);
end;

procedure TConnect.AddSendPacket (aID : Integer; aMsg : Word; aRetCode : Byte; aData : PChar; aSize : integer);
begin
   Sender.PutPacket (aID, aMsg, aRetCode, aData, aSize);
end;

procedure TConnect.Update;
var
   Packet : TPacketData;
   ComData : TComData;
begin
   Sender.Update;
   Receiver.Update;
   while Receiver.Count > 0 do begin
      if Receiver.GetPacket (@Packet) = false then break;
      MessageProcess (@Packet);
   end;
end;

procedure TConnect.MessageProcess (aPacket : PTPacketData);
var
   pCharData : PTGetRankData;
   RankData : TSendRankData;
   pBattleData : PTBattleResultData;
   pRankPart : PTGetRankPart;
   RankPart : TSendRankPart;
   nSize : Integer;
begin
   case aPacket^.RequestMsg of
      BSBD_GETRANKDATA :
         begin
            pCharData := PTGetRankData (@aPacket^.Data);
            if BattleDB.GetRankData (pCharData, @RankData) = true then begin
               AddSendPacket (aPacket^.RequestID, BDBS_SENDRANKDATA, 1, @RankData, SizeOf (TSendRankData));
            end else begin
               AddSendPacket (aPacket^.RequestID, BDBS_SENDRANKDATA, 0, nil, 0);
            end;
         end;
      BSBD_BATTLERESULT :
         begin
            pBattleData := PTBattleResultData (@aPacket^.Data);
            FrmMain.timerProcess.Enabled := false;
            BattleDB.UpdateRank (pBattleData);
            FrmMain.timerProcess.Enabled := true;
         end;
      BSBD_GETRANKPART :
         begin
            pRankPart := PTGetRankPart (@aPacket^.Data);
            if BattleDB.GetRankPart (pRankPart^.rAge, pRankPart^.rStart, pRankPart^.rEnd, @RankPart) = true then begin
               nSize := (SizeOf (Integer) * 2) + (SizeOf (TSendRankData) * (RankPart.rEnd - RankPart.rStart + 1));
               AddSendPacket (aPacket^.RequestID, BDBS_SENDRANKPART, 1, @RankPart, SizeOf (TSendRankPart));
            end else begin
               AddSendPacket (aPacket^.RequestID, BDBS_SENDRANKPART, 0, nil, 0);
            end;
         end;
   end;
end;

procedure TConnect.SetWriteAllow;
begin
   Sender.WriteAllow := true;
end;

/////////////////////  TConnectList //////////////////////////

Constructor TConnectList.Create;
begin
   AutoConnectID := 0;
   DataList := TList.Create;
end;

Destructor TConnectList.Destroy;
var
   i : integer;
   Connect : TConnect;
begin
   for i := 0 to DataList.Count-1 do begin
      Connect := DataList.Items[i];
      Connect.Free;
   end;
   DataList.Free;

   inherited Destroy;
end;

procedure TConnectList.CreateConnect (aSocket : TCustomWinSocket);
var
   aConnect : TConnect;
begin
   aConnect := TConnect.Create (aSocket, AutoConnectID);
   DataList.Add (aConnect);

   Inc (AutoConnectID);
end;

procedure TConnectList.DeleteConnect(aSocket : TCustomWinSocket);
var
   i : integer;
   Connect : TConnect;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connect := DataList.Items [i];
      if Connect.Socket = aSocket then begin
         DataList.Delete (i);
         exit;
      end;
   end;
end;

procedure TConnectList.SetAllowWrite (aSocket : TCustomWinSocket);
var
   i : integer;
   Connect : TConnect;
begin
   for i := 0 to DataList.Count-1 do begin
      Connect := DataList.Items[i];
      if Connect.Socket = aSocket then begin
         Connect.SetWriteAllow;
         exit;
      end;
   end;
end;

procedure TConnectList.AddReceiveData (aSocket : TCustomWinSocket; aData : PChar; aSize : integer);
var
   i : integer;
   aConnect : TConnect;
begin
   for i := 0 to DataList.Count-1 do begin
      aConnect := DataList.Items[i];
      if aConnect.Socket = aSocket then begin
         aConnect.AddReceiveData(aData, aSize);
         exit;
      end;
   end;
end;

{
procedure TConnectList.AddSendData (aName : string; aData : PChar; aSize : integer);
begin
end;

procedure TConnectList.AddSendDataAll (aData : PChar; aSize : integer);
var
   i : integer;
   aConnect : TConnect;
begin
   for i := 0 to DataList.Count-1 do begin
      aConnect := DataList.Items[i];
      aConnect.AddSendData(aData, aSize);
   end;
end;
}

procedure TConnectList.Update;
var
   i : integer;
   Connect : TConnect;
begin
   for i := 0 to DataList.Count - 1 do begin
      Connect := DataList.Items [i];
      Connect.Update;
   end;
end;

initialization
begin
   ConnectList := TConnectList.Create;
end;

Finalization
begin
   ConnectList.Destroy;
end;

end.


