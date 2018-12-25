import 'abstract.dart';
import 'utils.dart' as utils;

enum AlarmType { DISPLAY, AUDIO, EMAIL }

class Alarm extends AbstractSerializer {
  AlarmType type;
  Duration duration;
  int repeat;
  DateTime trigger;
  String description, summary;

  Alarm.display({
    this.duration = const Duration(minutes: 15),
    this.repeat = 1,
    this.trigger,
    this.description,
  }) : type = AlarmType.DISPLAY;
  Alarm.audio({
    this.duration = const Duration(minutes: 15),
    this.repeat = 1,
    this.trigger,
  }) : type = AlarmType.AUDIO;

  // TODO Alarm.email(
  //    {this.duration,
  //    this.repeat,
  //    this.trigger,
  //    this.description,
  //    this.summary})
  //s    : type = AlarmType.EMAIL;

  String _serializeSummary() => 'SUMMARY:$summary\n';
  String _serializeDescription() {
    String out = description.replaceAll('\n', "\\n\n\t");
    return 'DESCRIPTION:${out}\n';
  }

  @override
  String serialize() {
    String out = 'BEGIN:VALARM\n';
    switch (type) {
      case AlarmType.AUDIO:
        out += 'ACTION:AUDIO\n';
        break;
      case AlarmType.DISPLAY:
        out += 'ACTION:DISPLAY\n';
        out += _serializeDescription();
        break;
      case AlarmType.EMAIL:
        out += 'ACTION:EMAIL\n';
        out += _serializeDescription();
        out += _serializeSummary();

        // TODO ATTENDEE
        break;
    }

    if (repeat > 1) {
      out += 'REPEAT:$repeat\n';
      out += 'DURATION:${utils.formatDuration(duration)}\n';
    }

    assert(trigger != null);
    out += 'TRIGGER;VALUE=DATE-TIME:${utils.formatDateTime(trigger)}\n';

    out += 'END:VALARM\n';
    return out;
  }
}
