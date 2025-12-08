// 2001. 07. 03. Battle Server ½ÃÀÛ... ;;; by saset...
// 2001. 08. 04. ½ÇÇè¼·¿¡ ¶ç¿ò. (¹«Àð°Ô ÀÚÁÖ ´Ù¿îµÊ -_-;)
// 2001. 08. 14. º»¼·¿¡ ¶ç¿ò.

unit SVMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, inifiles, ExtCtrls,
  uAnsTick, uUser, uconnect, mapunit, fieldmsg, ulevelexp, deftype,
  svClass, basicobj, aUtil32, Spin, Menus, ComCtrls,
  uLetter, AnsStringCls, ScktComp, uPackets, Common;

type
  TFrmMain = class(TForm)
    TimerProcess: TTimer;
    TimerDisplay: TTimer;
    TimerSave: TTimer;
    TimerClose: TTimer;
    MainMenu1: TMainMenu;
    Files: TMenuItem;
    Exit1: TMenuItem;
    StatusBar1: TStatusBar;
    sckGameServerAccept: TServerSocket;
    txtLog: TMemo;
    sckBattleDBConnect: TClientSocket;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblBattleDBSendBytes: TLabel;
    lblBattleDBReceiveBytes: TLabel;
    lblBattleDBWBCount: TLabel;
    shpBattleDBWBSign: TShape;
    Label7: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lstGroup: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    lstRoom: TListBox;
    lstUsers: TListBox;
    lblUsers: TLabel;
    States: TMenuItem;
    GSState: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerProcessTimer(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure TimerSaveTimer(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure sckGameServerAcceptAccept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGameServerAcceptClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGameServerAcceptClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckGameServerAcceptClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckGameServerAcceptClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBattleDBConnectConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBattleDBConnectDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckBattleDBConnectError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sckBattleDBConnectRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckBattleDBConnectWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure lstGroupDblClick(Sender: TObject);
    procedure GSStateClick(Sender: TObject);
  private

  public
    boCloseFlag : Boolean;
    ProcessCount : integer;

    procedure AddLog (aStr : String);
    procedure WriteLogInfo (aStr : String);
    procedure WriteDumpInfo (aData : PChar; aSize : Integer);
    procedure AddUser (aName : String);
    procedure DelUser (aName : String);


    procedure lstGroupUpdate (aUpdateTitle : String);
  end;

var
  FrmMain: TFrmMain;

  BSPort : Integer = 3040;
  BufferSizeS2S : Integer = 1048576;
  BufferSizeS2C : Integer = 8192;

//  BattleDBServerIpAddr : String = '192.168.0.151';
  BattleDBServerIpAddr : String = '192.168.0.109';
  BattleDBServerPort : Integer = 3039;   // ¹ÌÁ¤.. ;;; ÂÁ..

  BattleDBSender : TPacketSender;
  BattleDBReceiver : TPacketReceiver;

implementation

uses
   uGConnect, uGroup, BSCommon, FGameServer;

{$R *.DFM}

procedure TFrmMain.WriteLogInfo (aStr : String);
var
   Stream : TFileStream;
   tmpFileName : String;
   szBuf : array[0..1024] of Byte;
begin
   try
      StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
      tmpFileName := 'BGS1000.LOG';
      if FileExists (tmpFileName) then
         Stream := TFileStream.Create (tmpFileName, fmOpenReadWrite)
      else
         Stream := TFileStream.Create (tmpFileName, fmCreate);

      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (szBuf, StrLen(@szBuf));
      Stream.Destroy;
   except
   end;
end;

procedure TFrmMain.WriteDumpInfo (aData : PChar; aSize : Integer);
var
   Stream : TFileStream;
   tmpFileName : String;
   iCount : Integer;
begin
   try
      iCount := 0;
      while true do begin
         tmpFileName := 'DUMP' + IntToStr (iCount) + '.BIN';
         if not FileExists (tmpFileName) then break;
         iCount := iCount + 1;
      end;
      
      Stream := TFileStream.Create (tmpFileName, fmCreate);
      Stream.Seek(0, soFromEnd);
      Stream.WriteBuffer (aData^, aSize);
      Stream.Destroy;
   except
   end;
end;

procedure TFrmMain.AddUser (aName : String);
begin
   lstUsers.Items.Add (aName);
   lblUsers.Caption := format ('Users (%d)', [lstUsers.Items.Count]);
end;

procedure TFrmMain.DelUser (aName : String);
var
   Index : Integer;
begin
   Index := lstUsers.Items.IndexOf (aName);
   if (Index >= 0) and (Index < lstUsers.Items.Count) then begin
      lstUsers.Items.Delete (Index);
      lblUsers.Caption := format ('Users (%d)', [lstUsers.Items.Count]);
   end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
   Ini : TIniFile;
begin
   ShareRoom := TBattleRoom.Create (nil, '', 0);

   WriteLogInfo ('Battle Server Started');

   Randomize;

   boCloseFlag := FALSE;

   LoadGameIni ('.\game.ini');

   Ini := TIniFile.Create ('.\bs1000.ini');
   BSPort := Ini.ReadInteger ('SERVER', 'Port', 3040);
   BufferSizeS2S := INI.ReadInteger ('SERVER', 'BUFFERSIZES2S', 1048576);
   BufferSizeS2C := INI.ReadInteger ('SERVER', 'BUFFERSIZES2C', 8192);

   BattleDBServerIpAddr := Ini.ReadString ('BattleDB_SERVER', 'IPADDRESS', '192.168.0.109');
   BattleDBServerPort := Ini.ReadInteger ('BattleDB_SERVER', 'PORT', 3039);

   ini.Free;

   BattleGroupList := TBattleGroupList.Create;

   // ManagerList := TManagerList.Create;

   GameServerConnectorList := TGameServerConnectorList.Create;

   ConnectorList := TConnectorList.Create;
   UserList := TUserList.Create (100);
   MirrorList := TMirrorList.Create;
   SpecialAreaList := TSpecialAreaList.Create;

   GradeStrList := TStringList.Create;
   GradeStrList.LoadFromFile (GRADE_FILENAME);

   sckGameServerAccept.Port := BSPort;
   sckGameServerAccept.Active := true;

   sckBattleDBConnect.Port := BattleDBServerPort;
   sckBattleDBConnect.Address := BattleDBServerIpAddr;
   sckBattleDBConnect.Active := true;

   TimerProcess.Interval := 10;
   TimerProcess.Enabled := TRUE;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
   GradeStrList.Clear;
   GradeStrList.Free;

   ShareRoom.free;

   TimerProcess.Enabled := false;
   TimerSave.Enabled := false;
   TimerDisplay.Enabled := false;

   MirrorList.Free;
   SpecialAreaList.Free;
   UserList.free;
   ConnectorList.free;
   GameServerConnectorList.Free;
   // ManagerList.Free;

   BattleGroupList.Free;

   WriteLogInfo ('Battle Server Exit');

   if sckGameServerAccept.Active = true then begin
      sckGameServerAccept.Socket.Close;
   end;

   if sckBattleDBConnect.Active = true then begin
      sckBattleDBConnect.Socket.Close;
   end;
end;

procedure TFrmMain.TimerSaveTimer(Sender: TObject);
begin
   {
   if TimerClose.Enabled = true then exit;

   str := TimeToStr (Time);
   if OldDate <> DateToStr (Date) then begin
      OldDate := DateToStr (Date);

      GameCurrentDate := Round ( Date - StrToDate (GameStartDateStr));

      NameStringListForDeleteMagic.Clear;
   end;

   if Pos ('¿ÀÀü', str) > 0 then GrobalLightDark := gld_dark
   else GrobalLightDark := gld_light;

   if NoticeStringList.Count > 0 then begin
      if CurNoticePosition >= NoticeStringList.Count then CurNoticePosition := 0;
      UserList.SendNoticeMessage ( NoticeStringList[CurNoticePosition], SAY_COLOR_NOTICE);
      inc (CurNoticePosition);
   end;

   n := GetCPUStartHour;
   if n <> IniHour then begin
      IniHour := n;
      ServerIni.WriteInteger ('DATABASE', 'HOUR', n);

      GuildList.SaveToFile ('.\Guild\CreateGuild.SDB');
   end;

   usd.rmsg := 1;
   SetWordString (usd.rWordString, IntToStr (UserList.Count));
   n := sizeof(TStringData) - sizeof(TWordString) + sizeofwordstring (usd.rwordstring);
   FrmSockets.UdpMoniterAddData (n, @usd);
   }
end;

procedure TFrmMain.TimerCloseTimer(Sender: TObject);
begin
   if (UserList.Count = 0) and (ConnectorList.Count = 0) and (ConnectorList.GetSaveListCount = 0) then begin
      Close;
   end else begin
      ConnectorList.CloseAllConnect;
   end;
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin
   boCloseFlag := true;

   TimerClose.Interval := 1000;
   TimerClose.Enabled := TRUE;
end;

procedure TFrmMain.TimerDisplayTimer(Sender: TObject);
var
   GameServerConnector : TGameServerConnector;
begin
   if sckBattleDBConnect.Active = false then begin
      sckBattleDBConnect.Socket.Close;
      sckBattleDBConnect.Active := true;
   end;


   // Ã¢Á¶GS
   GameServerConnector := GameServerConnectorList.Items [0];
   if GameServerConnector <> nil then begin
      with GameServerConnector do begin
         frmGSState.lblCreateSendB.Caption := IntToStr (SendBytesPerSec) + 'K';
         frmGSState.lblCreateReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

         if WriteAllow = true then begin
            frmGSState.shpCreateWBSign.Brush.Color := clLime;
         end else begin
            frmGSState.shpCreateWBSign.Brush.Color := clRed;
         end;
      end;
   end;

   // ºÎÈ°GS
   GameServerConnector := GameServerConnectorList.Items [1];
   if GameServerConnector <> nil then begin
      with GameServerConnector do begin
         frmGSState.lblRevivalSendB.Caption := IntToStr (SendBytesPerSec) + 'K';
         frmGSState.lblRevivalReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

         if WriteAllow = true then begin
            frmGSState.shpRevivalWBSign.Brush.Color := clLime;
         end else begin
            frmGSState.shpRevivalWBSign.Brush.Color := clRed;
         end;
      end;
   end;

   // »ý¸íGS
   GameServerConnector := GameServerConnectorList.Items [2];
   if GameServerConnector <> nil then begin
      with GameServerConnector do begin
         frmGSState.lblLifeSendB.Caption := IntToStr (SendBytesPerSec) + 'K';
         frmGSState.lblLifeReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

         if WriteAllow = true then begin
            frmGSState.shpLifeWBSign.Brush.Color := clLime;
         end else begin
            frmGSState.shpLifeWBSign.Brush.Color := clRed;
         end;
      end;
   end;

   // ½ÅÈ­GS
   GameServerConnector := GameServerConnectorList.Items [3];
   if GameServerConnector <> nil then begin
      with GameServerConnector do begin
         frmGSState.lblMythSendB.Caption := IntToStr (SendBytesPerSec) + 'K';
         frmGSState.lblMythReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

         if WriteAllow = true then begin
            frmGSState.shpMythWBSign.Brush.Color := clLime;
         end else begin
            frmGSState.shpMythWBSign.Brush.Color := clRed;
         end;
      end;
   end;

   // ÇÏ´ÃGS
   GameServerConnector := GameServerConnectorList.Items [4];
   if GameServerConnector <> nil then begin
      with GameServerConnector do begin
         frmGSState.lblSkySendB.Caption := IntToStr (SendBytesPerSec) + 'K';
         frmGSState.lblSkyReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

         if WriteAllow = true then begin
            frmGSState.shpSkyWBSign.Brush.Color := clLime;
         end else begin
            frmGSState.shpSkyWBSign.Brush.Color := clRed;
         end;
      end;
   end;

   // ÃµÇÏGS
   GameServerConnector := GameServerConnectorList.Items [5];
   if GameServerConnector <> nil then begin
      with GameServerConnector do begin
         frmGSState.lblWorldSendB.Caption := IntToStr (SendBytesPerSec) + 'K';
         frmGSState.lblWorldReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

         if WriteAllow = true then begin
            frmGSState.shpWorldWBSign.Brush.Color := clLime;
         end else begin
            frmGSState.shpWorldWBSign.Brush.Color := clRed;
         end;
      end;
   end;
   
{
   // ½ÇÇèGS
   GameServerConnector := GameServerConnectorList.Items [6];
   with GameServerConnector do begin
      frmGSState.lblExSendB.Caption := IntToStr (SendBytesPerSec) + 'K';
      frmGSState.lblExReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

      if WriteAllow = true then begin
         frmGSState.shpExWBSign.Brush.Color := clLime;
      end else begin
         frmGSState.shpExWBSign.Brush.Color := clRed;
      end;
   end;

   // 32¹øGS
   GameServerConnector := GameServerConnectorList.Items [0];
   with GameServerConnector do begin
      frmGSState.lblTestSendB.Caption := IntToStr (SendBytesPerSec) + 'K';
      frmGSState.lblTestReceiveB.Caption := IntToStr (ReceiveBytesPerSec) + 'K';

      if WriteAllow = true then begin
         frmGSState.shpTestWBSign.Brush.Color := clLime;
      end else begin
         frmGSState.shpTestWBSign.Brush.Color := clRed;
      end;
   end;
}

   // DB
   if (BattleDBSender <> nil) and (BattleDBReceiver <> nil) then begin
      lblBattleDBSendBytes.Caption := IntToStr (BattleDBSender.SendBytesPerSec) + 'K';
      lblBattleDBReceiveBytes.Caption := IntToStr (BattleDBReceiver.ReceiveBytesPerSec) + 'K';
      lblBattleDBWBCount.Caption := IntToStr (BattleDBSender.WouldBlockCount);

      if BattleDBSender.WriteAllow = true then begin
         shpBattleDBWBSign.Brush.Color := clLime;
      end else begin
         shpBattleDBWBSign.Brush.Color := clRed;
      end;
   end else begin
      shpBattleDBWBSign.Brush.Color := clRed;
   end;
end;

procedure TFrmMain.TimerProcessTimer(Sender: TObject);
var
   CurTick : integer;
   Packet : TPacketData;
begin
   CurTick := mmAnsTick;

   GameServerConnectorList.Update (CurTick);

   ConnectorList.Update (CurTick);
   UserList.Update (CurTick);

   if boCloseFlag = false then begin
      BattleGroupList.Update (CurTick);
   end;

   inc (ProcessCount);

   if BattleDBSender <> nil then BattleDBSender.Update;
   if BattleDBReceiver <> nil then begin
      BattleDBReceiver.Update;
      while BattleDBReceiver.Count > 0 do begin
         if BattleDBReceiver.GetPacket (@Packet) = false then break;
         ConnectorList.BattleDBMessageProcess (@Packet);
      end;
   end;
end;

procedure TFrmMain.sckGameServerAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if GameServerConnectorList.CreateConnect (Socket) = false then begin
      Socket.Close;
      exit;
   end;
   AddLog (format ('Server BattleServer Accepted %s', [Socket.RemoteAddress]));
end;

procedure TFrmMain.sckGameServerAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if Socket.Connected = true then begin
      GameServerConnectorList.DeleteConnect (Socket);
      AddLog (format ('Server BattleServer Disconnected %s', [Socket.RemoteAddress]));
   end;
end;

procedure TFrmMain.sckGameServerAcceptClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   AddLog (format ('Server Accept Socket Error (%d, %s)', [ErrorCode, Socket.RemoteAddress]));
   ErrorCode := 0;
end;

procedure TFrmMain.sckGameServerAcceptClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   nRead : Integer;
   buffer : array[0..8192 - 1] of byte;
begin
   nRead := Socket.ReceiveBuf (buffer, 8192);
   if nRead > 0 then begin
      GameServerConnectorList.AddReceiveData (Socket, @buffer, nRead);
   end;
end;

procedure TFrmMain.sckGameServerAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   GameServerConnectorList.SetWriteAllow (Socket);
end;

procedure TfrmMain.AddLog (aStr : String);
begin
   if txtLog.Lines.Count >= 30 then begin
      txtLog.Lines.Delete (0);
   end;
   txtLog.Lines.Add (aStr);
end;

procedure TFrmMain.sckBattleDBConnectConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if BattleDBSender <> nil then begin
      BattleDBSender.Free;
      BattleDBSender := nil;
   end;
   if BattleDBReceiver <> nil then begin
      BattleDBReceiver.Free;
      BattleDBReceiver := nil;
   end;

   BattleDBSender := TPacketSender.Create ('BattleDB_SENDER', BufferSizeS2S, Socket);
   BattleDBReceiver := TPacketReceiver.Create ('BattleDB_RECEIVER', BufferSizeS2C);

   AddLog (format ('BattleDBConnect Accepted %s', [Socket.RemoteAddress]));   
end;

procedure TFrmMain.sckBattleDBConnectDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if BattleDBSender <> nil then begin
      BattleDBSender.Free;
      BattleDBSender := nil;
   end;
   if BattleDBReceiver <> nil then begin
      BattleDBReceiver.Free;
      BattleDBReceiver := nil;
   end;
end;

procedure TFrmMain.sckBattleDBConnectError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   if (ErrorCode <> 10061) and (ErrorCode <> 10038) then begin
      AddLog (format ('BattleDBConnect Socket Error (%d)', [ErrorCode]));
   end;

   ErrorCode := 0;
end;

procedure TFrmMain.sckBattleDBConnectRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   buffer : array [0..8192 - 1] of char;
   nTotal, nRead : Integer;
begin
   nTotal := Socket.ReceiveLength;

   while nTotal > 0 do begin
      nRead := Socket.ReceiveBuf (buffer, 8192);
      if nRead < 0 then break;
      if BattleDBReceiver <> nil then BattleDBReceiver.PutData (@buffer, nRead);
      nTotal := nTotal - nRead;
   end;
end;

procedure TFrmMain.sckBattleDBConnectWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   if BattleDBSender <> nil then BattleDBSender.WriteAllow := true;
end;

procedure TFrmMain.lstGroupDblClick(Sender: TObject);
var
   Title, str, dest : String;
begin
   str := lstGroup.Items [lstGroup.ItemIndex];
   dest := GetValidStr3 (str, Title, ':');

   lstRoom.Clear;
   BattleGroupList.ShowRoomTitleList (Title);
end;

procedure TFrmMain.lstGroupUpdate (aUpdateTitle : String);
var
   UpdateTitle, Title, str, dest : String;
   i : Integer;
begin
   dest := GetValidStr3 (aUpdateTitle, UpdateTitle, ':');

   for i := 0 to lstGroup.Items.Count - 1 do begin
      str := lstGroup.Items [i];
      dest := GetValidStr3 (str, Title, ':');

      if Title = UpdateTitle then begin
         lstGroup.Items [i] := aUpdatetitle;
         exit;
      end;
   end;
end;

procedure TFrmMain.GSStateClick(Sender: TObject);
begin
   frmGSState.Show;
end;

end.
