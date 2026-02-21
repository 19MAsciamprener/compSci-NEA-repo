import 'package:flutter/material.dart';
import 'package:stock_kiosk_app/logic/create_user.dart';
import 'package:stock_kiosk_app/logic/date_pick.dart';
import 'package:stock_kiosk_app/widgets/back_button.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  bool isAdmin = false;
  DateTime? dateOfBirth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PagePageBackButton(),
        title: const Text('Create User', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              style: TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: lastNameController,
              style: TextStyle(color: Colors.white),

              decoration: const InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Admin Privileges',
                  style: TextStyle(color: Colors.white),
                ),
                Switch(
                  value: isAdmin,
                  onChanged: (value) {
                    setState(() {
                      isAdmin = value;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                DateTime? selectedDate = await pickDate(context, dateOfBirth);
                if (selectedDate != null) {
                  setState(() {
                    dateOfBirth = selectedDate;
                  });
                }
              },
              child: const Text(
                'Select Date of Birth',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                // Create user logic would go here
                createUser(
                  context,
                  firstNameController.text.trim(),
                  lastNameController.text.trim(),
                  emailController.text.trim(),
                  dateOfBirth,
                  isAdmin,
                );
              },
              child: const Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
