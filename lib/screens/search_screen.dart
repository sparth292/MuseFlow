import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../models/song_model.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.darkBackground,
              AppTheme.darkBackground.withOpacity(0.95),
              AppTheme.darkBackground.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      letterSpacing: -0.5,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: AppTheme.textSecondary.withOpacity(0.7),
                        fontSize: 16,
                        letterSpacing: -0.5,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.textSecondary.withOpacity(0.7),
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppTheme.textSecondary.withOpacity(0.7),
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _isSearching = false;
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ),
              ),

              // Search Results or Suggestions
              Expanded(
                child: Consumer<MusicProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryRed,
                              ),
                              strokeWidth: 2,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Searching...',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 16,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (provider.searchQuery.isEmpty && !_isSearching) {
                      return _buildSuggestions();
                    }

                    if (provider.searchResults.isEmpty &&
                        provider.searchQuery.isNotEmpty) {
                      return _buildNoResults();
                    }

                    return _buildSearchResults(provider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    final List<Map<String, dynamic>> suggestions = [
      {
        'title': 'Top Hits',
        'icon': Icons.trending_up,
        'gradient': const LinearGradient(
          colors: [Color(0xFFFF2D55), Color(0xFFFF375F)],
        ),
      },
      {
        'title': 'New Releases',
        'icon': Icons.new_releases,
        'gradient': const LinearGradient(
          colors: [Color(0xFF1DB954), Color(0xFF1ED760)],
        ),
      },
      {
        'title': 'Pop Music',
        'icon': Icons.music_note,
        'gradient': const LinearGradient(
          colors: [Color(0xFF9B2DEF), Color(0xFFB44DFF)],
        ),
      },
      {
        'title': 'Hip Hop',
        'icon': Icons.music_note,
        'gradient': const LinearGradient(
          colors: [Color(0xFFFF9500), Color(0xFFFFAA33)],
        ),
      },
      {
        'title': 'Rock',
        'icon': Icons.music_note,
        'gradient': const LinearGradient(
          colors: [Color(0xFFFF3B30), Color(0xFFFF5146)],
        ),
      },
      {
        'title': 'Electronic',
        'icon': Icons.music_note,
        'gradient': const LinearGradient(
          colors: [Color(0xFF5856D6), Color(0xFF7A79FF)],
        ),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Browse Categories',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: suggestion['gradient'],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _searchController.text = suggestion['title'];
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          suggestion['icon'],
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          suggestion['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkSurface.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 48,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(MusicProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final song = provider.searchResults[index];
        return _buildSongItem(song, provider);
      },
    );
  }

  Widget _buildSongItem(SongModel song, MusicProvider provider) {
    final isCurrentSong = provider.currentSong?.id == song.id;
    final isPlaying = isCurrentSong && provider.isPlaying;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => provider.playSong(song),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    song.thumbnailUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: AppTheme.darkSurface,
                        child: const Icon(
                          Icons.music_note,
                          color: AppTheme.textSecondary,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Song Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        song.artist,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Play/Pause Button
                if (isCurrentSong)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => provider.togglePlayPause(),
                      padding: EdgeInsets.zero,
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: AppTheme.primaryRed,
                      size: 24,
                    ),
                    onPressed: () => provider.playSong(song),
                  ),

                // Like Button
                IconButton(
                  icon: Icon(
                    song.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: song.isLiked
                        ? AppTheme.primaryRed
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => provider.toggleLike(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
