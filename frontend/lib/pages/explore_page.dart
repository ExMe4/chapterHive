import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/strings.dart';
import '../widgets/custom_drawer.dart';
import 'book_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  bool _isLoading = false;

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() => _books = []);
      return;
    }

    setState(() => _isLoading = true);

    final uri = Uri.parse("${dotenv.env['EXPLORE_URL']!}?query=$query");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final utf8DecodedData = utf8.decode(response.bodyBytes);
      final data = jsonDecode(utf8DecodedData);
      setState(() => _books = data['books'] ?? []);
    } else {
      print("Error fetching books: ${response.body}");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: const Color(0xFFFFD700),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.values.first,
          children: [
            _buildSearchBar(),
            if (_books.isNotEmpty) Expanded(child: _buildResultsCard()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: _searchController,
              onChanged: _searchBooks,
              decoration: InputDecoration(
                hintText: AppStrings.searchBoxHint,
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: _books.asMap().entries.map((entry) {
                  return Column(
                    children: [
                      _buildBookItem(entry.value),
                      if (entry.key != _books.length - 1) _buildLineSeparator(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookItem(dynamic book) {
    List<String> authors = (book['author'] != null)
        ? [book['author']]
        : ["Unknown Author"];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: book['coverImage'] != null && book['coverImage'].isNotEmpty
          ? Image.network(
        book['coverImage'],
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const CircularProgressIndicator();
          }
        },
      )
          : const Icon(Icons.book, size: 50),
      title: Text(
        book['title'] ?? "Unknown Title",
        style: const TextStyle(fontSize: 16, color: Colors.white),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${AppStrings.byAuthor} ${authors.join(", ")}",
        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _navigateToBookPage(book),
    );
  }


  Widget _buildLineSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 4,
      width: 300,
      decoration: BoxDecoration(
        color: BookPage.highlightColor.withAlpha((0.60 * 255).toInt()),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  void _navigateToBookPage(dynamic book) {
    String authorText = book['author'] ?? "Unknown Author";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookPage(
          title: book['title'] ?? "Unknown Title",
          author: authorText,
          authorImage: book['authorImage'],
          coverImage: book['coverImage'] ?? '',
          pages: book['pages'],
          averageRating: book['averageRating']?.toDouble() ?? 0.0,
          totalReviews: book['totalReviews'] ?? 0,
          publicationYear: book['publicationYear'],
          genre: book['genre'],
          description: book['description'],
          publisher: book['publisher'],
          language: book['language'],
          isDarkMode: false,
        ),
      ),
    );
  }
}
