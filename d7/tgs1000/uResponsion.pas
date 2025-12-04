unit uResponsion;
//应答 列表
interface
uses
    Windows, Classes, SysUtils, svClass, uAnsTick, // AnsUnit,
    DefType, Autil32;

type
    TResponsiondata = record
        rid:integer;               //验证ID
        rSourceName:string[32];    //来源
        rSource:pointer;
        rDestName:string[32];      //目标
        rDest:pointer;
        rTime:integer;
    end;
    pTResponsiondata = ^TResponsiondata;

    TResponsion = class
    private
        FDCurTick:integer;
        Fdata:tlist;
        Fid:integer;
    protected

    public
        FAvailabilityTime:integer; //有效 时间
        constructor Create;
        destructor Destroy; override;
        procedure Clear;
        function Get(aName:string):pTResponsiondata;
        function isName(aName:string):boolean;
        function GetIndex(aIndex:integer):pTResponsiondata;
        function GetID(aId:integer):pTResponsiondata;
        function add(aName, aSourceName:string):integer;
        function addPointer(adestName, aSourceName:string; adest, aSource:pointer):integer;
        procedure del(aName:string);
        procedure delId(id:integer);
        procedure delIndex(aIndex:integer);
        procedure UPDATE(CurTick:INTEGER);
        function count():integer;
    end;

implementation

procedure TResponsion.UPDATE(CurTick:INTEGER);
var
    i               :integer;
    p               :pTResponsiondata;
begin
    if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
    FDCurTick := CurTick;
    if Fdata.Count <= 0 then EXIT;
    I := 0;

    while I < Fdata.Count do
    begin
        p := Fdata.Items[i];
        if CurTick > (p.rTime + FAvailabilityTime) then
        begin
            delIndex(i);
        end else INC(I);
    end;
end;

procedure TResponsion.delIndex(aIndex:integer);
var
    p               :pTResponsiondata;
begin
    if (aIndex < 0) or (aIndex >= Fdata.Count) then exit;
    p := Fdata.Items[aIndex];
    Fdata.Delete(aIndex);
    dispose(p);
end;

procedure TResponsion.del(aName:string);
var
    i               :integer;
    p               :pTResponsiondata;
begin
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        if (aName = p.rDestName) or (aName = p.rSourceName) then
        begin
            Fdata.Delete(i);
            dispose(p);
            exit;
        end;
    end;
end;

procedure TResponsion.delId(id:integer);
var
    i               :integer;
    p               :pTResponsiondata;
begin
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        if id = p.rid then
        begin
            Fdata.Delete(i);
            dispose(p);
            exit;
        end;
    end;
end;

function TResponsion.addPointer(adestName, aSourceName:string; adest, aSource:pointer):integer;
var
    p               :pTResponsiondata;
begin
    result := 0;
    p := Get(adestName);
    if p <> nil then exit;
    new(p);
    p.rDestName := copy(adestName, 1, 32);
    p.rSourceName := copy(aSourceName, 1, 32);
    inc(Fid);
    p.rid := Fid;
    p.rTime := mmAnsTick;
    p.rSource := aSource;
    p.rDest := adest;
    Fdata.Add(p);
    result := p.rid;
end;

function TResponsion.add(aName, aSourceName:string):integer;
begin
    result := addPointer(aName, aSourceName, nil, nil);
end;

function TResponsion.count():integer;
begin
    result := Fdata.Count;
end;

function TResponsion.GetID(aId:integer):pTResponsiondata;
var
    i               :integer;
    p               :pTResponsiondata;
begin
    result := nil;
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        if aId = p.rId then
        begin
            result := p;
            exit;
        end;
    end;
end;

function TResponsion.GetIndex(aIndex:integer):pTResponsiondata;
begin
    result := nil;
    if (aIndex < 0) or (aIndex >= Fdata.Count) then exit;
    result := Fdata.Items[aIndex];

end;

function TResponsion.isName(aName:string):boolean;
begin
    result := Get(aName) <> nil;
end;

function TResponsion.Get(aName:string):pTResponsiondata;
var
    i               :integer;
    p               :pTResponsiondata;
begin
    result := nil;
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        if aName = p.rDestName then
        begin
            result := p;
            exit;
        end;
    end;

end;

procedure TResponsion.Clear();
var
    i               :integer;
    p               :pTResponsiondata;
begin
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        dispose(p);
    end;
    Fdata.Clear;
end;

constructor TResponsion.Create;
begin
    inherited Create;
    Fdata := tlist.Create;
    FAvailabilityTime := 3000;     //30秒
    Fid := 0;
end;

destructor TResponsion.Destroy;
begin
    Clear;
    Fdata.Free;
    inherited Destroy;
end;
end.

