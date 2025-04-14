import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_icon.dart';
import '../widgets/mini_player.dart';

class LikedSongsScreen extends StatelessWidget {
  const LikedSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Consumer<MusicProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Header
                  SliverAppBar(
                    backgroundColor: AppTheme.darkBackground,
                    expandedHeight: 200,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Liked Songs',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.error.withOpacity(0.6),
                              AppTheme.darkBackground,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.favorite,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Song count and Play All button
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${provider.likedSongs.length} songs',
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          if (provider.likedSongs.isNotEmpty)
                            ElevatedButton.icon(
                              onPressed: () {
                                provider.clearQueue();
                                for (var song in provider.likedSongs) {
                                  provider.addToQueue(song);
                                }
                                if (provider.likedSongs.isNotEmpty) {
                                  provider.playSong(provider.likedSongs[0]);
                                }
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Play All'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Liked songs list
                  if (provider.likedSongs.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppTheme.cardBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.favorite_border,
                                size: 48,
                                color: AppTheme.textSecondary.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No liked songs yet',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Like songs to see them here',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final song = provider.likedSongs[index];
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
                                  child: CachedNetworkImage(
                                    imageUrl: song.thumbnailUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: AppTheme.cardBackground,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: AppTheme.cardBackground,
                                      child: Icon(
                                        Icons.music_note,
                                        color: AppTheme.textSecondary
                                            .withOpacity(0.5),
                                      ),
                                    ),
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
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: AppTheme.error,
                                      ),
                                      onPressed: () =>
                                          provider.toggleLikeSong(song),
                                    ),
                                    IconButton(
                                      icon: const GradientIcon(
                                        Icons.play_circle_fill,
                                        32,
                                        LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Colors.white70
                                          ],
                                        ),
                                      ),
                                      onPressed: () => provider.playSong(song),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: provider.likedSongs.length,
                        ),
                      ),
                    ),

                  // Add bottom padding to avoid MiniPlayer overlap
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: provider.currentSong != null ? 80 : 16,
                    ),
                  ),
                ],
              ),
              // MiniPlayer at the bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: const MiniPlayer(),
              ),
            ],
          );
        },
      ),
    );
  }
}
