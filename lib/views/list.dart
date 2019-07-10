import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/models/notification_dialog.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:notifier/views/notification_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/models/list.dart';

ListModel listModel = ListModel(checkForDisabledNotifications: true);

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeModel = ScopedModel.of<ThemeModel>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return NotificationDialog(
                  mode: 'new',
                  initialItem: NotificationDialogModel.defaultItem(),
                  listModel: listModel);
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.wb_sunny),
                onPressed: () {
                  ScopedModel.of<ThemeModel>(context).toggleDarkMode();
                },
                color: Colors.white,
              )
            ],
            // backgroundColor: Colors.black26,
            floating: false,
            snap: false,
            expandedHeight: 200.0,
            backgroundColor: themeModel.appBarBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Notifier',
                style: themeModel.appTitleStyle,
              ),
              titlePadding: EdgeInsets.only(left: 72, bottom: 16),
            ),
          ),
          List(),
        ],
      ),
    );
  }
}

class List extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeModel = ScopedModel.of<ThemeModel>(context);
    return ScopedModel<ListModel>(
      model: listModel,
      child: ScopedModelDescendant<ListModel>(
        builder: (context, child, listModel) {
          print('[notifier] Building list (ScopedModelDescendant)');
          return SliverList(
            delegate: SliverChildListDelegate(
              listModel.itemsAsList.map((item) {
                return InkWell(
                  splashColor: themeModel.splashColor,
                  highlightColor: themeModel.highlightColor,
                  onTap: () async {
                    if (item['repeat'] != 'never' &&
                        item['date'] < DateTime.now().millisecondsSinceEpoch) {
                      // make sure the date is not in the past for repeating notifications
                      print('[notifier] Running setNotifications() before opening edit dialog');
                      await listModel.setNotifications(appIsOpen: true);
                    }
                    print("[notifier] Opening edit dialog");
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NotificationDialog(
                          mode: 'edit',
                          // clone the item so it changes to it won't be saved
                          initialItem: Map<String, dynamic>.from(item),
                          listModel: listModel,
                        );
                      },
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Switch(
                              value: item['status'] == 'enabled',
                              onChanged: (bool newValue) {
                                if (newValue == true) {
                                  if (item['repeat'] == 'never' &&
                                      item['date'] < DateTime.now().millisecondsSinceEpoch) {
                                    return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return NotificationDialog(
                                          mode: 'edit',
                                          // clone the item so it changes to it won't be saved
                                          initialItem: Map<String, dynamic>.from(item),
                                          listModel: listModel,
                                        );
                                      },
                                    );
                                  } else {
                                    item['status'] = 'enabled';
                                    listModel.setNotifications(appIsOpen: true);
                                  }
                                } else {
                                  item['status'] = 'disabled';
                                  listModel.cancelNotificationIfExists(item['id']);
                                }
                                listModel.rebuild();
                              },
                            ),
                            Container(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    item['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: themeModel.descriptionColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
