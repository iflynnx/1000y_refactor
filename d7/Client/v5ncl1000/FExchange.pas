unit FExchange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, A2Form, ExtCtrls, deftype, cltype, AUtil32, Charcls, AtzCls,
  FQuantity, A2Img, BaseUIForm;

type                                            
  TFrmExchange = class(TfrmBaseUI)
    BtnOk: TA2Button;
    BtnCancel: TA2Button;   
    A2Button_close: TA2Button;
    A2ILabel1: TA2ILabel;
    A2ILabel2: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2ILabel4: TA2ILabel;
    A2ILabel5: TA2ILabel;
    A2ILabel6: TA2ILabel;
    A2ILabel7: TA2ILabel;
    A2ILabel8: TA2ILabel;
    LbLEFT: TA2ILabel;
    A2Form: TA2Form;
    A2Label1: TA2Label;
    A2Label2: TA2Label;
    Lbright: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Clear;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure SourceItemStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure SourceItemDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SourceItemDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure A2ILabel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure SetFormText;
    procedure A2ILabel5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape: word);
  public
        //  TEMPFrmQuantity:TFrmQuantity;
    LEFTLabelArr: array[0..4 - 1] of TA2ILabel;
    RIGHTLabelArr: array[0..4 - 1] of TA2ILabel;
    LEFTdataArr: array[0..4 - 1] of titemdata;
    RIGHTdataArr: array[0..4 - 1] of titemdata;
    ExchangeLock: Boolean;
    FItemimg: TA2Image;
    procedure MessageProcess(var code: TWordComData);
    procedure senditemadd(akey, acount: integer);
    procedure senditemDEL(akey: integer);
        //2009.6.30增加
    procedure SetNewVersion();
    //procedure SetOldVersion();
        //2015.10.7增加
   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

var
  FrmExchange: TFrmExchange;

implementation

uses
  FMain, FAttrib, Fbl, FBottom, filepgkclass;

{$R *.DFM}

procedure TFrmExChange.SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape: word);
var
  gc, ga: integer;
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
    Lb.A2Image := AtzClass.GetItemImage(shape);
end;

procedure TFrmExChange.MessageProcess(var code: TWordComData);
var
  i, J, n, TEMP, N1, N2, N3: integer;
  str: string;
  pckey: PTCKey;
  psExChange: PTSExChange;
  aitem: titemdata;
begin
  pckey := @Code.data;
  case pckey^.rmsg of
    SM_SHOWEXCHANGE:
      begin
        i := 1;
        n := WordComData_GETbyte(code, i);
        case n of
          SHOWEXCHANGE_head:
            begin
              Clear;
              A2Label1.FontColor := ColorSysToDxColor($FFF0FFFF);
              A2Label2.FontColor := ColorSysToDxColor($FFF0FFFF);

              str := WordComData_GETString(code, i);
              A2Label2.Caption := str;
              A2Label1.Caption := WordComData_GETString(code, i);
                            //  FrmBottom.AddChat('SHOWEXCHANGE_head交易筐', WinRGB(22, 22, 0), 0);
              FrmExchange.Visible := TRUE;
            end;  
          SHOWEXCHANGE_item:
            begin
              TEMP := WordComData_GETbyte(code, i);
              FrmQuantity.showinputCount(SH_ExChange, TEMP, TEMP, 1, HaveItemclass.get(TEMP).rCount, HaveItemclass.get(TEMP).rViewName);

              //显示输入窗口
            end;
          SHOWEXCHANGE_Left:
            begin
              TEMP := WordComData_GETbyte(code, i);

              BtnOk.Enabled := not BOOLEAN(TEMP);
              if BOOLEAN(TEMP) then
              begin
                                //A2Label1.BColor := ColorSysToDxColor($FFBA55D3);
                A2Label1.FontColor := ColorSysToDxColor($FFBA55D3);
              end
              else
                A2Label1.FontColor := ColorSysToDxColor($FFF0FFFF);
              TEMP := WordComData_GETbyte(code, i);
              for J := 0 to TEMP - 1 do
              begin
                N1 := WordComData_GETbyte(code, i);
                case N1 of
                  SHOWEXCHANGE_add:
                    begin
                                            // N2 := WordComData_GETDWORD(code, i);
                                            // N3 := WordComData_GETDWORD(code, i);
                      TWordComDataToTItemData(i, code, aitem);
                      n3 := aitem.rcolor;
                      n2 := aitem.rShape;
                      LEFTdataArr[j] := aitem;
                                            //  STR := WordComData_GETString(code, i);
                      SetItemLabel(LEFTLabelArr[J], '', N3, N2);
                                            //  LEFTLabelArr[J].FHint.setText(STR);
                                              // FrmBottom.AddChat(format('SHOWEXCHANGE_Left交易筐%d 位置%s。', [J, str]), WinRGB(22, 22, 0), 0);
                    end;
                  2:
                    begin
                                            // FrmBottom.AddChat(format('SHOWEXCHANGE_Left交易筐%d 位置%S。', [J, '数据没变']), WinRGB(22, 22, 0), 0);
                    end;
                  3:
                    begin
                                            // FrmBottom.AddChat(format('SHOWEXCHANGE_Left交易筐%d 位置%s。', [J, '空闲']), WinRGB(22, 22, 0), 0);
                      fillchar(LEFTdataArr[j], sizeof(titemdata), 0);
                      LEFTLabelArr[J].A2Image := nil;
                                            // LEFTLabelArr[J].FHint.setText('');
                    end;
                else
                  begin
                    FrmBottom.AddChat(format('SHOWEXCHANGE_Left错误 类型:%d。', [N1]), WinRGB(22, 22, 0), 0);
                  end;
                end;

              end;

            end;
          SHOWEXCHANGE_right:
            begin
              TEMP := WordComData_GETbyte(code, i);

              if BOOLEAN(TEMP) then
              begin
                                //A2Label2.BColor := ColorSysToDxColor($FFBA55D3);
                A2Label2.FontColor := ColorSysToDxColor($FFBA55D3);
              end
              else
                A2Label2.FontColor := ColorSysToDxColor($FFF0FFFF);
              TEMP := WordComData_GETbyte(code, i);
              for J := 0 to TEMP - 1 do
              begin
                N1 := WordComData_GETbyte(code, i);
                case N1 of
                  1:
                    begin
                                            //  N2 := WordComData_GETDWORD(code, i);
                                              //N3 := WordComData_GETDWORD(code, i);
                                              //STR := WordComData_GETString(code, i);
                      TWordComDataToTItemData(i, code, aitem);
                      n3 := aitem.rcolor;
                      n2 := aitem.rShape;
                      RIGHTdataArr[j] := aitem;
                      SetItemLabel(RIGHTLabelArr[J], '', N3, N2);
                                            // RIGHTLabelArr[J].FHint.setText(STR);
                                             //  FrmBottom.AddChat(format('SHOWEXCHANGE_right交易筐%d 位置%s。', [J, str]), WinRGB(22, 22, 0), 0);
                    end;
                  2:
                    begin
                                            // FrmBottom.AddChat(format('SHOWEXCHANGE_right交易筐%d 位置没更新。', [J]), WinRGB(22, 22, 0), 0);
                    end;
                  3:
                    begin
                                            //  FrmBottom.AddChat(format('SHOWEXCHANGE_right交易筐%d 位置%s。', [J, '空闲']), WinRGB(22, 22, 0), 0);
                      RIGHTLabelArr[J].A2Image := nil;
                      fillchar(RIGHTdataArr[j], sizeof(titemdata), 0);
                                            // RIGHTLabelArr[J].FHint.setText('');
                    end;
                else
                  begin
                    FrmBottom.AddChat(format('SHOWEXCHANGE_right错误 类型:%d。', [N1]), WinRGB(22, 22, 0), 0);
                  end;
                end;

              end;

            end;
        end;

      end;
  end;
end;

procedure TFrmExchange.Clear;
begin
  fillchar(LEFTdataArr, sizeof(titemdata) * (high(LEFTdataArr) + 1), 0);
  fillchar(RIGHTdataArr, sizeof(titemdata) * (high(RIGHTdataArr) + 1), 0);
  ExchangeLock := false;
  LbLEFT.Caption := '';
  Lbright.Caption := ''; 
  A2ILabel1.A2Image := nil;
    //  A2ILabel1.FHint.setText('');
  A2ILabel2.A2Image := nil;
    //  A2ILabel2.FHint.setText('');
  A2ILabel3.A2Image := nil;
    // A2ILabel3.FHint.setText('');
  A2ILabel4.A2Image := nil;
    // A2ILabel4.FHint.setText('');
  A2ILabel5.A2Image := nil;
    // A2ILabel5.FHint.setText('');
  A2ILabel6.A2Image := nil;
    // A2ILabel6.FHint.setText('');
  A2ILabel7.A2Image := nil;
    //A2ILabel7.FHint.setText('');
  A2ILabel8.A2Image := nil;
    //  A2ILabel8.FHint.setText('');
end;

procedure TFrmExchange.FormCreate(Sender: TObject);
var
  i: integer;
begin
  inherited;
  FTestPos := True;

  FrmM.AddA2Form(Self, A2Form);

//  if WinVerType = wvtOld then
//  begin
//    SetoldVersion;
//  end
  if WinVerType = wvtnew then
  begin
    SetnewVersion;
  end;


  A2Label1.Left := LbLEFT.Left;
  A2Label1.Top := LbLEFT.Top;
  A2Label1.Width := LbLEFT.Width;
  A2Label1.Height := LbLEFT.Height;

  A2Label2.Left := Lbright.Left;
  A2Label2.Top := Lbright.Top;
  A2Label2.Width := Lbright.Width;
  A2Label2.Height := Lbright.Height;

  LbLEFT.Visible := false;
  Lbright.Visible := false;

//    A2form.FA2Hint.Ftype := hstTransparent;
  Color := clBlack;
  Left := 10;
  Top := 10;

  LEFTLabelArr[0] := A2ILabel1;

    //    LEFTLabelArr[0].FHint.Ftype := hstTransparent;
  LEFTLabelArr[1] := A2ILabel2;
    //    LEFTLabelArr[1].FHint.Ftype := hstTransparent;
  LEFTLabelArr[2] := A2ILabel3;
    //    LEFTLabelArr[2].FHint.Ftype := hstTransparent;
  LEFTLabelArr[3] := A2ILabel4;
    //    LEFTLabelArr[3].FHint.Ftype := hstTransparent;
  RIGHTLabelArr[0] := A2ILabel5;
    //    RIGHTLabelArr[0].FHint.Ftype := hstTransparent;
  RIGHTLabelArr[1] := A2ILabel6;
    //    RIGHTLabelArr[1].FHint.Ftype := hstTransparent;
  RIGHTLabelArr[2] := A2ILabel7;
    //    RIGHTLabelArr[2].FHint.Ftype := hstTransparent;
  RIGHTLabelArr[3] := A2ILabel8;
    //    RIGHTLabelArr[3].FHint.Ftype := hstTransparent;
  for i := 0 to high(LEFTLabelArr) do
  begin
    LEFTLabelArr[i].Tag := i;
  end;

  for i := 0 to high(RIGHTLabelArr) do
  begin
    RIGHTLabelArr[i].Tag := i;
  end;
    //   TEMPFrmQuantity := TFrmQuantity.Create(FrmM);
end;
//2009.6.30增加

procedure TFrmExchange.SetNewVersion();
begin
  if FTestPos then
    SetNewVersionTest;

 // else
  //  SetNewVersionOld;

end;

//procedure TFrmExchange.SetOldVersion();
//begin
//  pgkBmp.getBmp('交易背景.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//end;

//procedure TFrmExchange.SetNewVersionOld;
//var
//  temping, tempup, tempdown: TA2Image;
//begin
//  FItemimg := TA2Image.Create(32, 32, 0, 0);
//  try
//    pgkBmp.getBmp('交易背景.bmp', A2form.FImageSurface);
//    A2form.boImagesurface := true;
//    Width := A2form.FImageSurface.Width;
//    height := A2form.FImageSurface.Height;
//    //确认
//    pgkBmp.getBmp('通用_确认_弹起.bmp', FItemimg);
//    BtnOk.A2Up := FItemimg;
//    pgkBmp.getBmp('通用_确认_按下.bmp', FItemimg);
//    BtnOk.A2Down := FItemimg;
//    pgkBmp.getBmp('通用_确认_鼠标.bmp', FItemimg);
//    BtnOk.A2Mouse := FItemimg;
//    pgkBmp.getBmp('通用_确认_禁止.bmp', FItemimg);
//    BtnOk.A2NotEnabled := FItemimg;
//    BtnOk.Left := 24;
//    BtnOk.Top := 137;
//    BtnOk.Width := 56;
//    BtnOk.Height := 22;
//    //取消
//    pgkBmp.getBmp('通用_取消_弹起.bmp', FItemimg);
//    BtnCancel.A2Up := FItemimg;
//    pgkBmp.getBmp('通用_取消_按下.bmp', FItemimg);
//    BtnCancel.A2Down := FItemimg;
//    pgkBmp.getBmp('通用_取消_鼠标.bmp', FItemimg);
//    BtnCancel.A2Mouse := FItemimg;
//    pgkBmp.getBmp('通用_取消_禁止.bmp', FItemimg);
//    BtnCancel.A2NotEnabled := FItemimg;
//    BtnCancel.Left := 116;
//    BtnCancel.Top := 137;
//    BtnCancel.Width := 56;
//    BtnCancel.Height := 22;
//    pgkBmp.getBmp('玩家交易_道具底框.bmp', FItemimg);
//    A2ILabel1.A2Image := FItemimg;
//    A2ILabel1.A2Imageback := FItemimg;
//    A2ILabel2.A2Image := FItemimg;
//    A2ILabel2.A2Imageback := FItemimg;
//    A2ILabel3.A2Image := FItemimg;
//    A2ILabel3.A2Imageback := FItemimg;
//    A2ILabel4.A2Image := FItemimg;
//    A2ILabel4.A2Imageback := FItemimg;
//    A2ILabel5.A2Image := FItemimg;
//    A2ILabel5.A2Imageback := FItemimg;
//    A2ILabel6.A2Image := FItemimg;
//    A2ILabel6.A2Imageback := FItemimg;
//    A2ILabel7.A2Image := FItemimg;
//    A2ILabel7.A2Imageback := FItemimg;
//    A2ILabel8.A2Image := FItemimg;
//    A2ILabel8.A2Imageback := FItemimg;
//    A2ILabel1.Left := 12;
//    A2ILabel1.Top := 46;
//    A2ILabel1.Width := 40;
//    A2ILabel1.Height := 40;
//
//    A2ILabel2.Left := 52;
//    A2ILabel2.Top := 46;
//    A2ILabel2.Width := 40;
//    A2ILabel2.Height := 40;
//
//    A2ILabel3.Left := 12;
//    A2ILabel3.Top := 86;
//    A2ILabel3.Width := 40;
//    A2ILabel3.Height := 40;
//
//    A2ILabel4.Left := 52;
//    A2ILabel4.Top := 86;
//    A2ILabel4.Width := 40;
//    A2ILabel4.Height := 40;
//
//    A2ILabel5.Left := 104;
//    A2ILabel5.Top := 46;
//    A2ILabel5.Width := 40;
//    A2ILabel5.Height := 40;
//
//    A2ILabel6.Left := 144;
//    A2ILabel6.Top := 46;
//    A2ILabel6.Width := 40;
//    A2ILabel6.Height := 40;
//
//    A2ILabel7.Left := 104;
//    A2ILabel7.Top := 86;
//    A2ILabel7.Width := 40;
//    A2ILabel7.Height := 40;
//
//    A2ILabel8.Left := 144;
//    A2ILabel8.Top := 86;
//    A2ILabel8.Width := 40;
//    A2ILabel8.Height := 40;
//
//    //
//    LbLEFT.Left := 12;
//    LbLEFT.Top := 26;
//    LbLEFT.Width := 80;
//    LbLEFT.Height := 15;
//    //
//    Lbright.Left := 104;
//    Lbright.Top := 26;
//    Lbright.Width := 80;
//    Lbright.Height := 15;
//    //
//  finally
//    FItemimg.Free;
//  end;
//end;

procedure TFrmExchange.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);

  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;   

  SetControlPos(BtnOk);
  SetControlPos(BtnCancel);  
  SetControlPos(A2Button_close);

  SetControlPos(LbLEFT);
  SetControlPos(Lbright);

  SetControlPos(A2Label1);
  SetControlPos(A2Label2);

  SetControlPos(A2ILabel1);
  SetControlPos(A2ILabel2);
  SetControlPos(A2ILabel3);
  SetControlPos(A2ILabel4);
  SetControlPos(A2ILabel5);
  SetControlPos(A2ILabel6);
  SetControlPos(A2ILabel7);
  SetControlPos(A2ILabel8);
end;

procedure TFrmExchange.SetConfigFileName;
begin
  inherited;
  self.FConfigFileName := 'Exchange.xml';
end;

procedure TFrmExchange.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TFrmExchange.FormDestroy(Sender: TObject);
begin
    //    TEMPFrmQuantity.Free;
  FItemimg.Free;
end;

procedure TFrmExchange.BtnCancelClick(Sender: TObject);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ExChange);
  WordComData_ADDbyte(temp, ExChange_CANCEL);

  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmExchange.BtnOkClick(Sender: TObject);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ExChange);
  WordComData_ADDbyte(temp, ExChange_ok);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmExchange.SourceItemStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
    //
end;

procedure TFrmExchange.senditemadd(akey, acount: integer);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ExChange);
  WordComData_ADDbyte(temp, ExChange_listAdd);
  WordComData_ADDdword(temp, akey);
  WordComData_ADDdword(temp, acount);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmExchange.senditemDEL(akey: integer);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_ExChange);
  WordComData_ADDbyte(temp, ExChange_listDEL);
  WordComData_ADDdword(temp, akey);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmExchange.SourceItemDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  cDragDrop: TCDragDrop;
begin
  if Source = nil then
    exit;

  with Source as TDragItem do
  begin
    if SourceID <> WINDOW_ITEMS then
      exit;
        {    cDragDrop.rmsg := CM_DRAGDROP;
            cDragDrop.rsourId := DragedId;
            cDragDrop.rdestId := 0;
            cDragDrop.rsourwindow := SourceId;
            cDragDrop.rdestwindow := WINDOW_EXCHANGE;
            cDragDrop.rsourkey := Selected;
            cDragDrop.rdestkey := TA2ILabel(Sender).tag;
            Frmfbl.SocketAddData (sizeof(cDragDrop), @cDragDrop);}
  end;
  if HaveItemclass.IS_Exchange(DragItem.Selected) = false then
  begin
    FrmBottom.AddChat('无法交易的物品', WinRGB(22, 22, 0), 0);     //20121122修改，任何物品可以丢弃
    exit;
  end;
  
  FrmQuantity.showinputCount(SH_ExChange, DragItem.Selected, TA2ILabel(Sender).tag, 1, HaveItemclass.get(DragItem.Selected).rCount, HaveItemclass.get(DragItem.Selected).rViewName);
end;

procedure TFrmExchange.SourceItemDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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

procedure TFrmExchange.A2ILabel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    //    MouseInfoStr := TA2ILabel(Sender).Hint;
  if LEFTdataArr[TA2ILabel(Sender).Tag].rViewName = '' then
    GameHint.Close
  else
    GameHint.setText(integer(Sender), TItemDataToStr(LEFTdataArr[TA2ILabel(Sender).Tag]));
end;

procedure TFrmExchange.FormShow(Sender: TObject);
begin
    // Clear;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmExchange.SetFormText;
begin
  FrmExchange.Font.Name := mainFont;

end;

procedure TFrmExchange.A2ILabel5MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if RIGHTdataArr[TA2ILabel(Sender).Tag].rViewName = '' then
    GameHint.Close
  else
    GameHint.setText(integer(Sender), TItemDataToStr(RIGHTdataArr[TA2ILabel(Sender).Tag]));
end;

procedure TFrmExchange.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;



end.

