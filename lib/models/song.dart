class Song {
  final String id;
  final String title;
  final String artist;
  final String thumbnailUrl;
  final String? youtubeUrl;
  final String? lastfmUrl;
  final String? lastfmImageUrl;
  final String? lastfmDescription;
  final String duration;
  final bool isLiked;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    this.youtubeUrl,
    this.lastfmUrl,
    this.lastfmImageUrl,
    this.lastfmDescription,
    this.duration = '0:00',
    this.isLiked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'thumbnailUrl': thumbnailUrl,
      'youtubeUrl': youtubeUrl ?? '',
      'lastfmUrl': lastfmUrl ?? '',
      'lastfmImageUrl': lastfmImageUrl ?? '',
      'lastfmDescription': lastfmDescription ?? '',
      'duration': duration,
      'isLiked': isLiked ? 1 : 0,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      youtubeUrl: map['youtubeUrl'] ?? '',
      lastfmUrl: map['lastfmUrl'] ?? '',
      lastfmImageUrl: map['lastfmImageUrl'] ?? '',
      lastfmDescription: map['lastfmDescription'] ?? '',
      duration: map['duration'] ?? '0:00',
      isLiked: map['isLiked'] == 1,
    );
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? thumbnailUrl,
    String? youtubeUrl,
    String? lastfmUrl,
    String? lastfmImageUrl,
    String? lastfmDescription,
    String? duration,
    bool? isLiked,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      lastfmUrl: lastfmUrl ?? this.lastfmUrl,
      lastfmImageUrl: lastfmImageUrl ?? this.lastfmImageUrl,
      lastfmDescription: lastfmDescription ?? this.lastfmDescription,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
