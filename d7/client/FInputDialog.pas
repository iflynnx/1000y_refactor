unit FInputDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  deftype, A2Form, AUtil32, ExtCtrls, Buttons;

type
  TfrmInputDialog = class(TForm)
    edtName: TEdit;
    lblTitle: TA2Label;
    Image1: TImage;
    BtnOk: TA2Button;
    BtnCancel: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }
    CurrentMsg: Byte;
    SenderId: Longint;
  public
    { Public declarations }
    procedure MessageProcess(var ACode: TWordComData);
  end;

var
  frmInputDialog: TfrmInputDialog;

implementation

uses FMain, FAttrib, FBottom, FLogOn;

{$R *.dfm}

{ TfrmInputDialog }

procedure TfrmInputDialog.MessageProcess(var ACode: TWordComData);
var
  pckey: PTCKey;
  pSStartHelpWindow: PTSStartHelpWindow;
  PSStartGuildInputWindow: PTSStartGuildInputWindow;
begin
  pckey := @ACode.data;
  case pckey^.rmsg of
    SM_MARRYWINDOW, SM_GUILDMONEYCHIPWINDOW:
      begin
        CurrentMsg := pckey^.rmsg;
        pSStartHelpWindow := @ACode.Data;
        lblTitle.Caption := GetWordString(pSStartHelpWindow.rHelpText);
        Visible := True;
      end;
    SM_INPUTGUILDNAMEWINDOW:
      begin
        CurrentMsg := pckey^.rmsg;
        PSStartGuildInputWindow := @ACode.Data;
        lblTitle.Caption := GetWordString(PSStartGuildInputWindow.rHelpText);
        SenderId := PSStartGuildInputWindow.rSenderID;
        Visible := True;
      end;
  end;

end;

procedure TfrmInputDialog.FormCreate(Sender: TObject);
begin
  //FrmM.AddA2Form(Self, A2Form1);
  Parent := FrmM;
  Left := (640 - frmAttrib.Width - Width) div 2;
  Top := (480 - frmBottom.Height - Height) div 2;
  Visible := False;
end;

procedure TfrmInputDialog.Button1Click(Sender: TObject);
var
  cSelectHelpWindow: TCSelectHelpWindow;
  cInputGuildWindow: TCInputGuildWindow;
  n: Integer;
begin
  case CurrentMsg of
    SM_MARRYWINDOW:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_MARRY;
          SetWordString(rSelectKey, edtName.Text);
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
        Visible := False;
      end;
    SM_INPUTGUILDNAMEWINDOW:
      begin
        with cInputGuildWindow do
        begin
          rMsg := CM_INPUTGUILDNAME;
          SetWordString(rSelectKey, edtName.Text);
          rSenderId := SenderId;
          n := SizeOf(cInputGuildWindow) - SizeOf(TWordString) +
            SizeOfWordString(cInputGuildWindow.rSelectKey);
          FrmLogon.SocketAddData(n, @cInputGuildWindow);
          Visible := False;
        end;
      end;
    SM_GUILDMONEYCHIPWINDOW:
      begin
        with cSelectHelpWindow do
        begin
          rMsg := CM_GUILDMONEYCHIP;
          SetWordString(rSelectKey, edtName.Text);
        end;
        n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
          SizeOfWordString(cSelectHelpWindow.rSelectKey);
        FrmLogon.SocketAddData(n, @cSelectHelpWindow);
        Visible := False;
      end;
  end;
end;

procedure TfrmInputDialog.BtnCancelClick(Sender: TObject);
begin
  edtName.Text := '';
  Button1Click(Sender);
end;

end.

