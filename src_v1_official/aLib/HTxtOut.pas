unit HTxtOut;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, AnsImg2;

type

   THangul = class (TComponent)
   private
      fontcolor: LongInt; {font color}
      prHanFont, prEngFont, prFontTbl: string;
      firChr: array [0..7, 0..19, 0..31] of byte;
      midChr: array [0..3, 0..21, 0..31] of byte;
      endChr: array [0..3, 0..27, 0..31] of byte;
      english: array [0..255, 0..15] of byte;
      han_mem: array [0..31] of byte;
      eng_mem: array [0..15] of byte;
      FontTblBuf : array [0..65536] of byte;
      SrcPtr: PTAns2Color;
      procedure DrawHangul (AnsImage: TAns2Image; x, y: integer; cho, jung, jong: byte);
      procedure DrawEnglish (AnsImage: TAns2Image; x, y: integer; data: byte);
      procedure HPutch (AnsImage: TAns2Image; x, y: integer);
      procedure EPutch (AnsImage: TAns2Image; x, y: integer);
      procedure Loaded; override;
   public
      constructor Create (AOwner: TComponent); override;
      destructor Destroy; override;
      procedure LoadHanFonts (flname: string);
      procedure LoadEngFonts (flname: string);
      procedure LoadFontTbl (flname: string);
      procedure HTextOut (AnsImage: TAns2Image; x, y: integer; str: string);
      procedure ETextOut (AnsImage: TAns2Image; x, y: integer; str: string);
      procedure SetColor (clr: LongInt);
      function  GetColor: LongInt;
   published
      property HanFont: string read prHanFont write prHanFont;
      property EngFont: string read prEngFont write prEngFont;
      property FontTbl: string read prFontTbl write prFontTbl;
   end;


procedure Register;

implementation

const

   hantable: array [0..2, 0..31] of byte = (
      ( 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
        15,16,17,18,19,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ),
      ( 0, 0, 0, 1, 2, 3, 4, 5, 0, 0, 6, 7, 8, 9,10,11,
        0, 0,12,13,14,15,16,17, 0, 0,18,19,20,21, 0, 0 ),
      ( 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
        15,16, 0,17,18,19,20,21,22,23,24,25,26,27, 0, 0 ) );

   cho2jong: array [0..18] of byte = ($02, $03, $05, $08, $01, $09, $11, $13, $01,
             $15, $16, $17, $18, $01, $19, $1a, $1b, $1c, $1d);
          // ex) cho2jong[cho - 2] = jong: jong != 0 jong = O.k!

procedure Register;
begin
  RegisterComponents ('Notang', [THangul]);
end;


constructor THangul.Create (AOwner: TComponent);

begin
   inherited Create (AOwner);
   FontColor := clWhite;
end;


destructor THangul.Destroy;
begin
   inherited Destroy;
end;

procedure THangul.Loaded;
begin
   if not (csDesigning in ComponentState) then begin
      LoadHanFonts (prHanFont);
      LoadEngFonts (prEngFont);
      LoadFontTbl (prFontTbl);
   end;
end;

procedure THangul.DrawHangul (AnsImage: TAns2Image; x, y: integer; cho, jung, jong: byte);
var i, t1, t2, t3: integer;
begin
   FillChar (han_mem, 32, 0);
   t1 := 0;
//   t2 := 0;
   t3 := 0;

   cho  := hantable[0][cho];
   jung := hantable[1][jung];
   jong := hantable[2][jong];

   case jung of
      1, 3, 10:                  t3 := 0;
      5, 7, 12, 15, 17, 20, 21:  t3 := 1;
      2, 4, 6, 8, 11, 16:        t3 := 2;
      9, 13, 14, 18, 19:         t3 := 3;
   end;

   if (cho = 1) or (cho = 16) then begin
      if jong = 0 then t2 := 0
      else t2 := 2;
   end else
      if jong = 0 then t2 := 1
      else t2 := 3;

   case jung of
      1..8, 21:
         if jong = 0 then t1 := 0
         else t1 := 5;
      9, 13, 19:
         if jong = 0 then t1 := 1
         else t1 := 6;
      14, 18:
         if jong = 0 then t1 := 2
         else t1 := 6;
      10, 11, 12, 20:
         if jong = 0 then t1 := 3
         else t1 := 7;
      15, 16, 17:
         if jong = 0 then t1 := 4
         else t1 := 7;
   end;

   if (jung = 0) and (jong = 0) then t1 := 0;

   { combine flat img }
   if cho > 0 then
      for i:=0 to 31 do han_mem[i] := han_mem[i] or firChr[t1, cho, i];
   if jung > 0 then
      for i:=0 to 31 do han_mem[i] := han_mem[i] or midChr[t2, jung, i];
   if jong > 0 then
      for i:=0 to 31 do han_mem[i] := han_mem[i] or endChr[t3, jong, i];

   {hputch}
   HPutch (AnsImage, x, y);

end;

procedure THangul.DrawEnglish (AnsImage: TAns2Image; x, y: integer; data: byte);
begin
   FillChar (eng_mem, 16, 0);
   Move (english[data], eng_mem, 16);
   EPutch (AnsImage, x, y);
end;

{ use: han_mem }
procedure THangul.HPutch (AnsImage: TAns2Image; x, y: integer);
var
   i, max: integer;
   Ptr: PByte;
begin
   max := AnsImage.Width * AnsImage.Height;

   for i:=0 to 15 do begin

      if (y+i) * AnsImage.Width + x + 15 < max then begin
         Ptr := PByte (Longint(SrcPtr) + ((y + i) * AnsImage.Width + x) * 2);

         if han_mem[i*2] and $80 > 0 then Move (FontColor,  PByte (Longint(Ptr)+0*2)^ , 2);
         if han_mem[i*2] and $40 > 0 then Move (FontColor,  PByte (Longint(Ptr)+1*2)^ , 2);
         if han_mem[i*2] and $20 > 0 then Move (FontColor,  PByte (Longint(Ptr)+2*2)^ , 2);
         if han_mem[i*2] and $10 > 0 then Move (FontColor,  PByte (Longint(Ptr)+3*2)^ , 2);
         if han_mem[i*2] and $08 > 0 then Move (FontColor,  PByte (Longint(Ptr)+4*2)^ , 2);
         if han_mem[i*2] and $04 > 0 then Move (FontColor,  PByte (Longint(Ptr)+5*2)^ , 2);
         if han_mem[i*2] and $02 > 0 then Move (FontColor,  PByte (Longint(Ptr)+6*2)^ , 2);
         if han_mem[i*2] and $01 > 0 then Move (FontColor,  PByte (Longint(Ptr)+7*2)^ , 2);

         if han_mem[i*2+1] and $80 > 0 then Move (FontColor,  PByte (Longint(Ptr)+8*2)^ , 2);
         if han_mem[i*2+1] and $40 > 0 then Move (FontColor,  PByte (Longint(Ptr)+9*2)^ , 2);
         if han_mem[i*2+1] and $20 > 0 then Move (FontColor,  PByte (Longint(Ptr)+10*2)^ , 2);
         if han_mem[i*2+1] and $10 > 0 then Move (FontColor,  PByte (Longint(Ptr)+11*2)^ , 2);
         if han_mem[i*2+1] and $08 > 0 then Move (FontColor,  PByte (Longint(Ptr)+12*2)^ , 2);
         if han_mem[i*2+1] and $04 > 0 then Move (FontColor,  PByte (Longint(Ptr)+13*2)^ , 2);
         if han_mem[i*2+1] and $02 > 0 then Move (FontColor,  PByte (Longint(Ptr)+14*2)^ , 2);
         if han_mem[i*2+1] and $01 > 0 then Move (FontColor,  PByte (Longint(Ptr)+15*2)^ , 2);
      end;
   end;
end;

procedure THangul.EPutch (AnsImage: TAns2Image; x, y: integer);
var
   i, max: integer;
   Ptr: PByte;
begin
   max := AnsImage.Width * AnsImage.Height;
   for i:=0 to 15 do begin

      if (y+i) * AnsImage.Width + x + 7 < max then begin
         Ptr := PByte (Longint(SrcPtr) + ((y + i) * AnsImage.Width + x) * 2);

         if eng_mem[i] and $80 > 0 then Move (FontColor, PByte (Longint(Ptr)+0*2)^ , 2);
         if eng_mem[i] and $40 > 0 then Move (FontColor, PByte (Longint(Ptr)+1*2)^ , 2);
         if eng_mem[i] and $20 > 0 then Move (FontColor, PByte (Longint(Ptr)+2*2)^ , 2);
         if eng_mem[i] and $10 > 0 then Move (FontColor, PByte (Longint(Ptr)+3*2)^ , 2);
         if eng_mem[i] and $08 > 0 then Move (FontColor, PByte (Longint(Ptr)+4*2)^ , 2);
         if eng_mem[i] and $04 > 0 then Move (FontColor, PByte (Longint(Ptr)+5*2)^ , 2);
         if eng_mem[i] and $02 > 0 then Move (FontColor, PByte (Longint(Ptr)+6*2)^ , 2);
         if eng_mem[i] and $01 > 0 then Move (FontColor, PByte (Longint(Ptr)+7*2)^ , 2);
      end;
   end;
end;

procedure THangul.LoadHanFonts (flname: string);
var
   fhandle: integer;
begin
   fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
   if fhandle > 0 then begin
      FileRead (fhandle, firChr, 5120);
      FileRead (fhandle, midChr, 2816);
      FileRead (fhandle, endChr, 3584);
      FileClose (fhandle);
   end else
      ShowMessage ('(Error!!) Hangul font file not found !');
end;

procedure THangul.LoadFontTbl (flname: string);
var
   fhandle: integer;
begin
   fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
   if fhandle > 0 then begin
      FileRead (fhandle, FontTblbuf, 65536);
      FileClose (fhandle);
   end else
      ShowMessage ('(Error!!) FontTbl file not found !');
end;

procedure THangul.LoadEngFonts (flname: string);
var
   fhandle: integer;
begin
   fhandle := FileOpen (flname, fmOpenRead or fmShareDenyNone);
   if fhandle > 0 then begin
      FileRead (fhandle, english, 4096);
      FileClose (fhandle);
   end else
      ShowMessage ('(Error!!) English font file not found !');
end;

procedure THangul.SetColor (clr: LongInt);
begin
   FontColor := clr;
end;

function  THangul.GetColor: LongInt;
begin
   Result := FontColor;
end;

procedure THangul.HTextOut (AnsImage: TAns2Image; x, y: integer; str: string);
var
   data1, data2: byte;
   cho, jung, jong: byte;
   i, len, pos : integer;
   wd : word;
   pb : pbyte;
begin

//   data1 := 0;
   data2 := 0;

   SrcPtr := AnsImage.Bits;

   i := 1;
   pos := 0;
   len := Length (str);

   while TRUE do begin
      if i > len then break;
      pb := @FontTblBuf;
      data1 := byte (str[i]);
      if data1 > 127 then begin
         if i+1 <= len then data2 := byte (str[i + 1]);
         wd := makeword ( data2, data1);
         wd := wd - $8100;
         inc (pb, wd*2);
         data1 := pb^; inc (pb);
         data2 := pb^;
            cho  := (data1 and 124) shr 2;
            jung := (data1 and 3) * 8 + (data2 shr 5);
            jong := (data2 and 31);
         if ((x+pos) >= 0 ) and ((x+pos+16) < AnsImage.Width) and
            ((y) >= 0 ) and ((y+16) < AnsImage.Height) then
               DrawHangul (AnsImage, x + pos, y, cho, jung, jong);
         Inc (pos, 16);
         Inc (i);
      end else begin
         if ((x+pos) >= 0 ) and ((x+pos+8) < AnsImage.Width) and
            ((y) >= 0 ) and ((y+16) < AnsImage.Height) then
               DrawEnglish (AnsImage, x + pos, y, data1);
         Inc (pos, 8);
      end;
      Inc (i);
   end;

end;

procedure THangul.ETextOut (AnsImage: TAns2Image; x, y: integer; str: string);
var
   data1 : byte;//, data2: byte;
//   cho, jung, jong: byte;
   i, len, pos : integer;
//   wd : word;
//   pb : pbyte;
begin
// data2 := 0;

   SrcPtr := AnsImage.Bits;

   i := 1;
   pos := 0;
   len := Length (str);

   while TRUE do begin
      if i > len then break;
//      pb := @FontTblBuf;
      data1 := byte (str[i]);
{
      if data1 > 127 then begin
         if i+1 <= len then data2 := byte (str[i + 1]);
         wd := makeword ( data2, data1);
         wd := wd - $8100;
         inc (pb, wd*2);
         data1 := pb^; inc (pb);
         data2 := pb^;
            cho  := (data1 and 124) shr 2;
            jung := (data1 and 3) * 8 + (data2 shr 5);
            jong := (data2 and 31);
         if ((x+pos) >= 0 ) and ((x+pos+16) < AnsImage.Width) and
            ((y) >= 0 ) and ((y+16) < AnsImage.Height) then
               DrawHangul (AnsImage, x + pos, y, cho, jung, jong);
         Inc (pos, 16);
         Inc (i);
      end else begin
}
         if ((x+pos) >= 0 ) and ((x+pos+8) < AnsImage.Width) and
            ((y) >= 0 ) and ((y+16) < AnsImage.Height) then
               DrawEnglish (AnsImage, x + pos, y, data1);
         Inc (pos, 8);
//      end;
      Inc (i);
   end;

end;


end.
