import 'package:flutter/material.dart';
import '../../../../core/models/article.dart';
import '../../../../shared/widgets/parchment_background.dart';
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
              // TODO: Implement toggle favorite
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Favorite toggled (Not implemented)')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: ParchmentBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metadata
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

              // AI Summary (如果存在，优先显示)
              if (article.aiSummary != null && article.aiSummary!.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'AI 智能摘要',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      MarkdownRenderer(content: article.aiSummary!),
                    ],
                  ),
                ),
                Divider(height: 32),
              ],

              // Original Content
              MarkdownRenderer(content: article.content),
            ],
          ),
        ),
      ),
    );
  }
}
