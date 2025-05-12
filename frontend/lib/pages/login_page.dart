import 'package:flutter/material.dart';
import 'package:frontend/pages/username_setup_page.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../utils/strings.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    Future<void> _handleLogin() async {
      final success = await authService.signInWithGoogle();
      if (!success) return;

      final user = await authService.getUser();
      if (user?.username == null || user!.username.isEmpty) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UsernameSetupPage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.g_mobiledata_rounded, color: Color(0xFFFFD700)),
              label: Text(AppStrings.loginWithGoogle),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: _handleLogin,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.apple, color: Color(0xFFFFD700)),
              label: Text(AppStrings.loginWithApple),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {}, // TODO
            ),
          ],
        ),
      ),
    );
  }
}
