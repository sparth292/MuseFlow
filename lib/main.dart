import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iluvmusik/screens/home_screen.dart';
import 'package:iluvmusik/screens/search_screen.dart';
import 'package:iluvmusik/screens/library_screen.dart';
import 'package:iluvmusik/widgets/bottom_nav_bar.dart';
import 'package:iluvmusik/widgets/mini_player.dart';
import 'package:iluvmusik/providers/music_provider.dart';
import 'package:iluvmusik/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusicProvider(),
      child: MaterialApp(
        title: 'iLuvMusik',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: AppTheme.primaryColor,
            secondary: AppTheme.accentColor,
            background: AppTheme.darkBackground,
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _screens[_currentIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MiniPlayer(),
                NavigationBar(
                  backgroundColor: Colors.black,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home, color: Colors.cyan),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.search_outlined),
                      selectedIcon: Icon(Icons.search, color: Colors.cyan),
                      label: 'Search',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.library_music_outlined),
                      selectedIcon:
                          Icon(Icons.library_music, color: Colors.cyan),
                      label: 'Library',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
