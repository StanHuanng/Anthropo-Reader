import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/article.dart';
import '../../../../config/supabase_config.dart';
import '../datasources/mock_datasource.dart';

class ArticleRepository {
  final SupabaseClient? _supabase;
  final bool useMockData;

  ArticleRepository({this.useMockData = false})
      : _supabase = SupabaseConfig.isConfigured
          ? Supabase.instance.client
          : null;

  /// 获取聚合文章列表
  /// [source] 可选，指定来源（'github_trending', 'SCUT_JW' 等）
  Future<List<Article>> fetchArticles({
    String? source,
    int limit = 50,
  }) async {
    // 1. Mock 数据处理
    if (useMockData || _supabase == null) {
      if (_supabase == null && kDebugMode) {
        print('⚠️ Supabase 未初始化，返回 Mock 数据');
      }
      return MockArticleDataSource.getMockArticles();
    }

    try {
      List<Article> allArticles = [];
      List<Future<List<Article>>> queries = [];

      // 2. 根据 source 决定查询哪些表
      // 如果 source 为空，或者是 'github_trending'，则查询 articles 表
      if (source == null || source == 'github_trending') {
        queries.add(_fetchFromTable('articles', limit));
      }

      // 如果 source 为空，或者是 'SCUT_JW'，则查询 school_notices 表
      if (source == null || source == 'SCUT_JW') {
        queries.add(_fetchFromTable('school_notices', limit));
      }

      // 如果 source 为空，或者 source 不是上述两者（即新闻类），则查询 news 表
      if (source == null || (source != 'github_trending' && source != 'SCUT_JW')) {
        queries.add(_fetchFromTable('news', limit));
      }

      // 3. 并行执行查询
      final results = await Future.wait(queries);
      for (var list in results) {
        allArticles.addAll(list);
      }

      // 4. 内存排序：按发布时间倒序
      allArticles.sort((a, b) {
        if (a.publishedAt == null) return 1;
        if (b.publishedAt == null) return -1;
        return b.publishedAt!.compareTo(a.publishedAt!);
      });

      // 5. 如果指定了具体 source，进行精确过滤 (去除非目标数据)
      if (source != null) {
        allArticles = allArticles.where((article) => article.source == source).toList();
      }

      return allArticles.take(limit).toList();
    } catch (e) {
      print('❌ 数据库查询失败: $e');
      if (kDebugMode) rethrow;
      return MockArticleDataSource.getMockArticles();
    }
  }

  /// 专门获取新闻（支持分类）
  Future<List<Article>> fetchNews({
    String? category,
    int limit = 50,
  }) async {
    if (useMockData || _supabase == null) return [];

    try {
      // Step 1: Start query
      PostgrestFilterBuilder query = _supabase!.from('news').select();

      // Step 2: Apply filters
      if (category != null && category != 'all') {
        query = query.eq('category', category);
      }

      // Step 3: Apply sorting and limit
      final response = await query
          .order('published_at', ascending: false)
          .limit(limit);

      return (response as List).map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  /// 辅助方法：通用表查询
  Future<List<Article>> _fetchFromTable(String tableName, int limit) async {
    try {
      final response = await _supabase!
          .from(tableName)
          .select()
          .order('published_at', ascending: false)
          .limit(limit);

      return (response as List).map((json) => Article.fromJson(json)).toList();
    } catch (e) {
      // 在多表查询中，如果某个表不存在（例如 news 表还没建好），我们不希望整个查询失败
      print('⚠️ 查询表 $tableName 失败 (可能表不存在): $e');
      return [];
    }
  }

  Future<Article?> fetchArticleById(String id) async {
    // 注意：目前 fetchArticleById 主要用于 articles 表
    // 如果需要支持多表，这里需要重构，或者传入表名参数
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
      // 暂时只支持 articles 表的收藏
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
