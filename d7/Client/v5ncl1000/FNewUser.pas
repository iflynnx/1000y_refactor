unit FNewUser;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
    StdCtrls, ComCtrls, autil32, deftype, ExtCtrls, A2Form, Atzcls,
    uResidentRegistrationNumber, A2Img, Mask,
 uGramerId;

type

    TNewUserWindowsState = (nuws_registe, nuws_UpDatePass, nuws_FindPass);      //(注册，修改，找回密码)
    TFrmNewUser = class(TForm)
        Timer1: TTimer;
        Pninfo: TA2ILabel;
        A2Form: TA2Form;
        Panel_reg: TPanel;
        ButtonRegOK: TA2Button;
        ButtonPassUpdate: TA2Button;
        ButtonRegClose: TA2Button;
        ButtonFindPass: TA2Button;
        EditID: TA2Edit;
        EditPassWord: TA2Edit;
        EditConfirm: TA2Edit;
        EditName: TA2Edit;
        EditNativeNumber: TA2Edit;
        editEMAIL: TA2Edit;
        EditMasterKey: TA2Edit;
        Panel_UpDate: TPanel;
        Panel_FindPass: TPanel;
        edit_UpPassId: TA2Edit;
        ButtonUpDateOK: TA2Button;
        ButtonUpDateClose: TA2Button;
        ButtonRegister: TA2Button;
        ButtonFindPassword: TA2Button;
        edit_UpPassOldPass: TA2Edit;
        edit_UpPassNewPassword: TA2Edit;
        edit_UpPassAgain: TA2Edit;
        edit_UpPassMasterKey: TA2Edit;
        edit_UpPassEmail: TA2Edit;
        ButtonFindClose: TA2Button;
        ButtonFindRegister: TA2Button;
        ButtonFindUpDate: TA2Button;
        ButtonFindOK: TA2Button;
        EditFindID: TA2Edit;
        EditFindEMAI: TA2Edit;
        EditFindMasterKey: TA2Edit;
        EditFindResult: TA2Edit;
        procedure FormCreate(Sender: TObject);
        //   procedure A2ILabel14downClick(Sender:TObject);
        procedure ButtonRegCloseClick(Sender: TObject);
        procedure ButtonRegOKClick(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure ButtonPassUpdateClick(Sender: TObject);
        procedure ButtonFindPassClick(Sender: TObject);
        procedure ButtonRegisterClick(Sender: TObject);
        procedure ButtonFindPasswordClick(Sender: TObject);
        procedure ButtonUpDateOKClick(Sender: TObject);
        procedure ButtonFindRegisterClick(Sender: TObject);
        procedure ButtonFindUpDateClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure ButtonFindOKClick(Sender: TObject);

    public
        Fnewstate: integer;
        fnewconnstate: boolean;
        cConnTime: integer;
        regconnip: string;
        regconnprot: integer;
        NewUserWindowsState: TNewUserWindowsState;

        function MessageProcess(var Code: TWordComData): Boolean;               //处理 消息
        procedure SetRegisteState(astate: TNewUserWindowsState);
        procedure onconnect();
        procedure onDisconnect();
        procedure ClearAllEdit();

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;
    //procedure SetRegisteState(Sender: TObject);

var
    FrmNewUser: TFrmNewUser;

implementation

uses Fbl, FMain, filepgkclass, uAnsTick;

{$R *.DFM}

function TFrmNewUser.MessageProcess(var Code: TWordComData): Boolean;           //处理 消息
var
    i: integer;
    str, rdstr: string;
    pckey: PTCKey;
    psWs: PTWordInfoString;
    psMessage: PTSMessage;
    psWindow: PTSWindow;

    psReConnect: PTSReConnect;
    psSConnectThru: PTSConnectThru;
begin
    Result := true;

    pckey := @Code.data;
    case pckey^.rmsg of

        SM_CONNECTTHRU:
            begin

                psSConnectThru := @Code.Data;
                if psSConnectThru.rIpAddr = '0.0.0.0' then
                    regconnip := ReConnectIpAddr
                else
                    regconnip := (psSConnectThru.rIpAddr);
                regconnprot := psSConnectThru.rPort;
                ReConnectyid := psSConnectThru.ryid;
                Fnewstate := 10;
            end;

        SM_MESSAGE:
            begin
                psMessage := @Code.Data;
                case psMessage^.rkey of

                    MESSAGE_CREATELOGIN:
                        begin

                            Pninfo.Caption := GetWordString(psMessage^.rWordString);
                        end;
                    MESSAGE_FindPasswordResult:
                        begin
                            EditFindResult.Text := GetWordString(psMessage^.rWordString);
                        end;

                end;
            end;
    end;
end;

procedure TFrmNewUser.SetRegisteState(astate: TNewUserWindowsState);
begin
    Panel_reg.Visible := false;
    Panel_FindPass.Visible := false;
    Panel_UpDate.Visible := false;
    NewUserWindowsState := astate;

    FrmM.SoundManager.NewPlayEffect('click.wav', 0);
    case NewUserWindowsState of
        nuws_registe:
            begin
                if WinVerType = wvtnew then
                    pgkBmp.getBmp('账号注册-背景.bmp', A2form.FImageSurface)
                else
                    pgkBmp.getBmp('账户管理_账号注册系统.bmp', A2form.FImageSurface);
                A2form.boImagesurface := true;
                Panel_reg.Visible := true;

            end;
        nuws_UpDatePass:
            begin
                if WinVerType = wvtnew then
                    pgkBmp.getBmp('密码修改-背景.bmp', A2form.FImageSurface)
                else
                    pgkBmp.getBmp('账户管理_密码修改系统.bmp', A2form.FImageSurface);
                A2form.boImagesurface := true;
                Panel_UpDate.Visible := true;

            end;
        nuws_FindPass:
            begin
                if WinVerType = wvtnew then
                    pgkBmp.getBmp('密码查询-背景.bmp', A2form.FImageSurface)
                else
                    pgkBmp.getBmp('账户管理_密码查询系统.bmp', A2form.FImageSurface);
                A2form.boImagesurface := true;
                Panel_FindPass.Visible := true;

            end;
    end;
end;

//注册页面窗口创建

procedure TFrmNewUser.SetNewVersion;
var
    outimg: TA2Image;
begin
    Left := 0;
    Top := 0;
    FrmM.AddA2Form(Self, A2Form);

    Panel_UpDate.Top := 0;
    Panel_UpDate.Left := 0;
    Panel_FindPass.Top := 0;
    Panel_FindPass.Left := 0;
    Panel_reg.Top := 0;
    Panel_reg.Left := 0;

    fnewconnstate := false;
    regconnip := '';
    regconnprot := 0;
    Fnewstate := 1;

    SetRegisteState(nuws_registe);
    outimg := TA2Image.Create(32, 32, 0, 0);
    try
        //注册页面按钮
        pgkBmp.getBmp('账号注册-确认注册-按下.bmp', outimg);
        ButtonRegOK.A2Down := outimg;
        pgkBmp.getBmp('账号注册-确认注册-弹起.bmp', outimg);
        ButtonRegOK.A2Up := outimg;
        pgkBmp.getBmp('账号注册-确认注册-灰暗.bmp', outimg);
        ButtonRegOK.A2NotEnabled := outimg;
        pgkBmp.getBmp('账号注册-确认注册-鼠标.bmp', outimg);
        ButtonRegOK.A2Mouse := outimg;
        ButtonRegOK.Top := 472;
        ButtonRegOK.Left := 272;
        ButtonRegOK.Width := 65;
        ButtonRegOK.Height := 23;

        pgkBmp.getBmp('关闭-1.bmp', outimg);
        ButtonRegClose.A2Down := outimg;
        pgkBmp.getBmp('关闭-2.bmp', outimg);
        ButtonRegClose.A2Up := outimg;
        pgkBmp.getBmp('关闭-3.bmp', outimg);
        ButtonRegClose.A2Mouse := outimg;
        ButtonRegClose.Top := 472;
        ButtonRegClose.Left := 446;
        ButtonRegClose.Width := 65;
        ButtonRegClose.Height := 23;

        pgkBmp.getBmp('账号注册-密码修改-按下.bmp', outimg);
        ButtonPassUpdate.A2Down := outimg;
        pgkBmp.getBmp('账号注册-密码修改-弹起.bmp', outimg);
        ButtonPassUpdate.A2Up := outimg;
        pgkBmp.getBmp('账号注册-密码修改-鼠标.bmp', outimg);
        ButtonPassUpdate.A2Mouse := outimg;
        ButtonPassUpdate.Top := 42;
        ButtonPassUpdate.Left := 558;
        ButtonPassUpdate.Width := 65;
        ButtonPassUpdate.Height := 23;

        pgkBmp.getBmp('账号注册-密码查询-按下.bmp', outimg);
        ButtonFindPass.A2Down := outimg;
        pgkBmp.getBmp('账号注册-密码查询-弹起.bmp', outimg);
        ButtonFindPass.A2Up := outimg;
        pgkBmp.getBmp('账号注册-密码查询-鼠标.bmp', outimg);
        ButtonFindPass.A2Mouse := outimg;
        ButtonFindPass.Top := 42;
        ButtonFindPass.Left := 652;
        ButtonFindPass.Width := 65;
        ButtonFindPass.Height := 23;

        EditID.Left := 222;
        EditID.Top := 83;
        EditID.Width := 147;
        EditID.Height := 22;

        EditPassWord.Left := 222;
        EditPassWord.Top := 119;
        EditPassWord.Width := 147;
        EditPassWord.Height := 22;

        EditConfirm.Left := 222;
        EditConfirm.Top := 156;
        EditConfirm.Width := 147;
        EditConfirm.Height := 22;

        EditName.Left := 222;
        EditName.Top := 226;
        EditName.Width := 147;
        EditName.Height := 22;

        EditNativeNumber.Left := 222;
        EditNativeNumber.Top := 275;
        EditNativeNumber.Width := 147;
        EditNativeNumber.Height := 22;

        editEMAIL.Left := 222;
        editEMAIL.Top := 335;
        editEMAIL.Width := 147;
        editEMAIL.Height := 22;

        EditMasterKey.Left := 222;
        EditMasterKey.Top := 384;
        EditMasterKey.Width := 147;
        EditMasterKey.Height := 22;

        //密码修改界面按钮
        pgkBmp.getBmp('密码修改-确认修改-按下.bmp', outimg);
        ButtonUpDateOK.A2Down := outimg;
        pgkBmp.getBmp('密码修改-确认修改-弹起.bmp', outimg);
        ButtonUpDateOK.A2Up := outimg;
        pgkBmp.getBmp('密码修改-确认修改-灰暗.bmp', outimg);
        ButtonUpDateOK.A2NotEnabled := outimg;
        pgkBmp.getBmp('密码修改-确认修改-鼠标.bmp', outimg);
        ButtonUpDateOK.A2Mouse := outimg;
        ButtonUpDateOK.Top := 472;
        ButtonUpDateOK.Left := 272;
        ButtonUpDateOK.Width := 65;
        ButtonUpDateOK.Height := 23;

        pgkBmp.getBmp('关闭-1.bmp', outimg);
        ButtonUpDateClose.A2Down := outimg;
        pgkBmp.getBmp('关闭-2.bmp', outimg);
        ButtonUpDateClose.A2Up := outimg;
        pgkBmp.getBmp('关闭-3.bmp', outimg);
        ButtonUpDateClose.A2Mouse := outimg;
        ButtonUpDateClose.top := 472;
        ButtonUpDateClose.left := 446;
        ButtonUpDateClose.Width := 65;
        ButtonUpDateClose.Height := 23;

        pgkBmp.getBmp('密码查询-账号注册-按下.bmp', outimg);
        ButtonRegister.A2Down := outimg;
        pgkBmp.getBmp('密码查询-账号注册-弹起.bmp', outimg);
        ButtonRegister.A2Up := outimg;
        pgkBmp.getBmp('密码查询-账号注册-鼠标.bmp', outimg);
        ButtonRegister.A2Mouse := outimg;
        ButtonRegister.top := 42;
        ButtonRegister.left := 558;
        ButtonRegister.Width := 65;
        ButtonRegister.Height := 23;

        pgkBmp.getBmp('密码修改-密码查询-按下.bmp', outimg);
        ButtonFindPassword.A2Down := outimg;
        pgkBmp.getBmp('密码修改-密码查询-弹起.bmp', outimg);
        ButtonFindPassword.A2Up := outimg;
        pgkBmp.getBmp('密码修改-密码查询-鼠标.bmp', outimg);
        ButtonFindPassword.A2Mouse := outimg;
        ButtonFindPassword.top := 42;
        ButtonFindPassword.left := 652;
        ButtonFindPassword.Width := 65;
        ButtonFindPassword.Height := 23;

        edit_UpPassId.Left := 203;
        edit_UpPassId.Top := 100;
        edit_UpPassId.Width := 147;
        edit_UpPassId.Height := 22;

        edit_UpPassOldPass.Left := 203;
        edit_UpPassOldPass.Top := 133;
        edit_UpPassOldPass.Width := 147;
        edit_UpPassOldPass.Height := 22;

        edit_UpPassNewPassword.Left := 203;
        edit_UpPassNewPassword.Top := 170;
        edit_UpPassNewPassword.Width := 147;
        edit_UpPassNewPassword.Height := 22;

        edit_UpPassAgain.Left := 203;
        edit_UpPassAgain.Top := 206;
        edit_UpPassAgain.Width := 147;
        edit_UpPassAgain.Height := 22;

        edit_UpPassEmail.Left := 203;
        edit_UpPassEmail.Top := 241;
        edit_UpPassEmail.Width := 147;
        edit_UpPassEmail.Height := 22;

        edit_UpPassMasterKey.Left := 203;
        edit_UpPassMasterKey.Top := 277;
        edit_UpPassMasterKey.Width := 147;
        edit_UpPassMasterKey.Height := 22;

        //密码查询
        pgkBmp.getBmp('密码查询-确认查询-按下.bmp', outimg);
        ButtonFindOK.A2Down := outimg;
        pgkBmp.getBmp('密码查询-确认查询-弹起.bmp', outimg);
        ButtonFindOK.A2Up := outimg;
        pgkBmp.getBmp('密码查询-确认查询-灰暗.bmp', outimg);
        ButtonFindOK.A2NotEnabled := outimg;
        pgkBmp.getBmp('密码查询-确认查询-鼠标.bmp', outimg);
        ButtonFindOK.A2Mouse := outimg;
        ButtonFindOK.top := 472;
        ButtonFindOK.left := 272;
        ButtonFindOK.Width := 65;
        ButtonFindOK.Height := 23;

        pgkBmp.getBmp('关闭-1.bmp', outimg);
        ButtonFindClose.A2Down := outimg;
        pgkBmp.getBmp('关闭-2.bmp', outimg);
        ButtonFindClose.A2Up := outimg;
        pgkBmp.getBmp('关闭-3.bmp', outimg);
        ButtonFindClose.A2Mouse := outimg;
        ButtonFindClose.top := 472;
        ButtonFindClose.left := 446;
        ButtonFindClose.Width := 65;
        ButtonFindClose.Height := 23;

        pgkBmp.getBmp('密码查询-账号注册-按下.bmp', outimg);
        ButtonFindRegister.A2Down := outimg;
        pgkBmp.getBmp('密码查询-账号注册-弹起.bmp', outimg);
        ButtonFindRegister.A2Up := outimg;
        pgkBmp.getBmp('密码查询-账号注册-鼠标.bmp', outimg);
        ButtonFindRegister.A2Mouse := outimg;
        ButtonFindRegister.top := 45;
        ButtonFindRegister.left := 548;
        ButtonFindRegister.Width := 65;
        ButtonFindRegister.Height := 23;

        pgkBmp.getBmp('账号注册-密码修改-按下.bmp', outimg);
        ButtonFindUpDate.A2Down := outimg;
        pgkBmp.getBmp('账号注册-密码修改-弹起.bmp', outimg);
        ButtonFindUpDate.A2Up := outimg;
        pgkBmp.getBmp('账号注册-密码修改-鼠标.bmp', outimg);
        ButtonFindUpDate.A2Mouse := outimg;
        ButtonFindUpDate.top := 45;
        ButtonFindUpDate.left := 642;
        ButtonFindUpDate.Width := 65;
        ButtonFindUpDate.Height := 23;

        EditFindID.Left := 231;
        EditFindID.Top := 88;
        EditFindID.Width := 147;
        EditFindID.Height := 22;

        EditFindEMAI.Left := 231;
        EditFindEMAI.Top := 139;
        EditFindEMAI.Width := 147;
        EditFindEMAI.Height := 22;

        EditFindMasterKey.Left := 231;
        EditFindMasterKey.Top := 186;
        EditFindMasterKey.Width := 147;
        EditFindMasterKey.Height := 22;

        EditFindResult.Left := 231;
        EditFindResult.Top := 234;
        EditFindResult.Width := 147;
        EditFindResult.Height := 22;
    finally
        outimg.Free;
    end;

    Pninfo.Left := Pninfo.Left + 20;
end;

procedure TFrmNewUser.SetOldVersion;
var
    outimg: TA2Image;
begin
    Left := 0;
    Top := 0;
    FrmM.AddA2Form(Self, A2Form);

    Panel_UpDate.Top := 0;
    Panel_UpDate.Left := 0;
    Panel_FindPass.Top := 0;
    Panel_FindPass.Left := 0;
    Panel_reg.Top := 0;
    Panel_reg.Left := 0;

    fnewconnstate := false;
    regconnip := '';
    regconnprot := 0;
    Fnewstate := 1;

    SetRegisteState(nuws_registe);
    outimg := TA2Image.Create(32, 32, 0, 0);
    try
        //注册页面按钮
        pgkBmp.getBmp('账户管理_确认注册DOWN.bmp', outimg);
        ButtonRegOK.A2Down := outimg;
        pgkBmp.getBmp('账户管理_确认注册UP.bmp', outimg);
        ButtonRegOK.A2Up := outimg;
        pgkBmp.getBmp('账户管理_确认注册Enabled.bmp', outimg);
        ButtonRegOK.A2NotEnabled := outimg;

        pgkBmp.getBmp('账户管理_账户管理关闭DOWN.bmp', outimg);
        ButtonRegClose.A2Down := outimg;
        pgkBmp.getBmp('账户管理_账户系统关闭UP.bmp', outimg);
        ButtonRegClose.A2Up := outimg;

        pgkBmp.getBmp('账户管理_密码修改DOWN.bmp', outimg);
        ButtonPassUpdate.A2Down := outimg;
        pgkBmp.getBmp('账户管理_密码修改UP.bmp', outimg);
        ButtonPassUpdate.A2Up := outimg;

        pgkBmp.getBmp('账户管理_密码查询DOWN.bmp', outimg);
        ButtonFindPass.A2Down := outimg;
        pgkBmp.getBmp('账户管理_密码查询UP.bmp', outimg);
        ButtonFindPass.A2Up := outimg;

        //密码修改界面按钮
        pgkBmp.getBmp('账户管理_确认修改DOWN.bmp', outimg);
        ButtonUpDateOK.A2Down := outimg;
        pgkBmp.getBmp('账户管理_确认修改UP.bmp', outimg);
        ButtonUpDateOK.A2Up := outimg;
        pgkBmp.getBmp('账户管理_确认修改Enabled.bmp', outimg);
        ButtonUpDateOK.A2NotEnabled := outimg;

        pgkBmp.getBmp('账户管理_账户管理关闭DOWN.bmp', outimg);
        ButtonUpDateClose.A2Down := outimg;
        pgkBmp.getBmp('账户管理_账户系统关闭UP.bmp', outimg);
        ButtonUpDateClose.A2Up := outimg;

        pgkBmp.getBmp('账户管理_账号注册DOWN.bmp', outimg);
        ButtonRegister.A2Down := outimg;
        pgkBmp.getBmp('账户管理_账号注册UP.bmp', outimg);
        ButtonRegister.A2Up := outimg;

        pgkBmp.getBmp('账户管理_密码查询DOWN.bmp', outimg);
        ButtonFindPassword.A2Down := outimg;
        pgkBmp.getBmp('账户管理_密码查询UP.bmp', outimg);
        ButtonFindPassword.A2Up := outimg;

        //密码查询
        pgkBmp.getBmp('账户管理_确认查询DOWN.bmp', outimg);
        ButtonFindOK.A2Down := outimg;
        pgkBmp.getBmp('账户管理_确认查询UP.bmp', outimg);
        ButtonFindOK.A2Up := outimg;
        pgkBmp.getBmp('账户管理_确认查询Enabled.bmp', outimg);
        ButtonFindOK.A2NotEnabled := outimg;

        pgkBmp.getBmp('账户管理_账户管理关闭DOWN.bmp', outimg);
        ButtonFindClose.A2Down := outimg;
        pgkBmp.getBmp('账户管理_账户系统关闭UP.bmp', outimg);
        ButtonFindClose.A2Up := outimg;

        pgkBmp.getBmp('账户管理_账号注册DOWN.bmp', outimg);
        ButtonFindRegister.A2Down := outimg;
        pgkBmp.getBmp('账户管理_账号注册UP.bmp', outimg);
        ButtonFindRegister.A2Up := outimg;

        pgkBmp.getBmp('账户管理_密码修改DOWN.bmp', outimg);
        ButtonFindUpDate.A2Down := outimg;
        pgkBmp.getBmp('账户管理_密码修改UP.bmp', outimg);
        ButtonFindUpDate.A2Up := outimg;
    finally
        outimg.Free;
    end;
end;

procedure TFrmNewUser.FormCreate(Sender: TObject);
begin
    if WinVerType = wvtnew then
    begin
        SetNewVersion;
    end
    else
    begin
        SetOldVersion;
    end;
end;

//注册页面关闭按钮

procedure TFrmNewUser.ButtonRegCloseClick(Sender: TObject);
begin
    FrmM.SoundManager.NewPlayEffect('click.wav', 0);
    Visible := FALSE;
    ClearAllEdit;
    frmfbl.Visible:=True;
end;

//注册界面 确认注册按钮

procedure TFrmNewUser.ButtonRegOKClick(Sender: TObject);
var
    cCCreateIdPass3: TCCreateIdPass3;
begin
    FrmM.SoundManager.NewPlayEffect('click.wav', 0);
    EditId.Text := trim(EditId.Text);
    EditPassWord.Text := trim(EditPassWord.Text);
    EditConfirm.Text := trim(EditConfirm.Text);
    EditName.Text := trim(EditName.Text);
    EditNativeNumber.Text := trim(EditNativeNumber.Text);
    editEMAIL.Text := trim(editEMAIL.Text);
    EditMasterKey.Text := trim(EditMasterKey.Text);

    if (Length(EditId.Text) < 6) or (not isGrammarID(EditId.Text)) then
    begin
        Pninfo.Caption := ('【账户名称】只能使用英文字母与阿拉伯数字；并且至少6位。');
        EditId.SetFocus;
        exit;
    end;

    if (Length(EditPassWord.Text) < 6) or (not isGrammarID(EditPassWord.Text)) then
    begin
        Pninfo.Caption := ('【账户密码】只能使用英文字母与阿拉伯数字；并且至少6位。');
        EditPassWord.SetFocus;
        exit;
    end;
    if EditConfirm.Text <> EditPassWord.Text then
    begin
        Pninfo.Caption := ('【账户密码】与【重复账户密码】不一致。');
        EditConfirm.SetFocus;
        exit;
    end;

    if (Length(EditName.Text) < 4) or (not isFullHangul(EditName.Text)) then
    begin
        Pninfo.Caption := ('【用户名字】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
        EditName.SetFocus;
        exit;
    end;
    if ((Length(EditNativeNumber.Text) <> 15) and (Length(EditNativeNumber.Text) <> 18)) or (not isGrammarID(EditNativeNumber.Text)) then
    begin
        Pninfo.Caption := ('【身份证号】只能使用英文字母、阿拉伯数字；并且15位或者18位。');
        EditNativeNumber.SetFocus;
        exit;
    end;

    if (Length(editEMAIL.Text) < 4) or (not isEmailID(editEMAIL.Text)) then
    begin
        Pninfo.Caption := ('【电子邮件】只能使用英文字母、阿拉伯数字；并且至少4位。');
        editEMAIL.SetFocus;
        exit;
    end;
    if (Length(EditMasterKey.Text) < 4) or (not isFullHangul(EditMasterKey.Text)) then
    begin
        Pninfo.Caption := ('【安全问答】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
        EditMasterKey.SetFocus;
        exit;
    end;

    fillchar(cCCreateIdPass3, sizeof(cCCreateIdPass3), 0);
    with cCCreateIdPass3 do
    begin
        rMsg := CM_CREATEIDPASS3;
        rID := EditId.Text;
        rPass := EditPassWord.Text;
        rName := EDITNAME.Text;
        rNativeNumber := EditNativeNumber.Text;
        rMasterKey := EditMasterKey.Text;
        rEmail := EditEMail.Text;
        rPhone := '123456789';
        rParentName := EDITNAME.Text;
        rParentNativeNumber := EditNativeNumber.Text;
    end;
    ClearAllEdit;
    Frmfbl.SocketAddData(sizeof(cCCreateIdPass3), @cCCreateIdPass3);
    Pninfo.Caption := ('正在注册账号...');
end;

procedure TFrmNewUser.Timer1Timer(Sender: TObject);
begin
    if Visible = false then exit;
    if fnewconnstate then exit;
    case Fnewstate of
        1:                                                                      //连接
            begin
                Frmfbl.FGameStatus := gs_none;
                if Frmfbl.sckConnect.Socket.Connected
                    and (Frmfbl.sckConnect.Host = ReConnectIpAddr)
                    and (Frmfbl.sckConnect.Port = ReConnectPort) then
                begin
                    Fnewstate := 3;
                    exit;
                end;
                Frmfbl.sckConnect.Active := false;
                Fnewstate := 2;
            end;
        2:
            begin
                if Frmfbl.sckConnect.Socket.Connected = false then
                begin
                    Frmfbl.FGameStatus := gs_BA;
                    Frmfbl.sckConnect.Host := ReConnectIpAddr;
                    Frmfbl.sckConnect.Port := ReConnectPort;
                    Frmfbl.sckConnect.Open;
                    Fnewstate := 3;
                    Pninfo.Caption := ('连接服务器…');
                    cConnTime := mmAnsTick;
                end else
                begin
                    if GetItemLineTimeSec(mmAnsTick - cConnTime) > 5 then
                    begin
                        cConnTime := mmAnsTick;
                        Fnewstate := 1;
                    end;
                end;
            end;

        3:
            begin

                if Frmfbl.sckConnect.Socket.Connected then
                begin
                    ReConnectId := 'regname';
                    ReConnectPass := 'regpass';
                    Frmfbl.sendBalance;
                    PnInfo.Caption := ('等待获取证书…');
                    Fnewstate := 5;
                end else
                begin
                    if GetItemLineTimeSec(mmAnsTick - cConnTime) > 5 then
                    begin
                        cConnTime := mmAnsTick;
                        Fnewstate := 1;
                    end;
                end;
            end;
        5:
            begin

            end;
        10:
            begin
                Frmfbl.sckConnect.Active := false;
                Fnewstate := 11;

            end;
        11:
            begin
                if Frmfbl.sckConnect.Socket.Connected = false then
                begin
                    Frmfbl.FGameStatus := gs_login;
                    Frmfbl.sckConnect.Host := regconnip;
                    Frmfbl.sckConnect.Port := regconnprot;
                    Frmfbl.sckConnect.Open;
                    Fnewstate := 12;
                    PnInfo.Caption := ('连接服务器…');
                end else
                begin
                    if GetItemLineTimeSec(mmAnsTick - cConnTime) > 5 then
                    begin
                        cConnTime := mmAnsTick;
                        Fnewstate := 10;
                    end;
                end;
            end;
        12:
            begin

                if Frmfbl.sckConnect.Socket.Connected then
                begin
                    fnewconnstate := true;
                    PnInfo.Caption := ('服务器连接正常。');
                    ButtonRegOK.Enabled := fnewconnstate;
                    ButtonUpDateOK.Enabled := fnewconnstate;
                    ButtonFindOK.Enabled := fnewconnstate;
                    Fnewstate := 13;
                end else
                begin
                    if GetItemLineTimeSec(mmAnsTick - cConnTime) > 5 then
                    begin
                        cConnTime := mmAnsTick;
                        Fnewstate := 10;
                    end;
                end;

            end;
    end;
end;

//密码修改按钮

procedure TFrmNewUser.ButtonPassUpdateClick(Sender: TObject);

begin
    SetRegisteState(nuws_UpDatePass);
end;

//密码查询按钮

procedure TFrmNewUser.ButtonFindPassClick(Sender: TObject);
begin
    SetRegisteState(nuws_FindPass);
end;

procedure TFrmNewUser.ButtonRegisterClick(Sender: TObject);
begin
    SetRegisteState(nuws_registe);
end;

procedure TFrmNewUser.ButtonFindPasswordClick(Sender: TObject);
begin
    SetRegisteState(nuws_FindPass);
end;

procedure TFrmNewUser.ButtonUpDateOKClick(Sender: TObject);
var
    cUpdatePassword: TCUpdatePassword;
begin
    FrmM.SoundManager.NewPlayEffect('click.wav', 0);

    edit_UpPassId.Text := trim(edit_UpPassId.Text);
    edit_UpPassOldPass.Text := trim(edit_UpPassOldPass.Text);
    edit_UpPassNewPassword.Text := trim(edit_UpPassNewPassword.Text);
    edit_UpPassAgain.Text := trim(edit_UpPassAgain.Text);
    edit_UpPassEmail.Text := trim(edit_UpPassEmail.Text);
    edit_UpPassMasterKey.Text := trim(edit_UpPassMasterKey.Text);

    if (Length(edit_UpPassId.Text) < 6) or (not isGrammarID(edit_UpPassId.Text)) then
    begin
        Pninfo.Caption := ('【账户名称】只能使用英文字母与阿拉伯数字；并且至少6位。');
        edit_UpPassId.SetFocus;
        exit;
    end;
    if (Length(edit_UpPassOldPass.Text) < 6) or (not isGrammarID(edit_UpPassOldPass.Text)) then
    begin
        Pninfo.Caption := ('【账户密码】只能使用英文字母与阿拉伯数字；并且至少6位。');
        edit_UpPassOldPass.SetFocus;
        exit;
    end;
    if (Length(edit_UpPassNewPassword.Text) < 6) or (not isGrammarID(edit_UpPassNewPassword.Text)) then
    begin
        Pninfo.Caption := ('【新账户密码】只能使用英文字母与阿拉伯数字；并且至少6位。');
        edit_UpPassNewPassword.SetFocus;
        exit;
    end;
    if edit_UpPassAgain.Text <> edit_UpPassNewPassword.Text then
    begin
        Pninfo.Caption := ('【新账户密码】与【重复新账户密码】不一致。');
        edit_UpPassAgain.SetFocus;
        exit;
    end;

    if (Length(edit_UpPassEmail.Text) < 4) or (not isEmailID(edit_UpPassEmail.Text)) then
    begin
        Pninfo.Caption := ('【电子邮件】只能使用英文字母、阿拉伯数字；并且至少4位。');
        edit_UpPassEmail.SetFocus;
        exit;
    end;
    if (Length(edit_UpPassMasterKey.Text) < 4) or (not isFullHangul(edit_UpPassMasterKey.Text)) then
    begin
        Pninfo.Caption := ('【安全问答】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
        edit_UpPassMasterKey.SetFocus;
        exit;
    end;

    fillchar(cUpdatePassword, sizeof(cUpdatePassword), 0);
    with cUpdatePassword do
    begin
        rMsg := CM_UPDATEPASSWORD;
        rID := edit_UpPassId.Text;
        rPass := edit_UpPassOldPass.Text;
        rNewPass := edit_UpPassNewPassword.Text;
        rEmail := edit_UpPassEmail.Text;
        rMasterKey := edit_UpPassMasterKey.Text;
    end;
    ClearAllEdit;
    Frmfbl.SocketAddData(sizeof(cUpdatePassword), @cUpdatePassword);          //发送给GATE
    Pninfo.Caption := ('正在验证信息,请等待...');
end;

procedure TFrmNewUser.ButtonFindRegisterClick(Sender: TObject);
begin
    SetRegisteState(nuws_registe);
end;

procedure TFrmNewUser.ButtonFindUpDateClick(Sender: TObject);
begin
    SetRegisteState(nuws_UpDatePass);
end;

procedure TFrmNewUser.onconnect();
begin
    Pninfo.Caption := '连接中...';

    ButtonRegOK.Enabled := fnewconnstate;
    ButtonUpDateOK.Enabled := fnewconnstate;
    ButtonFindOK.Enabled := fnewconnstate;
end;

procedure TFrmNewUser.onDisconnect();
begin
    Pninfo.Caption := '服务器断开';

    ButtonRegOK.Enabled := false;
    ButtonUpDateOK.Enabled := false;
    ButtonFindOK.Enabled := false;
end;

procedure TFrmNewUser.FormShow(Sender: TObject);
begin
    SetRegisteState(nuws_registe);
    ClearAllEdit;
    Frmfbl.PnInfo.Caption := '';
    fnewconnstate := false;
    regconnip := '';
    regconnprot := 0;
    Fnewstate := 1;
end;

procedure TFrmNewUser.ClearAllEdit();
var
    i: integer;
    temp: TObject;
begin

    for i := 0 to Self.ComponentCount - 1 do
    begin
        temp := Self.Components[i];
        if temp is ta2edit then
            ta2edit(temp).Text := '';
    end;
end;

procedure TFrmNewUser.ButtonFindOKClick(Sender: TObject);
var
    cFindPassword: TFindPassword;
begin
    FrmM.SoundManager.NewPlayEffect('click.wav', 0);
    EditFindID.Text := trim(EditFindID.Text);
    EditFindEMAI.Text := trim(EditFindEMAI.Text);
    EditFindMasterKey.Text := trim(EditFindMasterKey.Text);

    if (Length(EditFindID.Text) < 6) or (not isGrammarID(EditFindID.Text)) then
    begin
        Pninfo.Caption := ('【账户名称】只能使用英文字母与阿拉伯数字；并且至少6位。');
        EditFindID.SetFocus;
        exit;
    end;

    if (Length(EditFindEMAI.Text) < 4) or (not isEmailID(EditFindEMAI.Text)) then
    begin
        Pninfo.Caption := ('【电子邮件】只能使用英文字母、阿拉伯数字；并且至少4位。');
        EditFindEMAI.SetFocus;
        exit;
    end;
    if (Length(EditFindMasterKey.Text) < 4) or (not isFullHangul(EditFindMasterKey.Text)) then
    begin
        Pninfo.Caption := ('【安全问答】只能使用英文字母、阿拉伯数字、汉字；并且至少4位。');
        EditFindMasterKey.SetFocus;
        exit;
    end;

    fillchar(cFindPassword, sizeof(TFindPassword), 0);
    with cFindPassword do
    begin
        rMsg := CM_FINDPASSWORD;
        rID := EditFindID.Text;
        rEmail := EditFindEMAI.Text;
        rMasterKey := EditFindMasterKey.Text;
    end;
    ClearAllEdit;
    Frmfbl.SocketAddData(sizeof(TFindPassword), @cFindPassword);              //发送给GATE
    Pninfo.Caption := ('正在验证信息,请等待...');
end;

end.

