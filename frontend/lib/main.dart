import 'package:flutter/material.dart';
import 'pages/book_page.dart';

void main() {
  runApp(const ChapterHiveApp());
}

class ChapterHiveApp extends StatelessWidget {
  const ChapterHiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChapterHive',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // Auto-switch light/dark mode
      home: Scaffold(
        body: SafeArea(
          child: BookPage(
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            coverImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg/1024px-The_Great_Gatsby_Cover_1925_Retouched.jpg",
            pages: 218,
            averageRating: 4.2,
            totalReviews: 1542,
            publicationYear: 1925,
            genre: "Classic, Fiction",
            description: "A novel set in the Jazz Age, exploring themes of wealth, excess, and the elusive American Dream through the mysterious Jay Gatsby.",
            publisher: "Charles Scribner's Sons",
            language: "English",
            isDarkMode: false, // Set dynamically based on user preference
          ),
        ),
      ),
    );
  }
}