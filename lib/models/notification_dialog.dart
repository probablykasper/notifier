import 'package:scoped_model/scoped_model.dart';

class NotificationDialogModel extends Model {
  Map<String, Object> item = {
    'title': '',
    'description': '',
    'repeat': 'never',
    'repeatEvery': 1,
    'noSwipeAway': false,
    'date': DateTime.now().millisecondsSinceEpoch,
  };
  Map<String, Object> initialItem;

  NotificationDialogModel({this.initialItem}) {
    if (initialItem != null) item = initialItem;
  }

  rebuild() {
    notifyListeners();
  }
}
