# 数据模型规范

> **适用范围**：仙侠传 (XXZ) 项目所有数据结构定义

---

## 1. 数据库结构

### 1.1 LoginServer - SQLite

#### accounts 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PRIMARY KEY | 用户 ID |
| account | TEXT UNIQUE | 账号名 |
| password_hash | TEXT | 密码哈希 (MD5) |
| email | TEXT | 邮箱 |
| status | INTEGER | 状态 (0=正常, 1=封禁) |
| created_at | DATETIME | 创建时间 |
| last_login | DATETIME | 最后登录时间 |

```sql
CREATE TABLE accounts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  email TEXT,
  status INTEGER DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_login DATETIME
);
```

#### characters 表

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER PRIMARY KEY | 角色 ID |
| user_id | INTEGER | 所属用户 ID |
| name | TEXT UNIQUE | 角色名 |
| level | INTEGER | 等级 |
| job | INTEGER | 职业 |
| created_at | DATETIME | 创建时间 |
| deleted | INTEGER | 是否删除 |

```sql
CREATE TABLE characters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  name TEXT UNIQUE NOT NULL,
  level INTEGER DEFAULT 1,
  job INTEGER NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  deleted INTEGER DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES accounts(id)
);
```

---

### 1.2 DBServer - mORMot2 ORM

> 使用 mORMot2 的 `TOrm` 作为基类，运行时使用内存 SQLite，持久化使用整库加密

#### 加密存储格式 (.xxzdb)

```
文件格式:
+------------------+-------------------+----------------------+
| 文件头 (16字节)   | IV (12字节)       | 加密数据 (AES-GCM)   |
+------------------+-------------------+----------------------+
```

| 偏移 | 长度 | 字段 | 值/说明 |
|------|------|------|---------|
| 0 | 4 | Magic | `'XXZ\x00'` (0x58585A00) |
| 4 | 2 | Version | 0x0001 |
| 6 | 2 | Reserved | 0x0000 |
| 8 | 4 | OriginalSize | 原始数据大小 |
| 12 | 4 | Checksum | CRC32 校验 |
| 16 | 12 | IV | AES-GCM 初始化向量 |
| 28 | N | EncryptedData | AES-256-GCM 加密的 SQLite 数据 |
| 28+N | 16 | AuthTag | GCM 认证标签 |

> [!IMPORTANT]
> 加密后的文件无法被任何 SQLite 工具识别或打开。

#### TDBCharacter

```pascal
uses
  mormot.orm.core;

type
  TDBCharacter = class(TOrm)
  private
    FCharID: Cardinal;
    FUserID: Cardinal;
    FName: RawUtf8;
    FLevel: Byte;
    FJob: Byte;
    FExp: Cardinal;
    FMapID: Word;
    FPosX: Word;
    FPosY: Word;
    FHP: Integer;
    FMP: Integer;
    FGold: Cardinal;
    FAttributes: RawUtf8;   // JSON 序列化
    FItems: RawUtf8;        // JSON 序列化
    FSkills: RawUtf8;       // JSON 序列化
    FBuffs: RawUtf8;        // JSON 序列化
  published
    property CharID: Cardinal read FCharID write FCharID;
    property UserID: Cardinal read FUserID write FUserID;
    property Name: RawUtf8 read FName write FName;
    property Level: Byte read FLevel write FLevel;
    property Job: Byte read FJob write FJob;
    property Exp: Cardinal read FExp write FExp;
    property MapID: Word read FMapID write FMapID;
    property PosX: Word read FPosX write FPosX;
    property PosY: Word read FPosY write FPosY;
    property HP: Integer read FHP write FHP;
    property MP: Integer read FMP write FMP;
    property Gold: Cardinal read FGold write FGold;
    property Attributes: RawUtf8 read FAttributes write FAttributes;
    property Items: RawUtf8 read FItems write FItems;
    property Skills: RawUtf8 read FSkills write FSkills;
    property Buffs: RawUtf8 read FBuffs write FBuffs;
  end;
```

---

## 2. 游戏对象类层次

```
TGameObject (基类)
├── TPlayerObject (玩家)
│   ├── AttributeManager
│   ├── ItemManager
│   ├── SkillManager
│   └── BuffManager
├── TMonsterObject (怪物)
├── TNPCObject (NPC)
└── TDropItemObject (掉落物)
```

### 2.1 TGameObject

```pascal
TGameObject = class
private
  FObjectID: Cardinal;
  FObjectType: TObjectType;
  FPosition: TPosition;
  FMapID: TMapID;
public
  property ObjectID: Cardinal read FObjectID;
  property ObjectType: TObjectType read FObjectType;
  property Position: TPosition read FPosition write FPosition;
  property MapID: TMapID read FMapID write FMapID;
  
  procedure Update(aTick: Cardinal); virtual; abstract;
end;

TObjectType = (otPlayer, otMonster, otNPC, otDropItem);
```

### 2.2 TPlayerObject

```pascal
TPlayerObject = class(TGameObject)
private
  FConnID: Cardinal;
  FCharID: Cardinal;
  FName: string;
  FLevel: Byte;
  FJob: Byte;
  FAttributes: TAttributeManager;
  FItems: TItemManager;
  FSkills: TSkillManager;
  FBuffs: TBuffManager;
public
  property ConnID: Cardinal read FConnID;
  property CharID: Cardinal read FCharID;
  property Name: string read FName;
  property Level: Byte read FLevel;
  property Attributes: TAttributeManager read FAttributes;
  property Items: TItemManager read FItems;
  property Skills: TSkillManager read FSkills;
  property Buffs: TBuffManager read FBuffs;
end;
```

---

## 3. 属性系统

### 3.1 基础属性

| 属性 | 字段 | 说明 |
|------|------|------|
| 元气 | Energy | 基础属性 |
| 内功 | InPower | 基础属性 |
| 外功 | OutPower | 基础属性 |
| 武功 | Magic | 基础属性 |
| 活力 | Life | 基础属性 |
| 才智 | Talent | 派生属性 |
| 神圣 | GoodChar | 派生属性 |
| 魔性 | BadChar | 派生属性 |

### 3.2 TPlayerAttributes

```pascal
TPlayerAttributes = packed record
  // 基础属性
  Energy: Integer;     // 元气
  InPower: Integer;    // 内功
  OutPower: Integer;   // 外功
  Magic: Integer;      // 武功
  Life: Integer;       // 活力
  
  // 派生属性
  Talent: Integer;     // 才智
  GoodChar: Integer;   // 神圣
  BadChar: Integer;    // 魔性
  Adaptive: Integer;   // 内性
  Revival: Integer;    // 再生
  Immunity: Integer;   // 免疫
  Virtue: Integer;     // 德行
  
  // 当前值
  CurHP: Integer;
  CurMP: Integer;
  CurSatiety: Integer; // 饱食度
end;
```

---

## 4. SDB 文件格式

### 4.1 物品表 (Item.sdb)

| 列 | 类型 | 说明 |
|----|------|------|
| ID | Integer | 物品模板 ID |
| Name | String | 物品名称 |
| Type | Integer | 物品类型 |
| SubType | Integer | 子类型 |
| Level | Integer | 需求等级 |
| Price | Integer | 价格 |
| MaxStack | Integer | 最大堆叠 |
| Description | String | 描述 |

### 4.2 技能表 (Skill.sdb)

| 列 | 类型 | 说明 |
|----|------|------|
| ID | Integer | 技能 ID |
| Name | String | 技能名称 |
| Type | Integer | 技能类型 |
| CostMP | Integer | 消耗 MP |
| Cooldown | Integer | 冷却时间 (毫秒) |
| Range | Integer | 施法距离 |
| Effect | String | 效果脚本 |

### 4.3 怪物表 (Monster.sdb)

| 列 | 类型 | 说明 |
|----|------|------|
| ID | Integer | 怪物 ID |
| Name | String | 怪物名称 |
| Level | Integer | 等级 |
| HP | Integer | 生命值 |
| Attack | Integer | 攻击力 |
| Defense | Integer | 防御力 |
| Exp | Integer | 经验值 |
| Drops | String | 掉落列表 (JSON) |

### 4.4 BUFF 表 (Buff.sdb)

| 列 | 类型 | 说明 |
|----|------|------|
| ID | Integer | BUFF ID |
| Name | String | BUFF 名称 |
| Type | Integer | 类型 (0=增益, 1=减益) |
| Duration | Integer | 持续时间 (毫秒) |
| MaxStack | Integer | 最大层数 |
| Effect | String | 效果描述 |

---

## 5. 版本历史

| 版本 | 日期 | 变更 |
|------|------|------|
| 1.0 | 2025-12-08 | 初始版本 |
