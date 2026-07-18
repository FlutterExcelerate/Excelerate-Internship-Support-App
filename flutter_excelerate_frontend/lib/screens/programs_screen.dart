import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../models/learnify_models.dart';
import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';
import 'program_details_screen.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  static const programs = [
    Program(
      title: 'Flutter Accelerator',
      category: 'Course',
      description:
          'Build polished mobile screens with navigation, state, and reusable widgets.',
      duration: '6 weeks',
      level: 'Intermediate',
      progress: 0.4,
      color: LearnifyColors.primary,
      modules: [
        ProgramModule(
          title: 'Module 1: Intro to Topic',
          summary: 'Core patterns, setup, and screen anatomy.',
          duration: '45 min',
          isComplete: true,
        ),
        ProgramModule(
          title: 'Module 2: Navigation',
          summary: 'Route structure and bottom navigation systems.',
          duration: '1 hr',
          isComplete: false,
        ),
        ProgramModule(
          title: 'Module 3: UI Polish',
          summary: 'Cards, spacing, empty states, and responsive behavior.',
          duration: '1.5 hr',
          isComplete: false,
        ),
      ],
    ),
    Program(
      title: 'Internship Readiness',
      category: 'Internship',
      description:
          'Prepare your portfolio, workplace habits, and weekly reflection rituals.',
      duration: '4 weeks',
      level: 'Beginner',
      progress: 0.18,
      color: LearnifyColors.secondary,
      modules: [
        ProgramModule(
          title: 'Portfolio Review',
          summary: 'Shape your project stories for interviews.',
          duration: '40 min',
          isComplete: false,
        ),
        ProgramModule(
          title: 'Workplace Rituals',
          summary: 'Plan check-ins, notes, and weekly status updates.',
          duration: '35 min',
          isComplete: false,
        ),
      ],
    ),
    Program(
      title: 'Workspace Mastery',
      category: 'Workspace',
      description:
          'Manage deadlines, notifications, submissions, and certificates with confidence.',
      duration: '3 weeks',
      level: 'All levels',
      progress: 0.72,
      color: LearnifyColors.success,
      modules: [
        ProgramModule(
          title: 'Deadline Systems',
          summary: 'Create a reliable assignment tracking loop.',
          duration: '30 min',
          isComplete: true,
        ),
        ProgramModule(
          title: 'Completion Evidence',
          summary: 'Submit work and collect certificate proof.',
          duration: '50 min',
          isComplete: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      key: const ValueKey('programs'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search programs...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tune_rounded),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Pill(
              label: 'Internship',
              icon: Icons.work_outline_rounded,
              color: LearnifyColors.secondary,
            ),
            Pill(
              label: 'Course',
              icon: Icons.menu_book_outlined,
              color: LearnifyColors.primary,
            ),
            Pill(
              label: 'Workspace',
              icon: Icons.dashboard_customize_outlined,
              color: LearnifyColors.success,
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...programs.map(
          (program) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ProgramCard(program: program),
          ),
        ),
      ],
    );

    if (!showAppBar) {
      return content;
    }

    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Programs')),
      child: content,
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: () => _openDetails(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: 5),
                    Text(
                      program.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openDetails(context),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Pill(
                label: program.category,
                icon: Icons.local_offer_outlined,
                color: program.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${program.duration} • ${program.level}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              FilledButton.tonal(
                onPressed: () => _openDetails(context),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(64, 38),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Enroll'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context) {
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
