unit ADxForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, ExtCtrls, DsgnIntf, Forms,
  Graphics, Buttons, AnsImg2, DxDraws, AdxUtil, CommCtrl, comctrls;

const
   EDIT_TOGGLE_TIME = 500;

   IMG_LT     = 0;
   IMG_TOP    = 1;
   IMG_RT     = 2;
   IMG_LEFT   = 3;
   IMG_BODY   = 4;
   IMG_RIGHT  = 5;
   IMG_LB     = 6;
   IMG_BOTTOM = 7;
   IMG_RB     = 8;

   IMG_DOWN   = 9;
   IMG_UP     = 10;

   IMG_BLOCK_SIZE = 12;

   XCENTER = -12;



type
  TOnAdxPaint = procedure (aSurface: TDirectDrawSurface) of object;
  TShowMethod = (FSM_NONE, FSM_DITHER, FSM_DARKEN);

  TADxForm = class (TComponent)
  private
    Hintx, Hinty:integer;
    Hintstr : string;
    CurFrame : integer;
    FShowMethod : TShowMethod;
    boShowed : Boolean;

    ComponentList : TList;
    FSurface : TDirectDrawSurface;
    FImageSurface : TDirectDrawSurface;
    FDXDraw  : TDXDraw;
    FColor : TColor;
    FImageFileName : string;
    FAtzFileName : string;
    Ans2ImageLib : TAns2ImageLib;

    FTransParent : Boolean;

    FOnAdxPaint : TOnAdxPaint;
    FOnShow  : procedure (Sender: TObject) of object;
    FOnHide  : procedure (Sender: TObject) of object;

    FInitialize  : procedure (Sender: TObject) of object;

    bwidth, bheight : integer;
    procedure DXInitialize(Sender: TObject);

    procedure Show(Sender: TObject);
    procedure Hide(Sender: TObject);
    procedure DrawDispath;
    procedure TimerTimer (Sender: TObject);
    procedure DrawMsgWindow2 (aSurface: TDirectDrawSurface);
  protected
    procedure Loaded; override;
  public
    property Surface : TDirectDrawSurface read FSurface write FSurface;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint(aSurface: TDirectDrawSurface);
    procedure ShowHint (ax, ay:integer; Hstr:string);
  published
    property DXDraw : TDXDraw read FDXDraw write FDXDraw;
    property Color : TColor read FColor write FColor;
    property OnAdxPaint : TOnAdxPaint read FOnAdxPaint write FOnAdxpaint;
    property ImageFileName : string read FImageFileName write FImageFileName;
    property ShowMethod : TShowMethod read FShowMethod write FShowMethod;
    property AtzFileName : string read FAtzFileName write FAtzFileName;
    property TransParent : Boolean read FTransParent write FTransParent;
  end;

  TAdxLabel = class (TLabel)
  private
    boEntered : Boolean;
    FADXForm : TADXForm;
    procedure SetCaption (Value: string);
    function  GetCaption: string;
    procedure DoDrawText(var Rect: TRect; Flags: Word; aCanvas:TCanvas);
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Loaded; override;
    procedure paint; override;
  public
    procedure AdxPaint; dynamic;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
    property Caption : string read GetCaption write SetCaption;
  end;

  TADXImageLabel = class(TAdxlabel)
  private
   FImage : TAns2Image;
   FOnPaint : TOnAdxPaint;
   procedure SetImage (Value: TAns2Image);
  protected
    procedure AdxPaint; override;
  public
   property Image : TAns2Image  read FImage write SetImage;
   procedure Paint; override;
  published
   property OnPaint: TOnAdxPaint read FOnPaint write FOnPaint;
  end;

  TAdxImage = class (TImage)
  private
    FADXForm : TADXForm;
  protected
    procedure Loaded; override;
    procedure paint; override;
  public
    procedure AdxPaint;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
  end;

  TAdxEdit = class (TEdit)
  private
    OldText : string;
    boTail : Boolean;
    FTransParent : Boolean;
    FOnEnter : procedure (Sender: TObject) of object;
    FOnExit : procedure (Sender: TObject) of object;
    FOnChange : procedure (Sender: TObject) of object;
    FOnKeyDown : procedure (Sender: TObject; var Key: Word; Shift: TShiftState) of object;

    Timer : TTimer;
    FADXForm : TADXForm;
    procedure FocusEnter (Sender: TObject);
    procedure FocusExit (Sender: TObject);

    procedure TextChange (Sender: TObject);
    procedure SelfKeyDown (Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure TimerTimer (Sender: TObject);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
    property TransParent : Boolean read FTransParent write FTransParent;
  end;

  TAdxMemo = class (TMemo)
  private
    OldText : string;
    boTail : Boolean;
    FTransParent : Boolean;
    FLineMax : Integer;

    FOnEnter : procedure (Sender: TObject) of object;
    FOnExit : procedure (Sender: TObject) of object;
    FOnChange : procedure (Sender: TObject) of object;

    Timer : TTimer;
    FADXForm : TADXForm;
    procedure FocusEnter (Sender: TObject);
    procedure FocusExit (Sender: TObject);

    procedure TextChange (Sender: TObject);

    procedure TimerTimer (Sender: TObject);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
    property TransParent : Boolean read FTransParent write FTransParent;
    property LineMax : Integer read FLineMax write FLineMax;
  end;

  TOnAdxDrawItem = procedure (ASurface:TDirectDrawSurface; index:integer; Rect:TRect; State: Integer) of object;

  TAdxListBox = class (TListBox)
  private
    Ans2ImageLib : TAns2ImageLib;
    FAtzFileName : string;
    FADXForm : TADXForm;
    FTransParent : Boolean;
    FOnAdxDrawItem : TOnAdxDrawItem;
    procedure DrawScrollBar;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
    property OnAdxDrawItem: TOnAdxDrawItem read FOnAdxDrawItem write FOnAdxDrawItem;
    property TransParent : Boolean read FTransParent write FTransParent;
    property AtzFileName : string read FAtzFileName write FAtzFileName;
  end;

  TAdxButton = class (TSpeedButton)
  private
    boEntered : Boolean;
    FADXForm : TADXForm;
    FTransParent : Boolean;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
    property TransParent : Boolean read FTransParent write FTransParent;
  end;

  TAdxAnimateButton = class (TPanel)
  private
    Timer : TTimer;
    CurFrame : integer;
    boUpProcess : Boolean;
    FAtzImageCount : integer;
    FADXForm : TADXForm;
    Ans2ImageLib : TAns2ImageLib;
    FAtzFileName : string;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Loaded; override;
    procedure paint; override;
    procedure TimerTimer (Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
    property AtzFileName : string read FAtzFileName write FAtzFileName;
    property AtzImageCount : integer read FAtzImageCount write FAtzImageCount;
  end;

  TADXProgressBar = class (TADXLabel)
  private
    FMinValue : integer;
    FMaxValue : integer;
    FValue : integer;
    FPicture: TPicture;
    procedure SetPicture(Value: TPicture);
  protected
    procedure Loaded; override;
    procedure paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; override;
  published
    property Picture: TPicture read FPicture write SetPicture;
    property MinValue: integer read FMinValue write FMinValue;
    property MaxValue: integer read FMaxValue write FMaxValue;
    property Value: integer read FValue write FValue;
  end;

  TAdxAnimateImage = class (TPanel)
  private
    Timer : TTimer;
    CurFrame : integer;
    FAtzImageCount : integer;
    FADXForm : TADXForm;
    Ans2ImageLib : TAns2ImageLib;
    FAtzFileName : string;
  protected
    procedure Loaded; override;
    procedure paint; override;
    procedure TimerTimer (Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
  published
    property ADXForm : TADXForm read FADXForm write FADXForm;
    property AtzFileName : string read FAtzFileName write FAtzFileName;
    property AtzImageCount : integer read FAtzImageCount write FAtzImageCount;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('DelphiX', [TADxForm]);
  RegisterComponents('DelphiX', [TADxLabel]);
  RegisterComponents('DelphiX', [TADXImageLabel]);
  RegisterComponents('DelphiX', [TADxImage]);
  RegisterComponents('DelphiX', [TADxEdit]);
  RegisterComponents('DelphiX', [TADxMemo]);
  RegisterComponents('DelphiX', [TADxListBox]);
  RegisterComponents('DelphiX', [TADxButton]);
  RegisterComponents('DelphiX', [TADxAnimateButton]);
  RegisterComponents('DelphiX', [TADxAnimateImage]);
  RegisterComponents('DelphiX', [TADxProgressBar]);
end;

constructor TADXProgressBar.Create(AOwner: TComponent);
begin
   inherited Create (AOwner);
   FPicture := TPicture.Create;
   FADXForm := nil;
   FMinValue := 0;
   FMaxValue := 100;
   FValue := 0;
   Caption := '';
   Width := 100;
   Height := 20;
end;

destructor TADXProgressBar.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

procedure TADXProgressBar.Loaded;
begin
   inherited Loaded;
end;

procedure TADXProgressBar.paint;
begin
   inherited paint;
   Canvas.Draw (0, 0, FPicture.Graphic);
end;

procedure TADXProgressBar.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
  if FPicture.Graphic <> nil then begin
     Width := FPicture.Width;
     Height := FPicture.Height;
  end;
end;

procedure TADXProgressBar.AdxPaint;
var
   R : TRect;
begin
   if (csDesigning in ComponentState) or not Assigned (FADXForm) then exit;
   if not Visible then exit;
   R := ClientRect;
   OffsetRect (R, Left, Top);
   R.Right := R.Left + FValue*Width div FMaxValue;

   FADXForm.Surface.Canvas.StretchDraw (R, FPicture.Graphic);
   FADXForm.Surface.Canvas.Release;
end;


//////////////////////////////////////////
//     TADXAnimateButton : TLabel
//////////////////////////////////////////

constructor TADXAnimateButton.Create(AOwner: TComponent);
begin
   inherited Create (AOwner);
   FAtzFileName := '';
   Ans2ImageLib := TAns2ImageLib.Create;
   Caption := '';
   CurFrame := 0;
   boUpProcess := FALSE;
   if not (csDesigning in ComponentState) then begin
      Timer := TTimer.Create (AOwner);
      Timer.Enabled := TRUE;
      Timer.Interval := 80;
      Timer.OnTimer := TimerTimer;
   end;
end;

destructor TADXAnimateButton.Destroy;
begin
   Ans2ImageLib.Free;
   if not (csDesigning in ComponentState) then Timer.Free;
   inherited Destroy;
end;

procedure TADXAnimateButton.AdxPaint;
begin
   if (csDesigning in ComponentState) or not Assigned (FADXForm) then exit;
   if not Visible then exit;
   if Ans2ImageLib.count <> 0 then
      ADXDrawImage (FADXForm.Surface, Left, Top, Ans2ImageLib.Images[CurFrame], TRUE);
end;

procedure TADXAnimateButton.paint;
begin
   inherited paint;
   if ans2ImageLib.Count <> 0 then AnsDraw2Image (Canvas, 0,0,Ans2ImageLib[CurFrame]);
end;

procedure TADXAnimateButton.TimerTimer (Sender: TObject);
begin
   if boUpProcess then CurFrame := CurFrame + 1
   else CurFrame := CurFrame -1;

   if CurFrame > AtzImageCount-1 then CurFrame := AtzImagecount;
   if CurFrame < 0 then begin
      Timer.Enabled := FALSE;
      CurFrame := 0;
   end;
end;

procedure TADXAnimateButton.Loaded;
begin
   inherited Loaded;
   if FAtzFileName <> '' then begin
      Ans2ImageLib.LoadFromFile (FAtzFileName);
      if ans2Imagelib.count <> 0 then begin
         Width := Ans2ImageLib.Images[0].Width;
         Height := Ans2ImageLib.Images[0].Height;
      end;
   end;
end;

procedure TADXAnimateButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  boUpProcess := TRUE;
  Timer.Enabled := TRUE;
end;

procedure TADXAnimateButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  boUpProcess := FALSE;
end;

//////////////////////////////////////////
//     TADXAnimateImage : TLabel
//////////////////////////////////////////

constructor TADXAnimateImage.Create(AOwner: TComponent);
begin
   inherited Create (AOwner);
   FAtzFileName := '';
   Ans2ImageLib := TAns2ImageLib.Create;
   Caption := '';
   CurFrame := 0;
   if not (csDesigning in ComponentState) then begin
      Timer := TTimer.Create (AOwner);
      Timer.Enabled := TRUE;
      Timer.Interval := 100;
      Timer.OnTimer := TimerTimer;
   end;
end;

destructor TADXAnimateImage.Destroy;
begin
   Ans2ImageLib.Free;
   if not (csDesigning in ComponentState) then Timer.Free;
   inherited Destroy;
end;

procedure TADXAnimateImage.AdxPaint;
begin
   if (csDesigning in ComponentState) or not Assigned (FADXForm) then exit;
   if not Visible then exit;
   if Ans2ImageLib.count <> 0 then
      ADXDrawImage (FADXForm.Surface, Left, Top, Ans2ImageLib.Images[CurFrame], TRUE);
end;

procedure TADXAnimateImage.paint;
begin
   inherited paint;
   if ans2ImageLib.Count <> 0 then AnsDraw2Image (Canvas, 0,0,Ans2ImageLib[CurFrame]);
end;

procedure TADXAnimateImage.TimerTimer (Sender: TObject);
begin
   CurFrame := CurFrame + 1;
   if CurFrame > AtzImageCount-1 then CurFrame := 0;
end;

procedure TADXAnimateImage.Loaded;
begin
   inherited Loaded;
   if FAtzFileName <> '' then begin
      Ans2ImageLib.LoadFromFile (FAtzFileName);
      if ans2Imagelib.count <> 0 then begin
         Width := Ans2ImageLib.Images[0].Width;
         Height := Ans2ImageLib.Images[0].Height;
      end;
   end;
end;

//////////////////////////////////////////
//        TADXButton : TButton
//////////////////////////////////////////

constructor TAdxButton.Create(AOwner: TComponent);
begin
   inherited Create (AOwner);
   boEntered := FALSE;
end;

destructor TAdxButton.Destroy;
begin
   inherited Destroy;
end;

procedure TAdxButton.CMMouseEnter(var Message: TMessage);
begin
   inherited;
   boEntered := TRUE;
end;

procedure TAdxButton.CMMouseLeave(var Message: TMessage);
begin
   inherited;
   boEntered := FALSE;
end;

procedure TAdxButton.Loaded;
begin
   inherited Loaded;
end;

procedure TAdxButton.AdxPaint;   // tbutton
const
  DownStyles: array[Boolean] of Integer = (BDR_RAISEDINNER, BDR_SUNKENOUTER);
  FillStyles: array[Boolean] of Integer = (BF_MIDDLE, 0);
var
   R: TRect;
begin
   if not Visible then exit;

   Canvas.Font := Self.Font;
   R := ClientRect;
   OffsetRect (R, Left,Top);

   with FADXForm.Surface.Canvas do begin
      if not Transparent then begin
         Brush.Color := clBlack;
         Brush.Style := bsSolid;
         FillRect(R);
      end;
      R.Left := R.Left + 1;
      R.Top := R.Top +1;
      R.Right := R.Right -1;
      R.Bottom := R.Bottom -1;

      if not Transparent then begin
         Brush.Color := Self.Color;
         Brush.Style := bsSolid;
         FillRect(R);
      end;

      if FState <> bsDown then begin
         if Flat then begin
            if boEntered then DrawEdge(Handle, R, BDR_RAISEDINNER, BF_RECT);
         end else DrawEdge(Handle, R, BDR_RAISEDINNER, BF_RECT);
         if Caption <> '' then
            DrawText(Handle, PChar(Caption), Length(Caption), R, DT_CENTER	or DT_VCENTER or DT_SINGLELINE	);
      end else begin
         DrawEdge(Handle, R, BDR_SUNKENINNER, BF_RECT);
         OffsetRect (R, 1, 1);
         if Caption <> '' then
            DrawText(Handle, PChar(Caption), Length(Caption), R, DT_CENTER	or DT_VCENTER or DT_SINGLELINE	);
      end;
   end;
   FADXForm.Surface.Canvas.Release;
end;

//////////////////////////////////////////
//            TADXListBox : TListBox
//////////////////////////////////////////

procedure Ans2ImageToBitmap (var Bmp: TBitMap; AnsImage: TAns2Image; aCanvas:TCanvas);
var
   BmpInfo: PBitmapInfo;
   HeaderSize: Integer;
begin
   HeaderSize := SizeOf(TBitmapInfo) + (256 * SizeOf(TRGBQuad));
   BmpInfo := AllocMem(HeaderSize);

   with BmpInfo^.bmiHeader do begin
      biSize := SizeOf(TBitmapInfoHeader);
      biWidth := AnsImage.Width;
      biHeight := -AnsImage.Height;
      biPlanes := 1;
      biBitCount := 16;
      biCompression := BI_RGB;
      biSizeImage := 0;
      biClrUsed := 0;
      biClrImportant := 0;
   end;

   Bmp.Handle := CreateDIBitmap(aCanvas.Handle, BmpInfo^.bmiHeader, 0, Pointer(0), BmpInfo^, DIB_PAL_COLORS);
   SetDIBits( aCanvas.Handle, Bmp.Handle, 0, AnsImage.Height, AnsImage.Bits, BmpInfo^, 0);
   if Bmp.Handle = 0 then raise Exception.Create('CreateDIBitmap failed');
   FreeMem(BmpInfo, HeaderSize);
end;

constructor TAdxListBox.Create(AOwner: TComponent);
begin
   inherited Create (AOwner);
   FAtzFileName := '';
   Ans2ImageLib := TAns2ImageLib.Create;
end;

destructor  TAdxListBox.Destroy;
begin
   Ans2ImageLib.Free;
   inherited Destroy;
end;

procedure   TAdxListBox.Loaded;
begin
   inherited loaded;
   if (csDesigning in ComponentState) or not Assigned (FAdxForm) then exit;
   if FAtzFileName <> '' then Ans2ImageLib.LoadFromFile (FAtzFileName);
end;

procedure   TAdxListBox.DrawScrollBar;
var
   i, h, t : integer;
   R, RB : TRect;
begin
   if Width = ClientRect.Right - ClientRect.Left then exit;
   R := ClientRect;
   OffsetRect (R, Left, Top);
   for i := 1 to Height div 16-1 do
      ADXDrawImage (FADXForm.Surface, R.Right, R.Top+i*16, Ans2ImageLib.Images[2], FALSE);

   ADXDrawImage (FADXForm.Surface, R.Right, R.Top, Ans2ImageLib.Images[0], FALSE);
   ADXDrawImage (FADXForm.Surface, R.Right, R.Bottom-16, Ans2ImageLib.Images[1], FALSE);

   h := (Height div ItemHeight) * (Height-32) div Items.Count -4;

   t := TopIndex * (Height-32) div Items.Count;

   RB.Top := R.Top + 16+t;
   RB.Left := R.Right;
   RB.Right := R.Right + 16;
   RB.Bottom := R.Top + 16 + h+t;

   for i := 1 to (RB.Bottom-RB.Top) div 16-1 do
      ADXDrawImage (FADXForm.Surface, RB.Left, RB.Top+i*16, Ans2ImageLib.Images[4], FALSE);

   ADXDrawImage (FADXForm.Surface, RB.Left, RB.Top, Ans2ImageLib.Images[3], FALSE);
   ADXDrawImage (FADXForm.Surface, RB.Left, RB.Bottom-16, Ans2ImageLib.Images[5], FALSE);
end;

procedure   TAdxListBox.AdxPaint;
var
   i : integer;
   str : string;
   R : TRect;
   State : Integer;
   FColor, BColor: TColor;
begin // TListbox
   if (csDesigning in ComponentState) or not Assigned (FAdxForm) then exit;
   if not Visible then exit;
   DrawScrollBar;

   R := ClientRect;
   OffsetRect (R, Left, Top);
   with FADXForm.Surface.Canvas do begin
      if not Transparent then begin
         Brush.Color := Self.Color;
         Brush.Style := bsSolid;
         FillRect(R);
      end;
   end;
   FADXForm.Surface.Canvas.Font := Font;
   FADXForm.Surface.Canvas.Brush := Canvas.Brush;
   FADXForm.Surface.Canvas.Brush.Color := Color;
   FADXForm.Surface.Canvas.Brush.Style := bsClear;

   FColor := FADXForm.Surface.Canvas.Font.Color;
   BColor := FADXForm.Surface.Canvas.Brush.Color;

   for i := TopIndex to Items.Count -1 do begin
      R.Bottom := R.Top + ItemHeight;
      if R.Bottom > Height + Top then break;
      if Assigned (FOnAdxDrawItem) then begin
         if i = ItemIndex then State := 1
         else State := 0;
         FOnAdxDrawItem ( FAdxForm.Surface, i, R, State);
      end else begin
         with FADXForm.Surface.Canvas do begin
            str := Items[i];
            if i = ItemIndex then begin
               Font.Color := BColor;
               Brush.Color := FColor;
               if Transparent then Brush.Style := bsClear
               else begin
                  Brush.Color := clActiveCaption;
                  Brush.Style := bsSolid;
                  FillRect(R);
               end;
               DrawText(Handle, PChar(str), Length(str), R, 64);
               Font.Color := FColor;
               Brush.Color := BColor;
            end else begin
               if Transparent then Brush.Style := bsClear
               else begin
                  Brush.Color := Self.Color;
                  Brush.Style := bsSolid;
                  FillRect(R);
               end;
               DrawText(Handle, PChar(str), Length(str), R, 64);
            end;
         end;
      end;
      R.Top := R.Top + ItemHeight;
   end;
   FADXForm.Surface.Canvas.Release;
end;


//////////////////////////////////////////
//            TADXForm
//////////////////////////////////////////

constructor TADxForm.Create(AOwner: TComponent);
begin
  	inherited Create(AOwner);
   ComponentList := TList.Create;

   FAtzFileName := '';
   Ans2ImageLib := TAns2ImageLib.Create;
   bwidth := 0; bheight := 0;

   boShowed := FALSE;

   FColor := 0;
   FSurface := nil;
   FImageSurface := nil;
   FDXDraw := nil;
   FInitialize := nil;
   CurFrame := 4;

end;

destructor TADxForm.Destroy;
begin
   if FSurface <> nil then FSurface.Free;
   if FImageSurface <> nil then FImageSurface.Free;
   ComponentList.Free;
   inherited Destroy;
end;

procedure TADxForm.ShowHint (ax, ay:integer; Hstr:string);
begin
   Hintx := ax; Hinty := ay; Hintstr := hstr;
end;

procedure TADxForm.Loaded;
var
   i : integer;
   compo : TComponent;
begin
   inherited Loaded;
   if not ( csDesigning in ComponentState) and Assigned (FDxDraw) then begin

      if FAtzFileName <> '' then begin
         Ans2ImageLib.LoadFromFile (FAtzFileName);
         if ans2Imagelib.count <> 0 then begin
            bwidth := Ans2ImageLib.Images[0].Width;
            bheight := Ans2ImageLib.Images[0].Height;
            Ans2ImageLib.TransparentColor := 31;
         end;
      end;

      FOnShow := TForm (Owner).OnShow;
      FOnHide := TForm (Owner).OnHide;
      TForm (Owner).OnShow := Show;
      TForm (Owner).OnHide := Hide;

      FInitialize := FDxDraw.OnInitialize;
      FDxDraw.OnInitialize := DXInitialize;

      ComponentList.Clear;
      for i := 0 to Owner.ComponentCount -1 do begin
         Compo := Owner.Components[i];
         if Compo is TAdxanimateImage      then ComponentList.Add (Compo);
         if Compo is TAdxanimateButton     then ComponentList.Add (Compo);
         if Compo is TAdxButton     then ComponentList.Add (Compo);
         if Compo is TAdxListbox    then ComponentList.Add (Compo);
         if Compo is TAdxMemo       then ComponentList.Add (Compo);
         if Compo is TAdxEdit       then ComponentList.Add (Compo);
         if Compo is TADXImageLabel then ComponentList.Add (Compo);
         if Compo is TAdxLabel      then ComponentList.Add (Compo);
         if Compo is TAdxImage      then ComponentList.Add (Compo);
         if Compo is TAdxProgressBar then ComponentList.Add (Compo);
      end;

   end;
end;

procedure TADXForm.DXInitialize(Sender: TObject);
begin
   if not ( csDesigning in ComponentState) and Assigned (FDxDraw) then begin
      if FImageFileName <> '' then begin
         FImageSurface := TDirectDrawSurface.Create(FDXDraw.DDraw);
         FImageSurface.LoadFromFile (FImageFileName);
//         FImageSurface.TransparentColor := ARGB (0,0,31);
      end;

      FSurface := TDirectDrawSurface.Create(FDXDraw.DDraw);
      FSurface.SetSize (TForm(Owner).Width, TForm(Owner).Height);
//      FSurface.TransparentColor := ARGB (0, 0, 31);
      FSurface.Fill (FColor);
   end;
   if assigned (FInitialize) then FInitialize (Sender);
end;

procedure TADXForm.Show(Sender: TObject);
begin
   if assigned (FOnShow) then FOnShow (Sender);
   boShowed := TRUE;
   DrawDispath;
end;

procedure TADXForm.Hide(Sender: TObject);
begin
   boShowed := FALSE;
   if assigned (FOnHide) then FOnHide (Sender);
//   CurFrame := 4;
end;

procedure TADXForm.DrawDispath;
var
   i : integer;
   Compo : TComponent;
begin
   for i := 0 to ComponentList.Count -1 do begin
      compo := ComponentList[i];
      if Compo is TAdxanimateImage then TAdxanimateImage(Compo).adxPaint;
      if Compo is TAdxanimateButton then TAdxanimateButton(Compo).adxPaint;
      if Compo is TAdxButton then TADXButton(Compo).adxPaint;
      if Compo is TAdxListBox then TADXListBox(Compo).adxPaint;
      if Compo is TAdxMemo then TADXMemo(Compo).adxPaint;
      if Compo is TAdxEdit then TADXEdit(Compo).adxPaint;
      if Compo is TADXImageLabel then TADXImageLabel(Compo).adxPaint;
      if Compo is TAdxLabel then TADXLabel(Compo).adxPaint;
      if Compo is TAdxImage then TAdxImage (Compo).adxpaint;
      if Compo is TAdxProgressBar then TAdxProgressBar (Compo).adxpaint;
   end;
   if assigned (FOnAdxPaint) then FOnAdxPaint (FSurface);
end;

procedure TADxForm.TimerTimer (Sender: TObject);
begin
   if FShowMethod = FSM_NONE then exit;

   if boShowed then CurFrame := CurFrame - 1
   else CurFrame := CurFrame + 1;

   if CurFrame > 4 then CurFrame := 4;
   if CurFrame < 0 then begin
      CurFrame := 0;
   end;
end;

procedure TADXForm.DrawMsgWindow2 (aSurface: TDirectDrawSurface);
var
   i, j, xblock, yblock: integer;
begin

   xblock := aSurface.Width div IMG_BLOCK_SIZE+1;
   yblock := aSurface.Height div IMG_BLOCK_SIZE+1;

   with aSurface do begin
      for j :=0 to yblock-1 do begin
         for i := 0 to xblock-1 do begin
            ADXDrawImage (aSurface, i*IMG_BLOCK_SIZE, j*IMG_BLOCK_SIZE, ans2ImageLib.Images[IMG_BODY], FALSE);
         end;
      end;

      for i:=0 to xblock-1 do begin
         ADXDrawImage (aSurface, i*IMG_BLOCK_SIZE, 0, ans2ImageLib.Images[IMG_TOP], FALSE);
         ADXDrawImage (aSurface, i*IMG_BLOCK_SIZE, (aSurface.Height-IMG_BLOCK_SIZE), ans2ImageLib.Images[IMG_BOTTOM], FALSE);
      end;
      for i:=0 to yblock-1 do begin
         ADXDrawImage (aSurface, 0, i*IMG_BLOCK_SIZE, ans2ImageLib.Images[IMG_LEFT], FALSE);
         ADXDrawImage (aSurface, (aSurface.Width-IMG_BLOCK_SIZE), i*IMG_BLOCK_SIZE, ans2ImageLib.Images[IMG_RIGHT], FALSE);
      end;

      ADXDrawImage (aSurface, 0, 0, ans2ImageLib.Images[IMG_LT], FALSE);
      ADXDrawImage (aSurface, (aSurface.Width-IMG_BLOCK_SIZE), 0, ans2ImageLib.Images[IMG_RT], FALSE);
      ADXDrawImage (aSurface, 0, (aSurface.Height-IMG_BLOCK_SIZE), ans2ImageLib.Images[IMG_LB], FALSE);
      ADXDrawImage (aSurface, (aSurface.Width-IMG_BLOCK_SIZE), (aSurface.Height-IMG_BLOCK_SIZE), ans2ImageLib.Images[IMG_RB], FALSE);
   end;
end;

procedure TADXForm.AdxPaint(aSurface: TDirectDrawSurface);
var
   w : integer;
   R: TRect;
begin
   Hintstr := '';

   TimerTimer(self);
   if boShowed then begin

      if Assigned (FImageSurface) then FSurface.Draw (0, 0, FImageSurface.ClientRect, FImageSurface, FALSE)
      else FSurface.Fill (FColor);

      if FAtzFileName <> '' then DrawMsgWindow2 (FSurface);

      DrawDispath;

      case FShowMethod of
         FSM_NONE  : aSurface.Draw (TForm(Owner).Left, TForm(Owner).Top, FSurface.ClientRect, FSurface, FTransparent);
         FSM_DITHER: ADCDrawDitherSurface (aSurface, TForm(Owner).Left, TForm(Owner).Top, FSurface, CurFrame, FTransparent);
         FSM_DARKEN: ADCDrawDarkenSurface (aSurface, TForm(Owner).Left, TForm(Owner).Top, FSurface);
      end;
      if HintStr <> '' then begin
         w := aSurface.Canvas.TextWidth(HintStr);

         R := Rect (Hintx, Hinty-10, Hintx + w, Hinty+6);
         OffsetRect (R, TForm(Owner).Left, TForm(Owner).Top);

         aSurface.Canvas.Font.Color := clBlack;
         DrawText(aSurface.Canvas.Handle, PChar(Hintstr), Length(Hintstr), R, 64);

         OffsetRect (R, -1, -1);
         aSurface.Canvas.Font.Color := clWhite;
         DrawText(aSurface.Canvas.Handle, PChar(Hintstr), Length(Hintstr), R, 64);
         aSurface.Canvas.Release;
      end;


   end else begin
      if CurFrame <> 4 then begin
         if Assigned (FImageSurface) then FSurface.Draw (0, 0, FImageSurface.ClientRect, FImageSurface, FALSE)
         else FSurface.Fill (FColor);

         if FAtzFileName <> '' then DrawMsgWindow2 (FSurface);

         DrawDispath;

         case FShowMethod of
            FSM_NONE  : aSurface.Draw (TForm(Owner).Left, TForm(Owner).Top, FSurface.ClientRect, FSurface, FTransparent);
            FSM_DITHER: ADCDrawDitherSurface (aSurface, TForm(Owner).Left, TForm(Owner).Top, FSurface, CurFrame, FTransparent);
            FSM_DARKEN: ADCDrawDarkenSurface (aSurface, TForm(Owner).Left, TForm(Owner).Top, FSurface);
         end;
      end;
   end;
end;

//////////////////////////////////////////
//            TADXLabel
//////////////////////////////////////////

procedure TADXLabel.CMMouseEnter(var Message: TMessage);
begin
   boEntered := TRUE;
end;

procedure TADXLabel.CMMouseLeave(var Message: TMessage);
begin
   boEntered := FALSE;
end;

procedure TADXLabel.SetCaption (Value: string);
begin
   inherited Caption := Value;
   boEntered := FALSE;
   AdxPaint;
end;

function  TADXLabel.GetCaption: string;
begin
   Result := inherited Caption;
end;

procedure TADXLabel.DoDrawText(var Rect: TRect; Flags: Word; aCanvas: TCanvas);
var Text: string;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
    (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  aCanvas.Font := Font;

  if not Enabled then
  begin
    OffsetRect(Rect, 1, 1);
    aCanvas.Font.Color := clBtnHighlight;
    DrawText(aCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
    OffsetRect(Rect, -1, -1);
    aCanvas.Font.Color := clBtnShadow;
    DrawText(aCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  end
  else DrawText(aCanvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

procedure TADXLabel.AdxPaint;
const
  Alignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
  WordWraps: array[Boolean] of Word = (0, DT_WORDBREAK);
var
  R: TRect;
  DrawStyle: Integer;
begin
   if (csDesigning in ComponentState) or not Assigned (FADXForm) then exit;
   if not Visible then exit;

   with FADXForm.Surface.Canvas do begin
      R := ClientRect;
      OffsetRect(R, left, top);
      if not Transparent then begin
         Brush.Color := Self.Color;
         Brush.Style := bsSolid;
         FillRect(R);
      end;
      Brush.Style := bsClear;
      DrawStyle := DT_EXPANDTABS or WordWraps[WordWrap] or Alignments[Alignment];
      if Layout <> tlTop then begin
         DoDrawText(R, DrawStyle or DT_CALCRECT, FADXForm.Surface.Canvas );
         if Layout = tlBottom then OffsetRect(R, 0, Height - R.Bottom)
         else OffsetRect(R, 0, (Height - R.Bottom) div 2);
       end;
       DoDrawText(R, DrawStyle, FADXForm.Surface.Canvas);
   end;
   FADXForm.Surface.Canvas.Release;

   if (Hint <> '') and boEntered then begin
       FADXForm.ShowHint (Left, Top, Hint);
   end;

end;

procedure TADXLabel.paint;
begin
   inherited paint;
end;

procedure TADXLabel.Loaded;
begin
   inherited Loaded;
end;

//////////////////////////////////////////
//            TADXImage
//////////////////////////////////////////

procedure TADXImage.AdxPaint;
begin
   if (csDesigning in ComponentState) or not Assigned (FADXForm) then exit;
   if not Visible then exit;
   FADXForm.Surface.Canvas.Draw (Left, Top, Picture.Bitmap);
   FADXForm.Surface.Canvas.Release;
end;

procedure TADXImage.paint;
begin
   inherited paint;
end;

procedure TADXImage.Loaded;
begin
   inherited Loaded;
end;

//////////////////////////////////////////
//            TADXImageLabel
//////////////////////////////////////////

procedure TADXImageLabel.SetImage (Value: TAns2Image);
begin
   FImage := Value;
end;

procedure TADXImageLabel.Paint;
begin
//   Inherited Paint;
end;

procedure TADXImageLabel.AdxPaint;
var
   x, y: integer;
begin
   if not Visible then exit;
   if (csDesigning in ComponentState) or not Assigned (FADXForm) then exit;

   if assigned (FImage) then begin
      x := (Width - FImage.Width) div 2;
      y := (Height - FImage.Height) div 2;
//      AnsDraw2Image ( FADXForm.Surface.Canvas,Left+x, Top+y, FImage);
//      FADXForm.Surface.Canvas.Release;
      ADXDrawImage (FADXForm.Surface, Left+x, Top+y, FImage, TRUE);
   end;

   if (Hint <> '') and boEntered then begin
       FADXForm.ShowHint (Left, Top, Hint);
   end;

   if assigned (FOnPaint) then begin
      FOnPaint(FADXForm.Surface);
      FADXForm.Surface.Canvas.Release;
   end;
   inherited AdxPaint;
end;

//////////////////////////////////////////
//            TADXIEdit
//////////////////////////////////////////

constructor TAdxEdit.Create(AOwner: TComponent);
begin
   inherited Create (AOwner);

   OldText := '';
   if not (csDesigning in ComponentState) then begin
      Timer := TTimer.Create (AOwner);
      Timer.Enabled := TRUE;
      Timer.Interval := 400;
      Timer.OnTimer := TimerTimer;
   end;
end;

destructor TAdxEdit.Destroy;
begin
   if not (csDesigning in ComponentState) then Timer.Free;
   inherited Destroy;
end;

procedure TAdxEdit.AdxPaint;
var
   i : integer;
   str : string;
   R : TRect;
begin // TEdit
   if not Visible then exit;
   if not Assigned (FADXForm) then exit;
   
   with FADXForm.Surface.Canvas do begin
      R := ClientRect;
      OffsetRect(R, left, top);
      if not Transparent then begin
         Brush.Color := Self.Color;
         Brush.Style := bsSolid;
         FillRect(R);
      end;
      Brush.Style := bsClear;
      Font := Self.Font;

      if TextWidth (text) > Width-8 then begin
         text := OldText;
         SelStart := Length(text);
      end else OldText := text;

      str := text;

      if passwordchar <> char(0) then begin
         for i := 1 to Length(str) do str[i] := passwordchar;
      end;

      if boTail then begin
         str := Copy (str, 1, SelStart);
         str := str + '&' + Copy (text, SelStart+1, Length(text));
      end;
      DrawText(Handle, PChar(str), Length(str), R, DT_VCENTER or DT_SINGLELINE);
   end;
   FADXForm.Surface.Canvas.Release;
   if SelLength <> 0 then begin
      SelStart := SelStart + SelLength;
      Sellength := 0;
   end;
end;

procedure TAdxEdit.TimerTimer (Sender: TObject);
var fh : THandle;
begin
   fh := GetFocus;
   if Handle = fh then begin
      boTail := not boTail;
      AdxPaint;
   end else begin
      FocusExit(self);
   end;
end;

procedure TAdxEdit.FocusEnter (Sender: TObject);
begin
   TimerTimer(self);
   boTail := TRUE;
   Adxpaint;
   if assigned (FOnEnter) then FOnEnter (Sender);
end;

procedure TAdxEdit.FocusExit (Sender: TObject);
begin
   boTail := FALSE;
   Adxpaint;
   if assigned (FOnExit) then FOnExit (Sender);
end;

procedure TAdxEdit.TextChange (Sender: TObject);
begin
   AdxPaint;
   if assigned (FOnChange) then FOnChange (Sender);
end;

procedure TAdxEdit.SelfKeyDown (Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (key = VK_LEFT) or (key = VK_RIGHT) or (key = VK_UP) or (key = VK_DOWN) then AdxPaint;
   if assigned (FOnKeyDown) then FOnKeyDown (Sender, Key, Shift);
end;

procedure TAdxEdit.Loaded;
begin
   inherited loaded;
   if not (csDesigning in ComponentState) then begin
      FOnEnter := OnEnter;
      FOnExit := OnExit;
      FOnChange := OnChange;
      FOnKeyDown := OnKeyDown;

      OnEnter := FocusEnter;
      OnExit := FocusExit;
      OnChange := TextChange;
      OnKeyDown := SelfKeyDown;
   end;
end;

//////////////////////////////////////////
//            TADXMemo
//////////////////////////////////////////

constructor TAdxMemo.Create(AOwner: TComponent);
begin
   inherited Create (AOwner);
   FLineMax := 4;
   OldText :='';
   WordWrap := FALSE;
   if not (csDesigning in ComponentState) then begin
      Timer := TTimer.Create (AOwner);
      Timer.Enabled := FALSE;
      Timer.Interval := 400;
      Timer.OnTimer := TimerTimer;
   end;
end;

destructor TAdxMemo.Destroy;
begin
   if not (csDesigning in ComponentState) then Timer.free;
   inherited Destroy;
end;

procedure TAdxMemo.AdxPaint;
var
   i : integer;
   flag : Boolean;
   str : string;
   R : TRect;
begin // TMemo
   if not Visible then exit;
   with FADXForm.Surface.Canvas do begin
      R := ClientRect;
      OffsetRect(R, left, top);
      if not Transparent then begin
         Brush.Color := Self.Color;
         Brush.Style := bsSolid;
         FillRect(R);
      end;
      Brush.Style := bsClear;
      Font := Self.Font;

      flag := FALSE;
      for i := 0 to Lines.Count -1 do if TextWidth (Lines[i]) > Width-8 then flag := TRUE;
      if FLineMax < Lines.Count then flag := TRUE;

      if flag then begin text := OldText; SelStart := Length(text); end
      else OldText := text;

      str := text;
      if boTail then begin
         str := Copy (text, 1, SelStart);
         str := str + '&' + Copy (text, SelStart+1, Length(text));
      end;
      DrawText(Handle, PChar(str), Length(str), R, 64);
   end;
   FADXForm.Surface.Canvas.Release;
   if SelLength <> 0 then begin
      SelStart := SelStart + SelLength;
      Sellength := 0;
   end;
end;

procedure TAdxMemo.TimerTimer (Sender: TObject);
begin
   boTail := not boTail;
   AdxPaint;
end;

procedure TAdxMemo.FocusEnter (Sender: TObject);
begin
   Timer.Enabled := TRUE;
   boTail := TRUE;
   Adxpaint;
   if assigned (FOnEnter) then FOnEnter (Sender);
end;

procedure TAdxMemo.FocusExit (Sender: TObject);
begin
   Timer.Enabled := FALSE;
   boTail := FALSE;
   Adxpaint;
   if assigned (FOnExit) then FOnExit (Sender);
end;

procedure TAdxMemo.TextChange (Sender: TObject);
begin
   AdxPaint;
   if assigned (FOnChange) then FOnChange (Sender);
end;

procedure TAdxMemo.Loaded;
begin
   inherited loaded;
   if not (csDesigning in ComponentState) then begin
      FOnEnter := OnEnter;
      FOnExit := OnExit;
      FOnChange := OnChange;
      OnEnter := FocusEnter;
      OnExit := FocusExit;
      OnChange := TextChange;
   end;
end;

end.
