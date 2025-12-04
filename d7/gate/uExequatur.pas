unit uExequatur;

interface
uses
    Windows, Classes, SysUtils, uAnsTick, // AnsUnit,
    DefType, Autil32, MMSystem;

type
    //数据 结构  有4个数据  ID 名字 密码 加入时间
        {    TExequaturdata = record
              rid:integer;               //验证ID
              rname:string[32];
              rpassword:string[32];
              rTime:integer;
          end;
          pTExequaturdata = ^TExequaturdata;}
    TExequatur = class
    private
        FDCurTick:Cardinal;
        Fdata:tlist;
        Fid:integer;
    protected

    public
        FAvailabilityTime:integer;
        constructor Create;
        destructor Destroy; override;
        procedure Clear;
        function Get(aName:string):pTExequaturdata;
        function isName(aName:string):boolean;
        function GetIndex(aIndex:integer):pTExequaturdata;
        function GetID(aId:integer):pTExequaturdata;
        function GetIP(aIP:string):pTExequaturdata;
        function add(aname, apas:string):integer;
        function addnone(aname, apas:string):TExequaturdata; //增加空
        procedure add2(temp:pTExequaturdata);
        procedure delId(id:integer);
        procedure delIndex(aIndex:integer);
        procedure UPDATE(CurTick:Cardinal);
        function count():integer;
        procedure delname(aname:string);
    end;

implementation
//UPDATE  可以不忙看

procedure TExequatur.UPDATE(CurTick:Cardinal); //由 外面定时 调用    CurTick 当前时间
var
    i               :integer;
    p               :pTExequaturdata;
begin
    //1秒钟 执行一次
    if CurTick < FDCurTick then
      FDCurTick := CurTick;
    if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit; //GetItemLineTimeSec 函数 转换成秒单位
    FDCurTick := CurTick;
    if Fdata.Count <= 0 then EXIT;
    I := 0;
    //删除 到时间 数据
    while I < Fdata.Count do
    begin
        p := Fdata.Items[i];
        if CurTick < p.rTime then begin
          p.rTime := CurTick;
          Inc(i);
        end
        else if CurTick > (p.rTime + FAvailabilityTime) then
        begin
            delIndex(i);
        end else INC(I);
    end;
end;

procedure TExequatur.delIndex(aIndex:integer); //删除 aIndex存放位置序号
var
    p               :pTExequaturdata;
begin
    if (aIndex < 0) or (aIndex >= Fdata.Count) then exit;
    p := Fdata.Items[aIndex];
    Fdata.Delete(aIndex);
    dispose(p);
end;

procedure TExequatur.delname(aname:string); //删除
var
    i               :integer;
    p               :pTExequaturdata;
begin
    for i := 0 to Fdata.Count - 1 do //从0开始 查找 到要的数据 并且删除
    begin
        p := Fdata.Items[i];
        if aname = p.rname then
        begin
            Fdata.Delete(i);
            dispose(p);
            exit;
        end;
    end;
end;

procedure TExequatur.delId(id:integer); //查找到ID相同的数据 删除
var
    i               :integer;
    p               :pTExequaturdata;
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

procedure TExequatur.add2(temp:pTExequaturdata); //增加
var
    p               :pTExequaturdata;
begin
    p := Get(temp.rname);
    if p <> nil then
    begin
        delId(p.rid);
        p := nil;
    end;
    new(p);
    p^ := temp^;
    p.rTime := timeGetTime;
    Fdata.Add(p);
end;

function TExequatur.addnone(aname, apas:string):TExequaturdata; //增加
var
    p               :TExequaturdata;
begin

    p.rname := copy(aName, 1, 32);
    p.rpassword := copy(apas, 1, 32);
    inc(Fid);
    p.rid := Fid;
    p.rTime := timeGetTime;

    result := p;
end;

function TExequatur.add(aname, apas:string):integer; //增加
var
    p               :pTExequaturdata;
begin
    result := 0;
    p := Get(aName);
    if p <> nil then exit;
    new(p);
    p.rname := copy(aName, 1, 32);
    p.rpassword := copy(apas, 1, 32);
    inc(Fid);
    p.rid := Fid;
    p.rTime := timeGetTime;
    Fdata.Add(p);
    result := p.rid;
end;

function TExequatur.count():integer; //返回 数据条数量
begin
    result := Fdata.Count;
end;

function TExequatur.GetID(aId:integer):pTExequaturdata; //查找 ID相同的数据
var
    i               :integer;
    p               :pTExequaturdata;
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

function TExequatur.Get(aName:string):pTExequaturdata; //查找 名字 相同的数据
var
    i               :integer;
    p               :pTExequaturdata;
begin
    result := nil;
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        if aName = p.rname then
        begin
            result := p;
            exit;
        end;
    end;

end;

function TExequatur.GetIndex(aIndex:integer):pTExequaturdata; //查找 某个位置 的数据
begin
    result := nil;
    if (aIndex < 0) or (aIndex >= Fdata.Count) then exit;
    result := Fdata.Items[aIndex];

end;

function TExequatur.GetIP(aIP:string):pTExequaturdata; //查找 IP 相同的数据   //2016.07.09 在水一方
var
    i               :integer;
    p               :pTExequaturdata;
begin
    result := nil;
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        if aIP = p.ruserip then
        begin
            result := p;
            exit;
        end;
    end;

end;

function TExequatur.isName(aName:string):boolean; //测试 某个名字 是否在
begin
    result := Get(aName) <> nil;
end;

procedure TExequatur.Clear();      //清除  删除所有数据
var
    i               :integer;
    p               :pTExequaturdata;
begin
    for i := 0 to Fdata.Count - 1 do
    begin
        p := Fdata.Items[i];
        dispose(p);
    end;
    Fdata.Clear;
end;

constructor TExequatur.Create;     //创建           类使用前必须创建
begin
    inherited Create;
    Fdata := tlist.Create;
    FAvailabilityTime := 3000;     //30秒
    Fid := 0;
end;

destructor TExequatur.Destroy;     //释放          使用完后必须释放
begin
    Clear;
    Fdata.Free;
    inherited Destroy;
end;
end.

