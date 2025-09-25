import 'package:ical/serializer.dart';
import 'package:test/test.dart';

void main() {
  group('Alarm', () {
    group('Alarm.display', () {
      late IAlarm disp;
      setUp(() {
        disp = IAlarm.display(
          duration: const Duration(minutes: 23),
          description: 'Test',
          repeat: 3,
          trigger: DateTime.now().add(const Duration(hours: 3)),
        );
      });
      test('duration', () {
        expect(disp.duration, const Duration(minutes: 23));
      });
      test('serialize', () {
        final List<String> out = disp.serialize().trim().split(CRLF_LINE_DELIMITER);
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
