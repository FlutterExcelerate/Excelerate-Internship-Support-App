import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/app_user.dart';
import 'package:flutter_excelerate_frontend/firebase/models/user_role.dart';
import 'package:flutter_excelerate_frontend/firebase/screen/login_screen.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_dashboard_screen.dart';
import 'package:flutter_excelerate_frontend/admin/screens/admin_verification_screen.dart';
import 'package:flutter_excelerate_frontend/firebase/service/admin_session_guard.dart';
import 'package:flutter_excelerate_frontend/firebase/service/user_service.dart';
import 'package:flutter_excelerate_frontend/student/screens/home_dashboard_screen.dart';

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

        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        final uid = snapshot.data!.uid;
        return StreamBuilder<AppUser?>(
          stream: UserService.instance.userStream(uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (userSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Database Error: ${userSnapshot.error}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => FirebaseAuth.instance.signOut(),
                          child: const Text("Sign Out"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            if (!userSnapshot.hasData) {
              UserService.instance.createUserIfNotExists(snapshot.data!);

              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text("Setting up user profile..."),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: const Text("Sign Out"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final appUser = userSnapshot.data!;

            if (appUser.role == UserRole.admin.name) {
              if (!AdminSessionGuard.isVerified(uid)) {
                return AdminVerificationScreen(uid: uid);
              }

              return const AdminDashboardScreen();
            }

            return const HomeDashboardScreen();
          },
        );
      },
    );
  }
}
