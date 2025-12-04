unit AtzCls;

interface

uses
  Windows, SysUtils, Classes, A2Img, deftype, clType, StrDb, uAnsTick, AUtil32, uKeyClass
  , Controls;

const
  UnUsedFreeTickDelay = 30000;
  UnUsedFreeTickAtzLibDelay = 20000;

  FreeCountMAXSIZE = 3;
  FpkTempPath = '.\res\LightTEMP\';

type
  TImageFiledata = record
    rname: string;
    rImageLib: TA2ImageLib;
    rrunTick: integer;
  end;
  pTImageFiledata = ^TImageFiledata;
  TImageLibFileList = class
  private
    boPgkMode: boolean;
    pgkfileName: string;
    UnUsedFreeTick: integer;
    FDATA: tlist;
    procedure add(aname: string);
    function get(aname: string): pTImageFiledata;
    procedure Clear;
    procedure add2(aname: string);
  public
    Directory: string;
    constructor Create;
    destructor Destroy; override;
    procedure del(aname: string);
    procedure UpDate(CurTick: integer);
    function GetImageLib(afName: string; CurTick: integer): TA2ImageLib;
    function GetImageLibPP(afName: string; CurTick: integer): pTImageFiledata;
    function GetImageLib_WEAPONPP(afName: string; acol: word; CurTick: integer): pTImageFiledata;
    function GetImageLib_WEAPONGHOSTPP(afName: string; acol: word; CurTick: integer): pTImageFiledata;
  end;

  TAtzClass = class

  private

  public
    AtzList: TImageLibFileList;
    EffectList: TImageLibFileList;
    ItemImageLib: TA2ImageLib;
    //ItemImageLib1000: TA2ImageLib;
    MagicImageLib: TA2ImageLib;
    constructor Create;
    destructor Destroy; override;

    procedure UpDate(CurTick: integer);

    function GetImageLib(afName: string; CurTick: integer): TA2ImageLib;
    function GetImageLib_Eft(afName: string; CurTick: integer): TA2ImageLib;
    function GetItemImage(idx: integer): TA2Image;
    function GetMagicImage(idx: integer): TA2Image;
  end;
  TAnimaterdata = record
    rname: string[64];
    raniList: tlist;
  end;
  pTAnimaterdata = ^TAnimaterdata;
  TAnimater = class //动作 动画 配制表
  private

    fdata: tlist; //pTAnimaterdata
    fnameindex: TStringKeyClass;
    procedure LoadFromFile(aFileName: string; List: TList);
    procedure add(aname: string; alist: tlist);
    procedure Clear();
    function get(aname: string): pTAnimaterdata;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAnimationList(aindex: integer): TList;
  end;

  TEffectPositionData = record
    rname: string[64];
    rArr: array[0..16 - 1 + 2] of integer; // +2 绰 overValue, Speed
  end;
  PTEffectPositionData = ^TEffectPositionData;

  TEffectPositionClass = class
  private

    fdata: TStringKeyListClass;
    procedure Clear;
    procedure add(app: PTEffectPositionData);
    function get(aname: string): PTEffectPositionData;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(aFileName: string);
    function GetPosition(aFileName: string): TEffectPositionData;
  end;

  TEtcAtzClass = class
  private
    munetcAtzLib: TA2ImageLib;
    temp: TA2Image;
  public
    constructor Create;
    destructor Destroy; override;
    function GetEtcAtz(value: integer): TA2Image;
  end;

var
  AtzClass: TAtzClass;
  Animater: TAnimater;
  EffectPositionClass: TEffectPositionClass;
  EtcAtzClass: TEtcAtzClass;
function Enc(Str: string): string; //2015.11.12 在水一方

implementation
uses filepgkclass, ImgList, FBottom;
var
  SearchRec: TSearchRec;

constructor TEffectPositionClass.Create;
begin
  fdata := TStringKeyListClass.Create;
  LoadFromFile('AtzPosXY.sdb');
end;

destructor TEffectPositionClass.Destroy;
begin
  Clear;
  fdata.Free;
  inherited Destroy;
end;

function TEffectPositionClass.get(aname: string): PTEffectPositionData;
begin
  result := fdata.Select(aname);
end;

procedure TEffectPositionClass.add(app: PTEffectPositionData);
var
  pp: PTEffectPositionData;
begin
  new(pp);
  pp^ := app^;
  fdata.Insert(pp.rname, pp);
end;

procedure TEffectPositionClass.Clear;
var
  i: integer;
  p: PTEffectPositionData;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.GetIndex(i); // PTEffectPositionData(StringList.Objects[i]);
    dispose(p);
  end;
  fdata.Clear;
end;

procedure TEffectPositionClass.LoadFromFile(aFileName: string);
var
  i, j: integer;
  iname: string;
  StringDb: TStringDb;
  temp: TEffectPositionData;
  aStream: TMemoryStream;
begin
  if pgksys.isfile(aFileName) then
  begin
    StringDb := TStringDb.Create;
    aStream := TMemoryStream.Create;
    try
      pgksys.get(aFileName, aStream);
      StringDb.LoadFromStream(aStream);
    finally
      aStream.Free;
    end;
  end else
  begin
    if not FileExists(aFileName) then exit;
    StringDb := TStringDb.Create;
    StringDb.LoadFromFile(aFileName);
  end;

  for j := 0 to StringDb.Count - 1 do
  begin
    iname := StringDb.GetIndexName(j);
    if get(iname) <> nil then Continue;
    temp.rname := iname;
    temp.rArr[0] := StringDb.GetFieldValueInteger(iname, 'OverValue');
    temp.rArr[1] := StringDb.GetFieldValueInteger(iname, 'Speed');
    for i := 0 to 8 - 1 do
    begin
      temp.rArr[(i + 1) * 2] := StringDb.GetFieldValueInteger(iname, 'Dir' + IntToStr(i) + 'X'); // overvalue, Speed 锭巩俊 +2
      temp.rArr[(i + 1) * 2 + 1] := StringDb.GetFieldValueInteger(iname, 'Dir' + IntToStr(i) + 'Y');
    end;
    add(@temp);

  end;
  StringDb.Free;
end;

function TEffectPositionClass.GetPosition(aFileName: string): TEffectPositionData;
var
  pp: pTEffectPositionData;
begin
  pp := get(aFileName);
  if pp = nil then
    FillChar(Result, sizeof(Result), 0)
  else
    result := pp^;
end;
////////////////////////////////////////////////////////////////////////////////

constructor TImageLibFileList.Create;
begin
  inherited Create;
  boPgkMode := false;
  pgkfileName := '';
  UnUsedFreeTick := mmAnsTick;
  FDATA := tlist.Create;
end;

destructor TImageLibFileList.Destroy;
begin
  Clear;
  FDATA.Free;
  inherited Destroy;
end;

procedure TImageLibFileList.Clear;
var
  i: integer;
  pp: pTImageFiledata;
begin
  for i := FDATA.Count - 1 downto 0 do
  begin
    pp := FDATA.Items[i];
    pp.rImageLib.Free;
    dispose(pp);
  end;
  fdata.Clear;
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

procedure TImageLibFileList.add(aname: string);
var
  pp: pTImageFiledata;
  aStream: TMemoryStream;

  procedure _add();
  var
    realName: string;
  begin
    if ('.\res\' = Directory) then
      realName := Enc(AnsiUpperCase(aname)) + '.dat'
    else if ('.\eff\' = Directory) then
      realName := Enc(AnsiUpperCase(aname)) + '.eff' else
      realName := aname;
    if not FileExists(Directory + realName) then exit;
    new(pp);
    pp.rname := aname;
    pp.rrunTick := mmAnsTick;
    pp.rImageLib := TA2ImageLib.Create;

    pp.rImageLib.LoadFromFile(Directory + realName);
    FDATA.Add(pp);
  end;

begin
  if boPgkMode = false then
  begin
    _add;
  end
  else
  begin

    if pgkfileName = 'eft' then
    begin
      if not pgkeft.isfile(aname) then
      begin
        _add;
        exit;
      end;
      aStream := TMemoryStream.Create;
      try
        new(pp);
        pp.rname := aname;
        pp.rrunTick := mmAnsTick;
        pp.rImageLib := TA2ImageLib.Create;
        pgkeft.get(aname, aStream);
        aStream.Position := 0;
        pp.rImageLib.LoadFromStream(aStream);
        FDATA.Add(pp);
      finally
        aStream.Free;
      end;
    end
    else if pgkfileName = 'sprite' then
    begin
      if not pgksprite.isfile(aname) then
      begin
        _add;
        exit;
      end;
      aStream := TMemoryStream.Create;
      try

        new(pp);
        pp.rname := aname;
        pp.rrunTick := mmAnsTick;
        pp.rImageLib := TA2ImageLib.Create;
        pgksprite.get(aname, aStream);
        aStream.Position := 0;
        pp.rImageLib.LoadFromStream(aStream);
        FDATA.Add(pp);
      finally
        aStream.Free;
      end;
    end;

  end;

end;

procedure TImageLibFileList.add2(aname: string);
var
  pp: pTImageFiledata;
begin
  new(pp);
  pp.rname := aname;
  pp.rrunTick := mmAnsTick;
  pp.rImageLib := TA2ImageLib.Create;
  FDATA.Add(pp);
end;

function TImageLibFileList.get(aname: string): pTImageFiledata;
var
  i: integer;
  pp: pTImageFiledata;
begin
  result := nil;
  for i := 0 to FDATA.Count - 1 do
  begin
    pp := FDATA.Items[i];
    if pp.rname = aname then
    begin
      result := pp;
      exit;
    end
  end;
end;

procedure TImageLibFileList.del(aname: string);
var
  i: integer;
  pp: pTImageFiledata;
begin
  for i := 0 to FDATA.Count - 1 do
  begin
    pp := FDATA.Items[i];
    if pp.rname = aname then
    begin
      pp.rImageLib.Free;
      dispose(pp);
      fdata.Delete(i);
      exit;
    end
  end;
end;

{function TImageLibFileList.GetImageLib_WEAPONPP(afName: string; acol: word; CurTick: integer): pTImageFiledata;
var
  pp: pTImageFiledata;
  ppw: pTImageFiledata;
  aname_w: string;
  temp: TA2Image;
  i, j, n, imgtimeall, imgtimecreate: integer;
  c1, c2: word;
  tempStream: TMemoryStream;

  r, g, b: word;
  t1: integer;
  procedure _setLevelColor(acol1, alevel: word; var aoutcol: word);
  begin
        //WinVRGB(acol1, r, g, b);
    b := acol1 and $1F;
    g := (acol1 shr 5) and $1F;
    r := (acol1 shr 10) and $1F;
    t1 := r * alevel div 6;
    if t1 <= 0 then t1 := 1;
    t1 := r - t1;
    if t1 <= 0 then t1 := 0;
    r := t1;

    t1 := g * alevel div 6;
    if t1 <= 0 then t1 := 1;
    t1 := g - t1;
    if t1 <= 0 then t1 := 0;
    g := t1;

    t1 := b * alevel div 6;
    if t1 <= 0 then t1 := 1;
    t1 := b - t1;
    if t1 <= 0 then t1 := 0;
    b := t1;
    aoutcol := b + (g shl 5) + (r shl 10); //WinRGB(r, g, b);
  end;


begin
  result := nil;
  aname_w := 'w_' + inttostr(acol) + afName;
  ppw := get(aname_w);
  if ppw <> nil then
  begin
    result := ppw;
    exit;
  end;
  pp := get(afname);
  if pp = nil then exit;
  add2(aname_w);
  ppw := get(aname_w);
  if ppw = nil then exit;
  if pgkeft_W.isfile(aname_w) then
  begin
    tempStream := TMemoryStream.Create;
    try
      pgkeft_W.get(aname_w, tempStream);
      tempStream.Position := 0;
      ppw.rImageLib.LoadFromStream(tempStream);
    finally
      tempStream.Free;
    end;
    result := ppw;
    exit;
  end;
  //FrmBottom.AddChat('缺发光文件，请到官方网站下载。', WinRGB(22, 22, 0), 0);

   // MessageBox(0, PCHAR('缺效果文件，需要生存效果文件。'), '生存效果文件', 1);

  imgtimeall := GetTickCount;
  temp := TA2Image.Create(160, 160, 0, 0);
  tempStream := TMemoryStream.Create;
  try
    for n := 0 to pp.rImageLib.Count - 1 do
    begin
      for j := 3 to 6 do
      begin
        temp.Setsize(160, 160);
        temp.DrawImage(pp.rImageLib.Images[n],
          pp.rImageLib.Images[n].px + 80, pp.rImageLib.Images[n].py + 80, false);

               // temp.delColor(31);
        _setLevelColor(acol, 6 - j, c1);
        temp.strokeCler(21140);
        for i := 1 to j do
        begin
          _setLevelColor(c1, i, c2);
          temp.stroke(c2);
        end;
        temp.delColor(21140);
        temp.Optimize;
               // temp.SaveToFile('c:\' + inttostr(n) + '.bmp');
        ppw.rImageLib.AddImage(temp);

      end;
    end;
    imgtimecreate := GetTickCount - imgtimeall;
        //
    ppw.rImageLib.SaveToStream(tempStream);
    tempStream.Position := 0;
    pgkeft_W.add2(aname_w, tempStream);
        //
    imgtimeall := GetTickCount - imgtimeall;
//        FrmBottom.AddChat('时间：' + inttostr(imgtimeall) + ' 生成时间：' + inttostr(imgtimecreate)
//            + ' 图片数量：' + inttostr(pp.rImageLib.Count * 4)
//            + ' 原始图片：' + inttostr(pp.rImageLib.Count)
//            , WinRGB(22, 22, 0), 0);

  finally
    temp.Free;
    tempStream.Free;
  end;
  result := ppw;

   // FrmBottom.AddChat('缺' + afName + '对应特效文件，生成效果文件快慢由机器速度决定。', WinRGB(22, 22, 0), 0);
   // FrmBottom.AddChat('生成' + afName + '对应特效文件完成。以后不会重复生成。', WinRGB(22, 22, 0), 0);

end;}

function TImageLibFileList.GetImageLib_WEAPONPP(afName: string; acol: word; CurTick: integer): pTImageFiledata;
var
  pp: pTImageFiledata;
  ppw: pTImageFiledata;
  aname_w, afilename_w: string;
  temp, temp2, temp3: TA2Image;
  i, j, n, imgtimeall, imgtimecreate: integer;
  c1, c2, c3, c4: word;
  tempStream: TMemoryStream;
  tempFileStream: TFileStream;

  r, g, b: word;
  t1: integer;
  procedure _setLevelColor(acol1, alevel: word; var aoutcol: word);
  begin
        //WinVRGB(acol1, r, g, b);
    b := acol1 and $1F;
    g := (acol1 shr 5) and $1F;
    r := (acol1 shr 10) and $1F;
    t1 := r * alevel div 6;
    if t1 <= 0 then t1 := 1;
    t1 := r - t1;
    if t1 <= 0 then t1 := 0;
    r := t1;

    t1 := g * alevel div 6;
    if t1 <= 0 then t1 := 1;
    t1 := g - t1;
    if t1 <= 0 then t1 := 0;
    g := t1;

    t1 := b * alevel div 6;
    if t1 <= 0 then t1 := 1;
    t1 := b - t1;
    if t1 <= 0 then t1 := 0;
    b := t1;
    aoutcol := b + (g shl 5) + (r shl 10); //WinRGB(r, g, b);
  end;
  
  procedure _setLevelColor2(acol1, alevel: word; var aoutcol: word);
  begin
        //WinVRGB(acol1, r, g, b);
    b := acol1 and $1F;
    g := (acol1 shr 5) and $1F;
    r := (acol1 shr 10) and $1F;
    t1 := r * alevel div 100;
    if t1 <= 0 then t1 := 0;
    if t1 >= 31 then t1 := 31;
    r := t1;

    t1 := g * alevel div 100;
    if t1 <= 0 then t1 := 0;
    if t1 >= 31 then t1 := 31;
    g := t1;

    t1 := b * alevel div 100;
    if t1 <= 0 then t1 := 0;
    if t1 >= 31 then t1 := 31;
    b := t1;
    aoutcol := b + (g shl 5) + (r shl 10); //WinRGB(r, g, b);
  end;

  function _CheckRgb(Rgb: Integer): Integer;
  asm  
      test    eax, eax  
      jge     @@1  
      xor     eax, eax  
      ret  
  @@1:  
      cmp     eax, 31
      jle     @@2  
      mov     eax, 31
  @@2:  
  end;
      
  procedure _SetBrightContrast(Image: TA2Image; Bright, Contrast, Threshold: Integer);
  var
    vs: array[0..31] of integer;
    cv, bv: Single;
    i, j, v: Integer;
    TempSS: PTAns2Color;
    r, g, b: word;
  begin  
    if (Bright = 0) and (Contrast = 0) then Exit;  
    if Bright <= -31 then bv := -1 else bv := Bright / 31;
    if (Bright > 0) and (Bright < 31) then
      bv := 1 / (1 - bv) - 1;
    if Contrast <= -31 then cv := -1 else cv := Contrast / 31;
    if (Contrast > 0) and (Contrast < 31) then
      cv := 1 / (1 - cv) - 1;  
    for i := 0 to 31 do
    begin  
      if Contrast > 0 then v := _CheckRgb(i + Round(i * bv)) else v := i;
      if Contrast >= 31 then
      begin  
        if v >= Threshold then v := 31 else v := 0;
      end  
      else  
        v := _CheckRgb(v + Round((v - Threshold) * cv));  
      if Contrast <= 0 then vs[i] := _CheckRgb(v + Round(v * bv)) else vs[i] := v;
    end;
    TempSS := Image.Bits;
    with Image do
    for i := 0 to Height - 1 do
    begin
      for j := 0 to Width - 1 do
      begin
        if (TempSS^ <> TransparentColor) and (TempSs^ <> 31) then
        begin
          b := TempSS^ and $1F;
          g := (TempSS^ shr 5) and $1F;
          r := (TempSS^ shr 10) and $1F;
          b := vs[b];
          g := vs[g];
          r := vs[r];
          if b > 31 then b := 31;
          if g > 31 then g := 31;
          if r > 31 then r := 31;
          TempSS^ := b + (g shl 5) + (r shl 10);
        end;
        inc(TempSS);
      end;
    end;
  end; 
      
  procedure _SetBrightContrast2(SrcImage, DesImage: TA2Image);
  var
    i, j, v1, v2, vmax, vmid: Integer;
    TempSS, TempDD: PTAns2Color;
    r, g, b: word;
    r2, g2, b2: word;
  begin
    TempSS := SrcImage.Bits;
    vmax := 0;
    with SrcImage do
    for i := 0 to Height - 1 do
      for j := 0 to Width - 1 do begin
        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;
        v1 := b + g + r;
        if v1 > vmax then
          vmax := v1; 
        inc(TempSS);
      end;
    vmid := vmax * 2 div 3;

    TempSS := SrcImage.Bits;
    TempDD := DesImage.Bits;
    with SrcImage do
    for i := 0 to Height - 1 do
    begin
      for j := 0 to Width - 1 do
      begin
        if (TempSS^ <> TransparentColor) and (TempSs^ <> 31) then
        begin
          b := TempSS^ and $1F;
          g := (TempSS^ shr 5) and $1F;
          r := (TempSS^ shr 10) and $1F;
          v1 := b + g + r;
          //b2 := TempDD^ and $1F;
          //g2 := (TempDD^ shr 5) and $1F;
          //r2 := (TempDD^ shr 10) and $1F;
          //v2 := (b2 + g2 + r2) div 3;
          v2 := (TempDD^ shr 5) and $1F;
//          if v1 < vmid then v1 := -v1;
//          b2 := b2 + (v1 div vmax) * v2;
//          g2 := g2 + (v1 div vmax) * v2;
//          r2 := r2 + (v1 div vmax) * v2; 
          //if v1 < vmid then v1 := 0;
          //b2 := b2 + (v1 * v2 div vmax);
          if v1 < vmid then
            g2 := g2 * 2 div 3 + (v1 * v2 div vmax)
          else
            g2 := g2 * 1 div 3 + (v1 * v2 div vmax);
          //r2 := r2 + (v1 * v2 div vmax);
          //if b2 > 31 then b2 := 31;
          if g2 > 31 then g2 := 31;
          //if r2 > 31 then r2 := 31;
          //TempDD^ := b2 + (g2 shl 5) + (r2 shl 10);
          TempDD^ := (g2 shl 5);
        end;
        inc(TempSS);
        inc(TempDD);
      end;
    end;
  end;
begin
  result := nil;
  acol := $03E0;
  aname_w := 'w_' + inttostr(acol) + afName;
  afilename_w := FpkTempPath + Enc(AnsiUpperCase(aname_w)) + '.dat';
  if not DirectoryExists(FpkTempPath) then CreateDir(FpkTempPath);

  ppw := get(aname_w);
  if ppw <> nil then
  begin
    result := ppw;
    exit;
  end;
  pp := get(afname);
  if pp = nil then exit;
  add2(aname_w);
  ppw := get(aname_w);
  if ppw = nil then exit;
  if pgkeft_W.isfile(aname_w) then
  begin
    tempStream := TMemoryStream.Create;
    try
      pgkeft_W.get(aname_w, tempStream);
      tempStream.Position := 0;
      ppw.rImageLib.LoadFromStream(tempStream);
    finally
      tempStream.Free;
    end;
    result := ppw;
    exit;
  end;
  //FrmBottom.AddChat('缺发光文件，请到官方网站下载。', WinRGB(22, 22, 0), 0);

   // MessageBox(0, PCHAR('缺效果文件，需要生存效果文件。'), '生存效果文件', 1);

    imgtimeall := GetTickCount;
    temp := TA2Image.Create(160, 160, 0, 0);
//    temp2 := TA2Image.Create(1, 1, 0, 0);
    temp3 := TA2Image.Create(1, 1, 0, 0);
    tempStream := TMemoryStream.Create;
    try
      if not FileExists(afilename_w) or _test_test_mode then begin
        for n := 0 to pp.rImageLib.Count - 1 do
        begin
            //for j := 3 to 6 do
            for j := 0 to 3 do
            begin
                temp.Setsize(160, 160);
                temp.DrawImage(pp.rImageLib.Images[n],
                    pp.rImageLib.Images[n].px + 80, pp.rImageLib.Images[n].py + 80, false);
//                pp.rImageLib.Images[n].CopyImage(temp2);
//                if _test_Bright_Enable then
//                  _SetBrightContrast(temp2,31 * _test_CenterColor_Bright[j] div 100,31 * _test_CenterColor_Contrast[j] div 100,16);
                pp.rImageLib.Images[n].CopyImage(temp3);
                temp3.strokeCler(21140);
                _setLevelColor2(acol, _test_range_color_par[j], c1);
                for i := 10 downto 1 do
                begin
                  _setLevelColor2(c1, i*10, c2);
                  temp3.stroke_inner(c2, 21140);
                end;
                _setLevelColor2(acol, _test_range_color_par[j], c1);
                temp.strokeCler(21140);
                for i := _test_range_width_par[j] downto 1 do
                begin
                  _setLevelColor2(c1, i*100 div _test_range_width_par[j], c2);
                  _setLevelColor2(c2, _test_OuterColor_Par, c4);
                  temp.stroke(c4);
                end;
                temp.delColor(21140);
//                if _test_Bright_Enable then
//                  _SetBrightContrast2(temp2,temp3);
                if _test_LightInner_Enable then
                  temp.DrawImageOveray(temp3, temp3.px + 80, temp3.py + 80, 100 - _test_range_color_par[j]);
                temp.Optimize;
                ppw.rImageLib.AddImage(temp);

            end;
        end;
        imgtimecreate := GetTickCount - imgtimeall;
        //
        ppw.rImageLib.SaveToStream(tempStream);
        ppw.rImageLib.SaveToFile(afilename_w);
        imgtimeall := GetTickCount - imgtimeall;
        FrmBottom.AddChat('时间：' + inttostr(imgtimeall) + ' 生成时间：' + inttostr(imgtimecreate)
            + ' 图片数量：' + inttostr(pp.rImageLib.Count * 4)
            + ' 原始图片：' + inttostr(pp.rImageLib.Count)
            , WinRGB(22, 22, 0), 0);

        FrmBottom.AddChat('缺' + afName + '对应特效文件，生成效果文件快慢由机器速度决定。', WinRGB(22, 22, 0), 0);
        FrmBottom.AddChat('生成' + afName + '对应特效文件完成。以后不会重复生成。', WinRGB(22, 22, 0), 0);
      end
      else
      begin
	    tempStream.LoadFromFile(afilename_w);
        tempStream.Position := 0;
        ppw.rImageLib.LoadFromStream(tempStream);
		
      //  tempFileStream := TFileStream.Create(afilename_w, fmOpenRead or fmShareDenyWrite);
      //  ppw.rImageLib.LoadFromStream(tempFileStream);
      //  tempFileStream.Free;
      end;

        tempStream.Position := 0;
        pgkeft_W.add2(aname_w, tempStream);
       //  pgkeft_W.saveToFile;
      //  pgkeft_W.saveAsToFile(pgkeft_W.);
        //

    finally
        temp.Free;
//        temp2.Free;
        temp3.Free;
        tempStream.Free;
    end;
    result := ppw;
   
end; 

function TImageLibFileList.GetImageLib_WEAPONGHOSTPP(afName: string; acol: word; CurTick: integer): pTImageFiledata;
var
  pp: pTImageFiledata;
  ppw: pTImageFiledata;
  aname_w, afilename_w: string;
  temp, temp2, temp3: TA2Image;
  i, j, n, imgtimeall, imgtimecreate: integer;
  c1, c2, c3, c4: word;
  tempStream: TMemoryStream;
  tempFileStream: TFileStream;

  r, g, b: word;
  t1: integer;

  function _CheckRgb(Rgb: Integer): Integer;
  asm  
      test    eax, eax  
      jge     @@1  
      xor     eax, eax  
      ret  
  @@1:  
      cmp     eax, 31
      jle     @@2  
      mov     eax, 31
  @@2:  
  end;
      
  procedure _SetBrightContrast(Image: TA2Image; Bright, Contrast, Threshold: Integer);
  var
    vs: array[0..31] of integer;
    cv, bv: Single;
    i, j, v: Integer;
    TempSS: PTAns2Color;
    r, g, b: word;
  begin  
    if (Bright = 0) and (Contrast = 0) then Exit;  
    if Bright <= -31 then bv := -1 else bv := Bright / 31;
    if (Bright > 0) and (Bright < 31) then
      bv := 1 / (1 - bv) - 1;
    if Contrast <= -31 then cv := -1 else cv := Contrast / 31;
    if (Contrast > 0) and (Contrast < 31) then
      cv := 1 / (1 - cv) - 1;  
    for i := 0 to 31 do
    begin
      if Contrast > 0 then v := _CheckRgb(i + Round(i * bv)) else v := i;
      if Contrast >= 31 then
      begin  
        if v >= Threshold then v := 31 else v := 0;
      end  
      else  
        v := _CheckRgb(v + Round((v - Threshold) * cv));  
      if Contrast <= 0 then vs[i] := _CheckRgb(v + Round(v * bv)) else vs[i] := v;
    end;
    TempSS := Image.Bits;
    with Image do
    for i := 0 to Height - 1 do
    begin
      for j := 0 to Width - 1 do
      begin
        if (TempSS^ <> TransparentColor) and (TempSs^ <> 31) then
        begin
          b := TempSS^ and $1F;
          g := (TempSS^ shr 5) and $1F;
          r := (TempSS^ shr 10) and $1F;
          b := vs[b];
          g := vs[g];
          r := vs[r];
          if b > 31 then b := 31;
          if g > 31 then g := 31;
          if r > 31 then r := 31;
          TempSS^ := b + (g shl 5) + (r shl 10);
        end;
        inc(TempSS);
      end;
    end;
  end; 
      
  procedure _SetBrightContrast2(Image: TA2Image);
  var
    i, j, v1, vmax, vmid: Integer;
    TempSS: PTAns2Color;
    r, g, b: word;
    r2, g2, b2: word;
  begin
    TempSS := Image.Bits;
    vmax := 0;
    with Image do
    for i := 0 to Height - 1 do
      for j := 0 to Width - 1 do begin
        b := TempSS^ and $1F;
        g := (TempSS^ shr 5) and $1F;
        r := (TempSS^ shr 10) and $1F;
        v1 := b + g + r;
        if v1 > vmax then
          vmax := v1; 
        inc(TempSS);
      end;
    vmid := vmax * 2 div 3;

    TempSS := Image.Bits;
    with Image do
    for i := 0 to Height - 1 do
    begin
      for j := 0 to Width - 1 do
      begin
        if (TempSS^ <> TransparentColor) then
        begin
          b := TempSS^ and $1F;
          g := (TempSS^ shr 5) and $1F;
          r := (TempSS^ shr 10) and $1F;
          v1 := b + g + r;
          //v2 := (TempDD^ shr 5) and $1F;
          if v1 < vmid then
            g2 := (v1 * v1 div vmax)
          else
            g2 := (v1 * v1 div vmax div 2);
          if g2 > 31 then g2 := 31;
          TempSS^ := (g2 shl 5);
        end;
        inc(TempSS);
      end;
    end;
  end;
begin
  result := nil;
  acol := $03E0;
  aname_w := 'g_' + inttostr(acol) + afName;
  afilename_w := FpkTempPath + Enc(AnsiUpperCase(aname_w)) + '.dat';
  if not DirectoryExists(FpkTempPath) then CreateDir(FpkTempPath);

  ppw := get(aname_w);
  if ppw <> nil then
  begin
    result := ppw;
    exit;
  end;

  pp := get(afname);
  if pp = nil then exit;
  add2(aname_w);
  ppw := get(aname_w);
  if ppw = nil then exit;
  if pgkeft_W.isfile(aname_w) then
  begin
    tempStream := TMemoryStream.Create;
    try
      pgkeft_W.get(aname_w, tempStream);
      tempStream.Position := 0;
      //'w_31w1850.atz' 2731316
      ppw.rImageLib.LoadFromStream(tempStream);
    finally
      tempStream.Free;
    end;
    result := ppw;
    exit;
  end;

    imgtimeall := GetTickCount;
    temp := TA2Image.Create(160, 160, 0, 0);
    temp2 := TA2Image.Create(1, 1, 0, 0);
    tempStream := TMemoryStream.Create;
    try
      if not FileExists(afilename_w) or _test_test_mode then begin
        for n := 0 to pp.rImageLib.Count - 1 do
        begin
            //for j := 3 to 6 do
            for j := 0 to 3 do
            begin
                temp.Setsize(160, 160);
                temp.Clear(0);
                pp.rImageLib.Images[n].CopyImage(temp2);
                _SetBrightContrast(temp2,31 * _test_CenterColor_Bright[j] div 100,31 * _test_CenterColor_Contrast[j] div 100,16);
                _SetBrightContrast2(temp2);
                temp.DrawImageOveray(temp2, temp2.px + 80, temp2.py + 80, 100 - _test_range_color_par[j]);
                temp.Optimize;
                ppw.rImageLib.AddImage(temp);

            end;
        end;
        imgtimecreate := GetTickCount - imgtimeall;
        //
        ppw.rImageLib.SaveToStream(tempStream);
        ppw.rImageLib.SaveToFile(afilename_w);
        imgtimeall := GetTickCount - imgtimeall;
        FrmBottom.AddChat('时间：' + inttostr(imgtimeall) + ' 生成时间：' + inttostr(imgtimecreate)
            + ' 图片数量：' + inttostr(pp.rImageLib.Count * 4)
            + ' 原始图片：' + inttostr(pp.rImageLib.Count)
            , WinRGB(22, 22, 0), 0);

        FrmBottom.AddChat('缺' + afName + '对应特效文件，生成效果文件快慢由机器速度决定。', WinRGB(22, 22, 0), 0);
        FrmBottom.AddChat('生成' + afName + '对应特效文件完成。以后不会重复生成。', WinRGB(22, 22, 0), 0);
      end
      else
      begin
	    tempStream.LoadFromFile(afilename_w);
        tempStream.Position := 0;
        ppw.rImageLib.LoadFromStream(tempStream);
		
        //tempFileStream := TFileStream.Create(afilename_w, fmOpenRead or fmShareDenyWrite);
        //ppw.rImageLib.LoadFromStream(tempFileStream);
        //tempFileStream.Free;
      end;

        tempStream.Position := 0;
        pgkeft_W.add2(aname_w, tempStream);
       //  pgkeft_W.saveToFile;
      //  pgkeft_W.saveAsToFile(pgkeft_W.);
        //

    finally
        temp.Free;
        temp2.Free;
        tempStream.Free;
    end;
    result := ppw;
   
end;


function TImageLibFileList.GetImageLibPP(afName: string; CurTick: integer): pTImageFiledata;
var
  pp: pTImageFiledata;
begin
  result := nil;
  pp := get(afname);
  if pp = nil then
  begin
    add(afname);
    pp := get(afname);
    if pp = nil then exit;
  end;
  pp.rrunTick := CurTick;
  result := pp;
end;

function TImageLibFileList.GetImageLib(afName: string; CurTick: integer): TA2ImageLib;
var
  pp: pTImageFiledata;
begin
  result := nil;
  pp := get(afname);
  if pp = nil then
  begin
    add(afname);
    pp := get(afname);
    if pp = nil then exit;
  end;
  pp.rrunTick := CurTick;
  result := pp.rImageLib;
end;

procedure TImageLibFileList.UpDate(CurTick: integer);
var
  i: integer;
  pp: pTImageFiledata;
begin
    //定期 清理 垃圾 资源
  if CurTick > UnUsedFreeTick + UnUsedFreeTickDelay then
  begin
    UnUsedFreeTick := CurTick;
    for i := fdata.Count - 1 downto 0 do
    begin
      pp := fdata.Items[i];
      if CurTick > pp.rrunTick + UnUsedFreeTickAtzLibDelay then
      begin
        pp.rImageLib.Free;
        dispose(pp);
        fdata.Delete(i);
      end;
    end;
  end;
end;
////////////////////////////////////////////////////////////////////////////////
//                         TAtzClass                                          //
////////////////////////////////////////////////////////////////////////////////




constructor TAtzClass.Create;
var
  aStream: TMemoryStream;
  ImageList1: TImageList;
begin
    //

  AtzList := TImageLibFileList.Create;
  AtzList.Directory := '.\res\';
  AtzList.pgkfileName := 'sprite';
  AtzList.boPgkMode := true;
  EffectList := TImageLibFileList.Create;
  EffectList.Directory := '.\eff\';

  EffectList.pgkfileName := 'eft';
  EffectList.boPgkMode := true;

  aStream := TMemoryStream.Create;
  try
    ItemImageLib := TA2ImageLib.Create;
        //ItemImageLib.LoadFromFile('item.atz');
    pgksys.get('item.atz', aStream);
    aStream.Position := 0;
    ItemImageLib.LoadFromStream(aStream);

//    ItemImageLib1000 := TA2ImageLib.Create;
//    pgkbmp.get('item1000.bmp', aStream);
//    aStream.Position := 0;
//    ItemImageLib1000.LoadFromStreamFenge(aStream);

    MagicImageLib := TA2ImageLib.Create;
        //MagicImageLib.LoadFromFile('magic.atz');
    pgksys.get('magic.atz', aStream);
    aStream.Position := 0;
    MagicImageLib.LoadFromStream(aStream);
  finally
    aStream.Free;
  end;



end;

destructor TAtzClass.Destroy;
begin
  //ItemImageLib1000.Free;
  EffectList.Free;
  AtzList.Free;
  MagicImageLib.Free;
  ItemImageLib.Free;

  inherited Destroy;
end;

function TAtzClass.GetItemImage(idx: integer): TA2Image;
begin
  Result := nil;
//  if idx >= 1000 then
//  begin
//    idx := idx - 1000;
//    if (idx < 0) or (idx >= ItemImageLib1000.Count) then exit;
//    Result := ItemImageLib1000[idx];
//    exit;
//  end;
  if (idx < 0) or (idx >= ItemImageLib.Count) then exit;
  Result := ItemImageLib[idx];
end;

function TAtzClass.GetMagicImage(idx: integer): TA2Image;
begin
  Result := nil;
  if (idx < 0) or (idx >= MagicImageLib.Count) then exit;
  Result := MagicImageLib[idx];
end;

function TAtzClass.GetImageLib_Eft(afName: string; CurTick: integer): TA2ImageLib;
begin
  result := EffectList.GetImageLib(afName, CurTick);
end;

function TAtzClass.GetImageLib(afName: string; CurTick: integer): TA2ImageLib;
begin
  result := AtzList.GetImageLib(afName, CurTick);
end;

procedure TAtzClass.UpDate(CurTick: integer);
begin
  AtzList.UpDate(CurTick);
  EffectList.UpDate(CurTick);
end;

/////////////////////////////////
//          TAnimater          //
/////////////////////////////////

procedure TAnimater.add(aname: string; alist: tlist);
var
  pp: pTAnimaterdata;
begin
  new(pp);
  pp.rname := copy(aname, 1, 64);
  pp.raniList := alist;
  fdata.Add(pp);
  fnameindex.Insert(pp.rname, pp)
end;

constructor TAnimater.Create;
var
  i: integer;
  List: TList;
  fname: string;
begin

  fnameindex := TStringKeyClass.Create;
  fdata := TList.Create;
  for i := 0 to 200 do
  begin
    fname := IntToStr(i) + '.atd';
    if pgksys.isfile(fname) = false then
      Continue;
    List := TList.Create;
    add(fname, (List));
    LoadFromFile(fname, List);

  end;
end;

function TAnimater.get(aname: string): pTAnimaterdata;

begin
  result := fnameindex.Select(aname);

end;

procedure TAnimater.Clear();
var
  i, j: Integer;
  pp: pTAnimaterdata;
  pa: PTAniInfo;
begin
  for j := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[j];
    for i := 0 to pp.raniList.Count - 1 do
    begin
      pa := pp.raniList.Items[i];
      dispose(pa);
    end;
    pp.raniList.Free;
    dispose(pp);
  end;
  fdata.Clear;
  fnameindex.Clear;
end;

destructor TAnimater.Destroy;
begin

  Clear;
  fdata.free;
  fnameindex.Free;
  inherited Destroy;
end;

function TAnimater.GetAnimationList(aindex: integer): TList;
var
  i: integer;
  fname: string;
  pp: pTAnimaterdata;
begin
  fname := IntToStr(aindex) + '.atd';
  pp := get(fname);
  if pp = nil then
  begin
    pp := fdata.Items[0];
    Result := pp.raniList;
  end else
  begin
    result := pp.raniList;
  end;
end;

procedure TAnimater.LoadFromFile(aFileName: string; List: TList);
var
  i, j: integer;
  str: string;
  C: char;
  StringDb: TStringDb;
  pa: PTAniInfo;
  aStream: TMemoryStream;
begin
  StringDb := TStringDb.Create;
  try
        // StringDb.LoadFromFileCode(aFileName);
    aStream := TMemoryStream.Create;
    try

      pgksys.get(aFileName, aStream);
      aStream.Position := 0;
      StringDb.LoadFromStreamCode(aStream);
    finally
      aStream.Free;
    end;

    for j := 1 to 1000 do
    begin
      str := StringDb.GetFieldValueString(IntToStr(j), 'Name');
      if str = '' then break;
      new(pa);
      List.Add(pa);
      with pa^ do
      begin
        str := StringDb.GetFieldValueString(IntToStr(j), 'Action');
        Action := -1;
        if CompareText(str, 'TURN') = 0 then Action := AM_TURN;
        if CompareText(str, 'TURN1') = 0 then Action := AM_TURN1;
        if CompareText(str, 'TURN2') = 0 then Action := AM_TURN2;
        if CompareText(str, 'TURN3') = 0 then Action := AM_TURN3;
        if CompareText(str, 'TURN4') = 0 then Action := AM_TURN4;

        if CompareText(str, 'TURNNING') = 0 then Action := AM_TURNNING;
        if CompareText(str, 'TURNNING1') = 0 then Action := AM_TURNNING1;
        if CompareText(str, 'TURNNING2') = 0 then Action := AM_TURNNING2;
        if CompareText(str, 'TURNNING3') = 0 then Action := AM_TURNNING3;
        if CompareText(str, 'TURNNING4') = 0 then Action := AM_TURNNING4;

        if CompareText(str, 'MOVE') = 0 then Action := AM_MOVE;
        if CompareText(str, 'MOVE1') = 0 then Action := AM_MOVE1;
        if CompareText(str, 'MOVE2') = 0 then Action := AM_MOVE2;
        if CompareText(str, 'MOVE3') = 0 then Action := AM_MOVE3;
        if CompareText(str, 'MOVE4') = 0 then Action := AM_MOVE4;

        if CompareText(str, 'HIT') = 0 then Action := AM_HIT;
        if CompareText(str, 'HIT1') = 0 then Action := AM_HIT1;
        if CompareText(str, 'HIT2') = 0 then Action := AM_HIT2;
        if CompareText(str, 'HIT3') = 0 then Action := AM_HIT3;
        if CompareText(str, 'HIT4') = 0 then Action := AM_HIT4;
        if CompareText(str, 'HIT5') = 0 then Action := AM_HIT5;
        if CompareText(str, 'HIT6') = 0 then Action := AM_HIT6;
        if CompareText(str, 'DIE') = 0 then Action := AM_DIE;
        if CompareText(str, 'STRUCTED') = 0 then Action := AM_STRUCTED;

        if CompareText(str, 'SEATDOWN') = 0 then Action := AM_SEATDOWN;
        if CompareText(str, 'STANDUP') = 0 then Action := AM_STANDUP;
        if CompareText(str, 'HELLO') = 0 then Action := AM_HELLO;

        if CompareText(str, 'TURN5') = 0 then Action := AM_TURN5;
        if CompareText(str, 'TURN6') = 0 then Action := AM_TURN6;
        if CompareText(str, 'TURN7') = 0 then Action := AM_TURN7;
        if CompareText(str, 'TURN8') = 0 then Action := AM_TURN8;
        if CompareText(str, 'TURN9') = 0 then Action := AM_TURN9;

        if CompareText(str, 'TURNNING5') = 0 then Action := AM_TURNNING5;
        if CompareText(str, 'TURNNING6') = 0 then Action := AM_TURNNING6;
        if CompareText(str, 'TURNNING7') = 0 then Action := AM_TURNNING7;
        if CompareText(str, 'TURNNING8') = 0 then Action := AM_TURNNING8;
        if CompareText(str, 'TURNNING9') = 0 then Action := AM_TURNNING9;

        if CompareText(str, 'MOVE5') = 0 then Action := AM_MOVE5;
        if CompareText(str, 'MOVE6') = 0 then Action := AM_MOVE6;
        if CompareText(str, 'MOVE7') = 0 then Action := AM_MOVE7;
        if CompareText(str, 'MOVE8') = 0 then Action := AM_MOVE8;
        if CompareText(str, 'MOVE9') = 0 then Action := AM_MOVE9;

        if CompareText(str, 'HIT7') = 0 then Action := AM_HIT7;
        if CompareText(str, 'HIT8') = 0 then Action := AM_HIT8;
        if CompareText(str, 'HIT9') = 0 then Action := AM_HIT9;
                { // 眠啊且巴
                         if CompareText (str, 'TURN10') = 0 then Action := AM_TURN10;
                         if CompareText (str, 'TURN11') = 0 then Action := AM_TURN11;
                         if CompareText (str, 'TURN12') = 0 then Action := AM_TURN12;
                         if CompareText (str, 'TURN13') = 0 then Action := AM_TURN13;
                         if CompareText (str, 'TURN14') = 0 then Action := AM_TURN14;
                         if CompareText (str, 'TURN15') = 0 then Action := AM_TURN15;
                         if CompareText (str, 'TURN16') = 0 then Action := AM_TURN16;
                         if CompareText (str, 'TURN17') = 0 then Action := AM_TURN17;
                         if CompareText (str, 'TURN18') = 0 then Action := AM_TURN18;
                         if CompareText (str, 'TURN19') = 0 then Action := AM_TURN19;
                         if CompareText (str, 'TURNNING10') = 0 then Action := AM_TURNNING10;
                         if CompareText (str, 'TURNNING11') = 0 then Action := AM_TURNNING11;
                         if CompareText (str, 'TURNNING12') = 0 then Action := AM_TURNNING12;
                         if CompareText (str, 'TURNNING13') = 0 then Action := AM_TURNNING13;
                         if CompareText (str, 'TURNNING14') = 0 then Action := AM_TURNNING14;
                         if CompareText (str, 'TURNNING15') = 0 then Action := AM_TURNNING15;
                         if CompareText (str, 'TURNNING16') = 0 then Action := AM_TURNNING16;
                         if CompareText (str, 'TURNNING17') = 0 then Action := AM_TURNNING17;
                         if CompareText (str, 'TURNNING18') = 0 then Action := AM_TURNNING18;
                         if CompareText (str, 'TURNNING19') = 0 then Action := AM_TURNNING19;
                         if CompareText (str, 'MOVE10') = 0 then Action := AM_MOVE10;
                         if CompareText (str, 'MOVE11') = 0 then Action := AM_MOVE11;
                         if CompareText (str, 'MOVE12') = 0 then Action := AM_MOVE12;
                         if CompareText (str, 'MOVE13') = 0 then Action := AM_MOVE13;
                         if CompareText (str, 'MOVE14') = 0 then Action := AM_MOVE14;
                         if CompareText (str, 'MOVE15') = 0 then Action := AM_MOVE15;
                         if CompareText (str, 'MOVE16') = 0 then Action := AM_MOVE16;
                         if CompareText (str, 'MOVE17') = 0 then Action := AM_MOVE17;
                         if CompareText (str, 'MOVE18') = 0 then Action := AM_MOVE18;
                         if CompareText (str, 'MOVE19') = 0 then Action := AM_MOVE19;
                         if CompareText (str, 'HIT10') = 0  then Action := AM_HIT10;
                         if CompareText (str, 'HIT11') = 0  then Action := AM_HIT11;
                         if CompareText (str, 'HIT12') = 0  then Action := AM_HIT12;
                         if CompareText (str, 'HIT13') = 0  then Action := AM_HIT13;
                         if CompareText (str, 'HIT14') = 0  then Action := AM_HIT14;
                         if CompareText (str, 'HIT15') = 0  then Action := AM_HIT15;
                         if CompareText (str, 'HIT16') = 0  then Action := AM_HIT16;
                         if CompareText (str, 'HIT17') = 0  then Action := AM_HIT17;
                         if CompareText (str, 'HIT18') = 0  then Action := AM_HIT18;
                         if CompareText (str, 'HIT19') = 0  then Action := AM_HIT19;
                }

        if Action = -1 then continue;

        str := StringDb.GetFieldValueString(IntToStr(j), 'Direction');
        if CompareText(str, 'DR_0') = 0 then Direction := DR_0;
        if CompareText(str, 'DR_1') = 0 then Direction := DR_1;
        if CompareText(str, 'DR_2') = 0 then Direction := DR_2;
        if CompareText(str, 'DR_3') = 0 then Direction := DR_3;
        if CompareText(str, 'DR_4') = 0 then Direction := DR_4;
        if CompareText(str, 'DR_5') = 0 then Direction := DR_5;
        if CompareText(str, 'DR_6') = 0 then Direction := DR_6;
        if CompareText(str, 'DR_7') = 0 then Direction := DR_7;

        Frame := StringDb.GetFieldValueInteger(IntToStr(j), 'Frame');
        FrameTime := StringDb.GetFieldValueInteger(IntToStr(j), 'FrameTime');
        c := 'A';
        for i := 0 to Frame - 1 do
        begin
          str := format('%sF', [c]);
          Frames[i] := StringDb.GetFieldValueInteger(IntToStr(j), str);

          str := format('%spx', [c]);
          Pxs[i] := StringDb.GetFieldValueInteger(IntToStr(j), str);

          str := format('%spy', [c]);
          Pys[i] := StringDb.GetFieldValueInteger(IntToStr(j), str);

          inc(c);
        end;
      end;

    end;
  finally
    StringDb.Free;
  end;

end;

////////////////////////////////////////////////////////////////////////////////
//                        TEtcAtzClass
////////////////////////////////////////////////////////////////////////////////

constructor TEtcAtzClass.Create;

begin
  temp := TA2Image.Create(32, 32, 0, 0);
  temp.Clear(0);
  munetcAtzLib := TA2ImageLib.Create;
  if pgkect.isfile('munetc.Atz') = false then exit;
    // munetcAtzLib.LoadFromFile('.\ect\munetc.Atz');
  pgkect.getImageLib('munetc.Atz', munetcAtzLib);
end;

destructor TEtcAtzClass.Destroy;
begin
  temp.Free;
  munetcAtzLib.Free;
end;

function TEtcAtzClass.GetEtcAtz(value: integer): TA2Image;
begin
  Result := temp;
  if (value < 0) and (value > munetcAtzLib.Count - 1) then exit;
  if munetcAtzLib.Images[value] <> nil then
    Result := munetcAtzLib.Images[value];
end;

end.

