// ignore_for_file: constant_identifier_names, annotate_overrides, overridden_fields

import 'package:meta/meta.dart';

import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

@immutable
final class ITodoStatus {
  static const NEEDS_ACTION = ITodoStatus._('NEEDS_ACTION');
  static const COMPLETED = ITodoStatus._('COMPLETED');
  static const IN_PROCESS = ITodoStatus._('IN_PROCESS');
  static const CANCELLED = ITodoStatus._('CANCELLED');

  final String _label;

  const ITodoStatus._(this._label);

  @override
  String toString() => _label;
}

class ITodo extends ICalendarElement with EventToDo {
  ITodoStatus status;
  DateTime? completed;
  DateTime? due;
  DateTime? start;
  Duration? duration;

  String? location;
  double? lat;
  double? lng;
  List<String>? resources;
  IAlarm? alarm;
  int? priority;

  late int _complete;
  set complete(int c) {
    assert(c >= 0 && c <= 100);
    _complete = c;
  }

  int get complete => _complete;

  ITodo({
    super.organizer,
    super.uid,
    this.status = ITodoStatus.NEEDS_ACTION,
    this.start,
    this.due,
    this.duration,
    this.location,
    this.lat,
    this.lng,
    this.resources,
    this.alarm,
    int percentComplete = 0,
    this.priority = 0,
    super.summary,
    super.description,
    super.categories,
    super.url,
    IClass super.classification,
    super.comment,
    super.rrule,
  }) {
    complete = percentComplete;
  }

  @override
  String serialize() {
    var out = StringBuffer()
      ..writecrlf('BEGIN:VTODO')
      ..writecrlf('DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}')
      ..writecrlf('DTSTART;VALUE=DATE:${utils.formatDate(start!)}')
      ..writecrlf('STATUS:$status');

    if (due != null) {
      out.writecrlf('DUE;VALUE=DATE:${utils.formatDate(due!)}');
    }
    if (duration != null) {
      out.writecrlf('DURATION:${utils.formatDuration(duration!)}');
    }

    out.writecrlf('PERCENT-COMPLETE:$_complete');

    out.write(super.serialize());
    out.write(serializeEventToDo());
    out.writecrlf('END:VTODO');
    return out.toString();
  }
}
