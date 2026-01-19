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

  // 构建来源图标
  Widget _buildSourceIcon(String source, ThemeData theme) {
    if (source == 'github_trending') {
      // GitHub 使用 Emoji
      return Text(
        '🧑‍💻',
        style: TextStyle(fontSize: 18),
      );
    } else if (source == 'SCUT_JW') {
      // 教务处使用 Emoji
      return Text(
        '🏫',
        style: TextStyle(fontSize: 18),
      );
    } else {
      return Icon(
        Icons.article_outlined,
        size: 20,
        color: theme.colorScheme.secondary,
      );
    }
  }

  // 获取来源标签文本
  String _getSourceLabel(String source) {
    switch (source) {
      case 'github_trending':
        return 'GitHub Trending';
      case 'SCUT_JW':
        return '华工教务处';
      default:
        return source;
    }
  }

  // 构建优先级徽章（仅教务通知）
  Widget _buildPriorityBadge(Article article, ThemeData theme) {
    // 检查文章内容是否包含优先级标识
    final content = article.content ?? '';
    final isHighPriority = content.contains('优先级: **HIGH**') ||
                          content.contains('🔴');

    if (!isHighPriority) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(left: 8),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔴',
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(width: 4),
          Text(
            '重要',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

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
              // Source Label with Icon/Emoji
              Row(
                children: [
                  // 来源图标：GitHub 用 SVG，教务处用 Emoji
                  _buildSourceIcon(article.source, theme),
                  SizedBox(width: 8),
                  Text(
                    _getSourceLabel(article.source),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // 优先级标识（仅教务通知）
                  if (article.source == 'SCUT_JW')
                    _buildPriorityBadge(article, theme),
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
