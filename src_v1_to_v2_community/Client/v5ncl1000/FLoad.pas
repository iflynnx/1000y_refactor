unit FLoad;
//2015.12.14 在水一方 创建
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, jpeg, Math;

type
  TLoad = class(TForm)
    imgBack: TImage;
    imgProgress: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    starttick: DWORD;
  public
    { Public declarations }
  end;

var
  Load: TLoad;
  CloseLoad: Boolean;
  LoadStop: Boolean;

implementation

{$R *.DFM}

function MyFun(p: Pointer): Integer; stdcall; 
var
  ShowWidth, ShowPar: Integer;
  R: TRect;
begin
  while True do
  begin
    if CloseLoad then Break;
    Load.imgProgress.Canvas.Lock;
    ShowPar := (GetTickCount - Load.starttick)*100 div 1500;
    ShowWidth := max(Min(ShowPar, 100), 0) * Load.imgProgress.Width div 100;
    R := Rect(0,0,ShowWidth,Load.imgProgress.Height);
    Load.imgProgress.Canvas.FillRect(R);
    Load.imgProgress.Repaint;
    Load.imgProgress.Canvas.Unlock;
    Sleep(10);
    if ShowPar >= 100 then Break;
  end;
  LoadStop := True;
  Result := 0; 
end;

procedure TLoad.FormShow(Sender: TObject); 
var 
  ID: THandle;
begin
  imgProgress.Picture.Bitmap;
  imgProgress.Picture.Bitmap := TBitmap.Create;
  imgProgress.Picture.Bitmap.Width := imgProgress.Width;
  imgProgress.Picture.Bitmap.Height := imgProgress.Height;
  imgProgress.Canvas.Brush.Color := clBlack;
  imgProgress.Canvas.FillRect(imgProgress.Canvas.ClipRect);
  imgProgress.Canvas.Brush.Color := clGreen;
  starttick := GetTickCount;
  CreateThread(nil, 0, @MyFun, nil, 0, ID);
end;

end.
