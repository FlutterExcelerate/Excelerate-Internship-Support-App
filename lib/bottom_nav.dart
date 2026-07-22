import 'package:flutter/material.dart';
import 'theme.dart';

/// Shared floating pill-shaped bottom navigation bar
/// used across Home, Programs, Messages, and Profile screens.
class LearnifyBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LearnifyBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.menu_book_rounded, label: 'Programs'),
    _NavItem(icon: Icons.chat_bubble_rounded, label: 'Messages'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurfaceContainerLowest.withValues(alpha: 0.8)
              : AppColors.lightSurfaceContainerLowest.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isActive = index == currentIndex;

            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? colorScheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: isActive
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      item.label,
                      style: AppTextStyles.caption.copyWith(
                        color: isActive
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}