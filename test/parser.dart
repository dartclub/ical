import 'package:ical/src/calendar.dart';
import 'package:ical/src/parser.dart';
import 'package:test/test.dart';

main() {
  group('Parser', () {
    ICalParser parser;
    setUp(() {
      parser = ICalParser();
    });
    test('parse single row', () {
      const withMiddle = "DTSTART;VALUE=DATE:20200908";
      const withoutMiddle = "CREATED:20200827T080438Z";

      var result = parser.parseText(withMiddle);
      var row = result.firstWhere((element) => element.key == "DTSTART");
      expect(row?.value, "20200908");
      expect(row?.properties["VALUE"], "DATE");

      result = parser.parseText(withoutMiddle);
      row = result.firstWhere((element) => element.key == "CREATED");
      expect(row?.value, "20200827T080438Z");
      expect(row?.properties?.length, 0);
    });

    test('parse multiple rows', () {
      const testIcs = """CREATED:20200827T080438Z
DTSTAMP:20200827T080438Z
LAST-MODIFIED:20200827T080438Z
DTSTART;VALUE=DATE:20200907
DTEND;VALUE=DATE:20200908""";
      final result = parser.parseText(testIcs);
      expect(result.length, 5);
      expect(result.map((e) => e.key), ["CREATED", "DTSTAMP", "LAST-MODIFIED", "DTSTART", "DTEND"]);
    });

    test('parse calendar', () {
      const foldedRow = """TEST:testtesttesttesttesttest
 testtest""";
      final row = parser.parseText(foldedRow).firstWhere((element) => element.key == "TEST");
      expect(row?.value, "testtesttesttesttesttesttesttest");
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
      final result = parser.parseCalender(testIcs);
      expect(result.events.length, 2);
    });
  });
}
