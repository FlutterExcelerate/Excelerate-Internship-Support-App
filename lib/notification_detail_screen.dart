import 'package:flutter/material.dart';
import 'theme.dart';
import 'assignment_detail_screen.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String category;
  final String title;
  final String description;

  const NotificationDetailScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
  });

  Color _categoryColor(ColorScheme colorScheme) {
    switch (category) {
      case 'Assignments':
        return colorScheme.error;
      case 'Announcements':
        return colorScheme.secondary;
      case 'Updates':
      default:
        return colorScheme.primary;
    }
  }

  IconData _categoryIcon() {
    switch (category) {
      case 'Assignments':
        return Icons.assignment_late_rounded;
      case 'Announcements':
        return Icons.campaign_rounded;
      case 'Updates':
      default:
        return Icons.celebration_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = _categoryColor(colorScheme);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Notification Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(_categoryIcon(), color: color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: color.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(title, style: textTheme.headlineMedium?.copyWith(fontSize: 22)),
              const SizedBox(height: 12),
              Text(
                description,
                style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              if (category == 'Assignments') ...[
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AssignmentDetailScreen(title: title),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            ),
                            child: Text('View Assignment', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: const Text('Mark as Completed'),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: Text('Mark as Completed', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}