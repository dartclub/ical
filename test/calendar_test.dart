import 'package:ical/src/calendar.dart';
import 'package:test/test.dart';

void main() {
  group('Calendar', () {
    late ICalendar iCalendar;
    setUp(() {
      iCalendar = ICalendar(
        company: 'Umbrella Inc.',
        lang: 'EN',
        product: 'Zombies',
        refreshInterval: const Duration(minutes: 30),
      );
    });
    test('serialize', () {
      print(iCalendar.serialize());
    });
  });
}
