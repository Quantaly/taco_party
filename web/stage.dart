import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:taco_party/taco_party.dart';

import 'sprite_sets/default.dart';
import 'sprite_sets/sprite_sets.dart';

void main() async {
  //window.onMessage.listen((m) => print("${m.origin} ${m.type} ${m.data}"));
  var name = Uri.base.queryParameters["type"];
  SpriteInfo spriteInfo = DefaultSpriteInfo();
  if (name != null) {
    var request = await HttpRequest.request("sprite_sets/$name.json");
    if (request.status == 200) {
      var object = jsonDecode(request.responseText);
      var maybeInfo = getSpriteSet(
          object["class"], object["data"], Uri.base.queryParameters);
      if (maybeInfo is Future) {
        spriteInfo = await maybeInfo;
      } else {
        spriteInfo = maybeInfo;
      }
    } else {
      window.alert("Bad type parameter");
    }
  }

  //print(Uri.base.queryParameters["data"]);

  querySelector("title").innerHtml = "Taco Party | ${spriteInfo.name}";

  var body = querySelector("body");
  body.style
    ..color = spriteInfo.textColor.toString()
    ..backgroundColor = spriteInfo.backgroundColor.toString();
  switch (Uri.base.queryParameters["filter"]) {
    case "invert":
      body.style.filter = "invert(1)";
      break;
    case "rainbow":
      body.classes.add("rainbow");
      break;
  }

  AnimationHandler(querySelector("#stage"), spriteInfo).start().then(
      (_) => querySelector("#text").text = Uri.base.queryParameters["msg"]);
}
