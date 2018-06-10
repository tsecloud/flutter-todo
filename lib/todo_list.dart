import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'todo.dart';
import 'add_form.dart';
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
        child: new Column(
          children: <Widget>[
            new LinearProgressIndicator(backgroundColor: Colors.red, value: _todos[index].computeLeftTime(),),
            new ListTile(
              leading: getLeading(_todos[index]),
              title: new Text(_todos[index].name),
              subtitle: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(padding: const EdgeInsets.only(right: 6.0), child: new Icon(Icons.details, color: Colors.green,),),
                    new Text(_todos[index].getDateMd(_todos[index].startAt)),
                    new Padding(padding: const EdgeInsets.only(right: 6.0), child: new Icon(Icons.details, color: Colors.red,),),
                    new Text(_todos[index].getDateMd(_todos[index].endAt))
                  ],
              ),
            ),
          ],
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

  Widget getLeading(Todo todo){
    if (todo.done == true){
      return new Icon(Icons.done, color: Colors.green,);
    }

    int isStart = todo.startAt.compareTo(new DateTime.now());

    int isEnd = todo.endAt.compareTo(new DateTime.now());
    //未开始
    if( isStart > 0){
      return new Icon(Icons.toc,);
    }

    //进行中
    if(isStart <= 0 && isEnd > 0){
      return new Icon(Icons.schedule, color: Colors.blue);
    }

    //结束未完成
    return new Icon(Icons.pause, color: Colors.red,);

  }
}