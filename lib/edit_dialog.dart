import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' show Get, GetNavigation;
import 'package:flutter/material.dart'
    show
        Colors,
        Column,
        Container,
        DropdownButton,
        DropdownMenuItem,
        EdgeInsets,
        InputDecoration,
        MaterialButton,
        MaterialTapTargetSize,
        Row,
        SimpleDialog,
        Text,
        TextFormField,
        Theme,
        Widget;
import 'package:notifier/notification_items.dart' show NotificationItem, Repeat;
import 'package:notifier/theme.dart';

class EditDialog extends StatefulWidget {
  final NotificationItem item;
  final bool editMode;
  final void Function(NotificationItem item) onSave;

  EditDialog({
    required this.item,
    required this.editMode,
    required this.onSave,
  });

  @override
  EditDialogState createState() {
    return EditDialogState();
  }
}

class EditDialogState extends State<EditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    return Form(
      key: formKey,
      child: SimpleDialog(
        // everything should have a horizontal padding of 24
        contentPadding: const EdgeInsets.all(0),
        title: widget.editMode
            ? const Text('Edit notification')
            : const Text('Add notification'),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 0),
            width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //* TITLE
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 8),
                  child: TextFormField(
                    initialValue: widget.item.title,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == '') return 'Write something, bro';
                      return null;
                    },
                    onChanged: (String newValue) {
                      widget.item.title = newValue;
                    },
                  ),
                ),
                //* DESCRIPTION
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 8),
                  child: TextFormField(
                    initialValue: widget.item.description,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (String newValue) {
                      widget.item.description = newValue;
                    },
                  ),
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
                // ListTile(
                //   contentPadding: EdgeInsets.symmetric(horizontal: 24),
                //   leading: Icon(Icons.calendar_today),
                //   title: Text('Time',
                //       style: TextStyle(color: themeModel.textColor)),
                //   isThreeLine: timeHasPassed(),
                //   // subtitle: Text(
                //   //   DateFormat("MMMM d, y 'at' h:mm a").format(
                //   //     DateTime.fromMillisecondsSinceEpoch(model.item['date']),
                //   //   ),
                //   // ),
                //   subtitle: RichText(
                //     text: TextSpan(
                //       children: [
                //         TextSpan(
                //           text: DateFormat("MMMM d, y 'at' h:mm a").format(
                //             DateTime.fromMillisecondsSinceEpoch(
                //                 model.item['date']),
                //           ),
                //           style: TextStyle(
                //               color: themeModel.textColor, fontFamily: 'Jost'),
                //         ),
                //         TextSpan(
                //           text: !timeHasPassed() ? '' : '\nTime has passed',
                //           style: TextStyle(
                //               color: themeModel.errorText, fontFamily: 'Jost'),
                //         ),
                //       ],
                //     ),
                //   ),
                //   onTap: () async {
                //     descriptionFocusNode.unfocus();
                //     print('[notifier] Selecting date');
                //     await _pickDateTime(context, model);
                //     final notificationItemModel =
                //         ScopedModel.of<NotificationDialogModel>(context);
                //     notificationItemModel.rebuild();
                //   },
                // ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: <Widget>[
                      //* REPEAT
                      FormField(
                        initialValue: widget.item.repeat,
                        onSaved: (newValue) {
                          // model.item['repeat'] = newValue;
                        },
                        builder: (FormFieldState state) {
                          return DropdownButton<Repeat>(
                            onChanged: (newValue) {
                              print(newValue);
                              if (newValue != null) {
                                setState(() {
                                  widget.item.repeat = newValue;
                                });
                              }
                            },
                            value: widget.item.repeat,
                            elevation: 16,
                            // style: TextStyle(
                            //   fontFamily: 'Jost',
                            //   color: themeModel.textColor,
                            //   fontSize: 15,
                            // ),
                            items: const [
                              DropdownMenuItem(
                                value: Repeat.never,
                                child: Text("Doesn't Repeat"),
                              ),
                              DropdownMenuItem(
                                value: Repeat.daily,
                                child: Text("Repeat Daily"),
                              ),
                              DropdownMenuItem(
                                value: Repeat.weekly,
                                child: Text("Repeat Weekly"),
                              ),
                              DropdownMenuItem(
                                value: Repeat.monthly,
                                child: Text("Repeat Monthly"),
                              ),
                              DropdownMenuItem(
                                value: Repeat.yearly,
                                child: Text("Repeat Yearly"),
                              ),
                            ],
                          );
                        },
                      ),
                      Container(width: 6),
                      // (() {
                      //   if (model.item['repeat'] == 'never') {
                      //     return Container();
                      //   } else {
                      //     return Text('every', style: TextStyle(fontSize: 15));
                      //   }
                      // })(),
                      //* REPEAT EVERY
                      Container(width: 6),
                      // (() {
                      //   if (model.item['repeat'] == 'never') {
                      //     return Container();
                      //   } else {
                      //     return Container(
                      //       width: 35,
                      //       child: TextFormField(
                      //         initialValue:
                      //             model.item['repeatEvery'].toString(),
                      //         onSaved: (String newValue) {
                      //           if (newValue == '')
                      //             model.item['repeatEvery'] = 1;
                      //           else
                      //             model.item['repeatEvery'] =
                      //                 int.parse(newValue);
                      //         },
                      //         textAlign: TextAlign.center,
                      //         keyboardType: TextInputType.numberWithOptions(
                      //           signed: false,
                      //           decimal: false,
                      //         ),
                      //         inputFormatters: [
                      //           BlacklistingTextInputFormatter(RegExp('^0\$')),
                      //           WhitelistingTextInputFormatter.digitsOnly,
                      //           LengthLimitingTextInputFormatter(3),
                      //         ],
                      //         decoration: InputDecoration(
                      //           hintText: '1',
                      //           contentPadding:
                      //               EdgeInsets.symmetric(vertical: 4),
                      //         ),
                      //       ),
                      //     );
                      //   }
                      // })(),
                      Container(width: 6),
                      // (() {
                      //   if (model.item['repeat'] == 'daily') {
                      //     return Text('days', style: TextStyle(fontSize: 15));
                      //   } else if (model.item['repeat'] == 'weekly') {
                      //     return Text('weeks', style: TextStyle(fontSize: 15));
                      //   } else if (model.item['repeat'] == 'monthly') {
                      //     return Text('months', style: TextStyle(fontSize: 15));
                      //   } else if (model.item['repeat'] == 'yearly') {
                      //     return Text('years', style: TextStyle(fontSize: 15));
                      //   } else {
                      //     return Container();
                      //   }
                      // })(),
                    ],
                  ),
                ),
                //* WEEKDAY CHECKBOXES
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 24),
                //   child: (() {
                //     if (model.item['repeat'] == 'weekly') {
                //       List<LetterCheckbox> checkboxes = [];
                //       model.item['weekdays'].asMap().forEach((index, valuex) {
                //         bool value = valuex;
                //         checkboxes.add(
                //           LetterCheckbox(
                //             text: 'MTWTFSS'[index],
                //             value: value,
                //             onChanged: (bool newValue) {
                //               model.item['weekdays'][index] = newValue;
                //               print('[notifier] Updated selected weekdays: ' +
                //                   model.item['weekdays'].toString());
                //               model.rebuild();
                //             },
                //           ),
                //         );
                //       });
                //       return Wrap(children: checkboxes);
                //     } else {
                //       return Container();
                //     }
                //   })(),
                // )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //* DELETE
                // (() {
                //   if (mode == 'edit')
                //     return Padding(
                //       padding: EdgeInsets.only(right: 12),
                //       child: MaterialButton(
                //         highlightColor: themeModel.highlightColor,
                //         splashColor: Colors.transparent,
                //         onPressed: () {
                //           listModel.delete(model.item['id']);
                //           Navigator.of(context).pop();
                //         },
                //         child:
                //             Text('Delete', style: themeModel.buttonTextStyle),
                //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //       ),
                //     );
                //   else
                //     return Container();
                // })(),
                //* CANCEL
                MaterialButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Get.back();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: const Text('Cancel'),
                ),
                Container(width: 12),
                //* SAVE
                MaterialButton(
                  splashColor: Colors.transparent,
                  elevation: 0,
                  // textColor: !themeModel.darkMode && !saveDisabled()
                  //     ? Colors.white
                  //     : null,
                  onPressed: () {
                    //   titleHasChanged = true;
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      widget.onSave(widget.item);
                      Get.back();
                    }
                  },
                  color: Theme.of(context).custom.primaryButtonColor,
                  disabledColor:
                      Theme.of(context).custom.primaryButtonDisabledColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
