import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/models/notification_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:notifier/models/list.dart';

import 'package:notifier/globals.dart';

class NotificationDialog extends StatefulWidget {
  final Map<String, dynamic> initialItem;
  final String mode;
  final ListModel listModel;

  NotificationDialog({this.mode, this.initialItem, this.listModel});

  @override
  NotificationDialogState createState() {
    return NotificationDialogState(mode: mode, initialItem: initialItem, listModel: listModel);
  }
}

class NotificationDialogState extends State<NotificationDialog> {
  final Map<String, dynamic> initialItem;
  final String mode;
  final ListModel listModel;

  NotificationDialogState({this.mode, this.initialItem, this.listModel});

  Future _pickDateTime(BuildContext context, NotificationDialogModel model) async {
    final firstDate = DateTime.now().subtract(Duration(days: 1));
    var initialDateTime = DateTime.fromMillisecondsSinceEpoch(model.item['date']);
    if (initialDateTime.isBefore(firstDate)) {
      initialDateTime = firstDate;
    }

    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDate,
      lastDate: DateTime(3000),
      builder: (BuildContext context, Widget child) {
        return Theme(
          child: child,
          data: globals.pickerTheme,
        );
      },
    );

    if (pickedDate == null) return;

    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
      builder: (BuildContext context, Widget child) {
        return Theme(
          child: child,
          data: globals.pickerTheme,
        );
      },
    );

    if (pickedTime == null) return;

    final newDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    model.item['date'] = newDate.millisecondsSinceEpoch;
    model.rebuild();
  }

  final formKey = GlobalKey<FormState>();

  FocusNode descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    this.descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    this.descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building dialog ScopedModel');
    return ScopedModel<NotificationDialogModel>(
      model: NotificationDialogModel(initialItem: initialItem),
      child: ScopedModelDescendant<NotificationDialogModel>(
        builder: (context, child, model) {
          print('Building dialog ScopedModelDescendant');
          //* TITLE
          final title = TextFormField(
            // style: TextStyle(fontSize: 24),
            initialValue: model.item['title'],
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Title',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            ),
            onSaved: (String newValue) {
              model.item['title'] = newValue;
            },
            onFieldSubmitted: (String newValue) {
              FocusScope.of(context).requestFocus(descriptionFocusNode);
            },
          );
          //* DESCRIPTION
          final description = TextFormField(
            initialValue: model.item['description'],
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Description',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            ),
            onSaved: (String newValue) {
              model.item['description'] = newValue;
            },
            focusNode: descriptionFocusNode,
          );
          return Form(
            key: formKey,
            child: SimpleDialog(
              // everything should have a horizontal padding of 24
              contentPadding: EdgeInsets.all(0),
              title: Text('Add notification'),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 12, bottom: 0),
                  width: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      title,
                      description,
                      //* CANNOT BE SWIPED AWAY?
                      ListTile(
                        // this is not a SwitchListTile because that doesn't support padding
                        contentPadding: EdgeInsets.symmetric(horizontal: 24),
                        title: Text('Notification cannot be swiped away'),
                        onTap: () {
                          model.item['noSwipeAway'] = !model.item['noSwipeAway'];
                          model.rebuild();
                        },
                        trailing: Switch(
                            value: model.item['noSwipeAway'],
                            onChanged: (bool newValue) {
                              model.item['noSwipeAway'] = newValue;
                              model.rebuild();
                            }),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 24),
                        leading: Icon(Icons.calendar_today),
                        title: Text('Time'),
                        subtitle: Text(
                          DateFormat("MMMM d, y 'at' h:mm a").format(
                            DateTime.fromMillisecondsSinceEpoch(model.item['date']),
                          ),
                        ),
                        onTap: () async {
                          print('Selecting date');
                          // _selectDate(context, model);
                          _pickDateTime(context, model);
                          model.rebuild();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //* DELETE
                      (() {
                        if (mode == 'edit')
                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: MaterialButton(
                              highlightColor: globals.highlightColor,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                listModel.delete(model.item['id']);
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete', style: globals.buttonTextStyle),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        else
                          return Container();
                      })(),
                      //* CANCEL
                      MaterialButton(
                        highlightColor: globals.highlightColor,
                        splashColor: Colors.transparent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel', style: globals.buttonTextStyle),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Container(width: 12),
                      //* SAVE
                      MaterialButton(
                        splashColor: Colors.transparent,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).pop();
                          formKey.currentState.save();
                          if (mode == 'new') {
                            listModel.add(model.item);
                          } else if (mode == 'edit') {
                            listModel.update(id: model.item['id'], notificationItem: model.item);
                          }
                        },
                        color: globals.primaryButtonColor,
                        textColor: globals.primaryButtonTextColor,
                        highlightColor: globals.highlightColor,
                        child: Text('Save', style: globals.buttonTextStyle),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
