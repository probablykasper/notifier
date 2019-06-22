import 'package:scoped_model/scoped_model.dart';

class NotificationDialogModel extends Model {
  Map<String, dynamic> item;

  static Map<String, dynamic> defaultItem() {
    List<bool> weekdays = [false, false, false, false, false, false, false];
    weekdays[DateTime.now().weekday-1] = true;
    return {
      'title': '',
      'description': '',
      'repeat': 'never',
      'repeatEvery': 1,
      'weekdays': weekdays,
      'noSwipeAway': false,
      'date': DateTime.now().millisecondsSinceEpoch,
      'nextDate': DateTime.now().millisecondsSinceEpoch,
    };
  }

  NotificationDialogModel({Map<String, Object> initialItem}) {
    item = initialItem;
  }

  rebuild() {
    notifyListeners();
  }
}
