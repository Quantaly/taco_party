import 'dart:math' as math;

import 'package:taco_party/everything.g.dart';

class Taco {
  static final _rand = math.Random();

  double x, y, angle;
  final double horzVelocity, vertVelocity, angularVelocity;
  final int imageIndex;

  Taco(this.x, this.y, this.angle, this.horzVelocity, this.vertVelocity,
      this.angularVelocity, this.imageIndex);
  Taco.random(num maxX, double y, int imageIndex, SpriteSet spriteSet)
      : this(
            _rand.nextDouble() * maxX,
            y,
            _rand.nextDouble() * 2 * math.pi,
            _rand.nextDouble() *
                spriteSet.maxHorzVelocity *
                (_rand.nextBool() ? 1 : -1),
            _rand.nextDouble() *
                    (spriteSet.maxVertVelocity - spriteSet.minVertVelocity) +
                spriteSet.minVertVelocity,
            _rand.nextDouble() *
                spriteSet.maxAngularVelocity *
                (_rand.nextBool() ? 1 : -1),
            imageIndex);

  void advance() {
    x += horzVelocity;
    y += vertVelocity;
    angle += angularVelocity;
  }
}
