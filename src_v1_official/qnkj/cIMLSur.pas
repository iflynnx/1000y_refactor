unit cIMLSur;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DsgnIntf, mmsystem, DGC, BmpUtil, HUtil32;

const
     ImageLibID = 'ATZ0';

type
  TImageBuffer = record
     Index : Integer;
     LoadedTime : LongInt;
  end;
  PTImageBuffer = ^TImageBuffer;

  TImageBufferArr = array[0..MaxListSize div 4] of TImageBuffer;
  PTImageBufferArr = ^TImageBufferArr;

  TIndexTable = record
  	  DiskPos : LongInt;
     ImageSize : LongInt;
     Surface  : TDGCSurface;
  end;
  PTIndexTable = ^TIndexTable;

  TIndexTableArr = array[0..MaxListSize div 4] of TIndexTable;
  PTIndexTableArr = ^TIndexTableArr;

  TIMLSurfaceLib = class(TComponent)
  	private
    	FFileName: string;
    	FNumBuffers: Integer;
   	FScreen : TDGCScreen;
    	ImageBufferArr: PTImageBufferArr;
     	BlackSurface : TDGCSurface;
		procedure SetNumBuffers(Value: Integer);
		procedure LoadIndexFromFile(aFileName: String);
		procedure SaveIndexToFile(aFileName: String; Dt: Integer);
		procedure SetFileName(Value: string);
		procedure FreeBuffer;
		procedure AllocBuffer;
      function IsIdxOk (Idx: Integer) : Boolean;
      function CreateSurface (AScreen: TDGCScreen; ImgHdr:TImgLibImage) : TDGCSurface;
   protected

   public
    	IndexTableArr: PTIndexTableArr;
    	ImgHeader: TImgLibHeader;
		constructor Create(AOwner: TComponent); override;
    	destructor Destroy; override;
		function  GetImageData (Idx: Integer):TDGCSurface;
    	property Images[Index: Integer]: TDGCSurface read GetImageData;
   published
    	property IMLFileName: string read FFileName write SetFileName;
    	property Screen: TDGCScreen read FScreen write FScreen;
    	property NumBuffers: Integer read FNumBuffers write SetNumBuffers;

   published
end;

procedure Register;

var
   ImagesAccessFile : integer;

implementation

procedure Register;
begin
   RegisterComponents('Zura',[TIMLSurfaceLib]);
end;

constructor TIMLSurfaceLib.Create (AOwner: TComponent);
begin
	inherited Create(AOwner);
   FScreen := nil;
   BlackSurface := nil;

   GetMem (IndexTableArr, sizeof(TIndexTable));
   IndexTableArr[0].Surface := nil;

	FNumBuffers := 1;
   AllocBuffer;
end;

destructor TIMLSurfaceLib.Destroy;
begin
	FreeBuffer;                                               //      free 하면.. 에러남
	Dispose (IndexTableArr);
   if BlackSurface <> nil then BlackSurface.Free;            //
	inherited Destroy;
end;

procedure TIMLSurfaceLib.FreeBuffer;
var i,n : integer;
begin
	for i := 0 to FNumBuffers-1 do begin
      n := ImageBufferArr[i].Index;
      if n < 0 then continue;

   	with IndexTableArr[n] do begin
     		if Surface <> nil then Surface.Free;
   		Surface := nil;
      end;
   end;
   FreeMem (ImageBufferArr);
end;

procedure TIMLSurfaceLib.AllocBuffer;
var i : integer;
begin
  	GetMem (ImageBufferArr, sizeof(TImageBuffer)*FNumBuffers);
	for i := 0 to FNumBuffers-1 do begin
      ImageBufferArr[i].Index := -1;
      ImageBufferArr[i].LoadedTime := TimeGetTime;
   end;
end;

procedure TIMLSurfaceLib.SetNumBuffers(Value: Integer);
begin
	if FFileName = '' then exit;

	if Value < 1 then Value := 1
   else if Value > ImgHeader.ImageCount then Value := ImgHeader.ImageCount;
   FreeBuffer;
   FNumBuffers := Value;
   AllocBuffer;
end;

procedure TIMLSurfaceLib.SetFileName(Value: string);
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

procedure TIMLSurfaceLib.LoadIndexFromFile(aFileName: String);
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
      raise Exception.Create('TIMLSurfaceLib: GemMem Failed for FImages');

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

procedure TIMLSurfaceLib.SaveIndexToFile(aFileName: String; Dt: Integer);
var
   I, L, fh: integer;
   Stream: TFileStream;
   idxname : string;
   ImgHdr: TImgLibImage;
begin
   FreeMem ( IndexTableArr); //Remove current image list if there is one
   GetMem(IndexTableArr, ImgHeader.ImageCount * SizeOF(TIndexTable));
   if IndexTableArr = nil then
      raise Exception.Create('TIMLSurfaceLib: GemMem Failed for FImages');

   Stream := TFileStream.Create(aFileName, fmOpenRead);
   Stream.ReadBuffer(ImgHeader, SizeOf(ImgHeader));
   L := SizeOf(ImgHeader);

	for I := 0 to ImgHeader.ImageCount - 1 do begin
   	with IndexTableArr[i] do begin
         Surface := nil;
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

function TIMLSurfaceLib.IsIdxOk (Idx: Integer) : Boolean;
begin
   Result := FALSE;
   if FScreen = nil then exit;

	if BlackSurface = nil then begin
      BlackSurface := TDGCSurface.Create(FScreen.DirectDraw2, 4, 4);
      BlackSurface.OnSurfaceLost := FScreen.DoSurfaceLost;
      BlackSurface.TransparentColor := 0;
   end;
   if FFileName = '' then exit;
   if (ImgHeader.ImageCount < 0) or (ImgHeader.ImageCount <= Idx) then exit;

   Result := TRUE;
end;

function TIMLSurfaceLib.GetImageData (Idx: Integer):TDGCSurface;
var
	I, n, old: Longint;
   ImgHdr: TImgLibImage;
   Stream : TStream;
begin
   if IsIdxOk(Idx) = FALSE then begin Result := BlackSurface; exit; end;

   if IndexTableArr[Idx].Surface <> nil then begin Result := IndexTableArr[Idx].Surface; exit; end;

   Inc (ImagesAccessFile);

	old := ImageBufferArr[0].LoadedTime;
   n := 0;
   for I := 0 to FNumBuffers-1 do begin
      with ImageBufferArr[i] do begin
         if old > LoadedTime  then begin
            old := LoadedTime;
            n := I;
         end;
      end;
   end;

   with ImageBufferArr[n] do begin
      if Index <> -1 then begin
         IndexTableArr[Index].Surface.Free;
         IndexTableArr[Index].Surface := nil;
      end;
      Index := idx;
      LoadedTime := TimeGetTime;
   end;

   Stream := TFileStream.Create(FFileName, fmOpenRead);
   Stream.Seek( IndexTableArr[Idx].DiskPos, soFromBeginning);
   Stream.ReadBuffer(ImgHdr, SizeOf(TImgLibImage) - SizeOf(PByte));

   GetMem  (ImgHdr.Bits, IndexTableArr[Idx].ImageSize);
   Stream.ReadBuffer(ImgHdr.Bits^, IndexTableArr[Idx].ImageSize);
   Stream.Free;

   IndexTableArr[Idx].Surface := CreateSurface ( FScreen, ImgHdr);
   FreeMem  (ImgHdr.Bits);

   Result := IndexTableArr[Idx].Surface;
end;

function TIMLSurfaceLib.CreateSurface (AScreen: TDGCScreen; ImgHdr:TImgLibImage) : TDGCSurface;
var
	n : integer;
   Surface:TDGCSurface;
   SBits, DBits: PByte;
   SWidthBytes, DWidthBytes: Integer;
begin

   if AScreen = nil then begin Result := nil; exit; end;

   with ImgHdr do begin
      Surface := TDGCSurface.Create(AScreen.DirectDraw2, Width, Height);
      Surface.OnSurfaceLost := AScreen.DoSurfaceLost;
      SBits := Bits;
      DBits := Surface.GetPointer;
      try
         SWidthBytes := WidthBytes(Width);
         DWidthBytes := Surface.WidthBytes;
         for n := 0 to Height - 1  do
         begin
              Move(SBits^, DBits^, Width);
              Inc(SBits, SWidthBytes);
              Inc(DBits, DWidthBytes);
         end;

      finally
             Surface.ReleasePointer;
      end;
      Surface.TransparentColor := 0;
   end;
   Result := Surface;
end;

end.
