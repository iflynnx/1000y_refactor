unit uRandomManager; //2015.11.25 在水一方

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, ExtCtrls, uKeyClass, StdCtrls, Buttons, deftype,
  Spin;

type
  TFrmRandomManager = class(TForm)
    Panel1: TPanel;
    sgUsers: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    lblitemname: TLabel;
    lblobjname: TLabel;
    sedqz: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    sebcz: TSpinEdit;
    sesdz: TSpinEdit;
    lbl1: TLabel;
    btnXg: TButton;
    btnSx: TButton;
    lblres: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgUsersClick(Sender: TObject);
    procedure btnSxClick(Sender: TObject);
    procedure btnXgClick(Sender: TObject);
  private
    { Private declarations }
    procedure showitems(fid: Integer);
  public
    { Public declarations }
  end;

var
  FrmRandomManager: TFrmRandomManager;

implementation

uses
  svClass, AUtil32;

{$R *.dfm}

procedure TFrmRandomManager.FormCreate(Sender: TObject);
begin
  sgUsers.Cells[0, 0] := '序号';
  sgUsers.Cells[1, 0] := '物品名称';
  sgUsers.Cells[2, 0] := '怪物名称';
  sgUsers.Cells[3, 0] := '当前值';
  sgUsers.Cells[4, 0] := '爆出值';
  sgUsers.Cells[5, 0] := '设定值';

end;

procedure TFrmRandomManager.FormShow(Sender: TObject);
begin
  showitems(0);
end;


procedure TFrmRandomManager.showitems(fid: Integer);
var
  i, n, s: Integer;
  str: string;
  p: PTMonsterData;
  pd: TRandomDataClass;
  pp: PTRandomData;
begin
  sgUsers.Canvas.Lock;
  sgUsers.RowCount := 2;
  sgUsers.Rows[1].clear;
  sgUsers.RowCount := RandomClass.getCount * 5 + 1;

  n := 1;
  str := '';
  //循环爆出数据
  for i := 0 to RandomClass.getCount - 1 do begin
      //获取怪物爆出数据
    pd := RandomClass.GetDataByIndex(i);
    if pd = nil then Continue;
      //循环怪物爆出数据
    for s := 0 to pd.GetCount - 1 do begin
        //获取爆出数据详细
      pp := pd.GetByIndex(s);
      if pp = nil then Continue;
        //写到列表
      sgUsers.Cells[0, n] := IntToStr(n);
      sgUsers.Cells[1, n] := pp.rItemName; //道具名称
      sgUsers.Cells[2, n] := pp.rObjName; //怪物名称
      sgUsers.Cells[3, n] := IntToStr(pp.rCurIndex); //当前值
      sgUsers.Cells[4, n] := IntToStr(pp.rIndex); //爆出值
      sgUsers.Cells[5, n] := IntToStr(pp.rCount); //设定值
      //sgUsers.RowCount := sgUsers.RowCount + 1;
      //sgUsers.Rows[sgUsers.RowCount - 1].clear;
      Inc(n);
    end;
  end;
  sgUsers.RowCount := n;
  sgUsers.Canvas.Unlock;

end;

procedure TFrmRandomManager.sgUsersClick(Sender: TObject);
var
  itemname, objname: string;
  dqz, bcz, sdz: Integer;
begin

  if sgUsers.Row >= 1 then begin
    //道具名称
    itemname := sgUsers.Cells[1, sgUsers.Row];
    if itemname <> '' then
      lblitemname.caption := itemname;
    //宿主名称
    objname := sgUsers.Cells[2, sgUsers.Row];
    if objname <> '' then
      lblobjname.caption := objname;
    //当前值
    dqz := _StrToInt(sgUsers.Cells[3, sgUsers.Row]);
    if dqz >= 0 then
      sedqz.Value := dqz;

    //爆出值
    bcz := _StrToInt(sgUsers.Cells[4, sgUsers.Row]);
    if bcz >= 0 then
      sebcz.Value := bcz;

    //设定值
    sdz := _StrToInt(sgUsers.Cells[5, sgUsers.Row]);
    if sdz >= 0 then
      sesdz.Value := sdz;

  end;
end;

procedure TFrmRandomManager.btnSxClick(Sender: TObject);
var
  sRow: Integer;
begin
  if sgUsers.Row >= 1 then begin
    sRow := sgUsers.Row;
  end;
  showitems(0);
  if sgUsers.RowCount >= sRow then
    sgUsers.Row := sRow;
end;

procedure TFrmRandomManager.btnXgClick(Sender: TObject);
var
  itemname, objname: string;
  dqz, bcz, sdz: Integer;
begin
  itemname := lblitemname.caption;
  objname := lblobjname.caption;
  dqz := sedqz.Value;
  bcz := sebcz.Value;
  sdz := sesdz.Value;

  if RandomClass.SetChance(itemname, objname, dqz, bcz, sdz) then
  begin
    lblres.caption := '修改成功';
  end
  else
    lblres.caption := '修改失败';
  exit;
end;

end.

