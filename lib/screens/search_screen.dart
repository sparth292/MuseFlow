import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/music_provider.dart';
import '../models/song.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = Provider.of<MusicProvider>(context, listen: false);
    provider.searchSongs(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search songs, artists, or albums',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Search results or initial state
            Expanded(
              child: Consumer<MusicProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (_searchController.text.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Search for your favorite songs',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.searchResults.isEmpty) {
                    return Center(
                      child: Text(
                        'No results found',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.searchResults.length,
                    itemBuilder: (context, index) {
                      final song = provider.searchResults[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            song.thumbnailUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 56,
                                height: 56,
                                color: AppTheme.cardBackground,
                                child: Icon(
                                  Icons.music_note,
                                  color: AppTheme.textSecondary,
                                ),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          song.artist,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: AppTheme.error,
                              ),
                              onPressed: () => provider.toggleLikeSong(song),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.play_circle_fill,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () => provider.playSong(song),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
