class SongModel {
  final String id;
  final String title;
  final String artist;
  final String thumbnailUrl;
  final Duration duration;
  final String? youtubeId;
  bool isLiked;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    required this.duration,
    this.youtubeId,
    this.isLiked = false,
  });

  factory SongModel.fromLastFm({
    required String id,
    required String title,
    required String artist,
    required String thumbnailUrl,
    bool isLiked = false,
  }) {
    return SongModel(
      id: id,
      title: title,
      artist: artist,
      thumbnailUrl: thumbnailUrl,
      duration: Duration.zero, // Last.fm doesn't provide duration
      isLiked: isLiked,
    );
  }

  factory SongModel.fromYouTube({
    required String videoId,
    required String title,
    required String artist,
    required String thumbnailUrl,
    required Duration duration,
    bool isLiked = false,
  }) {
    return SongModel(
      id: videoId,
      title: title,
      artist: artist,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      youtubeId: videoId,
      isLiked: isLiked,
    );
  }

  SongModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? thumbnailUrl,
    Duration? duration,
    String? youtubeId,
    bool? isLiked,
  }) {
    return SongModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      youtubeId: youtubeId ?? this.youtubeId,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
