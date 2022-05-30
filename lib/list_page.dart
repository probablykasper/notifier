import 'package:flutter/widgets.dart';
import 'package:get/get.dart'
    show
        ExtensionDialog,
        Get,
        GetNavigation,
        GetxController,
        Inst,
        Obx,
        RxInt,
        StringExtension;
import 'package:flutter/material.dart'
    show
        AppBar,
        Center,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        CustomScrollView,
        Divider,
        EdgeInsets,
        ElevatedButton,
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
        SliverChildListDelegate,
        SliverList,
        StatelessWidget,
        Switch,
        Text,
        TextStyle,
        Theme,
        Widget;
import 'package:get/state_manager.dart';
import 'notification_items.dart' show NotificationItem, Repeat;
import 'theme.dart' show CustomTheme, toggleDarkMode;

class Controller extends GetxController {
  var items = <NotificationItem>[].obs;
}

class ListPage extends StatelessWidget {
  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              print("Add notification item");
              c.items.add(NotificationItem(
                title: 'Yo',
                description: 'Ddd',
              ));
              c.refresh();
            }),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.wb_sunny),
                  onPressed: () {
                    print("Toggle dark mode");
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
              print("[notifier] Opening edit dialog");
              // return showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return NotificationDialog(
              //       mode: 'edit',
              //       // clone the item so it changes to it won't be saved
              //       initialItem: Map<String, dynamic>.from(item),
              //       listModel: listModel,
              //     );
              //   },
              // );
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                // color: themeModel.descriptionColor,
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
