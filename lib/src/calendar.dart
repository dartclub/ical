// ignore_for_file: unnecessary_brace_in_string_interps

import 'abstract.dart';
import 'utils.dart' as utils;

class ICalendar extends AbstractSerializer {
  final List<ICalendarElement> _elements = <ICalendarElement>[];
  String company;
  String product;
  String lang;
  Duration? refreshInterval;

  List<ICalendarElement> get elements => _elements;

  ICalendar({
    this.company = 'dartclub',
    this.product = 'ical/serializer',
    this.lang = 'EN',
    this.refreshInterval,
  });

  void addAll(List<ICalendarElement> elements) => _elements.addAll(elements);
  void addElement(ICalendarElement element) => _elements.add(element);

  @override
  String serialize() {
    var out = StringBuffer()
      ..writecrlf('BEGIN:VCALENDAR')
      ..writecrlf('VERSION:2.0')
      ..writecrlf('PRODID://$company//$product//${lang}');

    if (refreshInterval != null) {
      out.writecrlf(
          'REFRESH-INTERVAL;VALUE=DURATION:${utils.formatDuration(refreshInterval!)}');
    }

    for (ICalendarElement element in _elements) {
      out.write(element.serialize());
    }

    out.writecrlf('END:VCALENDAR');
    return out.toString();
  }
}
