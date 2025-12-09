---
description: 分析原型代码，确认功能实现细节
---

// turbo-all

# 原型代码分析流程

> **目标**：分析原型代码中的功能实现细节，为 XXZ 项目开发提供参考。

---

## 1. 准备工作

### 步骤 1：确定分析目标

指定要分析的服务或功能：

| 服务 | 原型路径 |
|------|----------|
| BalanceServer | `src_v1_to_v2_community` |
| GateServer | `src_v1_to_v2_community` |
| LoginServer | `src_v1_to_v2_community` |
| DBServer | `src_v1_to_v2_community` |
| GameServer | `src_v1_to_v2_community/tgs1000` |
| Client | `src_v1_to_v2_community/Client` |

> [!TIP]
> 主要参考 `src_v1_to_v2_community`，如需查看更纯净的实现可参考 `src_v1_official`。

---

## 2. 搜索原型代码

### 步骤 2：按文件名搜索

```powershell
Get-ChildItem -Path src_v1_to_v2_community -Recurse -Include *.pas,*.cpp,*.h | Where-Object { $_.Name -match "Keyword" -or $_.DirectoryName -match "Keyword" }
```

### 步骤 3：按内容搜索

```powershell
Get-ChildItem -Path src_v1_to_v2_community -Recurse -Include *.pas | Select-String -Pattern "pattern"
```

---

## 3. 分析代码

### 步骤 4：提取功能清单

分析代码，列出：
1. 核心类和接口
2. 主要功能点
3. 协议消息
4. 数据结构

---

## 4. 更新文档

### 步骤 5：同步到 design.md

> [!IMPORTANT]
> `design.md` 只作为**需求清单**，只记录最终确认需要实现的功能。

将确认需要实现的功能更新到 `xxz/docs/specs/design.md` 的对应服务章节，格式如下：

```markdown
### ServiceName

> 服务简述

| 功能 | 说明 |
|------|------|
| 功能名称 | 功能说明 |
```
