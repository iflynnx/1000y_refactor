unit AnsBtn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons;

type
  TAnsBtn = class(TSpeedButton)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure Paint; override;
//    procedure Paint2;
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation
//    FState: TButtonState;

procedure Register;
begin
  RegisterComponents('Notang', [TAnsBtn]);
end;

procedure TAnsBtn.Paint;
var
   Temp : TButtonState;
begin
   Temp := FState;
//   if FState = bsDown then FState := bsDisabled;
   if FState = bsExclusive then begin
      FState := bsDown;
      inherited Paint;
   end else begin
      inherited Paint;
   end;
   FState := Temp;
end;
{
procedure TAnsBtn.Paint2;
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
  FillStyles: array[Boolean] of Integer = (BF_MIDDLE, 0);
var
  PaintRect: TRect;
  DrawFlags: Integer;
  Offset: TPoint;
begin
  if not Enabled then
  begin
    FState := bsDisabled;
    FDragging := False;
  end
  else if FState = bsDisabled then
    if FDown and (GroupIndex <> 0) then
      FState := bsExclusive
    else
      FState := bsUp;
  Canvas.Font := Self.Font;
  PaintRect := Rect(0, 0, Width, Height);
  if not FFlat then
  begin
    DrawFlags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
    if FState in [bsDown, bsExclusive] then
      DrawFlags := DrawFlags or DFCS_PUSHED;
    DrawFrameControl(Canvas.Handle, PaintRect, DFC_BUTTON, DrawFlags);
  end
  else
  begin
    if (FState in [bsDown, bsExclusive]) or
      (FMouseInControl and (FState <> bsDisabled)) or
      (csDesigning in ComponentState) then
      DrawEdge(Canvas.Handle, PaintRect, DownStyles[FState in [bsDown, bsExclusive]],
        FillStyles[FFlat] or BF_RECT);
    InflateRect(PaintRect, -1, -1);
  end;
  if FState in [bsDown, bsExclusive] then
  begin
    if (FState = bsExclusive) and (not FFlat or not FMouseInControl) then
    begin
      if Pattern = nil then CreateBrushPattern;
      Canvas.Brush.Bitmap := Pattern;
      Canvas.FillRect(PaintRect);
    end;
    Offset.X := 1;
    Offset.Y := 1;
  end
  else
  begin
    Offset.X := 0;
    Offset.Y := 0;
  end;
  TButtonGlyph(FGlyph).Draw(Canvas, PaintRect, Offset, Caption, FLayout, FMargin,
    FSpacing, FState, FFlat);
end;
}
end.
