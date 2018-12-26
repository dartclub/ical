import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

class IEvent extends ICalendarElement with EventToDo {
  IEventStatus status;
  DateTime start;
  DateTime end;
  Duration duration;
  ITimeTransparency transparency;

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
    IClass classification,
    String comment,
    IRecurrenceRule rrule,
    this.transparency = ITimeTransparency.OPAQUE,
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

    if (end != null) out.writeln('DTEND:${utils.formatDateTime(end)}');
    if (duration != null)
      out.writeln('DURATION:${utils.formatDuration(duration)}');

    switch (transparency) {
      case ITimeTransparency.TRANSPARENT:
        out.writeln('TRANSP:TRANSPARENT');
        break;
      case ITimeTransparency.OPAQUE:
      default:
        out.writeln('TRANSP:OPAQUE');
        break;
    }

    switch (status) {
      case IEventStatus.TENTATIVE:
        out.writeln('STATUS:TENTATIVE');
        break;
      case IEventStatus.CANCELLED:
        out.writeln('STATUS:CANCELLED');
        break;
      case IEventStatus.CONFIRMED:
      default:
        out.writeln('STATUS:CONFIRMED');
        break;
    }

    out.write(super.serialize());
    out.write(serializeEventToDo());

    out.writeln('END:VEVENT');
    return out.toString();
  }
}

enum IEventStatus { TENTATIVE, CONFIRMED, CANCELLED }

enum ITimeTransparency { OPAQUE, TRANSPARENT }
