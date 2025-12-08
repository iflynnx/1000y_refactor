unit uDBAdapter;
//2009 年 5月 31 日
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  uDBFile, DefType;
type

  TUserDBAdapter_2009_06_01 = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create(afile: string = '');
    destructor Destroy; override;

    function UserUpdate(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function UserSelect(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function UserSelectAllName(): string;
    function UserInsert(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function count: integer;
    function delete(aIndexName: string): Byte;
  end;


  TUserDBAdapter = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create(afile: string = '');
    destructor Destroy; override;

    function UserUpdate(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function UserSelect(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function UserSelectAllName(): string;
    function UserInsert(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function count: integer;
    function delete(aIndexName: string): Byte;
  end;


  TLoginDBAdapter = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create(afile: string = '');
    destructor Destroy; override;

    function Update(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    function Select(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    function SelectAllName(): string;
    function Insert(aIndexName: string; aLGRecord: PTLGRecord): Byte;

    function count: integer;
  end;
  TPaidDBAdapter = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create;
    destructor Destroy; override;

    function Update(aIndexName: string; aPaidData: pTPaidData): Byte;
    function Select(aIndexName: string; aPaidData: pTPaidData): Byte;
    function SelectAllName(): string;
    function Insert(aIndexName: string; aPaidData: pTPaidData): Byte;
    function count: integer;
  end;

  TAuctionDBAdapter = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create;
    destructor Destroy; override;

    function Update(aIndexName: string; aAuctionData: pTAuctionData): Byte;
    function Delete(aIndexName: string): Byte;
    function Select(aIndexName: string; aAuctionData: pTAuctionData): Byte;
    function SelectAllName(): string;
    function Insert(aIndexName: string; aAuctionData: pTAuctionData): Byte;
    function count: integer;
  end;
  TEmailDBAdapter = class
  private
    dbfile: TDbFileClass;
  public
    constructor Create;
    destructor Destroy; override;

    function Update(aIndexName: string; aEmaildata: pTEmaildata): Byte;
    function Delete(aIndexName: string): Byte;
    function Select(aIndexName: string; aEmaildata: pTEmaildata): Byte;
    function SelectAllName(): string;
    function Insert(aIndexName: string; aEmaildata: pTEmaildata): Byte;
    function count: integer;
  end;
var
  UserDBAdapter: TUserDBAdapter;
  LoginDBAdapter: TLoginDBAdapter;
  PaidDBAdapter: TPaidDBAdapter;
  AuctionDBAdapter: TAuctionDBAdapter;
  EmailDBAdapter: TEmailDBAdapter;
implementation
 { TDBAdapter }

 { TUserDBAdapter_2009_06_01 }
constructor TUserDBAdapter_2009_06_01.Create(afile: string = '');
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_10_14'; // '酷引擎_1000y_2009_06_01';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TDBRecord_20091013);
  if afile = '' then
    dbfile := TDbFileClass.Create(aHead, '.\USER.DB')
  else
    dbfile := TDbFileClass.Create(aHead, afile);
end;

destructor TUserDBAdapter_2009_06_01.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TUserDBAdapter_2009_06_01.UserInsert(aIndexName: string; aDBRecord: PTDBRecord): Byte;
begin
  result := dbfile.Insert(aIndexName, aDBRecord, sizeof(TDBRecord));
end;

function TUserDBAdapter_2009_06_01.delete(aIndexName: string): Byte;
begin
  result := dbfile.delete(aIndexName);
end;

function TUserDBAdapter_2009_06_01.UserSelect(aIndexName: string; aDBRecord: PTDBRecord): Byte;
begin
  result := dbfile.Select(aIndexName, aDBRecord, sizeof(TDBRecord));
end;

function TUserDBAdapter_2009_06_01.UserUpdate(aIndexName: string; aDBRecord: PTDBRecord): Byte;
begin
  result := dbfile.Update(aIndexName, aDBRecord, sizeof(TDBRecord));
end;

function TUserDBAdapter_2009_06_01.UserSelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;

function TUserDBAdapter_2009_06_01.count: integer;
begin
  result := dbfile.count;
end;

 { TDBAdapter }
constructor TUserDBAdapter.Create(afile: string = '');
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_10_14'; // '酷引擎_1000y_2009_06_01';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TDBRecord);
  if afile = '' then
    dbfile := TDbFileClass.Create(aHead, '.\USER.DB')
  else
    dbfile := TDbFileClass.Create(aHead, afile);
end;

destructor TUserDBAdapter.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TUserDBAdapter.UserInsert(aIndexName: string; aDBRecord: PTDBRecord): Byte;
begin
  result := dbfile.Insert(aIndexName, aDBRecord, sizeof(TDBRecord));
end;

function TUserDBAdapter.delete(aIndexName: string): Byte;
begin
  result := dbfile.delete(aIndexName);
end;

function TUserDBAdapter.UserSelect(aIndexName: string; aDBRecord: PTDBRecord): Byte;
begin
  result := dbfile.Select(aIndexName, aDBRecord, sizeof(TDBRecord));
end;

function TUserDBAdapter.UserUpdate(aIndexName: string; aDBRecord: PTDBRecord): Byte;
begin
  result := dbfile.Update(aIndexName, aDBRecord, sizeof(TDBRecord));
end;

function TUserDBAdapter.UserSelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;

function TUserDBAdapter.count: integer;
begin
  result := dbfile.count;
end;
{ TLoginDBAdapter }

function TLoginDBAdapter.count: integer;
begin
  result := dbfile.count;
end;

constructor TLoginDBAdapter.Create(afile: string = '');
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_06_01_login';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TLGRecord);
  if afile = '' then
    dbfile := TDbFileClass.Create(aHead, '.\Login.DB')
  else dbfile := TDbFileClass.Create(aHead, afile);

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

{ TPaidDBAdapter }

function TPaidDBAdapter.count: integer;
begin
  result := dbfile.count;
end;

constructor TPaidDBAdapter.Create;
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_06_01_Paid';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TPaidData);
  dbfile := TDbFileClass.Create(aHead, '.\Paid.DB');
end;

destructor TPaidDBAdapter.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TPaidDBAdapter.Insert(aIndexName: string;
  aPaidData: pTPaidData): Byte;
begin
  result := dbfile.Insert(aIndexName, aPaidData, sizeof(TPaidData));
end;

function TPaidDBAdapter.Select(aIndexName: string;
  aPaidData: pTPaidData): Byte;
begin
  result := dbfile.Select(aIndexName, aPaidData, sizeof(TPaidData));
end;

function TPaidDBAdapter.SelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;

function TPaidDBAdapter.Update(aIndexName: string;
  aPaidData: pTPaidData): Byte;
begin
  result := dbfile.Update(aIndexName, aPaidData, sizeof(TPaidData));
end;

{ TAuctionDBAdapter }

function TAuctionDBAdapter.count: integer;
begin
  result := dbfile.count;
end;

constructor TAuctionDBAdapter.Create;
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_06_01_Auction';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TAuctionData);
  dbfile := TDbFileClass.Create(aHead, '.\Auction.DB');
end;

function TAuctionDBAdapter.Delete(aIndexName: string): Byte;
begin
  result := dbfile.DELETE(aIndexName);
end;

destructor TAuctionDBAdapter.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TAuctionDBAdapter.Insert(aIndexName: string; aAuctionData: pTAuctionData): Byte;
begin
  result := dbfile.Insert(aIndexName, aAuctionData, sizeof(TAuctionData));
end;

function TAuctionDBAdapter.Select(aIndexName: string; aAuctionData: pTAuctionData): Byte;
begin
  result := dbfile.Select(aIndexName, aAuctionData, sizeof(TAuctionData));
end;

function TAuctionDBAdapter.SelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;

function TAuctionDBAdapter.Update(aIndexName: string; aAuctionData: pTAuctionData): Byte;
begin
  result := dbfile.Update(aIndexName, aAuctionData, sizeof(TAuctionData));
end;

{ TEmailDBAdapter }

function TEmailDBAdapter.count: integer;
begin
  result := dbfile.count;
end;

constructor TEmailDBAdapter.Create;
var
  aHead: TDbHeadFile;
begin
  aHead.rVer := '酷引擎_1000y_2009_06_01_Email';
  aHead.rNewCount := 5000;
  aHead.rUseCount := 0;
  aHead.rMaxCount := 0;
  aHead.rSize := sizeof(TEmaildata);
  dbfile := TDbFileClass.Create(aHead, '.\Email.DB');
end;

function TEmailDBAdapter.Delete(aIndexName: string): Byte;
begin
  result := dbfile.DELETE(aIndexName);
end;

destructor TEmailDBAdapter.Destroy;
begin
  dbfile.Free;
  inherited;
end;

function TEmailDBAdapter.Insert(aIndexName: string; aEmaildata: pTEmaildata): Byte;
begin
  result := dbfile.Insert(aIndexName, aEmaildata, sizeof(TEmaildata));
end;

function TEmailDBAdapter.Select(aIndexName: string; aEmaildata: pTEmaildata): Byte;
begin
  result := dbfile.Select(aIndexName, aEmaildata, sizeof(TEmaildata));
end;

function TEmailDBAdapter.SelectAllName: string;
begin
  result := dbfile.getAllNameList;
end;

function TEmailDBAdapter.Update(aIndexName: string; aEmaildata: pTEmaildata): Byte;
begin
  result := dbfile.Update(aIndexName, aEmaildata, sizeof(TEmaildata));
end;



end.

