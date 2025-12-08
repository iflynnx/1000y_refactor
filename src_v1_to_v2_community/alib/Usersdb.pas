unit UserSdb;

interface

uses Windows, Classes, SysUtils, AUtil32, dialogs, uKeyClass;                   //ansunit;

type

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
///////////////////////////////////////////////////////////////////////////////////
    //字段
    // 使用 tstringlist 存放
    //序号从1开始
    TFieldClass = class
        FieldList: tstringlist;
        fFieldIndex: TStringKeyClass;
    public
        procedure Clear;
        constructor Create;
        destructor Destroy; override;
        procedure Load(astr: string);
        function get(aField: string): integer;
        function getCount: integer;
        function getFieldList: string;
    end;

    //纪录列表（一行纪录）
    //使用一个TSTRINGLIST存放

    TNewDbDataClass = class
        FdbName: string;
        dataList: tstringlist;
        FieldClass_p: TFieldClass;                                              //本类不创建
    public
        constructor Create(aFieldClass: TFieldClass);
        destructor Destroy; override;
        procedure Load(astr: string);
        function get(aIndex: integer): string;
        function getField(afield: string): string;
        function getCount: integer;
    end;
    //所有纪录 （针对行管理）
    //成员 TNewDbDataListClass
    TNewDbListClass = class
        dataList: tlist;
        fdbNameIndex: TStringKeyClass;

    public
        constructor Create;
        destructor Destroy; override;
        procedure Clear;
        procedure Add(aFieldClass: TFieldClass; astr: string);
        //删除 关键一行
        procedure del(adbName: string);
        //返回 某一行
        function getIndex(aindex: integer): TNewDbDataClass;
        //返回 指定关键字一行
        function get(adbName: string): TNewDbDataClass;
        function getDbNameList(): string;
    end;


    TNewStringDb = class
    private
        //字段列表
        FieldClass: TFieldClass;
        //纪录
        DbListClass: TNewDbListClass;

    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure LoadFile(afileName: string);
        procedure SaveFile(afileName: string);
        function getNaneIndexList: string;
        function GetFieldValueInteger(cName, cField: string): Integer;
        function GetFieldValueString(cName, cField: string): string;
        function GetFieldValueBoolean(cName, cField: string): Boolean;


        function SetFieldValueString(cName, cField, Value: string): Boolean;
        function SetFieldValueInteger(cName, cField: string; Value: Integer): Boolean;
        function SetFieldValueBoolean(cName, cField: string; Value: Boolean): Boolean;
    end;


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

{ TNewStringDb }

procedure TNewStringDb.Clear;
begin
    FieldClass.Clear;
    DbListClass.Clear;
end;

constructor TNewStringDb.Create;
begin
    FieldClass := TFieldClass.Create;
    DbListClass := TNewDbListClass.Create;
end;

destructor TNewStringDb.Destroy;
begin
    Clear;
    FieldClass.Free;
    DbListClass.Free;

    inherited;
end;

function TNewStringDb.GetFieldValueBoolean(cName, cField: string): Boolean;
var
    str: string;
begin
    result := false;
    str := GetFieldValueString(cName, cField);
    if str = 'TRUE' then result := true;

end;

function TNewStringDb.GetFieldValueInteger(cName, cField: string): Integer;
begin
    result := _StrToInt(GetFieldValueString(cName, cField));
end;

function TNewStringDb.GetFieldValueString(cName, cField: string): string;
var
    p: TNewDbDataClass;
begin
    result := '';
    p := DbListClass.get(cName);
    if p = nil then
    begin
        Windows.MessageBox(0, pchar(cName + ' 关键字的纪录不存在.'), '警告！错误提示', 0);
        exit;
    end;
    result := p.getField(cField);
end;

function TNewStringDb.getNaneIndexList: string;
begin
    result := DbListClass.getDbNameList;
end;

procedure TNewStringDb.LoadFile(afileName: string);
var
    temp: tstringlist;
    i: integer;
    str: string;
begin
    Clear;
    if FileExists(afileName) = false then
    begin
        Windows.MessageBox(0, pchar(aFileName + '文件不存在.'), '警告！错误提示', 0);
        exit;
    end;
    temp := tstringlist.Create;
    try
        temp.LoadFromFile(afileName);
        if temp.Count < 1 then
        begin
            Windows.MessageBox(0, pchar(aFileName + '无字段'), '警告！错误提示', 0);
            exit;
        end;
        //字段
        str := temp.Strings[0];
        FieldClass.Load(str);
        //纪录
        for i := 1 to temp.Count - 1 do
        begin
            str := temp.Strings[i];
            DbListClass.Add(FieldClass, str);
        end;

    finally
        temp.Free;
    end;

end;

procedure TNewStringDb.SaveFile(afileName: string);
begin

end;

function TNewStringDb.SetFieldValueBoolean(cName, cField: string; Value: Boolean): Boolean;
begin

end;

function TNewStringDb.SetFieldValueInteger(cName, cField: string; Value: Integer): Boolean;
begin

end;

function TNewStringDb.SetFieldValueString(cName, cField, Value: string): Boolean;
begin

end;

{ TNewDbListClass }

procedure TNewDbListClass.Add(aFieldClass: TFieldClass; astr: string);
var
    p: TNewDbDataClass;
    adbname: string;
begin
    GetValidStr3(astr, adbname, ',');
    if get(adbname) <> nil then exit;
    p := TNewDbDataClass.Create(aFieldClass);
    p.Load(astr);
    p.FdbName := adbname;
    dataList.Add(p);
    fdbNameIndex.Insert(adbname, p);
end;

procedure TNewDbListClass.Clear;
var
    i: integer;
    p: TNewDbDataClass;
begin
    for i := 0 to dataList.Count - 1 do
    begin
        p := dataList.Items[i];
        p.Free;
    end;
    dataList.Clear;
    fdbNameIndex.Clear;
end;

constructor TNewDbListClass.Create;
begin
    dataList := tlist.Create;
    fdbNameIndex := TStringKeyClass.Create;
end;

procedure TNewDbListClass.del(adbName: string);
var
    i: integer;
    p: TNewDbDataClass;
begin

    for i := 0 to dataList.Count - 1 do
    begin
        p := dataList.Items[i];
        if p.FdbName = adbName then
        begin
            dataList.Delete(i);
            fdbNameIndex.Delete(adbName);
            p.Free;
            exit;
        end;
    end;
end;

destructor TNewDbListClass.Destroy;
begin
    Clear;
    dataList.Free;
    fdbNameIndex.Free;
    inherited;
end;

function TNewDbListClass.get(adbName: string): TNewDbDataClass;
begin
    result := fdbNameIndex.Select(adbName);
end;

function TNewDbListClass.getDbNameList: string;
var
    i: integer;
    p: TNewDbDataClass;
begin
    result := '';
    for i := 0 to dataList.Count - 1 do
    begin
        p := dataList.Items[i];
        result := result + p.FdbName + #13#10;
    end;

end;

function TNewDbListClass.getIndex(aindex: integer): TNewDbDataClass;
begin
    result := nil;
    if (aindex < 0) or (aindex > (dataList.Count - 1)) then exit;
    result := dataList.Items[aindex];
end;

{ TNewDbDataClass }

constructor TNewDbDataClass.Create(aFieldClass: TFieldClass);
begin
    FieldClass_p := aFieldClass;
    dataList := tstringlist.Create;
end;

destructor TNewDbDataClass.Destroy;
begin
    dataList.Free;
    inherited;
end;

function TNewDbDataClass.get(aIndex: integer): string;
begin
    result := '';
    if (aIndex < 0) or (aIndex > (dataList.Count - 1)) then exit;
    result := dataList.Strings[aIndex];
end;

function TNewDbDataClass.getCount: integer;
begin
    result := dataList.Count;
end;

function TNewDbDataClass.getField(afield: string): string;
var
    i: integer;
begin
    result := '';
    if FieldClass_p = nil then
    begin
        Windows.MessageBox(0, pchar('所有字段为空'), '警告！错误提示', 0);
        exit;
    end;
    i := FieldClass_p.get(afield);
    if i = 0 then
    begin
        Windows.MessageBox(0, pchar('无字段：' + afield), '警告！错误提示', 0);
        exit;
    end;
    i := i - 1;
    result := get(i);
end;

procedure TNewDbDataClass.Load(astr: string);
begin
    if FieldClass_p = nil then exit;
    dataList.Text := StringReplace(astr, ',', #13#10, [rfReplaceAll]);
    if FieldClass_p.getCount <> getCount then
    begin
        Windows.MessageBox(0, pchar('字段和纪录数量不一致：' + astr), '警告！错误提示', 0);
    end;
end;

{ TFieldClass }

procedure TFieldClass.Clear;
begin
    FieldList.Clear;
    fFieldIndex.Clear;
end;

constructor TFieldClass.Create;
begin
    FieldList := tstringlist.Create;
    fFieldIndex := TStringKeyClass.Create;
end;

destructor TFieldClass.Destroy;
begin
    fFieldIndex.Free;
    FieldList.Free;
    inherited;
end;
//原始 返回

function TFieldClass.get(aField: string): integer;
begin
    aField := UpperCase(aField);
    result := integer(fFieldIndex.Select(aField));
end;

function TFieldClass.getCount: integer;
begin
    result := FieldList.Count;
end;

function TFieldClass.getFieldList: string;
begin
    result := FieldList.Text;
end;

procedure TFieldClass.Load(astr: string);
var
    i: integer;
    str: string;
begin
    fFieldIndex.Clear;
    FieldList.Text := StringReplace(astr, ',', #13#10, [rfReplaceAll]);
    for i := 0 to FieldList.Count - 1 do
    begin
        str := FieldList[i];
        str := UpperCase(str);
        if get(astr) <> 0 then Continue;
        fFieldIndex.Insert(str, pointer(i + 1));
    end;
end;

end.

