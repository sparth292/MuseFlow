//playing imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iluvmusik/screens/home_screen.dart';
import 'package:iluvmusik/screens/explore_screen.dart';
import 'package:iluvmusik/screens/library_screen.dart';
import 'package:iluvmusik/widgets/mini_player.dart';
import 'package:iluvmusik/providers/music_provider.dart';
import 'package:iluvmusik/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// MuseFlow Auth Screens
import 'package:iluvmusik/screens/auth/splash_screen.dart';
import 'package:iluvmusik/screens/auth/login_screen.dart';
import 'package:iluvmusik/screens/auth/signup_screen.dart';
import 'package:iluvmusik/screens/auth/pin_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Supabase.initialize(
  //   url: 'https://qfqnzlvijvcjcxacxrfn.supabase.co',
  //   anonKey: 'your-anon-key',
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusicProvider(),
      child: MaterialApp(
        title: 'MuseFlow',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/pin': (context) => const PinVerificationScreen(),
          '/main': (context) => const HomeScreen(),
        },
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
      body: _screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          NavigationBar(
            height: 55,
            backgroundColor: Colors.black,
            indicatorColor: Colors.transparent,
            selectedIndex: _currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.grey, size: 24),
                selectedIcon: Icon(Icons.home, color: Color(0xFF00E5FF), size: 24),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.explore_outlined, color: Colors.grey, size: 24),
                selectedIcon: Icon(Icons.explore, color: Color(0xFF00E5FF), size: 24),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined, color: Colors.grey, size: 24),
                selectedIcon: Icon(Icons.library_music, color: Color(0xFF00E5FF), size: 24),
                label: 'Library',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
