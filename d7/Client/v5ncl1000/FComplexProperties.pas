unit FComplexProperties;
//2015.12.07 在水一方 创建
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Atzcls, Deftype, BaseUIForm,
  NativeXml, Math, uKeyClass;
const
  WM_PROGRESS_MESSAGE = WM_USER + 100;

type
  TComplexdata = record
    id: integer;
    index: INTEGER;
    rColor, rShape: integer;
    cost: integer;
    probably: integer;
    needprof, addprof, prof: integer;
    name: string[32];
    text: string[255];
    subitem1, subitem2, subitem3, subitem4: string[32];
    subShape1, subShape2, subShape3, subShape4: integer;
    subColor1, subColor2, subColor3, subColor4: integer;
    subNum1, subNum2, subNum3, subNum4: integer;
  end;
  pComplexdata = ^TComplexdata;

  TfrmComplexProperties = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2ButtonStart: TA2Button;
    A2ILabel0: TA2ILabel;
    A2ILabel1: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2LabelCount: TA2Label;
    A2ButtonClose: TA2Button;
    A2ILabelProgress: TA2ILabel;
    A2ILabelProgressBack: TA2ILabel;
    A2ILabel4: TA2ILabel;
    tmrStart: TTimer;
    A2ButtonWQ: TA2Button;
    A2ButtonFJ: TA2Button;
    A2ButtonJZ: TA2Button;
    A2ButtonFZ: TA2Button;
    A2ButtonGN: TA2Button;
    A2ButtonTS: TA2Button;
    A2ButtonPageUp: TA2Button;
    A2ButtonPageDown: TA2Button;
    A2ButtonPlus: TA2Button;
    A2ButtonMinus: TA2Button;
    A2ILabelComp0: TA2ILabel;
    A2ILabelComp1: TA2ILabel;
    A2ILabelComp2: TA2ILabel;
    A2ILabelComp3: TA2ILabel;
    A2ILabelComp4: TA2ILabel;
    A2ILabelComp5: TA2ILabel;
    A2ILabelComp6: TA2ILabel;
    A2ILabelComp7: TA2ILabel;
    A2ILabelComp8: TA2ILabel;
    A2ILabelComp9: TA2ILabel;
    A2ILabelComp10: TA2ILabel;
    A2ILabelComp11: TA2ILabel;
    A2ILabelComp12: TA2ILabel;
    A2ILabelComp13: TA2ILabel;
    A2ILabelComp14: TA2ILabel;
    A2ILabelComp15: TA2ILabel;
    A2ILabelComp16: TA2ILabel;
    A2ILabelComp17: TA2ILabel;
    A2ILabelComp18: TA2ILabel;
    A2ILabelComp19: TA2ILabel;
    A2LabelDesc0: TA2Label;
    A2LabelDesc1: TA2Label;
    A2LabelDesc2: TA2Label;
    A2LabelDesc3: TA2Label;
    A2LabelMsg0: TA2Label;
    A2LabelMsg1: TA2Label;
    A2LabelMsg2: TA2Label;
    A2LabelMsg3: TA2Label;
    A2LabelMsg4: TA2Label;
    A2LabelPage: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ButtonStartClick(Sender: TObject);
    procedure sendshowForm();
    procedure A2ButtonCloseClick(Sender: TObject);
    procedure tmrStartTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2ILabelComp0Click(Sender: TObject);
    procedure A2ILabelComp0MouseEnter(Sender: TObject);
    procedure A2ILabelComp0MouseLeave(Sender: TObject);
    procedure A2ILabelComp0MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure A2ButtonPageClick(Sender: TObject);
    procedure A2ButtonGetList(Sender: TObject);
    procedure A2ButtonChangeNum(Sender: TObject);
    procedure A2ILabel0MouseLeave(Sender: TObject);
    procedure A2ILabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FItemArr: array[0..4] of TA2ILabel;
    FComplexArr: array[0..19] of TA2ILabel;
    A2ImageProgress: TA2Image;
    A2ImageProgressBack: TA2Image;
    starttick: DWORD;
    FComplexExp: DWORD;
    FCurrPage: integer;
    Findex: integer;
    fdata: tlist;
    select_item: integer;
    ComplexNum: integer;
    FAllowComp: Boolean;
    FLog: string;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure ItemPaint();
    procedure ProgressMsg(var Message: TMessage); message WM_PROGRESS_MESSAGE;
  public
    { Public declarations }
    FindexName: TStringKeyClass;
    function get(aname: string): pComplexdata;
    function getid(aid: integer): pComplexdata;
    procedure CLEAR();
    procedure add(var aitem: TComplexdata);
    procedure addlog(atext: string);
    procedure MessageProcess(var code: TWordComData);
    procedure getitemlist();
    procedure Complex();
    procedure autoitem();
  end;

var
  frmComplexProperties: TfrmComplexProperties;

implementation
uses FMain, FAttrib, FWearItem, CharCls, uAnsTick, filepgkclass, FBottom,
  fbl;
{$R *.dfm}

procedure TfrmComplexProperties.Complex();
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Complex);
  WordComData_ADDbyte(temp, Complex_Start);
  WordComData_ADDString(temp, pComplexdata(fdata[select_item]).name);
 // WordComData_ADDdword(temp, ComplexNum);
  WordComData_ADDdword(temp, 1); //每次只合成1个

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmComplexProperties.getitemlist();
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Complex);
  WordComData_ADDbyte(temp, Complex_GetItemList);
  WordComData_ADDdword(temp, starttick + 1);
  WordComData_ADDbyte(temp, Findex);         
  WordComData_ADDbyte(temp, FCurrPage);

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmComplexProperties.addlog(atext: string);
begin
  FrmBottom.AddChat(atext, WinRGB(22, 22, 0), 0);
end;

function TfrmComplexProperties.get(aname: string): pComplexdata;
begin
  result := FindexName.Select(aname);
end;

function TfrmComplexProperties.getid(aid: integer): pComplexdata;
var
  i: integer;
  pp: pComplexdata;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    if pp.id = aid then
    begin
      result := pp;
      exit;
    end;

  end;

end;

procedure TfrmComplexProperties.add(var aitem: TComplexdata);
var
  pp: pComplexdata;
begin

  pp := get(aitem.name);
  if pp <> nil then exit;
  pp := nil;
  New(pp);
  pp^ := aitem;
  fdata.Add(pp);
  FindexName.Insert(pp.name, pp);
end;

procedure TfrmComplexProperties.CLEAR();
var
  I: INTEGER;
  PP: pComplexdata;
begin
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];
    dispose(pp);
  end;
  Fdata.Clear;
  FindexName.Clear;

end;

procedure TfrmComplexProperties.MessageProcess(var code: TWordComData);
var
  i, i1, n, akey, money: integer;
  PSSShowSpecialWindow: PTSShowSpecialWindow;
  aitem: TComplexdata;
begin
  i := 0;
  akey := WordComData_GETbyte(Code, i);
  case akey of
    SM_SHOWSPECIALWINDOW: //窗口操作
      begin
        PSSShowSpecialWindow := @code.data;
        case PSSShowSpecialWindow.rWindow of
          WINDOW_Close_All: Visible := false; //窗口开闭

          WINDOW_Complex:
            begin
              FrmM.move_win_form_Align(Self, mwfCenterLeft);
              FrmM.SetA2Form(Self, A2form);
              Visible := true;
            end;
        end;
      end;
    SM_Complex:
      begin
        n := WordComData_GETbyte(Code, i);
        case n of
          Complex_GetItemList:
            begin
              starttick := WordComData_GETdword(Code, i);
              CLEAR;
              FComplexExp := WordComData_GETdword(Code, i);  //合成经验
              n := WordComData_GETword(Code, i); //总数量
              for I1 := 0 to n - 1 do
              begin
                aitem.index := WordComData_getbyte(Code, i);
                aitem.probably := WordComData_getbyte(Code, i);
                aitem.rColor := WordComData_getword(Code, i);
                aitem.rShape := WordComData_getword(Code, i);
                aitem.cost := WordComData_getdword(Code, i);
                aitem.needprof := WordComData_getdword(Code, i);
                aitem.addprof := WordComData_getdword(Code, i);
                aitem.name := WordComData_getString(Code, i);
                aitem.Text := WordComData_getString(Code, i);
                aitem.subShape1 := WordComData_getword(Code, i);
                aitem.subShape2 := WordComData_getword(Code, i);
                aitem.subShape3 := WordComData_getword(Code, i);
                aitem.subShape4 := WordComData_getword(Code, i);
                aitem.subColor1 := WordComData_getword(Code, i);
                aitem.subColor2 := WordComData_getword(Code, i);
                aitem.subColor3 := WordComData_getword(Code, i);
                aitem.subColor4 := WordComData_getword(Code, i);
                aitem.subNum1 := WordComData_getdword(Code, i);
                aitem.subNum2 := WordComData_getdword(Code, i);
                aitem.subNum3 := WordComData_getdword(Code, i);
                aitem.subNum4 := WordComData_getdword(Code, i);
                aitem.subitem1 := WordComData_getString(Code, i);
                aitem.subitem2 := WordComData_getString(Code, i);
                aitem.subitem3 := WordComData_getString(Code, i);
                aitem.subitem4 := WordComData_getString(Code, i);

                add(aitem);
              end;
              itempaint;
            end;

          Complex_Err:
            begin
              n := WordComData_GETbyte(Code, i);
              FLog := '';
              case n of
                1: FLog := '名字空';
                2: FLog := '非合成物品';
                3: FLog := '物品不存在';
                4: FLog := '物品数量限制1个';
                5: FLog := '绑定钱币不够';
                6: FLog := '材料不够';
                7: FLog := '背包没空位置';
                8: FLog := '很遗憾,您的合成失败了!';
                9: FLog := '熟练度不够';
                10: FLog := '扣帐失败';
                11: FLog := '使用材料失败';
                100: FLog := '发放物品失败';
              end;
              if FLog <> '' then addlog(FLog);
              autoitem(); //自动处理
            end;

          Complex_End: //2015.11.16 在水一方
            begin
              n := WordComData_GETbyte(Code, i);
              FLog := '';
              case n of
                0: begin
                    //money := WordComData_GETdword(Code, i);
                    FComplexExp := WordComData_GETdword(Code, i);
                    FLog := '合成成功';
                  end;
              end;
              if FLog <> '' then addlog(FLog);
              autoitem(); //自动处理
            end;
        end;
      end;
  end;
end;


procedure TfrmComplexProperties.FormCreate(Sender: TObject);
var
  i: integer;
begin
  inherited;
  self.FTestPos := true;
  fdata := tlist.Create;
  FindexName := TStringKeyClass.Create;
  FCurrPage := 0;
  select_item := -1;
  Findex := -1;
  ComplexNum := 1;
  A2LabelCount.Caption := IntToStr(ComplexNum);
  A2ImageProgress := TA2Image.Create(218, 9, 0, 0);
  A2ImageProgressBack := TA2Image.Create(218, 9, 0, 0);
  FrmM.AddA2Form(Self, A2Form);
  FItemArr[0] := A2ILabel2;
  FItemArr[1] := A2ILabel0;
  FItemArr[2] := A2ILabel1;
  FItemArr[3] := A2ILabel3;
  FItemArr[4] := A2ILabel4;
  for i := 0 to high(FItemArr) do
  begin
    FItemArr[i].Tag := i;
  end;

  FComplexArr[0] := A2ILabelComp0;
  FComplexArr[1] := A2ILabelComp1;
  FComplexArr[2] := A2ILabelComp2;
  FComplexArr[3] := A2ILabelComp3;
  FComplexArr[4] := A2ILabelComp4;
  FComplexArr[5] := A2ILabelComp5;
  FComplexArr[6] := A2ILabelComp6;
  FComplexArr[7] := A2ILabelComp7;
  FComplexArr[8] := A2ILabelComp8;
  FComplexArr[9] := A2ILabelComp9;
  FComplexArr[10] := A2ILabelComp10;
  FComplexArr[11] := A2ILabelComp11;
  FComplexArr[12] := A2ILabelComp12;
  FComplexArr[13] := A2ILabelComp13;
  FComplexArr[14] := A2ILabelComp14;
  FComplexArr[15] := A2ILabelComp15;
  FComplexArr[16] := A2ILabelComp16;
  FComplexArr[17] := A2ILabelComp17;
  FComplexArr[18] := A2ILabelComp18;
  FComplexArr[19] := A2ILabelComp19;
  for i := 0 to high(FComplexArr) do
  begin
    FComplexArr[i].Tag := i;
  end;
  SetNewVersionTest;

end;

procedure TfrmComplexProperties.FormDestroy(Sender: TObject);
begin
  A2ImageProgress.Free;
  A2ImageProgressBack.Free;
  CLEAR;
  FindexName.Free;
  fdata.Free;
end;

procedure TfrmComplexProperties.SetConfigFileName;
begin
  FConfigFileName := 'ComplexProperties.xml';
end;

procedure TfrmComplexProperties.SetNewVersionTest;
var
  i: integer;
begin
  inherited;
  SetControlPos(self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(A2ButtonClose);
  SetControlPos(A2ButtonStart);
  SetControlPos(A2LabelMsg0);
  SetControlPos(A2LabelMsg1);
  SetControlPos(A2LabelMsg2);
  SetControlPos(A2LabelMsg3);
  SetControlPos(A2LabelMsg4);
  SetControlPos(A2LabelDesc0);
  SetControlPos(A2LabelDesc1);
  SetControlPos(A2LabelDesc2);
  SetControlPos(A2LabelDesc3);
  SetControlPos(A2LabelCount);
  SetControlPos(A2LabelPage);
  SetControlPos(A2ButtonWQ);
  SetControlPos(A2ButtonFJ);
  SetControlPos(A2ButtonJZ);
  SetControlPos(A2ButtonFZ);
  SetControlPos(A2ButtonGN);
  SetControlPos(A2ButtonTS);
  SetControlPos(A2ButtonPageUp);
  SetControlPos(A2ButtonPageDown);
  SetControlPos(A2ButtonPlus);
  SetControlPos(A2ButtonMinus);
  SetControlPos(A2ILabelProgress);
  A2ILabelProgress.Visible := False;
  SetControlPos(A2ILabelProgressBack);
  A2ILabelProgressBack.Visible := False;
  if A2ImageProgress = nil then
    A2ImageProgress := TA2Image.Create(A2ILabelProgress.Width * 2, A2ILabelProgress.Height, 0, 0)
  else
    A2ImageProgress.Resize(A2ILabelProgress.Width * 2, A2ILabelProgress.Height);
  A2ImageProgress.Clear(1);
  if A2ILabelProgressBack.A2Image <> nil then
    A2ImageProgress.DrawImage(A2ILabelProgressBack.A2Image, A2ILabelProgress.Width, 0, false);
  if A2ILabelProgress.A2Image <> nil then
    A2ImageProgress.DrawImage(A2ILabelProgress.A2Image, 0, 0, false);
  for i := 0 to high(FItemArr) do
  begin
    SetControlPos(FItemArr[i]);
    if FItemArr[i].A2Image <> nil then
      FItemArr[i].A2Imageback := FItemArr[i].A2Image;
  end;
  for i := 0 to high(FComplexArr) do
  begin
    SetControlPos(FComplexArr[i]);
    if FComplexArr[i].A2Image <> nil then
      FComplexArr[i].A2Imageback := FComplexArr[i].A2Image;
    FComplexArr[i].Visible := False;
  end;
end;

procedure TfrmComplexProperties.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;
end;

procedure TfrmComplexProperties.ItemPaint();
var
  i, idx, tmpshape, tmpColor, tmpcount: integer;
  str, view: string;
  back: TA2Image;
  gc, ga: integer;
  aitem: TItemData;
  pi: PTItemdata;
begin
  for i := Low(FComplexArr) to High(FComplexArr) do
  begin
    if i + FCurrPage * 20 >= fdata.Count then begin
      FComplexArr[i].Visible := False;
      FComplexArr[i].ReDraw;
      Continue;
    end;
    idx := i + FCurrPage * 20;
    FComplexArr[i].Tag := idx;
    aitem.rColor := pComplexdata(fdata[idx]).rColor;
    aitem.rShape := pComplexdata(fdata[idx]).rShape;
    FrmAttrib.SetItemLabel(FComplexArr[i]
      , view
      , aitem.rColor
      , aitem.rShape
      , 0, 0);
    FComplexArr[i].Visible := true;
  end;
  if (select_item >= 0) and (select_item < fdata.Count) then
  begin
    FAllowComp := True;
    FrmAttrib.SetItemLabel(FItemArr[0]
      , view
      , pComplexdata(fdata[select_item]).rColor
      , pComplexdata(fdata[select_item]).rShape
      , 0, 0);
    A2LabelMsg0.Caption := '熟练度加' + IntToStr(pComplexdata(fdata[select_item]).addprof * ComplexNum);
    if pComplexdata(fdata[select_item]).subitem1 <> '' then begin
      tmpshape := pComplexdata(fdata[select_item]).subShape1;
      tmpColor := pComplexdata(fdata[select_item]).subColor1;
      tmpcount := pComplexdata(fdata[select_item]).subNum1 * ComplexNum;
      str := IntToStr(tmpcount);
      pi := HaveItemclass.getname(pComplexdata(fdata[select_item]).subitem1);
      if pi <> nil then
        str := str + ' / ' + IntToStr(pi.rCount)
      else
        str := str + ' / 0';
      if (pi = nil) or (pi.rCount < tmpcount) then
        A2LabelMsg1.FontColor := ColorSysToDxColor(clRed)
      else
        A2LabelMsg1.FontColor := ColorSysToDxColor(clWhite);
      if (pi = nil) or (pi.rCount < tmpcount) then FAllowComp := False;
    end
    else begin
      tmpshape := 0;
      tmpColor := 0;
      str := '';
    end;
    FrmAttrib.SetItemLabel(FItemArr[1]
      , view
      , tmpColor
      , tmpshape
      , 0, 0);
    A2LabelMsg1.Caption := str;
    if pComplexdata(fdata[select_item]).subitem2 <> '' then begin
      tmpshape := pComplexdata(fdata[select_item]).subShape2;
      tmpColor := pComplexdata(fdata[select_item]).subColor2;
      tmpcount := pComplexdata(fdata[select_item]).subNum2 * ComplexNum;
      str := IntToStr(tmpcount);
      pi := HaveItemclass.getname(pComplexdata(fdata[select_item]).subitem2);
      if pi <> nil then
        str := str + ' / ' + IntToStr(pi.rCount)
      else
        str := str + ' / 0';
      if (pi = nil) or (pi.rCount < tmpcount) then
        A2LabelMsg2.FontColor := ColorSysToDxColor(clRed)
      else
        A2LabelMsg2.FontColor := ColorSysToDxColor(clWhite);
      if (pi = nil) or (pi.rCount < tmpcount) then FAllowComp := False;
    end
    else begin
      tmpshape := 0;
      tmpColor := 0;
      str := '';
    end;
    FrmAttrib.SetItemLabel(FItemArr[2]
      , view
      , tmpColor
      , tmpshape
      , 0, 0);
    A2LabelMsg2.Caption := str;
    if pComplexdata(fdata[select_item]).subitem3 <> '' then begin
      tmpshape := pComplexdata(fdata[select_item]).subShape3;
      tmpColor := pComplexdata(fdata[select_item]).subColor3;
      tmpcount := pComplexdata(fdata[select_item]).subNum3 * ComplexNum;
      str := IntToStr(tmpcount);
      pi := HaveItemclass.getname(pComplexdata(fdata[select_item]).subitem3);
      if pi <> nil then
        str := str + ' / ' + IntToStr(pi.rCount)
      else
        str := str + ' / 0';
      if (pi = nil) or (pi.rCount < tmpcount) then
        A2LabelMsg3.FontColor := ColorSysToDxColor(clRed)
      else
        A2LabelMsg3.FontColor := ColorSysToDxColor(clWhite);
      if (pi = nil) or (pi.rCount < tmpcount) then FAllowComp := False;
    end
    else begin
      tmpshape := 0;
      tmpColor := 0;
      str := '';
    end;
    FrmAttrib.SetItemLabel(FItemArr[3]
      , view
      , tmpColor
      , tmpshape
      , 0, 0);
    A2LabelMsg3.Caption := str;
    if pComplexdata(fdata[select_item]).subitem4 <> '' then begin
      tmpshape := pComplexdata(fdata[select_item]).subShape4;
      tmpColor := pComplexdata(fdata[select_item]).subColor4;
      tmpcount := pComplexdata(fdata[select_item]).subNum4 * ComplexNum;
      str := IntToStr(tmpcount);
      pi := HaveItemclass.getname(pComplexdata(fdata[select_item]).subitem4);
      if pi <> nil then
        str := str + ' / ' + IntToStr(pi.rCount)
      else
        str := str + ' / 0';
      if (pi = nil) or (pi.rCount < tmpcount) then
        A2LabelMsg4.FontColor := ColorSysToDxColor(clRed)
      else
        A2LabelMsg4.FontColor := ColorSysToDxColor(clWhite);
      if (pi = nil) or (pi.rCount < tmpcount) then FAllowComp := False;
    end
    else begin
      tmpshape := 0;
      tmpColor := 0;
      str := '';
    end;
    FrmAttrib.SetItemLabel(FItemArr[4]
      , view
      , tmpColor
      , tmpshape
      , 0, 0);
    A2LabelMsg4.Caption := str;
    with pComplexdata(fdata[select_item])^ do begin
      A2LabelDesc0.Caption := '熟练度:' + IntToStr(FComplexExp);
      A2LabelDesc1.Caption := '需熟练度:' + IntToStr(needprof);
      A2LabelDesc2.Caption := '成功率:' + IntToStr(probably) + '%';
      A2LabelDesc3.Caption := '合成费用:' + IntToStr(cost * ComplexNum);
    end;
  end
  else begin
    for i := Low(FItemArr) to High(FItemArr) do
      FItemArr[i].A2Image := nil;
    A2LabelMsg0.Caption := '';
    A2LabelMsg1.Caption := '';
    A2LabelMsg2.Caption := '';
    A2LabelMsg3.Caption := '';
    A2LabelMsg4.Caption := '';
    A2LabelDesc0.Caption := '';
    A2LabelDesc1.Caption := '';
    A2LabelDesc2.Caption := '';
    A2LabelDesc3.Caption := '';
  end;
  if fdata.Count > 0 then
    A2LabelPage.Caption := IntToStr(FCurrPage + 1) + '/' + IntToStr(max(0, fdata.Count - 1) div 20 + 1)
  else
    A2LabelPage.Caption := '';
end;

procedure TfrmComplexProperties.A2ButtonStartClick(Sender: TObject);
begin
  if not FAllowComp then begin
    addlog('材料不足,不可合成.');
    exit;
  end;
  starttick := GetTickCount;
  A2ILabelProgress.Visible := True;
  A2ButtonStart.Enabled := False;
  //Complex();
  tmrStart.Enabled := True;
end;

procedure TfrmComplexProperties.sendshowForm();
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Complex);
  WordComData_ADDbyte(temp, Complex_showForm);

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

//关闭窗口

procedure TfrmComplexProperties.A2ButtonCloseClick(Sender: TObject);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Complex);
  WordComData_ADDbyte(temp, Complex_Windows_close);

  if Frmfbl.SocketAddData(temp.Size, @temp.data) then
    Visible := false;
end;

procedure TfrmComplexProperties.ProgressMsg(var Message: TMessage);
var
  ShowWidth, ShowLeft: Integer;
begin
  ShowWidth := max(Min(Message.LParam, 100), 0) * A2ILabelProgress.Width div 100;
  ShowLeft := -(A2ILabelProgress.Width - ShowWidth);
  A2ILabelProgress.A2Image.DrawImage(A2ImageProgress, ShowLeft, 0, true);
  A2ILabelProgress.ReDraw;
end;

procedure TfrmComplexProperties.tmrStartTimer(Sender: TObject);
begin
  //判断窗口是否关闭
  if Visible = False then
  begin
    A2ButtonStart.Enabled := True;
    tmrStart.Enabled := False;
    Exit;
  end;

  if GetTickCount - starttick <= 3000 then begin
    SendMessage(Self.Handle, WM_PROGRESS_MESSAGE, 0, (GetTickCount - starttick) * 100 div 3000);
  end
  else begin
    if A2ButtonStart.Enabled = False then Complex(); //发送数据
    A2ButtonStart.Enabled := True;
    tmrStart.Enabled := False;
    A2ILabelProgress.Visible := False;
    A2ILabelProgress.ReDraw;
//    if FLog <> '' then begin
//      addlog(FLog);
//      FLog := '';
//    end;

  end;
end;

procedure TfrmComplexProperties.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmComplexProperties.A2ILabelComp0Click(Sender: TObject);
begin
  if (TA2ILabel(Sender).Tag >= 0) and (TA2ILabel(Sender).Tag < fdata.Count) then
  begin
    select_item := TA2ILabel(Sender).Tag;
    ItemPaint;
  end;
end;

procedure TfrmComplexProperties.A2ILabelComp0MouseEnter(Sender: TObject);
begin
  //
end;

procedure TfrmComplexProperties.A2ILabelComp0MouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TfrmComplexProperties.A2ILabelComp0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  str, s2: string;
  i: Integer;
begin
  if (TA2ILabel(Sender).Tag >= 0) and (TA2ILabel(Sender).Tag < fdata.Count) then
    with pComplexdata(fdata[TA2ILabel(Sender).Tag])^ do
    begin
 // GameHint.settext(-1, name+#13#10+#13#10+text);
      str := text;
      s2 := '';
      for i := 1 to length(str) do
      begin
        if str[i] = '^' then
        begin
          s2 := s2 + #13#10 + '{2} ' + #13#10;
        end
        else
          s2 := s2 + str[i];
      end;
      GameHint.settext(-1, name + #13#10 + '{2} ' + #13#10 + s2);
    end;

end;

procedure TfrmComplexProperties.A2ButtonPageClick(Sender: TObject);
begin
  inherited;
  if TA2Button(Sender).Tag + FCurrPage < 0 then Exit;
  if (TA2Button(Sender).Tag + FCurrPage) * 20 >= fdata.Count then Exit;
  FCurrPage := TA2Button(Sender).Tag + FCurrPage;
  itempaint;
end;

procedure TfrmComplexProperties.A2ButtonGetList(Sender: TObject);
begin
  inherited;
  if tmrStart.Enabled = True then
  begin
    addlog('合成期间不能切换分类!');
    exit;
  end;
  Findex := TA2Button(Sender).Tag;
  select_item := -1;
  ComplexNum := 1;
  FCurrPage := 0;
  A2LabelCount.Caption := IntToStr(ComplexNum);
  getitemlist;

  ItemPaint;
end;

procedure TfrmComplexProperties.A2ButtonChangeNum(Sender: TObject);
begin
  inherited;
  if ComplexNum + TA2Button(Sender).Tag < 1 then exit;
  if ComplexNum + TA2Button(Sender).Tag > 100 then exit;
  ComplexNum := ComplexNum + TA2Button(Sender).Tag;
  A2LabelCount.Caption := IntToStr(ComplexNum);
  itempaint;
end;

procedure TfrmComplexProperties.A2ILabel0MouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

procedure TfrmComplexProperties.A2ILabel0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  str: string;
  tmpitem: TItemData;
  sourceitem: PTItemdata;
begin
  inherited;
  if (select_item >= 0) and (select_item < fdata.Count) then
  begin
    with pComplexdata(fdata[select_item])^ do
      case TA2ILabel(Sender).Tag of
        0: str := name;
        1: str := subitem1;
        2: str := subitem2;
        3: str := subitem3;
        4: str := subitem4;
      end;
    sourceitem := G_BufferItemDataClass.get(str);
    if sourceitem = nil then
    begin
      FrmBottom.SendGetItemData(str);
      Exit;
    end;
    CopyMemory(@tmpitem, sourceitem, SizeOf(TItemData));
    tmpitem.rCount := 1;
    GameHint.settext(Integer(Sender), TItemDataToStr(tmpitem));
  end;
end;


procedure TfrmComplexProperties.autoitem();
begin
  if A2ButtonStart.Enabled = false then Exit;
  if ComplexNum <= 1 then Exit;
  dec(ComplexNum);
  A2LabelCount.Caption := IntToStr(ComplexNum);
  itempaint;
  A2ButtonStartClick(nil);
end;

procedure TfrmComplexProperties.FormShow(Sender: TObject);
begin
  inherited;
  if Findex = -1 then
    A2ButtonGetList(A2ButtonWQ);
end;

end.

