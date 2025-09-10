import 'dart:io';

import 'package:ical/serializer.dart';

Future<void> main() async {
  final ICalendar cal = ICalendar();
  cal.addElement(
    IEvent(
      uid: 'test@example.com',
      start: DateTime(2019, 3, 6),
      url: 'https://pub.dartlang.org/packages/srt_parser',
      status: IEventStatus.CONFIRMED,
      location: 'Heilbronn',
      description:
          'Arman and Adrian released their SRT-file parser library for Dart',
      summary: 'SRT-file Parser Release',
      rrule: IRecurrenceRule(frequency: IRecurrenceFrequency.YEARLY),
    ),
  );
  cal.addElement(
    IEvent(
      alarm: IAlarm.audio(
        duration: const Duration(minutes: 3),
        repeat: 1,
        trigger: DateTime(2019, 4, 2, 11),
      ),
      description: 'Lukas releases his iCal-feed serializer',
      summary: 'ical Release',
      start: DateTime(2019, 4, 2, 11, 15),
      end: DateTime(2019, 4, 2, 11, 30),
      uid: 'lukas@himsel.me',
      organizer: IOrganizer(email: 'lukas@himsel.me', name: 'Lukas Himsel'),
      lat: 49.6782872,
      lng: 10.2425528,
    ),
  );

  await HttpServer.bind(InternetAddress.loopbackIPv4, 8080)
    ..listen((HttpRequest request) {
      request.response
        ..headers.contentType = ContentType('text', 'calendar')
        ..write(cal.serialize())
        ..close();
    });
  print('server running http://localhost:8080');
}
