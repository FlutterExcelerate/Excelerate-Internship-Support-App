import 'package:flutter/material.dart';
import 'premium_ai_icon.dart';
import '../context/ai_context_provider.dart';

import '../core/personas/ai_persona.dart';

class AiEmptyState extends StatelessWidget {
  final ValueChanged<String> onSuggestionTap;
  final AiApplicationContext? currentContext;
  final AiPersona persona;

  const AiEmptyState({
    super.key,
    required this.onSuggestionTap,
    required this.persona,
    this.currentContext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // We keep Suggestions from SuggestionEngine if they are dynamic, 
    // but typically we would get them from persona. Let's assume SuggestionEngine handles the list still,
    // or we can move the suggestion list to the Persona too.
    final suggestions = persona.getSuggestions(currentContext);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PremiumAiIcon(size: 64),
              const SizedBox(height: 24),
              Text(
                persona.welcomeTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                persona.welcomeDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: suggestions.map((suggestion) {
                  return _SuggestionChip(
                    text: suggestion,
                    onTap: () => onSuggestionTap(_stripEmoji(suggestion)), 
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _stripEmoji(String text) {
    // Basic heuristic to strip leading emoji + space
    if (text.length > 2 && text.runes.first > 255) {
      return text.substring(text.indexOf(' ') + 1).trim();
    }
    return text;
  }
}

class _SuggestionChip extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.text,
    required this.onTap,
  });

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _isHovered 
                  ? theme.colorScheme.primaryContainer.withValues(alpha: isDark ? 0.3 : 0.8)
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.3 : 0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _isHovered 
                    ? theme.colorScheme.primary.withValues(alpha: 0.5)
                    : theme.colorScheme.outlineVariant.withValues(alpha: isDark ? 0.2 : 0.5),
                width: 1,
              ),
            ),
            child: Text(
              widget.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _isHovered 
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
