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
//import 'package:iluvmusik/screens/auth/pin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qfqnzlvijvcjcxacxrfn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFmcW56bHZpanZjamN4YWN4cmZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5MTExODUsImV4cCI6MjA2MDQ4NzE4NX0.jQoFQOWuWud-9CkHqVaum2qAzNIB2J1y6TfooqXpgXo',
  );
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
          //'/pin': (context) => const PinVerificationScreen(), // ✅ uncommented
          '/main': (context) => const MainScreen(),
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
        ],
      ),
    );
  }
}
