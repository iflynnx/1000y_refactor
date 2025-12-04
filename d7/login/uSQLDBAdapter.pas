unit uSQLDBAdapter;

interface

uses
  Windows, SysUtils, DB, ADODB, Classes, DefType, AUtil32, uPackets, uEmaildata, uCreaSQL, uConnector, MyAccess, Dialogs;

type

  TSQlDBAdapter = class
  private
    FQuery: TMyQuery;
    FQuerysub: TMyQuery;
    FQueryRole: TMyQuery;
    FADOCommand: TMyCommand;
  public
    constructor Create(atemp: TMyConnection);
    destructor Destroy; override;
    procedure MessageSQLProcess(aPacket: PTPacketData; aconn: TConnector);
        //
    function CutItemDataUPdate(atable: string; ald: integer; atemp: pTCutItemData): boolean;
    function CutItemDataDELETE(aid: integer): boolean;
        //
    function EmailUpdate(pp: TEmaildataclass): boolean;
    function EmailREGNameINSERT(s: string): boolean;
    procedure EmailSELECTLoad(aPacket: PTPacketData; aconn: TConnector);
    function EmailDELETE(aid: integer): boolean;

    procedure AuctionSELECTLoad(aPacket: PTPacketData; aconn: TConnector);
    function AuctionUpdate(pp: pTAuctionData): boolean;
    function AuctionDELETE(aid: integer): boolean;
    function Auction_SelectAllName: string;

        //用户整体 操作函数
    function UserUpdate(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function UserSelect(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function UserInsert(aIndexName: string; aDBRecord: PTDBRecord): Byte;
    function Userdelete(aPrimaryKey: string): boolean;
    function UserSelectAllName(): string;
        //用户 基本数据 操作函数
    function UserdataIs(aPrimaryKey: string): boolean;
    function UserdataUpdate(var aDBRecord: TDBRecord): boolean;
    function UserdataSelect(aPrimaryKey: string; var aDBRecord: TDBRecord): boolean;
    function UserdataInsert(var aDBRecord: TDBRecord): boolean;
        //用户 物品 操作函数
    function UserItemDataDELETE(aUserName: string; atype: string; akey: integer): boolean;
    function UserItemDataInsert(aUserName: string; atype: string; akey: integer; aitem: TCutItemData): boolean;
    function UserItemDataUpdate(aUserName: string; atype: string; akey: integer; aitem: TCutItemData): boolean;
    function UserItemDataSelect(aUserName: string; atype: string; akey: integer; var aitem: TCutItemData): boolean;

    function UserItemDataSelectAll(aUserName: string; var aDBRecord: TDBRecord): boolean;
    procedure setItemData(atype: string; akey: integer; var aitem: TDBItemData; var aDBRecord: TDBRecord);
        //武功 数据 操作函数
    function UserMagicDataDELETE(aUserName: string; atype: string; akey: integer): boolean;
    function UserMagicDataInsert(aUserName: string; atype: string; akey: integer; amagic: TDBMagicData): boolean;
    function UserMagicDataUpdate(aUserName: string; atype: string; akey: integer; amagic: TDBMagicData): boolean;
    function UserMagicDataSelect(aUserName: string; atype: string; akey: integer; var amagic: TDBMagicData): boolean;

    function UserMagicDataSelectAll(aUserName: string; var aDBRecord: TDBRecord): boolean;
    procedure setMagicData(atype: string; akey: integer; var amagic: TDBMagicData; var aDBRecord: TDBRecord);
        //热键  数据 操作 函数
    function UserKEYDataInsert(var aDBRecord: TDBRecord): boolean;
    function UserKEYDataUpdate(var aDBRecord: TDBRecord): boolean;
    function UserKEYDataSelect(var aDBRecord: TDBRecord): boolean;
        //任务  数据 操作 函数
    function UserQuestDataInsert(var aDBRecord: TDBRecord): boolean;
    function UserQuestDataUpdate(var aDBRecord: TDBRecord): boolean;
    function UserQuestDataSelect(var aDBRecord: TDBRecord): boolean;
        //登陆
    function LG_Select(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    function Lg_SelectAllName: string;
    function LG_Insert(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    function LG_Delete(aIndexName: string): Byte;
    function LG_Update(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    //新表结构登录
    function New_LG_Select(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    function New_Lg_SelectAllName: string;
    function New_LG_Insert(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    function New_LG_Delete(aIndexName: string): Byte;
    function New_LG_Update(aIndexName: string; aLGRecord: PTLGRecord): Byte;
    function New_LG_UpdateChar(aIndexName: string; aLGRecord: PTLGRecord): Byte;
        //点卡
    function Paid_Select(apaid: PTPaidData): boolean;
    function Paid_Update(apaid: PTPaidData): boolean;
    function Paid_Insert(apaid: PTPaidData): boolean;
    function Paid_SelectAllName: string;

    procedure setnames(names: string);

  end;

var
  SQLDBAdapter: TSQlDBAdapter;

implementation

uses Math, FMain;


procedure TSQlDBAdapter.setnames(names: string);
var
  mStr: string;
begin
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('set names "' + names + '"');
  try
    FQuery.Execute;
  except
    FQuery.Close;
    exit;
  end;
end;

function TSQlDBAdapter.Paid_SelectAllName: string;
var
  mStr: string;
begin
  result := '';

  mStr := 'select * from uPaid';
    //  mStr := mStr + ' where ( rPrimaryKey = ''' + aPrimaryKey + ''') ;';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      result := result + COPY(FQuerysub.FieldByName('rLoginId').AsString, 1, 20) + #13#10;
      FQuerysub.Next;
    end;
  end;
  FQuerysub.Close;

end;

function TSQlDBAdapter.Paid_Select(apaid: PTPaidData): boolean;
var
  mStr, str: string;
  i: integer;
begin
  result := false;

  mStr := 'select * from uPaid';
  mStr := mStr + ' where (rloginid = ''' + apaid.rLoginId + ''')';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin

      apaid.rLoginId := FQuerysub.FieldByName('rLoginId').AsString; //帐户

      str := FQuerysub.FieldByName('rPaidType').AsString; //类型
      apaid.rPaidType := strTOpaidtype(str);

      apaid.rRemainDay := FQuerysub.FieldByName('rRemainDay').AsInteger; //点卡
      apaid.rmaturity := FQuerysub.FieldByName('rmaturity').AsDateTime; //日期

      FQuerysub.Next;

      break;
    end;
  end;
  FQuerysub.Close;

  result := true;
end;

function TSQlDBAdapter.Paid_Insert(apaid: PTPaidData): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := TPaidDataToInsertSQL(apaid^);
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  if FQuerysub.RowsAffected < 1 then
  begin
    FQuerysub.Close;
    exit;
  end;
  FQuerysub.Close;
  result := true;
end;

function TSQlDBAdapter.Paid_Update(apaid: PTPaidData): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := TPaidDataToUPdateSQL(apaid^);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
    if Paid_Insert(apaid) = false then
    begin
      FQuery.Close;
      exit;
    end;

  end;

  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.Lg_SelectAllName: string;
var
  mStr: string;
begin
  result := '';

  mStr := 'select * from account1000y ';
    //  mStr := mStr + ' where ( rPrimaryKey = ''' + aPrimaryKey + ''') ;';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      result := result + COPY(FQuerysub.FieldByName('account').AsString, 1, 20) + #13#10;
      FQuerysub.Next;
    end;
  end;
  FQuerysub.Close;

end;

function TSQlDBAdapter.LG_Select(aIndexName: string; aLGRecord: PTLGRecord): Byte;
var
  i: Integer;
  mStr, str: string;
  uPrimaryKey, uPassword: string;
  uCharInfo: array[0..5 - 1] of string;
  uIpAddr, uUserName, uBirth, uTelephone, uMakeDate: string;
  uParentName, uParentNativeNumber: string;
  uLastDate, uAddress, uEmail, uNativeNumber, uMasterKey: string;
  uCharName, uServerName: string;
begin
  Result := DB_OK;
  if aIndexName = '' then
  begin
    Result := DB_ERR_INVALIDDATA;
    exit;
  end;

  mStr := 'select * from account1000y where account = ''' + aIndexName + ''';';
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.Open;
  except
        //  frmMain.AddSQL(mStr);
  end;

  if FQuery.RecordCount <= 0 then
  begin
    FQuery.Close;
    Result := DB_ERR_NOTFOUND;
    exit;
  end;
  FQuery.First;
  while not (FQuery.Eof) do
  begin
    uPrimaryKey := FQuery.Fields[0].AsString;
    uPassword := FQuery.Fields[1].AsString;
    for i := 0 to 5 - 1 do
    begin
      uCharInfo[i] := FQuery.Fields[2 + i].AsString;
      if uCharInfo[i] = ':' then uCharInfo[i] := '';
    end;
    uIpAddr := FQuery.Fields[7].AsString;
    uUserName := FQuery.Fields[8].AsString;
    uBirth := FQuery.Fields[9].AsString;
    uTelephone := FQuery.Fields[10].AsString;
    uMakeDate := FQuery.Fields[11].AsString;
    uLastDate := FQuery.Fields[12].AsString;
    uAddress := FQuery.Fields[13].AsString;
    uEmail := FQuery.Fields[14].AsString;
    uNativeNumber := FQuery.Fields[15].AsString;
    uMasterKey := FQuery.Fields[16].AsString;
    uParentName := FQuery.Fields[17].AsString;
    uParentNativeNumber := FQuery.Fields[18].AsString;

    aLGRecord^.PrimaryKey := Copy(uPrimaryKey, 1, 20);
    aLGRecord^.PassWord := Copy(uPassWord, 1, 20);

    for i := 0 to 5 - 1 do
    begin
      str := uCharInfo[i];
      str := GetValidStr3(str, uCharName, ':');
      str := GetValidStr3(str, uServerName, ':');

      aLGRecord^.CharInfo[i].CharName := Copy(uCharName, 1, 20);
      aLGRecord^.CharInfo[i].ServerName := Copy(uServerName, 1, 20);
    end;

    aLGRecord^.IpAddr := Copy(uIpAddr, 1, 16);
    aLGRecord^.MakeDate := Copy(uMakeDate, 1, 20);
    aLGrecord^.LastDate := Copy(uLastDate, 1, 20);
    aLGRecord^.Birth := Copy(uBirth, 1, 20);
    aLGRecord^.Address := Copy(uAddress, 1, 50);
    aLGRecord^.UserName := Copy(uUserName, 1, 20);
    aLGRecord^.NativeNumber := Copy(uNativeNumber, 1, 20);
    aLGRecord^.MasterKey := Copy(uMasterKey, 1, 20);
    aLGRecord^.Email := Copy(uEmail, 1, 50);
    aLGRecord^.Phone := Copy(uTelePhone, 1, 20);
    aLGRecord^.ParentName := Copy(uParentName, 1, 20);
    aLGRecord^.ParentNativeNumber := Copy(uParentNativeNumber, 1, 20);

    FQuery.Next;

    break;
  end;

  FQuery.Close;
end;

function TSQlDBAdapter.LG_Insert(aIndexName: string; aLGRecord: PTLGRecord): Byte;
var
  i: Integer;
  mStr, str: string;
  uPrimaryKey, uPassword: string;
  uCharInfo: array[0..5 - 1] of string;
  uIpAddr, uUserName, uBirth, uTelephone, uMakeDate: string;
  uLastDate, uAddress, uEmail, uNativeNumber, uMasterKey: string;
  uParentName, uParentNativeNumber: string;
  uCharName, uServerName: string;
  LGRecord: TLGRecord;
begin
  Result := DB_OK;
  if aIndexName = '' then
  begin
    Result := DB_ERR_INVALIDDATA;
    exit;
  end;

  if LG_Select(aIndexName, @LGRecord) = DB_OK then
  begin
    Result := DB_ERR_DUPLICATE;
    exit;
  end;

  uPrimaryKey := aLGRecord^.PrimaryKey;
  uPassWord := aLGRecord^.PassWord;

  for i := 0 to 5 - 1 do
  begin
    Str := aLGRecord^.CharInfo[i].CharName + ':' + aLGRecord^.CharInfo[i].ServerName;
    if str = ':' then str := '';
    uCharInfo[i] := str;
  end;

  uIpAddr := aLGRecord^.IpAddr;
  uMakeDate := aLGRecord^.MakeDate;
  uLastDate := aLGRecord^.LastDate;
  uUserName := aLGRecord^.UserName;
  uNativeNumber := aLGRecord^.NativeNumber;
  uMasterKey := aLGRecord^.MasterKey;
  uEmail := aLGRecord^.Email;
  uTelePhone := aLGRecord^.Phone;
  uParentName := aLGRecord^.ParentName;
  uParentNativeNumber := aLGRecord^.ParentNativeNumber;

  uBirth := '';
  uAddress := '';

    // account, password, char1, char2, char3, char4, char5, ipaddr, username, birth
    // telephone, makedate, lastdate, address, email, nativenumber, masterkey
  mStr := 'insert into account1000y ( ';
  mStr := mStr + ' account, password, char1, char2, char3, char4, char5,';
  mStr := mStr + ' ipaddr, username, birth, telephone, makedate, lastdate,';
  mStr := mStr + ' address, email, nativenumber, masterkey, ptname, ptnativenumber )';
  mStr := mStr + ' values ( ';
  mStr := mStr + '''' + uPrimaryKey + ''',';
  mStr := mStr + '''' + uPassword + ''',';
  mStr := mStr + '''' + uCharInfo[0] + ''',';
  mStr := mStr + '''' + uCharInfo[1] + ''',';
  mStr := mStr + '''' + uCharInfo[2] + ''',';
  mStr := mStr + '''' + uCharInfo[3] + ''',';
  mStr := mStr + '''' + uCharInfo[4] + ''',';
  mStr := mStr + '''' + uIpAddr + ''',';
  mStr := mStr + '''' + uUserName + ''',';
  mStr := mStr + '''' + uBirth + ''',';
  mStr := mStr + '''' + uTelephone + ''',';
  mStr := mStr + '''' + uMakeDate + ''',';
  mStr := mStr + '''' + uLastDate + ''',';
  mStr := mStr + '''' + uAddress + ''',';
  mStr := mStr + '''' + uEmail + ''',';
  mStr := mStr + '''' + uNativeNumber + ''',';
  mStr := mStr + '''' + uMasterKey + ''',';
  mStr := mStr + '''' + uParentName + ''',';
  mStr := mStr + '''' + uParentNativeNumber + ''' );';

    // FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
        // frmMain.AddSQL(mStr);
  end;

  if FQuery.RowsAffected < 1 then
  begin
    Result := DB_ERR_DUPLICATE;
  end;

  FQuery.Close;
end;


function TSQlDBAdapter.LG_Delete(aIndexName: string): Byte;
var
  mStr: string;
  aitemid: integer;
begin


    ////////////////////////////////////////////////////////////////////////////
    //                         删除物品
    ////////////////////////////////////////////////////////////////////////////
  mStr := 'delete account1000y';
  mStr := mStr + ' where (account = ''' + aIndexName + ''')';


  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

end;

function TSQlDBAdapter.LG_Update(aIndexName: string; aLGRecord: PTLGRecord): Byte;
var
  i, j: Integer;
  mStr, str: string;
  uPrimaryKey, uPassword: string;
  uCharInfo: array[0..5 - 1] of string;
  uIpAddr, uUserName, uBirth, uTelephone, uMakeDate: string;
  uLastDate, uAddress, uEmail, uNativeNumber, uMasterKey: string;
  uParentName, uParentNativeNumber: string;
  uCharName, uServerName: string;
  LGRecord: TLGRecord;
begin
  Result := DB_OK;
  if aIndexName = '' then
  begin
    Result := DB_ERR_INVALIDDATA;
    exit;
  end;

  if LG_Select(aIndexName, @LGRecord) <> DB_OK then
  begin
    Result := DB_ERR_NOTFOUND;
    exit;
  end;

  uPrimaryKey := aLGRecord^.PrimaryKey;
  uPassWord := aLGRecord^.PassWord;

  for i := 0 to 5 - 1 do
  begin
    Str := aLGRecord^.CharInfo[i].CharName + ':' + aLGRecord^.CharInfo[i].ServerName;
    if str = ':' then str := '';
    uCharInfo[i] := str;
  end;
  uIpAddr := aLGRecord^.IpAddr;
  uMakeDate := aLGRecord^.MakeDate;
  uLastDate := aLGRecord^.LastDate;

  uUserName := aLGRecord^.UserName;
  uNativeNumber := aLGRecord^.NativeNumber;
  uMasterKey := aLGRecord^.MasterKey;
  uEmail := aLGRecord^.Email;
  uTelePhone := aLGRecord^.Phone;
  uParentName := aLGRecord^.ParentName;
  uParentNativeNumber := aLGRecord^.ParentNativeNumber;

  uBirth := aLGRecord^.Birth;
  uAddress := aLGRecord^.Address;

    // account, password, char1, char2, char3, char4, char5, ipaddr, username, birth
    // telephone, makedate, lastdate, address, email, nativenumber, masterkey
  mStr := 'update account1000y set ';
  mStr := mStr + ' password = ''' + uPassword + ''',';
  mStr := mStr + ' char1 = ''' + uCharInfo[0] + ''',';
  mStr := mStr + ' char2 = ''' + uCharInfo[1] + ''',';
  mStr := mStr + ' char3 = ''' + uCharInfo[2] + ''',';
  mStr := mStr + ' char4 = ''' + uCharInfo[3] + ''',';
  mStr := mStr + ' char5 = ''' + uCharInfo[4] + ''',';
  mStr := mStr + ' ipaddr = ''' + uIpAddr + ''',';
  mStr := mStr + ' username = ''' + uUserName + ''',';
  mStr := mStr + ' birth = ''' + uBirth + ''',';
  mStr := mStr + ' telephone = ''' + uTelephone + ''',';
  mStr := mStr + ' makedate = ''' + uMakeDate + ''',';
  mStr := mStr + ' lastdate = ''' + uLastDate + ''',';
  mStr := mStr + ' address = ''' + uAddress + ''',';
  mStr := mStr + ' email = ''' + uEmail + ''',';
  mStr := mStr + ' nativenumber = ''' + uNativeNumber + ''',';
  mStr := mStr + ' masterkey = ''' + uMasterKey + ''',';
  mStr := mStr + ' ptname = ''' + uParentName + ''',';
  mStr := mStr + ' ptnativenumber = ''' + uParentNativeNumber + '''';
  mStr := mStr + ' where account = ''' + uPrimaryKey + ''';';

  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
        //        frmMain.AddSQL(mStr);
  end;

  if FQuery.RowsAffected < 1 then
  begin
    Result := DB_ERR_NOTFOUND;
  end;

  FQuery.Close;
end;

function TSQlDBAdapter.UserQuestDataInsert(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := UserQuestdataToInsertSQL(aDBRecord);
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  if FQuerysub.RowsAffected < 1 then
  begin
    FQuerysub.Close;
    exit;
  end;
  FQuerysub.Close;
  result := true;
end;

function TSQlDBAdapter.UserQuestDataUpdate(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := UserQuestdataToUPdateSQL(aDBRecord);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
    if UserQuestDataInsert(aDBRecord) = false then
    begin
      FQuery.Close;
      exit;
    end;

  end;

  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.UserQuestDataSelect(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
  i: integer;
begin
  result := false;

  mStr := 'select * from uUserQuest';
  mStr := mStr + ' where (lusername = ''' + aDBRecord.PrimaryKey + ''')';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin

      aDBRecord.CompleteQuestNo := FQuerysub.FieldByName('CompleteQuestNo').AsInteger;
      aDBRecord.CurrentQuestNo := FQuerysub.FieldByName('CurrentQuestNo').AsInteger;
      aDBRecord.Queststep := FQuerysub.FieldByName('Queststep').AsInteger;
      aDBRecord.SubCurrentQuestNo := FQuerysub.FieldByName('SubCurrentQuestNo').AsInteger;
      aDBRecord.SubQueststep := FQuerysub.FieldByName('SubQueststep').AsInteger;
      for i := 0 to 19 do
      begin
        aDBRecord.QuesttempArr[i] := FQuerysub.FieldByName('Questtemp' + inttostr(i)).AsInteger;
      end;
      FQuerysub.Next;

      break;
    end;
  end;
  FQuerysub.Close;

  result := true;
end;
////////////////////////////////////////////////////////////////////////

function TSQlDBAdapter.UserKEYDataInsert(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := UserKEYdataToInsertSQL(aDBRecord);
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  if FQuerysub.RowsAffected < 1 then
  begin
    FQuerysub.Close;
    exit;
  end;
  FQuerysub.Close;
  result := true;
end;

function TSQlDBAdapter.UserKEYDataUpdate(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := UserKEYdataToUPdateSQL(aDBRecord);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
    if UserKEYDataInsert(aDBRecord) = false then
    begin
      FQuery.Close;
      exit;
    end;

  end;

  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.UserKEYDataSelect(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
  i: integer;
begin
  result := false;

  mStr := 'select * from uUserKey';
  mStr := mStr + ' where (lusername = ''' + aDBRecord.PrimaryKey + ''')';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      for i := 0 to 9 do
      begin
        aDBRecord.KeyArr[i] := FQuerysub.FieldByName('key' + inttostr(i)).AsInteger;
      end;
      for i := 0 to 9 do
      begin
        aDBRecord.ShortcutKeyArr[i] := FQuerysub.FieldByName('Shortcutkey' + inttostr(i)).AsInteger;
      end;
      FQuerysub.Next;

      break;
    end;
  end;
  FQuerysub.Close;

  result := true;
end;
////////////////////////////////////////////////////////////////////////

function TSQlDBAdapter.UserdataInsert(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := UserdataToInsertSQL(aDBRecord);
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  if FQuerysub.RowsAffected < 1 then
  begin
    FQuerysub.Close;
    exit;
  end;
  FQuerysub.Close;
  result := true;
end;

function TSQlDBAdapter.UserdataUpdate(var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := UserdataToUPdateSQL(aDBRecord);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
    if UserdataInsert(aDBRecord) = false then
    begin
      FQuery.Close;
      exit;
    end;

  end;

  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.UserdataIs(aPrimaryKey: string): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := 'select rPrimaryKey from uUserData';
  mStr := mStr + ' where ( rPrimaryKey = ''' + aPrimaryKey + ''') ;';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then result := true;
  FQuerysub.Close;

end;

function TSQlDBAdapter.UserSelectAllName: string;
var
  mStr: string;
begin
  result := '';

  mStr := 'select rPrimaryKey from uUserData';
    //  mStr := mStr + ' where ( rPrimaryKey = ''' + aPrimaryKey + ''') ;';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      result := result + COPY(FQuerysub.FieldByName('rPrimaryKey').AsString, 1, 20) + #13#10;
      FQuerysub.Next;
    end;
  end;
  FQuerysub.Close;

end;

function TSQlDBAdapter.UserdataSelect(aPrimaryKey: string; var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := 'select * from uUserData';
  mStr := mStr + ' where ( rPrimaryKey = ''' + aPrimaryKey + ''') ;';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      with aDBRecord do
      begin

        id := FQuerysub.FieldByName('rid').AsInteger;
        PrimaryKey := COPY(FQuerysub.FieldByName('rPrimaryKey').AsString, 1, 20);
        MasterName := COPY(FQuerysub.FieldByName('rMasterName').AsString, 1, 20);
        Password := COPY(FQuerysub.FieldByName('rPassword').AsString, 1, 20);
        GroupKey := FQuerysub.FieldByName('rGroupKey').AsInteger;
        Guild := COPY(FQuerysub.FieldByName('rGuild').AsString, 1, 20);
        LastDate := FQuerysub.FieldByName('rLastDate').AsDateTime;
        CreateDate := FQuerysub.FieldByName('rCreateDate').AsDateTime;
        Sex := FQuerysub.FieldByName('rSex').AsString = '男';
        ServerId := FQuerysub.FieldByName('rServerId').AsInteger;
        x := FQuerysub.FieldByName('rx').AsInteger;
        y := FQuerysub.FieldByName('ry').AsInteger;
        GOLD_Money := FQuerysub.FieldByName('rGOLD_Money').AsInteger;
        prestige := FQuerysub.FieldByName('rprestige').AsInteger;
        Light := FQuerysub.FieldByName('rLight').AsInteger;
        Dark := FQuerysub.FieldByName('rDark').AsInteger;
        Energy := FQuerysub.FieldByName('rEnergy').AsInteger;
        InPower := FQuerysub.FieldByName('rInPower').AsInteger;
        OutPower := FQuerysub.FieldByName('rOutPower').AsInteger;
        Magic := FQuerysub.FieldByName('rMagic').AsInteger;
        Life := FQuerysub.FieldByName('rLife').AsInteger;
        Talent := FQuerysub.FieldByName('rTalent').AsInteger;
        GoodChar := FQuerysub.FieldByName('rGoodChar').AsInteger;
        BadChar := FQuerysub.FieldByName('rBadChar').AsInteger;
        Adaptive := FQuerysub.FieldByName('rAdaptive').AsInteger;
        Revival := FQuerysub.FieldByName('rRevival').AsInteger;
        Immunity := FQuerysub.FieldByName('rImmunity').AsInteger;
        Virtue := FQuerysub.FieldByName('rVirtue').AsInteger;
        CurEnergy := FQuerysub.FieldByName('rCurEnergy').AsInteger;
        CurInPower := FQuerysub.FieldByName('rCurInPower').AsInteger;
        CurOutPower := FQuerysub.FieldByName('rCurOutPower').AsInteger;
        CurMagic := FQuerysub.FieldByName('rCurMagic').AsInteger;
        CurLife := FQuerysub.FieldByName('rCurLife').AsInteger;
        CurHealth := FQuerysub.FieldByName('rCurHealth').AsInteger;
        CurSatiety := FQuerysub.FieldByName('rCurSatiety').AsInteger;
        CurPoisoning := FQuerysub.FieldByName('rCurPoisoning').AsInteger;
        CurHeadSeek := FQuerysub.FieldByName('rCurHeadSeek').AsInteger;
        CurArmSeek := FQuerysub.FieldByName('rCurArmSeek').AsInteger;
        CurLegSeek := FQuerysub.FieldByName('rCurLegSeek').AsInteger;
        ExtraExp := FQuerysub.FieldByName('rExtraExp').AsInteger;
        AddableStatePoint := FQuerysub.FieldByName('rAddableStatePoint').AsInteger;
        TotalStatePoint := FQuerysub.FieldByName('rTotalStatePoint').AsInteger;
        CurrentGrade := FQuerysub.FieldByName('rCurrentGrade').AsInteger;
        FashionableDress := FQuerysub.FieldByName('rFashionableDress').AsInteger = 1;
        ItemLog.rsize := FQuerysub.FieldByName('rItemLogsize').AsInteger;
        ItemLog.Header.LockPassword := COPY(FQuerysub.FieldByName('rItemLogLockPassword').AsString, 1, 9);
        JobKind := FQuerysub.FieldByName('rJobKind').AsInteger;
        Dummyb := COPY(FQuerysub.FieldByName('rDummy').AsString, 1, 66);

      end;
      FQuerysub.Next;

      break;
    end;
  end;
  FQuerysub.Close;

  result := true;
end;
////////////////////////////////////////////////////////////////////////////////

function TSQlDBAdapter.UserMagicDataDELETE(aUserName: string; atype: string; akey: integer): boolean;
var
  mStr: string;
begin
  result := false;
  mStr := 'delete uUserMagic';
  mStr := mStr + ' where (lusername = ''' + aUserName + ''')'
    + ' and (ltype = ''' + atype + ''')'
    + ' and (lkey = ''' + inttostr(akey) + ''')';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

  result := true;
end;

function TSQlDBAdapter.UserMagicDataInsert(aUserName: string; atype: string; akey: integer; amagic: TDBMagicData): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := TDBMagicDataToInsertSQL(aUserName, atype, akey, @amagic);
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  if FQuerysub.RowsAffected < 1 then
  begin
    FQuerysub.Close;
    exit;
  end;
  FQuerysub.Close;
  result := true;
end;

function TSQlDBAdapter.UserMagicDataUpdate(aUserName: string; atype: string; akey: integer; amagic: TDBMagicData): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := TUserBMagicDataToUPdateSQL(aUserName, atype, akey, @amagic);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
    if UserMagicDataInsert(aUserName, atype, akey, amagic) = false then
    begin
      FQuery.Close;
      exit;
    end;

  end;

  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.UserMagicDataSelect(aUserName: string; atype: string; akey: integer; var amagic: TDBMagicData): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := 'select * from uUserMagic';
  mStr := mStr + ' where (lusername = ''' + aUserName + ''')'
    + ' and (ltype = ''' + atype + ''')'
    + ' and (lkey = ''' + inttostr(akey) + ''')';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin

      amagic.rName := COPY(FQuerysub.FieldByName('rName').AsString, 1, 20);
      amagic.rSkill := FQuerysub.FieldByName('rSkill').AsInteger;
      FQuerysub.Next;

      break;
    end;
  end;
  FQuerysub.Close;

  result := true;
end;

function TSQlDBAdapter.UserItemDataSelectAll(aUserName: string; var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
  atype: string;
  akey: integer;
  aitem: TCutItemData;
begin
  result := false;

  mStr := 'select * from uUserItem';
  mStr := mStr + ' where (lusername = ''' + aUserName + ''')';
    //  + ' and (ltype = ''' + atype + ''')'
     // + ' and (lkey = ''' + inttostr(akey) + ''')';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      atype := FQuerysub.FieldByName('ltype').AsString;
      akey := FQuerysub.FieldByName('lkey').AsInteger;

      aitem.rID := FQuerysub.FieldByName('rid').AsInteger;
      aitem.rName := COPY(FQuerysub.FieldByName('rName').AsString, 1, 20);
      aitem.rCount := FQuerysub.FieldByName('rCount').AsInteger;
      aitem.rColor := FQuerysub.FieldByName('rColor').AsInteger;
      aitem.rDurability := FQuerysub.FieldByName('rDurability').AsInteger;
      aitem.rDurabilityMAX := FQuerysub.FieldByName('rDurabilityMAX').AsInteger;
      aitem.rSmithingLevel := FQuerysub.FieldByName('rlevel').AsInteger;
      aitem.rAttach := FQuerysub.FieldByName('rAdditional').AsInteger;
      aitem.rlockState := FQuerysub.FieldByName('rlockState').AsInteger;
      aitem.rlocktime := FQuerysub.FieldByName('rlocktime').AsInteger;

      aitem.rSetting.rsettingcount := FQuerysub.FieldByName('rsettingcount').AsInteger;
      aitem.rSetting.rsetting1 := COPY(FQuerysub.FieldByName('rsetting1').AsString, 1, 20);
      aitem.rSetting.rsetting2 := COPY(FQuerysub.FieldByName('rsetting2').AsString, 1, 20);
      aitem.rSetting.rsetting3 := COPY(FQuerysub.FieldByName('rsetting3').AsString, 1, 20);
      aitem.rSetting.rsetting4 := COPY(FQuerysub.FieldByName('rsetting4').AsString, 1, 20);

      aitem.rDateTime := FQuerysub.FieldByName('rDateTime').AsDateTime;
      setItemData(atype, akey, aitem, aDBRecord);
      FQuerysub.Next;

            // break;
    end;
  end;
  FQuerysub.Close;

  result := true;
end;

procedure TSQlDBAdapter.setItemData(atype: string; akey: integer; var aitem: TDBItemData; var aDBRecord: TDBRecord);
begin
  if akey < 0 then exit;
  atype := UpperCase(atype);
  if atype = UpperCase('WearItem') then
  begin
    if akey <= high(aDBRecord.WearItemArr) then
      aDBRecord.WearItemArr[akey] := aitem;
  end
  else if atype = UpperCase('FashionableDress') then
  begin
    if akey <= high(aDBRecord.FashionableDressArr) then
      aDBRecord.FashionableDressArr[akey] := aitem;
  end
  else if atype = UpperCase('HaveItem') then
  begin
    if akey <= high(aDBRecord.HaveItemArr) then
      aDBRecord.HaveItemArr[akey] := aitem;
  end
  else if atype = UpperCase('ItemLog') then
  begin
    if akey <= high(aDBRecord.ItemLog.data) then
      aDBRecord.ItemLog.data[akey] := aitem;
  end;
end;

procedure TSQlDBAdapter.setMagicData(atype: string; akey: integer; var amagic: TDBMagicData; var aDBRecord: TDBRecord);
begin
  if akey < 0 then exit;
  atype := UpperCase(atype);
  if atype = UpperCase('BasicMagic') then
  begin
    if akey <= high(aDBRecord.BasicMagicArr) then
      aDBRecord.BasicMagicArr[akey] := amagic;
  end
  else if atype = UpperCase('BasicRiseMagic') then
  begin
    if akey <= high(aDBRecord.BasicRiseMagicArr) then
      aDBRecord.BasicRiseMagicArr[akey] := amagic;
  end
  else if atype = UpperCase('HaveMagic') then
  begin
    if akey <= high(aDBRecord.HaveMagicArr) then
      aDBRecord.HaveMagicArr[akey] := amagic;
  end
  else if atype = UpperCase('HaveRiseMagic') then
  begin
    if akey <= high(aDBRecord.HaveRiseMagicArr) then
      aDBRecord.HaveRiseMagicArr[akey] := amagic;
  end
  else if atype = UpperCase('HaveMysteryMagic') then
  begin
    if akey <= high(aDBRecord.HaveMysteryMagicArr) then
      aDBRecord.HaveMysteryMagicArr[akey] := amagic;
  end;

end;

function TSQlDBAdapter.UserMagicDataSelectall(aUserName: string; var aDBRecord: TDBRecord): boolean;
var
  mStr: string;
  akey: integer;
  atype: string;
  amagic: TDBMagicData;
begin
  result := false;

  mStr := 'select * from uUserMagic';
  mStr := mStr + ' where (lusername = ''' + aUserName + ''')';
    //  + ' and (ltype = ''' + atype + ''')'
     // + ' and (lkey = ''' + inttostr(akey) + ''')';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      atype := FQuerysub.FieldByName('ltype').AsString;
      akey := FQuerysub.FieldByName('lkey').AsInteger;

      amagic.rName := COPY(FQuerysub.FieldByName('rName').AsString, 1, 20);
      amagic.rSkill := FQuerysub.FieldByName('rSkill').AsInteger;

      setMagicData(atype, akey, amagic, aDBRecord);
      FQuerysub.Next;

    end;
  end;
  FQuerysub.Close;

  result := true;
end;

////////////////////////////////////////////////////////////////////////////////

function TSQlDBAdapter.UserItemDataDELETE(aUserName: string; atype: string; akey: integer): boolean;
var
  mStr: string;
begin
  result := false;
  mStr := 'delete uUserItem';
  mStr := mStr + ' where (lusername = ''' + aUserName + ''')'
    + ' and (ltype = ''' + atype + ''')'
    + ' and (lkey = ''' + inttostr(akey) + ''')';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

  result := true;
end;

function TSQlDBAdapter.UserItemDataInsert(aUserName: string; atype: string; akey: integer; aitem: TCutItemData): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := TUserItemDataToInsertSQL(aUserName, atype, akey, @aitem);
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  if FQuerysub.RowsAffected < 1 then
  begin
    FQuerysub.Close;
    exit;
  end;
  FQuerysub.Close;
  result := true;
end;

function TSQlDBAdapter.UserItemDataUpdate(aUserName: string; atype: string; akey: integer; aitem: TDBItemData): boolean;
var
  mStr: string;
begin
  result := false;

    ////////////////////////////////////////////////////////////////////////////
    //                         修改物品
    ////////////////////////////////////////////////////////////////////////////
  mStr := TUserItemDataToUPdateSQL(aUserName, atype, akey, @aitem);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
    if UserItemDataInsert(aUserName, atype, akey, aitem) = false then
    begin
      FQuery.Close;
      exit;
    end;

  end;

  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.UserItemDataSelect(aUserName: string; atype: string; akey: integer; var aitem: TDBItemData): boolean;
var
  mStr: string;
begin
  result := false;

  mStr := 'select * from uUserItem';
  mStr := mStr + ' where (lusername = ''' + aUserName + ''')'
    + ' and (ltype = ''' + atype + ''')'
    + ' and (lkey = ''' + inttostr(akey) + ''')';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin

      aitem.rID := FQuerysub.FieldByName('rid').AsInteger;
      aitem.rName := COPY(FQuerysub.FieldByName('rName').AsString, 1, 20);
      aitem.rCount := FQuerysub.FieldByName('rCount').AsInteger;
      aitem.rColor := FQuerysub.FieldByName('rColor').AsInteger;
      aitem.rDurability := FQuerysub.FieldByName('rDurability').AsInteger;
      aitem.rDurabilityMAX := FQuerysub.FieldByName('rDurabilityMAX').AsInteger;
      aitem.rSmithingLevel := FQuerysub.FieldByName('rlevel').AsInteger;
      aitem.rAttach := FQuerysub.FieldByName('rAdditional').AsInteger;
      aitem.rlockState := FQuerysub.FieldByName('rlockState').AsInteger;
      aitem.rlocktime := FQuerysub.FieldByName('rlocktime').AsInteger;

      aitem.rSetting.rsettingcount := FQuerysub.FieldByName('rsettingcount').AsInteger;
      aitem.rSetting.rsetting1 := COPY(FQuerysub.FieldByName('rsetting1').AsString, 1, 20);
      aitem.rSetting.rsetting2 := COPY(FQuerysub.FieldByName('rsetting2').AsString, 1, 20);
      aitem.rSetting.rsetting3 := COPY(FQuerysub.FieldByName('rsetting3').AsString, 1, 20);
      aitem.rSetting.rsetting4 := COPY(FQuerysub.FieldByName('rsetting4').AsString, 1, 20);

      aitem.rDateTime := FQuerysub.FieldByName('rDateTime').AsDateTime;

      FQuerysub.Next;

      break;
    end;
  end;
  FQuerysub.Close;

  result := true;
end;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function TSQlDBAdapter.Userdelete(aPrimaryKey: string): boolean;
var
  mStr: string;
  aitemid: integer;
begin
  result := false;

    ////////////////////////////////////////////////////////////////////////////
  mStr := 'delete uUserData';
  mStr := mStr + ' where ( rPrimaryKey = ''' + aPrimaryKey + ''') ;';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;
    //                         删除物品
    ////////////////////////////////////////////////////////////////////////////
  mStr := 'delete uUserItem';
  mStr := mStr + ' where ( lusername = ''' + aPrimaryKey + ''') ;';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

  mStr := 'delete uUserKey';
  mStr := mStr + ' where ( lUserName = ''' + aPrimaryKey + ''') ;';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

  mStr := 'delete uUserMagic';
  mStr := mStr + ' where ( lusername = ''' + aPrimaryKey + ''') ;';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

  mStr := 'delete uUserQuest';
  mStr := mStr + ' where ( lUserName = ''' + aPrimaryKey + ''') ;';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  result := true;
  FQuery.Close;

end;

function TSQlDBAdapter.UserInsert(aIndexName: string; aDBRecord: PTDBRecord): Byte;
var
  i: integer;
  SqlStr: string;
begin
  result := DB_ERR;
  if UserdataIs(aIndexName) then
  begin
    result := DB_ERR_DUPLICATE;
    exit;
  end;
  aDBRecord.PrimaryKey := aIndexName;
    ////////////////////////////////////////////////////////////////////////////////
    //                                1，基本
    ////////////////////////////////////////////////////////////////////////////////
  UserdataInsert(aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                3，物品类型
    ////////////////////////////////////////////////////////////////////////////////
    //1，WearItemArr:array[0..(8) - 1] of TDBItemData; //穿戴
  SqlStr := '';
  for i := 0 to high(aDBRecord.WearItemArr) do
  begin
        //   UserItemDataInsert(aDBRecord.PrimaryKey, UpperCase('WearItem'), i, aDBRecord.WearItemArr[i]);
    SqlStr := SqlStr + TUserItemDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('WearItem'), i, @aDBRecord.WearItemArr[i]);
        //  SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;

    //2，FashionableDressArr:array[0..(8) - 1] of TDBItemData; //时装
  for i := 0 to high(aDBRecord.FashionableDressArr) do
  begin
        //  UserItemDataInsert(aDBRecord.PrimaryKey, UpperCase('FashionableDress'), i, aDBRecord.FashionableDressArr[i]);
    SqlStr := SqlStr + TUserItemDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('FashionableDress'), i, @aDBRecord.FashionableDressArr[i]);
        // SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    //3，HaveItemArr:array[0..30 - 1] of TDBItemData; // 物品栏物品 默认为30个格子
  for i := 0 to high(aDBRecord.HaveItemArr) do
  begin
        // UserItemDataInsert(aDBRecord.PrimaryKey, UpperCase('HaveItem'), i, aDBRecord.HaveItemArr[i]);
    SqlStr := SqlStr + TUserItemDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('HaveItem'), i, @aDBRecord.HaveItemArr[i]);
        // SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    //4，ItemLog       data:array[0..10 * 4 - 1] of TItemLogData;//仓库

  for i := 0 to high(aDBRecord.ItemLog.data) do
  begin
        //  UserItemDataInsert(aDBRecord.PrimaryKey, UpperCase('ItemLog'), i, aDBRecord.ItemLog.data[i]);
    SqlStr := SqlStr + TUserItemDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('ItemLog'), i, @aDBRecord.ItemLog.data[i]);
        //  SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    ////////////////////////////////////////////////////////////////////////////////
    //                                3，武功类型
    ////////////////////////////////////////////////////////////////////////////////
    //1，BasicMagicArr:array[0..10 - 1] of TDBBasicMagicData; //基本武功 一层武功
  for i := 0 to high(aDBRecord.BasicMagicArr) do
  begin
        // UserMagicDataInsert(aDBRecord.PrimaryKey, UpperCase('BasicMagic'), i, aDBRecord.BasicMagicArr[i]);
    SqlStr := SqlStr + TDBMagicDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('BasicMagic'), i, @aDBRecord.BasicMagicArr[i]);
        // SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    //2，BasicRiseMagicArr:array[0..10 - 1] of TDBBasicRiseMagicData; //新 基本二层武功 9个
  for i := 0 to high(aDBRecord.BasicRiseMagicArr) do
  begin
        // UserMagicDataInsert(aDBRecord.PrimaryKey, UpperCase('BasicRiseMagic'), i, aDBRecord.BasicRiseMagicArr[i]);
    SqlStr := SqlStr + TDBMagicDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('BasicRiseMagic'), i, @aDBRecord.BasicRiseMagicArr[i]);
        // SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    //3，HaveMagicArr:array[0..30 - 1] of TDBMagicData; //一层 30个
  for i := 0 to high(aDBRecord.HaveMagicArr) do
  begin
        // UserMagicDataInsert(aDBRecord.PrimaryKey, UpperCase('HaveMagic'), i, aDBRecord.HaveMagicArr[i]);
    SqlStr := SqlStr + TDBMagicDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('HaveMagic'), i, @aDBRecord.HaveMagicArr[i]);
        // SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    // 4，HaveRiseMagicArr:array[0..30 - 1] of TDBHaveRiseMagicData; //新 二层30个
  for i := 0 to high(aDBRecord.HaveRiseMagicArr) do
  begin
        // UserMagicDataInsert(aDBRecord.PrimaryKey, UpperCase('HaveRiseMagic'), i, aDBRecord.HaveRiseMagicArr[i]);
    SqlStr := SqlStr + TDBMagicDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('HaveRiseMagic'), i, @aDBRecord.HaveRiseMagicArr[i]);
        // SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    //5，HaveMysteryMagicArr:array[0..30 - 1] of TDBHaveMysteryMagicData; //新 掌风武功 30个
  for i := 0 to high(aDBRecord.HaveMysteryMagicArr) do
  begin
        //UserMagicDataInsert(aDBRecord.PrimaryKey, UpperCase('HaveMysteryMagic'), i, aDBRecord.HaveMysteryMagicArr[i]);
    SqlStr := SqlStr + TDBMagicDataToInsertSQL(aDBRecord.PrimaryKey, UpperCase('HaveMysteryMagic'), i, @aDBRecord.HaveMysteryMagicArr[i]);
        // SqlStr := SqlStr + #13#10 + 'go' + #13#10;
  end;
    //写数据库
  FADOCommand.Connection.StartTransaction;
  try
    FADOCommand.SQL.Clear;
    FADOCommand.SQL.Add(SqlStr);
    FADOCommand.Execute;
    FADOCommand.Connection.Commit;
  except
    FADOCommand.Connection.Rollback;
    result := DB_ERR;
    exit;
  end;

    ////////////////////////////////////////////////////////////////////////////////
    //                                4，热键
    ////////////////////////////////////////////////////////////////////////////////
  UserKEYdataInsert(aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                5，任务
    ////////////////////////////////////////////////////////////////////////////////
  UserQuestDataInsert(aDBRecord^);
  result := DB_OK;
end;

function TSQlDBAdapter.UserSelect(aIndexName: string; aDBRecord: PTDBRecord): Byte;
var
  i: integer;
begin
  result := DB_ERR;
    ////////////////////////////////////////////////////////////////////////////////
    //                                1，基本
    ////////////////////////////////////////////////////////////////////////////////
  UserdataSelect(aIndexName, aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                3，物品类型
    ////////////////////////////////////////////////////////////////////////////////
  UserItemDataSelectAll(aDBRecord.PrimaryKey, aDBRecord^);
    { //1，WearItemArr:array[0..(8) - 1] of TDBItemData; //穿戴
     for i := 0 to high(aDBRecord.WearItemArr) do
     begin
         UserItemDataSelect(aDBRecord.PrimaryKey, UpperCase('WearItem'), i, aDBRecord.WearItemArr[i]);
     end;
     //2，FashionableDressArr:array[0..(8) - 1] of TDBItemData; //时装
     for i := 0 to high(aDBRecord.FashionableDressArr) do
     begin
         UserItemDataSelect(aDBRecord.PrimaryKey, UpperCase('FashionableDress'), i, aDBRecord.FashionableDressArr[i]);
     end;
     //3，HaveItemArr:array[0..30 - 1] of TDBItemData; // 物品栏物品 默认为30个格子
     for i := 0 to high(aDBRecord.HaveItemArr) do
     begin
         UserItemDataSelect(aDBRecord.PrimaryKey, UpperCase('HaveItem'), i, aDBRecord.HaveItemArr[i]);
     end;
     //4，ItemLog       data:array[0..10 * 4 - 1] of TItemLogData;//仓库

     for i := 0 to high(aDBRecord.ItemLog.data) do
     begin
         UserItemDataSelect(aDBRecord.PrimaryKey, UpperCase('ItemLog'), i, aDBRecord.ItemLog.data[i]);
     end;
     }
     ////////////////////////////////////////////////////////////////////////////////
     //                                3，武功类型
     ////////////////////////////////////////////////////////////////////////////////
  UserMagicDataSelectall(aDBRecord.PrimaryKey, aDBRecord^);
    { //1，BasicMagicArr:array[0..10 - 1] of TDBBasicMagicData; //基本武功 一层武功
     for i := 0 to high(aDBRecord.BasicMagicArr) do
     begin
         UserMagicDataSelect(aDBRecord.PrimaryKey, UpperCase('BasicMagic'), i, aDBRecord.BasicMagicArr[i]);
     end;
     //2，BasicRiseMagicArr:array[0..10 - 1] of TDBBasicRiseMagicData; //新 基本二层武功 9个
     for i := 0 to high(aDBRecord.BasicRiseMagicArr) do
     begin
         UserMagicDataSelect(aDBRecord.PrimaryKey, UpperCase('BasicRiseMagic'), i, aDBRecord.BasicRiseMagicArr[i]);
     end;
     //3，HaveMagicArr:array[0..30 - 1] of TDBMagicData; //一层 30个
     for i := 0 to high(aDBRecord.HaveMagicArr) do
     begin
         UserMagicDataSelect(aDBRecord.PrimaryKey, UpperCase('HaveMagic'), i, aDBRecord.HaveMagicArr[i]);
     end;
     // 4，HaveRiseMagicArr:array[0..30 - 1] of TDBHaveRiseMagicData; //新 二层30个
     for i := 0 to high(aDBRecord.HaveRiseMagicArr) do
     begin
         UserMagicDataSelect(aDBRecord.PrimaryKey, UpperCase('HaveRiseMagic'), i, aDBRecord.HaveRiseMagicArr[i]);
     end;
     //5，HaveMysteryMagicArr:array[0..30 - 1] of TDBHaveMysteryMagicData; //新 掌风武功 30个
     for i := 0 to high(aDBRecord.HaveMysteryMagicArr) do
     begin
         UserMagicDataSelect(aDBRecord.PrimaryKey, UpperCase('HaveMysteryMagic'), i, aDBRecord.HaveMysteryMagicArr[i]);
     end;
     }
     ////////////////////////////////////////////////////////////////////////////////
     //                                4，热键
     ////////////////////////////////////////////////////////////////////////////////
  UserKEYdataSelect(aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                5，任务
    ////////////////////////////////////////////////////////////////////////////////
  UserQuestDataSelect(aDBRecord^);
  result := DB_OK;
end;

function TSQlDBAdapter.UserUpdate(aIndexName: string; aDBRecord: PTDBRecord): Byte;
var
  i: integer;
  sqlstr: string;
  // xx:TStringList;
begin
  result := DB_ERR;
  SqlStr := '';
    ////////////////////////////////////////////////////////////////////////////////
    //                                1，基本
    ////////////////////////////////////////////////////////////////////////////////
  //  UserdataUpdate(aDBRecord^);
  SqlStr := SqlStr + UserdataToUPdateSQL_Exec(aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                3，物品类型
    ////////////////////////////////////////////////////////////////////////////////
    //1，WearItemArr:array[0..(8) - 1] of TDBItemData; //穿戴

  for i := 0 to high(aDBRecord.WearItemArr) do
  begin
    SqlStr := SqlStr + TUserItemDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('WearItem'), i, @aDBRecord.WearItemArr[i]);
  end;

    //2，FashionableDressArr:array[0..(8) - 1] of TDBItemData; //时装
  for i := 0 to high(aDBRecord.FashionableDressArr) do
  begin
    SqlStr := SqlStr + TUserItemDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('FashionableDress'), i, @aDBRecord.FashionableDressArr[i]);
  end;
    //3，HaveItemArr:array[0..30 - 1] of TDBItemData; // 物品栏物品 默认为30个格子
  for i := 0 to high(aDBRecord.HaveItemArr) do
  begin
    SqlStr := SqlStr + TUserItemDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('HaveItem'), i, @aDBRecord.HaveItemArr[i]);
  end;
    //4，ItemLog       data:array[0..10 * 4 - 1] of TItemLogData;//仓库

  for i := 0 to high(aDBRecord.ItemLog.data) do
  begin
    SqlStr := SqlStr + TUserItemDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('ItemLog'), i, @aDBRecord.ItemLog.data[i]);
  end;
    ////////////////////////////////////////////////////////////////////////////////
    //                                3，武功类型
    ////////////////////////////////////////////////////////////////////////////////
    //1，BasicMagicArr:array[0..10 - 1] of TDBBasicMagicData; //基本武功 一层武功
  for i := 0 to high(aDBRecord.BasicMagicArr) do
  begin
    SqlStr := SqlStr + TUserBMagicDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('BasicMagic'), i, @aDBRecord.BasicMagicArr[i]);
  end;
    //2，BasicRiseMagicArr:array[0..10 - 1] of TDBBasicRiseMagicData; //新 基本二层武功 9个
  for i := 0 to high(aDBRecord.BasicRiseMagicArr) do
  begin
    SqlStr := SqlStr + TUserBMagicDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('BasicRiseMagic'), i, @aDBRecord.BasicRiseMagicArr[i]);
  end;
    //3，HaveMagicArr:array[0..30 - 1] of TDBMagicData; //一层 30个
  for i := 0 to high(aDBRecord.HaveMagicArr) do
  begin
    SqlStr := SqlStr + TUserBMagicDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('HaveMagic'), i, @aDBRecord.HaveMagicArr[i]);
  end;
    // 4，HaveRiseMagicArr:array[0..30 - 1] of TDBHaveRiseMagicData; //新 二层30个
  for i := 0 to high(aDBRecord.HaveRiseMagicArr) do
  begin
    SqlStr := SqlStr + TUserBMagicDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('HaveRiseMagic'), i, @aDBRecord.HaveRiseMagicArr[i]);
  end;
    //5，HaveMysteryMagicArr:array[0..30 - 1] of TDBHaveMysteryMagicData; //新 掌风武功 30个
  for i := 0 to high(aDBRecord.HaveMysteryMagicArr) do
  begin
    SqlStr := SqlStr + TUserBMagicDataToUPdateSQL_Exec(aDBRecord.PrimaryKey, UpperCase('HaveMysteryMagic'), i, @aDBRecord.HaveMysteryMagicArr[i]);
  end;
    ////////////////////////////////////////////////////////////////////////////////
    //                                4，热键
    ////////////////////////////////////////////////////////////////////////////////
  SqlStr := SqlStr + UserKEYdataToUPdateSQL_exec(aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                5，任务
    ////////////////////////////////////////////////////////////////////////////////
  SqlStr := SqlStr + UserQuestdataToUPdateSQL_exec(aDBRecord^);

    //写数据库
  FADOCommand.Connection.StartTransaction;
  try

    FQuery.Close;
    FQuery.SQL.Text := sqlstr;

    FQuery.ExecSQL;

    FADOCommand.Connection.Commit;
    FQuery.Close;
  except
    FADOCommand.Connection.Rollback;
    result := DB_ERR;
    FQuery.Close;
    exit;
  end;

  result := DB_OK;
end;
{
function TSQlDBAdapter.UserUpdate(aIndexName:string; aDBRecord:PTDBRecord):Byte;
var
    i               :integer;
begin
    result := DB_ERR;
    ////////////////////////////////////////////////////////////////////////////////
    //                                1，基本
    ////////////////////////////////////////////////////////////////////////////////
    UserdataUpdate(aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                3，物品类型
    ////////////////////////////////////////////////////////////////////////////////
    //1，WearItemArr:array[0..(8) - 1] of TDBItemData; //穿戴
    for i := 0 to high(aDBRecord.WearItemArr) do
    begin
        UserItemDataUpdate(aDBRecord.PrimaryKey, UpperCase('WearItem'), i, aDBRecord.WearItemArr[i]);
    end;
    //2，FashionableDressArr:array[0..(8) - 1] of TDBItemData; //时装
    for i := 0 to high(aDBRecord.FashionableDressArr) do
    begin
        UserItemDataUpdate(aDBRecord.PrimaryKey, UpperCase('FashionableDress'), i, aDBRecord.FashionableDressArr[i]);
    end;
    //3，HaveItemArr:array[0..30 - 1] of TDBItemData; // 物品栏物品 默认为30个格子
    for i := 0 to high(aDBRecord.HaveItemArr) do
    begin
        UserItemDataUpdate(aDBRecord.PrimaryKey, UpperCase('HaveItem'), i, aDBRecord.HaveItemArr[i]);
    end;
    //4，ItemLog       data:array[0..10 * 4 - 1] of TItemLogData;//仓库

    for i := 0 to high(aDBRecord.ItemLog.data) do
    begin
        UserItemDataUpdate(aDBRecord.PrimaryKey, UpperCase('ItemLog'), i, aDBRecord.ItemLog.data[i]);
    end;
    ////////////////////////////////////////////////////////////////////////////////
    //                                3，武功类型
    ////////////////////////////////////////////////////////////////////////////////
    //1，BasicMagicArr:array[0..10 - 1] of TDBBasicMagicData; //基本武功 一层武功
    for i := 0 to high(aDBRecord.BasicMagicArr) do
    begin
        UserMagicDataUpdate(aDBRecord.PrimaryKey, UpperCase('BasicMagic'), i, aDBRecord.BasicMagicArr[i]);
    end;
    //2，BasicRiseMagicArr:array[0..10 - 1] of TDBBasicRiseMagicData; //新 基本二层武功 9个
    for i := 0 to high(aDBRecord.BasicRiseMagicArr) do
    begin
        UserMagicDataUpdate(aDBRecord.PrimaryKey, UpperCase('BasicRiseMagic'), i, aDBRecord.BasicRiseMagicArr[i]);
    end;
    //3，HaveMagicArr:array[0..30 - 1] of TDBMagicData; //一层 30个
    for i := 0 to high(aDBRecord.HaveMagicArr) do
    begin
        UserMagicDataUpdate(aDBRecord.PrimaryKey, UpperCase('HaveMagic'), i, aDBRecord.HaveMagicArr[i]);
    end;
    // 4，HaveRiseMagicArr:array[0..30 - 1] of TDBHaveRiseMagicData; //新 二层30个
    for i := 0 to high(aDBRecord.HaveRiseMagicArr) do
    begin
        UserMagicDataUpdate(aDBRecord.PrimaryKey, UpperCase('HaveRiseMagic'), i, aDBRecord.HaveRiseMagicArr[i]);
    end;
    //5，HaveMysteryMagicArr:array[0..30 - 1] of TDBHaveMysteryMagicData; //新 掌风武功 30个
    for i := 0 to high(aDBRecord.HaveMysteryMagicArr) do
    begin
        UserMagicDataUpdate(aDBRecord.PrimaryKey, UpperCase('HaveMysteryMagic'), i, aDBRecord.HaveMysteryMagicArr[i]);
    end;
    ////////////////////////////////////////////////////////////////////////////////
    //                                4，热键
    ////////////////////////////////////////////////////////////////////////////////
    UserKEYdataUpdate(aDBRecord^);
    ////////////////////////////////////////////////////////////////////////////////
    //                                5，任务
    ////////////////////////////////////////////////////////////////////////////////
    UserQuestDataUpdate(aDBRecord^);
    result := DB_OK;
end;
}

procedure TSQlDBAdapter.MessageSQLProcess(aPacket: PTPacketData; aconn: TConnector);
var
  id: integer;
  akey: integer;
  Code: TWordComData;
  pp: TEmaildataclass;
  aAuctionData: TAuctionData;
  s: string;
begin
  case aPacket^.RequestMsg of

    DB_Auction:
      begin

        id := 0;
        akey := WordComData_GETbyte(aPacket.Data, id);
        case akey of
          Auction_INSERT:
            begin

            end;
          Auction_SELECT:
            begin

            end;
          Auction_DELETE:
            begin
              akey := WordComData_GETdword(aPacket.Data, id);
              if AuctionDELETE(akey) then
              begin
                Code.Size := 0;
                WordComData_ADDbyte(Code, Auction_DELETE);
                WordComData_ADDdword(Code, akey);
                aconn.AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);
              end;
            end;
          Auction_UPDATE:
            begin

              copymemory(@aAuctionData, @aPacket.Data.Data[id], sizeof(TAuctionData));
              akey := aAuctionData.rid;
              if AuctionUpdate(@aAuctionData) then
              begin
                Code.Size := 0;
                WordComData_ADDbyte(Code, Auction_UPDATE);
                WordComData_ADDdword(Code, akey);
                aconn.AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);
              end;

            end;
          Auction_SELECTLoad:
            begin
              AuctionSELECTLoad(aPacket, aconn);
            end;
        end;

      end;
    DB_Email:
      begin
        id := 0;
        akey := WordComData_GETbyte(aPacket.Data, id);
        case akey of
          Email_RegNameINSERT:
            begin
              akey := WordComData_GETdword(aPacket.Data, id);
              s := WordComData_GETstring(aPacket.Data, id);
              if EmailREGNameINSERT(s) then
              begin
                Code.Size := 0;
                WordComData_ADDbyte(Code, Email_RegNameINSERT);
                WordComData_ADDdword(Code, akey);
                aconn.AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
              end;
            end;
          Email_INSERT:
            begin

            end;
          Email_SELECT:
            begin

            end;
          Email_DELETE:
            begin
              akey := WordComData_GETdword(aPacket.Data, id);
              if EmailDELETE(akey) then
              begin
                Code.Size := 0;
                WordComData_ADDbyte(Code, Email_DELETE);
                WordComData_ADDdword(Code, akey);
                aconn.AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
              end;
            end;
          Email_UPDATE:
            begin
              pp := TEmaildataclass.Create;
              try
                pp.LoadFormWordComData(aPacket.Data, id);
                akey := pp.FID;
                if EmailUpdate(pp) then
                begin
                  Code.Size := 0;
                  WordComData_ADDbyte(Code, Email_UPDATE);
                  WordComData_ADDdword(Code, akey);
                  aconn.AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
                end;
              finally
                pp.Free;
              end;
            end;
          Email_SELECTLoad:
            begin
              EmailSELECTLoad(aPacket, aconn);
            end;
        end;

      end;
  end;

end;

function TSQlDBAdapter.CutItemDataDELETE(aid: integer): boolean;
var
  mStr: string;
begin
  result := false;
    ////////////////////////////////////////////////////////////////////////////
    //                         删除物品
    ////////////////////////////////////////////////////////////////////////////
  if aid <= 0 then exit;

  mStr := 'delete uItem';
  mStr := mStr + ' where rID = ''' + inttostr(aid) + '''';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

  result := true;
end;

function TSQlDBAdapter.AuctionDELETE(aid: integer): boolean;
var
  mStr: string;
  aitemid: integer;
begin
  result := false;

    ////////////////////////////////////////////////////////////////////////////
    //                         删除物品
    ////////////////////////////////////////////////////////////////////////////
  mStr := 'delete uAuctionItem';
  mStr := mStr + ' where lid = ''' + inttostr(aid) + '''';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;
    ////////////////////////////////////////////////////////////////////////////
    //                         删除邮件
    ////////////////////////////////////////////////////////////////////////////
  mStr := 'delete uAuction';
  mStr := mStr + ' where rid = ''' + inttostr(aid) + '''';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.EmailDELETE(aid: integer): boolean;
var
  mStr: string;
  aitemid: integer;
begin
  result := false;

    ////////////////////////////////////////////////////////////////////////////
    //                         删除物品
    ////////////////////////////////////////////////////////////////////////////

  mStr := 'delete uEMAILItem';
  mStr := mStr + ' where lid = ''' + inttostr(aid) + '''';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;

    ////////////////////////////////////////////////////////////////////////////
    //                         删除邮件
    ////////////////////////////////////////////////////////////////////////////
  mStr := 'delete uEMAIL';
  mStr := mStr + ' where fid = ''' + inttostr(aid) + '''';
  FQuery.Close;
  FQuery.SQL.text := mStr;
  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;
  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.Auction_SelectAllName: string;
var
  mStr: string;
begin
  result := '';

  mStr := 'select rid from uAuction';
    //  mStr := mStr + ' where ( rPrimaryKey = ''' + aPrimaryKey + ''') ;';
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.Open;
  except
    FQuerysub.Close;
    exit;
  end;

  if FQuerysub.RecordCount > 0 then
  begin
    FQuerysub.First;
    while not (FQuerysub.Eof) do
    begin
      result := result + inttostr(FQuerysub.FieldByName('rid').AsInteger) + #13#10;
      FQuerysub.Next;
    end;
  end;
  FQuerysub.Close;

end;

procedure TSQlDBAdapter.AuctionSELECTLoad(aPacket: PTPacketData; aconn: TConnector);
var
  mStr: string;
  pp: TAuctionData;
  Code: TWordComData;
begin
    ////////////////////////////////////////////////////////////////////////////
    //                         回复确认信息
    ////////////////////////////////////////////////////////////////////////////
  Code.Size := 0;
  WordComData_ADDbyte(Code, Auction_SELECTLoad);
  aconn.AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);
  aconn.send;
    ////////////////////////////////////////////////////////////////////////////
    //                         查所有
    ////////////////////////////////////////////////////////////////////////////
  fillchar(pp, sizeof(TAuctionData), 0);
  mStr := 'select * from uAuction';
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.Open;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RecordCount <= 0 then
  begin
    FQuery.Close;

    exit;
  end;
  FQuery.First;
  while not (FQuery.Eof) do
  begin

    pp.rid := FQuery.FieldByName('rid').AsInteger;
    pp.ritemimg := FQuery.FieldByName('ritemimg').AsInteger;
    if FQuery.FieldByName('rPricetype').AsInteger = 1 then
      pp.rPricetype := aptGOLD_Money
    else pp.rPricetype := aptGold;
    pp.rPrice := FQuery.FieldByName('rPrice').AsInteger;
    pp.rTime := FQuery.FieldByName('rTime').AsDateTime;
    pp.rMaxTime := FQuery.FieldByName('rMaxTime').AsInteger;
    pp.rBargainorName := FQuery.FieldByName('rBargainorName').AsString;

    pp.rItem.rName := '';
    pp.rItem.rID := 0;
    FQuery.Next;

        ////////////////////////////////////////////////////////////////////////////
        //                         查邮件附件物品
        ////////////////////////////////////////////////////////////////////////////
    mStr := 'select * from uAuctionItem';
    mStr := mStr + ' where lid = ''' + inttostr(pp.rid) + '''';
    FQuerysub.Close;
    FQuerysub.SQL.Clear;
    FQuerysub.SQL.Add(mStr);

    try
      FQuerysub.Open;
    except
      FQuerysub.Close;
      exit;
    end;

    if FQuerysub.RecordCount > 0 then
    begin
      FQuerysub.First;
      while not (FQuerysub.Eof) do
      begin

        PP.rItem.rID := FQuerysub.FieldByName('rid').AsInteger;
        PP.rItem.rName := COPY(FQuerysub.FieldByName('rName').AsString, 1, 20);
        PP.rItem.rCount := FQuerysub.FieldByName('rCount').AsInteger;
        PP.rItem.rColor := FQuerysub.FieldByName('rColor').AsInteger;
        PP.rItem.rDurability := FQuerysub.FieldByName('rDurability').AsInteger;
        PP.rItem.rDurabilityMAX := FQuerysub.FieldByName('rDurabilityMAX').AsInteger;
        PP.rItem.rSmithingLevel := FQuerysub.FieldByName('rlevel').AsInteger;
        PP.rItem.rAttach := FQuerysub.FieldByName('rAdditional').AsInteger;
        PP.rItem.rlockState := FQuerysub.FieldByName('rlockState').AsInteger;
        PP.rItem.rlocktime := FQuerysub.FieldByName('rlocktime').AsInteger;

        PP.rItem.rSetting.rsettingcount := FQuerysub.FieldByName('rsettingcount').AsInteger;
        PP.rItem.rSetting.rsetting1 := COPY(FQuerysub.FieldByName('rsetting1').AsString, 1, 20);
        PP.rItem.rSetting.rsetting2 := COPY(FQuerysub.FieldByName('rsetting2').AsString, 1, 20);
        PP.rItem.rSetting.rsetting3 := COPY(FQuerysub.FieldByName('rsetting3').AsString, 1, 20);
        PP.rItem.rSetting.rsetting4 := COPY(FQuerysub.FieldByName('rsetting4').AsString, 1, 20);

        PP.rItem.rDateTime := FQuerysub.FieldByName('rDateTime').AsDateTime;
        FQuerysub.Next;

        break;
      end;
    end;
    FQuerysub.Close;

        ////////////////////////////////////////////////////////////////////////////
        //                         完整邮件资料发送
        ////////////////////////////////////////////////////////////////////////////
    Code.Size := 0;
    WordComData_ADDbyte(Code, Auction_SELECT);
    copymemory(@code.data[code.size], @pp, sizeof(TAuctionData));
    code.Size := code.Size + sizeof(TAuctionData);

    aconn.AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);
    aconn.send;
  end;

  FQuery.Close;

end;

procedure TSQlDBAdapter.EmailSELECTLoad(aPacket: PTPacketData; aconn: TConnector);
var
  mStr, s: string;
  pp: TEmaildataclass;
  Code: TWordComData;
begin
    ////////////////////////////////////////////////////////////////////////////
    //                         回复确认信息
    ////////////////////////////////////////////////////////////////////////////
  Code.Size := 0;
  WordComData_ADDbyte(Code, Email_SELECTLoad);
  aconn.AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
  aconn.send;

    ////////////////////////////////////////////////////////////////////////////
    //                         获取所有人
    ////////////////////////////////////////////////////////////////////////////

  mStr := 'select rname from uEMAILREGName';
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.Open;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RecordCount >= 1 then
  begin
    FQuery.First;
    while not (FQuery.Eof) do
    begin
      s := FQuery.FieldByName('rname').AsString;
      FQuery.Next;

            ////////////////////////////////////////////////////////////////////////////
            //                         资料发送
            ////////////////////////////////////////////////////////////////////////////
      Code.Size := 0;
      WordComData_ADDbyte(Code, Email_RegNameSELECT);
      WordComData_ADDstring(Code, s);
      aconn.AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
      aconn.send;
    end;

  end;
  FQuery.Close;
    ////////////////////////////////////////////////////////////////////////////
    //                         查所有邮件
    ////////////////////////////////////////////////////////////////////////////
  pp := TEmaildataclass.Create;
  try
    mStr := 'select * from uEMAIL';
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Add(mStr);

    try
      FQuery.Open;
    except
      FQuery.Close;
      exit;
    end;

    if FQuery.RecordCount <= 0 then
    begin
      FQuery.Close;

      exit;
    end;
    FQuery.First;
    while not (FQuery.Eof) do
    begin
      pp.FID := FQuery.FieldByName('FID').AsInteger;
      pp.FDestName := FQuery.FieldByName('FDestName').AsString;
      pp.FTitle := FQuery.FieldByName('FTitle').AsString;
      pp.FEmailText := FQuery.FieldByName('FEmailText').AsString;
      pp.FsourceName := FQuery.FieldByName('FsourceName').AsString;
      pp.FTime := FQuery.FieldByName('FTime').AsDateTime;
      pp.FGOLD_Money := FQuery.FieldByName('FGOLD_Money').AsInteger;

      pp.Fbuf.rName := '';
      pp.Fbuf.rID := 0;
      FQuery.Next;

            ////////////////////////////////////////////////////////////////////////////
            //                         查邮件附件物品
            ////////////////////////////////////////////////////////////////////////////
      mStr := 'select * from uEMAILItem';
      mStr := mStr + ' where lid = ''' + inttostr(pp.FID) + '''';
      FQuerysub.Close;
      FQuerysub.SQL.Clear;
      FQuerysub.SQL.Add(mStr);

      try
        FQuerysub.Open;
      except
        FQuerysub.Close;
        exit;
      end;

      if FQuerysub.RecordCount > 0 then
      begin
        FQuerysub.First;
        while not (FQuerysub.Eof) do
        begin

          PP.Fbuf.rID := FQuerysub.FieldByName('rid').AsInteger;
          PP.Fbuf.rName := COPY(FQuerysub.FieldByName('rName').AsString, 1, 20);
          PP.Fbuf.rCount := FQuerysub.FieldByName('rCount').AsInteger;
          PP.Fbuf.rColor := FQuerysub.FieldByName('rColor').AsInteger;
          PP.Fbuf.rDurability := FQuerysub.FieldByName('rDurability').AsInteger;
          PP.Fbuf.rDurabilityMAX := FQuerysub.FieldByName('rDurabilityMAX').AsInteger;
          PP.Fbuf.rSmithingLevel := FQuerysub.FieldByName('rlevel').AsInteger;
          PP.Fbuf.rAttach := FQuerysub.FieldByName('rAdditional').AsInteger;
          PP.Fbuf.rlockState := FQuerysub.FieldByName('rlockState').AsInteger;
          PP.Fbuf.rlocktime := FQuerysub.FieldByName('rlocktime').AsInteger;

          PP.Fbuf.rSetting.rsettingcount := FQuerysub.FieldByName('rsettingcount').AsInteger;
          PP.Fbuf.rSetting.rsetting1 := COPY(FQuerysub.FieldByName('rsetting1').AsString, 1, 20);
          PP.Fbuf.rSetting.rsetting2 := COPY(FQuerysub.FieldByName('rsetting2').AsString, 1, 20);
          PP.Fbuf.rSetting.rsetting3 := COPY(FQuerysub.FieldByName('rsetting3').AsString, 1, 20);
          PP.Fbuf.rSetting.rsetting4 := COPY(FQuerysub.FieldByName('rsetting4').AsString, 1, 20);

          PP.Fbuf.rDateTime := FQuerysub.FieldByName('rDateTime').AsDateTime;
          FQuerysub.Next;

          break;
        end;
      end;
      FQuerysub.Close;

            ////////////////////////////////////////////////////////////////////////////
            //                         完整邮件资料发送
            ////////////////////////////////////////////////////////////////////////////
      Code.Size := 0;
      WordComData_ADDbyte(Code, Email_SELECT);
      pp.SaveToWordComData(Code);
      aconn.AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
      aconn.send;
    end;

    FQuery.Close;
  finally
    pp.Free;
  end;

end;

function TSQlDBAdapter.CutItemDataUPdate(atable: string; ald: integer; atemp: pTCutItemData): boolean;
var
  mStr: string;
begin
  result := false;
  if (atemp.rName = '') then
  begin
    result := true;
    exit;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         修改物品
    ////////////////////////////////////////////////////////////////////////////
  mStr := TCutItemDataTOUPdateSQL(atable, ald, atemp);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
        ////////////////////////////////////////////////////////////////////////////
        //                         失败改新增加
        ////////////////////////////////////////////////////////////////////////////
    mStr := TCutItemDataToInsertSQL(atable, ald, atemp);
    FQuerysub.Close;
    FQuerysub.SQL.Clear;
    FQuerysub.SQL.Add(mStr);

    try
      FQuerysub.ExecSQL;
    except
      FQuerysub.Close;
      exit;
    end;
    if FQuerysub.RowsAffected < 1 then
    begin
      FQuerysub.Close;
      exit;
    end;
    FQuerysub.Close;
  end;

  FQuery.Close;
  result := true;
end;

function TSQlDBAdapter.AuctionUpdate(pp: pTAuctionData): boolean;
var
  mStr: string;
begin

  result := false;
  if pp.rItem.rName <> '' then
  begin
        ////////////////////////////////////////////////////////////////////////////
        //                         修改物品
        ////////////////////////////////////////////////////////////////////////////
    if CutItemDataUPdate('uAuctionItem', pp.rid, @pp.rItem) = false then
    begin
      exit;
    end;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         修改
    ////////////////////////////////////////////////////////////////////////////
  mStr := TAuctionDataTOUPdateSQL(pp);
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
        ////////////////////////////////////////////////////////////////////////////
        //                         失败改新增加
        ////////////////////////////////////////////////////////////////////////////
    mStr := TAuctionDataToInsertSQL(pp);
    FQuerysub.Close;
    FQuerysub.SQL.Clear;
    FQuerysub.SQL.Add(mStr);

    try
      FQuerysub.ExecSQL;
    except
      FQuerysub.Close;
      exit;
    end;
    if FQuerysub.RowsAffected < 1 then
    begin
      FQuerysub.Close;
      exit;
    end;
    FQuerysub.Close;
  end;

  FQuery.Close;

  result := true;
end;

function TSQlDBAdapter.EmailREGNameINSERT(s: string): boolean;
var
  mStr: string;
begin
    ////////////////////////////////////////////////////////////////////////////
    //                         查看
    ////////////////////////////////////////////////////////////////////////////
  result := false;
  mStr := 'select * from uEMAILREGName ';
  mStr := mStr + ' where rname = ''' + s + ''' ;';
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.Open;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RecordCount >= 1 then
  begin
    FQuery.Close;
    result := true;
    exit;
  end;

  FQuery.Close;
    ////////////////////////////////////////////////////////////////////////////
    //                         新增加
    ////////////////////////////////////////////////////////////////////////////

  mStr := 'insert into uEMAILREGName ( ';
  mStr := mStr + ' rname';
  mStr := mStr + '  )';
  mStr := mStr + ' values ( ';
  mStr := mStr + '''' + s + ''' ';
  mStr := mStr + ' ) ;';

  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQuerysub.SQL.Add(mStr);

  try
    FQuerysub.ExecSQL;
  except
    FQuerysub.Close;
    exit;
  end;
  if FQuerysub.RowsAffected < 1 then
  begin
    FQuerysub.Close;
    exit;
  end;
  FQuerysub.Close;
  result := true;
end;

function TSQlDBAdapter.EmailUpdate(pp: TEmaildataclass): boolean;
var
  mStr: string;
begin

  result := false;
  if pp.Fbuf.rName <> '' then
  begin
        ////////////////////////////////////////////////////////////////////////////
        //                         修改邮件物品
        ////////////////////////////////////////////////////////////////////////////
    if CutItemDataUPdate('uEmailitem', pp.FID, @pp.Fbuf) = false then
    begin
      exit;
    end;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                         修改邮件
    ////////////////////////////////////////////////////////////////////////////
  mStr := pp.GetupdateSQL;
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
    FQuery.Close;
    exit;
  end;

  if FQuery.RowsAffected < 1 then
  begin
        ////////////////////////////////////////////////////////////////////////////
        //                         失败改新增加
        ////////////////////////////////////////////////////////////////////////////
    mStr := pp.GetInsertSQL;
    FQuerysub.Close;
    FQuerysub.SQL.Clear;
    FQuerysub.SQL.Add(mStr);

    try
      FQuerysub.ExecSQL;
    except
      FQuerysub.Close;
      FQuery.Close;
      exit;
    end;
    if FQuerysub.RowsAffected < 1 then
    begin
      FQuerysub.Close;
      FQuery.Close;
      exit;
    end;
    FQuerysub.Close;
  end;

  FQuery.Close;

  result := true;
end;

constructor TSQlDBAdapter.Create(atemp: TMyConnection);
begin

  FQuery := TMyQuery.Create(nil);
  FQuery.Connection := atemp;
  FQuery.Close;
  FQuery.SQL.Clear;
  FQuerysub := TMyQuery.Create(nil);
  FQuerysub.Connection := atemp;
  FQuerysub.Close;
  FQuerysub.SQL.Clear;
  FQueryRole := TMyQuery.Create(nil);
  FQueryRole.Connection := atemp;

  FADOCommand := TMyCommand.Create(nil);
  FADOCommand.Connection := atemp;

end;

destructor TSQlDBAdapter.Destroy;
begin
  FQuery.Free;
  FQuerysub.Free;
  FQueryRole.Free;
  FADOCommand.Free;
  inherited Destroy;
end;

function TSQlDBAdapter.New_LG_Delete(aIndexName: string): Byte;
begin

end;

function TSQlDBAdapter.New_LG_Insert(aIndexName: string;
  aLGRecord: PTLGRecord): Byte;
var
  i: Integer;
  mStr, str: string;
  uPrimaryKey, uPassword: string;
  uCharInfo: array[0..5 - 1] of string;
  uIpAddr, uUserName, uBirth, uTelephone, uMakeDate: string;
  uLastDate, uAddress, uEmail, uNativeNumber, uMasterKey: string;
  uParentName, uParentNativeNumber: string;
  uCharName, uServerName: string;
  LGRecord: TLGRecord;
begin
  Result := DB_OK;
  if aIndexName = '' then
  begin
    Result := DB_ERR_INVALIDDATA;
    exit;
  end;

  if New_LG_Select(aIndexName, @LGRecord) = DB_OK then
  begin
    Result := DB_ERR_DUPLICATE;
    exit;
  end;

  uPrimaryKey := aLGRecord^.PrimaryKey;
  uPassWord := aLGRecord^.PassWord;

  for i := 0 to 5 - 1 do
  begin
    Str := aLGRecord^.CharInfo[i].CharName + ':' + aLGRecord^.CharInfo[i].ServerName;
    if str = ':' then str := '';
    uCharInfo[i] := str;
  end;

  uIpAddr := aLGRecord^.IpAddr;
  uMakeDate := aLGRecord^.MakeDate;
  uLastDate := aLGRecord^.LastDate;
  uUserName := aLGRecord^.UserName;
  uNativeNumber := aLGRecord^.NativeNumber;
  uMasterKey := aLGRecord^.MasterKey;
  uEmail := aLGRecord^.Email;
  uTelePhone := aLGRecord^.Phone;
  uParentName := aLGRecord^.ParentName;
  uParentNativeNumber := aLGRecord^.ParentNativeNumber;

  uBirth := '';
  uAddress := '';

    // account, password, char1, char2, char3, char4, char5, ipaddr, username, birth
    // telephone, makedate, lastdate, address, email, nativenumber, masterkey
  mStr := 'insert into mqn_user ( ';
  mStr := mStr + ' username, PassWord,';
  mStr := mStr + ' Email, Telephone, RealName, IdCard, PassQuestion, PassAnswer,';
  mStr := mStr + ' addtime, baLance,  dianQuan, logintime, Regip )';
  mStr := mStr + ' values ( ';
  mStr := mStr + '''' + uPrimaryKey + ''',';
  mStr := mStr + '''' + uPassword + ''',';
  mStr := mStr + '''' + uEmail + ''',';
  mStr := mStr + '''' + uTelephone + ''',';
  mStr := mStr + '''' + uUserName + ''',';
  mStr := mStr + '''' + uNativeNumber + ''',';
  mStr := mStr + '''' + uMasterKey + ''',';
  mStr := mStr + '''' + uMasterKey + ''',';
  mStr := mStr + '' + IntToStr(0) + ','; //时间戳需要修改
  mStr := mStr + '''' + '0' + ''',';
  mStr := mStr + '''' + '0' + ''',';
  mStr := mStr + '''' + '0' + ''',';
  mStr := mStr + '''' + uIpAddr + ''' );';

    // FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add(mStr);

  try
    FQuery.ExecSQL;
  except
        // frmMain.AddSQL(mStr);
  end;

  if FQuery.RowsAffected < 1 then
  begin
    Result := DB_ERR_DUPLICATE;
  end;

  FQuery.Close;
end;

function TSQlDBAdapter.New_LG_Select(aIndexName: string;
  aLGRecord: PTLGRecord): Byte;
var
  i: Integer;
  mStr, str: string;
  uPrimaryKey, uPassword: string;
  uCharInfo: array[0..5 - 1] of string;
  uIpAddr, uUserName, uBirth, uTelephone, uMakeDate: string;
  uParentName, uParentNativeNumber: string;
  uLastDate, uAddress, uEmail, uNativeNumber, uMasterKey: string;
  uCharName, uServerName: string;
  _mysql: TMyQuery;
begin
  Result := DB_OK;
  if aIndexName = '' then
  begin
    Result := DB_ERR_INVALIDDATA;
    exit;
  end;

  //读取帐号部分
  if not frmMain.AccConn.Connected then
  begin
    frmMain.AccConn.Connect;    
    Result := DB_ERR;
    exit;
  end;
  _mysql := TMyQuery.Create(nil);
  if frmMain.AccConn.Connected then
  begin
    mStr := 'select id,username,password,Block from mqn_user where username = ''' + aIndexName + ''';';
    _mysql.Connection := frmMain.AccConn;
    _mysql.Close;
    _mysql.SQL.Clear;
    _mysql.SQL.Add(mStr);
    try
      _mysql.Open;
    except
        //  frmMain.AddSQL(mStr);
    end;
  end;
  //没有获取到数据
  if _mysql.RecordCount <= 0 then
  begin
    _mysql.Close;
    Result := DB_ERR_NOTFOUND;
    exit;
  end;
  //获取到数据
  _mysql.First;
  while not (_mysql.Eof) do
  begin
    uPrimaryKey := _mysql.Fields[1].AsString; //username
    uPassword := _mysql.Fields[2].AsString; //PassWord
    if (_mysql.Fields[3].AsBoolean = true) then //Block
    begin
      _mysql.Close;
      Result := DB_BLOCK;
      exit;
    end;
    //读取人物数据
    if not frmMain.MyConn.Connected then
    begin
      _mysql.Close;
      Result := DB_ERR;
      exit;
    end;
    FQueryRole.Close;
    FQueryRole.SQL.Clear;
    FQueryRole.SQL.Add('select c_CharName,c_charserver from mqn_values where c_account = "' + uPrimaryKey + '" limit 0, 5;');
    FQueryRole.Open;
    FQueryRole.First;
    i := 0;
    while not FQueryRole.Eof do
    begin
      uCharInfo[i] := FQueryRole.Fields[0].AsString + ':' + FQueryRole.Fields[1].AsString; //c_CharName
      FQueryRole.Next;
      Inc(i);
    end;

    uIpAddr := '';
    uUserName := '';
    uBirth := '';
    uTelephone := '';
    uMakeDate := '';
    uLastDate := '';
    uAddress := '';
    uEmail := '';
    uNativeNumber := '';
    uMasterKey := '';
    uParentName := '';
    uParentNativeNumber := '';

    aLGRecord^.PrimaryKey := Copy(uPrimaryKey, 1, 20);
    aLGRecord^.PassWord := Copy(uPassWord, 1, 20);

    for i := 0 to 5 - 1 do
    begin
      str := uCharInfo[i];
      str := GetValidStr3(str, uCharName, ':');
      str := GetValidStr3(str, uServerName, ':');

      aLGRecord^.CharInfo[i].CharName := Copy(uCharName, 1, 20);
      aLGRecord^.CharInfo[i].ServerName := Copy(uServerName, 1, 20);
    end;

    aLGRecord^.IpAddr := Copy(uIpAddr, 1, 16);
    aLGRecord^.MakeDate := Copy(uMakeDate, 1, 20);
    aLGrecord^.LastDate := Copy(uLastDate, 1, 20);
    aLGRecord^.Birth := Copy(uBirth, 1, 20);
    aLGRecord^.Address := Copy(uAddress, 1, 50);
    aLGRecord^.UserName := Copy(uUserName, 1, 20);
    aLGRecord^.NativeNumber := Copy(uNativeNumber, 1, 20);
    aLGRecord^.MasterKey := Copy(uMasterKey, 1, 20);
    aLGRecord^.Email := Copy(uEmail, 1, 50);
    aLGRecord^.Phone := Copy(uTelePhone, 1, 20);
    aLGRecord^.ParentName := Copy(uParentName, 1, 20);
    aLGRecord^.ParentNativeNumber := Copy(uParentNativeNumber, 1, 20);

    _mysql.Next;

    break;
  end;

  _mysql.Free;

//  FQuery.Close;
//  FQuery.SQL.Clear;
//  FQuery.SQL.Add('set names "gbk"');
//  FQuery.ExecSQL;
//
//  mStr := 'select id,username,password,Block from mqn_user where username = ''' + aIndexName + ''';';
//  FQuery.Close;
//  FQuery.SQL.Clear;
//  FQuery.SQL.Add(mStr);
//
//  try
//    FQuery.Open;
//  except
//        //  frmMain.AddSQL(mStr);
//  end;
//
//  if FQuery.RecordCount <= 0 then
//  begin
//    FQuery.Close;
//    Result := DB_ERR_NOTFOUND;
//    exit;
//  end;
//
//  FQuery.First;
//  while not (FQuery.Eof) do
//  begin
//    uPrimaryKey := FQuery.Fields[1].AsString; //username
//    uPassword := FQuery.Fields[2].AsString; //PassWord
//    if (FQuery.Fields[3].AsBoolean = true) then //Block
//    begin
//      FQuery.Close;
//      Result := DB_BLOCK;
//      exit;
//    end;
//    //读取人物数据
//    FQueryRole.Close;
//    FQueryRole.SQL.Clear;
//    FQueryRole.SQL.Add('select c_CharName,c_charserver from mqn_values where c_account = ''' + uPrimaryKey + ''';');
//    FQueryRole.Open;
//    FQueryRole.First;
//    i := 0;
//    while not FQueryRole.Eof do
//    begin
//      uCharInfo[i] := FQueryRole.Fields[0].AsString + ':' + FQueryRole.Fields[1].AsString; //c_CharName
//      FQueryRole.Next;
//      Inc(i);
//    end;
//
//    uIpAddr := '';
//    uUserName := '';
//    uBirth := '';
//    uTelephone := '';
//    uMakeDate := '';
//    uLastDate := '';
//    uAddress := '';
//    uEmail := '';
//    uNativeNumber := '';
//    uMasterKey := '';
//    uParentName := '';
//    uParentNativeNumber := '';
//
//    aLGRecord^.PrimaryKey := Copy(uPrimaryKey, 1, 20);
//    aLGRecord^.PassWord := Copy(uPassWord, 1, 20);
//
//    for i := 0 to 5 - 1 do
//    begin
//      str := uCharInfo[i];
//      str := GetValidStr3(str, uCharName, ':');
//      str := GetValidStr3(str, uServerName, ':');
//
//      aLGRecord^.CharInfo[i].CharName := Copy(uCharName, 1, 20);
//      aLGRecord^.CharInfo[i].ServerName := Copy(uServerName, 1, 20);
//    end;
//
//    aLGRecord^.IpAddr := Copy(uIpAddr, 1, 16);
//    aLGRecord^.MakeDate := Copy(uMakeDate, 1, 20);
//    aLGrecord^.LastDate := Copy(uLastDate, 1, 20);
//    aLGRecord^.Birth := Copy(uBirth, 1, 20);
//    aLGRecord^.Address := Copy(uAddress, 1, 50);
//    aLGRecord^.UserName := Copy(uUserName, 1, 20);
//    aLGRecord^.NativeNumber := Copy(uNativeNumber, 1, 20);
//    aLGRecord^.MasterKey := Copy(uMasterKey, 1, 20);
//    aLGRecord^.Email := Copy(uEmail, 1, 50);
//    aLGRecord^.Phone := Copy(uTelePhone, 1, 20);
//    aLGRecord^.ParentName := Copy(uParentName, 1, 20);
//    aLGRecord^.ParentNativeNumber := Copy(uParentNativeNumber, 1, 20);
//
//    FQuery.Next;
//
//    break;
//  end;
//
//  FQuery.Close;
end;

function TSQlDBAdapter.New_Lg_SelectAllName: string;
begin

end;

function TSQlDBAdapter.New_LG_Update(aIndexName: string;
  aLGRecord: PTLGRecord): Byte;
var
  i, j: Integer;
  mStr, str: string;
  uPrimaryKey, uPassword: string;
  uCharInfo: array[0..5 - 1] of string;
  uIpAddr, uUserName, uBirth, uTelephone, uMakeDate: string;
  uLastDate, uAddress, uEmail, uNativeNumber, uMasterKey: string;
  uParentName, uParentNativeNumber: string;
  uCharName, uServerName: string;
  LGRecord: TLGRecord;
  have: Boolean;   
  _mysql: TMyQuery;
begin
  Result := DB_OK;
  if aIndexName = '' then
  begin
    Result := DB_ERR_INVALIDDATA;
    exit;
  end;

  if New_LG_Select(aIndexName, @LGRecord) <> DB_OK then
  begin
    Result := DB_ERR_NOTFOUND;
    exit;
  end;

  uPrimaryKey := aLGRecord^.PrimaryKey;
  uPassWord := aLGRecord^.PassWord;
  uLastDate := aLGRecord^.LastDate;
  for i := 0 to 5 - 1 do
  begin
    have := false;
    uCharName := aLGRecord^.CharInfo[i].CharName;
    uServerName := aLGRecord^.CharInfo[i].ServerName;

    for j := 0 to 5 - 1 do
    begin
      if (uCharName + ':' + uServerName = LGRecord.CharInfo[j].CharName + ':' + LGRecord.CharInfo[j].ServerName) then
      begin
        have := True;
        Break;
      end;
    end;
    if not have then
    begin
      Break;
    end;
   // uCharInfo[i] := str;
  end;
  //更新帐号登录时间
  begin
    if not frmMain.AccConn.Connected then
    begin
      frmMain.AccConn.Connect;
    end;
    _mysql := TMyQuery.Create(nil);
    if frmMain.AccConn.Connected then
    begin
      mStr := 'update mqn_user set ';
      mStr := mStr + ' logintime = ''' + uLastDate + '''';
      mStr := mStr + ' where username = ''' + uPrimaryKey + ''';';
      _mysql.Connection := frmMain.AccConn;
      _mysql.Close;
      _mysql.SQL.Clear;
      _mysql.SQL.Add(mStr);
      try
        _mysql.ExecSQL;
      except
        //  frmMain.AddSQL(mStr);
      end;
    end;    
    if _mysql.RowsAffected < 1 then
    begin
      Result := DB_ERR_NOTFOUND;
    end;
    _mysql.Free;
  end;

  if not have then
  begin
    mStr := 'insert into mqn_values ( ';
    mStr := mStr + ' c_account, c_CharName,';
    mStr := mStr + ' c_charserver  )';
    mStr := mStr + ' values ( ';
    mStr := mStr + '''' + uPrimaryKey + ''',';
    mStr := mStr + '''' + uCharName + ''',';
    mStr := mStr + '''' + uServerName + ''' );';
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Add(mStr);
    try
      FQuery.ExecSQL;
    except
        //        frmMain.AddSQL(mStr);
    end;
    if FQuery.RowsAffected < 1 then
    begin
      Result := DB_ERR_NOTFOUND;
    end;
    FQuery.Close;
  end;
end;

function TSQlDBAdapter.New_LG_UpdateChar(aIndexName: string;
  aLGRecord: PTLGRecord): Byte;
var
  i, j: Integer;
  mStr, str: string;
  uPrimaryKey, uPassword: string;
  uCharInfo: array[0..5 - 1] of string;
  uIpAddr, uUserName, uBirth, uTelephone, uMakeDate: string;
  uLastDate, uAddress, uEmail, uNativeNumber, uMasterKey: string;
  uParentName, uParentNativeNumber: string;
  uCharName, uServerName: string;
  LGRecord: TLGRecord;
  have: Boolean;
begin
  Result := DB_OK;
  if aIndexName = '' then
  begin
    Result := DB_ERR_INVALIDDATA;
    exit;
  end;

  FQuery.Close;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('set names "gbk"');
  FQuery.ExecSQL;

  uPrimaryKey := aLGRecord^.PrimaryKey;

  uLastDate := DateTimeToStr(Now);
  uCharName := aLGRecord^.UserName;
  begin
    mStr := 'update mqn_values set ';

    mStr := mStr + ' c_logintime = ''' + uLastDate + '''';
    mStr := mStr +
      ' where (c_account = ''' + uPrimaryKey + ''')'
      + ' and (c_CharName = ''' + uCharName + ''')';
    FQuery.Close;
    FQuery.SQL.Clear;
    FQuery.SQL.Add(mStr);

    try
      FQuery.ExecSQL;
    except
        //        frmMain.AddSQL(mStr);
    end;

    if FQuery.RowsAffected < 1 then
    begin
      Result := DB_ERR_NOTFOUND;
    end;

    FQuery.Close;
  end;

end;

end.

