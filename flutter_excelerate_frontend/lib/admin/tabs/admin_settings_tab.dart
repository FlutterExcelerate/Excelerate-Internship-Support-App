import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../firebase/models/app_user.dart';
import '../../firebase/models/program_model.dart';
import '../../firebase/service/repository.dart';
import '../../student/widgets/learnify_widgets.dart';
import '../../theme/app_theme.dart';

class AdminSettingsTab extends StatelessWidget {
  const AdminSettingsTab({
    super.key,
    required this.users,
    required this.programs,
  });

  final List<AppUser> users;
  final List<ProgramModel> programs;

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthRepository.instance.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final totalStudents = users.where((u) => u.role == 'student').length;
    final activeStudents = users
        .where((u) => u.role == 'student' && u.isActive)
        .length;
    final totalAdmins = users.where((u) => u.role == 'admin').length;
    final publishedPrograms = programs.where((p) => p.isPublished).length;
    final draftPrograms = programs.where((p) => !p.isPublished).length;

    return ListView(
      key: const ValueKey('admin-settings'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
      children: [
        _ProfileCard(
          email: currentUser?.email ?? '—',
          name: currentUser?.displayName ?? 'Admin',
          photoUrl: currentUser?.photoURL,
          isDark: isDark,
        ),
        const SizedBox(height: 14),

        _SectionHeader(
          icon: Icons.bar_chart_rounded,
          title: 'Platform Overview',
          color: LearnifyColors.primary,
        ),
        const SizedBox(height: 10),
        _StatsGrid(
          items: [
            _StatItem(
              label: 'Total Students',
              value: '$totalStudents',
              icon: Icons.school_rounded,
              color: LearnifyColors.primary,
            ),
            _StatItem(
              label: 'Active Students',
              value: '$activeStudents',
              icon: Icons.check_circle_outline_rounded,
              color: LearnifyColors.success,
            ),
            _StatItem(
              label: 'Admin Users',
              value: '$totalAdmins',
              icon: Icons.admin_panel_settings_outlined,
              color: LearnifyColors.secondary,
            ),
            _StatItem(
              label: 'Programs',
              value: '${programs.length}',
              icon: Icons.grid_view_rounded,
              color: LearnifyColors.info,
            ),
            _StatItem(
              label: 'Published',
              value: '$publishedPrograms',
              icon: Icons.public_rounded,
              color: LearnifyColors.success,
            ),
            _StatItem(
              label: 'Drafts',
              value: '$draftPrograms',
              icon: Icons.drafts_outlined,
              color: LearnifyColors.wellness,
            ),
          ],
        ),
        const SizedBox(height: 14),

        _SectionHeader(
          icon: Icons.lock_outline_rounded,
          title: 'Access & Security',
          color: LearnifyColors.secondary,
        ),
        const SizedBox(height: 10),
        SectionCard(
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.fingerprint_rounded,
                iconColor: LearnifyColors.secondary,
                title: 'Authentication',
                subtitle: 'Google Sign-In (OAuth 2.0)',
                trailing: _StatusBadge(
                  label: 'Active',
                  color: LearnifyColors.success,
                ),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.cloud_done_outlined,
                iconColor: LearnifyColors.primary,
                title: 'Data Storage',
                subtitle: 'Cloud Firestore (Firebase)',
                trailing: _StatusBadge(
                  label: 'Connected',
                  color: LearnifyColors.success,
                ),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.manage_accounts_outlined,
                iconColor: LearnifyColors.info,
                title: 'Role-Based Access',
                subtitle: 'Admin & Student roles enforced',
                trailing: _StatusBadge(
                  label: 'Enabled',
                  color: LearnifyColors.success,
                ),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.security_rounded,
                iconColor: LearnifyColors.wellness,
                title: 'Firestore Rules',
                subtitle:
                    'Protect sensitive collections with server-side rules',
                trailing: _StatusBadge(
                  label: 'Review',
                  color: LearnifyColors.wellness,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _SectionHeader(
          icon: Icons.info_outline_rounded,
          title: 'App Information',
          color: LearnifyColors.info,
        ),
        const SizedBox(height: 10),
        SectionCard(
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.rocket_launch_outlined,
                iconColor: LearnifyColors.info,
                title: 'App Name',
                subtitle: 'Excelerate Internship Platform',
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.tag_rounded,
                iconColor: LearnifyColors.primary,
                title: 'Version',
                subtitle: '1.0.0 (Build 1)',
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.devices_rounded,
                iconColor: LearnifyColors.secondary,
                title: 'Platform',
                subtitle: 'Flutter · Firebase · Gemini AI',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _SectionHeader(
          icon: Icons.warning_amber_rounded,
          title: 'Danger Zone',
          color: LearnifyColors.warning,
        ),
        const SizedBox(height: 10),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsTile(
                icon: Icons.logout_rounded,
                iconColor: LearnifyColors.warning,
                title: 'Sign Out',
                subtitle: 'Sign out of the admin panel',
                onTap: () => AuthRepository.instance.signOut(),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: LearnifyColors.warning,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Excelerate Admin Panel · Built with Flutter & Firebase',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: LearnifyColors.mutedLight.withValues(alpha: 0.6),
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.isDark,
  });

  final String email;
  final String name;
  final String? photoUrl;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Row(
        children: [
          _Avatar(photoUrl: photoUrl, name: name),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: email));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email copied'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          email,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.copy_rounded,
                        size: 12,
                        color: theme.colorScheme.primary.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Pill(
            label: 'Admin',
            icon: Icons.workspace_premium_outlined,
            color: LearnifyColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl, required this.name});
  final String? photoUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'A';
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [LearnifyColors.secondary, LearnifyColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: photoUrl != null
          ? ClipOval(
              child: Image.network(
                photoUrl!,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 7),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.items});
  final List<_StatItem> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.95,
      children: items,
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? LearnifyColors.surfaceDark
            : LearnifyColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? LearnifyColors.borderDark
              : LearnifyColors.borderLight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: theme.textTheme.titleLarge?.color,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyMedium?.color,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tile = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 1),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: tile,
      );
    }
    return tile;
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? LearnifyColors.borderDark : LearnifyColors.borderLight,
    );
  }
}
