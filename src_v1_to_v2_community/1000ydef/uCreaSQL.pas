unit uCreaSQL;

interface
uses
    Windows, Sysutils, Classes, Deftype;

function TCutItemDataTOUPdateSQL(atable:string; alid:integer; atemp:pTCutItemData):string;
function TCutItemDataToInsertSQL(atable:string; ald:integer; atemp:pTCutItemData):string;

function TAuctionDataTOUPdateSQL(atemp:pTAuctionData):string;
function TAuctionDataToInsertSQL(atemp:pTAuctionData):string;

function TUserItemDataToInsertSQL(ausername:string; atype:string; akey:integer; atemp:pTCutItemData ):string;
function TUserItemDataToUPdateSQL_Exec(ausername:string; atype:string; akey:integer; atemp:pTCutItemData ):string;
function TUserItemDataToUPdateSQL(ausername:string; atype:string; akey:integer; atemp:pTCutItemData ):string;

function TDBMagicDataToInsertSQL(ausername:string; atype:string; akey:integer; atemp:pTDBMagicData):string;
function TUserBMagicDataToUPdateSQL(ausername:string; atype:string; akey:integer; atemp:pTDBMagicData ):string;
 function TUserBMagicDataToUPdateSQL_Exec(ausername:string; atype:string; akey:integer; atemp:pTDBMagicData ):string;

function UserdataToInsertSQL(var aDBRecord:TDBRecord):string;
function UserdataToUPdateSQL(var aDBRecord:TDBRecord):string;
 function UserdataToUPdateSQL_Exec(var aDBRecord:TDBRecord):string;

function UserkeydataToInsertSQL(var aDBRecord:TDBRecord):string;
function UserKEYdataToUPdateSQL(var aDBRecord:TDBRecord):string;
function UserKEYdataToUPdateSQL_exec(var aDBRecord:TDBRecord):string;

function UserQuestdataToUPdateSQL(var aDBRecord:TDBRecord):string;
 function UserQuestdataToUPdateSQL_exec(var aDBRecord:TDBRecord):string;
function UserQuestdataToInsertSQL(var aDBRecord:TDBRecord):string;

function TPaidDataToUPdateSQL(var apaid:TPaidData):string;
function TPaidDataToInsertSQL(var apaid:TPaidData):string;

function strTOpaidtype(str:string):TPaidType;
function PaidtypeTostr(rPaidType:TPaidType):string;
implementation

uses StrUtils;

function strTOpaidtype(str:string):TPaidType;
begin

    if str = 'pt_none' then
        result := pt_none
    else if str = 'pt_invalidate' then
        result := pt_invalidate
    else if str = 'pt_validate' then
        result := pt_validate
    else if str = 'pt_test' then
        result := pt_test
    else if str = 'pt_timepay' then
        result := pt_timepay
            {else if str = 'pt_namemoney' then
result := pt_namemoney
else if str = 'pt_nametime' then
result := pt_nametime
else if str = 'pt_ipmoney' then
result := pt_ipmoney
else if str = 'pt_iptime' then
result := pt_iptime}
    else result := pt_none;
end;

function PaidtypeTostr(rPaidType:TPaidType):string;
begin
    case rPaidType of
        pt_none:result := 'pt_none';
        pt_invalidate:result := 'pt_invalidate';
        pt_validate:result := 'pt_validate';
        pt_test:result := 'pt_test';
        pt_timepay:result := 'pt_timepay';
        //  pt_namemoney:result := 'pt_namemoney';
        //  pt_nametime:result := 'pt_nametime';
         // pt_ipmoney:result := 'pt_ipmoney';
         // pt_iptime:result := 'pt_iptime';
    else result := 'pt_none';
    end;
end;

function TPaidDataToInsertSQL(var apaid:TPaidData):string;
begin
    with apaid do
    begin

        result := 'insert into uPaid ( ';

        result := result + ' rloginid, rPaidType, rRemainDay, rmaturity )';
        result := result + ' values ( ';
        result := result + '''' + (rloginid) + '''';

        result := result + ' , ''' + PaidtypeTostr(rPaidType) + '''';
        result := result + ' , ''' + inttostr(rRemainDay) + '''';
        result := result + ' , ''' + DateTimeToStr(rmaturity) + '''';

        result := result + ' ) ;';
    end;
end;

function UserQuestdataToInsertSQL(var aDBRecord:TDBRecord):string;
var
    i               :integer;
begin
    with aDBRecord do
    begin

        result := 'insert into uUserQuest ( ';
        result := result + ' lUserName, CompleteQuestNo, CurrentQuestNo, Queststep, SubCurrentQuestNo, SubQueststep,';
        result := result + ' Questtemp0, Questtemp1, Questtemp2, Questtemp3, Questtemp4, Questtemp5, Questtemp6,';
        result := result + ' Questtemp7, Questtemp8, Questtemp9, Questtemp10, Questtemp11, Questtemp12,';
        result := result + ' Questtemp13, Questtemp14, Questtemp15, Questtemp16, Questtemp17, Questtemp18, Questtemp19 )';
        result := result + ' values ( ';
        result := result + '''' + (PrimaryKey) + '''';

        result := result + ' , ''' + inttostr(CompleteQuestNo) + '''';
        result := result + ' , ''' + inttostr(CurrentQuestNo) + '''';
        result := result + ' , ''' + inttostr(Queststep) + '''';
        result := result + ' , ''' + inttostr(SubCurrentQuestNo) + '''';
        result := result + ' , ''' + inttostr(SubQueststep) + '''';
        for i := 0 to 19 do
        begin
            result := result + ' , ''' + inttostr(ShortcutKeyArr[i]) + '''';
        end;

        result := result + ' ) ;';
    end;
end;

function TPaidDataToUPdateSQL(var apaid:TPaidData):string;
begin
    with apaid do
    begin

        result := 'update  uPaid  set ';
        result := result + '  rPaidType = ''' + PaidtypeTostr(rPaidType) + '''';
        result := result + ' , rRemainDay = ''' + inttostr(rRemainDay) + '''';
        result := result + ' , rmaturity = ''' + datetimetostr(rmaturity) + '''';

        result := result + ' where (rloginid = ''' + rLoginId + ''') ;';

    end;
end;

function UserQuestdataToUPdateSQL_exec(var aDBRecord:TDBRecord):string;
var
    i               :integer;
begin
    with aDBRecord do
    begin

        result := 'exec 角色任务更新 ';

        result := result + '''' + PrimaryKey + ''',';
        result := result + '' + inttostr(CompleteQuestNo) + ',';
        result := result + '' + inttostr(CurrentQuestNo) + ',';
        result := result + '' + inttostr(Queststep) + ',';
        result := result + '' + inttostr(SubCurrentQuestNo) + ',';
        result := result + '' + inttostr(SubQueststep) + ',';
        for i := 0 to 19 do
        begin
            result := result + '' + inttostr(QuesttempARR[i]);
            if i = 19 then result := result + '; '
            else result := result + ',';
        end;

    end;
end;

function UserQuestdataToUPdateSQL(var aDBRecord:TDBRecord):string;
var
    i               :integer;
begin
    with aDBRecord do
    begin

        result := 'update  uUserQuest  set ';

        result := result + '  CompleteQuestNo = ''' + inttostr(CompleteQuestNo) + '''';
        result := result + ' , CurrentQuestNo = ''' + inttostr(CurrentQuestNo) + '''';
        result := result + ' , Queststep = ''' + inttostr(Queststep) + '''';
        result := result + ' , SubCurrentQuestNo = ''' + inttostr(SubCurrentQuestNo) + '''';
        result := result + ' , SubQueststep = ''' + inttostr(SubQueststep) + '''';
        for i := 0 to 19 do
        begin
            result := result + ' , Questtemp' + inttostr(i) + ' = ''' + inttostr(QuesttempARR[i]) + '''';
        end;

        result := result + ' where (lusername = ''' + PrimaryKey + ''') ; ';

    end;
end;

function UserKEYdataToUPdateSQL_exec(var aDBRecord:TDBRecord):string;
var
    i               :integer;
begin
    with aDBRecord do
    begin

        result := 'exec  角色热键更新 ';
        result := result + '''' + PrimaryKey + ''',';
        for i := 0 to 9 do
        begin
            result := result + '' + inttostr(KeyArr[i]) + ',';
        end;
        for i := 0 to 9 do
        begin
            result := result + '' + inttostr(ShortcutKeyArr[i]);
            if i = 9 then result := result + '; '
            else result := result + ',';
        end;
    end;
end;

function UserKEYdataToUPdateSQL(var aDBRecord:TDBRecord):string;
var
    i               :integer;
begin
    with aDBRecord do
    begin

        result := 'update  uUserKey  set ';

        result := result + '  key0 = ''' + inttostr(KeyArr[0]) + '''';
        for i := 1 to 9 do
        begin
            result := result + ' , key' + inttostr(i) + ' = ''' + inttostr(KeyArr[i]) + '''';
        end;
        for i := 0 to 9 do
        begin
            result := result + ' , Shortcutkey' + inttostr(i) + ' = ''' + inttostr(ShortcutKeyArr[i]) + '''';
        end;

        result := result + ' where (lusername = ''' + PrimaryKey + ''') ; ';

    end;
end;

function UserkeydataToInsertSQL(var aDBRecord:TDBRecord):string;
var
    i               :integer;
begin
    with aDBRecord do
    begin

        result := 'insert into uUserKey ( ';
        result := result + ' lUserName,';
        result := result + ' key0, key1, key2, key3, key4, key5, key6, key7, key8, key9,';
        result := result + ' Shortcutkey0, Shortcutkey1, Shortcutkey2, Shortcutkey3, Shortcutkey4,';
        result := result + ' Shortcutkey5, Shortcutkey6, Shortcutkey7, Shortcutkey8, Shortcutkey9 )';
        result := result + ' values ( ';
        result := result + '''' + (PrimaryKey) + '''';
        for i := 0 to 9 do
        begin
            result := result + ' , ''' + inttostr(KeyArr[i]) + '''';
        end;
        for i := 0 to 9 do
        begin
            result := result + ' , ''' + inttostr(ShortcutKeyArr[i]) + '''';
        end;

        result := result + ' ) ;';
    end;
end;

function UserdataToUPdateSQL(var aDBRecord:TDBRecord):string;
begin
    with aDBRecord do
    begin

        result := 'update  uUserData  set ';

        //result := result + ' rid, rPrimaryKey, rMasterName, rPassword, rGroupKey,';
        result := result + ' rid = ''' + inttostr(id) + ''',';
        // result := result + ' rPrimaryKey = ''' + (PrimaryKey) + ''',';
        result := result + ' rMasterName = ''' + (MasterName) + ''',';
        result := result + ' rPassword = ''' + (Password) + ''',';
        result := result + ' rGroupKey = ''' + inttostr(GroupKey) + ''',';
        //result := result + ' rGuild, rLastDate, rCreateDate, rSex, rServerId, rx, ry, ';
        result := result + ' rGuild = ''' + (Guild) + ''',';
        result := result + ' rLastDate = ''' + datetimetostr(LastDate) + ''',';
        result := result + ' rCreateDate = ''' + datetimetostr(CreateDate) + ''',';
        result := result + ' rsex = ''' + IfThen(sex, '男', '女') + ''',';
        result := result + ' rServerId = ''' + inttostr(ServerId) + ''',';
        result := result + ' rx = ''' + inttostr(x) + ''',';
        result := result + ' ry = ''' + inttostr(y) + ''',';
        //  result := result + ' rGOLD_Money, rprestige, rLight, rDark, rEnergy, rInPower, ';
        result := result + ' rGOLD_Money = ''' + inttostr(GOLD_Money) + ''',';
        result := result + ' rprestige = ''' + inttostr(prestige) + ''',';
        result := result + ' rLight = ''' + inttostr(Light) + ''',';
        result := result + ' rDark = ''' + inttostr(Dark) + ''',';
        result := result + ' rEnergy = ''' + inttostr(Energy) + ''',';
        result := result + ' rInPower = ''' + inttostr(InPower) + ''',';
        // result := result + ' rOutPower, rMagic, rLife, rTalent, rGoodChar, rBadChar, ';
        result := result + ' rOutPower = ''' + inttostr(OutPower) + ''',';
        result := result + ' rMagic = ''' + inttostr(Magic) + ''',';
        result := result + ' rLife = ''' + inttostr(Life) + ''',';
        result := result + ' rTalent = ''' + inttostr(Talent) + ''',';
        result := result + ' rGoodChar = ''' + inttostr(GoodChar) + ''',';
        result := result + ' rBadChar = ''' + inttostr(BadChar) + ''',';
        //result := result + ' rAdaptive, rRevival, rImmunity, rVirtue, rCurEnergy, ';
        result := result + ' rAdaptive = ''' + inttostr(Adaptive) + ''',';
        result := result + ' rRevival = ''' + inttostr(Revival) + ''',';
        result := result + ' rImmunity = ''' + inttostr(Immunity) + ''',';
        result := result + ' rVirtue = ''' + inttostr(Virtue) + ''',';
        result := result + ' rCurEnergy = ''' + inttostr(CurEnergy) + ''',';
        // result := result + ' rCurInPower, rCurOutPower, rCurMagic, rCurLife, rCurHealth,';
        result := result + ' rCurInPower = ''' + inttostr(CurInPower) + ''',';
        result := result + ' rCurOutPower = ''' + inttostr(CurOutPower) + ''',';
        result := result + ' rCurMagic = ''' + inttostr(CurMagic) + ''',';
        result := result + ' rCurLife = ''' + inttostr(CurLife) + ''',';
        result := result + ' rCurHealth = ''' + inttostr(CurHealth) + ''',';
        // result := result + ' rCurSatiety, rCurPoisoning, rCurHeadSeek, rCurArmSeek, rCurLegSeek,';
        result := result + ' rCurSatiety = ''' + inttostr(CurSatiety) + ''',';
        result := result + ' rCurPoisoning = ''' + inttostr(CurPoisoning) + ''',';
        result := result + ' rCurHeadSeek = ''' + inttostr(CurHeadSeek) + ''',';
        result := result + ' rCurArmSeek = ''' + inttostr(CurArmSeek) + ''',';
        result := result + ' rCurLegSeek = ''' + inttostr(CurLegSeek) + ''',';
        // result := result + ' rExtraExp, rAddableStatePoint, rTotalStatePoint, rCurrentGrade, rFashionableDress,';
        result := result + ' rExtraExp = ''' + inttostr(ExtraExp) + ''',';
        result := result + ' rAddableStatePoint = ''' + inttostr(AddableStatePoint) + ''',';
        result := result + ' rTotalStatePoint = ''' + inttostr(TotalStatePoint) + ''',';
        result := result + ' rCurrentGrade = ''' + inttostr(CurrentGrade) + ''',';
        result := result + ' rFashionableDress = ''' + IfThen(FashionableDress, '1', '0') + ''',';

        // result := result + ' rItemLogSize, rItemLogLockPassword, rJobKind, rDummy )';
        result := result + ' rItemLogSize = ''' + inttostr(ItemLog.rsize) + ''',';
        result := result + ' rItemLogLockPassword = ''' + (ItemLog.Header.LockPassword) + ''',';
        result := result + ' rJobKind = ''' + inttostr(JobKind) + ''',';
        result := result + ' rDummy = ''' + (Dummyb) + ''',';

        result := result + ' rpetname = ''' + (petname) + ''',';
        result := result + ' rpetgrade = ''' + inttostr(petgrade) + ''',';
        result := result + ' rpetexp = ''' + inttostr(petexp) + ''',';
        result := result + ' rpetmagic = ''' + petmagic + '''';

        result := result + ' where (rPrimaryKey = ''' + PrimaryKey + ''') ; ';

    end;
end;

function UserdataToUPdateSQL_Exec(var aDBRecord:TDBRecord):string;    //这里提交有问题，需要检查为啥没法保存最后的东西
begin
    with aDBRecord do
    begin

        result := 'Exec 角色基本数据更新 ';

        result := result + '''' + PrimaryKey + ''',';
        result := result + '' + inttostr(id) + ',';

        result := result + '''' + (MasterName) + ''',';
        result := result + '''' + (Password) + ''',';
        result := result + '' + inttostr(GroupKey) + ',';
        //result := result + ' rGuild, rLastDate, rCreateDate, rSex, rServerId, rx, ry, ';
        result := result + '''' + (Guild) + ''',';
        result := result + '''' + datetimetostr(LastDate) + ''',';
        result := result + '''' + datetimetostr(CreateDate) + ''',';
        result := result + '''' + IfThen(sex, '男', '女') + ''',';
        result := result + '' + inttostr(ServerId) + ',';
        result := result + '' + inttostr(x) + ',';
        result := result + '' + inttostr(y) + ',';
        //  result := result + ' rGOLD_Money, rprestige, rLight, rDark, rEnergy, rInPower, ';
        result := result + '' + inttostr(GOLD_Money) + ',';
        result := result + '' + inttostr(prestige) + ',';
        result := result + '' + inttostr(Light) + ',';
        result := result + '' + inttostr(Dark) + ',';
        result := result + '' + inttostr(Energy) + ',';
        result := result + '' + inttostr(InPower) + ',';
        // result := result + ' rOutPower, rMagic, rLife, rTalent, rGoodChar, rBadChar, ';
        result := result + '' + inttostr(OutPower) + ',';
        result := result + '' + inttostr(Magic) + ',';
        result := result + '' + inttostr(Life) + ',';
        result := result + '' + inttostr(Talent) + ',';
        result := result + '' + inttostr(GoodChar) + ',';
        result := result + '' + inttostr(BadChar) + ',';
        //result := result + ' rAdaptive, rRevival, rImmunity, rVirtue, rCurEnergy, ';
        result := result + '' + inttostr(Adaptive) + ',';
        result := result + '' + inttostr(Revival) + ',';
        result := result + '' + inttostr(Immunity) + ',';
        result := result + '' + inttostr(Virtue) + ',';
        result := result + '' + inttostr(CurEnergy) + ',';
        // result := result + ' rCurInPower, rCurOutPower, rCurMagic, rCurLife, rCurHealth,';
        result := result + '' + inttostr(CurInPower) + ',';
        result := result + '' + inttostr(CurOutPower) + ',';
        result := result + '' + inttostr(CurMagic) + ',';
        result := result + '' + inttostr(CurLife) + ',';
        result := result + '' + inttostr(CurHealth) + ',';
        // result := result + ' rCurSatiety, rCurPoisoning, rCurHeadSeek, rCurArmSeek, rCurLegSeek,';
        result := result + '' + inttostr(CurSatiety) + ',';
        result := result + '' + inttostr(CurPoisoning) + ',';
        result := result + '' + inttostr(CurHeadSeek) + ',';
        result := result + '' + inttostr(CurArmSeek) + ',';
        result := result + '' + inttostr(CurLegSeek) + ',';
        // result := result + ' rExtraExp, rAddableStatePoint, rTotalStatePoint, rCurrentGrade, rFashionableDress,';
        result := result + '' + inttostr(ExtraExp) + ',';
        result := result + '' + inttostr(AddableStatePoint) + ',';
        result := result + '' + inttostr(TotalStatePoint) + ',';
        result := result + '' + inttostr(CurrentGrade) + ',';
        result := result + '' + IfThen(FashionableDress, '1', '0') + ',';

        // result := result + ' rItemLogSize, rItemLogLockPassword, rJobKind, rDummy )';
        result := result + '' + inttostr(ItemLog.rsize) + ',';
        result := result + '''' + (ItemLog.Header.LockPassword) + ''',';
        result := result + '' + inttostr(JobKind) + ',';
        result := result + '''' + (Dummyb) + ''',';
        result := result + '''' + (petname) + ''',';
        result := result + '' + inttostr(petgrade) + ',';
        result := result + '' + inttostr(petexp) + ',';
        result := result + '''' +  petmagic  + '''; ';

    end;
end;


function UserdataToInsertSQL(var aDBRecord:TDBRecord):string;
begin
    with aDBRecord do
    begin

        result := 'insert into uUserData ( ';
        result := result + ' rid, rPrimaryKey, rMasterName, rPassword, rGroupKey,';
        result := result + ' rGuild, rLastDate, rCreateDate, rSex, rServerId, rx, ry, ';
        result := result + ' rGOLD_Money, rprestige, rLight, rDark, rEnergy, rInPower, ';
        result := result + ' rOutPower, rMagic, rLife, rTalent, rGoodChar, rBadChar, ';
        result := result + ' rAdaptive, rRevival, rImmunity, rVirtue, rCurEnergy, ';
        result := result + ' rCurInPower, rCurOutPower, rCurMagic, rCurLife, rCurHealth,';
        result := result + ' rCurSatiety, rCurPoisoning, rCurHeadSeek, rCurArmSeek, rCurLegSeek,';
        result := result + ' rExtraExp, rAddableStatePoint, rTotalStatePoint, rCurrentGrade, rFashionableDress,';
        result := result + ' rItemLogSize, rItemLogLockPassword, rJobKind, rDummy, rpetname, rpetgrade, rpetexp, rpetmagic )';
        result := result + ' values ( ';
        //result := result + ' rid, rPrimaryKey, rMasterName, rPassword, rGroupKey,';
        result := result + '''' + inttostr(id) + ''',';
        result := result + '''' + (PrimaryKey) + ''',';
        result := result + '''' + (MasterName) + ''',';
        result := result + '''' + (Password) + ''',';
        result := result + '''' + inttostr(GroupKey) + ''',';
        //result := result + ' rGuild, rLastDate, rCreateDate, rSex, rServerId, rx, ry, ';
        result := result + '''' + (Guild) + ''',';
        result := result + '''' + datetimetostr(LastDate) + ''',';
        result := result + '''' + datetimetostr(CreateDate) + ''',';
        result := result + '''' + IfThen(sex, '男', '女') + ''',';
        result := result + '''' + inttostr(ServerId) + ''',';
        result := result + '''' + inttostr(x) + ''',';
        result := result + '''' + inttostr(y) + ''',';
        //  result := result + ' rGOLD_Money, rprestige, rLight, rDark, rEnergy, rInPower, ';
        result := result + '''' + inttostr(GOLD_Money) + ''',';
        result := result + '''' + inttostr(prestige) + ''',';
        result := result + '''' + inttostr(Light) + ''',';
        result := result + '''' + inttostr(Dark) + ''',';
        result := result + '''' + inttostr(Energy) + ''',';
        result := result + '''' + inttostr(InPower) + ''',';
        // result := result + ' rOutPower, rMagic, rLife, rTalent, rGoodChar, rBadChar, ';
        result := result + '''' + inttostr(OutPower) + ''',';
        result := result + '''' + inttostr(Magic) + ''',';
        result := result + '''' + inttostr(Life) + ''',';
        result := result + '''' + inttostr(Talent) + ''',';
        result := result + '''' + inttostr(GoodChar) + ''',';
        result := result + '''' + inttostr(BadChar) + ''',';
        //result := result + ' rAdaptive, rRevival, rImmunity, rVirtue, rCurEnergy, ';
        result := result + '''' + inttostr(Adaptive) + ''',';
        result := result + '''' + inttostr(Revival) + ''',';
        result := result + '''' + inttostr(Immunity) + ''',';
        result := result + '''' + inttostr(Virtue) + ''',';
        result := result + '''' + inttostr(CurEnergy) + ''',';
        // result := result + ' rCurInPower, rCurOutPower, rCurMagic, rCurLife, rCurHealth,';
        result := result + '''' + inttostr(CurInPower) + ''',';
        result := result + '''' + inttostr(CurOutPower) + ''',';
        result := result + '''' + inttostr(CurMagic) + ''',';
        result := result + '''' + inttostr(CurLife) + ''',';
        result := result + '''' + inttostr(CurHealth) + ''',';
        // result := result + ' rCurSatiety, rCurPoisoning, rCurHeadSeek, rCurArmSeek, rCurLegSeek,';
        result := result + '''' + inttostr(CurSatiety) + ''',';
        result := result + '''' + inttostr(CurPoisoning) + ''',';
        result := result + '''' + inttostr(CurHeadSeek) + ''',';
        result := result + '''' + inttostr(CurArmSeek) + ''',';
        result := result + '''' + inttostr(CurLegSeek) + ''',';
        // result := result + ' rExtraExp, rAddableStatePoint, rTotalStatePoint, rCurrentGrade, rFashionableDress,';
        result := result + '''' + inttostr(ExtraExp) + ''',';
        result := result + '''' + inttostr(AddableStatePoint) + ''',';
        result := result + '''' + inttostr(TotalStatePoint) + ''',';
        result := result + '''' + inttostr(CurrentGrade) + ''',';
        result := result + '''' + IfThen(FashionableDress, '1', '0') + ''',';

        // result := result + ' rItemLogSize, rItemLogLockPassword, rJobKind, rDummy )';
        result := result + '''' + inttostr(ItemLog.rsize) + ''',';
        result := result + '''' + (ItemLog.Header.LockPassword) + ''',';
        result := result + '''' + inttostr(JobKind) + ''',';
        result := result + '''' + (Dummyb) + ''',';
        result := result + '''' + (petname) + ''',';
        result := result + '''' + inttostr(petgrade) + ''',';
        result := result + '''' + inttostr(petexp) + ''',';
        result := result + '''' +  petmagic + '''';
        result := result + ' ) ; ';
    end;
end;

function TUserBMagicDataToUPdateSQL(ausername:string; atype:string; akey:integer; atemp:pTDBMagicData ):string;
var
  mode:Integer;
begin
    with atemp^ do
    begin
      if UpperCase(atype)=UpperCase('BasicMagic') then mode:=1;
      if UpperCase(atype)=UpperCase('BasicRiseMagic') then mode:=2;
      if UpperCase(atype)=UpperCase('HaveMagic') then mode:=3;
      if UpperCase(atype)=UpperCase('HaveRiseMagic') then mode:=4;
      if UpperCase(atype)=UpperCase('HaveMysteryMagic') then mode:=5;

        case mode of
        1:  result := 'update  uUserMagic1  set ';
        2:  result := 'update  uUserMagic2  set ';
        3:  result := 'update  uUserMagic3  set ';
        4:  result := 'update  uUserMagic4  set ';
        5:  result := 'update  uUserMagic5  set ';
        end;
        result := result + ' rName = ''' + rName + ''',';
        result := result + ' rSkill = ''' + inttostr(rSkill) + '''';
        result := result + ' where (lusername = ''' + aUserName + ''')'
            + ' and (ltype = ''' + atype + ''')'
            + ' and (lkey = ''' + inttostr(akey) + ''') ; ';
    end;
end;

function TUserBMagicDataToUPdateSQL_Exec(ausername:string; atype:string; akey:integer; atemp:pTDBMagicData ):string;
var
  mode:Integer;
begin
    with atemp^ do
    begin
      if UpperCase(atype)=UpperCase('BasicMagic') then mode:=1;
      if UpperCase(atype)=UpperCase('BasicRiseMagic') then mode:=2;
      if UpperCase(atype)=UpperCase('HaveMagic') then mode:=3;
      if UpperCase(atype)=UpperCase('HaveRiseMagic') then mode:=4;
      if UpperCase(atype)=UpperCase('HaveMysteryMagic') then mode:=5;

        case mode of
        1: result := 'exec  角色武功更新1 ';
        2: result := 'exec  角色武功更新2 ';
        3: result := 'exec  角色武功更新3 ';
        4: result := 'exec  角色武功更新4 ';
        5: result := 'exec  角色武功更新5 ';
        end;
        result := result + '''' + aUserName + ''',';
        result := result + '''' + atype + ''',';
        result := result + '' + inttostr(akey) + ',';

        result := result + '''' + rName + ''',';
        result := result + '' + inttostr(rSkill) + '; ';

    end;
end;

function TUserItemDataToUPdateSQL_Exec(ausername:string; atype:string; akey:integer; atemp:pTCutItemData ):string;
var
  mode:Integer;
begin
    with atemp^ do
    begin
       if UpperCase(atype)=UpperCase('WearItem') then mode:=1;
      if UpperCase(atype)=UpperCase('FashionableDress') then mode:=2;
      if UpperCase(atype)=UpperCase('HaveItem') then mode:=3;
      if UpperCase(atype)=UpperCase('ItemLog') then mode:=4;
        case mode of
        1:result := 'exec  角色物品更新1 ';
        2:result := 'exec  角色物品更新2 ';
        3:result := 'exec  角色物品更新3 ';
        4:result := 'exec  角色物品更新4 ';
        end;
        result := result + '''' + aUserName + ''',';
        result := result + '''' + atype + ''',';
        result := result + '' + inttostr(akey) + ',';

        result := result + '' + inttostr(rid) + ',';
        result := result + '''' + rName + ''',';
        result := result + '' + inttostr(rcount) + ',';
        result := result + '' + inttostr(rcolor) + ',';
        result := result + '' + inttostr(rDurability) + ',';
        result := result + '' + inttostr(rDurabilityMax) + ',';
        result := result + '' + inttostr(rSmithingLevel) + ',';
        result := result + '' + inttostr(rAttach) + ',';
        result := result + '' + inttostr(rlockState) + ',';
        result := result + '' + inttostr(rlocktime) + ',';
        result := Result + '' +  booltostr(rBoident)+ ',';//20131207修改
        result := result + '' + inttostr(rSetting.rsettingcount) + ',';
        result := result + '''' + (rSetting.rsetting1) + ''',';
        result := result + '''' + (rSetting.rsetting2) + ''',';
        result := result + '''' + (rSetting.rsetting3) + ''',';
        result := result + '''' + (rSetting.rsetting4) + ''',';

        result := result + '''' + datetimetostr(rDateTime) + '''; ';
    end;
end;

function TUserItemDataToUPdateSQL(ausername:string; atype:string; akey:integer; atemp:pTCutItemData ):string;
var
  mode:Integer;
begin
    with atemp^ do
    begin
      if UpperCase(atype)=UpperCase('WearItem') then mode:=1;
      if UpperCase(atype)=UpperCase('FashionableDress') then mode:=2;
      if UpperCase(atype)=UpperCase('HaveItem') then mode:=3;
      if UpperCase(atype)=UpperCase('ItemLog') then mode:=4;

        case mode of
        1: result := 'update  uUserItem1  set ';
        2: result := 'update  uUserItem2  set ';
        3: result := 'update  uUserItem3  set ';
        4: result := 'update  uUserItem4  set ';
        end;
        result := result + ' rid = ''' + inttostr(rid) + ''',';
        result := result + ' rname = ''' + rName + ''',';
        result := result + ' rcount = ''' + inttostr(rcount) + ''',';
        result := result + ' rcolor = ''' + inttostr(rcolor) + ''',';
        result := result + ' rDurability = ''' + inttostr(rDurability) + ''',';
        result := result + ' rDurabilityMax = ''' + inttostr(rDurabilityMax) + ''',';
        result := result + ' rlevel = ''' + inttostr(rSmithingLevel) + ''',';
        result := result + ' rAdditional = ''' + inttostr(rAttach) + ''',';
        result := result + ' rlockState = ''' + inttostr(rlockState) + ''',';
        result := result + ' rlocktime = ''' + inttostr(rlocktime) + ''',';
        result:=  result + ' rBoident  = ''' + booltostr(rBoident) + ''','; //20131207修改
        result := result + ' rsettingcount = ''' + inttostr(rSetting.rsettingcount) + ''',';
        result := result + ' rsetting1 = ''' + (rSetting.rsetting1) + ''',';
        result := result + ' rsetting2 = ''' + (rSetting.rsetting2) + ''',';
        result := result + ' rsetting3 = ''' + (rSetting.rsetting3) + ''',';
        result := result + ' rsetting4 = ''' + (rSetting.rsetting4) + ''',';

        result := result + ' rdatetime = ''' + datetimetostr(rDateTime) + '''';
        result := result + ' where (lusername = ''' + aUserName + ''')'
            + ' and (ltype = ''' + atype + ''')'
            + ' and (lkey = ''' + inttostr(akey) + ''') ;';
    end;
end;

function TCutItemDataTOUPdateSQL(atable:string; alid:integer; atemp:pTCutItemData):string;
begin
    with atemp^ do
    begin

        result := 'update ' + atable + ' set ';
        result := result + ' rid = ''' + inttostr(rid) + ''',';
        result := result + ' rname = ''' + rName + ''',';
        result := result + ' rcount = ''' + inttostr(rcount) + ''',';
        result := result + ' rcolor = ''' + inttostr(rcolor) + ''',';
        result := result + ' rDurability = ''' + inttostr(rDurability) + ''',';
        result := result + ' rDurabilityMax = ''' + inttostr(rDurabilityMax) + ''',';
        result := result + ' rlevel = ''' + inttostr(rSmithingLevel) + ''',';
        result := result + ' rAdditional = ''' + inttostr(rAttach) + ''',';
        result := result + ' rlockState = ''' + inttostr(rlockState) + ''',';
        result := result + ' rlocktime = ''' + inttostr(rlocktime) + ''',';
        result := Result + ' rBoident = ''' +   booltostr(rBoident);//20131207修改
        result := result + ' rsettingcount = ''' + inttostr(rSetting.rsettingcount) + ''',';
        result := result + ' rsetting1 = ''' + (rSetting.rsetting1) + ''',';
        result := result + ' rsetting2 = ''' + (rSetting.rsetting2) + ''',';
        result := result + ' rsetting3 = ''' + (rSetting.rsetting3) + ''',';
        result := result + ' rsetting4 = ''' + (rSetting.rsetting4) + ''',';

        result := result + ' rdatetime = ''' + datetimetostr(rDateTime) + '''';
        result := result + ' where lid = ''' + inttostr(alid) + ''' ;';
    end;
end;

function TDBMagicDataToInsertSQL(ausername:string; atype:string; akey:integer; atemp:pTDBMagicData):string;
var
  mode:Integer;
begin
    with atemp^ do
    begin
      if UpperCase(atype)=UpperCase('BasicMagic') then mode:=1;
      if UpperCase(atype)=UpperCase('BasicRiseMagic') then mode:=2;
      if UpperCase(atype)=UpperCase('HaveMagic') then mode:=3;
      if UpperCase(atype)=UpperCase('HaveRiseMagic') then mode:=4;
      if UpperCase(atype)=UpperCase('HaveMysteryMagic') then mode:=5;

        case mode of
        1:   result := 'insert into uUserMagic1 ( ';
        2:   result := 'insert into uUserMagic2 ( ';
        3:   result := 'insert into uUserMagic3 ( ';
        4:   result := 'insert into uUserMagic4 ( ';
        5:   result := 'insert into uUserMagic5 ( ';
        end;
        result := result + ' lusername, ltype, lkey, rname, rSkill )';
        result := result + ' values ( ';
        result := result + '''' + (ausername) + ''',';
        result := result + '''' + (atype) + ''',';
        result := result + '''' + inttostr(akey) + ''',';
        result := result + '''' + (rName) + ''',';
        result := result + '''' + inttostr(rSkill) + '''';
        result := result + ' ) ;';
    end;
end;

function TUserItemDataToInsertSQL(ausername:string; atype:string; akey:integer; atemp:pTCutItemData ):string;
var
  mode:Integer;
begin
    with atemp^ do
    begin
      if UpperCase(atype)=UpperCase('WearItem') then mode:=1;
      if UpperCase(atype)=UpperCase('FashionableDress') then mode:=2;
      if UpperCase(atype)=UpperCase('HaveItem') then mode:=3;
      if UpperCase(atype)=UpperCase('ItemLog') then mode:=4;

        case mode of
        1:         result := 'insert into uUserItem1 ( ';
        2:         result := 'insert into uUserItem2 ( ';
        3:         result := 'insert into uUserItem3 ( ';
        4:         result := 'insert into uUserItem4 ( ';
        end;

        result := result + ' lusername, ltype, lkey,rid, rname, rcount, rcolor, rDurability, rDurabilityMax, ';
        result := result + ' rlevel, rAdditional, rlockState, rlocktime,rBoident,  rsettingcount, rsetting1, rsetting2, rsetting3, rsetting4,rDateTime)';
        result := result + ' values ( ';
        result := result + '''' + (ausername) + ''',';
        result := result + '''' + (atype) + ''',';
        result := result + '''' + inttostr(akey) + ''',';
        result := result + '''' + inttostr(rID) + ''',';
        result := result + '''' + rname + ''',';
        result := result + '''' + inttostr(rcount) + ''',';
        result := result + '''' + inttostr(rcolor) + ''',';
        result := result + '''' + inttostr(rDurability) + ''',';
        result := result + '''' + inttostr(rDurabilityMax) + ''',';
        result := result + '''' + inttostr(rSmithingLevel) + ''',';
        result := result + '''' + inttostr(rAttach) + ''',';
        result := result + '''' + inttostr(rlockState) + ''',';
        result := result + '''' + inttostr(rlocktime) + ''',';
        result := result + '''' + booltostr(rBoident) + ''',';    //20131207修改
        result := result + '''' + inttostr(rSetting.rsettingcount) + ''',';
        result := result + '''' + (rSetting.rsetting1) + ''',';
        result := result + '''' + (rSetting.rsetting2) + ''',';
        result := result + '''' + (rSetting.rsetting3) + ''',';
        result := result + '''' + (rSetting.rsetting4) + ''',';
        result := result + '''' + datetimetostr(rDateTime) + '''';
        result := result + ' ) ;';
    end;
end;

function TCutItemDataToInsertSQL(atable:string; ald:integer; atemp:pTCutItemData):string;
begin
    with atemp^ do
    begin
        result := 'insert into ' + atable + ' ( ';
        result := result + ' lid,rid, rname, rcount, rcolor, rDurability, rDurabilityMax, ';
        result := result + ' rlevel, rAdditional, rlockState, rlocktime,rBoident,  rsettingcount, rsetting1, rsetting2, rsetting3, rsetting4,rDateTime )';
        result := result + ' values ( ';
        result := result + '''' + inttostr(ald) + ''',';
        result := result + '''' + inttostr(rID) + ''',';
        result := result + '''' + rname + ''',';
        result := result + '''' + inttostr(rcount) + ''',';
        result := result + '''' + inttostr(rcolor) + ''',';
        result := result + '''' + inttostr(rDurability) + ''',';
        result := result + '''' + inttostr(rDurabilityMax) + ''',';
        result := result + '''' + inttostr(rSmithingLevel) + ''',';
        result := result + '''' + inttostr(rAttach) + ''',';
        result := result + '''' + inttostr(rlockState) + ''',';
        result := result + '''' + inttostr(rlocktime) + ''',';
        result := result + '''' + booltostr(rBoident) + ''',';    //20131207修改
        result := result + '''' + inttostr(rSetting.rsettingcount) + ''',';
        result := result + '''' + (rSetting.rsetting1) + ''',';
        result := result + '''' + (rSetting.rsetting2) + ''',';
        result := result + '''' + (rSetting.rsetting3) + ''',';
        result := result + '''' + (rSetting.rsetting4) + ''',';
        result := result + '''' + datetimetostr(rDateTime) + '''';
        result := result + ' ) ;';
    end;
end;

function TAuctionDataTOUPdateSQL(atemp:pTAuctionData):string;
var
    i               :integer;
begin
    with atemp^ do
    begin
        if rPricetype = aptGOLD_Money then i := 1 else i := 0;
        result := 'update uAuction set ';
        result := result + ' ritemimg = ''' + inttostr(ritemimg) + ''',';
        result := result + ' rPricetype = ''' + inttostr(i) + ''',';
        result := result + ' rPrice = ''' + inttostr(rPrice) + ''',';
        result := result + ' rTime = ''' + datetimetostr(rtime) + ''',';
        result := result + ' rMaxTime = ''' + inttostr(rMaxTime) + ''',';
        result := result + ' rBargainorName = ''' + rBargainorName + ''' ';

        result := result + ' where rid = ''' + inttostr(rID) + ''' ;';
    end;
end;

function TAuctionDataToInsertSQL(atemp:pTAuctionData):string;
var
    i               :integer;
begin
    with atemp^ do
    begin
        if rPricetype = aptGOLD_Money then i := 1 else i := 0;
        result := 'insert into uAuction ( ';
        result := result + '  rid, ritemimg, rPricetype, rPrice, rTime, rMaxTime ';
        result := result + ' , rBargainorName  )';
        result := result + ' values ( ';
        result := result + '''' + inttostr(rid) + ''',';
        result := result + '''' + inttostr(ritemimg) + ''',';
        result := result + '''' + inttostr(i) + ''',';
        result := result + '''' + inttostr(rPrice) + ''',';
        result := result + '''' + datetimetostr(rTime) + ''',';
        result := result + '''' + inttostr(rMaxTime) + ''',';
        result := result + '''' + rBargainorName + ''' ';

        result := result + ' ) ;';
    end;
end;
end.

