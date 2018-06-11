import 'package:flutter/material.dart';
import 'todo_list.dart';

void main() => runApp(new MaterialApp(
      title: 'Todo',
      theme: new ThemeData(
          primaryColor: Colors.orange,
          brightness: Brightness.light,
          accentColor: Colors.orangeAccent),
      home: new TodoList(),
    ));
