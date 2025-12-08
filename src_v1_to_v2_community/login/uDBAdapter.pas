unit uDBAdapter;
//2009 年 5月 31 日
interface
uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
    uDBFile, DefType;
type
    TLoginDBAdapter = class
    private
        dbfile: TDbFileClass;
    public
        constructor Create;
        destructor Destroy; override;

        function Update(aIndexName: string; aLGRecord: PTLGRecord): Byte;
        function Select(aIndexName: string; aLGRecord: PTLGRecord): Byte;
        function SelectAllName(): string;
        function delete(aIndexName: string): Byte;
        function Insert(aIndexName: string; aLGRecord: PTLGRecord): Byte;
        function count: integer;
    end;

var
    LoginDBAdapter: TLoginDBAdapter;
implementation

{ TLoginDBAdapter }

function TLoginDBAdapter.count: integer;
begin
    result := dbfile.count;
end;

constructor TLoginDBAdapter.Create;
var
    aHead: TDbHeadFile;
begin
    aHead.rVer := '酷引擎_1000y_2009_06_01_login';
    aHead.rNewCount := 5000;
    aHead.rUseCount := 0;
    aHead.rMaxCount := 0;
    aHead.rSize := sizeof(TLGRecord);
    dbfile := TDbFileClass.Create(aHead, '.\Login.DB');
end;

destructor TLoginDBAdapter.Destroy;
begin
    dbfile.Free;
    inherited;
end;

function TLoginDBAdapter.Insert(aIndexName: string; aLGRecord: PTLGRecord): Byte;
begin
    result := dbfile.Insert(aIndexName, aLGRecord, sizeof(TLGRecord));
end;

 function TLoginDBAdapter.delete(aIndexName: string): Byte;
begin
    result := dbfile.delete(aIndexName);
end;

function TLoginDBAdapter.Select(aIndexName: string; aLGRecord: PTLGRecord): Byte;
begin
    result := dbfile.Select(aIndexName, aLGRecord, sizeof(TLGRecord));
end;

function TLoginDBAdapter.SelectAllName: string;
begin
    result := dbfile.getAllNameList;
end;

function TLoginDBAdapter.Update(aIndexName: string; aLGRecord: PTLGRecord): Byte;
begin
    result := dbfile.Update(aIndexName, aLGRecord, sizeof(TLGRecord));
end;


end.

