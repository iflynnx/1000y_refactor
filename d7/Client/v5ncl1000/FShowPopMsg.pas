unit FShowPopMsg;
{提示列表窗口
1，好友 问答
2，门派 问答
3，交易 问答
4，门派让位 问答
5，反外挂 问答
6，
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, A2Form, A2Img, deftype, FPopMsgList, uanstick;

type

  TfrmPopMsg = class(TForm)
    A2Form: TA2Form;
    A2ILabel_msg: TA2ILabel;
    A2ILabel_msg2: TA2ILabel;
    A2ILabel_wg: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ILabel_msgClick(Sender: TObject);
    procedure A2ILabel_msg2Click(Sender: TObject);
    procedure A2ILabel_wgClick(Sender: TObject);
  private
        { Private declarations }
  public
        { Public declarations }
    runtcik: integer;
    EunTcikImg: integer;
    A2Image_msg, A2Image_msg2, A2Image_wg
      : TA2Image;
    imgMsgid, imgMsg2id, imgwgid: integer;

    frmPopMsgList_msg: TfrmPopMsgList;
    frmPopMsgList_msg2: TfrmPopMsgList;
    frmPopMsgList_wg: TfrmPopMsgList;
    procedure update(aTcik: integer);
    procedure ShowMsg(atype: integer; astate: boolean);
    procedure closeForm();

    procedure MessageProcess(var code: TWordComData);
    procedure CreateMsgFrom(var code: TWordComData);
  end;

var
  frmPopMsg: TfrmPopMsg;
  //showtime: Integer;

implementation

uses FMain, AtzCls, FAttrib, FConfirmDialog, FBottom;

{$R *.dfm}

procedure TfrmPopMsg.CreateMsgFrom(var code: TWordComData);
var
  frmConfirmDialog: TfrmConfirmDialog;
  pckey: PTCKey;
begin
    //添加到列表
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.MessageProcess(code);
  frmPopMsgList_msg.FdataformAdd(frmConfirmDialog);
  pckey := @code.Data;

    //显示叹号图标
  case pckey^.rmsg of
    SM_Procession: ShowMsg(1, true); //组队
    SM_HailFellow: ShowMsg(1, true); //好友
    SM_GUILD: ShowMsg(1, true); //入门派
    SM_EMAIL: ShowMsg(2, true); //邮件
    SM_InputOk: ShowMsg(3, true); //可能是交易
    SM_SHOWINPUTSTRING2: ShowMsg(1, true); //不知道是什么
  else ShowMsg(1, true); //其他的
  end;
end;

procedure TfrmPopMsg.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  PSSShowSpecialWindow: PTSShowSpecialWindow;
  pSHailFellowbasic: pTSHailFellowbasic;
  id, akey: integer;
begin
    //窗口 创建好 压入 LIST中
  pckey := @code.Data;
  case pckey^.rmsg of
    SM_Procession:
      begin
        id := 1;
        akey := WordComData_GETbyte(code, id);
        if akey = Procession_ADDMsg then
        begin
          CreateMsgFrom(code);
        end;
      end;
    SM_HailFellow:
      begin
        pSHailFellowbasic := @Code.Data;

        case pSHailFellowbasic.rkey of
          HailFellow_Message_ADD: //有人 要加我
            begin
              CreateMsgFrom(code);
            end;
        end;

      end;
    SM_GUILD:
      begin

        id := 1;
        akey := WordComData_GETbyte(code, id);
        case akey of
          GUILD_list_addMsg, GUILD_list_addALLYMsg: //被 人 加 是否同意
            begin
              CreateMsgFrom(code);
            end;
        end;
      end;
    SM_InputOk: CreateMsgFrom(code); //交易

    SM_SHOWINPUTSTRING2: CreateMsgFrom(code);
    SM_EMAIL: //邮件
      begin
        akey := WordComData_GETbyte(code, id);
        case akey of
          EMAIL_list:
            begin
              CreateMsgFrom(code);
            end;
        end;
      end;
  end;
end;

procedure TfrmPopMsg.ShowMsg(atype: integer; astate: boolean);
begin
  case atype of
    1:
      begin
        Visible := true;
        A2ILabel_msg.Visible := astate;
      end;
    2:
      begin
        Visible := true;
        A2ILabel_msg2.Visible := astate;
      end;
    3: //交易
      begin
        Visible := true;
        A2ILabel_wg.Visible := astate;
      end;
  else Visible := false;
  end;
  if (not A2ILabel_msg.Visible)
    and (not A2ILabel_msg2.Visible)
    and (not A2ILabel_wg.Visible) then
    Visible := false;
  //if Visible then
  //  showtime := mmAnsTick;
end;

procedure TfrmPopMsg.update(aTcik: integer);
var
  t: TA2Image;
begin
  if not Visible then exit;
//  if (aTcik - showtime) > 3000 then //超过30秒自动关闭
//  begin
//    if A2ILabel_msg.Visible then
//    begin
//      frmPopMsgList_msg.A2ListBox_delindex;
//    end;
//
//    if A2ILabel_msg2.Visible then
//    begin
//      frmPopMsgList_msg2.A2ListBox_delindex;
//    end;
//
//    if A2ILabel_wg.Visible then
//    begin
//      frmPopMsgList_wg.A2ListBox_delindex;
//    end;
//    closeForm;
//    FrmBottom.AddChat('1个请求已过期', WinRGB(22, 22, 0), 0);
//    exit;
//  end;

  if (aTcik - runtcik) > 10 then
  begin
        //换图片
    inc(EunTcikImg);
    if EunTcikImg >= 5 then EunTcikImg := 0;
    runtcik := aTcik;
    if A2ILabel_msg.Visible then
    begin
      t := getWWWImageLib(imgMsgid + EunTcikImg);
      A2ILabel_msg.A2Image := t;
            //A2Image_msg.Resize(t.Width, t.Height);
            //A2Image_msg.DrawImage(t, 0, 0, true);
            //A2Image_msg.Resize(32, 32);
    end;

    if A2ILabel_msg2.Visible then
    begin
      t := getWWWImageLib(imgMsg2id + EunTcikImg);
      A2ILabel_msg2.A2Image := t;
            //A2Image_msg2.Resize(t.Width, t.Height);
            //A2Image_msg2.DrawImage(t, 0, 0, true);
            //A2Image_msg2.Resize(32, 32);
    end;

    if A2ILabel_wg.Visible then
    begin
      t := getWWWImageLib(imgwgid + EunTcikImg);
      A2ILabel_wg.A2Image := t;
            //A2Image_wg.Resize(t.Width, t.Height);
            //a2Image_wg.DrawImage(t, 0, 0, true);
            //A2Image_wg.Resize(32, 32);
    end;

  end;

end;

procedure TfrmPopMsg.FormCreate(Sender: TObject);
var
  t: TA2Image;
begin
 // showtime := 0;
  imgMsgid := 0;
  imgMsg2id := 5;
  imgwgid := 10;

  FrmM.AddA2Form(Self, A2form);
    //Left := 300;
    //Top := 30;

  Left := 380;
  Top := 180;

  A2Image_msg := TA2Image.Create(32, 32, 0, 0);
  A2Image_msg2 := TA2Image.Create(32, 32, 0, 0);
  A2Image_wg := TA2Image.Create(32, 32, 0, 0);
  A2ILabel_msg.Visible := false;
  A2ILabel_msg.A2Image := A2Image_msg;
  A2ILabel_msg2.Visible := false;
  A2ILabel_msg2.A2Image := A2Image_msg2;
  A2ILabel_wg.Visible := false;
  A2ILabel_wg.A2Image := A2Image_wg;

  t := getWWWImageLib(imgMsgid);
  if t <> nil then
  begin
    A2Image_msg.Resize(t.Width, t.Height);
    A2Image_msg.DrawImage(t, 0, 0, true);
    A2Image_msg.Resize(32, 32);
  end;
  t := getWWWImageLib(imgMsg2id);
  if t <> nil then
  begin
    A2Image_msg2.Resize(t.Width, t.Height);
    A2Image_msg2.DrawImage(t, 0, 0, true);
    A2Image_msg2.Resize(32, 32);
  end;
  t := getWWWImageLib(imgwgid);
  if t <> nil then
  begin
    A2Image_wg.Resize(t.Width, t.Height);
    A2Image_wg.DrawImage(t, 0, 0, true);
    A2Image_wg.Resize(32, 32);
  end;
  frmPopMsgList_msg := TfrmPopMsgList.Create(self);
  frmPopMsgList_msg.atype := 1;
  frmPopMsgList_msg.Left := Self.Left;
  frmPopMsgList_msg.Top := Self.Top + self.Height + 2;

  frmPopMsgList_msg2 := TfrmPopMsgList.Create(self);
  frmPopMsgList_msg2.atype := 2;
  frmPopMsgList_msg2.Left := Self.Left + 4;
  frmPopMsgList_msg2.Top := Self.Top + self.Height + 2;

  frmPopMsgList_wg := TfrmPopMsgList.Create(self);
  frmPopMsgList_wg.atype := 3;
  frmPopMsgList_wg.Left := Self.Left + 8;
  frmPopMsgList_wg.Top := Self.Top + self.Height + 2;
end;

procedure TfrmPopMsg.FormDestroy(Sender: TObject);
begin
  A2Image_msg.Free;
  A2Image_msg2.Free;
  A2Image_wg.Free;
  frmPopMsgList_msg.Free;
  frmPopMsgList_msg2.Free;
  frmPopMsgList_wg.Free;
end;

procedure TfrmPopMsg.closeForm();
begin
  frmPopMsgList_msg.Visible := false;
  frmPopMsgList_msg2.Visible := false;
  frmPopMsgList_wg.Visible := false;
end;

procedure TfrmPopMsg.A2ILabel_msgClick(Sender: TObject);
begin
  closeForm;
    //frmPopMsgList_msg.Visible := true;
  frmPopMsgList_msg.A2ListBox_msglistClick(nil);
end;

procedure TfrmPopMsg.A2ILabel_msg2Click(Sender: TObject);
var
  key: word;
begin
  closeForm;
     // frmPopMsgList_msg2.Visible := true;
 // FrmBottom.AddChat(format('你有%d封信件尚未领取,使用@邮件或@yj命令打开邮件窗口。', [FrmEmail.A2ListBox1.Count]), WinRGB(22, 22, 0), 0);

  frmPopMsgList_msg2.A2ListBox_msglistClick(nil);
  key := VK_RETURN;
  FrmBottom.sendsay('@yj', key);
end;

procedure TfrmPopMsg.A2ILabel_wgClick(Sender: TObject);
begin
  closeForm;
     // frmPopMsgList_wg.Visible := true;
   // frmPopMsgList_msg2.A2ListBox_msglistClick(nil);
  frmPopMsgList_msg.A2ListBox_msglistClick(nil);
  frmPopMsgList_wg.A2ListBox_msglistClick(nil);
end;

end.

