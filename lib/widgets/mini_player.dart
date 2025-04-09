import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../theme/app_theme.dart';
import '../providers/music_provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, provider, child) {
        final currentSong = provider.currentSong;
        if (currentSong == null) return const SizedBox.shrink();

        final controller = provider.youtubeService.controller;
        if (controller == null) return const SizedBox.shrink();

        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                  ),
                  child: Image.network(
                    currentSong.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Song Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSong.artist,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Like Button
                  IconButton(
                    icon: Icon(
                      currentSong.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: currentSong.isLiked
                          ? AppTheme.accentTeal
                          : Colors.white,
                    ),
                    onPressed: () {
                      provider.toggleLike();
                    },
                    iconSize: 22,
                  ),

                  // Previous Button
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      provider.skipToPrevious();
                    },
                    iconSize: 22,
                  ),

                  // Play/Pause Button
                  IconButton(
                    icon: Icon(
                      provider.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      provider.togglePlayPause();
                    },
                  ),

                  // Next Button
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      provider.skipToNext();
                    },
                    iconSize: 22,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
