import 'package:test/test.dart';
import '../../lib/src/event.dart';
import '../../lib/src/subcomponents.dart';
import '../../lib/src/abstract.dart';

main(){
  group('Event', (){
    test('serialize', (){
      Event e = Event(
        uid: 'lukas@himsel.me',
        alarm: Alarm.display(description: 'Test test test', trigger: DateTime.now()),
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 3)),
        description: 'Test test test',
        lat: 49.3,
        lng: 13,
        categories: <String>['Test', 'unit', 'bla'],
        rrule: RecurrenceRule(frequency: RecurrenceFrequency.YEARLY),
      );
      print(e.serialize());
    });
    // TODO create tests
  });
}