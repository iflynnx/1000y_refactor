unit FConfirmDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, A2Form, A2View, deftype, ExtCtrls, A2img, BaseUIForm;
type

  TfrmConfirmDialog = class(TfrmBaseUI)
    BtnOk: TA2Button;
    BtnCancel: TA2Button;
    a2edit_old: TA2Edit;
    lblText: TA2Label;
    A2Label1: TA2Label;
    Image1: TImage;
    A2Form: TA2Form;
    A2editimg: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure a2edit_oldKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);

  private
        { Private declarations } 
    a2edit: TA2ChatEdit;
    FMSGItemName:string;
    FMSGItemNameMaxCharCount:Integer;
    FHint1,FHint2:string;
  public
        { Public declarations }
    FSelectedChatItemData: TItemData;
    FSelectedChatItemPos: integer;
    FCurEdChatText: string;
    atype: TConfirmDialogtype;
    Fkey: integer;
    ausername: string;
    aid: integer; 
    procedure SetChatInfo;    
    procedure MessageProcess(var code: TWordComData);
    procedure EdChatKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure ShowFrom(atemp: TConfirmDialogtype; aCaption, atext: string);
    procedure closeFrom();
   // procedure SetOldVersion;
    procedure SetNewVersion(); override;


    //procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

implementation

uses FMain, Fbl, AUTIL32, FBottom, FGuild, filepgkclass, FAttrib,
  FCharAttrib, FNEWHailFellow;

{$R *.DFM}

procedure TfrmConfirmDialog.ShowFrom(atemp: TConfirmDialogtype; aCaption, atext: string);
begin
  A2Label1.Caption := aCaption;
  a2edit.Text := '';
  lblText.Caption := atext;
  Caption := atext;
  atype := atemp;
  case atype of
    cdDel_Designation:
      begin
        a2edit.Text := aCaption;
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
        FrmM.move_win_form_Align(Self, mwfCenter);

      end;
    cdtItemStirng:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtProcession_ADDMsg:
      begin
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
        FrmM.move_win_form_Align(Self, mwfCenter);
        exit;
      end;
    cdtShowInputOk:
      begin
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
        FrmM.move_win_form_Align(Self, mwfCenter);
        exit;
      end;
    cdtShowInputString2:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
        FrmM.move_win_form_Align(Self, mwfCenter);
        exit;
      end;
      //好友删除
    cdtHailFellowDel:
      begin

        ausername := aCaption;
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtGuilGradeNameUPdate:
      begin
        ausername := atext;
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtguildSysdel_SubSysop:
      begin
        a2edit.Text := aCaption;
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtGuildSetSys:
      begin
        a2edit.Text := aCaption;
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtGuildelevate:
      begin
        a2edit.Text := aCaption;
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtGuildDel_Force:
      begin
        a2edit.Text := aCaption;
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtguildSubSysopdel:
      begin
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtGuildDel:
      begin

        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtGuilnoticeUPdate:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtguild_createName:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtProcession_ADD:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
      //添加门派成员
    cdtGuildAdd:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    cdtguild_addMsg, cdtguild_addALLYMsg:
      begin
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
        FrmM.move_win_form_Align(Self, mwfCenter);
        exit;
      end;
      //好友添加消息提示
    cdtHailFellow:
      begin

        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
        FrmM.move_win_form_Align(Self, mwfCenter);
        exit;
      end;
    cdtSetGuildMagicToUser:
      begin
        a2edit.Text := aCaption;
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
      //添加好友
    cdtAddHailFellow:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
      //NPC消息触发
    cdtNpcShow:
      begin
        lblText.Visible := false;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;
    //销毁道具
    cdtItemDel:   
      begin
        lblText.Visible := true;
        a2edit.Visible := not lblText.Visible;
        A2Label1.Visible := a2edit.Visible;
        A2editimg.Visible := a2edit.Visible;
      end;

  else
    begin
      closeFrom;
      exit;
    end;

  end;
  Visible := true;
    //    FrmM.SetA2Form(Self, A2form);
  FrmM.move_win_form_Align(Self, mwfCenter);
  frmm.SetA2Form(Self, A2Form);
  if a2edit.Visible then
  begin
    SetFocus;
    a2edit.SetFocus;
  end;
end;

procedure TfrmConfirmDialog.closeFrom();
begin
  Visible := false;
    // FrmM.DelA2Form(Self, A2form);
  Close;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TfrmConfirmDialog.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  pSHailFellowbasic: pTSHailFellowbasic;
  sname, str: string;
  id, akey: integer;
begin
  pckey := @Code.Data;
  case pckey^.rmsg of
    SM_Procession:
      begin
        id := 1;
        akey := WordComData_GETbyte(code, id);
        if akey = Procession_ADDMsg then
        begin

          ausername := WordComData_GETstring(code, id);
          ShowFrom(cdtProcession_ADDMsg, '', format('【%s】邀请你入队。', [ausername]));
        end;
      end;
    SM_HailFellow:
      begin
        pSHailFellowbasic := @Code.Data;

        sname := (pSHailFellowbasic.rName);
        case pSHailFellowbasic.rkey of
          HailFellow_Message_ADD: //有人 要加我
            begin
                            //  Visible := true;
              ausername := sname;
              ShowFrom(cdtHailFellow, '', format('【%s】请求添加你为好友!', [sname]));
            end;

        end;

      end;
    SM_GUILD:
      begin

        id := 1;
        akey := WordComData_GETbyte(code, id);
        case akey of
          GUILD_list_addMsg: //被 人 加 是否同意
            begin
              ausername := WordComData_GETstring(code, id);
              sname := WordComData_GETstring(code, id);
              ShowFrom(cdtguild_addMsg, '', format('%s 邀请你加入【%s】门派!', [sname, ausername]));
            end;
          GUILD_list_addALLYMsg: //邀请同盟询问
            begin
              ausername := WordComData_GETstring(code, id);//被请求 门派
              sname := WordComData_GETstring(code, id);  //请求 门派
              ShowFrom(cdtguild_addALLYMsg, '', format('【%s】门派邀请与您同盟!', [sname]));
            end;
                    {  GUILD_Create_name:
                          begin
                              aid := WordComData_GETbyte(code, id);
                              ShowFrom(cdtguild_addMsg, '', '输入创建门派的名字。');

                          end;}
        end;
      end;
    SM_InputOk:  //可能是交易
      begin
        id := 1;
        akey := WordComData_GETbyte(code, id);
        aid := WordComData_GETdword(code, id);
        str := WordComData_GETstring(code, id);
        ShowFrom(cdtShowInputOk, '', str);
        Fkey := akey;
      end;
    SM_SHOWINPUTSTRING2:
      begin
        id := 1;
        akey := WordComData_GETbyte(code, id);
        aid := WordComData_GETdword(code, id);
        str := WordComData_GETstring(code, id);
        ShowFrom(cdtShowInputString2, str, '');
        Fkey := akey;
      end;

  end;
end;

procedure TfrmConfirmDialog.SetNewVersion;

begin
  inherited;
end;

//procedure TfrmConfirmDialog.SetOldVersion;
//begin
//  A2Form.FImageSurface.LoadFromBitmap(Image1.Picture.Bitmap);
//  A2Form.boImagesurface := true;
//end;

procedure TfrmConfirmDialog.FormCreate(Sender: TObject);
begin
  inherited;
    //Parent := FrmM;
  FTestPos := True;
  FrmM.AddA2Form(Self, A2Form);
  Left := 0;
  Top := 0;
  a2edit := TA2ChatEdit.Create(self);

  a2edit.Parent := self;
  a2edit.Width := 20;
  a2edit.Height := 20;
  a2edit.ADXForm := self.A2form;
  a2edit.Name := 'a2edit';
  a2edit.Text := '';
  a2edit.MaxLength := 150;
  a2edit.AutoSize := false;
  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;
end;

procedure TfrmConfirmDialog.BtnOkClick(Sender: TObject);
var
  tt: TSHailFellowbasic;
  cnt: integer;
  cSay: TCSay;
  CGuild: TCGuild;
  STR: string;
  tempsend: TWordComData;
          
  aSayItem: TCSayItem;
  tempitem: TItemData;
  b:Boolean;
begin
  a2edit.Text := trim(a2edit.Text);
  case atype of
    cdDel_Designation:
      begin
        str := a2edit.Text;
        frmCharAttrib.send_Del_Designation(STR);
        closeFrom;
      end;
    cdtItemStirng:
      begin
        //str := a2edit.Text;
        //FrmAttrib.sendDblClickItemString(Fkey, STR);
        //closeFrom;
          b:=False;
           str := a2edit.Text;
          tempitem := HaveItemclass.get(Fkey);
          if FMSGItemName = tempitem.rName then
          begin
             if not self.a2edit.HaveChatItem then
             begin
               if Length(str)>  FMSGItemNameMaxCharCount then
                 b:=True;
             end else
             begin
               if (Length(self.FSelectedChatItemData.rName+str)+2) >FMSGItemNameMaxCharCount then
                 b:=True;
             end;  
             if b then
             begin
                FrmBottom.AddChat( fhint1+inttostr(FMSGItemNameMaxCharCount)+fhint2, WinRGB(255, 255, 0), 0);
               Exit;
             end;  

          end;  

        if not self.a2edit.HaveChatItem then
          FrmAttrib.sendDblClickItemString(Fkey, STR)
        else
        begin


          aSayItem.rmsg := CM_SAYITEM;
          aSayItem.rtype := 2;

          aSayItem.rpos := FSelectedChatItemPos;
          copymemory(@aSayItem.rChatItemData, @self.FSelectedChatItemData, sizeof(TItemData));

          SetWordString(aSayItem.rWordString, str);

          FrmAttrib.sendDblClickItemStringEx(Fkey, STR, aSayItem);
        end;

        closeFrom;
      end;
    cdtProcession_ADD:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Procession);
        WordComData_ADDbyte(tempsend, Procession_ADDMsg);
        str := a2edit.Text;
        WordComData_ADDstring(tempsend, str);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;

    cdtProcession_ADDMsg:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Procession);
        WordComData_ADDbyte(tempsend, Procession_ADDMsgOk);
        WordComData_ADDstring(tempsend, ausername);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtHailFellowDel:
      begin
        tt.rmsg := CM_HailFellow;
        //tt.rKEY := HailFellow_DEL;   
        tt.rKEY := HailFellow_MYSQLDEL;
        str := ausername;
        TT.rName := STR;
        cnt := sizeof(TT);
        Frmfbl.SocketAddData(cnt, @TT);
        closeFrom;
      end;
    cdtguild_createName:
      begin
                {cSay.rmsg := CM_SAY;
                str := a2edit.Text;
                str := format('%s门派创建', [str]);
                SetWordString(cSay.rWordString, str);
                cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
                Frmfbl.SocketAddData(cnt, @csay);}
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Guild);
        WordComData_ADDbyte(tempsend, GUILD_Create_name);
        WordComData_ADDbyte(tempsend, byte(aid));
        str := (a2edit.Text);
        WordComData_ADDstring(tempsend, str);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtguildSubSysopdel:
      begin
        frmGuild.sendGUILD_del_SubSysop_ic();
        closeFrom;
      end;

    cdtGuilnoticeUPdate:
      begin
        CGuild.rmsg := CM_Guild;
        CGuild.rkey := GUILD_noticeUPdate;
        str := trim(a2edit.Text);
        if str = '' then
        begin
          closeFrom;
          exit;
        end;
        SetWordString(CGuild.rWordString, str);
        cnt := sizeof(CGuild) - sizeof(TWordString) + SizeOfWordString(CGuild.rWordString);
        Frmfbl.SocketAddData(cnt, @CGuild);
        closeFrom;
      end;
    cdtGuildDel:
      begin
        frmGuild.sendGuilddel_ic();
        closeFrom;
      end;
    cdtguildSysdel_SubSysop:
      begin
        frmGuild.sendGUILD_del_SubSysop(a2edit.Text);
        closeFrom;
      end;
    cdtGuildSetSys:
      begin
        frmGuild.sendGUILD_set_Sysop(a2edit.Text);
        closeFrom;
      end;
    cdtGuildelevate:
      begin
        frmGuild.sendGUILD_set_SubSysop(a2edit.Text);
        closeFrom;
      end;
    cdtGuildDel_Force:
      begin
        frmGuild.sendGuilddel(a2edit.Text);
        closeFrom;
      end;
    cdtGuilGradeNameUPdate:
      begin
        frmGuild.sendGuilGradeNameUPdate(ausername, a2edit.Text);
        closeFrom;
      end;
      //添加门派成员
    cdtGuildAdd:
      begin
        frmGuild.sendGuildAdd(a2edit.Text);
        closeFrom;
      end;
    cdtguild_addMsg:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Guild);
        WordComData_ADDbyte(tempsend, GUILD_list_addMsgOk);
        WordComData_ADDstring(tempsend, ausername);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;    
    cdtguild_addALLYMsg:   //接受同盟请求
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Guild);
        WordComData_ADDbyte(tempsend, GUILD_list_addALLYMsgOk);
        WordComData_ADDstring(tempsend, ausername);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;

    cdtShowInputOk:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, cm_InputOk);
        WordComData_ADDbyte(tempsend, byte(fkey));
        WordComData_ADDdword(tempsend, aid);
        WordComData_ADDbyte(tempsend, byte(true));
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtShowInputString2:
      begin
        str := a2edit.Text;
        if str = '' then exit;
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_INPUTSTRING2);
        WordComData_ADDbyte(tempsend, byte(fkey));
        WordComData_ADDdword(tempsend, aid);
        WordComData_ADDbyte(tempsend, byte(true));
        WordComData_ADDstring(tempsend, str);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtHailFellow:
      begin
        tt.rmsg := CM_HailFellow;
        tt.rKEY := HailFellow_Message_ADD_OK;
        TT.rName := ausername;
        cnt := sizeof(TT);
        Frmfbl.SocketAddData(cnt, @TT);
        closeFrom;
      end;
    cdtSetGuildMagicToUser:
      begin
        cSay.rmsg := CM_SAY;
        SetWordString(cSay.rWordString, '@传授武功 ' + a2edit.Text);
        cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
        Frmfbl.SocketAddData(cnt, @csay);
        closeFrom;
      end;
    cdtNone: ;
      //添加好友
    cdtAddHailFellow:
      begin
        FrmHailFellow.sendHailFellowAdd(a2edit.Text);
        closeFrom;
      end;
  
      //NPC消息触发
    cdtNpcShow:
      begin           
        str := a2edit.Text;
        if str = '' then exit;
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_NPCDIALOGSHOW);
        WordComData_ADDdword(tempsend, aid);

        WordComData_ADDbyte(tempsend, byte(fkey));
        WordComData_ADDstring(tempsend, str);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;

      end;
      //销毁道具  
    cdtItemDel:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_ITEMDEL);
        WordComData_ADDbyte(tempsend, byte(fkey));
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;

  end;

end;

procedure TfrmConfirmDialog.BtnCancelClick(Sender: TObject);
var
  tt: TSHailFellowbasic;
  cnt: integer;
  tempsend: TWordComData;
begin
  case atype of

    cdtProcession_ADDMsg:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Procession);
        WordComData_ADDbyte(tempsend, Procession_ADDMsgNO);
        WordComData_ADDstring(tempsend, ausername);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtguild_addMsg:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Guild);
        WordComData_ADDbyte(tempsend, GUILD_list_addMsgno);
        WordComData_ADDstring(tempsend, ausername);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;  
    cdtguild_addALLYMsg:   //拒绝同盟请求
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_Guild);
        WordComData_ADDbyte(tempsend, GUILD_list_addALLYMsgNo);
        WordComData_ADDstring(tempsend, ausername);
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtShowInputOk:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_InputOk);
        WordComData_ADDbyte(tempsend, byte(fkey));
        WordComData_ADDdword(tempsend, aid);
        WordComData_ADDbyte(tempsend, byte(false));
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtShowInputString2:
      begin
        tempsend.Size := 0;
        WordComData_ADDbyte(tempsend, CM_INPUTSTRING2);
        WordComData_ADDbyte(tempsend, byte(fkey));
        WordComData_ADDdword(tempsend, aid);
        WordComData_ADDbyte(tempsend, byte(false));
        Frmfbl.SocketAddData(tempsend.Size, @tempsend.data);
        closeFrom;
      end;
    cdtHailFellow:
      begin
        tt.rmsg := CM_HailFellow;
        tt.rKEY := HailFellow_Message_ADD_NO;
        TT.rName := ausername;
        cnt := sizeof(TT);
        Frmfbl.SocketAddData(cnt, @TT);
        closeFrom;
      end;
    cdtNone: closeFrom;
    cdtGuildAdd: closeFrom;
  else closeFrom;
  end;

end;

procedure TfrmConfirmDialog.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    // if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
end;

procedure TfrmConfirmDialog.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);

    //a2edit.SetFocus;
end;

procedure TfrmConfirmDialog.SetConfigFileName;
begin
  inherited;
  self.FConfigFileName := 'ConfirmDialog.xml';
end;

//procedure TfrmConfirmDialog.SetNewVersionOld;
//var
//  temping: TA2Image;
//begin
//  temping := TA2Image.Create(32, 32, 0, 0);
//  try
//    pgkBmp.getBmp('添加队友好友窗口.bmp', A2Form.FImageSurface);
//    A2Form.boImagesurface := true;
//
//    pgkBmp.getBmp('通用_确认_按下.bmp', temping);
//    BtnOk.A2Down := temping;
//    pgkBmp.getBmp('通用_确认_弹起.bmp', temping);
//    BtnOk.A2Up := temping;
//    pgkBmp.getBmp('通用_确认_鼠标.bmp', temping);
//    BtnOk.A2Mouse := temping;
//    pgkBmp.getBmp('通用_确认_禁止.bmp', temping);
//    BtnOk.A2NotEnabled := temping;
//    BtnOk.Left := 118;
//    BtnOk.Top := 68;
//    BtnOk.Width := temping.Width;
//    BtnOk.Height := temping.Height;
//
//    pgkBmp.getBmp('通用_取消_按下.bmp', temping);
//    BtnCancel.A2Down := temping;
//    pgkBmp.getBmp('通用_取消_弹起.bmp', temping);
//    BtnCancel.A2Up := temping;
//    pgkBmp.getBmp('通用_取消_鼠标.bmp', temping);
//    BtnCancel.A2Mouse := temping;
//    pgkBmp.getBmp('通用_取消_禁止.bmp', temping);
//    BtnCancel.A2NotEnabled := temping;
//    BtnCancel.Left := 174;
//    BtnCancel.Top := 68;
//    BtnCancel.Width := temping.Width;
//    BtnCancel.Height := temping.Height;
//
//    a2edit.Left := 22;
//    a2edit.Top := 36 + 5 + 4;
//    a2edit.Width := 206;
//    a2edit.Height := 25;
//
//    lblText.Left := 22;
//    lblText.Top := 36 + 5 + 4;
//    lblText.Width := 206;
//    lblText.Height := 25;
//    lblText.FontColor := ColorSysToDxColor($080808);
//
//
//  finally
//    temping.Free;
//  end;
//
//end;

procedure TfrmConfirmDialog.SetNewVersionTest;
begin
  inherited;

  self.FormName := 'frmConfirmDialog';
  SetControlPos(Self);
  self.FormName := '';
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;
  SetControlPos(BtnOk);
  SetControlPos(BtnCancel);
  SetControlPos(a2edit);
  SetControlPos(A2Label1);

  SetControlPos(lblText);
  SetControlPos(A2editimg);

  lblText.FontColor := ColorSysToDxColor(clWhite);
end;

procedure TfrmConfirmDialog.settransparent(transparent: Boolean);
begin
  inherited;
  Self.A2Form.TransParent := transparent;
end;

procedure TfrmConfirmDialog.a2edit_oldKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//    if ssAlt in Shift then
//  begin
//    case Key of
//      word('P'), word('p'):
//        begin
//
//          SetNewVersion;
//        end;
//      word('O'), word('o'):
//        begin
//          self.SetTestPos(not self.GetTestPos);
//          SetNewVersion;
//        end;
//    end;
//  end;
end;

procedure TfrmConfirmDialog.FormDestroy(Sender: TObject);
begin
  inherited;
  a2edit.Free;
end;

procedure TfrmConfirmDialog.SetChatInfo;
var
  k: word;
begin
  if (self.FSelectedChatItemData.rViewName = '') then
  begin
    a2edit.HaveChatItem := false;

  end
  else
  begin
    a2edit.ChatItemName := self.FSelectedChatItemData.rViewName;
    a2edit.HaveChatItem := true;

    begin
      if a2edit.SelectedChatItemPos = -1 then
        a2edit.SelectedChatItemPos := length(self.a2edit.Text) + 1;
      self.FSelectedChatItemPos := length(self.a2edit.Text) + 1 - length(FCurEdChatText);
    end;
   // sendsayitem(EdChat.Text, k);
  end;
end;

procedure TfrmConfirmDialog.EdChatKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) or (key = VK_ESCAPE) then
  begin
    FCurEdChatText := a2edit.Text;
  end;
end;

end.

