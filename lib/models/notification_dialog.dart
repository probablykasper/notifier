import 'package:scoped_model/scoped_model.dart';

class NotificationDialogModel extends Model {
  Map<String, Object> item = {
    'title': '',
    'description': '',
    'noSwipeAway': false,
  };
  Map<String, Object> initialItem;

  NotificationDialogModel({this.initialItem}) {
    if (initialItem != null) item = initialItem;
  }

  rebuild() {
    notifyListeners();
  }
}
