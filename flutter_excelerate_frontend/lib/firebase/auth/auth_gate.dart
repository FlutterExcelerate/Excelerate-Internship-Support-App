import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/admin_access.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/screen/login_screen.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_dashboard_screen.dart';
import 'package:flutter_excelerate_frontend/screens/home_dashboard_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          if (AdminAccess.isAdminEmail(snapshot.data?.email)) {
            return const AdminDashboardScreen();
          }

          return const HomeDashboardScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
