import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback_model.dart';

class FeedbackService {
  FeedbackService._();

  static final FeedbackService instance = FeedbackService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _feedback =>
      _firestore.collection('feedback');

  Future<void> addFeedback({required FeedbackModel feedback}) async {
    await _feedback.add(feedback.toFirestore());
  }

  Stream<List<FeedbackModel>> feedbackStream() {
    return _feedback
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(FeedbackModel.fromFirestore).toList(),
        );
  }

  Stream<List<FeedbackModel>> userFeedbackStream(String uid) {
    return _feedback
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(FeedbackModel.fromFirestore).toList(),
        );
  }

  Future<void> updateStatus({
    required String feedbackId,
    required String status,
  }) async {
    await _feedback.doc(feedbackId).update({'status': status});
  }

  Future<void> deleteFeedback({required String feedbackId}) async {
    await _feedback.doc(feedbackId).delete();
  }
}
