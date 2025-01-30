import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookPage extends StatelessWidget {
  final String title;
  final String author;
  final String coverImage;
  final int? pages;
  final double averageRating;
  final int totalReviews;
  final int? publicationYear;
  final String? genre;
  final String? description;
  final String? publisher;
  final String? language;
  final bool isDarkMode;

  const BookPage({
    super.key,
    required this.title,
    required this.author,
    required this.coverImage,
    this.pages,
    required this.averageRating,
    required this.totalReviews,
    this.publicationYear,
    this.genre,
    this.description,
    this.publisher,
    this.language,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    const highlightColor = Color(0xFFFFD700); // Bumblebee yellow

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Book Details',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 800, // Limits the width for responsiveness
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            coverImage,
                            height: 300,
                            width: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 80);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'by $author',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Book Details Section
                  if (publicationYear != null || genre != null || publisher != null || language != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (publicationYear != null)
                          _bookDetailItem("Publication Year", publicationYear.toString(), textColor),
                        if (genre != null) _bookDetailItem("Genre", genre!, textColor),
                        if (publisher != null) _bookDetailItem("Publisher", publisher!, textColor),
                        if (language != null) _bookDetailItem("Language", language!, textColor),
                      ],
                    ),
                  const SizedBox(height: 16),
                  // Description
                  if (description != null)
                    Text(
                      description!,
                      style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.9)),
                    ),
                  const SizedBox(height: 16),
                  // Pages and Average Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (pages != null)
                        Text(
                          '$pages pages',
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: averageRating,
                            itemBuilder: (context, index) => Icon(Icons.star, color: highlightColor),
                            itemCount: 5,
                            itemSize: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$averageRating ($totalReviews reviews)',
                            style: TextStyle(fontSize: 14, color: textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Add a Review Section
                  Text(
                    'Add Your Review',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 12),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemBuilder: (context, index) => const Icon(Icons.star, color: highlightColor),
                    onRatingUpdate: (rating) {
                      print('New Rating: $rating');
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write your review...',
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print('Review submitted!');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: highlightColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bookDetailItem(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text('$label: $value', style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.9))),
    );
  }
}