unit ILabel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AnsImg2;

type
  TILabel = class(TLabel)
  private
   FBColor : word;
   FImage : TAns2Image;
   BaseImage : TAns2Image;
   FOnPaint : TNotifyEvent;
   FGreenCol : integer;
   FGreenadd : integer;
   procedure SetImage (Value: TAns2Image);
   procedure Setcolor (Value: word);
  protected
  public
   constructor Create (Owner: TComponent); override;
   destructor Destroy; override;
   procedure Paint; override;
   procedure Draw;
   property  BColor : word read FBColor write SetColor;
  published
   property Image : TAns2Image  read FImage write SetImage;
   property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
   property GreenCol : integer read FGreenCol write FGreenCol;
   property GreenAdd : integer read FGreenAdd write FGreenAdd;
  end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('notang', [TILabel]);
end;

constructor TILabel.Create (Owner: TComponent);
begin
   inherited Create (Owner);
   BaseImage := nil;
   FBColor := 0;
   FGreenCol := 0;
   FGreenadd := 0;
end;

destructor TILabel.Destroy;
begin
   if BaseImage = nil then BaseImage.Free;
   inherited Destroy;
end;

procedure TILabel.SetImage (Value: TAns2Image);
begin
   FImage := Value;
   if BaseImage <> nil then begin BaseImage.Free; BaseImage := nil; end;
   if Fimage <> nil then BaseImage := TAns2Image.Create (Width, Height, 0, 0);
   Draw;
end;

procedure TILabel.Setcolor (Value: word);
begin
   FBColor := Value;
   Draw;
end;

procedure TILabel.Paint;
var x, y: integer;
begin
   Inherited Paint;
   if assigned (FImage) then begin
      BaseImage.Clear (FBColor);
      x := (Width - FImage.Width) div 2;
      y := (Height - FImage.Height) div 2;

      if FGreenCol = 0 then
         BaseImage.DrawImage (FImage, x, y, TRUE)
      else
         BaseImage.DrawImageGreenConvert (FImage, x, y, FGreenCol, FGreenAdd);

      AnsDraw2Image ( Canvas, 0, 0, BaseImage);
   end;
   if assigned (FOnPaint) then FOnPaint(self);
end;

procedure TILabel.Draw;
var x, y: integer;
begin
   Inherited Paint;
   if assigned (FImage) then begin
      BaseImage.Clear (FBColor);
      x := (Width - FImage.Width) div 2;
      y := (Height - FImage.Height) div 2;
      if FGreenCol = 0 then
         BaseImage.DrawImage (FImage, x, y, TRUE)
      else
         BaseImage.DrawImageGreenConvert (FImage, x, y, FGreenCol, FGreenAdd);
      AnsDraw2Image ( Canvas, 0, 0, BaseImage);
   end;
   if assigned (FOnPaint) then FOnPaint(self);
end;

end.
