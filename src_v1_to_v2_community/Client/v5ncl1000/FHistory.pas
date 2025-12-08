unit FHistory;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, A2Form, A2Img, ExtCtrls, Clipbrd, BaseUIForm, uAnsTick,
  A2View, deftype;
type
  THistoryInfoList = record
    rstr: string;
    fcolor: integer;
    bcolor: integer;
    rindex: integer;
    rpos: shortint;
    rViewName: string;
    rChatItemData: TItemData;
    rsizeof: Boolean;
    rId: integer;
  end;
  pTHistoryInfoList = ^THistoryInfoList;

  TfrmHistory = class(TfrmBaseUI)
    A2Form: TA2Form;
    listHistory: TA2ChatListBox;
    btncloes: TA2Button;
    Check_Notice: TA2CheckBox;
    Check_Normal: TA2CheckBox;
    Check_Outcry: TA2CheckBox;
    Check_PrivateMsg: TA2CheckBox;
    Check_MapMsg: TA2CheckBox;
    Check_Guild: TA2CheckBox;
    check_Horn: TA2CheckBox;
    Check_GD: TA2CheckBox;
    procedure FormCreate(Sender: TObject);
    procedure listHistoryAdxDrawItem(ASurface: TA2Image; index: Integer;
      aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: Integer);
    procedure listHistoryClick(Sender: TObject);
    procedure listHistoryMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btncloesClick(Sender: TObject);
    procedure Check_gundong(Sender: TObject);
    procedure listHistoryMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    FStick: Integer;
        { Private declarations }
  public
    fdata: tlist;
        { Public declarations }
    procedure add(aStr: string; afcolor, abcolor: Integer);
    procedure add_item(aStr: string; afcolor, abcolor: Integer; apos: shortint; aItemNamea: string; aChatItemData: PTItemData);
    procedure add_ExHead(aStr: string; afcolor, abcolor: Integer; apos: shortint; aItemNamea: string; aId: Integer);
    function getstrindex(afcolor, abcolor: Integer): Integer;
    procedure CLEAR();
    procedure DrawInfo(p: pTHistoryInfoList);
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

var
  frmHistory: TfrmHistory;

implementation

uses FMain, FAttrib, FBottom, FMiniMap, AUtil32, filepgkclass, fbl;

{$R *.DFM}

procedure TfrmHistory.FormCreate(Sender: TObject);
begin
  inherited;
  Self.FTestPos := True;

  FrmM.AddA2Form(Self, A2form);
  Left := 0;
  Top := 0;
  FStick := 0;
  //聊天频道默认选中
  fdata := tlist.Create;

  Check_Notice.Checked := true;
  Check_Normal.Checked := true;
  Check_Outcry.Checked := true;
  Check_PrivateMsg.Checked := true;
  Check_MapMsg.Checked := true;
  Check_Guild.Checked := true;
  check_Horn.Checked := true;
  Check_GD.Checked := true;

  SetNewVersionTest;
//
//    pgkBmp.getBmp('History.bmp', A2form.FImageSurface);
//    A2form.boImagesurface := true;


    {  lblTop.A2Image := getviewImage(13);
      lblBottom.A2Image := getviewImage(16);
      lblLeft.A2Image := getviewImage(14);
      lblRight.A2Image := getviewImage(15);
     }
//      //   listContent.SetBackImage(getviewImage(10));
//    listHistory.SetScrollTopImage(getviewImage(7), getviewImage(6));
//    listHistory.SetScrollTrackImage(getviewImage(4), getviewImage(5));
//    listHistory.SetScrollBottomImage(getviewImage(9), getviewImage(8));
//    // listHistory.SetScrollBackImage(getviewImage(17));
//     //listContent.FFontSelBACKColor := 31;
//    listHistory.FLayout := tlCenter;
//    listHistory.FItemIndexViewState := false;
//    listHistory.FMouseViewState := true;
end;

procedure TfrmHistory.listHistoryAdxDrawItem(ASurface: TA2Image;
  index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
  fy: Integer);
var
  col: integer;
  fcol, bcol, r, g, b: word;
begin
    {  col := Integer(listHistory.StringList.Objects[Index]);

      fcol := LOWORD(Col);
      bcol := HIWORD(col);
      ASurface.Clear(bcol);
      ATextOut(ASurface, fx, fy, fcol, listHistory.Items[Index]);
      if (State = TIS_MouseSelect)
          or (state = TIS_Select_and_MouseSelect) then
          ATextOut(ASurface, fx + 1, fy, fcol, listHistory.Items[Index]);
    }
end;

procedure TfrmHistory.listHistoryClick(Sender: TObject);
var
  s, sname, s1, s2, s3: string;
  tempsend: TWordComData;
  aitem: PTItemdata;
  str, rdstr: string;
  Len, l, r, rx, ry: Integer;
begin
  aitem := nil;
  FrmBottom.SetFocus;
  FrmBottom.EdChat.SetFocus;
  sname := '';
  s := listHistory.GetItem(listHistory.ItemIndex);
  if s = '' then exit;
  if ReverseFormat(s, '[%s] :%s', s1, s2, s3, 2) then //世界
    sname := s1
  else if ReverseFormat(s, '<%s> :%s', s1, s2, s3, 2) then //门派
    sname := s1
  else if ReverseFormat(s, '%s :%s', s1, s2, s3, 2) then //当前
    sname := s1
  else if ReverseFormat(s, '%s" %s', s1, s2, s3, 2) then //纸条
    sname := s1
  else if ReverseFormat(s, '[队伍]%s:%s', s1, s2, s3, 2) then //队伍
    sname := s1;

  if sname <> '' then
  begin
    Clipboard.AsText := sname;
        //FrmBottom.AddChat('内容已复制', WinRGB(255, 255, 0), 0);
    FrmBottom.Editchannel.Caption := '纸条';
        //FrmBottom.EdChat.Text := '@纸条 ' + sname + ' '+s;
    FrmBottom.EdChat.Text := '@纸条 ' + sname + ' ';
  end;

  FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
    // FrmBottom.EdChat.SelLength := 1;
  if (TA2ChatListBox(Sender).MouseSelectItemIndex > 0) and (TA2ChatListBox(Sender).MouseSelectItemIndex < TA2ChatListBox(Sender).Count) and
    (TA2ChatListBox(Sender).ChatList.Objects[TA2ChatListBox(Sender).MouseSelectItemIndex] <> nil) then
  begin
    try
      if TA2ChatListBox(Sender).ChatList.Objects[TA2ChatListBox(Sender).MouseSelectItemIndex] is TChatItemData then
        aitem := @(TChatItemData(TA2ChatListBox(Sender).ChatList.Objects[TA2ChatListBox(Sender).MouseSelectItemIndex]).ItemData);
      if (aitem <> nil) and (aitem.rName = '') then
      begin
        str := GetValidStr3(TChatItemData(TA2ChatListBox(Sender).ChatList.Objects[TA2ChatListBox(Sender).MouseSelectItemIndex]).ItemName, rdstr, ':');
        //取坐标字符长度
        Len := length(str);
        //取:字符出现位置
        l := pos(':', str);
        //取X坐标
        rx := StrToIntDef(copy(str, 0, l - 1), 0);
        ry := StrToIntDef(copy(str, l + 1, Len - l), 0);
        if (rx <> 0) and (ry <> 0) then
        begin
          if rdstr = FrmMiniMap.A2ILabel1.Caption then
            FrmMiniMap.AIPathcalc_paoshishasbi(rx, ry)
          else
            FrmBottom.AddChat('不在同一地图！', ColorSysToDxColor(clFuchsia), 0);
          Exit;
        end;
        //不是坐标当物品处理
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_GETSAYITEMDATA);
        WordComData_ADDdword(tempsend, aitem.rId);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
      end
    except
    end;
  end;
end;

procedure TfrmHistory.listHistoryMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  id: integer;
  aitem: PTItemdata;
begin
  aitem := nil;
  try
    if Sender is TA2ChatListBox then
    begin
 //  if TA2ChatListBox(Sender).MouseSelectItemIndex > TA2ChatListBox(Sender).Count -1 then Exit;
      if (TA2ChatListBox(Sender).MouseSelectItemIndex <> -1) and (TA2ChatListBox(Sender).MouseSelectItemIndex <= TA2ChatListBox(Sender).Count - 1) then
      begin
        if TA2ChatListBox(Sender).ChatList.Objects[TA2ChatListBox(Sender).MouseSelectItemIndex] <> nil then
        begin
          try
            if TA2ChatListBox(Sender).ChatList.Objects[TA2ChatListBox(Sender).MouseSelectItemIndex] is TChatItemData then

              aitem := @(TChatItemData(TA2ChatListBox(Sender).ChatList.Objects[TA2ChatListBox(Sender).MouseSelectItemIndex]).ItemData);
          except
          end;
        end;
      end else
      begin
        GameHint.Close;
      end;

      if (aitem <> nil) and (aitem.rName <> '') then
      begin

        GameHint.setText(integer(Sender), TItemDataToStr(aitem^))

      end
      else
        GameHint.Close;
    end;
  except
    GameHint.Close;
  end;
end;


procedure TfrmHistory.add(aStr: string; afcolor, abcolor: Integer);
var
  pp: pTHistoryInfoList;
  index: Integer;
  Addflag: Boolean;
  rastr, rbstr: string;
  col, iLen: Integer;
begin
  index := 0;
  Addflag := False;
  //获取消息类型
  index := getstrindex(afcolor, abcolor);
  New(pp);
  pp^.rstr := aStr;
  pp^.fcolor := afcolor;
  pp^.bcolor := abcolor;
  pp^.rindex := index;
  pp^.rpos := -1;
 // pp^.rChatItemData := aChatItemData^;
  pp^.rsizeof := False;
  pp^.rId := 0;
  fdata.Add(pp);
  if fdata.Count >= 600 then
    fdata.Delete(0);

  DrawInfo(pp);
end;

procedure TfrmHistory.add_item(aStr: string; afcolor, abcolor: Integer; apos: shortint; aItemNamea: string; aChatItemData: PTItemData);
var
  pp: pTHistoryInfoList;
  index: Integer;
  Addflag: Boolean;
  rastr, rbstr: string;
  col, iLen: Integer;
begin
  index := 0;
  Addflag := False;
  //获取消息类型
  index := getstrindex(afcolor, abcolor);

  New(pp);
  pp^.rstr := aStr;
  pp^.fcolor := afcolor;
  pp^.bcolor := abcolor;
  pp^.rindex := index;
  pp^.rpos := apos;
  pp^.rViewName := aItemNamea;
  pp^.rChatItemData := aChatItemData^;
  pp^.rsizeof := False;
  pp^.rId := 0;
  fdata.Add(pp);
  if fdata.Count >= 600 then
    fdata.Delete(0);

  DrawInfo(pp);
end;


procedure TfrmHistory.add_ExHead(aStr: string; afcolor, abcolor: Integer; apos: shortint; aItemNamea: string; aId: Integer);
var
  pp: pTHistoryInfoList;
  index: Integer;
  Addflag: Boolean;
  rastr, rbstr: string;
  col, iLen: Integer;
begin
  index := 0;
  Addflag := False;
  //获取消息类型
  index := getstrindex(afcolor, abcolor);

  New(pp);
  pp^.rstr := aStr;
  pp^.fcolor := afcolor;
  pp^.bcolor := abcolor;
  pp^.rindex := index;
  pp^.rpos := apos;
  pp^.rViewName := aItemNamea;
  pp^.rsizeof := True;
  pp^.rId := aId;
  fdata.Add(pp);
  if fdata.Count >= 600 then
    fdata.Delete(0);

  DrawInfo(pp);
end;


function TfrmHistory.getstrindex(afcolor, abcolor: Integer): Integer;
begin
 inherited;
  Result := 0;
  //对话
  if (afcolor = 29596) and (abcolor = 0) then
    Result := 1
  //呐喊
  else if (afcolor = WinRGB(18, 16, 14)) and (abcolor = WinRGB(2, 4, 5)) then
    Result := 2
  else if (afcolor = WinRGB(18, 16, 14)) and (abcolor = WinRGB(2, 4, 5)) then
    Result := 2
  else if (afcolor = WinRGB(31, 29, 27)) and (abcolor = WinRGB(2, 4, 5)) then
    Result := 2
  else if (afcolor = WinRGB(22, 18, 8)) and (abcolor = WinRGB(1, 4, 11)) then
    Result := 2
  else if (afcolor = WinRGB(23, 13, 4)) and (abcolor = WinRGB(1, 4, 11)) then
    Result := 2
  else if (afcolor = WinRGB(31, 29, 21)) and (abcolor = WinRGB(1, 4, 11)) then
    Result := 2
  else if (afcolor = WinRGB(30, 30, 1)) and (abcolor = WinRGB(20, 10, 11)) then
    Result := 2
  else if (afcolor = WinRGB(31, 30, 11)) and (abcolor = WinRGB(25, 11, 11)) then
    Result := 2
  else if (afcolor = WinRGB(31, 31, 1)) and (abcolor = WinRGB(30, 5, 5)) then
    Result := 2
  else if (afcolor = WinRGB(1, 31, 31)) and (abcolor = WinRGB(1, 14, 20)) then
    Result := 2
  //纸条屏蔽
  else if (afcolor = ColorSysToDxColor($FF64FF)) and (abcolor = 0) then
    Result := 3
  else if (afcolor = ColorSysToDxColor($0000B0B0)) and (abcolor = 0) then
    Result := 3
  else if (afcolor = ColorSysToDxColor($00008890)) and (abcolor = 0) then
    Result := 3
  //副本屏蔽
  else if (afcolor = WinRGB(22, 22, 22)) and (abcolor = WinRGB(1, 1, 1)) then
    Result := 4
  //门派屏蔽
  else if (afcolor = WinRGB(22, 22, 22)) and (abcolor = WinRGB(0, 0, 1)) then
    Result := 5
    //屏蔽门派同盟
  else if (afcolor = WinRGB(26, 23, 21)) and (abcolor = WinRGB(2, 4, 6)) then
    Result := 5
  //喇叭屏蔽
  else if (afcolor = 32702) and (abcolor = 23563) then
    Result := 6
  else if (afcolor = 29503) and (abcolor = 4350) then
    Result := 6
  else if (afcolor = 32758) and (abcolor = 15840) then
    Result := 6;

end;

procedure TfrmHistory.DrawInfo(p: pTHistoryInfoList);
var
  index: Integer;
  Addflag: Boolean;
  aStr, rastr, rbstr: string;
  fcolor, bcolor, col, iLen: Integer;
begin

  Addflag := False;
  aStr := p.rstr;
  index := p.rindex;
  fcolor := p.fcolor;
  bcolor := p.bcolor;

  //判断当前列表是否添加
  case index of
    0: if Check_Notice.Checked then Addflag := true;
    1: if Check_Normal.Checked then Addflag := true;
    2: if Check_Outcry.Checked then Addflag := true;
    3: if Check_PrivateMsg.Checked then Addflag := true;
    4: if Check_MapMsg.Checked then Addflag := true;
    5: if Check_Guild.Checked then Addflag := true;
    6: if check_Horn.Checked then Addflag := true;
  end;

  if Addflag then
  begin
    col := MakeLong(fcolor, bcolor);
      //分割长的字符串
      //先判断要截取的字符串最后一个字节的类型
      //如果为汉字的第一个字节则减(加)一位
    iLen := 94;
    if Length(aStr) > iLen then
    begin
      if ByteType(aStr, iLen) = mbLeadByte then
        iLen := iLen - 1;
      rastr := copy(aStr, 1, iLen);
      rbstr := copy(aStr, iLen + 1, Length(aStr) - iLen);
      //画第一行
      if p.rpos > -1 then
      begin
        listHistory.addObject(rastr, TChatItemData.Create);
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).col := col;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemPos := p.rpos;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemName := p.rViewName;
        if not p.rsizeof then
          copymemory(@TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData, @p.rChatItemData, sizeof(TItemData))
        else
          fillchar(TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData, sizeof(TItemData), 0);
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).FColor := fcolor;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).bcolor := bcolor;
        if p.rid > 0 then
          TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData.rId := p.rid;
      end
      else
      begin
        listHistory.ChatList.AddObject(rastr, TChatColor.Create);
        TChatColor(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).col := col;
      end;
      if Check_GD.Checked  then
      begin
        listHistory.ItemIndex := listHistory.Count - 1;
        listHistory.upItemIndex;
      end;
      if p.rpos > -1 then
      begin
        listHistory.Loaded;
        listHistory.DrawItem;
      end;
      //画第二行
      if p.rpos > -1 then
      begin
        listHistory.addObject(rbstr, TChatItemData.Create);
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).col := col;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemPos := p.rpos;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemName := p.rViewName;
        if not p.rsizeof then
          copymemory(@TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData, @p.rChatItemData, sizeof(TItemData))
        else
          fillchar(TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData, sizeof(TItemData), 0);
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).FColor := fcolor;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).bcolor := bcolor;
        if p.rid > 0 then
          TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData.rId := p.rid;
      end
      else
      begin
        listHistory.ChatList.AddObject(rbstr, TChatColor.Create);
        TChatColor(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).col := col;
      end;
      if Check_GD.Checked then
      begin
        listHistory.ItemIndex := listHistory.Count - 1;
        listHistory.upItemIndex;
      end;

      if p.rpos > -1 then
      begin
        listHistory.Loaded;
        listHistory.DrawItem;
      end;
    end
    else
    begin
      if p.rpos > -1 then
      begin
        listHistory.addObject(aStr, TChatItemData.Create);
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).col := col;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemPos := p.rpos;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemName := p.rViewName;
        if not p.rsizeof then
          copymemory(@TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData, @p.rChatItemData, sizeof(TItemData))
        else
          fillchar(TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData, sizeof(TItemData), 0);
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).FColor := fcolor;
        TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).bcolor := bcolor;
        if p.rid > 0 then
          TChatItemData(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).ItemData.rId := p.rid;
      end
      else
      begin
        listHistory.ChatList.AddObject(aStr, TChatColor.Create);
        TChatColor(listHistory.ChatList.Objects[listHistory.ChatList.Count - 1]).col := col;
      end;
      if Check_GD.Checked then
      begin
        listHistory.ItemIndex := listHistory.Count - 1;
        listHistory.upItemIndex;
      end;
      if p.rpos > -1 then
      begin
        listHistory.Loaded;
        listHistory.DrawItem;
      end;
    end;
  end;
end;

procedure TfrmHistory.CLEAR();
var
  I: INTEGER;
  PP: pTHistoryInfoList;
begin
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];
    dispose(pp);
  end;
  Fdata.Clear;
end;

procedure TfrmHistory.SetNewVersionTest;
var
  i: Integer;
begin
  inherited;
  SetControlPos(self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;

  SetControlPos(listHistory);
  listHistory.FLayout := tlCenter;
  listHistory.FItemIndexViewState := false;
  listHistory.FMouseViewState := true;

  SetControlPos(btncloes);
  SetControlPos(Check_Notice);

  SetControlPos(Check_Normal);
  SetControlPos(Check_Outcry);
  SetControlPos(Check_PrivateMsg);
  SetControlPos(Check_MapMsg);
  SetControlPos(Check_Guild);
  SetControlPos(check_Horn);
  SetControlPos(Check_GD);

end;

procedure TfrmHistory.SetConfigFileName;
begin
  FConfigFileName := 'History.xml';

end;

procedure TfrmHistory.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TfrmHistory.btncloesClick(Sender: TObject);
begin
  Visible := false;
end;

procedure TfrmHistory.Check_gundong(Sender: TObject);
var
  i: integer;
  pp: pTHistoryInfoList;
begin
  inherited;
  if FStick + 50 > mmAnsTick then
    Exit;
  FStick := mmAnsTick;
  //改变选择重新输出所有消息
  //清除当前消息
  listHistory.Clear;
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.Items[i];
    DrawInfo(pp);
  end;
  //filter;
end;

procedure TfrmHistory.listHistoryMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  str: string;
begin
  inherited;

    //按住了ssCtrl
  if ssCtrl in Shift then
  begin
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
    str := listHistory.GetItem(listHistory.ItemIndex);
    if str = '' then exit;
    FrmBottom.EdChat.Text := str;
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
    // FrmBottom.EdChat.SelLength := 1;
  end;
end;

procedure TfrmHistory.FormDestroy(Sender: TObject);
begin
  inherited;
  fdata.Free;
end;

end.

