# 📱 Anthropo-Reader

> 一款专为工程背景用户设计的自动化信息聚合 App

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🎯 项目愿景

Anthropo-Reader 通过 GitHub Actions 与 LLM 语义分析，将海量杂乱的 GitHub Trending 与微信公众号内容，转化为结构化、具备 Claude 风格美感且支持二次智能聚合的 Markdown 日报。

## ✨ 核心特性

- 🎨 **双主题系统**
  - 羊皮纸模式 (Parchment): 暖米白 `#FAF9F5` + 5% 透明度纹理叠加
  - 极夜模式 (Pitch Black): 深黑 `#0A0A0A` + 高对比度文本

- 📖 **优雅的阅读体验**
  - Lora 字体用于正文（18px, 行高 1.6）
  - Inter 字体用于标题（24px, 粗体 600）
  - 完整的 Markdown 渲染支持

- 🔄 **智能数据聚合**
  - GitHub Trending 项目自动抓取
  - AI 驱动的内容摘要（可选）
  - 二次主题聚合收藏夹

- 🚀 **Serverless 架构**
  - GitHub Actions 定时触发
  - Supabase 数据存储
  - 无需常驻服务器

## 🏗️ 技术栈

- **前端**: Flutter (Skia 引擎)
- **状态管理**: Provider
- **数据库**: Supabase (PostgreSQL)
- **自动化**: GitHub Actions + Python
- **AI**: Claude 3.5 Sonnet API (可选)

## 📂 项目结构

```
Anthropo-Reader/
├── app/                          # Flutter 应用
│   ├── lib/
│   │   ├── core/
│   │   │   ├── models/          # 数据模型
│   │   │   ├── theme/           # 主题系统
│   │   │   └── utils/           # 工具类
│   │   ├── features/
│   │   │   ├── feed/            # 文章列表
│   │   │   ├── reader/          # Markdown 阅读器
│   │   │   └── archive/         # 收藏夹
│   │   └── config/              # 配置
│   ├── assets/
│   │   ├── textures/            # 羊皮纸纹理
│   │   └── icons/               # 图标资源
│   └── pubspec.yaml
├── scripts/                      # Python 数据抓取脚本
├── .github/workflows/            # CI/CD 配置
├── claude.md                     # 完整开发指南
└── Anthropo-Reader 开发计划书.md # 项目规划
```

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.0+
- Dart 3.0+
- Python 3.8+ (用于数据抓取脚本)

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Anthropo-Reader.git
   cd Anthropo-Reader/app
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行应用（模拟数据模式）**
   ```bash
   flutter run
   ```

4. **运行应用（Supabase 模式）**
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://your-project.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=your-anon-key
   ```

## 📊 数据库设置

详细的 Supabase 数据库 Schema 和设置步骤请参考 [claude.md](./claude.md#-supabase-数据库设置)。

## 🎨 设计规范

### 颜色系统

**羊皮纸模式**:
- 背景: `#FAF9F5` (暖米白)
- 卡片: `#FFFFFB`
- 边框: `#E8E6E1`
- 文本: `#2C2C2C`

**极夜模式**:
- 背景: `#0A0A0A` (深黑)
- 卡片: `#161616`
- 边框: `#2A2A2A`
- 文本: `#E5E5E5`

### 字体规范

- **正文**: Lora (Serif) - 18px, 行高 1.6
- **标题**: Inter (Sans-serif) - 24px, 粗体 600
- **代码**: JetBrains Mono - 14px

## 📖 开发指南

完整的开发指南、代码模板和实施计划请参考：
- [claude.md](./claude.md) - 详细的开发指南和代码模板
- [Anthropo-Reader 开发计划书.md](./Anthropo-Reader%20开发计划书.md) - 项目规划文档

## 🛣️ 开发路线图

### ✅ 阶段一：UI 基础框架（当前阶段）

- [x] 项目初始化和目录结构
- [x] 双主题系统实现
- [x] 数据模型设计
- [x] 配置文件和工具类
- [ ] UI 组件实现（文章卡片、Feed 列表）
- [ ] Markdown 阅读器
- [ ] 模拟数据源

### ⏳ 阶段二：Serverless 数据流

- [ ] Python 数据抓取脚本
- [ ] GitHub Actions 工作流
- [ ] Supabase 集成
- [ ] 自动化数据推送

### ⏳ 阶段三：阅读体验优化

- [ ] Markdown 渲染优化
- [ ] 收藏夹功能
- [ ] AI 主题聚合

### ⏳ 阶段四：发布部署

- [ ] Android APK 构建
- [ ] iOS 签名安装
- [ ] 离线缓存支持

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 👨‍💻 作者

- 项目构想与设计基于工程背景用户的实际需求
- 技术架构采用现代化的 Serverless 方案

## 🙏 致谢

- [Flutter](https://flutter.dev/) - 跨平台 UI 框架
- [Supabase](https://supabase.com/) - 开源 Firebase 替代方案
- [Google Fonts](https://fonts.google.com/) - Lora 和 Inter 字体
- [Anthropic](https://www.anthropic.com/) - Claude AI 灵感来源

---

**📖 阅读即修行，聚合即智慧 ✨**