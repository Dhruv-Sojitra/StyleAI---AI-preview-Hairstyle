import 'package:ai_hairstyle_preview_app/models/generation_result_model.dart';
import 'package:ai_hairstyle_preview_app/providers/theme_provider.dart';
import 'package:ai_hairstyle_preview_app/services/auth_service.dart';
import 'package:ai_hairstyle_preview_app/services/firestore_service.dart';
import 'package:ai_hairstyle_preview_app/screens/favorites_screen.dart';
import 'package:ai_hairstyle_preview_app/screens/edit_profile_screen.dart';
import 'package:ai_hairstyle_preview_app/screens/notification_screen.dart';
import 'package:ai_hairstyle_preview_app/screens/help_support_screen.dart';
import 'package:ai_hairstyle_preview_app/screens/about_screen.dart';
import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authServiceProvider).currentUser;
    final firestore = ref.watch(firestoreServiceProvider);
    final themeMode = ref.watch(themeProvider);

    if (user == null) return const Center(child: Text('Please login'));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            DesignSystem.primaryGradientStart.withValues(alpha: 0.05),
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: DesignSystem.primaryGradient,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Text(
                            user.email?.substring(0, 1).toUpperCase() ?? 'U',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: DesignSystem.primaryGradientStart,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.verified_rounded, color: Colors.blue, size: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? user.email?.split('@').first ?? 'User',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: StreamBuilder<List<GenerationResult>>(
              stream: firestore.getUserHistory(user.uid),
              builder: (context, snapshot) {
                final history = snapshot.data ?? [];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          label: 'Makeovers',
                          value: '${history.length}',
                          icon: Icons.auto_awesome_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatBox(
                          label: 'Favorites',
                          value: '${history.where((item) => item.isFavorite).length}',
                          icon: Icons.favorite_rounded,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen())),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text('Settings & Preferences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 16),
                _ProfileTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
                ),
                _ProfileTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
                ),
                _ProfileTile(
                  icon: themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  title: 'Appearance',
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                    activeThumbColor: DesignSystem.primaryGradientStart,
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 24),
                const Text('More', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 16),
                _ProfileTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen())),
                ),
                _ProfileTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About StyleAI',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen())),
                ),
                _ProfileTile(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  isDestructive: true,
                  onTap: () => _confirmLogout(context, ref),
                ),
                const SizedBox(height: 40),
                const Center(child: Text('Version 2.0.0 (Premium Build)', style: TextStyle(color: Colors.grey, fontSize: 12))),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to exit? We\'ll miss your transformations!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authServiceProvider).signOut();
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const _StatBox({required this.label, required this.value, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return StyleCard(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: DesignSystem.primaryGradientStart, size: 24),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDestructive;

  const _ProfileTile({required this.icon, required this.title, required this.onTap, this.trailing, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: StyleCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive ? Colors.redAccent.withValues(alpha: 0.1) : DesignSystem.primaryGradientStart.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isDestructive ? Colors.redAccent : DesignSystem.primaryGradientStart, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDestructive ? Colors.redAccent : null,
                ),
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
