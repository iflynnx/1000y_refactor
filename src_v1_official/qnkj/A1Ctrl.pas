unit A1Ctrl;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, ExtCtrls, Forms,
  Graphics, Buttons, A1Img, CommCtrl, Comctrls, A1imgutil;

const
   EDIT_TOGGLE_TIME = 300;

type
  TA1Object = class;
  TA1Form = class;

  TA1Screen = class (TGraphicControl) //(TCustomControl)//
  private
    FMouseX, FMouseY: integer;
    FSurface : TA1Image;
    A1FormList : TList;
    FCaptureObject: TA1Object;
    FCaptureObjectLeft, FCaptureObjectTop: integer;

    FHintR : TRect;
    FHintStr : string;
    FEnteredObject : TA1Object;
    FTimer : TTimer;
    procedure TimerOnTimer (Sender: TObject);
  protected
    procedure Click; override;
    procedure DblClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Loaded; override;
    procedure Paint; override;
  public
    property Surface : TA1Image read FSurface write FSurface;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DrawImagebyChild (aImage: TA1Image; x, y: integer; aTrans: Boolean);   // Clild 컨트롤이 자신을 그림
    procedure DrawHintbyChild (aObject: TA1Object; aHintR: TRect; aHintStr: string);
    procedure AddA1Form (aForm : TA1Form);
    procedure A1Paint;
    procedure A1SetCapture (Sender: TA1Object; aLeft, aTop: integer);
    procedure A1ReleaseCapture;
    procedure A1SetTopForm (aForm: TA1Form);
  published
    property Color;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property MouseX : integer read FMouseX;
    property MouseY : integer read FMouseY;
  end;

  TA1Object = class (TCustomControl)//(TGraphicControl)
  private
    FSurface : TA1Image;                   // Canvas;
    FTransParent : Boolean;
    FColorIndex : integer;

    FFontColor : TColor;
    FFontColorIndex : integer;
    FHint: string;
    FDisible : Boolean;

    function  GetColor: TColor;
    procedure SetColor (Value: TColor);
    procedure SetFontColor (Value: TColor);

  protected
    FA1Form : TA1Form;
    FEntered : Boolean;
    procedure Click; override;
    procedure DblClick; override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseEnter; dynamic;
    procedure CMMouseLeave; dynamic;

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   A1Paint; dynamic;
    procedure TimerOnTimer; dynamic;
    property Disible : Boolean read FDisible write FDisible;
  published
    property FontColor : TColor read FFontColor write SetFontColor;
    property TransParent: Boolean read FTransParent write FTransParent;
    property Color : TColor read GetColor write SetColor;
    property Hint : string read FHint write FHint;

    property Visible;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnEnter;
    property OnExit;
  end;

  TA1Form = class (TA1Object)
  private
    FOnShow : TNotifyEvent;
    FOnHide : TNotifyEvent;
    FMouseX, FMouseY: integer;
    FA1Screen : TA1Screen;
    FBackImage : TA1Image;
    FFileName : string;
    ObjectList : TList;
    procedure SetFileName (Value: string);
    function  GetVisible: Boolean;
    procedure SetVisible (Value: Boolean);

  protected
    procedure Click; override;
    procedure DblClick; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure Loaded; override;
    procedure Paint; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure A1Paint; override;
    procedure DrawImagebyChild (aImage: TA1Image; x, y: integer; aTrans: Boolean);   // Clild 컨트롤이 자신을 그림
    procedure DrawHintbyChild (aObject: TA1Object; aHintR: TRect; aHintStr: string);
    procedure A1SetCapture (Sender: TA1Object; aLeft, aTop: integer);
    procedure A1ReleaseCapture;
    procedure TimerOnTimer; override;
  published
    property A1Screen : TA1Screen read FA1Screen write FA1Screen;
    property FileName : string read FFileName write SetFileName;
    property Visible : Boolean read GetVisible write SetVisible;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
  end;

  TAlignment = (taCenter, taLeftJustify, taRightJustify);

  TA1Label = class (TA1Object)
  private
    FCaption : string;
    FAlignment : TAlignment;
    procedure SetCaption (Value: string);
    procedure SetAlignment (Value: TAlignment);
    function  GetAlignX: integer;
  protected
    procedure Loaded; override;
    procedure paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure  A1Paint; override;
  published
    property A1Form : TA1Form read FA1Form write FA1Form;
    property Caption : string read FCaption write SetCaption;
    property Alignment : TAlignment read FAlignment write SetAlignment;
  end;

  TA1Picture = class (TA1Object)
  private
    FBitmap : TBitmap;
    FPictureImage : TA1Image;
    FAutoSize : Boolean;
    FCount : integer;
    FDisPlay: integer;
    procedure SetBitmap (Value: TBitmap);
    procedure SetAutoSize (Value: Boolean);
    procedure SetDisPlay (Value: integer);
    procedure SetCount (Value: integer);
  protected
    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure A1Paint; override;
  published
    property A1Form : TA1Form read FA1Form write FA1Form;
    property Bitmap : TBitmap read FBitmap write SetBitmap;

    property AutoSize : Boolean read FAutoSize write SetAutoSize;
    property DisPlay : integer read FDisplay write SetDisplay;
    property Count : integer read FCount write SetCount;
  end;

  TA1Edit = class;

  TA1EditMain = class (TEdit)
  private
    Timer : TTimer;
    DataList : TList;
    CurA1Edit : TA1Edit;
    procedure TimerOnTimer (Sender : TObject);
  protected
    procedure Loaded; override;
    procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddA1Edit (aEdit: TA1Edit);
    procedure SetA1Focus (aEdit: TA1Edit);
  end;

  TKeyDownUpEvent = procedure (Sender: TObject; var Key: Word; Shift: TShiftState) of object;
  TKeyPressEvent = procedure (Sender: TObject; var Key: Char) of object;

  TA1Edit = class (TA1Object)
  private
    FText : string;
    FA1EditMain : TA1EditMain;
    FOnKeyDown : TKeyDownUpEvent;
    FOnKeyUp : TKeyDownUpEvent;
    FOnKeyPress : TKeyPressEvent;

    FOnEnter : TNotifyEvent;
    FOnExit : TNotifyEvent;


    FMaxLength : integer;
    FPasswordChar : Char;

    FTextHeight : integer;

    procedure SetText (Value: string);
    procedure SetA1EditMain (Value: TA1EditMain);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    procedure Click; override;
    procedure Loaded; override;
    procedure paint; override;
  public
    Active : Boolean;
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure  A1Paint; override;
    procedure  SetFocus; override;
  published
    property A1EditMain : TA1EditMain read FA1EDitMain write SetA1EditMain;
    property A1Form : TA1Form read FA1Form write FA1Form;
    property Text : string read FText write SetText;

    property MaxLength : integer read FMaxLength write FMaxLength;
    property PasswordChar : Char read FPasswordChar write FPasswordChar;

    property OnKeyDown: TKeyDownUpEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TKeyDownUpEvent read FOnKeyUp write FOnKeyUp;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;

    property OnEnter : TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit : TNotifyEvent read FOnExit write FOnExit;
  end;

  TA1Button = class (TA1Object)
  private
    FDown : Boolean;
    FCaptured : Boolean;
    FBitmap : TBitmap;
    FPictureImage : TA1Image;
    FAutoSize : Boolean;
    procedure SetBitmap (Value: TBitmap);
    procedure SetAutoSize (Value: Boolean);

  protected
    procedure Loaded; override;
    procedure Paint; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure A1Paint; override;
  published
    property A1Form : TA1Form read FA1Form write FA1Form;
    property Bitmap : TBitmap read FBitmap write SetBitmap;

    property AutoSize : Boolean read FAutoSize write SetAutoSize;
    property Disible : Boolean read FDisible write FDisible;
  end;

  TA1RectButton = class
  private
  public
  end;

  TA1ListBox = class (TA1Object)
  private
    FListItems : TStringList;
    FItemIndex : integer;
    FIndexTop : integer;

    FItemHeight : integer;
    FBevelWidth : integer;

    FDown : Boolean;
    FCaptured : Boolean;

    FBtnUp: TA1Image;
    FBtnDown: TA1Image;
    FTrackBar : TA1Image;

    FBackImage : TA1BitmapImage;
    FBtnImage : TA1BitmapImage;
    FTrackImage : TA1BitmapImage;
    procedure SetBitmapBtn (Value: TBitmap);
    procedure SetBitmapTrack (Value: TBitmap);
    procedure SetBitmapBack (Value: TBitmap);
    function  GetBitmapBack: TBitmap;
    function  GetBitmapBtn: TBitmap;
    function  GetBitmapTrack: TBitmap;
    procedure DrawItems;
  protected
    procedure Loaded; override;
    procedure Paint; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure A1Paint; override;
  published
    property A1Form : TA1Form read FA1Form write FA1Form;
    property BitmapBack : TBitmap read GetBitmapBack write SetBitmapBack;
    property BitmapBtn : TBitmap read GetBitmapBtn write SetBitmapBtn;
    property BitmapTrack : TBitmap read GetBitmapTrack write SetBitmapTrack;

    property ItemHeight : integer read FItemHeight write FItemHeight;
    property BevelWidth : integer read FBevelWidth write FBevelWidth;

    property Items : TStringList read FListItems write FListItems;

  end;

  TA1CheckBox = class (TA1Object)
  private
    FCaption : string;
    FChecked : Boolean;
    FImage: TA1BitmapImage;
    function  GetImage: TBitmap;
    procedure SetImage (Value : TBitmap);
    procedure SetCaption (Value: string);
  protected
    procedure Click; override;
    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure A1Paint; override;
  published
    property Image : TBitmap read GetImage write SetImage;
    property Caption : string read FCaption write SetCaption;
    property A1Form : TA1Form read FA1Form write FA1Form;
    property Checked : Boolean read FChecked write FChecked;
  end;

  TA1TrackBar = class (TA1Object)
  private
    FCaptured: Boolean;
    FBevelWidth : integer;
    FTrackImage: TA1BitmapImage;
    FBarImage: TA1BitmapImage;
    FPosition : integer;
    FMax: integer;
    function  GetTrackImage: TBitmap;
    procedure SetTrackImage (Value : TBitmap);
    function  GetBarImage: TBitmap;
    procedure SetBarImage (Value : TBitmap);
    procedure SetMax (Value: integer);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure A1Paint; override;
  published
    property TrackImage : TBitmap read GetTrackImage write SetTrackImage;
    property BarImage : TBitmap read GetBarImage write SetBarImage;
    property Position : integer read FPosition write FPosition;
    property Max : integer read FMax write SetMax;
    property BevelWidth : integer read FBevelWidth write FBevelWidth;
    property A1Form : TA1Form read FA1Form write FA1Form;
  end;

  TOrientation = (Horizontal, Vertical);

  TA1ProgressBar = class (TA1Object)
  private
    FProgressImage: TA1BitmapImage;
    FPosition : integer;
    FMax: integer;
    FOrientation: TOrientation;
    function  GetProgressImage: TBitmap;
    procedure SetProgressImage (Value : TBitmap);
    procedure SetMax (Value: integer);
  protected
    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure A1Paint; override;
  published
    property Image : TBitmap read GetProgressImage write SetProgressImage;
    property Position : integer read FPosition write FPosition;
    property Max : integer read FMax write SetMax;
    property Orientation : TOrientation read FOrientation write FOrientation;
    property A1Form : TA1Form read FA1Form write FA1Form;
  end;

  TA1ICon = class (TA1Object)
  private
    FImage : TA1Image;
  protected
    procedure Loaded; override;
    procedure paint; override;
  public
    TempCount : integer;
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure  A1Paint; override;
    property Image: TA1Image read FImage write FImage;
  published
    property A1Form : TA1Form read FA1Form write FA1Form;
  end;

  TOnSamiMemoDrawItem = procedure (SurFace: TA1Image; Index: integer; Rect: TRect) of object;

  TA1SamiMemo = class (TA1Object)
  private
    FListItems : TStringList;
    FItemHeight : integer;
    FOnDrawItem : TOnSamiMemoDrawItem;
    procedure DrawItems;
  protected
    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;
    procedure A1Paint; override;
  published
    property A1Form : TA1Form read FA1Form write FA1Form;
    property Items : TStringList read FListItems write FListItems;
    property ItemHeight : integer read FItemHeight write FItemHeight;
    property OnDrawItem : TOnSamiMemoDrawItem read FOnDrawItem write FOnDrawItem;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('A1Ctrl', [TA1Screen, TA1Form, TA1Label, TA1Picture,
     TA1Edit, TA1EditMain, TA1Button, TA1ListBox, TA1CheckBox, TA1TrackBar,
     TA1ProgressBar, TA1Icon, TA1SamiMemo]);
end;

function InArea (aLeft, aTop, aWidth, aHeight, Ax, Ay: integer): Boolean;
begin
   Result := FALSE;
   if aLeft > AX then exit;
   if ATop > AY then exit;
   if ALeft+AWidth < AX then exit;
   if ATop+AHeight < AY then exit;
   Result := TRUE;
end;


//////////////////////////////////////////
//            TA1SemiMemo
//////////////////////////////////////////

constructor TA1SamiMemo.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   FListItems := TStringList.Create;
   FItemHeight := 14;
end;

destructor TA1SamiMemo.Destroy;
begin
   FListItems.Free;
   inherited Destroy;
end;

procedure TA1SamiMemo.Loaded;
begin
   inherited Loaded;
end;

procedure TA1SamiMemo.DrawItems;
var
   i, n: integer;
   R : TRect;
begin
   n := (Height div FItemHeight);
   if FListItems.Count > n then FListItems.Delete (0);

   if csDesigning in ComponentState then begin
      for i := 0 to FListItems.Count -1 do
         A1TextOut (FSurface, 0, i * FItemHeight, FFontColorIndex, FListItems[i]);
   end else begin
      for i := 0 to FListItems.Count -1 do begin
         if Assigned (FOnDrawItem) then begin
            R := Rect (0, i * FItemHeight, Width, (i+1)*FItemHeight);
            FOnDrawItem (FSurface, i, R);
         end else A1TextOut (FSurface, 0, i * FItemHeight, FFontColorIndex, FListItems[i]);
      end;
   end;
end;

procedure TA1SamiMemo.Paint;
begin
   inherited Paint;
   if csDesigning in ComponentState then begin
      DrawItems;
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1SamiMemo.A1Paint;
begin
   inherited A1Paint;
   if not (csDesigning in ComponentState) then begin
      if not Assigned (FA1Form) then exit;
      DrawItems;
      FA1Form.DrawImagebyChild (FSurface, Left, Top, FTransParent);
   end;
end;

//////////////////////////////////////////
//            TA1Icon
//////////////////////////////////////////

constructor TA1Icon.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 32; Height := 32;
  FImage := nil;
end;

destructor TA1Icon.Destroy;
begin
  inherited destroy;
end;

procedure TA1Icon.Loaded;
begin
   inherited Loaded;
end;

procedure TA1Icon.paint;
begin
   inherited paint;
   if csDesigning in ComponentState then begin
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1Icon.A1Paint;
begin
   if csDesigning in ComponentState then begin
   end else begin
      if Assigned (FA1Form) then begin
         if FImage <> nil then
            FSurface.DrawImage (FImage, Width div 2 - FImage.Width div 2, Height div 2 - FImage.Height div 2, TRUE);
         FA1Form.DrawImagebyChild (FSurface, Left, Top, FTransParent);
      end;
   end;
end;


/////////////////////////////////
//         A1ProgressBar
/////////////////////////////////

constructor TA1ProgressBar.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   FProgressImage := TA1BitmapImage.Create;
   FOrientation := Horizontal;
   FPosition := 0;
   FMax := 100;
end;

destructor TA1ProgressBar.Destroy;
begin
   FProgressImage.Free;
   inherited Destroy;
end;

function  TA1ProgressBar.GetProgressImage: TBitmap;
begin
   Result := FProgressImage.Bitmap;
end;

procedure TA1ProgressBar.SetProgressImage (Value : TBitmap);
begin
   FProgressImage.Bitmap := Value;
end;

procedure TA1ProgressBar.SetMax (Value: integer);
begin
   if Value < 10 then exit;
   if Value > 1000000 then exit;
   FMax := Value;
end;

procedure TA1ProgressBar.Loaded;
begin
   inherited Loaded;
   FProgressImage.Bitmap := FProgressImage.Bitmap;
end;

procedure TA1ProgressBar.Paint;
var
   xx : integer;
   TempImage : TA1Image;
begin
   inherited Paint;
   if csDesigning in ComponentState then begin
      FSurface.DrawImage (FProgressImage, 0, 0, FALSE);

      case FOrientation of
         Horizontal:
            begin
               xx := FPosition * Width div FMax;
               if xx >= 4 then begin
                  TempImage := TA1Image.Create (xx, FProgressImage.Height, 0, 0);
                  FProgressImage.Getmage (TempImage, FProgressImage.Width div 2, 0, FALSE);
                  FSurface.DrawImage (TempImage, 0, 0, FALSE);
                  TempImage.Free;
               end;
            end;
         Vertical:
            begin
               xx := FPosition * Height div FMax;
               if xx >= 4 then begin
                  TempImage := TA1Image.Create (FProgressImage.Width div 2, xx, 0, 0);
                  FProgressImage.Getmage (TempImage, FProgressImage.Width div 2, FProgressImage.Height - xx, FALSE);
                  FSurface.DrawImage (TempImage, 0, FProgressImage.Height - xx, FALSE);
                  TempImage.Free;
               end;
            end;
      end;
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1ProgressBar.A1Paint;
var
   xx: integer;
   TempImage : TA1Image;
begin
   if Assigned (FA1Form) then begin
      FSurface.DrawImage (FProgressImage, 0, 0, FALSE);

      case FOrientation of
         Horizontal:
            begin
               xx := FPosition * Width div FMax;
               if xx >= 4 then begin
                  TempImage := TA1Image.Create (xx, FProgressImage.Height, 0, 0);
                  FProgressImage.Getmage (TempImage, FProgressImage.Width div 2, 0, FALSE);
                  FSurface.DrawImage (TempImage, 0, 0, FALSE);
                  TempImage.Free;
               end;
            end;
         Vertical:
            begin
               xx := FPosition * Height div FMax;
               if xx >= 4 then begin
                  TempImage := TA1Image.Create (FProgressImage.Width div 2, xx, 0, 0);
                  FProgressImage.Getmage (TempImage, FProgressImage.Width div 2, FProgressImage.Height - xx, FALSE);
                  FSurface.DrawImage (TempImage, 0, FProgressImage.Height - xx, FALSE);
                  TempImage.Free;
               end;
            end;
      end;


      FA1Form.DrawImagebyChild (FSurface, Left, Top, FALSE);
   end;
end;



/////////////////////////////////
//         A1TrackBar
/////////////////////////////////


constructor TA1TrackBar.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   FTrackImage := TA1BitmapImage.Create;
   FBarImage := TA1BitmapImage.Create;
   FPosition := 0;
   FMax := 100;
   FCaptured := FALSE;
end;

destructor TA1TrackBar.Destroy;
begin
   FBarImage.Free;
   FTrackImage.Free;
   inherited Destroy;
end;

function  TA1TrackBar.GetTrackImage: TBitmap;
begin
   Result := FTrackImage.Bitmap;
end;
procedure TA1TrackBar.SetTrackImage (Value : TBitmap);
begin
   FTrackImage.Bitmap := Value;
end;
function  TA1TrackBar.GetBarImage: TBitmap;
begin
   Result := FBarImage.Bitmap;
end;
procedure TA1TrackBar.SetBarImage (Value : TBitmap);
begin
   FBarImage.Bitmap := Value;
end;

procedure TA1TrackBar.SetMax (Value: integer);
begin
   if Value < 10 then exit;
   if Value < 100000 then exit;
   FMax := Value;
end;

procedure TA1TrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var TrackWidth: integer;
begin
   inherited MouseDown(Button, Shift, X, Y);
   if Assigned (FA1Form) then FA1Form.A1SetCapture (Self, Left, Top);
   FCaptured := TRUE;

   TrackWidth := Width - FBevelWidth * 2 - FBarImage.Width;
   if X < (FBevelWidth + FbarImage.Width div 2) then exit;
   if X > (Width - FBevelWidth + FbarImage.Width div 2) then exit;
   FPosition := (x-FBevelWidth-FBarImage.Width div 2) * Max div TrackWidth;
   if FPosition > FMax then FPosition := FMax;
end;

procedure TA1TrackBar.MouseMove(Shift: TShiftState; X, Y: Integer);
var TrackWidth: integer;
begin
   inherited MouseMove (Shift, X, Y);
   if FCaptured then begin
      TrackWidth := Width - FBevelWidth * 2 - FBarImage.Width;
      if X < (FBevelWidth + FbarImage.Width div 2) then exit;
      if X > (Width - FBevelWidth + FbarImage.Width div 2) then exit;
      FPosition := (x-FBevelWidth-FBarImage.Width div 2) * Max div TrackWidth;
      if FPosition > FMax then FPosition := FMax;

      if InArea (0, 0, Width, Height, X, Y) then begin
      end else begin
      end;
   end;
end;

procedure TA1TrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   inherited MouseUp(Button, Shift, X, Y);
   if FCaptured then begin
      if Assigned (FA1Form) then FA1Form.A1ReleaseCapture;
      FCaptured := FALSE;
   end;
end;

procedure TA1TrackBar.Loaded;
begin
   inherited Loaded;
   FTrackImage.Bitmap := FTrackImage.Bitmap;
   FBarImage.Bitmap := FBarImage.Bitmap;
end;
procedure TA1TrackBar.Paint;
var TrackWidth, xx : integer;
begin
   inherited Paint;
   if csDesigning in ComponentState then begin
      FSurface.DrawImage (FTrackImage, 0, 0, FALSE);

      TrackWidth := Width - FBevelWidth * 2 - FBarImage.Width;
      xx := FPosition * TrackWidth div Fmax;
      FSurface.DrawImage (FBarImage, FBevelWidth+xx, 0, TRUE);
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;
procedure TA1TrackBar.A1Paint;
var TrackWidth, xx : integer;
begin
   if Assigned (FA1Form) then begin
      FSurface.DrawImage (FTrackImage, 0, 0, FALSE);

      TrackWidth := Width - FBevelWidth * 2 - FBarImage.Width;
      xx := FPosition * TrackWidth div Fmax;
      FSurface.DrawImage (FBarImage, FBevelWidth+xx, 0, TRUE);
      FA1Form.DrawImagebyChild (FSurface, Left, Top, FALSE);
   end;
end;


/////////////////////////////////
//         A1CheckBox
/////////////////////////////////

constructor TA1CheckBox.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   FCaption := '';
   FChecked := FALSE;
   FImage := TA1BitmapImage.Create;
end;

destructor TA1CheckBox.Destroy;
begin
   FImage.Free;
   inherited Destroy;
end;
procedure TA1CheckBox.SetCaption (Value: string);
begin
   FCaption := Value;
end;
function  TA1CheckBox.GetImage: TBitmap;
begin
   Result := FImage.Bitmap;
end;
procedure TA1CheckBox.SetImage (Value : TBitmap);
begin
   FImage.Bitmap := Value;
end;
procedure TA1CheckBox.Loaded;
begin
   inherited Loaded;
   FImage.Bitmap := FImage.Bitmap;
end;
procedure TA1CheckBox.Paint;
begin
   inherited Paint;
   if csDesigning in ComponentState then begin
      if FChecked then begin
         FSurface.DrawImage (FImage, 0, 0, TRUE);
      end else begin
         FSurface.DrawImage (FImage, -FImage.Width div 2, 0, TRUE);
      end;
      A1TextOut (FSurface, 0, 0, FFontcolorIndex, FCaption);
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1CheckBox.Click;
begin
   inherited Click;
   FChecked := not FChecked;
end;

procedure TA1CheckBox.A1Paint;
begin
   if csDesigning in ComponentState then begin
   end else begin
      if Assigned (FA1Form) then begin
         if FChecked then begin
            FSurface.DrawImage (FImage, 0, 0, FALSE);
         end else begin
            FSurface.DrawImage (FImage, -FImage.Width div 2, 0, FALSE);
         end;

         A1TextOut (FSurface, 0, 0, FFontColorIndex, FCaption);
         FA1Form.DrawImagebyChild (FSurface, Left, Top, FALSE);
      end;
   end;
end;

////////////////////////////////
//   A1ListBox
////////////////////////////////

constructor TA1ListBox.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   Width := 128; Height := 128;

   FBackImage := TA1BitmapImage.Create;

   FBtnImage := TA1BitmapImage.Create;
   FTrackImage := TA1bitmapImage.Create;

   FBtnUp := TA1Image.Create (4, 4, 0, 0);
   FBtnDown := TA1Image.Create (4, 4, 0, 0);
   FTrackBar := TA1Image.Create (4, 4, 0, 0);

   FListItems := TStringList.Create;

   FItemIndex := 0; FIndexTop := 0;
   FItemHeight := 16; FBevelWidth := 4;

   FDown := FALSE;
   FCaptured := FALSE;
end;

destructor TA1ListBox.Destroy;
begin
   FListItems.Free;

   FBtnUp.Free;
   FBtnDown.Free;
   FTrackBar.Free;

   FTrackImage.Free;
   FBtnImage.Free;
   FBackImage.Free;
   inherited Destroy;
end;

procedure TA1ListBox.SetBitmapBtn (Value: TBitmap);
begin
   FBtnImage.Bitmap := Value;
end;

procedure TA1ListBox.SetBitmapTrack (Value: TBitmap);
begin
   FTrackImage.Bitmap := Value;
end;

function  TA1ListBox.GetBitmapBack: TBitmap;
begin
   Result := FBackImage.Bitmap;
end;

function  TA1ListBox.GetBitmapBtn: TBitmap;
begin
   Result := FBtnImage.Bitmap;
end;

function  TA1ListBox.GetBitmapTrack: TBitmap;
begin
   Result := FTrackImage.Bitmap;
end;

procedure TA1ListBox.SetBitmapBack (Value: TBitmap);
begin
   FBackImage.Bitmap := Value;
end;

procedure TA1ListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   procedure Check;
   var hcnt : integer;
   begin
      hcnt := (Height - 2*FBevelWidth) div FItemHeight;

      if FIndexTop+hcnt >= FListItems.Count then FIndexTop := FListItems.Count - hcnt;
      if FIndexTop < 0 then FIndexTop := 0;

      if FItemIndex < 0 then FItemIndex := 0;
      if FItemIndex >= FListItems.Count then FItemIndex := FListItems.Count -1;
      if FIndexTop + hcnt <= FItemIndex then FIndexTop := FItemIndex-hcnt+1;
      if FIndexTop > FItemIndex then FIndexTop := FItemIndex;
   end;
var
   hcnt, center, cn, ch, trackheight : integer;
begin
   inherited MouseDown (Button, Shift, X, Y);

   if FListItems.Count = 0 then exit;
   hcnt := (Height - 2*FBevelWidth) div FItemHeight;

   if (x > Width - FTrackBar.Width) and (x < Width) then begin
      if (y > 0) and (y < FBtnUp.Height) then begin FItemIndex := FItemIndex - 1; check; exit; end;
      if (y > Height-FBtnDown.Height) and (y < Height) then begin FItemIndex := FItemIndex + 1; check; exit; end;

      if FListItems.Count <= hcnt then exit;

      trackheight := Height - FBtnUp.Height*3;

      ch := (FItemIndex) * TrackHeight div (FListItems.count-1);   // ListItmes.Count : FItemIndex =  100 : x   백분율 100=>TrackHeight;
      center := FBtnUp.Height + ch + FTrackBar.Height div 2;

      if (y > FBtnUp.Height) and (y < center) then begin
         FItemIndex := FItemIndex - hcnt;
         FIndexTop := FIndexTop - hcnt;
      end;
      if (y > center) and (y < Height -FBtnDown.Height) then begin
         FItemIndex := FItemIndex + hcnt;
         FIndexTop := FIndexTop + hcnt;
      end;
      Check;
      exit;
   end;


   if ((y-FBevelWidth) div FItemHeight) >= FListItems.Count then exit;
   if ((y-FBevelWidth) div FItemHeight) < 0 then exit;

   cn := (y div FItemHeight);
   if cn > hcnt-1 then cn := hcnt-1;

   FItemIndex := FIndexTop + cn;

   Check;
end;

procedure TA1ListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
   inherited MouseMove (Shift, X, Y);
end;

procedure TA1ListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   inherited MouseUp (Button, Shift, X, Y);
end;

procedure TA1ListBox.Loaded;
begin
   inherited Loaded;
   FBackImage.Bitmap := FBackImage.Bitmap;
   FTrackImage.Bitmap := FTrackImage.Bitmap;
   FBtnImage.Bitmap := FBtnImage.Bitmap;

   if not FBtnImage.Empty then begin
      FBtnUP.ReCanvas (FBtnImage.Width div 3, FBtnImage.Height);
      FBtnDown.ReCanvas (FBtnImage.Width div 3, FBtnImage.Height);
      FTrackBar.ReCanvas (FBtnImage.Width div 3, FBtnImage.Height);

      FBtnImage.Getmage (FBtnUp, 0, 0, FALSE);
      FBtnImage.Getmage (FBtnDown, FBtnDown.Width, 0, FALSE);
      FBtnImage.Getmage (FTrackBar, FBtnDown.Width*2, 0, FALSE);
   end;
end;

procedure TA1ListBox.DrawItems;
var
   i, ch, yy: integer;
   TempImage : TA1Image;
   hcnt : integer;
   trackheight: integer;
begin
   hcnt := (Height - 2*FBevelWidth) div FItemHeight;
   yy := FBevelWidth;
   TempImage := TA1Image.Create (Width-16-FBevelWidth, ItemHeight, 0, 0);
   for i := FIndexTop to FIndexTop+hcnt -1 do begin
      if i >= FListItems.Count then break;
      if i = FItemIndex then begin
         FSurface.Getmage (TempImage, FBevelWidth, yy, FALSE);

         TempImage.Clear (A1GetColorIndex (clGray));

         A1TextOut (TempImage, 0, 0, FFontColorIndex, FListItems[i]);

         FSurface.DrawImage (TempImage, FBevelWidth, yy, FALSE);
      end else begin
         A1TextOut (FSurface, FBevelWidth, yy, FFontColorIndex, FListItems[i]);
      end;
      yy := yy + FItemHeight;
   end;
   TempImage.free;

   if not FBtnUp.Empty then FSurface.DrawImage (FBtnUp, Width-FTrackImage.Width, 0, TRUE);
   if not FBtnDown.Empty then FSurface.DrawImage (FBtnDown, Width-FTrackImage.Width, Height-FBtnDown.Height, TRUE);

   if FListItems.Count <= hcnt then exit;

   trackheight := Height - FBtnUp.Height*3;

   ch := (FItemIndex) * TrackHeight div (FListItems.count-1);   // ListItmes.Count : FItemIndex =  100 : x   백분율 100=>TrackHeight;

   if not FTrackBar.Empty then
      FSurface.DrawImage (FTrackBar, Width-FTrackImage.Width, FBtnUp.Height + ch, TRUE);
end;

procedure TA1ListBox.Paint;
begin
   inherited Paint;
   if csDesigning in ComponentState then begin
      if not FBackImage.Empty then FSurface.DrawImage (FBackImage, 0, 0, FALSE);
      if not FTrackImage.Empty then FSurface.DrawImage (FTrackImage, Width-FTrackImage.Width, 0, FALSE);
      DrawItems;

      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1ListBox.A1Paint;
begin
   if Assigned (FA1Form) then begin
      if not FBackImage.Empty then FSurface.DrawImage (FBackImage, 0, 0, FALSE);
      if not FTrackImage.Empty then FSurface.DrawImage (FTrackImage, Width-FTrackImage.Width, 0, FALSE);
      DrawItems;
      FA1Form.DrawImagebyChild (FSurface, Left, Top, TRUE);
   end;
end;


//////////////////////////////////////////
//            TA1Screen
//////////////////////////////////////////
constructor TA1Screen.Create(AOwner: TComponent);
begin
  	inherited Create(AOwner);
   Color := clGray;
   Width := 64; Height := 64;
   FMouseX := -1; FMouseY := -1;
   FCaptureObject := nil;
   FCaptureObjectLeft := 0; FCaptureObjectTop := 0;
   FEnteredObject := nil;

   A1FormList := TList.Create;
   FSurface := TA1Image.Create (4, 4, 0, 0);

   FTimer := TTimer.Create (nil);
   FTimer.Enabled := FALSE;
   FTimer.Interval := 100;
   FTimer.OnTimer := TimerOnTimer;
end;

destructor TA1Screen.Destroy;
begin
   FTimer.Free;
   FSurface.Free;
   A1FormList.Free;
   inherited Destroy;
end;

procedure TA1Screen.TimerOnTimer (Sender: TObject);
var
   i: integer;
begin
   for i := 0 to A1FormList.Count -1 do begin
      TA1Form (A1FormList[i]).TimerOnTimer;
   end;
end;

procedure TA1Screen.Loaded;
begin
   inherited Loaded;
   if csDesigning in ComponentState then begin
   end else begin
      FTimer.Enabled := TRUE;
      FSurface.ReCanvas (Width, Height);
   end;
end;

procedure TA1Screen.Paint;
begin
   inherited Paint;
   if csDesigning in ComponentState then begin
      Canvas.Brush.Color := Color;
      Canvas.FillRect (ClientRect);
      Canvas.Pen.Color := clWhite;

      Canvas.MoveTo (0, 0); Canvas.LineTo (Width,Height);
      Canvas.MoveTo (Width-1, 0); Canvas.LineTo (0,Height-1);
   end else begin
   end;
end;

procedure TA1Screen.Click;
var
   i: integer;
   A1Form : TA1Form;
begin
   if Assigned (FCaptureObject) then begin
      if FMouseX < FCaptureObjectLeft then exit;
      if FMouseX > FCaptureObjectLeft + FCaptureObject.Width then exit;
      if FMouseY < FCaptureObjectTop then exit;
      if FMouseY > FCaptureObjectTop + FCaptureObject.Height then exit;
   end;
   
   for i := 0 to A1FormList.Count -1 do begin
      A1Form := A1FormList[i];
      if not A1Form.Visible then continue;
      if InArea (A1Form.Left, A1Form.Top, A1Form.Width, A1Form.Height, FMouseX, FMouseY) then begin
         A1Form.Click;
         exit;
      end;
   end;
   if Assigned(OnClick) then OnClick(Self);
end;

procedure TA1Screen.DblClick;
var
   i: integer;
   A1Form : TA1Form;
begin
   if Assigned (FCaptureObject) then begin
      if FMouseX < FCaptureObjectLeft then exit;
      if FMouseX > FCaptureObjectLeft + FCaptureObject.Width then exit;
      if FMouseY < FCaptureObjectTop then exit;
      if FMouseY > FCaptureObjectTop + FCaptureObject.Height then exit;
   end;
   
   for i := 0 to A1FormList.Count -1 do begin
      A1Form := A1FormList[i];
      if not A1Form.Visible then continue;
      if InArea (A1Form.Left, A1Form.Top, A1Form.Width, A1Form.Height, FMouseX, FMouseY) then begin
         A1Form.DblClick;
         exit;
      end;
   end;
  if Assigned(OnDblClick) then OnDblClick(Self);
end;

procedure TA1Screen.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i: integer;
   A1Form : TA1Form;
begin
   FMouseX := X; FMouseY := Y;
   if Assigned (FCaptureObject) then begin
      FCaptureObject.MouseDown (Button, Shift, X-FCaptureObjectLeft, Y-FCaptureObjectTop);
      exit;
   end;

   for i := 0 to A1FormList.Count -1 do begin
      A1Form := A1FormList[i];
      if not A1Form.Visible then continue;
      if InArea (A1Form.Left, A1Form.Top, A1Form.Width, A1Form.Height, x, y) then begin
         A1Form.MouseDown (Button, Shift, X-A1Form.Left, Y-A1Form.Top);
         exit;
      end;
   end;
   inherited MouseDown(Button, Shift, X, Y);
end;

procedure TA1Screen.MouseMove(Shift: TShiftState; X, Y: Integer);
var
   i: integer;
   A1Form : TA1Form;
begin
   FHintStr := '';
   FMouseX := X; FMouseY := Y;
   if Assigned (FCaptureObject) then begin
      FCaptureObject.MouseMove (Shift, X-FCaptureObjectLeft, Y-FCaptureObjectTop);
      exit;
   end;
   for i := 0 to A1FormList.Count -1 do begin
      A1Form := A1FormList[i];
      if not A1Form.Visible then continue;
      if InArea (A1Form.Left, A1Form.Top, A1Form.Width, A1Form.Height, x, y) then begin
         A1Form.MouseMove (Shift, X-A1Form.Left, Y-A1Form.Top);
         exit;
      end;
   end;
   inherited MouseMove (Shift, X, Y);
end;

procedure TA1Screen.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i: integer;
   A1Form : TA1Form;
begin

   FMouseX := X; FMouseY := Y;
   if Assigned (FCaptureObject) then begin
      FCaptureObject.MouseUp (Button, Shift, X-FCaptureObjectLeft, Y-FCaptureObjectTop);
      exit;
   end;
   for i := 0 to A1FormList.Count -1 do begin
      A1Form := A1FormList[i];
      if not A1Form.Visible then continue;
      if InArea (A1Form.Left, A1Form.Top, A1Form.Width, A1Form.Height, x, y) then begin
         A1Form.MouseUp (Button, Shift, X-A1Form.Left, Y-A1Form.Top);
         exit;
      end;
   end;
   inherited MouseUp (Button, Shift, X, Y);
end;

procedure TA1Screen.A1Paint;
var
   i, n: integer;
   xx, yy, w, h: integer;
begin
   for i := A1FormList.Count -1 downto 0 do
      if TA1Form (A1FormList[i]).Visible then TA1Form (A1FormList[i]).A1Paint;

   if FHintStr <> '' then begin
      w := A1TextWidth (FHintStr);
      h := A1TextHeight (FHintStr);
      xx := (FHintR.Left + FHintR.Right) div 2 - w div 2;
      if xx < 0 then xx := 0;
      if (xx + w) > Width then xx := Width - w;

      yy := FHintR.Top - h-2;
      if yy < 0 then yy := FHintR.Bottom + 2;
      n := A1GetColorIndex (RGB (10, 10, 10));
      A1TextOut (FSurface, xx+1, yy+1, n, FHintStr);
      n := A1GetColorIndex (clSilver);
      A1TextOut (FSurface, xx, yy, n, FHintStr);
   end;
end;

procedure TA1Screen.AddA1Form (aForm : TA1Form);
begin
   A1FormList.Add (aForm);
end;

procedure TA1Screen.DrawImagebyChild (aImage: TA1Image; x, y: integer; aTrans: Boolean);   // Clild 컨트롤이 자신을 그림
begin
   if csDesigning in ComponentState then begin
   end else begin
      FSurface.DrawImage (AImage, x, y, aTrans);
   end;
end;

procedure TA1Screen.DrawHintbyChild (aObject : TA1Object; aHintR: TRect; aHintStr: string);
begin
   if csDesigning in ComponentState then begin
   end else begin
      FHintR := aHintR;
      FHintStr := aHintStr;
      if aObject <> FEnteredObject then begin
         if FEnteredObject <> nil then FEnteredObject.CMMouseLeave;
         FEnteredObject := aObject;
         FEnteredObject.CMMouseEnter;
      end;
   end;
end;


procedure TA1Screen.A1SetCapture (Sender: TA1Object; aLeft, aTop: integer);
begin
   FCaptureObject := Sender;
   FCaptureObjectLeft := aleft; FCaptureObjectTop := aTop;
   SetCapture (Parent.Handle);
end;

procedure TA1Screen.A1ReleaseCapture;
begin
   FCaptureObject := nil;
   FCaptureObjectLeft := 0; FCaptureObjectTop := 0;
   ReleaseCapture;
end;

procedure TA1Screen.A1SetTopForm (aForm: TA1Form);
var
   i: integer;
begin
   for i := 0 to A1FormList.Count -1 do begin
      if A1formList[i] = aform then begin
         A1formList.Delete (i);
         A1FormList.Insert (0, aForm);
         exit;
      end;
   end;
end;

//////////////////////////////////////////
//            TA1Object
//////////////////////////////////////////

constructor TA1Object.Create (AOwner: TComponent);
begin
  	inherited Create(AOwner);
   FDisible := FALSE;
   FSurface := TA1Image.Create (48, 20, 0, 0);
   FEntered := FALSE;
   Width := 48; Height := 20;
   FColorIndex := 0; Color := clGray;
   FSurface.Clear (FColorIndex);
   FFontColor := clBlack; FFontColorIndex := A1GetColorIndex (FFontColor);
end;

destructor  TA1Object.Destroy;
begin
   FSurface.Free;
   inherited Destroy;
end;

procedure TA1Object.TimerOnTimer;
begin
end;

function  TA1Object.GetColor: TColor;
begin
   Result := inherited Color;
end;

procedure TA1Object.SetFontColor (Value: TColor);
begin
   FFontColor := Value; FFontColorIndex := A1GetColorIndex (FFontColor);
   Invalidate;
end;

procedure TA1Object.SetColor (Value: TColor);
begin
   inherited Color := Value;
   FColorIndex := A1GetColorIndex (Color);
   FSurface.Clear (FColorIndex);
end;

procedure TA1Object.Click;
begin
  if Assigned(OnClick) then OnClick(Self);
end;

procedure TA1Object.DblClick;
begin
  if Assigned(OnDblClick) then OnDblClick(Self);
end;

procedure TA1Object.Paint;
begin
   inherited paint;
   FSurface.Clear (FColorIndex);
   if csDesigning in ComponentState then begin
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1Object.Loaded;
begin
   inherited Loaded;
   FSurface.ReCanvas (Width, Height);
   FSurface.Clear (FColorIndex);
end;

procedure TA1Object.Resize;
begin
   inherited Resize;
   if (Width <> 0) and (Height <> 0) then begin
      if Width mod 4 = 3 then Width := Width div 4 * 4;
      if Width mod 4 = 1 then Width := Width div 4 * 4+4;
      FSurface.ReCanvas (Width, Height);
      FSurface.Clear (FColorIndex);
   end;
end;

procedure TA1Object.A1Paint;
begin
   if Visible then FSurface.Clear (FColorIndex);
end;

procedure TA1Object.MouseMove(Shift: TShiftState; X, Y: Integer);
var
   R : TRect;
begin
   R := Rect (Left, Top, Left + Width, Top + Height);
   if Self is TA1Form then begin
      R := Rect (0, 0, Width, Height);
      TA1Form (Self).DrawHintbyChild (Self, R, Hint);
   end;

   if Assigned (FA1Form) then begin
      FA1Form.DrawHintbyChild (Self, R, Hint);
   end;
end;

procedure TA1Object.CMMouseEnter;
begin
   if Assigned (OnEnter) then OnEnter(Self);
   FEntered := TRUE;
end;

procedure TA1Object.CMMouseLeave;
begin
   if Assigned (OnExit) then OnExit(Self);
   FEntered := FALSE;
end;

//////////////////////////////////////////
//            TA1Form
//////////////////////////////////////////

constructor TA1Form.Create(AOwner: TComponent);
begin
  	inherited Create(AOwner);
   ObjectList := TList.Create;
   FBackImage := TA1Image.Create(4, 4, 0, 0);
   FFileName := '';
   FMouseX := -1; FMouseY := -1;
end;

destructor TA1Form.Destroy;
begin
   FBackImage.Free;
   ObjectList.Free;
   inherited Destroy;
end;

procedure TA1Form.TimerOnTimer;
begin
end;

function  TA1Form.GetVisible: Boolean;
begin
   Result := inherited Visible;
end;

procedure TA1Form.SetVisible (Value: Boolean);
var
   boChanged : Boolean;
begin
   if Value <> inherited Visible then boChanged := TRUE
   else boChanged := FALSE;
   inherited Visible := Value;

   if boChanged then begin

      if Assigned (FA1Screen) then FA1Screen.A1SetTopForm (Self);

      if Visible then begin
         if Assigned (FOnShow) then FOnShow (Self);
      end else begin
         if Assigned (FOnHide) then FOnHide (Self);
      end;
   end;
end;

procedure TA1Form.Loaded;
var i : integer;
begin
   inherited Loaded;
   if Assigned (FA1Screen) then FA1Screen.AddA1Form (Self);
   if FileExists (FFileName) then FBackImage.LoadFromFile (FFileName);
   if not ( csDesigning in ComponentState) then begin
      ObjectList.Clear;
      for i := 0 to Owner.ComponentCount -1 do begin
         if TComponent (Owner.Components[i]) is TA1Form then continue;
         if TComponent (Owner.Components[i]) is TA1Object then ObjectList.Add (Owner.Components[i]);
      end;
   end;
end;

procedure TA1Form.Click;
var
   i: integer;
   A1Object : TA1Object;
begin
   for i := 0 to ObjectList.Count -1 do begin
      A1Object := ObjectList[i];
      if not A1Object.Visible then continue;
      if A1Object.Disible then continue;
      if InArea (A1Object.Left, A1Object.Top, A1Object.Width, A1Object.Height, FMouseX, FMouseY) then begin
         A1Object.Click;
         exit;
      end;
   end;
  if Assigned(OnClick) then OnClick(Self);
end;

procedure TA1Form.DblClick;
var
   i: integer;
   A1Object : TA1Object;
begin
   for i := 0 to ObjectList.Count -1 do begin
      A1Object := ObjectList[i];
      if not A1Object.Visible then continue;
      if InArea (A1Object.Left, A1Object.Top, A1Object.Width, A1Object.Height, FMouseX, FMouseY) then begin
         A1Object.DblClick;
         exit;
      end;
   end;
  if Assigned(OnDblClick) then OnDblClick(Self);
end;

procedure TA1Form.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i: integer;
   A1Object : TA1Object;
begin
   FMouseX := X; FMouseY := Y;
   for i := 0 to ObjectList.Count -1 do begin
      A1Object := ObjectList[i];
      if not A1Object.Visible then continue;
      if InArea (A1Object.Left, A1Object.Top, A1Object.Width, A1Object.Height, FMouseX, FMouseY) then begin
         A1Object.MouseDown (Button, Shift, X-A1Object.Left, Y-A1Object.Top);
         exit;
      end;
   end;
   inherited MouseDown(Button, Shift, X, Y);
end;

procedure TA1Form.MouseMove(Shift: TShiftState; X, Y: Integer);
var
   i: integer;
   A1Object : TA1Object;
begin
   FMouseX := X; FMouseY := Y;
   for i := 0 to ObjectList.Count -1 do begin
      A1Object := ObjectList[i];
      if not A1Object.Visible then continue;
      if InArea (A1Object.Left, A1Object.Top, A1Object.Width, A1Object.Height, FMouseX, FMouseY) then begin
         A1Object.MouseMove (Shift, X, Y);
         exit;
      end;
   end;
   inherited MouseMove (Shift, X, Y);
end;

procedure TA1Form.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   i: integer;
   A1Object : TA1Object;
begin
   FMouseX := X; FMouseY := Y;
   for i := 0 to ObjectList.Count -1 do begin
      A1Object := ObjectList[i];
      if not A1Object.Visible then continue;
      if InArea (A1Object.Left, A1Object.Top, A1Object.Width, A1Object.Height, FMouseX, FMouseY) then begin
         A1Object.MouseUp (Button, Shift, X, Y);
         exit;
      end;
   end;
   inherited MouseUp(Button, Shift, X, Y);
end;

procedure TA1Form.Paint;
begin
   inherited Paint;
   if FileExists (FFileName) then A1DrawImage (Canvas, 0, 0, FBackImage);
end;

procedure TA1Form.A1Paint;
var i: integer;
begin
   if not Visible then exit;

   if Assigned (FA1Screen) then begin
      FA1Screen.DrawImagebyChild (FBackImage, Left, Top, FTransParent);
      for i := 0 to ObjectList.Count -1 do
         if TA1Object (ObjectList[i]).Visible then TA1Object (ObjectList[i]).A1Paint;
   end;
end;

procedure TA1Form.DrawImagebyChild (aImage: TA1Image; x, y: integer; aTrans: Boolean);   // Clild 컨트롤이 자신을 그림
begin
   if Assigned (FA1Screen) then FA1Screen.DrawImagebyChild (aImage, Left + x, Top + y, aTrans);
end;

procedure TA1Form.DrawHintbyChild (aObject: TA1Object; aHintR: TRect; aHintStr: string);
begin
   if Assigned (FA1Screen) then begin
      aHintR.Left := aHintR.Left + Left;
      aHintR.Top := aHintR.Top + Top;
      aHintR.Right := aHintR.Right + Left;
      aHintR.Bottom := aHintR.Bottom + Top;
      FA1Screen.DrawHintbyChild (aObject, aHintR, aHintStr);
   end;
end;


procedure TA1Form.SetFileName (Value: string);
begin
   FFileName := Value;
end;

procedure TA1Form.A1SetCapture (Sender: TA1Object; aLeft, aTop: integer);
begin
   if Assigned (FA1Screen) then FA1Screen.A1SetCapture (Sender, aleft+Left, aTop + Top);
end;

procedure TA1Form.A1ReleaseCapture;
begin
   if Assigned (FA1Screen) then FA1Screen.A1ReleaseCapture;
end;

//////////////////////////////////////////
//            TA1Label
//////////////////////////////////////////

constructor TA1Label.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 64; Height := 16;
  FCaption := ClassName;
  FAlignment := taLeftJustify;
end;

destructor TA1Label.Destroy;
begin
  inherited destroy;
end;

procedure TA1Label.SetCaption (Value: string);
begin
   FCaption := Value;
   Invalidate;
   FSurface.Clear (FColorIndex);
   A1TextOut (FSurface, GetAlignX, 0, FFontColorIndex, FCaption);
end;

procedure TA1Label.SetAlignment (Value: TAlignment);
begin
   FAlignment := Value;
   Invalidate;
   FSurface.Clear (FColorIndex);
   A1TextOut (FSurface, GetAlignX, 0, FFontColorIndex, FCaption);
end;

function  TA1Label.GetAlignX: integer;
begin
   Result := 0;
   case FAlignment of
      taCenter : Result := Width div 2 - A1TextWidth (FCaption) div 2;
      taLeftJustify: Result := 0;
      taRightJustify: Result := Width - A1TextWidth (FCaption);
   end;
end;

procedure TA1Label.Loaded;
begin
   inherited Loaded;
end;

procedure TA1Label.paint;
begin
   inherited paint;
   if csDesigning in ComponentState then begin
      A1TextOut (FSurface, GetAlignX, 0, FFontcolorIndex, FCaption);
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1Label.A1Paint;
begin
   if not (csDesigning in ComponentState) then begin
      if Assigned (FA1Form) then FA1Form.DrawImagebyChild (FSurface, Left, Top, TRUE);
   end;
end;


//////////////////////////////////////////
//            TA1Picture
//////////////////////////////////////////

constructor TA1Picture.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
  FPictureImage := TA1Image.Create (4, 4, 0, 0);
  FCount := 1;
  FDisplay := 0;
end;

destructor TA1Picture.Destroy;
begin
  FPictureImage.Free;
  FBitmap.Free;
  inherited destroy;
end;

procedure TA1Picture.Loaded;
begin
   inherited Loaded;
   if not FBitmap.Empty then begin
      FPictureImage.ReCanvas (FBitmap.Width, FBitmap.Height);
      A1GetCanvas (FBitmap, FPictureImage);
   end;
end;

procedure TA1Picture.SetBitmap(Value: TBitmap);
begin
   FBitmap.Assign(Value);
   if not FBitmap.Empty then A1GetCanvas (FBitmap, FPictureImage)
   else begin
      FPictureImage.ReCanvas (4, 4);
   end;
   if FAutoSize and not FBitmap.Empty then begin
      Width := FBitmap.Width div FCount;
      Height := FBitmap.Height;
   end;
   Invalidate;
end;

procedure TA1Picture.SetDisPlay (Value: integer);
begin
   if Value < 0 then exit;
   if Value >= FCount then exit;
   FDisplay := Value;
   
   if FAutoSize and not FBitmap.Empty then begin
      Width := FBitmap.Width div FCount;
      Height := FBitmap.Height;
   end;
   Invalidate;
end;

procedure TA1Picture.SetCount (Value: integer);
begin
   if FBitmap.Empty then exit;
   if Value < 1 then exit;
   FCount := Value;
   
   if FAutoSize and not FBitmap.Empty then begin
      Width := FBitmap.Width div FCount;
      Height := FBitmap.Height;
   end;
   Invalidate;
end;

procedure TA1Picture.SetAutoSize (Value: Boolean);
begin
   FAutoSize := Value;
   if FAutoSize and not FBitmap.Empty then begin
      Width := FBitmap.Width div FCount;
      Height := FBitmap.Height;
   end;
end;

procedure TA1Picture.paint;
begin
   inherited paint;
   if csDesigning in ComponentState then begin
      if not FPictureImage.Empty then begin
          FSurface.DrawImage (FPictureImage, -DisPlay * Width, 0, FALSE);
      end;
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1Picture.A1Paint;
begin
   if Assigned (FA1Form) then begin
      if not FBitmap.Empty then FSurface.DrawImage (FPictureImage, -DisPlay*Width, 0, FALSE);
      FA1Form.DrawImagebyChild (FSurface, Left, Top, TRUE);
   end;
end;


//////////////////////////////////////////
//            TA1EditMain
//////////////////////////////////////////

constructor TA1EditMain.Create (AOwner: TComponent);
begin
   inherited Create (AOwner);
   DataList := TList.Create;
   AutoSelect := FALSE;
   AutoSize := FALSE;
   BorderStyle := bsNone;
   CurA1Edit := nil;

   Timer := TTimer.Create(nil);
   Timer.Interval := EDIT_TOGGLE_TIME;
   Timer.Enabled := TRUE;
   Timer.OnTimer := TimerOnTimer;
end;

destructor TA1EditMain.Destroy;
begin
   Timer.Free;
   DataList.Free;
   inherited Destroy;
end;

procedure TA1EditMain.Loaded;
begin
   inherited Loaded;
end;

procedure TA1EditMain.TimerOnTimer (Sender : TObject);
begin
   if Assigned (CurA1Edit) then CurA1Edit.Active := not CurA1Edit.Active;
end;

procedure TA1EditMain.KeyDown(var Key: Word; Shift: TShiftState);
begin
   inherited KeyDown (Key, Shift);
   case Key of
      VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME:
         begin SelStart := Length (Text); Sellength := 0; end;
   end;
   if Assigned (CurA1Edit) then CurA1Edit.KeyDown (Key, Shift);
end;

procedure TA1EditMain.KeyUp(var Key: Word; Shift: TShiftState);
var
   i, curp: integer;
begin
   inherited KeyUp (Key, Shift);
   if csDesigning in ComponentState then exit;
   case Key of
     VK_TAB :
        begin
           if DataList.Count = 0 then exit;
           curp := -1;
           for i := 0 to DataList.Count -1 do
              if CurA1Edit = TA1Edit (DataList[i]) then curp := i;
           for i := 0 to DataList.Count -1 do begin
              inc (Curp);
              if curp >= DataList.Count then curp := 0;
              if not TA1Edit(DataList[curp]).Visible then continue;
              if not Assigned (TA1Edit (DataList[curp]).A1Form) then continue;
              if not TA1Edit (DataList[curp]).A1Form.Visible then continue;

              TA1Edit (DataList[curp]).SetFocus;
              break;
           end;
        end;
   end;
   case Key of
      VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN, VK_HOME:
         begin SelStart := Length (Text); Sellength := 0; end;
   end;
   if Assigned (CurA1Edit) then CurA1Edit.KeyUp (Key, Shift);
end;

procedure TA1EditMain.KeyPress(var Key: Char);
begin
   inherited KeyPress (Key);
   if Assigned (CurA1Edit) then CurA1Edit.KeyPress (Key);
end;

procedure TA1EditMain.Change;
begin
   inherited Change;
   if Assigned (CurA1Edit) then begin
      CurA1Edit.Text := Text;
   end;
end;

procedure TA1EditMain.AddA1Edit (aEdit: TA1Edit);
begin
   DataList.Add (aEdit);
end;

procedure TA1EditMain.SetA1Focus (aEdit: TA1Edit);
begin
   if Assigned (CurA1Edit) then begin
      CurA1Edit.Active := FALSE;
      if Assigned (CurA1Edit.OnExit) then CurA1Edit.OnExit (CurA1Edit);
   end;
   CurA1Edit := aEdit;
   MaxLength := CurA1Edit.MaxLength;
   Width := CurA1Edit.Width;
   Height := CurA1Edit.Height;

   Text := CurA1Edit.Text;
   PasswordChar := CurA1Edit.PasswordChar;
   SelStart := Length(text);
   if Assigned (CurA1Edit.OnEnter) then CurA1Edit.OnEnter (CurA1Edit);
end;


//////////////////////////////////////////
//            TA1Edit
//////////////////////////////////////////

constructor TA1Edit.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 64; Height := 16;
  FText := '';
  FTextHeight := 16;
  FMaxLength := 0; FPasswordChar := #0;
  Color := clWhite;
  Active := FALSE;
end;

destructor TA1Edit.Destroy;
begin
  inherited destroy;
end;

procedure TA1Edit.SetText (Value: string);
begin
   FText := Value;
   if Assigned (FA1EditMain) then FA1EditMain.text := FText;
   if Value <> '' then FTextHeight := A1TextHeight (Value);
   Invalidate;
end;

procedure TA1Edit.SetA1EditMain (Value: TA1EditMain);
begin
   FA1EditMain := Value;
end;

procedure TA1Edit.SetFocus;
begin
   if Assigned (FA1EditMain) then FA1EditMain.SetA1Focus (Self);
end;

procedure TA1Edit.KeyDown(var Key: Word; Shift: TShiftState);
begin
   inherited KeyDown (Key, Shift);
   if Assigned (FOnKeyDown) then FOnKeyDown (Self, key, shift);
end;

procedure TA1Edit.KeyUp(var Key: Word; Shift: TShiftState);
begin
   inherited KeyUp (Key, Shift);
   if Assigned (FOnKeyUp) then FOnKeyUp (Self, key, shift);
end;

procedure TA1Edit.KeyPress(var Key: Char);
begin
   inherited KeyPress (Key);
   if Assigned (FOnKeyPress) then FOnKeyPress (Self, key);
end;

procedure TA1Edit.Loaded;
begin
   inherited Loaded;
   if Assigned (FA1EditMain) then FA1EditMain.AddA1Edit (Self);
end;

procedure TA1Edit.Click;
begin
   inherited Click;
   SetFocus;
end;

procedure TA1Edit.Paint;
var
   i, yy: integer;
   str: string;
begin
   inherited paint;
   if csDesigning in ComponentState then begin
      str := FText;
      if (passwordchar <> char(0)) then
         for i := 1 to Length(str) do str[i] := passwordchar;
      yy := Height div 2 - FTextHeight div 2;
      A1TextOut (FSurface, 0, yy, FFontColorIndex, str);
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1Edit.A1Paint;
var
   i, yy : integer;
   str : string;
begin
   inherited A1Paint;
   if csDesigning in ComponentState then begin
   end else begin
      if Assigned (FA1Form) then begin
         str := FText;
         if (passwordchar <> char(0)) then
            for i := 1 to Length(str) do str[i] := passwordchar;
         if Active then Str := Str + '_';
         yy := Height div 2 - FTextHeight div 2;
         A1TextOut (FSurface, 0, yy, FFontColorIndex, Str);
         FA1Form.DrawImagebyChild (FSurface, Left, Top, TRUE);
      end;
   end;
end;

//////////////////////////////////////////
//            TA1Button
//////////////////////////////////////////

constructor TA1Button.Create (AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBitmap := TBitmap.Create;
  FDown := FALSE; FCaptured := FALSE;

  FPictureImage := TA1Image.Create (4, 4, 0, 0);
end;

destructor TA1Button.Destroy;
begin
  FPictureImage.Free;
  FBitmap.Free;
  inherited destroy;
end;

procedure TA1Button.Loaded;
begin
   inherited Loaded;
   if not FBitmap.Empty then begin
      FPictureImage.ReCanvas (FBitmap.Width, FBitmap.Height);
      A1GetCanvas (FBitmap, FPictureImage);
   end;
end;

procedure TA1Button.SetBitmap(Value: TBitmap);
begin
   FBitmap.Assign(Value);
   if not FBitmap.Empty then A1GetCanvas (FBitmap, FPictureImage)
   else begin
      FPictureImage.ReCanvas (4, 4);
   end;
   if FAutoSize and not FBitmap.Empty then begin
      Width := FBitmap.Width div 4;
      Height := FBitmap.Height;
   end;
   Invalidate;
end;

procedure TA1Button.SetAutoSize (Value: Boolean);
begin
   FAutoSize := Value;
   if FAutoSize and not FBitmap.Empty then begin
      Width := FBitmap.Width div 4;
      Height := FBitmap.Height;
   end;
end;

procedure TA1Button.paint;
begin
   inherited paint;
   if csDesigning in ComponentState then begin
      if not FPictureImage.Empty then begin
         if not FDisible then
            FSurface.DrawImage (FPictureImage, 0, 0, FALSE)
         else
            FSurface.DrawImage (FPictureImage, -Width*2, 0, FALSE)
      end;
      A1DrawImage (Canvas, 0, 0, FSurface);
   end;
end;

procedure TA1Button.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if FDisible then exit;
   inherited MouseDown(Button, Shift, X, Y);
   FDown := TRUE;
   if Assigned (FA1Form) then FA1Form.A1SetCapture (Self, Left, Top);
   FCaptured := TRUE;
end;

procedure TA1Button.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
   if FDisible then exit;
   inherited MouseMove (Shift, X, Y);
   if FCaptured then begin
      if InArea (0, 0, Width, Height, X, Y) then begin
         FDown := TRUE;
      end else begin
         FDown := FALSE;
      end;
   end;
end;

procedure TA1Button.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if FDisible then exit;
   inherited MouseUp(Button, Shift, X, Y);
   FDown := FALSE;
   if FCaptured then begin
      if Assigned (FA1Form) then FA1Form.A1ReleaseCapture;
      FCaptured := FALSE;
   end;
end;

procedure TA1Button.A1Paint;
begin
   if Assigned (FA1Form) then begin
      if not FBitmap.Empty then begin
         if not FDisible then begin
            if FDown then begin
               FSurface.DrawImage (FPictureImage, -Width, 0, FTransParent);
            end else begin
               if FEntered then
                  FSurface.DrawImage (FPictureImage, -Width*3, 0, FTransParent)
               else
                  FSurface.DrawImage (FPictureImage, 0, 0, FTransParent);
            end;
         end else begin
            FSurface.DrawImage (FPictureImage, -Width*2, 0, FTransParent);
         end;
      end;
      FA1Form.DrawImagebyChild (FSurface, Left, Top, FTransParent);
   end;
end;

end.
