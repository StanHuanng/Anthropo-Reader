# 📱 Anthropo-Reader

> 一款专为工程背景用户设计的自动化信息聚合 App，集技术前沿与校园情报于一体。

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Enabled-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

## 🎯 项目简介

Anthropo-Reader 是一款结合了 **Flutter 优雅 UI** 和 **自动化数据流** 的信息聚合应用。通过 GitHub Actions 与 Python 爬虫，每日自动抓取 GitHub Trending，并以精美的双主题界面呈现。

### 为什么开发这个 App？

- 📚 **信息过载时代的解决方案**：从海量信息中自动筛选出真正有价值的技术内容
- 🎨 **阅读体验优先**：Claude 风格的羊皮纸主题 + 极夜模式，拒绝千篇一律的设计
- 🔄 **全自动化**：基于 GitHub Actions 的定时任务，零服务器成本

---

## ✨ 核心功能

### 🎨 双主题视觉系统

<table>
<tr>
<td width="50%">

**羊皮纸模式 (Parchment)**
- `Frank Ruhl Libre` 经典衬线字体
- 程序化噪点纹理，模拟纸质阅读感
- 温暖的米黄色调 `#F5F0E6`

</td>
<td width="50%">

**极夜模式 (Pitch Black)**
- 深黑 `#0A0A0A` 背景
- OLED 屏幕优化，省电护眼
- 高对比度文字渲染

</td>
</tr>
</table>

### 📰 GitHub Trending 自动聚合

- **每日自动抓取**：AI、前端、Rust、Go 等热门技术领域
- **Serverless 架构**：基于 GitHub Actions 定时任务
- **云端存储**：Supabase 数据库，支持多设备同步

### 📖 Markdown 阅读器

- 高性能渲染引擎，支持代码高亮
- 图片缓存优化，流畅阅读体验
- 沉浸式全屏模式

---

## 🛠️ 技术栈

- **前端**: Flutter 3.0+ (Dart)
- **数据库**: Supabase (PostgreSQL)
- **自动化**: GitHub Actions + Python
- **UI 库**: `flutter_markdown`, `google_fonts`, `cached_network_image`

---

## 📂 项目结构

```
Anthropo-Reader/
├── app/                              # Flutter 应用源码
│   ├── lib/
│   │   ├── features/feed/            # 信息流模块
│   │   ├── features/reader/          # Markdown 阅读器
│   │   ├── core/theme/               # 双主题系统
│   │   └── config/                   # Supabase 配置
│   └── assets/                       # 图标与纹理资源
├── scripts/
│   └── fetch_github_trending.py      # GitHub 数据抓取脚本
└── .github/workflows/
    └── daily_update.yml              # 每日自动化任务
```

---

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.0
- Android Studio / Xcode (可选)

### 运行应用

```bash
# 克隆项目
git clone https://github.com/your-username/Anthropo-Reader.git
cd Anthropo-Reader/app

# 安装依赖
flutter pub get

# 运行
flutter run
```

### 打包 APK

```bash
# 构建发布版 APK
flutter build apk --release

# APK 输出路径
# app/build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔧 配置说明

### Supabase 配置

在 `app/lib/config/supabase_config.dart` 中配置你的 Supabase 密钥：

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

### GitHub Actions 配置

在仓库 Settings → Secrets 中添加：
- `SUPABASE_URL`
- `SUPABASE_SERVICE_KEY`

---

## 🎨 功能展示

### 信息流页面
- 卡片式布局展示文章列表
- 支持下拉刷新
- 实时主题切换

### 文章阅读页
- Markdown 完整渲染
- 代码语法高亮
- 图片缓存加载

### 主题切换
- 点击顶部图标即可切换主题
- 基于 Provider 状态管理

---

## 📄 开源协议

本项目采用 [MIT License](LICENSE) 开源协议。

---

**📖 阅读即修行，聚合即智慧 ✨**

*Built with ❤️ by engineering students, for engineering students.*
