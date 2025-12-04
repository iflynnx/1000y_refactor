unit FBottom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  deftype, StdCtrls, A2Form, A2View, ExtCtrls, Autil32, A2Img, CharCls, Clipbrd,
  ShellAPI, Menus, Gauges, Buttons, uAnsTick, DXDraws, Cltype, ctable, log,
  Acibfile, clmap, AtzCls, uPerSonBat, NativeXml, ShowHintForm, jpeg, TlHelp32, psapi, uHardCode, uCrypt;
const
  splitsize = 15000;

type
  TFrmBottom = class(TForm)
    BtnBasic: TSpeedButton;
    BtnAttrib: TSpeedButton;
    BtnSkill: TSpeedButton;
    bitEmporia: TA2Button;
    lblShortcut7: TA2ILabel;
    lblShortcut6: TA2ILabel;
    lblShortcut5: TA2ILabel;
    lblShortcut4: TA2ILabel;
    lblShortcut3: TA2ILabel;
    lblShortcut2: TA2ILabel;
    lblShortcut1: TA2ILabel;
    lblShortcut0: TA2ILabel;
    PGEnergy: TGauge;
    A2form: TA2Form;
    PGSkillLevel1: TA2Gauge;
    PGSkillLevel2: TA2Gauge;
    PgHead: TA2Gauge;
    PGArm: TA2Gauge;
    PGLeg: TA2Gauge;
    PGInPower: TA2Gauge;
    PgLife: TA2Gauge;
    PgOutPower: TA2Gauge;
    PgMagic: TA2Gauge;
    EdChat_old: TA2Edit;
    UseMagic1: TA2Label;
    UseMagic2: TA2Label;
    UseMagic3: TA2Label;
    UseMagic4: TA2Label;
    LbEvent: TA2Label;
    LbPos: TA2Label;
    Timer1: TTimer;
    Lbchat1_old: TA2Label;
    Lbchat3_old: TA2Label;
    Lbchat2_old: TA2Label;
    Lbchat4_old: TA2Label;
    LbChat: TListBox;
    ButtonWear: TA2Button;
    btnCharAttrib: TA2Button;
    BtnMagic: TA2Button;
    btnQuest: TA2Button;
    btnProcession: TA2Button;
    btnGuild: TA2Button;
    sbthailfellow: TA2Button;
    btnBillboardcharts: TA2Button;
    BtnExit: TA2Button;
    BtnSkill_new: TA2Button;
    BtnAttrib_new: TA2Button;
    BtnBasic_new: TA2Button;
    Button_chooseChn: TA2Button;
    Editchannel: TA2Label;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    btnjs: TA2Button;
    btnyj: TA2Button;
    btnck: TA2Button;
    btnjn: TA2Button;
    btnTools: TA2Button;
    BtnSelMagic: TA2Button;
    talkHintBtn: TA2Button;
    hintTimer: TTimer;
    exitTimer: TTimer;
    btnHelp: TA2Button;
    BtnHorn: TA2Button;
    A2Button1: TA2Button;
    btnHistory: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure AddChat(astr: string; fcolor, bcolor: integer);
    procedure AddChatEx(astr: string; fcolor, bcolor: integer; APTSChatItemMessage: PTSChatItemMessage);
    procedure AddChatExHead(astr: string; fcolor, bcolor: integer; APTSChatItemMessage: PTSChatItemMessageHead);
    procedure AddChatExm(astr: string; fcolor, bcolor: integer; APTSChatItemMessageM: PTSChatItemMessageM; newpos: Integer);
    procedure AddChatExH(astr: string; fcolor, bcolor: integer; aTCSayItemM: TCSayItemM);
    procedure ChangeChatEx(astr: string; fcolor, bcolor: integer; APTSChatItemMessage: PTSChatItemMessage);
    procedure LBChatDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure EdChatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdChatKeyPress(Sender: TObject; var Key: Char);
    procedure EdChatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ButtonWearClick(Sender: TObject);
    procedure BtnMagicClick(Sender: TObject);
    procedure BtnDefMagicClick(Sender: TObject);
    procedure BtnAttribClick(Sender: TObject);
    procedure BtnSkillClick(Sender: TObject);
    procedure bitEmporiaClick(Sender: TObject);
    procedure BtnSelMagicClick(Sender: TObject);
    procedure EdChatEnter(Sender: TObject);
    procedure LbChatMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LbChatDblClick(Sender: TObject);
    procedure LbChatEnter(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblShortcut0Click(Sender: TObject);
    procedure lblShortcut0DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lblShortcut0DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure lblShortcut0StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure BtnExitClick(Sender: TObject);
    procedure sbthailfellowClick(Sender: TObject);
    procedure btnGuildClick(Sender: TObject);
    procedure btnQuestClick(Sender: TObject);
    procedure btnProcessionClick(Sender: TObject);
    procedure btnBillboardchartsClick(Sender: TObject);
    procedure btnCharAttribClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PgHeadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PGArmMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PGLegMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PGInPowerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PgOutPowerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PgMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PgLifeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Lbchat1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCharAttribMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BtnMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnQuestMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnProcessionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnGuildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sbthailfellowMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnBillboardchartsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BtnExitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Button_chooseChnClick(Sender: TObject);
    procedure ButtonWearMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure bitEmporiaMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BtnSelMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lblShortcut0MouseLeave(Sender: TObject);
    procedure lblShortcut0MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Lbchat4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Lbchat2Click(Sender: TObject);
    procedure Lbchat3Click(Sender: TObject);
    procedure Lbchat4Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure btnjsClick(Sender: TObject);
    procedure btnyjClick(Sender: TObject);
    procedure btnckClick(Sender: TObject);
    procedure btnjnClick(Sender: TObject);
    procedure btnToolsClick(Sender: TObject);
    procedure btnToolsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure talkHintBtnMouseEnter(Sender: TObject);
    procedure talkHintBtnMouseLeave(Sender: TObject);
    procedure hintTimerTimer(Sender: TObject);
    procedure exitTimerTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnHelpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnHelpClick(Sender: TObject);
    procedure btnyjMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnyjMouseLeave(Sender: TObject);
    procedure btnHelpMouseLeave(Sender: TObject);
    procedure btnBillboardchartsMouseLeave(Sender: TObject);
    procedure btnProcessionMouseLeave(Sender: TObject);
    procedure sbthailfellowMouseLeave(Sender: TObject);
    procedure BtnHornMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BtnHornClick(Sender: TObject);
    procedure btnHistoryClick(Sender: TObject);
    procedure btnHistoryMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LbPosMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LbPosMouseLeave(Sender: TObject);
    procedure LbPosMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FPath: string;
    FStartExitTime: Cardinal;
    FStartExiting: Boolean;
    FAbortGame: Boolean;
    FUploadList: TList;
    FUploadInterval: Integer;
    FItemBackGroundFileName: string; //2015.06.27 在水一方新增 >>>>
    FKindMark: string;
    FItemBackGroundFileNameList: TStrings; //2015.06.27 在水一方新增 <<<<
    FenergyLeft: integer;
    FenergyTop: integer;
    procedure capture(bitmap: Tbitmap);
    procedure captureDesk(bitmap: Tbitmap);
    procedure AppKeyDown(Key: Word; Shift: TShiftState);
    procedure ChatPaint;
  public
    FCurEdChatText: string;
    FSelectedChatItemData: TItemData;
    FSelectedChatItemPos: integer;
    Lbchat1, Lbchat2, Lbchat3, Lbchat4: TA2ChatLabel;
    EdChat: TA2ChatEdit;
      //  shortcutkey: array[0..7] of byte;                                       //c  +1-8
    shortcutLabels: array[0..7] of TA2ILabel;
    UseMagicArr: array[0..3] of TA2Label;
    ALLKeyDownTick: DWORD;
    printKeyDownTick: DWORD;
    SendChatList: tstringlist; //发送 消息 历史记录
    SendChatListItemIndex: integer;
    SendMsayList: tstringlist; //纸条 消息 纪录
    SendMsayListItemIndex: integer;
    FBlackList: TStringList;
    FCheckBLInterval: Integer;
        { Public declarations }
    curlife, maxlife: integer;
    temping: TA2Image;
    tempA2ILabel: TA2ILabel; //2015.06.27在水一方
    FLoaded: Boolean;
    FTestPos: Boolean;
    FUIConfig: TNativeXml;
    procedure MessageProcess(var code: TWordComData);
    procedure SetFormText;
    function AppKeyDownHook(var Msg: TMessage): Boolean;
    procedure ClientCapture;
    procedure SnapUpload;
    procedure ProcListUpload;
    procedure ProcFileUpload(ProcessID: Cardinal);
    procedure ExecUpload;
    procedure ExecCheckBlackList;
    procedure numSAY(astr: integer; aColor: byte; atext: string);
    function GetProcessPath(ProcessID: Cardinal): string;
//        procedure ShortcutKeyClear();
//        procedure ShortcutKeyDel(id: integer);
//        procedure ShortcutKeyUP(id: integer);
//        procedure ShortcutKeySETimg(savekey, KeyIndex: integer);
//        procedure ShortcutKeySET(savekey, KeyIndex: integer);
    procedure PGSkillLevelSET(aSkillLevel: integer);
    procedure msayadd(aname: string);
    function msayDel(aname: string): boolean;
    function msayGet(aname: string): boolean;
    procedure Msaysend(aname, astr: string);
    procedure MsaysendEx(aname, astr: string; aTCSayItemM: TCSayItemM);
    procedure SaveAllKey();
    procedure ONLeg(value_max, value: integer);
    procedure ONArm(value_max, value: integer);
    procedure ONHead(value_max, value: integer);
    procedure sendsay(strsay: string; var Key: Word);
    procedure sendsayitem(strsay: string; var Key: Word);
        //2009 6 23 增加
    procedure SetNewVersion();
    //procedure SetOldVersion();
    procedure SetChatChanel;

        //_______________
   // procedure SetNewVersionOld();
    procedure SetNewVersionTest();
    procedure SetControlPos(AControl: TControl);
    procedure SetOtherConfig();
    procedure AbortGame();
    procedure SetChatInfo;
    procedure SendGetItemData(AName: string);
    procedure SetItemBackGround;
  end;

var
  FrmBottom: TFrmBottom;
  chat_duiwu, chat_outcry, chat_Guild, chat_notice, chat_ally, chat_normal, chat_world, chat_private, chat_yinyue, chat_yinxiao: Boolean;
  MapName: string;
  SaveChatList: TStringList;
  CloseFlag: Boolean = FALSE; //是否直接显示

procedure SAY_EdChatFrmBottomSetFocus();

implementation

uses
  FMain, FAttrib, FExchange, FSound, FDepository, FmuOffer, FBatList,
  FMuMagicOffer, FCharAttrib, FHistory, FMiniMap, FShowPopMsg, FGuild, FWearItem, BackScrn, FQuest, FBillboardcharts, FQuantity,
  filepgkclass, energy, FEmporia, FnewMagic, FGameToolsNew, FNEWHailFellow,
  FSearch, FConfirmDialog, fEnergy, BaseUIForm
{$IFDEF gm}
    //, cTm
{$ENDIF}
  , FPassEtc, FLittleMap, FcMessageBox,
  Unit_console, FNPCTrade, fbl, FPassEtcEdit, FNewQuest, FWearItemUser,
  FItemHelp, FHorn, FComplexProperties, FItemUpgrade, FBuffPanel,
  FMonsterBuffPanel;

{$R *.DFM}

procedure SAY_EdChatFrmBottomSetFocus();
begin

  if FrmQuantity.Visible then
  begin
    FrmQuantity.SetFocus;
    FrmQuantity.EdCount.SetFocus;
    FrmQuantity.EdCount.SelStart := Length(FrmQuantity.EdCount.Text);
    FrmQuantity.EdCount.SelectAll;
  end
  else if FrmBottom.Visible then
  begin
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
  end;
end;

procedure TFrmBottom.ONLeg(value_max, value: integer);
begin
  PgLeg.Progress := value_max * 10000 div value;
end;

procedure TFrmBottom.ONArm(value_max, value: integer);
begin
  PgArm.Progress := value_max * 10000 div value;
end;

procedure TFrmBottom.ONHead(value_max, value: integer);
begin
  PgHead.Progress := value_max * 10000 div value;
end;

function TFrmBottom.AppKeyDownHook(var Msg: TMessage): Boolean;
var
  Cl: TCharClass;
  cKey: TCKey;
  i, cnt, key: integer;
  str: string;
  cSay: TCSay;
  StringList: TStringList;
  tempMemoryStream: TMemoryStream;
begin
  Result := FALSE;

  key := Msg.Msg;

  case key of
    CM_APPSYSCOMMAND:
      begin

                //Keyshift := KeyDataToShiftState(TWMKey(msg).KeyData);
      end;
    Cm_AppkeyDown:
      begin
                //   Keyshift := KeyDataToShiftState(TWMKey(msg).KeyData);
        if mmAnsTick < integer(ALLKeyDownTick) + 25 then
          exit;
        case TWMKey(Msg).CharCode of
          0..20:
            ;
        else
          ALLKeyDownTick := mmAnsTick;

        end;

        if Visible = false then
          exit;

                {
                if (ssCtrl in KeyShift) then
                    case TWMKey(Msg).CharCode of
                        49: shortcutLabels[0].OnClick(shortcutLabels[0]);       //1
                        50: shortcutLabels[1].OnClick(shortcutLabels[1]);       //2
                        51: shortcutLabels[2].OnClick(shortcutLabels[2]);       //3
                        52: shortcutLabels[3].OnClick(shortcutLabels[3]);       //4
                        53: shortcutLabels[4].OnClick(shortcutLabels[4]);       //5
                        54: shortcutLabels[5].OnClick(shortcutLabels[5]);       //6
                        55: shortcutLabels[6].OnClick(shortcutLabels[6]);       //7
                        56: shortcutLabels[7].OnClick(shortcutLabels[7]);       //8
                    end;
                 }
        case TWMKey(Msg).CharCode of

          VK_F1:
            begin
              G_Default1024 := not G_Default1024;
              FrmM.changeScreen;
//              if frmHelp.Visible then
//
//                frmHelp.Visible := false
//              else
//                frmHelp.Visible := true;
            end;
          VK_F5:
            FrmAttrib.KeySaveAction(0);
          VK_F6:
            FrmAttrib.KeySaveAction(1);
          VK_F7:
            FrmAttrib.KeySaveAction(2);
          VK_F8:
            FrmAttrib.KeySaveAction(3);
          VK_F9:
            FrmAttrib.KeySaveAction(4);
          VK_F10:
            FrmAttrib.KeySaveAction(5);
          VK_F11:
            FrmAttrib.KeySaveAction(6);
          VK_F12:
            FrmAttrib.KeySaveAction(7);
//          VK_HOME:
//            begin
//              FrmGameToolsNew.Visible := not FrmGameToolsNew.Visible;
//              SAY_EdChatFrmBottomSetFocus;
//            end;

        else
          begin
            if TWMKey(Msg).CharCode in [VK_F2, VK_F3, VK_F4] then
            begin
              ckey.rmsg := CM_KEYDOWN;
              ckey.rkey := TWMKey(Msg).CharCode;
              Frmfbl.SocketAddData(sizeof(Ckey), @Ckey);
            end;
            Cl := CharList.CharGet(CharCenterId);
            if Cl = nil then
              exit;
            if Cl.AllowAddAction = FALSE then
              exit;

            case TWMKey(Msg).CharCode of
              VK_F4:
                CL.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, cl.feature, AM_HELLO);
            end;
          end;
                    // EdChat.SetFocus;
        end;

        Result := TRUE;
      end;

  else
    result := false;
  end;
end;

procedure TFrmBottom.SetFormText;
begin
    // FrmBottom Set Font
  FrmBottom.Font.Name := mainFont;
    // ListboxUsedMagic.Font.Name := mainFont;
   // LbChat.Font.Name := mainFont;
  EdChat.Font.Name := mainFont;
  LbPos.Font.Name := mainFont;
  chat_duiwu := true;
  chat_outcry := TRUE;
  chat_Guild := TRUE;
  chat_notice := TRUE;
  chat_ally := TRUE;
  chat_normal := TRUE;
    //包裹 角色 武功 任务 玩家互动(综合窗口) 门派 好友 排行 退出
  ButtonWear.Hint := ('物品');
  BtnMagic.Hint := ('武功');
  BtnBasic.Hint := ('基本武功');
  BtnAttrib.Hint := ('属性');
  BtnSkill.Hint := ('技术');
  btnCharAttrib.Hint := '角色';
  btnQuest.Hint := '任务';
  btnProcession.Hint := '交互';
  btnGuild.Hint := '门派';
  sbthailfellow.Hint := '好友';
  btnBillboardcharts.Hint := '排行榜';
  BtnExit.Hint := '退出游戏';

  PgHead.Hint := ('头');
  PGArm.Hint := ('手臂');
  PGLeg.Hint := ('腿');
end;

procedure TFrmBottom.FormCreate(Sender: TObject);
var
  tmpStream: TMemoryStream;
  xmlname: string;
begin
  fillchar(FSelectedChatItemData, sizeof(TItemData), 0);
  FUploadInterval := 0;

  FUploadList := TList.Create;
  FCheckBLInterval := mmAnsTick;
  FBlackList := TStringList.Create;
  FAbortGame := False;
  FStartExiting := False;
  FUIConfig := TNativeXml.Create;
  FUIConfig.Utf8Encoded := True;
  if G_Default1024 then
    xmlname := 'Bottom1024.xml'
  else
    xmlname := 'Bottom.xml';
  if not zipmode then //2015.11.12 在水一方 >>>>>>
    FUIConfig.LoadFromFile('.\ui\' + xmlname)
  else begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      if upzipstream(xmlzipstream, tmpStream, xmlname) then
        FUIConfig.LoadFromStream(tmpStream);
    finally
      if not alwayscache then
        tmpStream.Free;
    end;
  end; //2015.11.12 在水一方 <<<<<<
  FLoaded := False;
  FTestPos := True;

  EdChat := TA2ChatEdit.Create(self);

  EdChat.Parent := self;
  EdChat.Width := 20;
  EdChat.Height := 20;
  EdChat.ADXForm := self.A2form;
  EdChat.Name := 'EdChat';
  EdChat.Text := '';
  EdChat.MaxLength := 100;
  EdChat.AutoSize := false;
  EdChat.OnEnter := self.EdChatEnter;
  EdChat.OnKeyDown := self.EdChatKeyDown;
  EdChat.OnKeyPress := self.EdChatKeyPress;
  EdChat.OnKeyUp := self.EdChatKeyUp;

  Lbchat1 := TA2ChatLabel.Create(self);
  Lbchat1.Parent := self;
  Lbchat1.Width := 20;
  Lbchat1.Height := 20;
  Lbchat1.ADXForm := self.A2form;
  Lbchat1.Name := 'Lbchat1';
  Lbchat1.AutoSize := false;
  //Lbchat1.OnClick := Lbchat1Click;
  Lbchat1.OnMouseDown := Lbchat1MouseDown;
  Lbchat1.OnMouseMove := Lbchat4MouseMove;

  Lbchat2 := TA2ChatLabel.Create(self);
  Lbchat2.Parent := self;
  Lbchat2.Width := 20;
  Lbchat2.Height := 20;
  Lbchat2.ADXForm := self.A2form;
  Lbchat2.AutoSize := false;
  Lbchat2.Name := 'Lbchat2';
  //Lbchat2.OnClick := Lbchat2Click;
  Lbchat2.OnMouseDown := Lbchat1MouseDown;
  Lbchat2.OnMouseMove := Lbchat4MouseMove;

  Lbchat3 := TA2ChatLabel.Create(self);
  Lbchat3.Parent := self;
  Lbchat3.AutoSize := false;
  Lbchat3.ADXForm := self.A2form;
  Lbchat3.Name := 'Lbchat3';
  //Lbchat3.OnClick := Lbchat3Click;
  Lbchat3.OnMouseDown := Lbchat1MouseDown;
  Lbchat3.OnMouseMove := Lbchat4MouseMove;

  Lbchat4 := TA2ChatLabel.Create(self);
  Lbchat4.Parent := self;
  Lbchat4.ADXForm := self.A2form;
  Lbchat4.AutoSize := false;
  Lbchat4.Name := 'Lbchat4';
  //Lbchat4.OnClick := Lbchat4Click;
  Lbchat4.OnMouseDown := Lbchat1MouseDown;
  Lbchat4.OnMouseMove := Lbchat4MouseMove;

    // Parent := FrmM;
  FrmM.AddA2Form(Self, A2form);
    //AddChat('辅助程序快捷键为HOME', WinRGB(28, 28, 28), 0);
  LbChat.Items.addObject('欲终止游戏请按 ALT+X', TObject(MakeLong(WinRGB(255, 255, 0), 0)));
  Lbchat1.NotTransParent := true;
  Lbchat2.NotTransParent := true;
  Lbchat3.NotTransParent := true;
  Lbchat4.NotTransParent := true;
  ChatPaint;

//    A2Form.FA2Hint.Ftype := hstTransparent;
  PGSkillLevel1.MinValue := 0;
  PGSkillLevel1.MaxValue := 100;
  PGSkillLevel1.Progress := 1;
  PGSkillLevel2.MinValue := 0;
  PGSkillLevel2.MaxValue := 10;
  PGSkillLevel2.Progress := 1;
  PgHead.Progress := 1;
  PgHead.MaxValue := 10000;
  PgHead.MinValue := 0;
  PGArm.Progress := 1;
  PGArm.MaxValue := 10000;
  PGArm.MinValue := 0;
  PGLeg.Progress := 1;
  PGLeg.MaxValue := 10000;
  PGLeg.MinValue := 0;

  PgLife.Progress := 1;
  PgLife.MaxValue := 100;
  PgLife.MinValue := 0;

  PgMagic.Progress := 1;
  PgMagic.MaxValue := 100;
  PgMagic.MinValue := 0;

  PgOutPower.Progress := 1;
  PgOutPower.MaxValue := 100;
  PgOutPower.MinValue := 0;

  PGInPower.Progress := 1;
  PGInPower.MaxValue := 100;
  PGInPower.MinValue := 0;
  if not G_Default1024 then
    ClientWidth := 800
  else
    ClientWidth := 1024;
  ClientHeight := 117;

  tempA2ILabel := TA2ILabel.Create(nil);
  tempA2ILabel.Parent := Self;
  FKindMark := 'grade';
  FItemBackGroundFileNameList := TStringList.Create;
  FItemBackGroundFileName := '';
  SetItemBackGround;

  SendMsayList := tstringlist.Create; //纸条 消息 纪录
  editset := nil; // @SAY_EdChatFrmBottomSetFocus;

  ALLKeyDownTick := 0;
    //pplication.HookMainWindow(AppKeyDownHook);
  Color := clBlack;
  energyGraphicsclass := TenergyGraphicsclass.Create(FrmM, Self);
  energyGraphicsclass.BringToFront;

  Left := 0;

  if not G_Default1024 then
    Top := fhei - Height
  else
    Top := fhei1024 - Height + 3;

  SetFormText;
  MapName := '';
  SaveChatList := TStringList.Create;
  SendChatList := tstringlist.Create;
  SendChatListItemIndex := -1;
  move_win_form := nil;
  shortcutLabels[0] := lblShortcut0;
  shortcutLabels[1] := lblShortcut1;
  shortcutLabels[2] := lblShortcut2;
  shortcutLabels[3] := lblShortcut3;
  shortcutLabels[4] := lblShortcut4;
  shortcutLabels[5] := lblShortcut5;
  shortcutLabels[6] := lblShortcut6;
  shortcutLabels[7] := lblShortcut7;
//    ShortcutKeyClear;
  UseMagicArr[0] := UseMagic1;
  UseMagicArr[1] := UseMagic2;
  UseMagicArr[2] := UseMagic3;
  UseMagicArr[3] := UseMagic4;

  if G_Default1024 then
  begin
    self.FenergyTop := fhei1024 - 117 - (36 div 2);
    self.FenergyLeft := (fwide1024 - 36) div 2;
  end else
  begin
    self.FenergyTop := fhei - 117 - (36 div 2);
    self.FenergyLeft := (fwide - 36) div 2;
  end;

    //2009 3 23 增加
  if WinVerType = wvtnew then
  begin
    SetnewVersion;
//  end
//  else if WinVerType = wvtold then
//  begin
//    SetOldVersion;
  end;
  //FrmM.AddA2Form(Self, A2form);
end;

procedure TFrmBottom.SetNewVersion();
begin
  if FTestPos then
    SetNewVersionTest();

  //else
   // SetNewVersionOld();
  FLoaded := True;
end;

//procedure TFrmBottom.SetOldVersion();
//begin
//  pgkBmp.getBmp('bottom.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//  Button_chooseChn.Enabled := false;
//end;

procedure TFrmBottom.FormDestroy(Sender: TObject);
begin
    //application.UnhookMainWindow(AppKeyDownHook);
  energyGraphicsclass.Free;
  SaveChatList.Free;
  SendChatList.Free;
  SendMsayList.Free;
  temping.Free;
  EdChat.Free;
  FUIConfig.Free;
  FUploadList.Free;
  FBlackList.Free;
  tempA2ILabel.Free; //2015.06.27在水一方
end;

procedure TFrmBottom.PGSkillLevelSET(aSkillLevel: integer);
var
  lv1, lv2: integer;
begin
  lv1 := aSkillLevel mod 100;
  lv2 := aSkillLevel div 100;
  lv2 := lv2 mod 10;
  PGSkillLevel1.Progress := lv1;
  PGSkillLevel2.Progress := lv2;

end;

procedure TFrmBottom.numSAY(astr: integer; aColor: byte; atext: string);
var
  rFColor, rBColor: word;
  str: string;
begin
  case acolor of
    SAY_COLOR_NORMAL:
      begin
        rFColor := WinRGB(22, 22, 22);
        rBColor := WinRGB(0, 0, 0);
      end;
    SAY_COLOR_SHOUT:
      begin
        rFColor := WinRGB(22, 22, 22);
        rBColor := WinRGB(0, 0, 24);
      end;
    SAY_COLOR_SYSTEM:
      begin
        rFColor := WinRGB(22, 22, 0);
        rBColor := WinRGB(0, 0, 0);
      end;
    SAY_COLOR_NOTICE:
      begin
        rFColor := WinRGB(255 div 8, 255 div 8, 255 div 8);
        rBColor := WinRGB(133 div 8, 133 div 8, 133 div 8);
      end;

    SAY_COLOR_GRADE0:
      begin
        rFColor := WinRGB(18, 16, 14);
        rBColor := WinRGB(2, 4, 5);
      end;
    SAY_COLOR_GRADE1:
      begin
        rFColor := WinRGB(26, 23, 21);
        rBColor := WinRGB(2, 4, 5);
      end;
    SAY_COLOR_GRADE2:
      begin
        rFColor := WinRGB(31, 29, 27);
        rBColor := WinRGB(2, 4, 5);
      end;
    SAY_COLOR_GRADE3:
      begin
        rFColor := WinRGB(22, 18, 8);
        rBColor := WinRGB(1, 4, 11);
      end;
    SAY_COLOR_GRADE4:
      begin
        rFColor := WinRGB(23, 13, 4);
        rBColor := WinRGB(1, 4, 11);
      end;
    SAY_COLOR_GRADE5:
      begin
        rFColor := WinRGB(31, 29, 21);
        rBColor := WinRGB(1, 4, 11);
      end;
    SAY_COLOR_GRADE6lcred:
      begin
        rFColor := ColorSysToDxColor($FF); //WinRGB(22, 22, 22);
        rBColor := WinRGB(0, 0, 0);
      end;

  else
    begin
      rFColor := WinRGB(22, 22, 22);
      rBColor := WinRGB(0, 0, 0);
    end;
  end;
  if (astr < low(cNumSayArr)) or (astr > HIGH(cNumSayArr)) then
  begin
    AddChat(format('错误消息:%d', [astr]), rFColor, rBColor);
    exit;
  end;
  str := cNumSayArr[astr];
  if atext <> '' then
  begin
    if pos('%s', str) > 0 then
    begin
      str := format(str, [atext]);
      AddChat(str, rFColor, rBColor);
    end
    else
    begin
      AddChat(str, rFColor, rBColor);
    end;
    exit;
  end;
  if astr = numsay_NOHIT then
  begin
    PersonBat.LeftMsgListadd(str, rFColor);
    exit;
  end;

  AddChat(str, rFColor, rBColor);

end;

procedure TFrmBottom.MessageProcess(var code: TWordComData);
var
  str, rdstr: string;
  cstr: string[1];
  pckey: PTCKey;
  psSay: PTSSay;
  PTTSShowCenterMsg: PTSShowCenterMsg;
  psChatMessage: PTSChatMessage;
  psChatItemMessage: PTSChatItemMessage;
  psChatItemMessageHead: PTSChatItemMessageHead;
  psChatItemMessagem: PTSChatItemMessageM;
  psLeftText: ptsLeftText;
  psAttribBase: PTSAttribBase;
  psAttriblife: PTSAttribLife;
  psEventString: PTSEventString; 
  psBuffData: PTBuffDataMessage;
  psAllBuffData: PTAllBuffDataMessage;
  i, aidstr, acolor, ashape: integer;
  Cl: TCharClass;
begin
  pckey := @Code.Data;
  case pckey^.rmsg of
    SM_NumSay:
      begin
        i := 1;
        aidstr := WordComData_GETbyte(Code, i);
        acolor := WordComData_GETbyte(Code, i);
        str := WordComData_GETstring(Code, i);
        numSAY(aidstr, acolor, str);
      end;
    SM_USEDMAGICSTRING:
      begin
        if frmCharAttrib.Visible then
          frmCharAttrib.update;
                //                ListboxUsedMagic.Clear;
        psEventString := @Code.data;
        PGSkillLevelSET(psEventString.rKEY);
        str := GetWordString(psEventString^.rWordString);
        for i := 0 to high(UseMagicArr) do
          UseMagicArr[i].Caption := '';
        for i := 0 to high(UseMagicArr) do
        begin
          str := GetValidStr3(str, rdstr, ',');
          if rdstr = '' then
            Break;

          UseMagicArr[i].Caption := rdstr;
        end;

      end;
    SM_ATTRIBBASE:
      begin
        psAttribBase := @Code.Data;
        with psAttribBase^ do
        begin
          maxlife := psAttribBase^.rlife;
          curlife := psAttribBase^.rcurlife;

          PGEnergy.MaxValue := psattribBase^.rEnergy;
          PGEnergy.Progress := psattribBase^.rCurEnergy;

          PGEnergy.Hint := Get10000To100(rCurEnergy) + '/' + Get10000To100(rEnergy);

          PGInPower.MaxValue := psattribBase^.rInPower;
          PGInPower.Progress := psattribBase^.rCurInPower;

          PGInPower.Hint := Get10000To100(rCurInPower) + '/' + Get10000To100(rInPower);

          PGOutPower.MaxValue := psattribBase^.rOutPower;
          PGOutPower.Progress := psattribBase^.rCurOutPower;

          PGOutPower.Hint := Get10000To100(rCurOutPower) + '/' + Get10000To100(rOutPower);

          PGMagic.MaxValue := psattribBase^.rMagic;
          PGMagic.Progress := psattribBase^.rCurMagic;

          PGMagic.Hint := Get10000To100(psattribbase^.rCurMagic) + '/' + Get10000To100(psattribbase^.rMagic);

          PGLife.MaxValue := maxlife;
          PGLife.Progress := curlife;

          PGLife.Hint := Get10000To100(curlife) + '/' + Get10000To100(maxlife);

        end;
      end;
    SM_ATTRIB_LIFE:
      begin
        psAttribLife := @Code.Data;
        curlife := psAttribLife^.rcurlife;
        PGLife.Progress := curlife;
        PGLife.Hint := IntToStr(curlife) + '/' + IntToStr(maxlife);

                //            LbLife.Caption := IntToStr(curlife) + '/' + IntToStr(maxlife);
      end;
    SM_LeftText:
      begin
        //if not FrmSound.A2CheckBox_ShowDamage.Checked then Exit;
        psLeftText := @Code.data;
        str := GetwordString(psLeftText^.rWordstring);
        ashape := psLeftText^.rshape;
        case psLeftText.rtype of
          mtLeftText:
            begin
              PersonBat.LeftMsgListadd(str, psLeftText^.rFColor, 0);
              exit;
            end;
          mtLeftText2:
            begin
              PersonBat.LeftMsgListadd2(str, psLeftText^.rFColor, 0);
              exit;
            end;
          mtLeftText3:
            begin
              PersonBat.LeftMsgListadd3(str, psLeftText^.rFColor, 0);
              exit;
            end;
          mtLeftText4:
            begin
              PersonBat.LeftMsgListadd4(str, psLeftText^.rFColor, 0);
              exit;
            end;
          mtLeftLightText:
            begin
              PersonBat.LeftMsgListadd(str, psLeftText^.rFColor, ashape);
              exit;
            end;
          mtLeftLightText2:
            begin
              PersonBat.LeftMsgListadd2(str, psLeftText^.rFColor, ashape);
              exit;
            end;
          mtLeftLightText3:
            begin
              PersonBat.LeftMsgListadd3(str, psLeftText^.rFColor, ashape);
              exit;
            end;
          mtLeftLightText4:
            begin
              PersonBat.LeftMsgListadd4(str, psLeftText^.rFColor, ashape);
              exit;
            end;
          mtLeftBigText:
            begin
              PersonBat.LeftMsgListadd(str, psLeftText^.rFColor, -1);
              exit;
            end;
          mtLeftBigText2:
            begin
              PersonBat.LeftMsgListadd2(str, psLeftText^.rFColor, -1);
              exit;
            end;
          mtLeftBigText3:
            begin
              PersonBat.LeftMsgListadd3(str, psLeftText^.rFColor, -1);
              exit;
            end;
          mtLeftBigText4:
            begin
              PersonBat.LeftMsgListadd4(str, psLeftText^.rFColor, -1);
              exit;
            end;
          mtNone:
            ;
        else
          exit;
        end;

      end;
    SM_CHATMESSAGE:
      begin

        psChatMessage := @Code.data;
        str := GetwordString(psChatMessage^.rWordstring);

        cstr := str;
        if (cstr = '[') or (cstr = '<') then
        begin
          if pos(':', str) > 1 then
          begin
            str := GetValidStr3(str, rdstr, ':');
            str := ChangeDontSay(str);
            rdstr := rdstr + ':' + str
          end
          else
            rdstr := str;
        end
        else
        begin
          str := ChangeDontSay(str);
          rdstr := str;
        end;

        AddChat(rdstr, psChatMessage^.rFColor, psChatMessage^.rBColor);
        str := '';
        rdstr := '';
      end;
    SM_CHATITEMMESSAGENORMAL:
      begin
        psChatItemMessage := @Code.data;
        psChatItemMessageHead := @Code.data;
        if psChatItemMessage^.rIsHead then
          str := GetwordString(psChatItemMessageHead^.rWordstring)
        else
          str := GetwordString(psChatItemMessage^.rWordstring);

        cstr := str;
        if (cstr = '[') or (cstr = '<') then
        begin
          if pos(':', str) > 1 then
          begin
            str := GetValidStr3(str, rdstr, ':');
            str := ChangeDontSay(str);
            rdstr := rdstr + ':' + str
          end else rdstr := str;
        end else
        begin
          str := ChangeDontSay(str);
          rdstr := str;
        end;
        Cl := CharList.CharGet(psChatItemMessage^.rid);
        if psChatItemMessage^.rIsHead then begin
          if Cl <> nil then Cl.SayItemHead(rdstr, psChatItemMessageHead);
          AddChatExHead(rdstr, psChatItemMessageHead^.rFColor, psChatItemMessageHead^.rBColor, psChatItemMessageHead);
        end
        else begin
          //if Cl <> nil then Cl.SayItem(rdstr, psChatItemMessage);
          ChangeChatEx(rdstr, psChatItemMessage^.rFColor, psChatItemMessage^.rBColor, psChatItemMessage);
        end;
        //AddChat(rdstr, psChatItemMessage^.rFColor, psChatItemMessage^.rBColor);
        str := '';
        rdstr := '';
      end;
    SM_CHATITEMMESSAGE:
      begin
        psChatItemMessage := @Code.data;
        psChatItemMessageHead := @Code.data;
        if psChatItemMessage^.rIsHead then
          str := GetwordString(psChatItemMessageHead^.rWordstring)
        else
          str := GetwordString(psChatItemMessage^.rWordstring);

        cstr := str;
        if (cstr = '[') or (cstr = '<') then
        begin
          if pos(':', str) > 1 then
          begin
            str := GetValidStr3(str, rdstr, ':');
            str := ChangeDontSay(str);
            //psChatItemMessage.rpos := psChatItemMessage.rpos + length(rdstr);
            rdstr := rdstr + ':' + str
          end else rdstr := str;
        end else
        begin
          str := ChangeDontSay(str);
          rdstr := str;
        end;

        if psChatItemMessage^.rIsHead then
          AddChatExHead(rdstr, psChatItemMessageHead^.rFColor, psChatItemMessageHead^.rBColor, psChatItemMessageHead)
        else
          ChangeChatEx(rdstr, psChatItemMessage^.rFColor, psChatItemMessage^.rBColor, psChatItemMessage);
        //AddChat(rdstr, psChatItemMessage^.rFColor, psChatItemMessage^.rBColor);
        str := '';
        rdstr := '';
      end;
    SM_SHOWCENTERMSG:
      begin

        PTTSShowCenterMsg := @Code.data;
        if (PTTSShowCenterMsg.rtype <> SHOWCENTERMSG_RollMSG) and (PTTSShowCenterMsg.rtype <> SHOWCENTERMSG_MagicMSG) then
        begin

          str := GetwordString(PTTSShowCenterMsg.rText);
          AddChat(str, PTTSShowCenterMsg.rColor, 0);
        end;
      end;
    SM_MSay:
      begin
        i := 1;
        str := WordComData_GETString(code, i);
        msayadd(trim(str)); //添加纸条记录

                //   AddChat(rdstr, WinRGB(22, 22, 22), 0);
        rdstr := WordComData_GETString(code, i);
        rdstr := format('%s> %s', [str, rdstr]);
        //检测是否为好友
        if HailFellowlist.ISUName(str) then
          AddChat(rdstr, ColorSysToDxColor($FF64FF), 0)
        else
          AddChat(rdstr, ColorSysToDxColor($0000B0B0), 0);
      end;
    SM_SAYITEMMESSAGEM:
      begin
        i := 1;
        psChatItemMessagem := @Code.data;
        str := GetWordString(psChatItemMessagem^.rWordString);

        msayadd(str);
        rdstr := format('%s> %s', [psChatItemMessagem^.rName, str]);

        AddChatEXM(rdstr, ColorSysToDxColor($0000B0B0), 0, psChatItemMessagem, Length('> ' + psChatItemMessagem^.rName));
      end;
    SM_SAY:
      begin
        psSay := @Code.data;
        str := GetwordString(psSay^.rWordstring);
        str := GetValidStr3(str, rdstr, ':');
        str := ChangeDontSay(str);
        rdstr := rdstr + ' :' + str;
        AddChat(rdstr, WinRGB(28, 28, 28), 0);

        str := '';
        rdstr := '';
                //            Cl := CharList.GetChar (psSay^.rid);
                //            if Cl <> nil then Cl.Say (GetwordString(pssay^.rWordstring));
      end;

    SM_ADDBUFF:
      begin
        psBuffData := @code.data;
        frmBuffPanel.addBuffData(psBuffData^.rBuffData);
      end;

    SM_DELBUFF:
      begin
        psBuffData := @code.data;
        frmBuffPanel.delBuffData(psBuffData^.rBuffData);
      end;

    SM_ALLBUFF:
      begin
        psAllBuffData := @code.data;
        frmMonsterBuffPanel.SetAllBuffData(psAllBuffData);
      end;

  end;
end;

procedure TFrmBottom.ChatPaint();

  {procedure _settextcolor(aid: integer; atemp: TA2Label);
  var
    col: integer;
    fcol, bcol: word;
    astr: string;
  begin

    fcol := ColorSysToDxColor(clWhite);
    bcol := ColorSysToDxColor($080808);
    astr := ' ';
    if LbChat.Items.Count >= aid then
    begin
      col := Integer(LbChat.Items.Objects[aid - 1]);

      fcol := LOWORD(Col);
      bcol := HIWORD(col);
      astr := LbChat.Items.Strings[aid - 1];
    end;

    if MakeLong(WinRGB(28, 28, 28), 0) = MakeLong(fcol, bcol) then
      bcol := ColorSysToDxColor($080808);
    if (bcol = 0) then
      bcol := ColorSysToDxColor($001C1C1C);

    if astr = '' then
      astr := ' ';
    atemp.BackColor := bcol;
   //  atemp.BackColor :=  ColorSysToDxColor($080808);
    atemp.FontColor := fcol;
    atemp.Caption := astr;
  end;}
  procedure _settextcolor(aid: integer; atemp: TA2ChatLabel);
  var
    col: integer;
    fcol, bcol: word;
    astr: string;
    tmp: tchatItemdata;
    _tmp: tobject;
  begin

    fcol := ColorSysToDxColor(clWhite);
    bcol := ColorSysToDxColor($080808);
    astr := ' ';
    if LbChat.Items.Count >= aid then
    begin
      _tmp := LbChat.Items.Objects[aid - 1];
      try
        if (_tmp is TChatItemData) then
        begin
          tmp := TChatItemData(LbChat.Items.Objects[aid - 1]);
          col := tmp.Col;
          fcol := LOWORD(Col);
          bcol := HIWORD(col);
          atemp.ChatItemData := @tmp.ItemData;
          atemp.HaveChatItem := True;
          atemp.ChatItemNameIndex := tmp.ItemPos;
          atemp.CHatItemName := tmp.ItemName;

        end else if (_tmp is TChatColor) then
        begin
          atemp.HaveChatItem := False;
          col := TChatColor(LbChat.Items.Objects[aid - 1]).Col;

          fcol := LOWORD(Col);
          bcol := HIWORD(col);
        end;
      except
        atemp.HaveChatItem := False;
        col := Integer(LbChat.Items.Objects[aid - 1]);

        fcol := LOWORD(Col);
        bcol := HIWORD(col);
      end;

      astr := LbChat.Items.Strings[aid - 1];
    end;

    if MakeLong(WinRGB(28, 28, 28), 0) = MakeLong(fcol, bcol) then
      bcol := ColorSysToDxColor($080808);
    if (bcol = 0) then
      bcol := ColorSysToDxColor($001C1C1C);
    if fcol = 0 then
      fcol := 29596;
    if astr = '' then astr := ' ';
    atemp.BackColor := bcol;
   //  atemp.BackColor :=  ColorSysToDxColor($080808);
    atemp.FontColor := fcol;
    atemp.Caption := astr;
  end;

begin
  _settextcolor(1, Lbchat1);
  _settextcolor(2, Lbchat2);
  _settextcolor(3, Lbchat3);
  _settextcolor(4, Lbchat4);

end;

procedure TFrmBottom.AddChat(astr: string; fcolor, bcolor: integer);
var
  str, rdstr, rastr, rbstr: string;
  col, iLen: Integer;
  addflag: Boolean;
begin
    //   FrmChatList.AddChat (astr, fcolor, bcolor);
  addflag := FALSE;
  str := astr;
  while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    if rdstr = '' then
      break;
    if pos('[队伍]', rdstr) = 1 then
    begin
      if chat_duiwu then
        addflag := TRUE;
    end
    else if chat_outcry then
    begin // 呐喊
      if rdstr[1] = '[' then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_Guild then
    begin // 门派
      if (rdstr[1] = '<') and (bcolor = 1) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_ally then
    begin // 联盟
      if (rdstr[1] = '<') and (bcolor = 2182) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_notice then
    begin // 公告
      if bcolor = 16912 then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_normal then
    begin // 对话
      if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
      begin
        addflag := TRUE;
      end;
    end;
    //ShowMessage(rdstr + '颜色:' + IntToStr(fcolor) + '/' + IntToStr(bcolor));

    if Addflag then
    begin
      if LbChat.Items.Count >= 4 then
        LbChat.Items.delete(0);
      col := MakeLong(fcolor, bcolor);
      //LbChat.Items.addObject(rdstr, TObject(col));
      LbChat.Items.addObject(rdstr, TChatColor.Create);
      TChatColor(LbChat.Items.Objects[LbChat.Items.Count - 1]).Col := col;
      frmHistory.add(rdstr, fcolor, bcolor);
//      if frmHistory.listHistory.Count >= 600 then
//        frmHistory.listHistory.DeleteItem(0);
//      //分割长的字符串
//      //先判断要截取的字符串最后一个字节的类型
//      //如果为汉字的第一个字节则减(加)一位
//      iLen := 94;
//      if Length(rdstr) > iLen then
//      begin
//        if ByteType(rdstr, iLen) = mbLeadByte then
//          iLen := iLen - 1;
//        rastr := copy(rdstr, 1, iLen);
//        rbstr := copy(rdstr, iLen + 1, Length(rdstr) - iLen);
//
//        frmHistory.listHistory.ChatList.AddObject(rastr, TChatColor.Create);
//        TChatColor(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).col := col;
//        frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
//        frmHistory.listHistory.ChatList.AddObject(rbstr, TChatColor.Create);
//        TChatColor(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).col := col;
//        frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
//      end
//      else
//      begin
//        frmHistory.listHistory.ChatList.AddObject(rdstr, TChatColor.Create);
//        TChatColor(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).col := col;
//        frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
//      end;
//      frmHistory.filter;
    end;

    LbChat.Itemindex := LbChat.Items.Count - 1;
    LbChat.Itemindex := -1;
  end;
    { // 寇摹扁 救焊捞扁 眠啊肺 官柴
       str := astr;
       while TRUE do begin
          str := GetValidStr3 (str, rdstr, #13);
          if rdstr = '' then break;
          if LbChat.Items.Count >= 4 then LbChat.Items.delete (0);

          col := MakeLong (fcolor, bcolor);
          LbChat.Items.addObject (rdstr, TObject (col) );

          LbChat.Itemindex := LbChat.Items.Count -1;
          LbChat.Itemindex := -1;
       end;
    }
  ChatPaint;
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
  str := num(year) + ('年') + num(mon) + ('月') + num(day) + ('日');
  str := str + num(hour) + ('时') + num(min) + ('分') + num(sec) + ('秒');
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

  try

    FrmMDCcanvas.Handle := FrmMDC;
    Bitmap.Canvas.CopyRect(FrmMRect, FrmMDCcanvas, FrmMRect);
    ReleaseDC(FrmM.Handle, FrmMDC);
  finally
    FrmMDCcanvas.Free;
  end;

end;

procedure TFrmBottom.captureDesk(bitmap: Tbitmap);
var
  FrmMRect: TRect;
  FrmMDC: HDC;
  FrmMDCcanvas: TCanvas;
begin
  BitMap.Width := Screen.Width;
  BitMap.Height := Screen.Height;
  FrmMRect := Rect(0, 0, Screen.Width, Screen.Height);

  FrmMDC := GetWindowDC(0);
  FrmMDCcanvas := TCanvas.Create;

  try

    FrmMDCcanvas.Handle := FrmMDC;
    Bitmap.Canvas.CopyRect(FrmMRect, FrmMDCcanvas, FrmMRect);
    ReleaseDC(0, FrmMDC);
  finally
    FrmMDCcanvas.Free;
  end;

end;

procedure TFrmBottom.ClientCapture;
var
  abitmap: TBitmap;
  str: string;
begin
  if mmAnsTick < integer(printKeyDownTick) + 100 then
    exit;
  printKeyDownTick := mmAnsTick;

  abitmap := TBitmap.Create;
  try
    capture(abitmap);
    if DirExists('.\capture') then


    else
      Mkdir('.\' + 'capture');
    str := SaveFileName;
    aBitMap.SaveToFile('.\capture\' + str + '.bmp');
  finally
    abitmap.Free;
  end;
  PersonBat.LeftMsgListadd3('截图(' + str + ')', ColorSysToDxColor(clLime));

end;

procedure TFrmBottom.SnapUpload;
var
  abitmap: TBitmap;
  MyJpeg: TJpegImage;
  mstream: TMemoryStream;
  tupd: TUploadPacketData;
  ptud: PTUploadPacketData;
  i, TatalNum, CurTick, datasize, packsize: integer;
begin
  abitmap := TBitmap.Create;
  MyJpeg := TJpegImage.Create;
  mstream := TMemoryStream.Create;
  try
    captureDesk(abitmap);
    MyJpeg.Assign(aBitMap);
    MyJpeg.CompressionQuality := 25;
    MyJpeg.Compress;
    MyJpeg.SaveToStream(mstream);
    TatalNum := mstream.Size div splitsize;
    if TatalNum * splitsize < mstream.Size then
      inc(TatalNum);
    CurTick := mmAnsTick;
    mstream.Seek(0, 0);
    for i := 0 to TatalNum - 1 do begin
      tupd.msg := CM_Upload;
      tupd.rType := UploadScreen;
      tupd.rallnum := TatalNum;
      tupd.rallsize := mstream.Size;
      tupd.rSendTick := CurTick;
      tupd.rRecvTick := 0;
      tupd.rid := i;
      if mstream.Size - mstream.Position < splitsize then
        datasize := mstream.Size - mstream.Position
      else
        datasize := splitsize;
      tupd.Data.Size := datasize;
      mstream.ReadBuffer(tupd.Data.Data, datasize);
      New(ptud);
      ptud^ := tupd;
      FUploadList.Add(ptud);
    end;
  finally
    abitmap.Free;
    MyJpeg.Free;
    mstream.Free;
  end;

end;

function TFrmBottom.GetProcessPath(ProcessID: Cardinal): string;
var
  pProcess: THandle;
  buf: array[0..MAX_PATH] of char;
  hMod: HMODULE;
  cbNeeded: DWORD;
begin
  Result := '';
  pProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, FALSE, ProcessID);
  if pProcess <> 0 then
  begin
    if EnumProcessModules(pProcess, @hMod, sizeof(hMod), cbNeeded) then
    begin
      ZeroMemory(@buf, MAX_PATH + 1);
      GetModuleFileNameEx(pProcess, hMod, buf, MAX_PATH + 1);
      Result := strpas(buf);
    end;
  end;
end;

procedure GetProcessList(mstream: TMemoryStream);
var
  TempH: THandle;
  pNext: Boolean;
  lppe: TProcessentry32;
  nRow: Integer;
  ts: TStringList;
  str, filemd5: string;
  nstream: TMemoryStream;
begin
  ts := TStringList.Create;
  try
    TempH := CreateToolhelp32Snapshot(TH32cs_SnapProcess, 0);
    lppe.dwSize := sizeof(lppe);
    pNext := Process32First(TempH, lppe);
    nRow := 1;
    while pNext do
    begin
      filemd5 := GetFileMD5(FrmBottom.GetProcessPath(lppe.th32ProcessID));
      str := Format('%3d %6d %s %s', [nRow, lppe.th32ProcessID, filemd5, string(lppe.szExeFile)]);
      ts.Add(str);
      Inc(nRow);
      pNext := Process32Next(TempH, lppe);
    end;
    CloseHandle(TempH);
  finally
    if (ts.count > 0) and (mstream <> nil) then begin
      nstream := TMemoryStream.Create;
      try
        ts.SaveToStream(nstream);
        nstream.Seek(0, 0);
        mstream.Seek(0, 0);
        CompressStream(nstream, mstream);
      finally
        nstream.Free;
      end;
    end;
    ts.free;
  end;
end;

function ChcekBlackList(ts: TStringList): Boolean;
var
  TempH: THandle;
  pNext: Boolean;
  lppe: TProcessentry32;
  filemd5, filename: string;
  nstream: TMemoryStream;
  i: integer;
begin
{$I SE_PROTECT_START_MUTATION.inc}
  Result := False;
  TempH := CreateToolhelp32Snapshot(TH32cs_SnapProcess, 0);
  try
    lppe.dwSize := sizeof(lppe);
    pNext := Process32First(TempH, lppe);
    while pNext do
    begin
      filename := FrmBottom.GetProcessPath(lppe.th32ProcessID);
      if (lppe.th32ProcessID > 100) and (filename <> '') and (filename[1] <> '\') then begin
        filemd5 := GetFileMD5(filename);
        for i := 0 to ts.count - 1 do
          if filemd5 = ts.Strings[i] then begin
            Result := True;
            Exit;
          end;
      end;
      pNext := Process32Next(TempH, lppe);
    end;
  finally
    CloseHandle(TempH);
  end;
{$I SE_PROTECT_END.inc}
end;

procedure TFrmBottom.ProcListUpload;
var
  mstream: TMemoryStream;
  tupd: TUploadPacketData;
  ptud: PTUploadPacketData;
  i, TatalNum, CurTick, datasize, packsize: integer;
begin
  mstream := TMemoryStream.Create;
  try
    GetProcessList(mstream);
    if mstream.Size = 0 then exit;
    TatalNum := mstream.Size div splitsize;
    if TatalNum * splitsize < mstream.Size then
      inc(TatalNum);
    CurTick := mmAnsTick;
    mstream.Seek(0, 0);
    for i := 0 to TatalNum - 1 do begin
      tupd.msg := CM_Upload;
      tupd.rType := UploadProcess;
      tupd.rallnum := TatalNum;
      tupd.rallsize := mstream.Size;
      tupd.rSendTick := CurTick;
      tupd.rRecvTick := 0;
      tupd.rid := i;
      if mstream.Size - mstream.Position < splitsize then
        datasize := mstream.Size - mstream.Position
      else
        datasize := splitsize;
      tupd.Data.Size := datasize;
      mstream.ReadBuffer(tupd.Data.Data, datasize);
      New(ptud);
      ptud^ := tupd;
      FUploadList.Add(ptud);
    end;
  finally
    mstream.Free;
  end;

end;

procedure TFrmBottom.ProcFileUpload(ProcessID: Cardinal);
var
  mstream, nstream: TMemoryStream;
  tupd: TUploadPacketData;
  ptud: PTUploadPacketData;
  i, TatalNum, CurTick, datasize, packsize: integer;
  filename: string;
begin
  mstream := TMemoryStream.Create;
  nstream := TMemoryStream.Create;
  try
    filename := GetProcessPath(ProcessID);
    if filename = '' then exit;
    try
      nstream.LoadFromFile(filename);
    except
      exit;
    end;
    if nstream.Size = 0 then exit;

    nstream.Seek(0, 0);
    CompressStream(nstream, mstream);

    TatalNum := mstream.Size div splitsize;
    if TatalNum * splitsize < mstream.Size then
      inc(TatalNum);
    CurTick := mmAnsTick;
    mstream.Seek(0, 0);
    for i := 0 to TatalNum - 1 do begin
      tupd.msg := CM_Upload;
      tupd.rType := UploadFile;
      tupd.rallnum := TatalNum;
      tupd.rallsize := mstream.Size;
      tupd.rSendTick := CurTick;
      tupd.rRecvTick := 0;
      tupd.rid := i;
      if mstream.Size - mstream.Position < splitsize then
        datasize := mstream.Size - mstream.Position
      else
        datasize := splitsize;
      tupd.Data.Size := datasize;
      mstream.ReadBuffer(tupd.Data.Data, datasize);
      New(ptud);
      ptud^ := tupd;
      FUploadList.Add(ptud);
    end;
  finally
    mstream.Free;
    nstream.Free;
  end;

end;

procedure TFrmBottom.ExecUpload;
var
  ptud: PTUploadPacketData;
  CurTick, packsize: integer;
begin
  try
    if FUploadList.Count > 0 then begin
      if FUploadInterval > mmAnsTick - 100 then exit;
      FUploadInterval := mmAnsTick;
      ptud := PTUploadPacketData(FUploadList.Items[0]);
      packsize := SizeOf(integer) * 5 + SizeOf(byte) * 2 + SizeOf(word) + ptud^.Data.Size;

      Frmfbl.SocketAddData(packsize, ptud);
      Frmfbl.PacketSender.Update;
      FUploadList.Delete(0);
      Dispose(ptud);
    end
    else
      FUploadInterval := 0;
  finally
  end;

end;

//检测进程黑名单

procedure TFrmBottom.ExecCheckBlackList;
var
  ptud: PTUploadPacketData;
  CurTick, packsize: integer;
begin
  try
    if FBlackList.Count > 0 then begin
     // if FCheckBLInterval > mmAnsTick - 360000 then exit;
      FCheckBLInterval := mmAnsTick;
      if ChcekBlackList(FBlackList) then begin
        //FrmBottom.AddChat('黑名单测试...发现黑名单进程', WinRGB(22, 22, 0), 0);
        ExitProcess(0);
      end;
    end;
  finally
  end;

end;

var
  LbChatClickFlag: Boolean = TRUE;

    /////////////////////////////// LbChat events //////////////////////////////////

procedure TFrmBottom.LbChatDblClick(Sender: TObject);
{
var
   idx : integer;
   str, rdstr : string;
}
begin
    { // 快急阜酒初澜
       boShowChat := not boShowChat;
       LbChatClickFlag := FALSE;
       idx := TListBox(Sender).itemindex;
       if (idx > -1) and (idx < 4) then begin
          str := LbChat.Items[idx];
          str := GetValidStr3 (str, rdstr, ':');
          EdChat.Text := str;
       end;
       LbChatClickFlag := TRUE;
    }
end;

procedure TFrmBottom.LBChatDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  col: integer;
  fcol, bcol, r, g, b: word;
begin

  col := Integer(LbChat.Items.Objects[Index]);

  fcol := LOWORD(Col);
  bcol := HIWORD(col);

  WinVRGB(bcol, r, g, b);
  r := r * 8;
  g := g * 8;
  b := b * 8;
  LbChat.Canvas.Brush.Color := RGB(r, g, b);
  LBChat.Canvas.FillRect(Rect);

  WinVRGB(fcol, r, g, b);
  r := r * 8;
  g := g * 8;
  b := b * 8;
  LbChat.Canvas.Font.Color := RGB(r, g, b);
  LBChat.Canvas.TextOut(Rect.left, Rect.top, LbChat.Items[Index]);
end;

procedure TFrmBottom.LbChatMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if LbChatClickFlag then
    boShowChat := not boShowChat;
  SAY_EdChatFrmBottomSetFocus;
end;
/////////////////////////////// EdChat events //////////////////////////////////

procedure TFrmBottom.EdChatEnter(Sender: TObject);
begin
    //    SetImeMode(EdChat.Handle, 1);
end;

procedure TFrmBottom.msayadd(aname: string);
begin
  msayDel(aname); //不管存在不存在，删除下
  SendMsayList.Add(aname); //添加最新的
  SendMsayListItemIndex := SendMsayList.Count - 1; //当前选中为最后添加的
//  if msayGet(aname) = false then
//    SendMsayList.Add(aname);
end;

function TFrmBottom.msayGet(aname: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to SendMsayList.Count - 1 do
  begin
    if SendMsayList[i] = aname then
    begin
      result := true;
      exit;
    end;
  end;
end;

function TFrmBottom.msayDel(aname: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to SendMsayList.Count - 1 do
  begin
    if SendMsayList[i] = aname then
    begin
      SendMsayList.Delete(i);
      result := true;
      exit;
    end;
  end;
end;

procedure TFrmBottom.Msaysend(aname, astr: string);
var
  tempsend: TWordComData;
  rdstr: string;
begin
  if aname = '' then Exit;
  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_MSay);
  WordComData_ADDstring(tempsend, aname);
  WordComData_ADDstring(tempsend, astr);
  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
  rdstr := format('%s" %s', [aname, astr]);
  AddChat(rdstr, ColorSysToDxColor($00008890), 0);
  msayadd(trim(aname));
end;

procedure TFrmBottom.sendsay(strsay: string; var Key: Word);
var
  Cl: TCharClass;
  cKey: TCKey;
  i, cnt: integer;
  str, str2, aname: string;
  cSay: TCSay;
  strs: array[0..15] of string;
  tmpStr: string;
begin

  if (key = VK_RETURN) and (strsay <> '') then
  begin // Send SayData
    str := strsay;
    for i := 0 to 1 do
    begin
      str := GetValidStr3(str, strs[i], ' ');
      if str = '' then
        break;
    end;
    str2 := str;
//    if strsay[1] = '~' then
//    begin
//      if frmProcession.A2ListBox1.Count > 0 then
//        frmProcession.sendSay(strsay)
//      else
//      begin
//        FrmBottom.Editchannel.Caption := '当前';
//        FrmBottom.AddChat('你现在还没有队伍', WinRGB(255, 255, 0), 0);
//      end;
//    end
//    else
    if strs[0] = '@纸条' then
    begin
      Msaysend(strs[1], str2);
    end
    else
    begin
      tmpStr := strsay;
//      if (tmpStr[1] = '!') and (tmpStr[2] = '!') then
//      begin
//                //如果没有帮派，不发送消息 退出
//        if frmGuild.guildname = '' then
//        begin
//          FrmBottom.Editchannel.Caption := '当前';
//          FrmBottom.AddChat('你还没有加入门派', WinRGB(255, 255, 0), 0);
//          exit;
//        end;
//      end;
      cSay.rmsg := CM_SAY;
      SetWordString(cSay.rWordString, strsay);
      cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
      Frmfbl.SocketAddData(cnt, @csay);
    end;
    if SendChatList.Count > 100 then
      SendChatList.Delete(0);
    SendChatList.Add(strsay);
    SendChatListItemIndex := SendChatList.Count - 1;
  end;
end;

procedure TFrmBottom.sendsayitem(strsay: string; var Key: Word);
var
  Cl: TCharClass;
  cKey: TCKey;
  i, cnt: integer;
  str, str2, aname: string;
  cSay: TCSay;
  cSayItem: TCSayItem;
  cSayItemM: TCSayItemM;
  strs: array[0..15] of string;
  tmpStr: string;
  itemData: titemData;
begin

  if (key = VK_RETURN) then
  begin // Send SayData
    str := strsay;
    for i := 0 to 1 do
    begin
      str := GetValidStr3(str, strs[i], ' ');
      if str = '' then break;
    end;
    str2 := str;
    if strsay = '' then
    begin
      cSayItem.rmsg := CM_SAYITEM;
      cSayItem.rtype := 2;

      cSayItem.rpos := FSelectedChatItemPos;
      copymemory(@cSayItem.rChatItemData, @self.FSelectedChatItemData, sizeof(TItemData));

      SetWordString(cSayItem.rWordString, strsay);
      cnt := sizeof(cSayItem) - sizeof(TWordString) + SizeOfWordString(cSayItem.rWordString);
      Frmfbl.SocketAddDataEx(cnt, @cSayItem);
    end else
    begin
      //if EdChat.HaveChatItem then //2015.06.28 在水一方
      //  Self.FSelectedChatItemPos := EdChat.SelectedChatItemPos;
//      if strsay[1] = '~' then
//      begin
//        if frmProcession.A2ListBox1.Count > 0 then
//          frmProcession.sendSay(strsay)
//        else
//        begin
//          FrmBottom.Editchannel.Caption := '当前';
//          FrmBottom.AddChat('你现在还没有队伍', WinRGB(255, 255, 0), 0);
//        end;
//      end
//      else
      if strs[0] = '@纸条' then
      begin
        cSayItemM.rmsg := CM_MSayItem;
        cSayItemM.rtype := 2;
        cSayItemM.rName := strs[1];
        cSayItemM.rpos := FSelectedChatItemPos - length('@纸条 ' + strs[1] + ' ');
        copymemory(@cSayItemM.rChatItemData, @self.FSelectedChatItemData, sizeof(TItemData));

        SetWordString(cSayItemM.rWordString, str2);
        cnt := sizeof(cSayItemM) - sizeof(TWordString) + SizeOfWordString(cSayItemM.rWordString);
        Frmfbl.SocketAddDataEx(cnt, @cSayItemM);

        Msaysendex(strs[1], str2, cSayItemM);
      end
      else
      begin
        tmpStr := strsay;
        if (tmpStr[1] = '!') and (tmpStr[2] = '!') then
        begin
                //如果没有帮派，不发送消息 退出
          if frmGuild.guildname = '' then
          begin
            FrmBottom.Editchannel.Caption := '当前';
            FrmBottom.AddChat('你还没有帮派', WinRGB(255, 255, 0), 0);
            exit;
          end;
        end;
        cSayItem.rmsg := CM_SAYITEM;
        cSayItem.rtype := 2;

        cSayItem.rpos := FSelectedChatItemPos;
        copymemory(@cSayItem.rChatItemData, @self.FSelectedChatItemData, sizeof(TItemData));

        SetWordString(cSayItem.rWordString, strsay);
        cnt := sizeof(cSayItem) - sizeof(TWordString) + SizeOfWordString(cSayItem.rWordString);
        Frmfbl.SocketAddDataEx(cnt, @cSayItem);
      end;
    end;
    if SendChatList.Count > 100 then SendChatList.Delete(0);
    SendChatList.Add(strsay);
    SendChatListItemIndex := SendChatList.Count - 1;
    fillchar(self.FSelectedChatItemData, sizeof(titemdata), 0);
    EdChat.SelectedChatItemPos := -1;
    EdChat.HaveChatItem := false;
  end;
end;

procedure TFrmBottom.AppKeyDown(Key: Word; Shift: TShiftState);
var
  Cl: TCharClass;
  cKey: TCKey;
begin
  if mmAnsTick < integer(ALLKeyDownTick) + 25 then
    exit;

  if not ReConnetFlag then exit;

  case Key of
    0..20:
      ;
  else
    ALLKeyDownTick := mmAnsTick;

  end;

  if Visible = false then
    exit;

  if (ssCtrl in Shift) then
    case key of
      49:
        shortcutLabels[0].OnClick(shortcutLabels[0]); //1
      50:
        shortcutLabels[1].OnClick(shortcutLabels[1]); //2
      51:
        shortcutLabels[2].OnClick(shortcutLabels[2]); //3
      52:
        shortcutLabels[3].OnClick(shortcutLabels[3]); //4
      53:
        shortcutLabels[4].OnClick(shortcutLabels[4]); //5
      54:
        shortcutLabels[5].OnClick(shortcutLabels[5]); //6
      55:
        shortcutLabels[6].OnClick(shortcutLabels[6]); //7
      56:
        shortcutLabels[7].OnClick(shortcutLabels[7]); //8
    end;

  case key of
//    VK_INSERT:
//      begin
//        FrmLittleMap.Visible := not FrmLittleMap.Visible;
//      end;
    VK_F1:
      begin
        G_Default1024 := not G_Default1024;
        FrmM.changeScreen;
//        if frmHelp.Visible then
//          frmHelp.Visible := false
//        else
//          frmHelp.Visible := true;
      end;
    VK_F5:
      FrmAttrib.KeySaveAction(0);
    VK_F6:
      FrmAttrib.KeySaveAction(1);
    VK_F7:
      FrmAttrib.KeySaveAction(2);
    VK_F8:
      FrmAttrib.KeySaveAction(3);
    VK_F9:
      FrmAttrib.KeySaveAction(4);
    VK_F10:
      FrmAttrib.KeySaveAction(5);
    VK_F11:
      FrmAttrib.KeySaveAction(6);
    VK_F12:
      FrmAttrib.KeySaveAction(7);
//    VK_HOME:
//      begin
//        FrmGameToolsNew.Visible := not FrmGameToolsNew.Visible;
//        SAY_EdChatFrmBottomSetFocus;
//      end;

  else
    begin
      if key in [VK_F2, VK_F3, VK_F4] then
      begin
        ckey.rmsg := CM_KEYDOWN;
        ckey.rkey := key;
        Frmfbl.SocketAddData(sizeof(Ckey), @Ckey);
      end;
      Cl := CharList.CharGet(CharCenterId);
      if Cl = nil then
        exit;
      if Cl.AllowAddAction = FALSE then
        exit;

      case key of
        VK_F4:
          CL.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, cl.feature, AM_HELLO);
      end;
    end;
        // EdChat.SetFocus;
  end;
end;

procedure TFrmBottom.EdChatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Keyshift := Shift;
  AppKeyDown(key, Shift);
   { if ssalt in Shift then
    begin
        case key of
            word('z'), word('Z'):
                begin
                    boShowName := true;
                end;
            //VK_F4:
            //    begin
            //        BtnExitClick(nil);
            //    end;
        end;

    end;
   }
  if EdChat.Text = 'dio m1000y c log open' then
  begin
    FrmConsole.show;
    EdChat.Text := '';
    exit;
  end;
  if not self.EdChat.HaveChatItem then
    sendsay(EdChat.Text, key)
  else
    sendsayitem(EdChat.Text, key);
  if (key = VK_RETURN) or (key = VK_ESCAPE) then
  begin // EdChat.Text Clear
    if WinVerType = wvtold then
    begin
      EdChat.Text := '';
    end
    else if WinVerType = wvtnew then
    begin
      if Editchannel.Caption = '门派' then
      begin
        EdChat.Text := '!!';
      end
      else if Editchannel.Caption = '同盟' then
      begin
        EdChat.Text := '!!!';
      end
      else if Editchannel.Caption = '地图' then
      begin
        EdChat.Text := '@地图' + ' ';
      end
      else if Editchannel.Caption = '队伍' then
      begin
        EdChat.Text := '~';
      end
      else if Editchannel.Caption = '纸条' then
      begin
        EdChat.Text := '@纸条' + ' ';
      end
      else if Editchannel.Caption = '世界' then
      begin
        EdChat.Text := '! ';
      end
      else
      begin
        EdChat.Text := '';
      end;
      FCurEdChatText := EdChat.Text;
      FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
    end;
    exit;
  end;
end;

procedure TFrmBottom.EdChatKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = char(VK_ESCAPE)) or (key = char(VK_RETURN)) then
    key := char(0);
end;

procedure TFrmBottom.EdChatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  cSay: TCSay;
  cnt: integer;
  Cl: TCharClass;
  aStr: string;
begin
  Keyshift := Shift;
  if ssAlt in Shift then
  begin
    case Key of
            {ALT+1=角色信息
            ALT+2=角色物品
            ALT+3=武功窗
            ALT+4=门派窗
            ALT+5=任务窗
            ALT+6=辅助窗
            ALT+7=系统设置窗
            ALT+X=退出游戏    已有  不变

            ALT+Q=好友窗
            ALT+w=合成窗
            ALT+E=排行窗
            ALT+R=强化窗
            ALT+F=探查窗     FSearch.pas
            ALT+S=商城窗

            ALT+C=聊天纪录    已有  不变
            ALT+M=地图        已有  不变
            }

{            word('z'), word('Z'):
                begin
                    boShowName := false;
                end;   }
         //2015年10月22日屏蔽技能快捷键
//          word('j'), WORD('J'): //ALT+J  技能信息
//        begin
//          frmSkill.Visible := true;
//          frmSkill.send_Get_Job_blueprint_Menu;
//          FrmM.SetA2Form(frmSkill, frmSkill.A2form);
//        end;
//      word('l'), word('L'):
//        begin
//{$IFDEF gm}
//                 {   frmTM := tfrmTM.Create(frmm);
//                    try
//                        frmTM.ShowModal;
//                    finally
//                        frmTM.Free;
//                        frmTM := nil;
//                    end;  }
//
//{$ENDIF}
//        end;
      //属性快捷键
      word('1'):
        btnCharAttribClick(nil);
      //物品快捷键
      word('2'):
        ButtonWearClick(nil);
      //武功快捷键
      word('3'):
        BtnMagicClick(nil);
      //门派快捷键
      word('4'):
        begin
          //todo:门派
          frmGuild.Visible := not frmGuild.Visible;
          if frmGuild.Visible then
          begin
            FrmM.SetA2Form(frmGuild, frmGuild.A2form);
            FrmM.move_win_form_Align(frmGuild, mwfCenter);
          end;
        end;
      //任务快捷键
      word('5'):
        begin
          frmNewQuest.Visible := not frmNewQuest.Visible;
          if frmNewQuest.Visible then
          begin
            FrmM.SetA2Form(frmNewQuest, frmNewQuest.A2form);
            FrmM.move_win_form_Align(frmNewQuest, mwfCenter);
          end;
        end;
      //辅助快捷键
      word('6'):
        begin
          FrmGameToolsNew.Visible := not FrmGameToolsNew.Visible;
          SAY_EdChatFrmBottomSetFocus;
        end;
        //系统设置
      word('7'):
        begin
          FrmSound.Visible := not FrmSound.Visible; // option芒
                      //   FrmSelMagic.Visible := not FrmSelMagic.Visible;
          if FrmSound.Visible then
          begin

            FrmM.SetA2Form(FrmSound, FrmSound.A2form);
                          //   FrmM.move_win_form_Align(FrmNewMagic, mwfRight);
          end;
        end;
        //退出快捷键
      word('X'), word('x'):
        begin
          BtnExitClick(nil);
        end;
     //BtnSelMagicClick(nil);
//      word('T'), word('t'):
//        begin
//          frmProcession.Visible := not frmProcession.Visible;
//          if frmProcession.Visible then
//          begin
//            FrmM.SetA2Form(frmProcession, frmProcession.A2form);
//            FrmM.move_win_form_Align(frmProcession, mwfCenter);
//          end;
//        end;
    //  word('S'), word('s'): sbthailfellowClick(nil);
            { word('F'), word('f'):
                 begin

                     //  FrmSearch.Visible := not FrmSearch.Visible; //1
                     if not FrmSearch.Visible then
                     begin
                         cSay.rmsg := CM_SAY;
                         SetWordString(cSay.rWordString, '@探查');
                         cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
                         Frmfbl.SocketAddData(cnt, @csay);
                     end;
                 end;}
        //商城快捷键
      word('S'), word('s'):
        bitEmporiaClick(nil);
        //聊天记录快捷键
      word('C'), word('c'):
        begin
          frmHistory.Visible := not frmHistory.Visible; //1
          if frmHistory.Visible then
          begin
            FrmM.SetA2Form(frmHistory, frmHistory.A2form);
          end;
          SAY_EdChatFrmBottomSetFocus;
        end;
        //小地图快捷键
      word('M'), word('m'):
        begin
          if map.GetMapWidth < 50 then
            exit;
          Cl := CharList.CharGet(CharCenterId);
          if Cl = nil then
            exit;
          if Cl.Feature.rfeaturestate = wfs_die then exit;
          FrmMiniMap.Visible := not FrmMiniMap.Visible;
          if FrmMiniMap.Visible then
          begin
            FrmMiniMap.GETnpcList;
            FrmM.SetA2Form(FrmMiniMap, FrmMiniMap.A2form);
          end;
        end;
        //喇叭快捷键
      word('H'), word('h'):
        begin
          FrmHorn.Visible := not FrmHorn.Visible; //1
          if FrmHorn.Visible then
          begin
            FrmM.SetA2Form(FrmHorn, FrmHorn.A2form);
          end;
          //SAY_EdChatFrmBottomSetFocus;
        end;
        //合成道具快捷键
      word('W'), word('w'):
        begin
          if frmComplexProperties.Visible = false then
            frmComplexProperties.sendshowForm
          else
            frmComplexProperties.A2ButtonCloseClick(nil);
        end;
        //强化道具快捷键
      word('R'), word('r'):
        begin
          if frmItemUpgrade.Visible = false then
            frmItemUpgrade.sendshowForm
          else
            frmItemUpgrade.A2ButtonCloseClick(nil);
        end;
        //好友快捷键
      word('Q'), word('q'):
        begin
          FrmHailFellow.Visible := not FrmHailFellow.Visible; //1
          if FrmHailFellow.Visible then
          begin
            FrmM.SetA2Form(FrmHailFellow, FrmHailFellow.A2form);
          end;
        end;
      word('E'), word('e'):
        begin
          frmBillboardcharts.Visible := not frmBillboardcharts.Visible;
          if frmBillboardcharts.Visible then
          begin
            FrmM.SetA2Form(frmBillboardcharts, frmBillboardcharts.A2form);
            FrmM.move_win_form_Align(frmBillboardcharts, mwfCenter);
          end;
        end;

      //全屏切换
      VK_RETURN:
        begin // Screnn Mode Change
          if (NATION_VERSION = NATION_TAIWAN) or (NATION_VERSION = NATION_CHINA_1) then
            exit;

          if FullScreen_time + 200 > mmAnsTick then
          begin
            AddChat('窗口/全屏切换太快。', WinRGB(22, 22, 0), 0);
            exit;
          end;
          FullScreen_time := mmAnsTick;
          //全屏检测系统是否WIN10
          try
            aStr := GetWMIProperty('OperatingSystem', 'Version');
            if pos('10.', aStr) <> 0 then
            begin
              FrmBottom.AddChat('WIN10系统暂不支持全屏游戏。', WinRGB(22, 22, 0), 0);
              exit;
            end;
          finally
          end;

          FrmM.SaveAndDeleteAllA2Form;
          FrmM.DXDraw.Finalize;
          if doFullScreen in FrmM.DXDraw.Options then
          begin
            FrmM.BorderStyle := bsSingle;
            if not G_Default1024 then
            begin
              FrmM.ClientWidth := fwide;
              FrmM.ClientHeight := fhei;
            end
            else
            begin
              FrmM.ClientWidth := fwide1024;
              FrmM.ClientHeight := fhei1024;
            end;
            FrmM.DXDraw.Options := FrmM.DXDraw.Options - [doFullScreen];

          end
          else
          begin
            FrmM.BorderStyle := bsNone;
            if not G_Default1024 then
            begin
              FrmM.ClientWidth := fwide;
              FrmM.ClientHeight := fhei;
            end
            else
            begin
              FrmM.ClientWidth := fwide1024;
              FrmM.ClientHeight := fhei1024;
            end;
            FrmM.DXDraw.Options := FrmM.DXDraw.Options + [doFullScreen];

          end;
          FrmM.DXDraw.Initialize;
          FrmM.RestoreAndAddAllA2Form;
          if FrmBottom.Visible then
          begin
            SAY_EdChatFrmBottomSetFocus;
          end;
          exit;
        end;


        //ALT + P / ALT + O 测试UI调试用
      word('P'), word('p'):
        begin
//          //排行榜
//          if frmBillboardcharts.Visible then
//          begin
//            frmBillboardcharts.SetNewVersion;
//          end;
//          if FrmWearItemuSER.VISIBLE then
//          begin
//            FrmWearItemuSER.SetNewVersion;
//          end;
//          if FrmQuantity.Visible then
//            FrmQuantity.SetNewVersion;
//          if frmNPCTrade.Visible then
//            frmNPCTrade.SetNewVersion;
//          if FrmcMessageBox.Visible then
//            FrmcMessageBox.SetNewVersion;
//          if FrmSound.Visible then
//            FrmSound.SetNewVersion;
//          if frmCharAttrib.Visible then
//            frmCharAttrib.SetNewVersion;
//          if FrmWearItem.Visible then
//          begin
//            FrmWearItem.SetNewVersion;
//            FrmWearItem.SetFeature;
//            FrmWearItem.DrawWearItem;
//            FrmM.SetA2Form(FrmWearItem, FrmWearItem.A2form);
//          end;
//          if FrmNewMagic.Visible then
//          begin
//
//            FrmNewMagic.SetNewVersion;
//          end;
//
//          if frmGuild.Visible then
//          begin
//
//            frmGuild.SetNewVersion;
//          //  frmGuild.Invalidate;
//            FrmM.SetA2Form(frmGuild, frmGuild.A2form);
//          end;
//          if frmQuest.Visible then
//          begin
//
//            frmQuest.SetNewVersion;
//          end;
//          if frmNewQuest.Visible then
//          begin
//            frmNewQuest.SetNewVersion;
//          end;
//          if FrmGameToolsNew.Visible then
//          begin
//            FrmGameToolsNew.SetNewVersion;
//          end;
//
//          if frmEmporia.Visible then
//          begin
//            frmEmporia.SetNewVersion;
//          end;
//
//          if FrmHailFellow.Visible then
//          begin
//
//            FrmHailFellow.SetNewVersion;
//          end;
//          if frmProcession.Visible then
//          begin
//            frmProcession.SetNewVersion;
//          end;
//          if frmShowHint.Visible then
//          begin
//            frmShowHint.SetNewVersion;
//          end;
//          if FrmPassEtc.Visible then
//          begin
//            FrmPassEtc.SetNewVersion;
//          end;
//          if frmPassEtcEdit.Visible then
//          begin
//            frmPassEtcEdit.SetNewVersion;
//          end;
//          if FrmExchange.Visible then
//          begin
//            FrmExchange.SetNewVersion;
//          end;
//          if frmItemHelp.Visible then
//          begin
//            frmItemHelp.SetNewVersion;
//          end;
//
//          SetNewVersion();
        end;
//      word('O'), word('o'):
//        begin
//          if frmCharAttrib.Visible then
//          begin
//            frmCharAttrib.SetTestPos(not frmCharAttrib.GetTestPos);
//            frmCharAttrib.SetNewVersion;
//          end;
//          if FrmWearItem.Visible then
//          begin
//            FrmWearItem.SetTestPos(not FrmWearItem.GetTestPos);
//            FrmWearItem.SetNewVersion;
//          end;
//          if FrmNewMagic.Visible then
//          begin
//            FrmNewMagic.SetTestPos(not FrmNewMagic.GetTestPos);
//            FrmNewMagic.SetNewVersion;
//          end;
//          if frmWearItemUser.Visible then
//          begin
//            frmWearItemUser.SetTestPos(not frmWearItemUser.GetTestPos);
//            frmWearItemUser.SetNewVersion;
//          end;
//          if FrmQuantity.Visible then
//          begin
//            FrmQuantity.SetTestPos(not FrmQuantity.GetTestPos);
//            FrmQuantity.SetNewVersion;
//          end;
//          if frmNPCTrade.Visible then
//          begin
//            frmNPCTrade.SetTestPos(not frmNPCTrade.GetTestPos);
//            frmNPCTrade.SetNewVersion;
//          end;
//          if FrmcMessageBox.Visible then
//          begin
//            FrmcMessageBox.SetTestPos(not FrmcMessageBox.GetTestPos);
//            FrmcMessageBox.SetNewVersion;
//          end;
//          if FrmSound.Visible then
//          begin
//            FrmSound.SetTestPos(not FrmSound.GetTestPos);
//            FrmSound.SetNewVersion;
//          end;
//          if FrmEmail.Visible then
//          begin
//            FrmEmail.SetTestPos(not FrmEmail.GetTestPos);
//            FrmEmail.SetNewVersion;
//          end;
//          if frmQuest.Visible then
//          begin
//            frmQuest.SetTestPos(not frmQuest.GetTestPos);
//            frmQuest.SetNewVersion;
//          end;
//          if frmGuild.Visible then
//          begin
//            frmGuild.SetTestPos(not frmGuild.GetTestPos);
//            frmGuild.SetNewVersion;
//          end;
//          if FrmGameToolsNew.Visible then
//          begin
//            FrmGameToolsNew.SetTestPos(not FrmGameToolsNew.GetTestPos);
//            FrmGameToolsNew.SetNewVersion;
//          end;
//          if frmEmporia.Visible then
//          begin
//            frmEmporia.SetTestPos(not frmEmporia.GetTestPos);
//            frmEmporia.SetNewVersion;
//          end;
//          if FrmHailFellow.Visible then
//          begin
//            FrmHailFellow.SetTestPos(not FrmHailFellow.GetTestPos);
//            FrmHailFellow.SetNewVersion;
//          end;
//          if frmProcession.Visible then
//          begin
//            frmProcession.SetTestPos(not frmProcession.GetTestPos);
//            frmProcession.SetNewVersion;
//          end;
//          if frmBillboardcharts.Visible then
//          begin
//            frmBillboardcharts.SetTestPos(not frmBillboardcharts.GetTestPos);
//            frmBillboardcharts.SetNewVersion;
//          end;
//          if FrmPassEtc.Visible then
//          begin
//            FrmPassEtc.SetTestPos(not FrmPassEtc.GetTestPos);
//            FrmPassEtc.SetNewVersion;
//          end;
//          if frmPassEtcEdit.Visible then
//          begin
//            frmPassEtcEdit.SetTestPos(not frmPassEtcEdit.GetTestPos);
//            frmPassEtcEdit.SetNewVersion;
//          end;
//        //  FTestPos := not FTestPos;
//          SetNewVersion();
        //end;
    end;
    exit;
  end;
  if ssCtrl in Shift then
  begin
    if key = 38 then //上
    begin
      if SendChatList.Count > 0 then
      begin
        if (SendChatListItemIndex >= 0) and (SendChatListItemIndex < SendChatList.Count) then
        begin
          edchat.Text := SendChatList.Strings[SendChatListItemIndex];
          edchat.SelStart := length(edchat.Text);
        end;
        SendChatListItemIndex := SendChatListItemIndex - 1;
        if (SendChatListItemIndex < 0) or (SendChatListItemIndex >= SendChatList.Count) then
          SendChatListItemIndex := 0;

      end;

    end;
    if key = 40 then //下
    begin
      if SendChatList.Count > 0 then
      begin
        if (SendChatListItemIndex >= 0) and (SendChatListItemIndex < SendChatList.Count) then
        begin
          edchat.Text := SendChatList.Strings[SendChatListItemIndex];
          edchat.SelStart := length(edchat.Text);
        end;
        SendChatListItemIndex := SendChatListItemIndex + 1;
        if (SendChatListItemIndex < 0) or (SendChatListItemIndex >= SendChatList.Count) then
          SendChatListItemIndex := SendChatList.Count - 1;

      end;

    end;
    exit;
  end;
  if key = 9 then //tab键切换出来提示
  begin
       // if LbChatClickFlag then boShowChat := not boShowChat;
    boShowquest := not boShowquest;
    SAY_EdChatFrmBottomSetFocus;
    FrmBottom.EdChat.SelectAll;
    exit;
  end;
  if key = 38 then //上
  begin
    //有纸条对象列表处理
    if SendMsayList.Count > 0 then
    begin
      //判断选中对象
      if (SendMsayListItemIndex >= 0) and (SendMsayListItemIndex < SendMsayList.Count) then
      begin
        edchat.Text := '@纸条 ' + SendMsayList.Strings[SendMsayListItemIndex] + ' ';
        edchat.SelStart := length(edchat.Text);
      end;
      //选中对象往前
      SendMsayListItemIndex := SendMsayListItemIndex - 1;
      //选中对象超出后循环到最后1个
      if (SendMsayListItemIndex < 0) or (SendMsayListItemIndex >= SendMsayList.Count) then
        SendMsayListItemIndex := SendMsayList.Count - 1;
    end
    else
    begin
      edchat.Text := '@纸条 ';
      edchat.SelStart := length(edchat.Text);
    end;
    exit;
  end;
  if key = 40 then //下
  begin
    //有纸条对象列表处理
    if SendMsayList.Count > 0 then
    begin
      if (SendMsayListItemIndex >= 0) and (SendMsayListItemIndex < SendMsayList.Count) then
      begin
        edchat.Text := '@纸条 ' + SendMsayList.Strings[SendMsayListItemIndex] + ' ';
        edchat.SelStart := length(edchat.Text);
      end;
      //选中对象往后
      SendMsayListItemIndex := SendMsayListItemIndex + 1;
      //选中对象超出后循环到第一1个
      if (SendMsayListItemIndex < 0) or (SendMsayListItemIndex >= SendMsayList.Count) then
        SendMsayListItemIndex := 0;

    end
    else
    begin
      edchat.Text := '@纸条 ';
      edchat.SelStart := length(edchat.Text);
    end;
    exit;
  end;

end;

procedure TFrmBottom.ButtonWearClick(Sender: TObject);
begin
    { savekeyBool := FALSE;          // FAttrib狼 savekey 阜澜
     FrmAttrib.Visible := TRUE;
     FrmAttrib.LbWindowName.Caption := ('物品');
     FrmAttrib.LbMoney.Caption := ('物品');
     FrmAttrib.PaneClose('PanelItem');
     FrmAttrib.PanelItem.Visible := TRUE;
     FrmAttrib.magicState(false);
         }
  FrmWearItem.Visible := not FrmWearItem.Visible;
  if FrmWearItem.Visible then
  begin
    FrmWearItem.SetFeature;
    FrmWearItem.DrawWearItem;
    FrmM.SetA2Form(FrmWearItem, FrmWearItem.A2form);
        // FrmM.move_win_form_Align(FrmWearItem, mwfRight);
  end;
end;

procedure TFrmBottom.BtnMagicClick(Sender: TObject);
begin
    {   savekeyBool := FALSE;          // FAttrib狼 savekey 阜澜
       FrmAttrib.Visible := TRUE;
       FrmAttrib.LbWindowName.Caption := ('武功');
       FrmAttrib.LbMoney.Caption := ('武功');

       FrmAttrib.PaneClose;
       FrmAttrib.PanelMagic.Visible := TRUE;
       }
   // FrmAttrib.Visible := TRUE;
  //  FrmAttrib.btnMagicTabClick(nil);
  FrmNewMagic.Visible := not FrmNewMagic.Visible;
  if FrmNewMagic.Visible then
  begin

    FrmM.SetA2Form(FrmNewMagic, FrmNewMagic.A2form);
        //   FrmM.move_win_form_Align(FrmNewMagic, mwfRight);
  end;
end;

procedure TFrmBottom.BtnDefMagicClick(Sender: TObject);
begin
    { savekeyBool := FALSE;          // FAttrib狼 savekey 阜澜
     FrmAttrib.Visible := TRUE;
     FrmAttrib.LbWindowName.Caption := ('基本武功');
     FrmAttrib.LbMoney.Caption := ('基本武功');
     FrmAttrib.PaneClose;
     FrmAttrib.PanelBasic.Visible := TRUE;
   }
end;

procedure TFrmBottom.BtnAttribClick(Sender: TObject);
begin
  savekeyBool := FALSE; // FAttrib狼 savekey 阜澜
  FrmAttrib.Visible := TRUE;
  FrmAttrib.LbWindowName.Caption := ('属性');
  FrmAttrib.LbMoney.Caption := ('属性');
  FrmAttrib.PaneClose('PanelAttrib');
  FrmAttrib.PanelAttrib.Visible := TRUE;
  FrmAttrib.magicState(false);
end;

procedure TFrmBottom.BtnSkillClick(Sender: TObject);
begin
  savekeyBool := FALSE; // FAttrib狼 savekey 阜澜
  FrmAttrib.Visible := TRUE;
  FrmAttrib.LbWindowName.Caption := ('技术');
  FrmAttrib.LbMoney.Caption := ('技术');
  FrmAttrib.PaneClose('PanelSkill');
  FrmAttrib.PanelSkill.Visible := TRUE;
  FrmAttrib.magicState(false);
end;

procedure TFrmBottom.bitEmporiaClick(Sender: TObject);
begin
           {       if frmHelp.Visible then

                    frmHelp.Visible := false
                else
                    frmHelp.Visible := true;
                    Exit;
  // MessageBox(0,'不开放商城系统','提示',0);
                     if map.GetMapWidth < 50 then exit;
                    FrmMiniMap.Visible := not FrmMiniMap.Visible;
                    if FrmMiniMap.Visible then
                    begin
                        FrmMiniMap.GETnpcList;
                        FrmM.SetA2Form(FrmMiniMap, FrmMiniMap.A2form);
                    end;
   exit;     }
  if frmEmporia.Visible = false then
    frmEmporia.sendshowForm
  else
    frmEmporia.A2Button_closeClick(nil);
    //  if FrmMiniMap.Visible then FrmMiniMap.Visible := FALSE;
     // FrmAttrib.Visible := not FrmAttrib.Visible;
        //   if FrmNpcView.Visible then FrmNpcView.SetPostion;
        //   if FrmItemStoreView.Visible then FrmItemStoreView.SetPostion;
        //   if FrmQView.Visible then FrmQView.SetPostion;

        //   if FrmcMessageBox.Visible then FrmcMessageBox.SetPostion;
        //   if FrmMunpaCreate.Visible then FrmMunpaCreate.SetPostion;
        //   if FrmMunpaimpo.Visible then FrmMunpaimpo.SetPostion;
end;

procedure TFrmBottom.BtnSelMagicClick(Sender: TObject);
begin
//  if frmHelp.Visible then
//
//    frmHelp.Visible := false
//  else
//    frmHelp.Visible := true;
//  Exit;
  FrmSound.Visible := not FrmSound.Visible; // option芒
    //   FrmSelMagic.Visible := not FrmSelMagic.Visible;
  if FrmSound.Visible then
  begin

    FrmM.SetA2Form(FrmSound, FrmSound.A2form);
        //   FrmM.move_win_form_Align(FrmNewMagic, mwfRight);
  end;
end;

procedure TFrmBottom.LbChatEnter(Sender: TObject);
begin
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmBottom.SetChatChanel;
var
  str: string;
  substr: string;
begin
  str := FrmBottom.EdChat.Text;
  if str = '' then
  begin
    FrmBottom.Editchannel.Caption := '当前';
  end
  else
  begin
    if (str[1] = '!') then
    begin
      FrmBottom.Editchannel.Caption := '世界';
      if (str[2] = '!') and (str[3] = '!') then
      begin
        FrmBottom.Editchannel.Caption := '同盟';
      end
      else if (str[2] = '!') then
      begin
        FrmBottom.Editchannel.Caption := '门派';
      end;
    end
    else if (str[1] = '~') then
    begin
      FrmBottom.Editchannel.Caption := '队伍'
    end
    else if (str[1] = '@') then
    begin
      substr := Copy(str, 2, 2 + 4);
      if substr = '纸条' then
        FrmBottom.Editchannel.Caption := '纸条';
    end;
  end;
end;

procedure TFrmBottom.Timer1Timer(Sender: TObject);
var
  i: integer;
begin
  ExecUpload;
  //ExecCheckBlackList;
  if not Visible then
    exit;
  SetChatChanel;

//  if frmProcession.A2ListBox1.Count <= 0 then
//    FrmChat.Button_procession_choose.Enabled := false
//  else
//    FrmChat.Button_procession_choose.Enabled := true;

//  if frmGuild.A2ListBox1.Count <= 0 then
//    FrmChat.Button_guild_choose.Enabled := false
//  else
//    FrmChat.Button_guild_choose.Enabled := true;

  if boACTIVATEAPP = false then
    exit;
  for i := 0 to FrmM.ComponentCount - 1 do
  begin
    if (FrmM.Components[i] is TfrmConfirmDialog) or (FrmM.Components[i] is TFrmQuantity) then
    begin
      if TForm(FrmM.Components[i]).Visible then
        exit;
    end;
  end;

  if frmBillboardcharts.Visible or
 // frmbooth.Visible or
  frmNPCTrade.Visible or
 // frmSkill.Visible or
  FrmQuantity.Visible or FrmDepository.TEMPFrmQuantity.Visible or FrmSearch.Visible or FrmPassEtc.Visible or
  //FrmNEWEmail.Visible or
  FrmMuMagicOffer.Visible or FrmHailFellow.Visible or FrmGameToolsNew.Visible or frmEmporia.Visible or
 // frmAuction.Visible or
  FrmSound.Visible or
    FrmHorn.Visible then
  begin

  end
  else if FrmBottom.Visible and not edchat.Focused then
  begin

    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
  end;
end;

{procedure TFrmBottom.ShortcutKeyUP(id: integer);
var
    i: integer;
begin
    for i := 0 to high(shortcutkey) do
        if shortcutkey[i] = id then
        begin
            ShortcutKeySETimg(i, id);
        end;
    //FrmAttrib.SetItemLabel(shortcutLabels[i], '', 0, 0, 0, 0);

end;
 }

{procedure TFrmBottom.ShortcutKeyDel(id: integer);
begin
    case id of
        0..7: ;
    else exit;
    end;
    FrmAttrib.SetItemLabel(shortcutLabels[id], '', 0, 0, 0, 0);
    // shortcutLabels[id].A2Image := nil;
    /// shortcutLabels[id].A2ImageRDown := nil;
  //   shortcutLabels[id].A2ImageLUP := nil;
end;

{procedure TFrmBottom.ShortcutKeyClear();
var
    i: integer;
begin
    fillchar(shortcutkey, sizeof(shortcutkey), -1);
    for i := 0 to high(shortcutLabels) do
        FrmAttrib.SetItemLabel(shortcutLabels[i], '', 0, 0, 0, 0);

end;
 }

procedure TFrmBottom.lblShortcut0Click(Sender: TObject);
var
  tt: TA2ILabel;
  p: pTKeyClassData;
begin
  if GameMenu.Visable then
  begin
    if GameMenu.CurrItem < 0 then
       // GameMenu.Close
    else
    begin
      GameMenu.MouseDown;

    end;
    Exit;
  end;
    //使用
  p := cKeyClass.get(TA2ILabel(Sender).Tag);
  if p = nil then
    exit;
  if p.rboUser = false then
    exit;
  tt := nil;
  case p.rkeyType of
    kcdk_HaveItem:
      tt := FrmWearItem.ILabels[p.rkey];
    kcdk_HaveMagic:
      tt := FrmNewMagic.MLabels[p.rkey];
    kcdk_HaveRiseMagic:
      tt := FrmNewMagic.RiseLabels[p.rkey];
    kcdk_HaveMysteryMagic:
      tt := FrmNewMagic.MysteryLabels[p.rkey];
    kcdk_BasicMagic:
      tt := FrmNewMagic.BLabels[p.rkey];
  else
    exit;
  end;
  if tt = nil then
    exit;
  tt.OnDblClick(tt);
end;

{
procedure TFrmBottom.ShortcutKeySETimg(savekey, KeyIndex: integer);
var
    i: integer;
    idx, ID: integer;
    tt: TA2ILabel;
    aitem: TItemData;
    amagic: TMagicData;
begin
    // if KeyIndex = 255 then KeyIndex := -1;
    case savekey of
        0..7: id := savekey;
    else exit;
    end;
    //删除 原来
    //if KeyIndex = -1 then
    ShortcutKeyDel(savekey);
    //FrmAttrib.SetItemLabel(shortcutLabels[id], '', 0, 0, 0, 0);
    tt := nil;
    //增加
    shortcutkey[id] := KeyIndex;
    if (KeyIndex >= 0) and (KeyIndex <= 29) then
    begin
        tt := FrmAttrib.getkeyadd(shortcutkey[id]);
        amagic := (HaveMagicClass.DefaultMagic.get(tt.Tag));
        tt.Hint := TMagicDataToStr(amagic);
    end
    else if (KeyIndex >= 30) and (KeyIndex <= 59) then
    begin
        tt := FrmAttrib.getkeyadd(shortcutkey[id]);
        amagic := (HaveMagicClass.HaveMagic.get(tt.Tag));
        tt.Hint := TMagicDataToStr(amagic);
    end
    else if (KeyIndex >= 60) and (KeyIndex <= 89) then
    begin
        tt := FrmAttrib.getkeyadd(shortcutkey[id]);
        aitem := HaveItemclass.get(tt.Tag);
        tt.Hint := TItemDataToStr(aitem);
    end;

    if tt <> nil then
    begin
        // tt.ShowHint := false;
        if shortcutkey[id] <> 255 then
        begin
            shortcutLabels[id].GreenCol := tt.GreenCol;
            shortcutLabels[id].GreenAdd := tt.GreenAdd;
            shortcutLabels[id].A2Image := tt.A2Image;
            shortcutLabels[id].Hint := tt.Hint;
            shortcutLabels[id].A2ImageRDown := nil;
            shortcutLabels[id].A2ImageLUP := nil;
        end;
    end;
end;
}

procedure TFrmBottom.saveAllKey();
var
  tts: tskey;
  cnt: integer;
  i: Integer;
  p: ptKeyClassData;
begin
{

00，DefaultMagic
30，HaveMagic
60，HaveItemclass

}
    //发送 热键 到服务器
  tts.rmsg := CM_KEYf5f12SAVE;
  for i := 0 to high(tts.rKEY) do
  begin
    tts.rKEY[i] := 255;
    p := cKeyClass.get(i);
    if p = nil then
      Continue;
    if p.rboUser = false then
      Continue;
    case p.rkeyType of
      kcdk_HaveRiseMagic:
        tts.rKEY[i] := p.rkey + 120;
      kcdk_HaveMysteryMagic:
        tts.rKEY[i] := p.rkey + 180;
      kcdk_HaveItem:
        tts.rKEY[i] := p.rkey + 90;
      kcdk_HaveMagic:
        tts.rKEY[i] := p.rkey + 30;
      kcdk_BasicMagic:
        tts.rKEY[i] := p.rkey;
    end;
  end;
  for i := 0 to high(tts.rKEY2) do
  begin
    tts.rKEY2[i] := 255;
    p := cF5_F12Class.get(i);
    if p = nil then
      Continue;
    if p.rboUser = false then
      Continue;
    case p.rkeyType of
      kcdk_HaveRiseMagic:
        tts.rKEY2[i] := p.rkey + 120;
      kcdk_HaveMysteryMagic:
        tts.rKEY2[i] := p.rkey + 180;
      kcdk_HaveItem:
        tts.rKEY2[i] := p.rkey + 90;
      kcdk_HaveMagic:
        tts.rKEY2[i] := p.rkey + 30;
      kcdk_BasicMagic:
        tts.rKEY2[i] := p.rkey;
    end;
  end;

  cnt := sizeof(tts);
  Frmfbl.SocketAddData(cnt, @tts);
  Frmfbl.PacketSender.Update;
end;
{procedure TFrmBottom.ShortcutKeySET(savekey, KeyIndex: integer);
var
    i: integer;
    idx, ID: integer;
    tt: TA2ILabel;
    tts: tskey;
    cnt: integer;
begin
    //   if KeyIndex = 255 then KeyIndex := -1;
    case savekey of
        0..7: id := savekey;
    else exit;
    end;
//    ShortcutKeySETimg(savekey, KeyIndex);
end;
 }

procedure TFrmBottom.lblShortcut0DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  tp: TDragItem;
  titem: pTSHaveItem;
  shortcutid, tempid: integer;
  p: pTKeyClassData;
  t1, t2: TKeyClassData;
begin
  if Source = nil then
    exit;

  tp := pointer(Source);
  shortcutid := TA2ILabel(Sender).Tag;
  case tp.SourceID of
    WINDOW_BASICFIGHT:
      cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_BasicMagic, tp.Selected);
    WINDOW_MAGICS:
      cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveMagic, tp.Selected);
    WINDOW_MAGICS_Rise:
      cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveRiseMagic, tp.Selected);
    WINDOW_MAGICS_Mystery:
      cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveMysteryMagic, tp.Selected);
    WINDOW_ITEMS:
      cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveItem, tp.Selected);
    WINDOW_ShortcutItem:
      begin //交换
        p := cKeyClass.get(shortcutid);
        if p = nil then
          exit;
        t1 := p^;
        p := cKeyClass.get(tp.Selected);
        if p = nil then
          exit;
        t2 := p^;

        cKeyClass.UPdate(shortcutid, kcdt_key, t2.rkeyType, t2.rkey);
        cKeyClass.UPdate(tp.Selected, kcdt_key, t1.rkeyType, t1.rkey)
      end;
  end;

end;

procedure TFrmBottom.lblShortcut0DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := FALSE;
  if Source <> nil then
  begin
    with Source as TDragItem do
    begin
      case SourceID of
        WINDOW_BASICFIGHT:
          Accept := TRUE;
        WINDOW_MAGICS:
          Accept := TRUE;
        WINDOW_MAGICS_Rise:
          Accept := TRUE;
        WINDOW_MAGICS_Mystery:
          Accept := TRUE;
        WINDOW_ITEMS:
          Accept := TRUE;
        WINDOW_ShortcutItem:
          Accept := TRUE;
      end;
    end;
  end;
end;

procedure TFrmBottom.lblShortcut0StartDrag(Sender: TObject; var DragObject: TDragObject);
var
  id: integer;
begin
    //  id := TA2ILabel(Sender).Tag;
     // FrmAttrib.SetItemLabel(shortcutLabels[id], '', 0, 0, 0, 0);
  if Sender is TA2ILabel then
  begin
    DragItem.Selected := TA2ILabel(Sender).Tag;
    DragItem.SourceId := WINDOW_ShortcutItem;
    DragItem.Dragedid := 0;
    DragItem.sx := 0;
    DragItem.sy := 0;
    DragObject := DragItem;
  end;
end;

procedure TFrmBottom.BtnExitClick(Sender: TObject);
var
  cnt: integer;
  str: string;
  cSay: TCSay;
begin

  if not ReConnetFlag then
  begin
    Frmfbl.Timer_login.Enabled := FALSE;
    ReConnetFlag := true;
    showmessage('服务器连接失败!!!');
    ExitProcess(0);
  end;

  if frmfbl.Visible then
    Exit;
  if FStartExiting or FrmcMessageBox.Visible then
    Exit;

  FStartExiting := True;
  exitTimer.Enabled := False;
  FStartExitTime := GetTickCount;
  cSay.rmsg := CM_SAY;
  str := '@GameExit';
  SetWordString(cSay.rWordString, str);
  cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
  Frmfbl.SocketAddData(cnt, @csay);
  SaveAllKey;
  exitTimer.Enabled := True;




//  Shell_NotifyIcon(NIM_DELETE, @(FrmM.TrayIconData));
//  if not FrmBottom.Visible then
//  begin
//    Shell_NotifyIcon(NIM_DELETE, @(FrmM.TrayIconData));
//    ExitProcess(0);
//  end;
//  case MessageBox(Handle, PChar('是否正常退出' + #13#10 + '建议选择-是-' + #13#10 + '如果无法选-是-无法正常退出游戏，那么请选择-否-强制退出'), PChar('选择退出方式'),
//    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1) of
//    IDYES:
//      begin
//        cSay.rmsg := CM_SAY;
//        str := '@GameExit';
//        SetWordString(cSay.rWordString, str);
//        cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
//        Frmfbl.SocketAddData(cnt, @csay);
//        SaveAllKey;
//      end; // Add your code here
//    IDNO:
//      begin
//        Shell_NotifyIcon(NIM_DELETE, @(FrmM.TrayIconData));
//        ExitProcess(0);
//      end;
//  end;

end;

procedure TFrmBottom.sbthailfellowClick(Sender: TObject);
begin
    { savekeyBool := FALSE;          // FAttrib狼 savekey 阜澜
     FrmAttrib.Visible := TRUE;
     FrmAttrib.LbWindowName.Caption := ('好友');
     FrmAttrib.LbMoney.Caption := ('好友列表');
     FrmAttrib.PaneClose('PanelHailFellow');
     FrmAttrib.PanelHailFellow.Visible := true;
     FrmAttrib.magicState(false);
     }

  FrmHailFellow.Visible := not FrmHailFellow.Visible;
  if FrmHailFellow.Visible then
  begin
    FrmM.SetA2Form(FrmHailFellow, FrmHailFellow.A2form);
        //  FrmM.move_win_form_Align(FrmHailFellow, mwfCenter);
  end;
end;

procedure TFrmBottom.btnGuildClick(Sender: TObject);
begin

  //如果没有帮派，不发送消息 退出
  if frmGuild.guildname = '' then
  begin
    FrmBottom.AddChat('你还没有加入门派', WinRGB(255, 255, 0), 0);
    exit;
  end;
  frmGuild.Visible := not frmGuild.Visible;
  if frmGuild.Visible then
  begin
    FrmM.SetA2Form(frmGuild, frmGuild.A2form);
    FrmM.move_win_form_Align(frmGuild, mwfCenter);
  end;
end;

procedure TFrmBottom.btnQuestClick(Sender: TObject);
begin
  frmNewQuest.Visible := not frmNewQuest.Visible;
  if frmNewQuest.Visible then
  begin

    FrmM.SetA2Form(frmNewQuest, frmNewQuest.A2form);
    FrmM.move_win_form_Align(frmNewQuest, mwfCenter);
  end;
end;

procedure TFrmBottom.btnProcessionClick(Sender: TObject);
begin

  if frmComplexProperties.Visible = false then
    frmComplexProperties.sendshowForm
  else
    frmComplexProperties.A2ButtonCloseClick(nil);

//  frmComplexProperties.Visible := not frmComplexProperties.Visible; //1
//  if frmComplexProperties.Visible then
//  begin
//    FrmM.SetA2Form(frmComplexProperties, frmComplexProperties.A2form);
//  end;

//  frmProcession.Visible := not frmProcession.Visible;
//  if frmProcession.Visible then
//  begin
//    FrmM.SetA2Form(frmProcession, frmProcession.A2form);
//    FrmM.move_win_form_Align(frmProcession, mwfCenter);
//  end;
end;

procedure TFrmBottom.btnBillboardchartsClick(Sender: TObject);
begin
  frmBillboardcharts.Visible := not frmBillboardcharts.Visible;
  if frmBillboardcharts.Visible then
  begin
    FrmM.SetA2Form(frmBillboardcharts, frmBillboardcharts.A2form);
    FrmM.move_win_form_Align(frmBillboardcharts, mwfCenter);
  end;
end;

procedure TFrmBottom.btnCharAttribClick(Sender: TObject);
begin
  frmCharAttrib.Visible := not frmCharAttrib.Visible;
  if frmCharAttrib.Visible then
  begin

    FrmM.SetA2Form(frmCharAttrib, frmCharAttrib.A2form);
    FrmM.move_win_form_Align(frmCharAttrib, mwfLeft);
  end;
end;

procedure TFrmBottom.FormShow(Sender: TObject);
begin
    //FrmEnergy.Visible := true;
  energyGraphicsclass.Visible := true;

end;

procedure TFrmBottom.PgHeadMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin

  GameHint.setText(integer(Sender), '头' + Get10000To100(PgHead.Progress) + '/' + Get10000To100(PgHead.MaxValue));
end;

procedure TFrmBottom.PGArmMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '手肩' + Get10000To100(PGArm.Progress) + '/' + Get10000To100(PGArm.MaxValue));
end;

procedure TFrmBottom.PGLegMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '腿' + Get10000To100(PGLeg.Progress) + '/' + Get10000To100(PGLeg.MaxValue));

end;

procedure TFrmBottom.PGInPowerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '内功' + Get10000To100(PGInPower.Progress) + '/' + Get10000To100(PGInPower.MaxValue));
end;

procedure TFrmBottom.PgOutPowerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '外功' + Get10000To100(PgOutPower.Progress) + '/' + Get10000To100(PgOutPower.MaxValue));
end;

procedure TFrmBottom.PgMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '武功' + Get10000To100(PgMagic.Progress) + '/' + Get10000To100(PgMagic.MaxValue));
end;

procedure TFrmBottom.PgLifeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '活力' + Get10000To100(PgLife.Progress) + '/' + Get10000To100(PgLife.MaxValue));
end;

procedure TFrmBottom.Lbchat1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  s, sname, s1, s2, s3: string;
  tempsend: TWordComData;
  aitem: PTItemdata;
  str, rdstr: string;
  Len, l, r, rx, ry: Integer;
begin
  sname := '';
  s := TA2Label(Sender).Caption;
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
       // FrmBottom.Editchannel.Caption := '纸条';
        //FrmBottom.EdChat.Text := '@纸条 ' + sname + ' '+s;
    FrmBottom.EdChat.Text := '@纸条 ' + sname + ' ';
    FrmBottom.edchat.SelStart := length(FrmBottom.edchat.Text);
  end;

  if GameMenu.Visable then //2015.11.18 在水一方
  begin
    if GameMenu.CurrItem < 0 then
       // GameMenu.Close
    else
    begin
      GameMenu.MouseDown;
    end;
    Exit;
  end;
  Clipboard.AsText := Lbchat1.Caption;
//  if LbChatClickFlag then
//    boShowChat := not boShowChat;
  aitem := PTItemdata(TA2ChatLabel(Sender).ChatItemData);
  if (aitem <> nil) and (aitem.rName = '') then
  begin
    str := GetValidStr3(TA2ChatLabel(Sender).CHatItemName, rdstr, ':');
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
        AddChat('不在同一地图！', ColorSysToDxColor(clFuchsia), 0);
      Exit;
    end;
    //不是坐标当物品处理
    tempsend.Size := 0;
    WordComData_ADDbyte(tempsend, CM_GETSAYITEMDATA);
    WordComData_ADDdword(tempsend, aitem.rId);
    Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
  end;
  if (aitem <> nil) then
    TA2ChatLabel(Sender).ChatItemSelected := True;
end;

procedure TFrmBottom.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmBottom.btnCharAttribMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>属性(ALT + 1)');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.BtnMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>武功(ALT + 3)');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnQuestMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>任务(ALT + 5)');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnProcessionMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>合成(ALT + W)');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnGuildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>门派(ALT + 4)');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.sbthailfellowMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>好友(ALT + Q)');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnBillboardchartsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //GameHint.setText(integer(Sender), '【系统暂未开放】');
  //Exit;

  GameHint.setText(integer(Sender), '<$000080FF>排行榜(ALT + E)');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.BtnExitMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>退出(ALT + X)');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.Button_chooseChnClick(Sender: TObject);
begin
//  FrmChat.ClientWidth := 52;
//  FrmChat.ClientHeight := 114;
//  FrmChat.Left := 148;
//  FrmChat.Top := 453;
//  FrmChat.Visible := not FrmChat.Visible;
//  FrmM.SetA2Form(FrmChat, FrmChat.A2form);
end;

procedure TFrmBottom.ButtonWearMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>背包(ALT + 2)');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.bitEmporiaMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>商城(ALT + S)');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.BtnSelMagicMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>设置(ALT + 7)');
//    GameHint.pos(x + BtnSelMagic.Left, y + BtnSelMagic.Top + (600 - self.Height));
end;

procedure TFrmBottom.lblShortcut0MouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TFrmBottom.lblShortcut0MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  p: pTKeyClassData;
  aitem: titemdata;
  aMagic: TMagicData;
  temp: Ta2ILabel;
  HintText: string;
begin
  if GameMenu.Visable then
  begin
    Exit;
  end;
    //使用
  Temp := Ta2ILabel(Sender);
  if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
  begin
    if temp.A2Image <> nil then
      Temp.BeginDrag(TRUE);
    GameHint.Close;
    exit;
  end;

  HintText := '<$000080FF>CTRL + ' + IntToStr(TA2ILabel(Sender).Tag + 1);
  p := cKeyClass.get(TA2ILabel(Sender).Tag);
  if p = nil then
  begin
    GameHint.setText(integer(Sender), HintText);
   // GameHint.Close;
    exit;
  end;
  if p.rboUser = false then
  begin
    GameHint.setText(integer(Sender), HintText);
    //GameHint.Close;
    exit;
  end;
  case p.rkeyType of
    kcdk_HaveItem:
      begin
        aitem := HaveItemclass.get(p.rkey);
        if aitem.rName <> '' then
          GameHint.setText(integer(Sender), TItemDataToStr(aitem) + HintText)
        else
          GameHint.Close;
      end;
    kcdk_HaveMagic:
      begin
        aMagic := (HaveMagicClass.HaveMagic.get(p.rkey));
        if aMagic.rname <> '' then
          GameHint.setText(integer(Sender), TMagicDataToStr(aMagic) + HintText)
        else
          GameHint.Close;
      end;
    kcdk_HaveRiseMagic:
      begin
        aMagic := (HaveMagicClass.HaveRiseMagic.get(p.rkey));
        if aMagic.rname <> '' then
          GameHint.setText(integer(Sender), TMagicDataToStr(aMagic) + HintText)
        else
          GameHint.Close;
      end;
    kcdk_HaveMysteryMagic:
      begin
        aMagic := (HaveMagicClass.HaveMysteryMagic.get(p.rkey));
        if aMagic.rname <> '' then
          GameHint.setText(integer(Sender), TMagicDataToStr(aMagic) + HintText)
        else
          GameHint.Close;
      end;
    kcdk_BasicMagic:
      begin
        aMagic := (HaveMagicClass.DefaultMagic.get(p.rkey));
        if aMagic.rname <> '' then
          GameHint.setText(integer(Sender), TMagicDataToStr(aMagic) + HintText)
        else
          GameHint.Close;
      end;
  end;

end;

procedure TFrmBottom.Lbchat4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  id, aid: integer;
  aitem: PTItemdata;
begin
  if Sender is TA2ChatLabel then
  begin
    aitem := PTItemdata(TA2ChatLabel(Sender).ChatItemData);
    if (aitem <> nil) and (aitem.rName <> '') then
    begin
      if (TA2ChatLabel(Sender).ChatItemSelected) then begin
        tempA2ILabel.Width := 32; //2015.06.27在水一方 >>>>>>
        tempA2ILabel.Height := 32;
        if tempA2ILabel.A2Image = nil then
          tempA2ILabel.A2Image := TA2Image.Create(tempA2ILabel.Width, tempA2ILabel.Height, 0, 0)
        else
          tempA2ILabel.A2Image.Clear(0);
        FItemBackGroundFileName := FItemBackGroundFileNameList.Values[FKindMark + inttostr(aitem.rGrade)];
        FrmAttrib.SetItemLabelBackGround(tempA2ILabel, aitem.rcolor, FItemBackGroundFileName);
        FrmAttrib.SetItemLabel(tempA2ILabel, '', aitem.rcolor, aitem.rShape, 0, 0);
        GameHint.setText(integer(tempA2ILabel), TItemDataToStr(aitem^)); //2015.06.27在水一方 <<<<<<
      end
      else
        GameHint.Close;
    end
    else
      GameHint.Close;
  end;
end;

procedure TFrmBottom.N1Click(Sender: TObject);
begin
  Clipboard.AsText := EdChat.Text;
end;

procedure TFrmBottom.N2Click(Sender: TObject);
begin
  edChat.Clear;
end;

procedure TFrmBottom.Lbchat2Click(Sender: TObject); //2015.11.18 在水一方
begin
  if GameMenu.Visable then
  begin
    if GameMenu.CurrItem < 0 then
       // GameMenu.Close
    else
    begin
      GameMenu.MouseDown;
    end;
    Exit;
  end;
  Clipboard.AsText := Lbchat2.Caption;
end;

procedure TFrmBottom.Lbchat3Click(Sender: TObject);
begin
  if GameMenu.Visable then
  begin
    if GameMenu.CurrItem < 0 then
       // GameMenu.Close
    else
    begin
      GameMenu.MouseDown;

    end;
    Exit;
  end;
  Clipboard.AsText := Lbchat3.Caption;
end;

procedure TFrmBottom.Lbchat4Click(Sender: TObject);
begin
  if GameMenu.Visable then
  begin
    if GameMenu.CurrItem < 0 then
       // GameMenu.Close
    else
    begin
      GameMenu.MouseDown;

    end;
    Exit;
  end;
  Clipboard.AsText := Lbchat4.Caption;
end;

function deal(x: string): string;
begin
  result := Copy(x, 1, Pos('(', x) - 1);

end;

procedure TFrmBottom.N4Click(Sender: TObject);
begin
  EdChat.Text := deal(N4.Caption) + ' ';
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N5Click(Sender: TObject);
begin
  EdChat.Text := deal(N5.Caption) + ' ';
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N10Click(Sender: TObject);
begin
  EdChat.Text := deal(N10.Caption) + ' ';
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N9Click(Sender: TObject);
begin
  EdChat.Text := deal(N9.Caption);
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N6Click(Sender: TObject);
begin
  EdChat.Text := deal(N6.Caption);
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N7Click(Sender: TObject);
begin
  EdChat.Text := deal(N7.Caption);
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N8Click(Sender: TObject);
begin
  EdChat.Text := deal(N8.Caption);
  FrmBottom.EdChat.SelStart := Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N13Click(Sender: TObject);
begin
  frmHistory.Visible := not frmHistory.Visible; //1
  if frmHistory.Visible then
  begin
    FrmM.SetA2Form(frmHistory, frmHistory.A2form);
  end;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmBottom.N12Click(Sender: TObject);
var

  Cl: TCharClass;
begin
  if map.GetMapWidth < 50 then
    exit;
  //死亡关闭小地图
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then
    exit;
  if Cl.Feature.rfeaturestate = wfs_die then
    exit;

  FrmMiniMap.Visible := not FrmMiniMap.Visible;
  if FrmMiniMap.Visible then
  begin
    FrmMiniMap.GETnpcList;
    FrmM.SetA2Form(FrmMiniMap, FrmMiniMap.A2form);
  end;
end;

procedure TFrmBottom.btnjsClick(Sender: TObject);
var
  key: Word;
begin
//  key := VK_RETURN;
//  if frmAuction.Visible then
//    frmAuction.Close;
//  FrmBottom.sendsay('@js', key);
end;

procedure TFrmBottom.btnyjClick(Sender: TObject);
var
  key: Word;
begin

  if frmItemUpgrade.Visible = false then
    frmItemUpgrade.sendshowForm
  else
    frmItemUpgrade.A2ButtonCloseClick(nil);

//  FrmBottom.AddChat('【系统暂未开放】', WinRGB(255, 255, 0), 0);
//  Exit;
//
//  key := VK_RETURN;
//  if FrmEmail.Visible then
//    frmemail.Close;
//  FrmBottom.sendsay('@yj', key);
end;

procedure TFrmBottom.btnckClick(Sender: TObject);
var
  key: Word;
begin
  key := VK_RETURN;
  if FrmDepository.Visible then
    FrmDepository.Close;
  FrmBottom.sendsay('@ck', key);
end;

procedure TFrmBottom.btnjnClick(Sender: TObject);
begin
//  if frmSkill.Visible then
//    frmSkill.Close
//  else
//  begin
//    frmSkill.Visible := true;
//    frmSkill.send_Get_Job_blueprint_Menu;
//    FrmM.SetA2Form(frmSkill, frmSkill.A2form);
//  end;
end;

//procedure TFrmBottom.SetNewVersionOld;
//begin
//
// // pgkBmp.getBmp('操作界面_底框下半部分.bmp', A2form.FImageSurface);
//
//  A2form.boImagesurface := true;
//
//    //EdChat.MaxLength := 52;
//
//    //重新设置PgHead位置
//  PgHead.Left := 580;
//  PgHead.Top := 16;
//  PgHead.Width := 42;
//  PgHead.Height := 7;
//  SetControlPos(PgHead);
//  PGArm.Left := 642;
//  PGArm.Top := 16;
//  PGArm.Width := 43;
//  PGArm.Height := 7;
//  SetControlPos(PGArm);
//  PGLeg.Left := 704;
//  PGLeg.Top := 16;
//  PGLeg.Width := 43;
//  PGLeg.Height := 7;
//  SetControlPos(PGLeg);
//  PGInPower.Left := 673;
//  PGInPower.Top := 33;
//  PGInPower.Width := 63;
//  PGInPower.Height := 4;
//  SetControlPos(PGInPower);
//  PgOutPower.Left := 676;
//  PgOutPower.Top := 46;
//  PgOutPower.Width := 63;
//  PgOutPower.Height := 4;
//  SetControlPos(PgOutPower);
//  PgMagic.Left := 678;
//  PgMagic.Top := 59;
//  PgMagic.Width := 63;
//  PgMagic.Height := 4;
//  SetControlPos(PgMagic);
//  PgLife.Left := 680;
//  PgLife.Top := 73;
//  PgLife.Width := 72;
//  PgLife.Height := 7;
//  SetControlPos(PgLife);
//    //经验条
//  PGSkillLevel1.Left := 109;
//  PGSkillLevel1.Top := 18;
//  SetControlPos(PGSkillLevel1);
//  PGSkillLevel2.Left := 109;
//  PGSkillLevel2.Top := 23;
//  SetControlPos(PGSkillLevel2);
//    //坐标
//  LbPos.Left := 72;
//  LbPos.Top := 88;
//  LbPos.Width := 45;
//  LbPos.Height := 15;
//  SetControlPos(LbPos);
//    //频道显示窗口
//  Editchannel.Left := 204;
//  Editchannel.Top := 92;
//  Editchannel.Width := 29;
//  Editchannel.Height := 18;
//  SetControlPos(Editchannel);
//    //显示武功文字
//  UseMagic1.Left := 55;
//  UseMagic1.Top := 32;
//  SetControlPos(UseMagic1);
//  UseMagic2.Left := 55;
//  UseMagic2.Top := 44;
//  SetControlPos(UseMagic2);
//  UseMagic3.Left := 55;
//  UseMagic3.Top := 56;
//  SetControlPos(UseMagic3);
//  UseMagic4.Left := 55;
//  UseMagic4.Top := 68;
//  SetControlPos(UseMagic4);
//    //闪动框
//  LbEvent.Left := 166;
//  LbEvent.Top := 16;
//  LbEvent.Width := 57;
//  LbEvent.Height := 10;
//  SetControlPos(LbEvent);
//    //聊天窗口
//  Lbchat1.Left := 148;
//  Lbchat1.Top := 32;
//  Lbchat1.Width := 491;
//  Lbchat1.Height := 13;
//  Lbchat1.Color := ColorSysToDxColor($00292110);
//  SetControlPos(Lbchat1);
//
//  Lbchat2.Color := ColorSysToDxColor($00292110);
//  Lbchat3.Color := ColorSysToDxColor($00292110);
//  Lbchat4.Color := ColorSysToDxColor($00292110);
//  Lbchat2.Left := 148;
//  Lbchat2.Top := 45;
//  Lbchat2.Width := 491;
//  Lbchat2.Height := 13;
//  SetControlPos(Lbchat2);
//  Lbchat3.Left := 148;
//  Lbchat3.Top := 58;
//  Lbchat3.Width := 491;
//  Lbchat3.Height := 13;
//  SetControlPos(Lbchat3);
//  Lbchat4.Left := 148;
//  Lbchat4.Top := 71;
//  Lbchat4.Width := 491;
//  Lbchat4.Height := 13;
//  SetControlPos(Lbchat4);
//    //文字输入
//  EdChat.Left := 238;
//  EdChat.Top := 93;
//  EdChat.Width := 263;
//  EdChat.Height := 18;
//  SetControlPos(EdChat);
//  temping := TA2Image.Create(32, 32, 0, 0);
//    //频道选择
//  pgkBmp.getBmp('操作界面_频道选择_弹起.bmp', temping);
//  Button_chooseChn.A2Up := temping;
//  pgkBmp.getBmp('操作界面_频道选择_按下.bmp', temping);
//  Button_chooseChn.A2Down := temping;
//  pgkBmp.getBmp('操作界面_频道选择_鼠标.bmp', temping);
//  Button_chooseChn.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_频道选择_禁止.bmp', temping);
//  Button_chooseChn.A2NotEnabled := temping;
//  Button_chooseChn.Left := 148;
//  Button_chooseChn.Top := 89;
//  Button_chooseChn.Width := 52;
//  Button_chooseChn.Height := 19;
//  SetControlPos(Button_chooseChn);
//
//    //人物属性
//  pgkBmp.getBmp('操作界面_角色属性_弹起.bmp', temping);
//  btnCharAttrib.A2Up := temping;
//  pgkBmp.getBmp('操作界面_角色属性_按下.bmp', temping);
//  btnCharAttrib.A2Down := temping;
//  pgkBmp.getBmp('操作界面_角色属性_鼠标.bmp', temping);
//  btnCharAttrib.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_角色属性_禁止.bmp', temping);
//  btnCharAttrib.A2NotEnabled := temping;
//  btnCharAttrib.Left := 502;
//  btnCharAttrib.Top := 88;
//  SetControlPos(btnCharAttrib);
//    //物品栏
//  pgkBmp.getBmp('操作界面_物品栏_弹起.bmp', temping);
//  ButtonWear.A2Up := temping;
//  pgkBmp.getBmp('操作界面_物品栏_按下.bmp', temping);
//  ButtonWear.A2Down := temping;
//  pgkBmp.getBmp('操作界面_物品栏_鼠标.bmp', temping);
//  ButtonWear.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_物品栏_禁止.bmp', temping);
//  ButtonWear.A2NotEnabled := temping;
//  ButtonWear.Left := 523;
//  ButtonWear.Top := 88;
//  SetControlPos(ButtonWear);
//
//    //人物武功
//  pgkBmp.getBmp('操作界面_武功_弹起.bmp', temping);
//  BtnMagic.A2Up := temping;
//  pgkBmp.getBmp('操作界面_武功_按下.bmp', temping);
//  BtnMagic.A2Down := temping;
//  pgkBmp.getBmp('操作界面_武功_鼠标.bmp', temping);
//  BtnMagic.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_武功_禁止.bmp', temping);
//  BtnMagic.A2NotEnabled := temping;
//  BtnMagic.Left := 544;
//  BtnMagic.Top := 88;
//  SetControlPos(BtnMagic);
//    //任务
//  pgkBmp.getBmp('操作界面_任务_弹起.bmp', temping);
//  btnQuest.A2Up := temping;
//  pgkBmp.getBmp('操作界面_任务_按下.bmp', temping);
//  btnQuest.A2Down := temping;
//  pgkBmp.getBmp('操作界面_任务_鼠标.bmp', temping);
//  btnQuest.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_任务_禁止.bmp', temping);
//  btnQuest.A2NotEnabled := temping;
//  btnQuest.Left := 565;
//  btnQuest.Top := 88;
//  SetControlPos(btnQuest);
//    //玩家互动
//  pgkBmp.getBmp('操作界面_玩家互动_弹起.bmp', temping);
//  btnProcession.A2Up := temping;
//  pgkBmp.getBmp('操作界面_玩家互动_按下.bmp', temping);
//  btnProcession.A2Down := temping;
//  pgkBmp.getBmp('操作界面_玩家互动_鼠标.bmp', temping);
//  btnProcession.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_玩家互动_禁止.bmp', temping);
//  btnProcession.A2NotEnabled := temping;
//  btnProcession.Left := 586;
//  btnProcession.Top := 88;
//  SetControlPos(btnProcession);
//    //好友
//  pgkBmp.getBmp('操作界面_好友_弹起.bmp', temping);
//  sbthailfellow.A2Up := temping;
//  pgkBmp.getBmp('操作界面_好友_按下.bmp', temping);
//  sbthailfellow.A2Down := temping;
//  pgkBmp.getBmp('操作界面_好友_鼠标.bmp', temping);
//  sbthailfellow.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_好友_禁止.bmp', temping);
//  sbthailfellow.A2NotEnabled := temping;
//  sbthailfellow.Left := 607;
//  sbthailfellow.Top := 88;
//  SetControlPos(sbthailfellow);
//    //门派管理
//  pgkBmp.getBmp('操作界面_门派管理_弹起.bmp', temping);
//  btnGuild.A2Up := temping;
//  pgkBmp.getBmp('操作界面_门派管理_按下.bmp', temping);
//  btnGuild.A2Down := temping;
//  pgkBmp.getBmp('操作界面_门派管理_鼠标.bmp', temping);
//  btnGuild.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_门派管理_禁止.bmp', temping);
//  btnGuild.A2NotEnabled := temping;
//  btnGuild.Left := 628;
//  btnGuild.Top := 88;
//  SetControlPos(btnGuild);
//    //技能
//  pgkBmp.getBmp('操作界面_技能_弹起.bmp', temping);
//  btnjn.A2Up := temping;
//  pgkBmp.getBmp('操作界面_技能_鼠标.bmp', temping);
//  btnjn.A2Mouse := temping;
//  btnjn.A2NotEnabled := temping;
//  btnjn.Left := 649;
//  btnjn.Top := 88;
//  SetControlPos(btnjn);
//
//    //寄售
//  pgkBmp.getBmp('操作界面_寄售_弹起.bmp', temping);
//  btnjs.A2Up := temping;
//  pgkBmp.getBmp('操作界面_寄售_鼠标.bmp', temping);
//  btnjs.A2Mouse := temping;
//  btnjs.A2NotEnabled := temping;
//  btnjs.Left := 670;
//  btnjs.Top := 88;
//  SetControlPos(btnjs);
//
//    //邮件管理
//  pgkBmp.getBmp('操作界面_邮件_弹起.bmp', temping);
//  btnyj.A2Up := temping;
//  pgkBmp.getBmp('操作界面_邮件_鼠标.bmp', temping);
//  btnyj.A2Mouse := temping;
//  btnyj.A2NotEnabled := temping;
//  btnyj.Left := 691;
//  btnyj.Top := 88;
//  SetControlPos(btnyj);
//    //仓库管理
//  pgkBmp.getBmp('操作界面_仓库_弹起.bmp', temping);
//  btnck.A2Up := temping;
//  pgkBmp.getBmp('操作界面_仓库_鼠标.bmp', temping);
//  btnck.A2Mouse := temping;
//  btnck.A2NotEnabled := temping;
//  btnck.Left := 712;
//  btnck.Top := 88;
//  SetControlPos(btnck);
//
//
//    //排行
//  pgkBmp.getBmp('操作界面_排行_弹起.bmp', temping);
//  btnBillboardcharts.A2Up := temping;
//  pgkBmp.getBmp('操作界面_排行_按下.bmp', temping);
//  btnBillboardcharts.A2Down := temping;
//  pgkBmp.getBmp('操作界面_排行_鼠标.bmp', temping);
//  btnBillboardcharts.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_排行_禁止.bmp', temping);
//  btnBillboardcharts.A2NotEnabled := temping;
//  btnBillboardcharts.Left := 733;
//  btnBillboardcharts.Top := 88;
//  SetControlPos(btnBillboardcharts);
//    //商城按钮
//  pgkBmp.getBmp('操作界面_商城_弹起.bmp', temping);
//  bitEmporia.A2Up := temping;
//  pgkBmp.getBmp('操作界面_商城_按下.bmp', temping);
//  bitEmporia.A2Down := temping;
//  pgkBmp.getBmp('操作界面_商城_鼠标.bmp', temping);
//  bitEmporia.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_商城_禁止.bmp', temping);
//  bitEmporia.A2NotEnabled := temping;
//  bitEmporia.Left := 754;
//  bitEmporia.Top := 88;
//  SetControlPos(bitEmporia);
//    //退出
//  pgkBmp.getBmp('操作界面_退出_弹起.bmp', temping);
//  BtnExit.A2Up := temping;
//  pgkBmp.getBmp('操作界面_退出_按下.bmp', temping);
//  BtnExit.A2Down := temping;
//  pgkBmp.getBmp('操作界面_退出_鼠标.bmp', temping);
//  BtnExit.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_退出_禁止.bmp', temping);
//  BtnExit.A2NotEnabled := temping;
//  BtnExit.Left := 775;
//  BtnExit.Top := 88;
//  SetControlPos(BtnExit);
//    //游戏设置
//  pgkBmp.getBmp('操作界面_游戏设置_弹起.bmp', temping);
//  BtnSelMagic.A2Up := temping;
//  pgkBmp.getBmp('操作界面_游戏设置_按下.bmp', temping);
//  BtnSelMagic.A2Down := temping;
//  pgkBmp.getBmp('操作界面_游戏设置_鼠标.bmp', temping);
//  BtnSelMagic.A2Mouse := temping;
//  pgkBmp.getBmp('操作界面_游戏设置_禁止.bmp', temping);
//  BtnSelMagic.A2NotEnabled := temping;
//  BtnSelMagic.Left := 122;
//  BtnSelMagic.Top := 89;
// // SetControlPos(BtnSelMagic);
//end;

procedure TFrmBottom.SetNewVersionTest;
var
  tmpStream: TMemoryStream;
  xmlname: string;
begin
  if FTestPos then
  begin
    FUIConfig.Free;
    FUIConfig := TNativeXml.Create;
    FUIConfig.Utf8Encoded := True;
    if G_Default1024 then
      xmlname := 'Bottom1024.xml'
    else
      xmlname := 'Bottom.xml';
    if not zipmode then //2015.11.12 在水一方 >>>>>>
      FUIConfig.LoadFromFile('.\ui\' + xmlname)
    else begin
      if not alwayscache then
        tmpStream := TMemoryStream.Create;
      try
        if upzipstream(xmlzipstream, tmpStream, xmlname) then
          FUIConfig.LoadFromStream(tmpStream);
      finally
        if not alwayscache then
          tmpStream.Free;
      end;
    end;
  end;

  if not zipmode then
  begin
    if G_Default1024 then
      FrmM.BottomUpImage.LoadFromFile('.\ui\img\操作界面_底框上_1024.bmp')
    else
      FrmM.BottomUpImage.LoadFromFile('.\ui\img\操作界面_底框上半部分.bmp');
  end
  else begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      if G_Default1024 then
      begin
        if upzipstream(bmpzipstream, tmpStream, '操作界面_底框上_1024.bmp') then
          FrmM.BottomUpImage.LoadFromStream(tmpStream);
      end
      else
        if upzipstream(bmpzipstream, tmpStream, '操作界面_底框上半部分.bmp') then
          FrmM.BottomUpImage.LoadFromStream(tmpStream);
    finally
      if not alwayscache then
        tmpStream.Free;
    end;
  end;
  FrmM.BottomUpImage.TransparentColor := 0;

  if not zipmode then
  begin
    if G_Default1024 then
      A2form.FImageSurface.LoadFromFile('.\ui\img\操作界面_底框下_1024.bmp')
    else
      A2form.FImageSurface.LoadFromFile('.\ui\img\操作界面_底框下半部分.bmp');
  end
  else begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      if G_Default1024 then
      begin
        if upzipstream(bmpzipstream, tmpStream, '操作界面_底框下_1024.bmp') then
          A2form.FImageSurface.LoadFromStream(tmpStream);
      end
      else
        if upzipstream(bmpzipstream, tmpStream, '操作界面_底框下半部分.bmp') then
          A2form.FImageSurface.LoadFromStream(tmpStream);
    finally
      if not alwayscache then
        tmpStream.Free;
    end;
  end; //2015.11.12 在水一方 <<<<<<
  A2form.boImagesurface := true;

  if G_Default1024 then
    //Self.Top := FrmM.clientheight - Self.Height + 3
    Self.Top := FrmM.clientheight - Self.Height
  else
    Self.Top := FrmM.clientheight - Self.Height;

  if G_Default1024 then
   // Self.Left := ((FrmM.ClientWidth - FrmBottom.Width) div 2)
    Self.Left := ((FrmM.ClientWidth - FrmBottom.Width) div 2) + 1
  else
    Self.Left := ((FrmM.ClientWidth - FrmBottom.Width) div 2);

//  Self.Left := ((FrmM.ClientWidth - FrmBottom.Width) div 2);
  //pgkBmp.getBmp('操作界面_底框下半部分.bmp', A2form.FImageSurface);

    //EdChat.MaxLength := 52;

    //重新设置PgHead位置
  SetControlPos(lblShortcut7);
  SetControlPos(lblShortcut6);
  SetControlPos(lblShortcut5);
  SetControlPos(lblShortcut4);
  SetControlPos(lblShortcut3);
  SetControlPos(lblShortcut2);
  SetControlPos(lblShortcut1);
  SetControlPos(lblShortcut0);
  SetControlPos(talkHintBtn);
  SetControlPos(PgHead);

  SetControlPos(PGArm);

  SetControlPos(PGLeg);

  SetControlPos(PGInPower);

  SetControlPos(PgOutPower);

  SetControlPos(PgMagic);

  SetControlPos(PgLife);
    //经验条
  SetControlPos(PGSkillLevel1);

  SetControlPos(PGSkillLevel2);
    //坐标
  SetControlPos(LbPos);
    //频道显示窗口
  SetControlPos(Editchannel);
    //显示武功文字
  SetControlPos(UseMagic1);

  SetControlPos(UseMagic2);

  SetControlPos(UseMagic3);

  SetControlPos(UseMagic4);
    //闪动框
  SetControlPos(LbEvent);
    //聊天窗口
  Lbchat1.Color := ColorSysToDxColor(clRed);
  SetControlPos(Lbchat1);

  Lbchat2.Color := ColorSysToDxColor(clRed);
  Lbchat3.Color := ColorSysToDxColor(clRed);
  Lbchat4.Color := ColorSysToDxColor($080808); //00292110
  SetControlPos(Lbchat2);

  SetControlPos(Lbchat3);

  SetControlPos(Lbchat4);
    //文字输入
  SetControlPos(EdChat);

    //频道选择

  SetControlPos(Button_chooseChn);
  //辅助
  SetControlPos(btnTools);
    //人物属性
  SetControlPos(btnCharAttrib);
    //物品栏
  SetControlPos(ButtonWear);

    //人物武功

  SetControlPos(BtnMagic);
    //任务
  SetControlPos(btnQuest);
    //玩家互动
  SetControlPos(btnProcession);
    //好友
  SetControlPos(sbthailfellow);
    //门派管理
  SetControlPos(btnGuild);
    //技能
  SetControlPos(btnjn);

    //寄售

  SetControlPos(btnjs);

    //邮件管理

  SetControlPos(btnyj);
    //仓库管理
  SetControlPos(btnck);


    //排行

  SetControlPos(btnBillboardcharts);
    //商城按钮
  SetControlPos(bitEmporia);
    //退出
  SetControlPos(BtnExit);
    //游戏设置
  SetControlPos(BtnSelMagic);
  SetControlPos(btnHelp);
    //喇叭 聊天记录
  SetControlPos(BtnHorn);
  SetControlPos(btnHistory);
  SetOtherConfig;
  energyGraphicsclass.SetenergyLeft(SELF.FenergyLeft);
  energyGraphicsclass.SetenergyTop(SELF.FenergyTop);
end;

procedure TFrmBottom.SetOtherConfig;
begin
  try
    if G_Default1024 then
    begin
      self.FenergyTop := fhei1024 - 117 - (36 div 2);
      self.FenergyLeft := (fwide1024 - 36) div 2;
    end else
    begin
      self.FenergyTop := fhei - 117 - (36 div 2);
      self.FenergyLeft := (fwide - 36) div 2;
    end;
  except
  end;
end;

procedure TFrmBottom.SetControlPos(AControl: TControl); //2015.11.13 在水一方
var
  node: TXmlNode;
  width, height, left, top: Integer;
  visible: Boolean;
  A2Down, A2Mouse, A2NotEnabled, A2Up: string;
  temping: TA2Image;
  path: string;
  tmpStream: TMemoryStream;
begin
  path := '.\ui\img\';
  if FTestPos then
  begin
    if not alwayscache then
      tmpStream := TMemoryStream.Create;
    try
      try
        node := FUIConfig.Root.NodeByName('Views').FindNode(AControl.Name);
        if node = nil then
          exit;
        width := node.ReadInteger('width', -1);
        height := node.ReadInteger('height', -1);
        left := node.ReadInteger('left', -1);
        top := node.ReadInteger('top', -1);
        visible := node.ReadBool('visible', True);
        AControl.Visible := visible;
        if visible then
        begin
          if AControl is TA2Button then
          begin
            try
              temping := TA2Image.Create(32, 32, 0, 0);
              A2Down := node.ReadWidestring('A2Down', '');

              if (A2Down <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Down);
                  TA2Button(AControl).A2Down := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2Down) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2Down := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2Mouse := node.ReadWidestring('A2Mouse', '');
              if (A2Mouse <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Mouse);
                  TA2Button(AControl).A2Mouse := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2Mouse) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2Mouse := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2Up := node.ReadWidestring('A2Up', '');
              if (A2Up <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2Up);
                  TA2Button(AControl).A2Up := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2Up) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2Up := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end;
              A2NotEnabled := node.ReadWidestring('A2NotEnabled', '');
              if (A2NotEnabled <> '') then
              begin
                if not zipmode then begin
                  temping.LoadFromFile(path + A2NotEnabled);
                  TA2Button(AControl).A2NotEnabled := temping;
                end
                else begin
                  if upzipstream(bmpzipstream, tmpStream, A2NotEnabled) then
                    temping.LoadFromStream(tmpStream);
                  TA2Button(AControl).A2NotEnabled := temping;
                  if not alwayscache then tmpStream.Clear;
                end;
              end
              else
              begin
                TA2Button(AControl).A2NotEnabled := nil;
              end;
            finally
              temping.Free;

            end;
          end;

          if width <> -1 then
          begin
            AControl.Width := width;
          end;
          if height <> -1 then
          begin
            AControl.Height := height;
          end;
          if left <> -1 then
          begin
            AControl.Left := left;
          end;
          if top <> -1 then
          begin
            AControl.Top := top;
          end;
        end
        else
        begin
          AControl.Visible := visible;
        end;

      except
      end;
    finally
      if not alwayscache then
        tmpStream.Free;
    end;

  end
  else
  begin
    AControl.Visible := True;
  end;
end;

procedure TFrmBottom.btnToolsClick(Sender: TObject);
begin
  FrmGameToolsNew.Visible := not FrmGameToolsNew.Visible;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmBottom.btnToolsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>辅助(ALT + 6)');
end;

procedure TFrmBottom.talkHintBtnMouseEnter(Sender: TObject);
var
  cp, pos: TPoint;
begin
  G_enterhint := True;
  cp.X := talkHintBtn.Left;
  cp.Y := talkHintBtn.Height;
  pos := talkHintBtn.ClientToScreen(cp);
  GameMenu.setA2Hint_X(talkHintBtn.Left);
  GameMenu.setA2Hint_Y(420); ///420
  GameMenu.ProcessDown(-1);
//  // GameHint.setText(integer(Sender), ' 门              派' + #13#10 + 'AL            T+A'+ #13#10 + 'ALT   +A'+ #13#10 + 'ALT     +A'+ #13#10 + 'ALT     +A'+ #13#10 + 'ALT     +A'+ #13#10 + 'ALT     +A');
//  if not frmShowHint.Visible then
//  begin
//      // FrmM.AddA2Form(Self, A2form);
//
//    frmShowHint.Visible := True;
////     Lbchat1.Visible:=False;
////      Lbchat2.Visible:=False;
////      Lbchat3.Visible:=False;
////      Lbchat4.Visible:=False;
//     //  frmShowHint.BringToFront;
//  end;
//
end;

procedure TFrmBottom.talkHintBtnMouseLeave(Sender: TObject);
var
  cp, pos: TPoint;
  bheigth: Integer;
begin

  GetCursorPos(pos);
 // GetWindowRect(frmShowHint.Handle);
  cp := FrmM.ScreenToClient(pos);
  bheigth := FrmM.ClientHeight - (Self.Height - talkHintBtn.Top);
  if (cp.X < talkHintBtn.Left) or (cp.Y > bheigth) then
    GameMenu.Close
  else
  begin
    G_enterhint := False;
    hintTimer.Enabled := True;
  end;
end;

procedure TFrmBottom.hintTimerTimer(Sender: TObject);
var
  cp, pos: TPoint;
  bheigth: Integer;
  leftbottomx, leftbottomy: Integer;
  righttopx, righttopy: Integer;
begin
//  if boStartInitGamemenu or (GameMenu = nil) then Exit;
  if not GameMenu.Visable then
  begin
    hintTimer.Enabled := false;
    Exit;
  end;
  leftbottomx := GameMenu.getrect.Left; //  frmShowHint.Left;
  leftbottomy := GameMenu.getrect.Top + GameMenu.getHeight; // frmShowHint.Top + frmShowHint.A2form.FImageSurface.Height;
  righttopy := GameMenu.getrect.Top; // frmShowHint.Top;
  righttopx := GameMenu.getrect.Left + GameMenu.getWidth; // frmShowHint.Left + frmShowHint.A2form.FImageSurface.Width;
  GetCursorPos(pos);
  cp := FrmM.ScreenToClient(pos);
  OutputDebugString(pchar('当前坐标:x=' + inttostr(cp.X) + '  y=' + inttostr(cp.Y) + '  右上点坐标: x=' + inttostr(righttopx) + '  y=' + inttostr(righttopy)));
  if (cp.X < leftbottomx) or (cp.Y > leftbottomy) or (cp.X > righttopx) or (cp.Y < righttopy) then
  begin
//         Lbchat1.Visible:=True;
//      Lbchat2.Visible:=True;
//      Lbchat3.Visible:=True;
//      Lbchat4.Visible:=True;
    hintTimer.Enabled := false;
  //   if not G_enterhint then
    GameMenu.Close;
  //  frmShowHint.Visible := False;
  end;

end;

procedure TFrmBottom.exitTimerTimer(Sender: TObject);
var
  endTime: Cardinal;
begin
  endTime := GetTickCount;
  if FAbortGame then
  begin
    if ((endTime - FStartExitTime) > 200) then
      ExitProcess(0);
  end;
  if FrmcMessageBox.Visible then
  begin
    FStartExiting := False;
    exitTimer.Enabled := False;
    Exit;
  end;
  if ((endTime - FStartExitTime) > 200) and (not FrmcMessageBox.Visible) then
  begin
    FrmcMessageBox.AbortGame;
    FStartExiting := False;
    exitTimer.Enabled := False;
  end;

end;

procedure TFrmBottom.AbortGame;
begin
  exitTimer.Enabled := False;
  FAbortGame := True;
  FStartExitTime := GetTickCount;

  exitTimer.Enabled := True;
end;

procedure TFrmBottom.SendGetItemData(AName: string);
var
  tempsend: TWordComData;
begin
  tempsend.Size := 0;
  WordComData_ADDbyte(tempsend, CM_GETITEMDATA);
  WordComData_ADDstring(tempsend, AName);

  Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TFrmBottom.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if GameMenu.Visable then
  begin
    if GameMenu.CurrItem < 0 then
       // GameMenu.Close
    else
    begin
      GameMenu.MouseDown;

    end;
    Exit;
  end;
end;

procedure TFrmBottom.btnHelpMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.settext(Integer(Sender), '【系统暂未开放】');
end;

procedure TFrmBottom.btnHelpClick(Sender: TObject);
begin
  GameHint.settext(Integer(Sender), '【系统暂未开放】');
end;

procedure TFrmBottom.btnyjMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>强化(ALT + R)');
end;

procedure TFrmBottom.btnyjMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TFrmBottom.btnHelpMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TFrmBottom.btnBillboardchartsMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TFrmBottom.btnProcessionMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TFrmBottom.sbthailfellowMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TFrmBottom.BtnHornMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>喇叭(ALT + H)');
end;

procedure TFrmBottom.BtnHornClick(Sender: TObject);
begin

  FrmHorn.Visible := not FrmHorn.Visible;
  if FrmHorn.Visible then
  begin

    FrmM.SetA2Form(FrmHorn, FrmHorn.A2form);
  end;
end;

procedure TFrmBottom.btnHistoryClick(Sender: TObject);
begin

  frmHistory.Visible := not frmHistory.Visible; //1
  if frmHistory.Visible then
  begin
    FrmM.SetA2Form(frmHistory, frmHistory.A2form);
  end;
  SAY_EdChatFrmBottomSetFocus;

end;

procedure TFrmBottom.btnHistoryMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  GameHint.setText(integer(Sender), '<$000080FF>消息记录(ALT + C)');

end;

procedure TFrmBottom.SetChatInfo;
var
  k: word;
begin
  if (self.FSelectedChatItemData.rViewName = '') then
  begin
    EdChat.HaveChatItem := false;
    sendsay(EdChat.Text, k)
  end
  else
  begin
    EdChat.ChatItemName := self.FSelectedChatItemData.rViewName;
    EdChat.HaveChatItem := true;
//    if length(self.EdChat.Text) > 0 then
//    begin
//      if self.EdChat.Text[1] = '!'  then
//       begin
//             if EdChat.SelectedChatItemPos = -1 then
//      EdChat.SelectedChatItemPos := length(self.EdChat.Text) + 1;
//    self.FSelectedChatItemPos := length(self.EdChat.Text) + 1 - length(FCurEdChatText);
//       end else
//       begin
//          if EdChat.SelectedChatItemPos = -1 then
//      EdChat.SelectedChatItemPos := length(self.EdChat.Text) + 1;
//    self.FSelectedChatItemPos := length(self.EdChat.Text) + 1  - length(FCurEdChatText);
//       end;
//    end
//
//    else
    begin
      if EdChat.SelectedChatItemPos = -1 then
        EdChat.SelectedChatItemPos := length(self.EdChat.Text) + 1;
//      if Editchannel.Caption = '纸条' then
//        self.FSelectedChatItemPos := EdChat.SelectedChatItemPos else
//        self.FSelectedChatItemPos := length(self.EdChat.Text) + 1 - length(FCurEdChatText);
      if Editchannel.Caption = '门派' then
      begin
        self.FSelectedChatItemPos := length(self.EdChat.Text) - 2;
      end
      else if Editchannel.Caption = '同盟' then
      begin
        self.FSelectedChatItemPos := length(self.EdChat.Text) - 3;
      end
      else if Editchannel.Caption = '地图' then
      begin
        self.FSelectedChatItemPos := length(self.EdChat.Text) - length('@地图' + ' ');
      end
      else if Editchannel.Caption = '队伍' then
      begin
        self.FSelectedChatItemPos := length(self.EdChat.Text) - 1;
      end
      else if Editchannel.Caption = '纸条' then
      begin
        self.FSelectedChatItemPos := EdChat.SelectedChatItemPos;
      end
      else if Editchannel.Caption = '世界' then
      begin
        self.FSelectedChatItemPos := length(self.EdChat.Text) - 1;
      end
      else
      begin
        self.FSelectedChatItemPos := length(self.EdChat.Text) + 1;
      end;
    end;
    sendsayitem(EdChat.Text, k);
  end;
end;

procedure TFrmBottom.MsaysendEx(aname, astr: string; aTCSayItemM: TCSayItemM);
var
  rdstr: string;
begin

  rdstr := format('%s" %s', [aname, astr]);

  AddChatExH(rdstr, ColorSysToDxColor($00008890), 0, aTCSayItemM);
  msayadd(aname);
end;

procedure TFrmBottom.AddChatExm(astr: string; fcolor, bcolor: integer; APTSChatItemMessageM: PTSChatItemMessageM; newpos: Integer);
var
  str, rdstr: string;
  col: Integer;
  addflag: Boolean;
begin
  addflag := FALSE;
  str := astr;
  while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    if rdstr = '' then
      break;
    if pos('[队伍]', rdstr) = 1 then
    begin
      if chat_duiwu then
        addflag := TRUE;
    end
    else if chat_outcry then
    begin // 呐喊
      if rdstr[1] = '[' then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_Guild then
    begin // 门派
      if (rdstr[1] = '<') and (bcolor = 1) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_ally then
    begin // 联盟
      if (rdstr[1] = '<') and (bcolor = 2182) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_notice then
    begin // 公告
      if bcolor = 16912 then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_normal then
    begin // 对话
      if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
      begin
        addflag := TRUE;

      end;
    end;

    if Addflag then
    begin
      if LbChat.Items.Count >= 4 then LbChat.Items.delete(0);
      col := MakeLong(fcolor, bcolor);

      LbChat.Items.addObject(rdstr, TChatItemData.Create);

      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).col := col;
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemPos := APTSChatItemMessageM^.rpos; //  -length('@纸条 '+CharCenterName+' ') ;//-length('@纸条');
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemName := APTSChatItemMessageM^.rChatItemData.rViewName;
      copymemory(@TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemData, @APTSChatItemMessageM^.rChatItemData, sizeof(TItemData));

      frmHistory.add_item(rdstr, fcolor, bcolor, APTSChatItemMessageM^.rpos, APTSChatItemMessageM^.rChatItemData.rViewName, @APTSChatItemMessageM^.rChatItemData);

//      if frmHistory.listHistory.Count >= 600 then frmHistory.listHistory.DeleteItem(0);
//      frmHistory.listHistory.addObject(rdstr, TChatItemData.Create);
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).col := col;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemPos := APTSChatItemMessageM^.rpos;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemName := APTSChatItemMessageM^.rChatItemData.rViewName;
//      copymemory(@TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemData, @APTSChatItemMessageM^.rChatItemData, sizeof(TItemData));
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).FColor := fcolor;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).bcolor := bcolor;
//
//      frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
//      frmHistory.listHistory.Loaded;
//      frmHistory.listHistory.DrawItem;
    end;

    LbChat.Itemindex := LbChat.Items.Count - 1;
    LbChat.Itemindex := -1;
  end;
  ChatPaint;
end;

procedure TFrmBottom.AddChatExH(astr: string; fcolor, bcolor: integer; aTCSayItemM: TCSayItemM);
var
  str, rdstr, rastr, rbstr: string;
  col, iLen: Integer;
  addflag: Boolean;
begin
  addflag := FALSE;
  str := astr;
  while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    if rdstr = '' then
      break;
    if pos('[队伍]', rdstr) = 1 then
    begin
      if chat_duiwu then
        addflag := TRUE;
    end
    else if chat_outcry then
    begin // 呐喊
      if rdstr[1] = '[' then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_Guild then
    begin // 门派
      if (rdstr[1] = '<') and (bcolor = 1) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_ally then
    begin // 联盟
      if (rdstr[1] = '<') and (bcolor = 2182) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_notice then
    begin // 公告
      if bcolor = 16912 then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_normal then
    begin // 对话
      if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
      begin
        addflag := TRUE;

      end;
    end;

    if Addflag then
    begin
      if LbChat.Items.Count >= 4 then LbChat.Items.delete(0);
      col := MakeLong(fcolor, bcolor);

      LbChat.Items.addObject(rdstr, TChatItemData.Create);

      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).col := col;
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemPos := aTCSayItemM.rpos; //  -length('@纸条 '+CharCenterName+' ') ;//-length('@纸条');
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemName := aTCSayItemM.rChatItemData.rViewName;
      copymemory(@TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemData, @aTCSayItemM.rChatItemData, sizeof(TItemData));

      frmHistory.add_item(rdstr, fcolor, bcolor, aTCSayItemM.rpos, aTCSayItemM.rChatItemData.rViewName, @aTCSayItemM.rChatItemData);

//      if frmHistory.listHistory.Count >= 600 then frmHistory.listHistory.DeleteItem(0);
//      frmHistory.listHistory.addObject(rdstr, TChatItemData.Create);
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).col := col;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemPos := aTCSayItemM.rpos;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemName := aTCSayItemM.rChatItemData.rViewName;
//      copymemory(@TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemData, @aTCSayItemM.rChatItemData, sizeof(TItemData));
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).FColor := fcolor;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).bcolor := bcolor;
//      frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
//      frmHistory.listHistory.Loaded;
//      frmHistory.listHistory.DrawItem;
    end;

    LbChat.Itemindex := LbChat.Items.Count - 1;
    LbChat.Itemindex := -1;
  end;
  ChatPaint;
end;

procedure TFrmBottom.AddChatEx(astr: string; fcolor, bcolor: integer; APTSChatItemMessage: PTSChatItemMessage);
var
  str, rdstr, rastr, rbstr: string;
  col, iLen: Integer;
  addflag: Boolean;
begin
  addflag := FALSE;
  str := astr;
  while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    if rdstr = '' then
      break;
    if pos('[队伍]', rdstr) = 1 then
    begin
      if chat_duiwu then
        addflag := TRUE;
    end
    else if chat_outcry then
    begin // 呐喊
      if rdstr[1] = '[' then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_Guild then
    begin // 门派
      if (rdstr[1] = '<') and (bcolor = 1) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_ally then
    begin // 联盟
      if (rdstr[1] = '<') and (bcolor = 2182) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_notice then
    begin // 公告
      if bcolor = 16912 then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_normal then
    begin // 对话
      if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
      begin
        addflag := TRUE;
      end;
    end;
    //ShowMessage(rdstr + '颜色:' + IntToStr(fcolor) + '/' + IntToStr(bcolor));

    if Addflag then
    begin
      if LbChat.Items.Count >= 4 then
        LbChat.Items.delete(0);
      col := MakeLong(fcolor, bcolor);

      LbChat.Items.addObject(rdstr, TChatItemData.Create);
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).col := col;
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemPos := APTSChatItemMessage^.rpos;
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemName := APTSChatItemMessage^.rChatItemData.rViewName;

      copymemory(@TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemData, @APTSChatItemMessage^.rChatItemData, sizeof(TItemData));

      frmHistory.add_item(rdstr, fcolor, bcolor, APTSChatItemMessage^.rpos, APTSChatItemMessage^.rChatItemData.rViewName, @APTSChatItemMessage^.rChatItemData);

//      if frmHistory.listHistory.Count >= 600 then frmHistory.listHistory.DeleteItem(0);
//      frmHistory.listHistory.addObject(rdstr, TChatItemData.Create);
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).col := col;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemPos := APTSChatItemMessage^.rpos;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemName := APTSChatItemMessage^.rChatItemData.rViewName;
//
//      copymemory(@TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemData, @APTSChatItemMessage^.rChatItemData, sizeof(TItemData));
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).FColor := fcolor;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).bcolor := bcolor;
//
//      frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
//      frmHistory.listHistory.Loaded;
//      frmHistory.listHistory.DrawItem;

      //frmHistory.filter;
    end;

    LbChat.Itemindex := LbChat.Items.Count - 1;
    LbChat.Itemindex := -1;
  end;

  ChatPaint;
end;

procedure TFrmBottom.ChangeChatEx(astr: string; fcolor, bcolor: integer; APTSChatItemMessage: PTSChatItemMessage);
var
  str, rdstr, rastr, rbstr: string;
  col, iLen, i: Integer;
  addflag: Boolean;
begin
  addflag := FALSE;
  str := astr;
  //while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    //if rdstr = '' then
    //  break;

    //if Addflag then
    begin
      col := MakeLong(fcolor, bcolor);
      for i := 0 to LbChat.Items.Count - 1 do begin
        if LbChat.Items.Objects[i] = nil then continue;
        //if not (LbChat.Items.Objects[i] is TChatItemData) then continue;
        if LbChat.Items.Objects[i].ClassName <> 'TChatItemData' then continue;
        if TChatItemData(LbChat.Items.Objects[i]).ItemData.rId <> APTSChatItemMessage.rSn then continue;
        //TChatItemData(LbChat.Items.Objects[i]).col := col;
        //TChatItemData(LbChat.Items.Objects[i]).ItemPos := APTSChatItemMessage^.rpos;
        //TChatItemData(LbChat.Items.Objects[i]).ItemName := APTSChatItemMessage^.rChatItemData.rViewName;
        copymemory(@TChatItemData(LbChat.Items.Objects[i]).ItemData, @APTSChatItemMessage^.rChatItemData, sizeof(TItemData));
        break;
      end;

      for i := 0 to frmHistory.listHistory.Count - 1 do begin
        if frmHistory.listHistory.ChatList.Objects[i] = nil then continue;
        //if not (frmHistory.listHistory.ChatList.Objects[i] is TChatItemData) then continue;
        if frmHistory.listHistory.ChatList.Objects[i].ClassName <> 'TChatItemData' then continue;
        if TChatItemData(frmHistory.listHistory.ChatList.Objects[i]).ItemData.rId <> APTSChatItemMessage.rSn then continue;
        //TChatItemData(frmHistory.listHistory.ChatList.Objects[i]).col := col;
        //TChatItemData(frmHistory.listHistory.ChatList.Objects[i]).ItemPos := APTSChatItemMessage^.rpos;
        //TChatItemData(frmHistory.listHistory.ChatList.Objects[i]).ItemName := APTSChatItemMessage^.rChatItemData.rViewName;
        copymemory(@TChatItemData(frmHistory.listHistory.ChatList.Objects[i]).ItemData, @APTSChatItemMessage^.rChatItemData, sizeof(TItemData));
        //TChatItemData(frmHistory.listHistory.ChatList.Objects[i]).FColor := fcolor;
        //TChatItemData(frmHistory.listHistory.ChatList.Objects[i]).bcolor := bcolor;

        frmHistory.listHistory.DrawItem;

        //frmHistory.filter;
        break;
      end;
    end;

    LbChat.Itemindex := LbChat.Items.Count - 1;
    LbChat.Itemindex := -1;
  end;
  ChatPaint;
end;

procedure TFrmBottom.AddChatExHead(astr: string; fcolor, bcolor: integer; APTSChatItemMessage: PTSChatItemMessageHead);
var
  str, rdstr, rastr, rbstr: string;
  col, iLen: Integer;
  addflag: Boolean;
  tmpitem: TItemdata;
begin
  addflag := FALSE;
  str := astr;
  while TRUE do
  begin
    str := GetValidStr3(str, rdstr, #13);
    if rdstr = '' then
      break;
    if pos('[队伍]', rdstr) = 1 then
    begin
      if chat_duiwu then
        addflag := TRUE;
    end
    else if chat_outcry then
    begin // 呐喊
      if rdstr[1] = '[' then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_Guild then
    begin // 门派
      if (rdstr[1] = '<') and (bcolor = 1) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_ally then
    begin // 联盟
      if (rdstr[1] = '<') and (bcolor = 2182) then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_notice then
    begin // 公告
      if bcolor = 16912 then
      begin
        addflag := TRUE;
      end;
    end;

    if chat_normal then
    begin // 对话
      if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
      begin
        addflag := TRUE;
      end;
    end;
    //ShowMessage(rdstr + '颜色:' + IntToStr(fcolor) + '/' + IntToStr(bcolor));

    if Addflag then
    begin
      if LbChat.Items.Count >= 4 then
        LbChat.Items.delete(0);
      col := MakeLong(fcolor, bcolor);

      LbChat.Items.addObject(rdstr, TChatItemData.Create);
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).col := col;
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemPos := APTSChatItemMessage^.rpos;
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemName := APTSChatItemMessage^.rItemName;

      fillchar(TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemData, sizeof(TItemData), 0);
      TChatItemData(LbChat.Items.Objects[LbChat.Items.Count - 1]).ItemData.rId := APTSChatItemMessage^.rSn;

      frmHistory.add_ExHead(rdstr, fcolor, bcolor, APTSChatItemMessage^.rpos, APTSChatItemMessage^.rItemName, APTSChatItemMessage^.rSn);

//      if frmHistory.listHistory.Count >= 600 then frmHistory.listHistory.DeleteItem(0);
//
//      frmHistory.listHistory.addObject(rdstr, TChatItemData.Create);
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).col := col;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemPos := APTSChatItemMessage^.rpos;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemName := APTSChatItemMessage^.rItemName;
//      fillchar(TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemData, sizeof(TItemData), 0);
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).FColor := fcolor;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).bcolor := bcolor;
//      TChatItemData(frmHistory.listHistory.ChatList.Objects[frmHistory.listHistory.ChatList.Count - 1]).ItemData.rId := APTSChatItemMessage^.rSn;
//
//      frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
//      frmHistory.listHistory.Loaded;
//      frmHistory.listHistory.DrawItem;
//
//      frmHistory.filter;
    end;

    LbChat.Itemindex := LbChat.Items.Count - 1;
    LbChat.Itemindex := -1;
  end;
  ChatPaint;
end;

procedure TFrmBottom.SetItemBackGround;
var
  path: string;
  itembacknode, itembackchildnode, fpsnode: TXmlNode;
  i: Integer;
begin
  path := '.\ui\img\';
  if FTestPos then
  begin
    try
      itembacknode := FUIConfig.Root.NodeByName('Views').FindNode('ItemBackGround');
      if itembacknode = nil then exit;
      if itembacknode <> nil then
      begin
        for i := 0 to itembacknode.NodeCount - 1 do
        begin
          itembackchildnode := itembacknode.Nodes[i];
          FItemBackGroundFileNameList.Values[itembackchildnode.Name] := path + itembackchildnode.ValueAsWidestring;
        end;
      end;
    except
    end;
  end;
end;

procedure TFrmBottom.LbPosMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  aitem: TItemData;
  frm: TForm;
  cfrm: TFrmHorn;
begin
  if (ssAlt in shift) and (button = mbLeft)
    then
  begin
    fillchar(aitem, sizeof(TItemData), 0);
    with aitem do
    begin
      rName := FrmMiniMap.A2ILabel1.Caption + ':' + LbPos.Caption;
      rViewName := FrmMiniMap.A2ILabel1.Caption + ':' + LbPos.Caption;
      rId := -999;
    end;
    frm := FrmM.findForm('TFrmHorn');
    cfrm := nil;
    if frm <> nil then
    begin
      cfrm := TFrmHorn(frm);
      if (cfrm <> nil) and cfrm.Visible then
      begin
        cfrm.FSelectedChatItemData := aitem;
        cfrm.SetChatInfo;
      end
      else
      begin
        FSelectedChatItemData := aitem;
        SetChatInfo;
      end;
    end
    else
    begin
      FSelectedChatItemData := aitem;
      SetChatInfo;
    end;
  end;
end;

procedure TFrmBottom.LbPosMouseLeave(Sender: TObject);
begin
  GameHint.Close;
end;

procedure TFrmBottom.LbPosMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  GameHint.setText(integer(Sender), '按住ALT点击坐标可发送当前位置!');
    //GameHint.Close;
  exit;
end;


end.

