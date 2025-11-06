unit FGuildInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, A2Form, StdCtrls,
  deftype;

type
  TfrmGuildInfo = class(TForm)
    A2Form1: TA2Form;
    lblGuildName: TA2Label;
    lblGuildSysop: TA2Label;
    lblSubSysop1: TA2Label;
    lblEnergy: TA2Label;
    lblsubsysop: TA2Label;
    lblMemberCount: TA2Label;
    BtnOk: TA2Button;
    BtnCancel: TA2Button;
    Image1: TImage;
    lblsubsysop2: TA2Label;
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MessageProcess(var ACode: TWordComData);
  end;

var
  frmGuildInfo: TfrmGuildInfo;

implementation

uses FMain, FAttrib, FBottom;

{$R *.dfm}

{ TfrmGuildInfo }

procedure TfrmGuildInfo.MessageProcess(var ACode: TWordComData);
var
  pckey: PTCKey;
  pSGuildInfo: PTSGuildInfo;
begin
  pckey := @ACode.data;
  case pckey^.rmsg of
    SM_GUILDINFOWINDOW:
      begin
        pSGuildInfo := @ACode.Data;
        lblGuildName.Caption := pSGuildInfo.rGuildName;
        lblGuildSysop.Caption := pSGuildInfo.rSysopName;
        lblsubsysop.Caption := pSGuildInfo.rSubSysop0;
        lblSubSysop1.Caption := pSGuildInfo.rSubSysop1;
        lblSubSysop2.Caption := psGuildInfo.rSubSysop2;
        lblMemberCount.Caption := IntToStr(pSGuildInfo.rGuildMember);
        lblEnergy.Caption := IntToStr(pSGuildInfo.rGuildEnergy);
        Visible := True;
      end;
  end;
end;

procedure TfrmGuildInfo.BtnOkClick(Sender: TObject);
begin
  Visible := False;
end;

procedure TfrmGuildInfo.BtnCancelClick(Sender: TObject);
begin
  Visible := False;
end;

procedure TfrmGuildInfo.FormCreate(Sender: TObject);
begin
  FrmM.AddA2Form(Self, A2Form1);
  Left := (640 - frmAttrib.Width - Width) div 2;
  Top := (480 - frmBottom.Height - Height) div 2;
  Visible := False;
end;

end.
