import 'dart:convert';

class NotificationItem {
  // final int id;
  String title;
  String description;

  NotificationItem({this.title, this.description});

  toJson() {
    return json.encode({
      'title': title,
      'description': description,
    });
  }

  factory NotificationItem.fromJson(notificationItemJson) {
    return NotificationItem(
      title: notificationItemJson['title'],
      description: notificationItemJson['description'],
    );
  }
}
