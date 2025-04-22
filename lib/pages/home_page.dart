import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';
import '../pages/change_profile.dart';
import '../pages/signin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // initStateでは何もしない
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      // 非同期で実行してビルドサイクルを妨げないようにする
      Future.microtask(() {
        if (mounted) {
          Provider.of<AuthProvider>(context, listen: false).fetchUserProfile();
        }
      });
      _isInitialized = true;
    }
  }

  // URLを開く
  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  // ログアウト処理
  Future<void> _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).signout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Signin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('プロフィール'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfile()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: FutureBuilder(
            // 初期ロード時にFutureBuilderを使用
            future: authProvider.user == null
                ? authProvider.fetchUserProfile()
                : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Consumer<AuthProvider>(
                builder: (ctx, provider, _) {
                  final user = provider.user;
                  final profile = user?.profile;

                  if (user == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // プロフィール画像
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: profile?.profileImage != null
                              ? CachedNetworkImageProvider(
                                  'http://10.0.2.2:8000/storage/profile_images/${profile!.profileImage}',
                                )
                              : null,
                          child: profile?.profileImage == null ||
                                  profile?.profileImage == 'default.png'
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // ユーザー名
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // メールアドレス
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),

                        // SNSリンク
                        if (profile?.twitterUrl != null &&
                            profile!.twitterUrl!.isNotEmpty)
                          ListTile(
                            leading: const Icon(Icons.link, color: Colors.blue),
                            title: const Text('Twitter'),
                            subtitle: Text(profile.twitterUrl!),
                            onTap: () => _launchUrl(profile.twitterUrl),
                          ),

                        if (profile?.githubUrl != null &&
                            profile!.githubUrl!.isNotEmpty)
                          ListTile(
                            leading:
                                const Icon(Icons.code, color: Colors.black),
                            title: const Text('GitHub'),
                            subtitle: Text(profile.githubUrl!),
                            onTap: () => _launchUrl(profile.githubUrl),
                          ),

                        if ((profile?.twitterUrl == null ||
                                profile!.twitterUrl!.isEmpty) &&
                            (profile?.githubUrl == null ||
                                profile!.githubUrl!.isEmpty))
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'SNSリンクはまだ設定されていません。\n編集ボタンから追加できます。',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }));
  }
}
