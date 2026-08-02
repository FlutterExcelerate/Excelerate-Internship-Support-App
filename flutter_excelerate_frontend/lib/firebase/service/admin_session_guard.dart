class AdminSessionGuard {
  AdminSessionGuard._();

  static final Set<String> _verifiedAdminUids = <String>{};

  static bool isVerified(String uid) => _verifiedAdminUids.contains(uid);

  static void markVerified(String uid) {
    _verifiedAdminUids.add(uid);
  }

  static void clear() {
    _verifiedAdminUids.clear();
  }
}
