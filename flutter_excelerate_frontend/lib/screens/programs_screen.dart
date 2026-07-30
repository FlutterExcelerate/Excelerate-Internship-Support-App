import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

import '../models/learnify_models.dart';
import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';
import 'program_details_screen.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  

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
