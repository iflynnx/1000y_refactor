unit uIniFile;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, uKeyclass, aUtil32;

type

    TiniKeydataclass = class
        fName:string;
        fValue:string;
    end;

    TiniKeyclass = class           //成员 TiniKeydataclass
    private
        datalist:Tlist;
        indexKey:TstringKeyclass;
    public
        name:string;
        constructor Create;
        destructor Destroy; override;

        procedure add(aname, aValue:string);
        function get(aname:string):TiniKeydataclass;
        function getindex(aindex:integer):TiniKeydataclass;
        procedure del(aname:string);
        procedure clear;

    end;
    TiniKeyListclass = class       //成员 TiniKeyclass
    private
        datalist:Tlist;
        indexKey:TstringKeyclass;

    public
        constructor Create;
        destructor Destroy; override;

        procedure add(aname:string);
        function get(aname:string):TiniKeyclass;
        function getindex(aindex:integer):TiniKeyclass;
        procedure del(aname:string);
        procedure clear;
        function read(Section, Ident:string; var adata:string):boolean;
        procedure Write(Section, Ident, Value:string);
    end;

    TiniFileclass = class
    private
        filename:string;
        iniFile:TiniKeyListclass;
        fupstate:boolean;
        procedure loadfromfile;
    public
        constructor Create(const aFileName:string);
        destructor Destroy; override;

        function ReadString(const Section, Ident, Default:string):string;
        function ReadInteger(const Section, Ident:string; Default:LongInt):LongInt;
        function ReadDate(const Section, Ident:string; Default:TDateTime):TDateTime;
        function ReadBool(const Section, Ident:string; Default:Boolean):Boolean;
        function ReadFloat(const Section, Ident:string; Default:Double):Double;

        procedure SaveToFile(aFileName:string);
        procedure WriteString(const Section, Ident, Value:string);
        procedure WriteInteger(const Section, Ident:string; Value:LongInt);
        procedure WriteDate(const Section, Ident:string; Value:TDateTime);
        procedure WriteBool(const Section, Ident:string; Value:Boolean);
        procedure WriteFloat(const Section, Ident:string; Value:Double);

        procedure DeleteKey(const Section, Ident:string);
        procedure EraseSection(const Section:string);
    end;

implementation

uses Math;

{TiniKey}

constructor TiniKeyclass.Create;
begin
    datalist := Tlist.Create;
    indexKey := TstringKeyClass.Create;
end;

procedure TiniKeyclass.add(aname, aValue:string);
var
    p               :TiniKeydataclass;
begin
    if get(aname) <> nil then exit;
    p := TiniKeydataclass.Create;
    p.fName := aname;
    p.fValue := aValue;
    datalist.Add(p);
    indexKey.Insert(aname, p);
end;

procedure TiniKeyclass.clear;
var
    i               :integer;
    p               :TiniKeydataclass;
begin
    for i := 0 to datalist.Count - 1 do
    begin
        p := datalist.Items[i];

        p.Free;

    end;
    datalist.Clear;
    indexKey.Clear;
end;

procedure TiniKeyclass.del(aname:string);
var
    i               :integer;
    p               :TiniKeydataclass;
begin
    for i := 0 to datalist.Count - 1 do
    begin
        p := datalist.Items[i];
        if p.fName = aname then
        begin
            datalist.Delete(i);
            indexKey.Delete(p.fName);
            p.Free;
            exit;
        end;
    end;

end;

function TiniKeyclass.get(aname:string):TiniKeydataclass;
begin
    result := indexKey.Select(aname);
end;

destructor TiniKeyclass.Destroy;
begin
    clear;
    datalist.free;
    indexKey.free;
    inherited;
end;
//////////////

{ TiniKeyListclass }

procedure TiniKeyListclass.add(aname:string);
var
    p               :TiniKeyclass;
begin
    if get(aname) <> nil then exit;
    if aname = '' then exit;
    p := TiniKeyclass.Create;
    p.name := aname;
    datalist.Add(p);
    indexKey.Insert(p.name, p);
end;

procedure TiniKeyListclass.clear;
var
    i               :integer;
    p               :TiniKeyclass;
begin
    for i := 0 to datalist.Count - 1 do
    begin
        p := datalist.Items[i];
        p.Free;
    end;
    datalist.Clear;
    indexKey.Clear;

end;

constructor TiniKeyListclass.Create;
begin
    datalist := Tlist.Create;
    indexKey := TstringKeyclass.Create;
end;

procedure TiniKeyListclass.del(aname:string);
var
    i               :integer;
    p               :TiniKeyclass;
begin
    for i := 0 to datalist.Count - 1 do
    begin
        p := datalist.Items[i];
        if p.name = aname then
        begin
            datalist.Delete(i);
            indexKey.Delete(p.name);
            p.Free;
            exit;
        end;
    end;

end;

destructor TiniKeyListclass.Destroy;
begin
    clear;
    datalist.Free;
    indexKey.Free;
    inherited;
end;

function TiniKeyListclass.read(Section, Ident:string; var adata:string):boolean;
var
    pkey            :TiniKeyclass;
    pdata           :TiniKeydataclass;
begin
    adata := '';
    result := false;
    pkey := get(Section);
    if pkey = nil then exit;
    pdata := pkey.get(Ident);
    if pdata = nil then exit;
    if pdata.fValue = '' then exit;
    adata := pdata.fValue;
    result := true;
end;

function TiniKeyListclass.get(aname:string):TiniKeyclass;
begin
    result := indexKey.Select(aname);

end;

procedure TiniKeyListclass.Write(Section, Ident, Value:string);
var
    pkey            :TiniKeyclass;
    pdata           :TiniKeydataclass;
begin
    pkey := get(Section);
    if pkey = nil then
    begin
        add(Section);
        pkey := get(Section);
        if pkey = nil then exit;
    end;
    pdata := pkey.get(Ident);
    if pdata = nil then
    begin
        pkey.add(Ident, Value);
        exit;
    end;
    pdata.fValue := Value;
end;

function TiniKeyListclass.getindex(aindex:integer):TiniKeyclass;
begin
    result := nil;
    if (aindex < 0) or (aindex >= datalist.Count) then exit;
    Result := datalist.Items[aindex];
end;

{ TiniFileclass }

constructor TiniFileclass.Create(const aFileName:string);
var
    stream          :TFileStream;
begin
    filename := aFileName;
    fupstate := false;
    if FileExists(aFileName) = false then
    begin
        stream := TFileStream.Create(aFileName, fmCreate);
        stream.Free;
    end;
    iniFile := TiniKeyListclass.Create;
    loadfromfile;
end;

procedure TiniFileclass.DeleteKey(const Section, Ident:string);
var
    p               :TiniKeyclass;
begin
    p := iniFile.get(Section);
    if p = nil then exit;
    p.del(Ident);

end;

destructor TiniFileclass.Destroy;
begin
    if fupstate then
        SaveToFile(filename);
    iniFile.Free;
    inherited;
end;

procedure TiniFileclass.EraseSection(const Section:string);
begin
    iniFile.del(Section);
end;

procedure TiniFileclass.loadfromfile;
var
    tempstringlist1, tempstringlist:tstringlist;
    str1            :string;
    i               :integer;
    tempini         :TiniKeyclass;
begin
    tempini := nil;
    tempstringlist := tstringlist.Create;
    tempStringList1 := TstringList.Create;
    try
        tempstringlist.LoadFromFile(filename);
        str1 := '';
        for i := 0 to tempstringlist.Count - 1 do
        begin
            str1 := tempstringlist.Strings[i];
            if length(str1) <= 2 then Continue;
            if str1[1] = '[' then
            begin
                tempini := nil;
                if str1[length(str1)] = ']' then
                begin
                    str1 := copy(str1, 2, length(str1) - 2);
                    tempini := iniFile.get(str1);
                    if tempini = nil then
                    begin
                        iniFile.add(str1);
                        tempini := iniFile.get(str1);
                    end;
                end;
                Continue;
            end;
            if tempini = nil then Continue;
            tempStringList1.Clear;
            if pos('=', str1) <= 0 then Continue;
            ExtractStrings(['='], [#10, #13], pchar(str1), tempStringList1);
            case tempStringList1.Count of
                1:tempini.add(trim(tempStringList1.Strings[0]), '');
                2:tempini.add(trim(tempStringList1.Strings[0]), trim(tempStringList1.Strings[1]));
            end;

        end;
    finally
        tempStringList1.Free;
        tempstringlist.Free;
    end;
end;

function TiniFileclass.ReadString(const Section, Ident, Default:string):string;
var
    astr            :string;
begin
    result := Default;
    if iniFile.read(Section, Ident, astr) then result := astr;
end;

function TiniFileclass.ReadInteger(const Section, Ident:string; Default:LongInt):LongInt;
var
    count, i        :integer;
    aint            :string;
begin
    result := Default;
    if iniFile.read(Section, Ident, aint) then
        Result := _StrToInt(Trim(aint));
end;

function TiniFileclass.ReadDate(const Section, Ident:string; Default:TDateTime):TDateTime;
var
    adate           :string;
begin
    result := Default;
    if iniFile.read(Section, Ident, adate) then Result := StrToDateTime(adate);

end;

function TiniFileclass.ReadBool(const Section, Ident:string; Default:Boolean):Boolean;
var
    abool           :string;
begin
    if iniFile.read(Section, Ident, abool) then Result := abool = 'TRUE';
end;

function TiniFileclass.ReadFloat(const Section, Ident:string; Default:Double):Double;
var
    afloat          :string;
begin
    if iniFile.read(Section, Ident, afloat) then Result := StrToFloat(afloat);
end;

procedure TiniFileclass.SaveToFile(aFileName:string);
var
    i, j            :integer;
    pkey            :TiniKeyclass;
    pdata           :TiniKeydataclass;
    tempstringlist  :tstringlist;
begin
    tempstringlist := tstringlist.Create;
    try
        for i := 0 to iniFile.datalist.Count - 1 do
        begin
            pkey := iniFile.getindex(i);
            if pkey = nil then Continue;
            tempstringlist.Add('[' + pkey.name + ']');
            for j := 0 to pkey.datalist.Count - 1 do
            begin
                pdata := pkey.getindex(j);
                if pdata = nil then Continue;
                tempstringlist.Add(pdata.fName + '=' + pdata.fValue);
            end;
        end;
        tempstringlist.SaveToFile(aFilename);
    finally
        tempstringlist.Free;
    end;
end;

procedure TiniFileclass.WriteString(const Section, Ident, Value:string);
begin
    fupstate := true;
    iniFile.Write(Section, Ident, Value);
end;

procedure TiniFileclass.WriteInteger(const Section, Ident:string; Value:LongInt);
begin
    fupstate := true;
    iniFile.Write(Section, Ident, IntToStr(Value));
end;

procedure TiniFileclass.WriteDate(const Section, Ident:string; Value:TDateTime);
begin
    fupstate := true;
    iniFile.Write(Section, Ident, DateTimeToStr(Value));
end;

procedure TiniFileclass.WriteBool(const Section, Ident:string; Value:Boolean);
begin
    fupstate := true;
    if Value then
        iniFile.Write(Section, Ident, 'TRUE')
    else
        iniFile.Write(Section, Ident, 'FALSE');
end;

procedure TiniFileclass.WriteFloat(const Section, Ident:string; Value:Double);
begin
    fupstate := true;
    iniFile.Write(Section, Ident, FloatToStr(Value));
end;

function TiniKeyclass.getindex(aindex:integer):TiniKeydataclass;
begin
    result := nil;
    if (aindex < 0) or (aindex >= datalist.Count) then exit;
    Result := datalist.Items[aindex];
end;

end.

