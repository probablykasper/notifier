import 'package:scoped_model/scoped_model.dart';

class NotificationDialogModel extends Model {
  static final Map<String, dynamic> defaultItem = {
    'title': '',
    'description': '',
    'repeat': 'never',
    'repeatEvery': 1,
    'weekdays': [false,false,false,false,false,false,false],
    'noSwipeAway': false,
    'date': DateTime.now().millisecondsSinceEpoch,
    'nextDate': DateTime.now().millisecondsSinceEpoch,
  };
  Map<String, dynamic> item = defaultItem;

  NotificationDialogModel({Map<String, Object> initialItem}) {
    item = initialItem;
  }

  rebuild() {
    notifyListeners();
  }
}
