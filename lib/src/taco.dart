import 'dart:math' as math;
import 'dart:html';

import '../taco_party.dart';

class Taco {
  static final _rand = math.Random();

  double x, y, angle;
  final double horzVelocity, vertVelocity, angularVelocity;
  final ImageElement image;

  Taco(this.x, this.y, this.angle, this.horzVelocity, this.vertVelocity,
      this.angularVelocity, this.image);
  Taco.random(num maxX, double y, ImageElement image, SpriteInfo spriteInfo)
      : this(
            _rand.nextDouble() * maxX,
            y,
            _rand.nextDouble() * 2 * math.pi,
            _rand.nextDouble() *
                spriteInfo.maxHorzVelocity *
                (_rand.nextBool() ? 1 : -1),
            _rand.nextDouble() *
                    (spriteInfo.maxVertVelocity - spriteInfo.minVertVelocity) +
                spriteInfo.minVertVelocity,
            _rand.nextDouble() *
                spriteInfo.maxAngularVelocity *
                (_rand.nextBool() ? 1 : -1),
            image);

  void advance() {
    x += horzVelocity;
    y += vertVelocity;
    angle += angularVelocity;
  }

  void render(CanvasRenderingContext2D context) {
    context
      ..save()
      ..translate(x, y)
      ..rotate(angle)
      ..drawImageScaled(image, -image.width ~/ 2, -image.height ~/ 2,
          image.width, image.height)
      ..restore();
  }
}
