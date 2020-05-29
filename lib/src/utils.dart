import 'package:intl/intl.dart';

formatDateTime(DateTime dt) => DateFormat("yyyyMMdd'T'HHmmss'Z'").format(dt);
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
