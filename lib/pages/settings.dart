// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:settings_ui/settings_ui.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../pages/signin.dart';
// import 'package:http/http.dart';
// import '../utils/network.dart';

// class Settings extends StatefulWidget {
//   const Settings({super.key});
//   @override
//   SettingsState createState() => SettingsState();
// }

// class SettingsState extends State<Settings> {
//   String? _name;
//   bool _isLoading = false;
//   @override
//   void initState() {
//     _loadUserData();
//     super.initState();
//   }

//   _loadUserData() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var user = jsonDecode(localStorage.getString('user')!);

//     if (user != null) {
//       setState(() {
//         _name = user['name'];
//         // _email = user['email'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<void> signout() async {
//       setState(() {
//         _isLoading = true;
//       });

//       Response? res;
//       try {
//         res = await Network().getData('/signout');
//       } catch (e) {
//         debugPrint(e.toString());
//       }
//       if (res == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text('An error occurred'),
//           ));
//         }
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       var body = json.decode(res.body);

//       if (res.statusCode != 200) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text(body['message']),
//           ));
//         }
//         setState(() {
//           _isLoading = false;
//         });
//         return;
//       }

//       SharedPreferences localStorage = await SharedPreferences.getInstance();
//       localStorage.remove('user');
//       localStorage.remove('token');

//       if (!mounted) return;
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => SignIn()));
//     }

//     final theme = Theme.of(context);
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: theme.primaryColor,
//           iconTheme: theme.primaryIconTheme,
//           title: Text(
//             style: theme.primaryTextTheme.titleLarge,
//             'Settings',
//           ),
//         ),
//         body: SafeArea(
//             child: _isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : Center(
//                     child: Column(children: [
//                     Expanded(
//                         child: SettingsList(sections: [
//                       SettingsSection(
//                           title: const Text('Account'),
//                           tiles: <SettingsTile>[
//                             SettingsTile(
//                               leading: const Icon(Icons.account_circle),
//                               title: const Text('User name'),
//                               value: Text(_name ?? ""),
//                             ),
//                             SettingsTile.navigation(
//                               leading: const Icon(Icons.manage_accounts),
//                               title: const Text('Change user profile'),
//                             ),
//                             SettingsTile.navigation(
//                               leading: const Icon(Icons.language),
//                               title: const Text('Language'),
//                               value: const Text('English'),
//                             ),
//                             SettingsTile.navigation(
//                               leading: const Icon(Icons.privacy_tip),
//                               title: const Text('Privacy and security'),
//                             ),
//                           ]),
//                       SettingsSection(
//                         title: const Text('Notification'),
//                         tiles: <SettingsTile>[
//                           SettingsTile.switchTile(
//                             onToggle: (value) {},
//                             initialValue: true,
//                             leading: const Icon(Icons.notifications),
//                             title: const Text('New for you'),
//                           ),
//                           SettingsTile.switchTile(
//                             onToggle: (value) {
//                               value = !value;
//                             },
//                             initialValue: false,
//                             leading: const Icon(Icons.record_voice_over),
//                             title: const Text('Account activity'),
//                           ),
//                         ],
//                       ),
//                       SettingsSection(
//                           title: const Text(''),
//                           tiles: <SettingsTile>[
//                             SettingsTile.navigation(
//                               onPressed: (context) {
//                                 signout();
//                               },
//                               leading: const Icon(Icons.logout),
//                               title: const Text('Sign out'),
//                             )
//                           ])
//                     ]))
//                   ]))));
//   }
// }
