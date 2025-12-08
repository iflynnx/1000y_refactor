unit A1imgutil;

interface

uses Windows, SysUtils, Classes, BmpUtil, aUtil32;

const
   A1EFFECT_NONE      = 0;
   A1EFFECT_GRAY      = 1;
   A1EFFECT_RED       = 2;
   A1EFFECT_GREEN     = 3;
   A1EFFECT_BLUE      = 4;

 procedure A1LoadPalette (aFileName: string);

 procedure GetMatch256Table (aPalette : TImgLibPalette; ptable: pbyte);

 procedure Convert16BitTo8Bit (apw: pword; apb: pbyte; aSize: integer);
 procedure ConvertA1Effect (psour, pdest: pbyte; aSize: integer; aEffect: integer);

 function  GetDarken (acol: byte): byte;
var
   GPalette : TImgLibPalette;
   A1TableSight256x256 : array [0..256-1, 0..256-1] of byte;

   A1TableOverray : array [0..256-1, 0..256-1] of byte;

   A1TableBrightn : array [0..256-1, 0..256-1] of byte;

implementation

{$O+}

var
   A1Table16BitTo8Bit : array [0..65536-1] of byte;

   A1TableNone : array [0..256-1] of byte;           // A1EFFECT_GRAY
   A1TableGray : array [0..256-1] of byte;           // A1EFFECT_GRAY
   A1TableRed  : array [0..256-1] of byte;           // A1EFFECT_RED
   A1TableGreen: array [0..256-1] of byte;           // A1EFFECT_GREEN
   A1TableBlue : array [0..256-1] of byte;           // A1EFFECT_BLUE

   A1TableDarken : array [0..256-1] of byte;           // A1EFFECT_GRAY


function  GetDarken (acol: byte): byte;
begin
   Result := A1TableDarken [acol];
end;

procedure GetMatch256Table (aPalette : TImgLibPalette; ptable: pbyte);
var
   i: integer;
begin
   for i := 0 to 256-1 do begin
      ptable^ := GetNearestRGB (GPalette, aPalette[i]);
      inc (ptable);
   end;
end;


procedure ConvertA1Effect (psour, pdest: pbyte; aSize: integer; aEffect: integer);
var
   i: integer;
   peffect: pbyte;
begin
   case aEffect of
      A1EFFECT_NONE : peffect := @A1TableNone;
      A1EFFECT_GRAY : peffect := @A1TableGray;
      A1EFFECT_RED  : peffect := @A1TableRed;
      A1EFFECT_GREEN: peffect := @A1TableGreen;
      A1EFFECT_BLUE : peffect := @A1TableBlue;
      else peffect := @A1TableNone;
   end;

   for i := 0 to aSize -1 do begin
      pdest^ := PBYTE (integer (peffect) + psour^)^;
      inc (psour); inc (pdest);
   end;
end;

procedure Convert16BitTo8Bit (apw: pword; apb: pbyte; aSize: integer);
var i: integer;
begin
   for i := 0 to aSize -1 do begin apb^ := A1Table16bitTo8bit[apw^]; inc (apb); inc (apw); end;
end;


var
   D2PaletteTable : array [0..768-1] of byte = (
      0,0,0,55,0,0,43,37,12,68,55,24,93,80,37,142,0,0,111,99,49,130,111,62,                              223,0,0,217,111,24,255,0,0,255,204,49,255,255,167,217,192,124,255,241,155,18,18,12,
      31,24,24,43,43,43,62,55,43,68,68,68,93,86,74,86,86,86,111,111,111,136,124,111,                     155,136,80,136,136,136,179,155,93,155,155,155,192,179,173,204,204,204,241,235,229,255,255,255,
      0,0,255,12,6,6,24,6,0,37,12,6,37,24,12,43,31,24,55,18,6,49,37,18,                                  49,37,31,68,24,12,55,43,24,62,49,18,86,12,6,74,43,24,74,62,31,99,31,18,
      86,62,24,111,18,6,86,62,43,117,49,18,105,68,31,99,68,49,136,24,12,111,80,49,                       105,80,62,130,62,43,142,43,31,142,55,12,130,86,37,130,86,55,167,37,24,161,68,24,
      142,105,55,173,55,37,161,93,55,192,68,18,155,117,68,173,111,12,198,62,37,179,124,62,               210,74,55,167,124,99,217,80,18,173,49,161,186,136,105,217,99,99,204,142,74,241,80,55,
      254,62,37,254,111,31,217,155,99,217,173,86,217,161,124,255,105,80,255,117,49,235,173,136,          248,186,99,255,148,43,241,204,111,255,130,130,255,167,49,255,192,136,255,210,111,255,192,130,
      255,173,49,255,241,130,255,68,0,255,217,173,255,235,124,255,204,74,255,173,173,255,235,186,        255,210,93,255,248,86,255,255,155,255,254,204,255,255,105,255,255,117,255,255,217,255,255,142,
      255,255,255,6,55,24,31,55,37,49,93,37,37,111,18,0,105,74,37,155,12,55,142,55,                      86,142,55,12,167,105,62,192,31,99,179,80,136,186,74,80,241,43,173,204,86,111,248,80,
      136,223,117,105,255,62,204,235,111,148,255,117,37,255,0,179,255,142,217,255,192,248,255,210,       18,18,62,37,37,111,0,0,136,86,31,105,24,55,161,62,93,155,62,62,186,117,24,198,
      86,117,204,74,74,229,111,148,217,86,142,248,124,124,255,117,167,255,130,186,255,55,148,255,        155,186,255,155,223,255,198,248,255,254,49,255,204,204,255,248,248,255,223,255,255,136,217,223,
      161,248,254,204,255,255,235,255,255,255,255,255,255,255,255,255,248,198,255,255,255,255,255,229,   255,255,179,255,255,255,255,255,254,255,255,255,6,6,6,12,12,12,18,18,18,24,24,24,
      31,31,31,37,37,37,55,43,37,49,49,49,55,55,55,62,62,62,74,62,49,74,74,74,                           86,74,62,80,80,80,80,86,93,105,86,80,93,93,93,117,93,74,99,99,99,105,99,93,
      105,105,105,124,111,93,136,105,86,117,117,117,148,117,93,80,136,142,124,124,124,130,130,130,       142,142,142,161,142,124,148,148,148,105,173,179,192,155,124,161,161,161,167,167,167,186,167,148,
      173,173,173,179,179,179,192,192,192,229,198,155,223,204,179,255,210,173,223,223,223,241,229,204,   198,229,255,248,248,248,255,255,235,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
      255,255,255,173,142,80,192,161,99,210,173,105,255,37,255,255,24,255,255,31,255,255,31,255,         43,55,31,49,105,86,229,198,136,241,210,142,248,217,155,255,241,186,255,255,192,255,255,210,
      255,255,255,93,80,55,111,99,68,124,105,74,136,117,80,148,136,99,161,142,105,173,155,111,           179,161,117,198,173,111,192,173,130,210,179,117,204,186,136,210,192,148,248,229,173,255,255,255
   );
{
function WinRGB (r, g, b: word): word;
begin
   Result  := b + (g shl 5) + (r shl 10);
end;
}

procedure WinVRGB (n:word; var r, g, b: word);
begin
   b := n and $1F;
   g := (n shr 5) and $1F;
   r := (n shr 10) and $1F;
end;

procedure SetA1Table16BitTo8Bit;
var
   i: integer;
   r, g, b: word;
   TempColor: TImgLibColor;
begin
   for i := 0 to 65536-1 do begin
      WinVRGB (i, r, g, b);
      TempColor.Red := r*8;
      TempColor.Green := g*8;
      TempColor.Blue := b*8;
      A1Table16BitTo8Bit[i] := GetNearestRGB(GPalette, TempColor);
   end;
end;

procedure SetA1TableSight256x256;
var
   i, j, n: integer;
   r, g, b: word;
   TempColor: TImgLibColor;
begin
   for j := 0 to 256-1 do begin
      for i := 0 to 256-1 do begin
         TempColor := GPalette[i];
         n := 256-j;

         if (j = 127) or (j = 128) then begin
            A1TableSight256x256[i, j] := i;
            continue;
         end;


         if n > 128 then begin
            n := (n-128) * 100 div 128;
            TempColor.Red := TempColor.Red - TempColor.Red * (n) div 100;
            TempColor.Green := TempColor.Green - TempColor.Green * (n) div 100;
            TempColor.Blue := TempColor.Blue - TempColor.Blue * (n) div 100;
         end else begin
            n := (128-n) * 100 div 128;
            r := TempColor.Red + TempColor.Red * (n) div 100;
            if r > 255 then TempColor.Red := 255
            else TempColor.red := r;

            g := TempColor.Green + TempColor.Green * (n) div 100;
            if g > 255 then TempColor.Green := 255
            else TempColor.Green := g;

            b := TempColor.Blue + TempColor.Blue * (n) div 100;
            if b > 255 then TempColor.Blue := 255
            else TempColor.Blue := b;
         end;

         A1TableSight256x256[i, j] := GetNearestRGB (GPalette, TempColor);
      end;
   end;
end;

procedure SetA1TableOverray;
var
   i, j: integer;
   TempColor, BackColor, FrontColor: TImgLibColor;
begin
   for j := 0 to 256-1 do begin
      for i := 0 to 256-1 do begin
         FrontColor := GPalette[j];
         BackColor := GPalette[i];

         TempColor.Red := (BackColor.Red + FrontColor.Red) div 2;
         TempColor.Green := (BackColor.Green + FrontColor.Green) div 2;
         TempColor.Blue := (BackColor.Blue + FrontColor.Blue) div 2;
         A1TableOverray[i, j] := GetNearestRGB (GPalette, TempColor);
      end;
   end;
end;

procedure SetA1TableBrightn;
var
   i, j: integer;
   TempColor, BackColor, FrontColor: TImgLibColor;
begin
   for j := 0 to 256-1 do begin
      for i := 0 to 256-1 do begin
         FrontColor := GPalette[j];
         BackColor := GPalette[i];

         if BackColor.Red < FrontColor.Red then TempColor.Red := FrontColor.Red
         else TempColor.Red := BackColor.Red;

         if BackColor.Green < FrontColor.Green then TempColor.Green := FrontColor.Green
         else TempColor.Green := BackColor.Green;

         if BackColor.Blue < FrontColor.Blue then TempColor.Blue := FrontColor.Blue
         else TempColor.Blue := BackColor.Blue;

         A1TableBrightn[i, j] := GetNearestRGB (GPalette, TempColor);
      end;
   end;
end;

procedure SetA1TableNone;
var i: integer;
begin
   for i := 0 to 256-1 do A1TableNone[i] := i;
end;

procedure SetA1TableGray;
var
   i, n: integer;
   TempColor: TImgLibColor;
begin
   for i := 0 to 256-1 do begin
      TempColor := GPalette[i];
      with TempColor do n := Red+Blue+Green;
      with TempColor do begin
         Red := n div 3;
         Blue := n div 3;
         Green := n div 3;
      end;
      A1TableGray[i] := GetNearestRGB (GPalette, TempColor);
   end;
end;

procedure SetA1TableRed;
var
   i, n: integer;
   TempColor: TImgLibColor;
begin
   for i := 0 to 256-1 do begin
      TempColor := GPalette[i];
      with TempColor do n := Red;
      with TempColor do begin
         Red := n;
         Blue := 0;
         Green := 0;
      end;
      A1TableRed[i] := GetNearestRGB (GPalette, TempColor);
   end;
end;

procedure SetA1TableGreen;
var
   i, n: integer;
   TempColor: TImgLibColor;
begin
   for i := 0 to 256-1 do begin
      TempColor := GPalette[i];
      with TempColor do n := Green;
      with TempColor do begin
         Red := 0;
         Blue := 0;
         Green := n;
      end;
      A1TableGreen[i] := GetNearestRGB (GPalette, TempColor);
   end;
end;

procedure SetA1TableBlue;
var
   i, n: integer;
   TempColor: TImgLibColor;
begin
   for i := 0 to 256-1 do begin
      TempColor := GPalette[i];
      with TempColor do n := Blue;
      with TempColor do begin
         Red := 0;
         Blue := n;
         Green := 0;
      end;
      A1TableBlue[i] := GetNearestRGB (GPalette, TempColor);
   end;
end;

procedure SetA1TableDarken;
var
   i: integer;
   TempColor: TImgLibColor;
begin
   for i := 0 to 256-1 do begin
      TempColor := GPalette[i];
      if TempColor.Red > 2 then TempColor.Red := TempColor.Red div 2;
      if TempColor.Green > 2 then TempColor.Green := TempColor.Green div 2;
      if TempColor.Blue > 2 then TempColor.Blue := TempColor.Blue div 2;

      A1TableDarken[i] := GetNearestRGB (GPalette, TempColor);
   end;
end;

procedure SetGPalette (apb: pbyte);
var i: integer;
begin
   for i := 0 to 256 -1 do begin
      GPalette[i].Red   := apb^; inc (apb);
      GPalette[i].Green := apb^; inc (apb);
      GPalette[i].Blue  := apb^; inc (apb);
      GPalette[i].Used  := TRUE;
   end;
end;

procedure A1LoadPalette (aFileName: string);
var
   i, cols: integer;
   str, rdstr: string;
   StringList : TStringList;
begin
   if not FileExists (aFileName) then exit;
   StringList := TStringList.Create;
   StringList.LoadFromFile (aFileName);

   Cols := StringList.Count;
   if Cols > 256 then Cols := 256;
   for i := 0 to Cols -1 do begin
      str := StringList[i];
      str := GetValidStr3 (str, rdstr, ' ');
      D2PaletteTable[i*3+0] := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ' ');
      D2PaletteTable[i*3+1] := _StrToInt (rdstr);
      str := GetValidStr3 (str, rdstr, ' ');
      D2PaletteTable[i*3+2] := _StrToInt (rdstr);
      GPalette[i].Used := TRUE;
   end;
   StringList.Free;

   SetGPalette (@D2PaletteTable);
   SetA1Table16BitTo8Bit;
   SetA1TableSight256x256;
end;

initialization
begin
//   A1LoadPalette('.\palette.dat');
   SetGPalette (@D2PaletteTable);
   SetA1Table16BitTo8Bit;
   SetA1TableNone;
   SetA1TableGray;
   SetA1TableRed;
   SetA1TableGreen;
   SetA1TableBlue;

   SetA1TableDarken;
   SetA1TableSight256x256;
   SetA1TableOverray;
   SetA1TableBrightn;
end;

finalization
begin
end;


end.

