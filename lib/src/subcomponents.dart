import 'abstract.dart';
import 'utils.dart' as utils;

enum IAlarmType { DISPLAY, AUDIO, EMAIL }

class IAlarm extends AbstractSerializer {
  IAlarmType type;
  Duration duration;
  int repeat;
  DateTime trigger;
  String description, summary;

  IAlarm.display({
    this.duration = const Duration(minutes: 15),
    this.repeat = 1,
    this.trigger,
    this.description,
  }) : type = IAlarmType.DISPLAY;
  IAlarm.audio({
    this.duration = const Duration(minutes: 15),
    this.repeat = 1,
    this.trigger,
  }) : type = IAlarmType.AUDIO;

  // TODO IAlarm.email(
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
      case IAlarmType.AUDIO:
        out += 'ACTION:AUDIO\n';
        break;
      case IAlarmType.DISPLAY:
        out += 'ACTION:DISPLAY\n';
        out += _serializeDescription();
        break;
      case IAlarmType.EMAIL:
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
