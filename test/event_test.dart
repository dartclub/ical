import 'package:test/test.dart';
import 'package:ical/src/event.dart';
import 'package:ical/src/subcomponents.dart';
import 'package:ical/src/abstract.dart';

main() {
  group('Event', () {
    late IEvent e, e2;
    setUp(() {
      e = IEvent(
        uid: 'lukas@himsel.me',
        alarm: IAlarm.display(
          description: 'Test',
          duration: Duration(minutes: 15),
          repeat: 5,
          trigger: DateTime.now().add(Duration(hours: 3)),
        ),
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 3)),
        description: 'Test test test',
        lat: 49.3,
        lng: 13,
        categories: <String>['Test', 'unit', 'bla'],
        rrule: IRecurrenceRule(frequency: IRecurrenceFrequency.YEARLY),
        status: IEventStatus.CANCELLED,
        transparency: ITimeTransparency.TRANSPARENT,
      );
      e2 = IEvent(
        alarm: IAlarm.audio(
          duration: Duration(minutes: 15),
          repeat: 4,
          trigger: DateTime.now().add(Duration(minutes: 3)),
        ),
        comment: 'unit test',
        classification: IClass.PUBLIC,
        location: 'Am Wollhaus 1, 74072 Heilbronn',
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 3)),
        organizer: IOrganizer(name: 'Lukas Himsel', email: 'test@example.com'),
        uid: 'lukas@himsel.me',
        resources: <String>['foo', 'bar', 'baz'],
        rrule: IRecurrenceRule(
            frequency: IRecurrenceFrequency.MONTHLY,
            count: 4,
            interval: 0,
            weekday: 4),
        priority: 45,
        url: 'https://example.com',
      );
    });

    test('serialize', () {
      print(e.serialize());
      print(e2.serialize());
    });
    // TODO create tests
  });
}
