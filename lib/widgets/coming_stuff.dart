import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadComingTasks,
          ),
          // FlatButton(
          //   child: Icon(Icons.notifications),
          //   onPressed: _showNotificationWithDefaultSound,
          // ),
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