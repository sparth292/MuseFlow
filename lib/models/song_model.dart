class Song {
  final String id;
  final String title;
  final String artist;
  final String thumbnailUrl;
  bool isLiked;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    this.isLiked = false,
  });

  factory Song.fromLastFm({
    required String id,
    required String title,
    required String artist,
    required String thumbnailUrl,
    bool isLiked = false,
  }) {
    return Song(
      id: id,
      title: title,
      artist: artist,
      thumbnailUrl: thumbnailUrl,
      isLiked: isLiked,
    );
  }

  factory Song.fromYouTube({
    required String videoId,
    required String title,
    required String artist,
    required String thumbnailUrl,
    bool isLiked = false,
  }) {
    return Song(
      id: videoId,
      title: title,
      artist: artist,
      thumbnailUrl: thumbnailUrl,
      isLiked: isLiked,
    );
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? thumbnailUrl,
    bool? isLiked,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
