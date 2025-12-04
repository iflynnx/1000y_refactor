unit energy;
//境界 管理类
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls,
  A2Img, Deftype, A2Form, DXDraws, Grids, PaintLabel;
type
  TenergyGraphicsclass = class
  private
    boStart: boolean;
    FDelayTick: integer;
    level: integer;
    FImgIndex: integer;
    FImgIndexStart: integer;
    PaintLabelmain: TPaintLabel;
    PaintLabelbottom: TPaintLabel;
    Ftext: string;
    a2image: TA2Image;
    FergyA2Label: TA2Label;
    FenergyLeft: integer;
    FenergyTop: integer;
    procedure setVisible(v: boolean);
  public
    constructor Create(AOwnermain, AOwnerbottom: TComponent);
    destructor Destroy; override;
    procedure SETImage(aindex: integer);
    procedure SETlevel(alevel: integer);
    function GETlevel: integer;
    procedure update(atick: integer);
    property Visible: Boolean write setVisible;
    property text: string read ftext write ftext;
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseLeave(Sender: TObject);
    procedure sendAdd();
    procedure senddec();
    procedure sendleve(alevel: integer);
    procedure MessageProcess(var code: TWordComData);
    procedure AdxPaint(aimage: TA2Image);
    procedure BringToFront;
    procedure SetenergyA2Label(energyA2Label: TA2Label);
    procedure SetenergyLeft(ALeft: integer);
    procedure SetenergyTop(ATop: integer);
  end;

  Tenergyclass = class
  private

  public
    constructor Create;
    destructor Destroy; override;
  end;
var
  energyGraphicsclass: TenergyGraphicsclass;
  energyclass: Tenergyclass;

implementation
uses FAttrib, Fbl, FMain, FBottom; //GETenergyImage
///////////////////////////////////////////////////////////
//                TenergyGraphicsclass
///////////////////////////////////////////////////////////
//境界 动画管理

procedure TenergyGraphicsclass.MessageProcess(var code: TWordComData);
var
  i, n: integer;
  str: string;
begin
  i := 1;
  n := WordComData_GETbyte(code, i);
  case n of
    PowerLevel_level:
      begin
        n := WordComData_GETbyte(code, i);
        str := WordComData_GETString(code, i);
        text := str;
        if n > 0 then
        begin
          boStart := true;
          FrmBottom.AddChat('开启境界【' + text + '】', WinRGB(88, 88, 28), 0);
                    //if n >= maxjj then  //设定境界限定常量20130630
                    //    FrmBottom.AddChat('无法再提高了', WinRGB(22, 22, 0), 0);
          GameHint.setText(integer(self), text);
        end
        else
        begin
          boStart := false;
          FrmBottom.AddChat('无法再降低了', WinRGB(22, 22, 0), 0);
          GameHint.setText(integer(self), '单击开启或关闭境界');
        end;
        SETlevel(n);
      end;
  end;
end;

procedure TenergyGraphicsclass.Panel1MouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TenergyGraphicsclass.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if boStart then
    GameHint.setText(integer(self), text)
  else
    GameHint.setText(integer(self), '单击开启或关闭境界');

//    GameHint.pos(x + PaintLabelmain.Left, y + PaintLabelmain.Top);

end;

procedure TenergyGraphicsclass.Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if GameMenu.Visable then begin
    if GameMenu.CurrItem < 0 then
      GameMenu.Close
    else
    begin
      GameMenu.MouseDown;
      Exit;
    end;

  end;
    //
  case Button of
    mbLeft:
      begin
        sendAdd;
      end;
    mbRight:
      begin
        senddec;
      end;
  end;
end;

procedure TenergyGraphicsclass.sendAdd();
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_PowerLevel);
  WordComData_ADDbyte(temp, PowerLevel_ADD);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TenergyGraphicsclass.senddec();
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_PowerLevel);
  WordComData_ADDbyte(temp, PowerLevel_DEC);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TenergyGraphicsclass.sendleve(alevel: integer);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_PowerLevel);
  WordComData_ADDbyte(temp, PowerLevel_level);
  WordComData_ADDbyte(temp, alevel);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TenergyGraphicsclass.BringToFront;
begin
  PaintLabelmain.BringToFront;
  PaintLabelbottom.BringToFront;
end;


constructor TenergyGraphicsclass.Create(AOwnermain, AOwnerbottom: TComponent);
begin
  PaintLabelmain := TPaintLabel.Create(AOwnermain);
  PaintLabelmain.BringToFront;
  PaintLabelmain.AutoSize := false;
  PaintLabelmain.Caption := '';
  PaintLabelmain.Width := 36;
  PaintLabelmain.Height := 36;
  PaintLabelmain.Parent := TForm(AOwnermain);
  PaintLabelmain.Top := fhei - 117 - (36 div 2);
  if fwide = 800 then
    PaintLabelmain.Left := (fwide - 36) div 2
  else
    PaintLabelmain.Left := (fwide - 36) div 2 - 112;
  PaintLabelmain.OnMouseDown := Panel1MouseDown;
  PaintLabelmain.OnMouseMove := Panel1MouseMove;
  PaintLabelmain.OnMouseLeave := Panel1MouseLeave;

  PaintLabelbottom := TPaintLabel.Create(AOwnerbottom);
  PaintLabelbottom.BringToFront;
  PaintLabelbottom.AutoSize := false;
  PaintLabelbottom.Caption := '';
  PaintLabelbottom.Width := 36;
  PaintLabelbottom.Height := 36;
  PaintLabelbottom.Parent := TForm(AOwnerbottom);
    //PaintLabel.Top := fheight - 117 - (36 div 2);
  PaintLabelbottom.Top := -(36 div 2);

  if G_Default1024 then
    PaintLabelbottom.Left := (fwide1024 - 36) div 2
  else
    PaintLabelbottom.Left := (fwide - 36) div 2;

//  if fwide = 800 then PaintLabelbottom.Left := (fwide - 36) div 2
//  else PaintLabelbottom.Left := (fwide - 36) div 2 - 112;
  PaintLabelbottom.OnMouseDown := Panel1MouseDown;
  PaintLabelbottom.OnMouseMove := Panel1MouseMove;
  PaintLabelbottom.OnMouseLeave := Panel1MouseLeave;
  a2image := nil;
    { Panel1 := TPanel.Create(AOwner);
     Panel1.Width := 36;
     Panel1.Height := 36;
     Panel1.Parent := TForm(AOwner);
     Panel1.Top := fheight - 117 - (36 div 2);
     Panel1.Left := (fwideth - 36) div 2;
     Panel1.OnMouseDown := Panel1MouseDown;
     }
  SETlevel(0);

  boStart := false;
end;

procedure TenergyGraphicsclass.setVisible(v: boolean);
begin
    //    Panel1.Visible := v;
end;

procedure TenergyGraphicsclass.update(atick: integer);
begin
  if (aTick - FDelayTick) > 15 then
  begin
    FDelayTick := aTick;
    if level > 0 then
    begin
      inc(FImgIndex);
      case level of
        12: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        13: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        14: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        15: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        16: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        17: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        18: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        19: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        20: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
        21: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
      else
        if FImgIndex >= (FImgIndexStart + 5) then FImgIndex := FImgIndexStart;
      end;
      SETImage(FImgIndex);
    end;
  end;
  if a2image = nil then exit;
end;

procedure TenergyGraphicsclass.AdxPaint(aimage: TA2Image);
begin
  if a2image = nil then exit;
  if G_Default1024 then
    aimage.DrawImage(a2image, FenergyLeft + 2, FenergyTop + 4, true)
  else
    aimage.DrawImage(a2image, FenergyLeft + 5, FenergyTop + 2, true);
//  if fwide = 800 then
//    aimage.DrawImage(a2image, (fwide - 36) div 2 + 3, fhei - 117 - (36 div 2) + 2, false) else
//    aimage.DrawImage(a2image, (fwide - 36) div 2 - 112 + 3, fhei - 117 - (36 div 2) + 2, false)
end;

procedure TenergyGraphicsclass.SETlevel(alevel: integer);
begin
  level := alevel;
  case level of
    1..11: FImgIndexStart := (level - 1) * 5;
    12:
      begin
        FImgIndexStart := 55;
        FImgIndex := FImgIndexStart;
      end;
    13:
      begin
        FImgIndexStart := 65;
        FImgIndex := FImgIndexStart;
      end;
    14:
      begin
        FImgIndexStart := 75;
        FImgIndex := FImgIndexStart;
      end;
    15:
      begin
        FImgIndexStart := 85;
        FImgIndex := FImgIndexStart;
      end;
    16:
      begin
        FImgIndexStart := 95;
        FImgIndex := FImgIndexStart;
      end;
    17:
      begin
        FImgIndexStart := 105;
        FImgIndex := FImgIndexStart;
      end;
    18:
      begin
        FImgIndexStart := 115;
        FImgIndex := FImgIndexStart;
      end;
    19:
      begin
        FImgIndexStart := 125;
        FImgIndex := FImgIndexStart;
      end;
    20:
      begin
        FImgIndexStart := 135;
        FImgIndex := FImgIndexStart;
      end;
    21:
      begin
        FImgIndexStart := 145;
        FImgIndex := FImgIndexStart;
      end;
  else
    FImgIndexStart := 148;
    FImgIndex := FImgIndexStart;
  end;
  SETImage(FImgIndex);
end;

function TenergyGraphicsclass.GETlevel: integer;
begin
  Result := level;
end;

procedure TenergyGraphicsclass.SETImage(aindex: integer);
begin
  a2image := GETenergyImage(aindex);
end;

procedure TenergyGraphicsclass.SetenergyA2Label(energyA2Label: TA2Label);
begin
  FergyA2Label := energyA2Label;
end;

procedure TenergyGraphicsclass.SetenergyLeft(ALeft: integer);
begin
  FenergyLeft := ALeft;
  PaintLabelmain.Left := ALeft;

  if G_Default1024 then
    PaintLabelbottom.Left := (fwide1024 - 36) div 2
  else
    PaintLabelbottom.Left := (fwide - 36) div 2;
end;

procedure TenergyGraphicsclass.SetenergyTop(ATop: integer);
begin
  FenergyTop := ATop;
  PaintLabelmain.Top := ATop;

end;

destructor TenergyGraphicsclass.Destroy;
begin
  PaintLabelbottom.Free;
  PaintLabelmain.free;
  inherited Destroy;
end;
///////////////////////////////////////////////////////////
//                Tenergyclass
///////////////////////////////////////////////////////////
//境界 管理

constructor Tenergyclass.Create;
begin

end;

destructor Tenergyclass.Destroy;
begin

  inherited Destroy;
end;

end.

