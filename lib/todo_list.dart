import 'package:flutter/material.dart';
import 'todo.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'todo',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('Todo'),),
        body: new Builder(
          builder: (BuildContext context){
            return new Container(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: getTodoShow,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getTodoShow(BuildContext context, int index){
    return new ListTile(
      leading: new FlutterLogo(),
      title: new Text(todos[index].name),
      subtitle: new Text(todos[index].done ? "Done" : "Not"),
    );
  }
}