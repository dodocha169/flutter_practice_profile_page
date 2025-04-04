import 'package:flutter/material.dart';
import 'dart:convert';
import '../utils/network.dart';
import '../pages/profile.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _name;
  String? _email;
  String? _password;

  Future<void> _register() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }
    formState.save();

    setState(() {
      _isLoading = true;
    });

    Map<String, String> data = {
      'name': _name!,
      'email': _email!,
      'password': _password!,
    };

    Response? res;
    try {
      res = await Network().postData(data, '/register');
      debugPrint('Res Status: ${res.statusCode}');
      debugPrint('Res body: ${res.body}');
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

    Map<String, dynamic> body;
    try {
      body = json.decode(res.body);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid response format: ${e.toString()}'),
        ));
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(hintText: 'Name'),
                          validator: (nameValue) {
                            if (nameValue == null || nameValue == "") {
                              return 'Name is required';
                            }
                            return null;
                          },
                          onSaved: (nameValue) {
                            _name = nameValue!;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'Email'),
                          validator: (String? emailValue) {
                            if (emailValue == null || emailValue == "") {
                              return 'Email is required';
                            }
                            return null;
                          },
                          onSaved: (emailValue) {
                            _email = emailValue!;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              const InputDecoration(hintText: 'Password'),
                          obscureText: true,
                          validator: (passwordValue) {
                            if (passwordValue == null || passwordValue == "") {
                              return 'Password is required';
                            }
                            return null;
                          },
                          onSaved: (passwordValue) {
                            _password = passwordValue!;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _register();
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ))),
    );
  }
}
