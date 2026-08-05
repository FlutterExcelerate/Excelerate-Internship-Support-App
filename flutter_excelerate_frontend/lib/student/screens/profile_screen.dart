import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excelerate_frontend/firebase/models/app_user.dart';
import 'package:flutter_excelerate_frontend/firebase/service/repository.dart';
import 'package:flutter_excelerate_frontend/firebase/service/user_service.dart';
import 'package:flutter_excelerate_frontend/student/screens/feedback_screen.dart';
import 'package:flutter_excelerate_frontend/theme/app_theme.dart';
import 'package:flutter_excelerate_frontend/student/widgets/learnify_widgets.dart';
import 'package:flutter_excelerate_frontend/utils/responsive.dart';

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
          padding: context.pagePadding,
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
                  ResponsiveActionRow(
                    children: [
                      OutlinedButton.icon(
                        onPressed: appUser == null
                            ? null
                            : () => _showEditProfileDialog(context, appUser),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Profile'),
                      ),
                      FilledButton.icon(
                        onPressed: () async => repository.signOut(),
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _ProfileInfoCard(appUser: appUser),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FeedbackScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return SharedAxisTransition(
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.scaled,
                            child: child,
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              icon: const Icon(Icons.feedback_outlined),
              label: const Text('FeedBack'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditProfileDialog(
    BuildContext context,
    AppUser appUser,
  ) async {
    final updated = await showDialog<AppUser>(
      context: context,
      builder: (context) => _EditProfileDialog(appUser: appUser),
    );

    if (updated == null) return;
    await UserService.instance.updateUserProfile(updated);
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.appUser});

  final AppUser appUser;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cohortController;
  late final TextEditingController _locationController;
  late final TextEditingController _headlineController;
  late final TextEditingController _skillsController;

  @override
  void initState() {
    super.initState();
    final user = widget.appUser;
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    _cohortController = TextEditingController(text: user.cohort);
    _locationController = TextEditingController(text: user.location);
    _headlineController = TextEditingController(text: user.headline);
    _skillsController = TextEditingController(text: user.skills.join(', '));
  }

  @override
  void dispose() {
    disposeTextControllersAfterFrame([
      _nameController,
      _phoneController,
      _cohortController,
      _locationController,
      _headlineController,
      _skillsController,
    ]);
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop(
      widget.appUser.copyWith(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        cohort: _cohortController.text.trim(),
        location: _locationController.text.trim(),
        headline: _headlineController.text.trim(),
        skills: _skillsController.text
            .split(',')
            .map((skill) => skill.trim())
            .where((skill) => skill.isNotEmpty)
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LearnifyDialogShell(
      title: 'Edit Profile',
      subtitle: 'Keep your learner details useful and up to date.',
      icon: Icons.person_outline_rounded,
      color: LearnifyColors.primary,
      primaryLabel: 'Save',
      onPrimaryPressed: _save,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LearnifyDialogField(
            controller: _nameController,
            label: 'Full name',
            icon: Icons.person_outline_rounded,
          ),
          LearnifyDialogField(
            controller: _phoneController,
            label: 'Phone',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          LearnifyDialogField(
            controller: _cohortController,
            label: 'Cohort',
            icon: Icons.groups_outlined,
          ),
          LearnifyDialogField(
            controller: _locationController,
            label: 'Location',
            icon: Icons.location_on_outlined,
          ),
          LearnifyDialogField(
            controller: _headlineController,
            label: 'Headline',
            icon: Icons.short_text_rounded,
            maxLines: 2,
          ),
          LearnifyDialogField(
            controller: _skillsController,
            label: 'Skills, comma separated',
            icon: Icons.auto_awesome_outlined,
          ),
        ],
      ),
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
