import 'package:ical/src/utils.dart' as utils;
import 'package:test/test.dart';

main() {
  group('utils', () {
    test('formatDate', () {
      expect(utils.formatDate(DateTime(2000, 2, 1)), '20000201');
      expect(utils.formatDate(DateTime(1948, 12, 30)), '19481230');
    });
    test('formatDateTime', () {
      expect(
          utils.formatDateTime(DateTime(2000, 2, 1, 23, 1)), '20000201T230100');
      expect(utils.formatDateTime(DateTime(1948, 12, 30, 12, 45, 33)),
          '19481230T124533');
    });
    test('injectTimeZone', () {
      expect(utils.injectTimeZone(DateTime.utc(2000, 2, 1, 23, 1), null), '');
      expect(utils.injectTimeZone(DateTime(2000, 2, 1, 23, 1), null), '');
      expect(
          utils.injectTimeZone(
              DateTime(1948, 12, 30, 12, 45, 33), "Europe/Berlin"),
          ';TZID=/Europe/Berlin');
    });
    test('formatDateTime with UTC time', () {
      expect(utils.formatDateTime(DateTime.utc(2000, 2, 1, 23, 1)),
          '20000201T230100Z');
      expect(utils.formatDateTime(DateTime.utc(1948, 12, 30, 12, 45, 33)),
          '19481230T124533Z');
    });

    test('formatDuration', () {
      expect(
          utils.formatDuration(
              Duration(days: 30, hours: 20, minutes: 10, seconds: 59)),
          '+P30DT20H10M59S');
      expect(
          utils.formatDuration(
              Duration(days: 30, hours: 0, minutes: 10, seconds: 0)),
          '+P30DT0H10M0S');
    });
  });
}
