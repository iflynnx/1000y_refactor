# Delphi 12.3 编码规范

> **适用范围**：仙侠传 (XXZ) 项目所有 Delphi 代码

---

## 1. 命名规范

### 1.1 通用规则

| 类型 | 规则 | 示例 |
|------|------|------|
| **单元名** | PascalCase，前缀表示模块 | `uNetProtocol.pas`, `uGameTypes.pas` |
| **类名** | T + PascalCase | `TPacketSender`, `TUserObject` |
| **接口名** | I + PascalCase | `INetConnection`, `IPacketHandler` |
| **记录名** | T + PascalCase | `TPacketHeader`, `TPlayerData` |
| **枚举名** | T + PascalCase | `TMessageType`, `TPlayerState` |
| **枚举值** | 小写前缀 + PascalCase | `mtLogin`, `mtLogout`, `psIdle` |
| **常量** | 全大写 + 下划线 | `MAX_PACKET_SIZE`, `DEFAULT_PORT` |
| **变量/字段** | PascalCase (公有) / F前缀 (私有) | `PlayerName`, `FSocket` |
| **参数** | a/A 前缀 + PascalCase | `aPacket`, `APlayerID` |
| **局部变量** | 小写开头 PascalCase | `tempBuffer`, `i`, `result` |
| **方法名** | PascalCase，动词开头 | `SendPacket`, `GetPlayerByID` |

### 1.2 前缀约定

| 前缀 | 含义 | 示例 |
|------|------|------|
| `u` | 单元文件 | `uNetProtocol.pas` |
| `T` | 类型 (类/记录/枚举) | `TPacketData` |
| `I` | 接口 | `INetServer` |
| `F` | 私有字段 | `FSocket` |
| `A` / `a` | 参数 | `aPacketData` |
| `bo` | Boolean 变量 | `boConnected` |
| `n` | 数值变量 | `nCount` |
| `s` | 字符串变量 | `sPlayerName` |

---

## 2. 单元结构

### 2.1 标准单元模板

```pascal
unit uModuleName;
{*******************************************************************************
  单元名称：uModuleName
  功能描述：简要描述此单元的功能
  作者：
  创建日期：
  修改历史：
*******************************************************************************}

interface

uses
  // 系统单元（按字母顺序）
  System.SysUtils, System.Classes, System.Generics.Collections,
  // mORMot2 单元
  mormot.core.base, mormot.core.text, mormot.net.sock,
  // 项目公共单元
  uGameTypes, uNetProtocol;

const
  // 常量定义

type
  // 类型定义（先声明后实现）
  TMyClass = class;

  // 枚举和记录
  TMyRecord = record
    Field1: Integer;
    Field2: string;
  end;

  // 类定义
  TMyClass = class
  private
    FField: Integer;
  protected
    procedure DoSomething;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute(aParam: Integer);
    property Field: Integer read FField write FField;
  end;

implementation

uses
  // 仅实现部分需要的单元
  uHelperUnit;

{ TMyClass }

constructor TMyClass.Create;
begin
  inherited Create;
  FField := 0;
end;

destructor TMyClass.Destroy;
begin
  // 释放资源
  inherited Destroy;
end;

procedure TMyClass.DoSomething;
begin
  // 实现
end;

procedure TMyClass.Execute(aParam: Integer);
begin
  FField := aParam;
  DoSomething;
end;

end.
```

### 2.2 Uses 顺序

```pascal
uses
  // 1. 系统单元
  System.SysUtils, System.Classes, System.Generics.Collections,
  // 2. 第三方库（mORMot2）
  mormot.core.base, mormot.core.text,
  // 3. 项目公共模块
  uGameTypes, uNetProtocol,
  // 4. 同层模块
  uLocalModule;
```

---

## 3. 代码格式

### 3.1 缩进与空格

- **缩进**：2 个空格（不使用 Tab）
- **行宽**：最大 100 字符
- **空行**：方法之间 1 空行，逻辑块之间 1 空行

### 3.2 begin/end 风格

```pascal
// 正确：begin 不换行
if Condition then
begin
  DoSomething;
  DoSomethingElse;
end
else
begin
  DoOther;
end;

// 单行语句可省略 begin/end，但需保持一致
if Condition then
  DoSomething;
```

### 3.3 参数换行

```pascal
// 参数过长时换行对齐
procedure LongMethodName(
  aParam1: Integer;
  aParam2: string;
  aParam3: TObject);
```

---

## 4. 注释规范

### 4.1 文件头注释

```pascal
{*******************************************************************************
  单元名称：uNetProtocol
  功能描述：网络协议定义和数据包处理
  作者：
  创建日期：YYYY-MM-DD
  修改历史：
    - YYYY-MM-DD: 描述修改内容
*******************************************************************************}
```

### 4.2 方法注释

```pascal
/// <summary>发送数据包到指定连接</summary>
/// <param name="aConnID">连接 ID</param>
/// <param name="aPacket">数据包</param>
/// <returns>是否发送成功</returns>
function SendPacket(aConnID: Integer; const aPacket: TPacketData): Boolean;
```

### 4.3 行内注释

```pascal
// 计算伤害值（包含 BUFF 加成）
nDamage := nBaseDamage * (1 + nBuffBonus);
```

---

## 5. mORMot2 使用规范

> 本项目最大化使用 mORMot2 框架

### 5.1 字符串处理

```pascal
// 项目内统一使用 RawUtf8
var
  sText: RawUtf8;
  
// 与外部接口交互时转换
sText := StringToUtf8(sAnsiText);
sAnsiText := Utf8ToString(sText);

// 推荐使用 FormatUtf8 替代 Format
sMsg := FormatUtf8('Player % joined', [sPlayerName]);
```

### 5.2 日志

```pascal
uses
  mormot.core.log;

// 在单元初始化时设置
TSynLog.Family.Level := LOG_VERBOSE;  // 开发环境
TSynLog.Family.DestinationPath := 'logs';
TSynLog.Family.PerThreadLog := ptIdentifiedInOneFile;

// 使用日志
procedure TServerMain.HandleLogin;
begin
  TSynLog.Add.Log(sllInfo, 'Player login: %', [sPlayerName], Self);
end;
```

### 5.3 异步网络

```pascal
uses
  mormot.net.async;

// TCP 服务端
var
  Server: TAsyncServer;
begin
  Server := TAsyncServer.Create(
    '0.0.0.0', '7000', 
    nil,     // OnAccept
    nil,     // Protocol
    nil,     // Log
    TAsyncServerSettings.Create);
  try
    Server.WaitStarted;
    // ...
  finally
    Server.Free;
  end;
end;
```

### 5.4 加密 (AES + ECDH)

```pascal
uses
  mormot.crypt.core,
  mormot.crypt.ecc;

// ECDH 密钥交换
var
  LocalKey: TEccCertificate;
  SharedSecret: THash256;
begin
  LocalKey := TEccCertificate.CreateNew(nil);
  SharedSecret := LocalKey.SharedSecret(RemotePublicKey);
end;

// AES-256-GCM 加密
var
  Cipher: TAesGcmEngine;
begin
  Cipher.Init(SessionKey, 256);
  Cipher.Encrypt(Data, EncryptedData, Length(Data), Nonce, Tag);
end;
```

### 5.5 ORM (DBServer)

```pascal
uses
  mormot.orm.core,
  mormot.orm.sqlite3;

type
  TDBCharacter = class(TOrm)
  private
    FCharID: Cardinal;
    FName: RawUtf8;
    FLevel: Byte;
  published
    property CharID: Cardinal read FCharID write FCharID;
    property Name: RawUtf8 read FName write FName;
    property Level: Byte read FLevel write FLevel;
  end;

// 使用 ORM
var
  Rest: TRestServerDB;
  Char: TDBCharacter;
begin
  Char := TDBCharacter.Create;
  try
    Char.Name := 'TestPlayer';
    Char.Level := 1;
    Rest.Add(Char, True);
  finally
    Char.Free;
  end;
end;
```

### 5.6 线程安全集合

```pascal
uses
  mormot.core.json; // TSynDictionary is here

// 初始化
OnlinePlayers := TSynDictionary.Create(
  TypeInfo(TCardinalDynArray),   // Key: ConnID
  TypeInfo(TPlayerObjectDynArray) // Value: Player
);

// 添加
OnlinePlayers.Add(ConnID, Player);

// 查找
if OnlinePlayers.FindAndCopy(ConnID, Player) then
  Player.HandlePacket(Packet);

// 删除
OnlinePlayers.Delete(ConnID);
```

### 5.7 JSON 处理

```pascal
uses
  mormot.core.json;

// 使用 TDocVariant
var
  Doc: TDocVariantData;
begin
  Doc.InitObject(['name', 'test', 'value', 123]);
  sJson := Doc.ToJson;
end;

// 解析 JSON
Doc.InitJson(sJson);
sName := Doc.U['name'];
nValue := Doc.I['value'];
```

---

## 6. 错误处理

### 6.1 异常使用场景

| 场景 | 处理方式 |
|------|----------|
| 初始化失败 | 抛异常 |
| 配置错误 | 抛异常 |
| 网络断开 | 返回错误码 + 日志 |
| 协议错误 | 返回错误码 + 日志 |
| 业务逻辑错误 | 返回错误码 |

### 6.2 异常处理模板

```pascal
try
  DoRiskyOperation;
except
  on E: ENetworkError do
    LogError('网络错误: %s', [E.Message]);
  on E: Exception do
    LogError('未知错误: %s', [E.Message]);
end;
```

---

## 7. 日志规范

### 7.1 日志级别

| 级别 | 用途 |
|------|------|
| `Debug` | 调试信息，生产环境关闭 |
| `Info` | 正常运行信息 |
| `Warn` | 警告，不影响运行 |
| `Error` | 错误，需要关注 |
| `Fatal` | 致命错误，程序终止 |

### 7.2 日志格式

```pascal
// 使用统一的日志接口
Log.Debug('接收数据包: MsgType=%d, Size=%d', [nMsgType, nSize]);
Log.Info('玩家登录: %s', [sPlayerName]);
Log.Error('发送失败: ConnID=%d, Error=%s', [nConnID, sError]);
```

---

## 8. 代码模板

### 8.1 单例模式

```pascal
type
  TGameConfig = class
  private
    class var FInstance: TGameConfig;
    constructor CreatePrivate;
  public
    class function Instance: TGameConfig;
    class procedure ReleaseInstance;
  end;

class function TGameConfig.Instance: TGameConfig;
begin
  if FInstance = nil then
    FInstance := TGameConfig.CreatePrivate;
  Result := FInstance;
end;
```

### 8.2 线程安全计数器

```pascal
var
  FCounter: Integer;

procedure IncCounter;
begin
  InterlockedIncrement(FCounter);
end;
```

---

## 9. mORMot2 使用注意事项

> **重要**：本章节记录在实际开发中发现的 mORMot2 API 使用陷阱

### 9.1 TAsyncServer 事件处理

❌ **错误用法**：直接给 TAsyncServer 赋值事件处理器
```pascal
// 错误！TAsyncServer 没有这些事件属性
FServer := TAsyncServer.Create(...);
FServer.OnClientConnect := HandleConnect;  // 不存在
FServer.OnClientRead := HandleRead;        // 不存在
```

✅ **正确用法**：继承 TAsyncConnection 并覆盖方法
```pascal
type
  TMyConnection = class(TAsyncConnection)
  protected
    // 必须覆盖：OnRead 是 abstract 方法
    function OnRead: TPollAsyncSocketOnReadWrite; override;
    // 可选覆盖：OnClose 只是 virtual 方法，有默认空实现
    procedure OnClose; override;
  end;

// 创建服务器时传入自定义连接类
FServer := TAsyncServer.Create('0.0.0.0', sPort, nil, nil, TMyConnection, '', nil, [], 4);
```

> **注意**：`OnRead` 在 `TPollAsyncConnection` 中声明为 `virtual; abstract`，子类**必须**覆盖实现。`OnClose` 是 `virtual`（非 abstract），可以选择性覆盖。

### 9.2 TSqlRequest 用法

❌ **错误用法**：
```pascal
// 错误！TSqlDatabase 没有 Prepare 方法
FDatabase.Prepare(Stmt, SQL);

// 错误！FieldUtf8 是 procedure 不是 function
sValue := Stmt.FieldUtf8(0);
```

✅ **正确用法**：
```pascal
// TSqlRequest.Prepare 需要传入 TSqlite3DB 句柄
if Stmt.Prepare(FDatabase.DB, SQL) = SQLITE_OK then
try
  if Stmt.Step = SQLITE_ROW then
  begin
    nValue := Stmt.FieldInt(0);
    Stmt.FieldUtf8(1, sValue);  // procedure，需要传入变量
  end;
finally
  Stmt.Close;
end;
```

### 9.3 ECC 密钥生成

❌ **错误用法**：
```pascal
// 错误！函数名和参数类型不对
Ecc256r1CreateKeys(PrivKey, PubKey);
```

✅ **正确用法**：
```pascal
uses
  mormot.crypt.ecc256r1;

var
  PrivKey: TEccPrivateKey;
  PubKey: TEccPublicKey;  // 33 字节压缩格式公钥
begin
  Ecc256r1MakeKey(PubKey, PrivKey);
end;
```

### 9.4 Sha256 函数

❌ **错误用法**：
```pascal
// 错误！参数类型不对
sHash := Sha256(aPassword);  // aPassword 是 RawUtf8
```

✅ **正确用法**：
```pascal
uses
  mormot.crypt.core;

// Sha256 需要 RawByteString 类型
sHash := Sha256(RawByteString(aPassword));
```

### 9.5 TRestServerDB 创建

```pascal
uses
  mormot.rest.sqlite3;  // 必须引用此单元

// 内存数据库
FRestServer := TRestServerDB.Create(FModel, SQLITE_MEMORY_DATABASE_NAME);

// 文件数据库
FRestServer := TRestServerDB.Create(FModel, 'database.db');

// 创建表
FRestServer.Server.CreateMissingTables;
```

### 9.6 SQLite Backup API（内存数据库持久化）

```pascal
uses
  mormot.db.raw.sqlite3;

// 从内存数据库备份到文件
Backup := sqlite3.backup_init(TempDB.DB, 'main', FRestServer.DB.DB, 'main');
if Backup <> 0 then
begin
  sqlite3.backup_step(Backup, -1);  // -1 = 一次性复制全部
  sqlite3.backup_finish(Backup);
end;
```

### 9.7 StringFromFile / FileFromString

```pascal
// 注意：这些函数使用 RawByteString，不是 TBytes
var
  FileData: RawByteString;
begin
  FileData := StringFromFile(StringToUtf8(aFilePath));
  FileFromString(EncryptedData, StringToUtf8(aFilePath));
end;
```

### 9.8 InterlockedIncrement 类型匹配

❌ **错误用法**：
```pascal
var
  FCounter: Cardinal;
begin
  // 错误！InterlockedIncrement 需要 Integer 类型
  InterlockedIncrement(FCounter);
```

✅ **正确用法**：
```pascal
var
  FCounter: Integer;
begin
  InterlockedIncrement(FCounter);
  // 或者使用 AtomicIncrement
  AtomicIncrement(FCounter);
end;
```

---

## 10. 单元引用速查

| 功能 | 需要引用的单元 |
|------|----------------|
| RawUtf8, FormatUtf8 | `mormot.core.text` |
| StringToUtf8, Utf8ToString | `mormot.core.unicode` |
| TAsyncServer, TAsyncConnection | `mormot.net.async` |
| TSqlDatabase, TSqlRequest | `mormot.db.raw.sqlite3` |
| TRestServerDB | `mormot.rest.sqlite3` |
| TOrmModel, TOrm | `mormot.orm.core` |
| TAesGcmEngine, Sha256, TAesPrng | `mormot.crypt.core` |
| Ecc256r1MakeKey, TEccPublicKey | `mormot.crypt.ecc256r1` |
| TSynDictionary | `mormot.core.json` |
| GetSystemPath | `mormot.core.os` |

