class Article {
  final String id;
  final String title;
  final String? summary;
  final String content;
  final String source; // 'github_trending' or 'SCUT_JW'
  final String? sourceUrl;
  final String? author;
  final DateTime? publishedAt;
  final DateTime fetchedAt;
  final List<String> tags;
  final bool isFavorited;
  final String? aiSummary; // AI 生成的智能摘要
  final String? priority; // 'high' | 'low' (用于教务通知)
  final String? category; // 'domestic' | 'international' | 'tech' (用于新闻)

  Article({
    required this.id,
    required this.title,
    this.summary,
    required this.content,
    required this.source,
    this.sourceUrl,
    this.author,
    this.publishedAt,
    required this.fetchedAt,
    this.tags = const [],
    this.isFavorited = false,
    this.aiSummary,
    this.priority,
    this.category,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'].toString(),
      title: json['title'],
      summary: json['summary'],
      content: json['content'],
      source: json['source'],
      sourceUrl: json['source_url'],
      author: json['author'],
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      fetchedAt: DateTime.parse(json['fetched_at'] ?? DateTime.now().toIso8601String()),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isFavorited: json['is_favorited'] ?? false,
      aiSummary: json['ai_summary'],
      priority: json['priority'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'source': source,
      'source_url': sourceUrl,
      'author': author,
      'published_at': publishedAt?.toIso8601String(),
      'fetched_at': fetchedAt.toIso8601String(),
      'tags': tags,
      'is_favorited': isFavorited,
      'ai_summary': aiSummary,
      'priority': priority,
      'category': category,
    };
  }

  Article copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? source,
    String? sourceUrl,
    String? author,
    DateTime? publishedAt,
    DateTime? fetchedAt,
    List<String>? tags,
    bool? isFavorited,
    String? aiSummary,
    String? priority,
    String? category,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      source: source ?? this.source,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      tags: tags ?? this.tags,
      isFavorited: isFavorited ?? this.isFavorited,
      aiSummary: aiSummary ?? this.aiSummary,
      priority: priority ?? this.priority,
      category: category ?? this.category,
    );
  }
}