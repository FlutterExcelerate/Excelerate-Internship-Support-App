import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/widgets/learnify_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('profile'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        SectionCard(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: LearnifyColors.primary,
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 46,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Guest Learner',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Learning streak: 6 days',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
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