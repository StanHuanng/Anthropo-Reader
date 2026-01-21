# 📱 Anthropo-Reader

> 我为自己打造的**个人信息策展工具**——一款专注于技术前沿阅读的轻量级应用。

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Enabled-green.svg)](https://supabase.com/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

## 🎯 项目初心

Anthropo-Reader 是一个**纯个人使用工具**，解决我日常的一个具体痛点：

在信息爆炸时代，我想要：
- 📚 **自动化聚合**：每天自动抓取 GitHub Trending，无需手动浏览
- 🎨 **舒适的阅读体验**：拒绝千篇一律的 App 设计，用美学提升阅读质量
- ✍️ **专注而优雅**：一个简洁的工具，专心做好阅读这一件事

---

## ✨ 核心功能

### 🎨 双主题视觉系统

<table>
<tr>
<td width="50%">

**羊皮纸主题 (Parchment)**

古典书房的温暖气质
- `Frank Ruhl Libre` 衬线字体
- 程序化噪点纹理，还原纸质感
- 温暖米黄 `#F5F0E6`，减少眼疲劳
- 适合日间专注阅读

</td>
<td width="50%">

**极夜主题 (Pitch Black)**

为夜间阅读设计

- 纯黑 `#0A0A0A` 背景
- OLED 屏幕优化，护眼省电
- 高对比度，文字清晰
- 沉浸式无干扰体验

</td>
</tr>
</table>

### 📰 GitHub Trending 自动聚合

每日自动抓取，零手动操作
- 🤖 每天定时自动更新热门项目
- 🔗 GitHub Actions 驱动的 Serverless 架构
- 💾 Supabase 云端存储，设备间同步

### 📖 Markdown 阅读器

为阅读而优化的简洁设计
- ⚡ 高性能渲染，流畅阅读体验
- 🌈 代码语法高亮
- 🖼️ 图片智能缓存加载
- 🌙 全屏沉浸模式

---

## 🛠️ 技术栈

| 层级 | 技术 | 用途 |
|------|------|------|
| **前端** | Flutter 3.0+ | 跨平台应用 |
| **数据库** | Supabase (PostgreSQL) | 云端数据存储 |
| **自动化** | GitHub Actions + Python | 定时数据抓取 |
| **UI 库** | flutter_markdown, google_fonts | 渲染和排版 |

---

## 📂 项目结构

```
Anthropo-Reader/
├── app/                              # Flutter 应用
│   ├── lib/
│   │   ├── features/
│   │   │   ├── feed/                 # 信息流页面
│   │   │   └── reader/               # Markdown 阅读器
│   │   ├── core/
│   │   │   ├── theme/                # 双主题系统
│   │   │   └── config/               # Supabase 配置
│   │   └── widgets/                  # UI 组件
│   └── assets/
│       ├── fonts/                    # 自定义字体
│       ├── textures/                 # 纹理资源
│       └── icons/                    # 图标
├── scripts/
│   └── fetch_github_trending.py      # 爬虫脚本
└── .github/workflows/
    └── daily_update.yml              # 每日定时任务
```

---

## 🚀 快速开始

### 环境要求

```bash
Flutter SDK >= 3.0
Dart >= 2.17
```

### 本地运行

```bash
# 克隆项目
git clone https://github.com/your-username/Anthropo-Reader.git
cd Anthropo-Reader/app

# 安装依赖
flutter pub get

# 运行
flutter run
```

### 打包应用

```bash
# 构建 APK
flutter build apk --release
# 输出：app/build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔧 配置说明

### Supabase 配置

在 `lib/config/supabase_config.dart` 中填入你的密钥：

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

### GitHub Actions 配置

在仓库 Settings 中添加以下 Secrets：
- `SUPABASE_URL` — Supabase 项目 URL
- `SUPABASE_SERVICE_KEY` — 服务密钥

---

## 🎨 设计理念

### 排版与美学
- 基于黄金比例的间距
- 衬线字体与无衬线的搭配
- 色彩心理学的应用

### 交互体验
- 微妙的动画，不分散注意力
- 书籍翻页的自然感
- 直观的手势交互

### 可用性
- 高对比度支持
- 可调节的字体大小和行距
- 屏幕阅读器兼容

---

## 💭 为什么做这个

> "工具应该隐形，只让内容闪闪发光。"

这是我为自己设计的工具。我不想用通用的新闻聚合应用，因为它们往往过度设计、功能冗余。我只需要：每天自动拿到最新的技术资讯，用一个舒适优雅的界面来阅读。

---

## 📄 开源协议

[MIT License](LICENSE)

---

**阅读即修行。** ✨

