unit BKTransparentEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
  TWM_BKInvalidate=WM_USER+1;

type
  TBKTransEdit = class(TEdit)
  private
    { Private declarations }
    procedure BKInvalidate(var Message:TMessage); message
              TWM_BKInvalidate;
    procedure CNCTLCOLOREDIT(var Message:TWMCTLCOLOREDIT); message
              CN_CTLCOLOREDIT;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
  protected
    { Protected declarations }
    FTransparent: boolean;
    procedure CreateWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoExit; override;
    procedure DoEnter; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Invalidate; override;

  published
    { Published declarations }
  end;

procedure Register;

implementation

constructor TBKTransEdit.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FTransparent:=true;
end;

procedure TBKTransEdit.CreateWnd;
begin
  inherited CreateWnd;
  if FTransparent then  begin
    SetWindowLong(Parent.Handle, GWL_STYLE,GetWindowLong(Parent.Handle, GWL_STYLE) and not WS_CLIPCHILDREN);
  end;
end;

procedure TBKTransEdit.BKInvalidate(var Message:TMessage);
var
  r:TRect;
begin
  if (Parent<>nil) and FTransparent then  begin
    r:=ClientRect;
    r.TopLeft:=Parent.ScreenToClient(ClientToScreen(r.TopLeft));
    r.BottomRight:=Parent.ScreenToClient(ClientToScreen(r.BottomRight));
    RedrawWindow (Handle,0,0,RDW_FRAME+RDW_INVALIDATE);
  end;
end;

procedure TBKTransEdit.CNCTLCOLOREDIT(var Message:TWMCTLCOLOREDIT);
begin
  with Message do begin
  if FTransparent then
  begin
     SetBkMode(ChildDC,Windows.TRANSPARENT);
     result := GetStockObject(HOLLOW_BRUSH);
  end
  else begin
     inherited;
  end;
  end;
end;

procedure TBKTransEdit.WMEraseBkgnd(var Message:TWMERASEBKGND);
begin
//  RecreateWnd;
  inherited;
  if FTransparent and not (csDesigning in ComponentState) then
  begin
    PostMessage(Handle,TWM_BKInvalidate,0,0);
  end else
    inherited;
end;

procedure TBKTransEdit.WMMove(var message:TMessage);
begin
  inherited;
  if FTransparent then
    SendMessage(Handle,TWM_BKInvalidate,0,0)
  else
    Invalidate;
end;

procedure TBKTransEdit.CreateParams(var Params:TCreateParams);
begin
inherited CreateParams(Params);
  if (CsDesigning in ComponentState) then exit;
  with Params do
  begin
    ExStyle:=ExStyle or WS_EX_TRANSPARENT;
  end;
end;

procedure TBKTransEdit.DoExit;
begin
inherited;
   FTransparent:=true;
   SetCursor(0);
   RecreateWnd;
end;

procedure TBKTransEdit.DoEnter;
var
  exstyle,stdstyle:longint;
begin
  inherited;
  FTransparent:=false;
  StdStyle:= Windows.GetWindowLong(handle, GWL_EXSTYLE);
  exStyle:= StdStyle;
  Windows.SetWindowLong(handle, GWL_EXSTYLE, exStyle);
  invalidate;
end;

procedure TBKTransEdit.Invalidate;
begin
  if FTransparent then
    SendMessage(Handle,TWM_BKInvalidate,0,0)
  else
    inherited;
end;

procedure Register;
begin
  RegisterComponents('MyBKTransEdit', [TBKTransEdit]);
end;

end.


