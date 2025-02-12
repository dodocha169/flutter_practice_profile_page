import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/network.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/signin.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String? _name;
  String? _email;
  bool _isLoading = false;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user')!);

    if (user != null) {
      setState(() {
        _name = user['name'];
        _email = user['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> signout() async {
      setState(() {
        _isLoading = true;
      });

      Response? res;
      try {
        res = await Network().getData('/logout');
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
      localStorage.remove('user');
      localStorage.remove('token');

      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }

    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: theme.primaryIconTheme,
          backgroundColor: theme.primaryColor,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(110, 0, 30, 0),
            child: Text(
              style: theme.primaryTextTheme.titleLarge,
              'Profile Page',
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(140),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                'https://avatars.githubusercontent.com/u/74857462?v=4'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                        child: Text(_name ?? "",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const FaIcon(
                              FontAwesomeIcons.github,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.black87),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                )),
                            label: Text('GitHub',
                                style: theme.primaryTextTheme.labelLarge),
                          ),
                          const SizedBox(width: 18),
                          ElevatedButton.icon(
                            icon: const FaIcon(
                              FontAwesomeIcons.twitter,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.blue.shade600),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                              ),
                            ),
                            label: Text(
                              style: theme.primaryTextTheme.labelLarge,
                              "Twitter",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ));
  }
}
