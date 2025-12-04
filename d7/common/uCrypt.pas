unit uCrypt;

interface

uses
  Windows, Sysutils, Classes, ZLib;

const
//   CRYPT_PACKET_MAXSIZE = 1024;                                         //2015.07.24 在水一方 >>>>>>
  BufferSize = 4096;
  PngHeader: array[0..7] of Byte = ($89, $50, $4E, $47, $0D, $0A, $1A, $0A);
  CryPngHeader: array[0..7] of Byte = ($89, $50, $5A, $47, $0D, $0A, $1A, $0A); //2015.07.24 在水一方 <<<<<<

function EnCryption(sour, dest: pbyte; asize: integer): Integer;
function DeCryption(sour, dest: pbyte; asize: integer): Integer;
function EnCryptionBmpFile(FileName: string): TMemoryStream; //2015.07.24 在水一方 >>>>>>
function DeCryptionBmpFile(FileName: string): TMemoryStream;
function EnCryptionPngFile(FileName: string): TMemoryStream;
function DeCryptionPngFile(FileName: string): TMemoryStream;
function EnCryptionXmlFile(FileName: string): TMemoryStream;
function DeCryptionXmlFile(HexStr: string): TMemoryStream; //2015.07.24 在水一方 <<<<<<
function CompressStream(SrcStream, DesStream: TStream): Boolean;
function DeCompressStream(SrcStream, DesStream: TStream): Boolean;

implementation

///////////////////////////////////
//           Crypt
///////////////////////////////////

var
  CurrentRandom: integer = 1;

  EnCryptTable: array[0..64 - 1] of byte;
  DeCryptTable: array[59..123 - 1] of byte;

function UniformRandom(aMax: integer): integer;
begin
  CurrentRandom := (1229 * CurrentRandom + 351750) mod 1664501;
  Result := CurrentRandom mod aMax;
end;

procedure Decoding3(sour, dest: Pbyte);
var
  buf: array[0..4] of byte;
  b1, b2: byte;
begin
  move(sour^, buf, 4);
  b1 := buf[0] shl 2; b2 := buf[1] shr 4;
  dest^ := b1 or b2; inc(dest);

  b1 := buf[1] shl 4; b2 := buf[2] shr 2;
  dest^ := b1 or b2; inc(dest);

  b1 := buf[2] shl 6; b2 := buf[3];
  dest^ := b1 or b2;
end;

function DeCryption(sour, dest: pbyte; asize: integer): Integer;
var
  i, nblock, dsize: integer;
  buf: array[0..65535 - 1] of byte;
begin
  if asize mod 4 <> 0 then begin
    Result := -1;
    exit;
  end;
  nblock := asize div 4;

  move(sour^, buf, asize); buf[asize] := 0;

  for i := 0 to (nblock * 4) - 1 do begin
    if (buf[i] < 59) or (buf[i] > 123 - 1) then begin
      Result := -1;
      exit;
    end; // 鞠龋拳 俊矾..
    buf[i] := DeCryptTable[buf[i]]; // buf[i] := buf[i] - $3B;
  end;

  for i := 0 to nblock - 1 do Decoding3(@buf[i * 4], PBYTE(integer(dest) + i * 3));

  dsize := nblock * 3;

  Result := dsize;
end;

procedure Encoding4(sour, dest: Pbyte);
var
  buf: array[0..4] of byte;
  b1, b2: byte;
begin
  move(sour^, buf, 3);

  dest^ := buf[0] shr 2; inc(dest);

  b1 := (buf[0] and $03) shl 4;
  b2 := (buf[1] shr 4);
  dest^ := b1 or b2; inc(dest);

  b1 := (buf[1] and $0F) shl 2;
  b2 := (buf[2] shr 6);
  dest^ := b1 or b2; inc(dest);

  dest^ := buf[2] and $3F;
end;

function EnCryption(sour, dest: pbyte; asize: integer): Integer;
var
  i, nblock: integer;
begin
  PBYTE(integer(sour) + asize)^ := 0; //   sour.data[sour.cnt] := 0;
  PBYTE(integer(sour) + asize + 1)^ := 0;
  PBYTE(integer(sour) + asize + 2)^ := 0;

  nblock := asize div 3;
  if (asize mod 3) <> 0 then nblock := nblock + 1;

  for i := 0 to nblock - 1 do begin
    Encoding4(PBYTE(integer(sour) + i * 3), PBYTE(integer(dest) + i * 4)); //Encoding4 (sour.data[i*3], @dest.data[i*4]);
    PBYTE(integer(dest) + i * 4 + 0)^ := EncryptTable[PBYTE(integer(dest) + i * 4 + 0)^]; //dest.data[i*4+0] := dest.data[i*4+0] + $3B;
    PBYTE(integer(dest) + i * 4 + 1)^ := EncryptTable[PBYTE(integer(dest) + i * 4 + 1)^]; //dest.data[i*4+1] := dest.data[i*4+1] + $3B;
    PBYTE(integer(dest) + i * 4 + 2)^ := EncryptTable[PBYTE(integer(dest) + i * 4 + 2)^]; //dest.data[i*4+2] := dest.data[i*4+2] + $3B;
    PBYTE(integer(dest) + i * 4 + 3)^ := EncryptTable[PBYTE(integer(dest) + i * 4 + 3)^]; //dest.data[i*4+3] := dest.data[i*4+3] + $3B;
  end;

  PBYTE(integer(dest) + nblock * 4)^ := 0;
  Result := nblock * 4;
end;

function CompressStream(SrcStream, DesStream: TStream): Boolean;
var
  cStream: TCompressionStream;
  Count: Integer;
  Buffer: array[0..BufferSize * 4 - 1] of Byte;
  CBuffer: array[0..BufferSize * 4 - 1] of Byte;
begin
  Result := True;
  try
    //SrcStream.Position := 0;
    cStream := TCompressionStream.Create(clMax, DesStream);
    while True do begin
      Count := SrcStream.Read(Buffer, BufferSize * 3);
      Count := EnCryption(@Buffer, @CBuffer, Count);
      if Count <> 0 then
        cStream.WriteBuffer(CBuffer, Count)
      else
        Break;
    end;
    cStream.Free;
    SrcStream.Position := 0;
    DesStream.Position := 0;
  except
    Result := False;
  end;
end;

function DeCompressStream(SrcStream, DesStream: TStream): Boolean;
var
  dStream: TDeCompressionStream;
  Count: Integer;
  Buffer: array[0..BufferSize * 4 - 1] of Byte;
  DBuffer: array[0..BufferSize * 4 - 1] of Byte;
begin
  Result := True;
  try
    //SrcStream.Position := 0;
    dStream := TDeCompressionStream.Create(SrcStream);
    while True do begin
      Count := dStream.Read(Buffer, BufferSize * 4);
      Count := DeCryption(@Buffer, @DBuffer, Count);
      if Count <> 0 then
        DesStream.WriteBuffer(DBuffer, Count)
      else
        Break;
    end;
    dStream.Free;
    SrcStream.Position := 0;
    DesStream.Position := 0;
  except
    Result := False;
  end;
end;

function EnCryptionBmpFile(FileName: string): TMemoryStream;
var
  FStream: TFileStream;
  Header: TBitmapFileHeader;
  BmpInfoHeader: TBitmapInfoHeader;
begin
  Result := nil;
  if not FileExists(FileName) then exit;
  FStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  Result := TMemoryStream.Create;
  try
    FStream.ReadBuffer(Header, SizeOf(Header));
    FStream.ReadBuffer(BmpInfoHeader, SizeOf(BmpInfoHeader));
    Header.bfType := $5A42;
    Result.WriteBuffer(Header, SizeOf(Header));
    Result.WriteBuffer(BmpInfoHeader, SizeOf(BmpInfoHeader));
    FStream.Position := 0;
    CompressStream(FStream, Result);
  finally
    FStream.Free;
  end;

end;

function DeCryptionBmpFile(FileName: string): TMemoryStream;
var
  FStream: TFileStream;
begin
  Result := nil;
  if not FileExists(FileName) then exit;
  FStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  Result := TMemoryStream.Create;
  try
    FStream.Position := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfoHeader);
    DeCompressStream(FStream, Result);
  finally
    FStream.Free;
  end;

end;

function EnCryptionPngFile(FileName: string): TMemoryStream;
var
  FStream: TFileStream;
begin
  Result := nil;
  if not FileExists(FileName) then exit;
  FStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  Result := TMemoryStream.Create;
  try
    Result.WriteBuffer(CryPngHeader, 8);
    FStream.Position := 0;
    CompressStream(FStream, Result);
  finally
    FStream.Free;
  end;

end;

function DeCryptionPngFile(FileName: string): TMemoryStream;
var
  FStream: TFileStream;
begin
  Result := nil;
  if not FileExists(FileName) then exit;
  FStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  Result := TMemoryStream.Create;
  try
    FStream.Position := 8;
    DeCompressStream(FStream, Result);
  finally
    FStream.Free;
  end;

end;

function StreamToHexStr(Stream: TStream): string;
var
  i, Count: integer;
  HexStr: string;
  Buffer: array[0..BufferSize - 1] of Byte;
  CBuffer: array[0..BufferSize * 2 - 1] of Char;
begin
  Result := '';
  while True do begin
    Count := Stream.Read(Buffer, BufferSize);
    if Count <> 0 then begin
      for i := 0 to Count - 1 do begin
        HexStr := IntToHex(Byte(Buffer[i]), 2);
        CBuffer[i * 2] := HexStr[1];
        CBuffer[i * 2 + 1] := HexStr[2];
      end;
      Result := Result + Copy(CBuffer, 0, Count * 2);
    end
    else
      Break;
  end;
end;

function HexStrToStream(pStr: string): TMemoryStream;
var
  i, Count: integer;
  HexStr: string;
  Buf: Byte;
  function hextobyte(s: string): byte;
  begin
    Result := byte(StrToInt('$' + s));
  end;
begin
  Result := nil;
  if Length(pStr) = 0 then exit;
  Result := TMemoryStream.Create;
  for i := 0 to Length(pStr) div 2 - 1 do begin
    HexStr := pStr[i * 2 + 1] + pStr[i * 2 + 2];
    Buf := hextobyte(HexStr);
    Result.Write(Buf, 1);
  end;
end;

function EnCryptionXmlFile(FileName: string): TMemoryStream;
var
  FStream: TFileStream;
  mStream: TMemoryStream;
  xmlPrefix, xmlSuffix, HexStr: string;
begin
  Result := nil;
  if not FileExists(FileName) then exit;
  FStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  Result := TMemoryStream.Create;
  mStream := TMemoryStream.Create;
  try
    xmlPrefix := ' <?xml version="1.0" encoding="UTF-8" ?>'#13#10'<CT>'#13#10;
    xmlSuffix := #13#10'</CT>';
    Result.WriteBuffer(xmlPrefix[1], Length(xmlPrefix));
    FStream.Position := 0;
    CompressStream(FStream, mStream);
    HexStr := StreamToHexStr(mStream);
    Result.WriteBuffer(HexStr[1], Length(HexStr));
    Result.WriteBuffer(xmlSuffix[1], Length(xmlSuffix));
  finally
    FStream.Free;
    mStream.Free;
  end;

end;

function DeCryptionXmlFile(HexStr: string): TMemoryStream;
var
  mStream: TMemoryStream;
begin
  Result := nil;
  mStream := HexStrToStream(HexStr);
  if mStream = nil then exit;
  Result := TMemoryStream.Create;
  try
    mStream.Position := 0;
    DeCompressStream(mStream, Result);
  finally
    mStream.Free;
  end;
end;

procedure InitCryptTable;
var
  i, idx, n: integer;
  List: TList;
begin
  List := TList.Create;
  for i := 0 to 64 - 1 do List.Add(TObject(i));

  CurrentRandom := 1;

  for i := 0 to 64 - 1 do begin
    idx := UniformRandom(List.Count);
    n := Integer(List[idx]); List.Delete(idx);
    EnCryptTable[i] := n + $3B;
    DeCryptTable[EnCryptTable[i]] := i;
  end;
  List.Free;
end;


initialization
  begin
    InitCryptTable;
  end;

finalization
  begin
  end;

end.

