import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../entity/task.dart';

class TaskDatabaseService {
  static final TaskDatabaseService instance = TaskDatabaseService._init();
  static Database? _database;

  TaskDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            dueDate TEXT,
            isCompleted INTEGER NOT NULL
          )
        ''');

        // Chèn dữ liệu mẫu ban đầu
        await db.insert('tasks', {
          'title': 'Làm bài tập Flutter',
          'description': 'Hoàn thành trước thứ Sáu',
          'dueDate': '2024-12-01',
          'isCompleted': 0,
        });
        await db.insert('tasks', {
          'title': 'Ôn tập Riverpod',
          'description': 'Xem lại bài giảng MVVM',
          'dueDate': '2024-12-02',
          'isCompleted': 0,
        });
      },
    );
  }

  // Yêu cầu 1: Lấy danh sách task từ SQLite
  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  // Yêu cầu 2: Cập nhật task trong SQLite
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}