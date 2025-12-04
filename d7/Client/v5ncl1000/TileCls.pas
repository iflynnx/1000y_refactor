unit TileCls;

interface

uses Windows, SysUtils, Classes, BmpUtil, A2Img, Autil32, Dialogs;

const
  TileLibId = 'ATZTIL2';

  TileHeaderFileID = 'TILHDF';

  TILE_MAX_COUNT = 4096 + 1024;
  CELL_MAX_COUNT = 64;

  TILETYPE_RANDOM = 0;
  TILETYPE_ANIMATION = 1;
  TILETYPE_OVER = 2;

  UsedCheckTickDelay = 30000;
  UsedCheckDataTickDelay = 20000;

  FreeCountMAXSIZE = 5;
type
  TFileTileHeader = record
    Ident: array[0..7] of char;
    NTile: Integer;
    FilePos: array[0..1024 - 1] of integer;
  end;

  TTileData = record
    TileId: integer;
    Style: byte;
    nWCell, nHCell: Integer;
    nBlock: integer;
    TileWidth, TileHeight: Integer;
    MBuffer: array[0..CELL_MAX_COUNT - 1] of byte;
    AniDelay: DWORD;
    None: array[0..4 - 1] of integer;
    Bits: PTAns2Color;
  end;
  PTTileData = ^TTileData;

  TTileDataList = class
  private
    FStream: TFileStream;
    TempImgClear: TA2Image;
        //  SaveBits:PTAns2Color;
    DataList: TList;
    TempTileAnsImage: TA2Image;
    FFileName: string;
    UsedCheckTick: integer;

    DataPosArr: array[0..TILE_MAX_COUNT - 1] of integer;
    UsedTickBuffer: array[0..TILE_MAX_COUNT - 1] of integer;

    FreeCount: integer;
    FHaveHDF: Boolean;
    function GetCount: integer;
    function GetTileData(Index: Integer): PTTileData;
    procedure ReFreshDataPos;

    procedure LoadFromHeaderFile(aFileName: string);
    procedure LoadFromFile(aFileName: string);

    procedure LoadFromHeaderPgk(aFileName: string);
    procedure LoadFrompgk(aFileName: string);
  public
        //  fStream:TMemoryStream;
    constructor Create;
    destructor Destroy; override;

    procedure LoadFrom(aFileName: string);
    procedure SaveToFile(aFileName: string);

    function GetTileImage(index, pos, CurTick: integer): TA2Image;
        //function Add(pTileData:PTTileData):Boolean;
        //procedure Delete(Index:Integer);
    procedure Clear;
    procedure UsedTickUpdate(CurTick: integer);

    property Items[Index: Integer]: PTTileData read GetTileData; default;
    property Count: integer read GetCount;
  end;

var
  TileDataList: TTileDataList;

implementation
uses filepgkclass;
const
  G_MapDataPath = '.\map\';
  //XorKey: array[0..10] of Byte = ($A1, $B7, $AC, $57, $1C, $63, $3B, $81, $57, $1C, $63); //字符串加密用 old
  XorKey: array[0..10] of Byte = ($A2, $B8, $AC, $68, $2C, $74, $4B, $92, $68, $2C, $64); //字符串加密用

//在程序里加入以下两个函数，

function Dec(Str: string): string; //字符解密函數
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) div 2 do
  begin
    Result := Result + Char(StrToInt('$' + Copy(Str, i * 2 - 1, 2)) xor XorKey[j]);
    j := (j + 1) mod 11;
  end;
end;

function Enc(Str: string): string; //字符加密函數 這是用的一個異或加密
var
  i, j: Integer;
begin
  Result := '';
  j := 0;
  for i := 1 to Length(Str) do
  begin
    Result := Result + IntToHex(Byte(Str[i]) xor XorKey[j], 2);
    j := (j + 1) mod 11;
  end;
end;

constructor TTileDataList.Create;
begin
  fStream := nil;
  FFileName := '';
  DataList := TList.Create;
  TempTileAnsImage := TA2Image.Create(32, 24, 0, 0);
  TempImgClear := TA2Image.Create(32, 24, 0, 0);
  Clear;
  Fillchar(UsedTickBuffer, sizeof(UsedTickBuffer), 0);
  UsedCheckTick := 0;
  FreeCount := 0;
end;

destructor TTileDataList.Destroy;
begin

  Clear;
  DataList.Free;
  TempTileAnsImage.Free;
  TempImgClear.Free;
  inherited Destroy;
end;

procedure ResizeTile(sour, dest: PTAns2Color; ow, oh, nw, nh: integer; var px, py: integer);
var
  spb, dpb: PTAns2Color;
  i, j, x, y: integer;
begin
  FillChar(dest^, nw * nh * Sizeof(TAns2Color), 0);

  for j := 0 to nh - 1 do
  begin
    for i := 0 to nw - 1 do
    begin
      x := i * ow div nw;
      y := j * oh div nh;
      spb := sour;
      inc(spb, x + y * ow);
      dpb := dest;
      inc(dpb, i + j * nw);
      dpb^ := spb^;
    end;
  end;
  px := px * nw div ow;
  py := py * nh div oh;
end;

procedure TTileDataList.ReFreshDataPos;
var
  i: integer;
  pt: PTTileData;
begin
  FillChar(DataPosArr, sizeof(DataPosArr), $FF);
  for i := 0 to DataList.Count - 1 do
  begin
    pt := DataList[i];
    DataPosArr[pt^.TileId] := i;
  end;
end;

procedure TTileDataList.Clear;
var
  i: Integer;
  pTileData: PTTileData;
begin
  if fStream <> nil then fStream.free;
  fStream := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    pTileData := Datalist[i];
    if pTileData^.Bits <> nil then FreeMem(pTileData^.Bits);
    Dispose(pTileData);
  end;
  DataList.Clear;
  ReFreshDataPos;
end;

procedure TTileDataList.UsedTickUpdate(CurTick: integer);
var
  i: Integer;
  pTileData: PTTileData;
begin
  if FFileName = '' then exit;
  if CurTick > UsedCheckTick + UsedCheckTickdelay then
  begin
    UsedCheckTick := CurTick;
    for i := FreeCount to FreeCount + FreeCountMAXSIZE - 1 do
    begin
      if CurTick > UsedTickBuffer[i] + UsedCheckDataTickDelay then
      begin
        if DataList.Count - 1 < i then
        begin
          FreeCount := 0;
          break;
        end;
        pTileData := Datalist[i];
        if pTileData = nil then continue;
        if pTileData^.Bits <> nil then FreeMem(pTileData^.Bits);
        pTileData^.Bits := nil;
        UsedTickBuffer[i] := CurTick;
      end;
    end;
    inc(FreeCount, FreeCountMAXSIZE);
    if FreeCount + FreeCountMAXSIZE > DataList.Count - 1 then FreeCount := 0;
  end;
end;

procedure TTileDataList.SaveToFile(aFileName: string);
var
  i: Integer;
  Stream: TFileStream;
  FileTileHeader: TFileTileHeader;
  pTileData: PTTileData;
  pb: pbyte;
begin {
    Stream := nil;
    try
        Stream := TFileStream.Create(aFileName + 'head', fmCreate);

        try

            FileTileHeader.Ident := TileLibId;
            FileTileHeader.NTile := DataList.Count;

            Stream.WriteBuffer(FileTileHeader, sizeof(FileTileHeader));
            for i := 0 to DataList.Count - 1 do
            begin
                pTileData := DataList[i];

                Stream.WriteBuffer(pTileData^, sizeof(TTileData));

            end;
        finally
            Stream.Free;
        end;
        for i := 0 to DataList.Count - 1 do
        begin
            pTileData := DataList[i];
            Stream := TFileStream.Create(aFileName + inttostr(i), fmCreate);

            try

                pb := fStream.Memory;
                inc(pb, pTileData^.AniDelay); //本组首地址

                with pTileData^ do
                    Stream.WriteBuffer(PB^, (TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock);
            finally
                Stream.Free;
            end;
        end;
    except
    end;
    }
end;

function TTileDataList.GetTileImage(index, pos, CurTick: integer): TA2Image;
var
  pTileData: PTTileData;
  pb: pbyte;
  asize: integer;
  tmpfilename: string;
begin
  Result := TempImgClear;
  if DataPosArr[index] = -1 then exit;

  pTiledata := DataList[DataPosArr[index]];
  if Pos > (pTileData.nWCell * pTileData.nHCell * pTileData.nBlock) then exit;

    { if fStream.Size > pTileData^.AniDelay then
     begin
         UsedTickBuffer[index] := CurTick;
         pb := fStream.Memory;
         inc(pb, pTileData^.AniDelay); //本组首地址
         inc(pb, pTileData^.tileWidth * pTileData^.TileHeight * 2 * pos);
         TempTileansImage.Setsize(pTileData^.tileWidth, pTileData^.TileHeight);
         copymemory(TempTileansImage.Bits, pb, TempTileansImage.Width * TempTileansImage.Height * 2);
     end else
     begin
         TempTileansImage.Clear(0);
         exit;
     end;
     }
  if pTiledata.Bits = nil then
  begin

    if pgkmap.Position(FFileName, asize) = false then
    begin
      tmpfilename := G_MapDataPath + Enc(AnsiUpperCase(FFileName)) + '.dt';
      if FileExists(tmpfilename) = false then exit;
      if fStream = nil then
      begin
        fStream := TFileStream.Create(tmpfilename, fmOpenRead or fmShareDenyNone);
        FStream.Seek(16, 0);
      end;

      with pTileData^ do
      begin
        getmem(pb, (TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock);
        pTiledata.Bits := pointer(pb);
        fStream.Position := AniDelay; //本组 首地址
        fStream.ReadBuffer(pb^, (TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock);
      end;

    end else
    begin
      with pTileData^ do
      begin
        getmem(pb, (TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock);
        pTiledata.Bits := pointer(pb);
        pgkmap.FStream.Position := pgkmap.FStream.Position + AniDelay; //本组 首地址
        pgkmap.ReadBuffer(pb, (TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock);
      end;
    end;
  end;
  pb := pointer(pTiledata.Bits);
  inc(pb, pTileData^.tileWidth * pTileData^.TileHeight * 2 * pos);
  TempTileansImage.Setsize(pTileData^.tileWidth, pTileData^.TileHeight);
  copymemory(TempTileansImage.Bits, pb, TempTileansImage.Width * TempTileansImage.Height * 2);
  UsedTickBuffer[index] := CurTick;
  Result := TempTileAnsImage;
end;

function TTileDataList.GetCount: integer;
begin
  Result := TILE_MAX_COUNT;
end;

function TTileDataList.GetTileData(Index: Integer): PTTileData;
var
  dp: integer;
begin
  Result := nil;
  if (index > TILE_MAX_COUNT - 1) or (index < 0) then exit;
  dp := DataPosArr[Index];
  if (dp < DataList.Count) and (dp > -1) then Result := DataList[dp];
end;
{
function DataListSort(Item1, Item2:Pointer):integer;
begin
    Result := PTTileData(Item1).TileId - PTTileData(Item2).TileId;
end;

function TTileDataList.Add(pTileData:PTTileData):Boolean;
var
    i               :Integer;
    pod             :PTTileData;
begin
    Result := FALSE;
    if pTileData = nil then exit;
    for i := 0 to DataList.Count - 1 do
    begin
        pod := DataList[i];
        if (pod^.TileId = pTileData^.TileId) then exit;
    end;
    DataList.Add(pTileData);
    DataList.Sort(DataListSort);

    ReFreshDataPos;

    Result := TRUE;
end;

procedure TTileDataList.Delete(Index:Integer);
var
    dp              :integer;
begin
    if (index > TILE_MAX_COUNT - 1) or (index < 0) then exit;
    dp := DataPosArr[index];
    if (dp < DataList.Count) and (dp > -1) then
    begin
        if PTTileData(DataList[dp])^.Bits <> nil then FreeMem(PTTileData(DataList[dp])^.Bits);
        dispose(DataList[dp]);
        DataList.Delete(dp);

        ReFreshDataPos;
    end;
end;
}

procedure TTileDataList.LoadFrom(aFileName: string);
begin
  if pgkmap.isfile(aFileName) = FALSE then
  begin
    LoadFromFile(aFileName);
    exit;
  end;
  LoadFromPgk(aFileName);
end;

procedure TTileDataList.LoadFrompgk(aFileName: string);
var
  i, pos, asize: Integer;
    //  Stream          :TFileStream;
  FileTileHeader: TFileTileHeader;
  pTileData: PTTileData;
  HeaderFile, str, rdstr: string;
begin
  if pgkmap.isfile(aFileName) = FALSE then exit;
  if FFileName = aFileName then exit;
  FFileName := aFileName;

  str := ExtractFileName(aFileName);
  str := GetValidstr3(str, rdstr, '.');
  HeaderFile := ExtractFilePath(aFileName) + rdstr + '.hdf';
  if FileExists(HeaderFile) then
  begin
    LoadFromHeaderPgk(HeaderFile);
    exit;
  end;
  pos := 0;
  Clear;

    //  Stream := nil;
  try
    if pgkmap.Position(aFileName, asize) = false then exit;
    pgkmap.ReadBuffer(@FileTileHeader, sizeof(FileTileHeader));
    inc(pos, sizeof(FileTileHeader));

    if StrLIComp(PChar(TileLibId), FileTileHeader.Ident, 8) <> 0 then
      raise Exception.Create('Not a valid Tile Library File');

    for i := 0 to FileTileHeader.NTile - 1 do
    begin
      new(pTileData);
      pgkmap.ReadBuffer(pTileData, sizeof(TTileData));
      inc(pos, sizeof(TTileData));

      pTileData^.Bits := nil;
      pTileData^.AniDelay := pos;

      with pTileData^ do
      begin
        pgkmap.FStream.Seek((TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock, sofromcurrent);
        inc(pos, (TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock);
      end;

            //         with pTileData^ do GetMem (Bits, (TileWidth*TileHeight*2) * nWCell * nHCell * nBlock);
            //         with pTileData^ do Stream.ReadBuffer ( Bits^, (TileWidth*TileHeight*2) * nWCell * nHCell * nBlock);
      DataList.Add(pTileData);
    end;
    ReFreshDataPos;
  except
    Clear;
  end;

end;

procedure TTileDataList.LoadFromFile(aFileName: string);
var
  i, pos: Integer;
  Stream: TFileStream;
  FileTileHeader: TFileTileHeader;
  pTileData: PTTileData;
  HeaderFile, str, rdstr: string;
  tmpfilename: string;
  tmphdf: string;
begin
  FHaveHDF := False;
 // tmpfilename:=aFileName;
  tmpfilename := G_MapDataPath + Enc(AnsiUpperCase(aFileName)) + '.dt';

  if FileExists(tmpfilename) = FALSE then exit;
  if FFileName = aFileName then exit;
  FFileName := aFileName;

  str := ExtractFileName(aFileName);
  str := GetValidstr3(str, rdstr, '.');
  tmphdf := rdstr + '.hdf';
  tmphdf := Enc(AnsiUpperCase(tmphdf));
  HeaderFile := G_MapDataPath + tmphdf + '.dh';


  if FileExists(HeaderFile) then
  begin
    FHaveHDF := True;
    LoadFromHeaderFile(HeaderFile);
    exit;
  end;
  pos := 0;
  Clear;

  Stream := nil;
  try
    Stream := TFileStream.Create(tmpfilename, fmOpenRead or fmShareDenyNone);
    Stream.Seek(16, 0);
    Inc(pos, 16);
    Stream.ReadBuffer(FileTileHeader, sizeof(FileTileHeader));
    inc(pos, sizeof(FileTileHeader));

    if StrLIComp(PChar(TileLibId), FileTileHeader.Ident, 8) <> 0 then
      raise Exception.Create('Not a valid Tile Library File');

    for i := 0 to FileTileHeader.NTile - 1 do
    begin
      new(pTileData);
      Stream.ReadBuffer(pTileData^, sizeof(TTileData));
      inc(pos, sizeof(TTileData));

      pTileData^.Bits := nil;
      pTileData^.AniDelay := pos;

      with pTileData^ do
      begin
        Stream.Seek((TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock, sofromcurrent);
        inc(pos, (TileWidth * TileHeight * 2) * nWCell * nHCell * nBlock);
      end;

            //         with pTileData^ do GetMem (Bits, (TileWidth*TileHeight*2) * nWCell * nHCell * nBlock);
            //         with pTileData^ do Stream.ReadBuffer ( Bits^, (TileWidth*TileHeight*2) * nWCell * nHCell * nBlock);
      DataList.Add(pTileData);
    end;
    ReFreshDataPos;
  except
    Clear;
  end;
  if Stream <> nil then Stream.Free;
end;

procedure TTileDataList.LoadFromHeaderPgk(aFileName: string);
var
  i: Integer;
  Stream: TMemoryStream;
  FileTileHeader: TFileTileHeader;
  pTileData: PTTileData;
begin
  if pgkmap.isfile(aFileName) = FALSE then exit;
  Clear;
  Stream := TMemoryStream.Create;
  try

    try

      pgkmap.get(aFileName, Stream);
      Stream.Position := 0;
      Stream.ReadBuffer(FileTileHeader, sizeof(FileTileHeader));

      if StrLIComp(PChar(TileHeaderFileID), FileTileHeader.Ident, 8) <> 0 then
        raise Exception.Create('Not a valid Tile Library File');

      for i := 0 to FileTileHeader.NTile - 1 do
      begin
        new(pTileData);
        Stream.ReadBuffer(pTileData^, sizeof(TTileData));
        pTileData^.Bits := nil;
        DataList.Add(pTileData);
      end;
      ReFreshDataPos;
    except
      Clear;
    end;
  finally
    Stream.Free;
  end;

end;

procedure TTileDataList.LoadFromHeaderFile(aFileName: string);
var
  i: Integer;
  Stream: TFileStream;
  FileTileHeader: TFileTileHeader;
  pTileData: PTTileData;
begin
  if FileExists(aFileName) = FALSE then exit;
  Clear;
  Stream := nil;
  try
    Stream := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyNone);
    Stream.Seek(16,0);
    Stream.ReadBuffer(FileTileHeader, sizeof(FileTileHeader));

    if StrLIComp(PChar(TileHeaderFileID), FileTileHeader.Ident, 8) <> 0 then
      raise Exception.Create('Not a valid Tile Library File');

    for i := 0 to FileTileHeader.NTile - 1 do
    begin
      new(pTileData);
      Stream.ReadBuffer(pTileData^, sizeof(TTileData));
      pTileData^.Bits := nil;
      Inc(pTileData^.AniDelay, 16);
      DataList.Add(pTileData);
    end;
    ReFreshDataPos;
  except
    Clear;
  end;
  if Stream <> nil then Stream.Free;
end;

end.

