import 'package:ical/src/abstract.dart';

import '../tokenizer.dart';

final List<PropertyFactory> _factories = [
  // TODO factories
];

class IStandard extends IComponent {
  IStandard();
  IStandard.parseTokens(ITokens tokens)
      : super.parseTokens(tokens, 'VSTANDARD', _factories);

  @override
  String serialize() {
    // TODO: implement serialize
    throw UnimplementedError();
  }
}
