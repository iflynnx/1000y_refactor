---
description: 验证类任务工作流（单元测试、功能对比测试、性能测试）
---

# 验证类任务工作流

## 🎯 适用场景

- 单元测试编写与执行
- 功能对比测试（新旧系统）
- 性能基准测试
- 回归测试
- 安全测试

## 🔑 触发关键词

`测试`、`验证`、`对比`、`检查`、`benchmark`、`性能`

## 📋 执行步骤

### 1. 确定验证范围
- 明确被测系统/模块
- 确认依赖的前置条件
- 识别关键验证点

### 2. 准备验证环境

#### 2.1 搭建测试环境
// turbo
```powershell
# 运行所有测试
go test ./...

# 准备测试数据库
mysql -u root -p < test_schema.sql
```

#### 2.2 准备对比基线
如果是功能对比测试：
1. 准备旧系统可执行文件
2. 准备相同测试数据
3. 准备预期输出样本

### 3. 单元测试

#### 3.1 使用 Go testing 标准库

```go
package player_test

import (
    "testing"
    "github.com/yourname/y1000/internal/domain/player"
)

func TestCreatePlayer_ValidData_Success(t *testing.T) {
    // Arrange
    manager := player.NewManager()
    
    // Act
    p, err := manager.CreatePlayer("TestUser", "password123")
    
    // Assert
    if err != nil {
        t.Fatalf("expected no error, got %v", err)
    }
    if p == nil {
        t.Fatal("expected player, got nil")
    }
    if p.Name != "TestUser" {
        t.Errorf("expected name 'TestUser', got '%s'", p.Name)
    }
}

func TestCreatePlayer_DuplicateName_ReturnsError(t *testing.T) {
    // Arrange
    manager := player.NewManager()
    manager.CreatePlayer("TestUser", "pass1")
    
    // Act
    _, err := manager.CreatePlayer("TestUser", "pass2")
    
    // Assert
    if err == nil {
        t.Error("expected error for duplicate name, got nil")
    }
}

func TestGetPlayer_ExistingID_ReturnsPlayer(t *testing.T) {
    // Arrange
    manager := player.NewManager()
    created, _ := manager.CreatePlayer("TestUser", "password123")
    
    // Act
    p, err := manager.GetPlayer(created.ID)
    
    // Assert
    if err != nil {
        t.Fatalf("expected no error, got %v", err)
    }
    if p.ID != created.ID {
        t.Errorf("expected ID %d, got %d", created.ID, p.ID)
    }
}

func TestGetPlayer_NonExistingID_ReturnsError(t *testing.T) {
    // Arrange
    manager := player.NewManager()
    
    // Act
    _, err := manager.GetPlayer(99999)
    
    // Assert
    if err == nil {
        t.Error("expected error for non-existing ID, got nil")
    }
}
```

#### 3.2 运行测试
// turbo
```powershell
# 运行所有测试
go test ./...

# 运行测试并显示覆盖率
go test -cover ./...

# 生成覆盖率报告
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out -o coverage.html

# 运行测试并输出详细信息
go test -v ./...
```

#### 3.3 覆盖率检查
目标：**代码覆盖率 > 60%**

### 4. 功能对比测试

#### 4.1 设计对比方案

```
【测试场景】：用户登录
【测试数据】：账号=test001, 密码=pass123
【旧系统输出】：
  - 返回码：0（成功）
  - SessionId：ABC123
  - 响应时间：45ms
【新系统期望】：
  - 返回码：0（成功）
  - SessionId：有效值（格式匹配）
  - 响应时间：< 100ms
```

#### 4.2 执行对比测试

```go
// 对比测试工具
func TestCompareLoginBehavior(t *testing.T) {
    // 旧系统（通过网络调用或模拟）
    oldResult := callOldLoginServer("test001", "pass123")
    
    // 新系统
    newResult, err := newLoginServer.Login("test001", "pass123")
    if err != nil {
        t.Fatalf("new system login failed: %v", err)
    }
    
    // 对比
    if oldResult.ResultCode != newResult.ResultCode {
        t.Errorf("result code mismatch: old=%d, new=%d", 
            oldResult.ResultCode, newResult.ResultCode)
    }
    
    if newResult.ResponseTime >= 100 {
        t.Errorf("response time too slow: %dms", newResult.ResponseTime)
    }
    
    logComparison(oldResult, newResult)
}
```

#### 4.3 关键对比项

- **战斗系统**：
  - 伤害计算一致性
  - 暴击概率一致性
  - 技能效果一致性

- **物品系统**：
  - 掉落概率一致性
  - 装备属性计算一致性
  - 背包容量限制一致性

- **经济系统**：
  - 交易手续费一致性
  - 货币精度一致性
  - 溢出保护一致性

### 5. 性能基准测试

#### 5.1 性能目标
```
✅ 成功标准：
- 1000 并发 CPU < 30%
- 登录响应 < 100ms
- 战斗延迟 < 16ms（60 FPS）
- 内存增长 < 10MB/小时
```

#### 5.2 压力测试工具

```go
// 模拟并发登录
func BenchmarkLoginConcurrent(b *testing.B) {
    const concurrentUsers = 1000
    loginServer := setupLoginServer()
    
    b.ResetTimer()
    b.RunParallel(func(pb *testing.PB) {
        userID := 0
        for pb.Next() {
            username := fmt.Sprintf("user%d", userID)
            _, err := loginServer.Login(username, "password")
            if err != nil {
                b.Errorf("login failed: %v", err)
            }
            userID++
        }
    })
}

// 压力测试（非 benchmark）
func TestStressLogin(t *testing.T) {
    const concurrentUsers = 1000
    loginServer := setupLoginServer()
    
    var wg sync.WaitGroup
    startTime := time.Now()
    
    for i := 0; i < concurrentUsers; i++ {
        wg.Add(1)
        go func(userID int) {
            defer wg.Done()
            username := fmt.Sprintf("user%d", userID)
            _, err := loginServer.Login(username, "password")
            if err != nil {
                t.Errorf("login failed for %s: %v", username, err)
            }
        }(i)
    }
    
    wg.Wait()
    elapsed := time.Since(startTime)
    
    t.Logf("完成 %d 并发登录，耗时: %.2f 秒", concurrentUsers, elapsed.Seconds())
}
```

#### 5.3 性能分析
// turbo
```powershell
# CPU 性能分析
go test -cpuprofile=cpu.prof -bench=.
go tool pprof cpu.prof

# 内存分析
go test -memprofile=mem.prof -bench=.
go tool pprof mem.prof

# 竞态检测
go test -race ./...

# 生成性能报告
go test -bench=. -benchmem ./...
```

### 6. 安全测试

#### 6.1 输入验证测试

```go
// SQL 注入测试
func TestSQLInjection(t *testing.T) {
    userManager := setupUserManager()
    
    // 尝试 SQL 注入
    _, err := userManager.Login("admin' OR '1'='1", "any")
    
    // 应该返回错误，不应该成功登录
    if err == nil {
        t.Error("SQL injection vulnerability detected")
    }
}

// XSS 测试
func TestXSSPrevention(t *testing.T) {
    player, err := CreatePlayer("<script>alert(1)</script>", "pass")
    if err != nil {
        t.Fatalf("create player failed: %v", err)
    }
    
    // 检查是否包含 HTML 标签
    if strings.Contains(player.Name, "<") || strings.Contains(player.Name, ">") {
        t.Error("XSS vulnerability: HTML tags not sanitized")
    }
}
```

#### 6.2 权限测试

```go
// 越权测试
func TestUnauthorizedAccess(t *testing.T) {
    // 以普通用户登录
    session := loginAsNormalUser()
    adminPanel := setupAdminPanel()
    
    // 尝试执行管理员操作
    err := adminPanel.BanUser(session, "target_user")
    
    // 应该返回未授权错误
    if err == nil {
        t.Error("unauthorized access allowed")
    }
    
    // 检查错误类型
    var unauthorizedErr *UnauthorizedError
    if !errors.As(err, &unauthorizedErr) {
        t.Errorf("expected UnauthorizedError, got %T", err)
    }
}
```

#### 6.3 安全检查清单
- [ ] 密码使用 bcrypt 存储
- [ ] 敏感数据传输加密
- [ ] 用户输入验证
- [ ] SQL 参数化查询
- [ ] 会话超时机制
- [ ] 防重放攻击

### 7. 回归测试

每次代码变更后：
// turbo
```powershell
# 运行完整测试套件
go test ./...

# 检查测试结果
if ($LASTEXITCODE -ne 0) {
    Write-Error "回归测试失败!"
    exit 1
}

# 运行竞态检测
go test -race ./...
```

### 8. 生成测试报告

#### 8.1 报告内容

```markdown
# 验证报告：XXX 系统

## 测试概览
- 测试日期：2025-12-04
- 测试范围：用户认证系统
- 测试人员：AI Agent

## 测试结果

### 单元测试
- ✅ 通过：45/50
- ❌ 失败：5/50
- 覆盖率：68%

### 功能对比测试
- ✅ 登录流程：一致
- ✅ 密码验证：一致
- ⚠️ 响应时间：新系统更快（45ms vs 80ms）

### 性能测试
- ✅ 1000 并发：CPU 25%（目标 < 30%）
- ✅ 登录响应：78ms（目标 < 100ms）
- ✅ 内存增长：5MB/小时（目标 < 10MB/小时）

### 安全测试
- ✅ SQL 注入：已防御
- ✅ XSS：已防御
- ✅ 密码存储：bcrypt 加密

## 问题清单

### 高优先级
1. 【Bug】密码长度未验证 - 允许空密码

### 中优先级
2. 【性能】登录日志写入阻塞主线程

### 低优先级
3. 【优化】错误消息不够友好

## 结论
✅ 系统可以进入下一阶段
⚠️ 但需修复高优先级问题
```

#### 8.2 JSON 数据
```json
{
  "test_summary": {
    "date": "2025-12-04",
    "total_tests": 50,
    "passed": 45,
    "failed": 5,
    "coverage": 68
  },
  "issues": [
    {
      "priority": "high",
      "type": "bug",
      "description": "密码长度未验证"
    }
  ]
}
```

### 9. 提交验证检查点

```
🛑 验证完成：【XXX系统】

【测试统计】
- 单元测试：45/50 通过（68% 覆盖率）
- 功能对比：3/3 通过
- 性能测试：✅ 符合目标
- 安全测试：✅ 通过

【发现问题】
🔴 高优先级：1 个
🟡 中优先级：1 个
🟢 低优先级：1 个

【输出文档】
- 📄 verification_report.md
- 📄 test_results.json
- 📄 performance_metrics.json

【建议】
✅ 修复高优先级问题后可进入下一系统
⚠️ 中低优先级问题记录为技术债务

【用户选项】
1. 输入"继续" - 进入下一系统（接受技术债务）
2. 输入"修复" - 先修复所有问题
3. 输入"重测" - 调整测试方案并重新测试
```

## ⚠️ 注意事项

1. **不要过度测试**：测试应聚焦核心功能，不是 100% 覆盖率
2. **实用主义**：测试要有价值，避免测试琐碎代码
3. **持续集成**：每次提交都应运行基础测试
4. **文档化失败**：失败的测试要记录详细信息

## ✅ 验证检查清单

- [ ] 单元测试覆盖率 > 60%
- [ ] 关键功能有功能对比测试
- [ ] 性能符合目标
- [ ] 安全检查通过
- [ ] 测试报告完整
- [ ] 问题已分类并记录
