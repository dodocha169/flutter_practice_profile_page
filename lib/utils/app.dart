import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../pages/splash_screen.dart';

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: ThemeData(
//             primarySwatch: Colors.blueGrey,
//             primaryColor: Colors.black87,
//             primaryTextTheme: const TextTheme(
//               bodyLarge: TextStyle(color: Colors.black),
//               labelLarge: TextStyle(
//                 color: Colors.white,
//                 fontStyle: FontStyle.normal,
//               ),
//               titleLarge: TextStyle(
//                   color: Colors.white,
//                   fontStyle: FontStyle.normal,
//                   fontWeight: FontWeight.bold),
//             ),
//             primaryIconTheme: const IconThemeData(color: Colors.white)),
//         routes: {
//           '/register': (context) => const Register(),
//           '/signin': (context) => const SignIn(),
//           '/profile': (context) => const Profile(),
//           '/settings': (context) => const Settings(),
//         },
//         debugShowCheckedModeBanner: false,
//         home: const SignIn());
//   }
// }
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Profile App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
