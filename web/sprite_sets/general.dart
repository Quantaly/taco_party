import 'dart:html';
import 'dart:math' as math;

import 'default.dart';
import 'package:taco_party/taco_party.dart';

final DefaultSpriteInfo _def = DefaultSpriteInfo();
final math.Random _rand = math.Random();

class GeneralSpriteInfo implements SpriteInfo {
  final num maxHorzVelocity;
  final num minVertVelocity;
  final num maxVertVelocity;
  final num maxAngularVelocity;

  final List<ImageElement> images;
  int get nextIndex => _rand.nextInt(images.length);

  final Color textColor;
  final Color backgroundColor;

  int _maxWidth = 100;
  int get maxWidth => _maxWidth;
  int _maxHeight = 100;
  int get maxHeight => _maxHeight;

  final int numTacos;

  GeneralSpriteInfo(
      {this.maxHorzVelocity,
      this.minVertVelocity,
      this.maxVertVelocity,
      this.maxAngularVelocity,
      this.images,
      this.textColor,
      this.backgroundColor,
      this.numTacos}) {
    for (var image in images) {
      _updateDims(image);
      image.onLoad.listen((_) => _updateDims(image));
    }
  }

  void _updateDims(ImageElement el) {
    if (_maxWidth < el.width) _maxWidth = el.width;
    if (_maxHeight < el.height) _maxHeight = el.height;
  }
}
