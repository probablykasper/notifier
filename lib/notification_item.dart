import 'dart:convert' show json;
import 'package:awesome_notifications/awesome_notifications.dart'
    show AwesomeNotifications, NotificationContent, NotificationCalendar;

enum Repeat {
  never,
  daily,
  weekly,
  monthly,
  yearly,
}

class NotificationItem {
  String title;
  String description;
  bool disabled;
  Repeat repeat;
  DateTime originalDate;
  DateTime? lastScheduledDate;

  // bool noSwipeAway;
  // int date;
  // int firedCount;

  NotificationItem({
    required this.title,
    required this.description,
    required this.disabled,
    required this.repeat,
    required this.originalDate,
    required this.lastScheduledDate,
  });
  factory NotificationItem.getDefault() {
    var now = DateTime.now();
    return NotificationItem(
      title: '',
      description: '',
      disabled: false,
      repeat: Repeat.never,
      originalDate: DateTime(now.year, now.month, now.day, now.hour + 2),
      lastScheduledDate: null,
    );
  }

  bool timeHasPassed() =>
      originalDate.millisecondsSinceEpoch <
      DateTime.now().millisecondsSinceEpoch;

  DateTime getLatestDate() {
    return lastScheduledDate ?? originalDate;
  }

  factory NotificationItem.fromJson(String str) {
    var map = json.decode(str);
    return NotificationItem(
      title: map['title'],
      description: map['description'],
      disabled: map['disabled'],
      repeat: map['repeat'],
      originalDate: DateTime.fromMillisecondsSinceEpoch(map['originalDate']),
      lastScheduledDate: DateTime.fromMillisecondsSinceEpoch(map['lastDate']),
    );
  }

  String toJson() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'disabled': disabled,
      'repeat': repeat,
      'originalDate': originalDate.millisecondsSinceEpoch,
      'lastDate': lastScheduledDate?.millisecondsSinceEpoch,
    };
    return json.encode(map);
  }

  DateTime? getNextDate() {
    if (lastScheduledDate == null) {
      return originalDate;
    } else if (repeat == Repeat.never) {
      return null;
    } else if (repeat == Repeat.daily) {
      return DateTime(
          lastScheduledDate!.year,
          lastScheduledDate!.month,
          lastScheduledDate!.day + 1,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.weekly) {
      return DateTime(
          lastScheduledDate!.year,
          lastScheduledDate!.month,
          lastScheduledDate!.day + 7,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.monthly) {
      return DateTime(
          lastScheduledDate!.year,
          lastScheduledDate!.month + 1,
          originalDate.day,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.yearly) {
      return DateTime(
          lastScheduledDate!.year,
          originalDate.month,
          originalDate.day,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else {
      // never happens
      return null;
    }
  }

  scheduleAt(int id, DateTime date) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_notifications',
        title: title,
        body: description,
      ),
      schedule: NotificationCalendar(
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        second: date.second,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );
  }
}
