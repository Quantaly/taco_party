import 'dart:math' as math;

import 'bundle.dart';
import 'errors.dart';

class SpriteSet {
  num maxHorzVelocity;
  num minVertVelocity;
  num maxVertVelocity;
  num maxAngularVelocity;

  String name;

  List<ImageData> images;

  List<int> textColor;
  List<int> backgroundColor;

  int numTacos;

  String soundUrl;

  Bundle bundle;

  SpriteSet({
    this.maxHorzVelocity,
    this.minVertVelocity,
    this.maxVertVelocity,
    this.maxAngularVelocity,
    this.name,
    this.images,
    this.textColor,
    this.backgroundColor,
    this.numTacos,
    this.soundUrl,
    this.bundle,
  });

  static SpriteSet fromMap(Map source, [Bundle bundle]) =>
      _checkLegacy(source, bundle) ??
      SpriteSet(
        maxHorzVelocity: source["maxHorzVelocity"],
        minVertVelocity: source["minVertVelocity"],
        maxVertVelocity: source["maxVertVelocity"],
        maxAngularVelocity: toRadians(source["maxAngularVelocity"]),
        name: source["name"],
        images: (source["images"] as List)
            .cast<Map>()
            .map(ImageData.fromMap)
            .toList(growable: false),
        textColor: (source["textColor"] as List).cast(),
        backgroundColor: (source["backgroundColor"] as List).cast(),
        numTacos: source["numTacos"],
        soundUrl: source["soundUrl"],
        bundle: bundle,
      );

  // not sure what i'll do with this, but could be good to know.
  bool _isLegacy;
  bool get isLegacy => _isLegacy;
  static SpriteSet _checkLegacy(Map source, Bundle bundle) {
    if (source["class"] == "general") {
      return fromMap(source["data"], bundle).._isLegacy = true;
    } else if (source["class"] != null) {
      throw ParseException("Inconvertible legacy format");
    }
    return null;
  }

  static SpriteSet get defaultSpriteSet => SpriteSet(
        maxHorzVelocity: 4,
        minVertVelocity: 5,
        maxVertVelocity: 10.3,
        maxAngularVelocity: toRadians(3),
        images: [
          ImageData(
            src:
                "https://openclipart.org/image/2400px/svg_to_png/151201/taco.png",
            width: 240,
            height: 216,
          ),
        ],
        name: "Tacos!",
        textColor: const [0x80, 0x00, 0x80], // purple
        backgroundColor: const [0xff, 0xff, 0x00], // yellow
        numTacos: 32,
      );
}

class ImageData {
  String src;
  int width;
  int height;
  int weight;

  ImageData({this.src, this.width, this.height, this.weight});

  static ImageData fromMap(Map source) => ImageData(
        src: source["src"],
        width: source["width"],
        height: source["height"],
        weight: source["weight"],
      );
}

num toRadians(num degrees) => degrees / 360 * 2 * math.pi;
