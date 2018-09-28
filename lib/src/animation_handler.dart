import 'dart:async';
import 'dart:html';

import '../taco_party.dart';

const animSpeed = 16; // ms

class AnimationHandler {
  final List<Taco> _tacos;
  final CanvasElement _canvas;
  final SpriteInfo spriteInfo;

  num _lastFrame = 0;

  bool _started = false;
  List<ImageElement> images;

  AnimationHandler(this._canvas, SpriteInfo spriteInfo)
      : spriteInfo = spriteInfo,
        _tacos = List(spriteInfo.numTacos);

  Future<void> start() async {
    if (_started) throw StateError("The animation has already been started!");
    _started = true;

    adjustCanvasSize();

    var imageHolder = querySelector("#render-images");
    images = spriteInfo.images.toList(growable: false);
    await Future.wait(images.map((img) {
      imageHolder.append(img);
      return img.onLoad.first;
    }));

    for (var i = 0; i < _tacos.length; i++) {
      _tacos[i] = newTaco();
    }

    // resizeobservers appear to be borked
    //ResizeObserver((_, __) => adjustCanvasSize()).observe(querySelector("body"));
    window.addEventListener("resize", adjustCanvasSize);

    runFrame(0);
  }

  void updateAndRender() {
    var context = _canvas.context2D
      ..setFillColorRgb(spriteInfo.backgroundColor.r,
          spriteInfo.backgroundColor.g, spriteInfo.backgroundColor.b)
      ..fillRect(0, 0, _canvas.width, _canvas.height);
    for (var i = 0; i < _tacos.length; i++) {
      var t = _tacos[i]..advance();
      //print("t.y is ${t.y} and _canvas.height is ${_canvas.height}");
      if (t.y - spriteInfo.maxHalfDiagonal > _canvas.height) {
        _tacos[i] = newTaco();
        //print("new taco's image is ${_tacos[i].image}");
      }
      _tacos[i].render(context);
    }
  }

  void runFrame(num delta) {
    if (delta - _lastFrame > animSpeed) {
      _lastFrame = delta;
      updateAndRender();
    }
    window.animationFrame.then(runFrame);
  }

  void adjustCanvasSize([_]) {
    _canvas
      ..width = window.innerWidth
      ..height = window.innerHeight;
  }

  Taco newTaco() => Taco.random(_canvas.width, 0.0 - spriteInfo.maxHalfDiagonal,
      images[spriteInfo.nextIndex], spriteInfo);
}
