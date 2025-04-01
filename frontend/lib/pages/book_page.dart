import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:translator/translator.dart';
import '../utils/strings.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class BookPage extends StatefulWidget {
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

  static const highlightColor = Color(0xFFFFD700);

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
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  bool showDetailsList = false;
  bool _isExpanded = false;
  bool _isTranslated = false;
  String? translatedDescription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleDetails() {
    setState(() {
      showDetailsList = !showDetailsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;

    return Scaffold(
      drawer: CustomDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CustomAppBar(onMenuPressed: () => _scaffoldKey.currentState?.openDrawer()),
        ],
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                widget.coverImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withAlpha((0.5 * 255).toInt())),
            ),
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBookHeader(textColor),
                        _buildInfoSection(textColor),
                        _buildLineSeparator(),
                        GestureDetector(
                          onTap: _toggleDetails,
                          child: showDetailsList
                              ? _buildDetailsList(textColor)
                              : _buildDetailsGrid(textColor),
                        ),
                        _buildLineSeparator(),
                        if (widget.description != null) _buildDescriptionCard(textColor),
                        _buildCommentSection(textColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookHeader(Color textColor) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Center(
              child: Image.network(
                widget.coverImage,
                height: 200,
                width: 140,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildRatingCard(textColor, BookPage.highlightColor)),
        const SizedBox(width: 12),
        Expanded(child: _buildAuthorCard(textColor)),
      ],
    );
  }

  Widget _buildRatingCard(Color textColor, Color highlightColor) {
    return _buildCard(
      child: SizedBox(
        height: 60,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBarIndicator(
                  rating: widget.averageRating,
                  itemCount: 5,
                  itemSize: 16,
                  itemBuilder: (context, index) => Icon(Icons.star, color: highlightColor),
                ),
                const SizedBox(width: 8),
                Text(widget.averageRating.toString(), style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text('(${widget.totalReviews} ${AppStrings.totalReviews})', style: TextStyle(fontSize: 16, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorCard(Color textColor) {
    return _buildCard(
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/authorPage',
                    arguments: {
                      'name': widget.author,
                      'image': widget.authorImage,
                    },
                  );
                },
                child: Text(
                  widget.author,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BookPage.highlightColor,
                  ),
                ),
              ),
            ),
            if (widget.authorImage != null) ...[
              const SizedBox(width: 12),
              ClipOval(
                child: Image.network(
                  widget.authorImage!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(flex: 3, child: _buildGridCard(widget.publicationYear?.toString() ?? "-", textColor, "Year")),
              const SizedBox(width: 12),
              Flexible(flex: 2, child: _buildGridCard(_getLanguageFlag(), textColor, "", showOnlyFlag: true)),
              const SizedBox(width: 12),
              Flexible(
                flex: 3,
                child: _buildGridCard(
                  widget.publisher != null && widget.publisher!.length > 8
                      ? "${widget.publisher!.substring(0, 8)}..."
                      : widget.publisher ?? "-",
                  textColor,
                  "Publisher",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildGridCard(widget.genre ?? "-", textColor, "Genre", isWide: true),
          const SizedBox(height: 10),
          _buildGridCard(widget.pages == 0 ? AppStrings.pageNumberUnknown : "${widget.pages} ${AppStrings.pages}", textColor, "Pages")
        ],
      ),
    );
  }

  Widget _buildDetailsList(Color textColor) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.bookDetails,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          _bookDetailItem(AppStrings.title, widget.title, textColor),
          _bookDetailItem(AppStrings.author, widget.author, textColor),
          _bookDetailItem(AppStrings.publicationYear, widget.publicationYear?.toString() ?? "-", textColor),
          _bookDetailItem(AppStrings.language, _getLanguageName(), textColor),
          _bookDetailItem(AppStrings.publisher, widget.publisher ?? "-", textColor),
          _bookDetailItem(AppStrings.genre, widget.genre ?? "-", textColor),
          _bookDetailItem(AppStrings.pages, widget.pages?.toString() ?? "-", textColor),
        ],
      ),
    );
  }

  Widget _bookDetailItem(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: textColor.withAlpha((0.9 * 255).toInt())),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(Color textColor) {
    if (widget.description == null || widget.description!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              final textToShow = translatedDescription ?? widget.description!;
              final isOverflowing = textToShow.length >
                  300;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      textToShow,
                      maxLines: _isExpanded ? null : 5,
                      overflow: _isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: textColor.withAlpha((0.9 * 255).toInt()),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isOverflowing)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? AppStrings.readLess : AppStrings
                                .readMore,
                            style: TextStyle(
                              color: BookPage.highlightColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      TextButton.icon(
                        onPressed: _translateDescription,
                        icon: Icon(
                            Icons.translate, color: BookPage.highlightColor),
                        label: Text(
                          _isTranslated ? AppStrings.showOriginal : AppStrings
                              .translate,
                          style: TextStyle(
                            color: BookPage.highlightColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }


  void _translateDescription() async {
    if (_isTranslated) {
      setState(() {
        translatedDescription = null;
        _isTranslated = false;
      });
      return;
    }

    if (widget.description == null || widget.description!.isEmpty) return;

    final translator = GoogleTranslator();
    String description = widget.description!;

    String userLanguage = Platform.localeName.split('_')[0];

    try {
      Translation translated = await translator.translate(description, to: userLanguage);

      setState(() {
        translatedDescription = "${AppStrings.translated} ${translated.text}";
        _isTranslated = true;
      });
    } catch (e) {
      print("Translation failed: $e");
    }
  }


  Widget _buildCommentSection(Color textColor) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.addYourReview, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: AppStrings.writeReviewHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageFlag() {
    String? langCode = widget.language?.toLowerCase().substring(0, 2);

    switch (langCode) {
      case "en": return "🇬🇧"; // English
      case "zh": return "🇨🇳"; // Chinese
      case "es": return "🇪🇸"; // Spanish
      case "fr": return "🇫🇷"; // French
      case "de": return "🇩🇪"; // German
      case "ar": return "🇸🇦"; // Arabic
      case "ru": return "🇷🇺"; // Russian
      case "pt": return "🇵🇹"; // Portuguese
      case "ja": return "🇯🇵"; // Japanese
      case "it": return "🇮🇹"; // Italian
      case "hi": return "🇮🇳"; // Hindi
      case "bn": return "🇧🇩"; // Bengali
      case "pa": return "🇮🇳"; // Punjabi
      case "nl": return "🇳🇱"; // Dutch
      case "tr": return "🇹🇷"; // Turkish
      case "vi": return "🇻🇳"; // Vietnamese
      case "pl": return "🇵🇱"; // Polish
      case "sv": return "🇸🇪"; // Swedish
      case "ko": return "🇰🇷"; // Korean
      case "th": return "🇹🇭"; // Thai
      case "he": return "🇮🇱"; // Hebrew
      case "uk": return "🇺🇦"; // Ukrainian
      case "id": return "🇮🇩"; // Indonesian
      case "ro": return "🇷🇴"; // Romanian
      case "fa": return "🇮🇷"; // Persian (Farsi)
      case "cs": return "🇨🇿"; // Czech
      case "el": return "🇬🇷"; // Greek
      case "fi": return "🇫🇮"; // Finnish
      case "hu": return "🇭🇺"; // Hungarian
      case "da": return "🇩🇰"; // Danish
      case "no": return "🇳🇴"; // Norwegian
      case "bg": return "🇧🇬"; // Bulgarian
      case "ms": return "🇲🇾"; // Malay
      case "sr": return "🇷🇸"; // Serbian
      case "lt": return "🇱🇹"; // Lithuanian
      case "sk": return "🇸🇰"; // Slovak
      case "hr": return "🇭🇷"; // Croatian
      case "sl": return "🇸🇮"; // Slovenian
      case "ca": return "🇪🇸"; // Catalan
      case "eu": return "🇪🇸"; // Basque
      case "gl": return "🇪🇸"; // Galician
      case "ta": return "🇮🇳"; // Tamil
      case "te": return "🇮🇳"; // Telugu
      case "mr": return "🇮🇳"; // Marathi
      case "ur": return "🇵🇰"; // Urdu
      case "et": return "🇪🇪"; // Estonian
      case "lv": return "🇱🇻"; // Latvian
      case "is": return "🇮🇸"; // Icelandic
      case "ka": return "🇬🇪"; // Georgian
      case "hy": return "🇦🇲"; // Armenian
      case "az": return "🇦🇿"; // Azerbaijani
      case "sw": return "🇰🇪"; // Swahili
      case "af": return "🇿🇦"; // Afrikaans
      default: return "🌍";
    }
  }

  String _getLanguageName() {
    String? langCode = widget.language?.toLowerCase().substring(0, 2);

    switch (langCode) {
      case "en": return "English";
      case "zh": return "Chinese";
      case "es": return "Spanish";
      case "fr": return "French";
      case "de": return "German";
      case "ar": return "Arabic";
      case "ru": return "Russian";
      case "pt": return "Portuguese";
      case "ja": return "Japanese";
      case "it": return "Italian";
      case "hi": return "Hindi";
      case "bn": return "Bengali";
      case "pa": return "Punjabi";
      case "nl": return "Dutch";
      case "tr": return "Turkish";
      case "vi": return "Vietnamese";
      case "pl": return "Polish";
      case "sv": return "Swedish";
      case "ko": return "Korean";
      case "th": return "Thai";
      case "he": return "Hebrew";
      case "uk": return "Ukrainian";
      case "id": return "Indonesian";
      case "ro": return "Romanian";
      case "fa": return "Persian (Farsi)";
      case "cs": return "Czech";
      case "el": return "Greek";
      case "fi": return "Finnish";
      case "hu": return "Hungarian";
      case "da": return "Danish";
      case "no": return "Norwegian";
      case "bg": return "Bulgarian";
      case "ms": return "Malay";
      case "sr": return "Serbian";
      case "lt": return "Lithuanian";
      case "sk": return "Slovak";
      case "hr": return "Croatian";
      case "sl": return "Slovenian";
      case "ca": return "Catalan";
      case "eu": return "Basque";
      case "gl": return "Galician";
      case "ta": return "Tamil";
      case "te": return "Telugu";
      case "mr": return "Marathi";
      case "ur": return "Urdu";
      case "et": return "Estonian";
      case "lv": return "Latvian";
      case "is": return "Icelandic";
      case "ka": return "Georgian";
      case "hy": return "Armenian";
      case "az": return "Azerbaijani";
      case "sw": return "Swahili";
      case "af": return "Afrikaans";
      default: return widget.language ?? "-";
    }
  }


  Widget _buildLineSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: BookPage.highlightColor.withAlpha((0.60 * 255).toInt()),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildGridCard(String value, Color textColor, String label, {bool isWide = false, bool showOnlyFlag = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      constraints: const BoxConstraints(minWidth: double.infinity),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha((0.45 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          showOnlyFlag ? value : value,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      color: Colors.black.withAlpha((0.25 * 255).toInt()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16.0), child: child),
    );
  }
}
