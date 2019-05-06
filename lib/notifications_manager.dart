import 'package:flutter/material.dart';
import 'package:notifier/notifications_list.dart';

// class Notification: title, description, schedule

// class Notifications: set and get in both ui and db

// class NotificationsWidget: dispaly the list of notifications

class NotificationsManager extends StatefulWidget {
  final String startingTitle;

  NotificationsManager({this.startingTitle = 'wahai'});

  @override
  State<StatefulWidget> createState() {
    return _NotificationsManagerState();
  }
}

class _NotificationsManagerState extends State<NotificationsManager> {
  List<String> _titles = [];

  @override
  void initState() {
    _titles.add(widget.startingTitle);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return NotificationsList(_titles);
  }
}
