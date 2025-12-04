unit uMagicClass;

interface

uses
  Windows, SysUtils, Classes, Usersdb, Deftype, uKeyClass;

type
  TSkillAddDamageData = record
    rdamagebody: integer;
    rdamagehead: integer;
    rdamagearm: integer;
    rdamageleg: integer;
  end;

  TSkillAddArmorData = record
    rarmorbody: integer;
    rarmorhead: integer;
    rarmorarm: integer;
    rarmorleg: integer;
  end;

  TMagicBasicClass = class
  private
    SkillAddDamageArr: array[0..10000] of TSkillAddDamageData;
    SkillAddArmorArr: array[0..10000] of TSkillAddArmorData;                // 추가방어력
  protected
    procedure Clear;
    procedure loadDamage(TempDb: TUserStringDb);
    procedure loadArmor(TempDb: TUserStringDb);
  public
    constructor Create;
    destructor Destroy; override;
    function GetSkillDamageBody(askill: integer): integer;
    function GetSkillDamageHead(askill: integer): integer;
    function GetSkillDamageArm(askill: integer): integer;
    function GetSkillDamageLeg(askill: integer): integer;
    function GetSkillArmorBody(askill: integer): integer;
    function GetSkillArmorHead(askill: integer): integer;
    function GetSkillArmorArm(askill: integer): integer;
    function GetSkillArmorLeg(askill: integer): integer;
    procedure Calculate_cLifeData(pMagicData: PTMagicData);
  end;

var
  INI_SKILL_DIV_DAMAGE: integer = 5000;
  INI_SKILL_DIV_ARMOR: integer = 5000;
  INI_SKILL_DIV_ATTACKSPEED: integer = 25000;
  INI_SKILL_DIV_EVENT: integer = 5000;
  INI_2SKILL_DIV_DAMAGE: integer = 5000;
  INI_2SKILL_DIV_ARMOR: integer = 5000;
  INI_2SKILL_DIV_ATTACKSPEED: integer = 25000;
  INI_2SKILL_DIV_EVENT: integer = 5000;
  INI_2SKILL_ADD_BASESKILL: integer = 0;
  INI_2SKILL_DIV_RECOVERY: integer = 25000;
  INI_2SKILL_DIV_AVOID: integer = 25000;
  INI_2SKILL_DIV_ACCURACY: integer = 25000;
  INI_2SKILL_DIV_KEEPRECOVERY: integer = 25000;

implementation

///////////////////////////////////
//         TMagicClass
///////////////////////////////////

constructor TMagicBasicClass.Create;
begin

end;

destructor TMagicBasicClass.Destroy;
begin
  Clear;
  inherited destroy;
end;

procedure TMagicBasicClass.Clear;
begin
  FillChar(SkillAddDamageArr, sizeof(SkillAddDamageArr), 0);
  FillChar(SkillAddArmorArr, sizeof(SkillAddArmorArr), 0);

end;

procedure TMagicBasicClass.loadDamage(TempDb: TUserStringDb);
var
  idx, sn, en, i: integer;
  iname: string;
begin
  FillChar(SkillAddDamageArr, sizeof(SkillAddDamageArr), 0);

  for idx := 0 to TempDb.Count - 1 do
  begin
    iname := TempDb.GetIndexName(idx);
    sn := TempDb.GetFieldValueInteger(iname, 'StartSkill');
    en := TempDb.GetFieldValueInteger(iname, 'EndSkill');
    if sn <= 0 then
      sn := 0;
    if en >= 10000 then
      en := 10000;
    for i := sn to en do
    begin
      SkillAddDamageArr[i].rdamagebody := TempDb.GetFieldValueInteger(iname, 'DamageBody');
      SkillAddDamageArr[i].rdamagehead := TempDb.GetFieldValueInteger(iname, 'DamageHead');
      SkillAddDamageArr[i].rdamagearm := TempDb.GetFieldValueInteger(iname, 'DamageArm');
      SkillAddDamageArr[i].rdamageleg := TempDb.GetFieldValueInteger(iname, 'DamageLeg');
    end;
  end;

end;

procedure TMagicBasicClass.loadArmor(TempDb: TUserStringDb);
var
  idx, sn, en, i: integer;
  iname: string;
begin
  FillChar(SkillAddArmorArr, sizeof(SkillAddArmorArr), 0);
  for idx := 0 to TempDb.Count - 1 do
  begin
    iname := TempDb.GetIndexName(idx);
    sn := TempDb.GetFieldValueInteger(iname, 'StartSkill');
    en := TempDb.GetFieldValueInteger(iname, 'EndSkill');
    if sn <= 0 then
      sn := 0;
    if en >= 10000 then
      en := 10000;
    for i := sn to en do
    begin
      SkillAddArmorArr[i].rarmorbody := TempDb.GetFieldValueInteger(iname, 'ArmorBody');
      SkillAddArmorArr[i].rarmorhead := TempDb.GetFieldValueInteger(iname, 'ArmorHead');
      SkillAddArmorArr[i].rarmorarm := TempDb.GetFieldValueInteger(iname, 'ArmorArm');
      SkillAddArmorArr[i].rarmorleg := TempDb.GetFieldValueInteger(iname, 'ArmorLeg');
    end;
  end;

end;

procedure TMagicBasicClass.Calculate_cLifeData(pMagicData: PTMagicData);
begin
  //frmMain.WriteLogInfo('0');

  if pMagicData = nil then
    exit;  
 // frmMain.WriteLogInfo(format('1 pMagicData.rName = (%s)  pMagicData.rMagicType = (%d)  pMagicData.rcSkillLevel = (%d)', [pMagicData.rName, pMagicData.rMagicType, pMagicData.rcSkillLevel]));
  if pMagicData^.rName = '' then
    exit;
    
//  frmMain.WriteLogInfo(format('2 pMagicData.rName = (%s)  pMagicData.rMagicType = (%d)  pMagicData.rcSkillLevel = (%d)', [pMagicData.rName, pMagicData.rMagicType, pMagicData.rcSkillLevel]));
  if pMagicData.rMagicType < 99 then
  begin
    with pMagicData^do
    begin
      rcLifeData.DamageBody := rLifeData.damageBody + rLifeData.damageBody * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
            //FrmMain.WriteLogInfo('꿎桿:' + pMagicData^.rName + ',' + IntToStr(rcSkillLevel));
      rcLifeData.DamageHead := rLifeData.DamageHead + rLifeData.damageHead * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      rcLifeData.DamageArm := rLifeData.DamageArm + rLifeData.damageArm * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      rcLifeData.DamageLeg := rLifeData.DamageLeg + rLifeData.damageLeg * rcSkillLevel div INI_SKILL_DIV_DAMAGE;
      rcLifeData.AttackSpeed := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div INI_SKILL_DIV_ATTACKSPEED;
      rcLifeData.avoid := rLifeData.avoid;                                //    + rLifeData.avoid;
      rcLifeData.recovery := rLifeData.recovery;                          //    + rLifeData.recovery;
      rcLifeData.armorBody := rLifeData.armorBody + rLifeData.armorBody * rcSkillLevel div INI_SKILL_DIV_ARMOR;
      rcLifeData.armorHead := rLifeData.armorHead + rLifeData.armorHead * rcSkillLevel div INI_SKILL_DIV_ARMOR;
      rcLifeData.armorArm := rLifeData.armorArm + rLifeData.armorArm * rcSkillLevel div INI_SKILL_DIV_ARMOR;
      rcLifeData.armorLeg := rLifeData.armorLeg + rLifeData.armorLeg * rcSkillLevel div INI_SKILL_DIV_ARMOR;
{        end;

        with pMagicData^ do
        begin }
      rcLifeData.Damagebody := rcLifeData.Damagebody + rcLifeData.DamageBody * GetSkillDamageBody(rcSkillLevel) div 100;
      if rMagicType = MAGICTYPE_PROTECTING then
        rcLifeData.Armorbody := rcLifeData.Armorbody + rcLifeData.ArmorBody * GetSkillArmorBody(rcSkillLevel) div 100;
    end;
  end
  else
  begin
    with pMagicData^do
    begin
//            3000
           // rcLifeData.DamageBody := rLifeData.damageBody + rLifeData.damageBody * rcSkillLevel div INI_2SKILL_DIV_DAMAGE;
      rcLifeData.DamageBody := rLifeData.damageBody + rLifeData.damageBody * rcSkillLevel div 3000;

      rcLifeData.DamageHead := rLifeData.DamageHead + rLifeData.damageHead * rcSkillLevel div INI_2SKILL_DIV_DAMAGE;
      rcLifeData.DamageArm := rLifeData.DamageArm + rLifeData.damageArm * rcSkillLevel div INI_2SKILL_DIV_DAMAGE;
      rcLifeData.DamageLeg := rLifeData.DamageLeg + rLifeData.damageLeg * rcSkillLevel div INI_2SKILL_DIV_DAMAGE;
            //15000
           // rcLifeData.AttackSpeed := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div INI_2SKILL_DIV_ATTACKSPEED;
      rcLifeData.AttackSpeed := rLifeData.AttackSpeed - rLifeData.AttackSpeed * rcSkillLevel div 15000;

      rcLifeData.avoid := rLifeData.avoid;                                //    + rLifeData.avoid;
      rcLifeData.recovery := rLifeData.recovery;                          //    + rLifeData.recovery;

      //郭넣
      rcLifeData.HitArmor := trunc(rLifeData.HitArmor - (10000 - rcSkillLevel) * rLifeData.HitArmor DIV 10000);
      //츱櫓
      rcLifeData.accuracy := trunc(rLifeData.accuracy - (10000 - rcSkillLevel) * rLifeData.accuracy DIV 10000);

      rcLifeData.armorBody := rLifeData.armorBody + rLifeData.armorBody * rcSkillLevel div INI_2SKILL_DIV_ARMOR;
      rcLifeData.armorHead := rLifeData.armorHead + rLifeData.armorHead * rcSkillLevel div INI_2SKILL_DIV_ARMOR;
      rcLifeData.armorArm := rLifeData.armorArm + rLifeData.armorArm * rcSkillLevel div INI_2SKILL_DIV_ARMOR;
      rcLifeData.armorLeg := rLifeData.armorLeg + rLifeData.armorLeg * rcSkillLevel div INI_2SKILL_DIV_ARMOR;

      if rcLifeData.Damagebody > 0 then
        rcLifeData.Damagebody := rcLifeData.Damagebody + 300;

      if rcLifeData.DamageHead > 0 then
        rcLifeData.DamageHead := rcLifeData.DamageHead + 200;
      if rcLifeData.DamageArm > 0 then
        rcLifeData.DamageArm := rcLifeData.DamageArm + 200;
      if rcLifeData.DamageLeg > 0 then
        rcLifeData.DamageLeg := rcLifeData.DamageLeg + 200;



       { end;

        with pMagicData^ do
        begin}
      rcLifeData.Damagebody := rcLifeData.Damagebody + rcLifeData.DamageBody * GetSkillDamageBody(rcSkillLevel) div 100;
      if (rMagicType) = MAGICTYPE_2PROTECTING then
      begin
        rcLifeData.Armorbody := rcLifeData.Armorbody + rcLifeData.ArmorBody * GetSkillArmorBody(rcSkillLevel) div 100;
      end
      else
      begin
        if rcLifeData.armorBody > 0 then
          rcLifeData.armorBody := rcLifeData.armorBody + 100;

      end;

    end;
  end;
end;

function TMagicBasicClass.GetSkillDamageBody(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddDamageArr[askill].rdamagebody;
end;

function TMagicBasicClass.GetSkillDamageHead(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddDamageArr[askill].rdamagehead;
end;

function TMagicBasicClass.GetSkillDamageArm(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddDamageArr[askill].rdamagearm;
end;

function TMagicBasicClass.GetSkillDamageLeg(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddDamageArr[askill].rdamageleg;
end;

// 2000.10.05 몸 추가방어력 구하는 Method

function TMagicBasicClass.GetSkillArmorBody(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddArmorArr[askill].rarmorbody;
end;

// 2000.10.05 머리 추가방어력 구하는 Method

function TMagicBasicClass.GetSkillArmorHead(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddArmorArr[askill].rarmorhead;
end;

// 2000.10.05 팔 추가방어력 구하는 Method

function TMagicBasicClass.GetSkillArmorArm(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddArmorArr[askill].rarmorarm;
end;

// 2000.10.05 다리 추가방어력 구하는 Method

function TMagicBasicClass.GetSkillArmorLeg(askill: integer): integer;
begin
  Result := 0;
  if (askill <= 0) or (askill >= 10000) then
    exit;
  Result := SkillAddArmorArr[askill].rarmorleg;
end;

end.

