import 'dart:convert' show json;
import 'package:awesome_notifications/awesome_notifications.dart'
    show
        AwesomeNotifications,
        NotificationCalendar,
        NotificationContent,
        NotificationSchedule;

abstract class Repeat {
  static const never = "never";
  static const daily = "daily";
  static const weekly = "weekly";
  static const monthly = "monthly";
  static const yearly = "yearly";
}

class NotificationItem {
  String title;
  String description;
  bool disabled;
  String repeat;
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

  DateTime getLatestDate() {
    return lastScheduledDate ?? originalDate;
  }

  bool timeHasPassed() {
    return getLatestDate().millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch;
  }

  factory NotificationItem.fromJson(String str) {
    var map = json.decode(str);
    return NotificationItem(
      title: map['title'],
      description: map['description'],
      disabled: map['disabled'],
      repeat: map['repeat'],
      originalDate: DateTime.fromMillisecondsSinceEpoch(map['originalDate']),
      lastScheduledDate: map['lastDate'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['lastDate']),
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

  // Get the next date from the last scheduled date
  DateTime? _getDirectlyNextDate(DateTime? fromDate) {
    if (fromDate == null) {
      return originalDate;
    } else if (fromDate.isAfter(DateTime.now())) {
      return fromDate;
    } else if (repeat == Repeat.never) {
      return null;
    } else if (repeat == Repeat.daily) {
      return DateTime(
          fromDate.year,
          fromDate.month,
          fromDate.day + 1,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.weekly) {
      return DateTime(
          fromDate.year,
          fromDate.month,
          fromDate.day + 7,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.monthly) {
      return DateTime(
          fromDate.year,
          fromDate.month + 1,
          originalDate.day,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.yearly) {
      return DateTime(
          fromDate.year,
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

  /// Get the next date for scheduling a notification.
  /// Returns null for already scheduled non-repeating dates.
  DateTime? getNextNotificationDate() {
    var directlyNextDate = _getDirectlyNextDate(lastScheduledDate);
    if (directlyNextDate == null) {
      return null;
    }
    // If the next date is far in the past, skip forward to the most recent date,
    // but not into the future because then we could be
    var now = DateTime.now();
    var nextDate = directlyNextDate;
    print("getNextNotificationDate");
    while (nextDate.isBefore(now)) {
      var nextNextDate = _getDirectlyNextDate(nextDate);
      if (nextNextDate != null && nextNextDate.isBefore(now)) {
        nextDate = nextNextDate;
      } else {
        break;
      }
    }
    print("-getNextNotificationDate");
    return nextDate;
  }

  /// Get the next date for scheduling a notification, but only in the future.
  /// Returns null for already scheduled non-repeating dates.
  DateTime? getNextFutureDate() {
    var directlyNextDate = _getDirectlyNextDate(lastScheduledDate);
    if (directlyNextDate == null) {
      return null;
    }
    // If the next date is far in the past, skip forward to the most recent date,
    // but not into the future because then we could be
    var now = DateTime.now();
    var nextDate = directlyNextDate;
    while (nextDate.isBefore(now)) {
      var nextNextDate = _getDirectlyNextDate(nextDate);
      if (nextNextDate != null) {
        nextDate = nextNextDate;
      } else {
        break;
      }
    }
    return nextDate;
  }

  scheduleAt(int id, DateTime date) {
    NotificationSchedule? schedule = null;
    if (date.isAfter(DateTime.now())) {
      schedule = NotificationCalendar(
        year: date.year,
        month: date.month,
        day: date.day,
        hour: date.hour,
        minute: date.minute,
        second: date.second,
        preciseAlarm: true,
        allowWhileIdle: true,
      );
    }
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled_notifications',
        title: title,
        body: description,
      ),
      schedule: schedule,
    );
  }
}
