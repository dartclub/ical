import 'package:test/test.dart';
import 'package:ical/src/event.dart';
import 'package:ical/src/subcomponents.dart';
import 'package:ical/src/abstract.dart';

class _AttributesHelper {
  static final String alarm = 'ALARM';
  static final String categories = 'CATEGORIES';
  static final String classification = 'CLASSIFICATION';
  static final String comment = 'COMMENT';
  static final String description = 'DESCRIPTION';
  static final String duration = 'DURATION';
  static final String end = 'END';
  static final String lat = 'LAT';
  static final String lng = 'LNG';
  static final String location = 'LOCATION';
  static final String organizer = 'ORGANIZER';
  static final String priority = 'PRIORITY';
  static final String resources = 'RESOURCES';
  static final String rrule = 'RRULE';
  static final String start = 'START';
  static final String status = 'STATUS';
  static final String summary = 'SUMMARY';
  static final String transparency = 'TRANSPARENCY';
  static final String uid = 'UID';
  static final String url = 'URL';
  static final List<String> all = [
    alarm,
    categories,
    classification,
    comment,
    description,
    duration,
    end,
    lat,
    lng,
    location,
    organizer,
    priority,
    resources,
    rrule,
    start,
    status,
    summary,
    transparency,
    uid,
    url,
  ];
  static contains(List<String> attributes, String serialized) {
    var lines = serialized.split('\n');
    for (var attr in attributes) {
      expect(lines.contains(attr), true, reason: 'contains $attr');
    }
  }
}

main() {
  group('Event', () {
    IEvent e, e2;
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
          classification: IClass.PUBLIC,
          comment: 'Hello World',
          duration: Duration(hours: 5),
          location: '',
          organizer: IOrganizer(email: 'lukas@himsel.me', name: 'Lukas Himsel'),
          priority: 1,
          resources: ['Hello'],
          summary: '',
          url: 'https://github.com/dartclub/ical');
    });

    test('serialize', () {
      print(e.serialize());
      _AttributesHelper.contains(_AttributesHelper.all, e.serialize());
    });
    // TODO create tests
  });
}
