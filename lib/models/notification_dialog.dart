import 'package:scoped_model/scoped_model.dart';

class NotificationDialogModel extends Model {
  Map<String, dynamic> item = {
    'title': '',
    'description': '',
    'repeat': 'never',
    'repeatEvery': 1,
    'weekdays': [false,false,false,false,false,false,false],
    'noSwipeAway': false,
    'date': DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
    'nextDate': DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
  };
  Map<String, Object> initialItem;

  NotificationDialogModel({this.initialItem}) {
    if (initialItem != null) item = initialItem;
  }

  rebuild() {
    notifyListeners();
  }
}
