import 'dart:async';
import 'dart:math' as math;

import 'package:taco_party/everything.g.dart';

const animSpeed = 1000 ~/ 60; // ms between frames
// hilariously enough, it turns out that Chrome (at least) fires animation
// frames at 60 fps anyway.

class AnimationHandler {
  static final _rand = math.Random();

  final RenderController _renderController;
  final List<Taco> _tacos;
  final num _maxHalfDiagonal;

  final List<int> imageWeightMap;

  // for sound
  final StreamController<Taco> _tacoCreation = StreamController();
  Stream<Taco> get tacoCreationStream => _tacoCreation.stream;

  AnimationHandler(this._renderController)
      : _tacos = List(_renderController.spriteSet.numTacos),
        _maxHalfDiagonal = _renderController.maxImageHalfDiagonal, // cache
        imageWeightMap = _makeWeightMap(_renderController.spriteSet.images);

  static List<int> _makeWeightMap(List<SpriteSetImageData> images) {
    final ret = <int>[];
    for (int i = 0; i < images.length; i++) {
      ret.addAll(_returnCount(images[i].weight ?? 1, i));
    }
    return ret;
  }

  static Iterable<T> _returnCount<T>(int count, T thing) sync* {
    for (var _ in range(count)) {
      yield thing;
    }
  }

  int randomImageIndex() =>
      imageWeightMap[_rand.nextInt(imageWeightMap.length)];

  void setUp() {
    for (var i in range(_tacos.length)) {
      _tacos[i] = newTaco();
    }
  }

  void runFrame() {
    for (var i in range(_tacos.length)) {
      final t = _tacos[i]..advance();
      if (t.y - _maxHalfDiagonal > _renderController.canvasHeight) {
        _tacos[i] = newTaco();
        _tacoCreation.add(_tacos[i]); // t is still the now-dead one
      }
      _renderController.render(t);
    }
  }

  Taco newTaco() => Taco.random(_renderController.canvasWidth,
      -_maxHalfDiagonal, randomImageIndex(), _renderController.spriteSet);

  void tearDown() {
    _tacoCreation.close();
  }
}
