// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/list.dart';

class Databasecontroller extends GetxController {
  static const databaseName = 'db_ToDoListApp.db';
  static const databaseVersion = 1;
  static const tableName = "ToDoListTable";
  static const colId = "taskId";
  static const colTaskName = "taskName";
  static const colTaskComplete = "taskComplete";
  static final Databasecontroller instance = Databasecontroller();

  static Database? _database;
  Future<Database?> get database async {
    _database ??= await init();
    return _database;
  }

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: onCreateDatabase);
  }

  FutureOr<void> onCreateDatabase(Database db, int version) async {
    db.execute("""
    CREATE TABLE $tableName(
    $colId TEXT PRIMARY KEY,
    $colTaskName TEXT NOT NULL,
    $colTaskComplete INTEGER NOT NULL)
""");
  }

  insertData(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> readData() async {
    Database? db = await instance.database;
    return await db!.query(tableName,orderBy: '$colId DESC');
  }
  
  Future<void> updateTaskInDatabase(ToDoList todo) async {
  final Database? db = await instance.database;
  await db!.update(
    tableName, 
    todo.toMap(),
    where: 'taskId = ?',
    whereArgs: [todo.taskId],
  );
}
Future<int> deleteData(String id) async {
    Database? db = await instance.database;
    return db!.delete(tableName, where: "$colId = ?", whereArgs: [id]);
  }

 
}
