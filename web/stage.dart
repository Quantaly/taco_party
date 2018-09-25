import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:taco_party/taco_party.dart';

import 'sprite_sets/default.dart';
import 'sprite_sets/sprite_sets.dart';

void main() async {
  var name = Uri.base.queryParameters["type"];
  SpriteInfo spriteInfo = DefaultSpriteInfo();
  if (name != null) {
    var request = await HttpRequest.request("sprite_sets/$name.json");
    if (request.status == 200) {
      var object = jsonDecode(request.responseText);
      spriteInfo = getSpriteSet(
          object["class"], object["data"], Uri.base.queryParameters);
    }
  }

  querySelector("title").innerHtml = "Taco Party | ${spriteInfo.name}";

  querySelector("body").style
    ..color = spriteInfo.textColor.toString()
    ..backgroundColor = spriteInfo.backgroundColor.toString();

  AnimationHandler(querySelector("#stage"), spriteInfo).start().then(
      (_) => querySelector("#text").text = Uri.base.queryParameters["msg"]);
}
