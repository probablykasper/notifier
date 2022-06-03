import 'package:test/test.dart' show expect, group, test;
import 'package:notifier/notification_item.dart' show NotificationItem, Repeat;

main() {
  group('Weekly schedule', () {
    test('Normal', () {
      var item = NotificationItem.defaultWith(
        originalDate: DateTime(2018, 1, 1),
        lastScheduledDate: DateTime(2018, 1, 1),
        repeat: Repeat.weekly,
        repeatEvery: 1,
        weekdays: [true, false, false, false, false, false, false],
      );
      expect(item.testGetDirectlyNextDate(), DateTime(2018, 1, 8));
    });
    test('No weekdays checked', () {
      var item = NotificationItem.defaultWith(
        originalDate: DateTime(2018, 1, 1),
        lastScheduledDate: DateTime(2018, 1, 1),
        repeat: Repeat.weekly,
        repeatEvery: 1,
        weekdays: [false, false, false, false, false, false, false],
      );
      expect(item.testGetDirectlyNextDate(), DateTime(2018, 1, 8));
    });
    test('Next day', () {
      var item = NotificationItem.defaultWith(
        originalDate: DateTime(2018, 1, 1),
        lastScheduledDate: DateTime(2018, 1, 1),
        repeat: Repeat.weekly,
        repeatEvery: 1,
        weekdays: [true, true, true, true, true, true, true],
      );
      expect(item.testGetDirectlyNextDate(), DateTime(2018, 1, 2));
    });
    test('Later in same week', () {
      var item = NotificationItem.defaultWith(
        originalDate: DateTime(2018, 1, 1),
        lastScheduledDate: DateTime(2018, 1, 1),
        repeat: Repeat.weekly,
        repeatEvery: 1,
        weekdays: [true, false, false, false, false, false, true],
      );
      expect(item.testGetDirectlyNextDate(), DateTime(2018, 1, 7));
    });
    test('Bi-weekly', () {
      var item = NotificationItem.defaultWith(
        originalDate: DateTime(2018, 1, 1),
        lastScheduledDate: DateTime(2018, 1, 1),
        repeat: Repeat.weekly,
        repeatEvery: 2,
        weekdays: [true, false, false, false, false, false, false],
      );
      expect(item.testGetDirectlyNextDate(), DateTime(2018, 1, 1 + 7 * 2));
    });
    test('Bi-weekly from friday to thursday', () {
      var item = NotificationItem.defaultWith(
        originalDate: DateTime(2018, 1, 5),
        lastScheduledDate: DateTime(2018, 1, 5),
        repeat: Repeat.weekly,
        repeatEvery: 2,
        weekdays: [false, false, false, true, true, false, false],
      );
      expect(item.testGetDirectlyNextDate(), DateTime(2018, 1, 5 + 7 + 6));
    });
  });
}
