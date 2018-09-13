import 'dart:async';
import 'dart:html';
import 'package:taco_party/taco_party.dart';

void main() {
  SpriteInfo spriteInfo = DefaultSpriteInfo();
  switch (Uri.base.queryParameters["type"]) {
    case "pokemon":
      print("Gotta catch 'em all!");
      spriteInfo = PokemonSpriteInfo();
      break;
    case "umbreon":
      print("Happy borthday, daddy-o."); // my dad's favorite 'mon
      spriteInfo = UmbreonSpriteInfo();
      break;
  }

  querySelector("body").style
    ..color = spriteInfo.textColor.toString()
    ..backgroundColor = spriteInfo.backgroundColor.toString();

  AnimationHandler(querySelector("#stage"), spriteInfo).start().then(
      (_) => querySelector("#text").text = Uri.base.queryParameters["msg"]);
}
