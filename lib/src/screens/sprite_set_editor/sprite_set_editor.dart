import 'dart:convert';
import 'dart:html' hide Location;
import 'dart:math' as math;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:color/color.dart';

import '../../data_repr/sprite_set.dart';
import '../../routing.dart';
import '../../services/bundle_reader_service.dart';
import '../../services/page_meta_service.dart';
import '../../tools/async_stage_spawner.dart';
import '../../tools/color_utils.dart';
import '../../tools/string_base64.dart';
import '../../tools/url_json.dart';

@Component(
  selector: "tp-screens-spriteseteditor",
  templateUrl: "sprite_set_editor.html",
  styleUrls: ["sprite_set_editor.css"],
  directives: [
    coreDirectives,
    formDirectives,
  ],
)
class SpriteSetEditorScreenComponent implements OnInit, OnDestroy {
  final BundleReaderService _bundleReader;
  final PageMetaService _pageMeta;
  final Location _location;
  SpriteSetEditorScreenComponent(
      this._bundleReader, this._pageMeta, this._location);

  num maxHorzVelocity;
  num minVertVelocity;
  num maxVertVelocity;
  num maxAngularVelocity;

  String name;

  List<SpriteSetImageData> images;

  String textColor;
  String _backgroundColor;
  String get backgroundColor => _backgroundColor;

  String _foregroundColor;
  String get foregroundColor => _foregroundColor;
  set backgroundColor(String color) {
    _backgroundColor = color;
    _pageMeta.backgroundColor = color;
    _foregroundColor = augmentColor(HexColor(color.substring(1))).toCssString();
  }

  int numTacos;

  bool _soundEnabled;
  bool get soundEnabled => _soundEnabled;
  set soundEnabled(bool isEnabled) {
    _soundEnabled = isEnabled;
    if (!isEnabled) {
      soundUrl = "";
    }
  }

  String soundUrl;

  AsyncStageSpawner _previewSpawner;

  @override
  void ngOnInit() {
    _pageMeta.title = "Taco Party | Sprite Set Editor";
    copySpriteSet(SpriteSet.defaultSpriteSet);
    images = [SpriteSetImageData()];
    _previewSpawner = AsyncStageSpawner("preview",
        _location.prepareExternalUrl(Routes.stageLink("internal", "async")))
      ..init();
  }

  void copySpriteSet(SpriteSet values) {
    maxHorzVelocity = values.maxHorzVelocity;
    minVertVelocity = values.minVertVelocity;
    maxVertVelocity = values.maxVertVelocity;
    maxAngularVelocity = values.maxAngularVelocity / 2 / math.pi * 360;
    name = values.name;
    images = List.from(values.images);
    textColor = values.textColor.toHexColor().toCssString();
    backgroundColor = values.backgroundColor.toHexColor().toCssString();
    numTacos = values.numTacos;
    soundEnabled = values.soundUrl != "" && values.soundUrl != null;
    soundUrl = values.soundUrl ?? "";
  }

  void addImage() {
    images.add(SpriteSetImageData());
  }

  void processJsonImport(File inputFile) async {
    final reader = FileReader();
    reader.readAsText(inputFile);
    await reader.onLoadEnd.first;
    try {
      copySpriteSet(SpriteSet.fromJson(jsonDecode(reader.result)));
    } on Object {
      window.alert("Invalid file.");
    }
  }

  void processLinkImport(String link) async {
    var split = link.split("/");
    if (split.length < 3) return;
    split = split.sublist(split.length - 3);
    if (split[0] != "stage") return;
    try {
      copySpriteSet(await _bundleReader.getSpriteSet(
          normalizeBundleIdentifier(split[1]), split[2]));
    } on Object {}
  }

  Map<String, Object> jsonify() {
    final jsonMap = <String, Object>{
      "maxHorzVelocity": maxHorzVelocity,
      "minVertVelocity": minVertVelocity,
      "maxVertVelocity": maxVertVelocity,
      "maxAngularVelocity": maxAngularVelocity,
      "name": name,
      "images": images.map((img) {
        final jsonMap = <String, Object>{"src": img.src};
        if (img.width != null) {
          jsonMap["width"] = img.width;
        }
        if (img.height != null) {
          jsonMap["height"] = img.height;
        }
        if (img.weight != null) {
          jsonMap["weight"] = img.weight;
        }
        return jsonMap;
      }).toList(),
      "textColor": textColor,
      "backgroundColor": backgroundColor,
      "numTacos": numTacos,
    };
    if (soundEnabled) {
      jsonMap["soundUrl"] = soundUrl;
    }
    return jsonMap;
  }

  void preview() {
    _previewSpawner.spawnStage(jsonEncode(jsonify()), "?msg=Sample%20text");
  }

  void getPermalink() {
    final link = Routes.stageLink("permalink", urlJson.encode(jsonify()));
    window.open(_location.prepareExternalUrl(link), "_blank");
  }

  static const StringBase64Encoder _base64encoder = StringBase64Encoder();
  void downloadJson(AnchorElement downloadLink) {
    final dataUrl = "data:application/json;charset=utf-8;base64,"
        // can't use urlJson bcuz that compresses it
        "${_base64encoder.encode(jsonEncode(jsonify()))}";

    // bluh i hate doing it like this.
    downloadLink
      ..href = dataUrl
      ..click();
  }

  @override
  void ngOnDestroy() {
    _previewSpawner.stop();
  }

  // necessary because Angular expressions don't like casts
  static ImageElement castToImage(Element e) => e as ImageElement;
}
