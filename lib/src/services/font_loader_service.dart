import 'dart:async';
import 'dart:html';

class FontLoaderService {
  final HeadElement _head;

  final Set<String> _loadedFonts = {"Sarabun"};

  FontLoaderService(this._head);

  Future<void> loadFont(String fontName) {
    if (_loadedFonts.contains(fontName)) return Future.value();
    final link = LinkElement()
      ..rel="stylesheet"
      ..href = "https://fonts.googleapis.com/css?family="
          "${fontName.replaceAll(" ", "+")}&display=swap";
    _head.append(link);
    _loadedFonts.add(fontName);
    
    final ret = Completer();
    link.onLoad.first.then(ret.complete);
    link.onError.first.then(ret.completeError);
    return ret.future;
  }
}
