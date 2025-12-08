unit FMonsterBuffPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FBuffPanel, A2Form, StdCtrls, A2Img, NativeXml, CharCls, uCrypt, AUtil32, deftype,
  ExtCtrls, SubUtil;

type
  TBossStructedData = record
    StructedW, StructedH: Integer;
    StructedX, StructedY: Integer;
    StructedShapeW, StructedShapeH: Integer;
    StructedShapeX, StructedShapeY: Integer;
    BuffLeft, BuffTop: Integer;
    FormW, FormH: Integer;
    FormLeft, FormTop: Integer;
    level: Byte;
    BackImgName: string;
    BossName: string;
    BossNameColor: TColor;
    BossNameX: Integer;
    BossNameY: Integer;
  end;
  TfrmMonsterBuffPanel = class(TfrmBuffPanel)
    StructedA2ILabel: TA2ILabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FBossData: array[1..8] of TBossStructedData;

    FBossStructedBack: TA2Image;
    FClass: Integer;
  public
    FSelectCharName: string;
    FSelectCharId: LongInt;
  public
    procedure DrawBuff; override;
    procedure DrawBuff2(AClass: Integer);
    procedure ClearBuffData;
    procedure SetConfigFileName; override;
    procedure DrawStructed(AClass: Integer; Apercent: Integer; ABossId: Integer);
    procedure SetNewVersionTest(); override;
    procedure UpdateXml;
    procedure DrawNameEx(aback: TA2Image; aname: string; x, y: integer; aColor: Integer; bColor: Integer = $7FFF);
    procedure OpenTimer();
    procedure CloseTimer();
    function Send_Get_BuffData(): Boolean;
    procedure SetAllBuffData(pAllBuffData: PTAllBuffDataMessage);
  end;

var
  frmMonsterBuffPanel: TfrmMonsterBuffPanel;

implementation
uses
  FMain, BaseUIForm, fbl;
{$R *.dfm}

{ TfrmMonsterBuffPanel }

procedure TfrmMonsterBuffPanel.DrawStructed(AClass: Integer; Apercent: Integer; ABossId: Integer);
var
  xx, yy: integer;
  TMP: TA2Image;
  Max, curlife: Integer;
  LifeHeight, i: Integer;
  FBossStructedBlood: TA2Image;
  cl: TCharClass;
  tmp_w: Integer;
  tmp_h: Integer;
  tmpStream: TMemoryStream;
begin
  try

    FClass := AClass;


    //FBossStructedBack.LoadFromFile(FUIPath + FBossData[AClass].BackImgName);
    if (FBossData[AClass].BackImgName <> '') then
    begin
      if not zipmode then //2015.11.12 在水一方 >>>>>>
        FBossStructedBack.LoadFromFile(FUIPath + FBossData[AClass].BackImgName)
      else begin
        if not alwayscache then
          tmpStream := TMemoryStream.Create;
        try
          if GetUIStream(bmpzipstream, tmpStream, FBossData[AClass].BackImgName) then
          begin
            try
              FBossStructedBack.LoadFromStream(tmpStream);
            except
              ShowMessage('客户端缺少图片' + FBossData[AClass].BackImgName);
            end;
          end;
        finally
          if not alwayscache then
            tmpStream.Free;
        end;
      end; //2015.11.12 在水一方 <<<<<<
    //  AImg.SaveToFile('test.bmp');
    end;
    FBossStructedBlood := TA2Image.Create(FBossData[AClass].StructedShapeW, FBossData[AClass].StructedShapeH, 0, 0);
//    FBossStructedBlood.px:=0;
//    FBossStructedBlood.py:=0;
//    FBossStructedBlood.Width := FBossData[AClass].StructedShapeW;
//    FBossStructedBlood.Height := FBossData[AClass].StructedShapeH;
   // StructedA2ILabel.Width := FBossData[AClass].StructedShapeW;

    Self.Top := FBossData[AClass].FormTop;
    self.Height := FBossData[AClass].FormH;
    self.Width := FBossData[AClass].FormW;
    if G_Default1024 then
    begin
      tmp_w := fwide1024;
      tmp_h := fhei1024;
    end else
    begin
      tmp_w := fwide;
      tmp_h := fhei
    end;
    self.Left := (tmp_w - self.Width) div 2;
     //self.Invalidate;
   // StructedA2ILabel.Height := FBossData[AClass].StructedShapeH;

    Max := FBossData[AClass].StructedW;
    LifeHeight := FBossData[AClass].StructedH;
    xx := FBossData[AClass].StructedX;
    yy := FBossData[AClass].StructedY;
    FBossStructedBlood.DrawImage(FBossStructedBack, FBossData[AClass].StructedShapeX, FBossData[AClass].StructedShapeY, True);
    FBossStructedBlood.DrawhLine(xx, yy, Max, WinRGB(5, 5, 5), LifeHeight);
    FBossStructedBlood.DrawhLine(xx, yy + 1, Max, WinRGB(5, 5, 5), LifeHeight);
    FBossStructedBlood.DrawhLine(xx, yy + 1, Max, WinRGB(5, 5, 5), LifeHeight);
    curlife := Max * Apercent div 100;
                     //  aper div 25
    FBossStructedBlood.DrawhLine(xx, yy, curlife, WinRGB(22, 5, 5), LifeHeight);
    FBossStructedBlood.DrawhLine(xx, yy + 1, curlife, WinRGB(22, 5, 5), LifeHeight);
    FBossStructedBlood.DrawhLine(xx, yy + 1, curlife, WinRGB(22, 5, 5), LifeHeight);


    FBossData[AClass].BossName := FSelectCharName;

    DrawNameEx(FBossStructedBlood, FBossData[AClass].BossName, FBossData[AClass].BossNameX, FBossData[AClass].BossNameY, ColorSysToDxColor(FBossData[AClass].BossNameColor), WinRGB(2, 2, 2));

 //   FBossStructedBlood.SaveToFile('xxxddddxx.bmp');
    StructedA2ILabel.A2Image := FBossStructedBlood; //TA2Image.Create(FBossData[AClass].StructedShapeW,FBossData[AClass].StructedShapeH,0,0);
    /// StructedA2ILabel.A2Image.DrawImage(FBossStructedBlood,0,0,True);
    StructedA2ILabel.Left := FBossData[AClass].StructedShapeX;
    StructedA2ILabel.Top := FBossData[AClass].StructedShapeY;
    StructedA2ILabel.Height := FBossData[AClass].StructedShapeH;
    StructedA2ILabel.Width := FBossData[AClass].StructedShapeW;

   //  StructedA2ILabel.A2Image.DrawImage(FBossStructedBlood,0,0 ,True);
   //  StructedA2ILabel.Invalidate;
    DrawBuff2(AClass);
  finally
    FBossStructedBlood.Free;
  end;
end;

procedure TfrmMonsterBuffPanel.SetConfigFileName;
begin
  if G_Default1024 then
    FConfigFileName := 'MonsterBuffPanel.xml'
  else
    FConfigFileName := 'MonsterBuffPanel800.xml'; // FConfigFileName := 'MonsterBuffPanel.xml';

end;

procedure TfrmMonsterBuffPanel.SetNewVersionTest;
begin
  SetConfigFileName;
  inherited;

  SetControlPos(self);
  UpdateXml;
end;

procedure TfrmMonsterBuffPanel.FormCreate(Sender: TObject);
begin
  inherited;
  FClass := -1;
  FBossStructedBack := TA2Image.Create(32, 32, 0, 0);
  FTestPos := True;
      //FrmM.AddA2Form(Self, A2form);
end;

procedure TfrmMonsterBuffPanel.FormDestroy(Sender: TObject);
begin
  inherited;
  FBossStructedBack.Free;

end;

procedure TfrmMonsterBuffPanel.UpdateXml;
var
  i: Integer;
  node, views: TXmlNode;
  Stream: TMemoryStream;
  tmp_w: Integer;
  tmp_h: Integer;
begin
  views := FUIConfig.Root.NodeByName('Views');
  if views <> nil then
    for i := Low(FBossData) to High(FBossData) do
    begin

      node := views.NodeByName('BossStructedData' + inttostr(i));
      if node = nil then
        Continue;
      FBossData[i].StructedW := node.ReadInteger('StructedW');
      FBossData[i].StructedH := node.ReadInteger('StructedH');
      FBossData[i].StructedX := node.ReadInteger('StructedX');
      FBossData[i].StructedY := node.ReadInteger('StructedY');
      FBossData[i].StructedShapeX := node.ReadInteger('StructedShapeX');
      FBossData[i].StructedShapeY := node.ReadInteger('StructedShapeY');
      FBossData[i].StructedShapeW := node.ReadInteger('StructedShapeW');
      FBossData[i].StructedShapeH := node.ReadInteger('StructedShapeH');
      FBossData[i].BuffLeft := node.ReadInteger('BuffLeft');
      FBossData[i].BuffTop := node.ReadInteger('BuffTop');
      FBossData[i].FormW := node.ReadInteger('FormW');
      FBossData[i].FormH := node.ReadInteger('FormH');
      FBossData[i].FormLeft := node.ReadInteger('FormLeft');



      FBossData[i].FormTop := node.ReadInteger('FormTop');
      FBossData[i].BackImgName := node.ReadWidestring('BackImgName');
      FBossData[i].BossNameColor := node.ReadColor('BossNameColor', WinRGB(2, 31, 0));
      FBossData[i].BossNameX := node.ReadInteger('BossNameX');
      FBossData[i].BossNameY := node.ReadInteger('BossNameY');
    end;
  if G_Default1024 then
  begin
    tmp_w := fwide1024;
    tmp_h := fhei1024;
  end else
  begin
    tmp_w := fwide;
    tmp_h := fhei;
  end;
  self.Left := (tmp_w - self.Width) div 2;
end;

procedure TfrmMonsterBuffPanel.DrawBuff2(AClass: Integer);
var
  i, n: Integer;
  firstleft: Integer;
  firsttop: Integer;
  firstwidth: Integer;
  firstheight: Integer;
  cl: TCharClass;
begin
  if AClass = -1 then Exit;
//  if ClickSelectedChar = 0 then
//  begin
//    Self.Visible := False;
//    Exit;
//  end;

  SetNewVersionTest;

  firstleft := FBossData[AClass].BuffLeft; // FBuffList[1].buffLabel.Left;
  firsttop := FBossData[AClass].BuffTop; // FBuffList[1].buffLabel.Top;
  firstwidth := FBuffList[1].buffLabel.Width;
  firstheight := FBuffList[1].buffLabel.Height;
  n := 0;
  for i := Low(FBuffList) to High(FBuffList) do
  begin
    SetItemLabel(FBuffList[i].buffLabel, '', 255, FBuffList[i].buffData.rshape, 0, 0);

    if (FBuffList[i].buffLabel.Visible) then
    begin
      firstleft := firstleft + firstwidth + 5;
      FBuffList[i].buffLabel.Top := firsttop;
      FBuffList[i].buffLabel.Left := firstleft;
      FBuffList[i].buffLabel.Width := firstwidth;
      FBuffList[i].buffLabel.Height := firstheight;
      n := n + firstwidth + 5;
    end;
  end;
  n := n - 5;
  //firstleft := (StructedA2ILabel.Width - n) div 2;
  firstleft := FBossData[AClass].BuffLeft;

  for i := Low(FBuffList) to High(FBuffList) do
  begin
    if (FBuffList[i].buffLabel.Visible) then
    begin
      firstleft := firstleft + firstwidth + 5;
      FBuffList[i].buffLabel.Left := firstleft;
    end;
  end;

end;

procedure TfrmMonsterBuffPanel.DrawBuff;
begin
  DrawBuff2(FClass);

end;

procedure TfrmMonsterBuffPanel.ClearBuffData; //2016.01.21 在水一方
var
  i: integer;
begin
  for i := Low(FBuffList) to High(FBuffList) do begin
    FillChar(FBuffList[i].buffData, SizeOf(TBuffData), 0);
    FBuffList[i].haveBuff := false;
    //FBuffList[i].buffLabel.Visible := false;
  end;
  DrawBuff2(FClass);
end;

procedure TfrmMonsterBuffPanel.SetAllBuffData(pAllBuffData: PTAllBuffDataMessage);
var
  i, n: integer;
begin
  with pAllBuffData^ do
  begin
    if rid <> FSelectCharId then Exit;
    n := Low(FBuffList);
    for i := 0 to rbuffcount - 1 do
    begin
      if n > High(FBuffList) then Break;
      FBuffList[n].haveBuff := True;
      CopyMemory(@FBuffList[n].buffData, @rBuffData[i], SizeOf(TBuffData));
      Inc(n);
    end;
    DrawBuff;
    frmMonsterBuffPanel.DrawStructed(1, rstruct, 0);
  end;
end;

procedure TfrmMonsterBuffPanel.DrawNameEx(aback: TA2Image; aname: string; x, y: integer;
  aColor, bColor: Integer);
var

  xx, yy, len, h: integer;
begin
  len := ATextWidth(aname);
  h := ATextHeight(aname);
  xx := aback.Width div 2 - len div 2;
  yy := aback.Height div 2 - h div 2;

  ATextOutBold(aback, xx + 1, yy + 1, bColor, aname);
  ATextOutBold(aback, xx - 1, yy - 1, bColor, aname);
  ATextOutBold(aback, xx + 1, yy - 1, bColor, aname);
  ATextOutBold(aback, xx - 1, yy + 1, bColor, aname);
  ATextOutBold(aback, xx, yy, aColor, aname);



//  if aname <> '' then
//  begin
//
//    xx :=x;// SWidth div 2 + x - Cx - len div 2;
//    yy :=y;// SHeight div 2 + y - Cy - 16 - 16;
//
//    ATextOutBold(StructedA2ILabel.A2Image, xx + 1, yy + 1, WinRGB(2, 2, 2), aname);
//    ATextOutBold(StructedA2ILabel.A2Image, xx - 1, yy - 1, WinRGB(2, 2, 2), aname);
//    ATextOutBold(StructedA2ILabel.A2Image, xx + 1, yy - 1, WinRGB(2, 2, 2), aname);
//    ATextOutBold(StructedA2ILabel.A2Image, xx - 1, yy + 1, WinRGB(2, 2, 2), aname);
//    ATextOutBold(StructedA2ILabel.A2Image, xx, yy, WinRGB(31, 31, 31), aname);
//  end;
end;

procedure TfrmMonsterBuffPanel.CloseTimer;
begin
  Timer1.Enabled := False;
  FSelectCharName := '';
  FSelectCharId := 0;
  ClearBuffData;
  self.Visible := False;
end;

function TfrmMonsterBuffPanel.Send_Get_BuffData: Boolean;
var
  CLAtt: TCharClass;
  temp: TWordComData;
begin
  result := false;
  if FSelectCharId = 0 then exit;
  Clatt := CharList.CharGet(FSelectCharId);
  if Clatt = nil then exit;
  if (CLAtt.Feature.rrace <> RACE_HUMAN) and (CLAtt.Feature.rrace <> RACE_MONSTER) then exit;
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_GETBUFF);
  WordComData_ADDbyte(temp, CLAtt.Feature.rrace);
  WordComData_ADDdword(temp, FSelectCharId);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
  result := true;
end;

procedure TfrmMonsterBuffPanel.Timer1Timer(Sender: TObject);
var
  cl: TCharClass;
begin
  inherited;
  Cl := CharList.CharGet(FSelectCharId);
  if Cl = nil then
  begin
    Timer1.Enabled := False;
    FSelectCharName := '';
    FSelectCharId := 0;
    self.Visible := False;

    Exit;
  end;


  if GetLargeLength(cl.x, cl.y, CharPosX, CharPosY) > 15 then
  begin
    Timer1.Enabled := False;
    FSelectCharName := '';
    FSelectCharId := 0;
    self.Visible := False;
  end;
end;

procedure TfrmMonsterBuffPanel.OpenTimer;
begin
  Timer1.Enabled := True;
end;

procedure TfrmMonsterBuffPanel.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  null;
end;

procedure TfrmMonsterBuffPanel.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  null;
end;

procedure TfrmMonsterBuffPanel.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  null;
end;

end.

