import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import '../models/song_model.dart';

class LastFmService {
  static const String _apiKey = 'YOUR_API_KEY'; // Replace with your API key
  static const String _sharedSecret =
      'YOUR_SHARED_SECRET'; // Replace with your shared secret
  static const String _sessionKeyPref = 'lastfm_session_key';
  static const String _usernamePref = 'lastfm_username';
  static const String _baseUrl = 'https://ws.audioscrobbler.com/2.0/';

  String? _sessionKey;
  String? _username;
  bool _isAuthorized = false;

  // Singleton pattern
  static final LastFmService _instance = LastFmService._internal();
  factory LastFmService() => _instance;
  LastFmService._internal();

  // Initialize the service
  Future<void> initialize() async {
    // Check if we have a saved session key
    final prefs = await SharedPreferences.getInstance();
    _sessionKey = prefs.getString(_sessionKeyPref);
    _username = prefs.getString(_usernamePref);

    if (_sessionKey != null && _sessionKey!.isNotEmpty && _username != null) {
      _isAuthorized = true;
    }
  }

  // Get authorization URL for desktop authorization
  Future<String> getAuthorizationUrl() async {
    final token = await _getToken();
    return 'https://www.last.fm/api/auth/?api_key=$_apiKey&token=$token';
  }

  // Get token for authorization
  Future<String> _getToken() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?method=auth.getToken&api_key=$_apiKey&format=json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      throw Exception('Failed to get token: ${response.statusCode}');
    }
  }

  // Complete desktop authorization
  Future<bool> completeAuthorization() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?method=auth.getSession&api_key=$_apiKey&token=$token&format=json'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _sessionKey = data['session']['key'];
        _username = data['session']['name'];

        // Save the session key and username
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_sessionKeyPref, _sessionKey!);
        await prefs.setString(_usernamePref, _username!);

        _isAuthorized = true;
        return true;
      }
    } catch (e) {
      print('Error completing authorization: $e');
    }

    return false;
  }

  // Check if the service is authorized
  bool get isAuthorized => _isAuthorized;

  // Make an API request
  Future<XmlDocument> _makeRequest(
      String method, Map<String, String> params) async {
    final queryParams = {
      'method': method,
      'api_key': _apiKey,
      'format': 'xml',
      ...params,
    };

    if (_isAuthorized && _sessionKey != null) {
      queryParams['sk'] = _sessionKey!;
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return XmlDocument.parse(response.body);
    } else {
      throw Exception('Failed to make request: ${response.statusCode}');
    }
  }

  // Search for tracks
  Future<List<Song>> searchTracks(String query) async {
    try {
      final response = await _makeRequest('track.search', {'track': query});
      return _parseSearchResults(response);
    } catch (e) {
      print('Error searching tracks: $e');
      return [];
    }
  }

  // Get track info
  Future<Song?> getTrackInfo(String artist, String track) async {
    try {
      final response = await _makeRequest(
        'track.getInfo',
        {'artist': artist, 'track': track},
      );

      return _parseTrackInfo(response);
    } catch (e) {
      print('Error getting track info: $e');
      return null;
    }
  }

  // Love a track
  Future<bool> loveTrack(String artist, String track) async {
    if (!_isAuthorized) return false;

    try {
      await _makeRequest(
        'track.love',
        {'artist': artist, 'track': track},
      );
      return true;
    } catch (e) {
      print('Error loving track: $e');
      return false;
    }
  }

  // Unlove a track
  Future<bool> unloveTrack(String artist, String track) async {
    if (!_isAuthorized) return false;

    try {
      await _makeRequest(
        'track.unlove',
        {'artist': artist, 'track': track},
      );
      return true;
    } catch (e) {
      print('Error unloving track: $e');
      return false;
    }
  }

  // Get user's loved tracks
  Future<List<Song>> getLovedTracks() async {
    if (!_isAuthorized) return [];

    try {
      final response = await _makeRequest('user.getLovedTracks', {});
      return _parseLovedTracks(response);
    } catch (e) {
      print('Error getting loved tracks: $e');
      return [];
    }
  }

  // Get user's recent tracks
  Future<List<Song>> getRecentTracks() async {
    if (!_isAuthorized) return [];

    try {
      final response = await _makeRequest('user.getRecentTracks', {});
      return _parseRecentTracks(response);
    } catch (e) {
      print('Error getting recent tracks: $e');
      return [];
    }
  }

  // Parse search results
  List<Song> _parseSearchResults(XmlDocument response) {
    final tracks = <Song>[];

    try {
      final trackElements = response.findAllElements('track');

      for (final trackElement in trackElements) {
        final name = trackElement.findElements('name').first.text;
        final artist = trackElement.findElements('artist').first.text;
        final imageElements = trackElement.findElements('image');

        String? thumbnailUrl;
        for (final imageElement in imageElements) {
          if (imageElement.getAttribute('size') == 'large') {
            thumbnailUrl = imageElement.text;
            break;
          }
        }

        if (thumbnailUrl == null && imageElements.isNotEmpty) {
          thumbnailUrl = imageElements.last.text;
        }

        tracks.add(Song(
          id: '${artist}_$name',
          title: name,
          artist: artist,
          thumbnailUrl: thumbnailUrl ?? 'https://via.placeholder.com/300',
          isLiked: false,
        ));
      }
    } catch (e) {
      print('Error parsing search results: $e');
    }

    return tracks;
  }

  // Parse track info
  Song? _parseTrackInfo(XmlDocument response) {
    try {
      final trackElement = response.findElements('track').first;
      final name = trackElement.findElements('name').first.text;
      final artist = trackElement.findElements('artist').first.text;
      final imageElements = trackElement.findElements('image');

      String? thumbnailUrl;
      for (final imageElement in imageElements) {
        if (imageElement.getAttribute('size') == 'large') {
          thumbnailUrl = imageElement.text;
          break;
        }
      }

      if (thumbnailUrl == null && imageElements.isNotEmpty) {
        thumbnailUrl = imageElements.last.text;
      }

      final isLiked = trackElement.findElements('userloved').first.text == '1';

      return Song(
        id: '${artist}_$name',
        title: name,
        artist: artist,
        thumbnailUrl: thumbnailUrl ?? 'https://via.placeholder.com/300',
        isLiked: isLiked,
      );
    } catch (e) {
      print('Error parsing track info: $e');
      return null;
    }
  }

  // Parse loved tracks
  List<Song> _parseLovedTracks(XmlDocument response) {
    final tracks = <Song>[];

    try {
      final trackElements = response.findAllElements('track');

      for (final trackElement in trackElements) {
        final name = trackElement.findElements('name').first.text;
        final artist = trackElement.findElements('artist').first.text;
        final imageElements = trackElement.findElements('image');

        String? thumbnailUrl;
        for (final imageElement in imageElements) {
          if (imageElement.getAttribute('size') == 'large') {
            thumbnailUrl = imageElement.text;
            break;
          }
        }

        if (thumbnailUrl == null && imageElements.isNotEmpty) {
          thumbnailUrl = imageElements.last.text;
        }

        tracks.add(Song(
          id: '${artist}_$name',
          title: name,
          artist: artist,
          thumbnailUrl: thumbnailUrl ?? 'https://via.placeholder.com/300',
          isLiked: true,
        ));
      }
    } catch (e) {
      print('Error parsing loved tracks: $e');
    }

    return tracks;
  }

  // Parse recent tracks
  List<Song> _parseRecentTracks(XmlDocument response) {
    final tracks = <Song>[];

    try {
      final trackElements = response.findAllElements('track');

      for (final trackElement in trackElements) {
        final name = trackElement.findElements('name').first.text;
        final artist = trackElement.findElements('artist').first.text;
        final imageElements = trackElement.findElements('image');

        String? thumbnailUrl;
        for (final imageElement in imageElements) {
          if (imageElement.getAttribute('size') == 'large') {
            thumbnailUrl = imageElement.text;
            break;
          }
        }

        if (thumbnailUrl == null && imageElements.isNotEmpty) {
          thumbnailUrl = imageElements.last.text;
        }

        tracks.add(Song(
          id: '${artist}_$name',
          title: name,
          artist: artist,
          thumbnailUrl: thumbnailUrl ?? 'https://via.placeholder.com/300',
          isLiked: false,
        ));
      }
    } catch (e) {
      print('Error parsing recent tracks: $e');
    }

    return tracks;
  }
}
