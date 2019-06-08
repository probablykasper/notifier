import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:ui';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class ListModel extends Model {
  Map<String, dynamic> _notificationItems = {};

  UnmodifiableMapView get items {
    print('ListModel get items');
    return UnmodifiableMapView(_notificationItems);
  }

  List get itemsAsList {
    List listOfItems = [];
    _notificationItems.forEach((index, item) {
      listOfItems.add(item);
    });
    return listOfItems;
  }

  ListModel({load: false}) {
    print(load ? 'ListModel constructor + loading' : 'ListModel constructor');
    if (load == true) _load();
    // initialize notification plugin:
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notificationItems = prefs.getString('notificationItems') ?? '{}';
    _notificationItems = json.decode(notificationItems);
    print('ListModel _load');
    notifyListeners();
  }

  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationItems', json.encode(_notificationItems));
    print('ListModel _save');
  }

  Future<void> _addNotification(dynamic notificationItem) async {
    print('_addNotification');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        icon: 'app_icon',
        color: Color(0x00B0FF),
        ledColor: Color(0x00B0FF),
        ledOnMs: 1000,
        ledOffMs: 500,
        enableLights: true,
        );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    if (notificationItem['repeat'] == 'never') {
      await flutterLocalNotificationsPlugin.schedule(
        int.parse(notificationItem['id']),
        notificationItem['title'],
        notificationItem['description'],
        DateTime.fromMillisecondsSinceEpoch(notificationItem['date']),
        platformChannelSpecifics,
      );
      print('SCHEDULED NOTIFICATION');
    } else if (notificationItem['repeat'] == 'daily') {
    } else if (notificationItem['repeat'] == 'weekly') {
    } else if (notificationItem['repeat'] == 'monthly') {
    } else if (notificationItem['repeat'] == 'yearly') {}
  }

  void add(dynamic notificationItem) async {
    final int idLen = 9;
    final String id = Random.secure().nextInt(pow(10, idLen)).toString();
    notificationItem['id'] = id;
    _notificationItems[id] = notificationItem;
    await _save();
    await _addNotification(notificationItem);
    print('ListModel add');

    notifyListeners();
  }

  void delete(String id) async {
    _notificationItems.remove(id);
    await _save();
    print('ListModel delete');
    notifyListeners();
  }

  void update({String id, dynamic notificationItem}) async {
    notificationItem['id'] = id;
    _notificationItems[id] = notificationItem;
    await _save();
    await _addNotification(notificationItem);
    print('ListModel update');
    notifyListeners();
  }
}
