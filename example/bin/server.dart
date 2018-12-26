import 'package:jaguar/jaguar.dart';
import '../../lib/ical_serializer.dart';

main() async {
  final server = Jaguar();
  ICalendar cal = ICalendar();
  cal.addElement(
    IEvent(
      start: DateTime(2018, 12, 24),
      url: 'https://de.wikipedia.org/wiki/Weihnachten',
      status: IEventStatus.CONFIRMED,
      lat: 31.7053804,
      lng: 35.1849329,
      location: 'Bethlehem',
      description:
          'Weihnachten, auch Weihnacht, Christfest oder Heiliger Christ genannt, ist das Fest der Geburt Jesu Christi.\nFesttag ist der 25. Dezember, der Christtag, auch Hochfest der Geburt des Herrn, dessen Feierlichkeiten am Vorabend, dem Heiligen Abend, beginnen.\nEr ist in vielen Staaten ein gesetzlicher Feiertag.',
      summary: 'Weihnachten',
      rrule: IRecurrenceRule(frequency: IRecurrenceFrequency.YEARLY),
    ),
  );
  server.get('/calendar.ics',
      (Context ctx) => Response(cal.serialize(), mimeType: 'text/calendar'));
  await server.serve();
  print('server running http://localhost:8080');
}