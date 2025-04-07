import 'package:flutter/material.dart';
import 'package:frontend/utils/strings.dart';
import '../services/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Drawer(
      backgroundColor: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              final success = await authService.signInWithGoogle();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.loginSuccess)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.loginFailed)),
                );
              }
            },
            icon: Icon(Icons.g_mobiledata_rounded, color: Color(0xFFFFD700)),
            label: Text(AppStrings.loginWithGoogle),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              // Placeholder for Apple login
            },
            icon: Icon(Icons.apple, color: Color(0xFFFFD700)),
            label: Text(AppStrings.loginWithApple),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
          ),
        ],
      ),
    );
  }
}
