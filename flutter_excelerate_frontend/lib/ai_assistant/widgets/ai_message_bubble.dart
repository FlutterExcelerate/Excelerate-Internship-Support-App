import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/ai_message.dart';
import 'premium_ai_icon.dart';
import 'markdown_widget.dart';

class AiMessageBubble extends StatelessWidget {
  final AiMessage message;
  final bool isConsecutive;

  const AiMessageBubble({
    super.key,
    required this.message,
    this.isConsecutive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bubbleColor = isUser 
        ? colorScheme.primary 
        : (isDark ? const Color(0xFF2A2D35) : const Color(0xFFF0F2F5));
    final textColor = isUser ? colorScheme.onPrimary : colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 48.0 : 16.0,
        right: isUser ? 16.0 : 48.0,
        top: isConsecutive ? 4.0 : 16.0,
        bottom: 4.0,
      ),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            if (!isConsecutive)
              const PremiumAiIcon(size: 28)
            else
              const SizedBox(width: 28),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(!isUser && isConsecutive ? 8 : 24),
                  topRight: Radius.circular(isUser && isConsecutive ? 8 : 24),
                  bottomLeft: const Radius.circular(24),
                  bottomRight: const Radius.circular(24),
                ).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(24),
                  bottomLeft: !isUser ? const Radius.circular(4) : const Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownWidget(
                    text: message.content,
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      height: 1.6,
                      fontSize: 15,
                    ),
                    codeBackgroundColor: isUser 
                        ? Colors.white.withValues(alpha: 0.2)
                        : (isDark ? Colors.black38 : Colors.grey.shade200),
                    codeStyle: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: textColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: textColor.withValues(alpha: 0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!isUser) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: message.content));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Copied to clipboard'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Icon(
                            Icons.copy_rounded,
                            size: 14,
                            color: textColor.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}


