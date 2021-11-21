import 'package:ical/src/utils.dart';

import 'abstract.dart';
import 'utils.dart' as utils;

class IJournalStatus {
  final String _label;
  @override
  toString() => _label;
  const IJournalStatus._(this._label);

  static const DRAFT = IJournalStatus._('DRAFT');
  static const FINAL = IJournalStatus._('FINAL');
  static const CANCELLED = IJournalStatus._('CANCELLED');
}

class IJournal extends ICalendarElement {
  IJournalStatus status;
  DateTime start;
  IJournal({
    this.status = IJournalStatus.FINAL,
    required this.start,
    IOrganizer? organizer,
    String? uid,
    String? summary,
    String? description,
    List<String>? categories,
    String? url,
    IClass classification = IClass.PRIVATE,
    String? comment,
    IRecurrenceRule? rrule,
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
      ..writecrlf('BEGIN:VJOURNAL')
      ..writecrlf('DTSTAMP:${utils.formatDateTime(start)}')
      ..writecrlf('DTSTART;VALUE=DATE:${utils.formatDate(start)}')
      ..writecrlf('STATUS:$status')
      ..write(super.serialize())
      ..writecrlf('END:VJOURNAL');
    return out.toString();
  }
}
