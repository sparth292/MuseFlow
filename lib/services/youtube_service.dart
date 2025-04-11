import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/song_model.dart';

class YouTubeService {
  final YoutubeExplode _yt = YoutubeExplode();
  YoutubePlayerController? _controller;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // Get current player controller
  YoutubePlayerController? get controller => _controller;

  // Get current playback state
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;

  // Search for songs
  Future<List<Song>> searchSongs(String query) async {
    try {
      final searchResults = await _yt.search.search(query);
      final songs = <Song>[];

      for (final video in searchResults.take(20)) {
        songs.add(Song.fromYouTube(
          videoId: video.id.value,
          title: video.title,
          artist: video.author,
          thumbnailUrl: video.thumbnails.highResUrl,
        ));
      }

      return songs;
    } catch (e) {
      print('Error searching songs: $e');
      return [];
    }
  }

  // Initialize player for a song
  Future<void> initializePlayer(Song song) async {
    if (song.id.isEmpty) return;

    // Dispose existing controller if any
    await dispose();

    // Create new controller
    _controller = YoutubePlayerController(
      initialVideoId: song.id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        isLive: false,
      ),
    );

    // Add listeners
    _controller!.addListener(_onPlayerStateChange);
    _isPlaying = true;
  }

  // Handle player state changes
  void _onPlayerStateChange() {
    if (_controller == null) return;

    final playerState = _controller!.value.playerState;
    _position = _controller!.value.position;
    _duration = _controller!.value.metaData.duration ?? Duration.zero;

    switch (playerState) {
      case PlayerState.playing:
        _isPlaying = true;
        break;
      case PlayerState.paused:
        _isPlaying = false;
        break;
      case PlayerState.ended:
        _isPlaying = false;
        break;
      default:
        break;
    }
  }

  // Play song
  Future<void> playSong(Song song) async {
    await initializePlayer(song);
  }

  // Pause song
  Future<void> pauseSong() async {
    if (_controller != null) {
      _controller!.pause();
      _isPlaying = false;
    }
  }

  // Resume song
  Future<void> resumeSong() async {
    if (_controller != null) {
      _controller!.play();
      _isPlaying = true;
    }
  }

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_controller == null) return;

    if (_isPlaying) {
      await pauseSong();
    } else {
      await resumeSong();
    }
  }

  // Seek to position
  void seekTo(Duration position) {
    if (_controller != null) {
      _controller!.seekTo(position);
    }
  }

  // Skip to next song
  Future<void> skipToNext() async {
    // TODO: Implement playlist functionality
  }

  // Skip to previous song
  Future<void> skipToPrevious() async {
    // TODO: Implement playlist functionality
  }

  // Dispose resources
  Future<void> dispose() async {
    _controller?.dispose();
    _controller = null;
    _isPlaying = false;
    _position = Duration.zero;
    _duration = Duration.zero;
  }
}
