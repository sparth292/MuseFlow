import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iluvmusik/screens/home_screen.dart';
import 'package:iluvmusik/screens/explore_screen.dart';
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
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
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
    ExploreScreen(),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[900]!,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: NavigationBar(
                    height: 60,
                    backgroundColor: Colors.black,
                    indicatorColor: Colors.transparent,
                    selectedIndex: _currentIndex,
                    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                    onDestinationSelected: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    destinations: [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined, color: Colors.grey),
                        selectedIcon: Icon(Icons.home, color: Color(0xFF00E5FF)),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.explore_outlined, color: Colors.grey),
                        selectedIcon: Icon(Icons.explore, color: Color(0xFF00E5FF)),
                        label: 'Explore',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.library_music_outlined, color: Colors.grey),
                        selectedIcon: Icon(Icons.library_music, color: Color(0xFF00E5FF)),
                        label: 'Library',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
