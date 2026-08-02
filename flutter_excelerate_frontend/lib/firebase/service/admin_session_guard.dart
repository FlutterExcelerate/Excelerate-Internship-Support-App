import 'package:shared_preferences/shared_preferences.dart';

class AdminSessionGuard {
  AdminSessionGuard._();

  static late SharedPreferences _pref;

  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static bool isVerified(String uid) {
    final timestamp = _pref.getInt('admin_verified_$uid');
    if (timestamp == null) return false;

    final savedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    if (now.difference(savedDate).inDays > 30) {
      _pref.remove('admin_verified_$uid');
      return false;
    }

    return true;
  }

  static Future<void> markVerified(String uid) async {
    await _pref.setInt(
      'admin_verified_$uid',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<void> clear(String uid) async {
    await _pref.remove('admin_verified_$uid');
  }
}
