import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color codeBackgroundColor;
  final TextStyle? codeStyle;

  const MarkdownWidget({
    super.key,
    required this.text,
    this.textStyle,
    required this.codeBackgroundColor,
    this.codeStyle,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: textStyle,
        listBullet: textStyle,
        h1: textStyle?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
        h2: textStyle?.copyWith(fontSize: 22, fontWeight: FontWeight.bold),
        h3: textStyle?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        h4: textStyle?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        h5: textStyle?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        h6: textStyle?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
        em: textStyle?.copyWith(fontStyle: FontStyle.italic),
        strong: textStyle?.copyWith(fontWeight: FontWeight.bold),
        code: codeStyle?.copyWith(backgroundColor: Colors.transparent),
        codeblockDecoration: BoxDecoration(
          color: codeBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        codeblockPadding: const EdgeInsets.all(12.0),
        blockquote: textStyle?.copyWith(
          color: textStyle?.color?.withValues(alpha: 0.8),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: textStyle?.color?.withValues(alpha: 0.3) ?? Colors.grey,
              width: 4,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 4.0,
        ),
      ),
    );
  }
}
