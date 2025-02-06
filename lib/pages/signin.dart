import 'package:flutter/material.dart';
import 'package:flutter_practice_profile_page/pages/profile.dart';
import 'dart:convert';
import '../utils/network.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  SigninState createState() => SigninState();
}

class SigninState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _email;
  String? _password;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Map<String, String> data = {
      'email': _email!,
      'password': _password!,
    };

    Response? res;
    try {
      res = await Network().postData(data, '/signin');
    } catch (e) {
      debugPrint(e.toString());
    }

    if (res == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred'),
        ));
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var body = json.decode(res.body);

    if (res.statusCode != 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(body['message']),
        ));
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', json.encode(body['token']));
    localStorage.setString('user', json.encode(body['user']));

    if (!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: theme.primaryColor,
          title: Text('Sign In', style: theme.primaryTextTheme.titleLarge),
        ),
        body: SafeArea(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: _login,
                            child: const Text('Sign In'),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                    ))));
  }
}
