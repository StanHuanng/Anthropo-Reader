# 📱 Anthropo-Reader

> 一款专为工程背景用户设计的自动化信息聚合 App，集技术前沿与校园情报于一体。

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Enabled-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🎯 项目愿景

Anthropo-Reader 通过 GitHub Actions 与 LLM 语义分析，将海量杂乱的 GitHub Trending、技术新闻与**校园教务通知**，转化为结构化、具备 Claude 风格美感且支持二次智能聚合的 Markdown 日报。

## ✨ 核心特性

- 🎨 **双主题视觉系统**
  - **羊皮纸模式 (Parchment)**: `Frank Ruhl Libre` 衬线体 + 程序化噪点纹理，还原纸质阅读感。
  - **极夜模式 (Pitch Black)**: 深黑 `#0A0A0A` 背景，专为 OLED 屏幕优化。

- 🔄 **全自动化数据流**
  - **GitHub Trending**: 每日自动抓取 AI、前端、Rust 等热门领域。
  - **Serverless**: 结合 Python 脚本与 GitHub Actions，零成本运维。
  - **智能降级**: 无网环境下自动切换至本地模拟数据，演示无忧。

- 🏫 **校园情报局 (开发中)**
  - 针对**微电子专业**定制的教务通知抓取。
  - 智能过滤选课、保研、考试等关键信息。

## 🏗️ 技术栈

- **前端**: Flutter (Skia 引擎)
- **数据库**: Supabase (PostgreSQL + RLS)
- **自动化**: GitHub Actions + Python (Requests/BeautifulSoup)
- **AI**: (规划中) Claude 3.5 / GPT-4o 用于内容深度摘要

## 📂 项目结构

```
Anthropo-Reader/
├── app/                          # Flutter 客户端源码
│   ├── lib/
│   │   ├── features/feed/        # 信息流模块
│   │   ├── features/reader/      # Markdown 渲染引擎
│   │   └── core/theme/           # 双主题系统
│   └── pubspec.yaml
├── scripts/                      # Python 数据爬虫
│   ├── fetch_github_trending.py  # GitHub 趋势抓取 (已上线)
│   └── fetch_scut_jw.py          # 教务处爬虫 (开发中)
├── .github/workflows/            # 每日定时任务配置
└── claude.md                     # 🤖 AI 协作开发指南 (核心文档)
```

## 🚀 快速开始

1. **环境准备**
   - Flutter SDK
   - Python 3.8+ (用于运行爬虫)

2. **启动应用**
   ```bash
   cd app
   flutter pub get
   flutter run
   ```

3. **手动触发数据更新**
   ```bash
   # 需配置 Supabase 密钥
   python scripts/fetch_github_trending.py --limit 10 --upload
   ```

## 🛣️ 开发路线图

### ✅ Phase 1: 基础框架 (Completed)
- [x] Flutter 双主题 UI 搭建 (Parchment/Pitch Black)
- [x] Markdown 高性能渲染器
- [x] 模拟数据源实现

### ✅ Phase 2: 后端自动化 (Completed)
- [x] Supabase 数据库接入
- [x] Python 抓取脚本 (GitHub Trending)
- [x] GitHub Actions 定时任务配置

### 🚧 Phase 3: 校园与 AI (In Progress)
- [ ] **华工教务处爬虫开发** (SCUT Crawler)
- [ ] 针对微电子专业的智能过滤规则
- [ ] 接入 LLM API 生成文章摘要

### ⏳ Phase 4: 体验与发布 (Planned)
- [ ] 文章收藏与归档功能
- [ ] Android APK 打包发布

## 📖 开发文档

详细的开发指南、代码规范及下一步计划请查阅：
👉 **[CLAUDE.md](./claude.md)** (本项目最重要的文档)

---

**📖 阅读即修行，聚合即智慧 ✨**
