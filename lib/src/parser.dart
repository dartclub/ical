import 'dart:convert';

import 'package:ical/serializer.dart';
import 'package:ical/src/structure.dart';

const _rowRegex = r"""^([\w-]+);?([\w-]+="[^"]*"|.*?):(.*)$""";
const _middleRegex = r"""(?<key>[^=;]+)=(?<value>[^;]+)""";

class ICalParser {
  List<ICalRow> parseText(String text) {
    // unfold strings
    text = text.replaceAll("\r\n", "\n").replaceAll("\n ", "");
    return LineSplitter()
        .convert(text)
        .map(_parseLine)
        .where((element) => element != null)
        .toList();
  }

  ICalRow _parseLine(String line) {
    final regex = RegExp(_rowRegex);
    final match = regex.firstMatch(line);
    if(match == null) return null;
    final String key = match.group(1);
    final String middle = match.group(2);
    final String value = match.group(3);
    return ICalRow(key, value, properties: _parseMiddlePart(middle));
  }

  Map<String, String> _parseMiddlePart(String middle) {
    final matches = RegExp(_middleRegex).allMatches(middle);
    final entries = matches
        .map((match) => MapEntry(match.namedGroup("key"), match.namedGroup("value")));
    return Map.fromEntries(entries);
  }
  
  ICalendar parseCalender(String text) {
    final rows = parseText(text);

  }
}