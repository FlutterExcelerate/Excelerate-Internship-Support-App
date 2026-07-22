import 'package:flutter/material.dart';
import 'theme.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final String title;
  final String courseName;
  final bool initiallySubmitted;

  const AssignmentDetailScreen({
    super.key,
    this.title = 'Final Case Study Submission',
    this.courseName = 'Advanced UX Design',
    this.initiallySubmitted = false,
  });

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  late bool _submitted;

  @override
  void initState() {
    super.initState();
    _submitted = widget.initiallySubmitted;
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      'Assignment Details',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(fontSize: 18, color: colorScheme.primary),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: colorScheme.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (_submitted ? colorScheme.primary : colorScheme.error).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: (_submitted ? colorScheme.primary : colorScheme.error).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _submitted ? Icons.check_circle_rounded : Icons.schedule_rounded,
                            size: 16,
                            color: _submitted ? colorScheme.primary : colorScheme.error,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _submitted ? 'Submitted' : 'Due Tomorrow, 11:59 PM',
                            style: AppTextStyles.labelMd.copyWith(color: _submitted ? colorScheme.primary : colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(widget.title, style: textTheme.headlineLarge?.copyWith(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      widget.courseName,
                      style: AppTextStyles.labelMd.copyWith(color: colorScheme.secondary, letterSpacing: 1),
                    ),
                    const SizedBox(height: 20),
                    // Metadata grid
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.6,
                        children: [
                          _metaTile(context, icon: Icons.grade_rounded, label: 'Points', value: '100 pts', color: colorScheme.tertiary),
                          _metaTile(context, icon: Icons.upload_file_rounded, label: 'Submission Type', value: 'File Upload', color: colorScheme.secondary),
                          _metaTile(context, icon: Icons.history_rounded, label: 'Attempts Allowed', value: '2', color: colorScheme.primary),
                          _metaTile(context, icon: Icons.check_box_outline_blank_rounded, label: 'Attempts Used', value: _submitted ? '1' : '0', color: colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Description
                    _sectionHeader(context, 'Description', colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'For this final assignment, synthesize all the research, wireframing, and testing phases of your semester project into a comprehensive UX Case Study. Clearly articulate the problem statement, user personas, and the iterative journey that led to your high-fidelity solution.',
                      style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Include visual documentation of your design system, accessibility audits, and a summary of usability testing results. Submit as a single PDF or a link to a published portfolio project.',
                      style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    // Attachments
                    _sectionHeader(context, 'Attachments', colorScheme.secondary),
                    const SizedBox(height: 12),
                    _attachmentRow(context, icon: Icons.picture_as_pdf_rounded, name: 'Assignment_Brief.pdf', meta: '2.4 MB', color: colorScheme.primary),
                    const SizedBox(height: 10),
                    _attachmentRow(context, icon: Icons.analytics_rounded, name: 'Grading_Rubric.pdf', meta: '840 KB', color: colorScheme.secondary),
                    const SizedBox(height: 24),
                    // Your Submission
                    _sectionHeader(context, 'Your Submission', colorScheme.tertiary),
                    const SizedBox(height: 12),
                    _submitted ? _submittedCard(context) : _emptySubmissionCard(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: _submitted
                ? ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.check_circle_rounded, color: colorScheme.onSurfaceVariant),
                    label: Text('Submitted', style: AppTextStyles.labelMd.copyWith(color: colorScheme.onSurfaceVariant)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                  )
                : ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
                      disabledBackgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    child: Text('Submit Assignment', style: AppTextStyles.labelMd.copyWith(color: colorScheme.onSurfaceVariant)),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String label, Color accent) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(999))),
        const SizedBox(width: 10),
        Text(label, style: textTheme.headlineMedium?.copyWith(fontSize: 17)),
      ],
    );
  }

  Widget _metaTile(BuildContext context, {required IconData icon, required String label, required String value, required Color color}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(value, style: AppTextStyles.labelMd),
          ],
        ),
      ],
    );
  }

  Widget _attachmentRow(BuildContext context, {required IconData icon, required String name, required String meta, required Color color}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.labelMd.copyWith(fontSize: 14)),
                    Text(meta, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.download_rounded, color: colorScheme.onSurfaceVariant, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptySubmissionCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, shape: BoxShape.circle),
            child: Icon(Icons.cloud_upload_rounded, color: colorScheme.outline, size: 30),
          ),
          const SizedBox(height: 16),
          Text('No file uploaded yet', style: AppTextStyles.labelMd),
          const SizedBox(height: 4),
          Text('Supported formats: PDF, ZIP, PNG', style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(999)),
              child: ElevatedButton(
                onPressed: () => setState(() => _submitted = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: Text('Upload Submission', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _submittedCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
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
                decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.article_rounded, color: colorScheme.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Case_Study_Final.pdf', style: AppTextStyles.labelMd),
                    Text('4.8 MB • Submitted 2 hours ago', style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _submitted = false),
              icon: Icon(Icons.history_rounded, color: colorScheme.primary, size: 18),
              label: Text('Resubmit', style: AppTextStyles.labelMd.copyWith(color: colorScheme.primary)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}