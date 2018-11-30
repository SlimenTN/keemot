import 'package:flutter/material.dart';
import '../database/model.dart';

class DetailTask extends StatelessWidget {
  final Task task;

  const DetailTask({Key key, @required this.task}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(
          '${task.title}'
        ),
      ),
    );
  }
}