unit Acibfile;

interface

uses
   SysUtils, Graphics, classes, jpeg, zlib, Winsock;
const
   CIBFileAIDIdent = 'cib0';
type
  TCIBFileAHeader = record
    IDent : array[0..3] of Char;
    filedate : array[0..32-1] of Char;
    imagesize : integer;
    saydatasize : integer;
  end;

  TCIBfileA = class
    private
      CIBFileHeader : TCIBfileAHeader;
      sayDataList : TStringList;
      CImage : TBitmap;
      function  SetFileDate: string;
    protected
    public
      constructor Create;
      destructor Destroy; override;

      procedure  Clear;
      procedure  LoadFromFile (aFileName : string);
      procedure  saveToFile (aFileName, aname, server: string; Image: TBitmap; SayDataList: TStringList);

      procedure  ReadBitmap (abitmap : TBitmap);
      procedure  ReadSayData (aSayData : TStringList);
      function   GetFileDate: string;
  end;


implementation

function LocalIP: string;
type
   TaPInAddr = array [0..10] of PInAddr;
   PaPInAddr = ^TaPInAddr;
var
   phe: PHostEnt;  // HostEntry 구조체
   pptr: PaPInAddr;
   Buffer: array [0..255] of char;
   i: Integer;
begin
   LocalIP := '';
   GetHostName(Buffer, SizeOf(Buffer));
   phe := GetHostByName(buffer);
   if phe = nil then begin
      LocalIP := '127.0.0.1';
      System.Exit;
   end;
   pptr := PaPInAddr(Phe^.h_addr_list);
   i := 0;
   while pptr^[i] <> nil do begin
      LocalIP := StrPas(inet_ntoa(pptr^[i]^));
      Inc(i);
   end;
end;


constructor TCIBfileA.Create;
begin
   CImage :=TBitmap.Create;
   sayDataList := TStringList.Create;
end;

destructor  TCIBfileA.Destroy;
begin
   Clear;
   CImage.Free;
   sayDataList.Free;
   inherited Destroy;
end;

procedure   TCIBfileA.Clear;
begin
   FillChar (CIBFileHeader, sizeof(CIBFileHeader), '0');
   sayDataList.Clear;
end;

procedure   Decompression(DecompressionStream : TMemoryStream);
const
  BufferSize = 4096;
var
   Buffer: array[0..BufferSize-1] of Byte;
   Count: integer;
   ZStream: TCustomZLibStream;
   tempStream : TMemoryStream;
begin
   tempStream := TMemoryStream.Create;
   DecompressionStream.Position := 0;
   ZStream := TDecompressionStream.Create(DecompressionStream);
   try
      while True do begin
         begin
            fillchar (buffer, sizeof(buffer), 0);
            Count := ZStream.Read(Buffer, BufferSize);
            if Count <> 0 then tempStream.WriteBuffer(Buffer, Count) else Break;
         end;
      end;
   finally
      if ZStream <> nil then ZStream.Free;
   end;
   tempStream.Position := 0;
   DecompressionStream.SetSize(0);
   DecompressionStream.Position := 0;
   DecompressionStream.CopyFrom (tempStream, tempStream.Size);
   if tempStream <> nil then tempStream.Free;
end;

procedure   TCIBfileA.LoadFromFile(aFileName : string);
var
   cibfileStream : TFileStream;
   tempStream : TMemoryStream;
begin
   FillChar (CIBFileHeader, sizeof(CIBFileHeader), '0');

   cibfileStream := TFileStream.Create(aFileName, fmOpenRead);
   cibfileStream.ReadBuffer (CIBFileHeader, sizeof(CIBFileHeader));

   tempStream := nil;
   try
      tempStream := TMemoryStream.Create;
      tempStream.SetSize (0);
      tempStream.Position := 0;
      tempStream.CopyFrom (cibfileStream, CIBFileHeader.imagesize);
      Decompression(tempStream); // 압축풀기
      tempStream.Position := 0;
      CImage.LoadFromStream (tempStream);
   except
   end;
   if tempStream <> nil then tempStream.Free;

   // saydata
   tempStream := nil;
   try
      tempStream := TMemoryStream.Create;
      tempStream.SetSize (0);
      tempStream.Position := 0;
      tempStream.CopyFrom (cibfileStream, CIBFileHeader.saydatasize);
      Decompression(tempStream); // 압축풀기
      tempStream.Position := 0;
      SayDataList.LoadFromStream (tempStream);
   except

   end;
   if tempStream <> nil then tempStream.Free;

   if cibfileStream <> nil then cibfileStream.Free;
end;

procedure   TCIBfileA.saveToFile(aFileName, aname, server : string; Image : TBitmap; SayDataList : TStringList);
var
   str : string;
   tempList : TStringList;
   tempStream : TFileStream;
   ImageStream : TMemoryStream;
   sayStream : TMemoryStream;

   ZStream: TCustomZLibStream;
   ZtempStream : TMemoryStream;
   CompressionLevel: TCompressionLevel;
begin
   CompressionLevel := clFastest;

   ImageStream := nil;
   ZtempStream := nil;
   try
      ZtempStream := TMemoryStream.Create;
      ImageStream := TMemoryStream.Create;

      Image.SaveToStream(ztempStream);
      ZtempStream.Position := 0;
      ZStream := TCompressionStream.Create(CompressionLevel, ImageStream);
      try
         ZStream.CopyFrom(ZtempStream, 0);
      finally
         ZStream.Free;
      end;
   except
      if ImageStream <> nil then ImageStream.Free;
      if ZtempStream <> nil then ZtempStream.Free;
      exit;
   end;
   if ztempStream <> nil then ztempStream.Free;

   ZStream := nil;
   sayStream := nil;
   ZtempStream := nil;
   try
      ZtempStream := TMemoryStream.Create;
      str := '';
      str := SetFileDate;

      tempList := TStringList.Create;
      tempList.Assign (SayDataList);
      tempList.Add ('');
      tempList.Add (str);
      tempList.Add ('IP :  ' + LocalIP);
      tempList.Add ('ID :  ' + aname);
      tempList.Add ('Server :  ' + server);
      tempList.SaveToStream(ztempStream);
      tempList.Free;

      sayStream := TMemoryStream.Create;
      ZStream := TCompressionStream.Create(CompressionLevel, sayStream);
      try
         ZStream.CopyFrom(ZtempStream, 0);
      finally
         ZStream.Free;
      end;
   except
      if ZStream <> nil then ZStream.Free;
      if ztempStream <> nil then ztempStream.Free;
      if sayStream <> nil then sayStream.Free;
      exit;
   end;
   if ztempStream <> nil then ztempStream.Free;

   // Header write
   CIBFileHeader.IDent := CIBFileAIDIdent;
   StrPCopy(CIBFileHeader.filedate, str);
   CIBFileHeader.imagesize := ImageStream.Size;
   CIBFileHeader.saydatasize := sayStream.Size;

   tempStream := TFileStream.Create (aFileName, fmCreate or fmOpenReadWrite);
   tempStream.Position := 0;
   tempStream.WriteBuffer(CIBFileHeader, sizeof(CIBFileHeader));

   ImageStream.Position := 0;
   SayStream.Position := 0;
   // image saydata write
   tempStream.CopyFrom(ImageStream, CIBFileHeader.imagesize);
   tempStream.CopyFrom(sayStream, CIBFileHeader.saydatasize);

   ImageStream.Free;
   sayStream.Free;
   tempStream.Free;
end;

procedure   TCIBfileA.ReadBitmap (abitmap : TBitmap);
begin
   if CImage <> nil then abitmap.Assign (CImage);
end;

procedure   TCIBfileA.ReadSayData (aSayData : TStringList);
begin
   if sayDataList <> nil then aSayData.Assign (sayDataList);
end;


function    TCIBfileA.GetFileDate: string;
begin
   Result := CIBFileHeader.filedate;
end;

function   TCIBfileA.SetFileDate: string;
var
   year, mon, day : word;
   str : string;
begin
   str := '';
   DecodeDate(Date, year, mon, day);
   str := IntToStr(year)+'_'+IntToStr(mon)+'_'+IntToStr(day)+'_ '+TimeToStr(Time);
   Result := str;
end;

end.
