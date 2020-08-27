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

    test('parse folded row', () {
      const foldedRow = """TEST:testtesttesttesttesttest
 testtest""";
      final row = parser.parseText(foldedRow).firstWhere((element) => element.key == "TEST");
      expect(row?.value, "testtesttesttesttesttesttesttest");
    });
  });
}
