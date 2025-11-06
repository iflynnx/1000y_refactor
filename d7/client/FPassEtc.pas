unit FPassEtc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Deftype, StdCtrls, A2Form, AtzCls, ExtCtrls, AUtil32;

type
  TFrmPassEtc = class(TForm)
    A2Form: TA2Form;
    EdPass: TA2Edit;
    EdConfirm: TA2Edit;
    LbPass: TA2ILabel;
    LbConfirm: TA2ILabel;
    A2ButtonOK: TA2Button;
    A2ButtonCancel: TA2Button;
    A2Label1: TA2Label;
    A2ILabel1: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2ButtonOKClick(Sender: TObject);
    procedure A2ButtonCancelClick(Sender: TObject);
    procedure EdPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdConfirmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
     FPasswordWindowOption : byte;
  public
     procedure MessageProcess (var code: TWordComData);
     procedure SetPostion;
     procedure SetImage;
  end;

var
  FrmPassEtc: TFrmPassEtc;

implementation

uses FAttrib, FBottom, FMain, FLogon;

{$R *.DFM}

procedure TFrmPassEtc.MessageProcess (var code: TWordComData);
var
   PSTSPasswordWindow : PTSPasswordWindow;
begin
   PSTSPasswordWindow := @Code.data;
   FPasswordWindowOption := PSTSPasswordWindow^.rOption;
   case PSTSPasswordWindow^.rOption of
      0: // none
         begin
         end;
      1, // ½ÓÁöºñ¹ø¼³Á¤
      2, // ½ÓÁöºñ¹øÇØÁ¦
      3, // ºñ¹ø¼³Á¤
      4: // ºñ¹øÇØÁ¦
         begin
            frmM.ShowA2Form(Self);
         end;
   end;

end;

procedure TFrmPassEtc.SetPostion;
begin
   if FrmAttrib.Visible then begin
      FrmPassEtc.Top := ((480 - FrmBottom.Height) div 2) - (Height div 2);
      FrmPassEtc.Left := ((640 - FrmAttrib.Width) div 2) - (Width div 2);
   end else begin
      FrmPassEtc.Top := ((480 - FrmBottom.Height) div 2) - (Height div 2);
      FrmPassEtc.Left := (640 div 2) - (Width div 2);
   end;
end;

procedure TFrmPassEtc.SetImage;
begin
   A2ButtonOK.SetUpA2Image (EtcAtzClass.GetEtcAtz (47));
   A2ButtonOk.SetDownA2Image (EtcAtzClass.GetEtcAtz (48));
   A2ButtonCanCel.SetUpA2Image (EtcAtzClass.GetEtcAtz (49));
   A2ButtonCanCel.SetDownA2Image (EtcAtzClass.GetEtcAtz (50));
end;

procedure TFrmPassEtc.FormCreate(Sender: TObject);
begin
   FrmM.AddA2Form (Self, A2Form);
   Top := 0;
   Left := 0;
   FPasswordWindowOption := 0;
   SetImage;
end;

procedure TFrmPassEtc.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFrmPassEtc.FormShow(Sender: TObject);
begin
   A2Label1.Caption := '';
   EdPass.Text := '';
   EdConfirm.Text := '';
   SetPostion;
   EDPass.SetFocus;
end;

procedure TFrmPassEtc.A2ButtonOKClick(Sender: TObject);
var
   cCPassWord : TCPassWord;
begin
   if EdPass.Text <> EdConfirm.Text then begin
      A2Label1.Caption := Conv('ÃÜÂë²»Ò»ÖÂ');
      EdPass.Text := '';
      EdConfirm.Text := '';
      EdPass.SetFocus;
      exit;
   end;
   cCPassWord.rmsg := CM_PASSWORD;
   StrPCopy ( @cCPassWord.rNewPass, EdPass.Text);
   cCPassWord.rOption := FPasswordWindowOption;
   FrmLogon.SocketAddData (Sizeof (cCPassWord), @cCPassWord);
   FrmPassEtc.Visible := FALSE;
   if FrmBottom.Visible then FrmBottom.FocusControl (FrmBottom.EdChat);
end;

procedure TFrmPassEtc.A2ButtonCancelClick(Sender: TObject);
begin
   // ¾Æ¹« ¸Þ½ÃÁö ¾Èº¸³¿
   FrmPassEtc.Visible := FALSE;
   if FrmBottom.Visible then FrmBottom.FocusControl (FrmBottom.EdChat);
end;

procedure TFrmPassEtc.EdPassKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if key = 13 then EdConfirm.SetFocus;
end;

procedure TFrmPassEtc.EdConfirmKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if key = 13 then A2ButtonOK.OnClick (Self);
end;

end.
