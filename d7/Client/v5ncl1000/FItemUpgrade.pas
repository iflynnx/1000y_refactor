unit FItemUpgrade;
//2015.12.07 在水一方 创建
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Atzcls, Deftype, BaseUIForm,
  NativeXml, Math, uKeyClass;
const
  WM_PROGRESS_MESSAGE = WM_USER + 100;

type
  TItemUpgradedata = record
    rkey: integer;
    rname: string[32];
  end;

  TfrmItemUpgrade = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2ButtonStart: TA2Button;
    A2ILabel0: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel4: TA2ILabel;
    A2ButtonClose: TA2Button;
    A2ILabelProgress: TA2ILabel;
    A2ILabelProgressBack: TA2ILabel;
    tmrStart: TTimer;
    A2ILabel1: TA2ILabel;
    A2ILabel3: TA2ILabel;
    lblfy: TA2Label;
    lblylq: TA2ListBox;
    lblylh: TA2ListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CLEAR;
    procedure sendshowForm();
    procedure A2ButtonCloseClick(Sender: TObject);
    procedure tmrStartTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabelComp0MouseEnter(Sender: TObject);
    procedure A2ILabelComp0MouseLeave(Sender: TObject);
    procedure A2ILabel0MouseLeave(Sender: TObject);
    procedure A2ILabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2ILabel0DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure setitemshpe(Lb: TA2ILabel; aitemid: integer);
    procedure A2ILabel0DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure A2ILabel0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ButtonStartClick(Sender: TObject);
    procedure ProgressMsg(var Message: TMessage); message WM_PROGRESS_MESSAGE;
    procedure Complex();
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FItemArr: array[0..4] of TA2ILabel;
    A2ImageProgress: TA2Image;
    A2ImageProgressBack: TA2Image;
    starttick: DWORD;
    FLog: string;
    FItemUpgradeKeyArr: array[0..4] of TItemUpgradedata;
    FItemimg: TA2Image;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure getiteminfo;
  public
    { Public declarations }
    procedure addlog(atext: string);
    procedure MessageProcess(var code: TWordComData);
    procedure ItemUpgradeKeyArrDel(asubkey: integer);
    procedure ItemUpgradeKeyArrClear;
  end;

var
  frmItemUpgrade: TfrmItemUpgrade;

implementation
uses FMain, FAttrib, FWearItem, CharCls, cltype, uAnsTick, filepgkclass, FBottom,
  fbl;
{$R *.dfm}

procedure TfrmItemUpgrade.addlog(atext: string);
begin
  FrmBottom.AddChat(atext, WinRGB(22, 22, 0), 0);
end;


procedure TfrmItemUpgrade.MessageProcess(var code: TWordComData);
var
  i, n, akey, money: integer;
  str: string;
  PSSShowSpecialWindow: PTSShowSpecialWindow;
begin
  i := 0;
  akey := WordComData_GETbyte(Code, i);
  case akey of
    SM_SHOWSPECIALWINDOW: //窗口操作
      begin
        PSSShowSpecialWindow := @code.data;
        case PSSShowSpecialWindow.rWindow of
          WINDOW_Close_All: Visible := false; //窗口开闭

          WINDOW_ItemUpgrade:
            begin
              FrmM.move_win_form_Align(Self, mwfCenterLeft);
              FrmM.SetA2Form(Self, A2form);
              Visible := true;
            end;
        end;
      end;
    SM_ItemUpgrade:
      begin
        n := WordComData_GETbyte(Code, i);
        case n of
          ItemUpgrade_ItemInfo: //显示信息
            begin
              money := WordComData_GETdword(Code, i); //费用
              lblfy.Caption := IntToStr(money);
              str := WordComData_GETStringPro(Code, i); //升级前属性
              lblylq.StringList.Text := formatStr(str, lblylq.Width);
              lblylq.DrawItem;
              //lblylq.StringList.Text := formatStr(str, lblylq.Width);
              //lblylq.DrawItem;
              str := WordComData_GETStringPro(Code, i); //升级后属性
              lblylh.StringList.Text := formatStr(str, lblylh.Width);
              lblylh.DrawItem;
            end;

          ItemUpgrade_Err: //失败
            begin
              n := WordComData_GETbyte(Code, i);
              FLog := '';
              case n of
                1: FLog := '有密码设定';
                2: FLog := '强化装备不存在';
                3: FLog := '这个装备无法强化';
                4: FLog := '强化级数已达最高';
                5: FLog := '强化信息获取错误';
                6: FLog := '绑定钱币不足';
                7: FLog := '强化材料不存在';
                8: FLog := '你放入的强化材料不正确';
                9: FLog := '你好像放入了什么奇怪的东西?';
                10: FLog := '绑定钱币删除失败';
                11: FLog := '使用强化材料失败';
                100: FLog := '强化等级更新失败';  
              end;
              if FLog <> '' then addlog(FLog);
            end;

          ItemUpgrade_End: //完成
            begin
              n := WordComData_GETbyte(Code, i);
              FLog := '';
              case n of
                1: FLog := '强化成功!';
                2: FLog := '强化失败,装备消失了!';
                3: FLog := '强化失败,装备降级了!';
                4: FLog := '强化失败!';
              end;
              if FLog <> '' then addlog(FLog);
            end;
        end;
      end;
  end;
end;


procedure TfrmItemUpgrade.FormCreate(Sender: TObject);
var
  i: integer;
begin
  inherited;
  self.FTestPos := true;
  A2ImageProgress := TA2Image.Create(218, 9, 0, 0);
  A2ImageProgressBack := TA2Image.Create(218, 9, 0, 0);
  FrmM.AddA2Form(Self, A2Form);
  FItemArr[0] := A2ILabel0;
  FItemArr[1] := A2ILabel1;
  FItemArr[2] := A2ILabel2;
  FItemArr[3] := A2ILabel3;
  FItemArr[4] := A2ILabel4;
  for i := 0 to high(FItemArr) do
  begin
    FItemArr[i].Tag := i;
    FItemUpgradeKeyArr[i].rkey := -1;
  end;

  FItemimg := TA2Image.Create(32, 32, 0, 0);
  FItemimg.Name := 'FItemimg';

  SetNewVersionTest;

end;

procedure TfrmItemUpgrade.FormDestroy(Sender: TObject);
begin
  A2ImageProgress.Free;
  A2ImageProgressBack.Free;
  CLEAR;
  FItemimg.Free;
end;


procedure TfrmItemUpgrade.CLEAR;
var
  i: Integer;
begin
  for i := Low(FItemUpgradeKeyArr) to High(FItemUpgradeKeyArr) do
  begin
    FItemUpgradeKeyArr[i].rkey := -1;
 //   ItemInputKeyArr[asubkey].rcap := '';
//    ItemInputKeyArr[asubkey].rtext := '';
    FItemArr[i].A2Image := FItemimg;
    FItemArr[i].A2Imageback := FItemimg;
  end;
end;


procedure TfrmItemUpgrade.SetConfigFileName;
begin
  FConfigFileName := 'ItemUpgrade.xml';
end;

procedure TfrmItemUpgrade.SetNewVersionTest;
var
  i: integer;
begin
  inherited;
  SetControlPos(self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(A2ButtonClose); //关闭按钮
  SetControlPos(A2ButtonStart); //开始按钮

  SetControlPos(lblfy); //强化费用
  SetControlPos(lblylq); //强化前属性
  lblylq.FLayout := tlCenter;
  lblylq.FItemIndexViewState := false;
  lblylq.FMouseViewState := false;

  SetControlPos(lblylh); //强化后属性
  lblylh.FLayout := tlCenter;
  lblylh.FItemIndexViewState := false;
  lblylh.FMouseViewState := false;

  SetControlPos(A2ILabelProgress); //进度条
  A2ILabelProgress.Visible := False;
  SetControlPos(A2ILabelProgressBack); //进度条背景
  A2ILabelProgressBack.Visible := False;

  if A2ImageProgress = nil then
    A2ImageProgress := TA2Image.Create(A2ILabelProgress.Width * 2, A2ILabelProgress.Height, 0, 0)
  else
    A2ImageProgress.Resize(A2ILabelProgress.Width * 2, A2ILabelProgress.Height);
  A2ImageProgress.Clear(1);

  if A2ILabelProgressBack.A2Image <> nil then
    A2ImageProgress.DrawImage(A2ILabelProgressBack.A2Image, A2ILabelProgress.Width, 0, false);

  if A2ILabelProgress.A2Image <> nil then
    A2ImageProgress.DrawImage(A2ILabelProgress.A2Image, 0, 0, false);

  //道具图标窗口
  for i := 0 to high(FItemArr) do
  begin
    SetControlPos(FItemArr[i]);
    if FItemArr[i].A2Image <> nil then
      FItemArr[i].A2Imageback := FItemArr[i].A2Image;
  end;

  self.SetA2ImgPos(FItemimg);

end;

procedure TfrmItemUpgrade.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure TfrmItemUpgrade.sendshowForm();
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ItemUpgrade);
  WordComData_ADDbyte(temp, ItemUpgrade_showForm);

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

//关闭窗口

procedure TfrmItemUpgrade.A2ButtonCloseClick(Sender: TObject);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ItemUpgrade);
  WordComData_ADDbyte(temp, ItemUpgrade_Windows_close);

  if Frmfbl.SocketAddData(temp.Size, @temp.data) then
    Visible := false;
end;

procedure TfrmItemUpgrade.tmrStartTimer(Sender: TObject);
begin
  //判断窗口是否关闭
  if Visible = False then
  begin
    A2ButtonStart.Enabled := True;
    tmrStart.Enabled := False;
    Exit;
  end;

  if GetTickCount - starttick <= 3000 then begin
    SendMessage(Self.Handle, WM_PROGRESS_MESSAGE, 0, (GetTickCount - starttick) * 100 div 3000);
  end
  else begin
    //进度条走完处理
    if A2ButtonStart.Enabled = False then Complex(); //发送数据
    A2ButtonStart.Enabled := True;
    tmrStart.Enabled := False;
    A2ILabelProgress.Visible := False;
    A2ILabelProgress.ReDraw;
    ItemUpgradeKeyArrClear;

  end;
end;

procedure TfrmItemUpgrade.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;


procedure TfrmItemUpgrade.A2ILabelComp0MouseEnter(Sender: TObject);
begin
  //
end;

procedure TfrmItemUpgrade.A2ILabelComp0MouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;


procedure TfrmItemUpgrade.A2ILabel0MouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;


procedure TfrmItemUpgrade.A2ILabel0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  pp: PTItemdata;
begin
  inherited;
  if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
  if tA2ILabel(Sender).A2Image = nil then exit;

  pp := HaveItemclass.getid(FItemUpgradeKeyArr[TA2ILabel(Sender).Tag].rkey);
  if pp <> nil then
  begin
    if pp.rViewName <> '' then GameHint.setText(integer(Sender), TItemDataToStr(pp^))
    else
      GameHint.Close;
  end;
  exit;
end;

procedure TfrmItemUpgrade.A2ILabel0DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  n, i: integer;
  akey: integer;
  pp: PTItemdata;
  percent: string;
begin
  if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
  if Source = nil then exit;
  with Source as TDragItem do
  begin
    if SourceID <> WINDOW_ITEMS then exit;
    pp := HaveItemclass.getid(Selected);
    if pp <> nil then
    begin
      if pp.rName = '' then
        exit;
      case pp.rKind of
        ITEM_KIND_WEARITEM: i := 0; //装备
        ITEM_KIND_136: i := 1; //材料
        ITEM_KIND_137: i := 2; //加成功率
        ITEM_KIND_138: i := 3; //不降级
        ITEM_KIND_139: i := 4; //不碎
      else
        FrmBottom.AddChat('无法放入的道具!', WinRGB(22, 22, 0), 0);
        exit;
      end;
      ItemUpgradeKeyArrDel(i); //清空格子
      FItemUpgradeKeyArr[i].rkey := Selected; // 记录格子背包物品KEY
      akey := FItemUpgradeKeyArr[i].rkey;
      setitemshpe(FItemArr[i], akey);
      //如果拖入装备,发送获取信息
      if i = 0 then getiteminfo;
    end;

  end;
end;

//写入图标

procedure TfrmItemUpgrade.setitemshpe(Lb: TA2ILabel; aitemid: integer);
var
  pp: PTItemdata;
  idx: integer;
begin
  pp := HaveItemclass.getid(aitemid);
  if pp = nil then exit;
  if pp.rlockState = 1 then idx := 24
  else if pp.rlockState = 2 then idx := 25
  else idx := 0;
  FrmAttrib.SetItemLabel(lb
    , ''
    , pp.rColor
    , pp.rShape
    , idx, 0
    );
end;

procedure TfrmItemUpgrade.ItemUpgradeKeyArrDel(asubkey: integer);
var
  view: string;
begin
  if (asubkey < 0) or (asubkey > high(FItemUpgradeKeyArr)) then exit;
  FItemUpgradeKeyArr[asubkey].rkey := -1;

  FItemArr[asubkey].A2Image := FItemimg;
  FItemArr[asubkey].A2Imageback := FItemimg;
  FItemArr[asubkey].A2ImageRDown := nil;
  FItemArr[asubkey].A2ImageLUP := nil;
  //判断是否是装备
  if asubkey = 0 then
  begin
    lblylq.Clear;
    lblylh.Clear;
    lblfy.Caption := '';
  end;

  //  A2LabelItemInputCapArr[asubkey].Caption := '';
  GameHint.Close;
end;

procedure TfrmItemUpgrade.ItemUpgradeKeyArrClear;
var
  i: integer;
begin
  for i := 0 to high(FItemUpgradeKeyArr) do
  begin
    FItemUpgradeKeyArr[i].rkey := -1;
    FItemUpgradeKeyArr[i].rname := '';
    FItemArr[i].A2Image := FItemimg;
    FItemArr[i].A2Imageback := FItemimg;
    FItemArr[i].A2ImageRDown := nil;
    FItemArr[i].A2ImageLUP := nil;
  end;
  lblylq.Clear;
  lblylh.Clear;
  lblfy.Caption := '';
  GameHint.Close;
end;

procedure TfrmItemUpgrade.A2ILabel0DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
  Accept := FALSE;
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_ITEMS then Accept := TRUE;
    end;
  end;
end;

procedure TfrmItemUpgrade.A2ILabel0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
  if Button = mbRight then
  begin
    ItemUpgradeKeyArrDel(TA2ILabel(Sender).Tag);
  end;
end;


procedure TfrmItemUpgrade.getiteminfo;
var
  temp: TWordComData;
begin
  if FItemUpgradeKeyArr[0].rkey = -1 then exit;
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ItemUpgrade);
  WordComData_ADDbyte(temp, ItemUpgrade_ItemInfo);
  WordComData_ADDdword(temp, FItemUpgradeKeyArr[0].rkey);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmItemUpgrade.A2ButtonStartClick(Sender: TObject);
begin
  inherited;
  if FItemUpgradeKeyArr[0].rkey = -1 then
  begin
    addlog('请加入需要强化的装备!');
    exit;
  end;

  if FItemUpgradeKeyArr[1].rkey = -1 then
  begin
    addlog('请加入强化的装备的材料!');
    exit;
  end;

  starttick := GetTickCount;
  A2ILabelProgress.Visible := True;
  A2ButtonStart.Enabled := False;
  //Complex();
  tmrStart.Enabled := True;
end;

procedure TfrmItemUpgrade.ProgressMsg(var Message: TMessage);
var
  ShowWidth, ShowLeft: Integer;
begin
  ShowWidth := max(Min(Message.LParam, 100), 0) * A2ILabelProgress.Width div 100;
  ShowLeft := -(A2ILabelProgress.Width - ShowWidth);
  A2ILabelProgress.A2Image.DrawImage(A2ImageProgress, ShowLeft, 0, true);
  A2ILabelProgress.ReDraw;
end;

procedure TfrmItemUpgrade.Complex();
var
  i: integer;
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ItemUpgrade);
  WordComData_ADDbyte(temp, ItemUpgrade_Start);
  //发送rkey
  for i := Low(FItemUpgradeKeyArr) to High(FItemUpgradeKeyArr) do
  begin
    WordComData_ADDdword(temp, FItemUpgradeKeyArr[i].rkey);
  end;
  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmItemUpgrade.FormShow(Sender: TObject);
begin
  inherited;
  ItemUpgradeKeyArrClear;
end;

end.

