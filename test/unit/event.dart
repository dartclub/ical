import 'package:test/test.dart';
import '../../lib/src/event.dart';
import '../../lib/src/subcomponents.dart';
import '../../lib/src/abstract.dart';

main(){
  group('Event', (){
    test('serialize', (){
      IEvent e = IEvent(
        uid: 'lukas@himsel.me',
        alarm: IAlarm.display(description: 'Test test test', trigger: DateTime.now()),
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 3)),
        description: 'Test test test',
        lat: 49.3,
        lng: 13,
        categories: <String>['Test', 'unit', 'bla'],
        rrule: IRecurrenceRule(frequency: IRecurrenceFrequency.YEARLY),
      );
      print(e.serialize());
    });
    // TODO create tests
  });
}