unit ShowHintForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, FMain, StdCtrls, BaseUIForm, ExtCtrls;

type
  TfrmShowHint = class(TfrmBaseUI)
    A2form: TA2Form;
    A2Button1: TA2Button;
    A2Button2: TA2Button;
    A2Button3: TA2Button;
    A2Button4: TA2Button;
    A2Button5: TA2Button;
    A2Button6: TA2Button;
    A2Button7: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Button1Click(Sender: TObject);
    procedure A2Button2Click(Sender: TObject);
    procedure A2Button3Click(Sender: TObject);
    procedure A2Button4Click(Sender: TObject);
    procedure A2Button5Click(Sender: TObject);
    procedure A2Button6Click(Sender: TObject);
    procedure A2Button7Click(Sender: TObject);
  private

  public
    procedure DrawSelf;
    procedure SetNewVersion(); override;



    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure SetImageOveray(AImageOveray: Integer); override;
  end;

var
  frmShowHint: TfrmShowHint;

implementation

{$R *.dfm}
uses
  FBottom;

procedure TfrmShowHint.DrawSelf;
begin

end;

procedure TfrmShowHint.FormCreate(Sender: TObject);
begin
  inherited;
  FTestPos := True;
  FrmM.AddA2Form(Self, A2form);
  DrawSelf;
  SetNewVersion;
//  Fhint:=TA2Hint.Create;
//    Fhint.Ftype := hstTransparent;
 //   A2Hint.Ftype := hstImageOveray;
 //   A2Hint.FImageOveray := 10;


end;

procedure TfrmShowHint.SetConfigFileName;
begin
  FConfigFileName := 'ShowHint.xml';

end;

procedure TfrmShowHint.SetNewVersion;
begin
  inherited;

end;

procedure TfrmShowHint.SetNewVersionTest;
begin
  inherited;
    // A2form.FImageSurface.LoadFromFile('.\ui\img\聊天频道提示.BMP');
  A2form.FImageSurface.Name := 'FImageSurface';
  
   SetControlPos(Self);
  SetA2ImgPos(A2form.FImageSurface);
 // A2form.boImagesurface := true;

  SetControlPos(A2Button1);
  SetControlPos(A2Button2);
  SetControlPos(A2Button3);
  SetControlPos(A2Button4);
  SetControlPos(A2Button5);
  SetControlPos(A2Button6);
  SetControlPos(A2Button7);

end;

procedure TfrmShowHint.settransparent(transparent: Boolean);
begin
  Self.A2form.TransParent := transparent;

end;

procedure TfrmShowHint.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin

  G_enterhint := True;
end;

procedure TfrmShowHint.SetImageOveray(AImageOveray: Integer);
begin
  if AImageOveray <> -1 then
  begin
    self.A2form.FImageOveray := AImageOveray;
    self.A2form.ShowMethod := FSM_ImageOveray;
  end else
  begin
    self.A2form.ShowMethod := FSM_NONE;
  end;


end;

procedure TfrmShowHint.A2Button1Click(Sender: TObject);
begin
  inherited;
  FrmBottom.EdChat.Text:=A2Button1.Hint+FrmBottom.EdChat.Text;
  FrmBottom.hintTimer.Enabled := False;
  Self.Visible := False;
end;

procedure TfrmShowHint.A2Button2Click(Sender: TObject);
begin
  inherited;
  FrmBottom.EdChat.Text:=A2Button2.Hint+FrmBottom.EdChat.Text;
  FrmBottom.hintTimer.Enabled := False;
  Self.Visible := False;
end;

procedure TfrmShowHint.A2Button3Click(Sender: TObject);
begin
  inherited;
  FrmBottom.EdChat.Text:=A2Button3.Hint+FrmBottom.EdChat.Text;
  FrmBottom.hintTimer.Enabled := False;
  Self.Visible := False;
end;

procedure TfrmShowHint.A2Button4Click(Sender: TObject);
begin
  inherited;
  FrmBottom.EdChat.Text:=A2Button4.Hint+FrmBottom.EdChat.Text;
  FrmBottom.hintTimer.Enabled := False;
  Self.Visible := False;
end;

procedure TfrmShowHint.A2Button5Click(Sender: TObject);
begin
  inherited;
  FrmBottom.EdChat.Text:=A2Button5.Hint+FrmBottom.EdChat.Text;
  FrmBottom.hintTimer.Enabled := False;
  Self.Visible := False;
end;

procedure TfrmShowHint.A2Button6Click(Sender: TObject);
begin
  inherited;
  FrmBottom.EdChat.Text:=A2Button6.Hint+FrmBottom.EdChat.Text;
  FrmBottom.hintTimer.Enabled := False;
  Self.Visible := False;
end;

procedure TfrmShowHint.A2Button7Click(Sender: TObject);
begin
  inherited;
  FrmBottom.EdChat.Text:=A2Button7.Hint+FrmBottom.EdChat.Text;
  FrmBottom.hintTimer.Enabled := False;
  Self.Visible := False;
end;

end.

