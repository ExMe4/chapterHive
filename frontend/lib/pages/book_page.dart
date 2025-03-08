import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../utils/strings.dart';

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
  final String? authorImage;
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
    this.authorImage,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final Color cardColor = (isDarkMode ? Colors.grey[900] : Colors.grey[200])!;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    const highlightColor = Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.bookDetails, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookHeader(cardColor, textColor),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildRatingCard(cardColor, textColor, highlightColor)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildAuthorCard(cardColor, textColor, highlightColor, context)),
                    ],
                  ),
                  _buildDetailsCard(cardColor, textColor),
                  if (description != null) _buildSynopsisCard(cardColor, textColor),
                  _buildCommentSection(cardColor, textColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookHeader(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                coverImage,
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(Color cardColor, Color textColor, Color highlightColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.averageRating, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: RatingBarIndicator(
                    rating: averageRating,
                    itemCount: 5,
                    itemSize: 20,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Icon(Icons.star, color: highlightColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  averageRating.toString(),
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '($totalReviews ${AppStrings.totalReviews})',
              style: TextStyle(fontSize: 16, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorCard(Color cardColor, Color textColor, Color highlightColor, BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (authorImage != null)
              ClipOval(
                child: Image.network(
                  authorImage!,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/authorPage', arguments: author);
                },
                child: Text(
                  '${AppStrings.byAuthor} $author',
                  style: TextStyle(fontSize: 16, color: highlightColor, decoration: TextDecoration.underline),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (publicationYear != null) _bookDetailItem(AppStrings.publicationYear, publicationYear.toString(), textColor),
            if (genre != null) _bookDetailItem(AppStrings.genre, genre!, textColor),
            if (publisher != null) _bookDetailItem(AppStrings.publisher, publisher!, textColor),
            if (language != null) _bookDetailItem(AppStrings.language, language!, textColor),
            if (pages != null) _bookDetailItem(AppStrings.pages, '$pages', textColor),
          ],
        ),
      ),
    );
  }

  Widget _bookDetailItem(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text('$label: $value', style: TextStyle(fontSize: 16, color: textColor.withAlpha((0.9 * 255).toInt()))),
    );
  }

  Widget _buildSynopsisCard(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(description!, style: TextStyle(fontSize: 16, color: textColor.withAlpha((0.9 * 255).toInt()))),
      ),
    );
  }

  Widget _buildCommentSection(Color cardColor, Color textColor) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.addYourReview, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: AppStrings.writeReviewHint,
                hintStyle: TextStyle(color: textColor.withAlpha((0.6 * 255).toInt())),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text(AppStrings.post),
            ),
          ],
        ),
      ),
    );
  }
}
