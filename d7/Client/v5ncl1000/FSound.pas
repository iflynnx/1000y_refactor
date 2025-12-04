unit FSound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CharCls, a2img, ComCtrls, MMSystem, USound, StdCtrls, A2Form, ExtCtrls,
  deftype, AUtil32, BaseUIForm, NativeXml, uAnsTick, DXDraws, uIniFile, uHardCode;

type
  TFrmSound = class(TfrmBaseUI)
    BtnOutcrybak: TA2Button;
    BtnGuildbak: TA2Button;
    BtnNoticebak: TA2Button;
    BtnNormalbak: TA2Button;
    Image1: TImage;
    A2Button1: TA2Button;
    A2Button2: TA2Button;
    A2Form: TA2Form;
    Check_Outcry: TA2CheckBox;
    Check_Notice: TA2CheckBox;
    Check_Guild: TA2CheckBox;
    Check_Normal: TA2CheckBox;
    A2Button3: TA2Button;
    A2Button4: TA2Button;
    A2Button5: TA2Button;
    A2Button6: TA2Button;
    A2Button7: TA2Button;
    Check_Team: TA2CheckBox;
    Check_World: TA2CheckBox;
    Check_PrivateMsg: TA2CheckBox;
    A2CheckBox_changeForm: TA2CheckBox;
    check_trade: TA2CheckBox;
    check_guildjoin: TA2CheckBox;
    A2CheckBox_ShowSelfName: TA2CheckBox;
    A2CheckBox_ShowMonster: TA2CheckBox;
    A2CheckBox_ShowNpc: TA2CheckBox;
    A2CheckBox_ShowPlayer1: TA2CheckBox;
    A2CheckBox_ShowItem: TA2CheckBox;
    A2CheckBox_ShowGuildName: TA2CheckBox;
    A2CheckBox_ShowDamage: TA2CheckBox;
    A2CheckBox1: TA2CheckBox;
    check_HailFellowjoin: TA2CheckBox;
    Check_ALLY: TA2CheckBox;
    A2CheckBox_yinyue: TA2CheckBox;
    A2CheckBox_yinxiao: TA2CheckBox;
    A2ComboBox_fbl: TA2ComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnNormalbakClick(Sender: TObject);
    procedure A2Button2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure A2Button2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure A2Button2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure A2Button1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure A2Button1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure A2Button1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Check_OutcryClick(Sender: TObject);
    procedure Check_GuildClick(Sender: TObject);
    procedure Check_NoticeClick(Sender: TObject);
    procedure Check_NormalClick(Sender: TObject);
    procedure A2Button3Click(Sender: TObject);
    procedure A2Button4Click(Sender: TObject);
    procedure A2Button5Click(Sender: TObject);
    procedure A2Button6Click(Sender: TObject);
    procedure A2Button7Click(Sender: TObject);
    procedure Check_TeamClick(Sender: TObject);
    procedure Check_WorldClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Check_PrivateMsgClick(Sender: TObject);
    procedure A2CheckBox_changeFormClick(Sender: TObject);
    procedure check_tradeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure check_guildjoinClick(Sender: TObject);
    procedure A2CheckBox_ShowSelfNameClick(Sender: TObject);
    procedure A2CheckBox_ShowMonsterClick(Sender: TObject);
    procedure A2CheckBox_ShowNpcClick(Sender: TObject);
    procedure A2CheckBox_ShowPlayer1Click(Sender: TObject);
    procedure A2CheckBox_ShowItemClick(Sender: TObject);
    procedure A2CheckBox_ShowGuildNameClick(Sender: TObject);
    procedure A2CheckBox_ShowDamageClick(Sender: TObject);
    procedure check_HailFellowjoinClick(Sender: TObject);
    procedure Check_ALLYClick(Sender: TObject);
    procedure A2CheckBox_yinyueClick(Sender: TObject);
    procedure A2CheckBox_yinxiaoClick(Sender: TObject);
    procedure A2ComboBox_fblChange(Sender: TObject);
  private
    MINVALUE: Integer;
    FISShow: Boolean;
  public
    procedure setVolume(av: integer);
    procedure setVolumeEffect(av: integer);
    //procedure SetOldVersion;
    procedure SetNewVersion(); override;
   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetOtherConfig();
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure savetofile(afilenam: string);
    procedure loadFromfile(afilenam: string);
    procedure autosave;
    procedure autoload;
    procedure InitTgsConfig;
  end;

var
  FrmSound: TFrmSound;

var
  Boolflag: Boolean;
  Or_X: integer;
  Max, Min: integer;
  minsound: integer;

implementation

uses
  FMain, FBottom, filepgkclass, Fbl, FMonsterBuffPanel;

{$R *.DFM}

//////////////////// FrmSound //////////////////////////////////////////////////

procedure TFrmSound.SetNewVersion;
begin
  inherited;
end;

//procedure TFrmSound.SetOldVersion;
//var
//  tempimg: TA2Image;
//begin
//  tempimg := TA2Image.Create(32, 32, 0, 0);
//  try
//    A2form.FImageSurface.LoadFromBitmap(Image1.Picture.Bitmap);
//    A2form.boImagesurface := true;
//
//    tempimg.LoadFromBitmap(BtnOutcrybak.UpImage.Bitmap);
//    Check_Outcry.SelectImage := tempimg;
//    tempimg.LoadFromBitmap(BtnOutcrybak.DownImage.Bitmap);
//    Check_Outcry.SelectNotImage := tempimg;
//
//    tempimg.LoadFromBitmap(BtnGuildbak.UpImage.Bitmap);
//    Check_Guild.SelectImage := tempimg;
//    tempimg.LoadFromBitmap(BtnGuildbak.DownImage.Bitmap);
//    Check_Guild.SelectNotImage := tempimg;
//
//    tempimg.LoadFromBitmap(BtnNoticebak.UpImage.Bitmap);
//    Check_Notice.SelectImage := tempimg;
//    tempimg.LoadFromBitmap(BtnNoticebak.DownImage.Bitmap);
//    Check_Notice.SelectNotImage := tempimg;
//
//    tempimg.LoadFromBitmap(BtnNormalbak.UpImage.Bitmap);
//    Check_Normal.SelectImage := tempimg;
//    tempimg.LoadFromBitmap(BtnNormalbak.DownImage.Bitmap);
//    Check_Normal.SelectNotImage := tempimg;
//
//    max := 105;
//    min := 30;
//  finally
//    tempimg.Free;
//  end;
//end;

procedure TFrmSound.FormCreate(Sender: TObject);
begin
  inherited;
  FISShow := False;
  FTestPos := True;
    // Parent := FrmM;
  Color := clBlack;
  Left := 10;
  Top := 14;

  FrmM.AddA2Form(Self, A2form);

  Boolflag := FALSE;

  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;
  MINVALUE := minsound;
//  A2Button1.Left := FrmM.SoundManager.Volume;
//  A2Button2.Left := FrmM.SoundManager.VolumeEffect;
  if A2Button1.Left >= max then
    A2Button1.Left := max;
  if A2Button1.Left <= min then
    A2Button1.Left := min;
  if A2Button2.Left >= max then
    A2Button2.Left := max;
  if A2Button2.Left <= min then
    A2Button2.Left := min;

  Check_Outcry.Checked := true;
  Check_Notice.Checked := true;
  Check_ALLY.Checked := true;
  Check_Guild.Checked := true;
  Check_Normal.Checked := true;
  Check_Team.Checked := true;
  Check_World.Checked := true;
  Check_World.Enabled := false;

  A2ComboBox_fbl.Items.Text := '800 * 600' + #13#10 + '1024 * 768' + #13#10;
end;

procedure TFrmSound.FormDestroy(Sender: TObject);
begin
end;

/////////////////// OPTION CHAT ////////////////////////////////////////////////

procedure TFrmSound.BtnNormalbakClick(Sender: TObject);
begin
end;

/////////////////// OPTION SOUND ///////////////////////////////////////////////

procedure TFrmSound.A2Button2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Boolflag := TRUE;
end;

procedure TFrmSound.A2Button2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Boolflag := false;
  Or_X := x;
end;

procedure TFrmSound.setVolume(av: integer);
var
  v: single;
begin
  av := -av;
  if (av < 0) or (av > MINVALUE) then
  begin
    av := minsound;
    FrmM.SoundManager.Volume := -av;
  end;
  v := MINVALUE - av;
  v := (v / MINVALUE);
  v := v * (Max - Min);
  v := Min + v;
  A2Button1.Left := trunc(v);


//     A2Button1.Left := A2Button1.Left - 5;
//    if A2Button1.Left < min then A2Button1.Left := min;
//    v := A2Button1.Left - min;
//    v := trunc((v / (max - min)) * 5000);
//    v := 5000 - v;
//    if - v = -5000 then
//      v := minsound;
//    FrmM.SoundManager.Volume := -v;
end;

procedure TFrmSound.setVolumeEffect(av: integer);
var
  v: single;
begin
  av := -av;
  if (av < 0) or (av > MINVALUE) then
  begin
    av := minsound;
    FrmM.SoundManager.VolumeEffect := -av;
  end;
  v := MINVALUE - av;
  v := (v / MINVALUE);
  v := v * (max - min);
  v := Min + v;
  A2Button2.Left := trunc(v);
end;

procedure TFrmSound.A2Button2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  v: integer;
begin
  if Boolflag then
  begin
    x := x + tA2Button(Sender).Left - Or_X;
    tA2Button(Sender).Left := x;
    if tA2Button(Sender).Left > max then
      tA2Button(Sender).Left := max;
    if tA2Button(Sender).Left < min then
      tA2Button(Sender).Left := min;
    v := tA2Button(Sender).Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    if - v = -MINVALUE then
      v := minsound;
    FrmM.SoundManager.VolumeEffect := -v;
  end;
end;

procedure TFrmSound.A2Button1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Boolflag := TRUE;
  Or_X := x;
end;

procedure TFrmSound.A2Button1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Boolflag := false;
end;

procedure TFrmSound.A2Button1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  v: integer;
begin
  if Boolflag then
  begin
    x := x + tA2Button(Sender).Left - Or_X;
    tA2Button(Sender).Left := x;
    if tA2Button(Sender).Left > max then
      tA2Button(Sender).Left := max;
    if tA2Button(Sender).Left < min then
      tA2Button(Sender).Left := min;
    v := tA2Button(Sender).Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    if - v = -MINVALUE then
      v := minsound;
    FrmM.SoundManager.Volume := -v;
  end;
end;

procedure TFrmSound.FormShow(Sender: TObject);
begin
  setVolumeEffect(frmm.SoundManager.VolumeEffect);
  setVolume(frmm.SoundManager.Volume);
  FISShow := True;
end;

procedure TFrmSound.Check_OutcryClick(Sender: TObject);
begin
  chat_outcry := Check_Outcry.Checked;
  autosave;
end;

procedure TFrmSound.Check_GuildClick(Sender: TObject);
begin
  chat_Guild := Check_Guild.Checked;
  autosave;
end;

procedure TFrmSound.Check_NoticeClick(Sender: TObject);
var
  cSay: TCSay;
  cnt: integer;
begin
  chat_notice := Check_Notice.Checked;
  autosave;

end;

procedure TFrmSound.Check_NormalClick(Sender: TObject);
begin
  chat_normal := Check_Normal.Checked;
  autosave;
end;

procedure TFrmSound.A2Button3Click(Sender: TObject);
var
  v: integer;
begin
  if WinVerType = wvtNew then
  begin
    A2Button1.Left := A2Button1.Left - 5;
    if A2Button1.Left < min then
      A2Button1.Left := min;
    v := A2Button1.Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    if - v = -MINVALUE then
      v := minsound;
    FrmM.SoundManager.Volume := -v;
  end;
end;

procedure TFrmSound.A2Button4Click(Sender: TObject);
var
  v: integer;
begin
  if WinVerType = wvtNew then
  begin
    A2Button1.Left := A2Button1.Left + 5;
    if A2Button1.Left > max then
      A2Button1.Left := max;
    v := A2Button1.Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    FrmM.SoundManager.Volume := -v;
  end;
end;

procedure TFrmSound.A2Button5Click(Sender: TObject);
var
  v: integer;
begin
  if WinVerType = wvtNew then
  begin
    A2Button2.Left := A2Button2.Left - 5;
    if A2Button2.Left < min then
      A2Button2.Left := min;
    v := A2Button2.Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    if - v = -MINVALUE then
      v := minsound;
    FrmM.SoundManager.VolumeEffect := -v;
  end;
end;

procedure TFrmSound.A2Button6Click(Sender: TObject);
var
  v: integer;
begin
  if WinVerType = wvtNew then
  begin
    A2Button2.Left := A2Button2.Left + 5;
    if A2Button2.Left > max then
      A2Button2.Left := max;
    v := A2Button2.Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    FrmM.SoundManager.VolumeEffect := -v;
  end;
end;

procedure TFrmSound.A2Button7Click(Sender: TObject);
begin
  autosave;
  FISShow := False;
  Visible := false;

end;

procedure TFrmSound.Check_TeamClick(Sender: TObject);
begin
  chat_duiwu := Check_Team.Checked;
  autosave;
end;

procedure TFrmSound.Check_WorldClick(Sender: TObject);
begin
 //   chat_notice := Check_World.Checked;
 // chat_world := Check_World.Checked;
end;

procedure TFrmSound.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmSound.SetConfigFileName;
begin
  FConfigFileName := 'SystemConfig.xml';

end;

//procedure TFrmSound.SetNewVersionOld;
//var
//  temping: TA2Image;
//begin
//  temping := TA2Image.Create(32, 32, 0, 0);
//  try
//    pgkBmp.getBmp('游戏设置窗口.bmp', A2Form.FImageSurface);
//    A2form.boImagesurface := true;
//    Width := A2Form.FImageSurface.Width;
//    Height := A2Form.FImageSurface.Height;
//
//    pgkBmp.getBmp('游戏设置_滑动条A.bmp', temping);
//    A2Button1.A2Up := temping;
//    pgkBmp.getBmp('游戏设置_滑动条A.bmp', temping);
//    A2Button1.A2Down := temping;
//    A2Button1.Top := 79;
//
//    pgkBmp.getBmp('游戏设置_滑动条B.bmp', temping);
//    A2Button2.A2Up := temping;
//    pgkBmp.getBmp('游戏设置_滑动条B.bmp', temping);
//    A2Button2.A2Down := temping;
//    A2Button2.Top := 117;
//
//    pgkBmp.getBmp('通用减号_弹起.bmp', temping);
//    A2Button3.A2Up := temping;
//    pgkBmp.getBmp('通用减号_按下.bmp', temping);
//    A2Button3.A2Down := temping;
//    pgkBmp.getBmp('通用减号_鼠标.bmp', temping);
//    A2Button3.A2Mouse := temping;
//    pgkBmp.getBmp('通用减号_禁止.bmp', temping);
//    A2Button3.A2NotEnabled := temping;
//    A2Button3.Left := 13;
//    A2Button3.Top := 73;
//    A2Button3.Visible := true;
//
//    pgkBmp.getBmp('通用加号_弹起.bmp', temping);
//    A2Button4.A2Up := temping;
//    pgkBmp.getBmp('通用加号_按下.bmp', temping);
//    A2Button4.A2Down := temping;
//    pgkBmp.getBmp('通用加号_鼠标.bmp', temping);
//    A2Button4.A2Mouse := temping;
//    pgkBmp.getBmp('通用加号_禁止.bmp', temping);
//    A2Button4.A2NotEnabled := temping;
//    A2Button4.Left := 140;
//    A2Button4.Top := 73;
//    A2Button4.Visible := true;
//
//    pgkBmp.getBmp('通用减号_弹起.bmp', temping);
//    A2Button5.A2Up := temping;
//    pgkBmp.getBmp('通用减号_按下.bmp', temping);
//    A2Button5.A2Down := temping;
//    pgkBmp.getBmp('通用减号_鼠标.bmp', temping);
//    A2Button5.A2Mouse := temping;
//    pgkBmp.getBmp('通用减号_禁止.bmp', temping);
//    A2Button5.A2NotEnabled := temping;
//    A2Button5.Left := 13;
//    A2Button5.Top := 111;
//    A2Button5.Visible := true;
//
//    pgkBmp.getBmp('通用加号_弹起.bmp', temping);
//    A2Button6.A2Up := temping;
//    pgkBmp.getBmp('通用加号_按下.bmp', temping);
//    A2Button6.A2Down := temping;
//    pgkBmp.getBmp('通用加号_鼠标.bmp', temping);
//    A2Button6.A2Mouse := temping;
//    pgkBmp.getBmp('通用加号_禁止.bmp', temping);
//    A2Button6.A2NotEnabled := temping;
//    A2Button6.Left := 140;
//    A2Button6.Top := 111;
//    A2Button6.Visible := true;
//
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//    A2Button7.A2Up := temping;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//    A2Button7.A2Down := temping;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//    A2Button7.A2Mouse := temping;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//    A2Button7.A2NotEnabled := temping;
//    A2Button7.Left := 133;
//    A2Button7.Top := 17;
//    A2Button7.Visible := true;
//
//    pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
//    Check_Outcry.SelectImage := temping;
//    pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
//    Check_Outcry.SelectNotImage := temping;
//    Check_Outcry.AutoSize := false;
//
//    Check_Outcry.Left := 120; //57;
//    Check_Outcry.Top := 204; //164;
//    Check_Outcry.Width := 17;
//    Check_Outcry.Height := 17;
//
//    pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
//    Check_Guild.SelectImage := temping;
//    pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
//    Check_Guild.SelectNotImage := temping;
//    Check_Guild.AutoSize := false;
//
//    Check_Guild.Left := 120;
//    Check_Guild.Top := 164;
//    Check_Guild.Width := 17;
//    Check_Guild.Height := 17;
//
//    pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
//    Check_Notice.SelectImage := temping;
//    pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
//    Check_Notice.SelectNotImage := temping;
//    Check_Notice.AutoSize := false;
//
//    Check_Notice.Left := 57;
//    Check_Notice.Top := 184;
//    Check_Notice.Width := 17;
//    Check_Notice.Height := 17;
//
//    pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
//    Check_Normal.SelectImage := temping;
//    pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
//    Check_Normal.SelectNotImage := temping;
//    Check_Normal.AutoSize := false;
//
//    Check_Normal.Left := 57;
//    Check_Normal.Top := 164;
//    Check_Normal.Width := 17;
//    Check_Normal.Height := 17;
//
//    pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
//    Check_Team.SelectImage := temping;
//    pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
//    Check_Team.SelectNotImage := temping;
//    Check_Team.AutoSize := false;
//
//    Check_Team.Left := 57;
//    Check_Team.Top := 204;
//    Check_Team.Width := 17;
//    Check_Team.Height := 17;
//    Check_Team.Visible := true;
//
//    pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
//    Check_World.SelectImage := temping;
//    pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
//    Check_World.SelectNotImage := temping;
//    Check_World.AutoSize := false;
//
//    Check_World.Left := 120; //120;
//    Check_World.Top := 184; //204;
//    Check_World.Width := 17;
//    Check_World.Height := 17;
//    Check_World.Visible := true;
//
//    Image1.Visible := false;
//
//    max := 118;
//    min := 32;
//  finally
//    temping.Free;
//  end;
//end;

procedure TFrmSound.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;

//    pgkBmp.getBmp('游戏设置窗口.bmp', A2Form.FImageSurface);
//    A2form.boImagesurface := true;
//    Width := A2Form.FImageSurface.Width;
//    Height := A2Form.FImageSurface.Height;
  SetControlPos(A2Button1);

  SetControlPos(A2Button2);
  SetControlPos(A2Button3);
  SetControlPos(A2Button4);

  SetControlPos(A2Button5);

  SetControlPos(A2Button6);
  SetControlPos(A2Button7);
  SetControlPos(A2Button7);

  SetControlPos(Check_Outcry);

  Check_Outcry.AutoSize := false;

  SetControlPos(Check_Guild);
  Check_Guild.AutoSize := false;

  SetControlPos(Check_Notice);
  Check_Notice.AutoSize := false;

  SetControlPos(Check_ALLY);
  Check_ALLY.AutoSize := false;


  SetControlPos(Check_Normal);
  Check_Normal.AutoSize := false;

  SetControlPos(Check_Team);

  Check_Team.AutoSize := false;

  SetControlPos(Check_World);

  Check_World.AutoSize := false;

  SetControlPos(Check_PrivateMsg);
  SetControlPos(check_trade);
  SetControlPos(check_guildjoin);
  SetControlPos(check_HailFellowjoin);
  SetControlPos(A2CheckBox_changeForm);
  SetControlPos(A2CheckBox_yinyue);
  SetControlPos(A2CheckBox_yinxiao);
  SetControlPos(A2CheckBox_ShowSelfName);
  SetControlPos(A2CheckBox_ShowMonster);
  SetControlPos(A2CheckBox_ShowNpc);
  SetControlPos(A2CheckBox_ShowPlayer1);
  SetControlPos(A2CheckBox_ShowItem);
  SetControlPos(A2CheckBox_ShowGuildName);
  SetControlPos(A2CheckBox_ShowDamage);

  SetControlPos(A2ComboBox_fbl);

  Image1.Visible := false;
  SetOtherConfig;

end;

procedure TFrmSound.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TFrmSound.SetOtherConfig;
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  SelectImage, SelectNotImage, EnabledImage: string;
  temping, temping2: TA2Image;
  path: string;
  A2Image: string;
  imgwidth, imgheight: Integer;
  transparent: Boolean;
begin

  try
    node := FUIConfig.Root.NodeByName('Views').FindNode('Sound');
    if node <> nil then
    begin
      max := node.ReadInteger('max', 118);
      min := node.ReadInteger('min', 32);
      minsound := node.ReadInteger('minsound', 8000);
    end;
  except
  end;
end;

procedure TFrmSound.Check_PrivateMsgClick(Sender: TObject);
var
  cSay: TCSay;
  cnt: integer;
begin
  chat_private := Check_PrivateMsg.Checked;

  if chat_private = false then
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@拒绝纸条');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end
  else
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@接收纸条');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end;
  autosave;
end;

procedure TFrmSound.A2CheckBox_changeFormClick(Sender: TObject);
var
  aStr: string;
begin
  inherited;
  if (NATION_VERSION = NATION_TAIWAN) or (NATION_VERSION = NATION_CHINA_1) then
    exit;

  if FullScreen_time + 200 > mmAnsTick then
  begin
    FrmBottom.AddChat('窗口/全屏切换太快。', WinRGB(22, 22, 0), 0);
    exit;
  end;
  FullScreen_time := mmAnsTick;

          //全屏检测系统是否WIN10
  aStr := GetWMIProperty('OperatingSystem', 'Version');
  if pos('10.', aStr) <> 0 then
  begin
    FrmBottom.AddChat('WIN10系统暂不支持全屏游戏。', WinRGB(22, 22, 0), 0);
    exit;
  end;

  FrmM.SaveAndDeleteAllA2Form;
  FrmM.DXDraw.Finalize;
  if doFullScreen in FrmM.DXDraw.Options then
  begin
    FrmM.BorderStyle := bsSingle;
    if not G_Default1024 then
    begin
      FrmM.ClientWidth := fwide;
      FrmM.ClientHeight := fhei;
    end
    else
    begin
      FrmM.ClientWidth := fwide1024;
      FrmM.ClientHeight := fhei1024;
    end;
    FrmM.DXDraw.Options := FrmM.DXDraw.Options - [doFullScreen];

  end
  else
  begin
    FrmM.BorderStyle := bsNone;
    if not G_Default1024 then
    begin
      FrmM.ClientWidth := fwide;
      FrmM.ClientHeight := fhei;
    end
    else
    begin
      FrmM.ClientWidth := fwide1024;
      FrmM.ClientHeight := fhei1024;
    end;
    FrmM.DXDraw.Options := FrmM.DXDraw.Options + [doFullScreen];

  end;
  FrmM.DXDraw.Initialize;
  FrmM.RestoreAndAddAllA2Form;
  if FrmBottom.Visible then
  begin
    SAY_EdChatFrmBottomSetFocus;
  end;
  exit;
end;

procedure TFrmSound.check_tradeClick(Sender: TObject);
var
  cSay: TCSay;
  cnt: integer;
begin

  if check_trade.Checked = false then
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@拒绝交易');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end
  else
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@接受交易');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end;
  autosave;
end;

procedure TFrmSound.loadFromfile(afilenam: string);
var
  i, j, Count: integer;
  temp: TObject;
  str, str1: string;
  ini: TiniFileclass;
begin


 // if FileExists('.\userdata\' + afilenam) = false then exit;
 // ini := TiniFileclass.Create('.\userdata\' + afilenam);

  if FileExists('.\user\' + afilenam + '.dat') = false then
    ini := TiniFileclass.Create('.\user\_defaultFrmSound.dat')
  else
    ini := TiniFileclass.Create('.\user\' + afilenam + '.dat');

  try
    for j := 0 to ComponentCount - 1 do
    begin
      temp := Components[j];
      if temp is TA2CheckBox then
      begin
        TA2CheckBox(temp).Checked := ini.ReadBool('TA2CheckBox', TA2CheckBox(temp).Name, TA2CheckBox(temp).Checked);
      end
      else if temp is TA2Edit then
      begin
        TA2Edit(temp).Text := ini.ReadString('TA2Edit', TA2Edit(temp).Name, TA2Edit(temp).Text);
      end
      else if temp is TA2ListBox then
      begin
        Count := ini.ReadInteger('TA2ListBox', TA2ListBox(temp).Name + '.Count', TA2ListBox(temp).Count);
        if Count > 0 then
        begin
          TA2ListBox(temp).Clear;
          for i := 0 to Count - 1 do
          begin
            str := ini.ReadString('TA2ListBox', format(TA2ListBox(temp).Name + '%d', [i]), str);
            TA2ListBox(temp).AddItem(str);
          end;
        end;
      end
      else if temp is TA2ComboBox then
      begin
        TA2ComboBox(temp).Text := ini.ReadString('TA2ComboBox', TA2ComboBox(temp).Name, TA2ComboBox(temp).Text);
      end;
    end;
    //分辨率
    A2ComboBox_fbl.ItemIndex := ini.ReadInteger('TA2ComboBox', 'fbl', 0);
  finally
    ini.Free;
  end;
end;

procedure TFrmSound.savetofile(afilenam: string);
var
  str: string;
  i, j: integer;
  ini: TiniFileclass;
  temp: TObject;
begin
  if not DirectoryExists('.\user') then
    CreateDir('.\user');
  if afilenam = '' then
    Exit;
  ini := TiniFileclass.Create('.\user\' + afilenam + '.dat');
  try
    for j := 0 to ComponentCount - 1 do
    begin
      temp := Components[j];
      if temp is TA2CheckBox then
      begin
        ini.WriteBool('TA2CheckBox', TA2CheckBox(temp).Name, TA2CheckBox(temp).Checked);
      end
      else if temp is TA2Edit then
      begin
        ini.WriteString('TA2Edit', TA2Edit(temp).Name, TA2Edit(temp).Text);
      end
      else if temp is TA2ListBox then
      begin
        ini.WriteInteger('TA2ListBox', TA2ListBox(temp).Name + '.Count', TA2ListBox(temp).Count);
        for i := 0 to TA2ListBox(temp).Count - 1 do
        begin
          ini.WriteString('TA2ListBox', format(TA2ListBox(temp).Name + '%d', [i]), TA2ListBox(temp).Items[i]);
        end;
      end
      else if temp is TA2ComboBox then
      begin
        //不保存的项目
        if TA2ComboBox(temp).name = 'A2ComboBox_fbl' then Continue;
        ini.WriteString('TA2ComboBox', TA2ComboBox(temp).Name, TA2ComboBox(temp).Text);
      end;
    end;
    //分辨率
    ini.WriteString('TA2ComboBox', 'fbl', IntToStr(A2ComboBox_fbl.ItemIndex));

  finally
    ini.Free;
  end;
end;

procedure TFrmSound.autosave;
begin
  if not FISShow then
    Exit;
  savetofile(CharCenterName + self.Name);
end;

procedure TFrmSound.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  autosave;
  FISShow := False;

end;

procedure TFrmSound.autoload;
begin
  loadFromfile(CharCenterName + self.Name);
end;

procedure TFrmSound.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  autosave;
  FISShow := False;
end;

procedure TFrmSound.InitTgsConfig;
var
  key: Word;
begin
  key := VK_RETURN;
  autoload;
  if (A2ComboBox_fbl.ItemIndex = 1) and (not G_Default1024) then
  begin
    G_Default1024 := not G_Default1024;
    FrmM.changeScreen;
  end;
  if check_trade.Checked then
  begin
   // FrmBottom.sendsay('@接受交易', key);
  end
  else
  begin
    FrmBottom.sendsay('@拒绝交易', key);
  end;

  if check_guildjoin.Checked then
  begin
   // FrmBottom.sendsay('@设定允许加入门派', key);
  end
  else
  begin
    Sleep(1000);
    FrmBottom.sendsay('@设定拒绝加入门派', key);
  end;

  if Check_PrivateMsg.Checked then
  begin
   // FrmBottom.sendsay('@接收纸条', key);
  end
  else
  begin
    Sleep(1000);
    FrmBottom.sendsay('@拒绝纸条', key);
  end;
  chat_duiwu := Check_Team.Checked;
  chat_outcry := Check_Outcry.Checked;
  chat_Guild := Check_Guild.Checked;
  chat_notice := Check_Notice.Checked;
  chat_ally := Check_ALLY.Checked;
  chat_normal := Check_Normal.Checked;
  chat_yinyue := A2CheckBox_yinyue.Checked;
  chat_yinxiao := A2CheckBox_yinyue.Checked;
end;

procedure TFrmSound.check_guildjoinClick(Sender: TObject);
var
  cSay: TCSay;
  cnt: integer;
begin

  if check_guildjoin.Checked = false then
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@拒绝加入门派');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end
  else
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@允许加入门派');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end;
  autosave;
end;

procedure TFrmSound.A2CheckBox_ShowSelfNameClick(Sender: TObject);
begin
  inherited;
  if A2CheckBox_ShowSelfName.Checked then
    A2CheckBox_ShowPlayer1.Checked := True;
  autosave;
end;

procedure TFrmSound.A2CheckBox_ShowMonsterClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmSound.A2CheckBox_ShowNpcClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmSound.A2CheckBox_ShowPlayer1Click(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmSound.A2CheckBox_ShowItemClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmSound.A2CheckBox_ShowGuildNameClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmSound.A2CheckBox_ShowDamageClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmSound.check_HailFellowjoinClick(Sender: TObject);
var
  cSay: TCSay;
  cnt: integer;
begin
  inherited;

  if check_HailFellowjoin.Checked = false then
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@拒绝加为好友');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end
  else
  begin
    cSay.rmsg := CM_SAY;
    SetWordString(cSay.rWordString, '@允许加为好友');
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
  end;
  autosave;
end;

procedure TFrmSound.Check_ALLYClick(Sender: TObject);
begin
  inherited;
  chat_ally := Check_ALLY.Checked;
  autosave;
end;

procedure TFrmSound.A2CheckBox_yinyueClick(Sender: TObject);
var
  v: integer;
begin
  inherited;
  chat_yinyue := A2CheckBox_yinyue.Checked;
  if chat_yinyue then
  begin
    v := A2Button1.Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    if - v = -MINVALUE then
      v := minsound;
    FrmM.SoundManager.Volume := -v;
  end
  else
    FrmM.SoundManager.Volume := -9999;
  autosave;
end;

procedure TFrmSound.A2CheckBox_yinxiaoClick(Sender: TObject);
var
  v: integer;
begin
  inherited;
  chat_yinxiao := A2CheckBox_yinxiao.Checked;
  if chat_yinxiao then
  begin
    v := A2Button2.Left - min;
    v := trunc((v / (max - min)) * MINVALUE);
    v := MINVALUE - v;
    FrmM.SoundManager.VolumeEffect := -v;
  end
  else
    FrmM.SoundManager.VolumeEffect := -9999;
  autosave;

end;


procedure TFrmSound.A2ComboBox_fblChange(Sender: TObject);
var
  a_1024: Boolean;
begin
  inherited;
  autosave;
  a_1024 := False;

  if A2ComboBox_fbl.ItemIndex = 1 then
    a_1024 := true;

  if a_1024 <> G_Default1024 then
  begin
    G_Default1024 := not G_Default1024;
    FrmM.changeScreen;
    if frmMonsterBuffPanel.Visible then
      frmMonsterBuffPanel.SetNewVersionTest;
  end;
 // FrmBottom.AddChat('===' + IntToStr(A2ComboBox_fbl.ItemIndex), ColorSysToDxColor(clYellow), 0);
end;

end.

