import 'dart:async';
import 'dart:html';

import '../taco_party.dart';

class AnimationHandler {
  final List<Taco> _tacos = List(spriteInfo.numTacos);
  final Element _outputElement;
  Timer timer;

  AnimationHandler() : _outputElement = document.querySelector("#images");

  void start() {
    if (timer?.isActive ?? false) return;
    for (int i = 0; i < spriteInfo.numTacos; i++) _tacos[i] = newTaco();
    runFrame();
    timer = Timer.periodic(const Duration(milliseconds: 16), runFrame);
  }

  void runFrame([_]) {
    var windowHeight = window.innerHeight;
    for (int i = 0; i < _tacos.length; i++) {
      var t = _tacos[i];
      t.advance();
      if (t.y > windowHeight) {
        t.element.remove();
        _tacos[i] = newTaco();
      }
      _tacos[i].render();
    }
  }

  Taco newTaco() {
    var taco = Taco.random(
        window.innerWidth - spriteInfo.maxWidth, 0.0 - spriteInfo.maxHeight);
    _outputElement.append(taco.element);
    return taco;
  }
}
