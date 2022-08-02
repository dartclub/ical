import 'package:ical/serializer.dart';
import 'package:ical/src/structure.dart';

import 'utils.dart' as utils;

class ICalendar implements AbstractSerializer, AbstractDeserializer {
  List<ICalendarElement> _elements = <ICalendarElement>[];
  String company;
  String product;
  String lang;
  Duration refreshInterval;

  ICalendar({
    this.company = 'dartclub',
    this.product = 'ical/serializer',
    this.lang = 'EN',
    this.refreshInterval,
  });

  addAll(List<ICalendarElement> elements) => _elements.addAll(elements);
  addElement(ICalendarElement element) => _elements.add(element);

  List<IEvent> get events => _elements.whereType<IEvent>().toList();

  @override
  String serialize() {
    var out = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID://${company}//${product}//${lang}');

    if (refreshInterval != null) {
      out.writeln(
          'REFRESH-INTERVAL;VALUE=DURATION:${utils.formatDuration(refreshInterval)}');
    }

    for (ICalendarElement element in _elements) {
      out.write(element.serialize());
    }

    out.writeln('END:VCALENDAR');
    return out.toString();
  }

  @override
  void deserialize(ICalStructure structure) {
    _elements = structure.children
        .where((child) => child.type == "VEVENT")
        .map((event) => IEvent()..deserialize(event))
        .cast<ICalendarElement>()
        .toList();
  }
}
