import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keemot/widgets/settings.dart';
import 'new_stuff.dart';
import '../database/db_handler.dart';
import '../database/model.dart';
import 'coming_task_widget.dart';
import 'all_stuff.dart';
import '../util/colors.dart' as color;
import '../util/dictionnary.dart' as dictionnary;
import '../database/settings_model.dart';

class ComingStufWidget extends StatefulWidget {
  @override
  _ComingStufWidgetState createState() => _ComingStufWidgetState();
}

class _ComingStufWidgetState extends State<ComingStufWidget> {
  final formatDate = DateFormat('dd/MM/yyyy');
  final dbh = DatabaseHandler.internal();
  final List<Task> _comingTasks = <Task>[];
  final int numberOfDaysToDisplayComingStuff = 7;
  String _selectedLang;

  @override
  void initState() {
    super.initState();
    _loadComingTasks();
  }

  void _loadComingTasks() async{
    _comingTasks.clear();
    // List list = await dbh.readComingEvents(numberOfDaysToDisplayComingStuff);
    List list = await dbh.read();
    list.forEach((dynamic object){
      Task task = Task.map(object);
      if(task.reiterationTarget == 'MONTH'){
        if(
          taskWithinThisMonth(task) 
          && taskWithinThisWeek(task)
          ) _comingTasks.add(task);

      }else if(task.reiterationTarget == 'YEAR') {
        if(
          taskWithinThisYear(task) 
          && DateTime.now().month == task.month 
          && taskWithinThisWeek(task)
          ) _comingTasks.add(task);
      }
    });
    // sort list to make sure that the closest tasks should be displayed on the top
    _comingTasks.sort((task1, task2) {
      int remainingDays1 = task1.day - DateTime.now().day;
      int remainingDays2 = task2.day - DateTime.now().day;
      return remainingDays1.compareTo(remainingDays2);
    });
    setState(() {});
  }

  // Check if the given task is within this month
  // Equation: ((currentMonth + 12) - task.month) / task.reiteration)  ==> should be integer
  bool taskWithinThisMonth(Task task){
    int currentMonth = DateTime.now().month;
    return (((currentMonth + 12) - task.month) % task.reiteration == 0);
  }

  // Check if task within this week (7 days)
  // Equation: task.day - currentDay ==> should be inferiour or equal to 7
  bool taskWithinThisWeek(Task task){
    int currentDay = DateTime.now().day;
    int diff = task.day - currentDay;
    return (diff>= 0 && diff <= numberOfDaysToDisplayComingStuff);
  }

  // Check if task within this year for tasks that has reiteration over years
  // Equation: (currentYear - task.date.year) / task.reiteration ==> should be integer
  bool taskWithinThisYear(Task task){
    int currentYear = DateTime.now().year;
    return((currentYear - task.date.year) % task.reiteration == 0);
  }

  void _addNewStuff(BuildContext context) async{
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewStuffWidget(task: Task.empty(),)
      )
    );

    _loadComingTasks();
  }

  void _goToAllTasksScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AllStuffWidget()
      )
    );
    _loadComingTasks();
  }



  void _saveSettings() async{
    Settings settings = await dbh.readSettings();
    settings.lang = _selectedLang;
    dbh.saveSettings(settings);
    dictionnary.lang = _selectedLang;
    setState(() {});
  }

  void _showSettings(){
    var alert = AlertDialog(
      title: Text(dictionnary.translate('settings')),
      content: SettingsWidget(
        selectedLang: dictionnary.lang,
        onDataChanged: (lang) => _selectedLang = lang,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(dictionnary.translate('save')),
          onPressed: () {
            _saveSettings();
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(dictionnary.translate('cancel')),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Widget _buildList(){
    if(_comingTasks.length == 0){
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                // padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 70.0),
                width: 150.0,
                height: 150.0,
                child: Image.asset('images/empty.png'),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Text(
                  dictionnary.translate('no.stuff.to.do'),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: color.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
      );
    }else{
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              dictionnary.translate('coming.stuff'),
              style: TextStyle(
                  fontSize: 25.0,
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Keemot'),
        backgroundColor: color.primary,
        actions: <Widget>[
           FlatButton(
             child: Icon(Icons.settings, color: Colors.white),
             onPressed: _showSettings,
           ),
          FlatButton(
            child: Icon(Icons.list, color: Colors.white),
            onPressed: (){
              _goToAllTasksScreen(context);
            },
          ),
          // PopupMenuButton<String>(
          //   itemBuilder: (BuildContext context){
          //     return <PopupMenuItem<String>>[
          //       PopupMenuItem<String>(
          //         child: Text('Parameters'),
          //         value: 'settings',
          //       ),
          //       PopupMenuItem<String>(
          //         child: Text('All stuff'),
          //         value: 'list_stuff'
          //       ),
          //     ];
          //   },
          //   onSelected: (value){
          //     if(value == 'list_stuff') _goToAllTasksScreen(context);
          //   },
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_alarm),
        backgroundColor: color.primary,
        onPressed: (){
           _addNewStuff(context);
        },
      ),
      body: Center(
        child: _buildList(),
      ),
    );
  }
}