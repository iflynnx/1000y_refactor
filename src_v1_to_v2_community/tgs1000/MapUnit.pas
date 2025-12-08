unit MapUnit;

interface

uses
    Windows, Classes, SysUtils, DefType, subutil, autil32;

const
    ImageLibID = 'ATZMAP2';
const

    cMAP_BLOCK_SIZE = 40;
type
    TMapServerFileHeader = record
        IDent: array[0..7] of char;
        Width: integer;
        Height: integer;
    end;

    TSMAFileHeader = record
        IDent: array[0..7] of Char;
        Width: Integer;
        Height: Integer;
    end;

    TcMapCell = record
        TileId: word;
        TileNumber: byte;
        TileOverId: word;
        TileOverNumber: byte;
        ObjectId: word;
        ObjectNumber: byte;
        RoofId: word;
        boMove: byte;
    end;
    TcMapFileInfo = record
        MapIdent: array[0..15] of char;
        MapBlockSize: integer;
        MapWidth: integer;
        MapHeight: integer;
    end;
    TcMapBlockData = record
        MapBlockIdent: array[0..15] of char;
        MapChangedCount: Integer;
        MapBufferArr: array[0..cMAP_BLOCK_SIZE * cMAP_BLOCK_SIZE - 1] of TcMapCell;
    end;
    PTcMapBlockData = ^TcMapBlockData;
    TMapCellArr = array[0..MaxListSize] of Byte;
    PTMapCellArr = ^TMapCellArr;

    TMapUser = record
        Id: LongInt;
    end;

    PTMapUser = ^TMapUser;
    TMapUserArr = array[0..MaxListSize] of TMapUser;
    PTMapUserArr = ^TMapUserArr;

    TMaper = class
    private
        FWidth, FHeight: integer;
        MapFileName: string;
        MapCellArr: PTMapCellArr;
        MapUserArr: PTMapUserArr;
        MapAreaArr: PTMapCellArr;                                               //SMA
        procedure cLoadMapFromFile(aFileName: string);                          //¿Í»§ ¶Ë *¡£MAP
        procedure cSetMapBlock(xb, yb: integer; MapBlockData: TcMapBlockData);
        procedure LoadMapFromFile(aFileName: string);
        procedure LoadSMAFromFile(aFileName: string);





    public
        constructor Create(aMapFileName: string);
        destructor Destroy; override;

        function GetMoveableXy(var ax, ay: integer; aw: word): Boolean;
        function getMoveable_width(var ax, ay: integer; aw: word): Boolean;
        function GetAreaIndex(x, y: Integer): Byte;
        function getMoveable(x, y: Integer): Boolean;

        function GetNearXy(var ax, ay: integer): Boolean;
        function isMoveable(x, y: Integer): Boolean;
        function isObjectArea(x, y: Integer): Boolean;
        function isGuildStoneArea(x, y: Integer): Boolean;
        function getUser(x, y: integer): integer;
        function MapProc(Id: LongInt; Msg, x1, y1, x2, y2: word; var SenderInfo: TBasicData): Integer;

        property Width: integer read FWidth;
        property Height: integer read FHeight;
        function GetMoveableXy8(x, y: Integer): Boolean;
        function GetItemXy(xx, yy: integer; var ax, ay, j: integer; aw: word): Boolean;
    end;
var
    mapPosOffsetArr: array[0..32 * 32 - 1] of TPoint;
implementation

uses
    uUser, FieldMsg;

   //8·½Ïò ÊÇ·ñ ¿ÉÒÆ¶¯

function TMaper.GetMoveableXy8(x, y: Integer): Boolean;
var
    i, j, xx, yy: Integer;
begin
    Result := false;

    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then exit;


    for i := -1 to 1 do
    begin
        for j := -1 to 1 do
        begin
//            if (i = 0) and (j = 0) then Break;
            xx := j + x;
            yy := i + y;
            if (xx < 0) or (yy < 0) or (xx >= FWidth) or (yy >= FHeight) then Break;
            if (MapCellArr[yy * FWidth + xx] and 1 = 0)
                and (MapCellArr[yy * FWidth + xx] and 2 = 0)
                and (MapUserArr[yy * FWidth + xx].id = 0) then
            begin
                Result := true;
                exit;
            end;
        end;
    end;
end;
//aw ¸ñ×Ó·¶Î§

function TMaper.GetMoveableXy(var ax, ay: integer; aw: word): Boolean;
var
    i, x, y: integer;
begin
    result := false;
    aw := aw * aw;
    if aw > high(mapPosOffsetArr) then aw := high(mapPosOffsetArr);
    for i := 0 to aw do
    begin
        x := mapPosOffsetArr[i].X + ax;
        y := mapPosOffsetArr[i].y + ay;
        if isMoveable(x, y) then
        begin
            ax := x;
            ay := y;
            result := true;
            exit;
        end;
    end;
end;
{var
    i: Integer;
    xx, yy: Integer;
    ww: Integer;
    boFlag: Boolean;
begin
    xx := ax;
    yy := ay;
    ww := aw;
    boFlag := false;
    while ww > 0 do
    begin
        for i := ww to aw do
        begin
            xx := xx - 1;
            if isMoveable(xx, yy) then
            begin
                boFlag := true;
                break;
            end;
        end;
        if boFlag = true then break;
        for i := ww to aw do
        begin
            yy := yy - 1;
            if isMoveable(xx, yy) then
            begin
                boFlag := true;
                break;
            end;
        end;
        if boFlag = true then break;
        ww := ww - 1;
        for i := ww to aw do
        begin
            xx := xx + 1;
            if isMoveable(xx, yy) then
            begin
                boFlag := true;
                break;
            end;
        end;
        if boFlag = true then break;
        for i := ww to aw do
        begin
            yy := yy + 1;
            if isMoveable(xx, yy) then
            begin
                boFlag := true;
                break;
            end;
        end;
        if boFlag = true then break;
        ww := ww - 1;
    end;

    if boFlag = true then
    begin
        ax := xx;
        ay := yy;
    end;

    Result := boFlag;
end;
}
//aw ¸ñ×Ó·¶Î§

function TMaper.getMoveable_width(var ax, ay: integer; aw: word): Boolean;
var
    i, x, y: integer;
begin
    result := false;
    aw := aw * aw;
    if aw > high(mapPosOffsetArr) then aw := high(mapPosOffsetArr);
    for i := 0 to aw do
    begin
        x := mapPosOffsetArr[i].X + ax;
        y := mapPosOffsetArr[i].y + ay;
        if getMoveable(x, y) then
        begin
            ax := x;
            ay := y;
            result := true;
            exit;
        end;
    end;
end;
//aw ¸ñ×ÓÊýÁ¿

function TMaper.GetItemXy(xx, yy: integer; var ax, ay, j: integer; aw: word): Boolean;
var
    i, x, y: integer;
begin
    result := false;
    if aw > high(mapPosOffsetArr) then aw := high(mapPosOffsetArr);
    if (j > aw) or (j < 0) then j := 0;
    for i := j to aw do
    begin
        x := mapPosOffsetArr[i].X + xx;
        y := mapPosOffsetArr[i].y + yy;
        if getMoveable(x, y) then
        begin
            ax := x;
            ay := y;
            j := i + 1;
            result := true;
            exit;
        end;
    end;
    j := 0;
end;
{var
    i: Integer;
    xx, yy: Integer;
begin
    result := false;
    if (ww > aw) or (ww < 0) then exit;
    xx := ax;
    yy := ay;
    while ww > 0 do
    begin
        if (wf > 3) or (wf < 0) then wf := 0;
        case wf of
            0:
                begin
                    for i := wif to aw do
                    begin
                        xx := xx - 1;
                        if getMoveable(xx, yy) then
                        begin
                            ax := xx;
                            ay := yy;
                            wif := i + 1;
                            Result := true;
                            exit;
                        end;
                    end;

                end;
            1:
                begin
                    for i := wif to aw do
                    begin
                        yy := yy - 1;
                        if getMoveable(xx, yy) then
                        begin
                            ax := xx;
                            ay := yy;
                            wif := i + 1;
                            Result := true;
                            exit;
                        end;
                    end;
                    ww := ww - 1;

                end;
            2:
                begin
                    for i := wif to aw do
                    begin
                        xx := xx + 1;
                        if getMoveable(xx, yy) then
                        begin
                            ax := xx;
                            ay := yy;
                            wif := i + 1;
                            Result := true;
                            exit;
                        end;
                    end;
                end;
            3:
                begin
                    for i := wif to aw do
                    begin
                        yy := yy + 1;
                        if getMoveable(xx, yy) then
                        begin
                            ax := xx;
                            ay := yy;
                            wif := i + 1;
                            Result := true;
                            exit;
                        end;
                    end;

                    ww := ww - 1;

                end;
        end;

        inc(wf);
        wif := ww;
    end;


end;
}

function TMaper.GetNearXy(var ax, ay: integer): Boolean;
var
    i, xx, yy, tempx, tempy: integer;
begin
    Result := TRUE;

    xx := ax;
    yy := ay;
    tempx := 0;
    tempy := 0;

    // 2000.09.19 ½ÃÀÛÀ§Ä¡°¡ ÇÑÄ­À§ ¶Ç´Â ÇÑÄ­¿ÞÂÊÀ¸·Î ¹Ù²î¾î ½ÃÀÛµÇ´Â
    // Çö»ó¼öÁ¤ ÇöÀçÀ§Ä¡°¡ MovableÇÑ°¡¸¦ ¸ÕÀú Ã¼Å© by Lee.S.G
    if not isMoveable(xx + tempx, yy + tempy) then
    begin
        for i := 0 to 32 do
        begin
            GetNearPosition(tempx, tempy);
            if isMoveable(xx + tempx, yy + tempy) then break;
        end;
        if not isMoveable(xx + tempx, yy + tempy) then
        begin
            tempx := 0;
            tempy := 0;
            Result := FALSE;
        end;
    end;

    ax := ax + tempx;
    ay := ay + tempy;
end;

constructor TMaper.Create(aMapFileName: string);
begin
    MapFileName := aMapFileName;
    MapCellArr := nil;
    MapUserArr := nil;
    MapAreaArr := nil;
    LoadMapFromFile(MapFileName);
end;

destructor TMaper.Destroy;
begin
    if MapAreaArr <> nil then FreeMem(MapAreaArr);
    if MapCellArr <> nil then FreeMem(MapCellArr);
    if MapUserArr <> nil then FreeMem(MapUserArr);

    MapCellArr := nil;
    MapUserArr := nil;
    MapAreaArr := nil;

    inherited Destroy;
end;

procedure TMaper.cLoadMapFromFile(aFileName: string);
var
    i, j, xb, yb: integer;
    Stream: TFileStream;
    MapInfo: TcMapFileInfo;
    version: integer;
    MapBlockData: TcMapBlockData;
begin

    if FileExists(aFileName) = FALSE then
    begin
        //      ShowMessage ('¿î¿µÀÚ¿¡°Ô ¿¬¶ôÇÏ½Ã±â ¹Ù¶ø´Ï´Ù. [MAP FEITBlock FALSE]');
        exit;
    end;
    begin

        Stream := TFileStream.Create(aFileName, fmOpenRead);
        try

            Stream.ReadBuffer(MapInfo, sizeof(MapInfo));
            version := -1;
            if StrLIComp(PChar('ATZMAP2'), MapInfo.MapIdent, 8) = 0 then version := 1;

            if version = -1 then
                raise Exception.Create('Not a valid Image Library File');

            FWidth := MapInfo.MapWidth;
            FHeight := MapInfo.mapHeight;

            if MapCellArr <> nil then FreeMem(MapCellArr);
            if MapUserArr <> nil then FreeMem(MapUserArr);

            MapCellArr := nil;
            MapUserArr := nil;
            GetMem(MapCellArr, FWidth * FHeight);
            GetMem(MapUserArr, sizeof(TMapUser) * FWidth * FHeight);
            FillChar(MapCellArr^, FWidth * FHeight, 0);
            FillChar(MapUserArr^, sizeof(TMapUser) * FWidth * FHeight, 0);

            xb := MapInfo.MapWidth div cMAP_BLOCK_SIZE;
            yb := MapInfo.MapHeight div cMAP_BLOCK_SIZE;

            for j := 0 to yb - 1 do
            begin
                for i := 0 to xb - 1 do
                begin
                    Stream.ReadBuffer(MapBlockData, sizeof(MapBlockData));
                    cSetMapBlock(i, j, MapBlockData);
                end;
            end;
        finally
            Stream.Free;
        end;

    end;
end;

procedure TMaper.cSetMapBlock(xb, yb: integer; MapBlockData: TcMapBlockData);
var
    i, j, xp, yp: integer;
begin
    for i := 0 to cMAP_BLOCK_SIZE - 1 do
    begin
        xp := xb * cMAP_BLOCK_SIZE;
        yp := yb * cMAP_BLOCK_SIZE;
        yp := yp + i;
        for j := 0 to cMAP_BLOCK_SIZE - 1 do
        begin
            MapCellArr[xp + yp * FWidth + j] := MapBlockData.MapBufferArr[i * cMAP_BLOCK_SIZE + j].boMove;
        end;

        //  move(MapBlockData.MapBufferArr[i * cMAP_BLOCK_SIZE], MapBuffer[xp + yp * MAXMAPLENGTH], sizeof(TMapCell) * MAP_BLOCK_SIZE);
    end;
end;

procedure TMaper.LoadMapFromFile(aFileName: string);
var
    fh: integer;
    MapServerFileHeader: TMapServerFileHeader;
    SMAFileName: string;
begin
    fh := FileOpen(aFileName, fmOpenRead);
    try
        FileRead(fh, MapServerfileHeader, sizeof(MapServerFileHeader));
        if StrLIComp(PChar(ImageLibID), MapServerFileHeader.Ident, 4) = 0 then
        begin
            FWidth := MapServerFileHeader.Width;
            FHeight := MapServerFileHeader.Height;

            if MapCellArr <> nil then FreeMem(MapCellArr);
            if MapUserArr <> nil then FreeMem(MapUserArr);

            MapCellArr := nil;
            MapUserArr := nil;
            GetMem(MapCellArr, FWidth * FHeight);
            GetMem(MapUserArr, sizeof(TMapUser) * FWidth * FHeight);
            FillChar(MapCellArr^, FWidth * FHeight, 0);
            FillChar(MapUserArr^, sizeof(TMapUser) * FWidth * FHeight, 0);

            FileRead(fh, MapCellArr^, FWidth * FHeight);
        end;
        FileClose(fh);
    except
        FileClose(fh);
        raise;
    end;

    try
    SMAFileName := ChangeFileExt(aFileName, '.SMA');
    LoadSMAFromFile(SMAFileName);
    except
      end;
end;

procedure TMaper.LoadSMAFromFile(aFileName: string);
var
    SMAHeader: TSMAFileHeader;
    Stream: TFileStream;
begin
  //  MessageBox(0,'1','',0);

    if not FileExists(aFileName) then
    begin
   //    Log(aFileName);
     exit;
     end;
   //  Log('2');
    Stream := TFileStream.Create(aFileName, fmOpenRead);
    Stream.ReadBuffer(SMAHeader, SizeOf(TSMAFileHeader));
   //Log('0--- 1:'+IntToStr(SMAHeader.Width)+' 2:'+IntToStr(fWidth)+' 3:'+IntToStr(SMAHeader.Height)+' 4:'+IntToStr(fHeight));
   { if (SMAHeader.Width <> FWidth) or (SMAHeader.Height <> FHeight) then
    begin
           Log('1----- 1:'+IntToStr(SMAHeader.Width)+' 2:'+IntToStr(fWidth)+' 3:'+IntToStr(SMAHeader.Height)+' 4:'+IntToStr(fHeight));
        Stream.Free;
        exit;
    end; }

    if MapAreaArr <> nil then FreeMem(MapAreaArr);
    GetMem(MapAreaArr, FWidth * FHeight);
    try
    Stream.ReadBuffer(MapAreaArr^, FWidth * FHeight);
    except
    end;
    Stream.Free;
   // Log('4');
end;

function TMaper.GetAreaIndex(x, y: Integer): Byte;
var
    ReadPos: Integer;
    aByte: PByte;
begin
    Result := 0;
     if MapAreaArr = nil then exit;

    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then exit;

    ReadPos := y * FWidth + x;

    Result := MapAreaArr[ReadPos];
end;

function TMaper.getUser(x, y: integer): integer;
begin
    Result := 0;
    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then
    begin
        exit;
    end;
    Result := MapUserArr[y * FWidth + x].id;
end;

function TMaper.getMoveable(x, y: Integer): Boolean;
begin
    Result := false;
    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then exit;
    if (MapCellArr[y * FWidth + x] and 1 <> 0) or (MapCellArr[y * FWidth + x] and 2 <> 0) then exit;
    Result := true;
end;

function TMaper.isMoveable(x, y: Integer): Boolean;
begin
    Result := TRUE;
    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then
    begin
        Result := FALSE;
        exit;
    end;

    if (MapCellArr[y * FWidth + x] and 1 <> 0) or (MapCellArr[y * FWidth + x] and 2 <> 0) then
    begin
        Result := FALSE;
        exit;
    end;

    // À¯Àú°¡ ÁøÂ¥ ÀÖ´ÂÁö È®ÀÎÇÏ°í ¾øÀ¸¸é Çã¿ë ÇØ¾ß µÊ.
    if MapUserArr[y * FWidth + x].id <> 0 then
    begin
        Result := FALSE;
        exit;
    end;
end;

function TMaper.isGuildStoneArea(x, y: Integer): Boolean;
var
    i, j: Integer;
begin
    Result := false;

    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then
    begin
        Result := true;
        exit;
    end;

    for i := -1 to 1 do
    begin
        for j := -1 to 1 do
        begin
            if (i + y >= 0) and (j + x >= 0) and (i + y < FHeight) and (j + x < FWidth) then
            begin
                if isStaticItemId(MapUserArr[(i + y) * FWidth + (j + x)].id) then
                begin
                    Result := true;
                    exit;
                end;
            end;
        end;
    end;
end;

function TMaper.isObjectArea(x, y: Integer): Boolean;
var
    i, j: Integer;
begin
    Result := false;

    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then
    begin
        Result := true;
        exit;
    end;
    if (MapCellArr[y * FWidth + x] and 1 <> 0) or (MapCellArr[y * FWidth + x] and 2 <> 0) then
    begin
        Result := true;
        exit;
    end;

    for i := -2 to 2 do
    begin
        for j := -2 to 2 do
        begin
            if (i + y >= 0) and (j + x >= 0) and (i + y < FHeight) and (j + x < FWidth) then
            begin
                if (MapCellArr[(i + y) * FWidth + (j + x)] and 2 <> 0) then
                begin
                    Result := true;
                    exit;
                end;
            end;
        end;
    end;
end;

function TMaper.MapProc(Id: LongInt; Msg, x1, y1, x2, y2: Word; var SenderInfo: TBasicData): Integer;
var
    i: Integer;
    xx, yy: Integer;
begin
    Result := 0;

    if isObjectItemId(Id) then exit;

    if (x1 >= FWidth) or (y1 >= FHeight) then
    begin
        Result := -1;
        exit;
    end;
    if (x2 >= FWidth) or (y2 >= FHeight) then
    begin
        Result := -1;
        exit;
    end;

    case Msg of
        MM_MOVE:
            begin
                if MapUserArr[y1 * FWidth + x1].id = id then
                begin
                    for i := 0 to 10 - 1 do
                    begin
                        xx := SenderInfo.GuardX[i];
                        yy := SenderInfo.GuardY[i];
                        MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id := 0;
                        if (xx = 0) and (yy = 0) then break;
                    end;
                end;
                for i := 0 to 10 - 1 do
                begin
                    xx := SenderInfo.GuardX[i];
                    yy := SenderInfo.GuardY[i];
                    MapUserArr[(y2 + yy) * FWidth + (x2 + xx)].id := Id;
                    if (xx = 0) and (yy = 0) then break;
                end;
            end;
        MM_SHOW:
            begin
                for i := 0 to 10 - 1 do
                begin
                    xx := SenderInfo.GuardX[i];
                    yy := SenderInfo.GuardY[i];
                    MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id := Id;
                    if (xx = 0) and (yy = 0) then break;
                end;
            end;
        MM_HIDE:
            begin
                for i := 0 to 10 - 1 do
                begin
                    xx := SenderInfo.GuardX[i];
                    yy := SenderInfo.GuardY[i];
                    if MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id = id then MapUserArr[(y1 + yy) * FWidth + (x1 + xx)].id := 0;
                    if (xx = 0) and (yy = 0) then break;
                end;
            end;
    else Result := -1;
    end;
end;

procedure SetmapPosOffset();
var
    i, j, n: Integer;
    xx, yy: Integer;
    aw: Integer;
begin
    xx := 0;
    yy := 0;
    aw := 1;
    j := 0;
    n := high(mapPosOffsetArr);
    while true do
    begin
        for i := 1 to aw do
        begin
            if j > n then exit;
            xx := xx - 1;
            mapPosOffsetArr[j].X := xx;
            mapPosOffsetArr[j].y := yy;
            inc(j);
        end;
        for i := 1 to aw do
        begin
            if j > n then exit;
            yy := yy - 1;
            mapPosOffsetArr[j].X := xx;
            mapPosOffsetArr[j].y := yy;
            inc(j);
        end;
        inc(aw);
        for i := 1 to aw do
        begin
            if j > n then exit;
            xx := xx + 1;
            mapPosOffsetArr[j].X := xx;
            mapPosOffsetArr[j].y := yy;
            inc(j);
        end;
        for i := 1 to aw do
        begin
            if j > n then exit;
            yy := yy + 1;
            mapPosOffsetArr[j].X := xx;
            mapPosOffsetArr[j].y := yy;
            inc(j);
        end;
        inc(aw);
    end;
end;


initialization
    SetmapPosOffset;

finalization

end.

