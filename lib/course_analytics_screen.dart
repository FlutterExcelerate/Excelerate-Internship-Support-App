import 'package:flutter/material.dart';
import 'theme.dart';

class CourseAnalyticsScreen extends StatefulWidget {
  final String title;
  final String badge;
  final String description;
  final IconData icon;
  final String instructor;
  final int moduleCount;
  final double progress;
  final String currentModuleLabel;

  const CourseAnalyticsScreen({
    super.key,
    this.title = 'Mastering UI Architecture',
    this.badge = 'Advanced Track',
    this.description = 'Dive deep into component-driven design and systematic scaling.',
    this.icon = Icons.design_services_rounded,
    this.instructor = 'Elena Rossi',
    this.moduleCount = 12,
    this.progress = 0.75,
    this.currentModuleLabel = 'Module 9: Creating Depth with Tonal Layering',
  });

  @override
  State<CourseAnalyticsScreen> createState() => _CourseAnalyticsScreenState();
}

class _CourseAnalyticsScreenState extends State<CourseAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _weekLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _weekHours = [2.0, 3.5, 5.0, 2.5, 1.0, 4.0, 0.5];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
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
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Icon(Icons.school_rounded, color: colorScheme.primary, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    'Learnify',
                    style: textTheme.headlineMedium?.copyWith(fontSize: 18, color: colorScheme.primary),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: colorScheme.onSurfaceVariant),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course header card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(widget.icon, color: Colors.white, size: 36),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    widget.badge,
                                    style: AppTextStyles.caption.copyWith(color: colorScheme.secondary),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(widget.title, style: textTheme.headlineMedium?.copyWith(fontSize: 20)),
                                const SizedBox(height: 6),
                                Text(
                                  widget.description,
                                  style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tabs
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: colorScheme.primary,
                      unselectedLabelColor: colorScheme.onSurfaceVariant,
                      indicatorColor: colorScheme.primary,
                      labelStyle: AppTextStyles.labelMd,
                      tabAlignment: TabAlignment.start,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Analytics'),
                        Tab(text: 'Materials'),
                        Tab(text: 'Discussions'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 640,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _overviewTab(context),
                          _analyticsTab(context),
                          _materialsTab(context),
                          _discussionsTab(context),
                        ],
                      ),
                    ),
                  ],
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner (gradient placeholder instead of network image)
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: 0.0), Colors.black.withValues(alpha: 0.55)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Center(child: Icon(widget.icon, color: Colors.white.withValues(alpha: 0.3), size: 72)),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _pillTag(context, 'UI/UX', Colors.white),
                          const SizedBox(width: 8),
                          _pillTag(context, 'Advanced', Colors.white),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.title,
                        style: textTheme.headlineMedium?.copyWith(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Course summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                      ),
                      child: Icon(widget.icon, color: colorScheme.primary, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Course Overview', style: textTheme.headlineMedium?.copyWith(fontSize: 17)),
                          Text(
                            'Instructor: ${widget.instructor} • ${widget.moduleCount} Modules',
                            style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.description,
                  style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Progress card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Your Progress', style: textTheme.headlineMedium?.copyWith(fontSize: 17)),
                    ShaderMask(
                      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                      child: Text(
                        '${(widget.progress * 100).toInt()}%',
                        style: AppTextStyles.headlineMd.copyWith(fontSize: 32, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: widget.progress,
                    minHeight: 10,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.currentModuleLabel,
                  style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _tabController.animateTo(2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                      label: Text('Continue Learning', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              Expanded(child: _actionButton(context, icon: Icons.upload_file_rounded, label: 'Submit Work', onTap: () {})),
              const SizedBox(width: 14),
              Expanded(child: _actionButton(context, icon: Icons.workspace_premium_rounded, label: 'Certificate', enabled: false, onTap: () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillTag(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white)),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Material(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Icon(icon, color: colorScheme.primary, size: 22),
                const SizedBox(height: 8),
                Text(label, style: AppTextStyles.labelMd.copyWith(color: colorScheme.primary)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _analyticsTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Progress', style: textTheme.headlineMedium?.copyWith(fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Last updated 2h ago',
                  style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.25,
            children: [
              _statCard(context, icon: Icons.donut_large_rounded, label: 'Completion', value: '68', unit: '%', color: colorScheme.primary, trend: '+12%'),
              _statCard(context, icon: Icons.description_rounded, label: 'Assignments', value: '8', unit: '/10', color: colorScheme.secondary),
              _statCard(context, icon: Icons.schedule_rounded, label: 'Study Time', value: '12.5', unit: 'h', color: colorScheme.tertiary, trend: '+2.5h'),
              _statCard(context, icon: Icons.local_fire_department_rounded, label: 'Active Streak', value: '7', unit: 'd', color: colorScheme.error),
            ],
          ),
          const SizedBox(height: 20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bar_chart_rounded, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text('Weekly Engagement', style: textTheme.headlineMedium?.copyWith(fontSize: 16)),
                      ],
                    ),
                    Text('View Details', style: AppTextStyles.labelMd.copyWith(color: colorScheme.primary)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_weekHours.length, (i) {
                      final isPeak = _weekHours[i] == _weekHours.reduce((a, b) => a > b ? a : b);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 22,
                            height: (_weekHours[i] / 5.0) * 130,
                            decoration: BoxDecoration(
                              color: isPeak ? colorScheme.primary : colorScheme.surfaceContainerHigh,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                              border: isPeak ? Border.all(color: colorScheme.primary) : null,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _weekLabels
                      .map((d) => SizedBox(
                            width: 22,
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _materialsTab(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final documents = [
      _MaterialItem(icon: Icons.description_rounded, name: 'Syllabus.pdf', meta: '2.4 MB • Updated 2 days ago', color: colorScheme.primary),
      _MaterialItem(icon: Icons.article_rounded, name: 'Reading List.docx', meta: '842 KB • Updated Oct 12', color: colorScheme.primary),
    ];

    final links = [
      _MaterialItem(icon: Icons.token_rounded, name: 'Figma Community File', meta: 'Design System Boilerplate & Component Library', color: colorScheme.secondary),
      _MaterialItem(icon: Icons.menu_book_rounded, name: 'UI Design Guidelines', meta: 'Industry standards and accessibility documentation', color: colorScheme.secondary),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                ),
                child: Icon(Icons.folder_open_rounded, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Course Documents', style: textTheme.headlineMedium?.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          ...documents.map((d) => _materialCard(context, d)),
          const SizedBox(height: 28),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.2)),
                ),
                child: Icon(Icons.link_rounded, color: colorScheme.secondary, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Reference Links', style: textTheme.headlineMedium?.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          ...links.map((l) => _materialCard(context, l, isLink: true)),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'More materials being added as the course progresses',
              style: AppTextStyles.caption.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _materialCard(BuildContext context, _MaterialItem item, {bool isLink = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppTextStyles.labelMd.copyWith(fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(item.meta, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Icon(
                  isLink ? Icons.chevron_right_rounded : Icons.download_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _discussionsTab(BuildContext context) {
    final threads = [
      _DiscussionItem(
        initials: 'AR',
        author: 'Alex Rivera',
        timestamp: '2 hours ago',
        title: 'Struggling with Module 3: Advanced State Management?',
        preview: "Finding the section on Redux sagas a bit overwhelming — any resources for visualizing the worker/watcher pattern?",
        replies: 3,
        likes: 12,
      ),
      _DiscussionItem(
        initials: 'JV',
        author: 'Prof. Julian Vance',
        timestamp: '5 hours ago',
        title: 'Weekly Project Feedback Thread - Week 4',
        preview: "Post your progress on the final project here! Reviewing submissions all weekend with direct UX feedback.",
        replies: 24,
        likes: 89,
        pinned: true,
      ),
      _DiscussionItem(
        initials: 'SJ',
        author: 'Sami J.',
        timestamp: '1 day ago',
        title: 'Dark Mode vs Light Mode: Accessibility Trends',
        preview: "Curious what people think — pure black backgrounds versus dark grey for high-contrast OLED displays?",
        replies: 15,
        likes: 42,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(999),
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text('Start a Discussion', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...threads.map((t) => _discussionCard(context, t)),
        ],
      ),
    );
  }

  Widget _discussionCard(BuildContext context, _DiscussionItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.pinned
              ? colorScheme.tertiary.withValues(alpha: 0.5)
              : colorScheme.outlineVariant.withValues(alpha: 0.25),
          width: item.pinned ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.pinned)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.push_pin_rounded, color: colorScheme.tertiary, size: 14),
                  const SizedBox(width: 4),
                  Text('Pinned', style: AppTextStyles.caption.copyWith(color: colorScheme.tertiary)),
                ],
              ),
            ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Text(item.initials, style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.author, style: AppTextStyles.labelMd),
                    Text(item.timestamp, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.more_horiz_rounded, color: colorScheme.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.title, style: textTheme.headlineMedium?.copyWith(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            item.preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${item.replies} replies', style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(width: 14),
                  Icon(Icons.favorite_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${item.likes}', style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text('Join', style: AppTextStyles.labelMd.copyWith(color: colorScheme.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
    String? trend,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    trend,
                    style: AppTextStyles.caption.copyWith(color: colorScheme.tertiary),
                  ),
                ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTextStyles.headlineMd.copyWith(fontSize: 26, color: colorScheme.onSurface),
                ),
                TextSpan(
                  text: unit,
                  style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

class _MaterialItem {
  final IconData icon;
  final String name;
  final String meta;
  final Color color;

  const _MaterialItem({required this.icon, required this.name, required this.meta, required this.color});
}

class _DiscussionItem {
  final String initials;
  final String author;
  final String timestamp;
  final String title;
  final String preview;
  final int replies;
  final int likes;
  final bool pinned;

  const _DiscussionItem({
    required this.initials,
    required this.author,
    required this.timestamp,
    required this.title,
    required this.preview,
    required this.replies,
    required this.likes,
    this.pinned = false,
  });
}