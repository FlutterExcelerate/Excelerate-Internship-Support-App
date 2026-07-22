import 'package:flutter/material.dart';
import 'theme.dart';

class CourseDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final double progress;

  const CourseDetailScreen({
    super.key,
    this.title = 'Advanced UX Design',
    this.description = 'Master user-centered design principles and prototyping.',
    this.progress = 0.65,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isFavorite = false;

  static const _modules = [
    _ModuleItem(number: 1, title: 'Foundations of UX', description: 'Core principles and terminology', duration: '45 min', status: _ModuleStatus.completed),
    _ModuleItem(number: 2, title: 'User Research Methods', description: 'Interviews, surveys, and testing', duration: '1h 10min', status: _ModuleStatus.completed),
    _ModuleItem(number: 3, title: 'Wireframing & Prototyping', description: 'Low to high-fidelity design', duration: '1h 30min', status: _ModuleStatus.inProgress),
    _ModuleItem(number: 4, title: 'Usability Testing', description: 'Validate designs with real users', duration: '50 min', status: _ModuleStatus.locked),
    _ModuleItem(number: 5, title: 'Design Systems', description: 'Scalable component libraries', duration: '1h 05min', status: _ModuleStatus.locked),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: textTheme.headlineMedium?.copyWith(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isFavorite ? colorScheme.error : colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                  ),
                ],
              ),
            ),
            // Tab bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              labelStyle: AppTextStyles.labelMd,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Modules'),
                Tab(text: 'Analytics'),
                Tab(text: 'Certificates'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _overviewTab(context),
                  _modulesTab(context),
                  _analyticsTab(context),
                  _certificatesTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.design_services_rounded, color: colorScheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(widget.title, style: textTheme.headlineMedium?.copyWith(fontSize: 18)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.description,
                  style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: widget.progress,
                    minHeight: 10,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(widget.progress * 100).toInt()}%', style: AppTextStyles.labelMd),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(999),
              ),
              child: ElevatedButton(
                onPressed: () => _tabController.animateTo(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text('Continue', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _tabController.animateTo(1),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _tabController.animateTo(3),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  child: const Text('Certificate'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modulesTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _modules.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final module = _modules[index];
        final isLocked = module.status == _ModuleStatus.locked;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text('${module.number}', style: AppTextStyles.labelMd.copyWith(color: colorScheme.primary)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: AppTextStyles.bodyLg.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isLocked ? colorScheme.onSurfaceVariant : null,
                      ),
                    ),
                    Text(module.description, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text(module.duration, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(
                module.status == _ModuleStatus.completed
                    ? Icons.check_circle_rounded
                    : module.status == _ModuleStatus.inProgress
                        ? Icons.play_circle_fill_rounded
                        : Icons.lock_rounded,
                color: module.status == _ModuleStatus.completed
                    ? colorScheme.primary
                    : module.status == _ModuleStatus.inProgress
                        ? colorScheme.secondary
                        : colorScheme.outline,
                size: 26,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _analyticsTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _statCard(context, icon: Icons.donut_large_rounded, label: 'Completion', value: '65%', color: colorScheme.primary),
        _statCard(context, icon: Icons.assignment_turned_in_rounded, label: 'Assignments', value: '5/8', color: colorScheme.secondary),
        _statCard(context, icon: Icons.schedule_rounded, label: 'Study Time', value: '18h', color: colorScheme.tertiary),
        _statCard(context, icon: Icons.local_fire_department_rounded, label: 'Streak', value: '6 days', color: colorScheme.error),
      ],
    );
  }

  Widget _statCard(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.headlineMd.copyWith(fontSize: 22)),
          Text(label, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _certificatesTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool unlocked = widget.progress >= 1.0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: unlocked
                    ? AppColors.primaryGradient
                    : LinearGradient(colors: [
                        colorScheme.surfaceContainerHighest,
                        colorScheme.surfaceContainerHigh,
                      ]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                unlocked ? Icons.workspace_premium_rounded : Icons.lock_rounded,
                color: unlocked ? Colors.white : colorScheme.outline,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              unlocked ? 'Certificate Unlocked' : 'Certificate Locked',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              unlocked
                  ? 'Congratulations on completing the course!'
                  : 'Complete all modules and assignments to unlock your certificate.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            if (unlocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
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
                          child: Text('Add to Portfolio', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      child: const Text('Download'),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  child: const Text('Complete Course to Unlock'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _ModuleStatus { completed, inProgress, locked }

class _ModuleItem {
  final int number;
  final String title;
  final String description;
  final String duration;
  final _ModuleStatus status;

  const _ModuleItem({
    required this.number,
    required this.title,
    required this.description,
    required this.duration,
    required this.status,
  });
}