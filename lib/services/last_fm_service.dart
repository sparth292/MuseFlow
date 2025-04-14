import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class LastFmService {
  static const String _baseUrl = 'http://ws.audioscrobbler.com/2.0/';
  static const String _apiKey =
      'YOUR_LASTFM_API_KEY'; // Replace with your Last.fm API key

  Future<List<Song>> searchSongs(String query) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl?method=track.search&track=$query&api_key=$_apiKey&format=json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final tracks = data['results']['trackmatches']['track'] as List;

      return tracks
          .map((track) => Song(
                id: track['mbid'] ?? '',
                title: track['name'] ?? '',
                artist: track['artist'] ?? '',
                thumbnailUrl: track['image']?[2]?['#text'] ?? '',
                youtubeUrl: '', // Last.fm doesn't provide video IDs
                duration:
                    '0:00', // Last.fm doesn't provide duration in search results
                isLiked: false,
              ))
          .toList();
    }

    return [];
  }

  void dispose() {
    // Clean up any resources if needed
  }
}
