import 'package:ical/src/abstract.dart';
import 'package:ical/src/tokenizer.dart';
import 'package:ical/src/utils.dart' as utils;

enum IAlarmType { DISPLAY, AUDIO, EMAIL }

final List<PropertyFactory> _factories = [
  // TODO factories
];

class IAlarm extends IComponent {
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
  IAlarm.email({
    this.duration,
    this.repeat,
    this.trigger,
    this.description,
    this.summary,
  }) : type = IAlarmType.EMAIL;

  IAlarm.parseTokens(ITokens tokens)
      : super.parseTokens(tokens, 'VALARM', _factories);

  String _serializeDescription() =>
      'DESCRIPTION:${description.replaceAll('\n', "\\n\n\t")}';

  @override
  String serialize() {
    var out = StringBuffer()..writeln('BEGIN:VALARM');
    switch (type) {
      case IAlarmType.AUDIO:
        out.writeln('ACTION:AUDIO');
        break;
      case IAlarmType.DISPLAY:
        out.writeln('ACTION:DISPLAY');
        out.write(_serializeDescription());
        break;
      case IAlarmType.EMAIL:
        out.writeln('ACTION:EMAIL');
        out.writeln(_serializeDescription());
        out.writeln('SUMMARY:$summary');

        // TODO ATTENDEE
        break;
    }

    if (repeat > 1) {
      out.writeln('REPEAT:$repeat');
      out.writeln('DURATION:${utils.formatDuration(duration)}');
    }

    if (trigger != null) {
      out.writeln('TRIGGER;VALUE=DATE-TIME:${utils.formatDateTime(trigger)}');
    }

    out.writeln('END:VALARM');
    return out.toString();
  }
}
