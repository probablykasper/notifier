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
  // bool noSwipeAway;
  // int date;
  // int firedCount;

  NotificationItem({
    required this.title,
    required this.description,
    required this.disabled,
    required this.repeat,
  });

  NotificationItem.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        disabled = json['disabled'],
        repeat = json['repeat'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'disabled': disabled,
        'repeat': repeat,
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
