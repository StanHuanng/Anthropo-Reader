# Anthropo-Reader 开发指南

## 📋 项目概述

Anthropo-Reader 是一款专为工程背景用户设计的自动化信息聚合 App，通过 Flutter 构建，具备双主题视觉系统（羊皮纸模式 + 极夜模式）。

**当前状态**: 阶段一 - 核心基础文件已创建 ✅

---

## 🎯 已完成的工作

### ✅ 已创建的文件

1. **配置文件**
   - `app/pubspec.yaml` - Flutter 项目依赖配置

2. **核心数据模型**
   - `app/lib/core/models/article.dart` - 文章数据模型

3. **主题系统**
   - `app/lib/core/theme/parchment_theme.dart` - 羊皮纸主题
   - `app/lib/core/theme/pitch_black_theme.dart` - 极夜主题
   - `app/lib/core/theme/theme_provider.dart` - 主题状态管理

4. **工具类**
   - `app/lib/core/utils/date_formatter.dart` - 日期格式化工具

5. **配置类**
   - `app/lib/config/app_config.dart` - 应用配置
   - `app/lib/config/supabase_config.dart` - Supabase 配置

6. **目录结构**
   - 完整的 Flutter 项目目录结构已创建

---

## 📂 项目结构

```
d:\个人\Anthropo-Reader\
├── app/
│   ├── pubspec.yaml                    ✅ 已创建
│   ├── lib/
│   │   ├── main.dart                   ⏳ 待创建
│   │   ├── config/
│   │   │   ├── app_config.dart         ✅ 已创建
│   │   │   └── supabase_config.dart    ✅ 已创建
│   │   ├── core/
│   │   │   ├── theme/
│   │   │   │   ├── parchment_theme.dart       ✅ 已创建
│   │   │   │   ├── pitch_black_theme.dart     ✅ 已创建
│   │   │   │   └── theme_provider.dart        ✅ 已创建
│   │   │   ├── models/
│   │   │   │   └── article.dart        ✅ 已创建
│   │   │   └── utils/
│   │   │       └── date_formatter.dart ✅ 已创建
│   │   ├── features/
│   │   │   ├── feed/
│   │   │   │   ├── data/
│   │   │   │   │   ├── repositories/
│   │   │   │   │   │   └── article_repository.dart      ⏳ 待创建
│   │   │   │   │   └── datasources/
│   │   │   │   │       └── mock_datasource.dart         ⏳ 待创建
│   │   │   │   └── presentation/
│   │   │   │       ├── pages/
│   │   │   │       │   └── feed_page.dart               ⏳ 待创建
│   │   │   │       └── widgets/
│   │   │   │           └── article_card.dart            ⏳ 待创建
│   │   │   ├── reader/
│   │   │   │   └── presentation/
│   │   │   │       ├── pages/
│   │   │   │       │   └── reader_page.dart             ⏳ 待创建
│   │   │   │       └── widgets/
│   │   │   │           └── markdown_renderer.dart       ⏳ 待创建
│   │   │   └── archive/
│   │   │       └── presentation/
│   │   │           └── pages/
│   │   │               └── archive_placeholder_page.dart ⏳ 待创建
│   │   └── shared/
│   │       └── widgets/
│   │           └── theme_toggle_button.dart              ⏳ 待创建
│   └── assets/
│       ├── textures/
│       │   └── parchment_noise.png                       ⏳ 需手动添加
│       └── icons/
│           └── github_icon.svg                           ⏳ 需手动添加
├── scripts/
│   └── fetch_github_trending.py                          ⏳ 待创建
└── claude.md                                              ✅ 当前文件
```

---

## 🚀 下一步待创建的文件

### 优先级 1: 模拟数据源
**文件**: `app/lib/features/feed/data/datasources/mock_datasource.dart`

**作用**: 提供模拟数据用于 UI 开发，无需后端即可运行应用

**代码模板**:
```dart
import '../../../core/models/article.dart';

class MockArticleDataSource {
  static List<Article> getMockArticles() {
    return [
      Article(
        id: '1',
        title: 'Building a RISC-V Processor in Verilog',
        summary: '一个完整的 32 位 RISC-V 处理器实现，从零开始使用 Verilog HDL 构建。包含 5 级流水线、哈佛架构和 32 位数据通路。',
        content: '''# Building a RISC-V Processor in Verilog

## Introduction
This project demonstrates a complete implementation of a RISC-V RV32I processor...

## Architecture
- 5-stage pipeline
- Harvard architecture
- 32-bit data path

## Code Example
\`\`\`verilog
module riscv_core (
  input wire clk,
  input wire rst,
  // ... more ports
);
\`\`\`
''',
        source: 'github_trending',
        sourceUrl: 'https://github.com/example/riscv-verilog',
        author: 'hardware_guru',
        publishedAt: DateTime.now().subtract(Duration(hours: 2)),
        fetchedAt: DateTime.now(),
        tags: ['RISC-V', 'Verilog', 'Hardware'],
      ),
      // 添加更多模拟文章...
    ];
  }
}
```

### 优先级 2: 文章仓库
**文件**: `app/lib/features/feed/data/repositories/article_repository.dart`

**代码模板**:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/article.dart';
import '../../../config/supabase_config.dart';
import '../datasources/mock_datasource.dart';

class ArticleRepository {
  final SupabaseClient? _supabase;
  final bool useMockData;

  ArticleRepository({this.useMockData = true})
      : _supabase = SupabaseConfig.isConfigured
          ? Supabase.instance.client
          : null;

  Future<List<Article>> fetchArticles({
    String? source,
    int limit = 50,
  }) async {
    // 如果使用模拟数据或 Supabase 未配置
    if (useMockData || _supabase == null) {
      return MockArticleDataSource.getMockArticles();
    }

    try {
      var query = _supabase!
          .from('articles')
          .select()
          .order('published_at', ascending: false)
          .limit(limit);

      if (source != null) {
        query = query.eq('source', source);
      }

      final response = await query;
      return (response as List)
          .map((json) => Article.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching articles: $e');
      // 出错时返回模拟数据
      return MockArticleDataSource.getMockArticles();
    }
  }

  Future<Article?> fetchArticleById(String id) async {
    if (useMockData || _supabase == null) {
      return MockArticleDataSource.getMockArticles()
          .firstWhere((a) => a.id == id);
    }

    try {
      final response = await _supabase!
          .from('articles')
          .select()
          .eq('id', id)
          .single();
      return Article.fromJson(response);
    } catch (e) {
      print('Error fetching article: $e');
      return null;
    }
  }

  Future<bool> toggleFavorite(String articleId, bool isFavorited) async {
    if (_supabase == null) return false;

    try {
      await _supabase!
          .from('articles')
          .update({'is_favorited': isFavorited})
          .eq('id', articleId);
      return true;
    } catch (e) {
      print('Error toggling favorite: $e');
      return false;
    }
  }
}
```

### 优先级 3: 主题切换按钮
**文件**: `app/lib/shared/widgets/theme_toggle_button.dart`

**代码模板**:
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            themeProvider.isParchmentMode
              ? Icons.dark_mode_outlined
              : Icons.light_mode_outlined,
          ),
          tooltip: themeProvider.isParchmentMode ? '切换到极夜模式' : '切换到羊皮纸模式',
          onPressed: () => themeProvider.toggleTheme(),
        );
      },
    );
  }
}
```

### 优先级 4: 文章卡片组件
**文件**: `app/lib/features/feed/presentation/widgets/article_card.dart`

**代码模板**:
```dart
import 'package:flutter/material.dart';
import '../../../core/models/article.dart';
import '../../../core/utils/date_formatter.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 来源标签
              Row(
                children: [
                  Icon(
                    article.source == 'github_trending'
                        ? Icons.code
                        : Icons.article,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    article.source == 'github_trending'
                        ? 'GitHub Trending'
                        : 'WeChat',
                    style: theme.textTheme.labelSmall,
                  ),
                  Spacer(),
                  if (article.publishedAt != null)
                    Text(
                      DateFormatter.formatRelativeTime(article.publishedAt!),
                      style: theme.textTheme.labelSmall,
                    ),
                ],
              ),
              SizedBox(height: 12),

              // 标题
              Text(
                article.title,
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // 摘要
              if (article.summary != null && article.summary!.isNotEmpty)
                Text(
                  article.summary!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(height: 12),

              // 标签和作者
              Row(
                children: [
                  // 标签
                  if (article.tags.isNotEmpty)
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: article.tags.take(3).map((tag) {
                          return Chip(
                            label: Text(tag),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                    ),

                  // 作者
                  if (article.author != null)
                    Text(
                      '· ${article.author}',
                      style: theme.textTheme.labelMedium,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 优先级 5: Feed 页面
**文件**: `app/lib/features/feed/presentation/pages/feed_page.dart`

**代码模板**:
```dart
import 'package:flutter/material.dart';
import '../../../core/models/article.dart';
import '../../data/repositories/article_repository.dart';
import '../widgets/article_card.dart';
import '../../../shared/widgets/theme_toggle_button.dart';
import '../../../reader/presentation/pages/reader_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ArticleRepository _repository = ArticleRepository(useMockData: true);
  List<Article> _articles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _isLoading = true);
    try {
      final articles = await _repository.fetchArticles();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anthropo Reader'),
        actions: [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无文章', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return ArticleCard(
            article: article,
            onTap: () => _navigateToReader(article),
          );
        },
      ),
    );
  }

  void _navigateToReader(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReaderPage(article: article),
      ),
    );
  }
}
```

### 优先级 6: Markdown 渲染器
**文件**: `app/lib/features/reader/presentation/widgets/markdown_renderer.dart`

**代码模板**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownRenderer extends StatelessWidget {
  final String content;

  const MarkdownRenderer({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Markdown(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        // 段落
        p: GoogleFonts.lora(
          fontSize: 18,
          height: 1.7,
          color: theme.textTheme.bodyLarge?.color,
        ),

        // 标题
        h1: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.headlineLarge?.color,
        ),
        h2: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.headlineMedium?.color,
        ),
        h3: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.headlineSmall?.color,
        ),

        // 代码
        code: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          backgroundColor: isDark ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5),
        ),
        codeblockDecoration: BoxDecoration(
          color: isDark ? Color(0xFF1A1A1A) : Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Color(0xFF2A2A2A) : Color(0xFFE8E6E1),
          ),
        ),
        codeblockPadding: EdgeInsets.all(16),

        // 引用
        blockquote: GoogleFonts.lora(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.primary,
              width: 4,
            ),
          ),
        ),

        // 链接
        a: TextStyle(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
        ),

        // 列表
        listBullet: GoogleFonts.lora(
          fontSize: 18,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href));
        }
      },
    );
  }
}
```

### 优先级 7: 阅读器页面
**文件**: `app/lib/features/reader/presentation/pages/reader_page.dart`

**代码模板**:
```dart
import 'package:flutter/material.dart';
import '../../../core/models/article.dart';
import '../widgets/markdown_renderer.dart';

class ReaderPage extends StatelessWidget {
  final Article article;

  const ReaderPage({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              article.isFavorited
                  ? Icons.bookmark
                  : Icons.bookmark_outline,
            ),
            onPressed: () {
              // TODO: 实现收藏功能
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // TODO: 实现分享功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 文章元信息
            if (article.author != null || article.publishedAt != null)
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    if (article.author != null) ...[
                      Icon(Icons.person_outline, size: 16),
                      SizedBox(width: 4),
                      Text(article.author!,
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                    if (article.publishedAt != null) ...[
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 4),
                      Text(
                        article.publishedAt!.toString().split(' ')[0],
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ],
                ),
              ),

            // Markdown 内容
            MarkdownRenderer(content: article.content),
          ],
        ),
      ),
    );
  }
}
```

### 优先级 8: 主入口文件
**文件**: `app/lib/main.dart`

**代码模板**:
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'config/supabase_config.dart';
import 'features/feed/presentation/pages/feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Supabase（如果配置了的话）
  await SupabaseConfig.initialize();

  runApp(const AnthropoReaderApp());
}

class AnthropoReaderApp extends StatelessWidget {
  const AnthropoReaderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Anthropo Reader',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: FeedPage(),
          );
        },
      ),
    );
  }
}
```

---

## 🛠️ 安装 Flutter 环境

### Windows 安装步骤

1. **下载 Flutter SDK**
   - 访问: https://docs.flutter.dev/get-started/install/windows
   - 下载最新稳定版 (约 1.5GB)

2. **解压并配置环境变量**
   ```bash
   # 解压到: C:\flutter
   # 添加到 PATH: C:\flutter\bin
   ```

3. **运行 Flutter Doctor**
   ```bash
   flutter doctor
   ```

4. **安装 Android Studio**（用于 Android 开发）
   - 下载: https://developer.android.com/studio
   - 安装 Android SDK 和模拟器

5. **验证安装**
   ```bash
   flutter doctor -v
   ```

---

## 🚀 运行项目

### 1. 获取依赖
```bash
cd "d:\个人\Anthropo-Reader\app"
flutter pub get
```

### 2. 创建必要的资源文件

**羊皮纸纹理** (`app/assets/textures/parchment_noise.png`):
- 使用在线工具生成: https://www.noisetexturegenerator.com/
- 尺寸: 512x512px
- 噪点强度: 5%
- 格式: PNG

**GitHub 图标** (`app/assets/icons/github_icon.svg`):
- 下载: https://github.com/logos
- 或使用 Flutter Icons: `Icons.code`

### 3. 运行应用（模拟数据模式）
```bash
# 连接设备或启动模拟器
flutter devices

# 运行应用
flutter run
```

### 4. 运行应用（Supabase 模式）
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

---

## 📊 Supabase 数据库设置

### 1. 创建 Supabase 项目
- 访问: https://supabase.com
- 创建新项目: "anthropo-reader"
- 记录 Project URL 和 Anon Key

### 2. 执行数据库 Schema
在 Supabase SQL 编辑器中执行:

```sql
-- 文章表
CREATE TABLE articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  summary TEXT,
  content TEXT NOT NULL,
  source VARCHAR(50) NOT NULL,
  source_url TEXT,
  author VARCHAR(255),
  published_at TIMESTAMPTZ,
  fetched_at TIMESTAMPTZ DEFAULT now(),
  tags TEXT[],
  is_favorited BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 索引
CREATE INDEX idx_articles_source ON articles(source);
CREATE INDEX idx_articles_published ON articles(published_at DESC);
CREATE INDEX idx_articles_favorited ON articles(is_favorited) WHERE is_favorited = true;

-- 全文搜索
CREATE INDEX idx_articles_search ON articles
USING gin(to_tsvector('english', title || ' ' || COALESCE(summary, '') || ' ' || content));

-- RLS 策略
ALTER TABLE articles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow anonymous read" ON articles FOR SELECT USING (true);
```

---

## 🐍 Python 脚本 - GitHub Trending 数据获取

**文件**: `scripts/fetch_github_trending.py`

```python
#!/usr/bin/env python3
"""
GitHub Trending 数据抓取脚本
用于获取 GitHub 热门项目并转换为 Anthropo-Reader 格式
"""

import requests
import json
from datetime import datetime
import sys

def fetch_trending_repos(language='', limit=20):
    """
    获取 GitHub Trending 仓库

    Args:
        language: 编程语言过滤 (如: python, javascript, verilog)
        limit: 返回数量限制
    """
    url = "https://api.github.com/search/repositories"

    # 构建查询：最近创建且星标数较高的项目
    query = f'stars:>100 created:>2026-01-01'
    if language:
        query += f' language:{language}'

    params = {
        'q': query,
        'sort': 'stars',
        'order': 'desc',
        'per_page': limit
    }

    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        repos = response.json()['items']

        articles = []
        for repo in repos:
            # 构建文章内容
            content = f"""# {repo['name']}

{repo['description'] or '无描述'}

## 项目信息
- **Stars**: {repo['stargazers_count']:,}
- **Language**: {repo['language'] or 'N/A'}
- **Forks**: {repo['forks_count']:,}
- **Open Issues**: {repo['open_issues_count']}
- **Created**: {repo['created_at'][:10]}
- **Last Updated**: {repo['updated_at'][:10]}

## 链接
[查看项目]({repo['html_url']})

## 作者
[{repo['owner']['login']}]({repo['owner']['html_url']})
"""

            article = {
                'title': repo['name'],
                'summary': (repo['description'] or '')[:300],
                'content': content,
                'source': 'github_trending',
                'source_url': repo['html_url'],
                'author': repo['owner']['login'],
                'published_at': repo['created_at'],
                'fetched_at': datetime.now().isoformat(),
                'tags': [repo['language']] if repo['language'] else [],
                'is_favorited': False
            }
            articles.append(article)

        return articles

    except requests.exceptions.RequestException as e:
        print(f"错误: 无法获取数据 - {e}", file=sys.stderr)
        return []

def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(description='获取 GitHub Trending 数据')
    parser.add_argument('--language', default='', help='编程语言过滤')
    parser.add_argument('--limit', type=int, default=20, help='返回数量')
    parser.add_argument('--output', default='', help='输出文件路径')

    args = parser.parse_args()

    print(f"正在获取 GitHub Trending 数据...", file=sys.stderr)
    articles = fetch_trending_repos(args.language, args.limit)

    print(f"成功获取 {len(articles)} 篇文章", file=sys.stderr)

    output_data = json.dumps(articles, indent=2, ensure_ascii=False)

    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(output_data)
        print(f"已保存到: {args.output}", file=sys.stderr)
    else:
        print(output_data)

if __name__ == '__main__':
    main()
```

**使用方法**:
```bash
# 获取所有语言的热门项目
python scripts/fetch_github_trending.py > trending.json

# 仅获取 Python 项目
python scripts/fetch_github_trending.py --language python --limit 10

# 保存到文件
python scripts/fetch_github_trending.py --language verilog --output verilog_trending.json
```

---

## ✅ 开发检查清单

### 阶段一：基础框架
- [x] 创建项目目录结构
- [x] 配置 pubspec.yaml
- [x] 创建数据模型 (Article)
- [x] 实现主题系统（羊皮纸 + 极夜）
- [x] 创建主题管理器
- [x] 创建工具类（日期格式化）
- [ ] 创建模拟数据源
- [ ] 创建文章仓库
- [ ] 创建主题切换按钮
- [ ] 创建文章卡片组件
- [ ] 创建 Feed 页面
- [ ] 创建 Markdown 渲染器
- [ ] 创建阅读器页面
- [ ] 创建主入口文件
- [ ] 添加资源文件（纹理、图标）

### 阶段二：测试验证
- [ ] 运行 `flutter pub get`
- [ ] 修复依赖错误
- [ ] 启动应用并查看 Feed 页面
- [ ] 测试主题切换
- [ ] 测试文章阅读
- [ ] 测试下拉刷新
- [ ] 在不同设备尺寸测试响应式布局

### 阶段三：Supabase 集成
- [ ] 创建 Supabase 项目
- [ ] 执行数据库 Schema
- [ ] 配置 Supabase 凭证
- [ ] 测试数据获取
- [ ] 实现收藏功能

### 阶段四：数据自动化
- [ ] 创建 Python 数据抓取脚本
- [ ] 测试 GitHub Trending 数据获取
- [ ] 设置 GitHub Actions 工作流
- [ ] 配置定时任务

---

## 🎨 设计规范

### 颜色
**羊皮纸模式**:
- 背景: `#FAF9F5`
- 卡片: `#FFFFFb`
- 边框: `#E8E6E1`
- 文本: `#2C2C2C`

**极夜模式**:
- 背景: `#0A0A0A`
- 卡片: `#161616`
- 边框: `#2A2A2A`
- 文本: `#E5E5E5`

### 字体
- **正文**: Lora (18px, 行高 1.6)
- **标题**: Inter (24px, 粗体 600)
- **代码**: JetBrains Mono (14px)

### 间距
- 卡片内边距: 16px
- 卡片间距: 12px
- 水平边距: 16px
- 圆角: 12px

---

## 🆘 常见问题

### Q1: Flutter 命令找不到
**解决**: 确保 Flutter SDK 已添加到系统 PATH

### Q2: 依赖安装失败
**解决**:
```bash
flutter clean
flutter pub get
```

### Q3: 模拟器无法启动
**解决**:
- 检查 Android Studio AVD Manager
- 或使用真实设备

### Q4: 字体无法加载
**解决**:
- 确保 `google_fonts` 版本正确
- 检查网络连接（首次加载需要下载字体）

### Q5: Supabase 连接失败
**解决**:
- 检查 `--dart-define` 参数是否正确
- 验证 Supabase URL 和 Key
- 使用模拟数据模式开发: `useMockData: true`

---

## 📚 参考资源

- **Flutter 官方文档**: https://flutter.dev/docs
- **Supabase 文档**: https://supabase.com/docs
- **Google Fonts**: https://fonts.google.com
- **Flutter Markdown**: https://pub.dev/packages/flutter_markdown
- **Provider 状态管理**: https://pub.dev/packages/provider

---

## 🎯 下一步行动

1. **立即可做**:
   - 安装 Flutter SDK
   - 创建剩余的 Dart 文件（按优先级顺序）
   - 添加资源文件（纹理、图标）

2. **测试验证**:
   - 运行应用并查看双主题效果
   - 测试模拟数据显示
   - 测试文章阅读功能

3. **后续扩展**:
   - 创建 Supabase 项目
   - 实现 Python 数据抓取
   - 设置 GitHub Actions 自动化

---

**祝开发顺利！🚀**

如有问题，请参考此文档或查阅官方文档。