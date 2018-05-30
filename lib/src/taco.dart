import 'dart:math' as math;
import 'dart:html';

class Taco {
  static const width = 240;
  static const height = 216;

  static final _rand = new math.Random();
  static const maxHorzVelocity = 7;
  static const minVertVelocity = 10;
  static const maxVertVelocity = 25; // pixels / frame @ 30fps
  static const maxAngularVelocity = 9; // degrees / frame @ 30fps

  int x, y, angle = 0;
  final int horzVelocity, vertVelocity, angularVelocity;
  final ImageElement element;

  Taco(this.x, this.y, this.horzVelocity, this.vertVelocity, this.angularVelocity) :
        element = new ImageElement(src: "https://openclipart.org/image/2400px/svg_to_png/151201/taco.png", width: width, height: height) {
    element.classes.add("taco");
    render();
  }
  Taco.random(int maxX, int y) : this(_rand.nextInt(maxX), y,
      _rand.nextInt(maxHorzVelocity) * (_rand.nextBool() ? 1 : -1),
      _rand.nextInt(maxVertVelocity - minVertVelocity) + minVertVelocity,
      _rand.nextInt(maxAngularVelocity) * (_rand.nextBool() ? 1 : -1));

  void advance() {
    x += horzVelocity;
    y += vertVelocity;
    angle += angularVelocity;
  }

  void render() {
    element.style
      ..top = "${y}px"
      ..left = "${x}px"
      ..transform = "rotate(${angle}deg)";
  }
}