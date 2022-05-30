import 'dart:isolate' show Isolate;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'
    show AndroidAlarmManager;

const mainAlarmId = 0;

void scheduleNotifications() async {
  handler();
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), mainAlarmId, handler,
      rescheduleOnReboot: true);
}

void handler() async {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId");
}
