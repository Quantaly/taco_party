import 'dart:async';
import 'dart:html';

import 'package:taco_party/taco_party.dart';

class AnimationHandler {
  static const numTacos = 32;

  final List<Taco> _tacos = new List(numTacos);
  final Element _outputElement;
  Timer timer;

  AnimationHandler() : _outputElement = document.querySelector("body");

  void start() {
    if (timer?.isActive ?? false) return;
    for (int i = 0; i < numTacos; i++) _tacos[i] = newTaco();
    runFrame();
    timer = new Timer.periodic(const Duration(milliseconds: 16), runFrame);
  }

  void runFrame([_]) {
    var windowHeight = window.innerHeight;
    for (int i = 0; i < numTacos; i++) {
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
    var taco = new Taco.random(window.innerWidth - Taco.width, 0.0 - Taco.height);
    _outputElement.append(taco.element);
    return taco;
  }
}
