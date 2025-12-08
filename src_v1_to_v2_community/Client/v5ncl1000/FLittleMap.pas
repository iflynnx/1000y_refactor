unit FLittleMap;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, StdCtrls, A2img, BackScrn, clmap, MapType, CharCls, deftype,
    ObjCls, ProClass, ExtCtrls, uAnsTick, Math, TileCls, cltype;
type
    TMapState = (tms_add, tms_dec);
    TFrmLittleMap = class(TForm)
        A2Form: TA2Form;
        A2ILabel_littlemap: TA2ILabel;
        Timer1: TTimer;
        A2Button_Small: TA2Button;
        A2Button_Big: TA2Button;
        A2Button_Close: TA2Button;
    LbPos: TA2Label;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure A2Button_BigClick(Sender: TObject);
        procedure A2Button_SmallClick(Sender: TObject);
        procedure A2Button_CloseClick(Sender: TObject);
        procedure A2FormAdxPaint(aAnsImage: TA2Image);
    private
        iCx, iCy: integer;
        LittleMap: TA2Image;
        back_map: TA2Image;
        back_img: TA2Image;
    public
        procedure DrawImage(AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
        procedure DrawImageKeyColor(AnsImage: TA2Image; x, y: Integer);
        procedure DrawMinMap(CurTick: integer);
        procedure DrawMap(CurTick: integer);
    end;

var
     FrmLittleMap: TFrmLittleMap;
    v_min_map_VIEWWIDTH: integer = VIEWWIDTH * 2;
    v_min_map_VIEWHEIGHT: integer = VIEWHEIGHT * 2;

implementation
uses
    FMain, filepgkclass, FBottom, Unit_console,Fbl;
{$R *.dfm}

procedure TFrmLittleMap.DrawImage(AnsImage: TA2Image; x, y: Integer;
    aTrans: Boolean);
var
    ax, ay: integer;
begin
    if Ansimage <> nil then
    begin
        //左上 坐标
        ax := CharPosX - v_min_map_VIEWWIDTH;
        ay := CharPosY - v_min_map_VIEWHEIGHT;
        //象素左上坐标
        ax := ax * 32;
        ay := ay * 24;
        //象素坐标
        ax := x - ax + Ansimage.px;
        ay := y - ay + Ansimage.py;
        LittleMap.DrawImage(Ansimage, ax, ay, true);
    end;
end;

procedure TFrmLittleMap.DrawImageKeyColor(AnsImage: TA2Image; x, y: Integer);
var
    ax, ay: integer;
begin
    if Ansimage <> nil then
    begin
        //左上 坐标
        ax := CharPosX - v_min_map_VIEWWIDTH;
        ay := CharPosY - v_min_map_VIEWHEIGHT;
        //象素左上坐标
        ax := ax * 32;
        ay := ay * 24;
        //象素坐标
        ax := x - ax + Ansimage.px;
        ay := y - ay + Ansimage.py;
        LittleMap.DrawImageKeyColor(Ansimage, ax, ay, 31, @Darkentbl);
    end;
end;

procedure TFrmLittleMap.DrawMap(CurTick: integer);
var
    i, j: integer;
    MapCell: TMapCell;
    oi, n, m: integer;
    po: PTObjectData;
    subMapCell: TMapCell;
begin
    if (iCx = CharPosX) and (iCy = CharPosY) then exit;
    LittleMap.Setsize(v_min_map_VIEWWIDTH * 32 * 2, v_min_map_VIEWHEIGHT * 24 * 2);
    //绘制地表
    for j := map.Cy - v_min_map_VIEWWIDTH to map.Cy + v_min_map_VIEWWIDTH do
    begin
        for i := map.Cx - v_min_map_VIEWHEIGHT to map.Cx + v_min_map_VIEWHEIGHT do
        begin
            MapCell := map.GetCell(i, j);
            with MapCell do
            begin
                if TileId <> 0 then
                begin
                    if TileId > TILE_MAX_COUNT then continue;
                    DrawImage(TileDataList.GetTileImage(TileId, TileNumber, CurTick), i * UNITX, j * UNITY, FALSE);
                end else
                    DrawImage(TileDataList.GetTileImage(0, 0, CurTick), i * UNITX, j * UNITY, FALSE);
                if TileOverId <> 0 then
                begin
                    if TileOverId > TILE_MAX_COUNT then continue;
                    DrawImage(TileDataList.GetTileImage(TileOverId, TileOverNumber, CurTick), i * UNITX, j * UNITY, TRUE);
                end;
            end;
        end;
    end;

    //画地图 物体 （分上下层）
    for j := map.Cy - v_min_map_VIEWWIDTH to map.Cy + v_min_map_VIEWWIDTH do
    begin
        for i := map.Cx - v_min_map_VIEWHEIGHT to map.Cx + v_min_map_VIEWHEIGHT do
        begin
            MapCell := Map.GetCell(i, j);                                       //获取地图块
            oi := MapCell.ObjectId;                                             //物体ID
            if oi = 0 then Continue;
            po := ObjectDataList[oi];                                           //获取物体
            if po = nil then Continue;
            if po.Style = TOB_follow then                                       //follow  随从
            begin
                if CurTick > Map.GetMapCellTick(i, j) + po.AniDelay then
                begin
                    Map.SetMapCellTick(i, j, CurTick);
                    if po.StartID = po.ObjectId then
                    begin
                        inc(MapCell.ObjectNumber);
                        if MapCell.ObjectNumber > po.nBlock - 1 then MapCell.ObjectNumber := 0;
                        Map.SetCell(i, j, MapCell);
                        for m := j - po.MHeight to j + (po.MHeight div 2) + 2 do
                        begin
                            for n := 0 to po.EndID - po.StartID do
                            begin
                                SubMapCell := Map.GetCell(i + n + (po.IWidth div 32) - 1, m);
                                if (SubMapCell.ObjectId > 0) and (SubMapCell.ObjectId > po.StartID) and (SubMapCell.ObjectId <= po.EndID) then
                                begin
                                    Map.SetMapCellTick(i + n + (po.IWidth div 32) - 1, m, CurTick);
                                    inc(SubMapCell.ObjectNumber);
                                    if subMapCell.ObjectNumber > po.nBlock - 1 then subMapCell.ObjectNumber := 0;
                                    Map.SetCell(i + n + (po.IWidth div 32) - 1, m, subMapCell);
                                end;
                            end;
                        end;
                    end else
                    begin

                    end;
                end;
            end else
                MapCell.ObjectNumber := 0;

            DrawImageKeyColor(ObjectDataList.GetObjectImage(oi, MapCell.ObjectNumber, CurTick), i * UNITX, j * UNITY);
        end;
    end;

    //画屋顶
    for j := map.Cy + v_min_map_VIEWHEIGHT downto map.Cy - v_min_map_VIEWHEIGHT do
    begin
        for i := map.Cx - v_min_map_VIEWWIDTH to map.Cx + v_min_map_VIEWWIDTH do
        begin
            MapCell := Map.GetCell(i, j);
            if MapCell.RoofId <> 0 then
                DrawImageKeyColor(RoofDataList.GetObjectImage(MapCell.RoofId, 0, CurTick), i * UNITX, j * UNITY);
        end;
    end;

    icx := CharPosX;
    icy := CharPosY;
    LittleMap.Resize(trunc(LittleMap.Width / (LittleMap.Height / 150)), 150);
     i := (LittleMap.Width - 160) div 2;
     back_map.DrawImage(LittleMap, i, 0, false);
    LittleMap.GetImage(back_map, i, 0);
end;

procedure TFrmLittleMap.DrawMinMap(CurTick: integer);
var
    temp, temp2: TA2Image;
begin
    FrmConsole.cprint(lt_littlemap, '重新绘制' + inttostr(mmAnsTick));
    DrawMap(CurTick);
    temp := TA2Image.Create(LittleMap.Width, LittleMap.Height, 0, 0);
    temp2 := TA2Image.Create(160, 150, 0, 0);
    try

        LittleMap.CopyImage(temp);

        CharList.Paint_Point(temp, v_min_map_VIEWWIDTH * 2, v_min_map_VIEWHEIGHT * 2);
        temp.GetImage(temp2, (temp.Width - 160) div 2, 0);                      //裁剪图象
        temp2.DrawImage(back_img, 0, 0, true);
        A2ILabel_littlemap.A2Image := temp2;
    finally
        temp2.free;
        temp.Free;
    end;
end;

procedure TFrmLittleMap.FormCreate(Sender: TObject);
begin
    //坐标
  //  LbPos.Left := 72;
  //  LbPos.Top := 88;
    LbPos.Width := 45;
    LbPos.Height := 15;
    LbPos.Font.Name:=mainfont;
    FrmM.AddA2Form(Self, A2Form);
    back_img := TA2Image.Create(160, 150, 0, 0);
    pgkBmp.getBmp('小地图边框.bmp', back_img);
    back_img.TransparentColor := 0;
    LbPos.Font.Name := mainFont;
    A2Button_Small.Left := 113;
    A2Button_Big.Left := 128;
    A2Button_Close.Left := 143;
    A2Button_Small.BringToFront;
    A2Button_Big.BringToFront;
    A2Button_Close.BringToFront;
    
    Left := fwide-160;
    Top := 0;
    iCx := 0;
    iCy := 0;

    A2ILabel_littlemap.Width := 160;
    A2ILabel_littlemap.Height := 150;
    A2ILabel_littlemap.Left := 0;
    A2ILabel_littlemap.Top := 0;

    LittleMap := TA2Image.Create(160, 150, 0, 0);
    back_map := TA2Image.Create(160, 150, 0, 0);
end;

procedure TFrmLittleMap.FormDestroy(Sender: TObject);
begin
    LittleMap.Free;
    back_img.Free;
    back_map.Free;
end;

procedure TFrmLittleMap.Timer1Timer(Sender: TObject);
begin
    if Visible = false then exit;
    DrawMinMap(mmAnsTick);
end;

procedure TFrmLittleMap.A2Button_BigClick(Sender: TObject);
begin
    if (v_min_map_VIEWWIDTH = VIEWWIDTH * 2)
        and (v_min_map_VIEWHEIGHT = VIEWHEIGHT * 2) then
    begin
        FrmBottom.AddChat('小地图已经最大', WinRGB(22, 22, 0), 2);
        exit;
    end;
    v_min_map_VIEWWIDTH := VIEWWIDTH * 2;
    v_min_map_VIEWHEIGHT := VIEWHEIGHT * 2;
    iCx := 0;
    iCy := 0;
end;

procedure TFrmLittleMap.A2Button_SmallClick(Sender: TObject);
begin

    if (v_min_map_VIEWWIDTH = VIEWWIDTH * 4)
        and (v_min_map_VIEWHEIGHT = VIEWHEIGHT * 4) then
    begin
        FrmBottom.AddChat('小地图已经最小', WinRGB(22, 22, 0), 2);
        exit;
    end;
    v_min_map_VIEWWIDTH := VIEWWIDTH * 4;
    v_min_map_VIEWHEIGHT := VIEWHEIGHT * 4;
    iCx := 0;
    iCy := 0;
end;

procedure TFrmLittleMap.A2Button_CloseClick(Sender: TObject);
begin
    FrmConsole.cprint(lt_littlemap, '关闭小地图' + inttostr(mmAnsTick));
    Visible := false;
    FrmBottom.AddChat('小地图已关闭，你可以按下 Insert 再次打开小地图', WinRGB(22, 22, 0), 2);
end;

procedure TFrmLittleMap.A2FormAdxPaint(aAnsImage: TA2Image);
begin
    FrmConsole.cprint(lt_littlemap, '小地图绘制刷新' + inttostr(mmAnsTick));
end;

end.

