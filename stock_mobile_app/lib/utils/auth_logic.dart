import 'package:flutter/material.dart';
import 'package:stock_mobile_app/pages/global/login_page.dart';
import 'package:stock_mobile_app/pages/global/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = false;

  void toggle() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return showLogin ? LoginPage(onTap: toggle) : SignupPage(onTap: toggle);
  }
}
