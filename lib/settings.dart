import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        iconTheme: theme.primaryIconTheme,
        title: Text(
          style: theme.primaryTextTheme.titleLarge,
          'Settings',
        ),
      ),
      body: Column(children: [
        Expanded(
            child: SettingsList(sections: [
          SettingsSection(title: const Text('Account'), tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.account_circle),
              title: const Text('User name'),
              value: const Text('dodocha169'),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.manage_accounts),
              title: const Text('Change user profile'),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              value: const Text('English'),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy and security'),
            ),
          ]),
          SettingsSection(
            title: const Text('Notification'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: const Icon(Icons.notifications),
                title: const Text('New for you'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: false,
                leading: const Icon(Icons.record_voice_over),
                title: const Text('Account activity'),
              ),
            ],
          ),
          SettingsSection(title: const Text(''), tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
            ),
          ]),
        ])),
      ]),
    );
  }
}
