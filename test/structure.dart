import 'package:ical/src/parser.dart';
import 'package:ical/src/structure.dart';
import 'package:test/test.dart';

main() {
  group('Structure', () {
    ICalParser parser;
    setUp(() {
      parser = ICalParser();
    });

    test('parse example ICalStructure', () {
      const testIcs = """BEGIN:VCALENDAR
VERSION:2.0
CALSCALE:GREGORIAN
BEGIN:VEVENT
SUMMARY:Access-A-Ride Pickup
DTSTART;TZID=America/New_York:20130802T103400
DTEND;TZID=America/New_York:20130802T110400
LOCATION:1000 Broadway Ave.\, Brooklyn
DESCRIPTION: Access-A-Ride trip to 900 Jay St.\, Brooklyn
STATUS:CONFIRMED
SEQUENCE:3
BEGIN:VALARM
TRIGGER:-PT10M
DESCRIPTION:Pickup Reminder
ACTION:DISPLAY
END:VALARM
END:VEVENT
BEGIN:VEVENT
SUMMARY:Access-A-Ride Pickup
DTSTART;TZID=America/New_York:20130802T200000
DTEND;TZID=America/New_York:20130802T203000
LOCATION:900 Jay St.\, Brooklyn
DESCRIPTION: Access-A-Ride trip to 1000 Broadway Ave.\, Brooklyn
STATUS:CONFIRMED
SEQUENCE:3
BEGIN:VALARM
TRIGGER:-PT10M
DESCRIPTION:Pickup Reminder
ACTION:DISPLAY
END:VALARM
END:VEVENT
END:VCALENDAR""";
      final result = parser.parseText(testIcs);
      final structure = ICalStructure.fromRows(result);
      expect(structure.type, "VCALENDAR");
      expect(structure.children.length, 2);
      expect(structure["VERSION"]?.value, "2.0");
    });
  });
}
