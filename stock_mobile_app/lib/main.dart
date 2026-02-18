import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stock_mobile_app/utils/app_shell.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_mobile_app/utils/auth_logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(110, 5, 6, 1),
          primary: Color.fromRGBO(110, 5, 6, 1),
          surface: Color.fromRGBO(29, 27, 32, 1),
        ),

        useMaterial3: true,

        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          titleMedium: TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
            decorationThickness: 1.5,
            fontSize: 18,
            color: Colors.white,
          ),
        ),

        appBarTheme: const AppBarTheme(
          //this appbar theme stops a material3 styling issue where app bar goes a pale red any time a user scrolls.
          //This sections keeps UI consistency to not confuse users
          backgroundColor: Color.fromRGBO(29, 27, 32, 1),
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const AppShell();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
