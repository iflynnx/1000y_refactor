unit FBuffPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseUIForm, A2Form, A2Img, StdCtrls, deftype, CharCls, Atzcls, uAnsTick, backscrn;

type
  TBuffTmpData = record
    haveBuff: Boolean;
    buffData: TBuffData;
    buffLabel: TA2ILabel;
  end;
  TfrmBuffPanel = class(TfrmBaseUI)
    A2form: TA2Form;
    A2BuffIlabel1: TA2ILabel;
    A2BuffIlabel2: TA2ILabel;
    A2BuffIlabel9: TA2ILabel;
    A2BuffIlabel4: TA2ILabel;
    A2BuffIlabel5: TA2ILabel;
    A2BuffIlabel6: TA2ILabel;
    A2BuffIlabel7: TA2ILabel;
    A2BuffIlabel8: TA2ILabel;
    A2BuffIlabel3: TA2ILabel;
    A2BuffIlabel10: TA2ILabel;
    A2BuffIlabel11: TA2ILabel;
    A2BuffIlabel12: TA2ILabel;
    A2BuffIlabel13: TA2ILabel;
    A2BuffIlabel14: TA2ILabel;
    A2BuffIlabel15: TA2ILabel;
    A2BuffIlabel16: TA2ILabel;
    A2BuffIlabel17: TA2ILabel;
    A2BuffIlabel18: TA2ILabel;
    A2BuffIlabel19: TA2ILabel;
    A2BuffIlabel20: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2BuffIlabel1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  protected
    fbackimg: TA2Image;
    FBuffList: array[1..20] of TBuffTmpData;
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);

  public                                    
    procedure DrawBuff; virtual;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure addBuffData(ABuffData: TBuffData);
    procedure delBuffData(ABuffData: TBuffData);
    procedure null;
  end;

var
  frmbuffpanel: TfrmBuffPanel;

implementation

uses FMain;

{$R *.dfm}

{ TfrmBuffPanel }

procedure TfrmBuffPanel.SetConfigFileName;
begin
  FConfigFileName := 'BuffPanel.xml';

end;

procedure TfrmBuffPanel.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  SetControlPos(A2BuffIlabel1);
  if fbackimg = nil then
    fbackimg := TA2Image.Create(34, 34, 0, 0);
  fbackimg.Name := 'fbackimg';
  SetA2ImgPos(fbackimg);
end;

procedure TfrmBuffPanel.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure TfrmBuffPanel.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  Self.FTestPos := True;
  FrmM.AddA2Form(Self, A2form);
  self.SetNewVersionTest;
  for i := Low(FBuffList) to High(FBuffList) do
  begin
    FBuffList[i].buffLabel := TA2ILabel(Self.FindComponent('A2BuffIlabel' + inttostr(i)));
    FBuffList[i].haveBuff := False;
    FBuffList[i].buffLabel.A2Imageback := fbackimg;
  end;
  DrawBuff;


end;

procedure TfrmBuffPanel.FormShow(Sender: TObject);
begin
 // self.SetNewVersionTest;

end;

procedure TfrmBuffPanel.addBuffData(ABuffData: TBuffData);
var
  i, n: integer;
begin
  n := -1;
  for i := Low(FBuffList) to High(FBuffList) do
    if FBuffList[i].buffData.rid = ABuffData.rid then begin
      n := i;
      Break;
    end;
  if n = -1 then
    for i := Low(FBuffList) to High(FBuffList) do
      if FBuffList[i].haveBuff = False then begin
        n := i;
        Break;
      end;
  if n = -1 then Exit;
  FBuffList[n].haveBuff := True;
  CopyMemory(@FBuffList[n].buffData, @ABuffData, SizeOf(TBuffData));
  DrawBuff;
end;

procedure TfrmBuffPanel.delBuffData(ABuffData: TBuffData);
var
  i, n: integer;
begin
  n := -1;
  for i := Low(FBuffList) to High(FBuffList) do
    if FBuffList[i].buffData.rid = ABuffData.rid then begin
      n := i;
      Break;
    end;
  if n = -1 then Exit;
  FillChar(FBuffList[n].buffData, SizeOf(TBuffData), 0);
  FBuffList[n].haveBuff := False;
  DrawBuff;
end;

procedure TfrmBuffPanel.DrawBuff;
var
  i: Integer;
  firstleft: Integer;
  firsttop: Integer;
  firstwidth: Integer;
  firstheight: Integer;
  maxwidth: Integer;
  maxheight: Integer;
  Maxleft: Integer;
begin
  SetNewVersionTest;
  maxwidth := 0;
  maxheight := 0;
 // firstleft := 0;
  if G_Default1024 then
    Maxleft := fwide1024
  else
    Maxleft := fwide;

  //Maxleft := 800;
  firstleft := FBuffList[1].buffLabel.Left;
  //if not G_Default1024 then
  //  firstleft := firstleft - 220;
  firsttop := FBuffList[1].buffLabel.Top;
  firstwidth := FBuffList[1].buffLabel.Width;
  firstheight := FBuffList[1].buffLabel.Height;
  for i := Low(FBuffList) to High(FBuffList) do
  begin
    SetItemLabel(FBuffList[i].buffLabel, '', 255, FBuffList[i].buffData.rshape, 0, 0);

    if (FBuffList[i].buffLabel.Visible) then
    begin
      //firstleft := firstleft + firstwidth + 4;
      firstleft := firstleft + firstwidth + 4;
      FBuffList[i].buffLabel.Top := firsttop;
      FBuffList[i].buffLabel.Left := firstleft;
      FBuffList[i].buffLabel.Width := firstwidth;
      FBuffList[i].buffLabel.Height := firstheight;
    end;
    if maxwidth < firstleft + firstwidth then
      maxwidth := firstleft + firstwidth;
    if maxheight < firsttop + firstheight then
      maxheight := firsttop + firstheight;
  end;
  //ShowMessage(IntToStr(maxwidth));
  Self.Left := Maxleft - maxwidth - 4;     
  if not G_Default1024 then
    Self.Top := Self.Top - 168;
  Self.Width := maxwidth;
  Self.Height := maxheight;
end;

procedure TfrmBuffPanel.SetItemLabel(Lb: TA2ILabel; aname: string;
  acolor: byte; shape, shapeRdown, shapeLUP: word);
var
  gc, ga: integer;
  new, tmp, back: TA2Image;
begin
  Lb.Caption := aname;
  Lb.Font.Color := shapeLUP;
  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;
  if shape = 0 then
  begin
    lb.Visible := false;
  end else
  begin
    lb.Visible := true;
    Lb.A2Image := AtzClass.GetItemImage(shape);
  end;
end;

procedure TfrmBuffPanel.A2BuffIlabel1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  second, third: string;
  time: Integer;
  tmpBuffData: TBuffData;
begin
  tmpBuffData := FBuffList[(TA2ILabel(Sender).tag)].buffData;
  tmpBuffData.rdesc := StringReplace(tmpBuffData.rdesc, '^', #13#10 + '{2} ' + #13#10, [rfReplaceAll]);
  GameHint.setText(integer(Sender), tmpBuffData.rdesc);
end;

procedure TfrmBuffPanel.FormDestroy(Sender: TObject);
begin
  inherited; // 内存泄漏007 在水一方 2015.05.18
  fbackimg.Free;
end;

procedure TfrmBuffPanel.null;
begin

end;

procedure TfrmBuffPanel.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  spoint, mypoint: TPoint;
begin

  inherited;

end;

procedure TfrmBuffPanel.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  spoint, mypoint: TPoint;
begin

  inherited;
end;

procedure TfrmBuffPanel.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  spoint, mypoint: TPoint;
begin

  inherited;

end;

end.

