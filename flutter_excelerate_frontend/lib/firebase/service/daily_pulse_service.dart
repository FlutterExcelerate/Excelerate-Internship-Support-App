import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/daily_pulse_model.dart';

class DailyPulseService {
  DailyPulseService._();

  static final DailyPulseService instance = DailyPulseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _pulses =>
      _firestore.collection('daily_pulses');

  Future<void> addPulse({
    required int mood,
    required String moodLabel,
    required String reflection,
    required List<String> tags,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is logged in.');
    }

    await _pulses.add({
      'userId': user.uid,
      'mood': mood,
      'moodLabel': moodLabel,
      'reflection': reflection,
      'tags': tags,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<DailyPulseModel>> pulsesStream({String? userId}) {
    Query<Map<String, dynamic>> query = _pulses;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().map((snapshot) {
      final pulses = snapshot.docs.map(DailyPulseModel.fromFirestore).toList();
      pulses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return pulses;
    });
  }

  Stream<List<DailyPulseModel>> currentUserPulsesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return pulsesStream(userId: user.uid);
  }
}
