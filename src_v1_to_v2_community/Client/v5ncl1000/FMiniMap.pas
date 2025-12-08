unit FMiniMap;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, uAnsTick,
  StdCtrls, A2Form, CharCls, clmap, A2Img, DXDraws, Autil32, ProClass, Deftype,
  ExtCtrls, cAIPath;

type
  TFrmMiniMap = class(TForm)
    A2Form: TA2Form;
    CenterIDLabel: TA2ILabel;
    A2ILabel1: TA2ILabel;
    TimerAutoPathMove: TTimer;
    A2ILabel_b: TA2ILabel;
    TimerMove: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ILabel1Click(Sender: TObject);
    procedure TimerAutoPathMoveTimer(Sender: TObject);
    procedure A2ILabel_bMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel_bMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TimerMoveTimer(Sender: TObject);
  private
    FPath: TPath;
    FMoveIndex: Integer;
    FTmpPath: TPath;
    FTmpIndex: Integer;
    FEndX, FEndY: Integer;
    function OutMapFile(filename: string): boolean;
    procedure Clear;
  public
    SetFuserTicknum: integer;
    ttTA2Image: TA2Image;
        //  pathTA2Image:TA2Image;
    CenterImage: TA2Image;
    fNpc: TTA2ILabelList;
    fGate: TTA2ILabelList;
    fUser: TTA2ILabelList;
    mapw, maph: integer;

        // fONE:TTA2ILabelList;
    AIPathgx, AIPathgy: integer;
    procedure SetCenterID;
    procedure SetFuser;
    procedure SetPostion;
    procedure MessageProcess(var code: TWordComData);
    procedure GETnpcList(abo: Boolean = False);
    procedure StopAutoMOVE();
    procedure RunAutoMOVE();
    procedure AIPathcalc_paoshishasbi(gx, gy: integer);
    function showmap(filename: string): boolean;
  end;

var
  FrmMiniMap: TFrmMiniMap;
  MapImgWidth //  = 460;
    , MapImgHeight: integer; //  = 345;

const
  //XorKey: array[0..10] of Byte = ($A1, $B7, $AC, $57, $1C, $63, $3B, $81, $57, $1C, $63); //字符串加密用 old
  XorKey: array[0..10] of Byte = ($A2, $B8, $AC, $68, $2C, $74, $4B, $92, $68, $2C, $64); //字符串加密用

implementation

uses
  FMain, FAttrib, FBottom, FQuantity, Fbl //, cMAPGDI
   // ,ActiveX,
  , filepgkclass, FGameToolsNew;
{$R *.DFM}

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

procedure TFrmMiniMap.GETnpcList(abo: Boolean);
var
  TT: TGET_cmd;
  cnt: integer;
  s: string;
  tmp: string;
begin
  s := ExtractFileName(Map.GetMapName);

  if pos('.', s) > 0 then
    s := copy(s, 1, pos('.', s) - 1);
  tmp := dec(s);
  if pos('.', tmp) > 0 then
    tmp := copy(tmp, 1, pos('.', tmp) - 1);
  if showmap(format('%s.bmp', [tmp])) = false then
  begin
    Visible := false;
    exit;
  end;
  if abo then
    exit;

  fNpc.ItemClear;
  fGate.ItemClear;
  fUser.ItemClear;
  TT.rmsg := CM_GET;
  TT.rKEY := GET_MapObject;
  cnt := sizeof(tt);
  Frmfbl.SocketAddData(cnt, @tt);
end;

procedure TFrmMiniMap.MessageProcess(var code: TWordComData);
var
  pckey: PTckey;
  i, x, y: integer;
  str, rdstr: string;
  pSMapobject: pTSMapObject;
  s: string;
  psNewMap: PTSNewMap;
begin
  pckey := @code.data;
  case pckey^.rmsg of
    SM_NEWMAP:
      begin
        psNewMap := @Code.data;
        A2ILabel1.Caption := (psNewMap.rMapTitle);

        mapw := Map.GetMapWidth;
        maph := Map.GetMapHeight;
      end;
    SM_MapObject:
      begin
        pSMapobject := @Code.data;
        x := trunc(MapImgWidth * (pSMapobject.rx / mapw));
        //y := trunc(MapImgHeight * (pSMapobject.ry / maph));
        //2015年10月14日 14:14:23修改测试小地图标点Y坐标按照w坐标比例修正
        y := trunc(MapImgWidth * (pSMapobject.ry / maph) * 0.75);
        str := GetwordString(pSMapobject^.rWordstring);
        if str <> '' then
        begin
          case pSMapobject.rtype of
            MapobjectNpc:
              fNpc.ItemAdd(x, y, pSMapobject.rx, pSMapobject.ry, 4, 4, '', 'NPC：' + str);
            MapobjectGate:
              fGate.ItemAdd(x, y, pSMapobject.rx, pSMapobject.ry, 4, 4, '', '传送：' + str);
            MapobjectUserProcession:
              fUser.ItemAdd(x, y, pSMapobject.rx, pSMapobject.ry, 4, 4, '', '队友：' + str);
                    //  MapobjectONE:fONE.ItemAdd(pSMapobject.rx, pSMapobject.ry, 4, 4, '', str);
          else
            exit;
          end;
        end;
        CenterIdLabel.A2SendToBack;
      end;
  end;

end;

procedure TFrmMiniMap.FormCreate(Sender: TObject);
begin
  FrmM.AddA2Form(Self, A2Form);
    //Parent := FrmM;
  Top := 0;
  Left := 0;
  SetFuserTicknum := 0;
  CenterImage := TA2Image.Create(4, 4, 0, 0);
  CenterImage.Clear(255);
  CenterIdLabel.A2Image := CenterImage;

  fNpc := TTA2ILabelList.Create(A2Form, self, clred);
  fGate := TTA2ILabelList.Create(A2Form, self, $0AB10A);
  fUser := TTA2ILabelList.Create(A2Form, self, clNavy);
    //fONE := TTA2ILabelList.Create(A2Form, self, clLime);
    //SearchIDLabel.Font.Color := (clOlive);
    //SearchIDLabel.Caption := '';
  A2ILabel1.Font.Color := (clOlive);
  A2ILabel1.Caption := '';

  TimerMove.Enabled := true;
end;

{
function TFrmMiniMap.showmap_file(filename: string): boolean;
var
    tt: TA2Image;
    zoom, fw, fh: integer;
    Mapmini: tmapmini;
    TBitmap1: TBitmap;
    ttStream: TMemoryStream;
begin
    result := false;
    // A2Form.ImageSurface := nil;
    if ttTA2Image <> nil then
    begin
        ttTA2Image.Free;
        ttTA2Image := nil;
    end;

    if not FileExists(filename) then
    begin
        Mapmini := tMapmini.Create;
        try
            Mapmini.MapLoadFilePgk(map.GetMapName);
            case Mapmini.MapWidth * 32 of
                0..5000: zoom := 1;
                5001..10000: zoom := 2;
            else zoom := 4;
            end;

            tt := TA2Image.Create(Mapmini.MapWidth * 32 div zoom, Mapmini.MapHeight * 24 div zoom, 0, 0);
            try
                tt.Clear(winrgb(1, 1, 1));
                Mapmini.miniMAP(0, 0, zoom, tt);
                // tt.SaveToFile(filename + '1.bmp');
                ttStream := TMemoryStream.Create;
                try
                    tt.SaveToStream(ttStream);
                    TBitmap1 := TBitmap.Create;
                    try

                        fh := Mapmini.MapHeight * 24 div zoom;
                        if fh > 470 then
                        begin
                            fh := 470;
                            zoom := Mapmini.MapHeight * 24 div fh;
                        end;

                        fw := Mapmini.MapWidth * 32 div zoom;
                        if fw > 780 then
                        begin
                            fw := 780;
                            zoom := Mapmini.MapWidth * 32 div fw;
                            fh := Mapmini.MapHeight * 24 div zoom;
                        end;
                        // if Mapmini.MapWidth * 32 div zoom > A2ILabel_b.Width then fw := A2ILabel_b.Width;

                        TBitmap1.Width := fw;
                        TBitmap1.Height := fh;
                        TBitmap1.PixelFormat := pf16bit;
                        ToDrawZoomStream(TBitmap1.Canvas.Handle, ttStream, TBitmap1.Width, TBitmap1.Height);
                        TBitmap1.SaveToFile(filename);

                    finally
                        TBitmap1.Free;
                    end;
                finally
                    ttStream.Free;
                end;

            finally
                tt.Free;
            end;

        finally
            Mapmini.Free;
        end;

    end;

    if FileExists(filename) then
    begin
        ttTA2Image := TA2Image.Create(4, 4, 0, 0);
        // pgkmap.getBmp(filename, ttTA2Image);
        ttTA2Image.LoadFromFile(filename);
        A2ILabel_b.A2Image := ttTA2Image;
        A2ILabel_b.Width := ttTA2Image.Width;
        A2ILabel_b.Height := ttTA2Image.Height;
        // A2ILabel_b.Picture.LoadFromFile(filename);
    end else exit;
    MapImgWidth := A2ILabel_b.Width;
    if MapImgWidth = 0 then MapImgWidth := A2ILabel_b.Width;
    MapImgHeight := A2ILabel_b.Height;
    if MapImgHeight = 0 then MapImgHeight := A2ILabel_b.Height;
    self.Width := MapImgWidth;
    self.Height := MapImgHeight;
    //  A2Form.Width := MapImgWidth;
    //  A2Form.Height := MapImgHeight;
    A2ILabel_b.Width := MapImgWidth;
    A2ILabel_b.Height := MapImgHeight;
    //    A2ILabel_path.Width := A2ILabel_b.Width;
      //  A2ILabel_path.Height := A2ILabel_b.Height;
    FrmM.move_win_form_Align(Self, mwfCenter);

    // SearchIdLabel.Left := Self.ClientWidth - SearchIdLabel.Width - 15;
    // SearchIdLabel.Top := self.ClientHeight - SearchIdLabel.Height - 15;
    SetCenterID;
    result := true;
end;
}

function TFrmMiniMap.OutMapFile(filename: string): boolean;
var
  tt: TA2Image;
  zoom, fw, fh: integer;
  Mapmini: tmapmini;
  TBitmap1: TBitmap;
  ttStream: TMemoryStream;
begin
  result := false;
   { if not FileExists(filename) then
    begin
        Mapmini := tMapmini.Create;
        try
            Mapmini.MapLoadFile(map.GetMapName);
            case Mapmini.MapWidth * 32 of
                0..5000: zoom := 1;
                5001..10000: zoom := 2;
            else zoom := 4;
            end;

            tt := TA2Image.Create(Mapmini.MapWidth * 32 div zoom, Mapmini.MapHeight * 24 div zoom, 0, 0);
            try
                tt.Clear(winrgb(1, 1, 1));
                Mapmini.miniMAP(0, 0, zoom, tt);
                // tt.SaveToFile(filename + '1.bmp');
                ttStream := TMemoryStream.Create;
                try
                    tt.SaveToStream(ttStream);
                    TBitmap1 := TBitmap.Create;
                    try

                        fh := Mapmini.MapHeight * 24 div zoom;
                        if fh > 470 then
                        begin
                            fh := 470;
                            zoom := Mapmini.MapHeight * 24 div fh;
                        end;

                        fw := Mapmini.MapWidth * 32 div zoom;
                        if fw > 780 then
                        begin
                            fw := 780;
                            zoom := Mapmini.MapWidth * 32 div fw;
                            fh := Mapmini.MapHeight * 24 div zoom;
                        end;
                        // if Mapmini.MapWidth * 32 div zoom > A2ILabel_b.Width then fw := A2ILabel_b.Width;

                        TBitmap1.Width := fw;
                        TBitmap1.Height := fh;
                        TBitmap1.PixelFormat := pf16bit;
                        ToDrawZoomStream(TBitmap1.Canvas.Handle, ttStream, TBitmap1.Width, TBitmap1.Height);
                        TBitmap1.SaveToFile(filename);

                    finally
                        TBitmap1.Free;
                    end;
                finally
                    ttStream.Free;
                end;

            finally
                tt.Free;
            end;

        finally
            Mapmini.Free;
        end;

    end;
    }
  result := true;
end;

function TFrmMiniMap.showmap(filename: string): boolean;
var
  tt: TA2Image;
  zoom, fw, fh: integer;
  Mapmini: tmapmini;
  TBitmap1: TBitmap;
  ttStream: TMemoryStream;
begin
  result := false;
  if ttTA2Image <> nil then
  begin
    ttTA2Image.Free;
    ttTA2Image := nil;
  end;

  if pgkbmp.isfile(filename) then
  begin
    ttTA2Image := TA2Image.Create(4, 4, 0, 0);
    pgkbmp.getBmp(filename, ttTA2Image);

  end
  else
  begin
    if not FileExists(filename) then
    begin
      if OutMapFile(filename) = false then
        exit;
    end;
    if FileExists(filename) then
    begin
      ttTA2Image := TA2Image.Create(4, 4, 0, 0);
      ttTA2Image.LoadFromFile(filename);
    end
    else
      exit;

  end;
  MapImgWidth := ttTA2Image.Width;
  if MapImgWidth = 0 then
    MapImgWidth := 470;
  MapImgHeight := ttTA2Image.Height;
  if MapImgHeight = 0 then
    MapImgHeight := 780;

  Width := MapImgWidth;
  Height := MapImgHeight;
  A2ILabel_b.Width := MapImgWidth;
  A2ILabel_b.Height := MapImgHeight;
  FrmM.move_win_form_Align(Self, mwfCenter);
  A2ILabel_b.A2Image := ttTA2Image;

  result := true;
end;

procedure TFrmMiniMap.FormDestroy(Sender: TObject);
begin
  fNpc.Free;
  fGate.Free;
  fUser.Free;
    //    fONE.Free;
  CenterImage.Free;
  if ttTA2Image <> nil then
    ttTA2Image.Free;
end;

procedure TFrmMiniMap.SetFuser;
var
  x, y, i: integer;
  t: TA2ILabel;
begin
  for i := 0 to fUser.data.Count - 1 do
  begin
    t := fUser.ItemGet(i);
    x := trunc(MapImgWidth * (CharPosX / mapw));
    //y := trunc(MapImgHeight * (CharPosy / maph));
     //2015年10月14日 14:14:23修改测试小地图标点Y坐标按照w坐标比例修正
    y := trunc(MapImgWidth * (CharPosy / maph) * 0.75);

    CenterIdLabel.Hint := CharCenterName;

    CenterIdLabel.Left := x - (CenterIdLabel.Width div 2);
    CenterIdLabel.Top := y - (CenterIdLabel.Height div 2);
  end;

end;

procedure TFrmMiniMap.SetCenterID;
var
  x, y: integer;
begin

  x := trunc(MapImgWidth * (CharPosX / mapw));
  //y := trunc(MapImgHeight * (CharPosy / maph));
  //2015年10月14日 14:14:23修改测试小地图标点Y坐标按照w坐标比例修正
  y := trunc(MapImgWidth * (CharPosy / maph) * 0.75);

  CenterIdLabel.Hint := CharCenterName;

  CenterIdLabel.Left := x - (CenterIdLabel.Width div 2);
  CenterIdLabel.Top := y - (CenterIdLabel.Height div 2);
end;

procedure TFrmMiniMap.SetPostion;
begin

  if FrmAttrib.Visible then
  begin
    Top := ((fhei - FrmBottom.Height) div 2) - (Height div 2);
    Left := ((fwide - FrmAttrib.Width) div 2) - (Width div 2);
  end
  else
  begin
    Top := ((fhei - FrmBottom.Height) div 2) - (Height div 2);
    Left := (fwide div 2) - (Width div 2);
  end;
end;

procedure TFrmMiniMap.A2ILabel1Click(Sender: TObject);
begin
  CenterIdLabel.A2SendToBack;
end;

procedure TFrmMiniMap.AIPathcalc_paoshishasbi(gx, gy: integer);
var
  i, cx, cy, fx, fy: integer;
  j: dword;
begin
  pathlist.Clear;
  AIPathgx := gx;
  AIPathgy := gy;
  i := 2;
  while not cMaper.isMoveable(gx, gy) do
  begin
    inc(i);
    gx := gx + random(i);
    gy := gy + random(i);
    if i > 7 then
      Break;
  end;

  if not cMaper.isMoveable(gx, gy) then
  begin
    FrmBottom.AddChat(format('目标[%D,%D]可能存在障碍物,请重新定位!', [gx, gy]), ColorSysToDxColor(clYellow), 0);
    exit;
  end;
    //   pathTA2Image.Clear(0);
   //    temppathtest := pathTA2Image;
  cx := CharPosX;
  cy := CharPosy;
  //cSearchPathClass.GotoPath(cx, cy, gx, gy, fx, fy);
  //j := abs(gy - fy) + abs(gx - fx);
  //if j = 0 then
  //2016.03.21 在水一方 移植新寻路算法
  Clear;
  FPath := nSearchPathClass.FindPath(cx, cy, gx, gy, 1);
  if Assigned(FPath) then
  begin
    FMoveIndex := 1;
    FEndX := gx;
    FEndY := gy;
    RunAutoMOVE;
    //不是自动修炼步法才提示
    if not FrmGameToolsNew.A2CheckBox11.Checked then
      FrmBottom.AddChat(format('目标[%D,%D]开始自动走路。', [gx, gy]), ColorSysToDxColor(clLime), 0);
  end
  else
  begin
    FrmBottom.AddChat(format('目标[%D,%D]可能存在障碍物,请重新定位!!', [gx, gy]), ColorSysToDxColor(clYellow), 0);
  end;
end;

procedure TFrmMiniMap.StopAutoMOVE();
begin
  if not TimerAutoPathMove.Enabled then
    exit;
    //不是自动修炼步法才提示
  if not FrmGameToolsNew.A2CheckBox11.Checked then
    FrmBottom.AddChat('自动走路已经结束。', ColorSysToDxColor(clred), 0);
  pathlist.Clear;
  TimerAutoPathMove.Enabled := false;
end;

procedure TFrmMiniMap.RunAutoMOVE();
begin
  TimerAutoPathMove.Enabled := true;
end;

procedure TFrmMiniMap.TimerAutoPathMoveTimer(Sender: TObject);
var
  P: pTpathxy;
  j: integer;
var
  Dir: Integer;
  CurX, CurY: Integer;
  MoveTmp: Boolean;
  FindIndex: Integer;
  CharCls: TCharClass;
begin
  if (mmAnsTick - SetFuserTicknum) >= 300 then
  begin
    GETnpcList(true);
//    SetFuser;
    SetFuserTicknum := mmAnsTick;
  end;

    //    if sm_moveOk = false then exit;
  if MapAutoPath then
  begin
    if ((CharPosX = MapAutoPathx) and (MapAutoPathy = CharPosy)) then
      MapAutoPath := false;
  end;
  if MapAutoPath then
    exit;
  {if pathlist.Fdatalist.Count <= 0 then
  begin
    StopAutoMOVE;
    exit;
  end;
  p := pathlist.getEnd;
  if p = nil then
  begin
    StopAutoMOVE;
    exit;
  end;

  if ((CharPosX = p.rx) and (p.ry = CharPosy)) then
  begin
    pathlist.delEnd;
  end
  else
  begin
    FrmM.map_move(p.rx, p.ry);
  end;}
  //2016.03.21 在水一方 移植新寻路算法
  if not Assigned(FPath) then
  begin
    StopAutoMOVE;
    exit;
  end;

  MoveTmp := Assigned(FTmpPath);
  case MoveTmp of
    True:
      begin
        CurX := FTmpPath[FTmpIndex].X;
        CurY := FTmpPath[FTmpIndex].Y;
      end
  else
    begin
      CurX := FPath[FMoveIndex].X;
      CurY := FPath[FMoveIndex].Y;
    end;
  end;

  //短距离移动
  if (not Map.isMovable(CurX, CurY)) or (not CharList.isMovable(CurX, CurX)) or
    ((abs(CurX - Map.Cx) > 1) or (abs(CurY - Map.Cy) > 1)) then
  begin
    FindIndex := (High(FPath) - FMoveIndex - 1);
    if FindIndex > 13 then
      FindIndex := 13;

    FindIndex := FMoveIndex + FindIndex;

    cMaper.QuickMode := false;
    FTmpPath := nSearchPathClass.FindPath(CharPosX, CharPosy, FPath[FindIndex].X, FPath[FindIndex].Y, 1);
    if not Assigned(FTmpPath) then
    begin
      Clear;
      StopAutoMOVE;
      FrmBottom.AddChat(Format('目标<%d:%d>无法到达.', [FEndX, FEndY]), ColorSysToDxColor(clYellow), 0);
      Exit;
    end;
    FMoveIndex := FindIndex;
    FTmpIndex := 1;
    CurX := FTmpPath[FTmpIndex].X;
    CurY := FTmpPath[FTmpIndex].Y;
  end;

  if ((CharPosX = CurX) and (CharPosy = CurY)) then
  begin
    begin
      case MoveTmp of
        True:
          begin
            Inc(FTmpIndex);
            if FTmpIndex >= High(FTmpPath) then
            begin
              FTmpPath := nil;
            end;
          end;
        False:
          begin
            Inc(FMoveIndex);
            if High(FPath) <= FMoveIndex then
            begin
              Clear;
              StopAutoMOVE;
              Exit;
            end;
          end;
      end;
    end;
  end
  else
  begin
    FrmM.map_move(CurX, CurY);
  end;
end;

procedure TFrmMiniMap.A2ILabel_bMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  gx, gy: integer;
begin
  FrmM.SetA2Form(Self, A2form);
    //
  if Button = mbLeft then
  begin
    gx := trunc((x / A2ILabel_b.Width) * Map.Width);
    //gy := trunc((y / A2ILabel_b.Height) * Map.Height);
    //2015年10月14日 14:14:23修改测试小地图标点Y坐标按照w坐标比例修正
    gy := trunc((y / 0.75 / A2ILabel_b.Width) * Map.Height);

    AIPathgx := gx;
    AIPathgy := gy;
    cMaper.QuickMode := true;
    AIPathcalc_paoshishasbi(gx, gy);
  end;

end;

procedure TFrmMiniMap.A2ILabel_bMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  gx, gy: integer;
begin
  gx := trunc((x / A2ILabel_b.Width) * Map.Width);
 // gy := trunc((y / A2ILabel_b.Height) * Map.Height);
  //2015年10月14日 14:14:23修改测试小地图标点Y坐标按照w坐标比例修正
  gy := trunc((y / 0.75 / A2ILabel_b.Width) * Map.Height);

  GameHint.setText(integer(Sender), format('坐标[%D,%D]', [gx, gy]));
    //  SearchIDLabel.Caption := format('坐标[%D,%D]', [gx, gy]);
end;

procedure TFrmMiniMap.TimerMoveTimer(Sender: TObject);
begin
    //CenterIdLabel.A2Image := CenterImage;
end;

procedure TFrmMiniMap.Clear;
begin
  FPath := nil;
  FMoveIndex := 0;
  FTmpPath := nil;
  FTmpIndex := 0;
end;

end.

