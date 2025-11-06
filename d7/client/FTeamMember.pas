unit FTeamMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, A2Form, deftype, ExtCtrls;

type
  TfrmTeamMember = class(TForm)
    A2Form1: TA2Form;
    lblMember0: TA2Label;
    lblMember1: TA2Label;
    lblMember2: TA2Label;
    lblMember3: TA2Label;
    lblMember4: TA2Label;
    lblMember5: TA2Label;
    lblMember6: TA2Label;
    lblMember7: TA2Label;
    BtnCancel: TA2Button;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure lblMemberClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MessageProcess(var ACode: TWordComData);
  end;

var
  frmTeamMember: TfrmTeamMember;

implementation

uses FMain, FAttrib, FBottom;

{$R *.dfm}

procedure TfrmTeamMember.FormCreate(Sender: TObject);
begin
  FrmM.AddA2Form(Self, A2Form1);
  //Left := (640 - frmAttrib.Width - Width) div 2;
  Left := 0;
  Top := 175;
  Visible := False;
end;

procedure TfrmTeamMember.BtnCancelClick(Sender: TObject);
begin
  Visible := False;
end;

procedure TfrmTeamMember.MessageProcess(var ACode: TWordComData);
var
  pckey: PTCKey;
  pSTeamMemberList: PTSTeamMemberList;
  i: Integer;
begin
  pckey := @ACode.data;
  case pckey^.rmsg of
    SM_TEAMMEMBERLIST:
      begin
        pSTeamMemberList := @ACode.Data;
        for i := 0 to MAX_TEAM_MEMBER - 1 do
        begin
          TA2Label(FindComponent(Format('lblMember%d', [i]))).Caption :=
            StrPas(@pSTeamMemberList.rMember[i]);
        end;
        Visible := True;
      end;
  end;
end;

procedure TfrmTeamMember.lblMemberClick(Sender: TObject);
begin
  FrmBottom.EdChat.Text := Format('@Ö½Ìõ %s ', [TA2Label(Sender).Caption]);
  FrmBottom.EdChat.Focused;
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

end.

