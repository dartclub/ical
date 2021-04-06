import 'package:ical/src/calendar.dart';
import 'package:test/test.dart';

main() {
  group('Calendar', () {
    late ICalendar iCalendar;
    setUp(() {
      iCalendar = ICalendar(
        company: 'Umbrella Inc.',
        lang: 'EN',
        product: 'Zombies',
        refreshInterval: Duration(minutes: 30),
      );
    });
    test('serialize', () {
      print(iCalendar.serialize());
    });
  });
}
