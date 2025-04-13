import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/strings.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final authService = AuthService();
  bool isLoggedIn = false;
  String? username;
  String? profilePicture;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    final user = await authService.getUser();
    setState(() {
      isLoggedIn = user != null;
      username = user?.username;
      profilePicture = user?.profilePicture;
      _usernameController.text = username ?? '';
    });
  }

  Future<void> _updateProfile() async {
    final updated = await authService.updateUser(
      _usernameController.text,
      profilePicture,
    );
    if (updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.profileUpdated)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: Center(
        child: isLoggedIn ? _buildProfileSection() : _buildLoginSection(),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final success = await authService.signInWithGoogle();
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.loginSuccess)),
              );
              _checkAuthState();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.loginFailed)),
              );
            }
          },
          icon: Icon(Icons.g_mobiledata_rounded, color: Color(0xFFFFD700)),
          label: Text(AppStrings.loginWithGoogle),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // Placeholder for Apple login
          },
          icon: Icon(Icons.apple, color: Color(0xFFFFD700)),
          label: Text(AppStrings.loginWithApple),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: profilePicture != null && profilePicture!.isNotEmpty
                ? NetworkImage(profilePicture!)
                : AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _usernameController,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppStrings.enterUsername,
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _updateProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: Text(AppStrings.saveProfile),
          ),
        ],
      ),
    );
  }
}
