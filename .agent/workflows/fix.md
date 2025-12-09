---
description: 修复编译错误的排查流程
---

// turbo-all

# 编译错误修复流程

> 当遇到 Delphi 编译错误时，使用此流程进行系统化排查。

---

## 步骤 1：理解错误信息

分析编译器错误输出：
- 错误代码 (E xxxx)
- 文件位置和行号
- 错误描述

## 步骤 2：查看错误位置

```
定位到错误文件和行号
```

## 步骤 3：常见错误类型检查

| 错误类型 | 常见原因 | 解决方向 |
|----------|----------|----------|
| Undeclared identifier | 缺少 uses 引用 | 添加正确的单元引用 |
| Type mismatch | 类型不兼容 | 检查类型定义和转换 |
| Not enough parameters | 参数数量不匹配 | 对照接口定义 |
| Method not found | 方法签名错误 | 检查 mORMot2 API 变化 |

## 步骤 4：mORMot2 特定问题

如果涉及 mORMot2 API：
1. 查阅 `patterns.md` 中的 mORMot2 使用模式
2. 确认使用的是正确的单元和类型

## 步骤 5：验证修复

1. 重新编译当前项目
2. 确保无新增错误
3. 更新 `PROGRESS.md`（如适用）
