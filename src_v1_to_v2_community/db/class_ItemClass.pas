unit class_ItemClass;

interface
uses
  Windows,Classes,Dialogs,SysUtils,uKeyClass,deftype,AUtil32;
 type
   
    TStringFieldData = record
        rfieldname: string[64];
        rindex: integer;
    end;
    PTStringFieldData = ^TStringFieldData;
          TOpenNameData = record
        rdata: string;
        rnone: byte;
    end;
    PTOpenNameData = ^TOpenNameData;

    TNameData = record
        rName: array[0..36 - 1] of byte;
        rindex: integer;
    end;
    PTNameData = ^TNameData;
       TNameList = class
    private
        DataList: TList;
        procedure Clear;
        function FindIndex(aName: string): Integer;
    public
        constructor Create;
        destructor Destroy; override;
        procedure Add(aName: string; rNo: integer);
        procedure AddNoSort(aName: string; rNo: integer);
        procedure Delete(aName: string);
        procedure Sort;
        function Find(aName: string): PTNameData;
    end;
      TUserStringDb = class
    private
        //   Open_Data : TStringList;

        Open_Data: TList;
        Open_Name: string;

        DbName: string;
        pWriteBuffer: PChar;
        WriteBufferSize: integer;

        DbStringList: TStringList;
        FieldList: TStringList;

        LowerFieldList: TList;
        AnsIndexClass: TStringKeyClass;

        function GetNameCount: Integer;
        function GetFieldCount: Integer;
        function OpenRecord(cName: string): Boolean;
        procedure CloseRecord;
    public
        NameList: TNameList;
        constructor Create;
        destructor Destroy; override;
        procedure Clear;
        function GetNameIndex(cName: string): integer;
        function GetFieldIndex(cField: string): integer;

        procedure LoadFromFile(aFileName: string);
        procedure LoadFromStringList(atemp: TStringList);
        procedure SaveToFile(aFileName: string);

        function GetFieldValueInteger(cName, cField: string): Integer;
        function SetFieldValueInteger(cName, cField: string; Value: Integer): Boolean;

        function GetFieldValueString(cName, cField: string): string;
        function SetFieldValueString(cName, cField, Value: string): Boolean;

        function GetFieldValueBoolean(cName, cField: string): Boolean;
        function SetFieldValueBoolean(cName, cField: string; Value: Boolean): Boolean;

        function GetDbString(cName: string): string;
        function AddDbString(aDbStr: string): Boolean;
        function SetDbString(cName, aDbStr: string): Boolean;

        function AddName(cName: string): Boolean;
        function DeleteName(cName: string): Boolean;
        function GetDbFields: string;
        function SetDbFields(aFields: string): Boolean;
        function AddField(aField: string): Boolean;
        function GetIndexString(Index: Integer): string;
        function GetIndexName(Index: Integer): string;
        property Count: integer read GetNameCount;
        property FieldCount: integer read GetFieldCount;
    end;
  TItemClass = class
  private
    ItemDb: TUserStringDb;
    DataList: TList;
    AnsIndexClass: TStringKeyClass;
    ItemTextClass: TStringKeyListClass; //pTitemTextdata  物品描述





    procedure Clear;
    function LoadItemData(aItemName: string; var ItemData: TItemData): Boolean;
 
    procedure JOb_add(var aitem: titemdata);

  public

        //4个职业 生产材料详细表
    Job_Material1: tstringList;
    Job_Material2: tstringList;
    Job_Material3: tstringList;
    Job_Material4: tstringList;
    constructor Create;
    destructor Destroy; override;
 
    procedure ReLoadFromFile;
    function GetItemData(aItemName: string; var ItemData: TItemData): Boolean;
 
    function GetWearItemData(astr: string; var ItemData: TItemData): Boolean;
 
    function GetWearItemString(var ItemData: TItemData): string;
    function getdesc(aname: string): string;

  end;
var
 G_ItemClass: TItemClass;  
implementation

constructor TNameList.Create;
begin
    DataList := TList.Create;
    Clear;
end;

destructor TNameList.Destroy;
begin
    Clear;
    DataList.Free;
    inherited destroy;
end;

procedure TNameList.Clear;
var
    i: integer;
begin
    for i := 0 to DataList.Count - 1 do
        dispose(DataList[i]);
    DataList.Clear;
end;

function NameListSortFunction(Item1, Item2: Pointer): integer;
begin
    Result := StrComp(@PTNameData(Item1)^.rName, @PTNameData(Item2)^.rName);
end;

procedure TNameList.Sort;
begin
    DataList.Sort(NameListSortFunction);
end;

procedure TNameList.Delete(aName: string);
var
    i, n, index: integer;
    pi: PTNameData;
begin
    n := FindIndex(aName);
    if n = -1 then
        exit;
    pi := DataList[n];
    index := pi^.rindex;
    DataList.Delete(n);
    dispose(pi);

    for i := 0 to DataList.Count - 1 do
    begin                                                                       // 傈何促 八祸窍绰巴篮 肋给.
        pi := DataList[i];
        if pi^.rIndex >= index then
            pi^.rIndex := pi^.rindex - 1;
    end;
end;

function TNameList.Find(aName: string): PTNameData;
var
    n: integer;
begin
    Result := nil;
    n := FindIndex(aName);
    if n = -1 then
        exit;
    Result := DataList[n];
end;

function TNameList.FindIndex(aName: string): integer;
var
    i, lpos, hpos, cpos: integer;
    pn: PTNameData;
    NameBuffer: array[0..64 - 1] of byte;
    boRet: Boolean;
begin
    Result := -1;
    if DataList.Count = 0 then
        exit;

    StrPCopy(@NameBuffer, aName);

    hpos := DataList.Count - 1;
    lpos := 0;
    cpos := (lpos + hpos) div 2;

    for i := 0 to 20 - 1 do
    begin
        pn := DataList[cpos];
        boRet := WhereIsChar(@Namebuffer, @pn^.rname, lpos, cpos, hpos, 6);
        if boRet = FALSE then
            break;
    end;

    for i := lpos to hpos do
    begin
        pn := DataList[i];
        if StrPas(@pn^.rName) = aName then
        begin
            Result := i;
            exit;
        end;
    end;
end;

procedure TNameList.AddNoSort(aName: string; rNo: integer);
var
    pi: PTNameData;
begin
    new(pi);
    pi^.rindex := rNo;
    StrPCopy(@pi^.rName, aName);
    DataList.Add(pi);
end;

procedure TNameList.Add(aName: string; rNo: integer);
var
    pnew: PTNameData;
    i, lpos, hpos, cpos, np, nn: integer;
    pn, pp: PTNameData;
    boRet: Boolean;
begin
    new(pnew);
    pnew^.rindex := rNo;
    StrPCopy(@pnew^.rName, aName);

    if DataList.Count < 100 then
    begin
        DataList.Add(pnew);
        Sort;
        exit;
    end;

    pn := DataList[0];
    if StrComp(@pnew^.rName, @pn^.rName) < 0 then
    begin
        DataList.Insert(0, pnew);
        exit;
    end;

    pp := DataList[DataList.count - 1];
    if StrComp(@pnew^.rName, @pp^.rName) > 0 then
    begin
        DataList.Add(pnew);
        exit;
    end;

    hpos := DataList.Count - 1;
    lpos := 0;
    cpos := (lpos + hpos) div 2;

    for i := 0 to 20 - 1 do
    begin
        pn := DataList[cpos];
        boRet := WhereIsChar(@pnew^.rName, @pn^.rname, lpos, cpos, hpos, 10);
        if boRet = FALSE then
            break;
    end;

    for i := lpos to hpos - 1 do
    begin
        pp := DataList[i];
        pn := DataList[i + 1];

        np := StrComp(@pnew^.rName, @pp^.rName);
        nn := StrComp(@pnew^.rName, @pn^.rName);

        if (np > 0) and (nn < 0) then
        begin
            DataList.Insert(i + 1, pnew);
            exit;
        end;
    end;
end;

 { TItemClass }



constructor TItemClass.Create;
begin

  Job_Material1 := tstringList.Create;
  Job_Material2 := tstringList.Create;
  Job_Material3 := tstringList.Create;
  Job_Material4 := tstringList.Create;
  ItemDb := TUserStringDb.Create;
  DataList := TList.Create;
  AnsIndexClass := TStringKeyClass.Create; //('ItemClass', 20, TRUE);
  ItemTextClass := TStringKeyListClass.Create;
  ReLoadFromFile;
end;



destructor TItemClass.Destroy;
begin

  Clear;

  Job_Material1.Free;
  Job_Material2.Free;
  Job_Material3.Free;
  Job_Material4.Free;
  AnsIndexClass.Free;
  ItemTextClass.Free;
  DataList.Free;
  ItemDb.Free;
  inherited Destroy;
end;

procedure TItemClass.Clear;
var
  i: integer;
  p: pTitemTextdata;
begin
  for i := 0 to ItemTextClass.Count - 1 do
  begin
    p := ItemTextClass.GetIndex(i);
    dispose(p);
  end;
  ItemTextClass.Clear;
  for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
  DataList.Clear;
  AnsIndexClass.Clear;

  Job_Material1.Clear;
  Job_Material2.Clear;
  Job_Material3.Clear;
  Job_Material4.Clear;
  Job_Material1.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
  Job_Material2.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
  Job_Material3.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
  Job_Material4.Add('name,shape,Grade,mn1,mc1,mn2,mc2,mn3,mc3,mn4,mc4,');
end;

procedure TItemClass.JOb_add(var aitem: titemdata);
var
  str: string;
  i: integer;
begin
  if aitem.rboJobDown = false then exit;
  case aitem.rjobKind of
    1, 2, 3, 4: ;
  else exit;
  end;
  str := '';
    //物品名字
  str := str + aitem.rName + ',';
    //图像
  str := str + inttostr(aitem.rShape) + ',';
    //品
  str := str + inttostr(aitem.rGrade) + ',';
  for i := 0 to 4 - 1 do
  begin
    //材料名字
    str := str + aitem.rMaterial.nameArr[i] + ',';
    //材料数量
    str := str + inttostr(aitem.rMaterial.countArr[i]) + ',';
  end;

  case aitem.rjobKind of
    1: Job_Material1.Add(str);
    2: Job_Material2.Add(str);
    3: Job_Material3.Add(str);
    4: Job_Material4.Add(str);
  else exit;
  end;


end;

procedure TItemClass.ReLoadFromFile;
var
  i: integer;
  iName: string;
  pid: PTItemData;
//    tempitem: titemdata;
begin

  Clear;
  if not FileExists('.\Init\Item.SDB') then exit;

  ItemDb.LoadFromFile('.\Init\Item.SDB');
  for i := 0 to ItemDb.Count - 1 do
  begin
    iName := ItemDb.GetIndexName(i);
    New(pid);
    LoadItemData(iName, pid^);
    DataList.Add(pid);
    AnsIndexClass.Insert(iname, (pid));



  end;

end;

function TItemClass.getdesc(aname: string): string;
var
  pp: pTitemTextdata;
begin
  result := '';
  pp := ItemTextClass.Select(aname);
  if pp = nil then exit;
  result := pp.rdesc;
end;
 

function TItemClass.LoadItemData(aItemName: string; var ItemData: TItemData): Boolean;
var
  mName, mcount, Str: string;
  pp: pTitemTextdata;
  i: integer;
  boMaterial: boolean;
  tempMaterial_p: ptMaterialdata;
begin
  Result := FALSE;
  boMaterial := false;
  FillChar(ItemData, sizeof(ItemData), 0);
  if ItemDb.GetDbString(aItemName) = '' then exit;

  ItemData.rname := aItemName;
  Str := ItemDB.GetFieldValueString(aItemName, 'desc');
    //物品描述 列表
  if ItemTextClass.Select(aItemName) = nil then
  begin
    new(pp);
    pp.rname := aItemName;
    pp.rdesc := copy(str, 1, 255);
    ItemTextClass.Insert(pp.rname, pp);
  end;

  Str := ItemDB.GetFieldValueString(aItemName, 'ViewName');
  ItemData.rViewName := Str;
  Itemdata.rNameColor := ItemDb.GetFieldValueinteger(aItemName, 'NameColor');
  Itemdata.rjobKind := ItemDb.GetFieldValueinteger(aItemName, 'jobKind');
  Itemdata.rSpecialKind := ItemDb.GetFieldValueinteger(aItemName, 'SpecialKind');
  Itemdata.rcLife := ItemDb.GetFieldValueinteger(aItemName, 'cLife');
  Itemdata.rboJobDown := ItemDb.GetFieldValueBoolean(aItemName, 'boJobDown');
  Itemdata.rQuestNum := ItemDb.GetFieldValueinteger(aItemName, 'QuestNum');
  Itemdata.rboQuestProcession := ItemDb.GetFieldValueBoolean(aItemName, 'boQuestProcession');
  Itemdata.rMix := ItemDb.GetFieldValueString(aItemName, 'Mix');
  Itemdata.rNeedEnergyLevel := ItemDb.GetFieldValueInteger(aItemName, 'NeedEnergyLevel');


  Itemdata.rRepairPrice := ItemDb.GetFieldValueinteger(aItemName, 'RepairPrice');

 // StrToEffectData(ItemData.rSoundEvent, ItemDb.GetFieldValueString(aItemName, 'SoundEvent'));
//  StrToEffectData(ItemData.rSoundDrop, ItemDb.GetFieldValueString(aItemName, 'SoundDrop'));

  Itemdata.rMaxCount := ItemDb.GetFieldValueinteger(aItemName, 'MaxCount'); //新(最大持有数量)

  Itemdata.rLifeDataBasic.DamageBody := ItemDb.GetFieldValueinteger(aItemName, 'DamageBody');
  Itemdata.rLifeDataBasic.DamageHead := ItemDb.GetFieldValueinteger(aItemName, 'DamageHead');
  Itemdata.rLifeDataBasic.DamageArm := ItemDb.GetFieldValueinteger(aItemName, 'DamageArm');
  Itemdata.rLifeDataBasic.DamageLeg := ItemDb.GetFieldValueinteger(aItemName, 'DamageLeg');

  Itemdata.rLifeDataBasic.ArmorBody := ItemDb.GetFieldValueinteger(aItemName, 'ArmorBody');
  Itemdata.rLifeDataBasic.ArmorHead := ItemDb.GetFieldValueinteger(aItemName, 'ArmorHead');
  Itemdata.rLifeDataBasic.ArmorArm := ItemDb.GetFieldValueinteger(aItemName, 'ArmorArm');
  Itemdata.rLifeDataBasic.ArmorLeg := ItemDb.GetFieldValueinteger(aItemName, 'ArmorLeg');

  Itemdata.rLifeDataBasic.HitArmor := ItemDb.GetFieldValueinteger(aItemName, 'KeepRecovery');

  Itemdata.rLifeDataBasic.AttackSpeed := 0 - ItemDb.GetFieldValueinteger(aItemName, 'AttackSpeed');
  Itemdata.rLifeDataBasic.Recovery := 0 - ItemDb.GetFieldValueinteger(aItemName, 'Recovery');
  Itemdata.rLifeDataBasic.Avoid := ItemDb.GetFieldValueinteger(aItemName, 'Avoid');
  Itemdata.rLifeDataBasic.accuracy := ItemDb.GetFieldValueinteger(aItemName, 'accuracy');
  Itemdata.rLifeData := Itemdata.rLifeDataBasic;
    //rLifeDataSuit
  Itemdata.rLifeDataSuit.DamageBody := ItemDb.GetFieldValueinteger(aItemName, 'sDamageBody');
  Itemdata.rLifeDataSuit.DamageHead := ItemDb.GetFieldValueinteger(aItemName, 'sDamageHead');
  Itemdata.rLifeDataSuit.DamageArm := ItemDb.GetFieldValueinteger(aItemName, 'sDamageArm');
  Itemdata.rLifeDataSuit.DamageLeg := ItemDb.GetFieldValueinteger(aItemName, 'sDamageLeg');

  Itemdata.rLifeDataSuit.ArmorBody := ItemDb.GetFieldValueinteger(aItemName, 'sArmorBody');
  Itemdata.rLifeDataSuit.ArmorHead := ItemDb.GetFieldValueinteger(aItemName, 'sArmorHead');
  Itemdata.rLifeDataSuit.ArmorArm := ItemDb.GetFieldValueinteger(aItemName, 'sArmorArm');
  Itemdata.rLifeDataSuit.ArmorLeg := ItemDb.GetFieldValueinteger(aItemName, 'sArmorLeg');

  Itemdata.rLifeDataSuit.AttackSpeed := 0 - ItemDb.GetFieldValueinteger(aItemName, 'sAttackSpeed');
  Itemdata.rLifeDataSuit.Recovery := 0 - ItemDb.GetFieldValueinteger(aItemName, 'sRecovery');
  Itemdata.rLifeDataSuit.Avoid := ItemDb.GetFieldValueinteger(aItemName, 'sAvoid');
  Itemdata.rLifeDataSuit.accuracy := ItemDb.GetFieldValueinteger(aItemName, 'saccuracy');


  Itemdata.rSuitId := ItemDb.GetFieldValueinteger(aItemName, 'SuitId');

    //关开
  ItemData.MaxUpgrade := ItemDb.GetFieldValueinteger(aItemName, 'MaxUpgrade'); //新 (最大升级别)
  Itemdata.boUpgrade := ItemDb.GetFieldValueBoolean(aItemName, 'boUpgrade'); //新 (允许升级)
  Itemdata.rboNotTrade := ItemDb.GetFieldValueBoolean(aItemName, 'boNotTrade'); //新(允许交易)
  Itemdata.rboNotExchange := ItemDb.GetFieldValueBoolean(aItemName, 'boNotExchange'); //新(允许交换)
  Itemdata.rboNotDrop := ItemDb.GetFieldValueBoolean(aItemName, 'boNotDrop'); //新(允许丢在地上)
  Itemdata.rboNotSSamzie := ItemDb.GetFieldValueBoolean(aItemName, 'boNotSSamzie'); //新(允许放在福袋)
  ItemData.rboLOG := ItemDb.GetFieldValueBoolean(aItemName, 'boLOG'); //新
  Itemdata.rboTimeMode := ItemDb.GetFieldValueBoolean(aItemName, 'boTimeMode'); //新 时间模式 每秒消耗
  Itemdata.rboDurability := ItemDb.GetFieldValueBoolean(aItemName, 'boDurability'); //新(打击消耗持久)
  ItemData.rboNOTRepair := ItemDb.GetFieldValueBoolean(aItemName, 'boNOTRepair'); //新 可维修
  ItemData.rboSetting := ItemDb.GetFieldValueBoolean(aItemName, 'boSetting'); //
  ItemData.rboident := (ItemDb.GetFieldValueBoolean(aItemName, 'boident')); //是否可鉴定
  ItemData.rboExplosion := (ItemDb.GetFieldValueBoolean(aItemName, 'boExplosion'));

//    ItemData.rboQuest := (ItemDb.GetFieldValueBoolean(aItemName, 'boQuest'));   // 任务装备 物品 过地图 就自动删除
  ItemData.rboBlueprint := (ItemDb.GetFieldValueBoolean(aItemName, 'boBlueprint')); //
//    ItemData.rboPrestige := (ItemDb.GetFieldValueBoolean(aItemName, 'boPrestige')); //


  Itemdata.rDurability := ItemDb.GetFieldValueinteger(aItemName, 'Durability');
  Itemdata.rDecSize := ItemDb.GetFieldValueinteger(aItemName, 'DecSize'); //新 DecSize(损坏大小) 每次磨损几点耐久

  Itemdata.rCurDurability := Itemdata.rDurability;

  ItemData.rWearArr := ItemDb.GetFieldValueinteger(aItemName, 'WearPos');
  ItemData.rWearShape := ItemDb.GetFieldValueinteger(aItemName, 'WearShape');
  ItemData.rShape := ItemDb.GetFieldValueinteger(aItemName, 'Shape');
  ItemData.rActionImage := ItemDb.GetFieldValueInteger(aItemName, 'ActionImage');
  ItemData.rHitMotion := ItemDb.GetFieldValueinteger(aItemName, 'HitMotion');
  ItemData.rHitType := ItemDb.GetFieldValueinteger(aItemName, 'HitType');
  ItemData.rKind := ItemDb.GetFieldValueinteger(aItemName, 'Kind');
  ItemData.rSpecialKind := ItemDb.GetFieldValueinteger(aItemName, 'SpecialKind');
  ItemData.rColor := ItemDb.GetFieldValueinteger(aItemName, 'Color');
  ItemData.rBoDouble := ItemDb.GetFieldValueBoolean(aItemName, 'boDouble');
  ItemData.rBoColoring := ItemDb.GetFieldValueBoolean(aItemName, 'boColoring');
  ItemData.rPrice := ItemDb.GetFieldValueInteger(aItemName, 'Price');
  ItemData.rNeedGrade := ItemDb.GetFieldValueInteger(aItemName, 'NeedGrade');
  ItemData.rSex := (ItemDb.GetFieldValueInteger(aItemName, 'Sex'));
  ItemData.rDecDelay := (ItemDb.GetFieldValueInteger(aItemName, 'DecDelay'));




  ItemData.rAttribute := (ItemDb.GetFieldValueInteger(aItemName, 'Attribute'));

  str := ItemDb.GetFieldValueString(aItemName, 'WeaponLevelColor');
 // ItemData.rWeaponLevelColor_PP := WeaponLevelColorClass.get(STR);

  str := ItemDb.GetFieldValueString(aItemName, 'NeedItem');
  if str <> '' then
  begin
    str := GetValidStr3(str, mName, ':');
    str := GetValidStr3(str, mCount, ':');
    if (mName <> '') and (mCount <> '') then
    begin
      ItemData.rNeedItem := copy(mName, 1, 20);
      ItemData.rNeedItemCount := _StrToInt(mcount);

    end;
  end;

  str := (ItemDb.GetFieldValueString(aItemName, 'DelItem'));
  if str <> '' then
  begin
    str := GetValidStr3(str, mName, ':');
    str := GetValidStr3(str, mCount, ':');
    if (mName <> '') and (mCount <> '') then
    begin
      ItemData.rDelItem := copy(mName, 1, 20);
      ItemData.rDelItemCount := _StrToInt(mcount);
    end;
  end;
  str := (ItemDb.GetFieldValueString(aItemName, 'AddItem'));
  if str <> '' then
  begin
    str := GetValidStr3(str, mName, ':');
    str := GetValidStr3(str, mCount, ':');
    if (mName <> '') and (mCount <> '') then
    begin
      ItemData.rAddItem := copy(mName, 1, 20);
      ItemData.rAddItemCount := _StrToInt(mcount);
    end;
  end;

   { str := (ItemDb.GetFieldValueString(aItemName, 'NotHaveItem'));
    for i := 0 to high(ItemData.rNotHaveItemArr) do
    begin
        if str = '' then break;
        str := GetValidStr3(str, mName, ':');
        if mName = '' then break;
        str := GetValidStr3(str, mCount, ':');
        ItemData.rNotHaveItemArr[i] := copy(mName, 1, 20);
        ItemData.rNotHaveItemCountArr[i] := _StrToInt(mcount);
    end;
   }


  ItemData.rGrade := (ItemDb.GetFieldValueInteger(aItemName, 'Grade'));
  ItemData.rStarLevel := 0; // (ItemDb.GetFieldValueInteger(aItemName, 'StarLevel'));
  ItemData.rStarLevelMax := ItemDb.GetFieldValueInteger(aItemName, 'StarLevelMax');
//  str := ItemDb.GetFieldValueString(aItemName, 'Material');
//  if str <> '' then
//  begin
//   { if aItemName='溶华素' then
//    aItemName:=aItemName;
//        if aItemName='白龙剑' then
//    aItemName:=aItemName;    }
//    tempMaterial_p := MaterialClass.get(str);
//    if tempMaterial_p <> nil then
//    begin
//      ItemData.rMaterial := tempMaterial_p^;
//      boMaterial := true;
//    end;
//  end;
    //
    {for i := 0 to high(ItemData.rMaterial.namearr) do
    begin
        if str = '' then break;
        str := GetValidStr3(str, mName, ':');
        if mName = '' then break;
        str := GetValidStr3(str, mCount, ':');
        ItemData.MaterialArr[i].rname := copy(mName, 1, 20);
        ItemData.MaterialArr[i].rcount := _StrToInt(mcount);
        boMaterial := true;
    end;
    }
  ItemData.rNameParam[0] := ItemDb.GetFieldValueString(aItemName, 'NameParam1');
  ItemData.rNameParam[1] := ItemDb.GetFieldValueString(aItemName, 'NameParam2');
  ItemData.rDateTimeSec := ItemDb.GetFieldValueinteger(aItemName, 'DateTimeSec');
  ItemData.rServerId := ItemDb.GetFieldValueInteger(aItemName, 'ServerId');
  ItemData.rx := ItemDb.GetFieldValueInteger(aItemName, 'X');
  ItemData.ry := ItemDb.GetFieldValueInteger(aItemName, 'Y');

  ItemData.rScripter := ItemDb.GetFieldValueString(aItemName, 'Scripter');

  ItemData.rdiePunish := ItemDb.GetFieldValueInteger(aItemName, 'diePunish');
  ItemData.rRandomCount := ItemDb.GetFieldValueInteger(aItemName, 'RandomCount');

  ItemData.rCount := 1;

  ItemData.rSmithingLevel := 0; //新 装备等级
  ItemData.rAttach := 0; //新 附加属性
  ItemData.rlockState := 0; //新 物品锁状态
  ItemData.rlocktime := 0; //新 解锁状态 时间

  if boMaterial then JOb_add(ItemData);
  Result := TRUE;
 
end;

function TItemClass.GetItemData(aItemName: string; var ItemData: TItemData): Boolean;
var
  n: pointer;
begin
  Result := FALSE;

  n := AnsIndexClass.Select(aItemName);
    // if (n = 0) or (n = -1) then
  if n = nil then
  begin
    FillChar(ItemData, sizeof(ItemData), 0);
    exit;
  end;
  ItemData := PTItemData(n)^;

  Result := TRUE;
end;

 

function TItemClass.GetWearItemData(astr: string; var ItemData: TItemData): Boolean;
var
  str, rdstr, iname: string;
  icolor, icnt: integer;
begin
  Result := FALSE;

  str := astr;

  str := GetValidStr3(str, iname, ':');
  str := GetValidStr3(str, rdstr, ':');
  icolor := _StrToInt(rdstr);
  str := GetValidStr3(str, rdstr, ':');
  icnt := _StrToInt(rdstr);

  if GetItemData(iname, ItemData) = FALSE then exit;
  ItemData.rColor := icolor;
  ItemData.rCount := icnt;
  Result := TRUE;
end;

function TItemClass.GetWearItemString(var ItemData: TItemData): string;
begin
  Result := (ItemData.rName) + ':' + IntToStr(ItemData.rcolor) + ':' + IntToStr(ItemData.rCount) + ':';
end;
//////////////////////////////////////////////////////
//
//         TUserStringDb
//
//////////////////////////////////////////////////////

constructor TUserStringDb.Create;
var
    i: integer;
    p: PTOpenNameData;
begin

    dbName := 'noname.sdb';
    pWriteBuffer := nil;
    WriteBufferSize := 0;
    DbStringList := TStringList.Create;
    NameList := TNameList.Create;
    FieldList := TStringList.Create;
    LowerFieldList := TList.Create;
    AnsIndexClass := TStringKeyClass.Create;                                    //('Field', 64, TRUE);

    Open_Data := TList.Create;
    for i := 0 to 200 do
    begin
        new(p);
        p^.rdata := '';
        Open_Data.Add(p);
    end;
    Open_Name := '';
end;

destructor TUserStringDb.Destroy;
begin
    Clear;

    Open_Data.Free;
    AnsIndexClass.Free;
    LowerFieldList.Free;
    FieldList.Free;

    NameList.Free;
    DbStringList.Free;

    if pWriteBuffer <> nil then
        FreeMem(pWriteBuffer, WriteBufferSize);

    inherited Destroy;
end;

procedure TUserStringDb.Clear;
var
    i: integer;
begin
    CloseRecord;

    for i := 0 to LowerFieldList.Count - 1 do
        dispose(LowerFieldList[i]);
    LowerFieldList.Clear;
    FieldList.Clear;
    AnsIndexClass.Clear;

    for i := 0 to Open_Data.Count - 1 do
        dispose(Open_Data[i]);
    Open_Data.Clear;
    DbStringList.Clear;
    NameList.Clear;
end;

function TUserStringDb.GetFieldIndex(cField: string): integer;
{var i : integer;
begin
   Result := -1;
   for i := 0 to FieldList.Count-1 do if CompareText ( FieldList[i], cField) = 0 then begin Result := i; exit; end;
end;
}
var
    //   i : integer;
    str: string;
    p: PTStringFieldData;
begin
    Result := -1;
    str := LowerCase(cField);
    {
       for i := 0 to FieldList.Count-1 do begin
          if PTStringFieldData(LowerFieldList[i])^.rFieldName = str then begin Result := i; exit; end;
       end;
    }
    p := PTStringFieldData(AnsIndexclass.Select(str));
    // if (integer(p) <> 0) and (integer(p) <> -1) then
    if p <> nil then
    begin
        Result := p^.rindex;
    end;

end;

function TUserStringDb.GetNameIndex(cName: string): integer;
var
    pn: PTNameData;
begin
    Result := -1;
    pn := NameList.Find(cName);
    if pn = nil then
        exit;
    Result := pn^.rindex;
end;

procedure TUserStringDb.LoadFromFile(aFileName: string);
var
    atemp: TStringList;
begin
    if FileExists(aFileName) = FALSE then
    begin
        Windows.MessageBox(0, pchar(aFileName + '文件不存在.'), '警告！错误提示', 0);
        exit;
    end;
    atemp := TStringList.Create;
    try
        dbName := aFileName;
        atemp.LoadFromFile(aFileName);
        LoadFromStringList(atemp);

    finally
        atemp.Free;
    end;
end;

procedure TUserStringDb.LoadFromStringList(atemp: TStringList);
var
    i: integer;
    str, rdstr: string;
    p: PTStringFieldData;
    po: PTOpenNameData;
begin

    Clear;

    DbStringList.Clear;
    DbStringList.AddStrings(atemp);
    for i := DbStringList.Count - 1 downto 0 do
    begin
        str := DbStringList[i];
        if str = '' then
        begin
            DbStringList.Delete(i);
            continue;
        end;
        if str[1] = ',' then
            DbStringList.Delete(i);
    end;

    if DbStringList.Count = 0 then
    begin
        Windows.MessageBox(0, pchar(dbName + '无内容.'), '警告！错误提示', 0);
        exit;
    end;

    i := 0;
    str := DbStringList[0];
    while str <> '' do
    begin
        str := GetValidStr3(str, rdstr, ',');
        FieldList.add(rdstr);

        new(p);
        p^.rfieldname := LowerCase(rdstr);
        p^.rindex := i;
        inc(i);
        LowerFieldList.Add(p);

        AnsIndexclass.Insert(LowerCase(rdstr), (p));

        new(po);
        po^.rdata := '';
        Open_Data.Add(po);
    end;

    DbStringList.Delete(0);

    for i := 0 to DbStringList.Count - 1 do
    begin
        str := DbStringList[i];
        str := GetValidStr3(str, rdstr, ',');
        NameList.AddNoSort(rdstr, i);
    end;

    NameList.Sort;
end;

procedure TUserStringDb.SaveToFile(aFileName: string);
var
    i, clen, wsize: integer;
    tempfieldstr: string;
    ptemp: pchar;
    Stream: TFileStream;
begin
    CloseRecord;

    dbName := aFileName;

    tempfieldstr := '';
    for i := 0 to FieldList.Count - 1 do
        tempfieldstr := tempfieldstr + FieldList[i] + ',';
    wsize := Length(tempfieldstr) + 2;
    for i := 0 to DbStringList.count - 1 do
        wsize := wsize + Length(DbStringList[i]) + 2;

    if wsize >= WriteBufferSize - 1 then
    begin
        if pWriteBuffer <> nil then
            FreeMem(pWriteBuffer, WriteBufferSize);
        WriteBufferSize := wsize + 16384 + wsize div 10;
        GetMem(pWriteBuffer, WriteBufferSize)
    end;

    ptemp := pWriteBuffer;

    StrPCopy(ptemp, tempfieldstr + #13 + #10);
    clen := Length(tempfieldstr) + 2;
    inc(ptemp, clen);

    for i := 0 to DbStringList.count - 1 do
    begin
        StrPCopy(ptemp, DbStringList[i] + #13 + #10);
        clen := Length(DbStringList[i]) + 2;
        inc(ptemp, clen);
    end;

    Stream := TFileStream.create(aFileName, fmCreate);
    Stream.WriteBuffer(pWriteBuffer^, wsize);
    Stream.Free;
end;

function TUserStringDb.OpenRecord(cName: string): Boolean;
var
    i, n: integer;
    str, rdstr: string;
begin
    Result := FALSE;
    CloseRecord;

    n := GetNameIndex(cName);
    if n = -1 then
        exit;

    str := DbStringList[n];
    for i := 0 to FieldList.Count - 1 do
    begin
        str := GetValidStr3(str, rdstr, ',');
        PTOpenNameData(Open_Data[i])^.rdata := rdstr;
    end;
    Open_Name := cName;

    Result := TRUE;
end;

procedure TUserStringDb.CloseRecord;
var
    i, n, pos: integer;
    str: string;
    buffer: array[0..16384] of byte;
begin
    {
       if Open_Name <> '' then begin
          n := GetNameIndex (Open_Name);
          if n <> -1 then begin
             str := '';
             for i := 0 to FieldList.Count -1 do str := str + PTOpenNameData (Open_Data[i])^.rData + ',';
             DbStringList[n] := str;
          end;
       end;
    }
    if Open_Name <> '' then
    begin
        n := GetNameIndex(Open_Name);
        if n <> -1 then
        begin
            pos := 0;
            str := '';
            for i := 0 to FieldList.Count - 1 do
            begin
                StrPCopy(@Buffer[pos], PTOpenNameData(Open_Data[i])^.rData + ',');
                inc(pos, Length(PTOpenNameData(Open_Data[i])^.rData) + 1);
                //            str := str + PTOpenNameData (Open_Data[i])^.rData + ',';
            end;
            DbStringList[n] := StrPas(@buffer);
        end;
        Open_Name := '';
        for i := 0 to FieldList.Count - 1 do
            PTOpenNameData(Open_Data[i])^.rdata := '';
    end;

end;

function TUserStringDb.GetFieldValueString(cName, cField: string): string;
var
    fn: integer;
begin
    Result := '';
    if cName <> Open_Name then
        if OpenRecord(cName) = FALSE then
            exit;

    fn := GetFieldIndex(cField);
    if fn = -1 then
    begin
        Showmessage(DbName + ' : Field Not Found : ' + cField);
        exit;
    end;
    Result := PTOpenNameData(Open_Data[fn])^.rdata;
end;

function TUserStringDb.SetFieldValueString(cName, cField, Value: string): Boolean;
var
    fn: integer;
begin
    Result := FALSE;
    Value := StringReplace(Value, ',', '?', [rfReplaceAll]);
    if cName <> Open_Name then
        if OpenRecord(cName) = FALSE then
            exit;

    fn := GetFieldIndex(cField);
    if fn = -1 then
    begin
        Showmessage(DbName + ' : Field Not Found : ' + cField);
        exit;
    end;
    PTOpenNameData(Open_Data[fn])^.rdata := Value;
    Result := TRUE;
end;

function TUserStringDb.GetFieldValueBoolean(cName, cField: string): Boolean;
var
    str: string;
begin
    str := GetFieldValueString(cName, cField);
    if str = 'TRUE' then
        Result := TRUE
    else
        Result := FALSE;
end;

function TUserStringDb.SetFieldValueBoolean(cName, cField: string; Value: Boolean): Boolean;
var
    str: string;
begin
    if Value then
        str := 'TRUE'
    else
        str := 'FALSE';
    Result := SetFieldValueString(cName, cField, str);
end;

function TUserStringDb.GetFieldValueInteger(cName, cField: string): Integer;
var
    str: string;
begin
    str := GetFieldValueString(cName, cField);
    Result := _StrToInt(str);
end;

function TUserStringDb.SetFieldValueInteger(cName, cField: string; Value: Integer): Boolean;
var
    str: string;
begin
    str := IntToStr(Value);
    Result := SetFieldValueString(cName, cField, str);
end;

function TUserStringDb.GetDbString(cName: string): string;
var
    idx: integer;
begin
    CloseRecord;
    idx := GetNameIndex(cName);
    if idx = -1 then
        Result := ''
    else
        Result := DbStringList[idx];
end;

function TUserStringDb.SetDbString(cName, aDbStr: string): Boolean;
var
    idx: integer;
begin
    CloseRecord;
    idx := GetNameIndex(cName);
    if idx = -1 then
        Result := FALSE
    else
    begin
        DbStringList[idx] := aDbStr;
        Result := TRUE;
    end;
end;

function TUserStringDb.AddDbString(aDbStr: string): Boolean;
var
    uname: string;
begin
    CloseRecord;

    DbStringList.Add(aDbStr);

    GetValidStr3(aDbStr, uname, ',');
    NameList.Add(uname, DbStringList.Count - 1);
    Result := TRUE;
end;

function TUserStringDb.AddName(cName: string): Boolean;
var
    i: integer;
    str: string;
begin
    CloseRecord;
    Result := FALSE;
    if GetNameIndex(cName) <> -1 then
        exit;

    str := cName + ',';
    for i := 1 to FieldList.Count - 1 do
        str := str + ',';
    DBStringList.Add(Str);
    NameList.Add(cName, DbStringList.Count - 1);

    Result := TRUE;
end;

function TUserStringDb.DeleteName(cName: string): Boolean;
var
    idx: integer;
begin
    CloseRecord;

    Result := FALSE;
    idx := GetNameIndex(cName);
    if idx = -1 then
        exit;

    DbStringList.Delete(idx);
    NameList.Delete(CName);
    Result := TRUE;
end;

function TUserStringDb.AddField(aField: string): Boolean;
var
    po: PTOpenNameData;
    p: PTStringFieldData;
begin
    CloseRecord;
    if GetFieldIndex(aField) = -1 then
    begin
        FieldList.add(aField);

        new(p);
        p^.rfieldname := LowerCase(aField);
        p^.rindex := LowerFieldList.Count;
        LowerFieldList.Add(p);

        AnsIndexclass.Insert(LowerCase(aField), p);

        new(po);
        po^.rdata := '';
        Open_Data.Add(po);

        Result := TRUE;
    end
    else
    begin
        Result := FALSE;
    end;
end;

function TUserStringDb.SetDbFields(aFields: string): Boolean;
var
    i: integer;
    str, rdstr: string;
    p: PTStringFieldData;
    po: PTOpenNameData;
begin
    CloseRecord;

    for i := 0 to LowerFieldList.Count - 1 do
        dispose(LowerFieldList[i]);
    LowerFieldList.Clear;
    AnsIndexClass.Clear;
    FieldList.Clear;

    for i := 0 to Open_Data.Count - 1 do
        dispose(Open_Data[i]);
    Open_Data.Clear;

    str := aFields;

    i := 0;
    while TRUE do
    begin
        if str = '' then
            break;
        str := GetValidStr3(str, rdstr, ',');
        if rdstr = '' then
            break;

        FieldList.Add(rdstr);

        new(p);
        p^.rfieldname := LowerCase(rdstr);
        p^.rindex := i;
        inc(i);
        LowerFieldList.Add(p);
        AnsIndexclass.Insert(LowerCase(rdstr), p);

        new(po);
        po^.rdata := '';
        Open_Data.add(p);
    end;
    Result := TRUE;
end;

function TUserStringDb.GetDbFields: string;
var
    i: integer;
    str: string;
begin
    str := '';
    for i := 0 to FieldList.Count - 1 do
    begin
        str := str + FieldList[i] + ',';
    end;
    Result := str;
end;

function TUserStringDb.GetIndexString(Index: Integer): string;
begin
    CloseRecord;
    if index >= DbStringList.Count then
        Result := ''
    else
        Result := DbStringList[index];
end;

function TUserStringDb.GetIndexName(Index: Integer): string;
var
    str, uname: string;
begin
    CloseRecord;
    if index >= DbStringList.Count then
        Result := ''
    else
    begin
        str := DbStringList[index];
        str := GetValidStr3(str, uname, ',');
        Result := uname;
    end;
end;

function TUserStringDb.GetNameCount: Integer;
begin
    Result := DbStringList.Count;
end;

function TUserStringDb.GetFieldCount: Integer;
begin
    Result := FieldList.Count;
end;
 
initialization
  G_ItemClass:=TItemClass.Create;
  G_ItemClass.ReLoadFromFile;
end.
