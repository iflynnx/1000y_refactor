unit FGameToolsNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, ExtCtrls, a2img, StdCtrls, DateUtils, Mask, ComCtrls,
  BaseUIForm, uIniFile, SubUtil, uKeyClass, fbl, cAIPath;

type
  Twgitemdata = record
    aItemName: string[64];
    aRace: byte;
    aId, ax, ay, aItemShape, aItemColor: integer;
    runtime: tdatetime;
  end;

  pTwgitemdata = ^Twgitemdata;

  Twg_ItemList = class
  private
  public
    data: tlist;
    constructor Create;
    destructor Destroy; override;
    procedure add(aitem: Twgitemdata);
    procedure Clear;
    procedure del(aid: integer);
    procedure add2(aItemName: string; aRace: byte; aId, ax, ay, aItemShape, aItemColor: integer);
  end;

  //列表控制
  TListConsoledata = record
    rname: string[64];
    rAddTime: integer;
    rEndTime: integer;
  end;

  pTListConsoledata = ^TListConsoledata;

  TListConsole = class
  private
    fdata: tlist;
  public
    constructor Create;
    destructor Destroy; override;
    function getcount(): integer;
    procedure add(aname: string; atime: integer);
    procedure clear;
    procedure update(curtcik: integer);
  end;

  TFrmGameToolsNew = class(TfrmBaseUI)
    A2Form: TA2Form;
    A2Panel_eatblood: TA2Panel;
    A2Panel_pick: TA2Panel;
    A2Panel_shout: TA2Panel;
    A2Panel_walk: TA2Panel;
    A2Panel_attack: TA2Panel;
    A2Panel_ShouName: TA2Panel;
    A2ILabel_BackEat: TA2ILabel;
    A2ILabel_walk: TA2ILabel;
    A2ILabel_shout: TA2ILabel;
    A2ILabel_attack: TA2ILabel;
    A2ILabel_show: TA2ILabel;
    A2ILabel_pick: TA2ILabel;
    A2CheckBox_inPower: TA2CheckBox;
    A2CheckBox_outPower: TA2CheckBox;
    A2CheckBox_Magic: TA2CheckBox;
    A2CheckBox_Life: TA2CheckBox;
    A2Edit_inPower: TA2Edit;
    A2Edit_outPower: TA2Edit;
    A2Edit_Magic: TA2Edit;
    A2Edit_Life: TA2Edit;
    A2Edit_delayTimeEat: TA2Edit;
    A2ComboBox_inPower: TA2ComboBox;
    A2Button1: TA2Button;
    A2Button2: TA2Button;
    A2Button3: TA2Button;
    A2Button4: TA2Button;
    A2Button5: TA2Button;
    A2Button6: TA2Button;
    A2Button7: TA2Button;
    A2Button8: TA2Button;
    A2Button9: TA2Button;
    A2Button10: TA2Button;
    A2ComboBox_outPower: TA2ComboBox;
    A2ComboBox_Magic: TA2ComboBox;
    A2ComboBox_Life: TA2ComboBox;
    A2CheckBox_Hit_not_Shift: TA2CheckBox;
    A2CheckBox_Hit_not_Ctrl: TA2CheckBox;
    A2CheckBox_autoHIt: TA2CheckBox;
    A2CheckBox_Pick: TA2CheckBox;
    A2CheckBox_Opposite: TA2CheckBox;
    A2Button_Add: TA2Button;
    A2Button_Dec: TA2Button;
    A2ListBox_Itemlist: TA2ListBox;
    A2Edit6: TA2Edit;
    A2CheckBox_MoveOpenMagic: TA2CheckBox;
    A2CheckBox11: TA2CheckBox;
    A2Edit7: TA2Edit;
    A2Edit8: TA2Edit;
    A2Edit9: TA2Edit;
    A2Edit10: TA2Edit;
    A2Button13: TA2Button;
    A2Button14: TA2Button;
    A2Button15: TA2Button;
    A2Button16: TA2Button;
    A2Button17: TA2Button;
    A2Button18: TA2Button;
    A2Button19: TA2Button;
    A2Button20: TA2Button;
    A2ListBox_ShoutList: TA2ListBox;
    A2CheckBox12: TA2CheckBox;
    A2Edit11: TA2Edit;
    A2Button21: TA2Button;
    A2Button22: TA2Button;
    A2CheckBox_ShowAllName: TA2CheckBox;
    A2CheckBox_ShowMonster: TA2CheckBox;
    A2CheckBox_ShowNpc: TA2CheckBox;
    A2CheckBox_ShowPlayer1: TA2CheckBox;
    A2CheckBox_ShowItem: TA2CheckBox;
    A2ILabel_top: TA2ILabel;
    A2ILabel_bottom: TA2ILabel;
    A2ILabel_button: TA2ILabel;
    A2Button_Eat: TA2Button;
    A2Button_Pick: TA2Button;
    A2Button_Shout: TA2Button;
    A2Button_Walk: TA2Button;
    A2Button_Attack: TA2Button;
    A2Button_Show: TA2Button;
    A2Button_Close: TA2Button;
    A2Button_Read: TA2Button;
    A2Button_Save: TA2Button;
    Timer1: TTimer;
    A2Edit_AddShout: TA2Edit;
    A2Button_AddShout: TA2Button;
    A2Button_DelShout: TA2Button;
    A2ComboBox_ChangeMoveMagic: TA2ComboBox;
    A2ComboBox1: TA2ComboBox;
    A2Edit1: TA2Edit;
    A2Button11: TA2Button;
    A2Button12: TA2Button;
    A2CheckBox1: TA2CheckBox;
    A2CheckBox_ProtectMagic: TA2CheckBox;
    A2ComboBox_ProtectMagic: TA2ComboBox;
    A2CheckBoxThreePower: TA2CheckBox;
    A2ListBox_DropItemlist: TA2ListBox;
    A2CheckBox_MonsterHit: TA2CheckBox;
    A2ComboBox_MonsterList: TA2ComboBox;
    A2CheckBox_CounterAttack: TA2CheckBox;
    A2CheckBox_BossKey: TA2CheckBox;
    A2Edit_BossKey: TA2Edit;
    A2CheckBox_CounterAttackUser: TA2CheckBox;
    A2CheckBox_QieHuan: TA2CheckBox;
    A2CheckBox_CL: TA2CheckBox;
    A2ComboBox_CLWG: TA2ComboBox;
    A2Label_AddQieHuan: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2Button_EatClick(Sender: TObject);
    procedure A2Button_PickClick(Sender: TObject);
    procedure A2Button_ShoutClick(Sender: TObject);
    procedure A2Button_WalkClick(Sender: TObject);
    procedure A2Button_AttackClick(Sender: TObject);
    procedure A2Button_ShowClick(Sender: TObject);
    procedure A2Button_CloseClick(Sender: TObject);
    procedure A2Button1Click(Sender: TObject);
    procedure A2Button2Click(Sender: TObject);
    procedure A2Button3Click(Sender: TObject);
    procedure A2Button4Click(Sender: TObject);
    procedure A2Button5Click(Sender: TObject);
    procedure A2Button6Click(Sender: TObject);
    procedure A2Button8Click(Sender: TObject);
    procedure A2Button9Click(Sender: TObject);
    procedure A2Button10Click(Sender: TObject);
    procedure A2Button13Click(Sender: TObject);
    procedure A2Button14Click(Sender: TObject);
    procedure A2Button16Click(Sender: TObject);
    procedure A2Button15Click(Sender: TObject);
    procedure A2Button17Click(Sender: TObject);
    procedure A2Button18Click(Sender: TObject);
    procedure A2Button19Click(Sender: TObject);
    procedure A2Button20Click(Sender: TObject);
    procedure A2Button_AddClick(Sender: TObject);
    procedure A2Button_DecClick(Sender: TObject);
    procedure A2Button21Click(Sender: TObject);
    procedure A2Button22Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2Button_ReadClick(Sender: TObject);
    procedure A2Button_SaveClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure A2Edit_inPowerChange(Sender: TObject);
    procedure A2Button_AddShoutClick(Sender: TObject);
    procedure A2Button_DelShoutClick(Sender: TObject);
    procedure A2Button7Click(Sender: TObject);
    procedure A2Edit11Change(Sender: TObject);
    procedure A2Edit_outPowerChange(Sender: TObject);
    procedure A2Edit_MagicChange(Sender: TObject);
    procedure A2Edit_LifeChange(Sender: TObject);
    procedure A2Edit_delayTimeEatChange(Sender: TObject);
    procedure A2Edit7Change(Sender: TObject);
    procedure A2Edit8Change(Sender: TObject);
    procedure A2Edit9Change(Sender: TObject);
    procedure A2Edit10Change(Sender: TObject);
    procedure A2Edit_inPowerKeyPress(Sender: TObject; var Key: Char);
    procedure A2CheckBox_ShowAllNameClick(Sender: TObject);
    procedure A2ComboBox_inPowerDropDown(Sender: TObject);
    procedure A2ComboBox_ChangeMoveMagicDropDown(Sender: TObject);
    procedure A2ILabel_BackEatMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel_walkMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel_shoutMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel_pickMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel_attackMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure A2ILabel_showMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure A2Button11Click(Sender: TObject);
    procedure A2Button12Click(Sender: TObject);
    procedure A2Edit1Change(Sender: TObject);
    procedure A2CheckBox_autoHItClick(Sender: TObject);
    procedure A2CheckBox_Hit_not_CtrlClick(Sender: TObject);
    procedure A2CheckBox_Hit_not_ShiftClick(Sender: TObject);
    procedure A2CheckBox_inPowerClick(Sender: TObject);
    procedure A2CheckBox_LifeClick(Sender: TObject);
    procedure A2CheckBox_MagicClick(Sender: TObject);
    procedure A2CheckBox_outPowerClick(Sender: TObject);
    procedure A2CheckBox1Click(Sender: TObject);
    procedure A2ComboBox_inPowerChange(Sender: TObject);
    procedure A2ComboBox_LifeChange(Sender: TObject);
    procedure A2ComboBox_MagicChange(Sender: TObject);
    procedure A2ComboBox_outPowerChange(Sender: TObject);
    procedure A2CheckBox_OppositeClick(Sender: TObject);
    procedure A2CheckBox_PickClick(Sender: TObject);
    procedure A2CheckBox_ShowItemClick(Sender: TObject);
    procedure A2CheckBox_ShowMonsterClick(Sender: TObject);
    procedure A2CheckBox_ShowNpcClick(Sender: TObject);
    procedure A2CheckBox_ShowPlayer1Click(Sender: TObject);
    procedure A2CheckBox12Click(Sender: TObject);
    procedure A2CheckBox_MoveOpenMagicClick(Sender: TObject);
    procedure A2CheckBox11Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure A2ComboBox_ProtectMagicDropDown(Sender: TObject);
    procedure A2CheckBox_ProtectMagicClick(Sender: TObject);
    procedure A2CheckBoxThreePowerClick(Sender: TObject);
    procedure A2ComboBox_MonsterListDropDown(Sender: TObject);
    procedure A2CheckBox_MonsterHitClick(Sender: TObject);
    procedure A2CheckBox_CounterAttackClick(Sender: TObject);
    procedure A2CheckBox_BossKeyClick(Sender: TObject);
    procedure A2CheckBox_CounterAttackUserClick(Sender: TObject);
    procedure A2ListBox_DropItemlistDblClick(Sender: TObject);
    procedure A2CheckBox_QieHuanClick(Sender: TObject);
    procedure A2Label_AddQieHuanClick(Sender: TObject);
  private
        { Private declarations }
    AutoMove_X1, AutoMove_Y1: Integer;
    AutoMove_X2, AutoMove_Y2: Integer;
  public
    BackgroundImage_Eat: TA2Image;
    BackgroundImage_Pick: TA2Image;
    BackgroundImage_Walk: TA2Image;
    BackgroundImage_Show: TA2Image;
    BackgroundImage_Attack: TA2Image;
    BackgroundImage_Shout: TA2Image;
    ItemT1: tdatetime;
    ItemT2: tdatetime;
    ItemT3: tdatetime;
    ItemT4: tdatetime;
    Itemshiqu: tdatetime;
    auto_say_T: tdatetime;
    auto_Move_T: tdatetime;
    auto_say_id: integer;
    citem: TListConsole;
    FISShow: Boolean;
    procedure Item_Click(aid: integer);
    function isItemList(astr: string): boolean;
    procedure savetofile(afilenam: string);
    procedure loadFromfile(afilenam: string);
    //procedure SetImage;
    procedure SetData;

    procedure SetNewVersion(); override;

   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;
    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure autosave;
    function checkBoxMonsterlist(astr: string): boolean;

  end;

var
  FrmGameToolsNew: TFrmGameToolsNew;
  fwItemList: Twg_ItemList;
  G_ThreeStartInPower: Boolean;
  G_ThreeStartOutPower: Boolean;
  G_ThreeStartMagicPower: Boolean;
  G_ThreeStartNum: Byte;

implementation

uses
  FMain, FAttrib, AUtil32, CharCls, Deftype, FBottom, uPersonBat, FMiniMap,
  FnewMagic, filepgkclass, Unit_console, FGameToolsAssist;
{$R *.dfm}

constructor Twg_ItemList.Create();
begin
  data := tlist.Create;
end;

destructor Twg_ItemList.Destroy;
begin
  Clear;
  data.Free;
  inherited destroy;
end;

procedure Twg_ItemList.add2(aItemName: string; aRace: byte; aId, ax, ay, aItemShape, aItemColor: integer);
var
  aitem: Twgitemdata;
begin
  aitem.aItemName := aItemName;
  aitem.aRace := aRace;
  aitem.aId := aId;
  aitem.ax := ax;
  aitem.ay := ay;
  aitem.aItemShape := aItemShape;
  aitem.aItemColor := aItemColor;
  add(aitem);
end;

procedure Twg_ItemList.add(aitem: Twgitemdata);
var
  pp: pTwgitemdata;
begin
  new(pp);
  pp^ := aitem;
  pp.runtime := 0;
  data.Add(pp);
end;

procedure Twg_ItemList.del(aid: integer);
var
  i: integer;
  pp: pTwgitemdata;
begin
  for i := 0 to data.Count - 1 do
  begin
    pp := data.Items[i];
    if pp.aId = aid then
    begin
      dispose(pp);
      data.Delete(i);

      exit;
    end;
  end;

end;

procedure Twg_ItemList.Clear;
var
  i: integer;
  pp: pTwgitemdata;
begin
  for i := 0 to data.Count - 1 do
  begin
    pp := data.Items[i];
    dispose(pp);

  end;
  data.Clear;
end;

///////////////////////////////////////////////////////////////////////////////////

//procedure TFrmGameToolsNew.SetImage;
//var
//  outing: TA2Image;
//  uping: TA2Image;
//  downing: TA2Image;
//begin
//  BackgroundImage_Eat := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('辅助工具-吃药内框.bmp', BackgroundImage_Eat);
//   // BackgroundImage_Eat.LoadFromFile(ExtractFilePath(ParamStr(0))+'\bmp\辅助工具-吃药内框.bmp');
//  A2ILabel_BackEat.A2Image := BackgroundImage_Eat;
//  BackgroundImage_Pick := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('辅助工具-拾取内框.bmp', BackgroundImage_Pick);
//  A2ILabel_pick.A2Image := BackgroundImage_Pick;
//  BackgroundImage_Walk := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('辅助工具-步法内框.bmp', BackgroundImage_Walk);
//  A2ILabel_walk.A2Image := BackgroundImage_Walk;
//  BackgroundImage_Show := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('辅助工具-显示内框.bmp', BackgroundImage_Show);
//  A2ILabel_show.A2Image := BackgroundImage_Show;
//  BackgroundImage_Attack := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('辅助工具-攻击内框.bmp', BackgroundImage_Attack);
//  A2ILabel_attack.A2Image := BackgroundImage_Attack;
//  BackgroundImage_Shout := TA2Image.Create(32, 32, 0, 0);
//  pgkBmp.getBmp('辅助工具-喊话内框.bmp', BackgroundImage_Shout);
//  A2ILabel_shout.A2Image := BackgroundImage_Shout;
//
//  outing := TA2Image.Create(32, 32, 0, 0);
//  uping := TA2Image.Create(32, 32, 0, 0);
//  downing := TA2Image.Create(32, 32, 0, 0);
//  try
//        //导航按钮
//    pgkBmp.getBmp('辅助工具-吃药-按下.bmp', outing);
//    A2Button_Eat.A2NotEnabled := outing;
//    pgkBmp.getBmp('辅助工具-吃药-鼠标.bmp', outing);
//    A2Button_Eat.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-原始.bmp', outing);
//    A2Button_Eat.A2Up := outing;
//
//    pgkBmp.getBmp('辅助工具-拾取-按下.bmp', outing);
//    A2Button_Pick.A2NotEnabled := outing;
//    pgkBmp.getBmp('辅助工具-拾取-鼠标.bmp', outing);
//    A2Button_Pick.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-拾取-原始.bmp', outing);
//    A2Button_Pick.A2Up := outing;
//
//    pgkBmp.getBmp('辅助工具-喊话-按下.bmp', outing);
//    A2Button_Shout.A2NotEnabled := outing;
//    pgkBmp.getBmp('辅助工具-喊话-鼠标.bmp', outing);
//    A2Button_Shout.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-喊话-原始.bmp', outing);
//    A2Button_Shout.A2Up := outing;
//
//    pgkBmp.getBmp('辅助工具-步法-鼠标.bmp', outing);
//    A2Button_Walk.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-步法-原始.bmp', outing);
//    A2Button_Walk.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-步法-按下.bmp', outing);
//    A2Button_Walk.A2NotEnabled := outing;
//
//    pgkBmp.getBmp('辅助工具-攻击-按下.bmp', outing);
//    A2Button_Attack.A2NotEnabled := outing;
//    pgkBmp.getBmp('辅助工具-攻击-鼠标.bmp', outing);
//    A2Button_Attack.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-攻击-原始.bmp', outing);
//    A2Button_Attack.A2Up := outing;
//
//    pgkBmp.getBmp('辅助工具-显示-按下.bmp', outing);
//    A2Button_Show.A2NotEnabled := outing;
//    pgkBmp.getBmp('辅助工具-显示-鼠标.bmp', outing);
//    A2Button_Show.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-显示-原始.bmp', outing);
//    A2Button_Show.A2Up := outing;
//
//    pgkBmp.getBmp('辅助工具-辅助工具-顶部.bmp', outing);
//    A2ILabel_top.A2Image := outing;
//    pgkBmp.getBmp('辅助工具-辅助工具-底部.bmp', outing);
//    A2ILabel_bottom.A2Image := outing;
//    pgkBmp.getBmp('辅助工具-导航.bmp', outing);
//    A2ILabel_button.A2Image := outing;
//
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', outing);
//    A2Button_close.A2Up := outing;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', outing);
//    A2Button_close.A2Down := outing;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', outing);
//    A2Button_close.A2Mouse := outing;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', outing);
//    A2Button_close.A2NotEnabled := outing;
//
//    pgkBmp.getBmp('辅助工具-读入-弹起.bmp', outing);
//    A2Button_Read.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-读入-按下.bmp', outing);
//    A2Button_Read.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-读入-鼠标.bmp', outing);
//    A2Button_Read.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-读入-禁止.bmp', outing);
//    A2Button_Read.A2NotEnabled := outing;
//
//    pgkBmp.getBmp('辅助工具-保存-弹起.bmp', outing);
//    A2Button_Save.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-保存-按下.bmp', outing);
//    A2Button_Save.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-保存-鼠标.bmp', outing);
//    A2Button_Save.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-保存-禁止.bmp', outing);
//    A2Button_Save.A2NotEnabled := outing;
//
//        //吃药
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox1.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox1.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_inPower.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_inPower.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_outPower.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_outPower.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_Magic.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_Magic.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_Life.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_Life.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button1.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button1.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button1.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button2.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button2.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button2.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button3.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button3.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button3.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button4.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button4.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button4.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button5.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button5.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button5.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button6.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button6.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button6.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button7.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button7.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button7.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button8.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button8.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button8.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button11.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button11.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button11.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button12.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button12.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button12.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button9.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button9.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button9.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button10.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button10.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button10.A2Mouse := outing;
//
//        //拾取
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_Pick.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_Pick.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_Opposite.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_Opposite.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-添加-弹起.bmp', outing);
//    A2Button_Add.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-按钮-添加-按下.bmp', outing);
//    A2Button_Add.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-按钮-添加-鼠标.bmp', outing);
//    A2Button_Add.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-按钮-减少-弹起.bmp', outing);
//    A2Button_Dec.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-按钮-减少-按下.bmp', outing);
//    A2Button_Dec.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-按钮-减少-鼠标.bmp', outing);
//    A2Button_Dec.A2Mouse := outing;
//        //喊话
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox12.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox12.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button21.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button21.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button21.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button22.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button22.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button22.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-添加-弹起.bmp', outing);
//    A2Button_AddShout.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-按钮-添加-按下.bmp', outing);
//    A2Button_AddShout.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-按钮-添加-鼠标.bmp', outing);
//    A2Button_AddShout.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-按钮-减少-弹起.bmp', outing);
//    A2Button_DelShout.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-按钮-减少-按下.bmp', outing);
//    A2Button_DelShout.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-按钮-减少-鼠标.bmp', outing);
//    A2Button_DelShout.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-箭头-向上-弹起.bmp', uping);
//    pgkBmp.getBmp('辅助工具-箭头-向上-按下.bmp', downing);
//    A2ListBox_ShoutList.SetScrollTopImage(uping, downing);
//    pgkBmp.getBmp('辅助工具-箭头-向下-弹起.bmp', uping);
//    pgkBmp.getBmp('辅助工具-箭头-向下-按下.bmp', downing);
//    A2ListBox_ShoutList.SetScrollBottomImage(uping, downing);
//    pgkBmp.getBmp('辅助工具-按钮-滑动-鼠标.bmp', uping);
//    pgkBmp.getBmp('辅助工具-按钮-滑动-弹起.bmp', downing);
//    A2ListBox_ShoutList.SetScrollTrackImage(uping, downing);
//    pgkBmp.getBmp('辅助工具-滑动条-底框.bmp', outing);
//    A2ListBox_ShoutList.SetScrollBackImage(outing);
//
//        //步法
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_MoveOpenMagic.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_MoveOpenMagic.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox11.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox11.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button13.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button13.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button13.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button14.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button14.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button14.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button15.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button15.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button15.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button16.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button16.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button16.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button17.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button17.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button17.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button18.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button18.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button18.A2Mouse := outing;
//
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-弹起.bmp', outing);
//    A2Button19.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-按下.bmp', outing);
//    A2Button19.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向上按钮-鼠标.bmp', outing);
//    A2Button19.A2Mouse := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-弹起.bmp', outing);
//    A2Button20.A2Up := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-按下.bmp', outing);
//    A2Button20.A2Down := outing;
//    pgkBmp.getBmp('辅助工具-吃药-向下按钮-鼠标.bmp', outing);
//    A2Button20.A2Mouse := outing;
//
//        //攻击
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_Hit_not_Shift.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_Hit_not_Shift.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_Hit_not_Ctrl.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_Hit_not_Ctrl.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_autoHIt.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_autoHIt.SelectNotImage := outing;
//        //显示
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_ShowAllName.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_ShowAllName.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_ShowMonster.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_ShowMonster.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_ShowNpc.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_ShowNpc.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_ShowPlayer1.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_ShowPlayer1.SelectNotImage := outing;
//
//    pgkBmp.getBmp('辅助工具-按钮-打钩.bmp', outing);
//    A2CheckBox_ShowItem.SelectImage := outing;
//    pgkBmp.getBmp('辅助工具-按钮-空白.bmp', outing);
//    A2CheckBox_ShowItem.SelectNotImage := outing;
//  finally
//    outing.Free;
//    uping.Free;
//    downing.Free;
//  end;
//end;

procedure TFrmGameToolsNew.SetData;
begin
  A2Button_Eat.Enabled := false;
  A2Edit_inPower.Text := IntToStr(10);
  A2Edit_outPower.Text := IntToStr(10);
  A2Edit_Magic.Text := IntToStr(10);
  A2Edit_Life.Text := IntToStr(50);
  A2Edit1.Text := IntToStr(0);
  A2Edit_delayTimeEat.Text := IntToStr(1000);

  A2Edit7.Text := IntToStr(75);
  A2Edit8.Text := IntToStr(75);
  A2Edit9.Text := IntToStr(75);
  A2Edit10.Text := IntToStr(75);
  A2Edit11.Text := IntToStr(10);
end;

procedure TFrmGameToolsNew.FormCreate(Sender: TObject);
begin
  inherited;
  FISShow := False;
  Self.FTestPos := True;
  Left := 50;
  Top := 50;
  FrmM.AddA2Form(Self, A2Form);
  fwItemList := Twg_ItemList.Create;
 /// SetImage;
  SetNewVersion;
  SetData;
  citem := TListConsole.Create;
  G_ThreeStartInPower := false;
  G_ThreeStartOutPower := False;
  G_ThreeStartMagicPower := False;
  G_ThreeStartNum := 0;
  Timer1.Enabled := True; //2015.11.13 在水一方
end;

procedure TFrmGameToolsNew.FormDestroy(Sender: TObject);
begin
  BackgroundImage_Eat.Free;
  BackgroundImage_Pick.Free;
  BackgroundImage_Show.Free;
  BackgroundImage_Shout.Free;
  BackgroundImage_Walk.Free;
  BackgroundImage_Attack.Free;

  fwItemList.Free;
  citem.Free;
end;

procedure TFrmGameToolsNew.A2Button_EatClick(Sender: TObject);
begin
  if A2Button_Eat.Enabled then
    A2Button_Eat.Enabled := false;

  A2Button_Pick.Enabled := true;
  A2Button_Shout.Enabled := true;
  A2Button_Walk.Enabled := true;
  A2Button_Attack.Enabled := true;
  A2Button_Show.Enabled := true;
  if not FTestPos then
  begin
    A2Panel_eatblood.Left := 0;
    A2Panel_eatblood.Top := 56;
  end;
  A2Panel_eatblood.Visible := true;
  A2Panel_pick.Visible := false;
  A2Panel_shout.Visible := false;
  A2Panel_walk.Visible := false;
  A2Panel_attack.Visible := false;
  A2Panel_ShouName.Visible := false;
end;

procedure TFrmGameToolsNew.A2Button_PickClick(Sender: TObject);
begin
  if A2Button_Pick.Enabled then
    A2Button_Pick.Enabled := false;

  A2Button_Eat.Enabled := true;
  A2Button_Shout.Enabled := true;
  A2Button_Walk.Enabled := true;
  A2Button_Attack.Enabled := true;
  A2Button_Show.Enabled := true;
  if not FTestPos then
  begin
    A2Panel_pick.Left := 0;
    A2Panel_pick.Top := 56;
  end;
  A2Panel_pick.Visible := true;
  A2Panel_eatblood.Visible := false;
  A2Panel_shout.Visible := false;
  A2Panel_walk.Visible := false;
  A2Panel_attack.Visible := false;
  A2Panel_ShouName.Visible := false;
end;

procedure TFrmGameToolsNew.A2Button_ShoutClick(Sender: TObject);
begin
  if A2Button_Shout.Enabled then
    A2Button_Shout.Enabled := false;

  A2Button_Eat.Enabled := true;
  A2Button_Pick.Enabled := true;
  A2Button_Walk.Enabled := true;
  A2Button_Attack.Enabled := true;
  A2Button_Show.Enabled := true;
  if not FTestPos then
  begin
    A2Panel_shout.Left := 0;
    A2Panel_shout.Top := 56;
  end;
  A2Panel_shout.Visible := true;
  A2Panel_eatblood.Visible := false;
  A2Panel_pick.Visible := false;
  A2Panel_walk.Visible := false;
  A2Panel_attack.Visible := false;
  A2Panel_ShouName.Visible := false;
end;

procedure TFrmGameToolsNew.A2Button_WalkClick(Sender: TObject);
begin
  if A2Button_Walk.Enabled then
    A2Button_Walk.Enabled := false;

  A2Button_Eat.Enabled := true;
  A2Button_Pick.Enabled := true;
  A2Button_Shout.Enabled := true;
  A2Button_Attack.Enabled := true;
  A2Button_Show.Enabled := true;
  if not FTestPos then
  begin
    A2Panel_walk.Left := 0;
    A2Panel_walk.Top := 56;
  end;
  A2Panel_walk.Visible := true;
  A2Panel_eatblood.Visible := false;
  A2Panel_shout.Visible := false;
  A2Panel_pick.Visible := false;
  A2Panel_attack.Visible := false;
  A2Panel_ShouName.Visible := false;
end;

procedure TFrmGameToolsNew.A2Button_AttackClick(Sender: TObject);
begin
  if A2Button_Attack.Enabled then
    A2Button_Attack.Enabled := false;

  A2Button_Eat.Enabled := true;
  A2Button_Pick.Enabled := true;
  A2Button_Shout.Enabled := true;
  A2Button_Walk.Enabled := true;
  A2Button_Show.Enabled := true;
  if not FTestPos then
  begin
    A2Panel_attack.Left := 0;
    A2Panel_attack.Top := 56;
  end;
  A2Panel_attack.Visible := true;
  A2Panel_eatblood.Visible := false;
  A2Panel_shout.Visible := false;
  A2Panel_walk.Visible := false;
  A2Panel_pick.Visible := false;
  A2Panel_ShouName.Visible := false;
end;

procedure TFrmGameToolsNew.A2Button_ShowClick(Sender: TObject);
begin
  if A2Button_Show.Enabled then
    A2Button_Show.Enabled := false;

  A2Button_Eat.Enabled := true;
  A2Button_Pick.Enabled := true;
  A2Button_Shout.Enabled := true;
  A2Button_Walk.Enabled := true;
  A2Button_Attack.Enabled := true;
  if not FTestPos then
  begin
    A2Panel_ShouName.Left := 0;
    A2Panel_ShouName.Top := 56;
  end;
  A2Panel_ShouName.Visible := true;
  A2Panel_eatblood.Visible := false;
  A2Panel_shout.Visible := false;
  A2Panel_walk.Visible := false;
  A2Panel_attack.Visible := false;
  A2Panel_pick.Visible := false;
end;

procedure TFrmGameToolsNew.A2Button_CloseClick(Sender: TObject);
begin
  ItemT1 := now;
  ItemT2 := now;
  ItemT3 := now;
  ItemT4 := now;
  Itemshiqu := now;
  auto_say_T := now;
  auto_Move_T := now;
  Visible := false;
  SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmGameToolsNew.A2Button1Click(Sender: TObject);
begin
  if StrToInt(A2Edit_inPower.Text) <= 100 then
    A2Edit_inPower.Text := IntToStr(StrToInt(A2Edit_inPower.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button2Click(Sender: TObject);
begin
  if StrToInt(A2Edit_inPower.Text) > 0 then
    A2Edit_inPower.Text := IntToStr(StrToInt(A2Edit_inPower.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button3Click(Sender: TObject);
begin
  if StrToInt(A2Edit_outPower.Text) <= 100 then
    A2Edit_outPower.Text := IntToStr(StrToInt(A2Edit_outPower.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button4Click(Sender: TObject);
begin
  if StrToInt(A2Edit_outPower.Text) > 0 then
    A2Edit_outPower.Text := IntToStr(StrToInt(A2Edit_outPower.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button5Click(Sender: TObject);
begin
  if StrToInt(A2Edit_Magic.Text) <= 100 then
    A2Edit_Magic.Text := IntToStr(StrToInt(A2Edit_Magic.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button6Click(Sender: TObject);
begin
  if StrToInt(A2Edit_Magic.Text) > 0 then
    A2Edit_Magic.Text := IntToStr(StrToInt(A2Edit_Magic.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button8Click(Sender: TObject);
begin
  if StrToInt(A2Edit_Life.Text) > 0 then
    A2Edit_Life.Text := IntToStr(StrToInt(A2Edit_Life.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button9Click(Sender: TObject);
begin
  A2Edit_delayTimeEat.Text := IntToStr(StrToInt(A2Edit_delayTimeEat.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button10Click(Sender: TObject);
begin
  if StrToInt(A2Edit_delayTimeEat.Text) > 0 then
    A2Edit_delayTimeEat.Text := IntToStr(StrToInt(A2Edit_delayTimeEat.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button13Click(Sender: TObject);
begin
  A2Edit7.Text := IntToStr(StrToInt(A2Edit7.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button14Click(Sender: TObject);
begin
  if StrToInt(A2Edit7.Text) > 0 then
    A2Edit7.Text := IntToStr(StrToInt(A2Edit7.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button16Click(Sender: TObject);
begin
  if StrToInt(A2Edit8.Text) > 0 then
    A2Edit8.Text := IntToStr(StrToInt(A2Edit8.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button15Click(Sender: TObject);
begin
  A2Edit8.Text := IntToStr(StrToInt(A2Edit8.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button17Click(Sender: TObject);
begin
  A2Edit9.Text := IntToStr(StrToInt(A2Edit9.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button18Click(Sender: TObject);
begin
  if StrToInt(A2Edit9.Text) > 0 then
    A2Edit9.Text := IntToStr(StrToInt(A2Edit9.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button19Click(Sender: TObject);
begin
  A2Edit10.Text := IntToStr(StrToInt(A2Edit10.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button20Click(Sender: TObject);
begin
  if StrToInt(A2Edit10.Text) > 0 then
    A2Edit10.Text := IntToStr(StrToInt(A2Edit10.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button_AddClick(Sender: TObject);
var
  i: integer;
  isbo: Boolean;
  str, str2: string;
begin
  if A2Edit6.Text = '' then
    exit;
  str := A2Edit6.Text;
  isbo := False;
  //循环判断是否有重复内容
  for i := 0 to A2ListBox_Itemlist.Count - 1 do
  begin
    str2 := (A2ListBox_Itemlist.Items[i]);
    if trim(str2) = str then
    begin
      isbo := true;
      break;
    end;
  end;
  //加入内容
  if isbo = False then
  begin
    A2ListBox_Itemlist.AddItem(str);
  end;
  A2Edit6.Text := '';
  autosave;
end;

procedure TFrmGameToolsNew.A2Button_DecClick(Sender: TObject);
begin
  if (A2ListBox_Itemlist.ItemIndex >= 0) and (A2ListBox_Itemlist.ItemIndex < A2ListBox_Itemlist.Count) then
    A2ListBox_Itemlist.DeleteItem(A2ListBox_Itemlist.ItemIndex);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button21Click(Sender: TObject);
begin
  A2Edit11.Text := IntToStr(StrToInt(A2Edit11.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button22Click(Sender: TObject);
begin
  if StrToInt(A2Edit11.Text) > 0 then
    A2Edit11.Text := IntToStr(StrToInt(A2Edit11.Text) - 1);
  autosave;
end;

function TFrmGameToolsNew.isItemList(astr: string): boolean;
var
  i: integer;
  str, str2: string;
begin
  astr := GetValidStr3(astr, str2, ':');
  str2 := trim(str2);
  result := false;
  for i := 0 to A2ListBox_Itemlist.Count - 1 do
  begin
    str := (A2ListBox_Itemlist.Items[i]);
    if trim(str) = (str2) then
    begin
      result := true;
      exit;
    end;
  end;
end;

function TFrmGameToolsNew.checkBoxMonsterlist(astr: string): boolean;
var
  i: integer;
  str, str2: string;
begin
  result := false;

  for i := 0 to High(Box_Monster) do begin
    if trim(astr) = Box_Monster[i] then
    begin
      result := true;
      exit;
    end;
  end;
end;

procedure TFrmGameToolsNew.Item_Click(aid: integer);
var
  cClick: TCClick;
begin
  cClick.rmsg := CM_CLICK;
  cClick.rwindow := WINDOW_SCREEN;
  cClick.rclickedId := aid;
  Frmfbl.SocketAddData(sizeof(cClick), @cClick);
end;

procedure TFrmGameToolsNew.loadFromfile(afilenam: string);
var
  i, j, Count: integer;
  temp: TObject;
  str, str1: string;
  ini: TiniFileclass;
begin

  //if FileExists('.\user\' + afilenam) = false then exit;
  //ini := TiniFileclass.Create('.\userdata\' + afilenam);
  if FileExists('.\user\' + afilenam + '.dat') = false then
    ini := TiniFileclass.Create('.\user\_default.dat')
  else
    ini := TiniFileclass.Create('.\user\' + afilenam + '.dat');

  try
    for j := 0 to ComponentCount - 1 do
    begin
      temp := Components[j];
      if temp is TA2CheckBox then
      begin

        //不保存的项目
        if TA2CheckBox(temp).name = 'A2CheckBoxThreePower' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_ProtectMagic' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_CounterAttack' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_CounterAttackUser' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_MonsterHit' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_MoveOpenMagic' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox11' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox12' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_QieHuan' then Continue;

        TA2CheckBox(temp).Checked := ini.ReadBool('TA2CheckBox', TA2CheckBox(temp).Name, TA2CheckBox(temp).Checked);
      end
      else if temp is TA2Edit then
      begin
        TA2Edit(temp).Text := ini.ReadString('TA2Edit', TA2Edit(temp).Name, TA2Edit(temp).Text);
      end
      else if temp is TA2ListBox then
      begin
        if TA2ListBox(temp).name = 'A2ListBox_DropItemlist' then Continue; //2015.11.16 在水一方
        Count := ini.ReadInteger('TA2ListBox', TA2ListBox(temp).Name + '.Count', TA2ListBox(temp).Count);
        if Count > 0 then
        begin
          TA2ListBox(temp).Clear;
          for i := 0 to Count - 1 do
          begin
            str := ini.ReadString('TA2ListBox', format(TA2ListBox(temp).Name + '%d', [i]), str);
            TA2ListBox(temp).AddItem(str);
          end;
        end;
      end
      else if temp is TA2ComboBox then
      begin
        TA2ComboBox(temp).Text := ini.ReadString('TA2ComboBox', TA2ComboBox(temp).Name, TA2ComboBox(temp).Text);
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TFrmGameToolsNew.savetofile(afilenam: string);
var
  str: string;
  i, j: integer;
  ini: TiniFileclass;
  temp: TObject;
begin
  if not DirectoryExists('.\user') then
    CreateDir('.\user');
  if afilenam = '' then
    Exit;
  ini := TiniFileclass.Create('.\user\' + afilenam + '.dat');
  try
    for j := 0 to ComponentCount - 1 do
    begin
      temp := Components[j];
      if temp is TA2CheckBox then
      begin
        //不保存的项目
        if TA2CheckBox(temp).name = 'A2CheckBoxThreePower' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_ProtectMagic' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_CounterAttack' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_CounterAttackUser' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_MonsterHit' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_MoveOpenMagic' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox11' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox12' then Continue;
        if TA2CheckBox(temp).name = 'A2CheckBox_QieHuan' then Continue;
        ini.WriteBool('TA2CheckBox', TA2CheckBox(temp).Name, TA2CheckBox(temp).Checked);
      end
      else if temp is TA2Edit then
      begin
        ini.WriteString('TA2Edit', TA2Edit(temp).Name, TA2Edit(temp).Text);
      end
      else if temp is TA2ListBox then
      begin
        if TA2ListBox(temp).name = 'A2ListBox_DropItemlist' then Continue; //2015.11.16 在水一方
        ini.WriteInteger('TA2ListBox', TA2ListBox(temp).Name + '.Count', TA2ListBox(temp).Count);
        for i := 0 to TA2ListBox(temp).Count - 1 do
        begin
          ini.WriteString('TA2ListBox', format(TA2ListBox(temp).Name + '%d', [i]), TA2ListBox(temp).Items[i]);
        end;
      end
      else if temp is TA2ComboBox then
      begin
        ini.WriteString('TA2ComboBox', TA2ComboBox(temp).Name, TA2ComboBox(temp).Text);
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TFrmGameToolsNew.FormShow(Sender: TObject);
begin
  Top := 50;
  Left := 50;
  A2ComboBox_inPower.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox_outPower.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox_Magic.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox_Life.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox_ChangeMoveMagic.Items.Text := '无名步法' + #13#10 + HaveMagicClass.HaveMagic.getMoveMagicNameList;
  A2ComboBox_CLWG.Items.Text := HaveMagicClass.DefaultMagic.getBREATHNGMagicNameList + HaveMagicClass.HaveMagic.getBREATHNGMagicNameList + HaveMagicClass.HaveRiseMagic.getBREATHNGMagicNameList;

  loadFromfile(CharCenterName);
  FISShow := True;
end;

function GetCellLength(sx, sy, dx, dy: word): word;
var
  xx, yy, n: integer;
begin
  Result := 1000;

  if sx > dx then
    xx := sx - dx
  else
    xx := dx - sx;
  if sy > dy then
    yy := sy - dy
  else
    yy := dy - sy;

  if xx > 255 then
    exit;
  if yy > 255 then
    exit;

  n := xx * xx + yy * yy;
  Result := Round(SQRT(n));
end;

procedure TFrmGameToolsNew.A2Button_ReadClick(Sender: TObject);
begin
  loadFromfile(CharCenterName);
end;

procedure TFrmGameToolsNew.A2Button_SaveClick(Sender: TObject);
begin
  savetofile(CharCenterName);
  Close;
end;

procedure TFrmGameToolsNew.Timer1Timer(Sender: TObject);
var
  i: integer;
  Cl: TCharClass;
  psNewMap: PTSNewMap;

  function _item(astr: string): boolean;
  var
    akey: integer;
    CLAtt: TCharClass;
    cClick: TCClick;
  begin
    result := false;
    if astr = '' then
      exit;
    if citem.getcount >= 3 then
      exit;
    CLAtt := CharList.CharGet(CharCenterId);
    if CLAtt = nil then
      exit;
    if CLAtt.Feature.rfeaturestate = wfs_die then
      exit; //死亡
    akey := HaveItemclass.getViewNameid(astr);
    if akey = -1 then
      exit;
    if Frmfbl.ISMsgCmd(CM_DBLCLICK) = false then
      exit;

    cClick.rmsg := CM_DBLCLICK;
    cClick.rwindow := WINDOW_ITEMS;
    cClick.rclickedId := 0;
    cClick.rkey := akey;
    if Frmfbl.SocketAddData(sizeof(cClick), @cClick) = false then
      exit;
    citem.add('吃药', 5000);
    FrmConsole.cprint(lt_gametools, format('吃药，%s', [astr]));
    result := true;
  end;

  procedure _shiquitem();
  var
    aid, i: integer;
    pp: pTwgitemdata;
    CLAtt: TCharClass;
  const
    xtime = 500; //捡东西延迟
  begin
    CLAtt := CharList.CharGet(CharCenterId);
    if CLAtt = nil then
      exit;
    if CLAtt.Feature.rfeaturestate = wfs_die then
      exit; //死亡
    if CLAtt.Feature.rfeaturestate = wfs_sitdown then
      exit; //打坐
    for i := fwItemList.data.Count - 1 downto 0 do
    begin
      pp := fwItemList.data.Items[i];
      if pp.aRace <> RACE_ITEM then
        Continue;
      if A2CheckBox_Opposite.Checked then
      begin
        if (isItemList(pp.aItemName) = true) then
          Continue;
      end
      else
      begin
        if (isItemList(pp.aItemName) = false) then
          Continue;
      end;
      if (MilliSecondsBetween(now(), pp.runtime) > xtime) and (GetCellLength(CLAtt.x, CLAtt.y, pp.ax, pp.ay) <= 3) then
      begin
        pp.runtime := now();
        Item_Click(pp.aId);
        FrmConsole.cprint(lt_gametools, format('拾取，%s(%d:%d)', [pp.aItemName, pp.ax, pp.ay]));
        exit;
      end;
    end;

  end;

  procedure _autosay(astr: string);
  var
    tempKey: word;
    ai: integer;
    _str: string;
  begin
    astr := trim(astr);
    astr := copy(astr, 1, 100);
    if astr = '' then
      exit;
    tempKey := VK_RETURN;
    FrmBottom.sendsay(astr, tempKey);
  end;
  //来回移动

  procedure _autoMove_2015_12_24();
  begin
    if FrmMiniMap.TimerAutoPathMove.Enabled then
      exit;
    if (CharPosX = AutoMove_X1) and (CharPosY = AutoMove_Y1) then
    begin
      cMaper.QuickMode := true;
      FrmMiniMap.AIPathcalc_paoshishasbi(AutoMove_X2, AutoMove_Y2);
      exit;
    end;
    if (CharPosX = AutoMove_X2) and (CharPosY = AutoMove_Y2) then
    begin
      cMaper.QuickMode := true;
      FrmMiniMap.AIPathcalc_paoshishasbi(AutoMove_X1, AutoMove_Y1);
      exit;
    end;

    if random(8) > 5 then
    begin
      FrmMiniMap.AIPathcalc_paoshishasbi(AutoMove_X2, AutoMove_Y2);
      exit;
    end;
    FrmMiniMap.AIPathcalc_paoshishasbi(AutoMove_X1, AutoMove_Y1);
  end;

//  procedure _autoMove_2015_12_24();
//  begin
//    if FrmMiniMap.TimerAutoPathMove.Enabled then
//      exit;
//
//    if (CharPosX = StrToInt(A2Edit7.Text)) and (CharPosY = StrToInt(A2Edit8.Text)) then
//    begin
//      cMaper.QuickMode := true;
//      FrmMiniMap.AIPathcalc_paoshishasbi(StrToInt(A2Edit9.Text), StrToInt(A2Edit10.Text));
//      exit;
//    end;
//    if (CharPosX = StrToInt(A2Edit9.Text)) and (CharPosY = StrToInt(A2Edit10.Text)) then
//    begin
//      cMaper.QuickMode := true;
//      FrmMiniMap.AIPathcalc_paoshishasbi(StrToInt(A2Edit7.Text), StrToInt(A2Edit8.Text));
//      exit;
//    end;
//
//    if random(8) > 5 then
//    begin
//      FrmMiniMap.AIPathcalc_paoshishasbi(StrToInt(A2Edit9.Text), StrToInt(A2Edit10.Text));
//      exit;
//    end;
//    FrmMiniMap.AIPathcalc_paoshishasbi(StrToInt(A2Edit7.Text), StrToInt(A2Edit8.Text));
//  end;

begin
  if not ReConnetFlag then exit;

  citem.update(GetTickCount);

  //死亡关闭小地图
  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then
    exit;
  if (Cl.Feature.rfeaturestate = wfs_die) and (FrmMiniMap.Visible) then
    FrmMiniMap.Visible := False;

  if FrmBottom.Visible = false then
    exit;
 // FrmConsole.cprint(lt_gametools, format('刷新，%d', [GetTickCount]));

  if A2CheckBox11.Checked and (MilliSecondsBetween(now(), auto_move_T) > (1000)) then
  begin
    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;
    if (Cl.Feature.rfeaturestate = wfs_die) or (AutoMove_X1 = 0) or (AutoMove_Y1 = 0) or (AutoMove_X2 = 0) or (AutoMove_Y2 = 0) then
    begin
      //FrmBottom.AddChat('获取移动坐标', ColorSysToDxColor(clYellow), 0);
      //左边坐标获取
      AutoMove_X1 := CharPosX - 8;
      AutoMove_Y1 := CharPosY;
      i := 0;
      while not cMaper.isMoveable(AutoMove_X1, AutoMove_Y1) do
      begin
        inc(i);
        AutoMove_X1 := AutoMove_X1 + random(i) - 1;
        AutoMove_Y1 := AutoMove_Y1 + random(i) - 1;
        if i > 7 then
          Break;
      end;
      if not cMaper.isMoveable(AutoMove_X1, AutoMove_Y1) then
      begin
        FrmBottom.AddChat('周边障碍物太多.', ColorSysToDxColor(clYellow), 0);
        exit;
      end;
      //右边坐标获取
      AutoMove_X2 := CharPosX + 8;
      AutoMove_Y2 := CharPosY;
      i := 0;
      while not cMaper.isMoveable(AutoMove_X2, AutoMove_Y2) do
      begin
        inc(i);
        AutoMove_X2 := AutoMove_X2 + random(i) - 1;
        AutoMove_Y2 := AutoMove_Y2 + random(i) - 1;
        if i > 7 then
          Break;
      end;
      if not cMaper.isMoveable(AutoMove_X2, AutoMove_Y2) then
      begin
        FrmBottom.AddChat('周边障碍物太多.', ColorSysToDxColor(clYellow), 0);
        A2CheckBox11.Checked := False;
        exit;
      end;
      //FrmBottom.AddChat(format('AutoMove_X1 = %d / AutoMove_Y1 = %d / AutoMove_X2 = %d / AutoMove_Y2 = %d', [AutoMove_X1, AutoMove_Y1, AutoMove_X2, AutoMove_Y2]), ColorSysToDxColor(clYellow), 0);
    end;
    auto_Move_T := now();
    _autoMove_2015_12_24;
  end;

//  if A2CheckBox11.Checked and (MilliSecondsBetween(now(), auto_move_T) > (5000)) then
//  begin
//    if FrmMiniMap.A2ILabel1.Caption <> '步法弓投修练场' then
//    begin
//      FrmBottom.AddChat('自动修炼步法只允许在[步法弓投修练场]使用!', ColorSysToDxColor($008000), 0);
//      A2CheckBox11.Checked := False;
//      Exit;
//    end;
//    auto_Move_T := now();
//    _autoMove_2015_12_24;
//  end;

  if (A2CheckBox12.Checked) and (MilliSecondsBetween(now(), auto_say_T) > (StrToInt(A2Edit11.Text) * 1000)) then
  begin
    auto_say_T := now();
    if (auto_say_id < 0) or (auto_say_id >= A2ListBox_ShoutList.Count) then
      auto_say_id := 0;
    if (auto_say_id < 0) or (auto_say_id >= A2ListBox_ShoutList.Count) then

    else
    begin
      _autosay('! ' + A2ListBox_ShoutList.Items[auto_say_id]);
      inc(auto_say_id);
    end;
  end;

  //修炼三功模式
  if A2CheckBoxThreePower.Checked then
  begin
    //判断吃药状态
    if G_ThreeStartNum > 0 then
    begin
      //内容
      if G_ThreeStartNum = 1 then
      begin
        //超过90%停止向服用
        if (cAttribClass.CurAttribData.CurInPower / cAttribClass.AttribData.cInPower * 100 > 90) then
        begin
          G_ThreeStartNum := 0;
        end
        else
        begin
          //服用药品
          if (A2CheckBox_inPower.Checked) and (A2Edit_inPower.Text <> '') and (MilliSecondsBetween(now(), ItemT1) > 200) then
          begin
            if _item(A2ComboBox_inPower.Text) then
              ItemT1 := now();
          end;
        end;
      end
      //外功
      else if G_ThreeStartNum = 2 then
      begin
        //超过90%停止向服用
        if (cAttribClass.CurAttribData.CurOutPower / cAttribClass.AttribData.cOutPower * 100 > 90) then
        begin
          G_ThreeStartNum := 0;
        end
        else
        begin
          //服用药品
          if (A2CheckBox_outPower.Checked) and (A2Edit_outPower.Text <> '') and (MilliSecondsBetween(now(), ItemT2) > 200) then
          begin
            if _item(A2ComboBox_outPower.Text) then
              ItemT2 := now();
          end;
        end;
      end
      //武功
      else if G_ThreeStartNum = 3 then
      begin
        //超过90%停止向服用
        if (cAttribClass.CurAttribData.CurMagic / cAttribClass.AttribData.cMagic * 100 > 90) then
        begin
          G_ThreeStartNum := 0;
        end
        else
        begin
          //服用药品
          if (A2CheckBox_Magic.Checked) and (A2ComboBox_Magic.Text <> '') and (MilliSecondsBetween(now(), ItemT3) > 200) then
          begin
            if _item(A2ComboBox_Magic.Text) then
              ItemT3 := now();
          end;
        end;
      end;

    end
    else
    begin
    //判断是否需要吃药
    //内功
      if A2Edit_inPower.Text <> '' then
      begin
        if A2CheckBox_inPower.Checked
          and (cAttribClass.CurAttribData.CurInPower / cAttribClass.AttribData.cInPower * 100 < 10) then
        begin
          G_ThreeStartNum := 1; //设置服用内功药
        //if _item(A2ComboBox_inPower.Text) then
        //  ItemT1 := now();
        end;
      end;
    //外功
      if A2Edit_outPower.Text <> '' then
      begin
        if A2CheckBox_outPower.Checked
          and (cAttribClass.CurAttribData.CurOutPower / cAttribClass.AttribData.cOutPower * 100 < 10) then
        begin
          G_ThreeStartNum := 2; //设置服用外功药
          //if _item(A2ComboBox_outPower.Text) then
          //  ItemT2 := now();
        end;
      end;
    //武功
      if A2Edit_Magic.Text <> '' then
      begin
        if A2CheckBox_Magic.checked
          and (cAttribClass.CurAttribData.CurMagic / cAttribClass.AttribData.cMagic * 100 < 10) then
        begin
          G_ThreeStartNum := 3; //设置服用武功药
          //if _item(A2ComboBox_Magic.Text) then
          //  ItemT3 := now();
        end;
      end;
    end;

//    //判断是否需要吃药
//    if G_ThreeStartInPower or G_ThreeStartOutPower or G_ThreeStartMagicPower then
//    begin
//      if G_ThreeStartInPower then
//      begin
//        if (cAttribClass.CurAttribData.CurInPower < cAttribClass.AttribData.cInPower) then
//        begin
//          _item(A2ComboBox_inPower.Text);
//        end
//        else
//        begin
//          G_ThreeStartInPower := False;
//        end;
//      end;
//      if G_ThreeStartOutPower then
//      begin
//        if (cAttribClass.CurAttribData.CurOutPower < cAttribClass.AttribData.cOutPower) then
//        begin
//          _item(A2ComboBox_OutPower.Text);
//        end
//        else
//        begin
//          G_ThreeStartOutPower := False;
//        end;
//      end;
//
//      if G_ThreeStartMagicPower then
//      begin
//        if (cAttribClass.CurAttribData.CurMagic < cAttribClass.AttribData.cMagic) then
//        begin
//          _item(A2ComboBox_Magic.Text);
//        end
//        else
//        begin
//          G_ThreeStartMagicPower := False;
//        end;
//      end;
//    end
//    else
//    begin
//    end;
//
//    if (not G_ThreeStartInPower) and ((cAttribClass.CurAttribData.CurInPower / cAttribClass.AttribData.cInPower * 100) < 10) then
//    begin
//      G_ThreeStartInPower := True;
//      //FrmM.AutoHit_stop;
//
//    end;
//    if (not G_ThreeStartOutPower) and ((cAttribClass.CurAttribData.CurOutPower / cAttribClass.AttribData.cOutPower * 100) < 10) then
//    begin
//      G_ThreeStartOutPower := True;
//      //FrmM.AutoHit_stop;
//
//    end;
//    if (not G_ThreeStartMagicPower) and ((cAttribClass.CurAttribData.CurMagic / cAttribClass.AttribData.cMagic * 100) < 10) then
//    begin
//      G_ThreeStartMagicPower := True;
//      //FrmM.AutoHit_stop;
//
//    end;

  end
  else
  begin //普通吃药方式
    begin
      if (A2Edit_inPower.Text <> '') and (A2Edit_delayTimeEat.Text <> '') then
      begin
        if A2CheckBox_inPower.Checked //and (cAttribClass.CurAttribData.CurInPower <StrToInt64(A2Edit_inPower.Text)* 100)   //原来是比例，现在是绝对值
          and (cAttribClass.CurAttribData.CurInPower / cAttribClass.AttribData.cInPower * 100 < StrToInt64(A2Edit_inPower.Text)) and (MilliSecondsBetween(now(), ItemT1) > StrToInt64(A2Edit_delayTimeEat.Text)) then
        begin
          if _item(A2ComboBox_inPower.Text) then
            ItemT1 := now();
        end;
      end;

      if (A2Edit_outPower.Text <> '') and (A2Edit_delayTimeEat.Text <> '') then
      begin
        if A2CheckBox_outPower.Checked //and (cAttribClass.CurAttribData.CurOutPower   < StrToInt64(A2Edit_outPower.Text)* 100)   //原来是比例，现在是绝对值
          and (cAttribClass.CurAttribData.CurOutPower / cAttribClass.AttribData.cOutPower * 100 < StrToInt64(A2Edit_outPower.Text)) and (MilliSecondsBetween(now(), ItemT2) > StrToInt64(A2Edit_delayTimeEat.Text)) then
        begin
          if _item(A2ComboBox_outPower.Text) then
            ItemT2 := now();
        end;
      end;

      if (A2Edit_Magic.Text <> '') and (A2Edit_delayTimeEat.Text <> '') then
      begin
        if A2CheckBox_Magic.checked // and (cAttribClass.CurAttribData.CurMagic   < StrToInt64(A2Edit_Magic.Text)* 100)   //原来是比例，现在是绝对值
          and (cAttribClass.CurAttribData.CurMagic / cAttribClass.AttribData.cMagic * 100 < StrToInt64(A2Edit_Magic.Text)) and (MilliSecondsBetween(now(), ItemT3) > StrToInt64(A2Edit_delayTimeEat.Text)) then
        begin

          if _item(A2ComboBox_Magic.Text) then
            ItemT3 := now();
        end;
      end;
    end;
//    if (A2Edit_Life.Text <> '') and (A2Edit_delayTimeEat.Text <> '') then
//    begin
//      //if A2CheckBox_Life.Checked and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 < StrToInt64(A2Edit_Life.Text)) and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 > StrToInt64(A2Edit1.Text)) //大于低活吃药时候才吃普通的
//      //  and (MilliSecondsBetween(now(), ItemT4) > StrToInt64(A2Edit_delayTimeEat.Text)) then
//      if A2CheckBox_Life.Checked and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 < StrToInt64(A2Edit_Life.Text)) //大于低活吃药时候才吃普通的
//        and (MilliSecondsBetween(now(), ItemT4) > StrToInt64(A2Edit_delayTimeEat.Text)) then
//      begin
//        if _item(A2ComboBox_Life.Text) then
//          ItemT4 := now();
//      end;
//    end;

//    if (A2Edit1.Text <> '') and (A2Edit_delayTimeEat.Text <> '') then //低活
//    begin
//      if A2CheckBox1.Checked and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 < StrToInt64(A2Edit1.Text)) and (MilliSecondsBetween(now(), ItemT4) > StrToInt64(A2Edit_delayTimeEat.Text)) then
//      begin
//        if _item(A2ComboBox1.Text) then
//          ItemT4 := now();
//      end;
//    end;
  end;
  //活力单独处理
  if (A2Edit_Life.Text <> '') and (A2Edit_delayTimeEat.Text <> '') then
  begin
      //if A2CheckBox_Life.Checked and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 < StrToInt64(A2Edit_Life.Text)) and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 > StrToInt64(A2Edit1.Text)) //大于低活吃药时候才吃普通的
      //  and (MilliSecondsBetween(now(), ItemT4) > StrToInt64(A2Edit_delayTimeEat.Text)) then
    if A2CheckBox_Life.Checked and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 < StrToInt64(A2Edit_Life.Text)) //大于低活吃药时候才吃普通的
      and (MilliSecondsBetween(now(), ItemT4) > StrToInt64(A2Edit_delayTimeEat.Text)) then
    begin
      if _item(A2ComboBox_Life.Text) then
        ItemT4 := now();
    end;
  end;

  if A2CheckBox_Pick.Checked and (MilliSecondsBetween(now(), Itemshiqu) > 500) then
  begin
    Itemshiqu := now();
    _shiquitem;
  end;
end;

procedure TFrmGameToolsNew.A2Edit_inPowerChange(Sender: TObject);
begin

  if A2Edit_inPower.Text = '' then
    A2Edit_inPower.Text := '1';
  if _StrToInt(trim(A2Edit_inPower.Text)) < 1 then
    A2Edit_inPower.Text := '1';
 //   if _StrToInt(trim(A2Edit_inPower.Text)) > 100 then A2Edit_inPower.Text := '100';
  autosave;
end;

procedure TFrmGameToolsNew.A2Button_AddShoutClick(Sender: TObject);
begin
  if A2Edit_AddShout.Text <> '' then
    A2ListBox_ShoutList.AddItem(A2Edit_AddShout.Text);
  A2Edit_AddShout.Text := '';
  autosave;
end;

procedure TFrmGameToolsNew.A2Button_DelShoutClick(Sender: TObject);
var
  i: integer;
begin
  i := A2ListBox_ShoutList.ItemIndex;
  if (i < 0) or (i >= A2ListBox_ShoutList.Count) then
    exit;
  A2ListBox_ShoutList.DeleteItem(i);
  autosave;
end;

procedure TFrmGameToolsNew.A2Button7Click(Sender: TObject);
begin
  if StrToInt(A2Edit_Life.Text) <= 100 then
    A2Edit_Life.Text := IntToStr(StrToInt(A2Edit_Life.Text) + 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit11Change(Sender: TObject);
begin
  if A2Edit11.Text = '' then
    A2Edit11.Text := '1';
  if StrToInt(trim(A2Edit_delayTimeEat.Text)) < 1 then
    A2Edit_delayTimeEat.Text := '1';
  if StrToInt(trim(A2Edit_delayTimeEat.Text)) > 100000000 then
    A2Edit_delayTimeEat.Text := '100000000';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit_outPowerChange(Sender: TObject);
begin
  if A2Edit_outPower.Text = '' then
    A2Edit_outPower.Text := '1';
  if StrToInt(trim(A2Edit_outPower.Text)) < 1 then
    A2Edit_outPower.Text := '1';
 //   if StrToInt(trim(A2Edit_outPower.Text)) > 100 then A2Edit_outPower.Text := '100';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit_MagicChange(Sender: TObject);
begin
  if A2Edit_Magic.Text = '' then
    A2Edit_Magic.Text := '1';
  if StrToInt(trim(A2Edit_Magic.Text)) < 1 then
    A2Edit_Magic.Text := '1';
//    if StrToInt(trim(A2Edit_Magic.Text)) > 100 then A2Edit_Magic.Text := '100';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit_LifeChange(Sender: TObject);
begin
  if A2Edit_Life.Text = '' then
    A2Edit_Life.Text := '1';
//  if StrToInt(trim(A2Edit_Life.Text)) < StrToInt(trim(A2Edit1.Text)) then
//    A2Edit_Life.Text := trim(A2Edit1.Text);
  if StrToInt(trim(A2Edit_Life.Text)) < 1 then
    A2Edit_Life.Text := '1';
  if StrToInt(trim(A2Edit_Life.Text)) > 100 then A2Edit_Life.Text := '100';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit_delayTimeEatChange(Sender: TObject);
begin
  if A2Edit_delayTimeEat.Text = '' then
    A2Edit_delayTimeEat.Text := '1';
  if StrToInt(trim(A2Edit_delayTimeEat.Text)) < 1 then
    A2Edit_delayTimeEat.Text := '1';
  if StrToInt(trim(A2Edit_delayTimeEat.Text)) > 100000000 then
    A2Edit_delayTimeEat.Text := '100000000';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit7Change(Sender: TObject);
begin
  if A2Edit7.Text = '' then
    A2Edit7.Text := '1';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit8Change(Sender: TObject);
begin
  if A2Edit8.Text = '' then
    A2Edit8.Text := '1';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit9Change(Sender: TObject);
begin
  if A2Edit9.Text = '' then
    A2Edit9.Text := '1';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit10Change(Sender: TObject);
begin
  if A2Edit10.Text = '' then
    A2Edit10.Text := '1';
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit_inPowerKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then
    key := #0;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_ShowAllNameClick(Sender: TObject);
begin
  A2CheckBox_ShowMonster.Checked := A2CheckBox_ShowAllName.Checked;
  A2CheckBox_ShowNpc.Checked := A2CheckBox_ShowAllName.Checked;
  A2CheckBox_ShowPlayer1.Checked := A2CheckBox_ShowAllName.Checked;
  A2CheckBox_ShowItem.Checked := A2CheckBox_ShowAllName.Checked;
  autosave;
end;

{ TListConsole }

procedure TListConsole.add(aname: string; atime: integer);
var
  p: pTListConsoledata;
begin
  new(p);
  p.rname := copy(aname, 1, 64);
  p.rAddTime := GetTickCount;
  p.rEndTime := GetTickCount + atime;
  fdata.Add(p);
end;

procedure TListConsole.clear;
var
  i: integer;
  p: pTListConsoledata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    dispose(p);
  end;
  fdata.Clear;
end;

constructor TListConsole.Create;
begin
  fdata := TList.Create;
end;

destructor TListConsole.Destroy;
begin
  clear;
  fdata.Free;
  inherited;
end;

function TListConsole.getcount: integer;
begin
  result := fdata.Count;
end;

procedure TListConsole.update(curtcik: integer);
var
  i: integer;
  p: pTListConsoledata;
begin
  for i := fdata.Count - 1 downto 0 do
  begin
    p := fdata.Items[i];
    if curtcik > p.rEndTime then
    begin
      fdata.Delete(i);
      dispose(p);
    end;
  end;
end;

procedure TFrmGameToolsNew.A2ComboBox_inPowerDropDown(Sender: TObject);
begin
  A2ComboBox_inPower.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox_outPower.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox_Magic.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox_Life.Items.Text := HaveItemclass.getitemNameList;
  A2ComboBox1.Items.Text := HaveItemclass.getitemNameList;
  autosave;
end;

procedure TFrmGameToolsNew.A2ComboBox_ChangeMoveMagicDropDown(Sender: TObject);
begin
  A2ComboBox_ChangeMoveMagic.Items.Text := '无名步法' + #13#10 + HaveMagicClass.HaveMagic.getMoveMagicNameList;
  autosave;
end;

procedure TFrmGameToolsNew.A2ILabel_BackEatMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmGameToolsNew.A2ILabel_walkMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmGameToolsNew.A2ILabel_shoutMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmGameToolsNew.A2ILabel_pickMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmGameToolsNew.A2ILabel_attackMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmGameToolsNew.A2ILabel_showMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  GameHint.Close;
end;

procedure TFrmGameToolsNew.A2Button11Click(Sender: TObject);
begin
  if StrToInt(A2Edit1.Text) <= 100 then
    A2Edit1.Text := IntToStr(StrToInt(A2Edit1.Text) + 1);
  autosave;

end;

procedure TFrmGameToolsNew.A2Button12Click(Sender: TObject);
begin
  if StrToInt(A2Edit1.Text) > 0 then
    A2Edit1.Text := IntToStr(StrToInt(A2Edit1.Text) - 1);
  autosave;
end;

procedure TFrmGameToolsNew.A2Edit1Change(Sender: TObject);
begin
  if A2Edit1.Text = '' then
    A2Edit1.Text := '1';
  if StrToInt(trim(A2Edit1.Text)) >= StrToInt(trim(A2Edit_Life.Text)) then
    A2Edit1.Text := trim(A2Edit_Life.Text);
  if StrToInt(trim(A2Edit_Life.Text)) < 1 then
    A2Edit_Life.Text := '1';
  autosave;
//    if StrToInt(trim(A2Edit1.Text)) > 100 then A2Edit_Life.Text := '100';
end;

procedure TFrmGameToolsNew.SetConfigFileName;
begin
  FConfigFileName := 'GameTools.xml';

end;

procedure TFrmGameToolsNew.SetNewVersion;
begin
  inherited;
end;

//procedure TFrmGameToolsNew.SetNewVersionOld;
//begin
//  SetImage;
//end;

procedure TFrmGameToolsNew.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);


  SetControlPos(A2Panel_attack);
  SetControlPos(A2Panel_eatblood);
  SetControlPos(A2Panel_pick);
  SetControlPos(A2Panel_ShouName);
  SetControlPos(A2Panel_shout);
  SetControlPos(A2Panel_walk);
  SetControlPos(A2ILabel_BackEat);
  SetControlPos(A2ILabel_pick);
  SetControlPos(A2ILabel_walk);
  SetControlPos(A2ILabel_show);
  SetControlPos(A2ILabel_attack);
  SetControlPos(A2ILabel_shout);
  SetControlPos(A2Button_Eat);
  SetControlPos(A2Button_Pick);
  SetControlPos(A2Button_Shout);
  SetControlPos(A2Button_Walk);
  SetControlPos(A2Button_Attack);
  SetControlPos(A2Button_Show);
  SetControlPos(A2ILabel_top);
  SetControlPos(A2ILabel_bottom);
  SetControlPos(A2ILabel_button);
  SetControlPos(A2Button_close);
  SetControlPos(A2Button_Read);
  SetControlPos(A2Button_Save);
  SetControlPos(A2CheckBox1);
  SetControlPos(A2CheckBox_inPower);
  SetControlPos(A2CheckBox_outPower);
  SetControlPos(A2CheckBox_Magic);
  SetControlPos(A2CheckBox_Life);
  SetControlPos(A2Button1);
  SetControlPos(A2Button2);
  SetControlPos(A2Button3);
  SetControlPos(A2Button4);
  SetControlPos(A2Button5);
  SetControlPos(A2Button6);
  SetControlPos(A2Button7);
  SetControlPos(A2Button8);
  SetControlPos(A2Button11);
  SetControlPos(A2Button12);
  SetControlPos(A2Button9);
  SetControlPos(A2Button10);
  SetControlPos(A2CheckBox_Pick);
  SetControlPos(A2CheckBox_Opposite);
  SetControlPos(A2Button_Add);
  SetControlPos(A2Button_Dec);
  SetControlPos(A2CheckBox12);
  SetControlPos(A2Button21);
  SetControlPos(A2Button22);
  SetControlPos(A2Button_AddShout);
  SetControlPos(A2Button_DelShout);
  SetControlPos(A2ListBox_ShoutList);
  SetControlPos(A2CheckBox_MoveOpenMagic);
  SetControlPos(A2CheckBox11);
  SetControlPos(A2Button13);
  SetControlPos(A2Button14);
  SetControlPos(A2Button15);
  SetControlPos(A2Button16);
  SetControlPos(A2Button17);
  SetControlPos(A2Button18);
  SetControlPos(A2Button19);
  SetControlPos(A2Button20);
  SetControlPos(A2CheckBox_Hit_not_Shift);
  SetControlPos(A2CheckBox_Hit_not_Ctrl);
  SetControlPos(A2CheckBox_autoHIt);
  SetControlPos(A2CheckBox_ShowAllName);
  SetControlPos(A2CheckBox_ShowMonster);
  SetControlPos(A2CheckBox_ShowNpc);
  SetControlPos(A2CheckBox_ShowPlayer1);
  SetControlPos(A2CheckBox_ShowItem);
  SetControlPos(A2ComboBox_inPower);
  SetControlPos(A2ComboBox_Life);
  SetControlPos(A2ComboBox_Magic);
  SetControlPos(A2ComboBox_outPower);
  SetControlPos(A2ComboBox1);
  SetControlPos(A2Edit_delayTimeEat);
  SetControlPos(A2Edit_inPower);
  SetControlPos(A2Edit_Life);
  SetControlPos(A2Edit_Magic);
  SetControlPos(A2Edit_outPower);
  SetControlPos(A2Edit1);
  SetControlPos(A2ListBox_Itemlist);
  SetControlPos(A2Edit6);
  SetControlPos(A2Edit_AddShout);
  SetControlPos(A2ILabel_shout);
  SetControlPos(A2ComboBox_ChangeMoveMagic);
  SetControlPos(A2Edit10);
  SetControlPos(A2Edit7);
  SetControlPos(A2Edit8);
  SetControlPos(A2Edit9);
  SetControlPos(A2Edit11);
  SetControlPos(A2CheckBox_ProtectMagic);
  SetControlPos(A2ComboBox_ProtectMagic);
  SetControlPos(A2CheckBoxThreePower);
  SetControlPos(A2CheckBox_MonsterHit);
  SetControlPos(A2ListBox_DropItemlist);
  SetControlPos(A2ComboBox_MonsterList);
  SetControlPos(A2CheckBox_CounterAttack);
  SetControlPos(A2CheckBox_BossKey);
  SetControlPos(A2Edit_BossKey);
  SetControlPos(A2CheckBox_CounterAttackUser);
  SetControlPos(A2CheckBox_QieHuan);
  SetControlPos(A2CheckBox_CL);
  SetControlPos(A2ComboBox_CLWG);
  SetControlPos(A2Label_AddQieHuan);
  A2Edit_BossKey.Text := 'CTRL+ALT+F12';
  A2Edit_BossKey.Enabled := False;
end;

procedure TFrmGameToolsNew.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TFrmGameToolsNew.autosave;
begin
  if not FISShow then
    Exit;
  savetofile(CharCenterName);
end;

procedure TFrmGameToolsNew.A2CheckBox_autoHItClick(Sender: TObject);
begin
  inherited;

  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_Hit_not_CtrlClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_Hit_not_ShiftClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_inPowerClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_LifeClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_MagicClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_outPowerClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox1Click(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2ComboBox_inPowerChange(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2ComboBox_LifeChange(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2ComboBox_MagicChange(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2ComboBox_outPowerChange(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_OppositeClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_PickClick(Sender: TObject);
var
  cl: TCharClass;
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_ShowItemClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_ShowMonsterClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_ShowNpcClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_ShowPlayer1Click(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox12Click(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_MoveOpenMagicClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox11Click(Sender: TObject);
begin
  inherited;
  autosave;    

  AutoMove_X1 := 0;
  AutoMove_Y1 := 0;
  AutoMove_X2 := 0;
  AutoMove_Y2 := 0;
end;

procedure TFrmGameToolsNew.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FISShow := False;
end;

procedure TFrmGameToolsNew.A2ComboBox_ProtectMagicDropDown(Sender: TObject);
begin
  inherited;
  //A2ComboBox_ProtectMagic.Items.Text := '无名强身' + #13#10 + HaveMagicClass.DefaultMagic.getProtectMagicNameList + HaveMagicClass.HaveMagic.getProtectMagicNameList + HaveMagicClass.HaveRiseMagic.getProtectMagicNameList; //修改新增获取2层护体
  A2ComboBox_ProtectMagic.Items.Text := HaveMagicClass.DefaultMagic.getProtectMagicNameList + HaveMagicClass.HaveMagic.getProtectMagicNameList + HaveMagicClass.HaveRiseMagic.getProtectMagicNameList; //修改新增获取2层护体
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_ProtectMagicClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBoxThreePowerClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2ComboBox_MonsterListDropDown(Sender: TObject);
var
  i: Integer;
  cl, tmp: TCharClass;
  j: Integer;
  have: Boolean;
  tmplist: TStringKeyClass;
  v: TVirtualObjectClass;
  sslist: TStringList;
begin
  inherited;

  tmp := CharList.CharGet(CharCenterId);
  if tmp = nil then
    exit;
  A2ComboBox_MonsterList.Clear;
  for i := 0 to High(Box_Monster) do begin
    A2ComboBox_MonsterList.AddItem(Box_Monster[i], nil);
  end;

//  try
//    tmplist := TStringKeyClass.Create;
//    sslist := TStringList.Create;
//    sslist.CommaText := CharList.CharGetAllMonsterName;
//
//    for i := 0 to sslist.Count - 1 do
//    begin
//      have := False;
//      for j := 0 to A2ComboBox_MonsterList.Items.Count - 1 do
//      begin
//        if A2ComboBox_MonsterList.Items[j] = sslist[i] then
//        begin
//          have := True;
//          Break;
//        end;
//
//      end;
//      if not have then
//        A2ComboBox_MonsterList.AddItem(sslist[i], nil);
//    end;
//  finally
//    sslist.Free;
//    tmplist.Free;
//  end;

end;

procedure TFrmGameToolsNew.A2CheckBox_MonsterHitClick(Sender: TObject);
begin
  inherited;
  if A2CheckBox_MonsterHit.Checked then
  begin
    G_AutoHitCharPosX := CharPosX;
    G_AutoHitCharPosY := CharPosY;
  end
  else
  begin
    G_AutoHitCharPosX := 0;
    G_AutoHitCharPosY := 0;
  end;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_CounterAttackClick(Sender: TObject);
var
  key: Word;
begin
  inherited;
  key := VK_RETURN;
  if A2CheckBox_CounterAttack.Checked then
    FrmBottom.sendsay('@反击开启', key)
  else
    FrmBottom.sendsay('@反击关闭', key);
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_BossKeyClick(Sender: TObject);
begin
  inherited;
  if A2CheckBox_BossKey.Checked then
  begin
    FrmM.RegHotKey;
  end
  else
  begin
    FrmM.UnRegHotKey;
  end;
  autosave;
end;

procedure TFrmGameToolsNew.A2CheckBox_CounterAttackUserClick(Sender: TObject);
var
  key: Word;
begin
  inherited;
  key := VK_RETURN;
  if A2CheckBox_CounterAttackUser.Checked then
    FrmBottom.sendsay('@反击玩家开启', key)
  else
    FrmBottom.sendsay('@反击玩家关闭', key);
  autosave;
end;

procedure TFrmGameToolsNew.A2ListBox_DropItemlistDblClick(Sender: TObject); //2015.11.16 在水一方
var
  str, rdstr: string;
begin
  inherited;
  str := A2ListBox_DropItemlist.Items[A2ListBox_DropItemlist.ItemIndex];
  //查找:符号
  str := GetValidStr3(str, rdstr, ':');
  A2Edit6.Text := rdstr;
end;

procedure TFrmGameToolsNew.A2CheckBox_QieHuanClick(Sender: TObject);
begin
  inherited;
  autosave;
end;

procedure TFrmGameToolsNew.A2Label_AddQieHuanClick(Sender: TObject);
begin
  inherited;
  FrmGameToolsAssist.ShowModal;
end;

end.

