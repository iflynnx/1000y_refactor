unit uDM;

interface

uses
  SysUtils, Classes, ImgList, db,
  Controls, Dialogs, OleCtrls, SHDocVw, MSHTML, StdCtrls, ActiveX, DBClient,
  MyAccess, MemDS, DBAccess, IniFiles, SVMain;

type

  Tdm = class(TDataModule)
    MyConn: TMyConnection;
    Query: TMyQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure MyConnError(Sender: TObject; E: EDAError; var Fail: Boolean);
  private
    FConfig: TIniFile;
  public
    function Connect: Boolean;
    class procedure CreateDM;

  end;

var
  dm: Tdm;

implementation



{$R *.dfm}





function Tdm.Connect: Boolean;
var
  mysql: TMyQuery;
begin
  Result := True;
  MyConn.Close;
  MyConn.LoginPrompt := False;
  try
    MyConn.Server := FConfig.ReadString('DB_SERVER', 'Server', '');
    MyConn.Database := FConfig.ReadString('DB_SERVER', 'Database', '');
    MyConn.Port := FConfig.ReadInteger('DB_SERVER', 'Port', 0);
    MyConn.Username := FConfig.ReadString('DB_SERVER', 'Username', '');
    MyConn.Password := FConfig.ReadString('DB_SERVER', 'Password', '');
    MyConn.Connect;          

    mysql := TMyQuery.Create(nil);
    if MyConn.Connected then
    begin
      mysql.Connection := MyConn;
      mysql.SQL.Clear;
      mysql.SQL.Add('set names "gbk"');
      mysql.ExecSQL;
    end;
    mysql.Free;
  except
    on e: Exception do
    begin
      ShowMessage('tgs mysql数据库连接失败!error:' + e.Message);
      Result := False;
    end;


  end;

end;

class procedure Tdm.CreateDM;
begin
  dm := TDM.Create(nil);
  if not dm.Connect then
  begin

    dm.Connect
  end;
end;





procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  FConfig := TIniFile.Create('.\tgsMySqlDB.INI');
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  FConfig.Free;
end;

procedure Tdm.MyConnError(Sender: TObject; E: EDAError; var Fail: Boolean);
begin
      FrmMain.WriteLogInfo('MYSQL 错误信息: '+E.Message);
      Fail := False;
end;

end.

