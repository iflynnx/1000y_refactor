unit EntBtn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TEventButton = class(TLabel)
  private
    FState: TButtonState;
    { Private declarations }
    function GetState: Boolean;
    procedure SetState (val: Boolean);
  protected
    { Protected declarations }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    { Public declarations }
  published
    property Down : Boolean read GetState write SetState;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Notang', [TEventButton]);
end;

function TEventButton.GetState: Boolean;
begin
   if FState = bsDown then Result := TRUE
   else Result := FALSE;
end;

procedure TEventButton.SetState (val: Boolean);
begin
   if val then FState := bsDown
   else FState := bsUp;
   Invalidate;
end;

procedure TEventButton.Paint;
var
   PaintRect : TRect;
   w, h: integer;
begin
   PaintRect := Rect (0, 0, Width, Height);

   case FState of
      bsDown: DrawEdge(Canvas.Handle, PaintRect, BDR_SUNKENOUTER, BF_RECT);
      bsUp:  DrawEdge(Canvas.Handle, PaintRect, BDR_RAISEDOUTER	, BF_RECT);
   end;
   h := Canvas.TextHeight (Caption);
   w := Canvas.TextWidth (Caption);
   SetBkMode(Canvas.Handle,1);
   Canvas.TextOut ((Width -w)div 2,(Height-h) div 2, Caption);
   SetBkMode(Canvas.Handle,0);
end;

procedure TEventButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   inherited MouseDown(Button, Shift, X, Y);
   if (Button = mbLeft) then begin
      if FState <> bsDown then begin
         FState := bsDown;
         Invalidate;
      end;
   end;
end;

procedure TEventButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
   inherited MouseMove(Shift, X, Y);
end;

procedure TEventButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FState := bsUp;
  Invalidate;
end;

end.
