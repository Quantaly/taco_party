import 'dart:convert';
import 'dart:html' hide Location;
import 'dart:math' as math;

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:color/color.dart';

import 'package:taco_party/everything.g.dart';

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

  bool _soundEnabled = false;
  bool get soundEnabled => _soundEnabled;
  set soundEnabled(bool isEnabled) {
    _soundEnabled = isEnabled;
    if (!isEnabled) {
      soundUrl = "";
    }
  }

  String soundUrl;

  bool _fontEnabled = false;
  bool get fontEnabled => _fontEnabled;
  set fontEnabled(bool isEnabled) {
    _fontEnabled = isEnabled;
    if (!isEnabled) {
      font = "";
      fontImport = false;
    }
  }

  String font;
  bool fontImport;

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

    fontEnabled = values.font != null;
    font = values.font?.name ?? "";
    fontImport = values.font?.googleFontsImport ?? false;
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

  Map<String, Object> jsonify() => {
        "maxHorzVelocity": maxHorzVelocity,
        "minVertVelocity": minVertVelocity,
        "maxVertVelocity": maxVertVelocity,
        "maxAngularVelocity": maxAngularVelocity,
        "name": name,
        "images": [
          for (var img in images)
            {
              "src": img.src,
              if (img.width != null) "width": img.width,
              if (img.height != null) "height": img.height,
              if (img.weight != null) "weight": img.weight,
            }
        ],
        "textColor": textColor,
        "backgroundColor": backgroundColor,
        "numTacos": numTacos,
        if (soundEnabled) "soundUrl": soundUrl,
        if (fontEnabled)
          "font": {
            "name": font,
            "googleFontsImport": fontImport,
          },
      };

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
