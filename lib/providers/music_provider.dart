import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iluvmusik/screens/home_screen.dart';
import 'package:iluvmusik/screens/explore_screen.dart';
import 'package:iluvmusik/screens/library_screen.dart';
import 'package:iluvmusik/widgets/bottom_nav_bar.dart';
import 'package:iluvmusik/widgets/mini_player.dart';
import 'package:iluvmusik/theme/app_theme.dart';
import '../models/song_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => MusicProvider()..initialize(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iLuvMusik',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
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
                MiniPlayer(),
                BottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MusicProvider extends ChangeNotifier {
  bool _isInitialized = false;
  Song? _currentSong;
  bool _isPlaying = false;
  double _position = 0.0;
  double _duration = 0.0;
  List<Song> _likedSongs = [];
  List<Song> _searchResults = [];
  String _searchQuery = '';
  bool _isLoading = false;

  // Getters
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  double get position => _position;
  double get duration => _duration;
  List<Song> get likedSongs => _likedSongs;
  List<Song> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  void initialize() {
    if (!_isInitialized) {
      // Add initialization logic here
      _isInitialized = true;
      notifyListeners();
    }
  }

  void playSong(Song song) {
    _currentSong = song;
    _isPlaying = true;
    notifyListeners();
  }

  void togglePlayPause() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void toggleLike() {
    if (_currentSong != null) {
      _currentSong!.isLiked = !_currentSong!.isLiked;
      if (_currentSong!.isLiked) {
        _likedSongs.add(_currentSong!);
      } else {
        _likedSongs.removeWhere((song) => song.id == _currentSong!.id);
      }
      notifyListeners();
    }
  }

  void seekTo(double duration) {
    _position = duration;
    notifyListeners();
  }

  void skipToNext() {
    // Implement skip to next song logic
    notifyListeners();
  }

  void skipToPrevious() {
    // Implement skip to previous song logic
    notifyListeners();
  }

  void searchSongs(String query) {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _isLoading = false;
      // Implement actual search logic here
      _searchResults = []; // Replace with actual search results
      notifyListeners();
    });
  }
}
