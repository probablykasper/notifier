import 'package:flutter/material.dart';
import 'package:notifier/models/notification_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/globals.dart';
import 'package:notifier/models/list.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return NotificationDialog();
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
                  fontWeight: FontWeight.w500,
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

ListModel listModel = ListModel(load: true);

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
              listModel.items.map((item) {
                return InkWell(
                  splashColor: Globals.defaultSplashColor,
                  onTap: () => print("Someone tapped me and it felt great"),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 16,
                            // color: Color(0xff00B0FF),
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

class NotificationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building dialog ScopedModel');
    return ScopedModel<NotificationDialogModel>(
      model: NotificationDialogModel(),
      child: ScopedModelDescendant<NotificationDialogModel>(
        builder: (context, child, model) {
          print('Building dialog ScopedModelDescendant');
          return SimpleDialog(
            title: Text('Add notification'),
            contentPadding: EdgeInsets.all(12),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 12),
                width: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //* TITLE
                    TextField(
                      controller: TextEditingController(text: model.item['title']),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      onChanged: (String newValue) {
                        model.item['title'] = newValue;
                      },
                    ),
                    //* DESCRIPTION
                    TextField(
                      controller: TextEditingController(text: model.item['description']),
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      onChanged: (String newValue) {
                        model.item['description'] = newValue;
                      },
                    ),
                    SwitchListTile(
                      title: Text('Notification cannot be swiped away'),
                      value: model.item['noSwipeAway'],
                      onChanged: (bool newValue) {
                        model.item['noSwipeAway'] = newValue;
                        model.rebuild();
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //* CANCEL
                  MaterialButton(
                    minWidth: 90.0,
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Container(width: 12),
                  //* SAVE
                  MaterialButton(
                    minWidth: 90.0,
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context).pop();
                      // print(model.item);
                      // print('SAVE HERE');
                      listModel.add(model.item);
                    },
                    color: Colors.grey[700],
                    child: Text('Save'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
