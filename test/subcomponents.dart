import 'package:ical/src/subcomponents.dart';
import 'package:test/test.dart';

main() {
  group('Alarm', () {
    group('Alarm.display', () {
      late IAlarm disp;
      setUp(() {
        disp = IAlarm.display(
          duration: Duration(minutes: 23),
          description: 'Test',
          repeat: 3,
          trigger: DateTime.now().add(Duration(hours: 3)),
        );
        test('duration', () {
          expect(disp.duration, Duration(minutes: 23));
        });
      });

      test('serialize', () {
        List<String> out = disp.serialize().trim().split('\n');
        print(out.join('\n'));
        expect(out[0], 'BEGIN:VALARM');
        expect(out[out.length - 1], 'END:VALARM');
        expect(out.length, 7);
      });
    });
    /* TODO group('Alarm.audio', () {
      Alarm audio = Alarm.audio(
        trigger: DateTime.now().add(Duration(hours: 3)),
        repeat: 5,
        duration: Duration(minutes: 80),
      );
    });
*/
    // TODO group('Alarm.email', () {});
  });
}
