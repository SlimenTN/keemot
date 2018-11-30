import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'new_stuff.dart';
import '../database/db_handler.dart';
import '../database/model.dart';
import 'coming_task_widget.dart';
import 'all_stuff.dart';

class ComingStufWidget extends StatefulWidget {
  @override
  _ComingStufWidgetState createState() => _ComingStufWidgetState();
}

class _ComingStufWidgetState extends State<ComingStufWidget> {
  final formatDate = DateFormat('dd/MM/yyyy');
  final dbh = DatabaseHandler.internal();
  final List<Task> _comingTasks = <Task>[];
  final int numberOfDaysToDisplayComingStuff = 7;

  @override
    void initState() {
      super.initState();
      _loadComingTasks();
    }

  void _loadComingTasks() async{
    _comingTasks.clear();
    List list = await dbh.readComingEvents(numberOfDaysToDisplayComingStuff);
    list.forEach((dynamic object){
      Task task = Task.map(object);
      setState(() {
        _comingTasks.add(task);      
      });
    });
  }

  void _addNewStuff(BuildContext context) async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewStuffWidget()
      )
    );

    _loadComingTasks();
  }

  void _goToAllTasksScreen(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AllStuffWidget()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keemot'),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadComingTasks,
          ),
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context){
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                  child: Text('Parameters'),
                  value: 'settings',
                ),
                PopupMenuItem<String>(
                  child: Text('All stuff'),
                  value: 'list_stuff'
                ),
              ];
            },
            onSelected: (value){
              if(value == 'list_stuff') _goToAllTasksScreen(context);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_alarm),
        backgroundColor: Colors.lightBlue,
        onPressed: (){
          _addNewStuff(context);
        },
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
                child: Text(
                'Coming stuff to do',
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.blueAccent
                ),
              ),
            ),

            Flexible(
              child: ListView.builder(
                itemCount: _comingTasks.length,
                itemBuilder: (_, int index){
                  return ComingTask(task: _comingTasks[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}