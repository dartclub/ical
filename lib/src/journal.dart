import 'abstract.dart';
import 'utils.dart' as utils;

enum IJournalStatus {
  DRAFT,
  FINAL,
  CANCELLED,
}

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
      ..writeln('DTSTART;VALUE=DATE:${utils.formatDate(start)}');

    switch (status) {
      case IJournalStatus.DRAFT:
        out.writeln('STATUS:DRAFT');
        break;
      case IJournalStatus.CANCELLED:
        out.writeln('STATUS:CANCELLED');
        break;
      case IJournalStatus.FINAL:
      default:
        out.writeln('STATUS:FINAL');
        break;
    }
    out.write(super.serialize());
    out.writeln('END:VJOURNAL');
    return out.toString();
  }
}
