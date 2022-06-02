import 'package:flutter/widgets.dart';
import 'package:get/get.dart'
    show ExtensionDialog, Get, GetxController, Inst, Obx;
import 'package:flutter/material.dart'
    show
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        CustomScrollView,
        Divider,
        EdgeInsets,
        Expanded,
        FlexibleSpaceBar,
        FloatingActionButton,
        FontWeight,
        Icon,
        IconButton,
        Icons,
        InkWell,
        Row,
        Scaffold,
        SliverAppBar,
        SliverList,
        StatelessWidget,
        Switch,
        Text,
        TextStyle,
        Theme,
        Widget;
import 'package:get/state_manager.dart';
import 'package:notifier/edit_dialog.dart';
import 'package:notifier/main.dart';
import 'package:notifier/scheduler.dart';
import 'notification_item.dart' show NotificationItem;
import 'theme.dart' show CustomTheme, toggleDarkMode;

class Controller extends GetxController {
  var items = <NotificationItem>[].obs;

  load() async {
    var prefs = await prefsFuture;
    var jsonItems = prefs.getStringList("notificationItems");
    if (jsonItems == null) {
      return;
    }
    items.value = jsonItems.map((jsonItem) {
      return NotificationItem.fromJson(jsonItem);
    }).toList();
  }

  saveAndSchedule() async {
    var prefs = await prefsFuture;
    var jsonItems = items.map((item) => item.toJson()).toList();
    prefs.setStringList("notificationItems", jsonItems);
    scheduleNotifications();
  }
}

class ListPage extends StatelessWidget {
  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());
    c.load();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Get.dialog(EditDialog(
                item: NotificationItem.getDefault(),
                editMode: false,
                onSave: (item) {
                  c.items.add(item);
                  c.saveAndSchedule();
                },
              ));
            }),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.wb_sunny),
                  onPressed: () {
                    toggleDarkMode();
                  },
                  color: Colors.white,
                )
              ],
              floating: false,
              snap: false,
              expandedHeight: 200.0,
              backgroundColor: Theme.of(context).custom.appBarBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Notifier',
                  style: Theme.of(context).custom.appTitleStyle,
                ),
                titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
              ),
            ),
            ListView(),
          ],
        ));
  }
}

class ListView extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  ListView();

  @override
  Widget build(context) {
    return Obx(
      () => SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: c.items.length,
          (context, index) => InkWell(
            onTap: () async {
              // if (item['repeat'] != 'never' &&
              //     item['date'] < DateTime.now().millisecondsSinceEpoch) {
              //   // make sure the date is not in the past for repeating notifications
              //   print(
              //       '[notifier] Running setNotifications() before opening edit dialog');
              //   await listModel.setNotifications(appIsOpen: true);
              // }
              var item = NotificationItem.fromJson(c.items[index].toJson());
              item.lastScheduledDate = item.getNextFutureDate();
              Get.dialog(EditDialog(
                item: item,
                editMode: true,
                onSave: (item) {
                  c.items[index] = item;
                  c.saveAndSchedule();
                },
              ));
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Row(
                    children: <Widget>[
                      Container(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.items[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              c.items[index].description,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    Theme.of(context).custom.descriptionColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: !c.items[index].disabled,
                        onChanged: (bool newValue) {
                          var updatedItem = c.items[index];
                          updatedItem.disabled = !newValue;
                          c.items[index] = updatedItem;
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
