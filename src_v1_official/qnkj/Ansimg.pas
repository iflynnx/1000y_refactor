unit AnsImg;

interface

uses
  Windows, SysUtils, Classes, Graphics, BmpUtil;

const
     ImageLibID = 'ATZ0';

type

  TAnsImageFileHeader = record
    Width: Integer;
    Height: Integer;
    px, py : Integer;
    none : Integer;
  end;

  TAnsImage = class
  	private
   protected
   public
      px, py : integer;
    	Width, Height: Integer;
      Bits : PByte;
      TransparentColor : byte;
		constructor Create(AWidth, AHeight, Apx, Apy:Integer);
    	destructor Destroy; override;
      procedure DrawImage (AnsImage: TAnsImage; x, y: Integer; aTrans: Boolean);
      procedure DrawImageOver (AnsImage: TAnsImage; x, y: Integer);
      procedure GetImage  (AnsImage: TAnsImage; x, y: Integer);
      procedure hLine (x, y, w: Integer; Col:Byte);
      procedure vLine (x, y, h: Integer; Col:Byte);
      procedure Clear ( Color: byte);
		procedure SaveToFile(FileName: String; Palette: TImgLibPalette);
		procedure LoadFromFile (FileName: String; var Palette: TImgLibPalette);
      procedure Optimize;
   published
  end;

  TAnsImageLib = class
  	private
      ImageList : TList;
      FTransparentColor : byte;
		function  GetAnsImage (Idx: Integer):TAnsImage;
		function  GetCount : Integer;
      procedure SetTransparentColor (Value: byte);
   protected
   public
    	Palette: TImgLibPalette;
		constructor Create;
    	destructor Destroy; override;
		procedure Clear;
		procedure AddImage (AImage: TAnsImage);
		procedure DeleteImage (Idx: Integer);
		procedure InsertImage (Idx: Integer; AImage: TAnsImage);
    	procedure LoadFromFile(FileName: String);
    	procedure SaveToFile(FileName: String);

    	procedure LoadFromStream(Stream: TFileStream);
    	procedure SaveToStream(Stream: TFileStream);
    	property  TransParentColor : byte read FTransparentColor write SetTransparentColor;
      
    	property Images[Index: Integer]: TAnsImage read GetAnsImage;
    	property Count : Integer read GetCount;
   published
  end;

function  GetNearestColor (var Palette: TImgLibPalette; r,g,b:byte):byte;
procedure CopyAnsImage ( var Sour, Dest: TAnsImage);
procedure AnsDrawImage(Palette: TImgLibPalette; Canvas: TCanvas; X, Y: Integer; ansImage:TAnsImage);
procedure AnsStretchDrawImage(Palette: TImgLibPalette; Canvas: TCanvas; Rect : TRect; ansImage:TAnsImage);

implementation


///////////////////////////////
//        TAnsImage          //
///////////////////////////////

constructor TAnsImage.Create(AWidth, AHeight, Apx, Apy: Integer);
begin
	TransparentColor := 0;
	Width := WidthBytes(AWidth); Height := AHeight;
   px := Apx;                   py := Apy;
	Bits := nil;
	GetMem (Bits, Width*Height);
   if Bits = nil then raise Exception.Create('TAnsImage: GemMem Failed for Bits');
   FillChar (Bits^, Width*Height, TransparentColor)
end;

destructor TAnsImage.Destroy;
begin
   if Bits <> nil then FreeMem ( Bits, Width*Height);
	inherited Destroy;
end;

procedure TAnsImage.Clear (Color: byte);
begin
   FillChar ( Bits^, Width*Height, Color);
end;

procedure TAnsImage.hLine (x, y, w: Integer; Col: byte);
var
   i : integer;
   pb : pbyte;
begin
   pb := Bits;
   inc (pb, x + y * Width);
   for i := 0 to w-1 do begin
      pb^ := Col;
      inc (pb);
   end;
end;

procedure TAnsImage.vLine (x, y, h: Integer; Col: byte);
var
   i : integer;
   pb : pbyte;
begin
   pb := Bits;
   inc (pb, x + y * Width);
   for i := 0 to h-1 do begin
      pb^ := Col;
      inc (pb, width);
   end;
end;

procedure TAnsImage.Optimize;
var
   x, y, minx, maxx, miny, maxy, w, h : Integer;
   i, j: Integer;
   pb, spb, dpb, TempBits: pbyte;
begin
   minx := width-1; maxx := 0; miny := height-1; maxy := 0;

   pb := Bits;
   for i := 0 to (width * height)-1 do begin
      if pb^ <> TransParentColor then begin
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
      FreeMem ( Bits, Width*Height);
      Width := 4; Height := 4;
      GetMem (Bits, Width*Height);
      FillChar (Bits^, 16, TransParentColor);
   end else begin
      w := WidthBytes(Maxx - Minx +1);
      h := Maxy - Miny +1;
      GetMem ( TempBits, w * h);

      spb := Bits;
      inc (spb, minx+miny * Width);
      dpb := TempBits;
      for j := 0 to h -1 do begin
         move ( spb^, dpb^, w);
         inc (spb, Width);
         inc (dpb, w);
      end;

      FreeMem (Bits, Width*Height);
      Width := w; Height := h;
      Bits := TempBits;
      px := px + Minx;
      py := py + Miny;
   end;
end;

procedure TAnsImage.DrawImage (AnsImage: TAnsImage; x, y: Integer; aTrans: Boolean);
var
	spb, dpb, TempSS, TempDD : pbyte;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   //do clipping
   sr := Rect(x,y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   dr := Rect(0,0, Width-1, Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := AnsImage.Bits;
   inc (spb, (ir.left-x)+(ir.top-y)*AnsImage.Width);

   dpb := Bits;
   inc (dpb, ir.left+ir.top*Width);

   if aTrans then begin
      for i := 0 to ir.Bottom-ir.Top do begin
      	TempSS := spb; TempDD := dpb;
      	for j := 0 to (ir.right-ir.left+1)-1 do begin
         	if TempSS^ <> AnsImage.TransparentColor then TempDD^ := TempSS^;
            inc (TempSS); Inc (TempDD);
         end;
         inc (spb, AnsImage.Width);
         inc (dpb, Width);
      end;
   end else begin
      for i := 0 to ir.Bottom-ir.Top do begin
         move (spb^,dpb^, (ir.right-ir.left+1));
         inc (spb, AnsImage.Width);
         inc (dpb, Width);
      end;
   end;
end;

procedure TAnsImage.DrawImageOver (AnsImage: TAnsImage; x, y: Integer);
var
	spb, dpb, TempSS, TempDD : pbyte;
   i, j : integer;
   ir, sr, dr: TRect;
begin
   //do clipping
   sr := Rect(x,y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   dr := Rect(0,0, Width-1, Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := AnsImage.Bits;
   inc (spb, (ir.left-x)+(ir.top-y)*AnsImage.Width);

   dpb := Bits;
   inc (dpb, ir.left+ir.top*Width);

   for i := 0 to ir.Bottom-ir.Top do begin
      TempSS := spb; TempDD := dpb;
      for j := 0 to (ir.right-ir.left+1)-1 do begin
         if TempSS^ < TempDD^ then TempDD^ := TempSS^;
         inc (TempSS); Inc (TempDD);
      end;
      inc (spb, AnsImage.Width);
      inc (dpb, Width);
   end;
end;

procedure TAnsImage.GetImage  (AnsImage: TAnsImage; x, y: Integer);
var
	spb, dpb : pbyte;
   i: integer;
   ir, sr, dr: TRect;
begin
   //do clipping
   dr := Rect(x,y, x+AnsImage.Width-1, y+AnsImage.Height-1);
   sr := Rect(0,0, Width-1, Height-1);

   if not IntersectRect(ir, sr, dr) then exit;

   spb := Bits;
   inc (spb, ir.left+ir.top*Width);

   dpb := AnsImage.Bits;
   inc (dpb, (ir.left-x)+(ir.top-y)*AnsImage.Width);

   for i := 0 to ir.Bottom-ir.Top do begin
   	move (spb^,dpb^, (ir.right-ir.left+1));
      inc (spb, Width);
      inc (dpb, AnsImage.Width);
   end;
end;

//Save DIB ot File
procedure TAnsImage.SaveToFile(FileName: String; Palette: TImgLibPalette);
var
   Stream: TFileStream;
   Header: TBitmapFileHeader;
   BmpInfo : PBitMapInfo;
   BmpHeight: Integer;
   BmpWidth: Integer;
   HeaderSize, ImageSize, fh: Integer;
begin
     HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
     BmpInfo := AllocMem(HeaderSize);
     ImgLibPalToBmpInfo(Palette, BmpInfo);

     with BmpInfo^.bmiHeader do
     begin
          biSize := SizeOf(TBitmapInfoHeader);
          biWidth := Width;
          biHeight := -Height;
          biPlanes := 1;
          biBitCount := 8; //always convert to 8 bit image
          biCompression := BI_RGB;
          biClrUsed := 0;
          biClrImportant := 0;
     end;
     BmpWidth := BmpInfo^.bmiHeader.biWidth;
     BmpHeight := abs(BmpInfo^.bmiHeader.biHeight);
   ImageSize := BmpWidth * BmpHeight;
   //if the height is positive the bitmap is Bottom up so flip it.
   if BmpInfo^.bmiHeader.biHeight < 0 then begin
		FlipBits(Bits, BmpWidth, BmpHeight);
      BmpInfo^.bmiHeader.biHeight := -BmpInfo^.bmiHeader.biHeight;
   end;

   FillChar (Header, sizeof(TBitmapFileHeader), 0);
   with Header do begin
		bfType := $4D42;
      bfSize := 1078+BmpWidth*BmpHeight;
      bfOffBits := 1078;
   end;

	fh := FileCreate(FileName);
   FileClose(fh);

	//Initialise and open file
   Stream := TFileStream.Create(FileName, fmOpenWrite);
   //Read file Header
   Stream.WriteBuffer(Header, SizeOf(Header));
   //Read bitmap info header and validate
   Stream.WriteBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));

   //Load Color Table
   Stream.WriteBuffer(BmpInfo^.bmiColors, 256 * SizeOf(TRGBQuad));
   //Load Bits
   //Stream.Seek(Header.bfOffBits, soFromBeginning);
   Stream.WriteBuffer(Bits^, LongInt(ImageSize));
     //If the code gets this far the bitmap has been loaded okay
	Stream.Free;
   FreeMem ( BmpInfo);
end;

//Load DIB ot File
procedure TAnsImage.LoadFromFile (FileName: String; var Palette: TImgLibPalette);
var
	BmpInfo : PBitMapInfo;
   Bmpbits, sb, db : Pbyte;
   headerSize, ImageSize, i : Integer;
begin
	BmpInfo := nil; BmpBits := nil;

	LoadDIB256 ( FileName, BmpInfo, BmpBits, HeaderSize, ImageSize);
   if BmpInfo = nil then exit;
   if BmpBits = nil then exit;

   if Bits <> nil then FreeMem ( Bits, Width*Height);

   Width := WidthBytes(BmpInfo^.bmiHeader.biWidth);
   Height := Abs(BmpInfo^.bmiHeader.biHeight);
	BmpInfoToImgLibPal(Palette, BmpInfo);

	GetMem (Bits, Width*Height);
   if Bits = nil then raise Exception.Create('TAnsImage: GemMem Failed for Bits');
   FillChar (Bits^, Width*Height, TransparentColor);

   sb := BmpBits; db := Bits;

   for i := 0 to Height -1 do begin
      move (sb^, db^, BmpInfo^.bmiHeader.biWidth);
      inc (sb, Width); inc (db, Width);
   end;
   FreeMem ( Bmpbits);

   FreeMem ( BmpInfo);
end;



///////////////////////////////
//        TAnsImageLib       //
///////////////////////////////

constructor TAnsImageLib.Create;
begin
	ImageList := TList.Create;
	FTransparentColor := 0;
end;

destructor TAnsImageLib.Destroy;
var i : integer;
begin
	for i := 0 to ImageList.Count - 1 do TAnsImage(ImageList.items[i]).Free;
	ImageList.Free;
	inherited Destroy;
end;

function  TAnsImageLib.GetCount : Integer;
begin
	Result := ImageList.Count;
end;

function  TAnsImageLib.GetAnsImage (Idx: Integer):TAnsImage;
begin
	if Idx < ImageList.Count then Result := ImageList.items[Idx]
	else Result := nil;
end;

procedure TAnsImageLib.SetTransparentColor (Value: byte);
var
   i : Integer;
   ansimage : TAnsImage;
begin
   FTransparentColor := Value;
   for i := 0 to ImageList.Count -1 do begin
      ansimage := ImageList[i];
      ansimage.TransparentColor := Value;
   end;
end;

procedure TAnsImageLib.Clear;
var
   i : Integer;
	AnsImage : TAnsImage;
begin
	for i := 0 to ImageList.Count-1 do begin
   	AnsImage := ImageList.Items[i];
      AnsImage.Free;
   end;
   ImageList.Clear;
end;

procedure TAnsImageLib.AddImage (AImage: TAnsImage);
begin
	ImageList.add (AImage);
   AImage.TransParentColor := FTransParentColor;
end;

procedure TAnsImageLib.InsertImage (Idx: Integer; AImage: TAnsImage);
begin
	ImageList.Insert ( Idx, AImage);
   AImage.TransParentColor := FTransParentColor;
end;

procedure TAnsImageLib.DeleteImage (Idx: Integer);
begin
	if Idx < ImageList.Count then begin
   	TAnsImage(ImageList.items[Idx]).Free;
		ImageList.Delete (Idx);
	end;
end;

procedure TAnsImageLib.LoadFromFile(FileName: String);
var Stream: TFileStream;
begin
   Stream := TFileStream.Create(FileName, fmOpenRead);
   LoadFromStream(Stream);
   Stream.Free;
end;

procedure TAnsImageLib.SaveToFile(FileName: String);
var Stream: TFileStream;
begin
   Stream  := TFileStream.Create(FileName, fmCreate);
   SaveToStream(Stream);
   Stream.Free;
end;

procedure TAnsImageLib.LoadFromStream(Stream: TFileStream);
var
   n: Integer;
   AnsImage : TAnsImage;
   ImgHeader: TImgLibHeader;
  	FAnsHdr : TAnsImageFileHeader;
begin
   for n := 0 to ImageList.Count - 1 do TAnsImage(ImageList.items[n]).Free;
   ImageList.Clear;

   Stream.ReadBuffer(ImgHeader, SizeOf(ImgHeader));
   FTransparentColor := ImgHeader.TransparentColor;

   if StrLIComp(PChar(ImageLibID), ImgHeader.Ident, 4) <> 0 then
     raise Exception.Create('Not a valid Image Library File');
   Palette := ImgHeader.Palette;
   for n := 0 to ImgHeader.ImageCount - 1 do begin
      Stream.ReadBuffer(FAnsHdr, SizeOf(TAnsImageFileHeader));
      AnsImage := TAnsImage.Create ( FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
      if AnsImage = nil then
      	raise Exception.Create('TAnsImage: GemMem Failed ');
      AnsImage.TransparentColor := FTransparentColor;

      Stream.ReadBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height);
      AddImage ( AnsImage);
   end;
end;

procedure TAnsImageLib.SaveToStream(Stream: TFileStream);
var
   n: Integer;
   AnsImage: TAnsImage;
   fAnsHdr: TAnsImageFileHeader;
   ImgHeader: TImgLibHeader;
begin
   with ImgHeader do begin
   	Ident := 'ATZ0';
   	ImageCount := ImageList.Count;
      TransparentColor := Self.TransparentColor;
      Palette := Self.Palette;
   end;

   Stream.WriteBuffer(ImgHeader, SizeOf(ImgHeader));
   for n := 0 to ImgHeader.ImageCount - 1 do begin
      AnsImage := ImageList.items[n];
      fAnsHdr.Width := AnsImage.Width;
      fAnsHdr.Height := AnsImage.Height;
      fAnsHdr.Px := AnsImage.Px;
      fAnsHdr.Py := AnsImage.Py;
      Stream.WriteBuffer(fAnsHdr, SizeOf(TAnsImageFileHeader));
      Stream.WriteBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height);
  end;
end;



////////////////////////////////////////
//                                    //
//           AnsDrawImage             //
//                                    //
////////////////////////////////////////

function  GetNearestColor (var Palette: TImgLibPalette; r,g,b:byte):byte;
var Col : TImgLibColor;
begin
   Col.Red := r;
   Col.Blue := b;
   Col.Green := g;
   Result := GetNearestRGB (Palette, Col);
end;

procedure AnsDrawImage(Palette: TImgLibPalette; Canvas: TCanvas; X, Y: Integer; ansImage:TAnsImage);
var
   BmpInfo: PBitmapInfo;
   HeaderSize: Integer;
   Bmp: TBitmap;
begin
   if not assigned (AnsImage) then exit;

     Bmp := TBitmap.Create;
     HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
     BmpInfo := AllocMem(HeaderSize);
     //First Get Colours
     ImgLibPalToBmpInfo(Palette, BmpInfo);
     with BmpInfo^.bmiHeader do
     begin
          biSize := SizeOf(TBitmapInfoHeader);
          biWidth := AnsImage.Width;
          biHeight := -AnsImage.Height;
          biPlanes := 1;
          biBitCount := 8; //always convert to 8 bit image
          biCompression := BI_RGB;
          biClrUsed := 0;
          biClrImportant := 0;
     end;
     CreateDIB256(Bmp, BmpInfo, AnsImage.Bits);
     //CleanUp
     FreeMem(BmpInfo, HeaderSize);
     Canvas.Draw(x,y, Bmp);
     Bmp.Free;
end;

procedure AnsStretchDrawImage(Palette: TImgLibPalette; Canvas: TCanvas; Rect: TRect; ansImage:TAnsImage);
var
   BmpInfo: PBitmapInfo;
   HeaderSize: Integer;
   Bmp: TBitmap;
begin
   if not assigned (AnsImage) then exit;

     Bmp := TBitmap.Create;
     HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
     BmpInfo := AllocMem(HeaderSize);
     //First Get Colours
     ImgLibPalToBmpInfo(Palette, BmpInfo);
     with BmpInfo^.bmiHeader do
     begin
          biSize := SizeOf(TBitmapInfoHeader);
          biWidth := AnsImage.Width;
          biHeight := -AnsImage.Height;
          biPlanes := 1;
          biBitCount := 8; //always convert to 8 bit image
          biCompression := BI_RGB;
          biClrUsed := 0;
          biClrImportant := 0;
     end;
     CreateDIB256(Bmp, BmpInfo, AnsImage.Bits);

     //CleanUp
     FreeMem(BmpInfo, HeaderSize);
     Canvas.StretchDraw(Rect, Bmp);
     Bmp.Free;
end;

procedure CopyAnsImage ( var Sour, Dest: TAnsImage);
begin
   dest := TansImage.Create ( Sour.Width, sour.height, sour.px, sour.py);
   move ( sour.bits^, dest.bits^, sour.Width * sour.Height);
end;

end.
