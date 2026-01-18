class AppConfig {
  // 应用信息
  static const String appName = 'Anthropo Reader';
  static const String appVersion = '1.0.0';

  // API 配置
  static const String githubApiBase = 'https://api.github.com';

  // 默认配置
  static const int defaultArticleLimit = 50;
  static const int summaryMaxLength = 300;

  // 数据源
  static const String sourceGithubTrending = 'github_trending';
  static const String sourceWechat = 'wechat';
}