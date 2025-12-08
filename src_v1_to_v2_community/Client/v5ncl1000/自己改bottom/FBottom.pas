unit FBottom;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    deftype, StdCtrls, A2Form, ExtCtrls, Autil32, A2Img, CharCls,Clipbrd, ShellAPI,
  Menus, Gauges, Buttons,
    uAnsTick, DXDraws,    Cltype, ctable, log, Acibfile, clmap,
    AtzCls, uPerSonBat ;
type
    TFrmBottom = class(TForm)
        A2Form: TA2Form;
        Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N6: TMenuItem;
    BtnSelMagic: TA2Button;
    lblShortcut3: TA2ILabel;
    lblShortcut2: TA2ILabel;
    lblShortcut1: TA2ILabel;
    lblShortcut0: TA2ILabel;
    EdChat: TA2Edit;
    LbChat: TListBox;
    bitEmporia: TA2Button;
    BtnSkill_new: TA2Button;
    Button_chooseChn: TA2Button;
    ButtonWear: TA2Button;
    btnCharAttrib: TA2Button;
    BtnMagic: TA2Button;
    btnQuest: TA2Button;
    btnProcession: TA2Button;
    btnGuild: TA2Button;
    sbthailfellow: TA2Button;
    btnBillboardcharts: TA2Button;
    BtnExit: TA2Button;
    btnjs: TA2Button;
    btnyj: TA2Button;
    btnck: TA2Button;
    btnjn: TA2Button;
    lblShortcut7: TA2ILabel;
    lblShortcut6: TA2ILabel;
    lblShortcut5: TA2ILabel;
    lblShortcut4: TA2ILabel;
    Editchannelx: TA2Label;
        procedure FormCreate(Sender: TObject);
        procedure AddChat(astr: string; fcolor, bcolor: integer);
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
        procedure lblShortcut0DragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure lblShortcut0StartDrag(Sender: TObject;
            var DragObject: TDragObject);
        procedure BtnExitClick(Sender: TObject);
        procedure sbthailfellowClick(Sender: TObject);
        procedure btnGuildClick(Sender: TObject);
        procedure btnQuestClick(Sender: TObject);
        procedure btnProcessionClick(Sender: TObject);
        procedure btnBillboardchartsClick(Sender: TObject);
        procedure btnCharAttribClick(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure Lbchat1MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure btnCharAttribMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
        procedure BtnMagicMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure btnQuestMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure btnProcessionMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
        procedure btnGuildMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure sbthailfellowMouseMove(Sender: TObject; Shift: TShiftState;
            X, Y: Integer);
        procedure btnBillboardchartsMouseMove(Sender: TObject;
            Shift: TShiftState; X, Y: Integer);
        procedure BtnExitMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure Button_chooseChnClick(Sender: TObject);
        procedure ButtonWearMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure bitEmporiaMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure BtnSelMagicMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure lblShortcut0MouseLeave(Sender: TObject);
        procedure lblShortcut0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure Lbchat4MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
   
      procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
      procedure N8Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure btnjsClick(Sender: TObject);
    procedure btnyjClick(Sender: TObject);
    procedure btnckClick(Sender: TObject);
    procedure btnjnClick(Sender: TObject);
    private
        { Private declarations }
        procedure capture(bitmap: Tbitmap);
        procedure AppKeyDown(Key: Word; Shift: TShiftState);
      //   procedure ChatPaint;

    public
      //  shortcutkey: array[0..7] of byte;                                       //c  +1-8
        shortcutLabels: array[0..7] of TA2ILabel;


        ALLKeyDownTick: DWORD;
        printKeyDownTick: DWORD;
        SendChatList: tstringlist;                                              //发送 消息 历史记录
        SendChatListItemIndex: integer;
        SendMsayList: tstringlist;                                              //纸条 消息 纪录
        SendMsayListItemIndex: integer;
        { Public declarations }
        curlife, maxlife: integer;
        temping: TA2Image;
        procedure MessageProcess(var code: TWordComData);
        procedure SetFormText;
        function AppKeyDownHook(var Msg: TMessage): Boolean;
        procedure ClientCapture;
        procedure numSAY(astr: integer; aColor: byte; atext: string);
//        procedure ShortcutKeyClear();
//        procedure ShortcutKeyDel(id: integer);
//        procedure ShortcutKeyUP(id: integer);
//        procedure ShortcutKeySETimg(savekey, KeyIndex: integer);
//        procedure ShortcutKeySET(savekey, KeyIndex: integer);

          procedure msayadd(aname: string);
        function msayGet(aname: string): boolean;
        procedure Msaysend(aname, astr: string);
        procedure SaveAllKey();
   
        procedure sendsay(strsay: string; var Key: Word);
        //2009 6 23 增加
        procedure SetNewVersion();
        procedure SetOldVersion();

        procedure SetChatChanel;


    end;

var
    FrmBottom: TFrmBottom;
    chat_duiwu, chat_outcry, chat_Guild, chat_notice, chat_normal, chat_world: Boolean;
    MapName: string;
    SaveChatList: TStringList;
    CloseFlag: Boolean = FALSE;

procedure SAY_EdChatFrmBottomSetFocus();
implementation

uses
    FMain, Fbl, FAttrib, FExchange, FSound, FDepository,
      FBatList, FMuMagicOffer, FCharAttrib, FHistory, FMiniMap,
    FShowPopMsg, FGuild, FWearItem, FEMAIL, FAuction, BackScrn, FQuest,
    FProcession, FBillboardcharts, FQuantity, filepgkclass, energy,
    FEmporia, FnewMagic, FGameToolsNew, FNEWHailFellow, FSearch, FConfirmDialog
    , FChat
{$IFDEF gm}
    //, cTm
{$ENDIF}
    , Fhelp_htm, FPassEtc, FNewEMAIL, FLittleMap, FcMessageBox,
    FBooth, Unit_console, FSkill, FNPCTrade, Fperson;

{$R *.DFM}

procedure SAY_EdChatFrmBottomSetFocus();
begin

    if FrmQuantity.Visible then
    begin
        FrmQuantity.SetFocus;
        FrmQuantity.EdCount.SetFocus;
        FrmQuantity.EdCount.SelStart:=Length(FrmQuantity.EdCount.Text);
        FrmQuantity.EdCount.SelectAll;
    end
    else if FrmBottom.Visible then
    begin
        FrmBottom.SetFocus;
        FrmBottom.EdChat.SetFocus;
        FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
    end;
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

                if mmAnsTick < integer(ALLKeyDownTick) + 25 then exit;
                case TWMKey(Msg).CharCode of
                    0..20: ;
                else ALLKeyDownTick := mmAnsTick;

                end;

                if Visible = false then exit;

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
                            if frmHelp.Visible then

                                frmHelp.Visible := false
                            else
                                frmHelp.Visible := true;
                        end;
                    VK_F5: FrmAttrib.KeySaveAction(0);
                    VK_F6: FrmAttrib.KeySaveAction(1);
                    VK_F7: FrmAttrib.KeySaveAction(2);
                    VK_F8: FrmAttrib.KeySaveAction(3);
                    VK_F9: FrmAttrib.KeySaveAction(4);
                    VK_F10: FrmAttrib.KeySaveAction(5);
                    VK_F11: FrmAttrib.KeySaveAction(6);
                    VK_F12: FrmAttrib.KeySaveAction(7);
                    VK_HOME:
                        begin
                            FrmGameToolsNew.Visible := not FrmGameToolsNew.Visible;
                            SAY_EdChatFrmBottomSetFocus;
                        end;

                else
                    begin
                        if TWMKey(Msg).CharCode in [VK_F2, VK_F3, VK_F4] then
                        begin
                            ckey.rmsg := CM_KEYDOWN;
                            ckey.rkey := TWMKey(Msg).CharCode;
                            Frmfbl.SocketAddData(sizeof(Ckey), @Ckey);
                        end;
                        Cl := CharList.CharGet(CharCenterId);
                        if Cl = nil then exit;
                        if Cl.AllowAddAction = FALSE then exit;

                        case TWMKey(Msg).CharCode of
                            VK_F4: CL.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, cl.feature, AM_HELLO);
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

    chat_duiwu := true;
    chat_outcry := TRUE;
    chat_Guild := TRUE;
    chat_notice := TRUE;
    chat_normal := TRUE;
    //包裹 角色 武功 任务 玩家互动(综合窗口) 门派 好友 排行 退出
    ButtonWear.Hint := ('物品');
    BtnMagic.Hint := ('武功');
      btnCharAttrib.Hint := '角色';
    btnQuest.Hint := '任务';
    btnProcession.Hint := '交互';
    btnGuild.Hint := '门派';
    sbthailfellow.Hint := '好友';
    btnBillboardcharts.Hint := '排行榜';
    BtnExit.Hint := '退出游戏';

end;

procedure TFrmBottom.FormCreate(Sender: TObject);
begin
    // Parent := FrmM;
    FrmM.AddA2Form(Self, A2form);
    //AddChat('辅助程序快捷键为HOME', WinRGB(28, 28, 28), 0);
 //    Visible:=False;
    LbChat.Items.addObject('===辅助程序快捷键为HOME或ALT+Y ===', TObject(MakeLong(WinRGB(28, 28, 28), 0)));

    //ChatPaint; //显示在聊天框里

//    A2Form.FA2Hint.Ftype := hstTransparent;


    ClientWidth := fwide;
    ClientHeight := 30;

    SendMsayList := tstringlist.Create;                                         //纸条 消息 纪录
    editset := nil;                                                             // @SAY_EdChatFrmBottomSetFocus;
    //2009 3 23 增加
    if WinVerType = wvtnew then
    begin
        SetnewVersion;
    end else if WinVerType = wvtold then
    begin
        SetOldVersion;
    end;

    ALLKeyDownTick := 0;
    //pplication.HookMainWindow(AppKeyDownHook);
    Color := clBlack;

    Left := 0;

    Top := fhei - Height;
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
 
    energyGraphicsclass := TenergyGraphicsclass.Create(FrmM, Self);
    energyGraphicsclass.BringToFront;             //镜子的那个球

end;

procedure TFrmBottom.SetNewVersion();
begin

    //EdChat.MaxLength := 52;
  if fwide=800 then
  begin
    lblShortcut0.Left:=lblShortcut0.Left-82;
   lblShortcut1.Left:=lblShortcut1.Left-82;

    lblShortcut2.Left:=lblShortcut2.Left-82;
   lblShortcut3.Left:=lblShortcut3.Left-82;

    lblShortcut4.Left:=lblShortcut4.Left-85;
   lblShortcut5.Left:=lblShortcut5.Left-85;

    lblShortcut6.Left:=lblShortcut6.Left-85;
   lblShortcut7.Left:=lblShortcut7.Left-85;
   btnyj.Visible:=False;
   btnjs.Visible:=False;
   btnjn.Visible:=False;
   bitEmporia.Visible:=False;
   btnBillboardcharts.Visible:=False;
   sbthailfellow.Visible:=False;
   //A2Form.FImageSurface.loadfromFile(ExtractFilePath(ParamStr(0))+'bmp\下半部分800.bmp');
   pgkBmp_n.getBmp('下半部分800.bmp', A2form.FImageSurface);
   end else    pgkBmp_n.getBmp('下半部分.bmp', A2form.FImageSurface);
    
    //  A2Form.FImageSurface.loadfromFile(ExtractFilePath(ParamStr(0))+'bmp\下半部分.bmp');
    A2form.boImagesurface := true;

      //频道显示窗口
    { Editchannel.Left :=65;
    Editchannel.Top := 30; }
    Editchannelx.Width := 29;
    Editchannelx.Height := 28;



    //聊天窗口

    //文字输入
   { EdChat.Left := 238;
    EdChat.Top := 93;   }
   if fwide=800 then EdChat.Width:=200 else EdChat.Width := 263;
    EdChat.Height := 18;

    temping := TA2Image.Create(32, 32, 0, 0);
    //频道选择
    pgkBmp.getBmp('操作界面_频道选择_弹起.bmp', temping);
    Button_chooseChn.A2Up := temping;
    pgkBmp.getBmp('操作界面_频道选择_按下.bmp', temping);
    Button_chooseChn.A2Down := temping;
    pgkBmp.getBmp('操作界面_频道选择_鼠标.bmp', temping);
    Button_chooseChn.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_频道选择_禁止.bmp', temping);
    Button_chooseChn.A2NotEnabled := temping;
   { Button_chooseChn.Left := 148;
    Button_chooseChn.Top := 89; }
    Button_chooseChn.Width := 52;
    Button_chooseChn.Height := 19;


    //人物属性
    pgkBmp.getBmp('操作界面_角色属性_弹起.bmp', temping);
    btnCharAttrib.A2Up := temping;
    pgkBmp.getBmp('操作界面_角色属性_按下.bmp', temping);
    btnCharAttrib.A2Down := temping;
    pgkBmp.getBmp('操作界面_角色属性_鼠标.bmp', temping);
    btnCharAttrib.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_角色属性_禁止.bmp', temping);
    btnCharAttrib.A2NotEnabled := temping;
  {  btnCharAttrib.Left := 502;
    btnCharAttrib.Top := 88;  }
    //物品栏
    pgkBmp.getBmp('操作界面_物品栏_弹起.bmp', temping);
    ButtonWear.A2Up := temping;
    pgkBmp.getBmp('操作界面_物品栏_按下.bmp', temping);
    ButtonWear.A2Down := temping;
    pgkBmp.getBmp('操作界面_物品栏_鼠标.bmp', temping);
    ButtonWear.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_物品栏_禁止.bmp', temping);
    ButtonWear.A2NotEnabled := temping;
  {  ButtonWear.Left := 523;
    ButtonWear.Top := 88;
                              }

    //人物武功
    pgkBmp.getBmp('操作界面_武功_弹起.bmp', temping);
    BtnMagic.A2Up := temping;
    pgkBmp.getBmp('操作界面_武功_按下.bmp', temping);
    BtnMagic.A2Down := temping;
    pgkBmp.getBmp('操作界面_武功_鼠标.bmp', temping);
    BtnMagic.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_武功_禁止.bmp', temping);
    BtnMagic.A2NotEnabled := temping;
   { BtnMagic.Left := 544;
    BtnMagic.Top := 88;   }
    //任务
    pgkBmp.getBmp('操作界面_任务_弹起.bmp', temping);
    btnQuest.A2Up := temping;
    pgkBmp.getBmp('操作界面_任务_按下.bmp', temping);
    btnQuest.A2Down := temping;
    pgkBmp.getBmp('操作界面_任务_鼠标.bmp', temping);
    btnQuest.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_任务_禁止.bmp', temping);
    btnQuest.A2NotEnabled := temping;
   { btnQuest.Left := 565;
    btnQuest.Top := 88; }

    //玩家互动
    pgkBmp.getBmp('操作界面_玩家互动_弹起.bmp', temping);
    btnProcession.A2Up := temping;
    pgkBmp.getBmp('操作界面_玩家互动_按下.bmp', temping);
    btnProcession.A2Down := temping;
    pgkBmp.getBmp('操作界面_玩家互动_鼠标.bmp', temping);
    btnProcession.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_玩家互动_禁止.bmp', temping);
    btnProcession.A2NotEnabled := temping;
   { btnProcession.Left := 586;
    btnProcession.Top := 88;  }

    //好友
    pgkBmp.getBmp('操作界面_好友_弹起.bmp', temping);
    sbthailfellow.A2Up := temping;
    pgkBmp.getBmp('操作界面_好友_按下.bmp', temping);
    sbthailfellow.A2Down := temping;
    pgkBmp.getBmp('操作界面_好友_鼠标.bmp', temping);
    sbthailfellow.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_好友_禁止.bmp', temping);
    sbthailfellow.A2NotEnabled := temping;
  {  sbthailfellow.Left := 607;
    sbthailfellow.Top := 88;  }

    //门派管理
    pgkBmp.getBmp('操作界面_门派管理_弹起.bmp', temping);
    btnGuild.A2Up := temping;
    pgkBmp.getBmp('操作界面_门派管理_按下.bmp', temping);
    btnGuild.A2Down := temping;
    pgkBmp.getBmp('操作界面_门派管理_鼠标.bmp', temping);
    btnGuild.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_门派管理_禁止.bmp', temping);
    btnGuild.A2NotEnabled := temping;
   { btnGuild.Left := 628;
    btnGuild.Top := 88;  }

    //技能
    pgkBmp.getBmp('操作界面_技能_弹起.bmp', temping);
    btnjn.A2Up := temping;
    pgkBmp.getBmp('操作界面_技能_鼠标.bmp', temping);
    btnjn.A2Mouse := temping;
    btnjn.A2NotEnabled := temping;
   { btnjn.Left := 649;
    btnjn.Top := 88;  }


    //寄售
    pgkBmp.getBmp('操作界面_寄售_弹起.bmp', temping);
    btnjs.A2Up := temping;
    pgkBmp.getBmp('操作界面_寄售_鼠标.bmp', temping);
    btnjs.A2Mouse := temping;
    btnjs.A2NotEnabled := temping;
  {  btnjs.Left := 670;
    btnjs.Top := 88;}


    //邮件管理
    pgkBmp.getBmp('操作界面_邮件_弹起.bmp', temping);
    btnyj.A2Up := temping;
    pgkBmp.getBmp('操作界面_邮件_鼠标.bmp', temping);
    btnyj.A2Mouse := temping;
    btnyj.A2NotEnabled := temping;
   { btnyj.Left := 691;
    btnyj.Top := 88;     }

    //仓库管理
    pgkBmp.getBmp('操作界面_仓库_弹起.bmp', temping);
    btnck.A2Up := temping;
    pgkBmp.getBmp('操作界面_仓库_鼠标.bmp', temping);
    btnck.A2Mouse := temping;
    btnck.A2NotEnabled := temping;
  {  btnck.Left := 712;
    btnck.Top := 88; }



    //排行
    pgkBmp.getBmp('操作界面_排行_弹起.bmp', temping);
    btnBillboardcharts.A2Up := temping;
    pgkBmp.getBmp('操作界面_排行_按下.bmp', temping);
    btnBillboardcharts.A2Down := temping;
    pgkBmp.getBmp('操作界面_排行_鼠标.bmp', temping);
    btnBillboardcharts.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_排行_禁止.bmp', temping);
    btnBillboardcharts.A2NotEnabled := temping;
   { btnBillboardcharts.Left := 733;
    btnBillboardcharts.Top := 88;   }

    //商城按钮
     pgkBmp.getBmp('操作界面_商城_弹起.bmp', temping);
    bitEmporia.A2Up := temping;
    pgkBmp.getBmp('操作界面_商城_按下.bmp', temping);
    bitEmporia.A2Down := temping;
    pgkBmp.getBmp('操作界面_商城_鼠标.bmp', temping);
    bitEmporia.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_商城_禁止.bmp', temping);
    bitEmporia.A2NotEnabled := temping;
   { bitEmporia.Left := 754;
    bitEmporia.Top := 88; }

    //退出
    pgkBmp.getBmp('操作界面_退出_弹起.bmp', temping);
    BtnExit.A2Up := temping;
    pgkBmp.getBmp('操作界面_退出_按下.bmp', temping);
    BtnExit.A2Down := temping;
    pgkBmp.getBmp('操作界面_退出_鼠标.bmp', temping);
    BtnExit.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_退出_禁止.bmp', temping);
    BtnExit.A2NotEnabled := temping;
   { BtnExit.Left := 775;
    BtnExit.Top := 88;   }

    //游戏设置
    pgkBmp.getBmp('操作界面_游戏设置_弹起.bmp', temping);
    BtnSelMagic.A2Up := temping;
    pgkBmp.getBmp('操作界面_游戏设置_按下.bmp', temping);
    BtnSelMagic.A2Down := temping;
    pgkBmp.getBmp('操作界面_游戏设置_鼠标.bmp', temping);
    BtnSelMagic.A2Mouse := temping;
    pgkBmp.getBmp('操作界面_游戏设置_禁止.bmp', temping);
    BtnSelMagic.A2NotEnabled := temping;
  {  BtnSelMagic.Left := 122;
    BtnSelMagic.Top := 89; }
end;

procedure TFrmBottom.SetOldVersion();
begin
    pgkBmp.getBmp('bottom.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;
    Button_chooseChn.Enabled := false;
end;

procedure TFrmBottom.FormDestroy(Sender: TObject);
begin
    //application.UnhookMainWindow(AppKeyDownHook);
    energyGraphicsclass.Free;
    SaveChatList.Free;
    SendChatList.Free;
    SendMsayList.Free;
    temping.Free;
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
                rFColor := ColorSysToDxColor($FF);                              //WinRGB(22, 22, 22);
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
        end else
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
    psLeftText: ptsLeftText;
    psAttribBase: PTSAttribBase;
    psAttriblife: PTSAttribLife;
    psEventString: PTSEventString;
    i, aidstr, acolor: integer;

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
                if frmCharAttrib.Visible then frmCharAttrib.update;
                //                ListboxUsedMagic.Clear;
                psEventString := @Code.data;
                Frmperson.PGSkillLevelSET(psEventString.rKEY);
                str := GetWordString(psEventString^.rWordString);
                for i := 0 to high(Frmperson.UseMagicArr) do Frmperson.UseMagicArr[i].Caption := '';
                for i := 0 to high(Frmperson.UseMagicArr) do
                begin
                    str := GetValidStr3(str, rdstr, ',');
                    if rdstr = '' then Break;

                    Frmperson.UseMagicArr[i].Caption := rdstr;
                end;

            end;
        SM_ATTRIBBASE:
            begin
                psAttribBase := @Code.Data;
                with psAttribBase^ do
                begin
                    maxlife := psAttribBase^.rlife;
                    curlife := psAttribBase^.rcurlife;

                    frmperson.PGEnergy.MaxValue := psattribBase^.rEnergy;
                    frmperson.PGEnergy.Progress := psattribBase^.rCurEnergy;

                    frmperson.PGEnergy.Hint := Get10000To100(rCurEnergy) + '/' + Get10000To100(rEnergy);

                    frmperson.PGInPower.MaxValue := psattribBase^.rInPower;
                    frmperson.PGInPower.Progress := psattribBase^.rCurInPower;

                    frmperson.PGInPower.Hint := Get10000To100(rCurInPower) + '/' + Get10000To100(rInPower);

                    frmperson.PGOutPower.MaxValue := psattribBase^.rOutPower;
                    frmperson.PGOutPower.Progress := psattribBase^.rCurOutPower;

                    frmperson.PGOutPower.Hint := Get10000To100(rCurOutPower) + '/' + Get10000To100(rOutPower);

                    frmperson.PGMagic.MaxValue := psattribBase^.rMagic;
                    frmperson.PGMagic.Progress := psattribBase^.rCurMagic;

                    frmperson.PGMagic.Hint := Get10000To100(psattribbase^.rCurMagic) + '/' + Get10000To100(psattribbase^.rMagic);

                    frmperson.PGLife.MaxValue := maxlife;
                    frmperson.PGLife.Progress := curlife;

                    frmperson.PGLife.Hint := Get10000To100(curlife) + '/' + Get10000To100(maxlife);

                end;
            end;
        SM_ATTRIB_LIFE:
            begin
                psAttribLife := @Code.Data;
                curlife := psAttribLife^.rcurlife;
                frmperson.PGLife.Progress := curlife;
                frmperson.PGLife.Hint := IntToStr(curlife) + '/' + IntToStr(maxlife);

                //            LbLife.Caption := IntToStr(curlife) + '/' + IntToStr(maxlife);
            end;
        SM_LeftText:
            begin
                psLeftText := @Code.data;
                str := GetwordString(psLeftText^.rWordstring);
                case psLeftText.rtype of
                    mtLeftText:
                        begin
                            PersonBat.LeftMsgListadd(str, psLeftText^.rFColor);
                            exit;
                        end;
                    mtLeftText2:
                        begin
                            PersonBat.LeftMsgListadd2(str, psLeftText^.rFColor);
                            exit;
                        end;
                    mtLeftText3:
                        begin
                            PersonBat.LeftMsgListadd3(str, psLeftText^.rFColor);
                            exit;
                        end;
                    mtNone: ;
                else exit;
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
                    end else rdstr := str;
                end else
                begin
                    str := ChangeDontSay(str);
                    rdstr := str;
                end;

                AddChat(rdstr, psChatMessage^.rFColor, psChatMessage^.rBColor);
                str := '';
                rdstr := '';
            end;
        SM_SHOWCENTERMSG:
            begin

                PTTSShowCenterMsg := @Code.data;
                if PTTSShowCenterMsg.rtype <> SHOWCENTERMSG_RollMSG then
                begin

                    str := GetwordString(PTTSShowCenterMsg.rText);
                    AddChat('【系统】' + str, PTTSShowCenterMsg.rColor, 0);
                end;
            end;
        SM_MSay:
            begin
                i := 1;
                str := WordComData_GETString(code, i);
                msayadd(str);

                //   AddChat(rdstr, WinRGB(22, 22, 22), 0);
                rdstr := WordComData_GETString(code, i);
                rdstr := format('%s> %s', [str, rdstr]);
                AddChat(rdstr, ColorSysToDxColor($0000B0B0), 0);
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
 

    end;
end;

{
procedure Tfrmbottom.ChatPaint();
    procedure _settextcolor(aid: integer; atemp: TA2Label);
    var
        col: integer;
        fcol, bcol: word;
        astr: string;
    begin

        fcol := ColorSysToDxColor(clWhite);
        bcol := ColorSysToDxColor(clBlack);
        astr := ' ';
        if LbChat.Items.Count >= aid then
        begin
            col := Integer(LbChat.Items.Objects[aid - 1]);

            fcol := LOWORD(Col);
            bcol := HIWORD(col);
            astr := LbChat.Items.Strings[aid - 1];
        end;
        if bcol = 0 then bcol := ColorSysToDxColor($001C1C1C);

        if astr = '' then astr := ' ';
        atemp.BackColor := bcol;
        atemp.FontColor := fcol;
        atemp.Caption := astr;
    end;
begin
    _settextcolor(1, Lbchat1);
    _settextcolor(2, Lbchat2);
    _settextcolor(3, Lbchat3);
    _settextcolor(4, Lbchat4);

end;     }

procedure TFrmBottom.AddChat(astr: string; fcolor, bcolor: integer);
var
    str, rdstr: string;
    col: Integer;
    addflag: Boolean;
begin
    //   FrmChatList.AddChat (astr, fcolor, bcolor);
    addflag := FALSE;
    str := astr;
    while TRUE do
    begin
        str := GetValidStr3(str, rdstr, #13);
        if rdstr = '' then break;
        if pos('[队伍]', rdstr) = 1 then
        begin
            if chat_duiwu then addflag := TRUE;
        end
        else if chat_outcry then
        begin                                                                   // 寇摹扁
            if rdstr[1] = '[' then
            begin
                addflag := TRUE;
            end;
        end;

        if chat_Guild then
        begin                                                                   // 辨靛
            if rdstr[1] = '<' then
            begin
                addflag := TRUE;
            end;
        end;

        if chat_notice then
        begin                                                                   // 傍瘤荤亲
            if bcolor = 16912 then
            begin
                addflag := TRUE;
            end;
        end;

        if chat_normal then
        begin                                                                   // 老馆蜡历
            if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
            begin
                addflag := TRUE;
            end;
        end;

        if Addflag then
        begin
            if LbChat.Items.Count >= 4 then LbChat.Items.delete(0);
            col := MakeLong(fcolor, bcolor);
            LbChat.Items.addObject(rdstr, TObject(col));
          //  if frmHistory.listHistory.Count >= 768 then frmHistory.listHistory.DeleteItem(0);
            //frmHistory.listHistory.StringList.AddObject(rdstr, TObject(col));
            frmHistory.listHistory.AddItem(rdstr);
            frmHistory.listHistory.SETItemsColor(frmHistory.listHistory.Count - 1, fcolor, bcolor);
            frmHistory.listHistory.ItemIndex := frmHistory.listHistory.Count - 1;
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
   // ChatPaint; //显示在聊天框里
end;

function savefilename: string;
var
    year, mon, day, hour, min, sec, dummy: word;
    str: string;
    function num(n: integer): string;
    begin
        Result := '';
        if n >= 10 then Result := IntToStr(n)
        else Result := '0' + InttoStr(n);
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

procedure TFrmBottom.ClientCapture;
var
    abitmap: TBitmap;
    str: string;
begin
    if mmAnsTick < integer(printKeyDownTick) + 100 then exit;
    printKeyDownTick := mmAnsTick;

    abitmap := TBitmap.Create;
    try
        capture(abitmap);
        if DirExists('.\capture') then else Mkdir('.\' + 'capture');
        str := SaveFileName;
        aBitMap.SaveToFile('.\capture\' + str + '.bmp');
    finally
        abitmap.Free;
    end;
    PersonBat.LeftMsgListadd3('截图(' + str + ')', ColorSysToDxColor(clLime));

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

procedure TFrmBottom.LbChatMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    if LbChatClickFlag then boShowChat := not boShowChat;
    SAY_EdChatFrmBottomSetFocus;
end;
/////////////////////////////// EdChat events //////////////////////////////////

procedure TFrmBottom.EdChatEnter(Sender: TObject);
begin
    //    SetImeMode(EdChat.Handle, 1);
end;

procedure TFrmBottom.msayadd(aname: string);
begin
    if msayGet(aname) = false then
        SendMsayList.Add(aname);
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

procedure TFrmBottom.Msaysend(aname, astr: string);
var
    tempsend: TWordComData;
    rdstr: string;
begin
    tempsend.Size := 0;
    WordComData_ADDbyte(tempsend, CM_MSay);
    WordComData_ADDstring(tempsend, aname);
    WordComData_ADDstring(tempsend, astr);
    Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
    rdstr := format('%s" %s', [aname, astr]);
    AddChat(rdstr, ColorSysToDxColor($00008890), 0);
    msayadd(aname);
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
    begin                                                                       // Send SayData
        str := strsay;
        for i := 0 to 1 do
        begin
            str := GetValidStr3(str, strs[i], ' ');
            if str = '' then break;
        end;
        str2 := str;
        if strsay[1] = '~' then
        begin
            if frmProcession.A2ListBox1.Count > 0 then
                frmProcession.sendSay(strsay)
            else
            begin
                FrmBottom.Editchannelx.Caption := '当前';
                FrmBottom.AddChat('你现在还没有队伍', WinRGB(255, 255, 0), 0);
            end;
        end
        else if strs[0] = '@纸条' then
        begin
            Msaysend(strs[1], str2);
        end
        else
        begin
            tmpStr := strsay;
            if (tmpStr[1] = '!') and (tmpStr[2] = '!') then
            begin
                //如果没有帮派，不发送消息 退出
                if frmGuild.guildname = '' then
                begin
                    FrmBottom.Editchannelx.Caption := '当前';
                    FrmBottom.AddChat('你还没有帮派', WinRGB(255, 255, 0), 0);
                    exit;
                end;
            end;
            cSay.rmsg := CM_SAY;
            SetWordString(cSay.rWordString, strsay);
            cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
            Frmfbl.SocketAddData(cnt, @csay);
        end;
        if SendChatList.Count > 100 then SendChatList.Delete(0);
        SendChatList.Add(strsay);
        SendChatListItemIndex := SendChatList.Count - 1;
    end;
end;

procedure TFrmBottom.AppKeyDown(Key: Word; Shift: TShiftState);
var
    Cl: TCharClass;
    cKey: TCKey;
begin
    if mmAnsTick < integer(ALLKeyDownTick) + 25 then exit;
    case Key of
        0..20: ;
    else ALLKeyDownTick := mmAnsTick;

    end;

    if Visible = false then exit;

    if (ssCtrl in Shift) then
        case key of
            49: shortcutLabels[0].OnClick(shortcutLabels[0]);                   //1
            50: shortcutLabels[1].OnClick(shortcutLabels[1]);                   //2
            51: shortcutLabels[2].OnClick(shortcutLabels[2]);                   //3
            52: shortcutLabels[3].OnClick(shortcutLabels[3]);                   //4
            53: shortcutLabels[4].OnClick(shortcutLabels[4]);                   //5
            54: shortcutLabels[5].OnClick(shortcutLabels[5]);                   //6
            55: shortcutLabels[6].OnClick(shortcutLabels[6]);                   //7
            56: shortcutLabels[7].OnClick(shortcutLabels[7]);                   //8
        end;

    case key of
         VK_INSERT:
            begin
                FrmLittleMap.Visible := not FrmLittleMap.Visible;
            end;
        VK_F1:
            begin
                if frmHelp.Visible then

                    frmHelp.Visible := false
                else
                    frmHelp.Visible := true;
            end;
        VK_F5: FrmAttrib.KeySaveAction(0);
        VK_F6: FrmAttrib.KeySaveAction(1);
        VK_F7: FrmAttrib.KeySaveAction(2);
        VK_F8: FrmAttrib.KeySaveAction(3);
        VK_F9: FrmAttrib.KeySaveAction(4);
        VK_F10: FrmAttrib.KeySaveAction(5);
        VK_F11: FrmAttrib.KeySaveAction(6);
        VK_F12: FrmAttrib.KeySaveAction(7);
        VK_HOME:
            begin
                FrmGameToolsNew.Visible := not FrmGameToolsNew.Visible;
                SAY_EdChatFrmBottomSetFocus;
            end;

    else
        begin
            if key in [VK_F2, VK_F3, VK_F4] then
            begin
                ckey.rmsg := CM_KEYDOWN;
                ckey.rkey := key;
                Frmfbl.SocketAddData(sizeof(Ckey), @Ckey);
            end;
            Cl := CharList.CharGet(CharCenterId);
            if Cl = nil then exit;
            if Cl.AllowAddAction = FALSE then exit;

            case key of
                VK_F4: CL.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, cl.feature, AM_HELLO);
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
    if EdChat.Text = 'c log open' then
    begin
        FrmConsole.show;
        EdChat.Text := '';
        exit;
    end;
    sendsay(EdChat.Text, key);
    if (key = VK_RETURN) or (key = VK_ESCAPE) then
    begin                                                                       // EdChat.Text Clear
        if WinVerType = wvtold then
        begin
            EdChat.Text := '';
        end
        else if WinVerType = wvtnew then
        begin
            if Editchannelx.Caption = '门派' then
            begin
                EdChat.Text := '!!';
            end else if Editchannelx.Caption = '地图' then
            begin
                EdChat.Text := '@地图' + ' ';
            end else if Editchannelx.Caption = '队伍' then
            begin
                EdChat.Text := '~';
            end else if Editchannelx.Caption = '纸条' then
            begin
                EdChat.Text := '@纸条' + ' ';
            end else if Editchannelx.Caption = '世界' then
            begin
                EdChat.Text := '! ';
            end else
            begin
                EdChat.Text := '';
            end;
            FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
        end;
        exit;
    end;
end;

procedure TFrmBottom.EdChatKeyPress(Sender: TObject; var Key: Char);
begin
    if (key = char(VK_ESCAPE)) or (key = char(VK_RETURN)) then key := char(0);
end;

procedure TFrmBottom.EdChatKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
    cSay: TCSay;
    cnt: integer;
begin
    Keyshift := Shift;
    if ssAlt in Shift then
    begin
        case Key of
            {ALT+Q=角色物品
            ALT+W=角色信息
            ALT+E=武功窗
            ALT+R=任务窗
            ALT+T=交互窗
            ALT+A=门派窗
            ALT+S=好友窗
            ALT+D=排行窗
            ALT+F=探查窗     FSearch.pas
            ALT+G=商城窗

            ALT+C=聊天纪录    已有  不变
            ALT+X=退出游戏    已有  不变
            ALT+M=地图        已有  不变
            }

{            word('z'), word('Z'):
                begin
                    boShowName := false;
                end;   }
            word('j'),WORD('J'):   //ALT+J  技能信息
            begin
                  frmSkill.Visible := true;
                  frmSkill.send_Get_Job_blueprint_Menu;
                  FrmM.SetA2Form(frmSkill, frmSkill.A2form);
              end;
            word('l'), word('L'):
                begin
{$IFDEF gm}
                 {   frmTM := tfrmTM.Create(frmm);
                    try
                        frmTM.ShowModal;
                    finally
                        frmTM.Free;
                        frmTM := nil;
                    end;  }

{$ENDIF}
                end;
                word('Y'), word('y'):
                begin
                   FrmGameToolsNew.Visible := not FrmGameToolsNew.Visible;
                   SAY_EdChatFrmBottomSetFocus;
                  end;
            word('Q'), word('q'):
                ButtonWearClick(nil);
            word('W'), word('w'): btnCharAttribClick(nil);
            word('E'), word('e'): BtnMagicClick(nil);
            word('R'), word('r'):
            begin
                  frmQuest.Visible := not frmQuest.Visible;
    if frmQuest.Visible then
    begin
        FrmM.SetA2Form(frmQuest, frmQuest.A2form);
        FrmM.move_win_form_Align(frmQuest, mwfCenter);
    end;
              end;
            word('T'), word('t'):
            begin
                  frmProcession.Visible := not frmProcession.Visible;
                  if frmProcession.Visible then
                  begin
                      FrmM.SetA2Form(frmProcession, frmProcession.A2form);
                      FrmM.move_win_form_Align(frmProcession, mwfCenter);
                  end;
              end;
            word('A'), word('a'):
                  begin
                  frmGuild.Visible := not frmGuild.Visible;
                    if frmGuild.Visible then
                    begin
                        FrmM.SetA2Form(frmGuild, frmGuild.A2form);
                        FrmM.move_win_form_Align(frmGuild, mwfCenter);
                    end;
                    end;
            word('S'), word('s'): sbthailfellowClick(nil);
            word('D'), word('d'):
             begin
                   frmBillboardcharts.Visible := not frmBillboardcharts.Visible;
                  if frmBillboardcharts.Visible then
                  begin
                      FrmM.SetA2Form(frmBillboardcharts, frmBillboardcharts.A2form);
                      FrmM.move_win_form_Align(frmBillboardcharts, mwfCenter);
                  end;
            end;
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
            word('G'), word('g'): bitEmporiaClick(nil);

            word('C'), word('c'):
                begin
                    frmHistory.Visible := not frmHistory.Visible;               //1
                    if frmHistory.Visible then
                    begin
                        FrmM.SetA2Form(frmHistory, frmHistory.A2form);
                    end;
                    SAY_EdChatFrmBottomSetFocus;
                end;
            word('M'), word('m'):
                begin
                    if map.GetMapWidth < 50 then exit;
                    FrmMiniMap.Visible := not FrmMiniMap.Visible;
                    if FrmMiniMap.Visible then
                    begin
                        FrmMiniMap.GETnpcList;
                        FrmM.SetA2Form(FrmMiniMap, FrmMiniMap.A2form);
                    end;
                end;
            word('X'), word('x'):
                begin
                    BtnExitClick(nil);
                end;
            //2009.0706增加
            word('V'), word('v'):
                begin
                       FrmSound.Visible := not FrmSound.Visible;                                   // option芒
                      //   FrmSelMagic.Visible := not FrmSelMagic.Visible;
                      if FrmSound.Visible then
                      begin

                          FrmM.SetA2Form(FrmSound, FrmSound.A2form);
                          //   FrmM.move_win_form_Align(FrmNewMagic, mwfRight);
                      end;
     //BtnSelMagicClick(nil);
                end;
            VK_RETURN:
                begin                                                           // Screnn Mode Change
                    if (NATION_VERSION = NATION_TAIWAN) or (NATION_VERSION = NATION_CHINA_1) then exit;

                    if FullScreen_time + 200 > mmAnsTick then
                    begin
                        AddChat('窗口/全屏切换太快。', WinRGB(22, 22, 0), 0);
                        exit;
                    end;
                    FullScreen_time := mmAnsTick;

                    FrmM.SaveAndDeleteAllA2Form;
                    FrmM.DXDraw.Finalize;
                    if doFullScreen in FrmM.DXDraw.Options then
                    begin
                        FrmM.BorderStyle := bsSingle;
                        FrmM.ClientWidth := fwide;
                        FrmM.ClientHeight := fhei;
                        FrmM.DXDraw.Options := FrmM.DXDraw.Options - [doFullScreen];

                    end else
                    begin
                        FrmM.BorderStyle := bsNone;
                        FrmM.ClientWidth := fwide;
                        FrmM.ClientHeight := fhei;
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
        end;
        exit;
    end;
    if ssCtrl in Shift then
    begin
        if key = 38 then                                                        //上
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
        if key = 40 then                                                        //下
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
    if key = 9 then
    begin
        if LbChatClickFlag then boShowChat := not boShowChat;
        SAY_EdChatFrmBottomSetFocus;
        FrmBottom.EdChat.SelectAll;
        exit;
    end;
    if key = 38 then                                                            //上
    begin
        if SendMsayList.Count > 0 then
        begin
            if (SendMsayListItemIndex >= 0) and (SendMsayListItemIndex < SendMsayList.Count) then
            begin
                edchat.Text := '@纸条 ' + SendMsayList.Strings[SendMsayListItemIndex] + ' ';
                edchat.SelStart := length(edchat.Text);
            end;
            SendMsayListItemIndex := SendMsayListItemIndex - 1;
            if (SendMsayListItemIndex < 0) or (SendMsayListItemIndex >= SendMsayList.Count) then
                SendMsayListItemIndex := 0;

        end else
        begin
            edchat.Text := '@纸条 ';
            edchat.SelStart := length(edchat.Text);
        end;
        exit;
    end;
    if key = 40 then                                                            //下
    begin
        if SendMsayList.Count > 0 then
        begin
            if (SendMsayListItemIndex >= 0) and (SendMsayListItemIndex < SendMsayList.Count) then
            begin
                edchat.Text := '@纸条 ' + SendMsayList.Strings[SendMsayListItemIndex] + ' ';
                edchat.SelStart := length(edchat.Text);
            end;
            SendMsayListItemIndex := SendMsayListItemIndex + 1;
            if (SendMsayListItemIndex < 0) or (SendMsayListItemIndex >= SendMsayList.Count) then
                SendMsayListItemIndex := SendMsayList.Count - 1;

        end else
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
    savekeyBool := FALSE;                                                       // FAttrib狼 savekey 阜澜
    FrmAttrib.Visible := TRUE;
    FrmAttrib.LbWindowName.Caption := ('属性');
    FrmAttrib.LbMoney.Caption := ('属性');
    FrmAttrib.PaneClose('PanelAttrib');
    FrmAttrib.PanelAttrib.Visible := TRUE;
    FrmAttrib.magicState(false);
end;

procedure TFrmBottom.BtnSkillClick(Sender: TObject);
begin
    savekeyBool := FALSE;                                                       // FAttrib狼 savekey 阜澜
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
   if frmHelp.Visible then

                    frmHelp.Visible := false
                else
                    frmHelp.Visible := true;
      Exit;              
    FrmSound.Visible := not FrmSound.Visible;                                   // option芒
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
        FrmBottom.Editchannelx.Caption := '当前';
    end
    else
    begin
        if (str[1] = '!') then
        begin
            FrmBottom.Editchannelx.Caption := '世界';
            if (str[2] = '!') then
            begin
                FrmBottom.Editchannelx.Caption := '门派';
            end;
        end
        else if (str[1] = '~') then
        begin
            FrmBottom.Editchannelx.Caption := '队伍'
        end
        else if (str[1] = '@') then
        begin
            substr := Copy(str, 2, 2 + 4);
            if substr = '纸条' then
                FrmBottom.Editchannelx.Caption := '纸条';
        end;
    end;
end;

procedure TFrmBottom.Timer1Timer(Sender: TObject);
var
    i: integer;
begin
    if not Visible then exit;
    SetChatChanel;

    if frmProcession.A2ListBox1.Count <= 0 then
        FrmChat.Button_procession_choose.Enabled := false
    else
        FrmChat.Button_procession_choose.Enabled := true;

    if frmGuild.A2ListBox1.Count <= 0 then
        FrmChat.Button_guild_choose.Enabled := false
    else
        FrmChat.Button_guild_choose.Enabled := true;

    if boACTIVATEAPP = false then exit;
    for i := 0 to FrmM.ComponentCount - 1 do
    begin
        if (FrmM.Components[i] is TfrmConfirmDialog) or
            (FrmM.Components[i] is TFrmQuantity) then
        begin
            if TForm(FrmM.Components[i]).Visible then exit;
        end;
    end;

    if frmBillboardcharts.Visible
        or frmHelp.Visible
        or frmbooth.Visible
        or frmNPCTrade.Visible
        or frmSkill.Visible
        or FrmQuantity.Visible
        or FrmDepository.TEMPFrmQuantity.Visible
        or FrmSearch.Visible
        or FrmPassEtc.Visible
        or FrmNEWEmail.Visible
        or FrmMuMagicOffer.Visible
        or FrmHailFellow.Visible
        or FrmGameToolsNew.Visible
        or frmEmporia.Visible
        or frmAuction.Visible then
    begin

    end
    else if FrmBottom.Visible
        and not edchat.Focused then
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
    //使用
    p := cKeyClass.get(TA2ILabel(Sender).Tag);
    if p = nil then exit;
    if p.rboUser = false then exit;
    tt := nil;
    case p.rkeyType of
        kcdk_HaveItem: tt := FrmWearItem.ILabels[p.rkey];
        kcdk_HaveMagic: tt := FrmNewMagic.MLabels[p.rkey];
        kcdk_HaveRiseMagic: tt := FrmNewMagic.RiseLabels[p.rkey];
        kcdk_HaveMysteryMagic: tt := FrmNewMagic.MysteryLabels[p.rkey];
        kcdk_BasicMagic: tt := FrmNewMagic.BLabels[p.rkey];
    else exit;
    end;
    if tt = nil then exit;
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
        if p = nil then Continue;
        if p.rboUser = false then Continue;
        case p.rkeyType of
            kcdk_HaveRiseMagic: tts.rKEY[i] := p.rkey + 120;
            kcdk_HaveMysteryMagic: tts.rKEY[i] := p.rkey + 180;
            kcdk_HaveItem: tts.rKEY[i] := p.rkey + 90;
            kcdk_HaveMagic: tts.rKEY[i] := p.rkey + 30;
            kcdk_BasicMagic: tts.rKEY[i] := p.rkey;
        end;
    end;
    for i := 0 to high(tts.rKEY2) do
    begin
        tts.rKEY2[i] := 255;
        p := cF5_F12Class.get(i);
        if p = nil then Continue;
        if p.rboUser = false then Continue;
        case p.rkeyType of
            kcdk_HaveRiseMagic: tts.rKEY2[i] := p.rkey + 120;
            kcdk_HaveMysteryMagic: tts.rKEY2[i] := p.rkey + 180;
            kcdk_HaveItem: tts.rKEY2[i] := p.rkey + 90;
            kcdk_HaveMagic: tts.rKEY2[i] := p.rkey + 30;
            kcdk_BasicMagic: tts.rKEY2[i] := p.rkey;
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

procedure TFrmBottom.lblShortcut0DragDrop(Sender, Source: TObject; X,
    Y: Integer);
var
    tp: TDragItem;
    titem: pTSHaveItem;
    shortcutid, tempid: integer;
    p: pTKeyClassData;
    t1, t2: TKeyClassData;
begin
    if Source = nil then exit;

    tp := pointer(Source);
    shortcutid := TA2ILabel(Sender).Tag;
    case tp.SourceID of
        WINDOW_BASICFIGHT: cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_BasicMagic, tp.Selected);
        WINDOW_MAGICS: cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveMagic, tp.Selected);
        WINDOW_MAGICS_Rise: cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveRiseMagic, tp.Selected);
        WINDOW_MAGICS_Mystery: cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveMysteryMagic, tp.Selected);
        WINDOW_ITEMS: cKeyClass.UPdate(shortcutid, kcdt_key, kcdk_HaveItem, tp.Selected);
        WINDOW_ShortcutItem:
            begin                                                               //交换
                p := cKeyClass.get(shortcutid);
                if p = nil then exit;
                t1 := p^;
                p := cKeyClass.get(tp.Selected);
                if p = nil then exit;
                t2 := p^;

                cKeyClass.UPdate(shortcutid, kcdt_key, t2.rkeyType, t2.rkey);
                cKeyClass.UPdate(tp.Selected, kcdt_key, t1.rkeyType, t1.rkey)
            end;
    end;

end;

procedure TFrmBottom.lblShortcut0DragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            case SourceID of
                WINDOW_BASICFIGHT: Accept := TRUE;
                WINDOW_MAGICS: Accept := TRUE;
                WINDOW_MAGICS_Rise: Accept := TRUE;
                WINDOW_MAGICS_Mystery: Accept := TRUE;
                WINDOW_ITEMS: Accept := TRUE;
                WINDOW_ShortcutItem: Accept := TRUE;
            end;
        end;
    end;
end;

procedure TFrmBottom.lblShortcut0StartDrag(Sender: TObject;
    var DragObject: TDragObject);
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
    if not FrmBottom.Visible then
    begin
      Shell_NotifyIcon(NIM_DELETE, @(FrmM.TrayIconData));
     ExitProcess(0);
     end;
case MessageBox(Handle, PChar('是否正常退出'+#13#10+'建议选择-是-'+#13#10+'如果无法选-是-无法正常退出游戏，那么请选择-否-强制退出'), PChar('选择退出方式'),
  MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1) of
  IDYES:
  begin
    cSay.rmsg := CM_SAY;
    str := '@GameExit';
    SetWordString(cSay.rWordString, str);
    cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
    Frmfbl.SocketAddData(cnt, @csay);
    SaveAllKey;
  end;// Add your code here
  IDNO:
  begin
      Shell_NotifyIcon(NIM_DELETE, @(FrmM.TrayIconData));
     ExitProcess(0);
     end;
end;

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
    frmGuild.Visible := not frmGuild.Visible;
    if frmGuild.Visible then
    begin
        FrmM.SetA2Form(frmGuild, frmGuild.A2form);
        FrmM.move_win_form_Align(frmGuild, mwfCenter);
    end;
end;

procedure TFrmBottom.btnQuestClick(Sender: TObject);
begin
    frmQuest.Visible := not frmQuest.Visible;
    if frmQuest.Visible then
    begin
        FrmM.SetA2Form(frmQuest, frmQuest.A2form);
        FrmM.move_win_form_Align(frmQuest, mwfCenter);
    end;
end;

procedure TFrmBottom.btnProcessionClick(Sender: TObject);
begin
    frmProcession.Visible := not frmProcession.Visible;
    if frmProcession.Visible then
    begin
        FrmM.SetA2Form(frmProcession, frmProcession.A2form);
        FrmM.move_win_form_Align(frmProcession, mwfCenter);
    end;

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
        // FrmM.move_win_form_Align(FrmWearItem, mwfRight);
    end;
end;

procedure TFrmBottom.FormShow(Sender: TObject);
begin
    //FrmEnergy.Visible := true;
    energyGraphicsclass.Visible := true;
end;


procedure TFrmBottom.Lbchat1MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if LbChatClickFlag then boShowChat := not boShowChat;
end;

procedure TFrmBottom.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBottom.btnCharAttribMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 属  性' + #13#10 + 'ALT+W');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.BtnMagicMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 武  功' + #13#10 + 'ALT+E');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnQuestMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 任  务' + #13#10 + 'ALT+R');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnProcessionMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 交  互' + #13#10 + 'ALT+T');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnGuildMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 门  派' + #13#10 + 'ALT+A');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.sbthailfellowMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 好  友' + #13#10 + 'ALT+S');
  //  A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.btnBillboardchartsMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 排行榜' + #13#10 + 'ALT+D');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.BtnExitMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 退  出' + #13#10 + 'ALT+X');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.Button_chooseChnClick(Sender: TObject);
begin
    FrmChat.ClientWidth := 52;
    FrmChat.ClientHeight := 114;
    FrmChat.Left := 148;
    FrmChat.Top := 453;
    FrmChat.Visible := not FrmChat.Visible;
    FrmM.SetA2Form(FrmChat, FrmChat.A2form);
end;

procedure TFrmBottom.ButtonWearMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 背  包' + #13#10 + 'ALT+Q');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.bitEmporiaMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 商  城' + #13#10 + 'ALT+G');
 //   A2Form.FA2Hint.FVisible := true;
end;

procedure TFrmBottom.BtnSelMagicMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), ' 设  置' + #13#10 + 'ALT+V');
//    GameHint.pos(x + BtnSelMagic.Left, y + BtnSelMagic.Top + (600 - self.Height));

end;

procedure TFrmBottom.lblShortcut0MouseLeave(Sender: TObject);
begin
    GameHint.Close;
end;

procedure TFrmBottom.lblShortcut0MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    p: pTKeyClassData;
    aitem: titemdata;
    aMagic: TMagicData;
    temp: Ta2ILabel;
begin
    //使用
    Temp := Ta2ILabel(Sender);
    if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
    begin
        if temp.A2Image <> nil then Temp.BeginDrag(TRUE);
        GameHint.Close;
        exit;
    end;

    p := cKeyClass.get(TA2ILabel(Sender).Tag);
    if p = nil then
    begin
        GameHint.Close;
        exit;
    end;
    if p.rboUser = false then
    begin
        GameHint.Close;
        exit;
    end;
    case p.rkeyType of
        kcdk_HaveItem:
            begin
                aitem := HaveItemclass.get(p.rkey);
                if aitem.rName <> '' then GameHint.setText(integer(Sender), TItemDataToStr(aitem))
                else GameHint.Close;
            end;
        kcdk_HaveMagic:
            begin
                aMagic := (HaveMagicClass.HaveMagic.get(p.rkey));
                if aMagic.rname <> '' then GameHint.setText(integer(Sender), TMagicDataToStr(aMagic))
                else GameHint.Close;
            end;
        kcdk_HaveRiseMagic:
            begin
                aMagic := (HaveMagicClass.HaveRiseMagic.get(p.rkey));
                if aMagic.rname <> '' then GameHint.setText(integer(Sender), TMagicDataToStr(aMagic))
                else GameHint.Close;
            end;
        kcdk_HaveMysteryMagic:
            begin
                aMagic := (HaveMagicClass.HaveMysteryMagic.get(p.rkey));
                if aMagic.rname <> '' then GameHint.setText(integer(Sender), TMagicDataToStr(aMagic))
                else GameHint.Close;
            end;
        kcdk_BasicMagic:
            begin
                aMagic := (HaveMagicClass.DefaultMagic.get(p.rkey));
                if aMagic.rname <> '' then
                    GameHint.setText(integer(Sender), TMagicDataToStr(aMagic))
                else GameHint.Close;
            end;
    end;

end;


procedure TFrmBottom.Lbchat4MouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TFrmBottom.N1Click(Sender: TObject);
begin
Clipboard.AsText := EdChat.Text;
end;

procedure TFrmBottom.N2Click(Sender: TObject);
begin
edChat.Clear;
end;


function deal(x:string):string;
begin
result:=Copy(x,1,Pos('(',x)-1);

end;
procedure TFrmBottom.N4Click(Sender: TObject);
begin
  EdChat.Text:=deal(N4.Caption)+' ';
    FrmBottom.EdChat.SelStart:=Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N5Click(Sender: TObject);
begin
  EdChat.Text:=deal(N5.Caption)+' ';
    FrmBottom.EdChat.SelStart:=Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N10Click(Sender: TObject);
begin
  EdChat.Text:=deal(N10.Caption)+' ';
    FrmBottom.EdChat.SelStart:=Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N9Click(Sender: TObject);
begin
  EdChat.Text:=deal(N9.Caption);
    FrmBottom.EdChat.SelStart:=Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N6Click(Sender: TObject);
begin
  EdChat.Text:=deal(N6.Caption);
    FrmBottom.EdChat.SelStart:=Length(FrmBottom.EdChat.Text);
end;



procedure TFrmBottom.N8Click(Sender: TObject);
begin
  EdChat.Text:=deal(N8.Caption);
    FrmBottom.EdChat.SelStart:=Length(FrmBottom.EdChat.Text);
end;

procedure TFrmBottom.N13Click(Sender: TObject);
begin
    frmHistory.Visible := not frmHistory.Visible;               //1
    if frmHistory.Visible then
    begin
        FrmM.SetA2Form(frmHistory, frmHistory.A2form);
    end;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmBottom.N12Click(Sender: TObject);
begin
      if map.GetMapWidth < 50 then exit;
      FrmMiniMap.Visible := not FrmMiniMap.Visible;
      if FrmMiniMap.Visible then
      begin
          FrmMiniMap.GETnpcList;
          FrmM.SetA2Form(FrmMiniMap, FrmMiniMap.A2form);
      end;
end;

procedure TFrmBottom.btnjsClick(Sender: TObject);
var
  key:Word;
begin
      key:=VK_RETURN;
  if frmAuction.Visible then frmAuction.Close ;
   FrmBottom.sendsay('@js', key);
end;

procedure TFrmBottom.btnyjClick(Sender: TObject);
var
  key:Word;
begin
      key:=VK_RETURN;
  if frmemail.Visible then frmemail.Close ;
   FrmBottom.sendsay('@yj', key);
end;

procedure TFrmBottom.btnckClick(Sender: TObject);
var
  key:Word;
begin
      key:=VK_RETURN;
  if FrmDepository.Visible then FrmDepository.Close;
  FrmBottom.sendsay('@ck', key);
end;

procedure TFrmBottom.btnjnClick(Sender: TObject);
begin
  if frmSkill.Visible then frmSkill.Close else
  begin
                  frmSkill.Visible := true;
                  frmSkill.send_Get_Job_blueprint_Menu;
                  FrmM.SetA2Form(frmSkill, frmSkill.A2form);
                  end;
end;

end.

