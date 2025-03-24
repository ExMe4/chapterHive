import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/strings.dart';
import 'package:http/http.dart' as http;

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  List<dynamic> _authors = [];

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _books = [];
        _authors = [];
      });
      return;
    }

    final uri = Uri.parse('http://127.0.0.1:8080/api/explore?query=$query'); // change for prod
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _books = data['books'] ?? [];
        _authors = data['authors'] ?? [];
      });
    } else {
      print("Error fetching books: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      color: Colors.black.withAlpha((0.25 * 255).toInt()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextField(
          controller: _searchController,
          onChanged: _searchBooks,
          decoration: InputDecoration(
            hintText: AppStrings.searchBoxHint,
            hintStyle: TextStyle(color: Colors.white.withAlpha((0.7 * 255).toInt())),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _books.length + _authors.length,
        itemBuilder: (context, index) {
          if (index < _books.length) {
            final book = _books[index];
            return ListTile(
              leading: book['thumbnail'] != null && book['thumbnail'].isNotEmpty
                  ? Image.network(book['thumbnail'], width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon(Icons.book, size: 50),
              title: Text(book['title']),
              subtitle: Text("By ${book['authors'].join(", ")}"),
            );
          } else {
            final author = _authors[index - _books.length];
            return ListTile(
              leading: const Icon(Icons.person, size: 50),
              title: Text(author['name']),
            );
          }
        },
      ),
    );
  }
}
