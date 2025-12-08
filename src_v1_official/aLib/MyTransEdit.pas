unit BKTransparentEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
  TWM_BKInvalidate=WM_USER+1;

type
  TBKTransparentEdit = class(TEdit)
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
    //procedure DoExit; override;
    //procedure DoEnter; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Invalidate; override;

  published
    { Published declarations }
  end;

procedure Register;

implementation

constructor TBKTransparentEdit.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FTransparent:=true;
end;

procedure TBKTransparentEdit.CreateWnd;
begin
  inherited CreateWnd;
  if FTransparent then  begin
    SetWindowLong(Parent.Handle, GWL_STYLE,GetWindowLong(Parent.Handle, GWL_STYLE) and not WS_CLIPCHILDREN);
  end;
end;

procedure TBKTransparentEdit.BKInvalidate(var Message:TMessage);
var
  r:TRect;
begin
  if (Parent<>nil) and FTransparent then  begin
    r:=ClientRect;
    r.TopLeft:=Parent.ScreenToClient(ClientToScreen(r.TopLeft));
    r.BottomRight:=Parent.ScreenToClient(ClientToScreen(r.BottomRight));
    RedrawWindow(Handle,nil,0,RDW_FRAME+RDW_INVALIDATE);
  end;
end;

procedure TBKTransparentEdit.CNCTLCOLOREDIT(var Message:TWMCTLCOLOREDIT);
begin
  if FTransparent then
  with Message do
  begin
    SetBkMode(ChildDC,Windows.TRANSPARENT);
    Result:=GetStockObject(HOLLOW_BRUSH)
  end
  else
    inherited;
end;

procedure TBKTransparentEdit.WMEraseBkgnd(var Message:TWMERASEBKGND);
begin
  if FTransparent and not (csDesigning in ComponentState) then
    PostMessage(Handle,TWM_BKInvalidate,0,0)
  else
    inherited;
end;

procedure TBKTransparentEdit.WMMove(var message:TMessage);
begin
  inherited;
  if FTransparent then
    SendMessage(Handle,TWM_BKInvalidate,0,0)
  else
    Invalidate;
end;

procedure TBKTransparentEdit.CreateParams(var Params:TCreateParams);
begin
inherited CreateParams(Params);
  if (CsDesigning in ComponentState) then exit;
  with Params do
  begin
    ExStyle:=ExStyle or WS_EX_TRANSPARENT;
  end;
end;
{
procedure TBKTransparentEdit.DoExit;
begin
inherited;
   FTransparent:=true;
   SetCursor(0);
   RecreateWnd;
end;

procedure TBKTransparentEdit.DoEnter;
var
  exstyle,stdstyle:longint;
begin
  inherited;
  FTransparent:=false;
  StdStyle:= Windows.GetWindowLong(handle, GWL_EXSTYLE);
  exStyle:= StdStyle and not WS_EX_TRANSPARENT;
  Windows.SetWindowLong(handle, GWL_EXSTYLE, exStyle);
  invalidate;
end;
} 
procedure TBKTransparentEdit.Invalidate;
begin
  if FTransparent then
    SendMessage(Handle,TWM_BKInvalidate,0,0)
  else
    inherited;
end;

procedure Register;
begin
  RegisterComponents('BKTransparentComps', [TBKTransparentEdit]);
end;

end.


