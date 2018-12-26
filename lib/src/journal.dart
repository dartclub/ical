import 'abstract.dart';

enum IJournalStatus {
  DRAFT,
  FINAL,
  CANCELLED,
}

class IJournal extends ICalendarElement{
  @override
  String serialize() {
    // TODO: implement serialize
    return null;
  }
}
