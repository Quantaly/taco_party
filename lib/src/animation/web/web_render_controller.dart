import 'dart:async';
import 'dart:html';
import 'dart:math' as math;

import 'package:color/color.dart';

import 'package:taco_party/everything.g.dart';

class WebRenderController implements RenderController {
  final Element _imageContainer;
  final CanvasElement _canvas;
  final CanvasRenderingContext2D _context2d;
  final List<ImageElement> _images;
  final num _backgroundOpacity;

  @override
  final SpriteSet spriteSet;

  WebRenderController(this.spriteSet, this._imageContainer, this._canvas,
      [this._backgroundOpacity = 1])
      : _context2d = _canvas.context2D,
        _images = List(spriteSet.images.length);

  StreamSubscription<Event> _resizeSubscription;
  AnimationHandler _animationHandler;
  SoundController _soundController;

  RgbColor _backgroundColor;

  _Status _status = _Status.initial;

  /* */

  int _canvasHeight;
  @override
  int get canvasHeight => _canvasHeight;

  int _canvasWidth;
  @override
  int get canvasWidth => _canvasWidth;

  @override
  int maxImageHeight;
  @override
  int maxImageWidth;
  @override
  num maxImageHalfDiagonal;

  bool _soundReady;
  @override
  bool get soundReady => _soundReady;

  @override
  Future<void> load() async {
    switch (_status) {
      case _Status.initial:
        break;
      case _Status.loading:
      case _Status.loaded:
      case _Status.started:
        throw StateError("load() has already been called.");
      case _Status.stopped:
        throw StateError("stop() has been called.");
    }
    _status = _Status.loading;
    final futures = List<Future>(spriteSet.images.length);
    for (var i in range(spriteSet.images.length)) {
      final imageData = spriteSet.images[i];
      final image = ImageElement(
          src: imageData.src, width: imageData.width, height: imageData.height);
      _images[i] = image;
      futures[i] = image.onLoad.first;
      _imageContainer.append(image);
    }
    await Future.wait(futures);

    maxImageHeight = _images.fold(0, (a, b) => math.max(a, b.height));
    maxImageWidth = _images.fold(0, (a, b) => math.max(a, b.width));
    maxImageHalfDiagonal = math.sqrt(
            maxImageHeight * maxImageHeight + maxImageWidth * maxImageWidth) /
        2;

    _status = _Status.loaded;
  }

  @override
  void start() {
    switch (_status) {
      case _Status.initial:
        throw StateError("Call load() and wait for it to complete first.");
      case _Status.loading:
        throw StateError("Wait for load() to complete first.");
      case _Status.loaded:
        break;
      case _Status.started:
        throw StateError("start() has already been called.");
      case _Status.stopped:
        throw StateError("stop() has been called.");
    }
    _status = _Status.started;
    _adjustCanvasSize();
    _resizeSubscription = window.onResize.listen(_adjustCanvasSize);
    _animationHandler = AnimationHandler(this)..setUp();
    _backgroundColor = spriteSet.backgroundColor.toRgbColor();
    _runFrame(0);

    if (spriteSet.soundUrl != null) {
      _soundController = WebSoundController(spriteSet.soundUrl)
        ..load().then((success) {
          _soundReady = success;
        }).catchError((_) {});
    }
  }

  void _adjustCanvasSize([_]) {
    final width = window.innerWidth, height = window.innerHeight;
    _canvas
      ..width = width
      ..height = height;
    _canvasWidth = width;
    _canvasHeight = height;
  }

  num _lastFrame = 0;
  void _runFrame(num delta) {
    if (_status != _Status.started) return;
    if (delta - _lastFrame > animSpeed) {
      _lastFrame = delta;
      _context2d
        ..setFillColorRgb(_backgroundColor.r, _backgroundColor.g,
            _backgroundColor.b, _backgroundOpacity)
        ..fillRect(0, 0, canvasWidth, canvasHeight);
      _animationHandler.runFrame();
    }
    window.animationFrame.then(_runFrame);
  }

  @override
  void stop() {
    if (_status == _Status.stopped) throw StateError("Already stopped.");
    _status = _Status.stopped;
    _resizeSubscription?.cancel();
    _animationHandler?.tearDown();
    _soundReady = false;
    _soundController?.stop();
  }

  @override
  void render(Taco taco) {
    final image = _images[taco.imageIndex];
    _context2d
      ..save()
      ..translate(taco.x, taco.y)
      ..rotate(taco.angle)
      ..drawImageScaled(image, -image.width ~/ 2, -image.height ~/ 2,
          image.width, image.height)
      // draw cool box around image - for debugging purposes, of course
      /*..setStrokeColorRgb(255, 0, 0)
      ..beginPath()
      ..ellipse(0, 0, 5, 5, 0, 0, 2 * math.pi, false)
      ..stroke()
      ..strokeRect(
          -image.width / 2, -image.height / 2, image.width, image.height)
      ..closePath()
      ..beginPath()
      ..moveTo(-image.width / 2, -image.height / 2)
      ..lineTo(image.width / 2, image.height / 2)
      ..stroke()
      ..closePath()
      ..beginPath()
      ..moveTo(image.width / 2, -image.height / 2)
      ..lineTo(-image.width / 2, image.height / 2)
      ..stroke()
      ..closePath()
      ..restore()
      ..save()
      ..scale(3, 3)
      ..strokeText("x: ${x.round()}    y: ${y.round()}", 10, 10)*/
      ..restore();
  }

  @override
  void startSound() {
    if (!soundReady) throw StateError("soundReady must be true.");
    _soundReady = false;
    _soundController.start();
    _soundController.playSound();
    _animationHandler.tacoCreationStream.listen(_soundController.playSound);
  }
}

enum _Status {
  initial,
  loading,
  loaded,
  started,
  stopped,
}
