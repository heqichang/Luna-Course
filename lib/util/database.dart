
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
            attended INTEGER,
            total INTEGER, 
            sort_order INTEGER, 
            create_time INTEGER
          )
        ''');
        batch.execute('''
          CREATE TABLE course_records(
            id INTEGER PRIMARY KEY,
            course_id INTEGER,
            record_time INTEGER,
            status INTEGER, 
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

  Future<int> update<T extends BaseModel>(T model) async {
    final db = await _db;
    return db.update(model.tableName, model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> delete<T extends BaseModel>(T model) async {
    final db = await _db;
    return db.delete(model.tableName, where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> deleteByName(String tableName, {String where, List<dynamic> whereArgs}) async {
    final db = await _db;
    return db.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    // 不能用 new T() ，不然可以直接返回 model
    final db = await _db;
    return db.query(tableName);
  }

  Future<int> getCount(String tableName, {String where, List<dynamic> whereArgs}) async {

    final db = await _db;

    var rawSql = 'select count(*) from $tableName';
    if (where != null) {
      rawSql += ' where $where';
    }


    final count = Sqflite.firstIntValue(await db.rawQuery(
      rawSql,
      whereArgs,
    ));

    return count;
  }
  
  Future<List<Map<String, dynamic>>> get(String tableName,
      {bool distinct,
        List<String> columns,
        String where,
        List<dynamic> whereArgs,
        String groupBy,
        String having,
        String orderBy,
        int limit,
        int offset}) async {
    final db = await _db;

    return db.query(
      tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset
    );
  }

}