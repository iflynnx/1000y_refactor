unit A2Img;

interface

uses
  Windows, SysUtils, Classes, Graphics, BmpUtil, StrUtils, uCrypt;

const
  ImageLibID = 'ATZ0';
  ImageLibID1 = 'ATZ1';
  ImageLibID2 = 'ATZ2';
  ImageLibID3 = 'ATZ3';
  ImageLibID4 = 'ATZ4';

  ImageLibEFD0 = 'EFD0';
  ImageLibEFD1 = 'EFD1';
  ImageLibEFD2 = 'EFD2';
  imageBm = 'BM';

  MaxPixelCount = 32768;
type

  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..MaxPixelCount - 1] of TRGBTriple;
  TAns2Color = word;
  PTAns2Color = ^TAns2Color;

  TA2ImageFileHeader = record
    Width: Integer;
    Height: Integer;
    px, py: Integer;
    none: Integer;
  end;

    //$26长度
  TA2ImageEFD_FileHeader = record
    IDent: array[0..1] of Char;
    id: word;
    px: smallint;
    py: smallint;
        // arr:array[0..$26 - 1 - 8] of byte;
  end;
  TA2ImageLibHeader = record
    IDent: array[0..3] of Char;
    ImageCount: Integer;
    TransparentColor: Integer;
    Palette: TImgLibPalette;
  end;

  TInSpaceData = record
    spb, dpb: Pbyte;
    R: TRect;
  end;
  TDrawType = (
    _dt_none, //透明
    _dt_Add, //加法
    _dt_Multiply, //乘法
    _dt_Lighten, //变亮
    _dt_Darken, //变暗
    _dt_SoftLight,
    _dt_Opacity //透明度
    , _dt_Screen //滤色
    , _dt_ColorDodge //颜色减淡
    , _dt_LinearDodge //线形减淡
    , _dt_LinearBurn //
    , _dt_Overlay //叠加
    , _dt_HardLight //强光
    , _dt_HardMix //实色混合
    , _dt_PinLight //点光
    );
  TA2Image = class
  private
    FClientRect: TRect;
    procedure DrawImageAdd_2(AnsImage: TA2Image; x, y: Integer);
    procedure DrawImageOveray_2(AnsImage: TA2Image; x, y, weight: integer);







  protected
    function GetInSpace(AImage: TA2Image; x, y: integer; var InSpaceData: TInSpaceData): Boolean;
    procedure DrawFont(AImage: TA2Image; x, y, aColor: Integer);
    procedure DrawFontKeyColor(AnsImage: TA2Image; x, y, aColor: integer; ptable: pword);

  public
    Name: string;
    px, py: integer;
    Width, Height: Integer;
    Bits: PTAns2Color;
    TransparentColor: Integer;
    DrawOnBack: Boolean;

    constructor Create(AWidth, AHeight, Apx, Apy: Integer);
    destructor Destroy; override;
    procedure GetImage(AnsImage: TA2Image; x, y: Integer);
    procedure CopyImage(AnsImage: TA2Image);
    procedure DrawImageDither(AnsImage: TA2Image; x, y, adither: integer; aTrans: Boolean);
        //折射率
    procedure DrawRefractive(AnsImage: TA2Image; x, y, Refracrange, overValue: Integer); // ankudo 010118
        //MMX 汇编优化
    procedure DrawImage(AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
     procedure DrawImageEx(AnsImage: TA2Image; x, y,Awidth,Aheight: Integer; aTrans: Boolean); 
    procedure DrawImage_2(AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
    procedure DrawImageGreenConvert(AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word);
    procedure DrawImageGreenConvert2(AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word; Weight: integer);
    procedure DrawImageKeyColor(AnsImage: TA2Image; x, y: Integer; col: word; ptable: pword);
    procedure DrawImageKeyColor2(AnsImage: TA2Image; x, y: Integer; col: word; ptable: pword);
    procedure DrawImageOveray(AnsImage: TA2Image; x, y: Integer; Weight: integer);
    procedure DrawImageAdd(AnsImage: TA2Image; x, y: Integer);

    procedure Clear(Color: word);
    procedure EraseRect(R: TRect; Color: word);
    procedure hLine(x, y, w: Integer; Col: word);
    procedure DrawhLine(x, y, w: Integer; Col: word;H:Integer);
    procedure vLine(x, y, h: Integer; Col: word);
    procedure Pixels(x, y: Integer; Col: word);
    procedure Resize(aWidth, aheight: Integer);
    procedure SaveToFile(FileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToBitmap(Bitmap: TBitmap);

    procedure LoadFromFile(FileName: string);
    procedure LoadFromFileDIB(FileName: string);
    procedure LoadFromFileTrueColor(FileName: string);

    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromBitmap(Bitmap: TBitmap);
    procedure Optimize;
    procedure OptimizeWidth;

    procedure Setsize(aWidth, aheight: Integer);

    procedure stroke(acol: word);
    procedure stroke_inner(acol, mcol: word);
    procedure strokeCler(acol: word);
    procedure delColor(acol: word);
    procedure addColor(ar, ag, ab: word);
    procedure DrawImage_(aDrawType: TDrawType; at1, at2, at3: single; col: word; ptable: pword; AnsImage: TA2Image; x, y: Integer); //aLight 0.5-2.0
  published
  end;
    //图标 列表
  TA2ImageLib = class
  private
    temp: TA2Image;
    FTag: integer;
    ImageList: TList;
    function GeTA2Image(Idx: Integer): TA2Image;
    function GetCount: Integer;


  public
    TransparentColor: word;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddImage(AImage: TA2Image);
    procedure InsertImage(Idx: Integer; AImage: TA2Image);
    procedure DeleteImage(Idx: Integer);

        //使用 A2IMG.LoadFromStream
    procedure LoadFromStreamFenge(aStream: TStream); //1个BMP图片，32*32小块

    procedure LoadFromFile(FileName: string);
    procedure LoadFromStream(aStream: TStream);


        //使用 A2IMG.LoadFromStream
    procedure LoadFromFileEFT(FileName: string);
    procedure LoadFromStreamEFT(aStream: TStream);

    procedure SaveToFile(FileName: string);
    function GetByName(aName: string): TA2Image;
    property Images[Index: Integer]: TA2Image read GeTA2Image; default;
    property Count: Integer read GetCount;
    property Tag: integer read FTag write FTag;


    procedure SaveToStream(Stream: TMemoryStream);
  published
  end;

  TA2FontClass = class
  private
    FontA2ImageList: array[0..65536 - 1] of pointer;

    function GetFontImage(n: integer): TA2Image;
  public
    FBitMap: TBitmap;
    constructor Create;
    destructor Destroy; override;
    procedure SetFont(afont: string);
    function GetFont: tfont;
    function BmpToA2Image(aBmp: TBitMap; aImage: TA2Image): integer;
  end;

var
  Error: integer;
  darkentbl: array[0..65535] of word;
  Bubbletbl: array[0..65535] of word;
  DECRGBdarkentbl: array[0..65535] of word;

  A2FontClass,A2FontClassEx,A2FontClassBold: TA2FontClass;
  A2FontClass5,A2FontClass6,A2FontClass7,A2FontClass8,A2FontClass9,A2FontClass10,A2FontClass11,A2FontClass12,A2FontClass13: TA2FontClass;   //2015.12.19 在水一方
  OptFont: Boolean;

  BitMapFontName: string = 'Arial';

  atzdir, atzfile, atztemp: string;
procedure ATextOut(A2Image: TA2Image; x, y, FontColorIndex: integer; atext: string);
procedure ATextOutBold(A2Image: TA2Image; x, y, FontColorIndex: integer; atext: string);
function ATextOutEx(A2Image: TA2Image; x, y, FontColorIndex: integer; atext: string;ASize:integer;var AVheight:integer): integer;
function ATextWidth(atext: string): integer;

function ATextHeight(atext: string): integer;
procedure GetMaxTextWH(var W, H: integer; aStringList: TStringList);

procedure A2DrawImage(Canvas: TCanvas; X, Y: Integer; ansImage: TA2Image);
//procedure A2DrawImageDC(dc:HDC; X, Y:Integer; ansImage:TA2Image);
procedure AnsPaletteDataToAns2Image(Ans2Image: TA2Image; Palette: TImgLibPalette; pb: Pbyte);
procedure AnsTrueDataToAns2Image(Ans2Image: TA2Image; pb: pbyte);

//procedure A2SetFontName(aFontName:string);
//procedure A2TextOut(aImage:TA2Image; FontSize, x, y:integer; astr:string);
//function A2TextWidth(astr:string):integer;
//function A2TextHeight(astr:string):integer;
//procedure A2SetFontColor(aColor:integer);

//function A2GetCanvas:TCanvas;
//procedure A2DrawCanvas(aImage:TA2Image; x, y, sw, sh:integer; aTrans:Boolean);

function WinRGB(r, g, b: word): word;
procedure WinVRGB(n: word; var r, g, b: word);

function CutLengthString(var SourceStr: string; aWidth: integer): string;

function GetPBitmapInfo(aWidth, aHeight, aBitCount: integer): TBitMapInfo;

function ColorSysToDxColor(aColor: dword): word;
function ColorDxColorToSys(aColor: word): dword;

procedure BitmapClear(TmpBmp: TBitmap; acolor: Tcolor);
procedure DrawRectangle(Fback: TA2Image; lc: array of tcolor);
implementation

{$O+}

procedure BitmapClear(TmpBmp: TBitmap; acolor: Tcolor);
var
  i, j: Integer;
  DestRow: PRGBArray;
  r, g, b: byte;
begin
  if TmpBmp.PixelFormat <> pf24bit then TmpBmp.PixelFormat := pf24bit;
  R := GetRValue(acolor);
  G := GetGValue(acolor);
  B := GetBValue(acolor);
  for i := 0 to TmpBmp.Height - 1 do
  begin

    DestRow := TmpBmp.ScanLine[i];
    for j := 0 to TmpBmp.Width - 1 do
    begin
      DestRow[j].rgbtRed := r;
      DestRow[j].rgbtGreen := g;
      DestRow[j].rgbtBlue := b;
    end;
  end;

end;

procedure DrawRectangle(Fback: TA2Image; lc: array of tcolor);
var
  Bitmap: TBitmap;
  bc: Tcolor;
  alen, i: integer;
begin
  Fback.Clear(0);
  alen := high(lc);
  bc := ColorDxColorToSys(31);
    //画边框
  Bitmap := tBitmap.Create;
  try
    Bitmap.Width := Fback.Width;
    Bitmap.Height := Fback.Height;
    Bitmap.PixelFormat := pf24bit;

    BitmapClear(Bitmap, clBlack);

        //  Bitmap.Canvas.Brush.Style := bsClear;
    for i := 0 to alen do
    begin
      if i = alen then
        Bitmap.Canvas.Brush.Color := bc
      else Bitmap.Canvas.Brush.Color := lc[i];

      Bitmap.Canvas.Pen.color := lc[i];
      Bitmap.Canvas.RoundRect(i, i, Bitmap.Width - 1 - i, Bitmap.Height - 1 - i, 9, 9);
    end;

    Fback.LoadFromBitmap(Bitmap);
    Fback.TransparentColor := 0;
  finally
    Bitmap.Free;
  end;

end;

function ColorDxColorToSys(aColor: word): dword;
var
  r, g, b: word;
begin
  WinVRGB(acolor, r, g, b);
  result := RGB(r * 8, g * 8, b * 8);
end;

function ColorSysToDxColor(aColor: dword): word;
begin
  result := WinRGB(GetRValue(acolor) div 8, GetGValue(acolor) div 8, GetBValue(acolor) div 8);
end;

function CutLengthString(var SourceStr: string; aWidth: integer): string;
var
  i, n: integer;
  str: Widestring;
begin
  Result := '';
  if (SourceStr = '') or (aWidth < 1) then exit;
  n := 0;
  str := SourceStr;
  for i := 1 to Length(Str) do
  begin
    n := n + ATextWidth(Str[i]) + 1;
    if n > aWidth then
    begin
      SourceStr := Copy(str, i, Length(str));
      exit;
    end;
    Result := Result + Str[i];
  end;
  Result := SourceStr;
  SourceStr := '';
end;

function GetCurrentChar(atext: string; var curPos, rValue: integer): Boolean;
var
  buf: array[0..2] of char;
begin
  Result := FALSE;
  if Length(atext) < curpos then exit;

  if byte(atext[curpos]) < 128 then
  begin
    buf[0] := atext[curpos];
    buf[1] := char(0);
    inc(curPos);
    rValue := PWORD(@Buf)^;
  end else
  begin
    buf[0] := atext[curpos];
    inc(curpos);
    buf[1] := atext[curpos];
    inc(curpos);
    rValue := PWORD(@Buf)^;
  end;
  Result := TRUE;
end;
procedure ATextOutBold(A2Image: TA2Image; x, y, FontColorIndex: integer; atext: string);
var
  FontImage: TA2Image;
  curpos, rValue: integer;

begin
  if atext = '' then exit;
  curpos := 1;
  rValue := 0;
  while TRUE do
  begin
    if not GetCurrentChar(atext, curpos, rValue) then break;

     A2FontClassBold.GetFont.Size:=9;
    FontImage := A2FontClassBold.GetFontImage(rValue);
    A2FontClassBold.GetFont.Style:=[fsBold];
       A2FontClassBold.GetFont.Name:='宋体';
    if FontImage <> nil then
    begin
      A2Image.DrawFont(FontImage, x, y, FontColorIndex);
      x := x + FontImage.Width; //+ 1; // 2008年 10月修改 +1后无法 在输出前计算 长度
    end;
  end;
end;
procedure ATextOut(A2Image: TA2Image; x, y, FontColorIndex: integer; atext: string);
var
  FontImage: TA2Image;
  curpos, rValue: integer;
begin
  if atext = '' then exit;
  curpos := 1;
  rValue := 0;
  while TRUE do
  begin
    if not GetCurrentChar(atext, curpos, rValue) then break;
     A2FontClass.GetFont.Size:=9;
    FontImage := A2FontClass.GetFontImage(rValue);
    A2FontClass.GetFont.Style:=[];
    if FontImage <> nil then
    begin
      A2Image.DrawFont(FontImage, x, y, FontColorIndex);
      x := x + FontImage.Width; //+ 1; // 2008年 10月修改 +1后无法 在输出前计算 长度
    end;
  end;
end;
procedure ATextOutExOld(A2Image: TA2Image; x, y, FontColorIndex: integer; atext: string;ASize:integer;var AVheight:integer);
var
  FontImage: TA2Image;
  curpos, rValue: integer;
  A2FontClass:TA2FontClass;
begin
  if atext = '' then exit;
  curpos := 1;
  rValue := 0;
  while TRUE do
  begin
  try
   A2FontClass:=TA2FontClass.Create;
    if not GetCurrentChar(atext, curpos, rValue) then break;
    A2FontClass.GetFont.Size:=ASize;
    A2FontClass.GetFont.Name:='宋体';
    FontImage := A2FontClass.GetFontImage(rValue);
    if FontImage <> nil then
    begin
    AVheight:=  FontImage.Height;
    if A2Image<> nil then
      A2Image.DrawFont(FontImage, x, y, FontColorIndex);
      x := x + FontImage.Width; //+ 1; // 2008年 10月修改 +1后无法 在输出前计算 长度

    end;
    finally
    A2FontClass.Free;
    end;
  end;
end;
function ATextOutEx(A2Image: TA2Image; x, y, FontColorIndex: integer; atext: string;ASize:integer;var AVheight:integer): integer; //2015.12.19 在水一方
var
  FontImage: TA2Image;
  curpos, rValue: integer;
  A2FontClass:TA2FontClass;
begin
  Result := 0;
  if not OptFont then begin
    ATextOutExOld(A2Image,x,y,FontColorIndex,atext,ASize,AVheight);
    Exit;
  end;
  if atext = '' then exit;
  curpos := 1;
  rValue := 0;
  while TRUE do
  begin
    if not GetCurrentChar(atext, curpos, rValue) then break;
    case ASize of
      5:
        begin
          if A2FontClass5 = nil then exit;
          A2FontClass5.GetFont.Size:=ASize;
          A2FontClass5.GetFont.Style:=[];
          FontImage := A2FontClass5.GetFontImage(rValue);
        end;
      6:
        begin
          if A2FontClass6 = nil then exit;
          A2FontClass6.GetFont.Size:=ASize;
          A2FontClass6.GetFont.Style:=[];
          FontImage := A2FontClass6.GetFontImage(rValue);
        end;
      7:
        begin 
          if A2FontClass7 = nil then exit;
          A2FontClass7.GetFont.Size:=ASize;
          A2FontClass7.GetFont.Style:=[];
          FontImage := A2FontClass7.GetFontImage(rValue);
        end;
      8:
        begin 
          if A2FontClass8 = nil then exit;
          A2FontClass8.GetFont.Size:=ASize;
          A2FontClass8.GetFont.Style:=[];
          FontImage := A2FontClass8.GetFontImage(rValue);
        end; 
      9:
        begin 
          if A2FontClass9 = nil then exit;
          A2FontClass9.GetFont.Size:=ASize;
          A2FontClass9.GetFont.Style:=[];
          FontImage := A2FontClass9.GetFontImage(rValue);
        end;
      10:
        begin
          if A2FontClass10 = nil then exit;
          A2FontClass10.GetFont.Size:=ASize;
          A2FontClass10.GetFont.Style:=[];
          FontImage := A2FontClass10.GetFontImage(rValue);
        end;
      11:
        begin 
          if A2FontClass11 = nil then exit;
          A2FontClass11.GetFont.Size:=ASize;
          A2FontClass11.GetFont.Style:=[];
          FontImage := A2FontClass11.GetFontImage(rValue);
        end;
      12:
        begin
          if A2FontClass12 = nil then exit;
          A2FontClass12.GetFont.Size:=ASize;
          A2FontClass12.GetFont.Style:=[];
          FontImage := A2FontClass12.GetFontImage(rValue);
        end;
      13:
        begin
          if A2FontClass13 = nil then exit;
          A2FontClass13.GetFont.Size:=11;
          A2FontClass13.GetFont.Style:=[fsBold];  
          //A2FontClass13.GetFont.Name:='楷体';
          FontImage := A2FontClass13.GetFontImage(rValue);
        end;
    else
      begin
        A2FontClass:=TA2FontClass.Create;
        try
          A2FontClass.GetFont.Size:=ASize;
          A2FontClass.GetFont.Name:='宋体';
          FontImage := A2FontClass.GetFontImage(rValue);
          if FontImage <> nil then
          begin
            AVheight:=  FontImage.Height;
            if A2Image<> nil then
              A2Image.DrawFont(FontImage, x, y, FontColorIndex);
            x := x + FontImage.Width; //+ 1; // 2008年 10月修改 +1后无法 在输出前计算 长度
          end;
        finally
          A2FontClass.Free;
        end;
      end;
    end;
    if (FontImage <> nil) and (ASize in [5..13]) then
    begin
      AVheight:=  FontImage.Height;
      if A2Image<> nil then
        A2Image.DrawFont(FontImage, x, y, FontColorIndex);
      x := x + FontImage.Width; //+ 1; // 2008年 10月修改 +1后无法 在输出前计算 长度
    end;
  end;
  Result := x;
end;
function ATextWidth(atext: string): integer;
var
  FontImage: TA2Image;
  w, curpos, rValue: integer;
begin
  Result := 0;
  if atext = '' then exit;
  curpos := 1;
  rValue := 0;
  w := 0;
  while TRUE do
  begin
    //if w <> 0 then w := w + 1;
    if not GetCurrentChar(atext, curpos, rValue) then break;
    FontImage := A2FontClass.GetFontImage(rValue);
    if FontImage <> nil then w := w + FontImage.Width;
  end;
  Result := w;
end;

function ATextHeight(atext: string): integer;
var
  FontImage: TA2Image;
  h, curpos, rValue: integer;
begin
  Result := 0;
  if atext = '' then exit;

  curpos := 1;
  rValue := 0;
  h := 0;
  while TRUE do
  begin
    if not GetCurrentChar(atext, curpos, rValue) then break;
    FontImage := A2FontClass.GetFontImage(rValue);
    if FontImage <> nil then if h < FontImage.Height then h := FontImage.Height;
  end;
  Result := h;
end;

procedure GetMaxTextWH(var W, H: integer; aStringList: TStringList);
var
  xx, yy, i: integer;
begin
  W := 0;
  H := 0;
  for i := 0 to aStringList.Count - 1 do
  begin
    xx := ATextWidth(aStringList[i]);
    yy := ATextHeight(aStringList[i]);
    if W < xx then W := xx;
    if H < yy then H := yy;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//                      TA2FontClass
////////////////////////////////////////////////////////////////////////////////

constructor TA2FontClass.Create;
//var
  //  DC              :HDC;
  //  Focus           :hWnd;
  //  TEMP            :TBitMapinfo;
begin
  FBitMap := TBitMap.Create;
    //  TEMP := GetPBitmapInfo(64, 64, 16);
    //  Focus := GetFocus;
     // dc := GetDC(Focus);
   //   FBitMap.Handle := CreateDIBitmap(GetDC(GetFocus), TEMP.bmiHeader, 0, Pointer(0), TEMP, 0);
    //  ReleaseDC(Focus, DC);
     // if FBitMap.Handle = 0 then raise Exception.Create('CreateDIBitmap failed');
  //  FBitMap.Canvas.Handle := GetDC(GetFocus);
  FBitMap.Width := 64;
  FBitMap.Height := 64;
  FBitMap.PixelFormat := pf24bit;
  FBitMap.Canvas.Font.Name := '宋体';//'微软雅黑';    //
  FBitMap.Canvas.Font.Size := 9;
  FBitMap.Canvas.Font.Color := clWhite;
  FBitMap.Canvas.Brush.Color := clBlack;
  FillChar(FontA2ImageList, sizeof(FontA2ImageList), 0);
end;

destructor TA2FontClass.Destroy;
var
  i: integer;
begin
  for i := 0 to 65536 - 1 do if FontA2ImageList[i] <> nil then TA2Image(FontA2ImageList[i]).Free;
  FBitMap.Free;
  inherited destroy;
end;

function TA2FontClass.BmpToA2Image(aBmp: TBitMap; aImage: TA2Image): integer;
var
  TEMP: TBitMapinfo;
begin
  TEMP := GetPBitmapInfo(aImage.Width, aImage.Height, 16);
  Result := GetDIBits(aBmp.Canvas.Handle, aBmp.Handle, 0, aImage.Height, aImage.Bits, TEMP, DIB_PAL_COLORS);
end;
//返回 1个字 的图片

function TA2FontClass.GetFontImage(n: integer): TA2Image;
var
  str: string;
  buf: array[0..3] of char;
  TempImage: TA2Image;
begin
  Result := nil;
  if n = 0 then exit;
  if FontA2ImageList[n] = nil then
  begin
    move(n, buf, 2);
    buf[2] := char(0);
    str := StrPas(@buf);
    if str = '' then exit;
        //生成 图片
    BitmapClear(FBitMap, 0);
    FBitMap.Width := FBitMap.Canvas.TextWidth(str);
    FBitMap.Height := FBitMap.Canvas.TextHeight(str);
  //  FBitMap.Canvas.Font.Size:=20;
    FBitMap.Canvas.TextOut(0, 0, str);
    TempImage := TA2Image.Create(32, 32, 0, 0);
    TempImage.LoadFromBitmap(FBitMap);
    TempImage.TransparentColor := 0;
        //if buf[1] = #0 then
        //TempImage.OptimizeWidth;
    FontA2ImageList[n] := (TempImage);
  end;
  Result := TA2Image(FontA2ImageList[n]);
end;

function TA2FontClass.GetFont: TFont;
begin
  result := FBitMap.Canvas.Font;
end;

procedure TA2FontClass.SetFont(afont: string);
begin
  FBitMap.Canvas.Font.Name := afont;
end;

function WinRGB(r, g, b: word): word;
begin
  Result := b + (g shl 5) + (r shl 10);
end;

procedure WinVRGB(n: word; var r, g, b: word);
begin
  b := n and $1F;
  g := (n shr 5) and $1F;
  r := (n shr 10) and $1F;
end;

function WinRGBs(rs, gs, bs: single): word;
var
  r, g, b: word;
begin
  r := trunc(rs * 31);
  g := trunc(gs * 31);
  b := trunc(bs * 31);
  if r > 31 then r := 31;
  if g > 31 then g := 31;
  if b > 31 then b := 31;
  Result := b + (g shl 5) + (r shl 10);
end;

procedure WinVRGBs(n: word; var r, g, b: single);
begin
  b := (n and $1F) / 31;
  g := ((n shr 5) and $1F) / 31;
  r := ((n shr 10) and $1F) / 31;

end;
// 100%鳖瘤父'

function WinDECRGB(n: word; d: byte): word;
var
  r, g, b: word;
begin
  WinVRGB(n, r, g, b);
  if b > d then b := b - d
  else b := 0;
  if g > d then g := g - d
  else g := 0;
  if r > d then r := r - d
  else r := 0;
  Result := WinRGB(r, g, b);
end;

function WinOpercity(n: word; OperN: byte): word;
var
  r, g, b: word;
begin
  //  WinVRGB(n, r, g, b);
  b := n and $1F;
  g := (n shr 5) and $1F;
  r := (n shr 10) and $1F;

  b := (b * OperN) div 100;
  g := (g * OperN) div 100;
  r := (r * OperN) div 100;
  Result := b + (g shl 5) + (r shl 10); // WinRGB(r, g, b);
end;

const
  Contrast = 5;

function WinOpercityForCl1000(n: word; OperN: byte): word;
var
  r, g, b: word;
  i: integer;
begin
  WinVRGB(n, r, g, b);
  i := (r + g + b) div 3;
  i := i + i div 10;
  if r > i then
  begin
    r := r * (100 + Contrast) div 100;
    if r > 31 then r := 31;
  end else
  begin
    r := r * (100 - Contrast) div 100;
  end;
  if g > i then
  begin
    g := g * (100 + Contrast) div 100;
    if g > 31 then g := 31;
  end else
  begin
    g := g * (100 - Contrast) div 100;
  end;
  if b > i then
  begin
    b := b * (100 + Contrast) div 100;
    if b > 31 then b := 31;
  end else
  begin
    b := b * (100 - Contrast) div 100;
  end;

  b := (b * OperN div 100);
  g := (g * OperN div 100);
  r := (r * OperN div 100);
  Result := WinRGB(r, g, b);
end;

//////////////////////////////////////
//         TA2Image            //
//////////////////////////////////////

constructor TA2Image.Create(AWidth, AHeight, Apx, Apy: Integer);
begin

  TransparentColor := 0;
  Width := WidthBytes(AWidth); // 放弃 保持 一定规律宽度
  Height := (AHeight);
  px := Apx;
  py := Apy;
  Bits := nil;
  GetMem(Bits, Width * Height * Sizeof(TAns2Color));
  if Bits = nil then raise Exception.Create('TA2Image: GemMem Failed for Bits');
  FillChar(Bits^, Width * Height * Sizeof(TAns2Color), 0);
  FClientRect := Rect(0, 0, Width - 1, Height - 1);
end;

destructor TA2Image.Destroy;
begin

  if Bits <> nil then FreeMem(Bits); //Width * Height * sizeof(TAns2Color));
  inherited Destroy;
end;

procedure TA2Image.Clear(Color: word);
var
  i: integer;
  pcol: PTAns2Color;
begin
  if byte(Color shr 8) = byte(Color) then
  begin
    FillChar(Bits^, Width * Height * Sizeof(TAns2Color), byte(Color));
    exit;
  end;
  pcol := Bits;
  for i := 0 to Width * Height - 1 do
  begin
    pcol^ := Color;
    inc(pcol);
  end;
end;

procedure TA2Image.EraseRect(R: TRect; Color: word);
var
  dpb, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
begin
    //do clipping

  sr := Rect(R.Left, R.Top, R.Right - 1, R.Bottom - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  for i := ir.Top to ir.Bottom do
  begin
    TempDD := dpb;
    for j := ir.left to ir.right do
    begin
      TempDD^ := Color;
      Inc(TempDD);
    end;
    inc(dpb, Width);
  end;
end;

procedure TA2Image.hLine(x, y, w: Integer; Col: word);
var
  i: integer;
  pb: PTAns2Color;
begin
  if x < 0 then exit;
  if x + w >= Width then exit;
  if y < 0 then exit;
  if y >= Height then exit;
  pb := Bits;
  inc(pb, x + y * Width);
  for i := 0 to w - 1 do
  begin
    pb^ := Col;
    inc(pb);
  end;
end;

procedure TA2Image.Pixels(x, y: Integer; Col: word);
var
    //  i               :integer;
  pb: PTAns2Color;
begin
  if x < 0 then exit;
  if x >= Width then exit;
  if y < 0 then exit;
  if y >= Height then exit;
  pb := Bits;
  inc(pb, x + y * Width);
    //  for i := 0 to w - 1 do
  begin
    pb^ := Col;
    inc(pb);
  end;
end;

procedure TA2Image.vLine(x, y, h: Integer; Col: word);
var
  i: integer;
  pb: PTAns2Color;
begin
  if x < 0 then exit;
  if x >= Width then exit;
  if y < 0 then exit;
  if y + h >= Height then exit;
  pb := Bits;
  inc(pb, x + y * Width);
  for i := 0 to h - 1 do
  begin
    pb^ := Col;
    inc(pb, width);
  end;
end;

function TA2Image.GetInSpace(AImage: TA2Image; x, y: integer; var InSpaceData: TInSpaceData): Boolean;
var
  sr: TRect;
begin
  Result := FALSE;
  if AImage = nil then exit;
  sr := Rect(x, y, x + AImage.Width - 1, y + AImage.Height - 1);
  if not IntersectRect(InSpaceData.R, sr, FClientRect) then exit;

  InSpaceData.spb := pbyte(AImage.Bits);
  inc(InSpaceData.spb, ((InSpaceData.R.left - x) + (InSpaceData.R.top - y) * AImage.Width));

  InSpaceData.dpb := pbyte(Bits);
  inc(InSpaceData.dpb, (InSpaceData.R.left + InSpaceData.R.top * Width));
  Result := TRUE;
end;

procedure TA2Image.GetImage(AnsImage: TA2Image; x, y: Integer);
var
  spb, dpb: PTAns2Color;
  i: integer;
  ir, sr, dr: TRect;
begin
    //do clipping
  dr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  sr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := Bits;
  inc(spb, ir.left + ir.top * Width);

  dpb := AnsImage.Bits;
  inc(dpb, (ir.left - x) + (ir.top - y) * AnsImage.Width);

  for i := 0 to ir.Bottom - ir.Top do
  begin
    move(spb^, dpb^, (ir.right - ir.left + 1) * 2);
    inc(spb, Width);
    inc(dpb, AnsImage.Width);
  end;
end;

procedure TA2Image.DrawFont(AImage: TA2Image; x, y, aColor: Integer);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
    //   r,g,b : Word;
begin
  if AImage = nil then exit;

  sr := Rect(x, y, x + AImage.Width - 1, y + AImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    for j := ir.left to ir.right do
    begin
      if TempSS^ <> 0 then TempDD^ := aColor;
      inc(TempSS);
      Inc(TempDD);
    end;
    inc(spb, AImage.Width);
    inc(dpb, Width);
  end;
end;

procedure TA2Image.DrawFontKeyColor(AnsImage: TA2Image; x, y, aColor: Integer; ptable: pword);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  ptemp: pword;
    //   tempi, starti, endi : integer;
begin
  if AnsImage = nil then exit;

    //do clipping
  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    for j := ir.left to ir.right do
    begin
      if TempSS^ <> 0 then
      begin
        TempDD^ := aColor;
      end else
      begin
        ptemp := ptable;
        inc(ptemp, TempDD^);
        TempDD^ := ptemp^;
      end;
      inc(TempSS);
      Inc(TempDD);
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
end;
//换色 方式  （非直接替换）
{
procedure TA2Image.DrawImageGreenConvert(AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word);
var
    spb, dpb, TempSS, TempDD: PTAns2Color;
    i, j: integer;
    n, r, g, b, ar, ag, ab: word;
    ir, sr, dr: TRect;
begin
    if AnsImage = nil then exit;

   // WinVRGB(acol, ar, ag, ab);
    ab := acol and $1F;
    ag := (acol shr 5) and $1F;
    ar := (acol shr 10) and $1F;

    //do clipping

    sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
    dr := Rect(0, 0, Width - 1, Height - 1);

    if not IntersectRect(ir, sr, dr) then exit;

    spb := AnsImage.Bits;
    inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

    dpb := Bits;
    inc(dpb, (ir.left + ir.top * Width));

    for i := ir.Top to ir.Bottom do
    begin
        TempSS := spb;
        TempDD := dpb;
        for j := ir.left to ir.right do
        begin
            if TempSS^ <> AnsImage.TransparentColor then                        //不是透明色
            begin
               // WinVRGB(TempSS^, r, g, b);
                b := TempSS^ and $1F;
                g := (TempSS^ shr 5) and $1F;
                r := (TempSS^ shr 10) and $1F;
                if (r = 0) and (b = 0) then
                begin
                    n := g;
                    r := n * ar div 31 + defaultadd;
                    g := n * ag div 31 + defaultadd;
                    b := n * ab div 31 + defaultadd;
                    if r > 31 then r := 31;
                    if g > 31 then g := 31;
                    if b > 31 then b := 31;

                    TempDD^ := b + (g shl 5) + (r shl 10);                      // WinRGB(r, g, b);
                    if TempDD^ = 0 then TempDD^ := 1;
                end
                else TempDD^ := TempSS^;                                        //直接替换
            end;
            inc(TempSS);
            Inc(TempDD);
        end;
        inc(spb, AnsImage.Width);
        inc(dpb, Width);
    end;
end;

}

procedure TA2Image.DrawImageGreenConvert(AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j, k: integer;
  n, r, g, b, ar, ag, ab: word;
  ir, sr, dr: TRect;

  acol_R, acol_g, acol_b
    , defaultadd_64: int64;
const
  C_R15: int64 = $7C007C007C007C00;
  C_G15: int64 = $03E003E003E003E0;
  C_B15: int64 = $001F001F001F001F;
begin
  if AnsImage = nil then exit;



    //do clipping

  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

       // WinVRGB(acol, ar, ag, ab);
  ab := acol and $1F;
  ag := (acol shr 5) and $1F;
  ar := (acol shr 10) and $1F;
  i := acol;
  j := defaultadd;
  k := AnsImage.TransparentColor;
    //完成 64位置扩充
  asm

movd mm5,i
punpcklwd mm5,mm5
punpcklwd mm5,mm5
movq mm6,mm5
movq mm7,mm5

pand mm5,C_B15
pand mm6,C_G15
pand mm7,C_R15

psllw mm5,3  //l3
psrlw mm6,2  //l3 r5
psrlw mm7,7  //l3 r10

movq acol_b,mm5
movq acol_g,mm6
movq acol_r,mm7
/////////////////////////////
movd mm5,j
punpcklwd mm5,mm5
punpcklwd mm5,mm5
movq defaultadd_64,mm5

movd mm7,k
punpcklwd mm7,mm7
punpcklwd mm7,mm7
  end;

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    j := ir.right - ir.left;
    if j >= 0 then inc(j);
    if j >= 4 then
    begin
      asm
push edi
push esi
push eax
push ebx

mov esi,TempSS
mov edi,TempDD

mov eax,j
pxor mm6,mm6
@rgb555:

 movq mm2, [esi]    //原——读数据
 movq mm1, [edi]    //目标——读数据

 movq mm4,mm2
 pcmpeqw mm4,mm7
 pmovmskb ebx,mm4
 cmp ebx,$ff
 jz @Next_         //全透明结束
 movq mm0,mm4
 movq mm5,mm4
 pandn mm0,mm2    //保留不透明原始
 pand mm4,mm1     //保留透明目标 不变部分

//B，G，R  5转8    BYTE1
movq mm1,mm0
movq mm2,mm0
movq mm3,mm0
pand mm1,C_B15
pand mm2,C_G15
pand mm3,C_R15
psllw mm1,3
psrlw mm2,2  //r5 l3
psllw mm3,1  //   //回到BYTE2位置

//保留 R=0 and b=0 位置
 por mm1,mm3      //R,B合并到MM1
 pcmpeqw mm1,mm6  //MM1需要计算部位
 pand mm2,mm1     //保留出G
 //G=0就没必要 计算
 movq mm3,mm2
 pcmpeqw mm3,mm6
 pmovmskb ebx,mm3
 cmp ebx,$ff
 jz @save_edi  //G都=0，转保存
    //////////////////////////////////
    pandn mm1,mm0  //MM1不计算部分
    movq mm3,mm2
    movq mm0,mm2
    // g*acol div 255
    pmullw mm2,acol_b
    pmullw mm3,acol_g
    pmullw mm0,acol_r
    psrlw mm2,8   //r8
    psrlw mm3,8   //r8
    psrlw mm0,8   //r8

    paddusb mm2,defaultadd_64
    paddusb mm3,defaultadd_64
    paddusb mm0,defaultadd_64

    psrlw mm2,3   //r3
    psrlw mm3,3   //r3
    psrlw mm0,3   //r3

    psllw mm3,5   //r3 l5
    psllw mm0,10
    por mm0,mm3
    por mm0,mm2  //计算部分MM0

    //=0的保证至少是1
    movq mm2,mm0
    pcmpeqw mm2,mm6
    psrlw mm2,15
    por mm0,mm2

    pandn mm5,mm0

    por mm5,mm1
    movq mm0,mm5
    /////////////////////////////////////////
@save_edi:
 por mm0,mm4
 movq [edi],mm0   //保存
/////////////////////////////////////////


@Next_:

add esi,8
add edi,8

sub eax,4
cmp eax,4
jge @rgb555
mov j,eax
mov TempSS,esi
mov Tempdd,edi
//emms

pop ebx
pop eax
pop esi
pop edi


      end;
    end;


    while j > 0 do
    begin
      if TempSS^ <> AnsImage.TransparentColor then //不是透明色
      begin
               // WinVRGB(TempSS^, r, g, b);
        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;
        if (r = 0) and (b = 0) then
        begin
          n := g;
          r := n * ar div 31 + defaultadd;
          g := n * ag div 31 + defaultadd;
          b := n * ab div 31 + defaultadd;
          if r > 31 then r := 31;
          if g > 31 then g := 31;
          if b > 31 then b := 31;

          TempDD^ := b + (g shl 5) + (r shl 10); // WinRGB(r, g, b);
          if TempDD^ = 0 then TempDD^ := 1;
        end
        else TempDD^ := TempSS^; //直接替换
      end;
      inc(TempSS);
      Inc(TempDD);
      dec(j);
    end;

    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
  asm
        emms
  end;
end;

procedure TA2Image.DrawImageGreenConvert2(AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word; Weight: integer);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j, k: integer;
  n, r, g, b, r2, g2, b2, ar, ag, ab: word;
  ir, sr, dr: TRect;

  acol_R, acol_g, acol_b, acol_a
    , defaultadd_64: int64;
const
  C_R15: int64 = $7C007C007C007C00;
  C_G15: int64 = $03E003E003E003E0;
  C_B15: int64 = $001F001F001F001F;
begin
  if AnsImage = nil then exit;
  
  if weight > 100 then weight := 100;
  if weight < 0 then weight := 0;
  weight := weight * 255 div 100;

    //do clipping

  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

       // WinVRGB(acol, ar, ag, ab);
  ab := acol and $1F;
  ag := (acol shr 5) and $1F;
  ar := (acol shr 10) and $1F;
  i := acol;
  j := defaultadd;
  k := AnsImage.TransparentColor;
    //完成 64位置扩充
  asm

movd mm5,weight
punpcklwd mm5,mm5
punpcklwd mm5,mm5
movq acol_a,mm5

movd mm5,i
punpcklwd mm5,mm5
punpcklwd mm5,mm5
movq mm6,mm5
movq mm7,mm5

pand mm5,C_B15
pand mm6,C_G15
pand mm7,C_R15

psllw mm5,3  //l3
psrlw mm6,2  //l3 r5
psrlw mm7,7  //l3 r10

movq acol_b,mm5
movq acol_g,mm6
movq acol_r,mm7
/////////////////////////////
movd mm5,j
punpcklwd mm5,mm5
punpcklwd mm5,mm5
movq defaultadd_64,mm5

movd mm7,k
punpcklwd mm7,mm7
punpcklwd mm7,mm7
  end;

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    j := ir.right - ir.left;
    if j >= 0 then inc(j);
    if j >= 4 then
    begin
      asm
push edi
push esi
push eax
push ebx

mov esi,TempSS
mov edi,TempDD

mov eax,j
//pxor mm6,mm6
@rgb555:

 movq mm2, [esi]    //原——读数据
 movq mm1, [edi]    //目标——读数据

 pxor mm6,mm6
 movq mm4,mm2
 pcmpeqw mm4,mm7
 pmovmskb ebx,mm4
 cmp ebx,$ff
 jz @Next_         //全透明结束
 movq mm0,mm4
// movq mm5,mm4
 pandn mm0,mm2    //保留不透明原始
 pand mm4,mm1     //保留透明目标 不变部分
 movq mm5,mm1

//B，G，R  5转8    BYTE1
movq mm1,mm0
movq mm2,mm0
movq mm3,mm0
pand mm1,C_B15
pand mm2,C_G15
pand mm3,C_R15
psllw mm1,3
psrlw mm2,2  //r5 l3
psllw mm3,1  //   //回到BYTE2位置

//保留 R=0 and b=0 位置
 por mm1,mm3      //R,B合并到MM1
 pcmpeqw mm1,mm6  //MM1需要计算部位
 pand mm2,mm1     //保留出G
 //G=0就没必要 计算
 movq mm3,mm2
 pcmpeqw mm3,mm6
 pmovmskb ebx,mm3
 cmp ebx,$ff
 jz @save_edi  //G都=0，转保存
    //////////////////////////////////
    pandn mm1,mm0  //MM1不计算部分
    movq mm3,mm2
    movq mm0,mm2
    // g*acol div 255
    pmullw mm2,acol_b
    pmullw mm3,acol_g
    pmullw mm0,acol_r
    psrlw mm2,8   //r8
    psrlw mm3,8   //r8
    psrlw mm0,8   //r8
    // g*acol div 255
    pmullw mm2,acol_a
    pmullw mm3,acol_a
    pmullw mm0,acol_a
    psrlw mm2,8   //r8
    psrlw mm3,8   //r8
    psrlw mm0,8   //r8

    paddusb mm2,defaultadd_64
    paddusb mm3,defaultadd_64
    paddusb mm0,defaultadd_64
/////////////////////
    movq mm1,mm5
    movq mm6,mm5
    pand mm1,C_B15
    psllw mm1,3
    pand mm5,C_G15
    psrlw mm5,2
    pand mm6,C_R15
    psrlw mm6,7
    paddusb mm2,mm1
    paddusb mm3,mm5
    paddusb mm0,mm6
/////////////////////

    psrlw mm2,3   //r3
    psrlw mm3,3   //r3
    psrlw mm0,3   //r3

    psllw mm3,5   //r3 l5
    psllw mm0,10
    por mm0,mm3
    por mm0,mm2  //计算部分MM0
/////////////////////////////////////////
@save_edi:
 por mm0,mm4
 movq [edi],mm0   //保存
/////////////////////////////////////////


@Next_:

add esi,8
add edi,8

sub eax,4
cmp eax,4
jge @rgb555
mov j,eax
mov TempSS,esi
mov Tempdd,edi
//emms

pop ebx
pop eax
pop esi
pop edi


      end;
    end;


    while j > 0 do
    begin
      if TempSS^ <> AnsImage.TransparentColor then //不是透明色
      begin
               // WinVRGB(TempSS^, r, g, b);
        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;
        b2 := TempDD^ and $1F;
        g2 := (TempDD^ shr 5) and $1F;
        r2 := (TempDD^ shr 10) and $1F;
        if (r = 0) and (b = 0) then
        begin
          n := g;
          r := r2 + n * ar * weight div 255 div 31 + defaultadd;
          g := g2 + n * ag * weight div 255 div 31 + defaultadd;
          b := b2 + n * ab * weight div 255 div 31 + defaultadd;
          if r > 31 then r := 31;
          if g > 31 then g := 31;
          if b > 31 then b := 31;

          TempDD^ := b + (g shl 5) + (r shl 10); // WinRGB(r, g, b);
          //if TempDD^ = 0 then TempDD^ := 1;
        end
        else TempDD^ := TempSS^; //直接替换
      end;
      inc(TempSS);
      Inc(TempDD);
      dec(j);
    end;

    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
  asm
        emms
  end;
end;

procedure TA2Image.CopyImage(AnsImage: TA2Image);
begin
  if (AnsImage.Width <> Width) or (AnsImage.Height <> Height) then
  begin
    AnsImage.Resize(Width, Height);
  end;
  AnsImage.px := px;
  AnsImage.py := py;
  AnsImage.TransparentColor := TransparentColor;
  AnsImage.Name := Name;
  AnsImage.FClientRect := FClientRect;
  move(Bits^, AnsImage.Bits^, (Width * Height) * sizeof(TAns2Color));
end;

procedure TA2Image.DrawImageDither(AnsImage: TA2Image; x, y, adither: integer; aTrans: Boolean);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j, n: integer;
  ir, sr, dr: TRect;
begin
  if AnsImage = nil then exit;
  case adither of
    0:
      begin
        DrawImage(AnsImage, x, y, aTrans);
        exit;
      end;
    1: adither := 2;
    2: adither := 4;
    3: adither := 8;
  else exit;
  end;

    //do clipping

  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  if adither = 4 then
  begin
    inc(spb);
    inc(dpb);
  end;

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;

    if (i mod adither) = 0 then
    begin

      if (i mod (adither * 2)) = 0 then
      begin
        inc(TempSS, adither div 2);
        inc(TempDD, adither div 2);
      end;

      n := (ir.right - ir.left) div adither;
      for j := 0 to n - 1 do
      begin
        TempDD^ := TempSS^;
        inc(TempSS, adither);
        Inc(TempDD, adither);
      end;
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
end;

procedure TA2Image.Setsize(aWidth, aheight: Integer);
begin
  if (aWidth <= 0) or (aheight <= 0) then exit;
  if (Width = aWidth) and (aHeight = Height) then
  begin
    if Bits = nil then
    begin
      GetMem(Bits, Width * Height * Sizeof(TAns2Color));

    end;
    FillChar(Bits^, Width * Height * Sizeof(TAns2Color), 0);
    exit;
  end;
  px := 0;
  py := 0;
  {if WidthBytes(AWidth) <> AWidth then
  begin
    Width := WidthBytes(AWidth);
  end else
  begin

  end;
  }
  Width := WidthBytes(AWidth);
  Height := aHeight;
  if Bits <> nil then FreeMem(Bits); //释放 原来的
  Bits := nil;
  GetMem(Bits, Width * Height * Sizeof(TAns2Color));
  if bits = nil then raise Exception.Create('TA2Image.Setsize bits = nil');
  FillChar(Bits^, Width * Height * Sizeof(TAns2Color), 0);
  FClientRect := Rect(0, 0, Width - 1, Height - 1);
end;

procedure TA2Image.Resize(aWidth, aheight: Integer);
var
  OldBits, spb, dpb: PTAns2Color;
  i, j, x, y, Oldwidth, Oldheight: integer;
begin
  OldWidth := Width;
  OldHeight := Height;
  OldBits := Bits;

  Width := aWidth;
  Height := aHeight;
  GetMem(Bits, Width * Height * Sizeof(TAns2Color));
  FillChar(Bits^, Width * Height * Sizeof(TAns2Color), 0);

  for j := 0 to Height - 1 do
  begin
    for i := 0 to Width - 1 do
    begin
      x := trunc(i * (OldWidth / Width));

      y := trunc(j * (OldHeight / Height));

      spb := OldBits;
      inc(spb, x + y * OldWidth);
      dpb := Bits;
      inc(dpb, i + j * Width);
      dpb^ := spb^;
    end;
  end;

  px := px * Width div OldWidth;
  py := py * Height div OldHeight;
  FreeMem(OldBits);
  FClientRect := Rect(0, 0, Width - 1, Height - 1);
end;
//替换 色方式
{
procedure TA2Image.DrawImageKeyColor(AnsImage: TA2Image; x, y: Integer; col: word; ptable: pword);
var
    spb, dpb, TempSS, TempDD: PTAns2Color;
    i, j: integer;
    ir, sr, dr: TRect;
    ptemp: pword;
    //   tempi, starti, endi : integer;
begin
    if AnsImage = nil then exit;

    //do clipping
    sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
    dr := Rect(0, 0, Width - 1, Height - 1);

    if not IntersectRect(ir, sr, dr) then exit;

    spb := AnsImage.Bits;
    inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

    dpb := Bits;
    inc(dpb, (ir.left + ir.top * Width));

    for i := ir.Top to ir.Bottom do
    begin
        TempSS := spb;
        TempDD := dpb;
        for j := ir.left to ir.right do
        begin
            if TempSS^ <> AnsImage.TransparentColor then
            begin
                if TempSS^ = col then
                begin
                    ptemp := ptable;
                    inc(ptemp, TempDD^);
                    TempDD^ := ptemp^;
                    //               TempDD^ := Darkentbl[Tempdd^];
                end else
                begin
                    TempDD^ := TempSS^;
                end;
            end;
            inc(TempSS);
            Inc(TempDD);
        end;
        inc(spb, AnsImage.Width);
        inc(dpb, Width);
    end;

end;
}

procedure TA2Image.DrawImageKeyColor(AnsImage: TA2Image; x, y: Integer; col: word; ptable: pword);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  tArr: array[0..3] of word;
  tp, tpcol: pointer;
  ptemp: pword;
const
  //  MASKRED: int64 = $7C007C007C007C00;                                         // 三种颜色的掩码的64位扩展
   // MASKGREEN: int64 = $03E003E003E003E0;
  C_R15: int64 = $7C007C007C007C00;
  C_G15: int64 = $03E003E003E003E0;
  C_B15: int64 = $001F001F001F001F;
begin
  if AnsImage = nil then exit;

  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

        {tarr[0] := AnsImage.TransparentColor;
        tarr[1] := AnsImage.TransparentColor;
        tarr[2] := AnsImage.TransparentColor;
        tarr[3] := AnsImage.TransparentColor;
        tp := @tarr; }
  tarr[0] := col;
  tarr[1] := col;
  tarr[2] := col;
  tarr[3] := col;
  tpcol := @tarr;
  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    j := ir.right - ir.left;
    if j >= 0 then inc(j);
    if j >= 4 then
    begin
      asm
push edi
push esi
push eax
push ebx

mov eax,tpcol
movq mm7,[eax] //替换颜色

mov eax,j
mov esi,TempSS
mov edi,TempDD
@rgb555:



movq    mm0, [esi]                         //原
movq    mm1, [edi]                         //目标
 pxor mm6,mm6
 pcmpeqw mm6,mm0
 pmovmskb ebx,mm6
 cmp ebx,$ff

 jz @regNex  //透明跳过



//取得 原 保留
movq    mm5,mm7
pcmpeqw mm5,mm0  //替换部位
movq    mm6,mm5
pandn   mm6,mm0  //得到 原始 色
movq    mm4,mm1
pand    mm4,mm5   //得替换色
//对MM4颜色 降低 50%
movq mm3,mm4
movq mm2,mm4
//B
pand mm2,C_B15
pand mm3,C_G15
pand mm4,C_R15
psrlw mm2,1
psrlw mm3,1
psrlw mm4,1
pand mm3,C_G15
pand mm4,C_R15
//合并
por mm4,mm2
por mm4,mm3
//和原 合并
por mm4,mm6

//取得 目标保留
 pxor mm6,mm6
 pcmpeqw mm6,mm0   //保留部位
 pand mm1,mm6

//完整合并
por mm4,mm1


movq [edi],mm4

@regNex:
add esi,8
add edi,8

sub eax,4
cmp eax,4
jge @rgb555
mov j,eax
mov TempSS,esi
mov Tempdd,edi
emms
pop ebx
pop eax
pop esi
pop edi


      end;
    end;
    while j > 0 do
    begin
      if TempSS^ <> AnsImage.TransparentColor then
      begin
        if TempSS^ = col then
        begin
          ptemp := ptable;
          inc(ptemp, TempDD^);
          TempDD^ := ptemp^;
                    //               TempDD^ := Darkentbl[Tempdd^];
        end else
        begin
          TempDD^ := TempSS^;
        end;
      end;
      inc(TempSS);
      Inc(TempDD);
      dec(j);
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;


end;

procedure TA2Image.DrawImageKeyColor2(AnsImage: TA2Image; x, y: Integer; col: word; ptable: pword);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  tArr: array[0..3] of word;
  tp, tpcol: pointer;
  ptemp: pword;
const
  //  MASKRED: int64 = $7C007C007C007C00;                                         // 三种颜色的掩码的64位扩展
   // MASKGREEN: int64 = $03E003E003E003E0;
  C_R15: int64 = $7C007C007C007C00;
  C_G15: int64 = $03E003E003E003E0;
  C_B15: int64 = $001F001F001F001F;
  C_X15: int64 = $0003000300030003;
begin
  if AnsImage = nil then exit;

  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

        {tarr[0] := AnsImage.TransparentColor;
        tarr[1] := AnsImage.TransparentColor;
        tarr[2] := AnsImage.TransparentColor;
        tarr[3] := AnsImage.TransparentColor;
        tp := @tarr; }
  tarr[0] := col;
  tarr[1] := col;
  tarr[2] := col;
  tarr[3] := col;
  tpcol := @tarr;
  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    j := ir.right - ir.left;
    if j >= 0 then inc(j);
    if j >= 4 then
    begin
      asm
push edi
push esi
push eax
push ebx

mov eax,tpcol
movq mm7,[eax] //替换颜色

mov eax,j
mov esi,TempSS
mov edi,TempDD
@rgb555:



movq    mm0, [esi]                         //原
movq    mm1, [edi]                         //目标
 pxor mm6,mm6
 pcmpeqw mm6,mm0
 pmovmskb ebx,mm6
 cmp ebx,$ff

 jz @regNex  //透明跳过



//取得 原 保留
movq    mm5,mm7
pcmpeqw mm5,mm0  //替换部位
movq    mm6,mm5
pandn   mm6,mm0  //得到 原始 色
movq    mm4,mm1
pand    mm4,mm5   //得替换色
//对MM4颜色 降低 50%
movq mm3,mm4
movq mm2,mm4
//B
pand mm2,C_B15
pand mm3,C_G15
pand mm4,C_R15
psrlw mm4,2
pmullw mm2,C_X15
pmullw mm3,C_X15
pmullw mm4,C_X15
psrlw mm2,2
psrlw mm3,2
pand mm3,C_G15
pand mm4,C_R15
//合并
por mm4,mm2
por mm4,mm3
//和原 合并
por mm4,mm6

//取得 目标保留
 pxor mm6,mm6
 pcmpeqw mm6,mm0   //保留部位
 pand mm1,mm6

//完整合并
por mm4,mm1


movq [edi],mm4

@regNex:
add esi,8
add edi,8

sub eax,4
cmp eax,4
jge @rgb555
mov j,eax
mov TempSS,esi
mov Tempdd,edi
emms
pop ebx
pop eax
pop esi
pop edi


      end;
    end;
    while j > 0 do
    begin
      if TempSS^ <> AnsImage.TransparentColor then
      begin
        if TempSS^ = col then
        begin
          ptemp := ptable;
          inc(ptemp, TempDD^);
          TempDD^ := ptemp^;
                    //               TempDD^ := Darkentbl[Tempdd^];
        end else
        begin
          TempDD^ := TempSS^;
        end;
      end;
      inc(TempSS);
      Inc(TempDD);
      dec(j);
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;


end;
//涂 方式（R G B 3色分别用 对比 计算；计算规则没分析）

procedure TA2Image.DrawImageOveray_2(AnsImage: TA2Image; x, y: Integer; weight: integer);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  r, g, b, r1, g1, b1: word;
begin
  if AnsImage = nil then
  begin
        //      Error := 3;
    exit;
  end;

    //do clipping
  if weight > 100 then weight := 100;
  if weight < 0 then weight := 0;
  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;
    //带入 图缓冲
  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width)); //计算出 缓冲区 位置
    //自己 图缓冲
  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width)); //计算出 缓冲区 位置

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    for j := ir.left to ir.right do
    begin

      if (TempSS^ <> AnsImage.TransparentColor) then // and (TempSs^ <> 31) then
      begin //NOT透明 颜色
                //WinVRGB(TempDD^, r1, g1, b1);

               // WinVRGB(TempSS^, r, g, b);
        b1 := TempDD^ and $1F;
        g1 := (TempDD^ shr 5) and $1F;
        r1 := (TempDD^ shr 10) and $1F;
        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;

        if r > r1 then
        begin
          r := r * (100 - weight);
          r1 := r1 * weight;
          r1 := (r1 + r) div 100;
        end else
        begin
        end;

        if g > g1 then
        begin
          g := g * (100 - weight);
          g1 := g1 * weight;
          g1 := (g1 + g) div 100;
        end else
        begin
        end;

        if b > b1 then
        begin
          b := b * (100 - weight);
          b1 := b1 * weight;
          b1 := (b1 + b) div 100;
        end else
        begin
        end;

        TempDD^ := b1 + (g1 shl 5) + (r1 shl 10); // WinRGB(r1, g1, b1);
                //            TempDD^ := TempSS^;
      end;
      inc(TempSS);
      Inc(TempDD);
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
end;

procedure TA2Image.DrawImageOveray(AnsImage: TA2Image; x, y: Integer; weight: integer);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  r, g, b, r1, g1, b1: word;
  weightArr: array[0..3] of word;
  weightArr_f: array[0..3] of word;
  tpd, tps: int64;

const
  C_R15: int64 = $7C007C007C007C00;
  C_G15: int64 = $03E003E003E003E0;
  C_B15: int64 = $001F001F001F001F;
begin
  if AnsImage = nil then exit;
    //do clipping
  if weight > 100 then weight := 100;
  if weight < 0 then weight := 0;
  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;
    //带入 图缓冲
  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width)); //计算出 缓冲区 位置
    //自己 图缓冲
  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width)); //计算出 缓冲区 位置
          //	B<=0.5: C=2*A*B
        //B>0.5: C=1-2*(1-A)*(1-B)

  i := trunc((weight / 100) * 32);
  tpd := i;
  tpd := tpd or tpd shl 16 or tpd shl 32 or tpd shl 48;
  tps := 32 - i;
  tps := tps or tps shl 16 or tps shl 32 or tps shl 48;
  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;

    j := ir.right - ir.left;
    if j >= 0 then inc(j);
    if j >= 4 then
    begin
      asm
push edi
push esi
push eax
push ebx

mov eax,j
mov esi,TempSS
mov edi,TempDD
@rgb555:

movq    mm3, [esi]                         //原
movq    mm0, [edi]                         //目标

 pxor mm7,mm7
 pcmpeqw mm7,mm3
 pmovmskb ebx,mm7
 cmp ebx,$ff
 jz @regNex

movq mm4,mm3
movq mm1,mm0

//B  5转8    BYTE1
pand mm4,C_B15
pand mm1,C_B15

//大的FF
movq mm5,mm4
pcmpgtb mm5,mm1
pand mm4,mm5    //保留大的
movq mm2,mm1
pand mm2,mm5    //
pandn mm5,mm1   //保留透明部分

pmullw mm4,tps    //*透明度
pmullw mm2,tpd    //*透明度
paddusw mm4,mm2
psrlw mm4,5          //除 32
//pand mm4,C_B15

por mm5,mm4


/////////////////////////////////////////
movq mm4,mm3
movq mm1,mm0

//G  5转8    BYTE1
pand mm4,C_G15
pand mm1,C_G15
psrlw mm4,5
psrlw mm1,5

//大的FF
movq mm6,mm4
pcmpgtb mm6,mm1
pand mm4,mm6    //保留大的
movq mm2,mm1
pand mm2,mm6    //
pandn mm6,mm1   //保留透明部分

pmullw mm4,tps    //*透明度
pmullw mm2,tpd    //*透明度
paddusw mm4,mm2
psrlw mm4,5          //除 32
//pand mm4,C_B15

por mm6,mm4

psllw mm6,5

por mm5,mm6
/////////////////////////////////////////
/////////////////////////////////////////
//r  5转8    BYTE1
pand mm3,C_r15
pand mm0,C_r15
psrlw mm3,10
psrlw mm0,10

//大的FF
movq mm6,mm3
pcmpgtb mm6,mm0
pand mm3,mm6    //保留大的
movq mm2,mm0
pand mm2,mm6    //
pandn mm6,mm0   //保留透明部分

pmullw mm3,tps    //*透明度
pmullw mm2,tpd    //*透明度
paddusw mm3,mm2
psrlw mm3,5          //除 32
//pand mm3,C_B15

por mm6,mm3

psllw mm6,10

por mm5,mm6
/////////////////////////////////////////


movq [edi],mm5

@regNex:

add esi,8
add edi,8

sub eax,4
cmp eax,4
jge @rgb555
mov j,eax
mov TempSS,esi
mov Tempdd,edi
emms

pop ebx
pop eax
pop esi
pop edi


      end;
    end;

    while j > 0 do
    begin
      if (TempSS^ <> AnsImage.TransparentColor) then // and (TempSs^ <> 31) then
      begin //NOT透明 颜色
        b1 := TempDD^ and $1F;
        g1 := (TempDD^ shr 5) and $1F;
        r1 := (TempDD^ shr 10) and $1F;
        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;

        if r > r1 then
        begin
          r := r * (100 - weight);
          r1 := r1 * weight;
          r1 := (r1 + r) div 100;
        end else
        begin
        end;

        if g > g1 then
        begin
          g := g * (100 - weight);
          g1 := g1 * weight;
          g1 := (g1 + g) div 100;
        end else
        begin
        end;

        if b > b1 then
        begin
          b := b * (100 - weight);
          b1 := b1 * weight;
          b1 := (b1 + b) div 100;
        end else
        begin
        end;

        TempDD^ := b1 + (g1 shl 5) + (r1 shl 10); // WinRGB(r1, g1, b1);

      end;
      inc(TempSS);
      Inc(TempDD);
      dec(j);
    end;
        {
        for j := ir.left to ir.right do
        begin

            if (TempSS^ <> AnsImage.TransparentColor) then                      // and (TempSs^ <> 31) then
            begin                                                               //NOT透明 颜色
                b1 := TempDD^ and $1F;
                g1 := (TempDD^ shr 5) and $1F;
                r1 := (TempDD^ shr 10) and $1F;
                b := TempSS^ and $1F;
                g := (TempSS^ shr 5) and $1F;
                r := (TempSS^ shr 10) and $1F;

                if r > r1 then
                begin
                    r := r * (100 - weight);
                    r1 := r1 * weight;
                    r1 := (r1 + r) div 100;
                end else
                begin
                end;

                if g > g1 then
                begin
                    g := g * (100 - weight);
                    g1 := g1 * weight;
                    g1 := (g1 + g) div 100;
                end else
                begin
                end;

                if b > b1 then
                begin
                    b := b * (100 - weight);
                    b1 := b1 * weight;
                    b1 := (b1 + b) div 100;
                end else
                begin
                end;

                TempDD^ := b1 + (g1 shl 5) + (r1 shl 10);                       // WinRGB(r1, g1, b1);

            end;
            inc(TempSS);
            Inc(TempDD);
        end;
        }
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
end;
//折射率

procedure TA2Image.DrawRefractive(AnsImage: TA2Image; x, y, Refracrange, overValue: Integer);
var
  spb, dpb, TempSS, TempDD, TempDD_1: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
begin
  if AnsImage = nil then exit;

    //do clipping
  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    TempDD_1 := dpb;
    inc(TempDD_1, Refracrange);
    for j := ir.left to ir.right do
    begin
      if (TempSS^ <> AnsImage.TransparentColor) and (TempSS^ <> 31) then
      begin
        TempDD^ := TempDD_1^ + overValue;
      end;
      inc(TempSS);
      Inc(TempDD);
      Inc(TempDD_1);
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
end;

{
Soft Light 柔光

 A<=0.5: C=(2*A-1)*(B-B*B)+B
 A>0.5: C=(2*A-1)*(sqrt(B)-B)+B

 该模式类似上层以Gamma值范围为2.0到0.5的方式来调制下层的色彩值。
 结果将是一个非常柔和的组合。
  }

procedure TA2Image.DrawImage_(aDrawType: TDrawType; at1, at2, at3: single; col: word; ptable: pword; AnsImage: TA2Image; x, y: Integer);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  rA, gA, bA, rB, gB, bB, rC, gC, bC: single;

  rAd, gAd, bAd, rBd, gBd, bBd, rCd, gCd, bCd: word;
  t1d, t2d: word;
  ptemp: pword;
begin
  if AnsImage = nil then exit;
    //X，Y自己某位置
    //do clipping

    //原矩形
  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
    //目标矩形
  dr := Rect(0, 0, Width - 1, Height - 1);
    //计算相交 矩形
  if not IntersectRect(ir, sr, dr) then exit;

    //绘制点，起点
  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));


  case aDrawType of
    _dt_Add:
      begin
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGB(TempDD^, rBd, gBd, bBd); WinVRGB(TempSS^, rAd, gAd, bAd);
                rcd := rad + rbd;
                gcd := gad + gbd;
                bcd := bad + bbd;
                if rcd > 31 then rcd := 31;
                if gcd > 31 then gcd := 31;
                if bcd > 31 then bcd := 31;
                TempDD^ := WinRGB(rCd, gCd, bCd);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;

    _dt_none:
      begin
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                TempDD^ := TempSS^;
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_PinLight:
      begin
            //B<2*A-1: C=2*A-1
            //2*A-1<B<2*A: C=B
            //B>2*A: C=2*A
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                if rB < 2 * rA - 1 then rC := 2 * rA - 1;
                if (2 * rA - 1 < rB) and (rb < 2 * rA) then rC := rB;
                if rB > 2 * rA then rC := 2 * rA;

                if gB < 2 * gA - 1 then gC := 2 * gA - 1;
                if (2 * gA - 1 < gB) and (gb < 2 * gA) then gC := gB;
                if gB > 2 * gA then gC := 2 * gA;

                if bB < 2 * bA - 1 then bC := 2 * bA - 1;
                if (2 * bA - 1 < bB) and (bb < 2 * bA) then bC := bB;
                if bB > 2 * bA then bC := 2 * bA;
                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_Screen:
      begin
              //C=1-(1-A)*(1-B)也可以写成 1-C=(1-A)*(1-B)
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                rc := 1 - (1 - rA) * (1 - rB);
                gc := 1 - (1 - gA) * (1 - gB);
                bc := 1 - (1 - bA) * (1 - bB);
                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_LinearDodge:
      begin
            //C=A+B
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGB(TempDD^, rBd, gBd, bBd); WinVRGB(TempSS^, rAd, gAd, bAd);
                rcd := rad + rbd;
                gcd := gad + gbd;
                bcd := bad + bbd;
                if rcd > 31 then rcd := 31;
                if gcd > 31 then gcd := 31;
                if bcd > 31 then bcd := 31;
                TempDD^ := WinRGB(rCd, gCd, bCd);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_HardMix:
      begin
            //A<1-B: C=0
            //A>1-B: C=1

        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                if rA < 1 - rB then rC := 0 else rC := 1;
                if gA < 1 - gB then gC := 0 else gC := 1;
                if bA < 1 - bB then bC := 0 else bC := 1;
                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_Overlay:
      begin
        //	B<=0.5: C=2*A*B
        //B>0.5: C=1-2*(1-A)*(1-B)
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                if rB <= 0.5 then rC := 2 * rA * rB else rC := 1 - 2 * (1 - rA) * (1 - rB);
                if gB <= 0.5 then gC := 2 * gA * gB else gC := 1 - 2 * (1 - gA) * (1 - gB);
                if bB <= 0.5 then bC := 2 * bA * bB else bC := 1 - 2 * (1 - bA) * (1 - bB);
                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_LinearBurn:
      begin
            //	C=A+B-1
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGB(TempDD^, rBd, gBd, bBd); WinVRGB(TempSS^, rAd, gAd, bAd);
                rcd := rad + rbd;
                gcd := gad + gbd;
                bcd := bad + bbd;
                if rcd > 31 then rcd := rcd - 31 else rcd := 0;
                if gcd > 31 then gcd := gcd - 31 else gcd := 0;
                if bcd > 31 then bcd := bcd - 31 else bcd := 0;

                if rcd > 31 then rcd := 31;
                if gcd > 31 then gcd := 31;
                if bcd > 31 then bcd := 31;

                TempDD^ := WinRGB(rCd, gCd, bCd);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_ColorDodge:
      begin
            //C=B/(1-A)
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                if (rB > 0) and (rA < 1) then rc := rB / (1 - rA) else rc := 0;
                if (gB > 0) and (gA < 1) then gc := gB / (1 - gA) else gc := 0;
                if (bB > 0) and (bA < 1) then bc := bB / (1 - bA) else bc := 0;


                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_Opacity:
      begin
              //C=d*A+(1-d)*B
        if at1 < 0 then at1 := 0.01;
        if at1 > 1 then at1 := 0.99;
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                rc := at1 * ra + (1 - at1) * rb;
                gc := at1 * ga + (1 - at1) * gb;
                bc := at1 * ba + (1 - at1) * bb;
                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_HardLight:
      begin
//	A<=0.5: C=2*A*B
//	A>0.5: C=1-2*(1-A)*(1-B)
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                if rA <= 0.5 then rC := 2 * rA * rB else rC := 1 - 2 * (1 - rA) * (1 - rB);
                if gA <= 0.5 then gC := 2 * gA * gB else gC := 1 - 2 * (1 - gA) * (1 - gB);
                if bA <= 0.5 then bC := 2 * bA * bB else bC := 1 - 2 * (1 - bA) * (1 - bB);

                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_SoftLight:
      begin
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                                //A<=0.5: C=(2*A-1)*(B-B*B)+B
                                //A>0.5: C=(2*A-1)*(sqrt(B)-B)+B

                if ra <= 0.5 then rc := (2 * rA - 1) * (rB - rB * rB) + rB
                else rc := (2 * rA - 1) * (sqrt(rB) - rB) + rB;
                if ga <= 0.5 then gc := (2 * gA - 1) * (gB - gB * gB) + gB
                else gc := (2 * gA - 1) * (sqrt(gB) - gB) + gB;
                if ba <= 0.5 then bc := (2 * bA - 1) * (bB - bB * bB) + bB
                else bc := (2 * bA - 1) * (sqrt(bB) - bB) + bB;
                TempDD^ := WinRGBs(rC, gC, bC);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;

    _dt_Multiply:
      begin
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGB(TempDD^, rBd, gBd, bBd); WinVRGB(TempSS^, rAd, gAd, bAd);
                rcd := (rad * rbd) div 31;
                gcd := (gad * gbd) div 31;
                bcd := (bad * bbd) div 31;
                TempDD^ := WinRGB(rCd, gCd, bCd);
{                                WinVRGBs(TempDD^, rB, gB, bB); WinVRGBs(TempSS^, rA, gA, bA);
                                rc := ra * rb;
                                gc := ga * gb;
                                bc := ba * bb;
                                TempDD^ := WinRGBs(rC, gC, bC);}
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_Lighten:
      begin
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGB(TempDD^, rBd, gBd, bBd); WinVRGB(TempSS^, rAd, gAd, bAd);
                if rBd <= rAd then rCd := rAd else rCd := rBd;
                if gBd <= gAd then gCd := gAd else gCd := gBd;
                if bBd <= bAd then bCd := bAd else bCd := bBd;
                TempDD^ := WinRGB(rCd, gCd, bCd);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;
    _dt_Darken:
      begin
        for i := ir.Top to ir.Bottom do
        begin
          TempSS := spb; TempDD := dpb;
          for j := ir.left to ir.right do
          begin
            if (TempSS^ <> AnsImage.TransparentColor) then
            begin
              if (col <> 0) and (TempSS^ = col) then
              begin
                if ptable <> nil then
                begin
                  ptemp := ptable;
                  inc(ptemp, TempDD^);
                  TempDD^ := ptemp^;
                end;
              end else
              begin
                WinVRGB(TempDD^, rBd, gBd, bBd); WinVRGB(TempSS^, rAd, gAd, bAd);
                if rBd <= rAd then rCd := rbd else rCd := rad;
                if gBd <= gAd then gCd := gbd else gCd := gad;
                if bBd <= bAd then bCd := bbd else bCd := bad;
                TempDD^ := WinRGB(rCd, gCd, bCd);
              end;
            end;
            inc(TempSS); Inc(TempDD);
          end;
          inc(spb, AnsImage.Width); inc(dpb, Width);
        end;
      end;

  end;

end;

procedure TA2Image.stroke(acol: word);
var
  TempSS, p: PTAns2Color;
  i, j, ax, ay: integer;
  r, g, b, r1, g1, b1: word;
  TempBits: PTAns2Color;
  procedure _setColor(x, y: integer; col: word);
  begin
    if (x < 0) or (x >= Width) then exit;
    if (y < 0) or (y >= Height) then exit;
    p := Bits;
    inc(p, y * Width + x);
    if (p^ = TransparentColor) then
    begin
      p^ := col;
    end;
  end;

begin
//    GetMem(TempBits, Width * Height * sizeof(TAns2Color));
  try
      //  move(Bits^, TempBits^, Width * Height * sizeof(TAns2Color));


    TempSS := Bits;
    for i := 0 to Height - 1 do
    begin
      for j := 0 to Width - 1 do
      begin
        if (TempSS^ <> TransparentColor) and (TempSS^ <> acol) then
        begin
               // WinVRGB(TempSS^, r, g, b);
          _setColor(j, i - 1, acol);
          _setColor(j, i + 1, acol);
          _setColor(j - 1, i, acol);
          _setColor(j + 1, i, acol);

                  {  _setColor(j - 1, i + 1, acol);
                    _setColor(j + 1, i + 1, acol);
                    _setColor(j + 1, i - 1, acol);
                    _setColor(j - 1, i - 1, acol);}

               // TempSS^ := WinRGB(r1, g1, b1);
        end;
        inc(TempSS);
      end;

    end;
  finally
      //  FreeMem(TempBits, Width * Height * sizeof(TAns2Color));
  end;
end;

procedure TA2Image.stroke_inner(acol, mcol: word);
var
  TempSS, p: PTAns2Color;
  i, j, ax, ay: integer;
  r, g, b, r1, g1, b1: word;
  TempBits: PTAns2Color;
  procedure _setColor(x, y: integer; col: word);
  begin
    if (x < 0) or (x >= Width) then exit;
    if (y < 0) or (y >= Height) then exit;
    p := Bits;
    inc(p, y * Width + x);
    if (p^ = mcol) then
    begin
      p^ := col;
    end;
  end;

begin
//    GetMem(TempBits, Width * Height * sizeof(TAns2Color));
  try
      //  move(Bits^, TempBits^, Width * Height * sizeof(TAns2Color));


    TempSS := Bits;
    for i := 0 to Height - 1 do
    begin
      for j := 0 to Width - 1 do
      begin
        if (TempSS^ <> mcol) and (TempSS^ <> acol) then
        begin
               // WinVRGB(TempSS^, r, g, b);
          _setColor(j, i - 1, acol);
          _setColor(j, i + 1, acol);
          _setColor(j - 1, i, acol);
          _setColor(j + 1, i, acol);

                  {  _setColor(j - 1, i + 1, acol);
                    _setColor(j + 1, i + 1, acol);
                    _setColor(j + 1, i - 1, acol);
                    _setColor(j - 1, i - 1, acol);}

               // TempSS^ := WinRGB(r1, g1, b1);
        end;
        inc(TempSS);
      end;

    end;
  finally
      //  FreeMem(TempBits, Width * Height * sizeof(TAns2Color));
  end;
end;

procedure TA2Image.strokeCler(acol: word);
var
  TempSS: PTAns2Color;
  i, j: integer;
begin
  TempSS := Bits;
  for i := 0 to Height - 1 do
  begin
    for j := 0 to Width - 1 do
    begin
      if (TempSS^ <> TransparentColor) then // and (TempSS^ <> 31) then
      begin
        TempSS^ := acol;
      end;
      inc(TempSS);
    end;

  end;
end;

procedure TA2Image.addColor(ar, ag, ab: word);
var
  TempSS: PTAns2Color;
  i, j: integer;
  r, g, b: word;
begin
  TempSS := Bits;
  for i := 0 to Height - 1 do
  begin
    for j := 0 to Width - 1 do
    begin
      if (TempSS^ <> TransparentColor) and (TempSs^ <> 31) then
      begin
        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;
        b := b + ab;
        g := g + ag;
        r := r + ar;
        if b > 31 then b := 31;
        if g > 31 then g := 31;
        if r > 31 then r := 31;
        TempSS^ := b + (g shl 5) + (r shl 10);
      end;
      inc(TempSS);
    end;

  end;
end;

procedure TA2Image.delColor(acol: word);
var
  TempSS: PTAns2Color;
  i, j: integer;
begin
  TempSS := Bits;
  for i := 0 to Height - 1 do
  begin
    for j := 0 to Width - 1 do
    begin
      if (TempSS^ = acol) then
      begin
        TempSS^ := TransparentColor;
      end;
      inc(TempSS);
    end;

  end;
end;

procedure TA2Image.DrawImage(AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  swidth, dwidth, aTColor, i, j: integer;
  ir, sr, dr: TRect;
const
  c_tt: int64 = $03E003E003E003E0;
begin
  if AnsImage = nil then exit;

  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  if aTrans = FALSE then
  begin
    for i := ir.Top to ir.Bottom do
    begin
      move(spb^, dpb^, (ir.right - ir.left + 1) * sizeof(TAns2Color));
      inc(spb, AnsImage.Width);
      inc(dpb, Width);
    end;
    exit;
  end;
  swidth := AnsImage.Width * 2;
  dwidth := Width * 2;
  aTColor := AnsImage.TransparentColor;
  i := ir.Bottom - ir.Top + 1;
  j := ir.right - ir.left + 1;
  if (i > 0) and (j > 0) then
  begin
    asm
push edi
push esi
push eax
push ebx
/////////////TransparentColor/////////////
movd mm7,aTColor
punpcklwd mm7,mm7
punpcklwd mm7,mm7
/////////////for_Height_/////////////////////
@Height_:

mov eax,j
mov esi,spb
mov edi,dpb

/////////////for_Width_/////////////////////
@Width_:
  cmp eax,4
  jge @load_4
  cmp eax,3
  jge @load_3
  cmp eax,2
  jge @load_2
  cmp eax,1
  jge @load_1
  //0
  jmp @Width_end

  @load_3:
    movd mm0,[esi]                         //原
    movd mm1,[edi]                         //目标
   // pand mm0,c_load3_2
   // pand mm1,c_load3_2

    mov bx,[esi+4]                         //原
    movd mm2,ebx
    mov bx,[edi+4]
    movd mm3,ebx                         //目标
  //  pand mm2,c_load3_1
  //  pand mm3,c_load3_1
    psllq mm2,32
    psllq mm3,32


    por mm0,mm2
    por mm1,mm3
  jmp @load_end
  @load_2:
    movd mm0,[esi]                         //原
    movd mm1,[edi]                         //目标
  jmp @load_end
  @load_1:
    mov bx,[esi]                         //原
    movd mm0,ebx
    mov bx,[edi]
    movd mm1,ebx                         //目标
  jmp @load_end
  @load_4:
    movq mm0,[esi]                         //原
    movq mm1,[edi]                         //目标
  @load_end:

  movq mm6,mm7
  pcmpeqw mm6,mm0    //透明位置
  pmovmskb ebx,mm6
  cmp ebx,$ff        //全透明结束
  jz @Next_
  //  movq    mm5,mm7
  //  pcmpeqw mm5,mm0
    movq    mm4,mm6    //拷贝一份 透明位置
    pand    mm4,mm1    //保留目标
    pandn   mm6,mm0    //保留原始  反向 透明位置
    por     mm4,mm6    //合并

    cmp eax,4
    jge @save4_
      cmp eax,3
      jge @save3_
      cmp eax,2
      jge @save2_
      cmp eax,1
      jge @save1_
      //0
      jmp @Width_end
    @save4_:
   // movq mm4,c_tt
    movq [edi],mm4
  @Next_:
  add esi,8
  add edi,8

  sub eax,4
  jnz @Width_
  jmp @Width_end

@save2_: //绿
    movd ebx,mm4
   // mov ebx,$3E003E0
    mov [edi],ebx
    jmp @Width_end
@save3_: //蓝
          //mov ebx,$1F001F
    movd ebx,mm4
    mov [edi],ebx
    psrlq mm4,32
    movd ebx,mm4

    mov [edi+4],bx


    jmp @Width_end
@save1_:   //红
    movd ebx,mm4
  //  mov ebx,$7C00
    mov [edi],bx

@Width_end:
/////////////for_Width_/////////////////////

mov esi,spb
mov edi,dpb
add esi,swidth
add edi,dwidth
mov spb,esi
mov dpb,edi
dec i
jnz @Height_
/////////////for_Height_/////////////////////

emms
pop ebx
pop eax
pop esi
pop edi
    end;
  end;
end;

procedure TA2Image.DrawImage_2(AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);

var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  TransparentColor64: int64;
begin
  if AnsImage = nil then exit;

  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  if aTrans = FALSE then
  begin

    for i := ir.Top to ir.Bottom do
    begin
      move(spb^, dpb^, (ir.right - ir.left + 1) * sizeof(TAns2Color));
      inc(spb, AnsImage.Width);
      inc(dpb, Width);
    end;
    exit;
  end;
  i := AnsImage.TransparentColor;
  asm
movd mm0,i
punpcklwd mm0,mm0
punpcklwd mm0,mm0
movq TransparentColor64,mm0
  end;

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    j := ir.right - ir.left;
    if j >= 0 then inc(j);
    if j >= 4 then
    begin
      asm
push edi
push esi
push eax
push ebx

//mov eax,tp
movq mm7,TransparentColor64 //透明颜色

mov eax,j
mov esi,TempSS
mov edi,TempDD
@rgb555:

movq    mm0, [esi]                         //原
movq    mm1, [edi]                         //目标
 movq mm6,mm7
 pcmpeqw mm6,mm0
 pmovmskb ebx,mm6
 cmp ebx,$ff
 jz @regNex
 
movq    mm5,mm7
pcmpeqw mm5, mm0
movq    mm4, mm5
pand    mm4, mm1
pandn   mm5, mm0
por     mm4, mm5
movq [edi],mm4

@regNex:
add esi,8
add edi,8

sub eax,4
cmp eax,4
jge @rgb555

mov j,eax
mov TempSS,esi
mov Tempdd,edi

pop ebx
pop eax
pop esi
pop edi
      end;
    end;
    while j > 0 do
    begin
      if (TempSS^ <> AnsImage.TransparentColor) then //and (TempSs^ <> 31) 后面增加的
      begin
        TempDD^ := TempSS^;
      end;
      inc(TempSS);
      Inc(TempDD);
      dec(j);
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;

  asm
emms
  end;
end;


procedure TA2Image.DrawImageAdd(AnsImage: TA2Image; x, y: Integer);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;

  i, j, n, n1: integer;
  ir, sr, dr: TRect;
  r, g, b, r1, g1, b1: word;
const
  //  MASKRED: int64 = $7C007C007C007C00;                                         // 三种颜色的掩码的64位扩展
   // MASKGREEN: int64 = $03E003E003E003E0;
  C_R15: int64 = $7C007C007C007C00;
  C_G15: int64 = $03E003E003E003E0;
  C_B15: int64 = $001F001F001F001F;

begin
  if AnsImage = nil then exit;

    //do clipping
  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));


  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;

       { j := ir.Left;
        while j <= ir.right do
        begin
            if (TempSS^ = AnsImage.TransparentColor) then
            begin
                inc(TempSS);
                Inc(TempDD);
                inc(j);
                Continue;
            end;
            if (j + 4) <= ir.right then
            begin
        }

    j := ir.right - ir.Left + 1;
    if j >= 4 then
    begin
      asm
//装载
push edi
push esi
push eax
push ebx

mov eax,j
mov esi,TempSS
mov edi,TempDD



@rgb555:
 movq mm0,[esi]

 pxor mm7,mm7
 pcmpeqw mm7,mm0
 pmovmskb ebx,mm7
 cmp ebx,$ff
 jz @regNex

 movq mm3,[edi]

//装载原始
	movq mm4,mm3
	movq mm5,mm3


//装载目标
//	movq mm0,mm7
	movq mm1,mm0
	movq mm2,mm0
//保留需要部分


//B  5转8
	pand mm0,C_B15
  psllw mm0,3
//G
	pand mm1,C_G15
  psrlw mm1,2
//R
	pand mm2,C_R15
	psrlw mm2,7

//移动到尾部

//B
	pand mm3,C_B15
  psllw mm3,3
//G
	pand mm4,C_G15
  psrlw mm4,2
//R
	pand mm5,C_R15
	psrlw mm5,7



//加法
	paddusb mm0,mm3
	paddusb mm1,mm4
	paddusb mm2,mm5

//还原   8转5
	psrlw mm0,3
	psllw mm1,2
	psllw mm2,7
//B
	pand mm0,C_B15
//G
	pand mm1,C_G15
//R
	pand mm2,C_R15
//保留需要部分



//合并
	por mm1,mm2
	por mm0,mm1
//存回
	movq [edi],mm0
@regNex:

add esi,8
add edi,8

sub eax,4
cmp eax,4
jge @rgb555
mov j,eax
mov TempSS,esi
mov TempDD,edi
emms

pop ebx
pop eax
pop esi
pop edi


///////////////////////////////////
      end;

              //  inc(TempSS, 4);
               // inc(TempDD, 4);

              //  inc(j, 4);
    end;
    while j > 0 do
    begin
      b1 := TempDD^ and $1F;
      g1 := (TempDD^ shr 5) and $1F;
      r1 := (TempDD^ shr 10) and $1F;

      b := TempSS^ and $1F;
      g := (TempSS^ shr 5) and $1F;
      r := (TempSS^ shr 10) and $1F;

      r1 := r1 + r;
      g1 := g1 + g;
      b1 := b1 + b;
      if r1 > 31 then r1 := 31;
      if g1 > 31 then g1 := 31;
      if b1 > 31 then b1 := 31;

      TempDD^ := b1 + (g1 shl 5) + (r1 shl 10);
      inc(TempSS);
      Inc(TempDD);
      dec(j);
    end;

    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;

end;

procedure TA2Image.DrawImageAdd_2(AnsImage: TA2Image; x, y: Integer);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  i, j: integer;
  ir, sr, dr: TRect;
  r, g, b, r1, g1, b1: word;
begin
  if AnsImage = nil then exit;

    //do clipping
  sr := Rect(x, y, x + AnsImage.Width - 1, y + AnsImage.Height - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

  if not IntersectRect(ir, sr, dr) then exit;

  spb := AnsImage.Bits;
  inc(spb, ((ir.left - x) + (ir.top - y) * AnsImage.Width));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  for i := ir.Top to ir.Bottom do
  begin
    TempSS := spb;
    TempDD := dpb;
    for j := ir.left to ir.right do
    begin
      if (TempSS^ <> AnsImage.TransparentColor) and (TempSS^ <> 31) then
      begin
                {WinVRGB(TempDD^, r1, g1, b1);
                WinVRGB(TempSS^, r, g, b);

                r1 := r1 + r;
                g1 := g1 + g;
                b1 := b1 + b;
                if r1 > 31 then r1 := 31;
                if g1 > 31 then g1 := 31;
                if b1 > 31 then b1 := 31;

                TempDD^ := WinRGB(r1, g1, b1);
                }
        b1 := TempDD^ and $1F;
        g1 := (TempDD^ shr 5) and $1F;
        r1 := (TempDD^ shr 10) and $1F;

        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;

        r1 := r1 + r;
        g1 := g1 + g;
        b1 := b1 + b;
        if r1 > 31 then r1 := 31;
        if g1 > 31 then g1 := 31;
        if b1 > 31 then b1 := 31;

        TempDD^ := b1 + (g1 shl 5) + (r1 shl 10);

                //TempDD^ := TempDD^ or TempSS^;
      end;
      inc(TempSS);
      Inc(TempDD);
    end;
    inc(spb, AnsImage.Width);
    inc(dpb, Width);
  end;
end;

{
procedure TA2Image.Optimize;
var
   x, y, minx, maxx, miny, maxy, w, h : Integer;
   i, j: Integer;
   pb, TempBits: PTAns2Color;
   pcs, pcd : PTAns2Color;
begin
   minx := width-1; maxx := 0; miny := height-1; maxy := 0;

   pb := Bits;
   for i := 0 to (width * height)-1 do begin
      if pb^ <> TransParentColor then begin
         x := i mod width;
         y := i div width;
         if minx > x then minx := x;
         if miny > y then miny := y;

         if maxx < x then maxx := x;
         if maxy < y then maxy := y;
      end;
      inc (pb);
   end;

   if (minx >= maxx) and ( miny >= maxy) then begin
      FreeMem ( Bits, Width * Height * sizeof(TAns2Color));
      Width := 4; Height := 4;
      GetMem (Bits, Width*Height*sizeof(TAns2Color));
      FillChar (Bits^, Width*Height*sizeof(TAns2Color), 0);
   end else begin
      w := WidthBytes (Maxx - Minx +1);
      h := Maxy - Miny +1;

      GetMem ( TempBits, w * h * sizeof(TAns2Color));
      pcs := Bits;
      inc (pcs, (minx+miny * Width) );
      pcd := TempBits;
      for j := 0 to h -1 do begin
         move ( pcs^, pcd^, w * sizeof(TAns2Color));
         inc (pcs, Width);
         inc (pcd, w);
      end;

      FreeMem (Bits, Width*Height*sizeof(TAns2Color));
      Width := w; Height := h;
      Bits := TempBits;
      px := px + Minx;
      py := py + Miny;
   end;
end;}
{
procedure TA2Image.Optimize;
var
    x, y, minx, maxx, miny, maxy, w, h: Integer;
    i, j: Integer;
    pb, TempBits: PTAns2Color;
    pcs, pcd: PTAns2Color;
begin
    minx := width - 1;
    maxx := 0;
    miny := height - 1;
    maxy := 0;

    pb := Bits;
    for i := 0 to (width * height) - 1 do
    begin
        if pb^ <> TransParentColor then
        begin
            x := i mod width;
            y := i div width;
            if minx > x then minx := x;
            if miny > y then miny := y;

            if maxx < x then maxx := x;
            if maxy < y then maxy := y;
        end;
        inc(pb);
    end;

    if (minx >= maxx) and (miny >= maxy) then
    begin
        FreeMem(Bits, Width * Height * sizeof(TAns2Color));
        Width := 4;
        Height := 4;
        GetMem(Bits, Width * Height * sizeof(TAns2Color));
        FillChar(Bits^, Width * Height * sizeof(TAns2Color), 0);
    end else
    begin
        w := WidthBytes(Maxx - Minx + 1);
        h := Maxy - Miny + 1;

        GetMem(TempBits, w * h * sizeof(TAns2Color));
        pcs := Bits;
        inc(pcs, (minx + miny * Width));
        pcd := TempBits;
        for j := 0 to h - 1 do
        begin
            move(pcs^, pcd^, w * sizeof(TAns2Color));
            inc(pcs, Width);
            inc(pcd, w);
        end;

        FreeMem(Bits, Width * Height * sizeof(TAns2Color));
        Width := w;
        Height := h;
        Bits := TempBits;
        px := px + Minx;
        py := py + Miny;
    end;
    FClientRect := Rect(0, 0, Width - 1, Height - 1);
end;
}

procedure TA2Image.Optimize;
var
  x, y, minx, maxx, miny, maxy, w, h: Integer;
  i, j: Integer;
  pb, TempBits: PTAns2Color;
  pcs, pcd: PTAns2Color;
begin
  minx := width - 1; maxx := 0; miny := height - 1; maxy := 0;

  pb := Bits;
  for i := 0 to (width * height) - 1 do begin
    if pb^ <> TransParentColor then begin
      x := i mod width;
      y := i div width;
      if minx > x then minx := x;
      if miny > y then miny := y;

      if maxx < x then maxx := x;
      if maxy < y then maxy := y;
    end;
    inc(pb);
  end;

  if (minx >= maxx) and (miny >= maxy) then begin
    FreeMem(Bits, Width * Height * sizeof(TAns2Color));
    Width := 4; Height := 4;
    GetMem(Bits, Width * Height * sizeof(TAns2Color));
    FillChar(Bits^, Width * Height * sizeof(TAns2Color), 0);
  end else begin
    w := WidthBytes(Maxx - Minx + 1);
    h := Maxy - Miny + 1;

    GetMem(TempBits, w * h * sizeof(TAns2Color));
    pcs := Bits;
    inc(pcs, (minx + miny * Width));
    pcd := TempBits;
    for j := 0 to h - 1 do begin
      move(pcs^, pcd^, w * sizeof(TAns2Color));
      inc(pcs, Width);
      inc(pcd, w);
    end;

    FreeMem(Bits, Width * Height * sizeof(TAns2Color));
    Width := w; Height := h;
    Bits := TempBits;
    px := px + Minx;
    py := py + Miny;
  end;
end;

procedure TA2Image.OptimizeWidth;
var
  x, minx, maxx, w: Integer;
  i, j: Integer;
  pb, TempBits: PTAns2Color;
  pcs, pcd: PTAns2Color;
begin
  minx := width - 1;
  maxx := 0;

  pb := Bits;
  for i := 0 to (width * height) - 1 do
  begin
    if pb^ <> 0 then
    begin
      x := i mod width;
      if minx > x then minx := x;
      if maxx < x then maxx := x;
    end;
    inc(pb);
  end;

  if minx > 1 then minx := minx - 1;
  if maxx < Width - 1 then maxx := maxx + 1;

  if (minx >= maxx) then
  begin
    FreeMem(Bits, Width * Height * sizeof(TAns2Color));
    Width := 4;
    Height := 4;
    GetMem(Bits, Width * Height * sizeof(TAns2Color));
    FillChar(Bits^, Width * Height * sizeof(TAns2Color), 0);
  end else
  begin
    w := Maxx - Minx + 1;

    GetMem(TempBits, w * Height * sizeof(TAns2Color));
    pcs := Bits;
    inc(pcs, (minx));
    pcd := TempBits;
    for j := 0 to Height - 1 do
    begin
      move(pcs^, pcd^, w * sizeof(TAns2Color));
      inc(pcs, Width);
      inc(pcd, w);
    end;

    FreeMem(Bits, Width * Height * sizeof(TAns2Color));
    Width := w;
    Bits := PTAns2Color(TempBits);
    px := px + Minx;
  end;
  FClientRect := Rect(0, 0, Width - 1, Height - 1);
end;

procedure TA2Image.LoadFromFile(FileName: string);
var
  Stream: TFileStream;
  Header: TBitmapFileHeader;
  BmpInfo: PBitMapInfo;
  HeaderSize: Integer;

begin
    //Initialise and open file
  HeaderSize := SizeOf(TBitmapInfoHeader);
  BmpInfo := AllocMem(HeaderSize);
  Stream := nil;
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
            //Read file Header
      Stream.ReadBuffer(Header, SizeOf(Header));
            //Read bitmap info header and validate
      Stream.ReadBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));
    finally
      Stream.Free;
    end;

    with BmpInfo^.bmiHeader do
    begin
      if (biBitCount = 8) and (biCompression = BI_RGB) then
        LoadFromFileDIB(FileName)
      else LoadFromFileTrueColor(FileName);
    end;

  except
    if Stream <> nil then Stream.Free;
    if Bits <> nil then FreeMem(Bits);
    Bits := nil;
  end;
  if BmpInfo <> nil then FreeMem(BmpInfo);
end;
//Load DIB ot File

procedure TA2Image.LoadFromFileDIB(FileName: string);
var
  BmpInfo: PBitMapInfo;
  Bmpbits: Pbyte;
  headerSize, ImageSize: Integer;
  Palette: TImgLibPalette;
begin

  BmpInfo := nil;
  BmpBits := nil;

  LoadDIB256(FileName, BmpInfo, BmpBits, HeaderSize, ImageSize);
  if (BmpInfo = nil) or (BmpBits = nil) then exit;

  if Bits <> nil then FreeMem(Bits, Width * Height * Sizeof(TAns2Color));

  Width := BmpInfo^.bmiHeader.biWidth;
  Height := Abs(BmpInfo^.bmiHeader.biHeight);
  BmpInfoToImgLibPal(Palette, BmpInfo);

  GetMem(Bits, Width * Height * Sizeof(TAns2Color));
  if Bits = nil then raise Exception.Create('TA2Image: GemMem Failed for Bits');
  FillChar(Bits^, Width * Height * sizeof(TAns2Color), 0);

  AnsPaletteDataToAns2Image(Self, Palette, BmpBits);

  FreeMem(Bmpbits);
  FreeMem(BmpInfo);
end;

procedure TA2Image.LoadFromFileTrueColor(FileName: string);  //2015.07.24 在水一方
var
  TBitmap1: TBitmap;
  Stream: TMemoryStream;
  Header: TBitmapFileHeader;
begin
  TBitmap1 := TBitmap.Create;
  Stream := TMemoryStream.Create;
  try
    Stream.LoadFromFile(FileName);
    Stream.ReadBuffer(Header, SizeOf(Header));
    if Header.bfType = $5A42 then begin
      Stream.Free;
      Stream := DeCryptionBmpFile(FileName);
    end;
    Stream.Position := 0;
    //TBitmap1.LoadFromFile(FileName);
    TBitmap1.LoadFromStream(Stream);
    TBitmap1.PixelFormat := pf24bit;
    LoadFromBitmap(TBitmap1);
  finally
    TBitmap1.Free;
    Stream.Free;
  end;
end;
//最主要的 读入点

procedure TA2Image.LoadFromStream(Stream: TStream);
var
  TBitmap1: TBitmap;
begin

  TBitmap1 := TBitmap.Create;
  try
    TBitmap1.LoadFromStream(Stream);
    TBitmap1.PixelFormat := pf24bit;
    LoadFromBitmap(TBitmap1);
  finally
    TBitmap1.Free;
  end;

end;

procedure TA2Image.LoadFromBitmap(Bitmap: TBitmap);
var
  i, j, t: integer;
  r, g, b: byte;
  bd: PTAns2Color;
  OrigRow: PRGBArray;
begin

  try
    if Bits <> nil then FreeMem(Bits, Width * Height * Sizeof(TAns2Color));
    Bits := nil;

    Width := Bitmap.Width;
    Height := Bitmap.Height;
    TransparentColor := Bitmap.TransparentColor;

    GetMem(Bits, Width * Height * 2);
    bd := Bits;
    case Bitmap.PixelFormat of
      pf24bit, pf32bit:
        begin
          for i := 0 to Height - 1 do
          begin

            OrigRow := Bitmap.ScanLine[i];
            for j := 0 to Width - 1 do
            begin
              r := OrigRow[j].rgbtRed;
              g := OrigRow[j].rgbtGreen;
              b := OrigRow[j].rgbtBlue;
              bd^ := WinRGB(r div 8, g div 8, b div 8);
              inc(bd);
            end;
          end;
        end;
    else
      begin
        for i := 0 to Height - 1 do
        begin
          for j := 0 to Width - 1 do
          begin
            t := Bitmap.Canvas.Pixels[j, i];
            R := GetRValue(t);
            G := GetGValue(t);
            B := GetBValue(t);
            bd^ := WinRGB(r div 8, g div 8, b div 8);
            inc(bd);
          end;
        end;
      end;
    end;

  except
    if Bits <> nil then FreeMem(Bits);
    Bits := nil;
  end;
end;

{procedure TA2Image.LoadFromFileTrueColor(FileName:string);
var
    //   i, j : integer;
    Stream          :TFileStream;
    Header          :TBitmapFileHeader;
    BmpInfo         :PBitMapInfo;
    HeaderSize      :Integer;
    buffer          :pbyte;
begin
    //Initialise and open file
    HeaderSize := SizeOf(TBitmapInfoHeader);
    BmpInfo := AllocMem(HeaderSize);
    buffer := nil;
    Stream := nil;
    try
        Stream := TFileStream.Create(FileName, fmOpenRead);
        //Read file Header
        Stream.ReadBuffer(Header, SizeOf(Header));
        //Read bitmap info header and validate
        Stream.ReadBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));

        with BmpInfo^.bmiHeader do
        begin
            if biBitCount <> 24 then
            begin
                Stream.Free;
                FreeMem(BmpInfo);
                raise Exception.Create('TA2Image: Not TrueColor');
                exit;
            end;
        end;

        Width := BmpInfo^.bmiHeader.biWidth;
        Height := BmpInfo^.bmiHeader.biHeight;

        if Bits <> nil then FreeMem(Bits, Width * Height * Sizeof(TAns2Color));
        GetMem(Bits, Width * Height * 2);
        GetMem(Buffer, Width * Height * 3);

        //Load Bits
        //Stream.Seek(Header.bfOffBits, soFromBeginning);
        Stream.ReadBuffer(Buffer^, LongInt(width * height * 3));
        FlipBits(Buffer, Width * 3, Height);

        AnsTrueDataToAns2Image(Self, Buffer);

        //If the code gets this far the bitmap has been loaded okay
        Stream.Free;
        FreeMem(Buffer);
    except
        if Stream <> nil then Stream.Free;
        if Buffer <> nil then FreeMem(Buffer);
        if Bits <> nil then FreeMem(Bits);
        Bits := nil;
    end;
    if BmpInfo <> nil then FreeMem(BmpInfo);
end;}
//Save DIB ot File

procedure TA2Image.SaveToFile(FileName: string);
var
  Stream: TFileStream;
  Header: TBitmapFileHeader;
  BmpInfo: PBitMapInfo;
  HeaderSize, fh: Integer;
  tempBits: PTAns2Color;
begin
  HeaderSize := SizeOf(TBitmapInfo);
  BmpInfo := AllocMem(HeaderSize);

  with BmpInfo^.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := Width;
    biHeight := -Height;
    biPlanes := 1;
    biBitCount := 16; //16;          //always convert to 8 bit image
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  GetMem(tempBits, Width * Height * sizeof(TAns2Color));
  move(Bits^, tempBits^, Width * Height * sizeof(TAns2Color));
    //if the height is positive the bitmap is Bottom up so flip it.
  if BmpInfo^.bmiHeader.biHeight < 0 then
  begin

    FlipBits(PByte(tempBits), Width * 2, Height);
    BmpInfo^.bmiHeader.biHeight := -BmpInfo^.bmiHeader.biHeight;
  end;

  FillChar(Header, sizeof(TBitmapFileHeader), 0);
  with Header do
  begin
    bfType := $4D42;
    bfSize := 1078 + Width * Height * 2 - 1024;
    bfOffBits := 1078 - 1024;
  end;

  fh := FileCreate(FileName);
  FileClose(fh);

    //Initialise and open file
  Stream := TFileStream.Create(FileName, fmOpenWrite);
    //Read file Header
  Stream.WriteBuffer(Header, SizeOf(Header));
    //Read bitmap info header and validate
  Stream.WriteBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));

    //Load Bits
    //Stream.Seek(Header.bfOffBits, soFromBeginning);
  Stream.WriteBuffer(tempBits^, Width * Height * sizeof(TAns2Color));

    //If the code gets this far the bitmap has been loaded okay
  Stream.Free;
  FreeMem(BmpInfo);
  FreeMem(tempBits, Width * Height * sizeof(TAns2Color));
end;

procedure TA2Image.SaveToBitmap(Bitmap: TBitmap);
var
  tempTMemoryStream: TMemoryStream;
begin
  tempTMemoryStream := TMemoryStream.Create;
  try
    SaveToStream(tempTMemoryStream);
    tempTMemoryStream.Position := 0;
    Bitmap.LoadFromStream(tempTMemoryStream);
  finally
    tempTMemoryStream.Free;
  end;

end;

procedure TA2Image.SaveToStream(Stream: TStream);
var
  Header: TBitmapFileHeader;
  BmpInfo: PBitMapInfo;
  HeaderSize: Integer;
  tempBits: PTAns2Color;
begin
  HeaderSize := SizeOf(TBitmapInfo);
  BmpInfo := AllocMem(HeaderSize);

  with BmpInfo^.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := Width;
    biHeight := -Height;
    biPlanes := 1;
    biBitCount := 16; //16;          //always convert to 8 bit image
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
  GetMem(tempBits, Width * Height * sizeof(TAns2Color));
  move(Bits^, tempBits^, Width * Height * sizeof(TAns2Color));
    //if the height is positive the bitmap is Bottom up so flip it.
  if BmpInfo^.bmiHeader.biHeight < 0 then
  begin
    FlipBits(PByte(tempBits), Width * 2, Height);
    BmpInfo^.bmiHeader.biHeight := -BmpInfo^.bmiHeader.biHeight;
  end;

  FillChar(Header, sizeof(TBitmapFileHeader), 0);
  with Header do
  begin
    bfType := $4D42;
    bfSize := 1078 + Width * Height * 2 - 1024;
    bfOffBits := 1078 - 1024;
  end;

    //Read file Header
  Stream.WriteBuffer(Header, SizeOf(Header));
    //Read bitmap info header and validate
  Stream.WriteBuffer(BmpInfo^, SizeOf(TBitmapInfoHeader));

    //Load Bits
    //Stream.Seek(Header.bfOffBits, soFromBeginning);
  Stream.WriteBuffer(tempBits^, Width * Height * sizeof(TAns2Color));

    //If the code gets this far the bitmap has been loaded okay

  FreeMem(BmpInfo);
  FreeMem(tempBits, Width * Height * sizeof(TAns2Color));
end;
//////////////////////////////////////
//        TA2ImageLib             //
//////////////////////////////////////

constructor TA2ImageLib.Create;
begin
  temp := TA2Image.Create(32, 32, 0, 0);
  temp.Clear(0);
  TransparentColor := 0;
  FTag := 0;
  ImageList := TList.Create;
end;

destructor TA2ImageLib.Destroy;
var
  i: integer;
begin
  temp.Free;
  for i := 0 to ImageList.Count - 1 do TA2Image(ImageList.items[i]).Free;
  ImageList.Free;
  inherited Destroy;
end;

function TA2ImageLib.GetByName(aName: string): TA2Image;
var
  i: integer;
  AnsImage: TA2Image;
begin
  Result := nil;

  for i := 0 to Imagelist.Count - 1 do
  begin
    AnsImage := ImageList[i];
    if AnsImage.Name = aName then
    begin
      Result := AnsImage;
      exit;
    end;
  end;
end;

function TA2ImageLib.GetCount: Integer;
begin
  Result := ImageList.Count;
end;

function TA2ImageLib.GeTA2Image(Idx: Integer): TA2Image;
begin
  if ImageList = nil then
  begin
    Result := temp;
    exit;
  end;
  if (Idx < ImageList.Count) and (Idx >= 0) then Result := ImageList.items[Idx]
  else Result := temp;
end;

procedure TA2ImageLib.Clear;
var
  i: Integer;
  AnsImage: TA2Image;
begin
  for i := 0 to ImageList.Count - 1 do
  begin
    AnsImage := ImageList.Items[i];
    AnsImage.Free;
  end;
  ImageList.Clear;
end;

procedure TA2ImageLib.AddImage(AImage: TA2Image);
var
  pp: TA2Image;
begin
  pp := TA2Image.Create(AImage.Width, AImage.Height, 0, 0);
  AImage.CopyImage(pp);
   // pp.DrawImage(AImage, 0, 0, false);
  pp.px := AImage.px;
  pp.py := AImage.py;
  pp.Name := AImage.Name;
  pp.TransparentColor := AImage.TransparentColor;
  pp.DrawOnBack := AImage.DrawOnBack;  //2015.11.15 在水一方
  ImageList.add(pp);
end;

procedure TA2ImageLib.DeleteImage(Idx: Integer);
begin
  if Idx < ImageList.Count then
  begin
    TA2Image(ImageList.items[Idx]).Free;
    ImageList.Delete(Idx);
  end;
end;

procedure TA2ImageLib.InsertImage(Idx: Integer; AImage: TA2Image);
begin
  ImageList.Insert(Idx, AImage);
  AImage.TransParentColor := TransParentColor;
end;

procedure TA2ImageLib.SaveToStream(Stream: TMemoryStream);
var

  n: Integer;
  AnsImage: TA2Image;
  fAnsHdr: TA2ImageFileHeader;
  ImgHeader: TImgLibHeader;
begin
//    Stream := TFileStream.Create(FileName, fmCreate);
  with ImgHeader do
  begin
    Ident := 'ATZ1';
    ImageCount := ImageList.Count;
    TransparentColor := Self.TransparentColor;
        //      Palette := Self.Palette;
  end;

  Stream.WriteBuffer(ImgHeader, SizeOf(ImgHeader));
  for n := 0 to ImgHeader.ImageCount - 1 do
  begin
    AnsImage := ImageList.items[n];
    fAnsHdr.Width := AnsImage.Width;
    fAnsHdr.Height := AnsImage.Height;
    fAnsHdr.Px := AnsImage.Px;
    fAnsHdr.Py := AnsImage.Py;
    Stream.WriteBuffer(fAnsHdr, SizeOf(TA2ImageFileHeader));
    Stream.WriteBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height * 2);
  end;

 //   Stream.Free;
end;

procedure TA2ImageLib.LoadFromStream(aStream: TStream);
var
  n: Integer;
  AnsImage: TA2Image;
  ImgHeader: TA2ImageLibHeader;
  FAnsHdr: TA2ImageFileHeader;

    //    FAnsHdrEFD      :TA2ImageEFD_FileHeader;
  pbuf: pbyte;
  newfilehead: Integer;
    //    showbuf         :array[0..64] of byte;
begin
    //    exit;
  try
    Clear;

    aStream.ReadBuffer(ImgHeader, SizeOf(TA2ImageLibHeader));
    if StrLIComp(PChar(ImageLibID), ImgHeader.Ident, 4) = 0 then
    begin
      for n := 0 to ImgHeader.ImageCount - 1 do
      begin
        aStream.ReadBuffer(FAnsHdr, SizeOf(TA2ImageFileHeader));
        AnsImage := TA2Image.Create(FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
        try
          GetMem(pbuf, AnsImage.Width * AnsImage.Height);
          aStream.ReadBuffer(pbuf^, AnsImage.Width * AnsImage.Height);
                    //RGB888，转RGB555
          AnsPaletteDataToAns2Image(AnsImage, ImgHeader.Palette, pbuf);
          FreeMem(pbuf, AnsImage.Width * AnsImage.Height);
          AnsImage.TransparentColor := TransParentColor;
          AddImage(AnsImage);
        finally
          AnsImage.Free;
        end;
      end;

    end
    else if StrLIComp(PChar(ImageLibEFD0), ImgHeader.Ident, 3) = 0 then
    begin
      aStream.Position := 0;
      LoadFromStreamEFT(aStream);
      exit;
    end
    else
    begin
      if StrLIComp(PChar(ImageLibID1), ImgHeader.Ident, 4) = 0 then
      begin
        for n := 0 to ImgHeader.ImageCount - 1 do
        begin
          aStream.ReadBuffer(FAnsHdr, SizeOf(TA2ImageFileHeader));
                    //            FileRead (fh, FAnsHdr, SizeOf(TA2ImageFileHeader));
          AnsImage := TA2Image.Create(FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
          try
            if AnsImage.Width <> FAnsHdr.Width then AnsImage.Resize(FAnsHdr.Width, FAnsHdr.Height);
                        //直接是RGB555
            aStream.ReadBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height * 2);
                        //            FileRead (fh, AnsImage.Bits^, AnsImage.Width * AnsImage.Height * 2);
            AnsImage.TransparentColor := TransParentColor;

            AddImage(AnsImage);
          finally
            AnsImage.Free;
          end;
        end;
      end else raise Exception.Create('Not a valid Image Library File');
    end;

  except

  end;

end;


procedure TA2ImageLib.LoadFromStreamFenge(aStream: TStream);
var
  x, y: Integer;
  AnsImage, aImage: TA2Image;
begin

  Clear;
  aImage := TA2Image.Create(32, 32, 0, 0);
  AnsImage := TA2Image.Create(32, 32, 0, 0);
  try
    aImage.LoadFromStream(aStream);
    for y := 0 to (aImage.Width div 32) - 1 do
    begin
      for x := 0 to (aImage.Height div 32) - 1 do
      begin
        aImage.GetImage(AnsImage, x * 32, y * 32);
        AnsImage.TransparentColor := 0;
        AddImage(AnsImage);
      end;
    end;
  finally
    aImage.Free;
    AnsImage.Free;
  end;
end;
const

  //XorKey: array[0..10] of Byte = ($A1, $B7, $AC, $57, $1C, $63, $3B, $81, $57, $1C, $63); //字符串加密用 old
  XorKey: array[0..10] of Byte = ($A2, $B8, $AC, $68, $2C, $74, $4B, $92, $68, $2C, $64); //字符串加密用

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

procedure TA2ImageLib.LoadFromFile(FileName: string);
var
  Stream: TFileStream;
    //   fh : integer;
  n, w, h: Integer;
  AnsImage: TA2Image;
  ImgHeader: TA2ImageLibHeader;
  FAnsHdr: TA2ImageFileHeader;

    //    FAnsHdrEFD      :TA2ImageEFD_FileHeader;
  pbuf: pbyte;
  showbuf: array[0..64] of byte;
  i: Integer;
  kfile: string;
  newfile: boolean;
  newfilehead: Integer;
  filestring, realname: string;
  rbyte: array[0..15] of Byte;
begin
  newfile := false;
  i := 0;
  if FileExists(FileName) = FALSE then
  begin
    StrPcopy(@ShowBuf, 'File Not Found : ' + FileName);
    Windows.MessageBox(0, @ShowBuf, 'Error', 0);
    exit;
  end;

  //N00.Atz      //这里判断路径暂时必须是指定的某个ATZ文件

  if pos('.\res\', FileName) > 0 then
  begin
//    realname := ExtractFileName(FileName);
//    realname := StringReplace(realname, '.dat', '', [rfReplaceAll]);
//    realname := Dec(realname);
    newfile := true;
  end;
  if pos('.\eff\', FileName) > 0 then
  begin
    newfile := true;
  end;
  Stream := nil;
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    Clear;
    if newfile then
    begin
      //Stream.Seek(16, 0);
      for n := 0 to 15 do
        Stream.ReadBuffer(rbyte[n],1);
    end;
    Stream.ReadBuffer(ImgHeader, SizeOf(TA2ImageLibHeader));
    if StrLIComp(PChar(ImageLibID), ImgHeader.Ident, 4) = 0 then
    begin
      for n := 0 to ImgHeader.ImageCount - 1 do
      begin
        Stream.ReadBuffer(FAnsHdr, SizeOf(TA2ImageFileHeader));
        AnsImage := TA2Image.Create(FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
        try
          if AnsImage = nil then
            raise Exception.Create('TA2Image: GemMem Failed ');
          GetMem(pbuf, AnsImage.Width * AnsImage.Height);
          Stream.ReadBuffer(pbuf^, AnsImage.Width * AnsImage.Height);
                    //rgb888 TO RGB555
          AnsPaletteDataToAns2Image(AnsImage, ImgHeader.Palette, pbuf);

          FreeMem(pbuf, AnsImage.Width * AnsImage.Height);

          AnsImage.TransparentColor := TransParentColor;
            /////////// 2014
//          kfile := ExtractFilePath(ParamStr(0)) + atztemp + '\' + inttostr(i) + '.bmp';
//          CreateDir(ExtractFilePath(ParamStr(0)) + atztemp + '\');
//          if not FileExists(kfile) then AnsImage.SaveToFile(kfile); //这里劫持文件
//          Inc(i);
          //////////////
          AddImage(AnsImage);
        finally
          AnsImage.Free;
        end;
      end;
    end
    else if StrLIComp(PChar(ImageLibEFD0), ImgHeader.Ident, 3) = 0 then
    begin
      Stream.Free;
      LoadFromFileEFT(FileName);
      exit;
    end
    else
    begin
      if StrLIComp(PChar(ImageLibID1), ImgHeader.Ident, 4) = 0 then
      begin
        for n := 0 to ImgHeader.ImageCount - 1 do
        begin
          Stream.ReadBuffer(FAnsHdr, SizeOf(TA2ImageFileHeader));
                    //            FileRead (fh, FAnsHdr, SizeOf(TA2ImageFileHeader));
          AnsImage := TA2Image.Create(FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
          try
            if AnsImage = nil then
              raise Exception.Create('TA2Image: GemMem Failed ');
            if AnsImage.Width <> FAnsHdr.Width then AnsImage.Resize(FAnsHdr.Width, FAnsHdr.Height);
                       //直接
            Stream.ReadBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height * 2);
                        //            FileRead (fh, AnsImage.Bits^, AnsImage.Width * AnsImage.Height * 2);
            AnsImage.TransparentColor := TransParentColor;
            /////////// 2014
//            kfile := ExtractFilePath(ParamStr(0)) + '\atz\' + inttostr(i) + '.bmp';
//            if not FileExists(kfile) then AnsImage.SaveToFile(kfile); //这里劫持文件
//            Inc(i);
          //////////////

            AddImage(AnsImage);
          finally
            AnsImage.Free;
          end;
        end;
      end
      else if StrLIComp(PChar(ImageLibID3), ImgHeader.Ident, 4) = 0 then
      begin
        for n := 0 to ImgHeader.ImageCount - 1 do
        begin
          Stream.ReadBuffer(FAnsHdr, SizeOf(TA2ImageFileHeader));
          {$I SE_PROTECT_START_MUTATION.inc}
          w := FAnsHdr.Width;
          h := FAnsHdr.Height;
          asm
            mov eax, w
            rol eax,4
            mov w, eax
            mov eax, h
            rol eax,2
            mov h, eax
          end;
          FAnsHdr.Width := w xor rbyte[(n + 3) mod 16];
          FAnsHdr.Height := h xor rbyte[(n + 5) mod 16];
          {$I SE_PROTECT_END.inc}
          AnsImage := TA2Image.Create(FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
          try
            if AnsImage = nil then
              raise Exception.Create('TA2Image: GemMem Failed ');
            GetMem(pbuf, AnsImage.Width * AnsImage.Height);
            Stream.ReadBuffer(pbuf^, AnsImage.Width * AnsImage.Height);
            AnsPaletteDataToAns2Image(AnsImage, ImgHeader.Palette, pbuf);

            FreeMem(pbuf, AnsImage.Width * AnsImage.Height);

            AnsImage.TransparentColor := TransParentColor;
            AddImage(AnsImage);
          finally
            AnsImage.Free;
          end;
        end;
      end
      else if StrLIComp(PChar(ImageLibID4), ImgHeader.Ident, 4) = 0 then
      begin
        for n := 0 to ImgHeader.ImageCount - 1 do
        begin
          Stream.ReadBuffer(FAnsHdr, SizeOf(TA2ImageFileHeader));
          {$I SE_PROTECT_START_MUTATION.inc}
          w := FAnsHdr.Width;
          h := FAnsHdr.Height;
          asm
            mov eax, w
            rol eax,4
            mov w, eax
            mov eax, h
            rol eax,2
            mov h, eax
          end;
          FAnsHdr.Width := w xor rbyte[(n + 3) mod 16];
          FAnsHdr.Height := h xor rbyte[(n + 5) mod 16];
          {$I SE_PROTECT_END.inc}
          AnsImage := TA2Image.Create(FAnsHdr.Width, FAnsHdr.Height, FAnsHdr.px, FAnsHdr.py);
          try
            if AnsImage = nil then
              raise Exception.Create('TA2Image: GemMem Failed ');
            if AnsImage.Width <> FAnsHdr.Width then AnsImage.Resize(FAnsHdr.Width, FAnsHdr.Height);
            Stream.ReadBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height * 2);
            AnsImage.TransparentColor := TransParentColor;

            AddImage(AnsImage);
          finally
            AnsImage.Free;
          end;
        end;
      end else raise Exception.Create('Not a valid Image Library File:' + realname);
    end;
    Stream.Free;
  except
    if Stream <> nil then Stream.Free;
  end;
    //   FileClose (fh);
end;
//1，一批全部增加空图片，2，计算位置，3，一批全部再读入内容

procedure TA2ImageLib.LoadFromStreamEFT(aStream: TStream);
var

  alen: word;
  n: Integer;
  AnsImage: TA2Image;
  FAnsHdrEFD: TA2ImageEFD_FileHeader;
  Ident: array[0..4] of char;
  onback: Boolean;
    //    aBM             :array[0..1] of char;
    //    showbuf         :array[0..64] of byte;
    //    s               :string;
    //    px              :smallint;
    //    py              :smallint;
begin

  try

    Clear;
    aStream.Position := 0;
    aStream.ReadBuffer(Ident, 4);

    if StrLIComp(PChar(ImageLibEFD2), Ident, 4) = 0 then
    begin //$10 图片数量  起点 $3a   包头$26
      aStream.Position := $10;
      aStream.ReadBuffer(alen, 2);
      aStream.Position := $3A;
            //创建空的
      for n := 0 to alen - 1 do
      begin
        aStream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          aStream.Position := aStream.Position - 8;
          Break;
        end;
        aStream.Position := aStream.Position + $26 - 8;
        AnsImage := TA2Image.Create(32, 32, FAnsHdrEFD.px, FAnsHdrEFD.py);
        try
          AddImage(AnsImage);
        finally
          AnsImage.Free;
        end;
      end;
            //计算位置
      while aStream.Position < aStream.Size do
      begin
        aStream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          aStream.Position := aStream.Position - 8;
          Break;
        end;
        aStream.Position := aStream.Position + $26 - 8;
      end;
            //正式读入图片
      for n := 0 to ImageList.Count - 1 do
      begin

        AnsImage := ImageList.Items[n];
        AnsImage.LoadFromStream(aStream);
      end;
    end
    else if StrLIComp(PChar(ImageLibEFD0), Ident, 4) = 0 then
    begin //$6 图片数量  起点 $73   包头$2F
      aStream.Position := $6;
      aStream.ReadBuffer(alen, 2);
      aStream.Position := $73;
      for n := 0 to alen - 1 do
      begin
        aStream.ReadBuffer(FAnsHdrEFD, 2);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          aStream.Position := aStream.Position - 2;
          Break;
        end;
        onback := false;                                  //2015.11.15 在水一方 >>>>>>
        aStream.Position := aStream.Position -1;
        aStream.ReadBuffer(FAnsHdrEFD.px, 2);
        aStream.Position := aStream.Position + 2;
        aStream.ReadBuffer(FAnsHdrEFD.py, 2);
        aStream.Position := aStream.Position + 2;
        if (FAnsHdrEFD.px = 0) and (FAnsHdrEFD.py = 0) then begin
          aStream.ReadBuffer(FAnsHdrEFD.px, 2);
          aStream.Position := aStream.Position + 2;
          aStream.ReadBuffer(FAnsHdrEFD.py, 2);
          aStream.Position := aStream.Position + 2;
          aStream.Position := aStream.Position + $2F - 17;
          if (FAnsHdrEFD.px <> 0) or (FAnsHdrEFD.py <> 0) then
            onback := true;
        end
        else
          aStream.Position := aStream.Position + $2F - 9;
        AnsImage := TA2Image.Create(32, 32, FAnsHdrEFD.px, FAnsHdrEFD.py);
        AnsImage.DrawOnBack := onback;                     //2015.11.15 在水一方 <<<<<<
        try
          AddImage(AnsImage);
        finally
          AnsImage.Free;
        end;
      end;
      while aStream.Position < aStream.Size do
      begin
        aStream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          aStream.Position := aStream.Position - 8;
          Break;
        end;
        aStream.Position := aStream.Position + $2F - 8;
      end;
      for n := 0 to ImageList.Count - 1 do
      begin
        AnsImage := ImageList.Items[n];
        AnsImage.LoadFromStream(aStream);
      end;

    end
    else if StrLIComp(PChar(ImageLibEFD1), Ident, 4) = 0 then
    begin //$10 图片数量  起点 $34   包头$26
      aStream.Position := $10;
      aStream.ReadBuffer(alen, 2);
      aStream.Position := $34;
      for n := 0 to alen - 1 do
      begin
        aStream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          aStream.Position := aStream.Position - 8;
          Break;
        end;
        aStream.Position := aStream.Position + $26 - 8;
        AnsImage := TA2Image.Create(32, 32, FAnsHdrEFD.px, FAnsHdrEFD.py);
        try
          AddImage(AnsImage);
        finally
          AnsImage.Free;
        end;
      end;
      while aStream.Position < aStream.Size do
      begin
        aStream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          aStream.Position := aStream.Position - 8;
          Break;
        end;
        aStream.Position := aStream.Position + $26 - 8;
      end;
      for n := 0 to ImageList.Count - 1 do
      begin
        AnsImage := ImageList.Items[n];
        AnsImage.LoadFromStream(aStream);
      end;

    end else raise Exception.Create('Not a valid Image Library File');

  except

  end;
    //   FileClose (fh);
end;
//1，一批全部增加空图片，2，计算位置，3，一批全部再读入内容

procedure TA2ImageLib.LoadFromFileEFT(FileName: string);
var
  Stream: TFileStream;
  alen: word;
  n, i: Integer;
  AnsImage: TA2Image;
  FAnsHdrEFD: TA2ImageEFD_FileHeader;
  Ident: array[0..4] of char;
    //    aBM             :array[0..1] of char;
  showbuf: array[0..64] of byte;
  newfile, encfile: Boolean;
  newfilehead: Integer;
  onback: Boolean;
  rbyte: array[0..15] of Byte;
  buff, buff2: PByte;
  buff3: PSmallInt;
  abyte: Byte;
    //    s               :string;
    //    px              :smallint;
    //    py              :smallint;
begin
  if FileExists(FileName) = FALSE then
  begin
    StrPcopy(@ShowBuf, 'File Not Found : ' + FileName);
    Windows.MessageBox(0, @ShowBuf, 'Error', 0);
    exit;
  end;


  Stream := nil;
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    Clear;
    Stream.Position := 0;
    //Stream.Seek(16, 0);
    for n := 0 to 15 do
      Stream.ReadBuffer(rbyte[n],1);
    Stream.ReadBuffer(Ident, 5);
    if Ident[4] = 'X' then
      encfile := True
    else
      encfile := False;

    if StrLIComp(PChar(ImageLibEFD2), Ident, 4) = 0 then
    begin //$10 图片数量  起点 $3a   包头$26
      Stream.Position := $10+16;
      Stream.ReadBuffer(alen, 2);
      Stream.Position := $3A+16;
      for n := 0 to alen - 1 do
      begin
        Stream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          Stream.Position := Stream.Position - 8;
          Break;
        end;
        Stream.Position := Stream.Position + $26  - 8;
        buff2 := @FAnsHdrEFD;
        if encfile then
        for i := 0 to 8 - 1 do
        begin
          abyte := buff2^;
          asm
            mov al, abyte
            rol al,4
            mov abyte, al
          end;
          buff2^ := abyte xor rbyte[(i + 4) mod 16];
          Inc(buff2);
        end;
        AnsImage := TA2Image.Create(32, 32, FAnsHdrEFD.px, FAnsHdrEFD.py);
        try
          AddImage(AnsImage);
        finally
          AnsImage.Free;
        end;
      end;
      while Stream.Position < Stream.Size do
      begin
        Stream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          Stream.Position := Stream.Position - 8;
          Break;
        end;
        Stream.Position := Stream.Position + $26 - 8;
      end;

      if encfile then
        Stream.Position := Stream.Position + $10 + 2;
      for n := 0 to ImageList.Count - 1 do
      begin

        AnsImage := ImageList.Items[n];
        AnsImage.LoadFromStream(Stream);
      end;
    end
    else if StrLIComp(PChar(ImageLibEFD0), Ident, 4) = 0 then
    begin //$6 图片数量  起点 $73   包头$2F
      Stream.Position := $6+16;
      Stream.ReadBuffer(alen, 2);
      Stream.Position := $73+16;
      buff := AllocMem($2F);
      try
        for n := 0 to alen - 1 do
        begin
          Stream.ReadBuffer(FAnsHdrEFD, 2);
          if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
          begin
            Stream.Position := Stream.Position - 2;
            Break;
          end;
          onback := false;                                  //2015.11.15 在水一方 >>>>>>
          buff2 := buff;
          Stream.Position := Stream.Position - 2;
          Stream.ReadBuffer(buff^, $2F);
          if encfile then
          for i := 0 to $2F - 1 do
          begin
            abyte := buff2^;
            asm
              mov al, abyte
              rol al,4
              mov abyte, al
            end;
            buff2^ := abyte xor rbyte[(i + 2) mod 16];
            Inc(buff2);
          end;
          buff2 := buff;
          Inc(buff2);
          buff3 := PSmallInt(buff2);
          FAnsHdrEFD.px := buff3^;
          Inc(buff3, 2);
          FAnsHdrEFD.py := buff3^;
          if (FAnsHdrEFD.px = 0) and (FAnsHdrEFD.py = 0) then begin
            Inc(buff3, 2);
            FAnsHdrEFD.px := buff3^;
            Inc(buff3, 2);
            FAnsHdrEFD.py := buff3^;
            if (FAnsHdrEFD.px <> 0) or (FAnsHdrEFD.py <> 0) then
              onback := true;
          end;
          {Stream.Position := Stream.Position -1;
          Stream.ReadBuffer(FAnsHdrEFD.px, 2);
          Stream.Position := Stream.Position + 2;
          Stream.ReadBuffer(FAnsHdrEFD.py, 2);
          Stream.Position := Stream.Position + 2;
          if (FAnsHdrEFD.px = 0) and (FAnsHdrEFD.py = 0) then begin
            Stream.ReadBuffer(FAnsHdrEFD.px, 2);
            Stream.Position := Stream.Position + 2;
            Stream.ReadBuffer(FAnsHdrEFD.py, 2);
            Stream.Position := Stream.Position + 2;
            Stream.Position := Stream.Position + $2F - 17;
            if (FAnsHdrEFD.px <> 0) or (FAnsHdrEFD.py <> 0) then
              onback := true;
          end
          else
            Stream.Position := Stream.Position + $2F - 9;}
          AnsImage := TA2Image.Create(32, 32, FAnsHdrEFD.px, FAnsHdrEFD.py);
          AnsImage.DrawOnBack := onback;                    //2015.11.15 在水一方 <<<<<<
          try
            AddImage(AnsImage);
          finally
            AnsImage.Free;
          end;
        end;
      finally
        FreeMem(buff);
      end;
      while Stream.Position < Stream.Size do
      begin
        Stream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          Stream.Position := Stream.Position - 8;
          Break;
        end;
        Stream.Position := Stream.Position + $2F - 8;
      end;

      if encfile then
        Stream.Position := Stream.Position + $10 + 2;
      for n := 0 to ImageList.Count - 1 do
      begin
        AnsImage := ImageList.Items[n];
        AnsImage.LoadFromStream(Stream);
      end;

    end
    else if StrLIComp(PChar(ImageLibEFD1), Ident, 4) = 0 then
    begin //$10 图片数量  起点 $34   包头$26
      Stream.Position := $10+16;
      Stream.ReadBuffer(alen, 2);
      Stream.Position := $34+16;
      for n := 0 to alen - 1 do
      begin
        Stream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          Stream.Position := Stream.Position - 8;
          Break;
        end;
        Stream.Position := Stream.Position + $26 - 8;
        buff2 := @FAnsHdrEFD;
        if encfile then
        for i := 0 to 8 - 1 do
        begin
          abyte := buff2^;
          asm
            mov al, abyte
            rol al,4
            mov abyte, al
          end;
          buff2^ := abyte xor rbyte[(i + 3) mod 16];
          Inc(buff2);
        end;
        AnsImage := TA2Image.Create(32, 32, FAnsHdrEFD.px, FAnsHdrEFD.py);
        try
          AddImage(AnsImage);
        finally
          AnsImage.Free;
        end;
      end;
      while Stream.Position < Stream.Size do
      begin
        Stream.ReadBuffer(FAnsHdrEFD, 8);
        if StrLIComp(PChar(imageBm), FAnsHdrEFD.IDent, 2) = 0 then
        begin
          Stream.Position := Stream.Position - 8;
          Break;
        end;
        Stream.Position := Stream.Position + $26 - 8;
      end;

      if encfile then
        Stream.Position := Stream.Position + $10 + 2;
      for n := 0 to ImageList.Count - 1 do
      begin
        AnsImage := ImageList.Items[n];
        AnsImage.LoadFromStream(Stream);
      end;

    end
    else raise Exception.Create('Not a valid Image Library File');
    Stream.Free;
  except
    if Stream <> nil then Stream.Free;
  end;

    //   FileClose (fh);
end;



procedure TA2ImageLib.SaveToFile(FileName: string);
var
  Stream: TFileStream;
  n: Integer;
  AnsImage: TA2Image;
  fAnsHdr: TA2ImageFileHeader;
  ImgHeader: TImgLibHeader;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  with ImgHeader do
  begin
    Ident := 'ATZ1';
    ImageCount := ImageList.Count;
    TransparentColor := Self.TransparentColor;
        //      Palette := Self.Palette;
  end;

  Stream.WriteBuffer(ImgHeader, SizeOf(ImgHeader));
  for n := 0 to ImgHeader.ImageCount - 1 do
  begin
    AnsImage := ImageList.items[n];
    fAnsHdr.Width := AnsImage.Width;
    fAnsHdr.Height := AnsImage.Height;
    fAnsHdr.Px := AnsImage.Px;
    fAnsHdr.Py := AnsImage.Py;
    Stream.WriteBuffer(fAnsHdr, SizeOf(TA2ImageFileHeader));
    Stream.WriteBuffer(AnsImage.Bits^, AnsImage.Width * AnsImage.Height * 2);
  end;

  Stream.Free;
end;

procedure A2DrawImageDC(dc: HDC; X, Y: Integer; ansImage: TA2Image);
//const
  //  bmpInfo         :PBitmapInfo = nil;
var
    //  HeaderSize      :integer;
  bmpInfo: TBitmapInfo;
begin
  if not assigned(AnsImage) then exit;
    //    HeaderSize := Sizeof(TBitmapInfo) + (256 * Sizeof(TRGBQuad));
        //   if bmpinfo = nil then BmpInfo := AllocMem(HeaderSize);

          // if BmpInfo = nil then raise Exception.Create('TNoryImage: Failed to allocate a DIB');
  with BmpInfo.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := AnsImage.Width;
    biHeight := -AnsImage.Height;
    biPlanes := 1;
    biBitCount := 16;
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;

  SetDIBitsToDevice(dc, x, y, AnsImage.Width, AnsImage.Height, 0, 0, 0, AnsImage.Height, AnsImage.Bits, BmpInfo, DIB_RGB_COLORS);
    //.   FreeMem(BmpInfo, HeaderSize);
end;

procedure A2DrawImage(Canvas: TCanvas; X, Y: Integer; ansImage: TA2Image);
var
  dc: HDC;
  bmpInfo: TBitmapInfo;
begin

  if not assigned(AnsImage) then exit;
  with BmpInfo.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := AnsImage.Width;
    biHeight := -AnsImage.Height;
    biPlanes := 1;
    biBitCount := 16;
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;

  dc := canvas.Handle;
  SetDIBitsToDevice(dc, x, y, AnsImage.Width, AnsImage.Height, 0, 0, 0, AnsImage.Height, AnsImage.Bits, BmpInfo, DIB_RGB_COLORS);
end;

procedure AnsPaletteDataToAns2Image(Ans2Image: TA2Image; Palette: TImgLibPalette; pb: pbyte);
var
  i, j: integer;
  db: PTAns2Color;
  sb: pbyte;
  col8, r, g, b, t: word;
  wcol: word;
begin
  sb := pb;
  db := Ans2Image.Bits;

  for j := 0 to Ans2Image.Height - 1 do
  begin
    for i := 0 to Ans2Image.Width - 1 do
    begin
      col8 := sb^;
      r := Palette[col8].Red;
      g := Palette[col8].Green;
      b := Palette[col8].Blue;

      t := r shr 3;
      if (r <> 0) and (t = 0) then r := 1
      else r := t;

      t := g shr 3;
      if (g <> 0) and (t = 0) then g := 1
      else g := t;

      t := b shr 3;
      if (b <> 0) and (t = 0) then b := 1
      else b := t;

      wcol := WinRgb(r, g, b);

      db^ := wcol;

      inc(sb);
      inc(db);
    end;
  end;
end;

procedure AnsTrueDataToAns2Image(Ans2Image: TA2Image; pb: pbyte);
var
  i, j: integer;
  db: PTAns2Color;
  sb: pbyte;
  r, g, b, t: word;
  wcol: word;
begin
  sb := pb;
  db := Ans2Image.Bits;

  for j := 0 to Ans2Image.Height - 1 do
  begin
    for i := 0 to Ans2Image.Width - 1 do
    begin
      r := sb^;
      inc(sb);
      g := sb^;
      inc(sb);
      b := sb^;
      inc(sb);

      t := r shr 3;
      if (r <> 0) and (t = 0) then r := 1
      else r := t;

      t := g shr 3;
      if (g <> 0) and (t = 0) then g := 1
      else g := t;

      t := b shr 3;
      if (b <> 0) and (t = 0) then b := 1
      else b := t;

      wcol := WinRgb(r, g, b);

      db^ := wcol;

      inc(db);
    end;
  end;
end;

////////////////////////////////////////////
//     迄飘 免仿阑 困茄 傈开 BitMap
////////////////////////////////////////////
//var
  //  Gbmpinfo        :PBitmapinfo;
//    GBitMap         :TBitMap;
  //  TextImage       :TA2Image;

  //  pTempBmpinfo    :PBitmapinfo;
 {
procedure CreateGBitMap(aBitMap:TBitMap; aImage:TA2Image);
var
    HeaderSize      :Integer;
    Focus           :hWnd;
    dc              :HDC;
begin
    HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
    GBmpinfo := AllocMem(HeaderSize);

    with GBmpinfo^.bmiHeader do
    begin
        biSize := SizeOf(TBitmapInfoHeader);
        biWidth := aImage.Width;
        biHeight := -aImage.Height;
        biPlanes := 1;
        biBitCount := 16;
        biCompression := BI_RGB;
        biSizeImage := 0;
        biClrUsed := 0;
        biClrImportant := 0;
    end;

    Focus := GetFocus;
    dc := GetDC(Focus);
    aBitMap.Handle := CreateDIBitmap(dc, GBmpinfo^.bmiHeader, 0, Pointer(0), GBmpinfo^, DIB_PAL_COLORS);
    ReleaseDC(Focus, DC);
    if aBitMap.Handle = 0 then raise Exception.Create('CreateDIBitmap failed');

    aBitMap.Canvas.Font.Name := BitMapFontName;
    aBitMap.Canvas.Font.Size := 9;
    aBitMap.Canvas.Font.Color := clWhite;
    aBitMap.Canvas.Brush.Color := 0;

    pTempBmpInfo := AllocMem(HeaderSize);
    with pTempBmpInfo^.bmiHeader do
    begin
        biSize := SizeOf(TBitmapInfoHeader);
        biWidth := aImage.Width;
        biHeight := -aImage.Height;
        biPlanes := 1;
        biBitCount := 16;
        biCompression := BI_RGB;
        biSizeImage := 0;
        biClrUsed := 0;
        biClrImportant := 0;
    end;
end;
{
function A2TextWidth(astr:string):integer;
begin
    Result := GBitMap.Canvas.TextWidth(aStr);
end;

function A2TextHeight(astr:string):integer;
begin
    Result := GBitMap.Canvas.TextHeight(aStr);
end;

procedure A2SetFontColor(aColor:integer);
begin
    GBitMap.Canvas.Font.Color := aColor;
end;

function A2GetCanvas:TCanvas;
begin
    Result := GBitMap.Canvas;
end;
//显示 和窗体一样大小图片 要出错误，需要修正

procedure A2DrawCanvas(aImage:TA2Image; x, y, sw, sh:integer; aTrans:Boolean);
var
    Temp            :TA2Image;
    ww, hh          :integer;
begin
    ww := sw;
    hh := sh;
    //   sw := 640; sh := 256;
    sw := 640;

    if sw > aImage.Width then
        sw := aImage.Width;
    if sh > aImage.Height then
        sh := aImage.Height;

    textImage.Width := sw;
    TextImage.Height := sh;
    pTempBmpInfo^.bmiHeader.biWidth := sw;
    pTempBmpInfo^.bmiHeader.biHeight := -sh;

    GetDIBits(GBitMap.Canvas.Handle, GBitMap.Handle, 0, TextImage.Height, TextImage.Bits, pTempBmpInfo^, 0);

    Temp := TA2Image.Create(ww, hh, 0, 0);
    Temp.Resize(ww, hh);
    Temp.DrawImage(TextImage, 0, 0, FALSE);

    aImage.DrawImage(temp, x, y, aTrans);
    //   aImage.DrawImage (TextImage, x, y, aTrans);

    Temp.Free;

end;

procedure A2SetFontName(aFontName:string);
begin
    BitMapFontName := aFontName;

    GBitMap.Canvas.Font.Name := BitMapFontName;
end;

procedure A2TextOut(aImage:TA2Image; FontSize, x, y:integer; astr:string);
var
    Temp            :TA2Image;
    ww, hh          :integer;
    w, h            :integer;
    r               :TRect;
    oldFontSize     :integer;
begin
    if astr = '' then exit;
    GBitMap.Canvas.Font.Name := BitMapFontName;
    oldFontSize := GBitMap.Canvas.Font.Size;
    GBitMap.Canvas.Font.Size := FontSize;

    w := WidthBytes(GBitMap.Canvas.TextWidth(astr));
    h := GBitMap.Canvas.TextHeight(astr);

    ww := w;
    hh := h;

    w := 640;                      //h := 256;

    r := RECT(0, 0, w, h);
    GBitMap.Canvas.FillRect(r);

    GBitMap.Canvas.TextOut(0, 0, astr);

    textImage.Width := w;
    TextImage.Height := h;

    pTempBmpInfo^.bmiHeader.biWidth := w;
    pTempBmpInfo^.bmiHeader.biHeight := -h;

    GetDIBits(GBitMap.Canvas.Handle, GBitMap.Handle, 0, TextImage.Height, TextImage.Bits, pTempBmpInfo^, 0);

    Temp := TA2Image.Create(ww, hh, 0, 0);
    Temp.DrawImage(TextImage, 0, 0, FALSE);

    aImage.DrawImage(temp, x, y, TRUE);

    GBitMap.Canvas.Font.Size := oldFontSize;
    Temp.Free;
end;
}
{
procedure A2TextOut (aImage: TA2Image; x, y: integer; astr: string);
var r : TRect;
begin
   r := RECT ( 0, 0, GBitMap.Width, GBitMap.Height);
   GBitMap.Canvas.FillRect ( r);
   TextImage.Clear(0);
   GBitMap.Canvas.TextOut (x, y, astr);
   GetDIBits(GBitMap.Canvas.Handle, GBitMap.Handle, 0, TextImage.Height, TextImage.Bits, GBmpinfo^, 0);
   aImage.DrawImage (TextImage, x, y, TRUE);
end;
}

////////////////////////////////
//     GetBmpInfo
////////////////////////////////

function GetPBitmapInfo(aWidth, aHeight, aBitCount: integer): TBitMapInfo;
//const
//    LocalBmpInfo    :PBitmapInfo = nil;
//var
  //  HeaderSize      :integer;
   // LocalBmpInfo    :tBitmapInfo;
begin
    // HeaderSize := Sizeof(TBitmapInfo) + (256 * Sizeof(TRGBQuad));
     //  if LocalBmpInfo = nil then
    //   begin
     //      LocalBmpInfo := AllocMem(HeaderSize);
      // end;
      // if LocalBmpInfo = nil then
        //   raise Exception.Create('TNoryImage: Failed to allocate a DIB');

       //   ImgLibPalToBmpInfo(GPalette, LocalBmpInfo);
  with Result.bmiHeader do
  begin
    biSize := SizeOf(TBitmapInfoHeader);
    biWidth := aWidth;
    biHeight := -aHeight;
    biPlanes := 1;
    biBitCount := aBitCount;
    biCompression := BI_RGB;
    biClrUsed := 0;
    biClrImportant := 0;
  end;
    //    Result := @LocalBmpInfo;
end;

var
  tempi: integer;

procedure TA2Image.DrawImageEx(AnsImage: TA2Image; x, y, Awidth,
  Aheight: Integer; aTrans: Boolean);
var
  spb, dpb, TempSS, TempDD: PTAns2Color;
  swidth, dwidth, aTColor, i, j: integer;
  ir, sr, dr: TRect;
const
  c_tt: int64 = $03E003E003E003E0;
begin
  if AnsImage = nil then exit;

  sr := Rect(x, y, x + Awidth - 1, y + Aheight - 1);
  dr := Rect(0, 0, Width - 1, Height - 1);

// if not IntersectRect(ir, sr, dr) then exit;
  ir :=sr;
  spb := AnsImage.Bits;
 // inc(spb, ((ir.left - x) + (ir.top - y) * Awidth));

  dpb := Bits;
  inc(dpb, (ir.left + ir.top * Width));

  if aTrans = FALSE then
  begin
    for i := ir.Top to ir.Bottom do
    begin
      move(spb^, dpb^, (ir.right - ir.left + 1) * sizeof(TAns2Color));
      inc(spb, AWidth);
      inc(dpb, Width);
    end;
    exit;
  end;
  swidth := AWidth * 2;
  dwidth := Width * 2;
  aTColor := AnsImage.TransparentColor;
  i := ir.Bottom - ir.Top + 1;
  j := ir.right - ir.left + 1;
  if (i > 0) and (j > 0) then
  begin
    asm
push edi
push esi
push eax
push ebx
/////////////TransparentColor/////////////
movd mm7,aTColor
punpcklwd mm7,mm7
punpcklwd mm7,mm7
/////////////for_Height_/////////////////////
@Height_:

mov eax,j
mov esi,spb
mov edi,dpb

/////////////for_Width_/////////////////////
@Width_:
  cmp eax,4
  jge @load_4
  cmp eax,3
  jge @load_3
  cmp eax,2
  jge @load_2
  cmp eax,1
  jge @load_1
  //0
  jmp @Width_end

  @load_3:
    movd mm0,[esi]                         //原
    movd mm1,[edi]                         //目标
   // pand mm0,c_load3_2
   // pand mm1,c_load3_2

    mov bx,[esi+4]                         //原
    movd mm2,ebx
    mov bx,[edi+4]
    movd mm3,ebx                         //目标
  //  pand mm2,c_load3_1
  //  pand mm3,c_load3_1
    psllq mm2,32
    psllq mm3,32


    por mm0,mm2
    por mm1,mm3
  jmp @load_end
  @load_2:
    movd mm0,[esi]                         //原
    movd mm1,[edi]                         //目标
  jmp @load_end
  @load_1:
    mov bx,[esi]                         //原
    movd mm0,ebx
    mov bx,[edi]
    movd mm1,ebx                         //目标
  jmp @load_end
  @load_4:
    movq mm0,[esi]                         //原
    movq mm1,[edi]                         //目标
  @load_end:

  movq mm6,mm7
  pcmpeqw mm6,mm0    //透明位置
  pmovmskb ebx,mm6
  cmp ebx,$ff        //全透明结束
  jz @Next_
  //  movq    mm5,mm7
  //  pcmpeqw mm5,mm0
    movq    mm4,mm6    //拷贝一份 透明位置
    pand    mm4,mm1    //保留目标
    pandn   mm6,mm0    //保留原始  反向 透明位置
    por     mm4,mm6    //合并

    cmp eax,4
    jge @save4_
      cmp eax,3
      jge @save3_
      cmp eax,2
      jge @save2_
      cmp eax,1
      jge @save1_
      //0
      jmp @Width_end
    @save4_:
   // movq mm4,c_tt
    movq [edi],mm4
  @Next_:
  add esi,8
  add edi,8

  sub eax,4
  jnz @Width_
  jmp @Width_end

@save2_: //绿
    movd ebx,mm4
   // mov ebx,$3E003E0
    mov [edi],ebx
    jmp @Width_end
@save3_: //蓝
          //mov ebx,$1F001F
    movd ebx,mm4
    mov [edi],ebx
    psrlq mm4,32
    movd ebx,mm4

    mov [edi+4],bx


    jmp @Width_end
@save1_:   //红
    movd ebx,mm4
  //  mov ebx,$7C00
    mov [edi],bx

@Width_end:
/////////////for_Width_/////////////////////

mov esi,spb
mov edi,dpb
add esi,swidth
add edi,dwidth
mov spb,esi
mov dpb,edi
dec i
jnz @Height_
/////////////for_Height_/////////////////////

emms
pop ebx
pop eax
pop esi
pop edi
    end;
  end;
end;

procedure TA2Image.DrawhLine(x, y, w: Integer; Col: word; H: Integer);
var
  i,j : integer;
     
begin
  j:=y;
  for i:=0 to h-1 do
  begin

      hLine(x, j, w, Col );
      Inc(j);
  end;  

end;

initialization
  begin
        //  TextImage := TA2Image.Create(640, 256, 0, 0);
         // GBitMap := TBitmap.Create;

        //  CreateGBitMap(GBitMap, TextImage);

          //   for tempi := 0 to 65535 do darkentbl[tempi] := WinOpercity (tempi, 60);
          //   for tempi := 0 to 65535 do darkentbl[tempi] := WinDECRGB (tempi, 4); //盔夯

          { 1
             for tempi := 0 to 65535 do darkentbl[tempi] := WinOpercity (tempi, 95);
             for tempi := 0 to 65535 do darkentbl[tempi] := WinOpercityForCl1000 (darkentbl[tempi], 60);
          }
             // 弊覆磊侩
    for tempi := 0 to 65535 do darkentbl[tempi] := WinOpercity(tempi, 50);
      //  for tempi := 0 to 65535 do darkentbl[tempi] := WinDECRGB(darkentbl[tempi], 3);
        // bubble 侩
    for tempi := 0 to 65535 do bubbletbl[tempi] := WinDECRGB(tempi, 4);

    for tempi := 0 to 65535 do DECRGBdarkentbl[tempi] := WinDECRGB(tempi, 5);
    OptFont := False;
    A2FontClass := TA2FontClass.Create;
    A2FontClassEx:= TA2FontClass.Create;
        A2FontClassBold:= TA2FontClass.Create;
    A2FontClass5 := TA2FontClass.Create;       //2015.12.19 在水一方
    A2FontClass6 := TA2FontClass.Create;
    A2FontClass7 := TA2FontClass.Create;
    A2FontClass8 := TA2FontClass.Create;
    A2FontClass9 := TA2FontClass.Create;
    A2FontClass10 := TA2FontClass.Create;
    A2FontClass11 := TA2FontClass.Create;
    A2FontClass12 := TA2FontClass.Create;
    A2FontClass13 := TA2FontClass.Create;     //<<<<<<
  end;

finalization
  begin
    A2FontClass.Free;
     A2FontClassEx.Free;
     A2FontClassBold.Free;
    A2FontClass5.Free;                          //2015.12.19 在水一方
    A2FontClass6.Free;
    A2FontClass7.Free;
    A2FontClass8.Free;
    A2FontClass9.Free;
    A2FontClass10.Free;
    A2FontClass11.Free;
    A2FontClass12.Free;
    A2FontClass13.Free;                        //<<<<<<
        // GBitMap.Free;
        // TextImage.Width := 640;
       //  TextImage.Height := 128;
        // TextImage.Free;
  end;

end.

