import 'package:ical/src/tokenizer.dart';

abstract class IElement {
  String serialize();
  IElement();
  IElement.parseTokens(ITokens tokens);
  // factory IElement.parse(String content) => IElement.parseTokens(Tokenizer(content).tokenize());
  // factory IElement.parse(UInt8List content) => IElement.parseTokens(Tokenizer.bytes(content).tokenize());
}

abstract class IComponent extends IElement {
  IComponent();
  IComponent.parseTokens(
      ITokens tokens, String label, List<PropertyFactory> supportedProperties) {
    var t = tokens.moveNext() &&
        tokens
            .cond((t) => t.type == ITokenType.word && t.content == 'BEGIN')
            .then((t) => t.type == ITokenType.colon)
            .then((t) => t.type == ITokenType.word && t.content == label)
            .then((t) => t.type == ITokenType.delimiter)
            .resolve();
    if (t) {
      while (tokens.moveToNextDelimiter()) {
        if (tokens
            .cond((t) => t.type == ITokenType.word && t.content == 'END')
            .then((t) => t.type == ITokenType.colon)
            .then((t) => t.type == ITokenType.word && t.content == label)
            .resolve()) {
          tokens.moveToNextDelimiter();

          // TODO deserialize/decode Component
          return;
        }
        var prop = supportedProperties
            .singleWhere((t) => t.label == tokens.current.content);
        prop.parser(tokens);
      }
    }
  }
  // factory IElement.parse(String content) => IElement.parseTokens(Tokenizer(content).tokenize());
  // factory IElement.parse(UInt8List content) => IElement.parseTokens(Tokenizer.bytes(content).tokenize());
}

typedef IElement Parser(ITokens tokens);

class PropertyFactory {
  final String label;
  final Parser parser;
  PropertyFactory(this.label, this.parser);
}
