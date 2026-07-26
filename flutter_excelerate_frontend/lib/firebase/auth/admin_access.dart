class AdminAccess {
  const AdminAccess._();

  static const String _adminEmailsCsv = String.fromEnvironment(
    'ADMIN_EMAILS',
    defaultValue: '',
  );

  static Set<String> get allowedEmails => _adminEmailsCsv
      .split(',')
      .map((email) => email.trim().toLowerCase())
      .where((email) => email.isNotEmpty)
      .toSet();

  static bool get hasConfiguredAdmins => allowedEmails.isNotEmpty;

  static bool isAdminEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return false;
    }

    return allowedEmails.contains(email.trim().toLowerCase());
  }
}
