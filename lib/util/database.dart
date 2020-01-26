
import 'package:luna_flutter/model/base_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseUtil {

  static DatabaseUtil _instance;

  Future<Database> _db;

  DatabaseUtil get instance => _instance;

  factory DatabaseUtil() {
    if (_instance == null) {
      _instance = DatabaseUtil._internal();
    }
    return _instance;
  }

  DatabaseUtil._internal() {

    _db = openDatabase(
      'recordV1.db',
      onCreate: (db, version) {
        var batch = db.batch();
        batch.execute('''
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            sort_order INTEGER, 
            create_time INTEGER
          )
        ''');
        batch.execute('''
          CREATE TABLE course_records(
            id INTEGER PRIMARY KEY,
            course_id INTEGER,
            record_time INTEGER,
            remark TEXT,
            create_time INTEGER
          )
        ''');
        batch.commit();
      },
      version: 1,
    );
    return;
  }

  Future<int> insert<T extends BaseModel>(T model) async {
    final db = await _db;
    return db.insert(model.tableName, model.toMap());
  }

  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    final db = await _db;
    return db.query(tableName);
  }

}