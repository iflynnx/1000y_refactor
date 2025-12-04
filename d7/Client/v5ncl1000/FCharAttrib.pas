unit FCharAttrib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, A2Form, A2Img, deftype, ExtCtrls, NativeXml, BaseUIForm;
type
  TTalentData = record
    newBone: word;
    newLeg: word;
    newSavvy: word;
    newAttackPower: word;
    newTalent: Integer;
  end;
  TfrmCharAttrib = class(TfrmBaseUI)

    lbname: TA2Label;
    lblAttackSpeed: TA2Label;
    lblAvoid: TA2Label;
    lblAccuracy: TA2Label;
    lblRecovery: TA2Label;
    lblDamageBody: TA2Label;
    lblDamageHead: TA2Label;
    lblDamageArm: TA2Label;
    lblDamageLeg: TA2Label;
    lblArmorBody: TA2Label;
    lblArmorHead: TA2Label;
    lblArmorArm: TA2Label;
    lblArmorLeg: TA2Label;
    lblInPower: TA2Label;
    lblOutPower: TA2Label;
    lblMagic: TA2Label;
    lblLife: TA2Label;
    lblDefaultValue: TA2Label;
    lblAttribTotal: TA2Label;
    lblShoutLevel: TA2Label;
    lblLover: TA2Label;
    A2Form: TA2Form;
    A2Button14: TA2Button;
    LbAdaptive: TA2Label;
    LbRevival: TA2Label;
    Lbguildname: TA2Label;
    lblAge: TA2Label;
    lbPrestige: TA2Label;
    lbEnergy: TA2Label;
    lbVirtue: TA2Label;
    Timer1: TTimer;
    A2Button_Designation: TA2Button;
    A2LabelDesignation: TA2Label;
    listDesignation: TA2ListBox;
    A2Label_Designation_back: TA2ILabel;
    A2Button_showJOb: TA2Button;
    lbhitarmor: TA2Label;
    A2Label1: TA2Label;
    lbOnlineTime: TA2Label;
    Lbguildjob: TA2Label;
    LbLucky: TA2Label;
    lbTalent: TA2Label;
    lbTalentLv: TA2Label;
    lbTalentExp: TA2Label;
    lbnewBone: TA2Label;
    lbnewLeg: TA2Label;
    lbnewSavvy: TA2Label;
    lbnewAttackPower: TA2Label;
    btnnewBoneadd: TA2Button;
    btnnewBonesub: TA2Button;
    btnnewLegadd: TA2Button;
    btnnewLegsub: TA2Button;
    btnnewSavvysub: TA2Button;
    btnnewSavvyadd: TA2Button;
    btnnewAttackPoweradd: TA2Button;
    btnnewAttackPowersub: TA2Button;
    btnSaveTalent: TA2Button;
    btnEggFlower: TA2Button;
    lblcharm: TA2Label;
    lblEgg: TA2Label;
    lblFlower: TA2Label;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2Button14Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A2Button_DesignationClick(Sender: TObject);
    procedure listDesignationMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A2Button_showJObClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveTalentClick(Sender: TObject);
    procedure btnnewBoneaddClick(Sender: TObject);
    procedure btnnewLegaddClick(Sender: TObject);
    procedure btnnewSavvyaddClick(Sender: TObject);
    procedure btnnewAttackPoweraddClick(Sender: TObject);
    procedure btnnewBonesubClick(Sender: TObject);
    procedure btnnewLegsubClick(Sender: TObject);
    procedure btnnewSavvysubClick(Sender: TObject);
    procedure btnnewAttackPowersubClick(Sender: TObject);
    procedure lbnewBoneMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbnewBoneMouseLeave(Sender: TObject);
    procedure lbnewLegMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbnewLegMouseLeave(Sender: TObject);
    procedure lbnewSavvyMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbnewSavvyMouseLeave(Sender: TObject);
    procedure lbnewAttackPowerMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure lbnewAttackPowerMouseLeave(Sender: TObject);
    procedure btnEggFlowerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnEggFlowerClick(Sender: TObject);
    procedure btnEggFlowerMouseLeave(Sender: TObject);
  private

    FOldTalentData: TTalentData; //记录天赋原始属性
    FEditTalentData: TTalentData; //记录天赋编辑属性
    FTmpTalentData: TTalentData; //记录天赋临时属性
    FEditStatus: Boolean;
    procedure ReturnUpdateTalentData();
    procedure UpdateTmpTalentData(ATmp: TTalentData);
    procedure InitEditData;

  public
        { Public declarations }
    procedure send_user_Designation(astr: string);
    procedure send_Del_Designation(astr: string);
    procedure onupdate();
    //procedure SetOldVersion();
    procedure SetNewVersion(); override;


    //procedure SetNewVersionOld(); override;
    procedure SetNewVersionTest(); override;

    procedure SetConfigFileName; override;
    procedure settransparent(transparent: Boolean); override;
  end;

var
  frmCharAttrib: TfrmCharAttrib;

implementation

uses FMain, FBottom, FAttrib, Fbl, fguild, filepgkclass, energy, CharCls, FConfirmDialog;

{$R *.DFM}

function SecondToTime(a: integer): string;

begin

  result := Format('%d天%d小时%d分%d秒', [a div 3600 div 24, (a div 3600) mod 24, (a mod 3600) div 60, a mod 60]);

end;

procedure TfrmCharAttrib.onupdate();
var
  CL: TCharClass;
  n, rDefaultValue: integer;
begin

  Cl := CharList.CharGet(CharCenterId);
  if Cl = nil then exit;
  lblLover.Caption := cl.ConsortName;
  Lbguildname.Caption := frmGuild.guildname;
  Lbguildjob.Caption := frmGuild.getGuildJob;
  lbname.Caption := cl.rName;
  LbAdaptive.Caption := Get10000To100(cAttribClass.AttribData.cAdaptive);
  LbRevival.Caption := Get10000To100(cAttribClass.AttribData.cRevival);

  lblAttackSpeed.Caption := inttostr(cAttribClass.LifeData.AttackSpeed);
  lblAvoid.Caption := inttostr(cAttribClass.LifeData.avoid);
  lblAccuracy.Caption := inttostr(cAttribClass.LifeData.accuracy);
  lblRecovery.Caption := inttostr(cAttribClass.LifeData.recovery);
  lbhitarmor.Caption := inttostr(cAttribClass.LifeData.HitArmor); //维持

  lblDamageBody.Caption := inttostr(cAttribClass.LifeData.damageBody);
  lblDamageHead.Caption := inttostr(cAttribClass.LifeData.damageHead);
  lblDamageArm.Caption := inttostr(cAttribClass.LifeData.damageArm);
  lblDamageLeg.Caption := inttostr(cAttribClass.LifeData.damageLeg);
  lblArmorBody.Caption := inttostr(cAttribClass.LifeData.armorBody);
  lblArmorHead.Caption := inttostr(cAttribClass.LifeData.armorHead);
  lblArmorArm.Caption := inttostr(cAttribClass.LifeData.armorArm);
  lblArmorLeg.Caption := inttostr(cAttribClass.LifeData.armorLeg);
  lblAge.Caption := Get10000To100(cAttribClass.AttribData.cAge);
  lbPrestige.Caption := IntToStr(cAttribClass.AttribData.prestige);
  lbEnergy.Caption := Get10000To100(cAttribClass.AttribData.cEnergy);
  //lbEnergy.Caption := Format('%.2f', [cAttribClass.AttribData.cEnergy / 100]);

  lbVirtue.Caption := Get10000To100(cAttribClass.AttribData.cvirtue);
  LbLucky.Caption := IntToStr(cAttribClass.AttribData.lucky);
  //非天赋编辑状态
  if not self.FEditStatus then
  begin
    //天赋点
    if (FEditTalentData.newTalent > 0) then
    begin
      if (cAttribClass.AttribData.newTalent = StrToIntDef(lbTalent.Caption, 0)) then
        FEditTalentData.newTalent := 0;
    end else
      lbTalent.Caption := IntToStr(cAttribClass.AttribData.newTalent);
    //天赋属性
    lbnewBone.Caption := IntToStr(cAttribClass.AttribData.newBone);
    lbnewLeg.Caption := IntToStr(cAttribClass.AttribData.newLeg);
    lbnewSavvy.Caption := IntToStr(cAttribClass.AttribData.newSavvy);
    lbnewAttackPower.Caption := IntToStr(cAttribClass.AttribData.newAttackPower);

    if cAttribClass.AttribData.newBone >= StrToIntDef(lbnewBone.Caption, 0) then
      lbnewBone.Caption := IntToStr(cAttribClass.AttribData.newBone);
    if cAttribClass.AttribData.newLeg >= StrToIntDef(lbnewLeg.Caption, 0) then
      lbnewLeg.Caption := IntToStr(cAttribClass.AttribData.newLeg);
    if cAttribClass.AttribData.newSavvy >= StrToIntDef(lbnewSavvy.Caption, 0) then
      lbnewSavvy.Caption := IntToStr(cAttribClass.AttribData.newSavvy);
    if cAttribClass.AttribData.newAttackPower >= StrToIntDef(lbnewAttackPower.Caption, 0) then
      lbnewAttackPower.Caption := IntToStr(cAttribClass.AttribData.newAttackPower);
  end;

  lbTalentLv.Caption := IntToStr(cAttribClass.AttribData.newTalentlv);
  lbTalentExp.Caption := IntToStr(cAttribClass.AttribData.newTalentExp) + '/' + IntToStr(cAttribClass.AttribData.newTalentNextLvExp);

  with cAttribClass.AttribData do
  begin
    rDefaultValue := ((cAge + 1200) div 2);

    lblInPower.Caption := Get10000To100(cInPower);
    lblOutPower.Caption := Get10000To100(cOutPower);
    lblMagic.Caption := Get10000To100(cMagic);
    lblLife.Caption := Get10000To100(cLife);
    lblDefaultValue.Caption := Get10000To100(rDefaultValue);
    n := cMagic + cInPower + cOutPower + cLife;
    n := (n - 5000) div 4000;
    n := n - 5;
    if n <= 0 then n := 1;
    if n > 6 then n := 6;
    lblShoutLevel.Caption := inttostr(n) + '境界';

    lblAttribTotal.Caption := Get10000To100(rDefaultValue + cLife + cMagic + cOutPower + cInPower);
  end;
 // lbOnlineTime.Caption:= SecondToTime(cAttribClass.AttribData.cAge);
end;

procedure TfrmCharAttrib.SetNewVersion;

begin
  if FTestPos then
    SetNewVersionTest;

  //else
  //  SetNewVersionOld;

end;

//procedure TfrmCharAttrib.SetOldVersion;
//begin
//  pgkBmp.getBmp('角色信息窗.bmp', A2form.FImageSurface);
//  A2form.boImagesurface := true;
//end;

procedure TfrmCharAttrib.FormCreate(Sender: TObject);
begin
  inherited;
  FTestPos := True;
    //

  Left := 20;
  Top := 20;

  FrmM.AddA2Form(Self, A2form);

  if WinVerType = wvtNew then
  begin
    SetNewVersion;
//  end
//  else if WinVerType = wvtOld then
//  begin
//    SetOldVersion;
  end;
end;

procedure TfrmCharAttrib.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
  FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmCharAttrib.A2Button14Click(Sender: TObject);
begin
  Visible := false;

  if FEditStatus then
  begin
    ReturnUpdateTalentData;
    FEditStatus := False;
  end;
end;

procedure TfrmCharAttrib.Timer1Timer(Sender: TObject);
begin
  if Visible = false then exit;
  onupdate;
end;

procedure TfrmCharAttrib.FormShow(Sender: TObject);
begin
  onupdate;
end;

procedure TfrmCharAttrib.A2Button_DesignationClick(Sender: TObject);
begin
  listDesignation.Visible := not listDesignation.Visible;
  A2Label_Designation_back.Visible := listDesignation.Visible;
end;

procedure TfrmCharAttrib.send_Del_Designation(astr: string);
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Designation);
  WordComData_ADDbyte(temp, Designation_Del);
  WordComData_ADDString(temp, astr);

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmCharAttrib.send_user_Designation(astr: string);
var
  temp: TWordComData;
begin

  temp.Size := 0;
  WordComData_ADDbyte(temp, CM_Designation);
  WordComData_ADDbyte(temp, Designation_user);
  WordComData_ADDString(temp, astr);

  Frmfbl.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmCharAttrib.listDesignationMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  frmConfirmDialog: TfrmConfirmDialog;
  astr: string;
begin
  if Button = mbRight then
  begin
    if (listDesignation.ItemIndex < 0) or (listDesignation.ItemIndex > listDesignation.Count - 1) then
    else
    begin
      astr := listDesignation.Items[listDesignation.ItemIndex];
         //创建 输入 窗口
      frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
      frmConfirmDialog.ShowFrom(cdDel_Designation, astr, '你确认删除称号：' + astr);
    end;
    listDesignation.Visible := false;
    A2Label_Designation_back.Visible := listDesignation.Visible;
  end;
  if Button = mbLeft then
  begin
    if (listDesignation.ItemIndex < 0) or (listDesignation.ItemIndex > listDesignation.Count - 1) then
    else
    begin
      astr := listDesignation.Items[listDesignation.ItemIndex];
      send_user_Designation(astr);
    end;
    listDesignation.Visible := false;
    A2Label_Designation_back.Visible := listDesignation.Visible;
  end;
end;

procedure TfrmCharAttrib.A2Button_showJObClick(Sender: TObject);
begin
//
 // frmSkill.Visible := true;
  //frmSkill.send_Get_Job_blueprint_Menu;
 // FrmM.SetA2Form(frmSkill, frmSkill.A2form);
end;

//procedure TfrmCharAttrib.SetNewVersionOld;
//var
//  temping, tempup, tempdown: TA2Image;
//begin
//  temping := TA2Image.Create(32, 32, 0, 0);
//  tempup := TA2Image.Create(32, 32, 0, 0);
//  tempdown := TA2Image.Create(32, 32, 0, 0);
//  try
//    //pgkBmp_n.getBmp('角色信息窗口.bmp', A2form.FImageSurface);
//   // A2form.boImagesurface := true;
//
//    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
//    A2Button14.A2Up := temping;
//    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
//    A2Button14.A2Down := temping;
//    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
//    A2Button14.A2Mouse := temping;
//    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
//    A2Button14.A2NotEnabled := temping;
//
//    pgkBmp.getBmp('角色信息_技术_弹起.bmp', temping);
//    A2Button_showJOb.A2Up := temping;
//    pgkBmp.getBmp('角色信息_技术_按下.bmp', temping);
//    A2Button_showJOb.A2Down := temping;
//    pgkBmp.getBmp('角色信息_技术_鼠标.bmp', temping);
//    A2Button_showJOb.A2Mouse := temping;
//    pgkBmp.getBmp('角色信息_技术_禁止.bmp', temping);
//    A2Button_showJOb.A2NotEnabled := temping;
//
//
//    pgkBmp.getBmp('角色信息_江湖称号_弹起.bmp', temping);
//    A2Button_Designation.A2Up := temping;
//    pgkBmp.getBmp('角色信息_江湖称号_按下.bmp', temping);
//    A2Button_Designation.A2Down := temping;
//    pgkBmp.getBmp('角色信息_江湖称号_鼠标.bmp', temping);
//    A2Button_Designation.A2Mouse := temping;
//    pgkBmp.getBmp('角色信息_江湖称号_禁止.bmp', temping);
//    A2Button_Designation.A2NotEnabled := temping;
//
//
//    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
//    listDesignation.SetScrollTopImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
//    listDesignation.SetScrollTrackImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
//    listDesignation.SetScrollBottomImage(tempUp, tempDown);
//    pgkBmp.getBmp('任务信息_下拉条底框A.bmp', temping);
//    listDesignation.SetScrollBackImage(temping);
//
//    pgkBmp.getBmp('角色信息_选择称号底框.bmp', temping);
//    A2Label_Designation_back.A2Image := temping;
//
//
//    A2Button14.Left := 211;
//    A2Button14.Top := 9;
//
//        //左边布局
//    lbname.Left := 46;
//    lbname.Top := 38;
//    lbname.Width := 74;
//    lbname.Height := 13;
//    lblLover.Left := 46;
//    lbllover.Top := 55;
//    lblLover.Width := 74;
//    lblLover.Height := 13;
//
//    lblAttackSpeed.Left := 65;
//    lblAttackSpeed.Top := 76;
//    lblAttackSpeed.Width := 55;
//    lblAttackSpeed.Height := 13;
//    lblAccuracy.Left := 65;
//    lblAccuracy.Top := 93;
//    lblAccuracy.Width := 55;
//    lblAccuracy.Height := 13;
//    LbAdaptive.Left := 65;
//    LbAdaptive.Top := 110;
//    LbAdaptive.Width := 55;
//    LbAdaptive.Height := 13;
//
//    lbhitarmor.Top := 128;
//    lbhitarmor.left := 65;
//
//    lblDamageBody.Left := 65;
//    lblDamageBody.Top := 148;
//    lblDamageBody.Width := 55;
//    lblDamageBody.Height := 13;
//    lblDamageHead.Left := 65;
//    lblDamageHead.Top := 166;
//    lblDamageHead.Width := 55;
//    lblDamageHead.Height := 13;
//    lblDamageArm.Left := 65;
//    lblDamageArm.Top := 181;
//    lblDamageArm.Width := 55;
//    lblDamageArm.Height := 13;
//    lblDamageLeg.Left := 65;
//    lblDamageLeg.Top := 198;
//    lblDamageLeg.Width := 55;
//    lblDamageLeg.Height := 13;
//
//    lblInPower.Left := 65;
//    lblInPower.Top := 219;
//    lblInPower.Width := 55;
//    lblInPower.Height := 13;
//    lblOutPower.Left := 65;
//    lblOutPower.Top := 236;
//    lblOutPower.Width := 55;
//    lblOutPower.Height := 13;
//    lblMagic.Left := 65;
//    lblMagic.Top := 253;
//    lblMagic.Width := 55;
//    lblMagic.Height := 13;
//    lblLife.Left := 65;
//    lblLife.Top := 270;
//    lblLife.Width := 55;
//    lblLife.Height := 13;
//    lblDefaultValue.Left := 65;
//    lblDefaultValue.Top := 287;
//    lblDefaultValue.Width := 55;
//    lblDefaultValue.Height := 13;
//
//        //右边布局
//    lblAge.Left := 162;
//    lblAge.Top := 38;
//    lblAge.Width := 74;
//    lblAge.Height := 13;
//    Lbguildname.Left := 162;
//    Lbguildname.Top := 55;
//    Lbguildname.Width := 74;
//    Lbguildname.Height := 13;
//
//    lblRecovery.Left := 181;
//    lblRecovery.Top := 76;
//    lblRecovery.Width := 55;
//    lblRecovery.Height := 13;
//    lblAvoid.Left := 181;
//    lblAvoid.Top := 93;
//    lblAvoid.Width := 55;
//    lblAvoid.Height := 13;
//    LbRevival.Left := 181;
//    LbRevival.Top := 110;
//    LbRevival.Width := 55;
//    LbRevival.Height := 13;
//
//    lblArmorBody.Left := 181;
//    lblArmorBody.Top := 147;
//    lblArmorBody.Width := 55;
//    lblArmorBody.Height := 13;
//    lblArmorHead.Left := 181;
//    lblArmorHead.Top := 164;
//    lblArmorHead.Width := 55;
//    lblArmorHead.Height := 13;
//    lblArmorArm.Left := 181;
//    lblArmorArm.Top := 181;
//    lblArmorArm.Width := 55;
//    lblArmorArm.Height := 13;
//    lblArmorLeg.Left := 181;
//    lblArmorLeg.Top := 198;
//    lblArmorLeg.Width := 55;
//    lblArmorLeg.Height := 13;
//
//    lblAttribTotal.Left := 162;
//    lblAttribTotal.Top := 253;
//    lblAttribTotal.Width := 74;
//    lblAttribTotal.Height := 13;
//    lblShoutLevel.Left := 162;
//    lblShoutLevel.Top := 270;
//    lblShoutLevel.Width := 74;
//    lblShoutLevel.Height := 13;
//
//    lbPrestige.Left := 162;
//    lbPrestige.Top := 287;
//    lbPrestige.Width := 74;
//    lbPrestige.Height := 13;
//    lbPrestige.Visible := true;
//
//    lbEnergy.Left := 162;
//    lbEnergy.Top := 236;
//    lbEnergy.Width := 74;
//    lbEnergy.Height := 13;
//    lbEnergy.Visible := true;
//
//    lbVirtue.Left := 181;
//    lbVirtue.Top := 219;
//    lbVirtue.Width := 55;
//    lbVirtue.Height := 13;
//    lbVirtue.Visible := true;
//
//
//  finally
//    temping.Free;
//    tempup.Free;
//    tempdown.Free;
//  end;
//end;

procedure TfrmCharAttrib.SetNewVersionTest;
begin
  inherited;
  SetControlPos(Self);
  A2Form.FImageSurface.Name := 'FImageSurface';
  SetA2ImgPos(A2Form.FImageSurface);
  A2Form.boImagesurface := true;


  SetControlPos(A2Button14);
  SetControlPos(A2Button_showJOb);

  SetControlPos(A2Button_Designation);
  SetControlPos(listDesignation);

//    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
//    listDesignation.SetScrollTopImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
//    listDesignation.SetScrollTrackImage(tempUp, tempDown);
//    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
//    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
//    listDesignation.SetScrollBottomImage(tempUp, tempDown);
//    pgkBmp.getBmp('任务信息_下拉条底框A.bmp', temping);
//    listDesignation.SetScrollBackImage(temping);


  SetControlPos(A2Label_Designation_back);

  SetControlPos(lbname);

  SetControlPos(lblLover);

  SetControlPos(lblAttackSpeed);
  SetControlPos(lblAccuracy);
  SetControlPos(LbAdaptive);

  SetControlPos(lbhitarmor);

  SetControlPos(lblDamageBody);
  SetControlPos(lblDamageHead);
  SetControlPos(lblDamageArm);
  SetControlPos(lblDamageLeg);
  SetControlPos(lblInPower);

  SetControlPos(lblOutPower);
  SetControlPos(lblMagic);
  SetControlPos(lblLife);
  SetControlPos(lblDefaultValue);
  SetControlPos(lblDefaultValue);
  SetControlPos(lblAge);

  SetControlPos(Lbguildname);
  SetControlPos(lblRecovery);

  SetControlPos(lblAvoid);
  SetControlPos(LbRevival);
  SetControlPos(lblArmorBody);
  SetControlPos(lblArmorHead);

  SetControlPos(lblArmorArm);
  SetControlPos(lblArmorLeg);

  SetControlPos(lblAttribTotal);

  SetControlPos(lblShoutLevel);
  SetControlPos(lbPrestige);

  SetControlPos(lbEnergy);

  SetControlPos(lbVirtue);
  SetControlPos(lbOnlineTime);
  SetControlPos(Lbguildjob);
  SetControlPos(LbLucky);
  SetControlPos(lbTalent);
  SetControlPos(lbTalentLv);
  SetControlPos(lbTalentExp);
  SetControlPos(lbnewBone);
  SetControlPos(lbnewLeg);
  SetControlPos(lbnewSavvy);
  SetControlPos(lbnewAttackPower);
  SetControlPos(btnnewBoneadd);
  SetControlPos(btnnewBonesub);
  SetControlPos(btnnewLegadd);
  SetControlPos(btnnewLegsub);
  SetControlPos(btnnewSavvyadd);
  SetControlPos(btnnewSavvysub);
  SetControlPos(btnnewAttackPoweradd);
  SetControlPos(btnnewAttackPowersub);
  SetControlPos(btnSaveTalent);
  SetControlPos(btnEggFlower);
  SetControlPos(lblcharm);
  lblcharm.Caption := '0';
  SetControlPos(lblFlower);
  lblFlower.Caption := '0';
  SetControlPos(lblEgg);
  lblEgg.Caption := '0';
end;



procedure TfrmCharAttrib.ReturnUpdateTalentData;
begin
  FEditTalentData.newBone := 0;
  FEditTalentData.newLeg := 0;
  FEditTalentData.newSavvy := 0;
  FEditTalentData.newAttackPower := 0;
  FEditTalentData.newTalent := 0;
  lbTalent.Caption := IntToStr(FOldTalentData.newTalent);
  lbnewBone.Caption := IntToStr(FOldTalentData.newBone);
  lbnewLeg.Caption := IntToStr(FOldTalentData.newLeg);
  lbnewSavvy.Caption := IntToStr(FOldTalentData.newSavvy);
  lbnewAttackPower.Caption := IntToStr(FOldTalentData.newAttackPower);
end;

procedure TfrmCharAttrib.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FEditStatus then
  begin
    ReturnUpdateTalentData;
    FEditStatus := False;
  end;
end;

//保存天赋状态

procedure TfrmCharAttrib.btnSaveTalentClick(Sender: TObject);
var
  pTalentUpdateData: TCTalentUpdate;
begin
  if self.FEditStatus then
  begin
    //发包服务端
    pTalentUpdateData.rmsg := CM_TalentUpdate;
    pTalentUpdateData.newAttackPower := FEditTalentData.newAttackPower;
    pTalentUpdateData.newBone := FEditTalentData.newBone;
    pTalentUpdateData.newLeg := FEditTalentData.newLeg;
    pTalentUpdateData.newSavvy := FEditTalentData.newSavvy;
    Frmfbl.SocketAddData(Sizeof(pTalentUpdateData), @pTalentUpdateData);
    //改变编辑状态
    self.FEditStatus := False;
    //发包后清空旧属性  和编辑属性

    FillChar(FTmpTalentData, SizeOf(FTmpTalentData), 0);
    FillChar(FEditTalentData, SizeOf(FEditTalentData), 0);

    FillChar(FOldTalentData, SizeOf(FOldTalentData), 0);
//    //改变旧属性为编辑后属性
//
//    self.FOldTalentData.newAttackPower := FEditTalentData.newAttackPower;
//    self.FOldTalentData.newBone := FEditTalentData.newBone;
//    self.FOldTalentData.newLeg := FEditTalentData.newLeg;
//    self.FOldTalentData.newSavvy := FEditTalentData.newSavvy;
//    self.FOldTalentData.newTalent := FEditTalentData.newTalent;
  end;
//    FEditTalentData.newBone:=10;
//    FEditTalentData.newAttackPower:=10;
//   FEditTalentData.newSavvy:=10;
//   FEditTalentData.newAttackPower:=10;

end;

procedure TfrmCharAttrib.UpdateTmpTalentData(ATmp: TTalentData);
begin
  lbTalent.Caption := IntToStr(ATmp.newTalent);
  lbnewBone.Caption := IntToStr(ATmp.newBone);
  lbnewLeg.Caption := IntToStr(ATmp.newLeg);
  lbnewSavvy.Caption := IntToStr(ATmp.newSavvy);
  lbnewAttackPower.Caption := IntToStr(ATmp.newAttackPower);
end;

procedure TfrmCharAttrib.InitEditData;
begin
  if not FEditStatus then
  begin
    FEditStatus := True;

    if cAttribClass.AttribData.newBone > FOldTalentData.newBone then
      FOldTalentData.newBone := cAttribClass.AttribData.newBone;

    if cAttribClass.AttribData.newLeg > FOldTalentData.newLeg then
      FOldTalentData.newLeg := cAttribClass.AttribData.newLeg;
    if cAttribClass.AttribData.newSavvy > FOldTalentData.newSavvy then
      FOldTalentData.newSavvy := cAttribClass.AttribData.newSavvy;
    if cAttribClass.AttribData.newAttackPower > FOldTalentData.newAttackPower then
      FOldTalentData.newAttackPower := cAttribClass.AttribData.newAttackPower;
    if cAttribClass.AttribData.newTalent > FOldTalentData.newTalent then
      FOldTalentData.newTalent := cAttribClass.AttribData.newTalent;

    FTmpTalentData.newBone := cAttribClass.AttribData.newBone;
    FTmpTalentData.newLeg := cAttribClass.AttribData.newLeg;
    FTmpTalentData.newSavvy := cAttribClass.AttribData.newSavvy;
    FTmpTalentData.newAttackPower := cAttribClass.AttribData.newAttackPower;
    FTmpTalentData.newTalent := cAttribClass.AttribData.newTalent;

    if cAttribClass.AttribData.newBone > FEditTalentData.newBone then
      FEditTalentData.newBone := cAttribClass.AttribData.newBone;

    if cAttribClass.AttribData.newLeg > FEditTalentData.newLeg then
      FEditTalentData.newLeg := cAttribClass.AttribData.newLeg;
    if cAttribClass.AttribData.newSavvy > FEditTalentData.newSavvy then
      FEditTalentData.newSavvy := cAttribClass.AttribData.newSavvy;
    if cAttribClass.AttribData.newAttackPower > FEditTalentData.newAttackPower then
      FEditTalentData.newAttackPower := cAttribClass.AttribData.newAttackPower;
    if cAttribClass.AttribData.newTalent > FEditTalentData.newTalent then
      FEditTalentData.newTalent := cAttribClass.AttribData.newTalent;
  end;
end;

procedure TfrmCharAttrib.btnnewBoneaddClick(Sender: TObject);
begin

  if not FEditStatus then
  begin

    InitEditData;
    if FEditTalentData.newTalent = 0 then
    begin
      FEditStatus := False;
      Exit;
    end;
  end;

  if FEditTalentData.newTalent = 0 then
    Exit;

  FEditTalentData.newBone := FEditTalentData.newBone + 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent - 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.btnnewLegaddClick(Sender: TObject);
begin
  if not FEditStatus then
  begin

    InitEditData;
    if FEditTalentData.newTalent = 0 then
    begin
      FEditStatus := False;
      Exit;
    end;
  end;

  if FEditTalentData.newTalent = 0 then
    Exit;

  FEditTalentData.newLeg := FEditTalentData.newLeg + 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent - 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.btnnewSavvyaddClick(Sender: TObject);
begin
  if not FEditStatus then
  begin

    InitEditData;
    if FEditTalentData.newTalent = 0 then
    begin
      FEditStatus := False;
      Exit;
    end;
  end;

  if FEditTalentData.newTalent = 0 then
    Exit;

  FEditTalentData.newSavvy := FEditTalentData.newSavvy + 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent - 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.btnnewAttackPoweraddClick(Sender: TObject);
begin
  if not FEditStatus then
  begin

    InitEditData;
    if FEditTalentData.newTalent = 0 then
    begin
      FEditStatus := False;
      Exit;
    end;
  end;

  if FEditTalentData.newTalent = 0 then
    Exit;

  FEditTalentData.newAttackPower := FEditTalentData.newAttackPower + 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent - 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.btnnewBonesubClick(Sender: TObject);
begin
  if not FEditStatus then
  begin

    Exit;
  end;

  if FEditTalentData.newTalent = FOldTalentData.newTalent then
    Exit;
  if FEditTalentData.newBone = FOldTalentData.newBone then
    Exit;
  FEditTalentData.newBone := FEditTalentData.newBone - 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent + 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.btnnewLegsubClick(Sender: TObject);
begin
  if not FEditStatus then
  begin

    Exit;
  end;

  if FEditTalentData.newTalent = FOldTalentData.newTalent then
    Exit;
  if FEditTalentData.newLeg = FOldTalentData.newLeg then
    Exit;
  FEditTalentData.newLeg := FEditTalentData.newLeg - 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent + 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.btnnewSavvysubClick(Sender: TObject);
begin
  if not FEditStatus then
  begin

    Exit;
  end;

  if FEditTalentData.newTalent = FOldTalentData.newTalent then
    Exit;
  if FEditTalentData.newSavvy = FOldTalentData.newSavvy then
    Exit;
  FEditTalentData.newSavvy := FEditTalentData.newSavvy - 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent + 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.btnnewAttackPowersubClick(Sender: TObject);
begin
  if not FEditStatus then
  begin

    Exit;
  end;

  if FEditTalentData.newTalent = FOldTalentData.newTalent then
    Exit;
  if FEditTalentData.newAttackPower = FOldTalentData.newAttackPower then
    Exit;
  FEditTalentData.newAttackPower := FEditTalentData.newAttackPower - 1;
  FEditTalentData.newTalent := FEditTalentData.newTalent + 1;
  UpdateTmpTalentData(FEditTalentData);
end;

procedure TfrmCharAttrib.SetConfigFileName;
begin
  FConfigFileName := 'CharAttrib.xml';

end;

procedure TfrmCharAttrib.settransparent(transparent: Boolean);
begin
  Self.A2Form.TransParent := transparent;

end;

procedure TfrmCharAttrib.lbnewBoneMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  GameHint.setText(integer(Sender), '【增加1点根骨可提升6点防御】');
end;

procedure TfrmCharAttrib.lbnewBoneMouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

procedure TfrmCharAttrib.lbnewLegMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  GameHint.setText(integer(Sender), '【增加2点身法可提升1点闪躲】');
end;

procedure TfrmCharAttrib.lbnewLegMouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

procedure TfrmCharAttrib.lbnewSavvyMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  GameHint.setText(integer(Sender), '【增加2点悟性可提升1点命中】');
end;

procedure TfrmCharAttrib.lbnewSavvyMouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

procedure TfrmCharAttrib.lbnewAttackPowerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  GameHint.setText(integer(Sender), '【增加1点武学可提升6点攻击】');
end;

procedure TfrmCharAttrib.lbnewAttackPowerMouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

procedure TfrmCharAttrib.btnEggFlowerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  GameHint.setText(integer(Sender), '【系统暂未开放】');
end;

procedure TfrmCharAttrib.btnEggFlowerClick(Sender: TObject);
begin
  inherited;
  GameHint.setText(integer(Sender), '【系统暂未开放】');
end;

procedure TfrmCharAttrib.btnEggFlowerMouseLeave(Sender: TObject);
begin
  inherited;
  GameHint.Close;
end;

end.

