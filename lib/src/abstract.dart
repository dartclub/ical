import 'utils.dart' as utils;

abstract class AbstractSerializer {
  String serialize();
}

enum Class {
  PUBLIC,
  PRIVATE,
  CONFIDENTIAL,
}

enum RecurrenceFrequency {
  SECONDLY,
  MINUTELY,
  HOURLY,
  DAILY,
  WEEKLY,
  MONTHLY,
  YEARLY,
}

class RecurrenceRule {
  RecurrenceFrequency frequency;
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
  RecurrenceRule({
    this.frequency = RecurrenceFrequency.DAILY,
    this.untilDate,
    this.count = 0,
    this.interval = 0,
    this.weekday = 0,
  });
  String serialize() {
    String out = 'RRULE:FREQ=';
    switch (frequency) {
      case RecurrenceFrequency.SECONDLY:
        out += 'SECONDLY';
        break;
      case RecurrenceFrequency.MINUTELY:
        out += 'MINUTELY';
        break;
      case RecurrenceFrequency.HOURLY:
        out += 'HOURLY';
        break;
      case RecurrenceFrequency.WEEKLY:
        out += 'WEEKLY';
        break;
      case RecurrenceFrequency.MONTHLY:
        out += 'MONTHLY';
        break;
      case RecurrenceFrequency.YEARLY:
        out += 'YEARLY';
        break;
      case RecurrenceFrequency.DAILY:
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

abstract class CalendarElement extends AbstractSerializer {
  String organizer;
  String uid;
  String summary;
  String description;
  List<String> categories;
  Uri _url = null;
  Class classification;
  String comment;
  RecurrenceRule rrule;

  String serializeSummary() => 'SUMMARY:$summary\n';
  String serializeComment() => 'COMMENT:$comment\n';
  String serializeUrl() => 'URL:${url}\n';
  String serializeClassification() {
    switch (classification) {
      case Class.PUBLIC:
        return 'CLASS:PUBLIC\n';
      case Class.PRIVATE:
        return 'CLASS:PRIVATE\n';
      case Class.CONFIDENTIAL:
        return 'CLASS:CONFIDENTIAL\n';
      default:
        return '';
    }
  }

  set url(String u) => _url = Uri.tryParse(u);
  get url => _url.toString();
  String serializeCategories() =>
      (categories != null) ? 'CATEGORIES:${categories.join(',')}\n' : '';
  String serializeDescription() {
    String out = description.replaceAll('\n', "\\n\n\t");
    return 'DESCRIPTION:${out}\n';
  }
}

// Component Properties for Event + To-Do

mixin GeoLocation {
  String location;
  String serializeLocation() => 'LOCATION:$location\n';
  double lat;
  double lng;
  String serializeGeo() => 'GEO:$lat;$lng\n';
}

mixin Priority {
  int _priority = 0;
  set priority(int p) {
    assert(p >= 1 && p <= 9);
    _priority = p;
  }

  get priority => _priority;
  String serializePriority() => 'PRIORITY:$_priority\n';
}

abstract class Resources {
  List<String> resources;
  String serializeResources() =>
      (resources != null) ? 'RESOURCES:${resources.join(',')}\n' : '';
}
