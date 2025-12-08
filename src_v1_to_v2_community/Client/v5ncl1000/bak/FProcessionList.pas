unit FProcessionList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype;

type

  TfrmProcessionList = class(TForm)
    A2Form: TA2Form;
    A2ILabelTitle: TA2ILabel;
    A2ILabel08: TA2ILabel;
    A2ILabel07: TA2ILabel;
    A2ILabel01: TA2ILabel;
    A2ILabel06: TA2ILabel;
    A2ILabel05: TA2ILabel;
    A2ILabel04: TA2ILabel;
    A2ILabel02: TA2ILabel;
    A2ILabel03: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ILabelTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel01MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabelTitleClick(Sender: TObject);
    procedure A2ILabelTitleDblClick(Sender: TObject);
  private
        { Private declarations }
  public
        { Public declarations }
    boDrawList: boolean;
    FSELECTINDEX: INTEGER;
    titleA2Image: TA2Image;
    A2ILabelArr: array[0..7] of TA2ILabel;
    procedure ListDrawItem();

  end;

var
  frmProcessionList: TfrmProcessionList;

implementation
uses FProcession, FMain, FProcessionButton, filepgkclass;
{$R *.dfm}

procedure TfrmProcessionList.ListDrawItem();
var
  P: pTProcessiondata;
  i: integer;
  fx, fy, win_w, win_h: integer;
begin
  A2ILabelTitle.Top := 0;
  A2ILabelTitle.Left := 0;
  win_h := A2ILabelTitle.Height;
  win_w := A2ILabelTitle.Width;
  for i := 0 to high(A2ILabelArr) do
  begin
    A2ILabelArr[i].Visible := false;
    A2ILabelArr[i].A2Image := nil;
  end;
  if boDrawList then

    for i := 0 to frmProcession.FDATA.Count - 1 do
    begin
      if i > high(A2ILabelArr) then exit;
      P := frmProcession.GETIndex(i);
      if P = nil then EXIT;

      A2ILabelArr[i].Width := p.rA2Image.Width;
      A2ILabelArr[i].Height := p.rA2Image.Height;
      A2ILabelArr[i].Visible := true;
       // A2ILabelArr[i].A2Image := p.rA2Image;
      A2ILabelArr[i].top := win_h;
      A2ILabelArr[i].left := 0;
      win_h := win_h + p.rA2Image.Height;
      win_w := p.rA2Image.Width;
      if P.rid = frmProcession.headmanid then
        DrawRectangle(p.rA2Image, [$00838383, ColorDxColorToSys(31), $003C9DFF])
      else
        DrawRectangle(p.rA2Image, [$00838383]);
      fx := 8;
      fy := (p.rA2Image.Height - ATextHeight(p.rname)) div 2;

      ATextOut(p.rA2Image, fx + 1, fy + 1, WinRGB(3, 3, 3), p.rname);
      ATextOut(p.rA2Image, fx, fy, ColorSysToDxColor(p.rcolor), p.rname);
      A2ILabelArr[i].A2Image := p.rA2Image;
    end;
  ClientHeight := win_h;
  ClientWidth := win_w;
  A2Form.Surface.Setsize(ClientWidth + 10, ClientHeight + 20);
  A2ILabelTitle.Width := win_w;
  if frmProcession.FDATA.Count > 0 then
    Visible := true
  else Visible := false;
end;

procedure TfrmProcessionList.FormCreate(Sender: TObject);
var
  i, fx, fy: integer;
  str: string;
begin

  FrmM.AddA2Form(Self, A2Form);
    //Parent := FrmM;
  boDrawList := true;
  Top := 80;
  Left := 0;

  A2ILabelArr[0] := A2ILabel01;
  A2ILabelArr[1] := A2ILabel02;
  A2ILabelArr[2] := A2ILabel03;
  A2ILabelArr[3] := A2ILabel04;
  A2ILabelArr[4] := A2ILabel05;
  A2ILabelArr[5] := A2ILabel06;
  A2ILabelArr[6] := A2ILabel07;
  A2ILabelArr[7] := A2ILabel08;

  for i := 0 to high(A2ILabelArr) do
  begin
    A2ILabelArr[i].Tag := i;

  end;

  titleA2Image := TA2Image.Create(100, 26, 0, 0);

  pgkBmp.getBmp('组队信息120.bmp', titleA2Image);

    // titleA2Image.LoadFromFile('.\组队信息(大).bmp');
  A2ILabelTitle.A2Image := titleA2Image;
  A2ILabelTitle.Width := titleA2Image.Width;
  A2ILabelTitle.Height := titleA2Image.Height;
//    A2ILabelTitle.FBaseImage.Setsize(A2ILabelTitle.Width, A2ILabelTitle.Height);
  ClientWidth := A2ILabelTitle.Width;

    {DrawRectangle(titleA2Image, [$00A3E2E2, clYellow, $003DC5C5, $0058CDCD, $0082D9D9]);
    str := '组 队 信 息';

    fx := (titleA2Image.Width - ATextWidth(str)) div 2;
    fy := (titleA2Image.Height - ATextHeight(str)) div 2;
    ATextOut(titleA2Image, fx + 1, fy + 1, WinRGB(3, 3, 3), str);
    ATextOut(titleA2Image, fx, fy, ColorSysToDxColor(clOlive), str);
    }
end;

procedure TfrmProcessionList.FormDestroy(Sender: TObject);
begin
  titleA2Image.Free;
end;

procedure TfrmProcessionList.A2ILabelTitleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmProcessionList.A2ILabel01MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSELECTINDEX := TA2ILabel(Sender).Tag;

  frmProcession.buttonstate;

  frmProcessionButton.Visible := true;
  FrmM.SetA2Form(frmProcessionButton, A2form);
  frmProcessionButton.Top := y + Top + TA2ILabel(Sender).Top;
  frmProcessionButton.Left := x + Left + TA2ILabel(Sender).Left;
end;

procedure TfrmProcessionList.A2ILabelTitleClick(Sender: TObject);
begin

    {frmProcessionButton.Visible := true;
    frmProcession.buttonstate;
    FrmM.SetA2Form(Self, A2form);
    frmProcessionButton.Top := Top;
    frmProcessionButton.Left := Left;
    }
end;

procedure TfrmProcessionList.A2ILabelTitleDblClick(Sender: TObject);
begin
  boDrawList := not boDrawList;
  ListDrawItem;
end;

end.

