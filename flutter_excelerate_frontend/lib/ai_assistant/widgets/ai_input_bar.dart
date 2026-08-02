import 'package:flutter/material.dart';

class AiInputBar extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final bool isEnabled;

  const AiInputBar({
    super.key,
    required this.onSubmitted,
    this.isEnabled = true,
  });

  @override
  State<AiInputBar> createState() => _AiInputBarState();
}

class _AiInputBarState extends State<AiInputBar> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (_hasText != hasText) {
        setState(() => _hasText = hasText);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.isEnabled) {
      widget.onSubmitted(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              child: IconButton(
                icon: Icon(Icons.add_rounded, color: theme.colorScheme.onSurfaceVariant),
                onPressed: () {},
                tooltip: 'Attach file',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2D35) : const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: _focusNode.hasFocus 
                        ? theme.colorScheme.primary.withValues(alpha: 0.5)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled,
                  textInputAction: TextInputAction.send,
                  minLines: 1,
                  maxLines: 5,
                  onSubmitted: (_) => _submit(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask the AI Assistant...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedScale(
              scale: (_hasText && widget.isEnabled) ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: (_hasText && widget.isEnabled) ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward_rounded, color: theme.colorScheme.onPrimary),
                    onPressed: (_hasText && widget.isEnabled) ? _submit : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


