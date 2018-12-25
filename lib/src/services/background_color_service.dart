import 'dart:html';

class BackgroundColorService {
  BodyElement _body;

  BackgroundColorService(this._body);

  set backgroundColor(String color) {
    _body.style.backgroundColor = color;
  }
}
