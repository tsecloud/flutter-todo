import 'package:flutter/material.dart';
import 'todo_list.dart';

void main() => runApp(new MaterialApp(
      title: 'Todo',
      theme: new ThemeData(
          primaryColor: Colors.orange,
          brightness: Brightness.light,
          accentColor: Colors.cyan[600]),
      home: new TodoList(),
    ));
