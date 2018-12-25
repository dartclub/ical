import 'abstract.dart';

class Calendar extends AbstractSerializer {
  List<CalendarElement> _elements = <CalendarElement>[];
  String company;
  String product;
  String lang;

  Calendar({
    this.company = 'dartclub',
    this.product = 'ical_serializer',
    this.lang = 'EN',
  });

  addElement(CalendarElement element) => _elements.add(element);

  @override
  String serialize() {
    String out = 'BEGIN:VCALENDAR\nVERSION:2.0\n';
    out += 'PRODID://${company}//${product}//${lang}\n';

    for (CalendarElement element in _elements) {
      out += element.serialize();
    }

    out += 'END:VCALENDAR';
    return out;
  }
}
