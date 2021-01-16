import 'package:ical/src/structure.dart';

import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

class IEvent extends ICalendarElement with EventToDo {
  IEventStatus status = IEventStatus.CONFIRMED;
  DateTime start;
  DateTime end;
  Duration duration;
  ITimeTransparency transparency = ITimeTransparency.OPAQUE;

  String location;
  double lat, lng;
  List<String> resources;
  IAlarm alarm;
  IOrganizer organizer;
  int priority;

  IEvent({
    IOrganizer organizer,
    String uid,
    this.status,
    this.start,
    this.end,
    this.duration,
    String summary,
    String description,
    List<String> categories,
    String url,
    IClass classification = IClass.PRIVATE,
    String comment,
    IRecurrenceRule rrule,
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
      ..writeln('BEGIN:VEVENT')
      ..writeln('DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}');

    if ((end == null && duration == null)) {
      out.writeln('DTSTART;VALUE=DATE:${utils.formatDate(start)}');
    } else {
      out.writeln('DTSTART:${utils.formatDateTime(start)}');
    }

    if (end != null) {
      out.writeln('DTEND:${utils.formatDateTime(end)}');
    }
    if (duration != null) {
      out.writeln('DURATION:${utils.formatDuration(duration)}');
    }
    if (transparency != null) {
      out.writeln('TRANSP:$transparency');
    }

    out
      ..writeln('STATUS:$status')
      ..write(super.serialize())
      ..write(serializeEventToDo())
      ..writeln('END:VEVENT');
    return out.toString();
  }

  @override
  void deserialize(ICalStructure structure) {
    super.deserialize(structure);
    start = _parseDate(structure["DTSTART"]);
    end = _parseDate(structure["DTEND"]);
    // TODO support duration
    transparency = structure["TRANSP"] != null
      ? ITimeTransparency._(structure["TRANSP"].value)
        : null;
    status = structure["STATUS"] != null
      ? IEventStatus._(structure["STATUS"].value)
        : null;
    // TODO support missing event to do;
  }

  DateTime _parseDate(ICalRow row) {
    if(row == null || row.value == null) return null;
    // TODO: add TZID support
    return DateTime.parse(row.value);
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
