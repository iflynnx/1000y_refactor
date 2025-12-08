unit A1Img;

interface

uses
  Windows, SysUtils, Classes, Graphics, Dialogs, BmpUtil, A1ImgUtil;

const
   ImageLibID = 'ATZ0';
   ImageLibID1 = 'ATZ1';
   ImageLibID2 = 'ATZ2';

   IMG_LT     = 0;  IMG_TOP    = 1; IMG_RT     = 2; IMG_LEFT   = 3;
   IMG_BODY   = 4;  IMG_RIGHT  = 5; IMG_LB     = 6; IMG_BOTTOM = 7;
   IMG_RB     = 8;  IMG_DOWN   = 9; IMG_UP     =10; IMG_BLOCK_SIZE = 12;

type
  TA1Color = byte;
  PTA1Color = ^TA1Color;

  TA1ImageFileHeader = record
       Width: Integer;
       Height: Integer;
       px, py : Integer;
       none : Integer;
  end;

  TA1ImageLibHeader = record
    IDent: array[0..3] of Char;
    ImageCount: Integer;
    TransparentColor: Integer;
    Palette: TImgLibPalette;
  end;

  TInSpaceData = record
    spb, dpb: pbyte;
    R : TRect;
  end;

  TA1Image = class
  	private
      function  GetEmpty: Boolean;
      procedure DrawFont (AImage: TA1Image; x, y, aColor: Integer);
      function  GetInSpace (AImage: TA1Image; x, y: integer; var InSpaceData: TInSpaceData): Boolean;
   public
      boChangeGPalette: Boolean;
      px, py : integer;
    	Width, Height: Integer;
      Bits : PTA1Color;
      FClientRect : TRect;
		constructor Create(AWidth, AHeight, Apx, Apy:Integer);
    	destructor Destroy; override;
      procedure DrawImage (AImage: TA1Image; x, y: Integer; aTrans: Boolean);
      procedure DrawImageKeyColor (AImage: TA1Image; x, y, aKeyColor: integer; aTrans: Boolean);
      procedure DrawImageOveray (AImage: TA1Image; x, y: Integer; Weight: integer);
      procedure DrawImageBrightn (AImage: TA1Image; x, y: Integer);

      procedure Getmage (AImage: TA1Image; x, y: Integer; aTrans: Boolean);
      procedure Draw16BitImage (x, y, aWidth, AHeight: integer; aWordBits: pword);
      procedure DrawAddSight (AImage: TA1Image; x, y: integer);
      procedure DrawCopysight (AImage: TA1Image; x, y: integer);
      procedure DrawSight (AWidth, AHeight: integer; aGridBits: pbyte);

      procedure hLine (x, y, w: Integer; Col:word);
      procedure vLine (x, y, h: Integer; Col:word);

      procedure Clear (aColor: byte);
		procedure SaveToFile (aFileName: String);
		procedure LoadFromFile (aFileName: String);

		procedure LoadFromBitmap (aBitmap: TBitmap);

      procedure Optimize;
      procedure OptimizeWidth;
      procedure ReCanvas (aWidth, aHeight: integer);
      property  Empty : Boolean read GetEmpty;
  end;

  TA1BitmapImage = class (TA1Image)
  private
      FBitmap : TBitmap;
      procedure SetBitmap (Value: TBitmap);
  public
		constructor Create;
    	destructor Destroy; override;
      property  Bitmap : TBitmap read FBitmap write SetBitmap;
  end;

  TA1ImageLib = class
  	private
      FTag : integer;
      ImageList : TList;
		function  GetA1Image (Idx: Integer): TA1Image;
		function  GetCount : Integer;
   public
		constructor Create;
    	destructor Destroy; override;
		procedure Clear;
		procedure AddImage (AImage: TA1Image);
		procedure InsertImage (Idx: Integer; AImage: TA1Image);
		procedure DeleteImage (Idx: Integer);
    	procedure LoadFromFile (aFileName: String);
      procedure SaveToFile (aFileName: String);
    	property  Images[Index: Integer]: TA1Image read GetA1Image; default;
    	property  Count : Integer read GetCount;
      property  Tag : integer read FTag write FTag;
  end;

  TA1FontClass = class
  	private
     FontA1ImageList : array [0..65536-1] of integer;
     FBitMap : TBitmap;
     procedure BmpToA1Image (aBmp: TBitMap; aImage: TA1Image);
     function  GetFontImage (n: integer): TA1Image;
   public
     constructor Create;
     destructor Destroy; override;
  end;

procedure A1DrawImage(Canvas: TCanvas; X, Y: Integer; AImage:TA1Image);


procedure A1TextOut (A1Image: TA1Image; x, y, FontColorIndex: integer; atext: string);
function  A1TextWidth (atext: string) : integer;
function  A1TextHeight (atext: string) : integer;

procedure A1GetCanvas (aBmp: TBitMap; aImage: TA1Image);
function A1GetColorIndex (aColor: integer): integer;


function GetPBitmapInfo (aWidth, aHeight, aBitCount: integer): PBitMapInfo;

implementation

{$O+}

var
   A1FontClass : TA1FontClass;

constructor TA1FontClass.Create;
var
   DC : HDC;
   Focus: hWnd;
   p : PBitMapinfo;
begin
   FBitMap := TBitMap.Create;
   p := GetPBitmapInfo (64, 64, 8);
   Focus := GetFocus;
   dc := GetDC(Focus);
   FBitMap.Handle := CreateDIBitmap(GetDC (GetFocus), p^.bmiHeader, 0, Pointer(0), p^, DIB_RGB_COLORS);
   ReleaseDC(Focus, DC);
   if FBitMap.Handle = 0 then raise Exception.Create('CreateDIBitmap failed');
   FBitMap.Canvas.Font.Name := '±¼¸²';
   FBitMap.Canvas.Font.Size := 9;
   FBitMap.Canvas.Font.Color := clWhite;
   FBitMap.Canvas.Brush.Color := clBlack;
   FillChar (FontA1ImageList, sizeof(FontA1ImageList), 0);
end;

destructor TA1FontClass.Destroy;
var i: integer;
begin
   for i := 0 to 65536-1 do if FontA1ImageList[i] <> 0 then TA1Image (FontA1ImageList[i]).Free;
   FBitMap.Free;
   inherited destroy;
end;

procedure TA1FontClass.BmpToA1Image (aBmp: TBitMap; aImage: TA1Image);
var p : PBitMapinfo;
begin
   p := GetPBitmapInfo (aImage.Width, aImage.Height, 8);
   GetDIBits(aBmp.Canvas.Handle, aBmp.Handle, 0, aImage.Height, aImage.Bits, p^, DIB_RGB_COLORS);
end;

function TA1FontClass.GetFontImage (n: integer): TA1Image;
var
   str : string;
   w, h: integer;
   buf: array [0..3] of char;
   TempImage, TempImage2 : TA1Image;
begin
   if FontA1ImageList[n] = 0 then begin
      move (n, buf, 2);
      buf[2] := char (0);
      str := StrPas (@buf);

      FBitMap.Canvas.FillRect (Rect (0, 0, 64, 64));
      FBitMap.Canvas.TextOut(0,0,str);

      TempImage := TA1Image.Create (64, 64, 0, 0);
      BmpToA1Image (FBitMap, TempImage);

      w := FBitMap.Canvas.TextWidth(str);
      h := FBitMap.Canvas.TextHeight(str);

      TempImage2 := TA1Image.Create (w, h, 0, 0);
      TempImage2.DrawImage (TempImage, 0, 0, FALSE);
      TempImage.Free;

      TempImage2.OptimizeWidth;

      FontA1ImageList[n] := Integer (TempImage2);
   end;
   Result := TA1Image (FontA1ImageList[n]);
end;




//////////////////////////////////////
//         TA1BitmapImage           //
//////////////////////////////////////
constructor TA1BitmapImage.Create;
begin
   inherited Create (4, 4, 0, 0);
   FBitmap := TBitmap.Create;
end;

destructor TA1BitmapImage.Destroy;
begin
   FBitmap.Free;
   inherited Destroy;
end;

procedure TA1BitmapImage.SetBitmap (Value: TBitmap);
begin
   FBitmap.Assign (Value);
   if not FBitmap.Empty then begin
      ReCanvas (FBitmap.Width, FBitmap.Height);
      A1GetCanvas (FBitmap, Self);
   end else begin
      ReCanvas (4, 4);
   end;
end;

//////////////////////////////////////
//         TA1Image                 //
//////////////////////////////////////

constructor TA1Image.Create(AWidth, AHeight, Apx, Apy: Integer);
begin
	Width := WidthBytes (AWidth); Height := AHeight;
   boChangeGPalette := TRUE;

   px := Apx;                   py := Apy;
	Bits := nil;
	GetMem (Bits, Width*Height);
   if Bits = nil then raise Exception.Create('TA1Image: GemMem Failed for Bits');
   FillChar (Bits^, Width*Height, 0);
   FClientRect := Rect (0, 0, Width-1, Height-1);
end;

destructor TA1Image.Destroy;
begin
   if Bits <> nil then FreeMem (Bits);
	inherited Destroy;
end;

function  TA1Image.GetEmpty: Boolean;
begin
   Result := FALSE;
   if (Width = 4) and (Height = 4) then Result := TRUE;
end;

procedure TA1Image.ReCanvas (aWidth, aHeight: integer);
begin
   if (aWidth = 0) or (aHeight = 0) then exit;
   if (aWidth = Width) and (aHeight = Height) then exit;
   FreeMem (Bits);
   Width := aWidth;
   Height := aHeight;
   GetMem (Bits, Width*Height);
   if Bits = nil then raise Exception.Create('TA1Image: GemMem Failed for Bits');
   FillChar (Bits^, Width*Height, 0);
   FClientRect := Rect (0, 0, Width-1, Height-1);
end;

procedure TA1Image.Clear (aColor: byte);
begin
   FillChar (Bits^, Width*Height, aColor);
end;

procedure TA1Image.DrawSight (AWidth, AHeight: integer; aGridBits: pbyte);
var
   i, j:integer;
   pb: pbyte;
begin
   pb := pbyte (Bits);
   for j := 0 to 364 -1 do begin
      for i := 0 to 640 -1 do begin
         pb^ := A1TableSight256x256[pb^, aGridBits^];
         inc (pb); inc (aGridBits);
      end;
   end;
end;

procedure TA1Image.hLine (x, y, w: Integer; Col:word);
var
   i : integer;
   pb : pbyte;
begin
   if (x < 0) or (x+w >= Width) then exit;
   if (y < 0) or (y >= Height) then exit;
   pb := PBYTE (Bits);
   inc (pb, x + y * Width);
   for i := 0 to w-1 do begin pb^ := Col; inc (pb); end;
end;

procedure TA1Image.vLine (x, y, h: Integer; Col:word);
var
   i : integer;
   pb : pbyte;
begin
   if (x < 0) or (x >= Width) then exit;
   if (y < 0) or (y + h >= Height) then exit;
   pb := pbyte (Bits);
   inc (pb, x + y * Width);
   for i := 0 to h-1 do begin pb^ := Col; inc (pb, width); end;
end;

procedure TA1Image.Draw16BitImage (x, y, aWidth, AHeight: integer; aWordBits: pword);
var
   i: integer;
   pb: pbyte;
begin
   pb := pbyte (Bits);
   for i := 0 to aHeight-1 do begin
      Convert16BitTo8Bit (aWordBits, pb, aWidth);
      inc (aWordBits, aWidth);
      inc (pb, Width);
   end;
end;

procedure TA1Image.DrawAddSight (AImage: TA1Image; x, y: integer);
var
	TempSS, TempDD : pbyte;
   i, j, n : integer;
   InSpaceData : TInSpaceData;
begin
   if not GetInSpace (AImage, x, y, InSpaceData) then exit;

   for i := InSpaceData.r.Top to InSpaceData.r.Bottom do begin
      TempSS := InSpaceData.spb; TempDD := InSpaceData.dpb;
      for j := InSpaceData.r.left to InSpaceData.r.right do begin
         n  := TempDD^ + TempSS^;
         if n > 255 then TempDD^ := 255
         else TempDD^ := n;
         inc (TempSS); Inc (TempDD);
      end;
      inc (InSpaceData.spb, AImage.Width);
      inc (InSpaceData.dpb, Width);
   end;
end;

procedure TA1Image.DrawCopySight (AImage: TA1Image; x, y: integer);
var
	TempSS, TempDD : pbyte;
   i, j : integer;
   InSpaceData : TInSpaceData;
begin
   if not GetInSpace (AImage, x, y, InSpaceData) then exit;

   for i := InSpaceData.r.Top to InSpaceData.r.Bottom do begin
      TempSS := InSpaceData.spb; TempDD := InSpaceData.dpb;
      for j := InSpaceData.r.left to InSpaceData.r.right do begin
         if TempDD^ < TempSS^ then TempDD^ := TempSS^;
         inc (TempSS); Inc (TempDD);
      end;
      inc (InSpaceData.spb, AImage.Width);
      inc (InSpaceData.dpb, Width);
   end;
end;

procedure TA1Image.DrawFont (AImage: TA1Image; x, y, aColor: Integer);
var
	spb, dpb, TempSS, TempDD : pbyte;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   if AImage = nil then exit;

   sr := Rect(x, y, x+AImage.Width-1, y+AImage.Height-1);
   dr := Rect(0, 0, Width-1, Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := pbyte (AImage.Bits);
   inc (spb, ((ir.left-x)+(ir.top-y)*AImage.Width));

   dpb := pbyte (Bits);
   inc (dpb, (ir.left+ir.top*Width));

   for i := ir.Top to ir.Bottom do begin
      TempSS := spb; TempDD := dpb;
      for j := ir.left to ir.right do begin
         if TempSS^ <> 0 then TempDD^ := aColor;
         inc (TempSS); Inc (TempDD);
      end;
      inc (spb, AImage.Width);
      inc (dpb, Width);
   end;
end;

procedure TA1Image.Getmage (AImage: TA1Image; x, y: Integer; aTrans: Boolean);
var
	spb, dpb, TempSS, TempDD : pbyte;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   if AImage = nil then exit;

   sr := Rect(x, y, x+AImage.Width-1, y+AImage.Height-1);
   dr := Rect(0, 0, Width-1, Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := pbyte (AImage.Bits);
   inc (spb, ((ir.left-x)+(ir.top-y)*AImage.Width));

   dpb := pbyte (Bits);
   inc (dpb, (ir.left+ir.top*Width));

   if aTrans = FALSE then begin
      for i := ir.Top to ir.Bottom do begin
         move (dpb^, spb^, (ir.right-ir.left+1));
         inc (spb, AImage.Width);
         inc (dpb, Width);
      end;
   end else begin
      for i := ir.Top to ir.Bottom do begin
      	TempSS := spb; TempDD := dpb;
      	for j := ir.left to ir.right do begin
            if TempDD^ <> 0 then TempSS^ := TempDD^;
            inc (TempSS); Inc (TempDD);
         end;
         inc (spb, AImage.Width);
         inc (dpb, Width);
      end;
   end;
end;


function  TA1Image.GetInSpace (AImage: TA1Image; x, y: integer; var InSpaceData: TInSpaceData): Boolean;
var sr : TRect;
begin
   Result := FALSE;
   if AImage = nil then exit;
   sr := Rect(x, y, x+AImage.Width-1, y+AImage.Height-1);
   if not IntersectRect(InSpaceData.R, sr, FClientRect) then exit;

   InSpaceData.spb := pbyte (AImage.Bits);
   inc (InSpaceData.spb, ((InSpaceData.R.left-x)+(InSpaceData.R.top-y)*AImage.Width));

   InSpaceData.dpb := pbyte (Bits);
   inc (InSpaceData.dpb, (InSpaceData.R.left+InSpaceData.R.top*Width));
   Result := TRUE;
end;

procedure TA1Image.DrawImage (AImage: TA1Image; x, y: Integer; aTrans: Boolean);
var
   i, j : integer;
   TempSS, TempDD : pbyte;
   InSpaceData : TInSpaceData;
begin
   if not GetInSpace (AImage, x, y, InSpaceData) then exit;
   if aTrans = FALSE then begin
      for i := InSpaceData.R.Top to InSpaceData.R.Bottom do begin
         move (InSpaceData.spb^, InSpaceData.dpb^, (InSpaceData.r.right-InSpaceData.r.left+1));
         inc (InSpaceData.spb, AImage.Width);
         inc (InSpaceData.dpb, Width);
      end;
   end else begin
      for i := InSpaceData.r.Top to InSpaceData.r.Bottom do begin
      	TempSS := InSpaceData.spb; TempDD := InSpaceData.dpb;
      	for j := InSpaceData.r.left to InSpaceData.r.right do begin
            if TempSS^ <> 0 then TempDD^ := TempSS^;
            inc (TempSS); Inc (TempDD);
         end;
         inc (InSpaceData.spb, AImage.Width);
         inc (InSpaceData.dpb, Width);
      end;
   end;
end;

procedure TA1Image.DrawImageKeyColor (AImage: TA1Image; x, y, aKeyColor: integer; aTrans: Boolean);
var
   i, j : integer;
   TempSS, TempDD : pbyte;
   InSpaceData : TInSpaceData;
begin
   if not GetInSpace (AImage, x, y, InSpaceData) then exit;
   if aTrans = FALSE then begin
      for i := InSpaceData.R.Top to InSpaceData.R.Bottom do begin
         move (InSpaceData.spb^, InSpaceData.dpb^, (InSpaceData.r.right-InSpaceData.r.left+1));
         inc (InSpaceData.spb, AImage.Width);
         inc (InSpaceData.dpb, Width);
      end;
   end else begin
      for i := InSpaceData.r.Top to InSpaceData.r.Bottom do begin
      	TempSS := InSpaceData.spb; TempDD := InSpaceData.dpb;
      	for j := InSpaceData.r.left to InSpaceData.r.right do begin
            if (TempSS^ <> 0) then begin
               if (TempSS^ <> aKeyColor) then TempDD^ := TempSS^
               else TempDD^ := GetDarken (TempDD^);
            end;
            inc (TempSS); Inc (TempDD);
         end;
         inc (InSpaceData.spb, AImage.Width);
         inc (InSpaceData.dpb, Width);
      end;
   end;
end;

procedure TA1Image.DrawImageOveray (AImage: TA1Image; x, y: Integer; Weight: integer);
var
   i, j : integer;
   TempSS, TempDD : pbyte;
   InSpaceData : TInSpaceData;
begin
   if not GetInSpace (AImage, x, y, InSpaceData) then exit;
   for i := InSpaceData.r.Top to InSpaceData.r.Bottom do begin
      TempSS := InSpaceData.spb; TempDD := InSpaceData.dpb;
      for j := InSpaceData.r.left to InSpaceData.r.right do begin
         if TempSS^ <> 0 then TempDD^ := A1TableOverray[TempSS^, TempDD^];
         inc (TempSS); Inc (TempDD);
      end;
      inc (InSpaceData.spb, AImage.Width);
      inc (InSpaceData.dpb, Width);
   end;
end;

procedure TA1Image.DrawImageBrightn (AImage: TA1Image; x, y: Integer);
var
   i, j : integer;
   TempSS, TempDD : pbyte;
   InSpaceData : TInSpaceData;
begin
   if not GetInSpace (AImage, x, y, InSpaceData) then exit;
   for i := InSpaceData.r.Top to InSpaceData.r.Bottom do begin
      TempSS := InSpaceData.spb; TempDD := InSpaceData.dpb;
      for j := InSpaceData.r.left to InSpaceData.r.right do begin
         if TempSS^ <> 0 then TempDD^ := A1TableBrightn[TempSS^, TempDD^];
         inc (TempSS); Inc (TempDD);
      end;
      inc (InSpaceData.spb, AImage.Width);
      inc (InSpaceData.dpb, Width);
   end;
end;

procedure TA1Image.Optimize;
var
   x, y, minx, maxx, miny, maxy, w, h : Integer;
   i, j: Integer;
   pb, TempBits: pbyte;
   pcs, pcd : pbyte;
begin
   minx := width-1; maxx := 0; miny := height-1; maxy := 0;

   pb := pbyte (Bits);
   for i := 0 to (width * height)-1 do begin
      if pb^ <> 0 then begin
         x := i mod width;
         y := i div width;
         if minx > x then minx := x;
         if miny > y then miny := y;

         if maxx < x then maxx := x;
         if maxy < y then maxy := y;
      end;
      inc (pb);
   end;

   if (minx >= maxx) and ( miny >= maxy) then begin
      FreeMem ( Bits, Width * Height * sizeof(byte));
      Width := 4; Height := 4;
      GetMem (Bits, Width*Height*sizeof(byte));
      FillChar (Bits^, Width*Height*sizeof(byte), 0);
   end else begin
      w := WidthBytes (Maxx - Minx +1);
      h := Maxy - Miny +1;

      GetMem ( TempBits, w * h * sizeof(byte));
      pcs := pbyte (Bits);
      inc (pcs, (minx+miny * Width) );
      pcd := TempBits;
      for j := 0 to h -1 do begin
         move ( pcs^, pcd^, w * sizeof(byte));
         inc (pcs, Width);
         inc (pcd, w);
      end;

      FreeMem (Bits, Width*Height*sizeof(byte));
      Width := w; Height := h;
      Bits := PTA1Color (TempBits);
      px := px + Minx;
      py := py + Miny;
   end;
   FClientRect := Rect (0, 0, Width-1, Height-1);
end;

procedure TA1Image.OptimizeWidth;
var
   x, minx, maxx, w : Integer;
   i, j: Integer;
   pb, TempBits: pbyte;
   pcs, pcd : pbyte;
begin
   minx := width-1; maxx := 0;

   pb := pbyte (Bits);
   for i := 0 to (width * height)-1 do begin
      if pb^ <> 0 then begin
         x := i mod width;
         if minx > x then minx := x;
         if maxx < x then maxx := x;
      end;
      inc (pb);
   end;

   if minx > 1 then minx := minx -1;
   if maxx < Width-1 then maxx := maxx +1;

   if (minx >= maxx) then begin
      FreeMem ( Bits, Width * Height * sizeof(byte));
      Width := 4; Height := 4;
      GetMem (Bits, Width*Height*sizeof(byte));
      FillChar (Bits^, Width*Height*sizeof(byte), 0);
   end else begin
      w := Maxx - Minx +1;

      GetMem ( TempBits, w * Height * sizeof(byte));
      pcs := pbyte (Bits);
      inc (pcs, (minx) );
      pcd := TempBits;
      for j := 0 to Height -1 do begin
         move ( pcs^, pcd^, w * sizeof(byte));
         inc (pcs, Width);
         inc (pcd, w);
      end;

      FreeMem (Bits, Width*Height*sizeof(byte));
      Width := w;
      Bits := PTA1Color (TempBits);
      px := px + Minx;
   end;
   FClientRect := Rect (0, 0, Width-1, Height-1);
end;

//Load DIB ot File
procedure TA1Image.LoadFromFile (aFileName: String);
var
	BmpInfo : PBitMapInfo;
   Bmpbits : Pbyte;
   i, headerSize, ImageSize : Integer;
   Palette : TImgLibPalette;
   IndexArr : array [0..256-1] of byte;
   pb : pbyte;
begin

	BmpInfo := nil; BmpBits := nil;

	LoadDIB256 (aFileName, BmpInfo, BmpBits, HeaderSize, ImageSize);
   if (BmpInfo = nil) or (BmpBits = nil) then exit;

   if Bits <> nil then FreeMem (Bits);

   Width := BmpInfo^.bmiHeader.biWidth;
   Height := Abs(BmpInfo^.bmiHeader.biHeight);
	BmpInfoToImgLibPal(Palette, BmpInfo);

	GetMem (Bits, Width*Height);
   if Bits = nil then raise Exception.Create('TA1Image: GemMem Failed for Bits');
   FillChar (Bits^, Width*Height, 0);
   move (BmpBits^, Bits^, Width*Height);

   FreeMem ( Bmpbits);
   FreeMem ( BmpInfo);
   FClientRect := Rect (0, 0, Width-1, Height-1);

   if boChangeGPalette then begin
      for i := 0 to 256-1 do IndexArr[i] := GetNearestRGB (GPalette, Palette[i]);

      pb := pbyte (Bits);
      for i := 0 to Width*Height -1 do begin
         pb^ := IndexArr[pb^];
         inc (pb);
      end;
   end;
end;

procedure TA1Image.LoadFromBitmap (aBitmap: TBitmap);
begin
   ReCanvas (aBitmap.Width, aBitmap.Height);
   A1GetCanvas (aBitmap, Self);
end;

procedure TA1Image.SaveToFile(aFileName: String);
var
   Stream: TFileStream;
   Header: TBitmapFileHeader;
   BmpInfo : PBitMapInfo;
   HeaderSize, fh: Integer;
begin
   HeaderSize := SizeOf(TBitmapInfo);
   BmpInfo := AllocMem(HeaderSize);

   with BmpInfo^.bmiHeader do begin
      biSize := SizeOf(TBitmapInfoHeader);
      biWidth := Width;
      biHeight := -Height;
      biPlanes := 1;
      biBitCount := 8; //always convert to 8 bit image
      biCompression := BI_RGB;
      biClrUsed := 0;
      biClrImportant := 0;
   end;

   //if the height is positive the bitmap is Bottom up so flip it.
   if BmpInfo^.bmiHeader.biHeight < 0 then begin
		FlipBits(PByte(Bits), Width, Height);
      BmpInfo^.bmiHeader.biHeight := -BmpInfo^.bmiHeader.biHeight;
   end;

   ImgLibPalToBmpInfo(GPalette, BmpInfo);

   FillChar (Header, sizeof(TBitmapFileHeader), 0);
   with Header do begin
		bfType := $4D42;
      bfSize := 1078+Width*Height-1024;
      bfOffBits := 1078-1024;
   end;

	fh := FileCreate(aFileName);
   FileClose(fh);

	//Initialise and open file
   Stream := TFileStream.Create(aFileName, fmOpenWrite);
   //Read file Header
   Stream.WriteBuffer(Header, SizeOf(Header));
   //Read bitmap info header and validate
   Stream.WriteBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));

   //Load Bits
   //Stream.Seek(Header.bfOffBits, soFromBeginning);
   Stream.WriteBuffer(Bits^, LongInt(width * height * 2));
     //If the code gets this far the bitmap has been loaded okay
	Stream.Free;
   FreeMem ( BmpInfo);
end;

//////////////////////////////////////
//        TA1ImageLib             //
//////////////////////////////////////

constructor TA1ImageLib.Create;
begin
	ImageList := TList.Create;
end;

destructor TA1ImageLib.Destroy;
var i : integer;
begin
	for i := 0 to ImageList.Count - 1 do TA1Image(ImageList.items[i]).Free;
	ImageList.Free;
	inherited Destroy;
end;

function  TA1ImageLib.GetCount : Integer;
begin
	Result := ImageList.Count;
end;

function  TA1ImageLib.GetA1Image (Idx: Integer):TA1Image;
begin
	if (Idx < ImageList.Count) and (Idx >= 0)  then Result := ImageList.items[Idx]
	else Result := nil;
end;

procedure TA1ImageLib.Clear;
var i : Integer;
begin
	for i := 0 to ImageList.Count-1 do TA1Image (ImageList[i]).Free;
   ImageList.Clear;
end;

procedure TA1ImageLib.AddImage (AImage: TA1Image);
begin
	ImageList.add (AImage);
end;

procedure TA1ImageLib.DeleteImage (Idx: Integer);
begin
	if (Idx >= 0) and (Idx < ImageList.Count) then begin
   	TA1Image(ImageList.items[Idx]).Free;
		ImageList.Delete (Idx);
	end;
end;

procedure TA1ImageLib.InsertImage (Idx: Integer; AImage: TA1Image);
begin
	ImageList.Insert ( Idx, AImage);
end;

procedure TA1ImageLib.LoadFromFile (aFileName: String);
var
   Stream: TFileStream;
   n, len: Integer;
   AnsImage : TA1Image;
   ImgHeader: TA1ImageLibHeader;
  	FAnsHdr : TA1ImageFileHeader;
   LocalTable : array [0..256-1] of byte;
   pb: pbyte;
begin
   if not FileExists (aFilename) then begin ShowMessage ('File Not Fount : ' + aFileName); exit; end;
   Clear;

   Stream := TFileStream.Create(aFileName, fmOpenRead);

   Stream.ReadBuffer(ImgHeader, SizeOf(ImgHeader));
   if StrLIComp(PChar(ImageLibID), ImgHeader.Ident, 4) = 0 then begin
      GetMatch256Table (ImgHeader.Palette, @LocalTable);
      for n := 0 to ImgHeader.ImageCount - 1 do begin
         Stream.ReadBuffer(FAnsHdr, SizeOf(TA1ImageFileHeader));
         AnsImage := TA1Image.Create ( FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
         if AnsImage = nil then raise Exception.Create('TA1Image: GemMem Failed ');
         Stream.ReadBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height);
         pb := pbyte (AnsImage.Bits);
         for len := 0 to AnsImage.Width *AnsImage.Height-1 do begin
            pb^ := LocalTable[pb^];
            inc (pb);
         end;
         AddImage ( AnsImage);
      end;
   end;

   if StrLIComp(PChar(ImageLibID1), ImgHeader.Ident, 4) = 0 then begin
      for n := 0 to ImgHeader.ImageCount - 1 do begin
         Stream.ReadBuffer(FAnsHdr, SizeOf(TA1ImageFileHeader));
         AnsImage := TA1Image.Create (FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
         if AnsImage = nil then raise Exception.Create('TA1Image: GemMem Failed ');
         GetMem (pb, AnsImage.Width * AnsImage.Height*2);
         Stream.ReadBuffer(pb^, AnsImage.Width * AnsImage.Height*2);
         Convert16BitTo8Bit (pword(pb), pbyte(AnsImage.bits), AnsImage.Width*AnsImage.Height);
         FreeMem (pb);
         AddImage ( AnsImage);
      end;
   end;

   Stream.Free;
end;

procedure TA1ImageLib.SaveToFile(aFileName: String);
var
   Stream: TFileStream;
   n: Integer;
   AnsImage : TA1Image;
   fAnsHdr: TA1ImageFileHeader;
   ImgHeader: TImgLibHeader;
begin
   Stream  := TFileStream.Create(aFileName, fmCreate);
   with ImgHeader do begin
   	Ident := 'ATZ0';
   	ImageCount := ImageList.Count;
      TransparentColor := 0;
      Palette := GPalette;
   end;

   Stream.WriteBuffer(ImgHeader, SizeOf(ImgHeader));
   for n := 0 to ImgHeader.ImageCount - 1 do begin
      AnsImage := ImageList.items[n];
      fAnsHdr.Width := AnsImage.Width;
      fAnsHdr.Height := AnsImage.Height;
      fAnsHdr.Px := AnsImage.Px;
      fAnsHdr.Py := AnsImage.Py;
      Stream.WriteBuffer(fAnsHdr, SizeOf(TA1ImageFileHeader));
      Stream.WriteBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height);
   end;
   Stream.Free;
end;

////////////////////////////////
//     GetBmpInfo
////////////////////////////////

function GetPBitmapInfo (aWidth, aHeight, aBitCount: integer): PBitMapInfo;
const LocalBmpInfo : PBitmapInfo = nil;
var HeaderSize: integer;
begin
   HeaderSize := Sizeof(TBitmapInfo) + (256 * Sizeof(TRGBQuad));
   if LocalBmpInfo = nil then begin
      LocalBmpInfo := AllocMem(HeaderSize);
   end;
   if LocalBmpInfo = nil then
      raise Exception.Create('TNoryImage: Failed to allocate a DIB');

   ImgLibPalToBmpInfo(GPalette, LocalBmpInfo);
   with LocalBmpInfo^.bmiHeader do begin
      biSize        := SizeOf(TBitmapInfoHeader);
      biWidth       := aWidth;
      biHeight      := -aHeight;
      biPlanes      := 1;
      biBitCount    := aBitCount;
      biCompression := BI_RGB;
      biClrUsed     := 0;
      biClrImportant:= 0;
   end;
   Result := LocalBmpInfo;
end;

function A1GetColorIndex (aColor: integer): integer;
var TempColor : TImgLibColor;
begin
   move (aColor, TempColor, 4);
   Result := GetNearestRGB (GPalette, TempColor);
end;

procedure A1DrawImage(Canvas: TCanvas; X, Y: Integer; AImage:TA1Image);
var p : PBitmapInfo;
begin
   if not assigned (AImage) then exit;
   p := GetPBitmapInfo (aImage.Width, aImage.Height, 8);
   SetDIBitsToDevice (Canvas.Handle, x, y, AImage.Width, AImage.Height,
     0, 0, 0, AImage.Height, AImage.Bits, p^, DIB_RGB_COLORS);
end;

procedure A1GetCanvas (aBmp: TBitMap; aImage: TA1Image);
//var p : PBitmapInfo;
//begin
//   aImage.ReCanvas (aBmp.Width, aBmp.Height);
//   p := GetPBitmapInfo (aBmp.Width, aBmp.Height, 8);
//   GetDIBits(aBmp.Canvas.Handle, aBmp.Handle, 0, aImage.Height, aImage.Bits, p^, DIB_RGB_COLORS);
var
   i : integer;
   pb : pbyte;
   p : PBitMapinfo;
   Palette : TImgLibPalette;
   IndexArr : array [0..256-1] of byte;
begin
   p := GetPBitmapInfo (aImage.Width, aImage.Height, 8);

   GetDIBits(aBmp.Canvas.Handle, aBmp.Handle, 0, aImage.Height, aImage.Bits, p^, DIB_RGB_COLORS);

   FillChar (Palette, sizeof(Palette), 0);
	BmpInfoToImgLibPal(Palette, p);

   for i := 0 to 256-1 do IndexArr[i] := GetNearestRGB (GPalette, Palette[i]);

   pb := pbyte (aImage.Bits);
   for i := 0 to aImage.Width*aImage.Height -1 do begin
      pb^ := IndexArr[pb^];
      inc (pb);
   end;

end;

function  GetCurrentChar (atext: string; var curPos, rValue: integer): Boolean;
var buf: array [0..2] of char;
begin
   Result := FALSE;
   if Length (atext) < curpos then exit;

   if byte (atext[curpos]) < 128 then begin
      buf[0] := atext[curpos]; buf[1] := char (0); inc (curPos);
      rValue := PWORD (@Buf)^;
   end else begin
      buf[0] := atext[curpos];   inc (curpos);
      buf[1] := atext[curpos];   inc (curpos);
      rValue := PWORD (@Buf)^;
   end;
   Result := TRUE;
end;

procedure A1TextOut (A1Image: TA1Image; x, y, FontColorIndex: integer; atext: string);
var
   FontImage : TA1Image;
   curpos, rValue : integer;
begin
   if atext = '' then exit;

   curpos := 1; rValue := 0;
   while TRUE do begin
      if not GetCurrentChar (atext, curpos, rValue) then break;
      FontImage := A1FontClass.GetFontImage (rValue);
      A1Image.DrawFont (FontImage, x, y, FontColorIndex);
      x := x + FontImage.Width;
   end;
end;

function  A1TextWidth (atext: string): integer;
var
   FontImage : TA1Image;
   w,curpos, rValue : integer;
begin
   Result := 0;
   if atext = '' then exit;

   curpos := 1; rValue := 0; w := 0;
   while TRUE do begin
      if not GetCurrentChar (atext, curpos, rValue) then break;
      FontImage := A1FontClass.GetFontImage (rValue);
      w := w + FontImage.Width;
   end;
   Result := w;
end;

function  A1TextHeight (atext: string): integer;
var
   FontImage : TA1Image;
   h, curpos, rValue : integer;
begin
   Result := 0;
   if atext = '' then exit;

   curpos := 1; rValue := 0; h := 0;
   while TRUE do begin
      if not GetCurrentChar (atext, curpos, rValue) then break;
      FontImage := A1FontClass.GetFontImage (rValue);
      if h < FontImage.Height then h := FontImage.Height;
   end;
   Result := h;
end;

initialization
begin
   A1FontClass := TA1FontClass.Create;
end;

finalization
begin
   A1FontClass.Free;
end;


end.
