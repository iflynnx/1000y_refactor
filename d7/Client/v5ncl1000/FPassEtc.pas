unit FPassEtc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, A2Form, Deftype, BaseUIForm;
type
  TFrmPassEtc = class(TfrmBaseUI)
    A2Form: TA2Form;
    EdPass: TA2Edit;
    EdConfirm: TA2Edit;
    LbPass: TA2ILabel;
    LbConfirm: TA2ILabel;
    A2ButtonOK: TA2Button;
    A2ButtonCancel: TA2Button;
    A2Label1: TA2Label;
    A2lblPassTitle: TA2Label;
    btnClose: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure A2ButtonOKClick(Sender: TObject);
    procedure A2ButtonCancelClick(Sender: TObject);
    procedure EdPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdConfirmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  FrmPassEtc: TFrmPassEtc;
const
  Mark_SetPassWord = '_SetPW';
  Mark_UnLockPassWord = '_UnLockPW';
  Mark_ClearPassWord = '_ClearPW';
  Mark_UpdatePassWord = '_UpdatePW';
implementation

uses FMain, AtzCls, Fbl, FBottom, filepgkclass;

{$R *.DFM}

procedure TFrmPassEtc.MessageProcess(var code: TWordComData);
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

//  Mark_SetPassWord = 'SetPW';
//  Mark_UnLockPassWord = 'UnLockPW';
//  Mark_ClearPassWord = 'ClearPW';
//  Mark_UpdatePassWord = 'UpdatePW';
          WINDOW_ShowPassWINDOW_Item:
            begin
              A2lblPassTitle.Caption := '密码设定'; //  密码设定使用
              FControlMark := Mark_SetPassWord;
            end;

          WINDOW_ShowPassWINDOW_ItemUnLock:
            begin
              A2lblPassTitle.Caption := '密码认证';
              FControlMark := Mark_UnLockPassWord;
            end;
          WINDOW_ShowPassWINDOW_Clear:
          begin
            A2lblPassTitle.Caption := '密码清除'; //密码清除需要二次验证
            FControlMark:=Mark_ClearPassWord;
          end;
          WINDOW_ShowPassWINDOW_ItemUPDATE:
          begin
             A2lblPassTitle.Caption := '密码修改'; //修改密码
              FControlMark:=Mark_UpdatePassWord;
          end;
          WINDOW_ShowPassWINDOW_LogItem: ;
          WINDOW_ShowPassWINDOW_LogItemUnLock: ;
          WINDOW_ShowPassWINDOW_LogItemUPDATE: ;

        else exit;
        end;
        SetNewVersion;
        aType := PSSShowSpecialWindow^.rWindow;
        A2Label1.Caption := '';
        Visible := true;
        EdPass.Text := '';
        EdConfirm.Text := '';
        Self.SetFocus;
        EdPass.SetFocus;
        FrmM.move_win_form_Align(Self, mwfCenter);
      end;
  end;

end;

procedure TFrmPassEtc.FormCreate(Sender: TObject);
begin
  inherited;
  Self.FTestPos := True;
  FrmM.AddA2Form(Self, A2form);


  Left := 0;
  Top := 0;
 // FrmM.SetA2Form(Self, A2form);
  SetnewVersion;


end;
//munetc

procedure TFrmPassEtc.A2ButtonOKClick(Sender: TObject);
var
  tt: TCPassEtc;
  cnt: integer;
begin

  case aType of
    WINDOW_ShowPassWINDOW_Item: ;
    WINDOW_ShowPassWINDOW_ItemUnLock: ;
    WINDOW_ShowPassWINDOW_Clear: ;
    WINDOW_ShowPassWINDOW_ItemUPDATE: ;
    WINDOW_ShowPassWINDOW_LogItem: ;
    WINDOW_ShowPassWINDOW_LogItemUnLock: ;
    WINDOW_ShowPassWINDOW_LogItemUPDATE: ;
    WINDOW_ShowPassWINDOW_GameExit:
      begin
        FrmM.Close;
        exit;
      end;
  else exit;
  end; //
  if aType <>  WINDOW_ShowPassWINDOW_Clear then
  if EdPass.Text <> EdConfirm.Text then
  begin
    self.SetNewVersion;
    A2Label1.Caption := '密码不一致';
    A2Label1.BringToFront;
    exit;
  end;
  begin
    tt.rmsg := CM_ShowPassWindows;
    tt.rKEY := aType;
    tt.rPass := EdPass.Text;
    cnt := sizeof(tt);
    Frmfbl.SocketAddData(cnt, @tt);
    Visible := false;
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
  end;

end;

procedure TFrmPassEtc.A2ButtonCancelClick(Sender: TObject);
var
  tt: TCPassEtc;
  cnt: integer;
begin

  case aType of
    WINDOW_ShowPassWINDOW_Item: ;
    WINDOW_ShowPassWINDOW_ItemUnLock: ;
    WINDOW_ShowPassWINDOW_Clear: ;
    WINDOW_ShowPassWINDOW_ItemUPDATE: ;
    WINDOW_ShowPassWINDOW_LogItem: ;
    WINDOW_ShowPassWINDOW_LogItemUnLock: ;
    WINDOW_ShowPassWINDOW_LogItemUPDATE: ;
    WINDOW_ShowPassWINDOW_GameExit:
      begin
        FrmM.Close;
        exit;
      end;
  else exit;
  end; //

  begin
    tt.rmsg := CM_ShowPassWindows;
    tt.rKEY := WINDOW_ShowPassWINDOW_Close;
    tt.rPass := EdPass.Text;
    cnt := sizeof(tt);
    Frmfbl.SocketAddData(cnt, @tt);
    Visible := false;
  end;

end;

procedure TFrmPassEtc.EdPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    EdConfirm.SetFocus;
end;

procedure TFrmPassEtc.EdConfirmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    A2ButtonOKClick(nil);
end;

procedure TFrmPassEtc.SetConfigFileName;
begin
  FConfigFileName := 'PassEtc.xml';

end;

procedure TFrmPassEtc.SetNewVersion;
begin
  inherited;

end;

//procedure TFrmPassEtc.SetNewVersionOld;
//begin
//  pgkBmp.getBmp('mess.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//  A2ButtonOK.A2Up := (EtcAtzClass.GetEtcAtz(39));
//  A2ButtonOK.A2Down := (EtcAtzClass.GetEtcAtz(40));
//
//  A2ButtonCancel.A2Up := (EtcAtzClass.GetEtcAtz(41));
//  A2ButtonCancel.A2Down := (EtcAtzClass.GetEtcAtz(42));
//end;

procedure TFrmPassEtc.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(EdPass);
  SetControlPos(EdConfirm);
  SetControlPos(LbPass);
  SetControlPos(LbConfirm);
  SetControlPos(A2ButtonOK);
  SetControlPos(A2ButtonCancel);
  SetControlPos(A2Label1);
  SetControlPos(A2lblPassTitle);
   SetControlPos(btnClose);


end;

procedure TFrmPassEtc.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TFrmPassEtc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Self.A2ButtonCancelClick(Sender);
end;

end.

