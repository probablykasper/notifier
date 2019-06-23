import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/models/notification_dialog.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:notifier/views/letter_checkbox.dart';
import 'package:notifier/views/custom_text_form_field.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:notifier/models/list.dart';

class NotificationDialog extends StatefulWidget {
  final Map<String, dynamic> initialItem;
  final String mode;
  final ListModel listModel;

  NotificationDialog({this.mode, this.initialItem, this.listModel});

  @override
  NotificationDialogState createState() {
    if (mode == 'edit' &&
        initialItem['repeat'] != 'never' &&
        initialItem['date'] < DateTime.now().millisecondsSinceEpoch) {
      // when editing a repeating notification, don't start with a date in the past
      initialItem['date'] = initialItem['nextDate'];
    }
    return NotificationDialogState(mode: mode, initialItem: initialItem, listModel: listModel);
  }
}

class NotificationDialogState extends State<NotificationDialog> {
  final Map<String, dynamic> initialItem;
  final String mode;
  final ListModel listModel;

  NotificationDialogState({this.mode, this.initialItem, this.listModel});

  Future _pickDateTime(BuildContext context, NotificationDialogModel model) async {
    final themeModel = ScopedModel.of<ThemeModel>(context);
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
          data: themeModel.pickerTheme,
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
          data: themeModel.pickerTheme,
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
    model.item['nextDate'] = newDate.millisecondsSinceEpoch;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    final themeModel = ScopedModel.of<ThemeModel>(context);
    bool titleHasChanged = false;
    print('[notifier] Building dialog ScopedModel');
    return ScopedModel<NotificationDialogModel>(
      model: NotificationDialogModel(initialItem: initialItem),
      child: ScopedModelDescendant<NotificationDialogModel>(
        builder: (context, child, model) {
          print('[notifier] Building dialog ScopedModelDescendant');
          bool noWeekdaySelected() =>
              model.item['repeat'] == 'weekly' && !model.item['weekdays'].contains(true);
          bool timeHasPassed() => model.item['date'] < DateTime.now().millisecondsSinceEpoch;
          bool saveDisabled() => noWeekdaySelected() || timeHasPassed();
          //* TITLE
          final title = CustomTextFormField(
            initialValue: model.item['title'],
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            autovalidate: true,
            validator: (value) {
              if (value == '' && titleHasChanged) return 'Write something, bro';
              return null;
            },
            onChanged: (String newValue) {
              if (titleHasChanged) titleHasChanged = true;
            },
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
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                        child: title,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                        child: description,
                      ),
                      //* CANNOT BE SWIPED AWAY?
                      // ListTile(
                      //   // this is not a SwitchListTile because that doesn't support padding
                      //   contentPadding: EdgeInsets.symmetric(horizontal: 24),
                      //   title: Text('Notification cannot be swiped away'),
                      //   onTap: () {
                      //     model.item['noSwipeAway'] = !model.item['noSwipeAway'];
                      //     model.rebuild();
                      //   },
                      //   trailing: Switch(
                      //       value: model.item['noSwipeAway'],
                      //       onChanged: (bool newValue) {
                      //         model.item['noSwipeAway'] = newValue;
                      //         model.rebuild();
                      //       }),
                      // ),
                      //* TIME
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 24),
                        leading: Icon(Icons.calendar_today),
                        title: Text('Time'),
                        isThreeLine: timeHasPassed(),
                        // subtitle: Text(
                        //   DateFormat("MMMM d, y 'at' h:mm a").format(
                        //     DateTime.fromMillisecondsSinceEpoch(model.item['date']),
                        //   ),
                        // ),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: DateFormat("MMMM d, y 'at' h:mm a").format(
                                  DateTime.fromMillisecondsSinceEpoch(model.item['date']),
                                ),
                              ),
                              TextSpan(
                                text: !timeHasPassed() ? '' : '\nTIme has passed',
                                style: TextStyle(
                                  color: themeModel.errorText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          print('[notifier] Selecting date');
                          await _pickDateTime(context, model);
                          model.rebuild();
                        },
                      ),
                      //* REPEAT
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: <Widget>[
                            FormField(
                              initialValue: model.item['repeat'],
                              onSaved: (newValue) {
                                model.item['repeat'] = newValue;
                              },
                              builder: (FormFieldState state) {
                                return DropdownButton(
                                  onChanged: (newValue) {
                                    model.item['repeat'] = newValue;
                                    state.didChange(newValue);
                                    model.rebuild();
                                  },
                                  value: state.value,
                                  elevation: 16,
                                  style: TextStyle(
                                    inherit: true,
                                    fontFamily: 'Jost',
                                    color: themeModel.textColor,
                                    fontSize: 15,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'never',
                                      child: Text("Doesn't Repeat"),
                                    ),
                                    DropdownMenuItem(
                                      value: 'daily',
                                      child: Text("Repeat Daily"),
                                    ),
                                    DropdownMenuItem(
                                      value: 'weekly',
                                      child: Text("Repeat Weekly"),
                                    ),
                                    DropdownMenuItem(
                                      value: 'yearly',
                                      child: Text("Repeat Yearly"),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Container(width: 6),
                            (() {
                              if (model.item['repeat'] == 'never') {
                                return Container();
                              } else {
                                return Text('every', style: TextStyle(fontSize: 15));
                              }
                            })(),
                            Container(width: 6),
                            (() {
                              if (model.item['repeat'] == 'never') {
                                return Container();
                              } else {
                                return Container(
                                  width: 35,
                                  child: TextFormField(
                                    initialValue: model.item['repeatEvery'].toString(),
                                    onSaved: (String newValue) {
                                      if (newValue == '')
                                        model.item['repeatEvery'] = 1;
                                      else
                                        model.item['repeatEvery'] = int.parse(newValue);
                                    },
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.numberWithOptions(
                                      signed: false,
                                      decimal: false,
                                    ),
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(RegExp('^0\$')),
                                      WhitelistingTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: '1',
                                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                                    ),
                                  ),
                                );
                              }
                            })(),
                            Container(width: 6),
                            (() {
                              if (model.item['repeat'] == 'daily') {
                                return Text('days', style: TextStyle(fontSize: 15));
                              } else if (model.item['repeat'] == 'weekly') {
                                return Text('weeks', style: TextStyle(fontSize: 15));
                              } else if (model.item['repeat'] == 'monthly') {
                                return Text('months', style: TextStyle(fontSize: 15));
                              } else if (model.item['repeat'] == 'yearly') {
                                return Text('years', style: TextStyle(fontSize: 15));
                              } else {
                                return Container();
                              }
                            })(),
                          ],
                        ),
                      ),
                      //* WEEKDAY CHECKBOXES
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: (() {
                          print(model.item['weekdays']);
                          if (model.item['repeat'] == 'weekly') {
                            List<LetterCheckbox> checkboxes = [];
                            model.item['weekdays'].asMap().forEach((index, valuex) {
                              bool value = valuex;
                              print('$index --- $value');
                              checkboxes.add(
                                LetterCheckbox(
                                  text: ['M','T','W','T','F','S','S'][index],
                                  value: value,
                                  onChanged: (bool newValue) {
                                    model.item['weekdays'][index] = newValue;
                                    print(';;;;;');
                                    print(model.item['weekdays']);
                                    model.rebuild();
                                  },
                                ),
                              );
                            });
                            return Wrap(
                              children: checkboxes,
                              // alignment: WrapAlignment.spaceBetween,
                              // spacing: 4,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            );
                          } else {
                            return Container();
                          }
                        })(),
                      )
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
                              highlightColor: themeModel.highlightColor,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                listModel.delete(model.item['id']);
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete', style: themeModel.buttonTextStyle),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        else
                          return Container();
                      })(),
                      //* CANCEL
                      MaterialButton(
                        highlightColor: themeModel.highlightColor,
                        splashColor: Colors.transparent,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel', style: themeModel.buttonTextStyle),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Container(width: 12),
                      //* SAVE
                      MaterialButton(
                        splashColor: Colors.transparent,
                        elevation: 0,
                        textColor: !themeModel.darkMode && !saveDisabled() ? Colors.white : null,
                        onPressed: () {
                          titleHasChanged = true;
                          if (formKey.currentState.validate() &&
                              !saveDisabled() &&
                              titleHasChanged) {
                            Navigator.of(context).pop();
                            formKey.currentState.save();
                            if (mode == 'new') {
                              listModel.add(model.item);
                            } else if (mode == 'edit') {
                              listModel.update(id: model.item['id'], notificationItem: model.item);
                            }
                          }
                        },
                        color: saveDisabled()
                            ? themeModel.primaryButtonDisabledColor
                            : themeModel.primaryButtonColor,
                        highlightColor:
                            saveDisabled() ? Colors.transparent : themeModel.highlightColor,
                        highlightElevation: saveDisabled() ? 0 : 8,
                        child: Text('Save', style: themeModel.buttonTextStyle),
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
