unit FItemHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Deftype, A2Img, AUtil32,
  A2Form, ExtCtrls, BaseUIForm, uAnsTick, CharCls, StrUtils;
type
  TfrmItemHelp = class(TfrmBaseUI)
    A2Form: TA2Form;
    btnClose: TA2Button;
    imgItem: TA2ILabel;
    listContent: TA2ListBox;

    lbItemName: TA2Label;
    lbGrade: TA2Label;
    btnReserved: TA2Button;
    A2Label1: TA2Label;
    btnLock: TA2Button;
    lbItemDel: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLockClick(Sender: TObject);
    procedure btnReservedClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure listContentDblClick(Sender: TObject);
    procedure lbItemDelClick(Sender: TObject);

  private
    FNEWitemTA2Image: TA2Image;
   // procedure SetOldVersion;
        { Private declarations }
  public

    cmdlist: tstringlist;
        { Public declarations }

    procedure MessageProcess(var code: TWordComData);
    procedure showSAY(str: string);
    procedure ShowProItem(aitemkey: integer);


    procedure SetNewVersion(); override;


    //procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure SetItemLabel(aname: string; acolor: byte; shape: word);
  end;

var
  frmItemHelp: TfrmItemHelp;
  frmItemHelpitemPro: TSitemPro;
  frmItemHelpitemPro_KEY: INTEGER;
  lbItemDelStr: string;
    //AtzClass.GetItemImage
implementation

uses FNPCTrade, FMain, FConfirmDialog, AtzCls, FAttrib, FQuantity, Fbl, cltype, FDepository, filepgkclass,
  FBottom;

{$R *.DFM}

function GetItemDataInfo(var aItemData: TItemData): string;
var
  str, astr: string;

  function _get(acolor: string; var rLifeData: TLifeData): string;
  begin
    result := '';
    if rLifeData.AttackSpeed <> 0 then
      result := result + acolor + format('    速度: %d', [-rLifeData.AttackSpeed]) + '^';
    if rLifeData.recovery <> 0 then
      result := result + acolor + format('    恢复: %d', [-rLifeData.recovery]) + '^';

    if rLifeData.accuracy <> 0 then
      result := result + acolor + format('    命中: %d', [rLifeData.accuracy]) + '^';
    if rLifeData.avoid <> 0 then
      result := result + acolor + format('    躲闪: %d', [rLifeData.avoid]) + '^';

    if rLifeData.HitArmor <> 0 then
      result := result + acolor + format('    维持: %d', [rLifeData.HitArmor]) + '^';

    if (rLifeData.damageBody <> 0) or (rLifeData.damageHead <> 0) or (rLifeData.damageArm <> 0) or (rLifeData.damageLeg <> 0) then
      result := result + acolor + format('    攻击: %d/%d/%d/%d', [rLifeData.damageBody, rLifeData.damageHead, rLifeData.damageArm, rLifeData.damageLeg]) + '^';

    if (rLifeData.armorBody <> 0) or (rLifeData.armorHead <> 0) or (rLifeData.armorArm <> 0) or (rLifeData.armorLeg <> 0) then
      result := result + acolor + format('    防御: %d/%d/%d/%d', [rLifeData.armorBody, rLifeData.armorHead, rLifeData.armorArm, rLifeData.armorLeg]) + '^';

  end;

begin
  Result := '';
    // if aItemData.rName = '' then exit;
     //名字
  case aItemData.rStarLevel of
    1:
      aItemData.rNameColor := clGreen;
    2:
      aItemData.rNameColor := clYellow;
    3:
      aItemData.rNameColor := clRed;
  end;
  if aItemData.rNameColor > 0 then
    result := result + '『' + inttostr(aItemData.rNameColor) + '|' + aItemData.rViewName + '』'
  else
    Result := Result + (aItemData.rViewName); ;

  if aItemData.rSetting.rsettingcount > 0 then
    result := result + format('(%d孔)', [aItemData.rSetting.rsettingcount]);
  if aItemData.rSmithingLevel > 0 then
    result := result + format(' %d级', [aItemData.rSmithingLevel]); //format('<$0023A4FA>+%d', [rSmithingLevel]);
  result := result + '^';

    //制造人
  if aItemData.rcreatename <> '' then
    result := result + '〖' + aItemData.rcreatename + '〗制造' + '^';
    //描述
  str := cItemTextClass.getText(aItemData.rName);
  if str <> '' then
  begin
    str := StringReplace(str, #13#10 + '{2} ' + #13#10, '^', [rfReplaceAll]);
    Result := Result + str + '^';
  end;
    //持久
  if aItemData.rDurability <> 0 then
    Result := Result + format('持久: %d/%d', [aItemData.rCurDurability, aItemData.rDurability]) + '^';

    //属性
  astr := _get('', aItemData.rLifeDataBasic);
  if astr <> '' then
    result := result + '『$0000F1FF|基础属性:』' + '^' + astr;
  astr := _get('', aItemData.rLifeDataLevel);
  if astr <> '' then
    result := result + '『$0000F1FF|强化属性:』' + format(' %d级', [aItemData.rSmithingLevel]) + '^' + astr;
  astr := _get('', aItemData.rLifeDataAttach);
  if astr <> '' then
    result := result + '『$0000F1FF|附加属性:』' + '^' + astr;
  astr := _get('', aItemData.rLifeDataSetting);
  if astr <> '' then
    result := result + '『$0000F1FF|镶嵌属性:』' + '^' + astr;
    //状态
  if aItemData.rKind = ITEM_KIND_QUEST then
    result := result + '『$001A4DFB|任务物品』' + '^';
  if aItemData.rboNotExchange then
    result := result + '『$001A4DFB|不可交易』' + '^';
  if aItemData.rboNotTrade then
    result := result + '『$001A4DFB|不可出售』' + '^';
  if aItemData.rboNotDrop then
    result := result + '『$001A4DFB|不可丢弃』' + '^';
  if aItemData.rboNotSSamzie then
    result := result + '『$001A4DFB|不可寄存』' + '^';
  if aItemData.rboDurability then
    if aItemData.rboNOTRepair then
      result := result + '『$001A4DFB|不可维修』' + '^';
  if aItemData.rboColoring then
    result := result + '『$001A4DFB|允许染色』' + '^';
    //价格
  if aItemData.rPrice > 0 then
  begin
    result := result + format('『$0000F1FF|出售价格:』 %d', [aItemData.rPrice]) + '^';
  end;
  if aItemData.rCount > 1 then
  begin
    result := result + format('『$0000F1FF|数量:』 %d', [aItemData.rCount]) + '^';
  end;
  if aItemData.rSpecialLevel > 0 then
  begin
    result := result + '『$0000F1FF|等级:』 ' + Get10000To100(aItemData.rSpecialLevel) + '^';
  end;

  //Result := Result + format('价格: %d', [aItemData.rPrice]) + #13;
end;

procedure TfrmItemHelp.ShowProItem(aitemkey: integer);
var
  aitem: PTitemdata;
begin
  frmItemHelpitemPro_KEY := aitemkey;
  aitem := HaveItemclass.getid(aitemkey);
  if aitem = nil then exit;
  if aitem.rViewName = '' then exit;
  self.FTestPos := True;
  self.SetNewVersionTest;
  with aitem^ do
  begin
    if rGrade > 0 then
      lbGrade.Caption := format('[%d品]', [rGrade])
    else lbGrade.Caption := '';
    if rlockState = 1 then
    begin
            //rlockUPtime
            //锁
      btnReserved.Visible := true;
      A2Label1.Visible := false;

      btnLock.Visible := false;
    end
    else if rlockState = 2 then
    begin //解锁 中
      btnReserved.Visible := false;
      A2Label1.Visible := true;
      btnLock.Visible := true;
      //A2Label1.Caption := format('解锁时间已过:%.2f小时!', [(rlocktime / 60)]);
      A2Label1.Caption := format('解锁剩余%d分钟.', [(60 * 24 - rlocktime)]);
    end
    else if rlockState = 0 then
    begin //非锁
      btnReserved.Visible := false;
      A2Label1.Visible := false;
      btnLock.Visible := true;
    end;

    //等级显示
    if rSmithingLevel > 0 then
      lbItemName.Caption := format('%s %d级', [(rname), rSmithingLevel])
    else
      lbItemName.Caption := (rViewName);
    //销毁按钮显示
    if rAttribute = ITEM_Attribute_99 then
    begin
      lbItemDel.visible := true;
      lbItemDelStr := format('你真的要销毁【%d个%s】？', [rCount, rViewName]);
    end
    else
      lbItemDel.visible := false;

    showSAY(GetItemDataInfo(aitem^));
    imgItem.A2Image := nil;

    SetItemLabel('', rcolor, rshape);

    Visible := true;
    FrmM.move_win_form_Align(Self, mwfCenter);
    FrmM.SetA2Form(Self, A2form);

  end;
end;


function GetLeftStr(CellStr, FlagStr: string): string;
var
  FlagPos: integer;
begin
  FlagPos := Pos(FlagStr, CellStr);
  Result := Copy(CellStr, 1, FlagPos - 1);

end;

function GetRightStr(CellStr, FlagStr: string): string;
var
  FlagPos: integer;
  l1, l2: Integer;
begin
  FlagPos := Pos(FlagStr, CellStr);
  l1 := Length(FlagStr);
  l2 := Length(CellStr);
  Result := Copy(CellStr, FlagPos + l1, l2);

end;

function GetMidStr(sSource, sStr1,
  sStr2: string): string;
var
  nPos1, nPos2, i: integer;
  l1, l2: Integer;
begin
  i := 0;
  nPos1 := Pos(sStr1, sSource);
  nPos2 := Pos(sStr2, sSource);
  l1 := Length(sStr1);
  l2 := Length(sStr2);
  Result := Copy(sSource, nPos1 + l1, nPos2 - nPos1 - l2);

end;

procedure TfrmItemHelp.showSAY(str: string);
var
  i, li, cmdboolean: integer;
  cmd, sname: string;

  s: string;
  r, r2: TRect;
  tmp: TGUID;
  sg: string;
  count, tcount: Integer;
  function getNotHotRowsCount(Astr: string): Integer;
  const
    mark1 = '{';
    mark2 = '}';
  var
    ps: string;
    t: Integer;
  begin
    Result := 0;
    if (Pos(mark1, astr) > 0) and (Pos(mark2, astr) > 0) then
    begin
      ps := GetMidStr(Astr, mark1, mark2);
      Result := StrToIntDef(ps, 0);
    end;
  end;
begin

  listContent.Clear;
  cmdlist.Clear;

  count := 0;
  tcount := 0;
  cmdboolean := 0;
  s := '';
  cmd := '';
  sname := '';
  li := 0;

  for i := 1 to length(str) do
  begin
   // if li > high(TA2Labellist) then exit;
    case str[i] of
      '^':
        begin
         // TA2Labellist[li].Caption := s;
          tcount := getNotHotRowsCount(s);
          if tcount > 0 then
            count := tcount;
          if count > 0 then
          begin
            s := GetLeftStr(s, '{');
          end;
          sg := '';
          if s = '' then
          begin
            CreateGUID(tmp);
            sg := GUIDToString(tmp);
          end;
          if sg <> '' then
          begin
            cmdlist.Values[sg] := '';
          end else
            cmdlist.Values[s] := '';

          listContent.AddItem(s);
          inc(li);
          cmdboolean := 0;
          s := '';
        end;
    else
      begin
        if cmdboolean = 0 then
          s := s + str[i]
        else if cmdboolean = 1 then
          sname := sname + str[i]
        else if cmdboolean = 2 then
          cmd := cmd + str[i]
            ;
      end;
    end;

  end;
  //self.listSayContent.AddItem(s);
  if s <> '' then
  begin
    listContent.AddItem(s);
  end;
  listContent.ItemIndex := 0;
 /// TA2Labellist[li].Caption := s;
  listContent.NoHotDrawItemsCount := count;
  // SetNewVersionTest;

//  listContent.Clear;
//  s := '';
//  for i := 1 to length(str) do
//  begin
//    if str[i] = #13 then
//    begin
//      listContent.AddItem(s);
//      s := '';
//    end else
//    begin
//      S := S + STR[I];
//    end;
//  end;
//  if S <> '' then listContent.AddItem(s);

  //if listContent.Count > 0 then listContent.AddItem('{' + IntToStr(listContent.Count) +'}');
    //    listContent.AddItem(t.Strings[i]);

end;

procedure TfrmItemHelp.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  itemPro: pTSitemPro;

begin
  pckey := @Code.Data;
  case pckey^.rmsg of

    SM_itempro:
      begin
        self.FTestPos := True;
        self.SetNewVersionTest;
        itemPro := @Code.Data;
        if itemPro.rkey = itemproGET then
        begin
          frmItemHelpitemPro := itemPro^;
          with itemPro^ do
          begin
            if rGrade > 0 then
              lbGrade.Caption := format('[%d品]', [rGrade])
            else lbGrade.Caption := '';
            if rlockState = 1 then
            begin
                            //rlockUPtime
                            //锁
              btnReserved.Visible := true;
              A2Label1.Visible := false;
              btnLock.Visible := false;
            end
            else if rlockState = 2 then
            begin //解锁 中
              btnReserved.Visible := false;
              A2Label1.Visible := true;
              btnLock.Visible := true;
              A2Label1.Caption := format('解锁时间已过:%.2f小时', [(rlocktime / 60)]);
            end
            else if rlockState = 0 then
            begin //非锁
              btnReserved.Visible := false;
              A2Label1.Visible := false;
              btnLock.Visible := true;
            end;

            if rSmithingLevel > 0 then
              lbItemName.Caption := format('%s %d级', [(rname), rSmithingLevel])
            else
              lbItemName.Caption := (rname);

            showSAY(GetWordString(rWordString));

            FrmAttrib.SetItemLabel(imgItem, '', rcolor, rshape, 0, 0);
          end;

          Visible := true;
          FrmM.move_win_form_Align(Self, mwfCenter);
          FrmM.SetA2Form(Self, A2form);

        end;
                {
                else if itemPro.rkey = itemproGET_MagicBasic then
                begin
                    with itemPro^ do
                    begin
                        lbGrade.Caption := '';

                        btnReserved.Visible := false;
                        A2Label1.Visible := false;
                        btnLock.Visible := false;
                        A2Label1.Caption := '';

                        lbItemName.Caption := (rname);

                        showSAY(GetWordString(rWordString));
                        FrmAttrib.SetItemLabel(imgItem, '', 0, rshape, 0, 0);
                    end;

                    Visible := true;
                    FrmM.move_win_form_Align(Self, mwfCenter);
                    FrmM.SetA2Form(Self, A2form);
                end;}
      end;
  end;
end;

procedure TfrmItemHelp.SetNewVersion;

begin
  inherited;
end;

//procedure TfrmItemHelp.SetOldVersion;
//begin
//  pgkBmp.getBmp('itembase2.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//    //   listContent.SetBackImage(getviewImage(10));
//  listContent.SetScrollTopImage(getviewImage(20), getviewImage(21));
//  listContent.SetScrollTrackImage(getviewImage(22), getviewImage(23));
//  listContent.SetScrollBottomImage(getviewImage(18), getviewImage(19));
//    //  listContent.SetScrollBackImage(getviewImage(2));
//     //listContent.FFontSelBACKColor := 31;
//end;

procedure TfrmItemHelp.FormCreate(Sender: TObject);
begin
  inherited;
  self.FTestPos := false;
  FrmM.AddA2Form(Self, A2form);
  Left := 0;
  Top := 0;

  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;

  cmdlist := tstringlist.Create;
  cmdlist.Clear;

  listContent.FLayout := tlCenter;
  FNEWitemTA2Image := TA2Image.Create(32, 32, 0, 0);
  FNEWitemTA2Image.Clear(0);
 // FNEWitemTA2Image.Resize(A2ILabelNEWitem.Width, A2ILabelNEWitem.Height);
  imgItem.A2Image := FNEWitemTA2Image;
end;

procedure TfrmItemHelp.btnCloseClick(Sender: TObject);
begin
  Visible := false;
  FrmBottom.SetFocus;
  FrmBottom.EdChat.SetFocus;
end;

procedure TfrmItemHelp.FormDestroy(Sender: TObject);
begin
  inherited; // 内存泄漏007 在水一方 2015.05.18
end;

procedure TfrmItemHelp.btnLockClick(Sender: TObject);
//

var
  tt: TGET_cmd;
  cnt: integer;

begin

  tt.rmsg := CM_itempro;
  tt.rKEY := itemprolock;
  tt.rKEY2 := frmItemHelpitemPro_KEY;
  cnt := sizeof(TT);
  Frmfbl.SocketAddData(cnt, @TT);
  Visible := FALSE;
end;

procedure TfrmItemHelp.btnReservedClick(Sender: TObject);
var
  tt: TGET_cmd;
  cnt: integer;

begin

  tt.rmsg := CM_itempro;
  tt.rKEY := itemproUNlock;
  tt.rKEY2 := frmItemHelpitemPro_KEY;
  cnt := sizeof(TT);
  Frmfbl.SocketAddData(cnt, @TT);
  Visible := FALSE;
end;

procedure TfrmItemHelp.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmItemHelp.SetConfigFileName;
begin
  self.FConfigFileName := 'ItemHelp.xml';

end;

//procedure TfrmItemHelp.SetNewVersionOld;
//var
//  temping, tempUp, tempDown: TA2Image;
//begin
////  A2Form.TransParent := true;
////  temping := TA2Image.Create(32, 32, 0, 0);
////  tempUp := TA2Image.Create(32, 32, 0, 0);
////  tempDown := TA2Image.Create(32, 32, 0, 0);
////  try
////    pgkBmp.getBmp('道具属性窗口.BMP', A2form.FImageSurface);
////    A2form.boImagesurface := true;
////    Width := A2Form.FImageSurface.Width;
////    Height := A2Form.FImageSurface.Height;
////
////    pgkBmp.getBmp('道具属性_加锁_弹起.bmp', temping);
////    btnLock.A2Up := temping;
////    pgkBmp.getBmp('道具属性_加锁_按下.bmp', temping);
////    btnLock.A2Down := temping;
////    pgkBmp.getBmp('道具属性_加锁_鼠标.bmp', temping);
////    btnLock.A2Mouse := temping;
////    pgkBmp.getBmp('道具属性_加锁_禁止.bmp', temping);
////    btnLock.A2NotEnabled := temping;
////    btnLock.Caption := '';
////    btnLock.Left := 155;
////    btnLock.Top := 152;
////
////    pgkBmp.getBmp('道具属性_解锁_弹起.bmp', temping);
////    btnReserved.A2Up := temping;
////    pgkBmp.getBmp('道具属性_解锁_按下.bmp', temping);
////    btnReserved.A2Down := temping;
////    pgkBmp.getBmp('道具属性_解锁_鼠标.bmp', temping);
////    btnReserved.A2Mouse := temping;
////    pgkBmp.getBmp('道具属性_解锁_禁止.bmp', temping);
////    btnReserved.A2NotEnabled := temping;
////    btnReserved.Caption := '';
////    btnReserved.Left := 155;
////    btnReserved.Top := 152;
////
////    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
////    btnClose.A2Up := temping;
////    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
////    btnClose.A2Down := temping;
////    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
////    btnClose.A2Mouse := temping;
////    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
////    btnClose.A2NotEnabled := temping;
////    btnClose.Caption := '';
////    btnClose.Left := 210;
////    btnClose.Top := 14;
////
////    pgkBmp.getBmp('道具属性_道具底框.bmp', temping);
////    imgItem.A2Imageback := temping;
////    imgItem.Left := 22;
////    imgItem.Top := 37;
////    imgItem.Width := 40;
////    imgItem.Height := 40;
////
////    listContent.Left := 21;
////    listContent.Top := 77;
////    listContent.Width := 206;
////    listContent.Height := 71;
////    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
////    listContent.SetScrollTopImage(tempUp, tempDown);
////    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
////    listContent.SetScrollTrackImage(tempUp, tempDown);
////    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempUp);
////    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
////    listContent.SetScrollBottomImage(tempUp, tempDown);
////    pgkBmp.getBmp('道具属性_下拉条底框.bmp', temping);
////    listContent.SetScrollBackImage(temping);
////
////    lbGrade.Left := 22;
////    lbGrade.Top := 17;
////    lbItemName.Left := 64;
////    lbItemName.Top := 17;
////
////    A2Label1.Left := 18;
////    A2Label1.Top := 152;
////  finally
////    tempUp.Free;
////    tempDown.Free;
////    temping.Free;
////  end;
//
//end;

procedure TfrmItemHelp.SetNewVersionTest;


begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  self.SetControlPos(btnLock);
  btnLock.Caption := '';
  self.SetControlPos(btnReserved);
  btnReserved.Caption := '';
  self.SetControlPos(btnClose);
  btnClose.Caption := '';

  self.SetControlPos(imgItem);

  self.SetControlPos(listContent);
  listContent.FLayout := tlCenter;
  listContent.FItemIndexViewState := false;
  listContent.FMouseViewState := true;

  self.SetControlPos(lbGrade);
  self.SetControlPos(lbItemName);
  self.SetControlPos(A2Label1);
  self.SetControlPos(lbItemDel);
  lbItemDel.Caption := '销毁';


end;

procedure TfrmItemHelp.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TfrmItemHelp.SetItemLabel(
  aname: string; acolor: byte; shape: word);
var
  FGreenCol, FGreenAdd: integer;
  tt: TA2Image;
  temppTSHaveItem: PTItemdata;
begin

  FNEWitemTA2Image.Clear(0);



  tt := AtzClass.GetItemImage(shape);

  if tt <> nil then
  begin
    FNEWitemTA2Image.Resize(32, 32);
    FNEWitemTA2Image.Clear(0);
        //A2ILabelNEWitem.Caption := temppTSHaveItem.rViewName; //+ #13#10 + '数量' + inttostr(FNewItemKeyCount);

    GetGreenColorAndAdd(acolor, FGreenCol, FGreenAdd);
    if FGreenCol = 0 then
    begin
      FNEWitemTA2Image.DrawImage(imgItem.A2Imageback, 0, 0, TRUE);

      FNEWitemTA2Image.DrawImage(tt, (imgItem.Width - tt.Width) div 2, (imgItem.Height - tt.Height) div 2, true);
    end
    else
    begin
      FNEWitemTA2Image.DrawImageGreenConvert(imgItem.A2Imageback, 0, 0, FGreenCol, FGreenAdd);

      FNEWitemTA2Image.DrawImageGreenConvert(tt, (imgItem.Width - tt.Width) div 2, (imgItem.Height - tt.Height) div 2, FGreenCol, FGreenAdd);
    end;
    FNEWitemTA2Image.Optimize;
  end;
  imgItem.A2Image := FNEWitemTA2Image;
end;

function GetStrCounts(ASubStr, AStr: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  i := 1;
  while PosEx(ASubStr, AStr, i) <> 0 do
  begin
    Inc(Result);
    i := PosEx(ASubStr, AStr, i) + 1;
  end;
end;

procedure TfrmItemHelp.listContentDblClick(Sender: TObject);
var
  STR: string;
  temp: TWordComData;
begin
  inherited;
  if listContent.ItemIndex = -1 then Exit;
  STR := cmdlist.Values[(listContent.Items[listContent.ItemIndex])];
  if STR = '' then Exit;
  listContent.LeftMouseDown := False;
end;


procedure TfrmItemHelp.lbItemDelClick(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
begin
  inherited;
  btnCloseClick(Sender);
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtItemDel, '销毁道具', lbItemDelStr);
  frmConfirmDialog.Fkey := frmItemHelpitemPro_KEY;
end;

end.

