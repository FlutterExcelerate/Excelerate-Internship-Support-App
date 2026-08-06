import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/app_user.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../firebase/models/module_model.dart';
import '../../firebase/models/program_model.dart';
import '../../firebase/service/module_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';
import '../widgets/learnify_widgets.dart';
import '../../firebase/service/user_service.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key, required this.program});

  final ProgramModel program;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final programColor = Color(program.color);

    return DefaultTabController(
      length: 4,
      child: ResponsiveScaffold(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 180.0,
                pinned: true,
                floating: false,
                backgroundColor: theme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Feedback.forTap(context);
                    },
                    icon: const Icon(Icons.favorite_border_rounded),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(
                    bottom: 58,
                    left: 32,
                    right: 32,
                  ),
                  title: Text(
                    program.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              programColor.withValues(
                                alpha: isDark ? 0.22 : 0.12,
                              ),
                              theme.colorScheme.secondary.withValues(
                                alpha: isDark ? 0.18 : 0.08,
                              ),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -30,
                        top: -30,
                        child: IconBadge(
                          icon: Icons.school_rounded,
                          color: programColor,
                          size: 140,
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: programColor,
                  labelColor: theme.colorScheme.onSurface,
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Modules'),
                    Tab(text: 'Analytics'),
                    Tab(text: 'Certificates'),
                  ],
                ),
              ),
            ];
          },
          body: FutureBuilder<AppUser?>(
            future: UserService.instance.getUser(
              FirebaseAuth.instance.currentUser!.uid,
            ),
            builder: (context, userSnapshot) {
              final appUser = userSnapshot.data;
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return StreamBuilder<List<ModuleModel>>(
                stream: ModuleService.instance.modulesStream(program.id),
                builder: (context, snapshot) {
                  final modules = snapshot.data ?? [];

                  final progress = modules.isEmpty
                      ? 0.0
                      : modules.where((m) => m.isComplete).length /
                            modules.length;

                  return TabBarView(
                    children: [
                      _OverviewTab(
                        program: program,
                        modules: modules,
                        progress: progress,
                        user: appUser,
                      ),

                      _ModulesTab(program: program, modules: modules),

                      _AnalyticsTab(program: program, progress: progress),

                      _CertificatesTab(program: program, progress: progress),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.program,
    required this.modules,
    required this.progress,
    required this.user,
  });

  final ProgramModel program;
  final List<ModuleModel> modules;
  final double progress;
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final programColor = Color(program.color);

    return ListView(
      padding: context.pagePadding,
      children: [
        Hero(
          tag: 'program_hero_${program.title}',
          child: Material(
            type: MaterialType.transparency,
            child: SectionCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconBadge(
                        icon: Icons.school_outlined,
                        color: programColor,
                        size: 64,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          program.title,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(program.description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progress', style: theme.textTheme.titleMedium),
                      Text(
                        '${(progress * 100).round()}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: programColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(99),
                    color: programColor,
                    backgroundColor: theme.brightness == Brightness.light
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Pill(
                        label: program.level,
                        icon: Icons.trending_up_rounded,
                        color: programColor,
                      ),
                      Pill(
                        label: program.duration,
                        icon: Icons.schedule_outlined,
                        color: LearnifyColors.info,
                      ),
                      if (program.capacity > 0)
                        Pill(
                          label: '${program.capacity} seats',
                          icon: Icons.event_seat_outlined,
                          color: LearnifyColors.secondary,
                        ),
                      Pill(
                        label: program.isPublished ? 'Published' : 'Draft',
                        icon: program.isPublished
                            ? Icons.public_rounded
                            : Icons.drafts_outlined,
                        color: program.isPublished
                            ? LearnifyColors.success
                            : LearnifyColors.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (user?.role == "student")
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Feedback.forTap(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: programColor,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text("Enroll / Continue"),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ResponsiveActionRow(
          children: [
            if (user?.role == "student")
              OutlinedButton.icon(
                onPressed: () {
                  Feedback.forTap(context);
                },
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Submit'),
              ),
            if (user?.role == "student")
              OutlinedButton.icon(
                onPressed: () {
                  Feedback.forTap(context);
                },
                icon: const Icon(Icons.workspace_premium_outlined),
                label: const Text('Certificate'),
              ),
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Program Details', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.person_outline_rounded,
                label: 'Mentor',
                value: program.mentorName.isEmpty
                    ? 'To be assigned'
                    : program.mentorName,
              ),
              _DetailRow(
                icon: Icons.mail_outline_rounded,
                label: 'Contact',
                value: program.mentorEmail.isEmpty
                    ? 'Not added'
                    : program.mentorEmail,
              ),
              _DetailRow(
                icon: Icons.event_outlined,
                label: 'Deadline',
                value: program.applicationDeadline.isEmpty
                    ? 'Rolling admission'
                    : program.applicationDeadline,
              ),
              _DetailRow(
                icon: Icons.calendar_month_outlined,
                label: 'Schedule',
                value: program.schedule.isEmpty ? 'Flexible' : program.schedule,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (program.outcomes.isNotEmpty)
          _BulletCard(
            title: 'Outcomes',
            icon: Icons.flag_outlined,
            color: LearnifyColors.success,
            items: program.outcomes,
          ),
        if (program.prerequisites.isNotEmpty) ...[
          const SizedBox(height: 14),
          _BulletCard(
            title: 'Prerequisites',
            icon: Icons.fact_check_outlined,
            color: LearnifyColors.secondary,
            items: program.prerequisites,
          ),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: LearnifyColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletCard extends StatelessWidget {
  const _BulletCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(icon: icon, color: color, size: 42),
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded, size: 18, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModulesTab extends StatelessWidget {
  const _ModulesTab({required this.program, required this.modules});

  final ProgramModel program;
  final List<ModuleModel> modules;

  @override
  Widget build(BuildContext context) {
    if (modules.isEmpty) {
      return const Center(child: Text('No modules added yet.'));
    }

    final programColor = Color(program.color);

    return ListView.builder(
      padding: context.pagePadding,
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SectionCard(
            child: Row(
              children: [
                IconBadge(
                  icon: module.isComplete
                      ? Icons.check_circle_rounded
                      : Icons.play_circle_outline_rounded,
                  color: module.isComplete
                      ? LearnifyColors.success
                      : programColor,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        module.summary,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        module.duration,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? LearnifyColors.mutedDark
                              : LearnifyColors.mutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab({required this.program, required this.progress});

  final ProgramModel program;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final programColor = Color(program.color);

    return GridView.count(
      padding: context.pagePadding,
      crossAxisCount: context.gridCrossAxisCount.clamp(2, 4),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: [
        _MetricCard(
          label: 'Completion',
          value: '${(progress * 100).round()}%',
          icon: Icons.insights_rounded,
          color: programColor,
        ),
        const _MetricCard(
          label: 'Assignments',
          value: '3/5',
          icon: Icons.assignment_outlined,
          color: LearnifyColors.secondary,
        ),
        const _MetricCard(
          label: 'Study Time',
          value: '12h',
          icon: Icons.timer_outlined,
          color: LearnifyColors.success,
        ),
        const _MetricCard(
          label: 'Streak',
          value: '6 days',
          icon: Icons.local_fire_department_outlined,
          color: LearnifyColors.wellness,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconBadge(icon: icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _CertificatesTab extends StatelessWidget {
  const _CertificatesTab({required this.program, required this.progress});

  final ProgramModel program;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isReady = progress >= 1.0;
    final programColor = Color(program.color);

    return ListView(
      padding: context.pagePadding,
      children: [
        if (isReady)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(
                    0xFFFBBF24,
                  ).withValues(alpha: isDark ? 0.15 : 0.08),
                  const Color(0xFFD97706).withValues(alpha: isDark ? 0.2 : 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFFFBBF24,
                  ).withValues(alpha: isDark ? 0.05 : 0.1),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFD97706),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'CERTIFICATE OF COMPLETION',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD97706),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This certifies that',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Learner',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'has successfully mastered',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  program.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: programColor,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Feedback.forTap(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Download Certificate (PDF)'),
                  ),
                ),
              ],
            ),
          )
        else
          SectionCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                IconBadge(
                  icon: Icons.lock_outline_rounded,
                  color: theme.brightness == Brightness.light
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                  size: 72,
                ),
                const SizedBox(height: 18),
                Text('Certificate Locked', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Complete all modules and assignments in ${program.title} to unlock your certificate.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: null,
                    style: FilledButton.styleFrom(
                      disabledBackgroundColor:
                          theme.brightness == Brightness.light
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF1E293B),
                    ),
                    child: const Text('Complete Course to Unlock'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
