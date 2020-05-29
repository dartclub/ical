# ical
Dart package to generate iCalendar files.

https://en.wikipedia.org/wiki/ICalendar

## Example

```
import 'package:ical/serializer.dart';
import 'dart:io';

main() async {
  ICalendar cal = ICalendar();
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
        duration: Duration(minutes: 3),
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
```

Full example in `./example`
### Implemented Features

- [x] Basic Calendar Object
- [x] Event Element
- [x] To-Do Element
- [x] Journal Element
- [x] Alarm Component
- [ ] Free/Busy Times
- [ ] Timezones
- [ ] Attachements (for Emails, Sound-Alarms, etc.)
- [x] Recurrence of Elements with RRULE
- [ ] EXDATE
- [x] STATUS
- [ ] ATTENDEE, [ ] CONTACT, [x] ORGANIZER [Link](https://tools.ietf.org/html/rfc5545#section-3.8.4.1)
