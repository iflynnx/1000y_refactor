# 仙侠传 (XXZ) Golden Code Patterns

> **说明**: 本文件包含 "Golden Snippets"（金标准代码片段）——即经过验证的、可直接复制使用的 mORMot2 代码模式。
> **规则**: 在开发新功能时，优先复制并修改这些模式，而不是从零开始编写。

---

## 1. 异步网络服务 (Gate/Login/Game 使用)

**模式**: 使用 `mormot.net.async` 构建高性能 TCP 服务端。
**场景**: GateServer, LoginServer, GameServer 的网络接入层。

```pascal
unit uServicePattern;

interface

uses
  System.SysUtils, System.Classes,
  mormot.core.base, mormot.core.log, mormot.net.async, mormot.core.json, // mormot.core.json required for TSynDictionary
  uNetProtocol; // 项目的协议定义单元

type
  { 连接上下文 (每个连接一个实例) }
  TServiceConnection = class(TAsyncConnection)
  protected
    // 业务逻辑处理入口
    procedure ProcessPacket(const aPacket: RawByteString);
  public
    // 覆盖 mORMot2 的钩子函数
    function OnRead: TPollAsyncSocketOnReadWrite; override;
    procedure OnClose; override;
  end;

  { 服务端管理器 }
  TServiceServer = class
  private
    FServer: TAsyncServer;
  public
    constructor Create(const aPort: string);
    destructor Destroy; override;
  end;

implementation

{ TServiceConnection }

function TServiceConnection.OnRead: TPollAsyncSocketOnReadWrite;
var
  // 在真实场景中，这里需要缓冲区处理粘包/分包
  // mORMot2 的 OnRead 默认已经帮我们读取了数据到内部缓冲
  // 这里演示简单的处理逻辑
  res: TPollAsyncSocketOnReadWrite;
begin
  Result := sowRead; // 告诉框架继续读取
  
  // 假设我们通过某种方式获取了完整的包 (示例逻辑)
  // 在实际项目中，应结合 uNetProtocol 的 TryGetPacket
  // ProcessPacket(FullPacket);
end;

procedure TServiceConnection.ProcessPacket(const aPacket: RawByteString);
begin
  // 异常捕获网，防止单个包处理崩溃导致服务异常
  try
    // 分发逻辑...
  except
    on E: Exception do
      TSynLog.Add.Log(sllError, 'ProcessPacket Error: %', [E.Message], Self);
  end;
end;

procedure TServiceConnection.OnClose;
begin
  inherited; // 必须调用
  // 清理用户会话、从在线列表移除等
  TSynLog.Add.Log(sllInfo, 'Connection % closed', [RemoteIP]);
end;

{ TServiceServer }

constructor TServiceServer.Create(const aPort: string);
begin
  FServer := TAsyncServer.Create(
    '0.0.0.0',    // 监听所有 IP
    aPort,        // 端口
    nil,          // OnAccept (一般不用)
    nil,          // OnProcess (一般不用)
    TServiceConnection, // 指定连接类
    'ServiceServer',    // 进程名称
    nil,
    [asbOnRestricted],  // 高性能模式 (禁用 HTTP/WebSockets)
    4 // 线程池大小 (根据 CPU 核心数调整)
  );
  TSynLog.Add.Log(sllInfo, 'Service started on port %', [aPort]);
end;

destructor TServiceServer.Destroy;
begin
  FServer.Free;
  inherited;
end;

end.
```

## 2. 健壮的数据库对象应用 (ORM)

**模式**: 在 SQLite/mORMot2 中定义数据实体。
**场景**: DBServer 数据持久化。

```pascal
unit uDataModelPattern;

interface

uses
  mormot.core.base, mormot.orm.core;

type
  { 
    规范:
    1. 继承自 TOrm
    2. Published 属性会自动映射为数据库字段
    3. 字符串必须使用 RawUtf8
    4. 使用 [ORMIndex] 定义索引
  }
  
  [ORMIndex('Name', True)] // 在 Name 字段建立唯一索引
  TGameUser = class(TOrm)
  private
    FAccount: RawUtf8;
    FPasswordHash: RawUtf8;
    FLastLogin: TTimeLog; // mORMot 专用时间格式 (Int64)
    FStatus: Integer;
  published
    property Account: RawUtf8 index 20 read FAccount write FAccount;
    property PasswordHash: RawUtf8 index 30 read FPasswordHash write FPasswordHash;
    property LastLogin: TTimeLog index 40 read FLastLogin write FLastLogin;
    property Status: Integer index 50 read FStatus write FStatus;
  end;

implementation

initialization
  // 必须注册模型
  TOrmModel.Register([TGameUser]);

end.
```

## 3. 线程安全的字典 (高性能缓存)

**模式**: 使用 `TSynDictionary` 存储在线玩家。
**场景**: GateServer (路由表), GameServer (对象列表)。

```pascal
// 定义
var
  GOnlineMap: TSynDictionary; // Key: Integer (ConnID), Value: TObject

// 初始化
initialization
  GOnlineMap := TSynDictionary.Create(TypeInfo(Integer), TypeInfo(TObject));

// 增/改 (线程安全)
procedure AddInternal(AConnID: Integer; AObj: TObject);
begin
  GOnlineMap.Add(AConnID, AObj); 
end;

// 查 (高效，无全局锁)
function GetPlayer(AConnID: Integer): TObject;
begin
  if not GOnlineMap.FindAndCopy(AConnID, Result) then
    Result := nil;
end;

// 删
procedure RemovePlayer(AConnID: Integer);
begin
  GOnlineMap.Delete(AConnID);
end;
```

## 4. 标准日志模式

**模式**: 使用 `mormot.core.log` 的 TSynLog。

```pascal
procedure TLogic.ProcessLogin(const AUser: RawUtf8);
var
  I: ISynLog; // 接口类型，作用域结束自动记录 "Leave"
begin
  I := TSynLog.Enter; // 记录 "Enter ProcessLogin"
  try
    I.Log(sllInfo, 'Processing login for user %', [AUser]);
    
    if not IsValid(AUser) then
    begin
      I.Log(sllWarning, 'Invalid user %', [AUser]);
      Exit;
    end;
    
    // ... 业务逻辑 ...
    
  except
    on E: Exception do
      I.Log(sllError, 'Login Exception: %', [E.Message]); // 自动包含堆栈追踪
  end;
  // 方法结束时自动记录 "Leave ProcessLogin (耗时)"
end;
```

## 5. 安全的字符串处理

**模式**: 拒绝 `String` (UnicodeString)，在服务端核心逻辑全面使用 `RawUtf8`。

```pascal
var
  sName: RawUtf8;
  sMsg: RawUtf8;
begin
  // 1. 格式化 (比 Format 快，且不依赖 OS Locale)
  sMsg := FormatUtf8('Hello %, welcome back!', [sName]);
  
  // 2. 比较 (不区分大小写)
  if IdemPropName(sName, 'ADMIN') then 
    DoAdminStuff;
    
  // 3. 拼接
  sMsg := sMsg + ' suffix'; 
end;
```

## 🚫 负面约束 (禁止事项)

> **Agent 注意**: 遇到以下代码模式请立即修正。

*   ❌ **禁止使用 Indy (IdTCPClient/Server)**: 它是阻塞式的，并发性能差。必须使用 `mormot.net.async`。
*   ❌ **禁止使用 `TThread.Create`**: 不要手动管理线程生命周期。使用 `mormot.core.threads` 或依赖 mORMot 的线程池回调。
*   ❌ **禁止在核心数据结构使用 `String`**: 必须使用 `RawUtf8` (UTF-8)，避免 Windows/Linux 编码转换开销。
*   ❌ **禁止使用 `TStringList` 做查找**: 性能极差且非线程安全。必须使用 `TSynDictionary`。
*   ❌ **禁止 `Sleep()`**: 在异步服务中绝对禁止阻塞线程。
