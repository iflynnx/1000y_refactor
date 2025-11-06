unit FBestMagic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, A2Img, StdCtrls, ExtCtrls, deftype, AUtil32;

type
  TfrmBestMagic = class(TForm)
    A2Form: TA2Form;
    lblMagicImage: TA2ILabel;
    lblMagicName: TA2Label;
    btnClose: TA2Button;
    lblPointLevel0: TA2Label;
    lblBodyDam: TA2Label;
    lblPointLevel1: TA2Label;
    lblHeadDam: TA2Label;
    lblPointLevel2: TA2Label;
    lblArmDam: TA2Label;
    lblPointLevel3: TA2Label;
    lblLegDam: TA2Label;
    lblContent0: TA2Label;
    lblContent1: TA2Label;
    lblContent2: TA2Label;
    lblContent3: TA2Label;
    lblPointLevel4: TA2Label;
    lblEnergyDam: TA2Label;
    lblMagicGrade: TA2Label;
    btnPointUp0: TA2Button;
    btnPointUp1: TA2Button;
    btnPointUp2: TA2Button;
    btnPointUp3: TA2Button;
    btnPointUp4: TA2Button;
    lblPoint0: TA2Label;
    lblPoint1: TA2Label;
    lblPoint2: TA2Label;
    lblPoint3: TA2Label;
    lblPoint4: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPointClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    btnPointUp: array[0..4] of TA2Button;
    lblPoint: array[0..4] of TA2Label;
    lblPointLevel: array[0..4] of TA2Label;

    PointValue: array[0..4] of integer;
    lblContents: array[0..3] of TA2Label;

    MagicKey: Byte;

    bMoveFlag: Boolean;
    nMoveX, nMoveY: integer;
  public

    procedure MessageProcess(var code: TWordComData);
  end;

var
  frmBestMagic: TfrmBestMagic;

implementation

uses
   FMain, FAttrib, FBottom, FLogOn, AtzCls, FSpecialMagic,
   FItemHelp;

{$R *.dfm}

procedure TfrmBestMagic.FormCreate(Sender: TObject);
var
   i: integer; 
begin
   FrmM.AddA2Form(self, A2Form);
   Left := (640 - frmAttrib.Width - Width) div 2;
   Top := (480 - frmBottom.Height - Height) div 2;
   Visible := False;

   btnClose.Caption := Conv('¹Ø±Õ');

   for i := 0 to 4 do begin
      btnPointUp[i] := TA2Button(FindComponent(Format('btnPointUp%d', [i])));
      lblPoint[i] := TA2Label(FindComponent(Format('lblPoint%d', [i])));
      lblPointLevel[i] := TA2Label(FindComponent(Format('lblPointLevel%d', [i])));
      PointValue[i] := 0;
   end;
   for i := 0 to 3 do begin
      lblContents[i] := TA2Label(FindComponent(Format('lblContent%d', [i])));
   end;
end;

procedure TfrmBestMagic.A2FormAdxPaint(aAnsImage: TA2Image);
var
   i: integer;
   TextWidth, xx, yy: integer;
   str: string;
begin
   for i := 0 to 4 do begin
      str := IntToStr(PointValue[i]);
      TextWidth := ATextWidth(str);
      xx := lblPoint[i].Left + (lblPoint[i].Width - TextWidth) div 2;
      yy := lblPoint[i].Top + (lblPoint[i].Height - 12) div 2;
      ATextOut(aAnsImage, xx, yy, 32767, str);

      str := IntToStr(PointValue[i] div 10 + 1);
      TextWidth := ATextWidth(str);
      xx := lblPointLevel[i].Left + (lblPointLevel[i].Width - TextWidth) div 2;
      yy := lblPointLevel[i].Top + (lblPointLevel[i].Height - 12) div 2;
      ATextOut(aAnsImage, xx, yy, 32767, str);
   end;
end;

procedure TfrmBestMagic.MessageProcess(var code: TWordComData);
var
   psMagicData: PTSBestAttackMagicWindow;
   str, str2: string;
   i: integer;
   nMagicPoint: integer;
begin
   psMagicData := @Code.Data;

   case psMagicData.rMsg of
      SM_SHOWBESTATTACKMAGICWINDOW: begin
         lblBodyDam.Caption   := Conv('ÉíÌå¹¥»÷');
         lblHeadDam.Caption   := Conv('Í·¹¥»÷');
         lblArmDam.Caption    := Conv('ÊÖ¹¥»÷');
         lblLegDam.Caption    := Conv('ÍÈ¹¥»÷');
         lblEnergyDam.Caption := Conv('ÔªÆø¹¥»÷');
      end;
      SM_SHOWBESTPROTECTMAGICWINDOW: begin
         lblBodyDam.Caption   := Conv('ÉíÌå·ÀÓù');
         lblHeadDam.Caption   := Conv('Í··ÀÓù');
         lblArmDam.Caption    := Conv('ÊÖ·ÀÓù');
         lblLegDam.Caption    := Conv('ÍÈ·ÀÓù');
         lblEnergyDam.Caption := Conv('ÔªÆø·ÀÓùÁ¦');
      end;
      else begin
         exit;
      end;
   end;

   lblMagicName.Caption := PChar(@psMagicData.rViewName);
   lblMagicImage.A2Image := AtzClass.GetMagicImage(psMagicData.rShape);
   MagicKey := psMagicData.rkey;
   lblMagicGrade.Caption := Conv('ÐÞÁ¶µÈ¼¶') + Get10000To100(psMagicData.rGrade);

   nMagicPoint := _StrToInt(frmAttrib.MagicPoint.Caption);

   PointValue[0] := psMagicData.rDamageBody;
   PointValue[1] := psMagicData.rDamageHead;
   PointValue[2] := psMagicData.rDamageArm;
   PointValue[3] := psMagicData.rDamageLeg;
   PointValue[4] := psMagicData.rDamageEnergy;

   for i := 0 to 4 do begin
      btnPointUp[i].Visible := (nMagicPoint > (PointValue[i] div 10));
   end;

   str := GetWordString(psMagicData.rContents);

   for i := 0 to 3 do begin
      str2 := GetValidStr4(str, ',');
      lblContents[i].Caption := str2;
   end;

   FrmM.ShowA2Form(Self);

   Visible := True;
   frmItemHelp.Visible := False;
end;

procedure TfrmBestMagic.btnCloseClick(Sender: TObject);
begin
   Visible := False;
end;

procedure TfrmBestMagic.btnPointClick(Sender: TObject);
var
   cAddStatePoint: TCAddStatePoint;
begin
   cAddStatePoint.rmsg := CM_ADDSTATEPOINT;
   cAddStatePoint.rkey := MagicKey;
   cAddStatePoint.ridx := TComponent(Sender).Tag;
   FrmLogon.SocketAddData (sizeof(TCAddStatePoint), @cAddStatePoint);
//   Connector.SendData(@cAddStatePoint, sizeof(TCAddStatePoint));
end;

procedure TfrmBestMagic.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   bMoveFlag := True;

   nMoveX := X;
   nMoveY := Y;
end;

procedure TfrmBestMagic.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
   tx, ty: integer;
begin
   if bMoveFlag then begin
      tx := Left + X - nMoveX;
      ty := Top + Y - nMoveY;

      if tx < 0 then tx := 0;
      if tx > 640 - Width then tx := 640 - Width;
      if ty < 0 then ty := 0;
      if ty > 480 - frmBottom.Height - Height then ty := 480 - frmBottom.Height - Height;

      Left := tx;
      Top := ty;
   end;
end;

procedure TfrmBestMagic.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   bMoveFlag := False;
end;

end.
