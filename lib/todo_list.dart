import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'todo.dart';
import 'add_form.dart';
import 'package:intl/intl.dart';
import 'todo_provider.dart';
import 'package:path_provider/path_provider.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> _todos = [];

  TodoProvider todoProvider;

  Directory directory;

  @override
  void initState(){
    super.initState();

    init();
  }

  Future init() async {
    todoProvider = new TodoProvider();

    directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, "todos.db");

    await todoProvider.open(path);

    List<Todo> todos = await todoProvider.getTodos();

    setState(() {
          _todos.addAll(todos);
        });
  }

  @override
  Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text('Todo'),),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () => _addTodo(context),
        ),
        body: new Builder(
          builder: (BuildContext context){
            return new Container(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder:(BuildContext context, int index){
                  return getTodoShow(context, index);
                },
              ),
            );
          },
        ),
      );
  }

  Widget getTodoShow(BuildContext context, int index){
    return new Padding(
      padding: const EdgeInsets.all(4.0),
      child: new Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(padding: const EdgeInsets.only(right: 6.0),child: new Icon(Icons.event_note, color: Colors.blue,),),
            new Expanded(
              child:new Text(_todos[index].name, style: new TextStyle(
              fontSize: 14.0,
            ),),
            )
          ],
        ),
        new Divider(color: Colors.white, height: 10.0, indent: 0.0,),
            new Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(right: 6.0), child: new Icon(Icons.details, color: Colors.green,),),
                new Text(_todos[index].startAt.toString().substring(0,19)),
                new Padding(padding: const EdgeInsets.only(left: 8.0, right: 6.0),child: new Icon(Icons.stop, color: Colors.red),),
                new Text(_todos[index].startAt.toString().substring(0,19))
              ],
            ),
        new LinearProgressIndicator(backgroundColor: Colors.red, value: 0.8,),
        ],
      ),
      ),
    )
    );
  }

  Future _addTodo(BuildContext context) async {

    Todo newTodo = await Navigator.of(context).push(
      new MaterialPageRoute<Todo>(
        builder: (BuildContext context){
          return new AddTodoForm();
        },
        fullscreenDialog: true
    ));


    if (newTodo != null){
      Todo daddTodo = await todoProvider.insertTodo(newTodo);
      setState(() {
          _todos.add(daddTodo);
      });
    }
  }
}