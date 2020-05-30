import 'package:ical/src/abstract.dart';

import '../tokenizer.dart';

final List<PropertyFactory> _factories = [
  // TODO factories
];

class IDaylight extends IComponent {
  IDaylight();
  IDaylight.parseTokens(ITokens tokens)
      : super.parseTokens(tokens, 'VDAYLIGHT', _factories);

  @override
  String serialize() {
    // TODO: implement serialize
    throw UnimplementedError();
  }
}
