import 'package:flutter/material.dart';
import 'pages/book_page.dart';
import 'pages/author_page.dart';
import 'pages/explore_page.dart';

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
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const ExplorePage(),
        '/authorPage': (context) => const AuthorPage(),
      },
    );
  }
}
