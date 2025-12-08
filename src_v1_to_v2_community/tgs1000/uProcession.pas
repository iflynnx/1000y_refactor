unit uProcession;

interface
uses
    Windows, Classes, SysUtils, svClass, subutil, uAnsTick,                     //AnsUnit,
    BasicObj, FieldMsg, MapUnit, DefType, Autil32, uMonster, uGramerid, UUser,
    IniFiles, uLevelexp, uGuildSub, uManager, UserSDB, uResponsion;
type
    TProcessiondata = record
        rid: integer;
        rname: string[32];
        raddtime: tdatetime;
        rUser: tuser;
    end;
    PTProcessiondata = ^TProcessiondata;

    TProcessionclass = class
        headmanname: TProcessiondata;
        rid: integer;
        Ftype: TDistributeType;

        LifeData: TLifeData;
    private

        FDELSTATE: boolean;
        FDCurTick: integer;
        fdata: tlist;
        ADDMsgList: TResponsion;                                                //加人  等待 应答 列表
        procedure Clear();
        procedure sendSay(uUser: tuser; ausername, astr: string);
        procedure senddisband(uUser: tuser);
        procedure senddel(uUser: tuser; p: PTProcessiondata);
        procedure sendadd(uUser: tuser; p: PTProcessiondata);
        procedure sendadditem(uUser: tuser; p: PTProcessiondata; pitem: pTItemData);
        procedure sendList(uUser: tuser);
        procedure sendAddMsg(uUser: tuser);
        procedure sendSetHeadman(uUser: tuser; p: PTProcessiondata);
        procedure OnAddItem(pitem: pTItemData; p: PTProcessiondata);
        procedure Ondel(p: PTProcessiondata);
        procedure Onadd(p: PTProcessiondata);
        procedure OnHeadman(p: PTProcessiondata);
        function GETHeadman(): PTProcessiondata;
        function GETNoHeadman(): PTProcessiondata;
        function GET(uUser: tuser): PTProcessiondata;
        function GetId(aid: integer): PTProcessiondata;
        procedure setLifeData();
    public
        constructor Create(uuser: tuser);
        destructor Destroy; override;
        procedure Say(ausername, astr: string);

        procedure del(aid: integer);                                            //踢出
        procedure addMsg(uUser: tuser);
        procedure addMsgOK(uUser: tuser);
        procedure addMsgNO(uUser: tuser);
        procedure add(uUser: tuser);                                            //增加
        procedure setGameExit(uUser: tuser);                                    //退出游戏
        procedure disband();                                                    //解散
        procedure SetHeadman(aid: integer);                                     //设置队长
        function IsState: boolean;
        procedure SendMapObject(uUser: tuser);
        procedure MessageProcess(var Code: TWordComData; uUser: tuser);
        function ItemRandom(aItemObject: TItemObject): integer;
        procedure UPDATE(CurTick: INTEGER);
        function QuestProcessionAdd(uUser: tuser; atype: string; aQuestID, aQuestStep, aIndex, aAddCount, aAddMax: integer): boolean;
        function GetProcession(var u1, u2, u3, u4, u5, u6, u7, u8: integer): boolean;
        procedure _OnAddItem(pitem: pTItemData; userid: integer);

        function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
    end;
    TProcessionclassList = class
    private
        rid: integer;
        FDCurTick: integer;
        fdata: tlist;
        LifeDataarr: array[1..8] of TLifeData;
        procedure Clear();

    public
        constructor Create;
        destructor Destroy; override;
        procedure UPDATE(CurTick: INTEGER);
        procedure createProcessionclass(uuser: tuser);
        procedure loadsdb();
        function getPid: integer;
        function getLifeData(anum: integer): TLifeData;
    end;

var
    ProcessionclassList: TProcessionclassList;
implementation

procedure TProcessionclassList.loadsdb();
var
    i, j: integer;
    str, rdstr: string;
    StringList: TStringList;
    atp: TLifeData;
begin
    Clear;
    if not FileExists('.\Init\Procession.SDB') then exit;

    StringList := TStringList.Create;
    StringList.LoadFromFile('.\Init\Procession.SDB');
    for i := 1 to StringList.Count - 1 do
    begin
        str := StringList[i];
        str := GetValidStr3(str, rdstr, ',');
        j := _StrToInt(rdstr);
        if (j >= low(LifeDataarr)) and (j <= high(LifeDataarr)) then
        begin
            str := GetValidStr3(str, rdstr, ',');
            atp.damageBody := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.damageHead := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.damageArm := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.damageLeg := _StrToInt(rdstr);

            str := GetValidStr3(str, rdstr, ',');
            atp.armorBody := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.armorHead := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.armorArm := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.armorLeg := _StrToInt(rdstr);

            str := GetValidStr3(str, rdstr, ',');
            atp.AttackSpeed := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.avoid := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.recovery := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.HitArmor := _StrToInt(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            atp.accuracy := _StrToInt(rdstr);
            LifeDataarr[j] := atp;
        end;
    end;
    StringList.Free;
end;

function TProcessionclassList.getLifeData(anum: integer): TLifeData;
begin
    FillChar(Result, SizeOf(TLifeData), 0);
    if (anum >= low(ProcessionclassList.LifeDataarr))
        and (anum <= high(ProcessionclassList.LifeDataarr)) then
    begin
        Result := ProcessionclassList.LifeDataarr[anum];
    end;
end;

function TProcessionclassList.getPid: integer;
begin
    rid := rid + 7;
    result := rid;
end;

procedure TProcessionclassList.createProcessionclass(uuser: tuser);
var
    p: TProcessionclass;
begin
    if uuser.uProcessionclass <> nil then exit;
    p := TProcessionclass.Create(uuser);
    fdata.Add(p);
end;

procedure TProcessionclassList.Clear();
var
    i: integer;
    p: TProcessionclass;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        p.Free;
    end;
    fdata.Clear;
    fillchar(LifeDataarr, sizeof(tLifeData) * (high(LifeDataarr) - low(LifeDataarr) + 1), 0);
end;

constructor TProcessionclassList.Create();
begin
    inherited Create;
    fdata := tlist.Create;
    rid := 0;
    loadsdb;
end;

destructor TProcessionclassList.Destroy;
begin
    Clear;
    fdata.Free;
    inherited Destroy;
end;

procedure TProcessionclassList.UPDATE(CurTick: INTEGER);
var
    i: integer;
    p: TProcessionclass;
begin
    if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
    FDCurTick := CurTick;
    for i := fdata.Count - 1 downto 0 do
    begin
        p := fdata.Items[i];
        if p.FDELSTATE then
        begin
            p.Free;
            fdata.Delete(i);
        end
        else
            p.UPDATE(CurTick);
    end;

end;
//////////////////////////////////////////////////////////////////////////////////

procedure TProcessionclass.UPDATE(CurTick: INTEGER);
begin
    if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
    FDCurTick := CurTick;
    ADDMsgList.UPDATE(CurTick);
    if ADDMsgList.count <= 0 then
        if IsState = false then disband;
end;

procedure TProcessionclass.sendAddMsg(uUser: tuser);
var
    code: TWordComData;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_ADDMsg);
    WordComData_ADDstring(code, headmanname.rname);
    uUser.SendClass.SendData(code);
end;

procedure TProcessionclass.addMsg(uUser: tuser);

begin
    if uuser.uProcessionclass <> nil then exit;
    if fdata.Count >= 8 then exit;
    if GET(uuser) <> nil then exit;

    ADDMsgList.add(uuser.name, headmanname.rname);
    sendAddMsg(uuser);
end;

procedure TProcessionclass.addMsgOK(uUser: tuser);

begin
    if ADDMsgList.Get(uuser.name) = nil then
    begin
        uUser.SendClass.SendChatMessage('消息过期', SAY_COLOR_SYSTEM);
        exit;
    end;
    ADDMsgList.del(uuser.name);
    if uuser.uProcessionclass <> nil then exit;
    if fdata.Count >= 8 then exit;
    if GET(uuser) <> nil then exit;
    add(uUser);

end;

procedure TProcessionclass.addMsgNO(uUser: tuser);
var
    p: PTProcessiondata;
begin
    if ADDMsgList.Get(uuser.name) = nil then exit;
    ADDMsgList.del(uuser.name);
    p := GETHeadman;
    if p = nil then
    begin
        disband;
        exit;
    end;
    p.rUser.SendClass.SendChatMessage(format('%s 拒绝加入', [uuser.name]), SAY_COLOR_SYSTEM);
end;

procedure TProcessionclass.MessageProcess(var Code: TWordComData; uUser: tuser);
var
    pckey: PTCkey;
    i, akey, eid: integer;
    p: PTProcessiondata;
    str: string;
    tempuUser: tuser;
begin
    pckey := @Code.Data;

    if pckey^.rmsg <> CM_Procession then exit;

    i := 1;
    akey := WordComData_GETbyte(Code, i);
    case akey of
        Procession_say:
            begin
                str := WordComData_GETstring(Code, i);
                Say(uuser.name, str);
            end;
        Procession_ADDMsg:
            begin
                if uuser.name <> headmanname.rname then
                begin
                    uUser.SendClass.SendChatMessage('没权限。', SAY_COLOR_SYSTEM);
                    exit;
                end;
                if fdata.Count >= 8 then
                begin
                    uUser.SendClass.SendChatMessage('队伍满员', SAY_COLOR_SYSTEM);
                    exit;
                end;
                str := WordComData_GETstring(Code, i);
                tempuUser := UserList.GetUserPointer(str);
                if tempuUser = nil then
                begin
                    uUser.SendClass.SendChatMessage('目标不在线', SAY_COLOR_SYSTEM);
                    exit;
                end;
                if tempuUser.uProcessionclass <> nil then
                begin
                    uUser.SendClass.SendChatMessage('目标有队伍', SAY_COLOR_SYSTEM);
                    exit;
                end;
                p := GET(tempuUser);
                if p <> nil then
                begin
                    uUser.SendClass.SendChatMessage('目标在队伍中', SAY_COLOR_SYSTEM);
                    exit;
                end;

                addMsg(tempuUser);
            end;
        Procession_ADDMsgOk:
            begin
                addMsgOK(uUSER);
                if IsState = false then disband;
            end;
        Procession_ADDMsgNo:
            begin
                addMsgno(uUSER);
                if IsState = false then disband;
            end;
        Procession_DEL:
            begin
                if uuser.name <> headmanname.rname then
                begin
                    uUser.SendClass.SendChatMessage('没权限。', SAY_COLOR_SYSTEM);
                    exit;
                end;
                eid := WordComData_GETdword(Code, i);
                p := GetId(eid);
                if p = nil then
                begin
                    uUser.SendClass.SendChatMessage('无效用户', SAY_COLOR_SYSTEM);
                    exit;
                end;
                if p.rname = headmanname.rname then
                begin
                    setGameExit(uuser);
                    exit;
                end;
                del(eid);
                if IsState = false then disband;
            end;
        Procession_LIST:
            begin

            end;
        Procession_headman:
            begin
                if uuser.name <> headmanname.rname then
                begin
                    uUser.SendClass.SendChatMessage('没权限。', SAY_COLOR_SYSTEM);
                    exit;
                end;
                eid := WordComData_GETdword(Code, i);
                SetHeadman(eid);
            end;
        Procession_disband:
            begin
                if uuser.name <> headmanname.rname then
                begin
                    uUser.SendClass.SendChatMessage('没权限。', SAY_COLOR_SYSTEM);
                    exit;
                end;
                disband;
            end;
        Procession_exit:
            begin
                setGameExit(uuser);
                if IsState = false then disband;
            end;
    end;

end;

procedure TProcessionclass.Clear();
var
    i: integer;
    p: PTProcessiondata;
begin
    FillChar(LifeData, SizeOf(TLifeData), 0);
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        p.rUser.uProcessionclass := nil;
        dispose(p);
    end;

    fdata.Clear;
    setLifeData;
end;

procedure TProcessionclass.disband();
var
    i: integer;
    p: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        senddisband(p.rUser);
    end;
    Clear;
    FDELSTATE := true;
end;

procedure TProcessionclass.SendMapObject(uUser: tuser);
var
    i: integer;
    p: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        uUser.SendClass.SendMapObject(P.rUser.BasicData.x, P.rUser.BasicData.Y, P.rUser.name, MapobjectUserProcession);
    end;

end;

procedure TProcessionclass.Say(ausername, astr: string);
var
    i: integer;
    p: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        sendSay(p.rUser, ausername, astr);
    end;

end;

procedure TProcessionclass.del(aid: integer);
var
    i: integer;
    p: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rid = aid then
        begin
            ondel(p);
            p.rUser.uProcessionclass := nil;
            fdata.Delete(i);
            Dispose(p);
            exit;
        end;
    end;

end;
//下线

procedure TProcessionclass.setGameExit(uUser: tuser);
var
    p: PTProcessiondata;
begin
    //查找 自己
    p := get(uUser);
    if p = nil then
    begin
        //错误 解散 队伍
        disband;
        exit;
    end;
    del(p.rid);                                                                 //删除 自己

    if headmanname.rname = uuser.name then
    begin                                                                       // 自己是队长
        if fdata.Count >= 1 then
        begin
            p := GETNoHeadman;                                                  //查找 1 个 非队长
            if p = nil then
            begin
                //错误 解散 队伍
                disband;
                exit;
            end;
            SetHeadman(p.rid);                                                  //设置 新队长
        end;
    end;

    if IsState = false then disband;
end;

function TProcessionclass.IsState: boolean;
begin
    result := FALSE;
    if fdata.Count >= 2 then RESULT := TRUE;

end;

procedure TProcessionclass.SetHeadman(aid: integer);                            //设置队长
var
    p: PTProcessiondata;
begin
    p := GETid(aid);
    if p = nil then exit;
    headmanname := p^;
    OnHeadman(p);
end;

function TProcessionclass.GETHeadman(): PTProcessiondata;
var
    i: integer;
    p: PTProcessiondata;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname = headmanname.rname then
        begin
            result := p;
            exit;
        end;
    end;

end;

function TProcessionclass.GETNoHeadman(): PTProcessiondata;
var
    i: integer;
    p: PTProcessiondata;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname <> headmanname.rname then
        begin
            result := p;
            exit;
        end;
    end;

end;

function TProcessionclass.GETid(aid: integer): PTProcessiondata;
var
    i: integer;
    p: PTProcessiondata;
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

function TProcessionclass.GET(uUser: tuser): PTProcessiondata;
var
    i: integer;
    p: PTProcessiondata;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname = uuser.name then
        begin
            result := p;
            exit;
        end;
    end;

end;

function TProcessionclass.ItemRandom(aItemObject: TItemObject): integer;
var
    i, _max, j: integer;
    pp: PTProcessiondata;
begin
    result := 0;
    if fdata.Count <= 0 then exit;
    _max := 0;
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if (pp.rUser.ServerID = aItemObject.ServerID)
            and (aItemObject.isRangex(pp.rUser.BasicData.x, pp.rUser.BasicData.y)) then
        begin
            j := random(100) + 1;
            if j > _max then
            begin
                result := pp.rid;
                _max := j;
            end;
        end;
    end;
end;

procedure TProcessionclass.OnAddItem(pitem: pTItemData; p: PTProcessiondata);
var
    i: integer;
    pp: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if pp.rid <> p.rid then
            sendadditem(pp.rUser, p, pitem);
    end;
end;

procedure TProcessionclass._OnAddItem(pitem: pTItemData; userid: integer);
var
    pp: PTProcessiondata;
begin
    pp := GetId(userid);
    if pp = nil then exit;
    OnAddItem(pitem, pp);
end;

procedure TProcessionclass.Onadd(p: PTProcessiondata);
var
    i: integer;
    pp: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        sendadd(pp.rUser, p);
    end;
    setLifeData;
end;

procedure TProcessionclass.OnHeadman(p: PTProcessiondata);
var
    i: integer;
    pp: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        sendSetHeadman(pp.rUser, p);
    end;
end;

procedure TProcessionclass.sendSetHeadman(uUser: tuser; p: PTProcessiondata);
var
    code: TWordComData;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_headman);
    WordComData_ADDdword(code, P.rid);
    uUser.SendClass.SendData(code);
end;

procedure TProcessionclass.sendList(uUser: tuser);
var
    code: TWordComData;
    i: integer;
    p: PTProcessiondata;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_LIST);
    WordComData_ADDbyte(code, fdata.Count);
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        WordComData_ADDdword(code, P.rid);
        WordComData_ADDstring(code, P.rname);
    end;

    uUser.SendClass.SendData(code);
    P := GETHeadman;
    if P <> nil then
        sendSetHeadman(uUSER, p);
end;

procedure TProcessionclass.sendadditem(uUser: tuser; p: PTProcessiondata; pitem: pTItemData);
var
    code: TWordComData;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_additem);
    WordComData_ADDdword(code, P.rid);
    WordComData_ADDstring(code, pitem.rViewName);
    WordComData_ADDdword(code, pitem.rCount);
    uUser.SendClass.SendData(code);
end;

procedure TProcessionclass.sendadd(uUser: tuser; p: PTProcessiondata);
var
    code: TWordComData;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_add);
    WordComData_ADDdword(code, P.rid);
    WordComData_ADDstring(code, P.rname);
    uUser.SendClass.SendData(code);
end;

procedure TProcessionclass.senddisband(uUser: tuser);
var
    code: TWordComData;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_disband);
    uUser.SendClass.SendData(code);
end;

procedure TProcessionclass.senddel(uUser: tuser; p: PTProcessiondata);
var
    code: TWordComData;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_DEL);
    WordComData_ADDdword(code, P.rid);
    uUser.SendClass.SendData(code);
end;

procedure TProcessionclass.sendSay(uUser: tuser; ausername, astr: string);
var
    code: TWordComData;
begin
    code.Size := 0;
    WordComData_ADDbyte(code, SM_Procession);
    WordComData_ADDbyte(code, Procession_say);
    //   WordComData_ADDdword(code, P.rid);
    WordComData_ADDstring(code, ausername);
    WordComData_ADDstring(code, astr);
    uUser.SendClass.SendData(code);
end;

procedure TProcessionclass.Ondel(p: PTProcessiondata);
var
    i: integer;
    pp: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        senddel(pp.rUser, p);
    end;
    setLifeData;
end;

procedure TProcessionclass.setLifeData();
var
    i: integer;
    pp: PTProcessiondata;
begin

    LifeData := ProcessionclassList.getLifeData(fdata.Count);
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        pp.rUser.SetLifeData;
    end;

end;

procedure TProcessionclass.add(uUser: tuser);
var
    p: PTProcessiondata;
begin
    if uuser.uProcessionclass <> nil then
    begin
        uUser.SendClass.SendChatMessage('你已有队伍。', SAY_COLOR_SYSTEM);
        exit;
    end;
    if fdata.Count >= 8 then
    begin
        uUser.SendClass.SendChatMessage('加入失败人数满。', SAY_COLOR_SYSTEM);
        exit;
    end;
    if GET(uuser) <> nil then
    begin
        uUser.SendClass.SendChatMessage('失败你已在队伍。', SAY_COLOR_SYSTEM);
        exit;
    end;
    uUser.uProcessionclass := Self;
    new(p);
    p.rid := uuser.BasicData.id;
    p.rname := uuser.name;
    p.raddtime := now();
    p.rUser := uuser;

    fdata.Add(p);
    Onadd(p);
    sendList(uuser);
end;

constructor TProcessionclass.Create(uuser: tuser);
var
    p: PTProcessiondata;
begin
    inherited Create;

    ADDMsgList := TResponsion.Create;
    fdata := tlist.Create;
    Clear;
    // headmanname := uuser.name;
    add(uuser);
    p := GET(uuser);
    if p = nil then
    begin
        disband;
        exit;
    end;

    SetHeadman(p.rid);
    FDELSTATE := false;
    rid := ProcessionclassList.getPid;
    Ftype := pdtRandom;

end;

destructor TProcessionclass.Destroy;
begin
    Clear;
    fdata.Free;
    ADDMsgList.Free;
    inherited Destroy;
end;

{    FCompleteQuestNo: integer;                                              //新 任务 完成ID
        FCurrentQuestNo: integer;                                               //新 任务 当前ID
        FQueststep: integer;                                                    //新 任务 步骤ID

        FSubCurrentQuestNo: integer;                                            //新 分支任务 当前ID
        FSubQueststep: integer;                                                 //新 分支任务 步骤ID}

function TProcessionclass.QuestProcessionAdd(uUser: tuser; atype: string; aQuestID, aQuestStep, aIndex, aAddCount, aAddMax: integer): boolean;
var
    i: integer;
    p: PTProcessiondata;
begin
    if atype = '主线任务' then
    begin
        for i := 0 to fdata.Count - 1 do
        begin
            p := fdata.Items[i];
            if (p.rUser.FCurrentQuestNo <> aQuestID) or (p.rUser.FQueststep <> aQuestStep) then Continue;
            p.rUser.QuestTempAdd(aIndex, aAddCount, aAddMax);
        end;
    end;
    if atype = '支线任务' then
    begin
        for i := 0 to fdata.Count - 1 do
        begin
            p := fdata.Items[i];
            if (p.rUser.FSubCurrentQuestNo <> aQuestID) or (p.rUser.FSubQueststep <> aQuestStep) then Continue;
            p.rUser.QuestTempAdd(aIndex, aAddCount, aAddMax);
        end;
    end;
end;

function TProcessionclass.GetProcession(var u1, u2, u3, u4, u5, u6, u7, u8: integer): boolean;
begin
    result := false;
    u1 := 0;
    u2 := 0;
    u3 := 0;
    u4 := 0;
    u5 := 0;
    u6 := 0;
    u7 := 0;
    u8 := 0;
    if fdata.Count >= 1 then u1 := integer(PTProcessiondata(fdata.Items[0]).rUser);
    if fdata.Count >= 2 then u1 := integer(PTProcessiondata(fdata.Items[1]).rUser);
    if fdata.Count >= 3 then u1 := integer(PTProcessiondata(fdata.Items[2]).rUser);
    if fdata.Count >= 4 then u1 := integer(PTProcessiondata(fdata.Items[3]).rUser);
    if fdata.Count >= 5 then u1 := integer(PTProcessiondata(fdata.Items[4]).rUser);
    if fdata.Count >= 6 then u1 := integer(PTProcessiondata(fdata.Items[5]).rUser);
    if fdata.Count >= 7 then u1 := integer(PTProcessiondata(fdata.Items[6]).rUser);
    if fdata.Count >= 8 then u1 := integer(PTProcessiondata(fdata.Items[7]).rUser);
    result := true;
end;

function TProcessionclass.FieldProc(hfu: Integer; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
    i: integer;
    pp: PTProcessiondata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];

    end;

end;

end.

