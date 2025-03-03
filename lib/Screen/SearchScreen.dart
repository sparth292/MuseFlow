import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  YoutubeExplode _ytExplode = YoutubeExplode();
  List<Map<String, dynamic>> searchResults = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Currently playing song info
  String _currentTitle = "";
  String _currentArtist = "";
  String _currentThumbnail = "";

  // Function to search for songs
  Future<void> _searchSongs(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    var searchResultsList = await _ytExplode.search.search(query);
    setState(() {
      searchResults = searchResultsList.map((video) {
        return {
          "title": video.title,
          "artist": video.author,
          "thumbnail": video.thumbnails.highResUrl,
          "videoId": video.id.value,
        };
      }).toList();
    });
  }

  // Function to play a selected song
  Future<void> _playSong(String videoId, String title, String artist, String thumbnail) async {
    if (videoId.isEmpty) return;

    try {
      var manifest = await _ytExplode.videos.streamsClient.getManifest(videoId);
      var bestAudioStream = manifest.audioOnly.withHighestBitrate();
      var audioUrl = bestAudioStream.url;

      // Print the audio URL for debugging
      print("Audio URL: $audioUrl");

      await _audioPlayer.setUrl(audioUrl.toString());
      _audioPlayer.play();

      setState(() {
        _currentTitle = title;
        _currentArtist = artist;
        _currentThumbnail = thumbnail;
      });
    } catch (e) {
      print("Error playing song: $e");
    }
  }



  @override
  void dispose() {
    _ytExplode.close();
    _audioPlayer.dispose();
    super.dispose();
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
              onSubmitted: _searchSongs, // Trigger search when Enter is pressed
            ),
          ),

          // Currently playing song UI
          if (_currentTitle.isNotEmpty)
            Card(
              margin: EdgeInsets.all(8.0),
              elevation: 4,
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl: _currentThumbnail,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(_currentTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_currentArtist),
                trailing: IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: () => _audioPlayer.pause(),
                ),
              ),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final song = searchResults[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: song["thumbnail"],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(song["title"]),
                  subtitle: Text(song["artist"]),
                  onTap: () => _playSong(song["videoId"], song["title"], song["artist"], song["thumbnail"]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
