import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Item {
  int id;
  String title;
  String content;
  String created_at;

  Item({
    required this.id,
    required this.title,
    required this.content,
    required this.created_at
  });

}

class ConnectDB {

  Future _openDB() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');

    final openDB = await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) => {},
      onCreate: (Database db, int version) => {},
      onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
  }

  /**
   * Close Database. If you close the application, then auto close Database.
   */
  // Future _closeDB() async {
  //   final closeDB = await
  // }

  /// Create table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS posts(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  /// Insert column data.
  Future add(item) async {
    final db = await _openDB();         // open _openDB function.
    item.id = await db.insert(
      'posts',
      {
        'title': 'new post',
        'content': 'new content',
        'created_at': '2023 - 05 - 11 00:04:23',
      },
    );
    return item;
  }

  /// Update.
  Future update(item) async {
    final db = await _openDB();         // open _openDB function.
    await db.update(
      'posts',
      {
        'title': 'update title',
        'content': 'update content',
      },
      where: 'id = ?',
      whereArgs: [item.id],
    );
    return item;
  }

  /// Delete.
  Future<int> delete(int id) async {
    final db = await _openDB();
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );

    return id;
  }

}