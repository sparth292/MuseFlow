import 'package:flutter/material.dart';
import 'package:dart_ytmusic_api/yt_music.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  final YTMusic _ytMusic = YTMusic();
  List<Map<String, dynamic>> searchResults = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeYTMusic();
  }

  Future<void> _initializeYTMusic() async {
    await _ytMusic.initialize();
  }

  Future<void> _searchSongs(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final results = await _ytMusic.searchSongs(query);
    setState(() {
      searchResults = results.map((song) {
        return {
          "title": song.name,
          "artist": song.artist.name,
          "thumbnail": song.thumbnails.isNotEmpty ? song.thumbnails.first.url : "",
          "videoId": song.videoId,
        };
      }).toList();
    });
  }

  void _playSong(String videoId) async {
    if (videoId.isEmpty) return;
    try {
      await _audioPlayer.setUrl("https://music.youtube.com/watch?v=$videoId");
      _audioPlayer.play();
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Songs")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for a song...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchSongs,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final song = searchResults[index];
                return ListTile(
                  leading: song["thumbnail"].isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: song["thumbnail"],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : Icon(Icons.music_note, size: 50),
                  title: Text(song["title"]),
                  subtitle: Text(song["artist"]),
                  onTap: () => _playSong(song["videoId"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
