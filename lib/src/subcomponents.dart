import 'package:ical/src/utils.dart';

import 'abstract.dart';
import 'utils.dart' as utils;

class IAlarmType {
  final String _label;
  @override
  toString() => _label;

  const IAlarmType._(this._label);
  static const DISPLAY = IAlarmType._('DISPLAY');
  static const AUDIO = IAlarmType._('AUDIO');
  static const EMAIL = IAlarmType._('EMAIL');
}

class IAlarm extends AbstractSerializer {
  IAlarmType type;
  Duration duration;
  int repeat;
  DateTime? trigger;
  String? description, summary;

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

  String _serializeDescription() => 'DESCRIPTION:${escapeValue(description!)}';

  @override
  String serialize() {
    var out = StringBuffer()..writeln('BEGIN:VALARM')..writeln('ACTION:$type');
    switch (type) {
      case IAlarmType.DISPLAY:
        out.writeln(_serializeDescription());
        break;
      case IAlarmType.EMAIL:
        out.writeln(_serializeDescription());
        out.writeln('SUMMARY:${escapeValue(summary!)}');

        // TODO ATTENDEE
        break;
    }

    if (repeat > 1) {
      out.writeln('REPEAT:$repeat');
      out.writeln('DURATION:${utils.formatDuration(duration)}');
    }

    if (trigger != null) {
      out.writeln('TRIGGER;VALUE=DATE-TIME:${utils.formatDateTime(trigger!)}');
    }

    out.writeln('END:VALARM');
    return out.toString();
  }
}
