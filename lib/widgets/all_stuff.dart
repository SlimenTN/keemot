import 'package:flutter/material.dart';
import '../database/model.dart';
import './details_task_widget.dart';
import '../database/db_handler.dart';
import './new_stuff.dart';
import '../util/colors.dart' as color;
import '../util/dictionnary.dart' as dictionnary;

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
      title: Text(dictionnary.translate('delete.task')),
      content: Text(dictionnary.translate('delete.message')),
      actions: <Widget>[
        FlatButton(
          child: Text(dictionnary.translate('cancel')),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text(dictionnary.translate('yes')),
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
        builder: (_) => NewStuffWidget(task: Task.empty())
      )
    );

    _loadTasks();
  }

  void _editTask(Task task) async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewStuffWidget(task: task)
      )
    );
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: color.secondary,
      appBar: AppBar(
        title: Text(dictionnary.translate('list.repeated.tasks')),
        backgroundColor: color.primary,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_alarm),
        backgroundColor: color.primary,
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
                    onLongPress: (){
                      _editTask(task);
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