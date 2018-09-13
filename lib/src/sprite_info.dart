import 'dart:html';
import 'dart:math' as math;

import '../taco_party.dart';

final math.Random _rand = math.Random();

abstract class SpriteInfo {
  num get maxHorzVelocity;
  num get minVertVelocity;
  num get maxVertVelocity; // pixels/frame @ 60Hz
  num get maxAngularVelocity; // radians/frame @ 60Hz

  Iterable<ImageElement> get images;
  int get nextIndex;

  Color get textColor;
  Color get backgroundColor;

  int get maxWidth;
  int get maxHeight;

  int get numTacos;
}

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

class PokemonSpriteInfo implements SpriteInfo {
  static const int numPokemon = 649; // gen 5

  final num maxHorzVelocity = 2.5;
  final num minVertVelocity = 4.2;
  final num maxVertVelocity = 8.7;
  final num maxAngularVelocity = toRadians(2.7);

  Iterable<ImageElement> get images sync* {
    for (int i = 1; i <= numPokemon; i++) {
      yield ImageElement(
          src:
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$i.png");
    }
  }

  int get nextIndex => _rand.nextInt(numPokemon);

  final Color textColor = const Color(0xdc, 0x14, 0x3c); // crimson
  final Color backgroundColor = const Color(0xff, 0xc0, 0xcb); // pink

  final int maxWidth = 151;
  final int maxHeight = 151;

  final int numTacos = 151;
}

class UmbreonSpriteInfo extends PokemonSpriteInfo {
  final List<ImageElement> images = [
    ImageElement(
        src:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/197.png"),
    ImageElement(
        src:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/197.png"),
  ];
  int get nextIndex => (_rand.nextDouble() < 0.1) ? 1 : 0;

  final Color textColor = const Color(0xff, 0xff, 0x00); // yellow
  final Color backgroundColor = const Color(0x80, 0x80, 0x80); // grey
}

num toRadians(num degrees) => degrees / 360 * 2 * math.pi;
num maxHalfDiagonal(SpriteInfo si) =>
    math.sqrt(si.maxHeight * si.maxHeight + si.maxWidth * si.maxWidth) / 2;
