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

  addElement(ICalendarElement element) => _elements.add(element);

  @override
  String serialize() {
    String out = 'BEGIN:VCALENDAR\nVERSION:2.0\n';
    out += 'PRODID://${company}//${product}//${lang}\n';

    for (ICalendarElement element in _elements) {
      out += element.serialize();
    }

    out += 'END:VCALENDAR';
    return out;
  }
}
