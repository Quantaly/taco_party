import 'dart:math' as math;

import '../sprite_set.dart';
import 'taco.dart';

abstract class RenderController {
  final SpriteSet spriteSet;

  RenderController(this.spriteSet);

  Future<void> load();
  void start();
  void stop();
  void render(Taco taco);

  int get canvasWidth;
  int get canvasHeight;
}
