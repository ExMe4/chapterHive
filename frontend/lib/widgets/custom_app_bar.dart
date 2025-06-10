import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const CustomAppBar({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      backgroundColor: const Color(0xFFFFD700),
      expandedHeight: 60,
      automaticallyImplyLeading: false,
      elevation: 4,
      shadowColor: Colors.black.withAlpha((0.9 * 255).toInt()),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 7.0),
                title: Text(
                  "ChapterHive",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -2,
                    fontFamily: 'Merriweather',
                  ),
                ),
                centerTitle: true,
              ),
              Positioned(
                left: 8,
                top: topPadding + 8,
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 22),
                  onPressed: onMenuPressed,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
