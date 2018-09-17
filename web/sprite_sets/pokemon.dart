import 'dart:html';
import 'dart:math' as math;

import 'package:taco_party/taco_party.dart';

final math.Random _rand = math.Random();

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