unit uEmaildata;

interface
uses
    Windows, Sysutils, Classes, Deftype;
type
    TEmaildataclass = class
        FID:integer;
        FDestName:string;          //目的 名字
        FTitle:string;             //标题
        FEmailText:string;         //内容
        FsourceName:string;        //来源 名字
        FTime:tdatetime;
        FGOLD_Money:integer;       //【元宝】
        Fbuf:TCutItemData;         //保存 精简物品
        procedure SaveToWordComData(var Code:TWordComData);
        procedure LoadFormWordComData(var Code:TWordComData; var id:integer);

        procedure SaveToTEmaildata(var aEmaildata:TEmaildata);
        procedure LoadFormTEmaildata(var aEmaildata:TEmaildata);

        function GetupdateSQL():string;
        function GetInsertSQL():string;
        procedure Clear();
    end;
implementation

procedure TEmaildataclass.Clear();
begin
    FID := 0;
    FTitle := '';
    FEmailText := '';
    FDestName := '';
    FsourceName := '';
    FTime := now();
    Fbuf.rName := '';
    FGOLD_Money := 0;
end;

function TEmaildataclass.GetInsertSQL():string;
begin
    if Fbuf.rName = '' then Fbuf.rID := 0;

    result := 'insert into uEMAIL ( ';
    result := result + ' fid, fdestname, ftitle, femailtext, fsourcename,  ';
    result := result + ' ftime, fgold_money )';
    result := result + ' values ( ';
    result := result + '''' + inttostr(fid) + ''',';
    result := result + '''' + fdestname + ''',';
    result := result + '''' + ftitle + ''',';
    result := result + '''' + femailtext + ''',';
    result := result + '''' + fsourcename + ''',';
    result := result + '''' + datetimetostr(ftime) + ''',';

    result := result + '''' + inttostr(fgold_money) + ''' ';

    result := result + ' ) ;';

end;

function TEmaildataclass.GetUPdateSQL():string;
begin
    if Fbuf.rName = '' then Fbuf.rID := 0;
    result := 'update uEMAIL set ';
    result := result + ' FDestName = ''' + FDestName + ''',';
    result := result + ' FTitle = ''' + FTitle + ''',';
    result := result + ' FEmailText = ''' + FEmailText + ''',';
    result := result + ' FsourceName = ''' + FsourceName + ''',';

    result := result + ' FTime = ''' + datetimetostr(FTime) + ''',';
    result := result + ' FGOLD_Money = ''' + inttostr(FGOLD_Money) + ''' ';

    result := result + ' where FID = ''' + inttostr(FID) + ''' ;';
end;

procedure TEmaildataclass.SaveToWordComData(var Code:TWordComData);
begin
    WordComData_ADDdword(Code, FID);
    WordComData_ADDstring(Code, FDestName);
    WordComData_ADDstring(Code, FTitle);
    WordComData_ADDstring(Code, FEmailText);
    WordComData_ADDstring(Code, FsourceName);
    WordComData_ADDdatetime(Code, FTime);
    WordComData_ADDdword(Code, FGOLD_Money);

    copymemory(@Code.Data[Code.Size], @fbuf, sizeof(fbuf));
    Code.Size := Code.Size + sizeof(fbuf);
end;

procedure TEmaildataclass.LoadFormWordComData(var Code:TWordComData; var id:integer);
begin
    FID := WordComData_getdword(Code, id);
    FDestName := WordComData_getstring(Code, id);
    FTitle := WordComData_getstring(Code, id);
    FEmailText := WordComData_getstring(Code, id);
    FsourceName := WordComData_getstring(Code, id);
    FTime := WordComData_getdatetime(Code, id);
    FGOLD_Money := WordComData_getdword(Code, id);

    copymemory(@fbuf, @Code.Data[id], sizeof(TCutItemData));
    id := id + sizeof(TCutItemData);
end;

procedure TEmaildataclass.LoadFormTEmaildata(var aEmaildata:TEmaildata);
begin
    FID := aEmaildata.FID;
    FDestName := aEmaildata.FDestName;
    FTitle := aEmaildata.FTitle;
    FEmailText := aEmaildata.FEmailText;
    FsourceName := aEmaildata.FsourceName;
    FTime := aEmaildata.FTime;
    FGOLD_Money := aEmaildata.FGOLD_Money;

    fbuf := aEmaildata.Fbuf;
end;

procedure TEmaildataclass.SaveToTEmaildata(var aEmaildata:TEmaildata);
begin
    aEmaildata.FID := FID;
    aEmaildata.FDestName := copy(FDestName, 1, 64);
    aEmaildata.FTitle := copy(FTitle, 1, 64);
    aEmaildata.FEmailText := copy(FEmailText, 1, 255);
    aEmaildata.FsourceName := copy(FsourceName, 1, 64);
    aEmaildata.FTime := FTime;
    aEmaildata.FGOLD_Money := FGOLD_Money;
    aEmaildata.Fbuf := fbuf;
end;

end.

