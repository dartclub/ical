import 'package:intl/intl.dart';

DateFormat utcDateTimeFormatter = DateFormat("yyyyMMdd'T'HHmmss'Z'");
DateFormat floatingDateTimeFormatter = DateFormat("yyyyMMdd'T'HHmmss");

formatDateTime(DateTime dt) => dt.isUtc
    ? utcDateTimeFormatter.format(dt)
    : floatingDateTimeFormatter.format(dt);

/// If this DateTime is a UTC date time or the time zone is null this returns an empty string.
/// If a time zone string is passed, returns a TZID parameter.
/// It is assumed that the time zone string is from a unique database therefore it is prepended with a /
///
/// see https://icalendar.org/iCalendar-RFC-5545/3-2-19-time-zone-identifier.html
String injectTimeZone(DateTime dt, String? timeZone) {
  if (dt.isUtc || timeZone == null) {
    return "";
  } else {
    return ";TZID=/$timeZone";
  }
}

formatDate(DateTime dt) => DateFormat("yyyyMMdd").format(dt);
formatDuration(Duration d) {
  String out = (d.isNegative ? '-' : '+') + 'P';
  int hours = (d.inHours - (d.inDays * 24)).abs();
  int minutes = (d.inMinutes - (d.inHours * 60)).abs();
  int seconds = (d.inSeconds - (d.inMinutes * 60)).abs();

  if (d.inDays > 0) {
    out += '${d.inDays}D';
  }

  out += 'T${hours}H${minutes}M${seconds}S';

  return out;
}

String escapeValue(String val) => val
    .replaceAll('\\', '\\\\')
    .replaceAll('\n', '\\n')
    .replaceAll('\t', '\\t')
    .replaceAll(',', '\\,')
    .replaceAll(';', '\\;');
