import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/screens/profile_screen.dart';

import '../models/learnify_models.dart';
import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';
import 'daily_pulse_screen.dart';
import 'notifications_screen.dart';
import 'programs_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedIndex = 0;

  final _courses = const [
    CourseSummary(
      title: 'UX Foundations',
      subtitle: '4 of 10 modules complete',
      progress: 0.42,
      icon: Icons.palette_outlined,
      accent: LearnifyColors.secondary,
    ),
    CourseSummary(
      title: 'Flutter Sprint',
      subtitle: 'Next: Navigation patterns',
      progress: 0.68,
      icon: Icons.phone_iphone_rounded,
      accent: LearnifyColors.primary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardTab(courses: _courses, onNavigate: _openTab),
      const ProgramsScreen(showAppBar: false),
      const NotificationsScreen(showAppBar: false),
      const ProfileTab(),
    ];

    return ResponsiveScaffold(
      appBar: AppBar(
        leadingWidth: 0,
        title: Row(
          children: [
            const Icon(Icons.school_rounded, color: LearnifyColors.primary),
            const SizedBox(width: 8),
            Text(
              _selectedIndex == 0 ? 'Learnify' : _titleForIndex(_selectedIndex),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _openTab(2),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () => _openTab(3),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _openTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Programs',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outline_rounded),
            selectedIcon: Icon(Icons.mail_rounded),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: pages[_selectedIndex],
      ),
    );
  }

  String _titleForIndex(int index) => switch (index) {
    1 => 'Programs',
    2 => 'Messages',
    3 => 'Profile',
    _ => 'Learnify',
  };

  void _openTab(int index) => setState(() => _selectedIndex = index);
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({required this.courses, required this.onNavigate});

  final List<CourseSummary> courses;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        SectionCard(
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const DailyPulseScreen())),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const IconBadge(
                    icon: Icons.favorite_rounded,
                    color: LearnifyColors.wellness,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Pulse',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Log your reflection',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Start'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Wrap(
                spacing: 8,
                children: [
                  Pill(
                    label: '#Work',
                    icon: Icons.work_outline_rounded,
                    color: LearnifyColors.primary,
                  ),
                  Pill(
                    label: '#Mission',
                    icon: Icons.flag_outlined,
                    color: LearnifyColors.secondary,
                  ),
                  Pill(
                    label: '#Success',
                    icon: Icons.bolt_rounded,
                    color: LearnifyColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'My Courses',
          action: 'View all',
          onTap: () => onNavigate(1),
        ),
        const SizedBox(height: 10),
        ...courses.map(
          (course) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CourseTile(course: course, onTap: () => onNavigate(1)),
          ),
        ),
        const SizedBox(height: 8),
        _SectionHeader(
          title: 'Upcoming Deadlines',
          action: 'Open',
          onTap: () => onNavigate(2),
        ),
        const SizedBox(height: 10),
        SectionCard(
          child: Row(
            children: [
              const IconBadge(
                icon: Icons.assignment_late_outlined,
                color: LearnifyColors.warning,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assignment Due Tomorrow',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Flutter Sprint - Navigation patterns',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ],
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.course, required this.onTap});

  final CourseSummary course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: onTap,
      child: Row(
        children: [
          IconBadge(icon: course.icon, color: course.accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  course.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: course.progress,
                  borderRadius: BorderRadius.circular(99),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
