import 'package:ai_hairstyle_preview_app/utils/design_system.dart';
import 'package:ai_hairstyle_preview_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _allNotifications = true;
  bool _dailyTips = true;
  bool _reminders = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _allNotifications = prefs.getBool('notifications_enabled') ?? true;
      _dailyTips = prefs.getBool('daily_tips_enabled') ?? true;
      _reminders = prefs.getBool('reminders_enabled') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {
      if (key == 'notifications_enabled') _allNotifications = value;
      if (key == 'daily_tips_enabled') _dailyTips = value;
      if (key == 'reminders_enabled') _reminders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage how you receive updates and tips.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  _buildNotificationTile(
                    title: 'Allow Notifications',
                    subtitle: 'Master switch for all app notifications',
                    value: _allNotifications,
                    icon: Icons.notifications_active_outlined,
                    onChanged: (val) =>
                        _updatePreference('notifications_enabled', val),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Preferences',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildNotificationTile(
                    title: 'Daily Style Tips',
                    subtitle: 'Receive inspiration for your next look',
                    value: _dailyTips && _allNotifications,
                    enabled: _allNotifications,
                    icon: Icons.lightbulb_outline_rounded,
                    onChanged: (val) =>
                        _updatePreference('daily_tips_enabled', val),
                  ),

                  const SizedBox(height: 16),

                  _buildNotificationTile(
                    title: 'Transformation Reminders',
                    subtitle:
                        'Get notified when you leave a transformation pending',
                    value: _reminders && _allNotifications,
                    enabled: _allNotifications,
                    icon: Icons.history_rounded,
                    onChanged: (val) =>
                        _updatePreference('reminders_enabled', val),
                  ),

                  const SizedBox(height: 48),
                  StyleCard(
                    color: DesignSystem.primaryGradientStart.withValues(
                      alpha: 0.05,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: DesignSystem.primaryGradientStart,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Note: You can also manage notification permissions in your device settings.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return StyleCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesignSystem.primaryGradientStart.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: enabled ? DesignSystem.primaryGradientStart : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: enabled ? null : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: DesignSystem.primaryGradientStart,
          ),
        ],
      ),
    );
  }
}
