unit FPassEtcEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, A2Form, Deftype,BaseUIForm;

type
  TfrmPassEtcEdit = class(TfrmBaseUI)
    A2ButtonOK: TA2Button;
    A2ButtonCancel: TA2Button;
    A2Label1: TA2Label;
    A2Form: TA2Form;
 
    btnClose: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure A2ButtonCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure A2ButtonOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
        { Public declarations }
    aType: integer;
    procedure MessageProcess(var code: TWordComData);
    procedure SetNewVersion(); override;
    //procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;    
  end;

var
  frmPassEtcEdit: TfrmPassEtcEdit;

implementation

uses FMain, AtzCls, Fbl, FBottom, filepgkclass, FPassEtc;

{$R *.dfm}

{ TfrmPassEtcEdit }

procedure TfrmPassEtcEdit.MessageProcess(var code: TWordComData);
var
  PSSShowSpecialWindow: PTSShowSpecialWindow;
begin
  PSSShowSpecialWindow := @code.data;
  case PSSShowSpecialWindow^.rmsg of
    SM_SHOWSPECIALWINDOW:
      begin
        aType := 0;
        case PSSShowSpecialWindow^.rWindow of
          WINDOW_Close_All:
            begin
              Visible := false;
              exit;
            end;
        
           WINDOW_ShowPassWINDOW_ALLOWEDIT:;
        else exit;
        end;
        aType := PSSShowSpecialWindow^.rWindow;
        A2Label1.Caption := '';
          Self.SetNewVersion;
        Visible := true;
     
       // Self.SetFocus;

       FrmM.move_win_form_Align(Self, mwfCenter);
      end;
  end;

end;

procedure TfrmPassEtcEdit.SetConfigFileName;
begin
  FConfigFileName := 'PassEtcEdit.xml';

end;

procedure TfrmPassEtcEdit.SetNewVersion;
begin
  inherited;

end;

//procedure TfrmPassEtcEdit.SetNewVersionOld;
//begin
//  inherited;
//    pgkBmp.getBmp('mess.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//  A2ButtonOK.A2Up := (EtcAtzClass.GetEtcAtz(39));
//  A2ButtonOK.A2Down := (EtcAtzClass.GetEtcAtz(40));
//
//  A2ButtonCancel.A2Up := (EtcAtzClass.GetEtcAtz(41));
//  A2ButtonCancel.A2Down := (EtcAtzClass.GetEtcAtz(42));
//end;

procedure TfrmPassEtcEdit.SetNewVersionTest;
begin
  inherited;
    SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
 
 
 SetControlPos(A2ButtonOK);
 SetControlPos(A2ButtonCancel);
 SetControlPos(A2Label1);
 
 SetControlPos(btnClose);
end;

procedure TfrmPassEtcEdit.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TfrmPassEtcEdit.FormCreate(Sender: TObject);
begin
  inherited;
  Self.FTestPos:=True;
  FrmM.AddA2Form(Self, A2form);


  Left := 0;
  Top := 0;
 /// FrmM.SetA2Form(Self, A2form);
  SetnewVersion;

end;

procedure TfrmPassEtcEdit.A2ButtonCancelClick(Sender: TObject);
var
  key: Word;
begin
  key := VK_RETURN;
  if FrmPassEtc.Visible then FrmPassEtc.Close;
  if frmPassEtcEdit.Visible then  frmPassEtcEdit.Close;
//  btnCloseClick(Sender); 
  FrmBottom.sendsay('@Çå³ýÃÜÂë', key);
 //
end;

procedure TfrmPassEtcEdit.btnCloseClick(Sender: TObject);
var
  tt: TCPassEtc;
  cnt: integer;
begin
 
  begin
    tt.rmsg := CM_ShowPassWindows;
    tt.rKEY := WINDOW_ShowPassWINDOW_Close;
 
    cnt := sizeof(tt);
    Frmfbl.SocketAddData(cnt, @tt);
    Visible := false;
  end;

end;

procedure TfrmPassEtcEdit.A2ButtonOKClick(Sender: TObject);
var
  key: Word;
begin
  key := VK_RETURN;
  if FrmPassEtc.Visible then FrmPassEtc.Close;
  if frmPassEtcEdit.Visible then  frmPassEtcEdit.Close;
  // btnCloseClick(Sender);
  FrmBottom.sendsay('@ÐÞ¸ÄÃÜÂë', key);

end;

procedure TfrmPassEtcEdit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  btnCloseClick(Sender);
end;

end.
