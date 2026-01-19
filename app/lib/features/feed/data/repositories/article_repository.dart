import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/article.dart';
import '../../../../config/supabase_config.dart';
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
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 800));
      return MockArticleDataSource.getMockArticles();
    }

    try {
      var query = _supabase!
          .from('articles')
          .select();

      if (source != null) {
        query = query.eq('source', source);
      }

      final response = await query
          .order('published_at', ascending: false)
          .limit(limit);

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
