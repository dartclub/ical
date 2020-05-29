enum ITokenType {
  word,
  colon,
}

class IToken {
  String content;
  ITokenType type;
  IToken(this.content, this.type);
}
