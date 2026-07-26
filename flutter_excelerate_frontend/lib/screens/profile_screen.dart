import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/auth/service/repository.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/widgets/learnify_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthRepository repository = AuthRepository.instance;
    return ListView(
      key: const ValueKey('profile'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        SectionCard(
          child: Column(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: LearnifyColors.primary,
                backgroundImage:
                    (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: (user?.photoURL == null || user!.photoURL!.isEmpty)
                    ? const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 46,
                      )
                    : null,
              ),
              const SizedBox(height: 14),
              Text(
                user?.displayName ?? 'Student Learner',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                user?.email ?? 'student@example.com',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'Learning streak: 6 days',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async {
                    await repository.signOut();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
