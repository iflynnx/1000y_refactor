unit uPersonBat;

interface

uses
  A2Img, BackScrn, Controls, AUtil32, SysUtils, Deftype, Graphics, uAnsTick, classes, CharCls, Atzcls;

type

  TRollMsg = class
    FMSGSHOW: Boolean;
    FmsgRoll: boolean;                  //动画 滑动   TRUE 出现有动画效果  FALSE直接出现
    FmsgRolltime: integer;              //动画 时间
    FMSGText: string;
    FTextColor: word;
    FMSGDelay: integer;
    FRowTick: integer;                  //上次换行 时间
    Fleft, Ftop: integer;
    FWidth, FHeight: INTEGER;
    FBack: TA2Image;
    FBgEffect: TBgEffect;
    FBgEffectShape: Integer;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw(aFBack: TA2Image; aTick: integer);
    procedure UPDATE(aTick: integer);
    procedure add(astr: string; acolor: word; ashape: Integer = 0);

  end;

  TRollMsgFrom = class
    Fdatalist: tlist;
    Fmaxcount: integer;
    FRowRunTime: integer;
    Fleft, Ftop: integer;
    FHeight: integer;
    FBack: TA2Image;
    FMSGDelay: integer;
  public
    constructor Create(arowNum, aWidth, aHeight: INTEGER);
    destructor Destroy; override;
    procedure UPDATE(aTick: integer);
    procedure rowUP(aTick: integer);
    procedure Draw(aTick: integer);

    procedure add(astr: string; acolor: word; ashape: Integer = 0);
    function IS_End(): boolean;
    procedure del(aTick: integer);
    procedure Clear();
  end;
  TBatMsg = class
  private
    Fdata: Tlist;
        //  BatMsgText:string;
    FDelay: integer;
    BatMsgTextColor: word;
    Ftype: byte;
    FShowBatMsg: boolean;
    fWidth, fHeight: integer;
    Ftextlist: tstringlist;
  protected
    procedure formattext(s: string);
  public
    FTA2Image1, FTA2Image2: TA2Image;
    constructor Create(aFTA2Image1, aFTA2Image2: TA2Image);
    destructor Destroy; override;
    procedure ADD(p: PTSShowCenterMsg);
    procedure Clear();
    procedure del(id: integer);
    function GetIndex(aIndex: integer): PTSShowCenterMsg;
    procedure DrawBatMessage(x, y: integer);
    procedure AdxPaint(atick: integer);
    procedure update(CurTick: integer);
  end;

  TSelChar = class
  private
    FBack: TA2Image;                    //缓冲区
    FHeadPortrait: TA2Image;            //物体 头像
    FNameText: string;                  //物体 名字
    FNameTextColor: word;               //物体 名字 颜色
    FText: string;                      //物体 描述
    FTextColor: word;                   //物体 描述 颜色
    Ftype: byte;                        //物体 类型
    FShow: boolean;                     //是否 显示
    FX, FY: INTEGER;                    //显示 坐标
    FW, FH: integer;
    FStructedPercent: integer;          //血条%
    Fid: integer;                       //物体ID
  protected

  public

    constructor Create();
    destructor Destroy; override;

    procedure DrawItem();
    procedure AdxPaint(CurTick: integer);
    procedure update(CurTick: integer);
    function IsMouse(x, y: integer): boolean;
    procedure SelId(id: integer);
    procedure UPStructedPercent(aid, aStructedPercent: integer);
    procedure UPCHANGEFEATURE(aid: integer);
    procedure DrawWearHeadPortrait(id: integer);
    function MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer): boolean;
    function MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;
    function MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;
  end;

  TPersonBat = class                    //呐喊

  private
    PersonBatLib: TA2ImageLib;
    FWinType: Byte;
    RightID, LeftID: string;
    RightWinCount, LeftWinCount: byte;
    RightBarImg, LeftBarImg: TA2Image;
    RightIDEnergy, LeftIDEnergy: byte;
    FShowBar: Boolean;

    FShowRollMSG: Boolean;
    FRollMSGStringList: TStringList;
    RollMSGText: string;
    RollMSGTextColor: word;
    RollMSGDelay: integer;
    FShowMagicMSG: Boolean;
    FMagicMSGStringList: TStringList;
    MagicMSGText: string;
    MagicMSGTextColor: word;
    MagicMSGDelay: integer;
    MagicMSGtime: integer;

        //        FShowBatMsg:Boolean;
    BatMsg: tBatMsg;
    LeftRollMsgFrom: TRollMsgFrom;      //提示
    LeftRollMsgFrom2: TRollMsgFrom;     //提示
    LeftRollMsgFrom3: TRollMsgFrom;     //提示
    LeftRollMsgFrom4: TRollMsgFrom;     //喇叭专用提示
  public
        //        SelChar:TSelChar;
    RelivesendDiedTick, ReliveDiedTick, ReliveReliveTime: integer;
    constructor Create;
    destructor Destroy; override;
    procedure update(atick: integer);
    procedure AdxPaint(atick: integer);
    procedure LeftMsgListadd(astr: string; acolor: word; ashape: Integer = 0);
    procedure LeftMsgListadd2(astr: string; acolor: word; ashape: Integer = 0);
    procedure LeftMsgListadd3(astr: string; acolor: word; ashape: Integer = 0);
    procedure LeftMsgListadd4(astr: string; acolor: word; ashape: Integer = 0);


    procedure Relive(aTick: integer);   //复活 提示控制

    procedure DrawRollMSG(CurTick: integer); 
    procedure DrawMagicMSG(CurTick: integer);
    procedure DrawBarTop;

    procedure SetID(aRightID, aLeftID: string);
    procedure SetEnergy(aRightIDEnergy, aLeftIDEnergy: integer);

    procedure MessageProcess(var code: TWordComData);
    procedure RollMSGadd(atext: string; acolor: word);
    procedure MagicMSGadd(atext: string; acolor: word);
    property ShowBar: Boolean read FShowBar write FShowBar;
    property ShowRollMSG: Boolean read FShowRollMSG write FShowRollMSG;
    property ShowMagicMSG: Boolean read FShowMagicMSG write FShowMagicMSG;
    function MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer): boolean;
    function MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;
    function MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;

  end;

var
  PersonBat: TPersonBat;
implementation
uses filepgkclass, FMain, FAttrib, FBottom;
{O+}

procedure DrawStructed(x, y, aper, aHeight: integer; aBack: TA2Image);
var
  i: integer;
begin
  for i := 0 to 4 do
  begin
    aback.hLine(x, y + i, aHeight, WinRGB(5, 5, 5));
    aback.hLine(x, y + i, trunc((aHeight * aper) / 100), WinRGB(22, 5, 5));
  end;

    {
     aback.hLine(x, y + 1, aHeight, WinRGB(5, 5, 5));

     aback.hLine(x, y + 1, aHeight, WinRGB(5, 5, 5));

     aback.hLine(x, y + 1, aper div 5, WinRGB(22, 5, 5));
     aback.hLine(x, y + 1, aper div 5, WinRGB(22, 5, 5));}
end;

procedure TSelChar.UPStructedPercent(aid, aStructedPercent: integer);
begin
  if FID = AID then
  begin
    FStructedPercent := aStructedPercent;
    DrawItem;
  end;
end;

procedure TSelChar.UPCHANGEFEATURE(aid: integer);
begin
  if FID = AID then
  begin
    SelId(aID);
  end;
end;

procedure TSelChar.SelId(id: integer);
begin
  Fid := id;
  DrawWearHeadPortrait(id);
end;

procedure TSelChar.DrawWearHeadPortrait(id: integer);
var
  Cl: TCharClass;
begin
  Cl := CharList.CharGet(id);
  if Cl = nil then
  begin
    FShow := false;
    exit;
  end else
  begin
    cl.DrawWearHeadPortrait(FHeadPortrait);

    FShow := true;
    FNameText := Cl.rName;
    FStructedPercent := cl.Structed;
    if cl.Feature.rfeaturestate = wfs_die then
      FStructedPercent := 0
    else
      if FStructedPercent <= 0 then
        FStructedPercent := 100;
    DrawItem;
  end;
end;

constructor TSelChar.Create();
begin
  inherited Create;
  fw := 90;
  fh := 20;
  FBack := TA2Image.Create(fw, fh, 0, 0);
  FHeadPortrait := TA2Image.Create(20, 20, 0, 0); //物体 头像
  FHeadPortrait.Clear(5);
  FNameText := '';                      //物体 名字
  FNameTextColor := WinRGB(31, 31, 31); //物体 名字 颜色
  FText := '';                          //物体 描述
  FTextColor := WinRGB(31, 31, 31);     //物体 描述 颜色
  Ftype := 0;                           //物体 类型
  FShow := false;                       //是否 显示
  FX := 1;
  FY := 50;                             //显示 坐标
end;

destructor TSelChar.Destroy;
begin
  FBack.Free;
  FHeadPortrait.Free;
  inherited destroy;
end;

procedure TSelChar.AdxPaint(CurTick: integer);
begin
  if FShow = true then
    BackScreen.Back.DrawImage(FBack, fx, fy, true);
end;

procedure TSelChar.update(CurTick: integer);
begin

end;

function TSelChar.IsMouse(x, y: integer): boolean;
begin
  Result := false;
  if (x > fx) and (x < (fx + fw))
    and (y > FY) and (y < (fy + fh)) then
    result := true;
end;

function TSelChar.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer): boolean;
begin
  result := IsMouse(x, y);
  if not result then exit;

end;

function TSelChar.MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;
begin
  result := IsMouse(x, y);
  if not result then exit;

end;

function TSelChar.MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;
begin
  result := IsMouse(x, y);
  if not result then exit;

end;

procedure TSelChar.DrawItem;
var
  i: integer;
begin

  FBack.Clear(0);                       //ColorSysToDxColor(clNavy));

    //人 头
  FBack.DrawImage(FHeadPortrait, 0, 0, true);
    //名字
    {i := ATextWidth(FNameText);
    i := (FBack.Width - FHeadPortrait.Width);
    i := i + FHeadPortrait.Width;
    }
  i := FHeadPortrait.Width + 2;
  ATextOut(FBack, i, 5, FNameTextColor, FNameText);
    //血条
  DrawStructed(i, 1, FStructedPercent, FBack.Width - FHeadPortrait.Width - 4, FBack);

end;

procedure TBatMsg.AdxPaint(atick: integer);
var
  x, y: integer;
  maxWidth,
    maxHeight: integer;
begin

  if fShowBatMsg then
  begin
    case Ftype of
      SHOWCENTERMSG_BatMsg:
        begin
          maxWidth := FrmM.ClientWidth;
          if FrmAttrib.Visible then maxWidth := maxWidth - FrmAttrib.Width;
          maxHeight := FrmM.ClientHeight;
          if FrmBottom.Visible then maxHeight := maxHeight - FrmBottom.Height;
          x := (maxWidth - (fWidth)) div 2;
          y := (maxHeight - (fHeight)) div 2;

          DrawBatMessage(x, y);
        end;
      SHOWCENTERMSG_BatMsgtop: DrawBatMessage(0, 0);
    end;

  end;
end;

procedure TBatMsg.formattext(s: string);
var
  str, rdstr, str1, str2, str3: string;
begin
  Ftextlist.Clear;
  s := GetValidStr3(s, str1, ',');
  str3 := GetValidStr3(s, str2, ',');

  if (str3 = '') and (str2 = '') then
  begin
    str := CutLengthString(str1, fWidth - 8);
    if str <> '' then Ftextlist.Add(str);
    str := CutLengthString(str1, fWidth - 8);
    if str <> '' then Ftextlist.Add(str);
    str := CutLengthString(str1, fWidth - 8);
    if str <> '' then Ftextlist.Add(str);
  end else
  begin
    if str1 <> '' then Ftextlist.Add(str1);
    if str2 <> '' then Ftextlist.Add(str2);
    if str3 <> '' then Ftextlist.Add(str3);
  end;
end;

procedure TBatMsg.update(CurTick: integer);
var
  str, rdstr: string;
  n: integer;
  temp: PTSShowCenterMsg;
begin                                   // 茄臂 20磊 Total 40磊
  if FDelay + 300 < mmAnsTick then
  begin
    temp := GetIndex(0);
    if temp <> nil then
    begin
      str := GetWordString(temp.rText);
      formattext(str);
      BatMsgTextColor := temp.rColor;
      Ftype := temp.rtype;
      FDelay := CurTick;
      del(0);
    end
    else
    begin
      FShowBatMsg := FALSE;
    end;
  end;
end;

procedure TBatMsg.DrawBatMessage(x, y: integer);
var
  s: string;
  n, i: integer;
begin                                   // 茄臂 20磊 Total 40磊

  BackScreen.Back.DrawImageKeyColor(FTA2Image1, x, y, 31, @Darkentbl); //PersonBatLib.Images[8]
  BackScreen.Back.DrawImageKeyColor(FTA2Image2, FTA2Image1.Width + x - 2, y + 2, 31, @Darkentbl); //PersonBatLib.Images[9]

  if Ftextlist.Count = 1 then
  begin
    s := Ftextlist.Text;
    x := x + (fWidth - ATextWidth(s)) div 2;
    y := y + (fHeight - ATextHeight(s)) div 2;
    ATextOut(BackScreen.Back, x, y, BatMsgTextColor,
            //WinRGB(31, 31, 31)
      s);
    exit;
  end;
  n := Ftextlist.Count;
  if n <= 0 then exit;
  if n > 3 then n := 3;
  n := ATextHeight('你') * n;
  y := y + (fHeight - n) div 2;

  for i := 0 to Ftextlist.Count - 1 do
  begin
    if i >= 3 then exit;
    s := Ftextlist.Strings[i];
    ATextOut(BackScreen.Back, x + 10, y, BatMsgTextColor,
            //WinRGB(31, 31, 31)
      s);
    y := y + ATextHeight(s) + 2;
  end;

end;

procedure TBatMsg.del(id: integer);
var
  temp: PTSShowCenterMsg;
begin
  if (id < 0) or (id >= Fdata.Count) then exit;
  temp := Fdata.Items[id];
  Fdata.Delete(id);
  dispose(temp);

end;

procedure TBatMsg.Clear();
var
  i: integer;
  temp: PTSShowCenterMsg;
begin
  for i := 0 to Fdata.Count - 1 do
  begin
    temp := Fdata.Items[i];
    dispose(temp);
  end;
  Fdata.Clear;
end;

procedure TBatMsg.ADD(p: PTSShowCenterMsg);
var
  temp: PTSShowCenterMsg;
begin
  new(temp);
  temp^ := p^;
  Fdata.Add(temp);
  FShowBatMsg := true;
end;

constructor TBatMsg.Create(aFTA2Image1, aFTA2Image2: TA2Image);
begin

  FDelay := 0;
  BatMsgTextColor := 0;
  FShowBatMsg := false;

  FTA2Image1 := aFTA2Image1;
  FTA2Image2 := aFTA2Image2;
  fWidth := FTA2Image1.Width + FTA2Image2.Width;
  fHeight := FTA2Image1.Height;
  Fdata := tlist.Create;
  Ftextlist := tstringlist.Create;
end;

destructor TBatMsg.Destroy;
begin
  Clear;
  Fdata.Free;
  Ftextlist.Free;
end;

function TBatMsg.GetIndex(aIndex: integer): PTSShowCenterMsg;
begin
  result := nil;
  if (aIndex < 0) or (aIndex >= Fdata.Count) then exit;
  result := Fdata.Items[aIndex];

end;
//------------------------------------------------------------------------------

function TRollMsgFrom.IS_End(): boolean; //测试 最后1个位置是否为空
var
  t: TRollMsg;
begin
  result := false;
  if Fdatalist.Count <= 0 then exit;
  t := Fdatalist.Items[Fdatalist.Count - 1];
  result := t.Ftop = FBack.Height - FHeight;

end;

procedure TRollMsgFrom.add(astr: string; acolor: word; ashape: Integer);
var
  t: TRollMsg;
  str: string;
begin
  if astr = '' then exit;
  if ashape = 0 then begin
    t := TRollMsg.Create;
    t.add(astr, acolor, ashape);
    t.Fleft := 0;
    t.Ftop := FBack.Height - FHeight;

      //全部 换行
    if IS_End then
      rowUP(mmAnsTick);
    Fdatalist.Add(t);
  end
  else
  while astr <> '' do
  begin
    t := TRollMsg.Create;
    astr := GetValidStr3(astr, str, #13);
    t.add(str, acolor, ashape);
    t.Fleft := 0;
    t.Ftop := FBack.Height - FHeight;

      //全部 换行
    if IS_End then
      rowUP(mmAnsTick);
    Fdatalist.Add(t);
  end;
end;

procedure TRollMsgFrom.Clear();
var
  i: integer;
begin
  for i := 0 to Fdatalist.Count - 1 do TRollMsg(Fdatalist.Items[i]).Free;
  Fdatalist.Clear;
end;

procedure TRollMsgFrom.del(aTick: integer);
var
  t: TRollMsg;
  i: integer;
begin
  if Fdatalist.Count <= 0 then exit;
  while (Fdatalist.Count > 0) do
  begin
    t := (Fdatalist.Items[0]);
    if t.Ftop < 0 then
    begin
      t.Free;
      Fdatalist.Delete(0);
    end else Break;
  end;

end;

procedure TRollMsgFrom.rowUP(aTick: integer);
var
  i: integer;
  t: TRollMsg;
begin
    //换行
  //  if (aTick - FMSGDelay) > FRowRunTime then

  FMSGDelay := atick;
  if Fdatalist.Count > 0 then
  begin

    for i := 0 to Fdatalist.Count - 1 do
    begin
      t := Fdatalist.Items[i];
      t.Ftop := t.Ftop - (FHeight);
      t.FmsgRoll := false;
    end;
  end;
end;

procedure TRollMsgFrom.UPDATE(aTick: integer);
var
  i: integer;
  t: TRollMsg;
  hy: boolean;
begin
    //换行
  if (aTick - FMSGDelay) > FRowRunTime then rowUP(aTick);
  del(aTick);
  FBack.Clear(0);
  for i := 0 to Fdatalist.Count - 1 do
  begin
    t := Fdatalist.Items[i];
    t.UPDATE(aTick);
    t.Draw(FBack, aTick);
  end;

end;

procedure TRollMsgFrom.Draw(aTick: integer); 
var
  i,ax,ay: integer;
  t: TRollMsg;
begin
  for i := 0 to Fdatalist.Count - 1 do
  begin
    t := Fdatalist.Items[i];
    t.Draw(FBack, aTick);
    if t.FBgEffectShape > 0 then begin
      if not t.FBgEffect.Used then
        t.FBgEffect.Initialize(0, 0, t.FBgEffectShape, lek_follow, false);
      if (t.FBgEffect <> nil) and (t.FBgEffect.BgEffectImagePP <> nil) then begin
        ax := t.Fleft+Fleft + t.FBgEffect.BgEffectImagePP.px;
        ay := t.Ftop+Ftop + t.FBgEffect.BgEffectImagePP.py;
        BackScreen.Back.DrawImageAdd(t.FBgEffect.BgEffectImagePP, ax, ay);
      end;
    end;
  end;
  BackScreen.Back.DrawImage(FBack, Fleft, Ftop, true);
end;

constructor TRollMsgFrom.Create(arowNum, aWidth, aHeight: INTEGER);
begin
  Fdatalist := tlist.Create;
  Fmaxcount := arowNum;
  FRowRunTime := 100 * 3;
  FHeight := aHeight;
  FBack := TA2Image.Create(aWidth, (FHeight) * Fmaxcount, 0, 0);

end;

destructor TRollMsgFrom.Destroy;
begin
  Clear;
  Fdatalist.Free;
  FBack.Free;
  inherited destroy;

end;
////

procedure TRollMsg.add(astr: string; acolor: word; ashape: Integer);
begin
  if astr = '' then exit;
  FMSGSHOW := true;
  FmsgRoll := true;
  FMSGText := astr;
  FTextColor := acolor;
  FMSGDelay := mmAnsTick;
  Fleft := 0;
  Ftop := 0;
  FWidth := ATextWidth(astr);
  FHeight := ATextHeight(astr);

  FBack.Setsize(FWidth, FHeight);
  FBack.Clear(0);
  ATextOut(FBACK, 0, 0, FTextColor, FMSGText);
  FBgEffectShape := ashape;
  if FBgEffectShape > 0 then
    FBgEffect.Initialize(0, 0, FBgEffectShape, lek_follow, false);
end;

procedure TRollMsg.UPDATE(aTick: integer);
var
  fy: integer;
begin

  if FmsgRoll then if (aTick - FMSGDelay) > FmsgRolltime then FmsgRoll := false;
  if FmsgRoll then
  begin                                 //出现 过程 ，比如 从下往上出来
        //计算 位置
    fy := trunc(FHeight * ((FmsgRolltime - (aTick - FMSGDelay)) / FmsgRolltime));
    FBack.Clear(0);
    ATextOut(FBACK, 0 + 1, fy + 1, WinRGB(3, 3, 3), FMSGText);
    ATextOut(FBACK, 0, fy, FTextColor, FMSGText);
  end
  else
  begin
    FBack.Clear(0);
    ATextOut(FBACK, 0 + 1, 0 + 1, WinRGB(3, 3, 3), FMSGText);
    ATextOut(FBACK, 0, 0, FTextColor, FMSGText);
  end;
  if FBgEffectShape > 0 then
    FBgEffect.Update(aTick);

end;

procedure TRollMsg.Draw(aFBack: TA2Image; aTick: integer);
begin
  if not Assigned(FBack) then EXIT;
    //  UPDATE(aTick);
  aFBack.DrawImage(FBack, Fleft, Ftop, true);
end;

constructor TRollMsg.Create;
begin
  FMSGSHOW := false;
  FMSGText := '';
  FTextColor := ColorSysToDxColor($FFFFFF);
  FMSGDelay := 0;
  FmsgRolltime := 100 * 1;              //1秒
  FBack := TA2Image.Create(32, 32, 0, 0);
  FBgEffectShape := 0;
  FBgEffect := TBgEffect.Create(AtzClass);
end;

destructor TRollMsg.Destroy;
begin
  FBack.Free;
  FBgEffect.Free;
  inherited destroy;
end;

procedure TPersonBat.LeftMsgListadd(astr: string; acolor: word; ashape: Integer);
begin
  LeftRollMsgFrom.add(astr, acolor, ashape);
end;

procedure TPersonBat.LeftMsgListadd2(astr: string; acolor: word; ashape: Integer);
begin
  LeftRollMsgFrom2.add(astr, acolor, ashape);
end;

procedure TPersonBat.LeftMsgListadd3(astr: string; acolor: word; ashape: Integer);
begin
  LeftRollMsgFrom3.add(astr, acolor, ashape);
end;          

procedure TPersonBat.LeftMsgListadd4(astr: string; acolor: word; ashape: Integer);
begin
  LeftRollMsgFrom4.add(astr, acolor, ashape);
end;

procedure TPersonBat.update(atick: integer);
begin
  Relive(atick);
  LeftRollMsgFrom.UPDATE(atick);
  LeftRollMsgFrom2.UPDATE(atick);
  LeftRollMsgFrom3.UPDATE(atick);
  LeftRollMsgFrom4.UPDATE(atick);
  BatMsg.update(atick);
    //    SelChar.update(atick);
end;

procedure TPersonBat.AdxPaint(atick: integer);
begin
  LeftRollMsgFrom.Draw(atick);
  LeftRollMsgFrom2.Draw(atick);
  LeftRollMsgFrom3.Draw(atick);  
  LeftRollMsgFrom4.Draw(atick);
  if PersonBat.ShowRollMSG then PersonBat.DrawRollMSG(atick);
  if PersonBat.ShowMagicMSG then PersonBat.DrawMagicMSG(atick);
  if PersonBat.ShowBar then PersonBat.DrawBarTop;
  BatMsg.AdxPaint(atick);
    //    SelChar.AdxPaint(atick);
end;

function calculation4(xMax, xValue, yMax, yValue, aResult: integer): integer;
begin
  Result := 0;
  case aResult of
    1: Result := (xValue * yMax) div yValue;
    2: Result := (xMax * yValue) div yMax;
    3: Result := (xMax * yValue) div xValue;
    4: Result := (xValue * yMax) div xMax;
  end;
end;

procedure MakeBarImage(aBarImage, SourImage: TA2Image; BarPersent, directionType: byte);
var
  i, n: integer;
  dd, ss, tempSS, Tempbit, TT: PTAns2Color;
  ibp: integer;
begin
  ibp := calculation4(aBarImage.Width, 0, 100, BarPersent, 2);
  if ibp > aBarImage.Width then ibp := aBarImage.Width;
  dd := SourImage.Bits;
  ss := aBarImage.Bits;

  GetMem(Tempbit, sizeof(TAns2Color) * SourImage.Height);
  TT := Tempbit;
  for i := 0 to SourImage.Height - 1 do
  begin
    move(dd^, TT^, SizeOf(TAns2Color));
    inc(dd, SourImage.Width);
    inc(TT);
  end;
  case directionType of
    0:
      begin
        TT := Tempbit;
        for i := 0 to SourImage.Height - 1 do
        begin
          tempSS := ss;
          for n := 0 to ibp - 1 do
          begin
            TempSS^ := TT^;
            inc(TempSS);
          end;
          inc(ss, aBarImage.Width);
          inc(TT);
        end;
      end;
    1:
      begin
        TT := Tempbit;
        for i := 0 to SourImage.Height - 1 do
        begin
          tempSS := ss;
          inc(tempss, aBarImage.Width);
          for n := ibp - 1 downto 0 do
          begin
            dec(TempSS);
            TempSS^ := TT^;
          end;
          inc(ss, aBarImage.Width);
          inc(TT);
        end;
      end;
  end;
  FreeMem(Tempbit);
end;

function TPersonBat.MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer): boolean;
begin
  result := false;
    //    result := SelChar.MouseMove(Sender, Shift, X, Y);
end;

function TPersonBat.MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;
begin
  result := false;
    //    result := SelChar.MouseDown(Sender, Button, Shift, X, Y);
end;

function TPersonBat.MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer): boolean;
begin
  result := false;
    //    result := SelChar.MouseUp(Sender, Button, Shift, X, Y);
end;

procedure TPersonBat.RollMSGadd(atext: string; acolor: word);
begin
  if FShowRollMSG then
    FRollMSGStringList.AddObject(atext, TObject((acolor)))
  else
  begin
    RollMSGTextColor := (acolor);
    RollMSGText := atext;
    RollMSGDelay := mmAnsTick;
  end;
  FShowRollMSG := TRUE;
end;

procedure TPersonBat.MagicMSGadd(atext: string; acolor: word);
begin
  if FShowMagicMSG then
    FMagicMSGStringList.AddObject(atext, TObject((acolor)))
  else
  begin
    MagicMSGTextColor := (acolor);
    MagicMSGText := atext;
    MagicMSGDelay := mmAnsTick;
    MagicMSGtime := 50;
  end;
  FShowMagicMSG := TRUE;
end;

procedure TPersonBat.MessageProcess(var code: TWordComData);
var
  PTTSShowBattleBar: PTSShowBattleBar;
  PTTSShowCenterMsg: PTSShowCenterMsg;
  PTTSShowCenterMsgEx: PTSShowCenterMsgEx;
  pckey: PTCKey;
  id, i: integer;
  str: string;
begin
  pckey := @Code.data;
  case pckey^.rmsg of
    SM_SelChar:
      begin
        i := 1;
        id := WordComData_GETdword(code, i);
                //                SelChar.SelId(id);
      end;
    SM_ReliveTime:
      begin
        pckey := @Code.data;
        ReliveDiedTick := mmAnsTick;    //GetItemLineTimeSec
        ReliveReliveTime := pckey.rkey;
      end;
    SM_SHOWBATTLEBAR:
      begin
        PTTSShowBattleBar := @Code.data;
        with PTTSShowBattleBar^ do
        begin
          FWinType := rWinType;
          LeftID := rLeftName;
          LeftWinCount := rLeftWin;
          LeftIDEnergy := rLeftPercent;
          RightID := rRightName;
          RightWinCount := rRightWin;
          RightIDEnergy := rRightPercent;
        end;
        FShowBar := TRUE;
      end;
    SM_SHOWCENTERMSG:
      begin
        PTTSShowCenterMsg := @Code.data;
        case PTTSShowCenterMsg.rtype of
          SHOWCENTERMSG_BatMsg, SHOWCENTERMSG_BatMsgTOP:
            begin
              batmsg.ADD(PTTSShowCenterMsg);
            end;

          SHOWCENTERMSG_RollMSG:
            begin
              RollMSGadd(GetwordString(PTTSShowCenterMsg.rText), (PTTSShowCenterMsg.rColor));
            end;

          SHOWCENTERMSG_MagicMSG:
            begin
              PTTSShowCenterMsgEx := PTSShowCenterMsgEx(PTTSShowCenterMsg);
              str := GetwordString(PTTSShowCenterMsgEx.rText);
              for i := 0 to PTTSShowCenterMsgEx.rColorCount - 1 do
                MagicMSGadd(str, PTTSShowCenterMsgEx.rColors[i]);
            end;
        end;

        BatMsg.add(PTTSShowCenterMsg);
      end;

  end;
end;

constructor TPersonBat.Create;
begin
  PersonBatLib := TA2ImageLib.Create;
    // PersonBatLib.LoadFromFile('.\ect\persw.Atz');
  pgkect.getImageLib('persw.atz', PersonBatLib);

  RightBarImg := TA2Image.Create(140, 8, 0, 0);
  LeftBarImg := TA2Image.Create(140, 8, 0, 0);
    //    SelChar := TSelChar.Create;

  RightIDEnergy := 100;
  LeftIDEnergy := 100;
  RightID := '';
  LeftID := '';
  RightWinCount := 0;
  LeftWinCount := 0;
  FShowBar := FALSE;
    // FShowBatMsg := FALSE;

     //   BatMsgFontColor := 0;
    // BatMsgText := '';

  FRollMSGStringList := TStringList.Create;
  FMagicMSGStringList := TStringList.Create;

  if WinVerType = wvtOld then
  begin
    LeftRollMsgFrom := TRollMsgfrom.Create(4, 360, 16);

    LeftRollMsgFrom.Fleft := 20;
    LeftRollMsgFrom.Ftop := 169;

    LeftRollMsgFrom2 := TRollMsgfrom.Create(4, 360, 16);

    LeftRollMsgFrom2.Fleft := 20;
    LeftRollMsgFrom2.Ftop := 352;       // - (16 * 3 + 16);

    LeftRollMsgFrom3 := TRollMsgfrom.Create(4, 360, 16);

    LeftRollMsgFrom3.Fleft := 20;
    LeftRollMsgFrom3.Ftop := 412;       // - (16 * 3 + 16);

    LeftRollMsgFrom4 := TRollMsgfrom.Create(4, 720, 16);

    LeftRollMsgFrom4.Fleft := 50;
    LeftRollMsgFrom4.Ftop := 60;       // - (16 * 3 + 16);
  end else if WinVerType = wvtNew then
  begin
    LeftRollMsgFrom := TRollMsgfrom.Create(4, 360, 16);

    LeftRollMsgFrom.Fleft := 20;
    LeftRollMsgFrom.Ftop := 139;

    LeftRollMsgFrom2 := TRollMsgfrom.Create(4, 720, 32);

    LeftRollMsgFrom2.Fleft := 20;
    LeftRollMsgFrom2.Ftop := 322;       // - (16 * 3 + 16);

    LeftRollMsgFrom3 := TRollMsgfrom.Create(4, 360, 16);

    LeftRollMsgFrom3.Fleft := 20;
    LeftRollMsgFrom3.Ftop := 382;       // - (16 * 3 + 16);      

    LeftRollMsgFrom4 := TRollMsgfrom.Create(4, 720, 16);

    LeftRollMsgFrom4.Fleft := 50;
    LeftRollMsgFrom4.Ftop := 30;       // - (16 * 3 + 16);
  end;

  BatMsg := tBatMsg.Create(PersonBatLib.Images[8], PersonBatLib.Images[9]);
end;

destructor TPersonBat.Destroy;
begin
  inherited destroy;
  FRollMSGStringList.Free;
  FMagicMSGStringList.Free;
  RightBarImg.Free;
  LeftBarImg.Free;
  PersonBatLib.Free;
    //    SelChar.Free;
  LeftRollMsgFrom.Free;
  LeftRollMsgFrom2.Free;
  LeftRollMsgFrom3.Free;    
  LeftRollMsgFrom4.Free;
  BatMsg.Free;
end;

procedure TPersonBat.SetID(aRightID, aLeftID: string);
begin
  RightID := aRightID;
  LeftID := aLeftID;
end;

procedure TPersonBat.SetEnergy(aRightIDEnergy, aLeftIDEnergy: integer);
begin
  RightIDEnergy := aRightIDEnergy;
  LeftIDEnergy := aLeftIDEnergy;
end;

procedure TPersonBat.Relive(aTick: integer);
var
  i: integer;
begin
  if (aTick < ReliveDiedTick + ReliveReliveTime) then
  begin

    i := (ReliveDiedTick + ReliveReliveTime) - aTick;
    i := GetItemLineTimeSec(i);
    if i > 5 then
    begin

      if (aTick > RelivesendDiedTick + 500) then
      begin
        LeftMsgListadd(format('剩下%d秒重新站立', [i]), WinRGB(22, 22, 0));
        RelivesendDiedTick := aTick;
      end;

    end
    else if i < 5 then
    begin

      if (aTick > RelivesendDiedTick + 100) then
      begin
        LeftMsgListadd(format('剩下%d秒重新站立', [i]), WinRGB(22, 22, 0));
        RelivesendDiedTick := aTick;
      end;
    end;

  end;
end;
const
  EnergybarLeftstartPos = 20;
  EnergybarRightstartPos = 250;

procedure TPersonBat.DrawBarTop;
var
  i, Leftw, Rightw: integer;
begin
  BackScreen.Back.DrawImage(PersonBatLib.Images[4], 218, 14, TRUE);
    // Left
  LeftBarImg.Clear(0);
  MakeBarImage(LeftBarImg, PersonBatLib.Images[5], LeftIDEnergy, 0);
  BackScreen.Back.DrawImage(LeftBarImg, EnergybarLeftstartPos + 51, 10 + 14, TRUE);
  BackScreen.Back.DrawImage(PersonBatLib.Images[0], EnergybarLeftstartPos, 10, TRUE);
  BackScreen.Back.DrawImage(PersonBatLib.Images[1], EnergybarLeftstartPos + PersonBatLib.Images[0].Width - 2 - 4, 23, TRUE);
    //
  Leftw := LeftWinCount;
  for i := 0 to FWinType - 1 do
  begin
    if Leftw <= i then BackScreen.Back.DrawImage(PersonBatLib.Images[6], 160 + 32 - (i * 16), 35, TRUE)
    else BackScreen.Back.DrawImage(PersonBatLib.Images[7], 160 + 32 - (i * 16), 35, TRUE);
  end;
  i := ATextWidth(LeftID);
  ATextOut(BackScreen.Back, 212 - i, 6, WinRGB(31, 31, 31), LeftID);

    // Right
  RightBarImg.Clear(0);
  MakeBarImage(RightBarImg, PersonBatLib.Images[5], RightIDEnergy, 1);
  BackScreen.Back.DrawImage(RightBarImg, EnergybarRightstartPos, 10 + 14, TRUE);

  BackScreen.Back.DrawImage(PersonBatLib.Images[2], EnergybarRightstartPos, 23, TRUE);
  BackScreen.Back.DrawImage(PersonBatLib.Images[3], EnergybarRightstartPos + PersonBatLib.Images[2].Width - 2 - 4, 10, TRUE);

  Rightw := RightWinCount;
  for i := 0 to FWinType - 1 do
  begin
    if Rightw <= i then BackScreen.Back.DrawImage(PersonBatLib.Images[6], 6 + EnergybarRightstartPos + (i * 16), 35, TRUE)
    else BackScreen.Back.DrawImage(PersonBatLib.Images[7], 6 + EnergybarRightstartPos + (i * 16), 35, TRUE);
  end;
  ATextOut(BackScreen.Back, EnergybarRightstartPos, 6, WinRGB(31, 31, 31), RightID);
end;

procedure TPersonBat.DrawRollMSG(CurTick: integer);
var
  x, y, fx, rtime, maxw: integer;
begin
  rtime := 2000;
  if RollMSGDelay + rtime < mmAnsTick then
  begin
    if FRollMSGStringList.Count > 0 then
    begin
      RollMSGText := FRollMSGStringList[0];
      RollMSGDelay := CurTick;
      RollMSGTextColor := integer(FRollMSGStringList.Objects[0]);
      FRollMSGStringList.Delete(0);

    end else FShowRollMSG := FALSE;
  end;
  if ShowBar then y := 50
  else y := 10;
  x := 30;
  maxw := (BackScreen.SWidth - x * 2) + ATextWidth(RollMSGText);
  fx := (BackScreen.SWidth - x * 2) - trunc(((mmAnsTick - RollMSGDelay) / rtime) * maxw);

  BackScreen.DrawRollMsg(x, y, fx, RollMSGTextColor, RollMSGText);

end;

procedure TPersonBat.DrawMagicMSG(CurTick: integer);
var
  x, y, fx: integer;
begin
  if FMagicMSGStringList.Count > 0 then
  begin
    if MagicMSGDelay + MagicMSGtime < mmAnsTick then
    begin
      MagicMSGText := FMagicMSGStringList[0];
      MagicMSGDelay := CurTick;
      MagicMSGTextColor := integer(FMagicMSGStringList.Objects[0]);
      FMagicMSGStringList.Delete(0);

    end;
    if ShowBar then y := 40
    else y := 0;
    y := BackScreen.SHeight div 2 + y;
    fx := 10;
    x := (BackScreen.SWidth - ATextWidth(MagicMSGText)) div 2;
    BackScreen.DrawRollMsg(x-fx, y, fx, MagicMSGTextColor, MagicMSGText);
  end
  else FShowMagicMSG := FALSE;

end;

end.

