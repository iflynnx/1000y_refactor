unit ADbUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, AUtil32, AnsUnit;

type
  TBufferedFile = class
  private
   FOpened : Boolean;
   FOpenFileHandle : integer;
   BUFFERED_SIZE : integer;
   pBuffer : pbyte;
   FReadSize : integer;
   FStartPos : integer;
   FFileSize : integer;
   FFileName : string;
   function    FRead (apos: integer) : integer;
   function    FWrite: integer;
   procedure   SetOpened(value: Boolean);
  public
   constructor Create (aFileName: string);
   destructor  Destroy; override;
   function    ReadBuffer (apos, alen: integer; abuf: pbyte): integer;
   function    WriteBuffer (apos, alen: integer; abuf: pbyte): integer;
   procedure   SetBufferSize (asize: integer);
   property    Opened : Boolean read FOpened write SetOpened;
  end;

implementation

//////////////////////////////////////////////////
//             BufferedFile
//////////////////////////////////////////////////

constructor TBufferedFile.Create (aFileName: string);
begin
   FOpened := FALSE;
   FOpenFileHandle := -1;

   FFileName := '';
   FFileSize := -1;
   FStartPos := -1;
   if not FileExists (aFileName) then exit;
   FFileName := aFileName;
   FFileSize := File_Size (FFileName);

   BUFFERED_SIZE := 3072;
   GetMem (pBuffer, BUFFEREd_SIZE);

   FRead (0);
end;

destructor  TBufferedFile.Destroy;
begin
   if FStartPos <> -1 then FWrite;
   if FOpened then FileClose (FOpenFileHandle);
   FreeMem (pBuffer);
   inherited destroy;
end;

procedure   TBufferedFile.SetOpened(value: Boolean);
begin
   FWrite;
   if value = FOpened then exit;

   if FOpened then begin
      FileClose (FOpenFileHandle);
      FOpenFileHandle := -1;
   end else begin
      FOpenFileHandle := FileOpen (FFileName, fmOpenReadWrite);
   end;
   FOpened := value;
end;

function    TBufferedFile.FRead (apos: integer) : integer;
var fh : integer;
begin
   FWrite;
   Result := -1;
   if FFileSize <= 0 then exit;
   if apos >= FFileSize then exit;
   if apos < 0 then exit;

   FStartPos := apos;

   if FOpened then begin
      FileSeek (FOpenFileHandle, apos, 0);
      FReadSize := FileRead (FOpenFileHandle, pBuffer^, BUFFERED_SIZE);
   end else begin
      fh := FileOpen (FFileName, fmOpenRead);
      FileSeek (fh, apos, 0);
      FReadSize := FileRead (fh, pBuffer^, BUFFERED_SIZE);
      FileClose (fh);
   end;

   Result := FReadSize;
end;

function    TBufferedFile.FWrite : integer;
var fh : integer;
begin
   Result := -1;
   if FFileSize <= 0 then exit;
   if FStartPos = -1 then exit;

   if FOpened then begin
      FileSeek (FOpenFileHandle, FStartPos, 0);
      Result  := FileWrite (FOpenFileHandle, pBuffer^, FReadSize);
   end else begin
      fh := FileOpen (FFileName, fmOpenReadWrite);
      FileSeek (fh, FStartPos, 0);
      Result  := FileWrite (fh, pBuffer^, FReadSize);
      FileClose (fh);
   end;
   FStartPos := -1;
end;

function    TBufferedFile.ReadBuffer (apos, alen: integer; abuf: pbyte): integer;
var
   n : integer;
   pb : pbyte;
begin
   Result := -1;
   if FStartPos = -1 then FRead (apos);
   if FStartPos = -1 then exit;

   if FStartPos > apos then FRead (apos);
   if (FStartPos+FReadSize) < (apos+alen) then FRead (apos);

   if FStartPos > apos then exit;
   if (FStartPos+FReadSize) < (apos+alen) then exit;

   n := apos - FStartPos;
   pb := pBuffer;
   inc (pb, n);
   move (pb^, abuf^, alen);
   Result := alen;
end;

function    TBufferedFile.WriteBuffer (apos, alen: integer; abuf: pbyte): integer;
var
   n : integer;
   pb : pbyte;
begin
   Result := -1;
   if FStartPos = -1 then FRead (apos);
   if FStartPos = -1 then exit;

   if FStartPos > apos then FRead (apos);
   if (FStartPos+FReadSize) < (apos+alen) then FRead (apos);

   if FStartPos > apos then exit;
   if (FStartPos+FReadSize) < (apos+alen) then exit;

   n := apos - FStartPos;
   pb := pBuffer;
   inc (pb,n);
   move (abuf^, pb^, alen);
   Result := alen;
end;

procedure   TBufferedFile.SetBufferSize (asize: integer);
begin
   FWrite;
   FreeMem (pBuffer);
   GetMem (pBuffer, asize);
   BUFFERED_SIZE := asize;
end;


end.
