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
    String out = 'RRULE:FREQ=';
    switch (frequency) {
      case IRecurrenceFrequency.SECONDLY:
        out += 'SECONDLY';
        break;
      case IRecurrenceFrequency.MINUTELY:
        out += 'MINUTELY';
        break;
      case IRecurrenceFrequency.HOURLY:
        out += 'HOURLY';
        break;
      case IRecurrenceFrequency.WEEKLY:
        out += 'WEEKLY';
        break;
      case IRecurrenceFrequency.MONTHLY:
        out += 'MONTHLY';
        break;
      case IRecurrenceFrequency.YEARLY:
        out += 'YEARLY';
        break;
      case IRecurrenceFrequency.DAILY:
      default:
        out += 'DAILY';
        break;
    }
    if (untilDate != null) out += ';UNTIL=${utils.formatDateTime(untilDate)}';
    if (count > 0) out += ';COUNT=$count';
    if (interval > 0) out += ';INTERVAL=$interval';
    if (weekday > 0 && weekday < 8) out += ';WKST=${weekdays[weekday - 1]}';
    return '$out\n';
  }
}

class IOrganizer {
  String name;
  String email;
  IOrganizer({this.name, this.email});
  String serializeOrganizer() {
    String out = 'ORGANIZER';
    if (name != null) {
      out += ';CN=$name';
    }
    if (email == null) {
      return '';
    }
    return '$out:mailto:$email';
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

  String _serializeDescription() {
    String out = description.replaceAll('\n', "\\n\n\t");
    return 'DESCRIPTION:${out}\n';
  }

  String serialize() {
    String out;

    if (uid == null) uid = nanoid(32);

    out = 'UID:$uid\n';

    if (categories != null) out += 'CATEGORIES:${categories.join(',')}\n';

    if (comment != null) out += 'COMMENT:$comment\n';
    if (summary != null) out += 'SUMMARY:$summary\n';
    if (url != null) out += 'URL:${url}\n';
    out += _serializeClassification();
    if (description != null) out += _serializeDescription();
    if (rrule != null) out += rrule.serialize();

    return out;
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
    String out = '';
    if (location != null) out += 'LOCATION:$location\n';
    if (lat != null && lng != null) out += 'GEO:$lat;$lng\n';
    if (resources != null) out += 'RESOURCES:${resources.join(',')}\n';
    if (priority != null) {
      priority = (priority >= 0 && priority <= 9) ? priority : 0;
      out += 'PRIORITY:${priority}\n';
    }
    if (alarm != null) out += alarm.serialize();

    return out;
  }
}
