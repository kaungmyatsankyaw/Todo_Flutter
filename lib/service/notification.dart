import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo/database/db_handler.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future showToDayTomorrow() async {
    var dbHandler = DataBaseHandler();
    var tasks = await dbHandler.selectCurrentDateTask();

    for (int i = 0; i < tasks.length; i++) {
      scheduleNotification(
          flutterLocalNotificationsPlugin,
          '4',
          tasks[i]['categoryName'],
          tasks[i]['taskName'],
          formatTimeStamp(tasks[i]['dateTime']));
    }
  }

  Future setNoti(var text, var timestamp, var category) async {
  
    scheduleNotification(flutterLocalNotificationsPlugin, '4', category.name,
        text, formatTimeStamp(timestamp));
  }

  formatTimeStamp(var timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);

    return new DateTime(
        date.year, date.month, date.day, date.hour, date.minute, date.second);
  }

  Future<void> scheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String id,
      String category,
      String body,
      DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id,
      'Reminder notifications',
      'Remember about it',
      icon: 'ic_launcher',
    );
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, category, body,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    print(payload);
  }
}
