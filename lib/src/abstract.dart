import 'utils.dart' as utils;
import 'subcomponents.dart';
import 'package:nanoid/nanoid.dart';

abstract class AbstractSerializer {
  String serialize();
}

enum IClass {
  PUBLIC,
  PRIVATE,
  CONFIDENTIAL,
}

enum IRecurrenceFrequency {
  SECONDLY,
  MINUTELY,
  HOURLY,
  DAILY,
  WEEKLY,
  MONTHLY,
  YEARLY,
}

class IRecurrenceRule {
  IRecurrenceFrequency frequency;
  DateTime untilDate;
  int count;
  int interval;
  int weekday;
  // TODO BYSECOND, BYMINUTE, BYHOUR, BYDAY,BYMONTHDAY,BYYEARDAY,BYWEEKNO,BYMONTH,BYSETPOS,WKST

  static List<String> weekdays = <String>[
    "SU",
    "MO",
    "TU",
    "WE",
    "TH",
    "FR",
    "SA"
  ];
  IRecurrenceRule({
    this.frequency = IRecurrenceFrequency.DAILY,
    this.untilDate,
    this.count = 0,
    this.interval = 0,
    this.weekday = 0,
  });
  String serialize() {
    var out = StringBuffer()..write('RRULE:FREQ=');
    switch (frequency) {
      case IRecurrenceFrequency.SECONDLY:
        out.write('SECONDLY');
        break;
      case IRecurrenceFrequency.MINUTELY:
        out.write('MINUTELY');
        break;
      case IRecurrenceFrequency.HOURLY:
        out.write('HOURLY');
        break;
      case IRecurrenceFrequency.WEEKLY:
        out.write('WEEKLY');
        break;
      case IRecurrenceFrequency.MONTHLY:
        out.write('MONTHLY');
        break;
      case IRecurrenceFrequency.YEARLY:
        out.write('YEARLY');
        break;
      case IRecurrenceFrequency.DAILY:
      default:
        out.write('DAILY');
        break;
    }
    if (untilDate != null)
      out.write(';UNTIL=${utils.formatDateTime(untilDate)}');
    if (count > 0) out.write('COUNT=$count');
    if (interval > 0) out.write(';INTERVAL=$interval');
    if (weekday > 0 && weekday < 8) out.write(';WKST=${weekdays[weekday - 1]}');
    out.writeln('');
    return out.toString();
  }
}

class IOrganizer {
  String name;
  String email;
  IOrganizer({this.name, this.email});
  String serializeOrganizer() {
    var out = StringBuffer()..write('ORGANIZER');
    if (name != null) {
      out.write(';CN=$name');
    }
    if (email == null) {
      return '';
    }
    out.writeln(':mailto:$email');
    return out.toString();
  }
}

abstract class ICalendarElement extends AbstractSerializer {
  IOrganizer organizer;
  String uid;
  String summary;
  String description;
  List<String> categories;
  String url;
  IClass classification;
  String comment;
  IRecurrenceRule rrule;

  ICalendarElement({
    this.organizer,
    this.uid,
    this.summary,
    this.description,
    this.categories,
    this.url,
    this.classification,
    this.comment,
    this.rrule,
  });

  String _serializeClassification() {
    switch (classification) {
      case IClass.PUBLIC:
        return 'CLASS:PUBLIC\n';
      case IClass.PRIVATE:
        return 'CLASS:PRIVATE\n';
      case IClass.CONFIDENTIAL:
        return 'CLASS:CONFIDENTIAL\n';
      default:
        return '';
    }
  }

  String _serializeDescription() =>
      'DESCRIPTION:${description.replaceAll('\n', "\\n\n\t")}\n';

  String serialize() {
    var out = StringBuffer();

    if (uid == null) uid = nanoid(32);

    out.writeln('UID:$uid');

    if (categories != null) out.writeln('CATEGORIES:${categories.join(',')}');

    if (comment != null) out.writeln('COMMENT:$comment');
    if (summary != null) out.writeln('SUMMARY:$summary');
    if (url != null) out.writeln('URL:${url}');
    out.write(_serializeClassification());
    if (description != null) out.write(_serializeDescription());
    if (rrule != null) out.write(rrule.serialize());

    return out.toString();
  }
  // TODO ATTENDEE
  // TODO CONTACT
}

// Component Properties for Event + To-Do

mixin EventToDo {
  String location;
  double lat;
  double lng;
  int priority;
  List<String> resources;
  IAlarm alarm;

  String serializeEventToDo() {
    var out = StringBuffer();
    if (location != null) out.writeln('LOCATION:$location');
    if (lat != null && lng != null) out.writeln('GEO:$lat;$lng');
    if (resources != null) out.writeln('RESOURCES:${resources.join(',')}');
    if (priority != null) {
      priority = (priority >= 0 && priority <= 9) ? priority : 0;
      out.writeln('PRIORITY:${priority}');
    }
    if (alarm != null) out.write(alarm.serialize());

    return out.toString();
  }
}
