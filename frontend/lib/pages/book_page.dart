import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookPage extends StatelessWidget {
  final String title;
  final String author;
  final String coverImage;
  final int pages;
  final double averageRating;
  final int totalReviews;
  final bool isDarkMode;

  const BookPage({
    super.key,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.pages,
    required this.averageRating,
    required this.totalReviews,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic background color based on theme
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    const highlightColor = Color(0xFFFFD700); // yellow

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover and Title
            Center(
              child: Column(
                children: [
                  // Book Cover
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      coverImage,
                      height: 200,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Book Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Book Author
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
            // Pages and Average Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Total Pages
                Text(
                  '$pages pages',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                // Average Rating
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: averageRating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: highlightColor,
                      ),
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
            // Add a Review
            Text(
              'Add Your Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: highlightColor,
              ),
              onRatingUpdate: (rating) {
                // TODO: Save the rating
                print('New Rating: $rating');
              },
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review...',
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey[800]
                    : Colors.grey[200], // Light or dark text box
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Submit the review
                print('Review submitted!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: highlightColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
