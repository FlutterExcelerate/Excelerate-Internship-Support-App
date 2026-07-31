import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/app_user.dart';
import 'package:flutter_excelerate_frontend/firebase/service/repository.dart';
import 'package:flutter_excelerate_frontend/firebase/service/user_service.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/widgets/learnify_widgets.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthRepository repository = AuthRepository.instance;
    if (user == null) {
      return const Center(child: Text('No user signed in.'));
    }

    return StreamBuilder<AppUser?>(
      stream: UserService.instance.userStream(user.uid),
      builder: (context, snapshot) {
        final appUser = snapshot.data;

        return ListView(
          key: const ValueKey('profile'),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            SectionCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: LearnifyColors.primary,
                    backgroundImage:
                        (user.photoURL != null && user.photoURL!.isNotEmpty)
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: (user.photoURL == null || user.photoURL!.isEmpty)
                        ? const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 46,
                          )
                        : null,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    appUser?.name.isNotEmpty == true
                        ? appUser!.name
                        : user.displayName ?? 'Student Learner',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.email ?? 'student@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (appUser?.headline.isNotEmpty == true) ...[
                    const SizedBox(height: 8),
                    Text(
                      appUser!.headline,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      Pill(
                        label: appUser?.cohort.isNotEmpty == true
                            ? appUser!.cohort
                            : 'Cohort pending',
                        icon: Icons.groups_outlined,
                        color: LearnifyColors.secondary,
                      ),
                      Pill(
                        label: appUser?.location.isNotEmpty == true
                            ? appUser!.location
                            : 'Location pending',
                        icon: Icons.location_on_outlined,
                        color: LearnifyColors.info,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: appUser == null
                              ? null
                              : () => _showEditProfileDialog(context, appUser),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Profile'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async => repository.signOut(),
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileInfoCard(appUser: appUser),
          ],
        );
      },
    );
  }

  Future<void> _showEditProfileDialog(
    BuildContext context,
    AppUser appUser,
  ) async {
    final nameController = TextEditingController(text: appUser.name);
    final phoneController = TextEditingController(text: appUser.phone);
    final cohortController = TextEditingController(text: appUser.cohort);
    final locationController = TextEditingController(text: appUser.location);
    final headlineController = TextEditingController(text: appUser.headline);
    final skillsController = TextEditingController(
      text: appUser.skills.join(', '),
    );

    final updated = await showDialog<AppUser>(
      context: context,
      builder: (context) => LearnifyDialogShell(
        title: 'Edit Profile',
        subtitle: 'Keep your learner details useful and up to date.',
        icon: Icons.person_outline_rounded,
        color: LearnifyColors.primary,
        primaryLabel: 'Save',
        onPrimaryPressed: () {
          Navigator.of(context).pop(
            appUser.copyWith(
              name: nameController.text.trim(),
              phone: phoneController.text.trim(),
              cohort: cohortController.text.trim(),
              location: locationController.text.trim(),
              headline: headlineController.text.trim(),
              skills: skillsController.text
                  .split(',')
                  .map((skill) => skill.trim())
                  .where((skill) => skill.isNotEmpty)
                  .toList(),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField(
              nameController,
              'Full name',
              Icons.person_outline_rounded,
            ),
            _dialogField(
              phoneController,
              'Phone',
              Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            _dialogField(cohortController, 'Cohort', Icons.groups_outlined),
            _dialogField(
              locationController,
              'Location',
              Icons.location_on_outlined,
            ),
            _dialogField(
              headlineController,
              'Headline',
              Icons.short_text_rounded,
              maxLines: 2,
            ),
            _dialogField(
              skillsController,
              'Skills, comma separated',
              Icons.auto_awesome_outlined,
            ),
          ],
        ),
      ),
    );

    nameController.dispose();
    phoneController.dispose();
    cohortController.dispose();
    locationController.dispose();
    headlineController.dispose();
    skillsController.dispose();

    if (updated == null) return;
    await UserService.instance.updateUserProfile(updated);
  }

  Widget _dialogField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return LearnifyDialogField(
      controller: controller,
      label: label,
      icon: icon,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.appUser});

  final AppUser? appUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final skills = appUser?.skills ?? const [];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile Details', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: appUser?.phone.isNotEmpty == true
                ? appUser!.phone
                : 'Not added',
          ),
          _InfoRow(
            icon: Icons.badge_outlined,
            label: 'Role',
            value: appUser?.role ?? 'student',
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.isEmpty
                ? const [
                    Pill(
                      label: 'No skills yet',
                      icon: Icons.auto_awesome_outlined,
                      color: LearnifyColors.mutedLight,
                    ),
                  ]
                : skills
                      .map(
                        (skill) => Pill(
                          label: skill,
                          icon: Icons.auto_awesome_outlined,
                          color: LearnifyColors.success,
                        ),
                      )
                      .toList(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: LearnifyColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(value, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
