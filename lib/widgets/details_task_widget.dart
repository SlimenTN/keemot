import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/model.dart';
import '../util/colors.dart' as color;

class DetailTask extends StatelessWidget {
  final Task task;
  final Function onDelete;
  final Function onLongPress;
  

  const DetailTask({Key key, @required this.task, this.onDelete, this.onLongPress}): super(key: key);

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Long press to edit the task'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateFormat formatDate = DateFormat('dd/MM/yyyy');  


    return Container(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(
          '${task.title}',
          style: TextStyle(
            color: color.text,
            fontSize: 20.0
          ),
        ),
        subtitle: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Start date: ${task.humanReadableDate()}', textAlign: TextAlign.left),
              Text('Reiteration: Each ${task.reiteration} ${task.reiterationTarget}'),
              Text('Reminder: Before ${task.notification} ${task.notificationTarget}')
            ],
          ),
        ),
        trailing: FlatButton(
          child: Icon(
            Icons.delete_forever,
            color: color.red,
          ),
          onPressed: () {
            onDelete();
          },
        ),
        onTap: (){
          _showToast(context);
        },
        onLongPress: (){
          this.onLongPress();
        },
      ),
    );
  }
}