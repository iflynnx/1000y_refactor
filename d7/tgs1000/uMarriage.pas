unit uMarriage;
interface

uses
    Windows, Sysutils, Classes,  Deftype, uAnsTick, BasicObj, SvClass,
    SubUtil, uSkills, uLevelExp, uUser, aUtil32, uGramerid, //AnsUnit,
    FieldMsg, MapUnit, uKeyClass, uResponsion;
const
    MAX_Marriage_count = 30;
type
    {结婚流程管理
    }
    //结婚
    TMarriage = class
    private
        bouser:boolean;
        FManName:string;
        FWomanName:string;
        FTIME:integer;
        Ftext:string;              //问答 消息
        Fofficiator:string;        //主婚礼人
        Fstep:integer;
        MsgList:TResponsion;       //应答列表

        FDCurTick:integer;
    public

        constructor Create;
        destructor Destroy; override;
        function IsAuditoria():boolean; //礼堂 是否为空闲
        function IsParty(aname:string):boolean; //测试是否是当事人

        function getmarrystep():integer; //获取 当前 婚礼第几步骤
        function getManName():string;
        function getWomanName():string;
        procedure setmarrystep(anum:integer); //设置 当前 婚礼第几步骤

        procedure showsetofficiator(uUser:tuser; atext:string); //设置主婚礼 人 弹出筐
        procedure showsetofficiatorInput(uUser:tuser; aname:string; yid:integer; astate:boolean); //设置主婚礼 人 弹出筐
        procedure showsetofficiatorInputOk(uUser:tuser; yid:integer; astate:boolean); //设置主婚礼 人 弹出筐
        function getofficiator():string; //获取 主婚人
        function setofficiator(aname:string):boolean; //设置主婚人

        procedure showmarriage(atext:string; atype:integer);
        procedure showmarriageOk(uUser:tuser; yid:integer; astate:boolean); //问题 回复

        procedure SetAuditoria(aManName, aWomanName:string); //设置新人 结婚仪式
        procedure Update(CurTick:integer);
        procedure LoadFromFile(aFileName:string);
        procedure Clear;
        procedure SaveToFile(aFileName:string);

    end;

    TmarriedData = record
        rManName:string[32];
        rWomanName:string[32];
        rTime:string[32];          //结婚时间
        rMarriage:integer;         //婚礼 仪式 次数量
        rManNameClothes:boolean;   //礼物
        rWomanNameClothes:boolean; //礼物
    end;
    pTmarriedData = ^TmarriedData;
    //已婚列表
    Tmarriedlist = class
    private
        DataList:TList;
        NameKey:TStringKeyClass;
        ADDMsgList:TResponsion;    //应答列表  求婚应答

        FDCurTick:integer;
        procedure Clear;
    public
        constructor Create;
        destructor Destroy; override;
        procedure add(amanname, awomanname, atime:string); //增加 夫妻
        procedure unMarryInput(uUser:Tuser); //离婚
        procedure unMarryResponsionOk(aUser:Tuser; ID:integer; astate:boolean); //对方 回答

        procedure MarryInput(uUser:Tuser; atext:string); //输入求婚
        procedure MarryInputName(uUser:Tuser; destName:string; yid:integer); //输入名字 后
        procedure MarryResponsionOk(aUser:Tuser; ID:integer); //对方 回答
        procedure MarryResponsionNO(aUser:Tuser; ID:integer); //对方 回答
        procedure del(aname:string);
        procedure LoadFromFile(aFileName:string);
        procedure SaveToFile(aFileName:string);
        function GetName(aUserName:string):pointer;
        function GetConsortName(aUserName:string):string;
        procedure setOnLine(uUser:tuser); //上线 通知
        procedure setGameExit(uUser:tuser); //上线 通知
        function IsMarried(aUserName:string):boolean; //测试 已婚
        function ISMarriage(aUserName:string):boolean; //测试 婚礼状态    'true'举行过婚礼 'false'没举行过婚礼
        procedure setMarriage(aUserName:string); //设置 举行过婚礼
        procedure SetAuditoria(aName:string); //设置新人 占用 教堂
        function IsClothes(aname:string):boolean; //测试是否发放过礼物
        procedure SetClothes(aname:string); //发放过礼物

        procedure Update(CurTick:integer);
    end;
var
    marriedlist     :Tmarriedlist;
    Marriage        :TMarriage;
implementation

constructor TMarriage.Create;
begin
    inherited Create;
    LoadFromFile('.\Marriage\Marriage.SDB');
    MsgList := TResponsion.Create; //应答列表  求婚应答
end;

destructor TMarriage.Destroy;
begin
    SaveToFile('.\Marriage\Marriage.SDB');
    MsgList.Free;
    inherited destroy;
end;

procedure TMarriage.setAuditoria(aManName, aWomanName:string); //设置新人 结婚仪式
begin
    if not IsAuditoria then
    begin
        bouser := true;
        FManName := aManName;
        FWomanName := aWomanName;
        FTIME := mmAnsTick;
        Fstep := 0;
        marriedlist.setMarriage(aManName); //设置 记录下 已经举行过婚礼
    end;
end;

function TMarriage.getofficiator():string; //获取 主婚人
begin
    result := '';
    if not bouser then exit;
    result := Fofficiator;
end;

function TMarriage.setofficiator(aname:string):boolean; //设置主婚人
var
    tempuser        :tuser;
begin
    result := false;
    if not bouser then exit;
    Fofficiator := aname;
    UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s与%s的婚礼，主婚人是%s。', [FManName, FWomanName, Fofficiator]));
    result := true;
end;

procedure TMarriage.showmarriageOk(uUser:tuser; yid:integer; astate:boolean); //问题 回复
var
    tempuser        :tuser;
begin
    if not bouser then exit;
    if MsgList.GetID(yid) = nil then
    begin
        uUser.SendClass.SendChatMessage('消息过期。', SAY_COLOR_SYSTEM);
        tempuser := UserList.GetUserPointer(Fofficiator);
        if tempuser = nil then exit;
        tempuser.SendClass.SendChatMessage(format('主婚人注意：%s的问答已经过期。', [uUser.name]), SAY_COLOR_SYSTEM);
        exit;
    end;
    MsgList.delId(yid);
    inc(Fstep);
    if astate then
    begin
        if FManName = uUser.name then
            UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s新郎回答的[是]。', [Ftext]))
        else
            UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s新娘回答的[是]。', [Ftext]));
    end else
    begin
        if FManName = uUser.name then
            UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s新郎回答的[否]。', [Ftext]))
        else
            UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s新娘回答的[否]。', [Ftext]));

    end;

end;

procedure TMarriage.showmarriage(atext:string; atype:integer);
var
    tempuser        :tuser;
    Yid             :integer;
begin
    if not bouser then exit;

    if atype = 1 then
    begin
        tempuser := UserList.GetUserPointer(FManName);
        if tempuser = nil then exit;
        //发送 给对方 等待应答
        MsgList.del(tempuser.name);
        yid := MsgList.add(tempuser.name, '');
        if yid <= 0 then
        begin
            tempuser.SendClass.SendChatMessage('申请验证ID失败。', SAY_COLOR_SYSTEM);
            exit;
        end;
        tempuser.SendClass.SendShowInputOk(ShowInputOk_type_marry_showmarriage, yid, atext);
        Ftext := atext;
        UserList.SendTopMSG(WinRGB(28, 28, 28), atext);
    end
    else if atype = 2 then
    begin
        tempuser := UserList.GetUserPointer(FWomanName);
        if tempuser = nil then exit;
        //发送 给对方 等待应答
        MsgList.del(tempuser.name);
        yid := MsgList.add(tempuser.name, '');
        if yid <= 0 then
        begin
            tempuser.SendClass.SendChatMessage('申请验证ID失败。', SAY_COLOR_SYSTEM);
            exit;
        end;
        tempuser.SendClass.SendShowInputOk(ShowInputOk_type_marry_showmarriage, yid, atext);
        Ftext := atext;
        UserList.SendTopMSG(WinRGB(28, 28, 28), atext);
    end;
end;

function TMarriage.IsParty(aname:string):boolean;
begin
    result := false;
    if not bouser then exit;
    if (FManName = aname) or (FWomanName = aname) then
        result := true;
end;

function TMarriage.getManName():string;
begin
    result := FManName;
end;

function TMarriage.getWomanName():string;
begin
    result := FWomanName;
end;

function TMarriage.getmarrystep():integer; //
begin
    result := Fstep;
end;

procedure TMarriage.showsetofficiatorInputOk(uUser:tuser; yid:integer; astate:boolean); //设置主婚礼 人 弹出筐
var
    Manuser, woManuser:tuser;
begin
    if not bouser then exit;
    Manuser := UserList.GetUserPointer(FManName);
    woManuser := UserList.GetUserPointer(FWomanName);
    if MsgList.GetID(yid) = nil then
    begin
        uUser.SendClass.SendChatMessage('消息过期。', SAY_COLOR_SYSTEM);
        if woManuser <> nil then
            woManuser.SendClass.SendChatMessage(format('%s 答复了主婚人消息，但消息已经过期。', [uUser.name]), SAY_COLOR_SYSTEM);
        if Manuser <> nil then
            Manuser.SendClass.SendChatMessage(format('%s 答复了主婚人消息，但消息已经过期。', [uUser.name]), SAY_COLOR_SYSTEM);
        exit;
    end;
    MsgList.delId(yid);

    if astate then
    begin
        setofficiator(uUser.name);
        if woManuser <> nil then
            woManuser.SendClass.SendChatMessage(format('%s 同意当主婚人。', [uUser.name]), SAY_COLOR_SYSTEM);
        if Manuser <> nil then
            Manuser.SendClass.SendChatMessage(format('%s 同意当主婚人', [uUser.name]), SAY_COLOR_SYSTEM);

    end else
    begin
        if woManuser <> nil then
            woManuser.SendClass.SendChatMessage(format('%s 拒绝当主婚人。', [uUser.name]), SAY_COLOR_SYSTEM);
        if Manuser <> nil then
            Manuser.SendClass.SendChatMessage(format('%s 拒绝当主婚人', [uUser.name]), SAY_COLOR_SYSTEM);
    end;

end;

procedure TMarriage.showsetofficiatorInput(uUser:tuser; aname:string; yid:integer; astate:boolean); //设置主婚礼 人 弹出筐
var
    tempuser        :tuser;
begin
    if not bouser then exit;
    if not astate then exit;
    if MsgList.GetID(yid) = nil then
    begin
        uUser.SendClass.SendChatMessage('消息过期。', SAY_COLOR_SYSTEM);
        exit;
    end;
    MsgList.delId(yid);

    tempuser := UserList.GetUserPointer(aname);
    if tempuser = nil then
    begin
        uUser.SendClass.SendChatMessage(format('设置主婚人失败！%s 不在线', [aName]), SAY_COLOR_SYSTEM);
        exit;
    end;
    MsgList.del(uUser.name);
    yid := MsgList.add(uUser.name, '');
    if yid <= 0 then
    begin
        uUser.SendClass.SendChatMessage('申请验证ID失败。', SAY_COLOR_SYSTEM);
        exit;
    end;

    uUser.SendClass.SendChatMessage(format('设置主婚人为%s 等待他应答', [aName]), SAY_COLOR_SYSTEM);
    tempuser.SendClass.SendShowInputOk(ShowInputOk_type_marry_setofficiator, yid, '你是否愿意当主婚人。');
end;

procedure TMarriage.showsetofficiator(uUser:tuser; atext:string); //设置主婚礼 人 弹出筐
var
    yid             :integer;
begin
    if not bouser then exit;
    if not IsParty(uUser.name) then
    begin
        uUser.SendClass.SendChatMessage('新郎新娘才能设置主婚人。', SAY_COLOR_SYSTEM);
        exit;
    end;
    MsgList.del(uUser.name);
    yid := MsgList.add(uUser.name, '');
    if yid <= 0 then
    begin
        uUser.SendClass.SendChatMessage('申请验证ID失败。', SAY_COLOR_SYSTEM);
        exit;
    end;
    uUser.SendClass.SendShowInputString2(ShowInputString_type_marrysetofficiator, yid, atext);
end;

procedure TMarriage.setmarrystep(anum:integer); //设置 当前 婚礼第几步骤
begin
    Fstep := anum;
end;

function TMarriage.IsAuditoria():boolean; //
begin
    result := bouser;
end;

procedure TMarriage.Update(CurTick:integer);
var
    i               :integer;
begin
    if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
    FDCurTick := CurTick;          //处理 婚礼 流程 步骤
    MsgList.UPDATE(CurTick);
    if not bouser then exit;
    i := (CurTick - FTIME);
    i := GetItemLineTime(i);
    if i >= 60 * 2 then
    begin
        //结束
        bouser := false;
        if (FManName <> '') and (FWomanName <> '') then
            UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s与%s的婚礼，因超时自动被取消。', [FManName, FWomanName]));
        FManName := '';
        FWomanName := '';
    end;
end;

procedure TMarriage.Clear;
begin
    bouser := false;
    FManName := '';
    FWomanName := '';
end;

procedure TMarriage.LoadFromFile(aFileName:string);
var
    i               :integer;
    str, rdstr      :string;
    StringList      :TStringList;
begin

    if not FileExists(aFileName) then exit;

    StringList := TStringList.Create;
    try
        StringList.LoadFromFile(aFileName);
        if StringList.Count >= 2 then
        begin
            i := 1;
            str := StringList[i];
            str := GetValidStr3(str, rdstr, ',');
            FManName := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            FWomanName := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            FTime := 0;            //_StrToInt(rdstr);  改成0 关闭TGS 重新开 回到0 需要完善
            str := GetValidStr3(str, rdstr, ',');
            if rdstr = 'true' then
                bouser := true
            else bouser := false;
            str := GetValidStr3(str, rdstr, ',');
            Ftext := (rdstr);
            str := GetValidStr3(str, rdstr, ',');
            Fofficiator := (rdstr);
            str := GetValidStr3(str, rdstr, ',');
            Fstep := _strtoint(rdstr);
        end;
    finally
        StringList.Free;
    end;
end;

procedure TMarriage.SaveToFile(aFileName:string);
var
    i               :integer;
    str             :string;
    StringList      :TStringList;

begin

    StringList := TStringList.Create;
    try

        str := 'uManName,uWomanName,uTime,uboUser,utext,uofficiator,ustep';
        StringList.add(str);

        if bouser then str := 'true' else str := 'false';
        str := FManName + ',' + FWomanName + ',' + inttostr(FTime) + ',' + str + ',' + Ftext + ',' + Fofficiator + ',' + inttostr(Fstep) + ',';
        StringList.Add(str);

        StringList.SaveToFile(aFileName);
    finally
        StringList.Free;
    end;

end;
//-----------------------------

constructor Tmarriedlist.Create;
begin
    NameKey := TStringKeyClass.Create;
    DataList := TList.Create;
    LoadFromFile('.\Marriage\marriedlist.SDB');
    ADDMsgList := TResponsion.Create; //加人  等待 应答 列表
end;

destructor Tmarriedlist.Destroy;
begin
    SaveToFile('.\Marriage\marriedlist.SDB');
    Clear;
    DataList.Free;
    NameKey.Free;
    ADDMsgList.Free;
    inherited destroy;
end;

procedure Tmarriedlist.Clear;
var
    i               :integer;
    pp              :pTmarriedData;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        pp := (DataList.Items[i]);
        dispose(pp);
    end;
    DataList.Clear;
    NameKey.Clear;
end;

procedure Tmarriedlist.unmarryInput(uUser:Tuser); //离婚
var
    id              :integer;
    auser           :tuser;
    pp              :pTmarriedData;
begin
    if not IsMarried(uUser.name) then
    begin
        uUser.SendClass.SendChatMessage('你没结婚，离婚申请失败！', SAY_COLOR_SYSTEM);
        exit;
    end;

    pp := GetName(uUser.name);
    if pp = nil then
    begin
        uUser.SendClass.SendChatMessage(('错误！婚姻登记没你的档案。'), SAY_COLOR_SYSTEM);
        exit;
    end;
    //增加到 应答 验证
    ADDMsgList.del(uUser.name);
    if pp.rManName = uUser.name then
        id := ADDMsgList.add(pp.rWomanName, uUser.name)
    else
        id := ADDMsgList.add(pp.rManName, uUser.name);
    if id <= 0 then
    begin
        uUser.SendClass.SendChatMessage(('验证ID申请失败。'), SAY_COLOR_SYSTEM);
        exit;
    end;
    if pp.rManName = uUser.name then
    begin
        auser := UserList.GetUserPointer(pp.rWomanName);
    end else
    begin
        auser := UserList.GetUserPointer(pp.rManName);
    end;
    if auser = nil then
    begin
        uUser.SendClass.SendChatMessage(('离婚失败！对方不在线。'), SAY_COLOR_SYSTEM);
        exit;
    end;
    //发送 给对方 等待应答
    auser.SendClass.SendShowInputOk(ShowInputOk_type_ummarry, id
        , format('您的配偶【%s】希望跟您解除婚约！是否同意。', [uUser.name]));
    uUser.SendClass.SendChatMessage(('离婚请求发出，等待对方应答。'), SAY_COLOR_SYSTEM);
end;

//对方回答

procedure Tmarriedlist.unMarryResponsionOk(aUser:Tuser; ID:integer; astate:boolean); //
var
    uUser           :tuser;
    p               :PTResponsiondata;
    amanname, awomanname:string;
    pp              :pTmarriedData;
begin

    p := ADDMsgList.GetID(id);
    if p = nil then
    begin
        aUser.SendClass.SendChatMessage('消息已过期。', SAY_COLOR_SYSTEM);
        exit;
    end;
    if p.rDestName <> auser.name then
    begin
        aUser.SendClass.SendChatMessage('错误！消息验证失败。', SAY_COLOR_SYSTEM);
        exit;
    end;
    uUser := UserList.GetUserPointer(p.rSourceName);
    ADDMsgList.delId(id);
    if uUser = nil then
    begin
        aUser.SendClass.SendChatMessage(format('离婚失败！【%s】不在线。', [p.rSourceName]), SAY_COLOR_SYSTEM);
        exit;
    end;
    if not astate then
    begin
        uUser.SendClass.SendChatMessage(format('离婚失败！【%s】拒绝离婚。', [aUser.name]), SAY_COLOR_SYSTEM);
        exit;
    end;
    if auser.BasicData.Feature.rboman then
    begin
        amanname := auser.name;
        awomanname := uuser.name;
    end
    else
    begin
        amanname := uuser.name;
        awomanname := auser.name;
    end;

    pp := GetName(auser.name);
    if pp = nil then
    begin
        aUser.SendClass.SendChatMessage(('错误！婚姻登记没你的档案。'), SAY_COLOR_SYSTEM);
        exit;
    end;

    if (pp.rManName <> amanname) or (pp.rWomanName <> awomanname) then
    begin
        uUser.SendClass.SendChatMessage(('错误！婚姻登记档案不一致。'), SAY_COLOR_SYSTEM);
        aUser.SendClass.SendChatMessage(('错误！婚姻登记档案不一致。'), SAY_COLOR_SYSTEM);
        exit;
    end;
    del(auser.name);
    //发消息 通知 配偶发生 改变
    uuser.Marrydel;
    auser.Marrydel;
    uuser.BocChangeProperty;
    auser.BocChangeProperty;

    UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s与%s已经解除婚约。', [amanname, awomanname]));
end;

//申请

procedure Tmarriedlist.marryInput(uUser:Tuser; atext:string); //求婚
var
    id              :integer;
begin
    if IsMarried(uUser.name) then
    begin
        uUser.SendClass.SendChatMessage('你已经结婚！求婚失败！', SAY_COLOR_SYSTEM);
        exit;
    end;
    //增加到 应答 验证
    ADDMsgList.del(uUser.name);
    id := ADDMsgList.add('', uUser.name);
    if id <= 0 then
    begin
        uUser.SendClass.SendChatMessage(('求婚失败！系统内部错误！。'), SAY_COLOR_SYSTEM);
        exit;
    end;
    uUser.SendClass.SendShowInputString2(ShowInputString_type_marryinput, id, atext);
end;
//输入 目标后

procedure Tmarriedlist.MarryInputName(uUser:Tuser; destName:string; yid:integer); //
var
    auser           :tuser;
    id              :integer;
    p               :PTResponsiondata;
begin
    //验证
    p := ADDMsgList.GetID(yid);
    if p = nil then
    begin
        uUser.SendClass.SendChatMessage('求婚失败！消息已过期。', SAY_COLOR_SYSTEM);
        exit;
    end;
    if p.rSourceName <> uUser.name then
    begin
        uUser.SendClass.SendChatMessage('错误！消息验证失败。', SAY_COLOR_SYSTEM);
        exit;
    end;
    ADDMsgList.delId(yid);

    if IsMarried(uUser.name) then
    begin
        uUser.SendClass.SendChatMessage('你已经结婚！求婚失败！', SAY_COLOR_SYSTEM);
        exit;
    end;
    auser := UserList.GetUserPointer(destName);
    if auser = nil then
    begin
        uUser.SendClass.SendChatMessage(format('求婚失败！【%s】 不在线。', [destName]), SAY_COLOR_SYSTEM);
        exit;
    end;
    if auser.BasicData.Feature.rboman = uUser.BasicData.Feature.rboman then
    begin
        uUser.SendClass.SendChatMessage(format('求婚失败！【%s】于你性别一样。', [aUser.name]), SAY_COLOR_SYSTEM);
        aUser.SendClass.SendChatMessage(format('求婚失败！【%s】于你性别一样。', [uUser.name]), SAY_COLOR_SYSTEM);
        exit;
    end;
    if IsMarried(auser.name) then
    begin
        uUser.SendClass.SendChatMessage(format('求婚失败！【%s】已婚！。', [auser.name]), SAY_COLOR_SYSTEM);
        exit;
    end;
    //增加到 应答 验证
    ADDMsgList.del(aUser.name);
    id := ADDMsgList.add(aUser.name, uUser.name);
    if id <= 0 then
    begin
        uUser.SendClass.SendChatMessage(('求婚失败！系统内部错误！。'), SAY_COLOR_SYSTEM);
        exit;
    end;
    //发送 给对方 等待应答
    auser.SendClass.SendShowInputOk(ShowInputOk_type_marryMsg, id
        , format('【%s】向你求婚！是否同意。', [uUser.name]));
    uUser.SendClass.SendChatMessage(('求婚请求发出，等待对方应答。'), SAY_COLOR_SYSTEM);
end;
//对方回答

procedure Tmarriedlist.MarryResponsionOk(aUser:Tuser; ID:integer); //
var
    uUser           :tuser;
    p               :PTResponsiondata;
    amanname, awomanname:string;
begin

    p := ADDMsgList.GetID(id);
    if p = nil then
    begin
        aUser.SendClass.SendChatMessage('求婚失败！消息已过期。', SAY_COLOR_SYSTEM);
        exit;
    end;
    if p.rDestName <> auser.name then
    begin
        aUser.SendClass.SendChatMessage('错误！消息验证失败。', SAY_COLOR_SYSTEM);
        exit;
    end;
    uUser := UserList.GetUserPointer(p.rSourceName);
    ADDMsgList.delId(id);
    if uUser = nil then
    begin
        aUser.SendClass.SendChatMessage(('求婚失败！对方不在线。'), SAY_COLOR_SYSTEM);
        exit;
    end;

    if auser.BasicData.Feature.rboman = uUser.BasicData.Feature.rboman then
    begin
        uUser.SendClass.SendChatMessage(format('求婚失败！【%s】于你性别一样。', [aUser.name]), SAY_COLOR_SYSTEM);
        aUser.SendClass.SendChatMessage(format('求婚失败！【%s】于你性别一样。', [uUser.name]), SAY_COLOR_SYSTEM);
        exit;
    end;

    if IsMarried(uUser.name) then
    begin
        uUser.SendClass.SendChatMessage(format('求婚失败！【%s】已婚。', [uUser.name]), SAY_COLOR_SYSTEM);
        aUser.SendClass.SendChatMessage(format('求婚失败！【%s】已婚。', [uUser.name]), SAY_COLOR_SYSTEM);

        exit;
    end;
    if IsMarried(aUser.name) then
    begin
        uUser.SendClass.SendChatMessage(format('求婚失败！【%s】已婚。', [aUser.name]), SAY_COLOR_SYSTEM);
        aUser.SendClass.SendChatMessage(format('求婚失败！【%s】已婚。', [aUser.name]), SAY_COLOR_SYSTEM);

        exit;
    end;
    //结婚 成功
    if auser.BasicData.Feature.rboman then
    begin
        amanname := auser.name;
        awomanname := uuser.name;
    end
    else
    begin
        amanname := uuser.name;
        awomanname := auser.name;
    end;
    //增加
    add(amanname, awomanname, datetimetostr(now()));
    //发消息 通知 配偶发生 改变
    uuser.MarrySet(auser.name);
    auser.MarrySet(uuser.name);
    uuser.BocChangeProperty;
    auser.BocChangeProperty;
    //结婚完成
    UserList.SendTopMSG(WinRGB(28, 28, 28), format('%s与%s已经结婚,祝两位白头偕老，永远幸福。', [amanname, awomanname]));
end;

procedure Tmarriedlist.MarryResponsionNo(aUser:Tuser; ID:integer); //
var
    uUser           :tuser;
    p               :PTResponsiondata;
    amanname, awomanname:string;
begin

    p := ADDMsgList.GetID(id);
    if p = nil then
    begin
        aUser.SendClass.SendChatMessage('求婚失败！消息已过期。', SAY_COLOR_SYSTEM);
        exit;
    end;
    if p.rDestName <> auser.name then
    begin
        aUser.SendClass.SendChatMessage('错误！消息验证失败。', SAY_COLOR_SYSTEM);
        exit;
    end;
    uUser := UserList.GetUserPointer(p.rSourceName);
    ADDMsgList.delId(id);
    if uUser = nil then
    begin
        aUser.SendClass.SendChatMessage(('失败！对方不在线。'), SAY_COLOR_SYSTEM);
        exit;
    end;
    uUser.SendClass.SendChatMessage(format('求婚失败！【%s】拒绝了你。', [aUser.name]), SAY_COLOR_SYSTEM);
    aUser.SendClass.SendChatMessage(format('你拒绝了【%s】的求婚。', [uUser.name]), SAY_COLOR_SYSTEM);

end;

procedure Tmarriedlist.add(amanname, awomanname, atime:string);
var
    pp              :pTmarriedData;
begin
    new(pp);
    pp.rManName := amanname;
    pp.rWomanName := awomanname;
    pp.rTime := atime;
    pp.rMarriage := 0;             //婚礼 仪式 次数量
    pp.rManNameClothes := false;   //礼物
    pp.rWomanNameClothes := false; //礼物
    NameKey.Insert(pp.rWomanName, pp);
    NameKey.Insert(pp.rManName, pp);
    DataList.Add(pp);
    SaveToFile('.\Marriage\marriedlist.SDB'); //安全起见 结婚 就保存1次
end;

procedure Tmarriedlist.LoadFromFile(aFileName:string);
var
    i               :integer;
    str, rdstr      :string;
    StringList      :TStringList;
    tp              :TmarriedData;
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
            tp.rManName := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            tp.rWomanName := rdstr;
            str := GetValidStr3(str, rdstr, ',');
            tp.rTime := (rdstr);

            str := GetValidStr3(str, rdstr, ',');
            tp.rMarriage := _strtoint(rdstr);
            str := GetValidStr3(str, rdstr, ',');
            if (rdstr) = 'true' then
                tp.rManNameClothes := true
            else
                tp.rManNameClothes := false;
            str := GetValidStr3(str, rdstr, ',');
            if (rdstr) = 'true' then
                tp.rwoManNameClothes := true
            else
                tp.rwoManNameClothes := false;
            add(tp.rManName, tp.rWomanName, tp.rTime);
        end;
    finally
        StringList.Free;
    end;
end;

procedure Tmarriedlist.SaveToFile(aFileName:string);
var
    i               :integer;
    str, s1, s2     :string;
    StringList      :TStringList;
    pp              :pTmarriedData;
begin

    StringList := TStringList.Create;
    try
        str := 'uManName,uWomanName,uTime,uMarriage,uManNameClothes,uWomanNameClothes';
        StringList.add(str);
        for i := 0 to DataList.Count - 1 do
        begin
            pp := DataList[i];
            s1 := 'false';
            if pp.rManNameClothes then s1 := 'true';
            s2 := 'false';
            if pp.rWomanNameClothes then s2 := 'true';
            str := pp.rManName + ',' + pp.rWomanName + ',' + pp.rTime + ','
                + inttostr(pp.rMarriage) + ','
                + s1 + ','
                + s2 + ','
                ;
            StringList.Add(str);
        end;
        StringList.SaveToFile(aFileName);
    finally
        StringList.Free;
    end;
end;

procedure Tmarriedlist.Update(CurTick:integer);
var
    i               :integer;
    p               :pTResponsiondata;
begin
    if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
    FDCurTick := CurTick;

    I := 0;

    while I < ADDMsgList.Count do
    begin
        p := ADDMsgList.GetIndex(i);
        if CurTick > (p.rTime + 3000) then
        begin
            ADDMsgList.delIndex(i);
        end else INC(I);
    end;
end;

procedure Tmarriedlist.del(aname:string);
var
    pp              :pTmarriedData;
    i               :integer;
begin
    pp := NameKey.Select(aname);
    if pp = nil then exit;
    for i := 0 to DataList.Count - 1 do
    begin
        pp := DataList.Items[i];
        if (pp.rManName = aname) or (pp.rWomanName = aname) then
        begin
            NameKey.Delete(pp.rWomanName);
            NameKey.Delete(pp.rManName);
            dispose(pp);
            DataList.Delete(i);
            exit;
        end;
    end;

end;

function Tmarriedlist.IsClothes(aname:string):boolean; //测试是否发放过礼物
var
    pp              :pTmarriedData;
begin
    result := true;
    pp := GetName(aname);
    if pp = nil then exit;
    if pp.rManName = aname then
    begin
        result := pp.rManNameClothes;
        exit;
    end;
    if pp.rWomanName = aname then
    begin
        result := pp.rwoManNameClothes;
        exit;
    end;
end;

procedure Tmarriedlist.SetClothes(aname:string); //发放过礼物
var
    pp              :pTmarriedData;
begin
    pp := GetName(aname);
    if pp = nil then exit;
    if pp.rManName = aname then
    begin
        pp.rManNameClothes := true;
        exit;
    end;
    if pp.rWomanName = aname then
    begin
        pp.rwoManNameClothes := true;
        exit;
    end;
end;

procedure Tmarriedlist.SetAuditoria(aName:string); //设置新人 占用 教堂
var
    pp              :pTmarriedData;
begin
    pp := GetName(aName);
    if pp = nil then exit;
    Marriage.SetAuditoria(pp.rManName, pp.rWomanName);

end;

procedure Tmarriedlist.setMarriage(aUserName:string); //设置 举行过婚礼
var
    pp              :pTmarriedData;
begin
    pp := GetName(aUserName);
    if pp = nil then exit;
    if pp.rMarriage < 0 then pp.rMarriage := 0;
    inc(pp.rMarriage);

end;

function Tmarriedlist.ISMarriage(aUserName:string):boolean; //测试 婚礼状态    'true'举行过婚礼 'false'没举行过婚礼
var
    pp              :pTmarriedData;
begin
    result := true;
    pp := GetName(aUserName);
    if pp = nil then exit;
    if pp.rMarriage <= 0 then result := false;

end;

function Tmarriedlist.IsMarried(aUserName:string):boolean; //测试 已婚
begin
    result := false;
    if GetName(ausername) <> nil then result := true;
end;

function Tmarriedlist.GetName(aUserName:string):pointer;
begin
    Result := NameKey.Select(aUserName);
end;

procedure Tmarriedlist.setOnLine(uUser:tuser); //上线 通知
var
    tempuser        :tuser;
    aname           :string;

begin

    aname := GetConsortName(uuser.name);
    if aname = '' then exit;
    tempuser := UserList.GetUserPointer(aname);
    if tempuser = nil then
    begin
        if uUser.BasicData.Feature.rboman then
        begin
            uUser.SendClass.SendChatMessage(format('你的妻子【%s】当前离线。', [aname]), SAY_COLOR_SYSTEM);
        end else
        begin
            uUser.SendClass.SendChatMessage(format('你的老公【%s】当前离线。', [aname]), SAY_COLOR_SYSTEM);
        end;

        exit;
    end;
    if uUser.BasicData.Feature.rboman then
    begin
        uUser.SendClass.SendChatMessage(format('你的妻子【%s】当前在线。', [tempuser.name]), SAY_COLOR_SYSTEM);
        tempuser.SendClass.SendChatMessage(format('你的老公【%s】上线了。', [uUser.name]), SAY_COLOR_SYSTEM);
    end else
    begin
        uUser.SendClass.SendChatMessage(format('你的老公【%s】当前在线。', [tempuser.name]), SAY_COLOR_SYSTEM);
        tempuser.SendClass.SendChatMessage(format('你的妻子【%s】上线了。', [uUser.name]), SAY_COLOR_SYSTEM);
    end;

end;

procedure Tmarriedlist.setGameExit(uUser:tuser);
var
    tempuser        :tuser;
    aname           :string;
begin
    aname := GetConsortName(uuser.name);
    if aname = '' then exit;
    tempuser := UserList.GetUserPointer(aname);
    if tempuser = nil then
    begin
        exit;
    end;
    if uUser.BasicData.Feature.rboman then
    begin

        tempuser.SendClass.SendChatMessage(format('你的老公【%s】下线了。', [uUser.name]), SAY_COLOR_SYSTEM);
    end else
    begin

        tempuser.SendClass.SendChatMessage(format('你的妻子【%s】下线了。', [uUser.name]), SAY_COLOR_SYSTEM);
    end;

end;

function Tmarriedlist.GetConsortName(aUserName:string):string;
var
    p               :pTmarriedData;
begin
    result := '';
    p := NameKey.Select(aUserName);
    if p = nil then exit;
    if p.rManName = aUserName then
    begin
        result := p.rWomanName;
        exit;
    end;
    if p.rWomanName = aUserName then
    begin
        result := p.rManName;
        exit;
    end;
end;

initialization
    begin
        Marriage := TMarriage.Create;
        marriedlist := tmarriedlist.Create;

    end;

finalization
    begin

        Marriage.Free;
        marriedlist.Free;
    end;

end.

