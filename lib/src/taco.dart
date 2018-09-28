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
      // draw cool box around image
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
}
