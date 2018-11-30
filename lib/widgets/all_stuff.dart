import 'package:flutter/material.dart';
import '../database/model.dart';
import './details_task_widget.dart';
import '../database/db_handler.dart';

class AllStuffWidget extends StatefulWidget {
  @override
  _AllStuffWidgetState createState() => _AllStuffWidgetState();
}

class _AllStuffWidgetState extends State<AllStuffWidget> {
  final List<Task> _tasks = <Task>[];
  final dbh = DatabaseHandler.internal();

  @override
  void initState(){
    super.initState();
    print('from initial state');
    _loadTasks();
  }

  void _loadTasks() async{
    _tasks.clear();
    List list = await dbh.read();
    print(list.toString());
    setState(() {
      list.forEach((dynamic object){
        Task task = Task.map(object);
        _tasks.add(task);         
      });   
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('List of stuff to do'),
      ),

      body: Center(
        child: Column(
          children: <Widget>[
            // Padding(padding: EdgeInsets.all(20.0),),
            Flexible(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (_, int index){
                  return DetailTask(task: _tasks[index]); 
                },
              ),
            )
          ],
        )
      ),
    );
  }
}