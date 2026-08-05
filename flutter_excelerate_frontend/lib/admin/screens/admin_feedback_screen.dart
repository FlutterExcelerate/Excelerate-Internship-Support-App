import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/admin/widgets/feedback_card.dart';
import '../../firebase/models/feedback_model.dart';
import '../../firebase/service/feedback_service.dart';

class AdminFeedbackScreen extends StatelessWidget {
  const AdminFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FeedbackModel>>(
      stream: FeedbackService.instance.feedbackStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(child: Text(snapshot.error.toString())),
          );
        }
        final feedback = snapshot.data ?? [];
        if (feedback.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text("No feedback received yet.")),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: feedback.length,
          itemBuilder: (context, index) {
            return FeedbackCard(feedback: feedback[index], onTap: () {});
          },
        );
      },
    );
  }
}
