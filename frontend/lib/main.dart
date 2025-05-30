import 'package:flutter/material.dart';
import 'package:frontend/pages/splash_wrapper.dart';
import 'pages/author_page.dart';
import 'pages/explore_page.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_drawer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  await dotenv.load();
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
      home: const SplashWrapper(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _currentRoute = '/';

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  Widget _getCurrentPage() {
    switch (_currentRoute) {
      case '/authorPage':
        return const AuthorPage();
      default:
        return const ExplorePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CustomAppBar(onMenuPressed: _openDrawer),
        ],
        body: _getCurrentPage(),
      ),
    );
  }
}
