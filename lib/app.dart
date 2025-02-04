import 'package:flutter/material.dart';
import 'profile.dart';

final List<String> entries = <String>[
  'flutter_practice_signup',
  'flutter_practice_credit_card_checkout',
  'flutter_practice_landing_page',
  'flutter_practice_calculator'
];

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
        debugShowCheckedModeBanner: false,
        home: const Profile());
  }
}
