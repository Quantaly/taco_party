import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:taco_party/taco_party.dart';

import 'async_stage_spawner.dart';

List<ImageContainer> _images = [];

InputElement name;
InputElement maxHorzVelocity;
InputElement minVertVelocity;
InputElement maxVertVelocity;
InputElement maxAngularVelocity;
InputElement textColor;
InputElement backgroundColor;
InputElement numTacos;

class ImageContainer {
  final InputElement url;
  final InputElement width;
  final InputElement height;
  final InputElement weight;
  final InputElement remove;
  final ImageElement preview;

  ImageContainer()
      : url = InputElement()..type = "url",
        width = InputElement()
          ..type = "number"
          ..min = "1"
          ..classes.add("smol"),
        height = InputElement()
          ..type = "number"
          ..min = "1"
          ..classes.add("smol"),
        weight = InputElement()
          ..type = "number"
          ..min = "1"
          ..classes.add("smol"),
        remove = InputElement()
          ..type = "button"
          ..value = "Remove",
        preview = ImageElement() {
    _images.add(this);
    url.onChange.listen((_) => preview.src = url.value);
    remove.onClick.listen((_) => _images.remove(this));
  }

  TableElement get table {
    var ret = TableElement();
    var row1 = ret.addRow();
    row1.addCell()
      ..colSpan = 2
      ..appendText("URL: ")
      ..append(url);
    row1.addCell()
      ..rowSpan = 3
      ..append(preview);
    var row2 = ret.addRow();
    row2.addCell()
      ..appendText("Width: ")
      ..append(width);
    row2.addCell()
      ..appendText("Height: ")
      ..append(height);
    var row3 = ret.addRow();
    row3.addCell()
      ..appendText("Weight: ")
      ..append(weight);
    row3.addCell().append(remove);
    remove.onClick.listen((_) => ret.remove());
    return ret;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> ret = {"src": url.value};
    if (width.value.isNotEmpty) ret["width"] = num.parse(width.value);
    if (height.value.isNotEmpty) ret["height"] = num.parse(height.value);
    if (weight.value.isNotEmpty) ret["weight"] = int.parse(weight.value);
    return ret;
  }
}

void main() {
  //window.onMessage.listen((m) => print("${m.origin} ${m.type} ${m.data}"));
  setupInputElements();
  var imageStage = querySelector("#image-stage");
  void addImage([_]) =>
      imageStage.append(Element.li()..append(ImageContainer().table));
  addImage();

  querySelector("#btn-addimage").onClick.listen(addImage);
  var stageSpawner = AsyncStageSpawner("preview", "../stage.html");
  querySelector("#btn-preview").onClick.listen(
      (_) => stageSpawner.spawnStage(jsonEncode(generateJson()["data"])));
  querySelector("#btn-permalink").onClick.listen((_) => window.open(
      "../stage.html?type=inline&data=${Uri.encodeComponent(jsonEncode(generateJson()["data"]))}",
      "_blank"));
  var downloadLink = querySelector("#download-link") as AnchorElement;
  querySelector("#btn-download").onClick.listen((_) => downloadLink.href =
      "data:application/json;charset=utf-8,${Uri.encodeComponent(jsonEncode(generateJson()))}");

  var body = querySelector("body");
  var title = querySelector("h1");
  var segments = querySelectorAll(".segment");
  //print(segments.length);

  textColor.onInput.listen((_) => title.style.color = textColor.value);

  backgroundColor.onInput.listen((_) {
    body.style.backgroundColor = backgroundColor.value;
    var rgb = hexToRgb(backgroundColor.value);
    var color = Color(rgb[0], rgb[1], rgb[2]);
    var l = color.l;
    var segmentColor =
        "hsl(${color.h}, ${(color.s * 100).round()}%, ${(((l > 0.7) ? (l - 0.2) : (l + 0.25)) * 100).round()}%)";
    for (var s in segments) {
      s.style.backgroundColor = segmentColor.toString();
    }
  });
}

Map<String, dynamic> generateJson() => {
      "class": "general",
      "data": {
        "maxHorzVelocity": num.parse(maxHorzVelocity.value),
        "minVertVelocity": num.parse(minVertVelocity.value),
        "maxVertVelocity": num.parse(maxVertVelocity.value),
        "maxAngularVelocity": num.parse(maxAngularVelocity.value),
        "name": name.value,
        "images": _images.map((ic) => ic.toMap()).toList(growable: false),
        "textColor": hexToRgb(textColor.value),
        "backgroundColor": hexToRgb(backgroundColor.value),
        "numTacos": int.parse(numTacos.value)
      }
    };

void setupInputElements() {
  name = querySelector("#name");
  maxHorzVelocity = querySelector("#maxHorzVelocity");
  minVertVelocity = querySelector("#minVertVelocity");
  maxVertVelocity = querySelector("#maxVertVelocity");
  maxAngularVelocity = querySelector("#maxAngularVelocity");
  textColor = querySelector("#textColor");
  backgroundColor = querySelector("#backgroundColor");
  numTacos = querySelector("#numTacos");
}

List<int> hexToRgb(String hexCode) => [
      int.parse(hexCode.substring(1, 3), radix: 16),
      int.parse(hexCode.substring(3, 5), radix: 16),
      int.parse(hexCode.substring(5, 7), radix: 16),
    ];
