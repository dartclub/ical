import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

class ITodoStatus {
  final String _label;
  @override
  toString() => _label;

  const ITodoStatus._(this._label);
  static const NEEDS_ACTION = ITodoStatus._('NEEDS_ACTION');
  static const COMPLETED = ITodoStatus._('COMPLETED');
  static const IN_PROCESS = ITodoStatus._('IN_PROCESS');
  static const CANCELLED = ITodoStatus._('CANCELLED');
}

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
    String summary,
    String description,
    List<String> categories,
    String url,
    IClass classification = IClass.PRIVATE,
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
      ..writeln('DTSTART;VALUE=DATE:${utils.formatDate(start)}')
      ..writeln('STATUS:$status');

    if (due != null) out.writeln('DUE;VALUE=DATE:${utils.formatDate(due)}');
    if (duration != null) {
      out.writeln('DURATION:${utils.formatDuration(duration)}');
    }

    if (complete != null) out.writeln('PERCENT-COMPLETE:$_complete');

    out.write(super.serialize());
    out.write(serializeEventToDo());
    out.writeln('END:VTODO');
    return out.toString();
  }
}
