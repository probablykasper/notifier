import 'package:flutter/services.dart'
    show FilteringTextInputFormatter, LengthLimitingTextInputFormatter;
import 'package:get/get.dart' show Get, GetNavigation;
import 'package:flutter/material.dart'
    show
        AutovalidateMode,
        BuildContext,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        DropdownButton,
        DropdownMenuItem,
        EdgeInsets,
        FocusManager,
        Form,
        FormState,
        GlobalKey,
        Icon,
        Icons,
        InputDecoration,
        ListTile,
        MainAxisAlignment,
        MaterialButton,
        MaterialTapTargetSize,
        Padding,
        RichText,
        Row,
        SimpleDialog,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextAlign,
        TextEditingController,
        TextField,
        TextFormField,
        TextInputAction,
        TextInputType,
        TextSpan,
        TextStyle,
        Theme,
        TimeOfDay,
        Widget,
        kMinInteractiveDimension,
        showDatePicker,
        showTimePicker;
import 'package:intl/intl.dart' show DateFormat;
import 'package:notifier/notification_item.dart' show NotificationItem, Repeat;
import 'package:notifier/theme.dart' show CustomTheme;

class EditDialog extends StatefulWidget {
  final NotificationItem item;
  final bool editMode;
  final void Function(NotificationItem item) onSave;
  final void Function()? onDelete;
  var repeatEveryController = TextEditingController(
    text: "1",
  );

  EditDialog({
    required this.item,
    required this.editMode,
    required this.onSave,
    this.onDelete,
  });

  @override
  EditDialogState createState() {
    return EditDialogState();
  }
}

class EditDialogState extends State<EditDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<DateTime?> pickDateTime(
      BuildContext context, DateTime initialDT) async {
    final firstDate = DateTime.now().subtract(const Duration(days: 1));
    if (initialDT.isBefore(firstDate)) {
      initialDT = firstDate;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDT,
      firstDate: firstDate,
      lastDate: DateTime(3000),
    );
    if (pickedDate == null) return null;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDT),
    );
    if (pickedTime == null) return null;

    final newDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    return newDate;
  }

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
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Time'),
                  isThreeLine: widget.item.timeHasPassed(),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: DateFormat("MMMM d, y 'at' h:mm a")
                              .format(widget.item.getLatestDate()),
                          style: TextStyle(
                            color: Theme.of(context).custom.textColor,
                            fontFamily: 'Jost',
                          ),
                        ),
                        TextSpan(
                          text: !widget.item.timeHasPassed()
                              ? ''
                              : '\nTime has passed',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontFamily: 'Jost',
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var newDate = await pickDateTime(
                        context, widget.item.getLatestDate());
                    if (newDate != null) {
                      setState(() {
                        widget.item.originalDate = newDate;
                      });
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  height: kMinInteractiveDimension,
                  child: Row(
                    children: <Widget>[
                      //* REPEAT
                      DropdownButton<String>(
                        itemHeight: kMinInteractiveDimension,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              widget.item.repeat = newValue;
                            });
                          }
                        },
                        value: widget.item.repeat,
                        elevation: 16,
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
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.item.repeat == Repeat.never ? '' : 'every',
                        style: const TextStyle(fontSize: 15),
                      ),
                      //* REPEAT EVERY
                      const SizedBox(width: 6),
                      (() {
                        if (widget.item.repeat == Repeat.never) {
                          return const SizedBox();
                        } else {
                          const removedTopPadding = 16.0;
                          return SizedBox(
                            width: 35,
                            height:
                                kMinInteractiveDimension - removedTopPadding,
                            child: TextField(
                              controller: widget.repeatEveryController,
                              onChanged: (newValue) {
                                setState(() {
                                  if (newValue == '') {
                                    widget.item.repeatEvery = 1;
                                  } else {
                                    widget.item.repeatEvery =
                                        int.parse(newValue);
                                  }
                                });
                              },
                              textAlign: TextAlign.center,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: false,
                                decimal: false,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp('^0\$')),
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: const InputDecoration(
                                isDense: false,
                                hintText: '1',
                                contentPadding:
                                    EdgeInsets.only(top: -removedTopPadding),
                              ),
                            ),
                          );
                        }
                      })(),
                      const SizedBox(width: 6),
                      Text(
                        (() {
                          switch (widget.item.repeat) {
                            case Repeat.daily:
                              return 'days';
                            case Repeat.weekly:
                              return 'weeks';
                            case Repeat.monthly:
                              return 'months';
                            case Repeat.yearly:
                              return 'years';
                            default:
                              return '';
                          }
                        })(),
                        style: const TextStyle(fontSize: 15),
                      ),
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
                //       return const SizedBox();
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
                if (widget.editMode)
                  MaterialButton(
                    splashColor: Colors.transparent,
                    onPressed: () {
                      if (widget.onDelete != null) {
                        widget.onDelete!();
                      }
                      Get.back();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: const Text('Delete'),
                  )
                else
                  const SizedBox(),
                SizedBox(width: widget.editMode ? 12 : 0),
                //* CANCEL
                MaterialButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Get.back();
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                //* SAVE
                MaterialButton(
                  splashColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {
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
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
