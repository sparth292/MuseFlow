import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
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
                    'Notifications',
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
                  _buildFilterChip('Music'),
                  SizedBox(width: 8),
                  _buildFilterChip('Podcasts'),
                  SizedBox(width: 8),
                  _buildFilterChip('Following'),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Notifications list
            Expanded(
              child: ListView(
                children: [
                  _buildNotificationItem(
                    'New Release',
                    'The Weeknd just released a new album "Dawn FM"',
                    'assets/album_art.jpg',
                    '2h ago',
                    NotificationType.newRelease,
                  ),
                  _buildNotificationItem(
                    'Playlist Update',
                    'Your Daily Mix 1 has been updated with new tracks',
                    'assets/playlist.jpg',
                    '4h ago',
                    NotificationType.playlist,
                  ),
                  _buildNotificationItem(
                    'Artist Update',
                    'Playboi Carti posted a new story',
                    'assets/artist.jpg',
                    '6h ago',
                    NotificationType.artist,
                  ),
                  _buildNotificationItem(
                    'New Episode',
                    'New episode of "Tech Talk" is now available',
                    'assets/podcast.jpg',
                    '8h ago',
                    NotificationType.podcast,
                  ),
                  _buildNotificationItem(
                    'Friend Activity',
                    'John is listening to "Blinding Lights"',
                    'assets/friend.jpg',
                    '12h ago',
                    NotificationType.friend,
                  ),
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

  Widget _buildNotificationItem(
    String title,
    String description,
    String imageUrl,
    String time,
    NotificationType type,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getIconForType(type),
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.newRelease:
        return Icons.album;
      case NotificationType.playlist:
        return Icons.playlist_play;
      case NotificationType.artist:
        return Icons.person;
      case NotificationType.podcast:
        return Icons.mic;
      case NotificationType.friend:
        return Icons.people;
      default:
        return Icons.notifications;
    }
  }
}

enum NotificationType {
  newRelease,
  playlist,
  artist,
  podcast,
  friend,
} 