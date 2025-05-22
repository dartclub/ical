// ignore_for_file: constant_identifier_names

import 'package:ical/src/utils.dart';
import 'package:meta/meta.dart';

import 'abstract.dart';
import 'utils.dart' as utils;

@immutable
final class IAlarmType {
  static const DISPLAY = IAlarmType._('DISPLAY');
  static const AUDIO = IAlarmType._('AUDIO');
  static const EMAIL = IAlarmType._('EMAIL');

  final String _label;

  const IAlarmType._(this._label);

  @override
  String toString() => _label;
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
    var out = StringBuffer()
      ..writecrlf('BEGIN:VALARM')
      ..writecrlf('ACTION:$type');
    switch (type) {
      case IAlarmType.DISPLAY:
        out.writecrlf(_serializeDescription());
        break;
      case IAlarmType.EMAIL:
        out.writecrlf(_serializeDescription());
        out.writecrlf('SUMMARY:${escapeValue(summary!)}');

        // TODO ATTENDEE
        break;
      case IAlarmType.AUDIO:
        // TODO: Handle this case.
        break;
    }

    if (repeat > 1) {
      out.writecrlf('REPEAT:$repeat');
      out.writecrlf('DURATION:${utils.formatDuration(duration)}');
    }

    if (trigger != null) {
      out.writecrlf(
          'TRIGGER;VALUE=DATE-TIME:${utils.formatDateTime(trigger!)}');
    }

    out.writecrlf('END:VALARM');
    return out.toString();
  }
}
