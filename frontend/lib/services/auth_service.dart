import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class AuthService {
  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: dotenv.env['SERVER_CLIENT_ID'],
  );
  final _storage = FlutterSecureStorage();
  final _baseUrl = dotenv.env['BASE_URL']!;

  String? _jwt;
  String? _userId;

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return false;
      }
      final googleAuth = await googleUser.authentication;

      final idToken = googleAuth.idToken;
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
      final data = jsonDecode(utf8.decode(response.bodyBytes));
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
