import 'package:flutter/foundation.dart';
import '../models/song_model.dart';
import '../services/lastfm_service.dart';
import '../services/youtube_service.dart';

class MusicProvider with ChangeNotifier {
  final LastFmService _lastfmService = LastFmService();
  final YouTubeService _youtubeService = YouTubeService();

  SongModel? _currentSong;
  List<SongModel> _recentlyPlayed = [];
  List<SongModel> _likedSongs = [];
  List<SongModel> _searchResults = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String _error = '';

  // Getters
  SongModel? get currentSong => _currentSong;
  List<SongModel> get recentlyPlayed => _recentlyPlayed;
  List<SongModel> get likedSongs => _likedSongs;
  List<SongModel> get searchResults => _searchResults;
  String get searchQuery => _searchQuery;
  bool get isPlaying => _youtubeService.isPlaying;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isLastFmAuthorized => _lastfmService.isAuthorized;
  Duration get position => _youtubeService.position;
  Duration get duration => _youtubeService.duration;
  YouTubeService get youtubeService => _youtubeService;

  // Initialize the provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _lastfmService.initialize();

      if (_lastfmService.isAuthorized) {
        await Future.wait([
          _loadLovedTracks(),
          _loadRecentTracks(),
        ]);
      }
    } catch (e) {
      _error = 'Failed to initialize: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load loved tracks from Last.fm
  Future<void> _loadLovedTracks() async {
    try {
      _likedSongs = await _lastfmService.getLovedTracks();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load loved tracks: $e';
      notifyListeners();
    }
  }

  // Load recent tracks from Last.fm
  Future<void> _loadRecentTracks() async {
    try {
      _recentlyPlayed = await _lastfmService.getRecentTracks();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load recent tracks: $e';
      notifyListeners();
    }
  }

  // Search for tracks
  Future<void> searchSongs(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _youtubeService.searchSongs(query);
    } catch (e) {
      _error = 'Failed to search tracks: $e';
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Play a song
  Future<void> playSong(SongModel song) async {
    _currentSong = song;

    try {
      await _youtubeService.playSong(song);

      // Add to recently played if not already there
      if (!_recentlyPlayed.any((s) => s.id == song.id)) {
        _recentlyPlayed.insert(0, song);
        if (_recentlyPlayed.length > 20) {
          _recentlyPlayed.removeLast();
        }
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to play song: $e';
      notifyListeners();
    }
  }

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    try {
      await _youtubeService.togglePlayPause();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to toggle play/pause: $e';
      notifyListeners();
    }
  }

  // Toggle like status
  Future<void> toggleLike() async {
    if (_currentSong == null) return;

    try {
      if (_currentSong!.isLiked) {
        final success = await _lastfmService.unloveTrack(
          _currentSong!.artist,
          _currentSong!.title,
        );

        if (success) {
          _currentSong = _currentSong!.copyWith(isLiked: false);
          _likedSongs.removeWhere((s) => s.id == _currentSong!.id);
        }
      } else {
        final success = await _lastfmService.loveTrack(
          _currentSong!.artist,
          _currentSong!.title,
        );

        if (success) {
          _currentSong = _currentSong!.copyWith(isLiked: true);
          _likedSongs.insert(0, _currentSong!);
        }
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to toggle like status: $e';
      notifyListeners();
    }
  }

  // Skip to next track
  Future<void> skipToNext() async {
    try {
      await _youtubeService.skipToNext();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to skip to next track: $e';
      notifyListeners();
    }
  }

  // Skip to previous track
  Future<void> skipToPrevious() async {
    try {
      await _youtubeService.skipToPrevious();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to skip to previous track: $e';
      notifyListeners();
    }
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    _youtubeService.seekTo(position);
    notifyListeners();
  }

  // Get Last.fm authorization URL
  Future<String> getLastFmAuthUrl() async {
    return await _lastfmService.getAuthorizationUrl();
  }

  // Complete Last.fm authorization
  Future<bool> completeLastFmAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _lastfmService.completeAuthorization();

      if (success) {
        await Future.wait([
          _loadLovedTracks(),
          _loadRecentTracks(),
        ]);
      }

      return success;
    } catch (e) {
      _error = 'Failed to complete authorization: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Dispose resources
  @override
  void dispose() {
    _youtubeService.dispose();
    super.dispose();
  }
}
