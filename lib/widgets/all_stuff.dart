import 'package:flutter/material.dart';
import '../database/model.dart';
import './details_task_widget.dart';
import '../database/db_handler.dart';
import './new_stuff.dart';

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

  void _deleteTask(int id) async{
    await dbh.delete(id);
    _loadTasks();
  }

  void _confirmDelete(int id){
    var alert = AlertDialog(
      title: Text('Delete Task'),
      content: Text('Are you sure you want to delete this task ?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.pop(context);
            _deleteTask(id);
          },
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void _addNewStuff(BuildContext context) async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewStuffWidget()
      )
    );

    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('List of stuff to do'),
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
            // Padding(padding: EdgeInsets.all(20.0),),
            Flexible(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (_, int index){
                  Task task = _tasks[index];
                  return DetailTask(
                    task: task,
                    onDelete: (){
                      _confirmDelete(task.id);
                    },
                  ); 
                },
              ),
            )
          ],
        )
      ),
    );
  }
}