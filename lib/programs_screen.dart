import 'package:flutter/material.dart';
import 'theme.dart';
import 'bottom_nav.dart';
import 'course_analytics_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  int _navIndex = 1; // Programs tab active
  String _selectedCategory = 'Internship';
  final TextEditingController _searchController = TextEditingController();

  static const _categories = ['Internship', 'Course', 'Workspace'];

  static const _courses = [
    _CourseItem(
      icon: Icons.design_services_rounded,
      title: 'Advanced UX Design',
      description: 'Master user-centered design principles and prototyping.',
      tag: 'Course',
      duration: '8 weeks',
      level: 'Intermediate',
      enrolled: true,
    ),
    _CourseItem(
      icon: Icons.code_rounded,
      title: 'Data Structures & Algorithms',
      description: 'Build a strong foundation in core CS concepts.',
      tag: 'Course',
      duration: '10 weeks',
      level: 'Beginner',
      enrolled: true,
    ),
    _CourseItem(
      icon: Icons.business_center_rounded,
      title: 'Product Management Internship',
      description: 'Hands-on experience shipping real product features.',
      tag: 'Internship',
      duration: '12 weeks',
      level: 'Intermediate',
      enrolled: false,
    ),
    _CourseItem(
      icon: Icons.groups_rounded,
      title: 'Remote Team Workspace',
      description: 'Collaborate with a distributed team on live projects.',
      tag: 'Workspace',
      duration: '6 weeks',
      level: 'All levels',
      enrolled: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filtered = _courses.where((c) => c.tag == _selectedCategory).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text('Programs', style: textTheme.headlineLarge?.copyWith(fontSize: 24)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.refresh_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.person_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    hintText: 'Search programs...',
                    hintStyle: AppTextStyles.bodyMd.copyWith(
                      color: colorScheme.outline.withValues(alpha: 0.6),
                    ),
                    prefixIcon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.tune_rounded, color: colorScheme.primary),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        // TODO: open filter options
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Category filter chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isActive = category == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isActive ? AppColors.primaryGradient : null,
                        color: isActive ? null : colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                        border: isActive
                            ? null
                            : Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: AppTextStyles.labelMd.copyWith(
                          color: isActive ? Colors.white : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Course list
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No programs in this category yet.',
                        style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _courseCard(context, filtered[index]),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: LearnifyBottomNav(
          currentIndex: _navIndex,
          onTap: (index) {
            if (index == _navIndex) return;
            if (index == 0) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (index == 2) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MessagesScreen()),
              );
            } else if (index == 3) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _courseCard(BuildContext context, _CourseItem item) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CourseAnalyticsScreen(
              title: item.title,
              description: item.description,
              icon: item.icon,
            ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.tag,
                        style: AppTextStyles.caption.copyWith(color: colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(item.duration, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                    const SizedBox(width: 12),
                    Icon(Icons.bar_chart_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(item.level, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 12),
                if (item.enrolled)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.chevron_right_rounded, color: colorScheme.primary),
                  )
                else
                  SizedBox(
                    height: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        ),
                        child: Text('Enroll', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
                      ),
                    ),
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

class _CourseItem {
  final IconData icon;
  final String title;
  final String description;
  final String tag;
  final String duration;
  final String level;
  final bool enrolled;

  const _CourseItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.tag,
    required this.duration,
    required this.level,
    required this.enrolled,
  });
}