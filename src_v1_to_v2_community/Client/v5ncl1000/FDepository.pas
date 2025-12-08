unit FDepository;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  A2Form, ExtCtrls, StdCtrls, cltype, Deftype, uAnsTick, AtzCls, A2Img, CharCls,
  Autil32, FQuantity, BaseUIForm;

const
  DepItemMaxCount = 40;
  DepMessageMaxCount = 4;
  ItembaseImage = 1;

type
  TFrmDepository = class(TfrmBaseUI)
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
    BtnOk: TA2Button;
    BtnCancel: TA2Button;
    A2LabelCaption: TA2Label;
    A2Form: TA2Form;
    A2Button_close: TA2Button;
//    ILabel40: TA2ILabel;
//    ILabel42: TA2ILabel;
//    ILabel41: TA2ILabel;
//    ILabel43: TA2ILabel;
//    ILabel44: TA2ILabel;
//    ILabel45: TA2ILabel;
//    ILabel46: TA2ILabel;
//    ILabel47: TA2ILabel;
//    ILabel48: TA2ILabel;
//    ILabel49: TA2ILabel;
//    ILabel50: TA2ILabel;
//    ILabel51: TA2ILabel;
//    ILabel52: TA2ILabel;
//    ILabel53: TA2ILabel;
//    ILabel54: TA2ILabel;
//    ILabel56: TA2ILabel;
//    ILabel55: TA2ILabel;
//    ILabel57: TA2ILabel;
//    ILabel58: TA2ILabel;
//    ILabel59: TA2ILabel;
//    ILabel60: TA2ILabel;
//    ILabel61: TA2ILabel;
//    ILabel62: TA2ILabel;
//    ILabel63: TA2ILabel;
//    ILabel64: TA2ILabel;
//    ILabel66: TA2ILabel;
//    ILabel65: TA2ILabel;
//    ILabel67: TA2ILabel;
//    ILabel68: TA2ILabel;
//    ILabel69: TA2ILabel;
//    ILabel70: TA2ILabel;
//    ILabel71: TA2ILabel;
//    ILabel72: TA2ILabel;
//    ILabel73: TA2ILabel;
//    ILabel74: TA2ILabel;
//    ILabel76: TA2ILabel;
//    ILabel75: TA2ILabel;
//    ILabel77: TA2ILabel;
//    ILabel78: TA2ILabel;
//    ILabel79: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ILabelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ILabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ILabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ILabelStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ILabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure ILabelCaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure A2Button_closeClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    FItemimg: TA2Image;
  public
    TEMPFrmQuantity: TFrmQuantity;
    LabelArr: array[0..DepItemMaxCount - 1] of TA2ILabel;
      //  LogItemdata: array[0..DepItemMaxCount - 1] of TItemData;

        //MessageArr:array[0..DepMessageMaxCount - 1] of TA2Label;
    ItemLogBackImg: TA2Image;
    procedure initiaizeItemLabel(Lb: TA2ILabel);
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
    procedure MessageProcess(var code: TWordComData);
    procedure sendItemLogIn(ahaveitemkey, aitemlogkey, acount: integer);
    procedure sendItemLogOUT(ahaveitemkey, aitemlogkey, acount: integer);
    procedure showinputCountOUt(sourkey, destkey, CountCur, CountMax: integer; CountName: string);
    procedure showinputCountIn(sourkey, destkey, CountCur, CountMax: integer; CountName: string);
        //2009.6.29增加
    procedure SetNewVersion();
   // procedure SetOldVersion();
   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    function get(akey: integer): titemdata;
  end;

var
  FrmDepository: TFrmDepository;
  A2baseImageLib: TA2ImageLib;
  A2IMessage: TA2Image;
  MoveFlag: Boolean = FALSE;

implementation

uses
  FMain, FAttrib, Fbl, FBottom, filepgkclass, Math, FWearItem, FGameToolsNew;

{$R *.DFM}
var
  LogItemClass: TcItemListClass;

function TFrmDepository.get(akey: integer): titemdata;
begin
  result := LogItemClass.get(akey);
end;

procedure TFrmDepository.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  psSLogItem: PTSLogItem;
  PSSShowSpecialWindow: PTSShowSpecialWindow;
  i, idx: integer;
  str, rdstr: string;
  StringList: TStringList;
  aitem: titemdata;
  view: string;
  lcolor: Integer;
begin
  pckey := @code.data;
  case pckey^.rmsg of
    SM_SHOWSPECIALWINDOW:
      begin
        PSSShowSpecialWindow := @Code.data;
                // if not FrmAttrib.Visible then FrmAttrib.Visible := TRUE;
        case PSSShowSpecialWindow^.rWindow of
          WINDOW_Close_All:
            Visible := false;
          WINDOW_ITEMLOG:
            begin;
              MoveFlag := TRUE;
                            {  for i := 0 to DepMessageMaxCount - 1 do
                              begin
                                  MessageArr[i].Visible := FALSE;
                              end;}
                            {  for i := 0 to DepItemMaxCount - 1 do
                              begin
                                  LabelArr[i].Visible := TRUE;
                              end;}
              FrmDepository.Visible := TRUE;
              FrmDepository.A2LabelCaption.Caption := (PSSShowSpecialWindow.rCaption);
                          //  FrmDepository.A2LabelState.Caption := GetWordString(PSSShowSpecialWindow.rWordString);
              if FrmWearItem.Visible = false then
                FrmBottom.ButtonWearClick(nil);
              FrmM.move_win_form_Align(FrmDepository, mwfCenterLeft);
            end;
          WINDOW_ALERT:
            begin
                            {   MoveFlag := TRUE;
                               StringList := TStringList.Create;

                               FrmDepository.A2LabelCaption.Caption := (PSSShowSpecialWindow.rCaption);
                               str := GetWordString(PSSShowSpecialWindow.rWordString);
                               i := 0;
                               while TRUE do
                               begin
                                   str := GetValidStr3(str, rdstr, #13);
                                   MessageArr[i].Caption := rdstr;
                                   inc(i);
                                   if str = '' then Break;
                                   if i > 7 then break;
                               end;
                               FrmDepository.Visible := TRUE;
                               StringList.Free;}
            end;

        end;
        if PSSShowSpecialWindow.rWindow = WINDOW_ITEMLOG then


      end;
    SM_LOGITEM:
      begin
        psSLogItem := @Code.data;

        with psSLogItem^do
        begin
          fillchar(aitem, sizeof(TItemData), 0);
          LogItemClass.del(rkey);
                    //if (rName) <> '' then
          try
            LabelArr[rkey].caption := '';
          except
          end;
          if rbodel = false then
          begin
            i := 3;
            TWordComDataToTItemData(i, Code, aitem);
            LogItemClass.upitem(rkey, aitem);
            initiaizeItemLabel(LabelArr[rkey]);
            if aitem.rlockState = 1 then
              idx := 24
            else if aitem.rlockState = 2 then
              idx := 25
            else
              idx := 0;
//            if aitem.rboident then
//            begin
//              view := '可鉴定';       //20130720修改
//              lcolor := clGreen;
//            end;
//            if (aitem.rCount > 1) then
//            begin
//              if aitem.rCount > 10000 then
//                view := IntToStr(aitem.rCount div 10000) + '万'
//              else
//                view := IntToStr(aitem.rCount) + '个';
//              lcolor := clWhite;
//            end;
//            if aitem.rDurability > 0 then
//            begin
//              if aitem.rDurability >= 10000 then
//                view := '持久' + inttostr(aitem.rDurability div 10000) + '万'
//              else
//                view := '持久' + inttostr(aitem.rDurability);
//              lcolor := clred;
//            end;
        //    if not FrmGameToolsNew.A2CheckBox_ShowItem.Checked then view:='';
            SetItemLabel(LabelArr[rkey], view, aitem.rColor, aitem.rshape, idx, lcolor);

          end
          else
          begin
            initiaizeItemLabel(LabelArr[rkey]);
                        // LabelArr[rkey].FHint.setText('');
          end;

        end;
        FrmDepository.Visible := TRUE;
      end;
  end;
end;

procedure TFrmDepository.FormCreate(Sender: TObject);
var
  i: integer;
begin
  inherited;

  FItemimg := TA2Image.Create(32, 32, 0, 0);
  FItemimg.Name := 'FItemimg';

  self.FTestPos := true;
  ItemLogBackImg := TA2Image.Create(32, 32, 0, 0);

  LogItemClass := TcItemListClass.Create(DepItemMaxCount);
  TEMPFrmQuantity := TFrmQuantity.Create(Self);
  TEMPFrmQuantity.Name := 'TEMPFrmQuantity';       //2015.11.09 在水一方 >>>>>>
  TEMPFrmQuantity.SetControlPos(TEMPFrmQuantity);  //<<<<<<

    // Parent := frmm;    
  for i := 0 to DepItemMaxCount - 1 do
  begin
    LabelArr[i] := TA2ILabel(FindComponent('ILabel' + IntToStr(i)));
    LabelArr[i].Tag := i;
    LabelArr[i].Transparent := true;
   //  self.initiaizeItemLabel(LabelArr[i]);
  end;

  FrmM.AddA2Form(Self, A2Form);

//  if WinVerType = wvtOld then
//  begin
//    SetoldVersion;
//  end
  if WinVerType = wvtnew then
  begin
    SetNewVersion;
  end;
  Top := 10;
  Left := 10;

    //  A2baseImagelib.LoadFromFile('.\ect\Deposi.atz');

//  A2Form.FA2Hint.Ftype := hstTransparent;
end;

procedure TFrmDepository.SetNewVersion();
begin
  inherited;
end;

//procedure TFrmDepository.SetNewVersionOld();
//var
//  temping: TA2Image;
//begin
//  pgkBmp.getBmp('个人仓库窗口.bmp', A2form.FImageSurface);
// // a2form.FImageSurface.LoadFromFile('d:\个人仓库.bmp');
//  A2form.boImagesurface := true;
//   { Width := A2Form.FImageSurface.Width;
//    Height := A2Form.FImageSurface.Height;
//   { A2LabelState.Left := 18;
//    A2LabelState.Top := 200;
//    A2LabelState.Width := 354;
//    A2LabelState.Height := 22;}
//  A2LabelCaption.Visible := false;
//
//  temping := TA2Image.Create(32, 32, 0, 0);
//  try
//
//    pgkBmp.getBmp('个人仓库_道具底框.bmp', ItemLogBackImg);
//
//    pgkBmp.getBmp('通用_确认_弹起.bmp', temping);
//    BtnOk.A2Up := temping;
//    pgkBmp.getBmp('通用_确认_按下.bmp', temping);
//    BtnOk.A2Down := temping;
//    pgkBmp.getBmp('通用_确认_鼠标.bmp', temping);
//    BtnOk.A2Mouse := temping;
//    pgkBmp.getBmp('通用_确认_禁止.bmp', temping);
//    BtnOk.A2NotEnabled := temping;
//        {BtnOk.Left := 222;
//        BtnOk.Top := 226;
//        BtnOk.Width := 56;
//        BtnOk.Height := 22;
//        }
//    pgkBmp.getBmp('通用_取消_弹起.bmp', temping);
//    BtnCancel.A2Up := temping;
//    pgkBmp.getBmp('通用_取消_按下.bmp', temping);
//    BtnCancel.A2Down := temping;
//    pgkBmp.getBmp('通用_取消_鼠标.bmp', temping);
//    BtnCancel.A2Mouse := temping;
//    pgkBmp.getBmp('通用_取消_禁止.bmp', temping);
//    BtnCancel.A2NotEnabled := temping;
//        {BtnCancel.Left := 287;
//        BtnCancel.Top := 226;
//        BtnCancel.Width := 56;
//        BtnCancel.Height := 22;
//         }
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//    A2Button_close.A2Up := temping;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//    A2Button_close.A2Down := temping;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//    A2Button_close.A2Mouse := temping;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//    A2Button_close.A2NotEnabled := temping;
//        {A2Button_close.Left := 351;
//        A2Button_close.Top := 15;
//
//        ILabel0.Width := 36;
//        ILabel0.Height := 36;
//        ILabel1.Width := 36;
//        ILabel1.Height := 36;
//        ILabel2.Width := 36;
//        ILabel2.Height := 36;
//        ILabel3.Width := 36;
//        ILabel3.Height := 36;
//        ILabel4.Width := 36;
//        ILabel4.Height := 36;
//        ILabel5.Width := 36;
//        ILabel5.Height := 36;
//        ILabel6.Width := 36;
//        ILabel6.Height := 36;
//        ILabel7.Width := 36;
//        ILabel7.Height := 36;
//        ILabel8.Width := 36;
//        ILabel8.Height := 36;
//        ILabel9.Width := 36;
//        ILabel9.Height := 36;
//
//        ILabel10.Width := 36;
//        ILabel10.Height := 36;
//        ILabel11.Width := 36;
//        ILabel11.Height := 36;
//        ILabel12.Width := 36;
//        ILabel12.Height := 36;
//        ILabel13.Width := 36;
//        ILabel13.Height := 36;
//        ILabel14.Width := 36;
//        ILabel14.Height := 36;
//        ILabel15.Width := 36;
//        ILabel15.Height := 36;
//        ILabel16.Width := 36;
//        ILabel16.Height := 36;
//        ILabel17.Width := 36;
//        ILabel17.Height := 36;
//        ILabel18.Width := 36;
//        ILabel18.Height := 36;
//        ILabel19.Width := 36;
//        ILabel19.Height := 36;
//
//        ILabel20.Width := 36;
//        ILabel20.Height := 36;
//        ILabel21.Width := 36;
//        ILabel21.Height := 36;
//        ILabel22.Width := 36;
//        ILabel22.Height := 36;
//        ILabel23.Width := 36;
//        ILabel23.Height := 36;
//        ILabel24.Width := 36;
//        ILabel24.Height := 36;
//        ILabel25.Width := 36;
//        ILabel25.Height := 36;
//        ILabel26.Width := 36;
//        ILabel26.Height := 36;
//        ILabel27.Width := 36;
//        ILabel27.Height := 36;
//        ILabel28.Width := 36;
//        ILabel28.Height := 36;
//        ILabel29.Width := 36;
//        ILabel29.Height := 36;
//
//        ILabel30.Width := 36;
//        ILabel30.Height := 36;
//        ILabel31.Width := 36;
//        ILabel31.Height := 36;
//        ILabel32.Width := 36;
//        ILabel32.Height := 36;
//        ILabel33.Width := 36;
//        ILabel33.Height := 36;
//        ILabel34.Width := 36;
//        ILabel34.Height := 36;
//        ILabel35.Width := 36;
//        ILabel35.Height := 36;
//        ILabel36.Width := 36;
//        ILabel36.Height := 36;
//        ILabel37.Width := 36;
//        ILabel37.Height := 36;
//        ILabel38.Width := 36;
//        ILabel38.Height := 36;
//        ILabel39.Width := 36;
//        ILabel39.Height := 36;
//
//        ILabel0.Left := 14;
//        ILabel0.Top := 46;
//        ILabel1.Left := 50;
//        ILabel1.Top := 46;
//        ILabel2.Left := 86;
//        ILabel2.Top := 46;
//        ILabel3.Left := 122;
//        ILabel3.Top := 46;
//        ILabel4.Left := 158;
//        ILabel4.Top := 46;
//        ILabel5.Left := 194;
//        ILabel5.Top := 46;
//        ILabel6.Left := 230;
//        ILabel6.Top := 46;
//        ILabel7.Left := 266;
//        ILabel7.Top := 46;
//        ILabel8.Left := 302;
//        ILabel8.Top := 46;
//        ILabel9.Left := 338;
//        ILabel9.Top := 46;
//
//        ILabel10.Left := 14;
//        ILabel10.Top := 82;
//        ILabel11.Left := 50;
//        ILabel11.Top := 82;
//        ILabel12.Left := 86;
//        ILabel12.Top := 82;
//        ILabel13.Left := 122;
//        ILabel13.Top := 82;
//        ILabel14.Left := 158;
//        ILabel14.Top := 82;
//        ILabel15.Left := 194;
//        ILabel15.Top := 82;
//        ILabel16.Left := 230;
//        ILabel16.Top := 82;
//        ILabel17.Left := 266;
//        ILabel17.Top := 82;
//        ILabel18.Left := 302;
//        ILabel18.Top := 82;
//        ILabel19.Left := 338;
//        ILabel19.Top := 82;
//
//        ILabel20.Left := 14;
//        ILabel20.Top := 118;
//        ILabel21.Left := 50;
//        ILabel21.Top := 118;
//        ILabel22.Left := 86;
//        ILabel22.Top := 118;
//        ILabel23.Left := 122;
//        ILabel23.Top := 118;
//        ILabel24.Left := 158;
//        ILabel24.Top := 118;
//        ILabel25.Left := 194;
//        ILabel25.Top := 118;
//        ILabel26.Left := 230;
//        ILabel26.Top := 118;
//        ILabel27.Left := 266;
//        ILabel27.Top := 118;
//        ILabel28.Left := 302;
//        ILabel28.Top := 118;
//        ILabel29.Left := 338;
//        ILabel29.Top := 118;
//
//        ILabel30.Left := 14;
//        ILabel30.Top := 154;
//        ILabel31.Left := 50;
//        ILabel31.Top := 154;
//        ILabel32.Left := 86;
//        ILabel32.Top := 154;
//        ILabel33.Left := 122;
//        ILabel33.Top := 154;
//        ILabel34.Left := 158;
//        ILabel34.Top := 154;
//        ILabel35.Left := 194;
//        ILabel35.Top := 154;
//        ILabel36.Left := 230;
//        ILabel36.Top := 154;
//        ILabel37.Left := 266;
//        ILabel37.Top := 154;
//        ILabel38.Left := 302;
//        ILabel38.Top := 154;
//        ILabel39.Left := 338;
//        ILabel39.Top := 154;
//       
//        ILabel0.Left := 14;
//        ILabel0.Top := 46;
//        ILabel1.Left := 50;
//        ILabel1.Top := 46;
//        ILabel2.Left := 86;
//        ILabel2.Top := 46;
//        ILabel3.Left := 122;
//        ILabel3.Top := 46;
//        ILabel4.Left := 158;
//        ILabel4.Top := 46;
//        ILabel5.Left := 194;
//        ILabel5.Top := 46;
//        ILabel6.Left := 230;
//        ILabel6.Top := 46;
//        ILabel7.Left := 266;
//        ILabel7.Top := 46;
//        ILabel8.Left := 302;
//        ILabel8.Top := 46;
//        ILabel9.Left := 338;
//        ILabel9.Top := 46;
//
//        ILabel10.Left := 14;
//        ILabel10.Top := 82;
//        ILabel11.Left := 50;
//        ILabel11.Top := 82;
//        ILabel12.Left := 86;
//        ILabel12.Top := 82;
//        ILabel13.Left := 122;
//        ILabel13.Top := 82;
//        ILabel14.Left := 158;
//        ILabel14.Top := 82;
//        ILabel15.Left := 194;
//        ILabel15.Top := 82;
//        ILabel16.Left := 230;
//        ILabel16.Top := 82;
//        ILabel17.Left := 266;
//        ILabel17.Top := 82;
//        ILabel18.Left := 302;
//        ILabel18.Top := 82;
//        ILabel19.Left := 338;
//        ILabel19.Top := 82;
//
//        ILabel20.Left := 14;
//        ILabel20.Top := 118;
//        ILabel21.Left := 50;
//        ILabel21.Top := 118;
//        ILabel22.Left := 86;
//        ILabel22.Top := 118;
//        ILabel23.Left := 122;
//        ILabel23.Top := 118;
//        ILabel24.Left := 158;
//        ILabel24.Top := 118;
//        ILabel25.Left := 194;
//        ILabel25.Top := 118;
//        ILabel26.Left := 230;
//        ILabel26.Top := 118;
//        ILabel27.Left := 266;
//        ILabel27.Top := 118;
//        ILabel28.Left := 302;
//        ILabel28.Top := 118;
//        ILabel29.Left := 338;
//        ILabel29.Top := 118;
//
//        ILabel30.Left := 14;
//        ILabel30.Top := 154;
//        ILabel31.Left := 50;
//        ILabel31.Top := 154;
//        ILabel32.Left := 86;
//        ILabel32.Top := 154;
//        ILabel33.Left := 122;
//        ILabel33.Top := 154;
//        ILabel34.Left := 158;
//        ILabel34.Top := 154;
//        ILabel35.Left := 194;
//        ILabel35.Top := 154;
//        ILabel36.Left := 230;
//        ILabel36.Top := 154;
//        ILabel37.Left := 266;
//        ILabel37.Top := 154;
//        ILabel38.Left := 302;
//        ILabel38.Top := 154;
//        ILabel39.Left := 338;
//        ILabel39.Top := 154;
//
//        ILabel40.Left := 14;
//        ILabel40.Top := 190;
//        ILabel41.Left := 50;
//        ILabel41.Top := 190;
//        ILabel42.Left := 86;
//        ILabel42.Top := 190;
//        ILabel43.Left := 122;
//        ILabel43.Top := 190;
//        ILabel44.Left := 158;
//        ILabel44.Top := 190;
//        ILabel45.Left := 194;
//        ILabel45.Top := 190;
//        ILabel46.Left := 230;
//        ILabel46.Top := 190;
//        ILabel47.Left := 266;
//        ILabel47.Top := 190;
//        ILabel48.Left := 302;
//        ILabel48.Top := 190;
//        ILabel49.Left := 338;
//        ILabel49.Top := 190;
//
//        ILabel90.Left := 14;
//        ILabel90.Top := 190+36*5;
//        ILabel91.Left := 50;
//        ILabel91.Top := 190+36*5;
//        ILabel92.Left := 86;
//        ILabel92.Top := 190+36*5;
//        ILabel93.Left := 122;
//        ILabel93.Top := 190+36*5;
//        ILabel94.Left := 158;
//        ILabel94.Top := 190+36*5;
//        ILabel95.Left := 194;
//        ILabel95.Top := 190+36*5;
//        ILabel96.Left := 230;
//        ILabel96.Top := 190+36*5;
//        ILabel97.Left := 266;
//        ILabel97.Top := 190+36*5;
//        ILabel98.Left := 302;
//        ILabel98.Top := 190+36*5;
//        ILabel99.Left := 338;
//        ILabel99.Top := 190+36*5;    }
//  finally
//    temping.Free;
//  end;
//end;

procedure TFrmDepository.SetNewVersionTest;
var
  i: integer;
begin
  inherited;
  SetControlPos(self);
  //self.SetA2ImgPos();
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);

  A2Form.boImagesurface := true;

  for i := 0 to DepItemMaxCount - 1 do
  begin
    SetControlPos(LabelArr[i]);
  end;

  SetControlPos(A2LabelCaption);
  SetControlPos(BtnOk);
  SetControlPos(BtnCancel);
  SetControlPos(A2Button_close);
  SetA2ImgPos(FItemimg);            //2015.11.09 在水一方

end;

procedure TFrmDepository.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TFrmDepository.SetConfigFileName;
begin
  self.FConfigFileName := 'Depository.xml';
end;

//procedure TFrmDepository.SetOldVersion();
//var
//  i: integer;
//begin
//  pgkBmp.getBmp('Deposi.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//  A2baseImagelib := TA2ImageLib.Create;
//  pgkect.getImageLib('Deposi.atz', A2baseImagelib);
//
//end;

procedure TFrmDepository.FormDestroy(Sender: TObject);
begin
  inherited; // 内存泄漏007 在水一方 2015.05.18
  FItemimg.Free;
  ItemLogBackImg.Free;
  LogItemClass.Free;
  A2baseImagelib.Free;
  TEMPFrmQuantity.Free;
end;

procedure TFrmDepository.initiaizeItemLabel(Lb: TA2ILabel);
begin
  Lb.A2ImageRDown := nil;
  Lb.A2ImageLUP := nil;
  Lb.A2Image := FItemimg;
  Lb.A2Imageback := FItemimg;
  Lb.OnDragDrop := ILabelDragDrop;
  Lb.OnDragOver := ILabelDragOver;
  Lb.OnMouseMove := ILabelMouseMove;
  Lb.OnStartDrag := ILabelStartDrag;
  Lb.OnMouseDown := ILabelMouseDown;
end;

procedure TFrmDepository.SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
var
  gc, ga: integer;
  new, tmp, back: TA2Image;
begin
  new := nil;
  back := nil;
  lb.A2Image := FItemimg;
  Lb.Hint := aname;
  GetGreenColorAndAdd(acolor, gc, ga);
  lb.Caption := aname;
  Lb.Font.Color := shapeLUP;
  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;
  lb.A2ImageLUP := nil;
  if shape = 0 then
  begin

    Lb.A2Image := nil;
    Lb.A2ImageRDown := nil;
    Lb.BColor := 0;
    exit;
  end
  else
  begin
    tmp := AtzClass.GetItemImage(shape);
    if tmp <> nil then
    begin
      try
        new := TA2Image.Create(lb.Width, lb.Height, 0, 0);
        //2015.04.30 在水一方 >>>>>>
//        if FItemBackGroundFileName <> '' then
//        begin
//          back := TA2Image.Create(Lb.Width, Lb.Height, 0, 0);
//          back.LoadFromFile(FItemBackGroundFileName);
//          back.addColor(1, 1, 1);
//        end;
        //2015.04.30 在水一方 <<<<<<
        if gc = 0 then
        begin
          new.DrawImage(FItemimg, 1, 0, true);
          if back <> nil then //2015.04.30 在水一方
            new.DrawImage(back, (new.Width - back.Width) div 2, (new.Height - back.Height) div 2, true);
                             // (Lb.Width - tmp.Width) div 2, (Lb.Height - tmp.Height) div 2
          new.DrawImage(tmp, (new.Width - tmp.Width) div 2, (new.Height - tmp.Height) div 2, true);
        end
        else
        begin
          new.DrawImageGreenConvert(FItemimg, 1, 0, gc, ga);
          if back <> nil then //2015.04.30 在水一方
            new.DrawImageGreenConvert(back, (new.Width - back.Width) div 2, (new.Height - back.Height) div 2, gc, ga);
          new.DrawImageGreenConvert(tmp, (new.Width - tmp.Width) div 2, (new.Height - tmp.Height) div 2, gc, ga);
        end;
        Lb.A2Image := new;
      finally
        new.Free;
        if back <> nil then
          back.Free;
      end;
    end;
    Lb.A2ImageRDown := nil;
  //  Lb.A2Image := AtzClass.GetItemImage(shape);
    if shapeRdown <> 0 then
      Lb.A2ImageRDown := savekeyImagelib[shapeRdown];
  end;
    {
if shape = 0 then
begin
   Lb.A2Image := nil;
   Lb.BColor := 0;
   exit;
end else
   Lb.A2Image := AtzClass.GetItemImage(shape);
   }
end;

procedure TFrmDepository.sendItemLogIn(ahaveitemkey, aitemlogkey, acount: integer);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ITEMLOG);
  WordComData_ADDbyte(temp, ITEMLOG_IN);
  WordComData_ADDdword(temp, ahaveitemkey);
  WordComData_ADDdword(temp, aitemlogkey);
  WordComData_ADDdword(temp, acount);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmDepository.sendItemLogOUT(ahaveitemkey, aitemlogkey, acount: integer);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ITEMLOG);
  WordComData_ADDbyte(temp, ITEMLOG_OUT);
  WordComData_ADDdword(temp, ahaveitemkey);
  WordComData_ADDdword(temp, aitemlogkey);
  WordComData_ADDdword(temp, acount);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmDepository.showinputCountIn(sourkey, destkey, CountCur, CountMax: integer; CountName: string);
begin
  if CountMax = 1 then                                    //20130901修改直接拖放
  begin
    frmDepository.sendItemLogIn(sourkey, destkey, CountMax);
  //  Visible := FALSE;
    SAY_EdChatFrmBottomSetFocus;
  end
  else                                   //20130901修改直接拖放
  begin
  //  FrmQuantity.showinputCount(SH_DepositoryIn, sourkey, destkey, CountCur, CountMax, CountName);

    TEMPFrmQuantity.ShowType := SH_DepositoryIn;
    TEMPFrmQuantity.sourkey := sourkey;
    TEMPFrmQuantity.destkey := destkey;
    TEMPFrmQuantity.CountCur := CountCur;
    TEMPFrmQuantity.CountMax := CountMax;
    TEMPFrmQuantity.CountName := CountName;
    TEMPFrmQuantity.LbCountName.Caption := TEMPFrmQuantity.CountName;
    TEMPFrmQuantity.EdCount.Text := inttostr(TEMPFrmQuantity.CountMax);
    TEMPFrmQuantity.Visible := true;
    FrmM.SetA2Form(TEMPFrmQuantity, TEMPFrmQuantity.A2form);  //2015.11.09 在水一方
  end;
end;

procedure TFrmDepository.showinputCountOUt(sourkey, destkey, CountCur, CountMax: integer; CountName: string);
begin
  TEMPFrmQuantity.ShowType := SH_DepositoryOUt;

  TEMPFrmQuantity.sourkey := sourkey;
  TEMPFrmQuantity.destkey := destkey;
  TEMPFrmQuantity.CountCur := CountCur;
  TEMPFrmQuantity.CountMax := CountMax;
  TEMPFrmQuantity.CountName := CountName;
  TEMPFrmQuantity.LbCountName.Caption := TEMPFrmQuantity.CountName;
  TEMPFrmQuantity.EdCount.Text := inttostr(TEMPFrmQuantity.CountMax);
  if CountMax = 1 then                                       //20130901修改直接拖放
  begin
    frmDepository.sendItemLogOUt(destkey, sourkey, CountMax);
//  Visible := FALSE;
    SAY_EdChatFrmBottomSetFocus;
  end
  else begin
    TEMPFrmQuantity.Visible := true;
    FrmM.SetA2Form(TEMPFrmQuantity, TEMPFrmQuantity.A2form);  //2015.11.09 在水一方
  end;
end;

procedure TFrmDepository.ILabelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
begin
  if Source = nil then
    exit;
  if TDragItem(Source).SourceID <> WINDOW_ITEMS then
    exit;
  if HaveItemclass.IS_Samzie(DragItem.Selected) = false then
  begin
    FrmBottom.AddChat('无法放入福袋的物品', WinRGB(22, 22, 0), 0);
    exit;
  end;
  showinputCountIN(DragItem.Selected, TA2ILabel(Sender).tag, 1, HaveItemclass.get(DragItem.Selected).rCount, HaveItemclass.get(DragItem.Selected).rViewName);
end;

procedure TFrmDepository.ILabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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

procedure TFrmDepository.ILabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  MouseInfoStr := TA2ILabel(Sender).Hint;

  if LogItemClass.get(TA2ILabel(Sender).Tag).rViewName <> '' then
    GameHint.setText(integer(Sender), TItemDataToStr(LogItemClass.get(TA2ILabel(Sender).Tag)))
  else
    GameHint.Close;
end;

procedure TFrmDepository.ILabelStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_ITEMLOG;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmDepository.ILabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if LogItemClass.get(TA2ILabel(Sender).Tag).rViewName <> '' then      //检测不允许拖动没道具的窗口
    TA2ILabel(Sender).BeginDrag(FALSE);
end;

procedure TFrmDepository.FormShow(Sender: TObject);
begin
    { Top := (fheight - 117 - Height) div 2;
     if FrmAttrib.Visible then Left := (fwideth - 180 - Width) div 2
     else Left := (fwideth - Width) div 2;
     }
end;

procedure TFrmDepository.BtnOkClick(Sender: TObject);
var
  cCWindowConfirm: TCWindowConfirm;
begin
  cCWindowConfirm.rMsg := CM_WINDOWCONFIRM;
  CCWindowConfirm.rWindow := WINDOW_ITEMLOG;
  cCWindowConfirm.rboCheck := TRUE;
  cCWindowConfirm.rButton := 0; // 滚瓢捞 咯妨俺 乐阑版快父 荤侩 老馆篮 0捞 檬扁蔼
  Frmfbl.SocketAddData(sizeof(cCWindowConfirm), @cCWindowConfirm);
  FrmDepository.Visible := FALSE;
end;

procedure TFrmDepository.BtnCancelClick(Sender: TObject);
var
  cCWindowConfirm: TCWindowConfirm;
begin
  cCWindowConfirm.rMsg := CM_WINDOWCONFIRM;
  CCWindowConfirm.rWindow := WINDOW_ITEMLOG;
  cCWindowConfirm.rboCheck := FALSE;
  cCWindowConfirm.rButton := 0; // 滚瓢捞 咯妨俺 乐阑版快父 荤侩 老馆篮 0捞 檬扁蔼
  Frmfbl.SocketAddData(sizeof(cCWindowConfirm), @cCWindowConfirm);
  FrmDepository.Visible := FALSE;
end;

var
  Boolflag: Boolean = FALSE;
  Or_baseX: integer = 0;
  Or_baseY: integer = 0;

function CheckMaxRight: integer;
begin
  if FrmAttrib.Visible then
    Result := fwide - FrmAttrib.Width
  else
    Result := fwide;
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
    Result := (fhei - Frmbottom.Height) + 10
  else
    Result := fhei;
end;

//窗口拖动
procedure TFrmDepository.ILabelCaptionMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmDepository.A2Button_closeClick(Sender: TObject);
var
  cCWindowConfirm: TCWindowConfirm;
begin
  cCWindowConfirm.rMsg := CM_WINDOWCONFIRM;
  CCWindowConfirm.rWindow := WINDOW_ITEMLOG;
  cCWindowConfirm.rboCheck := FALSE;
  cCWindowConfirm.rButton := 0; // 滚瓢捞 咯妨俺 乐阑版快父 荤侩 老馆篮 0捞 檬扁蔼
  Frmfbl.SocketAddData(sizeof(cCWindowConfirm), @cCWindowConfirm);
  FrmDepository.Visible := FALSE;
end;

procedure TFrmDepository.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

end.

