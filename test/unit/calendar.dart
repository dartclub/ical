import 'package:ical_serializer/src/calendar.dart';
import 'package:test/test.dart';
import '../../lib/src/event.dart';
import '../../lib/src/subcomponents.dart';
import '../../lib/src/abstract.dart';

main() {
  group('Calendar', () {
    ICalendar iCalendar;
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
