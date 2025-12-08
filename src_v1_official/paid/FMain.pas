unit FMain;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, IniFiles, adeftype, Barutil, AUtil32, ExtCtrls, Grids, uAnstick,
   UserSdb, deftype, Db, DBTables, ScktComp, uUtil, ComCtrls;

type
   TfrmMain = class (TForm)
      cmdClose: TButton;
      TimerProcess: TTimer;
      cmdReload: TButton;
      CheckBox1: TCheckBox;
      sckAccept: TServerSocket;
      pgMain: TPageControl;
      tsConnection: TTabSheet;
      tsInfo: TTabSheet;
      lstConnection: TListBox;
      lstInfo: TListBox;
      timerLoad: TTimer;
    lblNameCount: TLabel;
    lblIPCount: TLabel;
      procedure FormCreate(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure TimerProcessTimer(Sender: TObject);
      procedure cmdCloseClick(Sender: TObject);
      procedure cmdReloadClick(Sender: TObject);
      procedure sckAcceptAccept(Sender: TObject; Socket: TCustomWinSocket);
      procedure sckAcceptClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
      procedure sckAcceptClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
      procedure sckAcceptClientRead(Sender: TObject; Socket: TCustomWinSocket);
      procedure sckAcceptClientWrite(Sender: TObject; Socket: TCustomWinSocket);
      procedure timerLoadTimer(Sender: TObject);
   private
   public
   end;

   procedure AddConnection (aStr : String);
   procedure AddInfo (aStr : String);

var
   frmMain: TfrmMain;

   NoticeDate : String;

   BufferSizeS2S : Integer = 1024 * 64;
   BufferSizeS2C : Integer = 1024 * 16;
   ListenPort : Integer = 3049;

implementation

uses
   uConnect, uPaidDB;

{$R *.DFM}

procedure AddConnection (aStr : String);
begin
   if frmMain.lstConnection.Items.Count > 100 then begin
      frmMain.lstConnection.Items.Delete (0);
   end;
   frmMain.lstConnection.Items.Add (aStr);

   frmMain.lstConnection.ItemIndex := frmMain.lstConnection.Items.Count - 1;
end;

procedure AddInfo (aStr : String);
begin
   if frmMain.lstInfo.Items.Count > 100 then begin
      frmMain.lstInfo.Items.Delete (0);
   end;
   frmMain.lstInfo.Items.Add (aStr);

   frmMain.lstInfo.ItemIndex := frmMain.lstInfo.Items.Count - 1;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   i : Integer;
   pd : PTNameData;
   iniFile : TIniFile;
   Str, rdStr : String;
   NamePaidFileName, IPPaidFileName : String;
begin
   iniFile := TIniFile.Create ('.\Paid.ini');

   NoticeDate := iniFile.ReadString ('PAID', 'DATE', '');
   IpPaidFileName := IniFile.ReadString ('PAID','DIRECTORY_IPPAID', '.\ippaid.sdb');
   NamePaidFileName := IniFile.ReadString ('PAID','DIRECTORY_NAMEPAID', '.\namepaid.sdb');
   ListenPort := iniFile.ReadInteger ('PAID','PORT', 3049);

   {
   NameCount := IniFile.ReadInteger ('PAID','NAMECOUNT', 0);
   for i := 0 to NameCount - 1 do begin
      New (pd);
      pd^.IpList := TStringList.Create;

      pd^.Name := iniFile.ReadString ('PAID', 'NAME' + IntToStr (i), 'TEST');
      Str := iniFile.ReadString ('PAID', 'IP' + IntToStr (i), '127.0.0.1');
      while Str <> '' do begin
         Str := GetTokenStr (Str, rdstr, ',');
         if rdstr <> '' then begin
            pd^.IpList.Add (rdstr);
         end;
      end;
      pd^.Count := 0;
      NameList.Add (pd);
   end;
   }

   ConnectorList := TConnectorList.Create;
   PaidDB := TPaidDB.Create (NamePaidFileName, IPPaidFileName);

   lblNameCount.Caption := format ('Name Paid Count : %d', [PaidDB.NamePaidCount]);
   lblIPCount.Caption := format ('IP Paid Count : %d', [PaidDB.IPPaidCount]);

   sckAccept.Port := ListenPort;
   sckAccept.Active := true;

   timerProcess.Interval := 10;
   timerProcess.Enabled := true;

   timerLoad.Enabled := true;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
   i : integer;
   pd : PTNameData;
begin
   sckAccept.Active := false;
   timerProcess.Enabled := false;
   timerLoad.Enabled := false;

   PaidDB.Free;
   ConnectorList.Free;
end;

procedure TfrmMain.TimerProcessTimer(Sender: TObject);
begin
   ConnectorList.Update;
end;

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmMain.cmdReloadClick(Sender: TObject);
var
   i: integer;
   pi : PTNameData;
   Stream : TFileStream;
begin
   PaidDB.LoadFromFile;
end;

procedure TfrmMain.sckAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.CreateConnect (Socket);
   AddConnection (format ('%s Connected', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.DeleteConnect (Socket);
   AddConnection (format ('%s DisConnected', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
   ErrorCode := 0;
end;

procedure TfrmMain.sckAcceptClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   buffer : array [0..4096 - 1] of char;
   nRead : Integer;
begin
   if Socket.ReceiveLength > 0 then begin
      nRead := Socket.ReceiveBuf (buffer, 4096);
      if nRead > 0 then begin
         ConnectorList.AddReceiveData (Socket, @buffer, nRead);
      end;
   end;
end;

procedure TfrmMain.sckAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.SetWriteAllow (Socket);
end;

procedure TfrmMain.timerLoadTimer(Sender: TObject);
begin
   if not FileExists ('.\loadpaid.flg') then exit;

   AddInfo ('DB loading...');
   cmdReloadClick (Self);
   Sleep (1000);
   DeleteFile ('.\loadpaid.flg');

   lblNameCount.Caption := format ('Name Paid Count : %d', [PaidDB.NamePaidCount]);
   lblIPCount.Caption := format ('IP Paid Count : %d', [PaidDB.IPPaidCount]);
   
   AddInfo ('DB Loaded');
end;

end.
