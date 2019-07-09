import 'package:scoped_model/scoped_model.dart';

class NotificationDialogModel extends Model {
  Map<String, dynamic> item;

  static Map<String, dynamic> defaultItem() {
    DateTime now = DateTime.now();
    DateTime defaultDate = DateTime(now.year, now.month, now.day, now.hour+2);

    List<bool> weekdays = [false, false, false, false, false, false, false];
    weekdays[defaultDate.weekday-1] = true;

    return {
      'title': '',
      'description': '',
      'repeat': 'never',
      'repeatEvery': 1,
      'weekdays': weekdays,
      'noSwipeAway': false,
      'date': defaultDate.millisecondsSinceEpoch,
      'firedCount': 0, // actual times notification has fired can be 1 higher
      'status': 'enabled',
      'willDisable': false, // if the notification will be disabled after it fires next time
    };
  }

  NotificationDialogModel({Map<String, Object> initialItem}) {
    item = initialItem;
  }

  rebuild() {
    notifyListeners();
  }
}
