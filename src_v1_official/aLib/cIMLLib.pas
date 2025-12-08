unit cimllib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DsgnIntf, mmsystem, BmpUtil, Hutil32;

const
     ImageLibID = 'ATZ0';

type

{ TFileNameProperty
  Property editor for the TMediaPlayer.  Displays an File Open Dialog
  for the name of the media file.}

  TFileNameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TImageBuffer = record
     Index : Integer;
     LoadedTime : LongInt;
     ImgHdr : TImgLibImage;
  end;
  PTImageBuffer = ^TImageBuffer;

  TImageBufferArr = array[0..MaxListSize div 4] of TImageBuffer;
  PTImageBufferArr = ^TImageBufferArr;

  TIndexTable = record
  	  DiskPos : LongInt;
     ImageSize : LongInt;
     ImgHdr : TImgLibImage;
  end;
  PTIndexTable = ^TIndexTable;

  TIndexTableArr = array[0..MaxListSize div 4] of TIndexTable;
  PTIndexTableArr = ^TIndexTableArr;

  TIMLImageLib = class(TComponent)
  	private
    	FFileName: string;
    	FNumBuffers: Integer;
    	IndexTableArr: PTIndexTableArr;
    	ImageBufferArr: PTImageBufferArr;
      BlackImageBuffer :array [0..15] of byte;
      BlackImage : TImgLibImage;
		procedure SetNumBuffers(Value: Integer);
		procedure LoadIndexFromFile(aFileName: String);
		procedure SaveIndexToFile(aFileName: String; Dt: Integer);
		procedure SetFileName(Value: string);
		procedure FreeBuffer;
		procedure AllocBuffer;
		procedure MakeBmp (var Bmp : TBitMap; var Imghdr : TImgLibImage);
   protected
//		procedure Loaded; override;
   public
    	ImgHeader: TImgLibHeader;
		constructor Create(AOwner: TComponent); override;
    	destructor Destroy; override;
		procedure DrawImage(Canvas: TCanvas; X, Y: Integer; Idx: Integer);              // use index
		procedure DrawImage2(Canvas: TCanvas; X, Y: Integer; ImgHdr: TImgLibImage);     // use imghdr
		procedure DrawImageTrans(Canvas: TCanvas; X, Y: Integer; Idx: Integer);
		procedure DrawImageTrans2(Canvas: TCanvas; X, Y: Integer; ImgHdr: TImgLibImage);
		procedure DrawInDraw(BaseImgHdr, SrcImgHdr:TImgLibImage; X, Y: Integer; Transparent:Boolean);
		function  GetImageData (Idx: Integer):TImgLibImage;
   published
    	property IMLFileName: string read FFileName write SetFileName;
    	property NumBuffers: Integer read FNumBuffers write SetNumBuffers;
   published
end;

procedure Register;

implementation

{$R CLibreg.dcr}
uses cIMLSur;

procedure Register;
begin
   RegisterComponents('Zura',[TIMLImageLib]);
   RegisterPropertyEditor( TypeInfo(string), TIMLImageLib, 'IMLFileName', TFileNameProperty);
   RegisterPropertyEditor( TypeInfo(string), TIMLSurfaceLib, 'IMLFileName', TFileNameProperty);
end;

{ TFileNameProperty }

procedure TFileNameProperty.Edit;
var
  	OpenDlg: TOpenDialog;
begin
  	OpenDlg := TOpenDialog.Create(Application);
  	OpenDlg.Filename := '*.Atz';//GetValue;
  	OpenDlg.Options := OpenDlg.Options + [ofShowHelp, ofPathMustExist, ofFileMustExist];
  	try if OpenDlg.Execute then begin
   	OpenDlg.FileName := Copy(OpenDlg.FileName, 3, Length(OpenDlg.FileName)-2);
   	SetValue(OpenDlg.Filename);
   end;
  	finally OpenDlg.Free;
  	end;
end;

function TFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  	Result := [paDialog, paRevertable];
end;


constructor TIMLImageLib.Create (AOwner: TComponent);
begin
	inherited Create(AOwner);
   FillChar (BlackImageBuffer, 16, 0);
   with BlackImage do begin
      Width := 4;
      Height := 4;
      Name := '';
      Bits := @BlackImagebuffer;
   end;
   GetMem (IndexTableArr, sizeof(TIndexTable));
	FNumBuffers := 1;
   AllocBuffer;
end;

destructor TIMLImageLib.Destroy;
begin
	FreeBuffer;
	Dispose (IndexTableArr);
	inherited Destroy;
end;

procedure TIMLImageLib.FreeBuffer;
var i : integer;
begin
	for i := 0 to FNumBuffers-1 do begin
   	FreeMem (ImageBufferArr[i].ImgHdr.Bits);
   	ImageBufferArr[i].ImgHdr.Bits := nil;
   end;
   FreeMem (ImageBufferArr);
end;

procedure TIMLImageLib.AllocBuffer;
var i : integer;
begin
  	GetMem (ImageBufferArr, sizeof(TImageBuffer)*FNumBuffers);
	for i := 0 to FNumBuffers-1 do begin
   	GetMem (ImageBufferArr[i].ImgHdr.Bits, 1);
      ImageBufferArr[i].Index := -1;
      ImageBufferArr[i].LoadedTime := TimeGetTime;
   end;
end;

procedure TIMLImageLib.SetNumBuffers(Value: Integer);
var
   Stream: TFileStream;
 	Header: TImgLibHeader;
   I : Integer;
begin
	if FFileName = '' then exit;

	if Value < 1 then Value := 1
   else if Value > ImgHeader.ImageCount then Value := ImgHeader.ImageCount;
   FreeBuffer;
   FNumBuffers := Value;
   AllocBuffer;
end;

procedure TIMLImageLib.SetFileName(Value: string);
var
   Stream: TFileStream;
 	Header: TImgLibHeader;
begin
   Stream := TFileStream.Create(Value, fmOpenRead);
   Stream.ReadBuffer(Header, SizeOf(Header));
  	Stream.Free;
   if StrLIComp(PChar(ImageLibID), Header.Ident, 4) <> 0 then exit;
   ImgHeader := Header;
   FFileName := Value;
	LoadIndexFromFile(FFileName);
end;

procedure TIMLImageLib.LoadIndexFromFile(aFileName: String);
var
   I, L, len: LongInt;
   Stream: TFileStream;
   st, dt : Integer;
   fh : integer;
   idxname, str : string;
   makeflag : Boolean;
begin
   makeflag := FALSE;
   FreeMem ( IndexTableArr); //Remove current image list if there is one
   GetMem(IndexTableArr, ImgHeader.ImageCount * SizeOF(TIndexTable));
   if IndexTableArr = nil then
      raise Exception.Create('TIMLImageLib: GemMem Failed for FImages');

   fh := FileOpen ( aFileName, fmOpenRead);
   st := FileGetDate(fh);
   FileClose(fh);

   idxname := ChangeFileExt(aFileName, '.idx');
   len := FileSize (idxname);
   if len <> -1 then begin
      fh := FileOpen ( idxname, fmOpenRead);
      dt := FileGetDate(fh);
      FileClose(fh);
      if st <> dt then makeflag := TRUE;
   end else makeflag := TRUE;

   if makeflag then SaveIndexToFile(aFileName, st);

   Stream := TFileStream.Create(idxname, fmOpenRead);
   Stream.ReadBuffer(IndexTableArr^, ImgHeader.ImageCount * SizeOF(TIndexTable));
   Stream.Free;
end;

procedure TIMLImageLib.SaveIndexToFile(aFileName: String; Dt: Integer);
var
   I, L, fh: integer;
   Stream: TFileStream;
   idxname : string;
begin
   FreeMem ( IndexTableArr); //Remove current image list if there is one
   GetMem(IndexTableArr, ImgHeader.ImageCount * SizeOF(TIndexTable));
   if IndexTableArr = nil then
      raise Exception.Create('TIMLImageLib: GemMem Failed for FImages');

   Stream := TFileStream.Create(aFileName, fmOpenRead);
   Stream.ReadBuffer(ImgHeader, SizeOf(ImgHeader));
   L := SizeOf(ImgHeader);

	for I := 0 to ImgHeader.ImageCount - 1 do begin
   	with IndexTableArr[i] do begin
   		DiskPos := L;
         Stream.ReadBuffer(ImgHdr, SizeOf(TImgLibImage) - SizeOf(PByte));  //Read Image Header
         L := L + SizeOf(TImgLibImage) - SizeOf(PByte);
         ImageSize := WidthBytes(ImgHdr.Width) * ImgHdr.Height;
         Stream.Seek(ImageSize , soFromCurrent);
         L := L + ImageSize;
      end;
	end;
   Stream.Free;

   idxname := ChangeFileExt(aFileName, '.idx');
   L := FileSize(idxname);
   if L <> -1 then DeleteFile ( idxname);

   fh := FileCreate (idxname);
   FileWrite ( fh, IndexTableArr^, ImgHeader.ImageCount * SizeOF(TIndexTable));
   FileSetDate(fh, dt);
   FileClose (fh);
end;

function TIMLImageLib.GetImageData (Idx: Integer):TImgLibImage;
var
	I, n, old : Longint;
   Stream : TStream;
begin
   if (ImgHeader.ImageCount-1 < Idx) or  (FFileName = '') then begin Result := BlackImage; exit; end;

//	if ImgHeader.ImageCount = FNumBuffers then begin Result := ImageBufferArr[Idx].ImgHdr; exit; end;

	old := ImageBufferArr[0].LoadedTime;
   n := 0;
   for I := 0 to FNumBuffers-1 do begin
   	if Idx = ImageBufferArr[I].Index  then begin Result := ImageBufferArr[I].ImgHdr; exit; end;
   	if old > ImageBufferArr[I].LoadedTime  then begin
      	old := ImageBufferArr[I].LoadedTime;
         n := I;
   	end;
   end;

   with ImageBufferArr[n] do begin
      Index := Idx;
      LoadedTime := TimeGetTime;

      FreeMem (ImgHdr.Bits);
      GetMem  (ImgHdr.Bits, IndexTableArr[Idx].ImageSize);

      Stream := TFileStream.Create(FFileName, fmOpenRead);
      Stream.Seek( IndexTableArr[Idx].DiskPos, soFromBeginning);

     	Stream.ReadBuffer(ImgHdr, SizeOf(TImgLibImage) - SizeOf(PByte));
     	Stream.ReadBuffer(ImgHdr.Bits^, WidthBytes(ImgHdr.Width) * ImgHdr.Height);

      Stream.Free;
   end;
   Result := ImageBufferArr[n].ImgHdr;
end;

procedure TIMLImageLib.MakeBmp (var Bmp : TBitMap; var Imghdr : TImgLibImage);
var
   BmpInfo: PBitmapInfo;
   HeaderSize: Integer;
   Palette: TImgLibPalette;
begin
   HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
   BmpInfo := AllocMem(HeaderSize);
   //First Get Colours
   Palette := ImgHeader.Palette;
   ImgLibPalToBmpInfo(Palette, BmpInfo);
   with BmpInfo^.bmiHeader do begin
      biSize := SizeOf(TBitmapInfoHeader);
      biWidth := ImgHdr.Width;
      biHeight := -ImgHdr.Height;
      biPlanes := 1;
      biBitCount := 8; //always convert to 8 bit image
      biCompression := BI_RGB;
      biClrUsed := 0;
      biClrImportant := 0;
   end;
   CreateDIB256(Bmp, BmpInfo, ImgHdr.Bits);
   //CleanUp
   FreeMem(BmpInfo, HeaderSize);
end;

procedure TIMLImageLib.DrawImage(Canvas: TCanvas; X, Y: Integer; Idx: Integer);
var
   ImgHdr: TImgLibImage;
   Bmp: TBitmap;
begin
	ImgHdr := GetImageData (Idx);
   if ImgHdr.Bits = nil then exit;

   Bmp := TBitmap.Create;
   MakeBmp ( Bmp, ImgHdr);
   Canvas.Draw(x, y, Bmp);
   Bmp.Free;
end;

procedure TIMLImageLib.DrawImageTrans(Canvas: TCanvas; X, Y: Integer; Idx: Integer);
var
   ImgHdr: TImgLibImage;
   Bmp: TBitmap;
begin

	ImgHdr := GetImageData (Idx);
   if ImgHdr.Bits = nil then exit;

   Bmp := TBitmap.Create;
   MakeBmp ( Bmp, ImgHdr);
   SpliteBitmap (Canvas.Handle, X, Y, Bmp, $0);
   Bmp.Free;
end;

procedure TIMLImageLib.DrawImage2(Canvas: TCanvas; X, Y: Integer; ImgHdr: TImgLibImage);
var Bmp: TBitmap;
begin

   Bmp := TBitmap.Create;
   MakeBmp ( Bmp, ImgHdr);
   Canvas.Draw(x, y, Bmp);
   Bmp.Free;
end;

procedure TIMLImageLib.DrawImageTrans2(Canvas: TCanvas; X, Y: Integer; ImgHdr: TImgLibImage);
var Bmp: TBitmap;
begin
   Bmp := TBitmap.Create;
   MakeBmp ( Bmp, ImgHdr);
   SpliteBitmap (Canvas.Handle, X, Y, Bmp, $0);
   Bmp.Free;
end;

procedure TIMLImageLib.DrawInDraw(BaseImgHdr, SrcImgHdr:TImgLibImage; X, Y: Integer; Transparent:Boolean);
var
   r, sr, br: TRect;
   i, j : integer;
   SBits,DBits, SSBits,SDBits : pbyte;
begin
	if (x<0) and (y<0) then exit;

   //Clip Rectangle
   sr := Rect(x, y, x + SrcImgHdr.Width-1 , y + SrcImgHdr.Height-1);
   br := Rect(0, 0, BaseImgHdr.Width-1 , BaseImgHdr.Height-1);

   if not IntersectRect(r, sr, br) then exit;

   SBits := SrcImgHdr.Bits;
   DBits := BaseImgHdr.Bits;
   inc (DBits, r.left);
   inc (DBits, r.top*WidthBytes(BaseImgHdr.Width));
   SSBits := SBits;
   SDBits := DBits;

	if Transparent then begin
		for j := r.top to r.bottom do begin
         SBits := SSBits;
         DBits := SDBits;
         for i := r.left to r.right do begin
            if SBits^ <> 0 then DBits^ := SBits^;
            inc (DBits); inc (SBits);
         end;
         inc (SSBits, WidthBytes(SrcImgHdr.Width));
         inc (SDBits, WidthBytes(BaseImgHdr.Width));
      end;
   end else begin
		for j := r.top to r. bottom do begin
         SBits := SSBits;
         DBits := SDBits;
         move (SBits^, DBits^, (r.right-r.left+1));
         inc (SSBits, WidthBytes(SrcImgHdr.Width));
         inc (SDBits, WidthBytes(BaseImgHdr.Width));
      end;
   end;

end;

end.
