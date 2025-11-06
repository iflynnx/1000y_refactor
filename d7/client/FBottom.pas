unit FBottom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  adeftype, deftype, StdCtrls, A2Form, ExtCtrls, Autil32, A2Img, CharCls,
  Gauges, Buttons, Cltype, ctable, log, ActozZip, clmap, uAnsTick,
  AtzCls, uPerSonBat, tilecls, objcls, Math;

const
  CMM_Close = 1;

type

  TFrmBottom = class(TForm)
    Image1: TImage;
    PGEnergy: TGauge;
    PGInPower: TGauge;
    PgOutPower: TGauge;
    PgMagic: TGauge;
    PgLife: TGauge;
    BtnItem: TSpeedButton;
    BtnMagic: TSpeedButton;
    BtnMystery: TSpeedButton;
    BtnSkill: TSpeedButton;
    BtnExit: TSpeedButton;
    LbChat: TListBox;
    EdChat: TEdit;
    LbPos: TLabel;
    BtnSelMagic: TA2Button;
    BtnWAttrib: TA2Button;
    BtnBestMagic: TSpeedButton;
    UseMagic1: TLabel;
    UseMagic2: TLabel;
    UseMagic3: TLabel;
    UseMagic4: TLabel;
    lblShortcut0: TA2ILabel;
    lblShortcut1: TA2ILabel;
    lblShortcut2: TA2ILabel;
    lblShortcut3: TA2ILabel;
    lblShortcut4: TA2ILabel;
    lblShortcut5: TA2ILabel;
    lblShortcut6: TA2ILabel;
    lblShortcut7: TA2ILabel;
    EdChatX: TEdit;
    PGSkillLevel1: TGauge;
    PGSkillLevel2: TGauge;
    procedure FormCreate(Sender: TObject);
    procedure LBChatDrawItem(Control: TWinControl; Index: Integer; Rect:
      TRect; State: TOwnerDrawState);
    procedure EdChatKeyDown(Sender: TObject; var Key: Word; Shift:
      TShiftState);
    procedure EdChatKeyPress(Sender: TObject; var Key: Char);
    procedure EdChatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnItemClick(Sender: TObject);
    procedure BtnMagicClick(Sender: TObject);
    procedure BtnMysteryClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnSkillClick(Sender: TObject);
    procedure BtnItemMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
      Integer);
    procedure BtnWAttribClick(Sender: TObject);
    procedure BtnSelMagicClick(Sender: TObject);
    procedure EdChatEnter(Sender: TObject);
    procedure LbChatMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure LbChatClick(Sender: TObject);
    procedure LbChatEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnBestMagicClick(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure lblShortcutClick(Sender: TObject);
    procedure lblShortcutDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lblShortcutDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lblShortcutMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure EdChatXEnter(Sender: TObject);
    procedure lblShortcutStartDrag(Sender: TObject;
      var DragObject: TDragObject);
  private
    { Private declarations }
    procedure capture(bitmap: Tbitmap);
  public
    ChatHistoryList: TStringList;
    ChatHistoryListIndex: Integer;
    UseMagicList: array[0..3] of TLabel;
    procedure AddEventString(const str: string; CurTick: integer);
    procedure EventTickProcess(CurTick: integer);
  public
    lblShortcut: array[0..7] of TA2ILabel;
    ShortcutIndex: array[0..7] of record
      rShape: integer;
      rMagicName: string[19];
    end;
    procedure ClearShortcut(index: integer);
  public
    { Public declarations }
    curlife, maxlife: integer;
    procedure MessageProcess(var code: TWordComData);
    procedure SetFormText;

    // 率瘤 汲沥
    procedure SetPaper(const str: string);
    procedure GetMessenger(const strTime, strMsg: string);
    //procedure SetNewVersion(); override;
    procedure ClientCapture(atime: string);
    procedure SetSkillLevelGauge(strValue: string);
    procedure changeBack();
  end;

var
  FrmBottom: TFrmBottom;
  chat_outcry, chat_Guild, chat_notice, chat_normal, chat_faction: Boolean;
  MapName: string;
  CloseFlag: Boolean = FALSE;
  boXKeyMode: Boolean = FALSE;

implementation

uses
  FMain, FLogOn, FAttrib, FExchange, FSound, FDepository,
  FBatList, FMuMagicOffer, FMiniMap, FcMessageBox, FHistory,
  FPassEtc, BackScrn, FHelp, FItemHelp, FNPCTrade, FSkill, DXDraws,
  FCharAttrib;

{$R *.DFM}

function Get10000To100(avalue: integer): string;
var
  n: integer;
  str: string;
begin
  str := InttoStr(avalue div 100) + '.';
  n := avalue mod 100;
  if n >= 10 then
    str := str + IntToStr(n)
  else
    str := str + '0' + InttoStr(n);

  Result := str;
end;

procedure TFrmBottom.SetFormText;
begin
  // FrmBottom Set Font
  FrmBottom.Font.Name := mainFont;
  //   ListboxUsedMagic.Font.Name := mainFont;
  LbChat.Font.Name := mainFont;
  EdChat.Font.Name := mainFont;
  LbPos.Font.Name := mainFont;
  chat_outcry := TRUE;
  chat_Guild := TRUE;
  chat_notice := TRUE;
  chat_normal := TRUE;
  //Author:Steven Date: 2004-10-11 11:32:51
  //Note:
  chat_faction := True;

  BtnItem.Hint := Conv('物品');
  BtnMagic.Hint := Conv('武功');
  BtnMystery.Hint := Conv('掌法');
  BtnBestMagic.Hint := Conv('绝世武功');
  BtnSkill.Hint := Conv('技术');
  BtnExit.Hint := Conv('终止游戏');
end;

procedure TFrmBottom.changeBack;
var
  i: integer;
  str: string;
begin
  Color := clBlack;
  Parent := FrmM;
   if G_Default800 then
  begin
    Top := fheight600 - Height;
  end else
  begin
    Top := fhei - Height + 3;
  end;

end;

procedure TFrmBottom.FormCreate(Sender: TObject);
var
  i: integer;
  str: string;
begin
  Color := clBlack;
  Parent := FrmM;

  if G_Default800 then
  begin
    Top := fheight600 - Height;
  end else
  begin
    Top := fhei - Height + 3;
  end;
  Left := 0;
  //Top := 768 - Height;
  SetFormText;
  MapName := '';
  //   SetHotkey;
  LbChat.AddItem('', TObject(0));
  LbChat.AddItem('', TObject(0));
  LbChat.AddItem('', TObject(0));
  LbChat.AddItem('', TObject(0));

  UseMagicList[0] := UseMagic1;
  UseMagicList[1] := UseMagic2;
  UseMagicList[2] := UseMagic3;
  UseMagicList[3] := UseMagic4;

  for i := 0 to 7 do
  begin
    lblShortcut[i] := TA2ILabel(FindComponent(Format('lblShortcut%d', [i])));
    //      str := ClientIni.ReadString('KEYSET', IntToStr(i+1), '');

    with ShortcutIndex[i] do
    begin
      rMagicName := ''; //GetValidStr4(str, ',');
      rShape := 0; // _StrToInt(str);
      //         if rShape > 0 then
      //            lblShortcut[i].A2Image := AtzClass.GetMagicImage(rShape);
    end;
  end;
  ChatHistoryList := TStringList.Create;
  ChatHistoryListIndex := -1;
end;



procedure TFrmBottom.FormDestroy(Sender: TObject);
var
  i: integer;
  str: string;
begin
  //   for i := 0 to 7 do begin
  //      str := Format('%s,%d', [ShortcutIndex[i].rMagicName, ShortcutIndex[i].rShape]);
  //      ClientIni.WriteString('KEYSET', IntToStr(i+1), str);
  //   end;
  ChatHistoryList.Free;
end;

procedure TFrmBottom.MessageProcess(var code: TWordComData);
var
  str, rdstr: string;
  i: integer;
  pckey: PTCKey;
  psAttribBase: PTSAttribBase;
  psAttriblife: PTSAttribLife;
  psEventString: PTSEventString;
  psMessenger: PTSMessenger;
begin
  pckey := @Code.Data;
  case pckey^.rmsg of
    SM_USEDMAGICSTRING:
      begin
        psEventString := @Code.data;

        str := GetWordString(psEventString^.rWordString);

        for i := 0 to 3 do
        begin
          rdstr := GetValidStr4(str, ',');
          UseMagicList[i].Caption := rdstr;
          UseMagicList[i].Tag := 0;
        end;
        // 公傍荐访 霸捞瘤官
        if UseMagicList[0].Caption <> '' then
        begin
          str := frmAttrib.GetMagicSkillLevel(UseMagicList[0].Caption);
          SetSkillLevelGauge(str);
        end;
      end;
    SM_ATTRIBBASE:
      begin
        psAttribBase := @Code.Data;
        with psAttribBase^ do
        begin
          // 劝仿
          maxlife := rlife;
          curlife := rcurlife;

          // 盔扁
          if rEnergy < rCurEnergy then
          begin
            // 盔扁坷滚矫
            PgEnergy.BackColor := $00444444;
            PgEnergy.ForeColor := $00444488;
            PGEnergy.MaxValue := rEnergy;
            PGEnergy.Progress := rCurEnergy - rEnergy;
          end
          else
          begin
            // 老馆利牢版快
            PgEnergy.BackColor := clBlack;
            PgEnergy.ForeColor := $00444444;
            PGEnergy.MaxValue := rEnergy;
            PGEnergy.Progress := rCurEnergy;
          end;
          PGEnergy.Hint := Get10000To100(rCurEnergy) + '/' +
            Get10000To100(rEnergy);

          PGInPower.MaxValue := rInPower;
          PGInPower.Progress := rCurInPower;
          PGInPower.Hint := Get10000To100(rCurInPower) + '/' +
            Get10000To100(rInPower);

          PGOutPower.MaxValue := rOutPower;
          PGOutPower.Progress := rCurOutPower;
          PGOutPower.Hint := Get10000To100(rCurOutPower) + '/' +
            Get10000To100(rOutPower);

          PGMagic.MaxValue := rMagic;
          PGMagic.Progress := rCurMagic;
          PGMagic.Hint := Get10000To100(rCurMagic) + '/' +
            Get10000To100(rMagic);

          PGLife.MaxValue := maxlife;
          PGLife.Progress := curlife;
          PGLife.Hint := Get10000To100(curlife) + '/' +
            Get10000To100(maxlife);

          frmAttrib.LbAge.Caption := Get10000To100(psAttribBase^.rAge);
        end;

        frmCharAttrib.MessageProcess(Code);
      end;
    SM_ATTRIB_LIFE:
      begin
        psAttribLife := @Code.Data;
        curlife := psAttribLife^.rcurlife;
        PGLife.Progress := curlife;
        PGLife.Hint := IntToStr(curlife) + '/' + IntToStr(maxlife);
      end;
    SM_MESSENGER:
      begin
        psMessenger := @Code.Data;
        str := StrPas(@psMessenger.rTime);
        rdstr := GetWordString(psMessenger.rWordString);
        GetMessenger(str, rdstr);
      end;
  end;
end;

procedure TFrmBottom.GetMessenger(const strTime, strMsg: string);
var
  str, rdstr: string;
  MsgType: char;
  n: integer;
begin
  str := strMsg;
  rdstr := GetValidStr4(str, ' ');
  if str = '' then
    exit;

  n := Length(rdstr);
  str := rdstr + ' ' + ChangeDontSay(str);

  MsgType := rdstr[n];
  Delete(rdstr, n, 1);

  case MsgType of
    '>': // 罐绰 皋技瘤...
      with ChatMan do
      begin
        AddUser(rdstr);
        AddChat(str, WinRGB(22, 22, 0), 0);
      end;
    '"': // 焊郴绰 皋技瘤...
      with ChatMan do
      begin
        AddUser(rdstr, true);
        AddChat(str, WinRGB(18, 17, 0), 0);
      end;
  end;
end;

function savefilename: string;
var
  year, mon, day, hour, min, sec, dummy: word;
  str: string;
  function num(n: integer): string;
  begin
    Result := '';
    if n >= 10 then
      Result := IntToStr(n)
    else
      Result := '0' + InttoStr(n);
  end;
begin
  str := '';
  DecodeDate(Date, year, mon, day);
  DecodeTime(Time, hour, min, sec, dummy);
  str := num(year) + Conv('年') + num(mon) + Conv('月') + num(day) +
    Conv('日');
  str := str + num(hour) + Conv('时') + num(min) + Conv('分') + num(sec) +
    Conv('秒');
  Result := str;
end;

function DirExists(Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

procedure TFrmBottom.capture(bitmap: Tbitmap);
var
  FrmMRect: TRect;
  FrmMDC: HDC;
  FrmMDCcanvas: TCanvas;
begin
  BitMap.Width := FrmM.Width;
  BitMap.Height := FrmM.Height;
  FrmMRect := Rect(0, 0, FrmM.Width, FrmM.Height);

  FrmMDC := GetWindowDC(FrmM.Handle);
  FrmMDCcanvas := TCanvas.Create;
  FrmMDCcanvas.Handle := FrmMDC;
  Bitmap.Canvas.CopyRect(FrmMRect, FrmMDCcanvas, FrmMRect);
  ReleaseDC(FrmM.Handle, FrmMDC);
  FrmMDCcanvas.Free;
end;

// change by minds 030210

procedure TFrmBottom.ClientCapture(atime: string);
var
  abitmap: TBitmap;
  CIBfile: TCIBfile;
  str: string;
begin
  abitmap := TBitmap.Create;
  capture(abitmap);
  if DirExists('.\capture') then
  else
    Mkdir('.\' + 'capture');
  str := SaveFileName;
  aBitMap.SaveToFile('.\capture\' + str + '.bmp');

  CIBfile := TCIBfile.Create(aBitmap, ChatMan.SaveChatList, CharCenterName,
    Map.GetMapName, ReConnectIpAddr, aTime);
  CIBFile.SaveToFile(Format('.\capture\%s.cib', [str]));
  CIBfile.Free;
  abitmap.Free;
  ChatMan.AddChat(Conv('截图（') + str + ')', $FFFF, 0);
end;

var
  LbChatClickFlag: Boolean = TRUE;

  /////////////////////////////// LbChat events //////////////////////////////////

procedure TFrmBottom.LbChatClick(Sender: TObject);
begin
  //   Sleep (300);
  if LbChatClickFlag then
    boShowChat := not boShowChat;
end;

procedure TFrmBottom.LBChatDrawItem(Control: TWinControl; Index: Integer; Rect:
  TRect; State: TOwnerDrawState);
var
  cIndex, col: integer;
  fcol, bcol, r, g, b: word;
begin
  cIndex := Index;
  col := 0;
  with ChatMan.SaveChatList do
  begin
    if Count >= 4 then
      cIndex := Count - 4 + Index;
    if cIndex < Count then
      col := Integer(Objects[cIndex]);
  end;

  fcol := LOWORD(Col);
  bcol := HIWORD(col);

  WinVRGB(bcol, r, g, b);
  r := r * 8;
  g := g * 8;
  b := b * 8;
  LbChat.Canvas.Brush.Color := RGB(r, g, b);
  LBChat.Canvas.FillRect(Rect);

  if cIndex < ChatMan.SaveChatList.Count then
  begin
    WinVRGB(fcol, r, g, b);
    r := r * 8;
    g := g * 8;
    b := b * 8;
    LbChat.Canvas.Font.Color := RGB(r, g, b);
    LBChat.Canvas.TextOut(Rect.left, Rect.top, ChatMan.SaveChatList[cIndex]);
  end;

end;

procedure TFrmBottom.LbChatMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  EdChat.SetFocus;
end;

/////////////////////////////// EdChat events //////////////////////////////////

procedure TFrmBottom.EdChatEnter(Sender: TObject);
begin
  if EdChat.ReadOnly then
    EdChatX.SetFocus
  else
    SetImeMode(EdChat.Handle, 1);
end;

procedure TFrmBottom.EdChatKeyDown(Sender: TObject; var Key: Word; Shift:
  TShiftState);
const
  KeyDownTick: DWORD = 0;
var
  Cl: TCharClass;
  cKey: TCKey;
  cnt: integer;
  str: string;
  i: integer;
  Params: array[0..10] of string;
  cSay: TCSay;
  cSelectHelp: TCSelectHelpWindow;
begin
  // change by minds 1222
  if key = VK_ESCAPE then
  begin
    EdChat.Text := '';
    exit;
  end;

  if ssAlt in Shift then
  begin
    case Key of
      // 窜绵虐 '~123456'
      192:
        begin
          if FrmAttrib.Visible then
            FrmAttrib.Visible := False;
          if FrmSkill.Visible then
            FrmSkill.Visible := False;
          if frmMiniMap.Visible then
            FrmMiniMap.SetPosition;
        end;
      Word('1'): frmAttrib.PanelSelect(1, Conv('物品'));
      Word('2'): frmAttrib.PanelSelect(2, Conv('武功'));
      Word('3'): frmAttrib.PanelSelect(3, Conv('基本武功'));
      Word('4'): frmAttrib.PanelSelect(4, Conv('上层武功'));
      Word('5'), Word('Q'): frmAttrib.PanelSelect(5, Conv('掌法'));
      Word('6'), Word('W'): frmAttrib.PanelSelect(6, Conv('绝世武功'));
      Word('7'), Word('S'): BtnSkill.OnClick(Self);

      // 窜绵虐葛靛
      Word('K'):
        begin
          if boXKeyMode then
          begin
            EdChat.ReadOnly := False;
            boXKeyMode := False;
            EdChat.SetFocus;
          end
          else
          begin
            EdChat.ReadOnly := True;
            boXKeyMode := True;
            EdChatX.SetFocus;
          end;
        end;

      // 矛变臂 扁瓷
      Word('C'):
        begin
          if not frmHistory.Visible then
            frmHistory.ShowHistory
          else
            frmHistory.HideHistory;
        end;

      Word('I'):
        begin
          if frmCharAttrib.Visible then
            frmCharAttrib.Visible := False
          else
            frmM.ShowA2Form(frmCharAttrib);
        end;
      // 固聪甘 窜绵虐
      Word('M'):
        begin
          if FrmMiniMap.Visible then
          begin
            FrmMiniMap.Visible := not FrmMiniMap.Visible;
            FrmMiniMap.NPCClear;
            exit;
          end;
          cKey.rmsg := CM_MINIMAP;
          cKey.rkey := 0;
          FrmLogOn.SocketAddData(sizeof(cKey), @cKey);
        end;
      // 辆丰 窜绵虐
      Word('X'):
        begin
          FrmcMessageBox.CMMessageProcess(CMM_Close);
        end;

      // 拳搁 葛靛函券 窜绵虐
      VK_RETURN:
        begin
          FrmM.SaveAndDeleteAllA2Form;
          FrmM.DXDraw.Finalize;
          if doFullScreen in FrmM.DXDraw.Options then
          begin
            FrmM.BorderStyle := bsSingle;
            FrmM.ClientWidth := 1024;
            FrmM.ClientHeight := 768;
            FrmM.DXDraw.Options := FrmM.DXDraw.Options - [doFullScreen];
          end
          else
          begin
            FrmM.BorderStyle := bsNone;
            FrmM.ClientWidth := 1024;
            FrmM.ClientHeight := 768;
            FrmM.DXDraw.Options := FrmM.DXDraw.Options + [doFullScreen];
          end;
          FrmM.DXDraw.Initialize;
          FrmM.RestoreAndAddAllA2Form;
          exit;
        end;
    end;
  end
  else if ssCtrl in Shift then
  begin
    case Key of
      Word('1'): lblShortcut0.OnClick(lblShortcut0);
      Word('2'): lblShortcut1.OnClick(lblShortcut1);
      Word('3'): lblShortcut2.OnClick(lblShortcut2);
      Word('4'): lblShortcut3.OnClick(lblShortcut3);
      Word('5'), Word('Q'): lblShortcut4.OnClick(lblShortcut4);
      Word('6'), Word('W'): lblShortcut5.OnClick(lblShortcut5);
      Word('7'), Word('E'): lblShortcut6.OnClick(lblShortcut6);
      Word('8'), Word('R'): lblShortcut7.OnClick(lblShortcut7);
      VK_UP:
      begin
        if (ChatHistoryListIndex < ChatHistoryList.Count) and (ChatHistoryList.Count <> 0) then
        begin
          if ChatHistoryListIndex < ChatHistoryList.Count - 1 then
            Inc(ChatHistoryListIndex);
          EdChat.Text := ChatHistoryList.Strings[ChatHistoryListIndex];
          EdChat.Focused;
          EdChat.SelStart := Length(EdChat.Text);
        end;
      end;
      VK_DOWN:
        if (ChatHistoryListIndex > -1) and (ChatHistoryList.Count <> 0) then
        begin
          EdChat.Text := ChatHistoryList.Strings[ChatHistoryListIndex];
          EdChat.Focused;
          EdChat.SelStart := Length(EdChat.Text);
          Dec(ChatHistoryListIndex);
        end else
          if ChatHistoryListIndex = -1 then
            EdChat.Text := '';
    end;
  end
  else if EdChat.ReadOnly then
  begin
    if ssShift in Shift then
    begin
      case Key of
        Word('1'): str := '!';
        Word('2'): str := '@';
        Word('3'): str := '#';
        Word('5'): str := '%';
      else
        str := '';
      end;
      if str <> '' then
      begin
        EdChat.ReadOnly := False;
        EdChat.SetFocus;
        EdChat.Text := str;
        EdChat.SelStart := 1;
        exit;
      end;
    end;
    case Key of
      Word('1'): lblShortcut0.OnClick(lblShortcut0);
      Word('2'): lblShortcut1.OnClick(lblShortcut1);
      Word('3'): lblShortcut2.OnClick(lblShortcut2);
      Word('4'): lblShortcut3.OnClick(lblShortcut3);
      Word('5'), Word('Q'): lblShortcut4.OnClick(lblShortcut4);
      Word('6'), Word('W'): lblShortcut5.OnClick(lblShortcut5);
      Word('7'), Word('E'): lblShortcut6.OnClick(lblShortcut6);
      Word('8'), Word('R'): lblShortcut7.OnClick(lblShortcut7);
      VK_RETURN:
        begin
          EdChat.ReadOnly := False;
          EdChat.SetFocus;
          exit;
        end;
    end;
  end;

  if (not (ssCtrl in Shift) and (key = VK_UP)) or
     (not (ssCtrl in Shift) and (key = VK_DOWN)) then
  begin
    if StrLComp(PChar(EdChat.Text), PChar(Conv('@纸条')), 5) = 0 then
    begin
      str := Copy(EdChat.Text, 7, 20);
      cnt := Pos(' ', str);
      if cnt > 0 then
      begin
        Delete(str, cnt, 20);

        case key of
          VK_UP: str := ChatMan.GetPrevUser(str);
          VK_DOWN: str := ChatMan.GetNextUser(str);
        end;

        if str <> '' then
          SetPaper(str);
      end;
    end
    else if EdChat.Text = '' then
    begin
      str := ChatMan.GetLastUser;
      SetPaper(str);
    end;
    key := 0;
    exit;
  end;

  if (key = 191) and not (ssShift in Shift) then
  begin //
    if EdChat.ReadOnly then
    begin
      EdChat.ReadOnly := False;
      EdChat.SetFocus;
      EdChat.Text := '/';
      EdChat.SelStart := 1;
      exit;
    end;
  end;

  if (key = VK_RETURN) and (EdChat.Text <> '') then
  begin // Send SayData
    str := EdChat.Text;

    if ChatHistoryList.Count < 50 then
      ChatHistoryList.Insert(0, Str)
    else
    begin
      ChatHistoryList.Delete(ChatHistoryList.Count - 1);
      ChatHistoryList.Insert(0, Str);
    end;
    ChatHistoryListIndex := -1;

    for i := 0 to 10 do
    begin
      Params[i] := GetValidStr4(str, ' ');
    end;



{$IFDEF _DEBUG}
    // object debug侩
    if CompareText(Params[0], '@load') = 0 then
    begin
      AtzClass.FreeImageLib(Params[1]);
    end
    else if CompareText(Params[0], '@setpx') = 0 then
    begin
      AtzClass.SetPX(Params[1], _StrToInt(Params[2]));
    end
    else if CompareText(Params[0], '@setpy') = 0 then
    begin
      AtzClass.SetPY(Params[1], _StrToInt(Params[2]));
    end
    else if CompareText(Params[0], '@save') = 0 then
    begin
      AtzClass.SavePXPY(Params[1]);
    end
    else if CompareText(Params[0], '@grid on') = 0 then
    begin
      bGridOn := True;
    end
    else if CompareText(Params[0], '@grid off') = 0 then
    begin
      bGridOn := False;
    end
    else if CompareText(Params[0], '@automove') = 0 then
    begin
      if Params[1] = '' then
        bTestMove := False
      else
      begin
        bTestMove := True;
        strAutoMove := Params[1];
      end;
    end
    else
      //      if CompareText(Params[0], '@resource') = 0 then begin
      //         boShowResource := not boShowResource;
      if CompareText(Params[0], '@earthquake') = 0 then
      begin
        BackScreen.AddEarthquake(40, 4);
      end
      else
        //      if CompareText(Params[0], '@movedelay') = 0 then begin
        //         Cl := CharList.GetChar (CharCenterId);
        //         if Cl = nil then exit;
        //         cl.SetMove5Delay(_StrToInt(Params[1]));
        if CompareText(Params[0], '@loadatd') = 0 then
        begin
          Animater.ReloadAnimation(Params[1]);
        end
        else
          //      if CompareText(Params[0], '@shift') = 0 then begin
          //         setAutoShift := 0;
          //      end else
          //      if CompareText(Params[0], '@noshift') = 0 then begin
          //         setAutoShift := 1;
          //      end else
          //      if CompareText(Params[0], '@noctrl') = 0 then begin
          //         setAutoShift := 2;
          if CompareText(Params[0], '@shadow') = 0 then
          begin
            bShadowDraw := True;
          end
          else if CompareText(Params[0], '@noshadow') = 0 then
          begin
            bShadowDraw := False;
          end
          else if CompareText(Params[0], '@分离信息') = 0 then
          begin //这个的中文,是属于调试信息部分,
            with ChatMan do
            begin //是李明玄临时译上去的,上下文关系
              if bSideMessage then
              begin //不清楚
                AddChat('分离信息 设置', NoticeColor, 0);
                bSideMessage := False;
              end
              else
              begin
                AddChat('分离信息 解除', NoticeColor, 0);
                bSideMessage := True;
              end;
            end;
          end
          else if CompareText(Params[0], '@stone') = 0 then
          begin
            CharList.__DrawGuildNameFontTest(StrToInt(Params[1]),
              StrToInt(Params[2]), StrToInt(Params[3]), StrToInt(Params[4]),
              StrToInt(Params[5]), StrToInt(Params[6]));
          end
          else if StrLComp(PChar(EdChat.Text), '@showchar', 9) = 0 then
          begin
            bShowCharList := not bShowCharList;
          end
          else
            //      if CompareText(Params[0], '@烤朝焊过') = 0 then begin
            //         bOldMove := not bOldMove;
            //      end else
{$ENDIF}if CompareText(Params[0], '@pmclear') = 0 then
            begin
              PacketMaxCount := 0;
            end
            else if CompareText(Params[0], '@fontclear') = 0 then
            begin
              //A2FontClass.Clear;
            end
            else
            begin
              cSay.rmsg := CM_SAY;
              str := EdChat.Text;
              SetWordString(cSay.rWordString, str);
              cnt := sizeof(cSay) - sizeof(TWordString) +
                SizeOfWordString(cSay.rWordString);
              FrmLogon.SocketAddData(cnt, @csay);
              //         Connector.SendData(@csay, cnt)
            end;
  end;

  if key = VK_RETURN then
  begin // EdChat.Text Clear
    EdChat.Text := '';
    if boXKeyMode then
    begin
      EdChat.ReadOnly := True;
      EdChatX.SetFocus;
    end;
    exit;
  end;

  Keyshift := Shift;

  if mmAnsTick < integer(KeyDownTick) + 25 then
    exit;
  KeyDownTick := mmAnsTick;

  case key of
    VK_F1:
      begin
              G_Default800 := not G_Default800;//true    not G_Default1024
              FrmM.changeScreen;

        //cSelectHelp.rMsg := CM_SELECTHELPWINDOW;
        //SetWordString(cSelectHelp.rSelectKey, 'open');
        //cnt := sizeof(cSelectHelp) - sizeof(TWordString) +
          //SizeOfWordString(cSelectHelp.rSelectKey);
        //FrmLogon.SocketAddData(cnt, @cSelectHelp);
        //            Connector.SendData(@cSelectHelp, cnt)
      end;

    VK_F5: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[0]);
    VK_F6: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[1]);
    VK_F7: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[2]);
    VK_F8: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[3]);
    VK_F9: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[4]);
    VK_F10: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[5]);
    VK_F11: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[6]);
    VK_F12: if not (KeyFlag) then
        FrmAttrib.keyProcess(Keybuffer[7]);
  else
    begin
      if key in [VK_F2, VK_F3, VK_F4] then
      begin
        ckey.rmsg := CM_KEYDOWN;
        ckey.rkey := key;
        FrmLogon.SocketAddData(sizeof(Ckey), @Ckey);
        //            Connector.SendData(@cKey, sizeof(TCKey))
      end;
      Cl := CharList.GetChar(CharCenterId);
      if Cl = nil then
        exit;
      if Cl.AllowAddAction = FALSE then
        exit;

      case key of
        VK_F4: //CL.ProcessMessage (SM_MOTION, cl.dir, cl.x, cl.y, cl.feature, AM_HELLO);
          Cl.SetMotion(AM_HELLO);
      end;
    end;
    EdChat.SetFocus;
  end;
end;

procedure TFrmBottom.SetPaper(const str: string);
begin
  if str <> '' then
    EdChat.Text := Conv('@纸条') + Format(' %s ', [str])
  else
    EdChat.Text := Conv('@纸条') + ' ';

  EdChat.ReadOnly := False;
  EdChat.SetFocus;
  EdChat.SelStart := Length(EdChat.Text);
  EdChat.SelLength := 0;
end;

procedure TFrmBottom.EdChatKeyPress(Sender: TObject; var Key: Char);
var
  str: string;
begin
  case key of
    char(VK_RETURN):
      key := char(0);
    char(VK_ESCAPE):
      begin
        key := char(0);
        if frmHistory.Visible then
          frmHistory.Visible := False;
      end;
    char('/'):
      begin
        if EdChat.Text = '/' then
        begin
          str := ChatMan.GetLastSender;
          SetPaper(str);
          key := Char(0);
          exit;
        end;
      end;
  end;
end;

procedure TFrmBottom.EdChatKeyUp(Sender: TObject; var Key: Word; Shift:
  TShiftState);
begin
  Keyshift := Shift;
end;

procedure TFrmBottom.BtnItemClick(Sender: TObject);
begin
  frmAttrib.PanelSelect(1, Conv('物品'));
end;

procedure TFrmBottom.BtnMagicClick(Sender: TObject);
begin
  frmAttrib.PanelSelect(-1, Conv('武功'));
end;

procedure TFrmBottom.BtnMysteryClick(Sender: TObject);
begin
  frmAttrib.PanelSelect(5, Conv('掌法'));
end;

procedure TFrmBottom.BtnBestMagicClick(Sender: TObject);
begin
  frmAttrib.PanelSelect(6, Conv('绝世武功'));
end;

procedure TFrmBottom.BtnExitClick(Sender: TObject);
begin
  FrmcMessageBox.CMMessageProcess(CMM_Close);
end;

procedure TFrmBottom.BtnSkillClick(Sender: TObject);
var
  cKey: TCKey;
begin
  if frmSkill.Visible then
    // 胶懦芒捞 凯妨乐阑版快 摧扁
    frmSkill.Visible := False
  else if not (frmHelp.Visible or frmNPCTrade.Visible or
    frmDepository.Visible or frmExchange.Visible) then
  begin
    // 胶懦芒捞 凯妨乐瘤 臼栏搁 凯扁
    cKey.rmsg := CM_SKILLWINDOW;
    cKey.rkey := 1;
    FrmLogon.SocketAddData(sizeof(TCKey), @cKey);
    //      Connector.SendData(@cKey, sizeof(TCKey))
  end;
end;

procedure TFrmBottom.BtnItemMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
  Integer);
begin
  MouseInfoStr := TSpeedButton(Sender).Hint;
end;

procedure TFrmBottom.BtnWAttribClick(Sender: TObject);
begin
  if FrmMiniMap.Visible then
    FrmMiniMap.Visible := FALSE;
  FrmAttrib.Visible := not FrmAttrib.Visible;
end;

procedure TFrmBottom.BtnSelMagicClick(Sender: TObject);
begin
  FrmSound.Visible := not FrmSound.Visible; // option芒
end;

procedure TFrmBottom.LbChatEnter(Sender: TObject);
begin
  LbChat.OnClick(nil);
  EdChat.SetFocus;
end;

procedure TFrmBottom.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if frmHistory.Visible then
  begin
    with frmHistory.listHistory do
    begin
      if Count > 20 then
      begin
        ViewIndex := Max(ViewIndex - 1, 0);
      end;
    end;
  end;
end;

procedure TFrmBottom.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if frmHistory.Visible then
  begin
    with frmHistory.listHistory do
    begin
      if Count > 20 then
      begin
        ViewIndex := Min(ViewIndex + 1, Count - 20);
      end;
    end;
  end;
end;

procedure TFrmBottom.AddEventString(const str: string; CurTick: integer);
var
  i: integer;
begin
  for i := 0 to 3 do
  begin
    if UseMagicList[i].Caption = str then
      UseMagicList[i].Tag := CurTick;
  end;
end;

procedure TFrmBottom.EventTickProcess(CurTick: integer);
var
  i: integer;
begin
  for i := 0 to 3 do
  begin
    if UseMagicList[i].Tag > 0 then
    begin
      if UseMagicList[i].Tag + 250 < CurTick then
      begin
        UseMagicList[i].Tag := 0;
        UseMagicList[i].Font.Color := clWhite;
      end
      else
      begin
        UseMagicList[i].Font.Color := Random(clWhite);
      end;
    end
    else
    begin
      UseMagicList[i].Font.Color := clWhite;
    end;
  end;
end;

procedure TFrmBottom.lblShortcutClick(Sender: TObject);
var
  strMagicName: string;
  index: integer;
begin
  strMagicName := ShortcutIndex[TA2ILabel(Sender).Tag].rMagicName;
  index := frmAttrib.FindMagicIndex(strMagicName);
  if index < 0 then
  begin
    ShortcutIndex[TA2ILabel(Sender).Tag].rMagicName := '';
    ShortcutIndex[TA2ILabel(Sender).Tag].rShape := 0;
    TA2ILabel(Sender).A2Image := nil;
    TA2ILabel(Sender).Repaint;
  end
  else
  begin
    frmAttrib.keyProcess(index + 51);
  end;
end;

procedure TFrmBottom.lblShortcutDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  A2ILabel: TA2ILabel;
  MagicData: TAttribMagicData;
  index: integer;
begin
  if Source = nil then
    exit;

  case TDragItem(Source).SourceID of
    WINDOW_MAGICS: index := TDragItem(Source).Selected;
    WINDOW_BASICFIGHT: index := TDragItem(Source).Selected + 50;
    WINDOW_RISEMAGICS: index := TDragItem(Source).Selected + 100;
    WINDOW_MYSTERYMAGICS: index := TDragItem(Source).Selected + 150;
    WINDOW_BESTMAGIC: index := TDragItem(Source).Selected + 200;
  else
    exit;
  end;
  MagicData := frmAttrib.MagicData[index];
  A2ILabel := TA2ILabel(Sender);
  A2ILabel.A2Image := AtzClass.GetMagicImage(MagicData.rShape);
  A2ILabel.Repaint;
  ShortcutIndex[A2ILabel.Tag].rShape := MagicData.rShape;
  ShortcutIndex[A2ILabel.Tag].rMagicName := MagicData.rMagicName;
end;

procedure TFrmBottom.lblShortcutStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_SHORTCUT;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmBottom.lblShortcutDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source = nil then
    exit;

  case TDragItem(Source).SourceID of
    WINDOW_MAGICS, WINDOW_BASICFIGHT, WINDOW_RISEMAGICS,
      WINDOW_MYSTERYMAGICS, WINDOW_BESTMAGIC:
      Accept := True;
  end;
end;

procedure TFrmBottom.lblShortcutMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  strMagicName: string;
  index: integer;
  ILabel: TA2ILabel;
begin
  ILabel := TA2ILabel(Sender);
  if ShortcutIndex[ILabel.Tag].rShape <= 0 then
  begin
    TA2ILabel(Sender).Hint := '';
    exit;
  end;
  strMagicName := ShortcutIndex[ILabel.Tag].rMagicName;
  index := frmAttrib.FindMagicIndex(strMagicName);
  if index < 0 then
    exit;

  if (x < 0) or (y < 0) or (x > ILabel.Width) or (y > ILabel.Height) then
  begin
    if ILabel.A2Image <> nil then
      ILabel.BeginDrag(TRUE);
  end;

  TA2ILabel(Sender).Hint := frmAttrib.MagicData[index].rMagicHint;
end;

procedure TFrmBottom.ClearShortcut(index: integer);
begin
  ShortcutIndex[index].rShape := 0;
  ShortcutIndex[index].rMagicName := '';
  lblShortcut[index].A2Image := nil;
  lblShortcut[index].Repaint;
end;

procedure TFrmBottom.EdChatXEnter(Sender: TObject);
begin
  if EdChat.ReadOnly = false then
    EdChat.SetFocus;
end;

procedure TFrmBottom.SetSkillLevelGauge(strValue: string);
begin
  PGSkillLevel2.Progress := _StrToInt(GetValidStr4(strValue, '.')) mod 10;
  PGSkillLevel1.Progress := _StrToInt(strValue);
end;

end.

