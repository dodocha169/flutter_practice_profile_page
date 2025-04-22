import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String baseUrl =
      'http://localhost/Laravel_Auth_Flutter/Public/api'; // エミュレータ用の localhost

  // GET リクエスト
  Future<dynamic> get(String endpoint, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(token),
    );

    return _processResponse(response);
  }

  // POST リクエスト
  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers(token),
      body: jsonEncode(data),
    );

    return _processResponse(response);
  }

  // マルチパートリクエスト（プロフィール画像アップロード用）
  Future<dynamic> multipartRequest(
    String endpoint, {
    String? twitterUrl,
    String? githubUrl,
    String? profileImagePath,
    String? token,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$endpoint'),
    );

    // ヘッダーを設定
    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    // テキストフィールドを追加
    if (twitterUrl != null) request.fields['twitter_url'] = twitterUrl;
    if (githubUrl != null) request.fields['github_url'] = githubUrl;

    // 画像ファイルを追加
    if (profileImagePath != null) {
      final file = File(profileImagePath);
      final fileExtension = profileImagePath.split('.').last;

      request.files.add(http.MultipartFile(
        'profile_image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: 'profile.$fileExtension',
        contentType: MediaType('image', fileExtension),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _processResponse(response);
  }

  // レスポンス処理
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API エラー: ${response.statusCode} ${response.body}');
    }
  }

  // リクエストヘッダー
  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
