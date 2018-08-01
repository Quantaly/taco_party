import 'dart:async';
import 'dart:html';
import 'package:taco_party/taco_party.dart';

void main() {
  //print("${window.innerWidth} x ${window.innerHeight}");
  querySelector("#text").text = Uri.base.queryParameters["msg"];
  switch (Uri.base.queryParameters["type"]) {
    case "pokemon":
      print("Gotta catch 'em all!");
      spriteInfo = new PokemonSpriteInfo();
      break;
  }

  querySelector("body").style..color = spriteInfo.textColor
  ..backgroundColor = spriteInfo.backgroundColor;

  _fillCache().then((_) => querySelector("#loading-notice").remove());

  new AnimationHandler().start();
}

Future _fillCache() {
  var cacheHolder = querySelector("#cache-holder");
  return Future.wait(spriteInfo.cacheUrls.map((u) {
    var element = new ImageElement(src: u);
    cacheHolder.append(element);
    return element.onLoad.first;
  }));
}