import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Settings'),
      ),
      body: Column(
          children: [
            Container(
              child: Expanded(
                  child: SettingsList(
                      sections: [
                        SettingsSection(
                            title: Text('Account'),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                leading: Icon(Icons.account_circle),
                                title: Text('User name'),
                                value: Text('dodocha169'),
                              ),
                              SettingsTile.navigation(
                                leading: Icon(Icons.manage_accounts),
                                title: Text('Change user profile'),
                              ),
                              SettingsTile.navigation(
                                leading: Icon(Icons.language),
                                title: Text('Language'),
                                value: Text('English'),
                              ),
                              SettingsTile.navigation(
                                leading: Icon(Icons.privacy_tip),
                                title: Text('Privacy and security'),
                              ),
                            ]
                        ),
                        SettingsSection(
                            title: Text('Notification'),
                            tiles: <SettingsTile>[
                              SettingsTile.switchTile(
                                onToggle: (value) {},
                                initialValue: true,
                                leading: Icon(Icons.notifications),
                                title: Text('New for you'),
                            ),
                              SettingsTile.switchTile(
                                onToggle: (value) {},
                                initialValue: false,
                                leading: Icon(Icons.record_voice_over),
                                title: Text('Account activity'),
                              ),
                            ],
                        ),
                        SettingsSection(
                            title: Text(''),
                            tiles: <SettingsTile>[
                              SettingsTile.navigation(
                                leading: Icon(Icons.logout),
                                title: Text('Sign out'),
                              ),
                            ]
                        ),
                      ]
                  )
              ),
            ),
          ]
      ),
    );
  }
}
