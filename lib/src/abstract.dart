import 'package:ical/serializer.dart';

abstract class IElement {
  String serialize();
}

abstract class IComponent extends IElement {}

abstract class IProperty extends IElement {}

abstract class IParameter extends IElement {}

abstract class IDataType extends IElement {}

// Component Properties for Event + To-Do

mixin EventToDo {
  String location;
  double lat;
  double lng;
  int priority;
  List<String> resources;
  IAlarm alarm;

  String serializeEventToDo() {
    var out = StringBuffer();
    if (location != null) out.writeln('LOCATION:$location');
    if (lat != null && lng != null) out.writeln('GEO:$lat;$lng');
    if (resources != null) out.writeln('RESOURCES:${resources.join(',')}');
    if (priority != null) {
      priority = (priority >= 0 && priority <= 9) ? priority : 0;
      out.writeln('PRIORITY:${priority}');
    }
    if (alarm != null) out.write(alarm.serialize());

    return out.toString();
  }
}
