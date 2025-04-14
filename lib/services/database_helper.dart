import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/song.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'music_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE liked_songs(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        thumbnailUrl TEXT NOT NULL,
        youtubeUrl TEXT,
        lastfmUrl TEXT,
        lastfmImageUrl TEXT,
        lastfmDescription TEXT,
        duration TEXT,
        isLiked INTEGER
      )
    ''');
  }

  Future<int> insertSong(Song song) async {
    try {
      print('Inserting song: ${song.title} (${song.id})');
      final db = await database;
      final result = await db.insert(
        'liked_songs',
        song.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Song inserted successfully: $result');
      return result;
    } catch (e) {
      print('Error inserting song: $e');
      rethrow;
    }
  }

  Future<int> deleteSong(String songId) async {
    try {
      print('Deleting song with ID: $songId');
      final db = await database;
      final result = await db.delete(
        'liked_songs',
        where: 'id = ?',
        whereArgs: [songId],
      );
      print('Song deleted successfully: $result');
      return result;
    } catch (e) {
      print('Error deleting song: $e');
      rethrow;
    }
  }

  Future<List<Song>> getLikedSongs() async {
    try {
      print('Getting liked songs');
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('liked_songs');
      print('Found ${maps.length} liked songs');
      return List.generate(maps.length, (i) => Song.fromMap(maps[i]));
    } catch (e) {
      print('Error getting liked songs: $e');
      rethrow;
    }
  }

  Future<bool> isSongLiked(String songId) async {
    try {
      print('Checking if song is liked: $songId');
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'liked_songs',
        where: 'id = ?',
        whereArgs: [songId],
      );
      final isLiked = result.isNotEmpty;
      print('Song is liked: $isLiked');
      return isLiked;
    } catch (e) {
      print('Error checking if song is liked: $e');
      rethrow;
    }
  }

  Future<void> recreateDatabase() async {
    String path = join(await getDatabasesPath(), 'music_app.db');
    await deleteDatabase(path);
    _database = await _initDatabase();
  }
}
