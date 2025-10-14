import 'screens/splash.dart';

import 'package:flutter/material.dart';
import 'db.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDb().database; // ensure DB created
  runApp(const AliciaApp());
}

class AliciaApp extends StatelessWidget {
  const AliciaApp({super.key});

  static const Color pink = Color(0xFFF3A6C0); // pastel approximated
  static const Color softPink = Color(0xFFF9D6E3);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floristas Alicia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: pink, primary: pink, secondary: softPink),
        useMaterial3: true,
        scaffoldBackgroundColor: softPink,
        fontFamily: 'sans-serif',
      ),
      home: const SplashScreen(),
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}
