import 'package:flutter/material.dart';
import 'profile.dart';

final List<String> entreis = <String>[
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
        debugShowCheckedModeBanner: false,
        home: Profile());
  }
}
