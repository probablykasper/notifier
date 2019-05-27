import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/models/notification_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
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
              return NotificationDialog(mode: 'new');
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
                            initialItem: Map<String, dynamic>.from(item));
                      },
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
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

class NotificationDialog extends StatelessWidget {
  final Map<String, dynamic> initialItem;
  final String mode;

  NotificationDialog({this.mode, this.initialItem});

  Future<Null> _selectDate(
      BuildContext context, NotificationDialogModel model) async {
    final firstDate = DateTime.now().subtract(Duration(days: 1));
    var initialDate = DateTime.fromMillisecondsSinceEpoch(model.item['date']);
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(3000),
    );

    if (pickedDate != null && pickedDate != model.item['date']) {
      final newDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        initialDate.hour,
        initialDate.minute,
      );
      model.item['date'] = newDate.millisecondsSinceEpoch;
      model.rebuild();
    }
  }

  Future<Null> _selectTime(
      BuildContext context, NotificationDialogModel model) async {
    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != model.item['time']) {
      final selectedDate =
          DateTime.fromMillisecondsSinceEpoch(model.item['date']);

      final newDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      model.item['date'] = newDate.millisecondsSinceEpoch;
      model.rebuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Building dialog ScopedModel');
    return ScopedModel<NotificationDialogModel>(
      model: NotificationDialogModel(initialItem: initialItem),
      child: ScopedModelDescendant<NotificationDialogModel>(
        builder: (context, child, model) {
          print('Building dialog ScopedModelDescendant');
          double bp = 12.0;
          return SimpleDialog(
            titlePadding:
                EdgeInsets.fromLTRB(24.0 - bp, 24.0 - bp, 24.0 - bp, 0.0),
            contentPadding: EdgeInsets.all(0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: bp),
                  child: Text(
                    'Add notification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 12.0 - bp, bottom: 16),
                child: Container(
                  padding: EdgeInsets.only(top: 8, bottom: 12),
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //* TITLE
                      TextField(
                        controller:
                            TextEditingController(text: model.item['title']),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        onChanged: (String newValue) {
                          model.item['title'] = newValue;
                        },
                      ),
                      //* DESCRIPTION
                      TextField(
                        controller: TextEditingController(
                            text: model.item['description']),
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        onChanged: (String newValue) {
                          model.item['description'] = newValue;
                        },
                      ),
                      //* CANNOT BE SWIPED AWAY?
                      SwitchListTile(
                        title: Text('Notification cannot be swiped away'),
                        value: model.item['noSwipeAway'],
                        onChanged: (bool newValue) {
                          model.item['noSwipeAway'] = newValue;
                          model.rebuild();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Date'),
                        subtitle: Text(
                          DateFormat.yMMMMd().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  model.item['date'])),
                        ),
                        onTap: () async {
                          print('Selecting date');
                          _selectDate(context, model);
                          model.rebuild();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.schedule),
                        title: Text('Time'),
                        subtitle: Text(
                          DateFormat('h:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  model.item['date'])),
                        ),
                        onTap: () async {
                          print('Selecting time');
                          _selectTime(context, model);
                          model.rebuild();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    //* DELETE
                    (() {
                      if (mode == 'edit')
                        return Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: MaterialButton(
                            minWidth: 85.0,
                            elevation: 0,
                            onPressed: () {
                              listModel.delete(model.item['id']);
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete'),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        );
                      else
                        return Container();
                    })(),
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
                        if (mode == 'new') {
                          listModel.add(model.item);
                        } else if (mode == 'edit') {
                          listModel.update(
                              id: model.item['id'],
                              notificationItem: model.item);
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
          );
        },
      ),
    );
  }
}
