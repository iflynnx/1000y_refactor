unit uQuest;

interface

uses
    Windows, Sysutils, Classes, Deftype, uAnsTick, BasicObj, SvClass,
    SubUtil, uSkills, uLevelExp, uUser, aUtil32, uGramerid,                     //AnsUnit,
    FieldMsg, MapUnit, uKeyClass, uResponsion, DateUtils, UserSdb;
const
    MAX_Marriage_count = 30;
type
    {任务系统
    }

    TQuestregdata = record
        rid: integer;
        rtime: tdatetime;                                                       //记录 时间
        rInterval_time: integer;                                                //这个时间后 结束
        rCount: integer;
    end;
    pTQuestregdata = ^TQuestregdata;

    //注册任务 人
    TQuestReg = class
    private
        Fname: string;
        DataList: TList;
        procedure Clear;
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(aid, aInterval_time: integer; atimes: Tdatetime);
        function get(aid: integer): pTQuestregdata;
        function getcount(): integer;
        procedure LoadString(atext: string);

        procedure SaveString(var atext: string);
        property uName: string read Fname write Fname;

        procedure Update(CurTick: integer);
    end;
    TQuestReg_server_data = record
        vstr1: string[64];
        vnum: dword;
        vdate: tdatetime;
    end;
    PTQuestReg_server_data = ^TQuestReg_server_data;

    TQuestReg_server = class
    private
        FQReg_arr: array of TQuestReg_server_data;
        ftick: integer;

    public
        constructor Create(asize: integer = 1000);
        destructor Destroy; override;

        procedure LoadFromFile(aFileName: string);
        procedure SaveToFile(aFileName: string);
        function getData(aqid: integer; var aTEXT: string; var adate: tdatetime; var anum: integer): boolean;
        procedure setData(aqid: integer; aTEXT: string; anum: integer);

        procedure Update(CurTick: integer);
    end;

    //注册任务 所有
    TQuestReglist = class
    private
        DataNameKey: TStringKeyListClass;                                       //TQuestReg
        FDCurTick: integer;
        procedure Clear;

    public
        FQReg_server: TQuestReg_server;
        constructor Create;
        destructor Destroy; override;
        function getSubQuestcount(ausername: string): integer;
        function get(ausername: string): pointer;
        procedure add(ausername: string);

        function getSubQuest(ausername: string; aqid: integer): pTQuestregdata;
        procedure SubQuestRegAddCount(ausername: string; qID: integer);
        procedure setSubQuestReg(ausername: string; qID, atime: integer);

        procedure LoadFromFile(aFileName: string);
        procedure SaveToFile(aFileName: string);

        procedure Update(CurTick: integer);
    end;

    TQuestSub = class
    private
        FQuestSubNum: INTEGER;
        FQuestNum: INTEGER;
        FQuestSubTitle: string;
        FRequest: string;
        FRequest2: string;
        Ftext: string;
        fItemNameArr: array[0..10 - 1] of TNameString;
        fItemCountArr: array[0..10 - 1] of integer;
    public

    end;
    TQuestMain = class
    private
        FQuestNum: INTEGER;
        FQuestMainTitle: string;
        Ftext: string;
        fItemNameArr: array[0..10 - 1] of TNameString;
        fItemCountArr: array[0..10 - 1] of integer;
        DataQSubidKey: TIntegerKeyListClass;                                    //TQuestsub
        procedure Clear;
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(adata: TQuestSub);
        function getSub(aSubid: integer): pointer;
        procedure Update(CurTick: integer);
    end;

    TQuestMainList = class
    private
        DataQidKey: TIntegerKeyListClass;                                       //TQuestMain
        procedure Clear;
        function getQid(aqid: integer): pointer;
        function getQsubid(aqid, aqsubid: integer): pointer;
        procedure LoadFromFile(aFileName: string);
        procedure LoadSubFromFile(aFileName: string);
    public
        constructor Create;
        destructor Destroy; override;
        function getQuestalltext(aqid, aqsubid: integer; var aMainTitle, aSubTitle, aRequest, atext: string): boolean;
        function getQuestMain(aqid: integer; var aMainTitle, atext: string): boolean;
        function getQuestSub(aqid, aqsubid: integer; var aSubTitle, aRequest, atext: string): boolean;
        //脚本控制
        function getQuestMainTitle(aqid: integer): string;
        function getQuestMaintext(aqid: integer): string;
        function getQuestMainItem(aqid, akey: integer; var aname: string; var acount: integer): boolean;
        function getQuestSubItem(aqid, asubid, akey: integer; var aname: string; var acount: integer): boolean;

        function getQuestSubTitle(aqid, aqsubid: integer): string;
        function getQuestSubRequest(aqid, aqsubid: integer): string;
        function getQuestSubtext(aqid, aqsubid: integer): string;

        procedure userGetQuestList(uUser: tuser);

        procedure Update(CurTick: integer);
    end;
var
    Questreglist: TQuestreglist;
    QuestMainList: TQuestMainList;

implementation

//-----------------------------

constructor TQuestReg.Create;
begin
    DataList := TList.Create;
end;

destructor TQuestReg.Destroy;
begin
    Clear;
    DataList.Free;
    inherited destroy;
end;

procedure TQuestReg.Clear;
var
    i: integer;
    pp: pTQuestregdata;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        pp := (DataList.Items[i]);
        dispose(pp);
    end;
    DataList.Clear;
end;

procedure TQuestReg.Update(CurTick: integer);
var
    i: integer;
    pp: pTQuestregdata;
    tt: tdatetime;
begin
    tt := now();
    for i := 0 to DataList.Count - 1 do
    begin
        pp := (DataList.Items[i]);

        if MinutesBetween(tt, pp.rtime) > pp.rInterval_time then
        begin
            dispose(pp);
            DataList.Delete(i);
            exit;                                                               //1次 只清除1个
        end;
    end;

end;

function TQuestReg.getcount(): integer;
begin
    result := DataList.Count;
end;

function TQuestReg.get(aid: integer): pTQuestregdata;
var
    i: integer;
    pp: pTQuestregdata;
begin
    result := nil;
    for i := 0 to DataList.Count - 1 do
    begin
        pp := (DataList.Items[i]);
        if pp.rid = aid then
        begin
            result := pp;
            exit;
        end;
    end;
end;

procedure TQuestReg.add(aid, aInterval_time: integer; atimes: Tdatetime);
var
    pp: pTQuestregdata;
begin
    if get(aid) <> nil then exit;
    new(pp);
    pp.rid := aid;
    pp.rtime := atimes;
    pp.rInterval_time := aInterval_time;
    pp.rCount := 1;
    DataList.Add(pp);
end;

procedure TQuestReg.LoadString(atext: string);
var
    str, rdstr: string;
    aid, aInterval_time: integer;
    atime: Tdatetime;
begin
    Clear;
    str := atext;
    while str <> '' do
    begin
        str := GetValidStr3(str, rdstr, ':');
        aid := _StrToInt(rdstr);
        str := GetValidStr3(str, rdstr, ':');
        try
            atime := StrToFloat(rdstr);
        except
            atime := now();
        end;
        str := GetValidStr3(str, rdstr, ':');
        try
            aInterval_time := _strtoint(rdstr);
        except
            aInterval_time := 0;
        end;
        add(aid, aInterval_time, atime);
    end;

end;

procedure TQuestReg.SaveString(var atext: string);
var
    I: INTEGER;
    STR: string;
    pp: pTQuestregdata;
begin
    atext := '';

    for I := 0 to DataList.Count - 1 do
    begin
        PP := DataList.Items[I];
        STR := INTTOSTR(PP.rid) + ':';
        STR := STR + FloatToStr(PP.rtime) + ':';
        STR := STR + inttostr(PP.rInterval_time) + ':';
        atext := atext + STR;
    end;

end;
///////////////////////////////////////////////////////

constructor TQuestReglist.Create;
begin
    FDCurTick := 0;
    DataNameKey := TStringKeyListClass.Create;

    LoadFromFile('.\QuestNotice\Questreglist.SDB');
    FQReg_server := TQuestReg_server.Create;
end;

destructor TQuestReglist.Destroy;
begin
    FQReg_server.Free;
    SaveToFile('.\QuestNotice\Questreglist.SDB');
    Clear;

    DataNameKey.Free;
    inherited destroy;
end;

procedure TQuestReglist.Clear;
var
    i: integer;
    pp: TQuestreg;
begin
    for i := 0 to DataNameKey.Count - 1 do
    begin
        pp := DataNameKey.GetIndex(i);
        if pp <> nil then pp.Free;
    end;
    DataNameKey.Clear;
end;

procedure TQuestReglist.Update(CurTick: integer);
var
    i: integer;
    pp: TQuestreg;
begin
    FQReg_server.Update(CurTick);
    if GetItemLineTimeSec(CurTick - FDCurTick) < 60 then exit;                  //1分钟 执行 一次
    FDCurTick := CurTick;
    for i := 0 to DataNameKey.Count - 1 do
    begin
        pp := DataNameKey.GetIndex(i);
        if pp <> nil then pp.Update(CurTick);
    end;

end;

function TQuestReglist.getSubQuest(ausername: string; aqid: integer): pTQuestregdata;
var
    tp: TQuestreg;
begin
    result := nil;
    tp := get(ausername);
    if tp = nil then exit;
    result := tp.get(aqid);
end;

procedure TQuestReglist.SubQuestRegAddCount(ausername: string; qID: integer);
var
    tp: TQuestreg;
    p: pTQuestregdata;
begin
    tp := get(ausername);
    if tp = nil then exit;
    p := tp.get(qID);
    if p = nil then exit;
    p.rCount := p.rCount + 1;
end;

procedure TQuestReglist.setSubQuestReg(ausername: string; qID, atime: integer);
var
    tp: TQuestreg;
begin
    tp := get(ausername);
    if tp = nil then add(ausername);
    tp := get(ausername);
    if tp = nil then exit;
    tp.add(qid, atime, now());
end;

procedure TQuestReglist.add(ausername: string);
var
    tp: TQuestreg;
begin
    if get(ausername) <> nil then exit;
    tp := TQuestreg.Create;
    tp.Fname := ausername;
    if DataNameKey.Insert(tp.Fname, tp) = false then tp.Free;
end;

function TQuestReglist.get(ausername: string): pointer;
begin
    result := DataNameKey.Select(ausername);
end;

function TQuestReglist.getSubQuestcount(ausername: string): integer;
var
    tp: TQuestreg;
begin
    result := 0;
    tp := get(ausername);
    if tp = nil then exit;
    result := tp.getcount;
end;

procedure TQuestReglist.LoadFromFile(aFileName: string);
var
    i: integer;
    str, rdstr,
        aname, atext: string;
    StringList: TStringList;
    tp: TQuestreg;
begin
    Clear;
    if not FileExists(aFileName) then exit;

    StringList := TStringList.Create;
    try
        StringList.LoadFromFile(aFileName);

        for i := 1 to StringList.Count - 1 do
        begin

            str := StringList[i];
            str := GetValidStr3(str, rdstr, ',');
            aname := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            atext := rdstr;
            if DataNameKey.Select(aname) = nil then
            begin
                tp := TQuestreg.Create;
                tp.Fname := aname;
                tp.LoadString(atext);
                DataNameKey.Insert(tp.Fname, tp);
            end;
        end;
    finally
        StringList.Free;
    end;
end;

procedure TQuestReglist.SaveToFile(aFileName: string);
var
    i: integer;
    str, aname, atext: string;
    StringList: TStringList;
    pp: TQuestreg;
begin
    StringList := TStringList.Create;
    try
        str := 'uName,uText';
        StringList.add(str);
        for i := 0 to DataNameKey.Count - 1 do
        begin
            pp := DataNameKey.GetIndex(i);
            if pp = nil then Break;
            aname := pp.Fname;
            pp.SaveString(atext);
            str := aname + ',' + atext + ',';
            StringList.Add(str);
        end;
        StringList.SaveToFile(aFileName);
    finally
        StringList.Free;
    end;
end;
///////////////////////////////////////////////////////

constructor TQuestMainList.Create;
begin
    DataQidKey := TIntegerKeyListClass.Create;

    LoadFromFile('.\QuestNotice\Quest.sdb');
    LoadSubFromFile('.\QuestNotice\QuestSub.sdb');
end;

destructor TQuestMainList.Destroy;
begin

    Clear;

    DataQidKey.Free;
    inherited destroy;
end;

function TQuestMainList.getQuestMainTitle(aqid: integer): string;
var
    ttmain: TQuestMain;
begin
    result := '';
    ttmain := getQid(aqid);
    if ttmain = nil then exit;
    result := ttmain.FQuestMainTitle;
end;

procedure TQuestMainList.userGetQuestList(uUser: tuser);   //获取任务列表
var
    ttmain: TQuestMain;
    ttsub: TQuestMain;
    tempsend: TWordComData;
    qcount: integer;
    str: string;
    temp: TQuestsub;
begin
    qcount := 0;
    tempsend.Size := 0;
    WordComData_ADDbyte(tempsend, SM_Quest);
    WordComData_ADDbyte(tempsend, Quest_getList);
    ttmain := getQid(uUser.FCurrentQuestNo);
    ttsub := getQid(uUser.FSubCurrentQuestNo);
    if ttmain <> nil then inc(qcount);
    if ttsub <> nil then inc(qcount);

    WordComData_ADDbyte(tempsend, qcount);
    if ttmain <> nil then
    begin
        WordComData_ADDdword(tempsend, ttmain.FQuestNum);
        WordComData_ADDstring(tempsend, ttmain.FQuestMainTitle);
        WordComData_ADDstring(tempsend, ttmain.Ftext);

        temp := ttmain.getSub(uUser.FQueststep);
        if temp <> nil then
        begin
            WordComData_ADDstring(tempsend, temp.FQuestSubTitle);
            WordComData_ADDstring(tempsend, temp.Ftext);
            WordComData_ADDstring(tempsend, temp.FRequest);
            WordComData_ADDstring(tempsend, temp.FRequest2);
        end else
        begin
            str := '';
            WordComData_ADDstring(tempsend, str);
            WordComData_ADDstring(tempsend, str);
            WordComData_ADDstring(tempsend, str);
            WordComData_ADDstring(tempsend, str);
        end;
    end;
    if ttsub <> nil then
    begin
        WordComData_ADDdword(tempsend, ttsub.FQuestNum);
        WordComData_ADDstring(tempsend, ttsub.FQuestMainTitle);
        WordComData_ADDstring(tempsend, ttsub.Ftext);

        temp := ttsub.getSub(uUser.FSubQueststep);
        if temp <> nil then
        begin
            WordComData_ADDstring(tempsend, temp.FQuestSubTitle);
            WordComData_ADDstring(tempsend, temp.Ftext);
            WordComData_ADDstring(tempsend, temp.FRequest);
            WordComData_ADDstring(tempsend, temp.FRequest2);
        end else
        begin
            str := '';
            WordComData_ADDstring(tempsend, str);
            WordComData_ADDstring(tempsend, str);
            WordComData_ADDstring(tempsend, str);
            WordComData_ADDstring(tempsend, str);
        end;
    end;
    uUser.SendClass.SendData(tempsend);
end;

function TQuestMainList.getQuestSubItem(aqid, asubid, akey: integer; var aname: string; var acount: integer): boolean;
var
    ttmain: TQuestMain;
    pp: TQuestSub;
begin
    aname := '';
    acount := 0;
    result := false;
    ttmain := getQid(aqid);
    if ttmain = nil then exit;

    pp := ttmain.getSub(asubid);
    if pp = nil then exit;
    if (akey < 0) or (akey > high(pp.fItemNameArr)) then exit;
    aname := pp.fItemNameArr[akey];
    acount := pp.fItemcountArr[akey];
    result := true;
end;

function TQuestMainList.getQuestMainItem(aqid, akey: integer; var aname: string; var acount: integer): boolean;
var
    ttmain: TQuestMain;
begin
    aname := '';
    acount := 0;
    result := false;
    ttmain := getQid(aqid);
    if ttmain = nil then exit;
    if (akey < 0) or (akey > high(ttmain.fItemNameArr)) then exit;
    aname := ttmain.fItemNameArr[akey];
    acount := ttmain.fItemcountArr[akey];
    result := true;
end;

function TQuestMainList.getQuestMaintext(aqid: integer): string;
var
    ttmain: TQuestMain;
begin
    result := '';
    ttmain := getQid(aqid);
    if ttmain = nil then exit;
    result := ttmain.Ftext;
end;

function TQuestMainList.getQuestMain(aqid: integer; var aMainTitle, atext: string): boolean;
var

    ttmain: TQuestMain;
begin
    result := false;
    ttmain := getQid(aqid);
    if ttmain = nil then exit;
    aMainTitle := ttmain.FQuestMainTitle;
    atext := ttmain.Ftext;
    result := true;
end;

function TQuestMainList.getQuestSubTitle(aqid, aqsubid: integer): string;
var
    ttsub: TQuestSub;
begin
    result := '';
    ttsub := getQsubid(aqid, aqsubid);
    if ttsub = nil then exit;
    result := ttsub.FQuestSubTitle;

end;

function TQuestMainList.getQuestSubRequest(aqid, aqsubid: integer): string;
var
    ttsub: TQuestSub;
begin
    result := '';
    ttsub := getQsubid(aqid, aqsubid);
    if ttsub = nil then exit;
    result := ttsub.FRequest;

end;

function TQuestMainList.getQuestSubtext(aqid, aqsubid: integer): string;
var
    ttsub: TQuestSub;
begin
    result := '';
    ttsub := getQsubid(aqid, aqsubid);
    if ttsub = nil then exit;
    result := ttsub.Ftext;

end;

function TQuestMainList.getQuestSub(aqid, aqsubid: integer; var aSubTitle, aRequest, atext: string): boolean;
var
    ttsub: TQuestSub;
begin
    result := false;
    ttsub := getQsubid(aqid, aqsubid);
    if ttsub = nil then exit;
    aSubTitle := ttsub.FQuestSubTitle;
    atext := ttsub.Ftext;
    aRequest := ttsub.FRequest;
    result := true;
end;

function TQuestMainList.getQuestalltext(aqid, aqsubid: integer; var aMainTitle, aSubTitle, aRequest, atext: string): boolean;
var
    ttsub: TQuestSub;
    ttmain: TQuestMain;
begin
    result := false;
    ttmain := getQid(aqid);
    if ttmain = nil then exit;
    aMainTitle := ttmain.FQuestMainTitle;
    ttsub := getQsubid(aqid, aqsubid);
    if ttsub = nil then exit;
    aSubTitle := ttsub.FQuestSubTitle;
    atext := ttsub.Ftext;
    aRequest := ttsub.FRequest;
    result := true;
end;

procedure TQuestMainList.Clear;
var
    i: integer;
    pp: TQuestMain;
begin
    for i := 0 to DataQidKey.Count - 1 do
    begin
        pp := DataQidKey.GetIndex(i);
        if pp <> nil then pp.Free;
    end;
    DataQidKey.Clear;
end;

procedure TQuestMainList.Update(CurTick: integer);

begin

end;

function TQuestMainList.getQsubid(aqid, aqsubid: integer): pointer;
var
    tt: TQuestMain;
begin
    result := nil;
    tt := getQid(aqid);
    if tt = nil then exit;
    result := tt.getSub(aqsubid);
end;

function TQuestMainList.getQid(aqid: integer): pointer;
begin
    result := DataQidKey.Select(aqid);
end;

procedure TQuestMainList.LoadFromFile(aFileName: string);
var
    i, j: integer;
    tp: TQuestMain;
    filesdb: TUserStringDb;
    str, iName, itemname, itemcount: string;

    aqid: integer;
    aqTitle, aqtext: string;
begin
//QuestNum,QuestMainTitle,text,任务,备注,item0,item1,item2,item3,item4,item5,item6,item7,item8,item9,
    if not FileExists(aFileName) then exit;
    Clear;
    filesdb := TUserStringDb.Create;
    try
        filesdb.LoadFromFile(aFileName);
        for i := 0 to filesdb.Count - 1 do
        begin
            iName := filesdb.GetIndexName(i);

            aqid := filesdb.GetFieldValueInteger(iName, 'QuestNum');
            aqTitle := filesdb.GetFieldValueString(iName, 'QuestMainTitle');
            aqtext := filesdb.GetFieldValueString(iName, 'text');

            if aqid <= 0 then Continue;
            if DataQidKey.Select(aqid) = nil then
            begin
                tp := TQuestMain.Create;
                tp.FQuestNum := aqid;
                tp.FQuestMainTitle := aqTitle;
                tp.Ftext := aqtext;
                for j := 0 to high(tp.fItemNameArr) do
                begin
                    str := filesdb.GetFieldValueString(iName, 'item' + inttostr(j));
                    if str <> '' then
                    begin
                        str := GetValidStr3(str, itemname, ':');
                        str := GetValidStr3(str, itemcount, ':');
                        tp.fItemNameArr[j] := copy(itemname, 1, 20);
                        tp.fItemCountArr[j] := _StrToInt(itemcount);
                    end;
                end;
                if DataQidKey.Insert(tp.FQuestNum, tp) = false then tp.Free;
            end;

        end;

    finally
        filesdb.Free;
    end;


end;
{var
    i, aqid: integer;
    str, rdstr,
        aqTitle, aqtext: string;

    StringList: TStringList;
    tp: TQuestMain;
begin
    //QuestNum,QuestMainTitle,text,
    Clear;
    if not FileExists(aFileName) then exit;

    StringList := TStringList.Create;
    try
        StringList.LoadFromFile(aFileName);

        for i := 1 to StringList.Count - 1 do
        begin

            str := StringList[i];
            str := GetValidStr3(str, rdstr, ',');
            aqid := _strtoint(rdstr);

            str := GetValidStr3(str, rdstr, ',');
            aqTitle := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            aqtext := rdstr;
            if aqid <= 0 then Continue;
            if DataQidKey.Select(aqid) = nil then
            begin
                tp := TQuestMain.Create;
                tp.FQuestNum := aqid;
                tp.FQuestMainTitle := aqTitle;
                tp.Ftext := aqtext;
                if DataQidKey.Insert(tp.FQuestNum, tp) = false then tp.Free;
            end;
        end;
    finally
        StringList.Free;
    end;
end;
}

procedure TQuestMainList.LoadSubFromFile(aFileName: string);
var
    i, j                                                                        //, aQuestSubNum, aQuestNum
        : integer;
    str, rdstr
        //aQuestSubTitle, aRequest, atext, aRequest2
    : string;
    tp: TQuestMain;
    filesdb: TUserStringDb;
    iName, itemname, itemcount: string;
    aQuestSub: TQuestSub;
begin
    //QuestSubNum,QuestNum,QuestSubTitle,text,Request,request2,item0,item1,item2,item3,item4,item5,item6,item7,item8,item9,
    if not FileExists(aFileName) then exit;

    filesdb := TUserStringDb.Create;
    aQuestSub := TQuestSub.Create;
    try
        filesdb.LoadFromFile(aFileName);
        for i := 0 to filesdb.Count - 1 do
        begin
            iName := filesdb.GetIndexName(i);

            aQuestSub.fQuestNum := filesdb.GetFieldValueInteger(iName, 'QuestNum');
            if aQuestSub.fQuestNum <= 0 then Continue;
            tp := DataQidKey.Select(aQuestSub.fQuestNum);
            if tp <> nil then
            begin
                fillchar(aQuestSub.fItemNameArr, sizeof(aQuestSub.fItemNameArr), 0);
                fillchar(aQuestSub.fItemCountArr, sizeof(aQuestSub.fItemCountArr), 0);

                aQuestSub.fQuestSubNum := filesdb.GetFieldValueInteger(iName, 'QuestSubNum');
                aQuestSub.fQuestSubTitle := filesdb.GetFieldValueString(iName, 'QuestSubTitle');
                aQuestSub.ftext := filesdb.GetFieldValueString(iName, 'text');
                aQuestSub.fRequest := filesdb.GetFieldValueString(iName, 'Request');
                aQuestSub.fRequest2 := filesdb.GetFieldValueString(iName, 'request2');
                for j := 0 to high(aQuestSub.fItemNameArr) do
                begin
                    str := filesdb.GetFieldValueString(iName, 'item' + inttostr(j));
                    if str = '' then Break;

                    str := GetValidStr3(str, itemname, ':');
                    str := GetValidStr3(str, itemcount, ':');
                    aQuestSub.fItemNameArr[j] := copy(itemname, 1, 20);
                    aQuestSub.fItemCountArr[j] := _StrToInt(itemcount);

                end;
                tp.add(aQuestSub);
            end;
        end;
    finally
        aQuestSub.free;
        filesdb.Free;
    end;
end;
{var
    i, aQuestSubNum, aQuestNum: integer;
    str, rdstr,
        aQuestSubTitle, aRequest, atext, aRequest2: string;

    StringList: TStringList;
    tp: TQuestMain;
begin
    //QuestSubNum,QuestNum,QuestSubTitle,Request,text,
    if not FileExists(aFileName) then exit;

    StringList := TStringList.Create;
    try
        StringList.LoadFromFile(aFileName);

        for i := 1 to StringList.Count - 1 do
        begin

            str := StringList[i];
            str := GetValidStr3(str, rdstr, ',');
            aQuestSubNum := _strtoint(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            aQuestNum := _strtoint(rdstr);

            str := GetValidStr3(str, rdstr, ',');
            aQuestSubTitle := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            aRequest := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            atext := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            aRequest2 := rdstr;
            if aQuestNum <= 0 then Continue;
            tp := DataQidKey.Select(aQuestNum);
            if tp <> nil then
                tp.add(aQuestNum, aQuestSubNum, aQuestSubTitle, aRequest, aRequest2, atext);
        end;
    finally
        StringList.Free;
    end;
end;}
////////////////////////////

procedure TQuestMain.Clear;
var
    i: integer;
    pp: TQuestSub;
begin
    for i := 0 to DataQSubidKey.Count - 1 do
    begin
        pp := DataQSubidKey.GetIndex(i);
        if pp <> nil then pp.Free;
    end;
    DataQSubidKey.Clear;
end;

constructor TQuestMain.Create;
begin

    inherited Create;
    DataQSubidKey := TIntegerKeyListClass.Create;                               //TQuestsub

    fillchar(fItemNameArr, sizeof(fItemNameArr), 0);
    fillchar(fItemCountArr, sizeof(fItemCountArr), 0);

end;

destructor TQuestMain.Destroy;
begin
    Clear;
    DataQSubidKey.Free;
    inherited destroy;
end;

procedure TQuestMain.add(adata: TQuestSub);
var
    pp: TQuestSub;
begin
    if adata = nil then exit;
    if getSub(adata.FQuestSubNum) <> nil then exit;
    pp := TQuestSub.Create;
    pp.FQuestSubNum := adata.FQuestSubNum;
    pp.FQuestNum := adata.FQuestNum;
    pp.FQuestSubTitle := adata.FQuestSubTitle;
    pp.FRequest := adata.FRequest;
    pp.FRequest2 := adata.FRequest2;
    pp.Ftext := adata.Ftext;
    move(adata.fItemNameArr, pp.fItemNameArr, sizeof(pp.fItemNameArr));
    move(adata.fItemCountArr, pp.fItemCountArr, sizeof(pp.fItemCountArr));

    if DataQSubidKey.Insert(adata.FQuestSubNum, pp) = false then pp.Free;
end;

function TQuestMain.getSub(aSubid: integer): pointer;
begin
    result := DataQSubidKey.Select(aSubid);
end;

procedure TQuestMain.Update(CurTick: integer);
begin

end;

{ TQuestReg_server }

constructor TQuestReg_server.Create(asize: integer);
begin

    ftick := 0;
    setlength(FQReg_arr, asize);
    fillchar(FQReg_arr[0], (high(FQReg_arr) + 1) * sizeof(TQuestReg_server_data), 0);
    LoadFromFile('.\QuestNotice\QuestReg_server.sdb');
end;

destructor TQuestReg_server.Destroy;
begin
    SaveToFile('.\QuestNotice\QuestReg_server.sdb');

end;

function TQuestReg_server.getdata(aqid: integer; var aTEXT: string;
    var adate: tdatetime; var anum: integer): boolean;
begin
    result := false;
    if (aqid < 0) or (aqid > high(FQReg_arr)) then exit;
    aTEXT := FQReg_arr[aqid].vstr1;
    adate := FQReg_arr[aqid].vdate;
    anum := FQReg_arr[aqid].vnum;
    result := true;
end;

procedure TQuestReg_server.LoadFromFile(aFileName: string);
var
    i, j: integer;
    iname: string;
    FDBfile: TUserStringDb;
begin
    if not FileExists(aFileName) then exit;                                     //文件不存在
    FDBfile := TUserStringDb.Create;
    try
        FDBfile.LoadFromFile(aFileName);
        for i := 0 to FDBfile.Count - 1 do
        begin
            iname := FDBfile.GetIndexName(i);
            j := StrToInt(iname);
            if (j < 0) or (j > high(FQReg_arr)) then continue;
            FQReg_arr[j].vnum := FDBfile.GetFieldValueInteger(iname, 'num');
            FQReg_arr[j].vstr1 := FDBfile.GetFieldValueString(iname, 'text');
            FQReg_arr[j].vdate := StrToDateTime(FDBfile.GetFieldValueString(iname, 'datetime'));
        end;
    finally
        FDBfile.Free;
    end;
end;

procedure TQuestReg_server.SaveToFile(aFileName: string);
var
    i: integer;
    str: string;
    temp: TStringList;
begin
    temp := TStringList.Create;
    try
        temp.Add('id,num,text,datetime,');
        for i := 0 to high(FQReg_arr) do
        begin
            if FQReg_arr[i].vnum = 0 then Continue;
            str := StringReplace(FQReg_arr[i].vstr1, ',', '?', [rfReplaceAll]);
            str := inttostr(i) + ','
                + inttostr(FQReg_arr[i].vnum) + ','
                + str + ','
                + DateTimeToStr(FQReg_arr[i].vdate) + ','
                ;
            temp.Add(str);
        end;
        temp.SaveToFile(aFileName);

    finally
        temp.free;
    end;
end;

procedure TQuestReg_server.setdata(aqid: integer; aTEXT: string; anum: integer);
begin
    if (aqid < 0) or (aqid > high(FQReg_arr)) then exit;
    FQReg_arr[aqid].vstr1 := copy(aTEXT, 1, 64);
    FQReg_arr[aqid].vdate := Now;
    FQReg_arr[aqid].vnum := anum;
end;

procedure TQuestReg_server.Update(CurTick: integer);
begin
    if GetItemLineTimeSec(CurTick - ftick) < 10 * 60 then exit;                 //1分钟 执行 一次
    ftick := CurTick;
    SaveToFile('.\QuestNotice\QuestReg_server.sdb');
end;

initialization
    begin
        Questreglist := TQuestreglist.Create;
        QuestMainList := TQuestMainList.Create;
    end;

finalization
    begin
        Questreglist.Free;
        QuestMainList.Free;
    end;

end.

