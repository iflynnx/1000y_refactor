unit uBillboardcharts;

interface
uses
  Windows, Classes, SysUtils, svClass, subutil, uAnsTick, //AnsUnit,
  BasicObj, FieldMsg, MapUnit, DefType, Autil32, uMonster, uGramerid, UUser,
  IniFiles, uLevelexp, uGuildSub, uManager, UserSDB, uKeyClass;

type

  TBillboardcharts = class
  private
    ftype: TBillboardchartstype;
    fdata: TStringKeyListClass;
    FINDEX: TIntegerKeyListClass;
    FFileName: string;
    procedure Clear();

  public
    constructor Create(aFileName: string; atype: TBillboardchartstype);
    destructor Destroy; override;
    procedure SaveToFile(aFileName: string);
    procedure LoadFromFile(aFileName: string);
    procedure add(aname: string; aEnergy, aprestige, anewTalent: integer; aGuildName: string);
    procedure add2(atemp: pTBillboardchartsdata);
    procedure del(aname: string);
    function getname(aname: string): pTBillboardchartsdata;
    procedure getList(aid: integer; uUser: tuser);
  end;
  TBillboardGuilds = class
  private
    fdata: TStringKeyListClass;
    FINDEX: TIntegerKeyListClass;
    FFileName: string;
    procedure Clear();
  public
    procedure add(asysopname: string; aEnergy, acount: integer; aGuildName: string);
    procedure add2(atemp: pTBillboardGuildsData);
    procedure del(aname: string);
    function getname(aname: string): pTBillboardGuildsData;
    procedure SaveToFile(aFileName: string);
    procedure LoadFromFile(aFileName: string);
    constructor Create(aFileName: string);
    destructor Destroy; override;
    procedure getList(aid: integer; uUser: tuser);
  end;
var
  BillboardchartsEnergy: TBillboardcharts;
  BillboardchartsPrestige: TBillboardcharts;
  BillboardchartsnewTalent: TBillboardcharts;
  G_BillboardGuilds: TBillboardGuilds;
   // Billboardcharts3h:TBillboardcharts;
implementation

procedure TBillboardcharts.getList(aid: integer; uUser: tuser);
var
  i: integer;
  pp: pTBillboardchartsdata;
  temp, temp2: TWordComData;
  rcount, maxtemp: integer;
begin //aid 页数量
  maxtemp := (fdata.Count div 10);
  if (fdata.Count mod 10) > 0 then inc(maxtemp);
  if (aid < 0) or (aid >= maxtemp) then aid := 0;
  rcount := 0;
    //2009 5 2 修改 只返回 前10名 aid := 0; aid参数实际 被忽略
  aid := 0;
  temp2.Size := 0;
  i := FINDEX.Count - aid * 10 - 1;

  while (i >= 0) and (i < FINDEX.Count) do
  begin
    pp := FINDEX.GetIndex(i);
    if pp = nil then Break;
    WordComData_ADDdword(temp2, FINDEX.Count - I);
    WordComData_ADDstring(temp2, pp.rname);
    WordComData_ADDdword(temp2, pp.rEnergy);
    WordComData_ADDdword(temp2, pp.rPrestige);
    WordComData_ADDdword(temp2, pp.rnewTalent);
    WordComData_ADDstring(temp2, pp.rGuildName);
    inc(rcount);
    i := i - 1;
    if rcount >= 10 then Break;
  end;
  temp.Size := 0;
  WordComData_ADDbyte(temp, SM_Billboardcharts);
  case ftype of
    bctEnergy: WordComData_ADDbyte(temp, Billboardcharts_Energy);
    bctPrestige: WordComData_ADDbyte(temp, Billboardcharts_Prestige);
    bctnewTalent: WordComData_ADDbyte(temp, Billboardcharts_newTalent);
  end;
  WordComData_ADDdword(temp, rcount);
  WordComData_ADDdword(temp, aid);
  copymemory(@temp.Data[temp.size], @temp2.data, temp2.Size);
  temp.Size := temp.Size + temp2.Size;
  uUser.SendClass.SendData(temp);
end;

function TBillboardcharts.getname(aname: string): pTBillboardchartsdata;
begin
  result := fdata.Select(aname);
end;

procedure TBillboardcharts.del(aname: string);
var
  p: pTBillboardchartsdata;
begin
  p := getname(aname);
  if p <> nil then FINDEX.Delete(p.rid);
  if p <> nil then fdata.Delete(aname);
  if p <> nil then Dispose(p);
end;

procedure TBillboardcharts.add(aname: string; aEnergy, aprestige, anewTalent: integer; aGuildName: string);
var
    p               :TBillboardchartsdata;
begin
    p.rname := aname;
    p.rEnergy := aEnergy;
    p.rPrestige := aprestige;
    p.rnewTalent := anewTalent;
    p.rGuildName := aGuildName;
    add2(@p);
end;

procedure TBillboardcharts.add2(atemp: pTBillboardchartsdata);
var
  p: PTBillboardchartsdata;
  i: integer;
begin
  del(atemp.rname); //保证之前的删除  干净
  new(p);
  p^ := atemp^;
  p.rid := 1;
  fdata.Insert(p.rname, p);
  case ftype of
    bctEnergy:
      begin
        i := p.rEnergy;
        while true do
        begin
          p.rid := i;
          if FINDEX.Insert(i, p) = true then Break;
          dec(i);
        end;

      end;
    bctPrestige:
      begin
        i := p.rPrestige;
        while true do
        begin
          p.rid := i;
          if FINDEX.Insert(i, p) = true then Break;
          dec(i);
        end;
      end;
    bctnewTalent:
      begin
        i := p.rnewTalent*100;                        //2016.01.24 在水一方
        while true do
        begin
          p.rid := i;
          if FINDEX.Insert(i, p) = true then Break;
          dec(i);
        end;
      end;
  end;

end;

procedure TBillboardcharts.SaveToFile(aFileName: string);
var
  i: integer;
  str: string;
  StringList: TStringList;
  pp: pTBillboardchartsdata;
begin
  StringList := TStringList.Create;
  str := 'rname,rEnergy,rprestige,rnewTalent,rGuildName';
  StringList.add(str);
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.GetIndex(i);

    str := format('%s,%d,%d,%d,%s,', [pp.rname, pp.rEnergy, pp.rPrestige, pp.rnewTalent, pp.rGuildName]);
    StringList.Add(str);
  end;
  StringList.SaveToFile(aFileName);
  StringList.Free;

end;

procedure TBillboardcharts.LoadFromFile(aFileName: string);
var
  i: integer;
  str, rdstr: string;
  StringList: TStringList;
  pp: TBillboardchartsdata;
begin
  Clear;
  if not FileExists(aFileName) then exit;

  StringList := TStringList.Create;
  StringList.LoadFromFile(aFileName);

  for i := 1 to StringList.Count - 1 do
  begin
    str := StringList[i];
    str := GetValidStr3(str, rdstr, ',');
    pp.rname := copy(rdstr, 1, 20);
    str := GetValidStr3(str, rdstr, ',');
    pp.rEnergy := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    pp.rPrestige := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    pp.rnewTalent := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    pp.rGuildName := copy(rdstr, 1, 20);
    add2(@pp);
  end;
  StringList.Free;
end;

procedure TBillboardcharts.Clear();
var
  i: integer;
  p: pTBillboardchartsdata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.GetIndex(i);
    Dispose(p);
  end;
  fdata.Clear;
end;

constructor TBillboardcharts.Create(aFileName: string; atype: TBillboardchartstype);
begin
  inherited Create;
  ftype := atype;
  FFileName := aFileName;
  fdata := TStringKeyListClass.Create;
  FINDEX := TIntegerKeyListClass.Create;
  LoadFromFile(FFileName);
end;

destructor TBillboardcharts.Destroy;
begin
  SaveToFile(FFileName);
  Clear;
  fdata.Free;
  FINDEX.Free;
  inherited Destroy;
end;

{ TBillboardGuilds }

procedure TBillboardGuilds.add(asysopname: string; aEnergy,
  acount: integer; aGuildName: string);
var
  p: TBillboardGuildsData;
begin
  p.rSysopname := asysopname;
  p.rEnergy := aEnergy;
  p.rCount := acount;

  p.rGuildName := aGuildName;
  add2(@p);

end;

procedure TBillboardGuilds.add2(atemp: pTBillboardGuildsData);
var
  p: pTBillboardGuildsData;
  i: integer;
begin
  del(atemp.rGuildName);
  new(p);
  p^ := atemp^;
  p.rid := 1;
  fdata.Insert(p.rGuildName, p);

  i := p.rEnergy;
  while true do
  begin
    p.rid := i;
    if FINDEX.Insert(i, p) = true then Break;
    dec(i);
  end;

end;

procedure TBillboardGuilds.Clear;
var
  i: integer;
  p: pTBillboardGuildsData;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.GetIndex(i);
    Dispose(p);
  end;
  fdata.Clear;
end;

constructor TBillboardGuilds.Create(aFileName: string);
begin
  inherited Create;

  FFileName := aFileName;
  fdata := TStringKeyListClass.Create;
  FINDEX := TIntegerKeyListClass.Create;
  LoadFromFile(FFileName);
end;

procedure TBillboardGuilds.del(aname: string);
var
  p: pTBillboardGuildsData;
begin
  p := getname(aname);
  if p <> nil then FINDEX.Delete(p.rid);
  if p <> nil then fdata.Delete(aname);
  if p <> nil then Dispose(p);
end;

destructor TBillboardGuilds.Destroy;
begin
  SaveToFile(FFileName);
  Clear;
  fdata.Free;
  FINDEX.Free;
  inherited Destroy;
end;

procedure TBillboardGuilds.getList(aid: integer;uUser: tuser);
var
  i: integer;
  pp: pTBillboardGuildsData;
  temp, temp2: TWordComData;
  rcount, maxtemp: integer;
begin //aid 页数量
  maxtemp := (fdata.Count div 10);
  if (fdata.Count mod 10) > 0 then inc(maxtemp);
  if (aid < 0) or (aid >= maxtemp) then aid := 0;
  rcount := 0;
    //2009 5 2 修改 只返回 前10名 aid := 0; aid参数实际 被忽略
  aid := 0;
  temp2.Size := 0;
  i := FINDEX.Count - aid * 10 - 1;

  while (i >= 0) and (i < FINDEX.Count) do
  begin
    pp := FINDEX.GetIndex(i);
    if pp = nil then Break;
    WordComData_ADDdword(temp2, FINDEX.Count - I);
    WordComData_ADDstring(temp2, pp.rSysopname);
    WordComData_ADDdword(temp2, pp.rEnergy div 100);
    WordComData_ADDdword(temp2, pp.rCount);
    WordComData_ADDstring(temp2, pp.rGuildName);
    inc(rcount);
    i := i - 1;
    if rcount >= 10 then Break;
  end;
  temp.Size := 0;
  WordComData_ADDbyte(temp, SM_BillboardGuilds);
 
  WordComData_ADDdword(temp, rcount);
  WordComData_ADDdword(temp, aid);
  copymemory(@temp.Data[temp.size], @temp2.data, temp2.Size);
  temp.Size := temp.Size + temp2.Size;
  uUser.SendClass.SendData(temp);
end;

function TBillboardGuilds.getname(aname: string): pTBillboardGuildsData;
begin
  result := fdata.Select(aname);
end;

procedure TBillboardGuilds.LoadFromFile(aFileName: string);
var
  i: integer;
  str, rdstr: string;
  StringList: TStringList;
  pp: TBillboardGuildsData;
begin
  Clear;
  if not FileExists(aFileName) then exit;

  StringList := TStringList.Create;
  StringList.LoadFromFile(aFileName);

  for i := 1 to StringList.Count - 1 do
  begin
    str := StringList[i];
    str := GetValidStr3(str, rdstr, ',');
    pp.rSysopname := copy(rdstr, 1, 32);
    str := GetValidStr3(str, rdstr, ',');
    pp.rEnergy := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    pp.rCount := _StrToInt(rdstr);
    str := GetValidStr3(str, rdstr, ',');
    pp.rGuildName := copy(rdstr, 1, 20);
    add2(@pp);
  end;
  StringList.Free;
end;

procedure TBillboardGuilds.SaveToFile(aFileName: string);
var
  i: integer;
  str: string;
  StringList: TStringList;
  pp: pTBillboardGuildsData;
begin
  StringList := TStringList.Create;
  str := 'rSysopName,rEnergy,rCount,rGuildName';
  StringList.add(str);
  for i := 0 to fdata.Count - 1 do
  begin
    pp := fdata.GetIndex(i);

    str := format('%s,%d,%d,%s,', [pp.rSysopname, pp.rEnergy, pp.rCount, pp.rGuildName]);
    StringList.Add(str);
  end;
  StringList.SaveToFile(aFileName);
  StringList.Free;

end;

end.

