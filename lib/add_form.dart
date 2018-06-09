import 'package:flutter/material.dart';
import 'todo.dart';
import 'datetime_picker.dart';


class AddTodoForm extends StatefulWidget {
  @override
  _AddTodoFormState createState() => new _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  // 初始化时间
  DateTime _fromDate = new DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 28);

  Todo newTodo;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      newTodo = new Todo();
    }

  void _submitForm(BuildContext context) {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('请重新填写表单');
    } else {
      form.save();
      newTodo.startAt = _combineDateAndTime(_fromDate, _fromTime);
      newTodo.endAt = _combineDateAndTime(_toDate, _toTime);
      // print(newTodo.startAt);
      // int compareResult = newTodo.startAt.compareTo(newTodo.endAt);
      // // print(compareResult);
      // // if(0 == compareResult){
      // //   showMessage('开始时间不能等于结束时间');
      // // }


      // // if(compareResult > 0){
      // //   showMessage('开始时间不能大于结束时间');
      // // }


      Navigator.of(context).pop(newTodo);
    }
  }

  DateTime _combineDateAndTime(DateTime dateTime, TimeOfDay timeOfDay){
    return new DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: color,
      content: new Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('新任务'),
        actions: <Widget>[
          new FlatButton(
            onPressed: (){
              _submitForm(context);
            },
            child: new Text(
              '保存',
            ),
          )
        ],
      ),
      body: new Builder(
        builder: (BuildContext context){
          return new DropdownButtonHideUnderline(
            child: new SafeArea(
              top: false,
              bottom: false,
              child: getTodoForm(context)
            ),
          );
        },
      ),
    );
  }

  Form getTodoForm(BuildContext context){
      return new Form(
        key: _formKey,
        child: new ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            new TextFormField(
              decoration: new InputDecoration(
                labelText: '任务',
              ),
              onSaved: (val){
                newTodo.name = val;
              },
              validator: (val){
                return val.isEmpty ? "请填写任务名称" : null;
              },
            ),
            new TextField(
              decoration: const InputDecoration(
                labelText: '补充',
              ),
              style: Theme.of(context).textTheme.display1.copyWith(fontSize: 12.0),
            ),
            new DateTimePicker(
              labelText: 'From',
              selectedDate: _fromDate,
              selectedTime: _fromTime,
              selectDate: (DateTime date) {
                setState(() {
                  _fromDate = date;
                  print(date);
                });
              },
              selectTime: (TimeOfDay time) {
                setState(() {
                  _fromTime = time;
                });
              },
            ),
            new DateTimePicker(
              labelText: 'To',
              selectedDate: _toDate,
              selectedTime: _toTime,
              selectDate: (DateTime date) {
                setState(() {
                  _toDate = date;
                });
              },
              selectTime: (TimeOfDay time) {
                setState(() {
                  _toTime = time;
                });
              },
            ),
          ],
        ),
      );
    }

}
