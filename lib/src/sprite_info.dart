import 'dart:html';
import 'dart:math' as math;

import '../taco_party.dart';

abstract class SpriteInfo {
  num get maxHorzVelocity;
  num get minVertVelocity;
  num get maxVertVelocity; // pixels/frame @ 60Hz
  num get maxAngularVelocity; // radians/frame @ 60Hz

  String get name;

  Iterable<ImageElement> get images;
  int get nextIndex;

  Color get textColor;
  Color get backgroundColor;

  int get maxWidth;
  int get maxHeight;
  num get maxHalfDiagonal;

  int get numTacos;

  String get soundUrl;
}

num toRadians(num degrees) => degrees / 360 * 2 * math.pi;
num calcHalfDiagonal(num x, num y) => math.sqrt(x * x + y * y) / 2;
