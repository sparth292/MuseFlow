import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/song.dart';

class YoutubeService {
  final _yt = YoutubeExplode();

  Future<List<Song>> searchSongs(String query) async {
    try {
      final searchList = await _yt.search.search(query);
      return searchList
          .map((video) => Song(
                id: video.id.value,
                title: video.title,
                artist: video.author,
                thumbnailUrl: video.thumbnails.highResUrl,
                duration: video.duration?.toString() ?? '0:00',
                youtubeUrl: video.id.value,
                isLiked: false,
              ))
          .toList();
    } catch (e) {
      print('Error searching songs: $e');
      return [];
    }
  }

  Future<String?> getStreamUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioOnly = manifest.audioOnly;
      if (audioOnly.isNotEmpty) {
        return audioOnly.withHighestBitrate().url.toString();
      }
      return null;
    } catch (e) {
      print('Error getting stream URL: $e');
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
