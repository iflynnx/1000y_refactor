unit FWearItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, CharCls, deftype, NativeXml;
type
  TFrmWearItem = class(TForm)
    A2Form: TA2Form;
    A2ILabelFD0: TA2ILabel;
    A2ILabelFD1: TA2ILabel;
    A2ILabelFD2: TA2ILabel;
    A2ILabelFD3: TA2ILabel;
    A2ILabelFD4: TA2ILabel;
    A2ILabelFD5: TA2ILabel;
    A2ILabelFD6: TA2ILabel;
    A2ILabelFD7: TA2ILabel;
    A2ILabelFD8: TA2ILabel;
    A2ILabelFD9: TA2ILabel;
    A2Button_win: TA2Button;
    A2Panel1: TA2Panel;
    A2Button_fdmode: TA2Button;
    A2Panel2: TA2Panel;
    A2ILabel9: TA2ILabel;
    A2ILabel8: TA2ILabel;
    A2ILabel7: TA2ILabel;
    A2ILabel6: TA2ILabel;
    A2ILabel5: TA2ILabel;
    A2ILabel4: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel1: TA2ILabel;
    A2ILabel0: TA2ILabel;
    A2Button_MODE: TA2Button;
    A2Button_FDwin: TA2Button;
    A2ILabelFD10: TA2ILabel;
    A2ILabelFD11: TA2ILabel;
    A2ILabelFD12: TA2ILabel;
    A2ILabelFD13: TA2ILabel;
    A2ILabel10: TA2ILabel;
    A2ILabel11: TA2ILabel;
    A2ILabel12: TA2ILabel;
    A2ILabel13: TA2ILabel;
    A2ILImg: TA2ILabel;
    A2ILabel_money: TA2ILabel;
    A2Button_close: TA2Button;
    LbCharFD: TA2ILabel;
    LbChar: TA2ILabel;
    A2Button5: TA2Button;
    Panel_item: TPanel;
    A2ILabelItem1: TA2ILabel;
    A2ILabelItem2: TA2ILabel;
    A2ILabelItem3: TA2ILabel;
    A2ILabelItem4: TA2ILabel;
    A2ILabelItem5: TA2ILabel;
    A2ILabelItem6: TA2ILabel;
    A2ILabelItem7: TA2ILabel;
    A2ILabelItem8: TA2ILabel;
    A2ILabelItem9: TA2ILabel;
    A2ILabelItem10: TA2ILabel;
    A2ILabelItem11: TA2ILabel;
    A2ILabelItem12: TA2ILabel;
    A2ILabelItem13: TA2ILabel;
    A2ILabelItem14: TA2ILabel;
    A2ILabelItem15: TA2ILabel;
    A2ILabelItem16: TA2ILabel;
    A2ILabelItem17: TA2ILabel;
    A2ILabelItem18: TA2ILabel;
    A2ILabelItem19: TA2ILabel;
    A2ILabelItem20: TA2ILabel;
    A2ILabelItem21: TA2ILabel;
    A2ILabelItem22: TA2ILabel;
    A2ILabelItem23: TA2ILabel;
    A2ILabelItem24: TA2ILabel;
    A2ILabelItem25: TA2ILabel;
    A2ILabelItem26: TA2ILabel;
    A2ILabelItem27: TA2ILabel;
    A2ILabelItem28: TA2ILabel;
    A2ILabelItem29: TA2ILabel;
    A2ILabelItem30: TA2ILabel;
    Panel_quest: TPanel;
    A2ILabel_QItem0: TA2ILabel;
    A2ILabel_QItem1: TA2ILabel;
    A2ILabel_QItem2: TA2ILabel;
    A2ILabel_QItem3: TA2ILabel;
    A2ILabel_QItem4: TA2ILabel;
    A2ILabel_QItem5: TA2ILabel;
    A2ILabel_QItem6: TA2ILabel;
    A2ILabel_QItem7: TA2ILabel;
    A2ILabel_QItem8: TA2ILabel;
    A2ILabel_QItem9: TA2ILabel;
    A2ILabel_QItem10: TA2ILabel;
    A2ILabel_QItem11: TA2ILabel;
    A2ILabel_QItem12: TA2ILabel;
    A2ILabel_QItem13: TA2ILabel;
    A2ILabel_QItem14: TA2ILabel;
    A2ILabel_QItem15: TA2ILabel;
    A2ILabel_QItem16: TA2ILabel;
    A2ILabel_QItem17: TA2ILabel;
    A2ILabel_QItem18: TA2ILabel;
    A2ILabel_QItem19: TA2ILabel;
    A2ILabel_QItem20: TA2ILabel;
    A2ILabel_QItem21: TA2ILabel;
    A2ILabel_QItem22: TA2ILabel;
    A2ILabel_QItem23: TA2ILabel;
    A2ILabel_QItem24: TA2ILabel;
    A2ILabel_QItem25: TA2ILabel;
    A2ILabel_QItem26: TA2ILabel;
    A2ILabel_QItem27: TA2ILabel;
    A2ILabel_QItem28: TA2ILabel;
    A2ILabel_QItem29: TA2ILabel;
    A2CheckBox_item: TA2CheckBox;
    A2CheckBox_quest: TA2CheckBox;
    A2ILabel_money2: TA2ILabel;
    A2LabelSortItem: TA2Button;
    A2LabelCk: TA2Button;
    A2LabelPassword: TA2Button;
    lblBindMoney: TA2ILabel;
    ItemPageBackA2ILabel: TA2ILabel;
    ItemPage2A2ILabel: TA2ILabel;
    ItemPage1A2ILabel: TA2ILabel;
    a2chckbx_SHOWFD: TA2CheckBox;
    a2chckbx_SHOWFD2: TA2CheckBox;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2Button_FDwinClick(Sender: TObject);
    procedure A2Button_winClick(Sender: TObject);
    procedure A2Button_MODEClick(Sender: TObject);
    procedure A2Button_fdmodeClick(Sender: TObject);
    procedure A2Button5Click(Sender: TObject);
    procedure A2ILabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2ILabelFD0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2ILabelFD0StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure A2ILabel0StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure A2ILabel0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabelFD0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel0DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure A2ILabel0DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure A2ILabel0DblClick(Sender: TObject);
    procedure A2ILabelFD0DblClick(Sender: TObject);
    procedure A2ILabel0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabelItem1DblClick(Sender: TObject);
    procedure A2ILabelItem1DragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure A2ILabelItem1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure A2ILabelItem1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabelItem1MouseEnter(Sender: TObject);
    procedure A2ILabelItem1MouseLeave(Sender: TObject);
    procedure A2ILabelItem1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure A2ILabelItem1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabelItem1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ILImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure A2ILImgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Panel1Click(Sender: TObject);
    procedure LbCharFDMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2FormAdxPaint(aAnsImage: TA2Image);
    procedure A2ILabel_QItem9MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Panel_questMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel_itemMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2CheckBox_itemClick(Sender: TObject);
    procedure A2CheckBox_questClick(Sender: TObject);
    procedure LbCharMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Button_FDwinMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure A2Button_MODEMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure A2LabelSortItemClick(Sender: TObject);
    procedure A2LabelCkClick(Sender: TObject);
    procedure A2LabelPasswordClick(Sender: TObject);
    procedure A2ILabelItem1Click(Sender: TObject);
    procedure ItemPage1A2ILabelClick(Sender: TObject);
    procedure ItemPage2A2ILabelClick(Sender: TObject);
    procedure a2chckbx_SHOWFD2Click(Sender: TObject);
    procedure a2chckbx_SHOWFDClick(Sender: TObject);
    procedure showshizhuang;
  private
    ItemPage1_img: TA2Image;
    ItemPage2_img: TA2Image;

    FTestPos: Boolean;
    FUIConfig: TNativeXml;
        { Private declarations }
  public
        { Public declarations }
    SelectedLabel: TA2ILabel;

    SendTick: integer;

    Feature: TFeature;
    FeatureFD: TFeature;
    CharCenterImage: TA2Image;
    wearimg: TA2Image;
    win_CloseDown_img: TA2Image;
    win_CloseUP_img: TA2Image;

        //        wearimgFD:TA2Image;
    CharCenterImageFD: TA2Image;
    FItemArr: array[0..13] of TA2ILabel;
    FItemFDArr: array[0..13] of TA2ILabel;
    FItemImgArr: array[0..13] of TA2Image;
    FItemFDImgArr: array[0..13] of TA2Image;

    ILabels: array[0..29] of TA2ILabel;
    ILabelsQuest: array[0..29] of TA2ILabel;
    A2ImageWearBack: TA2Image;
    A2ImageitemBack: TA2Image;

    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
    procedure updateWearItem(akey: integer; aitem: titemdata);
    procedure ItemPaintFD(akey: integer; aitem: titemdata);
    procedure DrawWearItem;
    procedure SetFeature();
    function GetArrImageLib(aindex, CurTick: integer; aFeature: tFeature): TA2ImageLib;
    procedure sendgetitemtext(akeyid: byte; atype: ItemTextType);
    procedure onHaveitemUPdate(akey: integer; aitem: titemdata);

    procedure onMoney(acount: integer);
    procedure onBindMoney(acount: integer);
    procedure onprestige(Value: integer);
    procedure onprestigeadd(Value: integer);
    procedure onKEYF5_f8Item(akey: byte; aitem: TA2Image);
    procedure onHaveitemQuestUPdate(akey: integer; aitem: titemdata);
    procedure SetNewVersion;
   // procedure SetOldVersion;


   // procedure SetNewVersionOld();
    procedure SetNewVersionTest();
    procedure SetTestPos(ATestPos: Boolean);
    function GetTestPos: Boolean;
    procedure SetControlPos(AControl: TControl);
    procedure SetA2ImgPos(AImg: TA2Image);
  end;

var
  FrmWearItem: TFrmWearItem;
    // WearCharClass   :TCharClass;
implementation

uses FMain, FAttrib, Fbl, AtzCls, uAnsTick, cltype, filepgkclass,
  FBottom, BackScrn, Math, uPersonBat, Unit_console, FQuest,
  FGameToolsNew, FDepository, FPassEtc, FPassEtcEdit, BaseUIForm, FHorn;

{$R *.dfm}
//var
  //  SelWearItemIndex:integer = 0;
  //  SelectedItemLabel:TA2ILabel = nil;

procedure TFrmWearItem.onKEYF5_f8Item(akey: byte; aitem: TA2Image);
begin
  FrmConsole.cprint(lt_have, format('%s,KEY%d,%d', ['onKEYF5_f8Item', akey, mmAnsTick]));
  ILabels[akey].A2ImageLUP := aitem;
end;

procedure TFrmWearItem.SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
var
  gc, ga: integer;
begin
  FrmConsole.cprint(lt_have, format('%s,%d', ['SetItemLabel', mmAnsTick]));
    //savekeyImagelib[idx]
  Lb.Caption := aname;
  Lb.Font.Color := shapeLUP;
 // Lb.Font.Size:=2;
  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;
    // Lb.BColor := Color;
  //  Lb.A2Imageback := A2ImageitemBack;
   // Lb.A2Image := A2ImageitemBack;
  if shape = 0 then
  begin
    Lb.A2Image := nil;
    Lb.A2ImageRDown := nil;

        // lb.Visible := false;
    exit;
  end else
  begin
    lb.Visible := true;
    Lb.A2Image := AtzClass.GetItemImage(shape);
    if shapeRdown = 0 then Lb.A2ImageRDown := nil
    else
      Lb.A2ImageRDown := savekeyImagelib[shapeRdown];

  end;

end;

procedure TFrmWearItem.onprestige(Value: integer);
begin

//    A2ILabel_prestige.Caption := inttostr(Value);

end;

procedure TFrmWearItem.onprestigeadd(Value: integer);
begin
  PersonBat.LeftMsgListadd3(format('获得荣誉%d点', [Value]), WinRGB(22, 22, 0));
end;

procedure TFrmWearItem.onMoney(acount: integer);
begin
  A2ILabel_money2.Caption := '元宝：' + inttostr(acount);
end;

procedure TFrmWearItem.onHaveitemQuestUPdate(akey: integer; aitem: titemdata);
var
  view: string;
  lcolor: Integer;
begin
  frmquest.onQuestItemUPdate(aitem);
  FrmConsole.cprint(lt_have, format('%s,KEY%d,%d', ['任务背包位置变化', akey, mmAnsTick]));
  if aitem.rName = '' then
  begin
    SetItemLabel(ILabelsQuest[akey], '', 0, 0, 0, 0);
  end else
  begin
    if aitem.rCount > 1 then
    begin
      if aitem.rCount > 10000 then view := IntToStr(aitem.rCount div 10000) + '万'
      else view := IntToStr(aitem.rCount) + '个';
      lcolor := clWhite;
    end;

    SetItemLabel(ILabelsQuest[akey], view, aitem.rColor, aitem.rshape, 0, lcolor);

  end;
end;

procedure TFrmWearItem.onHaveitemUPdate(akey: integer; aitem: titemdata);
var
  idx, lcolor: integer;
  view: string;
begin
  FrmConsole.cprint(lt_have, format('%s,KEY%d,%d', ['背包位置变化', akey, mmAnsTick]));
  try
    ILabels[akey].caption := '';
  except
  end;
  if aitem.rViewName = '' then
  begin

    SetItemLabel(ILabels[akey], '', 0, 0, 0, 0);
      //  FrmBottom.ShortcutKeyUP(akey + 60);
    ILabels[akey].Hint := '';
    cKeyClass.delType(kcdk_HaveItem, akey);
  end else
  begin
    if aitem.rlockState = 1 then idx := 24
    else if aitem.rlockState = 2 then idx := 25
    else idx := 0;
//    if aitem.rboident then
//    begin
//      view := '可鉴定'; //20130720修改
//      lcolor := clGreen;
//    end;
//    if (aitem.rCount > 1) then
//    begin
//      if aitem.rCount > 10000 then view := IntToStr(aitem.rCount div 10000) + '万'
//      else view := IntToStr(aitem.rCount) + '个';
//      lcolor := clWhite;
//    end;
//    if aitem.rDurability > 0 then
//    begin
//      if aitem.rDurability >= 10000 then view := '持久' + inttostr(aitem.rDurability div 10000) + '万' else view := '持久' + inttostr(aitem.rDurability);
//      lcolor := clred;
//    end;
    //      if not FrmGameToolsNew.A2CheckBox_ShowItem.Checked then view:='';
    SetItemLabel(ILabels[akey], view, aitem.rColor, aitem.rshape, idx, lcolor);
//        FrmBottom.ShortcutKeyUP(akey + 60);
    cKeyClass.UpdateType(kcdk_HaveItem, akey);
  end;
  //frmSkill.onHaveitemUPdate(akey, aitem);
end;

procedure TFrmWearItem.SetFeature();
var
  i: integer;
  aitem: TItemData;
  Cl: TCharClass;
begin
  FrmConsole.cprint(lt_have, '背包角色，设置外观' + inttostr(mmAnsTick));
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  Feature := Cl.Feature;
  FeatureFD := Cl.Feature;

  for i := ARR_GLOVES to ARR_WEAPON do
  begin
    aitem := WearItemclass.Wear.get(i);
    Feature.rArr[i * 2] := aitem.rWearShape;
    Feature.rArr[i * 2 + 1] := aitem.rColor;
  end;

  for i := ARR_GLOVES to ARR_WEAPON do
  begin
    aitem := WearItemclass.WearFD.get(i);
    FeatureFD.rArr[i * 2] := aitem.rWearShape;
    FeatureFD.rArr[i * 2 + 1] := aitem.rColor;
  end;
  aitem := WearItemclass.wear.get(ARR_WEAPON);
  FeatureFD.rArr[ARR_WEAPON * 2] := aitem.rWearShape;
  FeatureFD.rArr[ARR_WEAPON * 2 + 1] := aitem.rColor;

end;

function TFrmWearItem.GetArrImageLib(aindex, CurTick: integer; aFeature: tFeature): TA2ImageLib;
begin
  FrmConsole.cprint(lt_have, format('%s,%d,%d', ['GetArrImageLib查找图片', aindex, mmAnsTick]));
  if not aFeature.rboMan then
    Result := AtzClass.GetImageLib(char(word('a') + aindex) + format('%d0.atz', [aFeature.rArr[aindex * 2]]), CurTick)
  else
    Result := AtzClass.GetImageLib(char(word('n') + aindex) + format('%d0.atz', [aFeature.rArr[aindex * 2]]), CurTick);
end;

procedure TFrmWearItem.DrawWearItem;
var
  i, gc, ga: integer;
  Cl: TCharClass;
  ImageLib: TA2ImageLib;
begin
  FrmConsole.cprint(lt_have, '背包角色绘制' + inttostr(mmAnsTick));
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  Feature.rboman := CL.Feature.rboMan;
  FeatureFD.rboman := CL.Feature.rboMan;
  CharCenterImage.Clear(0);

  for i := 0 to 10 - 1 do
  begin
    ImageLib := GetArrImageLib(i, mmAnsTick, Feature);
    if ImageLib <> nil then
    begin
      GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
      if Feature.rArr[i * 2 + 1] = 0 then
        CharCenterImage.DrawImage(
          ImageLib.Images[57],
          ImageLib.Images[57].px + CHarMaxSiezHalf,
          ImageLib.Images[57].py + CHarMaxSiezHalf,
          TRUE)
      else
        CharCenterImage.DrawImageGreenConvert(
          ImageLib.Images[57],
          ImageLib.Images[57].px + CHarMaxSiezHalf,
          ImageLib.Images[57].py + CHarMaxSiezHalf,
          gc, ga);
    end;
  end;
  LbChar.A2Image := CharCenterImage;
  CharCenterImageFD.Clear(0);

  for i := 0 to 10 - 1 do
  begin
    ImageLib := GetArrImageLib(i, mmAnsTick, FeatureFD);
    if ImageLib <> nil then
    begin
      GetGreenColorAndAdd(FeatureFD.rArr[i * 2 + 1], gc, ga);
      if FeatureFD.rArr[i * 2 + 1] = 0 then
        CharCenterImageFD.DrawImage(
          ImageLib.Images[57],
          ImageLib.Images[57].px + CHarMaxSiezHalf,
          ImageLib.Images[57].py + CHarMaxSiezHalf,
          TRUE)
      else
        CharCenterImageFD.DrawImageGreenConvert(
          ImageLib.Images[57],
          ImageLib.Images[57].px + CHarMaxSiezHalf,
          ImageLib.Images[57].py + CHarMaxSiezHalf,
          gc, ga);
    end;
  end;
  LbCharFD.A2Image := CharCenterImageFD;
  //判断时装按钮状态
  if cl.Feature.rboFashionable then
  begin
    a2chckbx_SHOWFD2.Checked := True;
    a2chckbx_SHOWFD.Checked := True;
  end;
end;

procedure TFrmWearItem.updateWearItem(akey: integer; aitem: titemdata);
var
  idx, lcolor: integer;
  str, view: string;
begin
  FrmConsole.cprint(lt_have, '装备某位置变化' + inttostr(mmAnsTick));
  str := (aitem.rViewName);
  try
    FItemArr[akey].caption := '';
  except
  end;
  if str = '' then
  begin

        //            FItemArr[i].Visible := false;
    FItemArr[akey].A2Image := nil;
    FItemArr[akey].A2ImageRDown := nil;
    FItemArr[akey].A2ImageLUP := nil;
        //   FItemArr[akey].Visible := false;
    FItemArr[akey].A2Imageback := FItemImgArr[akey];
    FItemArr[akey].A2Image := FItemImgArr[akey];
  end else
  begin
    if aitem.rlockState = 1 then idx := 24
    else if aitem.rlockState = 2 then idx := 25
    else idx := 0;
//    if aitem.rboident then
//    begin
//      view := '可鉴定'; //20130720修改
//      lcolor := clGreen;
//    end;
//    if (aitem.rCount > 1) then
//    begin
//      if aitem.rCount > 10000 then view := IntToStr(aitem.rCount div 10000) + '万'
//      else view := IntToStr(aitem.rCount) + '个';
//      lcolor := clWhite;
//    end;
//    if aitem.rDurability > 0 then
//    begin
//      if aitem.rDurability >= 10000 then view := '持久' + inttostr(aitem.rDurability div 10000) + '万' else view := '持久' + inttostr(aitem.rDurability);
//      lcolor := clred;
//    end;
    //      if not FrmGameToolsNew.A2CheckBox_Showitem.Checked then view:='';
    FItemArr[akey].A2Imageback := A2ImageWearBack;
    SetItemLabel(FItemArr[akey]
      , view
      , aitem.rColor
      , aitem.rShape
      , idx, lcolor

      );

    FItemArr[akey].Visible := true;
  end;
  SetFeature;
  DrawWearItem;
end;

procedure TFrmWearItem.ItemPaintFD(akey: integer; aitem: titemdata);
var
  idx: integer;
  str: string;
begin
  FrmConsole.cprint(lt_have, '时装某位置变化' + inttostr(mmAnsTick));
  str := (aitem.rViewName);
  if str = '' then
  begin
        //FItemFDArr[i].Visible := false;
    FItemFDArr[akey].A2Image := nil;

    FItemFDArr[akey].A2ImageRDown := nil;
    FItemFDArr[akey].A2ImageLUP := nil;
        //        FItemFDArr[akey].Visible := false;
    FItemfdArr[akey].A2Imageback := FItemfdImgArr[akey];
    FItemfdArr[akey].A2Image := FItemfdImgArr[akey];
  end else
  begin
    if aitem.rlockState = 1 then idx := 24
    else if aitem.rlockState = 2 then idx := 25
    else idx := 0;
    FItemfdArr[akey].A2Imageback := A2ImageWearBack;
    FrmAttrib.SetItemLabel(FItemFDArr[akey]
      , ''
      , aitem.rColor
      , aitem.rShape
      , idx, 0

      );

    FItemFDArr[akey].Visible := true;
  end;
  SetFeature;
  DrawWearItem;
end;

procedure TFrmWearItem.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmWearItem.A2Button_FDwinClick(Sender: TObject);
begin

  a2Panel1.Visible := true;
  a2Panel2.Visible := not a2Panel1.Visible;

end;

procedure TFrmWearItem.A2Button_winClick(Sender: TObject);
begin
  a2Panel1.Visible := false;
  a2Panel2.Visible := not a2Panel1.Visible;

end;

procedure TFrmWearItem.A2Button_MODEClick(Sender: TObject);
var
  temp: TWordComData;
begin
  FrmConsole.cprint(lt_have, '装备显示' + inttostr(mmAnsTick));
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_SET_OK);
  WordComData_ADDbyte(temp, SET_OK_wear);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmWearItem.A2Button_fdmodeClick(Sender: TObject);
var
  temp: TWordComData;
begin
  FrmConsole.cprint(lt_have, '时装显示' + inttostr(mmAnsTick));
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_SET_OK);
  WordComData_ADDbyte(temp, SET_OK_wearFD);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmWearItem.A2Button5Click(Sender: TObject);
begin
  Visible := false;
end;

procedure TFrmWearItem.sendgetitemtext(akeyid: byte; atype: ItemTextType);
var
  getcmd: TGET_cmd;
begin
  getcmd.rmsg := CM_GET;
  getcmd.rKEY := Get_ItemText;
  getcmd.rKEY2 := byte(atype);
  GETCMD.rKEY3 := akeyid;
  Frmfbl.SocketAddData(SIZEOF(GETCMD), @GETCMD);
end;

procedure TFrmWearItem.A2ILabel0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  id: integer;
  aitem: titemdata;
begin
  if SelectedLabel = Sender then TA2ILabel(Sender).BeginDrag(true);
  SelectedLabel := nil;

  id := tA2ILabel(Sender).Tag;
  aitem := WearItemclass.wear.get(ID);
  if aitem.rViewName <> '' then GameHint.setText(integer(Sender), TItemDataToStr(aitem))
  else GameHint.Close;

end;

procedure TFrmWearItem.A2ILabelFD0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  id: integer;
  aitem: titemdata;
begin
  if SelectedLabel = Sender then TA2ILabel(Sender).BeginDrag(true);
  SelectedLabel := nil;
    {    if (mmAnsTick - SendTick) < 100 then exit;
        SendTick := mmAnsTick;
        id := tA2ILabel(Sender).Tag;

        if (mmAnsTick - FrmAttrib.WearItemFDArr[id].rgettime) < 1000 then exit;
        FrmAttrib.WearItemFDArr[id].rgettime := mmAnsTick;
        sendgetitemtext(id, ittWearItemTextFD);
      }
  id := tA2ILabel(Sender).Tag;
  aitem := WearItemclass.wearFD.get(id);
  if aitem.rViewName <> '' then GameHint.setText(integer(Sender), TItemDataToStr(aitem))
  else GameHint.Close;
end;

procedure TFrmWearItem.A2ILabelFD0StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  DragItem.Selected := tA2ILabel(Sender).Tag + 100;
  DragItem.Dragedid := 0;
  DragItem.SourceId := WINDOW_WEARS;
  DragObject := DragItem;

end;

procedure TFrmWearItem.A2ILabel0StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  DragItem.Selected := tA2ILabel(Sender).Tag;
  DragItem.Dragedid := 0;
  DragItem.SourceId := WINDOW_WEARS;
  DragObject := DragItem;

end;

procedure TFrmWearItem.A2ILabel0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectedLabel := tA2ILabel(Sender);
end;

procedure TFrmWearItem.A2ILabelFD0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectedLabel := tA2ILabel(Sender);
end;

procedure TFrmWearItem.A2ILabel0DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      if SourceID = WINDOW_ITEMS then Accept := TRUE;
    end;
  end;
end;

procedure TFrmWearItem.A2ILabel0DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  cDragDrop: TCDragDrop;
begin

  if Source = nil then exit;

  with Source as TDragItem do
  begin
    if SourceID <> WINDOW_ITEMS then exit;
    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := DragedId;
    cDragDrop.rdestId := 0;
    cDragDrop.rsourwindow := SourceId;
    cDragDrop.rdestwindow := WINDOW_WEARS;
    cDragDrop.rsourkey := Selected;
    cDragDrop.rdestkey := TA2ILabel(Sender).tag;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop);
  end;
end;

procedure TFrmWearItem.A2ILabel0DblClick(Sender: TObject);
var
  cDragDrop: TCDragDrop;
begin

  begin

    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := 0;
    cDragDrop.rdestId := 0;
    cDragDrop.rsx := 0;
    cDragDrop.rsy := 0;
    cDragDrop.rdx := 0;
    cDragDrop.rdy := 0;
    cDragDrop.rsourwindow := WINDOW_WEARS;
    cDragDrop.rdestwindow := WINDOW_ITEMS;
    cDragDrop.rsourkey := tA2ILabel(Sender).Tag;
    cDragDrop.rdestkey := 0;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop); // server r
  end;
end;

procedure TFrmWearItem.A2ILabelFD0DblClick(Sender: TObject);
var
  cDragDrop: TCDragDrop;
begin

  begin

    cDragDrop.rmsg := CM_DRAGDROP;
    cDragDrop.rsourId := 0;
    cDragDrop.rdestId := 0;
    cDragDrop.rsx := 0;
    cDragDrop.rsy := 0;
    cDragDrop.rdx := 0;
    cDragDrop.rdy := 0;
    cDragDrop.rsourwindow := WINDOW_WEARS;
    cDragDrop.rdestwindow := WINDOW_ITEMS;
    cDragDrop.rsourkey := tA2ILabel(Sender).Tag + 100;
    cDragDrop.rdestkey := 0;
    Frmfbl.SocketAddData(sizeof(cDragDrop), @cDragDrop); // server r
  end;
  GameHint.Close;
end;

procedure TFrmWearItem.A2ILabel0MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectedLabel := nil;
end;

procedure TFrmWearItem.A2ILabelItem1DblClick(Sender: TObject);
begin
  FrmAttrib.ItemLabelDblClick(Sender);
  GameHint.Close;
end;

procedure TFrmWearItem.A2ILabelItem1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  FrmAttrib.ItemLabelDragDrop(Sender, Source, X, Y);
end;

procedure TFrmWearItem.A2ILabelItem1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  FrmAttrib.A2ILabel0DragOver(Sender, Source, X, Y, State, Accept, );
end;

procedure TFrmWearItem.A2ILabelItem1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  aitem: TItemData;
  frm: TForm;
  cfrm: TFrmHorn;
begin
  if (ssAlt in shift) and (button = mbLeft)
    then
  begin
    aitem := HaveItemclass.get(TA2ILabel(Sender).Tag);
    if (aitem.rKind <> ITEM_KIND_WEARITEM) and (aitem.rKind <> ITEM_KIND_WEARITEM_FD) then Exit;
    frm := FrmM.findForm('TFrmHorn');
    cfrm := nil;
    if frm <> nil then
    begin
      cfrm := TFrmHorn(frm);
      if (cfrm <> nil) and cfrm.Visible then
      begin
        cfrm.FSelectedChatItemData := aitem;
        cfrm.SetChatInfo;
      end
      else
      begin
        FrmBottom.FSelectedChatItemData := aitem;
        FrmBottom.SetChatInfo;
      end;

    end
    else
    begin
      FrmBottom.FSelectedChatItemData := aitem;
      FrmBottom.SetChatInfo;
    end;
  end else
    FrmAttrib.A2ILabel0MouseDown(Sender, Button, Shift, X, Y);

end;

procedure TFrmWearItem.A2ILabelItem1MouseEnter(Sender: TObject);
begin
  FrmAttrib.A2ILabel0MouseEnter(Sender);
  GameHint.Close;
end;

procedure TFrmWearItem.A2ILabelItem1MouseLeave(Sender: TObject);
begin
  FrmAttrib.A2ILabel0MouseLeave(Sender);
  GameHint.Close;
end;

procedure TFrmWearItem.A2ILabelItem1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Temp: TA2ILabel;
  aitem: TItemData;
begin
    //    SelectedItemLabel := Ta2ILabel(Sender);
    {keyselmagicindexadd := TA2ILabel(Sender).Tag + 60;
     Temp := Ta2ILabel(Sender);
     if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
     begin
         if temp.A2Image <> nil then Temp.BeginDrag(TRUE);
         A2Form.FA2Hint.setText('');
         exit;
     end;
    aitem := HaveItemclass.get(TA2ILabel(Sender).Tag);
    if aitem.rName = '' then exit;
    A2Form.FA2Hint.setText(TItemDataToStr(aitem));
    }
  keyselmagicindexadd := TA2ILabel(Sender).Tag + 90; //60改150
  Temp := Ta2ILabel(Sender);
  if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
  begin
    if temp.A2Image <> nil then Temp.BeginDrag(TRUE);
    GameHint.Close;
    exit;
  end;
  aitem := HaveItemclass.get(TA2ILabel(Sender).Tag);
  if aitem.rName <> '' then
    GameHint.setText(integer(Sender), TItemDataToStr(aitem))
  else GameHint.Close;
//    GameHint.pos(move_win_X, move_win_y);

end;

procedure TFrmWearItem.A2ILabelItem1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FrmAttrib.A2ILabel0MouseUp(Sender, Button, Shift, X, Y);
end;

procedure TFrmWearItem.A2ILabelItem1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  FrmAttrib.ItemLabelStartDrag(Sender, DragObject);
end;

procedure TFrmWearItem.FormDestroy(Sender: TObject);
var
  i: integer;
begin
    //WearCharClass.Free;

  for i := 0 to high(FItemImgArr) do
  begin
    FItemImgArr[i].Free;
  end;
  for i := 0 to high(FItemFDImgArr) do
  begin
    FItemFDImgArr[i].Free;
  end;
  wearimg.Free;
  CharCenterImage.Free;
  CharCenterImageFD.Free;
  win_CloseUP_img.Free;
  win_CloseDown_img.free;
  A2ImageWearBack.Free;
  A2ImageitemBack.Free;
end;

procedure TFrmWearItem.SetNewVersion;

begin
  if FTestPos then
    SetNewVersionTest;
  //else
  //  SetNewVersionOld;

end;

//procedure TFrmWearItem.SetOldVersion;
//var
//  i: integer;
//begin
//  win_CloseUP_img := TA2Image.Create(32, 32, 0, 0);
//  win_CloseDown_img := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('X 关闭UP.bmp', win_CloseUP_img);
//  pgkBmp.getBmp('X 关闭DOWN.bmp', win_CloseDown_img);
//  A2Button_close.A2Down := win_CloseDown_img;
//  A2Button_close.A2Up := win_CloseUP_img;
//    //   LbChar.A2Image := FrmAttrib.CharCenterImage;
//
//  wearimg := TA2Image.Create(ClientWidth, ClientHeight, 0, 0);
//    //    wearimgFD := TA2Image.Create(ClientWidth, ClientHeight, 0, 0);
//  pgkBmp.getBmp('角色窗.bmp', wearimg);
//  A2ImageWearBack := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('装备底框.bmp', A2ImageWearBack);
//
//  A2ImageitemBack := TA2Image.Create(32, 32, 0, 0);
//    //A2ImageitemBack.Clear(0);
//  pgkBmp.getBmp('物品底框.bmp', A2ImageitemBack);
//  for i := 0 to high(FItemImgArr) do
//  begin
//    FItemImgArr[i] := TA2Image.Create(32, 32, 0, 0);
//    FItemImgArr[i].DrawImage(A2ImageWearBack, 0, 0, false);
//  end;
//  for i := 0 to high(FItemFDImgArr) do
//  begin
//    FItemFDImgArr[i] := TA2Image.Create(32, 32, 0, 0);
//    FItemFDImgArr[i].DrawImage(A2ImageWearBack, 0, 0, false);
//  end;
//
//  pgkBmp.getBmp('护腕.bmp', FItemImgArr[1]);
//  pgkBmp.getBmp('内衣.bmp', FItemImgArr[2]);
//  pgkBmp.getBmp('鞋子.bmp', FItemImgArr[3]);
//  pgkBmp.getBmp('裤子.bmp', FItemImgArr[4]);
//
//  pgkBmp.getBmp('衣服.bmp', FItemImgArr[6]);
//  pgkBmp.getBmp('头发.bmp', FItemImgArr[7]);
//  pgkBmp.getBmp('帽子.bmp', FItemImgArr[8]);
//  pgkBmp.getBmp('武器.bmp', FItemImgArr[9]);
//
//  pgkBmp.getBmp('护腕.bmp', FItemfdImgArr[1]);
//  pgkBmp.getBmp('内衣.bmp', FItemfdImgArr[2]);
//  pgkBmp.getBmp('鞋子.bmp', FItemfdImgarr[3]);
//  pgkBmp.getBmp('裤子.bmp', FItemfdImgArr[4]);
//
//  pgkBmp.getBmp('衣服.bmp', FItemfdImgArr[6]);
//  pgkBmp.getBmp('头发.bmp', FItemfdImgArr[7]);
//  pgkBmp.getBmp('帽子.bmp', FItemfdImgArr[8]);
//  pgkBmp.getBmp('武器.bmp', FItemfdImgArr[9]);
//    //    pgkBmp.getBmp('wearfd.bmp', wearimgFD);
//
//  A2ILImg.A2Image := wearimg;
//    //    A2ILImgFD.A2Image := wearimgFD;
//        //Parent := FrmM;
//
//  FItemArr[0] := A2ILabel0;
//  FItemArr[1] := A2ILabel1;
//  FItemArr[2] := A2ILabel2;
//  FItemArr[3] := A2ILabel3;
//  FItemArr[4] := A2ILabel4;
//  FItemArr[5] := A2ILabel5;
//  FItemArr[6] := A2ILabel6;
//  FItemArr[7] := A2ILabel7;
//  FItemArr[8] := A2ILabel8;
//  FItemArr[9] := A2ILabel9;
//  FItemArr[10] := A2ILabel10;
//  FItemArr[11] := A2ILabel11;
//  FItemArr[12] := A2ILabel12;
//  FItemArr[13] := A2ILabel13;
//
//  FItemFDArr[0] := A2ILabelFD0;
//  FItemFDArr[1] := A2ILabelFD1;
//  FItemFDArr[2] := A2ILabelFD2;
//  FItemFDArr[3] := A2ILabelFD3;
//  FItemFDArr[4] := A2ILabelFD4;
//  FItemFDArr[5] := A2ILabelFD5;
//  FItemFDArr[6] := A2ILabelFD6;
//  FItemFDArr[7] := A2ILabelFD7;
//  FItemFDArr[8] := A2ILabelFD8;
//  FItemFDArr[9] := A2ILabelFD9;
//  FItemFDArr[10] := A2ILabelFD10;
//  FItemFDArr[11] := A2ILabelFD11;
//  FItemFDArr[12] := A2ILabelFD12;
//  FItemFDArr[13] := A2ILabelFD13;
//
//  for i := 0 to high(FItemArr) do
//  begin
//    FItemArr[i].Tag := i;
//    FItemArr[i].A2Imageback := FItemimgArr[i];
//  end;
//  for i := 0 to high(FItemFDArr) do
//  begin
//    FItemFDArr[i].Tag := i;
//    FItemArr[i].A2Imageback := FItemFDimgArr[i];
//  end;
//  a2Panel1.Visible := false;
//  a2Panel2.Visible := not a2Panel1.Visible;
//  CharCenterImage := TA2Image.Create(160, 160, 0, 0);
//
//  LbChar.A2Image := CharCenterImage;
//
//  CharCenterImageFD := TA2Image.Create(160, 160, 0, 0);
//  LbCharFD.A2Image := CharCenterImageFD;
//
//  A2Button_fdwin.Top := A2Button_win.Top;
//  A2Button_FDwin.Left := A2Button_win.Left;
//  A2Button_mode.Top := A2Button_fdmode.Top;
//  A2Button_mode.Left := A2Button_fdmode.Left;
//
//  LbChar.Top := LbCharfd.Top;
//  LbChar.Left := LbCharfd.Left;
////    A2Form.FA2Hint.Ftype := hstTransparent;
//  A2Panel2.Top := A2Panel1.Top;
//  A2Panel2.Left := A2Panel1.Left;
//  FItemArr[0].Top := FItemFDArr[0].Top;
//  FItemArr[0].Left := FItemFDArr[0].Left;
//  FItemArr[1].Top := FItemFDArr[1].Top;
//  FItemArr[1].Left := FItemFDArr[1].Left;
//  FItemArr[2].Top := FItemFDArr[2].Top;
//  FItemArr[2].Left := FItemFDArr[2].Left;
//  FItemArr[3].Top := FItemFDArr[3].Top;
//  FItemArr[3].Left := FItemFDArr[3].Left;
//  FItemArr[4].Top := FItemFDArr[4].Top;
//  FItemArr[4].Left := FItemFDArr[4].Left;
//  FItemArr[6].Top := FItemFDArr[6].Top;
//  FItemArr[6].Left := FItemFDArr[6].Left;
//  FItemArr[7].Top := FItemFDArr[7].Top;
//  FItemArr[7].Left := FItemFDArr[7].Left;
//  FItemArr[8].Top := FItemFDArr[8].Top;
//  FItemArr[8].Left := FItemFDArr[8].Left;
//  FItemArr[9].Top := FItemFDArr[9].Top;
//  FItemArr[9].Left := FItemFDArr[9].Left;
//
//  ILabels[0] := A2ILabelItem1;
//  ILabels[1] := A2ILabelItem2;
//  ILabels[2] := A2ILabelItem3;
//  ILabels[3] := A2ILabelItem4;
//  ILabels[4] := A2ILabelItem5;
//  ILabels[5] := A2ILabelItem6;
//  ILabels[6] := A2ILabelItem7;
//  ILabels[7] := A2ILabelItem8;
//  ILabels[8] := A2ILabelItem9;
//  ILabels[9] := A2ILabelItem10;
//  ILabels[10] := A2ILabelItem11;
//  ILabels[11] := A2ILabelItem12;
//  ILabels[12] := A2ILabelItem13;
//  ILabels[13] := A2ILabelItem14;
//  ILabels[14] := A2ILabelItem15;
//  ILabels[15] := A2ILabelItem16;
//  ILabels[16] := A2ILabelItem17;
//  ILabels[17] := A2ILabelItem18;
//  ILabels[18] := A2ILabelItem19;
//  ILabels[19] := A2ILabelItem20;
//  ILabels[20] := A2ILabelItem21;
//  ILabels[21] := A2ILabelItem22;
//  ILabels[22] := A2ILabelItem23;
//  ILabels[23] := A2ILabelItem24;
//  ILabels[24] := A2ILabelItem25;
//  ILabels[25] := A2ILabelItem26;
//  ILabels[26] := A2ILabelItem27;
//  ILabels[27] := A2ILabelItem28;
//  ILabels[28] := A2ILabelItem29;
//  ILabels[29] := A2ILabelItem30;
//  for i := 0 to high(ILabels) do
//  begin
//    ILabels[i].Tag := i;
//  end;
//    //
//end;

procedure TFrmWearItem.FormCreate(Sender: TObject);
var
  tmpStream: TMemoryStream;
begin
  FUIConfig := TNativeXml.Create;
  FUIConfig.Utf8Encoded := True;
  if not zipmode then //2015.11.12 在水一方 >>>>>>
    FUIConfig.LoadFromFile('.\ui\WearItem.xml')
  else begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      if upzipstream(xmlzipstream, tmpStream, 'WearItem.xml') then
        FUIConfig.LoadFromStream(tmpStream);
    finally
      if not alwayscache then
        tmpStream.Free;
    end;
  end; //2015.11.12 在水一方 <<<<<<
  FrmM.AddA2Form(Self, A2Form);
  FTestPos := True;
  top := 20;
  Left := 500;

  ItemPage1_img := TA2Image.Create(32, 32, 0, 0);
  ItemPage1_img.Name := 'ItemPage1_img';
  ItemPage2_img := TA2Image.Create(32, 32, 0, 0);
  ItemPage2_img.Name := 'ItemPage2_img';

  SelectedLabel := nil;
    //WearCharClass := TCharClass.Create(AtzClass);
    //WearCharClass.Initialize('', 0, 0, 0, 0, Feature);
  LbChar.Transparent := true;
  LbCharFD.Transparent := true;
  A2ILabel_money2.Transparent := true;
  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;
end;


procedure TFrmWearItem.A2ILImgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmWearItem.A2ILImgMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  keyselmagicindexadd := -1;
  GameHint.Close;
end;

procedure TFrmWearItem.A2Panel1Click(Sender: TObject);
begin
  keyselmagicindexadd := -1;
  GameHint.Close;
end;

procedure TFrmWearItem.LbCharFDMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  keyselmagicindexadd := -1;
  GameHint.Close;
end;

procedure TFrmWearItem.A2FormAdxPaint(aAnsImage: TA2Image);
begin
  FrmConsole.cprint(lt_have, '背包绘制刷新' + inttostr(mmAnsTick));
end;

procedure TFrmWearItem.A2ILabel_QItem9MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  aitem: TItemData;
begin
  aitem := HaveItemQuestClass.get(TA2ILabel(Sender).Tag);
  if aitem.rName <> '' then
    GameHint.setText(integer(Sender), TItemDataToStr(aitem))
  else GameHint.Close;

end;

procedure TFrmWearItem.Panel_questMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmWearItem.Panel_itemMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmWearItem.A2Panel2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmWearItem.A2Panel1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmWearItem.A2CheckBox_itemClick(Sender: TObject);
begin
  A2CheckBox_quest.Checked := not A2CheckBox_item.Checked;
  Panel_item.Visible := A2CheckBox_item.Checked;
  Panel_quest.Visible := A2CheckBox_quest.Checked;
end;

procedure TFrmWearItem.A2CheckBox_questClick(Sender: TObject);
begin
  A2CheckBox_item.Checked := not A2CheckBox_quest.Checked;
  Panel_item.Visible := A2CheckBox_item.Checked;
  Panel_quest.Visible := A2CheckBox_quest.Checked;
end;

procedure TFrmWearItem.LbCharMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmWearItem.A2Button_FDwinMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmWearItem.A2Button_MODEMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

function TFrmWearItem.GetTestPos: Boolean;
begin
  Result := FTestPos;
end;

procedure TFrmWearItem.SetTestPos(ATestPos: Boolean);
begin
  FTestPos := ATestPos;
end;

//procedure TFrmWearItem.SetNewVersionOld;
//var
//  i: integer;
//  temping: TA2Image;
//begin
//
//
//  temping := TA2Image.Create(32, 32, 0, 0);
//  try
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//    A2Button_close.A2Up := temping;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//    A2Button_close.A2Down := temping;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//    A2Button_close.A2Mouse := temping;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//    A2Button_close.A2NotEnabled := temping;
//
//        //设置背包背景
//    pgkBmp.getBmp('角色物品框.bmp', temping);
//    A2ILImg.A2Image := temping;
//
//    A2ImageWearBack := TA2Image.Create(32, 32, 0, 0);
//    pgkBmp.getBmp('角色物品_装备底框.bmp', A2ImageWearBack);
//    for i := 0 to high(FItemImgArr) do
//    begin
//      FItemImgArr[i] := TA2Image.Create(32, 32, 0, 0);
//      FItemImgArr[i].DrawImage(A2ImageWearBack, 0, 0, false);
//    end;
//
//    pgkBmp.getBmp('物品底框.bmp', temping);
//    for i := 0 to high(FItemImgArr) do
//    begin
//      FItemFDImgArr[i] := TA2Image.Create(32, 32, 0, 0);
//      FItemFDImgArr[i].DrawImage(temping, 0, 0, false);
//    end;
//
//    pgkBmp.getBmp('角色物品_护腕底框.bmp', FItemImgArr[1]);
//    pgkBmp.getBmp('角色物品_内衣底框.bmp', FItemImgArr[2]);
//    pgkBmp.getBmp('角色物品_鞋子底框.bmp', FItemImgArr[3]);
//    pgkBmp.getBmp('角色物品_裤子底框.bmp', FItemImgArr[4]);
//
//    pgkBmp.getBmp('角色物品_上衣底框.bmp', FItemImgArr[6]);
//    pgkBmp.getBmp('角色物品_头发底框.bmp', FItemImgArr[7]);
//    pgkBmp.getBmp('角色物品_帽子底框.bmp', FItemImgArr[8]);
//    pgkBmp.getBmp('角色物品_武器底框.bmp', FItemImgArr[9]);
//
//    pgkBmp.getBmp('角色物品_问号底框.bmp', FItemImgArr[10]);
//    pgkBmp.getBmp('角色物品_问号底框.bmp', FItemImgArr[11]);
//    pgkBmp.getBmp('角色物品_问号底框.bmp', FItemImgArr[12]);
//    pgkBmp.getBmp('角色物品_问号底框.bmp', FItemImgArr[13]);
//
//
//    pgkBmp.getBmp('角色物品_护腕底框.bmp', FItemfdImgArr[1]);
//    pgkBmp.getBmp('角色物品_内衣底框.bmp', FItemfdImgArr[2]);
//    pgkBmp.getBmp('角色物品_鞋子底框.bmp', FItemfdImgarr[3]);
//    pgkBmp.getBmp('角色物品_裤子底框.bmp', FItemfdImgArr[4]);
//
//    pgkBmp.getBmp('角色物品_上衣底框.bmp', FItemfdImgArr[6]);
//    pgkBmp.getBmp('角色物品_头发底框.bmp', FItemfdImgArr[7]);
//    pgkBmp.getBmp('角色物品_帽子底框.bmp', FItemfdImgArr[8]);
//    pgkBmp.getBmp('角色物品_武器底框.bmp', FItemfdImgArr[9]);
//
//    pgkBmp.getBmp('角色物品-装备窗口-弹起.bmp', temping);
//    A2Button_win.A2Up := temping;
//    pgkBmp.getBmp('角色物品-装备窗口-按下.bmp', temping);
//    A2Button_win.A2Down := temping;
//    pgkBmp.getBmp('角色物品-装备窗口-鼠标.bmp', temping);
//    A2Button_win.A2Mouse := temping;
//
//    pgkbmp.getBmp('角色物品-显示时装-弹起.bmp', temping);
//    A2Button_fdmode.A2Up := temping;
//    pgkBmp.getBmp('角色物品-显示时装-按下.bmp', temping);
//    A2Button_fdmode.A2Down := temping;
//    pgkBmp.getBmp('角色物品-显示时装-鼠标.bmp', temping);
//    A2Button_fdmode.A2Mouse := temping;
//
//    pgkBmp.getBmp('角色物品-时装窗口-弹起.bmp', temping);
//    A2Button_FDwin.A2Up := temping;
//    pgkBmp.getBmp('角色物品-时装窗口_按下.bmp', temping);
//    A2Button_FDwin.A2Down := temping;
//    pgkBmp.getBmp('角色物品-时装窗口-鼠标.bmp', temping);
//    A2Button_FDwin.A2Mouse := temping;
//
//    pgkBmp.getBmp('角色物品-显示装备-弹起.bmp', temping);
//    A2Button_MODE.A2Up := temping;
//    pgkBmp.getBmp('角色物品-显示装备-按下.bmp', temping);
//    A2Button_MODE.A2Down := temping;
//    pgkBmp.getBmp('角色物品-显示装备-鼠标.bmp', temping);
//    A2Button_MODE.A2Mouse := temping;
//
//    pgkBmp.getBmp('角色物品_任务_鼠标.bmp', temping);
//    A2CheckBox_quest.SelectImage := temping;
//    pgkBmp.getBmp('角色物品_任务_按下.bmp', temping);
//    A2CheckBox_quest.SelectNotImage := temping;
//    pgkBmp.getBmp('角色物品_任务_禁止.bmp', temping);
//    A2CheckBox_quest.EnabledImage := temping;
//
//
//    pgkBmp.getBmp('角色物品_物品_鼠标.bmp', temping);
//    A2CheckBox_item.SelectImage := temping;
//    pgkBmp.getBmp('角色物品_物品_按下.bmp', temping);
//    A2CheckBox_item.SelectNotImage := temping;
//    pgkBmp.getBmp('角色物品_物品_禁止.bmp', temping);
//    A2CheckBox_item.EnabledImage := temping;
//    A2CheckBox_item.Checked := true;
//
//    pgkBmp.getBmp('角色物品_元宝数量底框.bmp', temping);
//    A2ILabel_money.A2Image := temping;
//
//    Panel_item.Left := 12;
//    Panel_item.Top := 230;
//    Panel_item.Visible := true;
//    Panel_quest.Left := Panel_item.Left;
//    Panel_quest.Top := Panel_item.Top;
//    Panel_quest.Visible := not Panel_item.Visible;
//
//    FItemArr[0] := A2ILabel0;
//    FItemArr[1] := A2ILabel1;
//    FItemArr[2] := A2ILabel2;
//    FItemArr[3] := A2ILabel3;
//    FItemArr[4] := A2ILabel4;
//    FItemArr[5] := A2ILabel5;
//    FItemArr[6] := A2ILabel6;
//    FItemArr[7] := A2ILabel7;
//    FItemArr[8] := A2ILabel8;
//    FItemArr[9] := A2ILabel9;
//    FItemArr[10] := A2ILabel10;
//    FItemArr[11] := A2ILabel11;
//    FItemArr[12] := A2ILabel12;
//    FItemArr[13] := A2ILabel13;
//
//    FItemFDArr[0] := A2ILabelFD0;
//    FItemFDArr[1] := A2ILabelFD1;
//    FItemFDArr[2] := A2ILabelFD2;
//    FItemFDArr[3] := A2ILabelFD3;
//    FItemFDArr[4] := A2ILabelFD4;
//    FItemFDArr[5] := A2ILabelFD5;
//    FItemFDArr[6] := A2ILabelFD6;
//    FItemFDArr[7] := A2ILabelFD7;
//    FItemFDArr[8] := A2ILabelFD8;
//    FItemFDArr[9] := A2ILabelFD9;
//    FItemFDArr[10] := A2ILabelFD10;
//    FItemFDArr[11] := A2ILabelFD11;
//    FItemFDArr[12] := A2ILabelFD12;
//    FItemFDArr[13] := A2ILabelFD13;
//
//    for i := 0 to high(FItemArr) do
//    begin
//      FItemArr[i].Tag := i;
//      FItemArr[i].A2Imageback := FItemimgArr[i];
//      FItemArr[i].A2Image := FItemimgArr[i];
//      FItemArr[i].Transparent := true;
//    end;
//    for i := 0 to high(FItemFDArr) do
//    begin
//      FItemFDArr[i].Tag := i;
//      FItemfdArr[i].A2Imageback := FItemFDimgArr[i];
//      FItemfdArr[i].A2Image := FItemFDimgArr[i];
//      FItemFDArr[i].Transparent := true;
//    end;
//    a2Panel1.Visible := false;
//    a2Panel2.Visible := not a2Panel1.Visible;
//    CharCenterImage := TA2Image.Create(160, 160, 0, 0);
//
//    LbChar.A2Image := CharCenterImage;
//
//    CharCenterImageFD := TA2Image.Create(160, 160, 0, 0);
//    LbCharFD.A2Image := CharCenterImageFD;
//
//    A2Button_win.Top := A2Button_FDwin.Top;
//    A2Button_win.Left := A2Button_FDwin.Left;
//    A2Button_fdmode.Top := A2Button_mode.Top;
//    A2Button_fdmode.Left := A2Button_mode.Left;
//
//    LbCharFD.Top := LbChar.Top;
//    LbCharFD.Left := LbChar.Left;
////        A2Form.FA2Hint.Ftype := hstTransparent;
//    A2Panel1.Top := A2Panel2.Top;
//    A2Panel1.Left := A2Panel2.Left;
//    A2Panel1.Width := A2Panel2.Width;
//    A2Panel1.Height := A2Panel2.Height;
//
//    FItemfdArr[0].Top := FItemArr[0].Top;
//    FItemfdArr[0].Left := FItemArr[0].Left;
//    FItemfdArr[1].Top := FItemarr[1].Top;
//    FItemfdArr[1].Left := FItemArr[1].Left;
//    FItemfdArr[2].Top := FItemArr[2].Top;
//    FItemfdArr[2].Left := FItemArr[2].Left;
//    FItemfdArr[3].Top := FItemArr[3].Top;
//    FItemfdArr[3].Left := FItemArr[3].Left;
//    FItemfdArr[4].Top := FItemArr[4].Top;
//    FItemfdArr[4].Left := FItemArr[4].Left;
//    FItemfdArr[6].Top := FItemArr[6].Top;
//    FItemfdArr[6].Left := FItemArr[6].Left;
//    FItemfdArr[7].Top := FItemArr[7].Top;
//    FItemfdArr[7].Left := FItemArr[7].Left;
//    FItemfdArr[8].Top := FItemArr[8].Top;
//    FItemfdArr[8].Left := FItemArr[8].Left;
//    FItemfdArr[9].Top := FItemArr[9].Top;
//    FItemfdArr[9].Left := FItemArr[9].Left;
//
//
//    ILabels[0] := A2ILabelItem1;
//    ILabels[1] := A2ILabelItem2;
//    ILabels[2] := A2ILabelItem3;
//    ILabels[3] := A2ILabelItem4;
//    ILabels[4] := A2ILabelItem5;
//    ILabels[5] := A2ILabelItem6;
//    ILabels[6] := A2ILabelItem7;
//    ILabels[7] := A2ILabelItem8;
//    ILabels[8] := A2ILabelItem9;
//    ILabels[9] := A2ILabelItem10;
//    ILabels[10] := A2ILabelItem11;
//    ILabels[11] := A2ILabelItem12;
//    ILabels[12] := A2ILabelItem13;
//    ILabels[13] := A2ILabelItem14;
//    ILabels[14] := A2ILabelItem15;
//    ILabels[15] := A2ILabelItem16;
//    ILabels[16] := A2ILabelItem17;
//    ILabels[17] := A2ILabelItem18;
//    ILabels[18] := A2ILabelItem19;
//    ILabels[19] := A2ILabelItem20;
//    ILabels[20] := A2ILabelItem21;
//    ILabels[21] := A2ILabelItem22;
//    ILabels[22] := A2ILabelItem23;
//    ILabels[23] := A2ILabelItem24;
//    ILabels[24] := A2ILabelItem25;
//    ILabels[25] := A2ILabelItem26;
//    ILabels[26] := A2ILabelItem27;
//    ILabels[27] := A2ILabelItem28;
//    ILabels[28] := A2ILabelItem29;
//    ILabels[29] := A2ILabelItem30;
//    for i := 0 to high(ILabels) do
//    begin
//      ILabels[i].Tag := i;
//      ILabels[i].Transparent := true;
//    end;
//
//    ILabelsQuest[0] := A2ILabel_QItem0;
//    ILabelsQuest[1] := A2ILabel_QItem1;
//    ILabelsQuest[2] := A2ILabel_QItem2;
//    ILabelsQuest[3] := A2ILabel_QItem3;
//    ILabelsQuest[4] := A2ILabel_QItem4;
//    ILabelsQuest[5] := A2ILabel_QItem5;
//    ILabelsQuest[6] := A2ILabel_QItem6;
//    ILabelsQuest[7] := A2ILabel_QItem7;
//    ILabelsQuest[8] := A2ILabel_QItem8;
//    ILabelsQuest[9] := A2ILabel_QItem9;
//    ILabelsQuest[10] := A2ILabel_QItem10;
//    ILabelsQuest[11] := A2ILabel_QItem11;
//    ILabelsQuest[12] := A2ILabel_QItem12;
//    ILabelsQuest[13] := A2ILabel_QItem13;
//    ILabelsQuest[14] := A2ILabel_QItem14;
//    ILabelsQuest[15] := A2ILabel_QItem15;
//    ILabelsQuest[16] := A2ILabel_QItem16;
//    ILabelsQuest[17] := A2ILabel_QItem17;
//    ILabelsQuest[18] := A2ILabel_QItem18;
//    ILabelsQuest[19] := A2ILabel_QItem19;
//    ILabelsQuest[20] := A2ILabel_QItem20;
//    ILabelsQuest[21] := A2ILabel_QItem21;
//    ILabelsQuest[22] := A2ILabel_QItem22;
//    ILabelsQuest[23] := A2ILabel_QItem23;
//    ILabelsQuest[24] := A2ILabel_QItem24;
//    ILabelsQuest[25] := A2ILabel_QItem25;
//    ILabelsQuest[26] := A2ILabel_QItem26;
//    ILabelsQuest[27] := A2ILabel_QItem27;
//    ILabelsQuest[28] := A2ILabel_QItem28;
//    ILabelsQuest[29] := A2ILabel_QItem29;
//    for i := 0 to high(ILabelsQuest) do
//    begin
//      ILabelsQuest[i].Tag := i;
//      ILabelsQuest[i].Transparent := true;
//    end;
//
//
//  finally
//    temping.Free;
//  end;
//end;

procedure TFrmWearItem.SetNewVersionTest;
var
  i: Integer;
  A2ImageItemBack: TA2Image;
  tmpStream: TMemoryStream;
begin
  if FTestPos then
  begin
    FUIConfig.Free;
    FUIConfig := TNativeXml.Create;
    FUIConfig.Utf8Encoded := True;
    if not zipmode then //2015.11.12 在水一方 >>>>>>
      FUIConfig.LoadFromFile('.\ui\WearItem.xml')
    else begin
      if not alwayscache then
        tmpStream := TMemoryStream.Create;
      try
        if upzipstream(xmlzipstream, tmpStream, 'WearItem.xml') then
          FUIConfig.LoadFromStream(tmpStream);
      finally
        if not alwayscache then
          tmpStream.Free;
      end;
    end; //2015.11.12 在水一方 <<<<<<
  end;
  SetControlPos(Self);
  SetControlPos(A2ILabel_money2);
  SetControlPos(lblBindMoney);
  SetControlPos(A2Panel2);
  A2Panel1.Top := A2Panel2.Top;
  A2Panel1.Left := A2Panel2.Left;
  A2Panel1.Width := A2Panel2.Width;
  A2Panel1.Height := A2Panel2.Height;
  SetControlPos(A2Panel1);

  SetControlPos(A2Button_close);

  SetControlPos(A2ILImg);
  SetControlPos(self.A2LabelSortItem);
  SetControlPos(self.A2LabelCk);
  SetControlPos(self.A2LabelPassword);
  SetControlPos(Panel_item);

  SetA2ImgPos(ItemPage1_img);
  SetA2ImgPos(ItemPage2_img);
  SetControlPos(self.ItemPage1A2ILabel);
  SetControlPos(self.ItemPage2A2ILabel);
  SetControlPos(self.ItemPageBackA2ILabel);
  SetControlPos(self.a2chckbx_SHOWFD); ;
  SetControlPos(self.a2chckbx_SHOWFD2);

  Panel_item.Visible := true;
  Panel_quest.Left := Panel_item.Left;
  Panel_quest.Top := Panel_item.Top;
  Panel_quest.Width := Panel_item.Width;
  Panel_quest.Height := Panel_item.Height;
  Panel_quest.Visible := not Panel_item.Visible;
  try
 //  if A2ImageItemBack = nil then
    A2ImageWearBack := TA2Image.Create(32, 32, 0, 0);
    A2ImageWearBack.Name := 'A2ImageWearBack';
    SetA2ImgPos(A2ImageWearBack);
//  pgkBmp.getBmp('角色物品_装备底框.bmp', A2ImageWearBack);
    for i := 0 to high(FItemImgArr) do
    begin
      FItemImgArr[i] := TA2Image.Create(A2ImageWearBack.Width, A2ImageWearBack.Height, 0, 0);
      FItemImgArr[i].DrawImage(A2ImageWearBack, 0, 0, false);
    end;
  finally

  end;

  try
    A2ImageItemBack := TA2Image.Create(32, 32, 0, 0);
    A2ImageItemBack.Name := 'A2ImageItemBack';
    SetA2ImgPos(A2ImageItemBack);

    for i := 0 to high(FItemImgArr) do
    begin
      FItemFDImgArr[i] := TA2Image.Create(32, 32, 0, 0);
      FItemFDImgArr[i].DrawImage(A2ImageItemBack, 0, 0, false);
    end;
  finally
    A2ImageItemBack.Free;
  end;
  FItemImgArr[1].Name := 'FItemImgArr1';
  SetA2ImgPos(FItemImgArr[1]);
  FItemImgArr[2].Name := 'FItemImgArr2';
  SetA2ImgPos(FItemImgArr[2]);
  FItemImgArr[3].Name := 'FItemImgArr3';
  SetA2ImgPos(FItemImgArr[3]);
  FItemImgArr[4].Name := 'FItemImgArr4';
  SetA2ImgPos(FItemImgArr[4]);

  FItemImgArr[6].Name := 'FItemImgArr6';
  SetA2ImgPos(FItemImgArr[6]);
  FItemImgArr[7].Name := 'FItemImgArr7';
  SetA2ImgPos(FItemImgArr[7]);
  FItemImgArr[8].Name := 'FItemImgArr8';
  SetA2ImgPos(FItemImgArr[8]);
  FItemImgArr[9].Name := 'FItemImgArr9';
  SetA2ImgPos(FItemImgArr[9]);
  FItemImgArr[10].Name := 'FItemImgArr10';
  SetA2ImgPos(FItemImgArr[10]);
  FItemImgArr[11].Name := 'FItemImgArr11';
  SetA2ImgPos(FItemImgArr[11]);
  FItemImgArr[12].Name := 'FItemImgArr12';
  SetA2ImgPos(FItemImgArr[12]);
  FItemImgArr[13].Name := 'FItemImgArr13';
  SetA2ImgPos(FItemImgArr[13]);


  FItemfdImgArr[1].Name := 'FItemfdImgArr1';
  SetA2ImgPos(FItemfdImgArr[1]);
  FItemfdImgArr[2].Name := 'FItemfdImgArr2';
  SetA2ImgPos(FItemfdImgArr[2]);
  FItemfdImgArr[3].Name := 'FItemfdImgArr3';
  SetA2ImgPos(FItemfdImgArr[3]);
  FItemfdImgArr[4].Name := 'FItemfdImgArr4';
  SetA2ImgPos(FItemfdImgArr[4]);

  FItemfdImgArr[6].Name := 'FItemfdImgArr6';
  SetA2ImgPos(FItemfdImgArr[6]);
  FItemfdImgArr[7].Name := 'FItemfdImgArr7';
  SetA2ImgPos(FItemfdImgArr[7]);
  FItemfdImgArr[8].Name := 'FItemfdImgArr8';
  SetA2ImgPos(FItemfdImgArr[8]);
  FItemfdImgArr[9].Name := 'FItemfdImgArr9';
  SetA2ImgPos(FItemfdImgArr[9]);


  SetControlPos(A2Button_win);
  SetControlPos(A2Button_fdmode);
  SetControlPos(A2Button_FDwin);
  SetControlPos(A2Button_MODE);

  SetControlPos(A2CheckBox_quest);
  SetControlPos(A2CheckBox_item);

  A2CheckBox_item.Checked := true;
  SetControlPos(A2ILabel_money);


  FItemArr[0] := A2ILabel0;
  FItemArr[1] := A2ILabel1;
  FItemArr[2] := A2ILabel2;
  FItemArr[3] := A2ILabel3;
  FItemArr[4] := A2ILabel4;
  FItemArr[5] := A2ILabel5;
  FItemArr[6] := A2ILabel6;
  FItemArr[7] := A2ILabel7;
  FItemArr[8] := A2ILabel8;
  FItemArr[9] := A2ILabel9;
  FItemArr[10] := A2ILabel10;
  FItemArr[11] := A2ILabel11;
  FItemArr[12] := A2ILabel12;
  FItemArr[13] := A2ILabel13;
  for i := 0 to 13 do
  begin
    SetControlPos(FItemArr[i]);
  end;


  FItemFDArr[0] := A2ILabelFD0;
  FItemFDArr[1] := A2ILabelFD1;
  FItemFDArr[2] := A2ILabelFD2;
  FItemFDArr[3] := A2ILabelFD3;
  FItemFDArr[4] := A2ILabelFD4;
  FItemFDArr[5] := A2ILabelFD5;
  FItemFDArr[6] := A2ILabelFD6;
  FItemFDArr[7] := A2ILabelFD7;
  FItemFDArr[8] := A2ILabelFD8;
  FItemFDArr[9] := A2ILabelFD9;
  FItemFDArr[10] := A2ILabelFD10;
  FItemFDArr[11] := A2ILabelFD11;
  FItemFDArr[12] := A2ILabelFD12;
  FItemFDArr[13] := A2ILabelFD13;
  for i := 0 to 13 do
  begin
    SetControlPos(FItemFDArr[i]);
  end;
//
  for i := 0 to high(FItemArr) do
  begin
    FItemArr[i].Tag := i;
    FItemArr[i].A2Imageback := FItemimgArr[i];
    FItemArr[i].A2Image := FItemimgArr[i];
    FItemArr[i].Transparent := true;
  end;
  for i := 0 to high(FItemFDArr) do
  begin
    FItemFDArr[i].Tag := i;
    FItemfdArr[i].A2Imageback := FItemFDimgArr[i];
    FItemfdArr[i].A2Image := FItemFDimgArr[i];
    FItemFDArr[i].Transparent := true;
  end;
  a2Panel1.Visible := false;
  a2Panel2.Visible := not a2Panel1.Visible;
  CharCenterImage := TA2Image.Create(160, 160, 0, 0);
//
  LbChar.A2Image := CharCenterImage;
//
  CharCenterImageFD := TA2Image.Create(160, 160, 0, 0);
  LbCharFD.A2Image := CharCenterImageFD;
  SetControlPos(LbChar);
  SetControlPos(LbCharFD);
//
  A2Button_win.Top := A2Button_FDwin.Top;
  A2Button_win.Left := A2Button_FDwin.Left;
  A2Button_fdmode.Top := A2Button_mode.Top;
  A2Button_fdmode.Left := A2Button_mode.Left;
//
  LbCharFD.Top := LbChar.Top;
  LbCharFD.Left := LbChar.Left;

//
  FItemfdArr[0].Top := FItemArr[0].Top;
  FItemfdArr[0].Left := FItemArr[0].Left;
  FItemfdArr[1].Top := FItemarr[1].Top;
  FItemfdArr[1].Left := FItemArr[1].Left;
  FItemfdArr[2].Top := FItemArr[2].Top;
  FItemfdArr[2].Left := FItemArr[2].Left;
  FItemfdArr[3].Top := FItemArr[3].Top;
  FItemfdArr[3].Left := FItemArr[3].Left;
  FItemfdArr[4].Top := FItemArr[4].Top;
  FItemfdArr[4].Left := FItemArr[4].Left;
  FItemfdArr[6].Top := FItemArr[6].Top;
  FItemfdArr[6].Left := FItemArr[6].Left;
  FItemfdArr[7].Top := FItemArr[7].Top;
  FItemfdArr[7].Left := FItemArr[7].Left;
  FItemfdArr[8].Top := FItemArr[8].Top;
  FItemfdArr[8].Left := FItemArr[8].Left;
  FItemfdArr[9].Top := FItemArr[9].Top;
  FItemfdArr[9].Left := FItemArr[9].Left;
//
//
  ILabels[0] := A2ILabelItem1;
  ILabels[1] := A2ILabelItem2;
  ILabels[2] := A2ILabelItem3;
  ILabels[3] := A2ILabelItem4;
  ILabels[4] := A2ILabelItem5;
  ILabels[5] := A2ILabelItem6;
  ILabels[6] := A2ILabelItem7;
  ILabels[7] := A2ILabelItem8;
  ILabels[8] := A2ILabelItem9;
  ILabels[9] := A2ILabelItem10;
  ILabels[10] := A2ILabelItem11;
  ILabels[11] := A2ILabelItem12;
  ILabels[12] := A2ILabelItem13;
  ILabels[13] := A2ILabelItem14;
  ILabels[14] := A2ILabelItem15;
  ILabels[15] := A2ILabelItem16;
  ILabels[16] := A2ILabelItem17;
  ILabels[17] := A2ILabelItem18;
  ILabels[18] := A2ILabelItem19;
  ILabels[19] := A2ILabelItem20;
  ILabels[20] := A2ILabelItem21;
  ILabels[21] := A2ILabelItem22;
  ILabels[22] := A2ILabelItem23;
  ILabels[23] := A2ILabelItem24;
  ILabels[24] := A2ILabelItem25;
  ILabels[25] := A2ILabelItem26;
  ILabels[26] := A2ILabelItem27;
  ILabels[27] := A2ILabelItem28;
  ILabels[28] := A2ILabelItem29;
  ILabels[29] := A2ILabelItem30;

  for i := 0 to high(ILabels) do
  begin
    ILabels[i].Tag := i;
    SetControlPos(ILabels[i]);
    ILabels[i].Transparent := true;
  end;
//
  ILabelsQuest[0] := A2ILabel_QItem0;
  ILabelsQuest[1] := A2ILabel_QItem1;
  ILabelsQuest[2] := A2ILabel_QItem2;
  ILabelsQuest[3] := A2ILabel_QItem3;
  ILabelsQuest[4] := A2ILabel_QItem4;
  ILabelsQuest[5] := A2ILabel_QItem5;
  ILabelsQuest[6] := A2ILabel_QItem6;
  ILabelsQuest[7] := A2ILabel_QItem7;
  ILabelsQuest[8] := A2ILabel_QItem8;
  ILabelsQuest[9] := A2ILabel_QItem9;
  ILabelsQuest[10] := A2ILabel_QItem10;
  ILabelsQuest[11] := A2ILabel_QItem11;
  ILabelsQuest[12] := A2ILabel_QItem12;
  ILabelsQuest[13] := A2ILabel_QItem13;
  ILabelsQuest[14] := A2ILabel_QItem14;
  ILabelsQuest[15] := A2ILabel_QItem15;
  ILabelsQuest[16] := A2ILabel_QItem16;
  ILabelsQuest[17] := A2ILabel_QItem17;
  ILabelsQuest[18] := A2ILabel_QItem18;
  ILabelsQuest[19] := A2ILabel_QItem19;
  ILabelsQuest[20] := A2ILabel_QItem20;
  ILabelsQuest[21] := A2ILabel_QItem21;
  ILabelsQuest[22] := A2ILabel_QItem22;
  ILabelsQuest[23] := A2ILabel_QItem23;
  ILabelsQuest[24] := A2ILabel_QItem24;
  ILabelsQuest[25] := A2ILabel_QItem25;
  ILabelsQuest[26] := A2ILabel_QItem26;
  ILabelsQuest[27] := A2ILabel_QItem27;
  ILabelsQuest[28] := A2ILabel_QItem28;
  ILabelsQuest[29] := A2ILabel_QItem29;
  for i := 0 to high(ILabelsQuest) do
  begin
    ILabelsQuest[i].Tag := i;
    SetControlPos(ILabelsQuest[i]);
    ILabelsQuest[i].Transparent := true;
  end;
end;

procedure TFrmWearItem.SetControlPos(AControl: TControl); //2015.11.13 在水一方
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  SelectImage, SelectNotImage, EnabledImage: string;
  temping, temping2: TA2Image;
  path: string;
  A2Image: string;
  imgwidth, imgheight: Integer;
  transparent: Boolean;
  tmpStream: TMemoryStream;
begin
  path := '.\ui\img\';
  if FTestPos then
  begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      try
        node := FUIConfig.Root.NodeByName('Views').FindNode(AControl.Name);
        if node = nil then exit;
        width := node.ReadInteger('width', -1);
        height := node.ReadInteger('height', -1);
        imgwidth := node.ReadInteger('imgwidth', -1);
        if imgwidth = -1 then
          imgwidth := 32;

        imgheight := node.ReadInteger('imgheight', -1);
        if imgheight = -1 then
          imgheight := 32;
        left := node.ReadInteger('left', -1);
        top := node.ReadInteger('top', -1);
        visible := node.ReadBool('visible', True);
        if not (AControl is TForm) then
          AControl.Visible := visible;
        if visible then
        begin
          if AControl is TForm then
          begin
            transparent := node.ReadBool('transparent', False);
            Self.A2Form.TransParent := transparent;
          end;
          if AControl is TA2Button then
          begin
            try
              temping := TA2Image.Create(imgwidth, imgheight, 0, 0);
              A2Down := node.ReadWidestring('A2Down', '');

              if (A2Down <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Down);
                  TA2Button(AControl).A2Down := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2Down) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2Down := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2Mouse := node.ReadWidestring('A2Mouse', '');
              if (A2Mouse <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Mouse);
                  TA2Button(AControl).A2Mouse := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2Mouse) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2Mouse := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2Up := node.ReadWidestring('A2Up', '');
              if (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  TA2Button(AControl).A2Up := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2Up := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2NotEnabled := node.ReadWidestring('A2NotEnabled', '');
              if (A2NotEnabled <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2NotEnabled);
                  TA2Button(AControl).A2NotEnabled := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2NotEnabled) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2NotEnabled := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end else
              begin
                TA2Button(AControl).A2NotEnabled := nil;
              end;
            finally
              temping.Free;

            end;
          end;

          if AControl is TA2CheckBox then
          begin
            try
              temping := TA2Image.Create(imgwidth, imgheight, 0, 0);
              SelectImage := node.ReadWidestring('SelectImage', '');

              if (SelectImage <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + SelectImage);
                  TA2CheckBox(AControl).SelectImage := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, SelectImage) then
                    temping.LoadFromStream(tmpStream);
                  TA2CheckBox(AControl).SelectImage := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              SelectNotImage := node.ReadWidestring('SelectNotImage', '');
              if (SelectNotImage <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + SelectNotImage);
                  TA2CheckBox(AControl).SelectNotImage := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, SelectNotImage) then
                    temping.LoadFromStream(tmpStream);
                  TA2CheckBox(AControl).SelectNotImage := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              EnabledImage := node.ReadWidestring('EnabledImage', '');
              if (EnabledImage <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + EnabledImage);
                  TA2CheckBox(AControl).EnabledImage := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, EnabledImage) then
                    temping.LoadFromStream(tmpStream);
                  TA2CheckBox(AControl).EnabledImage := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;

            finally
              temping.Free;

            end;
          end;

          if AControl is TA2ILabel then
          begin
            A2Image := node.ReadWidestring('A2Image', '');
            if (A2Image <> '') then
            begin
              temping := TA2Image.Create(imgwidth, imgheight, 0, 0);
              try
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Image);
                  TA2ILabel(AControl).A2Image := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2Image) then
                    temping.LoadFromStream(tmpStream);
                  TA2ILabel(AControl).A2Image := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              finally
                temping.Free;

              end;
            end;

          end;

          if width <> -1 then
          begin
            AControl.Width := width;
          end;
          if height <> -1 then
          begin
            AControl.Height := height;
          end;
          if left <> -1 then
          begin
            AControl.Left := left;
          end;
          if top <> -1 then
          begin
            AControl.Top := top;
          end;
        end;

      except
      end;
    finally
      if not alwayscache then
        tmpStream.Free;
    end;

  end else
  begin
    AControl.Visible := True;
  end;
end;

procedure TFrmWearItem.SetA2ImgPos(AImg: TA2Image);
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  temping, temping2: TA2Image;
  path: string;
  A2Image: string;
  imgwidth, imgheight: Integer;
  tmpStream: TMemoryStream;
begin
  path := '.\ui\img\';
  if FTestPos then
  begin

    try
      node := FUIConfig.Root.NodeByName('Views').FindNode(AImg.Name);
      if node = nil then Exit;

      A2Image := node.ReadWidestring('A2Image', '');
      if (A2Image <> '') then
      begin
        if not zipmode then //2015.11.13 在水一方 >>>>>>
          AImg.LoadFromFile(path + A2Image)
        else begin
          if not alwayscache then
            tmpStream := TMemoryStream.Create;
          try
            if upzipstream(bmpzipstream, tmpStream, A2Image) then
              AImg.LoadFromStream(tmpStream);
          finally
            if not alwayscache then
              tmpStream.Free;
          end;
        end; //2015.11.13 在水一方 <<<<<<
      end;

    except
    end;
  end;
end;

procedure TFrmWearItem.A2LabelSortItemClick(Sender: TObject);
var
  cdc: TCKey;
begin
  cdc.rmsg := CM_ITEMDATASORT;


  Frmfbl.SocketAddData(sizeof(cdc), @cdc);
end;

procedure TFrmWearItem.A2LabelCkClick(Sender: TObject);
var
  key: Word;
begin
  key := VK_RETURN;
  if FrmDepository.Visible then FrmDepository.Close;
  FrmBottom.sendsay('@ck', key);
end;

procedure TFrmWearItem.A2LabelPasswordClick(Sender: TObject);
var
  key: Word;
begin
  key := VK_RETURN;
  if FrmPassEtc.Visible then
  begin
    FrmPassEtc.Close; Exit;
  end;

  if frmPassEtcEdit.Visible then
  begin
    frmPassEtcEdit.Close;
    Exit;
  end;
  FrmBottom.sendsay('@密码管理', key);
end;

procedure TFrmWearItem.onBindMoney(acount: integer);
begin
  lblBindMoney.Caption := inttostr(acount);
end;

procedure TFrmWearItem.A2ILabelItem1Click(Sender: TObject);
var
  aitem: titemdata;
  str, astr, caption: string;

  function _get(acolor: string; var rLifeData: TLifeData): string;
  var
    _str: string;
  begin
    result := '';
    _str := '';
    if rLifeData.AttackSpeed <> 0 then
      _str := _str + acolor + format('攻击速度: %D  ', [-rLifeData.AttackSpeed]);
    if rLifeData.recovery <> 0 then
      _str := _str + acolor + format('恢复: %d  ', [-rLifeData.recovery]);
    if rLifeData.avoid <> 0 then
      _str := _str + acolor + format('躲闪: %d  ', [rLifeData.avoid]);
    if rLifeData.accuracy <> 0 then
      _str := _str + acolor + format('命中: %d  ', [rLifeData.accuracy]);
    if rLifeData.HitArmor <> 0 then
      _str := _str + acolor + format('维持: %d  ', [rLifeData.HitArmor]);
    if _str <> '' then
      result := result + _str + #13#10;

    if (rLifeData.damageBody <> 0) or (rLifeData.damageHead <> 0) or (rLifeData.damageArm <> 0) or (rLifeData.damageLeg <> 0) then
      result := result + format('攻击力: %d / %d / %d / %d', [rLifeData.damageBody, rLifeData.damageHead, rLifeData.damageArm, rLifeData.damageLeg]) + #13#10;
    if (rLifeData.armorBody <> 0) or (rLifeData.armorHead <> 0) or (rLifeData.armorArm <> 0) or (rLifeData.armorLeg <> 0) then
      result := result + format('防御力: %d / %d / %d / %d', [rLifeData.armorBody, rLifeData.armorHead, rLifeData.armorArm, rLifeData.armorLeg]) + #13#10;
  end;
begin

  aitem := HaveItemclass.get(TA2ILabel(Sender).Tag);
  if aitem.rViewName <> '' then
  begin
    str := aitem.rViewName;

    if aitem.rCount > 1 then
      str := str + format(' %d个', [aitem.rCount]);
    str := str + #13#10;

    astr := _get('', aitem.rLifeDataBasic);
    if astr <> '' then
      str := str + astr;

    astr := _get('', aitem.rLifeDataLevel);
    if astr <> '' then
      str := str + '强化属性' + #13#10 + astr;

    astr := _get('', aitem.rLifeDataAttach);
    if astr <> '' then
      str := str + '附加属性' + #13#10 + astr;

    astr := _get('', aitem.rLifeDataSetting);
    if astr <> '' then
      str := str + '镶嵌属性' + #13#10 + astr;

    FrmBottom.AddChat(TrimRight(str), WinRGB(22, 22, 22), 0);

  end;
  exit;
end;

procedure TFrmWearItem.ItemPage1A2ILabelClick(Sender: TObject);
begin
  inherited;
  self.ItemPageBackA2ILabel.A2Image := ItemPage1_img;
  a2Panel1.Visible := false;
  a2Panel2.Visible := not a2Panel1.Visible;
end;

procedure TFrmWearItem.ItemPage2A2ILabelClick(Sender: TObject);
begin
  inherited;
  self.ItemPageBackA2ILabel.A2Image := ItemPage2_img;
  a2Panel2.Visible := false;
  a2Panel1.Visible := not a2Panel2.Visible;
end;


procedure TFrmWearItem.a2chckbx_SHOWFDClick(Sender: TObject);
begin
  inherited;
  a2chckbx_SHOWFD2.Checked := a2chckbx_SHOWFD.Checked;
  showshizhuang;
end;

procedure TFrmWearItem.a2chckbx_SHOWFD2Click(Sender: TObject);
begin
  inherited;
  a2chckbx_SHOWFD.Checked := a2chckbx_SHOWFD2.Checked;
  showshizhuang;
end;

procedure TFrmWearItem.showshizhuang;
var
  temp: TWordComData;
begin
  inherited;
  if a2chckbx_SHOWFD.Checked then
  begin
    FrmConsole.cprint(lt_have, '时装显示' + inttostr(mmAnsTick));
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_SET_OK);
    WordComData_ADDbyte(temp, SET_OK_wearFD);
    Frmfbl.SocketAddData(temp.Size, @temp.data)
  end
  else
  begin
    FrmConsole.cprint(lt_have, '装备显示' + inttostr(mmAnsTick));
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_SET_OK);
    WordComData_ADDbyte(temp, SET_OK_wear);
    Frmfbl.SocketAddData(temp.Size, @temp.data);
  end;

end;
end.

