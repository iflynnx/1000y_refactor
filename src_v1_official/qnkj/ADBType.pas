unit ADBType;

interface

uses
  Windows, Messages, SysUtils, Classes, Dialogs, AUtil32;

const
     KINGDB_ID = 'ATD0';
type
  TDBFileHeader = record
     Ident : array[0..3] of char;
     RecordCount : integer;
     RecordDataSize : integer;
     RecordSize : integer;
     boSavedIndex : Boolean;
     None : array [0..31] of byte;
  end;

procedure CreateKingDbFile (aFileName: string; aRecordDataSize: integer);
procedure AppendKingDbFile (aFileName: string; aAppendCount: integer);
procedure DecreaseKingDbFile (aFileName: string; aDecreaseCount: integer);
function  GetKingDbFileRecordCount (aFileName: string): integer;
function  GetKingDbFileRecordDataCount (aFileName: string): integer;
implementation

function  GetKingDbFileRecordCount (aFileName: string): integer;
var
   DbFileHeader : TDBFileHeader;
   Stream : TFileStream;
begin
   Result := -1;
   if not FileExists (aFileName) then exit;
   Stream := TFileStream.Create (aFileName, fmOpenReadWrite);
   Stream.ReadBuffer (DbFileHeader, sizeof(DBFileHeader));
   Stream.Free;
   Result := DbFileHeader.RecordCount;
end;

function  GetKingDbFileRecordDataCount (aFileName: string): integer;
var
   DbFileHeader : TDBFileHeader;
   Stream : TFileStream;
begin
   Result := -1;
   if not FileExists (aFileName) then exit;
   Stream := TFileStream.Create (aFileName, fmOpenReadWrite);
   Stream.ReadBuffer (DbFileHeader, sizeof(DBFileHeader));
   Stream.Free;
   Result := DbFileHeader.RecordSize;
end;

procedure CreateKingDbFile (aFileName: string; aRecordDataSize: integer);
var
   DbFileHeader : TDBFileHeader;
   Stream : TFileStream;
begin
   FillChar (DbFileHeader, sizeof(TDBFileHeader), 0);
   DbFileHeader.Ident := KINGDB_ID;
   DbFileHeader.RecordCount := 0;
   DbFileHeader.RecordDataSize := aRecordDataSize;
   DbFileHeader.RecordSize := aRecordDataSize + 1;
   DbFileHeader.boSavedindex := FALSE;

   if FileExists (aFileName) then DeleteFile (aFileName);
   Stream := TFileStream.Create (aFileName, fmCreate);
   Stream.WriteBuffer (DbFileHeader, sizeof(DBFileHeader));
   Stream.Free;
end;

procedure AppendKingDbFile (aFileName: string; aAppendCount: integer);
var
   i, n: integer;
   DbFileHeader : TDBFileHeader;
   Stream : TFileStream;
   Buffer : array [0..16384] of byte;
begin
   if not FileExists (aFileName) then exit;

   Stream := TFileStream.Create (aFileName, fmOpenReadWrite);
   Stream.ReadBuffer (DbFileHeader, sizeof(DBFileHeader));
   FillChar (Buffer, sizeof(Buffer), 0);
   n := sizeof(DbFileHeader) + DbFileHeader.RecordSize * DbFileHeader.RecordCount;
   Stream.Seek (n, soFromBeginning);
   for i := 0 to aAppendCount -1 do Stream.WriteBuffer (Buffer, DbFileHeader.RecordSize);
   Stream.Seek (0, soFromBeginning);
   DbFileHeader.RecordCount := DbFileHeader.RecordCount + aAppendCount;
   DbFileHeader.boSavedIndex := FALSE;
   Stream.WriteBuffer (DbFileHeader, sizeof(DBFileHeader));
   Stream.Free;
end;

procedure DecreaseKingDbFile (aFileName: string; aDecreaseCount: integer);
var
   DbFileHeader : TDBFileHeader;
   Stream : TFileStream;
begin
   if not FileExists (aFileName) then exit;

   Stream := TFileStream.Create (aFileName, fmOpenReadWrite);
   Stream.ReadBuffer (DbFileHeader, sizeof(DBFileHeader));
   Stream.Seek (0, 0);
   DbFileHeader.RecordCount := DbFileHeader.RecordCount - aDecreaseCount;
   DbFileHeader.boSavedIndex := FALSE;
   Stream.WriteBuffer (DbfileHeader, sizeof(DbFileHeader));
   Stream.Size := Stream.Size - aDecreaseCount * DbFileHeader.RecordSize;
   Stream.Free;
end;

end.
