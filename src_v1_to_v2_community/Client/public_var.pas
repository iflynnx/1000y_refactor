unit public_var;

interface
uses
  IniFiles, graphics;
var
  G_Default1024: Boolean = true;
  G_ClientIni: TIniFile;
  G_BottomHeigth: integer;
  G_FpkUiUsed:Boolean =False;     //2015.07.24 在水一方
  G_SuitMaxCount: integer = 2;
  G_ShowPosExY:Integer = 0;
  G_ShowPosExYDefault:Integer=0;
var
  G_lbEnergyLv: string = '无';
   //装备提示相关
  G_ItemTitleBody: string = '+身攻击:';
  G_ItemTitleHead: string = '+头攻击:';
  G_ItemTitleHand: string = '+手攻击:';
  G_ItemTitleFoot: string = '+脚攻击:';
  G_ItemTitleAttack: string = '【物理攻击力】';

  G_ItemTitleBodyDf: string = '+身防御:';
  G_ItemTitleHeadDf: string = '+头防御:';
  G_ItemTitleHandDf: string = '+手防御:';
  G_ItemTitleFootDf: string = '+脚防御:';
  G_ItemTitleDef: string = '【物理防御力】';

  G_ItemTitleHitArmor: string = '【维持】';
  G_ItemTitleHitArmorValue: string = '+维持:';

  G_ItemTitleSpecial: string = '【特殊】';
  G_ItemTitleavoidvalue: string = '+躲避:';
  G_ItemTitlerecovery: string = '+恢复:';
  G_ItemTitleaccuracy: string = '+命中:';
  G_ItemTitleAttackSpeed: string = '+速度:';
  G_ItemTitlecritRating: string = '+暴击率:';
  G_ItemTitlecritRatio: string = '+暴击伤害百分比:';
  G_ItemTitlesuckBloodRating: string = '+吸血成功率:';
  G_ItemTitlesuckBloodRatio: string = '+吸血百分比:';
  G_rNameColorLv1: Tcolor = clGreen;
  G_rNameColorLv2: Tcolor = clYellow;
  G_rNameColorLv3: Tcolor = clRed;
  G_rNameAdjLv1: string = '粗糙的';
  G_rNameAdjLv2: string = '精致的';
  G_rNameAdjLv3: string = '完美的';
  G_ItemSexMale: string = '公的';
  G_ItemSexFemale: string = '母的';
  G_ItemHoleCountFirst: string = '<$0023A4FA>(';
  G_ItemHoleCountSecond: string = '孔)';
  G_ItemLvFirst: string = '<$000060FF> ';
  G_ItemLvSecond: string = '段';
  G_ItemCreatename1: string = '<$FF8000>〖';
  G_ItemCreatename2: string = '〗制造';
  G_ItemGrade: string = '品阶:';
  G_ItemPrice: string = '价格:';
  G_ItemPriceE1: string = ' <$000080FF>(';
  G_ItemPriceE2: string = '亿)';
  G_ItemPriceW1: string = ' <$000080FF>(';
  G_ItemPriceW2: string = '万)';
  G_ItemNum: string = '数量:';
  G_ItemNumE1: string = ' <$000080FF>(';
  G_ItemNumE2: string = '亿)';
  G_ItemNumW1: string = ' <$000080FF>(';
  G_ItemNumW2: string = '万)';
  G_ItemSpecialLevel: string = '等级:';
  G_ItemDurability: string = '水量:';
  G_ItemDurability2: string = '持久:';
  G_ItemTimelines: string = '<$000000FF>物品时效至:';
  G_ItemTimelinesColor: string = '<$000000FF>';
  G_ItemMaxUpgrade: string = '最高精炼等级:';
  G_Itemrboident: string = '<$001DF833>可鉴定(通过鉴定可以得到更多属性)';
  G_ItemBasic: string = '〓基本〓';
  G_ItemBasicColor: string = '<$00808080>';
  G_ItemSmithingLevel1: string = '<$001A4DFB>〓精炼〓';
  G_ItemSmithingLevel2: string = ' <$001A4DFB>';
  G_ItemSmithingLevel3: string = '段';
  G_ItemAttach: string = '<$001DF833>〓附加〓';
  G_ItemSetting: string = '<$00F7A61E>〓镶嵌〓';
  G_ItemSettingCount1: string = '<$00F7A61E>镶嵌(1):';
  G_ItemSettingCount2: string = '<$00F7A61E>镶嵌(2):';
  G_ItemSettingCount3: string = '<$00F7A61E>镶嵌(3):';
  G_ItemSettingCount4: string = '<$00F7A61E>镶嵌(4):';
  G_ItemSmithingLevelColor: string = '<$001A4DFB>';
  G_ItemAttachColor: string = '<$001DF833>';
  G_ItemSettingColor: string = '<$0000D714>';
   G_ItemRandomValueColor: string = '<$0000D714>';
   G_ItemRandomValueInjectTimes1:string='<$000060FF>注入:';
   G_ItemRandomValueInjectTimes2:string='次';
    G_ItemRandomValueInjectTimes3:string='已达巅峰';
  G_ItemSuit: string = '<$001DF833>〓套装〓';
  G_ItemSuitColor: string = '<$001DF833>';
  G_ItemSuitAll: string = '<$007B7B7B>〓套装〓(穿戴全套激活属性)';
  G_ItemSuitColorAll: string = '<$007B7B7B>';
  G_ItemSuitInvalid: string='<$00505050>封印属性';
  G_ItemLockStatus: string = '<$001A4DFB>锁定状态';
  G_ItemUnLockStatus1: string = '<$001A4DFB>解锁时间已过:';
  G_ItemUnLockStatus2: string = '小时';
  G_ItemModel1: string = '<$0023A4FA>设计图纸/铸造模型';
  G_ItemModel2: string = '<$0023A4FA>合成材料：';
  G_ItemKind1: string = '<$0000B8FF>任务物品'; //<$001A4DFB>   >>>
  G_ItemKind2: string = '<$0000B8FF>不可出售';
  G_ItemKind3: string = '<$0000B8FF>不可交易';
  G_ItemKind4: string = '<$0000B8FF>不可丢弃';
  G_ItemKind5: string = '<$0000B8FF>不可寄存';
  G_ItemKind6: string = '<$0000B8FF>不可维修'; //<$001A4DFB>   <<<
  G_ItemSpecialKind1: string = '<$001A4DFB>普通装备';
  G_ItemSpecialKind2: string = '<$001A4DFB>生产装备';
  G_ItemSpecialKind3: string = '<$001A4DFB>荣誉装备';
  G_ItemSpecialKind4: string = '<$001A4DFB>合成装备';
  G_ItemSpecialKind5: string = '<$001A4DFB>修炼装备';
  G_ItemSpecialKind6: string = '<$001A4DFB>特殊道具(离开任务地图消失)';
  G_ItemrboColoring: string = '允许染色';
  G_ItemrboTimeMode: string = '<$001A4DFB>有效时间:';
  G_ItemTab: string = '     <tab>';
  G_ItemIcon: string = '<ItemIcon> ';
  G_ItemFont9: string = '{9}';
  G_ItemFont10: string = '{10}';
  G_ItemFont11: string = '{11}';
  G_ItemFont12: string = '{12}';
  G_ItemFont13: string = '{13}';
  G_ItemWearNameColor: string = '<$0000B8FF>';
  G_ItemDescColor: string = '<$00487B8E>';
  G_ItemDescColor2: string = '<$00487B8E>';
  G_ItemBlank: string = #13#10; //'                            '+#13#10;
  G_Menus: array[0..4] of string = ('发送纸条', '申请交易', '查看装备', '添加好友', '邀请入门');
  G_Icon0: string = 'Icon0';
  G_Icon1: string = 'Icon1';
  G_Icon2: string = 'Icon2';
  G_Icon3: string = 'Icon3';
  G_Icon4: string = 'Icon4';
  G_Icon5: string = 'Icon5';
  G_Icon6: string = 'Icon6';
  G_Icon7: string = 'Icon7';
  G_Icon8: string = 'Icon8';
  G_Icon9: string = 'Icon9';
  G_SettingCharCount: Integer = 12;
  G_ItemInjectInfo: string = '<$000080FF>杀气注入:';
const
  G_CIcon0 = '<Icon0>';
  G_CIcon1 = '<Icon1>';
implementation

end.

