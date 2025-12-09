---
trigger: always_on
---

# 仙侠传 (XXZ) - 项目上下文

> ** 每个新会话必须首先阅读此文件！**

---

## 项目概述

| 项目 | 说明 |
|------|------|
| **项目名称** | 仙侠传 (XXZ) |
| **原型参考** | 千年 (1000y) 系列 |
| **开发环境** | Delphi 12.3 (Athens) |
| **目标平台** | Windows 桌面 |
| **代码目录** | `1000y_refactor/xxz/` |

### 原型说明

| 目录 | 说明 |
|------|------|
| `src_v1_to_v2_community/` | 主要原型参考（功能更全） |
| `src_v1_official/` | 辅助参考（实现更纯净） |

> 主要复刻 V2 社区版功能，但 V2 被添加了不必要功能，需对比 V1 筛选。

---

## 文档索引

> 规范文档位置：`xxz/docs/specs/`

| 文档 | 说明 |
|------|------|
| `arch.md` | 技术架构、选型、安全措施 |
| `design.md` | 游戏功能清单、项目结构 |
| `codestyle.md` | Delphi 编码规范 |
| `patterns.md` | mORMot2 代码模式 |
| `protocol.md` | 网络协议规范 |
| `interfaces.md` | 模块接口规范 |
| `datamodel.md` | 数据模型规范 |
| `errors.md` | 错误处理规范 |

> 开发进度：`xxz/PROGRESS.md`

---

> [!CAUTION]
> ##  强制执行规则
>
> **每次代码变更后必须立即更新：**
>
> | 变更类型 | 必须更新的文档 |
> |----------|---------------|
> | 任何代码完成 | `xxz/PROGRESS.md` |
> | 新增协议消息 | `protocol.md` |
> | 新增/修改公共接口 | `interfaces.md` |
> | 新增数据结构 | `datamodel.md` |
> | 新增错误码 | `errors.md` |
>
> ** 不要遗留到后续会话！**

---

> [!IMPORTANT]
> ##  命名规范速查
>
> | 类型 | 前缀 | 示例 |
> |------|------|------|
> | 类 | `T` | `TPlayerManager` |
> | 接口 | `I` | `IAttributeManager` |
> | 记录 | `T` + `Rec/Info/Data` | `TPlayerRec` |
> | 字段 | `F` | `FPlayerID` |
> | 参数 | `A` | `APlayerID` |
> | 局部变量 | 无前缀/小驼峰 | `player` |