import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class Network {
  final String _url = 'http://localhost/Laravel_Auth_Flutter/Public/api/auth';
  String? token;

  _setToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? localToken = localStorage.getString('token');

    if (localToken != null) {
      token = localToken.replaceAll('"', '');
    }
  }

  _getHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<Response> postData(data, String apiUrl) async {
    await _setToken();
    Uri fullUrl = Uri.parse(_url + apiUrl);
    return await post(fullUrl, body: jsonEncode(data), headers: _getHeaders());
  }

  Future<Response> getData(String apiUrl) async {
    await _setToken();
    Uri fullUrl = Uri.parse(_url + apiUrl);
    Response res = await get(fullUrl, headers: _getHeaders());
    return res;
  }
}
