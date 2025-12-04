unit Fperson;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    deftype, StdCtrls, A2Form, ExtCtrls, Autil32, A2Img, CharCls,Clipbrd, ShellAPI,
  Menus, Gauges, Buttons,
    uAnsTick, DXDraws,    Cltype, ctable, log, Acibfile, clmap,
    AtzCls, uPerSonBat ;
type
    Tfrmperson = class(TForm)
        A2Form: TA2Form;
    UseMagic4: TA2Label;
    UseMagic3: TA2Label;
    UseMagic2: TA2Label;
    UseMagic1: TA2Label;
    PGSkillLevel2: TA2Gauge;
    PGSkillLevel1: TA2Gauge;
    PgOutPower: TA2Gauge;
    PgMagic: TA2Gauge;
    PgLife: TA2Gauge;
    PGLeg: TA2Gauge;
    PGInPower: TA2Gauge;
    PgHead: TA2Gauge;
    PGEnergy: TGauge;
    PGArm: TA2Gauge;
    LbEvent: TA2Label;
        procedure FormCreate(Sender: TObject);
          procedure FormDestroy(Sender: TObject);
          procedure PgHeadMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure PGArmMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure PGLegMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure PGInPowerMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure PgOutPowerMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure PgMagicMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure PgLifeMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
              procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
  
       private
        { Private declarations }

    public
      //  shortcutkey: array[0..7] of byte;                                       //c  +1-8
        shortcutLabels: array[0..7] of TA2ILabel;

        UseMagicArr: array[0..3] of TA2Label;
        ALLKeyDownTick: DWORD;
        printKeyDownTick: DWORD;
        SendChatList: tstringlist;                                              //发送 消息 历史记录
        SendChatListItemIndex: integer;
        SendMsayList: tstringlist;                                              //纸条 消息 纪录
        SendMsayListItemIndex: integer;
        { Public declarations }
        curlife, maxlife: integer;
        temping: TA2Image;
          procedure SetFormText;

        procedure PGSkillLevelSET(aSkillLevel: integer);
          procedure ONLeg(value_max, value: integer);
        procedure ONArm(value_max, value: integer);
        procedure ONHead(value_max, value: integer);

          procedure SetNewVersion();
         

    end;

var
    frmperson: Tfrmperson;
 

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
    FBooth, Unit_console, FSkill, FNPCTrade, FBottom;

{$R *.DFM}



procedure Tfrmperson.ONLeg(value_max, value: integer);
begin
    PgLeg.Progress := value_max * 10000 div value;
end;

procedure Tfrmperson.ONArm(value_max, value: integer);
begin
    PgArm.Progress := value_max * 10000 div value;
end;

procedure Tfrmperson.ONHead(value_max, value: integer);
begin
    PgHead.Progress := value_max * 10000 div value;
end;



procedure Tfrmperson.SetFormText;
begin
    // FrmBottom Set Font
    FrmBottom.Font.Name := mainFont;
    // ListboxUsedMagic.Font.Name := mainFont;
   // LbChat.Font.Name := mainFont;
  //  EdChat.Font.Name := mainFont;
        //包裹 角色 武功 任务 玩家互动(综合窗口) 门派 好友 排行 退出

    PgHead.Hint := ('头');
    PGArm.Hint := ('手臂');
    PGLeg.Hint := ('腿');


    //闪动框
   { LbEvent.Left := 166;
    LbEvent.Top := 16;   }
    LbEvent.Width := 57;
    LbEvent.Height := 10;
end;

procedure Tfrmperson.FormCreate(Sender: TObject);
begin

   //  Parent := FrmM;
    FrmM.AddA2Form(Self, A2form);

 //    Visible:=False;

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

    ClientWidth := 300;
    ClientHeight := 200;

    SendMsayList := tstringlist.Create;
    editset := nil;
    //2009 3 23 增加
   if WinVerType = wvtnew then
    begin
        SetnewVersion ;
    end;

    ALLKeyDownTick := 0;
    //pplication.HookMainWindow(AppKeyDownHook);
    Color := clBlack;

    Left := 0;

  if fhei=768 then
  begin
   Top := 655 ;

   end
   else
   begin
   top:=485;
   left:=513;
   end;
    SetFormText;
    MapName := '';
    SaveChatList := TStringList.Create;
    SendChatList := tstringlist.Create;
    SendChatListItemIndex := -1;
    move_win_form := nil;

  
    UseMagicArr[0] := Frmperson.UseMagic1;
    UseMagicArr[1] := Frmperson.UseMagic2;
    UseMagicArr[2] := Frmperson.UseMagic3;
    UseMagicArr[3] := Frmperson.UseMagic4;


end;


procedure Tfrmperson.FormDestroy(Sender: TObject);
begin
    //application.UnhookMainWindow(AppKeyDownHook);
  // temping.Free;

end;

procedure Tfrmperson.PGSkillLevelSET(aSkillLevel: integer);
var
    lv1, lv2: integer;
begin
    lv1 := aSkillLevel mod 100;
    lv2 := aSkillLevel div 100;
    lv2 := lv2 mod 10;
    PGSkillLevel1.Progress := lv1;
    PGSkillLevel2.Progress := lv2;

end;

procedure Tfrmperson.PgHeadMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin

    GameHint.setText(integer(Sender), '头' + Get10000To100(PgHead.Progress) + '/' + Get10000To100(PgHead.MaxValue));
end;

procedure Tfrmperson.PGArmMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    GameHint.setText(integer(Sender), '手肩' + Get10000To100(PGArm.Progress) + '/' + Get10000To100(PGArm.MaxValue));
end;

procedure Tfrmperson.PGLegMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    GameHint.setText(integer(Sender), '腿' + Get10000To100(PGLeg.Progress) + '/' + Get10000To100(PGLeg.MaxValue));

end;
 
procedure Tfrmperson.PGInPowerMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), '内功' + Get10000To100(PGInPower.Progress) + '/' + Get10000To100(PGInPower.MaxValue));
end;

procedure Tfrmperson.PgOutPowerMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), '外功' + Get10000To100(PgOutPower.Progress) + '/' + Get10000To100(PgOutPower.MaxValue));
end;

procedure Tfrmperson.PgMagicMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.setText(integer(Sender), '武功' + Get10000To100(PgMagic.Progress) + '/' + Get10000To100(PgMagic.MaxValue));
end;

procedure Tfrmperson.PgLifeMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.setText(integer(Sender), '活力' + Get10000To100(PgLife.Progress) + '/' + Get10000To100(PgLife.MaxValue));
end;
procedure Tfrmperson.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    GameHint.Close;
end;


procedure Tfrmperson.Button1Click(Sender: TObject);
begin
frmperson.WindowState:=wsMinimized;
end;


procedure Tfrmperson.FormClick(Sender: TObject);
begin
  if fwide=800 then
  begin
  if frmperson.Left=513 then
  begin
   frmperson.Left:=-275 ;
  //A2Form.FImageSurface.LoadFromFile(ExtractFilePath(ParamStr(0))+'bmp\上半部分显示.bmp');
    pgkBmp_n.getBmp('上半部分显示.bmp', A2form.FImageSurface);
   end else
   begin
   frmperson.Left:=513;
  // A2Form.FImageSurface.LoadFromFile(ExtractFilePath(ParamStr(0))+'bmp\上半部分隐藏.bmp');
    pgkBmp_n.getBmp('上半部分隐藏.bmp', A2form.FImageSurface);
   end;
  end
  else
  begin
if frmperson.Left=0 then
begin
 frmperson.Left:=-275 ;
//A2Form.FImageSurface.LoadFromFile(ExtractFilePath(ParamStr(0))+'bmp\上半部分显示.bmp');
  pgkBmp_n.getBmp('上半部分显示.bmp', A2form.FImageSurface);
 end else
 begin
 frmperson.Left:=0;
// A2Form.FImageSurface.LoadFromFile(ExtractFilePath(ParamStr(0))+'bmp\上半部分隐藏.bmp');
  pgkBmp_n.getBmp('上半部分隐藏.bmp', A2form.FImageSurface);
 end;
 end;
end;

procedure Tfrmperson.SetNewVersion();
begin
 //  A2Form.FImageSurface.LoadFromFile(ExtractFilePath(ParamStr(0))+'bmp\上半部分隐藏.bmp');
      pgkBmp_n.getBmp('上半部分隐藏.bmp', A2form.FImageSurface);
     A2form.boImagesurface := true;


end;
end.

