import 'dart:isolate' show Isolate;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'
    show AndroidAlarmManager;
import 'package:awesome_notifications/awesome_notifications.dart'
    show AwesomeNotifications, NotificationContent;
// import 'package:shared_preferences/shared_preferences.dart'
//     show SharedPreferences;

const mainAlarmId = 0;

void scheduleNotifications() async {
  handler();
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), mainAlarmId, handler,
      rescheduleOnReboot: true);
}

void handler() async {
  // var prefs = await SharedPreferences.getInstance();
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId");

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'scheduled_notifications',
      title: 'Simple Notification',
      body: 'Simple body',
    ),
  );
}
