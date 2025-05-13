import 'package:flutter/material.dart';
import 'package:frontend/utils/strings.dart';
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainScreen()));
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
              const Text(AppStrings.chooseYourUsername,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                style: const TextStyle(
                  color: Colors.black, // darker text when typing
                ),
                decoration: const InputDecoration(
                  hintText: AppStrings.username,
                  hintStyle: TextStyle(color: Colors.black26), // lighter hint text
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitUsername,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text(AppStrings.saveUsername),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
