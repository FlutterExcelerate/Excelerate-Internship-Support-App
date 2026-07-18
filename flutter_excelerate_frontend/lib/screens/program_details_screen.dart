import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/learnify_models.dart';
import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key, required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  titlePadding: const EdgeInsets.only(bottom: 58),
                  title: Text(
                    program.title,
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
                              program.color.withValues(alpha: isDark ? 0.22 : 0.12),
                              theme.colorScheme.secondary.withValues(alpha: isDark ? 0.18 : 0.08),
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
                          color: program.color,
                          size: 140,
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: program.color,
                  labelColor: theme.colorScheme.onSurface,
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
          body: TabBarView(
            children: [
              _OverviewTab(program: program),
              _ModulesTab(program: program),
              _AnalyticsTab(program: program),
              _CertificatesTab(program: program),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(20),
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
                        color: program.color,
                        size: 64,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.title,
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              program.description,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progress', style: theme.textTheme.titleMedium),
                      Text(
                        '${(program.progress * 100).round()}%',
                        style: theme.textTheme.titleMedium?.copyWith(color: program.color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: program.progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(99),
                    color: program.color,
                    backgroundColor: theme.brightness == Brightness.light
                        ? const Color(0xFFE2E8F0)
                        : const Color(0xFF1E293B),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        Feedback.forTap(context);
                      },
                      style: FilledButton.styleFrom(backgroundColor: program.color),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Enroll / Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Feedback.forTap(context);
                },
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Submit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Feedback.forTap(context);
                },
                icon: const Icon(Icons.workspace_premium_outlined),
                label: const Text('Certificate'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ModulesTab extends StatelessWidget {
  const _ModulesTab({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: program.modules.length,
      itemBuilder: (context, index) {
        final module = program.modules[index];
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
                      : program.color,
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
  const _AnalyticsTab({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: MediaQuery.sizeOf(context).width > 640 ? 3 : 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        _MetricCard(
          label: 'Completion',
          value: '${(program.progress * 100).round()}%',
          icon: Icons.insights_rounded,
          color: program.color,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBadge(icon: icon, color: color, size: 44),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _CertificatesTab extends StatelessWidget {
  const _CertificatesTab({required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isReady = program.progress >= 1.0;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (isReady)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFBBF24).withValues(alpha: isDark ? 0.15 : 0.08),
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
                  color: const Color(0xFFFBBF24).withValues(alpha: isDark ? 0.05 : 0.1),
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
                  'Guest Learner',
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
                    color: program.color,
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
                Text(
                  'Certificate Locked',
                  style: theme.textTheme.titleLarge,
                ),
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
                      disabledBackgroundColor: theme.brightness == Brightness.light
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
