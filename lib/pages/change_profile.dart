import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _twitterController = TextEditingController();
  final _githubController = TextEditingController();
  File? _imageFile;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // 現在の値を設定
    final profile =
        Provider.of<AuthProvider>(context, listen: false).user?.profile;
    if (profile != null) {
      _twitterController.text = profile.twitterUrl ?? '';
      _githubController.text = profile.githubUrl ?? '';
    }
  }

  @override
  void dispose() {
    _twitterController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  // 画像選択
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // プロフィール更新
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await Provider.of<AuthProvider>(context, listen: false).updateProfile(
        twitterUrl: _twitterController.text.trim(),
        githubUrl: _githubController.text.trim(),
        profileImagePath: _imageFile?.path,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('プロフィールを更新しました')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<AuthProvider>(context).user?.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール編集')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // プロフィール画像
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (profile?.profileImage != null
                            ? CachedNetworkImageProvider(
                                'http://10.0.2.2:8000/storage/profile_images/${profile!.profileImage}',
                              ) as ImageProvider<Object>?
                            : null),
                    child: (_imageFile == null &&
                            (profile?.profileImage == null ||
                                profile!.profileImage == 'default.png'))
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 18),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Twitter URL
              TextFormField(
                onTapOutside: (event) {
                  primaryFocus?.unfocus();
                },
                controller: _twitterController,
                decoration: const InputDecoration(
                  labelText: 'Twitter URL',
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    // 簡易的なURL検証
                    final urlPattern = RegExp(
                      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return '有効なURLを入力してください';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // GitHub URL
              TextFormField(
                onTapOutside: (event) {
                  primaryFocus?.unfocus();
                },
                controller: _githubController,
                decoration: const InputDecoration(
                  labelText: 'GitHub URL',
                  prefixIcon: Icon(Icons.code),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    // 簡易的なURL検証
                    final urlPattern = RegExp(
                      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return '有効なURLを入力してください';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // 更新ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateProfile,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('更新する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
