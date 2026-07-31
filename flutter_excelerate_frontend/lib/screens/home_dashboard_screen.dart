import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_excelerate_frontend/screens/profile_screen.dart';
import 'package:intl/intl.dart';

import '../firebase/models/program_model.dart';
import '../firebase/service/program_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProgramModel>>(
      stream: ProgramService.instance.publishedProgramsStream(),
      builder: (context, snapshot) {
        final courses = snapshot.data ?? [];
        final pages = [
          _DashboardTab(
            courses: courses,
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
                  _selectedIndex == 0
                      ? 'Learnify'
                      : _titleForIndex(_selectedIndex),
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
                    transitionBuilder:
                        (child, primaryAnimation, secondaryAnimation) {
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
                bottom: 5,
                child: FloatingGlassNavBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _openTab,
                ),
              ),
            ],
          ),
        );
      },
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

  void _openProgramDetails(BuildContext context, ProgramModel program) {
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

  final List<ProgramModel> courses;
  final ValueChanged<int> onNavigate;
  final ValueChanged<ProgramModel> onTapCourse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deadlines = _ProgramDeadline.fromPrograms(courses);

    return ListView(
      key: const ValueKey('dashboard'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        GlassCard(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const DailyPulseScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
                        Text('Daily Pulse', style: theme.textTheme.titleLarge),
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
          action: deadlines.isEmpty ? 'Programs' : 'View all',
          onTap: () => onNavigate(1),
        ),
        const SizedBox(height: 10),
        if (deadlines.isEmpty)
          SectionCard(
            child: Row(
              children: [
                const IconBadge(
                  icon: Icons.event_available_outlined,
                  color: LearnifyColors.success,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'No upcoming program deadlines yet.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )
        else
          ...deadlines
              .take(3)
              .map(
                (deadline) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DeadlineTile(
                    deadline: deadline,
                    onTap: () => onTapCourse(deadline.program),
                  ),
                ),
              ),
      ],
    );
  }
}

class _ProgramDeadline {
  const _ProgramDeadline({
    required this.program,
    required this.rawDate,
    required this.parsedDate,
  });

  final ProgramModel program;
  final String rawDate;
  final DateTime? parsedDate;

  static List<_ProgramDeadline> fromPrograms(List<ProgramModel> programs) {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final deadlines = programs
        .where((program) => program.applicationDeadline.trim().isNotEmpty)
        .map(
          (program) => _ProgramDeadline(
            program: program,
            rawDate: program.applicationDeadline.trim(),
            parsedDate: _parseDate(program.applicationDeadline.trim()),
          ),
        )
        .where(
          (deadline) =>
              deadline.parsedDate == null ||
              !deadline.parsedDate!.isBefore(startOfToday),
        )
        .toList();

    deadlines.sort((a, b) {
      if (a.parsedDate == null && b.parsedDate == null) {
        return a.program.title.compareTo(b.program.title);
      }
      if (a.parsedDate == null) return 1;
      if (b.parsedDate == null) return -1;
      return a.parsedDate!.compareTo(b.parsedDate!);
    });

    return deadlines;
  }

  static DateTime? _parseDate(String value) {
    final formats = [
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('MM-dd-yyyy'),
      DateFormat('d MMM yyyy'),
      DateFormat('MMM d, yyyy'),
      DateFormat('MMMM d, yyyy'),
    ];

    for (final format in formats) {
      try {
        return format.parseStrict(value);
      } catch (_) {}
    }

    return null;
  }

  String get label {
    final date = parsedDate;
    if (date == null) return rawDate;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(date.year, date.month, date.day);
    final days = dueDate.difference(today).inDays;

    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    if (days < 7) return 'Due in $days days';
    return 'Due ${DateFormat('MMM d, yyyy').format(date)}';
  }
}

class _DeadlineTile extends StatelessWidget {
  const _DeadlineTile({required this.deadline, required this.onTap});

  final _ProgramDeadline deadline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final programColor = Color(deadline.program.color);

    return SectionCard(
      onTap: onTap,
      child: Row(
        children: [
          IconBadge(
            icon: Icons.event_note_outlined,
            color: deadline.parsedDate == null
                ? LearnifyColors.info
                : LearnifyColors.warning,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deadline.label, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(deadline.program.title, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Pill(
                      label: deadline.program.category,
                      icon: Icons.local_offer_outlined,
                      color: programColor,
                    ),
                    if (deadline.program.mentorName.isNotEmpty)
                      Pill(
                        label: deadline.program.mentorName,
                        icon: Icons.person_outline_rounded,
                        color: LearnifyColors.info,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.program, required this.onTap});

  final ProgramModel program;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: onTap,
      child: Row(
        children: [
          Hero(
            tag: 'program_badge_${program.title}',
            child: IconBadge(
              icon: Icons.school_outlined,
              color: Color(program.color),
            ),
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
                  '${program.category} • ${program.duration}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
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
