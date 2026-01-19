import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownRenderer extends StatelessWidget {
  final String content;

  const MarkdownRenderer({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Markdown(
      data: content,
      selectable: true,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      styleSheet: MarkdownStyleSheet(
        // Paragraphs
        p: GoogleFonts.lora(
          fontSize: 18,
          height: 1.7,
          color: theme.textTheme.bodyLarge?.color,
        ),

        // Headings - Using Frank Ruhl Libre (Claude style)
        h1: GoogleFonts.frankRuhlLibre(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.headlineLarge?.color,
        ),
        h2: GoogleFonts.frankRuhlLibre(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.headlineMedium?.color,
        ),
        h3: GoogleFonts.frankRuhlLibre(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.headlineSmall?.color,
        ),

        // Code
        code: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          backgroundColor: isDark ? Color(0xFF1E1E1E) : Color(0xFFF5F5F5),
        ),
        codeblockDecoration: BoxDecoration(
          color: isDark ? Color(0xFF1A1A1A) : Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Color(0xFF2A2A2A) : Color(0xFFE8E6E1),
          ),
        ),
        codeblockPadding: EdgeInsets.all(16),

        // Quotes
        blockquote: GoogleFonts.lora(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.colorScheme.primary,
              width: 4,
            ),
          ),
        ),

        // Links
        a: TextStyle(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
        ),

        // Lists
        listBullet: GoogleFonts.lora(
          fontSize: 18,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href));
        }
      },
    );
  }
}
