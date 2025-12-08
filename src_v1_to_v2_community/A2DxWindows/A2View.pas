unit A2View;

interface
uses
  A2Form, A2Img, Classes, Controls, Messages, Windows, graphics, sysutils, StdCtrls, deftype, AUtil32;
const WM_A2ViewSelected = WM_USER + $200;
type

  TEditChangeStat = record
    Selstart: Integer;
    SelLength: Integer;
    Length: Integer;
    LbutomDown: Boolean;
  end;

  TChatItemData = class
  public
    Col: integer;
    ItemPos: integer;
    ItemData: TItemData;
    ItemName: string;
    HaveItem: boolean;
    HaveItemColor: Boolean;
    FColor, BColor: Word;
    ChatItemFontColor: word;
    constructor Create();
  end;
  TChatColor = class
  public
    Col: integer;
  end;
  TA2ChatListBox = class(TA2ListBox)
  public
    function AddObject(const S: string; AObject: TObject): Integer;
    procedure DrawItem(); override;
    property ChatList: TStringList read FStringList;
    property MouseSelectItemIndex: Integer read FMouseSelectItemIndex;
  end;
  TA2ChatLabel = class(TA2Label)
  private

    FChatItemNameIndex: integer;
    FCHatItemName: string;
    FChatItemSelected: boolean;
    FChatItemFontColor: word;
    FChatItemLevel: integer;
    FHaveChatItem: Boolean;
    FChatItemData: Pointer;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    procedure AdxPaint; override;
    constructor Create(AOwner: TComponent); override;

    property ChatItemNameIndex: integer read FChatItemNameIndex write FChatItemNameIndex;
    property CHatItemName: string read FCHatItemName write FCHatItemName;
    property ChatItemSelected: boolean read FChatItemSelected write FChatItemSelected;
    property ChatItemFontColor: word read FChatItemFontColor write FChatItemFontColor;
    property ChatItemLevel: integer read FChatItemLevel write FChatItemLevel;
    property HaveChatItem: Boolean read FHaveChatItem write FHaveChatItem;
    property ChatItemData: Pointer read FChatItemData write FChatItemData;
  end;
  TA2ChatEdit = class(TA2Edit)
  private
    FSelectedChatItemPos: integer;
    FHaveChatItem: boolean;
    FChatItemName: string;
    FChatItemLevel: integer;
    FChatItemFontColor: word;
    FLastStatus: TEditChangeStat;
  protected
    procedure SelfKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure wndproc(var message: Tmessage); override;
    procedure CMChanged(var Message: TMessage); message CM_CHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AdxPaint; override;
    property SelectedChatItemPos: integer read FSelectedChatItemPos write FSelectedChatItemPos;
    property HaveChatItem: boolean read FHaveChatItem write FHaveChatItem;
    property ChatItemName: string read FChatItemName write FChatItemName;
    property ChatItemFontColor: word read FChatItemFontColor write FChatItemFontColor;
    property ChatItemLevel: integer read FChatItemLevel write FChatItemLevel;
  end;
  TA2View = class(TA2ILabel)
  private
    FSkinImg: TA2Image;
    FImageBuffer: TA2Image;
    FPersonImg: TA2Image;
    FListIndex: Integer;
    FFormHwnd: hwnd;
    FHaveSkin: Boolean;
    FSkinPlacementsPath: string;

  public
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure redraw;
    procedure ReDrawSkin;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ImageBuffer: TA2Image read FImageBuffer;
    property ListIndex: Integer read FListIndex write FListIndex;
    property FormHwnd: hwnd read FFormHwnd write FFormHwnd;
    property PersonImg: TA2Image read FPersonImg;
    property SkinImg: TA2Image read FSkinImg;
    property HaveSkin: Boolean read FHaveSkin write FHaveSkin;
    property SkinPlacementsPath: string read FSkinPlacementsPath write FSkinPlacementsPath;
 //   property SkinXOffset:Integer read FSkinXOffset write
  end;
implementation

{ TA2View }

constructor TA2View.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinImg := TA2Image.Create(32, 32, 0, 0);
  FPersonImg := TA2Image.Create(32, 32, 0, 0);
  FImageBuffer := TA2Image.Create(160, 160, 0, 0);
  FHaveSkin := False;
end;

destructor TA2View.Destroy;
begin
  if FSkinImg <> nil then FSkinImg.Free;
  if FPersonImg <> nil then FPersonImg.Free;
  if FImageBuffer <> nil then FImageBuffer.Free;
  inherited;
end;

procedure TA2View.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  SendMessage(FFormHwnd, WM_A2ViewSelected, FListIndex, 0)
end;



procedure TA2View.redraw;
begin
  _draw;
end;

procedure TA2View.ReDrawSkin;
begin
  FImageBuffer.Clear(0);
  FImageBuffer.DrawImage(FPersonImg, FPersonImg.px + 80, FPersonImg.py + 80, True);
  FImageBuffer.DrawImage(FSkinImg, FSkinImg.px + 80, FSkinImg.py + 80, True);
  A2Image := FImageBuffer;
 // _Draw;
end;

{ TA2ChatLabel }

procedure TA2ChatLabel.AdxPaint;
var
  R, r2: TRect;
  xx, yy, fx, fy: integer;
  DrawStyle: Longint;
  tempimg: TA2Image;
  _chattmp, _username: string;
  _chattmpwidth: integer;
  _chattmppos, _chatfirstpos, _chatsecondpos: integer;
begin

  if (csDesigning in ComponentState) or not Assigned(ADXForm) then exit;
  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;

  if Assigned(Picture.Graphic) then
  begin
    R := Self.ClientRect;
    OffsetRect(R, left, top);



  end;

  if Text <> '' then
  begin
    tempimg := TA2Image.Create(Width, Height, 0, 0);
    try
      tempimg.Resize(Width, Height);
      tempimg.Clear(BackColor);
      fx := 0;
      fy := 0;
      if Alignment = taCenter then
      begin
        fx := (Width - ATextWidth(text)) div 2;
      end
      else if Alignment = taRightJustify then
      begin
        fx := (Width - ATextWidth(text));
      end;
      if fx < 0 then fx := 0;
      if self.FHaveChatItem then
      begin
        _chattmppos := pos('] : ', text);
        if _chattmppos = 0 then
        begin
          ///FontColor:=ColorSysToDxColor($001C1C1C);
          _chattmppos := pos(': ', text);
          //普通区域聊天
          _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length(': ') - 2;
          if _chattmppos = 0 then
          begin
            _chattmppos := pos('> ', text);
            _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length('> ') - 2;
            if _chattmppos = 0 then
            begin
              _chattmppos := pos('" ', text);
              _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length('" ') - 2;
            end;

          end;
          _username := '[' + self.FCHatItemName + ']';
        end else
        begin
          //呐喊
          _username := '[' + self.FCHatItemName + ']';
          _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length('] : ') - 1;
        end;

        _chattmp := copy(text, 1, _chatfirstpos);
        _chattmpwidth := ATextWidth(_chattmp);
        ATextOut(tempimg, fx, fy, FontColor, _chattmp);
        ATextOut(tempimg, fx + _chattmpwidth, fy, self.FChatItemFontColor, _username);
        _chattmpwidth := _chattmpwidth + ATextWidth(_username);
        _chattmp := copy(text, _chatfirstpos + 1, 255);
        ATextOut(tempimg, fx + _chattmpwidth, fy, FontColor, _chattmp);
      end else
        ATextOut(tempimg, fx, fy, FontColor, Text);
      R := Self.ClientRect;
      OffsetRect(R, left, top);
      if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
      ADXForm.Surface.DrawImage(tempimg, R.Left, R.Top, not NotTransParent);
    finally
      tempimg.Free;
    end;
        //ATextOut(FADXForm.FSurface, R.Left + fx, R.Top + fy, ColorSysToDxColor(Font.Color), Text);
  end;

end;

constructor TA2ChatLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FHaveChatItem := False;
  self.FChatItemSelected := false;
  self.FChatItemNameIndex := -1;
  self.FCHatItemName := '';
  self.FChatItemFontColor := ColorSysToDxColor(clyellow);
end;

procedure TA2ChatLabel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
  _chattmp: string;
  _chattmpwidth: integer;
  _chattmppos, _chatfirstpos, _chatsecondpos: integer;
  p: tpoint;
begin
  inherited MouseMove(Shift, x, y);
  self.FChatItemSelected := false;
  if FHaveChatItem then
  begin
   // _chattmppos := pos('] : ', text);
  //  _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length('] : ') - 1;
    _chattmppos := pos('] : ', text);
    if _chattmppos = 0 then
    begin
      _chattmppos := pos(': ', text);
      _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length(': ') - 2;
      if _chattmppos = 0 then begin
        _chattmppos := pos('> ', text);
        _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length('> ') - 2;
        if _chattmppos = 0 then
        begin
          _chattmppos := pos('" ', text);
          _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length('" ') - 2;
        end;
      end;
       //_username:='[' + self.FCHatItemName + ']';
    end else
    begin
       //    _username:='[' + self.FCHatItemName + ']';
      _chatfirstpos := self.FChatItemNameIndex + _chattmppos + length('] : ') - 1;
    end;



    _chattmp := copy(text, 1, _chatfirstpos);
    _chattmpwidth := ATextWidth(_chattmp);
    r := rect(0 + _chattmpwidth, 0, 0 + _chattmpwidth + ATextWidth('[' + self.FCHatItemName + ']'), self.Height);
    p := Point(X, Y);
    self.FChatItemSelected := PtInRect(R, p);
  end;
end;

{ TA2ChatEdit }
//2015.06.28 在水一方 >>>>>>

procedure TA2ChatEdit.CMChanged(var Message: TMessage);
var
  len, diff: Integer;
begin
  len := Length(text);
  diff := len - FLastStatus.Length;
  if (diff <> 0) and self.HaveChatItem and (self.FSelectedChatItemPos - 1 <= len) then begin
    if (SelStart < self.FSelectedChatItemPos - 1) then
      Inc(self.FSelectedChatItemPos, diff)
    else if (FLastStatus.Selstart < self.FSelectedChatItemPos - 1) then
      Inc(self.FSelectedChatItemPos, diff);
  end;
  FLastStatus.Length := len;
  FLastStatus.SelLength := SelLength;
  FLastStatus.Selstart := SelStart;
  inherited;
end;

procedure TA2ChatEdit.wndproc(var message: Tmessage);
var
  _chattmp: string;
  _chattmpwidth, _mouseX: integer;
  _chattmppos, _chatfirstpos, _chatsecondpos: integer;
begin
  if (message.msg = WM_LBUTTONUP) or (message.msg = WM_LBUTTONDOWN) then
  begin
    if message.msg = WM_LBUTTONUP then
      FLastStatus.LbutomDown := False;
    if self.HaveChatItem and (self.FSelectedChatItemPos - 1 <= length(text)) then
    begin
      _mouseX := message.LParamLo;
      _chattmp := copy(text, 1, self.FSelectedChatItemPos - 1);
      _chattmppos := ATextWidth('[' + self.FChatItemName + ']');
      _chatfirstpos := ATextWidth(_chattmp);
      _chatsecondpos := _chattmppos + _chatfirstpos;
      if _mouseX >= _chatfirstpos then
      begin
        if message.msg = WM_LBUTTONDOWN then
          FLastStatus.LbutomDown := True;
        if _mouseX <= _chatsecondpos then begin
          if self.FSelectedChatItemPos = 1 then begin
            Text := ' ' + Text;
            self.FSelectedChatItemPos := 2;
            _mouseX := 0;
          end
          else
            _mouseX := _chatfirstpos;
        end
        else
          _mouseX := _mouseX - _chattmppos;
        message.LParamLo := _mouseX;
      end;
      FLastStatus.Selstart := Selstart;
    end;
  end;
  if (message.msg = WM_MOUSEMOVE) and FLastStatus.LbutomDown then
  begin
    _chattmppos := ATextWidth('[' + self.FChatItemName + ']');
    message.LParamLo := message.LParamLo - _chattmppos;
  end;
  if (message.msg = WM_KEYUP) then
  begin
    case message.WParamLo of //2015.07.10 在水一方
      VK_LEFT:
        begin
          if (Selstart = 0) and (self.FSelectedChatItemPos = 1) then begin
            Text := ' ' + Text;
            self.FSelectedChatItemPos := 2;
          end;
          FLastStatus.Selstart := Selstart;
        end;
      VK_RIGHT: FLastStatus.Selstart := Selstart;
    end;
  end;

  inherited wndproc(message);
end;
//2015.06.28 在水一方 <<<<<<

procedure TA2ChatEdit.AdxPaint;
var
  i, Fx, Ex, Fs, fw, Fy, SelEnd: integer;
  str, str1, str2, str3, tmpStr: string;
  R: TRect;
  tempimg, tempback: TA2Image;

  _chattmp1, _chattmp2: string;
  _chattmpwidth: integer;
  _chattmppos, _chatfirstpos, _chatsecondpos: integer;
  function _textout(_tempimg: TA2Image; pstr: string; _pos, _x, _y: integer): Boolean;
  var
    _start, _end, _length: integer;
  begin
    Result := True;
    _start := SelStart - (_pos - 1);
    _end := SelStart + SelLength - (_pos - 1);
    if (_start < 0) and (_end > 0) then
      Result := False;
    if (_start < Length(pstr)) and (_end > Length(pstr)) then
      Result := False;
    if _start < 0 then _start := 0;
    if _end >= Length(pstr) then _end := Length(pstr);
    _length := _end - _start;
    str1 := Copy(pstr, 1, _start);
    str2 := Copy(pstr, _start + 1, _length);
    str3 := Copy(pstr, _start + _length + 1, Length(pstr) - _start - _length);
    if (_tempimg <> nil) and Assigned(_tempimg) then begin
      ATextOut(_tempimg, _x, _y, FFontColor, str1);
      ATextOut(_tempimg, _x + ATextWidth(str1), _y, WinRGB(5, 0, 31), str2);
      ATextOut(_tempimg, _x + ATextWidth(str1 + str2), _y, FFontColor, str3);
    end;
  end;
begin // TEdit
  if not Visible then exit;
  if not Assigned(ADXForm) then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;


  str := text;

  if (passwordchar <> char(0)) and (text <> '') then
    for i := 1 to Length(text) do str[i] := passwordchar;
  if self.HaveChatItem then
    fw := ATextWidth(str) + 10 + ATextWidth('[' + self.FChatItemName + ']')
  else
    fw := ATextWidth(str) + 10;

  tempimg := TA2Image.Create(fw, Height, 0, 0);
  tempback := TA2Image.Create(Width, Height, 0, 0);

  SelEnd := SelStart + SelLength;
  EX := ATextWidth(COPY(str, 1, SelEnd));

  try
    tempback.Resize(Width, Height);
    if self.HaveChatItem then
    begin
      if self.FSelectedChatItemPos - 1 <= length(str) then
      begin
        _chattmp1 := copy(str, 1, self.FSelectedChatItemPos - 1);
        //ATextOut(tempimg1, 0, 0, FontColor, _chattmp);
        _textout(tempimg, _chattmp1, 1, 0, 0);
        _chattmppos := ATextWidth('[' + self.FChatItemName + ']');
        _chatfirstpos := ATextWidth(_chattmp1);
        ATextOut(tempimg, 0 + _chatfirstpos, 0, self.FChatItemFontColor, '[' + self.FChatItemName + ']');
        _chattmp2 := copy(str, self.FSelectedChatItemPos, 255);
        //ATextOut(tempimg, 0 + _chatfirstpos + _chattmppos, 0, FontColor, _chattmp2);
        _textout(tempimg, _chattmp2, self.FSelectedChatItemPos, _chatfirstpos + _chattmppos, 0);
      end else
      begin
        self.HaveChatItem := false;
        self.FSelectedChatItemPos := -1;
        ATextOut(tempimg, 0, 0, FontColor, str);
      end;
    end else
    begin
      if SelLength <> 0 then //2015.06.27在水一方 >>>>>>
        _textout(tempimg, str, 1, 0, 0)
      else
        ATextOut(tempimg, 0, 0, FontColor, str);
    end;

    str := COPY(str, 1, SelStart);                   //2015.12.12 在水一方
    FX := ATextWidth(str);

    if boTail then //光标
    begin
      //str := COPY(str, 1, SelStart);
      if self.HaveChatItem then begin
        if SelStart < self.FSelectedChatItemPos - 1 then
          FX := ATextWidth(COPY(str, 1, SelStart))
        else
          FX := ATextWidth(COPY(str, 1, SelStart)) + _chattmppos;
      end
      else
        FX := ATextWidth(COPY(str, 1, SelStart));
      ATextOut(tempimg, fx, 0, FFontColor, '_');
      ATextOut(tempimg, fx, 0 + 1, FFontColor, '_');
    end;
    if self.HaveChatItem and (SelLength <> 0) then
    begin
      //SelStart := SelStart + SelLength;
      if not (_textout(nil, _chattmp1, 1, 0, 0) and
        _textout(nil, _chattmp2, self.FSelectedChatItemPos, _chatfirstpos + _chattmppos, 0)) then
        Sellength := 0;
    end; //2015.06.27在水一方 <<<<<<

    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);


    Fs := 0;
      if (Fx - FStart >= 0) and (Ex - FStart < Width) then Fs := FStart
      else if FArrow and (Ex - FStart >= Width) then Fs := Ex - Width
      else if not FArrow and (Ex - FStart >= Width) then Fs := Fx
      else if FArrow then Fs := Fs + 1
      else if not FArrow then Fs := Fs - 1;
      if Fs > Fw - Width then Fs := fw - Width;
      if Fs <0 then Fs := 0;
      FStart := Fs;                      //2015.12.12 在水一方
    tempimg.GetImage(tempback, Fs, 0);

    //if fw > Width then fw := fw - width else fw := 0;
   // tempimg.GetImage(tempback, fw, 0);
    ADXForm.Surface.DrawImage(tempback, R.Left, R.Top, true);
  finally
    tempimg.Free;
    tempback.Free;
  end;

end;

constructor TA2ChatEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHaveChatItem := false;
  FSelectedChatItemPos := -1;
  FSelectedChatItemPos := -1;
  self.FChatItemFontColor := ColorSysToDxColor(clyellow);
end;

procedure TA2ChatEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if key = VK_BACK then
  begin
    if self.Text = '' then
      self.FHaveChatItem := false;
  end;
end;

procedure TA2ChatEdit.SelfKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited SelfKeyDown(Sender, Key, Shift);

end;

{ TA2ChatListBox }

function TA2ChatListBox.AddObject(const S: string;
  AObject: TObject): Integer;
begin
  Result := self.FStringList.AddObject(s, AObject);
end;

procedure TA2ChatListBox.DrawItem;
var
  i, xx, yy, fx, fy, f, n
    : integer;
  R: TRect;
  TmpImg: TA2Image;
  DIS: TDrawItemState;    
  col: integer;
  fcol, bcol: word;
  colf: integer;
  fcolf, bcolf: word;
  tmpItemData: TChatItemData;
  _chattmp, _username: string;
  _chattmpwidth: integer;
  _chattmppos, _chatfirstpos, _chatsecondpos: integer;
  text: string;
  tobj: TObject;
  clicked: Boolean;
  tmpobj: TObject;
  Filter: Boolean;
begin
  if (Width <> FBackScreen.Width)
    or (Height <> FBackScreen.Height) then
  begin
    FBackScreen.Free;
    FBackScreen := TA2Image.Create(Width, Height, 0, 0);
  end;
  FBackScreen.Clear(0);
  xx := FItemMerginX;
  yy := FItemMerginY;
    //背景
  if FSurface <> nil then FBackScreen.DrawImage(FSurface, 0, 0, TRUE);
    //滑动 背景
  if FScrollBarView then
    TmpImg := TA2Image.Create(Width - ScrollBarWidth - FItemMerginX, ItemHeight + 2, 0, 0)
  else
    TmpImg := TA2Image.Create(Width - (FItemMerginX * 2), ItemHeight + 2, 0, 0);

    //内容
  for i := FViewIndex to ViewItemCount + FViewIndex - 1 do
  begin
    tmpItemData := nil;
    if (i < 0) or (i > FStringList.Count - 1) then break;
    if i = FMouseSelectItemIndex then DIS := TIS_MouseSelect else DIS := TIS_None;
    if FStringList.Objects[i] <> nil then
    begin

{$IFNDEF TESTBREAK}

      try


        if FStringList.Objects[i] is TChatItemData then
        begin
          tmpItemData := TChatItemData(FStringList.Objects[i]);
          fcol := tmpItemData.FColor;
          bcol := tmpItemData.BColor;
          tobj := pointer(MakeLong(fcol, bcol));
          Col := Integer(tobj);
          fcol := LOWORD(Col);
          bcol := HIWORD(col);
        end else if (FStringList.Objects[i] is TChatColor) then
        begin

          col := TChatColor(FStringList.Objects[i]).Col;

          fcol := LOWORD(Col);
          bcol := HIWORD(col);
        end;

      except
       //、   raise Exception.CreateFmt('%s %d', ['错误代码:', 999]);
        col := Integer(FStringList.Objects[i]);
        fcol := LOWORD(Col);
        bcol := HIWORD(col);
      end;

{$ENDIF}
    end else
    begin
      fcol := FFontColor;
      bcol := 0;
    end;

    if (i = FItemIndex) or (i = self.FMouseSelectItemIndex) then
    begin
      if FItemIndexViewState then
      begin
        if i = FMouseSelectItemIndex then
        begin
          if FFontMovColor <> 31 then fcol := FFontMovColor;
        end
        else
        begin
          if FFontSelColor <> 31 then fcol := FFontSelColor;
        end;
        TmpImg.Clear(FFontSelBACKColor);
      end else TmpImg.Clear(bcol);
      if dis = TIS_MouseSelect then
        dis := TIS_Select_and_MouseSelect
      else DIS := TIS_Select;
    end else
    begin
      TmpImg.Clear(bcol);
    end;

        //  R := Rect(0, 0, TmpImg.Width, TmpImg.Height);

    fx := 0;
    fy := 0;
    if FLayout <> tlTop then
    begin
      if FLayout = tlBottom then
        fy := ItemHeight - ATextHeight(FStringList[i])
      else
        fy := (ItemHeight - ATextHeight(FStringList[i])) div 2;
    end;
    clicked := false;
    if FMouseViewState then
      if ((DIS = TIS_MouseSelect) or (DIS = TIS_Select_and_MouseSelect)) then

        clicked := True;
    if tmpItemData <> nil then
    begin
    //  inc(yy,2);
      text := FStringList[i];

      _chattmppos := pos('] : ', text);
      if _chattmppos = 0 then
      begin
          ///FontColor:=ColorSysToDxColor($001C1C1C);
        _chattmppos := pos(': ', text);

          //普通区域聊天

        _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length(': ') - 2;
        if _chattmppos = 0 then
        begin
          _chattmppos := pos('> ', text);
          _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length('> ') - 2;
          if _chattmppos = 0 then
          begin
            _chattmppos := pos('" ', text);
            _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length('" ') - 2;
          end;

        end;
        _username := '[' + tmpItemData.ItemName + ']';
      end else
      begin
          //呐喊
        _username := '[' + tmpItemData.ItemName + ']';
        _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length('] : ') - 1;
      end;

      _chattmp := copy(text, 1, _chatfirstpos);
      _chattmpwidth := ATextWidth(_chattmp);
      if fcol = 0 then
        fcol := 32767;
      if FEmphasis then
        ATextOut(TmpImg, fx + 1, fy + 1, WinRGB(3, 3, 3), _chattmp)
      else
        ATextOut(TmpImg, fx, fy, fcol, _chattmp);
      ATextOut(TmpImg, fx + _chattmpwidth, fy, tmpItemData.ChatItemFontColor, _username);
      _chattmpwidth := _chattmpwidth + ATextWidth(_username);
      _chattmp := copy(text, _chatfirstpos + 1, 255);
      if FEmphasis then
        ATextOut(TmpImg, fx + 1 + _chattmpwidth, fy + 1, WinRGB(3, 3, 3), _chattmp)
      else
        ATextOut(TmpImg, fx + _chattmpwidth, fy, fcol, _chattmp);
      if clicked then
      begin
        _chattmppos := pos('] : ', text);
        if _chattmppos = 0 then
        begin
          ///FontColor:=ColorSysToDxColor($001C1C1C);
          _chattmppos := pos(': ', text);

          //普通区域聊天
          _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length(': ') - 2;
          if _chattmppos = 0 then
          begin
            _chattmppos := pos('> ', text);
            _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length('> ') - 2;
            if _chattmppos = 0 then
            begin
              _chattmppos := pos('" ', text);
              _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length('" ') - 2;
            end;
          end;
          _username := '[' + tmpItemData.ItemName + ']';
        end else
        begin
          //呐喊
          _username := '[' + tmpItemData.ItemName + ']';
          _chatfirstpos := tmpItemData.ItemPos + _chattmppos + length('] : ') - 1;
        end;

        _chattmp := copy(text, 1, _chatfirstpos);
        _chattmpwidth := ATextWidth(_chattmp);
        if fcol = 0 then
          fcol := 32767;
        if FEmphasis then
          ATextOut(TmpImg, fx + 1, fy + 1, WinRGB(3, 3, 3), _chattmp)
        else
          ATextOut(TmpImg, fx + 1, fy, fcol, _chattmp);
        ATextOut(TmpImg, fx + _chattmpwidth + 1, fy, tmpItemData.ChatItemFontColor, _username);
        _chattmpwidth := _chattmpwidth + ATextWidth(_username);
        _chattmp := copy(text, _chatfirstpos + 1, 255);
        if FEmphasis then
          ATextOut(TmpImg, fx + 1 + _chattmpwidth, fy + 1, WinRGB(3, 3, 3), _chattmp)
        else
          ATextOut(TmpImg, fx + 1 + _chattmpwidth, fy, fcol, _chattmp);
      end;
    end else
    begin
      if FEmphasis then ATextOut(TmpImg, fx + 1, fy + 1, WinRGB(3, 3, 3), FStringList[i]);
      ATextOut(TmpImg, fx, fy, fcol, FStringList[i]);
    end;
    if FMouseViewState then
      if ((DIS = TIS_MouseSelect) or (DIS = TIS_Select_and_MouseSelect)) and (tmpItemData = nil) then
      begin
        ATextOut(TmpImg, fx + 1, fy, fcol, FStringList[i]);
      end;
    if Assigned(FOnAdxDrawItem) then
      FOnAdxDrawItem(TmpImg, i, FStringList[i], R, DIS, fx, fy);

    FBackScreen.DrawImage(TmpImg, xx, yy, TRUE);
   ///  if tmpItemData <> nil then
     //  inc(yy, FItemHeight+2)else
    inc(yy, FItemHeight);
  end;
  TmpImg.Free;
  if FScrollBarView then DrawScrollBar();
  if Assigned(FAdxForm) then
    AdxPaint
  else
    Paint;

  if assigned(ADXForm) then ADXForm.Draw;
end;

{ TChatItemData }

constructor TChatItemData.Create;
begin
  HaveItem := False;

  HaveItemColor := False;
  self.FColor := 0;
  self.BColor := 0;
  ChatItemFontColor := ColorSysToDxColor(clyellow);
end;

end.

