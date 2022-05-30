// import 'package:awesome_notifications/awesome_notifications.dart'
//     show
//         AwesomeNotifications,
//         NotificationContent,
//         NotificationLayout,
//         NotificationCalendar;

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
  int date;
  // bool noSwipeAway;
  // int date;
  // int firedCount;

  NotificationItem({
    required this.title,
    required this.description,
    required this.disabled,
    required this.repeat,
    required this.date,
  });
  factory NotificationItem.getDefault() {
    var now = DateTime.now();
    return NotificationItem(
      title: '',
      description: '',
      disabled: false,
      repeat: Repeat.never,
      date: DateTime(now.year, now.month, now.day, now.hour + 2)
          .millisecondsSinceEpoch,
    );
  }

  bool timeHasPassed() => date < DateTime.now().millisecondsSinceEpoch;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'],
      description: json['description'],
      disabled: json['disabled'],
      repeat: json['repeat'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'disabled': disabled,
        'repeat': repeat,
        'date': date,
      };
}

// void scheduleNotifications() async {
//   String localTimeZone =
//       await AwesomeNotifications().getLocalTimeZoneIdentifier();
//   await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           id: id,
//           channelKey: 'scheduled',
//           title: 'Notification at exactly every single minute',
//           body:
//               'This notification was schedule to repeat at every single minute at clock.',
//           notificationLayout: NotificationLayout.BigPicture,
//           bigPicture: 'asset://assets/images/melted-clock.png'),
//       schedule: NotificationCalendar(
//           month: 1, timeZone: localTimeZone, repeats: true));
// }
