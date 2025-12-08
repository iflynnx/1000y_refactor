unit FMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ScktComp, ExtCtrls, Grids, IniFiles, mmSystem;

type
  TConnectInfo = record
    Name : String [20];
    IpAddr : String [20];
    RequestCount : Integer;
  end;
  PTConnectInfo = ^TConnectInfo;

  TfrmMain = class(TForm)
    timerProcess: TTimer;
    sckAccept: TServerSocket;
    cmdClose: TButton;
    Label1: TLabel;
    grdList: TStringGrid;
    procedure cmdCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timerProcessTimer(Sender: TObject);
    procedure sckAcceptClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure sckAcceptClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sckAcceptAccept(Sender: TObject; Socket: TCustomWinSocket);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

  ConnectInfos : TList;
  ListenPort : Integer;
  BufferSizeS2S : Integer;
  BufferSizeS2C : Integer;

implementation

uses
   uConnect;

{$R *.DFM}

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   i, iCount : Integer;
   IniFile : TIniFile;
   pd : PTConnectInfo;
begin
   ConnectorList := TConnectorList.Create;
   ConnectInfos := TList.Create;

   IniFile := TIniFile.Create ('.\paid.ini');
   iCount := IniFile.ReadInteger ('PAID_SERVER', 'CLIENTCOUNT', 0);
   ListenPort := IniFile.ReadInteger ('PAID_SERVER', 'PORT', 5999);
   BufferSizeS2S := IniFile.ReadInteger ('PAID_SERVER', 'BUFFERSIZES2S', 1024 * 1024);
   BufferSizeS2C := IniFile.ReadInteger ('PAID_SERVER', 'BUFFERSIZES2C', 8192);
   for i := 0 to iCount - 1 do begin
      New (pd);
      pd^.Name := IniFile.ReadString ('CLIENT' + IntToStr (i), 'NAME', 'NONAME');
      pd^.IpAddr := IniFile.ReadString ('CLIENT' + IntToStr (i), 'REMOTEIP', '127.0.0.1');
      pd^.RequestCount := 0;

      ConnectInfos.Add (pd);
   end;
   IniFile.Free;

   grdList.FixedCols := 0;
   grdList.FixedRows := 1;
   grdList.ColCount := 3;
   grdList.RowCount := iCount + 1 + 10;
   grdList.ColWidths [0] := 76;
   grdList.ColWidths [1] := 76;
   grdList.ColWidths [2] := 25;

   grdList.Cells [0, 0] := 'Name';
   grdList.Cells [1, 0] := 'Request';
   grdList.Cells [2, 0] := 'St';

   for i := 0 to ConnectInfos.Count - 1 do begin
      pd := ConnectInfos.Items [i];
      grdList.Cells [0, i + 1] := pd^.Name;
      grdList.Cells [1, i + 1] := IntToStr (pd^.RequestCount);
      grdList.Cells [2, i + 1] := 'Off';
   end;

   timerProcess.Interval := 10;
   timerProcess.Enabled := true;

   Top := 0;
   Left := 0;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
   i : Integer;
   pd : PTConnectInfo;
begin
   for i := 0 to ConnectInfos.Count - 1 do begin
      pd := ConnectInfos.Items [i];
      Dispose (pd);
   end;
   ConnectInfos.Clear;
   ConnectInfos.Free;
   ConnectorList.Free;
end;

procedure TfrmMain.timerProcessTimer(Sender: TObject);
begin
   ConnectorList.Update;
end;

procedure TfrmMain.sckAcceptClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.DeleteConnect (Socket);
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
   nTotalCount, nRead : Integer;
begin
   nTotalCount := Socket.ReceiveLength;
   if nTotalCount > 0 then begin
      if nTotalCount > 8192 then nTotalCount := 8192;
      nRead := Socket.ReceiveBuf (buffer, nTotalCount);
      ConnectorList.AddReceiveData (Socket, @buffer, nRead);
   end;
end;

procedure TfrmMain.sckAcceptClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.SetWriteAllow (Socket);
end;

procedure TfrmMain.sckAcceptAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
   ConnectorList.CreateConnect (Socket);
end;

end.
