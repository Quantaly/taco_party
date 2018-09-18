import 'dart:html';

import 'default.dart';
import 'pokemon.dart';
import 'general.dart';

import 'package:taco_party/taco_party.dart';

SpriteInfo getSpriteSet(
    String name, dynamic data, Map<String, String> queryParameters) {
  switch (name) {
    case "pokemon":
      return PokemonSpriteInfo();
    case "general":
      if (data is Map) {
        return GeneralSpriteInfo(
          maxHorzVelocity: data["maxHorzVelocity"],
          minVertVelocity: data["minVertVelocity"],
          maxVertVelocity: data["maxVertVelocity"],
          maxAngularVelocity: toRadians(data["maxAngularVelocity"]),
          images: List.from(data["images"].map((data) => ImageElement(
              src: data["src"], width: data["width"], height: data["height"]))),
          textColor: Color(
              data["textColor"][0], data["textColor"][1], data["textColor"][2]),
          backgroundColor: Color(data["backgroundColor"][0],
              data["backgroundColor"][1], data["backgroundColor"][2]),
          numTacos: data["numTacos"],
        );
      }
  }
  return DefaultSpriteInfo();
}
