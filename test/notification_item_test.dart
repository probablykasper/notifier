import 'package:test/test.dart' show test, expect;
import 'package:notifier/notification_item.dart' show NotificationItem, Repeat;

main() {
  test('Weekly schedule next day', () {
    var item = NotificationItem.defaultWith(
      originalDate: DateTime(2018, 1, 1),
      lastScheduledDate: DateTime(2018, 1, 1),
      repeat: Repeat.weekly,
      repeatEvery: 1,
      weekdays: [true, true, true, true, true, true, true],
    );
    expect(item.testGetDirectlyNextDate(), DateTime(2018, 1, 2));
  });
}
