import 'package:flutter/material.dart';
import 'package:frontend/pages/splash_screen.dart';
import 'package:frontend/pages/username_setup_page.dart';
import '../main.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(Duration(seconds: 2));
    final user = await _authService.getUser();

    if (user == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    } else if (user.username.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UsernameSetupPage()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}