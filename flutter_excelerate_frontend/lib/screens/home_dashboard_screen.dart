import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_excelerate_frontend/screens/profile_screen.dart';

import '../models/learnify_models.dart';
import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';
import 'daily_pulse_screen.dart';
import 'notifications_screen.dart';
import 'programs_screen.dart';
import 'program_details_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedIndex = 0;
  int _previousIndex = 0;

  final _courses = [
    ProgramsScreen.programs[0],
    ProgramsScreen.programs[2],
  ];

  @override
  Widget build(BuildContext context) {

    final pages = [
      _DashboardTab(
        courses: _courses, 
        onNavigate: _openTab,
        onTapCourse: (program) => _openProgramDetails(context, program),
      ),
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
          const ThemeToggleButton(),
          const SizedBox(width: 8),
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
      child: Stack(
        children: [
          Positioned.fill(
            child: GradientBlobBackground(
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 350),
                reverse: _selectedIndex < _previousIndex,
                transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                  return SharedAxisTransition(
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                    fillColor: Colors.transparent,
                    child: child,
                  );
                },
                child: pages[_selectedIndex],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: FloatingGlassNavBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _openTab,
            ),
          ),
        ],
      ),
    );
  }

  String _titleForIndex(int index) => switch (index) {
    1 => 'Programs',
    2 => 'Messages',
    3 => 'Profile',
    _ => 'Learnify',
  };

  void _openTab(int index) {
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  void _openProgramDetails(BuildContext context, Program program) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProgramDetailsScreen(program: program),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({
    required this.courses, 
    required this.onNavigate,
    required this.onTapCourse,
  });

  final List<Program> courses;
  final ValueChanged<int> onNavigate;
  final ValueChanged<Program> onTapCourse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      key: const ValueKey('dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        GlassCard(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const DailyPulseScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.scaled,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          ),
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
                          style: theme.textTheme.titleLarge,
                        ),
                        Text(
                          'Log your reflection',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(64, 38),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
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
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'My Courses',
          action: 'View all',
          onTap: () => onNavigate(1),
        ),
        const SizedBox(height: 10),
        ...courses.map(
          (course) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CourseTile(
              program: course, 
              onTap: () => onTapCourse(course),
            ),
          ),
        ),
        const SizedBox(height: 14),
        _SectionHeader(
          title: 'Upcoming Deadlines',
          action: 'Open',
          onTap: () => onNavigate(2),
        ),
        const SizedBox(height: 10),
        SectionCard(
          onTap: () => onNavigate(2),
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
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      'Flutter Sprint - Navigation patterns',
                      style: theme.textTheme.bodyMedium,
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
  const _CourseTile({required this.program, required this.onTap});

  final Program program;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: onTap,
      child: Row(
        children: [
          Hero(
            tag: 'program_badge_${program.title}',
            child: IconBadge(icon: Icons.school_outlined, color: program.color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(program.progress * 100).round()}% complete • ${program.duration}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          CircularProgressRing(
            progress: program.progress,
            color: program.color,
            size: 44,
            strokeWidth: 4.0,
          ),
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
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
