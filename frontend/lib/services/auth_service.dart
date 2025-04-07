import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _googleSignIn = GoogleSignIn();
  final _storage = FlutterSecureStorage();

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final idToken = googleAuth?.idToken;
      if (idToken == null) return false;

      final response = await http.post(
        Uri.parse("http://localhost:8080/api/auth/login"), // change for prod
        body: {
          'token': idToken,
          'provider': 'google',
        },
      );

      if (response.statusCode == 200) {
        final jwt = jsonDecode(response.body)['token'];
        await _storage.write(key: 'jwt', value: jwt);
        return true;
      }

      return false;
    } catch (e) {
      print("Google sign-in failed: $e");
      return false;
    }
  }
}
