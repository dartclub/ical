import 'package:ical/serializer.dart';
import 'package:ical/src/abstract.dart';
import 'package:ical/src/properties.dart';
import 'package:ical/src/utils.dart' as utils;

enum ITodoStatus {
  NEEDS_ACTION,
  COMPLETED,
  IN_PROCESS,
  CANCELLED,
}
final List<PropertyFactory> _factories = [
  // TODO factories
];

class ITodo extends ICalendarElement with EventToDo {
  ITodoStatus status;
  DateTime completed;
  DateTime due;
  DateTime start;
  Duration duration;

  String location;
  double lat;
  double lng;
  List<String> resources;
  IAlarm alarm;
  int priority;

  int _complete;
  set complete(int c) {
    assert(c >= 0 && c <= 100);
    _complete = c;
  }

  get complete => _complete;

  ITodo({
    IOrganizer organizer,
    String uid,
    this.status,
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
    String summary,
    String description,
    List<String> categories,
    String url,
    IClass classification,
    String comment,
    IRecurrenceRule rrule,
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
        ) {
    complete = percentComplete;
  }

  @override
  String serialize() {
    var out = StringBuffer()
      ..writeln('BEGIN:VTODO')
      ..writeln('DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}')
      ..writeln('DTSTART;VALUE=DATE:${utils.formatDate(start)}');

    if (due != null) out.writeln('DUE;VALUE=DATE:${utils.formatDate(due)}');
    if (duration != null) {
      out.writeln('DURATION:${utils.formatDuration(duration)}');
    }

    switch (status) {
      case ITodoStatus.CANCELLED:
        out.writeln('STATUS:CANCELLED');
        break;
      case ITodoStatus.COMPLETED:
        out.writeln('STATUS:COMPLETED');
        break;
      case ITodoStatus.IN_PROCESS:
        out.writeln('STATUS:IN-PROCESS');
        break;
      case ITodoStatus.NEEDS_ACTION:
        out.writeln('STATUS:NEEDS-ACTION');
        break;
      default:
        out.writeln('STATUS:NEEDS-ACTION');
        break;
    }

    if (complete != null) out.writeln('PERCENT-COMPLETE:$_complete');

    out.write(super.serialize());
    out.write(serializeEventToDo());
    out.writeln('END:VTODO');
    return out.toString();
  }
}
