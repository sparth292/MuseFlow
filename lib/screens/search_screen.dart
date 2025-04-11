import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/music_provider.dart';
import '../models/song_model.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_icon.dart';

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
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.darkBackground,
              AppTheme.darkBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: GoogleFonts.inter(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search songs, artists, or albums',
                      hintStyle: GoogleFonts.inter(
                        color: AppTheme.textSecondary.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GradientIcon(
                          Icons.search,
                          24,
                          LinearGradient(
                            colors: [
                              AppTheme.textSecondary.withOpacity(0.7),
                              AppTheme.textSecondary.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: GradientIcon(
                                Icons.clear,
                                20,
                                LinearGradient(
                                  colors: [
                                    AppTheme.textSecondary.withOpacity(0.7),
                                    AppTheme.textSecondary.withOpacity(0.5),
                                  ],
                                ),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                      return _buildLoadingState();
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

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppTheme.cardBackground,
            highlightColor: AppTheme.darkSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 24),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    final List<Map<String, dynamic>> suggestions = [
      {
        'title': 'Top Hits',
        'subtitle': 'Most popular tracks',
        'icon': Icons.trending_up,
        'color': AppTheme.primaryColor,
      },
      {
        'title': 'New Releases',
        'subtitle': 'Fresh music daily',
        'icon': Icons.new_releases,
        'color': const Color(0xFF1DB954),
      },
      {
        'title': 'Pop Music',
        'subtitle': 'Top pop hits',
        'icon': Icons.music_note,
        'color': const Color(0xFF9B2DEF),
      },
      {
        'title': 'Hip Hop',
        'subtitle': 'Latest rap tracks',
        'icon': Icons.album,
        'color': const Color(0xFFFF9500),
      },
      {
        'title': 'Rock',
        'subtitle': 'Classic & modern rock',
        'icon': Icons.music_note,
        'color': const Color(0xFFFF3B30),
      },
      {
        'title': 'Electronic',
        'subtitle': 'EDM & dance music',
        'icon': Icons.electric_bolt,
        'color': const Color(0xFF5856D6),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Browse Categories',
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      suggestion['color'],
                      suggestion['color'].withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: suggestion['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Handle category tap
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            suggestion['icon'],
                            color: Colors.white,
                            size: 32,
                          ),
                          const Spacer(),
                          Text(
                            suggestion['title'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            suggestion['subtitle'],
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: GoogleFonts.poppins(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(MusicProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final song = provider.searchResults[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
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
                      color: AppTheme.textSecondary.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),
            title: Text(
              song.title,
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artist,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const GradientIcon(
                Icons.play_circle_fill,
                32,
                LinearGradient(
                  colors: [Colors.white, Colors.white70],
                ),
              ),
              onPressed: () {
                provider.playSong(song);
              },
            ),
          ),
        );
      },
    );
  }
}
