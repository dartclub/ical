abstract class IElement {
  IElement.named() {
    print('named constructor');
  }
  IElement.named2() {
    print('named2 constructor');
  }
}

class IComponent extends IElement {
  IComponent.named() : super.named();
}

class IProperty implements IElement {
  IProperty.named() : super();
}

main() {
  print('IComponent:');
  IComponent.named();
  print('IProperty:');
  IProperty.named();
}

// https://github.com/dart-lang/sdk/issues/9468