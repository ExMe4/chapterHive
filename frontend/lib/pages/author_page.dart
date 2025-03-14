import 'package:flutter/material.dart';
import '../utils/strings.dart';

class AuthorPage extends StatelessWidget {
  static const highlightColor = Color(0xFFFFD700);

  const AuthorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String authorName = args?['name'] ?? AppStrings.unknown;
    final String? authorImage = args?['image'];

    return Scaffold(
      backgroundColor: highlightColor,
      appBar: AppBar(
        title: Text(authorName),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (authorImage != null)
                  ClipOval(
                    child: Image.network(
                      authorImage,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  authorName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
