import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_excelerate_frontend/student/widgets/learnify_widgets.dart';
import 'package:flutter_excelerate_frontend/utils/responsive.dart';
import '../../theme/app_theme.dart';
import 'program_details_screen.dart';
import '../../firebase/models/program_model.dart';
import '../../firebase/service/program_service.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final content = StreamBuilder<List<ProgramModel>>(
      stream: ProgramService.instance.publishedProgramsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final programs = snapshot.data ?? [];
        final publishedPrograms = programs
            .where((program) => program.isPublished)
            .toList();

        return ListView(
          key: const ValueKey('programs'),
          padding: context.pagePadding,
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
            if (publishedPrograms.isEmpty)
              SectionCard(
                child: Text(
                  'No published programs yet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ...publishedPrograms.map(
              (program) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ProgramCard(program: program),
              ),
            ),
          ],
        );
      },
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

  final ProgramModel program;

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
                    const SizedBox(height: 5),
                    Text(
                      program.description,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
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
                color: Color(program.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${program.duration} • ${program.level}'
                  '${program.capacity > 0 ? ' • ${program.capacity} seats' : ''}',
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
          if (program.mentorName.isNotEmpty ||
              program.applicationDeadline.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (program.mentorName.isNotEmpty)
                  Pill(
                    label: program.mentorName,
                    icon: Icons.person_outline_rounded,
                    color: LearnifyColors.info,
                  ),
                if (program.applicationDeadline.isNotEmpty)
                  Pill(
                    label: 'Apply by ${program.applicationDeadline}',
                    icon: Icons.event_outlined,
                    color: LearnifyColors.warning,
                  ),
              ],
            ),
          ],
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
