unit FNEWHailFellow;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, ExtCtrls, StdCtrls, A2Img, Deftype, Clipbrd, BaseUIForm, NativeXml;

type
  TArrHailFellowtype = (ahft_1, ahft_2, ahft_3);
  TFrmHailFellow = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2ILabel1: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel_BUTTON: TA2ILabel;
    listContent: TA2ListBox;
    HailFellowbtadd: TA2Button;
    HailFellowbtdel: TA2Button;
    HailFellowUserName: TA2Edit;
    A2ILImg: TA2ILabel;
    A2Button_close: TA2Button;
    listContent3: TA2ListBox;
    listContent2: TA2ListBox;
    procedure FormCreate(Sender: TObject);
    procedure HailFellowbtdelClick(Sender: TObject);
    procedure listContentClick(Sender: TObject);
    procedure listContentAdxDrawItem(ASurface: TA2Image; index: Integer;
      aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure HailFellowbtaddClick(Sender: TObject);
    procedure A2ILabel1Click(Sender: TObject);
    procedure A2ILabel2Click(Sender: TObject);
    procedure A2ILabel3Click(Sender: TObject);
    procedure A2Button_closeClick(Sender: TObject);
    procedure A2ILImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure listContentDblClick(Sender: TObject);
    procedure listContent2DblClick(Sender: TObject);
  private
        { Private declarations }
  public
        { Public declarations }
    Farrtype: TArrHailFellowtype;
    win_back_img: TA2Image;
    button_back_img1: TA2Image;
    button_back_img2: TA2Image;
    button_back_img3: TA2Image;
    temping: TA2Image;
    tempup: TA2Image;
    tempdown: TA2Image;
    procedure SETarrtype(Value: TArrHailFellowtype);

    procedure sendHailFellowAdd(aname: string);

        //20090619增加

   // procedure SetOldVersion();
    procedure SetNewVersion(); override;


    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    property arrtype: TArrHailFellowtype read Farrtype write SETarrtype;
  end;
  THailFellowdata = record
    rname: string[32];
    rcolor: word;
    rtype: Integer;
  end;
  pTHailFellowdata = ^THailFellowdata;
  THailFellowclass = class
  private
    fdata1: tlist;
    fdata2: tlist;
        // function Fdataonline(Item1, Item2:Pointer):Integer;
    procedure Clear();
  public
    itype: Integer;
    tempListbox: TA2ListBox;
    tempListbox2: TA2ListBox;
    constructor Create;
    destructor Destroy; override;
    function ISUName(auname: string): boolean;
    function GetIndex(aindex: integer): pTHailFellowdata;
    function GetIndex2(aindex: integer): pTHailFellowdata;

    procedure add(uname: string);
    procedure mysql_add(uname: string; atype: Integer);
    procedure mysql_del(uname: string; atype: Integer);
    procedure SETstate(uname: string; astate: integer);
    procedure del(uname: string);
    procedure MessageProcess(var code: TWordComData);
  end;

var
  FrmHailFellow: TFrmHailFellow;
  HailFellowlist: THailFellowclass;

implementation

uses FShowPopMsg, FBottom, FMain, FConfirmDialog, Fbl, filepgkclass,
  FnewMagic, FAttrib;

{$R *.dfm}

procedure THailFellowclass.MessageProcess(var code: TWordComData);
var
  pSHailFellowbasic: ptSHailFellowbasic;
  pSHailFellowChangeProperty: ptSHailFellowChangeProperty;
  pSHailFellowMysqlList: pTSHailFellowMysqlList;
  sname: string;
  sType: byte;
begin
  case Code.Data[0] of
    SM_HailFellow:
      begin
        pSHailFellowbasic := @Code.Data;

        sname := (pSHailFellowbasic.rName);
        case pSHailFellowbasic.rkey of
          HailFellow_Message_ADD: //有人 要加我
            begin
                            // frmConfirmDialog.MessageProcess(code);
              frmPopMsg.MessageProcess(code);
            end;
          HailFellowChangeProperty: //好又列表
            begin
              pSHailFellowChangeProperty := @Code.Data;
              sname := (pSHailFellowChangeProperty.rName);
//              if isuname(sname) and chat_outcry then
//                if (pSHailFellowChangeProperty.rstate = HailFellow_state_onlise) then
//                  FrmBottom.AddChat(format('好友 %s 上线了!', [sname]), WinRGB(22, 10, 22), WinRGB(2, 2, 2))
//                else
//                  FrmBottom.AddChat(format('好友 %s 退出了!', [sname]), WinRGB(22, 10, 22), WinRGB(2, 2, 2));
              add(sname);
              SETstate(sname, pSHailFellowChangeProperty.rstate);
            end;
          HailFellow_Mysql_List: //MYSQL 好友列表
            begin
              pSHailFellowMysqlList := @Code.Data;
              sname := (pSHailFellowMysqlList.rName);
              sType := (pSHailFellowMysqlList.rType);
              mysql_add(sname, sType);
            end;
          HailFellow_GameExit: //好朋友  下线
            begin
              SETstate(sname, HailFellow_state_downlide);
              //if chat_outcry then
              //  FrmBottom.AddChat(format('好友 %s 退出了!', [sname]), WinRGB(22, 10, 22), WinRGB(2, 2, 2));
            end;
          HailFellow_del:
            begin
              del(sname);
            end;
          HailFellow_del2:
            begin
              FrmBottom.AddChat(format('%s 已将你删除了好友', [sname]), WinRGB(22, 22, 0), 0);
              del(sname);
            end;
          HailFellow_MYSQLDEL:
            begin
              mysql_del(sname, pSHailFellowbasic.rType);
            end;
        end;

      end;
  end;
end;

constructor THailFellowclass.Create;
begin
  inherited Create;
  fdata1 := Tlist.Create;
  fdata2 := Tlist.Create;
end;

procedure THailFellowclass.Clear();
var
  i: integer;
  p: pTHailFellowdata;
begin
  for i := 0 to fdata1.Count - 1 do
  begin
    p := fdata1.Items[i];
    dispose(p);
  end;
  fdata1.Clear;

  for i := 0 to fdata2.Count - 1 do
  begin
    p := fdata2.Items[i];
    dispose(p);
  end;
  fdata2.Clear;

  tempListbox.Clear;
  tempListbox2.Clear;
end;

destructor THailFellowclass.Destroy;
begin
  Clear;
  fdata1.Free;
  fdata2.Free;
  inherited Destroy;
end;

function THailFellowclass.GetIndex(aindex: integer): pTHailFellowdata;
begin
  Result := nil;
  if (aindex < 0) or (aindex >= fdata1.Count) then exit;
  Result := fdata1.Items[aindex];
end;

function THailFellowclass.GetIndex2(aindex: integer): pTHailFellowdata;
begin
  Result := nil;
  if (aindex < 0) or (aindex >= fdata2.Count) then exit;
  Result := fdata2.Items[aindex];
end;

function THailFellowclass.ISUName(auname: string): boolean;
var
  i: integer;
  p: pTHailFellowdata;
begin
  result := false;
  for i := 0 to fdata1.Count - 1 do
  begin
    p := fdata1.Items[i];
    if auname = p.rname then
    begin
      result := true;
      exit;
    end;
  end;
end;


procedure THailFellowclass.add(uname: string);
var
  p: pTHailFellowdata;
begin
  if isuname(uname) then exit;
  new(p);
  p.rname := uname;
  p.rcolor := 0;
  p.rtype := 0;
  fdata1.Add(p);
  tempListbox.AddItem(' ');
end;

procedure THailFellowclass.mysql_add(uname: string; atype: Integer);
var
  p: pTHailFellowdata;
  i: integer;
begin
  if isuname(uname) then exit;
  new(p);
  p.rname := uname;
  p.rcolor := ColorSysToDxColor($047AFF);
  p.rtype := atype;
  if atype = 0 then
  begin
    fdata1.Add(p);
    tempListbox.AddItem(' ');
  end
  else if atype = 1 then
  begin
    fdata2.Add(p);
    tempListbox2.AddItem(' ');
  end;
end;


procedure THailFellowclass.mysql_del(uname: string; atype: Integer);
var
  p: pTHailFellowdata;
  i: integer;
begin
  if atype = 0 then
  begin
    for i := 0 to fdata1.Count - 1 do
    begin
      p := fdata1.Items[i];
      if p.rname = uname then
      begin
        dispose(p);
        fdata1.Delete(i);
        tempListbox.DeleteItem(i);
        exit;
      end;
    end;
  end
  else if atype = 1 then
  begin
    for i := 0 to fdata2.Count - 1 do
    begin
      p := fdata2.Items[i];
      if p.rname = uname then
      begin
        dispose(p);
        fdata2.Delete(i);
        tempListbox2.DeleteItem(i);
        exit;
      end;
    end;
  end;
end;

procedure THailFellowclass.del(uname: string);
var
  i: integer;
  p: pTHailFellowdata;
begin
  for i := 0 to fdata1.Count - 1 do
  begin
    p := fdata1.Items[i];
    if p.rname = uname then
    begin
      dispose(p);
      fdata1.Delete(i);
      tempListbox.DeleteItem(i);
      exit;
    end;
  end;
end;

function Fdataonline(Item1, Item2: Pointer): Integer;
begin
  if pTHailFellowdata(Item1).rcolor > pTHailFellowdata(Item2).rcolor then Result := -1
  else if pTHailFellowdata(Item1).rcolor < pTHailFellowdata(Item2).rcolor then Result := 1
  else Result := 0;
end;

procedure THailFellowclass.SETstate(uname: string; astate: integer);
var
  i: integer;
  acolor: word;
  p: pTHailFellowdata;
begin

  case astate of
    HailFellow_state_onlise:
      begin
        acolor := ColorSysToDxColor($047AFF);

      end;
    HailFellow_state_downlide:
      begin
        acolor := ColorSysToDxColor($005E5E5E);

      end;
  else acolor := ColorSysToDxColor($005E5E5E);
  end;

  for i := 0 to fdata1.Count - 1 do
  begin
    p := fdata1.Items[i];
    if p.rname = uname then
    begin
      p.rcolor := acolor;
      fdata1.Sort(Fdataonline);
      tempListbox.DrawItem;
      exit;
    end;
  end;

end;

procedure TFrmHailFellow.HailFellowbtdelClick(Sender: TObject);
var
  tt: TSHailFellowbasic;
  cnt: integer;
  STR: string;

  P: pTHailFellowdata;
  frmConfirmDialog: TfrmConfirmDialog;
begin

  case arrtype of
    ahft_1:
      begin
        // if HailFellowUserName.Text = '' then exit;
        p := HailFellowlist.GetIndex(listContent.ItemIndex);
        if p = nil then
        begin
          SAY_EdChatFrmBottomSetFocus;
          exit;
        end;
        STR := p.rname;
        if STR = '' then
        begin
          SAY_EdChatFrmBottomSetFocus;
          exit;
        end;
        frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
        frmConfirmDialog.ShowFrom(cdtHailFellowDel, str, format('确认将【%s】从好友列表中删除？', [str]));
      end;
    ahft_2:
      begin
        p := HailFellowlist.GetIndex2(listContent2.ItemIndex);
        if p = nil then
        begin
          SAY_EdChatFrmBottomSetFocus;
          exit;
        end;
        STR := p.rname;
        if STR = '' then
        begin
          SAY_EdChatFrmBottomSetFocus;
          exit;
        end;
        frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
        frmConfirmDialog.ShowFrom(cdtHailFellowDel, str, format('确认将【%s】从仇敌列表中删除？', [str]));
      end;
    ahft_3: ;
  end;

  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.listContentClick(Sender: TObject);
var
  str: string;
  P: pTHailFellowdata;
begin
  if arrtype = ahft_1 then
  begin
    p := HailFellowlist.GetIndex(listContent.ItemIndex);
    if p = nil then
    begin
      SAY_EdChatFrmBottomSetFocus;
      exit;
    end;
    STR := p.rname;
    Clipboard.AsText := str;
    FrmBottom.AddChat('好友名字已复制', WinRGB(255, 255, 0), 0);
    FrmBottom.Editchannel.Caption := '纸条';
    FrmBottom.EdChat.Text := '@纸条 ' + str + ' ';
  end;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.listContentAdxDrawItem(ASurface: TA2Image;
  index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
  fy: Integer);
var
  P: pTHailFellowdata;
begin
  //P := HailFellowlist.GetIndex(index);
  //if p.rtype <> 0 then EXIT;
 // ATextOut(ASurface, 0, 0, p.rcolor, P.rName);
  case arrtype of
    ahft_1:
      begin
        P := HailFellowlist.GetIndex(index);
        if P = nil then EXIT;
        if p.rtype <> 0 then EXIT;
        ATextOut(ASurface, 2, 2, p.rcolor, P.rName);
      end;
    ahft_2:
      begin
        P := HailFellowlist.GetIndex2(index);
        if P = nil then EXIT;
        if p.rtype <> 1 then EXIT;
        ATextOut(ASurface, 2, 2, p.rcolor, P.rName);
      end;
    ahft_3: ;
  end;
  begin
  end;
end;

procedure TFrmHailFellow.FormCreate(Sender: TObject);
begin
  inherited;
  FTestPos := True;

  FrmM.AddA2Form(Self, A2Form);
  top := 50;
  Left := 20;
  HailFellowlist := THailFellowclass.Create;
  HailFellowlist.tempListbox := listContent;
  HailFellowlist.tempListbox2 := listContent2;


  if WinVerType = wvtnew then
  begin
    SetnewVersion;
//  end else if WinVerType = wvtold then
//  begin
  //  SetOldVersion;
  end;
  listContent.FFontSelBACKColor := ColorSysToDxColor($00FF00AA);
  listContent.FLayout := tlCenter;

  listContent2.FFontSelBACKColor := ColorSysToDxColor($00FF00AA);
  listContent2.FLayout := tlCenter;

  arrtype := ahft_1;

end;

procedure TFrmHailFellow.FormDestroy(Sender: TObject);
begin
  inherited; // 内存泄漏007 在水一方 2015.05.18
  HailFellowlist.Free;
  win_back_img.Free;
  button_back_img1.Free;
  button_back_img2.Free;
  button_back_img3.Free;
  temping.Free;
  tempup.Free;
  tempdown.Free;
end;

procedure TFrmHailFellow.SetNewVersion();

begin
  inherited;
end;

//procedure TFrmHailFellow.SetOldVersion();
//begin
//  win_back_img := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('好友窗.bmp', win_back_img);
//  A2ILImg.A2Image := win_back_img;
//  button_back_img1 := TA2Image.Create(32, 32, 0, 0);
//
//  pgkBmp.getBmp('好友按钮UP.bmp', button_back_img1);
//
//  button_back_img2 := TA2Image.Create(32, 32, 0, 0);
//
//  pgkBmp.getBmp('仇人按钮UP.bmp', button_back_img2);
//
//  button_back_img3 := TA2Image.Create(32, 32, 0, 0);
//
//  pgkBmp.getBmp('黑名单按钮UP.bmp', button_back_img3);
//
//  A2Button_close.A2Down := frmnewmagic.win_CloseDown_img;
//  A2Button_close.A2Up := frmnewmagic.win_CloseUP_img;
//
//  listContent.SetScrollTopImage(getviewImage(7), getviewImage(6));
//  listContent.SetScrollTrackImage(getviewImage(4), getviewImage(5));
//  listContent.SetScrollBottomImage(getviewImage(9), getviewImage(8));
//
//end;

procedure TFrmHailFellow.SETarrtype(Value: TArrHailFellowtype);
begin
  Farrtype := Value;
  case Farrtype of
    ahft_1:
      begin
        listContent.Visible := true;
        listContent2.Visible := false;
//        listContent3.Visible := false;
        A2ILabel_BUTTON.A2Image := button_back_img1;
        HailFellowlist.itype := 0;
        listContent.DrawItem;

      end;
    ahft_2:
      begin
        listContent.Visible := false;
        listContent2.Visible := true;
//        listContent3.Visible := false;
        A2ILabel_BUTTON.A2Image := button_back_img2;
        HailFellowlist.itype := 1;
        listContent2.DrawItem;
      end;
    ahft_3:
      begin
//        listContent.Visible := false;
//        listContent2.Visible := false;
//        listContent3.Visible := true;
        A2ILabel_BUTTON.A2Image := button_back_img3;
        listContent3.DrawItem;
      end;
  end;

end;

procedure TFrmHailFellow.sendHailFellowAdd(aname: string);
var
  tt: TSHailFellowbasic;
  cnt: integer;
begin
  if aname = '' then exit;
  tt.rmsg := CM_HailFellow;
  //tt.rKEY := HailFellow_ADD;
  tt.rKEY := HailFellow_MYSQLADD;
  TT.rName := aname;
  TT.rType := HailFellowlist.itype;
  cnt := sizeof(TT);
  Frmfbl.SocketAddData(cnt, @TT);

  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.HailFellowbtaddClick(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
begin
    //创建 输入 窗口
  //frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  //frmConfirmDialog.ShowFrom(cdtAddHailFellow, '输入要加入玩家名字', '');
  //exit;
  HailFellowUserName.Text := trim(HailFellowUserName.Text);
  if HailFellowUserName.Text = '' then exit;
  case arrtype of
    ahft_1: sendHailFellowAdd(HailFellowUserName.Text);
    ahft_2: sendHailFellowAdd(HailFellowUserName.Text);
    ahft_3: ;
  end;

  HailFellowUserName.Text := '';
end;

procedure TFrmHailFellow.A2ILabel1Click(Sender: TObject);
begin
  arrtype := ahft_1;
end;

procedure TFrmHailFellow.A2ILabel2Click(Sender: TObject);
begin
  arrtype := ahft_2;
end;

procedure TFrmHailFellow.A2ILabel3Click(Sender: TObject);
begin
  arrtype := ahft_3;
end;

procedure TFrmHailFellow.A2Button_closeClick(Sender: TObject);
begin
  Visible := false;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.A2ILImgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmHailFellow.SetConfigFileName;
begin
  FConfigFileName := 'Friends.xml';

end;

procedure TFrmHailFellow.SetNewVersionTest;
begin
  inherited;
//  //窗体
//  self.FormName := 'FrmHailFellow';
//  SetControlPos(Self);
//  self.FormName := '';
//  A2Form.FImageSurface.Name := 'FImageSurface';
//  SetA2ImgPos(A2Form.FImageSurface);
//  A2Form.boImagesurface := true;
//
//  //关闭
//  SetControlPos(A2Button_close);

  SetControlPos(Self);
  win_back_img := TA2Image.Create(32, 32, 0, 0);
  win_back_img.Name := 'win_back_img';
  SetA2ImgPos(win_back_img);
  SetControlPos(A2ILImg);
  A2ILImg.A2Image := win_back_img;
  button_back_img1 := TA2Image.Create(32, 32, 0, 0);
  button_back_img1.Name := 'button_back_img1';
  SetA2ImgPos(button_back_img1);
  button_back_img2 := TA2Image.Create(32, 32, 0, 0);
  button_back_img2.Name := 'button_back_img2';
  SetA2ImgPos(button_back_img2);
  button_back_img3 := TA2Image.Create(32, 32, 0, 0);
  button_back_img3.Name := 'button_back_img3';
  SetA2ImgPos(button_back_img3);
  SetControlPos(A2ILabel1);
  SetControlPos(A2ILabel2);
  SetControlPos(A2ILabel3);

  SetControlPos(A2ILabel_BUTTON);
  A2ILabel_BUTTON.A2Image := button_back_img1;

  SetControlPos(A2Button_close);
  SetControlPos(listContent);
  SetControlPos(listContent2);
  SetControlPos(listContent3);
  SetControlPos(HailFellowbtadd);
  HailFellowbtadd.BringToFront;
  SetControlPos(HailFellowbtdel);
  HailFellowbtdel.BringToFront;
  SetControlPos(A2Button_close);
  SetControlPos(HailFellowUserName);
end;

procedure TFrmHailFellow.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure TFrmHailFellow.listContentDblClick(Sender: TObject);
var
  str: string;
  P: pTHailFellowdata;
begin
  inherited;
  STR := '';
  p := HailFellowlist.GetIndex(listContent.ItemIndex);
  if p = nil then
  begin
    SAY_EdChatFrmBottomSetFocus;
    exit;
  end;
  STR := p.rname;
  if STR = '' then exit;
  Clipboard.AsText := str;
  HailFellowUserName.Text := str;
  FrmBottom.AddChat('好友名字已复制', WinRGB(255, 255, 0), 0);
  FrmBottom.Editchannel.Caption := '纸条';
  FrmBottom.EdChat.Text := '@纸条 ' + str + ' ';
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.listContent2DblClick(Sender: TObject);
var
  str: string;
  P: pTHailFellowdata;
begin
  inherited;
  STR := '';
  p := HailFellowlist.GetIndex2(listContent2.ItemIndex);
  if p = nil then
  begin
    SAY_EdChatFrmBottomSetFocus;
    exit;
  end;
  STR := p.rname;
  if STR = '' then exit;
  Clipboard.AsText := str;
  HailFellowUserName.Text := str;
  FrmBottom.AddChat('仇敌名字已复制', WinRGB(255, 255, 0), 0);
  FrmBottom.Editchannel.Caption := '探查';
  FrmBottom.EdChat.Text := '@探查 ' + str;
  SAY_EdChatFrmBottomSetFocus;

end;

end.

