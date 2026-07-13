import 'package:flutter/material.dart';

import '../models/learnify_models.dart';
import '../theme/app_theme.dart';
import '../widgets/learnify_widgets.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key, required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: ResponsiveScaffold(
        appBar: AppBar(
          title: const Text('Program Details'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border_rounded),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Modules'),
              Tab(text: 'Analytics'),
              Tab(text: 'Certificates'),
            ],
          ),
        ),
        child: TabBarView(
          children: [
            _OverviewTab(program: program),
            _ModulesTab(program: program),
            _AnalyticsTab(program: program),
            _CertificatesTab(program: program),
          ],
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
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SectionCard(
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
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          program.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Progress', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                '${(program.progress * 100).round()}%',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: program.progress,
                minHeight: 9,
                borderRadius: BorderRadius.circular(99),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Enroll / Continue'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Submit'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
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
                          color: LearnifyColors.muted,
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
          color: LearnifyColors.warning,
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
    final isReady = program.progress >= 1;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SectionCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              IconBadge(
                icon: Icons.workspace_premium_rounded,
                color: isReady
                    ? LearnifyColors.success
                    : LearnifyColors.warning,
                size: 72,
              ),
              const SizedBox(height: 18),
              Text(
                isReady ? 'Certificate unlocked' : 'Certificate in progress',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                isReady
                    ? 'Download your certificate for ${program.title}.'
                    : 'Complete all modules and assignments to unlock your certificate.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isReady ? () {} : null,
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download Certificate'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
