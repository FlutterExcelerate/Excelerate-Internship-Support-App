import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/student/widgets/learnify_widgets.dart';

import '../../firebase/models/feedback_model.dart';
import '../../theme/app_theme.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key, required this.feedback, required this.onTap});

  final FeedbackModel feedback;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SectionCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: LearnifyColors.primary.withOpacity(.15),
                  child: Text(
                    feedback.userName.isEmpty
                        ? "?"
                        : feedback.userName[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.userName,
                        style: theme.textTheme.titleMedium,
                      ),

                      Text(
                        feedback.userEmail,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            const SizedBox(height: 8),

            //--------------------------------------------------
            // Message
            //--------------------------------------------------
            Text(
              feedback.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            //--------------------------------------------------
            // Footer
            //--------------------------------------------------
            Row(
              children: [
                Pill(
                  label: feedback.category,
                  icon: Icons.category_outlined,
                  color: LearnifyColors.info,
                ),

                const SizedBox(width: 10),

                Pill(
                  label: _formatDate(feedback.createdAt.toDate()),
                  icon: Icons.schedule,
                  color: LearnifyColors.secondary,
                ),

                const Spacer(),

                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
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
