unit FItemHelp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, StdCtrls, A2Img, DefType, AUtil32;

type
  TfrmItemHelp = class(TForm)
    A2Form: TA2Form;
    btnClose: TA2Button;
    imgItem: TA2ILabel;
    listContent: TA2ListBox;
    lbItemName: TA2Label;
    lbGrade: TA2Label;
    btnReserved: TA2Button;
    A2Label1: TA2Label;
    btnLock: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure listContentAdxDrawItem(ASurface: TA2Image; Index: Integer;
      aStr: string; Rect: TRect; State: TDrawItemState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnReservedClick(Sender: TObject);
    procedure btnLockClick(Sender: TObject);
    procedure A2Button1Click(Sender: TObject);
  private
    ItemImage: TA2Image;
    bMoveFlag: Boolean;
    nMoveX, nMoveY: integer;
  public
    procedure MessageProcess(var Code: TWordComData);
  end;

var
  frmItemHelp: TfrmItemHelp;

implementation

uses
  FBottom, FMain, FHelp, AtzCls, FAttrib, FLogon,
  FBestMagic, FSpecialMagic;

{$R *.DFM}

procedure TfrmItemHelp.FormCreate(Sender: TObject);
begin
  FrmM.AddA2Form(Self, A2Form);
  A2Form.SetBackImageFile('.\ect\itembase2.bmp');
  SetBounds(100, 100, 256, 187);

  //   listContent.SetBackImage(EtcViewClass[10]);
  listContent.SetScrollBottomImage(EtcViewClass[18], EtcViewClass[19]);
  listContent.SetScrollTopImage(EtcViewClass[20], EtcViewClass[21]);
  listContent.SetScrollTrackImage(EtcViewClass[22], EtcViewClass[23]);

  ItemImage := TA2Image.Create(32, 32, 0, 0);
  btnClose.Caption := Conv('关闭');
end;

procedure TfrmItemHelp.btnCloseClick(Sender: TObject);
begin
  Visible := False;
  //FrmBottom.FocusControl(FrmBottom.EdChat);
end;

function GetLine(var str: string; divider: string): string;
var
  n: integer;
begin
  n := Pos(divider, str);
  if n > 0 then
  begin
    Result := Copy(str, 1, n - 1);
    Delete(str, 1, n + Length(divider) - 1);
  end
  else
  begin
    Result := str;
    str := '';
  end;
end;

procedure TfrmItemHelp.MessageProcess(var Code: TWordComData);
var
  pItemInfo: PTSItemWindow2;
  pItemInfo3: PTSItemWindow3;
  Price: integer;
  ItemViewName, Content, Line, str: string;
begin
  pItemInfo := @Code.Data;

  case pItemInfo.rMsg of
    SM_ITEMHELPWINDOW2:
      begin
        ItemViewName := StrPas(@pItemInfo^.rViewName);
        Price := pItemInfo^.rPrice;
        Content := GetWordString(pItemInfo^.rWordString);
        frmAttrib.SetItemLabel(imgItem, '', pItemInfo^.rColor,
          pItemInfo^.rShape);

        listContent.Clear;

        lbItemName.Caption := ItemViewName;

        if pItemInfo^.rGrade > 0 then
          lbGrade.Caption := Format(Conv('[%d品]'), [pItemInfo^.rGrade])
        else
          lbGrade.Caption := '';

        repeat
          Line := GetLine(Content, '<br>');
          while Line <> '' do
            listContent.AddItem(CutLengthString(Line, 220));
        until Content = '';

        if Price > 0 then
        begin
          listContent.AddItem(''); // 后临..
          listContent.AddItem(Format(Conv('价格 : %d 钱币'), [Price])); // 啊拜
        end;

        btnReserved.Caption := '';

        case pItemInfo^.rLockState of
          1:
            begin
              A2Label1.Caption := '';
              btnLock.Caption := Conv('解锁');
              btnLock.Tag := 1;
              btnLock.Visible := True;
            end;
          2:  //加锁中
            begin
              A2Label1.Caption := Format(Conv('解锁时间已过%2.2f小时'), [pItemInfo^.runLockTime / 60]);
              btnLock.Caption := Conv('加锁');
              btnLock.Tag := 2;
              btnLock.Visible := True;
            end;
          else
            begin
              A2Label1.Caption := '';
              btnLock.Caption := Conv('加锁');
              btnLock.Tag := 0;
              btnLock.Visible := (FrmAttrib.CurrentWindow = WINDOW_ITEMS);
            end;
        end;

        btnReserved.Visible := False;
      end;
    SM_ITEMHELPWINDOW3:
      begin
        pItemInfo3 := @Code.Data;
        ItemViewName := StrPas(@pItemInfo3.rViewName);
        Content := GetWordString(pItemInfo3.rWordString);
        frmAttrib.SetItemLabel(imgItem, '', pItemInfo3.rColor,
          pItemInfo3.rShape);

        listContent.Clear;

        lbItemName.Caption := ItemViewName;
        lbGrade.Caption := '';

        repeat
          Line := GetLine(Content, '<br>');
          while Line <> '' do
            listContent.AddItem(CutLengthString(Line, 220));
        until Content = '';

        str := StrPas(@pItemInfo3.rButton);
        btnReserved.Caption := str;
        btnReserved.Visible := True;
        btnReserved.Width := ATextWidth(str);
        btnReserved.Height := ATextHeight(str);
        btnReserved.Left := btnClose.Left - btnReserved.Width - 8;
        btnReserved.Tag := pItemInfo3.rKey;
      end;
  end;
  {
     if pItemInfo^.rMsg <> SM_ITEMHELPWINDOW2 then exit;

     ItemViewName := StrPas(@pItemInfo^.rViewName);
     Price := pItemInfo^.rPrice;
     Content := GetWordString(pItemInfo^.rWordString);
     frmAttrib.SetItemLabel(imgItem, '', pItemInfo^.rColor, pItemInfo^.rShape);

     listContent.Clear;

     // 酒捞袍 捞抚
     lbItemName.Caption := ItemViewName;

     // 酒捞袍 殿鞭
     if pItemInfo^.rGrade > 0 then
        lbGrade.Caption := Format(Conv('[%d品]'), [pItemInfo^.rGrade])
     else
        lbGrade.Caption := '';

  //   listContent.AddItem(ItemViewName);
  //   if Content <> '' then listContent.AddItem('');

     // 酒捞袍 汲疙
     repeat
        Line := GetLine(Content, '<br>');
        while Line <> '' do
           listContent.AddItem(CutLengthString(Line, 220));
     until Content = '';

     if Price > 0 then begin
        listContent.AddItem('');               // 后临..
        listContent.AddItem(Format('啊拜 : %d 傈', [Price])); // 啊拜
     end;
  }
  FrmM.ShowA2Form(Self);
  frmBestMagic.Visible := False;
  frmSpecialMagic.Visible := False;
  bMoveFlag := False;

  if listContent.Count > 7 then
    FocusControl(listContent);
end;

procedure TfrmItemHelp.FormDestroy(Sender: TObject);
begin
  //   FItemInfo.Free;
  ItemImage.Free;
end;

procedure TfrmItemHelp.listContentAdxDrawItem(ASurface: TA2Image;
  Index: Integer; aStr: string; Rect: TRect; State: TDrawItemState);
var
  n: integer;
  Tag: string;
  col: Word;
begin
  ASurface.Clear(0);

  if (Length(aStr) > 0) and (aStr[1] = '<') then
  begin
    n := Pos('>', aStr);
    Tag := Copy(aStr, 2, n - 2);
    Delete(aStr, 1, n);

    if CompareText(Tag, 'c1') = 0 then
      Col := WinRGB(30, 0, 0)
    else if CompareText(Tag, 'c2') = 0 then
      Col := WinRGB(30, 15, 0)
    else if CompareText(Tag, 'c3') = 0 then
      Col := WinRGB(30, 30, 0)
    else if CompareText(Tag, 'c4') = 0 then
      Col := WinRGB(0, 30, 0)
    else if CompareText(Tag, 'c5') = 0 then
      Col := WinRGB(0, 0, 30)
    else if CompareText(Tag, 'c6') = 0 then
      Col := WinRGB(15, 0, 30)
    else if CompareText(Tag, 'c7') = 0 then
      Col := WinRGB(30, 0, 30)
    else
      Col := 32767;

    ATextOut(ASurface, Rect.Left, Rect.Top, Col, aStr);
  end
  else
  begin // 老馆 扼牢
    ATextOut(ASurface, Rect.Left, Rect.Top, 32767, aStr);
  end;
end;

procedure TfrmItemHelp.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bMoveFlag := True;

  nMoveX := X;
  nMoveY := Y;
end;

procedure TfrmItemHelp.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  tx, ty: integer;
begin
  if bMoveFlag then
  begin
    tx := Left + X - nMoveX;
    ty := Top + Y - nMoveY;

    if tx < 0 then
      tx := 0;
    if tx > 640 - Width then
      tx := 640 - Width;
    if ty < 0 then
      ty := 0;
    if ty > 480 - frmBottom.Height - Height then
      ty := 480 - frmBottom.Height - Height;

    Left := tx;
    Top := ty;
  end;
end;

procedure TfrmItemHelp.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bMoveFlag := False;
end;

procedure TfrmItemHelp.btnReservedClick(Sender: TObject);
var
  cKey: TCKey;
begin
  cKey.rmsg := CM_ITEMBUTTON;
  cKey.rkey := btnReserved.Tag;

  frmLogon.SocketAddData(sizeof(TCKey), @cKey);
end;

procedure TfrmItemHelp.btnLockClick(Sender: TObject);
var
  tLock: TLockItem;
begin
  case TA2Button(Sender).Tag of
    1:
      begin
        tLock.rmsg := CM_UNLOCKITEM;
        tLock.rkey := SelectHaveItem;
        FrmLogon.SocketAddData(SizeOf(tLock), @tLock);
      end;
    else
      begin
        tLock.rmsg := CM_LOCKITEM;
        tLock.rkey := SelectHaveItem;
        FrmLogon.SocketAddData(SizeOf(tLock), @tLock);
      end;
  end;
  Visible := False;
  //FrmBottom.FocusControl(FrmBottom.EdChat);  
end;

procedure TfrmItemHelp.A2Button1Click(Sender: TObject);
var
  s: String;
begin
  with listContent do
  begin
    AddItem(Conv('说明：贵重物品需要加锁保护，请点'));
    AddItem(Conv('击加锁按钮保护您的贵重物品，需要'));
    AddItem(Conv('交易时请选择解锁按钮，在线24小时'));
    AddItem(Conv('后此物品才能进行交易。'));
    //
    AddItem(Conv('说明：贵重物品已加锁保护，如需交'));
    AddItem(Conv('易，请选择解锁按钮，解除锁定在线'));
    AddItem(Conv('24小时后此物品才能进行交易。'));
  end;
end;

end.

