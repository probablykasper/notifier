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

defaultDate() {
  var now = DateTime.now();
  return DateTime(now.year, now.month, now.day, now.hour + 2);
}

class NotificationItem {
  String title;
  String description;
  bool disabled;
  String repeat;
  int repeatEvery;
  List<bool> weekdays;
  DateTime originalDate;
  DateTime? lastScheduledDate;
  // bool noSwipeAway;

  NotificationItem({
    required this.title,
    required this.description,
    required this.disabled,
    required this.repeat,
    required this.repeatEvery,
    required this.weekdays,
    required this.originalDate,
    required this.lastScheduledDate,
  });
  NotificationItem.defaultWith({
    String? title,
    String? description,
    bool? disabled,
    String? repeat,
    int? repeatEvery,
    List<bool>? weekdays,
    DateTime? originalDate,
    this.lastScheduledDate,
  })  : title = title ?? '',
        description = description ?? '',
        disabled = disabled ?? false,
        repeat = repeat ?? Repeat.never,
        repeatEvery = repeatEvery ?? 1,
        weekdays =
            weekdays ?? [false, false, false, false, false, false, false],
        originalDate = originalDate ?? defaultDate();

  factory NotificationItem.getDefault() {
    return NotificationItem.defaultWith();
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
      repeatEvery: map['repeatEvery'],
      weekdays: map['weekdays'],
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
      'repeatEvery': repeatEvery,
      'weekdays': weekdays,
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
          fromDate.day + repeatEvery,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.weekly) {
      var newDay = fromDate.day;
      final fromZeroBasedWeekday = fromDate.weekday - 1;

      // find the next checked weekday in the "current" week
      final nextCheckedWeekday =
          weekdays.indexOf(true, fromZeroBasedWeekday + 1);

      if (nextCheckedWeekday >= 0) {
        newDay += nextCheckedWeekday - fromZeroBasedWeekday;
      } else {
        // if the next date is not in this week

        // go back to monday
        newDay -= fromZeroBasedWeekday;
        // go to next week
        newDay += 7 * repeatEvery;

        // go to first checked weekday
        final firstCheckedWeekday = weekdays.indexOf(true);
        if (firstCheckedWeekday >= 0) {
          newDay += firstCheckedWeekday;
        } else {
          // if no weekday is checked, go to the originalDate weekday
          newDay += originalDate.weekday - 1;
        }
      }

      return DateTime(
        fromDate.year,
        fromDate.month,
        newDay,
        originalDate.hour,
        originalDate.minute,
        originalDate.second,
        originalDate.millisecond,
      );
    } else if (repeat == Repeat.monthly) {
      return DateTime(
          fromDate.year,
          fromDate.month + repeatEvery,
          originalDate.day,
          originalDate.hour,
          originalDate.minute,
          originalDate.second,
          originalDate.millisecond);
    } else if (repeat == Repeat.yearly) {
      return DateTime(
          fromDate.year + repeatEvery,
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

  DateTime? testGetDirectlyNextDate() {
    return _getDirectlyNextDate(lastScheduledDate);
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
    while (nextDate.isBefore(now)) {
      var nextNextDate = _getDirectlyNextDate(nextDate);
      if (nextNextDate != null && nextNextDate.isBefore(now)) {
        nextDate = nextNextDate;
      } else {
        break;
      }
    }
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
    NotificationSchedule? schedule;
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
