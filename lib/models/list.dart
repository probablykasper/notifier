import 'dart:collection';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/models/src/notification.dart';

class ListModel extends Model {
  final List<Notification> _notifications = [
    Notification(
      title: 'nice',
      description: 'breat',
    ),
    Notification(
      title: 'cold',
      description: 'sheep',
    ),
  ];

  UnmodifiableListView<Notification> get items => UnmodifiableListView(_notifications);

  void add(Notification notification) {
    _notifications.add(notification);
    notifyListeners(); // tell the model to rebuild the widgets that depend on it
  }

}
