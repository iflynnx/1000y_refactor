unit FSkill;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, StdCtrls, DefType, AUtil32, ClType, A2Img, ExtCtrls, uAnsTick;

const
  ms_none   = 0;
  ms_making = 1;
  ms_made   = 2;

type
  TMaterialInfo = record
    rShape: integer;
    rColor: integer;
    rCount: integer;
    rName: string;
    rControl: TA2ILabel;
  end;

  TfrmSkill = class(TForm)
    lblJobKind: TA2Label;
    lblJobGrade: TA2Label;
    A2Label3: TA2Label;
    lblJobPoint: TA2Label;
    imgTool: TA2ILabel;
    btnMake: TA2Button;
    material1: TA2ILabel;
    material2: TA2ILabel;
    material3: TA2ILabel;
    material4: TA2ILabel;
    A2Form: TA2Form;
    btnClose: TA2Button;
    MakingProgress: TA2ProgressBar;
    MadeItem: TA2ILabel;
    lblExtJobGrade: TA2Label;
    lblExtJobPoint: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure materialDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure materialDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure btnMakeClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure materialStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure materialMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure FormShow(Sender: TObject);
    procedure materialMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure materialDblClick(Sender: TObject);
    procedure imgToolDblClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure imgToolMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
//    ToolImages: TA2ImageLib;   // 기술창의 알수없는 오류로 인해 atzclass로 변경
    FAniIndex: integer;
    FAniTick: integer;
    EventTick: integer;
    FDelay: integer;
    ResultMsg: string;
    MatInfoArr: array[0..4] of TMaterialInfo;
    SoundName: string;
    ResultSound: string;
    ImageName: string;
    SoundState: integer;
    OldJobPoint: string;

    procedure ClearMatInfo;      // Material Data를 지움, 화면구현별도
    function isProcess: Boolean; // 가공인지 체크하는 함수
  public
    bMakeState: integer;
    bWaitMode: Boolean;

    function isNullMat: Boolean; // 재료가 비어있는지 체크
    procedure MessageProcess(var Code: TWordComData);
    procedure SetMatrialLabel (Lb: TA2ILabel; aname: string; acolor: byte; shape: word);
  end;

var
  frmSkill: TfrmSkill;

implementation

uses FMain, FLogOn, CharCls, AtzCls, FAttrib, FBottom, FHistory,
  FSkillManufact;

{$R *.DFM}

procedure TFrmSkill.SetMatrialLabel (Lb: TA2ILabel; aname: string; acolor: byte; shape: word);
var
   gc, ga: integer;
begin
   GetGreenColorAndAdd (acolor, gc, ga);

   Lb.GreenCol := gc;
   Lb.GreenAdd := ga;

   if shape = 0 then begin
      Lb.A2Image := nil;
      Lb.BColor := 0;
      exit;
   end else
      Lb.A2Image := AtzClass.GetItemImage (shape);
end;

procedure TfrmSkill.ClearMatInfo;
var
   i: integer;
begin
   for i := 0 to 4 do begin
      MatInfoArr[i].rShape := 0;
      MatInfoArr[i].rColor := 0;
      MatInfoArr[i].rCount := 0;
      MatInfoArr[i].rName  := '';
   end;
end;

function TfrmSkill.isProcess: Boolean;
begin
   Result := (MatInfoArr[4].rShape > 0);
end;

function TfrmSkill.isNullMat: Boolean;
var
   i, t: integer;
begin
   t := 0;
   for i := 0 to 4 do
      t := t + MatInfoArr[i].rShape;

   Result := (t = 0);
end;

procedure TfrmSkill.MessageProcess(var Code: TWordComData);
var
   pcKey: PTCKey;
   psShowJobWindow: PTSShowJobWindow;
   psHaveItem: PTSHaveItem;
   psJobResult: PTSJobResult;
//   ImageName: string; // class member로 변경
   ImageLib: TA2ImageLib;
begin
   pcKey := @Code.Data;
   case pcKey.rmsg of
      SM_SKILLWINDOW: begin
         psShowJobWindow := @Code.Data;
         with psShowJobWindow^ do begin
            lblJobKind.Caption := StrPas(@rJobKind);
            lblJobGrade.Caption := StrPas(@rJobGrade);
            lblJobPoint.Caption := frmAttrib.LbTalent.Caption;
            lblExtJobGrade.Caption := Conv('꽃섞세콘:') + StrPas(@rExtJobGrade);
            lblExtJobPoint.Caption := Conv('세콘令: ') + Get10000To100(rExtJobLevel);

//            ImageName := 'sprite\m' + intToStr(rShape div 10) + IntToStr(rShape mod 10) + '.atz';
            ImageName := 'm' + intToStr(rShape div 10) + IntToStr(rShape mod 10) + '.atz';
            imgTool.Hint := StrPas(@rJobTool);
         end;

//         if FileExists(ImageName) then
//            ToolImages.LoadFromFile(ImageName);

         FAniIndex := 0;
         EventTick := 0;
         OldJobPoint := lblJobPoint.Caption;
         Visible := True;
      end;
      SM_JOBRESULT: begin
         psJobResult := @Code.Data;
         FDelay := mmAnsTick;
         bMakeState := ms_making; //

         btnMake.Enabled := False;
         btnClose.Enabled := False;

         with psJobResult^ do begin
            ResultMsg := GetWordString(rWordString);
            SoundName := ChangeFileExt(StrPas(@rWorkSound), '.wav');
            ResultSound := ChangeFileExt(StrPas(@rResultSound), '.wav');
         end;
         ATWaveLib.play(SoundName, 0, EffectVolume);
         SoundState := 2;
         FAniIndex := 0;
         ImageLib := AtzClass.GetImageLib(ImageName, mmAnsTick);
         if ImageLib <> nil then
            imgTool.A2Image := ImageLib[FAniIndex];
      end;
      SM_MATERIALITEM: begin
         psHaveItem := @Code.Data;

         with MatInfoArr[pshaveitem^.rKey] do begin
            rShape := pshaveitem^.rShape;
            rColor := pshaveitem^.rColor;
            rCount := pshaveitem^.rCount;
            rName := StrPas(@pshaveitem^.rName);
            if not bWaitMode then begin
               SetMatrialLabel (rControl, rName, rColor, rShape);
               if rcount <= 1 then rControl.Hint := rName
               else rControl.Hint := rName + ':' + IntToStr(rCount);
            end;
         end;
      end;

   end;
end;

procedure TfrmSkill.FormCreate(Sender: TObject);
begin
   FrmM.AddA2Form(self, A2Form);
   Left := 640 - frmAttrib.Width - Width - 10;
   Top := 10;
   Visible := False;

   ClearMatInfo;
   MatInfoArr[0].rControl := material1;
   MatInfoArr[1].rControl := material2;
   MatInfoArr[2].rControl := material3;
   MatInfoArr[3].rControl := material4;
   MatInfoArr[4].rControl := MadeItem;

//   ToolImages := TA2ImageLib.Create;
   FAniIndex := 0;

   MakingProgress.Value := 0;
   bWaitMode := False;
   bMakeState := ms_none;

   A2Label3.Caption := Conv('세콘');
end;

procedure TfrmSkill.materialDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   Accept := False;
   if not (Source is TDragItem) then exit;

   with Source as TDragItem do begin
      if SourceID = WINDOW_ITEMS then Accept := TRUE;
   end;
end;

procedure TfrmSkill.materialDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
   cDragDrop : TCDragDrop;
   DropItem: TDragItem;
begin
   if Source = nil then exit;
   if not (Source is TDragItem) then exit;

   DropItem := Source as TDragItem;
   if DropItem.SourceID <> WINDOW_ITEMS then exit;

   with cDragDrop do begin
      rmsg := CM_DRAGDROP;
      rsourId := DropItem.Dragedid;
      rdestId := 0;
      rsx := DropItem.sx;
      rsy := DropItem.sy;
      rdx := 0;
      rdy := 0;
      rsourwindow := DropItem.SourceId;
      rdestwindow := WINDOW_SKILL;
      rsourkey := DropItem.Selected;

      if TComponent(Sender).Tag = 4 then
         rdestkey := 4
      else
         rdestkey := 0;

      FrmLogOn.SocketAddData (sizeof(cDragDrop), @cDragDrop);
      //Connector.SendData(@cDragDrop, sizeof(cDragDrop));
   end;
end;

procedure TfrmSkill.FormDestroy(Sender: TObject);
begin
//   ToolImages.Free;
end;

procedure TfrmSkill.btnMakeClick(Sender: TObject);
var
   cKey: TCKey;
begin
   if isProcess then
      cKey.rmsg := CM_PROCESSITEM
   else begin
      if isNullMat then exit;  // 아무것도 없을때 실행안함..
      cKey.rmsg := CM_MAKEITEM;
   end;
   cKey.rkey := 0;
   FrmLogOn.SocketAddData(sizeof(cKey), @cKey);
//   Connector.SendData(@cKey, sizeof(cKey));

   MakingProgress.Value := 0;
   bWaitMode := True;
end;

procedure TfrmSkill.btnCloseClick(Sender: TObject);
begin
   Visible := False;
end;

procedure TfrmSkill.materialStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
   with DragItem do begin
      Selected := TControl(Sender).Tag;
      SourceId := WINDOW_SKILL;
      Dragedid := 0;
      sx := 0;
      sy := 0;
   end;
   DragObject := DragItem;
end;

procedure TfrmSkill.materialMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
   MatItem: TA2ILabel;
begin
   MatItem := TA2ILabel(Sender);

   if (x < 0) or (y <0) or (x>MatItem.Width) or (y>MatItem.Height) then begin
      if MatItem.A2Image <> nil then MatItem.BeginDrag (TRUE);
   end;
end;

procedure TfrmSkill.A2FormAdxPaint(aAnsImage: TA2Image);
var
   // Make Process 처리용
   TickAgo: integer;
   Value: integer;
   // Tool Animation용
   ImageLib: TA2ImageLib;
   img: TA2Image;
   xx, yy, i: integer;
begin
   ImageLib := AtzClass.GetImageLib(ImageName, mmAnsTick);
   // 재능상승 이벤트..
   if EventTick <> 0 then begin
      if EventTick + 150 < mmAnsTick then begin
         lblJobPoint.FontColor := 32767;
         EventTick := 0;
      end else begin
         lblJobPoint.FontColor := Random(32767);
      end;
   end else begin
      lblJobPoint.FontColor := 32767;
   end;

   if bMakeState = ms_making then begin
      // Progress Calculate..
      TickAgo := mmAnsTick - FDelay;
      if TickAgo < 300 then
         Value := TickAgo * 3
      else
         Value := (TickAgo-300) * 3 div 10 + 900;

      // 도구 사운드.. (초기한번, 2.3초 경과후 한번, 4.5초 경과후 한번)
      if (SoundState = 2) and (TickAgo >= 230) then begin
         ATWaveLib.Play(SoundName, 0, EffectVolume);
         SoundState := 1;
      end else
      if (SoundState = 1) and (TickAgo >= 450) then begin
         ATWaveLib.Play(SoundName, 0, EffectVolume);
         SoundState := 0;
      end;

      // 재료들이 하나씩 사라지는 효과
      if TickAgo > 450 then
         Material4.Visible := False
      else if TickAgo > 350 then
         Material3.Visible := False
      else if TickAgo > 250 then
         Material2.Visible := False
      else if TickAgo > 150 then
         Material1.Visible := False
      else if TickAgo > 50 then
         MadeItem.Visible := False;

      // 끝나는 시점...
      if TickAgo > 633 then begin
         Value := 0;
         // 재료들을 화면에 나오게함
         for i := 0 to 4 do begin
            with MatInfoArr[i] do begin
               SetMatrialLabel (rControl, rName, rColor, rShape);
               if rcount <= 1 then rControl.Hint := rName
               else rControl.Hint := rName + ':' + IntToStr(rCount);
               rControl.Visible := True;
            end;
         end;

         bWaitMode := False;
         bMakeState := ms_none;
         ChatMan.AddChat (ResultMsg, WinRGB (22,22,0), 0);
         //AddChat (ResultMsg, WinRGB (22,22,0), 0);
         btnMake.Enabled := True;
         btnClose.Enabled := True;
         if lblJobPoint.Caption <> frmAttrib.Lbtalent.Caption then begin
            EventTick := mmAnsTick;
            lblJobPoint.Caption := frmAttrib.Lbtalent.Caption;
         end;
         ATWaveLib.play(ResultSound, 0, EffectVolume);
      end;

      MakingProgress.Value := Value;

      // Tool Images Animation..
      if (FAniTick < mmAnsTick - 10) then begin
         inc(FAniIndex);
         if ImageLib <> nil then begin
            if FAniIndex >= ImageLib.Count then FAniIndex := 0;
         end;
//         if FAniIndex >= ToolImages.Count then FAniIndex := 0;
         FAniTick := mmAnsTick;
      end;
   end else begin
      FAniIndex := 0;
   end;

   if ImageLib <> nil then begin
      img := ImageLib.Images[FAniIndex];
//   img := ToolImages[FAniIndex];
      if img <> nil then begin
         xx := imgTool.Left + (imgTool.Width - img.Width) div 2;
         yy := imgTool.Top + (imgTool.Height - img.Height) div 2;
         aAnsImage.DrawImage(img, xx, yy, true);
      end;
   end;
end;

procedure TfrmSkill.FormShow(Sender: TObject);
begin
   MakingProgress.Value := 0;
end;

procedure TfrmSkill.materialMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if (Button = mbRight) and (TControl(Sender).Hint <> '') then begin
      ClickTick := mmAnsTick;
      FillChar (GrobalClick, sizeof(GrobalClick), 0);

      GrobalClick.rmsg := CM_SELECTITEMWINDOW;
      GrobalClick.rwindow := WINDOW_SKILL;
      GrobalClick.rclickedId := 0;
      GrobalClick.rShift := KeyShift;
      GrobalClick.rkey := TA2ILabel(Sender).Tag;
   end;
end;

procedure TfrmSkill.materialDblClick(Sender: TObject);
begin
   DragItem.Selected := TComponent(Sender).Tag;
   DragItem.SourceId := WINDOW_SKILL;
   DragItem.Dragedid := 0;
   DragItem.sx := 0; DragItem.sy := 0;

   frmAttrib.ItemLabelDragDrop(frmAttrib.A2ILabel0, DragItem, 16, 16); 
end;

procedure TfrmSkill.imgToolDblClick(Sender: TObject);
begin
   frmSkillManufact.ShowList(lblJobKind.Caption, lblJobGrade.Caption);
end;

procedure TfrmSkill.FormHide(Sender: TObject);
begin
   if frmSkillManufact.Visible then
      frmSkillManufact.Visible := False;
end;

procedure TfrmSkill.imgToolMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if Button = mbRight then begin
      imgTool.OnDblClick(Sender);
   end;
end;

end.

