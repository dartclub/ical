import 'package:ical/src/abstract.dart';

import '../tokenizer.dart';

final List<PropertyFactory> _factories = [
  // TODO factories
];

class ITimezone extends IComponent {
  ITimezone();
  ITimezone.parseTokens(ITokens tokens)
      : super.parseTokens(tokens, 'VTIMEZONE', _factories);

  @override
  String serialize() {
    // TODO: implement serialize
    throw UnimplementedError();
  }
}
