//imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/music_provider.dart';
import '../widgets/mini_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
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
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                floating: true,
                expandedHeight: 120,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Good Evening',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () {},
                    color: Colors.white,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {},
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Recently Played
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recently Played',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<MusicProvider>(
                        builder: (context, provider, child) {
                          final recentlyPlayed = provider.recentlyPlayed;

                          if (recentlyPlayed.isEmpty) {
                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 48,
                                      color: AppTheme.textSecondary
                                          .withOpacity(0.7),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No recently played songs',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your recently played songs will appear here',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.textSecondary
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recentlyPlayed.length,
                              itemBuilder: (context, index) {
                                final song = recentlyPlayed[index];
                                return _buildRecentlyPlayedItem(
                                    context, song, provider);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Made for You
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Made for You',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildPlaylistCard(
                              context,
                              'Daily Mix 1',
                              'Your daily mix of songs you love',
                              'https://picsum.photos/200',
                            ),
                            _buildPlaylistCard(
                              context,
                              'Discover Weekly',
                              'Your weekly mixtape of fresh music',
                              'https://picsum.photos/201',
                            ),
                            _buildPlaylistCard(
                              context,
                              'Release Radar',
                              'Catch all the latest music from artists you follow',
                              'https://picsum.photos/202',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Popular Playlists
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Playlists',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: [
                          _buildPlaylistGridItem(
                            context,
                            'Top Hits 2023',
                            'https://picsum.photos/203',
                          ),
                          _buildPlaylistGridItem(
                            context,
                            'Chill Vibes',
                            'https://picsum.photos/204',
                          ),
                          _buildPlaylistGridItem(
                            context,
                            'Workout Mix',
                            'https://picsum.photos/205',
                          ),
                          _buildPlaylistGridItem(
                            context,
                            'Focus Music',
                            'https://picsum.photos/206',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Add some bottom padding to avoid content being hidden by the mini player
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayedItem(
      BuildContext context, dynamic song, MusicProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.playSong(song);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      song.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.music_note,
                            size: 40,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          provider.playSong(song);
                        },
                        iconSize: 20,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              song.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              song.artist,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(
      BuildContext context, String title, String subtitle, String imageUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.album,
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 20,
                    ),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistGridItem(
      BuildContext context, String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.album,
                    size: 40,
                    color: Colors.white,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
