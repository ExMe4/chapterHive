import 'package:flutter/material.dart';

import '../main.dart';
import '../services/auth_service.dart';

class UsernameSetupPage extends StatefulWidget {
  const UsernameSetupPage({super.key});

  @override
  State<UsernameSetupPage> createState() => _UsernameSetupPageState();
}

class _UsernameSetupPageState extends State<UsernameSetupPage> {
  final _controller = TextEditingController();
  final authService = AuthService();

  Future<void> _submitUsername() async {
    if (_controller.text.trim().isEmpty) return;
    final updated = await authService.updateUser(_controller.text.trim(), null);
    if (updated) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD700),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose your username", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Username",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submitUsername, child: const Text("Continue")),
            ],
          ),
        ),
      ),
    );
  }
}
