import 'dart:collection';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListModel extends Model {
  // List<NotificationItem> _notificationItems = [
  //   NotificationItem(title: 'nice', description: 'breat'),
  //   NotificationItem(title: 'cold', description: 'sheep'),
  // ];
  List _notificationItems = [];

  UnmodifiableListView get items {
    print('ListModel get items');
    return UnmodifiableListView(_notificationItems);
  }

  ListModel({load: false}) {
    print(load ? 'ListModel constructor + loading' : 'ListModel constructor');
    if (load == true) _load();
  }

  _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notificationItems = prefs.getString('notificationItems') ?? '[]';
    _notificationItems = json.decode(notificationItems);
    print('ListModel _load');
    notifyListeners();
  }

  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationItems', json.encode(_notificationItems));
    print('ListModel _save');
  }

  void add(dynamic notificationItem) async {
    _notificationItems.add(notificationItem);
    await _save();
    print('ListModel add');
    notifyListeners(); // tell the model to rebuild the widgets that depend on it
  }

}
