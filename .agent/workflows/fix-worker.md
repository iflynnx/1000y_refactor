---
description: 修复类任务工作流（Bug修复、性能优化、代码重构）
---

# 修复类任务工作流

## 🎯 适用场景

- Bug 修复
- 性能优化
- 代码重构
- 技术债务清理
- 安全漏洞修复

## 🔑 触发关键词

`修复`、`调试`、`优化`、`重构`、`bug`、`问题`、`漏洞`

## 📋 执行步骤

### 1. 问题确认

#### 1.1 收集问题信息
- 问题描述（What）
- 复现步骤（How）
- 预期行为（Expected）
- 实际行为（Actual）
- 影响范围（Impact）
- 严重程度（Severity）

#### 1.2 问题分类

**按类型**：
- 🐛 Bug：功能不符合预期
- 🐌 性能：响应慢、资源占用高
- 🔐 安全：安全漏洞
- 💡 重构：代码质量改进
- 📝 技术债务：临时方案清理

**按优先级**：
- 🔴 P0（紧急）：系统崩溃、数据丢失、安全漏洞
- 🟠 P1（高）：核心功能不可用
- 🟡 P2（中）：次要功能问题
- 🟢 P3（低）：优化改进

### 2. 问题定位

#### 2.1 复现问题
// turbo
```powershell
# 编译并运行问题版本
go build -o buggy.exe ./cmd/game
.\buggy.exe

# 执行复现步骤
# 观察日志输出
```

#### 2.2 调试分析

**使用 Go 调试工具**：
- 使用 Delve 调试器：`dlv debug ./cmd/game`
- 设置断点：`break main.main`
- 单步执行：`next`, `step`
- 观察变量：`print varName`
- 查看调用堆栈：`stack`

**日志分析**：
```go
import "log/slog"

// 添加调试日志
slog.Debug("player login attempt", "username", username)
slog.Debug("database query", "sql", sqlQuery)
```

**性能分析**：
```go
import "time"

// 使用 time 包测量
start := time.Now()

// 被测代码
processHeavyOperation()

elapsed := time.Since(start)
log.Printf("Operation took: %v", elapsed)
```

#### 2.3 根因分析（Root Cause Analysis）

使用 5 Whys 方法：
```
问题：玩家登录失败
Why 1：数据库连接超时
Why 2：连接池耗尽
Why 3：连接未正确释放
Why 4：异常处理不完整
Why 5：开发时未考虑异常场景

根本原因：缺少 try-finally 保护
```

### 3. 设计修复方案

#### 3.1 方案对比

```markdown
## 方案 A：快速修复
**方案**：添加 try-finally 保护
**优点**：
- 改动小
- 风险低
- 快速上线
**缺点**：
- 治标不治本
- 可能有其他地方也有同样问题

## 方案 B：系统性修复
**方案**：引入连接池管理类
**优点**：
- 一劳永逸
- 统一管理
**缺点**：
- 改动大
- 需要更多测试

## AI 推荐：方案 A（紧急）+ 方案 B（计划）
```

#### 3.2 影响分析
- 影响的模块
- 需要回归测试的范围
- 是否需要数据迁移
- 是否影响客户端

### 4. 实施修复

#### 4.1 代码修改

**Bug 修复示例**：
```go
// ❌ Before（有问题）
func (db *DBManager) Query(sql string) error {
    conn := db.connectionPool.Acquire()
    err := conn.Execute(sql)  // 如果出错，连接不会释放
    db.connectionPool.Release(conn)
    return err
}

// ✅ After（修复后）
func (db *DBManager) Query(sql string) error {
    conn := db.connectionPool.Acquire()
    defer db.connectionPool.Release(conn)  // 使用 defer 确保释放
    
    return conn.Execute(sql)
}
```

**性能优化示例**：
```go
// ❌ Before（低效）
func (pm *PlayerManager) FindPlayerByName(name string) *Player {
    // O(n) 遍历切片
    for _, player := range pm.players {
        if player.Name == name {
            return player
        }
    }
    return nil
}

// ✅ After（优化后）
// 使用 map O(1) 查找
type PlayerManager struct {
    playersByID   map[int]*Player
    playersByName map[string]*Player  // 添加按名称索引
}

func (pm *PlayerManager) FindPlayerByName(name string) *Player {
    return pm.playersByName[name]  // O(1) 查找
}
```

**重构示例**：
```go
// ❌ Before（重复代码）
func ProcessPlayerLogin(player *Player) {
    log.Printf("Player login: %s", player.Name)
    SendWelcomeMessage(player)
    UpdateLastLoginTime(player)
}

func ProcessPlayerReconnect(player *Player) {
    log.Printf("Player reconnect: %s", player.Name)
    SendWelcomeMessage(player)
    UpdateLastLoginTime(player)
}

// ✅ After（消除重复）
func onPlayerEnterGame(player *Player, action string) {
    log.Printf("Player %s: %s", action, player.Name)
    SendWelcomeMessage(player)
    UpdateLastLoginTime(player)
}

func ProcessPlayerLogin(player *Player) {
    onPlayerEnterGame(player, "login")
}

func ProcessPlayerReconnect(player *Player) {
    onPlayerEnterGame(player, "reconnect")
}
```

#### 4.2 添加保护措施

**输入验证**：
```go
func CreatePlayer(name, password string) (*Player, error) {
    // 参数验证
    if name == "" || len(name) > 20 {
        return nil, errors.New("invalid player name")
    }
    
    if len(password) < 6 {
        return nil, errors.New("password too short")
    }
    
    // 业务逻辑
    // ...
    return player, nil
}
```

**错误处理**：
```go
func (db *Database) Execute(sql string) error {
    if err := db.conn.Exec(sql); err != nil {
        // 记录错误
        slog.Error("database error", "error", err, "sql", sql)
        
        // 返回包装后的错误
        return fmt.Errorf("execute sql failed: %w", err)
    }
    return nil
}
```

### 5. 测试验证

#### 5.1 单元测试
为修复的代码添加/更新单元测试：

```go
func TestConnectionRelease_WithError_StillReleases(t *testing.T) {
    pool := setupConnectionPool()
    dbManager := NewDBManager(pool)
    
    initialCount := pool.AvailableCount()
    
    // 执行会失败的查询
    err := dbManager.Query("INVALID SQL")
    
    // 应该返回错误
    if err == nil {
        t.Error("expected error, got nil")
    }
    
    finalCount := pool.AvailableCount()
    
    // 确保连接被释放
    if initialCount != finalCount {
        t.Errorf("connection leaked: initial=%d, final=%d", 
            initialCount, finalCount)
    }
}
```

#### 5.2 回归测试
// turbo
```powershell
# 运行完整测试套件
go test ./...

# 运行特定包的测试
go test ./pkg/database/...

# 运行竞态检测
go test -race ./...
```

#### 5.3 性能对比
```
修复前：
- 玩家查找：平均 150ms（1000 玩家）
- CPU 占用：45%

修复后：
- 玩家查找：平均 0.5ms（1000 玩家）✅ 提升 300 倍
- CPU 占用：15% ✅ 降低 67%
```

### 6. 代码审查

自审清单：
- [ ] 修复了根本原因（不是临时方案）
- [ ] 没有引入新问题
- [ ] 代码清晰易懂
- [ ] 添加了必要注释
- [ ] 添加了单元测试
- [ ] 性能没有退化

### 7. 提交代码

#### 提交信息格式
```
fix(database): 修复连接池泄漏问题

问题描述：
- 数据库连接在异常时未释放
- 导致连接池耗尽

根本原因：
- 缺少 try-finally 保护

解决方案：
- 添加 try-finally 确保连接释放
- 添加单元测试验证异常场景

影响范围：
- 所有数据库查询操作

测试：
- ✅ 单元测试通过
- ✅ 回归测试通过
- ✅ 负载测试 1000 并发无泄漏

Fixes: #123
```

### 8. 文档更新

如果修复影响使用方式：
- 更新 API 文档
- 更新配置说明
- 添加迁移指南（如需要）

### 9. 验证部署

#### 9.1 测试环境验证
// turbo
```powershell
# 构建可执行文件
go build -o gameserver.exe ./cmd/game

# 部署到测试环境
# (复制可执行文件和配置)

# 运行冒烟测试
go test -tags=smoke ./test/...
```

#### 9.2 监控观察
- 错误日志：是否有新错误
- 性能指标：是否有改善
- 资源占用：CPU、内存是否正常

### 10. 提交修复检查点

```
🛑 修复完成：【XXX 问题】

【问题信息】
- 类型：🐛 Bug / 🐌 性能 / 🔐 安全
- 优先级：🔴 P0
- 影响范围：数据库连接模块

【根本原因】
缺少异常保护导致连接泄漏

【修复方案】
添加 try-finally 确保资源释放

【验证结果】
- ✅ 单元测试：新增 3 个测试，全部通过
- ✅ 回归测试：156/156 通过
- ✅ 负载测试：1000 并发无泄漏
- ✅ 性能改善：响应时间减少 20%

【影响】
- 改动文件：1 个
- 代码行数：+8 行

【输出文档】
- 📄 fix_report.md
- 📄 test_results.json

【建议】
✅ 可以部署到生产环境

【用户选项】
1. 输入"部署" - 准备生产部署
2. 输入"继续" - 修复下一个问题
3. 输入"暂停" - 保存进度
```

## ⚠️ 注意事项

1. **不要扩大范围**：只修复当前问题，不要"顺便"改其他
2. **保持向后兼容**：除非必要，不要破坏现有 API
3. **充分测试**：Bug 修复也可能引入新 Bug
4. **记录日志**：修复过程要有痕迹可追溯

## 🚫 修复约束

### 禁止行为
- ❌ 猜测修复：必须找到根本原因
- ❌ 临时屏蔽：不能只是注释掉报错代码
- ❌ 过度修复：不要重写整个模块
- ❌ 无测试修复：必须有测试验证

### 推荐做法
- ✅ 根因分析：使用 5 Whys
- ✅ 最小改动：只改必须改的
- ✅ 防御编程：添加输入验证
- ✅ 测试先行：先写失败测试，再修复

## ✅ 修复检查清单

- [ ] 问题已准确定位
- [ ] 根本原因已识别
- [ ] 修复方案已设计
- [ ] 代码改动最小
- [ ] 添加/更新单元测试
- [ ] 回归测试通过
- [ ] 性能无退化
- [ ] 提交信息详细
- [ ] 文档已更新（如需要）
