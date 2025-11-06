unit FMiniMap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, A2Form, CharCls, clmap, A2Img, Autil32, deftype;

const
   MapImgWidth = 460;
   MapImgHeight = 345;

type
  TFrmMiniMap = class(TForm)
    A2Form: TA2Form;
    CenterIDLabel: TA2ILabel;
    SearchIDLabel: TA2ILabel;
    A2ILabel1: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2ILabel4: TA2ILabel;
    A2ILabel5: TA2ILabel;
    A2ILabel6: TA2ILabel;
    A2ILabel7: TA2ILabel;
    A2ILabel8: TA2ILabel;
    A2ILabel9: TA2ILabel;
    A2ILabel10: TA2ILabel;
    A2ILabel11: TA2ILabel;
    A2ILabel12: TA2ILabel;
    A2ILabel13: TA2ILabel;
    A2ILabel14: TA2ILabel;
    A2ILabel15: TA2ILabel;
    A2ILabel16: TA2ILabel;
    A2ILabel17: TA2ILabel;
    A2ILabel18: TA2ILabel;
    A2ILabel19: TA2ILabel;
    A2ILabel20: TA2ILabel;
    A2ILabel21: TA2ILabel;
    A2ILabel22: TA2ILabel;
    A2ILabel23: TA2ILabel;
    A2ILabel24: TA2ILabel;
    A2ILabel25: TA2ILabel;
    A2ILabel26: TA2ILabel;
    A2ILabel27: TA2ILabel;
    A2ILabel28: TA2ILabel;
    A2ILabel29: TA2ILabel;
    A2ILabel30: TA2ILabel;
    A2ILabel31: TA2ILabel;
    A2ILabel32: TA2ILabel;
    A2ILabel33: TA2ILabel;
    A2ILabel34: TA2ILabel;
    A2ILabel35: TA2ILabel;
    A2ILabel36: TA2ILabel;
    A2ILabel37: TA2ILabel;
    A2ILabel38: TA2ILabel;
    A2ILabel39: TA2ILabel;
    A2ILabel40: TA2ILabel;
    A2ILabel41: TA2ILabel;
    A2ILabel42: TA2ILabel;
    A2ILabel43: TA2ILabel;
    A2ILabel44: TA2ILabel;
    A2ILabel45: TA2ILabel;
    A2ILabel46: TA2ILabel;
    A2ILabel47: TA2ILabel;
    A2ILabel48: TA2ILabel;
    A2ILabel49: TA2ILabel;
    A2ILabel50: TA2ILabel;
    A2ILabel51: TA2ILabel;
    A2ILabel52: TA2ILabel;
    A2ILabel53: TA2ILabel;
    A2ILabel54: TA2ILabel;
    A2ILabel55: TA2ILabel;
    A2ILabel56: TA2ILabel;
    A2ILabel57: TA2ILabel;
    A2ILabel58: TA2ILabel;
    A2ILabel59: TA2ILabel;
    A2ILabel60: TA2ILabel;
    A2ILabel61: TA2ILabel;
    A2ILabel62: TA2ILabel;
    A2ILabel63: TA2ILabel;
    A2ILabel64: TA2ILabel;
    A2ILabel65: TA2ILabel;
    A2ILabel66: TA2ILabel;
    A2ILabel67: TA2ILabel;
    A2ILabel68: TA2ILabel;
    A2ILabel69: TA2ILabel;
    A2ILabel70: TA2ILabel;
    A2ILabel71: TA2ILabel;
    A2ILabel72: TA2ILabel;
    A2ILabel73: TA2ILabel;
    A2ILabel74: TA2ILabel;
    A2ILabel75: TA2ILabel;
    A2ILabel76: TA2ILabel;
    A2ILabel77: TA2ILabel;
    A2ILabel78: TA2ILabel;
    A2ILabel79: TA2ILabel;
    A2ILabel80: TA2ILabel;
    A2ILabel81: TA2ILabel;
    A2ILabel82: TA2ILabel;
    A2ILabel83: TA2ILabel;
    A2ILabel84: TA2ILabel;
    A2ILabel85: TA2ILabel;
    A2ILabel86: TA2ILabel;
    A2ILabel87: TA2ILabel;
    A2ILabel88: TA2ILabel;
    A2ILabel89: TA2ILabel;
    A2ILabel90: TA2ILabel;
    A2ILabel91: TA2ILabel;
    A2ILabel92: TA2ILabel;
    A2ILabel93: TA2ILabel;
    A2ILabel94: TA2ILabel;
    A2ILabel95: TA2ILabel;
    A2ILabel96: TA2ILabel;
    A2ILabel97: TA2ILabel;
    A2ILabel98: TA2ILabel;
    A2ILabel99: TA2ILabel;
    A2ILabel0: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2FormAdxPaintStart(aAnsImage: TA2Image);
  private
  public
     NPCLabel : array [0..100] of TA2ILabel;
     FNPCCount : integer;
     NPCImage : TA2Image;
//     NPCBackImage : TA2Image;

     CenterImage : TA2Image;

     MapImage: TA2Image;
     bHaveMapImage: Boolean;

     procedure SetCenterID;
     procedure SetPosition;
     procedure MessageProcess (var code: TWordComData);
     procedure NPCClear;
     function GetImagePos (ax, ay: integer): TPoint;
  end;

var
   FrmMiniMap: TFrmMiniMap;
   bTestMove: Boolean = False;
   strAutoMove: string = '';

implementation

uses
   FMain, FAttrib, FBottom;
{$R *.DFM}
procedure TFrmMiniMap.NPCClear;
var i : integer;
begin
   for i := 0 to 100 -1 do begin
      if NPCLabel[i] <> nil then begin
         NPCLabel[i].Visible := FALSE;
         NPCLabel[i].Left := -4;
         NPCLabel[i].Top := -4;
         NPCLabel[i].Hint := '';
      end;
   end;
end;

function GetTextImagePos (ax, ay: integer; aText: string): TPoint;
var
   i : integer;
begin
   i := ATextWidth (aText) div 2;
   Result.x := ax - i;
   i := ATextHeight (aText);
   Result.y := ay - i -1;
end;

function TFrmMiniMap.GetImagePos (ax, ay: integer): TPoint;
begin
{
   Result.x := ( (MapImgWidth * ax) div Map.GetMapWidth) - 2;
   Result.y := ( (MapImgHeight * ay) div Map.GetMapHeight) -2;
}
   Result.x := ( (MapImage.Width * ax) div Map.GetMapWidth) - 2;
   if MapImage.Height > MapImgHeight then
      Result.y := ( (MapImgHeight * ay) div Map.GetMapHeight) -2
   else
      Result.y := ( (MapImage.Height * ay) div Map.GetMapHeight) -2;
end;

procedure TFrmMiniMap.MessageProcess (var code: TWordComData);
var
   PSTSMiniMap : PTSMiniMap;
   name, str, rdstr : string;
   Tp : TPoint;
   Color: Integer;
   tmpImage: TA2Image;
begin
   PSTSMiniMap := @Code.data;

   // Map Loading
   str := Map.GetMapName;
   str := ChangeFileExt(str, '.bmp');

   if FileExists(str) then begin
      MapImage.LoadFromFile(str);
      bHaveMapImage := True;
   end else begin
      MapImage.Resize(MapImgWidth, MapImgHeight);
      MapImage.Clear(31);
      bHaveMapImage := False;
   end;
{
   if FileExists(str) then
      A2Form.SetBackImageFile (str)
   else // Map의 minimap bmp파일이 없으면 검은색으로...
      A2Form.SetBackImageFile ('');
}
   str := GetWordString(PSTSMiniMap.rWordString);
//   NPCBackImage.Clear (0);
   FNPCCount := 0;
   NPCClear;
   while TRUE do begin     // ex 주모:300:300,시약상:300:200,....
      str := GetValidStr3 (str, rdstr, ':');
      name := rdstr;
      str := GetValidStr3 (str, rdstr, ':');
      Tp.x := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ':');
      Tp.y := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ',');
      Color := _StrToInt (rdstr);

      Tp := GetImagePos(Tp.x, Tp.y);

      //NPCImage.Clear (Color);
      NPCLabel[FNPCCount].A2Image.Clear(Color);
      NPCLabel[FNPCCount].Hint := name;
      NPCLabel[FNPCCount].Left := Tp.x;
      NPCLabel[FNPCCount].Top := Tp.y;
      NPCLabel[FNPCCount].Visible := TRUE;
{
      NPCImage.Clear (WinRGB(1,1,1));
      NPCBackImage.DrawImage (NPCImage, Tp.x +1, Tp.y +1, FALSE);
      NPCBackImage.DrawImage (NPCImage, Tp.x, Tp.y, FALSE);
      Tp := GetTextImagePos (Tp.x, Tp.y, name);
      ATextOut (NPCBackImage, Tp.x +1, Tp.y +1, WinRGB (1, 1, 1), name);
      ATextOut (NPCBackImage, Tp.x, Tp.y, WinRGB(0,255,0), name);
}
      if str = '' then begin
         if bHaveMapImage then begin
            SetPosition;
         end;
         Self.Visible := TRUE;
         exit;
      end;

      inc (FNPCCount);
      if FNPCCount > 100 then exit;
   end;
end;

procedure TFrmMiniMap.SetCenterID;
var
   x, y : integer;
begin
{
   x := (MapImgWidth * CharPosX) div Map.GetMapWidth;
   y := (MapImgHeight * CharPosY) div Map.GetMapHeight;
}
   x := (MapImage.Width * CharPosX) div Map.GetMapWidth;
   if MapImage.Height > MapImgHeight then
      y := (MapImgHeight * CharPosY) div Map.GetMapHeight
   else
      y := (MapImage.Height * CharPosY) div Map.GetMapHeight;
   CenterIdLabel.Hint := CharCenterName;

   CenterIdLabel.Left := x - (CenterIdLabel.Width div 2);
   CenterIdLabel.Top := y - (CenterIdLabel.Height div 2);
end;

procedure TFrmMiniMap.FormCreate (Sender: TObject);
var i : integer;
begin
   FrmM.AddA2Form (Self, A2Form);
   Top := 0;
   Left := 0;
   CenterImage := TA2Image.Create (4,4,0,0);
   CenterImage.Clear (255);
   CenterIdLabel.A2Image := CenterImage;
   for i := 0 to 100 -1 do begin
      NPCLabel[i] := TA2ILabel(FindComponent (format('A2ILabel%d',[i])) );
      NPCLabel[i].A2Image := TA2Image.Create (4, 4, 0, 0);
   end;
   NPCClear;
   FNPCCount := 0;

   NPCImage := TA2Image.Create (4, 4, 0, 0);
   MapImage := TA2Image.Create(4, 4, 0, 0);
end;

procedure TFrmMiniMap.FormDestroy (Sender: TObject);
begin
   FNPCCount := 0;
   CenterImage.Free;
   NPCImage.Free;
   MapImage.Free;
end;

procedure TFrmMiniMap.FormShow(Sender: TObject);
begin
   SetPosition;
end;

procedure TFrmMiniMap.SetPosition;
begin
   Width := MapImage.Width;
   Height := MapImage.Height;
   if FrmAttrib.Visible then begin
      Top := ((480 - FrmBottom.Height) div 2) - (Height div 2);
      Left := ((640 - FrmAttrib.Width) div 2) - (Width div 2);
   end else begin
      Top := ((480 - FrmBottom.Height) div 2) - (Height div 2);
      Left := (640 div 2) - (Width div 2);
   end;
end;

procedure TFrmMiniMap.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   xx, yy: integer;
begin
   if bTestMove then begin // Map Test용...
      xx := (X * Map.GetMapWidth) div Width;
      yy := (Y * Map.GetMapHeight) div Height;
      frmBottom.EdChat.Text := Format('@盧땡 %s %d %d', [strAutoMove, xx, yy]);
   end;
end;

procedure TFrmMiniMap.A2FormAdxPaintStart(aAnsImage: TA2Image);
begin
   if bHaveMapImage then
      aAnsImage.DrawImage(MapImage, 0, 0, True)
   else begin
      aAnsImage.DrawImageKeyColor(MapImage, 0, 0, 31, @DECRGBdarkentbl);
   end;
end;

end.
