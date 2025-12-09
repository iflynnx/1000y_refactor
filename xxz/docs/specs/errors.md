# 错误处理规范

> **适用范围**：仙侠传 (XXZ) 项目所有错误处理

---

## 1. 错误码定义

### 1.1 全局错误码

```pascal
type
  TErrorCode = (
    // 成功 (0)
    ecSuccess = 0,

    // 通用错误 (1-99)
    ecUnknown = 1,
    ecInvalidParam = 2,
    ecTimeout = 3,
    ecNotFound = 4,
    ecAlreadyExists = 5,
    ecPermissionDenied = 6,
    ecNotImplemented = 7,

    // 网络错误 (100-199)
    ecNetworkError = 100,
    ecConnectionLost = 101,
    ecSendFailed = 102,
    ecReceiveFailed = 103,
    ecInvalidPacket = 104,
    ecDecryptFailed = 105,

    // 登录错误 (200-299)
    ecAccountNotExist = 200,
    ecPasswordError = 201,
    ecAccountBanned = 202,
    ecAccountOnline = 203,
    ecAccountLocked = 204,

    // 角色错误 (300-399)
    ecCharNotExist = 300,
    ecCharNameExists = 301,
    ecCharLimitReached = 302,
    ecCharInUse = 303,

    // 物品错误 (400-499)
    ecItemNotFound = 400,
    ecItemNotEnough = 401,
    ecBagFull = 402,
    ecItemCannotUse = 403,
    ecItemCannotEquip = 404,
    ecItemLevelLimit = 405,

    // 技能错误 (500-599)
    ecSkillNotLearned = 500,
    ecSkillCooldown = 501,
    ecMPNotEnough = 502,
    ecTargetOutOfRange = 503,

    // 交易错误 (600-699)
    ecGoldNotEnough = 600,
    ecTradeTargetBusy = 601,
    ecAuctionItemNotFound = 602
  );
```

### 1.2 错误码分组

| 范围 | 分类 |
|------|------|
| 0 | 成功 |
| 1-99 | 通用错误 |
| 100-199 | 网络错误 |
| 200-299 | 登录错误 |
| 300-399 | 角色错误 |
| 400-499 | 物品错误 |
| 500-599 | 技能错误 |
| 600-699 | 交易错误 |

---

## 2. 异常策略

### 2.1 何时使用异常

| 场景 | 处理方式 | 说明 |
|------|----------|------|
| 程序初始化失败 | 抛异常 | 无法恢复，必须终止 |
| 配置文件错误 | 抛异常 | 启动前必须修复 |
| 内存分配失败 | 抛异常 | 系统级错误 |
| 网络操作失败 | 返回错误码 | 可恢复，需要重试逻辑 |
| 业务逻辑错误 | 返回错误码 | 正常流程的一部分 |
| 协议解析失败 | 返回错误码 + 日志 | 记录并丢弃错误包 |

### 2.2 自定义异常类型

```pascal
type
  EGameException = class(Exception)
  private
    FErrorCode: TErrorCode;
  public
    constructor Create(aCode: TErrorCode; const aMsg: string);
    property ErrorCode: TErrorCode read FErrorCode;
  end;

  ENetworkException = class(EGameException);
  EConfigException = class(EGameException);
  EDataException = class(EGameException);
```

---

## 3. 错误处理模板

### 3.1 网络操作

```pascal
function SendPacket(aConnID: Cardinal; const aPacket: TPacketData): TErrorCode;
begin
  try
    if not FSocket.Send(aPacket) then
    begin
      Log.Error('发送失败: ConnID=%d', [aConnID]);
      Result := ecSendFailed;
      Exit;
    end;
    Result := ecSuccess;
  except
    on E: Exception do
    begin
      Log.Error('发送异常: ConnID=%d, Error=%s', [aConnID, E.Message]);
      Result := ecNetworkError;
    end;
  end;
end;
```

### 3.2 业务操作

```pascal
function UseItem(aPlayerID: Cardinal; aSlot: Byte): TErrorCode;
var
  Item: TItemInfo;
begin
  // 参数检查
  if aSlot >= BAG_SIZE then
  begin
    Result := ecInvalidParam;
    Exit;
  end;

  // 物品检查
  if not FItemManager.GetItem(aSlot, Item) then
  begin
    Result := ecItemNotFound;
    Exit;
  end;

  // 使用条件检查
  if not CanUseItem(Item) then
  begin
    Result := ecItemCannotUse;
    Exit;
  end;

  // 执行使用
  DoUseItem(Item);
  Result := ecSuccess;
end;
```

### 3.3 初始化操作

```pascal
procedure LoadConfig(const aPath: string);
var
  Ini: TIniFile;
begin
  if not FileExists(aPath) then
    raise EConfigException.Create(ecNotFound, 
      Format('配置文件不存在: %s', [aPath]));

  Ini := TIniFile.Create(aPath);
  try
    FPort := Ini.ReadInteger('Network', 'Port', 0);
    if FPort = 0 then
      raise EConfigException.Create(ecInvalidParam, '端口配置无效');
  finally
    Ini.Free;
  end;
end;
```

---

## 4. 日志记录规范

### 4.1 错误日志格式

```
[时间] [级别] [模块] 消息内容
```

示例：
```
[2024-01-01 12:00:00] [ERROR] [Network] 发送失败: ConnID=1234, Error=Connection reset
[2024-01-01 12:00:01] [WARN] [Game] 物品不足: PlayerID=5678, ItemID=100, Need=5, Have=3
```

### 4.2 需要记录的错误

| 级别 | 场景 |
|------|------|
| ERROR | 网络异常、数据库错误、协议解析失败 |
| WARN | 业务逻辑错误（物品不足、权限不足等） |
| INFO | 重要操作（登录、登出、交易） |
| DEBUG | 详细调试信息（仅开发环境） |

---

## 5. 客户端错误提示

### 5.1 错误消息映射

```pascal
function GetErrorMessage(aCode: TErrorCode): string;
begin
  case aCode of
    ecSuccess: Result := '';
    ecAccountNotExist: Result := '账号不存在';
    ecPasswordError: Result := '密码错误';
    ecAccountBanned: Result := '账号已被封禁';
    ecItemNotEnough: Result := '物品数量不足';
    ecGoldNotEnough: Result := '金币不足';
    ecMPNotEnough: Result := 'MP不足';
    // ...
  else
    Result := '未知错误';
  end;
end;
```

---

## 6. 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0 | 2025-12-08 | 初始版本 |
