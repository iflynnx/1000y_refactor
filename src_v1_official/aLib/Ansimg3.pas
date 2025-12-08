unit AnsImg3;

interface

uses
  Windows, SysUtils, Classes, Graphics, BmpUtil, AnsImg;

const
     ImageLibID = 'ATZ0';

type

  TAnsColor = record
     red, green, blue : byte;
  end;

  PTAnsColor = ^TAnsColor;

  TAnsTrueImageFileHeader = record
       Width: Integer;
       Height: Integer;
       px, py : Integer;
       none : Integer;
  end;

  TAnsTrueImageLibHeader = record
       IDent: array[0..3] of Char;
       ImageCount: Integer;
       TransparentColor: Integer;
       Palette: TImgLibPalette;
  end;

  TAnsTrueImage = class
  	private
   protected
   public
      px, py : integer;
    	Width, Height: Integer;
      Bits : PByte;
      TransparentColor : Integer;
		constructor Create(AWidth, AHeight, Apx, Apy:Integer);
    	destructor Destroy; override;
      procedure DrawImage (AnsImage: TAnsTrueImage; x, y: Integer; aTrans: Boolean);
      procedure ClearImage ( Color: DWORD);
		procedure SaveToFile(FileName: String);
		procedure LoadFromFile (FileName: String);
      procedure LoadFromFileTrueColor (FileName: String);
      procedure Optimize;
      procedure DrawImage8bit (Palette: TImgLibPalette; x, y:integer; aImage: TAnsImage);
   published
  end;

  TAnsTrueImageLib = class
  	private
      FTransparentColor : Integer;
      ImageList : TList;
		function  GetAnsTrueImage (Idx: Integer): TAnsTrueImage;
		function  GetCount : Integer;
      procedure SetTransparentColor (Value: Integer);
   protected
   public
		constructor Create;
    	destructor Destroy; override;
		procedure Clear;
		procedure AddImage (AImage: TAnsTrueImage);
		procedure DeleteImage (Idx: Integer);
    	procedure LoadFromFile(FileName: String);
    	property  TransParentColor : Integer read FTransparentColor write SetTransparentColor;
   published
//    	property Images[Index: Integer]: TAnsTrueImage read GetAnsTrueImage;
    	property Count : Integer read GetCount;
  end;

procedure AnsDrawTrueImage(Canvas: TCanvas; X, Y: Integer; ansImage:TAnsTrueImage);
procedure AnsPaletteDataToAnsTrueImage (AnsTrueImage: TAnsTrueImage; Palette: TImgLibPalette; pb : Pbyte);
procedure AnsStretchDrawTrueImage(Canvas: TCanvas; Rect: TRect; ansImage:TAnsTrueImage);
function  MakeSelectedImage ( AnsImage:TAnsTrueImage; Col:Integer):TAnsTrueImage;

procedure AnsTrueImageCreateAndMove (Sour: TAnsTrueImage; var Dest: TAnsTrueImage);

implementation


//////////////////////////////////////
//         TAnsTrueImage            //
//////////////////////////////////////

constructor TAnsTrueImage.Create(AWidth, AHeight, Apx, Apy: Integer);
begin
	TransparentColor := 0;
	Width := WidthBytes (AWidth); Height := AHeight;
   px := Apx;                   py := Apy;
	Bits := nil;
	GetMem (Bits, Width*Height*3);
   if Bits = nil then raise Exception.Create('TAnsTrueImage: GemMem Failed for Bits');
   FillChar (Bits^, Width*Height*3, 0)
end;

destructor TAnsTrueImage.Destroy;
begin
   if Bits <> nil then FreeMem ( Bits, Width*Height*3);
	inherited Destroy;
end;

procedure TAnsTrueImage.ClearImage ( Color: DWORD);
var
   i : integer;
   pb: pbyte;
begin
   pb := Bits;

   for i := 0 to Width * Height-1 do begin
      move (Color, pb^, 3);
      inc (pb, 3);
   end;
//   FillChar ( Bits^, Width*Height*3, Color);
end;

procedure TAnsTrueImage.Optimize;
var
   x, y, minx, maxx, miny, maxy, w, h : Integer;
   i, j: Integer;
   pb, TempBits: pbyte;
   TempColor : integer;
   pcs, pcd : PTAnsColor;
begin
   minx := width-1; maxx := 0; miny := height-1; maxy := 0;

   pb := Bits;
   for i := 0 to (width * height)-1 do begin
      TempColor := PInteger(pb)^ and $00ffffff;
      if TempColor <> TransParentColor then begin
         x := i mod width;
         y := i div width;
         if minx > x then minx := x;
         if miny > y then miny := y;

         if maxx < x then maxx := x;
         if maxy < y then maxy := y;
      end;
      inc (pb, 3);
   end;

   if (minx >= maxx) and ( miny >= maxy) then begin
      FreeMem ( Bits, Width * Height * 3);
      Width := 4; Height := 4;
      GetMem (Bits, Width*Height*3);
      FillChar (Bits^, 16*3, 0);
   end else begin
      w := WidthBytes (Maxx - Minx +1);
      h := Maxy - Miny +1;

      GetMem ( TempBits, w * h * 3);
      pcs := PTAnsColor (Bits);
      inc (pcs, (minx+miny * Width) );
      pcd := PTAnsColor(TempBits);
      for j := 0 to h -1 do begin
         move ( pcs^, pcd^, w * 3);
         inc (pcs, Width);
         inc (pcd, w);
      end;

      FreeMem (Bits, Width*Height*3);
      Width := w; Height := h;
      Bits := TempBits;
      px := px + Minx;
      py := py + Miny;

   end;
end;

procedure TAnsTrueImage.DrawImage8bit (Palette: TImgLibPalette; x, y:integer; aImage: TAnsImage);
var
   tempimage: TAnsTrueImage;
begin
   tempimage := TAnsTrueImage.Create (aImage.Width, aImage.Height, aImage.px, aImage.py);
   tempimage.TransparentColor := $FFFFFF;
   AnsPaletteDataToAnsTrueImage (tempimage, Palette, aImage.Bits);
   DrawImage (tempimage, x, y, TRUE);
   tempimage.Free;
end;

procedure TAnsTrueImage.DrawImage (AnsImage: TAnsTrueImage; x, y: Integer; aTrans: Boolean);
var
	spb, dpb, TempSS, TempDD : pbyte;
   i, j, tempcolor : integer;
   ir, sr, dr: TRect;
begin
   //do clipping
   sr := Rect(x, y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   dr := Rect(0, 0, Width-1, Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := AnsImage.Bits;
   inc (spb, ((ir.left-x)+(ir.top-y)*AnsImage.Width) * 3);

   dpb := Bits;
   inc (dpb, (ir.left+ir.top*Width) * 3);

   if aTrans = FALSE then begin
      for i := ir.Top to ir.Bottom do begin
         move (spb^, dpb^, (ir.right-ir.left+1) * 3);
         inc (spb, AnsImage.Width * 3);
         inc (dpb, Width * 3);
      end;
   end else begin
      for i := ir.Top to ir.Bottom do begin
      	TempSS := spb; TempDD := dpb;
      	for j := ir.left to ir.right do begin
            TempColor := PInteger(TempSS)^ and $00ffffff;

         	if TempColor <> AnsImage.TransparentColor then
               move ( TempSS^, TempDD^, 3);
            inc (TempSS, 3); Inc (TempDD, 3);
         end;
         inc (spb, AnsImage.Width * 3);
         inc (dpb, Width * 3);
      end;
   end;
end;

//Load DIB ot File
procedure TAnsTrueImage.LoadFromFile (FileName: String);
var
	BmpInfo : PBitMapInfo;
   Bmpbits : Pbyte;
   headerSize, ImageSize : Integer;
   Palette : TImgLibPalette;
begin

	BmpInfo := nil; BmpBits := nil;

	LoadDIB256 ( FileName, BmpInfo, BmpBits, HeaderSize, ImageSize);
   if (BmpInfo = nil) or (BmpBits = nil) then exit;

   if Bits <> nil then FreeMem ( Bits, Width*Height*3);

   Width := BmpInfo^.bmiHeader.biWidth;
   Height := Abs(BmpInfo^.bmiHeader.biHeight);
	BmpInfoToImgLibPal(Palette, BmpInfo);

	GetMem (Bits, Width*Height*3);
   if Bits = nil then raise Exception.Create('TAnsTrueImage: GemMem Failed for Bits');
   FillChar (Bits^, Width*Height*3, 0);

   AnsPaletteDataToAnsTrueImage (Self, Palette, BmpBits);

   FreeMem ( Bmpbits);
   FreeMem ( BmpInfo);
end;

procedure TAnsTrueImage.LoadFromFileTrueColor (FileName: String);
var
   Stream: TFileStream;
   Header: TBitmapFileHeader;
   BmpInfo : PBitMapInfo;
   HeaderSize: Integer;
begin
	//Initialise and open file
   HeaderSize := SizeOf(TBitmapInfoHeader);
   BmpInfo := AllocMem(HeaderSize);
   Stream := TFileStream.Create(FileName, fmOpenRead);
   //Read file Header
   Stream.ReadBuffer(Header, SizeOf(Header));
   //Read bitmap info header and validate
   Stream.ReadBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));

   with BmpInfo^.bmiHeader do begin
      if biBitCount <> 24 then begin
	      Stream.Free;
         FreeMem ( BmpInfo);
         exit;
      end;
   end;

   if Bits <> nil then FreeMem ( Bits, Width*Height*3);
   Width := BmpInfo^.bmiHeader.biWidth;
   Height := BmpInfo^.bmiHeader.biHeight;

	GetMem (Bits, Width*Height*3);

   //Load Bits
   //Stream.Seek(Header.bfOffBits, soFromBeginning);
   Stream.ReadBuffer(Bits^, LongInt(width * height * 3));
   FlipBits (Bits, Width*3, Height);

     //If the code gets this far the bitmap has been loaded okay
	Stream.Free;
   FreeMem ( BmpInfo);
end;

//Save DIB ot File
procedure TAnsTrueImage.SaveToFile(FileName: String);
var
   Stream: TFileStream;
   Header: TBitmapFileHeader;
   BmpInfo : PBitMapInfo;
   HeaderSize, fh: Integer;
begin
     HeaderSize := SizeOf(TBitmapInfo);
     BmpInfo := AllocMem(HeaderSize);

     with BmpInfo^.bmiHeader do
     begin
          biSize := SizeOf(TBitmapInfoHeader);
          biWidth := Width;
          biHeight := -Height;
          biPlanes := 1;
          biBitCount := 24; //always convert to 8 bit image
          biCompression := BI_RGB;
          biClrUsed := 0;
          biClrImportant := 0;
     end;

   //if the height is positive the bitmap is Bottom up so flip it.
   if BmpInfo^.bmiHeader.biHeight < 0 then begin
		FlipBits(Bits, Width*3, Height);
      BmpInfo^.bmiHeader.biHeight := -BmpInfo^.bmiHeader.biHeight;
   end;

   FillChar (Header, sizeof(TBitmapFileHeader), 0);
   with Header do begin
		bfType := $4D42;
      bfSize := 1078+Width*Height*3-1024;
      bfOffBits := 1078-1024;
   end;

	fh := FileCreate(FileName);
   FileClose(fh);

	//Initialise and open file
   Stream := TFileStream.Create(FileName, fmOpenWrite);
   //Read file Header
   Stream.WriteBuffer(Header, SizeOf(Header));
   //Read bitmap info header and validate
   Stream.WriteBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));

   //Load Bits
   //Stream.Seek(Header.bfOffBits, soFromBeginning);
   Stream.WriteBuffer(Bits^, LongInt(width * height * 3));
     //If the code gets this far the bitmap has been loaded okay
	Stream.Free;
   FreeMem ( BmpInfo);
end;

//////////////////////////////////////
//        TAnsTrueImageLib          //
//////////////////////////////////////

constructor TAnsTrueImageLib.Create;
begin
	ImageList := TList.Create;
   TransparentColor :=0;
end;

destructor TAnsTrueImageLib.Destroy;
var i : integer;
begin
	for i := 0 to ImageList.Count - 1 do TAnsTrueImage(ImageList.items[i]).Free;
	ImageList.Free;
	inherited Destroy;
end;

function  TAnsTrueImageLib.GetCount : Integer;
begin
	Result := ImageList.Count;
end;

function  TAnsTrueImageLib.GeTAnsTrueImage (Idx: Integer):TAnsTrueImage;
begin
	if Idx < ImageList.Count then Result := ImageList.items[Idx]
	else Result := nil;
end;

procedure TAnsTrueImageLib.SetTransparentColor (Value: Integer);
var
   i : Integer;
   ansimage : TAnsTrueImage;
begin
   FTransparentColor := Value and $00FFFFFF;
   for i := 0 to ImageList.Count -1 do begin
      ansimage := ImageList[i];
      ansimage.TransparentColor := FTransparentColor;
   end;
end;

procedure TAnsTrueImageLib.Clear;
var i : Integer;
	AnsImage : TAnsTrueImage;
begin
	for i := 0 to ImageList.Count-1 do begin
   	AnsImage := ImageList.Items[i];
      AnsImage.Free;
   end;
   ImageList.Clear;
end;

procedure TAnsTrueImageLib.AddImage (AImage: TAnsTrueImage);
begin
	ImageList.add (AImage);
   AImage.TransParentColor := FTransParentColor;
end;

procedure TAnsTrueImageLib.DeleteImage (Idx: Integer);
begin
	if Idx < ImageList.Count then begin
   	TAnsTrueImage(ImageList.items[Idx]).Free;
		ImageList.Delete (Idx);
	end;
end;

procedure TAnsTrueImageLib.LoadFromFile(FileName: String);
var
   Stream: TFileStream;
   n: Integer;
   AnsImage : TAnsTrueImage;
   ImgHeader: TAnsTrueImageLibHeader;
  	FAnsHdr : TAnsTrueImageFileHeader;
   pbuf : pbyte;
begin
   Stream := TFileStream.Create(FileName, fmOpenRead);

   for n := 0 to ImageList.Count - 1 do TAnsTrueImage(ImageList.items[n]).Free;
   ImageList.Clear;

   Stream.ReadBuffer(ImgHeader, SizeOf(ImgHeader));
   FTransparentColor := ImgHeader.TransparentColor;

   if StrLIComp(PChar(ImageLibID), ImgHeader.Ident, 4) <> 0 then
     raise Exception.Create('Not a valid Image Library File');

   for n := 0 to ImgHeader.ImageCount - 1 do begin
      Stream.ReadBuffer(FAnsHdr, SizeOf(TAnsTrueImageFileHeader));
      AnsImage := TAnsTrueImage.Create ( FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);

      if AnsImage = nil then
      	raise Exception.Create('TAnsTrueImage: GemMem Failed ');

      GetMem (pbuf, AnsImage.Width * AnsImage.Height);
      Stream.ReadBuffer(pbuf^, AnsImage.Width * AnsImage.Height);

      AnsPaletteDataToAnsTrueImage (AnsImage, ImgHeader.Palette, pbuf);

      FreeMem (pbuf, AnsImage.Width * AnsImage.Height);

      AnsImage.TransparentColor := TransParentColor;
      AddImage ( AnsImage);
   end;
   Stream.Free;
end;


procedure AnsDrawTrueImage(Canvas: TCanvas; X, Y: Integer; ansImage:TAnsTrueImage);
var
   BmpInfo: PBitmapInfo;
   HeaderSize: Integer;
   Bmp: TBitmap;
   Focus: hWnd;
   dc: HDC;
begin

   if not assigned (AnsImage) then exit;

   Bmp := TBitmap.Create;
   HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
   BmpInfo := AllocMem(HeaderSize);

   with BmpInfo^.bmiHeader do begin
      biSize := SizeOf(TBitmapInfoHeader);
      biWidth := AnsImage.Width;
      biHeight := -AnsImage.Height;
      biPlanes := 1;
      biBitCount := 24; //always convert to 8 bit image
      biCompression := BI_RGB;
      biClrUsed := 0;
      biClrImportant := 0;
   end;

   Focus := GetFocus;
   dc := GetDC(Focus);
   Bmp.Handle := CreateDIBitmap(dc, BmpInfo^.bmiHeader, 0,
               Pointer(0), BmpInfo^, DIB_RGB_COLORS);

   SetDIBits( dc, Bmp.Handle, 0, AnsImage.Height, AnsImage.Bits, BmpInfo^, 0);

   ReleaseDC(Focus, DC);
   if Bmp.Handle = 0 then
      raise Exception.Create('CreateDIBitmap failed');

   FreeMem(BmpInfo, HeaderSize);
   Canvas.Draw(x,y, Bmp);
   Bmp.Free;
end;

procedure AnsStretchDrawTrueImage(Canvas: TCanvas; Rect: TRect; ansImage:TAnsTrueImage);
var
   BmpInfo: PBitmapInfo;
   HeaderSize: Integer;
   Bmp: TBitmap;
   Focus: hWnd;
   dc: HDC;
begin

   if not assigned (AnsImage) then exit;

   Bmp := TBitmap.Create;
   HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
   BmpInfo := AllocMem(HeaderSize);

   with BmpInfo^.bmiHeader do begin
      biSize := SizeOf(TBitmapInfoHeader);
      biWidth := AnsImage.Width;
      biHeight := -AnsImage.Height;
      biPlanes := 1;
      biBitCount := 24; //always convert to 8 bit image
      biCompression := BI_RGB;
      biClrUsed := 0;
      biClrImportant := 0;
   end;

   Focus := GetFocus;
   dc := GetDC(Focus);
   Bmp.Handle := CreateDIBitmap(dc, BmpInfo^.bmiHeader, 0,
               Pointer(0), BmpInfo^, DIB_RGB_COLORS);

   SetDIBits( dc, Bmp.Handle, 0, AnsImage.Height, AnsImage.Bits, BmpInfo^, 0);

   ReleaseDC(Focus, DC);
   if Bmp.Handle = 0 then
      raise Exception.Create('CreateDIBitmap failed');

   FreeMem(BmpInfo, HeaderSize);
   Canvas.StretchDraw(Rect, Bmp);
   Bmp.Free;
end;

procedure AnsPaletteDataToAnsTrueImage (AnsTrueImage: TAnsTrueImage; Palette: TImgLibPalette; pb : Pbyte);
var
   i, j, col24: integer;
   sb, db : pbyte;
   col8 : byte;
begin
   sb := pb; db := AnsTrueImage.Bits;

   for j := 0 to AnsTrueImage.Height -1 do begin
      for i := 0 to AnsTrueImage.Width -1 do begin
         col8 := sb^;
         Col24 := RGB ( Palette[col8].Blue, Palette[col8].Green, Palette[col8].Red);
         move (Col24, db^, 3);
         inc (sb);
         inc (db, 3);
      end;
   end;
end;

function  MakeSelectedImage ( AnsImage:TAnsTrueImage; Col:Integer):TAnsTrueImage;
const
   SelImage : TAnsTrueImage = nil;
var
   j, i : Integer;
   bpri, bcur, bnext : pbyte;
   sbpri, sbcur, sbnext : pbyte;
begin

   if SelImage <> nil then begin
      SelImage.Free;
      SelImage := nil;
   end;

   if SelImage = nil then begin
      SelImage := TAnsTrueImage.Create(AnsImage.Width, AnsImage.Height, AnsImage.px, AnsImage.py);
   end;

   SelImage.ClearImage(0);
   SelImage.DrawImage(AnsImage, 0, 0, FALSE);

   bnext := SelImage.Bits;

   bpri := bnext;
   inc (bnext, 3);
   bcur := bnext;
   inc ( bnext, 3);

   sbpri := bpri;
   sbcur := bcur;
   sbnext := bnext;

   for j := 0 to AnsImage.Height-1 do begin
      bpri := sbpri;
      bcur := sbcur;
      bnext := sbnext;
      for i := 0 to AnsImage.Width-1 do begin
         if (bcur^ = 0) and (bcur^ <> Col) then begin
            if (bnext^ <> 0) and (bnext^ <> Col) then bcur^ := Col;
            if (bpri^ <> 0) and (bpri^ <> Col) then bcur^ := Col;
         end;
         inc (bpri, 3);
         inc (bcur, 3);
         inc (bnext, 3);
      end;
      inc (sbpri, SelImage.Width*3);
      inc (sbcur, SelImage.Width*3);
      inc (sbnext, SelImage.Width*3);
   end;

   Result := SelImage;
end;

procedure AnsTrueImageCreateAndMove (Sour: TAnsTrueImage; var Dest: TAnsTrueImage);
begin
   Dest := TAnsTrueImage.Create ( Sour.Width, Sour.Height, Sour.Px, Sour.Py);
   Move (Sour.Bits^, Dest.Bits^, Sour.Width * Sour.Height * 3);
end;

end.
