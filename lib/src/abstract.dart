import 'package:ical/serializer.dart';
import 'package:ical/src/structure.dart';
import 'package:ical/src/utils.dart';

import 'utils.dart' as utils;
import 'subcomponents.dart';
import 'package:nanoid/nanoid.dart';

abstract class AbstractSerializer {
  String serialize();
}

abstract class AbstractDeserializer {
  void deserialize(ICalStructure structure);
}

class IClass {
  final String _label;
  @override
  toString() => _label;
  const IClass._(this._label);
  static const PUBLIC = IClass._('PUBLIC');
  static const PRIVATE = IClass._('PRIVATE');
  static const CONFIDENTIAL = IClass._('CONFIDENTIAL');
}

class IRecurrenceFrequency {
  final String _label;
  @override
  toString() => _label;
  const IRecurrenceFrequency._(this._label);
  static const SECONDLY = IRecurrenceFrequency._('SECONDLY');
  static const MINUTELY = IRecurrenceFrequency._('MINUTELY');
  static const HOURLY = IRecurrenceFrequency._('HOURLY');
  static const DAILY = IRecurrenceFrequency._('DAILY');
  static const WEEKLY = IRecurrenceFrequency._('WEEKLY');
  static const MONTHLY = IRecurrenceFrequency._('MONTHLY');
  static const YEARLY = IRecurrenceFrequency._('YEARLY');
  static const BYSECOND = IRecurrenceFrequency._('BYSECOND');
  static const BYMINUTE = IRecurrenceFrequency._('BYMINUTE');
  static const BYHOUR = IRecurrenceFrequency._('BYHOUR');
  static const BYDAY = IRecurrenceFrequency._('BYDAY');
  static const BYMONTHDAY = IRecurrenceFrequency._('BYMONTHDAY');
  static const BYYEARDAY = IRecurrenceFrequency._('BYYEARDAY');
  static const BYWEEKNO = IRecurrenceFrequency._('BYWEEKNO');
  static const BYMONTH = IRecurrenceFrequency._('BYMONTH');
  static const BYSETPOS = IRecurrenceFrequency._('BYSETPOS');
  static const WKST = IRecurrenceFrequency._('WKST');
}

class IRecurrenceRule {
  IRecurrenceFrequency frequency = IRecurrenceFrequency.DAILY;
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
    this.frequency,
    this.untilDate,
    this.count = 0,
    this.interval = 0,
    this.weekday = 0,
  });
  String serialize() {
    var out = StringBuffer();
    out..write('RRULE:FREQ=$frequency');

    if (untilDate != null) {
      out.write(';UNTIL=${utils.formatDateTime(untilDate)}');
    }
    if (count > 0) {
      out.write(';COUNT=$count');
    }
    if (interval > 0) {
      out.write(';INTERVAL=$interval');
    }
    if (weekday > 0 && weekday < 8) {
      out.write(';WKST=${weekdays[weekday - 1]}');
    }
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
      out.write(';CN=${escapeValue(name)}');
    }
    if (email == null) {
      return '';
    }
    out.writeln(':mailto:$email');
    return out.toString();
  }
}

abstract class ICalendarElement implements AbstractSerializer, AbstractDeserializer {
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
    this.classification = IClass.PRIVATE,
    this.comment,
    this.rrule,
  });

  String serialize() {
    var out = StringBuffer();

    uid ??= nanoid(32);

    out.writeln('UID:$uid');

    if (categories != null) {
      out.writeln('CATEGORIES:${categories.map(escapeValue).join(',')}');
    }

    if (comment != null) out.writeln('COMMENT:${escapeValue(comment)}');
    if (summary != null) out.writeln('SUMMARY:${escapeValue(summary)}');
    if (url != null) out.writeln('URL:${url}');
    if (classification != null) out.writeln('CLASS:$classification');
    if (description != null)
      out.writeln('DESCRIPTION:${escapeValue(description)}');
    if (rrule != null) out.write(rrule.serialize());

    return out.toString();
  }

  @override
  void deserialize(ICalStructure structure) {
    uid = structure["UID"]?.value;
    categories = structure["CATEGORIES"]?.value?.split(",");
    comment = structure["COMMENT"]?.value;
    summary = structure["SUMMARY"]?.value;
    url = structure["URL"]?.value;
    final classificationString = structure["CLASSIFICATION"]?.value;
    if(classificationString != null) classification = IClass._(classificationString);
    // TODO support rrule
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
    if (location != null) out.writeln('LOCATION:${escapeValue(location)}');
    if (lat != null && lng != null) out.writeln('GEO:$lat;$lng');
    if (resources != null) {
      out.writeln('RESOURCES:${resources.map(escapeValue).join(',')}');
    }
    if (priority != null) {
      priority = (priority >= 0 && priority <= 9) ? priority : 0;
      out.writeln('PRIORITY:$priority');
    }
    if (alarm != null) out.write(alarm.serialize());

    return out.toString();
  }
}
