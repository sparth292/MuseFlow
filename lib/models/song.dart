class Song {
  final String id;
  final String title;
  final String artist;
  final String thumbnailUrl;
  final String duration;
  bool isLiked;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnailUrl,
    required this.duration,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'isLiked': isLiked,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['duration'],
      isLiked: json['isLiked'] ?? false,
    );
  }
}
