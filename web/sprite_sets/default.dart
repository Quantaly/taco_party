import 'dart:html';

import 'package:taco_party/taco_party.dart';

class DefaultSpriteInfo implements SpriteInfo {
  final num maxHorzVelocity = 4;
  final num minVertVelocity = 5;
  final num maxVertVelocity = 10.3;
  final num maxAngularVelocity = toRadians(3);

  final List<ImageElement> images = [
    ImageElement(
        src: "https://openclipart.org/image/2400px/svg_to_png/151201/taco.png",
        width: 240,
        height: 216)
  ];
  final int nextIndex = 0;

  final Color textColor = const Color(0x80, 0x00, 0x80); // purple
  final Color backgroundColor = const Color(0xff, 0xff, 0x00); // yellow

  final int maxWidth = 240;
  final int maxHeight = 216;

  final int numTacos = 32;
}
