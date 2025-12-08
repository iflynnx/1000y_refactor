unit FPopMsgList;
{
1，普通 消息
2，聊天 消息
3，反外挂 消息
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, A2Img, deftype, ExtCtrls;

type
  TfrmPopMsgList = class(TForm)
    A2Form: TA2Form;
    A2ListBox_msglist: TA2ListBox;
    procedure FormCreate(Sender: TObject);
    procedure A2ListBox_msglistClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ListBox_msglistAdxDrawItem(ASurface: TA2Image;
      index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
      fy: Integer);
  private
        { Private declarations }
  public
        { Public declarations }
    Fdataform: tlist;
    atype: integer;
    procedure FdataformClear;
    procedure FdataformAdd(atemp: TForm);
    function FdataformGET(ID: INTEGER): TForm;
    procedure FdataformDel(ID: INTEGER);
    procedure A2ListBox_delindex;
  end;

implementation

uses FMain, FShowPopMsg;

{$R *.dfm}

procedure TfrmPopMsgList.FdataformDel(ID: INTEGER);
begin
  if FdataformGET(id) = nil then exit;
  Fdataform.Delete(id);
  A2ListBox_msglist.DeleteItem(id);
    //不考虑 释放问题。窗口被关闭 自己控制释放
end;

procedure TfrmPopMsgList.A2ListBox_delindex;
begin
    //列表没有数据
  if A2ListBox_msglist.Count <= 0 then
  begin
    Visible := false;
    frmPopMsg.ShowMsg(atype, false);
    exit;
  end;

  if FdataformGet(A2ListBox_msglist.ItemIndex) <> nil then
    FdataformDel(A2ListBox_msglist.ItemIndex);
end;


function TfrmPopMsgList.FdataformGET(ID: INTEGER): TForm;
begin
  result := nil;
  if (id < 0) or (id >= Fdataform.Count) then EXIT;

  result := Fdataform.Items[id];
end;

procedure TfrmPopMsgList.FdataformAdd(atemp: TForm);
begin
  A2ListBox_msglist.AddItem(' ');
  Fdataform.Add(atemp);
end;

procedure TfrmPopMsgList.FdataformClear;
var
  i: integer;
  t: TForm;
begin
  for i := 0 to Fdataform.Count - 1 do
  begin
    t := (Fdataform[i]);
    t.free;
  end;
  Fdataform.Clear;
end;

procedure TfrmPopMsgList.FormCreate(Sender: TObject);
begin
  FrmM.AddA2Form(Self, A2Form);
  Top := 10;
  Left := 10;
  Fdataform := tlist.Create;
  A2ListBox_msglist.FboAutoSelectIndex := false;
  A2ListBox_msglist.boAutoPro := false;
end;

procedure TfrmPopMsgList.A2ListBox_msglistClick(Sender: TObject);
begin
    //列表没有数据
  if A2ListBox_msglist.Count <= 0 then
  begin
    Visible := false;
    frmPopMsg.ShowMsg(atype, false);
    exit;
  end;
  if (A2ListBox_msglist.ItemIndex < 0) or (A2ListBox_msglist.ItemIndex >= A2ListBox_msglist.Count) then exit;

  if FdataformGet(A2ListBox_msglist.ItemIndex) <> nil then
    FdataformGet(A2ListBox_msglist.ItemIndex).Visible := TRUE;
  FdataformDel(A2ListBox_msglist.ItemIndex);

  if A2ListBox_msglist.Count <= 0 then
  begin
    Visible := false;
    frmPopMsg.ShowMsg(atype, false);
    exit;
  end;
end;

procedure TfrmPopMsgList.FormDestroy(Sender: TObject);
begin

  FdataformClear; //清除 并且释放 没被点 开的窗口
  Fdataform.Free;
end;

procedure TfrmPopMsgList.A2ListBox_msglistAdxDrawItem(ASurface: TA2Image;
  index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
  fy: Integer);

begin

  if FdataformGET(index) = nil then
  begin
    exit;
  end;
  aStr := FdataformGET(index).Caption;
  ATextOut(ASurface, 0, 0, 32767, astr);

end;

end.

