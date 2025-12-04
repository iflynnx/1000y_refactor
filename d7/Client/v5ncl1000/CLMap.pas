unit clmap;

interface

uses Windows, Sysutils, Classes,
  Objcls, TileCls, A2Img, Autil32, maptype, backscrn, cltype,
  deftype, Log, dialogs, uanstick;

const
  VIEWWIDTH = 11 + 4 + 4; //后面添加的是1024分辨率增加的部分  视野修改
  VIEWHEIGHT = 8 + 3 + 10;
  //VIEWWIDTH = 11 + 4; //后面添加的是1024分辨率增加的部分  视野修改
  //VIEWHEIGHT = 8 + 3;
  
type
  TMap = class
  private
    bopgk: boolean;
    fStream: TMemoryStream;
    CurMap: integer;
    MapFileName: string;
    MapWidth, MapHeight: Integer;
    MapLeft, MapTop: integer;
    MapBuffer: array[0..MAP_BLOCK_SIZE * MAP_BLOCK_SIZE * 9 - 1] of TMapCell;
    MapCellTickBuffer: array[0..MAP_BLOCK_SIZE * MAP_BLOCK_SIZE * 9 - 1] of integer;
    FMAPBack: TA2Image;
    procedure LoadBlockFromFile(afilename: string; axb, ayb, txb, tyb: integer);
    procedure LoadBlockFromStreamPgk(aStream: tStream; axb, ayb, txb, tyb: integer);
    procedure SetMapBlock(xb, yb: integer; MapBlockData: TMapBlockData);
    procedure DrawMapUPdate(CurTick: integer);
  public
    Cx, Cy: Integer;
    procedure SetCell(x, y: integer; MapCell: TMapCell);
    function GetCell(x, y: integer): TMapCell;
    function GetCell2(x, y: integer): TMapCell;

    procedure SetMapCellTick(x, y: integer; CurTick: integer);
    function GetMapCellTick(x, y: integer): integer;

    constructor Create;
    destructor Destroy; override;
    procedure SetCenter(x, y: integer);

    procedure LoadFrom(aFileName: string; ax, ay: integer);

    procedure LoadFromFile(aFileName: string; ax, ay: integer);
    procedure LoadFrompgk(aFileName: string; ax, ay: integer);
    procedure DrawMap(CurTick: integer);

    procedure DrawRoof(CurTick: integer);
    function isMovable(x, y: Integer): Boolean;
    function isFlyable(x, y: Integer): Boolean;
    function IsInArea(x, y: integer): Boolean;

    function GetMapWidth: integer;
    function GetMapHeight: integer;
    function GetMapName: string;
    property Width: integer read MapWidth write MapWidth;
    property Height: integer read MapHeight write MapHeight;
  end;
const
  MAXMAPLENGTH = 2048;
type
  TMAPmini = class
    FStream: TMemoryStream;
    MapWidth, MapHeight: Integer;
  private
    MapBuffer: array of TMapCell;
  protected

  public
    constructor Create;
    destructor Destroy; override;

    procedure SetMapBlock(xb, yb: integer; MapBlockData: TMapBlockData);
    procedure MapLoadFile(aFileName: string);
    procedure MapLoadFilePgk(aFileName: string);
    procedure miniMAP(x, y, Zoom: integer; outTA2Image: TA2Image);
    function GetMapCell(aMapBuffer: PTMapCell; x, y: integer): TMapCell;
  published

  end;

var
  Map: TMap;

implementation
uses filepgkclass, Unit_console;
const

  //XorKey: array[0..10] of Byte = ($A1, $B7, $AC, $57, $1C, $63, $3B, $81, $57, $1C, $63); //字符串加密用 old
  XorKey: array[0..10] of Byte = ($A2, $B8, $AC, $68, $2C, $74, $4B, $92, $68, $2C, $64); //字符串加密用

//在程序里加入以下两个函数，

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

function TMAPmini.GetMapCell(aMapBuffer: PTMapCell; x, y: integer): TMapCell;
begin
  if (x < 0) or (x >= MapWidth) or (y < 0) or (y >= MapHeight) then exit;
  inc(aMapBuffer, x + y * MapWidth);
  Result := aMapBuffer^;
end;

procedure TMAPmini.miniMAP(x, y, Zoom: integer; outTA2Image: TA2Image);
var
  i, j, si, ei, sj, ej: Integer;
  MapCell, OldMapCell: TMapCell;
  po: PTObjectData;
  tt, tt2: TA2Image;
begin

  si := x;
  ei := x + outTA2Image.Width - 1;
  sj := y;
  ej := y + outTA2Image.Height - 1;

  if si <= 0 then si := 0;
  if sj <= 0 then sj := 0;

  for j := sj to ej do
  begin
    for i := si to ei do
    begin
      if i >= MapWidth then continue;
      if j >= MapHeight then continue;

      MapCell := GetMapCell(@MapBuffer[0], i, j);

      if MapCell.TileId = 0 then continue;
      if MapCell.Tileid > TILE_MAX_COUNT then
      begin
                // Showmessage('TileId:' + inttostr(MapCell.Tileid));
      end;
      if MapCell.TileNumber > TILE_MAX_COUNT then
      begin
                // Showmessage('TileNumber:' + inttostr(MapCell.TileNumber));
      end;
      tt := TileDataList.GetTileImage(MapCell.Tileid, MapCell.TileNumber, 0);
      if tt = nil then Continue;
      if Zoom <> 1 then
      begin
        tt2 := TA2Image.Create(tt.Width, tt.Height, 0, 0);
        try
          tt2.DrawImage(tt, 0, 0, false);
          tt2.Resize(tt.Width div Zoom, tt.Height div Zoom);

          outTA2Image.DrawImage(tt2, (i - x) * (32 div Zoom), (j - y) * (24 div Zoom), FALSE);
        finally
          tt2.Free;
        end;
      end else
      begin
        outTA2Image.DrawImage(tt, (i - x) * (32 div Zoom), (j - y) * (24 div Zoom), FALSE);
      end;

            //            AnsDraw2Image(FSurface.Canvas, (i-MapLeft)*UNITX, (j-MapTop)*UNITY, TileDataList.GetTileImage (MapCell.Tileid, MapCell.TileNumber));
    end;
  end;

  for j := sj to ej do
  begin
    for i := si to ei do
    begin
      if i >= MapWidth then continue;
      if j >= MapHeight then continue;

      MapCell := GetMapCell(@MapBuffer[0], i, j);

      if MapCell.TileOverId = 0 then continue;
      tt := TileDataList.GetTileImage(MapCell.TileOverid, MapCell.TileOverNumber, 0);
      if tt = nil then Continue;
      if Zoom <> 1 then
      begin
        tt2 := TA2Image.Create(tt.Width, tt.Height, 0, 0);
        try
          tt2.DrawImage(tt, 0, 0, false);

          tt2.Resize(tt.Width div Zoom, tt.Height div Zoom);

          outTA2Image.DrawImage(tt2, (i - x) * (32 div Zoom), (j - y) * (24 div Zoom), TRUE);
        finally
          tt2.Free;
        end;
      end else
      begin
        outTA2Image.DrawImage(tt, (i - x) * (32 div Zoom), (j - y) * (24 div Zoom), TRUE);
      end;
            //            AnsDraw2Image(FSurface.Canvas, (i-MapLeft)*UNITX, (j-MapTop)*UNITY, TileDataList.GetTileImage (MapCell.TileOverid, MapCell.TileOverNumber));
    end;
  end;

  for j := sj to ej do
  begin
    for i := si to ei do
    begin
      if i >= MapWidth then continue;
      if j >= MapHeight then continue;

      MapCell := GetMapCell(@MapBuffer[0], i, j);

      if MapCell.ObjectId = 0 then continue;
      po := ObjectDataList[MapCell.ObjectId];

      if po = nil then Continue;
      tt := ObjectDataList.GetObjectImage(MapCell.ObjectId, 0, 0);
      if tt = nil then Continue;
      if Zoom <> 1 then
      begin
        tt2 := TA2Image.Create(tt.Width, tt.Height, 0, 0);
        try
          tt2.DrawImage(tt, 0, 0, false);
          tt2.Resize(tt.Width div Zoom, tt.Height div Zoom);

          outTA2Image.DrawImageKeyColor(tt2, (i - x) * (32 div Zoom) + (po^.ipx div Zoom), (j - y) * (24 div Zoom) + po^.Ipy div Zoom, 31, @darkentbl);

        finally
          tt2.Free;
        end;
      end else
      begin
        outTA2Image.DrawImageKeyColor(tt, (i - x) * (32 div Zoom) + (po^.ipx div Zoom), (j - y) * (24 div Zoom) + po^.Ipy div Zoom, 31, @darkentbl);

      end;
            //            if po <> nil then AnsDraw2Image(FSurface.Canvas, (i-MapLeft)*UNITX+po^.ipx, (j-MapTop)*UNITY+po^.Ipy, ObjectDataList.GetObjectImage (MapCell.ObjectId, 0));
    end;
  end;

  for j := ej downto sj do
  begin
    for i := si to ei do
    begin
      if i >= MapWidth then continue;
      if j >= MapHeight then continue;

      MapCell := GetMapCell(@MapBuffer[0], i, j);

      if MapCell.RoofId = 0 then continue;
      po := RoofDataList[MapCell.RoofId];

      if po = nil then Continue;
      tt := RoofDataList.GetObjectImage(MapCell.RoofId, 0, 0);
      if tt = nil then Continue;
      if Zoom <> 1 then
      begin
        tt2 := TA2Image.Create(tt.Width, tt.Height, 0, 0);
        try
          tt2.DrawImage(tt, 0, 0, false);
          tt2.Resize(tt.Width div Zoom, tt.Height div Zoom);

          outTA2Image.DrawImageKeyColor(tt2, (i - x) * (32 div Zoom) + po^.ipx div Zoom, (j - y) * (24 div Zoom) + po^.Ipy div Zoom, 31, @darkentbl);

        finally
          tt2.Free;
        end;
      end else
      begin
        outTA2Image.DrawImageKeyColor(tt, (i - x) * (32 div Zoom) + po^.ipx div Zoom, (j - y) * (24 div Zoom) + po^.Ipy div Zoom, 31, @darkentbl);

      end;
    end;
  end;

end;

procedure TMAPmini.MapLoadFile(aFileName: string);
var
  i, j, xb, yb: integer;
  Stream: TFileStream;
  MapInfo: TMapFileInfo;
  version: integer;
  MapBlockData: TMapBlockData;
begin

  if FileExists(aFileName) = FALSE then
  begin
        //      ShowMessage ('款康磊俊霸 楷遏窍矫扁 官而聪促. [MAP FEITBlock FALSE]');
    exit;
  end;
  begin

    Stream := TFileStream.Create(aFileName, fmOpenRead);
    Stream.ReadBuffer(MapInfo, sizeof(MapInfo));
    version := -1;
    if StrLIComp(PChar('ATZMAP2'), MapInfo.MapIdent, 8) = 0 then version := 1;
    if version = -1 then
      raise Exception.Create('Not a valid Image Library File');
    MapWidth := MapInfo.MapWidth;
    MapHeight := MapInfo.MapHeight;
    setlength(MapBuffer, MapWidth * MapHeight);
    fillchar(MapBuffer[0], sizeof(TMapCell) * MapWidth * MapHeight, 0);
    xb := MapInfo.MapWidth div MAP_BLOCK_SIZE;
    yb := MapInfo.MapHeight div MAP_BLOCK_SIZE;

    for j := 0 to yb - 1 do
    begin
      for i := 0 to xb - 1 do
      begin
        Stream.ReadBuffer(MapBlockData, sizeof(MapBlockData));
        SetMapBlock(i, j, MapBlockData);
      end;
    end;

    Stream.Free;

  end;
end;

procedure TMAPmini.MapLoadFilePgk(aFileName: string);
var
  i, j, xb, yb: integer;

  MapInfo: TMapFileInfo;
  version: integer;
  MapBlockData: TMapBlockData;
begin

  if pgkmap.isfile(aFileName) = FALSE then
  begin
        //      ShowMessage ('款康磊俊霸 楷遏窍矫扁 官而聪促. [MAP FEITBlock FALSE]');
    exit;
  end;

  begin
    pgkmap.get(aFileName, FStream);
    FStream.Position := 0;
    FStream.ReadBuffer(MapInfo, sizeof(MapInfo));

    version := -1;
    if StrLIComp(PChar('ATZMAP2'), MapInfo.MapIdent, 8) = 0 then version := 1;
    if version = -1 then
      raise Exception.Create('Not a valid Image Library File');
    MapWidth := MapInfo.MapWidth;
    MapHeight := MapInfo.MapHeight;
    setlength(MapBuffer, MapWidth * MapHeight);
    fillchar(MapBuffer[0], sizeof(TMapCell) * MapWidth * MapHeight, 0);
    xb := MapInfo.MapWidth div MAP_BLOCK_SIZE;
    yb := MapInfo.MapHeight div MAP_BLOCK_SIZE;

    for j := 0 to yb - 1 do
    begin
      for i := 0 to xb - 1 do
      begin
        FStream.ReadBuffer(MapBlockData, sizeof(TMapBlockData));
        SetMapBlock(i, j, MapBlockData);
      end;
    end;
        // FStream.Size := 0;
  end;
end;

procedure TMAPmini.SetMapBlock(xb, yb: integer; MapBlockData: TMapBlockData);
var
  i, xp, yp: integer;
begin
  for i := 0 to MAP_BLOCK_SIZE - 1 do
  begin
    xp := xb * MAP_BLOCK_SIZE;
    yp := yb * MAP_BLOCK_SIZE;
    yp := yp + i;
    move(MapBlockData.MapBufferArr[i * MAP_BLOCK_SIZE], MapBuffer[xp + yp * MapWidth], sizeof(TMapCell) * MAP_BLOCK_SIZE);
  end;
end;

constructor TMAPmini.Create;
begin
  FStream := TMemoryStream.Create;
end;

destructor TMAPmini.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

constructor TMap.Create;
begin
  FMAPBack := TA2Image.Create((VIEWWIDTH) * 2 * UNITX, (VIEWHEIGHT + 1) * 2 * UNITy, 0, 0);
  bopgk := false;
  fStream := TMemoryStream.Create;
  CurMap := 0;
  MapFileName := '';
  Cx := 12;
  Cy := 12;
  MapWidth := 100;
  MapHeight := 100;
  MapLeft := 0;
  MapTop := 0;
end;

destructor TMap.Destroy;
begin
  FMAPBack.free;
  fStream.Free;
  inherited Destroy;
end;

function TMap.GetCell2(x, y: integer): TMapCell;
begin
  FillChar(Result, sizeof(Result), 0);
  if ((x) < 0) or ((x) >= MAP_BLOCK_SIZE * 3) then exit;
  if ((y - MapTop) < 0) or ((y - MapTop) >= MAP_BLOCK_SIZE * 3) then exit;

  if (x < 0) or (x >= MapWidth) or (y < 0) or (y >= MapHeight) then exit;
  Result := MapBuffer[(x - mapleft) + (y - maptop) * MAP_BLOCK_SIZE * 3];
end;

function TMap.GetCell(x, y: integer): TMapCell;
begin
  FillChar(Result, sizeof(Result), 0);
  if ((x - MapLeft) < 0) or ((x - MapLeft) >= MAP_BLOCK_SIZE * 3) then exit;
  if ((y - MapTop) < 0) or ((y - MapTop) >= MAP_BLOCK_SIZE * 3) then exit;

  if (x < 0) or (x >= MapWidth) or (y < 0) or (y >= MapHeight) then exit;
  Result := MapBuffer[(x - mapleft) + (y - maptop) * MAP_BLOCK_SIZE * 3];
end;

procedure TMap.SetCell(x, y: integer; MapCell: TMapCell);
begin
  if ((x - MapLeft) < 0) or ((x - MapLeft) >= MAP_BLOCK_SIZE * 3) then exit;
  if ((y - MapTop) < 0) or ((y - MapTop) >= MAP_BLOCK_SIZE * 3) then exit;

  if (x < 0) or (x >= MapWidth) or (y < 0) or (y >= MapHeight) then exit;
  MapBuffer[(x - mapleft) + (y - maptop) * MAP_BLOCK_SIZE * 3] := MapCell;
end;

function TMap.GetMapCellTick(x, y: integer): integer;
begin
  FillChar(Result, sizeof(Result), 0);
  if ((x - MapLeft) < 0) or ((x - MapLeft) >= MAP_BLOCK_SIZE * 3) then exit;
  if ((y - MapTop) < 0) or ((y - MapTop) >= MAP_BLOCK_SIZE * 3) then exit;

  if (x < 0) or (x >= MapWidth) or (y < 0) or (y >= MapHeight) then exit;
  Result := MapCellTickBuffer[(x - mapleft) + (y - maptop) * MAP_BLOCK_SIZE * 3];
end;

procedure TMap.SetMapCellTick(x, y: integer; CurTick: integer);
begin
  if ((x - MapLeft) < 0) or ((x - MapLeft) >= MAP_BLOCK_SIZE * 3) then exit;
  if ((y - MapTop) < 0) or ((y - MapTop) >= MAP_BLOCK_SIZE * 3) then exit;

  if (x < 0) or (x >= MapWidth) or (y < 0) or (y >= MapHeight) then exit;
  MapCellTickBuffer[(x - mapleft) + (y - maptop) * MAP_BLOCK_SIZE * 3] := CurTick;
end;

function TMap.isMovable(x, y: Integer): Boolean;
var
  MapCell: TMapCell;
begin
  Result := TRUE;
  if (x < 0) or (y < 0) or (x >= MapWidth) or (y >= MapHeight) then
  begin
    Result := FALSE;
    exit;
  end;
  MapCell := GetCell(x, y);
  if (MapCell.boMove and 1 <> 0) or (MapCell.boMove and 2 <> 0) then Result := FALSE;
end;

function TMap.isFlyable(x, y: Integer): Boolean;
var
  MapCell: TMapCell;
begin
  Result := TRUE;
  if (x < 0) or (y < 0) or (x >= MapWidth) or (y >= MapHeight) then
  begin
    Result := FALSE;
    exit;
  end;
  MapCell := GetCell(x, y);
  if (MapCell.boMove and 2 <> 0) then Result := FALSE;
end;

procedure TMap.SetCenter(x, y: integer);
var
  flag, flagup: boolean;
begin
  flag := FALSE;
  if (cx <> x) or (cy <> y) then flagup := true else flagup := false;
  Cx := x;
  Cy := y;

  if ((Cx div MAP_BLOCK_SIZE) - 1) <> (MapLeft div MAP_BLOCK_SIZE) then flag := TRUE;
  if ((Cy div MAP_BLOCK_SIZE) - 1) <> (MapTop div MAP_BLOCK_SIZE) then flag := TRUE;

  if flag then
    if bopgk then
      LoadFromPgk(MapFileName, x, y)
    else LoadFromFile(MapFileName, x, y);
  if flagup then DrawMapUPdate(mmAnsTick);
end;

procedure TMap.DrawMapUPdate(CurTick: integer);
var
  i, j, i0, j0: integer;
  MapCell: TMapCell;
begin
  FrmConsole.cprint(lt_draw, '地表绘制' + inttostr(CurTick));
  i0 := Cx - VIEWWIDTH;
  j0 := Cy - VIEWHEIGHT - 1;
  for j := Cy - VIEWHEIGHT - 1 to Cy + VIEWHEIGHT + 1 do
  begin
    for i := Cx - VIEWWIDTH to Cx + VIEWWIDTH do
    begin
      MapCell := GetCell(i, j);
      with MapCell do
      begin
        if TileId <> 0 then
        begin
          if TileId > TILE_MAX_COUNT then continue;
          FMAPBack.DrawImage(TileDataList.GetTileImage(TileId, TileNumber, CurTick), (i - i0) * UNITX, (j - j0) * UNITY, FALSE);
        end else
          FMAPBack.DrawImage(TileDataList.GetTileImage(0, 0, CurTick), (i - i0) * UNITX, (j - j0) * UNITY, FALSE);
        if TileOverId <> 0 then
        begin
          if TileOverId > TILE_MAX_COUNT then continue;
          FMAPBack.DrawImage(TileDataList.GetTileImage(TileOverId, TileOverNumber, CurTick), (i - i0) * UNITX, (j - j0) * UNITY, TRUE);
        end;
      end;
    end;
  end;
end;

procedure TMap.DrawMap(CurTick: integer);
var
  i, j: integer;
  MapCell: TMapCell;
begin
  i := Cx - VIEWWIDTH;
  j := Cy - VIEWHEIGHT - 1;
  BackScreen.DrawImage(FMAPBack, i * UNITX, j * UNITY, FALSE);
end;

procedure TMap.DrawRoof(CurTick: integer);
var
  i, j: integer;
  MapCell: TMapCell;
begin
  for j := Cy + VIEWHEIGHT - 1 + 16 downto Cy - VIEWHEIGHT - 1 do
  begin
    for i := Cx - VIEWWIDTH to Cx + VIEWWIDTH do
    begin
      MapCell := GetCell(i, j);
      if MapCell.RoofId <> 0 then
                //BackScreen.DrawImage(RoofDataList.GetObjectImage(MapCell.RoofId, 0, CurTick), i * UNITX, j * UNITY, TRUE);
        BackScreen.DrawImageKeyColor(RoofDataList.GetObjectImage(MapCell.RoofId, 0, CurTick), i * UNITX, j * UNITY);
    end;
  end;
end;

function TMap.IsInArea(x, y: integer): Boolean;
var
  MapCell: TMapCell;
begin
  MapCell := GetCell(x, y);
  if MapCell.boMove and 4 = 4 then Result := TRUE
  else Result := FALSE;
end;

procedure TMap.SetMapBlock(xb, yb: integer; MapBlockData: TMapBlockData);
var
  i, xp, yp: integer;
begin
  for i := 0 to MAP_BLOCK_SIZE - 1 do
  begin
    xp := xb * MAP_BLOCK_SIZE;
    yp := yb * MAP_BLOCK_SIZE;
    yp := yp + i;
    move(MapBlockData.MapBufferArr[i * MAP_BLOCK_SIZE], MapBuffer[xp + yp * MAP_BLOCK_SIZE * 3], sizeof(TMapCell) * MAP_BLOCK_SIZE);
  end;
end;

procedure TMap.LoadBlockFromStreamPgk(aStream: tStream; axb, ayb, txb, tyb: integer);
var
  n: integer;
  flag: Boolean;
    //   Stream : TFileStream;
  //  fh              :integer;
  MapBlockdata: TMapBlockData;
begin

  if (txb < 0) or (txb >= 3) or (tyb < 0) or (tyb >= 3) then exit;

  flag := TRUE;
  if (axb < 0) or (axb >= MapWidth div MAP_BLOCK_SIZE) or (ayb < 0) or (ayb >= MapHeight div MAP_BLOCK_SIZE) then flag := FALSE;

  if flag then
  begin
    n := sizeof(TMapFileInfo) + sizeof(MapBlockData) * (axb + ayb * (MapWidth div MAP_BLOCK_SIZE));
    try
      aStream.Position := n;
      aStream.ReadBuffer(MapBlockData, sizeof(MapBlockData));
    except
      FillChar(MapBlockData, sizeof(MapBlockData), 0);
    end;
  end else
  begin
    FillChar(MapBlockData, sizeof(MapBlockData), 0);
  end;

  SetMapBlock(txb, tyb, MapBlockData);
end;

procedure TMap.LoadBlockFromFile(afilename: string; axb, ayb, txb, tyb: integer);
var
  n: integer;
  flag: Boolean;
    //   Stream : TFileStream;
  fh: integer;
  MapBlockdata: TMapBlockData;
begin
  if FileExists(aFileName) = FALSE then
  begin
        //      ShowMessage ('款康磊俊霸 楷遏窍矫扁 官而聪促. [MAP FEITBlock FALSE]');
    exit;
  end;
  if (txb < 0) or (txb >= 3) or (tyb < 0) or (tyb >= 3) then exit;

  flag := TRUE;
  if (axb < 0) or (axb >= MapWidth div MAP_BLOCK_SIZE) or (ayb < 0) or (ayb >= MapHeight div MAP_BLOCK_SIZE) then flag := FALSE;

  if flag then
  begin
    n := sizeof(TMapFileInfo) + sizeof(MapBlockData) * (axb + ayb * (MapWidth div MAP_BLOCK_SIZE));
    fh := 0;
    try
      fh := FileOpen(aFileName, fmOpenRead);
      FileSeek(fh, n+16  , 0);
      FileRead(fh, MapBlockData, sizeof(MapBlockData));
      FileClose(fh);
    except
      FillChar(MapBlockData, sizeof(MapBlockData), 0);
      if fh <> 0 then FileClose(fh);
    end;
        {
              Stream := TFileStream.Create (aFileName, fmOpenRead);
              Stream.Seek (n, 0);
              Stream.ReadBuffer (MapBlockData, sizeof(MapBlockData));
              Stream.Free;
        }
  end else
  begin
    FillChar(MapBlockData, sizeof(MapBlockData), 0);
  end;

  SetMapBlock(txb, tyb, MapBlockData);
end;

procedure TMap.LoadFrompgk(aFileName: string; ax, ay: integer);
var
  i, j, xb, yb: integer;
    //  fh              :integer;

  MapInfo: TMapFileInfo;
begin
  if pgkmap.isfile(aFileName) = FALSE then
  begin
        //      ShowMessage ('款康磊俊霸 楷遏窍矫扁 官而聪促. [MAP FEIT FALSE]');
    exit;
  end;
  bopgk := true;
  if MapFilename <> afilename then
  begin
    MapFilename := afilename;
    pgkmap.get(aFileName, fStream);
  end;

  try

    fStream.Position := 0;
    fStream.ReadBuffer(MapInfo, sizeof(MapInfo));
    if StrLIComp(PChar('ATZMAP2'), MapInfo.MapIdent, 8) <> 0 then
      raise Exception.Create('Not a valid Image Library File');

    MapWidth := MapInfo.MapWidth;
    MapHeight := MapInfo.MapHeight;

    Fillchar(MapBuffer, sizeof(MapBuffer), 0);
    Fillchar(MapCellTickBuffer, sizeof(MapCellTickBuffer), 0);

    xb := ax div MAP_BLOCK_SIZE;
    yb := ay div MAP_BLOCK_SIZE;

    MapLeft := xb * MAP_BLOCK_SIZE - MAP_BLOCK_SIZE;
    MapTop := yb * MAP_BLOCK_SIZE - MAP_BLOCK_SIZE;

    for j := 0 to 3 - 1 do
    begin
      for i := 0 to 3 - 1 do
      begin
        LoadBlockFromStreamPgk(fStream, xb - 1 + i, yb - 1 + j, i, j);
      end;
    end;
  except

    MapFilename := '';
    raise exception.Create('Map ERROR');
  end;

end;

procedure TMap.LoadFrom(aFileName: string; ax, ay: integer);
var
  tmpFilename: string;
begin
  if pgkmap.isfile(aFileName) = FALSE then
  begin

    LoadFromFile(aFileName, ax, ay);
    exit;
  end;
  LoadFrompgk(aFileName, ax, ay);
end;

procedure TMap.LoadFromFile(aFileName: string; ax, ay: integer);
var
  i, j, xb, yb: integer;
  fh: integer;
    //   Stream : TFileStream;
  MapInfo: TMapFileInfo;
  tmpFilename: string;
begin
  if FileExists(aFileName) then
    tmpFilename := aFileName
  else
    tmpFilename := '.\map\' + Enc(AnsiUpperCase(aFileName)) + '.dm';
  if FileExists(tmpFilename) = FALSE then
  begin
        //      ShowMessage ('款康磊俊霸 楷遏窍矫扁 官而聪促. [MAP FEIT FALSE]');
    exit;
  end;
  bopgk := false;
  MapFilename := tmpFilename;
    {
       Stream := TFileStream.Create (aFileName, fmOpenRead);
       Stream.ReadBuffer (MapInfo, sizeof(MapInfo));
       if StrLIComp(PChar('ATZMAP2'), MapInfo.MapIdent, 8) <> 0 then
          raise Exception.Create('Not a valid Image Library File');
       Stream.Free;
    }
  fh := 0;
  try // ankudo
    fh := FileOpen(tmpFilename, fmOpenRead);
    FileSeek(fh, 16, 0);
    FileRead(fh, MapInfo, sizeof(MapInfo));
    if StrLIComp(PChar('ATZMAP2'), MapInfo.MapIdent, 8) <> 0 then
      raise Exception.Create('Not a valid Image Library File');
    FileClose(fh);
    MapWidth := MapInfo.MapWidth;
    MapHeight := MapInfo.MapHeight;

    Fillchar(MapBuffer, sizeof(MapBuffer), 0);
    Fillchar(MapCellTickBuffer, sizeof(MapCellTickBuffer), 0);

    xb := ax div MAP_BLOCK_SIZE;
    yb := ay div MAP_BLOCK_SIZE;

    MapLeft := xb * MAP_BLOCK_SIZE - MAP_BLOCK_SIZE;
    MapTop := yb * MAP_BLOCK_SIZE - MAP_BLOCK_SIZE;

    for j := 0 to 3 - 1 do
    begin
      for i := 0 to 3 - 1 do
      begin
        LoadBlockFromFile(tmpFilename, xb - 1 + i, yb - 1 + j, i, j);
      end;
    end;
  except
    if fh <> 0 then FileClose(fh);
    MapFilename := '';
    raise exception.Create('Map ERROR');
  end;
end;

function TMap.GetMapWidth: integer;
begin
  Result := MapWidth;
end;

function TMap.GetMapHeight: integer;
begin
  Result := MapHeight;
end;

function TMap.GetMapName: string;
begin
  Result := LowerCase(MapFileName);
end;

end.

