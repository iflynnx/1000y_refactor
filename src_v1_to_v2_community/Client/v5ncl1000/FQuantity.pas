unit FQuantity;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, A2Form, ExtCtrls, deftype, AUtil32, BaseUIForm;

type
  TQitemData = record
    itemName: string[16];
    Count: integer;
  end;

  TShowType = (SH_Server, SH_DepositoryIn, SH_DepositoryOut, SH_ExChange, SH_FAttrib, SH_NPCTrade, SH_NewEmail, SH_NewAuction, SH_Emporia);

  TFrmQuantity = class(TfrmBaseUI)
    BtnOK: TA2Button;
    BtnCancel: TA2Button;
    EdCount: TA2Edit;
    A2Button1: TA2Button;
    A2Form: TA2Form;
    LbCountName: TA2Label;
    lbMoneyType: TA2Label;
    lbTotalMoney: TA2Label;
    aItem: TA2ILabel;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Clear;
    procedure FormShow(Sender: TObject);
    procedure EdCountKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SetFormText;
    procedure A2Button1Click(Sender: TObject);
    procedure EdCountKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ILabelCaptionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FShowType: TShowType;
    procedure setShowType(const Value: TShowType);
  public
    msg: byte;
    Countid: LongInt;
    sourkey: word;
    destkey: word;
    CountCur: LongInt;
    CountMax: LongInt;
    CountName: string;  
    NpcItemName: string;
    price: Integer;
    procedure MYVisible(aVisible: Boolean; aType: TShowType; aItemName, aCount: string);
    procedure MessageProcess(var code: TWordComData);
    procedure showinputCount(aShowType: TShowType; asourkey, adestkey, aCountCur, aCountMax: integer; aCountName: string);
    //procedure SetOldVersion;
    procedure SetNewVersion(); override;
   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    property ShowType: TShowType read FShowType write setShowType; // TRUE ServerType
  end;

var
  FrmQuantity: TFrmQuantity;

implementation

uses
  FMain, FExchange, Fbl, FBottom, FDepository, FAttrib, FNPCTrade, filepgkclass, FEmporia;

{$R *.DFM}

procedure TFrmQuantity.showinputCount(aShowType: TShowType; asourkey, adestkey, aCountCur, aCountMax: integer; aCountName: string);
begin
  ShowType := aShowType;

  sourkey := asourkey;
  destkey := adestkey;
  CountCur := aCountCur;
  CountMax := aCountMax;
  CountName := aCountName;
  LbCountName.Caption := CountName;
  EdCount.Text := inttostr(CountCur);

  Top := fhei - (184 + Height + 10) - 40;
  Left := 20;
  Visible := true;
 // BringToFront;
end;

procedure TfrmQuantity.SetNewVersion;
begin
  inherited;
end;

//procedure TfrmQuantity.SetOldVersion;
//begin
//end;

procedure TFrmQuantity.FormCreate(Sender: TObject);
begin
  FAllowCache := True;
  inherited;
  FTestPos := True;
  A2Form.FImageSurface.Name := 'FImageSurface';   //2015.11.10 在水一方>
  FrmM.AddA2Form(Self, A2form);
//  Parent := FrmM;
  if WinVerType = wvtnew then
  begin
    SetNewVersion;
//  end
//  else
//  begin
//    SetOldVersion;
  end;

    // FrmQuantity Set Font
  EdCount.Font.Name := mainFont;
  LbCountName.Font.Name := mainFont;
  ShowType := SH_Server;
end;

procedure TFrmQuantity.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TFrmQuantity.Clear;
begin
  msg := 0;
  Countid := 0;
  sourkey := 0;
  destkey := 0;
  CountCur := 0;
  CountMax := 0;
  CountName := '';
  LbCountName.Caption := '';
  EdCount.Text := '';
end;

procedure TFrmQuantity.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  psCount: PTSCount;
  CSelectCount: TCSelectCount;
  tt, ttgod: pTSHaveItem;
  t2PTSNPCItem: PTSNPCItem;
begin
  pckey := @Code.data;
  case pckey^.rmsg of
    SM_SHOWCOUNT:
      begin
        psCount := @Code.data;
        msg := psCount^.rmsg;
        Countid := psCount^.rCountid;
        CountCur := psCount^.rCountCur;
        CountMax := psCount^.rCountMax;
        if CountMax = 0 then
          CountMax := 10000;
        sourkey := psCount^.rsourkey;
        destkey := psCount^.rdestkey;
        CountName := GetWordString(psCount^.rCountName);
           // if CountMax=1 then  MyVisible(TRUE, SH_Server, CountName, 1) else
        //MyVisible(TRUE, SH_Server, CountName, IntToStr(CountMax));
        MyVisible(TRUE, SH_Server, CountName, '0');
              {   //20130901修改

               if CountMax<>1 then MyVisible(TRUE, SH_Server, CountName, IntToStr(0))
               else begin
                    CSelectCount.rmsg := CM_SELECTCOUNT;
                    CSelectCount.rboOk := TRUE;
                    CSelectCount.rsourkey := sourkey;
                    CSelectCount.rdestkey := destkey;
                    CSelectCount.rCountid := Countid;
                    CSelectCount.rCount := CountMax;
                    FrmLogOn.SocketAddData(sizeof(CSelectCount), @CSelectCount);
                    FrmExchange.ExchangeLock := FALSE;

                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                   end;  }
      end;
  end;
end;

procedure TFrmQuantity.BtnOKClick(Sender: TObject);
var
  i: longint;
  CSelectCount: TCSelectCount;
  tt, ttgod: pTSHaveItem;
  t2PTSNPCItem: PTSNPCItem;
begin
  case ShowType of
    SH_Server: //丢 物品  在上
      begin
        i := _StrToInt(EdCount.Text);
        if (i > 0) and (i <= CountMax) then
        begin
          CSelectCount.rmsg := CM_SELECTCOUNT;
          CSelectCount.rboOk := TRUE;
          CSelectCount.rsourkey := sourkey;
          CSelectCount.rdestkey := destkey;
          CSelectCount.rCountid := Countid;
          CSelectCount.rCount := _StrToInt(EdCount.Text);
          Frmfbl.SocketAddData(sizeof(CSelectCount), @CSelectCount);
          FrmExchange.ExchangeLock := FALSE;

          Visible := FALSE;
          SAY_EdChatFrmBottomSetFocus;
        end
        else
        begin
                    // error
          CSelectCount.rmsg := CM_SELECTCOUNT;
          CSelectCount.rboOk := FALSE;
          CSelectCount.rsourkey := sourkey;
          CSelectCount.rdestkey := destkey;
          CSelectCount.rCountid := Countid;
          CSelectCount.rCount := 0;
          Frmfbl.SocketAddData(sizeof(CSelectCount), @CSelectCount);
          FrmExchange.ExchangeLock := FALSE;
          Visible := FALSE;
          FrmBottom.AddChat(('数量已满或没有'),  ColorSysToDxColor(clWhite), 9);
          SAY_EdChatFrmBottomSetFocus;
        end;
      end;
//    SH_NewAuction:
//      begin
//        i := _StrToInt(EdCount.Text);
//        if (i > 0) and (i <= CountMax) then
//        begin
//          frmAuctionBuy.FNEWItemKeyCount := i;
//          frmAuctionBuy.NEWitemDraw;
//
//          Visible := FALSE;
//          SAY_EdChatFrmBottomSetFocus;
//        end;
//      end;
//    SH_NewEmail:
//      begin
//        i := _StrToInt(EdCount.Text);
//        if (i > 0) and (i <= CountMax) then
//        begin
//          FrmNEWEmail.FNewItemKeyCount := i;
//          FrmNEWEmail.DrawOutNewMail;
//
//          Visible := FALSE;
//          SAY_EdChatFrmBottomSetFocus;
//        end;
//      end;
      //交易
    SH_ExChange:
      begin
        i := _StrToInt(EdCount.Text);
        if (i > 0) and (i <= CountMax) then
        begin
          FrmExchange.senditemadd(sourkey, i);
          Visible := FALSE;
          SAY_EdChatFrmBottomSetFocus;
        end;
      end;
    SH_DepositoryIn:
      begin
        i := _StrToInt(EdCount.Text);
        if (i > 0) and (i <= CountMax) then
        begin
          frmDepository.sendItemLogIn(sourkey, destkey, i);
          Visible := FALSE;
          SAY_EdChatFrmBottomSetFocus;
        end;
      end;
    SH_DepositoryOUt:
      begin
        i := _StrToInt(EdCount.Text);
        if (i > 0) and (i <= CountMax) then
        begin
          frmDepository.sendItemLogOUt(destkey, sourkey, i);
          Visible := FALSE;
          SAY_EdChatFrmBottomSetFocus;
        end;
      end;
    SH_FAttrib:
      begin

      end;
    SH_NPCTrade:
      begin
        i := _StrToInt(EdCount.Text);
        if i > 0 then
        begin
          Visible := FALSE;
          SAY_EdChatFrmBottomSetFocus;
          if frmNPCTrade.Visiblestate = 2 then
          begin
            //frmNPCTrade.SendNPCbuf(LbCountName.Caption, i);
            frmNPCTrade.SendNPCbuf(NpcItemName, i);
          end;
          if frmNPCTrade.Visiblestate = 3 then
          begin
            frmNPCTrade.SendNPCsell(frmNPCTrade.BuyItemKey, i);
          end;

        end;
      end;
    SH_Emporia:                 //2015.11.10 在水一方
      begin
        Visible := false;
        frmEmporia.Enabled := True;
        if _StrToInt(EdCount.Text) > 0 then
          frmEmporia.sendBuy(CountName, _StrToInt(EdCount.Text));
      end;
  end;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmQuantity.BtnCancelClick(Sender: TObject);
var
  CSelectCount: TCSelectCount;
begin
  case ShowType of
    SH_Server:
      begin
        CSelectCount.rmsg := CM_SELECTCOUNT;
        CSelectCount.rboOk := FALSE;
        CSelectCount.rsourkey := sourkey;
        CSelectCount.rdestkey := destkey;
        CSelectCount.rCountid := Countid;
        CSelectCount.rCount := 0;

        Frmfbl.SocketAddData(sizeof(CSelectCount), @CSelectCount);

        FrmExchange.ExchangeLock := FALSE;
        Visible := FALSE;
        Clear;
      end;
    SH_DepositoryOUt:
      begin
        Visible := FALSE;
        SAY_EdChatFrmBottomSetFocus;
      end;
    SH_DepositoryIn:
      begin
        Visible := FALSE;
        SAY_EdChatFrmBottomSetFocus;
      end;
    SH_FAttrib:
      begin
      end;
    SH_NPCTrade:
      begin
        Visible := false;
      end;
    SH_ExChange:
      begin
        Visible := FALSE;
        SAY_EdChatFrmBottomSetFocus;
      end;
    SH_Emporia:                 //2015.11.10 在水一方
      begin
        Visible := false;
        frmEmporia.Enabled := True;
      end;
  end;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmQuantity.FormShow(Sender: TObject);
begin
  case ShowType of
    SH_Server:
      begin
        FControlMark := '_trade';
        FrmExchange.ExchangeLock := TRUE;
        LbCountName.Caption := CountName;
        EdCount.Text := IntToStr(CountCur);
      end;
//    SH_DepositoryIn:
//      begin
//      end;
//    SH_FAttrib:
//      begin
//      end;
  end;
//  if WinVerType = wvtnew then
//  begin
//    Top := fhei - (117 + Height + 10) - 40;
//    Left := 20;
//    Width := 171;
//    Height := 90;
//  end
//  else
//  begin
//    Top := fhei - (117 + Height + 10);
//    Left := 20;
//  end;

  Top := fhei - (184 + Height + 10) - 40;
  Left := 20;
  if Visible then
  begin

    if FrmBottom.Visible then
      FocusControl(EdCount);
    EdCount.SelectAll;
    SetNewVersion;

  end;
end;

procedure TFrmQuantity.EdCountKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i: Integer;
begin
  if key = 13 then
  begin
    BtnOKClick(Self);
    Exit;
  end;
  if key = VK_ESCAPE then
  begin
    BtnCancelClick(Self);
    Exit;
  end;

  if key = 38 then
  begin
    A2Button1Click(nil);
    Exit;
  end;
  if KEY = 40 then
  begin
        //下
    TA2Edit(Sender).Text := '0';
    if Visible then
    begin
      EdCount.SetFocus;
    end;
    Exit;
  end;
  i := StrToIntDef(TA2Edit(Sender).Text, CountMax);

  if i > CountMax then
  begin
    TA2Edit(Sender).Text := IntToStr(CountMax);
  end
  else
    TA2Edit(Sender).Text := IntToStr(i);
end;

procedure TFrmQuantity.SetFormText;
begin
  Font.Name := mainFont;

  LbCountName.Font.Name := mainFont;
  EdCount.Font.Name := mainFont;
end;

procedure TFrmQuantity.MYVisible(aVisible: Boolean; aType: TShowType; aItemName, aCount: string);
begin
  Visible := aVisible;
  ShowType := aType;
  LbCountName.Caption := aItemName;
  EdCount.Text := aCount;
  lbTotalMoney.Caption := IntToStr(price * strtointdef(aCount, 0));
  FrmQuantity.EdCount.SelStart := Length(FrmQuantity.EdCount.Text);
  FrmQuantity.EdCount.SelectAll;
end;

procedure TFrmQuantity.A2Button1Click(Sender: TObject);
begin
    //上
  EdCount.Text := inttostr(CountMax);
  lbTotalMoney.Caption := IntToStr(price * CountMax);
  if Visible then
  begin
    EdCount.SetFocus;

  end;
end;

procedure TFrmQuantity.SetConfigFileName;
begin
  FConfigFileName := 'Quantity.xml';

end;

//procedure TFrmQuantity.SetNewVersionOld;
//var
//  temping: TBitmap;
//begin
//  temping := TBitmap.Create;
//  try
////    pgkBmp.getBitmap('物品买卖丢弃窗口.bmp', temping);
////    Image1.Picture.Bitmap := temping;
////    Image1.Width := temping.Width;
////    Image1.Height := temping.Height;
//    pgkBmp.getBmp('物品买卖丢弃窗口.bmp', A2form.FImageSurface);
//    A2form.boImagesurface := true;
//    pgkBmp.getBitmap('通用_确认_弹起.bmp', temping);
//    BtnOK.UpImage.Bitmap := temping;
//    pgkBmp.getBitmap('通用_确认_按下.bmp', temping);
//    BtnOK.DownImage.Bitmap := temping;
//    pgkBmp.getBitmap('通用_确认_鼠标.bmp', temping);
//    BtnOK.ImageMouse.Bitmap := temping;
//    pgkBmp.getBitmap('通用_确认_禁止.bmp', temping);
//    BtnOK.ImageNotEnabled.Bitmap := temping;
//    BtnOK.Left := 46;
//    BtnOK.Top := 56;
//    BtnOK.Width := 56;
//    BtnOK.Height := 22;
//
//    pgkBmp.getBitmap('通用_取消_弹起.bmp', temping);
//    BtnCancel.UpImage.Bitmap := temping;
//    pgkBmp.getBitmap('通用_取消_按下.bmp', temping);
//    BtnCancel.DownImage.Bitmap := temping;
//    pgkBmp.getBitmap('通用_取消_鼠标.bmp', temping);
//    BtnCancel.ImageMouse.Bitmap := temping;
//    pgkBmp.getBitmap('通用_取消_禁止.bmp', temping);
//    BtnCancel.ImageNotEnabled.Bitmap := temping;
//    BtnCancel.Left := 102;
//    BtnCancel.Top := 56;
//    BtnCancel.Width := 56;
//    BtnCancel.Height := 22;
//
//    LbCountName.Left := 50;
//    LbCountName.Top := 15;
//    LbCountName.Width := 106;
//    LbCountName.Height := 15;
//
//    EdCount.Left := 46;
//    EdCount.Top := 26;
//    EdCount.Width := 106;
//    EdCount.Height := 15;
//
//    A2Button1.Visible := false;
//  finally
//    temping.Free;
//  end;
//end;

procedure TFrmQuantity.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  //A2Form.FImageSurface.Name := 'FImageSurface';      //2015.11.10 在水一方
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(BtnOK);

  SetControlPos(BtnCancel);

  SetControlPos(LbCountName);
  SetControlPos(A2Button1);
  SetControlPos(EdCount);
  if FrmExchange.Visible then
  begin
    Left := FrmExchange.Left + 10;
    Top := FrmExchange.Top + FrmExchange.Height ;
  end;
  SetControlPos(lbMoneyType);
  SetControlPos(lbTotalMoney);
  SetControlPos(aItem);

end;

procedure TFrmQuantity.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure TFrmQuantity.setShowType(const Value: TShowType);
begin
  FShowType := Value;
  
  FrmM.AddA2Form(Self, A2form);

  case FShowType of
    SH_NPCTrade:
      FControlMark := '_buy';
    SH_Emporia:
      FControlMark := '_emp';
  else
    FControlMark := '';
  end;
  SetNewVersionTest;
end;

procedure TFrmQuantity.EdCountKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  I: Integer;
begin
  inherited;
  i := StrToIntDef(TA2Edit(Sender).Text, CountMax);
  if i > CountMax then
  begin

    TA2Edit(Sender).Text := IntToStr(CountMax);

  end
  else
    TA2Edit(Sender).Text := IntToStr(i);

  lbTotalMoney.Caption := IntToStr(price * i);
 // lbTotalMoney.Caption:=Self.p
end;

procedure TFrmQuantity.ILabelCaptionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
 // if Button = mbLeft then
 //   FrmM.move_win_form_set(self, x, y);
 // FrmM.SetA2Form(Self, A2form);
end;

end.

