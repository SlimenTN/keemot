import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificaitonManager{
  FlutterLocalNotificationsPlugin notificationsPlugin;

  NotificaitonManager.init(){
    var initAndroidSettings = AndroidInitializationSettings('app_icon');
    var initIOSSettings = IOSInitializationSettings();
    var initSettings = InitializationSettings(initAndroidSettings, initIOSSettings);
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async{
    // showDialog(
    //   context: context,
    //   builder: (_) => AlertDialog(
    //     title: const Text('Here is your payload'),
    //     content: Text('Payload: $payload'),
    //   )
    // );
  }

  Future schedual(DateTime date, String title, String body){
      // DateTime.now().
  }
}