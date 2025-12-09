---
description: 新增服务端游戏模块的标准流程
---

# 新增服务端模块流程

> 当需要新增游戏系统模块时（如技能系统、背包系统），使用此流程。
> 注意：涉及游戏玩法设计的步骤需要人工确认。

---

## 步骤 1：阅读现有规范
// turbo
```
查看 xxz/docs/specs/interfaces.md
查看 xxz/docs/specs/codestyle.md
```

## 步骤 2：设计模块接口

 **需要人工确认**

设计模块的公共接口，包括：
1. 接口名称 (I + 系统名 + Manager)
2. 核心方法签名
3. 依赖的其他模块

## 步骤 3：创建模块文件

在 `xxz/src/Server/GameServer/Systems/` 中创建：
- `u<ModuleName>.pas` - 模块实现

## 步骤 4：实现核心逻辑

 **需要人工确认** (如涉及游戏玩法)

实现模块的核心功能。

## 步骤 5：注册到 GameServer

在 GameServer 主程序中注册新模块。

## 步骤 6：同步文档
// turbo
```
更新 xxz/docs/specs/interfaces.md
更新 xxz/PROGRESS.md
```
