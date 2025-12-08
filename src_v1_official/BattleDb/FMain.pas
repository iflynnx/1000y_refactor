unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ScktComp, Grids, IniFiles;

type
  TFrmMain = class(TForm)
    sckAccept: TServerSocket;
    timerProcess: TTimer;
    lstComment: TListBox;
    cmdClose: TButton;
    timerSave: TTimer;
    cmdInit: TButton;
    cmdSave: TButton;
    lstResult1: TListBox;
    cmdTest: TButton;
    lstResult2: TListBox;
    lstResult3: TListBox;
    lstResult4: TListBox;
    lstResult5: TListBox;
    lstResult6: TListBox;
    cmdDisplay: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sckAcceptAccept(Sender: TObject;
      Socket: TCustomWinSocket);
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
    procedure timerProcessTimer(Sender: TObject);
    procedure cmdCloseClick(Sender: TObject);
    procedure timerSaveTimer(Sender: TObject);
    procedure cmdInitClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure cmdTestClick(Sender: TObject);
    procedure cmdDisplayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddLog (aStr : String);
    procedure AddResult (aAge : Integer; aStr : String);
    procedure ClearResult (aAge : Integer);
  end;

var
  FrmMain: TFrmMain;

  BufferSizeS2S : Integer = 1048576;
  BufferSizeS2C : Integer = 8192;

  BattleDBPort : Integer = 3039;
  BattleDBFile : String = '.\DATA\BATTLEDATA.SDB';
  BattleDBServerListFile : String = '.\DATA\BATTLESERVERDATA.SDB';
  BattleDBMagicListFile : string = '.\DATA\BATTLEMAGICDATA.SDB';
  BattleDBCalTableFile : string = '.\DATA\BATTLECALTABLE.SDB';

  BattleDBDisConnectPoint : Integer = 3;
  BattleDBServerPoint : Integer = 1;

  CurDate : TDateTime;
  SaveTick : Integer;

implementation

uses
   uConnect, uBattleDB, uServerList, uMagicList, uBattleTable;

{$R *.DFM}

procedure TfrmMain.AddLog (aStr : String);
begin
   if lstComment.Items.Count > 1000 then begin
      lstComment.Items.Delete (0);
   end;
   lstComment.Items.Add (aStr);
   lstComment.ItemIndex := lstComment.Items.Count - 1;
end;

procedure TfrmMain.ClearResult (aAge : Integer);
begin
   Case aAge of
      3000..3999 :
         begin
            lstResult1.Clear;
         end;
      4000..4499 :
         begin
            lstResult2.Clear;
         end;
      4500..4999 :
         begin
            lstResult3.Clear;
         end;
      5000..5499 :
         begin
            lstResult4.Clear;
         end;
      5500..9999 :
         begin
            lstResult5.Clear;
         end;
      0 :
         begin
            lstResult6.Clear;
         end;
   end;
end;

procedure TfrmMain.AddResult (aAge : Integer; aStr : String);
begin
   Case aAge of
      3000..3999 :
         begin
            lstResult1.Items.Add (aStr);
         end;
      4000..4499 :
         begin
            lstResult2.Items.Add (aStr);
         end;
      4500..4999 :
         begin
            lstResult3.Items.Add (aStr);
         end;
      5000..5499 :
         begin
            lstResult4.Items.Add (aStr);
         end;
      5500..9999 :
         begin
            lstResult5.Items.Add (aStr);
         end;
      0 :
         begin
            lstResult6.Items.Add (aStr);
         end;
   end;

   // lstResult6.Items.Add (aStr);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
   iniFile : TIniFile;
   Str, Title : String;
   i, iNo, nStart, nEnd : Integer;
begin
   CurDate := Date;

   BattleDB := TBattleDB.Create;

   iniFile := TIniFile.Create ('.\BattleDB.INI');
   BattleDBPort := iniFile.ReadInteger ('SERVER', 'LOCALPORT', 3039);
   BufferSizeS2S := iniFile.ReadInteger ('SERVER', 'BUFFERSIZES2S', 1048576);
   BufferSizeS2C := iniFile.ReadInteger ('SERVER', 'BUFFERSIZES2C', 8192);
   BattleDBFile := iniFile.ReadString ('SERVER', 'FILENAME', '.\DATA\BATTLEDATA.SDB');
   BattleDBServerListFile := iniFile.ReadString ('SERVER', 'SERVERLISTFILE', '.\DATA\BATTLESERVERDATA.SDB');
   BattleDBMagicListFile := iniFile.ReadString ('SERVER', 'MAGICLISTFILE', '.\DATA\BATTLEMAGICDATA.SDB');
   BattleDBCalTableFile := iniFile.ReadString ('SERVER', 'TABLEFILENAME', '.\DATA\BATTLECALTABLE.SDB');

   BattleDBDisConnectPoint := iniFile.ReadInteger ('POINT', 'DISCONNECTPOINT', 3);
   BattleDBServerPoint := iniFile.ReadInteger ('POINT', 'SERVERPOINT', 1);

   iNo := iniFile.ReadInteger ('BATTLEGROUP', 'COUNT', 0);
   for i := 0 to iNo - 1 do begin
      Str := format ('TITLE%d', [i]);
      Title := iniFile.ReadString ('BATTLEGROUP', Str, '');
      Str := format ('STARTAGE%d', [i]);
      nStart := iniFile.ReadInteger ('BATTLEGROUP', Str, -1);
      Str := format ('ENDAGE%d', [i]);
      nEnd := iniFile.ReadInteger ('BATTLEGROUP', Str, -1);

      if (nStart < 0) or (nEnd < 0) then break;

      BattleDB.AddGroup (Title, nStart, nEnd);
   end;

   iniFile.Free;

   if not FileExists (BattleDBFile) then begin
      ShowMessage (format ('cannot open %s', [BattleDBFile]));
      exit;
   end;

   BattleDB.LoadFromFile (BattleDBFile);

   MagicList := TMagicList.Create;
   MagicList.LoadFromFile (BattleDBMagicListFile);

   ServerList := TServerList.Create;
   ServerList.LoadFromFile (BattleDBServerListFile);

   BattleTable := TBattleTable.Create;
   BattleTable.LoadFromFile (BattleDBCalTableFile);

   sckAccept.Port := BattleDBPort;
   sckAccept.Active := true;

   timerProcess.Interval := 10;
   timerProcess.Enabled := true;

   timerSave.Interval := 1000;
   timerSave.Enabled := true;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
   timerProcess.Enabled := false;
   timerSave.Enabled := false;
   sckAccept.Active := false;

   if BattleDB <> nil then BattleDB.Free;
   if ServerList <> nil then ServerList.Free;
end;

procedure TFrmMain.sckAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectList.CreateConnect (Socket);
   AddLog (format ('BattleServer (%s) Connected', [Socket.RemoteAddress]));
end;

procedure TFrmMain.sckAcceptClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//
end;

procedure TFrmMain.sckAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectList.DeleteConnect (Socket);
   AddLog (format ('BattleServer (%s) DisConnected', [Socket.RemoteAddress]));
end;

procedure TFrmMain.sckAcceptClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   ErrorCode := 0;
end;

procedure TFrmMain.sckAcceptClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   nRead : Integer;
   Buffer : array [0..4096 - 1] of Char;
begin
   nRead := Socket.ReceiveBuf (Buffer, 4096);
   if nRead > 0 then begin
      ConnectList.AddReceiveData (Socket, @Buffer, nRead);
   end;
end;

procedure TFrmMain.sckAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectList.SetAllowWrite (Socket);
end;

procedure TFrmMain.timerProcessTimer(Sender: TObject);
begin
   ConnectList.Update;
end;

procedure TFrmMain.cmdCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TFrmMain.timerSaveTimer(Sender: TObject);
begin
   if CurDate <> Date then begin
      if BattleDB <> nil then begin
         BattleDB.SaveToSDB (BattleDBFile);
         ServerList.SaveToSDB (BattleDBServerListFile);
      end;
      CurDate := Date;
   end;
end;

procedure TFrmMain.cmdInitClick(Sender: TObject);
begin
   if BattleDB <> nil then begin
      BattleDB.Clear;
      BattleDB.SaveToSDB (BattleDBFile);
   end;
end;

procedure TFrmMain.cmdSaveClick(Sender: TObject);
begin
   if BattleDB <> nil then begin
      BattleDB.SaveToSDB (BattleDBFile);
      ServerList.SaveToSDB (BattleDBServerListFile);
   end;
end;

procedure TFrmMain.cmdTestClick(Sender: TObject);
begin
   // BattleDB.Test;
end;

procedure TFrmMain.cmdDisplayClick(Sender: TObject);
begin
   BattleDB.DisplayCurrentScore;
end;

end.
