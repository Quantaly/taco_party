import 'dart:math' as math;
import 'dart:html';

import '../taco_party.dart';

class Taco {
  static final _rand = new math.Random();

  double x, y, angle;
  final double horzVelocity, vertVelocity, angularVelocity;
  final ImageElement element;

  int get width => element.width;
  int get height => element.height;

  Taco(this.x, this.y, this.angle, this.horzVelocity, this.vertVelocity,
      this.angularVelocity)
      : element = spriteInfo.makeElement()..classes.add("taco") {
    render();
  }
  Taco.random(num maxX, double y)
      : this(
            _rand.nextDouble() * maxX,
            y,
            _rand.nextDouble() * 360,
            _rand.nextDouble() * spriteInfo.maxHorzVelocity * (_rand.nextBool() ? 1 : -1),
            _rand.nextDouble() * (spriteInfo.maxVertVelocity - spriteInfo.minVertVelocity) +
                spriteInfo.minVertVelocity,
            _rand.nextDouble() *
                spriteInfo.maxAngularVelocity *
                (_rand.nextBool() ? 1 : -1));

  void advance() {
    x += horzVelocity;
    y += vertVelocity;
    angle += angularVelocity;
  }

  void render() {
    element.style
      ..top = "${y.floor()}px"
      ..left = "${x.floor()}px"
      ..transform = "rotate(${angle}deg)";
  }
}
