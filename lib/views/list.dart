import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/models/notification_dialog.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:notifier/views/notification_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/models/list.dart';

ListModel listModel = ListModel();

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
    print('[notifier] Building list ScopedModel');
    final themeModel = ScopedModel.of<ThemeModel>(context);
    return ScopedModel<ListModel>(
      model: listModel,
      child: ScopedModelDescendant<ListModel>(
        builder: (context, child, listModel) {
          print('[notifier] Building list ScopedModelDescendant');
          return SliverList(
            delegate: SliverChildListDelegate(
              listModel.itemsAsList.map((item) {
                return InkWell(
                  splashColor: themeModel.splashColor,
                  highlightColor: themeModel.highlightColor,
                  onTap: () {
                    print("[notifier] Someone tapped me and it felt great");
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
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
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
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
