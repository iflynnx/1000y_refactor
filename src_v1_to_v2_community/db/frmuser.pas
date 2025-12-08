unit frmUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, deftype, uKeyClass, aUtil32;

type
  TitemListdataType = (ildt_HAVEITEM, ildt_ItemLog, ildt_WEAR, ildt_FASHION, ildt_Auction, ildt_Email);
  TitemListdata = record
    rid: integer;
    rUserName: string[64];
    rtype: TitemListdataType;
    ritem: TDBItemData;
  end;
  pTitemListdata = ^TitemListdata;

  TbqListdata = record
    rid: integer;
    rUserName: string[64];
    rnum: Int64;
  end;
  pTbqListdata = ^TbqListdata;

  TItemUserListclass = class
  private
    fautoid: integer;
    data: Tlist;

    procedure clear;
  public
    constructor Create();
    destructor Destroy; override;
    procedure add(aitem: TitemListdata);
    function get(aid: integer): pTitemListdata;
    procedure del(aid: integer);
        //统计指令
    function getNameList(aname: string): string;
    procedure Sort;
  end;

  TbquserListclass = class
  private
    fautoid: integer;
    data: Tlist;
    procedure clear;
  public
    constructor Create();
    destructor Destroy; override;
    procedure add(aitem: TbqListdata);
    function get(aid: integer): pTbqListdata;
    procedure del(aid: integer);
        //统计指令
    function getNameList: string;
    procedure Sort;
  end;

  TDBUserWindowsState = (DBUWS_BASIC, DBUWS_MAGIC, DBUWS_ITEM, DBUWS_QUEST);
    //                     基本            武功        物品        任务

  TDBMagicSelectState = (DBMSS_BASIC, DBMSS_BASIC2, DBMSS_MAGIC, DBMSS_MAGIC2);
    //                       基本           不羁           武功           上层


  TDBItemSelectState = (DBISS_HAVEITEM, DBISS_ItemLog, DBISS_WEAR, DBISS_FASHION);
    //                     背包             仓库            穿戴          时装
  TFormUser = class(TForm)
    Panel_head: TPanel;
    Button_save: TButton;
    Panel_log: TPanel;
    Memo_log: TMemo;
    Panel_item_edit: TPanel;
    Panel4: TPanel;
    Label31: TLabel;
    Button_windows_item_close: TButton;
    Label15: TLabel;
    Edit_item_id: TEdit;
    Label16: TLabel;
    Edit_item_name: TEdit;
    Label17: TLabel;
    Edit_item_count: TEdit;
    Label18: TLabel;
    Edit_item_color: TEdit;
    Label19: TLabel;
    Edit_item_durability: TEdit;
    Label20: TLabel;
    Edit_item_durabilitymax: TEdit;
    Label21: TLabel;
    Edit_item_smithingLevel: TEdit;
    Label22: TLabel;
    Edit_item_Additional: TEdit;
    Label23: TLabel;
    edit_item_LockState: TEdit;
    Label24: TLabel;
    Edit_item_Locktime: TEdit;
    Label25: TLabel;
    Edit_item_DataTime: TEdit;
    GroupBox1: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Edit_item_SettingCount: TEdit;
    Edit_item_Setting1: TEdit;
    Edit_item_Setting2: TEdit;
    Edit_item_Setting3: TEdit;
    Edit_item_Setting4: TEdit;
    Button_windows_item_save: TButton;
    Label29: TLabel;
    Label30: TLabel;
    pageEdit: TPageControl;
    TabSheet_basic: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Edit_db_name: TEdit;
    Edit_ID: TEdit;
    Edit_MasterName: TEdit;
    Edit_Password: TEdit;
    Edit_GroupKey: TEdit;
    Edit_Guild: TEdit;
    Edit_LastDate: TEdit;
    Edit_CreateDate: TEdit;
    Edit_ServerId: TEdit;
    Edit_x: TEdit;
    Edit_y: TEdit;
    Edit_GOLD_Money: TEdit;
    Edit_prestige: TEdit;
    Edit_Light: TEdit;
    Edit_dark: TEdit;
    Edit_Energy: TEdit;
    Edit_InPower: TEdit;
    Edit_OutPower: TEdit;
    Edit_Magic: TEdit;
    Edit_Life: TEdit;
    Edit_Talent: TEdit;
    Edit_GoodChar: TEdit;
    Edit_BadChar: TEdit;
    Edit_Adaptive: TEdit;
    Edit_Revival: TEdit;
    Edit_Immunity: TEdit;
    Edit_Virtue: TEdit;
    Edit_CurEnergy: TEdit;
    Edit_CurInPower: TEdit;
    Edit_CurOutPower: TEdit;
    Edit_CurMagic: TEdit;
    Edit_CurLife: TEdit;
    Edit_CurHealth: TEdit;
    Edit_CurSatiety: TEdit;
    Edit_CurPoisoning: TEdit;
    Edit_CurHeadSeek: TEdit;
    Edit_CurArmSeek: TEdit;
    Edit_CurLegSeek: TEdit;
    Edit_ExtraExp: TEdit;
    Edit_AddableStatePoint: TEdit;
    Edit_TotalStatePoint: TEdit;
    Edit_CurrentGrade: TEdit;
    Edit_FashionableDress: TEdit;
    Edit_JobKind: TEdit;
    ComboBox_Sex: TComboBox;
    TabSheet_Magic: TTabSheet;
    StringGrid_Magic: TStringGrid;
    Panel_Magic: TPanel;
    ComboBox_Magic: TComboBox;
    Button_edit_Magic_update: TButton;
    Panel_Edit_Magic: TPanel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Panel5: TPanel;
    Label64: TLabel;
    Button_Edit_Magic_save: TButton;
    Button_Edit_Magic_close: TButton;
    Edit_Magic_ID: TEdit;
    Edit_Magic_Name: TEdit;
    Edit_Magic_Skill: TEdit;
    TabSheet_Item: TTabSheet;
    StringGrid_Item: TStringGrid;
    Panel_Item: TPanel;
    ComboBox_Item: TComboBox;
    Button_Change_Item: TButton;
    TabSheet_Quest: TTabSheet;
    Panel_Quest: TPanel;
    Label93: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label127: TLabel;
    Label122: TLabel;
    Button_Quest_save: TButton;
    Edit_Quest_Temp9: TEdit;
    Edit_Quest_Temp8: TEdit;
    Edit_Quest_Temp19: TEdit;
    Edit_Quest_Temp7: TEdit;
    Edit_Quest_Temp14: TEdit;
    Edit_Quest_Temp13: TEdit;
    Edit_Quest_Temp12: TEdit;
    Edit_Quest_Temp11: TEdit;
    Edit_Quest_Temp10: TEdit;
    Edit_Quest_Temp6: TEdit;
    Edit_Quest_Temp5: TEdit;
    Edit_Quest_Temp4: TEdit;
    Edit_Quest_Temp3: TEdit;
    Edit_Quest_Temp2: TEdit;
    Edit_Quest_Temp1: TEdit;
    Edit_Quest_Temp0: TEdit;
    Edit_Quest_Step: TEdit;
    Edit_Quest_CurNo: TEdit;
    Edit_Quest_ComNo: TEdit;
    Edit_Quest_Temp15: TEdit;
    Edit_Quest_Temp16: TEdit;
    Edit_Quest_Temp17: TEdit;
    Edit_Quest_Temp18: TEdit;
    Edit_SubQuest_SubNo: TEdit;
    Edit_SubQuest_Step: TEdit;
    TabSheet_key: TTabSheet;
    StringGrid_key: TStringGrid;
    Panel6: TPanel;
    Button_change_key: TButton;
    Panel_key: TPanel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label80: TLabel;
    Panel9: TPanel;
    Label68: TLabel;
    Button_key_save: TButton;
    Button_key_close: TButton;
    Edit_key0: TEdit;
    Edit_key1: TEdit;
    Edit_key4: TEdit;
    Edit_key5: TEdit;
    Edit_key6: TEdit;
    Edit_key7: TEdit;
    Edit_key8: TEdit;
    Edit_lkey: TEdit;
    Edit_key3: TEdit;
    Edit_key2: TEdit;
    Edit_key9: TEdit;
    TabSheet_ShortcutKey: TTabSheet;
    StringGrid_ShortcutKey: TStringGrid;
    Panel7: TPanel;
    Button_change_CutKey: TButton;
    Panel_cutkey_edit: TPanel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Panel10: TPanel;
    Label81: TLabel;
    Button_change_cutkey_save: TButton;
    Button_change_cutkey_close: TButton;
    Edit_cutkey7: TEdit;
    Edit_cutkey2: TEdit;
    Edit_cutkey6: TEdit;
    Edit_cutkey5: TEdit;
    Edit_cutkey4: TEdit;
    Edit_cutkey3: TEdit;
    Edit_cutkey8: TEdit;
    Edit_cutlkey: TEdit;
    Edit_cutkey0: TEdit;
    Edit_cutkey9: TEdit;
    Edit_cutkey1: TEdit;
    Button_basic_save: TButton;
    Panel_find: TPanel;
    Button_find: TButton;
    Edit_name: TEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label79: TLabel;
    Edit_item_damageBody: TEdit;
    Label94: TLabel;
    Edit_item_damageHead: TEdit;
    Label114: TLabel;
    Edit_item_damageArm: TEdit;
    Label115: TLabel;
    Edit_item_damageLeg: TEdit;
    Label116: TLabel;
    Edit_item_AttackSpeed: TEdit;
    Label117: TLabel;
    Edit_item_avoid: TEdit;
    Label123: TLabel;
    Edit_item_armorBody: TEdit;
    Label126: TLabel;
    Edit_item_armorHead: TEdit;
    Label128: TLabel;
    Edit_item_armorArm: TEdit;
    Label129: TLabel;
    Edit_item_armorLeg: TEdit;
    Label130: TLabel;
    Edit_item_recovery: TEdit;
    Label131: TLabel;
    Edit_item_accuracy: TEdit;
    Panel_sum_count: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Edit_itemcount_find: TEdit;
    Button_itemcount_find: TButton;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Button4: TButton;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Edit_tian: TEdit;
    Edit_di: TEdit;
    Edit_ren: TEdit;
    Edit_newTalent: TEdit;
    Label150: TLabel;
    Edit_newTalentExp: TEdit;
    Label151: TLabel;
    Edit_newTalentLv: TEdit;
    Label152: TLabel;
    Edit_newBone: TEdit;
    Label153: TLabel;
    Label154: TLabel;
    Edit_newLeg: TEdit;
    Label155: TLabel;
    Edit_newSavvy: TEdit;
    Label156: TLabel;
    Edit_newAttackPower: TEdit;
    Label157: TLabel;
    Edit_newBindMoney: TEdit;
    Edit_MagicExpMulCount: TEdit;
    Label158: TLabel;
    Label159: TLabel;
    Edit_MagicExpMulEndTime: TEdit;
    lblLabel160: TLabel;
    Edit_VipUseLevel: TEdit;
    Edit_VipUseTime: TEdit;
    lblLabel161: TLabel;
    btnyace: TButton;
    lbl1: TLabel;
    Edit_ComplexExp: TEdit;
    lbl2: TLabel;
    Edit_guildPoint: TEdit;
    btn_bq: TButton;
    btnloaduserlist: TButton;
    UserList: TListBox;
    btnjiazai: TButton;
    dlgOpen1: TOpenDialog;
        //查找按钮点击
    procedure Button_findClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid_ItemSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure StringGrid_ItemClick(Sender: TObject);
        //修改武功
    procedure Button_edit_Magic_updateClick(Sender: TObject);
        //武功编辑框保存按钮
    procedure Button_Edit_Magic_closeClick(Sender: TObject);
        //武功编辑框保存按钮
    procedure Button_Edit_Magic_saveClick(Sender: TObject);
        //武功修改状态
    procedure ComboBox_MagicChange(Sender: TObject);

        //物品编辑框保存按钮
    procedure Button_windows_item_saveClick(Sender: TObject);
        //物品修改状态
    procedure ComboBox_ItemChange(Sender: TObject);
        //物品编辑框关闭按钮
    procedure Button_windows_item_closeClick(Sender: TObject);
        //物品修改
    procedure Button_Change_ItemClick(Sender: TObject);

        //写入数据库
    procedure Button_saveClick(Sender: TObject);
    procedure Button_change_keyClick(Sender: TObject);
    procedure Button_change_CutKeyClick(Sender: TObject);
    procedure Button_key_closeClick(Sender: TObject);
    procedure Button_change_cutkey_closeClick(Sender: TObject);
    procedure Button_change_cutkey_saveClick(Sender: TObject);
    procedure Button_key_saveClick(Sender: TObject);
    procedure Button_Quest_saveClick(Sender: TObject);
    procedure Button_basic_saveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button_itemcount_findClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnyaceClick(Sender: TObject);
    procedure btn_bqClick(Sender: TObject);
    procedure btnloaduserlistClick(Sender: TObject);
    procedure UserListDblClick(Sender: TObject);
    procedure btnjiazaiClick(Sender: TObject);

  private
    fUserWiondowState: TDBUserWindowsState;
        //基本
    procedure WriteUserMagicData();
        //物品
    procedure WriteUserItemData();
        //快捷键
    procedure WriteUserKeyData();
        //新功能键
    procedure WriteUserCutKeyData();

  public
    ItemUserListclass: TItemUserListclass;
    bquserListclass: TbquserListclass;
    UserData: TDBRecord;
    procedure clear();

    procedure ShowUserBasicData();
    procedure ShowUserMagicData(astr: string);
    procedure ShowUserItemData(astr: string);
    procedure ShowKeyData();
    procedure ShowCutKeyData();
    procedure ShowUserQuestData();
  end;




var
  FormUser: TFormUser;

implementation
uses uDBAdapter, UnitItemEditWin;
{$R *.dfm}

function ListSort(APt1, APt2: Pointer): Integer;
var
  P1, P2: pTitemListdata;
begin
  P1 := APt1;
  p2 := APt2;
  if p1.ritem.rCount = p2.ritem.rCount then
    Result := 0
  else if p1.ritem.rCount < p2.ritem.rCount then
    Result := 1
  else
    Result := -1;
end;

function ListbqSort(APt1, APt2: Pointer): Integer;
var
  P1, P2: pTbqListdata;
begin
  P1 := APt1;
  p2 := APt2;
  if p1.rnum = p2.rnum then
    Result := 0
  else if p1.rnum < p2.rnum then
    Result := 1
  else
    Result := -1;
end;

procedure TFormUser.clear;
begin
  fillchar(UserData, sizeof(UserData), 0);
  Panel_find.Visible := true;
  pageEdit.Visible := false;
  //  Button_save.Visible := false;
end;

//查找按钮点击

procedure TFormUser.Button_findClick(Sender: TObject);
var
  fresult: integer;
begin
  clear;
  Edit_name.Text := trim(Edit_name.Text);
  fresult := UserDBAdapter.UserSelect(Edit_name.Text, @UserData);
  case fresult of
    DB_OK:
      begin
               // Panel_find.Visible := false;
        pageEdit.Visible := true;
        pageEdit.Enabled := true;
              //  Button_save.Visible := true;

        ShowUserBasicData();
        ShowUserMagicData(ComboBox_Magic.Text);
        ShowUserItemData(ComboBox_Item.Text);
        ShowKeyData();
        ShowCutKeyData();
        ShowUserQuestData();
      end;
    DB_ERR_NOTFOUND: ShowMessage('角色不存在');
  else
    begin
      ShowMessage('未知错误' + inttostr(fresult));
    end;
  end;

end;
//写入数据库




procedure TFormUser.Button_saveClick(Sender: TObject);
var
  fresult: integer;
begin
  Edit_name.Text := trim(Edit_name.Text);
  fresult := UserDBAdapter.UserUpdate(Edit_name.Text, @UserData);
  if fresult = DB_OK then
  begin
    ShowMessage('保存成功' + inttostr(fresult));
    clear;
  end else
  begin
    ShowMessage('保存错误' + inttostr(fresult));
  end;
end;

//基本数据

procedure TFormUser.ShowUserBasicData();
var
  f: TFormatSettings;
begin
  f.ShortDateFormat := 'yyyy-MM-dd';
  f.DateSeparator := '-';
  f.TimeSeparator := ':';
  f.LongTimeFormat := 'hh:mm:ss';

  Edit_db_name.Text := UserData.PrimaryKey;
  Edit_ID.Text := UserData.PrimaryKey;


  Edit_MasterName.Text := Userdata.MasterName;
  Edit_Password.Text := UserData.Password;
  Edit_GroupKey.Text := IntToStr(UserData.GroupKey);
  Edit_Guild.Text := UserData.Guild;
  Edit_LastDate.Text := DateTimeToStr(UserData.LastDate, f);
  Edit_CreateDate.Text := DateTimeToStr(UserData.CreateDate, f);
  ComboBox_Sex.Text := BoolToStr(UserData.Sex);
  Edit_ServerId.Text := IntToStr(UserData.ServerId);
  Edit_x.Text := IntToStr(UserData.x);

  Edit_y.Text := IntToStr(UserData.y);
  Edit_GOLD_Money.Text := IntToStr(UserData.GOLD_Money);
  Edit_prestige.Text := IntToStr(UserData.prestige);
  Edit_Light.Text := IntToStr(UserData.Light);
  Edit_dark.Text := IntToStr(UserData.Dark);
  Edit_Energy.Text := IntToStr(UserData.Energy);
  Edit_InPower.Text := IntToStr(UserData.InPower);
  Edit_OutPower.Text := IntToStr(UserData.OutPower);
  Edit_Magic.Text := IntToStr(UserData.Magic);

  Edit_Life.Text := IntToStr(UserData.Life);
  Edit_Talent.Text := IntToStr(UserData.Talent);
  Edit_GoodChar.Text := IntToStr(UserData.GoodChar);
  Edit_BadChar.Text := IntToStr(UserData.BadChar);
  Edit_Adaptive.Text := IntToStr(UserData.Adaptive);
  Edit_Revival.Text := IntToStr(UserData.Revival);
  Edit_Immunity.Text := IntToStr(UserData.Immunity);
  Edit_Virtue.Text := IntToStr(UserData.Virtue);
  Edit_CurEnergy.Text := IntToStr(UserData.CurEnergy);
  Edit_CurInPower.Text := IntToStr(UserData.CurInPower);
  Edit_CurOutPower.Text := IntToStr(UserData.CurOutPower);
  Edit_CurMagic.Text := IntToStr(UserData.CurMagic);
  Edit_CurLife.Text := IntToStr(UserData.CurLife);
  Edit_CurHealth.Text := IntToStr(UserData.CurHealth);
  Edit_CurSatiety.Text := IntToStr(UserData.CurSatiety);
  Edit_CurPoisoning.Text := IntToStr(UserData.CurPoisoning);
  Edit_CurHeadSeek.Text := IntToStr(UserData.CurHeadSeek);
  Edit_CurArmSeek.Text := IntToStr(UserData.CurArmSeek);
  Edit_CurLegSeek.Text := IntToStr(UserData.CurLegSeek);
  Edit_ExtraExp.Text := IntToStr(UserData.ExtraExp);
  Edit_AddableStatePoint.Text := IntToStr(UserData.AddableStatePoint);
  Edit_TotalStatePoint.Text := IntToStr(UserData.TotalStatePoint);
  Edit_CurrentGrade.Text := IntToStr(UserData.CurrentGrade);
  Edit_FashionableDress.Text := boolToStr(UserData.FashionableDress);
  Edit_JobKind.Text := IntToStr(UserData.JobKind);

  Edit_tian.Text := IntToStr(UserData.r3f_sky);
  Edit_di.Text := IntToStr(UserData.r3f_terra);
  Edit_ren.Text := IntToStr(UserData.r3f_fetch);

  Edit_newTalent.Text := IntToStr(UserData.newTalent); //天赋点
  Edit_newTalentExp.Text := IntToStr(UserData.newTalentExp); //天赋经验
  Edit_newTalentLv.Text := IntToStr(UserData.newTalentLv); //天赋级别
  Edit_newBone.Text := IntToStr(UserData.newBone); //根骨
  Edit_newLeg.Text := IntToStr(UserData.newLeg); //身法
  Edit_newSavvy.Text := IntToStr(UserData.newSavvy); //悟性
  Edit_newAttackPower.Text := IntToStr(UserData.newAttackPower); //武学
  Edit_newBindMoney.Text := IntToStr(UserData.newBindMoney); //绑定钱币

  Edit_MagicExpMulCount.Text := IntToStr(UserData.MagicExpMulCount); //经验倍数
  Edit_MagicExpMulEndTime.Text := IntToStr(UserData.MagicExpMulEndTime); //经验结束时间

  Edit_VipUseLevel.Text := IntToStr(UserData.VipUseLevel); //VIP等级
  Edit_VipUseTime.Text := DateTimeToStr(UserData.VipUseTime, f); //VIP时间

  Edit_ComplexExp.Text := IntToStr(UserData.ComplexExp); //合成熟练度
  Edit_guildPoint.Text := IntToStr(UserData.guildPoint); //合成熟练度



end;
//===================================物品===================================================//
//物品修改按钮

procedure TFormUser.Button_Change_ItemClick(Sender: TObject);
  procedure _itemtowindows(var dataarr: array of TDBItemData);
  var
    arow: integer;
    frmItemEdit: TfrmItemEdit;
  begin
    arow := StringGrid_Item.Selection.Top;
    arow := arow - 1;
    if (arow < 0) or (arow > high(dataarr)) then exit;
    frmItemEdit := TfrmItemEdit.Create(self);
    try
      frmItemEdit.Left := Left + 168;
      frmItemEdit.Top := top + 113;
      frmItemEdit.itemtowindows(dataarr[arow]);
      frmItemEdit.ShowModal;
      dataarr[arow] := frmItemEdit.tempitem;
    finally
      frmItemEdit.Free;
    end;
       { Edit_item_id.Text := IntToStr(dataarr[arow].rID);
        Edit_item_name.Text := dataarr[arow].rName;
        Edit_item_count.Text := IntToStr(dataarr[arow].rCount);
        Edit_item_color.Text := IntToStr(dataarr[arow].rColor);
        Edit_item_durability.Text := IntToStr(dataarr[arow].rDurability);
        Edit_item_durabilitymax.Text := IntToStr(dataarr[arow].rDurabilityMAX);
        Edit_item_smithingLevel.Text := IntToStr(dataarr[arow].rSmithingLevel);
        Edit_item_Additional.Text := IntToStr(dataarr[arow].rAdditional);
        edit_item_LockState.Text := IntToStr(dataarr[arow].rlockState);
        Edit_item_Locktime.Text := IntToStr(dataarr[arow].rlocktime);
        Edit_item_DataTime.Text := DateTimeToStr(dataarr[arow].rDateTime);
        Edit_item_SettingCount.Text := IntToStr(dataarr[arow].rSetting.rsettingcount);
        Edit_item_Setting1.Text := dataarr[arow].rSetting.rsetting1;
        Edit_item_Setting2.Text := dataarr[arow].rSetting.rsetting2;
        Edit_item_Setting3.Text := dataarr[arow].rSetting.rsetting3;
        Edit_item_Setting4.Text := dataarr[arow].rSetting.rsetting4;

        Edit_item_damageBody.Text := inttostr(dataarr[arow].rLifeDataLevel.damageBody);
        Edit_item_damageHead.Text := inttostr(dataarr[arow].rLifeDataLevel.damageHead);
        Edit_item_damageArm.Text := inttostr(dataarr[arow].rLifeDataLevel.damageArm);
        Edit_item_damageLeg.Text := inttostr(dataarr[arow].rLifeDataLevel.damageLeg);

        Edit_item_armorBody.Text := inttostr(dataarr[arow].rLifeDataLevel.armorBody);
        Edit_item_armorHead.Text := inttostr(dataarr[arow].rLifeDataLevel.armorHead);
        Edit_item_armorArm.Text := inttostr(dataarr[arow].rLifeDataLevel.armorArm);
        Edit_item_armorLeg.Text := inttostr(dataarr[arow].rLifeDataLevel.armorLeg);

        Edit_item_AttackSpeed.Text := inttostr(dataarr[arow].rLifeDataLevel.AttackSpeed);
        Edit_item_avoid.Text := inttostr(dataarr[arow].rLifeDataLevel.avoid);
        Edit_item_recovery.Text := inttostr(dataarr[arow].rLifeDataLevel.recovery);
        Edit_item_accuracy.Text := inttostr(dataarr[arow].rLifeDataLevel.accuracy);
        }
  end;

begin
    //Panel_item_edit.Visible := false;
  if ComboBox_Item.Text = '仓库' then _itemtowindows(UserData.ItemLog.data)
  else if ComboBox_Item.Text = '背包' then _itemtowindows(UserData.HaveItemArr)
  else if ComboBox_Item.Text = '穿戴' then _itemtowindows(UserData.WearItemArr)
  else if ComboBox_Item.Text = '时装' then _itemtowindows(UserData.FashionableDressArr)
  else exit;

   { Panel_item_edit.Left := 168;
    Panel_item_edit.Top := 113;
    Panel_item_edit.Visible := true;
    pageEdit.Enabled := false;
    }
end;

procedure TFormUser.Button_windows_item_closeClick(Sender: TObject);
begin
  ShowUserItemData(ComboBox_Item.Text);
  Panel_item_edit.Visible := false;
  pageEdit.Enabled := true;
end;

procedure TFormUser.ShowUserItemData(astr: string);
  procedure _ShowUserItemData(var dataarr: array of TDBItemData);
  var
    id: integer;
  begin
    StringGrid_Item.RowCount := high(dataarr) + 2;
    for id := 0 to high(dataarr) do
    begin
      StringGrid_Item.Rows[id + 1].Strings[0] := IntToStr(id);
      StringGrid_Item.Rows[id + 1].Strings[1] := IntToStr(dataarr[id].rID);
      StringGrid_Item.Rows[id + 1].Strings[2] := dataarr[id].rName;
      StringGrid_Item.Rows[id + 1].Strings[3] := IntToStr(dataarr[id].rCount);
      StringGrid_Item.Rows[id + 1].Strings[4] := IntToStr(dataarr[id].rColor);
      StringGrid_Item.Rows[id + 1].Strings[5] := IntToStr(dataarr[id].rDurability);
      StringGrid_Item.Rows[id + 1].Strings[6] := IntToStr(dataarr[id].rDurabilityMAX);
      StringGrid_Item.Rows[id + 1].Strings[7] := IntToStr(dataarr[id].rSmithingLevel);
      StringGrid_Item.Rows[id + 1].Strings[8] := IntToStr(dataarr[id].rAttach);
      StringGrid_Item.Rows[id + 1].Strings[9] := IntToStr(dataarr[id].rlockState);
      StringGrid_Item.Rows[id + 1].Strings[10] := IntToStr(dataarr[id].rlocktime);
      StringGrid_Item.Rows[id + 1].Strings[11] := DateTimeToStr(dataarr[id].rDateTime);

      StringGrid_Item.Rows[id + 1].Strings[12] := IntToStr(dataarr[id].rSetting.rsettingcount);
      StringGrid_Item.Rows[id + 1].Strings[13] := dataarr[id].rSetting.rsetting1;
      StringGrid_Item.Rows[id + 1].Strings[14] := dataarr[id].rSetting.rsetting2;
      StringGrid_Item.Rows[id + 1].Strings[15] := dataarr[id].rSetting.rsetting3;
      StringGrid_Item.Rows[id + 1].Strings[16] := dataarr[id].rSetting.rsetting4;
    end;
  end;

begin
  Button_Change_Item.Enabled := false;
  if astr = '仓库' then _ShowUserItemData(UserData.ItemLog.data)
  else if astr = '背包' then _ShowUserItemData(UserData.HaveItemArr)
  else if astr = '穿戴' then _ShowUserItemData(UserData.WearItemArr)
  else if astr = '时装' then _ShowUserItemData(UserData.FashionableDressArr)
  else exit;
  Button_Change_Item.Enabled := true;
end;
//物品状态切换

procedure TFormUser.ComboBox_ItemChange(Sender: TObject);
begin
  ShowUserItemData(ComboBox_Item.Text);
end;

//物品修改界面保存按钮点击

procedure TFormUser.Button_windows_item_saveClick(Sender: TObject);
  procedure _itemsave(var dataarr: array of TDBItemData);
  var
    arow: integer;
  begin
    arow := StringGrid_Item.Selection.Top;
    arow := arow - 1;
    if (arow < 0) or (arow > high(dataarr)) then exit;
    dataarr[arow].rID := StrToInt(Edit_item_id.Text);
    dataarr[arow].rname := Edit_item_name.Text;
    dataarr[arow].rCount := StrToInt(Edit_item_count.Text);
    dataarr[arow].rColor := StrToInt(Edit_item_color.Text);
    dataarr[arow].rDurability := StrToInt(Edit_item_durability.Text);
    dataarr[arow].rDurabilityMAX := StrToInt(Edit_item_durabilitymax.Text);
    dataarr[arow].rSmithingLevel := StrToInt(Edit_item_smithingLevel.Text);
    dataarr[arow].rAttach := StrToInt(Edit_item_Additional.Text);
    dataarr[arow].rlockState := StrToInt(edit_item_LockState.Text);
    dataarr[arow].rlocktime := StrToInt(Edit_item_Locktime.Text);
    dataarr[arow].rDateTime := StrToDateTime(Edit_item_DataTime.Text);

    dataarr[arow].rSetting.rsettingcount := StrToInt(Edit_item_SettingCount.Text);
    dataarr[arow].rSetting.rsetting1 := Edit_item_Setting1.Text;
    dataarr[arow].rSetting.rsetting2 := Edit_item_Setting2.Text;
    dataarr[arow].rSetting.rsetting3 := Edit_item_Setting3.Text;
    dataarr[arow].rSetting.rsetting4 := Edit_item_Setting4.Text;

{        dataarr[arow].rLifeDataLevel.damageBody := strtoint(Edit_item_damageBody.Text);
        dataarr[arow].rLifeDataLevel.damageHead := strtoint(Edit_item_damageHead.Text);
        dataarr[arow].rLifeDataLevel.damageArm := strtoint(Edit_item_damageArm.Text);
        dataarr[arow].rLifeDataLevel.damageLeg := strtoint(Edit_item_damageLeg.Text);

        dataarr[arow].rLifeDataLevel.armorBody := strtoint(Edit_item_armorBody.Text);
        dataarr[arow].rLifeDataLevel.armorHead := strtoint(Edit_item_armorHead.Text);
        dataarr[arow].rLifeDataLevel.armorArm := strtoint(Edit_item_armorArm.Text);
        dataarr[arow].rLifeDataLevel.armorLeg := strtoint(Edit_item_armorLeg.Text);

        dataarr[arow].rLifeDataLevel.AttackSpeed := strtoint(Edit_item_AttackSpeed.Text);
        dataarr[arow].rLifeDataLevel.avoid := strtoint(Edit_item_avoid.Text);
        dataarr[arow].rLifeDataLevel.recovery := strtoint(Edit_item_recovery.Text);
        dataarr[arow].rLifeDataLevel.accuracy := strtoint(Edit_item_accuracy.Text);}
  end;

begin
  if ComboBox_Item.Text = '仓库' then _itemsave(UserData.ItemLog.data)
  else if ComboBox_Item.Text = '背包' then _itemsave(UserData.HaveItemArr)
  else if ComboBox_Item.Text = '穿戴' then _itemsave(UserData.WearItemArr)
  else if ComboBox_Item.Text = '时装' then _itemsave(UserData.FashionableDressArr)
  else exit;

  Button_windows_item_closeClick(Sender);
end;

procedure TFormUser.WriteUserItemData();
begin
    //ITEM
  StringGrid_Item.RowCount := 30;
  StringGrid_Item.ColCount := 17;
  StringGrid_Item.Rows[0].Strings[0] := 'lkey';
  StringGrid_Item.Rows[0].Strings[1] := 'rid';
  StringGrid_Item.Rows[0].Strings[2] := 'rname';
  StringGrid_Item.Rows[0].Strings[3] := 'rcount';
  StringGrid_Item.Rows[0].Strings[4] := 'rcolor';
  StringGrid_Item.Rows[0].Strings[5] := 'rDurability';
  StringGrid_Item.Rows[0].Strings[6] := 'rDurabulityMax';
  StringGrid_Item.Rows[0].Strings[7] := 'rSmithingLevel';
  StringGrid_Item.Rows[0].Strings[8] := 'rAdditional';
  StringGrid_Item.Rows[0].Strings[9] := 'rlockState';
  StringGrid_Item.Rows[0].Strings[10] := 'rlocktime';
  StringGrid_Item.Rows[0].Strings[11] := 'rdatetime';
  StringGrid_Item.Rows[0].Strings[12] := 'rsettingcount';
  StringGrid_Item.Rows[0].Strings[13] := 'rsetting1';
  StringGrid_Item.Rows[0].Strings[14] := 'rsetting2';
  StringGrid_Item.Rows[0].Strings[15] := 'rsetting3';
  StringGrid_Item.Rows[0].Strings[16] := 'rsetting4';
end;
//===============================武功======================================================//
//显示武功信息

procedure TFormUser.ShowUserMagicData(astr: string);
var
  i: integer;
begin
    // clearStringGrid(StringGrid_Magic);
  StringGrid_Magic.Enabled := false;
  Button_edit_Magic_update.Enabled := false;
  if astr = '基本' then
  begin
    StringGrid_Magic.RowCount := high(UserData.BasicMagicArr) + 2;
    for i := 0 to high(UserData.BasicMagicArr) do
    begin
      StringGrid_Magic.Rows[i + 1].Strings[0] := IntToStr(i);
      StringGrid_Magic.Rows[i + 1].Strings[1] := UserData.BasicMagicArr[i].rName;
      StringGrid_Magic.Rows[i + 1].Strings[2] := IntToStr(UserData.BasicMagicArr[i].rSkill);
    end;
  end
  else if astr = '不羁' then
  begin
    StringGrid_Magic.RowCount := high(UserData.BasicRiseMagicArr) + 2;
    for i := 0 to high(UserData.BasicRiseMagicArr) do
    begin
      StringGrid_Magic.Rows[i + 1].Strings[0] := IntToStr(i);
      StringGrid_Magic.Rows[i + 1].Strings[1] := UserData.BasicRiseMagicArr[i].rName;
      StringGrid_Magic.Rows[i + 1].Strings[2] := IntToStr(UserData.BasicRiseMagicArr[i].rSkill);
    end;
  end
  else if astr = '武功' then
  begin
    StringGrid_Magic.RowCount := high(UserData.HaveMagicArr) + 2;
    for i := 0 to high(UserData.HaveMagicArr) do
    begin
      StringGrid_Magic.Rows[i + 1].Strings[0] := IntToStr(i);
      StringGrid_Magic.Rows[i + 1].Strings[1] := UserData.HaveMagicArr[i].rName;
      StringGrid_Magic.Rows[i + 1].Strings[2] := IntToStr(UserData.HaveMagicArr[i].rSkill);
    end;
  end
  else if astr = '上层' then
  begin
    StringGrid_Magic.RowCount := high(UserData.HaveRiseMagicArr) + 2;
    for i := 0 to high(UserData.HaveRiseMagicArr) do
    begin
      StringGrid_Magic.Rows[i + 1].Strings[0] := IntToStr(i);
      StringGrid_Magic.Rows[i + 1].Strings[1] := UserData.HaveRiseMagicArr[i].rName;
      StringGrid_Magic.Rows[i + 1].Strings[2] := IntToStr(UserData.HaveRiseMagicArr[i].rSkill);
    end;
  end
  else exit;

  StringGrid_Magic.Enabled := true;
  Button_edit_Magic_update.Enabled := true;
end;

//点击武功修改按钮

procedure TFormUser.Button_edit_Magic_updateClick(Sender: TObject);
var
  acol: integer;
  arow: integer;
begin
    //找出所选择的行和列
  acol := StringGrid_Magic.Selection.Left;
  arow := StringGrid_Magic.Selection.Top;
  arow := arow - 1;

  if ComboBox_Magic.Text = '基本' then
  begin
    if (arow < 0) or (arow > high(UserData.BasicMagicArr)) then exit;
    Edit_Magic_ID.Text := inttostr(arow);
    Edit_Magic_Name.Text := UserData.BasicMagicArr[arow].rName;
    Edit_Magic_Skill.Text := IntToStr(UserData.BasicMagicArr[arow].rSkill);
  end
  else if ComboBox_Magic.Text = '不羁' then
  begin
    if (arow < 0) or (arow > high(UserData.BasicRiseMagicArr)) then exit;
    Edit_Magic_ID.Text := inttostr(arow);
    Edit_Magic_Name.Text := UserData.BasicRiseMagicArr[arow].rName;
    Edit_Magic_Skill.Text := IntToStr(UserData.BasicRiseMagicArr[arow].rSkill);
  end
  else if ComboBox_Magic.Text = '武功' then
  begin
    if (arow < 0) or (arow > high(UserData.HaveMagicArr)) then exit;
    Edit_Magic_ID.Text := inttostr(arow);
    Edit_Magic_Name.Text := UserData.HaveMagicArr[arow].rName;
    Edit_Magic_Skill.Text := IntToStr(UserData.HaveMagicArr[arow].rSkill);
  end
  else if ComboBox_Magic.Text = '上层' then
  begin
    if (arow < 0) or (arow > high(UserData.HaveRiseMagicArr)) then exit;
    Edit_Magic_ID.Text := inttostr(arow);
    Edit_Magic_Name.Text := UserData.HaveRiseMagicArr[arow].rName;
    Edit_Magic_Skill.Text := IntToStr(UserData.HaveRiseMagicArr[arow].rSkill);
  end else exit;

  Panel_Edit_Magic.Visible := true;
  Panel_Edit_Magic.Left := 192;
  Panel_Edit_Magic.Top := 184;
  pageEdit.Enabled := false;
end;

//武功修改界面关闭按钮点击

procedure TFormUser.Button_Edit_Magic_closeClick(Sender: TObject);
begin
  ShowUserMagicData(ComboBox_Magic.Text);
  Panel_Edit_Magic.Visible := false;
  pageEdit.Enabled := true;
end;
//武功修改界面保存按钮点击

procedure TFormUser.Button_Edit_Magic_saveClick(Sender: TObject);
var
  arow: integer;
begin
  arow := StringGrid_Magic.Selection.Top;
  arow := arow - 1;
  if ComboBox_Magic.Text = '基本' then
  begin
    if (arow < 0) or (arow > high(UserData.BasicMagicArr)) then exit;
    UserData.BasicMagicArr[arow].rSkill := StrToInt(Edit_Magic_Skill.Text);
  end
  else if ComboBox_Magic.Text = '不羁' then
  begin
    if (arow < 0) or (arow > high(UserData.BasicRiseMagicArr)) then exit;
    UserData.BasicRiseMagicArr[arow].rName := (Edit_Magic_Name.Text);
    UserData.BasicRiseMagicArr[arow].rSkill := StrToInt(Edit_Magic_Skill.Text);
  end
  else if ComboBox_Magic.Text = '武功' then
  begin
    if (arow < 0) or (arow > high(UserData.HaveMagicArr)) then exit;
    UserData.HaveMagicArr[arow].rName := (Edit_Magic_Name.Text);
    UserData.HaveMagicArr[arow].rSkill := StrToInt(Edit_Magic_Skill.Text);
  end
  else if ComboBox_Magic.Text = '上层' then
  begin
    if (arow < 0) or (arow > high(UserData.HaveRiseMagicArr)) then exit;
    UserData.HaveRiseMagicArr[arow].rName := (Edit_Magic_Name.Text);
    UserData.HaveRiseMagicArr[arow].rSkill := StrToInt(Edit_Magic_Skill.Text);
  end else exit;
  Button_Edit_Magic_closeClick(Sender);
end;

procedure TFormUser.WriteUserMagicData();
begin

  StringGrid_Magic.RowCount := 31;
  StringGrid_Magic.ColCount := 3;
  StringGrid_Magic.Rows[0].Strings[0] := 'lkey';
  StringGrid_Magic.Rows[0].Strings[1] := 'rname';
  StringGrid_Magic.Rows[0].Strings[2] := 'rskill';
end;

procedure TFormUser.ComboBox_MagicChange(Sender: TObject);
begin
  ShowUserMagicData(ComboBox_Magic.Text);
end;
//================================任务================================================//

procedure TFormUser.ShowUserQuestData();
begin

  Edit_Quest_ComNo.Text := IntToStr(UserData.CompleteQuestNo);
  Edit_Quest_CurNo.Text := IntToStr(UserData.CurrentQuestNo);
  Edit_Quest_Step.Text := IntToStr(UserData.Queststep);

  Edit_SubQuest_SubNo.Text := IntToStr(UserData.SubCurrentQuestNo);
  Edit_SubQuest_Step.Text := IntToStr(UserData.SubQueststep);

  Edit_Quest_Temp0.Text := IntToStr(UserData.QuesttempArr[0]);
  Edit_Quest_Temp1.Text := IntToStr(UserData.QuesttempArr[1]);
  Edit_Quest_Temp2.Text := IntToStr(UserData.QuesttempArr[2]);
  Edit_Quest_Temp3.Text := IntToStr(UserData.QuesttempArr[3]);
  Edit_Quest_Temp4.Text := IntToStr(UserData.QuesttempArr[4]);
  Edit_Quest_Temp5.Text := IntToStr(UserData.QuesttempArr[5]);
  Edit_Quest_Temp6.Text := IntToStr(UserData.QuesttempArr[6]);
  Edit_Quest_Temp7.Text := IntToStr(UserData.QuesttempArr[7]);
  Edit_Quest_Temp8.Text := IntToStr(UserData.QuesttempArr[8]);
  Edit_Quest_Temp9.Text := IntToStr(UserData.QuesttempArr[9]);
  Edit_Quest_Temp10.Text := IntToStr(UserData.QuesttempArr[10]);
  Edit_Quest_Temp11.Text := IntToStr(UserData.QuesttempArr[11]);
  Edit_Quest_Temp12.Text := IntToStr(UserData.QuesttempArr[12]);
  Edit_Quest_Temp13.Text := IntToStr(UserData.QuesttempArr[13]);
  Edit_Quest_Temp14.Text := IntToStr(UserData.QuesttempArr[14]);
  Edit_Quest_Temp15.Text := IntToStr(UserData.QuesttempArr[15]);
  Edit_Quest_Temp16.Text := IntToStr(UserData.QuesttempArr[16]);
  Edit_Quest_Temp17.Text := IntToStr(UserData.QuesttempArr[17]);
  Edit_Quest_Temp18.Text := IntToStr(UserData.QuesttempArr[18]);
  Edit_Quest_Temp19.Text := IntToStr(UserData.QuesttempArr[19]);

end;

//任务保存按钮

procedure TFormUser.Button_Quest_saveClick(Sender: TObject);
begin

    //主线任务
  UserData.CompleteQuestNo := StrToInt(Edit_Quest_ComNo.Text);
  UserData.CurrentQuestNo := StrToInt(Edit_Quest_CurNo.Text);
  UserData.Queststep := StrToInt(Edit_Quest_Step.Text);
    //支线任务
  UserData.SubCurrentQuestNo := StrToInt(Edit_SubQuest_SubNo.Text);
  UserData.SubQueststep := StrToInt(Edit_SubQuest_Step.Text);

    //临时变量
  UserData.QuesttempArr[0] := StrToInt(Edit_Quest_Temp0.Text);
  UserData.QuesttempArr[1] := StrToInt(Edit_Quest_Temp1.Text);
  UserData.QuesttempArr[2] := StrToInt(Edit_Quest_Temp2.Text);
  UserData.QuesttempArr[3] := StrToInt(Edit_Quest_Temp3.Text);
  UserData.QuesttempArr[4] := StrToInt(Edit_Quest_Temp4.Text);

  UserData.QuesttempArr[5] := StrToInt(Edit_Quest_Temp5.Text);
  UserData.QuesttempArr[6] := StrToInt(Edit_Quest_Temp6.Text);
  UserData.QuesttempArr[7] := StrToInt(Edit_Quest_Temp7.Text);
  UserData.QuesttempArr[8] := StrToInt(Edit_Quest_Temp8.Text);
  UserData.QuesttempArr[9] := StrToInt(Edit_Quest_Temp9.Text);

  UserData.QuesttempArr[10] := StrToInt(Edit_Quest_Temp10.Text);
  UserData.QuesttempArr[11] := StrToInt(Edit_Quest_Temp11.Text);
  UserData.QuesttempArr[12] := StrToInt(Edit_Quest_Temp12.Text);
  UserData.QuesttempArr[13] := StrToInt(Edit_Quest_Temp13.Text);
  UserData.QuesttempArr[14] := StrToInt(Edit_Quest_Temp14.Text);

  UserData.QuesttempArr[15] := StrToInt(Edit_Quest_Temp15.Text);
  UserData.QuesttempArr[16] := StrToInt(Edit_Quest_Temp16.Text);
  UserData.QuesttempArr[17] := StrToInt(Edit_Quest_Temp17.Text);
  UserData.QuesttempArr[18] := StrToInt(Edit_Quest_Temp18.Text);
  UserData.QuesttempArr[19] := StrToInt(Edit_Quest_Temp19.Text);

  ShowUserQuestData();
end;

//===========================新快捷键============================================//

procedure TFormUser.ShowCutKeyData;
begin
  StringGrid_ShortcutKey.Rows[1].Strings[0] := IntToStr(1);
  StringGrid_ShortcutKey.Rows[1].Strings[1] := IntToStr(UserData.ShortcutKeyArr[0]);
  StringGrid_ShortcutKey.Rows[1].Strings[2] := IntToStr(UserData.ShortcutKeyArr[1]);
  StringGrid_ShortcutKey.Rows[1].Strings[3] := IntToStr(UserData.ShortcutKeyArr[2]);
  StringGrid_ShortcutKey.Rows[1].Strings[4] := IntToStr(UserData.ShortcutKeyArr[3]);
  StringGrid_ShortcutKey.Rows[1].Strings[5] := IntToStr(UserData.ShortcutKeyArr[4]);
  StringGrid_ShortcutKey.Rows[1].Strings[6] := IntToStr(UserData.ShortcutKeyArr[5]);
  StringGrid_ShortcutKey.Rows[1].Strings[7] := IntToStr(UserData.ShortcutKeyArr[6]);
  StringGrid_ShortcutKey.Rows[1].Strings[8] := IntToStr(UserData.ShortcutKeyArr[7]);
  StringGrid_ShortcutKey.Rows[1].Strings[9] := IntToStr(UserData.ShortcutKeyArr[8]);
  StringGrid_ShortcutKey.Rows[1].Strings[10] := IntToStr(UserData.ShortcutKeyArr[9]);
end;

procedure TFormUser.WriteUserCutKeyData();
begin
  StringGrid_ShortcutKey.RowCount := 2;
  StringGrid_ShortcutKey.ColCount := 11;
  StringGrid_ShortcutKey.Rows[0].Strings[0] := 'lkey';
  StringGrid_ShortcutKey.Rows[0].Strings[1] := 'shortcutkey0';
  StringGrid_ShortcutKey.Rows[0].Strings[2] := 'shortcutkey1';
  StringGrid_ShortcutKey.Rows[0].Strings[3] := 'shortcutkey2';
  StringGrid_ShortcutKey.Rows[0].Strings[4] := 'shortcutkey3';
  StringGrid_ShortcutKey.Rows[0].Strings[5] := 'shortcutkey4';
  StringGrid_ShortcutKey.Rows[0].Strings[6] := 'shortcutkey5';
  StringGrid_ShortcutKey.Rows[0].Strings[7] := 'shortcutkey6';
  StringGrid_ShortcutKey.Rows[0].Strings[8] := 'shortcutkey7';
  StringGrid_ShortcutKey.Rows[0].Strings[9] := 'shortcutkey8';
  StringGrid_ShortcutKey.Rows[0].Strings[10] := 'shortcutkey9';
end;

procedure TFormUser.Button_change_CutKeyClick(Sender: TObject);
begin
  pageEdit.Enabled := false;
  Panel_cutkey_edit.Visible := true;
  Panel_cutkey_edit.Left := 248;
  Panel_cutkey_edit.Top := 72;

  Edit_cutkey0.Text := IntToStr(UserData.ShortcutKeyArr[0]);
  Edit_cutkey1.Text := IntToStr(UserData.ShortcutKeyArr[1]);
  Edit_cutkey2.Text := IntToStr(UserData.ShortcutKeyArr[2]);
  Edit_cutkey3.Text := IntToStr(UserData.ShortcutKeyArr[3]);
  Edit_cutkey4.Text := IntToStr(UserData.ShortcutKeyArr[4]);
  Edit_cutkey5.Text := IntToStr(UserData.ShortcutKeyArr[5]);
  Edit_cutkey6.Text := IntToStr(UserData.ShortcutKeyArr[6]);
  Edit_cutkey7.Text := IntToStr(UserData.ShortcutKeyArr[7]);
  Edit_cutkey8.Text := IntToStr(UserData.ShortcutKeyArr[8]);
  Edit_cutkey9.Text := IntToStr(UserData.ShortcutKeyArr[9]);

end;

procedure TFormUser.Button_change_cutkey_closeClick(Sender: TObject);
begin
  ShowCutKeyData();
  Panel_cutkey_edit.Visible := false;
  pageEdit.Enabled := true;
end;

procedure TFormUser.Button_change_cutkey_saveClick(Sender: TObject);
begin
  UserData.ShortcutKeyArr[0] := StrToInt(Edit_cutkey0.Text);
  UserData.ShortcutKeyArr[1] := StrToInt(Edit_cutkey1.Text);
  UserData.ShortcutKeyArr[2] := StrToInt(Edit_cutkey2.Text);
  UserData.ShortcutKeyArr[3] := StrToInt(Edit_cutkey3.Text);
  UserData.ShortcutKeyArr[4] := StrToInt(Edit_cutkey4.Text);
  UserData.ShortcutKeyArr[5] := StrToInt(Edit_cutkey5.Text);
  UserData.ShortcutKeyArr[6] := StrToInt(Edit_cutkey6.Text);
  UserData.ShortcutKeyArr[7] := StrToInt(Edit_cutkey7.Text);
  UserData.ShortcutKeyArr[8] := StrToInt(Edit_cutkey8.Text);
  UserData.ShortcutKeyArr[9] := StrToInt(Edit_cutkey9.Text);
  Button_change_cutkey_closeClick(Sender);
end;
//===========================//快捷键============================================//

procedure TFormUser.ShowKeyData;
begin
  StringGrid_key.Rows[1].Strings[0] := IntToStr(1);
  StringGrid_key.Rows[1].Strings[1] := IntToStr(UserData.KeyArr[0]);
  StringGrid_key.Rows[1].Strings[2] := IntToStr(UserData.KeyArr[1]);
  StringGrid_key.Rows[1].Strings[3] := IntToStr(UserData.KeyArr[2]);
  StringGrid_key.Rows[1].Strings[4] := IntToStr(UserData.KeyArr[3]);
  StringGrid_key.Rows[1].Strings[5] := IntToStr(UserData.KeyArr[4]);
  StringGrid_key.Rows[1].Strings[6] := IntToStr(UserData.KeyArr[5]);
  StringGrid_key.Rows[1].Strings[7] := IntToStr(UserData.KeyArr[6]);
  StringGrid_key.Rows[1].Strings[8] := IntToStr(UserData.KeyArr[7]);
  StringGrid_key.Rows[1].Strings[9] := IntToStr(UserData.KeyArr[8]);
  StringGrid_key.Rows[1].Strings[10] := IntToStr(UserData.KeyArr[9]);
end;

procedure TFormUser.WriteUserKeyData();
begin
  StringGrid_key.RowCount := 2;
  StringGrid_key.ColCount := 11;
  StringGrid_key.Rows[0].Strings[0] := 'lkey';
  StringGrid_key.Rows[0].Strings[1] := 'key0';
  StringGrid_key.Rows[0].Strings[2] := 'key1';
  StringGrid_key.Rows[0].Strings[3] := 'key2';
  StringGrid_key.Rows[0].Strings[4] := 'key3';
  StringGrid_key.Rows[0].Strings[5] := 'key4';
  StringGrid_key.Rows[0].Strings[6] := 'key5';
  StringGrid_key.Rows[0].Strings[7] := 'key6';
  StringGrid_key.Rows[0].Strings[8] := 'key7';
  StringGrid_key.Rows[0].Strings[9] := 'key8';
  StringGrid_key.Rows[0].Strings[10] := 'key9';
end;

procedure TFormUser.Button_change_keyClick(Sender: TObject);

begin
  pageEdit.Enabled := false;
  Panel_key.Visible := true;
  Panel_key.Left := 248;
  Panel_key.Top := 72;

  Edit_key0.Text := IntToStr(UserData.KeyArr[0]);
  Edit_key1.Text := IntToStr(UserData.KeyArr[1]);
  Edit_key2.Text := IntToStr(UserData.KeyArr[2]);
  Edit_key3.Text := IntToStr(UserData.KeyArr[3]);
  Edit_key4.Text := IntToStr(UserData.KeyArr[4]);
  Edit_key5.Text := IntToStr(UserData.KeyArr[5]);
  Edit_key6.Text := IntToStr(UserData.KeyArr[6]);
  Edit_key7.Text := IntToStr(UserData.KeyArr[7]);
  Edit_key8.Text := IntToStr(UserData.KeyArr[8]);
  Edit_key9.Text := IntToStr(UserData.KeyArr[9]);

end;

procedure TFormUser.Button_key_closeClick(Sender: TObject);
begin
  Panel_key.Visible := false;
  pageEdit.Enabled := true;
  ShowKeyData();
end;

procedure TFormUser.Button_key_saveClick(Sender: TObject);
begin
  UserData.KeyArr[0] := StrToInt(Edit_key0.Text);
  UserData.KeyArr[1] := StrToInt(Edit_key1.Text);
  UserData.KeyArr[2] := StrToInt(Edit_key2.Text);
  UserData.KeyArr[3] := StrToInt(Edit_key3.Text);
  UserData.KeyArr[4] := StrToInt(Edit_key4.Text);
  UserData.KeyArr[5] := StrToInt(Edit_key5.Text);
  UserData.KeyArr[6] := StrToInt(Edit_key6.Text);
  UserData.KeyArr[7] := StrToInt(Edit_key7.Text);
  UserData.KeyArr[8] := StrToInt(Edit_key8.Text);
  UserData.KeyArr[9] := StrToInt(Edit_key9.Text);
  Button_key_closeClick(Sender);
end;

procedure TFormUser.FormShow(Sender: TObject);
begin
  pageEdit.ActivePage := TabSheet_basic;
  WriteUserItemData();
  WriteUserMagicData();
  WriteUserKeyData();
  WriteUserCutKeyData();
end;

procedure TFormUser.StringGrid_ItemSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    //
   // FormUser.Caption:=inttostr(acol)+':'+inttostr(arow);
end;

procedure TFormUser.StringGrid_ItemClick(Sender: TObject);
begin
  FormUser.Caption := inttostr(StringGrid_Item.Selection.Left) + ':' + inttostr(StringGrid_Item.Selection.Top);
end;
//

procedure TFormUser.Button_basic_saveClick(Sender: TObject);
var
  FSetting: TFormatSettings;
begin
  FSetting.ShortDateFormat := 'yyyy-MM-dd';
  FSetting.DateSeparator := '-';
  FSetting.TimeSeparator := ':';
  FSetting.LongTimeFormat := 'hh:mm:ss';

    // UserData.PrimaryKey := Edit_ID.Text;

  UserData.MasterName := (Edit_MasterName.Text);
  UserData.Password := (Edit_Password.Text);
  UserData.GroupKey := StrToInt(Edit_GroupKey.Text);
  UserData.Guild := Edit_Guild.Text;
  UserData.LastDate := StrToDateTime(Edit_LastDate.Text, FSetting);
  UserData.CreateDate := StrToDateTime(Edit_CreateDate.Text, FSetting);
  UserData.ServerId := StrToInt(Edit_ServerId.Text);
  UserData.x := StrToInt(Edit_x.Text);
  UserData.y := StrToInt(Edit_y.Text);
  UserData.GOLD_Money := StrToInt(Edit_GOLD_Money.Text);
  UserData.prestige := StrToInt(Edit_prestige.Text);
  UserData.Light := StrToInt(Edit_Light.Text);
  UserData.Dark := StrToInt(Edit_dark.Text);
  UserData.Energy := StrToInt(Edit_Energy.Text);
  UserData.InPower := StrToInt(Edit_InPower.Text);
  UserData.OutPower := StrToInt(Edit_OutPower.Text);
  UserData.Magic := StrToInt(Edit_Magic.Text);
  UserData.Life := StrToInt(Edit_Life.Text);
  UserData.Talent := StrToInt(Edit_Talent.Text);
  UserData.GoodChar := StrToInt(Edit_GoodChar.Text);
  UserData.BadChar := StrToInt(Edit_BadChar.Text);
  UserData.Adaptive := StrToInt(Edit_Adaptive.Text);
  UserData.Revival := StrToInt(Edit_Revival.Text);
  UserData.Immunity := StrToInt(Edit_Immunity.Text);
  UserData.Virtue := StrToInt(Edit_Virtue.Text);
  UserData.CurEnergy := StrToInt(Edit_CurEnergy.Text);
  UserData.CurInPower := StrToInt(Edit_CurInPower.Text);
  UserData.CurOutPower := StrToInt(Edit_CurOutPower.Text);
  UserData.CurMagic := StrToInt(Edit_CurMagic.Text);
  UserData.CurLife := StrToInt(Edit_CurLife.Text);
  UserData.CurHealth := StrToInt(Edit_CurHealth.Text);
  UserData.CurSatiety := StrToInt(Edit_CurSatiety.Text);
  UserData.CurPoisoning := StrToInt(Edit_CurPoisoning.Text);
  UserData.CurHeadSeek := StrToInt(Edit_CurHeadSeek.Text);
  UserData.CurArmSeek := StrToInt(Edit_CurArmSeek.Text);
  UserData.CurLegSeek := StrToInt(Edit_CurLegSeek.Text);
  UserData.ExtraExp := StrToInt(Edit_ExtraExp.Text);
  UserData.AddableStatePoint := StrToInt(Edit_AddableStatePoint.Text);
  UserData.TotalStatePoint := StrToInt(Edit_TotalStatePoint.Text);
  UserData.CurrentGrade := StrToInt(Edit_CurrentGrade.Text);
  UserData.FashionableDress := StrToBool(Edit_FashionableDress.Text);
  UserData.JobKind := StrToInt(Edit_JobKind.Text);
    // UserData.Sex := StrToBool(ComboBox_Sex.Text);

  UserData.r3f_sky := StrToInt(Edit_tian.Text);
  UserData.r3f_terra := StrToInt(Edit_di.Text);
  UserData.r3f_fetch := StrToInt(Edit_ren.Text);

  UserData.newTalent := StrToInt(Edit_newTalent.Text); //天赋点
  UserData.newTalentExp := StrToInt(Edit_newTalentExp.Text); //天赋经验
  UserData.newTalentLv := StrToInt(Edit_newTalentLv.Text); //天赋级别

  UserData.newBone := StrToInt(Edit_newBone.Text); //根骨
  UserData.newLeg := StrToInt(Edit_newLeg.Text); //身法
  UserData.newSavvy := StrToInt(Edit_newSavvy.Text); //悟性
  UserData.newAttackPower := StrToInt(Edit_newAttackPower.Text); //武学
  UserData.newBindMoney := StrToInt(Edit_newBindMoney.Text); //绑定钱币

  UserData.MagicExpMulCount := StrToInt(Edit_MagicExpMulCount.Text); //经验倍数
  UserData.MagicExpMulEndTime := StrToInt(Edit_MagicExpMulEndTime.Text); //经验结束时间
  UserData.VipUseLevel := StrToInt(Edit_VipUseLevel.Text); //VIP等级
  UserData.VipUseTime := StrToDateTime(Edit_VipUseTime.Text, FSetting); //VIP时间

  UserData.ComplexExp := StrToInt(Edit_ComplexExp.Text); //合成熟练度
  UserData.guildPoint := StrToInt(Edit_guildPoint.Text); //门派贡献
end;

procedure TFormUser.FormCreate(Sender: TObject);
begin
  ItemUserListclass := TItemUserListclass.Create;

  bquserListclass := TbquserListclass.Create;

  clear;
end;

{ TItemUserclass }

procedure TItemUserListclass.add(aitem: TitemListdata);
var
  p: pTitemListdata;
begin
  inc(fautoid);
  aitem.rid := fautoid;
  new(p);
  p^ := aitem;
  data.Add(p);
end;

procedure TItemUserListclass.clear;
var
  i: Integer;
  temp: pTitemListdata;
begin
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    dispose(temp);
  end;
  data.Clear;
end;

constructor TItemUserListclass.Create();
begin
  data := tlist.Create;
  fautoid := 0;
end;

procedure TItemUserListclass.del(aid: integer);
var
  i: Integer;
  temp: pTitemListdata;
begin
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    if temp.rid = aid then
    begin
      dispose(temp);
      data.Delete(i);
      exit;
    end;
  end;
end;

destructor TItemUserListclass.Destroy;
begin
  clear;
  data.Free;
  inherited;
end;

function TItemUserListclass.get(aid: integer): pTitemListdata;
var
  i: Integer;
  temp: pTitemListdata;
begin
  result := nil;
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    if temp.rid = aid then
    begin
      result := temp;
      exit;
    end;
  end;
end;

procedure TItemUserListclass.Sort;
begin
  data.Sort(ListSort);
end;

function TItemUserListclass.getNameList(aname: string): string;
var
  i, j, m: Integer;
  temp: pTitemListdata;
  str: string;
begin
  j := 0;
  m := 0;
  result := '序号,物品,数量,用户,位置,' + #13#10;
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    if (aname <> '') then
      if (temp.ritem.rName <> aname) then Continue;
    case temp.rtype of
      ildt_HAVEITEM: str := '背包';
      ildt_ItemLog: str := '仓库';
      ildt_WEAR: str := '装备';
      ildt_FASHION: str := '时装';
      ildt_Auction: str := '寄售';
      ildt_Email: str := '邮件';
    else str := '未知';
    end;
    inc(j);
    m := m + temp.ritem.rCount;
    result := result + inttostr(j) + ',' + temp.ritem.rName + ',' + inttostr(temp.ritem.rCount) + ',' + temp.rUserName + ',' + str + ',' + #13#10;
  end;
  result := result + '总计数量: ' + inttostr(m) + #13#10;
end;

{ TbquserListclass }

procedure TbquserListclass.add(aitem: TbqListdata);
var
  p: pTbqListdata;
begin
  inc(fautoid);
  aitem.rid := fautoid;
  new(p);
  p^ := aitem;
  data.Add(p);
end;

procedure TbquserListclass.clear;
var
  i: Integer;
  temp: pTbqListdata;
begin
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    dispose(temp);
  end;
  data.Clear;
end;

constructor TbquserListclass.Create();
begin
  data := tlist.Create;
  fautoid := 0;
end;

procedure TbquserListclass.del(aid: integer);
var
  i: Integer;
  temp: pTbqListdata;
begin
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    if temp.rid = aid then
    begin
      dispose(temp);
      data.Delete(i);
      exit;
    end;
  end;
end;

destructor TbquserListclass.Destroy;
begin
  clear;
  data.Free;
  inherited;
end;

function TbquserListclass.get(aid: integer): pTbqListdata;
var
  i: Integer;
  temp: pTbqListdata;
begin
  result := nil;
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    if temp.rid = aid then
    begin
      result := temp;
      exit;
    end;
  end;
end;

procedure TbquserListclass.Sort;
begin
  data.Sort(ListbqSort);
end;

function TbquserListclass.getNameList: string;
var
  i, j: Integer;
  temp: pTbqListdata;
  str: string;
begin
  j := 0;
  result := '序号,玩家,数量' + #13#10;
  for i := 0 to data.Count - 1 do
  begin
    temp := data.Items[i];
    inc(j);
    result := result + inttostr(j) + ',' + temp.rUserName + ',' + inttostr(temp.rnum) + str + ',' + #13#10;
  end;
end;


procedure TFormUser.FormDestroy(Sender: TObject);
begin
  ItemUserListclass.free;
  bquserListclass.free;
end;

procedure TFormUser.Button1Click(Sender: TObject);
var
  tempList: TStringList;
  i, j, j1: integer;

  tempUser: TDBRecord;
  tempAuctionData: TAuctionData;
  tempemaildata: TEmaildata;
  procedure _add(aname: string; aitem: TDBItemData; atype: TitemListdataType);
  var
    tempitem: TitemListdata;
  begin
    if aitem.rName = '' then exit;
    tempitem.rUserName := aname;
    tempitem.ritem := aitem;
    tempitem.rtype := atype;
    ItemUserListclass.add(tempitem);
  end;

begin
  ItemUserListclass.clear;
  tempList := TStringList.Create;
  try
    tempList.Text := UserDBAdapter.UserSelectAllName;
        //角色
    for i := 0 to tempList.Count - 1 do
    begin
      if UserDBAdapter.UserSelect(tempList.Strings[i], @tempUser) <> DB_OK then Continue;
      for j := 0 to high(tempUser.HaveItemArr) do _add(tempuser.PrimaryKey, tempUser.HaveItemArr[j], ildt_HAVEITEM);
      for j := 0 to high(tempUser.WearItemArr) do _add(tempuser.PrimaryKey, tempUser.WearItemArr[j], ildt_WEAR);
      for j := 0 to high(tempUser.FashionableDressArr) do _add(tempuser.PrimaryKey, tempUser.FashionableDressArr[j], ildt_FASHION);
      j1 := tempUser.ItemLog.rsize;
      if j1 > high(tempUser.ItemLog.data) then j1 := high(tempUser.ItemLog.data);
      for j := 0 to j1 do _add(tempuser.PrimaryKey, tempUser.ItemLog.data[j], ildt_ItemLog);
    end;
        //寄售
    tempList.Text := AuctionDBAdapter.SelectAllName;
    for i := 0 to tempList.Count - 1 do
    begin
      if AuctionDBAdapter.Select(tempList.Strings[i], @tempAuctionData) <> DB_OK then Continue;
      _add(tempAuctionData.rBargainorName, tempAuctionData.rItem, ildt_Auction);
    end;
        //邮件
    tempList.Text := EmailDBAdapter.SelectAllName;
    for i := 0 to tempList.Count - 1 do
    begin
      if EmailDBAdapter.Select(tempList.Strings[i], @tempemaildata) <> DB_OK then Continue;
      _add(tempemaildata.FDestName, tempemaildata.Fbuf, ildt_Email);
    end;
    ItemUserListclass.Sort;
  finally
    tempList.Free;
  end;

end;

procedure TFormUser.Button2Click(Sender: TObject);
begin
  Panel_sum_count.Visible := not Panel_sum_count.Visible;
end;

procedure TFormUser.Button_itemcount_findClick(Sender: TObject);
begin
  Memo1.Lines.Text := ItemUserListclass.getNameList(Edit_itemcount_find.text);
end;

procedure TFormUser.Button3Click(Sender: TObject);
var
  temp: TMemoryStream;
begin
  if SaveDialog1.Execute then
  begin
    temp := TMemoryStream.Create;
    try
      temp.WriteBuffer(UserData, sizeof(UserData));
      temp.SaveToFile(SaveDialog1.FileName);
    finally
      temp.Free;
    end;

  end;
end;

procedure TFormUser.Button4Click(Sender: TObject);
var
  r: integer;
begin
  if Application.MessageBox('确定删除角色数据吗?', 'DB SERVER', MB_OKCANCEL) <> ID_OK then exit;
  Edit_name.Text := trim(Edit_name.Text);
  r := UserDBAdapter.delete(Edit_name.Text);
  case r of
    DB_OK: ShowMessage('删除数据成功。');
  else ShowMessage('错误(其他错误)!');
  end;

end;


procedure TFormUser.btnyaceClick(Sender: TObject);
var
  YaceStringList: TStringList;
  i, n, nCode: Integer;
  playname: string;
  str, rdstr: string;
begin
  //压测角色列表
  playname := trim(Edit_db_name.Text);
  if playname = '' then
  begin
    ShowMessage('请先读入角色数据');
    exit;
  end;
  YaceStringList := TStringList.Create;
  if FileExists('压测角色创建.txt') then YaceStringList.LoadFromFile('压测角色创建.txt');
  n := 0;
  for i := 0 to YaceStringList.Count - 1 do
  begin
    str := GetValidStr3(YaceStringList.Strings[i], rdstr, ',');
    UserData.PrimaryKey := str;
    UserData.MasterName := rdstr;
    nCode := UserDBAdapter.UserInsert(str, @UserData);
    if nCode = DB_OK then inc(n);
    //ShowMessage('账号=' + rdstr + ' / 角色=' + str);
  end;
  YaceStringList.Free;
  ShowMessage('成功创建了' + IntToStr(n) + '个压力测试角色！');
end;

procedure TFormUser.btn_bqClick(Sender: TObject);
var
  tempList: TStringList;
  i, j, j1: integer;
  tempUser: TDBRecord;

  procedure _add(aname: string; anum: Int64);
  var
    tempitem: TbqListdata;
  begin
    tempitem.rUserName := aname;
    tempitem.rnum := anum;
    bquserListclass.add(tempitem);
  end;
begin
  bquserListclass.clear;
  tempList := TStringList.Create;
  try
    tempList.Text := UserDBAdapter.UserSelectAllName;
    //角色
    for i := 0 to tempList.Count - 1 do
    begin
      if UserDBAdapter.UserSelect(tempList.Strings[i], @tempUser) <> DB_OK then Continue;
      if tempUser.newBindMoney >= 100000 then _add(tempuser.PrimaryKey, tempUser.newBindMoney);
    end;
    bquserListclass.Sort;
  finally
    tempList.Free;
  end;
  Memo1.Lines.Text := bquserListclass.getNameList;
end;

procedure TFormUser.btnloaduserlistClick(Sender: TObject);
var
  tempstring: tstringlist;
  i: integer;
  Item: TListItem;
begin
  tempstring := tstringlist.Create;
  UserList.Items.Clear;
  try
    tempstring.Text := UserDBAdapter.UserSelectAllName;
    for i := 0 to tempstring.Count - 1 do
    begin
      UserList.Items.Add(tempstring.Strings[i]);
    end;
  finally
    tempstring.Free;
  end;

end;


procedure TFormUser.UserListDblClick(Sender: TObject);
var
  fresult: integer;
  Str: string;
begin
  clear;
  Str := UserList.Items[UserList.ItemIndex];
  if Str = '' then exit;
  fresult := UserDBAdapter.UserSelect(Str, @UserData);
  case fresult of
    DB_OK:
      begin
        Edit_name.Text := Str;
        // Panel_find.Visible := false;
        pageEdit.Visible := true;
        pageEdit.Enabled := true;
        //  Button_save.Visible := true;

        ShowUserBasicData();
        ShowUserMagicData(ComboBox_Magic.Text);
        ShowUserItemData(ComboBox_Item.Text);
        ShowKeyData();
        ShowCutKeyData();
        ShowUserQuestData();
      end;
    DB_ERR_NOTFOUND: ShowMessage('角色不存在');
  else
    begin
      ShowMessage('未知错误' + inttostr(fresult));
    end;
  end;
end;

procedure TFormUser.btnjiazaiClick(Sender: TObject);
var
  temp: TMemoryStream;
  oldPrimaryKey, oldMasterName: string;
begin
  oldPrimaryKey := UserData.PrimaryKey;
  oldMasterName := UserData.MasterName;
  if oldPrimaryKey = '' then
  begin
    ShowMessage('请先读取角色');
    Exit;
  end;

  if dlgOpen1.Execute then
  begin
    temp := TMemoryStream.Create;
    try
      temp.LoadFromFile(dlgOpen1.FileName);
      temp.ReadBuffer(UserData, temp.size);
      UserData.PrimaryKey := oldPrimaryKey; 
      UserData.MasterName := oldMasterName;
      ShowUserBasicData();
      ShowUserMagicData(ComboBox_Magic.Text);
      ShowUserItemData(ComboBox_Item.Text);
      ShowKeyData();
      ShowCutKeyData();
      ShowUserQuestData();
    finally
      temp.Free;
    end;

  end;
end;

end.

