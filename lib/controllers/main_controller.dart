import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class MainController {
  static Database? _db;

  // Inicializar DB
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "tasks.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            date TEXT,
            priority TEXT
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> addTask(Task task) async {
    final db = await database;
    return await db.insert("tasks", task.toMap());
  }

  // READ
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("tasks");
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // UPDATE
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      "tasks",
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete("tasks", where: "id = ?", whereArgs: [id]);
  }
}
