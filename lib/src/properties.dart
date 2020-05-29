import 'package:nanoid/nanoid.dart';

import 'abstract.dart';
import 'utils.dart' as utils;

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
      out.write('COUNT=$count');
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
      out.write(';CN=$name');
    }
    if (email == null) {
      return '';
    }
    out.writeln(':mailto:$email');
    return out.toString();
  }
}

class IAttendee {
  // TODO implement 
}

abstract class ICalendarElement extends IComponent {
  IOrganizer organizer;
  String uid;
  String summary;
  String description;
  List<String> categories;
  String url;
  IClass classification = IClass.PRIVATE;
  String comment;
  IRecurrenceRule rrule;
  List<IAttendee> attendees;

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
    out.writeln('CLASS:$classification');
    if (description != null) out.write(_serializeDescription());
    if (rrule != null) out.write(rrule.serialize());

    return out.toString();
  }
  // TODO CONTACT
}
