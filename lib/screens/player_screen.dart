import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_icon.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        final currentSong = musicProvider.currentSong;
        if (currentSong == null) {
          return Scaffold(
            backgroundColor: AppTheme.darkBackground,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 64,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No song playing',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryColor.withOpacity(0.15),
                  AppTheme.darkBackground,
                  AppTheme.darkBackground,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Custom App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const GradientIcon(
                            Icons.keyboard_arrow_down,
                            28,
                            LinearGradient(
                              colors: [Colors.white, Colors.white70],
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Text(
                          'Now Playing',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const GradientIcon(
                            Icons.more_vert,
                            24,
                            LinearGradient(
                              colors: [Colors.white, Colors.white70],
                            ),
                          ),
                          onPressed: () {
                            // TODO: Show more options
                          },
                        ),
                      ],
                    ),
                  ),

                  // Album Art
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: currentSong.thumbnailUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppTheme.cardBackground,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppTheme.cardBackground,
                                  child: Icon(
                                    Icons.music_note,
                                    size: 80,
                                    color:
                                        AppTheme.textSecondary.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Song Info
                          Text(
                            currentSong.title,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentSong.artist,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ProgressBar(
                      progress: Duration(
                          milliseconds:
                              (musicProvider.position * 1000).round()),
                      total: Duration(
                          milliseconds:
                              (musicProvider.duration * 1000).round()),
                      progressBarColor: AppTheme.primaryColor,
                      baseBarColor: AppTheme.cardBackground,
                      bufferedBarColor: AppTheme.primaryColor.withOpacity(0.3),
                      thumbColor: AppTheme.primaryColor,
                      barHeight: 4.0,
                      thumbRadius: 8.0,
                      timeLabelTextStyle: GoogleFonts.inter(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                      onSeek: (duration) {
                        musicProvider.seekTo(duration.inMilliseconds / 1000);
                      },
                    ),
                  ),

                  // Controls
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            currentSong.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: currentSong.isLiked
                                ? AppTheme.error
                                : AppTheme.textSecondary,
                            size: 28,
                          ),
                          onPressed: () => musicProvider.toggleLike(),
                        ),
                        IconButton(
                          icon: const GradientIcon(
                            Icons.skip_previous,
                            36,
                            LinearGradient(
                              colors: [Colors.white, Colors.white70],
                            ),
                          ),
                          onPressed: () => musicProvider.skipToPrevious(),
                        ),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.accentColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => musicProvider.togglePlayPause(),
                              customBorder: const CircleBorder(),
                              child: Icon(
                                musicProvider.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const GradientIcon(
                            Icons.skip_next,
                            36,
                            LinearGradient(
                              colors: [Colors.white, Colors.white70],
                            ),
                          ),
                          onPressed: () => musicProvider.skipToNext(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
