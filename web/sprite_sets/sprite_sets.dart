import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'default.dart';
import 'pokemon.dart';
import 'general.dart';

import 'package:taco_party/taco_party.dart';

FutureOr<SpriteInfo> getSpriteSet(
    String className, dynamic data, Map<String, String> queryParameters) {
  switch (className) {
    case "pokemon":
      return PokemonSpriteInfo();
    case "general":
      if (data is Map) {
        return GeneralSpriteInfo(
          maxHorzVelocity: data["maxHorzVelocity"],
          minVertVelocity: data["minVertVelocity"],
          maxVertVelocity: data["maxVertVelocity"],
          maxAngularVelocity: toRadians(data["maxAngularVelocity"]),
          name: data["name"],
          images: List.from(
              data["images"].expand((data) => _expanded(
                  ImageElement(
                      src: data["src"],
                      width: data["width"],
                      height: data["height"]),
                  data["weight"] ?? 1)),
              growable: false),
          textColor: Color(
              data["textColor"][0], data["textColor"][1], data["textColor"][2]),
          backgroundColor: Color(data["backgroundColor"][0],
              data["backgroundColor"][1], data["backgroundColor"][2]),
          numTacos: data["numTacos"],
          soundUrl: data["soundUrl"],
        );
      }
      break;
    case "inline":
      return getSpriteSet(
          "general", jsonDecode(queryParameters["data"]), queryParameters);
    case "async":
      var text = querySelector("#text")..text = "Waiting...";
      return Future(() async {
        var message = await window.onMessage.first;
        (message.source as WindowBase).postMessage(window.name, window.origin);
        var result =
            getSpriteSet("general", jsonDecode(message.data), queryParameters);
        text.text = "Loading...";
        return result;
      });
  }
  return DefaultSpriteInfo();
}

Iterable<T> _expanded<T>(T value, int times) sync* {
  for (var i = 0; i < times; i++) {
    yield value;
  }
}
