import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/pages/notification_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/globals.dart';
import 'package:notifier/models/list.dart';

ListModel listModel = ListModel(load: true);

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return NotificationDialog(mode: 'new', listModel: listModel);
            },
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[800],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            // backgroundColor: Colors.black26,
            floating: false,
            snap: false,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Notifier',
                style: TextStyle(
                  color: Globals.blue,
                ),
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
    print('Building list ScopedModel');
    return ScopedModel<ListModel>(
      model: listModel,
      child: ScopedModelDescendant<ListModel>(
        builder: (context, child, listModel) {
          print('Building list ScopedModelDescendant');
          return SliverList(
            delegate: SliverChildListDelegate(
              listModel.itemsAsList.map((item) {
                return InkWell(
                  splashColor: Globals.defaultSplashColor,
                  onTap: () {
                    print("Someone tapped me and it felt great");
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NotificationDialog(
                          mode: 'edit',
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
                            color: Colors.grey[500],
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
