unit FWearItemUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, FAttrib, Deftype, BaseUIForm, NativeXml;

type
  TfrmWearItemUser = class(TfrmBaseUI)
    A2Form: TA2Form;
    LbChar: TA2ILabel;
    A2LabeluserName: TA2Label;
    A2ILabel9: TA2ILabel;
    A2ILabel8: TA2ILabel;
    A2ILabel7: TA2ILabel;
    A2ILabel6: TA2ILabel;
    A2ILabel5: TA2ILabel;
    A2ILabel4: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel13: TA2ILabel;
    A2ILabel12: TA2ILabel;
    A2ILabel11: TA2ILabel;
    A2ILabel10: TA2ILabel;
    A2ILabel1: TA2ILabel;
    A2ILabel0: TA2ILabel;
    A2Button6: TA2Button;
    LbCharFD: TA2ILabel;
    A2ILabelFD9: TA2ILabel;
    A2ILabelFD8: TA2ILabel;
    A2ILabelFD7: TA2ILabel;
    A2ILabelFD6: TA2ILabel;
    A2ILabelFD5: TA2ILabel;
    A2ILabelFD4: TA2ILabel;
    A2ILabelFD3: TA2ILabel;
    A2ILabelFD2: TA2ILabel;
    A2ILabelFD13: TA2ILabel;
    A2ILabelFD12: TA2ILabel;
    A2ILabelFD11: TA2ILabel;
    A2ILabelFD10: TA2ILabel;
    A2ILabelFD1: TA2ILabel;
    A2ILabelFD0: TA2ILabel;
    A2LabelGuildName: TA2Label;
    A2ILabel14: TA2ILabel;
    A2Button_Trade: TA2Button;
    A2Button_Msg: TA2Button;
    A2Button_Friends: TA2Button;
    A2Button_Team: TA2Button;
    A2Button_Flower: TA2Button;
    A2Button_Egg: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure A2Button6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ILabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2ILabelFD0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LbCharMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LbCharFDMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LbCharMouseLeave(Sender: TObject);
    procedure A2Button_TradeClick(Sender: TObject);
    procedure A2Button_MsgClick(Sender: TObject);
    procedure A2Button_TradeMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure A2Button_TradeMouseLeave(Sender: TObject);
    procedure A2Button_MsgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Button_MsgMouseLeave(Sender: TObject);
    procedure A2Button_EggClick(Sender: TObject);
    procedure A2Button_EggMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Button_EggMouseLeave(Sender: TObject);
    procedure A2Button_FlowerMouseLeave(Sender: TObject);
    procedure A2Button_FlowerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure A2Button_FriendsMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure A2Button_FriendsMouseLeave(Sender: TObject);
    procedure A2Button_FlowerClick(Sender: TObject);
    procedure A2Button_FriendsClick(Sender: TObject);
    procedure A2Button_TeamClick(Sender: TObject);
    procedure A2Button_TeamMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure A2Button_TeamMouseLeave(Sender: TObject);

  private
    FHintWidth: Integer;
    FHintHeight: Integer;
    FHintLeft: Integer;
    FHintTop: Integer;
  public
        { Public declarations }
    SendTick: integer;
    FUSERID: INTEGER;

    Feature: TFeature;
    FeatureFD: TFeature;
    CharCenterImage: TA2Image;
        //  wearimg:TA2Image;
        //  wearimgFD:TA2Image;
    CharCenterImageFD: TA2Image;
    A2ImageWearBack: TA2Image;
    FItemArr: array[0..13] of TA2ILabel;
    FItemFDArr: array[0..13] of TA2ILabel;
    A2Image_UserBack: TA2Image;
    procedure SetFeature();
    procedure DrawWearItem;

    procedure ItemFDPaint(akey: integer; aitem: titemdata);
    procedure ItemPaint(akey: integer; aitem: titemdata);


    procedure SetOldVersion;
    procedure SetNewVersion(); override;


    procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure onupdate();
    function OtherUsercAttribClassToHint(AcAttribClass: TcAttribClass): string;
    procedure SetOtherConfig();
  end;
var
  frmWearItemUser: TfrmWearItemUser;
  tempingx: TA2Image;

implementation

uses FMain, FWearItem, CharCls, uAnsTick, filepgkclass, fbl, FBottom, FNEWHailFellow;

{$R *.dfm}

procedure TfrmWearItemUser.FormDestroy(Sender: TObject);
begin
  inherited; // 内存泄漏007 在水一方 2015.05.18

  CharCenterImage.free;

  CharCenterImageFD.free;

  tempingx.Free;
end;

procedure TfrmWearItemUser.SetNewVersion;

begin
  inherited;
end;

procedure TfrmWearItemUser.SetOldVersion;
begin
    //
  pgkBmp.getBmp('Userwear.bmp', A2Form.FImageSurface);
  A2form.boImagesurface := true;
    //Width := 325;
    //Height := 500;
    // LbChar.A2Image := FrmAttrib.CharCenterImage;
 //  wearimg := TA2Image.Create(ClientWidth, ClientHeight, 0, 0);
 //  wearimgFD := TA2Image.Create(ClientWidth, ClientHeight, 0, 0);
 //  wearimg.LoadFromFile('wear.bmp');
 //  wearimgFD.LoadFromFile('wearFD.bmp');

//   A2ILImg.A2Image := wearimg;
  //A2ILImgFD.A2Image := wearimgFD;
   //Parent := FrmM;
  CharCenterImage := TA2Image.Create(56, 72, 0, 0);
  LbChar.A2Image := CharCenterImage;
  CharCenterImageFD := TA2Image.Create(56, 72, 0, 0);
  LbCharFD.A2Image := CharCenterImageFD;
//    A2Form.FA2Hint.Ftype := hstTransparent;
end;

procedure TfrmWearItemUser.FormCreate(Sender: TObject);
var
  i: integer;
begin
  inherited;
  self.FTestPos := True;

  FrmM.AddA2Form(Self, A2Form);

  CharCenterImage := TA2Image.Create(56, 72, 0, 0);
  LbChar.A2Image := CharCenterImage;

  CharCenterImageFD := TA2Image.Create(56, 72, 0, 0);
  LbCharFD.A2Image := CharCenterImageFD;
  A2ImageWearBack := TA2Image.Create(32, 32, 0, 0);
  A2ImageWearBack.Name := 'A2ImageWearBack';
  A2Image_UserBack := TA2Image.Create(32, 32, 0, 0);
  Top := 0;
  Left := 0;
  FItemArr[0] := A2ILabel0;
  FItemArr[1] := A2ILabel1;
  FItemArr[2] := A2ILabel2;
  FItemArr[3] := A2ILabel3;
  FItemArr[4] := A2ILabel4;
  FItemArr[5] := A2ILabel5;
  FItemArr[6] := A2ILabel6;
  FItemArr[7] := A2ILabel7;
  FItemArr[8] := A2ILabel8;
  FItemArr[9] := A2ILabel9;
  FItemArr[10] := A2ILabel10;
  FItemArr[11] := A2ILabel11;
  FItemArr[12] := A2ILabel12;
  FItemArr[13] := A2ILabel13;

  FItemFDArr[0] := A2ILabelFD0;
  FItemFDArr[1] := A2ILabelFD1;
  FItemFDArr[2] := A2ILabelFD2;
  FItemFDArr[3] := A2ILabelFD3;
  FItemFDArr[4] := A2ILabelFD4;
  FItemFDArr[5] := A2ILabelFD5;
  FItemFDArr[6] := A2ILabelFD6;
  FItemFDArr[7] := A2ILabelFD7;
  FItemFDArr[8] := A2ILabelFD8;
  FItemFDArr[9] := A2ILabelFD9;
  FItemFDArr[10] := A2ILabelFD10;
  FItemFDArr[11] := A2ILabelFD11;
  FItemFDArr[12] := A2ILabelFD12;
  FItemFDArr[13] := A2ILabelFD13;

  for i := 0 to high(FItemArr) do
  begin
    FItemArr[i].Tag := i;
  end;
  for i := 0 to high(FItemFDArr) do
  begin
    FItemFDArr[i].Tag := i;
  end;

  tempingx := TA2Image.Create(32, 32, 0, 0);
  if WinVerType = wvtnew then
  begin
    SetNewVersion;
  end
  else
  begin
    SetOldVersion;
  end;
  cOtherUserAttribClass.OtherUserUpdate := self.onupdate;
end;

procedure TfrmWearItemUser.SetFeature();
var
  i: integer;
begin
  for i := ARR_GLOVES to ARR_WEAPON do
  begin
    Feature.rArr[i * 2] := WearUseritemClass.Wear.get(i).rWearShape;
    Feature.rArr[i * 2 + 1] := WearUseritemClass.Wear.get(i).rColor;
  end;

  for i := ARR_GLOVES to ARR_WEAPON do
  begin
    FeatureFD.rArr[i * 2] := WearUseritemClass.WearFD.get(i).rWearShape;
    FeatureFD.rArr[i * 2 + 1] := WearUseritemClass.WearFD.get(i).rColor;
  end;
  FeatureFD.rArr[ARR_WEAPON * 2] := WearUseritemClass.Wear.get(ARR_WEAPON).rWearShape;
  FeatureFD.rArr[ARR_WEAPON * 2 + 1] := WearUseritemClass.Wear.get(ARR_WEAPON).rColor;
end;

procedure TfrmWearItemUser.DrawWearItem;
var
  i, gc, ga: integer;

  Cl: TCharClass;
  ImageLib: TA2ImageLib;
  Bitmap1, Bitmap2: TBitmap;
  a, b: trect;
begin
  Cl := CharList.CharGet(FUSERID);
  A2LabeluserName.Caption := '';
  A2LabelGuildName.Caption := '';
  if Cl = nil then exit;
  A2LabeluserName.Caption := Cl.rName;
  A2LabelGuildName.Caption := cl.GuildName;
  Feature.rboman := CL.Feature.rboMan;
  FeatureFD.rboman := CL.Feature.rboMan;
  CharCenterImage.Clear(0);
  A2Image_UserBack.Setsize(LbChar.Width, LbChar.Height);
  try
    Bitmap1 := TBitmap.Create;
  //  Bitmap1.PixelFormat:= pf24bit ;
    Bitmap1.Width := A2form.FImageSurface.Width;
    Bitmap1.Height := A2form.FImageSurface.Height;
    Bitmap2 := TBitmap.Create;
    Bitmap2.Width := LbChar.Width;
    Bitmap2.Height := LbChar.Height;

   // stream:=TMemoryStream.Create;
    //  A2form.FImageSurface.SaveToStream(stream);
   // Bitmap1.LoadFromStream(stream);
//    A2form.FImageSurface.SaveToFile('bt1.bmp');
//    Bitmap1.LoadFromFile('bt1.bmp');
    A2form.FImageSurface.SaveToBitmap(Bitmap1);
   // Bitmap1.SaveToFile('bt1.bmp');
    a := rect(0, 0, LbChar.Width, LbChar.Height);
    b := rect(LbChar.Left, LbChar.Top, LbChar.Left + LbChar.Width, LbChar.Top + LbChar.Height);
    Bitmap2.Canvas.CopyRect(a, Bitmap1.Canvas, b);
// Bitmap2.Canvas.Draw(0,0,Bitmap1);
   // A2Image_3.DrawImageEx(A2form.FImageSurface,imgImage.Left, imgImage.Top,  imgImage.Width,  imgImage.Height,True);
 //  A2Image_3.SaveToFile('xxx.bmp');
    A2Image_UserBack.LoadFromBitmap(Bitmap2);
  finally
  //  stream.Free;
    Bitmap2.Free;
    Bitmap1.Free;
  end;
  CharCenterImage.DrawImage(A2Image_UserBack, 0, 0, True);
  for i := 0 to 13 - 1 do
  begin
    ImageLib := FrmWearItem.GetArrImageLib(i, mmAnsTick, Feature);
    if ImageLib <> nil then
    begin
      GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
      if Feature.rArr[i * 2 + 1] = 0 then
        CharCenterImage.DrawImage(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, TRUE)
      else
        CharCenterImage.DrawImageGreenConvert(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, gc, ga);
    end;
  end;



  LbChar.A2Image := CharCenterImage;
  CharCenterImageFD.Clear(0);

  for i := 0 to 13 - 1 do
  begin
    ImageLib := FrmWearItem.GetArrImageLib(i, mmAnsTick, FeatureFD);
    if ImageLib <> nil then
    begin
      GetGreenColorAndAdd(FeatureFD.rArr[i * 2 + 1], gc, ga);
      if FeatureFD.rArr[i * 2 + 1] = 0 then
        CharCenterImageFD.DrawImage(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, TRUE)
      else
        CharCenterImageFD.DrawImageGreenConvert(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, gc, ga);
    end;
  end;
  LbCharFD.A2Image := CharCenterImageFD;
end;

procedure TfrmWearItemUser.ItemFDPaint(akey: integer; aitem: titemdata);
var
  idx: integer;
  str: string;
begin
  if Visible = false then Visible := true;

  FrmM.SetA2Form(Self, A2Form);
  FrmM.move_win_form_Align(self, mwfCenter);

  begin
    str := (aitem.rViewName);
    if str = '' then
    begin
      FItemFDArr[akey].Visible := false;
    end else
    begin
      if aitem.rlockState = 1 then idx := 24
      else if aitem.rlockState = 2 then idx := 25
      else idx := 0;
      FrmAttrib.SetItemLabel(FItemFDArr[akey]
        , ''
        , aitem.rColor
        , aitem.rShape
        , idx, 0

        );
      FItemFDArr[akey].A2Imageback := A2ImageWearBack; // A2ILabel14.A2Imageback;
      FItemFDArr[akey].Visible := true;
    end;
  end;
  SetFeature;
  DrawWearItem;
end;

procedure TfrmWearItemUser.ItemPaint(akey: integer; aitem: titemdata);
var
  idx: integer;
  str, view: string;

begin

  if Visible = false then Visible := true;

  FrmM.SetA2Form(Self, A2Form);
  FrmM.move_win_form_Align(self, mwfCenter);

  begin
    str := (aitem.rViewName);
       //  aitem.rColor:=aitem.rStarLevel;
    if aitem.rStarLevel = 3 then view := '完美';
    if str = '' then
    begin
      FItemArr[akey].Visible := false;
    end else
    begin
      if aitem.rlockState = 1 then idx := 24
      else if aitem.rlockState = 2 then idx := 25
      else idx := 0;
      FItemArr[akey].A2Imageback := A2ImageWearBack;
      FItemArr[akey].A2Image :=  A2ImageWearBack;
      FrmAttrib.SetItemLabel(FItemArr[akey]
        , view
        , aitem.rColor
        , aitem.rShape
        , idx, 0

        );

    //  tempingx.CopyImage(A2ImageWearBack);
     // tempingx.addColor(clRed, clRed, clred); //20130720修改背景，改成黑的了

      FItemArr[akey].Visible := true;

    end;
  end;

  SetFeature;
  DrawWearItem;

end;

procedure TfrmWearItemUser.A2Button6Click(Sender: TObject);
begin
  Visible := false;
end;

procedure TfrmWearItemUser.A2ILabel0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), TItemDataToStr(WearUseritemClass.Wear.get(TA2ILabel(sender).tag)));
end;

procedure TfrmWearItemUser.A2ILabelFD0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), TItemDataToStr(WearUseritemClass.Wearfd.get(TA2ILabel(sender).tag)));
end;

procedure TfrmWearItemUser.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmWearItemUser.LbCharMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
  GameHintByPos.setA2Hint_X(FHintLeft + self.Left);
  GameHintByPos.setA2Hint_Y(FHintTop + self.Top);
  GameHintByPos.MaxHeigth := FHintHeight;
  GameHintByPos.MaxWidth := FHintWidth;
  GameHintByPos.settext(-1, OtherUsercAttribClassToHint(cOtherUserAttribClass));
end;

procedure TfrmWearItemUser.LbCharFDMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TfrmWearItemUser.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;



procedure TfrmWearItemUser.onupdate;
begin

end;

procedure TfrmWearItemUser.LbCharMouseLeave(Sender: TObject);
begin
  GameHintByPos.Close;
end;

function TfrmWearItemUser.OtherUsercAttribClassToHint(
  AcAttribClass: TcAttribClass): string;
var
  n, rDefaultValue: integer;
  sInPower, sOutPower, sMagic, sLv, sTotal: string;
  Cl: TCharClass;
begin
  Result := '';

  Cl := CharList.CharGet(FUSERID);
  if Cl = nil then exit;

  Result := Result + '门派: ' + Cl.GuildName + #13#10 + '{2} ' + #13#10;
   //具体数据获取procedure TfrmCharAttrib.onupdate();
  with AcAttribClass.AttribData do
  begin
//    Result := Result + '门派: ' + A2LabelGuildName.Caption + #13#10 + '{2} ' + #13#10;
    Result := Result + format('年龄: %s  元气: %s', [Get10000To100(cAge), Get10000To100(cEnergy)]) + #13#10 + '{2} ' + #13#10;
    Result := Result + format('活力: %s  内功: %s', [Get10000To100(cLife), Get10000To100(cInPower)]) + #13#10 + '{2} ' + #13#10;
    Result := Result + format('外功: %s  武功: %s', [Get10000To100(cOutPower), Get10000To100(cMagic)]) + #13#10 + '{2} ' + #13#10;
    Result := Result + format('耐性: %s  再生: %s', [Get10000To100(cAdaptive), Get10000To100(cRevival)]) + #13#10 + '{2} ' + #13#10;

//    rDefaultValue := ((cAge + 1200) div 2);
//
//    sInPower := '内功:' + Get10000To100(cInPower);
//    sOutPower := '外功:' + Get10000To100(cOutPower);
//    sMagic := '武功:' + Get10000To100(cMagic);
//
//    n := cMagic + cInPower + cOutPower + cLife;
//    n := (n - 5000) div 4000;
//    n := n - 5;
//    if n <= 0 then n := 1;
//    if n > 6 then n := 6;
//    sLv := inttostr(n) + '境界';
//
//    sTotal := '三攻:' + Get10000To100(rDefaultValue + cLife + cMagic + cOutPower + cInPower);
  end;
   //具体数据获取procedure TfrmCharAttrib.onupdate();
  with AcAttribClass.LifeData do
  begin
    Result := Result + format('速度: %d  恢复: %d', [AttackSpeed, recovery]) + #13#10 + '{2} ' + #13#10;
    Result := Result + format('命中: %d  躲闪: %d', [accuracy, avoid]) + #13#10 + '{2} ' + #13#10;
    Result := Result + format('攻击: %d/%d/%d/%d', [damageBody, damageHead, damageArm, damageLeg]) + #13#10 + '{2} ' + #13#10;
    Result := Result + format('防御: %d/%d/%d/%d', [armorBody, armorHead, armorArm, armorLeg]) + #13#10 + '{2} ' + #13#10;
  end;

  //Result := Result + sLv + ' ' + sTotal + #13#10;
  //Result := Result + sOutPower + #13#10;
  //Result := Result + sMagic + #13#10;
  //140 210;
end;

procedure TfrmWearItemUser.SetConfigFileName;
begin
  FConfigFileName := 'OtherUserInfo.xml';

end;

procedure TfrmWearItemUser.SetNewVersionOld;
var
  temping: TA2Image;
begin

  pgkBmp.getBmp('查看装备窗口.bmp', A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  Width := A2Form.FImageSurface.Width;
  Height := A2Form.FImageSurface.Height;

  CharCenterImage := TA2Image.Create(56, 72, 0, 0);
  LbChar.A2Image := CharCenterImage;
  LbChar.Left := 60;
  LbChar.Top := 64;
  LbChar.Width := 85;
  LbChar.Height := 113;
  CharCenterImageFD := TA2Image.Create(56, 72, 0, 0);
  LbCharFD.A2Image := CharCenterImageFD;
  LbCharFD.Left := 266;
  LbCharFD.Top := 64;
  LbCharFD.Width := 85;
  LbCharFD.Height := 113;
//    A2Form.FA2Hint.Ftype := hstTransparent;

  A2ILabel8.Left := 13;
  A2ILabel8.Top := 36 + 2;
  A2ILabel7.Left := 13;
  A2ILabel7.Top := 80 + 2;
  A2ILabel1.Left := 13;
  A2ILabel1.Top := 124 + 2;
  A2ILabel3.Left := 13;
  A2ILabel3.Top := 168 + 2;

  A2ILabel9.Left := 157 + 2;
  A2ILabel9.Top := 36 + 2;
  A2ILabel2.Left := 157 + 2;
  A2ILabel2.Top := 80 + 2;
  A2ILabel6.Left := 157 + 2;
  A2ILabel6.Top := 124 + 2;
  A2ILabel4.Left := 157 + 2;
  A2ILabel4.Top := 168 + 2;

  A2ILabelFD8.Left := 217 + 2;
  A2ILabelfd8.Top := 36 + 2;
  A2ILabelfd7.Left := 217 + 2;
  A2ILabelfd7.Top := 80 + 2;
  A2ILabelfd1.Left := 217 + 2;
  A2ILabelfd1.Top := 124 + 2;
  A2ILabelfd3.Left := 217 + 2;
  A2ILabelfd3.Top := 168 + 2;

  A2ILabelfd9.Left := 363 + 2;
  A2ILabelfd9.Top := 36 + 2;
  A2ILabelfd2.Left := 363 + 2;
  A2ILabelfd2.Top := 80 + 2;
  A2ILabelfd6.Left := 363 + 2;
  A2ILabelfd6.Top := 124 + 2;
  A2ILabelfd4.Left := 363 + 2;
  A2ILabelfd4.Top := 168 + 2;

  temping := TA2Image.Create(32, 32, 0, 0);
  try
    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
    A2Button6.A2Up := temping;
    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
    A2Button6.A2Down := temping;
    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
    A2Button6.A2Mouse := temping;
    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
    A2Button6.A2NotEnabled := temping;
    A2Button6.Left := 378;
    A2Button6.Top := 16;
    A2Button6.Width := 17;
    A2Button6.Height := 17;

    pgkBmp.getBmp('角色物品_装备底框.bmp', temping);
    A2ILabel14.A2Imageback := temping;
  finally
    temping.Free;
  end;

  A2LabeluserName.Left := 290;
  A2LabeluserName.Top := 214;
  A2LabeluserName.Width := 95;
  A2LabeluserName.Height := 15;
  A2LabelGuildName.Left := 290;
  A2LabelGuildName.Top := 239;
  A2LabelGuildName.Width := 95;
  A2LabelGuildName.Height := 15;
end;

procedure TfrmWearItemUser.SetNewVersionTest;
var
  i: Integer;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  for i := Low(FItemArr) to High(FItemArr) do
  begin
    SetControlPos(FItemArr[i]);
  end;
  for i := Low(FItemFDArr) to High(FItemFDArr) do
  begin
    SetControlPos(FItemFDArr[i]);
  end;
  SetA2ImgPos(A2ImageWearBack);
  SetControlPos(LbChar);
  SetControlPos(LbCharFD);
  SetControlPos(A2LabeluserName); //角色姓名
  SetControlPos(A2LabelGuildName);
  SetControlPos(A2Button6); //关闭
  SetControlPos(A2Button_Trade);
  SetControlPos(A2Button_Msg);
  SetControlPos(A2Button_Friends);
  SetControlPos(A2Button_Team);
  SetControlPos(A2Button_Egg);
  SetControlPos(A2Button_Flower);
  SetOtherConfig;
end;

procedure TfrmWearItemUser.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure TfrmWearItemUser.SetOtherConfig;
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  SelectImage, SelectNotImage, EnabledImage: string;
  temping, temping2: TA2Image;
  path: string;
  A2Image: string;
  imgwidth, imgheight: Integer;
  transparent: Boolean;
begin

  try
    node := FUIConfig.Root.NodeByName('Views').FindNode('Hint');
    if node <> nil then
    begin
      FHintWidth := node.ReadInteger('HintWidth', 118);
      FHintHeight := node.ReadInteger('HintHeight', 32);
      FHintLeft := node.ReadInteger('HintLeft', 118);
      FHintTop := node.ReadInteger('HintTop', 32);
    end;
  except
  end;
end;

procedure TfrmWearItemUser.A2Button_TradeClick(Sender: TObject);
var
  cDragDrop: TCDragDrop;
begin
  try
    with cDragDrop do begin
      rmsg := CM_DRAGDROP;
      rsourwindow := WINDOW_ITEMS;
      rdestwindow := WINDOW_SCREEN;
      rsourId := 0;
      rdestId := FUSERID;
      rsx := 0;
      rsy := 0;
      rdx := CharList.CharGet(FUSERID).x;
      rdy := CharList.CharGet(FUSERID).y;
      rsourkey := 0;
      rdestkey := 0;
    end;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  except
  end;
end;

procedure TfrmWearItemUser.A2Button_MsgClick(Sender: TObject);
begin
  try
    FrmBottom.edchat.Text := '@纸条 ' + CharList.CharGet(FUSERID).rName + ' ';
    FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
  except
  end;
end;

procedure TfrmWearItemUser.A2Button_TradeMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.settext(-1, '【邀请地方进行交易】');
end;

procedure TfrmWearItemUser.A2Button_TradeMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TfrmWearItemUser.A2Button_MsgMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.settext(-1, '【向对方发送纸条】');
end;

procedure TfrmWearItemUser.A2Button_MsgMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TfrmWearItemUser.A2Button_EggClick(Sender: TObject);
begin
  GameHint.settext(-1, '【功能暂未开放】');
end;

procedure TfrmWearItemUser.A2Button_EggMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.settext(-1, '【功能暂未开放】');
end;

procedure TfrmWearItemUser.A2Button_EggMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TfrmWearItemUser.A2Button_FlowerMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TfrmWearItemUser.A2Button_FlowerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.settext(-1, '【功能暂未开放】');
end;

procedure TfrmWearItemUser.A2Button_FriendsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.settext(-1, '【添加对方为好友】');
end;

procedure TfrmWearItemUser.A2Button_FriendsMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TfrmWearItemUser.A2Button_FlowerClick(Sender: TObject);
begin
  GameHint.settext(-1, '【功能暂未开放】');
end;

procedure TfrmWearItemUser.A2Button_FriendsClick(Sender: TObject);
begin   
  try
    FrmHailFellow.sendHailFellowAdd(CharList.CharGet(FUSERID).rName);
  except
  end;
  //GameHint.settext(-1, '【功能暂未开放】');
end;

procedure TfrmWearItemUser.A2Button_TeamClick(Sender: TObject);
begin
  GameHint.settext(-1, '【功能暂未开放】');
end;

procedure TfrmWearItemUser.A2Button_TeamMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.settext(-1, '【功能暂未开放】');
end;

procedure TfrmWearItemUser.A2Button_TeamMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

end.

