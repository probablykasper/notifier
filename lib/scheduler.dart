import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'
    show AndroidAlarmManager;
import 'package:awesome_notifications/awesome_notifications.dart'
    show AwesomeNotifications;
import 'package:notifier/notification_item.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

const mainAlarmId = 0;

void scheduleNotifications() async {
  handler();
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), mainAlarmId, handler,
      rescheduleOnReboot: true);
}

void handler() async {
  var prefs = await SharedPreferences.getInstance();
  final DateTime now = DateTime.now();
  print("[$now] Notification schedule handler");
  await AwesomeNotifications().cancelAll();

  var jsonItems = prefs.getStringList("notificationItems");
  if (jsonItems == null) {
    return;
  }
  var items = jsonItems.map((jsonItem) {
    return NotificationItem.fromJson(jsonItem);
  }).toList();
  for (var i = 0; i < items.length; i++) {
    var nextDate = items[i].getNextNotificationDate();
    if (nextDate != null) {
      print("scheduleAt $nextDate ${items[i].repeat} \"${items[i].title}\"");
      items[i].scheduleAt(i, nextDate);
      items[i].lastScheduledDate = nextDate;
    }
  }
  prefs.setStringList(
      "notificationItems", items.map((item) => item.toJson()).toList());
}
