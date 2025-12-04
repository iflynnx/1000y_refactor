unit cAIPath;

interface
uses
  Windows, Classes, SysUtils, DefType, subutil, autil32, A2Img;

const
  ImageLibID = 'ATZMAP2';
const

  cMAP_BLOCK_SIZE = 40;
//2016.03.21 在水一方 移植新寻路算法 >>>>>>
type
  TMapDataArr = record
    ObjCls: array of TObject;
  end;
  PTMapDataArr = ^TMapDataArr;

  TPath = array of TPoint; //路径数组

  TMapDate = array of array of integer;

  TGetCostFunc = function(X, Y, Direction: Integer; PathWidth: Integer = 0): Integer;

  TPathMapCell = record //路径图元
    Distance: Integer; //离起点的距离
    Direction: Integer;
  end;
  TPathMapArray = array of array of TPathMapCell; // 路径图存储数组

  TPathMap = class //寻路类
  public
    PathMapArray: TPathMapArray;
    Height: Integer;
    Width: Integer;
    GetCostFunc: TGetCostFunc;
    PathWidth: Integer;
    CurMovePos: integer;
    constructor Create;
    function FindPath(MapWidthin, MapHeightin: Integer; StartX, StartY, StopX, StopY: Integer;
      pGetCostFunc: TGetCostFunc): TPath;
    function FindPathOnMap(X, Y: Integer): TPath;
    procedure MakePathMap(MapWidthin, MapHeightin: Integer; StartX, StartY: Integer;
      pGetCostFunc: TGetCostFunc);

  private
    function DirToDX(Direction: Integer): Integer;
    function DirToDY(Direction: Integer): Integer;
  protected
    function GetCost(X, Y, Direction: Integer): Integer; virtual;
    function FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
  end;

  TWaveCell = record //路线点
    X, Y: Integer; //
    Cost: Integer; //
    Direction: Integer;
  end;

  TWave = class //路线类
  private
    FData: array of TWaveCell;
    FPos: Integer; //
    FCount: Integer; //
    FMinCost: Integer;
    function GetItem: TWaveCell;
  public
    property Item: TWaveCell read GetItem; //
    property MinCost: Integer read FMinCost; // Cost

    constructor Create;
    destructor Destroy; override;
    procedure Add(NewX, NewY, NewCost, NewDirection: Integer); //
    procedure Clear; //FCount
    function Start: Boolean; //
    function Next: Boolean; //
  end;
//2016.03.21 在水一方 移植新寻路算法 <<<<<<

type
  TcMapServerFileHeader = record
    IDent: array[0..7] of char;
    Width: integer;
    Height: integer;
  end;

  TcSMAFileHeader = record
    IDent: array[0..7] of Char;
    Width: Integer;
    Height: Integer;
  end;
    {   TMapCell = record
     TileId : word;
     TileNumber : byte;
     TileOverId : word;
     TileOverNumber : byte;
     ObjectId : word;
     ObjectNumber : byte;
     RoofId : word;
     boMove : byte;
   end;}
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
  TcMapCellArr = array[0..MaxListSize] of Byte;
  PTcMapCellArr = ^TcMapCellArr;

  TcMapUser = record
    Id: LongInt;
  end;

  PTcMapUser = ^TcMapUser;
  TcMapUserArr = array[0..MaxListSize] of TcMapUser;
  PTcMapUserArr = ^TcMapUserArr;

  TcMaper = class
  private
    FWidth, FHeight: integer;

    MapFileName: string;
    MapCellArr: PTcMapCellArr;
    MapUserArr: PTcMapUserArr;
    MapAreaArr: PTcMapCellArr;

        //        procedure LoadMapFromFile(aFileName:string);
          //      procedure LoadSMAFromFile(aFileName:string);

    public
        QuickMode: Boolean;
        constructor Create(aMapFileName:string);
        destructor Destroy; override;
        //        procedure UserMove(id, x, y:integer);

    procedure cLoadMapFromFile(aFileName: string); //客户 端 *。MAP
    procedure cLoadMapFromPgk(aFileName: string);
    procedure cLoadMapFrom(aFileName: string);

    procedure cSetMapBlock(xb, yb: integer; MapBlockData: TcMapBlockData);
    function GetMoveableXy(var ax, ay: integer; aw: word): Boolean;
    function GetAreaIndex(x, y: Integer): Byte;

    function GetNearXy(var ax, ay: integer): Boolean;
    function isMoveable(x, y: Integer): Boolean;
    function isObjectArea(x, y: Integer): Boolean;
        //        function isGuildStoneArea(x, y:Integer):Boolean;
                //    function MapProc(Id:LongInt; Msg, x1, y1, x2, y2:word; var SenderInfo:TBasicData):Integer;
    property Width: integer read FWidth;
    property Height: integer read FHeight;
  end;

type
  Tpathxy = record
    id: integer;
    rx, ry: integer;
  end;
  pTpathxy = ^Tpathxy;

  TPathNode = record
    f, h, g: Integer;
    x, y: Integer;
    pPrev, pNext: Pointer;
    pDirect: array[0..7] of Pointer;
  end;
  PTPathNode = ^TPathNode;

  TPathStack = record
    pNodePtr: PTPathNode;
    pNext: Pointer;
  end;
  PTPathStack = ^TPathStack;

  TcSearchPathClass = class
  private
    m_pOpenNodes: PTPathNode;
    m_pClosedNodes: PTPathNode;

    m_pStack: PTPathStack;

    Maper: TcMaper;

    procedure Push(pNode: PTPathNode);
    function Pop: PTPathNode;
    function isOpen(x, y: Integer): PTPathNode;
    function isClose(x, y: Integer): PTPathNode;
    procedure MakeChild(pN: PTPathNode; dx, dy: Integer);
    procedure makeChildSub(pNode: PTPathNode; x, y, dx, dy: Integer);
    procedure makeDown(pT: PTPathNode);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetMaper(aMaper: TcMaper);
    function FindPath(sx, sy, dx, dy: Integer): PTPathNode;
    procedure test(x, y: integer; acolor: integer);
    function GotoPath(x1, y1, x2, y2: Integer; var x, y: Integer): boolean;
  end;
  Tpathlist = class
    Fdatalist: tlist;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear();
    procedure add(x, y: integer);
    procedure del(id: integer);
    procedure delEnd;
    function get(id: integer): pTpathxy;
    function getEnd: pTpathxy;
  end;

//2016.03.21 在水一方 移植新寻路算法 >>>>>>
  TNewSearchPathClass = class(TPathMap)
  private
    FPath: TPath;
    Maper: TcMaper;
    MapWidth, MapHeight: Integer;
    MapLeft, MapTop: integer;
    //MapData: TMapDate;
  protected
    function GetCost(X, Y, Direction: Integer): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetMaper(aMaper: TcMaper);
    function FindPath(StartX, StartY, StopX, StopY, PathSpace: Integer): TPath; overload;
    function GotoPath(x1, y1, x2, y2: Integer; var x, y: Integer): boolean;
  end;
//2016.03.21 在水一方 移植新寻路算法 <<<<<<

var
  cSearchPathClass: TcSearchPathClass;
  nSearchPathClass: TNewSearchPathClass;
  cMaper: TcMaper;
  temppathtest: TA2Image;
  pathlist: Tpathlist;
implementation
uses CharCls, filepgkclass, CLMap;

function Tpathlist.getEnd: pTpathxy;
begin
  result := nil;
  if Fdatalist.Count <= 0 then exit;
  result := get(Fdatalist.Count - 1);
end;

function Tpathlist.get(id: integer): pTpathxy;
begin
  result := nil;
  if (id < 0) or (id >= Fdatalist.Count) then exit;
  result := Fdatalist.Items[id];
end;

procedure Tpathlist.delEnd;
begin
  del(Fdatalist.Count - 1);
end;

procedure Tpathlist.del(id: integer);
var
  p: pTpathxy;
begin
  if (id < 0) or (id >= Fdatalist.Count) then exit;
  p := Fdatalist.Items[id];
  dispose(p);
  Fdatalist.Delete(id);

end;

procedure Tpathlist.add(x, y: integer);
var
  p: pTpathxy;
begin
  new(p);
  p.rx := x;
  p.ry := y;
  Fdatalist.Add(p);
end;

constructor Tpathlist.Create;
begin
  Fdatalist := tlist.Create;
end;

procedure Tpathlist.Clear();
var
  i: integer;
  p: pTpathxy;
begin
  for i := 0 to Fdatalist.Count - 1 do
  begin
    p := Fdatalist.Items[i];
    dispose(p);
  end;
  Fdatalist.Clear;
end;

destructor Tpathlist.Destroy;
begin
  Clear;
  Fdatalist.Free;

end;

constructor TcSearchPathClass.Create;
var
  i: Integer;
begin
  New(m_pOpenNodes);
  if m_pOpenNodes <> nil then
  begin
    m_pOpenNodes^.f := 0;
    m_pOpenNodes^.h := 0;
    m_pOpenNodes^.g := 0;
    m_pOpenNodes^.x := 0;
    m_pOpenNodes^.y := 0;
    m_pOpenNodes^.pPrev := nil;
    m_pOpenNodes^.pNext := nil;
    for i := 0 to 8 - 1 do
    begin
      m_pOpenNodes^.pDirect[i] := nil;
    end;
  end;
  New(m_pClosedNodes);
  if m_pClosedNodes <> nil then
  begin
    m_pClosedNodes^.f := 0;
    m_pClosedNodes^.h := 0;
    m_pClosedNodes^.g := 0;
    m_pClosedNodes^.x := 0;
    m_pClosedNodes^.y := 0;
    m_pClosedNodes^.pPrev := nil;
    m_pClosedNodes^.pNext := nil;
    for i := 0 to 8 - 1 do
    begin
      m_pClosedNodes^.pDirect[i] := nil;
    end;
  end;
  New(m_pStack);
  if m_pStack <> nil then
  begin
    m_pStack^.pNodePtr := nil;
    m_pStack^.pNext := nil;
  end;
end;

destructor TcSearchPathClass.Destroy;
{
var
   pFN, pTN : PTPathNode;
   pFS, pTS : PTPathStack;
}
begin
  if m_pOpenNodes <> nil then
  begin
    Dispose(m_pOpenNodes);
  end;
  if m_pClosedNodes <> nil then
  begin
    Dispose(m_pClosedNodes);
  end;
  if m_pStack <> nil then
  begin
    Dispose(m_pStack);
  end;

  inherited Destroy;
end;

procedure TcSearchPathClass.SetMaper(aMaper: TcMaper);
begin
  Maper := aMaper;
end;

procedure TcSearchPathClass.push(pNode: PTPathNode);
var
  pData: PTPathStack;
begin
  New(pData);
  if pData <> nil then
  begin
    pData^.pNodePtr := pNode;
    pData^.pNext := m_pStack^.pNext;
    m_pStack^.pNext := PData;
  end;
end;

function TcSearchPathClass.pop: PTPathNode;
var
  pN: PTPathNode;
  pData: PTPathStack;
begin
  Result := nil;
  try
    pData := m_pStack^.pNext;
    pN := pData^.pNodePtr;
    m_pStack^.pNext := pData^.pNext;
    Dispose(pData);
    Result := pN;
  except
  end;
end;

function TcSearchPathClass.isOpen(x, y: Integer): PTPathNode;
var
  pNode: PTPathNode;
begin
  Result := nil;
  pNode := m_pOpenNodes^.pNext;
  while pNode <> nil do
  begin
    if (pNode^.x = x) and (pNode^.y = y) then
    begin
      Result := pNode;
      exit;
    end;
    pNode := pNode^.pNext;
  end;
end;

function TcSearchPathClass.isClose(x, y: Integer): PTPathNode;
var
  pNode: PTPathNode;
begin
  Result := nil;
  pNode := m_pClosedNodes^.pNext;
  while pNode <> nil do
  begin
    if (pNode^.x = x) and (pNode^.y = y) then
    begin
      Result := pNode;
      exit;
    end;
    pNode := pNode^.pNext;
  end;
end;

procedure TcSearchPathClass.makeDown(pT: PTPathNode);
var
  i: Integer;
  pD, pF: PTPathNode;
begin
  for i := 0 to 8 - 1 do
  begin
    pD := pT^.pDirect[i];
    if pD = nil then break;
    if pD^.g > pT^.g + 1 then
    begin
      pD^.g := pT^.g + 1;
      pD^.f := pD^.g + pD^.h;
      pD^.pPrev := pT;
      push(pD);
    end;
  end;
  while m_pStack^.pNext <> nil do
  begin
    pF := pop();
    for i := 0 to 8 - 1 do
    begin
      pD := pF^.pDirect[i];
      if pD = nil then break;
      if pD^.g > pF^.g + 1 then
      begin
        pD^.g := pF^.g + 1;
        pD^.f := pD^.g + pD^.h;
        pD^.pPrev := pF;
        push(pD);
      end;
    end;
  end;
end;

procedure TcSearchPathClass.makeChildSub(pNode: PTPathNode; x, y, dx, dy: Integer);
  procedure InsertNode(pT: PTPathNode);
  var
    pOne, pTwo: PTPathNode;
  begin
    if m_pOpenNodes^.pNext = nil then
    begin
      m_pOpenNodes^.pNext := pT;
      exit;
    end;
    pOne := m_pOpenNodes;
    pTwo := pOne^.pNext;
    while (pTwo <> nil) and (pTwo^.f < pT^.f) do
    begin
      pOne := pTwo;
      pTwo := pOne^.pNext;
    end;
    pT^.pNext := pTwo;
    pOne^.pNext := pT;
  end;
var
  i, g: Integer;
  pT, pN: PTPathNode;
begin
  g := pNode^.g + 1;
  pT := isOpen(x, y);
  if pT <> nil then
  begin
        //在 OPEN表中
    for i := 0 to 8 - 1 do
    begin
      if pNode^.pDirect[i] = nil then break;
    end;
    pNode^.pDirect[i] := pT;
    if g < pT^.g then
    begin
            //如果 代价小 替换掉
      pT^.g := g;
      pT^.f := pT^.g + pT^.h;
      pT^.pPrev := pNode;
    end;
  end else
  begin

    pT := isClose(x, y);
    if pT <> nil then
    begin
            //在关闭表
      for i := 0 to 8 - 1 do
      begin
        if pNode^.pDirect[i] = nil then break;
      end;
      pNode^.pDirect[i] := pT;
      if g < pT^.g then
      begin
        pT^.g := g;
        pT^.f := pT^.g + pT^.h;
        pT^.pPrev := pNode;
        makeDown(pT);
      end;
    end else
    begin
            //新 点
      New(pN);
      if pN = nil then exit;
      pN^.g := x - dx;
      pN^.g := Abs(pN^.g);
      pN^.h := y - dy;
      pN^.h := Abs(pN^.h);
      pN^.h := pN^.g + pN^.h;
            //加重 权
//            pN^.h := pN^.h ;
      pN^.g := g;
      pN^.f := (g + pN^.h); //* 5; //修改  *5
      pN^.x := x;
      pN^.y := y;
      pN^.pPrev := pNode;
      pN^.pNext := nil;
      for i := 0 to 8 - 1 do
      begin
        pN^.pDirect[i] := nil;
      end;

      InsertNode(pN);
      for i := 0 to 8 - 1 do
      begin
        if pNode^.pDirect[i] = nil then break;
      end;
      pNode^.pDirect[i] := pN;
    end;
  end;
end;

procedure TcSearchPathClass.MakeChild(pN: PTPathNode; dx, dy: Integer);
var
  x, y: Integer;
begin
  x := pN^.x;
  y := pN^.y;
    //探测 8个方向
  dec(y);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
  inc(x);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
  inc(y);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
  inc(y);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
  dec(x);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
  dec(x);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
  dec(y);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
  dec(y);
  if Maper.isMoveable(x, y) or ((x = dx) and (y = dy)) then makeChildSub(pN, x, y, dx, dy);
end;

procedure TcSearchPathClass.test(x, y: integer; acolor: integer);
var
  fx, fy: integer;
begin
  if temppathtest <> nil then
  begin

    fx := trunc(temppathtest.Width * (x / Maper.FWidth));
    fy := trunc(temppathtest.Height * (y / Maper.FHeight));
    temppathtest.Pixels(fx, fy, ColorSysToDxColor(acolor));
    sleep(0);
  end;
end;

function TcSearchPathClass.FindPath(sx, sy, dx, dy: Integer): PTPathNode;
var
  i, j, MaxTry: Integer;
  pS, pBest: PTPathNode;
begin
  Result := nil;

  New(pS);
  MaxTry := Abs(dx - sx) * 1000 + Abs(dy - sy) * 1000;
    // MaxTry := (Abs(dx - sx) + Abs(dy - sy)) ;
     // MaxTry := MaxTry * 1;
    // MaxTry := 20;
  pS^.g := 0;
  pS^.h := abs(dx - sx) + abs(dy - sy);
  pS^.f := pS^.g + pS^.h;
  pS^.x := sx;
  pS^.y := sy;
  pS^.pNext := nil;
  pS^.pPrev := nil;
  for i := 0 to 8 - 1 do
  begin
    pS^.pDirect[i] := nil;
  end;
  m_pOpenNodes^.pNext := pS;
  j := 0;
  while true do
  begin
    inc(j);
    pBest := m_pOpenNodes^.pNext;
    if pBest = nil then exit;
    if j > 15000 then
    begin
      Result := pBest;
      exit;
    end;
    if pBest^.g >= MaxTry then
    begin
      Result := pBest; //;
      exit;
    end;
    if (pBest^.x = dx) and (pBest^.y = dy) then
    begin
      Result := pBest;
      exit;
    end;
    m_pOpenNodes^.pNext := pBest^.pNext;
    pBest^.pNext := m_pClosedNodes^.pNext;
    m_pClosedNodes^.pNext := pBest;
    MakeChild(pBest, dx, dy);
        //test(pBest.x, pBest.y, $00FF00);
  end;
end;

function TcSearchPathClass.GotoPath(x1, y1, x2, y2: Integer; var x, y: Integer): boolean;
var
    // boflag : Boolean;
  pBest, pF, pT: PTPathNode;
  fx, fy: integer;
begin
  Result := true;

  m_pOpenNodes^.pPrev := nil;
  m_pOpenNodes^.pNext := nil;
  m_pClosedNodes^.pPrev := nil;
  m_pClosedNodes^.pNext := nil;
  m_pStack^.pNodePtr := nil;
  m_pStack^.pNext := nil;
  pathlist.Clear;
  pBest := FindPath(x1, y1, x2, y2);
  if pBest <> nil then
  begin
    x := pBest^.x;
    y := pBest^.y;
    while pBest^.g >= 1 do
    begin
      pathlist.add(pBest.x, pBest.y);
            //  test(pBest.x, pBest.y, $FF);
      pBest := pBest^.pPrev;
    end;
        {   x := pBest^.x;
           y := pBest^.y;}
  end else
  begin
    Result := false;
  end;

  pF := m_pOpenNodes^.pNext;
  while pF <> nil do
  begin
    pT := pF;
    pF := pF^.pNext;
    Dispose(pT);
  end;
  pF := m_pClosedNodes^.pNext;
  while pF <> nil do
  begin
    pT := pF;
    pF := pF^.pNext;
    Dispose(pT);
  end;
end;

function TcMaper.GetMoveableXy(var ax, ay: integer; aw: word): Boolean;
var
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

function TcMaper.GetNearXy(var ax, ay: integer): Boolean;
var
  i, xx, yy, tempx, tempy: integer;
begin
  Result := TRUE;

  xx := ax;
  yy := ay;
  tempx := 0;
  tempy := 0;

    // 2000.09.19 矫累困摹啊 茄沫困 肚绰 茄沫哭率栏肺 官差绢 矫累登绰
    // 泅惑荐沥 泅犁困摹啊 Movable茄啊甫 刚历 眉农 by Lee.S.G
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

constructor TcMaper.Create(aMapFileName: string);
begin
    QuickMode := False;
    MapFileName := aMapFileName;
    MapCellArr := nil;
    MapUserArr := nil;
    MapAreaArr := nil;
    cLoadMapFromFile(MapFileName);
end;

destructor TcMaper.Destroy;
begin
  if MapAreaArr <> nil then FreeMem(MapAreaArr);
  if MapCellArr <> nil then FreeMem(MapCellArr);
  if MapUserArr <> nil then FreeMem(MapUserArr);

  MapCellArr := nil;
  MapUserArr := nil;
  MapAreaArr := nil;

  inherited Destroy;
end;

procedure TcMaper.cLoadMapFromPgk(aFileName: string);
var
  i, j, xb, yb: integer;
  Stream: TMemoryStream;
  MapInfo: TcMapFileInfo;
  version: integer;
  MapBlockData: TcMapBlockData;
begin

  if pgkmap.isfile(aFileName) = FALSE then
  begin
        //      ShowMessage ('款康磊俊霸 楷遏窍矫扁 官而聪促. [MAP FEITBlock FALSE]');
    exit;
  end;
  begin

    Stream := TMemoryStream.Create;
    try
      pgkmap.get(aFileName, Stream);
      Stream.Position := 0;
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
      GetMem(MapUserArr, sizeof(TcMapUser) * FWidth * FHeight);
      FillChar(MapCellArr^, FWidth * FHeight, 0);
      FillChar(MapUserArr^, sizeof(TcMapUser) * FWidth * FHeight, 0);

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

procedure TcMaper.cLoadMapFrom(aFileName: string);
begin
  if pgkmap.isfile(aFileName) = FALSE then
  begin
    cLoadMapFromFile(aFileName);
    exit;
  end;
  cLoadMapFromPgk(aFileName);

end;
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

procedure TcMaper.cLoadMapFromFile(aFileName: string);
var
  i, j, xb, yb: integer;
  Stream: TFileStream;
  MapInfo: TcMapFileInfo;
  version: integer;
  MapBlockData: TcMapBlockData;
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

  begin

    Stream := TFileStream.Create(tmpFilename, fmOpenRead);
    try
      Stream.Seek(16, 0);
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
      GetMem(MapUserArr, sizeof(TcMapUser) * FWidth * FHeight);
      FillChar(MapCellArr^, FWidth * FHeight, 0);
      FillChar(MapUserArr^, sizeof(TcMapUser) * FWidth * FHeight, 0);

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

procedure TcMaper.cSetMapBlock(xb, yb: integer; MapBlockData: TcMapBlockData);
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
{
procedure TcMaper.LoadMapFromFile(aFileName:string);
var
    fh              :integer;
    MapServerFileHeader:TMapServerFileHeader;
    SMAFileName     :string;
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

    SMAFileName := ChangeFileExt(aFileName, '.SMA');
    LoadSMAFromFile(SMAFileName);
end;

procedure TcMaper.LoadSMAFromFile(aFileName:string);
var
    SMAHeader       :TSMAFileHeader;
    Stream          :TFileStream;
begin
    if not FileExists(aFileName) then exit;

    Stream := TFileStream.Create(aFileName, fmOpenRead);
    Stream.ReadBuffer(SMAHeader, SizeOf(TSMAFileHeader));

    if (SMAHeader.Width <> FWidth) or (SMAHeader.Height <> FHeight) then
    begin
        Stream.Free;
        exit;
    end;

    if MapAreaArr <> nil then FreeMem(MapAreaArr);
    GetMem(MapAreaArr, FWidth * FHeight);

    Stream.ReadBuffer(MapAreaArr^, FWidth * FHeight);

    Stream.Free;
end;
}

function TcMaper.GetAreaIndex(x, y: Integer): Byte;
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
{
procedure TcMaper.UserMove(id, x, y:integer);
begin
    if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then exit;
    MapUserArr[y * FWidth + x].id := id;
end;
}

function TcMaper.isMoveable(x, y: Integer): Boolean;
begin
  Result := TRUE;
  if (x < 0) or (y < 0) or (x >= FWidth) or (y >= FHeight) then
  begin
    Result := FALSE;
    exit;
  end;
    // if (MapCell.boMove and 1 <> 0) or (MapCell.boMove and 2 <> 0) then Result := FALSE;
  if (MapCellArr[y * FWidth + x] and 1 <> 0) or (MapCellArr[y * FWidth + x] and 2 <> 0) then
  begin
    Result := FALSE;
    exit;
  end;

    //if (abs(x - CharPosX) <= VIEWWIDTH) or (abs(y - CharPosY) <= VIEWHEIGHT) then
    if not QuickMode then
    if CharList.isMovable(x, y) = FALSE then
    begin
      Result := FALSE;
      exit;
    end;

    // 蜡历啊 柳楼 乐绰瘤 犬牢窍绊 绝栏搁 倾侩 秦具 凳.
  if MapUserArr[y * FWidth + x].id <> 0 then
  begin
    Result := FALSE;
    exit;
  end;
end;
{
function TcMaper.isGuildStoneArea(x, y:Integer):Boolean;
var
    i, j            :Integer;
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
               // if isStaticItemId(MapUserArr[(i + y) * FWidth + (j + x)].id) then
                begin
                    Result := true;
                    exit;
                end;
            end;
        end;
    end;
end;
}

function TcMaper.isObjectArea(x, y: Integer): Boolean;
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
//2016.03.21 在水一方 移植新寻路算法 >>>>>>

{ TPathMap }

constructor TPathMap.Create;
begin
  PathWidth := 1;
  inherited Create;
end;

function TPathMap.DirToDX(Direction: Integer): Integer;
begin
  case Direction of
    0, 4: Result := 0;
    1..3: Result := 1;
  else
    Result := -1;
  end;
end;

function TPathMap.DirToDY(Direction: Integer): Integer;
begin
  case Direction of
    2, 6: Result := 0;
    3..5: Result := 1;
  else
    Result := -1;
  end;
end;

function TPathMap.FillPathMap(X1, Y1, X2, Y2: Integer): TPathMapArray;
var
  OldWave, NewWave: TWave;
  Finished: Boolean;
  I: TWaveCell;

  procedure PreparePathMap; //初始化PathMapArray
  var
    X, Y: Integer; //
  begin
    SetLength(Result, Height, Width);
    for Y := 0 to (Height - 1) do
      for X := 0 to (Width - 1) do
        Result[Y, X].Distance := -1;
  end;

//计算相邻8个节点的权cost，并合法点加入NewWave(),并更新最小cost
//合法点是指非障碍物且Result[X，Y]中未访问的点
  procedure TestNeighbours;
  var
    X, Y, C, D: Integer;
  begin
    for D := 0 to 7 do
    begin
      X := OldWave.Item.X + DirToDX(D);
      Y := OldWave.Item.Y + DirToDY(D);
      C := GetCost(X, Y, D);
      if (C >= 0) and (Result[Y, X].Distance < 0) then
        NewWave.Add(X, Y, C, D); //
    end;
  end;

  procedure ExchangeWaves; //
  var
    W: TWave;
  begin
    W := OldWave;
    OldWave := NewWave;
    NewWave := W;
    NewWave.Clear;
  end;

begin
  PreparePathMap; // 初始化PathMapArray ,Distance:=-1
  OldWave := TWave.Create;
  NewWave := TWave.Create;
  Result[Y1, X1].Distance := 0; // 起点Distance:=0
  OldWave.Add(X1, Y1, 0, 0); //将起点加入OldWave
  TestNeighbours; //

  Finished := ((X1 = X2) and (Y1 = Y2)); //检验是否到达终点
  while not Finished do
  begin
    ExchangeWaves; //
    if not OldWave.Start then
      Break;
    repeat
      I := OldWave.Item;
      I.Cost := I.Cost - OldWave.MinCost; // 如果大于MinCost
      if I.Cost > 0 then // 加入NewWave
        NewWave.Add(I.X, I.Y, I.Cost, I.Direction) //更新Cost= cost-MinCost
      else
      begin //  处理最小COST的点
        if Result[I.Y, I.X].Distance >= 0 then
          Continue;

        Result[I.Y, I.X].Distance := Result[I.Y - DirToDY(I.Direction), I.X -
          DirToDX(I.Direction)].Distance + 1; // 此点 Distance:=上一个点Distance+1

        Result[I.Y, I.X].Direction := I.Direction;
          //
        Finished := ((I.X = X2) and (I.Y = Y2)); //检验是否到达终点
        if Finished then
          Break;
        TestNeighbours;
      end;
    until not OldWave.Next; //
  end; // OldWave;
  NewWave.Free;
  OldWave.Free;
end;


function TPathMap.FindPath(MapWidthin, MapHeightin, StartX, StartY, StopX,
  StopY: Integer; pGetCostFunc: TGetCostFunc): TPath;
begin
  Width := MapWidthin; //
  Height := MapHeightin; //
  GetCostFunc := pGetCostFunc;
  PathMapArray := FillPathMap(StartX, StartY, StopX, StopY);
  Result := FindPathOnMap(StopX, StopY);
end;

function TPathMap.FindPathOnMap(X, Y: Integer): TPath;
var
  Direction: Integer;
begin
  Result := nil;
  if (X >= Width) or (Y >= Height) then
    Exit;
  if PathMapArray[Y, X].Distance < 0 then
    Exit;
  SetLength(Result, PathMapArray[Y, X].Distance + 1); //
  while PathMapArray[Y, X].Distance > 0 do
  begin
    Result[PathMapArray[Y, X].Distance] := Point(X, Y);
    Direction := PathMapArray[Y, X].Direction;
    X := X - DirToDX(Direction);
    Y := Y - DirToDY(Direction);
  end;
  Result[0] := Point(X, Y);
  CurMovePos := 1; //TODO : 这里设定移动的开始点
end;


function TPathMap.GetCost(X, Y, Direction: Integer): Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= Width) or (Y < 0) or (Y >= Height) then
    Result := -1
  else
    Result := GetCostFunc(X, Y, Direction, PathWidth);
end;

procedure TPathMap.MakePathMap(MapWidthin, MapHeightin, StartX, StartY: Integer;
  pGetCostFunc: TGetCostFunc);
begin
  Width := MapWidthin;
  Height := MapHeightin; //
  GetCostFunc := pGetCostFunc;
  PathMapArray := FillPathMap(StartX, StartY, -1, -1);
end;

{ TWave }

procedure TWave.Add(NewX, NewY, NewCost, NewDirection: Integer);
begin
  if FCount >= Length(FData) then //
    SetLength(FData, Length(FData) + 30); //
  with FData[FCount] do
  begin
    X := NewX;
    Y := NewY;
    Cost := NewCost;
    Direction := NewDirection;
  end;
  if NewCost < FMinCost then //NewCost
    FMinCost := NewCost;
  Inc(FCount); //
end;

procedure TWave.Clear;
begin
  FPos := 0;
  FCount := 0;
  FMinCost := High(Integer);
end;

constructor TWave.Create;
begin
  Clear;
end;

destructor TWave.Destroy;
begin
  FData := nil; //
  inherited Destroy;
end;

function TWave.GetItem: TWaveCell;
begin
  Result := FData[FPos]; //
end;

function TWave.Next: Boolean;
begin
  Inc(FPos); //
  Result := (FPos < FCount); // false,
end;

function TWave.Start: Boolean;
begin
  FPos := 0; //
  Result := (FCount > 0); //
end;

  { TNewSearchPathClass }

constructor TNewSearchPathClass.Create;
begin
  MapWidth := 100; MapHeight := 100;
  MapLeft := 0; MapTop := 0;
  //SetLength(MapData, 1000, 1000);
end;

destructor TNewSearchPathClass.Destroy;
begin
  inherited Destroy;
end;

function TNewSearchPathClass.GetCost(X, Y, Direction: Integer): Integer;
var
  cost: Integer;
begin
  Direction := (Direction and 7);
  if (X < 0) or (X >= MapWidth) or (Y < 0) or (Y >= MapHeight) then
    Result := -1
  else
  begin
    //if (MapData[x, y] <> 0) or (not CharList.isMovable(x, y)) then begin
    if (not Maper.isMoveable(x, y)) then begin
      Result := -1;
      exit;
    end
    else
      Result := 4;
    if ((Direction and 1) = 1) and (Result > 0) then // 如果是斜方向,则COST增加
      Result := Result + (Result shr 1); //应为Result*sqt(2),此处近似为1.5
  end;
end;

procedure TNewSearchPathClass.SetMaper(aMaper: TcMaper);
begin
  Maper := aMaper;
  MapWidth := Maper.Width;
  MapHeight := Maper.Height;
  Width := Maper.Width;
  Height := Maper.Height;
  //MapData := nil;
  //SetLength(MapData, Width, Height);
end;

function TNewSearchPathClass.FindPath(StartX, StartY, StopX, StopY, PathSpace: Integer): TPath;
begin
  PathWidth := PathSpace;
  if (not Maper.isMoveable(stopx, Stopy)) then //or (not CharList.isMovable(Stopx, Stopy)) then
  begin
    Result := nil;
    exit;
  end;
  PathMapArray := FillPathMap(StartX, StartY, StopX, StopY);
  Result := FindPathOnMap(StopX, StopY);
end;

function TNewSearchPathClass.GotoPath(x1, y1, x2, y2: Integer; var x, y: Integer): boolean;
var
  i: integer;
begin
  FPath := nil;
  pathlist.Clear;
  FPath := FindPath(x1, y1, x2, y2, 1);
  if Assigned(FPath) then begin
//    for i := Low(FPath) to High(FPath) do begin
//      pathlist.add(FPath[i].X,FPath[i].Y);
//    end;
    x := x2;
    y := y2;
  end
  else begin
    x := -1;
    y := -1;
  end;
end;

//2016.03.21 在水一方 移植新寻路算法 <<<<<<

initialization
  begin
    cSearchPathClass := TcSearchPathClass.Create;
    nSearchPathClass := TNewSearchPathClass.Create;
    pathlist := Tpathlist.Create;
    cMaper := TcMaper.Create('');
  end;

finalization
  begin
    cSearchPathClass.Free;
    nSearchPathClass.Free;
    cMaper.Free;
    pathlist.Free;
  end;

end.

