unit FCreateChar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,BaseUIForm, StdCtrls, A2Form,deftype;

type
  TfrmCreateChar = class(TfrmBaseUI)
    Pninfo: TA2Label;
    EditChar: TA2Edit;
    CBVillage: TA2ComboBox;
    LbSex: TA2Label;
    BtnCreateChar: TA2Button;
    LbChar: TA2ILabel;
    A2Form: TA2Form;
    procedure BtnCreateCharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
 
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

var
  frmCreateChar: TfrmCreateChar;

implementation

uses FMain, fbl;

{$R *.dfm}

{ TForm1 }

procedure TfrmCreateChar.SetConfigFileName;
begin
   FConfigFileName:='CreateChar.xml';

end;

procedure TfrmCreateChar.SetNewVersionTest;
begin
  inherited;

end;

procedure TfrmCreateChar.settransparent(transparent: Boolean);
begin
  inherited;

end;

procedure TfrmCreateChar.BtnCreateCharClick(Sender: TObject);
var
  ccc: TCCreateChar;
begin
  FrmM.SoundManager.NewPlayEffect('click.wav', 0);
  if Length(EditChar.Text) < 2 then
  begin
    Pninfo.Caption := ('人物名称 输入2个字以上');
    EditChar.SetFocus;
    exit;
  end;
  if Pos(',', EditChar.Text) > 0 then
  begin
    Pninfo.Caption := ('不可使用特殊符号');
    EditChar.SetFocus;
    exit;
  end;
  if Pos(',', CBVillage.text) > 0 then
  begin
    Pninfo.Caption := ('不可使用特殊符号');
    CBVillage.SetFocus;
    exit;
  end;

  ccc.rmsg := CM_CREATECHAR;
  ccc.rchar := EditChar.Text;

  if LbSex.Caption = ('男') then ccc.rsex := 0
  else ccc.rsex := 1;

  ccc.rVillage := CBVillage.Text;
  ccc.rServer := '';

  Frmfbl.SocketAddData(sizeof(ccc), @ccc);
  Self.ModalResult:=mrOk;
end;

procedure TfrmCreateChar.FormCreate(Sender: TObject);
begin
 inherited;
 Self.FTestPos:=True;
end;

end.
