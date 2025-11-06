unit FSpecialMagic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, A2Img, StdCtrls, deftype;

type
  TfrmSpecialMagic = class(TForm)
    lblMagicImage: TA2ILabel;
    lblMagicName: TA2Label;
    btnClose: TA2Button;
    A2Form: TA2Form;
    btnPointUp: TA2Button;
    lblNeedPoint: TA2Label;
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnLevelUpClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    nNeedPoint: integer;
    nMagicKey: integer;
    Contents: TStringList;

    bMoveFlag: Boolean;
    nMoveX, nMoveY: integer;
  public
    procedure MessageProcess(var code: TWordComData);
  end;

var
  frmSpecialMagic: TfrmSpecialMagic;

implementation

uses
   FMain, FAttrib, FBottom, FLogon, AtzCls, AUtil32,
   FBestMagic, FItemHelp;

{$R *.dfm}

procedure TfrmSpecialMagic.A2FormAdxPaint(aAnsImage: TA2Image);
var
   i: integer;
   TextWidth, xx, yy: integer;
   str: string;
begin
   // ÇÊ¿äÆ÷ÀÎÆ®
   if nNeedPoint > 0 then begin
      str := IntToStr(nNeedPoint);
      TextWidth := ATextWidth(str);
      xx := lblNeedPoint.Left + (lblNeedPoint.Width - TextWidth) div 2;
      yy := lblNeedPoint.Top + (lblNeedPoint.Height - 12) div 2;
      ATextOut(aAnsImage, xx, yy, 32767, str);
   end;
   
   for i := 0 to Contents.Count-1 do begin
      str := Contents[i];
//      TextWidth := ATextWidth(str);
      xx := 24;
      yy := 62 + i * 15;
      ATextOut(aAnsImage, xx, yy, 32767, str);
   end;
end;

procedure TfrmSpecialMagic.FormCreate(Sender: TObject);
begin
   FrmM.AddA2Form(self, A2Form);
   Left := (640 - frmAttrib.Width - Width) div 2;
   Top := (480 - frmBottom.Height - Height) div 2;
   Visible := False;

   btnClose.Caption := Conv('¹Ø±Õ');

   Contents := TStringList.Create;
end;

procedure TfrmSpecialMagic.FormDestroy(Sender: TObject);
begin
   Contents.Free;
end;

procedure TfrmSpecialMagic.MessageProcess(var code: TWordComData);
var
   psMagicData: PTSBestSpecialMagicWindow;
   str, str2: string;
   i: integer;
   nMagicPoint: integer;
begin
   psMagicData := @Code.Data;

   case psMagicData.rMsg of
      SM_SHOWBESTSPECIALMAGICWINDOW: begin
         lblMagicName.Caption := PChar(@psMagicData.rViewName);
         nMagicKey := psMagicData.rkey;
         lblMagicImage.A2Image := AtzClass.GetMagicImage(psMagicData.rShape);
         nNeedPoint := psMagicData.rNeedStatePoint;

         nMagicPoint := _StrToInt(frmAttrib.MagicPoint.Caption);
         
         if (nNeedPoint <> 0) and (nMagicPoint >= nNeedPoint) then
            btnPointUp.Visible := True
         else
            btnPointUp.Visible := False;

         if nNeedPoint = 0 then
            lblNeedPoint.Visible := False
         else
            lblNeedPoint.Visible := True;

         str := GetWordString(psMagicData.rContents);

         Contents.Clear;
         for i := 0 to 9 do begin
            str2 := GetValidStr4(str, ',');
            Contents.Add(str2);
         end;

         bMoveFlag := False;
         FrmM.ShowA2Form(Self);
         frmBestMagic.Visible := False;
         frmItemHelp.Visible := False;
      end;
   end;
end;

procedure TfrmSpecialMagic.btnCloseClick(Sender: TObject);
begin
   Visible := False;
end;

procedure TfrmSpecialMagic.btnLevelUpClick(Sender: TObject);
var
   cAddStatePoint: TCAddStatePoint;
begin
   cAddStatePoint.rmsg := CM_ADDSTATEPOINT;
   cAddStatePoint.rkey := nMagicKey;
   cAddStatePoint.ridx := 0;
   FrmLogon.SocketAddData (sizeof(TCAddStatePoint), @cAddStatePoint);
//   Connector.SendData(@cAddStatePoint, sizeof(TCAddStatePoint));
end;

procedure TfrmSpecialMagic.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   bMoveFlag := True;

   nMoveX := X;
   nMoveY := Y;
end;

procedure TfrmSpecialMagic.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
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

procedure TfrmSpecialMagic.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   bMoveFlag := False;
end;

end.
