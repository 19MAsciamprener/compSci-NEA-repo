import 'package:flutter/material.dart';
import 'package:stock_mobile_app/logic/login_logic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 128),
              Text(
                'Email:',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(height: 2),

              SizedBox(
                width: 400,
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 64),

              Text(
                'Password:',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(height: 2),
              SizedBox(
                width: 400,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 128),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await loginUserWithEmailAndPassword(
                      context,
                      emailController,
                      passwordController,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 100),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
