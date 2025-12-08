Unit AnsCmp;

interface

uses SysUtils, WinTypes, WinProcs,  Classes, Forms, Lzrw1kh, AUtil32;

type

  TAtcData = record
     rIDent : array [0..3] of char;  // ATC0
     rFileName : array [0..64-1] of char;
     rChunkCount:integer;
     rDataSize : integer;
  end;
  PTAtcData = ^TAtcData;

  TAtcClass = class
  private
    SRCBuf,DSTBuf       : BufferPtr;    { defined in LZRW1KH }
    PBuffer : pbyte;
  protected
  public
    constructor Create;
    destructor  Destroy; override;
    procedure LoadFromFile (aFileName: string);
    procedure SaveToFile (aFileName: string);
    procedure SetBuffer (abufsize:integer; apb:pbyte);
    procedure GetBuffer (abufsize:integer; apb:pbyte);
    function  GetMemSize:integer;
  end;

implementation

const
  ChunkSize = 32768;
  IOBufSize = (ChunkSize + 16);

constructor TAtcClass.Create;
begin
   Getmem(SRCBuf, IOBufSize);
   Getmem(DSTBuf, IOBufSize);
   
   pbuffer := nil;
   GetMem (PBuffer, sizeof(TAtcData));
   if pbuffer <> nil then
      Fillchar (pBuffer^, sizeof(TAtcData), 0);
end;

destructor  TAtcClass.Destroy;
begin
   if pbuffer <> nil then FreeMem (pBuffer);

   Freemem(SRCBuf, IOBufSize);
   Freemem(DSTBuf, IOBufSize);

   inherited destroy;
end;

function  TAtcClass.GetMemSize:integer;
var
   patc : PTAtcData;
begin
   patc := PTAtcData (pbuffer);
   Result := sizeof(TAtcData) + patc^.rDataSize;
end;

procedure TAtcClass.LoadFromFile (aFileName: string);
var
   patc : PTAtcData;
   fbuffer, pb : pbyte;
   fsize, csize, tempsize : integer;
   Stream : TFileStream;
   SRCSize, DSTSize : LongInt;
begin
   if FileExists (aFileName) = FALSE then exit;

   fsize := File_Size (aFileName);

   GetMem (fbuffer, fsize + sizeof(TAtcData)+1024);  // 1024 => temp

   patc := PTAtcData (fbuffer);

   patc^.rIDent := 'ATC0';
   StrPCopy (patc^.rFileName, aFileName);
   patc^.rChunkCount := 0;
   patc^.rdatasize := 0;

   pb := fbuffer; inc (pb, sizeof(TAtcData));

   SRCSize := ChunkSize;

   tempsize := fsize;
   Stream := TFileStream.Create(aFileName, fmOpenRead);

   while (SRCSize = ChunkSize) do begin
//      SrcSize := Stream.Read(SrcBuf^, ChunkSize);
      if tempsize > ChunkSize then begin
         SrcSize := Stream.Read(SrcBuf^, ChunkSize);
      end else begin
         SrcSize := Stream.Read(SrcBuf^, tempsize);
      end;
      tempsize := tempsize - SrcSize;

      DSTSize := Compression(SRCBuf,DSTBuf,SRCSize);

      move (DSTSize, pb^, sizeof(word));
      inc (pb, sizeof(word));
      inc (patc^.rdatasize, sizeof(word));

      move (DSTBuf^, pb^, DSTSize);
      inc (pb, DSTSize);
      inc (patc^.rdatasize, DSTSize);

      inc (patc^.rChunkCount);
   end;
   Stream.Free;

   if pbuffer <> nil then begin FreeMem (pbuffer); pbuffer := nil; end;

   csize := sizeof(TAtcData) + patc^.rDataSize;
   GetMem (pbuffer, csize);
   move (fbuffer^, pbuffer^, csize);

   FreeMem (fbuffer);
end;

procedure TAtcClass.SaveToFile (aFileName: string);
var
   patc : PTAtcData;
   pb : pbyte;
   i : integer;
   Stream : TFileStream;
   SRCSize, DSTSize : LongInt;
begin
   patc := PTAtcData (pbuffer);

   if aFileName = '' then afileName := StrPas (patc^.rFileName);

   pb := pbuffer; inc (pb, sizeof(TAtcData));

   Stream := TFileStream.Create(aFileName, fmCreate);

   for i := 0 to patc^.rChunkCount -1 do begin
//      Application.ProcessMessages;
      SrcSize := pword(pb)^;
      inc (pb, 2);
      move (pb^, SrcBuf^, SrcSize);
      inc (pb, Srcsize);

      DSTSize := DeCompression(SRCBuf,DSTBuf,SRCSize);
      Stream.Write (DSTBuf^, DSTSize);
   end;
   Stream.Free;
end;

procedure TAtcClass.SetBuffer (abufsize:integer; apb:pbyte);
begin
   if pbuffer <> nil then FreeMem (pbuffer);
   GetMem (pbuffer, abufsize);
   move (apb^, pbuffer^, abufsize);
end;

procedure TAtcClass.GetBuffer (abufsize:integer; apb:pbyte);
begin
   if GetMemSize < abufsize then exit;
   move (pbuffer^, apb^, abufsize);
end;

end.
