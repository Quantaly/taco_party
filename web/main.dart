import 'dart:async';
import 'dart:html';
import 'package:taco_party/taco_party.dart';

final _frameTime = 16;
num _lastTime = 0;

void main() {
  CanvasElement canvas = document.getElementById("stage");
  var context = canvas.context2D;
  print("${canvas.contentEdge.width} x ${canvas.contentEdge.height}");
  var taco =
      Taco(500.0, 350.0, 0.0, 0.0, 0.0, 2.5, querySelector("#mockimage"));

  void doTheThing([num delta = 0]) {
    if (delta - _lastTime > _frameTime) {
      _lastTime = delta;
      context
        ..setFillColorRgb(255, 255, 255)
        ..fillRect(0, 0, 1000, 700);
      taco
        ..advance()
        ..render(context);
    }
    window.animationFrame.then(doTheThing);
  }

  doTheThing();

  return;
  //print("${window.innerWidth} x ${window.innerHeight}");
  querySelector("#text").text = Uri.base.queryParameters["msg"];
  switch (Uri.base.queryParameters["type"]) {
    case "pokemon":
      print("Gotta catch 'em all!");
      spriteInfo = PokemonSpriteInfo();
      break;
    case "umbreon":
      print("Happy borthday, daddy-o."); // my dad's favorite 'mon
      spriteInfo = UmbreonSpriteInfo();
      break;
  }

  querySelector("body").style
    ..color = spriteInfo.textColor
    ..backgroundColor = spriteInfo.backgroundColor;

  _fillCache().then((_) => querySelector("#loading-notice").remove());

  AnimationHandler().start();
}

Future _fillCache() {
  var cacheHolder = querySelector("#cache-holder");
  return Future.wait(spriteInfo.cacheUrls.map((u) {
    var element = ImageElement(src: u);
    cacheHolder.append(element);
    return element.onLoad.first;
  }));
}
