import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  // アプリ起動時に保存されたトークンをチェック
  Future<bool> tryAutoLogin() async {
    setLoading(true);
    try {
      final savedToken = await _storage.read(key: 'auth_token');
      if (savedToken == null) {
        setLoading(false);
        return false;
      }

      _token = savedToken;
      await fetchUserProfile();

      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      return false;
    }
  }

  // ユーザー情報と関連プロフィールのフェッチ
  Future<void> fetchUserProfile() async {
    try {
      final response = await _apiService.get('/user', token: _token);
      _user = User.fromJson(response);
      notifyListeners();
    } catch (e) {
      signout();
      throw Exception('ユーザープロフィールの取得に失敗しました');
    }
  }

  // 登録
  Future<void> register(String name, String email, String password,
      String passwordConfirmation) async {
    setLoading(true);
    try {
      final response = await _apiService.post('/register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      _token = response['token'];
      _user = User.fromJson(response['user']);

      await _storage.write(key: 'auth_token', value: _token);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      throw Exception('登録に失敗しました: $e');
    }
  }

  // ログイン
  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      final response = await _apiService.post('/signin', {
        'email': email,
        'password': password,
      });

      _token = response['token'];
      _user = User.fromJson(response['user']);

      await _storage.write(key: 'auth_token', value: _token);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      throw Exception('ログインに失敗しました: $e');
    }
  }

  // ログアウト
  Future<void> signout() async {
    try {
      if (_token != null) {
        await _apiService.post('/signout', {}, token: _token);
      }
    } catch (e) {
      // エラーがあっても続行
    } finally {
      _token = null;
      _user = null;
      await _storage.delete(key: 'auth_token');
      notifyListeners();
    }
  }

  // プロフィール更新
  Future<void> updateProfile(
      {String? twitterUrl, String? githubUrl, String? profileImagePath}) async {
    setLoading(true);
    try {
      final response = await _apiService.multipartRequest(
        '/profile',
        twitterUrl: twitterUrl,
        githubUrl: githubUrl,
        profileImagePath: profileImagePath,
        token: _token,
      );

      if (_user != null && _user!.profile != null) {
        _user!.profile!.twitterUrl = response['profile']['twitter_url'];
        _user!.profile!.githubUrl = response['profile']['github_url'];
        _user!.profile!.profileImage = response['profile']['profile_image'];
      }

      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      throw Exception('プロフィール更新に失敗しました: $e');
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
