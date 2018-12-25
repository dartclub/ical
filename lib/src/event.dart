import 'abstract.dart';
import 'utils.dart' as utils;
import 'subcomponents.dart';
import 'package:nanoid/nanoid.dart';

enum EventStatus { TENTATIVE, CONFIRMED, CANCELLED }
enum TimeTransparency { OPAQUE, TRANSPARENT }

class Event extends CalendarElement with GeoLocation, Priority, Resources {
  String uid;
  EventStatus status;
  DateTime end;
  DateTime start;
  Duration duration;
  TimeTransparency transparency;
  List<String> categories;
  Class classification;
  String comment;
  String description;
  String location;
  double lat, lng;
  List<String> resources;
  String summary;
  RecurrenceRule rrule;

  Alarm alarm;

  Event({
    this.uid,
    this.start,
    this.end,
    this.duration,
    this.transparency = TimeTransparency.OPAQUE,
    this.categories,
    this.classification,
    this.comment,
    this.description,
    this.summary,
    this.location,
    this.lat,
    this.lng,
    this.resources,
    this.alarm,
    this.status,
    this.rrule,
    String eventUrl,
  }) {
    super.url = eventUrl;
  }

  @override
  String serialize() {
    String out = 'BEGIN:VEVENT\n';
    print(url);
    if (uid == null) {
      uid = nanoid(32);
    }
    out += 'UID:$uid\n';
    out += 'DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}\n';
    if ((end == null && duration == null)) {
      out += 'DTSTART;VALUE=DATE:${utils.formatDate(start)}\n';
    } else {
      out += 'DTSTART:${utils.formatDateTime(start)}\n';
    }

    if (end != null) {
      out += 'DTEND:${utils.formatDateTime(end)}\n';
    }
    if (duration != null) {
      out += 'DURATION:${utils.formatDuration(duration)}\n';
    }

    switch (transparency) {
      case TimeTransparency.TRANSPARENT:
        out += 'TRANSP:TRANSPARENT\n';
        break;
      case TimeTransparency.OPAQUE:
      default:
        out += 'TRANSP:OPAQUE\n';
        break;
    }

    switch (status) {
      case EventStatus.TENTATIVE:
        out += 'STATUS:TENTATIVE\n';
        break;
      case EventStatus.CANCELLED:
        out += 'STATUS:CANCELLED\n';
        break;
      case EventStatus.CONFIRMED:
      default:
        out += 'STATUS:CONFIRMED\n';
        break;
    }

    out += serializeCategories();
    out += serializeClassification();
    if (comment != null) out += serializeComment();
    if (description != null) out += serializeDescription();
    if (summary != null) out += serializeSummary();
    if (location != null) out += serializeLocation();
    if (lat != null && lng != null) out += serializeGeo();
    if (resources != null) out += serializeResources();
    if (alarm != null) out += alarm.serialize();
    if (super.url != null) out += serializeUrl();
    if (rrule != null) out += rrule.serialize();

    out += 'END:VEVENT\n';
    return out;
  }
}
