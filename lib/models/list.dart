import 'dart:collection';
import 'dart:convert';
import 'dart:core';
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

  List<Map<String, dynamic>> get itemsAsList {
    List<Map<String, dynamic>> listOfItems = [];
    _notificationItems.forEach((index, item) {
      listOfItems.add(item);
    });
    return listOfItems;
  }

  ListModel() {
    print('[notifier] ListModel constructor');
    _load();
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
          minimumFetchInterval: 60*8,
          stopOnTerminate: false,
          enableHeadless: true,
          startOnBoot: true,
        ), () async {
      // This is the fetch-event callback.
      print('[BackgroundFetch] Event received');
      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      await setNotifications();
      BackgroundFetch.finish();
    }).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
    });
  }

  DateTime getNextDate({DateTime date, String repeat, int repeatEvery, List<bool> weekdays}) {
    int newDay = date.day;
    int newMonth = date.month;
    int newYear = date.year;

    if (repeat == 'daily') {
      newDay += repeatEvery;
    } else if (repeat == 'weekly') {
      int firstCheckedWeekday = weekdays.indexOf(true);
      // i = x days in the future. Starts with tomorrow:
      int i = 1;
      while (i != 100) {
        if (date.weekday + i == 7) {
          // ^ done looping through this week
          // set to monday next week:
          newDay += i;
          // skip weeks:
          newDay += 7 * repeatEvery - 1;
          // set to next checked weekday:
          newDay += firstCheckedWeekday;
        } else if (weekdays[date.weekday - 1] == true) {
          // ^ weekday is checked
          newDay += i;
          i = 100;
        } else {
          // ^ weekday is not checked
          i++;
        }
      }
    } else if (repeat == 'monthly') {
      newMonth += repeatEvery;
    } else if (repeat == 'yearly') {
      newYear += repeatEvery;
    }
    return DateTime(newYear, newMonth, newDay, date.hour, date.minute);
  }

  cancelNotificationIfExists(String id) async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    pendingNotifications.forEach((pendingNotification) {
      String notificationId = pendingNotification.id.toString();
      if (notificationId.length > 1) {
        String pendingId = notificationId.substring(0, notificationId.length - 1);
        if (id == pendingId) flutterLocalNotificationsPlugin.cancel(pendingNotification.id);
      }
    });
  }

  setNotifications() async {
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
    List<String> pendingNotificationItemIds = pendingNotifications.map((pendingNotification) {
      String id = pendingNotification.id.toString();
      if (id.length > 1)
        return id.substring(0, id.length - 1);
      else
        return null;
    }).toList();
    print('[notifier] ${pendingNotificationItemIds.length} items are currently scheduled:');
    print('[notifier] $pendingNotificationItemIds');
    _notificationItems.forEach((id, notificationItem) {
      int next48h = DateTime.now().add(Duration(hours: 48)).millisecondsSinceEpoch;
      if (!pendingNotificationItemIds.contains(notificationItem['id']) &&
          notificationItem['date'] < next48h &&
          notificationItem['disabled'] == false) {
        // date to schedule notification to now
        DateTime date = DateTime.fromMillisecondsSinceEpoch(notificationItem['date']);
        // date to schedule notification to next time
        DateTime nextDate = getNextDate(
          date: date,
          repeat: notificationItem['repeat'],
          repeatEvery: notificationItem['repeatEvery'],
          weekdays: List<bool>.from(notificationItem['weekdays']),
        );

        // Only set date to nextDate if the notification has already fired. The date needs to be the closest future notification date. When notifications are scheduled for the first time, their date should therefore not be updated.
        if (notificationItem['date'] < DateTime.now().millisecondsSinceEpoch) {
          date = nextDate;
          notificationItem['date'] = nextDate.millisecondsSinceEpoch;
        }

        String oneDigitFiredCount = (notificationItem['firedCount'] % 10).toString();
        // notificationId: individual notification's id.
        int notificationId = int.parse(id + oneDigitFiredCount);
        flutterLocalNotificationsPlugin.schedule(
          notificationId,
          notificationItem['title'],
          notificationItem['description'],
          date,
          platformChannelSpecifics,
        );
        notificationItem['firedCount']++;
        print(
            "[notifier] notification $id-$oneDigitFiredCount ('${notificationItem['title']}') has been scheduled for $date. Next date: $nextDate");

        if (notificationItem['repeat'] == 'never') notificationItem['disabled'] = true;
      }
    });
  }

  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationItems', json.encode(_notificationItems));
    print('[notifier] ListModel _save');
  }

  Future<String> _generateId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // notifications start at 1 because individual notification ids get extra digits added to the end
    int id = 1 + (prefs.getInt('lastId') ?? 0);
    await prefs.setInt('lastId', id);
    return id.toString();
  }

  add(dynamic notificationItem) async {
    final String id = await _generateId();
    notificationItem['id'] = id;
    _notificationItems[id] = notificationItem;
    await _save();
    await setNotifications();
    print('[notifier] ListModel add');
    notifyListeners();
  }

  delete(String id) async {
    _notificationItems.remove(id);

    List pastPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    await cancelNotificationIfExists(id);
    List currentPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(
        '[notifier] Cancelled ${pastPendingNotifications.length - currentPendingNotifications.length} scheduled notifications');

    await _save();
    print('[notifier] ListModel delete');
    notifyListeners();
  }

  update({String id, dynamic notificationItem}) async {
    notificationItem['id'] = id;
    notificationItem['disabled'] = false;
    _notificationItems[id] = notificationItem;

    List pastPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    await cancelNotificationIfExists(id);
    List currentPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(
        '[notifier] Cancelled ${pastPendingNotifications.length - currentPendingNotifications.length} scheduled notifications');

    await _save();
    await setNotifications();
    print('[notifier] ListModel update');
    notifyListeners();
  }
}
