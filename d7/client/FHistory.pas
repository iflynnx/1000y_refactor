unit FHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, A2Form, AUtil32, A2Img, Math;

const
  SideMessageLines = 3;
  NoticeColor = 16912;

  DrawChatColor = 25368;
  TextShadowColor = 1057;

  SideMessageLifeTime = 250;
  SideMessageColor = 23232;
  SideMsgLine = 312;
  
type
  TChatManager = class
    // 쪽지관련
  private
    slUserList: TStringList;
    strLastSender: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddUser(const str: string; isSender: boolean = false);

    function GetLastSender: string;
    function GetLastUser: string;
    function GetPrevUser(const str: string): string;
    function GetNextUser(const str: string): string;

    // Save Chat List
  public
    bSideMessage: Boolean;
    SaveChatList: TStringList;

    procedure AddChat(const astr: string; fcolor, bcolor: integer);
    procedure AddDebugLine(const astr: string);
    procedure DrawChatList;

    // Side Message
  public
    LastTick: integer;
    SideMessageList: TStringList;

    procedure AddSideMessage(const astr: string; CurTick: integer);
    procedure DrawSideMessage(CurTick: integer);
  end;

  TfrmHistory = class(TForm)
    A2Form: TA2Form;
    lblTop: TA2ILabel;
    lblBottom: TA2ILabel;
    lblLeft: TA2ILabel;
    lblRight: TA2ILabel;
    listHistory: TA2ListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure listHistoryAdxDrawItem(ASurface: TA2Image; Index: Integer;
      aStr: String; Rect: TRect; State: TDrawItemState);
    procedure listHistoryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  public
    procedure ShowHistory;
    procedure HideHistory;
  end;


var
  frmHistory: TfrmHistory;
  ChatMan: TChatManager;

implementation

uses BackScrn, FMain, FBottom, AtzCls, FLogOn;

{$R *.dfm}

//////////////////////////////////////////////
///  TChatManager Class                         //
//////////////////////////////////////////////

constructor TChatManager.Create;
begin
   inherited;

   // 쪽지관련 초기화
   slUserList := TStringList.Create;
   strLastSender := '';

   // 채팅리스트 초기화
   SaveChatList := TStringList.Create;

   // SideMessageList 초기화
   bSideMessage := IsDebuggerPresent;
   SideMessageList := TStringList.Create;
   SideMessageList.Add('');
   SideMessageList.Add('');
   SideMessageList.Add('');
end;

destructor TChatManager.Destroy;
begin
   slUserList.Free;
   SaveChatList.Free;
   SideMessageList.Free;
   inherited;
end;

procedure TChatManager.AddUser(const str: string; isSender: boolean);
var
   index: integer;
begin
   slUserList.CaseSensitive := false;
   index := slUserList.IndexOf(stR);
   if index >= 0 then
      slUserList.Move(index, slUserList.Count-1)
   else begin
      if slUserList.Count >= 500 then slUserList.Delete(0);
      slUserList.Add(str);
   end;

   if isSender then strLastSender := str;
end;

function TChatManager.GetLastUser: string;
begin
   Result := '';
   if slUserList.Count > 0 then
      Result := slUserList[slUserList.Count-1];
end;

function TChatManager.GetLastSender: string;
begin
   Result := strLastSender;
end;

function TChatManager.GetPrevUser(const str: string): string;
var
   index: integer;
begin
   index := slUserList.IndexOf(str);
   if index >= 0 then begin
      if index > 0 then dec(index);
      Result := slUserList[index];
   end else begin
      Result := GetLastUser;
   end;
end;

function TChatManager.GetNextUser(const str: string): string;
var
   index: integer;
begin
   index := slUserList.IndexOf(str);
   if index >= 0 then begin
      if index < slUserList.count-1 then inc(index);
      Result := slUserList[index];
   end else begin
      Result := GetLastUser;
   end;
end;

/////////// SaveChat //////////////////////////

procedure TChatManager.AddChat (const astr: string; fcolor, bcolor: integer);
var
   str, rdstr: string;
   col : Integer;
   addflag : Boolean;
begin
   addflag := FALSE;
   str := astr;

   //str := '(ttt):123456';

   while TRUE do begin
      str := GetValidStr3 (str, rdstr, #13);
      if rdstr = '' then break;

      if chat_outcry then begin // 외치기
         if rdstr[1] = '[' then addflag := TRUE;
      end;

      if chat_Guild then begin  // 길드
         if rdstr[1] = '<' then
          addflag := TRUE;
      end;

      if chat_faction then
      begin
        if rdstr[1] = '{' then
          addflag := True;
      end;


      if chat_notice then begin // 공지사항
         if bcolor = NoticeColor then
            addflag := TRUE;
      end;

      if chat_normal then begin  // 일반유저
         if not(bcolor = NoticeColor) and not(rdstr[1] = '<')
            and not(rdstr[1] = '[') and not(rdstr[1] = '{') then begin
            addflag := TRUE;
         end;
      end;

      if Addflag then begin
         if SaveChatList.Count > 500 then begin
            SaveChatList.Delete(0);
            frmHistory.listHistory.DeleteItem(0);
         end;

         col := MakeLong (fcolor, bcolor);

         SaveChatList.AddObject(rdstr, TObject(col));

         ///////////////////
         //ShowMessage(rdstr);  steven 2004-10-18
         /////////////////
         with frmHistory.listHistory do begin
            AddItem(rdstr);
            if Visible and (Count - ViewIndex = 21) then
               ViewIndex := Max(Count - 20, 0);
         end;
{
         frmHistory.listHistory.AddItem(rdstr);
         if frmHistory.listHistory.ViewIndex <

         if not frmHistory.Visible or (frmHistory.ScrollPos + 20 < SaveChatList.Count) then begin
            frmHistory.listHistory.ViewIndex := frmHistory.listHistory.ViewIndex + 1;
         end;
}
      end;
   end;

   frmBottom.LbChat.Repaint;
end;

procedure TChatManager.AddDebugLine(const astr: string);
begin
{$IFDEF _DEBUG}
   AddChat(astr, 32727, 0);
{$ENDIF}
end;

procedure TChatManager.DrawChatList;
var
   i, t, nLines: integer;
begin
   if frmHistory.Visible then exit;
// 주석
   If bSideMessage then nLines := 20
                   else nLines := 20;

   t := SaveChatList.Count-nLines;
   if t < 0 then t := 0;

   for i := 0 to nLines-1 do begin
      if t + i >= SaveChatList.Count then exit;
      ATextOut (BackScreen.Back, 20+1, i*16+20+1, TextShadowColor, SaveChatList[t+i]);
      ATextOut (BackScreen.Back, 20, i*16+20, DrawChatColor, SaveChatList[t+i]);
   end;
end;

//////// Side Message /////////
procedure TChatManager.AddSideMessage(const astr: string; CurTick: integer);
begin
   LastTick := CurTick;

   SideMessageList.Move(0, 2);
   SideMessageList[2] := astr;
end;

procedure TChatManager.DrawSideMessage(CurTick: integer);
var
   i: integer;
   str: string;
begin
   if LastTick + SideMessageLifeTime < CurTick then begin
      AddSideMessage('', CurTick);
   end;
// 주석
   if bSideMessage or not bSideMessage then begin
      for i := 0 to 2 do begin
         str := SideMessageList[i];
         if Length(str) <> 0 then begin
            ATextOut (BackScreen.Back, 20+1, i*15+SideMsgLine+1, TextShadowColor, str);
            ATextOut (BackScreen.Back, 20, i*15+SideMsgLine, SideMessageColor, str);
         end;
      end;
   end;
end;


////////////////////////////////

procedure TfrmHistory.FormCreate(Sender: TObject);
begin
   FrmM.AddA2Form(self, A2Form);
   Left := 0;
   Top := 0;
   Visible := False;

   ChatMan := TChatManager.Create;
   ChatMan.bSideMessage := not IsDebuggerPresent;
   lblTop.A2Image := EtcViewClass[13];
   lblLeft.A2Image := EtcViewClass[14];
   lblRight.A2Image := EtcViewClass[15];
   lblBottom.A2Image := EtcViewClass[16];

   with listHistory do begin
      SetScrollBackImage(EtcViewClass[17]);
      SetScrollTrackImage(EtcViewClass[4], EtcViewClass[5]);
      SetScrollTopImage(EtcViewClass[6], EtcViewClass[7]);
      SetScrollBottomImage(EtcViewClass[8], EtcViewClass[9]);
   end;
end;

procedure TfrmHistory.FormDestroy(Sender: TObject);
begin
   ChatMan.Free;
end;

////////////////////////////////////////////////

procedure TfrmHistory.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
//
end;

procedure TfrmHistory.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
//
end;

procedure TfrmHistory.FormActivate(Sender: TObject);
begin
  // FrmBottom.FocusControl(FrmBottom.EdChat);
   FrmBottom.EdChat.SetFocus;
end;


procedure TfrmHistory.listHistoryAdxDrawItem(ASurface: TA2Image;
  Index: Integer; aStr: String; Rect: TRect; State: TDrawItemState);
var
   Col: integer;
   fcol, bcol: Word;
begin
   if Index > ChatMan.SaveChatList.Count-1 then begin
      ASurface.Clear(1);
//      ASurface.DrawImage(EtcViewClass[17], Rect.Left, Rect.Top, False);
   end else begin
      Col := Integer(ChatMan.SaveChatList.Objects[Index]);
      fcol := LOWORD (Col);
      bcol := HIWORD (col);

      ASurface.Clear(bcol);
      ATextOut(ASurface, Rect.Left+2, Rect.Top+2, fcol, aStr);
      if Index = listHistory.OverIndex then
         ATextOut(ASurface, Rect.Left+3, Rect.Top+2, fcol, aStr);
   end;
end;

procedure TfrmHistory.ShowHistory;
begin
   listHistory.ViewIndex := Max(ChatMan.SaveChatList.Count - 20, 0);
   {
   if SaveChatList.Count > 20 then
      listHistory.ViewIndex := SaveChatList.Count - 20;
   else
      listHistory.ViewIndex := 0;
   }
   frmM.ShowA2Form(self);
end;

procedure TfrmHistory.HideHistory;
begin
   Visible := False;
end;

procedure TfrmHistory.listHistoryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   str, namestr: string;
   idx, col: integer;
   fcol, bcol: word;
begin
   if listHistory.ItemIndex < listHistory.Count then begin
      with ChatMan.SaveChatList do begin
         str := Strings[listHistory.ItemIndex];
         col := Integer(Objects[listHistory.ItemIndex]);
      end;
      fcol := LOWORD (col);
      bcol := HIWORD (col);
      if bcol = NoticeColor then exit; // 공지사항
      if fcol = NoticeColor then exit; // 무공어쩌구..

      namestr := '';

      if str[1] = '[' then begin // 외치기
         idx := Pos(']', str);
         namestr := Copy(str, 2, idx-2);
      end else begin             // 일반대화
         idx := Pos(' :', str);
         namestr := Copy(str, 1, idx-1);
      end;

      if namestr <> '' then frmBottom.SetPaper(namestr);
      
   end;
end;

end.
