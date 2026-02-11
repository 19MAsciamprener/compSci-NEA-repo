//main.dart @ stock_kiosk_app (the beginning of everything)

//material import
import 'package:flutter/material.dart';
//firebase imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//internal page imports
// import 'package:stock_kiosk_app/pages/admin/add_item_page.dart'; //for testing
import 'pages/global/standby_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //initialize firebase
  await FirebaseAuth.instance.signOut(); //ensure signed out on app start

  runApp(
    const MyApp(),
  ); // 'the beginning of everything' (*read aloud, Mysteriously*)
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Kiosk',
      theme: ThemeData(
        //below is all theme data for app
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(110, 5, 6, 1),
          primary: Color.fromRGBO(110, 5, 6, 1),
          surface: Color.fromRGBO(29, 27, 32, 1),
        ), //who picked this dumbass color scheme?

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(110, 5, 6, 1),
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),

        useMaterial3: true,

        appBarTheme: const AppBarTheme(
          //this appbar theme stops a material3 styling issue where app bar goes a pale red any time a user scrolls.
          //This sections keeps UI consistency to not confuse users
          backgroundColor: Color.fromRGBO(29, 27, 32, 1),
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),

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
      ),
      home: const StandbyPage(), //opens standby screen on app start
    );
  }
}
