import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onTap;

  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({
            'email': emailController.text.trim(),
            'createdAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
            'first_name': 'first',
            'last_name': 'last',
            'date_of_birth': Timestamp.fromDate(DateTime(2000, 1, 1)),
            'is_admin': false,
          });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
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
                    await createUserWithEmailAndPassword();
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Center(
          child: TextButton(
            onPressed: widget.onTap,
            child: Text(
              'Already have an account? Login here.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
