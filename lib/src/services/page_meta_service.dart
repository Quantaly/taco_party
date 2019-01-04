import 'dart:html';

class PageMetaService {
  BodyElement _body;
  TitleElement _title;

  PageMetaService(this._body, this._title);

  set backgroundColor(String color) {
    _body.style.backgroundColor = color;
  }

  set title(String title) {
    _title.innerHtml = title;
  }
}
