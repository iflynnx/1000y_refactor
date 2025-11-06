unit FDepository;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, ExtCtrls, StdCtrls, cltype, Deftype, uAnsTick, AtzCls, A2Img,
  CharCls, aDeftype, Autil32;

const
  DepItemMaxCount = 40;
  DepMessageMaxCount = 8;
  ItembaseImage = 1;
type
  TFrmDepository = class(TForm)
    ILabel0: TA2ILabel;
    ILabel2: TA2ILabel;
    ILabel1: TA2ILabel;
    ILabel3: TA2ILabel;
    ILabel4: TA2ILabel;
    ILabel5: TA2ILabel;
    ILabel6: TA2ILabel;
    ILabel7: TA2ILabel;
    ILabel8: TA2ILabel;
    ILabel9: TA2ILabel;
    ILabel10: TA2ILabel;
    ILabel11: TA2ILabel;
    ILabel12: TA2ILabel;
    ILabel13: TA2ILabel;
    ILabel14: TA2ILabel;
    ILabel16: TA2ILabel;
    ILabel15: TA2ILabel;
    ILabel17: TA2ILabel;
    ILabel18: TA2ILabel;
    ILabel19: TA2ILabel;
    ILabel20: TA2ILabel;
    ILabel21: TA2ILabel;
    ILabel22: TA2ILabel;
    ILabel23: TA2ILabel;
    ILabel24: TA2ILabel;
    ILabel26: TA2ILabel;
    ILabel25: TA2ILabel;
    ILabel27: TA2ILabel;
    ILabel28: TA2ILabel;
    ILabel29: TA2ILabel;
    ILabel30: TA2ILabel;
    ILabel31: TA2ILabel;
    ILabel32: TA2ILabel;
    ILabel33: TA2ILabel;
    ILabel34: TA2ILabel;
    ILabel36: TA2ILabel;
    ILabel35: TA2ILabel;
    ILabel37: TA2ILabel;
    ILabel38: TA2ILabel;
    ILabel39: TA2ILabel;
    A2Form: TA2Form;
    BtnOk: TA2Button;
    BtnCancel: TA2Button;
    A2LabelCaption: TA2Label;
    A2LabelState: TA2Label;
    A2Label0: TA2Label;
    A2Label1: TA2Label;
    A2Label2: TA2Label;
    A2Label3: TA2Label;
    A2Label4: TA2Label;
    A2Label5: TA2Label;
    A2Label6: TA2Label;
    A2Label7: TA2Label;
    btnPrePage: TA2Button;
    btnNextPage: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure ILabelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ILabelGuildItemDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ILabelDragOver(Sender, Source: TObject; X, Y: Integer; State:
      TDragState; var Accept: Boolean);
    procedure ILabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure ILabelStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ILabelGuildItemStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ILabelMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);

    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure ILabelCaptionMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure ILabelCaptionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ILabelCaptionMouseUp(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure ILabelPaint(Sender: TObject);
    procedure btnPrePageClick(Sender: TObject);
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure btnNextPageClick(Sender: TObject);
  private
    FWindowKind: Word;
    FWindow: Word;
  public
    LabelArr: array[0..DepItemMaxCount - 1] of TA2ILabel;
    SLogItemList: array[0..DepItemMaxCount - 1] of TSLogItem;
    MessageArr: array[0..DepMessageMaxCount - 1] of TA2Label;
    procedure initiaizeItemLabel(Lb: TA2ILabel);
    procedure InitiaizeGuildItemLabel(Lb: TA2ILabel);
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape:
      word);
    procedure MessageProcess(var code: TWordComData);
    procedure PageDown(APage: Integer);
    procedure CloseWindowMsg(ASave: Boolean);
  end;

var
  FrmDepository: TFrmDepository;
  A2baseImageLib: TA2ImageLib;
  A2IMessage: TA2Image;
  MoveFlag: Boolean = FALSE;
implementation

uses FMain, FAttrib, FLogon, FBottom;

{$R *.DFM}

procedure TFrmDepository.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  psSLogItem: PTSLogItem;
  PSSShowSpecialWindow: PTSShowSpecialWindow;
  i: integer;
  str, rdstr: string;
  StringList: TStringList;
  LabIndex: Integer;
begin
  pckey := @code.data;
  case pckey^.rmsg of
    SM_SHOWSPECIALWINDOW:
      begin
        PSSShowSpecialWindow := @Code.data;
        if not FrmAttrib.Visible then
          FrmAttrib.Visible := TRUE;
        case PSSShowSpecialWindow^.rWindow of
          WINDOW_SSAMZIEITEM, WINDOW_GUILDITEMLOG:
            begin
              MoveFlag := TRUE;
              for i := 0 to DepMessageMaxCount - 1 do
              begin
                MessageArr[i].Visible := FALSE;
              end;
              for i := 0 to DepItemMaxCount - 1 do
              begin
                LabelArr[i].Visible := TRUE;
              end;
              FWindow := PSSShowSpecialWindow^.rWindow;
              FrmDepository.Visible := TRUE;
              FWindowKind := PSSShowSpecialWindow.rKind;
              FrmDepository.A2LabelCaption.Caption :=
                StrPas(@PSSShowSpecialWindow.rCaption);
              FrmDepository.A2LabelState.Caption :=
                GetWordString(PSSShowSpecialWindow.rWordString);
              //Author:Steven Date: 2005-01-05 21:32:02
              //Note:
              if PSSShowSpecialWindow^.rWindow = WINDOW_GUILDITEMLOG then
              begin
                btnNextPage.Visible := True;
                btnPrePage.Visible := True;
                btnCancel.OnClick := BtnOKClick;
              end else begin
                btnCancel.OnClick := BtnOKClick;
              end;
            end;
          WINDOW_ALERT:
            begin
              //                     MoveFlag := TRUE;
              FWindow := WINDOW_ALERT;
              StringList := TStringList.Create;
              for i := 0 to DepItemMaxCount - 1 do
              begin
                LabelArr[i].Visible := FALSE;
              end;
              for i := 0 to DepMessageMaxCount - 1 do
              begin
                MessageArr[i].Visible := TRUE;
                MessageArr[i].Caption := '';
              end;
              FWindowKind := PSSShowSpecialWindow.rKind;
              FrmDepository.A2LabelCaption.Caption :=
                StrPas(@PSSShowSpecialWindow.rCaption);
              str := GetWordString(PSSShowSpecialWindow.rWordString);
              i := 0;
              while TRUE do
              begin
                str := GetValidStr3(str, rdstr, #13);
                MessageArr[i].Caption := rdstr;
                inc(i);
                if str = '' then
                  Break;
                if i > 7 then
                  break;
              end;
              FrmDepository.Visible := TRUE;
              StringList.Free;
            end;

        end;
        if PSSShowSpecialWindow.rWindow = WINDOW_SSAMZIEITEM then

      end;
    SM_GUILDITEM:
      begin
        psSLogItem := @Code.data;
        //            FWindow := SM_LOGITEM;

        with psSLogItem^ do
        begin
          if rKey < 40 then
            LabIndex := rKey
          else
            LabIndex := rKey - 40;
          SLogItemList[LabIndex] := psSLogItem^;

          if StrPas(@rName) <> '' then
          begin
            InitiaizeGuildItemLabel(LabelArr[LabIndex]);
            LabelArr[LabIndex].Tag := rKey;
            SetItemLabel(LabelArr[LabIndex], StrPas(@rName), rColor, rshape);
          end
          else
          begin
            InitiaizeGuildItemLabel(LabelArr[LabIndex]);
            LabelArr[LabIndex].Tag := rKey;
          end;

          if rcount <= 1 then
            LabelArr[LabIndex].Hint := StrPas(@rName)
          else
            LabelArr[LabIndex].Hint := StrPas(@rName) + ':' + IntToStr(rCount);
        end;

        FrmDepository.Visible := TRUE;
      end;
    //Author:Steven Date: 2005-01-05 16:20:54
    //Note:
    SM_SSAMZIEITEM:
      begin
        psSLogItem := @Code.data;
        //            FWindow := SM_LOGITEM;
        with psSLogItem^ do
        begin

          SLogItemList[rkey] := psSLogItem^;

          if StrPas(@rName) <> '' then
          begin
            initiaizeItemLabel(LabelArr[rkey]);
            SetItemLabel(LabelArr[rkey], StrPas(@rName), rColor, rshape);
          end
          else
            initiaizeItemLabel(LabelArr[rkey]);

          if rcount <= 1 then
            LabelArr[rkey].Hint := StrPas(@rName)
          else
            LabelArr[rkey].Hint := StrPas(@rName) + ':' + IntToStr(rCount);
        end;

        FrmDepository.Visible := TRUE;
      end;
  end;
end;

procedure TFrmDepository.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Top := 10;
  Left := 10;
  FrmM.AddA2Form(Self, A2Form);
  FWindow := 0;
  for i := 0 to DepItemMaxCount - 1 do
  begin
    LabelArr[i] := TA2ILabel(FindComponent('ILabel' + IntToStr(i)));
  end;
  for i := 0 to DepMessageMaxCount - 1 do
  begin
    MessageArr[i] := TA2Label(FindComponent('A2Label' + IntToStr(i)));
  end;

  A2baseImagelib := TA2ImageLib.Create;
  A2baseImagelib.LoadFromFile('.\ect\Deposi.atz');
  FWindowKind := 0;
end;

procedure TFrmDepository.FormDestroy(Sender: TObject);
begin
  A2baseImagelib.Free;
end;

procedure TFrmDepository.initiaizeItemLabel(Lb: TA2ILabel);
begin
  Lb.A2Image := A2baseImagelib.Images[ItembaseImage];
  Lb.OnDragDrop := ILabelDragDrop;
  Lb.OnDragOver := ILabelDragOver;
  Lb.OnMouseMove := ILabelMouseMove;
  Lb.OnStartDrag := ILabelStartDrag;
  Lb.OnMouseDown := ILabelMouseDown;
  Lb.OnPaint := ILabelPaint;
end;

procedure TFrmDepository.SetItemLabel(Lb: TA2ILabel; aname: string; acolor:
  byte; shape: word);
var
  gc, ga: Integer;
begin
  Lb.Hint := aname;
  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;

  if shape = 0 then
  begin
    Lb.A2Image := nil;
    Lb.BColor := 0;
    exit;
  end
  else
  begin
    //    Lb.A2Image := AtzClass.GetItemImage(shape);
        //Lb.A2Image.Clear(0);

    Lb.A2Image := AtzClass.GetItemImage(Shape);
    //   Surface.DrawImage(SaveKeyImageLib[24], Lb.Top, Lb.Left, True);
    //Lb.A2Image.DrawImage(SaveKeyImageLib[24], 1, 1, True);

    //X := (Lb.Width - TempA2Image.Width) div 2;
    //Y := (Lb.Height - TempA2Image.Height) div 2;
    //xA2Image.
    //xA2Image.DrawImageGreenConvert(TempA2Image, X, Y, Lb.GreenCol, Lb.GreenAdd);
    //xA2Image.Create(30, 30, 0, 0);
    //xA2Image.Clear(1);
    //xA2Image.DrawImage(SaveKeyImageLib[24], 1, 1, True);
    //xA2Image.DrawImageGreenConvert(SaveKeyImageLib[24], 1, 1, Lb.GreenCol, Lb.GreenAdd);
    //xA2Image.DrawImage(SaveKeyImageLib[24], 1, 1, True);
    //xA2Image.DrawImageGreenConvert(TempA2Image, 1, 1, Lb.GreenCol, Lb.GreenAdd);
    //xA2Image.Free;
{
    //-------Add by steven 2004-09-08 17:17-------------------------------------
    SaveKeyImage.Clear(0);
    X := (Lb.Width - Lb.A2Image.Width) div 2;
    Y := (Lb.Height - Lb.A2Image.Height) div 2;
    SavekeyImage.DrawImageGreenConvert(Lb.A2Image, X, Y, Lb.GreenCol, Lb.GreenAdd);
    SaveKeyImage.DrawImage(SaveKeyImageLib[24], 1, 1, True);
    Lb.A2Image := SaveKeyImage;
}
  end;

end;

procedure TFrmDepository.ILabelDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  cDragDrop: TCDragDrop;
begin
  if Source = nil then
    exit;

  with Source as TDragItem do
  begin
    if SourceID <> WINDOW_ITEMS then
      exit;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := DragedId;
    cDragDrop.rdestId := 0;
    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_SSAMZIEITEM;
    cDragDrop.rsourkey := Selected;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  end;
end;

procedure TFrmDepository.ILabelDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_ITEMS then
      begin
        Accept := TRUE;
      end;
    end;
  end;
end;

procedure TFrmDepository.ILabelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseInfoStr := TA2ILabel(Sender).Hint;
end;

procedure TFrmDepository.ILabelStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_SSAMZIEITEM;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmDepository.ILabelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TA2ILabel(Sender).BeginDrag(FALSE);
end;

procedure TFrmDepository.FormShow(Sender: TObject);
begin
  Top := (480 - 117 - Height) div 2;
  if FrmAttrib.Visible then
    Left := (640 - 180 - Width) div 2
  else
    Left := (640 - Width) div 2;
end;

procedure TFrmDepository.BtnOkClick(Sender: TObject);
var
  cCWindowConfirm: TCWindowConfirm;
begin
  CloseWindowMsg(True);
  FrmDepository.Visible := FALSE;
end;

procedure TFrmDepository.BtnCancelClick(Sender: TObject);
begin
  CloseWindowMsg(False);
  FrmDepository.Visible := FALSE;
  btnPrePage.Visible := False;
  btnNextPage.Visible := False;
end;

var
  Boolflag: Boolean = FALSE;
  Or_baseX: integer = 0;
  Or_baseY: integer = 0;

function CheckMaxRight: integer;
begin
  if FrmAttrib.Visible then
    Result := 640 - FrmAttrib.Width
  else
    Result := 640;
end;

function CheckMaxLeft: integer;
begin
  Result := 0;
end;

function CheckMaxTop: integer;
begin
  Result := 0;
end;

function CheckMaxBottom: integer;
begin
  if FrmBottom.Visible then
    Result := (480 - Frmbottom.Height) + 10
  else
    Result := 480;
end;

procedure TFrmDepository.ILabelCaptionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if Boolflag then
  begin
    FrmDepository.Left := FrmDepository.Left - (Or_baseX - X);
    FrmDepository.Top := FrmDepository.Top - (Or_baseY - Y);
    {
    if FrmDepository.Left < CheckMaxLeft then FrmDepository.left := CheckMaxLeft;
    if FrmDepository.Left+FrmDepository.Width > CheckMaxRight then
       FrmDepository.Left := CheckMaxRight - FrmDepository.width;
    if FrmDepository.Top < CheckMaxTop then FrmDepository.Top := CheckMaxTop;
    if FrmDepository.Top+FrmDepository.Height > CheckMaxBottom then
       FrmDepository.Top := CheckMaxBottom - FrmDepository.Height;
       }
  end;
end;

procedure TFrmDepository.ILabelCaptionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if MoveFlag then
  begin
    Boolflag := TRUE;
    Or_baseX := X;
    Or_baseY := Y;
  end;
end;

procedure TFrmDepository.ILabelCaptionMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Boolflag := FALSE;
end;

procedure TFrmDepository.ILabelPaint(Sender: TObject);
begin
  //-------Add by steven 2004-09-08 15:47---------------------------------------
//  A2ILabel := TA2ILabel(Sender);
//  if (A2ILabel = nil) or (A2ILabel.A2Image = nil) then
//    Exit;

//  SaveKeyImage.Clear(0);
//  X := (A2ILabel.Width - A2ILabel.A2Image.Width) div 2;
//  Y := (A2ILabel.Height - A2ILabel.A2Image.Height) div 2;
{
  SavekeyImage.DrawImageGreenConvert(A2ILabel.A2Image, x, y, A2ILabel.GreenCol,
    A2ILabel.GreenAdd);
  {
    case HaveItemList[A2ILabel.Tag].rLockState of
      1:
      begin
        SaveKeyImage.DrawImage(SaveKeyImageLib[24], A2ILabel.Width - 14,
          A2ILabel.Height - 12, True);
      end;
      2:
      begin
        SaveKeyImage.DrawImage(SaveKeyImageLib[25], A2ILabel.Width - 14,
          A2ILabel.Height - 12, True);
      end;
    end;
   }
    //Õâ¾ä´úÂë×îºóÉ¾³ý
 // SaveKeyImage.DrawImage(SaveKeyImageLib[24], A2ILabel.Width - 14,
 //   A2ILabel.Height - 14, True);
  //

 // A2DrawImage(A2ILabel.Canvas, 0, 0, SaveKeyImage);
  //----------------------------------------------------------------------------
end;

procedure TFrmDepository.btnPrePageClick(Sender: TObject);
begin
  PageDown(1);
  CloseWindowMsg(False);
end;

{
   TSLogItem = packed record
      rmsg : byte;
      rkey : byte;
      rName : TNameString;
      rCount : word;
      rColor: byte;
      rShape: word;

      rLockState : word;
      runLockTime :word;
   end;
   PTSLogItem = ^TSLogItem;
}

procedure TFrmDepository.A2FormAdxPaint(aAnsImage: TA2Image);
var
  i: Integer;
begin
  //Author:Steven Date: 2004-09-08 18:13:24
  //Note:
  for i := 0 to 39 do
    with TA2ILabel(FindComponent(Format('ILabel%d', [i]))) do
      if A2Image <> nil then
        case SLogItemList[i].rLockState of
          1: aAnsImage.DrawImage(SaveKeyImageLib[24], Left + 20, Top + 18,
            True);
          2: aAnsImage.DrawImage(SaveKeyImageLib[25], Left + 20, Top + 18,
            True);
        end;
end;

procedure TFrmDepository.PageDown(APage: Integer);
var
  cSelectHelpWindow: TCSelectHelpWindow;
  n: Integer;
begin
  with cSelectHelpWindow do
  begin
    rMsg := CM_GUILDITEMPAGE;
    SetWordString(rSelectKey, IntToStr(APage));
  end;
  n := SizeOf(cSelectHelpWindow) - SizeOf(TWordString) +
    SizeOfWordString(cSelectHelpWindow.rSelectKey);
  FrmLogon.SocketAddData(n, @cSelectHelpWindow);
end;

procedure TFrmDepository.btnNextPageClick(Sender: TObject);
begin
  PageDown(2);
  CloseWindowMsg(False);
end;

procedure TFrmDepository.ILabelGuildItemDragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  cDragDrop: TCDragDrop;
begin
  if Source = nil then
    exit;

  with Source as TDragItem do
  begin
    if SourceID <> WINDOW_ITEMS then
      exit;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := DragedId;
    cDragDrop.rdestId := 0;
    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_GUILDITEMLOG;
    cDragDrop.rsourkey := Selected;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  end;
end;

procedure TFrmDepository.ILabelGuildItemStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_GUILDITEMLOG;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmDepository.InitiaizeGuildItemLabel(Lb: TA2ILabel);
begin
  Lb.A2Image := A2baseImagelib.Images[ItembaseImage];
  Lb.OnDragDrop := ILabelGuildItemDragDrop;
  Lb.OnDragOver := ILabelDragOver;
  Lb.OnMouseMove := ILabelMouseMove;
  Lb.OnStartDrag := ILabelGuildItemStartDrag;
  Lb.OnMouseDown := ILabelMouseDown;
  Lb.OnPaint := ILabelPaint;
end;

procedure TFrmDepository.CloseWindowMsg(ASave: Boolean);
var
  cCWindowConfirm: TCWindowConfirm;
begin
  cCWindowConfirm.rMsg := CM_WINDOWCONFIRM;
  CCWindowConfirm.rWindow := FWindow;
  cCWindowConfirm.rType := FWindowKind;
  cCWindowConfirm.rboCheck := ASave;
  cCWindowConfirm.rButton := 0;

  // ¹öÆ°ÀÌ ¿©·Á°³ ÀÖÀ»°æ¿ì¸¸ »ç¿ë ÀÏ¹ÝÀº 0ÀÌ ÃÊ±â°ª
  FrmLogon.SocketAddData(sizeof(cCWindowConfirm), @cCWindowConfirm);
end;

end.

