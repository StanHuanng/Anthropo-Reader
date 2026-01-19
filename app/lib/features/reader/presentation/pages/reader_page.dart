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

              // Markdown Content
              MarkdownRenderer(content: article.content),
            ],
          ),
        ),
      ),
    );
  }
}
