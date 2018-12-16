import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'new_stuff.dart';
import '../database/db_handler.dart';
import '../database/model.dart';
import 'coming_task_widget.dart';
import 'all_stuff.dart';
import './test_screen.dart';
import '../util/colors.dart' as color;

class ComingStufWidget extends StatefulWidget {
  @override
  _ComingStufWidgetState createState() => _ComingStufWidgetState();
}

class _ComingStufWidgetState extends State<ComingStufWidget> {
  final formatDate = DateFormat('dd/MM/yyyy');
  final dbh = DatabaseHandler.internal();
  final List<Task> _comingTasks = <Task>[];
  final int numberOfDaysToDisplayComingStuff = 7;
  FlutterLocalNotificationsPlugin notificationsPlugin;

  @override
    void initState() {
      super.initState();
      _loadComingTasks();

      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project   
      // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
      var initAndroidSettings = AndroidInitializationSettings('app_icon');
      var initIOSSettings = IOSInitializationSettings();
      var initSettings = InitializationSettings(initAndroidSettings, initIOSSettings);
      notificationsPlugin = FlutterLocalNotificationsPlugin();
      notificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
    }

  Future onSelectNotification(String payload) async{
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Here is your payload'),
        content: Text('Payload: $payload'),
      )
    );
  }

  Future _showNotificationWithDefaultSound()async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.show(
      1,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
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

  Widget _buildList(){
    if(_comingTasks.length == 0){
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Text(
                  'You are free for the next 7 days',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: color.text,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
              ),
              Container(
                // padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 70.0),
                width: 200.0,
                height: 200.0,
                child: Image.asset('images/freedom.png'),
              )
            ],
          )
        ),
      );
    }else{
      return Flexible(
        child: ListView.builder(
          itemCount: _comingTasks.length,
          itemBuilder: (_, int index){
            return ComingTask(task: _comingTasks[index]);            
          },
        ),
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
          // FlatButton(
          //   child: Icon(Icons.refresh, color: Colors.white),
          //   onPressed: _loadComingTasks,
          // ),
          // FlatButton(
          //   child: Icon(Icons.notifications),
          //   onPressed: _showNotificationWithDefaultSound,
          // ),
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
                child: Text(
                'COMING STUFF TO DO',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.blueAccent
                ),
              ),
            ),

            _buildList()
          ],
        ),
      ),
    );
  }
}