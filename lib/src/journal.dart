// ignore_for_file: constant_identifier_names

import 'package:meta/meta.dart';

import 'abstract.dart';
import 'utils.dart' as utils;

@immutable
final class IJournalStatus {
  static const DRAFT = IJournalStatus._('DRAFT');
  static const FINAL = IJournalStatus._('FINAL');
  static const CANCELLED = IJournalStatus._('CANCELLED');

  final String _label;

  const IJournalStatus._(this._label);

  @override
  String toString() => _label;
}

class IJournal extends ICalendarElement {
  IJournalStatus status;
  DateTime start;

  IJournal({
    this.status = IJournalStatus.FINAL,
    required this.start,
    super.organizer,
    super.uid,
    super.summary,
    super.description,
    super.categories,
    super.url,
    IClass super.classification,
    super.comment,
    super.rrule,
  });

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
