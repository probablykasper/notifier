import 'package:scoped_model/scoped_model.dart';

class NotificationDialogModel extends Model {
  Map<String, Object> item = {
    'title': '',
    'description': '',
    'noSwipeAway': false,
  };
  
  rebuild() {
    notifyListeners();
  }
}
