import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_icon.dart';
import 'package:marquee/marquee.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        final currentSong = musicProvider.currentSong;
        if (currentSong == null) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No song playing',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                // Header with down arrow and options
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Now Playing',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Album art and song info
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(32),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: currentSong.thumbnailUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[900],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.cyan,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[900],
                                child: Icon(
                                  Icons.music_note,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Song info with marquee
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                child: Marquee(
                                  text: currentSong.title,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 20.0,
                                  velocity: 30.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                currentSong.artist,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Progress bar and controls
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              ProgressBar(
                                progress: Duration(
                                    milliseconds:
                                        (musicProvider.position * 1000)
                                            .round()),
                                total: Duration(
                                    milliseconds:
                                        (musicProvider.duration * 1000)
                                            .round()),
                                progressBarColor: Colors.cyan,
                                baseBarColor: Colors.grey[900],
                                bufferedBarColor: Colors.cyan.withOpacity(0.3),
                                thumbColor: Colors.cyan,
                                barHeight: 3.0,
                                thumbRadius: 6.0,
                                timeLabelTextStyle: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                onSeek: (duration) {
                                  musicProvider
                                      .seekTo(duration.inMilliseconds / 1000);
                                },
                              ),

                              SizedBox(height: 24),

                              // Control buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      currentSong.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: currentSong.isLiked
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                    onPressed: () => musicProvider.toggleLike(),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.skip_previous,
                                        color: Colors.white, size: 36),
                                    onPressed: () =>
                                        musicProvider.skipToPrevious(),
                                  ),
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.cyan,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        musicProvider.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.black,
                                        size: 36,
                                      ),
                                      onPressed: () =>
                                          musicProvider.togglePlayPause(),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.skip_next,
                                        color: Colors.white, size: 36),
                                    onPressed: () => musicProvider.skipToNext(),
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.repeat, color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
