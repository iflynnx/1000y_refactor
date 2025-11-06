unit FConfirmDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, A2Form,
  //-----------------------
  deftype, AUtil32, ExtCtrls;

type
  TfrmConfirmDialog = class(TForm)
    A2Form1: TA2Form;
    lblText: TA2Label;
    BtnOk: TA2Button;
    BtnCancel: TA2Button;
    lblCaption: TA2Label;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    InvitedSender: string;
    Key: string;

    CurrentRMsg: Byte;

    procedure MessageProcess(var ACode: TWordComData);
    procedure BtnClick(AConfirm: Boolean);
  end;

var
  frmConfirmDialog: TfrmConfirmDialog;

implementation

uses FMain, FAttrib, FBottom, FLogOn;

{$R *.dfm}

procedure TfrmConfirmDialog.FormCreate(Sender: TObject);
begin
  FrmM.AddA2Form(Self, A2Form1);
  Left := (640 - frmAttrib.Width - Width) div 2;
  Top := (480 - frmBottom.Height - Height) div 2;
  Visible := False;
end;

procedure TfrmConfirmDialog.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //ReleaseCapture;
  //SendMessage(Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TfrmConfirmDialog.BtnCancelClick(Sender: TObject);
begin
  BtnClick(False);
end;

procedure TfrmConfirmDialog.BtnOkClick(Sender: TObject);
begin
  BtnClick(True)
end;

procedure TfrmConfirmDialog.MessageProcess(var ACode: TWordComData);
var
  pckey: PTCKey;
  pSShowInviteConfirm: PTSShowInviteConfirm;
  pSStartHelpWindow: PTSStartHelpWindow;
begin
  pckey := @ACode.data;
  CurrentRMsg := pcKey^.rmsg;
  case pckey^.rmsg of
    SM_ISINVITETEAM:
      begin
        pSShowInviteConfirm := @ACode.Data;
        lblCaption.Caption := StrPas(@pSShowInviteConfirm.rCaption);
        lblText.Caption := GetWordString(pSShowInviteConfirm.rWordString);
        InvitedSender := StrPas(@pSShowInviteConfirm.rInvitedSender);
        Key := StrPas(pSShowInviteConfirm.rKey);
        Visible := True;
      end;
    SM_MARRYANSWERWINDOW:
      begin
        pSStartHelpWindow := @ACode.Data;
        lblCaption.Caption := '';
        lblText.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
    SM_UNMARRY:
      begin
        pSStartHelpWindow := @ACode.Data;
        lblCaption.Caption := '';
        lblText.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
    SM_GUILDMONEYAPPLYWINDOW:
      begin
        pSStartHelpWindow := @ACode.Data;
        lblCaption.Caption := '';
        lblText.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
    SM_GUILDSUBSYSOP:
      begin
        pSStartHelpWindow := @ACode.Data;
        lblCaption.Caption := '';
        lblText.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
    SM_ARENAWINDOW:
      begin
        pSStartHelpWindow := @ACode.Data;
        lblCaption.Caption := '';
        lblText.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
    SM_ARENAJOINWINDOW:
      begin
        pSStartHelpWindow := @ACode.Data;
        lblCaption.Caption := '';
        lblText.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
    // add by minds 2005-03-28
    SM_GUILDANSWERWINDOW:
      begin
        pSStartHelpWindow := @ACode.Data;
        lblCaption.Caption := '';
        lblText.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
  end;
end;

procedure TfrmConfirmDialog.BtnClick(AConfirm: Boolean);
var
  cInvitation: TSInvitation;
  cSelectHelpWindow: TCSelectHelpWindow;
  n: Integer;
begin
  case CurrentRMsg of
    SM_ISINVITETEAM:
      begin
        with cInvitation do
        begin
          rMsg := CM_COMFIRMINVITATION;
          if AConfirm then
            rReturn := AGREE_INVITATION
          else
            rReturn := DISAGREE_INVITATION;
          StrPCopy(@rUser, InvitedSender);
          StrPCopy(@rKey, Key);
        end;
        FrmLogon.SocketAddData(SizeOf(TSInvitation), @CInvitation);
      end;
    SM_MARRYANSWERWINDOW:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_MARRYANSWER;
          if AConfirm then
            SetWordString(rSelectKey, 'yes')
          else
            SetWordString(rSelectKey, 'no');
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
      end;
    SM_UNMARRY:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_UNMARRY;
          if AConfirm then
            SetWordString(rSelectKey, 'yes')
          else
            SetWordString(rSelectKey, 'no');
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
      end;
    SM_GUILDMONEYAPPLYWINDOW:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_GUILDMONEYAPPLY;
          if AConfirm then
            SetWordString(rSelectKey, 'yes')
          else
            SetWordString(rSelectKey, 'no');
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
      end;
    SM_GUILDSUBSYSOP:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_GUILDSUBSYSOP;
          if AConfirm then
            SetWordString(rSelectKey, 'yes')
          else
            SetWordString(rSelectKey, 'no');
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
      end;
    SM_ARENAWINDOW:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_ARENAWINDOW;
          if AConfirm then
            SetWordString(rSelectKey, 'yes')
          else
            SetWordString(rSelectKey, 'no');
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
      end;
    SM_ARENAJOINWINDOW:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_ARENAJOINWINDOW;
          if AConfirm then
            SetWordString(rSelectKey, 'yes')
          else
            SetWordString(rSelectKey, 'no');
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
      end;
    SM_GUILDANSWERWINDOW:
      begin         
        with cSelectHelpWindow do
        begin
          rMsg := CM_GUILDANSWERWINDOW;
          if AConfirm then
            SetWordString(rSelectKey, 'yes')
          else
            SetWordString(rSelectKey, 'no');
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
      end;
  end;


  Visible := False;
end;

end.

