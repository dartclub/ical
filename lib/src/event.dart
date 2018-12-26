import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

class IEvent extends ICalendarElement with EventToDo {
  String uid;
  IEventStatus status;
  DateTime start;
  DateTime end;
  Duration duration;
  String summary;
  String description;
  String comment;
  List<String> categories;
  IClass classification;
  ITimeTransparency transparency;
  String location;
  double lat, lng;
  List<String> resources;
  IAlarm alarm;
  IRecurrenceRule rrule;
  String url;
  IOrganizer organizer;
  int priority;

  IEvent({
    this.uid,
    this.status,
    this.start,
    this.end,
    this.duration,
    this.summary,
    this.description,
    this.comment,
    this.categories,
    this.classification,
    this.transparency = ITimeTransparency.OPAQUE,
    this.location,
    this.lat,
    this.lng,
    this.resources,
    this.alarm,
    this.rrule,
    this.url,
    this.organizer,
    this.priority=0,
  });

  @override
  String serialize() {
    super.serialize();
    String out = 'BEGIN:VEVENT\n';

    out += 'DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}\n';

    if ((end == null && duration == null)) {
      out += 'DTSTART;VALUE=DATE:${utils.formatDate(start)}\n';
    } else {
      out += 'DTSTART:${utils.formatDateTime(start)}\n';
    }

    if (end != null) out += 'DTEND:${utils.formatDateTime(end)}\n';
    if (duration != null) out += 'DURATION:${utils.formatDuration(duration)}\n';

    switch (transparency) {
      case ITimeTransparency.TRANSPARENT:
        out += 'TRANSP:TRANSPARENT\n';
        break;
      case ITimeTransparency.OPAQUE:
      default:
        out += 'TRANSP:OPAQUE\n';
        break;
    }

    switch (status) {
      case IEventStatus.TENTATIVE:
        out += 'STATUS:TENTATIVE\n';
        break;
      case IEventStatus.CANCELLED:
        out += 'STATUS:CANCELLED\n';
        break;
      case IEventStatus.CONFIRMED:
      default:
        out += 'STATUS:CONFIRMED\n';
        break;
    }

    out += super.serialize();
    out += serializeEventToDo();

    out += 'END:VEVENT\n';
    return out;
  }
}

enum IEventStatus { TENTATIVE, CONFIRMED, CANCELLED }

enum ITimeTransparency { OPAQUE, TRANSPARENT }
