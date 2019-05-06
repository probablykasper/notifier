import 'dart:collection';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/models/src/notification.dart';

class ListModel extends Model {
  final List<NotificationItem> _notificationItems = [
    NotificationItem(title: 'nice', description: 'breat'),
    NotificationItem(title: 'cold', description: 'sheep'),
  ];

  UnmodifiableListView<NotificationItem> get items => UnmodifiableListView(_notificationItems);

  void add(NotificationItem notificationItem) {
    _notificationItems.add(notificationItem);
    notifyListeners(); // tell the model to rebuild the widgets that depend on it
  }

}
