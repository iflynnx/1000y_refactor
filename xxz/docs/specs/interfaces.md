# 模块接口规范

> **适用范围**：仙侠传 (XXZ) 项目所有公共模块和服务接口

---

## 1. 公共模块 (Common)

### 1.1 uNetProtocol - 网络协议

```pascal
unit uNetProtocol;

interface

type
  /// <summary>数据包回调函数</summary>
  TPacketCallback = procedure(aConnID: Cardinal; const aPacket: TPacketData) of object;

  /// <summary>数据包发送器接口</summary>
  IPacketSender = interface
    /// <summary>发送数据包</summary>
    function SendPacket(aConnID: Cardinal; aMsgType: Word; 
      const aData: TBytes): Boolean;
    /// <summary>广播数据包</summary>
    procedure Broadcast(aMsgType: Word; const aData: TBytes);
  end;

  /// <summary>数据包接收器接口</summary>
  IPacketReceiver = interface
    /// <summary>注册消息处理器</summary>
    procedure RegisterHandler(aMsgType: Word; aHandler: TPacketCallback);
    /// <summary>注销消息处理器</summary>
    procedure UnregisterHandler(aMsgType: Word);
  end;

  /// <summary>数据包编码器</summary>
  TPacketEncoder = class
    /// <summary>编码数据包</summary>
    class function Encode(aMsgType: Word; aSequence: Word; 
      const aData: TBytes): TBytes;
    /// <summary>解码数据包</summary>
    class function Decode(const aRawData: TBytes; 
      out aPacket: TPacketData): Boolean;
  end;
```

---

### 1.2 uGameTypes - 游戏类型

```pascal
unit uGameTypes;

interface

type
  TPlayerID = Cardinal;
  TItemID = Cardinal;
  TSkillID = Word;
  TMapID = Word;
  TBuffID = Word;

  /// <summary>坐标</summary>
  TPosition = packed record
    X: Word;
    Y: Word;
  end;

  /// <summary>玩家基础信息</summary>
  TPlayerInfo = packed record
    ID: TPlayerID;
    Name: array[0..19] of AnsiChar;
    Level: Byte;
    Job: Byte;
    Position: TPosition;
    MapID: TMapID;
  end;

  /// <summary>物品信息</summary>
  TItemInfo = packed record
    ID: TItemID;
    TemplateID: Word;
    Count: Word;
    Position: Byte;  // 背包位置
    Durability: Word;
    EnhanceLevel: Byte;
    StarLevel: Byte;
  end;

  /// <summary>BUFF 信息</summary>
  TBuffInfo = packed record
    ID: TBuffID;
    TemplateID: Word;
    Duration: Cardinal;  // 剩余时间 (毫秒)
    StackCount: Byte;
  end;
```

---

### 1.3 uCrypto - 加密模块

```pascal
unit uCrypto;

interface

type
  /// <summary>ECDH 密钥对</summary>
  TECDHKeyPair = record
    PublicKey: array[0..64] of Byte;   // 未压缩格式 (04 + X + Y)
    PrivateKey: array[0..31] of Byte;  // 32 字节私钥
  end;

  /// <summary>安全会话状态</summary>
  TSessionState = (ssDisconnected, ssHandshaking, ssEstablished);

  /// <summary>安全会话接口</summary>
  ISecureSession = interface
    /// <summary>获取会话状态</summary>
    function GetState: TSessionState;
    /// <summary>生成本地密钥对</summary>
    procedure GenerateKeyPair;
    /// <summary>获取本地公钥</summary>
    function GetPublicKey: TBytes;
    /// <summary>使用对方公钥完成密钥交换</summary>
    procedure CompleteHandshake(const aRemotePubKey: TBytes; const aSalt: TBytes);
    /// <summary>加密数据</summary>
    function Encrypt(const aData: TBytes): TBytes;
    /// <summary>解密并验证数据</summary>
    function Decrypt(const aData: TBytes; out aResult: TBytes): Boolean;
    /// <summary>重置会话</summary>
    procedure Reset;
  end;

  /// <summary>安全会话实现</summary>
  TSecureSession = class(TInterfacedObject, ISecureSession)
  private
    FState: TSessionState;
    FKeyPair: TECDHKeyPair;
    FSessionKey: array[0..31] of Byte;  // AES-256 密钥
    FSendSequence: Cardinal;
    FRecvSequence: Cardinal;
    FRecvWindow: array[0..127] of Boolean;  // 防重放窗口
  public
    constructor Create;
    function GetState: TSessionState;
    procedure GenerateKeyPair;
    function GetPublicKey: TBytes;
    procedure CompleteHandshake(const aRemotePubKey: TBytes; const aSalt: TBytes);
    function Encrypt(const aData: TBytes): TBytes;
    function Decrypt(const aData: TBytes; out aResult: TBytes): Boolean;
    procedure Reset;
  end;

/// <summary>创建新的安全会话</summary>
function CreateSecureSession: ISecureSession;
```

---

### 1.5 加密数据库 (uEncryptedDB)

```pascal
unit uEncryptedDB;

interface

type
  /// <summary>加密数据库文件格式版本</summary>
  XXZDB_VERSION = $0001;

  /// <summary>加密数据库文件头</summary>
  TXXZDBHeader = packed record
    Magic: Cardinal;      // 'XXZ\x00' (0x58585A00)
    Version: Word;        // 版本号
    Reserved: Word;       // 保留
    OriginalSize: Cardinal;  // 原始数据大小
    Checksum: Cardinal;   // CRC32 校验
  end;

  /// <summary>加密数据库管理器接口</summary>
  IEncryptedDB = interface
    /// <summary>加载加密数据库</summary>
    function Load(const aFilePath: string; const aKey: TBytes): Boolean;
    /// <summary>保存加密数据库</summary>
    function Save(const aFilePath: string; const aKey: TBytes): Boolean;
    /// <summary>获取内部 ORM 服务</summary>
    function GetRestServer: TRestServerDB;
  end;

  /// <summary>加密数据库管理器</summary>
  TEncryptedDB = class(TInterfacedObject, IEncryptedDB)
  private
    FRestServer: TRestServerDB;
    FModel: TOrmModel;
  public
    constructor Create(const aModelClasses: array of TOrmClass);
    destructor Destroy; override;
    function Load(const aFilePath: string; const aKey: TBytes): Boolean;
    function Save(const aFilePath: string; const aKey: TBytes): Boolean;
    function GetRestServer: TRestServerDB;
  end;
```

---

### 1.4 日志模块 (使用 mORMot2)

> 直接使用 mORMot2 的 `TSynLog`，不再封装 ILogger

```pascal
uses
  mormot.core.log;

// 初始化日志（在服务启动时调用一次）
procedure InitLogger(const aLogPath: string; aVerbose: Boolean);
begin
  TSynLog.Family.Level := LOG_VERBOSE;
  TSynLog.Family.DestinationPath := aLogPath;
  TSynLog.Family.PerThreadLog := ptIdentifiedInOneFile;
  TSynLog.Family.AutoFlushTimeOut := 1;  // 1秒自动刷新
end;

// 使用日志
TSynLog.Add.Log(sllDebug, 'Debug message: %', [sValue], Self);
TSynLog.Add.Log(sllInfo, 'Player % logged in', [sPlayerName], Self);
TSynLog.Add.Log(sllWarning, 'Connection timeout: ConnID=%', [nConnID], Self);
TSynLog.Add.Log(sllError, 'Failed to save character: %', [sErrorMsg], Self);
```

---

## 2. 服务接口

### 2.1 GateServer

```pascal
unit uGateServer;

interface

type
  /// <summary>Gate 服务接口</summary>
  IGateServer = interface
    /// <summary>启动服务</summary>
    procedure Start;
    /// <summary>停止服务</summary>
    procedure Stop;
    /// <summary>发送消息给客户端</summary>
    procedure SendToClient(aConnID: Cardinal; aMsgType: Word; 
      const aData: TBytes);
    /// <summary>断开客户端连接</summary>
    procedure DisconnectClient(aConnID: Cardinal);
    /// <summary>获取在线客户端数量</summary>
    function GetOnlineCount: Integer;
  end;

  /// <summary>Gate 事件回调</summary>
  TGateEventCallback = class
    /// <summary>客户端连接</summary>
    procedure OnClientConnect(aConnID: Cardinal); virtual; abstract;
    /// <summary>客户端断开</summary>
    procedure OnClientDisconnect(aConnID: Cardinal); virtual; abstract;
    /// <summary>收到客户端消息</summary>
    procedure OnClientMessage(aConnID: Cardinal; 
      const aPacket: TPacketData); virtual; abstract;
  end;
```

---

### 2.2 LoginServer

```pascal
unit uLoginServer;

interface

type
  TLoginResult = (lrSuccess, lrAccountNotExist, lrPasswordError, 
    lrAlreadyOnline, lrBanned);

  /// <summary>Login 服务接口</summary>
  ILoginService = interface
    /// <summary>登录验证</summary>
    function Login(const aAccount, aPassword: string; 
      out aUserID: Cardinal): TLoginResult;
    /// <summary>注册账号</summary>
    function Register(const aAccount, aPassword: string): Boolean;
    /// <summary>获取角色列表</summary>
    function GetCharacterList(aUserID: Cardinal): TArray<TCharacterBrief>;
  end;

  /// <summary>角色简要信息</summary>
  TCharacterBrief = record
    CharID: Cardinal;
    Name: string;
    Level: Byte;
    Job: Byte;
  end;
```

---

### 2.3 DBServer

```pascal
unit uDBServer;

interface

type
  /// <summary>DB 服务接口</summary>
  IDBService = interface
    /// <summary>加载角色数据</summary>
    function LoadCharacter(aCharID: Cardinal): TCharacterData;
    /// <summary>保存角色数据</summary>
    procedure SaveCharacter(const aData: TCharacterData);
    /// <summary>创建角色</summary>
    function CreateCharacter(aUserID: Cardinal; 
      const aName: string; aJob: Byte): Cardinal;
    /// <summary>删除角色</summary>
    function DeleteCharacter(aCharID: Cardinal): Boolean;
  end;

  /// <summary>角色完整数据</summary>
  TCharacterData = record
    Basic: TPlayerInfo;
    Attributes: TPlayerAttributes;
    Items: TArray<TItemInfo>;
    Skills: TArray<TSkillInfo>;
    Buffs: TArray<TBuffInfo>;
  end;
```

---

### 2.4 GameServer

```pascal
unit uGameServer;

interface

type
  /// <summary>Game 服务接口</summary>
  IGameService = interface
    /// <summary>玩家进入世界</summary>
    procedure PlayerEnterWorld(aConnID: Cardinal; aCharID: Cardinal);
    /// <summary>玩家离开世界</summary>
    procedure PlayerLeaveWorld(aCharID: Cardinal);
    /// <summary>处理玩家消息</summary>
    procedure HandlePlayerMessage(aCharID: Cardinal; 
      const aPacket: TPacketData);
  end;

  /// <summary>游戏世界事件</summary>
  IGameWorldEvents = interface
    /// <summary>玩家进入区域</summary>
    procedure OnPlayerEnterArea(aPlayer: TPlayerObject; aAreaID: Integer);
    /// <summary>玩家离开区域</summary>
    procedure OnPlayerLeaveArea(aPlayer: TPlayerObject; aAreaID: Integer);
    /// <summary>玩家死亡</summary>
    procedure OnPlayerDeath(aPlayer: TPlayerObject; aKiller: TGameObject);
  end;
```

---

### 2.5 BalanceServer

```pascal
unit uBalanceServer;

interface

type
  /// <summary>Balance 服务接口</summary>
  IBalanceService = interface
    /// <summary>获取最佳 Gate 地址</summary>
    function GetBestGate: TGateInfo;
    /// <summary>注册 Gate 服务</summary>
    procedure RegisterGate(const aInfo: TGateInfo);
    /// <summary>更新 Gate 负载</summary>
    procedure UpdateGateLoad(aGateID: Integer; aLoad: Integer);
  end;

  /// <summary>Gate 信息</summary>
  TGateInfo = record
    GateID: Integer;
    IP: string;
    Port: Word;
    CurrentLoad: Integer;
    MaxLoad: Integer;
  end;
```

---

## 3. 事件系统

### 3.1 事件类型定义

```pascal
unit uGameEvents;

interface

type
  TEventType = (
    evPlayerLogin,
    evPlayerLogout,
    evPlayerLevelUp,
    evPlayerDeath,
    evItemPickup,
    evItemUse,
    evSkillCast,
    evBuffAdd,
    evBuffRemove,
    evQuestAccept,
    evQuestComplete
  );

  /// <summary>事件基类</summary>
  TGameEvent = class
    EventType: TEventType;
    Timestamp: TDateTime;
  end;

  /// <summary>事件处理器</summary>
  TEventHandler = procedure(const aEvent: TGameEvent) of object;

  /// <summary>事件管理器接口</summary>
  IEventManager = interface
    procedure Subscribe(aEventType: TEventType; aHandler: TEventHandler);
    procedure Unsubscribe(aEventType: TEventType; aHandler: TEventHandler);
    procedure Publish(const aEvent: TGameEvent);
  end;
```

---

## 4. 接口版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0 | 2025-12-08 | 初始版本 |
