unit FcMessageBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, StdCtrls, Deftype, ExtCtrls, AUtil32, A2Img, AtzCls, shellapi, BaseUIForm;

const
  MessageMaxCount = 3;

type
  TFrmcMessageBox = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2LabelCaption: TA2Label;
    A2ButtonOK: TA2Button;
    A2ButtonCanCel: TA2Button;
    A2LabelText0: TA2Label;
    A2LabelText1: TA2Label;
    A2LabelText2: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ButtonOKClick(Sender: TObject);
    procedure A2ButtonCanCelClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    FAgree: Boolean;
    MessageArr: array[0..MessageMaxCount - 1] of TA2Label;
    FAbort: Boolean;
  public
    procedure AddMessageText(aText: string);
    procedure MessageProcess(var code: TWordComData);

    procedure SetImage;

    procedure SetMessage(astr: string);


    //procedure SetOldVersion;
    procedure AbortGame();

    procedure SetNewVersion(); override;


    //procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;

  end;

var
  FrmcMessageBox: TFrmcMessageBox;
  curversion: string;
implementation

uses
  FMain, FAttrib, FBottom, Fbl, filepgkclass;

{$R *.DFM}

procedure TFrmcMessageBox.SetNewVersion;

begin
  inherited;

end;

//procedure TFrmcMessageBox.SetOldVersion;
//begin
//  pgkBmp.getBmp('Mess.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//  SetImage;
//end;

procedure TFrmcMessageBox.FormCreate(Sender: TObject);
var
  i: integer;
begin
  inherited;
  FTestPos:=True;
  FAbort := False;
  FAgree := False;
  FrmM.AddA2Form(Self, A2Form);
  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;
  Top := 10;
  Left := 10;
  for i := 0 to MessageMaxCount - 1 do
  begin
    MessageArr[i] := TA2Label(FindComponent('A2LabelText' + IntToStr(i)));
  end;

end;

procedure TFrmcMessageBox.FormDestroy(Sender: TObject);
begin
    //
end;

procedure TFrmcMessageBox.AddMessageText(aText: string);
var
  str, rdstr: string;
  int: integer;
begin
  str := aText;
  int := 0;
  while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    MessageArr[int].Caption := rdstr;
    inc(int);
    if str = '' then Break;
    if int > MessageMaxCount - 1 then break;
  end;
end;

{
   TSShowSpecialWindow = record
      rMsg : Byte;
      rWindow : Byte;
      rCaption : TNameString;
      rWordString: TWordString;
   end;
   PTSShowSpecialWindow = ^TSShowSpecialWindow;

}

procedure TFrmcMessageBox.SetMessage(astr: string);
begin
  A2LabelText0.Caption := CutLengthString(astr, A2LabelText0.Width);
  A2LabelText1.Caption := CutLengthString(astr, A2LabelText1.Width);
  A2LabelText2.Caption := CutLengthString(astr, A2LabelText2.Width);
end;

function CenterStr(Src: string; Before, After: string): string;
var
  Pos1, Pos2: WORD;
begin
  Pos1 := Pos(Before, Src);
  Pos2 := Pos(After, Src);
  if (Pos1 = 0) or (Pos2 = 0) then //如果src中没有B串和A串
  begin
    Result := '';
    Exit;
  end;
  Pos1 := Pos1 + Length(Before); //句1.B串起始位+B串的长度
  if Pos2 - Pos1 = 0 then
  begin
    Result := '';
    Exit;
  end;
  Result := Copy(Src, Pos1, Pos2 - Pos1); // 从B串后的第一字符开始复制
  //此函数的作用实际上就是取得B\A两串之得的字符串,适用于BA两串已知, 要取的串由用户确定的情况
end;

procedure TFrmcMessageBox.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  PSSShowSpecialWindow: PTSShowSpecialWindow;
  version: TStringList;
begin
  pckey := @code.Data;
  case pckey^.rmsg of
    SM_SHOWSPECIALWINDOW:
      begin
        PSSShowSpecialWindow := @Code.data;
        case PSSShowSpecialWindow^.rWindow of
          WINDOW_Close_All: Visible := false;
          WINDOW_AGREE:
            begin
              FAbort := False;
              PSSShowSpecialWindow := @Code.Data;
            {  try
              version:=tstringlist.create  ;
              if FileExists(ExtractFilePath(ParamStr(0)+'\ver.txt')) then
              begin
              version.LoadFromFile(ExtractFilePath(ParamStr(0)+'\ver.txt'));
              curversion:=version.Strings[0];
              end;
              except
              end;
              FreeAndNil(version);
              if curversion<>CenterStr(PSSShowSpecialWindow^.rCaption,'[',']') then
              begin
                MessageBox(0,'有新版本登录器'+#13#10+'请更新','升级提示',0);
              end;            }
             // A2LabelCaption.Caption := '你确认要终止游戏吗？';

            //  A2LabelCaption.Caption := (PSSShowSpecialWindow^.rCaption);
              SetMessage(GetWordString(PSSShowSpecialWindow^.rWordString));
              Visible := TRUE;
              FrmM.SetA2Form(Self, A2form);
              FrmM.move_win_form_Align(Self, mwfCenter);
            end;
        end;
      end;
  end;
end;


procedure TFrmcMessageBox.A2ButtonOKClick(Sender: TObject);

var
  cCWindowConfirm: TCWindowConfirm;
begin
  if FAbort then
    ExitProcess(0);
  cCWindowConfirm.rMsg := CM_WINDOWCONFIRM;
  CCWindowConfirm.rWindow := WINDOW_AGREE;
  cCWindowConfirm.rboCheck := TRUE;
  cCWindowConfirm.rButton := 0; // 滚瓢捞 咯妨俺 乐阑版快父 荤侩 老馆篮 0捞 檬扁蔼
  Frmfbl.SocketAddData(sizeof(cCWindowConfirm), @cCWindowConfirm);
  Visible := FALSE;
  FrmBottom.AbortGame;
  FrmBottom.SetFocus;
  FrmBottom.EdChat.SetFocus;
end;

procedure TFrmcMessageBox.A2ButtonCanCelClick(Sender: TObject);
var
  cCWindowConfirm: TCWindowConfirm;
begin
  FAbort := False;
  cCWindowConfirm.rMsg := CM_WINDOWCONFIRM;
  CCWindowConfirm.rWindow := WINDOW_AGREE;
  cCWindowConfirm.rboCheck := FALSE;
  cCWindowConfirm.rButton := 0; // 滚瓢捞 咯妨俺 乐阑版快父 荤侩 老馆篮 0捞 檬扁蔼
  Frmfbl.SocketAddData(sizeof(cCWindowConfirm), @cCWindowConfirm);
  Visible := FALSE;
  if FrmBottom.Visible  and FrmBottom.CanFocus then
    FrmBottom.SetFocus;
  if FrmBottom.Visible and FrmBottom.EdChat.CanFocus then
    FrmBottom.EdChat.SetFocus;
end;

procedure TFrmcMessageBox.SetImage;
begin
  A2ButtonOK.A2Up := EtcAtzClass.GetEtcAtz(47);
  A2ButtonOk.A2Down := EtcAtzClass.GetEtcAtz(48);
  A2ButtonCanCel.A2Up := EtcAtzClass.GetEtcAtz(49);
  A2ButtonCanCel.A2Up := EtcAtzClass.GetEtcAtz(50);
end;

procedure TFrmcMessageBox.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmcMessageBox.FormShow(Sender: TObject);
begin
  FAgree := False;
end;

procedure TFrmcMessageBox.AbortGame;
begin
  FAbort := True;
  //A2LabelCaption.Caption := '你要终止游戏吗？';
  SetMessage('你要终止游戏吗？');
  Visible := TRUE;
  FrmM.SetA2Form(Self, A2form);
  FrmM.move_win_form_Align(Self, mwfCenter);

end;

procedure TFrmcMessageBox.SetConfigFileName;
begin
  FConfigFileName := 'MessageBox.xml';
end;

//procedure TFrmcMessageBox.SetNewVersionOld;
//var
//  temping: TA2Image;
//begin
//  temping := TA2Image.Create(32, 32, 0, 0);
//  try
//    pgkBmp.getBmp('通用对话窗口.bmp', A2form.FImageSurface);
//    A2form.boImagesurface := true;
//    Width := A2Form.FImageSurface.Width;
//    Height := A2Form.FImageSurface.Height;
//
//    pgkBmp.getBmp('通用_确认_弹起.bmp', temping);
//    A2ButtonOK.A2Up := temping;
//    pgkBmp.getBmp('通用_确认_按下.bmp', temping);
//    A2ButtonOK.A2Down := temping;
//    pgkBmp.getBmp('通用_确认_鼠标.bmp', temping);
//    A2ButtonOK.A2Mouse := temping;
//    pgkBmp.getBmp('通用_确认_禁止.bmp', temping);
//    A2ButtonOK.A2NotEnabled := temping;
//    A2ButtonOK.Left := 33;
//    A2ButtonOK.Top := 109;
//    A2ButtonOK.Width := 52;
//    A2ButtonOK.Height := 22;
//
//    pgkBmp.getBmp('通用_取消_弹起.bmp', temping);
//    A2ButtonCanCel.A2Up := temping;
//    pgkBmp.getBmp('通用_取消_按下.bmp', temping);
//    A2ButtonCanCel.A2Down := temping;
//    pgkBmp.getBmp('通用_取消_鼠标.bmp', temping);
//    A2ButtonCanCel.A2Mouse := temping;
//    pgkBmp.getBmp('通用_取消_禁止.bmp', temping);
//    A2ButtonCanCel.A2NotEnabled := temping;
//    A2ButtonCanCel.Left := 147;
//    A2ButtonCanCel.Top := 109;
//    A2ButtonCanCel.Width := 52;
//    A2ButtonCanCel.Height := 22;
//
//    A2LabelCaption.Left := A2LabelCaption.Left - 90;
//    A2LabelCaption.Top := A2LabelCaption.Top - 20;
//    A2LabelCaption.FontColor := ColorSysToDxColor($FFFF00);
//    A2LabelCaption.Visible := false;
//
//    A2LabelText0.Top := A2LabelText0.Top - 20;
//    A2LabelText0.Left := A2LabelText0.Left + 25;
//    A2LabelText0.FontColor := ColorSysToDxColor($FFFF00);
//    A2LabelText1.FontColor := ColorSysToDxColor($FFFF00);
//    A2LabelText1.Visible := false;
//    A2LabelText2.FontColor := ColorSysToDxColor($FFFF00);
//    A2LabelText2.Visible := false;
//
//  finally
//    temping.Free;
//  end;
//end;

procedure TFrmcMessageBox.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);

  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := True;
  SetControlPos(A2ButtonOK);

  SetControlPos(A2ButtonCanCel);
  SetControlPos(A2LabelCaption);


  A2LabelCaption.FontColor := ColorSysToDxColor($FFFF00);
  SetControlPos(A2LabelText0);
  SetControlPos(A2LabelText1);
  SetControlPos(A2LabelText2);
  A2LabelText0.FontColor := ColorSysToDxColor($FFFF00);
  A2LabelText1.FontColor := ColorSysToDxColor($FFFF00);

  A2LabelText2.FontColor := ColorSysToDxColor($FFFF00);



end;

procedure TFrmcMessageBox.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

end.

