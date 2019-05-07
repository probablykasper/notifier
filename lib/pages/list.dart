import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:notifier/globals.dart';
import 'package:notifier/models/src/notification.dart';
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
      body: _List(),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ListModel>(
      builder: (context, child, list) {
        return CustomScrollView(
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
            SliverList(
              delegate: SliverChildListDelegate(
                list.items.map((item) {
                  return InkWell(
                    onTap: () => print("Someone tapped me and it felt great"),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 32.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              // color: Color(0xff00B0FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item.description,
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
            )
          ],
        );
      },
    );
  }
}

class NotificationDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final NotificationItem _newNotificationItem = NotificationItem(title: '', description: '');

  @override
  build(BuildContext context) {
    return ScopedModelDescendant<ListModel>(builder: (context, child, list) {
      return Form(
        key: _formKey,
        child: SimpleDialog(
          title: Text('Add notification'),
          contentPadding: EdgeInsets.all(12),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 20),
                    onSaved: (String value) {
                      print('saved');
                      _newNotificationItem.title = value;
                    }
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                    ),
                    onSaved: (String value) {
                      _newNotificationItem.description = value;
                    }
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
                  MaterialButton(
                    minWidth: 90.0,
                    elevation: 0,
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        list.add(_newNotificationItem);
                      }
                    },
                    color: Colors.grey[700],
                    child: Text('Save'),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
