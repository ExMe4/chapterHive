import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _googleSignIn = GoogleSignIn();
  final _storage = FlutterSecureStorage();
  final _baseUrl = 'http://localhost:8080/api'; // change for prod

  String? _jwt;
  String? _userId;

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final idToken = googleAuth?.idToken;
      if (idToken == null) return false;

      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"),
        body: {
          'token': idToken,
          'provider': 'google',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _jwt = data['token'];
        _userId = _extractUserIdFromJwt(_jwt!);

        await _storage.write(key: 'jwt', value: _jwt);
        await _storage.write(key: 'userId', value: _userId);
        return true;
      }

      return false;
    } catch (e) {
      print("Google sign-in failed: $e");
      return false;
    }
  }

  Future<User?> getUser() async {
    _jwt ??= await _storage.read(key: 'jwt');
    _userId ??= await _storage.read(key: 'userId');

    if (_jwt == null || _userId == null) return null;

    final response = await http.get(
      Uri.parse("$_baseUrl/users/$_userId"),
      headers: {
        'Authorization': 'Bearer $_jwt',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }
    return null;
  }

  Future<bool> updateUser(String username, String? profilePicture) async {
    _jwt ??= await _storage.read(key: 'jwt');
    _userId ??= await _storage.read(key: 'userId');

    if (_jwt == null || _userId == null) return false;

    final response = await http.put(
      Uri.parse("$_baseUrl/users/$_userId"),
      headers: {
        'Authorization': 'Bearer $_jwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'profilePicture': profilePicture,
      }),
    );

    return response.statusCode == 200;
  }

  String _extractUserIdFromJwt(String jwt) {
    final parts = jwt.split('.');
    if (parts.length != 3) return '';
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final data = jsonDecode(payload);
    return data['sub'];
  }
}

class User {
  final String id;
  final String username;
  final String? profilePicture;

  User({required this.id, required this.username, this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      profilePicture: json['profilePicture'],
    );
  }
}
