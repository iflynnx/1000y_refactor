unit FEnergy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, A2Img, ExtCtrls, StdCtrls, deftype, cltype;

const
   Image_Max_Count = 5;
   Delay_Tick = 15;
   Image_Total_Count = 75;

type
  TFrmEnergy = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    ImageLib: TA2ImageLib;
    FFrameIndex: integer;
    FLevel: integer;
    FTick : integer;

  public
    procedure SetLevel(aName: string; aLevel: word; CurTick: integer);
    procedure EnergyDraw (CurTick: integer);
    procedure changeBack();
  end;

const
   ArrFrameIndex: array[1..13,0..1] of integer =
      (( 0,  4), ( 5,  9), (10, 14), (15, 19), (20, 24), (25, 29),
       (30, 34), (35, 39), (40, 44), (45, 49), (50, 54),
       (55, 64), (65, 74));

var
  FrmEnergy: TFrmEnergy;

implementation

uses FMain, FAttrib, FLogOn;

{$R *.DFM}

procedure TFrmEnergy.changeBack;
 begin
   if G_Default800 then
      begin
         Top := 467
      end else
      begin
         Top := 635;
      end;

end;

procedure TFrmEnergy.FormCreate(Sender: TObject);
begin
   Parent := FrmM;

   Color := clBlack;

   Left := 378;  //600 296 800 378   1024
   if G_Default800 then
      begin
         Top := 467;
      end else
      begin
         Top := 635;
      end;
     //Top := 467;   //  Top := 634    467

   Height := 36;  Width := 36;
   FLevel := 0;
   FFrameIndex := Image_Total_Count;

   ImageLib := TA2ImageLib.Create;
   ImageLib.LoadFromFile ('ect\energy10.atz');
   FTick := 0;
end;

procedure TFrmEnergy.FormDestroy(Sender: TObject);
begin
   ImageLib.Free;
end;

procedure TFrmEnergy.SetLevel(aName: string; aLevel: word; CurTick: integer);
begin
   Hint := aName;
   MouseInfoStr := Conv (aName);
   FLevel := aLevel;
   FTick := CurTick;
   if FLevel > 0 then
      FFrameIndex := ArrFrameIndex[FLevel, 0]//(FLevel-1) * Image_Max_Count
   else
      FFrameIndex := Image_Total_Count;
end;

procedure TFrmEnergy.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   FillChar (GrobalClick, sizeof(GrobalClick), 0);

   with GrobalClick do begin
      rmsg    := CM_CLICK;
      rwindow := WINDOW_POWERLEVEL;
      if Button = mbLeft  then rkey := 0;
      if Button = mbRight then rkey := 1;
   end;
end;

procedure TFrmEnergy.EnergyDraw (CurTick: integer);
var
   tmpImg : TA2Image;
begin
   if not Self.Visible then Self.Visible := True;
   if ImageLib.Count < Image_Total_Count+1 then exit;

   if FLevel = 0 then begin
      try
         tmpImg := ImageLib.Images [ImageLib.Count-1];  // ¾øÀ¸¶§
         A2DrawImage (Canvas, 0, 0, tmpImg);
      except
      end;
   end else if CurTick > FTick + Delay_Tick then begin
      FTick := CurTick;
      try
         tmpImg := ImageLib.Images [FFrameIndex];
         A2DrawImage (Canvas, 0, 0, tmpImg);
      except
      end;
      
      inc (FFrameIndex);
      if FFrameIndex > ArrFrameIndex[FLevel, 1] then
         FFrameIndex := ArrFrameIndex[FLevel, 0];
   end;
end;

end.

