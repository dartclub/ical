// ignore_for_file: constant_identifier_names, annotate_overrides, overridden_fields

import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

class IEvent extends ICalendarElement with EventToDo {
  IEventStatus status;
  DateTime start;
  DateTime? end;
  Duration? duration;
  ITimeTransparency? transparency = ITimeTransparency.OPAQUE;

  String? location;
  double? lat, lng;
  List<String>? resources;
  IAlarm? alarm;
  IOrganizer? organizer;
  int? priority;

  IEvent({
    IOrganizer? organizer,
    String? uid,
    this.status = IEventStatus.CONFIRMED,
    required this.start,
    this.end,
    this.duration,
    String? summary,
    String? description,
    List<String>? categories,
    String? url,
    IClass classification = IClass.PRIVATE,
    String? comment,
    IRecurrenceRule? rrule,
    this.transparency,
    this.location,
    this.lat,
    this.lng,
    this.resources,
    this.alarm,
    this.priority = 0,
  }) : super(
          organizer: organizer,
          uid: uid,
          summary: summary,
          description: description,
          categories: categories,
          url: url,
          classification: classification,
          comment: comment,
          rrule: rrule,
        );

  @override
  String serialize() {
    super.serialize();
    var out = StringBuffer()
      ..writecrlf('BEGIN:VEVENT')
      ..writecrlf('DTSTAMP:${utils.formatDateTime(start)}');

    if ((end == null && duration == null)) {
      out.writecrlf('DTSTART;VALUE=DATE:${utils.formatDate(start)}');
    } else {
      out.writecrlf('DTSTART:${utils.formatDateTime(start)}');
    }

    if (end != null) {
      out.writecrlf('DTEND:${utils.formatDateTime(end!)}');
    }
    if (duration != null) {
      out.writecrlf('DURATION:${utils.formatDuration(duration!)}');
    }
    if (transparency != null) {
      out.writecrlf('TRANSP:$transparency');
    }

    out
      ..writecrlf('STATUS:$status')
      ..write(super.serialize())
      ..write(serializeEventToDo())
      ..writecrlf('END:VEVENT');
    return out.toString();
  }
}

class IEventStatus {
  final String _label;
  @override
  toString() => _label;

  const IEventStatus._(this._label);
  static const TENTATIVE = IEventStatus._('TENTATIVE');
  static const CONFIRMED = IEventStatus._('CONFIRMED');
  static const CANCELLED = IEventStatus._('CANCELLED');
}

class ITimeTransparency {
  final String _label;
  @override
  toString() => _label;
  const ITimeTransparency._(this._label);
  static const OPAQUE = ITimeTransparency._('OPAQUE');
  static const TRANSPARENT = ITimeTransparency._('TRANSPARENT');
}
