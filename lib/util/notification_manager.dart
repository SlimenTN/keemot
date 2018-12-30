import 'dart:math';

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
    print('onSelectNotification called');
    // showDialog(
    //   context: context,
    //   builder: (_) => AlertDialog(
    //     title: const Text('Here is your payload'),
    //     content: Text('Payload: $payload'),
    //   )
    // );
  }

  Future schedual(DateTime date, String title, String body) async{
    int id = new Random().nextInt(1000);
    var scheduledNotificationDateTime = date;
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(
        'keemot channel $id',
        'your other channel name $id',
        'your other channel description $id');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.schedule(
        id,
        title,
        body,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
}