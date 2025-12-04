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
# 编译测试项目
dcc32.exe -B TestProject.dpr

# 准备测试数据库
mysql -u root -p < test_schema.sql
```

#### 2.2 准备对比基线
如果是功能对比测试：
1. 准备旧系统可执行文件
2. 准备相同测试数据
3. 准备预期输出样本

### 3. 单元测试

#### 3.1 使用 DUnit / DUnitX

```delphi
unit PlayerManagerTests;

interface

uses
  DUnitX.TestFramework,
  PlayerManager;

type
  [TestFixture]
  TPlayerManagerTests = class
  private
    FManager: IPlayerManager;
  public
    [Setup]
    procedure Setup;
    
    [TearDown]
    procedure TearDown;
    
    [Test]
    procedure TestCreatePlayer_ValidData_Success;
    
    [Test]
    procedure TestCreatePlayer_DuplicateName_ThrowsException;
    
    [Test]
    procedure TestGetPlayer_ExistingId_ReturnsPlayer;
    
    [Test]
    procedure TestGetPlayer_NonExistingId_ReturnsNil;
  end;

implementation

procedure TPlayerManagerTests.Setup;
begin
  FManager := TPlayerManager.Create;
end;

procedure TPlayerManagerTests.TearDown;
begin
  FManager := nil;
end;

procedure TPlayerManagerTests.TestCreatePlayer_ValidData_Success;
var
  Player: TPlayer;
begin
  // Arrange
  
  // Act
  Player := FManager.CreatePlayer('TestUser', 'password123');
  
  // Assert
  Assert.IsNotNull(Player);
  Assert.AreEqual('TestUser', Player.Name);
end;

...
```

#### 3.2 运行测试
// turbo
```powershell
# 运行所有测试
TestProject.exe

# 生成测试报告
TestProject.exe --xml-output=test_results.xml
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

```delphi
// 对比测试工具
procedure CompareLoginBehavior;
var
  OldResult, NewResult: TLoginResult;
begin
  // 旧系统
  OldResult := OldLoginServer.Login('test001', 'pass123');
  
  // 新系统
  NewResult := NewLoginServer.Login('test001', 'pass123');
  
  // 对比
  Assert.AreEqual(OldResult.ResultCode, NewResult.ResultCode);
  Assert.IsTrue(NewResult.ResponseTime < 100);
  
  LogComparison(OldResult, NewResult);
end;
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

```delphi
// 模拟并发登录
procedure StressTestLogin(AConcurrentUsers: Integer);
var
  Threads: TArray<TThread>;
  i: Integer;
  StartTime, EndTime: TDateTime;
begin
  SetLength(Threads, AConcurrentUsers);
  
  StartTime := Now;
  
  // 启动并发线程
  for i := 0 to AConcurrentUsers - 1 do
  begin
    Threads[i] := TThread.CreateAnonymousThread(
      procedure
      begin
        LoginServer.Login(Format('user%d', [i]), 'password');
      end);
    Threads[i].Start;
  end;
  
  // 等待完成
  for i := 0 to AConcurrentUsers - 1 do
    Threads[i].WaitFor;
    
  EndTime := Now;
  
  WriteLn(Format('完成 %d 并发登录，耗时: %.2f 秒', 
    [AConcurrentUsers, (EndTime - StartTime) * 86400]));
end;
```

#### 5.3 性能分析
// turbo
```powershell
# 使用 Delphi 性能分析工具
# 或使用 Windows Performance Analyzer

# 检查内存泄漏
# 启用 FastMM4 FullDebugMode
```

### 6. 安全测试

#### 6.1 输入验证测试

```delphi
// SQL 注入测试
procedure TestSQLInjection;
begin
  Assert.WillRaise(
    procedure
    begin
      UserManager.Login('admin'' OR ''1''=''1', 'any');
    end,
    EInvalidInput);
end;

// XSS 测试
procedure TestXSSPrevention;
begin
  Player := CreatePlayer('<script>alert(1)</script>', 'pass');
  Assert.IsFalse(ContainsHTML(Player.Name));
end;
```

#### 6.2 权限测试

```delphi
// 越权测试
procedure TestUnauthorizedAccess;
begin
  Session := LoginAsNormalUser();
  
  Assert.WillRaise(
    procedure
    begin
      AdminPanel.BanUser(Session, 'target_user');
    end,
    EUnauthorized);
end;
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
run_all_tests.bat

# 检查测试结果
if ($LASTEXITCODE -ne 0) {
    Write-Error "回归测试失败!"
    exit 1
}
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
