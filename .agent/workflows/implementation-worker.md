---
description: 实现类任务工作流（具体功能模块开发、增量实现各系统）
---

# 实现类任务工作流

## 🎯 适用场景

- 增量实现各个系统（阶段 5）
- 具体功能模块开发
- 核心框架搭建
- 游戏系统实现（战斗、物品、任务等）

## 🔑 触发关键词

`实现`、`开发`、`编码`、`重写`、`创建`、`构建`

## 📋 执行步骤

### 1. 确认实施前提
**必须满足**：
- ✅ 架构设计已批准（阶段 4 完成）
- ✅ 相关业务逻辑已提取（阶段 2 完成）
- ✅ 技术栈已确定
- ✅ 验证方案已明确

**如未满足，立即停止并返回相应阶段**

### 2. 选择实施策略

#### 策略 A：垂直切片（推荐）
从用户视角完整实现一个功能流程

示例：
```
✅ 推荐：实现"用户注册"完整流程
   - 网络接收注册请求
   - 验证用户输入
   - 写入数据库
   - 返回结果
   - 日志记录

❌ 避免：先实现所有"网络层"再实现"业务层"
```

#### 策略 B：测试驱动（TDD）
1. 先编写测试用例（基于旧系统行为）
2. 实现功能使测试通过
3. 重构优化

### 3. 代码实现

#### 3.1 项目结构
// turbo
```powershell
# 初始化 Go 模块
go mod init github.com/yourname/y1000

# 创建必要目录
mkdir -p cmd/login cmd/gate cmd/game
mkdir -p internal/domain internal/service internal/repository internal/handler
mkdir -p pkg/protocol pkg/config pkg/database pkg/logger pkg/util
mkdir -p configs scripts test
```

#### 3.2 编码规范

**命名约定**（遵循 Go 规范）：
```go
// ✅ 正确：使用驼峰命名，导出符号首字母大写
type PlayerManager struct {
    players map[int]*Player  // 私有字段小写开头
}

func (pm *PlayerManager) GetPlayerByID(id int) *Player {
    return pm.players[id]
}

// ❌ 错误：不符合 Go 规范
type player_manager struct {  // 不要使用下划线
    m_players map[int]*Player  // 不要使用匈牙利命名
}

func (pm *player_manager) get_player_by_id(id int) *Player {  // 函数名应驼峰
    return pm.m_players[id]
}
```

**禁止事项**（红线）：
- ❌ 复制旧代码超过 5 行
- ❌ 使用全局可变变量（只读常量可以）
- ❌ 不检查边界的切片访问
- ❌ 滥用 unsafe 包
- ❌ 硬编码配置
- ❌ 明文存储密码
- ❌ 循环包依赖

**必须遵循**（Go 最佳实践）：
- ✅ 使用内置类型（slice, map, channel）
- ✅ 使用接口（便于测试和解耦）
- ✅ 使用组合而非继承（Go 没有继承）
- ✅ 使用错误返回值而非 panic
- ✅ 合理使用 goroutine 和 channel
- ✅ 遵循 Go 代码规范（gofmt, golint）
- ✅ 使用 context 管理生命周期和超时

#### 3.3 MMORPG 特定约束
- 🎮 战斗计算**必须在服务器**
- 📦 物品生成**必须记录日志**
- 💰 经济操作**必须有事务保护**
- 🔐 客户端消息**必须验证合法性**

### 4. 实现推荐顺序

```
第一轮：核心框架
├── [ ] 项目结构搭建（Go 模块初始化）
├── [ ] 配置系统（viper / 标准库）
├── [ ] 日志系统（zap / logrus / slog）
├── [ ] 网络通信框架（net 包 / gorilla/websocket）
└── [ ] 数据库连接池（database/sql）

第二轮：认证系统
├── [ ] 用户注册
├── [ ] 用户登录
├── [ ] Session 管理
└── [ ] 密码加密（bcrypt）

第三轮：角色系统
├── [ ] 角色创建
├── [ ] 角色列表
├── [ ] 角色删除
└── [ ] 角色选择

第四轮：游戏世界
├── [ ] 地图加载
├── [ ] 玩家移动
├── [ ] 视野管理（AOI）
└── [ ] 对象同步

第五轮：战斗系统
├── [ ] 伤害计算
├── [ ] 技能系统
├── [ ] Buff 系统
└── [ ] 战斗日志

第六轮：物品系统
├── [ ] 背包管理
├── [ ] 装备系统
├── [ ] 物品交易
└── [ ] 掉落系统

...
```

### 5. 代码质量检查

每完成一个模块，执行：

#### 5.1 静态检查
- [ ] 无编译警告（go build）
- [ ] 通过静态分析（go vet）
- [ ] 通过代码格式检查（gofmt, goimports）
- [ ] 通过 linter 检查（golangci-lint）
- [ ] 无全局可变变量（除常量）
- [ ] 无循环包依赖

#### 5.2 代码审查
- [ ] 命名清晰（无匈牙利命名法）
- [ ] 注释充分（**英文**）
- [ ] 异常处理完整
- [ ] 资源释放正确

#### 5.3 性能检查
- [ ] 无明显性能瓶颈
- [ ] 数据库查询有索引
- [ ] 大数据量测试通过

### 6. 技术债务标记

遇到临时方案时，必须标记：

```go
// TODO: 需要实现缓存机制以提升性能
// FIXME: 当前实现在高并发下可能有竞态条件
// HACK: 临时方案，等待上游库修复
// LEGACY: 保留旧逻辑以兼容现有数据
// PERF: 性能优化点，可考虑使用 sync.Pool
```

### 7. 提交代码

#### 提交信息格式
```
feat(player): 实现角色创建功能

- 添加 TPlayerManager 类
- 实现角色数据验证
- 集成数据库持久化
- 添加单元测试

Refs: #12
```

类型前缀：
- `feat`: 新功能
- `fix`: Bug 修复
- `refactor`: 重构
- `perf`: 性能优化
- `test`: 测试
- `docs`: 文档

### 8. 系统完成检查点

每系统完成后：

```
🛑 检查点 5.X：【XXX系统】实现完成

【已实现功能】
- ✅ 功能 1
- ✅ 功能 2

【代码统计】
- 新增文件：X 个
- 代码行数：X 行
- 测试覆盖率：X%

【测试结果】
- ✅ 单元测试：X/Y 通过
- ✅ 功能对比测试：通过
- ✅ 性能测试：符合目标

【技术债务】
- TODO: X 项
- FIXME: Y 项

【下一步】
进入【XXX系统】实现

【用户选项】
1. 输入"继续" - 下一系统
2. 输入"修复问题" - 解决技术债务
3. 输入"验证" - 深度验证
```

## ⚠️ 注意事项

1. **禁止直接翻译**：不能直接将 Delphi 7 代码改成 Delphi 12
2. **理解优先**：先理解业务逻辑，再用现代方式实现
3. **小步快跑**：每次实现小功能，立即验证
4. **持续集成**：频繁提交，避免大批量合并

## 🚫 实施约束

### 必须遵守（红线）
```go
// ❌ 禁止：全局可变变量
var g_PlayerList []*Player

// ✅ 正确：只读全局常量
const MaxPlayers = 1000

// ❌ 禁止：明文密码
password := userInput

// ✅ 正确：加密存储
passwordHash := bcrypt.GenerateFromPassword([]byte(userInput), bcrypt.DefaultCost)

// ❌ 禁止：信任客户端数据
if clientDamage > 0 {
    applyDamage(target, clientDamage)
}

// ✅ 正确：服务器计算
damage := calculateDamageOnServer(attacker, target)
applyDamage(target, damage)

// ✅ 正确：使用接口
type PlayerManager interface {
    GetPlayer(id int) (*Player, error)
}
```

## ✅ 输出检查清单

- [ ] 代码符合 Go 最佳实践
- [ ] 通过 gofmt 和 goimports 格式化
- [ ] 通过 go vet 和 golangci-lint 检查
- [ ] 无红线违规
- [ ] 黄线已说明理由
- [ ] 注释完整（英文）
- [ ] 测试覆盖率 > 60%
- [ ] 性能符合目标
- [ ] 技术债务已标记
- [ ] 提交信息规范
