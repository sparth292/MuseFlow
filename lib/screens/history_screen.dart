import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Recently Played',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  SizedBox(width: 8),
                  _buildFilterChip('Songs'),
                  SizedBox(width: 8),
                  _buildFilterChip('Albums'),
                  SizedBox(width: 8),
                  _buildFilterChip('Playlists'),
                  SizedBox(width: 8),
                  _buildFilterChip('Podcasts'),
                ],
              ),
            ),

            SizedBox(height: 16),

            // History list
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryGroup('Today'),
                  _buildHistoryGroup('Yesterday'),
                  _buildHistoryGroup('This Week'),
                  _buildHistoryGroup('Last Week'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHistoryGroup(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildHistoryItem(
          'Timeless (feat. Playboi Carti)',
          'The Weeknd',
          'assets/album1.jpg',
          '3:42',
        ),
        _buildHistoryItem(
          'Blinding Lights',
          'The Weeknd',
          'assets/album2.jpg',
          '3:20',
        ),
        _buildHistoryItem(
          'Tech Talk Episode 42',
          'Latest in Technology',
          'assets/podcast1.jpg',
          '45:12',
          isPodcast: true,
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    String title,
    String subtitle,
    String imageUrl,
    String duration, {
    bool isPodcast = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isPodcast ? Icons.mic : Icons.music_note,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            duration,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
} 