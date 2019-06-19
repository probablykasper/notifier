import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:ui';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class ListModel extends Model {
  Map<String, dynamic> _notificationItems = {};

  UnmodifiableMapView get items {
    print('[notifier] ListModel get items');
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
    print('[notifier] ListModel constructor');
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
    print('[notifier] listModel _load()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String notificationItems = prefs.getString('notificationItems') ?? '{}';
    _notificationItems = json.decode(notificationItems);

    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    configureBackgroundFetch();

    print('[notifier] ListModel _load');
    notifyListeners();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> configureBackgroundFetch() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          startOnBoot: true,
        ), () async {
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received');
      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      await _setNotifications();
      BackgroundFetch.finish();
    }).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
    });
  }

  _setNotifications() async {
    print('[notifier] _setNotification');

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'scheduled_notifications',
      'Scheduled Notifications',
      'Scheduled notifications configured by the user',
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

    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    List<int> pendingNotificationIds = pendingNotifications.map((pendingNotification) {
      return pendingNotification.id;
    }).toList();
    flutterLocalNotificationsPlugin.cancelAll();
    _notificationItems.forEach((idString, notificationItem) {
      int id = int.parse(idString);
      int next24h = DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch;
      if (!pendingNotificationIds.contains(notificationItem['id']) &&
          notificationItem['nextDate'] < next24h) {
        print("[notifier] notification '${notificationItem['title']}' ($id) has been scheduled");
        flutterLocalNotificationsPlugin.schedule(
          id,
          notificationItem['title'],
          notificationItem['description'],
          DateTime.fromMillisecondsSinceEpoch(notificationItem['nextDate']),
          platformChannelSpecifics,
        );
        DateTime nextDate = DateTime.fromMillisecondsSinceEpoch(notificationItem['nextDate']);
        int newDay = nextDate.day;
        int newMonth = nextDate.month;
        int newYear = nextDate.year;
        if (notificationItem['repeat'] == 'daily') {
          newDay += notificationItem['repeatEvery'];
        } else if (notificationItem['repeat'] == 'weekly') {
          List weekdays = notificationItem['weekdays'];
          int firstCheckedWeekday;
          for (int i = 0; i < 7; i++) {
            if (weekdays[i] == true) firstCheckedWeekday = i;
          }
          // i = x days in the future. Starts with tomorrow:
          int i = 1;
          while (i != 100) {
            if (nextDate.weekday + i == 7) {
              // ^ done looping through this week
              // set to monday next week:
              newDay += i;
              // skip weeks:
              newDay += 7 * notificationItem['repeatEvery'] - 1;
              // set to next checked weekday:
              newDay += firstCheckedWeekday;
            } else if (weekdays[nextDate.weekday + i] == true) {
              // ^ weekday is checked
              newDay += i;
              i = 100;
            } else {
              // ^ weekday is not checked
              i++;
            }
          }
        } else if (notificationItem['repeat'] == 'monthly') {
          newMonth += notificationItem['repeatEvery'];
        } else if (notificationItem['repeat'] == 'yearly') {
          newYear += notificationItem['repeatEvery'];
        }
        notificationItem['nextDate'] = DateTime(
          newYear,
          newMonth,
          newDay,
          nextDate.hour,
          nextDate.minute,
        ).millisecondsSinceEpoch;
      }
    });
    print(pendingNotificationIds);
  }

  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationItems', json.encode(_notificationItems));
    print('[notifier] ListModel _save');
  }

  void add(dynamic notificationItem) async {
    final int idLen = 9;
    final String id = Random.secure().nextInt(pow(10, idLen)).toString();
    notificationItem['id'] = id;
    _notificationItems[id] = notificationItem;
    await _save();
    await _setNotifications();
    print('[notifier] ListModel add');

    notifyListeners();
  }

  void delete(String id) async {
    _notificationItems.remove(id);
    await _save();
    print('[notifier] ListModel delete');
    notifyListeners();
  }

  void update({String id, dynamic notificationItem}) async {
    notificationItem['id'] = id;
    _notificationItems[id] = notificationItem;
    await _save();
    await _setNotifications();
    print('[notifier] ListModel update');
    notifyListeners();
  }
}
