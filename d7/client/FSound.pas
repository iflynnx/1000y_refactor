unit FSound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls,
  A2Form;

type
  TFrmSound = class(TForm)
    BtnOutcry: TA2Button;
    BtnGuild: TA2Button;
    BtnNotice: TA2Button;
    BtnNormal: TA2Button;
    Image1: TImage;
    Imgbaseup: TImage;
    ImgEffectup: TImage;
    Imgbasedown: TImage;
    ImgNormalup: TImage;
    ImgGuildup: TImage;
    ImgOutcryup: TImage;
    ImgNoticeup: TImage;
    A2Button1: TA2Button;
    ImgFactionup: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure BtnOutcryClick(Sender: TObject);
    procedure BtnGuildClick(Sender: TObject);
    procedure BtnNoticeClick(Sender: TObject);
    procedure BtnNormalClick(Sender: TObject);
    procedure ImgbaseupMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure ImgbaseupMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure ImgbaseupMouseUp(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure ImgEffectupMouseDown(Sender: TObject; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
    procedure ImgEffectupMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure ImgEffectupMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure A2Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
{
    function  changeBaseVolume : Boolean;
    function  changeEffectVolume : integer;
}
  end;

function  RangeCompute(X : Integer; TagetX :word) : Integer;
function  RangeVolume(X,Y : Integer; TagetX,TagetY :word; volume : Integer) : Integer;


var
  FrmSound: TFrmSound;
  imgtemp : TBitmap;

var
  Boolflag : Boolean;
  Or_baseX : integer;
  Or_sysX : integer;

implementation

uses
   FMain, FBottom;

const
  baseLeft = 25;
  baseRight = 125;


{$R *.DFM}
function RangeCompute(X : Integer; TagetX :Word) : Integer;
begin
   if TagetX < X then begin
      Result := -(ABS(TagetX - X)*500);
   end else begin
      Result := (ABS(TagetX - X)*500);
   end;
end;

function RangeVolume(X,Y : Integer; TagetX,TagetY :word; volume : Integer) : Integer;
begin
   Result := -((ABS(TagetX - X)*400) + (ABS(TagetY - Y)*400)) + volume;
end;

function PosControl(oMin, oMax, rLeft, rRight, ovalue, rvalue :integer): integer;
var
   otemp, rtemp : integer;
begin
//   otemp := (oMax + oMin) - (oMin + oMin);
   otemp := oMax - oMin;
   rtemp := rright - rLeft;
   if ovalue = 0 then begin
      Result := ((rvalue - rLeft) * otemp) div rtemp;
      exit;
   end;
   if rvalue = 0 then begin
      Result := (((ovalue - OMin)* rtemp) div otemp) + rLeft;
      exit;
   end;
   Result := 0;
end;

function VolumeControlPos(Volume: integer): integer;
begin
   if Volume < -4750 then Volume := -4750;
   if Volume > -100 then Volume := -100;

   Result := Volume div 50 + 120;
end;

function GetVolumeValue(img: TImage): integer;
begin
   Result := (img.Left - 120) * 50;
   if Result <= -4750 then Result := -10000;
   if Result >= -100  then Result := 0;
end;

//////////////////// FrmSound //////////////////////////////////////////////////
procedure TFrmSound.FormCreate(Sender: TObject);
begin
   Parent := FrmM;
   Color := clBlack;
  //Author:Steven Date: 2004-10-11 11:21:21
  //Note:SetBounds(0, 14, 148, 160)
   SetBounds(0, 14, 148, 187);

   Boolflag := FALSE; // 사운드 마우스제어 Boolean
   imgtemp := TBitmap.Create;
   imgtemp.Assign (Imgbaseup.Picture.Bitmap);

   ImgBaseUp.Left   := VolumeControlPos(BaseVolume);
   ImgEffectUp.Left := VolumeControlPos(EffectVolume);
{
   Imgbaseup.Left := PosControl(-10000, 0, baseLeft, baseright, BaseVolume, 0)-Imgbaseup.width;
   ImgEffectup.Left := PosControl(-10000, 0, baseLeft, baseright, EffectVolume, 0)-ImgEffectup.Width;
}
   if Imgbaseup.Left <= baseLeft then Imgbaseup.Left := baseLeft;
   if Imgbaseup.Left >= baseRight then Imgbaseup.Left := baseRight-Imgbaseup.width;
   if ImgEffectup.Left <= baseLeft then ImgEffectup.Left := baseLeft;
   if ImgEffectup.Left >= baseRight then ImgEffectup.Left := baseRight-ImgEffectup.Width;
end;

procedure TFrmSound.FormDestroy(Sender: TObject);
begin
   imgtemp.Free;
end;
{
function TFrmSound.ChangeEffectVolume: Integer;
begin
   Result := -(105-ImgEffectup.Left)*100;
   if ImgEffectup.Left >= 110 then begin
      Result := 0;

   end else if ImgEffectup.Left <= 30 then begin
      Result := -10000;
   end;
   EFFECTVOLUME := Result;
end;

function TFrmSound.ChangeBaseVolume : boolean;
begin
   BASEVOLUME := -(105-Imgbaseup.Left)*100;
   if Imgbaseup.Left >= 110 then begin
      BASEVOLUME := 0;

   end else if Imgbaseup.Left <= 30 then begin
      BASEVOLUME := -10000;
   end;
   BaseSound.SetVolume (BASEVOLUME);
   Result := TRUE;
end;
}
procedure TFrmSound.ImgbaseupMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   Boolflag := TRUE;
   Or_baseX := x;
   Imgbaseup.Picture.Assign(Imgbasedown.Picture.Bitmap);
end;

procedure TFrmSound.ImgbaseupMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
   if Boolflag then begin
      Imgbaseup.Left := Imgbaseup.Left - (Or_baseX - X);
      if Imgbaseup.Left < baseLeft then Imgbaseup.left := baseLeft;
      if Imgbaseup.Left+Imgbaseup.Width > baseright then Imgbaseup.Left := baseright - Imgbaseup.width;
      BaseVolume := GetVolumeValue(ImgBaseUp);
      BaseSound.SetVolume (BaseVolume);
//      FrmM.Caption := 'BaseVolume : ' + IntToStr(BaseVolume);
//      ChangeBaseVolume;
   end;
end;

procedure TFrmSound.ImgbaseupMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   Boolflag := FALSE;
   Imgbaseup.Picture.Assign(imgtemp);
   ClientIni.WriteInteger ('SOUND','BASEVOLUME', BASEVOLUME);
end;

procedure TFrmSound.ImgEffectupMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   Boolflag := TRUE;
   Or_baseX := x;
   Imgeffectup.Picture.Assign (Imgbasedown.Picture.Bitmap);
end;

procedure TFrmSound.ImgEffectupMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
   if Boolflag then begin
      ImgEffectup.Left := ImgEffectup.Left - (Or_baseX - X);
      if ImgEffectup.Left < baseLeft then ImgEffectup.left := baseLeft;
      if ImgEffectup.Left+ImgEffectup.Width > baseright then
         ImgEffectup.Left := baseright - ImgEffectup.width;
      EffectVolume := GetVolumeValue(ImgEffectUp);
//      FrmM.Caption := 'EffectVolume : ' + IntToStr(EffectVolume);
//      EFFECTVOLUME := changeEffectVolume;
   end;
end;

procedure TFrmSound.ImgEffectupMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   Boolflag := FALSE;
   ImgEffectup.Picture.Assign(imgtemp);
   ClientIni.WriteInteger ('SOUND','EFFECTVOLUME', EFFECTVOLUME);
end;

/////////////////// OPTION CHAT ////////////////////////////////////////////////
procedure TFrmSound.BtnOutcryClick(Sender: TObject);    // For FBottom
begin // 외치기
   if chat_outcry then begin
      chat_outcry := FALSE;
      BtnOutcry.UpImage := BtnOutcry.DownImage;
   end else begin
      chat_outcry := TRUE;
      BtnOutcry.UpImage := ImgOutcryup.Picture;
   end;
end;
procedure TFrmSound.BtnGuildClick(Sender: TObject);
begin // 길드
   if chat_Guild then begin
      chat_Guild := FALSE;
      BtnGuild.UpImage := BtnGuild.DownImage;
   end else begin
      chat_Guild := TRUE;
      BtnGuild.UpImage := ImgGuildup.Picture;
   end;
end;
procedure TFrmSound.BtnNoticeClick(Sender: TObject);
begin // 공지사항
   if chat_notice then begin
      chat_notice := FALSE;
      BtnNotice.UpImage := BtnNotice.DownImage;
   end else begin
      chat_notice := TRUE;
      BtnNotice.UpImage := ImgNoticeup.Picture;
   end;
end;
procedure TFrmSound.BtnNormalClick(Sender: TObject);
begin // 일반 유저대화
   if chat_normal then begin
      chat_normal := FALSE;
      BtnNormal.UpImage := BtnNormal.DownImage;
   end else begin
      chat_normal := TRUE;
      BtnNormal.UpImage := ImgNormalup.Picture;
   end;
end;

procedure TFrmSound.A2Button1Click(Sender: TObject);
begin
   if chat_faction then begin
      chat_faction := False;
      with TA2Button(Sender) do
        UpImage := DownImage;
   end else begin
      chat_faction := True;
      TA2Button(Sender).UpImage := ImgFactionup.Picture;
   end;
end;

end.
