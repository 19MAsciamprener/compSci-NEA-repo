import 'package:flutter/material.dart';
import '../pages/qr_page.dart';
import '../pages/account_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _pages = const [QrPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          setState(() => _index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan",
          ),
          NavigationDestination(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
