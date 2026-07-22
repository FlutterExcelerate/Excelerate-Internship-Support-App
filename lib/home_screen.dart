import 'package:flutter/material.dart';
import 'theme.dart';
import 'bottom_nav.dart';
import 'daily_pulse_screen.dart';
import 'programs_screen.dart';
import 'course_detail_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.school_rounded, color: colorScheme.primary, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    'Learnify',
                    style: textTheme.headlineLarge?.copyWith(
                      fontSize: 24,
                      color: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Refreshed'), duration: Duration(seconds: 1)),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MessagesScreen()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                    onPressed: () {
                      themeModeNotifier.value =
                          isDark ? ThemeMode.light : ThemeMode.dark;
                    },
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Daily Pulse card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.favorite_rounded, color: colorScheme.primary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Daily Pulse', style: textTheme.headlineMedium?.copyWith(fontSize: 20)),
                                    Text(
                                      'Log your reflection',
                                      style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const DailyPulseScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ).copyWith(
                                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    child: Text(
                                      'Start',
                                      style: AppTextStyles.labelMd.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              _tagChip('#Work', colorScheme.secondary),
                              _tagChip('#Mission', colorScheme.tertiary),
                              _tagChip('#Success', colorScheme.primary),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // My Courses section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('My Courses', style: textTheme.headlineMedium?.copyWith(fontSize: 20)),
                        TextButton(
                          onPressed: () {},
                          child: Text('View all', style: AppTextStyles.labelMd.copyWith(color: colorScheme.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _courseCard(
                      context,
                      title: 'Advanced UX Design',
                      subtitle: '4 weeks remaining',
                      progress: 0.65,
                      icon: Icons.menu_book_rounded,
                      metaLabel: 'Module 3/8',
                    ),
                    const SizedBox(height: 12),
                    _courseCard(
                      context,
                      title: 'Data Structures',
                      subtitle: '2 weeks remaining',
                      progress: 0.50,
                      icon: Icons.code_rounded,
                      metaLabel: 'Project Phase',
                    ),
                    const SizedBox(height: 24),
                    // Upcoming Deadlines
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Upcoming Deadlines', style: textTheme.headlineMedium?.copyWith(fontSize: 20)),
                        TextButton(
                          onPressed: () {},
                          child: Text('Open', style: AppTextStyles.labelMd.copyWith(color: colorScheme.primary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          left: BorderSide(color: colorScheme.error, width: 4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.assignment_late_rounded, color: colorScheme.error, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Final Case Study Submission',
                                  style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Advanced UX Design • Due Tomorrow, 11:59 PM',
                                  style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: LearnifyBottomNav(
          currentIndex: _navIndex,
          onTap: (index) async {
            setState(() => _navIndex = index);
            if (index == 1) {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProgramsScreen()),
              );
              if (mounted) setState(() => _navIndex = 0);
            } else if (index == 2) {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MessagesScreen()),
              );
              if (mounted) setState(() => _navIndex = 0);
            } else if (index == 3) {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              if (mounted) setState(() => _navIndex = 0);
            }
          },
        ),
      ),
    );
  }

  Widget _tagChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: color)),
    );
  }

  Widget _courseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double progress,
    required IconData icon,
    required String metaLabel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CourseDetailScreen(title: title, progress: progress),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(metaLabel, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 6,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTextStyles.labelMd,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}