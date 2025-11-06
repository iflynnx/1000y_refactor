unit uDBFile;

interface
uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
    uKeyClass, deftype;
type

    TDbHeadFile = record
        rVer: string[64];
        rNewCount: integer;
        rUseCount: integer;
        rMaxCount: integer;
        rSize: integer;
    end;
    pTDbHeadFile = ^TDbHeadFile;
    TDBModuleType = (dmtNone, dmtUser, dmtTemp);

    TDBHeadModule = record
        rname: string[64];
        rtime: tdatetime;
        rid: Integer;
        rstate: TDBModuleType;
    end;
    pTDBHeadModule = ^TDBHeadModule;

    TBasicDbFileClass = class
    private
        FHEAD: TDbHeadFile;
        FStream: TFileStream;
        Ffilename: string;
        function Read(abuf: pointer; asize: integer): boolean;
        function Write(abuf: pointer; asize: integer): boolean;
        function SetPositionHead(apos: integer): boolean;
        function SetPositionBuf(apos: integer): boolean;
        function createFile(afilename: string): boolean;

        procedure LoadFileHead(aHead: TDbHeadFile);
        procedure addSize();
        procedure HeadFileUPdate();

        function GetUseCount: integer;
        function GetMaxCount: integer;
        procedure PutUseCount(Value: integer);
        procedure WriteLog(aStr: string);
    public
        constructor Create(aHead: TDbHeadFile; afilename: string);
        destructor Destroy; override;

        function ReadHeadModule(aid: integer; var aheadModule: TDBHeadModule): boolean;
        function WriteHeadModule(aid: integer; var aheadModule: TDBHeadModule): boolean;
        function ReadBufModule(aid: integer; abuf: pointer; asize: integer): boolean;
        function WriteBufModule(aid: integer; abuf: pointer; asize: integer): boolean;

        function ReadModule(aid: integer; var aheadModule: TDBHeadModule; abuf: pointer; asize: integer): boolean;
        function WriteModule(aid: integer; var aheadModule: TDBHeadModule; abuf: pointer; asize: integer): boolean;

        property UseCount: integer read GetUseCount write PutUseCount;
        property MaxCount: integer read GetMaxCount;
    end;

    //使用 空间列表
    TUseDataListclass = class
    private
        fdata: tlist;                                                           //TDBHeadModule
        findexname: TStringKeyClass;
        procedure Clear;
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(aitem: TDBHeadModule);
        procedure del(aid: integer);
        procedure delname(aname: string);
        function get(aname: string): pTDBHeadModule;
        function getAllNameList(): string;
        function getIndex(aname: string): pTDBHeadModule;

    end;
    //可用 空间 列表
    TEmptyData = record
        rtime: tdatetime;
        rid: Integer;
    end;
    pTEmptyData = ^TEmptyData;
    TEmptyListclass = class
    private
        fdata: tlist;                                                           //TEmptyData
        procedure Clear;
    public
        constructor Create;
        destructor Destroy; override;

        procedure add(aid: integer);
        procedure del(aid: integer);
        function GET(aid: integer): pTEmptyData;
        function GETEmpty(): pTEmptyData;
    end;

    TDbFileClass = class
    private
        dbfile: TBasicDbFileClass;
        FUseDataList: TUseDataListclass;
        FemptyList: TEmptyListclass;
        procedure Emptycheck();
        procedure LoadFile;

        function Read(aindexname: string; abuf: pointer; asize: integer): boolean;
        function Write(aindexname: string; abuf: pointer; asize: integer): boolean;
    public
        constructor Create(aHead: TDbHeadFile; afilename: string);
        destructor Destroy; override;

        function Update(aIndexName: string; abuf: pointer; asize: integer): Byte;
        function Select(aIndexName: string; abuf: pointer; asize: integer): Byte;
        function Insert(aIndexName: string; abuf: pointer; asize: integer): Byte;
        function DELETE(aindexname: string): byte;

        function IsData(aindexname: string): boolean;
        function getAllNameList: string;
        function count: integer;
    end;

implementation

{ TBasicDbFileClass }

constructor TBasicDbFileClass.Create(aHead: TDbHeadFile;
    afilename: string);
begin

    if aHead.rNewCount <= 0 then aHead.rNewCount := 100;

    FStream := nil;
    Ffilename := afilename;
    if FileExists(Ffilename) = FALSE then
    begin
        FHEAD := aHead;
        FHEAD.rUseCount := 0;
        FHEAD.rMaxCount := 0;
        createFile(afilename);
    end else
    begin
        FStream := TFileStream.Create(afilename, fmOpenReadWrite);
    end;
    LoadFileHead(aHead);

end;

function TBasicDbFileClass.createFile(afilename: string): boolean;
begin
    result := false;
    FStream := TFileStream.Create(afilename, fmCreate);
    if FStream = nil then
    begin
        WriteLog('TBasicDbFileClass.createFile 创建文件流失败');
        exit;
    end;
    HeadFileUPdate;
    addSize;
    result := true;
end;

destructor TBasicDbFileClass.Destroy;
begin
    if FStream <> nil then FStream.Free;
    inherited;
end;

procedure TBasicDbFileClass.LoadFileHead(aHead: TDbHeadFile);
begin
    if FStream = nil then exit;
    if FStream.Size < sizeof(FHEAD) then exit;
    FStream.Position := 0;
    FStream.ReadBuffer(FHEAD, sizeof(FHEAD));

    if (aHead.rVer = FHEAD.rVer)
        and (aHead.rSize = FHEAD.rSize)
        and (FHEAD.rUseCount <= FHEAD.rMaxCount) then
    begin
        WriteLog('正常打开文件[使用数量]' + inttostr(FHEAD.rUseCount) + '[空间数量]' + inttostr(FHEAD.rMaxCount));
        exit;
    end;
    FStream.Free;
    FStream := nil;
    if aHead.rVer <> FHEAD.rVer then
        WriteLog('版本错误' + '[文件]' + FHEAD.rVer + '[应该]' + aHead.rVer);

    if aHead.rSize <> FHEAD.rSize then
        WriteLog('数据块大小错误' + '[文件]' + inttostr(fHead.rSize) + '[应该]' + inttostr(aHead.rSize));

    if FHEAD.rUseCount > FHEAD.rMaxCount then
        WriteLog('使用数量超界' + '[使用数量]' + inttostr(fHead.rUseCount) + '[空间数量]' + inttostr(aHead.rMaxCount));
end;
////////////////////////////////////////////////////////////
//                    扩展容量

procedure TBasicDbFileClass.addSize;
begin
    if FHEAD.rNewCount <= 0 then exit;
    if FStream = nil then exit;
    FHEAD.rMaxCount := FHEAD.rMaxCount + FHEAD.rNewCount;
    FStream.Size := FHEAD.rMaxCount * FHEAD.rSize + sizeof(FHEAD);
    HeadFileUPdate;
end;
////////////////////////////////////////////////////////////
//                    读文件

function TBasicDbFileClass.Read(abuf: pointer; asize: integer): boolean;
begin
    result := false;
    if FStream = nil then exit;
    try
        FStream.ReadBuffer(abuf^, asize);
        result := true;
    except
        WriteLog('TBasicDbFileClass.Read 失败');
    end;

end;

function TBasicDbFileClass.ReadBufModule(aid: integer; abuf: pointer; asize: integer): boolean;
begin
    result := false;
    if SetPositionBuf(aid) = false then exit;
    result := Read(abuf, asize);
end;

function TBasicDbFileClass.ReadHeadModule(aid: integer; var aheadModule: TDBHeadModule): boolean;
begin
    result := false;
    if SetPositionHead(aid) = false then exit;
    result := Read(@aheadModule, sizeof(TDBHeadModule));
end;

function TBasicDbFileClass.ReadModule(aid: integer; var aheadModule: TDBHeadModule; abuf: pointer; asize: integer): boolean;
begin
    result := ReadHeadModule(aid, aheadModule);
    if result then result := ReadBufModule(aid, abuf, asize);
end;
////////////////////////////////////////////////////////////
//                    设置文件指针

function TBasicDbFileClass.SetPositionHead(apos: integer): boolean;
begin
    result := false;
    if FStream = nil then exit;
    if FStream.Size < FHEAD.rSize * apos + sizeof(FHEAD) then exit;
    FStream.Position := FHEAD.rSize * apos + sizeof(FHEAD);
    result := true;
end;

function TBasicDbFileClass.SetPositionBuf(apos: integer): boolean;
begin
    result := false;
    if FStream = nil then exit;
    if FStream.Size < FHEAD.rSize * apos + sizeof(FHEAD) + sizeof(TDBHeadModule) then exit;
    FStream.Position := FHEAD.rSize * apos + sizeof(FHEAD) + +sizeof(TDBHeadModule);
    result := true;
end;

////////////////////////////////////////////////////////////
//                    写文件

function TBasicDbFileClass.Write(abuf: pointer; asize: integer): boolean;
begin
    result := false;
    if FStream = nil then exit;
    try
        FStream.WriteBuffer(abuf^, asize);
        result := true;
    except
        WriteLog('TBasicDbFileClass.Read 失败');
    end;
end;

function TBasicDbFileClass.WriteBufModule(aid: integer; abuf: pointer; asize: integer): boolean;
begin
    result := false;
    if SetPositionBuf(aid) = false then exit;
    result := Write(abuf, asize);
end;

function TBasicDbFileClass.WriteHeadModule(aid: integer; var aheadModule: TDBHeadModule): boolean;
begin
    result := false;
    if SetPositionHead(aid) = false then exit;
    result := Write(@aheadModule, sizeof(TDBHeadModule));
end;

procedure TBasicDbFileClass.WriteLog(aStr: string);
var
    Stream: TFileStream;
    FileName: string;
begin
    try
        FileName := '.\Log\' + 'dbfile.Log';
        if FileExists(FileName) then
        begin
            Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        end else
        begin
            Stream := TFileStream.Create(FileName, fmCreate);
        end;
        aStr := '[' + datetimetostr(now()) + ',' + Ffilename + ']' + aStr + #13 + #10;
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aStr[1], length(aStr));
        Stream.Free;
    except
    end;
end;

function TBasicDbFileClass.WriteModule(aid: integer; var aheadModule: TDBHeadModule; abuf: pointer; asize: integer): boolean;
begin
    result := WriteHeadModule(aid, aheadModule);
    if result then
        result := WriteBufModule(aid, abuf, asize);
end;

procedure TBasicDbFileClass.HeadFileUPdate;
begin
    if FStream = nil then exit;
    try
        FStream.Position := 0;
        FStream.WriteBuffer(FHEAD, sizeof(FHEAD));
    except
        WriteLog('TBasicDbFileClass.HeadFileUPdate 失败');
    end;
end;

function TBasicDbFileClass.GetUseCount: integer;
begin
    result := FHEAD.rUseCount;
end;

procedure TBasicDbFileClass.PutUseCount(Value: integer);
begin
    FHEAD.rUseCount := Value;
    HeadFileUPdate;
end;

function TBasicDbFileClass.GetMaxCount: integer;
begin
    result := FHEAD.rMaxCount;
end;

{ THeadModuleListclass }

procedure TUseDataListclass.add(aitem: TDBHeadModule);
var
    p: pTDBHeadModule;
begin
    if get(aitem.rname) <> nil then exit;
    new(p);
    p^ := aitem;
    fdata.Add(p);
    findexname.insert(p.rname, p);
end;

procedure TUseDataListclass.Clear;
var
    i: integer;
    p: pTDBHeadModule;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        dispose(p);
    end;
    fdata.Clear;
    findexname.Clear;
end;

constructor TUseDataListclass.Create;
begin
    fdata := TList.Create;
    findexname := TStringKeyClass.Create;
end;

procedure TUseDataListclass.del(aid: integer);
var
    i: integer;
    p: pTDBHeadModule;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rid = aid then
        begin
            fdata.Delete(i);
            findexname.Delete(p.rname);
            dispose(p);
            exit;
        end;
    end;
end;

procedure TUseDataListclass.delname(aname: string);
var
    i: integer;
    p: pTDBHeadModule;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname = aname then
        begin
            fdata.Delete(i);
            findexname.Delete(p.rname);
            dispose(p);
            exit;
        end;
    end;
end;

destructor TUseDataListclass.Destroy;
begin
    Clear;
    fdata.Free;
    findexname.Free;
    inherited;
end;

function TUseDataListclass.getAllNameList(): string;
var
    i: integer;
    p: pTDBHeadModule;
begin
    result := '';
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        result := result + p.rname + #13#10;
    end;
end;

function TUseDataListclass.get(aname: string): pTDBHeadModule;
var
    i: integer;
    p: pTDBHeadModule;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname = aname then
        begin
            result := p;
            exit;
        end;
    end;
end;

function TUseDataListclass.getIndex(aname: string): pTDBHeadModule;
begin
    result := findexname.select(aname);
end;

{ TEmptyListclass }

procedure TEmptyListclass.add(aid: integer);
var
    p: pTEmptyData;
begin
    if GET(aid) <> nil then exit;
    new(p);
    p.rtime := now();
    p.rid := aid;
    fdata.Add(p);
end;

procedure TEmptyListclass.Clear;
var
    p: pTEmptyData;
    i: integer;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        dispose(p);
    end;

    fdata.Clear;

end;

constructor TEmptyListclass.Create;
begin
    fdata := tlist.Create;
end;

procedure TEmptyListclass.del(aid: integer);
var
    p: pTEmptyData;
    i: integer;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rid = aid then
        begin
            fdata.Delete(i);
            dispose(p);
            exit;
        end;
    end;

end;

destructor TEmptyListclass.Destroy;
begin
    Clear;
    fdata.Free;
    inherited;
end;

function TEmptyListclass.GET(aid: integer): pTEmptyData;
var
    p: pTEmptyData;
    i: integer;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rid = aid then
        begin
            result := p;
            exit;
        end;
    end;

end;

function TEmptyListclass.GETEmpty: pTEmptyData;
var
    p: pTEmptyData;
    i: integer;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        result := p;
        exit;
    end;

end;
{ TDbFileClass }

function TDbFileClass.Read(aindexname: string; abuf: pointer;
    asize: integer): boolean;
var
    p: pTDBHeadModule;
begin
    result := false;
    p := FUseDataList.get(aindexname);
    if p = nil then exit;
    dbfile.ReadBufModule(p.rid, abuf, asize);
    result := true;
end;
//保持 空白 空间 至少1个

procedure TDbFileClass.Emptycheck();
var
    aheadModule: TDBHeadModule;
begin
    if FemptyList.fdata.Count <= 0 then
    begin
        if dbfile.UseCount >= dbfile.MaxCount then
        begin
            dbfile.addSize;
        end;
        if dbfile.UseCount >= dbfile.MaxCount then exit;
        //写 空白
        aheadModule.rid := dbfile.UseCount;
        aheadModule.rname := '';
        aheadModule.rstate := dmtNone;
        aheadModule.rtime := now();
        dbfile.WriteHeadModule(aheadModule.rid, aheadModule);
        dbfile.UseCount := dbfile.UseCount + 1;
        FemptyList.add(aheadModule.rid);
    end;
end;

function TDbFileClass.DELETE(aindexname: string): byte;
var
    p: pTDBHeadModule;
begin
    result := DB_ERR;
    p := FUseDataList.get(aindexname);
    if p = nil then
    begin
        result := DB_ERR_NOTFOUND;                                              //不存在
        exit;
    end;
    p.rtime := now();
    p.rstate := dmtNone;
    dbfile.WriteHeadModule(p.rid, p^);
    FemptyList.add(p.rid);                                                      //增加 （回收 空间）
    FUseDataList.del(p.rid);                                                    //删除（使用列表）

    result := DB_Ok;
end;

function TDbFileClass.Write(aindexname: string; abuf: pointer;
    asize: integer): boolean;
{var
    p               :pTDBHeadModule;
    TEMP            :TDBHeadModule;
    Pempty          :pTEmptyData;
begin
    result := false;

    //////////////////////////////////////
    //             写入新段
    Emptycheck;
    Pempty := FemptyList.GETEmpty;
    if Pempty = nil then
    begin
        //错误  没空间
        exit;
    end;

    p := FUseDataList.get(aindexname);
    if p <> nil then
    begin
        dbfile.WriteModule(p.rid, p^, abuf, asize);
    end else
    begin
        TEMP.rname := copy(aindexname, 1, 64);
        TEMP.rstate := dmtUser;
        temp.rid := Pempty.rid;
        temp.rtime := now();
        dbfile.WriteModule(temp.rid, temp, abuf, asize);
        FemptyList.del(Pempty.rid);
        FUseDataList.add(temp);
    end;
    result := true;
end;
}
var
    p: pTDBHeadModule;
    TEMP: TDBHeadModule;
    Pempty: pTEmptyData;
begin
    result := false;

    //////////////////////////////////////
    //             写入新段
    Emptycheck;
    Pempty := FemptyList.GETEmpty;
    if Pempty = nil then
    begin
        dbfile.WriteLog('TDbFileClass.Write 错误 没有空余空间；' + aindexname);
        exit;
    end;
    TEMP.rname := copy(aindexname, 1, 64);
    TEMP.rstate := dmtTemp;
    temp.rid := Pempty.rid;
    temp.rtime := now();
    if dbfile.WriteModule(temp.rid, temp, abuf, asize) = false then
    begin
        dbfile.WriteLog('TDbFileClass.Write;新段 写入错误' + #13#10
            + '{1}，ID' + inttostr(temp.rid) + #13#10
            + '{2}，关键字' + temp.rname + #13#10
            + '{3}，时间' + datetimetostr(temp.rtime) + #13#10
            + '{4}，状态' + INTTOSTR(INTEGER(temp.rstate))
            );
        exit;
    end;
    //////////////////////////////////////
    //             修改新状态
    TEMP.rstate := dmtUser;
    temp.rtime := now();
    if dbfile.WriteHeadModule(temp.rid, temp) = false then
    begin

        dbfile.WriteLog('TDbFileClass.Write;新段 改状态错误' + #13#10
            + '{1}，ID' + inttostr(temp.rid) + #13#10
            + '{2}，关键字' + temp.rname + #13#10
            + '{3}，时间' + datetimetostr(temp.rtime) + #13#10
            + '{4}，状态' + INTTOSTR(INTEGER(temp.rstate))
            );
        exit;
    end;
    FemptyList.del(Pempty.rid);                                                 //
    //////////////////////////////////////
    //             维护使用列表和空间列表
    p := FUseDataList.get(aindexname);
    if p <> nil then
    begin                                                                       //存在 修改
        p.rtime := now();
        p.rstate := dmtNone;
        if dbfile.WriteHeadModule(p.rid, p^) = false then
        begin
            dbfile.WriteLog('TDbFileClass.Write;修空间 修改状态失败' + #13#10
                + '{1}，ID' + inttostr(P.rid) + #13#10
                + '{2}，关键字' + P.rname + #13#10
                + '{3}，时间' + datetimetostr(P.rtime) + #13#10
                + '{4}，状态' + INTTOSTR(INTEGER(P.rstate))
                );
        end;
        FemptyList.add(p.rid);                                                  //增加 （回收 空间）
        p^ := TEMP;
    end else
    begin                                                                       //不存在 增加
        FUseDataList.add(temp);
    end;
    result := true;
end;

procedure TDbFileClass.LoadFile;
var
    i: integer;
    TEMP: TDBHeadModule;
begin
    if dbfile = nil then exit;
    for i := 0 to dbfile.UseCount - 1 do
    begin
        dbfile.ReadHeadModule(i, TEMP);
        case temp.rstate of
            dmtUser:
                begin
                    if TEMP.rid <> i then
                    begin
                        dbfile.WriteLog('TDbFileClass.LoadFile;ID错误' + #13#10
                            + '{0}，真实ID：' + inttostr(i) + #13#10
                            + '{1}，ID' + inttostr(temp.rid) + #13#10
                            + '{2}，关键字' + TEMP.rname + #13#10
                            + '{3}，时间' + datetimetostr(temp.rtime) + #13#10
                            + '{4}，状态dmtUser'
                            );
                        TEMP.rid := i;
                    end;
                    FUseDataList.add(TEMP);
                end;
            dmtNone: FemptyList.add(i);
            dmtTemp:
                begin
                    //记录下错误

                    dbfile.WriteLog('TDbFileClass.LoadFile;数据不完整' + #13#10
                        + '{0}，真实ID：' + inttostr(i) + #13#10
                        + '{1}，ID' + inttostr(temp.rid) + #13#10
                        + '{2}，关键字' + TEMP.rname + #13#10
                        + '{3}，时间' + datetimetostr(temp.rtime) + #13#10
                        + '{4}，状态dmtTemp'
                        );
                    FemptyList.add(i);
                end;

        else
            begin
                //记录下错误
                dbfile.WriteLog('TDbFileClass.LoadFile;错误类型;ID:' + inttostr(i) + ';状态:' + INTTOSTR(INTEGER(TEMP.rstate)));
                FemptyList.add(i);
            end
        end;

    end;

end;

constructor TDbFileClass.Create(aHead: TDbHeadFile; afilename: string);
begin
    aHead.rSize := aHead.rSize + SIZEOF(TDBHeadModule);
    dbfile := TBasicDbFileClass.Create(aHead, afilename);
    fUseDataList := TUseDataListclass.Create;
    FemptyList := TEmptyListclass.Create;

    LoadFile;
end;

destructor TDbFileClass.Destroy;
begin
    dbfile.Free;
    fUseDataList.Free;
    FemptyList.Free;

    inherited;
end;

function TDbFileClass.IsData(aindexname: string): boolean;
begin
    result := true;
    if fUseDataList.get(aindexname) = nil then result := false;
end;

function TDbFileClass.getAllNameList: string;
begin
    result := fUseDataList.getAllNameList;
end;

function TDbFileClass.Insert(aIndexName: string; abuf: pointer; asize: integer): Byte;
begin
    result := DB_ERR;
    if IsData(aIndexName) then
    begin
        result := DB_ERR_DUPLICATE;                                             //已经存在
        exit;
    end;
    if Write(aIndexName, abuf, asize) = FALSE then EXIT;
    result := DB_OK;
end;

function TDbFileClass.Select(aIndexName: string; abuf: pointer; asize: integer): Byte;
begin
    result := DB_ERR;
    if IsData(aIndexName) = false then
    begin
        result := DB_ERR_NOTFOUND;                                              //不存在
        exit;
    end;
    if Read(aIndexName, abuf, asize) = FALSE then EXIT;
    result := DB_OK;
end;

function TDbFileClass.Update(aIndexName: string; abuf: pointer; asize: integer): Byte;
begin
    result := DB_ERR;
    if IsData(aIndexName) = false then
    begin
        result := DB_ERR_NOTFOUND;                                              //不存在
        exit;
    end;
    if Write(aIndexName, abuf, asize) = FALSE then EXIT;
    result := DB_OK;
end;

function TDbFileClass.count: integer;
begin
    result := fUseDataList.fdata.Count;
end;

end.

