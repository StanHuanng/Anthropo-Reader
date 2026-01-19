import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/article.dart';
import '../../data/repositories/article_repository.dart';
import '../widgets/article_card.dart';
import '../../../../shared/widgets/theme_toggle_button.dart';
import '../../../../shared/widgets/parchment_background.dart';
import '../../../reader/presentation/pages/reader_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // If Supabase is configured, it will be used. Otherwise, it gracefully falls back to mock data.
  final ArticleRepository _repository = ArticleRepository(useMockData: false);
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Anthropo Reader',
          style: GoogleFonts.frankRuhlLibre(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        actions: [
          ThemeToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: ParchmentBackground(child: _buildBody()),
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
            Text('No articles found', style: TextStyle(color: Colors.grey)),
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
