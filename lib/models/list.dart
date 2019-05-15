import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


String generateId() {
  const strlen = 8;
  const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

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

  void add(dynamic notificationItem) async {
    final id = generateId();
    notificationItem['id'] = id;
    _notificationItems[id] = notificationItem;
    await _save();
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
    print('ListModel update');
    notifyListeners();
  }

}
