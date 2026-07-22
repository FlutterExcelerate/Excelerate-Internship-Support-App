import 'package:flutter/material.dart';
import 'theme.dart';
import 'bottom_nav.dart';
import 'programs_screen.dart';
import 'messages_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _navIndex = 3; // Profile tab active
  bool _notificationsEnabled = true;

  static const _stats = [
    _StatItem(icon: Icons.school_rounded, label: 'Courses', value: '4'),
    _StatItem(icon: Icons.workspace_premium_rounded, label: 'Certificates', value: '1'),
    _StatItem(icon: Icons.local_fire_department_rounded, label: 'Streak', value: '6d'),
  ];

  static const _menuItems = [
    _MenuItem(icon: Icons.person_outline_rounded, label: 'Edit Profile'),
    _MenuItem(icon: Icons.lock_outline_rounded, label: 'Privacy & Security'),
    _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & Support'),
    _MenuItem(icon: Icons.info_outline_rounded, label: 'About Learnify'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Text('Profile', style: textTheme.headlineLarge?.copyWith(fontSize: 24)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
                    onPressed: () {
                      themeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Avatar + name card
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              'PS',
                              style: textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text('Pushkar Sharma', style: textTheme.headlineMedium?.copyWith(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(
                            'pushkar@learnify.dev',
                            style: AppTextStyles.bodyMd.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Stats row
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _stats.map((s) => _statColumn(context, s)).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Notifications toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Push Notifications', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          'Get notified about deadlines and updates',
                          style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        value: _notificationsEnabled,
                        activeThumbColor: colorScheme.primary,
                        onChanged: (value) => setState(() => _notificationsEnabled = value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Menu items
                    ..._menuItems.map((item) => _menuTile(context, item)),
                    const SizedBox(height: 16),
                    // Log out
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        icon: Icon(Icons.logout_rounded, color: colorScheme.error),
                        label: Text('Log Out', style: AppTextStyles.labelMd.copyWith(color: colorScheme.error)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.error.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: LearnifyBottomNav(
          currentIndex: _navIndex,
          onTap: (index) {
            if (index == _navIndex) return;
            if (index == 0) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ProgramsScreen()),
              );
            } else if (index == 2) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MessagesScreen()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _statColumn(BuildContext context, _StatItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(item.icon, color: colorScheme.primary, size: 22),
        const SizedBox(height: 6),
        Text(item.value, style: AppTextStyles.headlineMd.copyWith(fontSize: 18)),
        Text(item.label, style: AppTextStyles.caption.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _menuTile(BuildContext context, _MenuItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(item.icon, color: colorScheme.onSurfaceVariant, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(item.label, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w500)),
                ),
                Icon(Icons.chevron_right_rounded, color: colorScheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  const _StatItem({required this.icon, required this.label, required this.value});
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}