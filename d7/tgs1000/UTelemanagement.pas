unit UTelemanagement;
{
列表 存盘 读取
【元宝】纪录
1，人，上线（下线）纪录【元宝】
2，GM，部分指令纪录，制造物品。制造【元宝】。
}
interface
uses
    Windows, SysUtils, Classes, uKeyClass, deftype;
type
    Tmoneylistdata = record
        rname:string[64];
        rmoney:integer;
        rtime:tdatetime;
        rpos:integer;
    end;
    pTmoneylistdata = ^Tmoneylistdata;

    TsTMLogClass = class
    private
        Ffilename:string;
        DBStream:TFileStream;
        procedure EnCryption(buf:pointer; asize:integer);
        procedure DeCryption(buf:pointer; asize:integer);
    public
        constructor Create(afilename:string);
        destructor Destroy; override;

        procedure add(astr:string);
        procedure Clear();

        procedure gettostringlist(temp:TStrings);
    end;
    TsTMMoneyLogListClass = class
    private
        Ffilename:string;
        DBStream:TFileStream;
        indexname:TStringKeyClass;
        data:tlist;
        procedure Clear();
        function get(aname:string):pTmoneylistdata;
        //  procedure del(aname:string);
        procedure add(aitem:Tmoneylistdata; aWritefile:boolean = false);
        procedure EnCryption(buf:pointer; asize:integer);
        procedure DeCryption(buf:pointer; asize:integer);

        procedure LoadFromFile();
        procedure save(pp:pTmoneylistdata);
    public
        constructor Create(afilename:string);
        destructor Destroy; override;

        procedure gameLoad(aname:string; amoney:integer);
        procedure gamesave(aname:string; amoney:integer);
        procedure setsize();

    end;
var
    tmmoneylist     :TsTMMoneyLogListClass;
    tmlog           :TsTMLogClass;

implementation

procedure TsTMLogClass.EnCryption(buf:pointer; asize:integer);
var
    i               :integer;
    pb              :pbyte;
    bb              :byte;
begin
    pb := buf;
    for i := 1 to asize do
    begin
        bb := pb^;
        asm
          rol bb,3
        end;
        pb^ := bb;
        inc(pb);
    end;

end;

procedure TsTMLogClass.DeCryption(buf:pointer; asize:integer);
var
    i               :integer;
    pb              :pbyte;
    bb              :byte;
begin
    pb := buf;
    for i := 1 to asize do
    begin
        bb := pb^;
        asm
          ror bb,3
        end;
        pb^ := bb;
        inc(pb);
    end;

end;

procedure TsTMLogClass.Clear();
begin
    DBStream.Position := 0;
    DBStream.Size := 0;

end;

procedure TsTMLogClass.gettostringlist(temp:TStrings);
var
    tempfile        :TMemoryStream;
begin

    tempfile := TMemoryStream.Create;
    try
        DBStream.Position := 0;
        tempfile.LoadFromStream(DBStream);
        EnCryption(tempfile.Memory, tempfile.Size);
        tempfile.Position := 0;
        temp.LoadFromStream(tempfile);
    finally
        tempfile.Free;
        DBStream.Position := DBStream.Size;
    end;
end;

procedure TsTMLogClass.add(astr:string);
var
    rtemp           :array[0..65535] of byte;
    rlen            :integer;
begin
    if astr = '' then exit;
    astr := datetimetostr(now()) + astr + #13#10;
    rlen := length(astr);
    if (rlen <= 0) or (rlen > 65535) then exit;

    copymemory(@rtemp, @astr[1], rlen);
    DeCryption(@rtemp, rlen);
    DBStream.WriteBuffer(rtemp, rlen);

end;

constructor TsTMLogClass.Create(afilename:string);
begin
    inherited Create;
    DBStream := nil;
    Ffilename := afilename;
    if FileExists(Ffilename) = false then
    begin
        DBStream := TFileStream.Create(Ffilename, fmCreate);

    end else
    begin
        DBStream := TFileStream.Create(Ffilename, fmOpenReadWrite);
        DBStream.Position := DBStream.Size;
    end;

end;

destructor TsTMLogClass.Destroy;
begin
    if DBStream <> nil then DBStream.Free;
    inherited destroy;
end;
///////////////////////////////////////////

constructor TsTMMoneyLogListClass.Create(afilename:string);
begin
    inherited Create;
    DBStream := nil;
    indexname := TStringKeyClass.Create;
    data := tlist.Create;

    Ffilename := afilename;
    if FileExists(Ffilename) = false then
    begin
        DBStream := TFileStream.Create(Ffilename, fmCreate);
        setsize;
    end else
    begin
        DBStream := TFileStream.Create(Ffilename, fmOpenReadWrite);
        DBStream.Position := DBStream.Size;
    end;
    LoadFromFile();

end;

destructor TsTMMoneyLogListClass.Destroy;
begin

    Clear;
    indexname.Free;
    data.Free;
    if DBStream <> nil then DBStream.Free;
    inherited destroy;
end;

procedure TsTMMoneyLogListClass.LoadFromFile();
var
    rlen, i         :integer;
    aitem           :Tmoneylistdata;
begin
    DBStream.Position := 0;
    DBStream.ReadBuffer(rlen, 4);
    for i := 0 to rlen - 1 do
    begin
        if DBStream.Size < (DBStream.Position + sizeof(Tmoneylistdata)) then
        begin
            tmlog.add('LoadFromFile error < size');
            setsize;
            exit;
        end;
        DBStream.ReadBuffer(aitem, sizeof(Tmoneylistdata));
        EnCryption(@aitem, sizeof(Tmoneylistdata));
        add(aitem, false);
    end;

end;

procedure TsTMMoneyLogListClass.save(pp:pTmoneylistdata);
var
    aitem           :Tmoneylistdata;
begin
    if pp.rpos = 0 then pp.rpos := DBStream.Size;
    DBStream.Position := pp.rpos;
    aitem := pp^;
    DeCryption(@aitem, sizeof(Tmoneylistdata));
    DBStream.WriteBuffer(aitem, sizeof(Tmoneylistdata));
    setsize;
end;

procedure TsTMMoneyLogListClass.Clear();
var
    pp              :pTmoneylistdata;
    i               :integer;
begin
    for i := 0 to data.Count - 1 do
    begin
        pp := data.Items[i];
        dispose(pp);

    end;
    data.Clear;
    indexname.Clear;
end;

procedure TsTMMoneyLogListClass.gameLoad(aname:string; amoney:integer);
var
    pp              :pTmoneylistdata;
    aitem           :Tmoneylistdata;
begin
    pp := get(aname);
    if pp = nil then
    begin
        aitem.rname := aname;
        aitem.rmoney := amoney;
        aitem.rtime := now();
        aitem.rpos := 0;
        add(aitem, true);
        exit;
    end;
    if pp.rname <> aname then
    begin
        tmlog.add('gameLoad error name !=');
        exit;
    end;
    if pp.rmoney <> amoney then
    begin
        tmlog.add(format('gameLoad error:%s,new:%d,(old:%d,%s)', [aname, amoney, pp.rmoney, datetimetostr(pp.rtime)]));
        pp.rmoney := amoney;
        pp.rtime := now();
        save(pp);
        exit;
    end;
end;

procedure TsTMMoneyLogListClass.gamesave(aname:string; amoney:integer);
var
    pp              :pTmoneylistdata;
    aitem           :Tmoneylistdata;
begin
    pp := get(aname);
    if pp = nil then
    begin
        tmlog.add('gamesave error not name');
        aitem.rname := aname;
        aitem.rmoney := amoney;
        aitem.rtime := now();
        aitem.rpos := 0;
        add(aitem, true);
        exit;
    end;
    if pp.rname <> aname then
    begin
        tmlog.add('gamesave error name !=');
        exit;
    end;
    if pp.rmoney <> amoney then
    begin
        pp.rmoney := amoney;
        pp.rtime := now();
        save(pp);
        exit;
    end;
end;

procedure TsTMMoneyLogListClass.setsize();
var
    i               :integer;
begin
    DBStream.Position := 0;
    i := data.Count;
    DBStream.WriteBuffer(i, 4);
end;

procedure TsTMMoneyLogListClass.EnCryption(buf:pointer; asize:integer);
var
    i               :integer;
    pb              :pbyte;
    bb              :byte;
begin
    pb := buf;
    for i := 1 to asize do
    begin
        bb := pb^;
        asm
          rol bb,2
        end;
        pb^ := bb;
        inc(pb);
    end;

end;

procedure TsTMMoneyLogListClass.DeCryption(buf:pointer; asize:integer);
var
    i               :integer;
    pb              :pbyte;
    bb              :byte;
begin
    pb := buf;
    for i := 1 to asize do
    begin
        bb := pb^;
        asm
          ror bb,2
        end;
        pb^ := bb;
        inc(pb);
    end;

end;

procedure TsTMMoneyLogListClass.add(aitem:Tmoneylistdata; aWritefile:boolean);
var
    pp              :pTmoneylistdata;
begin
    pp := get(aitem.rname);
    if pp <> nil then exit;
    new(pp);
    pp^ := aitem;
    data.Add(pp);
    indexname.Insert(pp.rname, pp);
    if aWritefile then save(pp);
end;
{
procedure TsTMMoneyLogListClass.del(aname:string);
var
   pp              :pTmoneylistdata;
   i               :integer;
begin
   if get(aname) = nil then exit;
   for i := 0 to data.Count - 1 do
   begin
       pp := data.Items[i];
       if pp.rname = aname then
       begin
           dispose(pp);
           data.Delete(i);
           indexname.Delete(aname);
           exit;
       end;
   end;

end;
}

function TsTMMoneyLogListClass.get(aname:string):pTmoneylistdata;
begin
    result := indexname.Select(aname);
end;

end.

