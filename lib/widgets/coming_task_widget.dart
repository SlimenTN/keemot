import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/model.dart';

class ComingTask extends StatelessWidget {
  
  final Task task;

  const ComingTask({Key key, @required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat formatDate = DateFormat('dd/MM/yyyy');  
    int remainingDays;

    Duration diff = task.date.difference(DateTime.now());
    remainingDays = diff.inDays+1;
    Color borderColor = remainingDays == 1 ? Colors.red : Colors.blueAccent;
    Color backgroundColor = remainingDays == 1 ? Colors.red : Colors.white;
    Color avatarColor = remainingDays == 1 ? Colors.white : Colors.blueGrey;
    Color avatarTextColor = remainingDays == 1 ? Colors.red : Colors.white;
    Color titleColor = remainingDays == 1 ? Colors.white : Colors.blueAccent;
    Color subtitleColor = remainingDays == 1 ? Colors.white : Colors.grey;


    return Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: backgroundColor
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(
              '- $remainingDays',
              style: TextStyle(
                color: avatarTextColor
              ),
            ),
            backgroundColor: avatarColor,
          ),
          title: Text(
            "${task.title}",
            style: TextStyle(
              fontSize: 20.0,
              color: titleColor
            ),
          ),
          subtitle: Text(
            "${formatDate.format(task.date)}",
            style: TextStyle(
              fontSize: 15.0,
              fontStyle: FontStyle.italic,
              color: subtitleColor,
            ),
          ),
        ),
      );
  }
}