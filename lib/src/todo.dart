import 'abstract.dart';
import 'subcomponents.dart';

enum ITodoStatus {
  NEEDS_ACTION,
  COMPLETED,
  IN_PROCESS,
  CANCELLED,
}

class ITodo extends ICalendarElement with EventToDo {
  IOrganizer organizer;
  String uid;
  String summary;
  String description;
  List<String> categories;
  String url;
  IClass classification;
  String comment;
  IRecurrenceRule rrule;
  ITodoStatus status;
  DateTime completed;
  DateTime due;
  DateTime start;
  Duration duration;
  String location;
  double lat;
  double lng;
  List<String> resources;
  IAlarm alarm;
  int priority;

  int _complete;
  set complete(int c) {
    assert(c >= 0 && c <= 100);
    _complete = c;
  }
  get complete => _complete;

  ITodo({
    this.uid,
    this.status,
    this.start,
    this.due,
    this.duration,
    this.summary,
    this.description,
    this.comment,
    this.categories,
    this.classification,
    this.location,
    this.lat,
    this.lng,
    this.resources,
    this.alarm,
    this.rrule,
    this.url,
    this.organizer,
    int percentComplete=0,
    this.priority=0,
  }){complete = percentComplete;}

  @override
  String serialize() {
    String out = 'BEGIN:VTODO\n';

    if(complete!=null) out += 'PERCENT-COMPLETE:$_complete\n';

    out += super.serialize();
    out += serializeEventToDo();
    return '$out\nEND:VTODO\n';
  }
}
