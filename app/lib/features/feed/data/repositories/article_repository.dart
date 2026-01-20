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

  Future<List<Article>> fetchArticles({
    String? source,
    int limit = 50,
  }) async {
    // 如果使用模拟数据
    if (useMockData) {
      await Future.delayed(Duration(milliseconds: 800));
      return MockArticleDataSource.getMockArticles();
    }

    // 检查 Supabase 是否已初始化
    if (_supabase == null) {
      print('⚠️ Supabase 未初始化，请检查网络连接和配置');
      if (kDebugMode) {
        throw Exception('Supabase 未初始化');
      }
      return MockArticleDataSource.getMockArticles();
    }

    try {
      // 合并 GitHub 文章和教务通知
      List<Article> allArticles = [];

      // 1. 获取 GitHub Trending 文章
      final githubResponse = await _supabase!
          .from('articles')
          .select()
          .order('published_at', ascending: false)
          .limit(limit);

      allArticles.addAll((githubResponse as List)
          .map((json) => Article.fromJson(json))
          .toList());

      // 2. 获取教务通知
      try {
        final noticesResponse = await _supabase!
            .from('school_notices')
            .select()
            .order('published_at', ascending: false)
            .limit(limit);

        allArticles.addAll((noticesResponse as List)
            .map((json) => Article.fromJson(json))
            .toList());
      } catch (e) {
        print('School notices table may not exist yet: $e');
      }

      // 3. 按发布时间排序（最新的在前）
      allArticles.sort((a, b) {
        if (a.publishedAt == null) return 1;
        if (b.publishedAt == null) return -1;
        return b.publishedAt!.compareTo(a.publishedAt!);
      });

      // 4. 根据 source 参数过滤
      if (source != null) {
        allArticles = allArticles.where((article) => article.source == source).toList();
      }

      // 5. 限制数量
      return allArticles.take(limit).toList();
    } catch (e) {
      print('❌ 数据库查询失败: $e');
      print('Stack trace: ${StackTrace.current}');
      // 开发模式抛出错误，便于调试
      if (kDebugMode) {
        rethrow;
      }
      // 生产模式降级到 Mock 数据
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
