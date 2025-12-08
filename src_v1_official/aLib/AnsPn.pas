unit AnsPn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons;

type
  TAnsPn = class(TPanel)
  private
    FImage : TImage;
    { Private declarations }
    procedure SetImage (img: TImage);
    function  GetImage: TImage;
  protected
    { Protected declarations }
    procedure Paint; override;
  public
    procedure WMEraseBkGnd(var Message: TMessage); message WM_ERASEBKGND;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  published
    property Image: TImage read GetImage write SetImage;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Notang', [TAnsPn]);
end;

constructor TAnsPn.Create(AOwner: TComponent);
begin
   inherited Create (AOWner);
   FImage := nil;
end;

destructor TAnsPn.Destroy;
begin
   inherited Destroy;
end;

procedure TAnsPn.WMEraseBkGnd(var Message: TMessage);
var ps : TPaintStruct;
   r : Trect;
begin
   BeginPaint (handle, Ps);
   EndPaint (handle, Ps);
   r := ClientRect;
   InvalidateRect(handle, @r, FALSE);
end;

procedure TAnsPn.SetImage (img: TImage);
begin
   FImage := img;
end;

function  TAnsPn.GetImage: TImage;
begin
   Result := FImage;
end;

procedure TAnsPn.Paint;
begin
   if csDesigning in ComponentState then inherited Paint;

   if  not (csDesigning in ComponentState) then
      if Assigned (FImage) then
         if Assigned (FImage.picture.Bitmap) then
            Canvas.Draw (-Left,-Top,FImage.Picture.Bitmap);
end;

end.
