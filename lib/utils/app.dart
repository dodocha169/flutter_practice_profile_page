import 'package:flutter/material.dart';
import '../pages/signin.dart';
import '../pages/profile.dart';
import '../pages/settings.dart';
import '../pages/register.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            primaryColor: Colors.black87,
            primaryTextTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              labelLarge: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.normal,
              ),
              titleLarge: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
            ),
            primaryIconTheme: const IconThemeData(color: Colors.white)),
        routes: {
          '/register': (context) => const Register(),
          '/signin': (context) => const SignIn(),
          '/profile': (context) => const Profile(),
          '/settings': (context) => const Settings(),
        },
        debugShowCheckedModeBanner: false,
        home: const SignIn());
  }
}
