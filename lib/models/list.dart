import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask() async {
  print('[notifier] BackgroundFetch: headless event received.');
  BackgroundFetch.finish();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class ListModel extends Model {
  Map<String, dynamic> _notificationItems = {};
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  checkForDisabledNotifications() async {
    // Since one-time notifications get disabled after firing, we check constantly to see if any one-time notifications have fired.
    print('[notifier] ListModel checkForDisabledNotifications()');
    Timer.periodic(
      Duration(milliseconds: 500),
      (timer) {
        bool changedWereMade = false;
        _notificationItems.forEach((id, notificationItem) {
          if (notificationItem['willDisable'] == true &&
              notificationItem['date'] < DateTime.now().millisecondsSinceEpoch) {
            notificationItem['status'] = 'disabled';
            notificationItem['willDisable'] = false;
            changedWereMade = true;
            print(
              "[notifier] ListModel checkForDisabledNotifications(): Disabling $id ('${notificationItem['title']}') due to it having fired ",
            );
          }
        });
        if (changedWereMade) {
          _save();
          rebuild();
        }
      },
    );
  }

  _loadPrefs() async {
    SharedPreferences prefs = await _prefs;
    String notificationItems = prefs.getString('notificationItems') ?? '{}';
    _notificationItems = json.decode(notificationItems);
  }

  load() async {
    print('[notifier] ListModel _load()');

    await _loadPrefs();
    await checkIfRestored();

    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    configureBackgroundFetch();

    checkForDisabledNotifications();
  }

  Future<void> checkIfRestored() async {
    // Disable all notifications if the last time BackgroundFetch ran was before the app was installed (e.g when the ap is restored from a backup).
    // MSSE = Milliseconds Since Epoch
    SharedPreferences prefs = await _prefs;
    int lastBackgroundFecthDateMSSE = prefs.getInt('lastBackgroundFetchDate') ?? 0;

    const platform = MethodChannel('space.kasper.notifier/get_install_date');
    String installDateMSSE = await platform.invokeMethod('get_install_date');
    if (int.parse(installDateMSSE) < lastBackgroundFecthDateMSSE) {
      _disableAll();
    }
  }

  _disableAll() {
    _notificationItems.forEach((id, notificationItem) {
      notificationItem['status'] = 'disabled';
    });
    _save();
  }

  rebuild() async {
    notifyListeners();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> configureBackgroundFetch() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 60 * 8,
          stopOnTerminate: false,
          enableHeadless: true,
          startOnBoot: true,
        ), () async {
      // This is the fetch-event callback.
      print('[notifier] BackgroundFetch: Event received');

      SharedPreferences prefs = await _prefs;
      await prefs.setInt('lastBackgroundFetchDate', DateTime.now().millisecondsSinceEpoch);

      await setNotifications(appIsOpen: false);
      // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish();
    }).then((int status) {
      print('[notifier] BackgroundFetch: SUCCESS - Status: $status');
    }).catchError((e) {
      print('[notifier] BackgroundFetch: ERROR: $e');
    });
  }

  DateTime getNextDate({DateTime date, String repeat, int repeatEvery, List<bool> weekdays}) {
    int newDay = date.day;
    int newMonth = date.month;
    int newYear = date.year;

    if (repeat == 'daily') {
      newDay += repeatEvery;
    } else if (repeat == 'weekly') {
      // get the zero-based weekday of date
      int dateWeekday = date.weekday - 1;
      // get the index of the first checked weekday, starting from tomorrow
      int nextCheckedWeekdayInThisWeek = weekdays.indexOf(true, dateWeekday + 1);

      // if there is an upcoming checked weekday this week
      if (nextCheckedWeekdayInThisWeek >= 0) {
        // set newDay to the difference between the next checked weekday and today
        newDay += nextCheckedWeekdayInThisWeek - dateWeekday;
      }

      // if there is no upcoming checked weekday this week
      if (nextCheckedWeekdayInThisWeek == -1) {
        // find how many days left till monday next week. If it's currently monday (0), that's 7 days
        int daysTillMonday = (7 - dateWeekday);
        // set newDay to monday next week
        newDay += daysTillMonday;

        // skip weeks. If it's repeated every 2 weeks, add 7 days to newDay
        newDay += (7 * repeatEvery) - 7 * 1;

        // set newDay to the next checked weekday
        int firstCheckedWeekday = weekdays.indexOf(true);
        newDay += firstCheckedWeekday;
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
    _save();
  }

  setNotifications({@required bool appIsOpen}) async {
    print('[notifier] setNotifications()');

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
    print(
        '[notifier] ListModel setNotifications(): ${pendingNotificationItemIds.length} items are currently scheduled: $pendingNotificationItemIds');
    _notificationItems.forEach((id, notificationItem) {
      int next48h = DateTime.now().add(Duration(hours: 48)).millisecondsSinceEpoch;

      // handle willDisable
      if (notificationItem['repeat'] == 'never' && notificationItem['willDisable'] == true) {
        // if the notification date is in the past, disable the notification
        if (notificationItem['date'] < DateTime.now().millisecondsSinceEpoch) {
          notificationItem['status'] = 'disabled';
          notificationItem['willDisable'] = false;
        }
      }

      if (!pendingNotificationItemIds.contains(notificationItem['id']) &&
          notificationItem['date'] < next48h &&
          notificationItem['status'] == 'enabled') {
        // date to schedule notification to now
        DateTime date = DateTime.fromMillisecondsSinceEpoch(notificationItem['date']);
        // date to schedule notification to next time
        DateTime nextDate;
        nextDate = getNextDate(
          date: date,
          repeat: notificationItem['repeat'],
          repeatEvery: notificationItem['repeatEvery'],
          weekdays: List<bool>.from(notificationItem['weekdays']),
        );

        if (notificationItem['date'] < DateTime.now().millisecondsSinceEpoch) {
          // Only set date to nextDate if the notification has already fired. The date needs to be the closest future notification date. When notifications are scheduled for the first time, their date should therefore not be updated.
          date = nextDate;
          notificationItem['date'] = nextDate.millisecondsSinceEpoch;

          notificationItem['firedCount']++;
        }

        String twoDigitFiredCount = (notificationItem['firedCount'] % 100).toString();
        if (twoDigitFiredCount.length == 1) twoDigitFiredCount = '0' + twoDigitFiredCount;
        // notificationId: individual notification's id.
        int notificationId = int.parse(id + twoDigitFiredCount);
        flutterLocalNotificationsPlugin.schedule(
          notificationId,
          notificationItem['title'],
          notificationItem['description'],
          date,
          platformChannelSpecifics,
        );
        print(
            "[notifier] ListModel setNotifications(): notification $id-$twoDigitFiredCount ('${notificationItem['title']}') has been scheduled for $date. Next date: $nextDate");

        if (notificationItem['repeat'] == 'never') {
          notificationItem['willDisable'] = true;
          if (appIsOpen == true) rebuild();
        }
      }
    });
    _save();
  }

  _save() async {
    print('[notifier] ListModel _save()');
    SharedPreferences prefs = await _prefs;
    await prefs.setString('notificationItems', json.encode(_notificationItems));
  }

  Future<String> _generateId() async {
    SharedPreferences prefs = await _prefs;
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
    await setNotifications(appIsOpen: true);
    print('[notifier] ListModel add()');
    notifyListeners();
  }

  delete(String id) async {
    print('[notifier] ListModel delete()');
    _notificationItems.remove(id);

    List pastPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    await cancelNotificationIfExists(id);
    List currentPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(
        '[notifier] ListModel delete(): Cancelled ${pastPendingNotifications.length - currentPendingNotifications.length} scheduled notifications');

    await _save();
    notifyListeners();
  }

  update({String id, dynamic notificationItem}) async {
    print('[notifier] ListModel update()');
    notificationItem['id'] = id;
    notificationItem['status'] = 'enabled';
    notificationItem['willDisable'] = false;
    _notificationItems[id] = notificationItem;

    List pastPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    await cancelNotificationIfExists(id);
    List currentPendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(
        '[notifier] ListModel update(): Cancelled ${pastPendingNotifications.length - currentPendingNotifications.length} scheduled notifications');

    await _save();
    await setNotifications(appIsOpen: true);
    rebuild();
    notifyListeners();
  }
}
