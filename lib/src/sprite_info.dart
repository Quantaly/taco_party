import 'dart:html';
import 'dart:math' as math;

SpriteInfo spriteInfo = new DefaultSpriteInfo();

abstract class SpriteInfo {
  num get maxHorzVelocity;
  num get minVertVelocity;
  num get maxVertVelocity; // pixels/frame @ 60Hz
  num get maxAngularVelocity; // degreees/frame @ 60Hz
  
  ImageElement makeElement();
  Iterable<String> get cacheUrls;

  String get textColor;
  String get backgroundColor;

  int get maxWidth;
  int get maxHeight;

  int get numTacos;
}

class DefaultSpriteInfo implements SpriteInfo {
  num get maxHorzVelocity => 4;
  num get minVertVelocity => 5;
  num get maxVertVelocity => 11;
  num get maxAngularVelocity => 4;
  
  ImageElement makeElement() => new ImageElement(src: "https://openclipart.org/image/2400px/svg_to_png/151201/taco.png", width: 240, height: 216);
  final List<String> cacheUrls = const ["https://openclipart.org/image/2400px/svg_to_png/151201/taco.png"];

  final String textColor = "purple";
  final String backgroundColor = "yellow";

  final int maxWidth = 240;
  final int maxHeight = 216;

  final int numTacos = 32;
}

class PokemonSpriteInfo implements SpriteInfo {
  static final math.Random _rand = new math.Random();
  static const int numPokemon = 649; // gen 5
  
  num get maxHorzVelocity => 2.5;
  num get minVertVelocity => 4;
  num get maxVertVelocity => 9;
  num get maxAngularVelocity => 3;
  
  ImageElement makeElement() => new ImageElement(src: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${_rand.nextInt(numPokemon) + 1}.png");
  Iterable<String> get cacheUrls sync* {
    for (int i=1; i <= numPokemon; i++) {
      yield "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$i.png";
    }
  }

  final String textColor = "crimson";
  final String backgroundColor = "pink";

  final int maxWidth = 151;
  final int maxHeight = 151;

  final int numTacos = 151;
}