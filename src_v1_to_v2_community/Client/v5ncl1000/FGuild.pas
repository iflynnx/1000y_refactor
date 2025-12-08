unit FGuild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, A2Form, StdCtrls, A2IMG, deftype, ExtCtrls, AUtil32, BaseUIForm, NativeXml;

type
  TLifeDataList = class;
  TfrmGuild = class(TfrmBaseUI)
    A2Button_add: TA2Button;
    A2Button2: TA2Button;
    A2Button3: TA2Button;
    A2Button5: TA2Button;
    A2Button6: TA2Button;
    A2Button4: TA2Button;
    A2Button7: TA2Button;
    A2Label_leve: TA2Label;
    A2Label_maxnum: TA2Label;
    A2Label_num: TA2Label;
    A2Button1: TA2Button;
    A2Button8: TA2Button;
    A2Button9: TA2Button;
    A2Button10: TA2Button;
    A2Button11: TA2Button;
    A2Button12: TA2Button;
    A2Button13: TA2Button;
    A2Form: TA2Form;
    A2ListBox1: TA2ListBox;
    A2ILabelNotice: TA2ILabel;
    A2Button14: TA2Button;
    A2Label_GuildName: TA2Label;
    A2Label_GuildPoint: TA2Label;
    A2Label_GuildMagic: TA2Label;
    A2Label_MakeDate: TA2Label;
    A2Label_Enegy: TA2Label;
    A2Label_Sysop: TA2Label;
    A2Label_urability: TA2Label;
    A2Label_GradeName: TA2Label;
    A2Label_Job: TA2Label;
    AbtnSetGuildJob: TA2Button;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A2ListBox1AdxDrawItem(ASurface: TA2Image; index: Integer;
      aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: Integer);
    procedure A2Button_addClick(Sender: TObject);
    procedure A2Button6Click(Sender: TObject);
    procedure A2Button4Click(Sender: TObject);
    procedure A2Button3Click(Sender: TObject);
    procedure A2Button7Click(Sender: TObject);
    procedure A2Button2Click(Sender: TObject);
    procedure A2Button1Click(Sender: TObject);
    procedure A2Button12Click(Sender: TObject);
    procedure A2Button11Click(Sender: TObject);
    procedure A2Button10Click(Sender: TObject);
    procedure A2Button9Click(Sender: TObject);
    procedure A2Button8Click(Sender: TObject);
    procedure A2Button14Click(Sender: TObject);
    procedure A2Label_GuildName1MouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2Button5Click(Sender: TObject);
    procedure AbtnSetGuildJobClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
        { Private declarations }
  public
        { Public declarations }
    LifeDataList: TLifeDataList;
    Fdata: TLIST;
        ///////////////////////////////////
        //           门派属性
        ///////////////////////////////////
    guildname: string;
    GuildLevel: integer; //门派 等级
    GuilDurability,
      GuilDurabilityMAX:
    integer; //门派 血  最大血
    GuilMaxNum: integer; //门派 最大人数
    Guilnotice: string; //门派 公告
    FGuildX, FGuildY: Integer; //门派坐标
    FGuildMagic: string; //门派武功
    FGuildMakeDate: string; //创建日期
    FGuildEnegy: Integer; //门派积分？
    FGuildMaxEnegy: Integer; //门派升级积分？
    FGuildSysop: string; //门主

    FGNameX: Integer;
    FGNameY: Integer;
    FGEnergyX: Integer;
    FGEnergyY: Integer;
    FGPointX: Integer;
    FGPointY: Integer;
    FGOnlineColor: Integer;
    FGOfflineColor: Integer;
        ///////////////////////////////////
    FdataTListSortCompare: TListSortCompare;
    tempTA2Image: TA2Image;

    procedure DrawDispathLifedata();
    procedure MessageProcess(var code: TWordComData);
    procedure setGuildNotice(astr: string);

    procedure FdataADD(aGuildUserData: TGuildUserData);
    procedure FdataClear();
    function FdataGET(id: integer): PTGuildUserData;
    function FdataGETIndex(id: integer): PTGuildUserData;
    function FdataGETName(aName: string): PTGuildUserData;
    procedure FdataDEL(id: integer);
    procedure SetGradeName(id: integer; astr: string);
    procedure FdataSort();

    procedure sendGuildAdd(aname: string);
    procedure sendGuilddel(aname: string);
    procedure sendGuilddel_ic();
    procedure sendGUILD_set_SubSysop(aname: string);
    procedure sendGUILD_set_Sysop(aname: string);
    procedure sendGUILD_del_SubSysop(aname: string);
    procedure sendGUILD_del_SubSysop_ic();
    procedure sendGUILD_get_info();
    procedure sendGuilGradeNameUPdate(aname, atext: string);
    function isSysop(): boolean;
    function isSubSysop(): boolean;
    function isSubSysop2(AName: string): boolean;
    procedure onlinecount();


    //procedure SetOldVersion;



    procedure SetNewVersion(); override;


   // procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
    procedure ShowSelfGuildInfo();
    procedure ReadOtherConfig;
    function getGuildJob: string;
  end;
  TLifeDataListdata = record
    rid: integer;
    LifeData: TLifeData;
    name: string[32];
    rtime: integer;
    reft: integer;
  end;
  pTLifeDataListdata = ^TLifeDataListdata;
  TLifeDataList = class //属性列表
  private

  public
    DataList: TList;
    LifeData: TLifeData; //属性合计

    constructor Create;
    destructor Destroy; override;

    function get(aid: integer): pTLifeDataListdata;

    function del(aid: integer): boolean; //唯一  删除
    function add(var aitem: TLifeDataListdata): boolean; //唯一 增加
    procedure upitem(pp: pTLifeDataListdata; var aitem: TLifeDataListdata); //唯一 更新覆盖
    procedure Clear();
    procedure setLifeData();
    function getLifedatastr(): string;

  end;

var
  frmGuild: TfrmGuild;

implementation

uses FMain, FAttrib, FConfirmDialog, FBottom, CharCls, FShowPopMsg, filepgkclass,
  Fbl, uPersonBat;

{$R *.dfm}

procedure _print_botton(astr: string);
begin
  FrmBottom.AddChat(astr, WinRGB(22, 22, 0), 0);
end;

procedure GatherLifeData(var BaseLifeData, aLifeData: TLifeData);
begin
  BaseLifeData.DamageBody := BaseLifeData.DamageBody + aLifeData.damageBody;
  BaseLifeData.DamageHead := BaseLifeData.DamageHead + aLifeData.damageHead;
  BaseLifeData.DamageArm := BaseLifeData.DamageArm + aLifeData.damageArm;
  BaseLifeData.DamageLeg := BaseLifeData.DamageLeg + aLifeData.damageLeg;

  BaseLifeData.AttackSpeed := BaseLifeData.AttackSpeed + aLifeData.AttackSpeed;
  BaseLifeData.avoid := BaseLifeData.avoid + aLifeData.avoid;
  BaseLifeData.recovery := BaseLifeData.recovery + aLifeData.recovery;
  BaseLifeData.HitArmor := BaseLifeData.HitArmor + aLifeData.HitArmor;
  BaseLifeData.armorBody := BaseLifeData.armorBody + aLifeData.armorBody;
  BaseLifeData.armorhead := BaseLifeData.armorHead + aLifeData.armorHead;
  BaseLifeData.armorArm := BaseLifeData.armorArm + aLifeData.armorArm;
  BaseLifeData.armorLeg := BaseLifeData.armorLeg + aLifeData.armorLeg;
end;

constructor TLifeDataList.Create;
begin
  DataList := TList.Create;
end;

procedure TLifeDataList.setLifeData;
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  FillChar(LifeData, SizeOf(TLifeData), 0);
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    GatherLifeData(LifeData, pp.LifeData);
  end;
  _print_botton('门派属性发生改变');
end;

function TLifeDataList.getLifedatastr(): string;
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  result := '';
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    result := result + '<$0023A4FA>' + pp.name + #13#10;
    if (pp.LifeData.damageBody <> 0) or (pp.LifeData.damageHead <> 0) or (pp.LifeData.damageArm <> 0) or (pp.LifeData.damageLeg <> 0) then
    begin
      //result := result + '<$001A4DFB>攻击:' + #13#10 + ' ';
      if pp.LifeData.damageBody <> 0 then
        result := result + format('<$001DF833>+身体攻击:%d', [pp.LifeData.damageBody]) + ' ';
      if pp.LifeData.damageHead <> 0 then
        result := result + format('+头:%d', [pp.LifeData.damageHead]) + ' ';
      if pp.LifeData.damageArm <> 0 then
        result := result + format('+手:%d', [pp.LifeData.damageArm]) + ' ';
      if pp.LifeData.damageLeg <> 0 then
        result := result + format('+脚:%d', [pp.LifeData.damageLeg]) + ' ';
      result := result + #13#10;
    end;
    if (pp.LifeData.armorBody <> 0) or (pp.LifeData.armorHead <> 0) or (pp.LifeData.armorArm <> 0) or (pp.LifeData.armorLeg <> 0) then
    begin
      //result := result + '<$001A4DFB>防御:' + #13#10 + ' ';
      if pp.LifeData.armorBody <> 0 then
        result := result + format('<$001DF833>+身体防御:%d', [pp.LifeData.armorBody]) + ' ';
      if pp.LifeData.armorHead <> 0 then
        result := result + format('+头:%d', [pp.LifeData.armorHead]) + ' ';
      if pp.LifeData.armorArm <> 0 then
        result := result + format('+手:%d', [pp.LifeData.armorArm]) + ' ';
      if pp.LifeData.armorLeg <> 0 then
        result := result + format('+脚:%d', [pp.LifeData.armorLeg]) + ' ';
      result := result + #13#10;
    end;

    if (pp.LifeData.AttackSpeed <> 0) then
    begin
      result := result + format('<$001DF833>+攻击速度:%d', [-pp.LifeData.AttackSpeed]) + ' ';
      result := result + #13#10;
    end;
    if (pp.LifeData.avoid <> 0) then
    begin
      result := result + format('<$001DF833>+躲避:%d', [pp.LifeData.avoid]) + ' ';
      result := result + #13#10;
    end;
    if (pp.LifeData.recovery <> 0) then
    begin
      result := result + format('<$001DF833>+恢复:%d', [-pp.LifeData.recovery]) + ' ';
      result := result + #13#10;
    end;
    if (pp.LifeData.HitArmor <> 0) then
    begin
      result := result + format('<$001DF833>+维持:%d', [-pp.LifeData.HitArmor]) + ' ';
      result := result + #13#10;
    end;
    if (pp.LifeData.accuracy <> 0) then
    begin
      result := result + format('<$001DF833>+命中:%d', [pp.LifeData.accuracy]) + ' ';
      result := result + #13#10;
    end;

  end;
end;

function TLifeDataList.del(aid: integer): boolean;
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  result := false;
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    if pp.rid = aid then
    begin
      _print_botton(format('门派状态%s消失', [pp.name]));
      dispose(pp);
      DataList.Delete(i);
      setLifeData;
      result := true;
      exit;
    end;
  end;

end;

function TLifeDataList.get(aid: integer): pTLifeDataListdata;
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    if pp.rid = aid then
    begin
      result := pp;
      exit;
    end;
  end;

end;

procedure TLifeDataList.upitem(pp: pTLifeDataListdata; var aitem: TLifeDataListdata);
begin
  _print_botton(format('门派状态%s覆盖为%s', [pp.name, aitem.name]));
  pp^ := aitem;

  setLifeData;

end;

function TLifeDataList.add(var aitem: TLifeDataListdata): boolean;
var
  pp: pTLifeDataListdata;
begin
  result := false;
  pp := get(aitem.rid);
  if pp <> nil then
  begin
    upitem(pp, aitem);
    exit;
  end;
  new(pp);
  pp^ := aitem;
  DataList.Add(pp);
  _print_botton(format('门派获得%s状态', [pp.name]));
  setLifeData;

  result := true;
end;

procedure TLifeDataList.Clear();
var
  i: integer;
  pp: pTLifeDataListdata;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    pp := DataList.Items[i];
    dispose(pp);
  end;
  DataList.Clear;
  _print_botton('所有门派状态被清除');
  setLifeData;
end;

destructor TLifeDataList.Destroy;
begin
  Clear;
  DataList.Free;
  inherited destroy;
end;
//////////////////////////////////////////////////////////

function Fdataonline(Item1, Item2: Pointer): Integer;
begin
  if PTGuildUserData(Item1).ronline > PTGuildUserData(Item2).ronline then Result := -1
  else if PTGuildUserData(Item1).ronline < PTGuildUserData(Item2).ronline then Result := 1
  else Result := 0;
end;

function Fdataname(Item1, Item2: Pointer): Integer;
begin
  if PTGuildUserData(Item1).rName > PTGuildUserData(Item2).rName then Result := -1
  else if PTGuildUserData(Item1).rName < PTGuildUserData(Item2).rName then Result := 1
  else Result := 0;
end;

function Fdataage(Item1, Item2: Pointer): Integer;
begin
  if PTGuildUserData(Item1).rage > PTGuildUserData(Item2).rage then Result := -1
  else if PTGuildUserData(Item1).rage < PTGuildUserData(Item2).rage then Result := 1
  else Result := 0;
end;

function FdataGradeName(Item1, Item2: Pointer): Integer;
begin
  if PTGuildUserData(Item1).rGradeName < PTGuildUserData(Item2).rGradeName then Result := -1
  else if PTGuildUserData(Item1).rGradeName < PTGuildUserData(Item2).rGradeName then Result := 1
  else Result := 0;
end;

function FdataJob(Item1, Item2: Pointer): Integer;
begin
  if PTGuildUserData(Item1).rjob > PTGuildUserData(Item2).rjob then Result := -1
  else if PTGuildUserData(Item1).rjob < PTGuildUserData(Item2).rjob then Result := 1
  else Result := 0;
end;

procedure TfrmGuild.FdataSort();
begin
  Fdata.Sort(FdataTListSortCompare);
  A2ListBox1.DrawItem;
  onlinecount;
end;

procedure TfrmGuild.SetGradeName(id: integer; astr: string);
var
  P: PTGuildUserData;
begin
  p := FdataGET(id);
  if p = nil then exit;
  astr := copy(astr, 1, 32);
  p.rGradeName := astr;

end;

procedure TfrmGuild.FdataDEL(id: integer);
var
  P: PTGuildUserData;
begin
  P := FdataGET(ID);
  if P = nil then EXIT;
  Fdata.Remove(p);
  dispose(P);
  if A2ListBox1.Count > 0 then
    A2ListBox1.DeleteItem(0);
  onlinecount;
end;
//CharCenterName

function TfrmGuild.FdataGETName(aName: string): PTGuildUserData;
var
  i: integer;
begin
  result := nil;
  if aName = '' then Exit; //2015.11.12 在水一方
  for i := 0 to Fdata.Count - 1 do
  begin
    if PTGuildUserData(Fdata.Items[i]).rName = aName then
    begin
      result := Fdata.Items[i];
      exit;
    end;
  end;
end;

function TfrmGuild.FdataGET(id: integer): PTGuildUserData;
var
  i: integer;
begin
  result := nil;
  for i := 0 to Fdata.Count - 1 do
  begin
    if PTGuildUserData(Fdata.Items[i]).rid = id then
    begin
      result := Fdata.Items[i];
      exit;
    end;
  end;
end;

function TfrmGuild.FdataGETIndex(id: integer): PTGuildUserData;
begin
  result := nil;
  if (id < 0) or (id >= Fdata.Count) then exit;
  result := Fdata.Items[ID];
end;

procedure TfrmGuild.FdataClear();
var
  I: INTEGER;
  P: PTGuildUserData;
begin
  for I := 0 to Fdata.Count - 1 do
  begin
    P := Fdata.Items[I];
    Dispose(p);
  end;
  Fdata.Clear;
  setGuildNotice('');
  A2Label_leve.Caption := '0';
  A2Label_num.Caption := '0';
  A2Label_maxnum.Caption := '0';
  A2ListBox1.Clear;
  onlinecount;
end;

procedure TfrmGuild.FdataADD(aGuildUserData: TGuildUserData);
var
  P: PTGuildUserData;
begin
  NEW(P);
  P^ := aGuildUserData;
  Fdata.Add(P);
  A2ListBox1.AddItem(' ');
  onlinecount;
end;

procedure TfrmGuild.SetGuildNotice(astr: string);
var
  S: string;
begin
  Guilnotice := astr;
  A2ILabelNotice.Caption := Guilnotice;
    { tempTA2Image.Clear(0);
     S := CutLengthString(astr, tempTA2Image.Width);
     ATextOut(tempTA2Image, 0, 0, ColorSysToDxColor(clWhite), S);
     S := CutLengthString(astr, tempTA2Image.Width);
     ATextOut(tempTA2Image, 0, 20, ColorSysToDxColor(clWhite), S);
   }
end;

procedure TfrmGuild.DrawDispathLifedata();
begin

end;

procedure TfrmGuild.MessageProcess(var code: TWordComData);
var
  pckey: PTCKey;
  pSHailFellowbasic: pTSHailFellowbasic;
  sname, astr, astr2: string;
  tempTGuildUserData: TGuildUserData;
  pGuildUserData: pTGuildUserData;
  akey: byte;
  id, anum, i: integer;
  frmConfirmDialog: TfrmConfirmDialog;
  templife: TLifeDataListdata;
begin
  pckey := @Code.Data;
  case pckey^.rmsg of
    SM_GUILD:
      begin

        id := 1;
        akey := WordComData_GETbyte(code, id);

        case akey of
          GUILD_Lifedata_add:
            begin
              templife.rid := WordComData_getdword(code, id);
              templife.rtime := WordComData_getdword(code, id);
              templife.name := WordComData_getstring(code, id);
              copymemory(@templife.LifeData, @code.data[id], sizeof(TLifeData));
              LifeDataList.add(templife);
              DrawDispathLifedata;
            end;
          GUILD_Lifedata_Update:
            begin
              templife.rid := WordComData_getdword(code, id);
              templife.rtime := WordComData_getdword(code, id);
              templife.name := WordComData_getstring(code, id);
              copymemory(@templife.LifeData, @code.data[id], sizeof(TLifeData));
              LifeDataList.add(templife);
              DrawDispathLifedata;
            end;
          GUILD_Lifedata_del:
            begin
              templife.rid := WordComData_getdword(code, id);
              LifeDataList.del(templife.rid);
              DrawDispathLifedata;

            end;

          GUILD_Lifedata_Clear:
            begin
              LifeDataList.Clear;
              DrawDispathLifedata;

            end;
          GUILD_sys:
            begin
              akey := WordComData_GETbyte(code, id);
              if boolean(akey) then
              begin
                astr := '门派进入自由攻击模式';
                FrmBottom.AddChat(astr, WinRGB(1, 31, 31), WinRGB(1, 14, 20));
                FrmBottom.AddChat(astr, WinRGB(1, 31, 31), WinRGB(1, 14, 20));
                FrmBottom.AddChat(astr, WinRGB(1, 31, 31), WinRGB(1, 14, 20));
                PersonBat.RollMSGadd(astr, ColorSysToDxColor($0000FFFF));
              end else
              begin
                astr := '门派进入保护模式';
                FrmBottom.AddChat(astr, WinRGB(1, 31, 31), WinRGB(1, 14, 20));
                FrmBottom.AddChat(astr, WinRGB(1, 31, 31), WinRGB(1, 14, 20));
                FrmBottom.AddChat(astr, WinRGB(1, 31, 31), WinRGB(1, 14, 20));
                PersonBat.RollMSGadd(astr, ColorSysToDxColor($0000FF00));
              end;
            end;
          GUILD_list_ForceDelAll:
            begin

              FrmBottom.AddChat(format('%s:门派灭门。', [guildname]), WinRGB(22, 22, 0), 0);
              FdataClear;
            end;
          GUILD_list_hit:
            begin
              GuilDurability := WordComData_GETdword(code, id);
              FrmBottom.AddChat(format('%s:门派石遭攻击', [guildname]), WinRGB(22, 22, 0), 0);
                          //  FrmBottom.AddChat(format('%s:门派石被攻击,耐久：'+inttostr(GuilDurability), [guildname]), WinRGB(22, 22, 0), 0);
            end;
          GUILD_list_addMsg, GUILD_list_addALLYMsg: //被 人 加 是否同意
            begin
              frmPopMsg.MessageProcess(code);
            end;
          GUILD_Create_name:
            begin
                            // frmPopMsg.MessageProcess(code);
                            //创建 输入 窗口
              frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
              frmConfirmDialog.ShowFrom(cdtguild_createName, '创建门派；请输入门派名字。', '');
              anum := WordComData_GETbyte(code, id);
              frmConfirmDialog.aid := anum;
            end;
          GUILD_list_SubSysop:
            begin
                            //副门主  权利 变动
              i := WordComData_GETdword(code, ID); //ID
              anum := WordComData_GETdword(code, ID); //职位
              pGuildUserData := FdataGET(i);
              if pGuildUserData = nil then exit;
              astr := pGuildUserData.rName;
                            //if not pGuildUserData.rjob = anum then
              begin
                pGuildUserData.rjob := anum;
                case anum of
                  GUILD_job_Sysop: astr2 := format('%s 被任命为门主', [astr]);
                  GUILD_job_SubSysop: astr2 := format('%s 被任命为副门主', [astr]);
                  GUILD_job_None: astr2 := format('%s 被任命为门徒', [astr]);
                else exit;
                end;
                FrmBottom.AddChat(astr2, WinRGB(22, 22, 0), 0);
              end;
              ShowSelfGuildInfo;
              A2ListBox1.DrawItem;
            end;
          GUILD_GradeNameUPDATE:
            begin
              i := WordComData_GETdword(code, ID); //ID
              astr := WordComData_getString(code, id);
              SetGradeName(i, astr);
              pGuildUserData := FdataGET(i);
              if pGuildUserData <> nil then
              begin
                if pGuildUserData.rName = CharCenterName then
                begin

                  FrmBottom.AddChat(format('获得的职称是【%s】', [astr]), WinRGB(22, 22, 0), 0);
                end;
              end;
              ShowSelfGuildInfo;
              A2ListBox1.DrawItem;
            end;
          GUILD_noticeUPdate:
            begin
              SetGuildNotice(WordComData_getString(code, id)); //门派 公告
              FrmBottom.AddChat('本门派公告已经修改。', WinRGB(22, 22, 0), 0);

            end;
          GUILD_list_add:
            begin
              tempTGuildUserData.rid := WordComData_GETdword(code, ID); //ID
              tempTGuildUserData.rLastDay := WordComData_GETdword(code, ID); //持续天
              tempTGuildUserData.rage := WordComData_GETdword(code, ID); //年龄
              tempTGuildUserData.rjob := WordComData_GETdword(code, ID); //职位
              tempTGuildUserData.ronline := boolean(WordComData_getbyte(code, id)); //在线

              tempTGuildUserData.rName := WordComData_GETString(code, ID); //名字
              tempTGuildUserData.rGradeName := WordComData_GETString(code, ID); //封号
              if FdataGET(tempTGuildUserData.rid) = nil then
              begin
                FrmBottom.AddChat(format('%s:将【%s】加入了.', [guildname, tempTGuildUserData.rName]), WinRGB(22, 22, 0), 0);
                FdataADD(tempTGuildUserData); //
              end;

              FdataSort;
            end;
          GUILD_list_ForceDel:
            begin
              i := WordComData_GETdword(code, ID); //ID
              pGuildUserData := FdataGET(i);
              if pGuildUserData <> nil then
              begin
                pGuildUserData.ronline := true;
                if pGuildUserData.rName = CharCenterName then
                begin
                  FdataClear;
                  FrmBottom.AddChat('你已经被踢出门派了', WinRGB(22, 22, 0), 0);
                end else
                begin

                  FrmBottom.AddChat(format('%s (%s)已被踢出门派。', [pGuildUserData.rName, pGuildUserData.rGradeName]), WinRGB(22, 22, 0), 0);
                  FdataDEL(i);
                end;
              end;

            end;
          GUILD_list_del:
            begin
              i := WordComData_GETdword(code, ID); //ID
              pGuildUserData := FdataGET(i);
              if pGuildUserData <> nil then
              begin
                pGuildUserData.ronline := true;
                if pGuildUserData.rName = CharCenterName then
                begin
                  FdataClear;
                  FrmBottom.AddChat('你已经脱离门派了', WinRGB(22, 22, 0), 0);
                end else
                begin

                  FrmBottom.AddChat(format('%s (%s)已脱离门派。', [pGuildUserData.rName, pGuildUserData.rGradeName]), WinRGB(22, 22, 0), 0);
                  FdataDEL(i);
                end;
              end;

            end;
          GUILD_list_online:
            begin
              i := WordComData_GETdword(code, ID); //ID
              pGuildUserData := FdataGET(i);
              if pGuildUserData <> nil then
              begin
                pGuildUserData.ronline := true;
                FrmBottom.AddChat(format('%s (%s)连线了。', [pGuildUserData.rName, pGuildUserData.rGradeName]), WinRGB(22, 22, 0), 0);
              end;
              FdataSort;

            end;
          GUILD_list_GameExit:
            begin
              i := WordComData_GETdword(code, ID); //ID
              pGuildUserData := FdataGET(i);
              if pGuildUserData <> nil then
              begin
                pGuildUserData.ronline := false;
                FrmBottom.AddChat(format('%s(%s)离线了', [pGuildUserData.rName, pGuildUserData.rGradeName]), WinRGB(22, 22, 0), 0);
              end;
            end;
          GUILD_Level:
            begin
              GuildLevel := WordComData_getdword(code, id); //门派 等级
              A2Label_leve.Caption := inttostr(GuildLevel);
              GuilMaxNum := WordComData_getdword(code, id); //门派 最大人数
              A2Label_maxnum.Caption := inttostr(GuilMaxNum);
            end;
          GUILD_list_head:
            begin
              FdataClear;
              guildname := WordComData_GETString(code, id); //名字
              A2Label_GuildName.Caption := guildname;

              GuildLevel := WordComData_getbyte(code, id); //门派 等级
              A2Label_leve.Caption := inttostr(GuildLevel);

              GuilMaxNum := WordComData_getbyte(code, id); //门派 最大人数
              A2Label_maxnum.Caption := inttostr(GuilMaxNum);

              SetGuildNotice(WordComData_getString(code, id)); //门派 公告
              GuilDurability := WordComData_getdword(code, id);
              GuilDurabilityMAX := WordComData_getdword(code, id);
              A2Label_urability.Caption := inttostr(GuilDurability) + '/' + inttostr(GuilDurabilityMAX);

              FGuildX := WordComData_getdword(code, id);
              FGuildY := WordComData_getdword(code, id);

              A2Label_GuildPoint.Caption := IntToStr(FGuildX) + ',' + inttostr(FGuildY);

              FGuildMagic := WordComData_getString(code, id);
               //if FGuildMagic='' then
              //   FGuildMagic:='无门派武功';
              A2Label_GuildMagic.Caption := FGuildMagic;
              FGuildMakeDate := WordComData_getString(code, id);
              A2Label_MakeDate.Caption := FGuildMakeDate;
              FGuildEnegy := WordComData_getdword(code, id); //积分？
               //A2Label_Enegy.Caption:= IntToStr(FGuildEnegy);
              FGuildMaxEnegy := WordComData_getdword(code, id); //升级积分？
              if FGuildMaxEnegy > 0 then
                A2Label_Enegy.Caption := IntToStr(FGuildEnegy) + '/' + IntToStr(FGuildMaxEnegy)
              else
                A2Label_Enegy.Caption := IntToStr(FGuildEnegy) + '/满级';

              FGuildSysop := WordComData_getString(code, id);
              A2Label_Sysop.Caption := FGuildSysop;
//                WordComData_ADDDWORD(tempsend, SelfData.x);
//  WordComData_ADDDWORD(tempsend, SelfData.y); //门派坐标
//  WordComData_ADDString(tempsend, SelfData.GuildMagic); //门派武功
//  WordComData_ADDString(tempsend, SelfData.MakeDate); //创建日期
//  WordComData_ADDDWORD(tempsend, SelfData.rMaxEnegy); //积分？
//  WordComData_ADDString(tempsend, SelfData.Sysop); //门主
            end;
          GUILD_list:
            begin

              anum := WordComData_GETword(code, id); //数量

              for i := 0 to anum - 1 do
              begin
                tempTGuildUserData.rid := WordComData_GETdword(code, ID); //ID
                tempTGuildUserData.rLastDay := WordComData_GETdword(code, ID); //持续天
                tempTGuildUserData.rage := WordComData_GETdword(code, ID); //年龄
                tempTGuildUserData.rjob := WordComData_GETdword(code, ID); //职位
                tempTGuildUserData.ronline := boolean(WordComData_getbyte(code, id)); //在线

                tempTGuildUserData.rName := WordComData_GETString(code, ID); //名字
                tempTGuildUserData.rGradeName := WordComData_GETString(code, ID); //封号
                tempTGuildUserData.rEnergy := WordComData_GETdword(code, ID); //元气
                tempTGuildUserData.rGuildPoint := WordComData_GETdword(code, ID); //贡献
                FdataADD(tempTGuildUserData); //
              end;
              ShowSelfGuildInfo;
              FdataSort;
            end;

        end;

      end;
  end;
end;

procedure TfrmGuild.onlinecount();
var
  i, j2: integer;
  pp: pTGuildUserData;
begin
  j2 := 0;
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[i];
    if pp.ronline then
      inc(j2);
  end;

  A2Label_num.Caption := format('%d/%d', [j2, Fdata.Count]);
end;

procedure TfrmGuild.SetNewVersion;
begin
  inherited;
end;

//procedure TfrmGuild.SetOldVersion;
//begin
//  pgkBmp.getBmp('guild.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//  A2ListBox1.SetScrollTopImage(getviewImage(7), getviewImage(6));
//  A2ListBox1.SetScrollTrackImage(getviewImage(4), getviewImage(5));
//  A2ListBox1.SetScrollBottomImage(getviewImage(9), getviewImage(8));
//  A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($9B7781);
//end;

procedure TfrmGuild.FormCreate(Sender: TObject);
begin
  inherited;
  FGNameX := 0;
  FGNameY := 0;
  FGEnergyX := 100;
  FGEnergyY := 0;
  FGPointX := 155;
  FGPointY := 0;
  FGOnlineColor := 32767;
  FGOfflineColor := 300;
  FTestPos := True;
  FrmM.AddA2Form(Self, A2form);

  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;
    //Parent := FrmM;
  Left := 0;
  Top := 0;
  A2ILabelNotice.Transparent := true;
  Fdata := TLIST.Create;
  tempTA2Image := TA2Image.Create(A2ILabelNotice.Width, A2ILabelNotice.Height, 0, 0);
    //  A2ILabelNotice.A2Image := tempTA2Image;
  tempTA2Image.Clear(0);

  FdataClear;
  FdataTListSortCompare := Fdataonline;
  LifeDataList := TLifeDataList.Create;
end;

procedure TfrmGuild.FormDestroy(Sender: TObject);
begin
  FdataClear;
  Fdata.Free;
  tempTA2Image.Free;
  LifeDataList.Free;
end;

procedure TfrmGuild.A2ListBox1AdxDrawItem(ASurface: TA2Image;
  index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
  fy: Integer);
var
  P: PTGuildUserData;
  fontcolor: Integer;
begin

 // ShowSelfGuildInfo();
  P := FdataGETIndex(index);
  if P = nil then EXIT;
  if p.ronline then
    fontcolor := FGOnlineColor
  else
    fontcolor := FGOfflineColor;

  case P.rjob of
    GUILD_job_None: aStr := '';
    GUILD_job_Sysop: aStr := '门主';
    GUILD_job_SubSysop: aStr := '副门主';
  else aStr := '';
  end;
    // ATextOut(ASurface, 0, 0, 32767, inttostr(index));
  if aStr <> '' then
    ATextOut(ASurface, FGNameX, FGNameY, fontcolor, P.rName + '(' + aStr + ')') else

    ATextOut(ASurface, FGNameX, FGNameY, fontcolor, P.rName);
  aStr := Get10000To100(p.rEnergy);
  ATextOut(ASurface, FGEnergyX, FGEnergyY, fontcolor, aStr);
  astr := P.rGradeName;
  aStr := IntToStr(p.rGuildPoint);
  if length(astr) > 12 then astr := copy(astr, 1, 12);
  ATextOut(ASurface, FGPointX, FGPointY, fontcolor, astr);

//  ATextOut(ASurface, 240, 0, 32767, Get10000To100(p.rage));
//  if p.ronline then
//    astr := '在线'
//  else astr := '离线';
//  ATextOut(ASurface, 320, 0, 32767, astr);
end;

procedure TfrmGuild.sendGUILD_set_SubSysop(aname: string);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_set_SubSysop);
  WordComData_ADDString(temp, aname);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.sendGUILD_set_Sysop(aname: string);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_set_Sysop);
  WordComData_ADDString(temp, aname);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.sendGUILD_del_SubSysop(aname: string);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_del_SubSysop);
  WordComData_ADDString(temp, aname);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.sendGuilddel(aname: string);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_del);
  WordComData_ADDString(temp, aname);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.sendGUILD_del_SubSysop_ic();
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_del_SubSysop_ic);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.sendGuilddel_ic();
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_del_i);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.sendGuilGradeNameUPdate(aname, atext: string);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_GradeNameUPDATE);
  WordComData_ADDString(temp, aname);
  WordComData_ADDString(temp, atext);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.sendGuildAdd(aname: string);
var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_add);
  WordComData_ADDString(temp, aname);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

function TfrmGuild.isSysop(): boolean;
var
  p: PTGuildUserData;
begin
  result := false;
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  if P.rjob = GUILD_job_Sysop then result := true; //aStr := '门主';
end;

function TfrmGuild.isSubSysop(): boolean;
var
  p: PTGuildUserData;
begin
  result := false;
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  if P.rjob = GUILD_job_SubSysop then result := true; //aStr := '副门主';
end;

function TfrmGuild.isSubSysop2(AName: string): boolean;
var
  p: PTGuildUserData;
begin
  result := false;
  p := FdataGETName(AName);
  if p = nil then exit;
  if P.rjob = GUILD_job_SubSysop then result := true; //aStr := '副门主';
end;

procedure TfrmGuild.A2Button_addClick(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
begin
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop: ; //aStr := '门主';
    GUILD_job_SubSysop: ; //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;
    //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtGuildAdd, '输入要加入玩家名字', '');

end;

procedure TfrmGuild.A2Button6Click(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
begin
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
    //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtGuildDel, '', '你真的要退出门派吗？');

end;

procedure TfrmGuild.A2Button4Click(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
begin
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop: ; //aStr := '门主';
    GUILD_job_SubSysop: ; //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;
    //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtGuilnoticeUPdate, '输入公告内容', '');

end;

procedure TfrmGuild.A2Button3Click(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
  astr: string;
begin
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop: ; //aStr := '门主';
    GUILD_job_SubSysop: ; //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;
    //

  p := FdataGETIndex(A2ListBox1.ItemIndex);
  if p = nil then
  begin
    FrmBottom.AddChat('请先选择门徒。', WinRGB(22, 22, 0), 0);
    exit;
  end;
  astr := p.rName;
    //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtGuildDel_Force, astr, format('你真的要把【%s】踢出门派吗？', [astr]));

end;

procedure TfrmGuild.A2Button7Click(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
  astr: string;
begin
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop: ; //aStr := '门主';
    GUILD_job_SubSysop: ; //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;
    //

  p := FdataGETIndex(A2ListBox1.ItemIndex);
  if p = nil then
  begin
    FrmBottom.AddChat('请先选择门徒。', WinRGB(22, 22, 0), 0);
    exit;
  end;
  astr := p.rName;
    //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtGuilGradeNameUPdate, format('输入要赋予【%s】的职称', [astr]), astr);

end;

procedure TfrmGuild.A2Button2Click(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
  astr: string;
  selfisSubSysop: Boolean;
begin
  selfisSubSysop := False;
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop: ; //aStr := '门主';
    GUILD_job_SubSysop: selfisSubSysop := True; //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;
    //

  p := FdataGETIndex(A2ListBox1.ItemIndex);
  if p = nil then
  begin
    FrmBottom.AddChat('请先选择门徒。', WinRGB(22, 22, 0), 0);
    exit;
  end;
  astr := p.rName;
  if isSubSysop2(astr) then
  begin

    if selfisSubSysop then
    begin
      frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
      frmConfirmDialog.ShowFrom(cdtguildSubSysopdel, '', '你真的要放弃副门主吗？');
    end else
    begin
                               //创建 输入 窗口
      frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
      frmConfirmDialog.ShowFrom(cdtguildSysdel_SubSysop, astr, format('你真的要将副门主【%s】权力删除？', [astr]));
    end;

  end else
  begin
             //创建 输入 窗口
    frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
    frmConfirmDialog.ShowFrom(cdtGuildelevate, astr, format('你真的要赐予【%s】副门主职位吗？', [astr]));
  end;



end;

procedure TfrmGuild.A2Button1Click(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
  astr: string;
begin
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
    //创建 输入 窗口
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop:
      begin
        p := FdataGETIndex(A2ListBox1.ItemIndex);
        if p = nil then
        begin
          FrmBottom.AddChat('请先选择门徒。', WinRGB(22, 22, 0), 0);
          exit;
        end;
        astr := p.rName;

                //创建 输入 窗口
        frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
        frmConfirmDialog.ShowFrom(cdtguildSysdel_SubSysop, astr, format('你真的要将副门主【%s】权力删除？', [astr]));
      end; //aStr := '门主';
    GUILD_job_SubSysop:
      begin
        frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
        frmConfirmDialog.ShowFrom(cdtguildSubSysopdel, '', '你真的要放弃副门主吗？');
      end; //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;

end;

procedure TfrmGuild.A2Button12Click(Sender: TObject);
begin
  FdataTListSortCompare := Fdataonline;
  FdataSort;
end;

procedure TfrmGuild.A2Button11Click(Sender: TObject);
begin
  FdataTListSortCompare := Fdataage;
  FdataSort;

end;

procedure TfrmGuild.A2Button10Click(Sender: TObject);
begin
  FdataTListSortCompare := FdataGradeName;
  FdataSort;
end;

procedure TfrmGuild.A2Button9Click(Sender: TObject);
begin
  FdataTListSortCompare := FdataJob;
  FdataSort;
end;

procedure TfrmGuild.A2Button8Click(Sender: TObject);
begin
  FdataTListSortCompare := Fdataname;
  FdataSort;
end;

procedure TfrmGuild.A2Button14Click(Sender: TObject);
begin
  Visible := false;
end;

procedure TfrmGuild.A2Label_GuildName1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
//  A2Form.FA2Hint.Ftype := hstTransparent;
  GameHint.setText(integer(Sender), LifeDataList.getLifedatastr);
end;

procedure TfrmGuild.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmGuild.A2Button5Click(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
  astr: string;
begin
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop: ; //aStr := '门主';
        //  GUILD_job_SubSysop:;       //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;
    //

  p := FdataGETIndex(A2ListBox1.ItemIndex);
  if p = nil then
  begin
    FrmBottom.AddChat('请先选择继承人。', WinRGB(22, 22, 0), 0);
    exit;
  end;
  astr := p.rName;
    //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtGuildSetSys, astr, format('你真的要让位给【%s】吗？', [astr]));

end;

procedure TfrmGuild.SetConfigFileName;
begin
  FConfigFileName := 'Guild.xml';

end;

//procedure TfrmGuild.SetNewVersionOld;
//var
//  temping: TA2Image;
//  tempUp, tempDown: TA2Image;
//begin
//  temping := TA2Image.Create(32, 32, 0, 0);
//  tempUp := TA2Image.Create(32, 32, 0, 0);
//  tempDown := TA2Image.Create(32, 32, 0, 0);
//  try
//    A2Label_GuildName.Font.Color := ColorSysToDxColor($000FFFF0);
//        //A2Label_GuildName.Layout := tlCenter;
//    A2Label_GuildName.Left := 157;
//    A2Label_GuildName.Top := 19;
//    A2Label_GuildName.Width := 106;
//    A2Label_GuildName.Height := 15;
//
//    pgkBmp.getBmp('门派管理窗口.bmp', A2Form.FImageSurface);
//    A2Form.boImagesurface := true;
//
//    pgkBmp.getBmp('门派管理_删除职位_弹起.bmp', temping);
//    A2Button1.A2Up := temping;
//    pgkBmp.getBmp('门派管理_删除职位_按下.bmp', temping);
//    A2Button1.A2Down := temping;
//    pgkBmp.getBmp('门派管理_删除职位_鼠标.bmp', temping);
//    A2Button1.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_删除职位_禁止.bmp', temping);
//    A2Button1.A2NotEnabled := temping;
//    A2Button1.Left := 277;
//    A2Button1.Top := 285;
//
//    pgkBmp.getBmp('门派管理_赐予职位_弹起.bmp', temping);
//    A2Button2.A2Up := temping;
//    pgkBmp.getBmp('门派管理_赐予职位_按下.bmp', temping);
//    A2Button2.A2Down := temping;
//    pgkBmp.getBmp('门派管理_赐予职位_鼠标.bmp', temping);
//    A2Button2.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_赐予职位_禁止.bmp', temping);
//    A2Button2.A2NotEnabled := temping;
//    A2Button2.Left := 214;
//    A2Button2.Top := 285;
//
//    pgkBmp.getBmp('门派管理_踢出门派_弹起.bmp', temping);
//    A2Button3.A2Up := temping;
//    pgkBmp.getBmp('门派管理_踢出门派_按下.bmp', temping);
//    A2Button3.A2Down := temping;
//    pgkBmp.getBmp('门派管理_踢出门派_鼠标.bmp', temping);
//    A2Button3.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_踢出门派_禁止.bmp', temping);
//    A2Button3.A2NotEnabled := temping;
//    A2Button3.Left := 340;
//    A2Button3.Top := 235;
//
//    pgkBmp.getBmp('门派管理_修改公告_弹起.bmp', temping);
//    A2Button4.A2Up := temping;
//    pgkBmp.getBmp('门派管理_修改公告_按下.bmp', temping);
//    A2Button4.A2Down := temping;
//    pgkBmp.getBmp('门派管理_修改公告_鼠标.bmp', temping);
//    A2Button4.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_修改公告_禁止.bmp', temping);
//    A2Button4.A2NotEnabled := temping;
//    A2Button4.Left := 277;
//    A2Button4.Top := 235;
//
//    pgkBmp.getBmp('门派管理_门主让位_弹起.bmp', temping);
//    A2Button5.A2Up := temping;
//    pgkBmp.getBmp('门派管理_门主让位_按下.bmp', temping);
//    A2Button5.A2Down := temping;
//    pgkBmp.getBmp('门派管理_门主让位_鼠标.bmp', temping);
//    A2Button5.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_门主让位_禁止.bmp', temping);
//    A2Button5.A2NotEnabled := temping;
//    A2Button5.Left := 277;
//    A2Button5.Top := 260;
//
//    pgkBmp.getBmp('门派管理_退出门派_弹起.bmp', temping);
//    A2Button6.A2Up := temping;
//    pgkBmp.getBmp('门派管理_退出门派_按下.bmp', temping);
//    A2Button6.A2Down := temping;
//    pgkBmp.getBmp('门派管理_退出门派_鼠标.bmp', temping);
//    A2Button6.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_退出门派_禁止.bmp', temping);
//    A2Button6.A2NotEnabled := temping;
//    A2Button6.Left := 340;
//    A2Button6.Top := 260;
//
//    pgkBmp.getBmp('门派管理_赐予职称_弹起.bmp', temping);
//    A2Button7.A2Up := temping;
//    pgkBmp.getBmp('门派管理_赐予职称_按下.bmp', temping);
//    A2Button7.A2Down := temping;
//    pgkBmp.getBmp('门派管理_赐予职称_鼠标.bmp', temping);
//    A2Button7.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_赐予职称_禁止.bmp', temping);
//    A2Button7.A2NotEnabled := temping;
//    A2Button7.Left := 151;
//    A2Button7.Top := 285;
//
//    pgkBmp.getBmp('门派管理_加入成员_弹起.bmp', temping);
//    A2Button_add.A2Up := temping;
//    pgkBmp.getBmp('门派管理_加入成员_按下.bmp', temping);
//    A2Button_add.A2Down := temping;
//    pgkBmp.getBmp('门派管理_加入成员_鼠标.bmp', temping);
//    A2Button_add.A2Mouse := temping;
//    pgkBmp.getBmp('门派管理_加入成员_禁止.bmp', temping);
//    A2Button_add.A2NotEnabled := temping;
//    A2Button_add.Left := 340;
//    A2Button_add.Top := 285;
//
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//    A2Button14.A2Up := temping;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//    A2Button14.A2Down := temping;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//    A2Button14.A2Mouse := temping;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//    A2Button14.A2NotEnabled := temping;
//    A2Button14.Left := 379;
//    A2Button14.Top := 17;
//
//    A2ListBox1.Left := 21;
//    A2ListBox1.Top := 80;
//    A2ListBox1.Width := 377;
//    A2ListBox1.Height := 132;
//    pgkBmp.getBmp('门派管理_下拉条底框.bmp', temping);
//    A2ListBox1.SetScrollBackImage(temping);
//    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
//    A2ListBox1.SetScrollTopImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
//    A2ListBox1.SetScrollTrackImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
//    A2ListBox1.SetScrollBottomImage(tempUp, tempDown);
//    A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($00FF00AA);
//
//    A2ILabelNotice.Left := 22;
//    A2ILabelNotice.Top := 236;
//    A2ILabelNotice.Width := 245;
//    A2ILabelNotice.Height := 42;
//
//    A2Button8.Left := 23;
//    A2Button8.Top := 64;
//    A2Button9.Left := 95;
//    A2Button9.Top := 64;
//    A2Button10.Left := 169;
//    A2Button10.Top := 64;
//    A2Button11.Left := 242;
//    A2Button11.Top := 64;
//    A2Button12.Left := 371;
//    A2Button12.Top := 64;
//
//    A2Label_leve.Left := 85;
//    A2Label_leve.Top := 217;
//    A2Label_maxnum.Left := 190;
//    A2Label_maxnum.Top := 217;
//    A2Label_num.Left := 294;
//    A2Label_num.Top := 217;
//  finally
//    tempUp.Free;
//    tempDown.Free;
//    temping.Free;
//  end;
//
//end;

procedure TfrmGuild.SetNewVersionTest;
begin
  inherited;
  ReadOtherConfig;
  SetControlPos(Self);
  A2Label_GuildName.Font.Color := ColorSysToDxColor($000FFFF0);

  SetControlPos(A2Label_GuildName);
  SetControlPos(A2Label_GuildPoint);
  SetControlPos(A2Label_GuildMagic);
  SetControlPos(A2Label_MakeDate);
  SetControlPos(A2Label_Enegy);
  SetControlPos(A2Label_Sysop);
  SetControlPos(A2Label_urability);
  SetControlPos(A2Label_GradeName);
  SetControlPos(A2Label_Job);



  //A2form.FImageSurface.LoadFromFile('.\ui\img\门派管理窗口.bmp'); //2015.11.13 在水一方 >>>>>>
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface); //<<<<<<

  A2form.boImagesurface := true;

  SetControlPos(A2Button1);
  SetControlPos(A2Button2);

  SetControlPos(A2Button3);

  SetControlPos(A2Button4);
  SetControlPos(A2Button5);
  SetControlPos(A2Button6);
  SetControlPos(A2Button7);

  SetControlPos(A2Button_add);

  SetControlPos(A2Button14);


  SetControlPos(A2ListBox1);



  A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($00FF00AA);
  SetControlPos(A2ILabelNotice);
  SetControlPos(A2Button8);
  SetControlPos(A2Button9);
  SetControlPos(A2Button10);

  SetControlPos(A2Button11);
  SetControlPos(A2Button12);
  SetControlPos(A2Label_leve);
  SetControlPos(A2Label_maxnum);
  SetControlPos(A2Label_num);

 //2014 11 26新增
  SetControlPos(AbtnSetGuildJob);
end;

procedure TfrmGuild.settransparent(transparent: Boolean);
begin
  self.A2Form.TransParent := transparent;

end;

procedure TfrmGuild.ShowSelfGuildInfo;
var
  selfGuildData: PTGuildUserData;
  aStr: string;
begin
  selfGuildData := FdataGETName(CharCenterName);
  if selfGuildData <> nil then
  begin
    A2Label_GradeName.Caption := selfGuildData^.rGradeName; //称号
    case selfGuildData^.rjob of
      GUILD_job_Sysop: aStr := '门主';
      GUILD_job_SubSysop: aStr := '副门主';
      GUILD_job_None: aStr := '门徒';
    end;
    A2Label_Job.Caption := aStr;
  end;
end;

procedure TfrmGuild.ReadOtherConfig;
var
  node: TXmlNode;
begin
  node := FUIConfig.Root.NodeByName('Views').FindNode('guildlist');
  if (node <> nil) then
  begin


    FGNameX := node.ReadInteger('gnamex', 0);
    FGNameY := node.ReadInteger('gnamey', 0);
    FGEnergyX := node.ReadInteger('genergyx', 100);
    FGEnergyY := node.ReadInteger('genergyy', 0);
    FGPointX := node.ReadInteger('gpointx', 155);
    FGPointY := node.ReadInteger('gpointy', 0);
    FGOnlineColor := node.ReadInteger('gonlinecolor', 32767);
    FGOfflineColor := node.ReadInteger('gofflinecolor', 300);
  end;
end;

procedure TfrmGuild.AbtnSetGuildJobClick(Sender: TObject);
var
  frmConfirmDialog: TfrmConfirmDialog;
  p: PTGuildUserData;
  astr: string;
  selfisSubSysop: Boolean;
begin
  selfisSubSysop := False;
  p := FdataGETName(CharCenterName);
  if p = nil then exit;
  case P.rjob of
    GUILD_job_Sysop: ; //aStr := '门主';
    GUILD_job_SubSysop: selfisSubSysop := True; //aStr := '副门主';
  else
    begin
      FrmBottom.AddChat(format('%s(%s)你没权限！', [p.rName, p.rGradeName]), WinRGB(22, 22, 0), 0);
      exit;
    end;
  end;
    //

  p := FdataGETIndex(A2ListBox1.ItemIndex);
  if p = nil then
  begin
    FrmBottom.AddChat('请先选择门徒。', WinRGB(22, 22, 0), 0);
    exit;
  end;
  astr := p.rName;
             //创建 输入 窗口
  frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
  frmConfirmDialog.ShowFrom(cdtSetGuildMagicToUser, astr, format('你真的要传授【%s】门派武功吗？', [astr]));

end;

procedure TfrmGuild.sendGUILD_get_info;

var
  temp: TWordComData;
begin
  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Guild);
  WordComData_ADDbyte(temp, GUILD_get_info);
  Frmfbl.SocketAddData(temp.Size, @temp.data);
end;

procedure TfrmGuild.FormShow(Sender: TObject);
begin
  inherited;
  if Visible then
    sendGUILD_get_info;
end;

function TfrmGuild.getGuildJob: string;
begin
  Result := A2Label_Job.Caption;
end;

end.

