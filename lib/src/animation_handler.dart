import 'dart:async';
import 'dart:html';

import 'package:taco_party/taco_party.dart';

class AnimationHandler {
  static const numTacos = 30;

  final List<Taco> _tacos = [];
  final Element _outputElement;
  Timer timer;

  AnimationHandler() : _outputElement = document.querySelector("body");

  void start() {
    if (timer?.isActive ?? false) return;
    for (int i=0; i<numTacos; i++) addTaco();
    runFrame();
    timer = new Timer.periodic(const Duration(milliseconds: 33), runFrame);
  }

  void runFrame([_]) {
    var windowHeight = window.innerHeight;
    for (var t in _tacos) {
      t.advance();
      if (t.y > windowHeight) {
        t.element.remove();
        new Future(() => _tacos.remove(t)); // do it async so there's no concurrent modification.
      } else t.render();
    }
    while (_tacos.length < numTacos) addTaco();
  }

  void addTaco() {
    var taco = new Taco.random(window.innerWidth - Taco.width, 0 - Taco.height);
    _outputElement.append(taco.element);
    _tacos.add(taco);
  }
}