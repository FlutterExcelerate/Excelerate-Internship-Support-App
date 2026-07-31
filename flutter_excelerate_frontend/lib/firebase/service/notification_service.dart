import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection('notifications');

  Future<void> addNotification({
    required NotificationModel notification,
  }) async {
    await _notifications.add(notification.toFirestore());
  }

  Stream<List<NotificationModel>> notificationsStream() {
    return _notifications
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(NotificationModel.fromFirestore).toList(),
        );
  }

  Future<void> updateNotification({
    required NotificationModel notification,
  }) async {
    await _notifications
        .doc(notification.id)
        .update(notification.toFirestore());
  }

  Future<void> deleteNotification({required String notificationId}) async {
    await _notifications.doc(notificationId).delete();
  }
}
