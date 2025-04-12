import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iluvmusik/screens/home_screen.dart';
import 'package:iluvmusik/screens/explore_screen.dart';
import 'package:iluvmusik/screens/library_screen.dart';
import 'package:iluvmusik/widgets/bottom_nav_bar.dart';
import 'package:iluvmusik/widgets/mini_player.dart';
import 'package:iluvmusik/theme/app_theme.dart';
import '../models/song.dart';
import '../services/youtube_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class MusicProvider with ChangeNotifier {
  final _player = AudioPlayer();
  final _youtubeService = YoutubeService();
  Song? _currentSong;
  List<Song> _likedSongs = [];
  bool _isPlaying = false;
  double _position = 0;
  double _duration = 0;
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

  MusicProvider() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _player.positionStream.listen((position) {
      _position = position.inMilliseconds / 1000;
      notifyListeners();
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        _duration = duration.inMilliseconds / 1000;
        notifyListeners();
      }
    });

    _player.playingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });
  }

  Future<void> playSong(Song song) async {
    try {
      final streamUrl = await _youtubeService.getStreamUrl(song.id);
      if (streamUrl != null) {
        await _player.setUrl(streamUrl);
        _currentSong = song;
        _player.play();
        notifyListeners();
      }
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
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

  void seekTo(double position) {
    _player.seek(Duration(milliseconds: (position * 1000).round()));
  }

  void skipToNext() {
    // TODO: Implement playlist functionality
  }

  void skipToPrevious() {
    // TODO: Implement playlist functionality
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

  @override
  void dispose() {
    _player.dispose();
    _youtubeService.dispose();
    super.dispose();
  }
}
