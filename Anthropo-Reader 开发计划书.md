- # 📱 Anthropo-Reader 开发计划书 (v2.0)

  ## 1. 项目愿景

  **Anthropo-Reader** 是一款专为工程背景用户设计的自动化信息聚合 App。它通过 GitHub Actions 与 LLM 语义分析，将海量杂乱的 GitHub 趋势与微信公众号内容，转化为结构化、具备 Claude 风格美感且支持二次智能聚合的 Markdown 日报。

  ------

  ## 2. 核心功能规范

  ### 2.1 视觉系统 (Visuals)

  - **标准卡片列表**：采用整齐的等宽标准列表布局，提升工程化信息的检索效率。
  - **羊皮纸模式 (Parchment)**：
    - 背景色彩：使用暖米白 `#FAF9F5`。
    - 纸质纹理：在背景层叠加 5% 透明度的微噪点纹理图，复刻纸张质感。
    - 字体规范：正文采用 Lora (Serif)，标题采用 Inter。
  - **极夜模式 (Pitch Black)**：背景 `#0A0A0A`，文本采用高对比度灰白。

  ### 2.2 抓取与后端 (Serverless Ingestion)

  - **极简架构**：放弃常驻服务器，完全依托 **GitHub Actions** 定时触发抓取脚本。
  - **数据流流水线**：
    - 集成 `wechat2md` 工具将公众号文章转换为 Markdown。
    - 定时获取 GitHub 关键词相关的 Trending 项目。
  - **存储方案**：利用 **Supabase** (PostgreSQL) 的 Flutter 插件直接进行数据读写，无需额外编写后端 API。

  ### 2.3 智能逻辑 (Intelligence)

  - **AI 自动摘要**：进入阅读器前预览 300 字以内的核心逻辑，去除“AI 味”。
  - **二次主题聚合**：在“收藏夹”中，AI 能够根据已收藏内容的语义进行动态分类（如：将不同来源的 FPGA 硬件、Verilog 技巧聚合为同一专题）。

  ------

  ## 3. 技术栈建议

  - **前端**：Flutter (基于 Skia 引擎)。
  - **后端/自动化**：GitHub Actions + Python 脚本。
  - **数据库/接口**：Supabase (原生支持全文搜索)。
  - **AI 接口**：Claude 3.5 Sonnet API。

  ------

  ## 4. 项目结构计划

  Plaintext

  ```
  anthropo_reader/
  ├── .github/workflows/
  │   └── daily_sync.yml      # 自动化流水线：抓取 -> 摘要 -> 写入 Supabase
  ├── app/ (Flutter 项目)
  │   ├── assets/
  │   │   └── textures/       # 羊皮纸噪点纹理图
  │   ├── lib/
  │   │   ├── features/
  │   │   │   ├── feed/       # 标准列表 UI
  │   │   │   ├── reader/     # 支持 Markdown 渲染的阅读器
  │   │   │   └── archive/    # 二次主题聚合收藏夹
  │   │   └── theme/          # 纸质感主题与深色主题定义
  └── scripts/ (Python 脚本)
      ├── ingest_wechat.py    # 公众号转 MD 逻辑
      └── ai_summarizer.py    # 调用 Claude 生成摘要与初始标签
  ```

  ------

  ## 5. 分步开发路线图

  ### 第一阶段：视觉基准与 UI 引擎

  - [ ] **Step 1.1**: Flutter 项目初始化，配置 `google_fonts` (Lora/Inter)。
  - [ ] **Step 1.2**: 实现双色模式引擎。在 `ThemeData` 中集成背景噪点纹理叠加逻辑。
  - [ ] **Step 1.3**: 开发标准列表卡片组件，包含来源图标、标题、摘要预览。

  ### 第二阶段：Serverless 数据流 (去服务器化)

  - [ ] **Step 2.1**: 编写 Python 爬虫脚本，集成 `wechat2md` 逻辑。
  - [ ] **Step 2.2**: 接入 Claude API 实现摘要生成。
  - [ ] **Step 2.3**: 配置 GitHub Actions，实现每日凌晨自动向 Supabase 推送新内容。

  ### 第三阶段：阅读体验与深度聚合

  - [ ] **Step 3.1**: 集成 `flutter_markdown`，优化代码块与公式显示效果。
  - [ ] **Step 3.2**: 开发收藏夹“二次聚合”功能，调用 Claude 对已存文章进行主题聚类。

  ### 第四阶段：交付与部署

  - [ ] **Step 4.1**: **Android 端**：通过 GitHub Actions 自动构建并输出 Release 版本的 APK。
  - [ ] **Step 4.2**: **iOS 端**：本地连接 Mac，通过 Xcode 进行个人签名安装。
  - [ ] **Step 4.3**: 离线缓存处理，确保无网状态下亦可阅读已加载的 Markdown 内容。

  ------

  ## 6. 风险与对策

  - **API 成本限制**：由于频繁调用 Claude，需在 App 端实现本地缓存，避免重复请求同一摘要。
  - **微信反爬**：若自动化抓取受阻，优先确保“一键链接转换 MD”的本地兜底功能。