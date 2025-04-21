import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/sample_users.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set isLoggedIn to false to start with LoginScreen
  isLoggedIn = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduLearn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
          secondary: Colors.amber,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      // Check if user is logged in and show appropriate screen
      home: isLoggedIn ? const MainAppScreen() : const LoginScreen(),
    );
  }
}
