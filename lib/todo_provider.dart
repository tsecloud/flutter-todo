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

          start_at integer not null,

          end_at integer not null,

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
      maps.forEach((item){
          list.add(Todo.fromMap(item));
      });
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

  Future<List<Todo>> scopeTodos(SearchStatus status) async{

    List<Map> maps;

    num now = DateTime.now().millisecondsSinceEpoch;
    switch (status) {
      case SearchStatus.wait:
        maps = await db.query(tableName, where: "done != 1 and start_at > ?", whereArgs: [now]);
        break;
      case SearchStatus.doing:
        maps = await db.query(tableName, where: "done != 1 and start_at < ? and end_at > ?", whereArgs: [now, now]);
        break;

      case SearchStatus.done:
        maps = await db.query(tableName, where: "done = 1 ");
        break;

      case SearchStatus.pause:
        maps = await db.query(tableName, where: "done != 1 and end_at < ? ", whereArgs: [now]);
        break;
      case SearchStatus.all:
        maps = await db.query(tableName, orderBy: "start_at", limit: 20);
        break;
    }
    
    List<Todo> list = [];

    if (maps.length > 0) {
      maps.forEach((item){
        list.add(Todo.fromMap(item));
      });
    }
    return list;
  }

  Future close() => db.close();
}