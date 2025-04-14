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
import '../services/database_helper.dart';
import '../services/last_fm_service.dart';

class MusicProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final YoutubeService _youtubeService = YoutubeService();
  final AudioPlayer _player = AudioPlayer();

  List<Song> _likedSongs = [];
  List<Song> _searchResults = [];
  List<Song> _queue = [];
  int _currentQueueIndex = -1;
  Song? _currentSong;
  bool _isLoading = false;
  bool _isPlaying = false;
  double _position = 0;
  double _duration = 0;
  String _searchQuery = '';

  // Getters
  List<Song> get likedSongs => _likedSongs;
  List<Song> get searchResults => _searchResults;
  List<Song> get queue => _queue;
  Song? get currentSong => _currentSong;
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  double get position => _position;
  double get duration => _duration;
  String get searchQuery => _searchQuery;

  MusicProvider() {
    _initializePlayer();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      // Load liked songs from database
      final songs = await _dbHelper.getLikedSongs();
      _likedSongs = songs.map((song) => song.copyWith(isLiked: true)).toList();
      notifyListeners();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  void _initializePlayer() {
    // Listen to player state changes
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    // Listen to position changes
    _player.positionStream.listen((position) {
      _position = position.inMilliseconds / 1000;
      notifyListeners();
    });

    // Listen to duration changes
    _player.durationStream.listen((duration) {
      _duration = (duration?.inMilliseconds ?? 0) / 1000;
      notifyListeners();
    });

    // Listen to song completion to play next song
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  Future<void> playSong(Song song) async {
    try {
      // Check if the song is already in the queue
      int existingIndex = _queue.indexWhere((s) => s.id == song.id);

      if (existingIndex == -1) {
        // Add to queue if not already present
        _queue.add(song);
        _currentQueueIndex = _queue.length - 1;
      } else {
        // Play the existing song in queue
        _currentQueueIndex = existingIndex;
      }

      // Get stream URL and play
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

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> skipToNext() async {
    if (_currentQueueIndex < _queue.length - 1) {
      _currentQueueIndex++;
      await playSong(_queue[_currentQueueIndex]);
    }
  }

  Future<void> skipToPrevious() async {
    if (_currentQueueIndex > 0) {
      _currentQueueIndex--;
      await playSong(_queue[_currentQueueIndex]);
    }
  }

  Future<void> seekTo(double seconds) async {
    await _player.seek(Duration(milliseconds: (seconds * 1000).round()));
  }

  Future<void> toggleLikeSong(Song song) async {
    try {
      final isLiked = await _dbHelper.isSongLiked(song.id);

      if (isLiked) {
        await _dbHelper.deleteSong(song.id);
        _likedSongs.removeWhere((s) => s.id == song.id);

        // Update current song if it's the same
        if (_currentSong?.id == song.id) {
          _currentSong = _currentSong!.copyWith(isLiked: false);
        }

        // Update queue if song exists
        int queueIndex = _queue.indexWhere((s) => s.id == song.id);
        if (queueIndex != -1) {
          _queue[queueIndex] = _queue[queueIndex].copyWith(isLiked: false);
        }
      } else {
        final likedSong = song.copyWith(isLiked: true);
        await _dbHelper.insertSong(likedSong);
        _likedSongs.add(likedSong);

        // Update current song if it's the same
        if (_currentSong?.id == song.id) {
          _currentSong = _currentSong!.copyWith(isLiked: true);
        }

        // Update queue if song exists
        int queueIndex = _queue.indexWhere((s) => s.id == song.id);
        if (queueIndex != -1) {
          _queue[queueIndex] = _queue[queueIndex].copyWith(isLiked: true);
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> toggleLike() async {
    if (_currentSong != null) {
      await toggleLikeSong(_currentSong!);
    }
  }

  Future<void> addToQueue(Song song) async {
    _queue.add(song);
    notifyListeners();
  }

  void clearQueue() {
    _queue.clear();
    _currentQueueIndex = -1;
    notifyListeners();
  }

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final songs = await _youtubeService.searchSongs(query);

      // Check if each song is liked
      final updatedSongs = await Future.wait(
        songs.map((song) async {
          final isLiked = await _dbHelper.isSongLiked(song.id);
          return song.copyWith(isLiked: isLiked);
        }),
      );

      _searchResults = updatedSongs;
    } catch (e) {
      print('Error searching songs: $e');
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void stopSong() {
    _currentSong = null;
    _isPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
