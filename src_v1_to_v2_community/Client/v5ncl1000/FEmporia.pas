unit FEmporia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, StdCtrls, deftype, uKeyClass, ExtCtrls, A2Img, shellapi, IniFiles, BaseUIForm, Atzcls,
  FQuantity;

type
  TEmporiadata = record
    id: integer;
    index: INTEGER;
    rColor
      , rShape: integer;
    name: string[32];
    text: string[255];
    num, price, SmithingLevel: integer;
  end;
  pTEmporiadata = ^TEmporiadata;

  TfrmEmporia = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2Button1: TA2Button;
    A2Button2: TA2Button;
    A2Button3: TA2Button;
    A2Button4: TA2Button;
    A2Button5: TA2Button;
    Panel_buy_ok: TPanel;
    A2Button_BUYclose: TA2Button;
    A2Edit_select_num: TA2Edit;
    A2Label_select_name: TA2Label;
    A2Button_close: TA2Button;
    Panel_itemList: TPanel;
    A2ILabel1: TA2ILabel;
    A2ILabel_money: TA2Label;
    A2Button6: TA2Button;
    A2ILabel2: TA2ILabel;
    A2ILabel3: TA2ILabel;
    A2ILabel4: TA2ILabel;
    A2ILabel5: TA2ILabel;
    A2ILabel6: TA2ILabel;
    A2ILabel7: TA2ILabel;
    A2ILabel8: TA2ILabel;
    A2ILabel9: TA2ILabel;
    A2ILabel10: TA2ILabel;
    A2ILabel11: TA2ILabel;
    A2ILabel12: TA2ILabel;
    A2Label_price: TA2Label;
    A2ILabel37: TA2ILabel;
    A2Button7: TA2Button;
    A2Edit1: TA2Edit;
    A2Button8: TA2Button;
    A2Button_BUY: TA2Button;
    A2ILabel_select_item: TA2ILabel;
    NameA2Label1: TA2Label;
    NameA2Label2: TA2Label;
    NameA2Label3: TA2Label;
    NameA2Label4: TA2Label;
    NameA2Label5: TA2Label;
    NameA2Label6: TA2Label;
    NameA2Label7: TA2Label;
    NameA2Label8: TA2Label;
    A2Button9: TA2Button;
    NameA2Label9: TA2Label;
    NameA2Label10: TA2Label;
    NameA2Label11: TA2Label;
    NameA2Label12: TA2Label;
    A2Label1: TA2Label;
    A2Label2: TA2Label;
    A2Label3: TA2Label;
    A2Label4: TA2Label;
    A2Label5: TA2Label;
    A2Label6: TA2Label;
    A2Label7: TA2Label;
    A2Label8: TA2Label;
    A2Label9: TA2Label;
    A2Label10: TA2Label;
    A2Label11: TA2Label;
    A2Label12: TA2Label;
    A2Button_Pre: TA2Button;
    A2Button_Next: TA2Button;
    A2Label_PageInfo: TA2Label;
    A2Button_BUYOK: TA2Button;
    Timer1: TTimer;
    A2Label_Get: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ILabel1Click(Sender: TObject);
    procedure A2Button_BUYClick(Sender: TObject);
    procedure A2Button_closeClick(Sender: TObject);
    procedure A2Button1Click(Sender: TObject);
    procedure A2Button_BUYcloseClick(Sender: TObject);
    procedure A2ILabel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Edit_select_numChange(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2Button7Click(Sender: TObject);
    procedure A2Button8Click(Sender: TObject);
    procedure A2Button_PreClick(Sender: TObject);
    procedure A2Button_NextClick(Sender: TObject);
    procedure A2ILabel1MouseLeave(Sender: TObject);
    procedure A2ILabel1DbClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure A2Label_GetMouseLeave(Sender: TObject);
    procedure A2Label_GetMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A2Label_GetClick(Sender: TObject);
  private
    FIndex0MaxCount: Integer;
    FIndex1MaxCount: Integer;
    FIndex2MaxCount: Integer;
    FIndex3MaxCount: Integer;
    FIndex4MaxCount: Integer;
    FIndex5MaxCount: Integer;
    FPage: Integer;
    FMaxPage: Integer;
  public
        { Public declarations }
    fbackimg: TA2Image;
    fOKimg: TA2Image;
    Fkuangimg: TA2Image;
    itemArr: array[0..12 - 1] of TA2ILabel;
    FkuangitemArr: array[0..12 - 1] of TA2ILabel;
    FItemNameArr: array[0..12 - 1] of TA2Label;
    FItemPriceArr: array[0..12 - 1] of TA2Label;
    select_menu_item: integer;
    fdata: tlist;
    FindexName: TStringKeyClass;
    FButtonArr: array[0..5] of TA2Button;
    FSelectItemTag: Integer;
    FA2ImageitemBack: TA2Image;
    EmporiaFrmQuantity: TFrmQuantity;
    procedure CLEAR();
    procedure add(var aitem: TEmporiadata);
    function get(aname: string): pTEmporiadata;
    function getid(aid: integer): pTEmporiadata;
    procedure MessageProcess(var code: TWordComData);

    procedure itempaint();
    procedure setitemshpe(Lb: TA2ILabel; var aitem: TEmporiadata);
    procedure SetItemLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape, shapeRdown, shapeLUP: word);
    procedure sendBuy(aitemname: string; acount: integer);

    procedure sendshowForm();

    procedure addlog(atext: string);


    //procedure SetOldVersion;
    procedure SetNewVersion(); override;


   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;

  end;

var
  frmEmporia: TfrmEmporia;

implementation

{$R *.dfm}
uses FAttrib, FMain, Fbl, AUtil32, FBottom, filepgkclass, charcls;

procedure TfrmEmporia.setitemshpe(Lb: TA2ILabel; var aitem: TEmporiadata);

begin
  if Lb.Tag = FSelectItemTag then

    SetItemLabel(lb
      , ''
      , aitem.rColor
      , aitem.rShape
      , 0, 0
      )
  else
    FrmAttrib.SetItemLabel(lb
      , ''
      , aitem.rColor
      , aitem.rShape
      , 0, 0
      );
end;

procedure TfrmEmporia.itempaint();
var
  i, j: integer;
  pp: pTEmporiadata;
  pagecount: Integer;
  totalpage: Integer;
  maxcount: Integer;
begin
  pagecount := 12;
  A2Label_PageInfo.Caption := '0/0';
  Panel_buy_ok.Visible := false;
  for I := Low(FItemNameArr) to High(FItemNameArr) do
  begin
    FItemNameArr[i].Caption := '';
  end;
  for I := Low(FItemPriceArr) to High(FItemPriceArr) do
  begin
    FItemPriceArr[i].Caption := '';
  end;
  for i := 0 to 12 - 1 do
  begin
    itemArr[i].A2Image := nil;
    itemArr[i].A2ImageLUP := nil;
    itemArr[i].A2ImageRDown := nil;
    itemArr[i].Caption := '';
  end;
  case select_menu_item of
    0: begin
        if FIndex0MaxCount = 0 then
          Exit;
        maxcount := FIndex0MaxCount;
      end;
    1: begin
        if FIndex1MaxCount = 0 then
          Exit;
        maxcount := FIndex1MaxCount;
      end;
    2: begin
        if FIndex2MaxCount = 0 then
          Exit;
        maxcount := FIndex2MaxCount;
      end;
    3: begin
        if FIndex3MaxCount = 0 then
          Exit;
        maxcount := FIndex3MaxCount;
      end;
    4: begin
        if FIndex4MaxCount = 0 then
          Exit;
        maxcount := FIndex4MaxCount;
      end;
    5: begin
        if FIndex5MaxCount = 0 then
          Exit;
        maxcount := FIndex5MaxCount;
      end;
  end;

  totalpage := Round((maxcount / 12) + 0.49999);
  if FPage > totalpage then
    FPage := totalpage;

  if FPage <= 0 then FPage := 1;
  j := 0;
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    if pp.index = select_menu_item then
    begin
      if (j < pagecount * FPage) and (j >= pagecount * (FPage - 1)) then
      begin
        pp.id := j;
        if j >= 12 then
        begin
          FItemNameArr[j - 12 * (FPage - 1)].Caption := format('%s(%d个)', [pp.name, pp.num]);
    // FItemPriceArr[i].Visible:=True;
          FItemPriceArr[j - 12 * (FPage - 1)].Caption := '价格:' + inttostr(pp.price);
          setitemshpe(itemArr[j - 12 * (FPage - 1)], pp^);
        end else
        begin
          FItemNameArr[j].Caption := format('%s(%d个)', [pp.name, pp.num]);
    // FItemPriceArr[i].Visible:=True;
          FItemPriceArr[j].Caption := '价格:' + inttostr(pp.price);
          setitemshpe(itemArr[j], pp^);
        end;

      end;
      inc(j);
    end;

  end;




  A2Label_PageInfo.Caption := IntToStr(FPage) + '/' + inttostr(totalpage);
  Panel_buy_ok.Visible := false;
 // Panel_itemList.Visible := not Panel_buy_ok.Visible;
//  A2ListBox_itemText.Clear;
end;

procedure TfrmEmporia.addlog(atext: string);
begin
  FrmBottom.AddChat(atext, WinRGB(22, 22, 0), 0);
  //A2ListBox_result.AddItem(inttostr(A2ListBox_result.Count) + atext);
end;

procedure TfrmEmporia.MessageProcess(var code: TWordComData);
var
  i, i1, n, akey, money: integer;
  PSSShowSpecialWindow: PTSShowSpecialWindow;
  aitem: TEmporiadata;
begin
  i := 0;
  akey := WordComData_GETbyte(Code, i);
  case akey of
    SM_money:
      begin
        n := WordComData_GETdword(Code, i);
        A2ILabel_money.Caption := inttostr(n);

      end;
    SM_SHOWSPECIALWINDOW:
      begin
        PSSShowSpecialWindow := @code.data;
        case PSSShowSpecialWindow.rWindow of
          WINDOW_Close_All: Visible := false;

          WINDOW_Emporia:
            begin
              FrmM.move_win_form_Align(Self, mwfCenterLeft);
              FrmM.SetA2Form(Self, A2form);
              Panel_buy_ok.Visible := false;
              select_menu_item := 0;
              A2Button1Click(A2Button1);
              //itempaint;
            //  A2ListBox_result.Clear;
              Visible := true;
              Timer1Timer(nil);
            end;
        end;
      end;
    SM_Emporia:
      begin
        n := WordComData_GETbyte(Code, i);
        case n of
          Emporia_GetItemList:
            begin
              FIndex0MaxCount := 0;
              FIndex1MaxCount := 0;
              FIndex2MaxCount := 0;
              FIndex3MaxCount := 0;
              FIndex4MaxCount := 0;
              FIndex5MaxCount := 0;
              CLEAR;
              n := WordComData_GETword(Code, i);
              for I1 := 0 to n - 1 do
              begin
                aitem.index := WordComData_getbyte(Code, i);
                case aitem.index of
                  0: begin
                      inc(FIndex0MaxCount);
                    end;
                  1: begin
                      inc(FIndex1MaxCount);
                    end;
                  2: begin
                      inc(FIndex2MaxCount);
                    end;
                  3: begin
                      inc(FIndex3MaxCount);
                    end;
                  4: begin
                      inc(FIndex4MaxCount);
                    end;
                  5: begin
                      inc(FIndex5MaxCount);
                    end;
                end;
                aitem.name := WordComData_getString(Code, i);
                aitem.Text := WordComData_getString(Code, i);
                aitem.num := WordComData_getdword(Code, i);
                aitem.price := WordComData_getdword(Code, i);
                aitem.rColor := WordComData_getword(Code, i);
                aitem.rShape := WordComData_getword(Code, i);
                aitem.SmithingLevel := WordComData_getword(Code, i);

                add(aitem);
              end;
              select_menu_item := 0;
              A2Button1Click(A2Button1);
             // itempaint;
            end;

          Emporia_BUY:
            begin
              n := WordComData_GETbyte(Code, i);
              case n of
                1: addlog('数量超出范围');
                2: addlog('名字空');
                3: addlog('商城没有物品');
                4: addlog('物品不存在');
                5: addlog('物品数量限制1个');
                6: addlog('元宝不够');
                7: addlog('背包没空位置');
                8: addlog('发放物品失败');
                100: addlog('购买成功');
              end;

            end;

//          Emporia_getmoney: //2015.11.16 在水一方
//            begin
//              n := WordComData_GETbyte(Code, i);
//              case n of
//                0: begin
//                    money := WordComData_GETdword(Code, i);
//                    A2ILabel_money.Caption := inttostr(money);
//                  end;
//              end;
//            end;
        end;

      end;

  end;

end;

function TfrmEmporia.get(aname: string): pTEmporiadata;
begin
  result := FindexName.Select(aname);
end;

function TfrmEmporia.getid(aid: integer): pTEmporiadata;
var
  i: integer;
  pp: pTEmporiadata;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    if pp.index = select_menu_item then
    begin
      if pp.id = aid then
      begin
        result := pp;
        exit;
      end;
    end;

  end;

end;

procedure TfrmEmporia.add(var aitem: TEmporiadata);
var
  pp: pTEmporiadata;
begin

  pp := get(aitem.name);
  if pp <> nil then exit;
  pp := nil;
  New(pp);
  pp^ := aitem;
  fdata.Add(pp);
  FindexName.Insert(pp.name, pp);
end;

procedure TfrmEmporia.CLEAR();
var
  I: INTEGER;
  PP: pTEmporiadata;
begin
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];
    dispose(pp);
  end;
  Fdata.Clear;
  FindexName.Clear;

end;

procedure TfrmEmporia.SetNewVersion;
begin
  inherited;
end;

//procedure TfrmEmporia.SetOldVersion;
//var
//  outimg: TA2Image;
//begin
//
//end;

procedure TfrmEmporia.FormCreate(Sender: TObject);
var
  i: integer;
begin
  inherited;
  FPage := 0;
  FIndex0MaxCount := 0;
  FIndex1MaxCount := 0;
  FIndex2MaxCount := 0;
  FIndex3MaxCount := 0;
  FIndex4MaxCount := 0;
  FIndex5MaxCount := 0;
  FTestPos := True;
  FrmM.AddA2Form(Self, A2Form);

  fdata := tlist.Create;
  FindexName := TStringKeyClass.Create;
  FA2ImageitemBack := TA2Image.Create(32, 32, 0, 0);
  FA2ImageitemBack.Name := 'A2ImageItemBack';
  EmporiaFrmQuantity := TFrmQuantity.Create(Self); //2015.11.10 在水一方 >>>>>>
  with EmporiaFrmQuantity do begin
    ShowType := SH_Emporia;
    Name := 'EmporiaFrmQuantity';
    A2Form.FImageSurface.Name := 'EmporiaFImageSurface';
  end; //<<<<<<

  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;

  FButtonArr[0] := A2Button1;
  FButtonArr[1] := A2Button2;
  FButtonArr[2] := A2Button3;
  FButtonArr[3] := A2Button4;
  FButtonArr[4] := A2Button5;
  FButtonArr[5] := A2Button6;

//  itemArr[12] := A2ILabel25;
//  FkuangitemArr[12] := A2ILabeL26;
//
//  itemArr[13] := A2ILabel27;
//  FkuangitemArr[13] := A2ILabeL28;
//
//  itemArr[14] := A2ILabel29;
//  FkuangitemArr[14] := A2ILabel30;
//
//  itemArr[15] := A2ILabel31;
//  FkuangitemArr[15] := A2ILabel32;
//
//  itemArr[16] := A2ILabel33;
//  FkuangitemArr[16] := A2ILabel34;
//
//  itemArr[17] := A2ILabel35;
//  FkuangitemArr[17] := A2ILabel36;


//  for i := 0 to HIGH(FkuangitemArr) do
//  begin
//    FkuangitemArr[i].A2Image := Fkuangimg;
//  end;
end;

procedure TfrmEmporia.FormDestroy(Sender: TObject);
begin
  inherited; // 内存泄漏007 在水一方 2015.05.18

  fOKimg.Free;
  Fkuangimg.Free;
  fbackimg.Free;
  CLEAR;
  FindexName.Free;
  fdata.Free;
  EmporiaFrmQuantity.Free;
end;

procedure TfrmEmporia.A2ILabel1Click(Sender: TObject);
var
  pp: pTEmporiadata;
  i: Integer;
begin
//  for I := Low(FItemNameArr) to High(FItemNameArr) do
//  begin
//    FItemNameArr[i].Caption := '';
//  end;
//  for I := Low(FItemPriceArr) to High(FItemPriceArr) do
//  begin
//    FItemPriceArr[i].Caption := '';
//  end;
    //
  //ShowMessage(IntToStr(FPage));
  //pp := getid(tA2ILabel(sender).Tag);
  //if pp = nil then exit;
  i := tA2ILabel(sender).Tag;
  pp := getid(i + 12 * (FPage - 1));
  if pp = nil then
  begin
    A2Label_select_name.Caption := '';
    exit;
  end;

  FSelectItemTag := i;
  itempaint;
    //FItemNameArr[i].Visible:=True;
 // FItemNameArr[i].Caption := pp.name;
    // FItemPriceArr[i].Visible:=True;
 // FItemPriceArr[i].Caption := '价格:' + inttostr(pp.price);

//  setitemshpe(A2ILabel_select_item, pp^);
//  A2Label_select_name.Left := TA2ILabel(Sender).Left;
//  A2Label_select_name.top := TA2ILabel(Sender).top;
//  A2Label_select_name.Width := TA2ILabel(Sender).Width;
//  A2Label_select_name.Height := TA2ILabel(Sender).Height;
  A2Label_select_name.Caption := pp.name;

    //A2Label_num.Caption := inttostr(pp.num);
  A2Label_price.Caption := inttostr(pp.price);
  A2Edit_select_num.Text := '1';
//  Panel_buy_ok.Left := 19;
//  Panel_buy_ok.Top := 82;
//  Panel_buy_ok.Visible := true;
//  Panel_itemList.Visible := not Panel_buy_ok.Visible;
end;

procedure TfrmEmporia.sendshowForm();
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Emporia);
  WordComData_ADDbyte(temp, Emporia_showForm);

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmEmporia.sendBuy(aitemname: string; acount: integer);
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Emporia);
  WordComData_ADDbyte(temp, Emporia_BUY);
  WordComData_ADDstring(temp, aitemname);
  WordComData_ADDdword(temp, acount);

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmEmporia.A2Button_BUYClick(Sender: TObject);
var
  pp: pTEmporiadata;
  acount: integer;
begin
  pp := get(A2Label_select_name.Caption);
  if pp = nil then
  begin
    FrmBottom.AddChat('请选择要购买的道具!', WinRGB(22, 22, 0), 0);
    Exit;
  end;
  FrmM.SetA2Form(EmporiaFrmQuantity, EmporiaFrmQuantity.A2form); //2015.11.10 在水一方  >>>>>>
  EmporiaFrmQuantity.CountCur := 1;
  EmporiaFrmQuantity.CountMax := 1000;
  EmporiaFrmQuantity.CountName := pp.name;
  EmporiaFrmQuantity.LbCountName.Caption := format('%s(%d个)', [pp.name, pp.num]);
  EmporiaFrmQuantity.EdCount.Text := inttostr(EmporiaFrmQuantity.CountCur);
  EmporiaFrmQuantity.lbTotalMoney.Caption := IntToStr(pp.price);
  EmporiaFrmQuantity.price := pp.price;
  setitemshpe(EmporiaFrmQuantity.aItem, pp^);
  EmporiaFrmQuantity.Visible := true;
  Self.Enabled := False;
//  Panel_buy_ok.Left := 19;
//  Panel_buy_ok.Top := 82;
//  Panel_buy_ok.Visible := true;

//  acount := _strtoint(A2Edit_select_num.Text);
//  if (acount > 0) and (acount <= 1000) then
//  begin
//    sendBuy(pp.name, acount);
//    itempaint;
//  end;

end;

procedure TfrmEmporia.A2Button_closeClick(Sender: TObject);
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Emporia);
  WordComData_ADDbyte(temp, Emporia_Windows_close);

  if Frmfbl.SocketAddData(temp.Size, @temp.data) then
    Visible := false;
end;

procedure TfrmEmporia.A2Button1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := Low(fbuttonarr) to High(fbuttonarr) do
  begin
    fbuttonarr[i].Enabled := True;
  end;

  select_menu_item := tA2Button(sender).Tag;
  if fbuttonarr[select_menu_item].Enabled then
    fbuttonarr[select_menu_item].Enabled := False;
  itempaint;
  //点击下第一个道具
  A2ILabel1Click(A2ILabel1);
end;

procedure TfrmEmporia.A2Button_BUYcloseClick(Sender: TObject);
begin
  Panel_buy_ok.Visible := false;
  Panel_itemList.Visible := not Panel_buy_ok.Visible;
end;

procedure TfrmEmporia.A2ILabel1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  pp: pTEmporiadata;
  s, str, s2: string;
  i: Integer;

begin


  pp := getid(tA2ILabel(sender).Tag);
  if pp = nil then exit;
  i := tA2ILabel(sender).Tag;
  pp := getid(i + 12 * (FPage - 1));
  if pp = nil then exit;
  //GameHint.settext(-1, pp.text);

  str := pp.name;
  if pp.SmithingLevel > 0 then
    str := str + '(强化' + inttostr(pp.SmithingLevel) + '级)';
  str := str + '^数量: ' + inttostr(pp.num) + '^价格: ' + inttostr(pp.price) + '^' + pp.text;
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
  GameHint.settext(-1, s2);
    //
 // A2ListBox_itemText.Clear;

 // A2ListBox_itemText.AddItem('' + pp.name);
 // A2ListBox_itemText.AddItem('一组:' + inttostr(pp.num));
 // A2ListBox_itemText.AddItem('价格:' + inttostr(pp.price));
//  str := '' + pp.text;
//  while str <> '' do
//  begin
//    S := CutLengthString(str, A2ListBox_itemText.Width);
//    A2ListBox_itemText.AddItem(s);
//  end;

    { s2 := '';
     s2 := s2 + '<$00007CF9>名字:' + pp.name + #13#10;
     s2 := s2 + '<$00007CF9>一组:' + inttostr(pp.num) + #13#10;
     s2 := s2 + '<$00007CF9>价格:' + inttostr(pp.price) + #13#10;
     s2 := s2 + '<$00007CF9>描述:' + pp.text;
     A2Form.FA2Hint.Ftype := hstTransparent;
     A2Form.FA2Hint.setText(s2);}
end;

procedure TfrmEmporia.A2Edit_select_numChange(Sender: TObject);
var
  str, str2: string;
  i: integer;
begin
  str2 := '';
  str := A2Edit_select_num.Text;
  for i := 1 to length(str) do
  begin
    case str[i] of
      '0'..'9': str2 := str2 + str[i];
    end;

  end;
  A2Edit_select_num.Text := str2;
  A2Edit_select_num.SelStart := length(A2Edit_select_num.Text);

end;

procedure TfrmEmporia.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(Self, x, y);
  FrmM.SetA2Form(Self, A2Form);
end;

procedure TfrmEmporia.A2Button7Click(Sender: TObject);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Emporia);
  WordComData_ADDbyte(temp, Emporia_money); //     CharCenterName
  WordComData_ADDstring(temp, CharCenterName);
  WordComData_ADDstring(temp, A2Edit1.Text);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;


procedure TfrmEmporia.A2Button8Click(Sender: TObject);
var
  ClientIni: TIniFile;
  czk: string;
begin
  ShellExecute(Handle, 'open', 'http://account.m1000y.com/pay/',
    nil, nil, SW_SHOW);

//  ClientIni := TIniFile.Create('.\ClientIni.ini');
//  try
//    czk := Trim(ClientIni.ReadString('FBL', 'czk', ''))
//  finally
//    ClientIni.Free;
//  end;
//  ShellExecute(Application.Handle, nil, PChar(czk), nil, nil, SW_SHOWNORMAL);
//

end;

procedure TfrmEmporia.SetConfigFileName;
begin
  FConfigFileName := 'Emporia.xml';

end;

//procedure TfrmEmporia.SetNewVersionOld;
//var
//  outimg, tempUp, tempDown: TA2Image;
//  i: integer;
//begin
////
////  Fkuangimg := TA2Image.Create(32, 32, 0, 0);
////  pgkBmp.getBmp('在线商城_道具底框.bmp', Fkuangimg);
////
////  fOKimg := TA2Image.Create(32, 32, 0, 0);
////  pgkBmp.getBmp('在线商城_确认购买.bmp', fOKimg);
////  A2ILabel37.A2Image := fOKimg;
////
//// // A2ILabel_buy_kuang.A2Image := Fkuangimg;
////  fbackimg := TA2Image.Create(32, 32, 0, 0);
////  pgkBmp_n.getBmp('在线商城窗口.bmp', fbackimg);
////  //A2ILabel_BACK.A2Image := fbackimg;
////  Width := fbackimg.Width;
////  Height := fbackimg.Height;
////
////  outimg := TA2Image.Create(32, 32, 0, 0);
////  tempUp := TA2Image.Create(32, 32, 0, 0);
////  tempDown := TA2Image.Create(32, 32, 0, 0);
////  try
////    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
//// //   A2ListBox_itemText.SetScrollTopImage(tempUp, tempDown);
////    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
////   // A2ListBox_itemText.SetScrollTrackImage(tempUp, tempDown);
////    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
////  //  A2ListBox_itemText.SetScrollBottomImage(tempUp, tempDown);
////    pgkBmp.getBmp('在线商城_下拉条底框A.bmp', outimg);
////    A2ListBox_itemText.SetScrollBackImage(outimg);
////    A2ListBox_itemText.FontColor := ColorSysToDxColor($00FFFF00);
////    A2ListBox_itemText.FontSelColor := ColorSysToDxColor($00FFFF00);
////    A2ListBox_itemText.Left := 272;
////    A2ListBox_itemText.Top := 84;
////    A2ListBox_itemText.Width := 138;
////    A2ListBox_itemText.Height := 73;
////
////    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
////    A2ListBox_result.SetScrollTopImage(tempUp, tempDown);
////    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
////    A2ListBox_result.SetScrollTrackImage(tempUp, tempDown);
////    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
////    A2ListBox_result.SetScrollBottomImage(tempUp, tempDown);
////    pgkBmp.getBmp('在线商城_下拉条底框B.bmp', outimg);
////    A2ListBox_result.SetScrollBackImage(outimg);
////    A2ListBox_result.FFontSelBACKColor := ColorSysToDxColor($00FFF000);
////    A2ListBox_result.FontColor := ColorSysToDxColor($00FF00FF);
////    A2ListBox_result.Left := 272;
////    A2ListBox_result.Top := 169;
////    A2ListBox_result.Width := 138;
////    A2ListBox_result.Height := 74;
////
////    pgkBmp.getBmp('在线商城_道具_弹起.bmp', outimg);
////    A2Button1.A2Up := outimg;
////    pgkBmp.getBmp('在线商城_道具_按下.bmp', outimg);
////    A2Button1.A2Down := outimg;
////    pgkBmp.getBmp('在线商城_道具_鼠标.bmp', outimg);
////    A2Button1.A2Mouse := outimg;
////    pgkBmp.getBmp('在线商城_道具_禁止.bmp', outimg);
////    A2Button1.A2NotEnabled := outimg;
////    A2Button1.Left := 17;
////    A2Button1.Top := 58;
////
////    pgkBmp.getBmp('在线商城_药品_弹起.bmp', outimg);
////    A2Button2.A2Up := outimg;
////    pgkBmp.getBmp('在线商城_药品_按下.bmp', outimg);
////    A2Button2.A2Down := outimg;
////    pgkBmp.getBmp('在线商城_药品_鼠标.bmp', outimg);
////    A2Button2.A2Mouse := outimg;
////    pgkBmp.getBmp('在线商城_药品_禁止.bmp', outimg);
////    A2Button2.A2NotEnabled := outimg;
////    A2Button2.Left := 73;
////    A2Button2.Top := 58;
////
////    pgkBmp.getBmp('在线商城_时装_弹起.bmp', outimg);
////    A2Button3.A2Up := outimg;
////    pgkBmp.getBmp('在线商城_时装_按下.bmp', outimg);
////    A2Button3.A2Down := outimg;
////    pgkBmp.getBmp('在线商城_时装_鼠标.bmp', outimg);
////    A2Button3.A2Mouse := outimg;
////    pgkBmp.getBmp('在线商城_时装_禁止.bmp', outimg);
////    A2Button3.A2NotEnabled := outimg;
////    A2Button3.Left := 129;
////    A2Button3.Top := 58;
////
////    pgkBmp.getBmp('在线商城_辅助_弹起.bmp', outimg);
////    A2Button4.A2Up := outimg;
////    pgkBmp.getBmp('在线商城_辅助_按下.bmp', outimg);
////    A2Button4.A2Down := outimg;
////    pgkBmp.getBmp('在线商城_辅助_鼠标.bmp', outimg);
////    A2Button4.A2Mouse := outimg;
////    pgkBmp.getBmp('在线商城_辅助_禁止.bmp', outimg);
////    A2Button4.A2NotEnabled := outimg;
////    A2Button4.Left := 185;
////    A2Button4.Top := 58;
////
////    pgkBmp.getBmp('在线商城_其他_弹起.bmp', outimg);
////    A2Button5.A2Up := outimg;
////    pgkBmp.getBmp('在线商城_其他_按下.bmp', outimg);
////    A2Button5.A2Down := outimg;
////    pgkBmp.getBmp('在线商城_其他_鼠标.bmp', outimg);
////    A2Button5.A2Mouse := outimg;
////    pgkBmp.getBmp('在线商城_其他_禁止.bmp', outimg);
////    A2Button5.A2NotEnabled := outimg;
////    A2Button5.Left := 241;
////    A2Button5.Top := 58;
////
////    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', outimg);
////    A2Button_close.A2Up := outimg;
////    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', outimg);
////    A2Button_close.A2Down := outimg;
////    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', outimg);
////    A2Button_close.A2Mouse := outimg;
////    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', outimg);
////     //   A2Button_close.A2NotEnabled := outimg;
////    A2Button_close.Left := 390;
////    A2Button_close.Top := 20;
////
////    A2ILabel37.Left := A2ILabel37.Left + 0;
////    A2ILabel37.Top := A2ILabel37.Top + 2;
////
////    pgkBmp.getBmp('通用_取消_弹起.bmp', outimg);
////    A2Button_BUYclose.A2Up := outimg;
////    pgkBmp.getBmp('通用_取消_按下.bmp', outimg);
////    A2Button_BUYclose.A2Down := outimg;
////    pgkBmp.getBmp('通用_取消_鼠标.bmp', outimg);
////    A2Button_BUYclose.A2Mouse := outimg;
////    pgkBmp.getBmp('通用_取消_禁止.bmp', outimg);
////    A2Button_BUYclose.A2NotEnabled := outimg;
////
////    pgkBmp.getBmp('通用_确认_弹起.bmp', outimg);
////    A2Button_BUY.A2Up := outimg;
////    pgkBmp.getBmp('通用_确认_按下.bmp', outimg);
////    A2Button_BUY.A2Down := outimg;
////    pgkBmp.getBmp('通用_确认_鼠标.bmp', outimg);
////    A2Button_BUY.A2Mouse := outimg;
////    pgkBmp.getBmp('通用_确认_禁止.bmp', outimg);
////    A2Button_BUY.A2NotEnabled := outimg;
////        ////////////////////////////////////////////
////    pgkBmp_n.getBmp('充值码弹起.bmp', outimg);
////    A2Button7.A2Up := outimg;
////    pgkBmp_n.getBmp('充值码鼠标.bmp', outimg);
////    A2Button7.A2Down := outimg;
////    A2Button7.A2NotEnabled := outimg;
////
////    pgkBmp_n.getBmp('在线充值_商城_弹起.bmp', outimg);
////    A2Button8.A2Up := outimg;
////    pgkBmp_n.getBmp('在线充值_商城_鼠标.bmp', outimg);
////    A2Button8.A2Down := outimg;
////    A2Button8.A2NotEnabled := outimg;
////
////    A2Button6.Visible := false;
////  finally
////    outimg.Free;
////    tempUp.Free;
////    tempDown.Free;
////  end;
//
//end;

procedure TfrmEmporia.SetNewVersionTest;
var
  i: Integer;
  pp: pTEmporiadata;
begin
  inherited;
  SetControlPos(Self);

  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(A2Button1);
  SetControlPos(A2Button2);
  SetControlPos(A2Button3);
  SetControlPos(A2Button4);
  SetControlPos(A2Button5);
  SetControlPos(A2Button_close);
  SetControlPos(A2Button_BUY);
  SetControlPos(A2Button7);
  SetControlPos(A2Button8);
  SetControlPos(A2Button6);
  SetControlPos(A2ILabel_money);
  SetControlPos(Panel_itemList);
  SetA2ImgPos(FA2ImageitemBack);


  itemArr[0] := A2ILabel1;


  itemArr[1] := A2ILabel2;


  itemArr[2] := A2ILabel3;


  itemArr[3] := A2ILabel4;


  itemArr[4] := A2ILabel5;


  itemArr[5] := A2ILabel6;


  itemArr[6] := A2ILabel7;


  itemArr[7] := A2ILabel8;


  itemArr[8] := A2ILabel9;

  itemArr[9] := A2ILabel10;


  itemArr[10] := A2ILabel11;


  itemArr[11] := A2ILabel12;

//  itemArr[12] := A2ILabel25;
//  FkuangitemArr[12] := A2ILabeL26;
//
//  itemArr[13] := A2ILabel27;
//  FkuangitemArr[13] := A2ILabeL28;
//
//  itemArr[14] := A2ILabel29;
//  FkuangitemArr[14] := A2ILabel30;
//
//  itemArr[15] := A2ILabel31;
//  FkuangitemArr[15] := A2ILabel32;
//
//  itemArr[16] := A2ILabel33;
//  FkuangitemArr[16] := A2ILabel34;
//
//  itemArr[17] := A2ILabel35;
 // FkuangitemArr[17] := A2ILabel36;
  for i := 0 to length(itemArr) - 1 do
  begin
    self.SetControlPos(itemArr[i]);

  end;

  for i := 0 to HIGH(itemArr) do
  begin
    itemArr[i].Tag := i;
    itemArr[i].Transparent := true;
  end;

//  for i := 0 to length(FkuangitemArr) - 1 do
//  begin
//   // self.SetControlPos(FkuangitemArr[i]);
//    FkuangitemArr[i].Visible := false;
//  end;
  FItemNameArr[0] := NameA2Label1;
  FItemNameArr[1] := NameA2Label2;
  FItemNameArr[2] := NameA2Label3;
  FItemNameArr[3] := NameA2Label4;
  FItemNameArr[4] := NameA2Label5;
  FItemNameArr[5] := NameA2Label6;
  FItemNameArr[6] := NameA2Label7;
  FItemNameArr[7] := NameA2Label8;
  FItemNameArr[8] := NameA2Label9;
  FItemNameArr[9] := NameA2Label10;
  FItemNameArr[10] := NameA2Label11;
  FItemNameArr[11] := NameA2Label12;

  FItemPriceArr[0] := A2Label1;
  FItemPriceArr[1] := A2Label2;
  FItemPriceArr[2] := A2Label3;
  FItemPriceArr[3] := A2Label4;
  FItemPriceArr[4] := A2Label5;
  FItemPriceArr[5] := A2Label6;
  FItemPriceArr[6] := A2Label7;
  FItemPriceArr[7] := A2Label8;
  FItemPriceArr[8] := A2Label9;
  FItemPriceArr[9] := A2Label10;
  FItemPriceArr[10] := A2Label11;
  FItemPriceArr[11] := A2Label12;


  for I := Low(FItemNameArr) to High(FItemNameArr) do
  begin
    //FItemNameArr[i].Caption := '';
    self.SetControlPos(FItemNameArr[i]);
  end;
  for I := Low(FItemPriceArr) to High(FItemPriceArr) do
  begin
    //FItemPriceArr[i].Caption := '';
    self.SetControlPos(FItemPriceArr[i]);
  end;
  SetControlPos(A2Button_Pre);
  SetControlPos(A2Button_Next);
  SetControlPos(A2Label_PageInfo);  
  SetControlPos(A2Label_Get);
  A2Label_Get.FontColor := ColorSysToDxColor(clLime);

  //确认购买窗口
  fOKimg := TA2Image.Create(32, 32, 0, 0);
  fOKimg.Name := 'fOKimg';
  SetA2ImgPos(fOKimg);
  A2ILabel37.A2Image := fOKimg;
  SetControlPos(A2ILabel37);

  SetControlPos(Panel_buy_ok);
  SetControlPos(A2Button_BUYclose);
  SetControlPos(A2Button_BUY);
  SetControlPos(A2Button_BUYOK);
  SetControlPos(A2Edit1);
  self.SetControlPos(A2Edit_select_num);
  self.SetControlPos(A2ILabel_select_item);
  self.SetControlPos(A2Label_select_name);
  self.SetControlPos(A2Label_price);
  Panel_buy_ok.Visible := false;

end;

procedure TfrmEmporia.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TfrmEmporia.A2Button_PreClick(Sender: TObject);
begin
  inherited;
  Dec(FPage);
  itempaint;
  //点击下第一个道具
  A2ILabel1Click(A2ILabel1);
end;

procedure TfrmEmporia.A2Button_NextClick(Sender: TObject);
begin
  inherited;
  inc(FPage);
  itempaint;
  //点击下第一个道具
  A2ILabel1Click(A2ILabel1);
end;

procedure TfrmEmporia.A2ILabel1MouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

procedure TfrmEmporia.SetItemLabel(Lb: TA2ILabel; aname: string;
  acolor: byte; shape, shapeRdown, shapeLUP: word);
var
  gc, ga: integer;

  new, tmp: TA2Image;
begin
    //savekeyImagelib[idx]
  Lb.Caption := aname;
  Lb.Font.Color := clRed; //添加上颜色 20130720
    //lb.Font.Size:=1;
  GetGreenColorAndAdd(acolor, gc, ga);

  Lb.GreenCol := gc;
  Lb.GreenAdd := ga;
    // Lb.BColor := Color;
  if shape = 0 then
  begin
    Lb.A2Image := nil;
    Lb.A2ImageRDown := nil;
        // Lb.A2ImageLUP := nil;
    exit;
  end
  else
  begin
    lb.Visible := true;
    tmp := AtzClass.GetItemImage(shape);

    if tmp <> nil then
    begin
      try
        new := TA2Image.Create(lb.Width, lb.Height, 0, 0);

          //FA2ImageitemBack.SaveToFile('背景.BMP');
        if gc = 0 then //2015.04.30 在水一方 >>>>>>
        begin
          new.DrawImage(FA2ImageitemBack, (new.Width - FA2ImageitemBack.Width) div 2, (new.Height - FA2ImageitemBack.Height) div 2, true);
                           // (Lb.Width - tmp.Width) div 2, (Lb.Height - tmp.Height) div 2
          new.DrawImage(tmp, (Lb.Width - tmp.Width) div 2, (Lb.Height - tmp.Height) div 2, true);
        end
        else
        begin
          new.DrawImageGreenConvert(FA2ImageitemBack, (new.Width - FA2ImageitemBack.Width) div 2, (new.Height - FA2ImageitemBack.Height) div 2, gc, ga);
          new.DrawImageGreenConvert(tmp, (Lb.Width - tmp.Width) div 2, (Lb.Height - tmp.Height) div 2, gc, ga);
        end;
          //new.SaveToFile('ttt.bmp');
        Lb.A2Image := new;
      finally

        new.Free;
      end;
    end;


    if shapeRdown = 0 then Lb.A2ImageRDown := nil
    else
      Lb.A2ImageRDown := savekeyImagelib[shapeRdown];
        { if shapeLUP = 0 then Lb.A2ImageLUP := nil
         else
             Lb.A2ImageLUP := savekeyImagelib[shapeLUP];
             }
  end;

end;

procedure TfrmEmporia.A2ILabel1DbClick(Sender: TObject);
var
  i: integer;
  pp: pTEmporiadata;
begin
  inherited;
  i := TA2ILabel(sender).Tag;
  pp := getid(i + 12 * (FPage - 1));
  if pp = nil then
  begin
    exit;
  end;

  FSelectItemTag := i;
  itempaint;

  FrmM.SetA2Form(EmporiaFrmQuantity, EmporiaFrmQuantity.A2form); //2015.11.10 在水一方  >>>>>>
  EmporiaFrmQuantity.CountCur := 1;
  EmporiaFrmQuantity.CountMax := 1000;
  EmporiaFrmQuantity.CountName := pp.name;
  EmporiaFrmQuantity.LbCountName.Caption := format('%s(%d个)', [pp.name, pp.num]);
  EmporiaFrmQuantity.EdCount.Text := inttostr(EmporiaFrmQuantity.CountCur);
  EmporiaFrmQuantity.lbTotalMoney.Caption := IntToStr(pp.price);
  EmporiaFrmQuantity.price := pp.price;
  setitemshpe(EmporiaFrmQuantity.aItem, pp^);
  EmporiaFrmQuantity.Visible := true;
  Self.Enabled := False;
end;

procedure TfrmEmporia.Timer1Timer(Sender: TObject); //2015.11.16 在水一方
var
  temp: TWordComData;
begin
  inherited;
  if not Visible then Exit;
//  temp.Size := 0;
//  WordComData_ADDbyte(temp, CM_Emporia);
//  WordComData_ADDbyte(temp, Emporia_getmoney);
//  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmEmporia.A2Label_GetMouseLeave(Sender: TObject);
begin
  inherited;
  A2Label_Get.FontColor := ColorSysToDxColor(clLime);
end;

procedure TfrmEmporia.A2Label_GetMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;     
  A2Label_Get.FontColor := ColorSysToDxColor(clAqua);

end;

procedure TfrmEmporia.A2Label_GetClick(Sender: TObject);   
var
  temp: TWordComData;
begin
  inherited;
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Emporia);
  WordComData_ADDbyte(temp, Emporia_GET);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

end.

