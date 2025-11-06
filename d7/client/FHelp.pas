unit FHelp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, A2Form, Buttons, A2Img, AUtil32, DefType,
  HelpCls;

const
  IDENTIFY_HELP1 = 'HELP1';

type
  TCmdActionType = (ca_none, ca_link, ca_send, ca_click);
  TCommandInfo = record
    cmdType: TCmdActionType;
    value: string;
  end;

  TfrmHelp = class(TForm)
    A2Form: TA2Form;
    btnCommand0: TA2Button;
    lblTitle: TA2ILabel;
    A2Label1: TA2Label;
    A2Label2: TA2Label;
    A2Label3: TA2Label;
    A2Label4: TA2Label;
    imgImage: TA2ILabel;
    listContent: TA2ListBox;
    btnCommand1: TA2Button;
    btnCommand2: TA2Button;
    btnCommand3: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCommandClick(Sender: TObject);
    procedure listContentAdxDrawItem(ASurface: TA2Image; Index: Integer;
      aStr: String; Rect: TRect; State: TDrawItemState);
    procedure listContentMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormHide(Sender: TObject);
  private
    FRawData: string;
    CharImage: TA2Image;
    FTitleText: TA2Image;
    A2Text: array[0..3] of TA2Label;
    CmdInfo: array[0..3] of TCommandInfo;
    btnCommand: array[0..3] of TA2Button;
    HelpClass: THelpClass; 

//    procedure LoadFromFile(const filename: string);
    function Parse: integer;
    procedure Clear;
    procedure SetTitle(const Str: string);
    procedure SetImage(const Str: string);
    procedure SetA2Text(const Text: string);
    procedure SetBody(const Text: string);
    procedure AddCommand(index: integer; str, capt: string);
  public

    procedure View(filename: string);
    procedure View2(helpText: TWordString);
    procedure MessageProcess(var code: TWordComData);
  end;

var
  frmHelp: TfrmHelp;

function GetStatement(var Line, Str: string) : integer;
function GetParamValue(const TagStr, ParamName: string): string; overload;
function GetParamValue(const TagStr, ParamName: string; out Value: string): Boolean; overload;

implementation

uses
   FMain, FBottom, FLogOn, Log, AtzCls, uAnsTick;

{$R *.DFM}

procedure TfrmHelp.FormCreate(Sender: TObject);
begin
   FrmM.AddA2Form (Self, A2Form);
   A2Form.SetBackImageFile ('.\ect\base.bmp');
   SetBounds(30, 26, 388, 276);
//   Visible := False;

   A2Text[0] := A2Label1;
   A2Text[1] := A2Label2;
   A2Text[2] := A2Label3;
   A2Text[3] := A2Label4;

   btnCommand[0] := btnCommand0;
   btnCommand[1] := btnCommand1;
   btnCommand[2] := btnCommand2;
   btnCommand[3] := btnCommand3;
   fillchar(CmdInfo, SizeOf(TCommandInfo) * 4, 0);
{
   ImageLib := TA2ImageLib.Create;
   ImageLib.LoadFromFile('.\ect\view.atz');
}

   CharImage := TA2Image.Create(80, 100, 0, 0);
   FTitleText := TA2Image.Create(lblTitle.Width, lblTitle.Height, 0, 0);

   HelpClass := THelpClass.Create;
   HelpClass.LoadIndex('.\ect\help.idx');

   with listContent do begin
      SetBackImage(EtcViewClass[1]);
      SetScrollBackImage(EtcViewClass[3]);
      SetScrollTrackImage(EtcViewClass[4], EtcViewClass[5]);
      SetScrollTopImage(EtcViewClass[6], EtcViewClass[7]);
      SetScrollBottomImage(EtcViewClass[8], EtcViewClass[9]);
   end;
end;

procedure TfrmHelp.FormDestroy(Sender: TObject);
begin
   CharImage.Free;
   FTitleText.Free;

   HelpClass.Free;
end;

procedure TfrmHelp.btnCommandClick(Sender: TObject);
var
   index, n: integer;
   cSendMsg: TCSelectHelpWindow;
begin
   index := TA2Button(Sender).Tag;
   Visible := False;
   //FrmBottom.FocusControl (FrmBottom.EdChat);
   //FrmBottom.EdChat.SetFocus
   case CmdInfo[index].CmdType of
      ca_link: begin
         View(CmdInfo[index].value);
      end;
      ca_send: begin
         cSendMsg.rMsg := CM_SELECTHELPWINDOW;
         SetWordString(cSendMsg.rSelectKey, CmdInfo[index].value);
         n := sizeof(cSendMsg) - sizeof(TWordString) + SizeOfWordString(cSendMsg.rSelectKey);
         FrmLogon.SocketAddData(n, @cSendMsg);
      end;
   end;
end;
{
procedure TfrmHelp.LoadFromFile(const filename: string);
var
   Stream: TFileStream;
   Size: Word;
begin
   try
      Stream := TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
   except
      exit;
   end;

   Size := Word(Stream.Size);
   SetLength(FRawData, Size+1);
   try
      Stream.Read(FRawData[1], Size);
      FRawData[Size+1] := #0;
   finally
      Stream.Free;
   end;
end;
}
function GetWordBlock(const Str, Separator: string; var Block: string): integer;
begin
   Result := Pos(Separator, Str);

   if Result = 0 then
      Block := Str
   else
      Block := Copy(Str, 1, Result-1);
end;

function GetStatement(var Line, Str: string) : integer;
var
   n: integer;
begin
   Result := 0;
   if Line = '' then exit;
   if Line[1] = '<' then begin
      n := Pos('>', Line);
      if Line[2] = '/' then begin // 종료태그임
         Str := Copy(Line, 3, n-3);
         Result := 2;
      end else begin              // 시작태그임
         Str := Copy(Line, 2, n-2);
         Result := 1;
      end;
      Delete(Line, 1, n);
   end else begin                 // 일반텍스트임
      n := Pos('<', Line);
      if n > 0 then begin
         Str := Copy(Line, 1, n-1);
         Delete(Line, 1, n-1);
      end else begin
         Str := Line;
         Line := '';
      end;
   end;

end;

function GetParamValue(const TagStr, ParamName: string): string;
var
   n, p, i: integer;
   CheckChar: char;
begin
   Result := '';
   n := Pos(' '+ParamName+'=', TagStr);
   if n > 0 then begin
      p := n+Length(ParamName)+2;
      CheckChar := #32;
      if (TagStr[p] = '"') or (TagStr[p] = '''') then begin
         CheckChar := TagStr[p];
         inc(p);
      end;

      n := Length(TagStr);
      for i := p to n do
         if TagStr[i] = CheckChar then break;

      if (CheckChar <> #32) and (i > n) then begin
         Result := '';
         exit;
      end;

      Result := Copy(TagStr, p, i-p);
   end;
end;

function GetParamValue(const TagStr, ParamName: string; out Value: string): Boolean;
begin
   Result := True;
   Value := GetParamValue(TagStr, ParamName);
   if Value = '' then Result := False;
end;

function TfrmHelp.Parse: integer;
var
   Res, iCommand: integer;
   ParseStack: TStringList;
   Line, DataText, tmpStr: string;
   isBody: Boolean;
begin
   Result := 0;

   Clear;

   ParseStack := TStringList.Create;
   Line := FRawData;
   DataText := '';
   isBody := False;
   iCommand := 0;

   repeat
      Res := GetStatement(line, tmpStr);

      case Res of
      0: // 일반 텍스트
         begin
            if isBody then // Body는 공백삭제를 하지 않음(enter처리땜시롱)
               DataText := DataText + tmpStr
            else           // Text의 불필요한 양 공백삭제
               DataText := Trim(tmpStr);
         end;
      1: // 시작태그
         begin
            if not isBody then begin
               if StrLIComp(PChar(tmpStr), 'image', 5) = 0 then
                  SetImage(tmpStr)
               else begin
                  if StrLIComp(PChar(tmpStr), 'body', 4) = 0 then isBody := True;
                  ParseStack.Add(tmpStr);
               end;

               DataText := '';
            end else begin // body내의 tag들은 parsing하지 않음
               DataText := DataText + '<' + tmpStr + '>';
            end;
         end;
      2: // 종료태그
         begin
            if StrLIComp(PChar(tmpStr), 'title', 5) = 0 then begin
               SetTitle(DataText);
            end else if StrLIComp(PChar(tmpStr), 'text', 4) = 0 then
               SetA2Text(StringReplace(DataText, #13#10, ' ', [rfReplaceAll]))
            else if StrLIComp(PChar(tmpStr), 'command', 7) = 0 then begin
               tmpStr := ParseStack[ParseStack.Count-1];
               AddCommand(iCommand, tmpStr, DataText);
               inc(iCommand);
            end else if StrLIComp(PChar(tmpStr), 'body', 4) = 0 then begin
               SetBody(DataText);
               isBody := False;
            end;
            DataText := '';
            ParseStack.Delete(ParseStack.Count-1);
         end;
      end;

   until ParseStack.Count = 0;

   ParseStack.Free;
end;

procedure TfrmHelp.SetA2Text(const Text: string);
var
   i, nWidth: integer;
   Line: string;
begin
   Line := Text;
   for i := 0 to 3 do begin
      nWidth := A2Text[i].Width;
      nWidth := nWidth + (nWidth div 10);
      A2Text[i].Caption := CutLengthString(Line, nWidth);
   end;
end;

procedure TfrmHelp.listContentAdxDrawItem(ASurface: TA2Image;
  Index: Integer; aStr: String; Rect: TRect; State: TDrawItemState);
var
   n: integer;
begin
   ASurface.Clear (0);

   if (Length(aStr) > 0) and (aStr[1] = '<') then begin
      n := Pos('>', aStr);
      Delete(aStr, 1, n);
      if Index = listContent.OverIndex then
         ATextOut (ASurface, Rect.Left, Rect.Top, 255, aStr)
      else
         ATextOut (ASurface, Rect.Left, Rect.Top, 32767, aStr);

   end else begin // 일반 라인
      ATextOut (ASurface, Rect.Left, Rect.Top, 32767, aStr);
   end;

end;

procedure TfrmHelp.SetImage(const str: string); // image setting;
var
   i: integer;
   ImageLib: TA2ImageLib;
   tmpImage: TA2Image;
   tmpString: string;
begin
   imgImage.Visible := True;
   for i := 0 to 3 do begin
      A2Text[i].Left := 108;
      A2Text[i].Width := 270;
   end;

   with listContent do begin
      Left := 104;
      Top := 128;
      Width := 240;
      Height := 108;

      ImageLib := EtcViewClass.ImageLib;//AtzClass.GetImageLib(ECT_VIEW_ATZ, mmAnsTick);
      SetBackImage(ImageLib[1]);
      SetScrollBackImage(ImageLib[3]);
   end;

   tmpString := GetParamValue(str, 'name') + '.atz';
   ImageLib := AtzClass.GetImageLib(tmpString, mmAnsTick);

   CharImage.Free;
   CharImage := TA2Image.Create(84, 112, 0, 0);

   tmpString := GetParamValue(str, 'value');
   tmpImage := ImageLib[_StrToInt(tmpString)];
   if tmpImage <> nil then
      CharImage.DrawImageKeyColor(tmpImage, 0, 0, 31, @darkentbl);
   CharImage.Optimize;
   imgImage.A2Image := CharImage;
end;

procedure TfrmHelp.SetTitle(const Str: string);
var
   H,W: integer;
begin
   FTitleText.Clear(0);
   W := ATextWidth(Str);
   H := ATextHeight(Str);
   ATextOut(FTitleText, (lblTitle.Width-W) div 2, (lblTitle.Height-H-8) div 2, 32767, Str);
   lblTitle.A2Image := FTitleText;
end;

procedure TfrmHelp.SetBody(const Text: string);
var
   i: integer;
   Temp: TStringList;
begin
   Temp := TStringList.Create;
   Temp.Text := Text;

   if Temp[0] = '' then Temp.Delete(0);
   if Temp[Temp.Count-1] = '' then Temp.Delete(Temp.Count-1);

   listContent.Clear;   // listContent를 clear한후 내용 적재
   for i := 0 to Temp.Count-1 do
      listContent.AddItem(Temp[i]);

   temp.Free;
end;

procedure TfrmHelp.AddCommand(index: integer; str, capt: string);
var
   tmpStr: string;
begin
   btnCommand[index].Caption := capt;

   if GetParamValue(str, 'link', tmpStr) then
      CmdInfo[index].CmdType := ca_link
   else if GetParamValue(str, 'send', tmpStr) then
      CmdInfo[index].CmdType := ca_send;
   CmdInfo[index].value := tmpStr;

   btnCommand[index].Width := ATextWidth(capt);
   btnCommand[index].Height := ATextHeight(capt);
   if index > 1 then // 0번 버튼의 위치는 고정 from minds..
      btnCommand[index].Left := btnCommand[index-1].Left - btnCommand[index].Width - 8;
   btnCommand[index].Visible := True;
end;

procedure TfrmHelp.Clear;
var
   i: integer;
begin
   // Text 초기화
   for i := 0 to 3 do begin
      A2Text[i].Caption := '';
      A2Text[i].Left := 12;
      A2Text[i].Width := 362;
   end;

   // 커맨드버튼 초기화, 0번버튼은 기본 닫기로..
   btnCommand[0].Caption := Conv('밑균');
   btnCommand[0].Width := ATextWidth(Conv('밑균'));
   CmdInfo[0].CmdType := ca_send;
   CmdInfo[0].Value := 'close';
   for i := 1 to 3 do begin
      CmdInfo[i].CmdType := ca_none;
      btnCommand[i].Visible := False;
   end;

   // 이미지 초기화
   CharImage.Clear(0);
   imgImage.Visible := False;

   // Title 초기화
   FTitleText.Clear(0);

   // 컨텐트 초기화
   listContent.Clear;
   with listContent do begin
      Left := 12;
      Top := 96;
      Width := 364;
      Height := 140;

      SetBackImage(EtcViewClass[0]);
      SetScrollBackImage(EtcViewClass[2]);
   end;
end;

procedure TfrmHelp.MessageProcess(var code: TWordComData);
var
   str: string;
   psStartHelpWindow: PTSStartHelpWindow;
begin
   psStartHelpWindow := @Code.data;
   with psStartHelpWindow^ do begin
      if rMsg <> SM_STARTHELPWINDOW then exit;  // 도움말창 관련 메세지가 아니면 종료

      str := StrPas(@rFileName);
      if str <> '' then
         View(str)
      else
         View2(rHelpText);

      RightButtonDown := FALSE; // 이동을 멈추기 위해
   end;
   FocusControl(listContent);
end;

procedure TfrmHelp.View(filename: string);
var
   HelpRec: PHelpRec;
begin
   HelpRec := HelpClass.Names[filename];
   if HelpRec = nil then begin
      exit;
   end else begin
      HelpClass.LoadHelp(HelpRec, FRawData);
   end;
   Parse;
   FrmM.ShowA2Form(self);
end;

procedure TfrmHelp.View2(helpText: TWordString);
begin
   FRawData := GetWordString(helpText);
   Parse;
   FrmM.ShowA2Form(self);
end;

procedure TfrmHelp.listContentMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   n: integer;
   tmpStr, linkStr: string;
   cSendMsg: TCSelectHelpWindow;
begin
   if listContent.ItemIndex <> listContent.OverIndex then exit;
   tmpStr := listContent.items[listContent.ItemIndex];
   if (GetStatement(tmpStr, linkStr) = 1) and
      (linkStr[1] = 'a') and (linkStr[2] = ' ') then begin

      tmpStr := GetParamValue(linkStr, 'link');
      if tmpStr <> '' then begin
         view(tmpStr);
         exit;
      end;

      tmpStr := GetParamValue(linkStr, 'send');
      if tmpStr <> '' then begin
         cSendMsg.rMsg := CM_SELECTHELPWINDOW;
         SetWordString(cSendMsg.rSelectKey, tmpStr);
         n := sizeof(cSendMsg) - sizeof(TWordString) + SizeOfWordString(cSendMsg.rSelectKey);
         FrmLogon.SocketAddData(n, @cSendMsg);
         Visible := False;
         //FrmBottom.FocusControl (FrmBottom.EdChat);
      end;
   end;
end;

procedure TfrmHelp.FormHide(Sender: TObject);
begin
   //frmBottom.FocusControl(frmBottom.EdChat);
end;

end.
