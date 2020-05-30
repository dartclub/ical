import 'package:ical/src/abstract.dart';

import '../tokenizer.dart';

final List<PropertyFactory> _factories = [
  // TODO factories
];

class IFreeBusy extends IComponent {
  IFreeBusy();
  IFreeBusy.parseTokens(ITokens tokens)
      : super.parseTokens(tokens, 'VFREEBUSY', _factories);

  @override
  String serialize() {
    // TODO: implement serialize
    throw UnimplementedError();
  }
}
