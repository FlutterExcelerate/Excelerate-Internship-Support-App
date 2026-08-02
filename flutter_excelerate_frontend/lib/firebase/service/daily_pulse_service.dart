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

    final now = Timestamp.now();
    final expiresAt = Timestamp.fromDate(
      now.toDate().add(const Duration(hours: 24)),
    );

    await cleanupExpiredPulses(userId: user.uid);

    await _pulses.add({
      'userId': user.uid,
      'mood': mood,
      'moodLabel': moodLabel,
      'reflection': reflection,
      'tags': tags,
      'createdAt': now,
      'expiresAt': expiresAt,
    });
  }

  Stream<List<DailyPulseModel>> pulsesStream({String? userId}) {
    Query<Map<String, dynamic>> query = _pulses;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().asyncMap((snapshot) async {
      final expiredDocs = snapshot.docs.where((doc) {
        final pulse = DailyPulseModel.fromFirestore(doc);
        return pulse.isExpired;
      }).toList();

      if (expiredDocs.isNotEmpty) {
        final batch = _firestore.batch();
        for (final doc in expiredDocs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      final pulses = snapshot.docs
          .map(DailyPulseModel.fromFirestore)
          .where((pulse) => !pulse.isExpired)
          .toList();
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

  Future<void> cleanupExpiredPulses({String? userId}) async {
    Query<Map<String, dynamic>> query = _pulses;

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    final snapshot = await query.get();
    final expiredDocs = snapshot.docs.where((doc) {
      final pulse = DailyPulseModel.fromFirestore(doc);
      return pulse.isExpired;
    }).toList();

    if (expiredDocs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    for (final doc in expiredDocs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
