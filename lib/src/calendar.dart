import 'abstract.dart';

class ICalendar extends AbstractSerializer {
  List<ICalendarElement> _elements = <ICalendarElement>[];
  String company;
  String product;
  String lang;

  ICalendar({
    this.company = 'dartclub',
    this.product = 'ical_serializer',
    this.lang = 'EN',
  });

  addAll(List<ICalendarElement> elements) => _elements.addAll(elements);
  addElement(ICalendarElement element) => _elements.add(element);

  @override
  String serialize() {
    var out = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID://${company}//${product}//${lang}');

    for (ICalendarElement element in _elements) {
      out.write(element.serialize());
    }

    out.writeln('END:VCALENDAR');
    return out.toString();
  }
}
