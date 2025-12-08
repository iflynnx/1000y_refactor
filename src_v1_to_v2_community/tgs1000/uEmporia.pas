unit uEmporia;

interface
uses
  Windows, Sysutils, Classes, Deftype, uAnsTick, BasicObj, SvClass,
  SubUtil, uSkills, uLevelExp, uUser, aUtil32,
  uKeyClass, DateUtils;
type
    //1,获取列表。
    //2，购买
  TEmporiadata = record
    index: INTEGER;
    name: string[32];
    text: string[255];
    num, price, maxnum: integer;
    aitem: titemdata;
    log: Boolean;
    SmithingLevel: integer;
  end;
  pTEmporiadata = ^TEmporiadata;
  TEmporiaClass = class
    Fdata: Tlist;
    FindexName: TStringKeyClass;
  private
    procedure Clear;
    procedure add(var aitem: TEmporiadata);

  public
    constructor Create;
    destructor Destroy; override;
    procedure loadFile();
    procedure GetItemList(auser: Tuser);
    function get(aname: string): pTEmporiadata;
  end;
var
  EmporiaClass: TEmporiaClass;
implementation        

uses
  SvMain;

procedure TEmporiaClass.GetItemList(auser: Tuser);
var
  ComData: TWordComData;
  I: INTEGER;
  PP: pTEmporiadata;
    // aitem           :titemdata;
begin
  ComData.Size := 0;
  WordComData_ADDbyte(ComData, SM_Emporia);
  WordComData_ADDbyte(ComData, Emporia_GetItemList);
  WordComData_ADDword(ComData, Fdata.Count);
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];

        // if ItemClass.GetItemData(pp.name, aitem) then
    begin
      WordComData_ADDbyte(ComData, PP.index);
      WordComData_ADDString(ComData, pp.aitem.rViewName);
      WordComData_ADDString(ComData, PP.text);
      WordComData_ADDdword(ComData, PP.num);
      WordComData_ADDdword(ComData, PP.price);
      WordComData_ADDword(ComData, pp.aitem.rcolor);
      WordComData_ADDword(ComData, pp.aitem.rShape);
      WordComData_ADDword(ComData, pp.SmithingLevel);
    end;
  end;
  auser.SendClass.SendData(ComData);
end;

function TEmporiaClass.get(aname: string): pTEmporiadata;
begin
  result := FindexName.Select(aname);
end;

procedure TEmporiaClass.add(var aitem: TEmporiadata);
var
  pp: pTEmporiadata;
begin

  pp := get(aitem.name);
  if pp <> nil then exit;
  pp := nil;
  New(pp);
  pp^ := aitem;
  fdata.Add(pp);
  FindexName.Insert(pp.name, pp);
end;

procedure TEmporiaClass.loadFile();
var
  i, j: integer;
  str, rdstr: string;
  StringList: TStringList;
  atp: TEmporiadata;
begin
  Clear;
  if not FileExists('.\init\emporia.sdb') then exit;

  StringList := TStringList.Create;
  StringList.LoadFromFile('.\init\emporia.sdb');
  for i := 1 to StringList.Count - 1 do
  begin //index,name,num,price,text,
    str := StringList[i];

    str := GetValidStr3(str, rdstr, ',');
    atp.index := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.name := copy(rdstr, 1, 32);
    str := GetValidStr3(str, rdstr, ',');
    atp.num := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.price := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    atp.text := copy(rdstr, 1, 255);
    str := GetValidStr3(str, rdstr, ',');
    atp.maxnum := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    if rdstr = 'TRUE' then
      atp.log := True
    else
      atp.log := False;
    str := GetValidStr3(str, rdstr, ',');
    atp.SmithingLevel := _StrToInt(rdstr);
    if ItemClass.GetItemData(atp.name, atp.aitem) then add(atp);
  end;
  StringList.Free;
end;

procedure TEmporiaClass.Clear;
var
  I: INTEGER;
  PP: pTEmporiadata;
begin
  for I := 0 to Fdata.Count - 1 do
  begin
    PP := Fdata.Items[I];
    dispose(pp);
  end;
  Fdata.Clear;
  FindexName.Clear;
end;

constructor TEmporiaClass.Create;
begin
  Fdata := TLIST.Create;
  FindexName := TStringKeyClass.Create;
  loadFile;
end;

destructor TEmporiaClass.Destroy;
begin
  Clear;
  Fdata.Free;
  FindexName.Free;
  inherited destroy;
end;
//////////////////////
end.

