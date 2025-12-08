unit uUserManager; //2015.11.25 在水一方

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UUser, Dialogs, ComCtrls, Grids, ExtCtrls, uKeyClass, StdCtrls, Buttons, deftype;

type
  TFrmUserManager = class(TForm)
    Panel1: TPanel;
    sgUsers: TStringGrid;
    StatusBar1: TStatusBar;
    edtQryName: TEdit;
    cbbQryObj: TComboBox;
    btnQry: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnBan: TButton;
    btnBanIP: TButton;
    btnBanID: TButton;
    btnBanHcode: TButton;
    btnQryBan: TButton;
    pnlBanlist: TPanel;
    pnlBantitle: TPanel;
    btnBanClose: TSpeedButton;
    sgBanlist: TStringGrid;
    pnlBanBottom: TPanel;
    btnBanDelete: TButton;
    btnre: TButton;
    lbl1: TLabel;
    lblwj: TLabel;
    lbl2: TLabel;
    lblIP: TLabel;
    lbl3: TLabel;
    lblJQ: TLabel;
    edit_copy: TEdit;
    cbb_add: TComboBox;
    btn_ban: TButton;
    edt_add: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbQryObjCloseUp(Sender: TObject);
    procedure btnQryClick(Sender: TObject);
    procedure btnBanClick(Sender: TObject);
    procedure btnBanIPClick(Sender: TObject);
    procedure btnBanCloseClick(Sender: TObject);
    procedure btnBanDeleteClick(Sender: TObject);
    procedure btnQryBanClick(Sender: TObject);
    procedure btnreClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RemoveDuplicates(const stringList: TStringList);
    procedure sgUsersClick(Sender: TObject);
    procedure btn_banClick(Sender: TObject);
  private
    { Private declarations }
    procedure showusers(fid: Integer);
    procedure showbanlist;
  public
    { Public declarations }
  end;

var
  FrmUserManager: TFrmUserManager;

implementation

uses
  uConnect;

{$R *.dfm}

procedure TFrmUserManager.FormCreate(Sender: TObject);
begin
  sgUsers.Cells[0, 0] := '序号';
  sgUsers.Cells[1, 0] := '登陆ID';
  sgUsers.Cells[2, 0] := '角色名称';
  sgUsers.Cells[3, 0] := '连线IP';
  sgUsers.Cells[4, 0] := '外网IP';
  sgUsers.Cells[5, 0] := '上线时间';
  sgUsers.Cells[6, 0] := '机器码';

  sgBanlist.Cells[0, 0] := '序号';
  sgBanlist.Cells[1, 0] := '屏蔽项目';
  sgBanlist.Cells[2, 0] := '屏蔽内容';
end;

procedure TFrmUserManager.FormShow(Sender: TObject);
begin
  showusers(0);
end;

procedure TFrmUserManager.showusers(fid: Integer);
var
  i, n, j: Integer;
  qFiled: PString;
  str: string;
  IPList: TstringList;
  JQList: TstringList;
begin
  IPList := TStringList.Create;
  JQList := TStringList.Create;

  sgUsers.Canvas.Lock;
  sgUsers.RowCount := 2;
  sgUsers.Rows[1].clear;
  sgUsers.RowCount := ConnectorList.Count + 1;

  n := 1;
  str := '';

  for i := 0 to ConnectorList.Count - 1 do begin
    with TConnector(ConnectorList.Items[i]) do begin
      case fid of
        0: qFiled := @str;
        1: qFiled := @LoginID;
        2: qFiled := @CharName;
        3: qFiled := @IpAddr;
        4: qFiled := @OutIpAddr;
        5: qFiled := @StartTime;
        6: qFiled := @hcode;
      end;
      if (edtQryName.Text <> '') and (qFiled^ <> '') and (Pos(edtQryName.Text, qFiled^) = 0) then Continue;
      sgUsers.Cells[0, n] := IntToStr(n);
      sgUsers.Cells[1, n] := LoginID;
      sgUsers.Cells[2, n] := CharName;
      sgUsers.Cells[3, n] := IpAddr;
      sgUsers.Cells[4, n] := OutIpAddr;
      sgUsers.Cells[5, n] := StartTime;
      sgUsers.Cells[6, n] := hcode;
      if OutIpAddr <> '' then IPList.Add(OutIpAddr); //添加IP列表
      if hcode <> '' then JQList.Add(hcode); //添加机器列表
      Inc(n);
    end;
  end;
  sgUsers.RowCount := n;
  sgUsers.Canvas.Unlock;
  //在线玩家数量显示
  lblwj.Caption := IntToStr(sgUsers.RowCount - 1);
  //在线IP数量显示
  RemoveDuplicates(IPList);
  lblIP.Caption := IntToStr(IPList.Count);
  IPList.Clear;
  IPList.Free;
  //在线机器数量显示
  RemoveDuplicates(JQList);
  lblJQ.Caption := IntToStr(JQList.Count);
  JQList.Clear;
  JQList.Free;



end;


//procedure TFrmUserManager.showusers(fid: Integer);
//var
//  i, n, s: Integer;
//  qFiled: PString;
//  str: string;
//begin
//  sgUsers.Canvas.Lock;
//  sgUsers.RowCount := 2;
//  sgUsers.Rows[1].clear;
//  sgUsers.RowCount := ConnectorList.Count+1;
//  n := 1;
//  str := '';
//for s := 0 to 3000 do begin
//  for i := 0 to ConnectorList.Count - 1 do begin
//    with TConnector(ConnectorList.Items[i]) do begin
//      case fid of
//        0: qFiled := @str;
//        1: qFiled := @LoginID;
//        2: qFiled := @CharName;
//        3: qFiled := @IpAddr;
//        4: qFiled := @OutIpAddr;
//        5: qFiled := @StartTime;
//        6: qFiled := @hcode;
//      end;
//      if (edtQryName.Text <> '') and (qFiled^ <> '') and (Pos(edtQryName.Text, qFiled^) = 0) then Continue;
//      sgUsers.Cells[0, n] := IntToStr(n);
//      sgUsers.Cells[1, n] := LoginID;
//      sgUsers.Cells[2, n] := CharName;
//      sgUsers.Cells[3, n] := IpAddr;
//      sgUsers.Cells[4, n] := OutIpAddr;
//      sgUsers.Cells[5, n] := StartTime;
//      sgUsers.Cells[6, n] := hcode;
//      sgUsers.RowCount := sgUsers.RowCount + 1;
//      sgUsers.Rows[sgUsers.RowCount - 1].clear;
//      Inc(n);
//    end;
//  end;
//end;
//  sgUsers.Canvas.Unlock;
//end;

procedure TFrmUserManager.showbanlist;
var
  i, n: Integer;
  qFiled: PString;
  str: string;
begin
  sgBanlist.Canvas.Lock;
  sgBanlist.RowCount := 2;
  sgBanlist.Rows[1].clear;
  n := 1;
  str := '';
  for i := 0 to ConnectorList.Bans.Count - 1 do begin
    with ConnectorList.Bans do begin
      str := '';
      case StrToInt(ValueFromIndex[i]) of
        0: str := BanID_Desc;
        1: str := BanIP_Desc;
        2: str := BanHcode_Desc;
      end;
      sgBanlist.Cells[0, n] := IntToStr(n);
      sgBanlist.Cells[1, n] := str;
      sgBanlist.Cells[2, n] := Names[i];
      sgBanlist.RowCount := sgBanlist.RowCount + 1;
      sgBanlist.Rows[sgBanlist.RowCount - 1].clear;
      Inc(n);
    end;
  end;
  sgBanlist.Canvas.Unlock;
end;

procedure TFrmUserManager.cbbQryObjCloseUp(Sender: TObject);
begin
  if cbbQryObj.Text = 'ALL' then begin
    edtQryName.ReadOnly := True;
    edtQryName.Text := '';
  end
  else
    edtQryName.ReadOnly := False;
end;

procedure TFrmUserManager.btnQryClick(Sender: TObject);
begin
  showusers(cbbQryObj.ItemIndex);
end;

procedure TFrmUserManager.btnBanClick(Sender: TObject);
var
  cname: string;
  TempUser: TUser;
begin
  if sgUsers.Row >= 1 then begin
    cname := sgUsers.Cells[2, sgUsers.Row];
    if cname <> '' then
    begin
      TempUser := UserList.GetUserPointer(cname);
      if TempUser <> nil then
      begin
        TempUser.boDeleteState := true;
        TempUser.SendClass.SendCloseClient();
      end;
      //ConnectorList.CloseConnectByCharName(cname);
    end;
  end;
end;

procedure TFrmUserManager.btnBanIPClick(Sender: TObject);
var
  cname: string;
begin
  if sgUsers.Row >= 1 then begin
    case TButton(Sender).Tag of
      0: cname := sgUsers.Cells[1, sgUsers.Row];
      1: cname := sgUsers.Cells[4, sgUsers.Row];
      2: cname := sgUsers.Cells[6, sgUsers.Row];
    end;
    if cname <> '' then begin
      ConnectorList.BanlistAdd(cname, TButton(Sender).Tag);
      ConnectorList.BanlistSave;
    end;
  end;
end;

procedure TFrmUserManager.btnBanCloseClick(Sender: TObject);
begin
  pnlBanlist.Visible := False;
end;

procedure TFrmUserManager.btnBanDeleteClick(Sender: TObject);
var
  cname: string;
begin
  if sgBanlist.Row >= 1 then begin
    cname := sgBanlist.Cells[2, sgBanlist.Row];
    if cname <> '' then begin
      ConnectorList.BanlistDel(cname);
      ConnectorList.BanlistSave;
    end;
    showbanlist;
  end;
end;

procedure TFrmUserManager.btnQryBanClick(Sender: TObject);
begin
  showbanlist;
  pnlBanlist.Visible := True;
  pnlBanlist.BringToFront;
end;

procedure TFrmUserManager.btnreClick(Sender: TObject);
begin
  showusers(0);
end;


procedure TFrmUserManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ConnectorList.BanlistToGate;
end;


procedure TFrmUserManager.RemoveDuplicates(const stringList: TStringList);
var
  buffer: TStringList;
  cnt: Integer;
begin
  stringList.Sort;
  buffer := TStringList.Create;
  try
    buffer.Sorted := True;
    buffer.Duplicates := dupIgnore;
    buffer.BeginUpdate;
    for cnt := 0 to stringList.Count - 1 do
      buffer.Add(stringList[cnt]);
    buffer.EndUpdate;
    stringList.Assign(buffer);
  finally
    FreeandNil(buffer);
  end;
end;


procedure TFrmUserManager.sgUsersClick(Sender: TObject);
begin

  if sgUsers.Row >= 1 then begin
    edit_copy.Text := Format('%s / %s / %s / %s', [sgUsers.Cells[1, sgUsers.Row], sgUsers.Cells[2, sgUsers.Row], sgUsers.Cells[4, sgUsers.Row], sgUsers.Cells[6, sgUsers.Row]]); //2015.11.17 在水一方
  end;
end;

procedure TFrmUserManager.btn_banClick(Sender: TObject);
var
  cname: string;
begin
  if (cbb_add.ItemIndex < 0) or (cbb_add.ItemIndex > 2) then Exit;
  cname := trim(edt_add.Text);
  if cname <> '' then begin
    ConnectorList.BanlistAdd(cname, cbb_add.ItemIndex);
    ConnectorList.BanlistSave;
    showbanlist;
  end;
end;

end.

