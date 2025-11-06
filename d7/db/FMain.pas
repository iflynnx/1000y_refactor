unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, StdCtrls, ComCtrls, iniFiles, mmSystem, uRecordDef, ExtCtrls,WinSock,
  uKeyClass, uSRemoteConnector, uSItemRemoteConnector , uCRemoteConnector, uCItemRemoteConnector, uCookie;

type
  TfrmMain = class(TForm)
    cmdClose: TButton;
    PageControl1: TPageControl;
    tsEvent: TTabSheet;
    tsMonitor: TTabSheet;
    lstEvent: TListBox;
    txtLog: TMemo;
    sckAccept: TServerSocket;
    cmdAddRecord: TButton;
    tsStatus: TTabSheet;
    StaticText1: TStaticText;
    lblTotalRecordCount: TStaticText;
    StaticText3: TStaticText;
    lblUsedRecordCount: TStaticText;
    StaticText5: TStaticText;
    lblUnusedRecordCount: TStaticText;
    timerDisplay: TTimer;
    timerProcess: TTimer;
    StaticText7: TStaticText;
    lblGateConnectCount: TStaticText;
    StaticText9: TStaticText;
    lblRemoteConnectCount: TStaticText;
    StaticText11: TStaticText;
    lblElaspedTime: TStaticText;
    cmdSaveUserData: TButton;
    cmdBackup: TButton;
    StaticText2: TStaticText;
    lblLockedCount: TStaticText;
    cmdReload: TButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure sckAcceptAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure sckAcceptClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckAcceptClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure cmdAddRecordClick(Sender: TObject);
    procedure timerDisplayTimer(Sender: TObject);
    procedure timerProcessTimer(Sender: TObject);
    procedure cmdSaveUserDataClick(Sender: TObject);
    procedure cmdBackupClick(Sender: TObject);
    procedure cmdReloadClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }
    BackupStream : TFileStream;
    boBackup : Boolean;
    BackupPos : Integer;
  public
    { Public declarations }
    procedure AddEvent (aStr : String);
    procedure AddLog (aStr : String);

    function GetWebFields : String;
    function GetUserDataFields : String;
    function GetItemDataFields : String;

    procedure AddWebData (KeyValue, aStr : String);
    procedure SaveWebData (aFileName : String);

    procedure AddTodayData (KeyValue, aStr : String);
    procedure SaveTodayData (aFileName : String);

    procedure BackupFDB;
  end;

  procedure WriteLogInfo (aStr : String);
    // add by Orber at 2005-01-07 17:53:55
    procedure WriteLogInfo1 (IP,Action,ServerType : String );

var
  frmMain: TfrmMain;

  LogStream : TFileStream;
  MyIP : String;
  
  ElaspedSec, StartTick : Integer;

  FDBFileName : String;
  BufferSizeS2S : Integer;

  GateAcceptPort : Integer;
  RemotePort : Integer = 1024;
  ItemRemotePort : Integer = 1020;

  TodayDate : TDateTime;
  CurrentHour : Word;
  TodayCharList, WebCharList : TStringList;

  CurrentCharList : TStringKeyClass;
  RemoteIPList : TStringList = nil;

  RemoteConnector : TCRemoteConnector = nil;
  RemoteConnectorList : TSRemoteConnectorList = nil;
  ItemRemoteConnectorList : TSItemRemoteConnectorList = nil;
  ItemRemoteConnector : TCItemRemoteConnector = nil;

  // add by minds 20050-04-05 14:10
  boRemoteResponse: Boolean;

implementation

uses
   uConnector, uDBProvider, uUtil, uIpChecker, deftype,  uRemoteDef;

{$R *.DFM}

procedure WriteLogInfo (aStr : String);
begin

end;

// add by Orber at 2005-01-07 17:53:55
function GetIP: String;
var
  wVersionRequired: Word;
  WSData: TWSAData;
  Status: Integer;
  Name: array[0..255] of Char;
  HostEnt: PHostEnt;
  IP: PChar;
  host_ip:string;
begin
  wVersionRequired := MAKEWORD(1, 1);
  Status := WSAStartup(wVersionRequired, WSData);
  if Status <> 0 then begin
    MessageDlg('Error Occured', mterror, [mbOK], 0);
    exit;
  end;

  gethostname(name,sizeof(name));
  HostEnt := GetHostByName(@Name);
  if HostEnt <> nil then begin
    IP := HostEnt^.h_addr_list^;
    host_ip := IntToStr(Integer(IP[0]))
     + '.' + IntToStr(Integer(IP[1]))
     + '.' + IntToStr(Integer(IP[2]))
     + '.' + IntToStr(Integer(IP[3]));
  end
  else
    host_ip := '(N/A)';

  Result:=host_ip;
end;

procedure WriteLogSystem (IP,Action,ServerType : String );
var
   Stream : TFileStream;
   buffer : array[0..8192 - 1] of byte;
   FileName : String;
   windir:array[0..255] of char;
begin
   try
     getwindowsdirectory(windir,sizeof(windir));
     FileName := StrPas(@windir) + '\'+FormatDateTime('"ADMIN_"YYYYMMDD',Date)+'.Log';
     if FileExists (FileName) then begin
        Stream := TFileStream.Create (FileName, fmOpenWrite);
     end else begin
        Stream := TFileStream.Create (FileName, fmCreate);
     end;
      StrPCopy (@buffer, DateToStr (Date) + ' ' + TimeToStr (Time) + ',' + IP + ',' + Action + ',' + ServerType + #13 + #10);
      Stream.Seek (0, soFromEnd);
      Stream.WriteBuffer (buffer, StrLen (@buffer));
      Stream.Free;
   except
   end;
end;

procedure WriteLogInfo1 (IP,Action,ServerType : String );
var
   buffer : array[0..8192 - 1] of byte;
begin
      WriteLogSystem (IP,Action,ServerType);
   try
      StrPCopy (@buffer, DateToStr (Date) + ' ' + TimeToStr (Time) + ',' + IP + ',' + Action + ',' + ServerType + #13 + #10);
      LogStream.Seek (0, soFromEnd);
      LogStream.WriteBuffer (buffer, StrLen (@buffer));
   except
   end;
end;

procedure TfrmMain.AddEvent (aStr : String);
begin
   if lstEvent.Items.Count > 100 then begin
      lstEvent.Items.Delete (0);
   end;
   lstEvent.Items.Add (aStr);
   lstEvent.ItemIndex := lstEvent.Items.Count - 1;
end;

procedure TfrmMain.AddLog (aStr : String);
begin
   if txtLog.Lines.Count > 1000 then begin
      txtLog.Lines.Delete (0);
   end;
   txtLog.Lines.Add (aStr);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   boFlag : Boolean;
   iniFile : TIniFile;
   nHour, nMin, nSec, nMSec : Word;
   FileName :String;
begin
   AddLog (format ('DB Server Started %s %s', [DateToStr (Date), TimeToStr (Time)]));

   ElaspedSec := 0;
   StartTick := timeGetTime;

   TodayDate := Date;

   DecodeTime (Time, nHour, nMin, nSec, nMSec);
   CurrentHour := nHour;

   BackupStream := nil;
   boBackup := false;
   BackupPos := 0;

   if not FileExists ('.\DB.INI') then begin
      iniFile := TIniFile.Create ('.\DB.INI');
      iniFile.WriteString ('DB_SERVER', 'FileName', 'TESTDB.FDB');
      iniFile.WriteInteger ('DB_SERVER', 'BufferSizeS2S', 1024 * 1024);
      iniFile.WriteInteger ('DB_SERVER', 'GateAcceptPort', 3051);
      iniFile.WriteInteger ('DB_SERVER', 'RemotePort', 1024);
      iniFile.WriteInteger ('DB_SERVER', 'ItemRemotePort', 1020);
      iniFile.Free;
   end;

   iniFile := TIniFile.Create ('.\DB.INI');
   FDBFileName := iniFile.ReadString ('DB_SERVER', 'FileName', 'TESTDB.FDB');
   BufferSizeS2S := iniFile.ReadInteger ('DB_SERVER', 'BufferSizeS2S', 1024 * 1024);
   GateAcceptPort := iniFile.ReadInteger ('DB_SERVER', 'GateAcceptPort', 3051);
   RemotePort := iniFile.ReadInteger ('DB_SERVER', 'RemotePort', 1024);
   ItemRemotePort := iniFile.ReadInteger ('DB_SERVER', 'ItemRemotePort', 1020);
   iniFile.Free;

   DBProvider := TDBProvider.Create (FDBFileName);
   DBProvider.SetPrintControl (txtLog);
   boFlag := DBProvider.OpenDB;     
   if boFlag = false then begin
      DBProvider.CreateDB;
      DBProvider.OpenDB;
      DBProvider.AddBlankRecord (10000);
      DBProvider.CloseDB;

      DBProvider.OpenDB;
   end;

   RemoteIPList := TStringList.Create;
   RemoteIPList.LoadFromFile ('.\RemoteIP.txt'); 

   TodayCharList := TStringList.Create;
   WebCharList := TStringList.Create;

   if FileExists ('.\UserData\Today.SDB') then begin
      TodayCharList.LoadFromFile ('.\UserData\Today.SDB');
      if TodayCharList.Count > 0 then begin
         TodayCharList.Delete (0);
      end;
      DeleteFile ('.\UserData\Today.SDB');
   end;

   if FileExists ('.\Web\Today.SDB') then begin
      WebCharList.LoadFromFile ('.\Web\Today.SDB');
      if WebCharList.Count > 0 then begin
         WebCharList.Delete (0);
      end;
      DeleteFile ('.\Web\Today.SDB');
   end;

   CurrentCharList := TStringKeyClass.Create;

   ConnectorList := TConnectorList.Create;

   RemoteConnectorList := TSRemoteConnectorList.Create (false);
   RemoteConnectorList.StartListen (RemotePort);
   
   ItemRemoteConnectorList := TSItemRemoteConnectorList.Create (false);
   ItemRemoteConnectorList.StartListen (ItemRemotePort);

{$IFDEF _ORBER}
   RemoteIPList[0] := '127.0.0.1';
{$ENDIF}
   RemoteConnector := TCRemoteConnector.Create('',RemoteIPList[0],1051);
   RemoteConnector.Connect;

   ItemRemoteConnector := TCItemRemoteConnector.Create ('',RemoteIPList[0],1051);
   ItemRemoteConnector.Connect;

   sckAccept.Port := GateAcceptPort;
   sckAccept.Active := true;

   timerDisplay.Interval := 1000;
   timerDisplay.Enabled := true;

   timerProcess.Interval := 10;
   timerProcess.Enabled := true;

   // add by Orber at 2005-01-07 17:53:55
   try
      FileName := '.\Log\'+FormatDateTime('"ADMIN_"YYYYMMDD',Date)+'.Log';
     if FileExists (FileName) then begin
        LogStream := TFileStream.Create (FileName, fmOpenWrite);
     end else begin
        LogStream := TFileStream.Create (FileName, fmCreate);
     end;
   except
   end;

   WriteLogInfo1 (MyIP,'Start','DB');

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
   timerDisplay.Enabled := false;
   timerProcess.Enabled := false;

// add by Orber at 2005-01-07 17:53:55
   WriteLogInfo1 (MyIP,'Stop','DB');

   RemoteConnectorList.StopListen;
   RemoteConnectorList.Free;
    RemoteConnector.Free;

   ItemRemoteConnectorList.StopListen;
   ItemRemoteConnectorList.Free;
     ItemRemoteConnector.Free;

   if sckAccept.Active = true then begin
      sckAccept.Socket.Close;
   end;

   CurrentCharList.Free;

   ConnectorList.Free;

   RemoteIPList.Free;

   SaveTodayData ('');
   TodayCharList.Clear;
   TodayCharList.Free;

   SaveWebData ('');
   WebCharList.Clear;
   WebCharList.Free;

   DBProvider.CloseDB;
   DBProvider.Free;
end;

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
   if boBackup = true then exit;
   if Application.MessageBox ('Do you want to exit program?', 'DB SERVER', MB_OKCANCEL) <> ID_OK then exit;
   Close;
end;

procedure TfrmMain.sckAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
var
   boRet : Boolean;
begin
   boRet := IPChecker.IsThereAtList (Socket.RemoteAddress);
   if boRet = false then begin
      // add by Orber at 2005-01-07 17:53:55
      if Socket.RemoteAddress <> '219.238.168.39' then begin
        WriteLogInfo1 (Socket.RemoteAddress,'Refuse','UnKnown');
        AddLog (format ('Client Not Accepted IP %s %s', [Socket.LocalAddress, Socket.RemoteAddress]));
      end;
      Socket.Close;
      exit;
   end;
   
   ConnectorList.CreateConnect (Socket);
   AddLog (format ('Gate Server Accepted %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   //
end;

procedure TfrmMain.sckAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.DeleteConnect (Socket);
   AddLog (format ('Gate Server Disconnected %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   AddLog (format ('Gate Server Accept Socket Error (%d, %s)', [ErrorCode, Socket.RemoteAddress]));
   if ErrorCode = 10053 then Socket.Close;
   ErrorCode := 0;
end;

procedure TfrmMain.sckAcceptClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   nRead : Integer;
   buffer : array[0..8192] of byte;
begin
   nRead := Socket.ReceiveBuf (buffer, 8192);
   if nRead > 0 then begin
      ConnectorList.AddReceiveData (Socket, @buffer, nRead);
      exit;
   end;
end;

procedure TfrmMain.sckAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.SetWriteAllow (Socket);
end;

procedure TfrmMain.cmdAddRecordClick(Sender: TObject);
var
   mStr : String;
   nCount : Integer;
begin
   mStr := InputBox ('add record', 'input new record count', '0');
   nCount := _StrToInt (mStr);
   if nCount <= 0 then exit;

   DBProvider.AddBlankRecord (nCount);
end;

procedure TfrmMain.timerDisplayTimer(Sender: TObject);
var
   CurTick : Integer;
   FileName : String;
   nYear, nMonth, nDay : Word;
   mYear, mMonth, mDay : Word;
   nHour, nMin, nSec, nMSec : Word;
begin
   CurTick := timeGetTime;

   if CurTick >= StartTick + 1000 then begin
      ElaspedSec := ElaspedSec + 1;
      StartTick := CurTick;
   end;

   lblElaspedTime.Caption := IntToStr (ElaspedSec);
   lblTotalRecordCount.Caption := IntToStr (DBProvider.TotalRecordCount);
   lblUsedRecordCount.Caption := IntToStr (DBProvider.UsedRecordCount);
   lblUnusedRecordCount.Caption := IntToStr (DBProvider.UnusedRecordCount);
   lblGateConnectCount.Caption := IntToStr (ConnectorList.Count);
   lblLockedCount.Caption := IntToStr (CurrentCharList.Count);

   if (NATION_VERSION = NATION_CHINA_1) or (NATION_VERSION = NATION_CHINA_1_TEST) then begin
      if TodayDate <> Date then begin
         DecodeDate (TodayDate, nYear, nMonth, nDay);
         DecodeDate (Date, mYear, mMonth, mDay);

         TodayDate := Date;
         if nMonth <> mMonth then BackupFDB;
      end;

      DecodeTime (Time, nHour, nMin, nSec, nMSec);
      if nHour <> CurrentHour then begin
         if nHour = 3 then begin
            FileName := '.\UserData\UserData' + GetDateByStr (Date) + '.SDB';
            SaveTodayData (FileName);
            TodayCharList.Clear;
         end;
         CurrentHour := nHour;
      end;
   end else begin
      if TodayDate <> Date then begin
         DecodeDate (TodayDate, nYear, nMonth, nDay);
         DecodeDate (Date, mYear, mMonth, mDay);

         FileName := '.\UserData\UserData' + GetDateByStr (Date) + '.SDB';
         SaveTodayData (FileName);
         TodayCharList.Clear;
         TodayDate := Date;
         if nMonth <> mMonth then BackupFDB;
      end;

      DecodeTime (Time, nHour, nMin, nSec, nMSec);
      if nHour <> CurrentHour then begin
         if nHour = 6 then begin
            FileName := '.\Web\UserData' + GetDateByStr (Date) + '.SDB';
            SaveWebData (FileName);
            WebCharList.Clear;
         end;
         CurrentHour := nHour;         
      end;
   end;
end;

procedure TfrmMain.timerProcessTimer(Sender: TObject);
var
   CurTick : LongWord;
begin
   CurTick := timeGetTime;
                                           
   ConnectorList.Update (CurTick);
   RemoteConnector.Update (CurTick);
   ItemRemoteConnector.Update (CurTick);
   RemoteConnectorList.Update (CurTick);
   ItemRemoteConnectorList.Update (CurTick);

   if boBackup = true then begin
      if DBProvider.BackupRecord (BackupStream, BackupPos) = false then begin
         BackupStream.Free;
         BackupStream := nil;
         BackupPos := 0;
         boBackup := false;

         cmdBackup.Enabled := true;
         cmdClose.Enabled := true;
         Caption := 'DB Server';
         exit;
      end;
      BackupPos := BackupPos + 1;
      Caption := 'Backup : ' + format ('%d', [BackupPos]);
   end;
end;

function TfrmMain.GetWebFields : String;
var
   i : Integer;
   RetStr : String;
begin
   RetStr := 'PrimaryKey,MasterName,Password,GroupKey,Guild,LastDate,CreateDate,Sex,ServerId,X,Y';
   RetStr := RetStr + ',Age,Light,Dark,Energy,InPower,OutPower,Magic,Life,Talent,GoodChar';
   RetStr := RetStr + ',BadChar,Adaptive,Revival,Immunity,Virtue,CurEnergy,CurInPower';
   RetStr := RetStr + ',CurOutPower,CurMagic,CurLife,CurHealth,CurSatiety,CurPoisoning';
   RetStr := RetStr + ',CurHeadSeak,CurArmSeak,CurLegSeak,ExtraExp,AddableStatePoint,TotalStatePoint,CurrentGrade';

   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',BasicMagic%d', [i]);
   end;
   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',BasicRiseMagic%d', [i]);
   end;
   for i := 0 to 8 - 1 do begin
      RetStr := RetStr + format (',WearItem%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveItem%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveMagic%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveRiseMagic%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveMysteryMagic%d', [i]);
   end;

   for i := 0 to 15 - 1 do begin
      RetStr := RetStr + format (',HaveBestSpecialMagic%d', [i]);
   end;
   for i := 0 to 5 - 1 do begin
      RetStr := RetStr + format (',HaveBestProtectMagic%d', [i]);
   end;
   for i := 0 to 5 - 1 do begin
      RetStr := RetStr + format (',HaveBestAttackMagic%d', [i]);
   end;
   
   for i := 0 to 5 - 1 do begin
      RetStr := RetStr + format (',HaveMaterialItem%d', [i]);
   end;
   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',HaveMarketItem%d', [i]);
   end;
   RetStr := RetStr + ',Person1';
   RetStr := RetStr + ',Person2';
   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',Key%d', [i]);
   end;
   RetStr := RetStr + ',CompleteQuestNo,CurrentQuestNo,QuestStr,FirstQuestNo';
   RetStr := RetStr + ',JobKind';   
   Result := RetStr;
end;

function TfrmMain.GetUserDataFields : String;
var
   i : Integer;
   RetStr : String;
begin
   RetStr := 'PrimaryKey,MasterName,Password,GroupKey,Guild,LastDate,CreateDate,Sex,Lover,ServerId,X,Y';
   RetStr := RetStr + ',Light,Dark,Energy,InPower,OutPower,Magic,Life,Talent,GoodChar';
   RetStr := RetStr + ',BadChar,Adaptive,Revival,Immunity,Virtue,CurEnergy,CurInPower';
   RetStr := RetStr + ',CurOutPower,CurMagic,CurLife,CurHealth,CurSatiety,CurPoisoning';
   RetStr := RetStr + ',CurHeadSeak,CurArmSeak,CurLegSeak,ExtraExp,AddableStatePoint,TotalStatePoint,CurrentGrade';

   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',BasicMagic%d', [i]);
   end;
   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',BasicRiseMagic%d', [i]);
   end;
   for i := 0 to 8 - 1 do begin
      RetStr := RetStr + format (',WearItem%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveItem%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveMagic%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveRiseMagic%d', [i]);
   end;
   for i := 0 to 30 - 1 do begin
      RetStr := RetStr + format (',HaveMysteryMagic%d', [i]);
   end;
   for i := 0 to 15 - 1 do begin
      RetStr := RetStr + format (',HaveBestSpecialMagic%d', [i]);
   end;
   for i := 0 to 5 - 1 do begin
      RetStr := RetStr + format (',HaveBestProtectMagic%d', [i]);
   end;
   for i := 0 to 5 - 1 do begin
      RetStr := RetStr + format (',HaveBestAttackMagic%d', [i]);
   end;
   
   for i := 0 to 5 - 1 do begin
      RetStr := RetStr + format (',HaveMaterialItem%d', [i]);
   end;
   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',HaveMarketItem%d', [i]);
   end;
   RetStr := RetStr + ',Person1';
   RetStr := RetStr + ',Person2,Person3,Person4';
   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',Key%d', [i]);
   end;
   RetStr := RetStr + ',CompleteQuestNo,CurrentQuestNo,QuestStr,FirstQuestNo';
   RetStr := RetStr + ',JobKind,ExtJobKind,CurJobExp';

   for i := 0 to 20 - 1 do begin
      RetStr := RetStr + format (',EventRecord%d', [i]);
   end;

   Result := RetStr;
end;

function TfrmMain.GetItemDataFields : String;
var
   i : Integer;
   RetStr : String;
begin
   RetStr := 'Name,No,Password';
   for i := 0 to 10 - 1 do begin
      RetStr := RetStr + format (',Item%d', [i]);
   end;
   Result := RetStr;
end;


procedure TfrmMain.AddTodayData (KeyValue, aStr : String);
var
   i : Integer;
   str, rdstr : String;
begin
   for i := 0 to TodayCharList.Count - 1 do begin
      str := TodayCharList.Strings [i];
      str := GetTokenStr (str, rdstr, ',');
      if rdstr = KeyValue then begin
         TodayCharList.Strings [i] := aStr;
         exit;
      end;
   end;
   TodayCharList.Add (aStr);
end;

procedure TfrmMain.AddWebData (KeyValue, aStr : String);
var
   i : Integer;
   str, rdstr : String;
begin
   for i := 0 to WebCharList.Count - 1 do begin
      str := WebCharList.Strings [i];
      str := GetTokenStr (str, rdstr, ',');
      if rdstr = KeyValue then begin
         WebCharList.Strings [i] := aStr;
         exit;
      end;
   end;
   WebCharList.Add (aStr);
end;

procedure TfrmMain.SaveTodayData (aFileName : String);
var
   FileName : String;
   mStr : String;
   boClear : Boolean;
begin
   if TodayCharList.Count = 0 then exit;

   if aFileName = '' then begin
      FileName := '.\UserData\Today.SDB';
      boClear := false;
   end else begin
      FileName := afileName;
      boClear := true;
   end;
   if FileExists (FileName) then begin
      DeleteFile (FileName);
   end;

   mStr := GetUserDataFields;
   TodayCharList.Insert (0, mStr);
   TodayCharList.SaveToFile (FileName);
   TodayCharList.Delete (0);

   if boClear = true then begin
      TodayCharList.Clear;
   end;
end;

procedure TfrmMain.SaveWebData (aFileName : String);
var
   FileName : String;
   mStr : String;
   boClear : Boolean;
begin
   if WebCharList.Count = 0 then exit;

   if aFileName = '' then begin
      FileName := '.\Web\Today.SDB';
      boClear := false;
   end else begin
      FileName := afileName;
      boClear := true;
   end;
   if FileExists (FileName) then begin
      DeleteFile (FileName);
   end;

   mStr := GetWebFields;
   WebCharList.Insert (0, mStr);
   WebCharList.SaveToFile (FileName);
   WebCharList.Delete (0);

   if boClear = true then begin
      WebCharList.Clear;
   end;
end;

procedure TfrmMain.cmdSaveUserDataClick(Sender: TObject);
begin
   SaveTodayData ('');
   SaveWebData ('');
end;

procedure TfrmMain.cmdBackupClick(Sender: TObject);
begin
   if Application.MessageBox ('Do you want to backup fdb file?', 'DB SERVER', MB_OKCANCEL) <> ID_OK then exit;

   BackupFDB;
end;

procedure TfrmMain.BackupFDB;
var
   FileName : String;
   mYear, mMonth, mDay : Word;
begin
   DecodeDate (Date, mYear, mMonth, mDay);
   if BackupStream <> nil then BackupStream.Free;
   FileName := format ('.\UserData\Backup%d-%d-%d.FDB', [mYear, mMonth, mDay]);
   if FileExists (FileName) then DeleteFile (FileName);
   BackupStream := TFileStream.Create (FileName, fmCreate);
   DBProvider.BackupHeader (BackupStream);

   boBackup := true;
   BackupPos := 0;

   cmdBackup.Enabled := false;
   cmdClose.Enabled := false;
end;

procedure TfrmMain.cmdReloadClick(Sender: TObject);
begin
   RemoteIPList.Clear;
   RemoteIPList.LoadFromFile ('.\RemoteIP.txt');

   RemoteUserList.Clear;
   RemoteUserList.LoadFromFile;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var CharData : TDBRecord;
    TmpBuf  : array[0 .. 5840 - 1] of byte;
begin
    Randomize;
    StrPCopy(@CharData.MasterName,IntToStr(Random(1000)));
    Move(CharData,TmpBuf,SizeOf(TmpBuf));
    ShowMessage(FloatToStr(oz_CRC32(@TmpBuf,SizeOf(TmpBuf))));
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  Packet: TRemotePacket;
begin
  // add by Orber at 2005-01-31 10:30:26
   if not RemoteConnector.Connected then begin
        RemoteConnector.Connect;
        WriteLogInfo1 (MyIP,'Reconnect To RemoteServer:DB','DB');
        AddEvent ('Reconnect To RemoteServer:DB');
   // add by minds at 2005-04-05 14:16
   end else begin
     if boRemoteResponse then begin
       Packet.Len := SizeOf(Word) + SizeOf(Byte) * 2;
       Packet.Cmd := REMOTE_CMD_NETSTAT;
       Packet.Result := REMOTE_RESULT_OK;
       RemoteConnector.AddSendData(@Packet, Packet.Len);
       boRemoteResponse := False;
     end else begin
       RemoteConnector.Connect;
       ItemRemoteConnector.Connect;
       exit;
     end;
   //
   end;

   if not ItemRemoteConnector.Connected then begin
        ItemRemoteConnector.Connect;
        WriteLogInfo1 (MyIP,'Reconnect To RemoteServer:ITEM','DB');
        AddEvent ('Reconnect To RemoteServer:ITEM');
   end;
end;



end.
