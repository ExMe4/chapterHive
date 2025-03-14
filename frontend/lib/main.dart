import 'package:flutter/material.dart';
import 'pages/book_page.dart';
import 'pages/author_page.dart';

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
        '/': (context) => const Scaffold(
          body: SafeArea(
            child: BookPage(
              title: "Trusting Was The Hardest Part (Hardest Part 2)",
              author: "Rabia Doğan",
              authorImage: "https://www.carlsen.de/sites/default/files/styles/s_470_auto/public/autor/foto/urheber5394_0.jpg?itok=QW0opy03",
              coverImage: "https://images.thalia.media/-/BF750-750/7d0b0eb48a6c4ad5bb22ed4ac7aa6182/trusting-was-the-hardest-part-hardest-part-2-taschenbuch-rabia-dogan.jpeg",
              pages: 400,
              averageRating: 4.2,
              totalReviews: 1542,
              publicationYear: 2024,
              genre: "Fiction / Romance / Contemporary",
              description: "Since Zelal moved to Berlin to study teaching, she has been torn between financial worries and the desire for independence. Without the support of her family, she is on her own. A light seems to emerge when she gets the job of student assistant to the newly hired postdoc Levi Jakab. But then something happens that Zelal never wanted to allow: The two of them begin to have forbidden tension. But Levi's hot-cold signals confuse Zelal until she realizes that he is hiding a secret - one that could cost him his job and throw Zelal back into her painful past.",
              publisher: "Carlsen",
              language: "German",
              isDarkMode: false,
            ),
          ),
        ),
        '/authorPage': (context) => const AuthorPage(),
      },
    );
  }
}
