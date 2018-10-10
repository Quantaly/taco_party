import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:web_audio';

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
InputElement soundCheckbox;
InputElement soundUrl;

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
    url.onChange.listen(updatePreview);
    remove.onClick.listen((_) => _images.remove(this));
  }

  void updatePreview([_]) => preview.src = url.value;

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
  ImageContainer addImage([_]) {
    var ret = ImageContainer();
    imageStage.append(Element.li()..append(ret.table));
    return ret;
  }

  addImage();

  querySelector("#btn-addimage").onClick.listen(addImage);
  var stageSpawner = AsyncStageSpawner("preview", "../stage.html");
  querySelector("#btn-preview").onClick.listen((_) => stageSpawner.spawnStage(
      jsonEncode(generateJson()["data"]), "&msg=Sample%20text"));
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

  void updateTextColor([_]) => title.style.color = textColor.value;
  textColor.onInput.listen(updateTextColor);

  void updateBackgroundColor([_]) {
    body.style.backgroundColor = backgroundColor.value;
    var rgb = hexToRgb(backgroundColor.value);
    var color = Color(rgb[0], rgb[1], rgb[2]);
    var l = color.l;
    var segmentColor =
        "hsl(${color.h}, ${(color.s * 100).round()}%, ${(((l > 0.7) ? (l - 0.2) : (l + 0.25)) * 100).round()}%)";
    for (var s in segments) {
      s.style.backgroundColor = segmentColor.toString();
    }
  }

  backgroundColor.onInput.listen(updateBackgroundColor);

  InputElement fileUpload = querySelector("#upload");
  fileUpload.onInput.listen((_) {
    var reader = FileReader();
    reader.readAsText(fileUpload.files.first);
    downloadLink.download = fileUpload.files.first.name;
    reader.onLoadEnd.first.then((_) {
      var fileData = jsonDecode(reader.result);
      if (fileData["class"] != "general") {
        window.alert("Invalid file.");
        return;
      }

      var data = fileData["data"];
      maxHorzVelocity.value = data["maxHorzVelocity"].toString();
      minVertVelocity.value = data["minVertVelocity"].toString();
      maxVertVelocity.value = data["maxVertVelocity"].toString();
      maxAngularVelocity.value = data["maxAngularVelocity"].toString();
      name.value = data["name"];
      textColor.value = rgbToHex(data["textColor"].cast<int>());
      backgroundColor.value = rgbToHex(data["backgroundColor"].cast<int>());
      numTacos.value = data["numTacos"].toString();
      if (data["soundUrl"] != null) {
        soundCheckbox.checked = true;
        soundUrl.disabled = false;
        soundUrl.value = data["soundUrl"];
      } else {
        soundCheckbox.checked = false;
        soundUrl.disabled = true;
        soundUrl.value = "";
      }

      for (var image in _images) {
        image.remove.click();
      }

      for (var imageData in data["images"]) {
        var image = addImage()..url.value = imageData["src"];
        if (imageData["width"] != null)
          image.width.value = imageData["width"].toString();
        if (imageData["height"] != null)
          image.height.value = imageData["height"].toString();
        if (imageData["weight"] != null)
          image.weight.value = imageData["weight"].toString();
        image.updatePreview();
      }

      updateTextColor();
      updateBackgroundColor();
    });
  });

  AudioContext context;
  soundCheckbox.onInput.listen((_) {
    context ??= AudioContext();
    soundUrl.disabled = !soundCheckbox.checked;
  });
  soundUrl.disabled = !soundCheckbox.checked;
  soundUrl.onChange.listen((_) {
    context ??= AudioContext();
    var request = HttpRequest()
      ..open("GET", soundUrl.value, async: true)
      ..responseType = "arraybuffer";
    request.onLoad.first.then((_) async {
      context.createBufferSource()
        ..buffer = await context.decodeAudioData(request.response)
        ..connectNode(context.destination)
        ..start();
    });
    request.send();
  });
}

Map<String, dynamic> generateJson() {
  var ret = {
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
      "numTacos": int.parse(numTacos.value),
    }
  };
  if (soundCheckbox.checked) ret["soundUrl"] = soundUrl.value;
  return ret;
}

void setupInputElements() {
  name = querySelector("#name");
  maxHorzVelocity = querySelector("#maxHorzVelocity");
  minVertVelocity = querySelector("#minVertVelocity");
  maxVertVelocity = querySelector("#maxVertVelocity");
  maxAngularVelocity = querySelector("#maxAngularVelocity");
  textColor = querySelector("#textColor");
  backgroundColor = querySelector("#backgroundColor");
  numTacos = querySelector("#numTacos");
  soundCheckbox = querySelector("#soundCheckbox");
  soundUrl = querySelector("#soundUrl");
}

List<int> hexToRgb(String hexCode) => [
      int.parse(hexCode.substring(1, 3), radix: 16),
      int.parse(hexCode.substring(3, 5), radix: 16),
      int.parse(hexCode.substring(5, 7), radix: 16),
    ];

String rgbToHex(List<int> rgb) => "#${rgb[0].toRadixString(16).padLeft(2, "0")}"
    "${rgb[1].toRadixString(16).padLeft(2, "0")}"
    "${rgb[2].toRadixString(16).padLeft(2, "0")}";
