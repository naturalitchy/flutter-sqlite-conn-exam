// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class Item {
//   int id;
//   String title;
//   String content;
//   String created_at;
//
//   Item({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.created_at
//   });
//
// }
//
// class ConnectDB {
//
//   Future _openDB() async {
//     final databasePath = await getDatabasesPath();
//     String path = join(databasePath, 'my_database.db');
//
//     final openDB = await openDatabase(
//       path,
//       version: 1,
//       onConfigure: (Database db) => {},
//       onCreate: (Database db, int version) => {},
//       onUpgrade: (Database db, int oldVersion, int newVersion) => {},
//     );
//   }
//
//   /**
//    * Close Database. If you close the application, then auto close Database.
//    */
//   // Future _closeDB() async {
//   //   final closeDB = await
//   // }
//
//   /// Get table.
//   Future<Item> getTodo(int id) async {
//     final db = await _openDB();         // open _openDB function.
//     List<Map> maps = await db.query('posts',
//         columns: [columnId, columnDone, columnTitle],
//         where: '$columnId = ?',
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       return Item.fromMap(maps.first);
//     }
//     return null;
//   }
//
//   /// Create table.
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE IF NOT EXISTS posts(
//         id INTEGER PRIMARY KEY,
//         title TEXT NOT NULL,
//         content TEXT NOT NULL,
//         created_at TEXT NOT NULL
//       )
//     ''');
//   }
//
//   /// Insert column data.
//   Future add(item) async {
//     final db = await _openDB();         // open _openDB function.
//     item.id = await db.insert(
//       'posts',
//       {
//         'title': 'new post',
//         'content': 'new content',
//         'created_at': '2023 - 05 - 11 00:04:23',
//       },
//     );
//     return item;
//   }
//
//   /// Update.
//   Future update(item) async {
//     final db = await _openDB();         // open _openDB function.
//     await db.update(
//       'posts',
//       {
//         'title': 'update title',
//         'content': 'update content',
//       },
//       where: 'id = ?',
//       whereArgs: [item.id],
//     );
//     return item;
//   }
//
//   /// Delete.
//   Future<int> delete(int id) async {
//     final db = await _openDB();
//     await db.delete(
//       'posts',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//
//     return id;
//   }
//
// }


/**
 * it is real.
 */
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {

  /// create a database and table.
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }
  // static Future<void> createTables(sql.Database database) async {
  //   await database.execute("""
  //     CREATE TABLE items(
  //       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  //       title TEXT,
  //       description TEXT,
  //       createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  //     )
  //   """);
  // }

  /// open the database.
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'nabindhakal.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  /// adding/create item
  static Future<int> createItem(String? title, String? description) async {
    final db = await DatabaseHelper.db();
    final data = {'title': title, 'description': description};
    final id = await db.insert(
      'items',                    /// table name.
      data,
      /// 데이터베이스에 데이터를 삽입하거나 업데이트할 때 발생할 수 있는 충돌을 처리하는 방법을 지정하는 열거형
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  /// read item
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query(
      'items',
      orderBy: 'id',
    );
  }

  /// edit item.
  static Future<int> updateItem(int id, String title, String? description) async {
    print(' id = ${id} ################# ');
    print(' title = ${title} @@@@@@@@@@@@@@ ');
    print(' description = ${description} @@@@@@@@@@@@@@ ');
    final db = await DatabaseHelper.db();
    final data = {
      'title' : title,
      'description' : description,
      'createdAt' : DateTime.now().toString(),
    };
    final result = await db.update(
      'items',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  /// delete item.
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete(
        'itmes',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch(err) {
      print('Something went wrong when deleting an item: $err');
    }
  }


}


