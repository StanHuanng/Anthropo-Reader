import 'package:flutter/material.dart';
import '../../../../core/models/article.dart';
import '../../../../core/utils/date_formatter.dart';

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
              // Source Label
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

              // Title
              Text(
                article.title,
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // Summary
              if (article.summary != null && article.summary!.isNotEmpty)
                Text(
                  article.summary!,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(height: 12),

              // Tags and Author
              Row(
                children: [
                  // Tags
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

                  // Author
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
