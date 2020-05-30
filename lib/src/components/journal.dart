import 'package:ical/src/properties.dart';
import 'package:ical/src/utils.dart' as utils;

import '../abstract.dart';

class IJournalStatus {
  final String _label;
  @override
  toString() => _label;
  const IJournalStatus._(this._label);

  static const DRAFT = IJournalStatus._('DRAFT');
  static const FINAL = IJournalStatus._('FINAL');
  static const CANCELLED = IJournalStatus._('CANCELLED');
}

final List<PropertyFactory> _factories = [
  // TODO factories
];

class IJournal extends ICalendarElement {
  IJournalStatus status;
  DateTime start;
  IJournal({
    this.status,
    this.start,
    IOrganizer organizer,
    String uid,
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
        );

  @override
  String serialize() {
    var out = StringBuffer()
      ..writeln('BEGIN:VJOURNAL')
      ..writeln('DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}')
      ..writeln('DTSTART;VALUE=DATE:${utils.formatDate(start)}')
      ..writeln('STATUS:$status')
      ..write(super.serialize())
      ..writeln('END:VJOURNAL');
    return out.toString();
  }
}
