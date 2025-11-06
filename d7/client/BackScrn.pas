unit BackScrn;

interface

uses
  Windows, Classes, SysUtils, Graphics, uAnsTick,
  Bmputil, AUtil32, A2Img, DefType, cltype, uEffectCls, uXDibA;

type
  TRainData = record
     rsx, rsy: integer;
     rx, ry: integer;
     rimage: integer;
     rOverray : integer;
     rspeed : integer;
     rXpos : integer;
  end;
  PTRainData = ^TRainData;

  TBackScreen = class
  private
   FRainning: Boolean;
   RainImageLib : TA2ImageLib;
   SnowImageLib : TA2ImageLib;

   RainList : TList;
   RainSpeed, RainCount, RainOverray: integer;
   RainTick : integer;
   Raintype : byte;

   nEarthquakeTick: integer;
   nEarthquakeWidth: integer;
  public
   LightMap : integer;
   boDark : Boolean;
   Cx, Cy : Integer;
   SWidth, SHeight: integer;
   Back : TA2Image;
	constructor Create;
  	destructor Destroy; override;
   procedure  Clear;
   procedure  SetCenter ( x, y: integer);

   procedure DrawImage (AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
   procedure DrawImageGreenConvert (AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word);
   procedure DrawImageKeyColor (AnsImage: TA2Image; x, y: Integer);
   procedure DrawImageOveray (AnsImage: TA2Image; x, y: Integer; Weight: integer);
   procedure DrawEffect (xDib: TXDib; x, y: integer; eTable: TColorTable5x5);
   procedure DrawDib (xDib: TXDib; x, y: integer; aShadow: Boolean);

   procedure DrawRefractive (AnsImage: TA2Image; x, y, Refracrange, overValue: Integer); // ankudo 010118

   procedure DrawImageAdd (AnsImage: TA2Image; x, y: Integer);

   procedure  DrawStructed ( x, y, ImgHeight ,aper: integer);
   procedure  DrawName (Canvas:TCanvas; x, y: integer; abubble: string; aColor:Integer);
   procedure  DrawCanvas(Canvas: TCanvas; X, Y: Integer);

   function   GetBubble (var BubbleList: TStringList; SayString: string): Boolean;
   procedure  DrawBubble (Canvas:TCanvas; x, y: integer; abubbleList: Tstringlist; wCol: word = 32767);

   // add by minds 021127 상점팻말
   procedure  DrawStoreSign(const aStr: string; x, y: Integer);

   procedure  UpdateRain;
   procedure  CenterchangeIDPos(x, y: integer);
   procedure  SetRainState (aRainning: Boolean; aspeed, aCount, aover, aTick: integer; araintype: byte);
//   procedure  ConvertDark;
   procedure  AddEarthquake(aTick, aWidth: integer);
    procedure changeBack();
   property   Rainning : Boolean read FRainning;
  end;


var
   BackScreen : TBackScreen;

   snowxPosTable : array [0..40-1] of integer = (
                   0, 0,  0,  0,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4,  4,  4,  4,  4,  4, 4,
                   0, 0, -0, -0, -1, -1, -1, -1, -2, -2, -3, -3, -3, -4, -4, -4, -4, -4, -4, -4
                   );
   snowidx : byte;
{
const
  LIGHTMAP_WIDTH = 64;

type
  TD2LightData = record
    rx, ry : integer;
    rbright : integer;
    rWide : integer;
    rcolor : DWORD;
  end;
  PTD2LightData = ^TD2LightData;

  TLigthData = array [0..0] of byte;
  PTLigthData = ^TLigthData;

  TD2LightMapData = record
//    rTex: PTLigthData;
    rTex: pbyte;
    rWidth, rHeight: integer;
    rLightList : TList;
  end;
  PTD2LightMapData = ^TD2LightMapData;

function  D2TexCreateLightMap (aWidth, aHeight: integer): integer;
procedure D2TexFreeLightMap (aHandle: integer);

procedure D2TexBeginLight (aHandle: integer);
procedure D2TexAddLight (aHandle: integer; ax, ay: integer; abright, awide: byte; acolor: DWORD);
procedure D2TexEndLight (aHandle: integer);

procedure D2TexDrawLight (aHandle, awidth, aheight: integer; pBits: pointer);

var
   AlphaData : array [0..255,0..255] of byte;
   AlphaWPoint : array [0..1024-1] of Word;
   AlphaHPoint : array [0..768-1] of Word;
   AlphaPosData : array [-1024..1024,-1024..1024] of integer;
}
implementation

uses clmap, Charcls, AtzCls, FMain;

{$O+}
{
const
   SIZERATE = 4;

function  D2TexCreateLightMap (aWidth, aHeight: integer): integer;
var p : PTD2LightMapData;
begin
   Result := 0;
   if aWidth mod SIZERATE <> 0 then exit;
   if aHeight mod SIZERATE <> 0 then exit;

   new (p);
   Result := 0;
   GetMem (p^.rTex, aWidth div SIZERATE * aHeight div SIZERATE);
   p^.rLightList := TList.Create;
   p^.rWidth := aWidth;
   p^.rHeight := aHeight;
   Result := integer (p);
end;

procedure D2TexFreeLightMap (aHandle: integer);
begin
   if aHandle = 0 then exit;
   Freemem (PTD2LightMapData (aHandle)^.rTex);
   dispose (PTD2LightMapData (aHandle));
end;

procedure D2TexBeginLight (aHandle: integer);
var
   p : PTD2LightMapData;
begin
   if aHandle = 0 then exit;
   p := PTD2LightMapData (aHandle);
   while TRUE do begin
      if p^.rLightList.Count = 0 then break;
      dispose (p^.rLightList.Items[0]);
      p^.rLightList.Delete (0);
   end;
end;

procedure D2TexAddLight (aHandle: integer; ax, ay: integer; abright, awide: byte; acolor: DWORD);
var p : PTD2LightData;
begin
   if aHandle = 0 then exit;
   new (p);
   p^.rx := ax * (PTD2LightMapData (aHandle)^.rWidth div SIZERATE) div PTD2LightMapData (aHandle)^.rWidth;
   p^.ry := ay * (PTD2LightMapData (aHandle)^.rHeight div SIZERATE) div PTD2LightMapData (aHandle)^.rHeight;
   p^.rbright := abright;
   p^.rWide := awide;
   p^.rcolor := acolor;
   PTD2LightMapData (aHandle)^.rLightList.Add (p);
end;

function  SLength (xlen, ylen: integer): integer;
begin
   Result := round ( Sqrt ( (xlen * xlen) + (ylen * ylen) ) );
end;

procedure D2TexEndLight (aHandle: integer);
var
   i, j, k, brighten, darken, temp: integer;

   p : PTD2LightMapData;
   pl : PTD2LightData;
   pDestBit : pbyte;
begin
   if aHandle = 0 then exit;
   p := PTD2LightMapData (aHandle);

   pDestBit := p^.rTex;

   for j := 0 to (p^.rHeight div SIZERATE) -1 do begin
      for i := 0 to (p^.rWidth div SIZERATE) -1 do begin

         brighten := 20;

         for k := 0 to p^.rLightList.Count -1 do begin
            pl := p^.rLightList[k];

            temp := Slength (i - pl^.rx, j - pl^.ry);
            if temp > pl^.rWide then continue;

            temp := (pl^.rWide - temp) * 255 div pl^.rWide;// wide: temp = 255 : x
            if brighten < temp then brighten := temp;
         end;
         if brighten > 255 then brighten := 255;
         pDestBit^ := brighten;
         inc (pDestBit);
      end;
   end;
end;

procedure D2TexDrawLight (aHandle, awidth, aheight: integer; pBits: pointer);
var
   r, g, b: word;
   i, j, jj, ii: integer;
   p : PTD2LightMapData;
   pw, pdest : pword;
   pb, psour : pbyte;
   tmp : Word;
   x, y : integer;
begin
   if aHandle = 0 then exit;
   p := PTD2LightMapData (aHandle);
{
   pw := pBits;
   for j := 0 to aHeight -1 do begin
      pdest := pw;
      y := AlphaHPoint[j]; // 58 F before 45;   //      y := LIGHTMAP_WIDTH * j div p^.rHeight;
      for i := 0 to aWidth -1 do begin

          WinVRGB (pdest^, r, g, b);
         x := AlphaWPoint[i]; // 58 F before 45; //         x := LIGHTMAP_WIDTH * i div p^.rWidth;

         tmp := p^.rTex[x + y* p^.rWidth]; // 4F uses

         r := AlphaData[r,tmp]; // 45 F before 24
         g := AlphaData[g,tmp];    // 45 F
         b := AlphaData[b,tmp]; // 45 F

         pdest^ := WinRGB (r, g, b);

         inc (psour);
         inc (pdest);
      end;

      inc (pw, aWidth);
   end;


   pw := pBits;
   pb := p^.rTex;
   for j := 0 to (p^.rHeight div SIZERATE) -1 do begin
      psour := pb;

      for jj := 0 to SIZERATE-1 do begin
         pdest := pw;
         for i := 0 to (p^.rWidth div SIZERATE) -1 do begin
            for ii := 0 to SIZERATE-1 do begin
               WinVRGB (pdest^, r, g, b);
               r := AlphaData [r, psour^];
               g := AlphaData [g, psour^];
               b := AlphaData [b, psour^];
               pdest^ := WinRGB (r, g, b);
               inc (pdest);
            end;
            inc (psour);
         end;
         inc (pw, aWidth);
      end;

      inc (pb, p^.rWidth div SIZERATE);
   end;

end;
}

/////////////////////////////////
//          TBackScreen
/////////////////////////////////

constructor TBackScreen.Create;
begin
{
   LightMap := D2TexCreateLightMap (640, 360);
   boDark := False;
}
   RainImageLib := TA2ImageLib.Create;
   RainImageLib.LoadFromFile ('.\ect\rain.atz');

   SnowImageLib := TA2ImageLib.Create;
   SnowImageLib.LoadFromFile ('.\ect\snow.atz');

   snowidx := 0;
   RainList := TList.Create;
   Raintype := RAINTYPE_RAIN;


  { Back := TA2Image.Create ( 1024, 768, 0, 0);
//   Back := TA2Image.Create ( 640, 363, 0, 0);
//   Back := TA2Image.Create ( 640-192, 363, 0, 0);
   SWidth := Back.Width-192;
   SHeight:= 768-117;}

    if G_Default800 then
  begin
    Back := TA2Image.Create(fwide800, fheight600, 0, 0);
    SWidth := fwide800;
    SHeight := fheight600 - 117;
  end
  else
  begin
    Back := TA2Image.Create(fwide, fhei, 0, 0);
    SWidth := fwide;
    SHeight := fhei - 117;
  end;


   Cx := SWidth div 2; Cy := SHeight div 2;

   FRainning := FALSE;
   RainSpeed := 15;
   RainCount := 200;
   RainOverray := 50;

   nEarthquakeTick := 0;
   nEarthquakeWidth := 4;
end;

destructor TBackScreen.Destroy;
var i: integer;
begin
   for i := 0 to RainList.Count -1 do dispose (RainList[i]);
   RainList.Free;
   RainImageLib.Free;
   SnowImageLib.Free;

   Back.free;
{   D2TexFreeLightMap (LightMap);}
   inherited destroy;
end;

procedure TBackScreen.DrawCanvas(Canvas: TCanvas; X, Y: Integer);
begin
   if Back = nil then exit;
{
   if boDark then begin
      D2TexBeginLight (LightMap);
      D2TexAddLight (LightMap, 320, 363 div 2, 120, 130, $FFFFFF);
   //   D2TexAddLight (LightMap, 50, 50, 20, 20, $FFFFFF);
      D2TexEndLight (LightMap);
      D2TexDrawLight (LightMap, Back.Width, Back.Height, Back.Bits); // 거의 다 이곳에서
   end;
}
   A2DrawImage(Canvas, 0, 0, Back);
end;

procedure  TBackScreen.SetCenter ( x, y: integer);
begin
   Cx := x; Cy := y;
   if nEarthquakeTick > mmAnsTick then
      Cx := x + Random(nEarthquakeWidth*2) - nEarthquakeWidth;
end;

procedure  TBackScreen.DrawStructed ( x, y, ImgHeight ,aper: integer);
var
   xx, yy: integer;
begin
   xx := SWidth div 2 + x-Cx - 10;
//   yy := SHeight div 2 + y-Cy - 36;
   yy := SHeight div 2 + y-Cy - ImgHeight;

   Back.hLine (xx, yy  , 20, WinRGB (5,5,5));
   Back.hLine (xx, yy+1, 20, WinRGB (5,5,5));
   Back.hLine (xx, yy+1, 20, WinRGB (5,5,5));

   Back.hLine (xx, yy  , aper div 5, WinRGB (22,5,5));
   Back.hLine (xx, yy+1, aper div 5, WinRGB (22,5,5));
   Back.hLine (xx, yy+1, aper div 5, WinRGB (22,5,5));
end;

procedure  TBackScreen.DrawImageGreenConvert (AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word);
var
   maxX, maxY : integer;
begin
{
   if Ansimage <> nil then
      Back.DrawImageGreenConvert (AnsImage, SWidth div 2 + x-Cx+AnsImage.px, SHeight div 2 + y-Cy+AnsImage.py, acol, defaultadd);
}
   if Ansimage <> nil then begin
      maxX := SWidth div 2 + x-Cx+AnsImage.px;
      maxY := SHeight div 2 + y-Cy+AnsImage.py;
      if (maxX > SWidth) and (maxY > SHeight) then exit;
      if (maxX < -AnsImage.Width) and (maxY < -AnsImage.Height) then exit;
      Back.DrawImageGreenConvert (AnsImage, maxX, maxY, acol, defaultadd);
   end;
end;

procedure TBackScreen.DrawImageKeyColor (AnsImage: TA2Image; x, y: Integer);
var
   maxX, maxY : integer;
begin
{
   if Ansimage <> nil then
      Back.DrawImageKeyColor ( AnsImage, SWidth div 2 + x-Cx+AnsImage.px, SHeight div 2 + y-Cy+AnsImage.py, 31, @Darkentbl);
}
   if Ansimage <> nil then begin
      maxX := SWidth div 2 + x-Cx+Ansimage.px;
      maxY := SHeight div 2 + y-Cy+Ansimage.py;
      if (maxX > SWidth) and (maxY > SHeight) then exit;
      if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
      Back.DrawImageKeyColor ( Ansimage, maxX, maxY, 31, @Darkentbl);
   end;
end;

procedure TBackScreen.DrawRefractive (AnsImage: TA2Image; x, y, Refracrange, overValue: Integer); // ankudo 010118
var
   maxX, maxY : integer;
begin
{
   if Ansimage <> nil then
      Back.DrawRefractive ( AnsImage, SWidth div 2 + x-Cx+AnsImage.px, SHeight div 2 + y-Cy+AnsImage.py, Refracrange, overValue);
}
   if Ansimage <> nil then begin
      maxX := SWidth div 2 + x-Cx+Ansimage.px;
      maxY := SHeight div 2 + y-Cy+Ansimage.py;
      if (maxX > SWidth) and (maxY > SHeight) then exit;
      if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
      Back.DrawRefractive ( Ansimage, maxX, maxY, Refracrange, overValue);
   end;
end;

procedure TBackScreen.DrawImage (AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
var
   maxX, maxY : integer;
begin
{
   if Ansimage <> nil then
      Back.DrawImage ( AnsImage, SWidth div 2 + x-Cx+AnsImage.px, SHeight div 2 + y-Cy+AnsImage.py, aTrans);
}
   if Ansimage <> nil then begin
      maxX := SWidth div 2 + x-Cx+Ansimage.px;
      maxY := SHeight div 2 + y-Cy+Ansimage.py;
      if (maxX > SWidth) and (maxY > SHeight) then exit;
      if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
      Back.DrawImage ( Ansimage, maxX, maxY, aTrans);
   end;
end;

procedure TBackScreen.DrawImageOveray (AnsImage: TA2Image; x, y: Integer; Weight: integer);
var
   maxX, maxY : integer;
begin
{
   if Ansimage <> nil then
      Back.DrawImageOveray ( AnsImage, SWidth div 2 + x-Cx+AnsImage.px, SHeight div 2 + y-Cy+AnsImage.py, weight);
}
   if Ansimage <> nil then begin
      maxX := SWidth div 2 + x-Cx+Ansimage.px;
      maxY := SHeight div 2 + y-Cy+Ansimage.py;
      if (maxX > SWidth) and (maxY > SHeight) then exit;
      if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
      Back.DrawImageOveray ( Ansimage, maxX, maxY, weight);
   end;
end;

procedure TBackScreen.DrawEffect (xDib: TXDib; x, y: integer; eTable: TColorTable5x5);
var
   maxX, maxY : integer;
begin
   if xDib <> nil then begin
      maxX := SWidth div 2 + x-Cx;
      maxY := SHeight div 2 + y-Cy;
      if (maxX > SWidth) and (maxY > SHeight) then exit;
      if (maxX < -xDib.Width) and (maxY < -xDib.Height) then exit;

      Back.DrawEffect(xDib, maxX, maxY, eTable);
   end;
end;

procedure TBackScreen.DrawDib (xDib: TXDib; x, y: integer; aShadow: Boolean);
var
   maxX, maxY : integer;
begin
   if xDib <> nil then begin
      maxX := SWidth div 2 + x-Cx;
      maxY := SHeight div 2 + y-Cy;
      if (maxX > SWidth) and (maxY > SHeight) then exit;
      if (maxX < -xDib.Width) and (maxY < -xDib.Height) then exit;

      Back.DrawDib(xDib, maxX, maxY, aShadow);
   end;
end;

procedure TBackScreen.DrawImageAdd (AnsImage: TA2Image; x, y: Integer);
begin
   if Ansimage <> nil then
      Back.DrawImageAdd ( AnsImage, SWidth div 2 + x-Cx+AnsImage.px, SHeight div 2 + y-Cy+AnsImage.py);
end;

procedure  TBackScreen.Clear;
begin
   Back.Clear (0);
end;

procedure  TBackScreen.DrawName (Canvas:TCanvas; x, y: integer; abubble: string; aColor:Integer);
var
   str, aname: string;
   xx, yy, len: integer;
begin
   str := abubble;
   str := GetValidStr3(str, aname, ',');

   len :=ATextWidth (aname);
   xx := SWidth div 2 + x-Cx- len div 2;
   yy := SHeight div 2 + y-Cy-16;

   ATextOut (Back, xx+1, yy+1, WinRGB (3, 3, 3), aname);
   ATextOut (Back, xx, yy, aColor, aname);

   str := GetValidStr3(str, aname, ',');

   if aname <> '' then begin
      len :=ATextWidth (aname);
      xx := SWidth div 2 + x-Cx- len div 2;
      yy := SHeight div 2 + y-Cy-16-16;

      ATextOut (Back, xx+1, yy+1, WinRGB (2, 2, 2), aname);

      ATextOut (Back, xx, yy, WinRGB (31, 31, 31), aname);
   end;
end;


function TBackScreen.GetBubble (var BubbleList: TStringList; SayString: string): Boolean;
   function GetHanString (var str: string; n : integer) : string;
   var
      i : integer;
      hanflag : Boolean;
   begin
      hanflag := FALSE;
      Result := '';
      for i := 1 to n do begin
         if hanflag then begin
            Result := Result + str[i];
            hanflag := FALSE;
         end else begin
            if byte (str[i]) > 127 then hanflag := TRUE;
            Result := Result + str[i];
         end;
      end;
      if hanflag then Result := Result + str[n+1];
      str := Copy (str, Length(Result)+1, Length(str)-Length(Result));
   end;
var
   i: integer;
   Can : TCanvas;
   str, rdstr : string;
begin
   BubbleList.Clear;
   Can := A2GetCanvas;

   for i := 0 to 10 do begin
      str := '';
      while TRUE do begin
         SayString := GetValidStr3 (SayString, rdstr, ' ');
         str := str + rdstr;
         str := str + ' ';

         if Can.TextWidth (str) > 20*8 then begin
            rdstr := str;
            str := GetHanString (rdstr, 20);
            SayString := rdstr + SayString;
            break;
         end;
         if SayString = '' then break;

         if Can.TextWidth (str) > 80 then break;
      end;
      BubbleList.Add (str);
      if sayString = '' then break;
   end;
   Result := TRUE;
end;

const
   XDrawBubbleMargin = 8;
   YDrawBubbleMargin = 6;

procedure  TBackScreen.DrawBubble (Canvas:TCanvas; x, y: integer; abubbleList: TStringList; wCol: Word);
var
   i, imgX, imgY, xx, yy : integer;
   FontBackImg : TA2Image;
begin
   GetMaxTextWH (imgX,imgY,abubbleList);
   imgY := (imgY*abubbleList.Count)+(abubbleList.Count-1);

   FontBackImg := TA2Image.Create (imgX+XDrawBubbleMargin,imgY+YDrawBubbleMargin,0,0);
   FontBackimg.Clear (31);
   xx := XDrawBubbleMargin div 2+3; yy := YDrawBubbleMargin div 2;
   for i := 0 to aBubbleList.Count -1 do begin
      ATextOut (FontBackimg, xx+1, yy+1, WinRGB (3, 3, 3), abubblelist[i]);
      inc (yy, imgY div aBubbleList.Count+1);
   end;
   xx := XDrawBubbleMargin div 2+3; yy := YDrawBubbleMargin div 2;
   for i := 0 to aBubbleList.Count -1 do begin
      ATextOut (FontBackimg, xx, yy, wCol{WinRGB (31, 31, 31)}, abubblelist[i]);
      inc (yy, imgY div aBubbleList.Count+1);
   end;
   xx := (SWidth div 2 + x - Cx)-((imgX+XDrawBubbleMargin) div 2);
   yy := (SHeight div 2) + y - Cy - 36 - (imgY+YDrawBubbleMargin);

   back.DrawImageKeyColor (FontBackimg, xx, yy, 31, @bubbletbl);
   FontBackImg.Free;
end;
{ 바탕없는것 예전거
procedure  TBackScreen.DrawBubble (Canvas:TCanvas;  x, y: integer; abubbleList: TStringList);
var
   i, len, xx, yy, n : integer;
begin
   len := 0;
   for i := 0 to aBubbleList.Count -1 do begin
      n := ATextHeight (aBubbleList[i]);
      if n > len then len := n;
   end;
   if len = 0 then exit;
   len := len + 2;

   for i := 0 to aBubbleList.Count -1 do begin
      xx := SWidth div 2 + x-Cx - 40 + 1;
      yy := SHeight div 2 + y-Cy - aBubbleList.Count * len + i *len-36+1;
      ATextOut (Back, xx, yy, WinRGB (3, 3, 3), abubblelist[i]);
   end;

   for i := 0 to aBubbleList.Count -1 do begin
      xx := SWidth div 2 + x-Cx - 40;
      yy := SHeight div 2 + y-Cy - aBubbleList.Count * len + i *len - 36;
      ATextOut (Back, xx, yy, WinRGB (31, 31, 31), abubblelist[i]);
   end;
end;
}

// add by minds 021127 상점푯말
procedure TBackScreen.DrawStoreSign(const aStr: string; x, y: Integer);
var
   maxX, maxY: integer;
   SignImage: TA2Image;
   tmpstr, str: string;
begin
   SignImage := EtcViewClass[11];
   maxX := SWidth div 2 + x - Cx + SignImage.px;
   maxY := SHeight div 2 + y - Cy + SignImage.py;

   Back.DrawImage(SignImage, maxX, maxY, True);

   tmpstr := aStr;
   str := CutLengthString(tmpstr, 80);
   if tmpstr <> '' then str := str + '.';

   maxX := SWidth div 2 + x - Cx + 2 - ATextWidth(str) div 2;
   maxY := SHeight div 2 + y - Cy + SignImage.py + 6;

   ATextOut(Back, maxX+1, maxY+1, clBlack, str);
   ATextOut(Back, maxX, maxY, clWhite, str);
end;

procedure TBackScreen.SetRainState (aRainning: Boolean; aspeed, aCount, aover, aTick: integer; araintype: byte);
begin
   FRainning := aRainning;
   RainSpeed := aspeed;
   RainCount := acount;
   RainOverray := aover;
   RainTick := mmAnsTick + aTick;
   Raintype := araintype;
end;

procedure TBackScreen.CenterchangeIDPos(x, y: integer);
begin
{
   RainchagX := x;
   RainchagY := y;
}
end;

procedure TBackScreen.UpdateRain;
var
   i, n, xx, yy: integer;
   pr : PTRainData;
   itemp : byte;
begin
   if not FRainning then exit;
   if RainTick < mmAnsTick then FRainning := FALSE;
{
   Raintype :=RAINTYPE_SNOW;
   RainSpeed := 1;
   RainCount := 200;
   RainOverray := 50;
}
   case Raintype of
      RAINTYPE_RAIN :
            begin
               if RainList.Count < RainCount then begin
                  n := Random (RainCount div 20);
                  for i := 0 to n-1 do begin
                     new (pr);
                     pr^.rx := Random (700)-30;
                     pr^.ry := Random (480)-200;
                     pr^.rsx := pr^.rx;
                     pr^.rsy := pr^.ry;
                     pr^.rSpeed := RainSpeed + Random (RainSpeed); // 의미없는값
                     pr^.rOverray := Random (50);// 의미없는값
                     pr^.rXpos := random (20);  // 의미없는값
                     pr^.rimage := 0;
                     RainList.Add (pr);
                  end;
               end;
               for i := 0 to RainList.Count -1 do begin
                  pr := RainList[i];
                  Back.DrawImageOveray (RainImageLib.Images[pr^.rImage], pr^.rx, pr^.ry, RainOverray);
                  if (pr^.ry - pr^.rsy) > 150 then begin
                     xx := (Cx - SWidth div 2 + pr^.rx) div UNITX;
                     yy := (Cy - SHeight div 2 + pr^.ry) div UNITY;
                     if Map.IsInArea (xx, yy) then pr^.rimage := RainImageLib.Count
                     else inc (pr^.rimage);
                  end else begin
                     pr^.ry := pr^.ry + RainSpeed;
                  end;
               end;
            end;
      RAINTYPE_SNOW :
            begin
               if RainList.Count < RainCount then begin
                  n := Random (RainCount div 20);
                  for i := 0 to n-1 do begin
                     new (pr);
                     pr^.rx := Random (700)-30;
                     pr^.ry := Random (480)-200;
                     pr^.rsx := pr^.rx;
                     pr^.rsy := pr^.ry;
                     pr^.rSpeed := RainSpeed + Random (RainSpeed);
                     pr^.rOverray := Random (50);// ==>
                     pr^.rXpos := random (20);
                     pr^.rimage := 0;
                     RainList.Add (pr);
                  end;
               end;
               itemp := 0;
               for i := 0 to RainList.Count -1 do begin
                  pr := RainList[i];
                  Back.DrawImageOveray (SnowImageLib.Images[pr^.rImage], pr^.rx, pr^.ry, pr^.rOverray);
//                  Back.DrawImage (SnowImageLib.Images[pr^.rImage], pr^.rx, pr^.ry, true{pr^.rOverray});
                  if (pr^.ry - pr^.rsy) > 150 then begin
                     xx := (Cx - SWidth div 2 + pr^.rx) div UNITX;
                     yy := (Cy - SHeight div 2 + pr^.ry) div UNITY;
                     if Map.IsInArea (xx, yy) then pr^.rimage := RainImageLib.Count
                     else inc (pr^.rimage);
                  end else begin
                     if itemp = random(4) then begin
                        pr^.rx := pr^.rsx + snowXPosTable[pr^.rXpos];// + snowidx];
                        pr^.rXpos := pr^.rXpos + 1;
                        if pr^.rXpos > 40 then pr^.rXpos:= 0;
                     end;
                     inc (itemp);
                     if itemp > 4 then itemp := 0;
                     pr^.ry := pr^.ry + pr^.rSpeed;
                  end;
               end;
            end;
   end;
   for i := RainList.Count -1 downto 0 do begin
      pr := RainList[i];
      if pr^.rimage >= RainImageLib.Count then begin
         dispose (RainList[i]);
         RainList.Delete (i);
      end;
   end;
end;

procedure TBackScreen.AddEarthquake(aTick, aWidth: integer);
begin
   nEarthquakeTick := mmAnsTick + aTick;
   nEarthquakeWidth := aWidth;
end;

{
////////////////////////////// ConvertDark /////////////////////////////////////
procedure  TBackScreen.ConvertDark;
var
   i, j: integer;
   pw : PWORD;
begin
   pw := PWORD (Back.Bits);
   for j := 0 to 768-1 do begin
      for i := 0 to 1024-1 do begin
         pw^ := darkentbl [pw^];
         inc (pw);
      end;
   end;
end;

procedure SetAlphaData;
var
   j, i : integer;
begin
   for j := 0 to 255-1 do begin
      for i := 0 to 255-1 do begin
         AlphaData [j,i] := j * i div 255;
      end;
   end;
end;

procedure SetAlphaPoint;
var
   i : integer;
begin
   for i := 0 to 1027 -1 do begin
      AlphaWPoint[i] := LIGHTMAP_WIDTH * i div 640;
   end;

   for i := 0 to 768 -1 do begin
      AlphaHPoint[i] := LIGHTMAP_WIDTH * i div 480;
   end;
end;

procedure SetAlphaPos; //거리계산
var
   j, i : integer;
begin
   for j := -1024 to 1024 - 1 do begin
      for i := -1024 to 1024 - 1 do begin
         AlphaPosData [j, i] := SLength (j, i);
      end;
   end;
end;

initialization
begin
   SetAlphaData;
   SetAlphaPoint;
   SetAlphaPos;
end;

finalization
begin
end;
}



procedure TBackScreen.changeBack;
begin
  Back.Free;
  if G_Default800 then
  begin
    Back := TA2Image.Create(fwide800, fheight600, 0, 0);
    Back.Width := fwide800;
    Back.Height := fheight600;
    SWidth := fwide800; //800 - 192;
    // SHeight := 363;
    SHeight := fheight600-117; //- 117;           -G_BottomHeigth
  end else
  begin
    Back := TA2Image.Create(fwide, fhei, 0, 0);
    Back.Width := fwide;
    Back.Height := fhei;
    SWidth := fwide; //800 - 192;
    // SHeight := 363;
    SHeight := fhei-117; //- 117;   -G_BottomHeigth
  end;

  Cx := SWidth div 2;
  Cy := (SHeight div 2)+200 ;
end;
end.
