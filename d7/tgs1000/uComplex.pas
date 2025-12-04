unit uComplex; //2015.12.08 在水一方

interface
uses
  Windows, Sysutils, Classes, Deftype, uAnsTick, BasicObj, SvClass,
  SubUtil, uSkills, uLevelExp, uUser, aUtil32,
  uKeyClass, DateUtils;
type
    //1,获取列表。
    //2，购买
  TComplexdata = record
    id: integer;
    index: INTEGER;
    rColor, rShape: integer;
    cost: integer;
    probably: integer;
    needprof, addprof: integer;
    name: string[32];
    text: string[255];
    subitem1, subitem2, subitem3, subitem4: string[32];
    subShape1, subShape2, subShape3, subShape4: integer;
    subColor1, subColor2, subColor3, subColor4: integer;
    subNum1, subNum2, subNum3, subNum4: integer;
    aitem: titemdata;
    bomsg: Boolean;
  end;
  pComplexdata = ^TComplexdata;
  TComplexClass = class
    Fdata: Tlist;
    FindexName: TStringKeyClass;
  private
    procedure Clear;
    procedure add(var aitem: TComplexdata);

  public
    FLoadTick: DWORD;
    FComplexExp: DWORD;
    FIndex: integer;
    FCurrPage: integer;
    constructor Create;
    destructor Destroy; override;
    procedure loadFile();
    procedure GetItemList(auser: Tuser);
    function get(aname: string): pComplexdata;
  end;
var
  ComplexClass: TComplexClass;
implementation

procedure TComplexClass.GetItemList(auser: Tuser);
var
  ComData: TWordComData;
  I, N: INTEGER;
  PP: pComplexdata;
    // aitem           :titemdata;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Complex);
  WordComData_ADDbyte(ComData, Complex_GetItemList);
  WordComData_ADDDword(ComData, FLoadTick);
  WordComData_ADDDword(ComData, FComplexExp);
    //WordComData_ADDword(ComData, Fdata.Count);
  N := 0;
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];
    if (FIndex <> -1) and (PP.index <> FIndex) then Continue;
    Inc(N);
  end;
  WordComData_ADDword(ComData, N);
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];
        // if ItemClass.GetItemData(pp.name, aitem) then
    begin
            //不是分类跳出下一个循环
      if (FIndex <> -1) and (PP.index <> FIndex) then Continue;
      WordComData_ADDbyte(ComData, PP.index);
      WordComData_ADDbyte(ComData, pp.probably);
      WordComData_ADDword(ComData, pp.aitem.rcolor);
      WordComData_ADDword(ComData, pp.aitem.rShape);
      WordComData_ADDdword(ComData, PP.cost);
      WordComData_ADDdword(ComData, PP.needprof);
      WordComData_ADDdword(ComData, PP.addprof);
      WordComData_ADDString(ComData, pp.aitem.rViewName);
      WordComData_ADDString(ComData, PP.text);
      WordComData_ADDword(ComData, pp.subShape1);
      WordComData_ADDword(ComData, pp.subShape2);
      WordComData_ADDword(ComData, pp.subShape3);
      WordComData_ADDword(ComData, pp.subShape4);
      WordComData_ADDword(ComData, pp.subColor1);
      WordComData_ADDword(ComData, pp.subColor2);
      WordComData_ADDword(ComData, pp.subColor3);
      WordComData_ADDword(ComData, pp.subColor4);
      WordComData_ADDdword(ComData, PP.subNum1);
      WordComData_ADDdword(ComData, PP.subNum2);
      WordComData_ADDdword(ComData, PP.subNum3);
      WordComData_ADDdword(ComData, PP.subNum4);
      WordComData_ADDString(ComData, PP.subitem1);
      WordComData_ADDString(ComData, PP.subitem2);
      WordComData_ADDString(ComData, PP.subitem3);
      WordComData_ADDString(ComData, PP.subitem4);
    end;
  end;
  auser.SendClass.SendData(ComData);
end;

function TComplexClass.get(aname: string): pComplexdata;
begin
  result := FindexName.Select(aname);
end;

procedure TComplexClass.add(var aitem: TComplexdata);
var
  pp: pComplexdata;
begin

  pp := get(aitem.name);
  if pp <> nil then exit;
  pp := nil;
  New(pp);
  pp^ := aitem;
  fdata.Add(pp);
  FindexName.Insert(pp.name, pp);
end;

procedure TComplexClass.loadFile();
var
  i, j: integer;
  str, rdstr: string;
  StringList: TStringList;
  atp: TComplexdata;
  subitem: titemdata;
begin
  Clear;
  if not FileExists('.\init\Complex.sdb') then exit;

  FLoadTick := mmAnsTick;
  StringList := TStringList.Create;
  StringList.LoadFromFile('.\init\Complex.sdb');
  for i := 1 to StringList.Count - 1 do
  begin //index,name,cost,probably,needprof,addprof,text,subitem1,subNum1,subitem2,subNum2,subitem3,subNum3,subitem4,subNum4
    str := StringList[i];

    str := GetValidStr3(str, rdstr, ',');
    atp.index := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.name := copy(rdstr, 1, 32);
    str := GetValidStr3(str, rdstr, ',');
    atp.cost := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.probably := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.needprof := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.addprof := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.text := copy(rdstr, 1, 255);
    str := GetValidStr3(str, rdstr, ',');
    atp.subitem1 := copy(rdstr, 1, 32);
    str := GetValidStr3(str, rdstr, ',');
    atp.subNum1 := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.subitem2 := copy(rdstr, 1, 32);
    str := GetValidStr3(str, rdstr, ',');
    atp.subNum2 := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.subitem3 := copy(rdstr, 1, 32);
    str := GetValidStr3(str, rdstr, ',');
    atp.subNum3 := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.subitem4 := copy(rdstr, 1, 32);
    str := GetValidStr3(str, rdstr, ',');
    atp.subNum4 := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    if rdstr = 'TRUE' then
      atp.bomsg := true
    else
      atp.bomsg := false;

    if ItemClass.GetItemData(atp.subitem1, subitem) then begin
      atp.subitem1 := subitem.rViewName;
      atp.subShape1 := subitem.rShape;
      atp.subColor1 := subitem.rcolor;
    end;
    if ItemClass.GetItemData(atp.subitem2, subitem) then begin
      atp.subitem2 := subitem.rViewName;
      atp.subShape2 := subitem.rShape;
      atp.subColor2 := subitem.rcolor;
    end;
    if ItemClass.GetItemData(atp.subitem3, subitem) then begin
      atp.subitem3 := subitem.rViewName;
      atp.subShape3 := subitem.rShape;
      atp.subColor3 := subitem.rcolor;
    end;
    if ItemClass.GetItemData(atp.subitem4, subitem) then begin
      atp.subitem4 := subitem.rViewName;
      atp.subShape4 := subitem.rShape;
      atp.subColor4 := subitem.rcolor;
    end;
    if ItemClass.GetItemData(atp.name, atp.aitem) then add(atp);
  end;
  StringList.Free;
end;

procedure TComplexClass.Clear;
var
  I: INTEGER;
  PP: pComplexdata;
begin
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];
    dispose(pp);
  end;
  Fdata.Clear;
  FindexName.Clear;
end;

constructor TComplexClass.Create;
begin
  FLoadTick := 0;
  FIndex := -1;
  FCurrPage := 0;
  Fdata := TLIST.Create;
  FindexName := TStringKeyClass.Create;
  loadFile;
end;

destructor TComplexClass.Destroy;
begin
  Clear;
  Fdata.Free;
  FindexName.Free;
  inherited destroy;
end;
//////////////////////
end.

