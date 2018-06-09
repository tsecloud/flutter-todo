import 'dart:async';

import 'package:flutter/material.dart';


class DateTimeShow extends StatelessWidget {
  final DateTime dateTime;


  DateTimeShow({Key key, DateTime dateTime}):
    dateTime = dateTime == null 
    ? DateTime.now() : new DateTime(dateTime.year, dateTime.month, dateTime.day),super(key:key);

  final Duration duration = new Duration(days: 10);

  @override
  Widget build(BuildContext context){
    return new Row(
        children: <Widget>[
          new Expanded(
            child: new InkWell(
              onTap: () => _selectDate(context),
              child: new Text(dateTime.day.toString())
            ),
          ),
          new InkWell(
            onTap: (){
              showTimePicker(context: context, initialTime: new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
            },
            child: new Text('time'),
          )
        ],
    );
  }

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
                context: context, 
                initialDate: dateTime, 
                firstDate: dateTime, 
                lastDate: dateTime.add(duration),
    );

    if (picked != null){
      print(picked);
    }
  }
}