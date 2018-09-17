import 'default.dart';
import 'pokemon.dart';

import 'package:taco_party/taco_party.dart';

SpriteInfo getSpriteSet(String name, dynamic data, Map<String, String> queryParameters) {
  switch (name) {
    case "pokemon":
      return PokemonSpriteInfo();
    default:
      return DefaultSpriteInfo();
  }
}