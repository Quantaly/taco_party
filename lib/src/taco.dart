import 'dart:math' as math;
import 'dart:html';

class Taco {
  static const width = 240;
  static const height = 216;

  static final _rand = new math.Random();
  static const maxHorzVelocity = 4;
  static const minVertVelocity = 5;
  static const maxVertVelocity = 11; // pixels / frame @ 60fps
  static const maxAngularVelocity = 4; // degrees / frame @ 60fps

  double x, y, angle;
  final double horzVelocity, vertVelocity, angularVelocity;
  final ImageElement element;

  Taco(this.x, this.y, this.angle, this.horzVelocity, this.vertVelocity,
      this.angularVelocity)
      : element = new ImageElement(
            src:
                "https://openclipart.org/image/2400px/svg_to_png/151201/taco.png",
            width: width,
            height: height) {
    element.classes.add("taco");
    render();
  }
  Taco.random(num maxX, double y)
      : this(
            _rand.nextDouble() * maxX,
            y,
            _rand.nextDouble() * 360,
            _rand.nextDouble() * maxHorzVelocity * (_rand.nextBool() ? 1 : -1),
            _rand.nextDouble() * (maxVertVelocity - minVertVelocity) + minVertVelocity,
            _rand.nextDouble() * maxAngularVelocity * (_rand.nextBool() ? 1 : -1));

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
