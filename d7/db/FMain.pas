unit FMain;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ScktComp, StdCtrls, ComCtrls, iniFiles, mmSystem, ExtCtrls,
    uKeyClass, deftype, DB, ADODB, Menus;

type
    TfrmMain = class(TForm)
        PageControl1: TPageControl;
        tsEvent: TTabSheet;
        tsMonitor: TTabSheet;
        txtLog: TMemo;
        sckAccept: TServerSocket;
        tsStatus: TTabSheet;
        timerDisplay: TTimer;
        timerProcess: TTimer;
        StaticText7: TStaticText;
        lblGateConnectCount: TStaticText;
        StaticText11: TStaticText;
        lblElaspedTime: TStaticText;
        ADOConnectionSQL: TADOConnection;
        sckPaid: TServerSocket;
        TabSheet3: TTabSheet;
        Button5: TButton;
        Button6: TButton;
        ADOQuery1: TADOQuery;
        Memo1: TMemo;
        CheckBox_SQLandDB: TCheckBox;
        Edit_SQLandDB_user_name: TEdit;
        Label3: TLabel;
        CheckBox_SQLANDDB_UPDATE: TCheckBox;
        Button7: TButton;
        Button8: TButton;
        Button9: TButton;
        Button10: TButton;
        MainMenu1: TMainMenu;
        N1: TMenuItem;
        NMenuUser: TMenuItem;
        NMenuLogin: TMenuItem;
        NMenuEmail: TMenuItem;
        NMenuAuction: TMenuItem;
        NMenuPaid: TMenuItem;
        PageControl2: TPageControl;
        N7: TMenuItem;
        N8: TMenuItem;
        lstEvent: TMemo;
        lblUserDbCount: TStaticText;
        lUserDbCount: TStaticText;
        lblEmailDbCount: TStaticText;
        lEmailDbCount: TStaticText;
        lblAuctionDbCount: TStaticText;
        lAuctionDbCount: TStaticText;
        lblPaidDbCount: TStaticText;
        lPaidDbCount: TStaticText;
        lLoginDbCount: TStaticText;
        lblLoginDbCount: TStaticText;
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
        procedure timerDisplayTimer(Sender: TObject);
        procedure timerProcessTimer(Sender: TObject);
        procedure sckItemRemoteClientError(Sender: TObject;
            Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
            var ErrorCode: Integer);
        procedure sckPaidAccept(Sender: TObject; Socket: TCustomWinSocket);
        procedure sckPaidClientConnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckPaidClientDisconnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckPaidClientError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; var ErrorCode: Integer);
        procedure sckPaidClientRead(Sender: TObject; Socket: TCustomWinSocket);
        procedure sckPaidClientWrite(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure Button5Click(Sender: TObject);
        procedure Button6Click(Sender: TObject);
        procedure Button7Click(Sender: TObject);
        procedure Button8Click(Sender: TObject);
        procedure NMenuUserClick(Sender: TObject);
        procedure NMenuLoginClick(Sender: TObject);
   //     procedure NMenuEmailClick(Sender: TObject);
        procedure NMenuPaidClick(Sender: TObject);
        procedure NMenuAuctionClick(Sender: TObject);
        procedure N8Click(Sender: TObject);
    private
        { Private declarations }

    public
        { Public declarations }
        procedure AddEvent(aStr: string);
        procedure AddLog(aStr: string);

    end;

var
    frmMain: TfrmMain;

    ElaspedSec, StartTick: Integer;
   // FDBFileName: string;
    BufferSizeDataSend: Integer;
    BufferSizeDataReceive: Integer;

    BufferSizePaidSend: Integer;
    BufferSizePaidReceive: Integer;
    PaidAcceptPort
        , DBAcceptPort
       // , RemoteAcceptPort
       // , ItemRemoteAcceptPort
    : Integer;

  //  sqldbname, sqlip, sqlusername, sqlpassword: string;

implementation

uses
    uConnector,  uPaidConnector, uDBAdapter, frmuser
    , frmLogin, frmpaid, frmAuction ;

{$R *.DFM}

procedure TfrmMain.AddEvent(aStr: string);
begin
    if lstEvent.Lines.Count > 100 then lstEvent.Lines.Clear;
    lstEvent.Lines.Add(aStr);
end;

procedure TfrmMain.AddLog(aStr: string);
begin
    if txtLog.Lines.Count > 1000 then txtLog.Lines.Clear;
    txtLog.Lines.Add(aStr);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
    boFlag: Boolean;
    iniFile: TIniFile;
    str: string;
begin
    AddLog(format('DB Server Started %s %s', [DateToStr(Date), TimeToStr(Time)]));

    ElaspedSec := 0;
    StartTick := timeGetTime;
{$IFDEF boLogin}

{$ENDIF}
{$IFDEF bodb}
    if FileExists('.\DB.INI') = FALSE then
    begin
        iniFile := TIniFile.Create('.\DB.INI');
        try
            iniFile.WriteInteger('DB_SERVER', 'BufferSizeDataReceive', 1024 * 1024);
            iniFile.WriteInteger('DB_SERVER', 'BufferSizeDataSend', 1024 * 1024);
            iniFile.WriteInteger('DB_SERVER', 'BufferSizePaidReceive', 1024 * 1024);
            iniFile.WriteInteger('DB_SERVER', 'BufferSizePaidSend', 1024 * 1024);

            iniFile.WriteInteger('DB_SERVER', 'DBAcceptPort', 3051);
            iniFile.WriteInteger('DB_SERVER', 'PaidAcceptPort', 5999);
        finally
            iniFile.Free;
        end;
    end;
    iniFile := TIniFile.Create('.\DB.INI');

    try

        BufferSizeDataReceive := iniFile.ReadInteger('DB_SERVER', 'BufferSizeDataReceive', 1024 * 1024);
        BufferSizeDataSend := iniFile.ReadInteger('DB_SERVER', 'BufferSizeDataSend', 1024 * 1024);
        BufferSizePaidReceive := iniFile.ReadInteger('DB_SERVER', 'BufferSizePaidReceive', 1024 * 1024);
        BufferSizePaidSend := iniFile.ReadInteger('DB_SERVER', 'BufferSizePaidSend', 1024 * 1024);

        DBAcceptPort := iniFile.ReadInteger('DB_SERVER', 'DBAcceptPort', 3051);
        PaidAcceptPort := iniFile.ReadInteger('DB_SERVER', 'PaidAcceptPort', 5999);
    finally
        iniFile.Free;
    end;

{$ENDIF}


    ConnectorList := TConnectorList.Create;

    sckAccept.Port := dbAcceptPort;
    sckAccept.Active := true;

    timerDisplay.Interval := 1000;
    timerDisplay.Enabled := true;

    timerProcess.Interval := 10;
    timerProcess.Enabled := true;

    //  Provider=MSDASQL.1;Persist Security Info=False;Data Source=account1000y;Initial Catalog=1000y
{    str := format('Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s'
        , [sqlpassword, sqlusername, sqldbname, sqlip]);
    ADOConnectionSQL.ConnectionString := str;
    ADOConnectionSQL.Connected := true;
 }
    NMenuLogin.Visible := false;
    NMenuUser.Visible := false;
    NMenuEmail.Visible := false;
    NMenuAuction.Visible := false;
    NMenuPaid.Visible := false;
    Caption := '';
    LoginDBAdapter := nil;
    UserDBAdapter := nil;
    PaidDBAdapter := nil;
    AuctionDBAdapter := nil;
    EmailDBAdapter := nil;
    PaidConnectorlist := nil;
    lLoginDbCount.Visible := false;
    lblLoginDbCount.Visible := false;
    lUserDbCount.Visible := false;
    lblUserDbCount.Visible := false;
    lEmailDbCount.Visible := false;
    lblEmailDbCount.Visible := false;
    lAuctionDbCount.Visible := false;
    lblAuctionDbCount.Visible := false;
    lPaidDbCount.Visible := false;
    lblPaidDbCount.Visible := false;

{$IFDEF boLogin}
    LoginDBAdapter := TLoginDBAdapter.Create;
    NMenuLogin.Visible := true;
    Caption := '[Login]';
    lLoginDbCount.Visible := true;
    lblLoginDbCount.Visible := true;
{$ENDIF}
{$IFDEF bodb}
    Caption := Caption + '[Db]';
    UserDBAdapter := TUserDBAdapter.Create;


   PaidDBAdapter := TPaidDBAdapter.Create;
    sckPaid.Port := PaidAcceptPort;
     sckPaid.Active := true;
       PaidConnectorlist := TPaidConnectorlist.Create;


        
    AuctionDBAdapter := TAuctionDBAdapter.Create;
    EmailDBAdapter := TEmailDBAdapter.Create;

   
    NMenuUser.Visible := true;
    NMenuEmail.Visible := true;
    NMenuAuction.Visible := true;
    NMenuPaid.Visible := true;
    lUserDbCount.Visible := true;
    lblUserDbCount.Visible := true;
    lEmailDbCount.Visible := true;
    lblEmailDbCount.Visible := true;
    lAuctionDbCount.Visible := true;
    lblAuctionDbCount.Visible := true;
    lPaidDbCount.Visible := true;
    lblPaidDbCount.Visible := true;
{$ENDIF}
    Caption := Caption + 'Server';
//    SQLDBAdapter := TSQlDBAdapter.Create(ADOConnectionSQL);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

    if sckAccept.Active = true then
    begin
        sckAccept.Socket.Close;
    end;

    timerDisplay.Enabled := false;
    timerProcess.Enabled := false;

    ConnectorList.Free;
   // SQLDBAdapter.Free;
    if PaidConnectorList <> nil then PaidConnectorlist.Free;
    if UserDBAdapter <> nil then UserDBAdapter.Free;
    if LoginDBAdapter <> nil then LoginDBAdapter.Free;
    if PaidDBAdapter <> nil then PaidDBAdapter.Free;
    if AuctionDBAdapter <> nil then AuctionDBAdapter.Free;
    if EmailDBAdapter <> nil then EmailDBAdapter.free;
end;

procedure TfrmMain.timerDisplayTimer(Sender: TObject);
var
    CurTick: Integer;
    FileName: string;
    nYear, nMonth, nDay: Word;
    mYear, mMonth, mDay: Word;
begin
    CurTick := timeGetTime;

    if CurTick >= StartTick + 1000 then
    begin
        ElaspedSec := ElaspedSec + 1;
        StartTick := CurTick;
    end;

    lblElaspedTime.Caption := IntToStr(ElaspedSec);
    lblGateConnectCount.Caption := IntToStr(ConnectorList.Count);
    if LoginDBAdapter <> nil then
        lblLoginDbCount.Caption := inttostr(LoginDBAdapter.count);
    if UserDBAdapter <> nil then
        lblUserDbCount.Caption := inttostr(UserDBAdapter.count);
    if EmailDBAdapter <> nil then
        lblEmailDbCount.Caption := inttostr(EmailDBAdapter.count);
    if AuctionDBAdapter <> nil then
        lblAuctionDbCount.Caption := inttostr(AuctionDBAdapter.count);
    if PaidDBAdapter <> nil then
        lblPaidDbCount.Caption := inttostr(PaidDBAdapter.count);
end;

procedure TfrmMain.timerProcessTimer(Sender: TObject);
var
    CurTick: Integer;
begin
    CurTick := timeGetTime;
    if ConnectorList <> nil then ConnectorList.Update(CurTick);
    if PaidConnectorList <> nil then PaidConnectorList.Update(CurTick);
end;

procedure TfrmMain.cmdCloseClick(Sender: TObject);
begin
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmMain.sckAcceptAccept(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    ConnectorList.CreateConnect(Socket);
    AddLog(format('Gate Server Accepted %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientConnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
 if Socket.RemoteAddress<>'127.0.0.1' then Socket.Close;
    //
end;

procedure TfrmMain.sckAcceptClientDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    ConnectorList.DeleteConnect(Socket);
    AddLog(format('Gate Server Disconnected %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckAcceptClientError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
begin
    AddLog(format('Gate Server Accept Socket Error (%d, %s)', [ErrorCode, Socket.RemoteAddress]));
    ErrorCode := 0;
    Socket.Close;
end;

procedure TfrmMain.sckAcceptClientRead(Sender: TObject;
    Socket: TCustomWinSocket);
var
    nRead: Integer;
    buffer: array[0..65535] of byte;
begin
    //3051
    nRead := Socket.ReceiveBuf(buffer, 65535);
    if nRead > 0 then
    begin
        ConnectorList.AddReceiveData(Socket, @buffer, nRead);
        exit;
    end;
end;

procedure TfrmMain.sckAcceptClientWrite(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    ConnectorList.SetWriteAllow(Socket);
end;

procedure TfrmMain.sckItemRemoteClientError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
begin
    ErrorCode := 0;
end;

procedure TfrmMain.sckPaidAccept(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    PaidConnectorList.CreateConnect(Socket);
    AddLog(format('Paid Server Accepted %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckPaidClientConnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
if Socket.RemoteAddress<>'127.0.0.1' then Socket.Close;    //
end;

procedure TfrmMain.sckPaidClientDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    PaidConnectorList.DeleteConnect(Socket);
    AddLog(format('Paid Server Disconnected %s', [Socket.RemoteAddress]));
end;

procedure TfrmMain.sckPaidClientError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
begin
    AddLog(format('Paid Server Paid Socket Error (%d, %s)', [ErrorCode, Socket.RemoteAddress]));
    ErrorCode := 0;
    Socket.Close;
end;

procedure TfrmMain.sckPaidClientRead(Sender: TObject;
    Socket: TCustomWinSocket);
var
    nRead: Integer;
    buffer: array[0..deftype_MAX_PACK_SIZE] of byte;
begin
    //3051
    nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
    if nRead > 0 then
    begin
        PaidConnectorList.AddReceiveData(Socket, @buffer, nRead);
        exit;
    end;
end;

procedure TfrmMain.sckPaidClientWrite(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    PaidConnectorList.SetWriteAllow(Socket);
end;

function isbuf(abuf, abuf2: pointer; asize: integer; out strout: string): boolean;
var
    i: integer;
    pb, pb2: pbyte;
begin
    result := false;
    pb := abuf;
    pb2 := abuf2;
    for i := 0 to asize - 1 do
    begin
        if pb^ <> pb2^ then
        begin
            strout := '[位置]' + inttostr(i) + '/' + inttostr(asize);
            exit;
        end;
        inc(pb);
        inc(pb2);
    end;
    result := true;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
{var
    tempstrList: tstringlist;
    i: integer;
    sname, str: string;
    tempTDBRecord: TDBRecord;
    tempTDBRecord2: TDBRecord;
    fresult: byte;
    procedure _sqlToDb();
    begin
        fillchar(tempTDBRecord, sizeof(tempTDBRecord), 0);
        if SQLDBAdapter.UserSelect(sname, @tempTDBRecord) <> DB_OK then
        begin
            Memo1.Lines.Add('[' + sname + ']SQL读出失败');
            exit;
        end;

        fresult := UserDBAdapter.UserInsert(sname, @tempTDBRecord);

        if (fresult <> DB_OK) and CheckBox_SQLANDDB_UPDATE.Checked then
            fresult := UserDBAdapter.UserUpdate(sname, @tempTDBRecord);

        if fresult = DB_OK then
        begin
            Memo1.Lines.Add('[' + sname + ']转换成功');
            fillchar(tempTDBRecord2, sizeof(tempTDBRecord2), 0);
            if UserDBAdapter.UserSelect(sname, @tempTDBRecord2) <> DB_OK then
            begin
                Memo1.Lines.Add('[' + sname + ']UserDB效验 读出失败');
                exit;
            end;
            if isbuf(@tempTDBRecord, @tempTDBRecord2, sizeof(tempTDBRecord), str) = false then
            begin
                Memo1.Lines.Add('[' + sname + ']UserDB效验 发现错误 ' + str);
            end;
        end else
        begin
            if fresult = DB_ERR_DUPLICATE then
                Memo1.Lines.Add('[' + sname + ']UserDB写入失败-数据存在')
            else
                Memo1.Lines.Add('[' + sname + ']UserDB写入失败');
        end;
    end;
    }
begin
{    if CheckBox_SQLandDB.Checked then
    begin
        tempstrList := tstringlist.Create;
        try

            tempstrList.Text := SQLDBAdapter.UserSelectAllName;
            Memo1.Lines.Text := tempstrList.Text;
            for i := 0 to tempstrList.Count - 1 do
            begin
                sname := tempstrList.Strings[i];
                _sqlToDb;
                // sleep(1000);
                Application.ProcessMessages;
            end;

        finally
            tempstrList.Free;
        end;
    end else
    begin
        sname := Edit_SQLandDB_user_name.Text;
        _sqlToDb;
    end;
 }
end;

procedure TfrmMain.Button6Click(Sender: TObject);
{var
    tempstrList: tstringlist;
    i: integer;
    sname: string;
    tempTDBRecord: TDBRecord;
    fresult: byte;
    procedure _DbtoSql();
    begin
        if UserDBAdapter.UserSelect(sname, @tempTDBRecord) <> DB_OK then
        begin
            Memo1.Lines.Add('[' + sname + ']UserDB读出失败');
            exit;
        end;
        fresult := SQLDBAdapter.UserInsert(sname, @tempTDBRecord);
        if (fresult <> DB_OK) and CheckBox_SQLANDDB_UPDATE.Checked then
            fresult := SQLDBAdapter.UserUpdate(sname, @tempTDBRecord);

        if fresult = DB_OK then
        begin
            Memo1.Lines.Add('[' + sname + ']SQL转换成功');
        end else
        begin
            if fresult = DB_ERR_DUPLICATE then
                Memo1.Lines.Add('[' + sname + ']SQL写入失败-数据存在')
            else
                Memo1.Lines.Add('[' + sname + ']SQL写入失败');
        end;
    end;
    }
begin
    {
        if CheckBox_SQLandDB.Checked then
        begin
            tempstrList := tstringlist.Create;
            try
                tempstrList.Text := UserDBAdapter.UserSelectAllName;
                Memo1.Lines.Text := tempstrList.Text;
                for i := 0 to tempstrList.Count - 1 do
                begin
                    sname := tempstrList.Strings[i];
                    _DbtoSql;
                    Application.ProcessMessages;

                end;

            finally
                tempstrList.Free;
            end;
        end else
        begin
            sname := Edit_SQLandDB_user_name.Text;
            _DbtoSql;
        end;
        }
end;

procedure TfrmMain.Button7Click(Sender: TObject);
{var
    tempstrList: tstringlist;
    i: integer;
    sname, str: string;
    tempTLGRecord: TLGRecord;
    tempTLGRecord2: TLGRecord;
    fresult: byte;
    procedure _sqlToDb();
    begin

        fillchar(tempTLGRecord, sizeof(tempTLGRecord), 0);
        if SQLDBAdapter.LG_Select(sname, @tempTLGRecord) <> DB_OK then
        begin
            Memo1.Lines.Add('[' + sname + ']SQL读出失败');
            exit;
        end;

        fresult := LoginDBAdapter.Insert(sname, @tempTLGRecord);

        if (fresult <> DB_OK) and CheckBox_SQLANDDB_UPDATE.Checked then
            fresult := LoginDBAdapter.Update(sname, @tempTLGRecord);

        if fresult = DB_OK then
        begin
            Memo1.Lines.Add('[' + sname + ']转换成功');
            fillchar(tempTLGRecord2, sizeof(tempTLGRecord2), 0);
            if LoginDBAdapter.Select(sname, @tempTLGRecord2) <> DB_OK then
            begin
                Memo1.Lines.Add('[' + sname + ']LoginDB效验 读出失败');
                exit;
            end;
            if isbuf(@tempTLGRecord, @tempTLGRecord2, sizeof(tempTLGRecord2), str) = false then
            begin
                Memo1.Lines.Add('[' + sname + ']LoginDB效验 发现错误 ' + str);
            end;
        end else
        begin
            if fresult = DB_ERR_DUPLICATE then
                Memo1.Lines.Add('[' + sname + ']LoginDB写入失败-数据存在')
            else
                Memo1.Lines.Add('[' + sname + ']LoginDB写入失败');
        end;
    end;
    }
begin
{    if CheckBox_SQLandDB.Checked then
    begin
        tempstrList := tstringlist.Create;
        try

            tempstrList.Text := SQLDBAdapter.Lg_SelectAllName;
            Memo1.Lines.Text := tempstrList.Text;
            for i := 0 to tempstrList.Count - 1 do
            begin
                sname := tempstrList.Strings[i];
                _sqlToDb;
                // sleep(1000);
                Application.ProcessMessages;
            end;

        finally
            tempstrList.Free;
        end;
    end else
    begin
        sname := Edit_SQLandDB_user_name.Text;
        _sqlToDb;
    end;
  }
end;

procedure TfrmMain.Button8Click(Sender: TObject);
{var
    tempstrList: tstringlist;
    i: integer;
    sname, str: string;
    tempRecord: TPaidData;
    tempRecord2: TPaidData;
    fresult: byte;
    procedure _sqlToDb();
    begin

        fillchar(tempRecord, sizeof(tempRecord), 0);
        tempRecord.rLoginId := sname;
        if SQLDBAdapter.Paid_Select(@tempRecord) = false then
        begin
            Memo1.Lines.Add('[' + sname + ']SQL读出失败');
            exit;
        end;

        fresult := PaidDBAdapter.Insert(sname, @tempRecord);

        if (fresult <> DB_OK) and CheckBox_SQLANDDB_UPDATE.Checked then
            fresult := PaidDBAdapter.Update(sname, @tempRecord);

        if fresult = DB_OK then
        begin
            Memo1.Lines.Add('[' + sname + ']转换成功');
            fillchar(tempRecord2, sizeof(tempRecord2), 0);
            if PaidDBAdapter.Select(sname, @tempRecord2) <> DB_OK then
            begin
                Memo1.Lines.Add('[' + sname + ']Paid效验 读出失败');
                exit;
            end;
            if isbuf(@tempRecord, @tempRecord2, sizeof(tempRecord), str) = false then
            begin
                Memo1.Lines.Add('[' + sname + ']Paid效验 发现错误 ' + str);
            end;
        end else
        begin
            if fresult = DB_ERR_DUPLICATE then
                Memo1.Lines.Add('[' + sname + ']Paid写入失败-数据存在')
            else
                Memo1.Lines.Add('[' + sname + ']Paid写入失败');
        end;
    end;
    }
begin
{    if CheckBox_SQLandDB.Checked then
    begin
        tempstrList := tstringlist.Create;
        try

            tempstrList.Text := SQLDBAdapter.Paid_SelectAllName;
            Memo1.Lines.Text := tempstrList.Text;
            for i := 0 to tempstrList.Count - 1 do
            begin
                sname := tempstrList.Strings[i];
                _sqlToDb;
                // sleep(1000);
                Application.ProcessMessages;
            end;

        finally
            tempstrList.Free;
        end;
    end else
    begin
        sname := Edit_SQLandDB_user_name.Text;
        _sqlToDb;
    end;
}
end;

procedure TfrmMain.NMenuUserClick(Sender: TObject);
begin

    formuser := TFormUser.Create(self);
    try
        formuser.Top := 103;
        formuser.Left := 176;
        formuser.ShowModal;
    finally
        formuser.Free;
    end;


end;

procedure TfrmMain.NMenuLoginClick(Sender: TObject);
begin
    FormLogin := TFormLogin.Create(self);
    try
        FormLogin.Left := 192;
        FormLogin.Top := 112;
        FormLogin.ShowModal;
    finally
        FormLogin.Free;
    end;
end;



procedure TfrmMain.NMenuPaidClick(Sender: TObject);
begin
    FormPaid := TFormPaid.Create(Self);
    try
        FormPaid.Left := 192;
        FormPaid.Top := 112;
        FormPaid.ShowModal;

    finally
        FormPaid.Free;
    end;
end;

procedure TfrmMain.NMenuAuctionClick(Sender: TObject);
begin
    FormAuction := TFormAuction.Create(Self);
    try
        FormAuction.ShowModal;
        FormAuction.Left := 192;
        FormAuction.Top := 112;
    finally
        FormAuction.Free;
    end;
end;

procedure TfrmMain.N8Click(Sender: TObject);
begin

    if Application.MessageBox('你真的要退出吗?', 'DB SERVER', MB_OKCANCEL) <> ID_OK then exit;
    Close;
end;

end.

