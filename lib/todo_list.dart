import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'todo.dart';
import 'add_form.dart';
import 'todo_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'edit_todo.dart';

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

      GlobalKey<ScaffoldState> _listScaffoldKey = GlobalKey<ScaffoldState>();

      void showMessage(String message, [MaterialColor color = Colors.red]) {
        _listScaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: color,
          content: new Text(message),
        ));
      }

      return new Scaffold(
        key: _listScaffoldKey,
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
              onLongPress:(){
                 _setTodoDone(context,  _todos[index]);
              },
              onTap: (){
                _updateTodo(context,_todos[index],index);
              },
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

    double _size = 40.0;
    if (todo.done == true){
      return new Icon(Icons.done, color: Colors.green, size: _size,);
    }

    int isStart = todo.startAt.compareTo(new DateTime.now());

    int isEnd = todo.endAt.compareTo(new DateTime.now());
    //未开始
    if( isStart > 0){
      return new Icon(Icons.schedule, color: Colors.blue, size: _size,);
    }

    //进行中
    if(isStart <= 0 && isEnd > 0){
      return new Icon(Icons.schedule, color: Colors.blue, size: _size,);
    }

    //结束未完成
    return new Icon(Icons.pause, color: Colors.red, size: _size,);

  }


  Future _updateTodo(BuildContext context, Todo todo, int index) async {
    Todo newTodo = await Navigator.of(context).push(
      new MaterialPageRoute<Todo>(
        builder: (BuildContext context){
          return new EditTodoForm(oldTodo:todo);
        },
        fullscreenDialog: true
    ));
    if (newTodo != null){
      int updateResult = await todoProvider.updateTodo(newTodo);
      if(updateResult == 1){
        setState(() {
            _todos[index] = newTodo;
        });
      }
    }
  }

 
  Future _setTodoDone(BuildContext context, Todo todo) async {

    int isStart = todo.startAt.compareTo(new DateTime.now());

    int isEnd = todo.endAt.compareTo(new DateTime.now());

    //已完成，无需变更
    if(todo.done){
          _showDialog(context,"任务已完成，无需处理");
    }else if( isStart > 0){
       _showDialog(context,"任务未开始，无法标记完成");

    } else if(isEnd  < 0) {
      _showDialog(context,"任务已超时，无法标记完成");

    }else if(isStart <= 0 && isEnd > 0){
       todo.done = true;

       int result = await todoProvider.updateTodo(todo);

       if(result == 1){
         setState(() {
              todo.done = true;
          });
       }
      _showDialog(context,"恭喜，又完成一个任务");
    }
  }

  Future _showDialog(BuildContext context, String message) async{

  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('操作提示！'),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  }

}