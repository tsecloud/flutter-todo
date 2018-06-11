import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'todo.dart';

String tableName = "todos";

class TodoProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        create table todos(

          id integer not null primary key autoincrement,
          
          name text  not null,
          
          remark text  null,

          start_at text not null,

          end_at text not null,

          done integer not null default 0
        )
      ''');
    });
  }

  Future<Todo> insertTodo(Todo todo) async {
    todo.id = await db.insert(tableName, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps =
        await db.query(tableName, where: "id = ?", whereArgs: [id]);

    if (maps.length > 0) {
      return new Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> getTodos() async {
    List<Map> maps = await db.query(tableName, orderBy: "start_at", limit: 20);

    List<Todo> list = [];

    if (maps.length > 0) {
      for (var item in maps) {
        list.add(Todo.fromMap(item));
      }
    }
    return list;
  }

  Future<int> updateTodo(Todo todo) async {
    return await db
        .update(tableName, todo.toMap(), where: "id = ?", whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    return await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

  Future close() => db.close();
}
