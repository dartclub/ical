import 'dart:typed_data';

enum ITokenType {
  word,
  colon, // :
  delimiter, // \r\n
}

class IToken {
  String content;
  ITokenType type;
  IToken(this.content, this.type);
}

typedef bool Cond(IToken t);

class ITokens extends Iterator {
  final List<IToken> tokens;
  int _i = 0;

  ITokens(this.tokens);

  @override
  IToken get current => tokens[_i];

  @override
  bool moveNext() => ++_i < tokens.length;
  bool moveToNextDelimiter() {
    while (++_i < tokens.length) {
      if (tokens[_i].type == ITokenType.delimiter) {
        return ++_i < tokens.length;
      }
    }

    return false;
  }

  _CondTokens cond(Cond c) {
    if (tokens.sublist(_i + 1).isEmpty) {
      return _CondTokens(false, []);
    }
    return _CondTokens(c(current), tokens.sublist(_i + 1));
  }
}

class _CondTokens {
  final bool _state;
  final List<IToken> tokens;
  _CondTokens(this._state, this.tokens);
  _CondTokens then(Cond c) {
    if (tokens.isEmpty) {
      return _CondTokens(false, []);
    }
    return _CondTokens(_state ? c(tokens.first) : _state, tokens.sublist(1));
  }

  bool resolve() => _state;
}

class ITokenizer {
  String content;
  ITokenizer.bytes(Uint8List bytes) : content = bytes.toString();
  ITokenizer(this.content);
}

/*
main(){
  token.then((t) => ...).then((t) => ...).then((t) => ...).;
}
*/
