import 'dart:math' as math;

import 'package:color/color.dart';

import 'bundle.dart';
import 'errors.dart';

class SpriteSet {
  num maxHorzVelocity;
  num minVertVelocity;
  num maxVertVelocity;
  num maxAngularVelocity;

  String name;

  List<SpriteSetImageData> images;

  Color textColor;
  Color backgroundColor;

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
            .map(SpriteSetImageData.fromMap)
            .toList(growable: false),
        textColor: _parseColor(source["textColor"]),
        backgroundColor: _parseColor(source["backgroundColor"]),
        numTacos: source["numTacos"],
        soundUrl: source["soundUrl"],
        bundle: bundle,
      );

  static Color _parseColor(thing) {
    if (thing is List) {
      return RgbColor(thing[0], thing[1], thing[2]);
    } else if (thing is String) {
      if (thing.startsWith("#")) {
        return HexColor(thing.substring(1));
      } else {
        return RgbColor.namedColors[thing];
      }
    } else {
      throw ParseException("Bad color format");
    }
  }

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
          SpriteSetImageData(
            src:
                "https://openclipart.org/image/2400px/svg_to_png/151201/taco.png",
            width: 240,
            height: 216,
          ),
        ],
        name: "Tacos!",
        textColor: RgbColor.namedColors["purple"],
        backgroundColor: RgbColor.namedColors["yellow"],
        numTacos: 32,
      );
}

class SpriteSetImageData {
  String src;
  int width;
  int height;
  int weight;

  SpriteSetImageData({this.src, this.width, this.height, this.weight});

  static SpriteSetImageData fromMap(Map source) => SpriteSetImageData(
        src: source["src"],
        width: source["width"],
        height: source["height"],
        weight: source["weight"],
      );
}

num toRadians(num degrees) => degrees / 360 * 2 * math.pi;
