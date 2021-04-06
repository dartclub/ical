import 'package:ical/src/abstract.dart';
import 'package:test/test.dart';

class ElementTest extends ICalendarElement {
  ElementTest({
    IOrganizer? organizer,
    String? uid,
    String? summary,
    String? description,
    List<String>? categories,
    String? url,
    IClass? classification,
    String? comment,
    IRecurrenceRule? rrule,
  }) : super(
          organizer: organizer,
          uid: uid,
          summary: summary,
          description: description,
          categories: categories,
          url: url,
          classification: classification,
          comment: comment,
          rrule: rrule,
        );
}

main() {
  late ElementTest t1, t2;
  group('test ElementTest', () {
    setUp(() {
      t1 = ElementTest();
      t2 = ElementTest(
          categories: ['1', '2', '3'],
          classification: IClass.CONFIDENTIAL,
          comment: 'foo',
          description: 'bar',
          organizer: IOrganizer(name: 'Lukas Himsel', email: 'lukas@himsel.me'),
          rrule: IRecurrenceRule(
            frequency: IRecurrenceFrequency.BYDAY,
            count: 3,
          ),
          summary: 'baz',
          uid: 'very unique key',
          url: 'https://github.com/lukas-h');
    });
    test('t1', () {
      var s1 = t1.serialize();
      print(s1);
      expect(s1.trimRight().split('\n').length, 1);
    });
    test('t2', () {
      var s2 = t2.serialize();
      print(s2);
      var rows = s2.trimRight().split('\n');
      expect(rows.length, 8);
      expect(rows[0], 'UID:very unique key');
      expect(rows[1], 'CATEGORIES:1,2,3');
      expect(rows[2], 'COMMENT:foo');
      expect(rows[3], 'SUMMARY:baz');
      expect(rows[4], 'URL:https://github.com/lukas-h');
      expect(rows[5], 'CLASS:CONFIDENTIAL');
      expect(rows[6], 'DESCRIPTION:bar');
      expect(rows[7], 'RRULE:FREQ=BYDAY;COUNT=3');
    });
  });
}
