import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/music_provider.dart';
import '../models/song.dart';
import '../services/youtube_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final YoutubeService _youtubeService = YoutubeService();
  List<Song> _searchResults = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final results = await _youtubeService.searchSongs(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to search songs. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search YouTube songs...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  ),
                  onChanged: (value) {
                    if (value.length >= 3) {
                      _performSearch(value);
                    }
                  },
                  onSubmitted: _performSearch,
                ),
              ),
            ),

            // Search results or initial state
            Expanded(
              child: _searchController.text.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for your favorite songs',
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.cyan),
                        )
                      : _error.isNotEmpty
                          ? Center(
                              child: Text(
                                _error,
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final song = _searchResults[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      song.thumbnailUrl,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 56,
                                          height: 56,
                                          color: Colors.grey[900],
                                          child: const Icon(
                                            Icons.music_note,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  title: Text(
                                    song.title,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    song.artist,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        song.duration,
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow,
                                            color: Colors.cyan),
                                        onPressed: () {
                                          context
                                              .read<MusicProvider>()
                                              .playSong(song);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _youtubeService.dispose();
    super.dispose();
  }
}
