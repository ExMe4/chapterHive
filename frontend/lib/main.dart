import 'package:flutter/material.dart';
import 'pages/book_page.dart';

void main() {
  runApp(const ChapterHiveApp());
}

class ChapterHiveApp extends StatelessWidget {
  const ChapterHiveApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChapterHive',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system, // Adjust for light/dark mode
      home: const BookPage(
        title: "The Great Gatsby",
        author: "F. Scott Fitzgerald",
        coverImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/The_Great_Gatsby_Cover_1925_Retouched.jpg/1024px-The_Great_Gatsby_Cover_1925_Retouched.jpg",
        pages: 218,
        averageRating: 4.2,
        totalReviews: 1542,
      ),
    );
  }
}