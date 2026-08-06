import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/student/widgets/learnify_widgets.dart';

import '../../firebase/models/feedback_model.dart';
import '../../theme/app_theme.dart';

class FeedbackCard extends StatefulWidget {
  const FeedbackCard({super.key, required this.feedback, required this.onTap});

  final FeedbackModel feedback;
  final VoidCallback onTap;

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final feedback = widget.feedback;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SectionCard(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: LearnifyColors.primary.withOpacity(.15),
                  child: Text(
                    widget.feedback.userName.isEmpty
                        ? "?"
                        : widget.feedback.userName[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.feedback.userName,
                        style: theme.textTheme.titleMedium,
                      ),

                      Text(
                        widget.feedback.userEmail,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: _expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Text(
                      feedback.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    secondChild: Text(
                      feedback.message,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  if (feedback.message.length > 180)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Text(_expanded ? "Read less" : "Read more"),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Pill(
                  label: widget.feedback.category,
                  icon: Icons.category_outlined,
                  color: LearnifyColors.info,
                ),

                const SizedBox(width: 10),

                Pill(
                  label: _formatDate(widget.feedback.createdAt.toDate()),
                  icon: Icons.schedule,
                  color: LearnifyColors.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return "Just now";
    }

    if (diff.inHours < 1) {
      return "${diff.inMinutes} min";
    }

    if (diff.inDays < 1) {
      return "${diff.inHours} h";
    }

    if (diff.inDays == 1) {
      return "Yesterday";
    }

    return "${diff.inDays} days";
  }
}
