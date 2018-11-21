import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/model.dart';

class ComingTask extends StatelessWidget {
  
  final Task task;

  const ComingTask({Key key, @required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat formatDate = DateFormat('dd/MM/yyyy');  

    return Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: ListTile(
          title: Text(
            "${task.title}",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blueAccent
            ),
          ),
          subtitle: Text(
            "${formatDate.format(task.date)}",
            style: TextStyle(
              fontSize: 15.0,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      );
  }
}