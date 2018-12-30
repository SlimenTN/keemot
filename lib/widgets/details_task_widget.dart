import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/model.dart';
import '../util/colors.dart' as color;
import '../util/dictionnary.dart' as dictionnary;

class DetailTask extends StatelessWidget {
  final Task task;
  final Function onDelete;
  final Function onLongPress;
  

  const DetailTask({Key key, @required this.task, this.onDelete, this.onLongPress}): super(key: key);

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(dictionnary.translate('long.press.to.edit.this.task')),
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
              Text('${dictionnary.translate('start.date')}: ${task.humanReadableDate()}', textAlign: TextAlign.left),
              Text('${dictionnary.translate('reiteration.each')} ${task.reiteration} ${dictionnary.translate(task.reiterationTarget)}'),
              Text('${dictionnary.translate('reminder.before')} ${task.notification} ${dictionnary.translate(task.notificationTarget)}')
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