unit FEventInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, StdCtrls, ExtCtrls, AtzCls, DefType, CTable;

type
  TfrmEventInput = class(TForm)
    A2Form: TA2Form;
    A2ILabel1: TA2ILabel;
    EdText1: TA2Edit;
    EdText2: TA2Edit;
    A2ButtonOK: TA2Button;
    A2ILabel2: TA2ILabel;
    A2ILabel3: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2ButtonOKClick(Sender: TObject);
    procedure EdText1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdText2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure SetImage;
  end;

var
  frmEventInput: TfrmEventInput;

implementation

uses FMain, FBottom, FAttrib, FHistory, FLogon, A2Img;

{$R *.dfm}

procedure TfrmEventInput.SetImage;
begin
   A2ButtonOK.SetUpA2Image (EtcAtzClass.GetEtcAtz (47));
   A2ButtonOk.SetDownA2Image (EtcAtzClass.GetEtcAtz (48));
//   A2ButtonCanCel.SetUpA2Image (EtcAtzClass.GetEtcAtz (49));
//   A2ButtonCanCel.SetDownA2Image (EtcAtzClass.GetEtcAtz (50));
end;

procedure TfrmEventInput.FormCreate(Sender: TObject);
begin
   FrmM.AddA2Form (Self, A2Form);
   Top := ((480 - FrmBottom.Height - Height) div 2);
   Left := ((640 - FrmAttrib.Width - Width) div 2);

   SetImage;
end;

procedure TfrmEventInput.FormShow(Sender: TObject);
begin
   EdText1.Text := '';
   EdText2.Text := '';
   EdText1.SetFocus;
end;

procedure TfrmEventInput.A2ButtonOKClick(Sender: TObject);
var
   cEventInput: TCEventInput;
   str: string;
begin
   cEventInput.rMsg := CM_EVENTINPUT;
   cEventInput.rboCheck := True;

   str := ChangeDontSay(EdText1.Text);
   if str <> EdText1.Text then begin
      ChatMan.AddChat(Conv('禁用非礼貌用语'), WinRGB(31,31,0), 0);
      exit;
   end;
   cEventInput.rMsg1 := str;

   str := ChangeDontSay(EdText2.Text);
   if str <> EdText2.Text then begin
      ChatMan.AddChat(Conv('禁用非礼貌用语'), WinRGB(31,12,12), 0);
      exit;
   end;
   cEventInput.rMsg2 := str;

//   if Connector.SendData(@cEventInput, sizeof(TCEventInput)) then begin
   if frmLogon.SocketAddData(sizeof(TCEventInput), @cEventInput) then begin
      Visible := False;
      frmBottom.FocusControl(frmBottom.EdChat);
   end;
end;

procedure TfrmEventInput.EdText1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then begin
      EdText2.SetFocus;
   end;
end;

procedure TfrmEventInput.EdText2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then begin
      EdText1.SetFocus;
   end;
end;

end.
