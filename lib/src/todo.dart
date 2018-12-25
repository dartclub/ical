import 'abstract.dart';

enum TodoStatus {
  NEEDS_ACTION,
  COMPLETED,
  IN_PROCESS,
  CANCELLED,
}

class Todo extends CalendarElement
    with
        GeoLocation,
        Priority,
        Resources {
  TodoStatus status;
  DateTime completed;
  DateTime due;
  DateTime start;
  Duration duration;
  int _complete;
  set complete(int c) {
    assert(c >= 0 && c <= 100);
    _complete = c;
  }

  get complete => _complete;
  String serializePercentComplete() => 'PERCENT-COMPLETE:$_complete\n';
  @override
  String serialize() {
    return '';
  }
}
