unit fieldmsg;                     //本类 分析完可直接看注解

interface

uses
    Windows, SysUtils, Classes, DefType, svClass, uManager;

const
    //PHONE_BLOCK_SIZE = 16;         //16;
    PHONE_BLOCK_SIZE = 18;         //16; 1024可视范围

    FIRSTUSERSIZE   = PHONE_BLOCK_SIZE * 2;

    FIELDPHONE_STARTPOS = 0;
    FIELDPHONE_CENTERPOS = 4;
    FIELDPHONE_ENDPOS = 8;

type
    {16*16个坐标一组

    }

    TFieldProc = function(hfu:Longint; Msg:word; var SenderInfo:TBasicData; var aSubData:TSubData):Integer of object;

    TFieldUser = record
        hfu:LongInt;
        FieldProc:TFieldProc;
    end;

    PTFieldUser = ^TFieldUser;
    {
    TFieldPhone 消息通知类
    1，一地图为单位创建
    2，物体在什么地图就附加一份
    3，物体动作通过本类 通知发送出去
    主要成员：
    DataList:TList;
    1，以为格为单位 地图分组
    2，物体所在位置 分组 存入

    功能：
    发消息给物体当前地图周围物体。
    }
    TFieldPhone = class
    private
        Name:string;
        Manager:TManager;

        Width, Height:integer;
        Wblock, Hblock:integer;
        DataList:TList;            //组 列表（内放 物体列表）
        function GetFieldUser(hfu:LongInt; ax, ay:integer):PTFieldUser;
        function DeleteFieldUser(Puser:PTFieldUser; ax, ay:integer):Boolean;
        function GetDataListByXy(ax, ay, aPos:integer):TList;
    public
        constructor Create(aManager:TManager);
        destructor Destroy; override;
        function boExistUser(hfu:LongInt; ax, ay:integer):Boolean;
        procedure RegisterUser(hfu:LongInt; Proc:TFieldProc; ax, ay:integer);
        procedure UnRegisterUser(hfu:LongInt; ax, ay:integer);

        function SendMessage(hfu:Longint; Msg:word; var SenderInfo:TBasicData; var aSubData:TSubData):Integer;
    end;

implementation

uses
    MapUnit, SVMain;

constructor TFieldPhone.Create(aManager:TManager);
var
    i, j            :Integer;
    List            :TList;
begin
    Manager := aManager;

    Width := TMaper(Manager.Maper).Width;
    Height := TMaper(Manager.Maper).Height;

    wblock := Width div PHONE_BLOCK_SIZE + 1;
    hblock := Height div PHONE_BLOCK_SIZE + 1;

    Name := Manager.Title;

    DataList := TList.Create;
    for j := 0 to hblock - 1 do
    begin
        for i := 0 to wblock - 1 do
        begin
            List := TList.Create;
            DataList.Add(List);
        end;
    end;
end;

destructor TFieldPhone.Destroy;
var
    i, j            :integer;
    List            :TList;
begin
    for j := 0 to DataList.Count - 1 do
    begin
        List := DataList[j];
        for i := 0 to List.Count - 1 do
        begin
            Dispose(List[i]);
        end;
    end;
    for i := 0 to DataList.Count - 1 do TList(DataList[i]).Free;
    DataList.Free;
    inherited Destroy;
end;
//获取 组首地址

function TFieldPhone.GetDataListByXy(ax, ay, aPos:integer):TList;
var
    n               :integer;
    xb, yb          :integer;
begin
    Result := nil;
    if dataList.Count = 0 then exit;

    xb := ax div PHONE_BLOCK_SIZE;
    yb := ay div PHONE_BLOCK_SIZE;

    case aPos of
        0:
            begin
                xb := xb - 1;
                yb := yb - 1;
            end;
        1:
            begin
                xb := xb;
                yb := yb - 1;
            end;
        2:
            begin
                xb := xb + 1;
                yb := yb - 1;
            end;
        3:
            begin
                xb := xb - 1;
                yb := yb;
            end;
        4:;
        5:
            begin
                xb := xb + 1;
                yb := yb;
            end;
        6:
            begin
                xb := xb - 1;
                yb := yb + 1;
            end;
        7:
            begin
                xb := xb;
                yb := yb + 1;
            end;
        8:
            begin
                xb := xb + 1;
                yb := yb + 1;
            end;
    else exit;
    end;

    if (xb < 0) or (xb >= wblock) then exit;
    if (yb < 0) or (yb >= hblock) then exit;

    n := xb + yb * wblock;

    if (n >= DataList.Count) or (n < 0) then exit;
    Result := DataList[n];
end;

function TFieldPhone.GetFieldUser(hfu:LongInt; ax, ay:integer):PTFieldUser;
var
    i, j            :integer;
    pu              :PTFieldUser;
    List            :TList;
begin
    Result := nil;

    j := 4;
    //获取 本组
    List := GetDataListByXy(ax, ay, j);
    if List <> nil then
    begin
        //本组内 搜索目标ID
        for i := 0 to List.Count - 1 do
        begin
            pu := List.items[i];
            if pu^.hfu = hfu then
            begin
                Result := pu;
                exit;
            end;
        end;
    end;
    //上面没找到
    //周围8格内 继续搜索
    for j := 0 to 8 do
    begin
        if j = 4 then continue;
        List := GetDataListByXy(ax, ay, j);
        if List = nil then continue;

        for i := 0 to List.Count - 1 do
        begin
            pu := List.items[i];
            if pu^.hfu = hfu then
            begin
                Result := pu;
                exit;
            end;
        end;
    end;

end;
//从目标组 删除物体

function TFieldPhone.DeleteFieldUser(puser:PTFieldUser; ax, ay:integer):Boolean;
var
    i, j            :integer;
    pu              :PTFieldUser;
    List            :TList;
begin
    Result := FALSE;

    j := 4;
    List := GetDataListByXy(ax, ay, j);
    if List <> nil then
    begin
        for i := 0 to List.Count - 1 do
        begin
            pu := List[i];
            if pu = puser then
            begin
                dispose(pu);
                List.Delete(i);
                Result := TRUE;
                exit;
            end;
        end;
    end;

    for j := 0 to 8 do
    begin
        if j = 4 then continue;
        List := GetDataListByXy(ax, ay, j);
        if List = nil then continue;

        for i := 0 to List.Count - 1 do
        begin
            pu := List[i];
            if pu = puser then
            begin
                dispose(pu);
                List.Delete(i);
                Result := TRUE;
                exit;
            end;
        end;
    end;
end;
//////////////////////////////////////////////
//                   注册
//增加到 地图 分组 管理

procedure TFieldPhone.RegisterUser(hfu:LongInt; Proc:TFieldProc; ax, ay:integer);
var
    puser           :PTFieldUser;
    List            :TList;
begin
    List := GetDataListByXy(ax, ay, FIELDPHONE_CENTERPOS); //找 坐标对应组
    if List = nil then exit;

    puser := GetFieldUser(hfu, ax, ay);
    if puser = nil then
    begin
        new(puser);
        puser^.hfu := hfu;
        puser^.FieldProc := Proc;
        List.Add(puser);
    end else
    begin                          //目标存在 肯定有问题  ID编号不可能重复，所以不会有失败可能
        frmMain.WriteLogInfo('TFieldPhone.RegisterUser () failed');
    end;
end;
//注销 删除1个

procedure TFieldPhone.UnRegisterUser(hfu:LongInt; ax, ay:integer);
var
    puser           :PTFieldUser;
begin
    puser := GetFieldUser(hfu, ax, ay);
    if puser <> nil then
    begin
        DeleteFieldUser(puser, ax, ay);
    end else
    begin
        frmMain.WriteLogInfo('TFieldPhone.UnRegisterUser () failed');
    end;
end;
//测试 存在

function TFieldPhone.boExistUser(hfu:LongInt; ax, ay:integer):Boolean;
var
    puser           :PTFieldUser;
begin
    puser := GetFieldUser(hfu, ax, ay);
    if puser <> nil then Result := TRUE
    else Result := FALSE;
end;
//发送 消息

function TFieldPhone.SendMessage(hfu:Longint; Msg:word; var SenderInfo:TBasicData; var aSubData:TSubData):Integer;
var
    i, j            :integer;
    List            :TList;
    puser           :PTFieldUser;
    Changed         :TFieldUser;
    flag            :boolean;
begin
    ////////////////////////////////////////////////////////
    //                       移动
    if msg = FM_MOVE then
    begin
        flag := FALSE;
        //跨组 测试
        if (SenderInfo.x div PHONE_BLOCK_SIZE) <> (SenderInfo.nx div PHONE_BLOCK_SIZE) then flag := TRUE;
        if (SenderInfo.y div PHONE_BLOCK_SIZE) <> (SenderInfo.ny div PHONE_BLOCK_SIZE) then flag := TRUE;
        if flag then
        begin
            //跨组
            puser := GetFieldUser(SenderInfo.Id, SenderInfo.x, SenderInfo.y);
            if puser <> nil then
            begin
                Changed := puser^;
                //从原组 删除
                DeleteFieldUser(puser, SenderInfo.x, SenderInfo.y);
                //注册 到新组
                RegisterUser(SenderInfo.id, Changed.FieldProc, SenderInfo.nx, SenderInfo.ny);
            end;
        end;
    end;
    ////////////////////////////////////////////////////////
    //                        
    if hfu = MANAGERPHONE then
    begin
        Result := ManagerList.FieldProc(hfu, Msg, Senderinfo, aSubData);
        exit;
    end;
    ////////////////////////////////////////////////////////
    //                       广播全部目标
    if hfu = NOTARGETPHONE then
    begin
        //消息 给 目标
        puser := GetFieldUser(SenderInfo.id, SenderInfo.x, SenderInfo.y);
        if puser <> nil then
        begin
            Result := puser^.FieldProc(hfu, Msg, SenderInfo, aSubData);
        end else
        begin
            Result := -1;
            exit;
        end;
        //消息 发到8格子内 所有人
        for j := 0 to 8 do
        begin
            List := GetDataListByXy(SenderInfo.x, SenderInfo.y, j);
            if List = nil then continue;
            //每个格 能存放的 物体 没限制
            for i := 0 to List.Count - 1 do
            begin
                puser := List[i];
                if puser^.hfu = SenderInfo.id then continue;
                Result := puser^.FieldProc(0, Msg, SenderInfo, aSubData);
            end;
        end;
    end else
    begin
        //消息 发到 指定 ID
        puser := GeTFieldUser(hfu, SenderInfo.x, SenderInfo.y);
        if puser <> nil then
        begin
            Result := puser^.FieldProc(hfu, Msg, SenderInfo, aSubData);
        end else
        begin
            if (msg <> FM_NONE) and (msg <> FM_ADDITEM) and
                (msg <> FM_CLICK) then ;
            Result := -1;
        end;
    end;
end;

end.

